--[[
************************************************************************
Reputation.lua
Reputation data for all of Ackis Recipe List
************************************************************************
File date: 2010-03-14T06:15:56Z
File revision: @file-revision@
Project revision: @project-revision@
Project version: v2.01-8-g9458672
************************************************************************
Format:
	self:addLookupList(DB, Rep ID,  Rep Name)
************************************************************************
Please see http://www.wowace.com/addons/arl/ for more information.
************************************************************************
This source code is released under All Rights Reserved.
************************************************************************
]]--

local MODNAME	= "Ackis Recipe List"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)
local L		= LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local BFAC	= LibStub("LibBabble-Faction-3.0"):GetLookupTable()

function addon:InitReputation(DB)
	self:addLookupList(DB, 59, BFAC["Thorium Brotherhood"], "N/A")
	self:addLookupList(DB, 270, BFAC["Zandalar Tribe"], "N/A")
	self:addLookupList(DB, 529, BFAC["Argent Dawn"], "N/A")
	self:addLookupList(DB, 576, BFAC["Timbermaw Hold"], "N/A")
	self:addLookupList(DB, 609, BFAC["Cenarion Circle"], "N/A")
	self:addLookupList(DB, 932, BFAC["The Aldor"], "N/A")
	self:addLookupList(DB, 933, BFAC["The Consortium"], "N/A")
	self:addLookupList(DB, 934, BFAC["The Scryers"], "N/A")
	self:addLookupList(DB, 935, BFAC["The Sha'tar"], "N/A")
	self:addLookupList(DB, 941, BFAC["The Mag'har"], "N/A")
	self:addLookupList(DB, 942, BFAC["Cenarion Expedition"], "N/A")
	self:addLookupList(DB, 946, BFAC["Honor Hold"], "N/A")
	self:addLookupList(DB, 947, BFAC["Thrallmar"], "N/A")
	self:addLookupList(DB, 967, BFAC["The Violet Eye"], "N/A")
	self:addLookupList(DB, 970, BFAC["Sporeggar"], "N/A")
	self:addLookupList(DB, 978, BFAC["Kurenai"], "N/A")
	self:addLookupList(DB, 989, BFAC["Keepers of Time"], "N/A")
	self:addLookupList(DB, 990, BFAC["The Scale of the Sands"], "N/A")
	self:addLookupList(DB, 1011, BFAC["Lower City"], "N/A")
	self:addLookupList(DB, 1012, BFAC["Ashtongue Deathsworn"], "N/A")
	self:addLookupList(DB, 1037, BFAC["Alliance Vanguard"], "N/A")
	self:addLookupList(DB, 1050, BFAC["Valiance Expedition"], "N/A")
	self:addLookupList(DB, 1052, BFAC["Horde Expedition"], "N/A")
	self:addLookupList(DB, 1064, BFAC["The Taunka"], "N/A")
	self:addLookupList(DB, 1067, BFAC["The Hand of Vengeance"], "N/A")
	self:addLookupList(DB, 1068, BFAC["Explorers' League"], "N/A")
	self:addLookupList(DB, 1073, BFAC["The Kalu'ak"], "N/A")
	self:addLookupList(DB, 1077, BFAC["Shattered Sun Offensive"], "N/A")
	self:addLookupList(DB, 1085, BFAC["Warsong Offensive"], "N/A")
	self:addLookupList(DB, 1090, BFAC["Kirin Tor"], "N/A")
	self:addLookupList(DB, 1091, BFAC["The Wyrmrest Accord"], "N/A")
	self:addLookupList(DB, 1098, BFAC["Knights of the Ebon Blade"], "N/A")
	self:addLookupList(DB, 1104, BFAC["Frenzyheart Tribe"], "N/A")
	self:addLookupList(DB, 1105, BFAC["The Oracles"], "N/A")
	self:addLookupList(DB, 1106, BFAC["Argent Crusade"], "N/A")
	self:addLookupList(DB, 1119, BFAC["The Sons of Hodir"], "N/A")
	self:addLookupList(DB, 1156, BFAC["The Ashen Verdict"], "N/A")
end
