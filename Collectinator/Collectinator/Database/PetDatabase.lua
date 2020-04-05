--------------------------------------------------------------------------------------------------------------------
-- ./DB/PetDatabase.lua
-- Pet Database data for all of Collectinator
--------------------------------------------------------------------------------------------------------------------
-- File date: 2010-07-27T16:06:54Z
-- Project version: v1.0.4
--------------------------------------------------------------------------------------------------------------------
-- Please see http://www.wowace.com/addons/collectinator/ for more information.
--------------------------------------------------------------------------------------------------------------------
-- License:
-- Please see LICENSE.txt
-- This source code is released under All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------

--[[
http://lua-users.org/wiki/SlightlyLessSimpleLuaPreprocessor
http://wowuidev.pastey.net/125321
http://wowuidev.pastey.net/125322
12:59	sylvanaar	Ackis so i saved that code to a file luapp.lua, then i did lua luapp.lua infile.lua outfile.lua
13:00	sylvanaar	"lua luapp.lua infile.lua outfile.lua"
]]--

local MODNAME		= "Collectinator"
local addon		= LibStub("AceAddon-3.0"):GetAddon(MODNAME)
local BF		= LibStub("LibBabble-Faction-3.0"):GetLookupTable()

local FACTION_ALLIANCE	= BF["Alliance"]
local FACTION_HORDE	= BF["Horde"]

local MY_FACTION	= select(2, UnitFactionGroup("player"))

-------------------------------------------------------------------------------
-- Item "rarity"
-------------------------------------------------------------------------------
local R_COMMON, R_UNCOMMON, R_RARE, R_EPIC, R_LEGENDARY, R_ARTIFACT = 1, 2, 3, 4, 5, 6

-------------------------------------------------------------------------------
-- Origin
-------------------------------------------------------------------------------
local GAME_ORIG, GAME_TBC, GAME_WOTLK = 0, 1, 2

-------------------------------------------------------------------------------
-- Filter flags
-------------------------------------------------------------------------------
local F_ALLIANCE, F_HORDE, F_VENDOR, F_QUEST, F_CRAFT, F_INSTANCE, F_RAID, F_SEASONAL, F_WORLD_DROP, F_MOB_DROP = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
local F_TCG, F_SPEC_EVENT, F_COLLECTORS, F_REMOVED, F_ACHIEVEMENT, F_PVP, F_STORE = 11, 12, 13, 14, 15, 16, 77
local F_BOE, F_BOP, F_BOA = 17, 18, 19
local F_ALCH, F_BS, F_COOKING, F_ENCH, F_ENG, F_FIRST_AID, F_INSC, F_JC, F_LW, F_SMELT, F_TAILOR, F_FISHING = 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32

-------------------------------------------------------------------------------
-- Reputation Filter Flags
-------------------------------------------------------------------------------
local F_ARGENT_DAWN, F_BLOODSAIL, F_CENARION_CIRCLE, F_THORIUM_BROTHERHOOD, F_TIMBERMAW, F_WINTERSRPING, F_ZANDALAR = 33, 34, 35, 36, 37, 38, 39
local F_ALDOR, F_ASHTONGUE, F_CENARION_EXPIDITION, F_HELLFIRE, F_CONSORTIUM, F_KOT, F_LOWER_CITY, F_NAGRAND = 40, 41, 42, 43, 44, 45, 46, 47
local F_NETHERWING, F_SCALE_SANDS, F_SCRYER, F_SHATAR, F_SKYGUARD, F_SHATTEREDSUN, F_SPOREGGAR, F_VIOLET_EYE = 48, 49, 50, 51, 52, 53, 54, 55
local F_ARGENT_CRUSADE, F_FRENZYHEART, F_EBON_BLADE, F_KIRINTOR, F_HODIR, F_KALUAK, F_ORACLES, F_WYRMREST = 56, 57, 58, 59, 60, 61, 62, 63
local WRATHCOMMON1, WRATHCOMMON2, WRATHCOMMON3, WRATHCOMMON4, WRATHCOMMON5 = 64, 65, 66, 67, 68
local F_CITY1, F_CITY2, F_CITY3, F_CITY4, F_CITY5 = 69, 70, 71, 72, 73
local F_PVP1, F_PVP2, F_PVP3 = 74, 75, 76

-- City 1 Darnassus/Darkspear
-- City 2 Stormwind/Orgrimmar
-- City 3 Gnomerga/Thunder Bluff
-- City 4 Ironforge/Undercity
-- City 5 Exodar/Silvermoon
-- PVP 1 WSG
-- PVP 2 AV
-- PVP 3 AB
--Wrath Common Factions 1 (The Silver Covenant/The Sunreavers)
--Wrath Common Factions 2 (Explorer's League/Hand of Vengance)
--Wrath Common Factions 3 (Explorer's League/Valiance Expedition)
--Wrath Common Factions 4 (The Frostborn/The Taunka)
--Wrath Common Factions 5 (Alliance Vanguard/Horde Expedition)

-------------------------------------------------------------------------------
-- Acquire types
-------------------------------------------------------------------------------
local A_VENDOR, A_QUEST, A_CRAFTED, A_MOB, A_SEASONAL, A_REPUTATION, A_WORLD_DROP, A_CUSTOM, A_ACHIEVEMENT = 1, 2, 3, 4, 5, 6, 7, 8, 9

-------------------------------------------------------------------------------
-- Reputation Levels
-------------------------------------------------------------------------------
local FRIENDLY = 1
local HONORED = 2
local REVERED = 3
local EXALTED = 4

local initialized = false
local num_pets = 0

function addon:GetMiniPetTotal(PetDB)
	if initialized then
		return num_pets
	end
	initialized = true

	-------------------------------------------------------------------------------
	-- Counter and wrapper function
	-------------------------------------------------------------------------------
	local function AddPet(SpellID, PetItemID, Rarity, Game)
		num_pets = num_pets + 1
		addon:AddCompanion(PetDB, "CRITTER", SpellID, PetItemID, Rarity, Game)
	end

-- 3.3 pets - not categorized
	-- Core Hound Pup
	AddPet(69452, 49646, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 69452, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_BOP)
	self:AddCompanionAcquire(PetDB, 69452, A_CUSTOM, 14)

	-- Calico Cat
	AddPet(65358, 46398, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 65358, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 65358, A_VENDOR, 28951)

	-- Albino Snake
	AddPet(10713, 44822, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 10713, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10713, A_VENDOR, 28951)

	-- Zipao Tiger - 69539
	AddPet(69539, nil, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 69539, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_REMOVED, F_BOE)
	self:AddCompanionAcquire(PetDB, 69539, A_CUSTOM, 34)

--ACHIEVEMENTS
	-- Pilgrim Turkey - 61773
	AddPet(61773, 44810, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 61773, F_ALLIANCE, F_HORDE, F_ACHIEVEMENT)
	self:AddCompanionAcquire(PetDB, 61773, A_ACHIEVEMENT, 3478, A_ACHIEVEMENT, 3656)

	-- Kirin Tor Familiar - 61472
	AddPet(61472, 44738, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 61472, F_ALLIANCE, F_HORDE, F_ACHIEVEMENT, F_BOP)
	self:AddCompanionAcquire(PetDB, 61472, A_ACHIEVEMENT, 1956)

	-- Reeking Pet Carrier - 40990
	AddPet(40990, 40653, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 40990, F_ALLIANCE, F_HORDE, F_ACHIEVEMENT, F_BOP)
	self:AddCompanionAcquire(PetDB, 40990, A_ACHIEVEMENT, 1250)

	-- Little Fawn - 61991
	AddPet(61991, 44841, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 61991, F_ALLIANCE, F_HORDE, F_ACHIEVEMENT, F_BOP)
	self:AddCompanionAcquire(PetDB, 61991, A_ACHIEVEMENT, 2516)

	-- Perky Pug - 70600
	AddPet(70613, 49912, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 70613, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_BOP)
	self:AddCompanionAcquire(PetDB, 70613, A_CUSTOM, 15)

--FISHING
	-- Magical Crawdad Box - 33050
	AddPet(33050, 27445, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 33050, F_ALLIANCE, F_HORDE, F_WORLD_DROP, F_BOP, F_FISHING)
	self:AddCompanionAcquire(PetDB, 33050, A_ACHIEVEMENT, 726, A_CUSTOM, 9)

	-- Toothy's Bucket - 43697
	AddPet(43697, 33816, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 43697, F_ALLIANCE, F_HORDE, F_QUEST, F_BOP, F_FISHING)
	self:AddCompanionAcquire(PetDB, 43697, A_QUEST, 11665, A_CUSTOM, 18)

	-- Muckbreath's Bucket - 43698
	AddPet(43698, 33818, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 43698, F_ALLIANCE, F_HORDE, F_QUEST, F_BOP, F_FISHING)
	self:AddCompanionAcquire(PetDB, 43698, A_QUEST, 11665, A_CUSTOM, 18)

	-- Snarly's Bucket - 46425
	AddPet(46425, 35349, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 46425, F_ALLIANCE, F_HORDE, F_QUEST, F_BOP, F_FISHING)
	self:AddCompanionAcquire(PetDB, 46425, A_QUEST, 11665, A_CUSTOM, 18)

	-- Chuck's Bucket - 46426
	AddPet(46426, 35350, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 46426, F_ALLIANCE, F_HORDE, F_QUEST, F_BOP, F_FISHING)
	self:AddCompanionAcquire(PetDB, 46426, A_QUEST, 11665, A_CUSTOM, 18)

	-- Giant Sewer Rat - 59250
	AddPet(59250, 43698, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 59250, F_ALLIANCE, F_HORDE, F_BOP, F_WORLD_DROP, F_FISHING)
	self:AddCompanionAcquire(PetDB, 59250, A_ACHIEVEMENT, 1958)

	-- Strand Crawler -- 62561
	AddPet(62561, 44983, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62561, F_ALLIANCE, F_HORDE, F_QUEST, F_BOP, F_FISHING)
	self:AddCompanionAcquire(PetDB, 62561, A_QUEST, 13830, A_QUEST, 13832, A_QUEST, 13833, A_QUEST, 13834, A_QUEST, 13836)

--PLAYERMADE
	-- Mechanical Squirrel Box - 4055
	AddPet(4055, 4401, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 4055, F_ALLIANCE, F_HORDE, F_CRAFT, F_BOE)
	self:AddCompanionAcquire(PetDB, 4055, A_CRAFTED, 4036, 3928)

	-- Pet Bombling - 15048
	AddPet(15048, 11825, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 15048, F_ALLIANCE, F_HORDE, F_CRAFT, F_BOE, F_ENG)
	self:AddCompanionAcquire(PetDB, 15048, A_CRAFTED, 4036, 15628)

	-- Lil' Smoky - 15049
	AddPet(15049, 11826, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 15049, F_ALLIANCE, F_HORDE, F_CRAFT, F_BOE, F_ENG)
	self:AddCompanionAcquire(PetDB, 15049, A_CRAFTED, 4036, 15633)

	-- Lifelike Mechanical Toad - 19772
	AddPet(19772, 15996, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 19772, F_ALLIANCE, F_HORDE, F_CRAFT, F_BOE)
	self:AddCompanionAcquire(PetDB, 19772, A_CRAFTED, 4036, 19793)

	-- Tranquil Mechanical Yeti - 26010
	AddPet(26010, 21277, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 26010, F_ALLIANCE, F_HORDE, F_CRAFT, F_BOE)
	self:AddCompanionAcquire(PetDB, 26010, A_CRAFTED, 4036, 26011)

--WORLD EVENT DROP
	-- Snowman Kit - 26045
	AddPet(26045, 21309, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 26045, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOE)
	self:AddCompanionAcquire(PetDB, 26045, A_SEASONAL, 1)

	-- Jingling Bell - 26529
	AddPet(26529, 21308, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 26529, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOE)
	self:AddCompanionAcquire(PetDB, 26529, A_SEASONAL, 1)

	-- Green Helper Box - 26533
	AddPet(26533, 21301, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 26533, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOE)
	self:AddCompanionAcquire(PetDB, 26533, A_SEASONAL, 1)

	-- Red Helper Box - 26541
	AddPet(26541, 21305, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 26541, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOE)
	self:AddCompanionAcquire(PetDB, 26541, A_SEASONAL, 1)

	-- Truesilver Shafted Arrow - 27570
	AddPet(27570, 22235, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 27570, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 27570, A_ACHIEVEMENT, 1700, A_SEASONAL, 5)

	-- Sinister Squashling - 42609
	AddPet(42609, 33154, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 42609, F_ALLIANCE, F_HORDE, F_INSTANCE, F_SEASONAL, F_MOB_DROP, F_BOP)
	self:AddCompanionAcquire(PetDB, 42609, A_MOB, 23682, A_SEASONAL, 7)

	-- Scorched Stone - 45890
	AddPet(45890, 34955, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 45890, F_ALLIANCE, F_HORDE, F_INSTANCE, F_SEASONAL, F_MOB_DROP, F_BOP, F_REMOVED)
	self:AddCompanionAcquire(PetDB, 45890, A_MOB, 25740, A_SEASONAL, 4)

	-- Clockwork Rocket Bot - 54187
	AddPet(54187, 34425, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 54187, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOP, F_REMOVED)
	self:AddCompanionAcquire(PetDB, 54187, A_ACHIEVEMENT, 1705, A_SEASONAL, 1)

	-- Spring Rabbit - 61725
	AddPet(61725, 44794, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 61725, F_ALLIANCE, F_HORDE, F_SEASONAL)
	self:AddCompanionAcquire(PetDB, 61725, A_SEASONAL, 9)

	-- Toxic Wasteling - 71840
	AddPet(71840, 50446, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 71840, F_ALLIANCE, F_HORDE, F_SEASONAL, F_MOB_DROP, F_INSTANCE, F_BOP)
	self:AddCompanionAcquire(PetDB, 71840, A_SEASONAL, 5, A_MOB, 36296)

	-- Ice Chip (Frigid Frostling) - 74932
	AddPet(74932, 53641, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 74932, F_ALLIANCE, F_HORDE, F_SEASONAL, F_MOB_DROP, F_INSTANCE, F_BOP)
	self:AddCompanionAcquire(PetDB, 74932, A_SEASONAL, 4, A_MOB, 25740)

--WORLD EVENT VENDOR
	-- Spirit of Summer - 28871
	AddPet(28871, 23083, R_RARE, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 28871, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 28871, A_SEASONAL, 4)

	-- Pint-Sized Pink Pachyderm - 44369
	AddPet(44369, 46707, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 44369, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 44369, A_SEASONAL, 6, A_VENDOR, 23710, A_VENDOR, 24495, A_VENDOR, 27478, A_VENDOR, 27489)

--DROP
	-- Parrot Cage (Hyacinth Macaw) - 10682
	AddPet(10682, 8494, R_EPIC, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10682, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 10682, A_MOB, 1561, A_MOB, 1562, A_MOB, 1563, A_MOB, 1564, A_MOB, 1565, A_MOB, 1653, A_MOB, 2545, A_MOB, 4505, A_MOB, 4506)

	-- Parrot Cage (Green Wing Macaw) - 10683
	AddPet(10683, 8492, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10683, F_ALLIANCE, F_HORDE, F_INSTANCE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 10683, A_MOB, 657)

	-- Cat Carrier (Black Tabby) - 10675
	AddPet(10675, 8491, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10675, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 10675, A_MOB, 1920, A_MOB, 2271, A_MOB, 2272, A_MOB, 2358)

	-- Cat Carrier (Siamese) - 10677
	AddPet(10677, 8490, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10677, F_ALLIANCE, F_HORDE, F_VENDOR, F_INSTANCE, F_BOE)
	self:AddCompanionAcquire(PetDB, 10677, A_VENDOR, 20980, A_MOB, 645)

	-- Dark Whelpling - 10695
	AddPet(10695, 10822, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10695, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 10695, A_MOB, 2725, A_MOB, 4324)

	-- Azure Whelpling - 10696
	AddPet(10696, 34535, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10696, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 10696, A_MOB, 193, A_MOB, 6129, A_MOB, 6130, A_MOB, 6131)

	-- Tiny Crimson Whelpling - 10697
	AddPet(10697, 8499, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10697, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 10697, A_MOB, 1042, A_MOB, 1044, A_MOB, 1069)

	-- Tiny Emerald Whelpling - 10698
	AddPet(10698, 8498, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10698, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 10698, A_MOB, 741)

	-- Disgusting Oozeling - 25162
	AddPet(25162, 20769, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 25162, F_ALLIANCE, F_HORDE, F_WORLD_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 25162, A_MOB, 14345, A_MOB, 15335, A_MOB, 8606, A_MOB, 8607, A_MOB, 1808, A_MOB, 12387, A_MOB, 1806, A_MOB, 9621, A_MOB, 9477, A_MOB, 7093, A_MOB, 6559, A_MOB, 7092, A_MOB, 6557, A_CUSTOM, 3)

	-- Captured Firefly - 36034
	AddPet(36034, 29960, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 36034, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 36034, A_MOB, 20197)

	-- Mojo - 43918
	AddPet(43918, 33993, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 43918, F_ALLIANCE, F_HORDE, F_RAID, F_BOP)
	self:AddCompanionAcquire(PetDB, 43918, A_MOB, 24396, A_CUSTOM, 19)

	-- Phoenix Hatchling - 46599
	AddPet(46599, 35504, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 46599, F_ALLIANCE, F_HORDE, F_INSTANCE, F_MOB_DROP, F_BOP)
	self:AddCompanionAcquire(PetDB, 46599, A_MOB, 24664)

	-- Darting Hatchling
	AddPet(67413, 48112, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 67413, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 67413, A_MOB, 14232)

	-- Deviate Hatchling
	AddPet(67414, 48114, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 67414, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 67414, A_MOB, 3636, A_MOB, 3637)

	-- Gundrak Hatchling
	AddPet(67415, 48116, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 67415, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 67415, A_MOB, 29334)

	-- Leaping Hatchling
	AddPet(67416, 48118, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 67416, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 67416, A_MOB, 5842)

	-- Ravasaur Hatchling
	AddPet(67418, 48122, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 67418, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 67418, A_MOB, 6581)

	-- Razormaw Hatchling
	AddPet(67419, 48124, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 67419, F_ALLIANCE, F_HORDE, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 67419, A_MOB, 1140)

	-- Razzashi Hatchling
	AddPet(67420, 48122, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 67420, F_ALLIANCE, F_HORDE, F_RAID, F_MOB_DROP, F_BOE)
	self:AddCompanionAcquire(PetDB, 67420, A_MOB, 14821)

--QUESTS
	-- Mechanical Chicken - 12243
	AddPet(12243, 10398, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 12243, F_ALLIANCE, F_HORDE, F_QUEST, F_BOE)
	self:AddCompanionAcquire(PetDB, 12243, A_QUEST, 3721)

	-- Chicken Egg - 13548
	AddPet(13548, 11110, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 13548, F_ALLIANCE, F_HORDE, F_QUEST, F_BOP)
	self:AddCompanionAcquire(PetDB, 13548, A_QUEST, 3861, A_CUSTOM, 2)

	-- Sprite Darter Egg - 15067
	AddPet(15067, 11474, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 15067, F_ALLIANCE, F_HORDE, F_QUEST, F_BOP)
	self:AddCompanionAcquire(PetDB, 15067, A_QUEST, 4298, A_MOB, 5278, A_CUSTOM, 27)

	-- Worg Carrier - 15999
	AddPet(15999, 12264, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 15999, F_ALLIANCE, F_HORDE, F_QUEST, F_BOP)
	self:AddCompanionAcquire(PetDB, 15999, A_QUEST, 4729)

	-- Smolderweb Carrier - 16450
	AddPet(16450, 12529, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 16450, F_ALLIANCE, F_HORDE, F_QUEST, F_BOP)
	self:AddCompanionAcquire(PetDB, 16450, A_QUEST, 4862)

	-- A Jubling's Tiny Home - 23811
	AddPet(23811, 19450, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 23811, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 23811, A_QUEST, 7946, A_SEASONAL, 3)

	-- Miniwing - 39181
	AddPet(39181, 31760, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 39181, F_ALLIANCE, F_HORDE, F_QUEST, F_BOP)
	self:AddCompanionAcquire(PetDB, 39181, A_QUEST, 10898)

	-- Wolpertinger's Tankard - 39709
	AddPet(39709, 32233, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 39709, F_ALLIANCE, F_HORDE, F_QUEST, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 39709, A_SEASONAL, 6, A_QUEST, 11431, A_QUEST, 11117)

	-- Argent Squire -- 62609
	AddPet(62609, 44998, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62609, F_ALLIANCE, F_QUEST, F_BOP)
	self:AddCompanionAcquire(PetDB, 62609, A_QUEST, 13702, A_QUEST, 13732, A_QUEST, 13733, A_QUEST, 13734, A_QUEST, 13735)

	-- Argent Gruntling -- 62746
	AddPet(62746, 45022, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62746, F_HORDE, F_QUEST, F_BOP)
	self:AddCompanionAcquire(PetDB, 62746, A_QUEST, 13736, A_QUEST, 13737, A_QUEST, 13738, A_QUEST, 13739, A_QUEST, 13740)

	-- Turtle Box - 28738
	AddPet(28738, 23002, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 28738, F_ALLIANCE, F_HORDE, F_QUEST, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 28738, A_QUEST, 171, A_QUEST, 5502, A_SEASONAL, 8)

	-- Piglet's Collar - 28739
	AddPet(28739, 23007, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 28739, F_ALLIANCE, F_HORDE, F_QUEST, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 28739, A_QUEST, 171, A_QUEST, 5502, A_SEASONAL, 8)

	-- Rat Cage - 28740
	AddPet(28740, 23015, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 28740, F_ALLIANCE, F_HORDE, F_QUEST, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 28740, A_QUEST, 171, A_QUEST, 5502, A_ACHIEVEMENT, 1792)

	-- Sleepy Willy - 40613
	AddPet(40613, 32617, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 40613, F_ALLIANCE, F_HORDE, F_QUEST, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 40613, A_QUEST, 10966, A_QUEST, 10967, A_SEASONAL, 8)

	-- Egbert's Egg - 40614
	AddPet(40614, 32616, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 40614, F_ALLIANCE, F_HORDE, F_QUEST, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 40614, A_QUEST, 10966, A_QUEST, 10967, A_SEASONAL, 8)

	-- Elekk Training Collar - 40634
	AddPet(40634, 32622, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 40634, F_ALLIANCE, F_HORDE, F_QUEST, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 40634, A_QUEST, 10966, A_QUEST, 10967, A_SEASONAL, 8)

	-- Curious Wolvar Pup
	AddPet(65382, 46544, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 65382, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 65382, A_QUEST, 13959, A_SEASONAL, 8)

	-- Curious Oracle Hatchling
	AddPet(65381, 46545, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 65381, F_ALLIANCE, F_HORDE, F_SEASONAL, F_BOP)
	self:AddCompanionAcquire(PetDB, 65381, A_QUEST, 13960, A_SEASONAL, 8)

--REP VENDOR ARGENT
	-- Teldrassil Sproutling -- 62491
	AddPet(62491, 44965, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62491, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 62491, A_VENDOR, 33653)

	-- Dun Morogh Cub -- 62508
	AddPet(62508, 44970, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62508, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 62508, A_VENDOR, 33310)

	-- Tirisfal Batling -- 62510
	AddPet(62510, 44971, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62510, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 62510, A_VENDOR, 33555)

	-- Durotar Scorpion -- 62513
	AddPet(62513, 44973, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62513, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 62513, A_VENDOR, 33553)

	-- Elwynn Lamb -- 62516
	AddPet(62516, 44974, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62516, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 62516, A_VENDOR, 33307)

	-- Mulgore Hatchling -- 62542
	AddPet(62542, 44980, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62542, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 62542, A_VENDOR, 33556)

	-- Ammen Vale Lashling -- 62562
	AddPet(62562, 44984, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62562, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 62562, A_VENDOR, 33657)

	-- Enchanted Broom -- 62564
	AddPet(62564, 44982, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62564, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 62564, A_VENDOR, 33557)

	-- Mechanopeep -- 62674
	AddPet(62674, 45002, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 62674, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 62674, A_VENDOR, 33650)

	-- Sen'jin Fetish -- 63712
	AddPet(63712, 45606, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 63712, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 63712, A_VENDOR, 33554)

--REP VENDOR NEUTRAL
	-- Tiny Sporebat - 45082
	AddPet(45082, 34478, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 45082, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOP, F_SPOREGGAR)
	self:AddCompanionAcquire(PetDB, 45082, A_REPUTATION, 970, EXALTED, 18382)

	-- Nether Ray Fry - 51716
	AddPet(51716, 38628, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 51716, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOP, F_SKYGUARD)
	self:AddCompanionAcquire(PetDB, 51716, A_REPUTATION, 1031, EXALTED, 23367)

	-- Tickbird Hatchling -- 61348
	AddPet(61348, 39896, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 61348, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOP, F_ORACLES)
	self:AddCompanionAcquire(PetDB, 61348, A_REPUTATION, 1105, REVERED, 31910, A_CUSTOM, 16)

	-- White Tickbird Hatchling -- 61349
	AddPet(61349, 39899, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 61349, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOP, F_ORACLES)
	self:AddCompanionAcquire(PetDB, 61349, A_REPUTATION, 1105, REVERED, 31910, A_CUSTOM, 16)

	-- Proto-Drake Whelp -- 61350
	AddPet(61350, 44721, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 61350, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOP, F_ORACLES)
	self:AddCompanionAcquire(PetDB, 61350, A_REPUTATION, 1105, REVERED, 31910, A_CUSTOM, 16)

	-- Cobra Hatchling -- 61351
	AddPet(61351, 39898, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 61351, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOP, F_ORACLES)
	self:AddCompanionAcquire(PetDB, 61351, A_REPUTATION, 1105, REVERED, 31910, A_CUSTOM, 16)

	-- Nurtured Penguin Egg - 61357
	AddPet(61357, 44723, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 61357, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOP, F_KALUAK)
	self:AddCompanionAcquire(PetDB, 61357, A_REPUTATION, 1073, EXALTED, 31916, A_REPUTATION, 1073, EXALTED, 32763)

--VENDOR NEUTRAL
	-- Parrot Cage (Cockatiel) - 10680
	AddPet(10680, 8496, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10680, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10680, A_VENDOR, 2663)

	-- Parrot Cage (Senegal) - 10684
	AddPet(10684, 8495, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10684, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10684, A_VENDOR, 2663, A_VENDOR, 20980)

	-- Ancona Chicken - 10685
	AddPet(10685, 11023, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10685, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10685, A_VENDOR, 6548)

	-- Wood Frog Box - 10703
	AddPet(10703, 11027, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10703, F_ALLIANCE, F_HORDE, F_VENDOR, F_SEASONAL, F_BOE)
	self:AddCompanionAcquire(PetDB, 10703, A_VENDOR, 14860, A_SEASONAL, 3)

	-- Tree Frog Box - 10704
	AddPet(10704, 11026, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10704, F_ALLIANCE, F_HORDE, F_VENDOR, F_SEASONAL, F_BOE)
	self:AddCompanionAcquire(PetDB, 10704, A_VENDOR, 14860, A_SEASONAL, 3)

	-- Crimson Snake - 10717
	AddPet(10717, 10392, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10717, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10717, A_VENDOR, 8404, A_VENDOR, 20980)

	-- Mana Wyrmling - 35156
	AddPet(35156, 29363, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 35156, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 35156, A_VENDOR, 20980)

	-- Brown Rabbit Crate - 35239
	AddPet(35239, 29364, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 35239, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 35239, A_VENDOR, 20980)

	-- Red Moth Egg - 35909
	AddPet(35909, 29902, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 35909, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 35909, A_VENDOR, 20980)

	-- Blue Dragonhawk Hatchling - 36031
	AddPet(36031, 29958, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 36031, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 36031, A_VENDOR, 20980)

	-- Ghostly Skull - 53316
	AddPet(53316, 39973, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 53316, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOP)
	self:AddCompanionAcquire(PetDB, 53316, A_VENDOR, 29537)

	-- Obsidian Hatchling
	AddPet(67417, 48120, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 67417, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 67417, A_VENDOR, 28951)

	-- Blue Clockwork Rocket Bot
	AddPet(75134, 54436, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 75134, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOP)
	self:AddCompanionAcquire(PetDB, 75134, A_VENDOR, 29478, A_VENDOR, 29716)

--VENDOR HORDE
	-- Cockroach - 10688
	AddPet(10688, 10393, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10688, F_ALLIANCE, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10688, A_VENDOR, 8403, A_VENDOR,20980)

	-- Prairie Dog Whistle - 10709
	AddPet(10709, 10394, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10709, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10709, A_VENDOR, 8401)

	-- Black Kingsnake - 10714
	AddPet(10714, 10360, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10714, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10714, A_VENDOR, 8404)

	-- Brown Snake - 10716
	AddPet(10716, 10361, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10716, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10716, A_VENDOR, 8404)

	-- Golden Dragonhawk Hatchling - 36027
	AddPet(36027, 29953, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 36027, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 36027, A_VENDOR, 16860)

	-- Red Dragonhawk Hatchling - 36028
	AddPet(36028, 29956, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 36028, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 36028, A_VENDOR, 16860)

	-- Silver Dragonhawk Hatchling - 36029
	AddPet(36029, 29957, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 36029, F_HORDE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 36029, A_VENDOR, 16860)

--VENDOR ALLIANCE
	-- Cat Carrier (Bombay) - 10673
	AddPet(10673, 8485, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10673, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10673, A_VENDOR, 6367)

	-- Cat Carrier (Cornish Rex) - 10674
	AddPet(10674, 8486, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10674, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10674, A_VENDOR, 6367)

	-- Cat Carrier (Orange Tabby) - 10676
	AddPet(10676, 8487, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10676, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10676, A_VENDOR,6367)

	-- Cat Carrier (Silver Tabby) - 10678
	AddPet(10678, 8488, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10678, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10678, A_VENDOR,6367)

	-- Cat Carrier (White Kitten) - 10679
	AddPet(10679, 8489, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10679, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10679, A_VENDOR, 8666)

	-- Hawk Owl - 10706
	AddPet(10706, 8501, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10706, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10706, A_VENDOR, 8665)

	-- Great Horned Owl - 10707
	AddPet(10707, 8500, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10707, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10707, A_VENDOR, 8665)

	-- Rabbit Crate (Snowshoe) - 10711
	AddPet(10711, 8497, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 10711, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 10711, A_VENDOR, 1263)

	-- Blue Moth Egg - 35907
	AddPet(35907, 29901, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 35907, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 35907, A_VENDOR, 21019)

	-- Yellow Moth Egg - 35910
	AddPet(35910, 29903, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 35910, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 35910, A_VENDOR, 21019)

	-- White Moth Egg - 35911
	AddPet(35911, 29904, R_COMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 35911, F_ALLIANCE, F_VENDOR, F_BOE)
	self:AddCompanionAcquire(PetDB, 35911, A_VENDOR, 21019)

--RETIRED
	-- Spirit of Competition - 48406
	AddPet(48406, 37297, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 48406, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_REMOVED, F_BOA)
	self:AddCompanionAcquire(PetDB, 48406, A_ACHIEVEMENT, 1637)

	-- Essence of Competition - 48408
	AddPet(48408, nil, R_UNCOMMON, GAME_TBC)
	self:AddCompanionFlags(PetDB, 48408, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_REMOVED, F_BOA)
	self:AddCompanionAcquire(PetDB, 48408, A_CUSTOM, 13)

	-- Vampiric Batling - 51851
	AddPet(51851, 38658, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 51851, F_ALLIANCE, F_HORDE, F_RAID, F_MOB_DROP, F_SPEC_EVENT, F_REMOVED, F_BOP)
	self:AddCompanionAcquire(PetDB, 51851, A_ACHIEVEMENT, 2456, A_MOB, 28194)

	-- Baby Blizzard Bear - 61855
	AddPet(61855, 44819, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 61855, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_ACHIEVEMENT, F_REMOVED, F_BOA)
	self:AddCompanionAcquire(PetDB, 61855, A_ACHIEVEMENT, 2398)

	-- Murkimus' Little Spear - 63318
	AddPet(63318, 45180, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 63318, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_REMOVED, F_PVP, F_BOA)
	self:AddCompanionAcquire(PetDB, 63318, A_ACHIEVEMENT, 3618, A_CUSTOM, 21)

	-- Onyxian Whelpling - 69002
	AddPet(69002, 49362, R_COMMON, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 69002, F_ALLIANCE, F_HORDE, F_ACHIEVEMENT, F_SPEC_EVENT, F_REMOVED, F_BOA)
	self:AddCompanionAcquire(PetDB, 69002, A_ACHIEVEMENT, 4400)

	-- Mr. Chilly - 55068
	AddPet(55068, 41133, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 55068, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_REMOVED, F_BOA)
	self:AddCompanionAcquire(PetDB, 55068, A_CUSTOM, 28)


--COLLECTORS EDITION
	-- Diablo Stone - 17708
	AddPet(17708, 13584, R_RARE, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 17708, F_ALLIANCE, F_HORDE, F_COLLECTORS, F_BOA)
	self:AddCompanionAcquire(PetDB, 17708, A_ACHIEVEMENT, 662)

	-- Panda Collar - 17707
	AddPet(17707, 13583, R_RARE, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 17707, F_ALLIANCE, F_HORDE, F_COLLECTORS, F_BOA)
	self:AddCompanionAcquire(PetDB, 17707, A_ACHIEVEMENT, 663)

	-- Zergling Leash - 17709
	AddPet(17709, 13582, R_RARE, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 17709, F_ALLIANCE, F_HORDE, F_COLLECTORS, F_BOA)
	self:AddCompanionAcquire(PetDB, 17709, A_ACHIEVEMENT, 664)

	-- Lurky's Egg - 24988
	AddPet(24988, 30360, R_RARE, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 24988, F_ALLIANCE, F_HORDE, F_COLLECTORS, F_BOA)
	self:AddCompanionAcquire(PetDB, 24988, A_CUSTOM, 10)

	-- Netherwhelp's Collar - 32298
	AddPet(32298, 25535, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 32298, F_ALLIANCE, F_HORDE, F_COLLECTORS, F_BOA)
	self:AddCompanionAcquire(PetDB, 32298, A_ACHIEVEMENT, 665)

	-- Frosty's Collar - 52615
	AddPet(52615, 39286, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 52615, F_ALLIANCE, F_HORDE, F_COLLECTORS, F_BOA)
	self:AddCompanionAcquire(PetDB, 52615, A_ACHIEVEMENT, 683)

	-- Mini Thor - 78381
	AddPet(78381, 56806, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 78381, F_ALLIANCE, F_HORDE, F_COLLECTORS, F_BOA)
	self:AddCompanionAcquire(PetDB, 78381, A_ACHIEVEMENT, 4824)

--BLIZZ CON
	-- Blue Murloc Egg - 24696 (Murky)
	AddPet(24696, 20371, R_RARE, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 24696, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_BOA)
	self:AddCompanionAcquire(PetDB, 24696, A_ACHIEVEMENT, 411)

	-- Heavy Murloc Egg
	AddPet(66030, 45180, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 66030, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_BOP)
	self:AddCompanionAcquire(PetDB, 66030, A_ACHIEVEMENT, 3536)

--PROMO
	-- Pink Murloc Egg - 27241 (Gurky)
	AddPet(27241, 22114, R_RARE, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 27241, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_BOA)
	self:AddCompanionAcquire(PetDB, 27241, A_CUSTOM, 6)

	-- Polar Bear Collar - 28505 (Poley)
	AddPet(28505, 22781, R_COMMON, GAME_ORIG)
	self:AddCompanionFlags(PetDB, 28505, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_REMOVED, F_BOA)
	self:AddCompanionAcquire(PetDB, 28505, A_CUSTOM, 7)

	-- Fortune Coin - 40405 (Lucky)
	AddPet(40405, 32498, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 40405, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_REMOVED, F_BOA)
	self:AddCompanionAcquire(PetDB, 40405, A_CUSTOM, 12)

	-- Tyrael's Hilt - 53082
	AddPet(53082, 39656, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 53082, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_BOA)
	self:AddCompanionAcquire(PetDB, 53082, A_ACHIEVEMENT, 414)

	-- Warbot
	AddPet(65682, 46767, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 65682, F_ALLIANCE, F_HORDE, F_SPEC_EVENT, F_REMOVED, F_BOP)
	self:AddCompanionAcquire(PetDB, 65682, A_CUSTOM, 24)

--TCG
	-- Banana Charm - 40549
	AddPet(40549, 32588, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 40549, F_ALLIANCE, F_HORDE, F_TCG, F_BOP)
	self:AddCompanionAcquire(PetDB, 40549, A_CUSTOM, 1)

	-- Rocket Chicken - 45125
	AddPet(45125, 34492, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 45125, F_ALLIANCE, F_HORDE, F_TCG, F_BOP)
	self:AddCompanionAcquire(PetDB, 45125, A_CUSTOM, 1)

	-- Dragon Kite - 45127
	AddPet(45127, 34493, R_EPIC, GAME_TBC)
	self:AddCompanionFlags(PetDB, 45127, F_ALLIANCE, F_HORDE, F_TCG, F_BOP)
	self:AddCompanionAcquire(PetDB, 45127, A_CUSTOM, 1)

	-- Hippogryph Hatchling - 30156
	AddPet(30156, 23713, R_EPIC, GAME_TBC)
	self:AddCompanionFlags(PetDB, 30156, F_ALLIANCE, F_HORDE, F_TCG, F_BOP)
	self:AddCompanionAcquire(PetDB, 30156, A_CUSTOM, 1)

	-- Soul-Trader Beacon - 49964
	AddPet(49964, 38050, R_RARE, GAME_TBC)
	self:AddCompanionFlags(PetDB, 49964, F_ALLIANCE, F_HORDE, F_TCG, F_BOP)
	self:AddCompanionAcquire(PetDB, 49964, A_CUSTOM, 1)

	-- Tuskarr Kite - 68767
	AddPet(68767, 49287, R_EPIC, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 68767, F_ALLIANCE, F_HORDE, F_TCG, F_BOP)
	self:AddCompanionAcquire(PetDB, 68767, A_CUSTOM, 1)

	-- Spectral Tiger Cub - 68810
	AddPet(68810, 49343, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 68810, F_ALLIANCE, F_HORDE, F_TCG, F_BOP)
	self:AddCompanionAcquire(PetDB, 68810, A_CUSTOM, 1)

--PURCHASED
	-- Lil' K.T. - 69677
	AddPet(69677, 49693, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 69677, F_ALLIANCE, F_HORDE, F_STORE, F_BOA)
	self:AddCompanionAcquire(PetDB, 69677, A_CUSTOM, 4)

	-- Pandaren Monk - 69541
	AddPet(69541, 49665, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 69541, F_ALLIANCE, F_HORDE, F_STORE, F_BOA)
	self:AddCompanionAcquire(PetDB, 69541, A_CUSTOM, 4)

	-- Gryphon Hatchling - 69535
	AddPet(69535, 49662, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 69535, F_ALLIANCE, F_HORDE, F_STORE, F_BOA)
	self:AddCompanionAcquire(PetDB, 69535, A_CUSTOM, 4)

	-- Wind Rider Cub - 69536
	AddPet(69536, 49663, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 69536, F_ALLIANCE, F_HORDE, F_STORE, F_BOA)
	self:AddCompanionAcquire(PetDB, 69536, A_CUSTOM, 4)

	-- Lil' XT - 75906
	AddPet(75906, 54847, R_RARE, GAME_WOTLK)
	self:AddCompanionFlags(PetDB, 75906, F_ALLIANCE, F_HORDE, F_STORE, F_BOA)
	self:AddCompanionAcquire(PetDB, 75906, A_CUSTOM, 4)

	-- We only add the faction specific pets if the user is part of that faction
	if MY_FACTION == FACTION_ALLIANCE then
		-- Shimmering Wyrmling -- 66096
		AddPet(66096, 46820, R_RARE, GAME_WOTLK)
		self:AddCompanionFlags(PetDB, 66096, F_ALLIANCE, F_VENDOR, F_BOE, WRATHCOMMON1)
		self:AddCompanionAcquire(PetDB, 66096, A_REPUTATION, 1094, EXALTED, 34881)

	elseif MY_FACTION == FACTION_HORDE then
		-- Shimmering Wyrmling -- 66096
		AddPet(66096, 46821, R_RARE, GAME_WOTLK)
		self:AddCompanionFlags(PetDB, 66096, F_HORDE, F_VENDOR, F_BOE, WRATHCOMMON1)
		self:AddCompanionAcquire(PetDB, 66096, A_REPUTATION, 1124, EXALTED, 34772)
	end
	return num_pets
end
