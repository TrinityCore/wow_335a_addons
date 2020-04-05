--[[
	Auctioneer - AutoMagic Utility module
	Version: 5.7.4568 (KillerKoala)
	Revision: $Id: Core.lua 4496 2009-10-08 22:15:46Z Nechckn $
	URL: http://auctioneeraddon.com/

	AutoMagic is an Auctioneer module which automates mundane tasks for you.

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

local lib = AucAdvanced.Modules.Util.AutoMagic
local print,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()
local AppraiserValue, DisenchantValue, ProspectValue, VendorValue, bestmethod, bestvalue, runstop, _

-- This table is validating that each ID within it is a gem from prospecting.
local isGem =
	{
	[818] = true,--TIGERSEYE
	[774] = true,--MALACHITE
	[1210] = true,--SHADOWGEM
	[1705] = true,--LESSERMOONSTONE
	[1206] = true,--MOSSAGATE
	[3864] = true,--CITRINE
	[1529] = true,--JADE
	[7909] = true,--AQUAMARINE
	[7910] = true,--STARRUBY
	[12800] = true,--AZEROTHIANDIAMOND
	[12361] = true,--BLUESAPPHIRE
	[12799] = true,--LARGEOPAL
	[12364] = true,--HUGEEMERALD
	[23077] = true,--BLOODGARNET
	[21929] = true,--FLAMESPESSARITE
	[23112] = true,--GOLDENDRAENITE
	[23709] = true,--DEEPPERIDOT
	[23117] = true,--AZUREMOONSTONE
	[23107] = true,--SHADOWDRAENITE
	[23436] = true,--LIVINGRUBY
	[23439] = true,--NOBLETOPAZ
	[23440] = true,--DAWNSTONE
	[23437] = true,--TALASITE
	[23428] = true,--STAROFELUNE
	[23441] = true,--NIGHTSEYE
	[36920] = true,--SUNCRYSTAL
	[36926] = true,--SHADOWCRYSTAL
	[36929] = true,--HUGECITRINE
	[36932] = true,--DARKJADE
	[36923] = true,--CHALCEDONY
	[36917] = true,--BLOODSTONE
	[36927] = true,--TWILIGHTOPAL
	[36924] = true,--SKYSAPPHIRE
	[36918] = true,--SCARLETRUBY
	[36930] = true,--MONARCHTOPAZ
	[36933] = true,---FORESTEMERALD
	[36921] = true,--AUTUMNSGLOW
}

-- This table is validating that each ID within it is a mat from disenchanting.
local isDEMats =
	{
	[34057] = true,--Abyss Crystal
	[22450] = true,--Void Crystal
	[20725] = true,--Nexus Crystal
	[34052] = true,--Dream Shard
	[34053] = true,--Small Dream Shard
	[22449] = true,--Large Prismatic Shards
	[14344] = true,--Large Brillianr Shards
	[11178] = true,--Large Radiant Shards
	[11139] = true,--Large Glowing Shards
	[11084] = true,--Large Glimmering Shards
	[22448] = true,--Small Primatic Shards
	[14343] = true,--Small Brilliant Shards
	[11177] = true,--Small Radiant Shards
	[11138] = true,--Small Glowing Shards
	[10978] = true,--Small Glimmering Shards
	[34055] = true,--Greater Cosmic Essence
	[34056] = true,--Lesser Cosmic Essence
	[22446] = true,--Greater Planer Essence
	[16203] = true,--Greater Eternal Essence
	[11175] = true,--Greater Nether Essence
	[11135] = true,--Greater Mystic Essence
	[11082] = true,--Greater Astral Essence
	[10939] = true,--Greater Magic Essence
	[22447] = true,--Lesser Planer Essence
	[16202] = true,--Lesser Eternal Essence
	[11174] = true,--Lesser Nether Essence
	[11134] = true,--Lesser Mystic Essence
	[10998] = true,--Lesser Astral Essence
	[10938] = true,--Lesser Magic Essence
	[34054] = true, --Infinite Dust
	[22445] = true,--Arcane Dust
	[16204] = true,--Illusion Dust
	[11176] = true,--Dream Dust
	[11137] = true,--Vision Dust
	[11083] = true,--Soul Dust
	[10940] = true,--Strange Dust
}

-- This table is validating that each ID within it is a mat from Milling (table from enchantrix)
local isPigmentMats =
	{
	[39151] = true,	-- ALABASTER_PIGMENT
	[39334] = true,	-- DUSKY_PIGMENT
	[39338] = true,	-- GOLDEN_PIGMENT
	[39339] = true,	-- EMERALD_PIGMENT
	[39340] = true,	-- VIOLET_PIGMENT
	[39341] = true, 	-- SILVERY_PIGMENT
	[43103] = true,	-- VERDANT_PIGMENT
	[43104] = true,	-- BURNT_PIGMENT
	[43105] = true,	-- INDIGO_PIGMENT
	[43106] = true,	-- RUBY_PIGMENT
	[43107] = true, 	-- SAPPHIRE_PIGMENT
	[39342] = true, 	-- NETHER_PIGMENT
	[43108] = true, 	-- EBON_PIGMENT
	[39343] = true, 	-- AZURE_PIGMENT
	[43109] = true, 	-- ICY_PIGMENT
}

lib.vendorlist = {}
function lib.vendorAction()
	empty(lib.vendorlist) --this needs to be cleared on every vendor open
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local itemLink, itemCount = GetContainerItemLink(bag,slot)
				if itemLink then
					if itemCount == nil then _, itemCount = GetContainerItemInfo(bag, slot) end
					if itemCount == nil then itemCount = 1 end
					local _, itemID, _, _, _, _ = decode(itemLink)
					local itemSig = AucAdvanced.API.GetSigFromLink(itemLink) -- future plan is to use itemSig in place of itemID throughout - to eliminate problems for items with suffixes
					local itemName, _, itemRarity, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
					local key = bag..":"..slot -- key needs to be unique, but is not currently used for anything. future: rethink if this can be made useful

					if lib.autoSellList[ itemID ] then
						lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, "Sell List"}
					elseif itemRarity == 0 and get("util.automagic.autosellgrey") then
						lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, "Grey"}
					else --look for btmScan or SearchUI reason codes if above fails
						local reason, text = lib.getReason(itemLink, itemName, itemCount, "vendor")
						if reason and text then
							lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, text}
						end
					end
				end
			end
		end
	end
	lib.ASCPrompt()
end

function lib.disenchantAction()
	MailFrameTab_OnClick(nil, 2)
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local itemLink, itemCount = GetContainerItemLink(bag,slot)
				if (itemLink == nil) then return end
				if itemCount == nil then _, itemCount = GetContainerItemInfo(bag, slot) end
				if itemCount == nil then itemCount = 1 end
				runstop = 0
				local _, itemID, _, _, _, _ = decode(itemLink)
				local itemName, _, itemRarity, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
				if (AucAdvanced.Modules.Util.ItemSuggest and get("util.automagic.overidebtmmail") == true) then
					local aimethod = AucAdvanced.Modules.Util.ItemSuggest.itemsuggest(itemLink, itemCount)
					if(aimethod == "Disenchant") then
						if (get("util.automagic.chatspam")) then
							print("AutoMagic has loaded", itemName, " due to Item Suggest(Disenchant)")
						end
						UseContainerItem(bag, slot)
						runstop = 1
					end
				else --look for btmScan or SearchUI reason codes if above fails
					local reason, text = lib.getReason(itemLink, itemName, itemCount, "disenchant")
					if reason and text then
						if (get("util.automagic.chatspam")) then
							print("AutoMagic has loaded", itemName, " due to", text ,"Rule(Disenchant)")
						end
						UseContainerItem(bag, slot)
					end
				end
			end
		end
	end
end

function lib.prospectAction()
	MailFrameTab_OnClick(nil, 2)
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local itemLink, itemCount = GetContainerItemLink(bag,slot)
				if (itemLink == nil) then return end
				if itemCount == nil then _, itemCount = GetContainerItemInfo(bag, slot) end
				if itemCount == nil then itemCount = 1 end
				local _, itemID, _, _, _, _ = decode(itemLink)
				local itemName, _, itemRarity, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
				runstop = 0
				if (AucAdvanced.Modules.Util.ItemSuggest and get("util.automagic.overidebtmmail") == true) then
					local aimethod = AucAdvanced.Modules.Util.ItemSuggest.itemsuggest(itemLink, itemCount)
					if(aimethod == "Prospect") then
						if (get("util.automagic.chatspam")) then
							print("AutoMagic has loaded", itemName, " due to Item Suggest(Prospect)")
						end
						UseContainerItem(bag, slot)
						runstop = 1
					end
				else --look for btmScan or SearchUI reason codes if above fails
					local reason, text = lib.getReason(itemLink, itemName, itemCount, "prospect")
					if reason and text then
						if (get("util.automagic.chatspam")) then
							print("AutoMagic has loaded", itemName, " due to", text ,"Rule(Prospect)")
						end
						UseContainerItem(bag, slot)
					end
				end
			end
		end
	end
end

function lib.gemAction()
	MailFrameTab_OnClick(nil, 2)
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local itemLink, itemCount = GetContainerItemLink(bag,slot)
				if (itemLink == nil) then return end
				if itemCount == nil then _, itemCount = GetContainerItemInfo(bag, slot) end
				if itemCount == nil then itemCount = 1 end
				local _, itemID, _, _, _, _ = decode(itemLink)
				local itemName, _, itemRarity, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
				if isGem[ itemID ] then
					if (get("util.automagic.chatspam")) then
						print("AutoMagic has loaded", itemName, " because it is a gem!")
					end
					UseContainerItem(bag, slot)
				end
			end
		end
	end
end

function lib.dematAction()
	MailFrameTab_OnClick(nil, 2)
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local itemLink, itemCount = GetContainerItemLink(bag,slot)
				if (itemLink == nil) then return end
				if itemCount == nil then _, itemCount = GetContainerItemInfo(bag, slot) end
				if itemCount == nil then itemCount = 1 end
				local _, itemID, _, _, _, _ = decode(itemLink)
				local itemName, _, itemRarity, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
				if isDEMats[ itemID ] then
					if (get("util.automagic.chatspam")) then
						print("AutoMagic has loaded", itemName, " because it is a mat used for enchanting.")
					end
					UseContainerItem(bag, slot)
				end
			end
		end
	end
end

function lib.pigmentAction()
	MailFrameTab_OnClick(nil, 2)
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local itemLink, itemCount = GetContainerItemLink(bag,slot)
				if (itemLink == nil) then return end
				if itemCount == nil then _, itemCount = GetContainerItemInfo(bag, slot) end
				if itemCount == nil then itemCount = 1 end
				local _, itemID, _, _, _, _ = decode(itemLink)
				local itemName, _, itemRarity, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
				if isPigmentMats[ itemID ] then
					if (get("util.automagic.chatspam")) then
						print("AutoMagic has loaded", itemName, " because it is a pigment used for milling.")
					end
					UseContainerItem(bag, slot)
				end
			end
		end
	end
end

function lib.herbAction()
	MailFrameTab_OnClick(nil, 2)
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local itemLink, itemCount = GetContainerItemLink(bag,slot)
				if (itemLink == nil) then return end
				if itemCount == nil then _, itemCount = GetContainerItemInfo(bag, slot) end
				if itemCount == nil then itemCount = 1 end
				local _, itemID, _, _, _, _ = decode(itemLink)
				local itemName, _, itemRarity, _, _, _, itemType, _, _, _ = GetItemInfo(itemLink)
				if itemType == "Herb" then
					if (get("util.automagic.chatspam")) then
						print("AutoMagic has loaded", itemName, " because it is a herb.")
					end
					UseContainerItem(bag, slot)
				end
			end
		end
	end
end

--Searches for reason and returns values if found nil other wise.
--Consolidates code into one function instead of 5-6 places that need editing/maintaining
function lib.getReason(itemLink, itemName, itemCount, text)
	if (BtmScan) then
		local bidlist = BtmScan.Settings.GetSetting("bid.list")
		if (bidlist) then
			local id, suffix, enchant, seed = BtmScan.BreakLink(itemLink)
			local sig = ("%d:%d:%d"):format(id, suffix, enchant)
			local bids = bidlist[sig..":"..seed.."x"..itemCount]

			if(bids and bids[1] and bids[1] == text) then
				return bids[1], "BTM"
			end
		end
	end

	if (BeanCounter and BeanCounter.API.isLoaded) then
		local reason = BeanCounter.API.getBidReason(itemLink, itemCount) or ""
		if reason:lower() == text then
			return reason, "SearchUI"
		end
	end

	return
end

AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/5.7/Auc-Util-AutoMagic/Core.lua $", "$Rev: 4496 $")
