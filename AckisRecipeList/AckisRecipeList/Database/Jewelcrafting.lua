--[[
************************************************************************
Jewelcrafting.lua
Jewelcrafting data for all of Ackis Recipe List
************************************************************************
File date: 2010-09-06T14:12:03Z
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
	addon:AddRecipe(spell_id, skill_level, item_id, quality, 25229, nil, genesis, optimal_level, medium_level, easy_level, trivial_level)
end

function addon:InitJewelcrafting()
	if initialized then
		return num_recipes
	end
	initialized = true

	-- Delicate Copper Wire -- 25255
	AddRecipe(25255, 1, 20816, Q.COMMON, V.TBC, 1, 20, 35, 50)
	self:AddRecipeFlags(25255, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(25255, A.CUSTOM, 8)

	-- Bronze Setting -- 25278
	AddRecipe(25278, 50, 20817, Q.COMMON, V.TBC, 50, 70, 80, 90)
	self:AddRecipeFlags(25278, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(25278, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Elegant Silver Ring -- 25280
	AddRecipe(25280, 50, 20818, Q.COMMON, V.TBC, 50, 80, 95, 110)
	self:AddRecipeFlags(25280, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(25280, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Inlaid Malachite Ring -- 25283
	AddRecipe(25283, 30, 20821, Q.COMMON, V.TBC, 30, 60, 75, 90)
	self:AddRecipeFlags(25283, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(25283, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Simple Pearl Ring -- 25284
	AddRecipe(25284, 60, 20820, Q.COMMON, V.TBC, 60, 90, 105, 120)
	self:AddRecipeFlags(25284, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(25284, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Gloom Band -- 25287
	AddRecipe(25287, 70, 20823, Q.COMMON, V.TBC, 70, 100, 115, 130)
	self:AddRecipeFlags(25287, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(25287, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Heavy Silver Ring -- 25305
	AddRecipe(25305, 90, 20826, Q.COMMON, V.TBC, 90, 120, 135, 150)
	self:AddRecipeFlags(25305, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(25305, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Ring of Silver Might -- 25317
	AddRecipe(25317, 80, 20827, Q.COMMON, V.TBC, 80, 110, 125, 140)
	self:AddRecipeFlags(25317, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(25317, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Ring of Twilight Shadows -- 25318
	AddRecipe(25318, 100, 20828, Q.COMMON, V.TBC, 100, 130, 145, 160)
	self:AddRecipeFlags(25318, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(25318, 33614, 18774, 28701, 15501, 19775, 19778, 26982, 18751, 26960, 19539, 19063, 26997, 33680, 33590)

	-- Heavy Golden Necklace of Battle -- 25320
	AddRecipe(25320, 150, 20856, Q.COMMON, V.TBC, 150, 180, 195, 210)
	self:AddRecipeFlags(25320, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.NECK)
	self:AddRecipeLimitedVendor(25320, 17512, 1, 16624, 1, 3367, 1, 1286, 1)

	-- Moonsoul Crown -- 25321
	AddRecipe(25321, 120, 20832, Q.COMMON, V.TBC, 120, 150, 165, 180)
	self:AddRecipeFlags(25321, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CLOTH)
	self:AddRecipeTrainer(25321, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Wicked Moonstone Ring -- 25323
	AddRecipe(25323, 125, 20833, Q.COMMON, V.TBC, 125, 155, 170, 185)
	self:AddRecipeFlags(25323, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeLimitedVendor(25323, 3499, 1, 3954, 1)

	-- Amulet of the Moon -- 25339
	AddRecipe(25339, 110, 20830, Q.COMMON, V.TBC, 110, 140, 155, 170)
	self:AddRecipeFlags(25339, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeLimitedVendor(25339, 16624, 1, 4561, 1, 4229, 1, 17512, 1)

	-- Solid Bronze Ring -- 25490
	AddRecipe(25490, 50, 20907, Q.COMMON, V.TBC, 50, 80, 95, 110)
	self:AddRecipeFlags(25490, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(25490, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Braided Copper Ring -- 25493
	AddRecipe(25493, 1, 20906, Q.COMMON, V.TBC, 1, 30, 45, 60)
	self:AddRecipeFlags(25493, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeAcquire(25493, A.CUSTOM, 8)

	-- Barbaric Iron Collar -- 25498
	AddRecipe(25498, 110, 20909, Q.COMMON, V.TBC, 110, 140, 155, 170)
	self:AddRecipeFlags(25498, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.NECK)
	self:AddRecipeTrainer(25498, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Pendant of the Agate Shield -- 25610
	AddRecipe(25610, 120, 20950, Q.COMMON, V.TBC, 120, 150, 165, 180)
	self:AddRecipeFlags(25610, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.TANK, F.NECK)
	self:AddRecipeVendor(25610, 1448, 4877)

	-- Heavy Iron Knuckles -- 25612
	AddRecipe(25612, 125, 20954, Q.COMMON, V.TBC, 125, 155, 170, 185)
	self:AddRecipeFlags(25612, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.ONE_HAND, F.FIST)
	self:AddRecipeLimitedVendor(25612, 2381, 1, 2393, 1)

	-- Golden Dragon Ring -- 25613
	AddRecipe(25613, 135, 20955, Q.COMMON, V.TBC, 135, 165, 180, 195)
	self:AddRecipeFlags(25613, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK, F.RING)
	self:AddRecipeTrainer(25613, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Mithril Filigree -- 25615
	AddRecipe(25615, 150, 20963, Q.COMMON, V.TBC, 150, 170, 180, 190)
	self:AddRecipeFlags(25615, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(25615, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Blazing Citrine Ring -- 25617
	AddRecipe(25617, 150, 20958, Q.COMMON, V.TBC, 150, 180, 195, 210)
	self:AddRecipeFlags(25617, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeLimitedVendor(25617, 2381, 1, 9636, 1)

	-- Jade Pendant of Blasting -- 25618
	AddRecipe(25618, 160, 20966, Q.UNCOMMON, V.TBC, 160, 190, 205, 220)
	self:AddRecipeFlags(25618, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeWorldDrop(25618, "Kalimdor", "Eastern Kingdoms")

	-- The Jade Eye -- 25619
	AddRecipe(25619, 170, 20959, Q.COMMON, V.TBC, 170, 200, 215, 230)
	self:AddRecipeFlags(25619, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.TANK, F.RING)
	self:AddRecipeLimitedVendor(25619, 17512, 1, 16624, 1, 4775, 1, 5163, 1)

	-- Engraved Truesilver Ring -- 25620
	AddRecipe(25620, 170, 20960, Q.COMMON, V.TBC, 170, 200, 215, 230)
	self:AddRecipeFlags(25620, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(25620, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Citrine Ring of Rapid Healing -- 25621
	AddRecipe(25621, 180, 20961, Q.COMMON, V.TBC, 180, 210, 225, 240)
	self:AddRecipeFlags(25621, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(25621, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Citrine Pendant of Golden Healing -- 25622
	AddRecipe(25622, 190, 20967, Q.UNCOMMON, V.TBC, 190, 220, 235, 250)
	self:AddRecipeFlags(25622, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeWorldDrop(25622, "Kalimdor", "Eastern Kingdoms")

	-- Figurine - Jade Owl -- 26872
	AddRecipe(26872, 200, 21748, Q.COMMON, V.TBC, 200, 225, 240, 255)
	self:AddRecipeFlags(26872, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET)
	self:AddRecipeTrainer(26872, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Figurine - Golden Hare -- 26873
	AddRecipe(26873, 200, 21756, Q.UNCOMMON, V.TBC, 200, 225, 240, 255)
	self:AddRecipeFlags(26873, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOP, F.RBOE, F.TRINKET)
	self:AddRecipeWorldDrop(26873, "Kalimdor", "Eastern Kingdoms")

	-- Aquamarine Signet -- 26874
	AddRecipe(26874, 210, 20964, Q.COMMON, V.TBC, 210, 235, 250, 265)
	self:AddRecipeFlags(26874, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(26874, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Figurine - Black Pearl Panther -- 26875
	AddRecipe(26875, 215, 21758, Q.COMMON, V.TBC, 215, 240, 255, 270)
	self:AddRecipeFlags(26875, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOE, F.DPS, F.TRINKET)
	self:AddRecipeVendor(26875, 989, 4897)

	-- Aquamarine Pendant of the Warrior -- 26876
	AddRecipe(26876, 220, 21755, Q.COMMON, V.TBC, 220, 245, 260, 275)
	self:AddRecipeFlags(26876, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.NECK)
	self:AddRecipeTrainer(26876, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Ruby Crown of Restoration -- 26878
	AddRecipe(26878, 225, 20969, Q.COMMON, V.TBC, 225, 250, 265, 280)
	self:AddRecipeFlags(26878, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.CLOTH)
	self:AddRecipeLimitedVendor(26878, 2810, 1, 2821, 1)

	-- Thorium Setting -- 26880
	AddRecipe(26880, 225, 21752, Q.COMMON, V.TBC, 225, 235, 245, 255)
	self:AddRecipeFlags(26880, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(26880, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Figurine - Truesilver Crab -- 26881
	AddRecipe(26881, 225, 21760, Q.COMMON, V.TBC, 225, 250, 265, 280)
	self:AddRecipeFlags(26881, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOE, F.TANK, F.TRINKET)
	self:AddRecipeLimitedVendor(26881, 1148, 1, 4897, 1)

	-- Figurine - Truesilver Boar -- 26882
	AddRecipe(26882, 235, 21763, Q.UNCOMMON, V.TBC, 235, 260, 275, 290)
	self:AddRecipeFlags(26882, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOP, F.RBOE, F.DPS, F.TRINKET)
	self:AddRecipeWorldDrop(26882, "Kalimdor", "Eastern Kingdoms")

	-- Ruby Pendant of Fire -- 26883
	AddRecipe(26883, 235, 21764, Q.COMMON, V.TBC, 235, 260, 275, 290)
	self:AddRecipeFlags(26883, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeTrainer(26883, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Truesilver Healing Ring -- 26885
	AddRecipe(26885, 240, 21765, Q.COMMON, V.TBC, 240, 265, 280, 295)
	self:AddRecipeFlags(26885, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(26885, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- The Aquamarine Ward -- 26887
	AddRecipe(26887, 245, 21754, Q.UNCOMMON, V.TBC, 245, 270, 285, 300)
	self:AddRecipeFlags(26887, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.TANK, F.RING)
	self:AddRecipeWorldDrop(26887, "Kalimdor", "Eastern Kingdoms")

	-- Gem Studded Band -- 26896
	AddRecipe(26896, 250, 21753, Q.UNCOMMON, V.TBC, 250, 275, 290, 305)
	self:AddRecipeFlags(26896, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeWorldDrop(26896, "Kalimdor", "Eastern Kingdoms")

	-- Opal Necklace of Impact -- 26897
	AddRecipe(26897, 250, 21766, Q.COMMON, V.TBC, 250, 275, 290, 305)
	self:AddRecipeFlags(26897, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.NECK)
	self:AddRecipeLimitedVendor(26897, 17512, 1, 5163, 1, 16624, 1, 8363, 1)

	-- Figurine - Ruby Serpent -- 26900
	AddRecipe(26900, 260, 21769, Q.UNCOMMON, V.TBC, 260, 280, 290, 300)
	self:AddRecipeFlags(26900, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOP, F.RBOE, F.HEALER, F.CASTER, F.TRINKET)
	self:AddRecipeWorldDrop(26900, "Kalimdor", "Eastern Kingdoms")

	-- Simple Opal Ring -- 26902
	AddRecipe(26902, 260, 21767, Q.COMMON, V.TBC, 260, 280, 290, 300)
	self:AddRecipeFlags(26902, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(26902, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Sapphire Signet -- 26903
	AddRecipe(26903, 275, 21768, Q.COMMON, V.TBC, 275, 285, 295, 305)
	self:AddRecipeFlags(26903, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(26903, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Emerald Crown of Destruction -- 26906
	AddRecipe(26906, 275, 21774, Q.COMMON, V.TBC, 275, 285, 295, 305)
	self:AddRecipeFlags(26906, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.CLOTH)
	self:AddRecipeLimitedVendor(26906, 15179, 1)

	-- Onslaught Ring -- 26907
	AddRecipe(26907, 280, 21775, Q.COMMON, V.TBC, 280, 290, 300, 310)
	self:AddRecipeFlags(26907, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(26907, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Sapphire Pendant of Winter Night -- 26908
	AddRecipe(26908, 280, 21790, Q.COMMON, V.TBC, 280, 290, 300, 310)
	self:AddRecipeFlags(26908, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeTrainer(26908, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Figurine - Emerald Owl -- 26909
	AddRecipe(26909, 285, 21777, Q.UNCOMMON, V.TBC, 285, 295, 305, 315)
	self:AddRecipeFlags(26909, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOP, F.RBOE, F.HEALER, F.CASTER, F.TRINKET)
	self:AddRecipeWorldDrop(26909, "Kalimdor", "Eastern Kingdoms")

	-- Ring of Bitter Shadows -- 26910
	AddRecipe(26910, 285, 21778, Q.COMMON, V.TBC, 285, 295, 305, 315)
	self:AddRecipeFlags(26910, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeVendor(26910, 12941)

	-- Living Emerald Pendant -- 26911
	AddRecipe(26911, 290, 21791, Q.COMMON, V.TBC, 290, 300, 310, 320)
	self:AddRecipeFlags(26911, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeTrainer(26911, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Figurine - Black Diamond Crab -- 26912
	AddRecipe(26912, 300, 21784, Q.UNCOMMON, V.TBC, 300, 310, 320, 330)
	self:AddRecipeFlags(26912, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOP, F.RBOP, F.TANK, F.TRINKET)
	self:AddRecipeMobDrop(26912, 9736)

	-- Figurine - Dark Iron Scorpid -- 26914
	AddRecipe(26914, 300, 21789, Q.UNCOMMON, V.TBC, 300, 310, 320, 330)
	self:AddRecipeFlags(26914, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOP, F.RBOP, F.DPS, F.TRINKET)
	self:AddRecipeMobDrop(26914, 8983)

	-- Necklace of the Diamond Tower -- 26915
	AddRecipe(26915, 305, 21792, Q.COMMON, V.TBC, 305, 315, 325, 335)
	self:AddRecipeFlags(26915, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.TANK, F.NECK)
	self:AddRecipeVendor(26915, 11189)

	-- Band of Natural Fire -- 26916
	AddRecipe(26916, 310, 21779, Q.COMMON, V.TBC, 310, 320, 330, 340)
	self:AddRecipeFlags(26916, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(26916, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Woven Copper Ring -- 26925
	AddRecipe(26925, 1, 21931, Q.COMMON, V.TBC, 1, 30, 45, 60)
	self:AddRecipeFlags(26925, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeAcquire(26925, A.CUSTOM, 8)

	-- Heavy Copper Ring -- 26926
	AddRecipe(26926, 5, 21932, Q.COMMON, V.TBC, 5, 35, 50, 65)
	self:AddRecipeFlags(26926, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(26926, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Thick Bronze Necklace -- 26927
	AddRecipe(26927, 50, 21933, Q.COMMON, V.TBC, 50, 80, 95, 110)
	self:AddRecipeFlags(26927, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.NECK)
	self:AddRecipeTrainer(26927, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Ornate Tigerseye Necklace -- 26928
	AddRecipe(26928, 30, 21934, Q.COMMON, V.TBC, 30, 60, 75, 90)
	self:AddRecipeFlags(26928, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeTrainer(26928, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Teardrop Blood Garnet -- 28903
	AddRecipe(28903, 300, 23094, Q.COMMON, V.TBC, 300, 300, 320, 340)
	self:AddRecipeFlags(28903, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(28903, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Bold Blood Garnet -- 28905
	AddRecipe(28905, 305, 23095, Q.COMMON, V.TBC, 305, 305, 325, 345)
	self:AddRecipeFlags(28905, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(28905, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Runed Blood Garnet -- 28906
	AddRecipe(28906, 315, 23096, Q.UNCOMMON, V.TBC, 315, 315, 335, 355)
	self:AddRecipeFlags(28906, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCRYER)
	self:AddRecipeRepVendor(28906, FAC.SCRYER, REP.FRIENDLY, 19331)

	-- Delicate Blood Garnet -- 28907
	AddRecipe(28907, 325, 23097, Q.UNCOMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(28907, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.CONSORTIUM)
	self:AddRecipeRepVendor(28907, FAC.CONSORTIUM, REP.HONORED, 20242, 23007)

	-- Inscribed Flame Spessarite -- 28910
	AddRecipe(28910, 300, 23098, Q.COMMON, V.TBC, 300, 300, 320, 340)
	self:AddRecipeFlags(28910, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(28910, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Luminous Flame Spessarite -- 28912
	AddRecipe(28912, 305, 23099, Q.UNCOMMON, V.TBC, 305, 305, 325, 345)
	self:AddRecipeFlags(28912, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CONSORTIUM)
	self:AddRecipeRepVendor(28912, FAC.CONSORTIUM, REP.FRIENDLY, 20242, 23007)

	-- Glinting Flame Spessarite -- 28914
	AddRecipe(28914, 315, 23100, Q.COMMON, V.TBC, 315, 315, 335, 355)
	self:AddRecipeFlags(28914, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(28914, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Potent Flame Spessarite -- 28915
	AddRecipe(28915, 325, 23101, Q.UNCOMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(28915, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LOWERCITY)
	self:AddRecipeRepVendor(28915, FAC.LOWERCITY, REP.FRIENDLY, 21655)

	-- Radiant Deep Peridot -- 28916
	AddRecipe(28916, 300, 23103, Q.COMMON, V.TBC, 300, 300, 320, 340)
	self:AddRecipeFlags(28916, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeTrainer(28916, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Jagged Deep Peridot -- 28917
	AddRecipe(28917, 305, 23104, Q.COMMON, V.TBC, 305, 305, 325, 345)
	self:AddRecipeFlags(28917, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(28917, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Enduring Deep Peridot -- 28918
	AddRecipe(28918, 315, 23105, Q.UNCOMMON, V.TBC, 315, 315, 335, 355)
	self:AddRecipeFlags(28918, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.HELLFIRE)
	self:AddRecipeRepVendor(28918, FAC.HONOR_HOLD, REP.FRIENDLY, 17657)
	self:AddRecipeRepVendor(28918, FAC.THRALLMAR, REP.FRIENDLY, 17585)

	-- Dazzling Deep Peridot -- 28924
	AddRecipe(28924, 325, 23106, Q.UNCOMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(28924, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCRYER)
	self:AddRecipeRepVendor(28924, FAC.SCRYER, REP.HONORED, 19331)

	-- Glowing Shadow Draenite -- 28925
	AddRecipe(28925, 300, 23108, Q.COMMON, V.TBC, 300, 300, 320, 340)
	self:AddRecipeFlags(28925, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(28925, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Royal Shadow Draenite -- 28927
	AddRecipe(28927, 305, 23109, Q.UNCOMMON, V.TBC, 305, 305, 325, 345)
	self:AddRecipeFlags(28927, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ALDOR)
	self:AddRecipeRepVendor(28927, FAC.ALDOR, REP.HONORED, 19321)

	-- Shifting Shadow Draenite -- 28933
	AddRecipe(28933, 315, 23110, Q.UNCOMMON, V.TBC, 315, 315, 335, 355)
	self:AddRecipeFlags(28933, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.CONSORTIUM)
	self:AddRecipeRepVendor(28933, FAC.CONSORTIUM, REP.FRIENDLY, 20242, 23007)

	-- Sovereign Shadow Draenite -- 28936
	AddRecipe(28936, 325, 23111, Q.COMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(28936, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(28936, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Brilliant Golden Draenite -- 28938
	AddRecipe(28938, 300, 23113, Q.COMMON, V.TBC, 300, 300, 320, 340)
	self:AddRecipeFlags(28938, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(28938, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Gleaming Golden Draenite -- 28944
	AddRecipe(28944, 305, 23114, Q.UNCOMMON, V.TBC, 305, 305, 325, 345)
	self:AddRecipeFlags(28944, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.ALDOR)
	self:AddRecipeRepVendor(28944, FAC.ALDOR, REP.FRIENDLY, 19321)

	-- Thick Golden Draenite -- 28947
	AddRecipe(28947, 315, 23115, Q.UNCOMMON, V.TBC, 315, 315, 335, 355)
	self:AddRecipeFlags(28947, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.CONSORTIUM)
	self:AddRecipeRepVendor(28947, FAC.CONSORTIUM, REP.HONORED, 20242, 23007)

	-- Rigid Golden Draenite -- 28948
	AddRecipe(28948, 325, 23116, Q.COMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(28948, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(28948, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Solid Azure Moonstone -- 28950
	AddRecipe(28950, 300, 23118, Q.COMMON, V.TBC, 300, 300, 320, 340)
	self:AddRecipeFlags(28950, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(28950, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Sparkling Azure Moonstone -- 28953
	AddRecipe(28953, 305, 23119, Q.COMMON, V.TBC, 305, 305, 325, 345)
	self:AddRecipeFlags(28953, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(28953, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Stormy Azure Moonstone -- 28955
	AddRecipe(28955, 315, 23120, Q.UNCOMMON, V.TBC, 315, 315, 335, 355)
	self:AddRecipeFlags(28955, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.CASTER)
	self:AddRecipeWorldDrop(28955, "Outland")

	-- Lustrous Azure Moonstone -- 28957
	AddRecipe(28957, 325, 23121, Q.UNCOMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(28957, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CONSORTIUM)
	self:AddRecipeRepVendor(28957, FAC.CONSORTIUM, REP.HONORED, 20242, 23007)

	-- Fel Iron Blood Ring -- 31048
	AddRecipe(31048, 310, 24074, Q.COMMON, V.TBC, 310, 320, 330, 340)
	self:AddRecipeFlags(31048, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(31048, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Golden Draenite Ring -- 31049
	AddRecipe(31049, 310, 24075, Q.COMMON, V.TBC, 310, 320, 335, 350)
	self:AddRecipeFlags(31049, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(31049, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Azure Moonstone Ring -- 31050
	AddRecipe(31050, 320, 24076, Q.COMMON, V.TBC, 320, 330, 340, 350)
	self:AddRecipeFlags(31050, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(31050, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Thick Adamantite Necklace -- 31051
	AddRecipe(31051, 335, 24077, Q.COMMON, V.TBC, 335, 345, 355, 365)
	self:AddRecipeFlags(31051, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.NECK)
	self:AddRecipeTrainer(31051, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Heavy Adamantite Ring -- 31052
	AddRecipe(31052, 335, 24078, Q.COMMON, V.TBC, 335, 345, 355, 365)
	self:AddRecipeFlags(31052, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(31052, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Khorium Band of Shadows -- 31053
	AddRecipe(31053, 350, 24079, Q.RARE, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(31053, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeMobDrop(31053, 19826)

	-- Khorium Band of Frost -- 31054
	AddRecipe(31054, 355, 24080, Q.RARE, V.TBC, 355, 365, 372, 380)
	self:AddRecipeFlags(31054, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeMobDrop(31054, 17722)

	-- Khorium Inferno Band -- 31055
	AddRecipe(31055, 355, 24082, Q.RARE, V.TBC, 355, 365, 372, 380)
	self:AddRecipeFlags(31055, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeMobDrop(31055, 18472)

	-- Khorium Band of Leaves -- 31056
	AddRecipe(31056, 360, 24085, Q.RARE, V.TBC, 360, 370, 375, 380)
	self:AddRecipeFlags(31056, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeMobDrop(31056, 19984)

	-- Arcane Khorium Band -- 31057
	AddRecipe(31057, 365, 24086, Q.RARE, V.TBC, 365, 370, 375, 380)
	self:AddRecipeFlags(31057, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeMobDrop(31057, 18866)

	-- Heavy Felsteel Ring -- 31058
	AddRecipe(31058, 345, 24087, Q.RARE, V.TBC, 345, 355, 365, 375)
	self:AddRecipeFlags(31058, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.RING)
	self:AddRecipeWorldDrop(31058, "Outland")

	-- Delicate Eternium Ring -- 31060
	AddRecipe(31060, 355, 24088, Q.RARE, V.TBC, 355, 365, 375, 385)
	self:AddRecipeFlags(31060, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.TANK, F.RING)
	self:AddRecipeWorldDrop(31060, "Outland")

	-- Blazing Eternium Band -- 31061
	AddRecipe(31061, 365, 24089, Q.RARE, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(31061, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeWorldDrop(31061, "Outland")

	-- Pendant of Frozen Flame -- 31062
	AddRecipe(31062, 360, 24092, Q.RARE, V.TBC, 360, 370, 375, 380)
	self:AddRecipeFlags(31062, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.NECK, F.KOT)
	self:AddRecipeRepVendor(31062, FAC.KEEPERS_OF_TIME, REP.REVERED, 21643)

	-- Pendant of Thawing -- 31063
	AddRecipe(31063, 360, 24093, Q.RARE, V.TBC, 360, 370, 375, 380)
	self:AddRecipeFlags(31063, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.NECK, F.LOWERCITY)
	self:AddRecipeRepVendor(31063, FAC.LOWERCITY, REP.REVERED, 21655)

	-- Pendant of Withering -- 31064
	AddRecipe(31064, 360, 24095, Q.RARE, V.TBC, 360, 370, 375, 380)
	self:AddRecipeFlags(31064, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.NECK, F.SCRYER)
	self:AddRecipeRepVendor(31064, FAC.SCRYER, REP.REVERED, 19331)

	-- Pendant of Shadow's End -- 31065
	AddRecipe(31065, 360, 24097, Q.RARE, V.TBC, 360, 370, 375, 380)
	self:AddRecipeFlags(31065, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.NECK, F.ALDOR)
	self:AddRecipeRepVendor(31065, FAC.ALDOR, REP.REVERED, 19321)

	-- Pendant of the Null Rune -- 31066
	AddRecipe(31066, 360, 24098, Q.RARE, V.TBC, 360, 370, 375, 380)
	self:AddRecipeFlags(31066, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.NECK, F.CONSORTIUM)
	self:AddRecipeRepVendor(31066, FAC.CONSORTIUM, REP.REVERED, 20242, 23007)

	-- Thick Felsteel Necklace -- 31067
	AddRecipe(31067, 355, 24106, Q.RARE, V.TBC, 355, 365, 375, 385)
	self:AddRecipeFlags(31067, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.NECK)
	self:AddRecipeWorldDrop(31067, "Outland")

	-- Living Ruby Pendant -- 31068
	AddRecipe(31068, 355, 24110, Q.RARE, V.TBC, 355, 365, 375, 385)
	self:AddRecipeFlags(31068, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeWorldDrop(31068, "Outland")

	-- Braided Eternium Chain -- 31070
	AddRecipe(31070, 360, 24114, Q.RARE, V.TBC, 360, 370, 377, 385)
	self:AddRecipeFlags(31070, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.NECK)
	self:AddRecipeWorldDrop(31070, "Outland")

	-- Eye of the Night -- 31071
	AddRecipe(31071, 360, 24116, Q.RARE, V.TBC, 360, 370, 375, 380)
	self:AddRecipeFlags(31071, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeWorldDrop(31071, "Outland")

	-- Embrace of the Dawn -- 31072
	AddRecipe(31072, 365, 24117, Q.RARE, V.TBC, 365, 375, 380, 385)
	self:AddRecipeFlags(31072, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeWorldDrop(31072, "Outland")

	-- Chain of the Twilight Owl -- 31076
	AddRecipe(31076, 365, 24121, Q.RARE, V.TBC, 365, 375, 380, 385)
	self:AddRecipeFlags(31076, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.TANK, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeWorldDrop(31076, "Outland")

	-- Coronet of Verdant Flame -- 31077
	AddRecipe(31077, 370, 24122, Q.EPIC, V.TBC, 370, 375, 380, 385)
	self:AddRecipeFlags(31077, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CLOTH)
	self:AddRecipeMobDrop(31077, 18422)

	-- Circlet of Arcane Might -- 31078
	AddRecipe(31078, 370, 24123, Q.EPIC, V.TBC, 370, 375, 380, 385)
	self:AddRecipeFlags(31078, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CLOTH)
	self:AddRecipeMobDrop(31078, 18096)

	-- Figurine - Felsteel Boar -- 31079
	AddRecipe(31079, 370, 24124, Q.RARE, V.TBC, 370, 375, 380, 385)
	self:AddRecipeFlags(31079, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS, F.TRINKET, F.LOWERCITY)
	self:AddRecipeRepVendor(31079, FAC.LOWERCITY, REP.REVERED, 21655)

	-- Figurine - Dawnstone Crab -- 31080
	AddRecipe(31080, 370, 24125, Q.RARE, V.TBC, 370, 375, 380, 385)
	self:AddRecipeFlags(31080, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.TANK, F.TRINKET, F.HELLFIRE)
	self:AddRecipeRepVendor(31080, FAC.HONOR_HOLD, REP.REVERED, 17657)
	self:AddRecipeRepVendor(31080, FAC.THRALLMAR, REP.REVERED, 17585)

	-- Figurine - Living Ruby Serpent -- 31081
	AddRecipe(31081, 370, 24126, Q.RARE, V.TBC, 370, 375, 380, 385)
	self:AddRecipeFlags(31081, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET, F.KOT)
	self:AddRecipeRepVendor(31081, FAC.KEEPERS_OF_TIME, REP.REVERED, 21643)

	-- Figurine - Talasite Owl -- 31082
	AddRecipe(31082, 370, 24127, Q.RARE, V.TBC, 370, 375, 380, 385)
	self:AddRecipeFlags(31082, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET, F.SHATAR)
	self:AddRecipeRepVendor(31082, FAC.SHATAR, REP.REVERED, 21432)

	-- Figurine - Nightseye Panther -- 31083
	AddRecipe(31083, 370, 24128, Q.RARE, V.TBC, 370, 375, 380, 385)
	self:AddRecipeFlags(31083, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS, F.TRINKET, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(31083, FAC.CENARION_EXPEDITION, REP.REVERED, 17904)

	-- Bold Living Ruby -- 31084
	AddRecipe(31084, 350, 24027, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31084, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(31084, "Outland")

	-- Delicate Living Ruby -- 31085
	AddRecipe(31085, 350, 24028, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31085, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(31085, "Outland")

	-- Teardrop Living Ruby -- 31087
	AddRecipe(31087, 350, 24029, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31087, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(31087, "Outland")

	-- Runed Living Ruby -- 31088
	AddRecipe(31088, 350, 24030, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31088, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.MOB_DROP, F.IBOE, F.RBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeMobDrop(31088, 24664)
	self:AddRecipeWorldDrop(31088, "Outland")

	-- Bright Living Ruby -- 31089
	AddRecipe(31089, 350, 24031, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31089, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.MOB_DROP, F.IBOE, F.RBOE, F.RBOP, F.DPS)
	self:AddRecipeMobDrop(31089, 24664)
	self:AddRecipeWorldDrop(31089, "Outland")

	-- Subtle Living Ruby -- 31090
	AddRecipe(31090, 350, 24032, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31090, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.TANK)
	self:AddRecipeWorldDrop(31090, "Outland")

	-- Flashing Living Ruby -- 31091
	AddRecipe(31091, 350, 24036, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31091, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.TANK)
	self:AddRecipeWorldDrop(31091, "Outland")

	-- Solid Star of Elune -- 31092
	AddRecipe(31092, 350, 24033, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31092, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.MOB_DROP, F.IBOE, F.RBOE, F.RBOP)
	self:AddRecipeMobDrop(31092, 24664)
	self:AddRecipeWorldDrop(31092, "Outland")

	-- Lustrous Star of Elune -- 31094
	AddRecipe(31094, 350, 24037, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31094, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(31094, "Outland")

	-- Stormy Star of Elune -- 31095
	AddRecipe(31095, 350, 24039, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31095, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.CASTER)
	self:AddRecipeWorldDrop(31095, "Outland")

	-- Brilliant Dawnstone -- 31096
	AddRecipe(31096, 350, 24047, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31096, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(31096, "Outland")

	-- Smooth Dawnstone -- 31097
	AddRecipe(31097, 350, 24048, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31097, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(31097, "Outland")

	-- Rigid Dawnstone -- 31098
	AddRecipe(31098, 350, 24051, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31098, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.MOB_DROP, F.IBOE, F.RBOE, F.RBOP)
	self:AddRecipeMobDrop(31098, 24664)
	self:AddRecipeWorldDrop(31098, "Outland")

	-- Gleaming Dawnstone -- 31099
	AddRecipe(31099, 350, 24050, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31099, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(31099, "Outland")

	-- Thick Dawnstone -- 31100
	AddRecipe(31100, 350, 24052, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31100, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.TANK)
	self:AddRecipeWorldDrop(31100, "Outland")

	-- Mystic Dawnstone -- 31101
	AddRecipe(31101, 350, 24053, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31101, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(31101, 21474, 21485)

	-- Sovereign Nightseye -- 31102
	AddRecipe(31102, 350, 24054, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31102, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(31102, "Outland")

	-- Shifting Nightseye -- 31103
	AddRecipe(31103, 350, 24055, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31103, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(31103, "Outland")

	-- Glowing Nightseye -- 31104
	AddRecipe(31104, 350, 24056, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31104, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(31104, "Outland")

	-- Royal Nightseye -- 31105
	AddRecipe(31105, 350, 24057, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31105, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(31105, "Outland")

	-- Inscribed Noble Topaz -- 31106
	AddRecipe(31106, 350, 24058, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31106, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(31106, "Outland")

	-- Potent Noble Topaz -- 31107
	AddRecipe(31107, 350, 24059, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31107, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(31107, "Outland")

	-- Luminous Noble Topaz -- 31108
	AddRecipe(31108, 350, 24060, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31108, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(31108, "Outland")

	-- Glinting Noble Topaz -- 31109
	AddRecipe(31109, 350, 24061, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31109, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(31109, "Outland")

	-- Enduring Talasite -- 31110
	AddRecipe(31110, 350, 24062, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31110, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.TANK)
	self:AddRecipeWorldDrop(31110, "Outland")

	-- Radiant Talasite -- 31111
	AddRecipe(31111, 350, 24066, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31111, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.CASTER)
	self:AddRecipeWorldDrop(31111, "Outland")

	-- Dazzling Talasite -- 31112
	AddRecipe(31112, 350, 24065, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31112, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(31112, "Outland")

	-- Jagged Talasite -- 31113
	AddRecipe(31113, 350, 24067, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31113, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(31113, "Outland")

	-- Sparkling Star of Elune -- 31149
	AddRecipe(31149, 350, 24035, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(31149, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(31149, "Outland")

	-- Malachite Pendant -- 32178
	AddRecipe(32178, 20, 25438, Q.COMMON, V.TBC, 20, 50, 65, 80)
	self:AddRecipeFlags(32178, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.NECK)
	self:AddRecipeTrainer(32178, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Tigerseye Band -- 32179
	AddRecipe(32179, 20, 25439, Q.COMMON, V.TBC, 20, 50, 65, 80)
	self:AddRecipeFlags(32179, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(32179, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Rough Stone Statue -- 32259
	AddRecipe(32259, 1, 25498, Q.COMMON, V.TBC, 1, 30, 40, 50)
	self:AddRecipeFlags(32259, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeAcquire(32259, A.CUSTOM, 8)

	-- Coarse Stone Statue -- 32801
	AddRecipe(32801, 50, 25880, Q.COMMON, V.TBC, 50, 70, 80, 90)
	self:AddRecipeFlags(32801, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(32801, 15501, 33614, 28701, 18774, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Heavy Stone Statue -- 32807
	AddRecipe(32807, 110, 25881, Q.COMMON, V.TBC, 110, 120, 130, 140)
	self:AddRecipeFlags(32807, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(32807, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Solid Stone Statue -- 32808
	AddRecipe(32808, 175, 25882, Q.COMMON, V.TBC, 175, 175, 185, 195)
	self:AddRecipeFlags(32808, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(32808, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Dense Stone Statue -- 32809
	AddRecipe(32809, 225, 25883, Q.COMMON, V.TBC, 225, 225, 235, 245)
	self:AddRecipeFlags(32809, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(32809, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Powerful Earthstorm Diamond -- 32866
	AddRecipe(32866, 365, 25896, Q.COMMON, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(32866, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CONSORTIUM)
	self:AddRecipeRepVendor(32866, FAC.CONSORTIUM, REP.HONORED, 17518)

	-- Bracing Earthstorm Diamond -- 32867
	AddRecipe(32867, 365, 25897, Q.COMMON, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(32867, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CONSORTIUM)
	self:AddRecipeRepVendor(32867, FAC.CONSORTIUM, REP.REVERED, 17518)

	-- Tenacious Earthstorm Diamond -- 32868
	AddRecipe(32868, 365, 25898, Q.RARE, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(32868, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.TANK)
	self:AddRecipeWorldDrop(32868, "Outland")

	-- Brutal Earthstorm Diamond -- 32869
	AddRecipe(32869, 365, 25899, Q.RARE, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(32869, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(32869, "Outland")

	-- Insightful Earthstorm Diamond -- 32870
	AddRecipe(32870, 365, 25901, Q.COMMON, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(32870, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SHATAR)
	self:AddRecipeRepVendor(32870, FAC.SHATAR, REP.FRIENDLY, 21432)

	-- Destructive Skyfire Diamond -- 32871
	AddRecipe(32871, 365, 25890, Q.RARE, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(32871, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(32871, "Outland")

	-- Mystical Skyfire Diamond -- 32872
	AddRecipe(32872, 365, 25893, Q.RARE, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(32872, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(32872, "Outland")

	-- Swift Skyfire Diamond -- 32873
	AddRecipe(32873, 365, 25894, Q.COMMON, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(32873, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.CONSORTIUM)
	self:AddRecipeRepVendor(32873, FAC.CONSORTIUM, REP.HONORED, 20242, 23007)

	-- Enigmatic Skyfire Diamond -- 32874
	AddRecipe(32874, 365, 25895, Q.COMMON, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(32874, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.KOT)
	self:AddRecipeRepVendor(32874, FAC.KEEPERS_OF_TIME, REP.HONORED, 21643)

	-- Smooth Golden Draenite -- 34069
	AddRecipe(34069, 325, 28290, Q.COMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(34069, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(34069, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Bright Blood Garnet -- 34590
	AddRecipe(34590, 305, 28595, Q.COMMON, V.TBC, 305, 305, 325, 345)
	self:AddRecipeFlags(34590, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(34590, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Golden Ring of Power -- 34955
	AddRecipe(34955, 180, 29157, Q.COMMON, V.TBC, 180, 190, 200, 210)
	self:AddRecipeFlags(34955, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(34955, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Truesilver Commander's Ring -- 34959
	AddRecipe(34959, 200, 29158, Q.COMMON, V.TBC, 200, 210, 220, 230)
	self:AddRecipeFlags(34959, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(34959, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Glowing Thorium Band -- 34960
	AddRecipe(34960, 280, 29159, Q.COMMON, V.TBC, 280, 290, 300, 310)
	self:AddRecipeFlags(34960, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(34960, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Emerald Lion Ring -- 34961
	AddRecipe(34961, 290, 29160, Q.COMMON, V.TBC, 290, 300, 310, 320)
	self:AddRecipeFlags(34961, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(34961, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Brilliant Necklace -- 36523
	AddRecipe(36523, 75, 30419, Q.COMMON, V.TBC, 75, 105, 120, 135)
	self:AddRecipeFlags(36523, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeTrainer(36523, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Heavy Jade Ring -- 36524
	AddRecipe(36524, 105, 30420, Q.COMMON, V.TBC, 105, 135, 150, 165)
	self:AddRecipeFlags(36524, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(36524, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Red Ring of Destruction -- 36525
	AddRecipe(36525, 230, 30421, Q.COMMON, V.TBC, 230, 255, 270, 285)
	self:AddRecipeFlags(36525, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(36525, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Diamond Focus Ring -- 36526
	AddRecipe(36526, 265, 30422, Q.COMMON, V.TBC, 265, 285, 295, 305)
	self:AddRecipeFlags(36526, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(36526, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Bronze Band of Force -- 37818
	AddRecipe(37818, 65, 30804, Q.COMMON, V.TBC, 65, 95, 110, 125)
	self:AddRecipeFlags(37818, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(37818, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Ring of Arcane Shielding -- 37855
	AddRecipe(37855, 360, 30825, Q.RARE, V.TBC, 360, 370, 375, 380)
	self:AddRecipeFlags(37855, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.RING, F.SHATAR)
	self:AddRecipeRepVendor(37855, FAC.SHATAR, REP.HONORED, 21432)

	-- Mercurial Adamantite -- 38068
	AddRecipe(38068, 325, 31079, Q.COMMON, V.TBC, 325, 325, 335, 345)
	self:AddRecipeFlags(38068, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(38068, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Bronze Torc -- 38175
	AddRecipe(38175, 80, 31154, Q.COMMON, V.TBC, 80, 110, 125, 140)
	self:AddRecipeFlags(38175, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.NECK)
	self:AddRecipeTrainer(38175, 18774, 33614, 28701, 15501, 26997, 19775, 19778, 26982, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- The Frozen Eye -- 38503
	AddRecipe(38503, 375, 31398, Q.EPIC, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(38503, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.RING, F.VIOLETEYE)
	self:AddRecipeRepVendor(38503, FAC.VIOLETEYE, REP.HONORED, 18255)

	-- The Natural Ward -- 38504
	AddRecipe(38504, 375, 31399, Q.EPIC, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(38504, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.RING, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(38504, FAC.CENARION_EXPEDITION, REP.EXALTED, 17904)

	-- Great Golden Draenite -- 39451
	AddRecipe(39451, 325, 31860, Q.UNCOMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(39451, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeAcquire(39451, A.CUSTOM, 35)

	-- Great Dawnstone -- 39452
	AddRecipe(39452, 350, 31861, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(39452, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(39452, "Outland")

	-- Balanced Shadow Draenite -- 39455
	AddRecipe(39455, 325, 31862, Q.UNCOMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(39455, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeAcquire(39455, A.CUSTOM, 35)

	-- Infused Shadow Draenite -- 39458
	AddRecipe(39458, 325, 31864, Q.UNCOMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(39458, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(39458, A.CUSTOM, 35)

	-- Infused Nightseye -- 39462
	AddRecipe(39462, 350, 31865, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(39462, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(39462, "Outland")

	-- Balanced Nightseye -- 39463
	AddRecipe(39463, 350, 31863, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(39463, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(39463, "Outland")

	-- Veiled Flame Spessarite -- 39466
	AddRecipe(39466, 325, 31866, Q.UNCOMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(39466, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(39466, A.CUSTOM, 35)

	-- Wicked Flame Spessarite -- 39467
	AddRecipe(39467, 325, 31869, Q.UNCOMMON, V.TBC, 325, 325, 340, 355)
	self:AddRecipeFlags(39467, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeAcquire(39467, A.CUSTOM, 35)

	-- Veiled Noble Topaz -- 39470
	AddRecipe(39470, 350, 31867, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(39470, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(39470, "Outland")

	-- Wicked Noble Topaz -- 39471
	AddRecipe(39471, 350, 31868, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(39471, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(39471, "Outland")

	-- Bold Crimson Spinel -- 39705
	AddRecipe(39705, 375, 32193, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39705, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39705, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39705, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Delicate Crimson Spinel -- 39706
	AddRecipe(39706, 375, 32194, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39706, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39706, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39706, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Teardrop Crimson Spinel -- 39710
	AddRecipe(39710, 375, 32195, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39710, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39710, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39710, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Runed Crimson Spinel -- 39711
	AddRecipe(39711, 375, 32196, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39711, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39711, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39711, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Bright Crimson Spinel -- 39712
	AddRecipe(39712, 375, 32197, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39712, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39712, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39712, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Subtle Crimson Spinel -- 39713
	AddRecipe(39713, 375, 32198, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39713, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39713, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39713, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Flashing Crimson Spinel -- 39714
	AddRecipe(39714, 375, 32199, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39714, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.TANK, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39714, FAC.SHATTEREDSUN, REP.EXALTED, 27666, 25950)
	self:AddRecipeAcquire(39714, A.CUSTOM, 27)

	-- Solid Empyrean Sapphire -- 39715
	AddRecipe(39715, 375, 32200, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39715, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39715, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39715, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Sparkling Empyrean Sapphire -- 39716
	AddRecipe(39716, 375, 32201, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39716, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39716, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39716, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Lustrous Empyrean Sapphire -- 39717
	AddRecipe(39717, 375, 32202, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39717, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39717, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39717, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Stormy Empyrean Sapphire -- 39718
	AddRecipe(39718, 375, 32203, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39718, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.CASTER, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39718, FAC.SHATTEREDSUN, REP.EXALTED, 27666, 25950)
	self:AddRecipeAcquire(39718, A.CUSTOM, 27)

	-- Brilliant Lionseye -- 39719
	AddRecipe(39719, 375, 32204, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39719, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39719, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39719, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Smooth Lionseye -- 39720
	AddRecipe(39720, 375, 32205, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39720, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39720, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39720, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Rigid Lionseye -- 39721
	AddRecipe(39721, 375, 32206, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39721, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39721, FAC.SHATTEREDSUN, REP.REVERED, 25950, 27666)
	self:AddRecipeRepVendor(39721, FAC.SCALE_OF_SANDS, REP.REVERED, 23437)

	-- Gleaming Lionseye -- 39722
	AddRecipe(39722, 375, 32207, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39722, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39722, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39722, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Thick Lionseye -- 39723
	AddRecipe(39723, 375, 32208, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39723, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39723, FAC.SHATTEREDSUN, REP.FRIENDLY, 25950, 27666)
	self:AddRecipeRepVendor(39723, FAC.SCALE_OF_SANDS, REP.FRIENDLY, 23437)

	-- Mystic Lionseye -- 39724
	AddRecipe(39724, 375, 32209, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39724, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39724, FAC.SHATTEREDSUN, REP.EXALTED, 27666, 25950)
	self:AddRecipeAcquire(39724, A.CUSTOM, 27)

	-- Great Lionseye -- 39725
	AddRecipe(39725, 375, 32210, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39725, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39725, FAC.SHATTEREDSUN, REP.EXALTED, 27666, 25950)
	self:AddRecipeAcquire(39725, A.CUSTOM, 27)

	-- Sovereign Shadowsong Amethyst -- 39727
	AddRecipe(39727, 375, 32211, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39727, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.DPS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39727, FAC.SHATTEREDSUN, REP.EXALTED, 27666, 25950)
	self:AddRecipeAcquire(39727, A.CUSTOM, 27)

	-- Shifting Shadowsong Amethyst -- 39728
	AddRecipe(39728, 375, 32212, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39728, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.DPS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39728, FAC.SHATTEREDSUN, REP.EXALTED, 27666, 25950)
	self:AddRecipeAcquire(39728, A.CUSTOM, 27)

	-- Balanced Shadowsong Amethyst -- 39729
	AddRecipe(39729, 375, 32213, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39729, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39729, FAC.SHATTEREDSUN, REP.HONORED, 25950, 27666)
	self:AddRecipeRepVendor(39729, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Infused Shadowsong Amethyst -- 39730
	AddRecipe(39730, 375, 32214, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39730, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39730, FAC.SHATTEREDSUN, REP.HONORED, 25950, 27666)
	self:AddRecipeRepVendor(39730, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Glowing Shadowsong Amethyst -- 39731
	AddRecipe(39731, 375, 32215, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39731, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39731, FAC.SHATTEREDSUN, REP.HONORED, 25950, 27666)
	self:AddRecipeRepVendor(39731, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Royal Shadowsong Amethyst -- 39732
	AddRecipe(39732, 375, 32216, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39732, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39732, FAC.SHATTEREDSUN, REP.REVERED, 25950, 27666)
	self:AddRecipeRepVendor(39732, FAC.SCALE_OF_SANDS, REP.REVERED, 23437)

	-- Inscribed Pyrestone -- 39733
	AddRecipe(39733, 375, 32217, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39733, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.DPS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39733, FAC.SHATTEREDSUN, REP.EXALTED, 27666, 25950)
	self:AddRecipeAcquire(39733, A.CUSTOM, 27)

	-- Potent Pyrestone -- 39734
	AddRecipe(39734, 375, 32218, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39734, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39734, FAC.SHATTEREDSUN, REP.HONORED, 25950, 27666)
	self:AddRecipeRepVendor(39734, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Luminous Pyrestone -- 39735
	AddRecipe(39735, 375, 32219, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39735, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39735, FAC.SHATTEREDSUN, REP.HONORED, 25950, 27666)
	self:AddRecipeRepVendor(39735, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Glinting Pyrestone -- 39736
	AddRecipe(39736, 375, 32220, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39736, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39736, FAC.SHATTEREDSUN, REP.HONORED, 25950, 27666)
	self:AddRecipeRepVendor(39736, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Veiled Pyrestone -- 39737
	AddRecipe(39737, 375, 32221, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39737, F.ALLIANCE, F.HORDE, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39737, FAC.SHATTEREDSUN, REP.EXALTED, 27666, 25950)
	self:AddRecipeAcquire(39737, A.CUSTOM, 27)

	-- Wicked Pyrestone -- 39738
	AddRecipe(39738, 375, 32222, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39738, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39738, FAC.SHATTEREDSUN, REP.REVERED, 25950, 27666)
	self:AddRecipeRepVendor(39738, FAC.SCALE_OF_SANDS, REP.REVERED, 23437)

	-- Enduring Seaspray Emerald -- 39739
	AddRecipe(39739, 375, 32223, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39739, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39739, FAC.SHATTEREDSUN, REP.REVERED, 25950, 27666)
	self:AddRecipeRepVendor(39739, FAC.SCALE_OF_SANDS, REP.REVERED, 23437)

	-- Radiant Seaspray Emerald -- 39740
	AddRecipe(39740, 375, 32224, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39740, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39740, FAC.SHATTEREDSUN, REP.HONORED, 25950, 27666)
	self:AddRecipeRepVendor(39740, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Dazzling Seaspray Emerald -- 39741
	AddRecipe(39741, 375, 32225, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39741, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39741, FAC.SHATTEREDSUN, REP.HONORED, 25950, 27666)
	self:AddRecipeRepVendor(39741, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Jagged Seaspray Emerald -- 39742
	AddRecipe(39742, 375, 32226, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(39742, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(39742, FAC.SHATTEREDSUN, REP.HONORED, 25950, 27666)
	self:AddRecipeRepVendor(39742, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Relentless Earthstorm Diamond -- 39961
	AddRecipe(39961, 365, 32409, Q.RARE, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(39961, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.CONSORTIUM)
	self:AddRecipeRepVendor(39961, FAC.CONSORTIUM, REP.EXALTED, 20242, 23007)

	-- Thundering Skyfire Diamond -- 39963
	AddRecipe(39963, 365, 32410, Q.RARE, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(39963, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(39963, "Outland")

	-- Necklace of the Deep -- 40514
	AddRecipe(40514, 340, 32508, Q.COMMON, V.TBC, 340, 340, 355, 370)
	self:AddRecipeFlags(40514, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.NECK)
	self:AddRecipeTrainer(40514, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Brilliant Pearl Band -- 41414
	AddRecipe(41414, 325, 32772, Q.COMMON, V.TBC, 325, 335, 345, 355)
	self:AddRecipeFlags(41414, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(41414, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- The Black Pearl -- 41415
	AddRecipe(41415, 330, 32774, Q.COMMON, V.TBC, 330, 340, 350, 360)
	self:AddRecipeFlags(41415, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(41415, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Crown of the Sea Witch -- 41418
	AddRecipe(41418, 365, 32776, Q.COMMON, V.TBC, 365, 375, 380, 385)
	self:AddRecipeFlags(41418, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CLOTH)
	self:AddRecipeTrainer(41418, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Purified Jaggal Pearl -- 41420
	AddRecipe(41420, 325, 32833, Q.COMMON, V.TBC, 325, 325, 332, 340)
	self:AddRecipeFlags(41420, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(41420, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Purified Shadow Pearl -- 41429
	AddRecipe(41429, 350, 32836, Q.COMMON, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(41429, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(41429, 33614, 26997, 28701, 18774, 26982, 18751, 26960, 19539, 19063, 26915, 33680, 33590)

	-- Don Julio's Heart -- 42558
	AddRecipe(42558, 360, 33133, Q.COMMON, V.TBC, 360, 365, 370, 375)
	self:AddRecipeFlags(42558, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.CONSORTIUM)
	self:AddRecipeRepVendor(42558, FAC.CONSORTIUM, REP.REVERED, 20242, 23007)

	-- Kailee's Rose -- 42588
	AddRecipe(42588, 360, 33134, Q.COMMON, V.TBC, 360, 365, 370, 375)
	self:AddRecipeFlags(42588, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.SHATAR)
	self:AddRecipeRepVendor(42588, FAC.SHATAR, REP.HONORED, 21432)

	-- Crimson Sun -- 42589
	AddRecipe(42589, 360, 33131, Q.COMMON, V.TBC, 360, 365, 370, 375)
	self:AddRecipeFlags(42589, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS, F.CONSORTIUM)
	self:AddRecipeRepVendor(42589, FAC.CONSORTIUM, REP.REVERED, 20242, 23007)

	-- Falling Star -- 42590
	AddRecipe(42590, 360, 33135, Q.COMMON, V.TBC, 360, 365, 370, 375)
	self:AddRecipeFlags(42590, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.LOWERCITY)
	self:AddRecipeRepVendor(42590, FAC.LOWERCITY, REP.REVERED, 21655)

	-- Stone of Blades -- 42591
	AddRecipe(42591, 360, 33143, Q.COMMON, V.TBC, 360, 365, 370, 375)
	self:AddRecipeFlags(42591, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.KOT)
	self:AddRecipeRepVendor(42591, FAC.KEEPERS_OF_TIME, REP.REVERED, 21643)

	-- Blood of Amber -- 42592
	AddRecipe(42592, 360, 33140, Q.COMMON, V.TBC, 360, 365, 370, 375)
	self:AddRecipeFlags(42592, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS, F.SHATAR)
	self:AddRecipeRepVendor(42592, FAC.SHATAR, REP.REVERED, 21432)

	-- Facet of Eternity -- 42593
	AddRecipe(42593, 360, 33144, Q.COMMON, V.TBC, 360, 365, 370, 375)
	self:AddRecipeFlags(42593, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.TANK, F.KOT)
	self:AddRecipeRepVendor(42593, FAC.KEEPERS_OF_TIME, REP.HONORED, 21643)

	-- Steady Talasite -- 43493
	AddRecipe(43493, 350, 33782, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(43493, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP)
	self:AddRecipeVendor(43493, 18821, 18822)

	-- Chaotic Skyfire Diamond -- 44794
	AddRecipe(44794, 365, 34220, Q.RARE, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(44794, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(44794, 19768)

	-- Loop of Forged Power -- 46122
	AddRecipe(46122, 365, 34362, Q.EPIC, V.TBC, 365, 375, 380, 385)
	self:AddRecipeFlags(46122, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeAcquire(46122, A.CUSTOM, 24)

	-- Ring of Flowing Life -- 46123
	AddRecipe(46123, 365, 34363, Q.EPIC, V.TBC, 365, 375, 380, 385)
	self:AddRecipeFlags(46123, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeAcquire(46123, A.CUSTOM, 24)

	-- Hard Khorium Band -- 46124
	AddRecipe(46124, 365, 34361, Q.EPIC, V.TBC, 365, 375, 380, 385)
	self:AddRecipeFlags(46124, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeAcquire(46124, A.CUSTOM, 24)

	-- Pendant of Sunfire -- 46125
	AddRecipe(46125, 365, 34359, Q.EPIC, V.TBC, 365, 375, 380, 385)
	self:AddRecipeFlags(46125, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeAcquire(46125, A.CUSTOM, 24)

	-- Amulet of Flowing Life -- 46126
	AddRecipe(46126, 365, 34360, Q.EPIC, V.TBC, 365, 375, 380, 385)
	self:AddRecipeFlags(46126, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeAcquire(46126, A.CUSTOM, 24)

	-- Hard Khorium Choker -- 46127
	AddRecipe(46127, 365, 34358, Q.EPIC, V.TBC, 365, 375, 380, 385)
	self:AddRecipeFlags(46127, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOP, F.DPS, F.NECK)
	self:AddRecipeAcquire(46127, A.CUSTOM, 24)

	-- Quick Dawnstone -- 46403
	AddRecipe(46403, 350, 35315, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(46403, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46403, FAC.SHATTEREDSUN, REP.EXALTED, 25950, 27666)

	-- Reckless Noble Topaz -- 46404
	AddRecipe(46404, 350, 35316, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(46404, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46404, FAC.SHATTEREDSUN, REP.EXALTED, 25950, 27666)

	-- Forceful Talasite -- 46405
	AddRecipe(46405, 350, 35318, Q.RARE, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(46405, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46405, FAC.SHATTEREDSUN, REP.EXALTED, 25950, 27666)

	-- Eternal Earthstorm Diamond -- 46597
	AddRecipe(46597, 370, 35501, Q.COMMON, V.TBC, 370, 375, 377, 380)
	self:AddRecipeFlags(46597, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46597, FAC.SHATTEREDSUN, REP.REVERED, 25032)

	-- Ember Skyfire Diamond -- 46601
	AddRecipe(46601, 370, 35503, Q.COMMON, V.TBC, 370, 375, 377, 380)
	self:AddRecipeFlags(46601, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46601, FAC.SHATTEREDSUN, REP.REVERED, 25032)

	-- Figurine - Empyrean Tortoise -- 46775
	AddRecipe(46775, 375, 35693, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(46775, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.TANK, F.TRINKET, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46775, FAC.SHATTEREDSUN, REP.REVERED, 25032)

	-- Figurine - Khorium Boar -- 46776
	AddRecipe(46776, 375, 35694, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(46776, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS, F.TRINKET, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46776, FAC.SHATTEREDSUN, REP.REVERED, 25032)

	-- Figurine - Crimson Serpent -- 46777
	AddRecipe(46777, 375, 35700, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(46777, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46777, FAC.SHATTEREDSUN, REP.REVERED, 25032)

	-- Figurine - Shadowsong Panther -- 46778
	AddRecipe(46778, 375, 35702, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(46778, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS, F.TRINKET, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46778, FAC.SHATTEREDSUN, REP.REVERED, 25032)

	-- Figurine - Seaspray Albatross -- 46779
	AddRecipe(46779, 375, 35703, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(46779, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46779, FAC.SHATTEREDSUN, REP.REVERED, 25032)

	-- Regal Nightseye -- 46803
	AddRecipe(46803, 350, 35707, Q.COMMON, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(46803, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(46803, FAC.SHATTEREDSUN, REP.REVERED, 25032)

	-- Forceful Seaspray Emerald -- 47053
	AddRecipe(47053, 375, 35759, Q.EPIC, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(47053, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(47053, FAC.SHATTEREDSUN, REP.REVERED, 25032, 25950, 27666)
	self:AddRecipeRepVendor(47053, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Steady Seaspray Emerald -- 47054
	AddRecipe(47054, 375, 35758, Q.EPIC, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(47054, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(47054, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)
	self:AddRecipeRepVendor(47054, FAC.SHATTEREDSUN, REP.REVERED, 25032, 25950, 27666)

	-- Reckless Pyrestone -- 47055
	AddRecipe(47055, 375, 35760, Q.EPIC, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(47055, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(47055, FAC.SHATTEREDSUN, REP.REVERED, 25032, 25950, 27666)
	self:AddRecipeRepVendor(47055, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Quick Lionseye -- 47056
	AddRecipe(47056, 375, 35761, Q.EPIC, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(47056, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SCALE_SANDS, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(47056, FAC.SHATTEREDSUN, REP.REVERED, 25032, 25950, 27666)
	self:AddRecipeRepVendor(47056, FAC.SCALE_OF_SANDS, REP.HONORED, 23437)

	-- Brilliant Glass -- 47280
	AddRecipe(47280, 350, 35945, Q.COMMON, V.TBC, 350, 350, 365, 380)
	self:AddRecipeFlags(47280, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(47280, 33614, 26982, 28701, 18774, 26997, 18751, 26915, 19539, 19063, 33590, 33680, 26960)

	-- Purified Shadowsong Amethyst -- 48789
	AddRecipe(48789, 375, 37503, Q.COMMON, V.TBC, 375, 375, 380, 385)
	self:AddRecipeFlags(48789, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(48789, FAC.SHATTEREDSUN, REP.EXALTED, 25950, 27666)

	-- Bold Scarlet Ruby -- 53830
	AddRecipe(53830, 390, 39996, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53830, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53830, 28721, 33602)

	-- Bold Bloodstone -- 53831
	AddRecipe(53831, 350, 39900, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53831, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53831, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Delicate Bloodstone -- 53832
	AddRecipe(53832, 350, 39905, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53832, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53832, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Runed Bloodstone -- 53834
	AddRecipe(53834, 350, 39911, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53834, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53834, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Bright Bloodstone -- 53835
	AddRecipe(53835, 350, 39906, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53835, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53835, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Subtle Bloodstone -- 53843
	AddRecipe(53843, 360, 39907, Q.COMMON, V.WOTLK, 360, 375, 395, 415)
	self:AddRecipeFlags(53843, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeTrainer(53843, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Flashing Bloodstone -- 53844
	AddRecipe(53844, 350, 39908, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53844, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeTrainer(53844, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Fractured Bloodstone -- 53845
	AddRecipe(53845, 350, 39909, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53845, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53845, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Brilliant Sun Crystal -- 53852
	AddRecipe(53852, 350, 39912, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53852, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53852, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Smooth Sun Crystal -- 53853
	AddRecipe(53853, 350, 39914, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53853, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53853, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Rigid Sun Crystal -- 53854
	AddRecipe(53854, 350, 39915, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53854, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53854, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Thick Sun Crystal -- 53855
	AddRecipe(53855, 350, 39916, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53855, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeTrainer(53855, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Quick Sun Crystal -- 53856
	AddRecipe(53856, 350, 39918, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53856, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53856, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Mystic Sun Crystal -- 53857
	AddRecipe(53857, 350, 39917, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53857, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP)
	self:AddRecipeVendor(53857, 34079, 34039)

	-- Sovereign Shadow Crystal -- 53859
	AddRecipe(53859, 350, 39934, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53859, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53859, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Shifting Shadow Crystal -- 53860
	AddRecipe(53860, 350, 39935, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53860, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53860, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Tenuous Shadow Crystal -- 53861
	AddRecipe(53861, 350, 39942, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53861, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53861, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Glowing Shadow Crystal -- 53862
	AddRecipe(53862, 350, 39936, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53862, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53862, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Purified Shadow Crystal -- 53863
	AddRecipe(53863, 350, 39941, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53863, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53863, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Royal Shadow Crystal -- 53864
	AddRecipe(53864, 350, 39943, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53864, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53864, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Mysterious Shadow Crystal -- 53865
	AddRecipe(53865, 350, 39945, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53865, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53865, 34079, 34039)

	-- Balanced Shadow Crystal -- 53866
	AddRecipe(53866, 350, 39937, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53866, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53866, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Infused Shadow Crystal -- 53867
	AddRecipe(53867, 350, 39944, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53867, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53867, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Regal Shadow Crystal -- 53868
	AddRecipe(53868, 360, 39938, Q.COMMON, V.WOTLK, 360, 375, 395, 415)
	self:AddRecipeFlags(53868, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeTrainer(53868, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Defender's Shadow Crystal -- 53869
	AddRecipe(53869, 350, 39939, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53869, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.KALUAK)
	self:AddRecipeRepVendor(53869, FAC.KALUAK, REP.HONORED, 31916, 32763)

	-- Puissant Shadow Crystal -- 53870
	AddRecipe(53870, 350, 39933, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53870, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53870, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Guardian's Shadow Crystal -- 53871
	AddRecipe(53871, 350, 39940, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53871, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeTrainer(53871, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Inscribed Huge Citrine -- 53872
	AddRecipe(53872, 350, 39947, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53872, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53872, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Etched Huge Citrine -- 53873
	AddRecipe(53873, 350, 39948, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53873, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53873, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Champion's Huge Citrine -- 53874
	AddRecipe(53874, 350, 39949, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53874, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeTrainer(53874, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Resplendent Huge Citrine -- 53875
	AddRecipe(53875, 350, 39950, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53875, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53875, 34079, 34039)

	-- Fierce Huge Citrine -- 53876
	AddRecipe(53876, 350, 39951, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53876, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53876, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Deadly Huge Citrine -- 53877
	AddRecipe(53877, 350, 39952, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53877, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.EBONBLADE)
	self:AddRecipeRepVendor(53877, FAC.EBONBLADE, REP.FRIENDLY, 32538)

	-- Glinting Huge Citrine -- 53878
	AddRecipe(53878, 350, 39953, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53878, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53878, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Lucent Huge Citrine -- 53879
	AddRecipe(53879, 350, 39954, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53879, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53879, 34079, 34039)

	-- Deft Huge Citrine -- 53880
	AddRecipe(53880, 350, 39955, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53880, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53880, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Luminous Huge Citrine -- 53881
	AddRecipe(53881, 350, 39946, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53881, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53881, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Potent Huge Citrine -- 53882
	AddRecipe(53882, 350, 39956, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53882, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53882, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Veiled Huge Citrine -- 53883
	AddRecipe(53883, 350, 39957, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53883, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53883, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Durable Huge Citrine -- 53884
	AddRecipe(53884, 350, 39958, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53884, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53884, 34079, 34039)

	-- Reckless Huge Citrine -- 53885
	AddRecipe(53885, 350, 39959, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53885, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.FRENZYHEART)
	self:AddRecipeRepVendor(53885, FAC.FRENZYHEART, REP.FRIENDLY, 31911)

	-- Wicked Huge Citrine -- 53886
	AddRecipe(53886, 350, 39960, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53886, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53886, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Pristine Huge Citrine -- 53887
	AddRecipe(53887, 350, 39961, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53887, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53887, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Empowered Huge Citrine -- 53888
	AddRecipe(53888, 350, 39962, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53888, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53888, 34079, 34039)

	-- Stark Huge Citrine -- 53889
	AddRecipe(53889, 350, 39963, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53889, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53889, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Stalwart Huge Citrine -- 53890
	AddRecipe(53890, 350, 39964, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53890, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeTrainer(53890, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Glimmering Huge Citrine -- 53891
	AddRecipe(53891, 360, 39965, Q.COMMON, V.WOTLK, 360, 375, 395, 415)
	self:AddRecipeFlags(53891, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeTrainer(53891, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Accurate Huge Citrine -- 53892
	AddRecipe(53892, 350, 39966, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53892, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeTrainer(53892, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Resolute Huge Citrine -- 53893
	AddRecipe(53893, 350, 39967, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53893, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeTrainer(53893, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Timeless Dark Jade -- 53894
	AddRecipe(53894, 350, 39968, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53894, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53894, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Jagged Dark Jade -- 53916
	AddRecipe(53916, 350, 39974, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53916, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53916, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Vivid Dark Jade -- 53917
	AddRecipe(53917, 350, 39975, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53917, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ORACLES)
	self:AddRecipeRepVendor(53917, FAC.ORACLES, REP.FRIENDLY, 31910)

	-- Enduring Dark Jade -- 53918
	AddRecipe(53918, 350, 39976, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53918, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeTrainer(53918, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Steady Dark Jade -- 53919
	AddRecipe(53919, 350, 39977, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53919, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP)
	self:AddRecipeVendor(53919, 34079, 34039)

	-- Forceful Dark Jade -- 53920
	AddRecipe(53920, 350, 39978, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53920, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53920, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Seer's Dark Jade -- 53921
	AddRecipe(53921, 350, 39979, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53921, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.KALUAK)
	self:AddRecipeRepVendor(53921, FAC.KALUAK, REP.FRIENDLY, 31916, 32763)

	-- Misty Dark Jade -- 53922
	AddRecipe(53922, 350, 39980, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53922, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53922, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Shining Dark Jade -- 53923
	AddRecipe(53923, 350, 39981, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53923, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53923, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Turbid Dark Jade -- 53924
	AddRecipe(53924, 350, 39982, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53924, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53924, 34079, 34039)

	-- Intricate Dark Jade -- 53925
	AddRecipe(53925, 350, 39983, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53925, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53925, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Dazzling Dark Jade -- 53926
	AddRecipe(53926, 350, 39984, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53926, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53926, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Sundered Dark Jade -- 53927
	AddRecipe(53927, 350, 39985, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53927, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53927, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Lambent Dark Jade -- 53928
	AddRecipe(53928, 350, 39986, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53928, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53928, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Opaque Dark Jade -- 53929
	AddRecipe(53929, 350, 39988, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53929, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53929, 34079, 34039)

	-- Energized Dark Jade -- 53930
	AddRecipe(53930, 350, 39989, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53930, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53930, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Radiant Dark Jade -- 53931
	AddRecipe(53931, 350, 39990, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53931, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeTrainer(53931, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Tense Dark Jade -- 53932
	AddRecipe(53932, 350, 39991, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53932, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeVendor(53932, 34079, 34039)

	-- Shattered Dark Jade -- 53933
	AddRecipe(53933, 350, 39992, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53933, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeVendor(53933, 34079, 34039)

	-- Solid Chalcedony -- 53934
	AddRecipe(53934, 350, 39919, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53934, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53934, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Sparkling Chalcedony -- 53940
	AddRecipe(53940, 350, 39920, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53940, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53940, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Lustrous Chalcedony -- 53941
	AddRecipe(53941, 350, 39927, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53941, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53941, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Stormy Chalcedony -- 53943
	AddRecipe(53943, 350, 39927, Q.UNCOMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(53943, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeVendor(53943, 34079, 34039)

	-- Delicate Scarlet Ruby -- 53945
	AddRecipe(53945, 390, 39997, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53945, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53945, 28721, 33602)

	-- Runed Scarlet Ruby -- 53946
	AddRecipe(53946, 390, 39998, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53946, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.KIRINTOR)
	self:AddRecipeRepVendor(53946, FAC.KIRINTOR, REP.EXALTED, 32287)

	-- Bright Scarlet Ruby -- 53947
	AddRecipe(53947, 390, 39999, Q.COMMON, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53947, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53947, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Subtle Scarlet Ruby -- 53948
	AddRecipe(53948, 390, 40000, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53948, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(53948, 28721, 33602)

	-- Flashing Scarlet Ruby -- 53949
	AddRecipe(53949, 390, 40001, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53949, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(53949, 28721, 33602)

	-- Fractured Scarlet Ruby -- 53950
	AddRecipe(53950, 390, 40002, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53950, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeMobDrop(53950, 29570)

	-- Precise Scarlet Ruby -- 53951
	AddRecipe(53951, 390, 40003, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53951, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeMobDrop(53951, 29311)

	-- Solid Sky Sapphire -- 53952
	AddRecipe(53952, 390, 40008, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53952, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(53952, 28721, 33602)

	-- Sparkling Sky Sapphire -- 53953
	AddRecipe(53953, 390, 40009, Q.COMMON, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53953, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53953, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Lustrous Sky Sapphire -- 53954
	AddRecipe(53954, 390, 40010, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53954, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53954, 28721, 33602)

	-- Stormy Sky Sapphire -- 53955
	AddRecipe(53955, 390, 40011, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53955, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeVendor(53955, 32296, 32294, 30489)

	-- Brilliant Autumn's Glow -- 53956
	AddRecipe(53956, 390, 40012, Q.COMMON, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53956, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53956, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Smooth Autumn's Glow -- 53957
	AddRecipe(53957, 390, 40013, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53957, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HODIR)
	self:AddRecipeRepVendor(53957, FAC.HODIR, REP.EXALTED, 32540)

	-- Rigid Autumn's Glow -- 53958
	AddRecipe(53958, 390, 40014, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53958, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(53958, 28721, 33602)

	-- Thick Autumn's Glow -- 53959
	AddRecipe(53959, 390, 40015, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53959, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeMobDrop(53959, 31134)

	-- Mystic Autumn's Glow -- 53960
	AddRecipe(53960, 390, 40016, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53960, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP)
	self:AddRecipeVendor(53960, 32296, 32294, 30489)

	-- Quick Autumn's Glow -- 53961
	AddRecipe(53961, 390, 40017, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53961, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(53961, 28721, 33602)

	-- Sovereign Twilight Opal -- 53962
	AddRecipe(53962, 390, 40022, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53962, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(53962, "Northrend")

	-- Shifting Twilight Opal -- 53963
	AddRecipe(53963, 390, 40023, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53963, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53963, 28721, 33602)

	-- Tenuous Twilight Opal -- 53964
	AddRecipe(53964, 390, 40024, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53964, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(53964, "Northrend")

	-- Glowing Twilight Opal -- 53965
	AddRecipe(53965, 390, 40025, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53965, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.EBONBLADE)
	self:AddRecipeRepVendor(53965, FAC.EBONBLADE, REP.EXALTED, 32538)

	-- Purified Twilight Opal -- 53966
	AddRecipe(53966, 390, 40026, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53966, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(53966, "Northrend")

	-- Royal Twilight Opal -- 53967
	AddRecipe(53967, 390, 40027, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53967, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53967, 28721, 33602)

	-- Mysterious Twilight Opal -- 53968
	AddRecipe(53968, 390, 40028, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53968, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53968, 32296, 32294, 30489)

	-- Balanced Twilight Opal -- 53969
	AddRecipe(53969, 390, 40029, Q.COMMON, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53969, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53969, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Infused Twilight Opal -- 53970
	AddRecipe(53970, 390, 40030, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53970, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeMobDrop(53970, 29120)

	-- Regal Twilight Opal -- 53971
	AddRecipe(53971, 390, 40031, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53971, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(53971, 28721, 33602)

	-- Defender's Twilight Opal -- 53972
	AddRecipe(53972, 390, 40032, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53972, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeMobDrop(53972, 30208, 29370, 30222, 29376)

	-- Puissant Twilight Opal -- 53973
	AddRecipe(53973, 390, 40033, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53973, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53973, 28721, 33602)

	-- Guardian's Twilight Opal -- 53974
	AddRecipe(53974, 390, 40034, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53974, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TANK, F.ARGENTCRUSADE)
	self:AddRecipeRepVendor(53974, FAC.ARGENTCRUSADE, REP.REVERED, 30431)

	-- Inscribed Monarch Topaz -- 53975
	AddRecipe(53975, 390, 40037, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53975, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(53975, "Northrend")

	-- Etched Monarch Topaz -- 53976
	AddRecipe(53976, 390, 40038, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53976, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(53976, "Northrend")

	-- Champion's Monarch Topaz -- 53977
	AddRecipe(53977, 390, 40039, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53977, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.TANK)
	self:AddRecipeWorldDrop(53977, "Northrend")

	-- Resplendent Monarch Topaz -- 53978
	AddRecipe(53978, 390, 40040, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53978, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53978, 32296, 32294, 30489)

	-- Deadly Monarch Topaz -- 53979
	AddRecipe(53979, 390, 40043, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53979, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeMobDrop(53979, 26723)

	-- Glinting Monarch Topaz -- 53980
	AddRecipe(53980, 390, 40044, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53980, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53980, 28721, 33602)

	-- Lucent Monarch Topaz -- 53981
	AddRecipe(53981, 390, 40045, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53981, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53981, 32296, 32294, 30489)

	-- Deft Monarch Topaz -- 53982
	AddRecipe(53982, 390, 40046, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53982, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeMobDrop(53982, 27978)

	-- Luminous Monarch Topaz -- 53983
	AddRecipe(53983, 390, 40047, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53983, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53983, 28721, 33602)

	-- Potent Monarch Topaz -- 53984
	AddRecipe(53984, 390, 40048, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53984, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53984, 28721, 33602)

	-- Veiled Monarch Topaz -- 53985
	AddRecipe(53985, 390, 40049, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53985, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53985, 28721, 33602)

	-- Durable Monarch Topaz -- 53986
	AddRecipe(53986, 390, 40050, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53986, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53986, 32296, 32294, 30489)

	-- Reckless Monarch Topaz -- 53987
	AddRecipe(53987, 390, 40051, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53987, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(53987, 28721, 33602)

	-- Wicked Monarch Topaz -- 53988
	AddRecipe(53988, 390, 40052, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53988, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.EBONBLADE)
	self:AddRecipeRepVendor(53988, FAC.EBONBLADE, REP.REVERED, 32538)

	-- Pristine Monarch Topaz -- 53989
	AddRecipe(53989, 390, 40053, Q.COMMON, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53989, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53989, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Empowered Monarch Topaz -- 53990
	AddRecipe(53990, 390, 40054, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53990, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53990, 32296, 32294, 30489)

	-- Stark Monarch Topaz -- 53991
	AddRecipe(53991, 390, 40055, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53991, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(53991, 28721, 33602)

	-- Stalwart Monarch Topaz -- 53992
	AddRecipe(53992, 390, 40056, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53992, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.TANK)
	self:AddRecipeWorldDrop(53992, "Northrend")

	-- Glimmering Monarch Topaz -- 53993
	AddRecipe(53993, 390, 40057, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53993, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.WYRMREST)
	self:AddRecipeRepVendor(53993, FAC.WYRMREST, REP.EXALTED, 32533)

	-- Accurate Monarch Topaz -- 53994
	AddRecipe(53994, 390, 40058, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53994, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeMobDrop(53994, 30260, 28379, 29402, 28851, 30448)

	-- Timeless Forest Emerald -- 53995
	AddRecipe(53995, 390, 40085, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53995, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeMobDrop(53995, 26632)

	-- Jagged Forest Emerald -- 53996
	AddRecipe(53996, 390, 40086, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53996, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.FRENZYHEART)
	self:AddRecipeRepVendor(53996, FAC.FRENZYHEART, REP.REVERED, 31911)

	-- Vivid Forest Emerald -- 53997
	AddRecipe(53997, 390, 40088, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53997, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(53997, 28721, 33602)

	-- Enduring Forest Emerald -- 53998
	AddRecipe(53998, 390, 40089, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(53998, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(53998, 28721, 33602)

	-- Steady Forest Emerald -- 54000
	AddRecipe(54000, 390, 40090, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54000, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP)
	self:AddRecipeVendor(54000, 32296, 32294, 30489)

	-- Forceful Forest Emerald -- 54001
	AddRecipe(54001, 390, 40091, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54001, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(54001, 28721, 33602)

	-- Seer's Forest Emerald -- 54002
	AddRecipe(54002, 390, 40092, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54002, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(54002, 28721, 33602)

	-- Misty Forest Emerald -- 54003
	AddRecipe(54003, 390, 40095, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54003, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(54003, "Northrend")

	-- Shining Forest Emerald -- 54004
	AddRecipe(54004, 390, 40099, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54004, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(54004, "Northrend")

	-- Turbid Forest Emerald -- 54005
	AddRecipe(54005, 390, 40102, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54005, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(54005, 32296, 32294, 30489)

	-- Intricate Forest Emerald -- 54006
	AddRecipe(54006, 390, 40104, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54006, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(54006, 28721, 33602)

	-- Dazzling Forest Emerald -- 54007
	AddRecipe(54007, 390, 40094, Q.COMMON, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54007, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(54007, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Sundered Forest Emerald -- 54008
	AddRecipe(54008, 390, 40096, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54008, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ORACLES)
	self:AddRecipeRepVendor(54008, FAC.ORACLES, REP.REVERED, 31910)

	-- Lambent Forest Emerald -- 54009
	AddRecipe(54009, 390, 40100, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54009, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(54009, 28721, 33602)

	-- Opaque Forest Emerald -- 54010
	AddRecipe(54010, 390, 40103, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54010, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(54010, 32296, 32294, 30489)

	-- Energized Forest Emerald -- 54011
	AddRecipe(54011, 390, 40105, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54011, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(54011, 28721, 33602)

	-- Radiant Forest Emerald -- 54012
	AddRecipe(54012, 390, 40098, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54012, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeMobDrop(54012, 29792, 29793)

	-- Tense Forest Emerald -- 54013
	AddRecipe(54013, 390, 40101, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54013, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeVendor(54013, 32296, 32294, 30489)

	-- Shattered Forest Emerald -- 54014
	AddRecipe(54014, 390, 40106, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54014, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeVendor(54014, 32296, 32294, 30489)

	-- Precise Bloodstone -- 54017
	AddRecipe(54017, 350, 39910, Q.COMMON, V.WOTLK, 350, 375, 395, 415)
	self:AddRecipeFlags(54017, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeTrainer(54017, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Fierce Monarch Topaz -- 54019
	AddRecipe(54019, 390, 40041, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54019, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeMobDrop(54019, 23954)

	-- Resolute Monarch Topaz -- 54023
	AddRecipe(54023, 390, 40059, Q.RARE, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(54023, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.TANK)
	self:AddRecipeWorldDrop(54023, "Northrend")

	-- Effulgent Skyflare Diamond -- 55384
	AddRecipe(55384, 420, 41377, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55384, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(55384, 28721, 33602)

	-- Tireless Skyflare Diamond -- 55386
	AddRecipe(55386, 420, 41375, Q.COMMON, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55386, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(55386, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Forlorn Skyflare Diamond -- 55387
	AddRecipe(55387, 420, 41378, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55387, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(55387, 32296, 32294, 30489)

	-- Impassive Skyflare Diamond -- 55388
	AddRecipe(55388, 420, 41379, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55388, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP)
	self:AddRecipeVendor(55388, 32296, 32294, 30489)

	-- Chaotic Skyflare Diamond -- 55389
	AddRecipe(55389, 420, 41285, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55389, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(55389, 28721, 33602)

	-- Destructive Skyflare Diamond -- 55390
	AddRecipe(55390, 420, 41307, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55390, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(55390, "Northrend")

	-- Ember Skyflare Diamond -- 55392
	AddRecipe(55392, 420, 41333, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55392, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(55392, 28721, 33602)

	-- Enigmatic Skyflare Diamond -- 55393
	AddRecipe(55393, 420, 41335, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55393, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP)
	self:AddRecipeVendor(55393, 32296, 32294, 30489)

	-- Swift Skyflare Diamond -- 55394
	AddRecipe(55394, 420, 41339, Q.COMMON, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55394, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(55394, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Thundering Skyflare Diamond -- 55395
	AddRecipe(55395, 420, 41400, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55395, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(55395, "Northrend")

	-- Insightful Earthsiege Diamond -- 55396
	AddRecipe(55396, 420, 41401, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55396, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(55396, 28721, 33602)

	-- Bracing Earthsiege Diamond -- 55397
	AddRecipe(55397, 420, 41395, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55397, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeMobDrop(55397, 27656)

	-- Eternal Earthsiege Diamond -- 55398
	AddRecipe(55398, 420, 41396, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55398, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeMobDrop(55398, 28923)

	-- Powerful Earthsiege Diamond -- 55399
	AddRecipe(55399, 420, 41397, Q.COMMON, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55399, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(55399, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Relentless Earthsiege Diamond -- 55400
	AddRecipe(55400, 420, 41398, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55400, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(55400, 28721, 33602)

	-- Austere Earthsiege Diamond -- 55401
	AddRecipe(55401, 420, 41380, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55401, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(55401, 26861)

	-- Persistent Earthsiege Diamond -- 55402
	AddRecipe(55402, 420, 41381, Q.COMMON, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55402, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(55402, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Trenchant Earthsiege Diamond -- 55403
	AddRecipe(55403, 420, 41382, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55403, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(55403, 28721, 33602)

	-- Invigorating Earthsiege Diamond -- 55404
	AddRecipe(55404, 420, 41385, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55404, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(55404, 28721, 33602)

	-- Beaming Earthsiege Diamond -- 55405
	AddRecipe(55405, 420, 41389, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55405, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(55405, "Northrend")

	-- Revitalizing Skyflare Diamond -- 55407
	AddRecipe(55407, 420, 41376, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(55407, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(55407, 28721, 33602)

	-- Bold Dragon's Eye -- 56049
	AddRecipe(56049, 370, 42142, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56049, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS)
	self:AddRecipeVendor(56049, 28721, 33602)

	-- Delicate Dragon's Eye -- 56052
	AddRecipe(56052, 370, 42143, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56052, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS)
	self:AddRecipeVendor(56052, 28721, 33602)

	-- Runed Dragon's Eye -- 56053
	AddRecipe(56053, 370, 42144, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56053, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(56053, 28721, 33602)

	-- Bright Dragon's Eye -- 56054
	AddRecipe(56054, 370, 36766, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56054, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS)
	self:AddRecipeVendor(56054, 28721, 33602)

	-- Subtle Dragon's Eye -- 56055
	AddRecipe(56055, 370, 42151, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56055, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.TANK)
	self:AddRecipeVendor(56055, 28721, 33602)

	-- Flashing Dragon's Eye -- 56056
	AddRecipe(56056, 370, 42152, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56056, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.TANK)
	self:AddRecipeVendor(56056, 28721, 33602)

	-- Brilliant Dragon's Eye -- 56074
	AddRecipe(56074, 370, 42148, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56074, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(56074, 28721, 33602)

	-- Fractured Dragon's Eye -- 56076
	AddRecipe(56076, 370, 42153, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56076, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS)
	self:AddRecipeVendor(56076, 28721, 33602)

	-- Lustrous Dragon's Eye -- 56077
	AddRecipe(56077, 370, 42146, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56077, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(56077, 28721, 33602)

	-- Mystic Dragon's Eye -- 56079
	AddRecipe(56079, 370, 42158, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56079, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP)
	self:AddRecipeVendor(56079, 28721, 33602)

	-- Precise Dragon's Eye -- 56081
	AddRecipe(56081, 370, 42154, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56081, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeVendor(56081, 28721, 33602)

	-- Quick Dragon's Eye -- 56083
	AddRecipe(56083, 370, 42150, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56083, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP)
	self:AddRecipeVendor(56083, 28721, 33602)

	-- Rigid Dragon's Eye -- 56084
	AddRecipe(56084, 370, 42156, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56084, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP)
	self:AddRecipeVendor(56084, 28721, 33602)

	-- Smooth Dragon's Eye -- 56085
	AddRecipe(56085, 370, 42149, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56085, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP)
	self:AddRecipeVendor(56085, 28721, 33602)

	-- Solid Dragon's Eye -- 56086
	AddRecipe(56086, 370, 36767, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56086, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP)
	self:AddRecipeVendor(56086, 28721, 33602)

	-- Sparkling Dragon's Eye -- 56087
	AddRecipe(56087, 370, 42145, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56087, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(56087, 28721, 33602)

	-- Stormy Dragon's Eye -- 56088
	AddRecipe(56088, 370, 42155, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56088, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.CASTER)
	self:AddRecipeVendor(56088, 28721, 33602)

	-- Thick Dragon's Eye -- 56089
	AddRecipe(56089, 370, 42157, Q.RARE, V.WOTLK, 370, 390, 415, 440)
	self:AddRecipeFlags(56089, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.TANK)
	self:AddRecipeVendor(56089, 28721, 33602)

	-- Bloodstone Band -- 56193
	AddRecipe(56193, 350, 42336, Q.COMMON, V.WOTLK, 350, 380, 400, 420)
	self:AddRecipeFlags(56193, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(56193, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Sun Rock Ring -- 56194
	AddRecipe(56194, 350, 42337, Q.COMMON, V.WOTLK, 350, 380, 400, 420)
	self:AddRecipeFlags(56194, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(56194, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Jade Dagger Pendant -- 56195
	AddRecipe(56195, 380, 42338, Q.COMMON, V.WOTLK, 380, 400, 410, 420)
	self:AddRecipeFlags(56195, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.NECK)
	self:AddRecipeTrainer(56195, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Blood Sun Necklace -- 56196
	AddRecipe(56196, 380, 42339, Q.COMMON, V.WOTLK, 380, 400, 410, 420)
	self:AddRecipeFlags(56196, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeTrainer(56196, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Dream Signet -- 56197
	AddRecipe(56197, 420, 42340, Q.COMMON, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(56197, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(56197, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Ruby Hare -- 56199
	AddRecipe(56199, 400, 42341, Q.COMMON, V.WOTLK, 400, 430, 440, 450)
	self:AddRecipeFlags(56199, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.TRINKET)
	self:AddRecipeTrainer(56199, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Twilight Serpent -- 56201
	AddRecipe(56201, 400, 42395, Q.COMMON, V.WOTLK, 400, 430, 440, 450)
	self:AddRecipeFlags(56201, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET)
	self:AddRecipeTrainer(56201, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Sapphire Owl -- 56202
	AddRecipe(56202, 400, 42413, Q.COMMON, V.WOTLK, 400, 430, 440, 450)
	self:AddRecipeFlags(56202, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET)
	self:AddRecipeTrainer(56202, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Emerald Boar -- 56203
	AddRecipe(56203, 400, 42418, Q.COMMON, V.WOTLK, 400, 430, 440, 450)
	self:AddRecipeFlags(56203, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.TRINKET)
	self:AddRecipeTrainer(56203, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Dark Jade Focusing Lens -- 56205
	AddRecipe(56205, 350, 41367, Q.COMMON, V.WOTLK, 350, 360, 370, 380)
	self:AddRecipeFlags(56205, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(56205, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Shadow Crystal Focusing Lens -- 56206
	AddRecipe(56206, 360, 42420, Q.COMMON, V.WOTLK, 360, 370, 380, 390)
	self:AddRecipeFlags(56206, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(56206, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Shadow Jade Focusing Lens -- 56208
	AddRecipe(56208, 370, 42421, Q.COMMON, V.WOTLK, 370, 380, 390, 400)
	self:AddRecipeFlags(56208, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(56208, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Titanium Impact Band -- 56496
	AddRecipe(56496, 430, 42642, Q.EPIC, V.WOTLK, 430, 450, 455, 460)
	self:AddRecipeFlags(56496, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeVendor(56496, 28721, 33602)

	-- Titanium Earthguard Ring -- 56497
	AddRecipe(56497, 430, 42643, Q.EPIC, V.WOTLK, 430, 450, 455, 460)
	self:AddRecipeFlags(56497, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.RING)
	self:AddRecipeVendor(56497, 28721, 33602)

	-- Titanium Spellshock Ring -- 56498
	AddRecipe(56498, 430, 42644, Q.EPIC, V.WOTLK, 430, 450, 455, 460)
	self:AddRecipeFlags(56498, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeVendor(56498, 28721, 33602)

	-- Titanium Impact Choker -- 56499
	AddRecipe(56499, 440, 42645, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(56499, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.NECK)
	self:AddRecipeVendor(56499, 28721, 33602)

	-- Titanium Earthguard Chain -- 56500
	AddRecipe(56500, 440, 42646, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(56500, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.NECK)
	self:AddRecipeVendor(56500, 28721, 33602)

	-- Titanium Spellshock Necklace -- 56501
	AddRecipe(56501, 440, 42647, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(56501, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeVendor(56501, 28721, 33602)

	-- Enchanted Pearl -- 56530
	AddRecipe(56530, 360, 42701, Q.COMMON, V.WOTLK, 360, 380, 400, 420)
	self:AddRecipeFlags(56530, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(56530, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Enchanted Tear -- 56531
	AddRecipe(56531, 390, 42702, Q.COMMON, V.WOTLK, 390, 410, 425, 440)
	self:AddRecipeFlags(56531, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(56531, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Crystal Citrine Necklace -- 58141
	AddRecipe(58141, 350, 43244, Q.COMMON, V.WOTLK, 350, 380, 400, 420)
	self:AddRecipeFlags(58141, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeTrainer(58141, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Crystal Chalcedony Amulet -- 58142
	AddRecipe(58142, 350, 43245, Q.COMMON, V.WOTLK, 350, 380, 400, 420)
	self:AddRecipeFlags(58142, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.NECK)
	self:AddRecipeTrainer(58142, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Earthshadow Ring -- 58143
	AddRecipe(58143, 370, 43246, Q.COMMON, V.WOTLK, 370, 390, 405, 420)
	self:AddRecipeFlags(58143, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(58143, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Jade Ring of Slaying -- 58144
	AddRecipe(58144, 370, 43247, Q.COMMON, V.WOTLK, 370, 390, 405, 420)
	self:AddRecipeFlags(58144, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.TANK, F.RING)
	self:AddRecipeTrainer(58144, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Stoneguard Band -- 58145
	AddRecipe(58145, 390, 43248, Q.COMMON, V.WOTLK, 390, 410, 420, 430)
	self:AddRecipeFlags(58145, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK, F.RING)
	self:AddRecipeTrainer(58145, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Shadowmight Ring -- 58146
	AddRecipe(58146, 390, 43249, Q.COMMON, V.WOTLK, 390, 410, 420, 430)
	self:AddRecipeFlags(58146, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeTrainer(58146, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Ring of Earthen Might -- 58147
	AddRecipe(58147, 420, 43250, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(58147, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TANK, F.RING)
	self:AddRecipeVendor(58147, 28721, 33602)

	-- Ring of Scarlet Shadows -- 58148
	AddRecipe(58148, 420, 43251, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(58148, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeVendor(58148, 28721, 33602)

	-- Windfire Band -- 58149
	AddRecipe(58149, 420, 43252, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(58149, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeVendor(58149, 28721, 33602)

	-- Ring of Northern Tears -- 58150
	AddRecipe(58150, 420, 43253, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(58150, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeVendor(58150, 28721, 33602)

	-- Savage Titanium Ring -- 58492
	AddRecipe(58492, 420, 43482, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(58492, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeVendor(58492, 28721, 33602)

	-- Savage Titanium Band -- 58507
	AddRecipe(58507, 420, 43498, Q.RARE, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(58507, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeVendor(58507, 28721, 33602)

	-- Titanium Frostguard Ring -- 58954
	AddRecipe(58954, 420, 43582, Q.EPIC, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(58954, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.RING)
	self:AddRecipeVendor(58954, 28721, 33602)

	-- Monarch Crab -- 59759
	AddRecipe(59759, 400, 44063, Q.COMMON, V.WOTLK, 400, 430, 440, 450)
	self:AddRecipeFlags(59759, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.TANK, F.TRINKET)
	self:AddRecipeTrainer(59759, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Icy Prism -- 62242
	AddRecipe(62242, 425, 44943, Q.COMMON, V.WOTLK, 425, 445, 457, 470)
	self:AddRecipeFlags(62242, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(62242, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Prismatic Black Diamond -- 62941
	AddRecipe(62941, 300, 45054, Q.COMMON, V.WOTLK, 300, 310, 315, 320)
	self:AddRecipeFlags(62941, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(62941, 33614, 26982, 33590, 28701, 26997, 18751, 26915, 18774, 19063, 19539, 33680, 26960)

	-- Amulet of Truesight -- 63743
	AddRecipe(63743, 200, 45627, Q.COMMON, V.WOTLK, 200, 210, 220, 230)
	self:AddRecipeFlags(63743, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.NECK)
	self:AddRecipeTrainer(63743, 26982, 33614, 28701, 26915, 26960, 15501, 19778, 26997, 18751, 19775, 18774, 19063, 19539, 33680, 33590)

	-- Emerald Choker -- 64725
	AddRecipe(64725, 420, 45812, Q.COMMON, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(64725, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.NECK)
	self:AddRecipeTrainer(64725, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Sky Sapphire Amulet -- 64726
	AddRecipe(64726, 420, 45813, Q.COMMON, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(64726, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.NECK)
	self:AddRecipeTrainer(64726, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Runed Mana Band -- 64727
	AddRecipe(64727, 420, 45808, Q.COMMON, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(64727, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.RING)
	self:AddRecipeTrainer(64727, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Scarlet Signet -- 64728
	AddRecipe(64728, 420, 45809, Q.COMMON, V.WOTLK, 420, 440, 450, 460)
	self:AddRecipeFlags(64728, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.RING)
	self:AddRecipeTrainer(64728, 26915, 28701, 33590, 26960, 26982, 26997)

	-- Enduring Eye of Zul -- 66338
	AddRecipe(66338, 450, 40167, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66338, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(66338, 33637, 33680, 28701, 19065)

	-- Steady Eye of Zul -- 66428
	AddRecipe(66428, 450, 40168, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66428, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(66428, 33637, 33680, 28701, 19065)

	-- Vivid Eye of Zul -- 66429
	AddRecipe(66429, 450, 40166, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66429, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(66429, 33637, 33680, 28701, 19065)

	-- Dazzling Eye of Zul -- 66430
	AddRecipe(66430, 450, 40175, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66430, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66430, 33637, 33680, 28701, 19065)

	-- Jagged Eye of Zul -- 66431
	AddRecipe(66431, 450, 40165, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66431, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(66431, 33637, 33680, 28701, 19065)

	-- Timeless Eye of Zul -- 66432
	AddRecipe(66432, 450, 40164, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66432, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66432, 33637, 33680, 28701, 19065)

	-- Seer's Eye of Zul -- 66433
	AddRecipe(66433, 450, 40170, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66433, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66433, 33637, 33680, 28701, 19065)

	-- Forceful Eye of Zul -- 66434
	AddRecipe(66434, 450, 40169, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66434, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(66434, 33637, 33680, 28701, 19065)

	-- Misty Eye of Zul -- 66435
	AddRecipe(66435, 450, 40171, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66435, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66435, 33637, 33680, 28701, 19065)

	-- Sundered Eye of Zul -- 66436
	AddRecipe(66436, 450, 40176, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66436, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66436, 33637, 33680, 28701, 19065)

	-- Shining Eye of Zul -- 66437
	AddRecipe(66437, 450, 40172, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66437, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66437, 33637, 33680, 28701, 19065)

	-- Tense Eye of Zul -- 66438
	AddRecipe(66438, 450, 40181, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66438, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeVendor(66438, 33637, 33680, 28701, 19065)

	-- Lambent Eye of Zul -- 66439
	AddRecipe(66439, 450, 40177, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66439, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66439, 33637, 33680, 28701, 19065)

	-- Intricate Eye of Zul -- 66440
	AddRecipe(66440, 450, 40174, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66440, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66440, 33637, 33680, 28701, 19065)

	-- Radiant Eye of Zul -- 66441
	AddRecipe(66441, 450, 40180, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66441, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeVendor(66441, 33637, 33680, 28701, 19065)

	-- Energized Eye of Zul -- 66442
	AddRecipe(66442, 450, 40179, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66442, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66442, 33637, 33680, 28701, 19065)

	-- Shattered Eye of Zul -- 66443
	AddRecipe(66443, 450, 40182, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66443, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeVendor(66443, 33637, 33680, 28701, 19065)

	-- Opaque Eye of Zul -- 66444
	AddRecipe(66444, 450, 40178, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66444, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66444, 33637, 33680, 28701, 19065)

	-- Turbid Eye of Zul -- 66445
	AddRecipe(66445, 450, 40173, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66445, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66445, 33637, 33680, 28701, 19065)

	-- Runed Cardinal Ruby -- 66446
	AddRecipe(66446, 450, 40113, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66446, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66446, 33637, 33680, 28701, 19065)

	-- Bold Cardinal Ruby -- 66447
	AddRecipe(66447, 450, 40111, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66447, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66447, 33637, 33680, 28701, 19065)

	-- Delicate Cardinal Ruby -- 66448
	AddRecipe(66448, 450, 40112, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66448, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66448, 33637, 33680, 28701, 19065)

	-- Bright Cardinal Ruby -- 66449
	AddRecipe(66449, 450, 40114, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66449, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66449, 33637, 33680, 28701, 19065)

	-- Precise Cardinal Ruby -- 66450
	AddRecipe(66450, 450, 40118, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66450, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeVendor(66450, 33637, 33680, 28701, 19065)

	-- Fractured Cardinal Ruby -- 66451
	AddRecipe(66451, 450, 40117, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66451, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66451, 33637, 33680, 28701, 19065)

	-- Subtle Cardinal Ruby -- 66452
	AddRecipe(66452, 450, 40115, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66452, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(66452, 33637, 33680, 28701, 19065)

	-- Flashing Cardinal Ruby -- 66453
	AddRecipe(66453, 450, 40116, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66453, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(66453, 33637, 33680, 28701, 19065)

	-- Solid Majestic Zircon -- 66497
	AddRecipe(66497, 450, 40119, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66497, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(66497, 33637, 33680, 28701, 19065)

	-- Sparkling Majestic Zircon -- 66498
	AddRecipe(66498, 450, 40120, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66498, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66498, 33637, 33680, 28701, 19065)

	-- Stormy Majestic Zircon -- 66499
	AddRecipe(66499, 450, 40122, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66499, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CASTER)
	self:AddRecipeVendor(66499, 33637, 33680, 28701, 19065)

	-- Lustrous Majestic Zircon -- 66500
	AddRecipe(66500, 450, 40121, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66500, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66500, 33637, 33680, 28701, 19065)

	-- Rigid King's Amber -- 66501
	AddRecipe(66501, 450, 40125, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66501, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(66501, 33637, 33680, 28701, 19065)

	-- Smooth King's Amber -- 66502
	AddRecipe(66502, 450, 40124, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66502, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(66502, 33637, 33680, 28701, 19065)

	-- Brilliant King's Amber -- 66503
	AddRecipe(66503, 450, 40123, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66503, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66503, 33637, 33680, 28701, 19065)

	-- Thick King's Amber -- 66504
	AddRecipe(66504, 450, 40126, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66504, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(66504, 33637, 33680, 28701, 19065)

	-- Mystic King's Amber -- 66505
	AddRecipe(66505, 450, 40127, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66505, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(66505, 33637, 33680, 28701, 19065)

	-- Quick King's Amber -- 66506
	AddRecipe(66506, 450, 40128, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66506, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(66506, 33637, 33680, 28701, 19065)

	-- Balanced Dreadstone -- 66553
	AddRecipe(66553, 450, 40136, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66553, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66553, 33637, 33680, 28701, 19065)

	-- Sovereign Dreadstone -- 66554
	AddRecipe(66554, 450, 40129, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66554, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66554, 33637, 33680, 28701, 19065)

	-- Glowing Dreadstone -- 66555
	AddRecipe(66555, 450, 40132, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66555, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66555, 33637, 33680, 28701, 19065)

	-- Purified Dreadstone -- 66556
	AddRecipe(66556, 450, 40133, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66556, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66556, 33637, 33680, 28701, 19065)

	-- Shifting Dreadstone -- 66557
	AddRecipe(66557, 450, 40130, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66557, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66557, 33637, 33680, 28701, 19065)

	-- Royal Dreadstone -- 66558
	AddRecipe(66558, 450, 40134, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66558, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66558, 33637, 33680, 28701, 19065)

	-- Regal Dreadstone -- 66559
	AddRecipe(66559, 450, 40138, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66559, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(66559, 33637, 33680, 28701, 19065)

	-- Defender's Dreadstone -- 66560
	AddRecipe(66560, 450, 40139, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66560, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(66560, 33637, 33680, 28701, 19065)

	-- Guardian's Dreadstone -- 66561
	AddRecipe(66561, 450, 40141, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66561, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeVendor(66561, 33637, 33680, 28701, 19065)

	-- Mysterious Dreadstone -- 66562
	AddRecipe(66562, 450, 40135, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66562, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66562, 33637, 33680, 28701, 19065)

	-- Puissant Dreadstone -- 66563
	AddRecipe(66563, 450, 40140, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66563, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66563, 33637, 33680, 28701, 19065)

	-- Infused Dreadstone -- 66564
	AddRecipe(66564, 450, 40137, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66564, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66564, 33637, 33680, 28701, 19065)

	-- Tenuous Dreadstone -- 66565
	AddRecipe(66565, 450, 40131, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66565, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66565, 33637, 33680, 28701, 19065)

	-- Luminous Ametrine -- 66566
	AddRecipe(66566, 450, 40151, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66566, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66566, 33637, 33680, 28701, 19065)

	-- Inscribed Ametrine -- 66567
	AddRecipe(66567, 450, 40142, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66567, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66567, 33637, 33680, 28701, 19065)

	-- Deadly Ametrine -- 66568
	AddRecipe(66568, 450, 40147, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66568, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66568, 33637, 33680, 28701, 19065)

	-- Potent Ametrine -- 66569
	AddRecipe(66569, 450, 40152, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66569, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66569, 33637, 33680, 28701, 19065)

	-- Veiled Ametrine -- 66570
	AddRecipe(66570, 450, 40153, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66570, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66570, 33637, 33680, 28701, 19065)

	-- Durable Ametrine -- 66571
	AddRecipe(66571, 450, 40154, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66571, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66571, 33637, 33680, 28701, 19065)

	-- Etched Ametrine -- 66572
	AddRecipe(66572, 450, 40143, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66572, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66572, 33637, 33680, 28701, 19065)

	-- Pristine Ametrine -- 66573
	AddRecipe(66573, 450, 40157, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66573, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66573, 33637, 33680, 28701, 19065)

	-- Reckless Ametrine -- 66574
	AddRecipe(66574, 450, 40155, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66574, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeVendor(66574, 33637, 33680, 28701, 19065)

	-- Glinting Ametrine -- 66575
	AddRecipe(66575, 450, 40148, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66575, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66575, 33637, 33680, 28701, 19065)

	-- Accurate Ametrine -- 66576
	AddRecipe(66576, 450, 40162, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66576, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeVendor(66576, 33637, 33680, 28701, 19065)

	-- Wicked Ametrine -- 66577
	AddRecipe(66577, 450, 40156, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66577, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66577, 33637, 33680, 28701, 19065)

	-- Glimmering Ametrine -- 66578
	AddRecipe(66578, 450, 40161, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66578, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(66578, 33637, 33680, 28701, 19065)

	-- Champion's Ametrine -- 66579
	AddRecipe(66579, 450, 40144, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66579, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66579, 33637, 33680, 28701, 19065)

	-- Empowered Ametrine -- 66580
	AddRecipe(66580, 450, 40158, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66580, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66580, 33637, 33680, 28701, 19065)

	-- Stalwart Ametrine -- 66581
	AddRecipe(66581, 450, 40160, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66581, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeVendor(66581, 33637, 33680, 28701, 19065)

	-- Resplendent Ametrine -- 66582
	AddRecipe(66582, 450, 40145, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66582, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66582, 33637, 33680, 28701, 19065)

	-- Fierce Ametrine -- 66583
	AddRecipe(66583, 450, 40146, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66583, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66583, 33637, 33680, 28701, 19065)

	-- Deft Ametrine -- 66584
	AddRecipe(66584, 450, 40150, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66584, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66584, 33637, 33680, 28701, 19065)

	-- Lucent Ametrine -- 66585
	AddRecipe(66585, 450, 40149, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66585, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66585, 33637, 33680, 28701, 19065)

	-- Resolute Ametrine -- 66586
	AddRecipe(66586, 450, 40163, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66586, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TANK)
	self:AddRecipeVendor(66586, 33637, 33680, 28701, 19065)

	-- Stark Ametrine -- 66587
	AddRecipe(66587, 450, 40159, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66587, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeVendor(66587, 33637, 33680, 28701, 19065)

	-- Nightmare Tear -- 68253
	AddRecipe(68253, 450, 49110, Q.RARE, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(68253, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(68253, 33637, 33680, 28701, 19065)

	return num_recipes
end
