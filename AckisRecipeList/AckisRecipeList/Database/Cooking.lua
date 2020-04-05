--[[
************************************************************************
Cooking.lua
Cooking data for all of Ackis Recipe List
************************************************************************
File date: 2010-05-18T07:53:19Z
File revision: @file-revision@
Project revision: @project-revision@
Project version: v2.01-8-g9458672
************************************************************************
Please see http://www.wowace.com/addons/arl/ for more information.
************************************************************************
This source code is released under All Rights Reserved.
************************************************************************
]]--

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local MODNAME	= "Ackis Recipe List"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)
local L		= LibStub("AceLocale-3.0"):GetLocale(MODNAME)

local private	= select(2, ...)

-------------------------------------------------------------------------------
-- Filter flags. Acquire types, and Reputation levels.
-------------------------------------------------------------------------------
local F		= private.filter_flags
local A		= private.acquire_types
local Q		= private.item_qualities
local REP	= private.rep_levels
local FAC	= private.faction_ids
local V		= private.game_versions

local initialized = false
local num_recipes = 0

--------------------------------------------------------------------------------------------------------------------
-- Counter and wrapper function
--------------------------------------------------------------------------------------------------------------------
local function AddRecipe(spell_id, skill_level, item_id, quality, genesis, optimal_level, medium_level, easy_level, trivial_level)
	num_recipes = num_recipes + 1
	addon:AddRecipe(spell_id, skill_level, item_id, quality, 2550, nil, genesis, optimal_level, medium_level, easy_level, trivial_level)
end

function addon:InitCooking()
	if initialized then
		return num_recipes
	end
	initialized = true

	-- Charred Wolf Meat -- 2538
	AddRecipe(2538, 1, 2679, Q.COMMON, V.ORIG, 1, 45, 65, 85)
	self:AddRecipeFlags(2538, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(2538, A.CUSTOM, 8)

	-- Spiced Wolf Meat -- 2539
	AddRecipe(2539, 10, 2680, Q.COMMON, V.ORIG, 10, 50, 70, 90)
	self:AddRecipeFlags(2539, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(2539, 1355, 4210, 19369, 16719, 3399, 19185, 8306, 5482, 16676, 1430, 18988, 4552, 3026, 16253, 18987, 1699, 16277, 3067, 18993, 6286, 1382, 17246, 5159, 3087)

	-- Roasted Boar Meat -- 2540
	AddRecipe(2540, 1, 2681, Q.COMMON, V.ORIG, 1, 45, 65, 85)
	self:AddRecipeFlags(2540, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(2540, A.CUSTOM, 8)

	-- Coyote Steak -- 2541
	AddRecipe(2541, 50, 2684, Q.COMMON, V.ORIG, 50, 90, 110, 130)
	self:AddRecipeFlags(2541, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(2541, 1355, 4210, 19369, 16719, 3399, 19185, 8306, 5482, 16676, 1430, 18988, 4552, 3026, 16253, 18987, 1699, 16277, 3067, 18993, 6286, 1382, 17246, 5159, 3087)

	-- Goretusk Liver Pie -- 2542
	AddRecipe(2542, 50, 724, Q.COMMON, V.ORIG, 50, 90, 110, 130)
	self:AddRecipeFlags(2542, F.ALLIANCE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(2542, 340)
	self:AddRecipeQuest(2542, 22)

	-- Westfall Stew -- 2543
	AddRecipe(2543, 75, 733, Q.COMMON, V.ORIG, 75, 115, 135, 155)
	self:AddRecipeFlags(2543, F.ALLIANCE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE)
	self:AddRecipeVendor(2543, 340)
	self:AddRecipeQuest(2543, 38)

	-- Crab Cake -- 2544
	AddRecipe(2544, 75, 2683, Q.COMMON, V.ORIG, 75, 115, 135, 155)
	self:AddRecipeFlags(2544, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(2544, 1355, 4210, 19369, 16719, 3399, 19185, 8306, 5482, 16676, 1430, 18988, 4552, 3026, 16253, 18987, 1699, 16277, 3067, 18993, 6286, 1382, 17246, 5159, 3087)

	-- Cooked Crab Claw -- 2545
	AddRecipe(2545, 85, 2682, Q.COMMON, V.ORIG, 85, 125, 145, 165)
	self:AddRecipeFlags(2545, F.ALLIANCE, F.HORDE, F.VENDOR, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeVendor(2545, 340)
	self:AddRecipeWorldDrop(2545, "Darkshore", "Westfall")

	-- Dry Pork Ribs -- 2546
	AddRecipe(2546, 80, 2687, Q.COMMON, V.ORIG, 80, 120, 140, 160)
	self:AddRecipeFlags(2546, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(2546, 1355, 4210, 19369, 16719, 3399, 19185, 8306, 5482, 16676, 1430, 18988, 4552, 3026, 16253, 18987, 1699, 16277, 3067, 18993, 6286, 1382, 17246, 5159, 3087)

	-- Redridge Goulash -- 2547
	AddRecipe(2547, 100, 1082, Q.COMMON, V.ORIG, 100, 135, 155, 175)
	self:AddRecipeFlags(2547, F.ALLIANCE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(2547, 340)
	self:AddRecipeQuest(2547, 92)

	-- Succulent Pork Ribs -- 2548
	AddRecipe(2548, 110, 2685, Q.COMMON, V.ORIG, 110, 130, 150, 170)
	self:AddRecipeFlags(2548, F.ALLIANCE, F.HORDE, F.VENDOR, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeVendor(2548, 340)
	self:AddRecipeWorldDrop(2548, "Loch Modan", "Redridge Mountains")

	-- Seasoned Wolf Kabob -- 2549
	AddRecipe(2549, 100, 1017, Q.COMMON, V.ORIG, 100, 140, 160, 180)
	self:AddRecipeFlags(2549, F.ALLIANCE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(2549, 340)
	self:AddRecipeQuest(2549, 90)

	-- Beer Basted Boar Ribs -- 2795
	AddRecipe(2795, 10, 2888, Q.COMMON, V.ORIG, 10, 60, 80, 100)
	self:AddRecipeFlags(2795, F.ALLIANCE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(2795, 340)
	self:AddRecipeQuest(2795, 384)

	-- Crocolisk Steak -- 3370
	AddRecipe(3370, 80, 3662, Q.COMMON, V.ORIG, 80, 120, 140, 160)
	self:AddRecipeFlags(3370, F.ALLIANCE, F.HORDE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(3370, 340)
	self:AddRecipeQuest(3370, 385)

	-- Blood Sausage -- 3371
	AddRecipe(3371, 60, 3220, Q.COMMON, V.ORIG, 60, 100, 120, 140)
	self:AddRecipeFlags(3371, F.ALLIANCE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(3371, 340)
	self:AddRecipeQuest(3371, 418)

	-- Murloc Fin Soup -- 3372
	AddRecipe(3372, 90, 3663, Q.COMMON, V.ORIG, 90, 130, 150, 170)
	self:AddRecipeFlags(3372, F.ALLIANCE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(3372, 340)
	self:AddRecipeQuest(3372, 127)

	-- Crocolisk Gumbo -- 3373
	AddRecipe(3373, 120, 3664, Q.COMMON, V.ORIG, 120, 160, 180, 200)
	self:AddRecipeFlags(3373, F.ALLIANCE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(3373, 340)
	self:AddRecipeQuest(3373, 471)

	-- Curiously Tasty Omelet -- 3376
	AddRecipe(3376, 130, 3665, Q.COMMON, V.ORIG, 130, 170, 190, 210)
	self:AddRecipeFlags(3376, F.ALLIANCE, F.HORDE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(3376, 1148, 2821, 340)
	self:AddRecipeQuest(3376, 296)

	-- Gooey Spider Cake -- 3377
	AddRecipe(3377, 110, 3666, Q.COMMON, V.ORIG, 110, 150, 170, 190)
	self:AddRecipeFlags(3377, F.ALLIANCE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(3377, 340)
	self:AddRecipeQuest(3377, 93)

	-- Big Bear Steak -- 3397
	AddRecipe(3397, 110, 3726, Q.COMMON, V.ORIG, 110, 150, 170, 190)
	self:AddRecipeFlags(3397, F.ALLIANCE, F.HORDE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(3397, 3960)
	self:AddRecipeLimitedVendor(3397, 12246, 1)
	self:AddRecipeQuest(3397, 498)

	-- Hot Lion Chops -- 3398
	AddRecipe(3398, 125, 3727, Q.COMMON, V.ORIG, 125, 175, 195, 215)
	self:AddRecipeFlags(3398, F.ALLIANCE, F.HORDE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(3398, 3489, 12245)
	self:AddRecipeQuest(3398, 501)

	-- Tasty Lion Steak -- 3399
	AddRecipe(3399, 150, 3728, Q.COMMON, V.ORIG, 150, 190, 210, 230)
	self:AddRecipeFlags(3399, F.ALLIANCE, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeQuest(3399, 564)

	-- Soothing Turtle Bisque -- 3400
	AddRecipe(3400, 175, 3729, Q.COMMON, V.ORIG, 175, 215, 235, 255)
	self:AddRecipeFlags(3400, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeQuest(3400, 555, 7321)

	-- Barbecued Buzzard Wing -- 4094
	AddRecipe(4094, 175, 4457, Q.COMMON, V.ORIG, 175, 215, 235, 255)
	self:AddRecipeFlags(4094, F.ALLIANCE, F.HORDE, F.TRAINER, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(4094, 2818)
	self:AddRecipeVendor(4094, 2814)
	self:AddRecipeLimitedVendor(4094, 12246, 1)
	self:AddRecipeQuest(4094, 703)

	-- Kaldorei Spider Kabob -- 6412
	AddRecipe(6412, 10, 5472, Q.COMMON, V.ORIG, 10, 50, 70, 90)
	self:AddRecipeFlags(6412, F.ALLIANCE, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeQuest(6412, 4161)

	-- Scorpid Surprise -- 6413
	AddRecipe(6413, 20, 5473, Q.COMMON, V.ORIG, 20, 60, 80, 100)
	self:AddRecipeFlags(6413, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(6413, 3881)

	-- Roasted Kodo Meat -- 6414
	AddRecipe(6414, 35, 5474, Q.COMMON, V.ORIG, 35, 75, 95, 115)
	self:AddRecipeFlags(6414, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(6414, 3081)

	-- Fillet of Frenzy -- 6415
	AddRecipe(6415, 50, 5476, Q.COMMON, V.ORIG, 50, 90, 110, 130)
	self:AddRecipeFlags(6415, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(6415, 4200)

	-- Strider Stew -- 6416
	AddRecipe(6416, 50, 5477, Q.COMMON, V.ORIG, 50, 90, 110, 130)
	self:AddRecipeFlags(6416, F.ALLIANCE, F.HORDE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(6416, 3482)
	self:AddRecipeQuest(6416, 2178)

	-- Dig Rat Stew -- 6417
	AddRecipe(6417, 90, 44977, Q.COMMON, V.WOTLK, 90, 130, 150, 170)
	self:AddRecipeFlags(6417, F.ALLIANCE, F.HORDE, F.VENDOR, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeVendor(6417, 3392)
	self:AddRecipeQuest(6417, 862)

	-- Crispy Lizard Tail -- 6418
	AddRecipe(6418, 100, 5479, Q.COMMON, V.ORIG, 100, 140, 160, 180)
	self:AddRecipeFlags(6418, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(6418, 3482)

	-- Lean Venison -- 6419
	AddRecipe(6419, 110, 5480, Q.COMMON, V.ORIG, 110, 150, 170, 190)
	self:AddRecipeFlags(6419, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(6419, 3960, 12245)

	-- Boiled Clams -- 6499
	AddRecipe(6499, 50, 5525, Q.COMMON, V.ORIG, 50, 90, 110, 130)
	self:AddRecipeFlags(6499, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(6499, 1355, 4210, 19369, 16719, 3399, 19185, 8306, 5482, 16676, 1430, 18988, 4552, 3026, 16253, 18987, 1699, 16277, 3067, 18993, 6286, 1382, 17246, 5159, 3087)

	-- Goblin Deviled Clams -- 6500
	AddRecipe(6500, 125, 5527, Q.COMMON, V.ORIG, 125, 165, 185, 205)
	self:AddRecipeFlags(6500, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(6500, 1355, 4210, 19369, 16719, 3399, 19185, 8306, 5482, 16676, 1430, 18988, 4552, 3026, 16253, 18987, 1699, 16277, 3067, 18993, 6286, 1382, 17246, 5159, 3087)

	-- Clam Chowder -- 6501
	AddRecipe(6501, 90, 5526, Q.COMMON, V.ORIG, 90, 130, 150, 170)
	self:AddRecipeFlags(6501, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(6501, 4305, 4307)

	-- Giant Clam Scorcho -- 7213
	AddRecipe(7213, 175, 6038, Q.COMMON, V.ORIG, 175, 215, 235, 255)
	self:AddRecipeFlags(7213, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(7213, 2664)

	-- Brilliant Smallfish -- 7751
	AddRecipe(7751, 1, 6290, Q.COMMON, V.ORIG, 1, 45, 65, 85)
	self:AddRecipeFlags(7751, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(7751, 5940, 8508, 5494, 3550, 66, 4265, 3029, 4574, 1684)

	-- Slitherskin Mackerel -- 7752
	AddRecipe(7752, 1, 787, Q.COMMON, V.ORIG, 1, 45, 65, 85)
	self:AddRecipeFlags(7752, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(7752, 5162, 4305, 3550, 5942, 10118)

	-- Longjaw Mud Snapper -- 7753
	AddRecipe(7753, 50, 4592, Q.COMMON, V.ORIG, 50, 90, 110, 130)
	self:AddRecipeFlags(7753, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(7753, 5748, 1684, 4574, 66, 4265, 5940, 3027, 5162)

	-- Loch Frenzy Delight -- 7754
	AddRecipe(7754, 50, 6316, Q.COMMON, V.ORIG, 50, 90, 110, 130)
	self:AddRecipeFlags(7754, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(7754, 1684)

	-- Bristle Whisker Catfish -- 7755
	AddRecipe(7755, 100, 4593, Q.COMMON, V.ORIG, 100, 140, 160, 180)
	self:AddRecipeFlags(7755, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(7755, 3497, 4553, 2383, 3027, 2397, 5494, 3029)

	-- Rainbow Fin Albacore -- 7827
	AddRecipe(7827, 50, 5095, Q.COMMON, V.ORIG, 50, 90, 110, 130)
	self:AddRecipeFlags(7827, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(7827, 4305, 4307, 5748, 5494, 3333, 4553, 3178, 10118, 3497, 5942)

	-- Rockscale Cod -- 7828
	AddRecipe(7828, 175, 4594, Q.COMMON, V.ORIG, 175, 190, 210, 230)
	self:AddRecipeFlags(7828, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(7828, 4307, 2664, 3333, 12962, 2383, 12033, 3178, 4574, 5162)

	-- Savory Deviate Delight -- 8238
	AddRecipe(8238, 85, 6657, Q.UNCOMMON, V.ORIG, 85, 125, 145, 165)
	self:AddRecipeFlags(8238, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(8238, "The Barrens")

	-- Herb Baked Egg -- 8604
	AddRecipe(8604, 1, 6888, Q.COMMON, V.ORIG, 1, 45, 65, 85)
	self:AddRecipeFlags(8604, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(8604, A.CUSTOM, 8)

	-- Smoked Bear Meat -- 8607
	AddRecipe(8607, 40, 6890, Q.COMMON, V.ORIG, 40, 80, 100, 120)
	self:AddRecipeFlags(8607, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(8607, 1465, 3556)

	-- Thistle Tea -- 9513
	AddRecipe(9513, 60, 7676, Q.UNCOMMON, V.ORIG, 60, 100, 120, 140)
	self:AddRecipeFlags(9513, F.ALLIANCE, F.HORDE, F.VENDOR, F.QUEST, F.ROGUE, F.IBOE, F.RBOP)
	self:AddRecipeVendor(9513, 6779)
	self:AddRecipeQuest(9513, 2359, 2478)

	-- Goldthorn Tea -- 13028
	AddRecipe(13028, 175, 10841, Q.COMMON, V.ORIG, 175, 175, 190, 205)
	self:AddRecipeFlags(13028, F.ALLIANCE, F.HORDE, F.TRAINER, F.INSTANCE, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(13028, A.CUSTOM, 13)

	-- Lean Wolf Steak -- 15853
	AddRecipe(15853, 125, 12209, Q.COMMON, V.ORIG, 125, 165, 185, 205)
	self:AddRecipeFlags(15853, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeLimitedVendor(15853, 12246, 1)

	-- Roast Raptor -- 15855
	AddRecipe(15855, 175, 12210, Q.COMMON, V.ORIG, 175, 215, 235, 255)
	self:AddRecipeFlags(15855, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(15855, 1148, 734, 12245, 2821, 4897, 2810, 4879)

	-- Hot Wolf Ribs -- 15856
	AddRecipe(15856, 175, 13851, Q.COMMON, V.ORIG, 175, 215, 235, 255)
	self:AddRecipeFlags(15856, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(15856, 8145, 7947)
	self:AddRecipeLimitedVendor(15856, 12246, 1)

	-- Jungle Stew -- 15861
	AddRecipe(15861, 175, 12212, Q.COMMON, V.ORIG, 175, 215, 235, 255)
	self:AddRecipeFlags(15861, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(15861, 1148, 734, 12245)

	-- Carrion Surprise -- 15863
	AddRecipe(15863, 175, 12213, Q.COMMON, V.ORIG, 175, 215, 235, 255)
	self:AddRecipeFlags(15863, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(15863, 12245, 4879, 989, 9636)

	-- Mystery Stew -- 15865
	AddRecipe(15865, 175, 12214, Q.COMMON, V.ORIG, 175, 215, 235, 255)
	self:AddRecipeFlags(15865, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(15865, 4897, 8150)
	self:AddRecipeLimitedVendor(15865, 12246, 1)

	-- Dragonbreath Chili -- 15906
	AddRecipe(15906, 200, 12217, Q.COMMON, V.ORIG, 200, 225, 237, 250)
	self:AddRecipeFlags(15906, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(15906, 4897, 4879)
	self:AddRecipeLimitedVendor(15906, 12246, 1)

	-- Heavy Kodo Stew -- 15910
	AddRecipe(15910, 200, 12215, Q.COMMON, V.ORIG, 200, 225, 237, 250)
	self:AddRecipeFlags(15910, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(15910, 12245, 9636, 8150)

	-- Spiced Chili Crab -- 15915
	AddRecipe(15915, 225, 12216, Q.COMMON, V.ORIG, 225, 250, 262, 275)
	self:AddRecipeFlags(15915, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(15915, 4305, 1149, 989)

	-- Monster Omelet -- 15933
	AddRecipe(15933, 225, 12218, Q.COMMON, V.ORIG, 225, 250, 262, 275)
	self:AddRecipeFlags(15933, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(15933, 2803, 2806, 11187)

	-- Crispy Bat Wing -- 15935
	AddRecipe(15935, 1, 12224, Q.COMMON, V.ORIG, 1, 45, 65, 85)
	self:AddRecipeFlags(15935, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(15935, 2118)

	-- Spotted Yellowtail -- 18238
	AddRecipe(18238, 225, 6887, Q.COMMON, V.ORIG, 225, 250, 262, 275)
	self:AddRecipeFlags(18238, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(18238, 8137)

	-- Cooked Glossy Mightfish -- 18239
	AddRecipe(18239, 225, 13927, Q.COMMON, V.ORIG, 225, 250, 262, 275)
	self:AddRecipeFlags(18239, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(18239, 2664)

	-- Grilled Squid -- 18240
	AddRecipe(18240, 240, 13928, Q.COMMON, V.ORIG, 240, 265, 277, 290)
	self:AddRecipeFlags(18240, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeVendor(18240, 8137)

	-- Filet of Redgill -- 18241
	AddRecipe(18241, 225, 13930, Q.COMMON, V.ORIG, 225, 250, 262, 275)
	self:AddRecipeFlags(18241, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(18241, 2664)

	-- Hot Smoked Bass -- 18242
	AddRecipe(18242, 240, 13929, Q.COMMON, V.ORIG, 240, 265, 277, 290)
	self:AddRecipeFlags(18242, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(18242, 2664)

	-- Nightfin Soup -- 18243
	AddRecipe(18243, 250, 13931, Q.COMMON, V.ORIG, 250, 275, 285, 295)
	self:AddRecipeFlags(18243, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(18243, 8137)

	-- Poached Sunscale Salmon -- 18244
	AddRecipe(18244, 250, 13932, Q.COMMON, V.ORIG, 250, 275, 285, 295)
	self:AddRecipeFlags(18244, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(18244, 8137)

	-- Lobster Stew -- 18245
	AddRecipe(18245, 275, 13933, Q.COMMON, V.ORIG, 275, 300, 312, 325)
	self:AddRecipeFlags(18245, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(18245, 7947, 8145)

	-- Mightfish Steak -- 18246
	AddRecipe(18246, 275, 13934, Q.COMMON, V.ORIG, 275, 300, 312, 325)
	self:AddRecipeFlags(18246, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(18246, 7947, 8145)

	-- Baked Salmon -- 18247
	AddRecipe(18247, 275, 13935, Q.COMMON, V.ORIG, 275, 300, 312, 325)
	self:AddRecipeFlags(18247, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(18247, 7947, 8145)

	-- Undermine Clam Chowder -- 20626
	AddRecipe(20626, 225, 16766, Q.COMMON, V.ORIG, 225, 250, 262, 275)
	self:AddRecipeFlags(20626, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(20626, 8139)

	-- Mithril Head Trout -- 20916
	AddRecipe(20916, 175, 8364, Q.COMMON, V.ORIG, 175, 215, 235, 255)
	self:AddRecipeFlags(20916, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(20916, 4307, 2664, 3333, 12962, 2383, 12033, 3178, 4574, 5162)

	-- Gingerbread Cookie -- 21143
	AddRecipe(21143, 1, 17197, Q.COMMON, V.ORIG, 1, 45, 65, 85)
	self:AddRecipeFlags(21143, F.ALLIANCE, F.HORDE, F.VENDOR, F.SEASONAL, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(21143, 23064, 23010, 13435, 13432, 13429, 13433, 23012, 13420)
	self:AddRecipeAcquire(21143, A.SEASONAL, 1)

	-- Egg Nog -- 21144
	AddRecipe(21144, 35, 17198, Q.COMMON, V.ORIG, 35, 75, 95, 115)
	self:AddRecipeFlags(21144, F.ALLIANCE, F.HORDE, F.VENDOR, F.SEASONAL, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(21144, 23064, 23010, 13435, 13432, 13429, 13433, 23012, 13420)
	self:AddRecipeAcquire(21144, A.SEASONAL, 1)

	-- Spider Sausage -- 21175
	AddRecipe(21175, 200, 17222, Q.COMMON, V.ORIG, 200, 225, 237, 250)
	self:AddRecipeFlags(21175, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(21175, 1355, 4210, 19369, 16719, 3399, 19185, 8306, 5482, 16676, 1430, 18988, 4552, 3026, 16253, 18987, 1699, 16277, 3067, 18993, 6286, 1382, 17246, 5159, 3087)

	-- Tender Wolf Steak -- 22480
	AddRecipe(22480, 225, 18045, Q.COMMON, V.ORIG, 225, 250, 262, 275)
	self:AddRecipeFlags(22480, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(22480, 4782, 8125, 7733)

	-- Runn Tum Tuber Surprise -- 22761
	AddRecipe(22761, 275, 18254, Q.UNCOMMON, V.ORIG, 275, 300, 312, 325)
	self:AddRecipeFlags(22761, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeMobDrop(22761, 14354)

	-- Heavy Crocolisk Stew -- 24418
	AddRecipe(24418, 150, 20074, Q.COMMON, V.ORIG, 150, 160, 180, 200)
	self:AddRecipeFlags(24418, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(24418, 4879)

	-- Smoked Desert Dumplings -- 24801
	AddRecipe(24801, 285, 20452, Q.COMMON, V.ORIG, 285, 310, 322, 335)
	self:AddRecipeFlags(24801, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeQuest(24801, 8313)

	-- Dirge's Kickin' Chimaerok Chops -- 25659
	AddRecipe(25659, 300, 21023, Q.EPIC, V.ORIG, 300, 325, 337, 350)
	self:AddRecipeFlags(25659, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOE)
	self:AddRecipeQuest(25659, 8586)

	-- Smoked Sagefish -- 25704
	AddRecipe(25704, 80, 21072, Q.COMMON, V.ORIG, 80, 120, 140, 160)
	self:AddRecipeFlags(25704, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(25704, 2397, 16718, 3085, 17246, 3027, 14738, 5160, 4265, 8307, 4223, 5483, 3400, 2381, 2664, 4553, 19195, 26868, 16253, 12033, 16677)

	-- Sagefish Delight -- 25954
	AddRecipe(25954, 175, 21217, Q.COMMON, V.ORIG, 175, 215, 235, 255)
	self:AddRecipeFlags(25954, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(25954, 2397, 16718, 3085, 17246, 3027, 14738, 5160, 4265, 8307, 4223, 5483, 3400, 2381, 2664, 4553, 19195, 26868, 16253, 12033, 16677)

	-- Crunchy Spider Surprise -- 28267
	AddRecipe(28267, 60, 22645, Q.COMMON, V.TBC, 60, 100, 120, 140)
	self:AddRecipeFlags(28267, F.ALLIANCE, F.HORDE, F.VENDOR, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(28267, 16253, 18427)
	self:AddRecipeQuest(28267, 9171)

	-- Lynx Steak -- 33276
	AddRecipe(33276, 1, 27635, Q.COMMON, V.TBC, 1, 45, 65, 85)
	self:AddRecipeFlags(33276, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33276, 16262)

	-- Roasted Moongraze Tenderloin -- 33277
	AddRecipe(33277, 1, 24105, Q.COMMON, V.TBC, 1, 45, 65, 85)
	self:AddRecipeFlags(33277, F.ALLIANCE, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeQuest(33277, 9454)

	-- Bat Bites -- 33278
	AddRecipe(33278, 50, 27636, Q.COMMON, V.TBC, 50, 90, 110, 130)
	self:AddRecipeFlags(33278, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33278, 16253)

	-- Buzzard Bites -- 33279
	AddRecipe(33279, 300, 27651, Q.COMMON, V.TBC, 300, 320, 330, 340)
	self:AddRecipeFlags(33279, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeQuest(33279, 9356)

	-- Ravager Dog -- 33284
	AddRecipe(33284, 300, 27655, Q.COMMON, V.TBC, 300, 320, 330, 340)
	self:AddRecipeFlags(33284, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33284, 16585, 16826)

	-- Sporeling Snack -- 33285
	AddRecipe(33285, 310, 27656, Q.COMMON, V.TBC, 310, 330, 340, 350)
	self:AddRecipeFlags(33285, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33285, 18382)

	-- Blackened Basilisk -- 33286
	AddRecipe(33286, 315, 27657, Q.COMMON, V.TBC, 315, 335, 345, 355)
	self:AddRecipeFlags(33286, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33286, 18957, 19038)

	-- Roasted Clefthoof -- 33287
	AddRecipe(33287, 325, 27658, Q.COMMON, V.TBC, 325, 345, 355, 365)
	self:AddRecipeFlags(33287, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeVendor(33287, 20096, 20097)

	-- Warp Burger -- 33288
	AddRecipe(33288, 325, 27659, Q.COMMON, V.TBC, 325, 345, 355, 365)
	self:AddRecipeFlags(33288, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeVendor(33288, 18957, 19038)

	-- Talbuk Steak -- 33289
	AddRecipe(33289, 325, 27660, Q.COMMON, V.TBC, 325, 345, 355, 365)
	self:AddRecipeFlags(33289, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33289, 20096, 20097)

	-- Blackened Trout -- 33290
	AddRecipe(33290, 300, 27661, Q.COMMON, V.TBC, 300, 320, 330, 340)
	self:AddRecipeFlags(33290, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(33290, 18015, 20028)

	-- Feltail Delight -- 33291
	AddRecipe(33291, 300, 27662, Q.COMMON, V.TBC, 300, 320, 330, 340)
	self:AddRecipeFlags(33291, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33291, 18011, 20028)

	-- Blackened Sporefish -- 33292
	AddRecipe(33292, 310, 27663, Q.COMMON, V.TBC, 310, 330, 340, 350)
	self:AddRecipeFlags(33292, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33292, 18911)

	-- Grilled Mudfish -- 33293
	AddRecipe(33293, 320, 27664, Q.COMMON, V.TBC, 320, 340, 350, 360)
	self:AddRecipeFlags(33293, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeVendor(33293, 20096, 20097)

	-- Poached Bluefish -- 33294
	AddRecipe(33294, 320, 27665, Q.COMMON, V.TBC, 320, 340, 350, 360)
	self:AddRecipeFlags(33294, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33294, 20096, 20097)

	-- Golden Fish Sticks -- 33295
	AddRecipe(33295, 325, 27666, Q.COMMON, V.TBC, 325, 345, 355, 365)
	self:AddRecipeFlags(33295, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33295, 18960, 19296)

	-- Spicy Crawdad -- 33296
	AddRecipe(33296, 350, 27667, Q.COMMON, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(33296, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(33296, 18960, 19296)

	-- Clam Bar -- 36210
	AddRecipe(36210, 300, 30155, Q.COMMON, V.TBC, 300, 320, 330, 340)
	self:AddRecipeFlags(36210, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(36210, 18382)

	-- Spice Bread -- 37836
	AddRecipe(37836, 1, 30816, Q.COMMON, V.TBC, 1, 30, 35, 38)
	self:AddRecipeFlags(37836, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(37836, 1355, 4210, 19369, 16719, 3399, 19185, 8306, 5482, 16676, 1430, 18988, 4552, 3026, 16253, 18987, 1699, 16277, 3067, 18993, 6286, 1382, 17246, 5159, 3087)

	-- Mok'Nathal Shortribs -- 38867
	AddRecipe(38867, 335, 31672, Q.COMMON, V.TBC, 335, 355, 365, 375)
	self:AddRecipeFlags(38867, F.ALLIANCE, F.HORDE, F.VENDOR, F.QUEST, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(38867, 20916, 21113)
	self:AddRecipeQuest(38867, 10860)

	-- Crunchy Serpent -- 38868
	AddRecipe(38868, 335, 31673, Q.COMMON, V.TBC, 335, 355, 365, 375)
	self:AddRecipeFlags(38868, F.ALLIANCE, F.HORDE, F.VENDOR, F.QUEST, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(38868, 20916, 21113)
	self:AddRecipeQuest(38868, 10860)

	-- Stewed Trout -- 42296
	AddRecipe(42296, 320, 33048, Q.COMMON, V.TBC, 320, 335, 345, 355)
	self:AddRecipeFlags(42296, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(42296, 19186)

	-- Fisherman's Feast -- 42302
	AddRecipe(42302, 350, 33052, Q.COMMON, V.TBC, 350, 375, 380, 385)
	self:AddRecipeFlags(42302, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(42302, 19186)

	-- Hot Buttered Trout -- 42305
	AddRecipe(42305, 350, 33053, Q.COMMON, V.TBC, 350, 375, 380, 385)
	self:AddRecipeFlags(42305, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(42305, 19186)

	-- Skullfish Soup -- 43707
	AddRecipe(43707, 325, 33825, Q.UNCOMMON, V.TBC, 325, 335, 345, 355)
	self:AddRecipeFlags(43707, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeQuest(43707, 11381, 11377, 11379, 11380)
	self:AddRecipeAcquire(43707, A.CUSTOM, 6)

	-- Stormchops -- 43758
	AddRecipe(43758, 300, 33866, Q.RARE, V.TBC, 300, 320, 330, 340)
	self:AddRecipeFlags(43758, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeQuest(43758, 11381, 11377, 11379, 11380, 13100, 13101, 13102, 13103, 13107, 13112, 13113,	13114, 13115, 13116)
	self:AddRecipeAcquire(43758, A.CUSTOM, 5, A.CUSTOM, 6, A.CUSTOM, 38)

	-- Broiled Bloodfin -- 43761
	AddRecipe(43761, 300, 33867, Q.UNCOMMON, V.TBC, 300, 320, 330, 340)
	self:AddRecipeFlags(43761, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeQuest(43761, 11381, 11377, 11379, 11380)
	self:AddRecipeAcquire(43761, A.CUSTOM, 6)

	-- Spicy Hot Talbuk -- 43765
	AddRecipe(43765, 325, 33872, Q.UNCOMMON, V.TBC, 325, 335, 345, 355)
	self:AddRecipeFlags(43765, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeQuest(43765, 11381, 11377, 11379, 11380)
	self:AddRecipeAcquire(43765, A.CUSTOM, 5)

	-- Kibler's Bits -- 43772
	AddRecipe(43772, 300, 33874, Q.UNCOMMON, V.TBC, 300, 345, 355, 365)
	self:AddRecipeFlags(43772, F.ALLIANCE, F.HORDE, F.QUEST, F.HUNTER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeQuest(43772, 11381, 11377, 11379, 11380)
	self:AddRecipeAcquire(43772, A.CUSTOM, 5, A.CUSTOM, 6)

	-- Delicious Chocolate Cake -- 43779
	AddRecipe(43779, 1, 33924, Q.RARE, V.TBC, 1, 50, 62, 75)
	self:AddRecipeFlags(43779, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeQuest(43779, 11381, 11377, 11379, 11380, 13100, 13101, 13102, 13103, 13107, 13112, 13113,	13114, 13115, 13116)
	self:AddRecipeAcquire(43779, A.CUSTOM, 5, A.CUSTOM, 6, A.CUSTOM, 38)

	-- Hot Apple Cider -- 45022
	AddRecipe(45022, 325, 34411, Q.COMMON, V.WOTLK, 325, 325, 325, 325)
	self:AddRecipeFlags(45022, F.ALLIANCE, F.HORDE, F.VENDOR, F.SEASONAL, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(45022, 13420, 13433)
	self:AddRecipeAcquire(45022, A.SEASONAL, 1)

	-- Mammoth Meal -- 45549
	AddRecipe(45549, 350, 34748, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(45549, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(45549, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Shoveltusk Steak -- 45550
	AddRecipe(45550, 350, 34749, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(45550, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(45550, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Worm Delight -- 45551
	AddRecipe(45551, 350, 34750, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(45551, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45551, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Roasted Worg -- 45552
	AddRecipe(45552, 350, 34751, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(45552, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45552, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Rhino Dogs -- 45553
	AddRecipe(45553, 350, 34752, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(45553, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45553, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Great Feast -- 45554
	AddRecipe(45554, 375, 34753, Q.COMMON, V.WOTLK, 375, 375, 400, 425)
	self:AddRecipeFlags(45554, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(45554, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Mega Mammoth Meal -- 45555
	AddRecipe(45555, 400, 34754, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(45555, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(45555, 31031, 31032, 33595)

	-- Tender Shoveltusk Steak -- 45556
	AddRecipe(45556, 400, 34755, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(45556, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(45556, 31031, 31032, 33595)

	-- Spiced Worm Burger -- 45557
	AddRecipe(45557, 400, 34756, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(45557, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(45557, 31031, 31032, 33595)

	-- Very Burnt Worg -- 45558
	AddRecipe(45558, 400, 34757, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(45558, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(45558, 31031, 31032, 33595)

	-- Mighty Rhino Dogs -- 45559
	AddRecipe(45559, 400, 34758, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(45559, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(45559, 31031, 31032, 33595)

	-- Smoked Rockfin -- 45560
	AddRecipe(45560, 350, 34759, Q.COMMON, V.WOTLK, 350, 350, 365, 380)
	self:AddRecipeFlags(45560, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45560, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Grilled Bonescale -- 45561
	AddRecipe(45561, 350, 34760, Q.COMMON, V.WOTLK, 350, 350, 365, 380)
	self:AddRecipeFlags(45561, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45561, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Sauteed Goby -- 45562
	AddRecipe(45562, 350, 34761, Q.COMMON, V.WOTLK, 350, 350, 365, 380)
	self:AddRecipeFlags(45562, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45562, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Grilled Sculpin -- 45563
	AddRecipe(45563, 350, 34762, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(45563, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(45563, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Smoked Salmon -- 45564
	AddRecipe(45564, 350, 34763, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(45564, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(45564, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Poached Nettlefish -- 45565
	AddRecipe(45565, 350, 34764, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(45565, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45565, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Pickled Fangtooth -- 45566
	AddRecipe(45566, 350, 34765, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(45566, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45566, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Poached Northern Sculpin -- 45567
	AddRecipe(45567, 400, 34766, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(45567, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(45567, 31031, 31032, 33595)

	-- Firecracker Salmon -- 45568
	AddRecipe(45568, 400, 34767, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(45568, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(45568, 31031, 31032, 33595)

	-- Baked Manta Ray -- 45569
	AddRecipe(45569, 350, 42942, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(45569, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45569, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Imperial Manta Steak -- 45570
	AddRecipe(45570, 400, 34769, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(45570, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(45570, 31031, 31032, 33595)

	-- Spicy Blue Nettlefish -- 45571
	AddRecipe(45571, 400, 34768, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(45571, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(45571, 31031, 31032, 33595)

	-- Captain Rumsey's Lager -- 45695
	AddRecipe(45695, 100, 34832, Q.UNCOMMON, V.WOTLK, 100, 100, 105, 110)
	self:AddRecipeFlags(45695, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeQuest(45695, 11666, 11668, 11667, 11669, 13100, 13101, 13102, 13103, 13107, 13112, 13113,	13114, 13115, 13116)
	self:AddRecipeAcquire(45695, A.CUSTOM, 7, A.CUSTOM, 38)

	-- Charred Bear Kabobs -- 46684
	AddRecipe(46684, 250, 35563, Q.COMMON, V.WOTLK, 250, 275, 285, 295)
	self:AddRecipeFlags(46684, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeVendor(46684, 2803, 2806)

	-- Juicy Bear Burger -- 46688
	AddRecipe(46688, 250, 35565, Q.COMMON, V.WOTLK, 250, 275, 285, 295)
	self:AddRecipeFlags(46688, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(46688, 2803, 2806)

	-- Kungaloosh -- 53056
	AddRecipe(53056, 375, 39520, Q.COMMON, V.WOTLK, 375, 375, 387, 400)
	self:AddRecipeFlags(53056, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeQuest(53056, 13571)
	self:AddRecipeAcquire(53056, A.CUSTOM, 36)

	-- Northern Stew -- 57421
	AddRecipe(57421, 350, 34747, Q.COMMON, V.WOTLK, 350, 350, 362, 365)
	self:AddRecipeFlags(57421, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeQuest(57421, 13088, 13087, 13089, 13090)

	-- Fish Feast -- 57423
	AddRecipe(57423, 450, 43015, Q.UNCOMMON, V.WOTLK, 450, 455, 460, 465)
	self:AddRecipeFlags(57423, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(57423, 31031, 31032, 33595)

	-- Spicy Fried Herring -- 57433
	AddRecipe(57433, 400, 42993, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57433, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(57433, 31031, 31032, 33595)

	-- Rhinolicious Wormsteak -- 57434
	AddRecipe(57434, 400, 42994, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57434, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeVendor(57434, 31031, 31032, 33595)

	-- Critter Bites -- 57435
	AddRecipe(57435, 400, 43004, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57435, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(57435, 31031, 31032, 33595)

	-- Hearty Rhino -- 57436
	AddRecipe(57436, 400, 42995, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57436, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(57436, 31031, 31032, 33595)

	-- Snapper Extreme -- 57437
	AddRecipe(57437, 400, 42996, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57437, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(57437, 31031, 31032, 33595)

	-- Blackened Worg Steak -- 57438
	AddRecipe(57438, 400, 42997, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57438, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(57438, 31031, 31032, 33595)

	-- Cuttlesteak -- 57439
	AddRecipe(57439, 400, 42998, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57439, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(57439, 31031, 31032, 33595)

	-- Spiced Mammoth Treats -- 57440
	AddRecipe(57440, 400, 43005, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57440, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(57440, 31031, 31032, 33595)

	-- Blackened Dragonfin -- 57441
	AddRecipe(57441, 400, 42999, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57441, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(57441, 31031, 31032, 33595)

	-- Dragonfin Filet -- 57442
	AddRecipe(57442, 400, 43000, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57442, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(57442, 31031, 31032, 33595)

	-- Tracker Snacks -- 57443
	AddRecipe(57443, 400, 43001, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(57443, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(57443, 31031, 31032, 33595)

	-- Dalaran Clam Chowder -- 58065
	AddRecipe(58065, 350, 43268, Q.COMMON, V.WOTLK, 350, 350, 382, 415)
	self:AddRecipeFlags(58065, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(58065, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Tasty Cupcake -- 58512
	AddRecipe(58512, 350, 43490, Q.UNCOMMON, V.WOTLK, 350, 350, 357, 365)
	self:AddRecipeFlags(58512, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOP)
	self:AddRecipeWorldDrop(58512, "Northrend")

	-- Last Week's Mammoth -- 58521
	AddRecipe(58521, 350, 43488, Q.UNCOMMON, V.WOTLK, 350, 350, 357, 365)
	self:AddRecipeFlags(58521, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOP)
	self:AddRecipeWorldDrop(58521, "Northrend")

	-- Bad Clams -- 58523
	AddRecipe(58523, 350, 43491, Q.UNCOMMON, V.WOTLK, 350, 350, 357, 365)
	self:AddRecipeFlags(58523, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOP)
	self:AddRecipeWorldDrop(58523, "Northrend")

	-- Haunted Herring -- 58525
	AddRecipe(58525, 350, 43492, Q.UNCOMMON, V.WOTLK, 350, 350, 357, 365)
	self:AddRecipeFlags(58525, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOP)
	self:AddRecipeWorldDrop(58525, "Northrend")

	-- Gigantic Feast -- 58527
	AddRecipe(58527, 425, 43478, Q.UNCOMMON, V.WOTLK, 425, 435, 455, 475)
	self:AddRecipeFlags(58527, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(58527, 31031, 31032, 33595)

	-- Small Feast -- 58528
	AddRecipe(58528, 425, 43480, Q.UNCOMMON, V.WOTLK, 425, 435, 455, 475)
	self:AddRecipeFlags(58528, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(58528, 31031, 31032, 33595)

	-- Worg Tartare -- 62350
	AddRecipe(62350, 400, 44953, Q.UNCOMMON, V.WOTLK, 400, 400, 420, 460)
	self:AddRecipeFlags(62350, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(62350, 31031, 31032, 33595)

	-- Clamlette Magnifique -- 64054
	AddRecipe(64054, 250, 33004, Q.COMMON, V.WOTLK, 250, 250, 275, 300)
	self:AddRecipeFlags(64054, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeQuest(64054, 6610)

	-- Black Jelly -- 64358
	AddRecipe(64358, 400, 45932, Q.COMMON, V.WOTLK, 400, 400, 412, 425)
	self:AddRecipeFlags(64358, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(64358, 29631, 26972, 26989, 26953, 33587, 28705, 26905)

	-- Bread of the Dead -- 65454
	AddRecipe(65454, 45, 46691, Q.COMMON, V.WOTLK, 45, 55, 60, 65)
	self:AddRecipeFlags(65454, F.ALLIANCE, F.HORDE, F.SEASONAL, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(65454, A.SEASONAL, 6)

	-- Some recipes are only availible to specific factions.
	-- We only add the faction specific recipes if the user is part of that faction
	local BFAC = LibStub("LibBabble-Faction-3.0"):GetLookupTable()
	local _,faction = UnitFactionGroup("player")

	if faction == BFAC["Alliance"] then

		-- Pumpkin Pie -- 62044
		AddRecipe(62044, 100, 44839, Q.COMMON, V.WOTLK, 100, 150, 162, 175)
		self:AddRecipeFlags(62044, F.ALLIANCE, F.SEASONAL, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
		self:AddRecipeAcquire(62044, A.SEASONAL, 5)

		-- Slow-Roasted Turkey -- 62045
		AddRecipe(62045, 330, 44839, Q.COMMON, V.WOTLK, 330, 330, 342, 355)
		self:AddRecipeFlags(62045, F.ALLIANCE, F.SEASONAL, F.IBOE, F.RBOP, F.DPS)
		self:AddRecipeAcquire(62045, A.SEASONAL, 5)

		-- Cranberry Chutney -- 62049
		AddRecipe(62049, 210, 44840, Q.COMMON, V.WOTLK, 210, 210, 222, 235)
		self:AddRecipeFlags(62049, F.ALLIANCE, F.SEASONAL, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
		self:AddRecipeAcquire(62049, A.SEASONAL, 5)

		-- Spice Bread Stuffing -- 62050
		AddRecipe(62050, 90, 44837, Q.COMMON, V.WOTLK, 90, 90, 102, 115)
		self:AddRecipeFlags(62050, F.ALLIANCE, F.SEASONAL, F.IBOE, F.RBOE)
		self:AddRecipeAcquire(62050, A.SEASONAL, 5)

		-- Candied Sweet Potato -- 62051
		AddRecipe(62051, 270, 44839, Q.COMMON, V.WOTLK, 270, 270, 282, 295)
		self:AddRecipeFlags(62051, F.ALLIANCE, F.SEASONAL, F.IBOE, F.RBOP)
		self:AddRecipeAcquire(62051, A.SEASONAL, 5)

	elseif faction == BFAC["Horde"] then

		-- Candied Sweet Potato -- 66034
		AddRecipe(66034, 270, 44839, Q.COMMON, V.WOTLK, 270, 270, 282, 295)
		self:AddRecipeFlags(66034, F.HORDE, F.SEASONAL, F.IBOE, F.RBOP)
		self:AddRecipeAcquire(66034, A.SEASONAL, 5)

		-- Cranberry Chutney -- 66035
		AddRecipe(66035, 210, 44840, Q.COMMON, V.WOTLK, 210, 210, 222, 235)
		self:AddRecipeFlags(66035, F.HORDE, F.SEASONAL, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
		self:AddRecipeAcquire(66035, A.SEASONAL, 5)

		-- Pumpkin Pie -- 66036
		AddRecipe(66036, 100, 44839, Q.COMMON, V.WOTLK, 100, 150, 162, 175)
		self:AddRecipeFlags(66036, F.HORDE, F.SEASONAL, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
		self:AddRecipeAcquire(66036, A.SEASONAL, 5)

		-- Slow-Roasted Turkey -- 66037
		AddRecipe(66037, 330, 44839, Q.COMMON, V.WOTLK, 330, 330, 342, 355)
		self:AddRecipeFlags(66037, F.HORDE, F.SEASONAL, F.IBOE, F.RBOP, F.DPS)
		self:AddRecipeAcquire(66037, A.SEASONAL, 5)

		-- Spice Bread Stuffing -- 66038
		AddRecipe(66038, 90, 44837, Q.COMMON, V.WOTLK, 90, 90, 102, 115)
		self:AddRecipeFlags(66038, F.HORDE, F.SEASONAL, F.IBOE, F.RBOE)
		self:AddRecipeAcquire(66038, A.SEASONAL, 5)
	end
	return num_recipes
end
