-------------------------------------------------------------------------------
-- Player.lua
-- Player functions and data for AckisRecipeList.
-------------------------------------------------------------------------------
-- File date: 2010-07-01T05:02:05Z
-- File hash: 9402355
-- Project hash: 9458672
-- Project version: v2.01-8-g9458672
-------------------------------------------------------------------------------
-- Please see http://www.wowace.com/addons/arl/ for more information.
-------------------------------------------------------------------------------
-- This source code is released under All Rights Reserved.
-------------------------------------------------------------------------------
--- **AckisRecipeList** provides an interface for scanning professions for missing recipes.
-- There are a set of functions which allow you make use of the ARL database outside of ARL.
-- ARL supports all professions currently in World of Warcraft 3.3.2
-- @class file
-- @name Player.lua
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

local table = _G.table

local bit = _G.bit

local pairs = _G.pairs

-------------------------------------------------------------------------------
-- Localized Blizzard API.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local LibStub = LibStub

local MODNAME		= "Ackis Recipe List"
local addon		= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

local BFAC		= LibStub("LibBabble-Faction-3.0"):GetLookupTable()
local L			= LibStub("AceLocale-3.0"):GetLocale(MODNAME)

local private		= select(2, ...)

local Player		= private.Player

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local A = private.acquire_types
local F = private.filter_flags

local A_MAX = 9

-------------------------------------------------------------------------------
-- Variables
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------
function Player:HasProperRepLevel(rep_data)
	if not rep_data then
		return true
	end
	local is_alliance = Player.faction == BFAC["Alliance"]
	local player_rep = Player["Reputation"]
	local FAC = private.faction_ids
	local has_faction = true

	for rep_id, rep_info in pairs(rep_data) do
		for rep_level in pairs(rep_info) do
			if rep_id == FAC.HONOR_HOLD or rep_id == FAC.THRALLMAR then
				rep_id = is_alliance and FAC.HONOR_HOLD or FAC.THRALLMAR
			elseif rep_id == FAC.MAGHAR or rep_id == FAC.KURENAI then
				rep_id = is_alliance and FAC.KURENAI or FAC.MAGHAR
			end
			local rep_name = private.reputation_list[rep_id].name

			if not player_rep[rep_name] or player_rep[rep_name] < rep_level then
				has_faction = false
			else
				has_faction = true
				break
			end
		end
	end
	return has_faction
end

function Player:HasRecipeFaction(recipe)
	local flagged_horde = recipe:IsFlagged("common1", "HORDE")
	local flagged_alliance = recipe:IsFlagged("common1", "ALLIANCE")

	if self.faction == BFAC["Alliance"] and flagged_horde and not flagged_alliance then
		return false
	elseif self.faction == BFAC["Horde"] and flagged_alliance and not flagged_horde then
		return false
	end
	return true
end

-- Sets the player's professions. Used when the AddOn initializes and when a profession has been learned or unlearned.
-- TODO: Make the AddOn actually detect when a profession is learned/unlearned, then call this function. -Torhal
function Player:SetProfessions()
	local profession_list = self.professions

	for i in pairs(profession_list) do
		profession_list[i] = false
	end

	for index = 1, 25, 1 do
		local spell_name = GetSpellName(index, BOOKTYPE_SPELL)

		if not spell_name or index == 25 then
			break
		end

		-- Check for false in the profession_list - a nil entry means we don't care about the spell.
		if profession_list[spell_name] == false then
			profession_list[spell_name] = true
		end
	end
end
