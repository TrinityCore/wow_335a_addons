--[[
	Auctioneer
	Version: 5.7.4568 (KillerKoala)
	Revision: $Id: CoreBuy.lua 4553 2009-12-02 21:22:13Z Nechckn $
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds statistical history to the auction data that is collected
	when the auction is scanned, so that you can easily determine what price
	you will be able to sell an item for at auction or at a vendor whenever you
	mouse-over an item in the game

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
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]

--[[
	Auctioneer Purchasing Engine.

	This code helps modules that need to purchase things to do so in an extremely easy and
	queueable fashion.
]]
if not AucAdvanced then return end

if (not AucAdvanced.Buy) then AucAdvanced.Buy = {} end

local lib = AucAdvanced.Buy
local private = {}
lib.Private = private

local print,decode,_,_,replicate,_,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()
local Const = AucAdvanced.Const
local empty = table.wipe
lib.Print = print
local highlight = "|cffff7f3f"

private.BuyRequests = {}
private.PendingBids = {}
private.Searching = false
private.lastPrompt = false
private.lastQueue = 0
function private.QueueReport()
	local queuelen = #private.BuyRequests
	local prompt = private.Prompt:IsShown()
	if queuelen ~= private.lastQueue or prompt ~= private.lastPrompt then
		private.lastQueue = queuelen
		private.lastPrompt = prompt
		AucAdvanced.SendProcessorMessage("buyqueue", prompt and queuelen+1 or queuelen) -- quick'n'dirty "queue count"
	end
end
function private.QueueInsert(request, pos)
	if pos and pos <= #private.BuyRequests then
		tinsert(private.BuyRequests, pos, request)
	else
		tinsert(private.BuyRequests, request)
	end
	private.QueueReport()
end
function private.QueueRemove(index)
	if private.BuyRequests[index] then
		local removed = tremove(private.BuyRequests, index)
		private.QueueReport()
		return removed
	end
end

--[[
	GetQueueStatus returns:
	number of items in queue
	total cost of items in queue
	string showing link and number of items if Prompt is open, false/nil otherwise [todo: confirm which]
	cost of item(s) in Prompt, or 0 if closed
--]]
function lib.GetQueueStatus()
	local queuelen = #private.BuyRequests
	local queuecost = 0
	for i, request in ipairs(private.BuyRequests) do
		queuecost = queuecost + request.price
	end
	local prompt = private.Prompt:IsShown() and private.CurAuction.count.."x "..private.CurAuction.link
	local promptcost = prompt and private.CurAuction.price or 0

	return queuelen, queuecost, prompt, promptcost
end

--[[
	Securely clears the Buy Request queue
	if prompt is true, cancels the Buy Prompt (without sending a "bidcancelled" message)
--]]
function lib.CancelBuyQueue(prompt)

	if prompt and private.Prompt:IsShown() then
		private.Searching = false
		private.CurAuction = nil
		private.Prompt:Hide()
		AucAdvanced.Scan.SetPaused(false)
	end

	empty(private.BuyRequests)

	private.QueueReport()
end

--[[
	to add an auction to the Queue:
	AucAdvanced.Buy.QueueBuy(link, seller, count, minbid, buyout, price)
	price = price to pay
	AucAdv will buy the first auction it sees fitting the specifics at price.
	If item cannot be found in current scandata, entry is removed.
]]
function lib.QueueBuy(link, seller, count, minbid, buyout, price, reason)
	local canbuy, problem = lib.CanBuy(price, seller)
	if not canbuy then
		print("AucAdv: Can't buy "..link.." : "..problem)
		return
	end
	link = AucAdvanced.SanitizeLink(link)
	if buyout > 0 and price > buyout then
		price = buyout
	end
	if get("ShowPurchaseDebug") then
		if buyout > 0 and price >= buyout then
			print("AucAdv: Queueing Buyout of "..link.." from seller "..tostring(seller).." for "..AucAdvanced.Coins(price))
		else
			print("AucAdv: Queueing Bid of "..link.." from seller "..tostring(seller).." for "..AucAdvanced.Coins(price))
		end
	end
	private.QueueInsert({link = link, sellername=seller, count=count, minbid=minbid, buyout=buyout, price=price, reason = reason})
	lib.ScanPage()
end

--[[
	This function will return false, reason if an auction by seller at price cannot be bought
	Else it will return true.
	Note that this will not catch all, but if it says you can't, you can't
]]
function lib.CanBuy(price, seller)
	if not price or price == 0 then
		return false, "no price given"
	elseif GetMoney() < price then
		return false, "not enough money"
	elseif seller and AucAdvancedConfig["users."..GetRealmName().."."..seller] then
		return false, "own auction"
	end
	return true
end

function private.PushSearch()
	local nextRequest = private.BuyRequests[1]
	local link = nextRequest["link"]
	local canbuy, reason = lib.CanBuy(nextRequest["price"], nextRequest["sellername"])
	if not canbuy then
		print("AucAdv: Can't buy "..link.." : "..reason)
		private.QueueRemove(1)
		return
	end

	local _, name, rarity, minlevel, itemType, itemSubType, stack, TypeID, SubTypeID
	name, _, rarity, _, minlevel, itemType, itemSubType, stack = GetItemInfo(link)
	nextRequest["itemname"] = name
	for catId, catName in pairs(AucAdvanced.Const.CLASSES) do
		if catName == itemType then
			TypeID = catId
			for subId, subName in pairs(AucAdvanced.Const.SUBCLASSES[TypeID]) do
				if subName == itemSubType then
					SubTypeID = subId
					break
				end
			end
			break
		end
	end
	AucAdvanced.Scan.PushScan()
	private.Searching = true
	AucAdvanced.Scan.StartScan(name, minlevel, minlevel, nil, TypeID, SubTypeID, nil, rarity)
end

function lib.FinishedSearch(query)
	local queuecount = #private.BuyRequests
	if queuecount > 0 then
		local queryname = query.name
		local querylevel = query.minUseLevel
		local queryquality = query.quality
		for i = queuecount, 1, -1 do
			local BuyRequest = private.BuyRequests[i]
			local itemname = BuyRequest.itemname
			if itemname == queryname then
				-- additional checks
				local link = BuyRequest.link
				local _, _, rarity, _, minlevel = GetItemInfo(link)
				if minlevel == 0 then
					minlevel = nil
				end
				if rarity == 0 then
					rarity = nil
				end
				if rarity == queryquality and minlevel == querylevel then
					print("AucAdv: Auction for "..link.." no longer exists")
					private.QueueRemove(i)
				end
			end
		end
	end
	private.Searching = false
end

function private.PromptPurchase(thisAuction)
	if type(thisAuction.price) ~= "number" then
		AucAdvanced.Print(highlight.."Cancelling bid: invalid price: "..type(thisAuction.price)..":"..tostring(thisAuction.price))
		return
	elseif type(thisAuction.index) ~= "number" then
		AucAdvanced.Print(highlight.."Cancelling bid: invalid index: "..type(thisAuction.index)..":"..tostring(thisAuction.index))
		return
	end
	private.CurAuction = thisAuction
	AucAdvanced.Scan.SetPaused(true)
	private.Prompt:Show()
	if (private.CurAuction["price"] < private.CurAuction["buyout"]) or (private.CurAuction["buyout"] == 0) then
		private.Prompt.Text:SetText("Are you sure you want to bid on")
	else
		private.Prompt.Text:SetText("Are you sure you want to buyout")
	end
	if private.CurAuction["count"] == 1 then
		private.Prompt.Value:SetText(private.CurAuction["link"].." for "..AucAdvanced.Coins(private.CurAuction["price"],true).."?")
	else
		private.Prompt.Value:SetText(private.CurAuction["count"].."x "..private.CurAuction["link"].." for "..AucAdvanced.Coins(private.CurAuction["price"],true).."?")
	end
	private.Prompt.Item.tex:SetTexture(private.CurAuction["texture"])
	private.Prompt.Reason:SetText(private.CurAuction["reason"] or "")
	local width = private.Prompt.Value:GetStringWidth() or 0
	private.Prompt.Frame:SetWidth(math.max((width + 70), 400))
	private.QueueReport()
end

function private.HidePrompt()
	private.Prompt:Hide()
	private.CurAuction = nil
	private.QueueReport()
	AucAdvanced.Scan.SetPaused(false)
end

function lib.ScanPage(startat)
	if #private.BuyRequests == 0 then return end
	if private.Prompt:IsVisible() then return end
	local batch = GetNumAuctionItems("list")
	if startat and startat < batch then
		batch = startat
	end
	for i = batch, 1, -1 do
		local link = GetAuctionItemLink("list", i)
		link = AucAdvanced.SanitizeLink(link)
		for j = #private.BuyRequests, 1, -1 do -- must check in reverse order as there are table removes inside the loop
			local BuyRequest = private.BuyRequests[j]
			if link == BuyRequest["link"] then
				local price = BuyRequest["price"]
				local buy = BuyRequest["buyout"]
				local name, texture, count, _, _, _, minBid, minIncrement, buyout, curBid, ishigh, owner = GetAuctionItemInfo("list", i)
				if ishigh and ((not buy) or (buy <= 0) or (price < buy)) then
					print("Unable to bid on "..link..". Already highest bidder")
					private.QueueRemove(j)
				else
					local brSeller = BuyRequest.sellername
					if ((not owner) or (not brSeller) or (brSeller == "") or (owner == brSeller))
					and (count == BuyRequest["count"])
					and (minBid == BuyRequest["minbid"])
					and (buyout == BuyRequest["buyout"]) then --found the auction we were looking for
						if (BuyRequest["price"] >= (curBid + minIncrement)) or (BuyRequest["price"] >= buyout) then
							BuyRequest.index = i
							BuyRequest.texture = texture
							private.QueueRemove(j)
							private.PromptPurchase(BuyRequest)
							return
						else
							print(highlight.."Unable to bid on "..link..". Price invalid")
							private.QueueRemove(j)
						end
					end
				end
			end
		end
	end
end

--Cancels the current auction
--Also sends out a Callback with a callback string of "<link>;<price>"
function private.CancelPurchase()
	private.Searching = false
	local CallBackString = string.join(";", tostring(private.CurAuction["link"]), tostring(private.CurAuction["price"]), tostring(private.CurAuction["count"]))
	AucAdvanced.SendProcessorMessage("bidcancelled", CallBackString)
	private.HidePrompt()
	--scan the page again for other auctions
	lib.ScanPage()
end

function private.PerformPurchase()
	if not private.CurAuction then return end
	private.Searching = false
	--first, do some Sanity Checking
	local index = private.CurAuction["index"]
	local price = private.CurAuction["price"]
	if type(price)~="number" then
		AucAdvanced.Print(highlight.."Cancelling bid: invalid price: "..type(price)..":"..tostring(price))
		private.HidePrompt()
		return
	elseif type(index) ~= "number" then
		AucAdvanced.Print(highlight.."Cancelling bid: invalid index: "..type(index)..":"..tostring(index))
		private.HidePrompt()
		return
	end
	local link = GetAuctionItemLink("list", index)
	link = AucAdvanced.SanitizeLink(link)
	local name, texture, count, _, _, _, minBid, minIncrement, buyout, curBid, ishigh, owner = GetAuctionItemInfo("list", index)

	if (private.CurAuction["link"] ~= link) then
		AucAdvanced.Print(highlight.."Cancelling bid: "..tostring(index).." not found")
		private.HidePrompt()
		return
	elseif (price < minBid) then
		AucAdvanced.Print(highlight.."Cancelling bid: Bid below minimum bid: "..AucAdvanced.Coins(price))
		private.HidePrompt()
		return
	elseif (curBid and curBid > 0 and price < curBid + minIncrement and price < buyout) then
		AucAdvanced.Print(highlight.."Cancelling bid: Already higher bidder")
		private.HidePrompt()
		return
	end
	if get("ShowPurchaseDebug") then
		if buyout > 0 and price >= buyout then
			print("AucAdv: Buying out "..link.." for "..AucAdvanced.Coins(price))
		else
			print("AucAdv: Bidding on "..link.." for "..AucAdvanced.Coins(price))
		end
	end

	PlaceAuctionBid("list", index, price)

	private.CurAuction["reason"] = private.Prompt.Reason:GetText()
	--Add bid to list of bids we're watching for
	local pendingBid = replicate(private.CurAuction)
	tinsert(private.PendingBids, pendingBid)
	--register for the Response events if this is the first pending bid
	if (#private.PendingBids == 1) then
		Stubby.RegisterEventHook("CHAT_MSG_SYSTEM", "AucAdv_CoreBuy", private.onEventHookBid)
		Stubby.RegisterEventHook("UI_ERROR_MESSAGE", "AucAdv_CoreBuy", private.onEventHookBid)
	end

	--get ready for next bid action
	private.HidePrompt()
	lib.ScanPage(index-1)--check the page for any more auctions
end

function private.removePendingBid()
	if (#private.PendingBids > 0) then
		tremove(private.PendingBids, 1)

		--Unregister events if no more bids pending
		if (#private.PendingBids == 0) then
			Stubby.UnregisterEventHook("CHAT_MSG_SYSTEM", "AucAdv_CoreBuy", private.onEventHookBid)
			Stubby.UnregisterEventHook("UI_ERROR_MESSAGE", "AucAdv_CoreBuy", private.onEventHookBid)
		end
	end
end

function private.onEventHookBid(_, event, arg1)
	if (event == "CHAT_MSG_SYSTEM" and arg1) then
		if (arg1 == ERR_AUCTION_BID_PLACED) then
		 	private.onBidAccepted()
		end
	elseif (event == "UI_ERROR_MESSAGE" and arg1) then
		if (arg1 == ERR_ITEM_NOT_FOUND or
			arg1 == ERR_NOT_ENOUGH_MONEY or
			arg1 == ERR_AUCTION_BID_OWN or
			arg1 == ERR_AUCTION_HIGHER_BID or
			arg1 == ERR_AUCTION_BID_INCREMENT or
			arg1 == ERR_AUCTION_MIN_BID or
			arg1 == ERR_ITEM_MAX_COUNT) then
			private.onBidFailed(arg1)
		end
	end
end

function private.onBidAccepted()
	--"itemlink;seller;count;buyout;price;reason"
	local bid = private.PendingBids[1]
	local CallBackString = strjoin(";", tostringall(bid.link, bid.sellername, bid.count, bid.buyout, bid.price, bid.reason))
	AucAdvanced.SendProcessorMessage("bidplaced", CallBackString)
	private.removePendingBid()
end

--private.onBidFailed(arg1)
--This function is called when a bid fails
--purpose is to output to chat the reason for the failure, and then pass the Bid on to private.removePendingBid()
--The output may duplicate some client output.  If so, those lines need to be removed.
function private.onBidFailed(arg1)
	print(highlight.."Bid Failed: "..arg1)
	private.removePendingBid()
end

function private.OnUpdate()
	if AuctionFrame and AuctionFrame:IsVisible() then
		if (not private.Prompt:IsShown()) --if we have a prompt, we don't need to look any more
			and (not private.Searching)
			and (#private.BuyRequests > 0) then
				private.PushSearch()
		end
	elseif private.CurAuction then --AH was closed, so reinsert current request back into the queue
		private.Prompt:Hide()
		private.QueueInsert(private.CurAuction, 1)
		private.Searching = false
		private.CurAuction = nil
		AucAdvanced.Scan.SetPaused(false)
	else
		private.Searching = false
	end
end

--[[
    Our frames for feeding event functions
]]

function private.OnEvent(...)
	if (event == "AUCTION_ITEM_LIST_UPDATE") then
		lib.ScanPage()
	end
end

function private.ShowTooltip()
	GameTooltip:SetOwner(AuctionFrameCloseButton, "ANCHOR_NONE")
	GameTooltip:SetHyperlink(private.CurAuction["link"])
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPRIGHT", private.Prompt.Item, "TOPLEFT", -10, -20)
end

function private.HideTooltip()
	GameTooltip:Hide()
end

-- Simple timer to keep actions up-to-date even if an event misfires
private.updateFrame = CreateFrame("frame", nil, UIParent)
private.updateFrame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
private.updateFrame:SetScript("OnUpdate", private.OnUpdate)
private.updateFrame:SetScript("OnEvent", private.OnEvent)

--this is a anchor frame that never changes size
private.Prompt = CreateFrame("frame", "AucAdvancedBuyPrompt", UIParent)
private.Prompt:Hide()
private.Prompt:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -400, -100)
private.Prompt:SetFrameStrata("DIALOG")
private.Prompt:SetHeight(120)
private.Prompt:SetWidth(400)
private.Prompt:SetMovable(true)
private.Prompt:SetClampedToScreen(true)

--The "graphic" frame and backdrop that we resize. Only thing anchored to it is the item Box
private.Prompt.Frame = CreateFrame("frame", nil, private.Prompt)
private.Prompt.Frame:SetPoint("CENTER",private.Prompt, "CENTER" )
local level = private.Prompt:GetFrameLevel()
private.Prompt.Frame:SetFrameLevel(level - 1)
private.Prompt.Frame:SetHeight(120)
private.Prompt.Frame:SetWidth(400)
private.Prompt.Frame:SetClampedToScreen(true)
private.Prompt.Frame:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 9, right = 9, top = 9, bottom = 9 }
})
private.Prompt.Frame:SetBackdropColor(0,0,0,0.8)

private.Prompt.Item = CreateFrame("Button", "AucAdvancedBuyPromptItem", private.Prompt)
private.Prompt.Item:SetNormalTexture("Interface\\Buttons\\UI-Slot-Background")
private.Prompt.Item:GetNormalTexture():SetTexCoord(0,0.640625, 0, 0.640625)
private.Prompt.Item:SetPoint("TOPLEFT", private.Prompt.Frame, "TOPLEFT", 15, -15)
private.Prompt.Item:SetHeight(37)
private.Prompt.Item:SetWidth(37)
private.Prompt.Item:SetScript("OnEnter", private.ShowTooltip)
private.Prompt.Item:SetScript("OnLeave", private.HideTooltip)
private.Prompt.Item.tex = private.Prompt.Item:CreateTexture(nil, "OVERLAY")
private.Prompt.Item.tex:SetPoint("TOPLEFT", private.Prompt.Item, "TOPLEFT", 0, 0)
private.Prompt.Item.tex:SetPoint("BOTTOMRIGHT", private.Prompt.Item, "BOTTOMRIGHT", 0, 0)

private.Prompt.Text = private.Prompt:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
private.Prompt.Text:SetPoint("TOPLEFT", private.Prompt, "TOPLEFT", 52, -20)
private.Prompt.Text:SetPoint("TOPRIGHT", private.Prompt, "TOPRIGHT", -15, -20)
private.Prompt.Text:SetJustifyH("CENTER")

private.Prompt.Value = private.Prompt:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
private.Prompt.Value:SetPoint("CENTER", private.Prompt.Frame, "CENTER", 20, 15)

private.Prompt.Reason = CreateFrame("EditBox", "AucAdvancedBuyPromptReason", private.Prompt, "InputBoxTemplate")
private.Prompt.Reason:SetPoint("TOPLEFT", private.Prompt, "TOPLEFT", 150, -55)
private.Prompt.Reason:SetPoint("TOPRIGHT", private.Prompt, "TOPRIGHT", -30, -55)
private.Prompt.Reason:SetHeight(20)
private.Prompt.Reason:SetAutoFocus(false)
private.Prompt.Reason:SetScript("OnEnterPressed", function()
	private.Prompt.Reason:ClearFocus()
	end)
private.Prompt.Reason:SetText("")

private.Prompt.Reason.Label = private.Prompt.Reason:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
private.Prompt.Reason.Label:SetPoint("TOPRIGHT", private.Prompt.Reason, "TOPLEFT", 0, 0)
private.Prompt.Reason.Label:SetPoint("TOPLEFT", private.Prompt, "TOPLEFT", 52, -55)
private.Prompt.Reason.Label:SetText("Reason:")
private.Prompt.Reason.Label:SetHeight(15)

private.Prompt.Yes = CreateFrame("Button", "AucAdvancedBuyPromptYes", private.Prompt, "OptionsButtonTemplate")
private.Prompt.Yes:SetText("Yes")
private.Prompt.Yes:SetPoint("BOTTOMRIGHT", private.Prompt, "BOTTOMRIGHT", -10, 10)
private.Prompt.Yes:SetScript("OnClick", private.PerformPurchase)

private.Prompt.No = CreateFrame("Button", "AucAdvancedBuyPromptNo", private.Prompt, "OptionsButtonTemplate")
private.Prompt.No:SetText("Cancel")
private.Prompt.No:SetPoint("BOTTOMRIGHT", private.Prompt.Yes, "BOTTOMLEFT", -60, 0)
private.Prompt.No:SetScript("OnClick", private.CancelPurchase)

private.Prompt.DragTop = CreateFrame("Button", nil, private.Prompt)
private.Prompt.DragTop:SetPoint("TOPLEFT", private.Prompt, "TOPLEFT", 10, -5)
private.Prompt.DragTop:SetPoint("TOPRIGHT", private.Prompt, "TOPRIGHT", -10, -5)
private.Prompt.DragTop:SetHeight(6)
private.Prompt.DragTop:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
private.Prompt.DragTop:SetScript("OnMouseDown", function() private.Prompt:StartMoving() end)
private.Prompt.DragTop:SetScript("OnMouseUp", function() private.Prompt:StopMovingOrSizing() end)

private.Prompt.DragBottom = CreateFrame("Button", nil, private.Prompt)
private.Prompt.DragBottom:SetPoint("BOTTOMLEFT", private.Prompt, "BOTTOMLEFT", 10, 5)
private.Prompt.DragBottom:SetPoint("BOTTOMRIGHT", private.Prompt, "BOTTOMRIGHT", -10, 5)
private.Prompt.DragBottom:SetHeight(6)
private.Prompt.DragBottom:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
private.Prompt.DragBottom:SetScript("OnMouseDown", function() private.Prompt:StartMoving() end)
private.Prompt.DragBottom:SetScript("OnMouseUp", function() private.Prompt:StopMovingOrSizing() end)

AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/5.7/Auc-Advanced/CoreBuy.lua $", "$Rev: 4553 $")
