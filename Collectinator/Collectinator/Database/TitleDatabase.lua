--------------------------------------------------------------------------------------------------------------------
-- ./DB/TitleDatabase.lua
-- Title Database data for all of Collectinator
--------------------------------------------------------------------------------------------------------------------
-- File date: 2010-02-23T16:09:24Z
-- Project version: v1.0.4
--------------------------------------------------------------------------------------------------------------------
-- Please see http://www.wowace.com/projects/collectinator/for more information.
--------------------------------------------------------------------------------------------------------------------
-- License:
-- Please see LICENSE.txt
-- This source code is released under All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------

local MODNAME		= "Collectinator"
local addon		= LibStub("AceAddon-3.0"):GetAddon(MODNAME)
local BF		= LibStub("LibBabble-Faction-3.0"):GetLookupTable()

local FACTION_ALLIANCE	= BF["Alliance"]
local FACTION_HORDE	= BF["Horde"]

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
local F_WRATHCOMMON1, F_WRATHCOMMON2, F_WRATHCOMMON3, F_WRATHCOMMON4, F_WRATHCOMMON5 = 64, 65, 66, 67, 68
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

-------------------------------------------------------------------------------
-- Class types
-------------------------------------------------------------------------------
local C_DK, C_DRUID, C_HUNTER, C_MAGE, C_PALADIN, C_PRIEST, C_ROGUE, C_SHAMAN, C_WARLOCK, C_WARRIOR = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

local MY_CLASS = select(2, UnitClass("player"))
local MY_FACTION = UnitFactionGroup("player")

local initialized = false
local num_titles = 0
--http://www.wowwiki.com/TitleId

function addon:GetTitleTotal(DB)
	if initialized then
		return num_titles
	end
	initialized = true

	-------------------------------------------------------------------------------
	-- Wrapper function
	-------------------------------------------------------------------------------
	local function AddTitle(TitleID)
		addon:AddCompanion(DB, "TITLE", TitleID)
		num_titles = num_titles + 1
	end

	AddTitle(1)
	self:AddCompanionFlags(1, F_ALLIANCE, F_PVP, F_RETIRED)

	AddTitle(2)
	self:AddCompanionFlags(2, F_ALLIANCE, F_PVP, F_RETIRED)

	AddTitle(3)
	self:AddCompanionFlags(3, F_ALLIANCE, F_PVP, F_RETIRED)

	AddTitle(4)
	--self:AddCompanionFlags(4

	AddTitle(5)
	--self:AddCompanionFlags(5

	AddTitle(6)
	--self:AddCompanionFlags(6

	AddTitle(7)
	--self:AddCompanionFlags(7

	AddTitle(8)
	--self:AddCompanionFlags(8

	AddTitle(9)
	--self:AddCompanionFlags(9

	AddTitle(10)
	--self:AddCompanionFlags(10

	AddTitle(11)
	--self:AddCompanionFlags(11

	AddTitle(12)
	--self:AddCompanionFlags(12

	AddTitle(13)
	--self:AddCompanionFlags(13

	AddTitle(14)
	--self:AddCompanionFlags(14

	AddTitle(15)
	--self:AddCompanionFlags(15

	AddTitle(16)
	--self:AddCompanionFlags(16

	AddTitle(17)
	--self:AddCompanionFlags(17

	AddTitle(18)
	--self:AddCompanionFlags(18

	AddTitle(19)
	--self:AddCompanionFlags(19

	AddTitle(20)
	--self:AddCompanionFlags(20

	AddTitle(21)
	--self:AddCompanionFlags(21

	AddTitle(22)
	--self:AddCompanionFlags(22

	AddTitle(23)
	--self:AddCompanionFlags(23

	AddTitle(24)
	--self:AddCompanionFlags(24

	AddTitle(25)
	--self:AddCompanionFlags(25

	AddTitle(26)
	--self:AddCompanionFlags(26

	AddTitle(27)
	--self:AddCompanionFlags(27

	AddTitle(28)
	--self:AddCompanionFlags(28

	AddTitle(29)
	--self:AddCompanionFlags(29

	AddTitle(30)
	--self:AddCompanionFlags(30

	AddTitle(31)
	--self:AddCompanionFlags(31

	AddTitle(32)
	--self:AddCompanionFlags(32

	AddTitle(33)
	--self:AddCompanionFlags(33

	AddTitle(34)
	--self:AddCompanionFlags(34

	AddTitle(35)
	--self:AddCompanionFlags(35

	AddTitle(36)
	--self:AddCompanionFlags(36

	AddTitle(37)
	--self:AddCompanionFlags(37

	AddTitle(38)
	--self:AddCompanionFlags(38

	AddTitle(39)
	--self:AddCompanionFlags(39

	AddTitle(40)
	--self:AddCompanionFlags(40

	AddTitle(41)
	--self:AddCompanionFlags(41

	AddTitle(42)
	--self:AddCompanionFlags(42

	AddTitle(43)
	--self:AddCompanionFlags(43

	AddTitle(44)
	--self:AddCompanionFlags(44

	AddTitle(45)
	--self:AddCompanionFlags(45

	AddTitle(46)
	--self:AddCompanionFlags(46

	AddTitle(47)
	--self:AddCompanionFlags(47

	AddTitle(48)
	--self:AddCompanionFlags(48

	AddTitle(49)
	--self:AddCompanionFlags(49

	AddTitle(50)
	--self:AddCompanionFlags(50

	AddTitle(51)
	--self:AddCompanionFlags(51

	AddTitle(52)
	--self:AddCompanionFlags(52

	AddTitle(53)
	--self:AddCompanionFlags(53

	AddTitle(54)
	--self:AddCompanionFlags(54

	AddTitle(55)
	--self:AddCompanionFlags(55

	AddTitle(56)
	--self:AddCompanionFlags(56

	AddTitle(57)
	--self:AddCompanionFlags(57

	AddTitle(58)
	--self:AddCompanionFlags(58

	AddTitle(59)
	--self:AddCompanionFlags(59

	AddTitle(60)
	--self:AddCompanionFlags(60

	AddTitle(61)
	--self:AddCompanionFlags(61

	AddTitle(62)
	--self:AddCompanionFlags(62

	AddTitle(63)
	--self:AddCompanionFlags(63

	AddTitle(64)
	--self:AddCompanionFlags(64

	AddTitle(65)
	--self:AddCompanionFlags(65

	AddTitle(66)
	--self:AddCompanionFlags(66

	AddTitle(67)
	--self:AddCompanionFlags(67

	AddTitle(68)
	--self:AddCompanionFlags(68

	AddTitle(69)
	--self:AddCompanionFlags(69

	AddTitle(70)
	--self:AddCompanionFlags(70

	AddTitle(71)
	--self:AddCompanionFlags(71

	AddTitle(72)
	--self:AddCompanionFlags(72

	AddTitle(73)
	--self:AddCompanionFlags(73

	AddTitle(74)
	--self:AddCompanionFlags(74

	AddTitle(75)
	--self:AddCompanionFlags(75

	AddTitle(76)
	--self:AddCompanionFlags(76

	AddTitle(77)
	--self:AddCompanionFlags(77

	AddTitle(78)
	--self:AddCompanionFlags(78

	AddTitle(79)
	--self:AddCompanionFlags(79

	AddTitle(80)
	--self:AddCompanionFlags(80

	AddTitle(81)
	--self:AddCompanionFlags(81

	AddTitle(82)
	--self:AddCompanionFlags(82

	AddTitle(83)
	--self:AddCompanionFlags(83

	AddTitle(84)
	--self:AddCompanionFlags(84

	AddTitle(85)
	--self:AddCompanionFlags(85

	AddTitle(86)
	--self:AddCompanionFlags(86

	AddTitle(87)
	--self:AddCompanionFlags(87

	AddTitle(88)
	--self:AddCompanionFlags(88

	AddTitle(89)
	--self:AddCompanionFlags(89

	AddTitle(90)
	--self:AddCompanionFlags(90

	AddTitle(91)
	--self:AddCompanionFlags(91

	AddTitle(92)
	--self:AddCompanionFlags(92

	AddTitle(93)
	--self:AddCompanionFlags(93

	AddTitle(94)
	--self:AddCompanionFlags(94

	AddTitle(95)
	--self:AddCompanionFlags(95

	AddTitle(96)
	--self:AddCompanionFlags(96

	AddTitle(97)
	--self:AddCompanionFlags(97

	AddTitle(98)
	--self:AddCompanionFlags(98

	AddTitle(99)
	--self:AddCompanionFlags(99

	AddTitle(100)
	--self:AddCompanionFlags(100

	AddTitle(101)
	--self:AddCompanionFlags(101

	--self:AddCompanionFlags(101,

	AddTitle(102)
	--self:AddCompanionFlags(102

	AddTitle(103)
	--self:AddCompanionFlags(103

	AddTitle(104)
	--self:AddCompanionFlags(104

	AddTitle(105)
	--self:AddCompanionFlags(105

	AddTitle(106)
	--self:AddCompanionFlags(106

	AddTitle(107)
	--self:AddCompanionFlags(107

	AddTitle(108)
	--self:AddCompanionFlags(108

	AddTitle(109)
	--self:AddCompanionFlags(109

	AddTitle(110)
	--self:AddCompanionFlags(110

	AddTitle(111)
	--self:AddCompanionFlags(111

	AddTitle(112)
	--self:AddCompanionFlags(112

	AddTitle(113)
	--self:AddCompanionFlags(113

	AddTitle(114)
	--self:AddCompanionFlags(114

	AddTitle(115)
	--self:AddCompanionFlags(115

	AddTitle(116)
	--self:AddCompanionFlags(116

	AddTitle(117)
	--self:AddCompanionFlags(117

	AddTitle(118)
	--self:AddCompanionFlags(118

	AddTitle(119)
	--self:AddCompanionFlags(119

	AddTitle(120)
	--self:AddCompanionFlags(120

	AddTitle(121)
	--self:AddCompanionFlags(121

	AddTitle(122)
	--self:AddCompanionFlags(122

	AddTitle(123)
	--self:AddCompanionFlags(123

	AddTitle(124)
	--self:AddCompanionFlags(124

	AddTitle(125)
	--self:AddCompanionFlags(125

	AddTitle(126)
	--self:AddCompanionFlags(126

	AddTitle(127)
	--self:AddCompanionFlags(127

	AddTitle(128)
	--self:AddCompanionFlags(128

	AddTitle(129)
	--self:AddCompanionFlags(129

	AddTitle(130)
	--self:AddCompanionFlags(130

	AddTitle(131)
	--self:AddCompanionFlags(131

	AddTitle(132)
	--self:AddCompanionFlags(132

	AddTitle(133)
	--self:AddCompanionFlags(133

	AddTitle(134)
	--self:AddCompanionFlags(134

	AddTitle(135)
	--self:AddCompanionFlags(135

	AddTitle(136)
	--self:AddCompanionFlags(136

	AddTitle(137)
	--self:AddCompanionFlags(137

	AddTitle(138)
	--self:AddCompanionFlags(138

	AddTitle(139)
	--self:AddCompanionFlags(139

	AddTitle(140)
	--self:AddCompanionFlags(140

	AddTitle(141)
	--self:AddCompanionFlags(141

	AddTitle(142)
	--self:AddCompanionFlags(142


	return num_titles
end
