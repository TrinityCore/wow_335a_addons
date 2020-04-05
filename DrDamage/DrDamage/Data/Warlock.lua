if select(2, UnitClass("player")) ~= "WARLOCK" then return end
local GetSpellInfo = GetSpellInfo
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local UnitExists = UnitExists
local UnitIsFriend = UnitIsFriend
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitIsUnit = UnitIsUnit
local math_min = math.min
local select = select
local GetPetSpellBonusDamage = GetPetSpellBonusDamage
local GetSpellCritChanceFromIntellect = GetSpellCritChanceFromIntellect

function DrDamage:PlayerData()
	--Health updates
	self.PlayerHealth = { [1] = 0.201, [0.201] = GetSpellInfo(689) }
	self.TargetHealth = { [1] = 0.351, [2] = 0.251, [0.251] = GetSpellInfo(1120) }
	--General
	local firestones = { [GetSpellInfo(54721)] = true, [GetSpellInfo(55152)] = true, [GetSpellInfo(55153)] = true, [GetSpellInfo(55154)] = true, [GetSpellInfo(55155)] = true, [GetSpellInfo(55156)] = true, [GetSpellInfo(55158)] = true }
	local spellstones = { [GetSpellInfo(55171)] = true, [GetSpellInfo(55175)] = true, [GetSpellInfo(55178)] = true, [GetSpellInfo(55188)] = true, [GetSpellInfo(55190)] = true, [GetSpellInfo(55194)] = true }
	--Drain Mana
	self.ClassSpecials[GetSpellInfo(5138)] = function()
		local value = not UnitIsFriend("player","target") and math_min(UnitPower("target",0), math_min(0.30 * UnitPowerMax("player",0), 0.15 * UnitPowerMax("target",0)))
		if value and value > 0 then
			return value, false, true
		else
			return "", false, true
		end
	end
--GENERAL
	self.Calculation["WARLOCK"] = function( calculation, ActiveAuras, Talents, spell, baseSpell )
		if calculation.group ~= "Pet" then
			if Talents["Death's Embrace"] then
				if UnitHealth("target") ~=0 and (UnitHealth("target") / UnitHealthMax("target")) <= 0.35 then
					calculation.dmgM = calculation.dmgM * ( 1 + 0.04 * Talents["Death's Embrace"] )
				end
			end
			if ActiveAuras["Metamorphosis"] == 0 then
				calculation.dmgM = calculation.dmgM * 1.2
			end		
			local buff = self:GetWeaponBuff()
			if buff then
				if spellstones[buff] then
					if baseSpell.Drain then
						calculation.dmgM_Add = calculation.dmgM_Add + 0.01
					elseif (calculation.spellName ~= "Seed of Corruption") and (calculation.spellName ~= "Curse of Doom") and (calculation.spellName ~= "Conflagrate") then
						calculation.dmgM_dot_Add = calculation.dmgM_dot_Add + 0.01
					end
					--	calculation.dmgM_dot = calculation.dmgM_dot * 1.01 - 0.01 * (Talents["Shadow Mastery"] or 0) - 0.01 * (Talents["Emberstorm"] or 0)
				end
				if not baseSpell.eDot and firestones[buff] then
					if calculation.spellName == "Immolate" then
						calculation.dmgM_dd_Add = calculation.dmgM_dd_Add + 0.01
					elseif calculation.hybridDotDmg then
						calculation.dmgM_dd = calculation.dmgM_dd * 1.01 - 0.01 * (Talents["Shadow Mastery"] or 0) - 0.01 * (Talents["Emberstorm"] or 0)
					else
						calculation.dmgM = calculation.dmgM * 1.01 - 0.01 * (Talents["Shadow Mastery"] or 0) - 0.01 * (Talents["Emberstorm"] or 0)
					end
				end
			end
		--else
		--	if ActiveAuras["Metamorphosis"] and ActiveAuras["Metamorphosis"] > 0 then
		--		calculation.dmgM = calculation.dmgM / 1.2
		--	end
		end
	end
--TALENTS
	self.Calculation["Pandemic"] = function( calculation )
		calculation.canCrit = true
		calculation.critM = calculation.critM + 0.5
	end
--ABILITIES
	self.Calculation["Drain Life"] = function( calculation, ActiveAuras, Talents )
		if ActiveAuras["Soul Siphon"] and Talents["Soul Siphon"] then
			calculation.dmgM = calculation.dmgM * (1 + math_min(4, ActiveAuras["Soul Siphon"]) * Talents["Soul Siphon"] * 0.03)
		end
		if Talents["Death's Embrace"] then
			if (UnitHealth("player") / UnitHealthMax("player")) <= 0.2 then
				calculation.dmgM = calculation.dmgM * ( 1 + 0.1 * Talents["Death's Embrace"] )
			end
		end
	end
	self.Calculation["Drain Soul"] = function ( calculation, ActiveAuras, Talents, spell )
		if ActiveAuras["Soul Siphon"] and Talents["Soul Siphon"] then
			calculation.dmgM = calculation.dmgM * (1 + math_min(4, ActiveAuras["Soul Siphon"]) * Talents["Soul Siphon"] * 0.03)
		end
		if UnitHealth("target") ~= 0 and (UnitHealth("target") / UnitHealthMax("target")) <= 0.25 then
			calculation.minDam = calculation.minDam * 4
			calculation.maxDam = calculation.maxDam * 4
		end
	end
	self.Calculation["Incinerate"] = function( calculation, ActiveAuras, Talents, spell )
		--Glyph of Incinerate (additive - 3.3.3)
		if self:HasGlyph(56242) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.05
		end
		if ActiveAuras["Immolate"] then
			calculation.minDam = 1.25 * calculation.minDam
			calculation.maxDam = 1.25 * calculation.maxDam
			calculation.dmgM = calculation.dmgM * (1 + (Talents["Fire and Brimstone"] or 0))
		end
		if ActiveAuras["Molten Core"] and Talents["Molten Core"] then
			calculation.dmgM = calculation.dmgM * (1 + 0.06 * Talents["Molten Core"])
		end
		if self:GetSetAmount( "T8" ) >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
		if self:GetSetAmount( "T10" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Soul Fire"] = function( calculation, ActiveAuras, Talents, spell )
		if ActiveAuras["Molten Core"] and Talents["Molten Core"] then
			calculation.dmgM = calculation.dmgM * (1 + 0.06 * Talents["Molten Core"])
			calculation.critPerc = calculation.critPerc + 5 * Talents["Molten Core"]
		end
	end
	self.Calculation["Chaos Bolt"] = function( calculation, ActiveAuras, Talents )
		if ActiveAuras["Immolate"] and Talents["Fire and Brimstone"] then
			calculation.dmgM = calculation.dmgM * (1 + Talents["Fire and Brimstone"])
		end
		--Glyph of Chaos Bolt
		if self:HasGlyph(63304) then
			calculation.cooldown = calculation.cooldown - 2
		end
	end
	self.Calculation["Life Tap"] = function ( calculation, _, _, spell )
		--calculation.minDam = calculation.minDam + spell.spiritFactor * calculation.spirit
		--calculation.maxDam = calculation.maxDam + spell.spiritFactor * calculation.spirit
	end
	self.Calculation["Immolate"] = function( calculation )
		calculation.hybridCanCrit = true
		--Glyph of Immolate (additive - 3.3.3)
		if self:HasGlyph(56228) then
			calculation.dmgM_dot_Add = calculation.dmgM_dot_Add + 0.1
		end
		if self:GetSetAmount( "T8" ) >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
		if self:GetSetAmount( "T9" ) >= 4 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
	end
	self.Calculation["Curse of Agony"] = function( calculation )
		--Glyph of Curse of Agony
		if self:HasGlyph(56241) then
			calculation.eDuration = calculation.eDuration + 4
			--Total damage goes from 100% -> 133.2%. 28/24 increase is handled in the core, but the glyph gives high-end ticks so it gain more base damage.
			calculation.bDmgM = calculation.bDmgM * (133.2/(100*(28/24)))
		end
	end
	self.Calculation["Searing Pain"] = function( calculation )
		--Glyph of Searing Pain
		if self:HasGlyph(56226) then
			calculation.critM = calculation.critM + 0.1
		end
	end
	self.Calculation["Shadowburn"] = function( calculation )
		--Glyph of Shadowburn
		if self:HasGlyph(56229) then
			if UnitHealth("target") ~=0 and (UnitHealth("target") / UnitHealthMax("target")) <= 0.35 then
				calculation.critPerc = calculation.critPerc + 20
			end
		end		
	end
	self.Calculation["Corruption"] = function( calculation )
		--Glyph of Siphon Life
		if self:HasGlyph(56216) then
			calculation.leechBonus = calculation.leechBonus * 1.25
		end
		--Glyph of Quick Decay
		if self:HasGlyph(70947) then
			calculation.customHaste = true
		end
		if self:GetSetAmount( "T9" ) >= 4 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
		if self:GetSetAmount( "T10" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	local Conflagrate = GetSpellInfo(17962)
	local Immolate = GetSpellInfo(348)
	local Shadowflame = GetSpellInfo(47897)
	self.Calculation["Conflagrate"] = function( calculation, ActiveAuras, Talents, spell )
		calculation.hybridCanCrit = true
		calculation.eDuration = 6
		calculation.sTicks = 2

		if ActiveAuras["Immolate"] or not ActiveAuras["Shadowflame"] then
			if self:GetSetAmount( "T8" ) >= 2 then
				--Set bonus stacks additively with firestone
				calculation.dmgM_dd_Add = calculation.dmgM_dd_Add + 0.14 - (calculation.dmgM_dd - 1) * 0.14
			end
			if self:GetSetAmount( "T9" ) >= 4 then
				--Additive - 3.3.3. Works as expected with firestone (multiplicative).
				calculation.dmgM_Add = calculation.dmgM_Add + 0.1
			end
			--Glyph of Immolate (additive - 3.3.3)
			if self:HasGlyph(56228) then
				calculation.dmgM_Add = calculation.dmgM_Add + 0.1
			end
			--Check max rank if not active
			local rank = ActiveAuras["Immolate"]
			if not rank then
				local level = calculation.playerLevel
				for i = 11, 1, -1 do
					if level >= self.spellInfo[Immolate][i].spellLevel then
						rank = i
						break
					end
				end
			end
			--Spellstone doesn't apply to dd or dot part of Conflagrate
			calculation.dmgM_Add = calculation.dmgM_Add + (Talents["Aftermath"] or 0) + (Talents["Improved Immolate"] or 0)
			calculation.spellDmgM = 0.6
			calculation.spellDmgM_dot = 0.4
			calculation.minDam = 0.6 * self.spellInfo[Immolate][rank].hybridDotDmg
			calculation.maxDam = calculation.minDam
			calculation.hybridDotDmg = 0.4 * self.spellInfo[Immolate][rank].hybridDotDmg
			calculation.tooltipName = Conflagrate
			calculation.tooltipName2 = Immolate
		elseif ActiveAuras["Shadowflame"] then
			--This applies also to shadowflame conflagrate for some reason. T9 with a similar bonus doesn't apply.
			if self:GetSetAmount( "T8" ) >= 2 then
				--Set bonus stacks additively with firestone
				calculation.dmgM_dd_Add = calculation.dmgM_dd_Add + 0.10 - (calculation.dmgM_dd - 1) * 0.10
			end
			calculation.spellDmgM = 0.6 * 8/30
			calculation.spellDmgM_dot = 0.4 * 8/30
			calculation.minDam = 0.6 * self.spellInfo[Shadowflame]["Secondary"][(ActiveAuras["Shadowflame"])].hybridDotDmg
			calculation.maxDam = calculation.minDam
			calculation.hybridDotDmg = 0.4 * self.spellInfo[Shadowflame]["Secondary"][(ActiveAuras["Shadowflame"])].hybridDotDmg
			calculation.tooltipName = Conflagrate
			calculation.tooltipName2 = Shadowflame
		end
	end
	self.Calculation["Unstable Affliction"] = function( calculation )
		if self:GetSetAmount( "T8" ) >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
		if self:GetSetAmount( "T9" ) >= 4 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
	end
	self.Calculation["Shadow Bolt"] = function( calculation )
		if self:GetSetAmount( "T8" ) >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
		if self:GetSetAmount( "T10" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Soul Fire"] = function( calculation )
		if self:GetSetAmount( "T10" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Immolation Aura"] = function( calculation, ActiveAuras )
		if not ActiveAuras["Metamorphosis"] then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Shadow Cleave"] = function( calculation, ActiveAuras )
		if not ActiveAuras["Metamorphosis"] then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	local DE = GetSpellInfo(47193)
	self.Calculation["Firebolt"] = function( calculation, ActiveAuras, Talents, spell )
		--Benefits from Master Demonologist. Doesn't benefit from Emberstorm, Malediction or self-buff part of Demonic Pact.
		--PTR:
		calculation.spellDmg = GetPetSpellBonusDamage and GetPetSpellBonusDamage() or calculation.spellDmg * 0.15
		calculation.critPerc = GetSpellCritChanceFromIntellect("pet") + calculation.spellCrit + (Talents["Demonic Tactics"] or 0) + (calculation.critPerc * (Talents["Improved Demonic Tactics"] or 0))
		--calculation.manaRegen = GetUnitManaRegenRateFromSpirit("pet")
		--calculation.playerMana = UnitPower("pet",0)
		calculation.castTime = 2.5 - (Talents["Demonic Power"] or 0)
		calculation.haste = 1
		local UP = Talents["Unholy Power"] or 0
		local EI = Talents["Empowered Imp"] or 0
		local glyph = self:HasGlyph(56248) and 0.2 or 0
		calculation.dmgM = calculation.dmgM * (1 + UP) * (1 + EI + glyph)
		calculation.minDam = calculation.minDam - (UP + EI + glyph) * spell[3]
		calculation.maxDam = calculation.maxDam - (UP + EI + glyph) * spell[4]
		if self:GetSetAmount( "T9" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 10
		end
		if UnitBuff("pet",DE) then
			calculation.critPerc = calculation.critPerc + 20
		end
		if ActiveAuras["Master Demonologist"] then
			calculation.critPerc = calculation.critPerc + (100 * (Talents["Master Demonologist"] or 0))
		end
	end
	local shadowbite = {
		--Immolate, Corruption, Curse of Agony
		[GetSpellInfo(348)] = true, [GetSpellInfo(172)] = true, [GetSpellInfo(980)] = true, 
		--Unstable Affliction, Curse of Doom, Drain Soul
		[GetSpellInfo(30108)] = true, [GetSpellInfo(603)] = true, [GetSpellInfo(1120)] = true,
		--Drain Life, Seed of Corruption, 
		[GetSpellInfo(689)] = true, [GetSpellInfo(47836)] = true,
		--Also benefits from: Shadowflame
		--Doesn't benefit from: Hellfire, Rain of Fire
	}
	self.Calculation["Shadow Bite"] = function( calculation, ActiveAuras, Talents, spell )
		--Doesn't benefit from Malediction, Death's Embrace, Shadow Embrace or Haunt.
		--PTR:
		calculation.spellDmg = GetPetSpellBonusDamage and GetPetSpellBonusDamage() or calculation.spellDmg * 0.15
		calculation.critPerc = GetSpellCritChanceFromIntellect("pet") + calculation.spellCrit + (Talents["Demonic Tactics"] or 0) + (calculation.critPerc * (Talents["Improved Demonic Tactics"] or 0))
		calculation.castTime = 1.5
		calculation.haste = 1
		local UP = Talents["Unholy Power"] or 0
		calculation.dmgM = calculation.dmgM * (1 + UP)
		calculation.minDam = calculation.minDam - UP * spell[3]
		calculation.maxDam = calculation.maxDam - UP * spell[4]
		if self:GetSetAmount( "T9" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 10
		end
		if UnitExists("pettarget") then
			local dots = 0
			for i = 1, 40 do
				local name, _, _, _, _, _, _, caster = UnitDebuff("pettarget",i)
				if name then
					if shadowbite[name] and caster and UnitIsUnit("player", caster) then
						dots = dots + 1
					end
				else break end
			end
			calculation.dmgM = calculation.dmgM * (1 + dots * 0.15)
		end
	end
	self.Calculation["Lash of Pain"] = function( calculation, ActiveAuras, Talents, spell )
		--Benefits from Master Demonologist. Doesn't benefit from Shadow Mastery, Malediction, Death's Embrace, Haunt.
		--PTR:
		calculation.spellDmg = GetPetSpellBonusDamage and GetPetSpellBonusDamage() or calculation.spellDmg * 0.15
		calculation.critPerc = GetSpellCritChanceFromIntellect("pet") + calculation.spellCrit + (Talents["Demonic Tactics"] or 0) + (calculation.critPerc * (Talents["Improved Demonic Tactics"] or 0))
		calculation.castTime = 1.5
		calculation.haste = 1
		local UP = Talents["Unholy Power"] or 0
		calculation.dmgM = calculation.dmgM * (1 + UP)
		calculation.minDam = calculation.minDam - UP * spell[3]
		calculation.maxDam = calculation.maxDam - UP * spell[4]
		if self:GetSetAmount( "T9" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 10
		end
		if ActiveAuras["Master Demonologist"] then
			calculation.critPerc = calculation.critPerc + (100 * (Talents["Master Demonologist"] or 0))
		end
	end		
--SETS
	self.SetBonuses["T8"] = { 46135, 46136, 46137, 46139, 46140, 45417, 45419, 45420, 45421, 45422 }
	self.SetBonuses["T9"] = { 47798, 47799, 47800, 47801, 47802, 47783, 47784, 47785, 47786, 47787, 47782, 47778, 47780, 47779, 47781, 47788, 47789, 47790, 47791, 47792, 47803, 47804, 47805, 47806, 47807, 47797, 47796, 47795, 47794, 47793 }
	self.SetBonuses["T10"] = { 50240, 50241, 50242, 50243, 50244, 51230, 51231, 51232, 51233, 51234, 51205, 51206, 51207, 51208, 51209, }
--AURA
--Player
	--Pyroclasm
	self.PlayerAura[GetSpellInfo(63245)] = { School = { ["Fire"] = true, ["Shadow"] = true }, Not = "Pet", Ranks = 3, Value = 0.02, ID = 63245 }
	--Demonic Soul (T7 proc)
	self.PlayerAura[GetSpellInfo(61595)] = { Spells = { 686, 29722 }, ModType = "critPerc", Value = 10, NoManual = true }
	--Eradication
	self.PlayerAura[GetSpellInfo(47195)] = { Update = true }
	--Decimation
	self.PlayerAura[GetSpellInfo(63156)] = { Update = true }
	--Molten Core
	self.PlayerAura[GetSpellInfo(47383)] = { Spells = { 29722, 6353 }, ActiveAura = "Molten Core", ID = 47383 }
	--Empowered Imp
	self.PlayerAura[GetSpellInfo(47283)] = { ModType = "critPerc", Value = 100, ID = 47283 }
	--Metamorphosis
	self.PlayerAura[GetSpellInfo(59672)] = { ActiveAura = "Metamorphosis", Index = true, ID = 59672 }
--Target
	--Immolate
	self.TargetAura[GetSpellInfo(348)] = { ActiveAura = "Immolate", Ranks = 11, Spells = { 29722, 17962, 50796 }, SelfCast = true, ID = 348 }
	--Shadowflame
	self.TargetAura[GetSpellInfo(61290)] = { ActiveAura = "Shadowflame", Ranks = 2, Spells = 17962, SelfCast = true, ID = 61290 }
--Soul Siphon
	--Corruption
	self.TargetAura[GetSpellInfo(172)] = 	{ ActiveAura = "Soul Siphon", Spells = { 689, 1120 }, SelfCast = true, NoManual = true }
	--Curse of Agony
	self.TargetAura[GetSpellInfo(980)] = 	self.TargetAura[GetSpellInfo(172)]
	--Curse of Doom
	self.TargetAura[GetSpellInfo(603)] = 	self.TargetAura[GetSpellInfo(172)]
	--Curse of Weakness
	self.TargetAura[GetSpellInfo(702)] = 	self.TargetAura[GetSpellInfo(172)]
	--Curse of Tongues
	self.TargetAura[GetSpellInfo(1714)] = 	self.TargetAura[GetSpellInfo(172)]
	--Curse of Exhaustion
	self.TargetAura[GetSpellInfo(18223)] = 	self.TargetAura[GetSpellInfo(172)]
	--Unstable Affliction
	self.TargetAura[GetSpellInfo(30108)] = 	self.TargetAura[GetSpellInfo(172)]
	--Seed of Corruption
	self.TargetAura[GetSpellInfo(27243)] = 	self.TargetAura[GetSpellInfo(172)]
	--Fear
	self.TargetAura[GetSpellInfo(5782)] = 	self.TargetAura[GetSpellInfo(172)]
	--Howl of Terror
	self.TargetAura[GetSpellInfo(5484)] = 	self.TargetAura[GetSpellInfo(172)]
--Custom
	--Curse of the Elements (debuff added in Aura.lua)
	self.TargetAura[GetSpellInfo(1490)].ActiveAura = "Soul Siphon"
	--Demon Armor
	self.PlayerAura[GetSpellInfo(706)] = { School = "Leech", ID = 706, ModType =
		function( calculation, _, Talents )
				calculation.leechBonus = (calculation.leechBonus or 0) * (1.2 + (Talents["Demonic Aegis"] or 0))
		end
	}
	--Master Demonologist
	local imp = GetSpellInfo(3110)
	local succubus = GetSpellInfo(7814)
	self.PlayerAura[GetSpellInfo(23785)] = { School = { ["Fire"] = true, ["Shadow"] = true }, ActiveAura = "Master Demonologist", NoManual = true, ModType =
		function ( calculation, _, Talents )
			if calculation.school == "Fire" and GetSpellInfo(imp) or calculation.school == "Shadow" and GetSpellInfo(succubus) then
				calculation.dmgM = calculation.dmgM * (1 + (Talents["Master Demonologist"] or 0))
			end
		end
	}
	--Backdraft
	self.PlayerAura[GetSpellInfo(47258)] = { NoManual = true, ModType =
		function( calculation, _, Talents )
			if Talents["Backdraft"] then
				calculation.haste = calculation.haste * (1 + Talents["Backdraft"])
			end
		end
	}
	--Haunt
	self.TargetAura[GetSpellInfo(48181)] = { School = "Shadow", SelfCast = true, ID = 48181, Not = { "Pet", "Curse of Doom" },  ModType =
		function( calculation, ActiveAuras, Talents )
			--Glyph of Haunt
			if calculation.spellName == "Drain Life" or calculation.spellName == "Drain Soul" then
				calculation.dmgM = calculation.dmgM * (1.2 + (self:HasGlyph(63302) and 0.03 or 0))
			else
				calculation.dmgM_dot = calculation.dmgM_dot * (1.2 + (self:HasGlyph(63302) and 0.03 or 0))
			end
			if Talents["Soul Siphon"] then
				ActiveAuras["Soul Siphon"] = (ActiveAuras["Soul Siphon"] or 0) + 1
			end
		end
	}
	--Shadow Embrace
	self.TargetAura[GetSpellInfo(32386)] = { School = "Shadow", SelfCast = true, ID = 32386, Apps = 3, Not = { "Pet", "Curse of Doom" }, ModType =
		function( calculation, ActiveAuras, Talents, _, apps )
			if Talents["Shadow Embrace"] then
				if calculation.spellName == "Drain Life" or calculation.spellName == "Drain Soul" then
					calculation.dmgM = calculation.dmgM * (1 + Talents["Shadow Embrace"] * apps)
				else
					calculation.dmgM_dot = calculation.dmgM_dot * (1 + Talents["Shadow Embrace"] * apps)
				end
			end
			if Talents["Soul Siphon"] then
				ActiveAuras["Soul Siphon"] = (ActiveAuras["Soul Siphon"] or 0) + 1
			end
		end
	}

	self.spellInfo = {
		[GetSpellInfo(172)] = {	--DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Corruption",
					[0] = { School = { "Shadow", "Affliction", }, SPBonus = 1.2, castTime = 2, eDot = true, eDuration = 18, sTicks = 3, Downrank = 5 },
					[1] = { 40, 40, spellLevel = 4, eDuration = 12, },
					[2] = { 90, 90, spellLevel = 14, eDuration = 15, },
					[3] = { 222, 222, spellLevel = 24, },
					[4] = { 324, 324, spellLevel = 34, },
					[5] = { 486, 486, spellLevel = 44, },
					[6] = { 666, 666, spellLevel = 54, },
					[7] = { 822, 822, spellLevel = 60, },
					[8] = { 900, 900, spellLevel = 65, },
					[9] = { 984, 984, spellLevel = 71, },
					[10] = { 1080, 1080, spellLevel = 77, },
		},
		[GetSpellInfo(686)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Shadow Bolt",
					[0] = { School = { "Shadow", "Destruction" }, castTime = 3, canCrit = true, BaseIncrease = true, Downrank = 5 },
					[1] = { 12, 16, 1, 2, castTime = 1.7, spellLevel = 1, },
					[2] = { 23, 29, 3, 3, castTime = 2.2, spellLevel = 6, },
					[3] = { 48, 56, 4, 5, castTime = 2.8, spellLevel = 12, },
					[4] = { 86, 98, 6, 6, spellLevel = 20, },
					[5] = { 142, 162, 8, 8, spellLevel = 28, },
					[6] = { 204, 230, 9, 10, spellLevel = 36, },
					[7] = { 281, 315, 11, 12, spellLevel = 44, },
					[8] = { 360, 402, 13, 13, spellLevel = 52, },
					[9] = { 455, 507, 15, 15, spellLevel = 60, },
					[10] = { 482, 538, 15, 16, spellLevel = 60, },
					[11] = { 541, 603, 17, 17, spellLevel = 69, },
					[12] = { 596, 664, 19, 19, spellLevel = 74, },
					[13] = { 690, 770, 4, 5, spellLevel = 79, },
		},
		[GetSpellInfo(1454)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Life Tap",
					[0] = { School = { "Shadow", "Utility", }, SPBonus = 0.5, BaseIncrease = 10, NoGlobalMod = true, NoTargetAura = true, NoSchoolTalents = true, NoDPS = true, NoTooltip = true, Unresistable = true, NoDownrank = true, NoLowLevelPenalty = true },
					[1] = { 0, 0, 10, 10, spellLevel = 6, spiritFactor = 1.0, },
					[2] = { 6, 6, 10, 10, spellLevel = 16, spiritFactor = 1.5, },
					[3] = { 24, 24, 10, 10, spellLevel = 26, spiritFactor = 2.0, },
					[4] = { 37, 37, 10, 10, spellLevel = 36, spiritFactor = 2.5, },
					[5] = { 42, 42, 10, 10, spellLevel = 46, spiritFactor = 3.0, },
					[6] = { 500, 500, 10, 10, spellLevel = 56, spiritFactor = 3.0, },
					[7] = { 710, 710, 10, 10, spellLevel = 68, spiritFactor = 3.0, },
					[8] = { 1490, 1490, 0, 0, spellLevel = 80, spiritFactor = 3.0, },
		},
		[GetSpellInfo(6229)] = { --DONE: Base OK, Increase OK, Coefficient OK, Downrank OK
					["Name"] = "Shadow Ward",
					[0] = { School = { "Shadow", "Absorb" }, SPBonus = 0.806, NoGlobalMod = true, NoTargetAura = true, NoSchoolTalents = true, NoDPS = true, NoNext = true, NoDPM = true, NoDoom = true, Unresistable = true, },
					[1] = { 290, 290, spellLevel = 32, Downrank = 9 },
					[2] = { 470, 470, spellLevel = 42, Downrank = 9 },
					[3] = { 675, 675, spellLevel = 52, Downrank = 7 },
					[4] = { 875, 875, spellLevel = 60, Downrank = 11 },
					[5] = { 2750, 2750, spellLevel = 72, },
					[6] = { 3300, 3300, spellLevel = 78, },
		},
		[GetSpellInfo(18220)] = { --Base OK, Increase OK, Coefficient OK
					["Name"] = "Dark Pact",
					[0] = { School = { "Shadow", "Utility", }, SPBonus = 0.96, NoGlobalMod = true, NoTargetAura = true, NoSchoolTalents = true, NoDPS = true, NoDPM = true, NoDoom = true, NoCasts = true, NoNext = true, Unresistable = true, NoDownrank = true },
					[1] = { 305, 305, spellLevel = 40, },
					[2] = { 440, 440, spellLevel = 50, },
					[3] = { 545, 545, spellLevel = 60, },
					[4] = { 700, 700, spellLevel = 70, },
					[5] = { 1200, 1200, spellLevel = 80, },
		},
		[GetSpellInfo(980)] = { --Base OK, Increase OK, Coefficient OK
					["Name"] = "Curse of Agony",
					[0] = { School = { "Shadow", "Affliction", }, SPBonus = 1.20, eDot = true, eDuration = 24, sTicks = 2, Downrank = 5 },
					[1] = { 84, 84, spellLevel = 8,  },
					[2] = { 180, 180, spellLevel = 18, },
					[3] = { 324, 324, spellLevel = 28, },
					[4] = { 504, 504, spellLevel = 38, },
					[5] = { 780, 780, spellLevel = 48, },
					[6] = { 1044, 1044, spellLevel = 58, },
					[7] = { 1356, 1356, spellLevel = 67, },
					[8] = { 1440, 1440, spellLevel = 73, },
					[9] = { 1740, 1740, spellLevel = 79, },
		},
		[GetSpellInfo(603)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Curse of Doom",
					[0] = { School = { "Shadow", "Affliction", }, SPBonus = 2, eDot = true, eDuration = 60, Downrank = 9 },
					[1] = { 3200, 3200, spellLevel = 60, },
					[2] = { 4200, 4200, spellLevel = 70, },
					[3] = { 7300, 7300, spellLevel = 80, },
		},
		[GetSpellInfo(6789)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Death Coil",
					[0] = { School = { "Shadow", "Affliction", "Leech" }, sFactor = 0.5, Cooldown = 120, Leech = 3, NoDoom = true, BaseIncrease = true, Downrank = 6 },
					[1] = { 244, 244, 13, 14, spellLevel = 42, },
					[2] = { 319, 319, 15, 16, spellLevel = 50, },
					[3] = { 400, 400, 18, 18, spellLevel = 58, },
					[4] = { 519, 519, 20, 21, spellLevel = 68, },
					[5] = { 670, 670, 16, 16, spellLevel = 73, },
					[6] = { 790, 790, 10, 10, spellLevel = 78, },
		},
		[GetSpellInfo(689)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Drain Life",
					[0] = { School = { "Shadow", "Affliction", "Leech" }, castTime = 5, Leech = 1, sHits = 5, sFactor = 0.5, Channeled = true, Drain = true, Downrank = 5 },
					[1] = { 10, 10, spellLevel = 14, },
					[2] = { 17, 17, spellLevel = 22, },
					[3] = { 29, 29, spellLevel = 30, },
					[4] = { 41, 41, spellLevel = 38, },
					[5] = { 55, 55, spellLevel = 46, },
					[6] = { 71, 71, spellLevel = 54, },
					[7] = { 87, 87, spellLevel = 62, },
					[8] = { 108, 108, spellLevel = 69, },
					[9] = { 133, 133, spellLevel = 78, },
		},
		[GetSpellInfo(1120)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Drain Soul",
					[0] = { School = { "Shadow", "Affliction", }, castTime = 15, sFactor = 0.5, sTicks = 3, Channeled = true, Drain = true, Downrank = 14 },
					[1] = { 55, 55, spellLevel = 10, },
					[2] = { 155, 155, spellLevel = 24, },
					[3] = { 295, 295, spellLevel = 38, },
					[4] = { 455, 455, spellLevel = 52, },
					[5] = { 620, 620, spellLevel = 67, Downrank = 9 },
					[6] = { 710, 710, spellLevel = 77, },
		},
		[GetSpellInfo(5676)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Searing Pain",
					[0] = { School = { "Fire", "Destruction" }, canCrit = true, BaseIncrease = true, Downrank = 6 },
					[1] = { 34, 42, 4, 5, spellLevel = 18, },
					[2] = { 59, 71, 6, 6, spellLevel = 26, },
					[3] = { 86, 104, 7, 8, spellLevel = 34, },
					[4] = { 122, 146, 9, 9, spellLevel = 42, },
					[5] = { 158, 188, 10, 11, spellLevel = 50, },
					[6] = { 204, 240, 12, 12, spellLevel = 58, },
					[7] = { 243, 287, 9, 10, spellLevel = 65, Downrank = 4 },
					[8] = { 270, 320, 16, 17, spellLevel = 70, },
					[9] = { 295, 349, 16, 17, spellLevel = 74, },
					[10] = { 343, 405, 4, 5, spellLevel = 79, },
		},
		[GetSpellInfo(6353)] = { --DONE: Base OK, Increase OK, Coefficient OK (?)
					["Name"] = "Soul Fire",
					[0] = { School = { "Fire", "Destruction" }, SPBonus = 1.15, castTime = 6, canCrit = true, BaseIncrease = true, Cooldown = 60, Downrank = 4 },
					[1] = { 623, 783, 17, 18, spellLevel = 48, },
					[2] = { 703, 881, 18, 19, spellLevel = 56, Downrank = 6 },
					[3] = { 839, 1051, 14, 14, spellLevel = 64,  },
					[4] = { 1003, 1257, 15, 16, spellLevel = 70, },
					[5] = { 1137, 1423, 16, 16, spellLevel = 75, },
					[6] = { 1323, 1657, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(17877)] = { --Base OK, Increase OK, Coefficient X, Downrank X
					["Name"] = "Shadowburn",
					[0] = { School = { "Shadow", "Destruction" }, Cooldown = 15, canCrit = true, BaseIncrease = true, },
					[1] = { 87, 99, 4, 5, spellLevel = 20, },
					[2] = { 115, 131, 8, 9, spellLevel = 24, },
					[3] = { 186, 210, 10, 11, spellLevel = 32, },
					[4] = { 261, 293, 13, 14, spellLevel = 40, },
					[5] = { 350, 392, 15, 16, spellLevel = 48, },
					[6] = { 450, 502, 18, 18, spellLevel = 56, },
					[7] = { 518, 578, 20, 21, spellLevel = 63, },
					[8] = { 597, 665, 15, 16, spellLevel = 70, },
					[9] = { 662, 738, 20, 20, spellLevel = 75, },
					[10] = { 775, 865, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(348)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Immolate",
					[0] = { School = { "Fire", "Destruction" }, canCrit = true, castTime = 2, SPBonus = 0.2, eDuration = 15, sTicks = 3, BaseIncrease = true, Downrank = 5 },
					[1] = { 8, 8, 2, 3, hybridDotDmg = 20, spellLevel = 1, },
					[2] = { 19, 19, 4, 5, hybridDotDmg = 40, spellLevel = 10, },
					[3] = { 45, 45, 7, 8, hybridDotDmg = 90, spellLevel = 20, },
					[4] = { 90, 90, 10, 11, hybridDotDmg = 165, spellLevel = 30, },
					[5] = { 134, 134, 13, 14, hybridDotDmg = 255, spellLevel = 40, },
					[6] = { 192, 192, 16, 16, hybridDotDmg = 365, spellLevel = 50, },
					[7] = { 258, 258, 19, 19, hybridDotDmg = 485, spellLevel = 60, },
					[8] = { 279, 279, 19, 20, hybridDotDmg = 510, spellLevel = 60, },
					[9] = { 327, 327, 21, 22, hybridDotDmg = 615, spellLevel = 69, },
					[10] = { 370, 370, 20, 20, hybridDotDmg = 695, spellLevel = 75, },
					[11] = { 460, 460, 0, 0, hybridDotDmg = 785, spellLevel = 80, },
		},
		[GetSpellInfo(1949)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Hellfire",
					[0] = { School = { "Fire", "Destruction" }, castTime = 15, sHits = 15, sFactor = 1/2, BaseIncrease = true, Channeled = true, Downrank = 10, AoE = true },
					[1] = { 83, 83, 4, 4, spellLevel = 30, },
					[2] = { 139, 139, 5, 5, spellLevel = 42, },
					[3] = { 208, 208, 7, 7, spellLevel = 54, },
					[4] = { 306, 306, 8, 8, spellLevel = 68, },
					[5] = { 451, 451, 2, 2, spellLevel = 78, },
		},
		[GetSpellInfo(5740)] = { --DONE: Base OK, Increase OK, Coefficient OK (more precise?)
					["Name"] = "Rain of Fire",
					[0] = { School = { "Fire", "Destruction" }, castTime = 8, canCrit = true, SPBonus = 1.144157, sTicks = 2, BaseIncrease = 12, Channeled = true, Downrank = 5, AoE = true },
					[1] = { 240, 240, 4, 4, spellLevel = 20, },
					[2] = { 544, 544, 8, 8, spellLevel = 34, },
					[3] = { 880, 880, 8, 8, spellLevel = 46, },
					[4] = { 1284, 1284, 12, 12, spellLevel = 58, },
					[5] = { 1808, 1808, 16, 16, spellLevel = 69, },
					[6] = { 2152, 2152, 24, 24, spellLevel = 72, Downrank = 4 },
					[7] = { 2700, 2700, 8, 8, spellLevel = 79, },
		},
		[GetSpellInfo(30108)] = { --DONE: Base OK, Increase OK, Coefficient OK, Downrank X
					["Name"] = "Unstable Affliction",
					[0] = { School = { "Shadow", "Affliction", }, eDot = true, eDuration = 15, sTicks = 3, },
					[1] = { 550, 550, spellLevel = 50, },
					[2] = { 700, 700, spellLevel = 60, },
					[3] = { 875, 875, spellLevel = 70, },
					[4] = { 985, 985, spellLevel = 75, },
					[5] = { 1150, 1150, spellLevel = 80, },
		},
		[GetSpellInfo(17962)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Conflagrate",
					[0] = { School = { "Fire", "Destruction" }, canCrit = true, Cooldown = 10, NoDownrank = true },
					[1] = { 0, 0, hybridDotDmg = 0, spellLevel = 40, },
		},
		[GetSpellInfo(27243)] = { --Base OK, Increase OK (rank 2 upper?), Coefficient OK (DD?)
					["Name"] = "Seed of Corruption",
					[0] = { School = { "Shadow", "Affliction", }, castTime = 2, canCrit = true, SPBonus = 0.2129, dotFactor = 1.5, eDuration = 18, sTicks = 3, NoDotAverage = true, DotCap = true, AoE = true },
					[1] = { 1110, 1290, hybridDotDmg = 1044, spellLevel = 70, },
					[2] = { 1383, 1612, hybridDotDmg = 1296, spellLevel = 75, },
					[3] = { 1633, 1897, hybridDotDmg = 1518, spellLevel = 80, },
		},
		[GetSpellInfo(30283)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Shadowfury",
					[0] = { School = { "Shadow", "Destruction" }, canCrit = true, SPBonus = 0.1932, Cooldown = 20, BaseIncrease = true, AoE = true },
					[1] = { 343, 407, 14, 15, spellLevel = 50, },
					[2] = { 459, 547, 17, 18, spellLevel = 60, },
					[3] = { 612, 728, 8, 9, spellLevel = 70, },
					[4] = { 822, 978, 12, 12, spellLevel = 75, },
					[5] = { 968, 1152, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(32231)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Incinerate",
					[0] = { School = { "Fire", "Destruction" }, canCrit = true, castTime = 2.5, BaseIncrease = true, Downrank = 4 },
					[1] = { 403, 467, 13, 14, spellLevel = 64, Downrank = 5 },
					[2] = { 444, 514, 11, 12, spellLevel = 70, },
					[3] = { 485, 563, 12, 13, spellLevel = 74, },
					[4] = { 582, 676, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(47897)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Shadowflame",
					[0] = { School = { "Shadow", "Destruction" }, SPBonus = 1.5/3.5 * (1/4), canCrit = true, Cooldown = 15, BaseIncrease = true, },
					[1] = { 520, 568, 10, 10, spellLevel = 75, },
					[2] = {	615, 671, 0, 0, spellLevel = 80, },
			["Secondary"] = {
					["Name"] = "Shadowflame",
					[0] = { School = { "Fire", "Destruction" }, dotFactor = 8/30, eDuration = 8, sTicks = 2, Cooldown = 15 },
					[1] = { 0, 0, hybridDotDmg = 544, spellLevel = 75,  },
					[2] = {	0, 0, hybridDotDmg = 644, spellLevel = 80, },
			},
		},
		[GetSpellInfo(48181)] = { --DONE: Base OK, Increase OK, Coefficient OK, Downrank X
					["Name"] = "Haunt",
					[0] = { School = { "Shadow", "Affliction" }, canCrit = true, castTime = 1.5, Cooldown = 8 },
					[1] = { 405, 473, spellLevel = 60, },
					[2] = { 487, 569, spellLevel = 70, },
					[3] = { 550, 642, spellLevel = 75, },
					[4] = { 645, 753, spellLevel = 80, },
		},
		[GetSpellInfo(50796)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Chaos Bolt",
					[0] = { School = { "Fire", "Destruction" }, castTime = 2.5, canCrit = true, Unresistable = true, Cooldown = 12, BaseIncrease = true, Downrank = 8 },
					[1] = { 837, 1061, 27, 28, spellLevel = 60, Downrank = 5 },
					[2] = { 1077, 1367, 55, 55, spellLevel = 70, },
					[3] = { 1217, 1545, 27, 28, spellLevel = 75, },
					[4] = { 1429, 1813, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(50589)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Immolation Aura",
					[0] = { School = "Fire", SPBonus = 2.145, castTime = 15, Channeled = true, AoE = true, sHits = 15, Cooldown = 30, NoDownrank = true, BaseIncrease = true },
					[1] = { 251, 251, 230, 230, spellLevel = 60 },
		},
		[GetSpellInfo(50581)] = { --DONE: Base OK, Increase OK, Coefficient OK
					["Name"] = "Shadow Cleave",
					[0] = { School = "Shadow", SPBonus = 0.214, AoE = 3, Cooldown = 6, canCrit = true, NoDownrank = true },
					[1] = { 110, 110, spellLevel = 60 },
		},
		[GetSpellInfo(3110)] = {
					--BASE OK, COEFFICIENT OK, INCREASE X
					["Name"] = "Firebolt",
					[0] = { School = { "Fire", "Pet" }, SPBonus = 0.784, canCrit = true, NoGlobalMod = true, NoManaCalc = true, NoNext = true, NoMPS = true, NoDPM = true, NoDownrank = true, NoManualRatings = true, BaseIncrease = true },
					[1] = { 6, 9, 0, 0, spellLevel = 1, },
					[2] = { 12, 15, 0, 0, spellLevel = 8, },
					[3] = { 23, 28, 0, 0, spellLevel = 18, },
					[4] = { 34, 39, 0, 0, spellLevel = 28, },
					[5] = { 50, 57, 0, 0, spellLevel = 38, },
					[6] = { 70, 79, 0, 0, spellLevel = 48, },
					[7] = { 87, 98, 0, 0, spellLevel = 58, },
					[8] = { 115, 131, 0, 0, spellLevel = 68, },
					[9] = { 208, 235, 16, 16, spellLevel = 78, },
		},
		[GetSpellInfo(54049)] = {
					--BASE OK, COEFFICIENT OK, INCREASE X
					["Name"] = "Shadow Bite",
					[0] = { School = { "Shadow", "Pet" }, SPBonus = 0.4489, canCrit = true, Cooldown = 6, NoGlobalMod = true, NoManaCalc = true, NoNext = true, NoMPS = true, NoDPM = true, NoDownrank = true, NoManualRatings = true, BaseIncrease = true },
					[1] = { 34, 46, 0, 0, spellLevel = 42, },
					[2] = { 48, 66, 0, 0, spellLevel = 50, },
					[3] = { 73, 103, 0, 0, spellLevel = 58, },
					[4] = { 84, 118, 0, 0, spellLevel = 66, },
					[5] = { 97, 138, 6, 7, spellLevel = 74, },
		},
		[GetSpellInfo(7814)] = {
					--BASE OK, COEFFICIENT OK, INCREASE X
					["Name"] = "Lash of Pain",
					[0] = { School = { "Shadow", "Pet" }, SPBonus = 0.4712, canCrit = true, Cooldown = 12, NoGlobalMod = true, NoManaCalc = true, NoNext = true, NoMPS = true, NoDPM = true, NoDownrank = true, NoManualRatings = true, BaseIncrease = true },
					[1] = { 34, 35, 0, 0, spellLevel = 20, },
					[2] = { 46, 47, 0, 0, spellLevel = 28, },
					[3] = { 63, 63, 0, 0, spellLevel = 36, },
					[4] = { 76, 77, 0, 0, spellLevel = 44, },
					[5] = { 91, 92, 0, 0, spellLevel = 52, },
					[6] = { 103, 104, 0, 0, spellLevel = 60, },
					[7] = { 129, 130, 0, 0, spellLevel = 68, },
					[8] = { 202, 203, 0, 0, spellLevel = 74, },
					[9] = { 248, 249, 13, 13, spellLevel = 80, },
		},
		--[[
		[GetSpellInfo(1122)] = {
					["Name"] = "Inferno",
					[0] = { School = "Fire", SPBonus = 1, AoE = true, Cooldown = 20 * 60, canCrit = true, NoDownrank = true },
					[1] = { 200, 200, spellLevel = 60 },
		},
	--]]		
	}
	self.talentInfo = {
	--AFFLICTION
		--Improved Curse of Agony (additive - 3.3.3)
		[GetSpellInfo(18827)] = { 	[1] = { Effect = 0.05, Spells = "Curse of Agony" }, },
		--Suppression
		[GetSpellInfo(18174)] = { 	[1] = { Effect = 1, Spells = "All", ModType = "hitPerc", }, },
		--Improved Corruption (additive - 3.3.3)
		[GetSpellInfo(17810)] = {	[1] = { Effect = 0.02, Spells = "Corruption" },
									[2] = { Effect = 1, Spells = "Seed of Corruption", ModType = "critPerc", }, },
		--Improved Life Tap
		[GetSpellInfo(18182)] = { 	[1] = { Effect = 0.1, Spells = "Life Tap", }, },
		--Soul Siphon
		[GetSpellInfo(17804)] = { 	[1] = { Effect = 1, Spells = { "Drain Soul", "Drain Life" }, ModType = "Soul Siphon" }, },
		--Amplify Curse
		[GetSpellInfo(18288)] = { 	[1] = { Effect = -0.5, Spells = { "Curse of Doom", "Curse of Agony" }, ModType = "castTime" }, },
		--Empowered Corruption (additive - 3.3.3)
		[GetSpellInfo(32381)] = { 	[1] = { Effect = 0.12, Spells = "Corruption", ModType = "SpellDamage" }, },
		--Shadow Embrace
		[GetSpellInfo(32385)] = {	[1] = { Effect = 0.01, Spells = "Shadow", ModType = "Shadow Embrace" }, },
		--Siphon Life (additive - 3.3.3)
		[GetSpellInfo(63108)] = {	[1] = { Effect = 0.05, Spells = { "Corruption", "Unstable Affliction" }, },
									[2] = { Effect = 0.05, Spells = "Seed of Corruption", ModType = "dmgM_dot_Add" },
									[3] = { Effect = 0.4, Spells = "Corruption", ModType = "leechBonus" }, },
		--Improved Felhunter
		[GetSpellInfo(54037)] = { 	[1] = { Effect = -2, Spells = "Shadow Bite", ModType = "cooldown" }, },
		--Shadow Mastery (additive - 3.3.3)
		[GetSpellInfo(18271)] = { 	[1] = { Effect = 0.03, Spells = "Shadow" },
									[2] = { Effect = 0.03, Spells = "Shadow", ModType = "Shadow Mastery" }, },
		--Contagion (additive - 3.3.3)
		[GetSpellInfo(30060)] = { 	[1] = { Effect = 0.01, Spells = { "Curse of Agony", "Corruption", "Seed of Corruption" }, }, },
		--Malediction (multiplicative - 3.3.3)
		[GetSpellInfo(32477)] = {	[1] = { Effect = 0.01, Spells = "All", Not = "Pet", Multiply = true },
									[2] = { Effect = 3, Spells = { "Unstable Affliction", "Corruption" }, ModType = "critPerc" }, },
		--Death's Embrace (multiplicative - 3.3.3)
		[GetSpellInfo(47198)] = {	[1] = { Effect = 1, Spells = "Shadow", Not = "Pet", ModType = "Death's Embrace", }, },
		--Pandemic
		[GetSpellInfo(58435)] = {	[1] = { Effect = 1, Spells = { "Corruption", "Unstable Affliction", "Haunt" }, ModType = "Pandemic" }, },
		--Everlasting Affliction (additive - 3.3.3)
		[GetSpellInfo(47201)] = {	[1] = { Effect = 0.06, Spells = "Corruption", ModType = "SpellDamage" },
									[2] = { Effect = 0.05, Spells = "Unstable Affliction", ModType = "SpellDamage" }, },
	--DEMONOLOGY
		--Improved Imp
		[GetSpellInfo(18694)] = { 	[1] = { Effect = 0.1, Spells = "Firebolt", ModType = "bDmgM", Multiply = true }, },
		--Unholy Power (multiplicative - 3.3.3)
		[GetSpellInfo(18769)] = { 	[1] = { Effect = 0.04, Spells = "Pet", ModType = "Unholy Power" }, },
		--Demonic Aegis
		[GetSpellInfo(30143)] = { 	[1] = { Effect = 0.02, Spells = "Leech", ModType = "Demonic Aegis" }, },
		--Master Demonologist  (multiplicative - 3.3.3)
		[GetSpellInfo(23785)] = {	[1] = { Effect = 0.01, Spells = "All", ModType = "Master Demonologist" }, },
		--Molten Core
		[GetSpellInfo(47245)] = {	[1] = { Effect = 3, Spells = "Immolate", ModType = "eDuration" },
									[2] = { Effect = 1, Spells = { "Soul Fire", "Incinerate" }, ModType = "Molten Core", }, },
		--Demonic Tactics
		[GetSpellInfo(30242)] = { 	[1] = { Effect = 2, Spells = "Pet", ModType = "Demonic Tactics" }, },
		--Improved Demonic Tactics
		[GetSpellInfo(54347)] = { 	[1] = { Effect = 0.1, Spells = "Pet", ModType = "Improved Demonic Tactics" }, },
		--Demonic Pact (multiplicative - 3.3.3)
		[GetSpellInfo(47236)] = {	[1] = { Effect = 0.02, Spells = "All", Not = "Pet", Multiply = true }, },
	--DESTRUCTION:
		--Improved Shadow Bolt (additive - 3.3.3)
		[GetSpellInfo(17793)] = {	[1] = { Effect = 0.02, Spells = "Shadow Bolt" }, },
		--Aftermath (additive - 3.3.3)
		[GetSpellInfo(18119)] = {	[1] = { Effect = 0.03, Spells = "Immolate", ModType = "dmgM_dot_Add", },
									[2] = { Effect = 0.03, Spells = "Conflagrate", ModType = "Aftermath" }, },
		--Demonic Power
		[GetSpellInfo(18126)] = { 	[1] = { Effect = 0.25, Spells = "Firebolt", ModType = "Demonic Power" }, 
									[2] = { Effect = -3, Spells = "Lash of Pain", ModType = "cooldown" }, },
		--Ruin
		[GetSpellInfo(17959)] = { 	[1] = { Effect = 0.1, Spells = { "Destruction", "Firebolt" }, ModType = "critM", }, },
		--Improved Searing Pain
		[GetSpellInfo(17927)] = { 	[1] = { Effect = { 4, 7, 10, }, Spells = "Searing Pain", ModType = "critPerc", }, },
		--Improved Immolate (additive - 3.3.3)
		[GetSpellInfo(17815)] = { 	[1] = { Effect = 0.1, Spells = "Immolate" },
									[2] = { Effect = 0.1, Spells = "Conflagrate", ModType = "Improved Immolate" }, },
		--Devastation
		[GetSpellInfo(18130)] = { 	[1] = { Effect = 5, Spells = "Destruction", ModType = "critPerc", }, },
		--Emberstorm (additive - 3.3.3)
		[GetSpellInfo(17954)] = {	[1] = { Effect = 0.03, Spells = "Fire", Not = "Firebolt", Mod = { "Incinerate", 3, 16, "castTime", function(v,c,t) return (v+c*0.05-t*0.05) end }, },
									[2] = { Effect = 0.03, Spells = "Fire", ModType = "Emberstorm" }, },
		--Shadow and Flame (multiplicative - 3.3.3)
		[GetSpellInfo(30288)] = { 	[1] = { Effect = 0.04, Spells = { "Shadow Bolt", "Chaos Bolt", "Incinerate", "Shadowburn" }, ModType = "SpellDamage", Multiply = true }, },
		--Backdraft
		[GetSpellInfo(47258)] = { 	[1] = { Effect = 0.1, Spells = { "Conflagrate", "Shadowburn", "Shadowflame", "Shadowfury" }, ModType = "Backdraft", }, },
		--Empowered Imp (multiplicative - 3.3.3)
		[GetSpellInfo(47220)] = { 	[1] = { Effect = 0.1, Spells = "Firebolt", ModType = "Empowered Imp" }, },		
		--Fire and Brimstone (multiplicative - 3.3.3)
		[GetSpellInfo(47266)] = {	[1] = { Effect = 5, Spells = "Conflagrate", ModType = "critPerc", },
									[2] = { Effect = 0.02, Spells = { "Incinerate", "Chaos Bolt" }, ModType = "Fire and Brimstone" }, },
	}
end