--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: 5.7.4568 (KillerKoala)
	Revision: $Id: BeanCounter.lua 4553 2009-12-02 21:22:13Z Nechckn $

	BeanCounterCore - BeanCounter: Auction House History
	URL: http://auctioneeraddon.com/

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
LibStub("LibRevision"):Set("$URL: http://svn.norganna.org/auctioneer/branches/5.7/BeanCounter/BeanCounter.lua $","$Rev: 4553 $","5.1.DEV.", 'auctioneer', 'libs')

--AucAdvanced.Modules["Util"]["BeanCounter"]

local select,ipairs,pairs=select,ipairs,pairs
local concat=table.concat
local tonumber,tostring,strsplit,strjoin=tonumber,tostring,strsplit,strjoin
local tinsert,tremove = tinsert,tremove

local libName = "BeanCounter"
local libType = "Util"
local lib
BeanCounter={}
lib = BeanCounter
lib.API = {}
local private = {
	--BeanCounterCore
	playerName = UnitName("player"),
	realmName = GetRealmName(),
	AucModule, --registers as an auctioneer module if present and stores module local functions
	faction = nil,
	version = 2.12,
	wealth, --This characters current net worth. This will be appended to each transaction.
	compressed = false,

	playerData, --Alias for BeanCounterDB[private.realmName][private.playerName]
	serverData, --Alias for BeanCounterDB[private.realmName]
	DBSumEntry = 0,
	DBSumItems = 0,
	--BeanCounter Bids/posts
	PendingBids = {},
	PendingPosts = {},

	--BeanCounterMail
	reconcilePending = {},
	inboxStart = {},
	serverVersion = select(4, GetBuildInfo()),--WOW 3.0 HACK
}

local tooltip = LibStub("nTipHelper:1")
private.tooltip = tooltip

lib.Private = private --allow beancounter's sub lua's access
--Taken from AucAdvCore
function BeanCounter.Print(...)
	local output, part
	for i=1, select("#", ...) do
		part = select(i, ...)
		part = tostring(part):gsub("{{", "|cffddeeff"):gsub("}}", "|r")
		if (output) then output = output .. " " .. part
		else output = part end
	end
	DEFAULT_CHAT_FRAME:AddMessage(output, 0.3, 0.9, 0.8)
end

local print = BeanCounter.Print

local function debugPrint(...)
    if lib.GetSetting("util.beancounter.debugCore") then
        private.debugPrint("BeanCounterCore",...)
    end
end

--used to allow beancounter to recive Processor events from Auctioneer. Allows us to send a search request to BC GUI
if AucAdvanced and AucAdvanced.NewModule then
	private.AucModule = AucAdvanced.NewModule(libType, libName) --register as an Adv Module for callbacks
	local get, set, default = select(7, AucAdvanced.GetModuleLocals()) --Get locals for use getting settings
	private.AucModule.locals = {["get"] = get, ["set"] = set, ["default"] = default}

	function private.AucModule.Processor(callbackType, ...)
		if (callbackType == "querysent") and lib.API.isLoaded then --if BeanCounter has disabled itself dont try looking for auction House links
			local item = ...
			if item.name then
				if item.name ~= "" then
					lib.API.search(item.name)
				end
			end
		elseif (callbackType == "bidplaced") and lib.API.isLoaded then
			private.storeReasonForBid(...)
		end
	end
end

lib.API.isLoaded = false
function lib.OnLoad(addon)
	private.initializeDB() --create or initialize the saved DB
	 --OK we now have our Database ready, lets create an Alias to make refrencing easier
	local db = BeanCounterDB
	private.playerData = db[private.realmName][private.playerName]
	private.serverData = db[private.realmName]
	private.wealth = private.playerData["wealth"]
	--Upgrade DB if needed
	private.UpgradeDatabaseVersion()
	--Check if user is trying to use old client with newer database or if the database has failed to update
	if private.version and private.playerData.version then
		if private.version < private.playerData.version then
			private.CreateErrorFrames("bean older", private.version, private.playerData.version)
			return
		elseif private.version ~= private.playerData.version then
			private.CreateErrorFrames("failed update", private.version, private.playerData.version)
			return
		end
	end
	--Continue loading if the Database is ready
	lib.MakeGuiConfig() --create the configurator GUI frame
	private.CreateFrames() --create our framework used for AH and GUI
	private.createDeleteItemPrompt() --create the item delete prompt
	private.slidebar() --create slidebar icon

	private.scriptframe:RegisterEvent("PLAYER_MONEY")
	private.scriptframe:RegisterEvent("PLAYER_ENTERING_WORLD")
	private.scriptframe:RegisterEvent("MAIL_INBOX_UPDATE")
	private.scriptframe:RegisterEvent("UI_ERROR_MESSAGE")
	private.scriptframe:RegisterEvent("MAIL_SHOW")
	private.scriptframe:RegisterEvent("MAIL_CLOSED")
	private.scriptframe:RegisterEvent("UPDATE_PENDING_MAIL")
	private.scriptframe:RegisterEvent("MERCHANT_SHOW")
	private.scriptframe:RegisterEvent("MERCHANT_UPDATE")
	private.scriptframe:RegisterEvent("MERCHANT_CLOSED")

	private.scriptframe:SetScript("OnUpdate", private.onUpdate)

	-- Hook all the methods we need
	Stubby.RegisterAddOnHook("Blizzard_AuctionUi", "BeanCounter", private.AuctionUI) --To be standalone we cannot depend on AucAdv for lib.Processor
	--mail
	Stubby.RegisterFunctionHook("TakeInboxMoney", -100, private.PreTakeInboxMoneyHook);
	Stubby.RegisterFunctionHook("TakeInboxItem", -100, private.PreTakeInboxItemHook);
	--Bids
	Stubby.RegisterFunctionHook("PlaceAuctionBid", 50, private.postPlaceAuctionBidHook)
	--Posting
	Stubby.RegisterFunctionHook("StartAuction", -50, private.preStartAuctionHook)
	--Vendor
	--hooksecurefunc("BuyMerchantItem", private.merchantBuy)
	
	tooltip:Activate()
	tooltip:AddCallback(private.processTooltip, 700)

	lib.API.isLoaded = true
end

--Create the database
--server and player are passed by upgrade code when we need to reset a toons DB
function private.initializeDB(server, player)
	if not server then server = private.realmName end
	if not player then player = private.playerName end
	
	local db = BeanCounterDB
	if not db then
		db = {}
		BeanCounterDB  = db
		db["settings"] = {}
		db["ItemIDArray"] = {}
	end
	
	if not db[server] then
		db[server] = {}
	end
	
	if not db[server][player] then
		local playerData = {}
		db[server][player] = playerData
		
		playerData["version"] = private.version
		playerData["faction"] = "unknown" --faction is recorded when we get the login event
		playerData["wealth"] = GetMoney()

		playerData["vendorbuy"] = {}
		playerData["vendorsell"] = {}

		playerData["postedAuctions"] = {}
		playerData["completedAuctions"] = {}
		playerData["failedAuctions"] = {}

		playerData["postedBids"] = {}
		playerData["completedBidsBuyouts"]  = {}
		playerData["failedBids"]  = {}
		
		playerData["completedAuctionsNeutral"] = {}
		playerData["failedAuctionsNeutral"] = {}

		playerData["completedBidsBuyoutsNeutral"]  = {}
		playerData["failedBidsNeutral"]  = {}

		playerData["mailbox"] = {}
	end
end

--[[ Configator Section ]]--
--See BeanCounterConfig.lua
--sets sub luas print, get, set, localization and any future locals
function lib.getLocals()
	return lib.Private, lib.Print, lib.GetSetting, lib.SetSetting, private.localizations
end

--[[Sidebar Section]]--
local sideIcon
function private.slidebar()
	if LibStub then
		local SlideBar = LibStub:GetLibrary("SlideBar", true)
		if SlideBar then
			sideIcon = SlideBar.AddButton("BeanCounter", "Interface\\AddOns\\BeanCounter\\Textures\\BeanCounterIcon")
			sideIcon:RegisterForClicks("LeftButtonUp","RightButtonUp")
			sideIcon:SetScript("OnClick", private.GUI)
			sideIcon.tip = {
				"BeanCounter",
				"BeanCounter tracks your trading activities so that you may review your expenditures and income, perform searches and use this data to determine your successes and failures.",
				"{{Click}} to view your activity report.",
				"{{Right-Click}} to edit the configuration.",
			}
		end
	end
end

--[[ Local functions ]]--
function private.onUpdate()
	private.mailonUpdate()
end

function private.onEvent(frame, event, arg, ...)
	if (event == "PLAYER_MONEY") then
		private.wealth = GetMoney()
		private.playerData["wealth"] = private.wealth

	elseif (event == "PLAYER_ENTERING_WORLD") then --used to record one time info when player loads
		private.scriptframe:UnregisterEvent("PLAYER_ENTERING_WORLD") --no longer care about this event after we get our current wealth
		private.wealth = GetMoney()
		private.playerData["wealth"] = private.wealth

	elseif (event == "MAIL_INBOX_UPDATE") or (event == "MAIL_SHOW") or (event == "MAIL_CLOSED") then
		private.mailMonitor(event, arg, ...)

	elseif (event == "MERCHANT_CLOSED") or (event == "MERCHANT_SHOW") or (event == "MERCHANT_UPDATE") then
			--private.vendorOnevent(event, arg, ...)

	elseif (event == "UPDATE_PENDING_MAIL") then
		private.hasUnreadMail()
		--we also use this event to get faction data since the faction often returns nil if called after "PLAYER_ENTERING_WORLD"
		private.faction = UnitFactionGroup(UnitName("player"))
		private.playerData["faction"] =  private.faction or "unknown"

	elseif (event == "ADDON_LOADED") then
		if arg == "BeanCounter" then
		   lib.OnLoad()
		   private.scriptframe:UnregisterEvent("ADDON_LOADED")
		end
	end
end


--[[ Utility Functions]]--
--External Search Stub, allows other addons searches to search to display in BC or get results of a BC search
--Can be item Name or link or itemID
--If itemID or link search will be much faster than a plain text lookup
function lib.externalSearch(name, settings, queryReturn, count)
	lib.ShowDeprecationAlert("Depreciated API Call Used", "")
	--print("|CFFFF3300 WARNING: |CFFFFFFFF A module just called a depreciated  Beancounter API")
	--print(" |CFFFF3300 BeanCounter.externalSearch() ")
	--print("Please update the module to use the function |CFFFFFF00 BeanCounter.API.search()  ")
	return lib.API.search(name, settings, queryReturn, count) or {}
end

--will return any length arguments into a ; seperated string
local tmp={}
function private.packString(...)
	local num = select("#", ...)
	for n = 1, num do
		local msg = select(n, ...)
		if msg == nil then
			msg = ""
		elseif msg == true then
			msg = "boolean true"
		elseif msg == false then
			msg = "boolean false"
		elseif msg == "0" then
			msg = ""
		elseif msg == "<nil>" then
			msg = ""
		end
		tmp[n] = msg
	end
	return concat(tmp,";",1,num)
end
--Will split any string and return a table value, replace gsub with tbl compare, slightly faster this way.
function private.unpackString(text)
	if not text then return end
	local stack,  money, deposit , fee, buyout , bid, buyer, Time, reason, location = strsplit(";", text)
	if stack == "" then stack = "0" end
	if money == "" then money = "0" end
	if deposit == "" then deposit = "0" end
	if fee == "" then fee = "0" end
	if buyout == "" then buyout = "0" end
	if bid == "" then bid = "0" end
	if buyer == "" then buyer = "0" end
	if Time == "" then Time = "0" end
	if reason == "" then reason = "0" end
	if location == "" then location = "0" end
	
	return stack, money, deposit , fee, buyout , bid, buyer, Time, reason, location
end
--[[
Adds data to the database in proper place, adds link to itemName array, optionally compresses the itemstring into compact format
return false if data fails to write
]]
function private.databaseAdd(key, itemLink, itemString, value, compress)
	--if we are passed a link and not both then extract the string
	if itemLink and not itemString then
		itemString = lib.API.getItemString(itemLink)
	end
	
	if not key or not itemString or not value then
		debugPrint("BeanCounter database add error: Missing required data") 
		debugPrint("Database:", key, "itemString:", itemString, "Value:", value, "compress:",compress)
		return false
	end

	local item, itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4, suffixID, uniqueID, linkLevel = strsplit(":", itemString)
	--if this will be a compressed entry replace uniqueID with 0 or its scaling factor
	if compress then
		suffixID = tonumber(suffixID)
		--print(itemString)
		if suffixID < 0 then --scaling factor built into uniqueID, extract it and store so we can create properly scaled itemLinks
			uniqueID = bit.band(uniqueID, 65535)
		--	print(uniqueID)
		else
			uniqueID = 0
		end
		itemString = strjoin(":", item, itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4, suffixID, uniqueID, linkLevel)
		--print(itemString)
	end
	
	if private.playerData[key][itemID] then --if ltemID exists
		if private.playerData[key][itemID][itemString] then
			tinsert(private.playerData[key][itemID][itemString], value)
		else
			private.playerData[key][itemID][itemString] = {value}
		end
	else
		private.playerData[key][itemID]={[itemString] = {value}}
	end
	--Insert into the ItemName:ItemID dictionary array
	if itemLink then
		lib.API.storeItemLinkToArray(itemLink)
	end
	return true
end

--remove item (for pending bids only atm)
function private.databaseRemove(key, itemID, itemLink, NAME, COUNT)
	if key == "postedBids" then
	local itemString = lib.API.getItemString(itemLink)
	local _, suffix = lib.API.decodeLink(itemLink)
		if private.playerData[key][itemID] and private.playerData[key][itemID][itemString] then
			for i, v in pairs(private.playerData[key][itemID][itemString]) do
				local postCount, postBid, postSeller, isBuyout, postTimeLeft, postTime, postReason = private.unpackString(v)
				if postSeller and itemID  and NAME then
					if postSeller == NAME and tonumber(postCount) == COUNT then
						--debugPrint("Removing entry from postedBids this is a match", itemID, NAME, "vs", postedName, postedCount, "vs",  COUNT)
						tremove(private.playerData[key][itemID][itemString], i)--Just remove the key
						break
					end
				end
			end
		end
	end
end

--Store reason Code for BTM/SearchUI
--tostring(bid["link"]), tostring(bid["sellername"]), tostring(bid["count"]), tostring(bid["buyout"]), tostring(bid["price"]), tostring(bid["reason"]))
function private.storeReasonForBid(CallBack)
	--debugPrint("bidplaced", CallBack)
	if not CallBack then return end
	
	local itemLink, seller, count, buyout, price, reason = strsplit(";", CallBack)
	local itemString = lib.API.getItemString(itemLink)
	local itemID, suffix = lib.API.decodeLink(itemLink)
	
	if private.playerData.postedBids[itemID] and private.playerData.postedBids[itemID][itemString] then
		for i, v in pairs(private.playerData.postedBids[itemID][itemString]) do
			local postCount, postBid, postSeller, isBuyout, postTimeLeft, postTime, postReason = private.unpackString(v)
			if postCount and postBid and itemID and price and count then
				if postCount == count and postBid == price then
					local text = private.packString(postCount, postBid, postSeller, isBuyout, postTimeLeft, postTime, reason)
						--debugPrint("before", private.playerData.postedBids[itemID][itemString][i])
						private.playerData.postedBids[itemID][itemString][i] = text
						--debugPrint("after", private.playerData.postedBids[itemID][itemString][i])
					break
				end
			end
		end
	end
end

--Get item Info or a specific subset. accepts itemID or "itemString" or "itemName ONLY IF THE ITEM IS IN PLAYERS BAG" or "itemLink"
function private.getItemInfo(link, cmd)
	--debugPrint(link, cmd)
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(link)
	if not cmd and itemLink then --return all
		return itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture

	elseif itemLink and (cmd == "itemid") then
		local itemID = lib.API.decodeLink(itemLink)
		return itemID, itemLink

	elseif itemName and itemTexture  and (cmd == "name") then
		return itemName, itemTexture

	elseif itemStackCount and (cmd == "stack") then
		return itemStackCount
	end
	return
end

function private.debugPrint(...)
	if lib.GetSetting("util.beancounter.debug") then
		print(...)
	end
end

--[[Bootstrap Code]]
private.scriptframe = CreateFrame("Frame")
private.scriptframe:RegisterEvent("ADDON_LOADED")
private.scriptframe:SetScript("OnEvent", private.onEvent)
