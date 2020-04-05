--[[
************************************************************************
Seasonal.lua
Seasonal data for all of AckisRecipeList
************************************************************************
File date: 2010-03-14T06:15:56Z
File revision: @file-revision@
Project revision: @project-revision@
Project version: v2.01-8-g9458672
************************************************************************
Format:
	self:addLookupList(SeasonDB, Season ID, Season Name)
************************************************************************
Please see http://www.wowace.com/addons/arl/ for more information.
************************************************************************
License:
	Please see LICENSE.txt
This source code is released under All Rights Reserved.
************************************************************************
]]--

local MODNAME		= "Ackis Recipe List"
local addon		= LibStub("AceAddon-3.0"):GetAddon(MODNAME)
local L			= LibStub("AceLocale-3.0"):GetLocale(MODNAME)

local GetCategoryInfo = GetCategoryInfo

function addon:InitSeasons(DB)
	local name = ""
	local seasonal = GetCategoryInfo(155)

	name = GetCategoryInfo(156) -- Winter's Veil
	self:addLookupList(DB, 1, name, seasonal)

	name = GetCategoryInfo(160) -- Lunar Festival
	self:addLookupList(DB, 2, name, seasonal)

	name = L["Darkmoon Faire"] -- Darkmoon Faire
	self:addLookupList(DB, 3, name, seasonal)

	name = GetCategoryInfo(161) -- Midsummer
	self:addLookupList(DB, 4, name, seasonal)

	name = GetCategoryInfo(14981) -- Pilgrim's Bounty
	self:addLookupList(DB, 5, name, seasonal)

	name = L["Day of the Dead"] -- Day of the Dead
	self:addLookupList(DB, 6, name, seasonal)
end
