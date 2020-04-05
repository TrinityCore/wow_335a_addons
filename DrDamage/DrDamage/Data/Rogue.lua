if select(2, UnitClass("player")) ~= "ROGUE" then return end
local GetSpellInfo = GetSpellInfo
local GetSpellCritChance = GetSpellCritChance
local GetCritChance = GetCritChance
local UnitDebuff = UnitDebuff
local UnitCreatureType = UnitCreatureType
local math_min = math.min
local math_max = math.max
local math_floor = math.floor
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitDamage = UnitDamage
local string_find = string.find
local string_lower = string.lower
local IsEquippedItemType = IsEquippedItemType
local ipairs = ipairs
local select = select

function DrDamage:PlayerData()
	--Health Updates
	self.TargetHealth = { [1] = 0.35, [2] = "player" }
	--Special aura handling
	local TargetIsPoisoned = false
	local Mutilate = GetSpellInfo(1329)
	local poison = GetSpellInfo(38615)
	self.Calculation["TargetAura"] = function()
		local temp = TargetIsPoisoned
		TargetIsPoisoned = false

		for i=1,40 do
			local name, _, _, _, debuffType = UnitDebuff("target",i)
			if name then
				if debuffType == poison then
					TargetIsPoisoned = true
					break
				end
			else break end
		end
		if temp ~= TargetIsPoisoned then
			return true, Mutilate
		end
	end
--GENERAL
	local instant = { [GetSpellInfo(8679)] = 13, [GetSpellInfo(8686)] = 21, [GetSpellInfo(8688)] = 30, [GetSpellInfo(11338)] = 45, [GetSpellInfo(11339)] = 62, [GetSpellInfo(11340)] = 76, [GetSpellInfo(26891)] = 161, [GetSpellInfo(57964)] = 245, [GetSpellInfo(57965)] = 300, }
	local wound = { [GetSpellInfo(13219)] = 17, [GetSpellInfo(13225)] = 25, [GetSpellInfo(13226)] = 38, [GetSpellInfo(13227)] = 53, [GetSpellInfo(27188)] = 112, [GetSpellInfo(57977)] = 188, [GetSpellInfo(57978)] = 231, }
	local anesthetic = { [GetSpellInfo(26785)] = (134+172)/2, [GetSpellInfo(57982)] = (218+280)/2, }
	local deadly = { [GetSpellInfo(2823)] = 24, [GetSpellInfo(2824)] = 36, [GetSpellInfo(11355)] = 56, [GetSpellInfo(11356)] = 76, [GetSpellInfo(25351)] = 96, [GetSpellInfo(26967)] = 160, [GetSpellInfo(27186)] = 204, [GetSpellInfo(57972)] = 244, [GetSpellInfo(57973)] = 296,  }
	local ohs = GetSpellInfo(201)
	local oha = GetSpellInfo(196)
	local ipicon = "|T" .. select(3,GetSpellInfo(8679)) .. ":16:16:1:1|t"
	local wpicon = "|T" .. select(3,GetSpellInfo(13219)) .. ":16:16:1:1|t"
	local apicon = "|T" .. select(3,GetSpellInfo(26785)) .. ":16:16:1:1|t"
	local dpicon = "|T" .. select(3,GetSpellInfo(2823)) .. ":16:16:1:-1|t"
	local hasicon = "|T" .. select(3,GetSpellInfo(13960)) .. ":16:16:1:1|t"
	self.Calculation["ROGUE"] = function( calculation, ActiveAuras, Talents, spell, baseSpell )
		if Talents["Prey on the Weak"] then
			if UnitHealth("target") ~= 0 and (UnitHealth("player") / UnitHealthMax("player")) > (UnitHealth("target") / UnitHealthMax("target")) then
				calculation.critM = calculation.critM * (1 + 2 * Talents["Prey on the Weak"])
			end
		end
		if Talents["Remorseless Attacks"] and ActiveAuras["Remorseless"] then
			calculation.critPerc = calculation.critPerc + Talents["Remorseless Attacks"]
		end
		if Talents["Improved Kidney Shot"] and ActiveAuras["Kidney Shot"] then
			--Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * (1 + Talents["Improved Kidney Shot"])
		end
		if Talents["Dirty Deeds"] and UnitHealth("target") ~= 0 and (UnitHealth("target") / UnitHealthMax("target")) < 0.35 then
			--Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * (1 + Talents["Dirty Deeds"])
		end
		if Talents["Focused Attacks"] then
			calculation.actionCost = calculation.actionCost - 2 * Talents["Focused Attacks"] * (calculation.critPerc / 100) * (baseSpell.DualAttack and not baseSpell.AoE and 2 or 1)
		end
		if ActiveAuras["Shadowstep"] then
			calculation.dmgM = calculation.dmgM * 1.2
		end
		--Glyph of Hemorrhage
		if ActiveAuras["Hemorrhage"] and self:HasGlyph(56807) then
			calculation.finalMod = calculation.finalMod * 1.4
		end
		if ActiveAuras["Blade Flurry"] then
			if not calculation.aoe then
				calculation.aoe = 2
			else
				calculation.targets = calculation.targets * 2
			end
		end
		local buff = self:GetWeaponBuff()
		local buffO = self:GetWeaponBuff(true)
		local hit
		if buff or buffO then
			calculation.E_dmgM = select(7,UnitDamage("player")) * (1 + (Talents["Vile Poisons"] or 0)) * calculation.dmgM_Magic
			calculation.E_canCrit = true
			calculation.E_critPerc = GetSpellCritChance(4) + calculation.spellCrit
			calculation.E_critM = 0.5 + self.Damage_critMBonus * 1.5
			hit =  0.01 * math_max(0,math_min(100, self:GetSpellHit(calculation.playerLevel,calculation.targetLevel) + calculation.spellHit))
		end
		if not baseSpell.OffhandAttack and not baseSpell.NoPoison and buff then
			--Instant Poison
			if instant[buff] then
				local spd = self:GetWeaponSpeed()
				calculation.extra = instant[buff]
				calculation.extraDamage = 0.09
				calculation.extraChance = 0.2/1.4 * spd * (1 + (Talents["Improved Poisons"] or 0) + (ActiveAuras["Envenom"] and 0.75 or 0)) * hit
				calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. ipicon) or ipicon
			--Wound Poison
			elseif wound[buff] then
				local spd = self:GetWeaponSpeed()
				calculation.extra = wound[buff]
				calculation.extraDamage = 0.036
				calculation.extraChance = 0.5/1.4 * spd * hit
				calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. wpicon) or wpicon
			--Anesthethic Poison
			elseif anesthetic[buff] then
				calculation.extra = anesthetic[buff]
				calculation.extraChance = 0.5 * hit
				calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. apicon) or apicon
				if not calculation.extraDamage then
					calculation.extraDamage = 0
				end
			--Deadly Poison
			elseif baseSpell.AutoAttack and deadly[buff] then
				calculation.extra_DPS = deadly[buff]
				calculation.extraDamage_DPS = 0.108
				calculation.extraDuration_DPS = 12
				calculation.extraStacks_DPS = 5
				calculation.extraName_DPS = "5x" .. dpicon
			end
		end
		if (baseSpell.AutoAttack or baseSpell.DualAttack or baseSpell.OffhandAttack) and buffO then
			--Instant Poison
			if instant[buffO] then
				local _, spd = self:GetWeaponSpeed()
				calculation.extra_O = instant[buffO]
				calculation.extraDamage_O = 0.09
				calculation.extraChance_O = 0.2/1.4 * spd * (1 + (Talents["Improved Poisons"] or 0) + (ActiveAuras["Envenom"] and 0.75 or 0)) * hit
				calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. ipicon) or ipicon
				if not calculation.extraDamage then
					calculation.extraDamage = 0
				end
			--Wound Poison
			elseif wound[buffO] then
				local _, spd = self:GetWeaponSpeed()
				calculation.extra_O = wound[buffO]
				calculation.extraDamage_O = 0.036
				calculation.extraChance_O = 0.5/1.4 * spd * hit
				calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. wpicon) or wpicon			
				if not calculation.extraDamage then
					calculation.extraDamage = 0
				end
			--Anesthethic Poison
			elseif anesthetic[buffO] then
				calculation.extra_O = anesthetic[buffO]
				calculation.extraChance_O = 0.5 * hit
				calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. apicon) or apicon
				if not calculation.extraDamage then
					calculation.extraDamage = 0
				end
			--Deadly Poison
			elseif baseSpell.AutoAttack and deadly[buffO] then
				calculation.extra_DPS = deadly[buffO]
				calculation.extraDamage_DPS = 0.108
				calculation.extraDuration_DPS = 12
				calculation.extraStacks_DPS = 5
				calculation.extraName_DPS = "5x" .. dpicon
			end
		end
		if Talents["Hack and Slash"] then
			--Requires One-Handed Swords
			local mhType, ohType = self:GetWeaponType()
			local mh = ((mhType == ohs) or (mhType == oha)) and not baseSpell.OffhandAttack
			local oh = ((ohType == ohs) or (ohType == oha)) and (baseSpell.AutoAttack or baseSpell.OffhandAttack or baseSpell.DualAttack)
			if mh or oh then
				if not calculation.extraDamage then			
					calculation.extraDamage = 0
				end
				calculation.extraWeaponDamage = 1
				calculation.extraWeaponDamageM = true
				calculation.extraWeaponDamageChance = (mh and oh) and (2 * Talents["Hack and Slash"]) or Talents["Hack and Slash"]
				calculation.extraWeaponDamage_dmgM = calculation.dmgM_global
				calculation.extra_canCrit = true
				calculation.extra_critM = 1 + 2 * self.Damage_critMBonus
				calculation.extra_critPerc = GetCritChance() + calculation.meleeCrit
				calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. hasicon) or hasicon
			end
		end
	end
--TALENTS
	local ohm = GetSpellInfo(198)
	self.Calculation["Mace Specialization"] = function( calculation, value )
		if IsEquippedItemType(ohm) then
			calculation.armorPen = calculation.armorPen + value
		end
	end
	self.Calculation["Surprise Attacks"] = function( calculation, value )
		calculation.NoDodge = true
	end
	self.Calculation["Relentless Strikes"] = function( calculation, value )
		calculation.actionCost = calculation.actionCost - value * calculation.Melee_ComboPoints * 25
	end	
--ABILITIES
	self.Calculation["Shiv"] = function( calculation )
		calculation.extraChance_O = 0.01 * math_max(0,math_min(100, self:GetSpellHit(calculation.playerLevel,calculation.targetLevel) + calculation.spellHit))
		calculation.E_canCrit = false
	end
	self.Calculation["Fan of Knives"] = function( calculation )
		if self:GetNormM() == 1.7 then
			calculation.WeaponDamage = 1.05
		end
		--Glyph of Fan of Knives (TODO: A/M - currently doesn't matter)
		if self:HasGlyph(63254) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Envenom"] = function( calculation, ActiveAuras, _, spell )
		if ActiveAuras["Deadly Poison"] then
			local cp = math_min(ActiveAuras["Deadly Poison"], calculation.Melee_ComboPoints)
			if cp > 1 then
				calculation.minDam = calculation.minDam + (cp - 1) * spell.DPBonus
				calculation.maxDam = calculation.maxDam + (cp - 1) * spell.DPBonus
			end
		else
			calculation.zero = true
		end
	end
	self.Calculation["Mutilate"] = function( calculation )
		if TargetIsPoisoned then
			--Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * 1.2
		end
		if self:GetSetAmount("T9") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Killing Spree"] = function( calculation, ActiveAuras )
		if not ActiveAuras["Killing Spree"] then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Eviscerate"] = function( calculation )
		--Glyph of Eviscerate
		if self:HasGlyph(56802) then
			calculation.critPerc = calculation.critPerc + 10
		end
	end
	self.Calculation["Garrote"] = function( calculation )
		--Glyph of Garrote
		if self:HasGlyph(56812) then
			calculation.dmgM_Add = 15/18 * calculation.dmgM_Add + 0.2
			calculation.eDuration = calculation.eDuration - 3
		end
	end
	self.Calculation["Ghostly Strike"] = function( calculation )
		--Glyph of Ghostly Strike
		if self:HasGlyph(56814) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.4
			calculation.cooldown = calculation.cooldown + 10
		end
		if self:GetNormM() == 1.7 then
			calculation.WeaponDamage = 1.8
		end		
	end
	self.Calculation["Rupture"] = function( calculation )
		--Glyph of Rupture
		if self:HasGlyph(56801) then
			calculation.eDuration = calculation.eDuration + 4
		end
		if self:GetSetAmount("T7") >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
		if self:GetSetAmount("T8") >= 4 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Hemorrhage"] = function( calculation )
		if self:GetSetAmount("T9") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
		if self:GetNormM() == 1.7 then
			calculation.WeaponDamage = 1.6
		end		
	end
	self.Calculation["Sinister Strike"] = function( calculation )
		if self:GetSetAmount("T9") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Backstab"] = self.Calculation["Sinister Strike"]
--SETS
	self.SetBonuses["T7"] = { 40495, 40496, 40499, 40500, 40502, 39558, 39560, 39561, 39564, 39565 }
	self.SetBonuses["T8"] = { 46123, 46124, 46125, 46126, 46127, 45396, 45397, 45398, 45399, 45400 }
	self.SetBonuses["T9"] = { 48243, 48244, 48245, 48246, 48247, 48218, 48219, 48220, 48221, 48222, 48223, 48224, 48225, 48226, 48227, 48232, 48231, 48230, 48229, 48228, 48242, 48241, 48240, 48239, 48238, 48233, 48234, 48235, 48236, 48237 }
	self.SetBonuses["T10"] = { 50150, 50090, 50089, 50088, 50087, 51185, 51254, 51186, 51253, 51187, 51252, 51188, 51251, 51189, 51250 }
--AURA
--Player
	--Killing Spree
	self.PlayerAura[GetSpellInfo(51690)] = { ActiveAura = "Killing Spree", Value = 0.2, ID = 51690 }
	--Remorseless
	self.PlayerAura[GetSpellInfo(14143)] = { ActiveAura = "Remorseless", ID = 14143 }
	--Shadowstep
	self.PlayerAura[GetSpellInfo(36554)] = { ActiveAura = "Shadowstep", Not = { "Gouge", "Shiv", "Deadly Throw", "Fan of Knives" }, ID = 36554 }
	--Envenom
	self.PlayerAura[GetSpellInfo(32645)] = { ActiveAura = "Envenom", Spells = 6603, ID = 32645 }
	--Turn the Tables
	self.PlayerAura[GetSpellInfo(51629)] = { ModType = "critPerc", Ranks = 3, Value = 2, ID = 51629, Spells = { 53, 14278, 16511, 1329, 14251, 5938, 1752 } }
	--Blade Flurry
	self.PlayerAura[GetSpellInfo(13877)] = { ActiveAura = "Blade Flurry", ID = 13877, Mods = { ["haste"] = function(v) return v * 1.2 end } }
	--Slice and Dice
	self.PlayerAura[GetSpellInfo(6774)] = { ID = 6774, Mods = { ["haste"] = function(v) return v * 1.4 end } }
	--Cold Blood
	self.PlayerAura[GetSpellInfo(14177)] = { Value = 100, ModType = "critPerc", ID = 14177, Not = { "Attack", "Rupture", "Garrote", "Gouge", "Shiv" } }
--Target
	--Deadly Poison
	self.TargetAura[GetSpellInfo(2818)] = { ActiveAura = "Deadly Poison", Spells = 1329, Manual = GetSpellInfo(2818), Category = "Deadly Poison", SelfCast = true, Apps = 5, ID = 2818 }
	local dPoison = { 2819, 11353, 11354, 25349, 26968, 27187, 57969, 57970 }
	for _, v in ipairs(dPoison) do
		self.TargetAura[GetSpellInfo(v)] = self.TargetAura[GetSpellInfo(2818)]
	end
	--Kidney Shot
	self.TargetAura[GetSpellInfo(408)] = { ActiveAura = "Kidney Shot", SelfCast = true, ID = 408 }


	self.spellInfo = {
		[GetSpellInfo(1752)] = {
			["Name"] = "Sinister Strike",
			[0] = { WeaponDamage = 1 },
			[1] = { 3 },
			[2] = { 6 },
			[3] = { 10 },
			[4] = { 15 },
			[5] = { 22 },
			[6] = { 33 },
			[7] = { 52 },
			[8] = { 68 },
			[9] = { 80 },
			[10] = { 98 },
			[11] = { 150 },
			[12] = { 180 },
		},
		[GetSpellInfo(53)] = {
			["Name"] = "Backstab",
			[0] = { WeaponDamage = 1.5, Weapon = GetSpellInfo(1180) }, --Daggers
			[1] = { 15 },
			[2] = { 30 },
			[3] = { 48 },
			[4] = { 69 },
			[5] = { 90 },
			[6] = { 135 },
			[7] = { 165 },
			[8] = { 210 },
			[9] = { 225 },
			[10] = { 255 },
			[11] = { 382.5 },
			[12] = { 465 },
		},
		[GetSpellInfo(2098)] = {
			["Name"] = "Eviscerate",
			[0] = { ComboPoints = true, --[[APBonus = { 0.03, 0.06, 0.09, 0.12, 0.15 },--]] APBonus = { 0.07, 0.14, 0.21, 0.28, 0.35 } },
			[1] = { 6, 10, PerCombo = 5 },
			[2] = { 14, 22, PerCombo = 11 },
			[3] = { 25, 39, PerCombo = 19 },
			[4] = { 41, 61, PerCombo = 31 },
			[5] = { 60, 90, PerCombo = 45 },
			[6] = { 93, 137, PerCombo = 71 },
			[7] = { 144, 212, PerCombo = 110 },
			[8] = { 199, 295, PerCombo = 151 },
			[9] = { 224, 332, PerCombo = 170 },
			[10] = { 245, 365, PerCombo = 185 },
			[11] = { 405, 613, PerCombo = 301 },
			[12] = { 497, 751, PerCombo = 370 },
		},
		[GetSpellInfo(8676)] = {
			["Name"] = "Ambush",
			[0] = { WeaponDamage = 2.75, Weapon = GetSpellInfo(1180), Unavoidable = true }, --Daggers
			[1] = { 77 },
			[2] = { 110 },
			[3] = { 137.5 },
			[4] = { 203.5 },
			[5] = { 253 },
			[6] = { 319 },
			[7] = { 368.5 },
			[8] = { 508.75 },
			[9] = { 770 },
			[10] = { 907.5 },
		},
		[GetSpellInfo(1776)] = {
			["Name"] = "Gouge",
			[0] = { APBonus = 0.21, NoPoison = true, Cooldown = 10 },
			[1] = { 1 },
		},
		[GetSpellInfo(14278)] = {
			["Name"] = "Ghostly Strike",
			[0] = { WeaponDamage = 1.25, Cooldown = 20, NoNormalization = true },
			[1] = { 0 },
		},
		[GetSpellInfo(14251)] = {
			["Name"] = "Riposte",
			[0] = { WeaponDamage = 1.5, NoNormalization = true, NoWeapon = true },
			[1] = { 0 },
		},
		[GetSpellInfo(703)] = {
			["Name"] = "Garrote",
			[0] = { NoCrits = true, APBonus = 0.42, eDuration = 18, Ticks = 3, NoWeapon = true, Bleed = true, Unavoidable = true },
			[1] = { 120 },
			[2] = { 162 },
			[3] = { 222 },
			[4] = { 270 },
			[5] = { 342 },
			[6] = { 426 },
			[7] = { 510 },
			[8] = { 612 },
			[9] = { 660 },
			[10] = { 714 },
		},
		[GetSpellInfo(1943)] = {
			["Name"] = "Rupture",
			[0] = { ComboPoints = true, APBonus = { 0.06, 0.12, 0.18, 0.24, 0.3 }, ExtraPerCombo = { 0, 0, 1, 3, 6 }, eDuration = 6, Ticks = 2, DurationPerCombo = 2, Bleed = true },
			[1] = { 40, PerCombo = 20, ExtraPerCombo = 4 },
			[2] = { 60, PerCombo = 30, ExtraPerCombo = 6 },
			[3] = { 88, PerCombo = 42, ExtraPerCombo = 8 },
			[4] = { 128, PerCombo = 57, ExtraPerCombo = 10 },
			[5] = { 176, PerCombo = 79, ExtraPerCombo = 14 },
			[6] = { 272, PerCombo = 108, ExtraPerCombo = 16 },
			[7] = { 324, PerCombo = 136, ExtraPerCombo = 22 },
			[8] = { 488, PerCombo = 197, ExtraPerCombo = 30 },
			[9] = { 580, PerCombo = 235, ExtraPerCombo = 36 },
		},
		[GetSpellInfo(16511)] = {
			["Name"] = "Hemorrhage",
			[0] = { WeaponDamage = 1.1 },
			[1] = { 0 },
			[2] = { 0 },
			[3] = { 0 },
			[4] = { 0 },
			[5] = { 0 },
		},
		[GetSpellInfo(5938)] = {
			["Name"] = "Shiv",
			[0] = { WeaponDamage = 1, OffhandAttack = true, NoCrits = true, Unavoidable = true },
			[1] = { 0 },
		},
		[GetSpellInfo(32645)] = {
			["Name"] = "Envenom",
			[0] = { School = "Nature", ComboPoints = true, APBonus = { 0.09, 0.18, 0.27, 0.36, 0.45 } },
			[1] = { 117, DPBonus = 117 },
			[2] = { 147, DPBonus = 147 },
			[3] = { 175, DPBonus = 175 },
			[4] = { 215, DPBonus = 215 },
		},
		[GetSpellInfo(26679)] = {
			["Name"] = "Deadly Throw",
			[0] = { School = { "Physical", "Ranged" }, ComboPoints = true, WeaponDamage = 1, NoPoison = true, NoNormalization = true, },
			[1] = { 164, 180, PerCombo = 105 },
			[2] = { 223, 245, PerCombo = 142 },
			[3] = { 350, 386, PerCombo = 224 },
		},
		[GetSpellInfo(1329)] = {
			["Name"] = "Mutilate",
			[0] = { WeaponDamage = 1, DualAttack = true },
			[1] = { 44 },
			[2] = { 63 },
			[3] = { 88 },
			[4] = { 101 },
			[5] = { 153 },
			[6] = { 181 },
		},
		[GetSpellInfo(51723)] = {
			["Name"] = "Fan of Knives",
			[0] = { WeaponDamage = 0.7, DualAttack = true, Cooldown = 10, AoE = true, NoNormalization = true },
			[1] = { 0 },
		},
		[GetSpellInfo(51690)] = {
			["Name"] = "Killing Spree",
			[0] = { WeaponDamage = 1, DualAttack = true, Hits = 5 },
			[1] = { 0 },
		},
	}
	self.talentInfo = {
	--ASSASSINATION:
		--Improved Eviscerate (additive - 3.3.3)
		[GetSpellInfo(14162)] = {	[1] = { Effect = { 0.07, 0.14, 0.20 } , Spells = "Eviscerate" }, },
		--Remorseless Attacks
		[GetSpellInfo(14144)] = {	[1] = { Effect = 20, Spells = { "Sinister Strike", "Hemorrhage", "Backstab", "Mutilate", "Ambush", "Ghostly Strike" }, ModType = "Remorseless Attacks" }, },
		--Blood Spatter (additive - 3.3.3)
		[GetSpellInfo(51632)] = {	[1] = { Effect = 0.15, Spells = { "Rupture", "Garrote" } }, },
		--Puncturing Wounds
		[GetSpellInfo(13733)] = {	[1] = { Effect = 10, Spells = "Backstab", ModType = "critPerc" },
									[2] = { Effect = 5, Spells = "Mutilate", ModType = "critPerc" }, },
		--Lethality
		[GetSpellInfo(14128)] = {	[1] = { Effect = 0.06, Spells = { "Sinister Strike", "Gouge", "Backstab", "Ghostly Strike", "Mutilate", "Shiv", "Hemorrhage", "Riposte" }, ModType = "critM" }, },
		--Vile Poisons (additive - 3.3.3)
		[GetSpellInfo(16513)] = {	[1] = { Effect = { 0.07, 0.14, 0.20 }, Spells = "Envenom" },
									[2] = { Effect = { 0.07, 0.14, 0.20 }, Spells = "All", ModType = "Vile Poisons" }, },
		--Improved poisons
		[GetSpellInfo(14117)] = {	[1] = { Effect = 0.1, Spells = "All", ModType = "Improved Poisons" }, },
		--Improved Kidney Shot (multiplicative - 3.3.3. Poisons benefit.)
		[GetSpellInfo(14174)] = {	[1] = { Effect = 0.03, Spells = "All", ModType = "Improved Kidney Shot" }, },
		--Quick Recovery
		[GetSpellInfo(31244)] = {	[1] = { Effect = 1, Spells = "Lifeblood", ModType = "Lifeblood" }, },
		--Focused Attacks
		[GetSpellInfo(51634)] = {	[1] = { Effect = { 0.33, 0.66, 1 }, Spells = "All", Not = "Deadly Throw", ModType = "Focused Attacks" }, },
		--Find Weakness (additive - 3.3.3. Poisons and auto attack do not benefit.)
		[GetSpellInfo(31234)] = {	[1] = { Effect = 0.02, Spells = "All", Not = "Attack" }, },
	--COMBAT:
		--Dual Wield Specialization
		[GetSpellInfo(13715)] = {	[1] = { Effect = 0.1, Spells = { "Attack", "Mutilate", "Shiv", "Fan of Knives", "Killing Spree" }, ModType = "offHdmgM", Multiply = true }, NoManual = true, },
		--Precision
		[GetSpellInfo(13705)] = {	[1] = { Effect = 1, Spells = "All", ModType = "hitPerc" },
									[2] = { Effect = 1, Spells = "All", ModType = "spellHit" }, },
		--Aggression (additive - 3.3.3)
		[GetSpellInfo(18427)] = {	[1] = { Effect = 0.03, Spells = { "Sinister Strike", "Eviscerate", "Backstab" } }, },
		--Mace Specialization
		[GetSpellInfo(13709)] = {	[1] = { Effect = 0.03, Spells = "All", ModType = "Mace Specialization" }, },
		--Hack and Slash
		[GetSpellInfo(13964)] = {	[1] = { Effect = 0.01, Spells = { "Attack", "Sinister Strike", "Eviscerate", "Fan of Knives", "Envenom", "Shiv", "Ghostly Strike", "Gouge", "Rupture", "Hemorrhage" }, ModType = "Hack and Slash", }, },
		--Blade Twisting (additive - 3.3.3)
		[GetSpellInfo(31124)] = { 	[1] = { Effect = 0.05, Spells = { "Sinister Strike", "Backstab" } }, },
		--Surprise Attacks (additive - 3.3.3)
		[GetSpellInfo(32601)] = {	[1] = { Effect = 0.1, Spells = { "Sinister Strike", "Backstab", "Shiv", "Gouge", "Hemorrhage" } }, 
									[2] = { Effect = 1, Spells = { "Eviscerate", "Deadly Throw", "Envenom", "Rupture" }, ModType = "Surprise Attacks", }, },
		--Prey on the Weak (multiplicative - 3.3.3)
		[GetSpellInfo(51685)] = { 	[1] = { Effect = 0.04, Spells = "All", ModType = "Prey on the Weak" }, },
	--SUBTLETY:
		--Relentless Strikes
		[GetSpellInfo(14179)] = {	[1] = { Effect = 0.04, Spells = { "Eviscerate", "Deadly Throw", "Envenom", "Rupture" }, ModType = "Relentless Strikes", }, },
		--Opportunity (additive - 3.3.3)
		[GetSpellInfo(14057)] = {	[1] = { Effect = 0.1, Spells = { "Backstab", "Mutilate", "Garrote", "Ambush" } }, },
		--Serrated Blades (additive - 3.3.3)
		[GetSpellInfo(14171)] = {	[1] = { Effect = 0.1, Spells = "Rupture" },
									[2] = { Effect = 0.03, Spells = "All", ModType = "armorPen" }, },
		--Improved Ambush
		[GetSpellInfo(14079)] = {	[1] = { Effect = 25, Spells = "Ambush", ModType = "critPerc" }, },
		--Dirty Deeds (multiplicative?)
		[GetSpellInfo(14082)] = { 	[1] = { Effect = 0.1, Spells = "All", Not = "Attack", ModType = "Dirty Deeds" }, },
		--Sinister Calling (multiplicative - 3.3.3)
		[GetSpellInfo(31216)] = {	[1] = { Effect = 0.02, Spells = { "Backstab", "Hemorrhage" }, Multiply = true }, },
	}
end