--[[
	Auctioneer - Price Level Utility module
	Version: 5.7.4568 (KillerKoala)
	Revision: $Id: Undercut.lua 4496 2009-10-08 22:15:46Z Nechckn $
	URL: http://auctioneeraddon.com/

	This is an Auctioneer Matcher module that returns an undercut price
	based on the current market snapshot

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
if not AucAdvanced then return end

local libType, libName = "Match", "Undercut"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end

local print,decode,_,_,replicate,empty,get,set,default,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()
local floor,min,max,ceil = floor,min,max,ceil
local tonumber,tostring,next = tonumber,tostring,next


local pricecache --only used for tooltip info, as that's the only place where we know that the starting price will remain the same

function lib.Processor(callbackType, ...)
	if (callbackType == "tooltip") then
		--Called when the tooltip is being drawn.
		private.ProcessTooltip(...)
	elseif (callbackType == "config") then
		--Called when you should build your Configator tab.
		private.SetupConfigGui(...)
	elseif (callbackType == "listupdate") then
		--Called when the AH Browse screen receives an update.
	elseif (callbackType == "configchanged") then
		--Called when your config options (if Configator) have been changed.
		lib.ClearMatchArrayCache()
		pricecache = nil
	elseif (callbackType == "scanstats") then
		-- AH has been scanned
		lib.ClearMatchArrayCache()
		pricecache = nil
	elseif callbackType == "auctionclose" then
		lib.ClearMatchArrayCache()	-- this is mostly to conserve RAM, we don't really need to wipe the cache here
	end
end

local matchArrayCache = {}

function lib.ClearMatchArrayCache()	-- called from processor
	if next(matchArrayCache) then
		matchArrayCache = {}
	end
end

local playerName = UnitName("player")

function lib.GetMatchArray(hyperlink, marketprice)
	if not AucAdvanced.Settings.GetSetting("match.undercut.enable") then
		return
	end
	local linkType,itemId,property,factor = AucAdvanced.DecodeLink(hyperlink)
	if (linkType ~= "item") then return end

	local cacheKey = itemId .."x".. property .. "x" .. factor .. "x" .. (marketprice or "0")
	if matchArrayCache[cacheKey] then return matchArrayCache[cacheKey] end
	
	
	local overmarket = AucAdvanced.Settings.GetSetting("match.undermarket.overmarket")
	local undermarket = AucAdvanced.Settings.GetSetting("match.undermarket.undermarket")
	local usevalue = AucAdvanced.Settings.GetSetting("match.undercut.usevalue")
	local undercut
	if usevalue then
		undercut = AucAdvanced.Settings.GetSetting("match.undercut.value")
	else
		undercut = AucAdvanced.Settings.GetSetting("match.undermarket.undercut")
	end
	local marketdiff = 0
	local competing = 0
	local matchprice = 0
	local minprice = 0
	local lowest = true
	if not marketprice then marketprice = 0 end
	if marketprice > 0 then
		matchprice = floor(marketprice*(1+(overmarket/100)))
		minprice = ceil(marketprice*(1+(undermarket/100)))
	end

	itemId = tonumber(itemId)
	property = tonumber(property) or 0
	factor = tonumber(factor) or 0

	local data = AucAdvanced.API.QueryImage({
		itemId = itemId,
		suffix = property,
		factor = factor,
	})
	competing = #data
	local lowestBidOnly = matchprice
	for i = 1, #data do
		local compet = AucAdvanced.API.UnpackImageItem(data[i])
		local competname = compet.itemName or " "
		local competseller = compet.sellerName or " "
		local competcost = compet.buyoutPrice or 0
		local competstack = compet.stackSize or 0
		if compet.buyoutPrice<1 then
			-- UCUT-8: Don't try to match bid-only auctions
			lowestBidOnly = min(lowestBidOnly, (compet.curBid or compet.minBid)/compet.stackSize)
		else
			compet.buyoutPrice = (compet.buyoutPrice/compet.stackSize)
			if usevalue then
				compet.buyoutPrice = compet.buyoutPrice - undercut
			else
				compet.buyoutPrice = floor(compet.buyoutPrice*((100-undercut)/100))
			end
			if compet.buyoutPrice <= 0 then
				compet.buyoutPrice = 1
			end
			if (compet.buyoutPrice < matchprice) then
				if (compet.buyoutPrice > minprice) then
					if (not (compet.sellerName == playerName)) then
						matchprice = compet.buyoutPrice
					end
				elseif (compet.buyoutPrice > 0) then
					lowest = false
				end
			end
		end
	end
	if (marketprice > 0) then
		marketdiff = (((matchprice - marketprice)/marketprice)*100)
		if (marketdiff-floor(marketdiff))<0.5 then
			marketdiff = floor(marketdiff)
		else
			marketdiff = ceil(marketdiff)
		end
	else
		marketdiff = 0
	end
	local matchArray = {}
	matchArray.value = matchprice
	if lowest then
		if matchprice<=lowestBidOnly then
			matchArray.returnstring = _TRANS('UCUT_Interface_UndercutLowestPrice'):format(marketdiff, "\n")--Undercut: %% change: %s%s Undercut: Lowest Price
		else
			matchArray.returnstring = _TRANS('UCUT_Interface_UndercutLowestBid'):format(marketdiff, "\n")--Undercut: %% change: %s%s Undercut: Lower bid-only auctions
		end
	else
		matchArray.returnstring = _TRANS('UCUT_Interface_UndercutNoMatch'):format(marketdiff, "\n")--Undercut: %% change: %s%s Undercut: Can not match lowest price')
	end
	matchArray.competing = competing
	matchArray.diff = marketdiff
	matchArrayCache[cacheKey] = matchArray
	return matchArray
end

local array = {}

function private.ProcessTooltip(tooltip, name, link, quality, quantity, cost, additional)
	if not link then return end
	if not get("match.undercut.tooltip") then return end
	local model = get("match.undercut.model")
	if not model then return end
	local market
	local matcharray

	if pricecache and pricecache[link] then
		matcharray = replicate(pricecache[link])
		market = matcharray.market
	end
	if not matcharray then
		if model == "market" then
			market = AucAdvanced.API.GetMarketValue(link)
		else
			market = AucAdvanced.API.GetAlgorithmValue(model, link)
		end
		matcharray = lib.GetMatchArray(link, market)
		if not matcharray then return end
		if not pricecache then pricecache = {} end
		pricecache[link] = replicate(matcharray)
		pricecache[link]["market"] = market
	end
	if not matcharray or not matcharray.value or matcharray.value <= 0 then return end

	tooltip:SetColor(0.3, 0.9, 0.8)

	if matcharray.competing == 0 then
		tooltip:AddLine(_TRANS('UCUT_Tooltip_NoCompetition'):format("|cff00ff00") )--Undercut: %s No competition
	elseif matcharray.returnstring:find("Can not match") then
		tooltip:AddLine(_TRANS('UCUT_Tooltip_CannotUndercut'):format("|cffff0000") )--Undercut: %s Cannot Undercut
	elseif matcharray.returnstring:find("Lowest") then
		if matcharray.value >= market then
			tooltip:AddLine(_TRANS('UCUT_Tooltip_CompetitionAbove'):format("|cff40ff00") )--Undercut: %s Competition Above market
		else
			tooltip:AddLine(_TRANS('UCUT_Tooltip_Undercutting'):format("|cfffff000") )--Undercut: %s Undercutting competition
		end
	end
	tooltip:AddLine("  ".._TRANS('UCUT_Tooltip_MovingPrice').." "..tostring(matcharray.diff).."%:", matcharray.value)--Moving price
end

function lib.OnLoad()
	--This function is called when your variables have been loaded.
	--You should also set your Configator defaults here

	--print("AucAdvanced: {{"..libType..":"..libName.."}} loaded!")
	default("match.undercut.enable", true)
	default("match.undermarket.undermarket", -20)
	default("match.undermarket.overmarket", 10)
	default("match.undermarket.undercut", 1)
	default("match.undercut.tooltip", true)
	default("match.undercut.model", "market")
	default("match.undercut.usevalue", false)
	default("match.undercut.value", 1)
end

--[[ Local functions ]]--

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName, libType.." Modules")
	--gui:MakeScrollable(id)

	gui:AddHelp(id, "what undercut module",
		_TRANS('UCUT_Help_WhatUndercut') ,--What is this undercut module?
		_TRANS('UCUT_Help_WhatUndercutAnswer') )--The undercut module allows you to undercut the lowest price of all currently available items, based on your settings. \n\n It is recommended to have undercut run after any other matcher modules.

	gui:AddControl(id, "Header",     0,   _TRANS('UCUT_Interface_UndercutOptions') )--Undercut options

	gui:AddControl(id, "Subhead",    0,   _TRANS('UCUT_Interface_CompetitionMatching') )--Competition Matching

	gui:AddControl(id, "Checkbox",   0, 1, "match.undercut.enable", _TRANS('UCUT_Interface_EnableUndercut') )--Enable Auc-Match-Undercut
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_EnableUndercut') )--Enable this module's functions.

	gui:AddControl(id, "WideSlider", 0, 1, "match.undermarket.undermarket", -100, 0, 1, _TRANS('UCUT_Interface_MaxMarkdown').." %d%%")--Max under market price (markdown):
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_MaxMarkdown') )--This controls how much below the market price you are willing to undercut before giving up. \n If Auctioneer cannot beat the lowest price, it will undercut the lowest price it can.

	gui:AddControl(id, "WideSlider", 0, 1, "match.undermarket.overmarket", 0, 100, 1, _TRANS('UCUT_Interface_MaxMarkup').." %d%%")--Max over market price (markup):
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_MaxMarkup') )--This controls how much above the market price you are willing to mark up. If there is no competition, or the competition is marked up higher than this value Auctioneer will set the price to this value above market.

	gui:AddControl(id, "Slider",     0, 1, "match.undermarket.undercut", 0, 20, 0.1, _TRANS('UCUT_Interface_UndercutMinimum').." %g%%")--Undercut:
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_UndercutMinimum') )--This controls the minimum undercut.  Auctioneer will try to undercut the competition by this amount

	gui:AddControl(id, "Checkbox",   0, 1, "match.undercut.usevalue", _TRANS('UCUT_Interface_UndercutAmount') )--Specify undercut amount by coin value
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_UndercutAmount') )--Specify the amount to undercut by a specific amount, instead of by a percentage

	gui:AddControl(id, "MoneyFramePinned", 0, 2, "match.undercut.value", 1, 99999999, _TRANS('UCUT_Interface_CurrentValue') )--Undercut Amount
	gui:AddControl(id, "Subhead",    0,    _TRANS('UCUT_Interface_UndercutTooltipSettings') )--Tooltip Setting
	gui:AddControl(id, "Checkbox",   0, 1, "match.undercut.tooltip",_TRANS('UCUT_Interface_ShowInTooltip') )--Show undercut status in tooltip
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_ShowInTooltip') )--Add a line to the tooltip showing whether the current competition is undercuttable
	gui:AddControl(id, "Note",       0, 2, 500, 15, _TRANS('UCUT_Interface_TooltipValuationMethod') )--Tooltip price valuation method
	gui:AddControl(id, "Selectbox",  0, 2, parent.selectorPriceModels, "match.undercut.model", _TRANS('UCUT_Interface_PricingModel') )--Pricing model to use
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_PricingModel'))--The pricing model to use to compare the competition against.  Should be set to the model most often used for posting.  --Note: this is ONLY for basing the tooltip on, nothing else

end

AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/5.7/Auc-Match-Undercut/Undercut.lua $", "$Rev: 4496 $")
