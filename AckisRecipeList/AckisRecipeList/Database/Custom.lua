--[[
************************************************************************
Custom.lua
Custom acquire data for all of Ackis Recipe List
************************************************************************
File date: 2010-04-09T00:40:50Z
File revision: @file-revision@
Project revision: @project-revision@
Project version: v2.01-8-g9458672
************************************************************************
Format:
	self:addLookupList(DB, Rep ID, Rep Name)
************************************************************************
Please see http://www.wowace.com/addons/arl/ for more information.
************************************************************************
This source code is released under All Rights Reserved.
************************************************************************
]]--

local MODNAME		= "Ackis Recipe List"
local addon		= LibStub("AceAddon-3.0"):GetAddon(MODNAME)
local L			= LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local BZ		= LibStub("LibBabble-Zone-3.0"):GetLookupTable()

function addon:InitCustom(DB)
	self:addLookupList(DB, 1, L["DISCOVERY_ALCH_ELIXIRFLASK"])
	self:addLookupList(DB, 2, L["DISCOVERY_ALCH_POTION"])
	self:addLookupList(DB, 3, L["DISCOVERY_ALCH_XMUTE"])
	self:addLookupList(DB, 4, L["DISCOVERY_ALCH_PROT"])
	self:addLookupList(DB, 5, L["DAILY_COOKING_MEAT"], BZ["Shattrath"], 0, 0)
	self:addLookupList(DB, 6, L["DAILY_COOKING_FISH"], BZ["Shattrath"], 0, 0)
	self:addLookupList(DB, 7, L["DAILY_FISHING_SHATT"], BZ["Shattrath"], 0, 0)
	self:addLookupList(DB, 8, L["DEFAULT_RECIPE"])
	self:addLookupList(DB, 9, L["CRAFTED_ENGINEERS"])
	self:addLookupList(DB, 10, L["ONYXIA_HEAD_QUEST"], BZ["Onyxia's Lair"], 0, 0)
	self:addLookupList(DB, 11, L["EDGE_OF_MADNESS"], BZ["Zul'Gurub"], 0, 0)
	self:addLookupList(DB, 12, L["DISCOVERY_ALCH_WRATH"])
	self:addLookupList(DB, 13, L["HENRY_STERN_RFD"], BZ["Razorfen Downs"], 0, 0)
	self:addLookupList(DB, 14, L["DISCOVERY_INSC_MINOR"])
	self:addLookupList(DB, 15, L["DISCOVERY_INSC_NORTHREND"])
	self:addLookupList(DB, 16, L["ENG_GNOMER"], BZ["Gnomeregan"], 0, 0)
	self:addLookupList(DB, 17, L["ENG_FLOOR_ITEM_BRD"], BZ["Blackrock Depths"], 0, 0)
	self:addLookupList(DB, 18, L["DISCOVERY_ALCH_NORTHREND_RESEARCH"])
	self:addLookupList(DB, 19, L["DISCOVERY_ALCH_NORTHREND_XMUTE"])

	self:addLookupList(DB, 22, L["AQ40_RANDOM_BOP"], BZ["Temple of Ahn'Qiraj"], 0, 0)
	self:addLookupList(DB, 23, L["DM_CACHE"], BZ["Dire Maul"], 59.04, 48.82)
	self:addLookupList(DB, 24, L["SUNWELL_RANDOM"], BZ["Sunwell Plateau"], 0, 0)
	self:addLookupList(DB, 25, L["BRD_RANDOM_ROOM"], BZ["Blackrock Depths"], 0, 0)
	self:addLookupList(DB, 26, L["MC_RANDOM"], BZ["Molten Core"], 0, 0)
	self:addLookupList(DB, 27, L["HYJAL_RANDOM"], BZ["Hyjal Summit"], 0, 0)

	self:addLookupList(DB, 29, L["ZA_RANDOM"], BZ["Zul'Aman"], 0, 0)
	self:addLookupList(DB, 30, L["SCHOLO_BOOK_SPAWN"], BZ["Scholomance"], 0, 0)
	self:addLookupList(DB, 31, L["STRATH_BS_PLANS"], BZ["Stratholme"], 0, 0)
	self:addLookupList(DB, 32, L["DM_TRIBUTE"], BZ["Dire Maul"], 59.04, 48.82)

	self:addLookupList(DB, 34, L["BT_RANDOM"], BZ["Black Temple"], 0, 0)
	self:addLookupList(DB, 35, L["Custom35"])
	self:addLookupList(DB, 36, L["Custom36"])

	self:addLookupList(DB, 37, L["SSC_RANDOM"], BZ["Serpentshrine Cavern"], 0, 0)
	self:addLookupList(DB, 38, L["DAILY_COOKING_DAL"], BZ["Dalaran"], 0, 0)
	self:addLookupList(DB, 39, L["ULDUAR_RANDOM"], BZ["Ulduar"], 0, 0)
	self:addLookupList(DB, 40, L["DISCOVERY_INSC_BOOK"])
	self:addLookupList(DB, 41, L["Custom41"])
	self:addLookupList(DB, 42, L["TOC25_RANDOM"])
	self:addLookupList(DB, 43, L["TK_RANDOM"], BZ["The Eye"], 0, 0)
	self:addLookupList(DB, 44, L["Custom44"])
	self:addLookupList(DB, 45, L["Custom45"])

--self:addLookupList(DB, 28, L["BT_HYJAL_RANDOM"])
--[[
L["Custom35"] = "Drops from dragons in Ogri'la and Blade's Edge Mountains Summon Bosses"
L["Custom36"] = "From a NPC in Dalaran sewers after doing The Taste Test" -- Update
L["Custom38"] = "Randomly obtained by completing the cooking daily quest in Dalaran."
L["Custom41"] = "Removed from the game when Naxx 40 was taken out."
]]--
end

