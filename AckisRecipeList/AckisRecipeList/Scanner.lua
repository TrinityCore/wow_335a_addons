--[[
************************************************************************
Scanner.lua
In-game tooltip-scanner for datamining.
************************************************************************
File date: 2010-07-09T22:59:09Z
File hash: 3925609
Project hash: 9458672
Project version: v2.01-8-g9458672
************************************************************************
Please see http://www.wowace.com/addons/arl/ for more information.
************************************************************************
This source code is released under All Rights Reserved.
************************************************************************
]]--

-------------------------------------------------------------------------------
-- Upvalues globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

local table = _G.table
local tconcat, tinsert, tsort = table.concat, table.insert, table.sort

local string = _G.string

local tonumber, tostring = _G.tonumber, _G.tostring

local ipairs, pairs = _G.ipairs, _G.pairs

-------------------------------------------------------------------------------
-- Upvalued Blizzard API.
-------------------------------------------------------------------------------
local UnitName = UnitName
local UnitGUID = UnitGUID
local UnitExists = UnitExists
local UnitIsPlayer = UnitIsPlayer
local UnitIsEnemy = UnitIsEnemy
local GetNumTrainerServices = GetNumTrainerServices
local GetTrainerServiceInfo = GetTrainerServiceInfo
local IsTradeskillTrainer = IsTradeskillTrainer
local SetTrainerServiceTypeFilter = SetTrainerServiceTypeFilter
local GetTrainerServiceTypeFilter = GetTrainerServiceTypeFilter
local GetTrainerServiceSkillReq = GetTrainerServiceSkillReq
local GetMerchantNumItems = GetMerchantNumItems
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantItemInfo = GetMerchantItemInfo
local GetSpellInfo = GetSpellInfo

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local MODNAME	= "Ackis Recipe List"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

local L		= LibStub("AceLocale-3.0"):GetLocale(MODNAME)

-- Set up the private intra-file namespace.
local private	= select(2, ...)

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local F = private.filter_flags
local A = private.acquire_types

local PROFESSIONS = private.professions

local SPELL_TO_RECIPE_MAP = private.spell_to_recipe_map
local RECIPE_TO_SPELL_MAP = {}

do
	for spell_id, recipe_id in pairs(SPELL_TO_RECIPE_MAP) do
		RECIPE_TO_SPELL_MAP[recipe_id] = spell_id
	end
end

-------------------------------------------------------------------------------
-- Look up table of spell IDs for recipes which do not have a player flag
-- BASICALLY A TEMPORARY STORAGE FOR IDS, SO WE CAN SEE CLEANER SCANS AND WHAT NOT,
-- WE'LL GO BACK HERE LATER DOWN THE ROAD.
-------------------------------------------------------------------------------
local NO_ROLE_FLAG = {

	--------------------------------------------------------------------------------------------
	-----ASSORTED CRAP
	--------------------------------------------------------------------------------------------
	[30344] = true, 		[30341] = true, 		[32814] = true, 		[23066] = true,
	[26421] = true, 		[36955] = true, 		[19788] = true, 		[23129] = true,
	[26422] = true, 		[12715] = true, 		[12899] = true, 		[56459] = true,
	[30307] = true, 		[26423] = true, 		[3918] = true,	 		[23067] = true,
	[30308] = true, 		[3953] = true,			[15255] = true, 		[26424] = true,
	[30548] = true, 		[44157] = true, 		[56462] = true, 		[19567] = true,
	[30552] = true, 		[23068] = true, 		[44155] = true, 		[28327] = true,
	[26425] = true, 		[56461] = true, 		[68067] = true, 		[15633] = true,
	[23096] = true, 		[12589] = true, 		[26442] = true, 		[26426] = true,
	[67920] = true, 		[9273] = true,			[3926] = true,			[6458] = true,
	[19793] = true, 		[55252] = true, 		[9271] = true,			[26427] = true,
	[26443] = true, 		[30551] = true, 		[23486] = true, 		[3922] = true,
	[3924] = true,			[12590] = true, 		[3928] = true,			[3942] = true,
	[26428] = true, 		[3952] = true,	 		[22704] = true, 		[12902] = true,
	[30569] = true, 		[15628] = true, 		[12895] = true, 		[21940] = true,
	[56349] = true, 		[12584] = true, 		[56477] = true, 		[30348] = true,
	[26416] = true, 		[53281] = true, 		[23507] = true,			[12075] = true,
	[12079] = true,			[26746] = true,			[56000] = true,

	-----------------------------------------------------------------------------------------
	---JEWELCRAFTING
	-----------------------------------------------------------------------------------------
	[55401] = true,	[53995] = true,	[66432] = true,	[25255] = true,
	[66497] = true, [53996] = true, [56074] = true, [56202] = true,
	[66434] = true, [32801] = true, [28948] = true, [53997] = true,
	[39963] = true, [32866] = true, [66501] = true, [39452] = true,
	[53934] = true, [66502] = true, [55405] = true, [58954] = true,
	[56205] = true, [37855] = true, [38175] = true, [25305] = true,
	[25321] = true, [66505] = true, [54000] = true, [39742] = true,
	[56206] = true, [66506] = true, [32869] = true, [54001] = true,
	[56079] = true, [32259] = true, [32870] = true, [56208] = true,
	[32807] = true, [32871] = true, [26873] = true, [31061] = true,
	[32872] = true, [42591] = true, [46779] = true, [56530] = true,
	[42592] = true, [31062] = true, [56083] = true, [32874] = true,
	[56531] = true, [31063] = true, [56085] = true, [38503] = true,
	[56086] = true, [28938] = true, [38504] = true, [31064] = true,
	[31096] = true, [55384] = true, [25278] = true, [68253] = true,
	[43493] = true, [26925] = true, [31065] = true, [46403] = true,
	[53852] = true, [53916] = true, [39722] = true, [25615] = true,
	[28924] = true, [26926] = true, [53853] = true, [36526] = true,
	[31098] = true, [55388] = true, [46405] = true, [53854] = true,
	[39724] = true, [55389] = true, [26927] = true, [31051] = true,
	[53919] = true, [39725] = true, [55390] = true, [53856] = true,
	[53920] = true, [53952] = true, [26880] = true, [53857] = true,
	[31052] = true, [34069] = true, [25490] = true, [55393] = true,
	[39451] = true, [53956] = true, [44794] = true, [36524] = true,
	[55395] = true, [38068] = true, [28944] = true, [53957] = true,
	[31066] = true, [31082] = true, [66428] = true, [26909] = true,
	[55396] = true, [31097] = true, [25284] = true, [56084] = true,
	[62941] = true, [66431] = true, [53894] = true, [53958] = true,
	[58146] = true, [31099] = true, [47053] = true, [31067] = true,
	[28917] = true, [26903] = true, [36525] = true, [66503] = true,
	[56197] = true, [47054] = true, [53961] = true, [39715] = true,
	[31092] = true, [53960] = true, [31077] = true, [31101] = true,
	[39719] = true, [55399] = true, [31113] = true, [32808] = true,
	[53917] = true, [63743] = true, [39720] = true, [39721] = true,
	[42590] = true, [58149] = true, [56199] = true, [47056] = true,
	[28950] = true, [47280] = true, [32809] = true, [31072] = true,
	[25318] = true, [66429] = true, [62242] = true,
	---------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------
	---COOKING
	---------------------------------------------------------------------------------------
	[62050]= true, [22761]= true, [62051]= true, [8607]= true,
	[18238]= true, [6413]= true, [6417]= true, [42296]= true,
	[45557]= true, [6501]= true, [45558]= true, [18239]= true,
	[7752]= true, [7828]= true, [45560]= true, [64358]= true,
	[57421]= true, [45561]= true, [13028]= true, [2543]= true,
	[2545]= true, [25659]= true, [58512]= true, [45565]= true,
	[42305]= true, [45566]= true, [62350]= true, [7753]= true,
	[45695]= true, [9513]= true, [18244]= true, [20626]= true,
	[45569]= true, [43779]= true, [18245]= true, [45571]= true,
	[18246]= true, [37836]= true, [57433]= true, [20916]= true,
	[58521]= true, [18247]= true, [57435]= true, [7754]= true,
	[53056]= true, [58523]= true, [57437]= true, [57438]= true,
	[58525]= true, [45570]= true, [2538]= true, [2540]= true,
	[2548]= true, [33290]= true, [45562]= true, [15906]= true,
	[18241]= true, [45559]= true, [45551]= true, [57443]= true,
	[58527]= true, [43758]= true, [58528]= true, [8238]= true,
	[7751]= true, [7755]= true, [43761]= true, [7827]= true,
	[45552]= true, [45553]= true, [66038] = true, [66034] = true,
	---------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------
	---BLACKSMITHING
	---------------------------------------------------------------------------------------
	[10015] = true, [55202] = true, [16726] = true, [24399] = true,
	[15293] = true, [32655] = true, [3320] = true, [40033] = true,
	[34545] = true, [61010] = true, [16639] = true, [3115] = true,
	[3116] = true, [3117] = true, [16648] = true, [40034] = true,
	[9920] = true, [9928] = true, [29558] = true, [55839] = true,
	[9964] = true, [7818] = true, [55732] = true, [29694] = true,
	[3326] = true, [9950] = true, [59405] = true, [12260] = true,
	[16983] = true, [16991] = true, [23650] = true, [16640] = true,
	[2741] = true, [3513] = true, [3497] = true, [8768] = true,
	[19666] = true, [2662] = true, [2663] = true, [20201] = true,
	[16664] = true, [15294] = true, [3496] = true, [16645] = true,
	[29569] = true, [2737] = true, [14380] = true, [16992] = true,
	[36125] = true, [19667] = true, [22757] = true, [16665] = true,
	[59406] = true, [2738] = true, [2739] = true, [2740] = true,
	[24913] = true, [9933] = true, [20873] = true, [36126] = true,
	[40035] = true, [8880] = true, [23636] = true, [3292] = true,
	[3293] = true, [21161] = true, [32656] = true, [19668] = true,
	[9921] = true, [7222] = true, [3319] = true, [15295] = true,
	[20874] = true, [20890] = true, [3337] = true, [34546] = true,
	[16970] = true, [16978] = true, [61008] = true, [7224] = true,
	[11454] = true, [19669] = true, [55656] = true, [16667] = true,
	[16731] = true, [61009] = true, [9926] = true, [16984] = true,
	[21913] = true, [40036] = true, [9974] = true, [32657] = true,
	[32285] = true, [23638] = true, [10011] = true, [36131] = true,
	[27830] = true,  [32284] = true, [16732] = true, [15292] = true,
	[15296] = true, [38478] = true, [20876] = true, [38475] = true,
	[23653] = true, [3325] = true, [14379] = true,  [29729] = true,
	[2661] = true,  [29728] = true, [16655] = true, [16993] = true,
	[3491] = true, [3494] = true, [3501] = true, [9959] = true,
	[9983] = true, [36262] = true, [10003] = true, [10007] = true,
	---------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------
	----INSCRIPTION
	---------------------------------------------------------------------------------------
	[58315] = true, [58331] = true, [58347] = true, [56974] = true, [56990] = true,
	[64256] = true, [64304] = true, [57166] = true, [57709] = true, [57214] = true,
	[57230] = true, [50603] = true, [57262] = true, [59338] = true, [58332] = true,
	[56959] = true, [56975] = true, [56991] = true, [57007] = true, [57023] = true,
	[53462] = true, [64257] = true, [64273] = true, [64289] = true, [57151] = true,
	[57167] = true, [57183] = true, [57710] = true, [57215] = true, [57247] = true,
	[50620] = true, [58301] = true, [59339] = true, [58333] = true, [59387] = true,
	[52840] = true, [59499] = true, [56960] = true, [56976] = true, [57008] = true,
	[57024] = true, [64258] = true, [64274] = true, [57168] = true, [57184] = true,
	[61288] = true, [57216] = true, [57232] = true, [58286] = true, [58302] = true,
	[59340] = true, [48114] = true, [64051] = true, [59484] = true, [59500] = true,
	[56961] = true, [56977] = true, [57009] = true, [57025] = true, [61177] = true,
	[64259] = true, [57121] = true, [64291] = true, [57153] = true, [57169] = true,
	[57185] = true, [57712] = true, [57217] = true, [57233] = true, [58287] = true,
	[58303] = true, [58319] = true, [56946] = true, [56978] = true, [56994] = true,
	[57010] = true, [57026] = true, [64260] = true, [57122] = true, [57154] = true,
	[57170] = true, [57186] = true, [57713] = true, [57218] = true, [57234] = true,
	[57266] = true, [59326] = true, [58320] = true, [58336] = true, [59486] = true,
	[59502] = true, [56963] = true, [56995] = true, [57011] = true, [57027] = true,
	[64261] = true, [64277] = true, [57155] = true, [57187] = true, [57714] = true,
	[57219] = true, [57235] = true, [58289] = true, [58305] = true, [58321] = true,
	[58337] = true, [69385] = true, [57243] = true, [64314] = true, [64313] = true,
	[56958] = true, [59487] = true, [59503] = true, [58288] = true, [56980] = true,
	[56996] = true, [57012] = true, [57028] = true, [59501] = true, [56948] = true,
	[57264] = true, [64246] = true, [64262] = true, [57124] = true, [64294] = true,
	[57156] = true, [57172] = true, [57188] = true, [57715] = true, [57220] = true,
	[57236] = true, [57268] = true, [58306] = true, [58322] = true, [58338] = true,
	[48247] = true, [57133] = true, [57270] = true, [57131] = true, [57129] = true,
	[50604] = true, [59488] = true, [59504] = true, [56965] = true, [56981] = true,
	[56997] = true, [57013] = true, [57029] = true, [64280] = true, [57114] = true,
	[64286] = true, [58299] = true, [57125] = true, [64295] = true, [64311] = true,
	[57164] = true, [57189] = true, [57716] = true, [57221] = true, [57237] = true,
	[57269] = true, [58307] = true, [58323] = true, [58339] = true, [64307] = true,
	[57119] = true, [57246] = true, [68166] = true, [64282] = true, [57250] = true,
	[59489] = true, [56957] = true, [56982] = true, [56998] = true, [57014] = true,
	[57117] = true, [64305] = true, [61677] = true, [52843] = true, [57126] = true,
	[64296] = true, [57158] = true, [64310] = true, [57190] = true, [56956] = true,
	[57238] = true, [60336] = true, [58308] = true, [58324] = true, [58340] = true,
	[64315] = true, [56949] = true, [56950] = true, [64308] = true, [56955] = true,
	[59490] = true, [59315] = true, [56983] = true, [56999] = true, [64267] = true,
	[57031] = true, [56954] = true, [64276] = true, [57249] = true, [64249] = true,
	[56953] = true, [57127] = true, [64297] = true, [57159] = true, [64275] = true,
	[57191] = true, [57207] = true, [57223] = true, [57239] = true, [50612] = true,
	[60337] = true, [57208] = true, [58325] = true, [48121] = true, [56952] = true,
	[56947] = true, [56951] = true, [64268] = true, [57123] = true, [59475] = true,
	[59491] = true, [56968] = true, [56984] = true, [57000] = true, [48248] = true,
	[58565] = true, [58317] = true, [64266] = true, [57252] = true, [64250] = true,
	[57112] = true, [57128] = true, [64298] = true, [57160] = true, [58316] = true,
	[57703] = true, [57719] = true, [57224] = true, [57240] = true, [57272] = true,
	[58310] = true, [58326] = true, [58342] = true, [57201] = true, [56945] = true,
	[57200] = true, [56944] = true, [57711] = true, [56985] = true, [57001] = true,
	[57199] = true, [57033] = true, [56943] = true, [57198] = true, [64251] = true,
	[57113] = true, [64283] = true, [64299] = true, [57161] = true, [57197] = true,
	[57704] = true, [57209] = true, [57225] = true, [57241] = true, [50614] = true,
	[57273] = true, [58311] = true, [58327] = true, [58343] = true, [52738] = true,
	[57196] = true, [64278] = true, [57195] = true, [58318] = true, [64284] = true,
	[57006] = true, [64316] = true, [56986] = true, [57002] = true, [59560] = true,
	[57034] = true, [58341] = true, [57192] = true, [64252] = true, [67600] = true,
	[57130] = true, [64300] = true, [57162] = true, [57244] = true, [57194] = true,
	[57210] = true, [57226] = true, [50599] = true, [57258] = true, [58296] = true,
	[58312] = true, [58328] = true, [58344] = true, [52739] = true, [58298] = true,
	[57274] = true, [57265] = true, [57251] = true, [59478] = true, [56971] = true,
	[56987] = true, [57003] = true, [57019] = true, [57035] = true, [57259] = true,
	[57263] = true, [57271] = true, [64253] = true, [57115] = true, [64285] = true,
	[57242] = true, [57163] = true, [57120] = true, [57706] = true, [57211] = true,
	[57227] = true, [50600] = true, [50616] = true, [58297] = true, [58313] = true,
	[58329] = true, [58345] = true, [50602] = true, [57248] = true, [59559] = true,
	[57157] = true, [57257] = true, [64309] = true, [64317] = true, [56972] = true,
	[56988] = true, [57004] = true, [57020] = true, [57036] = true, [62162] = true,
	[57030] = true, [64254] = true, [57116] = true, [57132] = true, [64302] = true,
	[64318] = true, [64270] = true, [57707] = true, [57212] = true, [57228] = true,
	[50601] = true, [57260] = true, [57276] = true, [58314] = true, [58330] = true,
	[58346] = true, [45382] = true, [57267] = true, [57275] = true, [64312] = true,
	[64279] = true, [50598] = true, [59480] = true, [59496] = true, [56973] = true,
	[56989] = true, [57005] = true, [57021] = true, [50619] = true, [50618] = true,
	[65245] = true, [50617] = true, [64255] = true, [64271] = true, [64287] = true,
	[64303] = true, [57165] = true, [57181] = true, [57708] = true, [57213] = true,
	[57229] = true, [57245] = true, [57261] = true, [57277] = true, [57253] = true,
	[71015] = true,	[71101] = true,	[71102] = true,
	---------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------
	----ENCHANTING
	---------------------------------------------------------------------------------------
	[46578] = true, [25125] = true, [13612] = true, [13620] = true, [13628] = true,
	[13640] = true, [13644] = true, [13648] = true, [59625] = true, [13700] = true,
	[17181] = true, [27920] = true, [27960] = true, [28016] = true, [45765] = true,
	[14810] = true, [63746] = true, [13836] = true, [20008] = true, [20032] = true,
	[13868] = true, [13421] = true, [13948] = true, [27905] = true, [27945] = true,
	[13501] = true, [7786] = true, [7788] = true, [13529] = true, [32664] = true,
	[44506] = true, [25127] = true, [20025] = true, [20033] = true, [13617] = true,
	[64579] = true, [60619] = true, [13657] = true, [13693] = true, [27914] = true,
	[44555] = true, [27954] = true, [27962] = true, [14807] = true, [32665] = true,
	[7421] = true, [13817] = true, [25072] = true, [44492] = true, [44524] = true,
	[7443] = true, [44556] = true, [25128] = true, [20026] = true, [7457] = true,
	[13378] = true, [34001] = true, [13917] = true, [13933] = true, [13937] = true,
	[13941] = true, [44621] = true, [28003] = true, [28027] = true, [13522] = true,
	[13538] = true, [25081] = true, [44494] = true, [20011] = true, [25129] = true,
	[44590] = true, [47672] = true, [20051] = true, [13622] = true, [13626] = true,
	[69412] = true, [60623] = true, [44383] = true, [13698] = true, [13702] = true,
	[23804] = true, [44623] = true, [28004] = true, [28028] = true, [14293] = true,
	[32667] = true, [13822] = true, [25082] = true, [44576] = true, [20028] = true,
	[20036] = true, [13890] = true, [13898] = true, [60609] = true, [59619] = true,
	[47898] = true, [7745] = true, [27957] = true, [13503] = true, [34006] = true,
	[7793] = true, [7795] = true, [59636] = true, [25083] = true, [20029] = true,
	[13631] = true, [13655] = true, [7861] = true, [7863] = true, [62256] = true,
	[13695] = true, [13858] = true, [44483] = true, [27968] = true, [7857] = true,
	[27967] = true, [42615] = true, [27958] = true, [42613] = true, [25084] = true,
	[20017] = true, [33992] = true, [34008] = true, [13663] = true, [60653] = true,
	[44528] = true, [14809] = true, [27961] = true, [47901] = true, [7418] = true,
	[7420] = true, [44488] = true, [7426] = true, [44616] = true, [13841] = true,
	[44596] = true, [17180] = true, [7454] = true, [33993] = true, [34009] = true,
	[27950] = true, [20031] = true, [13915] = true, [47900] = true, [13943] = true,
	[13947] = true, [13945] = true, [13464] = true, [27927] = true, [7771] = true,
	[20014] = true, [20030] = true, [27947] = true, [33994] = true, [28022] = true,
	[60692] = true, [25130] = true, [34005] = true, [13794] = true, [7748] = true,
	[44588] = true, [15596] = true, [7776] = true, [44584] = true, [13607] = true,
	[13653] = true, [20020] = true,  [70524] = true, [71692] = true,
	---------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------
	---TAILORING
	---------------------------------------------------------------------------------------
	[12055] = true, [12059] = true, [12071] = true, [46131] = true, [23664] = true,
	[31433] = true, [31441] = true, [7624] = true, [26403] = true, [24902] = true,
	[22866] = true, [56001] = true, [18411] = true, [18419] = true, [18451] = true,
	[28208] = true, [6686] = true, [8766] = true, [23665] = true, [8786] = true,
	[26747] = true, [56002] = true, [26763] = true, [26779] = true, [31434] = true,
	[31450] = true, [60969] = true, [28480] = true, [22867] = true, [56003] = true,
	[18404] = true, [18412] = true, [18420] = true, [12044] = true, [63924] = true,
	[12056] = true, [12064] = true, [12080] = true, [12084] = true, [23666] = true,
	[56004] = true, [26780] = true, [31459] = true, [7892] = true, [60971] = true,
	[28481] = true, [22868] = true, [20848] = true, [56005] = true, [18405] = true,
	[19435] = true, [26086] = true, [18437] = true, [18453] = true, [27659] = true,
	[28210] = true, [40021] = true, [23667] = true, [26773] = true, [26781] = true,
	[26759] = true, [8774] = true, [31460] = true, [24903] = true, [3755] = true,
	[37882] = true, [3757] = true, [3758] = true, [50194] = true, [18446] = true,
	[6692] = true, [28482] = true, [22869] = true, [18439] = true, [20849] = true,
	[18440] = true, [2389] = true, [56007] = true, [18455] = true, [6521] = true,
	[18445] = true, [18406] = true, [18414] = true, [18422] = true, [12045] = true,
	[36318] = true, [18454] = true, [27660] = true, [24091] = true, [12065] = true,
	[12069] = true, [12077] = true, [12081] = true, [12085] = true, [27724] = true,
	[12093] = true, [40060] = true, [26087] = true, [26749] = true, [31373] = true,
	[26750] = true, [26782] = true, [28205] = true, [28209] = true, [36686] = true,
	[3813] = true, [2394] = true, [7629] = true, [18438] = true, [7633] = true,
	[40023] = true, [49677] = true, [26407] = true, [18452] = true, [7643] = true,
	[22870] = true, [26755] = true, [22902] = true, [3869] = true, [55993] = true,
	[8789] = true, [3839] = true, [3841] = true, [3844] = true, [18407] = true,
	[18415] = true, [3847] = true, [3848] = true, [3851] = true, [3852] = true,
	[24092] = true, [3854] = true, [3856] = true, [3857] = true, [8760] = true,
	[27725] = true, [8776] = true, [8780] = true, [8784] = true, [3865] = true,
	[55994] = true, [3868] = true, [26783] = true, [3871] = true, [3872] = true,
	[3873] = true, [31438] = true, [22759] = true, [12091] = true, [8804] = true,
	[8772] = true, [18560] = true, [18447] = true, [44950] = true, [60993] = true,
	[55899] = true, [55898] = true, [55995] = true, [2385] = true, [21945] = true,
	[6688] = true, [12066] = true, [18416] = true, [8465] = true, [12046] = true,
	[18448] = true, [3915] = true, [24093] = true, [8489] = true, [2386] = true,
	[12078] = true, [12082] = true, [60994] = true, [55900] = true, [2392] = true,
	[2393] = true, [23662] = true, [2396] = true, [55996] = true, [2399] = true,
	[26784] = true, [2402] = true, [2403] = true, [2406] = true, [31431] = true,
	[3864] = true, [8782] = true, [37884] = true, [37883] = true, [26751] = true,
	[50647] = true, [8802] = true, [8467] = true, [7893] = true, [40020] = true,
	[41208] = true, [22813] = true, [41207] = true, [37873] = true, [2387] = true,
	[55997] = true, [26085] = true, [8799] = true, [27658] = true, [8483] = true,
	[3914] = true, [18401] = true, [56006] = true, [18441] = true, [18449] = true,
	[28207] = true, [55769] = true, [18413] = true, [18421] = true, [46129] = true,
	[2963] = true, [2964] = true, [12061] = true, [12086] = true, [23663] = true,
	[26745] = true, [55998] = true, [3863] = true, [8764] = true, [31440] = true,
	[31448] = true, [12089] = true, [6695] = true, [40024] = true, [60990] = true,
	[50644] = true, [8793] = true, [46130] = true, [24901] = true, [3870] = true,
	[31437] = true, [44958] = true, [55999] = true, [3845] = true, [6693] = true,
	[3866] = true, [18456] = true, [18410] = true, [18418] = true, [2397] = true,
	[18434] = true, [18450] = true,
	---------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------
	----LEATHERWORKING
	---------------------------------------------------------------------------------------
	[9198] = true, [23704] = true, [60996] = true, [35549] = true, [22921] = true,
	[50958] = true, [10509] = true, [10525] = true, [19053] = true, [19085] = true,
	[19101] = true, [2149] = true, [36349] = true, [2153] = true, [60997] = true,
	[2159] = true, [2163] = true, [2165] = true, [35582] = true, [50959] = true,
	[46132] = true, [23705] = true, [60998] = true, [22922] = true, [46133] = true,
	[24121] = true, [19054] = true, [19070] = true, [19086] = true, [19102] = true,
	[32465] = true, [32481] = true, [22331] = true, [35520] = true, [35584] = true,
	[9207] = true, [6661] = true, [46134] = true, [23706] = true, [61000] = true,
	[35521] = true, [35585] = true, [50962] = true, [10518] = true, [39997] = true,
	[24122] = true, [19055] = true, [19087] = true, [19103] = true, [32466] = true,
	[32482] = true, [36353] = true, [35522] = true, [35554] = true, [50963] = true,
	[44953] = true, [46136] = true, [23707] = true, [61002] = true, [35523] = true,
	[35555] = true, [35587] = true, [50964] = true, [46137] = true, [24123] = true,
	[19072] = true, [19104] = true, [9064] = true, [9072] = true, [69386] = true,
	[32499] = true, [36355] = true, [7133] = true, [35524] = true, [35588] = true,
	[7153] = true, [9208] = true, [46138] = true, [23708] = true, [69388] = true,
	[35525] = true, [35557] = true, [10487] = true, [10511] = true, [46139] = true,
	[24124] = true, [19073] = true, [19089] = true, [32468] = true, [32500] = true,
	[10647] = true, [28472] = true, [35526] = true, [35558] = true, [45117] = true,
	[60622] = true, [23709] = true, [35527] = true, [3774] = true, [3778] = true,
	[3780] = true, [40003] = true, [24125] = true, [19058] = true, [19074] = true,
	[32485] = true, [32501] = true, [36359] = true, [3816] = true, [3818] = true,
	[28473] = true, [35528] = true, [35560] = true, [9193] = true, [40004] = true,
	[23710] = true, [8322] = true, [35529] = true, [35561] = true, [50970] = true,
	[2881] = true, [10520] = true, [40005] = true, [10544] = true, [10552] = true,
	[10560] = true, [19091] = true, [19107] = true, [32454] = true, [32502] = true,
	[28474] = true, [35530] = true, [50971] = true, [62448] = true, [7953] = true,
	[41157] = true, [36074] = true, [24846] = true, [35531] = true, [22928] = true,
	[28219] = true, [41158] = true, [36075] = true, [32487] = true, [32503] = true,
	[7126] = true, [9146] = true, [35532] = true, [35564] = true, [9194] = true,
	[9202] = true, [24655] = true, [36076] = true, [24847] = true, [35533] = true,
	[5244] = true, [10529] = true, [28220] = true, [19093] = true, [32456] = true,
	[52733] = true, [2158] = true, [2160] = true, [2162] = true, [2166] = true,
	[24848] = true, [35535] = true, [35567] = true, [28221] = true, [19094] = true,
	[44359] = true, [57690] = true, [32457] = true, [32473] = true, [32489] = true,
	[9147] = true, [35536] = true, [35568] = true, [9195] = true, [41163] = true,
	[6703] = true, [24849] = true, [20853] = true, [10482] = true, [10490] = true,
	[28222] = true, [10546] = true, [10554] = true, [41164] = true, [10570] = true,
	[19095] = true, [57692] = true, [32458] = true, [10650] = true, [35538] = true,
	[42731] = true, [24850] = true, [20854] = true, [44970] = true, [28223] = true,
	[19048] = true, [19064] = true, [19080] = true, [57694] = true, [9148] = true,
	[35540] = true, [35572] = true, [24851] = true, [20855] = true, [45100] = true,
	[10531] = true, [28224] = true, [57696] = true, [10619] = true, [19081] = true,
	[22727] = true, [35539] = true, [19079] = true, [10566] = true, [19065] = true,
	[10574] = true, [19097] = true, [60647] = true, [3753] = true, [9065] = true,
	[44343] = true, [3763] = true, [3767] = true, [3773] = true, [3775] = true,
	[3777] = true, [3779] = true, [32455] = true, [24940] = true, [19050] = true,
	[19082] = true, [23190] = true, [32461] = true, [60999] = true, [3817] = true,
	[44344] = true, [9149] = true, [35544] = true, [9197] = true, [19077] = true,
	[9060] = true, [19076] = true, [35573] = true, [40001] = true, [19066] = true,
	[19090] = true, [19098] = true, [22711] = true, [57699] = true, [9059] = true,
	[32480] = true, [64661] = true, [10562] = true, [40002] = true, [50936] = true,
	[6705] = true, [9058] = true, [24703] = true, [22923] = true, [60645] = true,
	[35577] = true, [2152] = true, [10556] = true, [10572] = true, [44770] = true,
	[36077] = true, [19059] = true, [19075] = true, [35580] = true, [20648] = true,
	[2169] = true, [60643] = true, [19088] = true, [6702] = true, [6704] = true,
	[35543] = true, [7149] = true, [36078] = true, [36079] = true, [23703] = true,
	[35534] = true, [57701] = true, [46135] = true, [19047] = true, [20649] = true,
	[40006] = true, [3765] = true, [41156] = true, [3771] = true, [50956] = true,
	[19061] = true, [20650] = true, [32467] = true, [35537] = true, [22926] = true,
	[4096] = true, [19062] = true, [44768] = true, [35576] = true, [19063] = true,
	[9062] = true, [9070] = true, [32495] = true,
	---------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------
	-----ALCHEMY
	---------------------------------------------------------------------------------------
	[53898] = true, [28579] = true, [17566] = true, [53771] = true, [7256] = true,
	[53899] = true, [11452] = true, [11460] = true, [11468] = true, [3170] = true,
	[3172] = true, [3174] = true, [3176] = true, [53836] = true, [53900] = true,
	[28564] = true, [28580] = true, [54220] = true, [17551] = true, [53773] = true,
	[53837] = true, [62213] = true, [54221] = true, [53774] = true, [53838] = true,
	[6617] = true, [53902] = true, [28581] = true, [2331] = true, [2335] = true,
	[2337] = true, [53775] = true, [53839] = true, [11453] = true, [7836] = true,
	[24266] = true, [41500] = true, [53904] = true, [53936] = true, [28566] = true,
	[28582] = true, [3452] = true, [3454] = true, [33732] = true, [17553] = true,
	[22732] = true, [53777] = true, [53905] = true, [53937] = true, [33733] = true,
	[62409] = true, [25146] = true, [41502] = true, [53938] = true, [28551] = true,
	[28567] = true, [28583] = true, [62410] = true, [7181] = true, [17570] = true,
	[17634] = true, [53779] = true, [7257] = true, [53939] = true, [11478] = true,
	[17187] = true, [53812] = true, [28552] = true, [28568] = true, [28584] = true,
	[60366] = true, [57425] = true, [17635] = true, [53781] = true, [60367] = true,
	[4508] = true, [53782] = true, [24365] = true, [6618] = true, [53942] = true,
	[28569] = true, [28585] = true, [29688] = true, [57427] = true, [17556] = true,
	[17572] = true, [17636] = true, [53783] = true, [11479] = true, [7837] = true,
	[7841] = true, [53784] = true, [24366] = true, [53848] = true, [28554] = true,
	[28570] = true, [28586] = true, [58868] = true, [33741] = true, [24367] = true,
	[28555] = true, [28571] = true, [17574] = true, [17638] = true, [7258] = true,
	[11448] = true, [11456] = true, [11464] = true, [11480] = true, [3171] = true,
	[3173] = true, [3175] = true, [24368] = true, [28572] = true, [28588] = true,
	[45061] = true, [66658] = true, [17559] = true, [17575] = true, [66659] = true,
	[66660] = true, [63732] = true, [28573] = true, [66662] = true, [17560] = true,
	[2330] = true, [2332] = true, [2334] = true, [66663] = true, [11457] = true,
	[11465] = true, [11473] = true, [66664] = true, [3449] = true, [3451] = true,
	[3453] = true, [17561] = true, [17577] = true, [28543] = true, [28575] = true,
	[7179] = true, [17562] = true, [17578] = true, [7255] = true, [7259] = true,
	[11458] = true, [11466] = true, [38962] = true, [53776] = true, [12609] = true,
	[53780] = true, [60893] = true, [58871] = true, [3448] = true, [3450] = true,
	[3447] = true, [4942] = true, [28576] = true, [15833] = true, [17576] = true,
	[41503] = true, [60350] = true, [41501] = true, [17563] = true, [42736] = true,
	[54213] = true, [41458] = true, [6624] = true, [39636] = true, [28577] = true,
	[32765] = true, [38070] = true, [17564] = true, [17580] = true, [53895] = true,
	[11451] = true, [39637] = true, [28546] = true, [28562] = true, [28578] = true,
	[60354] = true, [32766] = true, [17565] = true, [22808] = true, [39639] = true,
	[60355] = true, [56519] = true,
	---------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------
	----ENGINEERING
	---------------------------------------------------------------------------------------
	[23081] = true, [12586] = true, [12594] = true, [12622] = true, [30347] = true,
	[44391] = true, [30547] = true, [56464] = true, [12754] = true, [12758] = true,
	[23489] = true, [23082] = true, [8243] = true, [9269] = true, [30316] = true,
	[30332] = true, [12906] = true, [8339] = true, [26420] = true, [56514] = true,
	[39971] = true, [12599] = true, [12603] = true, [12607] = true, [43676] = true,
	[12619] = true, [54998] = true, [30349] = true, [56468] = true, [12755] = true,
	[12759] = true, [63750] = true, [39973] = true, [56465] = true, [56469] = true,
	[30318] = true, [30334] = true, [55016] = true, [12903] = true, [54793] = true,
	[19795] = true, [8895] = true, [19819] = true, [30558] = true, [39895] = true,
	[23069] = true, [23077] = true, [12596] = true, [30303] = true, [56471] = true,
	[12624] = true, [19796] = true, [56472] = true, [12760] = true, [63770] = true,
	[23070] = true, [23078] = true, [61471] = true, [30304] = true, [30312] = true,
	[12908] = true, [12597] = true, [3930] = true, [24356] = true, [67839] = true,
	[67326] = true, [56474] = true, [30560] = true, [30568] = true, [30314] = true,
	[3929] = true, [56475] = true, [19830] = true, [3946] = true, [54736] = true,
	[30563] = true, [24357] = true, [30337] = true, [12591] = true, [19814] = true,
	[60866] = true, [12716] = true, [23071] = true, [23079] = true, [12585] = true,
	[3923] = true, [3925] = true, [30305] = true, [12621] = true, [30329] = true,
	[3931] = true, [3932] = true, [3933] = true, [3936] = true, [3937] = true,
	[3938] = true, [3939] = true, [3941] = true, [56473] = true, [3944] = true,
	[3945] = true, [3947] = true, [54999] = true, [3949] = true, [3950] = true,
	[26417] = true, [12717] = true, [3954] = true, [3955] = true, [3957] = true,
	[3958] = true, [3961] = true, [3962] = true, [3963] = true, [3965] = true,
	[3966] = true, [3967] = true, [3968] = true, [3969] = true, [3971] = true,
	[3972] = true, [3973] = true, [7430] = true, [3977] = true, [3978] = true,
	[3979] = true, [19790] = true, [23080] = true, [12620] = true, [30309] = true,
	[30346] = true, [12905] = true, [41307] = true, [8334] = true, [56460] = true,
	[56476] = true, [12718] = true, [26418] = true, [19791] = true, [3960] = true,
	[19815] = true, [13240] = true, [19831] = true, [30570] = true, [19799] = true,
	[30306] = true, [30310] = true, [26011] = true, [36954] = true, [3919] = true,
	[3920] = true, [19800] = true, [12617] = true, [30311] = true, [56463] = true,
	[72952] = true, [72953] = true,
	---------------------------------------------------------------------------------------
}

local function ItemLinkToID(link)
	if not link then
		return
	end
	local _, _, id_num = string.find(link,"item:(%d+):")

	if id_num then
		return tonumber(id_num)
	end
end


local function LoadRecipe()
	local recipe_list = private.recipe_list

	if addon.db.profile.autoloaddb then
		-- Make sure the lookup lists are loaded as well, since they are no longer automatically loaded in addon:OnEnable().
		if addon.InitializeLookups then
			addon:InitializeLookups()
		end

		for idx, prof in pairs(PROFESSIONS) do
			addon:InitializeProfession(prof)
		end
	end
	return recipe_list

end

-------------------------------------------------------------------------------
-- Creates a reverse lookup for a recipe list
-------------------------------------------------------------------------------
local GetReverseLookup
do
	local reverse_lookup = {}

	function GetReverseLookup(recipe_list)
		if not recipe_list then
			addon:Print(L["DATAMINER_NODB_ERROR"])
			return
		end
		table.wipe(reverse_lookup)

		for i in pairs(recipe_list) do
			--if t[recipe_list[i].name] then addon:Print("Dupe: " .. i) end
			reverse_lookup[recipe_list[i].name] = i
		end
		return reverse_lookup
	end

end

-------------------------------------------------------------------------------
-- Tooltip for data-mining.
-------------------------------------------------------------------------------
local ARLDatamineTT = CreateFrame("GameTooltip", "ARLDatamineTT", UIParent, "GameTooltipTemplate")

do
	-- Tables used in all the Scan functions within this do block. -Torhal
	local info, output = {}, {}

	--- Function to compare the skill levels of a trainers recipes with those in the ARL database.
	-- @name AckisRecipeList:ScanSkillLevelData
	-- @param autoscan True when autoscan is enabled in preferences, it will surpress output letting you know when a scan has occured.
	-- @return Does a comparison of the information in your internal ARL database, and those items which are available on the trainer.  Compares the skill levels between the two.
	function addon:ScanSkillLevelData(autoscan)
		if not IsTradeskillTrainer() then
			if not autoscan then
				self:Print(L["DATAMINER_SKILLLEVEL_ERROR"])
			end
			return
		end
		local recipe_list = LoadRecipe()	-- Get internal database

		if not recipe_list then
			self:Print(L["DATAMINER_NODB_ERROR"])
			return
		end
		-- Get the initial trainer filters
		local avail = GetTrainerServiceTypeFilter("available")
		local unavail = GetTrainerServiceTypeFilter("unavailable")
		local used = GetTrainerServiceTypeFilter("used")

		-- Clear the trainer filters
		SetTrainerServiceTypeFilter("available", 1)
		SetTrainerServiceTypeFilter("unavailable", 1)
		SetTrainerServiceTypeFilter("used", 1)

		table.wipe(info)

		-- Get the skill levels from the trainer
		for i = 1, GetNumTrainerServices(), 1 do
			local name = GetTrainerServiceInfo(i)
			local _, skilllevel = GetTrainerServiceSkillReq(i)

			if not skilllevel then
				skilllevel = 0
			end
			info[name] = skilllevel
		end
		local found = false

		table.wipe(output)

		for i in pairs(recipe_list) do
			local i_name = recipe_list[i].name

			if info[i_name] and info[i_name] ~= recipe_list[i].skill_level then
				found = true
				tinsert(output, L["DATAMINER_SKILLELVEL"]:format(i_name, recipe_list[i].skill_level, info[i_name]))
			end
		end
		tinsert(output, "Trainer Skill Level Scan Complete.")

		if found then
			self:DisplayTextDump(nil, nil, tconcat(output, "\n"))
		end
		-- Reset the filters to what they were before
		SetTrainerServiceTypeFilter("available", avail or 0)
		SetTrainerServiceTypeFilter("unavailable", unavail or 0)
		SetTrainerServiceTypeFilter("used", used or 0)
	end

	local teach, noteach = {}, {}

	--- Function to compare which recipes are available from a trainer and compare with the internal ARL database.
	-- @name AckisRecipeList:ScanTrainerData
	-- @param autoscan True when autoscan is enabled in preferences, it will surpress output letting you know when a scan has occured.
	-- @return Does a comparison of the information in your internal ARL database, and those items which are available on the trainer.
	-- Compares the acquire information of the ARL database with what is available on the trainer.
	function addon:ScanTrainerData(autoscan)
		if not (UnitExists("target") and (not UnitIsPlayer("target")) and (not UnitIsEnemy("player", "target"))) then	-- Make sure the target exists and is a NPC
			if not autoscan then
				self:Print(L["DATAMINER_TRAINER_NOTTARGETTED"])
			end
			return
		end
		local targetname = UnitName("target")	-- Get its name
		local targetID = tonumber(string.sub(UnitGUID("target"), -12, -7), 16)	-- Get the NPC ID

		if not IsTradeskillTrainer() then		-- Are we at a trade skill trainer?
			if not autoscan then
				self:Print(L["DATAMINER_SKILLLEVEL_ERROR"])
			end
			return
		end
		local recipe_list = LoadRecipe()	-- Get internal database

		if not recipe_list then
			self:Print(L["DATAMINER_NODB_ERROR"])
			return
		end

		-- Get the initial trainer filters
		local avail = GetTrainerServiceTypeFilter("available")
		local unavail = GetTrainerServiceTypeFilter("unavailable")
		local used = GetTrainerServiceTypeFilter("used")

		-- Clear the trainer filters
		SetTrainerServiceTypeFilter("available", 1)
		SetTrainerServiceTypeFilter("unavailable", 1)
		SetTrainerServiceTypeFilter("used", 1)

		if GetNumTrainerServices() == 0 then
			self:Print("Warning: Trainer is bugged, reporting 0 trainer items.")
		end
		table.wipe(info)

		-- Get all the names of recipes from the trainer
		for i = 1, GetNumTrainerServices(), 1 do
			local name = GetTrainerServiceInfo(i)
			info[name] = true
		end
		table.wipe(teach)
		table.wipe(noteach)
		table.wipe(output)

		-- Dump out trainer info
		tinsert(output, L["DATAMINER_TRAINER_INFO"]:format(targetname, targetID))

		local teachflag = false
		local noteachflag = false

		for spell_id, recipe in pairs(recipe_list) do
			local train_data = recipe.acquire_data[A.TRAINER]
			local found = false

			if train_data then
				for id_num in pairs(train_data) do
					if id_num == targetID then
						found = true
						break
					end
				end
			end

			if info[recipe.name] then
				if not found then
					tinsert(teach, spell_id)
					teachflag = true

					if not recipe:IsFlagged("common1", "TRAINER") then
						tinsert(output, ": Trainer flag needs to be set.")
					end
				end
			else
				if found then
					noteachflag = true
					tinsert(noteach, spell_id)
				end
			end
		end

		if teachflag then
			tinsert(output, "Missing entries (need to be added):")
			tsort(teach)

			for i in ipairs(teach) do
				tinsert(output, L["DATAMINER_TRAINER_TEACH"]:format(teach[i], recipe_list[teach[i]].name))
			end
		end

		if noteachflag then
			tinsert(output, "Extra entries (need to be removed):")
			tsort(noteach)

			for i in ipairs(noteach) do
				tinsert(output, L["DATAMINER_TRAINER_NOTTEACH"]:format(noteach[i], recipe_list[noteach[i]].name))
			end
		end
		tinsert(output, "Trainer Acquire Scan Complete.")
		tinsert(output, "If this is an engineering scan, some goggles may be listed as extra. These goggles ONLY show up for the classes who can make them, so they may be false positives.")

		if teachflag or noteachflag then
			self:DisplayTextDump(nil, nil, tconcat(output, "\n"))
		end
		-- Reset the filters to what they were before
		SetTrainerServiceTypeFilter("available", avail or 0)
		SetTrainerServiceTypeFilter("unavailable", unavail or 0)
		SetTrainerServiceTypeFilter("used", used or 0)
	end
end	-- do

--- Generates tradeskill links for all professions so you can scan them for completeness.
-- @name AckisRecipeList:GenerateLinks
-- @return Generates tradeskill links with all recipes.  Used for testing to see if a recipe is missing from the database or not.
function addon:GenerateLinks()
	-- This code adopted from Gnomish Yellow Pages with permission

	local guid = UnitGUID("player")
	local playerGUID = string.gsub(guid, "0x0+", "")

	-- Listing of all tradeskill professions
	local tradelist = {51304, 51300, 51313, 51306, 45363, 51311, 51302, 51309, 51296, 45542}

--[[
	local encodingLength = floor((#recipeList+5) / 6)

	local encodedString = string.rep("/", encodingLength)
]]--
	local bitmap = {}
	bitmap[45542] = "8bffAA" -- First Aid  100%   17/17 recipes
	bitmap[51296] = "2/6///7///9f///7//////////g///B" -- Cooking  98.2%  166/169 recipes
	--bitmap[51306] = "4/////////////3nFA+///9+/P7//f//n//9dgdJgHA87/3f/TolD" -- Engineering (53)
	bitmap[51306] = "4/////////////3nFA+///9+/P7//f//n//9dgdJgHA87/3f/Tol3B" -- Engineering
	bitmap[51302] = "e+//ff////d//u//v//n+vv7/+ujr7/9////bg/+////f344//dA4I8j/X//B4/vu5/////////////////nvA8/M8/D" -- Leatherworking  85.4%   451/528 recipes
	bitmap[51304] = "2//v//////f////3//v///////5//////////9/////v" -- Alchemy 100%   251/251 recipes
	bitmap[51300] = "2//////f7fM//f/f53/+//7///ze8c6q/f9///P2/////m4BAA2XIG+dFA8//PC////4//z//////////Pwvy//H" -- Blacksmithing 82.9%   413/498 recipes
	bitmap[51309] = "4//+/76J7//v7/ve+/XR9fLb2f3nN3vLc6vS0+Hf8/XG7/VAIh9B+/f6/////3/////9/f1wCB" -- Tailoring   83.37%   341/409 recipes
	bitmap[51311] = "8//3////fzj//u//////v/7///9///33////////Pw////////////////////////3///////////////////////////D" -- Jewelcrafting  97.5%   540/554 recipes
	bitmap[45363] = "g////7////3///////////////////////////////////////////////////f///////////f" --Inscription 99.77%    439/440 recipes
	bitmap[51313] = "4//////////7///////////w//+//9/n7///////3f//////ZsD" -- Enchanting   94.3%    279/296 recipes

	for i in pairs(tradelist) do

		local tradeName = GetSpellInfo(tradelist[i])
		local tradelink = {}
		tradelink[1] = "|cffffd000|Htrade:"
		tradelink[2] = tradelist[i]
		tradelink[3] = ":450:450:"
		tradelink[4] = playerGUID
		tradelink[5] = ":"
		tradelink[6] = bitmap[tradelist[i]]
		tradelink[7] = "|h["
		tradelink[8] = tradeName
		tradelink[9] = "]|h|r"

		if (bitmap[tradelist[i]]) then
			self:Print(tconcat(tradelink, ""))
		else
			self:Print("There currently is not a generated tradeskill link for: " .. tradeName)
		end
		-- /script DEFAULT_CHAT_FRAME:AddMessage(string.gsub(GetTradeSkillListLink(), "\124", "\124\124"))
	end

end

-------------------------------------------------------------------------------
--- Scans the items in the specified profession
-------------------------------------------------------------------------------
do
	local ORDERED_PROFESSIONS = private.ordered_professions

	local recipe_list = {}
	local output = {}

	local function Sort_AscID(a, b)
		local reca, recb = private.recipe_list[a], private.recipe_list[b]

		return reca.spell_id < recb.spell_id
	end

	local function SortRecipesByID()
		local sorted_recipes = addon.sorted_recipes
		table.wipe(sorted_recipes)

		for n, v in pairs(recipe_list) do
			tinsert(sorted_recipes, n)
		end
		table.sort(sorted_recipes, Sort_AscID)
	end

	local function ProfessionScan(prof_name)
		local master_list = LoadRecipe()

		if not master_list then
			addon:Print(L["DATAMINER_NODB_ERROR"])
			return
		end
		table.wipe(recipe_list)

		if prof_name == private.professions["Smelting"]:lower() then
			prof_name = private.mining_name:lower()
		end

		for i in pairs(master_list) do
			local prof = string.lower(master_list[i].profession)

			if prof and prof == prof_name then
				recipe_list[i] = master_list[i]
			end
		end
		SortRecipesByID()
		table.wipe(output)

		-- Parse the entire recipe database
		for index, id in ipairs(addon.sorted_recipes) do
			local ttscantext = addon:TooltipScanRecipe(id, false, true)

			if ttscantext and ttscantext ~= "" then
				tinsert(output, ttscantext)
			end
		end

		if #output == 0 then
			addon:Debug("ProfessionScan(): output is empty.")
		end
		addon:DisplayTextDump(nil, nil, tconcat(output, "\n"))
		ARLDatamineTT:Hide()
	end

	--- Parses all recipes for a specified profession, scanning their tool tips.
	-- @name AckisRecipeList:ScanProfession
	-- @usage AckisRecipeList:ScanProfession("first aid")
	-- @param prof_name The profession name or the spell ID of it, which you wish to scan.
	-- @return Recipes in the given profession have their tooltips scanned.
	function addon:ScanProfession(prof_name)
		if type(prof_name) == "number" then
			prof_name = GetSpellInfo(prof_name)
		end

		local found = false
		prof_name = string.lower(prof_name)

		local scan_all = prof_name == "all"

		if not scan_all then
			for idx, name in ipairs(ORDERED_PROFESSIONS) do
				if prof_name == name:lower() then
					found = true
					break
				end
			end

			if not found then
				self:Print(L["DATAMINER_NODB_ERROR"])
				return
			end

			ProfessionScan(prof_name)
		else
			for idx, name in ipairs(ORDERED_PROFESSIONS) do
				ProfessionScan(name:lower())
			end
		end
	end

	local FILTER_STRINGS = private.filter_strings
	local ACQUIRE_STRINGS = private.acquire_strings
	local REP_LEVELS = private.rep_level_strings
	local FACTION_NAMES = private.faction_strings
	local Q = private.item_quality_names
	local V = private.game_version_names

	local NUM_FILTER_FLAGS = 128

	local FUNCTION_FORMATS = {
		[A.TRAINER]	= "self:AddRecipeTrainer(%d, %s)",
		[A.VENDOR]	= "self:AddRecipeVendor(%d, %s)",
		[A.MOB_DROP]	= "self:AddRecipeMobDrop(%d, %s)",
		[A.WORLD_DROP]	= "self:AddRecipeWorldDrop(%d, %s)",
		[A.QUEST]	= "self:AddRecipeQuest(%d, %s)",
	}

	local function RecipeDump(id, single)
		local recipe = private.recipe_list[id or 1]

		if single and not recipe then
			addon:Print("Invalid recipe ID.")
			return
		end
		local flag_string
		local specialty = not recipe.specialty and "" or (", "..recipe.specialty)
		local genesis = private.game_versions[recipe.genesis]

		tinsert(output, string.format("-- %s -- %d", recipe.name, recipe.spell_id))
		tinsert(output, string.format("AddRecipe(%d, %d, %s, Q.%s, V.%s, %d, %d, %d, %d%s)",
					      recipe.spell_id, recipe.skill_level, tostring(recipe.item_id), Q[recipe.quality], V[genesis],
					      recipe.optimal_level, recipe.medium_level, recipe.easy_level, recipe.trivial_level, specialty))

		for table_index, bits in ipairs(private.bit_flags) do
			for flag_name, flag in pairs(bits) do
				local bitfield = recipe.flags[private.flag_members[table_index]]

				if bitfield and bit.band(bitfield, flag) == flag then
					if not flag_string then
						flag_string = "F."..FILTER_STRINGS[private.filter_flags[flag_name]]
					else
						flag_string = flag_string..", ".."F."..FILTER_STRINGS[private.filter_flags[flag_name]]
					end
				end
			end
		end
		tinsert(output, string.format("self:AddRecipeFlags(%d, %s)", recipe.spell_id, flag_string))

		flag_string = nil

		for acquire_type, acquire_info in pairs(recipe.acquire_data) do
			if acquire_type == A.REPUTATION then
				for rep_id, rep_info in pairs(acquire_info) do
					local faction_string = FACTION_NAMES[rep_id]

					if not faction_string then
						faction_string = rep_id
						addon:Printf("Recipe %d (%s) - no string for faction %d", recipe.spell_id, recipe.name, rep_id)
					else
						faction_string = "FAC."..faction_string
					end

					for rep_level, level_info in pairs(rep_info) do
						local rep_string = "REP."..REP_LEVELS[rep_level or 1]
						local values

						for vendor_id in pairs(level_info) do
							values = values and (values..", "..vendor_id) or vendor_id
						end
						tinsert(output, string.format("self:AddRecipeRepVendor(%d, %s, %s, %s)", recipe.spell_id, faction_string, rep_string, values))
					end
				end
			elseif FUNCTION_FORMATS[acquire_type] then
				local values

				for id_num in pairs(acquire_info) do
					local saved_id = (type(id_num) == "string" and ("\""..id_num.."\"") or id_num)
					values = values and (values..", "..saved_id) or saved_id
				end
				tinsert(output, string.format(FUNCTION_FORMATS[acquire_type], recipe.spell_id, values))
			else
				for id_num in pairs(acquire_info) do
					if not flag_string then
						flag_string = "A."..ACQUIRE_STRINGS[acquire_type]..", "..(type(id_num) == "string" and ("\""..id_num.."\"") or id_num)
					else
						flag_string = flag_string..", ".."A."..ACQUIRE_STRINGS[acquire_type]..", "..(type(id_num) == "string" and ("\""..id_num.."\"") or id_num)
					end
				end
			end
		end

		if flag_string then
			tinsert(output, string.format("self:AddRecipeAcquire(%d, %s)", recipe.spell_id, flag_string))
		end
		tinsert(output, "")
	end

	local function ProfessionDump(prof_name)
		local master_list = LoadRecipe()

		if not master_list then
			addon:Print(L["DATAMINE_NODB_ERROR"])
			return
		end
		table.wipe(recipe_list)

		if prof_name == private.professions["Smelting"]:lower() then
			prof_name = private.mining_name:lower()
		end
		for i in pairs(master_list) do
			local prof = string.lower(master_list[i].profession)

			if prof and prof == prof_name then
				recipe_list[i] = master_list[i]
			end
		end
		SortRecipesByID()
		table.wipe(output)

		for index, id in ipairs(addon.sorted_recipes) do
			RecipeDump(id, false)
		end
		addon:DisplayTextDump(nil, nil, tconcat(output, "\n"))
	end

	function addon:DumpRecipe(id_num)
		table.wipe(output)
		RecipeDump(id_num, true)
		addon:DisplayTextDump(nil, nil, tconcat(output, "\n"))
	end

	function addon:DumpProfession(prof_name)
		if type(prof_name) == "number" then
			prof_name = GetSpellInfo(prof_name)
		end

		local found = false
		prof_name = string.lower(prof_name)

		local scan_all = prof_name == "all"

		if not scan_all then
			for idx, name in ipairs(ORDERED_PROFESSIONS) do
				if prof_name == name:lower() then
					found = true
					break
				end
			end

			if not found then
				self:Print(L["DATAMINER_NODB_ERROR"])
				return
			end
			ProfessionDump(prof_name)
		else
			for idx, name in ipairs(ORDERED_PROFESSIONS) do
				ProfessionDump(name:lower())
			end
		end
	end
end	-- do

local RECIPE_TYPES = {
	-- JC
	["design: "] = true,
	-- LW or Tailoring
	["pattern: "] = true,
	-- Alchemy or Cooking
	["recipe: "] = true,
	-- BS
	["plans: "] = true,
	-- Enchanting
	["formula: "] = true,
	-- Engineering
	["schematic: "] = true,
	-- First Aid
	["manual: "] = true,

	["alchemy: "] = true,
	["blacksmithing: "] = true,
	["cooking: "] = true,
	["enchanting: "] = true,
	["engineering: "] = true,
	["first aid: "] = true,
	["inscription: "] = true,
	["jewelcrafting: "] = true,
	["leatherworking: "] = true,
	["tailoring: "] = true,
}

--- Scans the items on a vendor, determining which recipes are available if any and compares it with the database entries
-- @name AckisRecipeList:ScanVendor
-- @usage AckisRecipeList:ScanVendor()
-- @return Obtains all the vendor information on tradeskill recipes and attempts to compare the current vendor with the internal database
do
	local output = {}

	function addon:ScanVendor()
		if not (UnitExists("target") and (not UnitIsPlayer("target")) and (not UnitIsEnemy("player", "target"))) then	-- Make sure the target exists and is a NPC
			self:Print(L["DATAMINER_VENDOR_NOTTARGETTED"])
			return
		end
		local recipe_list = LoadRecipe()		-- Get internal database

		if not recipe_list then
			self:Print(L["DATAMINER_NODB_ERROR"])
			return
		end
		local targetname = UnitName("target")		-- Get its name
		local targetID = tonumber(string.sub(UnitGUID("target"), -12, -7), 16)		-- Get the NPC ID
		local added = false

		table.wipe(output)

		tinsert(output, "Vendor Name: "..targetname.." NPC ID: "..targetID)
		-- Parse all the items on the merchant
		for i = 1, GetMerchantNumItems(), 1 do
			local name, _, _, _, numAvailable = GetMerchantItemInfo(i)

			if name then
				-- Lets scan recipes only on vendors
				local matchtext = string.match(name, "%a+: ")

				-- Check to see if we're dealing with a recipe
				if matchtext and RECIPE_TYPES[string.lower(matchtext)] then
					local item_link = GetMerchantItemLink(i)
					local item_id = ItemLinkToID(item_link)
					local spell_id = RECIPE_TO_SPELL_MAP[item_id]

					if spell_id then
						local ttscantext = addon:TooltipScanRecipe(spell_id, true, true)

						if ttscantext and ttscantext ~= "" then
							added = true
							tinsert(output, ttscantext)
						end

						-- Check the database to see if the vendor is listed as an acquire method.
						local acquire = recipe_list[spell_id].acquire_data
						local vendor_data = acquire[A.VENDOR]
						local rep_data = acquire[A.REPUTATION]
						local found = false

						if vendor_data then
							for id_num in pairs(vendor_data) do
								if id_num == targetID then
									found = true
									break
								end
							end
						elseif rep_data then
							for id_num, info in pairs(rep_data) do
								if found then
									break
								end

								for rep_level, level_info in pairs(info) do
									for vendor_id in pairs(level_info) do
										if vendor_id == targetID then
											found = true
										end
									end
								end
							end
						end

						if not found then
							added = true
							tinsert(output, string.format("Vendor ID missing from \"%s\" %d.", recipe_list[spell_id].name, spell_id))
						end
					else
						--[===[@debug@
						added = true
						tinsert(output, "Spell ID not found for: " .. name)
						--@end-debug@]===]
					end
				end
			end
		end

		if added then
			self:DisplayTextDump(nil, nil, tconcat(output, "\n"))
		end
		ARLDatamineTT:Hide()
	end
end	-- do

--- Parses all the recipes in the database, and scanning their tooltips.
-- @name AckisRecipeList:TooltipScanDatabase
-- @usage AckisRecipeList:TooltipScanDatabase()
-- @return Entire recipe database has its tooltips scanned.
do
	local output = {}

	function addon:TooltipScanDatabase()
		-- Get internal database
		local recipe_list = LoadRecipe()

		if (not recipe_list) then
			self:Print(L["DATAMINER_NODB_ERROR"])
			return
		end
		table.wipe(output)

		-- Parse the entire recipe database
		for i in pairs(recipe_list) do

			local ttscantext = addon:TooltipScanRecipe(i, false, true)
			if (ttscantext) then
				tinsert(output, ttscantext)
			end
		end
		self:DisplayTextDump(nil, nil, tconcat(output, "\n"))
	end
end	-- do
--- Parses a specific recipe in the database, and scanning its tooltip
-- @name AckisRecipeList:TooltipScanRecipe
-- @param spell_id The [[[http://www.wowwiki.com/SpellLink|Spell ID]]] of the recipe being added to the database
-- @param is_vendor Boolean to determine if we're viewing a vendor or not
-- @param is_largescan Boolean to determine if we're doing a large scan
-- @return Recipe has its tooltips scanned


-- Table to store scanned information. Wiped and re-used every scan.
local scan_data = {}

do
	---------------------------------------------------------------------------------------------------------
	----This table, DO_NOT_SCAN, contains itemid's that will not cache on the servers
	---------------------------------------------------------------------------------------------------------

	local DO_NOT_SCAN = {
		-------------------------------------------------------------------------------
		--Leatherworking
		-------------------------------------------------------------------------------
		[35214] = true,	[32434] = true,	[15769] = true,
		[32431] = true,	[32432] = true,	[35215] = true,	[35521] = true,
		[35520] = true,	[35524] = true,	[35517] = true,	[35528] = true,
		[35527] = true,	[35523] = true,	[35549] = true,	[35218] = true,
		[35217] = true,	[35216] = true,	[35546] = true,	[35541] = true, [15756] = true,
		[15777] = true,  [32433] = true,  [29729] = true,  [29732] = true,   [32744] = true,
		[15773] = true,	[30301] = true,	[15745] = true,	[35302] = true,	[15774] = true,

		-------------------------------------------------------------------------------
		--Tailoring
		-------------------------------------------------------------------------------
		[14477] = true, [14485] = true, [30281] = true, [14478] = true, [14500] = true,
		[32439] = true, [14479] = true, [32447] = true, [14480] = true, [32437] = true,
		[14495] = true, [14505] = true, [35204] = true,  [35205] = true,   [35206] = true,
		[14473] = true, [14488] = true,  [14481] = true,
		[35309] = true,	[30280] = true,	[14492] = true,	[14491] = true,

		-------------------------------------------------------------------------------
		--Jewelcrafting
		-------------------------------------------------------------------------------
		[23130] = true,  [23140] = true, [23137] = true, [23131] = true, [23148] = true,
		[35538] = true, [35201] = true, [35533] = true, [35200] = true,  [23147] = true,
		[23135] = true,  [35203] = true, [35198] = true, [23152] = true,  [23151] = true,
		[23141] = true, [28596] = true,  [28291] = true,	[23153] = true,

		-------------------------------------------------------------------------------
		--Alchemy
		-------------------------------------------------------------------------------
		[22925] = true,  [13480] = true,  [13481] = true,   [13493] = true,	[35295] = true,
		[44568] = true,

		-------------------------------------------------------------------------------
		--Cooking
		-------------------------------------------------------------------------------
		[39644] = true,

		-------------------------------------------------------------------------------
		--Blacksmithing
		-------------------------------------------------------------------------------
		[32441] = true,   [32443] = true,  [12687] = true, [12714] = true,  [12688 ] = true,
		[35211] = true,  [35209] = true, [35210] = true,    [12706] = true,  [7982] = true,
		[12718] = true,		[23621] = true,	[35208] = true,	[12716] = true,	[23632] = true,
		[23633] = true,	[30324] = true,	[23637] = true,	[31393] = true,[22221] = true,
		[12690] = true,	[31394] = true,[31395] = true,[23630] = true,[23629] = true,[7978] = true,
		[41120] = true,	[12717] = true,[22219] = true,[23627] = true,

		-------------------------------------------------------------------------------
		--Engineering
		-------------------------------------------------------------------------------
		[35196] = true,    [21734] = true,  [18292] = true,  [21727] = true,  [21735] = true,  [16053] = true,  [21729] = true,
		[16047] = true,[21730] = true,[21731] = true,[21732] = true,[4411] = true,   [21733] = true,  [21728] = true,
		[35186] = true,	[18655] = true,

		-------------------------------------------------------------------------------
		--Enchanting
		-------------------------------------------------------------------------------
		[16222] = true,	[20734] = true,	[20729] = true,	[20731] = true,	[16246] = true,
	}

	local output = {}

	function addon:TooltipScanRecipe(spell_id, is_vendor, is_largescan)
		local recipe_list = LoadRecipe()

		if not recipe_list then
			self:Print(L["DATAMINER_NODB_ERROR"])
			return
		end
		local recipe = recipe_list[spell_id]

		if not recipe then
			self:Debug("Spell ID %d does not exist in the database.", tonumber(spell_id))
			return
		end
		local recipe_name = recipe.name
		local game_vers = private.game_versions[recipe.genesis]

		table.wipe(output)

		if not game_vers then
			tinsert(output, "No expansion information: " .. tostring(spell_id) .. " " .. recipe_name)
		elseif game_vers > private.game_versions.WOTLK then
			tinsert(output, "Expansion information too high: " .. tostring(spell_id) .. " " .. recipe_name)
		end
		local optimal = recipe.optimal_level
		local medium = recipe.medium_level
		local easy = recipe.easy_level
		local trivial = recipe.trivial_level
		local skill_level = recipe.skill_level

		if not optimal then
			tinsert(output, "No skill level information: " .. tostring(spell_id) .. " " .. recipe_name)
		else
			-- Highest level is greater than the skill of the recipe
			if optimal > skill_level then
				tinsert(output, "Skill Level Error (optimal_level > skill_level): " .. tostring(spell_id) .. " " .. recipe_name)
			elseif optimal < skill_level then
				tinsert(output, "Skill Level Error (optimal_level < skill_level): " .. tostring(spell_id) .. " " .. recipe_name)
			end

			-- Level info is messed up
			if optimal > medium or optimal > easy or optimal > trivial or medium > easy or medium > trivial or easy > trivial then
				tinsert(output, "Skill Level Error: " .. tostring(spell_id) .. " " .. recipe_name)
			end
		end
		local recipe_link = GetSpellLink(recipe.spell_id)

		if not recipe_link then
			if recipe.profession ~= private.runeforging_name then		-- Lets hide this output for runeforging.
				self:Printf("Missing spell_link for ID %d (%s).", spell_id, recipe_name)
			end
			return
		end
		ARLDatamineTT:SetOwner(WorldFrame, "ANCHOR_NONE")
		GameTooltip_SetDefaultAnchor(ARLDatamineTT, UIParent)

		ARLDatamineTT:SetHyperlink(recipe_link)

		-- Check to see if this is a recipe tooltip.
		local text = string.lower(_G["ARLDatamineTTTextLeft1"]:GetText())
		local match_text = string.match(text, "%a+: ")

		if not RECIPE_TYPES[match_text] and not (string.find(text, "smelt") or string.find(text, "sunder") or string.find(text, "shatter")) then
			ARLDatamineTT:Hide()
			return
		end
		local reverse_lookup = GetReverseLookup(recipe_list)

		local item_id = SPELL_TO_RECIPE_MAP[spell_id]

		wipe(scan_data)

		if item_id and not DO_NOT_SCAN[item_id] then
			local item_name, item_link, item_quality = GetItemInfo(item_id)

			if item_name then
				scan_data.quality = item_quality

				ARLDatamineTT:SetHyperlink(item_link)
				self:ScanToolTip(recipe_name, recipe_list, reverse_lookup, is_vendor)
			else
				local querier_string = _G.Querier and string.format(" To fix: /iq %d", item_id) or ""

				tinsert(output, string.format("%s: %d", recipe.name, spell_id))
				tinsert(output, string.format("    Recipe item not in cache.%s", querier_string))
			end
		elseif not item_id then
			-- We are dealing with a recipe that does not have an item to learn it from.
			-- Lets check the recipe flags to see if we have a data error and the item should exist
			if not recipe:IsFlagged("common1", "RETIRED") then
				if (recipe:IsFlagged("common1", "VENDOR") or recipe:IsFlagged("common1", "INSTANCE") or recipe:IsFlagged("common1", "RAID")) then
					tinsert(output, string.format("%s: %d", recipe.name, spell_id))
					tinsert(output, "    No match found in the SPELL_TO_RECIPE_MAP table.")
				elseif recipe:IsFlagged("common1", "TRAINER") and recipe.quality ~= private.item_qualities["COMMON"] then
					local QS = private.item_quality_names
 
					tinsert(output, string.format("%s: %d", recipe.name, spell_id))
					tinsert(output, string.format("    Wrong quality: Q.%s - should be Q.COMMON.", QS[recipe.quality]))
				end
			end
		end
		ARLDatamineTT:Hide()

		-- Add the flag scan to the table if it's not nil
		local results = self:PrintScanResults()

		if results then
			tinsert(output, results)
		end

		if is_largescan then
			return tconcat(output, "\n")
		else
			self:Print(tconcat(output, "\n"))
		end
	end
end	-- do

-------------------------------------------------------------------------------
-- Tooltip-scanning code
-------------------------------------------------------------------------------
do
	local SPECIALTY_TEXT = {
		["requires spellfire tailoring"] = 26797,
		["requires mooncloth tailoring"] = 26798,
		["requires shadoweave tailoring"] = 26801,
		["requires dragonscale leatherworking"] = 10657,
		["requires elemental leatherworking"] = 10659,
		["requires tribal leatherworking"] = 10661,
		["requires gnomish engineer"] = 20219,
		["requires goblin engineer"] = 20222,
		["requires armorsmith"] = 9788,
		["requires master axesmith"] = 17041,
		["requires master hammersmith"] = 17040,
		["requires master swordsmith"] = 17039,
		["requires weaponsmith"] = 9787,
	}

	local FACTION_TEXT = {
		["thorium brotherhood"] = 98,
		["zandalar tribe"] = 100,
		["argent dawn"] = 96,
		["timbermaw hold"] = 99,
		["cenarion circle"] = 97,
		["the aldor"] = 101,
		["the consortium"] = 105,
		["the scryers"] = 110,
		["the sha'tar"] = 111,
		["the mag'har"] = 108,
		["cenarion expedition"] = 103,
		["honor hold"] = 104,
		["thrallmar"] = 104,
		["the violet eye"] = 114,
		["sporeggar"] = 113,
		["kurenai"] = 108,
		["keepers of time"] = 106,
		["the scale of the sands"] = 109,
		["lower city"] = 107,
		["ashtongue deathsworn"] = 102,
		["alliance vanguard"] = 131,
		["valiance expedition"] = 126,
		["horde expedition"] = 130,
		["the taunka"] = 128,
		["the hand of vengeance"] = 127,
		["explorers' league"] = 125,
		["the kalu'ak"] = 120,
		["shattered sun offensive"] = 112,
		["warsong offensive"] = 129,
		["kirin tor"] = 118,
		["the wyrmrest accord"] = 122,
		["knights of the ebon blade"] = 117,
		["frenzyheart tribe"] = 116,
		["the oracles"] = 121,
		["argent crusade"] = 115,
		["the sons of hodir"] = 119,
	}

	local FACTION_LEVELS = {
		["neutral"] = 0,
		["friendly"] = 1,
		["honored"] = 2,
		["revered"] = 3,
		["exalted"] = 4,
	}

	local CLASS_TYPES = {
		["Death Knight"]	= 21, 	["Druid"]	= 22, 	["Hunter"]	= 23,
		["Mage"]		= 24, 	["Paladin"]	= 25, 	["Priest"]	= 26,
		["Shaman"]		= 27, 	["Rogue"]	= 28, 	["Warlock"]	= 29,
		["Warrior"]		= 30,
	}

	local ORDERED_CLASS_TYPES = {
		[1]	= "Death Knight", 	[2]	= "Druid", 	[3]	= "Hunter",
		[4]	= "Mage", 		[5]	= "Paladin", 	[6]	= "Priest",
		[7]	= "Shaman", 		[8]	= "Rogue", 	[9]	= "Warlock",
		[10]	= "Warrior",
	}

	local ROLE_TYPES = {
		["dps"]		= 51, 	["tank"]	= 52, 	["healer"]	= 53,
		["caster"]	= 54,
	}

	local ORDERED_ROLE_TYPES = {
		[1]	= "dps", 	[2]	= "tank", 	[3]	= "healer",
		[4]	= "caster",
	}

	local ENCHANT_TO_ITEM = {
		["Cloak"]	= "Back",
		["Ring"]	= "Finger",
		["2H Weapon"]	= "Two-Hand",
	}

	local ITEM_TYPES = {
		-- Armor types
		["Cloth"]	= 56, 	["Leather"]	= 57, 	["Mail"]	= 58,
		["Plate"]	= 59, 	["Back"]	= 60, 	["Trinket"]	= 61,
		["Finger"]	= 62, 	["Neck"]	= 63, 	["Shield"]	= 64,

		-- Weapon types
		["One-Hand"]	= 66, 	["Two-Hand"]	= 67, 	["Axe"]		= 68,
		["Sword"]	= 69, 	["Mace"]	= 70, 	["Polearm"]	= 71,
		["Dagger"]	= 72, 	["Staff"]	= 73, 	["Wand"]	= 74,
		["Thrown"]	= 75, 	["Bow"]		= 76, 	["CrossBow"]	= 77,
		["Ammo"]	= 78, 	["Fist Weapon"]	= 79, 	["Gun"]		= 80,
	}

	local ORDERED_ITEM_TYPES = {
		-- Armor types
		[1]	= "Cloth", 	[2]	= "Leather", 	[3]	= "Mail",
		[4]	= "Plate", 	[5]	= "Back", 	[6]	= "Trinket",
		[7]	= "Finger", 	[8]	= "Neck", 	[9]	= "Shield",

		-- Weapon types
		[11]	= "One-Hand", 	[12]	= "Two-Hand", 	[13]	= "Axe",
		[14]	= "Sword", 	[15]	= "Mace", 	[16]	= "Polearm",
		[17]	= "Dagger", 	[18]	= "Staff", 	[19]	= "Wand",
		[20]	= "Thrown", 	[21]	= "Bow", 	[22]	= "CrossBow",
		[23]	= "Ammo", 	[24]	= "Fist Weapon", 	[25]	= "Gun",
	}

	--- Parses the mining tooltip for certain keywords, comparing them with the database flags
	-- @name AckisRecipeList:ScanToolTip
	-- @param name The name of the recipe
	-- @param recipe_list Recipe database
	-- @param reverse_lookup Reverse lookup database
	-- @param is_vendor Boolean to indicate if we're scanning a vendor
	-- @return Scans a tooltip, and outputs the missing or extra filter flags
	function addon:ScanToolTip(name, recipe_list, reverse_lookup, is_vendor)
		scan_data.match_name = name
		scan_data.recipe_list = recipe_list
		scan_data.reverse_lookup = reverse_lookup
		scan_data.is_vendor = is_vendor

		-- Parse all the lines of the tooltip
		for i = 1, ARLDatamineTT:NumLines(), 1 do
			local text_l = _G["ARLDatamineTTTextLeft" .. i]:GetText()
			local text_r = _G["ARLDatamineTTTextRight" .. i]:GetText()
			local text

			if text_r then
				text = text_l .. " " .. text_r
			else
				text = text_l
			end

			local text = string.lower(text)

			-- Check for recipe/item binding
			-- The recipe binding is within the first few lines of the tooltip always
			if string.match(text, "binds when picked up") then
				if (i < 3) then
					scan_data.recipe_bop = true
				else
					scan_data.item_bop = true
				end
			end

			-- Recipe Specialities
			if SPECIALTY_TEXT[text] then
				scan_data.specialty = SPECIALTY_TEXT[text]
			end

			-- Recipe Reputations
			local rep, replevel = string.match(text_l, "Requires (.+) %- (.+)")

			if rep and replevel and FACTION_TEXT[rep] then
				scan_data.repid = FACTION_TEXT[rep]
				scan_data.repidlevel = FACTION_LEVELS[replevel]
			end

			-- Flag so that we don't bother checking for classes if we're sure of the class
			-- AKA +spell hit == caster DPS only no matter what other stats are on it
			-- Saves processing cycles and it won't cause the flags to be overwritten if a non-specific stat is found after
			scan_data.verifiedclass = false

			if not scan_data.verifiedclass then
				-- Certain stats can be considered for a specific role (aka spell hit == caster dps).
				if string.match(text, "strength") and not string.match(text, "strength of the clefthoof") and not string.match(text,  "set:") then
					scan_data.dps = true
				elseif string.match(text, "agility") then
					scan_data.dps = true
				elseif string.match(text, "spirit") or string.match(text, "intellect") then
					scan_data.caster = true
					scan_data.healer = true
				elseif string.match(text, "spell power") then
					scan_data.caster = true
					scan_data.healer = true
				elseif string.match(text, "spell crit") then
					scan_data.caster = true
					scan_data.healer = true
				elseif string.match(text, "spell hit") then
					scan_data.caster = true
					scan_data.verifiedclass = true
				elseif string.match(text, "spell penetration") then
					scan_data.caster = true
					scan_data.verifiedclass = true
				elseif string.match(text, "mana per 5 sec.") or string.match(text, "mana every 5 seconds") then
					scan_data.caster = true
					scan_data.healer = true
				elseif string.match(text, "attack power") then
					scan_data.dps = true
				elseif string.match(text, "expertise") then
					scan_data.dps = true
					scan_data.tank = true
				elseif string.match(text, "melee crit") then
					scan_data.dps = true
				elseif string.match(text, "critical hit") then
					scan_data.dps = true
				elseif string.match(text, "weapon damage") then
					scan_data.dps = true
				elseif string.match(text, "ranged crit") then
					scan_data.dps = true
					scan_data.verifiedclass = true
				elseif string.match(text, "melee haste") then
					scan_data.dps = true
				elseif string.match(text, "ranged haste") then
					scan_data.dps = true
					scan_data.verifiedclass = true
				elseif string.match(text, "melee hit") then
					scan_data.dps = true
				elseif string.match(text, "ranged hit") then
					scan_data.dps = true
					scan_data.verifiedclass = true
				elseif string.match(text, "armor pen") then
					scan_data.dps = true
				elseif string.match(text, "feral attack power") then
					scan_data.tank = true
					scan_data.dps = true
				elseif string.match(text, "defense") and not string.match(text, "defenseless") then
					scan_data.tank = true
					scan_data.verifiedclass = true
				elseif string.match(text, "block") then
					scan_data.tank = true
					scan_data.verifiedclass = true
				elseif string.match(text, "parry") then
					scan_data.tank = true
					scan_data.verifiedclass = true
				elseif string.match(text, "dodge") and not string.match(text,  "set:") then
					scan_data.tank = true
					scan_data.verifiedclass = true
				end
			end

			-- Classes
			local class_type = string.match(text_l, "Classes: (.+)")

			if class_type then
				for idx, class in ipairs(ORDERED_CLASS_TYPES) do
					if string.match(class_type, class) then
						scan_data[class] = true
						scan_data.found_class = true
					end
				end
			end

			-- Armor types
			if ITEM_TYPES[text_l] then
				scan_data[text_l] = true
			elseif text_l == "Held In Off-hand" or text_l == "Off Hand" or text_l == "Main Hand" then	-- Special cases.
				scan_data["One-Hand"] = true
			elseif text_l == "Projectile" then
				scan_data["Ammo"] = true
			end

			if text_r and ITEM_TYPES[text_r] then
				scan_data[text_r] = true
			end

			-- Enchantment voodoo
			local ench_type, _ = string.match(text_l, "Enchant (.+) %- (.+)")

			if ench_type then
				if ITEM_TYPES[ench_type] then
					scan_data[ench_type] = true
				elseif ITEM_TYPES[ENCHANT_TO_ITEM[ench_type]] then
					scan_data[ENCHANT_TO_ITEM[ench_type]] = true
				elseif ench_type == "Weapon" then		-- Special case.
					scan_data["One-Hand"] = true
					scan_data["Two-Hand"] = true
				end
			end
		end	-- for
	end

	-- Flag data for printing. Wiped and re-used.
	local missing_flags = {}
	local extra_flags = {}
	local output = {}

	local ACQUIRE_TO_FILTER_MAP = {
		[A.MOB_DROP]	= F.MOB_DROP,
		[A.QUEST]	= F.QUEST,
		[A.SEASONAL]	= F.SEASONAL,
		[A.WORLD_DROP]	= F.WORLD_DROP,
	}
	local FILTER_TO_ACQUIRE_MAP

	--- Prints out the results of the tooltip scan.
	-- @name AckisRecipeList:PrintScanResults
	function addon:PrintScanResults()
		if not scan_data.match_name then
			return
		end

		-- Parse the recipe database until we get a match on the name
		local recipe_name = string.gsub(scan_data.match_name, "%a+%?: ", "")
		local spell_id = scan_data.reverse_lookup[recipe_name]

		if not spell_id then
			self:Print(recipe_name .. " has no reverse lookup")
			return
		end
		local recipe = scan_data.recipe_list[spell_id]
		local acquire_data = recipe["acquire_data"]

		local FS = private.filter_strings
		local flag_format = "F.%s"

		table.wipe(missing_flags)
		table.wipe(extra_flags)
		table.wipe(output)

		-- If we're a vendor scan,  do some extra checks
		if scan_data.is_vendor then
			-- Check to see if the vendor flag is set
			if not recipe:IsFlagged("common1", "VENDOR") then
				tinsert(missing_flags, string.format(flag_format, FS[F.VENDOR]))
			end

			-- Check to see if we're in a PVP zone
			if (GetSubZoneText() == "Wintergrasp Fortress" or GetSubZoneText() == "Halaa") and not recipe:IsFlagged("common1", "PVP") then
				tinsert(missing_flags, string.format(flag_format, FS[F.PVP]))
			elseif recipe:IsFlagged("common1", "PVP") and not (GetSubZoneText() == "Wintergrasp Fortress" or GetSubZoneText() == "Halaa") then
				tinsert(extra_flags, string.format(flag_format, FS[F.PVP]))
			end
		end

		-- -- If we've picked up at least one class flag
		if scan_data.found_class then
			for k, v in ipairs(ORDERED_CLASS_TYPES) do
				if scan_data[v] and not recipe:IsFlagged("class1", FS[CLASS_TYPES[v]]) then
					tinsert(missing_flags, string.format(flag_format, FS[CLASS_TYPES[v]]))
				elseif not scan_data[v] and recipe:IsFlagged("class1", FS[CLASS_TYPES[v]]) then
					tinsert(extra_flags, string.format(flag_format, FS[CLASS_TYPES[v]]))
				end
			end
		end

		if scan_data.item_bop and not recipe:IsFlagged("common1", "IBOP") then
			tinsert(missing_flags, string.format(flag_format, FS[F.IBOP]))

			if recipe:IsFlagged("common1", "IBOE") then
				tinsert(extra_flags, string.format(flag_format, FS[F.IBOE]))
			end

			if recipe:IsFlagged("common1", "IBOA") then
				tinsert(extra_flags, string.format(flag_format, FS[F.IBOA]))
			end
		elseif not recipe:IsFlagged("common1", "IBOE") and not scan_data.item_bop then
			tinsert(missing_flags, string.format(flag_format, FS[F.IBOE]))

			if recipe:IsFlagged("common1", "IBOP") then
				tinsert(extra_flags, string.format(flag_format, FS[F.IBOP]))
			end

			if recipe:IsFlagged("common1", "IBOA") then
				tinsert(extra_flags, string.format(flag_format, FS[F.IBOA]))
			end
		end

		if scan_data.recipe_bop and not recipe:IsFlagged("common1", "RBOP") then
			tinsert(missing_flags, string.format(flag_format, FS[F.RBOP]))

			if recipe:IsFlagged("common1", "RBOE") then
				tinsert(extra_flags, string.format(flag_format, FS[F.RBOE]))
			end

			if recipe:IsFlagged("common1", "RBOA") then
				tinsert(extra_flags, string.format(flag_format, FS[F.RBOA]))
			end

		elseif not recipe:IsFlagged("common1", "TRAINER") and not recipe:IsFlagged("common1", "RBOE") and not scan_data.recipe_bop then
			tinsert(missing_flags, string.format(flag_format, FS[F.RBOE]))

			if recipe:IsFlagged("common1", "RBOP") then
				tinsert(extra_flags, string.format(flag_format, FS[F.RBOP]))
			end

			if recipe:IsFlagged("common1", "RBOA") then
				tinsert(extra_flags, string.format(flag_format, FS[F.RBOA]))
			end
		end

		for k, v in ipairs(ORDERED_ROLE_TYPES) do
			local role_string = FS[ROLE_TYPES[v]]

			if scan_data[v] and not recipe:IsFlagged("common1", role_string) then
				tinsert(missing_flags, string.format(flag_format, role_string))
			elseif not scan_data[v] and recipe:IsFlagged("common1", role_string) then
				tinsert(extra_flags, string.format(flag_format, role_string))
			end
		end

		for k, v in ipairs(ORDERED_ITEM_TYPES) do
			if scan_data[v] and not recipe:IsFlagged("item1", FS[ITEM_TYPES[v]]) then
				tinsert(missing_flags, string.format(flag_format, FS[ITEM_TYPES[v]]))
			elseif not scan_data[v] and recipe:IsFlagged("item1", FS[ITEM_TYPES[v]]) then
				tinsert(extra_flags, string.format(flag_format, FS[ITEM_TYPES[v]]))
			end
		end

		-- Reputations
		local repid = scan_data.repid
		local found_problem = false

		if repid and not recipe:IsFlagged("reputation1", FS[repid]) and not recipe:IsFlagged("reputation2", FS[repid]) then
			tinsert(missing_flags, repid)

			local rep_data = acquire_data[A.REPUTATION]

			if rep_data then
				for rep_id, rep_info in pairs(acquire_info) do
					for rep_level, level_info in pairs(rep_info) do
						if rep_level ~= scan_data.repidlevel then
							tinsert(output, "    Wrong reputation level.")
						end
					end
				end
			end
		end

		-- Make sure the recipe's filter flags match with its acquire types.
		if not FILTER_TO_ACQUIRE_MAP then
			FILTER_TO_ACQUIRE_MAP = {}

			for k, v in pairs(ACQUIRE_TO_FILTER_MAP) do
				FILTER_TO_ACQUIRE_MAP[v] = k
			end
		end

		for acquire_type in pairs(acquire_data) do
			local flag = ACQUIRE_TO_FILTER_MAP[acquire_type]

			if flag and not recipe:IsFlagged("common1", FS[flag]) then
				tinsert(missing_flags, string.format(flag_format, FS[flag]))
			end
		end

		if (acquire_data[A.VENDOR] or acquire_data[A.REPUTATION]) and not recipe:IsFlagged("common1", "VENDOR") then
			tinsert(missing_flags, string.format(flag_format, FS[F.VENDOR]))
		end

		if recipe:IsFlagged("common1", "VENDOR") and not (acquire_data[A.VENDOR] or acquire_data[A.REPUTATION]) then
			tinsert(extra_flags, string.format(flag_format, FS[F.VENDOR]))
		end

		if acquire_data[A.TRAINER] and not recipe:IsFlagged("common1", "TRAINER") then
			tinsert(missing_flags, string.format(flag_format, FS[F.TRAINER]))
		end

		if recipe:IsFlagged("common1", "TRAINER") and not acquire_data[A.TRAINER] then
			if not acquire_data[A.CUSTOM] then
				tinsert(extra_flags, string.format(flag_format, FS[F.TRAINER]))
			end
		end

		for flag, acquire_type in pairs(FILTER_TO_ACQUIRE_MAP) do
			if recipe:IsFlagged("common1", FS[flag]) and not acquire_data[acquire_type] then
				tinsert(extra_flags, string.format(flag_format, FS[flag]))
			end
		end

		if #missing_flags > 0 or #extra_flags > 0 then
			found_problem = true

			-- Add a string of the missing flag numbers
			if #missing_flags > 0 then
				tinsert(output, "    Missing flags: " .. tconcat(missing_flags, ", "))
			end

			-- Add a string of the extra flag numbers
			if #extra_flags > 0 then
				tinsert(output, "    Extra flags: " .. tconcat(extra_flags, ", "))
			end
			local found_type = false

			for k, v in ipairs(ORDERED_ITEM_TYPES) do
				if scan_data[v] then
					found_type = true
					break
				end
			end

			if not found_type then
				tinsert(output, "    Missing: item type flag")
			end
		end

		-- Check to see if we have a horde/alliance flag,  all recipes must have one of these
		if not recipe:IsFlagged("common1", "ALLIANCE") and not recipe:IsFlagged("common1", "HORDE") then
			found_problem = true
			tinsert(output, "    Horde or Alliance not selected.")
		end

		-- Check to see if we have an obtain method flag,  all recipes must have at least one of these
		if (not recipe:IsFlagged("common1", "TRAINER") and not recipe:IsFlagged("common1", "VENDOR") and not recipe:IsFlagged("common1", "INSTANCE") and not recipe:IsFlagged("common1", "RAID")
		    and not recipe:IsFlagged("common1", "SEASONAL") and not recipe:IsFlagged("common1", "QUEST") and not recipe:IsFlagged("common1", "PVP") and not recipe:IsFlagged("common1", "WORLD_DROP")
		    and not recipe:IsFlagged("common1", "MOB_DROP") and not recipe:IsFlagged("common1", "DISC")) then
			found_problem = true
			tinsert(output, "    No obtain flag.")
		end

		-- Check for recipe binding information,  all recipes must have one of these
		if not recipe:IsFlagged("common1", "RBOE") and not recipe:IsFlagged("common1", "RBOP") and not recipe:IsFlagged("common1", "RBOA") then
			found_problem = true
			tinsert(output, "    No recipe binding information.")
		end

		-- Check for item binding information,  all recipes must have one of these
		if not recipe:IsFlagged("common1", "IBOE") and not recipe:IsFlagged("common1", "IBOP") and not recipe:IsFlagged("common1", "IBOA") then
			found_problem = true
			tinsert(output, "    No item binding information.")
		end

		-- We need to code this better.  Some items (aka bags) won't have a role at all.
		-- Check for player role flags
		if not scan_data.tank and not scan_data.healer and not scan_data.caster and not scan_data.dps and not NO_ROLE_FLAG[spell_id] then
			found_problem = true
			tinsert(output, "    No player role flag.")
		end

		if scan_data.specialty then
			if not recipe.specialty then
				found_problem = true
				tinsert(output, string.format("    Missing Specialty: %s", scan_data.specialty))
			elseif recipe.specialty ~= scan_data.specialty then
				tinsert(output, string.format("    Wrong Specialty: %s - should be %s ", recipe.specialty, scan_data.specialty))
			end
		elseif recipe.specialty then
			found_problem = true
			tinsert(output, string.format("    Extra Specialty: %s", recipe.specialty))
		end

		if scan_data.quality ~= recipe.quality then
			local QS = private.item_quality_names

			found_problem = true
			tinsert(output, string.format("    Wrong quality: Q.%s - should be Q.%s.", QS[recipe.quality], QS[scan_data.quality]))
		end

		if found_problem then
			tinsert(output, 1, string.format("%s: <a href=\"http://www.wowhead.com/?spell=%d\">%d</a>", recipe_name, spell_id, spell_id))
			return tconcat(output, "\n")
		else
			return
		end
	end
end