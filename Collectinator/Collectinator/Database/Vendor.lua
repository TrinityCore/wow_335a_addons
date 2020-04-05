-------------------------------------------------------------------------------
-- Vendor.lua
-------------------------------------------------------------------------------
-- Vendor data for all of Collectinator
-------------------------------------------------------------------------------
-- File date: 2010-04-22T18:21:37Z
-- File revision: @file-revision@
-- Project revision: @project-revision@
-- Project version: v1.0.4
-- Format:	self:addLookupList(DB, NPC ID, NPC Name, NPC Location, X Coord, Y Coord, Faction)
-------------------------------------------------------------------------------
local MODNAME	= "Collectinator"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

local L		= LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local BZ	= LibStub("LibBabble-Zone-3.0"):GetLookupTable()
local BBOSS	= LibStub("LibBabble-Boss-3.0"):GetLookupTable()

function addon:InitVendor(DB)
	local NEUTRAL	= 0
	local ALLIANCE	= 1
	local HORDE	= 2

	-------------------------------------------------------------------------------
	-- Companions only
	-------------------------------------------------------------------------------
	self:addLookupList(DB, 1263,	L["Yarlyn Amberstill"],			BZ["Dun Morogh"],		63.2, 50.0,	ALLIANCE)
	self:addLookupList(DB, 2663,	L["Narkk"],				BZ["Stranglethorn Vale"],	28.2, 74.5,	NEUTRAL)
	self:addLookupList(DB, 6367,	L["Donni Anthania"],			BZ["Elwynn Forest"],		44.2, 53.4,	ALLIANCE)
	self:addLookupList(DB, 6548,	L["Magus Tirth"],			BZ["Thousand Needles"],		78.3, 75.7,	NEUTRAL)
	self:addLookupList(DB, 8401,	L["Halpa"],				BZ["Thunder Bluff"],		62.2, 58.5,	HORDE)
	self:addLookupList(DB, 8403,	L["Jeremiah Payson"],			BZ["Undercity"],		67.5, 44.6,	HORDE)
	self:addLookupList(DB, 8404,	L["Xan'tish"],				BZ["Orgrimmar"],		37.5, 74.6,	HORDE) -- Wanders
	self:addLookupList(DB, 8665,	L["Shylenai"],				BZ["Darnassus"],		69.8, 45.4,	ALLIANCE)
	self:addLookupList(DB, 8666,	L["Lil Timmy"],				BZ["Stormwind City"],		46.4, 55.5,	ALLIANCE) -- Wanders

	self:addLookupList(DB, 16860,	L["Jilanne"],				BZ["Eversong Woods"],		44.8, 71.8,	HORDE)
	self:addLookupList(DB, 17249,	L["Landro Longshot"],			BZ["Stranglethorn Vale"],	28.1, 75.8,	NEUTRAL)
	self:addLookupList(DB, 18382,	L["Mycah"],				BZ["Zangarmarsh"],		17.9, 51.2,	NEUTRAL)
	self:addLookupList(DB, 20980,	L["Dealer Rashaad"],			BZ["Netherstorm"],		43.5, 35.2,	NEUTRAL)
	self:addLookupList(DB, 21019,	L["Sixx"],				BZ["The Exodar"],		30.3, 34.0,	ALLIANCE)
	self:addLookupList(DB, 23367,	L["Grella"],				BZ["Terokkar Forest"],		64.3, 66.3,	NEUTRAL)
	self:addLookupList(DB, 28951,	L["Breanni"],				BZ["Dalaran"],			58.7, 39.5,	NEUTRAL)
	self:addLookupList(DB, 29478,	L["Jepetto Joybuzz"],				BZ["Dalaran"],			44.8, 46.5,	NEUTRAL)
	self:addLookupList(DB, 29716,	L["Clockwork Assistant"],				BZ["Dalaran"],			44.2, 46.5,	NEUTRAL)
	self:addLookupList(DB, 29537,	L["Darahir"],				BZ["Dalaran"],			63.7, 16.5,	NEUTRAL)
	self:addLookupList(DB, 31910,	L["Geen"],				BZ["Sholazar Basin"],		54.5, 56.2,	NEUTRAL)
	self:addLookupList(DB, 31916,	L["Tanaika"],				BZ["Howling Fjord"],		25.5, 58.7,	NEUTRAL)
	self:addLookupList(DB, 32763,	L["Sairuk"],				BZ["Dragonblight"],		48.5, 75.7,	NEUTRAL)

	-------------------------------------------------------------------------------
	-- World Events
	-------------------------------------------------------------------------------
	self:addLookupList(DB, 14860,	L["Flik"],				BZ["Terokkar Forest"],		33.7, 35.9,	NEUTRAL) --several places, Darkmoon, Wanders
	self:addLookupList(DB, 23710,	L["Belbi Quikswitch"],			BZ["Dun Morogh"],		49.3, 39.5,	ALLIANCE)
	self:addLookupList(DB, 24495,	L["Blix Fixwidget"],			BZ["Durotar"],			44.1, 17.9,	HORDE)
	self:addLookupList(DB, 27478,	L["Larkin Thunderbrew"],		BZ["Ironforge"],		18.8, 53.1,     ALLIANCE)
	self:addLookupList(DB, 27489,	L["Ray'ma"],				BZ["Orgrimmar"],		37.9, 85.6,     HORDE)

	self:addLookupList(DB, 33307,	L["Corporal Arthur Flew"],		BZ["Icecrown"],			76.5, 19.2,	ALLIANCE)
	self:addLookupList(DB, 33310,	L["Derrick Brindlebeard"],		BZ["Icecrown"],			76.5, 19.5,	ALLIANCE)
	self:addLookupList(DB, 33553,	L["Freka Bloodaxe"],			BZ["Icecrown"],			76.4, 24.4,	HORDE)
	self:addLookupList(DB, 33554,	L["Samamba"],				BZ["Icecrown"],			76.1, 24.5,	HORDE)
	self:addLookupList(DB, 33555,	L["Eliza Killian"],			BZ["Icecrown"],			76.5, 24.2,	HORDE)
	self:addLookupList(DB, 33556,	L["Doru Thunderhorn"],			BZ["Icecrown"],			76.2, 24.5,	HORDE)
	self:addLookupList(DB, 33557,	L["Trellis Morningsun"],		BZ["Icecrown"],			76.3, 23.9,	HORDE)
	self:addLookupList(DB, 33650,	L["Rillie Spindlenut"],			BZ["Icecrown"],			76.5, 19.7,	ALLIANCE)
	self:addLookupList(DB, 33653,	L["Rook Hawkfist"],			BZ["Icecrown"],			76.3, 49.2,	ALLIANCE)
	self:addLookupList(DB, 33657,	L["Irisee"],				BZ["Icecrown"],			76.2, 19.3,	ALLIANCE)
	self:addLookupList(DB, 34772,	L["Vasarin Redmorn"],			BZ["Icecrown"],			76.2, 24.0,	HORDE)
	self:addLookupList(DB, 34881,	L["Hiren Loresong"],			BZ["Icecrown"],			76.2, 19.6,	ALLIANCE)
	self:addLookupList(DB, 34885,	L["Dame Evniki Kapsalis"],		BZ["Icecrown"],			69.5, 23.2,	NEUTRAL)

	-------------------------------------------------------------------------------
	-- Mounts only
	-------------------------------------------------------------------------------
	self:addLookupList(DB, 384,	L["Katie Hunter"],			BZ["Elwynn Forest"],		84.1, 65.5,	ALLIANCE)
	self:addLookupList(DB, 1261,	L["Veron Amberstill"],			BZ["Dun Morogh"],		63.5, 50.7,	ALLIANCE)
	self:addLookupList(DB, 1460,	L["Unger Statforth"],			BZ["Wetlands"],			8.6, 54.5,	ALLIANCE)
	self:addLookupList(DB, 2357,	L["Merideth Carlson"],			BZ["Hillsbrad Foothills"],	52.1, 55.6,	ALLIANCE)
	self:addLookupList(DB, 3362,	L["Ogunaro Wolfrunner"],		BZ["Orgrimmar"],		69.3, 12.7,	HORDE)
	self:addLookupList(DB, 3685,	L["Harb Clawhoof"],			BZ["Mulgore"],			47.5, 58.5,	HORDE)
	self:addLookupList(DB, 4730,	L["Lelanai"],				BZ["Darnassus"],		38.3, 15.7,	ALLIANCE)
	self:addLookupList(DB, 4731,	L["Zachariah Post"],			BZ["Tirisfal Glades"],		59.9, 52.6,	HORDE)
	self:addLookupList(DB, 4885,	L["Gregor MacVince"],			BZ["Dustwallow Marsh"],		65.2, 51.5,	ALLIANCE)
	self:addLookupList(DB, 7952,	L["Zjolnir"],				BZ["Durotar"],			55.2, 75.6,	HORDE)
	self:addLookupList(DB, 7955,	L["Milli Featherwhistle"],		BZ["Dun Morogh"],		49.2, 48.0,	ALLIANCE)
	self:addLookupList(DB, 10618,	L["Rivern Frostwind"],			BZ["Winterspring"],		49.9, 9.9,	ALLIANCE)
	self:addLookupList(DB, 11701,	L["Mor'vek"],				BZ["Un'Goro Crater"],		71.5, 73.7,	HORDE)
	self:addLookupList(DB, 12783,	L["Lieutenant Karter"],			BZ["Stormwind City"],		74.7, 67.3,	ALLIANCE)
	self:addLookupList(DB, 12796,	L["Raider Bork"],			BZ["Orgrimmar"],		41.68, 68.33,	HORDE)
	self:addLookupList(DB, 13216,	L["Gaelden Hammersmith"],		BZ["Alterac Valley"],		44.2, 18.2,	ALLIANCE)
	self:addLookupList(DB, 13217,	L["Thanthaldis Snowgleam"],		BZ["Alterac Mountains"],	39.5, 81.7,	ALLIANCE)
	self:addLookupList(DB, 13218,	L["Grunnda Wolfheart"],			BZ["Alterac Valley"],		49.0, 85.5,	HORDE)
	self:addLookupList(DB, 13219,	L["Jekyll Flandring"],			BZ["Alterac Mountains"],	62.8, 59.4,	HORDE)
	self:addLookupList(DB, 16264,	L["Winaestra"],				BZ["Eversong Woods"],		61.0, 54.7,	HORDE)
	self:addLookupList(DB, 17584,	L["Torallius the Pack Handler"],	BZ["The Exodar"],		81.5, 52.0,	ALLIANCE)
	self:addLookupList(DB, 17904,	L["Fedryen Swiftspear"],		BZ["Zangarmarsh"],		79.3, 63.8,	NEUTRAL)
	self:addLookupList(DB, 20240,	L["Trader Narasu"],			BZ["Nagrand"],			54.6, 75.2,	ALLIANCE)
	self:addLookupList(DB, 20241,	L["Provisioner Nasela"],		BZ["Nagrand"],			53.5, 36.9,	HORDE)
	self:addLookupList(DB, 20494,	L["Dama Wildmane"],			BZ["Shadowmoon Valley"],	29.2, 29.5,	HORDE)
	self:addLookupList(DB, 20510,	L["Brunn Flamebeard"],			BZ["Shadowmoon Valley"],	37.6, 56.0,	ALLIANCE)
	self:addLookupList(DB, 21474,	L["Coreiel"],				BZ["Nagrand"],			42.8, 42.6,	HORDE)
	self:addLookupList(DB, 21485,	L["Aldraan"],				BZ["Nagrand"],			42.9, 42.5,	ALLIANCE)
	self:addLookupList(DB, 23489,	L["Drake Dealer Hurlunk"],		BZ["Shadowmoon Valley"],	65.6, 86.0,	NEUTRAL)
	self:addLookupList(DB, 24468,	L["Pol Amberstill"],			BZ["Dun Morogh"],		46.5, 40.4,	ALLIANCE)
	self:addLookupList(DB, 24510,	L["Driz Tumblequick"],			BZ["Durotar"],			46.3, 14.9,	HORDE)
	self:addLookupList(DB, 29587,	L["Dread Commander Thalanor"],		BZ["Eastern Plaguelands"],	84.1, 49.9,	NEUTRAL)
	self:addLookupList(DB, 32216,	L["Mei Francis"],			BZ["Dalaran"],			58.5, 42.6,	NEUTRAL)
	self:addLookupList(DB, 32294,	L["Knight Dameron"],			BZ["Wintergrasp"],		51.7, 17.5,	ALLIANCE)
	self:addLookupList(DB, 32296,	L["Stone Guard Mukar"],			BZ["Wintergrasp"],		51.7, 17.5,	HORDE)
	self:addLookupList(DB, 32533,	L["Cielstrasza"],			BZ["Dragonblight"],		59.9, 53.1,	NEUTRAL)
	self:addLookupList(DB, 32540,	L["Lillehoff"],				BZ["The Storm Peaks"],		66.2, 61.4,	NEUTRAL)
	self:addLookupList(DB, 35099,	L["Bana Wildmane"],			BZ["Hellfire Peninsula"],	54.2, 41.6,	HORDE)
	self:addLookupList(DB, 35101,	L["Grunda Bronzewing"],			BZ["Hellfire Peninsula"],	54.2, 62.6,	ALLIANCE)
	self:addLookupList(DB, 35131,	L["Durgan Thunderbeak"],		BZ["Borean Tundra"],		58.9, 68.2,	ALLIANCE)
	self:addLookupList(DB, 35132,	L["Tohfo Skyhoof"],			BZ["Borean Tundra"],		42.2, 55.3,	HORDE)

	-------------------------------------------------------------------------------
	-- Warlock trainers.
	-------------------------------------------------------------------------------
	self:addLookupList(DB, 16646,	L["Alamma"],				BZ["Silvermoon City"],	73.5, 46.6,	HORDE)
	self:addLookupList(DB, 5173,	L["Alexander Calder"],			BZ["Ironforge"],	50.1, 6.9,	ALLIANCE)
	self:addLookupList(DB, 23534,	L["Babagaya Shadowcleft"],		BZ["The Barrens"],	62.5, 35.5,	NEUTRAL)
	self:addLookupList(DB, 5172,	L["Briarthorn"],			BZ["Ironforge"],	50.3, 6.1,	ALLIANCE)
	self:addLookupList(DB, 16266,	L["Celoenus"],				BZ["Eversong Woods"],	48.2, 47.9,	HORDE)
	self:addLookupList(DB, 461,	L["Demisette Cloyce"],			BZ["Stormwind City"],	39.7, 84.5,	ALLIANCE)
	self:addLookupList(DB, 3172,	L["Dhugru Gorelust"],			BZ["Durotar"],		54.3, 41.2,	HORDE)
	self:addLookupList(DB, 5612,	L["Gimrizz Shadowcog"],			BZ["Dun Morogh"],	47.3, 53.7,	ALLIANCE)
	self:addLookupList(DB, 3324,	L["Grol'dar"],				BZ["Orgrimmar"],	48.1, 46.2,	HORDE)
	self:addLookupList(DB, 4563,	L["Kaal Soulreaper"],			BZ["Undercity"],	86.0, 15.7,	HORDE)
	self:addLookupList(DB, 988,	L["Kartosh"],				BZ["Swamp of Sorrows"],	48.5, 55.5,	HORDE)
	self:addLookupList(DB, 4564,	L["Luther Pickman"],			BZ["Undercity"],	86.2, 15.3,	HORDE)
	self:addLookupList(DB, 906,	L["Maximillian Crowe"],			BZ["Elwynn Forest"],	44.5, 66.1,	ALLIANCE)
	self:addLookupList(DB, 3325,	L["Mirket"],				BZ["Orgrimmar"],	48.5, 47.0,	HORDE)
	self:addLookupList(DB, 4565,	L["Richard Kerwin"],			BZ["Undercity"],	88.7, 16.0,	HORDE)
	self:addLookupList(DB, 2127,	L["Rupert Boch"],			BZ["Tirisfal Glades"],	61.6, 52.5,	HORDE)
	self:addLookupList(DB, 5496,	L["Sandahl"],				BZ["Stormwind City"],	39.8, 85.4,	ALLIANCE)
	self:addLookupList(DB, 6251,	L["Strahad Farsan"],			BZ["The Barrens"],	62.6, 35.5,	NEUTRAL)
	self:addLookupList(DB, 16647,	L["Talionia"],				BZ["Silvermoon City"],	74.5, 46.9,	HORDE)
	self:addLookupList(DB, 5171,	L["Thistleheart"],			BZ["Ironforge"],	50.8, 6.7,	ALLIANCE)
	self:addLookupList(DB, 5495,	L["Ursula Deline"],			BZ["Stormwind City"],	40.0, 84.3,	ALLIANCE)
	self:addLookupList(DB, 16648,	L["Zanien"],				BZ["Silvermoon City"],	73.5, 44.5,	HORDE)
	self:addLookupList(DB, 3326,	L["Zevrost"],				BZ["Orgrimmar"],	48.3, 45.6,	HORDE)
end
