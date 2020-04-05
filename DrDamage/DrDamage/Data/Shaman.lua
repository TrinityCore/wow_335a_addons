if select(2, UnitClass("player")) ~= "SHAMAN" then return end
local GetSpellInfo = GetSpellInfo
local GetSpellCritChance = GetSpellCritChance
local GetSpellBonusDamage = GetSpellBonusDamage
local UnitPowerMax = UnitPowerMax
local IsEquippedItem = IsEquippedItem
local UnitAttackSpeed = UnitAttackSpeed
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local string_find = string.find
local string_match = string.match
local string_gsub = string.gsub
local math_min = math.min
local math_max = math.max
local math_floor = math.floor
local select = select
local tonumber = tonumber

function DrDamage:PlayerData()
	--Health updates
	self.TargetHealth = { [1] = 0.351 }
	--Mana tide totem
	self.ClassSpecials[GetSpellInfo(16190)] = function()
		--Glyph of Mana Tide Totem
		return (self:HasGlyph(55441) and 0.28 or 0.24) * UnitPowerMax("player",0), nil, true
	end
	--Mana spring totem
	local MST, MSR = GetSpellInfo(5675)
	local RT = GetSpellInfo(16187)
	self.ClassSpecials[MST] = function(rank)
		local cost = rank and select(4, GetSpellInfo(MST,(string_gsub(MSR,"%d+", rank))))
		cost = tonumber(cost) or 0
		return (select(rank or 8, 960, 1260, 1560, 1860, 2460, 4380, 4920, 5460)) * (1 + select(self.talents[RT] or 4,0.7,0.12,0.20,0)) - cost, nil, true
	end
--GENERAL
	local elw = GetSpellInfo(51730)
	local elwicon = "|T" .. select(3,GetSpellInfo(51730)) .. ":16:16:1:-1|t"
	self.Calculation["SHAMAN"] = function( calculation, ActiveAuras, Talents )
		if Talents["Frozen Power"] and ActiveAuras["Frostbrand Attack"] then
			calculation.dmgM = calculation.dmgM * (1 + Talents["Frozen Power"])
		end
		if calculation.healingSpell then
			if calculation.spellName ~= "Healing Stream Totem" then
				local name, rank = self:GetWeaponBuff()
				if name and string_find(elw,name) then
					local bonus = rank and select(rank, 116, 160, 220, 348, 456, 652) or 652
					local chance = (self:HasGlyph(55439) and 0.25 or 0.2) + (UnitHealth("target") ~= 0 and ((UnitHealth("target") / UnitHealthMax("target")) <= 0.35) and Talents["Blessing of the Eternals"] or 0)
					chance = math_min(1, chance * (calculation.spellName == "Chain Heal" and calculation.aoe or 1))
					calculation.extra = bonus 
					calculation.extraDamage = 0.455 * 1.88 * (12/15)
					calculation.extraBonus = true
					calculation.extraDmgM = 1 + (Talents["Purification"] or 0)
					calculation.extraTicks = 4
					calculation.extraName = elwicon
					calculation.extraChance = chance
				end
				name, rank = self:GetWeaponBuff(true)
				if name and string_find(elw,name) then
					local bonus = rank and select(rank, 116, 160, 220, 348, 456, 652) or 652
					local chance = (self:HasGlyph(55439) and 0.25 or 0.2) + (UnitHealth("target") ~= 0 and ((UnitHealth("target") / UnitHealthMax("target")) <= 0.35) and Talents["Blessing of the Eternals"] or 0)
					chance = math_min(1, chance * (calculation.spellName == "Chain Heal" and calculation.aoe or 1))
					calculation.extra = bonus 
					calculation.extraDamage = 0.455 * 1.88 * (12/15)
					calculation.extraBonus = true
					calculation.extraDmgM = 1 + (Talents["Purification"] or 0)
					calculation.extraTicks = 4
					calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. elwicon) or elwicon
					calculation.extraChance = (calculation.extraChance < 1) and math_min(1, calculation.extraChance + chance) or chance
				end
			end
		else
			if Talents["Elemental Oath"] and ActiveAuras["Clearcasting"] then
				--Multiplicative 3.3.3
				calculation.dmgM = calculation.dmgM * (1 + Talents["Elemental Oath"])
			end
		end
	end
	self.Calculation["Dual Wield Specialization"] = function( calculation, talentValue )
		if calculation.offHand then
			calculation.hitPerc = calculation.hitPerc + talentValue
		end
	end
	self.Calculation["Weapon Mastery"] = function( calculation, talentValue )
		calculation.dmgM = calculation.dmgM * (1 + talentValue)
		calculation.wDmgM = calculation.wDmgM * (1 + talentValue)
	end	
--ABILITIES
	local wf = GetSpellInfo(8232)
	local wficon = "|T" .. select(3,GetSpellInfo(8232)) .. ":16:16:1:-1|t"
	--Flametongue
	local ft = GetSpellInfo(8024)
	local fticon = "|T" .. select(3,GetSpellInfo(8024)) .. ":16:16:1:-1|t"
	local ft_table = { 3.26, 4.79, 7.16, 11.44, 18.76, 24.98, 31.07, 50.3, 60, 68.5 }
	local ft_table_inc = { 1.14, 1.735, 3.365, 5.835, 4.965, 6.07, 3.93, 3.955, 3.925, 0 }
	local ft_table_lvl = { 10, 18, 26, 36, 46, 56, 64, 71, 76, 80 }
	--Frostbrand
	local fb = GetSpellInfo(8033)
	local fbicon = "|T" .. select(3,GetSpellInfo(8033)) .. ":16:16:1:-1|t"
	local fb_table = { 42, 63, 101, 160, 210, 259, 391, 463, 530 }
	local fb_table_inc = { 12.5, 24, 40, 32, 40, 29, 29.5, 29.5, 29.5 }
	local fb_table_lvl = { 20, 28, 38, 48, 58, 66, 71, 76, 80 }
	self.Calculation["Attack"] = function( calculation, _, Talents, spell, baseSpell )
		local spellHit = 0.01 * math_max(0,math_min(100,self:GetSpellHit(calculation.playerLevel, calculation.targetLevel) + calculation.spellHit))
		local critM = (0.5 + (Talents["Elemental Fury"] or 0)) * (1 + 3 * self.Damage_critMBonus)
		local name, rank = self:GetWeaponBuff()
		local pcm, pco
		if name then
			if string_find(wf, name) then
				--Totem of Splintering, Totem of the Astral Winds
				local bonus = IsEquippedItem(40710) and 212 or IsEquippedItem(27815) and 80 or 0
				local AP = rank and select(rank, 46, 119, 249, 333, 445, 835, 1090, 1250) or 1250
				local spd = UnitAttackSpeed("player")
				pcm = self:HasGlyph(55445) and (select(math_floor(spd/1.5) + 1, 0.132, 0.153, 0.18) or 0.22) or (select(math_floor(spd/1.5) + 1, 0.125, 0.143, 0.167) or 0.2)
				calculation.WindfuryBonus = AP + bonus
				calculation.extraName = wficon
			elseif string_find(ft, name) then
				local spd = self:GetWeaponSpeed()
				local bonus = tonumber(rank) or 10
				local level = calculation.playerLevel
				local diff = (level >= 70) and 1 or (level >= (8 + ft_table_lvl[bonus])) and 1 or (level - ft_table_lvl[bonus])/8
				local coeff = (spd <= 2.6) and (spd / 2.6) * 0.1 or (0.1 + (spd - 2.6)/ 1.4 * 0.05)
				bonus = ft_table[bonus] + ft_table_inc[bonus] * diff
				--Modifiers to core:
				calculation.extraDamage = 0
				calculation.extraName = fticon
				calculation.extra = calculation.extra + spd * bonus
				calculation.extraDamageSP = coeff
				calculation.extraChance = spellHit
				calculation.E_canCrit = true
				calculation.E_critM = critM
				calculation.E_dmgM = calculation.dmgM_Magic			
				calculation.E_spellDmg = GetSpellBonusDamage(3)			
				calculation.E_critPerc = GetSpellCritChance(3) + calculation.spellCrit
			elseif string_find(fb, name) then
				local spd = self:GetWeaponSpeed()
				local bonus = tonumber(rank) or 9
				local level = calculation.playerLevel
				local diff = (level >= 70) and 1 or (level >= (8 + fb_table_lvl[bonus])) and 1 or (level - fb_table_lvl[bonus])/8
				bonus = fb_table[bonus] + fb_table_inc[bonus] * diff
				--Modifiers to core:
				calculation.extraDamage = 0
				calculation.extraName = fbicon
				calculation.extra = calculation.extra + bonus
				calculation.extraDamageSP = 0.1
				calculation.extraChance = (spd * 9)/60 * spellHit
				calculation.E_canCrit = true
				calculation.E_critM = critM
				calculation.E_dmgM = calculation.dmgM_Magic					
				calculation.E_spellDmg = GetSpellBonusDamage(5)			
				calculation.E_critPerc = GetSpellCritChance(5) + calculation.spellCrit
			end
		end
		if calculation.offHand then
			local name, rank = self:GetWeaponBuff(true)
			if name then
				if string_find(wf, name) then
					--Totem of Splintering, Totem of the Astral Winds
					local bonus = IsEquippedItem(40710) and 212 or IsEquippedItem(27815) and 80 or 0
					local AP = rank and select(rank, 46, 119, 249, 333, 445, 835, 1090, 1250) or 1250
					local _, ospd = UnitAttackSpeed("player")
					pco = self:HasGlyph(55445) and (select(math_floor(ospd/1.5) + 1, 0.132, 0.153, 0.18) or 0.22) or (select(math_floor(ospd/1.5) + 1, 0.125, 0.143, 0.167) or 0.2)
					calculation.WindfuryBonus_O = AP + bonus
					calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. wficon) or wficon
				elseif string_find(ft, name) then
					local _, spd = self:GetWeaponSpeed()
					local bonus = tonumber(rank) or 10
					local level = calculation.playerLevel
					local diff = (level >= 70) and 1 or (level >= (8 + ft_table_lvl[bonus])) and 1 or (level - ft_table_lvl[bonus])/8
					local coeff = (spd <= 2.6) and (spd / 2.6) * 0.1 or (0.1 + (spd - 2.6)/ 1.4 * 0.05)
					bonus = ft_table[bonus] + ft_table_inc[bonus] * diff
					--Modifiers to core:
					calculation.extraDamage = 0
					calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. fticon) or fticon
					calculation.extra_O = calculation.extra_O + spd * bonus
					calculation.extraDamageSP_O = coeff
					calculation.extraChance_O = spellHit
					calculation.E_canCrit = true
					calculation.E_critM = critM
					calculation.E_dmgM = calculation.dmgM_Magic
					calculation.E_spellDmg_O = GetSpellBonusDamage(3)
					calculation.E_critPerc_O = GetSpellCritChance(3) + calculation.spellCrit
				elseif string_find(fb, name) then
					local _, spd = self:GetWeaponSpeed()
					local bonus = tonumber(rank) or 9
					local level = calculation.playerLevel
					local diff = (level >= 70) and 1 or (level >= (8 + fb_table_lvl[bonus])) and 1 or (level - fb_table_lvl[bonus])/8
					bonus = fb_table[bonus] + fb_table_inc[bonus] * diff
					--Modifiers to core:
					calculation.extraDamage = 0
					calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. fbicon) or fbicon
					calculation.extra_O = calculation.extra_O + bonus
					calculation.extraDamageSP_O = 0.1
					calculation.extraChance_O = (spd * 9)/60 * spellHit
					calculation.E_canCrit = true
					calculation.E_critM = critM
					calculation.E_dmgM = calculation.dmgM_Magic
					calculation.E_spellDmg_O = GetSpellBonusDamage(5)
					calculation.E_critPerc_O = GetSpellCritChance(5) + calculation.spellCrit
				end
			end
		end
		if Talents["Elemental Weapons"] then
			calculation.WindfuryDmgM = 1 + Talents["Elemental Weapons"]
		end
		--Model windfury cooldown effects
		if pcm and pco then
			local spd, ospd = UnitAttackSpeed("player")
			if spd <= 1.5 and ospd <= 1.5 then
				--From total 1.7s to 2.9s combined (simulation from 0.8 - 1.4, 0.9 - 1.5)
				if self:HasGlyph(55445) then
					--Max error deviation 1.39%, avg 0.346%
					pcm = 10.9 + math_min(1,math_max(0,(spd+ospd-1.7)/1.2)) * 4.1
				else
					--Max error deviation 0.8%, avg: 0.314%
					pcm = 10.7 + math_min(1,math_max(0,(spd+ospd-1.7)/1.2)) * 3.8
				end
			elseif spd <= 1.5 or ospd <= 1.5 then
				--From total 2.4s to 4.2s combined (simulation from 0.8 - 1.5, 1.6 - 2.7)
				if self:HasGlyph(55445) then
					--Max error deviation 1.73%, avg 0.725%
					pcm = 13.8 + math_min(1,math_max(0,(spd+ospd-2.4)/1.8)) * 4
				else
					--Max error deviation 1.7%, avg 0.678%
					pcm = 13.3 + math_min(1,math_max(0,(spd+ospd-2.4)/1.8)) * 3.9
				end
			elseif spd > 1.5 and ospd > 1.5 then
				--From total 3.3s to 5.3s combined (simulation from 1.6 - 2.6, 1.7 - 2.7)
				if self:HasGlyph(55445) then
					--Max error deviation 1.67%, avg 0.198%
					pcm = 18.5 + math_min(1,math_max(0,(spd+ospd-3.3)/2)) * 2.6
				else
					--Max error deviation 1.58%, avg 0.165%
					pcm = 17.8 + math_min(1,math_max(0,(spd+ospd-3.3)/2)) * 2.4
				end
			end
			calculation.WindfuryChance = pcm / 100
		else
			calculation.WindfuryChance = pcm or pco
		end
	end
	self.Calculation["Lava Lash"] = function( calculation )
		--Glyph of Lava Lash (checked - 3.3.3)
		if calculation.offHand then
			local name = self:GetWeaponBuff(true)
			if name and string_find(ft, name) then
				calculation.dmgM = calculation.dmgM * (1.25 + (self:HasGlyph(55444) and 0.1 or 0))
			end
		end
		--Additive/multiplicative?
		if self:GetSetAmount( "T8 Melee" ) >= 2 then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Earth Shield"] = function( calculation )
		--Glyph of Earth Shield (multiplicative - 3.3.3)
		if self:HasGlyph(63279) then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Lava Burst"] = function( calculation, ActiveAuras )
		--Glyph of Lava (additive - 3.3.3)
		if self:HasGlyph(55454) then
			calculation.spellDmgM = calculation.spellDmgM + 0.1
		end
		if ActiveAuras["Flame Shock"] then
			calculation.critPerc = 100
		end
		if self:GetSetAmount( "T7 Elemental" ) >= 4 then
			calculation.critM = calculation.critM + 0.05
		end
		if self:GetSetAmount( "T9 Elemental" ) >= 4 then
			calculation.extraAvg = 0.1
			calculation.extraTicks = 3
			calculation.extraName = "4T9"
		end
	end
	self.Calculation["Chain Heal"] = function( calculation )
		--Glyph of Chain Heal
		if self:HasGlyph(55437) then
			calculation.aoe = 4
		end
		if self:GetSetAmount( "T7 Healer" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.05
		end
		if self:GetSetAmount( "T9 Healer" ) >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
		if self:GetSetAmount( "T10 Healer" ) >= 4 then
			--TODO: Make work in conjunction with ELW?
			if calculation.extra then
				calculation.extra = nil
				calculation.extraDamage = nil
				calculation.extraChance = nil
				calculation.extraBonus = nil
			end
			-- 25% of amount healed becomes a HoT over 9s on critical heal
			calculation.extraCrit = 0.25
			calculation.extraChanceCrit = true
			calculation.extraTicks = 3
			calculation.extraName = "4T10"
		end
	end
	self.Calculation["Chain Lightning"] = function( calculation )
		--Glyph of Chain Lightning
		if self:HasGlyph(55449) then
			calculation.aoe = 4
		end
	end
	self.Calculation["Flame Shock"] = function( calculation )
		calculation.hybridCanCrit = true
		calculation.customHaste = true
		--Glyph of Flame Shock
		if self:HasGlyph(55447) then
			calculation.critM_dot = (calculation.critM + 0.3) * (1 + 3 * self.Damage_critMBonus)
		end
		--Glyph of Shocking then
		if self:HasGlyph(55442) then
			calculation.castTime = 1
		end
		if self:GetSetAmount( "T8 Elemental" ) >= 2 then
			calculation.dmgM_dot_Add = calculation.dmgM_dot_Add + 0.2
		end
		if self:GetSetAmount( "T9 Elemental" ) >= 2 then
			calculation.eDuration = calculation.eDuration + 9
		end
		--Confirmed additive - 3.3.3
		if self:GetSetAmount( "T9 Melee" ) >= 4 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.25
		end
	end
	self.Calculation["Frost Shock"] = function( calculation )
		--Glyph of Shocking then
		if self:HasGlyph(55442) then
			calculation.castTime = 1
		end
		if self:GetSetAmount( "T9 Melee" ) >= 4 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.25
		end
	end
	self.Calculation["Earth Shock"] = self.Calculation["Frost Shock"]
	self.Calculation["Healing Stream Totem"] = function( calculation )
		--Glyph of Healing Stream Totem (additive with restorative totems - 3.3.3)
		if self:HasGlyph(55456) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Lesser Healing Wave"] = function( calculation, ActiveAuras )
		--Glyph of Lesser Healing Wave (additive/multiplicative - unknown since Purification is multiplicative)
		if self:HasGlyph(55438) and ActiveAuras["Earth Shield"] then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Lightning Bolt"] = function( calculation )
		--Glyph of Lightning Bolt (additive - 3.3.2)
		if self:HasGlyph(55453) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.04
		end
		if self:GetSetAmount( "T8 Elemental" ) >= 4 then
			calculation.extraCrit = 0.08
			calculation.extraCritChance = true
			calculation.extraTicks = 2
		end
	end
	self.Calculation["Lightning Shield"] = function( calculation )
		--Glyph of Lightning Shield (additive - 3.3.3)
		if self:HasGlyph(55448) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
		if self:GetSetAmount( "T7 Melee" ) >= 2 then --(Additive/Multiplicative)
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
	end
	self.Calculation["Riptide"] = function( calculation )
		--Glyph of Riptide
		if self:HasGlyph(63273) then
			calculation.eDuration = calculation.eDuration + 6
		end
		if self:GetSetAmount( "T8 Healer" ) >= 2 then
			calculation.cooldown = calculation.cooldown - 1
		end
		if self:GetSetAmount( "T9 Healer" ) >= 2 then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Thunderstorm"] = function( calculation )
		--Glyph of Thunder
		if self:HasGlyph(63270) then
			calculation.cooldown = calculation.cooldown - 10
		end

	end
	self.Calculation["Fire Nova"] = function( calculation )
		--Glyph of Fire Nova
		if self:HasGlyph(55450) then
			calculation.cooldown = calculation.cooldown - 3
		end

	end
	self.Calculation["Stormstrike"] = function( calculation )
		if self:GetSetAmount( "T8 Melee" ) >= 2 then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Healing Wave"] = function( calculation )
		if self:GetSetAmount( "T7 Healer" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.05
		end
	end
--SETS
	self.SetBonuses["T7 Melee"] = { 40520, 40521, 40522, 40523, 40524, 39597, 39601, 39602, 39603, 39604 }
	self.SetBonuses["T7 Elemental"] = { 39592, 39593, 39594, 39595, 39596, 40514, 40515, 40516, 40517, 40518 }
	self.SetBonuses["T7 Healer"] = { 40508, 40509, 40510, 40512, 40513, 39583, 39588, 39589, 39590, 39591 }
	self.SetBonuses["T8 Melee"] = { 46200, 46203, 46205, 46208, 46212, 45412, 45413, 45414, 45415, 45416 }
	self.SetBonuses["T8 Elemental"] = { 46206, 46207, 46209, 46210, 46211, 45406, 45408, 45409, 45410, 45411 }
	self.SetBonuses["T8 Healer"] = { 46198, 46199, 46201, 46202, 46204, 45401, 45402, 45403, 45404, 45405 }
	self.SetBonuses["T9 Melee"] = { 48341, 48342, 48343, 48344, 48345, 48366, 48367, 48368, 48369, 48370, 48346, 48348, 48347, 48350, 48349, 48355, 48353, 48354, 48351, 48352, 48365, 48363, 48364, 48361, 48362, 48356, 48358, 48357, 48360, 48359 }
	self.SetBonuses["T9 Elemental"] = { 48310, 48312, 48313, 48314, 48315, 48336, 48337, 48338, 48339, 48340, 48334, 48335, 48333, 48332, 48331, 48327, 48326, 48328, 48329, 48330, 48317, 48316, 48318, 48319, 48320, 48324, 48325, 48323, 48322, 48321 }
	self.SetBonuses["T9 Healer"] = { 48280, 48281, 48282, 48283, 48284, 48295, 48296, 48297, 48298, 48299, 48301, 48302, 48303, 48304, 48300, 48306, 48307, 48308, 48309, 48305, 48286, 48287, 48288, 48289, 48285, 48293, 48292, 48291, 48290, 48294 }
	self.SetBonuses["T10 Elemental"] = { 50842, 50841, 50843, 50844, 50845, 51238, 51201, 51239, 51200, 51237, 51202, 51236, 51203, 51235, 51204 }
	self.SetBonuses["T10 Healer"] = { 50836, 50837, 50838, 50839, 50835, 51248, 51191, 51247, 51192, 51246, 51193, 51245, 51194, 51249, 51190 }
--RELIC
	--Steamcaller's Totem, Totem of Healing Rains, Totem of the Bay
	self.RelicSlot["Chain Heal"] = { 45114, 243, 28523, 87, 38368, 102, ModType1 = "Base", ModType2 = "Base", ModType3 = "Base" }
	--Thunderfall Totem, Venture Co. Lightning Rod
	self.RelicSlot["Lava Burst"] = { 45255, 215, 38361, 121, ModType1 = "Base", ModType2 = "Base" }
	--Venture Co. Flame Slicer
	self.RelicSlot["Lava Lash"] = { 38367, 25 }
	--Totem of Spontaneous Regrowth
	self.RelicSlot["Healing Wave"] = { 27544, 88, }
	--Totem of Rage, Totem of Impact
	self.RelicSlot["Earth Shock"] = { 22395, 30, 27947, 46, 27984, 46, }
	self.RelicSlot["Frost Shock"] = { 22395, 30, 27947, 46, 27984, 46, }
	self.RelicSlot["Flame Shock"] = { 22395, 30, 27947, 46, 27984, 46, }
	--Totem of Hex (unaffected by Shamanism), Totem of the Void, Totem of the Storm, Totem of Ancestral Guidance
	self.RelicSlot["Lightning Bolt"] = { 40267, 165, 28248, 55, 23199, 33, 32330, 85, ModType1 = "BaseSP" }
	self.RelicSlot["Chain Lightning"] = { 40267, 165, 28248, 55, 23199, 33, 32330, 85, ModType1 = "BaseSP" }
	self.RelicSlot["Lesser Healing Wave"] = { 
		--Savage, Hateful, Deadly, Furious, Relentless, Wrathful
		42595, 204, 42596, 236, 42597, 267, 42598, 320, 42599, 404, 51501, 459,
		--Totem of the Plains, Totem of Life, Totem of Sustaining	
		25645, 79, 22396, 80, 23200, 53, 
		ModTypeAll = "BaseSP",
	}
	--Totem of the Dancing Flame
	self.RelicSlot["Stormstrike"] = { 45169, 155 }
--AURA
--Player
	--Maelstrom Weapon
	self.PlayerAura[GetSpellInfo(53817)] = { Update = true }
	--Elemental Mastery
	self.PlayerAura[GetSpellInfo(16166)] = self.PlayerAura[GetSpellInfo(53817)]
	--Lava Flows
	self.PlayerAura[GetSpellInfo(65264)] = self.PlayerAura[GetSpellInfo(53817)]
	--Tidal Force
	self.PlayerAura[GetSpellInfo(55166)] = { Spells = { 331, 8004, 1064 }, Apps = 3, Value = 20, ModType = "critPerc", NoManual = true }
	--Clearcasting
	self.PlayerAura[GetSpellInfo(16246)] = { School = "Spells", ActiveAura = "Clearcasting", ID = 16246, Mods = { ["manaCost"] = function(v) return v * 0.6 end } }
--Target
	--Riptide
	self.TargetAura[GetSpellInfo(61295)] = { Spells = 1064, Value = 0.25, ID = 61295 }
	--Flame Shock
	self.TargetAura[GetSpellInfo(8050)] = { ActiveAura = "Flame Shock", Spells = 51505, ID = 8050 }
	--Frostbrand Attack
	self.TargetAura[GetSpellInfo(8034)] = { ActiveAura = "Frostbrand Attack", ID = 8034 }
	--Earth Shield
	self.TargetAura[GetSpellInfo(49284)] = { ActiveAura = "Earth Shield", Spells = 8004, SelfCastBuff = true, ID = 49284 }
--Custom
	--Tidal Waves
	self.PlayerAura[GetSpellInfo(53390)] = { Spells = { 331, 8004 }, ID = 53390, ModType =
		function( calculation )
			if calculation.spellName == "Lesser Healing Wave" then
				calculation.critPerc = calculation.critPerc + 25
			end
		end
	}
	--Stormstrike
	self.TargetAura[GetSpellInfo(17364)] = { School = "Nature", SelfCast = true, ID = 17364, ModType =
		function( calculation )
			calculation.dmgM = calculation.dmgM * (self:HasGlyph(55446) and 1.28 or 1.2)
		end
	}

	self.spellInfo = {
		--TODO: Thunderstorm coefficient
		[GetSpellInfo(324)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Lightning Shield",
			[0] = { School = "Nature", SPBonus = 0.801, sHits = 3, NoDPS = true, NoDoom = true, NoPeriod = true, Downrank = 7 },
			[1] = { 13, 13, spellLevel = 8, },
			[2] = { 29, 29, spellLevel = 16, },
			[3] = { 51, 51, spellLevel = 24, },
			[4] = { 80, 80, spellLevel = 32, },
			[5] = { 114, 114, spellLevel = 40, },
			[6] = { 154, 154, spellLevel = 48, },
			[7] = { 198, 198, spellLevel = 56, Downrank = 6 },
			[8] = { 232, 232, spellLevel = 63, Downrank = 6 },
			[9] = { 287, 287, spellLevel = 70, Downrank = 4 },
			[10] = { 325, 325, spellLevel = 75, Downrank = 4 },
			[11] = { 380, 380, spellLevel = 80, },
		},
		[GetSpellInfo(403)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Lightning Bolt",
			[0] = { School = { "Nature", "Nuke" }, canCrit = true, castTime = 2.5, BaseIncrease = true, },
			[1] = { 13, 15, 2, 2, castTime = 1.5, spellLevel = 1, },
			[2] = { 26, 30, 2, 3, castTime = 2, spellLevel = 8, },
			[3] = { 45, 53, 3, 4, spellLevel = 14, },
			[4] = { 83, 95, 5, 5, spellLevel = 20, },
			[5] = { 125, 143, 6, 6, spellLevel = 26, },
			[6] = { 172, 194, 7, 8, spellLevel = 32, },
			[7] = { 227, 255, 8, 9, spellLevel = 38, },
			[8] = { 282, 316, 9, 10, spellLevel = 44, },
			[9] = { 347, 389, 10, 11, spellLevel = 50, },
			[10] = { 419, 467, 12, 12, spellLevel = 56, },
			[11] = { 495, 565, 10, 11, spellLevel = 62, Downrank = 4 },
			[12] = { 563, 643, 11, 12, spellLevel = 67, Downrank = 4 },
			[13] = { 595, 679, 12, 12, spellLevel = 73, Downrank = 4 },
			[14] = { 715, 815, 4, 4, spellLevel = 79, },
		},
		[GetSpellInfo(421)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Chain Lightning",
			[0] = { School = { "Nature", "Nuke" }, canCrit = true, castTime = 2, Cooldown = 6, chainFactor = 0.7, AoE = 3, BaseIncrease = true, },
			[1] = { 191, 217, 9, 10, spellLevel = 32, },
			[2] = { 277, 311, 11, 12, spellLevel = 40, },
			[3] = { 378, 424, 13, 14, spellLevel = 48, },
			[4] = { 493, 551, 15, 16, spellLevel = 56, },
			[5] = { 603, 687, 17, 18, spellLevel = 63, },
			[6] = { 734, 838, 15, 16, spellLevel = 70, Downrank = 4 },
			[7] = { 806, 920, 16, 16, spellLevel = 74, },
			[8] = { 973, 1111, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(8042)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Earth Shock",
			[0] = { School = { "Nature", "Shock" }, sFactor = 0.90, canCrit = true, Cooldown = 6, BaseIncrease = true, },
			[1] = { 17, 19, 2, 3, spellLevel = 4, },
			[2] = { 32, 34, 3, 4, spellLevel = 8, },
			[3] = { 60, 64, 5, 5, spellLevel = 14, },
			[4] = { 119, 127, 7, 7, spellLevel = 24, },
			[5] = { 225, 239, 10, 10, spellLevel = 36, },
			[6] = { 359, 381, 13, 13, spellLevel = 48, },
			[7] = { 517, 545, 15, 16, spellLevel = 60, },
			[8] = { 658, 692, 14, 15, spellLevel = 69, Downrank = 4 },
			[9] = { 723, 761, 16, 16, spellLevel = 74, Downrank = 4 },
			[10] = { 849, 895, 5, 5, spellLevel = 79, },
		},
		[GetSpellInfo(8050)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Flame Shock",
			[0] = { School = { "Fire", "Shock" }, SPBonus = 0.214, dotFactor = 18/15 * 0.5, canCrit = true, Cooldown = 6, eDuration = 18, sTicks = 3, BaseIncrease = true },
			[1] = { 21, 21, 4, 4, hybridDotDmg = 42, spellLevel = 10, },
			[2] = { 45, 45, 6, 6, hybridDotDmg = 72, spellLevel = 18, },
			[3] = { 86, 86, 8, 9, hybridDotDmg = 144, spellLevel = 28, },
			[4] = { 152, 152, 11, 12, hybridDotDmg = 252, spellLevel = 40, },
			[5] = { 230, 230, 14, 15, hybridDotDmg = 384, spellLevel = 52, },
			[6] = { 309, 309, 24, 25, hybridDotDmg = 516, spellLevel = 60, Downrank = 7 },
			[7] = { 377, 377, 15, 16, hybridDotDmg = 630, spellLevel = 70, Downrank = 4 },
			[8] = { 425, 425, 16, 16, hybridDotDmg = 714, spellLevel = 75, Downrank = 4 },
			[9] = { 500, 500, 0, 0, hybridDotDmg = 834, spellLevel = 80, },
		},
		[GetSpellInfo(8056)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Frost Shock",
			[0] = { School = { "Frost", "Shock" }, sFactor = 0.90, canCrit = true, Cooldown = 6, BaseIncrease = true, },
			[1] = { 89, 95, 6, 6, spellLevel = 20, },
			[2] = { 206, 220, 9, 10, spellLevel = 34, },
			[3] = { 333, 353, 12, 13, spellLevel = 46, },
			[4] = { 486, 514, 15, 15, spellLevel = 58, },
			[5] = { 640, 676, 14, 14, spellLevel = 68, Downrank = 4 },
			[6] = { 681, 719, 16, 16, spellLevel = 73, Downrank = 4 },
			[7] = { 802, 848, 10, 10, spellLevel = 78, },
		},
		[GetSpellInfo(3599)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Searing Totem",
			[0] = { School = { "Fire", "OffensiveTotem" }, eDuration = 60, sHits = 24, eDot = true, canCrit = true, Downrank = 9 },
			[1] = { 9, 11, spellLevel = 10, eDuration = 30, sHits = 12, },
			[2] = { 13, 17, spellLevel = 20, eDuration = 35, sHits = 14, },
			[3] = { 19, 25, spellLevel = 30, eDuration = 40, sHits = 16, },
			[4] = { 26, 34, spellLevel = 40, eDuration = 45, sHits = 18, },
			[5] = { 33, 45, spellLevel = 50, eDuration = 50, sHits = 20, },
			[6] = { 40, 54, spellLevel = 60, eDuration = 55, sHits = 22, Downrank = 8 },
			[7] = { 56, 74, spellLevel = 69, Downrank = 5 },
			[8] = { 68, 92, spellLevel = 71, Downrank = 7 },
			[9] = { 77, 103, spellLevel = 75, },
			[10] = { 90, 120, spellLevel = 80, },
		},
		[GetSpellInfo(1535)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Fire Nova",
			[0] = { School = { "Fire", "OffensiveTotem" }, canCrit = true, sFactor = 1/2, Cooldown = 10, BaseIncrease = true, AoE = true, Downrank = 4 },
			[1] = { 48, 56, 5, 6, spellLevel = 12, },
			[2] = { 102, 116, 8, 8, spellLevel = 22, },
			[3] = { 184, 208, 11, 11, spellLevel = 32, },
			[4] = { 281, 317, 14, 14, spellLevel = 42, },
			[5] = { 396, 442, 17, 17, spellLevel = 52, },
			[6] = { 518, 578, 19, 20, spellLevel = 61, Downrank = 5 },
			[7] = { 727, 813, 22, 23, spellLevel = 70, Downrank = 5 },
			[8] = { 755, 843, 22, 23, spellLevel = 75, Downrank = 5 },
			[9] = { 893, 997, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(8190)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Magma Totem",
			[0] = { School = { "Fire", "OffensiveTotem" }, SPBonus = 1, canCrit = true, eDot = true, eDuration = 20, sHits = 10, AoE = true, NoPeriod = true, Downrank = 9 },
			[1] = { 38, 38, spellLevel = 26, },
			[2] = { 64, 64, spellLevel = 36, },
			[3] = { 94, 94, spellLevel = 46, },
			[4] = { 131, 131, spellLevel = 56, Downrank = 8 },
			[5] = { 180, 180, spellLevel = 65, Downrank = 7 },
			[6] = { 314, 314, spellLevel = 73, Downrank = 4 },
			[7] = { 371, 371, spellLevel = 78, },
		},
		[GetSpellInfo(51490)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK (0.171-0.172), DOWNRANK OK
			["Name"] = "Thunderstorm",
			[0] = { School = { "Nature", "Nuke" }, SPBonus = 0.172, canCrit = true, Cooldown = 45, BaseIncrease = true, AoE = true, Downrank = 5 },
			[1] = { 551, 629, 14, 15, spellLevel = 60, },
			[2] = { 1074, 1226, 14, 15, spellLevel = 70, },
			[3] = { 1226, 1400, 14, 15, spellLevel = 75, },
			[4] = { 1450, 1656, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(51505)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK (NONE)
			["Name"] = "Lava Burst",
			[0] = { School = { "Fire", "Nuke" }, castTime = 2, canCrit = true, Cooldown = 8, BaseIncrease = true },
			[1] = { 1012, 1290, 26, 26, spellLevel = 75, },
			[2] = { 1192, 1518, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(8004)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Lesser Healing Wave",
			[0] = { School = { "Nature", "Healing", }, canCrit = true, BaseIncrease = true },
			[1] = { 162, 186, 8, 9, spellLevel = 20, },
			[2] = { 247, 281, 10, 11, spellLevel = 28, },
			[3] = { 337, 381, 12, 13, spellLevel = 36, },
			[4] = { 458, 514, 15, 15, spellLevel = 44, },
			[5] = { 631, 705, 18, 18, spellLevel = 52, },
			[6] = { 832, 928, 21, 21, spellLevel = 60, },
			[7] = { 1039, 1185, 16, 17, spellLevel = 66, Downrank = 4 },
			[8] = { 1382, 1578, 20, 20, spellLevel = 72, Downrank = 4 },
			[9] = { 1606, 1834, 18, 18, spellLevel = 77, },
		},
		[GetSpellInfo(331)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Healing Wave",
			[0] = { School = { "Nature", "Healing", }, canCrit = true, castTime = 3, BaseIncrease = true },
			[1] = { 34, 44, 2, 3, castTime = 1.5, spellLevel = 1, },
			[2] = { 64, 78, 5, 5, castTime = 2, spellLevel = 6, },
			[3] = { 129, 155, 7, 8, castTime = 2.5, spellLevel = 12, },
			[4] = { 268, 316, 11, 12, spellLevel = 18, },
			[5] = { 376, 440, 13, 14, spellLevel = 24, },
			[6] = { 536, 622, 16, 17, spellLevel = 32, },
			[7] = { 740, 854, 19, 20, spellLevel = 40, },
			[8] = { 1017, 1167, 23, 24, spellLevel = 48, },
			[9] = { 1367, 1561, 27, 28, spellLevel = 56, },
			[10] = { 1620, 1850, 27, 28, spellLevel = 60, },
			[11] = { 1725, 1969, 31, 32, spellLevel = 63, },
			[12] = { 2134, 2436, 28, 29, spellLevel = 70, Downrank = 4 },
			[13] = { 2624, 2996, 32, 32, spellLevel = 75, Downrank = 4 },
			[14] = { 3034, 3466, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(1064)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Chain Heal",
			[0] = { School = { "Nature", "Healing", }, canCrit = true, castTime = 2.5, chainFactor = 0.6, AoE = 3, BaseIncrease = true },
			[1] = { 320, 368, 12, 13, spellLevel = 40, },
			[2] = { 405, 465, 14, 14, spellLevel = 46, },
			[3] = { 551, 629, 16, 17, spellLevel = 54, },
			[4] = { 605, 691, 19, 19, spellLevel = 61, },
			[5] = { 826, 942, 19, 19, spellLevel = 68, },
			[6] = { 906, 1034, 19, 19, spellLevel = 74, },
			[7] = { 1055, 1205, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(5394)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK (NONE)
			["Name"] = "Healing Stream Totem",
			[0] = { School = { "Nature", "Healing", }, SPBonus = 6.6 * 1.88, eDot = true, eDuration = 300, sHits = 150, AoE = 5, NoPeriod = true, NoDownrank = true },
			[1] = { 6, 6, spellLevel = 20, },
			[2] = { 8, 8, spellLevel = 30, },
			[3] = { 10, 10, spellLevel = 40, },
			[4] = { 12, 12, spellLevel = 50, },
			[5] = { 14, 14, spellLevel = 60, },
			[6] = { 18, 18, spellLevel = 69, },
			[7] = { 20, 20, spellLevel = 71, },
			[8] = { 23, 23, spellLevel = 76, },
			[9] = { 25, 25, spellLevel = 80, },
		},
		[GetSpellInfo(974)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Earth Shield",
			[0] = { School = { "Nature", "Healing", }, canCrit = true, sHits = 6, SPBonus = 3.228, NoDPS = true, NoDoom = true, NoPeriod = true, Downrank = 9 },
			[1] = { 150, 150, spellLevel = 50, },
			[2] = { 205, 205, spellLevel = 60, },
			[3] = { 270, 270, spellLevel = 70, Downrank = 4 },
			[4] = { 300, 300, spellLevel = 75, Downrank = 4 },
			[5] = { 337, 337, spellLevel = 80, },
		},
		[GetSpellInfo(61295)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
			["Name"] = "Riptide",
			[0] = { School = { "Nature", "Healing", }, SPBonus = 1.5/7 * 1.88, dotFactor = 0.5 * 1.88, canCrit = true, Cooldown = 6, eDuration = 15, sTicks = 3 },
			[1] = { 639, 691, hybridDotDmg = 665, spellLevel = 60, Downrank = 9 },
			[2] = { 849, 919, hybridDotDmg = 885, spellLevel = 70, Downrank = 4 },
			[3] = { 1378, 1492, hybridDotDmg = 1435, spellLevel = 75, Downrank = 4 },
			[4] = { 1604, 1736, hybridDotDmg = 1670, spellLevel = 80, },
		},
		[GetSpellInfo(17364)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK
			["Name"] = "Stormstrike",
			[0] = { Melee = true, Cooldown = 8, DualAttack = true, WeaponDamage = 1, NoNormalization = true },
			[1] = { 0 },
		},
		[GetSpellInfo(60103)] = {
			--DONE: BASE OK, INCREASE OK, COEFFICIENT OK
			["Name"] = "Lava Lash",
			[0] = { School = "Fire", Melee = true, Cooldown = 6, OffhandAttack = true, WeaponDamage = 1, NoNormalization = true },
			[1] = { 0 },
		},
	}
	self.talentInfo = {
	--ELEMENTAL:
		--Concussion (additive - 3.3.3)
		[GetSpellInfo(16035)] = { 	[1] = { Effect = 0.01, Caster = true, Spells = { "Nuke", "Shock" }, }, },
		--Call of Flame (additive with Improved Fire Nova and Concussion - 3.3.3)
		[GetSpellInfo(16038)] = { 	[1] = { Effect = 0.05, Caster = true, Spells = "OffensiveTotem" },
									[2] = { Effect = 0.02, Caster = true, Spells = "Lava Burst" }, },
		--Reverberation
		[GetSpellInfo(16040)] = { 	[1] = { Effect = -0.2, Caster = true, Spells = "Shock", ModType = "cooldown" }, },
		--Elemental Fury
		[GetSpellInfo(16089)] = { 	[1] = { Effect = 0.1, Caster = true, Spells = { "Nuke", "Shock", "OffensiveTotem" }, ModType= "critM", },
									[2] = { Effect = 0.1, Melee = true, Spells = "Attack", ModType = "Elemental Fury" }, },
		--Improved Fire Nova (additive - 3.3.3)
		[GetSpellInfo(16086)] = {	[1] = { Effect = 0.1, Caster = true, Spells = "Fire Nova", },
									[2] = { Effect = -2, Caster = true, Spells = "Fire Nova", ModType = "cooldown" }, },
		--Call of Thunder
		[GetSpellInfo(16041)] = { 	[1] = { Effect = 5, Caster = true, Spells = { "Lightning Bolt", "Chain Lightning", "Thunderstorm" }, ModType = "critPerc", }, },
		--Elemental Precision
		[GetSpellInfo(30672)] = { 	[1] = { Effect = 1, Caster = true, Spells = { "Lightning Shield", "Nuke", "Shock", "OffensiveTotem", }, ModType = "hitPerc", },
									[2] = { Effect = 1, Melee = true, Spells = "Attack", ModType = "spellHit" }, },
		--Storm, Earth and Fire (additive - 3.3.3)
		[GetSpellInfo(51483)] = { 	[1] = { Effect = { -0.75, -1.5, -2.5 }, Caster = true, Spells = "Chain Lightning", ModType = "cooldown", },
                                    [2] = { Effect = 0.2, Caster = true, Spells = "Flame Shock", ModType = "dmgM_dot_Add" }, },
		--Elemental Oath
		[GetSpellInfo(51466)] = { 	[1] = { Effect = 0.05, Caster = true, Spells = "All", ModType = "Elemental Oath" }, },
		--Booming Echoes (additive - 3.3.3)
		[GetSpellInfo(63370)] = {	[1] = { Effect = -1, Caster = true, Spells = { "Flame Shock", "Frost Shock" }, ModType = "cooldown" },
									[2] = { Effect = 0.1, Caster = true, Spells = { "Flame Shock", "Frost Shock" }, ModType = "dmgM_dd_Add" }, },
		--Lightning Overload
		[GetSpellInfo(30675)] = {	[1] = { Effect = { (1/9) * 0.5, (1/6) * 0.5, (1/3) * 0.5 }, Caster = true, Spells = { "Lightning Bolt", "Chain Lightning" }, ModType = "finalMod_M" }, },
		--Lava Flows
		[GetSpellInfo(51480)] = { 	[1] = { Effect = { 0.03, 0.06, 0.12 }, Caster = true, Spells = "Lava Burst", ModType = "critM", }, },
		--Shamanism (additive - 3.3.3)
		[GetSpellInfo(62097)] = {	[1] = { Effect = 0.04, Caster = true, Spells = { "Lightning Bolt", "Chain Lightning" }, ModType = "SpellDamage" },
									[2] = { Effect = 0.05, Caster = true, Spells = "Lava Burst", ModType = "SpellDamage" }, },
	--RESTORATION:
		--Restorative Totems (additive - 3.3.3)
		[GetSpellInfo(16187)] = { 	[1] = { Effect = 0.15, Caster = true, Spells = "Healing Stream Totem", }, },
		--Healing Way (A/M)
		[GetSpellInfo(29206)] = { 	[1] = { Effect = { 0.08, 0.16, 0.25 }, Caster = true, Spells = "Healing Wave", }, },
		--Tidal Mastery
		[GetSpellInfo(16194)] = { 	[1] = { Effect = 1, Caster = true, Spells = { "Healing", "Lightning Bolt", "Chain Lightning", "Thunderstorm" }, ModType = "critPerc", }, },
		--Purification (multiplicative - 3.3.3)
		[GetSpellInfo(16178)] = { 	[1] = { Effect = 0.02, Caster = true, Multiply = true, Spells = { "Healing", "Lifeblood" }, },
									[2] = { Effect = 0.02, Caster = true, Spells = "Healing", ModType = "Purification" }, },
		--Blessing of the Eternals
		[GetSpellInfo(51554)] = { 	[1] = { Effect = 0.4, Caster = true, Spells = "Healing", ModType = "Blessing of the Eternals" }, },
		--Improved Chain Heal (multiplicative - 3.3.3)
		[GetSpellInfo(30872)] = { 	[1] = { Effect = 0.1, Caster = true, Multiply = true, Spells = "Chain Heal", }, },
		--Improved Earth Shield (additive - 3.3.3)
		[GetSpellInfo(51560)] = {	[1] = { Effect = 1, Caster = true, Spells = "Earth Shield", ModType = "sHits" },
									[2] = { Effect = 0.05, Caster = true, Spells = "Earth Shield", }, },
		--Tidal Waves (additive - 3.3.3)
		[GetSpellInfo(51562)] = {	[1] = { Effect = 0.04, Caster = true, Spells = "Healing Wave", ModType = "SpellDamage" },
									[2] = { Effect = 0.02, Caster = true, Spells = "Lesser Healing Wave", ModType = "SpellDamage" }, },
	--ENHANCEMENT:
		--Improved Shields (additive - 3.3.3)
		[GetSpellInfo(16261)] = { 	[1] = { Effect = 0.05, Caster = true, Spells = { "Lightning Shield", "Earth Shield" }, }, },
		--Elemental Weapons
		[GetSpellInfo(16266)] = {	[1] = { Effect = { 0.13, 0.27, 0.4 }, Melee = true, Spells = "Attack", ModType = "Elemental Weapons" }, },
		--Weapon Mastery
		[GetSpellInfo(29082)] = {	[1] = { Effect = { 0.04, 0.07, 0.1 }, Melee = true, Spells = "All", ModType = "Weapon Mastery" }, },
		--Frozen Power (multiplicative - 3.3.3)
		[GetSpellInfo(63373)] = {	[1] = { Effect = 0.05, Spells = { "Chain Lightning", "Lightning Bolt", "Shock", "Lava Lash" }, ModType = "Frozen Power" }, },
		--Dual Wield Specialization
		[GetSpellInfo(30816)] = {	[1] = { Effect = 2, Melee = true,  Spells = "Attack", ModType = "Dual Wield Specialization" }, },
		--Static Shock
		[GetSpellInfo(51525)] = { 	[1] = { Effect = 2, Caster = true, Spells = "Lightning Shield", ModType = "sHits" }, },
	}
end