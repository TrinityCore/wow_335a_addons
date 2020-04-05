--[[
************************************************************************
Runeforging.lua
Runeforging data for all of Ackis Recipe List
************************************************************************
File date: 2010-03-27T07:19:00Z
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
local function AddRecipe(spell_id)
	num_recipes = num_recipes + 1
	addon:AddRecipe(spell_id, 1, nil, Q.COMMON, 53428, nil, V.WOTLK, 1, 1, 1, 1)
end

function addon:InitRuneforging()
	if initialized then
		return num_recipes
	end
	initialized = true

	-- Rune of Swordshattering -- 53323
	AddRecipe(53323, 1, nil, Q.COMMON, V.WOTLK, 1, 1, 1, 1)
	self:AddRecipeFlags(53323, F.ALLIANCE, F.HORDE, F.TRAINER, F.DK, F.IBOP, F.RBOP, F.TWO_HAND)
	self:AddRecipeTrainer(53323, 29194, 29195, 29196, 31084)

	-- Rune of Lichbane -- 53331
	AddRecipe(53331, 1, nil, Q.COMMON, V.WOTLK, 1, 1, 1, 1)
	self:AddRecipeFlags(53331, F.ALLIANCE, F.HORDE, F.TRAINER, F.DK, F.IBOP, F.RBOP, F.TWO_HAND)
	self:AddRecipeTrainer(53331, 29194, 29195, 29196, 31084)

	-- Rune of Cinderglacier -- 53341
	AddRecipe(53341, 1, nil, Q.COMMON, V.WOTLK, 1, 1, 1, 1)
	self:AddRecipeFlags(53341, F.ALLIANCE, F.HORDE, F.TRAINER, F.DK, F.IBOP, F.RBOP, F.TWO_HAND)
	self:AddRecipeTrainer(53341, 29194, 29195, 29196, 31084)

	-- Rune of Spellshattering -- 53342
	AddRecipe(53342, 1, nil, Q.COMMON, V.WOTLK, 1, 1, 1, 1)
	self:AddRecipeFlags(53342, F.ALLIANCE, F.HORDE, F.TRAINER, F.DK, F.IBOP, F.RBOP, F.TWO_HAND)
	self:AddRecipeTrainer(53342, 29194, 29195, 29196, 31084)

	-- Rune of Razorice -- 53343
	AddRecipe(53343, 1, nil, Q.COMMON, V.WOTLK, 1, 1, 1, 1)
	self:AddRecipeFlags(53343, F.ALLIANCE, F.HORDE, F.TRAINER, F.DK, F.IBOP, F.RBOP, F.TWO_HAND)
	self:AddRecipeTrainer(53343, 29194, 29195, 29196, 31084)

	-- Rune of the Fallen Crusader -- 53344
	AddRecipe(53344, 1, nil, Q.COMMON, V.WOTLK, 1, 1, 1, 1)
	self:AddRecipeFlags(53344, F.ALLIANCE, F.HORDE, F.TRAINER, F.DK, F.IBOP, F.RBOP, F.TWO_HAND)
	self:AddRecipeTrainer(53344, 29194, 29195, 29196, 31084)

	-- Rune of Swordbreaking -- 54446
	AddRecipe(54446, 1, nil, Q.COMMON, V.WOTLK, 1, 1, 1, 1)
	self:AddRecipeFlags(54446, F.ALLIANCE, F.HORDE, F.TRAINER, F.DK, F.IBOP, F.RBOP, F.TWO_HAND)
	self:AddRecipeTrainer(54446, 29194, 29195, 29196, 31084)

	-- Rune of Spellbreaking -- 54447
	AddRecipe(54447, 1, nil, Q.COMMON, V.WOTLK, 1, 1, 1, 1)
	self:AddRecipeFlags(54447, F.ALLIANCE, F.HORDE, F.TRAINER, F.DK, F.IBOP, F.RBOP, F.TWO_HAND)
	self:AddRecipeTrainer(54447, 29194, 29195, 29196, 31084)

	-- Rune of the Stoneskin Gargoyle -- 62158
	AddRecipe(62158, 1, nil, Q.COMMON, V.WOTLK, 1, 1, 1, 1)
	self:AddRecipeFlags(62158, F.ALLIANCE, F.HORDE, F.TRAINER, F.DK, F.IBOP, F.RBOP, F.TWO_HAND)
	self:AddRecipeTrainer(62158, 29194, 29195, 29196, 31084)

	-- Rune of the Nerubian Carapace -- 70164
	AddRecipe(70164, 1, nil, Q.COMMON, V.WOTLK, 1, 1, 1, 1)
	self:AddRecipeFlags(70164, F.ALLIANCE, F.HORDE, F.TRAINER, F.DK, F.IBOP, F.RBOP, F.TWO_HAND)
	self:AddRecipeTrainer(70164, 29194, 29195, 29196, 31084)

	return num_recipes
end
