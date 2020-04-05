--[[
************************************************************************
FirstAid.lua
First Aid data for all of Ackis Recipe List
************************************************************************
File date: 2010-04-09T05:56:13Z
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
	addon:AddRecipe(spell_id, skill_level, item_id, quality, 3273, nil, genesis, optimal_level, medium_level, easy_level, trivial_level)
end

function addon:InitFirstAid()
	if initialized then
		return num_recipes
	end
	initialized = true

	-- Linen Bandage -- 3275
	AddRecipe(3275, 1, 1251, Q.COMMON, V.ORIG, 1, 30, 45, 60)
	self:AddRecipeFlags(3275, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(3275, A.CUSTOM, 8)

	-- Heavy Linen Bandage -- 3276
	AddRecipe(3276, 40, 2581, Q.COMMON, V.ORIG, 40, 50, 75, 100)
	self:AddRecipeFlags(3276, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3276, 33589, 33621, 17214, 16272, 19184, 6094, 5939, 5943, 4211, 2326, 4591, 3181, 16662, 28706, 5150, 2329, 26956, 17424, 18990, 18991, 23734, 3373, 16731, 5759, 19478, 2327, 26992, 22477, 2798, 29233)

	-- Wool Bandage -- 3277
	AddRecipe(3277, 80, 3530, Q.COMMON, V.ORIG, 80, 80, 115, 150)
	self:AddRecipeFlags(3277, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3277, 33589, 33621, 17214, 16272, 19184, 6094, 5939, 5943, 4211, 2326, 4591, 3181, 16662, 28706, 5150, 2329, 26956, 17424, 18990, 18991, 23734, 3373, 16731, 5759, 19478, 2327, 26992, 22477, 2798, 29233)

	-- Heavy Wool Bandage -- 3278
	AddRecipe(3278, 115, 3531, Q.COMMON, V.ORIG, 115, 115, 150, 185)
	self:AddRecipeFlags(3278, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3278, 33589, 33621, 17214, 16272, 19184, 6094, 5939, 5943, 4211, 2326, 4591, 3181, 16662, 28706, 5150, 2329, 26956, 17424, 18990, 18991, 23734, 3373, 16731, 5759, 19478, 2327, 26992, 22477, 2798, 29233)

	-- Silk Bandage -- 7928
	AddRecipe(7928, 150, 6450, Q.COMMON, V.ORIG, 150, 150, 180, 210)
	self:AddRecipeFlags(7928, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(7928, 33589, 33621, 17214, 16272, 19184, 6094, 5939, 5943, 4211, 2326, 4591, 3181, 16662, 28706, 5150, 2329, 26956, 17424, 18990, 18991, 23734, 3373, 16731, 5759, 19478, 2327, 26992, 22477, 2798, 29233)

	-- Heavy Silk Bandage -- 7929
	AddRecipe(7929, 180, 6451, Q.COMMON, V.ORIG, 180, 180, 210, 240)
	self:AddRecipeFlags(7929, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(7929, 33589, 33621, 17214, 16272, 19184, 6094, 5939, 5943, 4211, 2326, 4591, 3181, 16662, 28706, 5150, 2329, 26956, 17424, 18990, 18991, 23734, 3373, 16731, 5759, 19478, 2327, 26992, 22477, 2798, 29233)

	-- Anti-Venom -- 7934
	AddRecipe(7934, 80, 6452, Q.COMMON, V.ORIG, 80, 80, 115, 150)
	self:AddRecipeFlags(7934, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(7934, 33589, 33621, 17214, 16272, 19184, 6094, 5939, 5943, 4211, 2326, 4591, 3181, 16662, 28706, 5150, 2329, 26956, 17424, 18990, 18991, 23734, 3373, 16731, 5759, 19478, 2327, 26992, 22477, 2798, 29233)

	-- Strong Anti-Venom -- 7935
	AddRecipe(7935, 130, 6453, Q.UNCOMMON, V.ORIG, 130, 130, 165, 200)
	self:AddRecipeFlags(7935, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(7935, "Kalimdor", "Eastern Kingdoms")

	-- Mageweave Bandage -- 10840
	AddRecipe(10840, 210, 8544, Q.COMMON, V.ORIG, 210, 210, 240, 270)
	self:AddRecipeFlags(10840, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(10840, 33589, 33621, 17214, 16272, 19184, 6094, 5939, 5943, 4211, 2326, 4591, 3181, 16662, 28706, 5150, 2329, 26956, 17424, 18990, 18991, 23734, 3373, 16731, 5759, 19478, 2327, 26992, 22477, 2798, 29233)

	-- Heavy Mageweave Bandage -- 10841
	AddRecipe(10841, 240, 8545, Q.COMMON, V.ORIG, 240, 240, 270, 300)
	self:AddRecipeFlags(10841, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(10841, 33589, 33621, 17214, 16272, 19184, 6094, 5939, 5943, 4211, 2326, 4591, 3181, 16662, 28706, 5150, 2329, 26956, 17424, 18990, 18991, 23734, 3373, 16731, 5759, 19478, 2327, 26992, 22477, 2798, 29233)

	-- Runecloth Bandage -- 18629
	AddRecipe(18629, 260, 14529, Q.COMMON, V.ORIG, 260, 260, 290, 320)
	self:AddRecipeFlags(18629, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(18629, 33589, 33621, 17214, 16272, 19184, 6094, 5939, 5943, 4211, 2326, 4591, 3181, 16662, 28706, 5150, 2329, 26956, 17424, 18990, 18991, 23734, 3373, 16731, 5759, 19478, 2327, 26992, 22477, 2798, 29233)

	-- Heavy Runecloth Bandage -- 18630
	AddRecipe(18630, 290, 14530, Q.COMMON, V.ORIG, 290, 290, 320, 350)
	self:AddRecipeFlags(18630, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(18630, 33589, 33621, 17214, 16272, 19184, 6094, 5939, 5943, 4211, 2326, 4591, 3181, 16662, 28706, 5150, 2329, 26956, 17424, 18990, 18991, 23734, 3373, 16731, 5759, 19478, 2327, 26992, 22477, 2798, 29233)

	-- Powerful Anti-Venom -- 23787
	AddRecipe(23787, 300, 19440, Q.COMMON, V.ORIG, 300, 300, 330, 360)
	self:AddRecipeFlags(23787, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ARGENTDAWN)
	self:AddRecipeRepVendor(23787, FAC.ARGENTDAWN, REP.HONORED, 10856, 11536, 10857)

	-- Netherweave Bandage -- 27032
	AddRecipe(27032, 300, 21990, Q.COMMON, V.TBC, 300, 330, 347, 365)
	self:AddRecipeFlags(27032, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(27032, 26956, 18991, 29233, 18990, 26992, 23734, 33589, 28706)

	-- Heavy Netherweave Bandage -- 27033
	AddRecipe(27033, 330, 21991, Q.COMMON, V.TBC, 330, 360, 367, 375)
	self:AddRecipeFlags(27033, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(27033, 26956, 18991, 29233, 18990, 26992, 23734, 33589, 28706)

	-- Frostweave Bandage -- 45545
	AddRecipe(45545, 350, 34721, Q.COMMON, V.WOTLK, 350, 375, 392, 410)
	self:AddRecipeFlags(45545, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45545, 28706, 26992, 29233, 23734, 33589, 26956)

	-- Heavy Frostweave Bandage -- 45546
	AddRecipe(45546, 400, 34722, Q.UNCOMMON, V.WOTLK, 400, 400, 430, 470)
	self:AddRecipeFlags(45546, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOP)
	self:AddRecipeWorldDrop(45546, "Northrend")

	return num_recipes
end
