--[[
************************************************************************
Enchanting.lua
Enchanting data for all of Ackis Recipe List
************************************************************************
File date: 2010-09-07T13:13:55Z
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
	addon:AddRecipe(spell_id, skill_level, item_id, quality, 7411, nil, genesis, optimal_level, medium_level, easy_level, trivial_level)
end

function addon:InitEnchanting()
	if initialized then
		return num_recipes
	end
	initialized = true

	-- Enchant Bracer - Minor Health -- 7418
	AddRecipe(7418, 1, nil, Q.COMMON, V.ORIG, 1, 70, 90, 110)
	self:AddRecipeFlags(7418, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(7418, A.CUSTOM, 8)

	-- Enchant Chest - Minor Health -- 7420
	AddRecipe(7420, 15, nil, Q.COMMON, V.ORIG, 15, 70, 90, 110)
	self:AddRecipeFlags(7420, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(7420, 3606, 19540, 11072, 5695, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 16160, 4616, 11073, 33676, 4213, 3345, 3011, 33610, 7949, 1317)

	-- Runed Copper Rod -- 7421
	AddRecipe(7421, 1, 6218, Q.COMMON, V.ORIG, 1, 5, 7, 10)
	self:AddRecipeFlags(7421, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeAcquire(7421, A.CUSTOM, 8)

	-- Enchant Chest - Minor Absorption -- 7426
	AddRecipe(7426, 40, nil, Q.COMMON, V.ORIG, 40, 90, 110, 130)
	self:AddRecipeFlags(7426, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(7426, 3606, 19540, 11072, 5695, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 16160, 4616, 11073, 33676, 4213, 3345, 3011, 33610, 7949, 1317)

	-- Enchant Bracer - Minor Deflection -- 7428
	AddRecipe(7428, 1, nil, Q.COMMON, V.ORIG, 1, 80, 100, 120)
	self:AddRecipeFlags(7428, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeAcquire(7428, A.CUSTOM, 8)

	-- Enchant Chest - Minor Mana -- 7443
	AddRecipe(7443, 20, nil, Q.UNCOMMON, V.ORIG, 20, 80, 100, 120)
	self:AddRecipeFlags(7443, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(7443, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Cloak - Minor Resistance -- 7454
	AddRecipe(7454, 45, nil, Q.COMMON, V.ORIG, 45, 95, 115, 135)
	self:AddRecipeFlags(7454, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeTrainer(7454, 3606, 19540, 11072, 5695, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 16160, 4616, 11073, 33676, 4213, 3345, 3011, 33610, 7949, 1317)

	-- Enchant Bracer - Minor Stamina -- 7457
	AddRecipe(7457, 50, nil, Q.COMMON, V.ORIG, 50, 100, 120, 140)
	self:AddRecipeFlags(7457, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(7457, 3606, 19540, 11072, 5695, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 16160, 4616, 11073, 33676, 4213, 3345, 3011, 33610, 7949, 1317)

	-- Enchant 2H Weapon - Minor Impact -- 7745
	AddRecipe(7745, 100, nil, Q.COMMON, V.ORIG, 100, 130, 150, 170)
	self:AddRecipeFlags(7745, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.TWO_HAND)
	self:AddRecipeTrainer(7745, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 16160, 33676, 4213, 3345, 3011, 5695, 7949, 1317)

	-- Enchant Chest - Lesser Health -- 7748
	AddRecipe(7748, 60, nil, Q.COMMON, V.ORIG, 60, 105, 125, 145)
	self:AddRecipeFlags(7748, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(7748, 3606, 19540, 11072, 5695, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 16160, 4616, 11073, 33676, 4213, 3345, 3011, 33610, 7949, 1317)

	-- Enchant Bracer - Minor Spirit -- 7766
	AddRecipe(7766, 60, nil, Q.UNCOMMON, V.ORIG, 60, 105, 125, 145)
	self:AddRecipeFlags(7766, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(7766, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Cloak - Minor Protection -- 7771
	AddRecipe(7771, 70, nil, Q.COMMON, V.ORIG, 70, 110, 130, 150)
	self:AddRecipeFlags(7771, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeTrainer(7771, 3606, 19540, 11072, 5695, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 16160, 4616, 11073, 33676, 4213, 3345, 3011, 33610, 7949, 1317)

	-- Enchant Chest - Lesser Mana -- 7776
	AddRecipe(7776, 80, nil, Q.UNCOMMON, V.ORIG, 80, 115, 135, 155)
	self:AddRecipeFlags(7776, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(7776, 3346, 5757)

	-- Enchant Bracer - Minor Agility -- 7779
	AddRecipe(7779, 80, nil, Q.COMMON, V.ORIG, 80, 115, 135, 155)
	self:AddRecipeFlags(7779, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(7779, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 16160, 33676, 4213, 3345, 3011, 5695, 7949, 1317)

	-- Enchant Bracer - Minor Strength -- 7782
	AddRecipe(7782, 80, nil, Q.UNCOMMON, V.ORIG, 80, 115, 135, 155)
	self:AddRecipeFlags(7782, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(7782, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Weapon - Minor Beastslayer -- 7786
	AddRecipe(7786, 90, nil, Q.UNCOMMON, V.ORIG, 90, 120, 140, 160)
	self:AddRecipeFlags(7786, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeWorldDrop(7786, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Weapon - Minor Striking -- 7788
	AddRecipe(7788, 90, nil, Q.COMMON, V.ORIG, 90, 120, 140, 160)
	self:AddRecipeFlags(7788, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeTrainer(7788, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 16160, 33676, 4213, 3345, 3011, 5695, 7949, 1317)

	-- Enchant 2H Weapon - Lesser Intellect -- 7793
	AddRecipe(7793, 100, nil, Q.COMMON, V.ORIG, 100, 130, 150, 170)
	self:AddRecipeFlags(7793, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.TWO_HAND)
	self:AddRecipeVendor(7793, 3012, 5158, 3346, 5758)

	-- Runed Silver Rod -- 7795
	AddRecipe(7795, 100, 6339, Q.COMMON, V.ORIG, 100, 130, 150, 170)
	self:AddRecipeFlags(7795, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(7795, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 16160, 33676, 4213, 3345, 3011, 5695, 7949, 1317)

	-- Enchant Chest - Health -- 7857
	AddRecipe(7857, 120, nil, Q.COMMON, V.ORIG, 120, 145, 165, 185)
	self:AddRecipeFlags(7857, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(7857, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Bracer - Lesser Spirit -- 7859
	AddRecipe(7859, 120, nil, Q.UNCOMMON, V.ORIG, 120, 145, 165, 185)
	self:AddRecipeFlags(7859, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(7859, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Cloak - Lesser Fire Resistance -- 7861
	AddRecipe(7861, 125, nil, Q.COMMON, V.ORIG, 125, 150, 170, 190)
	self:AddRecipeFlags(7861, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeTrainer(7861, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Boots - Minor Stamina -- 7863
	AddRecipe(7863, 125, nil, Q.COMMON, V.ORIG, 125, 150, 170, 190)
	self:AddRecipeFlags(7863, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(7863, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Boots - Minor Agility -- 7867
	AddRecipe(7867, 125, nil, Q.UNCOMMON, V.ORIG, 125, 150, 170, 190)
	self:AddRecipeFlags(7867, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeVendor(7867, 3012, 3537)

	-- Enchant Shield - Minor Stamina -- 13378
	AddRecipe(13378, 105, nil, Q.COMMON, V.ORIG, 105, 130, 150, 170)
	self:AddRecipeFlags(13378, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.SHIELD)
	self:AddRecipeTrainer(13378, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 1317, 4213, 33676, 3011, 3345, 7949, 16160, 5695)

	-- Enchant 2H Weapon - Lesser Spirit -- 13380
	AddRecipe(13380, 110, nil, Q.UNCOMMON, V.ORIG, 110, 135, 155, 175)
	self:AddRecipeFlags(13380, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.TWO_HAND)
	self:AddRecipeWorldDrop(13380, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Cloak - Minor Agility -- 13419
	AddRecipe(13419, 110, nil, Q.UNCOMMON, V.ORIG, 110, 135, 155, 175)
	self:AddRecipeFlags(13419, F.ALLIANCE, F.HORDE, F.VENDOR, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.CLOAK)
	self:AddRecipeVendor(13419, 3954, 12043)
	self:AddRecipeWorldDrop(13419, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Cloak - Lesser Protection -- 13421
	AddRecipe(13421, 115, nil, Q.COMMON, V.ORIG, 115, 140, 160, 180)
	self:AddRecipeFlags(13421, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeTrainer(13421, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Shield - Lesser Protection -- 13464
	AddRecipe(13464, 115, nil, Q.UNCOMMON, V.ORIG, 115, 140, 160, 180)
	self:AddRecipeFlags(13464, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.SHIELD)
	self:AddRecipeWorldDrop(13464, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Shield - Lesser Spirit -- 13485
	AddRecipe(13485, 130, nil, Q.COMMON, V.ORIG, 130, 155, 175, 195)
	self:AddRecipeFlags(13485, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.SHIELD)
	self:AddRecipeTrainer(13485, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Bracer - Lesser Stamina -- 13501
	AddRecipe(13501, 130, nil, Q.COMMON, V.ORIG, 130, 155, 175, 195)
	self:AddRecipeFlags(13501, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13501, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Weapon - Lesser Striking -- 13503
	AddRecipe(13503, 140, nil, Q.COMMON, V.ORIG, 140, 165, 185, 205)
	self:AddRecipeFlags(13503, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeTrainer(13503, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Cloak - Lesser Shadow Resistance -- 13522
	AddRecipe(13522, 135, nil, Q.UNCOMMON, V.ORIG, 135, 160, 180, 200)
	self:AddRecipeFlags(13522, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeWorldDrop(13522, "Kalimdor", "Eastern Kingdoms")

	-- Enchant 2H Weapon - Lesser Impact -- 13529
	AddRecipe(13529, 145, nil, Q.COMMON, V.ORIG, 145, 170, 190, 210)
	self:AddRecipeFlags(13529, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.TWO_HAND)
	self:AddRecipeTrainer(13529, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Bracer - Lesser Strength -- 13536
	AddRecipe(13536, 140, nil, Q.UNCOMMON, V.ORIG, 140, 165, 185, 205)
	self:AddRecipeFlags(13536, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeVendor(13536, 3954, 12043)

	-- Enchant Chest - Lesser Absorption -- 13538
	AddRecipe(13538, 140, nil, Q.COMMON, V.ORIG, 140, 165, 185, 205)
	self:AddRecipeFlags(13538, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13538, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Chest - Mana -- 13607
	AddRecipe(13607, 145, nil, Q.COMMON, V.ORIG, 145, 170, 190, 210)
	self:AddRecipeFlags(13607, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13607, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Gloves - Mining -- 13612
	AddRecipe(13612, 145, nil, Q.UNCOMMON, V.ORIG, 145, 170, 190, 210)
	self:AddRecipeFlags(13612, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(13612, 1054, 1051, 1052, 1364, 1053)

	-- Enchant Gloves - Herbalism -- 13617
	AddRecipe(13617, 145, nil, Q.UNCOMMON, V.ORIG, 145, 170, 190, 210)
	self:AddRecipeFlags(13617, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(13617, 4029, 3834, 3919, 4028, 4030)

	-- Enchant Gloves - Fishing -- 13620
	AddRecipe(13620, 145, nil, Q.UNCOMMON, V.ORIG, 145, 170, 190, 210)
	self:AddRecipeFlags(13620, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(13620, 2377, 2374, 2375, 2376, 14276)

	-- Enchant Bracer - Lesser Intellect -- 13622
	AddRecipe(13622, 150, nil, Q.COMMON, V.ORIG, 150, 175, 195, 215)
	self:AddRecipeFlags(13622, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13622, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Chest - Minor Stats -- 13626
	AddRecipe(13626, 150, nil, Q.COMMON, V.ORIG, 150, 175, 195, 215)
	self:AddRecipeFlags(13626, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13626, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Runed Golden Rod -- 13628
	AddRecipe(13628, 150, 11130, Q.COMMON, V.ORIG, 150, 175, 195, 215)
	self:AddRecipeFlags(13628, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(13628, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 4616, 5695, 1317, 4213, 3345, 3011, 33676, 7949, 16160)

	-- Enchant Shield - Lesser Stamina -- 13631
	AddRecipe(13631, 155, nil, Q.COMMON, V.ORIG, 155, 175, 195, 215)
	self:AddRecipeFlags(13631, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.SHIELD)
	self:AddRecipeTrainer(13631, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Cloak - Defense -- 13635
	AddRecipe(13635, 155, nil, Q.COMMON, V.ORIG, 155, 175, 195, 215)
	self:AddRecipeFlags(13635, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.TANK, F.CLOAK)
	self:AddRecipeTrainer(13635, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Boots - Lesser Agility -- 13637
	AddRecipe(13637, 160, nil, Q.COMMON, V.ORIG, 160, 180, 200, 220)
	self:AddRecipeFlags(13637, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(13637, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Chest - Greater Health -- 13640
	AddRecipe(13640, 160, nil, Q.COMMON, V.ORIG, 160, 180, 200, 220)
	self:AddRecipeFlags(13640, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13640, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Bracer - Spirit -- 13642
	AddRecipe(13642, 165, nil, Q.COMMON, V.ORIG, 165, 185, 205, 225)
	self:AddRecipeFlags(13642, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(13642, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Boots - Lesser Stamina -- 13644
	AddRecipe(13644, 170, nil, Q.COMMON, V.ORIG, 170, 190, 210, 230)
	self:AddRecipeFlags(13644, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13644, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Bracer - Lesser Deflection -- 13646
	AddRecipe(13646, 170, nil, Q.UNCOMMON, V.ORIG, 170, 190, 210, 230)
	self:AddRecipeFlags(13646, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.TANK)
	self:AddRecipeLimitedVendor(13646, 2381, 1, 2821, 1)

	-- Enchant Bracer - Stamina -- 13648
	AddRecipe(13648, 170, nil, Q.COMMON, V.ORIG, 170, 190, 210, 230)
	self:AddRecipeFlags(13648, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13648, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Weapon - Lesser Beastslayer -- 13653
	AddRecipe(13653, 175, nil, Q.UNCOMMON, V.ORIG, 175, 195, 215, 235)
	self:AddRecipeFlags(13653, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeWorldDrop(13653, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Weapon - Lesser Elemental Slayer -- 13655
	AddRecipe(13655, 175, nil, Q.UNCOMMON, V.ORIG, 175, 195, 215, 235)
	self:AddRecipeFlags(13655, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeWorldDrop(13655, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Cloak - Fire Resistance -- 13657
	AddRecipe(13657, 175, nil, Q.COMMON, V.ORIG, 175, 195, 215, 235)
	self:AddRecipeFlags(13657, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeTrainer(13657, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Shield - Spirit -- 13659
	AddRecipe(13659, 180, nil, Q.COMMON, V.ORIG, 180, 200, 220, 240)
	self:AddRecipeFlags(13659, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.SHIELD)
	self:AddRecipeTrainer(13659, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Bracer - Strength -- 13661
	AddRecipe(13661, 180, nil, Q.COMMON, V.ORIG, 180, 200, 220, 240)
	self:AddRecipeFlags(13661, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(13661, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Chest - Greater Mana -- 13663
	AddRecipe(13663, 185, nil, Q.COMMON, V.ORIG, 185, 205, 225, 245)
	self:AddRecipeFlags(13663, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13663, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Boots - Lesser Spirit -- 13687
	AddRecipe(13687, 190, nil, Q.UNCOMMON, V.ORIG, 190, 210, 230, 250)
	self:AddRecipeFlags(13687, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(13687, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Shield - Lesser Block -- 13689
	AddRecipe(13689, 195, nil, Q.UNCOMMON, V.ORIG, 195, 215, 235, 255)
	self:AddRecipeFlags(13689, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.TANK, F.SHIELD)
	self:AddRecipeWorldDrop(13689, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Weapon - Striking -- 13693
	AddRecipe(13693, 195, nil, Q.COMMON, V.ORIG, 195, 215, 235, 255)
	self:AddRecipeFlags(13693, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeTrainer(13693, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant 2H Weapon - Impact -- 13695
	AddRecipe(13695, 200, nil, Q.COMMON, V.ORIG, 200, 220, 240, 260)
	self:AddRecipeFlags(13695, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.TWO_HAND)
	self:AddRecipeTrainer(13695, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Gloves - Skinning -- 13698
	AddRecipe(13698, 200, nil, Q.UNCOMMON, V.ORIG, 200, 220, 240, 260)
	self:AddRecipeFlags(13698, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(13698, 2556, 2558, 2557, 2606)

	-- Enchant Chest - Lesser Stats -- 13700
	AddRecipe(13700, 200, nil, Q.COMMON, V.ORIG, 200, 220, 240, 260)
	self:AddRecipeFlags(13700, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13700, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Runed Truesilver Rod -- 13702
	AddRecipe(13702, 200, 11145, Q.COMMON, V.ORIG, 200, 220, 240, 260)
	self:AddRecipeFlags(13702, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(13702, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Cloak - Greater Defense -- 13746
	AddRecipe(13746, 205, nil, Q.COMMON, V.ORIG, 205, 225, 245, 265)
	self:AddRecipeFlags(13746, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.TANK, F.CLOAK)
	self:AddRecipeTrainer(13746, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Cloak - Resistance -- 13794
	AddRecipe(13794, 205, nil, Q.COMMON, V.ORIG, 205, 225, 245, 265)
	self:AddRecipeFlags(13794, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeTrainer(13794, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Gloves - Agility -- 13815
	AddRecipe(13815, 210, nil, Q.COMMON, V.ORIG, 210, 230, 250, 270)
	self:AddRecipeFlags(13815, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(13815, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Shield - Stamina -- 13817
	AddRecipe(13817, 210, nil, Q.UNCOMMON, V.ORIG, 210, 230, 250, 270)
	self:AddRecipeFlags(13817, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.SHIELD)
	self:AddRecipeWorldDrop(13817, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Bracer - Intellect -- 13822
	AddRecipe(13822, 210, nil, Q.COMMON, V.ORIG, 210, 230, 250, 270)
	self:AddRecipeFlags(13822, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13822, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Boots - Stamina -- 13836
	AddRecipe(13836, 215, nil, Q.COMMON, V.ORIG, 215, 235, 255, 275)
	self:AddRecipeFlags(13836, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13836, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Gloves - Advanced Mining -- 13841
	AddRecipe(13841, 215, nil, Q.UNCOMMON, V.ORIG, 215, 235, 255, 275)
	self:AddRecipeFlags(13841, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(13841, 674)

	-- Enchant Bracer - Greater Spirit -- 13846
	AddRecipe(13846, 220, nil, Q.UNCOMMON, V.ORIG, 220, 240, 260, 280)
	self:AddRecipeFlags(13846, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(13846, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Chest - Superior Health -- 13858
	AddRecipe(13858, 220, nil, Q.COMMON, V.ORIG, 220, 240, 260, 280)
	self:AddRecipeFlags(13858, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13858, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Gloves - Advanced Herbalism -- 13868
	AddRecipe(13868, 225, nil, Q.UNCOMMON, V.ORIG, 225, 245, 265, 285)
	self:AddRecipeFlags(13868, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(13868, 764, 766, 14448, 1081, 765)

	-- Enchant Cloak - Lesser Agility -- 13882
	AddRecipe(13882, 225, nil, Q.UNCOMMON, V.ORIG, 225, 245, 265, 285)
	self:AddRecipeFlags(13882, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.CLOAK)
	self:AddRecipeMobDrop(13882, 5623, 7805, 2246)

	-- Enchant Gloves - Strength -- 13887
	AddRecipe(13887, 225, nil, Q.COMMON, V.ORIG, 225, 245, 265, 285)
	self:AddRecipeFlags(13887, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(13887, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Boots - Minor Speed -- 13890
	AddRecipe(13890, 225, nil, Q.COMMON, V.ORIG, 225, 245, 265, 285)
	self:AddRecipeFlags(13890, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13890, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Weapon - Fiery Weapon -- 13898
	AddRecipe(13898, 265, nil, Q.UNCOMMON, V.ORIG, 265, 285, 305, 325)
	self:AddRecipeFlags(13898, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeMobDrop(13898, 9024)

	-- Enchant Shield - Greater Spirit -- 13905
	AddRecipe(13905, 230, nil, Q.COMMON, V.ORIG, 230, 250, 270, 290)
	self:AddRecipeFlags(13905, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.SHIELD)
	self:AddRecipeTrainer(13905, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Weapon - Demonslaying -- 13915
	AddRecipe(13915, 230, nil, Q.UNCOMMON, V.ORIG, 230, 250, 270, 290)
	self:AddRecipeFlags(13915, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeWorldDrop(13915, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Chest - Superior Mana -- 13917
	AddRecipe(13917, 230, nil, Q.COMMON, V.ORIG, 230, 250, 270, 290)
	self:AddRecipeFlags(13917, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13917, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Bracer - Deflection -- 13931
	AddRecipe(13931, 235, nil, Q.UNCOMMON, V.ORIG, 235, 255, 275, 295)
	self:AddRecipeFlags(13931, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.TANK)
	self:AddRecipeVendor(13931, 989, 4229)

	-- Enchant Shield - Frost Resistance -- 13933
	AddRecipe(13933, 235, nil, Q.UNCOMMON, V.ORIG, 235, 255, 275, 295)
	self:AddRecipeFlags(13933, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.SHIELD)
	self:AddRecipeWorldDrop(13933, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Boots - Agility -- 13935
	AddRecipe(13935, 235, nil, Q.COMMON, V.ORIG, 235, 255, 275, 295)
	self:AddRecipeFlags(13935, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(13935, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant 2H Weapon - Greater Impact -- 13937
	AddRecipe(13937, 240, nil, Q.COMMON, V.ORIG, 240, 260, 280, 300)
	self:AddRecipeFlags(13937, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.TWO_HAND)
	self:AddRecipeTrainer(13937, 3606, 19540, 11072, 5695, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 16160, 4616, 11073, 33676, 4213, 3345, 3011, 33610, 7949, 1317)

	-- Enchant Bracer - Greater Strength -- 13939
	AddRecipe(13939, 240, nil, Q.COMMON, V.ORIG, 240, 260, 280, 300)
	self:AddRecipeFlags(13939, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(13939, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Chest - Stats -- 13941
	AddRecipe(13941, 245, nil, Q.COMMON, V.ORIG, 245, 265, 285, 305)
	self:AddRecipeFlags(13941, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13941, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Weapon - Greater Striking -- 13943
	AddRecipe(13943, 245, nil, Q.COMMON, V.ORIG, 245, 265, 285, 305)
	self:AddRecipeFlags(13943, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeTrainer(13943, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Bracer - Greater Stamina -- 13945
	AddRecipe(13945, 245, nil, Q.UNCOMMON, V.ORIG, 245, 265, 285, 305)
	self:AddRecipeFlags(13945, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(13945, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Gloves - Riding Skill -- 13947
	AddRecipe(13947, 250, nil, Q.UNCOMMON, V.ORIG, 250, 270, 290, 310)
	self:AddRecipeFlags(13947, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(13947, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Gloves - Minor Haste -- 13948
	AddRecipe(13948, 250, nil, Q.COMMON, V.ORIG, 250, 270, 290, 310)
	self:AddRecipeFlags(13948, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(13948, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Lesser Magic Wand -- 14293
	AddRecipe(14293, 10, 11287, Q.COMMON, V.ORIG, 10, 75, 95, 115)
	self:AddRecipeFlags(14293, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.WAND)
	self:AddRecipeTrainer(14293, 3606, 19540, 11072, 5695, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 16160, 4616, 11073, 33676, 4213, 3345, 3011, 33610, 7949, 1317)

	-- Greater Magic Wand -- 14807
	AddRecipe(14807, 70, 11288, Q.COMMON, V.ORIG, 70, 110, 130, 150)
	self:AddRecipeFlags(14807, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.WAND)
	self:AddRecipeTrainer(14807, 3606, 19540, 11072, 5695, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 16160, 4616, 11073, 33676, 4213, 3345, 3011, 33610, 7949, 1317)

	-- Lesser Mystic Wand -- 14809
	AddRecipe(14809, 155, 11289, Q.COMMON, V.ORIG, 155, 175, 195, 215)
	self:AddRecipeFlags(14809, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.WAND)
	self:AddRecipeTrainer(14809, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Greater Mystic Wand -- 14810
	AddRecipe(14810, 175, 11290, Q.COMMON, V.ORIG, 175, 195, 215, 235)
	self:AddRecipeFlags(14810, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.WAND)
	self:AddRecipeTrainer(14810, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Smoking Heart of the Mountain -- 15596
	AddRecipe(15596, 265, 45050, Q.UNCOMMON, V.ORIG, 265, 285, 305, 325)
	self:AddRecipeFlags(15596, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOP, F.RBOP, F.TRINKET)
	self:AddRecipeMobDrop(15596, 9025)

	-- Enchanted Thorium -- 17180
	AddRecipe(17180, 250, 12655, Q.COMMON, V.ORIG, 250, 250, 255, 260)
	self:AddRecipeFlags(17180, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(17180, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchanted Leather -- 17181
	AddRecipe(17181, 250, 12810, Q.COMMON, V.ORIG, 250, 250, 255, 260)
	self:AddRecipeFlags(17181, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(17181, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Bracer - Greater Intellect -- 20008
	AddRecipe(20008, 255, nil, Q.COMMON, V.ORIG, 255, 275, 295, 315)
	self:AddRecipeFlags(20008, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(20008, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Bracer - Superior Spirit -- 20009
	AddRecipe(20009, 270, nil, Q.UNCOMMON, V.ORIG, 270, 290, 310, 330)
	self:AddRecipeFlags(20009, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(20009, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Bracer - Superior Strength -- 20010
	AddRecipe(20010, 295, nil, Q.UNCOMMON, V.ORIG, 295, 310, 325, 340)
	self:AddRecipeFlags(20010, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeMobDrop(20010, 7372)

	-- Enchant Bracer - Superior Stamina -- 20011
	AddRecipe(20011, 300, nil, Q.UNCOMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(20011, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(20011, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Gloves - Greater Agility -- 20012
	AddRecipe(20012, 270, nil, Q.COMMON, V.ORIG, 270, 290, 310, 330)
	self:AddRecipeFlags(20012, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(20012, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Gloves - Greater Strength -- 20013
	AddRecipe(20013, 295, nil, Q.COMMON, V.ORIG, 295, 310, 325, 340)
	self:AddRecipeFlags(20013, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(20013, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Cloak - Greater Resistance -- 20014
	AddRecipe(20014, 265, nil, Q.COMMON, V.ORIG, 265, 285, 305, 325)
	self:AddRecipeFlags(20014, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeTrainer(20014, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Cloak - Superior Defense -- 20015
	AddRecipe(20015, 285, nil, Q.COMMON, V.ORIG, 285, 300, 317, 335)
	self:AddRecipeFlags(20015, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.TANK, F.CLOAK)
	self:AddRecipeVendor(20015, 12022)

	-- Enchant Shield - Vitality -- 20016
	AddRecipe(20016, 280, nil, Q.COMMON, V.ORIG, 280, 300, 320, 340)
	self:AddRecipeFlags(20016, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.SHIELD)
	self:AddRecipeTrainer(20016, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Shield - Greater Stamina -- 20017
	AddRecipe(20017, 265, nil, Q.COMMON, V.ORIG, 265, 285, 305, 325)
	self:AddRecipeFlags(20017, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SHIELD)
	self:AddRecipeVendor(20017, 4229, 4561)

	-- Enchant Boots - Greater Stamina -- 20020
	AddRecipe(20020, 260, nil, Q.UNCOMMON, V.ORIG, 260, 280, 300, 320)
	self:AddRecipeFlags(20020, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(20020, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Boots - Greater Agility -- 20023
	AddRecipe(20023, 295, nil, Q.COMMON, V.ORIG, 295, 310, 325, 340)
	self:AddRecipeFlags(20023, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(20023, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Boots - Spirit -- 20024
	AddRecipe(20024, 275, nil, Q.UNCOMMON, V.ORIG, 275, 295, 315, 335)
	self:AddRecipeFlags(20024, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(20024, "Kalimdor", "Eastern Kingdoms")

	-- Enchant Chest - Greater Stats -- 20025
	AddRecipe(20025, 300, nil, Q.UNCOMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(20025, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(20025, "Outland")

	-- Enchant Chest - Major Health -- 20026
	AddRecipe(20026, 275, nil, Q.COMMON, V.ORIG, 275, 295, 315, 335)
	self:AddRecipeFlags(20026, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(20026, 11189)

	-- Enchant Chest - Major Mana -- 20028
	AddRecipe(20028, 290, nil, Q.COMMON, V.ORIG, 290, 305, 322, 340)
	self:AddRecipeFlags(20028, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(20028, 3606, 19540, 11072, 11073, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 33610, 1317, 16160, 33676, 4213, 3345, 3011, 4616, 7949, 5695)

	-- Enchant Weapon - Icy Chill -- 20029
	AddRecipe(20029, 285, nil, Q.UNCOMMON, V.ORIG, 285, 300, 317, 335)
	self:AddRecipeFlags(20029, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeMobDrop(20029, 7524)

	-- Enchant 2H Weapon - Superior Impact -- 20030
	AddRecipe(20030, 295, nil, Q.UNCOMMON, V.ORIG, 295, 310, 325, 340)
	self:AddRecipeFlags(20030, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.TWO_HAND)
	self:AddRecipeMobDrop(20030, 10317)

	-- Enchant Weapon - Superior Striking -- 20031
	AddRecipe(20031, 300, nil, Q.UNCOMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(20031, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeMobDrop(20031, 9216)

	-- Enchant Weapon - Lifestealing -- 20032
	AddRecipe(20032, 300, nil, Q.RARE, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(20032, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeMobDrop(20032, 10499)

	-- Enchant Weapon - Unholy Weapon -- 20033
	AddRecipe(20033, 295, nil, Q.UNCOMMON, V.ORIG, 295, 310, 325, 340)
	self:AddRecipeFlags(20033, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeMobDrop(20033, 10398, 16810)

	-- Enchant Weapon - Crusader -- 20034
	AddRecipe(20034, 300, nil, Q.UNCOMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(20034, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeMobDrop(20034, 4494, 9451)

	-- Enchant 2H Weapon - Major Spirit -- 20035
	AddRecipe(20035, 300, nil, Q.UNCOMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(20035, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.TWO_HAND)
	self:AddRecipeMobDrop(20035, 10469)

	-- Enchant 2H Weapon - Major Intellect -- 20036
	AddRecipe(20036, 300, nil, Q.UNCOMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(20036, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.TWO_HAND)
	self:AddRecipeMobDrop(20036, 10422)

	-- Runed Arcanite Rod -- 20051
	AddRecipe(20051, 290, 16207, Q.COMMON, V.ORIG, 290, 305, 322, 340)
	self:AddRecipeFlags(20051, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOE)
	self:AddRecipeVendor(20051, 12022)

	-- Enchant Weapon - Winter's Might -- 21931
	AddRecipe(21931, 190, nil, Q.UNCOMMON, V.ORIG, 190, 210, 230, 250)
	self:AddRecipeFlags(21931, F.ALLIANCE, F.HORDE, F.SEASONAL, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeAcquire(21931, A.SEASONAL, 1)

	-- Enchant Weapon - Spellpower -- 22749
	AddRecipe(22749, 300, nil, Q.RARE, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(22749, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeAcquire(22749, A.CUSTOM, 26)

	-- Enchant Weapon - Healing Power -- 22750
	AddRecipe(22750, 300, nil, Q.RARE, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(22750, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeAcquire(22750, A.CUSTOM, 26)

	-- Enchant Weapon - Strength -- 23799
	AddRecipe(23799, 290, nil, Q.COMMON, V.ORIG, 290, 305, 322, 340)
	self:AddRecipeFlags(23799, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.ONE_HAND, F.TWO_HAND, F.THORIUM_BROTHERHOOD)
	self:AddRecipeRepVendor(23799, FAC.THORIUM_BROTHERHOOD, REP.FRIENDLY, 12944)

	-- Enchant Weapon - Agility -- 23800
	AddRecipe(23800, 290, nil, Q.COMMON, V.ORIG, 290, 305, 322, 340)
	self:AddRecipeFlags(23800, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.ONE_HAND, F.TWO_HAND, F.TIMBERMAW_HOLD)
	self:AddRecipeRepVendor(23800, FAC.TIMBERMAW_HOLD, REP.HONORED, 11557)

	-- Enchant Bracer - Mana Regeneration -- 23801
	AddRecipe(23801, 290, nil, Q.COMMON, V.ORIG, 290, 305, 322, 340)
	self:AddRecipeFlags(23801, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ARGENTDAWN)
	self:AddRecipeRepVendor(23801, FAC.ARGENTDAWN, REP.HONORED, 10856, 11536, 10857)

	-- Enchant Bracer - Healing Power -- 23802
	AddRecipe(23802, 300, nil, Q.COMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(23802, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ARGENTDAWN)
	self:AddRecipeRepVendor(23802, FAC.ARGENTDAWN, REP.REVERED, 10856, 11536, 10857)

	-- Enchant Weapon - Mighty Spirit -- 23803
	AddRecipe(23803, 300, nil, Q.COMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(23803, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND, F.THORIUM_BROTHERHOOD)
	self:AddRecipeRepVendor(23803, FAC.THORIUM_BROTHERHOOD, REP.HONORED, 12944)

	-- Enchant Weapon - Mighty Intellect -- 23804
	AddRecipe(23804, 300, nil, Q.COMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(23804, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ONE_HAND, F.HEALER, F.CASTER, F.TWO_HAND, F.THORIUM_BROTHERHOOD)
	self:AddRecipeRepVendor(23804, FAC.THORIUM_BROTHERHOOD, REP.REVERED, 12944)

	-- Enchant Gloves - Threat -- 25072
	AddRecipe(25072, 300, nil, Q.RARE, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(25072, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.MOB_DROP, F.IBOE, F.RBOP, F.TANK, F.SHATAR)
	self:AddRecipeMobDrop(25072, 15275)
	self:AddRecipeRepVendor(25072, FAC.SHATAR, REP.EXALTED, 21432)

	-- Enchant Gloves - Shadow Power -- 25073
	AddRecipe(25073, 300, nil, Q.RARE, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(25073, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(25073, A.CUSTOM, 22)

	-- Enchant Gloves - Frost Power -- 25074
	AddRecipe(25074, 300, nil, Q.RARE, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(25074, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(25074, A.CUSTOM, 22)

	-- Enchant Gloves - Fire Power -- 25078
	AddRecipe(25078, 300, nil, Q.RARE, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(25078, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(25078, A.CUSTOM, 22)

	-- Enchant Gloves - Healing Power -- 25079
	AddRecipe(25079, 300, nil, Q.RARE, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(25079, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(25079, A.CUSTOM, 22)

	-- Enchant Gloves - Superior Agility -- 25080
	AddRecipe(25080, 300, nil, Q.RARE, V.TBC, 300, 310, 325, 340)
	self:AddRecipeFlags(25080, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.DPS, F.KOT)
	self:AddRecipeRepVendor(25080, FAC.KEEPERS_OF_TIME, REP.EXALTED, 21643)
	self:AddRecipeAcquire(25080, A.CUSTOM, 22)

	-- Enchant Cloak - Greater Fire Resistance -- 25081
	AddRecipe(25081, 300, nil, Q.COMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(25081, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CLOAK, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(25081, FAC.CENARION_CIRCLE, REP.FRIENDLY, 15419)

	-- Enchant Cloak - Greater Nature Resistance -- 25082
	AddRecipe(25082, 300, nil, Q.COMMON, V.ORIG, 300, 310, 325, 340)
	self:AddRecipeFlags(25082, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CLOAK, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(25082, FAC.CENARION_CIRCLE, REP.HONORED, 15419)

	-- Enchant Cloak - Stealth -- 25083
	AddRecipe(25083, 300, nil, Q.RARE, V.TBC, 300, 310, 325, 340)
	self:AddRecipeFlags(25083, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOE, F.CLOAK, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(25083, FAC.CENARION_EXPEDITION, REP.EXALTED, 17904)
	self:AddRecipeAcquire(25083, A.CUSTOM, 22)

	-- Enchant Cloak - Subtlety -- 25084
	AddRecipe(25084, 300, nil, Q.RARE, V.TBC, 300, 310, 325, 340)
	self:AddRecipeFlags(25084, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.MOB_DROP, F.IBOE, F.RBOP, F.CLOAK, F.HELLFIRE)
	self:AddRecipeMobDrop(25084, 15276)
	self:AddRecipeRepVendor(25084, FAC.HONOR_HOLD, REP.EXALTED, 17657)
	self:AddRecipeRepVendor(25084, FAC.THRALLMAR, REP.EXALTED, 17585)

	-- Enchant Cloak - Dodge -- 25086
	AddRecipe(25086, 300, nil, Q.RARE, V.TBC, 300, 310, 325, 340)
	self:AddRecipeFlags(25086, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.TANK, F.CLOAK, F.LOWERCITY)
	self:AddRecipeRepVendor(25086, FAC.LOWERCITY, REP.EXALTED, 21655)
	self:AddRecipeAcquire(25086, A.CUSTOM, 22)

	-- Minor Wizard Oil -- 25124
	AddRecipe(25124, 45, 20744, Q.COMMON, V.ORIG, 45, 55, 65, 75)
	self:AddRecipeFlags(25124, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(25124, 28714, 15419, 4617, 18951, 5757, 16722, 27030, 19234, 3012, 5758, 26569, 18773, 4228, 5158, 16635, 19663, 3346, 1318, 27054, 27147, 19537, 18753, 19540)

	-- Minor Mana Oil -- 25125
	AddRecipe(25125, 150, 20745, Q.COMMON, V.ORIG, 150, 160, 170, 180)
	self:AddRecipeFlags(25125, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(25125, 28714, 15419, 4617, 18951, 5757, 16722, 27030, 19234, 3012, 5758, 26569, 18773, 4228, 5158, 16635, 19663, 3346, 1318, 27054, 27147, 19537, 18753, 19540)

	-- Lesser Wizard Oil -- 25126
	AddRecipe(25126, 200, 20746, Q.COMMON, V.ORIG, 200, 210, 220, 230)
	self:AddRecipeFlags(25126, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(25126, 28714, 15419, 4617, 18951, 5757, 16722, 27030, 19234, 3012, 5758, 26569, 18773, 4228, 5158, 16635, 19663, 3346, 1318, 27054, 27147, 19537, 18753, 19540)

	-- Lesser Mana Oil -- 25127
	AddRecipe(25127, 250, 20747, Q.COMMON, V.ORIG, 250, 260, 270, 280)
	self:AddRecipeFlags(25127, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(25127, 15419)

	-- Wizard Oil -- 25128
	AddRecipe(25128, 275, 20750, Q.COMMON, V.ORIG, 275, 285, 295, 305)
	self:AddRecipeFlags(25128, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(25128, 15419)

	-- Brilliant Wizard Oil -- 25129
	AddRecipe(25129, 300, 20749, Q.COMMON, V.ORIG, 300, 310, 320, 330)
	self:AddRecipeFlags(25129, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ZANDALAR)
	self:AddRecipeRepVendor(25129, FAC.ZANDALAR, REP.HONORED, 14921)

	-- Brilliant Mana Oil -- 25130
	AddRecipe(25130, 300, 20748, Q.COMMON, V.ORIG, 300, 310, 320, 330)
	self:AddRecipeFlags(25130, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ZANDALAR)
	self:AddRecipeRepVendor(25130, FAC.ZANDALAR, REP.FRIENDLY, 14921)

	-- Enchant 2H Weapon - Agility -- 27837
	AddRecipe(27837, 290, nil, Q.COMMON, V.ORIG, 290, 305, 322, 340)
	self:AddRecipeFlags(27837, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TWO_HAND, F.TIMBERMAW_HOLD)
	self:AddRecipeRepVendor(27837, FAC.TIMBERMAW_HOLD, REP.FRIENDLY, 11557)

	-- Enchant Bracer - Brawn -- 27899
	AddRecipe(27899, 305, nil, Q.COMMON, V.TBC, 305, 315, 330, 345)
	self:AddRecipeFlags(27899, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(27899, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Bracer - Stats -- 27905
	AddRecipe(27905, 315, nil, Q.COMMON, V.TBC, 315, 325, 340, 355)
	self:AddRecipeFlags(27905, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(27905, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Bracer - Major Defense -- 27906
	AddRecipe(27906, 320, nil, Q.UNCOMMON, V.TBC, 320, 330, 345, 360)
	self:AddRecipeFlags(27906, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeMobDrop(27906, 22822, 23008)

	-- Enchant Bracer - Superior Healing -- 27911
	AddRecipe(27911, 325, nil, Q.COMMON, V.TBC, 325, 335, 350, 365)
	self:AddRecipeFlags(27911, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.HELLFIRE)
	self:AddRecipeRepVendor(27911, FAC.HONOR_HOLD, REP.FRIENDLY, 17657)
	self:AddRecipeRepVendor(27911, FAC.THRALLMAR, REP.FRIENDLY, 17585)

	-- Enchant Bracer - Restore Mana Prime -- 27913
	AddRecipe(27913, 335, nil, Q.UNCOMMON, V.TBC, 335, 345, 360, 375)
	self:AddRecipeFlags(27913, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(27913, "Outland")

	-- Enchant Bracer - Fortitude -- 27914
	AddRecipe(27914, 350, nil, Q.UNCOMMON, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(27914, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(27914, 17803)

	-- Enchant Bracer - Spellpower -- 27917
	AddRecipe(27917, 360, nil, Q.UNCOMMON, V.TBC, 360, 370, 385, 400)
	self:AddRecipeFlags(27917, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeMobDrop(27917, 19952)

	-- Enchant Ring - Striking -- 27920
	AddRecipe(27920, 360, nil, Q.COMMON, V.TBC, 360, 370, 377, 385)
	self:AddRecipeFlags(27920, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.RING, F.CONSORTIUM)
	self:AddRecipeRepVendor(27920, FAC.CONSORTIUM, REP.REVERED, 17518)

	-- Enchant Ring - Spellpower -- 27924
	AddRecipe(27924, 360, nil, Q.COMMON, V.TBC, 360, 370, 377, 385)
	self:AddRecipeFlags(27924, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING, F.KOT)
	self:AddRecipeRepVendor(27924, FAC.KEEPERS_OF_TIME, REP.HONORED, 21643)

	-- Enchant Ring - Healing Power -- 27926
	AddRecipe(27926, 370, nil, Q.COMMON, V.TBC, 370, 380, 385, 390)
	self:AddRecipeFlags(27926, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING, F.SHATAR)
	self:AddRecipeRepVendor(27926, FAC.SHATAR, REP.REVERED, 21432)

	-- Enchant Ring - Stats -- 27927
	AddRecipe(27927, 375, nil, Q.COMMON, V.TBC, 375, 380, 385, 390)
	self:AddRecipeFlags(27927, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.RING, F.LOWERCITY)
	self:AddRecipeRepVendor(27927, FAC.LOWERCITY, REP.HONORED, 21655)

	-- Enchant Shield - Tough Shield -- 27944
	AddRecipe(27944, 310, nil, Q.COMMON, V.TBC, 310, 320, 335, 350)
	self:AddRecipeFlags(27944, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.TANK, F.SHIELD)
	self:AddRecipeTrainer(27944, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Shield - Intellect -- 27945
	AddRecipe(27945, 325, nil, Q.COMMON, V.TBC, 325, 335, 350, 365)
	self:AddRecipeFlags(27945, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.SHIELD)
	self:AddRecipeVendor(27945, 18664)

	-- Enchant Shield - Shield Block -- 27946
	AddRecipe(27946, 340, nil, Q.UNCOMMON, V.TBC, 340, 350, 365, 380)
	self:AddRecipeFlags(27946, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.TANK, F.SHIELD)
	self:AddRecipeWorldDrop(27946, "Outland")

	-- Enchant Shield - Resistance -- 27947
	AddRecipe(27947, 360, nil, Q.UNCOMMON, V.TBC, 360, 370, 375, 380)
	self:AddRecipeFlags(27947, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.SHIELD)
	self:AddRecipeWorldDrop(27947, "Outland")

	-- Enchant Boots - Vitality -- 27948
	AddRecipe(27948, 305, nil, Q.UNCOMMON, V.TBC, 305, 315, 330, 345)
	self:AddRecipeFlags(27948, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeMobDrop(27948, 24664)

	-- Enchant Boots - Fortitude -- 27950
	AddRecipe(27950, 320, nil, Q.UNCOMMON, V.TBC, 320, 330, 345, 360)
	self:AddRecipeFlags(27950, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(27950, 18317)

	-- Enchant Boots - Dexterity -- 27951
	AddRecipe(27951, 340, nil, Q.UNCOMMON, V.TBC, 340, 350, 365, 380)
	self:AddRecipeFlags(27951, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeMobDrop(27951, 18521)

	-- Enchant Boots - Surefooted -- 27954
	AddRecipe(27954, 370, nil, Q.UNCOMMON, V.TBC, 370, 380, 385, 390)
	self:AddRecipeFlags(27954, F.ALLIANCE, F.HORDE, F.RAID, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS, F.CASTER)
	self:AddRecipeMobDrop(27954, 16472)

	-- Enchant Chest - Exceptional Health -- 27957
	AddRecipe(27957, 315, nil, Q.COMMON, V.TBC, 315, 325, 340, 355)
	self:AddRecipeFlags(27957, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(27957, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Chest - Exceptional Mana -- 27958
	AddRecipe(27958, 350, nil, Q.COMMON, V.WOTLK, 350, 360, 370, 380)
	self:AddRecipeFlags(27958, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(27958, 28693, 26980, 33583, 26954, 26906, 26990)

	-- Enchant Chest - Exceptional Stats -- 27960
	AddRecipe(27960, 345, nil, Q.COMMON, V.TBC, 345, 355, 367, 380)
	self:AddRecipeFlags(27960, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HELLFIRE)
	self:AddRecipeRepVendor(27960, FAC.HONOR_HOLD, REP.REVERED, 17657)
	self:AddRecipeRepVendor(27960, FAC.THRALLMAR, REP.REVERED, 17585)

	-- Enchant Cloak - Major Armor -- 27961
	AddRecipe(27961, 310, nil, Q.COMMON, V.TBC, 310, 320, 335, 350)
	self:AddRecipeFlags(27961, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeTrainer(27961, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Cloak - Major Resistance -- 27962
	AddRecipe(27962, 330, nil, Q.UNCOMMON, V.TBC, 330, 340, 355, 370)
	self:AddRecipeFlags(27962, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeWorldDrop(27962, "Outland")

	-- Enchant Weapon - Major Striking -- 27967
	AddRecipe(27967, 340, nil, Q.COMMON, V.TBC, 340, 350, 365, 380)
	self:AddRecipeFlags(27967, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ONE_HAND, F.TWO_HAND, F.CONSORTIUM)
	self:AddRecipeRepVendor(27967, FAC.CONSORTIUM, REP.HONORED, 20242, 23007)

	-- Enchant Weapon - Major Intellect -- 27968
	AddRecipe(27968, 340, nil, Q.UNCOMMON, V.TBC, 340, 350, 365, 380)
	self:AddRecipeFlags(27968, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.ONE_HAND, F.TWO_HAND, F.HEALER, F.CASTER)
	self:AddRecipeMobDrop(27968, 20136)

	-- Enchant 2H Weapon - Savagery -- 27971
	AddRecipe(27971, 350, nil, Q.UNCOMMON, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(27971, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS, F.TWO_HAND)
	self:AddRecipeMobDrop(27971, 17465)

	-- Enchant Weapon - Potency -- 27972
	AddRecipe(27972, 350, nil, Q.UNCOMMON, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(27972, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeWorldDrop(27972, "Outland")

	-- Enchant Weapon - Major Spellpower -- 27975
	AddRecipe(27975, 350, nil, Q.UNCOMMON, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(27975, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeMobDrop(27975, 22242)

	-- Enchant 2H Weapon - Major Agility -- 27977
	AddRecipe(27977, 360, nil, Q.UNCOMMON, V.TBC, 360, 370, 377, 385)
	self:AddRecipeFlags(27977, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS, F.TWO_HAND)
	self:AddRecipeMobDrop(27977, 20880)

	-- Enchant Weapon - Sunfire -- 27981
	AddRecipe(27981, 375, nil, Q.RARE, V.TBC, 375, 375, 375, 390)
	self:AddRecipeFlags(27981, F.ALLIANCE, F.HORDE, F.RAID, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeMobDrop(27981, 16524)

	-- Enchant Weapon - Soulfrost -- 27982
	AddRecipe(27982, 375, nil, Q.RARE, V.TBC, 375, 380, 385, 390)
	self:AddRecipeFlags(27982, F.ALLIANCE, F.HORDE, F.RAID, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeMobDrop(27982, 15688)

	-- Enchant Weapon - Mongoose -- 27984
	AddRecipe(27984, 375, nil, Q.RARE, V.TBC, 375, 380, 385, 390)
	self:AddRecipeFlags(27984, F.ALLIANCE, F.HORDE, F.RAID, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeMobDrop(27984, 15687)

	-- Enchant Weapon - Spellsurge -- 28003
	AddRecipe(28003, 360, nil, Q.UNCOMMON, V.TBC, 360, 370, 377, 385)
	self:AddRecipeFlags(28003, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeWorldDrop(28003, "Outland")

	-- Enchant Weapon - Battlemaster -- 28004
	AddRecipe(28004, 360, nil, Q.UNCOMMON, V.TBC, 360, 370, 377, 385)
	self:AddRecipeFlags(28004, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeWorldDrop(28004, "Outland")

	-- Superior Mana Oil -- 28016
	AddRecipe(28016, 310, 22521, Q.COMMON, V.TBC, 310, 310, 320, 330)
	self:AddRecipeFlags(28016, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(28016, 19663, 16722, 16635)

	-- Superior Wizard Oil -- 28019
	AddRecipe(28019, 340, 22522, Q.COMMON, V.TBC, 340, 340, 350, 360)
	self:AddRecipeFlags(28019, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeVendor(28019, 19663, 16722, 16635)

	-- Large Prismatic Shard -- 28022
	AddRecipe(28022, 335, 22449, Q.COMMON, V.TBC, 335, 335, 335, 335)
	self:AddRecipeFlags(28022, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(28022, 19663, 16722, 16635)

	-- Prismatic Sphere -- 28027
	AddRecipe(28027, 325, 22460, Q.COMMON, V.TBC, 325, 325, 330, 335)
	self:AddRecipeFlags(28027, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(28027, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Void Sphere -- 28028
	AddRecipe(28028, 350, 22459, Q.COMMON, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(28028, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(28028, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Runed Fel Iron Rod -- 32664
	AddRecipe(32664, 300, 22461, Q.COMMON, V.TBC, 300, 310, 325, 340)
	self:AddRecipeFlags(32664, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(32664, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Runed Adamantite Rod -- 32665
	AddRecipe(32665, 350, 22462, Q.COMMON, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(32665, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOE)
	self:AddRecipeVendor(32665, 18960, 19004)

	-- Runed Eternium Rod -- 32667
	AddRecipe(32667, 375, 22463, Q.COMMON, V.TBC, 375, 375, 377, 385)
	self:AddRecipeFlags(32667, F.ALLIANCE, F.HORDE, F.TRAINER, F.VENDOR, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(32667, 28693, 26980, 33583, 26954, 26906, 26990)
	self:AddRecipeVendor(32667, 19663)

	-- Enchant Chest - Major Spirit -- 33990
	AddRecipe(33990, 320, nil, Q.COMMON, V.TBC, 320, 330, 345, 360)
	self:AddRecipeFlags(33990, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(33990, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Chest - Restore Mana Prime -- 33991
	AddRecipe(33991, 300, nil, Q.COMMON, V.TBC, 300, 310, 325, 340)
	self:AddRecipeFlags(33991, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(33991, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Chest - Major Resilience -- 33992
	AddRecipe(33992, 345, nil, Q.UNCOMMON, V.TBC, 345, 355, 367, 380)
	self:AddRecipeFlags(33992, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(33992, "Outland")

	-- Enchant Gloves - Blasting -- 33993
	AddRecipe(33993, 305, nil, Q.COMMON, V.TBC, 305, 315, 330, 345)
	self:AddRecipeFlags(33993, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(33993, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Gloves - Precise Strikes -- 33994
	AddRecipe(33994, 360, nil, Q.UNCOMMON, V.TBC, 360, 370, 377, 385)
	self:AddRecipeFlags(33994, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(33994, FAC.CENARION_EXPEDITION, REP.REVERED, 17904)

	-- Enchant Gloves - Major Strength -- 33995
	AddRecipe(33995, 340, nil, Q.COMMON, V.TBC, 340, 350, 365, 380)
	self:AddRecipeFlags(33995, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(33995, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Gloves - Assault -- 33996
	AddRecipe(33996, 310, nil, Q.COMMON, V.TBC, 310, 320, 335, 350)
	self:AddRecipeFlags(33996, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(33996, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Gloves - Major Spellpower -- 33997
	AddRecipe(33997, 360, nil, Q.UNCOMMON, V.TBC, 360, 370, 377, 385)
	self:AddRecipeFlags(33997, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.KOT)
	self:AddRecipeRepVendor(33997, FAC.KEEPERS_OF_TIME, REP.HONORED, 21643)

	-- Enchant Gloves - Major Healing -- 33999
	AddRecipe(33999, 350, nil, Q.UNCOMMON, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(33999, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SHATAR)
	self:AddRecipeRepVendor(33999, FAC.SHATAR, REP.HONORED, 21432)

	-- Enchant Bracer - Major Intellect -- 34001
	AddRecipe(34001, 305, nil, Q.COMMON, V.TBC, 305, 315, 330, 345)
	self:AddRecipeFlags(34001, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(34001, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Bracer - Assault -- 34002
	AddRecipe(34002, 300, nil, Q.COMMON, V.TBC, 300, 310, 325, 340)
	self:AddRecipeFlags(34002, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(34002, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Cloak - Spell Penetration -- 34003
	AddRecipe(34003, 325, nil, Q.UNCOMMON, V.TBC, 325, 335, 350, 365)
	self:AddRecipeFlags(34003, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CASTER, F.CLOAK, F.CONSORTIUM)
	self:AddRecipeRepVendor(34003, FAC.CONSORTIUM, REP.FRIENDLY, 20242, 23007)

	-- Enchant Cloak - Greater Agility -- 34004
	AddRecipe(34004, 310, nil, Q.COMMON, V.TBC, 310, 320, 335, 350)
	self:AddRecipeFlags(34004, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS, F.CLOAK)
	self:AddRecipeTrainer(34004, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Cloak - Greater Arcane Resistance -- 34005
	AddRecipe(34005, 350, nil, Q.RARE, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(34005, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.CLOAK)
	self:AddRecipeMobDrop(34005, 19796)

	-- Enchant Cloak - Greater Shadow Resistance -- 34006
	AddRecipe(34006, 350, nil, Q.RARE, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(34006, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.CLOAK)
	self:AddRecipeMobDrop(34006, 18870)

	-- Enchant Boots - Cat's Swiftness -- 34007
	AddRecipe(34007, 360, nil, Q.RARE, V.TBC, 360, 370, 377, 385)
	self:AddRecipeFlags(34007, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeMobDrop(34007, 24664)

	-- Enchant Boots - Boar's Speed -- 34008
	AddRecipe(34008, 360, nil, Q.RARE, V.TBC, 360, 370, 377, 385)
	self:AddRecipeFlags(34008, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(34008, 24664)

	-- Enchant Shield - Major Stamina -- 34009
	AddRecipe(34009, 325, nil, Q.COMMON, V.TBC, 325, 335, 350, 365)
	self:AddRecipeFlags(34009, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.SHIELD)
	self:AddRecipeVendor(34009, 19663)

	-- Enchant Weapon - Major Healing -- 34010
	AddRecipe(34010, 350, nil, Q.UNCOMMON, V.TBC, 350, 370, 375, 380)
	self:AddRecipeFlags(34010, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND, F.SHATAR)
	self:AddRecipeRepVendor(34010, FAC.SHATAR, REP.REVERED, 21432)

	-- Nexus Transformation -- 42613
	AddRecipe(42613, 300, 22448, Q.COMMON, V.TBC, 300, 300, 300, 305)
	self:AddRecipeFlags(42613, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(42613, 18773, 18753, 19252, 33676, 33610, 19540)

	-- Small Prismatic Shard -- 42615
	AddRecipe(42615, 335, 22448, Q.COMMON, V.TBC, 335, 335, 335, 335)
	self:AddRecipeFlags(42615, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(42615, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Weapon - Greater Agility -- 42620
	AddRecipe(42620, 350, nil, Q.COMMON, V.TBC, 350, 360, 367, 375)
	self:AddRecipeFlags(42620, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.ONE_HAND, F.TWO_HAND, F.VIOLETEYE)
	self:AddRecipeRepVendor(42620, FAC.VIOLETEYE, REP.EXALTED, 18255)

	-- Enchant Weapon - Executioner -- 42974
	AddRecipe(42974, 375, 33307, Q.RARE, V.TBC, 375, 380, 385, 390)
	self:AddRecipeFlags(42974, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.DPS, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeAcquire(42974, A.CUSTOM, 29)

	-- Enchant Shield - Resilience -- 44383
	AddRecipe(44383, 330, nil, Q.COMMON, V.TBC, 330, 340, 355, 370)
	self:AddRecipeFlags(44383, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.SHIELD)
	self:AddRecipeTrainer(44383, 18773, 18753, 19252, 19540, 33610, 33676)

	-- Enchant Cloak - Superior Frost Resistance -- 44483
	AddRecipe(44483, 400, nil, Q.UNCOMMON, V.WOTLK, 400, 415, 425, 435)
	self:AddRecipeFlags(44483, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeMobDrop(44483, 32289)

	-- Enchant Gloves - Expertise -- 44484
	AddRecipe(44484, 405, nil, Q.COMMON, V.WOTLK, 405, 415, 425, 435)
	self:AddRecipeFlags(44484, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeTrainer(44484, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Gloves - Precision -- 44488
	AddRecipe(44488, 410, nil, Q.COMMON, V.WOTLK, 410, 420, 430, 440)
	self:AddRecipeFlags(44488, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44488, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Shield - Defense -- 44489
	AddRecipe(44489, 420, nil, Q.COMMON, V.WOTLK, 420, 430, 440, 450)
	self:AddRecipeFlags(44489, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK, F.SHIELD)
	self:AddRecipeTrainer(44489, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Chest - Mighty Health -- 44492
	AddRecipe(44492, 395, nil, Q.COMMON, V.WOTLK, 395, 405, 415, 425)
	self:AddRecipeFlags(44492, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44492, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Cloak - Superior Nature Resistance -- 44494
	AddRecipe(44494, 400, nil, Q.UNCOMMON, V.WOTLK, 400, 415, 425, 435)
	self:AddRecipeFlags(44494, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeMobDrop(44494, 32290)

	-- Enchant Cloak - Superior Agility -- 44500
	AddRecipe(44500, 395, nil, Q.COMMON, V.WOTLK, 395, 405, 415, 425)
	self:AddRecipeFlags(44500, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.CLOAK)
	self:AddRecipeTrainer(44500, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Gloves - Gatherer -- 44506
	AddRecipe(44506, 375, nil, Q.COMMON, V.WOTLK, 375, 375, 380, 390)
	self:AddRecipeFlags(44506, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44506, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Boots - Greater Spirit -- 44508
	AddRecipe(44508, 410, nil, Q.COMMON, V.WOTLK, 410, 420, 430, 440)
	self:AddRecipeFlags(44508, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(44508, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Chest - Greater Mana Restoration -- 44509
	AddRecipe(44509, 420, nil, Q.COMMON, V.WOTLK, 420, 430, 440, 450)
	self:AddRecipeFlags(44509, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(44509, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Weapon - Exceptional Spirit -- 44510
	AddRecipe(44510, 410, nil, Q.COMMON, V.WOTLK, 410, 420, 430, 440)
	self:AddRecipeFlags(44510, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeTrainer(44510, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Gloves - Greater Assault -- 44513
	AddRecipe(44513, 395, nil, Q.COMMON, V.WOTLK, 395, 405, 415, 425)
	self:AddRecipeFlags(44513, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(44513, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Weapon - Icebreaker -- 44524
	AddRecipe(44524, 425, nil, Q.RARE, V.WOTLK, 425, 435, 445, 455)
	self:AddRecipeFlags(44524, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeVendor(44524, 32514)

	-- Enchant Boots - Greater Fortitude -- 44528
	AddRecipe(44528, 385, nil, Q.COMMON, V.WOTLK, 385, 385, 390, 400)
	self:AddRecipeFlags(44528, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44528, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Gloves - Major Agility -- 44529
	AddRecipe(44529, 415, nil, Q.COMMON, V.WOTLK, 415, 425, 435, 445)
	self:AddRecipeFlags(44529, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(44529, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Bracers - Exceptional Intellect -- 44555
	AddRecipe(44555, 375, nil, Q.COMMON, V.WOTLK, 375, 385, 392, 400)
	self:AddRecipeFlags(44555, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44555, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Cloak - Superior Fire Resistance -- 44556
	AddRecipe(44556, 400, nil, Q.UNCOMMON, V.WOTLK, 400, 415, 425, 435)
	self:AddRecipeFlags(44556, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeMobDrop(44556, 30921)

	-- Enchant Bracers - Greater Assault -- 44575
	AddRecipe(44575, 430, nil, Q.UNCOMMON, V.WOTLK, 430, 440, 450, 460)
	self:AddRecipeFlags(44575, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(44575, 32514)

	-- Enchant Weapon - Lifeward -- 44576
	AddRecipe(44576, 425, nil, Q.RARE, V.WOTLK, 425, 435, 445, 455)
	self:AddRecipeFlags(44576, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeVendor(44576, 32514)

	-- Enchant Cloak - Spell Piercing -- 44582
	AddRecipe(44582, 395, nil, Q.COMMON, V.WOTLK, 395, 395, 402, 410)
	self:AddRecipeFlags(44582, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.CASTER, F.CLOAK)
	self:AddRecipeTrainer(44582, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Boots - Greater Vitality -- 44584
	AddRecipe(44584, 405, nil, Q.COMMON, V.WOTLK, 405, 415, 425, 435)
	self:AddRecipeFlags(44584, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44584, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Chest - Exceptional Resilience -- 44588
	AddRecipe(44588, 410, nil, Q.UNCOMMON, V.WOTLK, 410, 435, 445, 455)
	self:AddRecipeFlags(44588, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(44588, 32514)

	-- Enchant Boots - Superior Agility -- 44589
	AddRecipe(44589, 415, nil, Q.COMMON, V.WOTLK, 415, 425, 435, 445)
	self:AddRecipeFlags(44589, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(44589, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Cloak - Superior Shadow Resistance -- 44590
	AddRecipe(44590, 400, nil, Q.UNCOMMON, V.WOTLK, 400, 415, 425, 435)
	self:AddRecipeFlags(44590, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeMobDrop(44590, 32349)

	-- Enchant Cloak - Titanweave -- 44591
	AddRecipe(44591, 435, nil, Q.UNCOMMON, V.WOTLK, 435, 445, 455, 465)
	self:AddRecipeFlags(44591, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.CLOAK)
	self:AddRecipeVendor(44591, 32514)

	-- Enchant Gloves - Exceptional Spellpower -- 44592
	AddRecipe(44592, 360, nil, Q.COMMON, V.WOTLK, 360, 370, 380, 390)
	self:AddRecipeFlags(44592, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(44592, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Bracers - Major Spirit -- 44593
	AddRecipe(44593, 420, nil, Q.COMMON, V.WOTLK, 420, 430, 440, 450)
	self:AddRecipeFlags(44593, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(44593, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant 2H Weapon - Scourgebane -- 44595
	AddRecipe(44595, 430, 44473, Q.RARE, V.WOTLK, 430, 440, 450, 460)
	self:AddRecipeFlags(44595, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeVendor(44595, 32514)

	-- Enchant Cloak - Superior Arcane Resistance -- 44596
	AddRecipe(44596, 400, nil, Q.UNCOMMON, V.WOTLK, 400, 415, 425, 435)
	self:AddRecipeFlags(44596, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeMobDrop(44596, 31702, 32297)

	-- Enchant Bracers - Expertise -- 44598
	AddRecipe(44598, 415, nil, Q.COMMON, V.WOTLK, 415, 425, 435, 445)
	self:AddRecipeFlags(44598, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeTrainer(44598, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Bracers - Greater Stats -- 44616
	AddRecipe(44616, 400, nil, Q.COMMON, V.WOTLK, 400, 410, 420, 430)
	self:AddRecipeFlags(44616, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44616, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Weapon - Giant Slayer -- 44621
	AddRecipe(44621, 430, nil, Q.RARE, V.WOTLK, 430, 440, 450, 460)
	self:AddRecipeFlags(44621, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeVendor(44621, 32514)

	-- Enchant Chest - Super Stats -- 44623
	AddRecipe(44623, 370, nil, Q.COMMON, V.WOTLK, 370, 380, 390, 400)
	self:AddRecipeFlags(44623, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44623, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Gloves - Armsman -- 44625
	AddRecipe(44625, 435, nil, Q.UNCOMMON, V.WOTLK, 435, 445, 455, 465)
	self:AddRecipeFlags(44625, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(44625, 32514)

	-- Enchant Weapon - Exceptional Spellpower -- 44629
	AddRecipe(44629, 395, nil, Q.COMMON, V.WOTLK, 395, 405, 415, 425)
	self:AddRecipeFlags(44629, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeTrainer(44629, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant 2H Weapon - Greater Savagery -- 44630
	AddRecipe(44630, 390, nil, Q.COMMON, V.WOTLK, 390, 400, 410, 420)
	self:AddRecipeFlags(44630, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.TWO_HAND)
	self:AddRecipeTrainer(44630, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Cloak - Shadow Armor -- 44631
	AddRecipe(44631, 440, nil, Q.UNCOMMON, V.WOTLK, 440, 450, 460, 470)
	self:AddRecipeFlags(44631, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.CLOAK)
	self:AddRecipeVendor(44631, 32514)

	-- Enchant Weapon - Exceptional Agility -- 44633
	AddRecipe(44633, 410, nil, Q.COMMON, V.WOTLK, 410, 420, 430, 440)
	self:AddRecipeFlags(44633, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeTrainer(44633, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Bracers - Greater Spellpower -- 44635
	AddRecipe(44635, 395, nil, Q.COMMON, V.WOTLK, 395, 405, 415, 425)
	self:AddRecipeFlags(44635, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(44635, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Ring - Greater Spellpower -- 44636
	AddRecipe(44636, 400, nil, Q.COMMON, V.WOTLK, 400, 400, 407, 415)
	self:AddRecipeFlags(44636, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(44636, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Ring - Assault -- 44645
	AddRecipe(44645, 400, nil, Q.COMMON, V.WOTLK, 400, 400, 407, 415)
	self:AddRecipeFlags(44645, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(44645, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Void Shatter -- 45765
	AddRecipe(45765, 375, 22449, Q.COMMON, V.TBC, 375, 375, 375, 375)
	self:AddRecipeFlags(45765, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(45765, FAC.SHATTEREDSUN, REP.HONORED, 25032)

	-- Enchant Weapon - Deathfrost -- 46578
	AddRecipe(46578, 350, 35498, Q.RARE, V.TBC, 350, 350, 357, 365)
	self:AddRecipeFlags(46578, F.ALLIANCE, F.HORDE, F.SEASONAL, F.IBOE, F.RBOP, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeAcquire(46578, A.SEASONAL, 4)

	-- Enchant Chest - Defense -- 46594
	AddRecipe(46594, 360, nil, Q.COMMON, V.WOTLK, 360, 370, 385, 400)
	self:AddRecipeFlags(46594, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46594, FAC.SHATTEREDSUN, REP.HONORED, 25032)

	-- Enchant Cloak - Steelweave -- 47051
	AddRecipe(47051, 375, nil, Q.RARE, V.TBC, 375, 380, 385, 390)
	self:AddRecipeFlags(47051, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.TANK, F.CLOAK)
	self:AddRecipeMobDrop(47051, 24560)

	-- Enchant Cloak - Mighty Armor -- 47672
	AddRecipe(47672, 430, nil, Q.UNCOMMON, V.WOTLK, 430, 440, 450, 460)
	self:AddRecipeFlags(47672, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CLOAK)
	self:AddRecipeVendor(47672, 32514)

	-- Enchant Chest - Greater Defense -- 47766
	AddRecipe(47766, 400, nil, Q.COMMON, V.WOTLK, 400, 410, 420, 430)
	self:AddRecipeFlags(47766, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeTrainer(47766, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Cloak - Greater Speed -- 47898
	AddRecipe(47898, 430, nil, Q.UNCOMMON, V.WOTLK, 430, 440, 450, 460)
	self:AddRecipeFlags(47898, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CLOAK)
	self:AddRecipeVendor(47898, 32514)

	-- Enchant Cloak - Wisdom -- 47899
	AddRecipe(47899, 440, nil, Q.UNCOMMON, V.WOTLK, 440, 450, 460, 470)
	self:AddRecipeFlags(47899, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CLOAK)
	self:AddRecipeVendor(47899, 32514)

	-- Enchant Chest - Super Health -- 47900
	AddRecipe(47900, 425, nil, Q.COMMON, V.WOTLK, 425, 435, 445, 455)
	self:AddRecipeFlags(47900, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(47900, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Boots - Tuskarr's Vitality -- 47901
	AddRecipe(47901, 440, nil, Q.UNCOMMON, V.WOTLK, 440, 450, 460, 470)
	self:AddRecipeFlags(47901, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(47901, 32514)

	-- Enchant Weapon - Accuracy -- 59619
	AddRecipe(59619, 440, nil, Q.RARE, V.WOTLK, 440, 450, 460, 470)
	self:AddRecipeFlags(59619, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeVendor(59619, 32514)

	-- Enchant Weapon - Berserking -- 59621
	AddRecipe(59621, 440, nil, Q.RARE, V.WOTLK, 440, 450, 460, 470)
	self:AddRecipeFlags(59621, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeVendor(59621, 32514)

	-- Enchant Weapon - Black Magic -- 59625
	AddRecipe(59625, 440, nil, Q.RARE, V.WOTLK, 440, 450, 460, 470)
	self:AddRecipeFlags(59625, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeVendor(59625, 32514)

	-- Enchant Ring - Stamina -- 59636
	AddRecipe(59636, 400, nil, Q.COMMON, V.WOTLK, 400, 400, 407, 415)
	self:AddRecipeFlags(59636, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(59636, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Boots - Assault -- 60606
	AddRecipe(60606, 375, nil, Q.COMMON, V.WOTLK, 375, 385, 395, 405)
	self:AddRecipeFlags(60606, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(60606, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Cloak - Speed -- 60609
	AddRecipe(60609, 350, nil, Q.COMMON, V.WOTLK, 350, 360, 370, 380)
	self:AddRecipeFlags(60609, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.CLOAK)
	self:AddRecipeTrainer(60609, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Bracers - Striking -- 60616
	AddRecipe(60616, 360, nil, Q.COMMON, V.WOTLK, 360, 370, 380, 390)
	self:AddRecipeFlags(60616, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(60616, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Runed Titanium Rod -- 60619
	AddRecipe(60619, 425, 44452, Q.COMMON, V.WOTLK, 425, 435, 445, 455)
	self:AddRecipeFlags(60619, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(60619, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Weapon - Greater Potency -- 60621
	AddRecipe(60621, 380, nil, Q.COMMON, V.WOTLK, 380, 390, 400, 410)
	self:AddRecipeFlags(60621, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeTrainer(60621, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Boots - Icewalker -- 60623
	AddRecipe(60623, 385, nil, Q.COMMON, V.WOTLK, 385, 395, 405, 415)
	self:AddRecipeFlags(60623, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(60623, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Shield - Greater Intellect -- 60653
	AddRecipe(60653, 395, nil, Q.COMMON, V.WOTLK, 395, 405, 415, 425)
	self:AddRecipeFlags(60653, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.SHIELD)
	self:AddRecipeTrainer(60653, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Cloak - Major Agility -- 60663
	AddRecipe(60663, 420, nil, Q.COMMON, V.WOTLK, 420, 430, 440, 450)
	self:AddRecipeFlags(60663, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.CLOAK)
	self:AddRecipeTrainer(60663, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Gloves - Crusher -- 60668
	AddRecipe(60668, 425, nil, Q.COMMON, V.WOTLK, 425, 435, 445, 455)
	self:AddRecipeFlags(60668, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(60668, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant 2H Weapon - Massacre -- 60691
	AddRecipe(60691, 430, nil, Q.RARE, V.WOTLK, 430, 440, 450, 460)
	self:AddRecipeFlags(60691, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TWO_HAND)
	self:AddRecipeVendor(60691, 32514)

	-- Enchant Chest - Powerful Stats -- 60692
	AddRecipe(60692, 440, nil, Q.UNCOMMON, V.WOTLK, 440, 450, 460, 470)
	self:AddRecipeFlags(60692, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(60692, 32514)

	-- Enchant Weapon - Superior Potency -- 60707
	AddRecipe(60707, 435, nil, Q.RARE, V.WOTLK, 435, 445, 455, 465)
	self:AddRecipeFlags(60707, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeVendor(60707, 32514)

	-- Enchant Weapon - Mighty Spellpower -- 60714
	AddRecipe(60714, 435, nil, Q.RARE, V.WOTLK, 435, 445, 455, 465)
	self:AddRecipeFlags(60714, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeVendor(60714, 32514)

	-- Enchant Boots - Greater Assault -- 60763
	AddRecipe(60763, 440, nil, Q.UNCOMMON, V.WOTLK, 440, 450, 460, 470)
	self:AddRecipeFlags(60763, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(60763, 32514)

	-- Enchant Bracers - Superior Spellpower -- 60767
	AddRecipe(60767, 440, 44498, Q.UNCOMMON, V.WOTLK, 440, 450, 460, 470)
	self:AddRecipeFlags(60767, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(60767, 32514)

	-- Enchant Bracers - Major Stamina -- 62256
	AddRecipe(62256, 450, 44944, Q.RARE, V.WOTLK, 450, 460, 470, 480)
	self:AddRecipeFlags(62256, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(62256, 32514)

	-- Enchant Staff - Greater Spellpower -- 62948
	AddRecipe(62948, 450, nil, Q.RARE, V.WOTLK, 450, 455, 460, 465)
	self:AddRecipeFlags(62948, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.STAFF)
	self:AddRecipeVendor(62948, 32514)

	-- Enchant Staff - Spellpower -- 62959
	AddRecipe(62959, 385, nil, Q.COMMON, V.WOTLK, 385, 395, 405, 415)
	self:AddRecipeFlags(62959, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.STAFF)
	self:AddRecipeTrainer(62959, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Boots - Lesser Accuracy -- 63746
	AddRecipe(63746, 225, nil, Q.COMMON, V.WOTLK, 225, 245, 265, 285)
	self:AddRecipeFlags(63746, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(63746, 3606, 19540, 11072, 5695, 18753, 11074, 5157, 19251, 16725, 19252, 16633, 18773, 16160, 4616, 11073, 33676, 4213, 3345, 3011, 33610, 7949, 1317)

	-- Enchant Weapon - Blade Ward -- 64441
	AddRecipe(64441, 450, nil, Q.EPIC, V.WOTLK, 450, 455, 460, 465)
	self:AddRecipeFlags(64441, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.TANK, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeAcquire(64441, A.CUSTOM, 39)

	-- Enchant Weapon - Blood Draining -- 64579
	AddRecipe(64579, 450, nil, Q.EPIC, V.WOTLK, 450, 455, 460, 465)
	self:AddRecipeFlags(64579, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.ONE_HAND, F.TWO_HAND)
	self:AddRecipeAcquire(64579, A.CUSTOM, 39)

	-- Abyssal Shatter -- 69412
	AddRecipe(69412, 445, 49640, Q.COMMON, V.WOTLK, 445, 445, 447, 450)
	self:AddRecipeFlags(69412, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(69412, 28693, 33583, 26990, 26954, 26906, 26980)

	-- Enchant Gloves - Angler -- 71692
	AddRecipe(71692, 375, nil, Q.UNCOMMON, V.WOTLK, 375, 385, 392, 400)
	self:AddRecipeFlags(71692, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOP, F.RBOP)
	self:AddRecipeMobDrop(71692, 26343, 26336, 26344)

	return num_recipes
end
