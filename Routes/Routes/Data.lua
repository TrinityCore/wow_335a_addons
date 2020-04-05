local Routes = LibStub("AceAddon-3.0"):GetAddon("Routes")

--[[
	Copied directly from GatherMate's Constants.lua
	Zone data for heigth, width, and gathermate ID
]]
local zone_data = { -- {width, height, zoneID}
	Arathi = {3599.78645678886,2399.85763785924,1,},
	Ogrimmar = {1402.563051365538,935.042034243692,2,},
	--EasternKingdoms = {37649.15159852673,25099.43439901782,3,},
	Undercity = {959.3140238076666,639.5426825384444,4,},
	Barrens = {10132.98626357964,6755.32417571976,5,},
	Darnassis = {1058.300884213672,705.5339228091146,6,},
	AzuremystIsle = {4070.691916244019, 2713.794610829346,7,},
	UngoroCrater = {3699.872808671186,2466.581872447457,8,},
	BurningSteppes = {2928.988452241535,1952.658968161023,9,},
	Wetlands = {4135.166184805389,2756.777456536926,10,},
	Winterspring = {7099.756078049357,4733.170718699571,11,},
	Dustwallow = {5249.824712249077,3499.883141499384,12,},
	Darkshore = {6549.780280774227,4366.520187182819,13,},
	LochModan = {2758.158752877019,1838.772501918013,14,},
	BladesEdgeMountains = {5424.84803598309,3616.56535732206,15,},
	Durotar = {5287.285801274457,3524.857200849638,16,},
	Silithus = {3483.224287356748,2322.149524904499,17,},
	ShattrathCity = {1306.210386847456,870.8069245649707,18,},
	Ashenvale = {5766.471113365881,3844.314075577254,19,},
	--Azeroth = {44531.82907938571,29687.8860529238,20,},
	Nagrand = {5524.827295176373,3683.218196784248,21,},
	TerokkarForest = {5399.832305361811,3599.888203574541,22,},
	EversongWoods = {4924.70470173181,3283.136467821207,23,},
	SilvermoonCity = {1211.384457945605,807.5896386304033,24,},
	Tanaris = {6899.765399158026,4599.843599438685,25,},
	Stormwind = {1344.138055148283,896.092036765522,26,},
	SwampOfSorrows = {2293.606089974149,1529.070726649433,27,},
	EasternPlaguelands = {3870.596078314358,2580.397385542905,28,},
	BlastedLands = {3349.808966078055,2233.20597738537,29,},
	Elwynn = {3470.62593362794,2313.750622418627,30,},
	DeadwindPass = {2499.848163715574,1666.565442477049,31,},
	DunMorogh = {4924.664537147015,3283.109691431343,32,},
	TheExodar = {1056.732317707213,704.4882118048087,33,},
	Felwood = {5749.8046476606,3833.2030984404,34,},
	Silverpine = {4199.739879721531,2799.826586481021,35,},
	ThunderBluff = {1043.762849319158,695.8418995461053,36,},
	Hinterlands = {3849.77134323942,2566.51422882628,37,},
	StonetalonMountains = {4883.173287670144,3255.448858446763,38,},
	Mulgore = {5137.32138887616,3424.88092591744,39,},
	Hellfire = {5164.421615455519,3442.947743637013,40,},
	Ironforge = {790.5745810546713,527.0497207031142,41,},
	ThousandNeedles = {4399.86408093722,2933.242720624814,42,},
	Stranglethorn = {6380.866711475876,4253.911140983918,43,},
	Badlands = {2487.343589680943,1658.229059787295,44,},
	Teldrassil = {5091.467863261982,3394.311908841321,45,},
	Moonglade = {2308.253559286662,1538.835706191108,46,},
	ShadowmoonValley = {5499.827432644566,3666.551621763044,47,},
	Tirisfal = {4518.469744413802,3012.313162942535,48,},
	Aszhara = {5070.669448432522,3380.446298955014,49,},
	Redridge = {2170.704876735185,1447.136584490123,50,},
	BloodmystIsle = {3262.385067990556,2174.92337866037,51,},
	WesternPlaguelands = {4299.7374000546,2866.4916000364,52,},
	Alterac = {2799.820894040741,1866.547262693827,53,},
	Westfall = {3499.786489780177,2333.190993186784,54,},
	Duskwood = {2699.837284973949,1799.891523315966,55,},
	Netherstorm = {5574.82788866266,3716.551925775107,56,},
	Ghostlands = {3299.755735439147,2199.837156959431,57,},
	Zangarmarsh = {5026.925554043871,3351.283702695914,58,},
	Desolace = {4495.726850591814,2997.151233727876,59,},
	--Kalimdor = {36798.56388065484,24532.37592043656,60,},
	SearingGorge = {2231.119799153945,1487.413199435963,61,},
	--Expansion01 = {17463.5328406368,11642.3552270912,62,},
	Feralas = {6949.760203962193,4633.173469308129,63,},
	Hilsbrad = {3199.802496078764,2133.201664052509,64,},
	Sunwell = {3327.0830078125,2218.7490234375,65,},
	-- Wrath Zones
	--[[ These valus derived from the dbc client files, they may change and/or are not final
	UtgardeKeep = {0.0,0.0},
	Nexus = {0.0,0.0},
	Dalaran = {0.0,0.0},
	--]]	
	Northrend = {17751.3984375,11834.2650146484,66,},
	BoreanTundra = {5764.5830088,3843.749878,67,},
	Dragonblight = {5608.33312988281,3739.58337402344,68,},
	GrizzlyHills = {5249.999878,3499.999878,69,},
	HowlingFjord = {6045.83288574219,4031.24981689453,70,},
	IcecrownGlacier = {6270.83331298828, 4181.25,71,},
	SholazarBasin = {4356.25,2904.166504,72,},
	TheStormPeaks = {7112.49963378906,4741.666015625,73,},
	ZulDrak = {4993.75,3329.166504,74,},
	LakeWintergrasp = {2974.99987792969,1983.33325195312,75,},
	ScarletEnclave = {3162.5,2108.333374,76,},
	CrystalsongForest = {2722.91662597656,1814.5830078125,77,},
	LakeWintergrasp = {2974.99987792969,1983.33325195312,78,},
	StrandoftheAncients = {1743.74993896484,1162.49993896484,79,},
	Dalaran = {667,768,80,},
	-- Temporarely because Kagaro slacks
	HrothgarsLanding = {3677.084, 2452.084, 81,},
}
-- meta table to return 0 for all unknown zones, instances, and what not
local emptyZoneTbl = {0,0,0,""}
setmetatable(zone_data, { __index = function(t, k)
	geterrorhandler()("Routes is missing data for "..k)
	return emptyZoneTbl
end })


-- Initialize zone names into a table
local zoneNames = {}
local zoneList = setmetatable({}, { __index = function() return emptyZoneTbl end})
local zoneMapFile = {}
local continentList = {GetMapContinents()}
for cID = 1, #continentList do
	for zID, zname in ipairs({GetMapZones(cID)}) do
		zoneNames[cID*100 + zID] = zname
		SetMapZoom(cID, zID)
		local mapfile = GetMapInfo()
		zoneList[zname] = zone_data[mapfile]
		zoneList[zname][3] = cID*100 + zID -- overwrite GatherMate ZoneID with our own ZoneID
		zoneList[zname][4] = mapfile
		zoneMapFile[mapfile] = zname
	end
end

Routes.zoneNames = zoneNames
Routes.zoneData = zoneList
Routes.zoneMapFile = zoneMapFile

zone_data = nil
continentList = nil

--[[
Documatation of contents of these tables:
If you are in the zone "Dun Morogh" (continent 1, zone 7 in the enUS client) and
	GetCurrentMapContinent()*100 + GetCurrentMapZone() == 107

then
	zoneNames[107] == "Dun Morogh"
	zoneData["Dun Morogh"] == { 4924.664537147015, 3283.109691431343, 107, "DunMorogh" }
	zoneMapFile["DunMorogh"] == "Dun Morogh"
	zoneData["Some Invalid Zone"] == { 0, 0, 0, "" }

Note that in all the above, "Dun Morogh" is a localized string
]]

-- vim: ts=4 noexpandtab
