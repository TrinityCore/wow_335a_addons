--[[
************************************************************************
Smelting.lua
Smelting data for all of Ackis Recipe List
************************************************************************
File date: 2010-04-11T15:13:43Z
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
local V		= private.game_versions

local initialized = false
local num_recipes = 0

--------------------------------------------------------------------------------------------------------------------
-- Counter and wrapper function
--------------------------------------------------------------------------------------------------------------------
local function AddRecipe(spell_id, skill_level, item_id, quality, genesis, optimal_level, medium_level, easy_level, trivial_level)
	num_recipes = num_recipes + 1
	addon:AddRecipe(spell_id, skill_level, item_id, quality, 32606, nil, genesis, optimal_level, medium_level, easy_level, trivial_level)
end

function addon:InitSmelting()
	if initialized then
		return num_recipes
	end
	initialized = true

	-- Smelt Copper -- 2657
	AddRecipe(2657, 1, 2840, Q.COMMON, V.ORIG, 1, 25, 47, 70)
	self:AddRecipeFlags(2657, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(2657, A.CUSTOM, 8)

	-- Smelt Silver -- 2658
	AddRecipe(2658, 75, 2842, Q.COMMON, V.ORIG, 75, 115, 122, 130)
	self:AddRecipeFlags(2658, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(2658, 33682, 18779, 5392, 8128, 1701, 16752, 5513, 26999, 4254, 3357, 16663, 1681, 26912, 3175, 6297, 3555, 26962, 3001, 28698, 17488, 18804, 26976, 33617, 3137, 18747, 4598)

	-- Smelt Bronze -- 2659
	AddRecipe(2659, 65, 2841, Q.COMMON, V.ORIG, 65, 65, 90, 115)
	self:AddRecipeFlags(2659, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(2659, 33682, 18779, 5392, 8128, 1701, 16752, 5513, 26999, 4254, 3357, 16663, 1681, 26912, 3175, 6297, 3555, 26962, 3001, 28698, 17488, 18804, 26976, 33617, 3137, 18747, 4598)

	-- Smelt Tin -- 3304
	AddRecipe(3304, 65, 3576, Q.COMMON, V.ORIG, 65, 65, 70, 75)
	self:AddRecipeFlags(3304, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3304, 33682, 18779, 5392, 8128, 1701, 16752, 5513, 26999, 4254, 3357, 16663, 1681, 26912, 3175, 6297, 3555, 26962, 3001, 28698, 17488, 18804, 26976, 33617, 3137, 18747, 4598)

	-- Smelt Iron -- 3307
	AddRecipe(3307, 125, 3575, Q.COMMON, V.ORIG, 125, 130, 145, 160)
	self:AddRecipeFlags(3307, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3307, 33682, 18779, 5392, 8128, 1701, 16752, 5513, 26999, 4254, 3357, 16663, 1681, 26912, 3175, 6297, 3555, 26962, 3001, 28698, 17488, 18804, 26976, 33617, 3137, 18747, 4598)

	-- Smelt Gold -- 3308
	AddRecipe(3308, 155, 3577, Q.COMMON, V.ORIG, 155, 170, 177, 185)
	self:AddRecipeFlags(3308, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3308, 33682, 18779, 5392, 8128, 1701, 16752, 5513, 26999, 4254, 3357, 16663, 1681, 26912, 3175, 6297, 3555, 26962, 3001, 28698, 17488, 18804, 26976, 33617, 3137, 18747, 4598)

	-- Smelt Steel -- 3569
	AddRecipe(3569, 165, 3859, Q.COMMON, V.ORIG, 165, 165, 165, 165)
	self:AddRecipeFlags(3569, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3569, 33682, 18779, 5392, 8128, 1701, 16752, 5513, 26999, 4254, 3357, 16663, 1681, 26912, 3175, 6297, 3555, 26962, 3001, 28698, 17488, 18804, 26976, 33617, 3137, 18747, 4598)

	-- Smelt Mithril -- 10097
	AddRecipe(10097, 175, 3860, Q.COMMON, V.ORIG, 175, 175, 202, 230)
	self:AddRecipeFlags(10097, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(10097, 33682, 18779, 5392, 8128, 1701, 16752, 5513, 26999, 4254, 3357, 16663, 1681, 26912, 3175, 6297, 3555, 26962, 3001, 28698, 17488, 18804, 26976, 33617, 3137, 18747, 4598)

	-- Smelt Truesilver -- 10098
	AddRecipe(10098, 230, 6037, Q.COMMON, V.ORIG, 230, 250, 270, 290)
	self:AddRecipeFlags(10098, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(10098, 33682, 18779, 5392, 8128, 1701, 16752, 5513, 26999, 4254, 3357, 16663, 1681, 26912, 3175, 6297, 3555, 26962, 3001, 28698, 17488, 18804, 26976, 33617, 3137, 18747, 4598)

	-- Smelt Dark Iron -- 14891
	AddRecipe(14891, 230, 11371, Q.COMMON, V.ORIG, 230, 300, 305, 310)
	self:AddRecipeFlags(14891, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeQuest(14891, 4083)

	-- Smelt Thorium -- 16153
	AddRecipe(16153, 230, 12359, Q.COMMON, V.ORIG, 230, 250, 270, 290)
	self:AddRecipeFlags(16153, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(16153, 33682, 18779, 5392, 8128, 1701, 16752, 5513, 26999, 4254, 3357, 16663, 1681, 26912, 3175, 6297, 3555, 26962, 3001, 28698, 17488, 18804, 26976, 33617, 3137, 18747, 4598)

	-- Smelt Elementium -- 22967
	AddRecipe(22967, 300, 17771, Q.RARE, V.ORIG, 300, 350, 362, 375)
	self:AddRecipeFlags(22967, F.ALLIANCE, F.HORDE, F.RAID, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(22967, 14401)

	-- Smelt Fel Iron -- 29356
	AddRecipe(29356, 275, 23445, Q.COMMON, V.TBC, 275, 275, 300, 325)
	self:AddRecipeFlags(29356, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(29356, 18779, 28698, 26962, 33617, 26999, 33682, 26912, 26976, 18747)

	-- Smelt Adamantite -- 29358
	AddRecipe(29358, 325, 23446, Q.COMMON, V.TBC, 325, 325, 332, 340)
	self:AddRecipeFlags(29358, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(29358, 18779, 28698, 26962, 33617, 26999, 33682, 26912, 26976, 18747)

	-- Smelt Eternium -- 29359
	AddRecipe(29359, 350, 23447, Q.COMMON, V.TBC, 350, 350, 357, 365)
	self:AddRecipeFlags(29359, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(29359, 18779, 28698, 26962, 33617, 26999, 33682, 26912, 26976, 18747)

	-- Smelt Felsteel -- 29360
	AddRecipe(29360, 350, 23448, Q.COMMON, V.TBC, 350, 350, 357, 375)
	self:AddRecipeFlags(29360, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(29360, 18779, 28698, 26962, 33617, 26999, 33682, 26912, 26976, 18747)

	-- Smelt Khorium -- 29361
	AddRecipe(29361, 375, 23449, Q.COMMON, V.TBC, 375, 375, 375, 375)
	self:AddRecipeFlags(29361, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(29361, 18779, 28698, 26962, 33617, 26999, 33682, 26912, 26976, 18747)

	-- Smelt Hardened Adamantite -- 29686
	AddRecipe(29686, 375, 23573, Q.COMMON, V.TBC, 375, 375, 375, 375)
	self:AddRecipeFlags(29686, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(29686, 18779, 28698, 26962, 33617, 26999, 33682, 26912, 26976, 18747)

	-- Earth Shatter -- 35750
	AddRecipe(35750, 300, 22573, Q.COMMON, V.TBC, 300, 300, 300, 300)
	self:AddRecipeFlags(35750, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(35750, 18779, 28698, 26962, 33617, 26999, 33682, 26912, 26976, 18747)

	-- Fire Sunder -- 35751
	AddRecipe(35751, 300, 22574, Q.COMMON, V.TBC, 300, 300, 300, 300)
	self:AddRecipeFlags(35751, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(35751, 18779, 28698, 26962, 33617, 26999, 33682, 26912, 26976, 18747)

	-- Smelt Hardened Khorium -- 46353
	AddRecipe(46353, 375, 35128, Q.RARE, V.WOTLK, 375, 375, 375, 375)
	self:AddRecipeFlags(46353, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(46353, A.CUSTOM, 24)

	-- Smelt Cobalt -- 49252
	AddRecipe(49252, 350, 36916, Q.COMMON, V.WOTLK, 350, 350, 362, 375)
	self:AddRecipeFlags(49252, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(49252, 26999, 28698, 26912, 26976, 26962)

	-- Smelt Saronite -- 49258
	AddRecipe(49258, 400, 36913, Q.COMMON, V.WOTLK, 400, 400, 400, 400)
	self:AddRecipeFlags(49258, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(49258, 26999, 28698, 26912, 26976, 26962)

	-- Smelt Titansteel -- 55208
	AddRecipe(55208, 450, 37663, Q.COMMON, V.WOTLK, 450, 450, 450, 450)
	self:AddRecipeFlags(55208, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(55208, 26999, 28698, 26912, 26976, 26962)

	-- Smelt Titanium -- 55211
	AddRecipe(55211, 450, 41163, Q.COMMON, V.WOTLK, 450, 450, 450, 450)
	self:AddRecipeFlags(55211, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(55211, 26999, 28698, 26912, 26976, 26962)

	-- Enchanted Thorium -- 70524
	AddRecipe(70524, 250, 12655, Q.COMMON, V.WOTLK, 250, 250, 255, 260)
	self:AddRecipeFlags(70524, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(70524, 28698)

	return num_recipes
end
