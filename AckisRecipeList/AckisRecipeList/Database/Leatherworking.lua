--[[
************************************************************************
Leatherworking.lua
Leatherworking data for all of Ackis Recipe List
************************************************************************
File date: 2010-09-07T19:26:58Z
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
local function AddRecipe(spell_id, skill_level, item_id, quality, genesis, optimal_level, medium_level, easy_level, trivial_level, specialty)
	num_recipes = num_recipes + 1
	addon:AddRecipe(spell_id, skill_level, item_id, quality, 2108, specialty, genesis, optimal_level, medium_level, easy_level, trivial_level)
end

function addon:InitLeatherworking()
	if initialized then
		return num_recipes
	end
	initialized = true

	-- Handstitched Leather Boots -- 2149
	AddRecipe(2149, 1, 2302, Q.COMMON, V.ORIG, 1, 40, 55, 70)
	self:AddRecipeFlags(2149, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeAcquire(2149, A.CUSTOM, 8)

	-- Light Armor Kit -- 2152
	AddRecipe(2152, 1, 2304, Q.COMMON, V.ORIG, 1, 30, 45, 60)
	self:AddRecipeFlags(2152, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeAcquire(2152, A.CUSTOM, 8)

	-- Handstitched Leather Pants -- 2153
	AddRecipe(2153, 15, 2303, Q.COMMON, V.ORIG, 15, 45, 60, 75)
	self:AddRecipeFlags(2153, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(2153, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 3365, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 5564, 3007, 18771, 16278, 21087, 33681, 33635)

	-- Fine Leather Boots -- 2158
	AddRecipe(2158, 90, 2307, Q.UNCOMMON, V.ORIG, 90, 120, 135, 150)
	self:AddRecipeFlags(2158, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(2158, "Kalimdor", "Eastern Kingdoms")

	-- Fine Leather Cloak -- 2159
	AddRecipe(2159, 85, 2308, Q.COMMON, V.ORIG, 85, 105, 120, 135)
	self:AddRecipeFlags(2159, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.CLOAK)
	self:AddRecipeTrainer(2159, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Embossed Leather Vest -- 2160
	AddRecipe(2160, 40, 2300, Q.COMMON, V.ORIG, 40, 70, 85, 100)
	self:AddRecipeFlags(2160, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(2160, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 3365, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 5564, 3007, 18771, 16278, 21087, 33681, 33635)

	-- Embossed Leather Boots -- 2161
	AddRecipe(2161, 55, 2309, Q.COMMON, V.ORIG, 55, 85, 100, 115)
	self:AddRecipeFlags(2161, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(2161, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 5564, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 3365, 3007, 18771, 16278, 21087, 33681, 33635)

	-- Embossed Leather Cloak -- 2162
	AddRecipe(2162, 60, 2310, Q.COMMON, V.ORIG, 60, 90, 105, 120)
	self:AddRecipeFlags(2162, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.CLOAK)
	self:AddRecipeTrainer(2162, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 5564, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 3365, 3007, 18771, 16278, 21087, 33681, 33635)

	-- White Leather Jerkin -- 2163
	AddRecipe(2163, 60, 2311, Q.UNCOMMON, V.ORIG, 60, 90, 105, 120)
	self:AddRecipeFlags(2163, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(2163, "Kalimdor", "Eastern Kingdoms")

	-- Fine Leather Gloves -- 2164
	AddRecipe(2164, 75, 2312, Q.UNCOMMON, V.ORIG, 75, 105, 120, 135)
	self:AddRecipeFlags(2164, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(2164, "Kalimdor", "Eastern Kingdoms")

	-- Medium Armor Kit -- 2165
	AddRecipe(2165, 100, 2313, Q.COMMON, V.ORIG, 100, 115, 122, 130)
	self:AddRecipeFlags(2165, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(2165, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 5564, 4212, 8153, 4588, 18771, 16728, 33612, 17442, 3549, 3007, 5127, 16278, 21087, 33681, 33635)

	-- Toughened Leather Armor -- 2166
	AddRecipe(2166, 120, 2314, Q.COMMON, V.ORIG, 120, 145, 157, 170)
	self:AddRecipeFlags(2166, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(2166, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Dark Leather Boots -- 2167
	AddRecipe(2167, 100, 2315, Q.COMMON, V.ORIG, 100, 125, 137, 150)
	self:AddRecipeFlags(2167, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(2167, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Dark Leather Cloak -- 2168
	AddRecipe(2168, 110, 2316, Q.COMMON, V.ORIG, 110, 135, 147, 160)
	self:AddRecipeFlags(2168, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.CLOAK)
	self:AddRecipeTrainer(2168, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Dark Leather Tunic -- 2169
	AddRecipe(2169, 100, 2317, Q.UNCOMMON, V.ORIG, 100, 125, 137, 150)
	self:AddRecipeFlags(2169, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(2169, "Kalimdor", "Eastern Kingdoms")

	-- Light Leather -- 2881
	AddRecipe(2881, 1, 2318, Q.COMMON, V.ORIG, 1, 20, 30, 40)
	self:AddRecipeFlags(2881, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeAcquire(2881, A.CUSTOM, 8)

	-- Handstitched Leather Belt -- 3753
	AddRecipe(3753, 25, 4237, Q.COMMON, V.ORIG, 25, 55, 70, 85)
	self:AddRecipeFlags(3753, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(3753, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 3365, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 5564, 3007, 18771, 16278, 21087, 33681, 33635)

	-- Embossed Leather Gloves -- 3756
	AddRecipe(3756, 55, 4239, Q.COMMON, V.ORIG, 55, 85, 100, 115)
	self:AddRecipeFlags(3756, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(3756, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 5564, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 3365, 3007, 18771, 16278, 21087, 33681, 33635)

	-- Embossed Leather Pants -- 3759
	AddRecipe(3759, 75, 4242, Q.COMMON, V.ORIG, 75, 105, 120, 135)
	self:AddRecipeFlags(3759, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(3759, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 5564, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 3365, 3007, 18771, 16278, 21087, 33681, 33635)

	-- Hillman's Cloak -- 3760
	AddRecipe(3760, 150, 3719, Q.COMMON, V.ORIG, 150, 170, 180, 190)
	self:AddRecipeFlags(3760, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CLOAK)
	self:AddRecipeTrainer(3760, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Fine Leather Tunic -- 3761
	AddRecipe(3761, 85, 4243, Q.COMMON, V.ORIG, 85, 115, 130, 145)
	self:AddRecipeFlags(3761, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(3761, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 5564, 4212, 8153, 4588, 18771, 16728, 33612, 17442, 3549, 3007, 5127, 16278, 21087, 33681, 33635)

	-- Hillman's Leather Vest -- 3762
	AddRecipe(3762, 100, 4244, Q.UNCOMMON, V.ORIG, 100, 125, 137, 150)
	self:AddRecipeFlags(3762, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(3762, "Kalimdor", "Eastern Kingdoms")

	-- Fine Leather Belt -- 3763
	AddRecipe(3763, 80, 4246, Q.COMMON, V.ORIG, 80, 110, 125, 140)
	self:AddRecipeFlags(3763, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(3763, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 5564, 4212, 8153, 4588, 18771, 16728, 33612, 17442, 3549, 3007, 5127, 16278, 21087, 33681, 33635)

	-- Hillman's Leather Gloves -- 3764
	AddRecipe(3764, 145, 4247, Q.COMMON, V.ORIG, 145, 170, 182, 195)
	self:AddRecipeFlags(3764, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(3764, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Dark Leather Gloves -- 3765
	AddRecipe(3765, 120, 4248, Q.UNCOMMON, V.ORIG, 120, 155, 167, 180)
	self:AddRecipeFlags(3765, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeWorldDrop(3765, "Kalimdor", "Eastern Kingdoms")

	-- Dark Leather Belt -- 3766
	AddRecipe(3766, 125, 4249, Q.COMMON, V.ORIG, 125, 150, 162, 175)
	self:AddRecipeFlags(3766, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(3766, 1385, 3703, 16688, 5784, 3967, 19187, 11097, 18754, 3365, 3605, 11098, 1632, 4212, 4588, 18771, 33635, 5127, 33612, 16728, 8153, 3007, 3549, 16278, 21087, 33681, 5564)

	-- Hillman's Belt -- 3767
	AddRecipe(3767, 120, 4250, Q.UNCOMMON, V.ORIG, 120, 145, 157, 170)
	self:AddRecipeFlags(3767, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(3767, "Kalimdor", "Eastern Kingdoms")

	-- Hillman's Shoulders -- 3768
	AddRecipe(3768, 130, 4251, Q.COMMON, V.ORIG, 130, 155, 167, 180)
	self:AddRecipeFlags(3768, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(3768, 1385, 3703, 16688, 5784, 3967, 19187, 11097, 18754, 3365, 3605, 11098, 18771, 4212, 4588, 3549, 33635, 5127, 33612, 17442, 16728, 3007, 8153, 16278, 21087, 1632, 5564)

	-- Dark Leather Shoulders -- 3769
	AddRecipe(3769, 140, 4252, Q.UNCOMMON, V.ORIG, 140, 165, 177, 190)
	self:AddRecipeFlags(3769, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(3769, "Kalimdor", "Eastern Kingdoms")

	-- Toughened Leather Gloves -- 3770
	AddRecipe(3770, 135, 4253, Q.COMMON, V.ORIG, 135, 160, 172, 185)
	self:AddRecipeFlags(3770, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(3770, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Barbaric Gloves -- 3771
	AddRecipe(3771, 150, 4254, Q.UNCOMMON, V.ORIG, 150, 170, 180, 190)
	self:AddRecipeFlags(3771, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(3771, "Kalimdor", "Eastern Kingdoms")

	-- Green Leather Armor -- 3772
	AddRecipe(3772, 155, 4255, Q.COMMON, V.ORIG, 155, 175, 185, 195)
	self:AddRecipeFlags(3772, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.TANK, F.LEATHER)
	self:AddRecipeVendor(3772, 2679, 2698)

	-- Guardian Armor -- 3773
	AddRecipe(3773, 175, 4256, Q.UNCOMMON, V.ORIG, 175, 195, 205, 215)
	self:AddRecipeFlags(3773, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(3773, "Kalimdor", "Eastern Kingdoms")

	-- Green Leather Belt -- 3774
	AddRecipe(3774, 160, 4257, Q.COMMON, V.ORIG, 160, 180, 190, 200)
	self:AddRecipeFlags(3774, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK, F.LEATHER)
	self:AddRecipeTrainer(3774, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Guardian Belt -- 3775
	AddRecipe(3775, 170, 4258, Q.RARE, V.ORIG, 170, 190, 200, 210)
	self:AddRecipeFlags(3775, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(3775, "Kalimdor", "Eastern Kingdoms")

	-- Green Leather Bracers -- 3776
	AddRecipe(3776, 180, 4259, Q.COMMON, V.ORIG, 180, 200, 210, 220)
	self:AddRecipeFlags(3776, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK, F.LEATHER)
	self:AddRecipeTrainer(3776, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Guardian Leather Bracers -- 3777
	AddRecipe(3777, 195, 4260, Q.UNCOMMON, V.ORIG, 195, 215, 225, 235)
	self:AddRecipeFlags(3777, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(3777, "Kalimdor", "Eastern Kingdoms")

	-- Gem-studded Leather Belt -- 3778
	AddRecipe(3778, 185, 4262, Q.COMMON, V.ORIG, 185, 205, 215, 225)
	self:AddRecipeFlags(3778, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeVendor(3778, 2699)

	-- Barbaric Belt -- 3779
	AddRecipe(3779, 200, 4264, Q.RARE, V.ORIG, 200, 220, 230, 240)
	self:AddRecipeFlags(3779, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(3779, "Kalimdor", "Eastern Kingdoms")

	-- Heavy Armor Kit -- 3780
	AddRecipe(3780, 150, 4265, Q.COMMON, V.ORIG, 150, 170, 180, 190)
	self:AddRecipeFlags(3780, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3780, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Cured Light Hide -- 3816
	AddRecipe(3816, 35, 4231, Q.COMMON, V.ORIG, 35, 55, 65, 75)
	self:AddRecipeFlags(3816, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3816, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 3365, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 5564, 3007, 18771, 16278, 21087, 33681, 33635)

	-- Cured Medium Hide -- 3817
	AddRecipe(3817, 100, 4233, Q.COMMON, V.ORIG, 100, 115, 122, 130)
	self:AddRecipeFlags(3817, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3817, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 5564, 4212, 8153, 4588, 18771, 16728, 33612, 17442, 3549, 3007, 5127, 16278, 21087, 33681, 33635)

	-- Cured Heavy Hide -- 3818
	AddRecipe(3818, 150, 4236, Q.COMMON, V.ORIG, 150, 160, 165, 170)
	self:AddRecipeFlags(3818, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(3818, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Raptor Hide Harness -- 4096
	AddRecipe(4096, 165, 4455, Q.UNCOMMON, V.WOTLK, 165, 185, 195, 205)
	self:AddRecipeFlags(4096, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeLimitedVendor(4096, 2819, 1)

	-- Raptor Hide Belt -- 4097
	AddRecipe(4097, 165, 4456, Q.UNCOMMON, V.ORIG, 165, 185, 195, 205)
	self:AddRecipeFlags(4097, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeVendor(4097, 2816)

	-- Kodo Hide Bag -- 5244
	AddRecipe(5244, 40, 5081, Q.UNCOMMON, V.ORIG, 40, 70, 85, 100)
	self:AddRecipeFlags(5244, F.HORDE, F.QUEST, F.IBOE, F.RBOE)
	self:AddRecipeQuest(5244, 769)

	-- Barbaric Harness -- 6661
	AddRecipe(6661, 190, 5739, Q.COMMON, V.ORIG, 190, 210, 220, 230)
	self:AddRecipeFlags(6661, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(6661, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Murloc Scale Belt -- 6702
	AddRecipe(6702, 90, 5780, Q.COMMON, V.ORIG, 90, 120, 135, 150)
	self:AddRecipeFlags(6702, F.ALLIANCE, F.HORDE, F.VENDOR, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeMobDrop(6702, 1732, 3385)
	self:AddRecipeVendor(6702, 843, 3556, 4186)

	-- Murloc Scale Breastplate -- 6703
	AddRecipe(6703, 95, 5781, Q.COMMON, V.ORIG, 95, 125, 140, 155)
	self:AddRecipeFlags(6703, F.ALLIANCE, F.HORDE, F.VENDOR, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeMobDrop(6703, 657, 3386)
	self:AddRecipeVendor(6703, 843, 3556, 4186)

	-- Thick Murloc Armor -- 6704
	AddRecipe(6704, 170, 5782, Q.UNCOMMON, V.ORIG, 170, 190, 200, 210)
	self:AddRecipeFlags(6704, F.ALLIANCE, F.HORDE, F.VENDOR, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeMobDrop(6704, 938, 1160)
	self:AddRecipeLimitedVendor(6704, 2381, 1, 2393, 1, 2846, 1)

	-- Murloc Scale Bracers -- 6705
	AddRecipe(6705, 190, 5783, Q.UNCOMMON, V.ORIG, 190, 210, 220, 230)
	self:AddRecipeFlags(6705, F.ALLIANCE, F.HORDE, F.VENDOR, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeMobDrop(6705, 2636, 1561)
	self:AddRecipeVendor(6705, 4897)

	-- Handstitched Leather Vest -- 7126
	AddRecipe(7126, 1, 5957, Q.COMMON, V.ORIG, 1, 40, 55, 70)
	self:AddRecipeFlags(7126, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeAcquire(7126, A.CUSTOM, 8)

	-- Fine Leather Pants -- 7133
	AddRecipe(7133, 105, 5958, Q.UNCOMMON, V.ORIG, 105, 130, 142, 155)
	self:AddRecipeFlags(7133, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(7133, "Kalimdor", "Eastern Kingdoms")

	-- Dark Leather Pants -- 7135
	AddRecipe(7135, 115, 5961, Q.COMMON, V.ORIG, 115, 140, 152, 165)
	self:AddRecipeFlags(7135, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(7135, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Guardian Pants -- 7147
	AddRecipe(7147, 160, 5962, Q.COMMON, V.ORIG, 160, 180, 190, 200)
	self:AddRecipeFlags(7147, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(7147, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Barbaric Leggings -- 7149
	AddRecipe(7149, 170, 5963, Q.COMMON, V.ORIG, 170, 190, 200, 210)
	self:AddRecipeFlags(7149, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeVendor(7149, 3958, 2810, 4877, 2821)

	-- Barbaric Shoulders -- 7151
	AddRecipe(7151, 175, 5964, Q.COMMON, V.ORIG, 175, 195, 205, 215)
	self:AddRecipeFlags(7151, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(7151, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Guardian Cloak -- 7153
	AddRecipe(7153, 185, 5965, Q.UNCOMMON, V.ORIG, 185, 205, 215, 225)
	self:AddRecipeFlags(7153, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.CLOAK)
	self:AddRecipeWorldDrop(7153, "Kalimdor", "Eastern Kingdoms")

	-- Guardian Gloves -- 7156
	AddRecipe(7156, 190, 5966, Q.COMMON, V.ORIG, 190, 210, 220, 230)
	self:AddRecipeFlags(7156, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(7156, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Deviate Scale Cloak -- 7953
	AddRecipe(7953, 90, 6466, Q.COMMON, V.ORIG, 90, 120, 135, 150)
	self:AddRecipeFlags(7953, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.CLOAK)
	self:AddRecipeLimitedVendor(7953, 5783, 2)

	-- Deviate Scale Gloves -- 7954
	AddRecipe(7954, 105, 6467, Q.COMMON, V.ORIG, 105, 130, 142, 155)
	self:AddRecipeFlags(7954, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeLimitedVendor(7954, 5783, 1)

	-- Deviate Scale Belt -- 7955
	AddRecipe(7955, 115, 6468, Q.UNCOMMON, V.ORIG, 115, 140, 152, 165)
	self:AddRecipeFlags(7955, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeQuest(7955, 1487)

	-- Moonglow Vest -- 8322
	AddRecipe(8322, 90, 6709, Q.UNCOMMON, V.ORIG, 90, 115, 130, 145)
	self:AddRecipeFlags(8322, F.ALLIANCE, F.QUEST, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeQuest(8322, 1582)

	-- Handstitched Leather Cloak -- 9058
	AddRecipe(9058, 1, 7276, Q.COMMON, V.ORIG, 1, 40, 55, 70)
	self:AddRecipeFlags(9058, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.CLOAK)
	self:AddRecipeAcquire(9058, A.CUSTOM, 8)

	-- Handstitched Leather Bracers -- 9059
	AddRecipe(9059, 1, 7277, Q.COMMON, V.ORIG, 1, 40, 55, 70)
	self:AddRecipeFlags(9059, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeAcquire(9059, A.CUSTOM, 8)

	-- Light Leather Quiver -- 9060
	AddRecipe(9060, 30, 7278, Q.COMMON, V.ORIG, 30, 60, 75, 90)
	self:AddRecipeFlags(9060, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(9060, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 3365, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 5564, 3007, 18771, 16278, 21087, 33681, 33635)

	-- Small Leather Ammo Pouch -- 9062
	AddRecipe(9062, 30, 7279, Q.COMMON, V.ORIG, 30, 60, 75, 90)
	self:AddRecipeFlags(9062, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.AMMO)
	self:AddRecipeTrainer(9062, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 5564, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 3365, 3007, 18771, 16278, 21087, 33681, 33635)

	-- Rugged Leather Pants -- 9064
	AddRecipe(9064, 35, 7280, Q.UNCOMMON, V.ORIG, 35, 65, 80, 95)
	self:AddRecipeFlags(9064, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeWorldDrop(9064, "Kalimdor", "Eastern Kingdoms")

	-- Light Leather Bracers -- 9065
	AddRecipe(9065, 70, 7281, Q.COMMON, V.ORIG, 70, 100, 115, 130)
	self:AddRecipeFlags(9065, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(9065, 1385, 3703, 16688, 4212, 5784, 1632, 3967, 19187, 11097, 18754, 4588, 3605, 11098, 5564, 3549, 8153, 3069, 5127, 16728, 33612, 17442, 3365, 3007, 18771, 16278, 21087, 33681, 33635)

	-- Light Leather Pants -- 9068
	AddRecipe(9068, 95, 7282, Q.COMMON, V.ORIG, 95, 125, 140, 155)
	self:AddRecipeFlags(9068, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(9068, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Black Whelp Cloak -- 9070
	AddRecipe(9070, 100, 7283, Q.COMMON, V.ORIG, 100, 125, 137, 150)
	self:AddRecipeFlags(9070, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeVendor(9070, 2697)

	-- Red Whelp Gloves -- 9072
	AddRecipe(9072, 120, 7284, Q.COMMON, V.ORIG, 120, 145, 157, 170)
	self:AddRecipeFlags(9072, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeVendor(9072, 2679)

	-- Nimble Leather Gloves -- 9074
	AddRecipe(9074, 120, 7285, Q.COMMON, V.ORIG, 120, 145, 157, 170)
	self:AddRecipeFlags(9074, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(9074, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Fletcher's Gloves -- 9145
	AddRecipe(9145, 125, 7348, Q.COMMON, V.ORIG, 125, 150, 162, 175)
	self:AddRecipeFlags(9145, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(9145, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Herbalist's Gloves -- 9146
	AddRecipe(9146, 135, 7349, Q.UNCOMMON, V.ORIG, 135, 160, 172, 185)
	self:AddRecipeFlags(9146, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeVendor(9146, 6731)

	-- Earthen Leather Shoulders -- 9147
	AddRecipe(9147, 135, 7352, Q.COMMON, V.ORIG, 135, 160, 172, 185)
	self:AddRecipeFlags(9147, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeVendor(9147, 3537)

	-- Pilferer's Gloves -- 9148
	AddRecipe(9148, 140, 7358, Q.UNCOMMON, V.ORIG, 140, 165, 177, 190)
	self:AddRecipeFlags(9148, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(9148, "Kalimdor", "Eastern Kingdoms")

	-- Heavy Earthen Gloves -- 9149
	AddRecipe(9149, 145, 7359, Q.UNCOMMON, V.ORIG, 145, 170, 182, 195)
	self:AddRecipeFlags(9149, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(9149, "Kalimdor", "Eastern Kingdoms")

	-- Heavy Quiver -- 9193
	AddRecipe(9193, 150, 7371, Q.COMMON, V.ORIG, 150, 170, 180, 190)
	self:AddRecipeFlags(9193, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(9193, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Heavy Leather Ammo Pouch -- 9194
	AddRecipe(9194, 150, 7372, Q.COMMON, V.ORIG, 150, 170, 180, 190)
	self:AddRecipeFlags(9194, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.AMMO)
	self:AddRecipeTrainer(9194, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Dusky Leather Leggings -- 9195
	AddRecipe(9195, 165, 7373, Q.UNCOMMON, V.ORIG, 165, 185, 195, 205)
	self:AddRecipeFlags(9195, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(9195, "Kalimdor", "Eastern Kingdoms")

	-- Dusky Leather Armor -- 9196
	AddRecipe(9196, 175, 7374, Q.COMMON, V.ORIG, 175, 195, 205, 215)
	self:AddRecipeFlags(9196, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(9196, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Green Whelp Armor -- 9197
	AddRecipe(9197, 175, 7375, Q.UNCOMMON, V.ORIG, 175, 195, 205, 215)
	self:AddRecipeFlags(9197, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(9197, "Kalimdor", "Eastern Kingdoms")

	-- Frost Leather Cloak -- 9198
	AddRecipe(9198, 180, 7377, Q.COMMON, V.ORIG, 180, 200, 210, 220)
	self:AddRecipeFlags(9198, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.CLOAK)
	self:AddRecipeTrainer(9198, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Dusky Bracers -- 9201
	AddRecipe(9201, 185, 7378, Q.COMMON, V.ORIG, 185, 205, 215, 225)
	self:AddRecipeFlags(9201, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(9201, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Green Whelp Bracers -- 9202
	AddRecipe(9202, 190, 7386, Q.UNCOMMON, V.ORIG, 190, 210, 220, 230)
	self:AddRecipeFlags(9202, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeVendor(9202, 7854, 7852, 4589, 4225)

	-- Dusky Belt -- 9206
	AddRecipe(9206, 195, 7387, Q.COMMON, V.ORIG, 195, 215, 225, 235)
	self:AddRecipeFlags(9206, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(9206, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Dusky Boots -- 9207
	AddRecipe(9207, 200, 7390, Q.RARE, V.ORIG, 200, 220, 230, 240)
	self:AddRecipeFlags(9207, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(9207, "Kalimdor", "Eastern Kingdoms")

	-- Swift Boots -- 9208
	AddRecipe(9208, 200, 7391, Q.UNCOMMON, V.ORIG, 200, 220, 230, 240)
	self:AddRecipeFlags(9208, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeWorldDrop(9208, "Kalimdor", "Eastern Kingdoms")

	-- Cured Thick Hide -- 10482
	AddRecipe(10482, 200, 8172, Q.COMMON, V.ORIG, 200, 200, 200, 200)
	self:AddRecipeFlags(10482, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(10482, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Thick Armor Kit -- 10487
	AddRecipe(10487, 200, 8173, Q.COMMON, V.ORIG, 200, 220, 230, 240)
	self:AddRecipeFlags(10487, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(10487, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Comfortable Leather Hat -- 10490
	AddRecipe(10490, 200, 8174, Q.RARE, V.ORIG, 200, 220, 230, 240)
	self:AddRecipeFlags(10490, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeWorldDrop(10490, "Kalimdor", "Eastern Kingdoms")

	-- Nightscape Tunic -- 10499
	AddRecipe(10499, 205, 8175, Q.COMMON, V.ORIG, 205, 225, 235, 245)
	self:AddRecipeFlags(10499, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(10499, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Nightscape Headband -- 10507
	AddRecipe(10507, 205, 8176, Q.COMMON, V.ORIG, 205, 225, 235, 245)
	self:AddRecipeFlags(10507, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(10507, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Turtle Scale Gloves -- 10509
	AddRecipe(10509, 205, 8187, Q.COMMON, V.ORIG, 205, 225, 235, 245)
	self:AddRecipeFlags(10509, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(10509, 7852, 7854)

	-- Turtle Scale Breastplate -- 10511
	AddRecipe(10511, 210, 8189, Q.COMMON, V.ORIG, 210, 230, 240, 250)
	self:AddRecipeFlags(10511, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(10511, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Nightscape Shoulders -- 10516
	AddRecipe(10516, 210, 8192, Q.UNCOMMON, V.ORIG, 210, 230, 240, 250)
	self:AddRecipeFlags(10516, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeVendor(10516, 7854, 8160)

	-- Turtle Scale Bracers -- 10518
	AddRecipe(10518, 210, 8198, Q.COMMON, V.ORIG, 210, 230, 240, 250)
	self:AddRecipeFlags(10518, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.MAIL)
	self:AddRecipeTrainer(10518, 1385, 3703, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 3549, 3365, 4212, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 4588)

	-- Big Voodoo Robe -- 10520
	AddRecipe(10520, 215, 8200, Q.UNCOMMON, V.ORIG, 215, 235, 245, 255)
	self:AddRecipeFlags(10520, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(10520, "Kalimdor", "Eastern Kingdoms")

	-- Tough Scorpid Breastplate -- 10525
	AddRecipe(10525, 220, 8203, Q.UNCOMMON, V.ORIG, 220, 240, 250, 260)
	self:AddRecipeFlags(10525, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(10525, 5618)

	-- Wild Leather Shoulders -- 10529
	AddRecipe(10529, 220, 8210, Q.UNCOMMON, V.ORIG, 220, 240, 250, 260)
	self:AddRecipeFlags(10529, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeQuest(10529, 2848, 2855)

	-- Big Voodoo Mask -- 10531
	AddRecipe(10531, 220, 8201, Q.UNCOMMON, V.ORIG, 220, 240, 250, 260)
	self:AddRecipeFlags(10531, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(10531, "Kalimdor", "Eastern Kingdoms")

	-- Tough Scorpid Bracers -- 10533
	AddRecipe(10533, 220, 8205, Q.UNCOMMON, V.ORIG, 220, 240, 250, 260)
	self:AddRecipeFlags(10533, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(10533, 5617)

	-- Tough Scorpid Gloves -- 10542
	AddRecipe(10542, 225, 8204, Q.UNCOMMON, V.ORIG, 225, 245, 255, 265)
	self:AddRecipeFlags(10542, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(10542, 5616)

	-- Wild Leather Vest -- 10544
	AddRecipe(10544, 225, 8211, Q.UNCOMMON, V.ORIG, 225, 245, 255, 265)
	self:AddRecipeFlags(10544, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeQuest(10544, 2849, 2856)

	-- Wild Leather Helmet -- 10546
	AddRecipe(10546, 225, 8214, Q.UNCOMMON, V.ORIG, 225, 245, 255, 265)
	self:AddRecipeFlags(10546, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeQuest(10546, 2850, 2857)

	-- Nightscape Pants -- 10548
	AddRecipe(10548, 230, 8193, Q.COMMON, V.ORIG, 230, 250, 260, 270)
	self:AddRecipeFlags(10548, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(10548, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Turtle Scale Helm -- 10552
	AddRecipe(10552, 230, 8191, Q.COMMON, V.ORIG, 230, 250, 260, 270)
	self:AddRecipeFlags(10552, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(10552, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Tough Scorpid Boots -- 10554
	AddRecipe(10554, 235, 8209, Q.UNCOMMON, V.ORIG, 235, 255, 265, 275)
	self:AddRecipeFlags(10554, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(10554, 5615)

	-- Turtle Scale Leggings -- 10556
	AddRecipe(10556, 235, 8185, Q.COMMON, V.ORIG, 235, 255, 265, 275)
	self:AddRecipeFlags(10556, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(10556, 1385, 3703, 16688, 5784, 3967, 19187, 11097, 18754, 11098, 33635, 18771, 1632, 3549, 3365, 4212, 16728, 5127, 33612, 17442, 5564, 3007, 8153, 16278, 21087, 33681, 4588)

	-- Nightscape Boots -- 10558
	AddRecipe(10558, 235, 8197, Q.COMMON, V.ORIG, 235, 255, 265, 275)
	self:AddRecipeFlags(10558, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(10558, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Big Voodoo Pants -- 10560
	AddRecipe(10560, 240, 8202, Q.UNCOMMON, V.ORIG, 240, 260, 270, 280)
	self:AddRecipeFlags(10560, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(10560, "Kalimdor", "Eastern Kingdoms")

	-- Big Voodoo Cloak -- 10562
	AddRecipe(10562, 240, 8216, Q.UNCOMMON, V.ORIG, 240, 260, 270, 280)
	self:AddRecipeFlags(10562, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.CLOAK)
	self:AddRecipeWorldDrop(10562, "Kalimdor", "Eastern Kingdoms")

	-- Tough Scorpid Shoulders -- 10564
	AddRecipe(10564, 240, 8207, Q.UNCOMMON, V.ORIG, 240, 260, 270, 280)
	self:AddRecipeFlags(10564, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(10564, 5623, 7805, 7883)

	-- Wild Leather Boots -- 10566
	AddRecipe(10566, 245, 8213, Q.UNCOMMON, V.ORIG, 245, 265, 275, 285)
	self:AddRecipeFlags(10566, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeQuest(10566, 2851, 2858)

	-- Tough Scorpid Leggings -- 10568
	AddRecipe(10568, 245, 8206, Q.UNCOMMON, V.ORIG, 245, 265, 275, 285)
	self:AddRecipeFlags(10568, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(10568, 5615)

	-- Tough Scorpid Helm -- 10570
	AddRecipe(10570, 250, 8208, Q.UNCOMMON, V.ORIG, 250, 270, 280, 290)
	self:AddRecipeFlags(10570, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(10570, 5623, 7805, 7883)

	-- Wild Leather Leggings -- 10572
	AddRecipe(10572, 250, 8212, Q.UNCOMMON, V.ORIG, 250, 270, 280, 290)
	self:AddRecipeFlags(10572, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeQuest(10572, 2852, 2859)

	-- Wild Leather Cloak -- 10574
	AddRecipe(10574, 250, 8215, Q.UNCOMMON, V.ORIG, 250, 270, 280, 290)
	self:AddRecipeFlags(10574, F.ALLIANCE, F.HORDE, F.QUEST, F.IBOE, F.RBOP, F.CLOAK)
	self:AddRecipeQuest(10574, 2853, 2860)

	-- Dragonscale Gauntlets -- 10619
	AddRecipe(10619, 225, 8347, Q.COMMON, V.ORIG, 225, 245, 255, 265)
	self:AddRecipeFlags(10619, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.MAIL)
	self:AddRecipeTrainer(10619, 7866, 7867, 29508)

	-- Wolfshead Helm -- 10621
	AddRecipe(10621, 225, 8345, Q.COMMON, V.ORIG, 225, 245, 255, 265)
	self:AddRecipeFlags(10621, F.ALLIANCE, F.HORDE, F.TRAINER, F.DRUID, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(10621, 29509, 7870, 7871)

	-- Gauntlets of the Sea -- 10630
	AddRecipe(10630, 230, 8346, Q.COMMON, V.ORIG, 230, 250, 260, 270)
	self:AddRecipeFlags(10630, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(10630, 7869, 29507, 7868)

	-- Helm of Fire -- 10632
	AddRecipe(10632, 250, 8348, Q.COMMON, V.ORIG, 250, 270, 280, 290)
	self:AddRecipeFlags(10632, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(10632, 7869, 29507, 7868)

	-- Feathered Breastplate -- 10647
	AddRecipe(10647, 250, 8349, Q.COMMON, V.ORIG, 250, 270, 280, 290)
	self:AddRecipeFlags(10647, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(10647, 29509, 7870, 7871)

	-- Dragonscale Breastplate -- 10650
	AddRecipe(10650, 255, 8367, Q.COMMON, V.ORIG, 255, 275, 285, 295)
	self:AddRecipeFlags(10650, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.MAIL)
	self:AddRecipeTrainer(10650, 7866, 7867, 29508)

	-- Quickdraw Quiver -- 14930
	AddRecipe(14930, 225, 8217, Q.COMMON, V.ORIG, 225, 245, 255, 265)
	self:AddRecipeFlags(14930, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(14930, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Thick Leather Ammo Pouch -- 14932
	AddRecipe(14932, 225, 8218, Q.COMMON, V.ORIG, 225, 245, 255, 265)
	self:AddRecipeFlags(14932, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.AMMO)
	self:AddRecipeTrainer(14932, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Cured Rugged Hide -- 19047
	AddRecipe(19047, 250, 15407, Q.COMMON, V.ORIG, 250, 250, 255, 260)
	self:AddRecipeFlags(19047, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(19047, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Heavy Scorpid Bracers -- 19048
	AddRecipe(19048, 255, 15077, Q.COMMON, V.ORIG, 255, 275, 285, 295)
	self:AddRecipeFlags(19048, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeVendor(19048, 12956)

	-- Wicked Leather Gauntlets -- 19049
	AddRecipe(19049, 260, 15083, Q.COMMON, V.ORIG, 260, 280, 290, 300)
	self:AddRecipeFlags(19049, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeVendor(19049, 12942, 12943)

	-- Green Dragonscale Breastplate -- 19050
	AddRecipe(19050, 260, 15045, Q.COMMON, V.ORIG, 260, 280, 290, 300)
	self:AddRecipeFlags(19050, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(19050, 11874)

	-- Heavy Scorpid Vest -- 19051
	AddRecipe(19051, 265, 15076, Q.UNCOMMON, V.ORIG, 265, 285, 295, 305)
	self:AddRecipeFlags(19051, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(19051, 5981, 6005)

	-- Wicked Leather Bracers -- 19052
	AddRecipe(19052, 265, 15084, Q.COMMON, V.ORIG, 265, 285, 295, 305)
	self:AddRecipeFlags(19052, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(19052, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Chimeric Gloves -- 19053
	AddRecipe(19053, 265, 15074, Q.COMMON, V.ORIG, 265, 285, 295, 305)
	self:AddRecipeFlags(19053, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeVendor(19053, 12957)

	-- Red Dragonscale Breastplate -- 19054
	AddRecipe(19054, 300, 15047, Q.RARE, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19054, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeMobDrop(19054, 10363)

	-- Runic Leather Gauntlets -- 19055
	AddRecipe(19055, 270, 15091, Q.COMMON, V.ORIG, 270, 290, 300, 310)
	self:AddRecipeFlags(19055, F.ALLIANCE, F.HORDE, F.TRAINER, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(19055, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)
	self:AddRecipeWorldDrop(19055, "Kalimdor", "Eastern Kingdoms")

	-- Rugged Armor Kit -- 19058
	AddRecipe(19058, 250, 15564, Q.COMMON, V.ORIG, 250, 255, 265, 275)
	self:AddRecipeFlags(19058, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(19058, 1385, 3703, 16688, 5784, 3967, 19187, 11097, 18754, 3365, 3605, 11098, 1632, 4212, 8153, 4588, 18771, 5127, 33612, 17442, 16728, 3007, 3549, 5564, 21087, 33681, 33635)

	-- Volcanic Leggings -- 19059
	AddRecipe(19059, 270, 15054, Q.UNCOMMON, V.ORIG, 270, 290, 300, 310)
	self:AddRecipeFlags(19059, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeMobDrop(19059, 7035)

	-- Green Dragonscale Leggings -- 19060
	AddRecipe(19060, 270, 15046, Q.RARE, V.ORIG, 270, 290, 300, 310)
	self:AddRecipeFlags(19060, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeMobDrop(19060, 5226)

	-- Living Shoulders -- 19061
	AddRecipe(19061, 270, 15061, Q.COMMON, V.ORIG, 270, 290, 300, 310)
	self:AddRecipeFlags(19061, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(19061, 7852, 7854)

	-- Ironfeather Shoulders -- 19062
	AddRecipe(19062, 270, 15067, Q.COMMON, V.ORIG, 270, 290, 300, 310)
	self:AddRecipeFlags(19062, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(19062, 12958)

	-- Chimeric Boots -- 19063
	AddRecipe(19063, 275, 15073, Q.UNCOMMON, V.ORIG, 275, 295, 305, 315)
	self:AddRecipeFlags(19063, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeWorldDrop(19063, "Kalimdor", "Eastern Kingdoms")

	-- Heavy Scorpid Gauntlets -- 19064
	AddRecipe(19064, 275, 15078, Q.UNCOMMON, V.ORIG, 275, 295, 305, 315)
	self:AddRecipeFlags(19064, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(19064, 7025)

	-- Runic Leather Bracers -- 19065
	AddRecipe(19065, 275, 15092, Q.COMMON, V.ORIG, 275, 295, 305, 315)
	self:AddRecipeFlags(19065, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(19065, 1385, 3703, 16688, 5784, 3967, 19187, 11097, 18754, 11098, 33635, 18771, 1632, 4212, 3365, 3605, 3549, 5127, 33612, 17442, 5564, 3007, 8153, 16728, 21087, 33681, 4588)

	-- Frostsaber Boots -- 19066
	AddRecipe(19066, 275, 15071, Q.COMMON, V.ORIG, 275, 295, 305, 315)
	self:AddRecipeFlags(19066, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeVendor(19066, 11189)

	-- Stormshroud Pants -- 19067
	AddRecipe(19067, 275, 15057, Q.COMMON, V.ORIG, 275, 295, 305, 315)
	self:AddRecipeFlags(19067, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.TANK, F.LEATHER)
	self:AddRecipeVendor(19067, 12942, 12943)

	-- Warbear Harness -- 19068
	AddRecipe(19068, 275, 15064, Q.COMMON, V.ORIG, 275, 295, 305, 315)
	self:AddRecipeFlags(19068, F.ALLIANCE, F.HORDE, F.VENDOR, F.WORLD_DROP, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.TIMBERMAW_HOLD)
	self:AddRecipeRepVendor(19068, FAC.TIMBERMAW_HOLD, REP.FRIENDLY, 11557)

	-- Heavy Scorpid Belt -- 19070
	AddRecipe(19070, 280, 15082, Q.UNCOMMON, V.ORIG, 280, 300, 310, 320)
	self:AddRecipeFlags(19070, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeWorldDrop(19070, "Kalimdor", "Eastern Kingdoms")

	-- Wicked Leather Headband -- 19071
	AddRecipe(19071, 280, 15086, Q.COMMON, V.ORIG, 280, 300, 310, 320)
	self:AddRecipeFlags(19071, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(19071, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Runic Leather Belt -- 19072
	AddRecipe(19072, 280, 15093, Q.COMMON, V.ORIG, 280, 300, 310, 320)
	self:AddRecipeFlags(19072, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeTrainer(19072, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Chimeric Leggings -- 19073
	AddRecipe(19073, 280, 15072, Q.UNCOMMON, V.ORIG, 280, 300, 310, 320)
	self:AddRecipeFlags(19073, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeWorldDrop(19073, "Kalimdor", "Eastern Kingdoms")

	-- Frostsaber Leggings -- 19074
	AddRecipe(19074, 285, 15069, Q.UNCOMMON, V.ORIG, 285, 305, 315, 325)
	self:AddRecipeFlags(19074, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeMobDrop(19074, 7440)

	-- Heavy Scorpid Leggings -- 19075
	AddRecipe(19075, 285, 15079, Q.UNCOMMON, V.ORIG, 285, 305, 315, 325)
	self:AddRecipeFlags(19075, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(19075, 7027)

	-- Volcanic Breastplate -- 19076
	AddRecipe(19076, 285, 15053, Q.UNCOMMON, V.ORIG, 285, 305, 315, 325)
	self:AddRecipeFlags(19076, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeMobDrop(19076, 9259)

	-- Blue Dragonscale Breastplate -- 19077
	AddRecipe(19077, 285, 15048, Q.COMMON, V.ORIG, 285, 305, 315, 325)
	self:AddRecipeFlags(19077, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(19077, 12957)

	-- Living Leggings -- 19078
	AddRecipe(19078, 285, 15060, Q.RARE, V.ORIG, 285, 305, 315, 325)
	self:AddRecipeFlags(19078, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeMobDrop(19078, 7158)

	-- Stormshroud Armor -- 19079
	AddRecipe(19079, 285, 15056, Q.RARE, V.ORIG, 285, 305, 315, 325)
	self:AddRecipeFlags(19079, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.TANK, F.LEATHER)
	self:AddRecipeMobDrop(19079, 6138)

	-- Warbear Woolies -- 19080
	AddRecipe(19080, 285, 15065, Q.COMMON, V.ORIG, 285, 305, 315, 325)
	self:AddRecipeFlags(19080, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.TIMBERMAW_HOLD)
	self:AddRecipeRepVendor(19080, FAC.TIMBERMAW_HOLD, REP.FRIENDLY, 11557)

	-- Chimeric Vest -- 19081
	AddRecipe(19081, 290, 15075, Q.UNCOMMON, V.ORIG, 290, 310, 320, 330)
	self:AddRecipeFlags(19081, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeWorldDrop(19081, "Kalimdor", "Eastern Kingdoms")

	-- Runic Leather Headband -- 19082
	AddRecipe(19082, 290, 15094, Q.COMMON, V.ORIG, 290, 310, 320, 330)
	self:AddRecipeFlags(19082, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeTrainer(19082, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Wicked Leather Pants -- 19083
	AddRecipe(19083, 290, 15087, Q.COMMON, V.ORIG, 290, 315, 325, 335)
	self:AddRecipeFlags(19083, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(19083, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Devilsaur Gauntlets -- 19084
	AddRecipe(19084, 290, 15063, Q.COMMON, V.ORIG, 290, 310, 320, 330)
	self:AddRecipeFlags(19084, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeVendor(19084, 12959)

	-- Black Dragonscale Breastplate -- 19085
	AddRecipe(19085, 290, 15050, Q.COMMON, V.ORIG, 290, 310, 320, 330)
	self:AddRecipeFlags(19085, F.ALLIANCE, F.HORDE, F.VENDOR, F.INSTANCE, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeVendor(19085, 9499)

	-- Ironfeather Breastplate -- 19086
	AddRecipe(19086, 290, 15066, Q.RARE, V.ORIG, 290, 310, 320, 330)
	self:AddRecipeFlags(19086, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeMobDrop(19086, 2644)

	-- Frostsaber Gloves -- 19087
	AddRecipe(19087, 295, 15070, Q.UNCOMMON, V.ORIG, 295, 315, 325, 335)
	self:AddRecipeFlags(19087, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeMobDrop(19087, 7441)

	-- Heavy Scorpid Helm -- 19088
	AddRecipe(19088, 295, 15080, Q.COMMON, V.ORIG, 295, 315, 325, 335)
	self:AddRecipeFlags(19088, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeVendor(19088, 12956)

	-- Blue Dragonscale Shoulders -- 19089
	AddRecipe(19089, 295, 15049, Q.RARE, V.ORIG, 295, 315, 325, 335)
	self:AddRecipeFlags(19089, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeMobDrop(19089, 6146)

	-- Stormshroud Shoulders -- 19090
	AddRecipe(19090, 295, 15058, Q.RARE, V.ORIG, 295, 315, 325, 335)
	self:AddRecipeFlags(19090, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.TANK, F.LEATHER)
	self:AddRecipeMobDrop(19090, 6144)

	-- Runic Leather Pants -- 19091
	AddRecipe(19091, 300, 15095, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19091, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(19091, 1385, 3703, 16688, 5784, 3967, 19187, 11097, 18754, 11098, 33635, 18771, 1632, 4212, 3365, 4588, 3605, 16728, 33612, 17442, 3549, 3007, 8153, 16278, 21087, 33681, 5564)

	-- Wicked Leather Belt -- 19092
	AddRecipe(19092, 300, 15088, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19092, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(19092, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Onyxia Scale Cloak -- 19093
	AddRecipe(19093, 300, 15138, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19093, F.ALLIANCE, F.HORDE, F.RAID, F.QUEST, F.IBOE, F.RBOP, F.CLOAK)
	self:AddRecipeQuest(19093, 7493, 7497)
	self:AddRecipeAcquire(19093, A.CUSTOM, 10)

	-- Black Dragonscale Shoulders -- 19094
	AddRecipe(19094, 300, 15051, Q.RARE, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19094, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(19094, 8898)

	-- Living Breastplate -- 19095
	AddRecipe(19095, 300, 15059, Q.RARE, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19095, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeMobDrop(19095, 1813)

	-- Devilsaur Leggings -- 19097
	AddRecipe(19097, 300, 15062, Q.RARE, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19097, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeMobDrop(19097, 6559, 6556, 9477, 6557)

	-- Wicked Leather Armor -- 19098
	AddRecipe(19098, 300, 15085, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19098, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(19098, 1385, 3703, 16688, 5784, 3967, 19187, 11097, 18754, 3365, 33635, 18771, 1632, 4212, 8153, 4588, 5564, 5127, 33612, 17442, 16728, 3007, 3549, 16278, 21087, 33681, 11098)

	-- Heavy Scorpid Shoulders -- 19100
	AddRecipe(19100, 300, 15081, Q.UNCOMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19100, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(19100, 7029)

	-- Volcanic Shoulders -- 19101
	AddRecipe(19101, 300, 15055, Q.UNCOMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19101, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeMobDrop(19101, 9260)

	-- Runic Leather Armor -- 19102
	AddRecipe(19102, 300, 15090, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19102, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(19102, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Runic Leather Shoulders -- 19103
	AddRecipe(19103, 300, 15096, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19103, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeTrainer(19103, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 4588, 4212, 8153, 18771, 16728, 5127, 33612, 17442, 3549, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Frostsaber Tunic -- 19104
	AddRecipe(19104, 300, 15068, Q.UNCOMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19104, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeMobDrop(19104, 7438)

	-- Black Dragonscale Leggings -- 19107
	AddRecipe(19107, 300, 15052, Q.RARE, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(19107, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(19107, 8903)

	-- Medium Leather -- 20648
	AddRecipe(20648, 100, 2319, Q.COMMON, V.ORIG, 100, 100, 105, 110)
	self:AddRecipeFlags(20648, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(20648, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 11098, 5564, 4212, 8153, 4588, 18771, 16728, 33612, 17442, 3549, 3007, 5127, 16278, 21087, 33681, 33635)

	-- Heavy Leather -- 20649
	AddRecipe(20649, 150, 4234, Q.COMMON, V.ORIG, 150, 150, 155, 160)
	self:AddRecipeFlags(20649, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(20649, 1385, 3703, 16688, 5784, 3365, 3967, 19187, 11097, 18754, 1632, 3605, 18771, 3549, 4212, 4588, 11098, 16728, 5127, 33612, 17442, 8153, 3007, 33635, 16278, 21087, 33681, 5564)

	-- Thick Leather -- 20650
	AddRecipe(20650, 200, 4304, Q.COMMON, V.ORIG, 200, 200, 202, 205)
	self:AddRecipeFlags(20650, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(20650, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Corehound Boots -- 20853
	AddRecipe(20853, 295, 16982, Q.COMMON, V.ORIG, 295, 315, 325, 335)
	self:AddRecipeFlags(20853, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(20853, 12944)

	-- Molten Helm -- 20854
	AddRecipe(20854, 300, 16983, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(20854, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.LEATHER)
	self:AddRecipeVendor(20854, 12944)

	-- Black Dragonscale Boots -- 20855
	AddRecipe(20855, 300, 16984, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(20855, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.THORIUM_BROTHERHOOD)
	self:AddRecipeRepVendor(20855, FAC.THORIUM_BROTHERHOOD, REP.HONORED, 12944)

	-- Gloves of the Greatfather -- 21943
	AddRecipe(21943, 190, 17721, Q.UNCOMMON, V.ORIG, 190, 210, 220, 230)
	self:AddRecipeFlags(21943, F.ALLIANCE, F.HORDE, F.SEASONAL, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeAcquire(21943, A.SEASONAL, 1)

	-- Rugged Leather -- 22331
	AddRecipe(22331, 250, 8170, Q.COMMON, V.ORIG, 250, 250, 250, 250)
	self:AddRecipeFlags(22331, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(22331, 1385, 3703, 16688, 5784, 11098, 3967, 19187, 11097, 18754, 1632, 33635, 18771, 3605, 4212, 4588, 3549, 5564, 5127, 33612, 17442, 8153, 3007, 16728, 16278, 21087, 33681, 3365)

	-- Shadowskin Gloves -- 22711
	AddRecipe(22711, 200, 18238, Q.COMMON, V.ORIG, 200, 210, 220, 230)
	self:AddRecipeFlags(22711, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeVendor(22711, 2699)

	-- Core Armor Kit -- 22727
	AddRecipe(22727, 300, 18251, Q.RARE, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(22727, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.TANK)
	self:AddRecipeAcquire(22727, A.CUSTOM, 26)

	-- Gordok Ogre Suit -- 22815
	AddRecipe(22815, 275, 18258, Q.COMMON, V.ORIG, 275, 285, 290, 385)
	self:AddRecipeFlags(22815, F.ALLIANCE, F.HORDE, F.INSTANCE, F.QUEST, F.IBOE, F.RBOP)
	self:AddRecipeQuest(22815, 5518)

	-- Girdle of Insight -- 22921
	AddRecipe(22921, 300, 18504, Q.RARE, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(22921, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeAcquire(22921, A.CUSTOM, 23)

	-- Mongoose Boots -- 22922
	AddRecipe(22922, 300, 18506, Q.RARE, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(22922, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeAcquire(22922, A.CUSTOM, 23)

	-- Swift Flight Bracers -- 22923
	AddRecipe(22923, 300, 18508, Q.RARE, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(22923, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeAcquire(22923, A.CUSTOM, 23)

	-- Chromatic Cloak -- 22926
	AddRecipe(22926, 300, 18509, Q.EPIC, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(22926, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOE, F.CLOAK)
	self:AddRecipeAcquire(22926, A.CUSTOM, 23)

	-- Hide of the Wild -- 22927
	AddRecipe(22927, 300, 18510, Q.EPIC, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(22927, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.CLOAK)
	self:AddRecipeAcquire(22927, A.CUSTOM, 23)

	-- Shifting Cloak -- 22928
	AddRecipe(22928, 300, 18511, Q.EPIC, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(22928, F.ALLIANCE, F.HORDE, F.INSTANCE, F.IBOE, F.RBOE, F.TANK, F.CLOAK)
	self:AddRecipeAcquire(22928, A.CUSTOM, 23)

	-- Heavy Leather Ball -- 23190
	AddRecipe(23190, 150, 18662, Q.COMMON, V.ORIG, 150, 150, 155, 160)
	self:AddRecipeFlags(23190, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(23190, 5128, 3366)

	-- Barbaric Bracers -- 23399
	AddRecipe(23399, 155, 18948, Q.COMMON, V.ORIG, 155, 175, 185, 195)
	self:AddRecipeFlags(23399, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeVendor(23399, 4225, 4589)

	-- Might of the Timbermaw -- 23703
	AddRecipe(23703, 290, 19044, Q.COMMON, V.ORIG, 290, 310, 320, 330)
	self:AddRecipeFlags(23703, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.LEATHER, F.TIMBERMAW_HOLD)
	self:AddRecipeRepVendor(23703, FAC.TIMBERMAW_HOLD, REP.HONORED, 11557)

	-- Timbermaw Brawlers -- 23704
	AddRecipe(23704, 300, 19049, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(23704, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.TIMBERMAW_HOLD)
	self:AddRecipeRepVendor(23704, FAC.TIMBERMAW_HOLD, REP.REVERED, 11557)

	-- Dawn Treaders -- 23705
	AddRecipe(23705, 290, 19052, Q.COMMON, V.ORIG, 290, 310, 320, 330)
	self:AddRecipeFlags(23705, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.ARGENTDAWN)
	self:AddRecipeRepVendor(23705, FAC.ARGENTDAWN, REP.HONORED, 10856, 11536, 10857)

	-- Golden Mantle of the Dawn -- 23706
	AddRecipe(23706, 300, 19058, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(23706, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.LEATHER, F.ARGENTDAWN)
	self:AddRecipeRepVendor(23706, FAC.ARGENTDAWN, REP.REVERED, 10856, 11536, 10857)

	-- Lava Belt -- 23707
	AddRecipe(23707, 300, 19149, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(23707, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER, F.THORIUM_BROTHERHOOD)
	self:AddRecipeRepVendor(23707, FAC.THORIUM_BROTHERHOOD, REP.HONORED, 12944)

	-- Chromatic Gauntlets -- 23708
	AddRecipe(23708, 300, 19157, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(23708, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.THORIUM_BROTHERHOOD)
	self:AddRecipeRepVendor(23708, FAC.THORIUM_BROTHERHOOD, REP.REVERED, 12944)

	-- Corehound Belt -- 23709
	AddRecipe(23709, 300, 19162, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(23709, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER, F.THORIUM_BROTHERHOOD)
	self:AddRecipeRepVendor(23709, FAC.THORIUM_BROTHERHOOD, REP.REVERED, 12944)

	-- Molten Belt -- 23710
	AddRecipe(23710, 300, 19163, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(23710, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.THORIUM_BROTHERHOOD)
	self:AddRecipeRepVendor(23710, FAC.THORIUM_BROTHERHOOD, REP.REVERED, 12944)

	-- Primal Batskin Jerkin -- 24121
	AddRecipe(24121, 300, 19685, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24121, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.ZANDALAR)
	self:AddRecipeRepVendor(24121, FAC.ZANDALAR, REP.REVERED, 14921)

	-- Primal Batskin Gloves -- 24122
	AddRecipe(24122, 300, 19686, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24122, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.ZANDALAR)
	self:AddRecipeRepVendor(24122, FAC.ZANDALAR, REP.HONORED, 14921)

	-- Primal Batskin Bracers -- 24123
	AddRecipe(24123, 300, 19687, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24123, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.ZANDALAR)
	self:AddRecipeRepVendor(24123, FAC.ZANDALAR, REP.FRIENDLY, 14921)

	-- Blood Tiger Breastplate -- 24124
	AddRecipe(24124, 300, 19688, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24124, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER, F.ZANDALAR)
	self:AddRecipeRepVendor(24124, FAC.ZANDALAR, REP.REVERED, 14921)

	-- Blood Tiger Shoulders -- 24125
	AddRecipe(24125, 300, 19689, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24125, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER, F.ZANDALAR)
	self:AddRecipeRepVendor(24125, FAC.ZANDALAR, REP.HONORED, 14921)

	-- Blue Dragonscale Leggings -- 24654
	AddRecipe(24654, 300, 20295, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24654, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(24654, 7866, 7867, 29508)

	-- Green Dragonscale Gauntlets -- 24655
	AddRecipe(24655, 260, 20296, Q.COMMON, V.ORIG, 260, 280, 290, 300)
	self:AddRecipeFlags(24655, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(24655, 7866, 7867, 29508)

	-- Dreamscale Breastplate -- 24703
	AddRecipe(24703, 300, 20380, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24703, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(24703, FAC.CENARION_CIRCLE, REP.EXALTED, 15293)

	-- Spitfire Bracers -- 24846
	AddRecipe(24846, 300, 20481, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24846, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(24846, FAC.CENARION_CIRCLE, REP.FRIENDLY, 15293)

	-- Spitfire Gauntlets -- 24847
	AddRecipe(24847, 300, 20480, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24847, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(24847, FAC.CENARION_CIRCLE, REP.HONORED, 15293)

	-- Spitfire Breastplate -- 24848
	AddRecipe(24848, 300, 20479, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24848, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(24848, FAC.CENARION_CIRCLE, REP.REVERED, 15293)

	-- Sandstalker Bracers -- 24849
	AddRecipe(24849, 300, 20476, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24849, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.MAIL, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(24849, FAC.CENARION_CIRCLE, REP.FRIENDLY, 15293)

	-- Sandstalker Gauntlets -- 24850
	AddRecipe(24850, 300, 20477, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24850, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.MAIL, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(24850, FAC.CENARION_CIRCLE, REP.HONORED, 15293)

	-- Sandstalker Breastplate -- 24851
	AddRecipe(24851, 300, 20478, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(24851, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.MAIL, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(24851, FAC.CENARION_CIRCLE, REP.REVERED, 15293)

	-- Black Whelp Tunic -- 24940
	AddRecipe(24940, 100, 20575, Q.COMMON, V.ORIG, 100, 125, 137, 150)
	self:AddRecipeFlags(24940, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeVendor(24940, 777)

	-- Stormshroud Gloves -- 26279
	AddRecipe(26279, 300, 21278, Q.RARE, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(26279, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeMobDrop(26279, 14454, 14457)

	-- Polar Tunic -- 28219
	AddRecipe(28219, 300, 22661, Q.EPIC, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(28219, F.ALLIANCE, F.HORDE, F.RETIRED, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeRepVendor(28219, FAC.ARGENTDAWN, REP.EXALTED, 16365)
	self:AddRecipeAcquire(28219, A.CUSTOM, 41)

	-- Polar Gloves -- 28220
	AddRecipe(28220, 300, 22662, Q.EPIC, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(28220, F.ALLIANCE, F.HORDE, F.RETIRED, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeRepVendor(28220, FAC.ARGENTDAWN, REP.REVERED, 16365)
	self:AddRecipeAcquire(28220, A.CUSTOM, 41)

	-- Polar Bracers -- 28221
	AddRecipe(28221, 300, 22663, Q.EPIC, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(28221, F.ALLIANCE, F.HORDE, F.RETIRED, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeRepVendor(28221, FAC.ARGENTDAWN, REP.REVERED, 16365)
	self:AddRecipeAcquire(28221, A.CUSTOM, 41)

	-- Icy Scale Breastplate -- 28222
	AddRecipe(28222, 300, 22664, Q.EPIC, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(28222, F.ALLIANCE, F.HORDE, F.RETIRED, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeRepVendor(28222, FAC.ARGENTDAWN, REP.EXALTED, 16365)
	self:AddRecipeAcquire(28222, A.CUSTOM, 41)

	-- Icy Scale Gauntlets -- 28223
	AddRecipe(28223, 300, 22666, Q.EPIC, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(28223, F.ALLIANCE, F.HORDE, F.RETIRED, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeRepVendor(28223, FAC.ARGENTDAWN, REP.REVERED, 16365)
	self:AddRecipeAcquire(28223, A.CUSTOM, 41)

	-- Icy Scale Bracers -- 28224
	AddRecipe(28224, 300, 22665, Q.EPIC, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(28224, F.ALLIANCE, F.HORDE, F.RETIRED, F.VENDOR, F.RAID, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeRepVendor(28224, FAC.ARGENTDAWN, REP.REVERED, 16365)
	self:AddRecipeAcquire(28224, A.CUSTOM, 41)

	-- Bramblewood Helm -- 28472
	AddRecipe(28472, 300, 22759, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(28472, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(28472, FAC.CENARION_CIRCLE, REP.REVERED, 15293)

	-- Bramblewood Boots -- 28473
	AddRecipe(28473, 300, 22760, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(28473, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(28473, FAC.CENARION_CIRCLE, REP.HONORED, 15293)

	-- Bramblewood Belt -- 28474
	AddRecipe(28474, 300, 22761, Q.COMMON, V.ORIG, 300, 320, 330, 340)
	self:AddRecipeFlags(28474, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER, F.CENARION_CIRCLE)
	self:AddRecipeRepVendor(28474, FAC.CENARION_CIRCLE, REP.FRIENDLY, 15293)

	-- Knothide Leather -- 32454
	AddRecipe(32454, 300, 21887, Q.COMMON, V.TBC, 300, 300, 305, 310)
	self:AddRecipeFlags(32454, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(32454, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Heavy Knothide Leather -- 32455
	AddRecipe(32455, 325, 23793, Q.COMMON, V.TBC, 325, 325, 330, 335)
	self:AddRecipeFlags(32455, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.LEATHER)
	self:AddRecipeVendor(32455, 16748, 16689, 19196)

	-- Knothide Armor Kit -- 32456
	AddRecipe(32456, 300, 25650, Q.COMMON, V.TBC, 300, 310, 325, 340)
	self:AddRecipeFlags(32456, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(32456, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Vindicator's Armor Kit -- 32457
	AddRecipe(32457, 325, 25651, Q.COMMON, V.TBC, 325, 335, 340, 345)
	self:AddRecipeFlags(32457, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.ALDOR)
	self:AddRecipeRepVendor(32457, FAC.ALDOR, REP.REVERED, 19321)

	-- Magister's Armor Kit -- 32458
	AddRecipe(32458, 325, 25652, Q.COMMON, V.TBC, 325, 335, 340, 345)
	self:AddRecipeFlags(32458, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.SCRYER)
	self:AddRecipeRepVendor(32458, FAC.SCRYER, REP.REVERED, 19331)

	-- Riding Crop -- 32461
	AddRecipe(32461, 350, 25653, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(32461, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE, F.TRINKET)
	self:AddRecipeVendor(32461, 18672)

	-- Felscale Gloves -- 32462
	AddRecipe(32462, 300, 25654, Q.COMMON, V.TBC, 300, 310, 320, 330)
	self:AddRecipeFlags(32462, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(32462, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Felscale Boots -- 32463
	AddRecipe(32463, 310, 25655, Q.COMMON, V.TBC, 310, 320, 330, 340)
	self:AddRecipeFlags(32463, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(32463, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Felscale Pants -- 32464
	AddRecipe(32464, 320, 25656, Q.COMMON, V.TBC, 320, 330, 340, 350)
	self:AddRecipeFlags(32464, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(32464, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Felscale Breastplate -- 32465
	AddRecipe(32465, 335, 25657, Q.COMMON, V.TBC, 335, 345, 355, 365)
	self:AddRecipeFlags(32465, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(32465, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Scaled Draenic Pants -- 32466
	AddRecipe(32466, 300, 25662, Q.COMMON, V.TBC, 300, 310, 320, 330)
	self:AddRecipeFlags(32466, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(32466, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Scaled Draenic Gloves -- 32467
	AddRecipe(32467, 310, 25661, Q.COMMON, V.TBC, 310, 320, 330, 340)
	self:AddRecipeFlags(32467, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(32467, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Scaled Draenic Vest -- 32468
	AddRecipe(32468, 325, 25660, Q.COMMON, V.TBC, 325, 335, 345, 355)
	self:AddRecipeFlags(32468, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(32468, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Scaled Draenic Boots -- 32469
	AddRecipe(32469, 335, 25659, Q.COMMON, V.TBC, 335, 345, 355, 365)
	self:AddRecipeFlags(32469, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(32469, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Thick Draenic Gloves -- 32470
	AddRecipe(32470, 300, 25669, Q.COMMON, V.TBC, 300, 310, 320, 330)
	self:AddRecipeFlags(32470, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(32470, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Thick Draenic Pants -- 32471
	AddRecipe(32471, 315, 25670, Q.COMMON, V.TBC, 315, 325, 335, 345)
	self:AddRecipeFlags(32471, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(32471, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Thick Draenic Boots -- 32472
	AddRecipe(32472, 320, 25668, Q.COMMON, V.TBC, 320, 330, 340, 350)
	self:AddRecipeFlags(32472, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(32472, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Thick Draenic Vest -- 32473
	AddRecipe(32473, 330, 25671, Q.COMMON, V.TBC, 330, 340, 350, 360)
	self:AddRecipeFlags(32473, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(32473, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Wild Draenish Boots -- 32478
	AddRecipe(32478, 300, 25673, Q.COMMON, V.TBC, 300, 310, 320, 330)
	self:AddRecipeFlags(32478, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(32478, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Wild Draenish Gloves -- 32479
	AddRecipe(32479, 310, 25674, Q.COMMON, V.TBC, 310, 320, 330, 340)
	self:AddRecipeFlags(32479, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(32479, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Wild Draenish Leggings -- 32480
	AddRecipe(32480, 320, 25675, Q.COMMON, V.TBC, 320, 330, 340, 350)
	self:AddRecipeFlags(32480, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(32480, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Wild Draenish Vest -- 32481
	AddRecipe(32481, 330, 25676, Q.COMMON, V.TBC, 330, 340, 350, 360)
	self:AddRecipeFlags(32481, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(32481, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Comfortable Insoles -- 32482
	AddRecipe(32482, 300, 25679, Q.COMMON, V.TBC, 300, 300, 305, 310)
	self:AddRecipeFlags(32482, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOE)
	self:AddRecipeVendor(32482, 16689, 16748)

	-- Stylin' Purple Hat -- 32485
	AddRecipe(32485, 350, 25680, Q.RARE, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(32485, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeMobDrop(32485, 18667)

	-- Stylin' Adventure Hat -- 32487
	AddRecipe(32487, 350, 25681, Q.RARE, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(32487, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeMobDrop(32487, 17820, 28132)

	-- Stylin' Crimson Hat -- 32488
	AddRecipe(32488, 350, 25683, Q.RARE, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(32488, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeMobDrop(32488, 18322)

	-- Stylin' Jungle Hat -- 32489
	AddRecipe(32489, 350, 25682, Q.RARE, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(32489, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeMobDrop(32489, 17839, 21104)

	-- Fel Leather Gloves -- 32490
	AddRecipe(32490, 340, 25685, Q.RARE, V.TBC, 340, 350, 360, 370)
	self:AddRecipeFlags(32490, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.CONSORTIUM)
	self:AddRecipeRepVendor(32490, FAC.CONSORTIUM, REP.FRIENDLY, 20242, 23007)

	-- Fel Leather Boots -- 32493
	AddRecipe(32493, 350, 25686, Q.RARE, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(32493, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.CONSORTIUM)
	self:AddRecipeRepVendor(32493, FAC.CONSORTIUM, REP.HONORED, 20242, 23007)

	-- Fel Leather Leggings -- 32494
	AddRecipe(32494, 350, 25687, Q.RARE, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(32494, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.CONSORTIUM)
	self:AddRecipeRepVendor(32494, FAC.CONSORTIUM, REP.REVERED, 20242, 23007)

	-- Heavy Clefthoof Vest -- 32495
	AddRecipe(32495, 360, 25689, Q.RARE, V.TBC, 360, 370, 380, 390)
	self:AddRecipeFlags(32495, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.LEATHER, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(32495, FAC.CENARION_EXPEDITION, REP.HONORED, 17904)

	-- Heavy Clefthoof Leggings -- 32496
	AddRecipe(32496, 355, 25690, Q.RARE, V.TBC, 355, 365, 375, 385)
	self:AddRecipeFlags(32496, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.LEATHER, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(32496, FAC.CENARION_EXPEDITION, REP.HONORED, 17904)

	-- Heavy Clefthoof Boots -- 32497
	AddRecipe(32497, 355, 25691, Q.RARE, V.TBC, 355, 365, 375, 385)
	self:AddRecipeFlags(32497, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.TANK, F.LEATHER, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(32497, FAC.CENARION_EXPEDITION, REP.FRIENDLY, 17904)

	-- Felstalker Belt -- 32498
	AddRecipe(32498, 350, 25695, Q.RARE, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(32498, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL, F.HELLFIRE)
	self:AddRecipeRepVendor(32498, FAC.HONOR_HOLD, REP.FRIENDLY, 17657)
	self:AddRecipeRepVendor(32498, FAC.THRALLMAR, REP.FRIENDLY, 17585)

	-- Felstalker Bracer -- 32499
	AddRecipe(32499, 360, 25697, Q.RARE, V.TBC, 360, 370, 380, 390)
	self:AddRecipeFlags(32499, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL, F.HELLFIRE)
	self:AddRecipeRepVendor(32499, FAC.HONOR_HOLD, REP.HONORED, 17657)
	self:AddRecipeRepVendor(32499, FAC.THRALLMAR, REP.HONORED, 17585)

	-- Felstalker Breastplate -- 32500
	AddRecipe(32500, 360, 25696, Q.RARE, V.TBC, 360, 370, 380, 390)
	self:AddRecipeFlags(32500, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL, F.HELLFIRE)
	self:AddRecipeRepVendor(32500, FAC.HONOR_HOLD, REP.HONORED, 17657)
	self:AddRecipeRepVendor(32500, FAC.THRALLMAR, REP.HONORED, 17585)

	-- Netherfury Belt -- 32501
	AddRecipe(32501, 340, 25694, Q.RARE, V.TBC, 340, 350, 360, 370)
	self:AddRecipeFlags(32501, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL, F.NAGRAND)
	self:AddRecipeRepVendor(32501, FAC.KURENAI, REP.FRIENDLY, 20240)

	-- Netherfury Leggings -- 32502
	AddRecipe(32502, 340, 25692, Q.RARE, V.TBC, 340, 350, 360, 370)
	self:AddRecipeFlags(32502, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL, F.NAGRAND)
	self:AddRecipeRepVendor(32502, FAC.KURENAI, REP.HONORED, 20240)

	-- Netherfury Boots -- 32503
	AddRecipe(32503, 350, 25693, Q.RARE, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(32503, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL, F.NAGRAND)
	self:AddRecipeRepVendor(32503, FAC.KURENAI, REP.REVERED, 20240)

	-- Shadow Armor Kit -- 35520
	AddRecipe(35520, 340, 29483, Q.UNCOMMON, V.TBC, 340, 350, 355, 360)
	self:AddRecipeFlags(35520, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(35520, 18320)

	-- Flame Armor Kit -- 35521
	AddRecipe(35521, 340, 29485, Q.UNCOMMON, V.TBC, 340, 350, 355, 360)
	self:AddRecipeFlags(35521, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(35521, 20898)

	-- Frost Armor Kit -- 35522
	AddRecipe(35522, 340, 29486, Q.UNCOMMON, V.TBC, 340, 350, 355, 360)
	self:AddRecipeFlags(35522, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(35522, 17797)

	-- Nature Armor Kit -- 35523
	AddRecipe(35523, 340, 29487, Q.UNCOMMON, V.TBC, 340, 350, 355, 360)
	self:AddRecipeFlags(35523, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(35523, 17941)

	-- Arcane Armor Kit -- 35524
	AddRecipe(35524, 340, 29488, Q.UNCOMMON, V.TBC, 340, 350, 355, 360)
	self:AddRecipeFlags(35524, F.ALLIANCE, F.HORDE, F.INSTANCE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(35524, 17879)

	-- Enchanted Felscale Leggings -- 35525
	AddRecipe(35525, 350, 29489, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35525, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.SCRYER)
	self:AddRecipeRepVendor(35525, FAC.SCRYER, REP.EXALTED, 19331)

	-- Enchanted Felscale Gloves -- 35526
	AddRecipe(35526, 350, 29490, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35526, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.SCRYER)
	self:AddRecipeRepVendor(35526, FAC.SCRYER, REP.HONORED, 19331)

	-- Enchanted Felscale Boots -- 35527
	AddRecipe(35527, 350, 29491, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35527, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.SCRYER)
	self:AddRecipeRepVendor(35527, FAC.SCRYER, REP.REVERED, 19331)

	-- Flamescale Boots -- 35528
	AddRecipe(35528, 350, 29493, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35528, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.ALDOR)
	self:AddRecipeRepVendor(35528, FAC.ALDOR, REP.REVERED, 19321)

	-- Flamescale Leggings -- 35529
	AddRecipe(35529, 350, 29492, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35529, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.ALDOR)
	self:AddRecipeRepVendor(35529, FAC.ALDOR, REP.EXALTED, 19321)

	-- Reinforced Mining Bag -- 35530
	AddRecipe(35530, 325, 29540, Q.COMMON, V.TBC, 325, 335, 340, 345)
	self:AddRecipeFlags(35530, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.NAGRAND)
	self:AddRecipeRepVendor(35530, FAC.KURENAI, REP.HONORED, 20240)

	-- Flamescale Belt -- 35531
	AddRecipe(35531, 350, 29494, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35531, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.ALDOR)
	self:AddRecipeRepVendor(35531, FAC.ALDOR, REP.HONORED, 19321)

	-- Enchanted Clefthoof Leggings -- 35532
	AddRecipe(35532, 350, 29495, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35532, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.SCRYER)
	self:AddRecipeRepVendor(35532, FAC.SCRYER, REP.EXALTED, 19331)

	-- Enchanted Clefthoof Gloves -- 35533
	AddRecipe(35533, 350, 29496, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35533, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.SCRYER)
	self:AddRecipeRepVendor(35533, FAC.SCRYER, REP.REVERED, 19331)

	-- Enchanted Clefthoof Boots -- 35534
	AddRecipe(35534, 350, 29497, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35534, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.SCRYER)
	self:AddRecipeRepVendor(35534, FAC.SCRYER, REP.HONORED, 19331)

	-- Blastguard Pants -- 35535
	AddRecipe(35535, 350, 29498, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35535, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.ALDOR)
	self:AddRecipeRepVendor(35535, FAC.ALDOR, REP.EXALTED, 19321)

	-- Blastguard Boots -- 35536
	AddRecipe(35536, 350, 29499, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35536, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.ALDOR)
	self:AddRecipeRepVendor(35536, FAC.ALDOR, REP.REVERED, 19321)

	-- Blastguard Belt -- 35537
	AddRecipe(35537, 350, 29500, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(35537, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.ALDOR)
	self:AddRecipeRepVendor(35537, FAC.ALDOR, REP.HONORED, 19321)

	-- Drums of Panic -- 35538
	AddRecipe(35538, 370, 29532, Q.COMMON, V.TBC, 370, 370, 377, 385)
	self:AddRecipeFlags(35538, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.KOT)
	self:AddRecipeRepVendor(35538, FAC.KEEPERS_OF_TIME, REP.HONORED, 21643)

	-- Drums of Restoration -- 35539
	AddRecipe(35539, 350, 29531, Q.COMMON, V.TBC, 350, 350, 357, 365)
	self:AddRecipeFlags(35539, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.NAGRAND)
	self:AddRecipeRepVendor(35539, FAC.KURENAI, REP.HONORED, 20240)

	-- Drums of War -- 35540
	AddRecipe(35540, 340, 29528, Q.COMMON, V.TBC, 340, 340, 347, 355)
	self:AddRecipeFlags(35540, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(35540, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Drums of Battle -- 35543
	AddRecipe(35543, 365, 29529, Q.COMMON, V.TBC, 365, 365, 372, 380)
	self:AddRecipeFlags(35543, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.SHATAR)
	self:AddRecipeRepVendor(35543, FAC.SHATAR, REP.HONORED, 21432)

	-- Drums of Speed -- 35544
	AddRecipe(35544, 345, 29530, Q.COMMON, V.TBC, 345, 345, 352, 360)
	self:AddRecipeFlags(35544, F.ALLIANCE, F.HORDE, F.VENDOR, F.INSTANCE, F.IBOE, F.RBOP, F.NAGRAND)
	self:AddRecipeRepVendor(35544, FAC.MAGHAR, REP.HONORED, 20241)
	self:AddRecipeRepVendor(35544, FAC.KURENAI, REP.HONORED, 20240)

	-- Cobrahide Leg Armor -- 35549
	AddRecipe(35549, 335, 29533, Q.COMMON, V.TBC, 335, 335, 345, 355)
	self:AddRecipeFlags(35549, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HELLFIRE)
	self:AddRecipeRepVendor(35549, FAC.HONOR_HOLD, REP.HONORED, 17657)
	self:AddRecipeRepVendor(35549, FAC.THRALLMAR, REP.HONORED, 17585)

	-- Nethercobra Leg Armor -- 35554
	AddRecipe(35554, 365, 29535, Q.COMMON, V.TBC, 365, 365, 375, 385)
	self:AddRecipeFlags(35554, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HELLFIRE)
	self:AddRecipeRepVendor(35554, FAC.HONOR_HOLD, REP.EXALTED, 17657)
	self:AddRecipeRepVendor(35554, FAC.THRALLMAR, REP.EXALTED, 17585)

	-- Clefthide Leg Armor -- 35555
	AddRecipe(35555, 335, 29534, Q.COMMON, V.TBC, 335, 335, 345, 355)
	self:AddRecipeFlags(35555, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TANK, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(35555, FAC.CENARION_EXPEDITION, REP.HONORED, 17904)

	-- Nethercleft Leg Armor -- 35557
	AddRecipe(35557, 365, 29536, Q.COMMON, V.TBC, 365, 365, 375, 385)
	self:AddRecipeFlags(35557, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TANK, F.CENARION_EXPEDITION)
	self:AddRecipeRepVendor(35557, FAC.CENARION_EXPEDITION, REP.EXALTED, 17904)

	-- Cobrascale Hood -- 35558
	AddRecipe(35558, 365, 29502, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35558, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(35558, "Outland")

	-- Cobrascale Gloves -- 35559
	AddRecipe(35559, 365, 29503, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35559, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeMobDrop(35559, 24664)
	self:AddRecipeWorldDrop(35559, "Outland")

	-- Windscale Hood -- 35560
	AddRecipe(35560, 365, 29504, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35560, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(35560, "Outland")

	-- Hood of Primal Life -- 35561
	AddRecipe(35561, 365, 29505, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35561, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeWorldDrop(35561, "Outland")

	-- Gloves of the Living Touch -- 35562
	AddRecipe(35562, 365, 29506, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35562, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeMobDrop(35562, 24664)

	-- Windslayer Wraps -- 35563
	AddRecipe(35563, 365, 29507, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35563, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeWorldDrop(35563, "Outland")

	-- Living Dragonscale Helm -- 35564
	AddRecipe(35564, 365, 29508, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35564, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeWorldDrop(35564, "Outland")

	-- Earthen Netherscale Boots -- 35567
	AddRecipe(35567, 365, 29512, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35567, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeWorldDrop(35567, "Outland")

	-- Windstrike Gloves -- 35568
	AddRecipe(35568, 365, 29509, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35568, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeMobDrop(35568, 24664)

	-- Netherdrake Helm -- 35572
	AddRecipe(35572, 365, 29510, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35572, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeWorldDrop(35572, "Outland")

	-- Netherdrake Gloves -- 35573
	AddRecipe(35573, 365, 29511, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35573, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeMobDrop(35573, 24664)

	-- Thick Netherscale Breastplate -- 35574
	AddRecipe(35574, 365, 29514, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(35574, F.ALLIANCE, F.HORDE, F.WORLD_DROP, F.IBOE, F.RBOE, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeWorldDrop(35574, "Outland")

	-- Ebon Netherscale Breastplate -- 35575
	AddRecipe(35575, 375, 29515, Q.COMMON, V.TBC, 375, 385, 395, 405, 10657)
	self:AddRecipeFlags(35575, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(35575, 7866, 7867, 29508)

	-- Ebon Netherscale Belt -- 35576
	AddRecipe(35576, 375, 29516, Q.COMMON, V.TBC, 375, 385, 395, 405, 10657)
	self:AddRecipeFlags(35576, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(35576, 7866, 7867, 29508)

	-- Ebon Netherscale Bracers -- 35577
	AddRecipe(35577, 375, 29517, Q.COMMON, V.TBC, 375, 385, 395, 405, 10657)
	self:AddRecipeFlags(35577, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(35577, 7866, 7867, 29508)

	-- Netherstrike Breastplate -- 35580
	AddRecipe(35580, 375, 29519, Q.COMMON, V.TBC, 375, 385, 395, 405, 10657)
	self:AddRecipeFlags(35580, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(35580, 7866, 7867, 29508)

	-- Netherstrike Belt -- 35582
	AddRecipe(35582, 375, 29520, Q.COMMON, V.TBC, 375, 385, 395, 405, 10657)
	self:AddRecipeFlags(35582, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(35582, 7866, 7867, 29508)

	-- Netherstrike Bracers -- 35584
	AddRecipe(35584, 375, 29521, Q.COMMON, V.TBC, 375, 385, 395, 405, 10657)
	self:AddRecipeFlags(35584, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(35584, 7866, 7867, 29508)

	-- Windhawk Hauberk -- 35585
	AddRecipe(35585, 375, 29522, Q.COMMON, V.TBC, 375, 385, 395, 405, 10661)
	self:AddRecipeFlags(35585, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(35585, 29509, 7870, 7871)

	-- Windhawk Belt -- 35587
	AddRecipe(35587, 375, 29524, Q.COMMON, V.TBC, 375, 385, 395, 405, 10661)
	self:AddRecipeFlags(35587, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(35587, 29509, 7870, 7871)

	-- Windhawk Bracers -- 35588
	AddRecipe(35588, 375, 29523, Q.COMMON, V.TBC, 375, 385, 395, 405, 10661)
	self:AddRecipeFlags(35588, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(35588, 29509, 7870, 7871)

	-- Primalstrike Vest -- 35589
	AddRecipe(35589, 375, 29525, Q.COMMON, V.TBC, 375, 385, 395, 405, 10659)
	self:AddRecipeFlags(35589, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(35589, 7869, 29507, 7868)

	-- Primalstrike Belt -- 35590
	AddRecipe(35590, 375, 29526, Q.COMMON, V.TBC, 375, 385, 395, 405, 10659)
	self:AddRecipeFlags(35590, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(35590, 7869, 29507, 7868)

	-- Primalstrike Bracers -- 35591
	AddRecipe(35591, 375, 29527, Q.COMMON, V.TBC, 375, 385, 395, 405, 10659)
	self:AddRecipeFlags(35591, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(35591, 7869, 29507, 7868)

	-- Blackstorm Leggings -- 36074
	AddRecipe(36074, 260, 29964, Q.COMMON, V.TBC, 260, 280, 290, 300, 10659)
	self:AddRecipeFlags(36074, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(36074, 7869, 29507, 7868)

	-- Wildfeather Leggings -- 36075
	AddRecipe(36075, 260, 29970, Q.COMMON, V.TBC, 260, 280, 290, 300, 10661)
	self:AddRecipeFlags(36075, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(36075, 29509, 7870, 7871)

	-- Dragonstrike Leggings -- 36076
	AddRecipe(36076, 260, 29971, Q.COMMON, V.TBC, 260, 280, 290, 300, 10657)
	self:AddRecipeFlags(36076, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(36076, 7866, 7867, 29508)

	-- Primalstorm Breastplate -- 36077
	AddRecipe(36077, 330, 29973, Q.COMMON, V.TBC, 330, 350, 360, 370, 10659)
	self:AddRecipeFlags(36077, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(36077, 7869, 29507, 7868)

	-- Living Crystal Breastplate -- 36078
	AddRecipe(36078, 330, 29974, Q.COMMON, V.TBC, 330, 350, 360, 370, 10661)
	self:AddRecipeFlags(36078, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(36078, 29509, 7870, 7871)

	-- Golden Dragonstrike Breastplate -- 36079
	AddRecipe(36079, 330, 29975, Q.COMMON, V.TBC, 330, 350, 360, 370, 10657)
	self:AddRecipeFlags(36079, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOP, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(36079, 7866, 7867, 29508)

	-- Belt of Natural Power -- 36349
	AddRecipe(36349, 375, 30042, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(36349, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeAcquire(36349, A.CUSTOM, 37, A.CUSTOM, 43)

	-- Belt of Deep Shadow -- 36351
	AddRecipe(36351, 375, 30040, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(36351, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeAcquire(36351, A.CUSTOM, 37, A.CUSTOM, 43)

	-- Belt of the Black Eagle -- 36352
	AddRecipe(36352, 375, 30046, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(36352, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(36352, A.CUSTOM, 37, A.CUSTOM, 43)

	-- Monsoon Belt -- 36353
	AddRecipe(36353, 375, 30044, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(36353, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(36353, A.CUSTOM, 37, A.CUSTOM, 43)

	-- Boots of Natural Grace -- 36355
	AddRecipe(36355, 375, 30041, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(36355, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.DPS, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeAcquire(36355, A.CUSTOM, 37, A.CUSTOM, 43)

	-- Boots of Utter Darkness -- 36357
	AddRecipe(36357, 375, 30039, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(36357, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeAcquire(36357, A.CUSTOM, 37, A.CUSTOM, 43)

	-- Boots of the Crimson Hawk -- 36358
	AddRecipe(36358, 375, 30045, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(36358, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(36358, A.CUSTOM, 37, A.CUSTOM, 43)

	-- Hurricane Boots -- 36359
	AddRecipe(36359, 375, 30043, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(36359, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(36359, A.CUSTOM, 37, A.CUSTOM, 43)

	-- Boots of Shackled Souls -- 39997
	AddRecipe(39997, 375, 32398, Q.COMMON, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(39997, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.MAIL, F.ASHTONGUE)
	self:AddRecipeRepVendor(39997, FAC.ASHTONGUE, REP.FRIENDLY, 23159)

	-- Greaves of Shackled Souls -- 40001
	AddRecipe(40001, 375, 32400, Q.COMMON, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(40001, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.MAIL, F.ASHTONGUE)
	self:AddRecipeRepVendor(40001, FAC.ASHTONGUE, REP.HONORED, 23159)

	-- Waistguard of Shackled Souls -- 40002
	AddRecipe(40002, 375, 32397, Q.COMMON, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(40002, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.MAIL, F.ASHTONGUE)
	self:AddRecipeRepVendor(40002, FAC.ASHTONGUE, REP.HONORED, 23159)

	-- Redeemed Soul Moccasins -- 40003
	AddRecipe(40003, 375, 32394, Q.COMMON, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(40003, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER, F.ASHTONGUE)
	self:AddRecipeRepVendor(40003, FAC.ASHTONGUE, REP.HONORED, 23159)

	-- Redeemed Soul Wristguards -- 40004
	AddRecipe(40004, 375, 32395, Q.COMMON, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(40004, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER, F.ASHTONGUE)
	self:AddRecipeRepVendor(40004, FAC.ASHTONGUE, REP.HONORED, 23159)

	-- Redeemed Soul Legguards -- 40005
	AddRecipe(40005, 375, 32396, Q.COMMON, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(40005, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER, F.ASHTONGUE)
	self:AddRecipeRepVendor(40005, FAC.ASHTONGUE, REP.FRIENDLY, 23159)

	-- Redeemed Soul Cinch -- 40006
	AddRecipe(40006, 375, 32393, Q.COMMON, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(40006, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER, F.ASHTONGUE)
	self:AddRecipeRepVendor(40006, FAC.ASHTONGUE, REP.FRIENDLY, 23159)

	-- Bracers of Renewed Life -- 41156
	AddRecipe(41156, 375, 32582, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(41156, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeAcquire(41156, A.CUSTOM, 34)

	-- Shoulderpads of Renewed Life -- 41157
	AddRecipe(41157, 375, 32583, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(41157, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeAcquire(41157, A.CUSTOM, 27, A.CUSTOM, 34)

	-- Swiftstrike Bracers -- 41158
	AddRecipe(41158, 375, 32580, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(41158, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeAcquire(41158, A.CUSTOM, 27, A.CUSTOM, 34)

	-- Swiftstrike Shoulders -- 41160
	AddRecipe(41160, 375, 32581, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(41160, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeAcquire(41160, A.CUSTOM, 34)

	-- Bindings of Lightning Reflexes -- 41161
	AddRecipe(41161, 375, 32574, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(41161, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeAcquire(41161, A.CUSTOM, 27, A.CUSTOM, 34)

	-- Shoulders of Lightning Reflexes -- 41162
	AddRecipe(41162, 375, 32575, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(41162, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeAcquire(41162, A.CUSTOM, 34)

	-- Living Earth Bindings -- 41163
	AddRecipe(41163, 375, 32577, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(41163, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(41163, A.CUSTOM, 34)

	-- Living Earth Shoulders -- 41164
	AddRecipe(41164, 375, 32579, Q.EPIC, V.TBC, 375, 385, 395, 405)
	self:AddRecipeFlags(41164, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(41164, A.CUSTOM, 27, A.CUSTOM, 34)

	-- Cloak of Darkness -- 42546
	AddRecipe(42546, 360, 33122, Q.RARE, V.TBC, 360, 370, 380, 390)
	self:AddRecipeFlags(42546, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.CLOAK, F.VIOLETEYE)
	self:AddRecipeRepVendor(42546, FAC.VIOLETEYE, REP.EXALTED, 18255)

	-- Shadowprowler's Chestguard -- 42731
	AddRecipe(42731, 365, 33204, Q.EPIC, V.TBC, 365, 375, 385, 395)
	self:AddRecipeFlags(42731, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.VIOLETEYE)
	self:AddRecipeRepVendor(42731, FAC.VIOLETEYE, REP.REVERED, 18255)

	-- Knothide Ammo Pouch -- 44343
	AddRecipe(44343, 315, 34099, Q.COMMON, V.TBC, 315, 325, 335, 345)
	self:AddRecipeFlags(44343, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.AMMO)
	self:AddRecipeTrainer(44343, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Knothide Quiver -- 44344
	AddRecipe(44344, 315, 34100, Q.COMMON, V.TBC, 315, 325, 335, 345)
	self:AddRecipeFlags(44344, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44344, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Quiver of a Thousand Feathers -- 44359
	AddRecipe(44359, 350, 34105, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(44359, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LOWERCITY)
	self:AddRecipeRepVendor(44359, FAC.LOWERCITY, REP.REVERED, 21655)

	-- Netherscale Ammo Pouch -- 44768
	AddRecipe(44768, 350, 34106, Q.COMMON, V.TBC, 350, 360, 370, 380)
	self:AddRecipeFlags(44768, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.AMMO, F.HELLFIRE)
	self:AddRecipeRepVendor(44768, FAC.THRALLMAR, REP.REVERED, 17585)
	self:AddRecipeRepVendor(44768, FAC.HONOR_HOLD, REP.REVERED, 17657)

	-- Glove Reinforcements -- 44770
	AddRecipe(44770, 350, 34207, Q.COMMON, V.TBC, 350, 355, 360, 365)
	self:AddRecipeFlags(44770, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44770, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Winter Boots -- 44953
	AddRecipe(44953, 285, 34086, Q.UNCOMMON, V.TBC, 285, 285, 285, 285)
	self:AddRecipeFlags(44953, F.ALLIANCE, F.HORDE, F.VENDOR, F.SEASONAL, F.IBOE, F.RBOP, F.CLOTH)
	self:AddRecipeVendor(44953, 13420, 13433)
	self:AddRecipeAcquire(44953, A.SEASONAL, 1)

	-- Heavy Knothide Armor Kit -- 44970
	AddRecipe(44970, 350, 34330, Q.COMMON, V.TBC, 350, 355, 360, 365)
	self:AddRecipeFlags(44970, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(44970, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Leatherworker's Satchel -- 45100
	AddRecipe(45100, 300, 34482, Q.COMMON, V.TBC, 300, 310, 320, 330)
	self:AddRecipeFlags(45100, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(45100, 33612, 19187, 18754, 33681, 21087, 18771, 33635)

	-- Bag of Many Hides -- 45117
	AddRecipe(45117, 360, 34490, Q.UNCOMMON, V.TBC, 360, 370, 380, 390)
	self:AddRecipeFlags(45117, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(45117, 22144, 22148, 22143, 23022)

	-- Leather Gauntlets of the Sun -- 46132
	AddRecipe(46132, 365, 34372, Q.EPIC, V.TBC, 365, 375, 392, 410)
	self:AddRecipeFlags(46132, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeAcquire(46132, A.CUSTOM, 24)

	-- Fletcher's Gloves of the Phoenix -- 46133
	AddRecipe(46133, 365, 34374, Q.EPIC, V.TBC, 365, 375, 392, 410)
	self:AddRecipeFlags(46133, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeAcquire(46133, A.CUSTOM, 24)

	-- Gloves of Immortal Dusk -- 46134
	AddRecipe(46134, 365, 34370, Q.EPIC, V.TBC, 365, 375, 392, 410)
	self:AddRecipeFlags(46134, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeAcquire(46134, A.CUSTOM, 24)

	-- Sun-Drenched Scale Gloves -- 46135
	AddRecipe(46135, 365, 34376, Q.EPIC, V.TBC, 365, 375, 392, 410)
	self:AddRecipeFlags(46135, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(46135, A.CUSTOM, 24)

	-- Leather Chestguard of the Sun -- 46136
	AddRecipe(46136, 365, 34371, Q.EPIC, V.TBC, 365, 375, 392, 410)
	self:AddRecipeFlags(46136, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeAcquire(46136, A.CUSTOM, 24)

	-- Embrace of the Phoenix -- 46137
	AddRecipe(46137, 365, 34373, Q.EPIC, V.TBC, 365, 375, 392, 410)
	self:AddRecipeFlags(46137, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeAcquire(46137, A.CUSTOM, 24)

	-- Carapace of Sun and Shadow -- 46138
	AddRecipe(46138, 365, 34369, Q.EPIC, V.TBC, 365, 375, 392, 410)
	self:AddRecipeFlags(46138, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeAcquire(46138, A.CUSTOM, 24)

	-- Sun-Drenched Scale Chestguard -- 46139
	AddRecipe(46139, 365, 34375, Q.EPIC, V.TBC, 365, 375, 392, 410)
	self:AddRecipeFlags(46139, F.ALLIANCE, F.HORDE, F.RAID, F.IBOP, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(46139, A.CUSTOM, 24)

	-- Heavy Borean Leather -- 50936
	AddRecipe(50936, 390, 38425, Q.COMMON, V.WOTLK, 390, 390, 395, 405)
	self:AddRecipeFlags(50936, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(50936, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Iceborne Chestguard -- 50938
	AddRecipe(50938, 375, 38408, Q.COMMON, V.WOTLK, 375, 390, 400, 410)
	self:AddRecipeFlags(50938, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(50938, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Iceborne Leggings -- 50939
	AddRecipe(50939, 370, 38410, Q.COMMON, V.WOTLK, 370, 385, 395, 405)
	self:AddRecipeFlags(50939, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(50939, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Iceborne Shoulderpads -- 50940
	AddRecipe(50940, 380, 38411, Q.COMMON, V.WOTLK, 380, 395, 405, 415)
	self:AddRecipeFlags(50940, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(50940, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Iceborne Gloves -- 50941
	AddRecipe(50941, 370, 38409, Q.COMMON, V.WOTLK, 370, 385, 395, 405)
	self:AddRecipeFlags(50941, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(50941, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Iceborne Boots -- 50942
	AddRecipe(50942, 375, 38407, Q.COMMON, V.WOTLK, 375, 390, 400, 410)
	self:AddRecipeFlags(50942, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(50942, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Iceborne Belt -- 50943
	AddRecipe(50943, 380, 38406, Q.COMMON, V.WOTLK, 380, 380, 387, 395)
	self:AddRecipeFlags(50943, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(50943, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Arctic Chestpiece -- 50944
	AddRecipe(50944, 370, 38400, Q.COMMON, V.WOTLK, 370, 385, 395, 405)
	self:AddRecipeFlags(50944, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(50944, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Arctic Leggings -- 50945
	AddRecipe(50945, 375, 38401, Q.COMMON, V.WOTLK, 375, 390, 400, 410)
	self:AddRecipeFlags(50945, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(50945, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Arctic Shoulderpads -- 50946
	AddRecipe(50946, 380, 38402, Q.COMMON, V.WOTLK, 380, 395, 405, 415)
	self:AddRecipeFlags(50946, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(50946, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Arctic Gloves -- 50947
	AddRecipe(50947, 375, 38403, Q.COMMON, V.WOTLK, 375, 390, 400, 410)
	self:AddRecipeFlags(50947, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(50947, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Arctic Boots -- 50948
	AddRecipe(50948, 370, 38404, Q.COMMON, V.WOTLK, 370, 385, 395, 405)
	self:AddRecipeFlags(50948, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(50948, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Arctic Belt -- 50949
	AddRecipe(50949, 380, 38405, Q.COMMON, V.WOTLK, 380, 395, 405, 415)
	self:AddRecipeFlags(50949, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(50949, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Frostscale Chestguard -- 50950
	AddRecipe(50950, 375, 38414, Q.COMMON, V.WOTLK, 375, 390, 400, 410)
	self:AddRecipeFlags(50950, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(50950, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Frostscale Leggings -- 50951
	AddRecipe(50951, 370, 38416, Q.COMMON, V.WOTLK, 370, 385, 395, 405)
	self:AddRecipeFlags(50951, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(50951, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Frostscale Shoulders -- 50952
	AddRecipe(50952, 375, 38424, Q.COMMON, V.WOTLK, 375, 390, 400, 410)
	self:AddRecipeFlags(50952, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(50952, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Frostscale Gloves -- 50953
	AddRecipe(50953, 380, 38415, Q.COMMON, V.WOTLK, 380, 395, 405, 415)
	self:AddRecipeFlags(50953, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(50953, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Frostscale Boots -- 50954
	AddRecipe(50954, 380, 38413, Q.COMMON, V.WOTLK, 380, 395, 405, 415)
	self:AddRecipeFlags(50954, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(50954, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Frostscale Belt -- 50955
	AddRecipe(50955, 370, 38412, Q.COMMON, V.WOTLK, 370, 385, 395, 405)
	self:AddRecipeFlags(50955, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(50955, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nerubian Chestguard -- 50956
	AddRecipe(50956, 375, 38420, Q.COMMON, V.WOTLK, 375, 390, 400, 410)
	self:AddRecipeFlags(50956, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(50956, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nerubian Legguards -- 50957
	AddRecipe(50957, 370, 38422, Q.COMMON, V.WOTLK, 370, 385, 395, 405)
	self:AddRecipeFlags(50957, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(50957, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nerubian Shoulders -- 50958
	AddRecipe(50958, 380, 38417, Q.COMMON, V.WOTLK, 380, 395, 405, 415)
	self:AddRecipeFlags(50958, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(50958, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nerubian Gloves -- 50959
	AddRecipe(50959, 370, 38421, Q.COMMON, V.WOTLK, 370, 385, 395, 405)
	self:AddRecipeFlags(50959, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(50959, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nerubian Boots -- 50960
	AddRecipe(50960, 380, 38419, Q.COMMON, V.WOTLK, 380, 395, 405, 415)
	self:AddRecipeFlags(50960, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(50960, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nerubian Belt -- 50961
	AddRecipe(50961, 375, 38418, Q.COMMON, V.WOTLK, 375, 390, 400, 410)
	self:AddRecipeFlags(50961, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(50961, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Borean Armor Kit -- 50962
	AddRecipe(50962, 350, 38375, Q.COMMON, V.WOTLK, 350, 375, 380, 385)
	self:AddRecipeFlags(50962, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(50962, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Heavy Borean Armor Kit -- 50963
	AddRecipe(50963, 395, 38376, Q.COMMON, V.WOTLK, 395, 400, 402, 405)
	self:AddRecipeFlags(50963, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(50963, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Jormungar Leg Armor -- 50964
	AddRecipe(50964, 405, 38371, Q.COMMON, V.WOTLK, 405, 410, 415, 420)
	self:AddRecipeFlags(50964, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(50964, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Frosthide Leg Armor -- 50965
	AddRecipe(50965, 425, 38373, Q.COMMON, V.WOTLK, 425, 435, 440, 445)
	self:AddRecipeFlags(50965, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(50965, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nerubian Leg Armor -- 50966
	AddRecipe(50966, 400, 38372, Q.COMMON, V.WOTLK, 400, 405, 410, 415)
	self:AddRecipeFlags(50966, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(50966, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Icescale Leg Armor -- 50967
	AddRecipe(50967, 425, 38374, Q.COMMON, V.WOTLK, 425, 435, 440, 445)
	self:AddRecipeFlags(50967, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(50967, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Trapper's Traveling Pack -- 50970
	AddRecipe(50970, 415, 38399, Q.RARE, V.WOTLK, 415, 420, 422, 425)
	self:AddRecipeFlags(50970, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.KALUAK)
	self:AddRecipeRepVendor(50970, FAC.KALUAK, REP.REVERED, 31916, 32763)

	-- Mammoth Mining Bag -- 50971
	AddRecipe(50971, 415, 38347, Q.RARE, V.WOTLK, 415, 420, 422, 425)
	self:AddRecipeFlags(50971, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HODIR)
	self:AddRecipeRepVendor(50971, FAC.HODIR, REP.HONORED, 32540)

	-- Black Chitinguard Boots -- 51568
	AddRecipe(51568, 400, 38590, Q.COMMON, V.WOTLK, 400, 415, 425, 435)
	self:AddRecipeFlags(51568, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(51568, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Dark Arctic Leggings -- 51569
	AddRecipe(51569, 395, 38591, Q.COMMON, V.WOTLK, 395, 410, 420, 430)
	self:AddRecipeFlags(51569, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(51569, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Dark Arctic Chestpiece -- 51570
	AddRecipe(51570, 395, 38592, Q.COMMON, V.WOTLK, 395, 410, 420, 430)
	self:AddRecipeFlags(51570, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(51570, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Arctic Wristguards -- 51571
	AddRecipe(51571, 385, 38433, Q.COMMON, V.WOTLK, 385, 400, 410, 420)
	self:AddRecipeFlags(51571, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(51571, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Arctic Helm -- 51572
	AddRecipe(51572, 385, 38437, Q.COMMON, V.WOTLK, 385, 400, 410, 420)
	self:AddRecipeFlags(51572, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(51572, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Bracers of Shackled Souls -- 52733
	AddRecipe(52733, 375, 32399, Q.COMMON, V.WOTLK, 375, 385, 395, 405)
	self:AddRecipeFlags(52733, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.MAIL, F.ASHTONGUE)
	self:AddRecipeRepVendor(52733, FAC.ASHTONGUE, REP.FRIENDLY, 23159)

	-- Cloak of Tormented Skies -- 55199
	AddRecipe(55199, 395, 41238, Q.COMMON, V.WOTLK, 395, 405, 415, 425)
	self:AddRecipeFlags(55199, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.TANK, F.CLOAK)
	self:AddRecipeTrainer(55199, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Fur Lining - Attack Power -- 57683
	AddRecipe(57683, 400, nil, Q.COMMON, V.WOTLK, 400, 425, 430, 435)
	self:AddRecipeFlags(57683, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(57683, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Fur Lining - Stamina -- 57690
	AddRecipe(57690, 400, nil, Q.COMMON, V.WOTLK, 400, 425, 430, 435)
	self:AddRecipeFlags(57690, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(57690, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Fur Lining - Spell Power -- 57691
	AddRecipe(57691, 400, nil, Q.COMMON, V.WOTLK, 400, 425, 430, 435)
	self:AddRecipeFlags(57691, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER)
	self:AddRecipeTrainer(57691, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Fur Lining - Fire Resist -- 57692
	AddRecipe(57692, 400, nil, Q.RARE, V.WOTLK, 400, 425, 430, 435)
	self:AddRecipeFlags(57692, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(57692, 30921)

	-- Fur Lining - Frost Resist -- 57694
	AddRecipe(57694, 400, nil, Q.RARE, V.WOTLK, 400, 425, 430, 435)
	self:AddRecipeFlags(57694, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(57694, 32289)

	-- Fur Lining - Shadow Resist -- 57696
	AddRecipe(57696, 400, nil, Q.RARE, V.WOTLK, 400, 425, 430, 435)
	self:AddRecipeFlags(57696, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(57696, 32349)

	-- Fur Lining - Nature Resist -- 57699
	AddRecipe(57699, 400, nil, Q.RARE, V.WOTLK, 400, 425, 430, 435)
	self:AddRecipeFlags(57699, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(57699, 32290)

	-- Fur Lining - Arcane Resist -- 57701
	AddRecipe(57701, 400, nil, Q.RARE, V.WOTLK, 400, 425, 430, 435)
	self:AddRecipeFlags(57701, F.ALLIANCE, F.HORDE, F.MOB_DROP, F.IBOE, F.RBOP)
	self:AddRecipeMobDrop(57701, 31702, 32297)

	-- Jormungar Leg Reinforcements -- 60583
	AddRecipe(60583, 405, nil, Q.COMMON, V.WOTLK, 405, 405, 405, 410)
	self:AddRecipeFlags(60583, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(60583, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nerubian Leg Reinforcements -- 60584
	AddRecipe(60584, 400, nil, Q.COMMON, V.WOTLK, 400, 400, 400, 405)
	self:AddRecipeFlags(60584, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS)
	self:AddRecipeTrainer(60584, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Frostscale Bracers -- 60599
	AddRecipe(60599, 385, 38436, Q.COMMON, V.WOTLK, 385, 400, 410, 420)
	self:AddRecipeFlags(60599, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(60599, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Frostscale Helm -- 60600
	AddRecipe(60600, 385, 38440, Q.COMMON, V.WOTLK, 385, 400, 410, 420)
	self:AddRecipeFlags(60600, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(60600, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Dark Frostscale Leggings -- 60601
	AddRecipe(60601, 395, 44436, Q.COMMON, V.WOTLK, 395, 410, 420, 430)
	self:AddRecipeFlags(60601, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(60601, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Dark Frostscale Breastplate -- 60604
	AddRecipe(60604, 395, 44437, Q.COMMON, V.WOTLK, 395, 410, 420, 430)
	self:AddRecipeFlags(60604, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(60604, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Dragonstompers -- 60605
	AddRecipe(60605, 400, 44438, Q.COMMON, V.WOTLK, 400, 415, 425, 435)
	self:AddRecipeFlags(60605, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(60605, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Iceborne Wristguards -- 60607
	AddRecipe(60607, 385, 38434, Q.COMMON, V.WOTLK, 385, 400, 410, 420)
	self:AddRecipeFlags(60607, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(60607, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Iceborne Helm -- 60608
	AddRecipe(60608, 385, 38438, Q.COMMON, V.WOTLK, 385, 400, 410, 420)
	self:AddRecipeFlags(60608, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(60608, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Dark Iceborne Leggings -- 60611
	AddRecipe(60611, 395, 44440, Q.COMMON, V.WOTLK, 395, 410, 420, 430)
	self:AddRecipeFlags(60611, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(60611, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Dark Iceborne Chestguard -- 60613
	AddRecipe(60613, 395, 44441, Q.COMMON, V.WOTLK, 395, 410, 420, 430)
	self:AddRecipeFlags(60613, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(60613, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Bugsquashers -- 60620
	AddRecipe(60620, 400, 44442, Q.COMMON, V.WOTLK, 400, 415, 425, 435)
	self:AddRecipeFlags(60620, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(60620, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nerubian Bracers -- 60622
	AddRecipe(60622, 385, 38435, Q.COMMON, V.WOTLK, 385, 400, 410, 420)
	self:AddRecipeFlags(60622, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(60622, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nerubian Helm -- 60624
	AddRecipe(60624, 385, 38439, Q.COMMON, V.WOTLK, 385, 400, 410, 420)
	self:AddRecipeFlags(60624, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(60624, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Dark Nerubian Leggings -- 60627
	AddRecipe(60627, 395, 44443, Q.COMMON, V.WOTLK, 395, 410, 420, 430)
	self:AddRecipeFlags(60627, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(60627, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Dark Nerubian Chestpiece -- 60629
	AddRecipe(60629, 395, 44444, Q.COMMON, V.WOTLK, 395, 410, 420, 430)
	self:AddRecipeFlags(60629, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(60629, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Scaled Icewalkers -- 60630
	AddRecipe(60630, 400, 44445, Q.COMMON, V.WOTLK, 400, 415, 425, 435)
	self:AddRecipeFlags(60630, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(60630, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Cloak of Harsh Winds -- 60631
	AddRecipe(60631, 380, 38441, Q.COMMON, V.WOTLK, 380, 390, 400, 410)
	self:AddRecipeFlags(60631, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.CLOAK)
	self:AddRecipeTrainer(60631, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Ice Striker's Cloak -- 60637
	AddRecipe(60637, 440, 43566, Q.COMMON, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(60637, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.CLOAK)
	self:AddRecipeTrainer(60637, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Durable Nerubhide Cape -- 60640
	AddRecipe(60640, 440, 43565, Q.COMMON, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(60640, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.TANK, F.CLOAK)
	self:AddRecipeTrainer(60640, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Pack of Endless Pockets -- 60643
	AddRecipe(60643, 415, 44446, Q.COMMON, V.WOTLK, 415, 420, 422, 425)
	self:AddRecipeFlags(60643, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(60643, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Dragonscale Ammo Pouch -- 60645
	AddRecipe(60645, 415, 44447, Q.RARE, V.WOTLK, 415, 420, 422, 425)
	self:AddRecipeFlags(60645, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.AMMO, F.KALUAK)
	self:AddRecipeRepVendor(60645, FAC.KALUAK, REP.HONORED, 31916, 32763)

	-- Nerubian Reinforced Quiver -- 60647
	AddRecipe(60647, 415, 44448, Q.RARE, V.WOTLK, 415, 420, 422, 425)
	self:AddRecipeFlags(60647, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.EBONBLADE)
	self:AddRecipeRepVendor(60647, FAC.EBONBLADE, REP.HONORED, 32538)

	-- Razorstrike Breastplate -- 60649
	AddRecipe(60649, 425, 43129, Q.COMMON, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60649, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(60649, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Virulent Spaulders -- 60651
	AddRecipe(60651, 420, 43130, Q.COMMON, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60651, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(60651, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Eaglebane Bracers -- 60652
	AddRecipe(60652, 420, 43131, Q.COMMON, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60652, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.MAIL)
	self:AddRecipeTrainer(60652, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nightshock Hood -- 60655
	AddRecipe(60655, 425, 43132, Q.COMMON, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60655, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(60655, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Nightshock Girdle -- 60658
	AddRecipe(60658, 420, 43133, Q.COMMON, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60658, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeTrainer(60658, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Leggings of Visceral Strikes -- 60660
	AddRecipe(60660, 425, 42731, Q.COMMON, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60660, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(60660, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Seafoam Gauntlets -- 60665
	AddRecipe(60665, 420, 43255, Q.COMMON, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60665, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(60665, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Jormscale Footpads -- 60666
	AddRecipe(60666, 420, 43256, Q.COMMON, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60666, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeTrainer(60666, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Wildscale Breastplate -- 60669
	AddRecipe(60669, 425, 43257, Q.COMMON, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60669, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(60669, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Purehorn Spaulders -- 60671
	AddRecipe(60671, 420, 43258, Q.COMMON, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60671, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeTrainer(60671, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Eviscerator's Facemask -- 60697
	AddRecipe(60697, 420, 43260, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60697, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(60697, 32515)

	-- Eviscerator's Shoulderpads -- 60702
	AddRecipe(60702, 420, 43433, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60702, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(60702, 32515)

	-- Eviscerator's Chestguard -- 60703
	AddRecipe(60703, 420, 43434, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60703, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(60703, 32515)

	-- Eviscerator's Bindings -- 60704
	AddRecipe(60704, 420, 43435, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60704, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(60704, 32515)

	-- Eviscerator's Gauntlets -- 60705
	AddRecipe(60705, 425, 43436, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60705, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(60705, 32515)

	-- Eviscerator's Waistguard -- 60706
	AddRecipe(60706, 425, 43437, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60706, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(60706, 32515)

	-- Eviscerator's Legguards -- 60711
	AddRecipe(60711, 425, 43438, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60711, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(60711, 32515)

	-- Eviscerator's Treads -- 60712
	AddRecipe(60712, 425, 43439, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60712, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(60712, 32515)

	-- Overcast Headguard -- 60715
	AddRecipe(60715, 420, 43261, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60715, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(60715, 32515)

	-- Overcast Spaulders -- 60716
	AddRecipe(60716, 420, 43262, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60716, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(60716, 32515)

	-- Overcast Chestguard -- 60718
	AddRecipe(60718, 420, 43263, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60718, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(60718, 32515)

	-- Overcast Bracers -- 60720
	AddRecipe(60720, 420, 43264, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60720, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(60720, 32515)

	-- Overcast Handwraps -- 60721
	AddRecipe(60721, 425, 43265, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60721, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(60721, 32515)

	-- Overcast Belt -- 60723
	AddRecipe(60723, 425, 43266, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60723, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(60723, 32515)

	-- Overcast Leggings -- 60725
	AddRecipe(60725, 425, 43271, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60725, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(60725, 32515)

	-- Overcast Boots -- 60727
	AddRecipe(60727, 425, 43273, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60727, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(60727, 32515)

	-- Swiftarrow Helm -- 60728
	AddRecipe(60728, 420, 43447, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60728, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60728, 32515)

	-- Swiftarrow Shoulderguards -- 60729
	AddRecipe(60729, 420, 43449, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60729, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60729, 32515)

	-- Swiftarrow Hauberk -- 60730
	AddRecipe(60730, 420, 43445, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60730, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60730, 32515)

	-- Swiftarrow Bracers -- 60731
	AddRecipe(60731, 420, 43444, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60731, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60731, 32515)

	-- Swiftarrow Gauntlets -- 60732
	AddRecipe(60732, 425, 43446, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60732, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60732, 32515)

	-- Swiftarrow Belt -- 60734
	AddRecipe(60734, 425, 43442, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60734, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60734, 32515)

	-- Swiftarrow Leggings -- 60735
	AddRecipe(60735, 425, 43448, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60735, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60735, 32515)

	-- Swiftarrow Boots -- 60737
	AddRecipe(60737, 425, 43443, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60737, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60737, 32515)

	-- Stormhide Crown -- 60743
	AddRecipe(60743, 420, 43455, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60743, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60743, 32515)

	-- Stormhide Shoulders -- 60746
	AddRecipe(60746, 420, 43457, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60746, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60746, 32515)

	-- Stormhide Hauberk -- 60747
	AddRecipe(60747, 420, 43453, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60747, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60747, 32515)

	-- Stormhide Wristguards -- 60748
	AddRecipe(60748, 420, 43452, Q.RARE, V.WOTLK, 420, 425, 430, 435)
	self:AddRecipeFlags(60748, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60748, 32515)

	-- Stormhide Grips -- 60749
	AddRecipe(60749, 425, 43454, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60749, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60749, 32515)

	-- Stormhide Belt -- 60750
	AddRecipe(60750, 425, 43450, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60750, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60750, 32515)

	-- Stormhide Legguards -- 60751
	AddRecipe(60751, 425, 43456, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60751, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60751, 32515)

	-- Stormhide Stompers -- 60752
	AddRecipe(60752, 425, 43451, Q.RARE, V.WOTLK, 425, 430, 435, 440)
	self:AddRecipeFlags(60752, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60752, 32515)

	-- Giantmaim Legguards -- 60754
	AddRecipe(60754, 440, 43458, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(60754, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60754, 32515)

	-- Giantmaim Bracers -- 60755
	AddRecipe(60755, 440, 43459, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(60755, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60755, 32515)

	-- Revenant's Breastplate -- 60756
	AddRecipe(60756, 440, 43461, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(60756, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60756, 32515)

	-- Revenant's Treads -- 60757
	AddRecipe(60757, 440, 43469, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(60757, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeVendor(60757, 32515)

	-- Trollwoven Spaulders -- 60758
	AddRecipe(60758, 440, 43481, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(60758, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(60758, 32515)

	-- Trollwoven Girdle -- 60759
	AddRecipe(60759, 440, 43484, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(60759, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER)
	self:AddRecipeVendor(60759, 32515)

	-- Earthgiving Legguards -- 60760
	AddRecipe(60760, 440, 43495, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(60760, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(60760, 32515)

	-- Earthgiving Boots -- 60761
	AddRecipe(60761, 440, 43502, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(60761, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(60761, 32515)

	-- Polar Vest -- 60996
	AddRecipe(60996, 425, 43590, Q.EPIC, V.WOTLK, 425, 435, 445, 455)
	self:AddRecipeFlags(60996, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeVendor(60996, 32515)

	-- Polar Cord -- 60997
	AddRecipe(60997, 420, 43591, Q.EPIC, V.WOTLK, 420, 430, 440, 450)
	self:AddRecipeFlags(60997, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeVendor(60997, 32515)

	-- Polar Boots -- 60998
	AddRecipe(60998, 420, 43592, Q.EPIC, V.WOTLK, 420, 430, 440, 450)
	self:AddRecipeFlags(60998, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeVendor(60998, 32515)

	-- Icy Scale Chestguard -- 60999
	AddRecipe(60999, 425, 43593, Q.EPIC, V.WOTLK, 425, 435, 445, 455)
	self:AddRecipeFlags(60999, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.MAIL)
	self:AddRecipeVendor(60999, 32515)

	-- Icy Scale Belt -- 61000
	AddRecipe(61000, 420, 43594, Q.EPIC, V.WOTLK, 420, 430, 440, 450)
	self:AddRecipeFlags(61000, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.MAIL)
	self:AddRecipeVendor(61000, 32515)

	-- Icy Scale Boots -- 61002
	AddRecipe(61002, 420, 43595, Q.EPIC, V.WOTLK, 420, 430, 440, 450)
	self:AddRecipeFlags(61002, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.MAIL)
	self:AddRecipeVendor(61002, 32515)

	-- Windripper Boots -- 62176
	AddRecipe(62176, 440, 44930, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(62176, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(62176, 32515)

	-- Windripper Leggings -- 62177
	AddRecipe(62177, 440, 44931, Q.EPIC, V.WOTLK, 440, 450, 455, 460)
	self:AddRecipeFlags(62177, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeVendor(62177, 32515)

	-- Earthen Leg Armor -- 62448
	AddRecipe(62448, 425, 44963, Q.COMMON, V.WOTLK, 425, 435, 440, 445)
	self:AddRecipeFlags(62448, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(62448, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Belt of Dragons -- 63194
	AddRecipe(63194, 450, 45553, Q.EPIC, V.WOTLK, 450, 455, 465, 475)
	self:AddRecipeFlags(63194, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(63194, A.CUSTOM, 39)

	-- Boots of Living Scale -- 63195
	AddRecipe(63195, 450, 45095, Q.EPIC, V.WOTLK, 450, 455, 465, 475)
	self:AddRecipeFlags(63195, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.MAIL)
	self:AddRecipeAcquire(63195, A.CUSTOM, 39)

	-- Blue Belt of Chaos -- 63196
	AddRecipe(63196, 450, 45096, Q.EPIC, V.WOTLK, 450, 455, 465, 475)
	self:AddRecipeFlags(63196, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(63196, A.CUSTOM, 39)

	-- Lightning Grounded Boots -- 63197
	AddRecipe(63197, 450, 45097, Q.EPIC, V.WOTLK, 450, 455, 465, 475)
	self:AddRecipeFlags(63197, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
	self:AddRecipeAcquire(63197, A.CUSTOM, 39)

	-- Death-warmed Belt -- 63198
	AddRecipe(63198, 450, 45098, Q.EPIC, V.WOTLK, 450, 455, 465, 475)
	self:AddRecipeFlags(63198, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeAcquire(63198, A.CUSTOM, 39)

	-- Footpads of Silence -- 63199
	AddRecipe(63199, 450, 45099, Q.EPIC, V.WOTLK, 450, 455, 465, 475)
	self:AddRecipeFlags(63199, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
	self:AddRecipeAcquire(63199, A.CUSTOM, 39)

	-- Belt of Arctic Life -- 63200
	AddRecipe(63200, 450, 45100, Q.EPIC, V.WOTLK, 450, 455, 465, 475)
	self:AddRecipeFlags(63200, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeAcquire(63200, A.CUSTOM, 39)

	-- Boots of Wintry Endurance -- 63201
	AddRecipe(63201, 450, 45101, Q.EPIC, V.WOTLK, 450, 455, 465, 475)
	self:AddRecipeFlags(63201, F.ALLIANCE, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
	self:AddRecipeAcquire(63201, A.CUSTOM, 39)

	-- Borean Leather -- 64661
	AddRecipe(64661, 350, 33568, Q.COMMON, V.WOTLK, 350, 350, 362, 375)
	self:AddRecipeFlags(64661, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP, F.LEATHER)
	self:AddRecipeTrainer(64661, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Drums of Forgotten Kings -- 69386
	AddRecipe(69386, 450, 49633, Q.COMMON, V.WOTLK, 450, 450, 455, 470)
	self:AddRecipeFlags(69386, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(69386, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Drums of the Wild -- 69388
	AddRecipe(69388, 450, 49634, Q.COMMON, V.WOTLK, 450, 450, 455, 470)
	self:AddRecipeFlags(69388, F.ALLIANCE, F.HORDE, F.TRAINER, F.IBOE, F.RBOP)
	self:AddRecipeTrainer(69388, 26998, 28700, 33581, 26911, 26961, 26996)

	-- Legwraps of Unleashed Nature -- 70554
	AddRecipe(70554, 450, 49898, Q.EPIC, V.WOTLK, 450, 460, 465, 470)
	self:AddRecipeFlags(70554, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER, F.ASHEN_VERDICT)
	self:AddRecipeRepVendor(70554, FAC.ASHEN_VERDICT, REP.REVERED, 37687)

	-- Blessed Cenarion Boots -- 70555
	AddRecipe(70555, 450, 49894, Q.EPIC, V.WOTLK, 450, 460, 465, 470)
	self:AddRecipeFlags(70555, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.LEATHER, F.ASHEN_VERDICT)
	self:AddRecipeRepVendor(70555, FAC.ASHEN_VERDICT, REP.HONORED, 37687)

	-- Bladeborn Leggings -- 70556
	AddRecipe(70556, 450, 49899, Q.EPIC, V.WOTLK, 450, 460, 465, 470)
	self:AddRecipeFlags(70556, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.LEATHER, F.ASHEN_VERDICT)
	self:AddRecipeRepVendor(70556, FAC.ASHEN_VERDICT, REP.REVERED, 37687)

	-- Footpads of Impending Death -- 70557
	AddRecipe(70557, 450, 49895, Q.EPIC, V.WOTLK, 450, 460, 465, 470)
	self:AddRecipeFlags(70557, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.TANK, F.LEATHER, F.ASHEN_VERDICT)
	self:AddRecipeRepVendor(70557, FAC.ASHEN_VERDICT, REP.HONORED, 37687)

	-- Lightning-Infused Leggings -- 70558
	AddRecipe(70558, 450, 49900, Q.EPIC, V.WOTLK, 450, 460, 465, 470)
	self:AddRecipeFlags(70558, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL, F.ASHEN_VERDICT)
	self:AddRecipeRepVendor(70558, FAC.ASHEN_VERDICT, REP.REVERED, 37687)

	-- Earthsoul Boots -- 70559
	AddRecipe(70559, 450, 49896, Q.EPIC, V.WOTLK, 450, 460, 465, 470)
	self:AddRecipeFlags(70559, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.MAIL, F.ASHEN_VERDICT)
	self:AddRecipeRepVendor(70559, FAC.ASHEN_VERDICT, REP.HONORED, 37687)

	-- Draconic Bonesplinter Legguards -- 70560
	AddRecipe(70560, 450, 49901, Q.EPIC, V.WOTLK, 450, 460, 465, 470)
	self:AddRecipeFlags(70560, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.ASHEN_VERDICT)
	self:AddRecipeRepVendor(70560, FAC.ASHEN_VERDICT, REP.REVERED, 37687)

	-- Rock-Steady Treads -- 70561
	AddRecipe(70561, 450, 49897, Q.EPIC, V.WOTLK, 450, 460, 465, 470)
	self:AddRecipeFlags(70561, F.ALLIANCE, F.HORDE, F.VENDOR, F.IBOE, F.RBOP, F.DPS, F.MAIL, F.ASHEN_VERDICT)
	self:AddRecipeRepVendor(70561, FAC.ASHEN_VERDICT, REP.HONORED, 37687)

	-- Some recipes are only availible to specific factions.
	-- We only add the faction specific recipes if the user is part of that faction
	local BFAC = LibStub("LibBabble-Faction-3.0"):GetLookupTable()
	local _,faction = UnitFactionGroup("player")

	if faction == BFAC["Alliance"] then

		-- Ensorcelled Nerubian Breastplate -- 67080
		AddRecipe(67080, 450, 47597, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67080, F.ALLIANCE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
		self:AddRecipeAcquire(67080, A.CUSTOM, 42)

		-- Black Chitin Bracers -- 67081
		AddRecipe(67081, 450, 47579, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67081, F.ALLIANCE, F.RAID)
		self:AddRecipeAcquire(67081, A.CUSTOM, 42)

		-- Crusader's Dragonscale Breastplate -- 67082
		AddRecipe(67082, 450, 47595, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67082, F.ALLIANCE, F.RAID)
		self:AddRecipeAcquire(67082, A.CUSTOM, 42)

		-- Crusader's Dragonscale Bracers -- 67083
		AddRecipe(67083, 450, 47576, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67083, F.ALLIANCE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.MAIL)
		self:AddRecipeAcquire(67083, A.CUSTOM, 42)

		-- Lunar Eclipse Chestguard -- 67084
		AddRecipe(67084, 450, 47602, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67084, F.ALLIANCE, F.RAID)
		self:AddRecipeAcquire(67084, A.CUSTOM, 42)

		-- Moonshadow Armguards -- 67085
		AddRecipe(67085, 450, 47583, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67085, F.ALLIANCE, F.RAID)
		self:AddRecipeAcquire(67085, A.CUSTOM, 42)

		-- Knightbane Carapace -- 67086
		AddRecipe(67086, 450, 47599, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67086, F.ALLIANCE, F.RAID)
		self:AddRecipeAcquire(67086, A.CUSTOM, 42)

		-- Bracers of Swift Death -- 67087
		AddRecipe(67087, 450, 47581, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67087, F.ALLIANCE, F.RAID)
		self:AddRecipeAcquire(67087, A.CUSTOM, 42)

	elseif faction == BFAC["Horde"] then

		-- Ensorcelled Nerubian Breastplate -- 67136
		AddRecipe(67136, 450, 47598, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67136, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
		self:AddRecipeAcquire(67136, A.CUSTOM, 42)

		-- Black Chitin Bracers -- 67137
		AddRecipe(67137, 450, 47580, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67137, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.MAIL)
		self:AddRecipeAcquire(67137, A.CUSTOM, 42)

		-- Crusader's Dragonscale Breastplate -- 67138
		AddRecipe(67138, 450, 47596, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67138, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.MAIL)
		self:AddRecipeAcquire(67138, A.CUSTOM, 42)

		-- Bracers of Swift Death -- 67139
		AddRecipe(67139, 450, 47582, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67139, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
		self:AddRecipeAcquire(67139, A.CUSTOM, 42)

		-- Lunar Eclipse Robes -- 67140
		AddRecipe(67140, 450, 47601, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67140, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
		self:AddRecipeAcquire(67140, A.CUSTOM, 42)

		-- Moonshadow Armguards -- 67141
		AddRecipe(67141, 450, 47584, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67141, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.HEALER, F.CASTER, F.LEATHER)
		self:AddRecipeAcquire(67141, A.CUSTOM, 42)

		-- Knightbane Carapace -- 67142
		AddRecipe(67142, 450, 47600, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67142, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.LEATHER)
		self:AddRecipeAcquire(67142, A.CUSTOM, 42)

		-- Crusader's Dragonscale Bracers -- 67143
		AddRecipe(67143, 450, 47577, Q.EPIC, V.WOTLK, 450, 460, 467, 475)
		self:AddRecipeFlags(67143, F.HORDE, F.RAID, F.IBOE, F.RBOE, F.DPS, F.MAIL)
		self:AddRecipeAcquire(67143, A.CUSTOM, 42)
	end
	return num_recipes
end
