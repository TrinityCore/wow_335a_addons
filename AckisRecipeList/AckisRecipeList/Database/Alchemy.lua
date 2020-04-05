--[[
************************************************************************
Alchemy.lua
Alchemy data for all of Ackis Recipe List
************************************************************************
File date: 2010-09-07T19:26:37Z
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
	addon:AddRecipe(spell_id, skill_level, item_id, quality, 51304, nil, genesis, optimal_level, medium_level, easy_level, trivial_level)
end

function addon:InitAlchemy()
	if initialized then
		return num_recipes
	end
	initialized = true

	-- Elixir of Lion's Strength -- 2329
	AddRecipe(2329, 1, 2454, Q.COMMON, V.ORIG, 1, 55, 75, 95)
	self:AddRecipeFlags(2329, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeAcquire(2329, A.CUSTOM, 8)

	-- Minor Healing Potion -- 2330
	AddRecipe(2330, 1, 118, Q.COMMON, V.ORIG, 1, 55, 75, 95)
	self:AddRecipeFlags(2330, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(2330, A.CUSTOM, 8)

	-- Minor Mana Potion -- 2331
	AddRecipe(2331, 25, 2455, Q.COMMON, V.ORIG, 25, 65, 85, 105)
	self:AddRecipeFlags(2331, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(2331, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 5499, 16723, 1246, 3603, 16642, 1215, 4611, 2391, 33608, 19052, 16588, 7948, 33674, 3964, 16161, 18802, 3009, 27023, 1470, 5177, 17215)

	-- Minor Rejuvenation Potion -- 2332
	AddRecipe(2332, 40, 2456, Q.COMMON, V.ORIG, 40, 70, 90, 110)
	self:AddRecipeFlags(2332, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(2332, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 5499, 16723, 1246, 3603, 16642, 1215, 4611, 2391, 33608, 19052, 16588, 7948, 33674, 3964, 16161, 18802, 3009, 27023, 1470, 5177, 17215)

	-- Elixir of Lesser Agility -- 2333
	AddRecipe(2333, 140, 3390, Q.UNCOMMON, V.ORIG, 140, 165, 185, 205)
	self:AddRecipeFlags(2333, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(2333, "Kalimdor", "Eastern Kingdoms")

	-- Elixir of Minor Fortitude -- 2334
	AddRecipe(2334, 50, 2458, Q.COMMON, V.ORIG, 50, 80, 100, 120)
	self:AddRecipeFlags(2334, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(2334, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 5499, 16723, 1246, 3603, 16642, 1215, 4611, 2391, 33608, 19052, 16588, 7948, 33674, 3964, 16161, 18802, 3009, 27023, 1470, 5177, 17215)

	-- Swiftness Potion -- 2335
	AddRecipe(2335, 60, 2459, Q.UNCOMMON, V.ORIG, 60, 90, 110, 130)
	self:AddRecipeFlags(2335, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(2335, "Kalimdor", "Eastern Kingdoms")

	-- Lesser Healing Potion -- 2337
	AddRecipe(2337, 55, 858, Q.COMMON, V.ORIG, 55, 85, 105, 125)
	self:AddRecipeFlags(2337, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(2337, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 5499, 16723, 1246, 3603, 16642, 1215, 4611, 2391, 33608, 19052, 16588, 7948, 33674, 3964, 16161, 18802, 3009, 27023, 1470, 5177, 17215)

	-- Weak Troll's Blood Elixir -- 3170
	AddRecipe(3170, 15, 3382, Q.COMMON, V.ORIG, 15, 60, 80, 100)
	self:AddRecipeFlags(3170, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3170, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 5499, 16723, 1246, 3603, 16642, 1215, 4611, 2391, 33608, 19052, 16588, 7948, 33674, 3964, 16161, 18802, 3009, 27023, 1470, 5177, 17215)

	-- Elixir of Wisdom -- 3171
	AddRecipe(3171, 90, 3383, Q.COMMON, V.ORIG, 90, 120, 140, 160)
	self:AddRecipeFlags(3171, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3171, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Minor Magic Resistance Potion -- 3172
	AddRecipe(3172, 110, 3384, Q.COMMON, V.ORIG, 110, 135, 155, 175)
	self:AddRecipeFlags(3172, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(3172, "Kalimdor", "Eastern Kingdoms")

	-- Lesser Mana Potion -- 3173
	AddRecipe(3173, 120, 3385, Q.COMMON, V.ORIG, 120, 145, 165, 185)
	self:AddRecipeFlags(3173, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3173, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Potion of Curing -- 3174
	AddRecipe(3174, 120, 3386, Q.COMMON, V.ORIG, 120, 145, 165, 185)
	self:AddRecipeFlags(3174, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(3174, "Kalimdor", "Eastern Kingdoms")

	-- Limited Invulnerability Potion -- 3175
	AddRecipe(3175, 250, 3387, Q.UNCOMMON, V.ORIG, 250, 275, 295, 315)
	self:AddRecipeFlags(3175, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(3175, "Kalimdor", "Eastern Kingdoms")

	-- Strong Troll's Blood Elixir -- 3176
	AddRecipe(3176, 125, 3388, Q.COMMON, V.ORIG, 125, 150, 170, 190)
	self:AddRecipeFlags(3176, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3176, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Elixir of Defense -- 3177
	AddRecipe(3177, 130, 3389, Q.COMMON, V.ORIG, 130, 155, 175, 195)
	self:AddRecipeFlags(3177, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeTrainer(3177, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Elixir of Ogre's Strength -- 3188
	AddRecipe(3188, 150, 3391, Q.COMMON, V.ORIG, 150, 175, 195, 215)
	self:AddRecipeFlags(3188, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(3188, "Kalimdor", "Eastern Kingdoms")

	-- Elixir of Minor Agility -- 3230
	AddRecipe(3230, 50, 2457, Q.UNCOMMON, V.ORIG, 50, 80, 100, 120)
	self:AddRecipeFlags(3230, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(3230, "Kalimdor", "Eastern Kingdoms")

	-- Healing Potion -- 3447
	AddRecipe(3447, 110, 929, Q.COMMON, V.ORIG, 110, 135, 155, 175)
	self:AddRecipeFlags(3447, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3447, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Lesser Invisibility Potion -- 3448
	AddRecipe(3448, 165, 3823, Q.COMMON, V.ORIG, 165, 185, 205, 225)
	self:AddRecipeFlags(3448, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3448, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 4160, 1215, 4611, 33608, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Shadow Oil -- 3449
	AddRecipe(3449, 165, 3824, Q.COMMON, V.ORIG, 165, 190, 210, 230)
	self:AddRecipeFlags(3449, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(3449, 2481, 1, 4878, 1)

	-- Elixir of Fortitude -- 3450
	AddRecipe(3450, 175, 3825, Q.COMMON, V.ORIG, 175, 195, 215, 235)
	self:AddRecipeFlags(3450, F.ALLIANCE, F.HORDE, F.TRAINER, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(3450, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 4160, 1215, 4611, 33608, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)
	self:AddRecipeWorldDrop(3450, "Kalimdor", "Eastern Kingdoms")

	-- Major Troll's Blood Elixir -- 3451
	AddRecipe(3451, 180, 3826, Q.UNCOMMON, V.ORIG, 180, 200, 220, 240)
	self:AddRecipeFlags(3451, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(3451, "Kalimdor", "Eastern Kingdoms")

	-- Mana Potion -- 3452
	AddRecipe(3452, 160, 3827, Q.COMMON, V.ORIG, 160, 180, 200, 220)
	self:AddRecipeFlags(3452, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3452, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 4160, 1215, 4611, 33608, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Elixir of Detect Lesser Invisibility -- 3453
	AddRecipe(3453, 195, 3828, Q.UNCOMMON, V.ORIG, 195, 215, 235, 255)
	self:AddRecipeFlags(3453, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(3453, "Kalimdor", "Eastern Kingdoms")

	-- Frost Oil -- 3454
	AddRecipe(3454, 200, 3829, Q.UNCOMMON, V.ORIG, 200, 220, 240, 260)
	self:AddRecipeFlags(3454, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(3454, 2480, 1)

	-- Discolored Healing Potion -- 4508
	AddRecipe(4508, 50, 4596, Q.UNCOMMON, V.ORIG, 50, 80, 100, 120)
	self:AddRecipeFlags(4508, F.HORDE, F.QUEST, F.IBOE, F.RBOE)
	self:AddRecipeQuest(4508, 429)

	-- Lesser Stoneshield Potion -- 4942
	AddRecipe(4942, 215, 4623, Q.COMMON, V.ORIG, 215, 230, 250, 270)
	self:AddRecipeFlags(4942, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOE)
	self:AddRecipeQuest(4942, 715)

	-- Rage Potion -- 6617
	AddRecipe(6617, 60, 5631, Q.COMMON, V.ORIG, 60, 90, 110, 130)
	self:AddRecipeFlags(6617, F.ALLIANCE, F.HORDE, F.VENDOR, F.DRUID, F.WARRIOR, F.IBOE, F.RBOE, F.DPS, F.TANK)
	self:AddRecipeVendor(6617, 1685, 3335, 1669, 3499)

	-- Great Rage Potion -- 6618
	AddRecipe(6618, 175, 5633, Q.COMMON, V.ORIG, 175, 195, 215, 235)
	self:AddRecipeFlags(6618, F.ALLIANCE, F.HORDE, F.VENDOR, F.DRUID, F.WARRIOR, F.IBOE, F.RBOE, F.DPS, F.TANK)
	self:AddRecipeVendor(6618, 3335, 4226)

	-- Free Action Potion -- 6624
	AddRecipe(6624, 150, 5634, Q.COMMON, V.ORIG, 150, 175, 195, 215)
	self:AddRecipeFlags(6624, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(6624, 5178, 1, 4226, 1, 3348, 1)

	-- Elixir of Water Breathing -- 7179
	AddRecipe(7179, 90, 5996, Q.COMMON, V.ORIG, 90, 120, 140, 160)
	self:AddRecipeFlags(7179, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(7179, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Greater Healing Potion -- 7181
	AddRecipe(7181, 155, 1710, Q.COMMON, V.ORIG, 155, 175, 195, 215)
	self:AddRecipeFlags(7181, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(7181, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 4160, 1215, 4611, 33608, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Elixir of Minor Defense -- 7183
	AddRecipe(7183, 1, 5997, Q.COMMON, V.ORIG, 1, 55, 75, 95)
	self:AddRecipeFlags(7183, F.ALLIANCE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeAcquire(7183, A.CUSTOM, 8)

	-- Holy Protection Potion -- 7255
	AddRecipe(7255, 100, 6051, Q.COMMON, V.ORIG, 100, 130, 150, 170)
	self:AddRecipeFlags(7255, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(7255, 1685, 1, 3134, 1, 3490, 1)

	-- Shadow Protection Potion -- 7256
	AddRecipe(7256, 135, 6048, Q.COMMON, V.ORIG, 135, 160, 180, 200)
	self:AddRecipeFlags(7256, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(7256, 2393, 1, 3956, 1)

	-- Fire Protection Potion -- 7257
	AddRecipe(7257, 165, 6049, Q.COMMON, V.ORIG, 165, 210, 230, 250)
	self:AddRecipeFlags(7257, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(7257, 4083, 1, 2380, 1)

	-- Frost Protection Potion -- 7258
	AddRecipe(7258, 190, 6050, Q.COMMON, V.ORIG, 190, 205, 225, 245)
	self:AddRecipeFlags(7258, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(7258, 2812, 1, 2848, 1)

	-- Nature Protection Potion -- 7259
	AddRecipe(7259, 190, 6052, Q.COMMON, V.ORIG, 190, 210, 230, 250)
	self:AddRecipeFlags(7259, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(7259, 8157, 1, 8158, 1, 2848, 1, 5594, 1)

	-- Blackmouth Oil -- 7836
	AddRecipe(7836, 80, 6370, Q.COMMON, V.ORIG, 80, 80, 90, 100)
	self:AddRecipeFlags(7836, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(7836, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Fire Oil -- 7837
	AddRecipe(7837, 130, 6371, Q.COMMON, V.ORIG, 130, 150, 160, 170)
	self:AddRecipeFlags(7837, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(7837, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Swim Speed Potion -- 7841
	AddRecipe(7841, 100, 6372, Q.COMMON, V.ORIG, 100, 130, 150, 170)
	self:AddRecipeFlags(7841, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(7841, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Elixir of Firepower -- 7845
	AddRecipe(7845, 140, 6373, Q.COMMON, V.ORIG, 140, 165, 185, 205)
	self:AddRecipeFlags(7845, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(7845, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Elixir of Giant Growth -- 8240
	AddRecipe(8240, 90, 6662, Q.UNCOMMON, V.ORIG, 90, 120, 140, 160)
	self:AddRecipeFlags(8240, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(8240, "The Barrens")

	-- Greater Mana Potion -- 11448
	AddRecipe(11448, 205, 6149, Q.COMMON, V.ORIG, 205, 220, 240, 260)
	self:AddRecipeFlags(11448, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(11448, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 4160, 1215, 4611, 33608, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Elixir of Agility -- 11449
	AddRecipe(11449, 185, 8949, Q.COMMON, V.ORIG, 185, 205, 225, 245)
	self:AddRecipeFlags(11449, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(11449, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 4160, 1215, 4611, 33608, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Elixir of Greater Defense -- 11450
	AddRecipe(11450, 195, 8951, Q.COMMON, V.ORIG, 195, 215, 235, 255)
	self:AddRecipeFlags(11450, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeTrainer(11450, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 4160, 1215, 4611, 33608, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Oil of Immolation -- 11451
	AddRecipe(11451, 205, 8956, Q.COMMON, V.ORIG, 205, 220, 240, 260)
	self:AddRecipeFlags(11451, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(11451, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 4160, 1215, 4611, 33608, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Restorative Potion -- 11452
	AddRecipe(11452, 210, 9030, Q.COMMON, V.ORIG, 210, 225, 245, 265)
	self:AddRecipeFlags(11452, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeQuest(11452, 2203, 2501)

	-- Magic Resistance Potion -- 11453
	AddRecipe(11453, 210, 9036, Q.UNCOMMON, V.ORIG, 210, 225, 245, 265)
	self:AddRecipeFlags(11453, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(11453, "Kalimdor", "Eastern Kingdoms")

	-- Goblin Rocket Fuel -- 11456
	AddRecipe(11456, 210, 9061, Q.COMMON, V.ORIG, 210, 225, 245, 265)
	self:AddRecipeFlags(11456, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(11456, A.CUSTOM, 9)

	-- Superior Healing Potion -- 11457
	AddRecipe(11457, 215, 3928, Q.COMMON, V.ORIG, 215, 230, 250, 270)
	self:AddRecipeFlags(11457, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(11457, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 4160, 1215, 4611, 33608, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Wildvine Potion -- 11458
	AddRecipe(11458, 225, 9144, Q.UNCOMMON, V.ORIG, 225, 240, 260, 280)
	self:AddRecipeFlags(11458, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(11458, "Eastern Kingdoms")

	-- Philosopher's Stone -- 11459
	AddRecipe(11459, 225, 9149, Q.COMMON, V.ORIG, 225, 240, 260, 280)
	self:AddRecipeFlags(11459, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOE, F.DPS, F.HEALER, F.CASTER, F.TRINKET)
	self:AddRecipeVendor(11459, 5594)

	-- Elixir of Detect Undead -- 11460
	AddRecipe(11460, 230, 9154, Q.COMMON, V.ORIG, 230, 245, 265, 285)
	self:AddRecipeFlags(11460, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(11460, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Arcane Elixir -- 11461
	AddRecipe(11461, 235, 9155, Q.COMMON, V.ORIG, 235, 250, 270, 290)
	self:AddRecipeFlags(11461, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(11461, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Invisibility Potion -- 11464
	AddRecipe(11464, 235, 9172, Q.UNCOMMON, V.ORIG, 235, 250, 270, 290)
	self:AddRecipeFlags(11464, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(11464, "Kalimdor", "Eastern Kingdoms")

	-- Elixir of Greater Intellect -- 11465
	AddRecipe(11465, 235, 9179, Q.COMMON, V.ORIG, 235, 250, 270, 290)
	self:AddRecipeFlags(11465, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(11465, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Gift of Arthas -- 11466
	AddRecipe(11466, 240, 9088, Q.UNCOMMON, V.ORIG, 240, 255, 275, 295)
	self:AddRecipeFlags(11466, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(11466, 1783, 1791)

	-- Elixir of Greater Agility -- 11467
	AddRecipe(11467, 240, 9187, Q.COMMON, V.ORIG, 240, 255, 275, 295)
	self:AddRecipeFlags(11467, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(11467, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Elixir of Dream Vision -- 11468
	AddRecipe(11468, 240, 9197, Q.UNCOMMON, V.ORIG, 240, 255, 275, 295)
	self:AddRecipeFlags(11468, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(11468, "Kalimdor", "Eastern Kingdoms")

	-- Elixir of Giants -- 11472
	AddRecipe(11472, 245, 9206, Q.UNCOMMON, V.ORIG, 245, 260, 280, 300)
	self:AddRecipeFlags(11472, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(11472, "Kalimdor", "Eastern Kingdoms")

	-- Ghost Dye -- 11473
	AddRecipe(11473, 245, 9210, Q.COMMON, V.ORIG, 245, 260, 280, 300)
	self:AddRecipeFlags(11473, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(11473, 8157, 1, 8158, 1)

	-- Elixir of Shadow Power -- 11476
	AddRecipe(11476, 250, 9264, Q.UNCOMMON, V.ORIG, 250, 265, 285, 305)
	self:AddRecipeFlags(11476, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeLimitedVendor(11476, 1313, 1, 4610, 1)

	-- Elixir of Demonslaying -- 11477
	AddRecipe(11477, 250, 9224, Q.COMMON, V.ORIG, 250, 265, 285, 305)
	self:AddRecipeFlags(11477, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeLimitedVendor(11477, 8177, 1, 8178, 1)

	-- Elixir of Detect Demon -- 11478
	AddRecipe(11478, 250, 9233, Q.COMMON, V.ORIG, 250, 265, 285, 305)
	self:AddRecipeFlags(11478, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(11478, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Transmute: Iron to Gold -- 11479
	AddRecipe(11479, 225, 3577, Q.COMMON, V.ORIG, 225, 240, 260, 280)
	self:AddRecipeFlags(11479, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(11479, 5594)

	-- Transmute: Mithril to Truesilver -- 11480
	AddRecipe(11480, 225, 6037, Q.COMMON, V.ORIG, 225, 240, 260, 280)
	self:AddRecipeFlags(11480, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(11480, 5594, 1)

	-- Catseye Elixir -- 12609
	AddRecipe(12609, 200, 10592, Q.COMMON, V.ORIG, 200, 220, 240, 260)
	self:AddRecipeFlags(12609, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(12609, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 4160, 1215, 4611, 33608, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Dreamless Sleep Potion -- 15833
	AddRecipe(15833, 230, 12190, Q.COMMON, V.ORIG, 230, 245, 265, 285)
	self:AddRecipeFlags(15833, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(15833, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Transmute: Arcanite -- 17187
	AddRecipe(17187, 275, 12360, Q.COMMON, V.ORIG, 275, 275, 282, 290)
	self:AddRecipeFlags(17187, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(17187, 5594)

	-- Stonescale Oil -- 17551
	AddRecipe(17551, 250, 13423, Q.COMMON, V.ORIG, 250, 250, 255, 260)
	self:AddRecipeFlags(17551, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(17551, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Mighty Rage Potion -- 17552
	AddRecipe(17552, 255, 13442, Q.COMMON, V.ORIG, 255, 270, 290, 310)
	self:AddRecipeFlags(17552, F.ALLIANCE, F.HORDE, F.TRAINER, F.DRUID, F.WARRIOR, F.IBOE, F.RBOE, F.DPS, F.TANK)
	self:AddRecipeTrainer(17552, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Superior Mana Potion -- 17553
	AddRecipe(17553, 260, 13443, Q.COMMON, V.ORIG, 260, 275, 295, 315)
	self:AddRecipeFlags(17553, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(17553, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Elixir of Superior Defense -- 17554
	AddRecipe(17554, 265, 13445, Q.COMMON, V.ORIG, 265, 280, 300, 320)
	self:AddRecipeFlags(17554, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.TANK)
	self:AddRecipeLimitedVendor(17554, 5178, 1, 3348, 1)

	-- Elixir of the Sages -- 17555
	AddRecipe(17555, 270, 13447, Q.COMMON, V.ORIG, 270, 285, 305, 325)
	self:AddRecipeFlags(17555, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(17555, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Major Healing Potion -- 17556
	AddRecipe(17556, 275, 13446, Q.COMMON, V.ORIG, 275, 290, 310, 330)
	self:AddRecipeFlags(17556, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(17556, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Elixir of Brute Force -- 17557
	AddRecipe(17557, 275, 13453, Q.COMMON, V.ORIG, 275, 290, 310, 330)
	self:AddRecipeFlags(17557, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeTrainer(17557, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Transmute: Air to Fire -- 17559
	AddRecipe(17559, 275, 7078, Q.UNCOMMON, V.ORIG, 275, 275, 282, 290)
	self:AddRecipeFlags(17559, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ARGENTDAWN)
	self:AddRecipeRepVendor(17559, FAC.ARGENTDAWN, REP.HONORED, 10856, 11536, 10857)

	-- Transmute: Fire to Earth -- 17560
	AddRecipe(17560, 275, 7076, Q.UNCOMMON, V.ORIG, 275, 275, 282, 290)
	self:AddRecipeFlags(17560, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(17560, 9499)

	-- Transmute: Earth to Water -- 17561
	AddRecipe(17561, 275, 7080, Q.UNCOMMON, V.ORIG, 275, 275, 282, 290)
	self:AddRecipeFlags(17561, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TIMBERMAW_HOLD)
	self:AddRecipeRepVendor(17561, FAC.TIMBERMAW_HOLD, REP.FRIENDLY, 11557)

	-- Transmute: Water to Air -- 17562
	AddRecipe(17562, 275, 7082, Q.UNCOMMON, V.ORIG, 275, 275, 282, 290)
	self:AddRecipeFlags(17562, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP)
	self:AddRecipeVendor(17562, 11278)

	-- Transmute: Undeath to Water -- 17563
	AddRecipe(17563, 275, 7080, Q.UNCOMMON, V.ORIG, 275, 275, 282, 290)
	self:AddRecipeFlags(17563, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(17563, "Kalimdor", "Eastern Kingdoms")

	-- Transmute: Water to Undeath -- 17564
	AddRecipe(17564, 275, 12808, Q.UNCOMMON, V.ORIG, 275, 275, 282, 290)
	self:AddRecipeFlags(17564, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(17564, "Kalimdor", "Eastern Kingdoms")

	-- Transmute: Life to Earth -- 17565
	AddRecipe(17565, 275, 7076, Q.UNCOMMON, V.ORIG, 275, 275, 282, 290)
	self:AddRecipeFlags(17565, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(17565, "Kalimdor", "Eastern Kingdoms")

	-- Transmute: Earth to Life -- 17566
	AddRecipe(17566, 275, 12803, Q.UNCOMMON, V.ORIG, 275, 275, 282, 290)
	self:AddRecipeFlags(17566, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(17566, "Kalimdor", "Eastern Kingdoms")

	-- Greater Stoneshield Potion -- 17570
	AddRecipe(17570, 280, 13455, Q.UNCOMMON, V.ORIG, 280, 295, 315, 335)
	self:AddRecipeFlags(17570, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(17570, "Kalimdor", "Eastern Kingdoms")

	-- Elixir of the Mongoose -- 17571
	AddRecipe(17571, 280, 13452, Q.UNCOMMON, V.ORIG, 280, 295, 315, 335)
	self:AddRecipeFlags(17571, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeMobDrop(17571, 6201, 7106)

	-- Purification Potion -- 17572
	AddRecipe(17572, 285, 13462, Q.COMMON, V.ORIG, 285, 300, 320, 340)
	self:AddRecipeFlags(17572, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE)
	self:AddRecipeTrainer(17572, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Greater Arcane Elixir -- 17573
	AddRecipe(17573, 285, 13454, Q.COMMON, V.ORIG, 285, 300, 320, 340)
	self:AddRecipeFlags(17573, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(17573, 1386, 2837, 4900, 4160, 3184, 2132, 27029, 3347, 16723, 3603, 33608, 1215, 4611, 16642, 5177, 19052, 16588, 5499, 1470, 3964, 16161, 33674, 3009, 27023, 2391, 7948, 18802)

	-- Greater Fire Protection Potion -- 17574
	AddRecipe(17574, 290, 13457, Q.UNCOMMON, V.ORIG, 290, 305, 325, 345)
	self:AddRecipeFlags(17574, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(17574, 9262, 9264)

	-- Greater Frost Protection Potion -- 17575
	AddRecipe(17575, 290, 13456, Q.UNCOMMON, V.ORIG, 290, 305, 325, 345)
	self:AddRecipeFlags(17575, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(17575, 7428)

	-- Greater Nature Protection Potion -- 17576
	AddRecipe(17576, 290, 13458, Q.UNCOMMON, V.ORIG, 290, 305, 325, 345)
	self:AddRecipeFlags(17576, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(17576, 1812, 1813)

	-- Greater Arcane Protection Potion -- 17577
	AddRecipe(17577, 290, 13461, Q.UNCOMMON, V.ORIG, 290, 305, 325, 345)
	self:AddRecipeFlags(17577, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(17577, 7437)

	-- Greater Shadow Protection Potion -- 17578
	AddRecipe(17578, 290, 13459, Q.UNCOMMON, V.ORIG, 290, 305, 325, 345)
	self:AddRecipeFlags(17578, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE)
	self:AddRecipeMobDrop(17578, 8546, 8550)

	-- Major Mana Potion -- 17580
	AddRecipe(17580, 295, 13444, Q.UNCOMMON, V.ORIG, 295, 310, 330, 350)
	self:AddRecipeFlags(17580, F.ALLIANCE, F.HORDE, F.VENDOR, F.INSTANCE, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(17580, 1853)
	self:AddRecipeVendor(17580, 11278)

	-- Alchemist's Stone -- 17632
	AddRecipe(17632, 350, 13503, Q.COMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(17632, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET, F.SHATAR)
	self:AddRecipeRepVendor(17632, FAC.SHATAR, REP.REVERED, 21432)

	-- Potion of Petrification -- 17634
	AddRecipe(17634, 300, 13506, Q.UNCOMMON, V.ORIG, 300, 315, 322, 330)
	self:AddRecipeFlags(17634, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(17634, "Kalimdor", "Eastern Kingdoms")

	-- Flask of the Titans -- 17635
	AddRecipe(17635, 300, 13510, Q.UNCOMMON, V.TBC, 300, 315, 322, 330)
	self:AddRecipeFlags(17635, F.ALLIANCE, F.HORDE, F.VENDOR, F.INSTANCE, F.IBOE, F.RBOP, F.TANK, F.SHATAR)
	self:AddRecipeMobDrop(17635, 10363)
	self:AddRecipeRepVendor(17635, FAC.SHATAR, REP.EXALTED, 21432)

	-- Flask of Distilled Wisdom -- 17636
	AddRecipe(17636, 300, 13511, Q.UNCOMMON, V.TBC, 300, 315, 322, 330)
	self:AddRecipeFlags(17636, F.ALLIANCE, F.HORDE, F.VENDOR, F.INSTANCE, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(17636, FAC.CENARION_EXPEDITION, REP.EXALTED, 17904)
	self:AddRecipeMobDrop(17636, 10813)

	-- Flask of Supreme Power -- 17637
	AddRecipe(17637, 300, 13512, Q.UNCOMMON, V.TBC, 300, 315, 322, 330)
	self:AddRecipeFlags(17637, F.ALLIANCE, F.HORDE, F.VENDOR, F.INSTANCE, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.KOT)
	self:AddRecipeMobDrop(17637, 10508)
	self:AddRecipeRepVendor(17637, FAC.KEEPERS_OF_TIME, REP.EXALTED, 21643)

	-- Flask of Chromatic Resistance -- 17638
	AddRecipe(17638, 300, 13513, Q.UNCOMMON, V.TBC, 300, 315, 322, 330)
	self:AddRecipeFlags(17638, F.ALLIANCE, F.HORDE, F.VENDOR, F.INSTANCE, F.IBOE, F.RBOP, F.LOWERCITY)
	self:AddRecipeMobDrop(17638, 10339)
	self:AddRecipeRepVendor(17638, FAC.LOWERCITY, REP.EXALTED, 21655)

	-- Elixir of Frost Power -- 21923
	AddRecipe(21923, 190, 17708, Q.COMMON, V.ORIG, 190, 210, 230, 250)
	self:AddRecipeFlags(21923, F.ALLIANCE, F.HORDE, F.SEASONAL, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(21923, A.SEASONAL, 1)

	-- Major Rejuvenation Potion -- 22732
	AddRecipe(22732, 300, 18253, Q.RARE, V.ORIG, 300, 310, 320, 330)
	self:AddRecipeFlags(22732, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE)
	self:AddRecipeAcquire(22732, A.CUSTOM, 26)

	-- Elixir of Greater Water Breathing -- 22808
	AddRecipe(22808, 215, 18294, Q.COMMON, V.ORIG, 215, 230, 250, 270)
	self:AddRecipeFlags(22808, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(22808, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 33674, 2391, 1215)

	-- Gurubashi Mojo Madness -- 24266
	AddRecipe(24266, 300, 19931, Q.RARE, V.ORIG, 300, 315, 322, 330)
	self:AddRecipeFlags(24266, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(24266, A.CUSTOM, 11)

	-- Mageblood Elixir -- 24365
	AddRecipe(24365, 275, 20007, Q.COMMON, V.ORIG, 275, 290, 310, 330)
	self:AddRecipeFlags(24365, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ZANDALAR)
	self:AddRecipeRepVendor(24365, FAC.ZANDALAR, REP.REVERED, 14921)

	-- Greater Dreamless Sleep Potion -- 24366
	AddRecipe(24366, 275, 20002, Q.COMMON, V.ORIG, 275, 290, 310, 330)
	self:AddRecipeFlags(24366, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ZANDALAR)
	self:AddRecipeRepVendor(24366, FAC.ZANDALAR, REP.FRIENDLY, 14921)

	-- Living Action Potion -- 24367
	AddRecipe(24367, 285, 20008, Q.COMMON, V.ORIG, 285, 300, 320, 340)
	self:AddRecipeFlags(24367, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ZANDALAR)
	self:AddRecipeRepVendor(24367, FAC.ZANDALAR, REP.EXALTED, 14921)

	-- Mighty Troll's Blood Elixir -- 24368
	AddRecipe(24368, 290, 20004, Q.COMMON, V.ORIG, 290, 305, 325, 345)
	self:AddRecipeFlags(24368, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.ZANDALAR)
	self:AddRecipeRepVendor(24368, FAC.ZANDALAR, REP.HONORED, 14921)

	-- Transmute: Elemental Fire -- 25146
	AddRecipe(25146, 300, 7068, Q.COMMON, V.ORIG, 300, 301, 305, 310)
	self:AddRecipeFlags(25146, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.THORIUM_BROTHERHOOD)
	self:AddRecipeRepVendor(25146, FAC.THORIUM_BROTHERHOOD, REP.FRIENDLY, 12944)

	-- Elixir of Greater Firepower -- 26277
	AddRecipe(26277, 250, 21546, Q.UNCOMMON, V.ORIG, 250, 265, 285, 305)
	self:AddRecipeFlags(26277, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeMobDrop(26277, 5844, 5846, 8637)

	-- Elixir of Camouflage -- 28543
	AddRecipe(28543, 305, 22823, Q.COMMON, V.TBC, 305, 320, 327, 335)
	self:AddRecipeFlags(28543, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(28543, 18802, 1, 16705, 1, 16641, 1, 16588, 1)

	-- Elixir of Major Strength -- 28544
	AddRecipe(28544, 305, 22824, Q.COMMON, V.TBC, 305, 320, 327, 335)
	self:AddRecipeFlags(28544, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(28544, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Elixir of Healing Power -- 28545
	AddRecipe(28545, 310, 22825, Q.COMMON, V.TBC, 310, 325, 332, 340)
	self:AddRecipeFlags(28545, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(28545, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Sneaking Potion -- 28546
	AddRecipe(28546, 315, 22826, Q.COMMON, V.TBC, 315, 330, 337, 345)
	self:AddRecipeFlags(28546, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(28546, 18017, 1, 19042, 1)

	-- Elixir of Major Frost Power -- 28549
	AddRecipe(28549, 320, 22827, Q.COMMON, V.TBC, 320, 335, 342, 350)
	self:AddRecipeFlags(28549, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeLimitedVendor(28549, 18005, 1, 18017, 1)

	-- Insane Strength Potion -- 28550
	AddRecipe(28550, 320, 22828, Q.UNCOMMON, V.TBC, 320, 335, 342, 350)
	self:AddRecipeFlags(28550, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(28550, "Outland")

	-- Super Healing Potion -- 28551
	AddRecipe(28551, 325, 22829, Q.COMMON, V.TBC, 325, 340, 347, 355)
	self:AddRecipeFlags(28551, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(28551, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Elixir of the Searching Eye -- 28552
	AddRecipe(28552, 325, 22830, Q.UNCOMMON, V.TBC, 325, 340, 347, 355)
	self:AddRecipeFlags(28552, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE)
	self:AddRecipeWorldDrop(28552, "Outland")

	-- Elixir of Major Agility -- 28553
	AddRecipe(28553, 330, 22831, Q.COMMON, V.TBC, 330, 345, 352, 360)
	self:AddRecipeFlags(28553, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HELLFIRE)
	self:AddRecipeRepVendor(28553, FAC.HONOR_HOLD, REP.HONORED, 17657)
	self:AddRecipeRepVendor(28553, FAC.THRALLMAR, REP.HONORED, 17585)

	-- Shrouding Potion -- 28554
	AddRecipe(28554, 335, 22871, Q.UNCOMMON, V.TBC, 335, 350, 357, 365)
	self:AddRecipeFlags(28554, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SPOREGGAR)
	self:AddRecipeRepVendor(28554, FAC.SPOREGGAR, REP.EXALTED, 18382)

	-- Super Mana Potion -- 28555
	AddRecipe(28555, 340, 22832, Q.COMMON, V.TBC, 340, 355, 362, 370)
	self:AddRecipeFlags(28555, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(28555, 18005, 1, 19837, 1)

	-- Elixir of Major Firepower -- 28556
	AddRecipe(28556, 345, 22833, Q.UNCOMMON, V.TBC, 345, 360, 367, 375)
	self:AddRecipeFlags(28556, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCRYER)
	self:AddRecipeRepVendor(28556, FAC.SCRYER, REP.REVERED, 19331)

	-- Elixir of Major Defense -- 28557
	AddRecipe(28557, 345, 22834, Q.COMMON, V.TBC, 345, 360, 367, 375)
	self:AddRecipeFlags(28557, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.TANK)
	self:AddRecipeLimitedVendor(28557, 18005, 1, 19837, 1)

	-- Elixir of Major Shadow Power -- 28558
	AddRecipe(28558, 350, 22835, Q.UNCOMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(28558, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LOWERCITY)
	self:AddRecipeRepVendor(28558, FAC.LOWERCITY, REP.REVERED, 21655)

	-- Major Dreamless Sleep Potion -- 28562
	AddRecipe(28562, 350, 22836, Q.COMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(28562, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(28562, 19042, 1, 19837, 1)

	-- Heroic Potion -- 28563
	AddRecipe(28563, 350, 22837, Q.UNCOMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(28563, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS)
	self:AddRecipeWorldDrop(28563, "Outland")

	-- Haste Potion -- 28564
	AddRecipe(28564, 350, 22838, Q.UNCOMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(28564, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(28564, 24664)

	-- Destruction Potion -- 28565
	AddRecipe(28565, 350, 22839, Q.UNCOMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(28565, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(28565, "Outland")

	-- Transmute: Primal Air to Fire -- 28566
	AddRecipe(28566, 350, 21884, Q.UNCOMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(28566, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SHATAR)
	self:AddRecipeRepVendor(28566, FAC.SHATAR, REP.REVERED, 21432)

	-- Transmute: Primal Earth to Water -- 28567
	AddRecipe(28567, 350, 21885, Q.UNCOMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(28567, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.SPOREGGAR)
	self:AddRecipeRepVendor(28567, FAC.SPOREGGAR, REP.REVERED, 18382)

	-- Transmute: Primal Fire to Earth -- 28568
	AddRecipe(28568, 350, 22452, Q.UNCOMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(28568, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.NAGRAND)
	self:AddRecipeRepVendor(28568, FAC.KURENAI, REP.REVERED, 20240)

	-- Transmute: Primal Water to Air -- 28569
	AddRecipe(28569, 350, 22451, Q.UNCOMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(28569, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(28569, FAC.CENARION_EXPEDITION, REP.REVERED, 17904)

	-- Elixir of Major Mageblood -- 28570
	AddRecipe(28570, 355, 22840, Q.UNCOMMON, V.TBC, 355, 370, 375, 380)
	self:AddRecipeFlags(28570, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER)
	self:AddRecipeWorldDrop(28570, "Outland")

	-- Major Fire Protection Potion -- 28571
	AddRecipe(28571, 360, 22841, Q.UNCOMMON, V.TBC, 360, 375, 377, 380)
	self:AddRecipeFlags(28571, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(28571, 19168, 19221)

	-- Major Frost Protection Potion -- 28572
	AddRecipe(28572, 360, 22842, Q.UNCOMMON, V.TBC, 360, 375, 377, 380)
	self:AddRecipeFlags(28572, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(28572, 18344)

	-- Major Nature Protection Potion -- 28573
	AddRecipe(28573, 360, 22844, Q.COMMON, V.TBC, 360, 375, 377, 380)
	self:AddRecipeFlags(28573, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(28573, FAC.CENARION_EXPEDITION, REP.EXALTED, 17904)

	-- Major Arcane Protection Potion -- 28575
	AddRecipe(28575, 360, 22845, Q.UNCOMMON, V.TBC, 360, 375, 377, 380)
	self:AddRecipeFlags(28575, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(28575, 17150)

	-- Major Shadow Protection Potion -- 28576
	AddRecipe(28576, 360, 22846, Q.UNCOMMON, V.TBC, 360, 375, 377, 380)
	self:AddRecipeFlags(28576, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(28576, 21302)

	-- Major Holy Protection Potion -- 28577
	AddRecipe(28577, 360, 22847, Q.UNCOMMON, V.TBC, 360, 375, 377, 380)
	self:AddRecipeFlags(28577, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(28577, 19973)

	-- Elixir of Empowerment -- 28578
	AddRecipe(28578, 365, 22848, Q.UNCOMMON, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(28578, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(28578, 24664)
	self:AddRecipeWorldDrop(28578, "Outland")

	-- Ironshield Potion -- 28579
	AddRecipe(28579, 365, 22849, Q.UNCOMMON, V.TBC, 365, 375, 377, 380)
	self:AddRecipeFlags(28579, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(28579, 17862)

	-- Transmute: Primal Shadow to Water -- 28580
	AddRecipe(28580, 375, 21885, Q.UNCOMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28580, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(28580, A.CUSTOM, 3)

	-- Transmute: Primal Water to Shadow -- 28581
	AddRecipe(28581, 375, 22456, Q.UNCOMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28581, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(28581, A.CUSTOM, 3)

	-- Transmute: Primal Mana to Fire -- 28582
	AddRecipe(28582, 375, 21884, Q.UNCOMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28582, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(28582, A.CUSTOM, 3)

	-- Transmute: Primal Fire to Mana -- 28583
	AddRecipe(28583, 375, 22457, Q.UNCOMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28583, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(28583, A.CUSTOM, 3)

	-- Transmute: Primal Life to Earth -- 28584
	AddRecipe(28584, 375, 22452, Q.UNCOMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28584, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(28584, A.CUSTOM, 3)

	-- Transmute: Primal Earth to Life -- 28585
	AddRecipe(28585, 375, 21886, Q.UNCOMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28585, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(28585, A.CUSTOM, 3)

	-- Super Rejuvenation Potion -- 28586
	AddRecipe(28586, 375, 22850, Q.COMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28586, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(28586, A.CUSTOM, 2)

	-- Flask of Fortification -- 28587
	AddRecipe(28587, 375, 22851, Q.COMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28587, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeAcquire(28587, A.CUSTOM, 1)

	-- Flask of Mighty Restoration -- 28588
	AddRecipe(28588, 375, 22853, Q.COMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28588, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(28588, A.CUSTOM, 1)

	-- Flask of Relentless Assault -- 28589
	AddRecipe(28589, 375, 22854, Q.COMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28589, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeAcquire(28589, A.CUSTOM, 1)

	-- Flask of Blinding Light -- 28590
	AddRecipe(28590, 375, 22861, Q.COMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28590, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(28590, A.CUSTOM, 1)

	-- Flask of Pure Death -- 28591
	AddRecipe(28591, 375, 22866, Q.COMMON, V.TBC, 375, 375, 377, 380)
	self:AddRecipeFlags(28591, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(28591, A.CUSTOM, 1)

	-- Transmute: Primal Might -- 29688
	AddRecipe(29688, 350, 23571, Q.UNCOMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(29688, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeLimitedVendor(29688, 16705, 1, 16641, 1, 19074, 1)

	-- Transmute: Earthstorm Diamond -- 32765
	AddRecipe(32765, 350, 25867, Q.COMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(32765, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(32765, FAC.CENARION_EXPEDITION, REP.HONORED, 17904)

	-- Transmute: Skyfire Diamond -- 32766
	AddRecipe(32766, 350, 25868, Q.COMMON, V.TBC, 350, 365, 372, 380)
	self:AddRecipeFlags(32766, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HELLFIRE)
	self:AddRecipeRepVendor(32766, FAC.HONOR_HOLD, REP.HONORED, 17657)
	self:AddRecipeRepVendor(32766, FAC.THRALLMAR, REP.HONORED, 17585)

	-- Volatile Healing Potion -- 33732
	AddRecipe(33732, 300, 28100, Q.COMMON, V.TBC, 300, 315, 322, 330)
	self:AddRecipeFlags(33732, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(33732, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Unstable Mana Potion -- 33733
	AddRecipe(33733, 310, 28101, Q.COMMON, V.TBC, 310, 325, 332, 340)
	self:AddRecipeFlags(33733, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(33733, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Onslaught Elixir -- 33738
	AddRecipe(33738, 300, 28102, Q.COMMON, V.TBC, 300, 315, 322, 330)
	self:AddRecipeFlags(33738, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(33738, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Adept's Elixir -- 33740
	AddRecipe(33740, 300, 28103, Q.COMMON, V.TBC, 300, 315, 322, 330)
	self:AddRecipeFlags(33740, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(33740, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Elixir of Mastery -- 33741
	AddRecipe(33741, 315, 28104, Q.COMMON, V.TBC, 315, 330, 337, 345)
	self:AddRecipeFlags(33741, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(33741, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Mercurial Stone -- 38070
	AddRecipe(38070, 325, 31080, Q.COMMON, V.TBC, 325, 340, 347, 355)
	self:AddRecipeFlags(38070, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TRINKET)
	self:AddRecipeTrainer(38070, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Fel Strength Elixir -- 38960
	AddRecipe(38960, 335, 31679, Q.RARE, V.TBC, 335, 350, 357, 365)
	self:AddRecipeFlags(38960, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeMobDrop(38960, 19740, 21302, 19755, 21314)

	-- Fel Mana Potion -- 38961
	AddRecipe(38961, 360, 31677, Q.RARE, V.TBC, 360, 375, 377, 380)
	self:AddRecipeFlags(38961, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeMobDrop(38961, 19795, 19792, 22076, 22017, 22016, 22018, 19796, 19806, 22093)

	-- Fel Regeneration Potion -- 38962
	AddRecipe(38962, 345, 31676, Q.RARE, V.TBC, 345, 360, 367, 375)
	self:AddRecipeFlags(38962, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(38962, 19756, 19754, 20878, 20887)

	-- Elixir of Major Fortitude -- 39636
	AddRecipe(39636, 310, 32062, Q.COMMON, V.TBC, 310, 325, 332, 340)
	self:AddRecipeFlags(39636, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(39636, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Earthen Elixir -- 39637
	AddRecipe(39637, 320, 32063, Q.COMMON, V.TBC, 320, 335, 342, 350)
	self:AddRecipeFlags(39637, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(39637, FAC.CENARION_EXPEDITION, REP.HONORED, 17904)

	-- Elixir of Draenic Wisdom -- 39638
	AddRecipe(39638, 320, 32067, Q.COMMON, V.TBC, 320, 335, 342, 350)
	self:AddRecipeFlags(39638, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(39638, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Elixir of Ironskin -- 39639
	AddRecipe(39639, 330, 32068, Q.COMMON, V.TBC, 330, 345, 352, 360)
	self:AddRecipeFlags(39639, F.ALLIANCE, F.HORDE, F.VENDOR, F.PVP, F.IBOE, F.RBOP)
	self:AddRecipeVendor(39639, 18821, 18822)

	-- Cauldron of Major Arcane Protection -- 41458
	AddRecipe(41458, 360, 32839, Q.COMMON, V.TBC, 360, 360, 370, 380)
	self:AddRecipeFlags(41458, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(41458, A.CUSTOM, 4)

	-- Cauldron of Major Fire Protection -- 41500
	AddRecipe(41500, 360, 32849, Q.COMMON, V.TBC, 360, 360, 370, 380)
	self:AddRecipeFlags(41500, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(41500, A.CUSTOM, 4)

	-- Cauldron of Major Frost Protection -- 41501
	AddRecipe(41501, 360, 32850, Q.COMMON, V.TBC, 360, 360, 370, 380)
	self:AddRecipeFlags(41501, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(41501, A.CUSTOM, 4)

	-- Cauldron of Major Nature Protection -- 41502
	AddRecipe(41502, 360, 32851, Q.COMMON, V.TBC, 360, 360, 370, 380)
	self:AddRecipeFlags(41502, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(41502, A.CUSTOM, 4)

	-- Cauldron of Major Shadow Protection -- 41503
	AddRecipe(41503, 360, 32852, Q.COMMON, V.TBC, 360, 360, 370, 380)
	self:AddRecipeFlags(41503, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(41503, A.CUSTOM, 4)

	-- Flask of Chromatic Wonder -- 42736
	AddRecipe(42736, 375, 33208, Q.UNCOMMON, V.TBC, 375, 390, 397, 405)
	self:AddRecipeFlags(42736, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.VIOLETEYE)
	self:AddRecipeRepVendor(42736, FAC.VIOLETEYE, REP.HONORED, 18255)

	-- Mad Alchemist's Potion -- 45061
	AddRecipe(45061, 325, 34440, Q.COMMON, V.TBC, 325, 335, 342, 350)
	self:AddRecipeFlags(45061, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45061, 18802, 19052, 33674, 27023, 33608, 16588, 27029)

	-- Guardian's Alchemist Stone -- 47046
	AddRecipe(47046, 375, 35748, Q.COMMON, V.TBC, 375, 380, 385, 390)
	self:AddRecipeFlags(47046, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.TANK, F.TRINKET, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(47046, FAC.SHATTEREDSUN, REP.EXALTED, 25032)

	-- Sorcerer's Alchemist Stone -- 47048
	AddRecipe(47048, 375, 35749, Q.COMMON, V.TBC, 375, 380, 385, 390)
	self:AddRecipeFlags(47048, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(47048, FAC.SHATTEREDSUN, REP.EXALTED, 25032)

	-- Redeemer's Alchemist Stone -- 47049
	AddRecipe(47049, 375, 35750, Q.COMMON, V.TBC, 375, 380, 385, 390)
	self:AddRecipeFlags(47049, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(47049, FAC.SHATTEREDSUN, REP.EXALTED, 25032)

	-- Assassin's Alchemist Stone -- 47050
	AddRecipe(47050, 375, 35751, Q.COMMON, V.TBC, 375, 380, 385, 390)
	self:AddRecipeFlags(47050, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOP, F.RBOP, F.DPS, F.TRINKET, F.SHATTEREDSUN)
	self:AddRecipeRepVendor(47050, FAC.SHATTEREDSUN, REP.EXALTED, 25032)

	-- Transmute: Eternal Life to Shadow -- 53771
	AddRecipe(53771, 405, 35627, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53771, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53771, A.CUSTOM, 19)

	-- Transmute: Eternal Life to Fire -- 53773
	AddRecipe(53773, 405, 36860, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53773, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53773, A.CUSTOM, 19)

	-- Transmute: Eternal Fire to Water -- 53774
	AddRecipe(53774, 405, 35622, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53774, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53774, A.CUSTOM, 19)

	-- Transmute: Eternal Fire to Life -- 53775
	AddRecipe(53775, 405, 35625, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53775, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53775, A.CUSTOM, 19)

	-- Transmute: Eternal Air to Water -- 53776
	AddRecipe(53776, 405, 35622, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53776, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53776, A.CUSTOM, 19)

	-- Transmute: Eternal Air to Earth -- 53777
	AddRecipe(53777, 405, 35624, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53777, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53777, A.CUSTOM, 19)

	-- Transmute: Eternal Shadow to Earth -- 53779
	AddRecipe(53779, 405, 35624, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53779, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53779, A.CUSTOM, 19)

	-- Transmute: Eternal Shadow to Life -- 53780
	AddRecipe(53780, 405, 35625, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53780, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53780, A.CUSTOM, 19)

	-- Transmute: Eternal Earth to Air -- 53781
	AddRecipe(53781, 405, 35623, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53781, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53781, A.CUSTOM, 19)

	-- Transmute: Eternal Earth to Shadow -- 53782
	AddRecipe(53782, 405, 35627, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53782, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53782, A.CUSTOM, 19)

	-- Transmute: Eternal Water to Air -- 53783
	AddRecipe(53783, 405, 35623, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53783, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53783, A.CUSTOM, 19)

	-- Transmute: Eternal Water to Fire -- 53784
	AddRecipe(53784, 405, 36860, Q.UNCOMMON, V.WOTLK, 405, 405, 415, 425)
	self:AddRecipeFlags(53784, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53784, A.CUSTOM, 19)

	-- Pygmy Oil -- 53812
	AddRecipe(53812, 375, 40195, Q.COMMON, V.WOTLK, 375, 380, 385, 390)
	self:AddRecipeFlags(53812, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53812, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Runic Healing Potion -- 53836
	AddRecipe(53836, 405, 33447, Q.COMMON, V.WOTLK, 405, 415, 420, 425)
	self:AddRecipeFlags(53836, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53836, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Runic Mana Potion -- 53837
	AddRecipe(53837, 410, 33448, Q.COMMON, V.WOTLK, 410, 420, 425, 430)
	self:AddRecipeFlags(53837, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53837, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Resurgent Healing Potion -- 53838
	AddRecipe(53838, 350, 39671, Q.COMMON, V.WOTLK, 350, 360, 365, 370)
	self:AddRecipeFlags(53838, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53838, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Icy Mana Potion -- 53839
	AddRecipe(53839, 360, 40067, Q.COMMON, V.WOTLK, 360, 370, 375, 380)
	self:AddRecipeFlags(53839, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53839, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Elixir of Mighty Agility -- 53840
	AddRecipe(53840, 395, 39666, Q.COMMON, V.WOTLK, 395, 405, 410, 415)
	self:AddRecipeFlags(53840, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53840, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Wrath Elixir -- 53841
	AddRecipe(53841, 355, 40068, Q.COMMON, V.WOTLK, 355, 365, 370, 375)
	self:AddRecipeFlags(53841, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53841, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Spellpower Elixir -- 53842
	AddRecipe(53842, 365, 40070, Q.COMMON, V.WOTLK, 365, 375, 380, 385)
	self:AddRecipeFlags(53842, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53842, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Elixir of Spirit -- 53847
	AddRecipe(53847, 385, 40072, Q.COMMON, V.WOTLK, 385, 395, 400, 405)
	self:AddRecipeFlags(53847, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53847, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Guru's Elixir -- 53848
	AddRecipe(53848, 375, 40076, Q.COMMON, V.WOTLK, 375, 385, 390, 395)
	self:AddRecipeFlags(53848, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53848, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Crazy Alchemist's Potion -- 53895
	AddRecipe(53895, 400, 40077, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(53895, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53895, A.CUSTOM, 18)

	-- Elixir of Mighty Fortitude -- 53898
	AddRecipe(53898, 390, 40078, Q.COMMON, V.WOTLK, 390, 400, 405, 410)
	self:AddRecipeFlags(53898, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53898, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Lesser Flask of Toughness -- 53899
	AddRecipe(53899, 375, 40079, Q.COMMON, V.WOTLK, 375, 385, 390, 395)
	self:AddRecipeFlags(53899, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53899, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Potion of Nightmares -- 53900
	AddRecipe(53900, 380, 40081, Q.COMMON, V.WOTLK, 380, 390, 395, 400)
	self:AddRecipeFlags(53900, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53900, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Flask of the Frost Wyrm -- 53901
	AddRecipe(53901, 435, 40082, Q.COMMON, V.WOTLK, 435, 450, 457, 465)
	self:AddRecipeFlags(53901, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(53901, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Flask of Stoneblood -- 53902
	AddRecipe(53902, 435, 40083, Q.COMMON, V.WOTLK, 435, 450, 457, 465)
	self:AddRecipeFlags(53902, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53902, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Flask of Endless Rage -- 53903
	AddRecipe(53903, 435, 40084, Q.COMMON, V.WOTLK, 435, 450, 457, 465)
	self:AddRecipeFlags(53903, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(53903, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Powerful Rejuvenation Potion -- 53904
	AddRecipe(53904, 400, 40087, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(53904, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(53904, A.CUSTOM, 18)

	-- Indestructible Potion -- 53905
	AddRecipe(53905, 395, 40093, Q.COMMON, V.WOTLK, 395, 405, 410, 415)
	self:AddRecipeFlags(53905, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(53905, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Mighty Arcane Protection Potion -- 53936
	AddRecipe(53936, 400, 40213, Q.UNCOMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(53936, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(53936, 32297, 31702)

	-- Mighty Frost Protection Potion -- 53937
	AddRecipe(53937, 400, 40215, Q.UNCOMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(53937, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(53937, 32289)

	-- Mighty Shadow Protection Potion -- 53938
	AddRecipe(53938, 400, 40217, Q.UNCOMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(53938, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(53938, 32349)

	-- Mighty Fire Protection Potion -- 53939
	AddRecipe(53939, 400, 40214, Q.UNCOMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(53939, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(53939, 30921)

	-- Mighty Nature Protection Potion -- 53942
	AddRecipe(53942, 400, 40216, Q.UNCOMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(53942, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(53942, 32290)

	-- Flask of Pure Mojo -- 54213
	AddRecipe(54213, 435, 40404, Q.COMMON, V.WOTLK, 435, 450, 457, 465)
	self:AddRecipeFlags(54213, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(54213, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Elixir of Mighty Strength -- 54218
	AddRecipe(54218, 385, 40073, Q.COMMON, V.WOTLK, 385, 395, 400, 405)
	self:AddRecipeFlags(54218, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(54218, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Elixir of Protection -- 54220
	AddRecipe(54220, 400, 40097, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(54220, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(54220, A.CUSTOM, 18)

	-- Potion of Speed -- 54221
	AddRecipe(54221, 400, 40211, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(54221, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(54221, A.CUSTOM, 18)

	-- Potion of Wild Magic -- 54222
	AddRecipe(54222, 400, 40212, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(54222, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeAcquire(54222, A.CUSTOM, 18)

	-- Elixir of Mighty Mageblood -- 56519
	AddRecipe(56519, 400, 40109, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(56519, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(56519, A.CUSTOM, 18)

	-- Transmute: Skyflare Diamond -- 57425
	AddRecipe(57425, 430, 41266, Q.COMMON, V.WOTLK, 430, 440, 445, 450)
	self:AddRecipeFlags(57425, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(57425, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Transmute: Earthsiege Diamond -- 57427
	AddRecipe(57427, 425, 41334, Q.COMMON, V.WOTLK, 425, 435, 440, 445)
	self:AddRecipeFlags(57427, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(57427, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Endless Mana Potion -- 58868
	AddRecipe(58868, 410, 43570, Q.COMMON, V.WOTLK, 410, 420, 425, 430)
	self:AddRecipeFlags(58868, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(58868, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Endless Healing Potion -- 58871
	AddRecipe(58871, 410, 43569, Q.COMMON, V.WOTLK, 410, 420, 425, 430)
	self:AddRecipeFlags(58871, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP)
	self:AddRecipeTrainer(58871, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Transmute: Titanium -- 60350
	AddRecipe(60350, 395, 41163, Q.COMMON, V.WOTLK, 395, 405, 410, 415)
	self:AddRecipeFlags(60350, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(60350, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Elixir of Accuracy -- 60354
	AddRecipe(60354, 400, 44325, Q.COMMON, V.WOTLK, 400, 415, 422, 430)
	self:AddRecipeFlags(60354, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(60354, A.CUSTOM, 18)

	-- Elixir of Deadly Strikes -- 60355
	AddRecipe(60355, 400, 44327, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(60355, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(60355, A.CUSTOM, 18)

	-- Elixir of Mighty Defense -- 60356
	AddRecipe(60356, 400, 44328, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(60356, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeAcquire(60356, A.CUSTOM, 18)

	-- Elixir of Expertise -- 60357
	AddRecipe(60357, 400, 44329, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(60357, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeAcquire(60357, A.CUSTOM, 18)

	-- Elixir of Armor Piercing -- 60365
	AddRecipe(60365, 400, 44330, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(60365, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeAcquire(60365, A.CUSTOM, 18)

	-- Elixir of Lightning Speed -- 60366
	AddRecipe(60366, 400, 44331, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(60366, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(60366, A.CUSTOM, 18)

	-- Elixir of Mighty Thoughts -- 60367
	AddRecipe(60367, 395, 44332, Q.COMMON, V.WOTLK, 395, 405, 410, 415)
	self:AddRecipeFlags(60367, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(60367, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Mercurial Alchemist Stone -- 60396
	AddRecipe(60396, 400, 44322, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(60396, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.TRINKET)
	self:AddRecipeTrainer(60396, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Indestructible Alchemist Stone -- 60403
	AddRecipe(60403, 400, 44323, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(60403, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.TANK, F.TRINKET)
	self:AddRecipeTrainer(60403, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Mighty Alchemist Stone -- 60405
	AddRecipe(60405, 400, 44324, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(60405, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.TRINKET)
	self:AddRecipeTrainer(60405, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Northrend Alchemy Research -- 60893
	AddRecipe(60893, 400, nil, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(60893, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(60893, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Lesser Flask of Resistance -- 62213
	AddRecipe(62213, 385, 44939, Q.COMMON, V.WOTLK, 385, 395, 400, 405)
	self:AddRecipeFlags(62213, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(62213, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Ethereal Oil -- 62409
	AddRecipe(62409, 375, 44958, Q.COMMON, V.WOTLK, 375, 385, 390, 395)
	self:AddRecipeFlags(62409, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(62409, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Elixir of Water Walking -- 62410
	AddRecipe(62410, 400, 8827, Q.COMMON, V.WOTLK, 400, 410, 415, 420)
	self:AddRecipeFlags(62410, F.ALLIANCE, F.HORDE, F.DISC, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(62410, A.CUSTOM, 18)

	-- Elixir of Minor Accuracy -- 63732
	AddRecipe(63732, 135, 45621, Q.COMMON, V.WOTLK, 135, 160, 180, 200)
	self:AddRecipeFlags(63732, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(63732, 1386, 2837, 4900, 16642, 3184, 2132, 27029, 3347, 16723, 3603, 5499, 18802, 4611, 4160, 5177, 19052, 16588, 7948, 1470, 3964, 16161, 33608, 3009, 27023, 2391, 33674, 1215)

	-- Transmute: Ametrine -- 66658
	AddRecipe(66658, 450, 36931, Q.COMMON, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66658, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(66658, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Transmute: Cardinal Ruby -- 66659
	AddRecipe(66659, 450, 36919, Q.COMMON, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66659, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeQuest(66659, 14151)

	-- Transmute: King's Amber -- 66660
	AddRecipe(66660, 450, 36922, Q.COMMON, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66660, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(66660, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Transmute: Dreadstone -- 66662
	AddRecipe(66662, 450, 36928, Q.COMMON, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66662, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(66662, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Transmute: Majestic Zircon -- 66663
	AddRecipe(66663, 450, 36925, Q.COMMON, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66663, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(66663, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Transmute: Eye of Zul -- 66664
	AddRecipe(66664, 450, 36934, Q.COMMON, V.WOTLK, 450, 450, 452, 465)
	self:AddRecipeFlags(66664, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(66664, 26951, 26903, 28703, 26975, 26987, 33588)

	-- Flask of the North -- 67025
	AddRecipe(67025, 425, 47499, Q.COMMON, V.WOTLK, 425, 440, 445, 450)
	self:AddRecipeFlags(67025, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS)
	self:AddRecipeTrainer(67025, 26951, 26903, 28703, 26975, 26987, 33588)

	return num_recipes
end
