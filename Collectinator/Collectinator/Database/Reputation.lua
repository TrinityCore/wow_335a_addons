--[[

************************************************************************

Reputation.lua

Reputation data for all of Collectinator

Auto-generated using Dataminer.rb
Entries to this file will be overwritten

************************************************************************

File date: 2010-01-31T23:40:54Z
File revision: @file-revision@
Project revision: @project-revision@
Project version: v1.0.4

]]--

local MODNAME	= "Collectinator"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

local BFAC	= LibStub("LibBabble-Faction-3.0"):GetLookupTable()

function addon:InitReputation(RepDB)

	self:addLookupList(RepDB, 21, BFAC["Booty Bay"])
	self:addLookupList(RepDB, 47, BFAC["Ironforge"])
	self:addLookupList(RepDB, 54, BFAC["Gnomeregan Exiles"])
	self:addLookupList(RepDB, 59, BFAC["Thorium Brotherhood"])
	self:addLookupList(RepDB, 68, BFAC["Undercity"])
	self:addLookupList(RepDB, 69, BFAC["Darnassus"])
	self:addLookupList(RepDB, 70, BFAC["Syndicate"])
	self:addLookupList(RepDB, 72, BFAC["Stormwind"])
	self:addLookupList(RepDB, 76, BFAC["Orgrimmar"])
	self:addLookupList(RepDB, 81, BFAC["Thunder Bluff"])
	self:addLookupList(RepDB, 87, BFAC["Bloodsail Buccaneers"])
	self:addLookupList(RepDB, 92, BFAC["Gelkis Clan Centaur"])
	self:addLookupList(RepDB, 93, BFAC["Magram Clan Centaur"])
	self:addLookupList(RepDB, 270, BFAC["Zandalar Tribe"])
	self:addLookupList(RepDB, 349, BFAC["Ravenholdt"])
	self:addLookupList(RepDB, 369, BFAC["Gadgetzan"])
	self:addLookupList(RepDB, 470, BFAC["Ratchet"])
	self:addLookupList(RepDB, 471, BFAC["Wildhammer Clan"])
	self:addLookupList(RepDB, 510, BFAC["The Defilers"])
	self:addLookupList(RepDB, 529, BFAC["Argent Dawn"])
	self:addLookupList(RepDB, 530, BFAC["Darkspear Trolls"])
	self:addLookupList(RepDB, 576, BFAC["Timbermaw Hold"])
	self:addLookupList(RepDB, 577, BFAC["Everlook"])
	self:addLookupList(RepDB, 589, BFAC["Wintersaber Trainers"])
	self:addLookupList(RepDB, 609, BFAC["Cenarion Circle"])
	self:addLookupList(RepDB, 729, BFAC["Frostwolf Clan"])
	self:addLookupList(RepDB, 730, BFAC["Stormpike Guard"])
	self:addLookupList(RepDB, 749, BFAC["Hydraxian Waterlords"])
	self:addLookupList(RepDB, 809, BFAC["Shen'dralar"])
	self:addLookupList(RepDB, 889, BFAC["Warsong Outriders"])
	self:addLookupList(RepDB, 890, BFAC["Silverwing Sentinels"])
	self:addLookupList(RepDB, 909, BFAC["Darkmoon Faire"])
	self:addLookupList(RepDB, 910, BFAC["Brood of Nozdormu"])
	self:addLookupList(RepDB, 911, BFAC["Silvermoon City"])
	self:addLookupList(RepDB, 922, BFAC["Tranquillien"])
	self:addLookupList(RepDB, 930, BFAC["Exodar"])
	self:addLookupList(RepDB, 932, BFAC["The Aldor"])
	self:addLookupList(RepDB, 933, BFAC["The Consortium"])
	self:addLookupList(RepDB, 934, BFAC["The Scryers"])
	self:addLookupList(RepDB, 935, BFAC["The Sha'tar"])
	self:addLookupList(RepDB, 941, BFAC["The Mag'har"])
	self:addLookupList(RepDB, 942, BFAC["Cenarion Expedition"])
	self:addLookupList(RepDB, 946, BFAC["Honor Hold"])
	self:addLookupList(RepDB, 947, BFAC["Thrallmar"])
	self:addLookupList(RepDB, 967, BFAC["The Violet Eye"])
	self:addLookupList(RepDB, 970, BFAC["Sporeggar"])
	self:addLookupList(RepDB, 978, BFAC["Kurenai"])
	self:addLookupList(RepDB, 989, BFAC["Keepers of Time"])
	self:addLookupList(RepDB, 990, BFAC["The Scale of the Sands"])
	self:addLookupList(RepDB, 1011, BFAC["Lower City"])
	self:addLookupList(RepDB, 1012, BFAC["Ashtongue Deathsworn"])
	self:addLookupList(RepDB, 1015, BFAC["Netherwing"])
	self:addLookupList(RepDB, 1031, BFAC["Sha'tari Skyguard"])
	self:addLookupList(RepDB, 1037, BFAC["Alliance Vanguard"])
	self:addLookupList(RepDB, 1038, BFAC["Ogri'la"])
	self:addLookupList(RepDB, 1050, BFAC["Valiance Expedition"])
	self:addLookupList(RepDB, 1052, BFAC["Horde Expedition"])
	self:addLookupList(RepDB, 1064, BFAC["The Taunka"])
	self:addLookupList(RepDB, 1067, BFAC["The Hand of Vengeance"])
	self:addLookupList(RepDB, 1068, BFAC["Explorers' League"])
	self:addLookupList(RepDB, 1073, BFAC["The Kalu'ak"])
	self:addLookupList(RepDB, 1077, BFAC["Shattered Sun Offensive"])
	self:addLookupList(RepDB, 1085, BFAC["Warsong Offensive"])
	self:addLookupList(RepDB, 1090, BFAC["Kirin Tor"])
	self:addLookupList(RepDB, 1091, BFAC["The Wyrmrest Accord"])
	self:addLookupList(RepDB, 1094, BFAC["The Silver Covenant"])
	self:addLookupList(RepDB, 1098, BFAC["Knights of the Ebon Blade"])
	self:addLookupList(RepDB, 1104, BFAC["Frenzyheart Tribe"])
	self:addLookupList(RepDB, 1105, BFAC["The Oracles"])
	self:addLookupList(RepDB, 1106, BFAC["Argent Crusade"])
	self:addLookupList(RepDB, 1119, BFAC["The Sons of Hodir"])
	self:addLookupList(RepDB, 1124, BFAC["The Sunreavers"])
	self:addLookupList(RepDB, 1126, BFAC["The Frostborn"])

end
