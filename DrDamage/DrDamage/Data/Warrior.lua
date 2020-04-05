if select(2, UnitClass("player")) ~= "WARRIOR" then return end
local GetSpellInfo = GetSpellInfo
local math_min = math.min
local math_abs = math.abs
local select = select
local UnitPower = UnitPower
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitDamage = UnitDamage
local IsEquippedItemType = IsEquippedItemType
local GetShapeshiftForm = GetShapeshiftForm
local GetCritChance = GetCritChance

--NOTE; One-Handed Weapon Specialization is handled by API (7th return of UnitDamage("player"), Two-Handed Weapon Specialization is multiplied into weapon damage range

function DrDamage:PlayerData()
	--Health Updates
	self.TargetHealth = { [1] = 0.751, [0.751] = GetSpellInfo(772) }
	--Events
	local lastRage = 0
	local execute = GetSpellInfo(5308)
	function DrDamage:UNIT_RAGE(units)
		if units["player"] then
			local rage = UnitPower("player",1)
			if (rage < 30) and (lastRage > 30 or math_abs(rage - lastRage) >= 10) or (rage >= 30 and lastRage < 30) then
				lastRage = rage
				self:UpdateAB(execute)
			end
		end
	end	
	--Specials
	--Enraged Regeneration
	self.ClassSpecials[GetSpellInfo(55694)] = function()
		--Glyph of Enraged Regeneration (additive - 3.3.3)
		if self:HasGlyph(63327) then
			return 0.4 * UnitHealthMax("player"), true
		else
			return 0.3 * UnitHealthMax("player"), true
		end
	end
--TALENTS
	self.Calculation["Two-Handed Weapon Specialization"] = function( calculation, value, baseSpell )
		if self:GetNormM() == 3.3 and not baseSpell.NoWeapon then
			calculation.wDmgM = calculation.wDmgM * (1 + value)
			calculation.dmgM = calculation.dmgM * (1 + value)
		end
	end
	self.Calculation["Precision"] = function( calculation, value, baseSpell )
		if not baseSpell.NoWeapon then
			calculation.hitPerc = calculation.hitPerc + value
		end
	end
	self.Calculation["Improved Revenge"] = function( calculation, value )
		if calculation.targets >= 2 then
			calculation.aoe = 2
			calculation.aoeM = value
		end
	end
	self.Calculation["Weapon Mastery"] = function( calculation, value )
		calculation.dodgeMod = value
	end	
	local ohm = GetSpellInfo(198)
	local thm = GetSpellInfo(199)	
	self.Calculation["Mace Specialization"] = function( calculation, value )
		if IsEquippedItemType(ohm) or IsEquippedItemType(thm) then
			calculation.armorPen = calculation.armorPen + value
		end
	end	
--GENERAL
	local oha = GetSpellInfo(196)
	local tha = GetSpellInfo(197)
	local pol = GetSpellInfo(200)
	local ohs = GetSpellInfo(201)
	local ths = GetSpellInfo(202)
	local dwicon = "|T" .. select(3,GetSpellInfo(12867)) .. ":16:16:1:-1|t"
	local ssicon = "|T" .. select(3,GetSpellInfo(12815)) .. ":16:16:1:-1|t"
	self.Calculation["WARRIOR"] = function( calculation, ActiveAuras, Talents, spell, baseSpell )
		if ActiveAuras["Disarm"] and Talents["Improved Disarm"] then
			calculation.dmgM = calculation.dmgM * (1 + Talents["Improved Disarm"])
		end
		if Talents["Poleaxe Specialization"] then
			--Requires One-Handed Axes, Two-Handed Axes, Polearms
			--TODO: Fix crit multiplier error if only one of the weapons is an axe?
			if IsEquippedItemType(oha) or IsEquippedItemType(tha) or IsEquippedItemType(pol) then
				calculation.critM = calculation.critM * (1 + Talents["Poleaxe Specialization"])
			end
		end
		if GetShapeshiftForm() == 1 then
			calculation.armorPen = calculation.armorPen + 0.1 + ((self:GetSetAmount("T9 - Damage") >= 2) and 0.06 or 0)
		end
		if Talents["Deep Wounds"] and not calculation.NoCrits then
			if not calculation.unarmed or calculation.offHand and baseSpell.AutoAttack then
				calculation.extraDamage = 0
				calculation.extraWeaponDamage = Talents["Deep Wounds"] * calculation.bleedBonus
				calculation.extraWeaponDamage_dmgM = calculation.dmgM_global
				calculation.extraWeaponDamageChanceCrit = true
				calculation.extraName = dwicon
				calculation.extraTicks = 6
			end
			if calculation.offHand and baseSpell.AutoAttack then
				calculation.extraWeaponDamage_O = Talents["Deep Wounds"] * calculation.bleedBonus
				calculation.extraTicks = nil
			end
		end
		if Talents["Sword Specialization"] and not baseSpell.NoWeapon then
			calculation.extraTicks = nil
			calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. ssicon) or ssicon
			--Requires One-Handed Swords, Two-Handed Swords
			local mhType, ohType = self:GetWeaponType()
			local mh = (mhType == ohs) or (mhType == ths)
			local oh = (ohType == ohs) and baseSpell.AutoAttack
			if mh or oh then
				calculation.extraDamage = 0
				--Note: Cooldown not taken into account at the moment (except rough guesstimation of 7.5% on dual wield)
				local min, max = self:WeaponDamage(calculation, true)
				local value = 0.5 * (min + max)
				calculation.extra = value
				calculation.extraM = true
				calculation.extraChance = (mh and oh) and (1.5 * Talents["Sword Specialization"]) or Talents["Sword Specialization"]
				calculation.E_dmgM = calculation.dmgM_global
				calculation.E_canCrit = true
				calculation.E_critM = 1 + 2 * self.Damage_critMBonus
				calculation.E_critPerc = GetCritChance() + calculation.meleeCrit
			end
		end
	end
--ABILITIES
	self.Calculation["Heroic Strike"] = function( calculation, ActiveAuras, _, spell )
		if ActiveAuras["Dazed"] and spell.Daze then
			calculation.minDam = calculation.minDam + spell.Daze
			calculation.maxDam = calculation.maxDam + spell.Daze
		end
		--Glyph of Heroic Strike
		if self:HasGlyph(58357) then
			calculation.actionCost = calculation.actionCost - 10 * math_min(1, calculation.critPerc / 100)
		end
		if self:GetSetAmount("T9 - Damage") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Shield Slam"] = function( calculation, ActiveAuras, Talents )
		local dr = 24.5 * calculation.playerLevel --1960 at level 80
		local cap = 39.5 * calculation.playerLevel --3160 at level 80
		local bv = calculation.blockValue
		local bonus = 0
		if ActiveAuras["Shield Block"] then
			local mult = self.MetaGem_BlockBonus + (Talents["Shield Mastery"] or 0) + (ActiveAuras["Glyph of Blocking"] and 0.1 or 0)
			bonus = bv / (2 + mult)
			bv = bonus * (1 + mult)
			--TODO: Improve this?
			if Talents["Shield Mastery"] and bv > dr then
				bonus = bonus * (1 + math_min(0.13,(bv - dr) * 0.055))
			end
		end
		if bv > dr then
			--At level 80 true bonus is 2072 with 3160 blockvalue. 112 effective block value from 1200 block value.
			bv = math_min(cap, bv)
			bv = dr + (bv - dr) * (112/1200)
		end
		calculation.minDam = calculation.minDam + bv + bonus
		calculation.maxDam = calculation.maxDam + bv + bonus
		calculation.coeff = (bv + bonus) / calculation.blockValue
		calculation.coeffv = calculation.blockValue
		if self:GetSetAmount("T7 - Prot") >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
		if self:GetSetAmount( "T10 - Prot" ) >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Devastate"] = function( calculation, ActiveAuras, _, spell )
		local bonus = (ActiveAuras["Sunder Armor"] and math_min(5, ActiveAuras["Sunder Armor"] + 1) or 1) * spell.sunderDmg
		calculation.minDam = calculation.minDam + bonus
		calculation.maxDam = calculation.maxDam + bonus
		if self:GetSetAmount("T8 - Prot") >= 2 then
			calculation.critPerc = calculation.critPerc + 10
		end
		if self:GetSetAmount("T9 - Prot") >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.05
		end
	end
	self.Calculation["Execute"] = function( calculation, ActiveAuras )
		--Glyph of Execution
		if self:HasGlyph(58367) then
			calculation.extraPowerBonus = 10
		end
		if ActiveAuras["Sudden Death"] then
			calculation.actionCost = calculation.actionCost - select(ActiveAuras["Sudden Death"], 3, 7, 10)
		end
		calculation.maxCost = 30 - calculation.baseCost
	end
	self.Calculation["Cleave"] = function( calculation )
		--Glyph of Cleaving
		if self:HasGlyph(58366) then
			calculation.aoe = calculation.aoe + 1
		end
	end
	self.Calculation["Mocking Blow"] = function( calculation )
		--Glyph of Mocking Blow (TODO: A/M - doesn't matter currently)
		if self:HasGlyph(58099) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.25
		end
	end
	self.Calculation["Mortal Strike"] = function( calculation )
		--Glyph of Mortal Strike (additive - 3.3.3)
		if self:HasGlyph(58368) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
		if self:GetSetAmount("T8 - Damage") >= 4 then
			calculation.critPerc = calculation.critPerc + 10
		end
	end
	self.Calculation["Rend"] = function( calculation, _, _, spell )
		--Glyph of Rending
		if self:HasGlyph(58385) then
			calculation.eDuration = calculation.eDuration + 6
		end
		--Multiplicative - 3.3.3
		if spell.healthBonus and (UnitHealth("target") / UnitHealthMax("target")) > 0.75 then
			calculation.dmgM = calculation.dmgM * (1 + spell.healthBonus)
		end
	end
	self.Calculation["Bloodthirst"] = function( calculation )
		if self:GetSetAmount("T8 - Damage") >= 4 then
			calculation.critPerc = calculation.critPerc + 10
		end
	end
	self.Calculation["Slam"] = function( calculation )
		if self:GetSetAmount("T7 - Damage") >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
		if self:GetSetAmount("T9 - Damage") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Shockwave"] = function( calculation )
		--Glyph of Shockwave
		if self:HasGlyph(63325) then
			calculation.cooldown = calculation.cooldown - 3
		end
		if self:GetSetAmount( "T10 - Prot" ) >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Victory Rush"] = function( calculation )
		--Glyph of Victory Rush
		if self:HasGlyph(58382) then
			calculation.critPerc = calculation.critPerc + 30
		end
	end
	self.Calculation["Whirlwind"] = function( calculation )
		--Glyph of Whirlwind
		if self:HasGlyph(58370) then
			calculation.cooldown = calculation.cooldown - 2
		end
	end
	self.Calculation["Bladestorm"] = function( calculation )
		--Glyph of Bladestorm
		if self:HasGlyph(63324) then
			calculation.cooldown = calculation.cooldown - 15
		end
	end
--SETS
	self.SetBonuses["T7 - Damage"] = { 40525, 40527, 40528, 40529, 40530, 39605, 39606, 39607, 39608, 39609 }
	self.SetBonuses["T7 - Prot"] = { 40544, 40545, 40546, 40547, 40548, 39610, 39611, 39612,  39613,  39622  }
	self.SetBonuses["T8 - Damage"] = { 46146, 46148, 46149, 46150, 46151, 45429, 45430, 45431, 45432, 45433 }
	self.SetBonuses["T8 - Prot"] = { 46162, 46164, 46166, 46167, 46169, 45424, 45425, 45426, 45427, 45428 }
	self.SetBonuses["T9 - Damage"] = { 48386, 48387, 48388, 48389, 48390, 48371, 48372, 48373, 48374, 48375, 48391, 48392, 48393, 48394, 48395, 48396, 48397, 48398, 48399, 48400, 48376, 48377, 48378, 48379, 48380, 48385, 48384, 48383, 48382, 48381 }
	self.SetBonuses["T9 - Prot"] = { 48456, 48457, 48458, 48459, 48460, 48429, 48436, 48445, 48448, 48449, 48450, 48430, 48452, 48446, 48454, 48451, 48433, 48453, 48447, 48455, 48461, 48463, 48462, 48464, 48465, 48466, 48468, 48467, 48469, 48470 }
	self.SetBonuses["T10 - Prot"] = { 50846, 50847, 50849, 50848, 50850, 51215, 51224, 51216, 51223, 51217, 51222, 51218, 51221, 51219, 51220    }
--AURA
--Player
	--Revenge
	self.PlayerAura[GetSpellInfo(37517)] = { Value = 0.1, ID = 37517 }
	--Juggernaut
	self.PlayerAura[GetSpellInfo(65156)] = { Value = 25, ModType = "critPerc", Spells = { 1464, 12294 }, ID = 65156 }
	--Shield Block
	self.PlayerAura[GetSpellInfo(2565)] = { Spells = 23922, ActiveAura = "Shield Block", NoManual = true }
	--Recklessness
	self.PlayerAura[GetSpellInfo(1719)] = { Value = 100, ModType = "critPerc", ID = 1719, Not = { "Attack", "Shockwave", "Concussion Blow", "Heroic Throw", "Shattering Throw", "Thunder Clap" } }
	--Glyph of Blocking
	self.PlayerAura[GetSpellInfo(58374)] = { Spells = 23922, ActiveAura = "Glyph of Blocking", NoManual = true }
	
	
--Target
	--Dazed
	self.TargetAura[GetSpellInfo(1604)] = { ActiveAura = "Dazed", Spells = 78, ID = 1604 }
	--Disarm
	self.TargetAura[GetSpellInfo(676)] = { ActiveAura = "Disarm", ID = 676 }
	--Sudden Death
	self.TargetAura[GetSpellInfo(29723)] = { ActiveAura = "Sudden Death", Ranks = 3, Spells = 5308, ID = 29723 }
	--Sunder Armor
	self.TargetAura[GetSpellInfo(7386)] = { ActiveAura = "Sunder Armor", Apps = 5, Value = 0.04, ModType = "armorM", Category = "-20% Armor", Manual = GetSpellInfo(7386), ID = 7386 }

	self.spellInfo = {
		[GetSpellInfo(78)] = {
			["Name"] = "Heroic Strike",
			[0] = { WeaponDamage = 1, NextMelee = true, NoNormalization = true },
			[1] = { 11, },
			[2] = { 21, },
			[3] = { 32, },
			[4] = { 44, },
			[5] = { 60, },
			[6] = { 93, },
			[7] = { 136, },
			[8] = { 178, },
			[9] = { 201, },
			[10] = { 234, Daze = 81.9 },
			[11] = { 317, Daze = 110.95 },
			[12] = { 432, Daze = 151.2 },
			[13] = { 495, Daze = 173.25 },
		},
		[GetSpellInfo(772)] = {
			["Name"] = "Rend",
			[0] = { WeaponDamage = 1, NoCrits = true, eDuration = 15, Ticks = 3, NoNormalization = true, Bleed = true },
			[1] = { 25 },
			[2] = { 40 },
			[3] = { 50 },
			[4] = { 70 },
			[5] = { 115 },
			[6] = { 150 },
			[7] = { 185 },
			[8] = { 215 },
			[9] = { 315, healthBonus = 0.35 },
			[10] = { 380, healthBonus = 0.35 },
		},
		[GetSpellInfo(7384)] = {
			["Name"] = "Overpower",
			[0] = { WeaponDamage = 1, Unavoidable = true },
			[1] = { 0 },
		},
		[GetSpellInfo(6572)] = {
			["Name"] = "Revenge",
			[0] = { APBonus = 0.31, Cooldown = 5, },
			[1] = { 99, 121, },
			[2] = { 145, 177, },
			[3] = { 197, 239, },
			[4] = { 360, 440, },
			[5] = { 561, 685, },
			[6] = { 723, 883, },
			[7] = { 786, 960, },
			[8] = { 963, 1175, },
			[9] = { 1636, 1998, },
		},
		[GetSpellInfo(694)] = {
			["Name"] = "Mocking Blow",
			[0] = { WeaponDamage = 1 },
			[1] = { 0 },
		},
		[GetSpellInfo(6343)] = {
			["Name"] = "Thunder Clap",
			[0] = { APBonus = 0.12, NoWeapon = true, AoE = true, Unavoidable = true },
			[1] = { 15 },
			[2] = { 34 },
			[3] = { 55 },
			[4] = { 82 },
			[5] = { 123 },
			[6] = { 154 },
			[7] = { 184 },
			[8] = { 247 },
			[9] = { 300 },
		},
		[GetSpellInfo(845)] = {
			["Name"] = "Cleave",
			[0] = { WeaponDamage = 1, AoE = 2, NextMelee = true, NoNormalization = true },
			[1] = { 15 },
			[2] = { 30 },
			[3] = { 50 },
			[4] = { 70 },
			[5] = { 95 },
			[6] = { 135 },
			[7] = { 189 },
			[8] = { 222 },
		},
		[GetSpellInfo(5308)] = {
			["Name"] = "Execute",
			[0] = { APBonus = 0.2 },
			[1] = { 93, PowerBonus = 3 },
			[2] = { 159, PowerBonus = 6 },
			[3] = { 282, PowerBonus = 9 },
			[4] = { 404, PowerBonus = 12 },
			[5] = { 554, PowerBonus = 15 },
			[6] = { 687, PowerBonus = 18 },
			[7] = { 865, PowerBonus = 21 },
			[8] = { 1142, PowerBonus = 30 },
			[9] = { 1456, PowerBonus = 38 },
		},
		[GetSpellInfo(20252)] = {
			["Name"] = "Intercept",
			[0] = { APBonus = 0.12, Cooldown = 30, NoWeapon = true },
			[1] = { 0 },
		},
		[GetSpellInfo(1464)] = {
			["Name"] = "Slam",
			[0] = { WeaponDamage = 1, castTime = 1.5, NoNormalization = true },
			[1] = { 32 },
			[2] = { 43 },
			[3] = { 68 },
			[4] = { 87 },
			[5] = { 105 },
			[6] = { 140 },
			[7] = { 220 },
			[8] = { 250 },
		},
		[GetSpellInfo(23881)] = {
			["Name"] = "Bloodthirst",
			[0] = { APBonus = 0.5, Cooldown = 5 },
			[1] = { 0 },
		},
		[GetSpellInfo(12294)] = {
			["Name"] = "Mortal Strike",
			[0] = { WeaponDamage = 1, Cooldown = 6 },
			[1] = { 85 },
			[2] = { 110 },
			[3] = { 135 },
			[4] = { 160 },
			[5] = { 185 },
			[6] = { 210 },
			[7] = { 320 },
			[8] = { 380 },
		},
		[GetSpellInfo(23922)] = {
			["Name"] = "Shield Slam",
			[0] = { Offhand = select(7, GetItemInfo(40700)), NoWeapon = true }, --Fix for "Shields" translation
			[1] = { 294, 308, },
			[2] = { 346, 362, },
			[3] = { 396, 416, },
			[4] = { 447, 469, },
			[5] = { 499, 523, },
			[6] = { 549, 577, },
			[7] = { 837, 879, },
			[8] = { 990, 1040, },
		},
		[GetSpellInfo(20243)] = {
			["Name"] = "Devastate",
			[0] = { WeaponDamage = 1.2, },
			[1] = { 0, sunderDmg = 58 },
			[2] = { 0, sunderDmg = 96 },
			[3] = { 0, sunderDmg = 134 },
			[4] = { 0, sunderDmg = 204 },
			[5] = { 0, sunderDmg = 242 },
		},
		[GetSpellInfo(34428)] = {
			["Name"] = "Victory Rush",
			[0] = { APBonus = 0.45, NoWeapon = true },
			[1] = { 0 },
		},
		[GetSpellInfo(46968)] = {
			["Name"] = "Shockwave",
			[0] = { APBonus = 0.75, NoWeapon = true, AoE = true, Unavoidable = true },
			[1] = { 0 },
		},
		[GetSpellInfo(1680)] = {
			["Name"] = "Whirlwind",
			[0] = { WeaponDamage = 1, DualAttack = true, Cooldown = 10, AoE = 4 },
			[1] = { 0 },
		},
		[GetSpellInfo(46924)] = {
			["Name"] = "Bladestorm",
			[0] = { WeaponDamage = 1, DualAttack = true, Cooldown = 90, Hits = 7, AoE = 4 },
			[1] = { 0 },
		},
		[GetSpellInfo(12809)] = {
			["Name"] = "Concussion Blow",
			[0] = { APBonus = 0.38 },
			[1] = { 0 },
		},
		[GetSpellInfo(57755)] = {
			["Name"] = "Heroic Throw",
			[0] = { APBonus = 0.5, Cooldown = 60 },
			[1] = { 12 },
		},
		[GetSpellInfo(64382)] = {
			["Name"] = "Shattering Throw",
			[0] = { APBonus = 0.5, Cooldown = 300 },
			[1] = { 12 },
		},
	}
	self.talentInfo = {
	--ARMS:
		--Improved Rend (additive/multiplicative? - doesn't matter currently)
		[GetSpellInfo(12286)] = {	[1] = { Effect = 0.1, Spells = "Rend" }, },
		--Improved Overpower
		[GetSpellInfo(12290)] = {	[1] = { Effect = 25, Spells = "Overpower", ModType = "critPerc" }, },
		--Impale (additive - 3.3.3)
		[GetSpellInfo(16493)] = {	[1] = { Effect = 0.1, Spells = "All", ModType = "critM", Not = "Attack" }, },
		--Deep Wounds
		[GetSpellInfo(12867)] = {	[1] = { Effect = 0.16, Spells = "All", ModType = "Deep Wounds", }, },
		--Two-Handed Weapon Specialization
		[GetSpellInfo(12163)] = {	[1] = { Effect = 0.02, Spells = "All", ModType = "Two-Handed Weapon Specialization" }, },
		--Poleaxe Specialization (multiplicative - 3.3.3)
		[GetSpellInfo(12700)] = {	[1] = { Effect = 0.02, Spells = "All", Not = "Thunder Clap", ModType = "Poleaxe Specialization", }, },
		--Mace Specialization
		[GetSpellInfo(12284)] = {	[1] = { Effect = 0.03, Spells = "All", ModType = "Mace Specialization" }, },
		--Sword Specialization
		[GetSpellInfo(12281)] = {	[1] = { Effect = 0.02, Spells = "All", ModType = "Sword Specialization", }, },
		--Weapon Mastery
		[GetSpellInfo(20504)] = {	[1] = { Effect = 1, Spells = "All", ModType = "Weapon Mastery", }, },
		--Improved Mortal Strike (additive - 3.3.3)
		[GetSpellInfo(35446)] = {	[1] = { Effect = { 0.03, 0.06, 0.1 }, Spells = "Mortal Strike", },
									[2] = { Effect = { -0.333, -0.666, -1 }, Multiply = true, Spells = "Mortal Strike", ModType = "cooldown" }, },
		--Unrelenting Assault (additive - 3.3.3)
		[GetSpellInfo(46859)] = {	[1] = { Effect = -2, Spells = { "Overpower", "Revenge" }, ModType = "cooldown" },
									[2] = { Effect = 0.1, Spells = { "Overpower", "Revenge" }, }, },
		--Endless Rage
		[GetSpellInfo(29623)] = {	[1] = { Effect = 0.25, Spells = { "Heroic Strike", "Cleave" }, ModType = "rageBonus" }, },
	--FURY:
		--Improved Cleave
		[GetSpellInfo(12329)] = {	[1] = { Effect = 0.4, Spells = "Cleave", ModType = "bDmgM", Multiply = true }, },
		--Dual Wield Specialization
		[GetSpellInfo(23584)] = {	[1] = { Effect = 0.05, Spells = "All", ModType = "offHdmgM", Multiply = true  }, NoManual = true },
		--Precision, TODO: Does this apply to everything?
		[GetSpellInfo(29590)] = {	[1] = { Effect = 1, Spells = "All", ModType = "Precision" }, },
		--Improved Intercept
		[GetSpellInfo(29888)] = {	[1] = { Effect = -5, Spells = "Intercept", ModType = "cooldown" }, },
		--Improved Whirlwind (additive - 3.3.3)
		[GetSpellInfo(29721)] = {	[1] = { Effect = 0.1, Spells = "Whirlwind" }, },
		--Unending Fury (additive - 3.3.3)
		[GetSpellInfo(56927)] = {	[1] = { Effect = 0.02, Spells = { "Slam", "Whirlwind", "Bloodthirst", } }, },
	--PROTECTION:
		--Improved Thunder Clap (additive/multiplicative? - currently doesn't matter)
		[GetSpellInfo(12287)] = {	[1] = { Effect = 0.1, Spells = "Thunder Clap" }, },
		--Incite
		[GetSpellInfo(50685)] = {	[1] = { Effect = 5, Spells = { "Heroic Strike", "Thunder Clap", "Cleave" }, ModType = "critPerc" }, },
		--Improved Revenge (additive - 3.3.3)
		[GetSpellInfo(12797)] = {	[1] = { Effect = 0.3, Spells = "Revenge" }, 
									[2] = { Effect = 0.5, Spells = "Revenge", ModType = "Improved Revenge" }, },
		--Shield Mastery
		[GetSpellInfo(29598)] = {	[1] = { Effect = 0.15, Spells = "Shield Slam", ModType = "Shield Mastery" }, },
		--Improved Disarm (multiplicative - 3.3.3)
		[GetSpellInfo(12313)] = {	[1] = { Effect = 0.05, Spells = "All", ModType = "Improved Disarm"  }, },
		--Gag Order
		[GetSpellInfo(12311)] = {	[1] = { Effect = 0.05, Spells = "Shield Slam" }, },
		--Critical Block
		[GetSpellInfo(47294)] = {	[1] = { Effect = 5, Spells = "Shield Slam", ModType = "critPerc" }, },
		--Sword and Board
		[GetSpellInfo(46951)] = {	[1] = { Effect = 5, Spells = "Devastate", ModType = "critPerc" }, },
	}
end