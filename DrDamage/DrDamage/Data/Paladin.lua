if select(2, UnitClass("player")) ~= "PALADIN" then return end
local GetSpellInfo = GetSpellInfo
local GetTrackingTexture = GetTrackingTexture
local GetSpellBonusDamage = GetSpellBonusDamage
local math_floor = math.floor
local math_min = math.min
local string_match = string.match
local string_find = string.find
local string_lower = string.lower
local tonumber = tonumber
local select = select
local pairs = pairs
local UnitBuff = UnitBuff
local UnitHealthMax = UnitHealthMax
local UnitPowerMax = UnitPowerMax
local UnitCreatureType = UnitCreatureType

--NOTE: One-Handed Weapon Specialization is handled by API (7th return of UnitDamage("player"), Two-Handed Weapon Specialization is multiplied into weapon damage range

function DrDamage:PlayerData()
	local horde = (UnitFactionGroup("player") == "Horde")
	--Lay on Hands
	self.ClassSpecials[GetSpellInfo(633)] = function()
		return UnitHealthMax("player"), true
	end
	--Divine Plea
	self.ClassSpecials[GetSpellInfo(54428)] = function()
		return 0.25 * UnitPowerMax("player",0), false, true
	end
	--Seal of Wisdom
	self.ClassSpecials[GetSpellInfo(20166)] = function()
		return 0.04 * UnitPowerMax("player",0), false, true
	end
	--Seal of Light
	self.ClassSpecials[GetSpellInfo(20165)] = function()
		local AP = 0.15 * self:GetAP()
		local SP = 0.15 * GetSpellBonusDamage(2)
		return AP + SP, true
	end
--GENERAL
	--Sense Undead
	local undead = string_lower(GetSpellInfo(5502))
	local solicon = "|T" .. select(3,GetSpellInfo(53501)) .. ":16:16:1:-1|t"
	local rvicon = "|T" .. select(3,GetSpellInfo(53380)) .. ":16:16:1:-1|t"
	self.Calculation["PALADIN"] = function( calculation, ActiveAuras, Talents, spell, baseSpell )
		if not baseSpell.Melee then
			if calculation.healingSpell then
				if Talents["Improved Devotion Aura"] and ActiveAuras["Improved Devotion Aura"] and not ActiveAuras["+6% Healing"] then
					--Multiplicative - 3.3.3
					calculation.dmgM = calculation.dmgM * (1 + Talents["Improved Devotion Aura"])
					ActiveAuras["+6% Healing"] = true
				end
				if self:GetSetAmount( "T10 Holy" ) >= 2 and ActiveAuras["Divine Illumination"] then
					--Multiplicative - 3.3.2
					calculation.dmgM = calculation.dmgM * 1.35
				end
				if Talents["Sheath of Light"] then
					calculation.extraCrit = Talents["Sheath of Light"]
					calculation.extraTicks = 4
					calculation.extraChanceCrit = true
					calculation.extraName = solicon
				end
			end
		else
			if calculation.group == "Judgement" then
				--Glyph of Judgement
				if self:HasGlyph(54922) then
					--Additive - 3.3.3
					calculation.dmgM_Add = calculation.dmgM_Add + 0.1
				end
				if self:GetSetAmount( "T7 Protection" ) >= 4 then
					calculation.cooldown = calculation.cooldown - 1
				end
				if self:GetSetAmount( "PvP Retri" ) >= 4 then
					calculation.cooldown = calculation.cooldown - 1
				end
				if self:GetSetAmount( "T9 Retribution" ) >= 4 then
					calculation.critPerc = calculation.critPerc + 5
				end
				if self:GetSetAmount( "T10 Retribution" ) >= 4 then
					calculation.dmgM_Add = calculation.dmgM_Add + 0.1
				end
			end
			if calculation.group == "Seal" then
				if self:GetSetAmount( "T10 Retribution" ) >= 4 then
					if calculation.spellName == "Seal of Vengeance" or calculation.spellName == "Seal of Corruption" then
						calculation.dmgM_dd_Add = calculation.dmgM_dd_Add + 0.1
					else
						calculation.dmgM_Add = calculation.dmgM_Add + 0.1
					end
				end
			end
			if Talents["Righteous Vengeance"] then
				calculation.extraDamage = 0
				calculation.extraChanceCrit = true
				calculation.extraCrit = Talents["Righteous Vengeance"]
				calculation.extraTicks = 4
				calculation.extraName = rvicon
				if self:GetSetAmount( "T9 Retribution" ) >= 2 then
					calculation.extra_canCrit = true
				end
			end
		end
		if self:HasGlyph(57947) and (GetTrackingTexture() == "Interface\\Icons\\Spell_Holy_SenseUndead") and not calculation.healingSpell then
			local target = UnitCreatureType("target")
			if target and string_find(undead,string_lower(target)) then
				--Multiplicative - 3.3.3
				calculation.dmgM = calculation.dmgM * 1.01
			end
		end
	end
--TALENTS
	self.Calculation["Two-Handed Weapon Specialization"] = function( calculation, value )
		if self:GetNormM() == 3.3 then
			calculation.wDmgM = calculation.wDmgM * (1 + value)
			calculation.dmgM = calculation.dmgM * (1 + value)
		end
	end
	--Sense Undead, Sense Demons, Track Humanoids, Track Elementals
	local crusade = string_lower(GetSpellInfo(5503) .. GetSpellInfo(5500) .. GetSpellInfo(19883) .. GetSpellInfo(19880))
	self.Calculation["Crusade"] = function( calculation, talentValue )
		if not calculation.healingSpell then
			local target = UnitCreatureType("target")
			if target and string_find(crusade, string_lower(target)) then
				--Multiplicative - 3.3.3
				calculation.dmgM = calculation.dmgM * ( 1 + talentValue )
			end
		end
	end
	self.Calculation["Divinity"] = function( calculation, value )
		--Multiplicative - 3.3.3
		calculation.dmgM = calculation.dmgM * (1 + value)
		if calculation.target == "player" then
			calculation.dmgM = calculation.dmgM * (1 + value)
		end
	end
--ABILITIES
	self.Calculation["Flash of Light"] = function( calculation, ActiveAuras, Talents )
		--PvP Healer Glove Flash of Light Bonus
		if self:GetSetAmount( "PvP Healing Gloves" ) >= 1 then
			calculation.critPerc = calculation.critPerc + 2
		end
		--Glyph of Flash of Light
		if self:HasGlyph(54936) then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Shield of Righteousness"] = function( calculation, ActiveAuras, Talents )
		local dr = 30 * calculation.playerLevel
		local cap = 34.5 * calculation.playerLevel
		local bv = calculation.blockValue
		if ActiveAuras["Aegis"] then
			bv = bv - math_floor(225 * (1 + (Talents["Redoubt"] or 0)))
		end
		if bv > dr then
			bv = math_min(cap,  bv)
			bv = bv - 0.0042901155466318 * (bv - dr) ^ 1.70387168889193
		end
		if self:GetSetAmount( "T8 Protection" ) >= 4 then
			bv = bv + 225
		end
		calculation.coeff = bv / calculation.blockValue	
		calculation.coeffv = calculation.blockValue
		calculation.minDam = calculation.minDam + bv
		calculation.maxDam = calculation.maxDam + bv
	end
	self.Calculation["Avenger's Shield"] = function( calculation, _, _, baseSpell )
		if self:HasGlyph(54930) then
			--Glyph of Avenger's Shield
			calculation.dmgM = calculation.dmgM * 2
			baseSpell.chainFactor = nil
		end
	end
	--Sense Undead, Sense Demons
	local exorcism = string_lower(GetSpellInfo(5503) .. GetSpellInfo(5500))
	self.Calculation["Exorcism"] = function( calculation )
		local target = UnitCreatureType("target")
		if target and string_find(exorcism, string_lower(target)) then
			calculation.critPerc = 100
		end
		--Glyph of Exorcism (additive - 3.3.3)
		if self:HasGlyph(54934) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
		--Additive - 3.3.0
		if self:GetSetAmount( "T8 Retribution" ) >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
	end
	self.Calculation["Hammer of the Righteous"] = function( calculation )
		local min, max = self:GetMainhandBase()
		local spd = self:GetWeaponSpeed()
		if min > 0 then
			calculation.minDam = calculation.minDam + ((min+max)/(2 * spd)) * 4
			calculation.maxDam = calculation.minDam
		else
			calculation.zero = true
		end
		--Glyph of Hammer of the Righteous
		if self:HasGlyph(63219) then
			calculation.aoe = calculation.aoe + 1
		end
		--TODO: Additive/multiplicative? - currently doesn't matter
		if self:GetSetAmount( "T7 Protection" ) >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
		if self:GetSetAmount( "T9 Protection" ) >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.05
		end
		if self:GetSetAmount( "T10 Protection" ) >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Consecration"] = function( calculation )
		--Glyph of Consecration
		if self:HasGlyph(54928) then
			calculation.eDuration = calculation.eDuration + 2
			calculation.cooldown = calculation.cooldown + 2
		end
	end
	self.Calculation["Holy Shock"] = function( calculation )
		--Glyph of Holy Shock
		if self:HasGlyph(63224) then
			calculation.cooldown = calculation.cooldown - 1
		end
		if calculation.healingSpell then 
			if self:GetSetAmount( "PvP Healing" ) >= 4 then
				--Additive - 3.3.3
				calculation.dmgM_Add = calculation.dmgM_Add + 0.1
			end
			if self:GetSetAmount( "T8 Holy" ) >= 2 then
				calculation.extraCrit = (calculation.extraCrit or 0) + 0.15
				calculation.extraChanceCrit = true
				if calculation.extraTicks then
					calculation.extraTicks = nil
				else
					calculation.extraTicks = 3
				end
				calculation.extraName = calculation.extraName and (calculation.extraName .. "+2T8") or "2T8"
			end			
		end
		if self:GetSetAmount( "T7 Holy" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 10
		end
	end
	self.Calculation["Holy Wrath"] = function( calculation, _ , Talents )
		--Glyph of Holy Wrath
		if self:HasGlyph(56420) then
			calculation.cooldown = calculation.cooldown - 15
		end
		if Talents["Purifying Power"] then
			calculation.cooldown = calculation.cooldown * (1 + Talents["Purifying Power"])
		end
	end
	self.Calculation["Crusader Strike"] = function( calculation )
		if self:GetSetAmount( "PvP Retri Gloves" ) >= 1 then
			--Additive - 3.3.3
			calculation.dmgM_Add = calculation.dmgM_Add + 0.05
		end
		if self:GetSetAmount( "T8 Retribution" ) >= 4 then
			calculation.critPerc = calculation.critPerc + 10
		end
	end
	self.Calculation["Divine Storm"] = function( calculation )
		if self:GetSetAmount( "T7 Retribution" ) >= 2 then
			--Not verified
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
		if self:GetSetAmount( "T8 Retribution" ) >= 4 then
			calculation.critPerc = calculation.critPerc + 10
		end
	end
	self.Calculation["Hammer of Wrath"] = function( calculation )
		--Additive - 3.3.0
		if self:GetSetAmount( "T8 Retribution" ) >= 2 then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
	end
	self.Calculation["Sacred Shield"] = function( calculation )
		if self:GetSetAmount( "T8 Holy" ) >= 4 then
			calculation.spellDmgM = calculation.spellDmgM + 0.1
		end
		calculation.dmgM = (1 + (calculation.dmgM_absorb or 0)) * self.healingMod
	end
--SEALS AND JUDGEMENTS
	self.Calculation["Seal of Righteousness"] = function( calculation )
		--Glyph of Seal of Righteousness (additive - 3.3.3)
		if self:HasGlyph(56414) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
		if self:GetSetAmount( "T8 Protection" ) >= 2 then
			--TODO: A/M?
			calculation.dmgM = calculation.dmgM_Add + 0.1
		end
		local spd = self:GetWeaponType() and self:GetWeaponSpeed() or 2
		calculation.APBonus = spd * 0.022
		calculation.SPBonus = spd * 0.044
	end
	if horde then
		local bc = "|T" .. select(3,GetSpellInfo(53742)) .. ":16:16:1:-1|t"
		self.Calculation["Seal of Corruption"] = function( calculation, ActiveAuras )
			local number = ActiveAuras["Blood Corruption"] or 1
			calculation.extraDamage = number * 0.125
			calculation.extraDamageSP = number * 0.065
			calculation.extraName = number .. "x" .. bc
			calculation.WeaponDamage = math_min(1,((ActiveAuras["Blood Corruption"] or 0)/5)) * 0.33
			calculation.WeaponDPS = true
			if self:GetSetAmount( "T8 Protection" ) >= 2 then
				--TODO: A/M?
				calculation.dmgM_Add = calculation.dmgM_Add + 0.1
			end
		end
		self.Calculation["Judgement of Corruption"] = function( calculation, ActiveAuras )
			if ActiveAuras["Blood Corruption"] then
				calculation.dmgM = calculation.dmgM * (1 + 0.1 * ActiveAuras["Blood Corruption"])
			end
		end
	else
		local hv = "|T" .. select(3,GetSpellInfo(31803)) .. ":16:16:1:-1|t"
		self.Calculation["Seal of Vengeance"] = function( calculation, ActiveAuras )
			local number = ActiveAuras["Holy Vengeance"] or 1
			calculation.extraDamage = number * 0.125
			calculation.extraDamageSP = number * 0.065
			calculation.extraName = number .. "x" .. hv
			calculation.WeaponDamage = math_min(1,((ActiveAuras["Holy Vengeance"] or 0)/5)) * 0.33
			calculation.WeaponDPS = true
			if self:GetSetAmount( "T8 Protection" ) >= 2 then
				--TODO: A/M?
				calculation.dmgM_Add = calculation.dmgM_Add + 0.1
			end
		end
		self.Calculation["Judgement of Vengeance"] = function( calculation, ActiveAuras )
			if ActiveAuras["Holy Vengeance"] then
				calculation.dmgM = calculation.dmgM * (1 + 0.1 * ActiveAuras["Holy Vengeance"])
			end
		end
	end
--RELICS
	--Libram of the Eternal Rest, Libram of Resurgence
	self.RelicSlot["Consecration"] = { 27917, 47, 40337, 141 }
	--Libram of Righteous Power, Libram of Radiance
	self.RelicSlot["Crusader Strike"] = { 31033, 24.75, 40191, 78.75 }
	self.RelicSlot["Flash of Light"] = {
		--Savage, Hateful, Deadly, Furious, Relentless, Wrathful
		--42612, 204, 42613, 293, 42614, 331, 42615, 375, 42616, 436,  51472, 510,
		--NOTE: For some reason most librams have a ~0.805 coefficient
		42612, 204, 42613, 236, 42614, 267, 42615, 303, 42616, 352,  51472, 510,
		--Libram of Souls Redeemed, Libram of Light, Blessed Book of Nagrand, Libram of Divinity,
		28592, 89, 23006, 43, 25644, 79, 23201, 28,
		ModTypeAll = "Base"
	}
	--Libram of the Lightbringer, Libram of Tolerance, Libram of the Resolute,
	self.RelicSlot["Holy Light"] = { 28296, 47, 40268, 141, 45436, 160, }
	--Libram of Divine Purpose
	self.RelicSlot["Seal of Rightenousness"] = { 33504, 94, ModType1 = "spellDmg" }
	self.RelicSlot["Judgement of Righteousness"] = { 33504, 94, ModType1 = "spellDmg" }
	--Libram of Wracking
	self.RelicSlot["Exorcism"] = { 28065, 120 }
	self.RelicSlot["Holy Wrath"] = { 28065, 120 }
	--Libram of Discord, Venture Co. Libram of Retribution
	self.RelicSlot["Divine Storm"] = { 45510, 235, 38362, 81, ModType2 = "finalMod" }
	--Venture Co. Libram of Mostly Holy Deeds
	self.RelicSlot["Holy Shock"] = { 38364, 69, ModType1 = "finalMod" }
	--Venture Co. Libram of Protection
	self.RelicSlot["Shield of Righteousness"] = { 38363, 96, ModType1 = "finalMod" }
--SETS
	self.SetBonuses["PvP Healing Gloves"] = {
		--Savage, Hateful, Deadly, Furious, Relentless, Wrathful
		40918, 40925, 40926, 40927, 40928, 40928, 51459,
	}
	self.SetBonuses["PvP Healing"] = { 
	--Savage Gladiators'
	40898, 40918, 40930, 40936, 40960,
	--Hateful Gladiator's
	40904, 40925, 40931, 40937, 40961,	
	--Deadly Gladiator's
	40905, 40926, 40932, 40938, 40962,
	--Furious Gladiator's
	40907, 40927, 40933, 40939, 40963,
	--Relentess Gladiator's
	40910, 40928, 40934, 40940, 40964,
	--Wrathful Gladiator's
	51468, 51469, 51470, 51471, 51473,
	}
	self.SetBonuses["PvP Retri Gloves"] = {
		--Savage, Hateful, Deadly, Furious, Relentless, Wrathful
		40798, 40802, 40805, 40808, 40812, 51475,
	}
	self.SetBonuses["PvP Retri"] = {
		--Savage Gladiators'
		40780, 40798, 40818, 40838, 40858,
		--Hateful Gladiator's
		40782, 40802, 40821, 40842, 40861,
		--Deadly Gladiator's
		40785, 40805, 40825, 40846, 40864,
		--Furious Gladiator's
		40788, 40808, 40828, 40849, 40869,
		--Relentess Gladiator's
		40792, 40812, 40831, 40852, 40872,
		--Wrathful Gladiator's
		51474, 51475, 51476, 51477, 51479,
	}
	--T7
	self.SetBonuses["T7 Holy"] = { 39628, 39629, 39630, 39631, 39632, 40569, 40570, 40571, 40572, 40573 }
	self.SetBonuses["T7 Protection"] = { 39638, 39639, 39640, 39641, 39642, 40579, 40580, 40581, 40583, 40584 }
	self.SetBonuses["T7 Retribution"] = { 39633, 39634, 39635, 39636, 39637, 40574, 40575, 40576, 40577, 40578 }
	--T8
	self.SetBonuses["T8 Holy"] = { 45370, 45371, 45372, 45373, 45374, 46178, 46179, 46180, 46181, 46182 }
	self.SetBonuses["T8 Protection"] = { 45381, 45382, 45383, 45384, 45385, 46173, 46174, 46175, 46176, 46177 }
	self.SetBonuses["T8 Retribution"] = { 45375, 45376, 45377, 45379, 45380, 46152, 46153, 46154, 46155, 46156 }
	--T9
	self.SetBonuses["T9 Holy"] = { 48595, 48596, 48597, 48598, 48599, 48564, 48566, 48568, 48572, 48574, 48593, 48591, 48592, 48590, 48594, 48588, 48586, 48587, 48585, 48589, 48576, 48578, 48577, 48579, 48575, 48583, 48581, 48582, 48580, 48584 }
	self.SetBonuses["T9 Protection"] = { 48652, 48653, 48654, 48655, 48656, 48632, 48633, 48634, 48635, 48636, 48641, 48639, 48640, 48638, 48637, 48642, 48644, 48643, 48645, 48646, 48657, 48659, 48658, 48660, 48661, 48651, 48649, 48650, 48648, 48647 }
	self.SetBonuses["T9 Retribution"] = { 48627, 48628, 48629, 48630, 48631, 48602, 48603, 48604, 48605, 48606, 48626, 48625, 48624, 48623, 48622, 48617, 48618, 48619, 48620, 48621, 48607, 48608, 48609, 48610, 48611, 48616, 48615, 48614, 48613, 48612 }
	--T10
	self.SetBonuses["T10 Holy"] = { 50868, 50866, 50867, 50865, 50869, 51270, 51169, 51271, 51168, 51272, 51167, 51273, 51166, 51274, 51165 }
	self.SetBonuses["T10 Protection"] = { 50864, 50862, 50863, 50861, 50860, 51265, 51174, 51266, 51173, 51267, 51172, 51268, 51171, 51269, 51170 }
	self.SetBonuses["T10 Retribution"] = { 50328, 50327, 50326, 50325, 50324, 51275, 51164, 51276, 51163, 51277, 51162, 51278, 51161, 51279, 51160 }
--AURA
--Player
	--Seal of Righteousness
	--Seal of Command
	--Seal of Corruption
	--Seal of Vengeance
	--Seal of Justice
	--Seal of Wisdom
	self.PlayerAura[GetSpellInfo(21084)] = { Update = true }
	self.PlayerAura[GetSpellInfo(20375)] = self.PlayerAura[GetSpellInfo(21084)]
	self.PlayerAura[GetSpellInfo(53736)] = self.PlayerAura[GetSpellInfo(21084)]
	self.PlayerAura[GetSpellInfo(31801)] = self.PlayerAura[GetSpellInfo(21084)]
	self.PlayerAura[GetSpellInfo(20164)] = self.PlayerAura[GetSpellInfo(21084)]
	self.PlayerAura[GetSpellInfo(20166)] = self.PlayerAura[GetSpellInfo(21084)]
	--Judgements of the Pure
	self.PlayerAura[GetSpellInfo(54153)] = self.PlayerAura[GetSpellInfo(21084)]
	--The Art of War
	self.PlayerAura[GetSpellInfo(53489)] = { Update = true, Spells = 19750 }
	--Light's Grace
	self.PlayerAura[GetSpellInfo(31834)] = { Update = true, Spells = 635 }
	--Divine Illumination
	self.PlayerAura[GetSpellInfo(31842)] = { ActiveAura = "Divine Illumination", ID = 31842 }	
	--Divine Favor
	self.PlayerAura[GetSpellInfo(20216)] = { Spells = { 19750, 635, 20473 }, ModType = "critPerc", Value = 100, ID = 20216 }
	--Infusion of Light
	self.PlayerAura[GetSpellInfo(53569)] = { Spells = 635, ModType = "critPerc", Ranks = 2, Value = 10, ID = 53569 }
	--Aegis
	self.PlayerAura[GetSpellInfo(64883)] = { Spells = 53600, ActiveAura = "Aegis", Texture = "Spell_Holy_AvengersShield", NoManual = true }
	--Avenging Wrath
	self.PlayerAura[GetSpellInfo(31884)] = { School = "Healing", Value = 0.2, NoManual = true }
	--Divine Plea
	self.PlayerAura[GetSpellInfo(54428)] = { Spells = { 19750, 635, 20473 }, Value = -0.5, ID = 54428 }
	--Holiness (4p T10 healer proc, -0.3s cast on Holy Light)
	self.PlayerAura[(GetSpellInfo(70757) or "Holiness")] = { Spells = 635, Update = true }
--Target
	--Blood Corruption
	if horde then self.TargetAura[GetSpellInfo(53742)] = { Spells = { 53736, ["Judgement of Corruption"] = true }, ActiveAura = "Blood Corruption", SelfCast = true, Apps = 5, ID = 53742 }
	--Holy Vengeance
	else self.TargetAura[GetSpellInfo(31803)] = { Spells = { 31801, ["Judgement of Vengeance"] = true }, ActiveAura = "Holy Vengeance", SelfCast = true, Apps = 5, ID = 31803 } end
--Auras
	--Concentration
	self.TargetAura[GetSpellInfo(19746)] = 	{ School = "Healing", ActiveAura = "Improved Devotion Aura", SelfCastBuff = true, Manual = GetSpellInfo(20140), Category = "+6% Healing", SkipCategory = true, ID = 20140 }
	--Crusader
	self.TargetAura[GetSpellInfo(32223)] = 	self.TargetAura[GetSpellInfo(19746)]
	--Devotion
	self.TargetAura[GetSpellInfo(465)] = 	self.TargetAura[GetSpellInfo(19746)]
	--Fire Resistance
	self.TargetAura[GetSpellInfo(19891)] = 	self.TargetAura[GetSpellInfo(19746)]
	--Frost Resitance
	self.TargetAura[GetSpellInfo(19888)] = 	self.TargetAura[GetSpellInfo(19746)]
	--Shadow Resistance
	self.TargetAura[GetSpellInfo(19876)] = 	self.TargetAura[GetSpellInfo(19746)]
	--Retribution
	self.TargetAura[GetSpellInfo(7294)] = 	self.TargetAura[GetSpellInfo(19746)]
--Custom
	--Seal of Light
	self.PlayerAura[GetSpellInfo(20165)] = { Caster = true, School = "Healing", ID = 20165, Not = { "Gift of the Naaru", "Lifeblood" }, ModType =
		function( calculation )
			--Glyph of Seal of Light (additive - 3.3.3)
			if self:HasGlyph( 54943 ) then
				calculation.dmgM_Add = calculation.dmgM_Add + 0.05
			end
		end
	}
	--Sacred Shield
	self.TargetAura[GetSpellInfo(58597)] = { Spells = 19750, SelfCastBuff = true, ID = 58597, ModType = 
		function( calculation, ActiveAuras, Talents, _, _, texture )
			if not texture or string_find(texture, "Ability_Paladin_GaurdedbytheLight") then
				calculation.critPerc = calculation.critPerc + 50
			end
			if Talents["Infusion of Light"] and not ActiveAuras["Sacred Shield"] then
				calculation.hybridCanCrit = true
				calculation.hybridDotDmg = Talents["Infusion of Light"] * (calculation.minDam + calculation.maxDam)/2
				calculation.spellDmgM_dot = Talents["Infusion of Light"] * calculation.spellDmgM
				calculation.eDuration = 12
				calculation.sTicks = 1
				if self:GetSetAmount( "T9 Holy" ) >= 4 then
					calculation.dmgM_dot = calculation.dmgM_dot * 2
				end
				if Talents["Divinity Bonus"] then
					--Multiplicative - 3.3.3
					calculation.dmgM_dot = calculation.dmgM_dot * (1 + Talents["Divinity Bonus"])
					if calculation.target == "player" then
						calculation.dmgM_dot = calculation.dmgM_dot * (1 + Talents["Divinity Bonus"])
					end				
				end
			end
			ActiveAuras["Sacred Shield"] = true
		end
	}
	

	self.spellInfo = {
		[GetSpellInfo(31935)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					--200% crit, Melee hit
					["Name"] = "Avenger's Shield",
					[0] = { School = { "Holy", "Melee" }, MeleeCrit = true, MeleeHit = true, APBonus = 0.091, SPBonus = 0.091, canCrit = true, AoE = 3, Cooldown = 30 },
					[1] = { 440, 536, spellLevel = 50, Downrank = 9 },
					[2] = { 601, 733, spellLevel = 60, Downrank = 9 },
					[3] = { 796, 972, spellLevel = 70, Downrank = 4 },
					[4] = { 913, 1115, spellLevel = 75, Downrank = 4 },
					[5] = { 1100, 1344, spellLevel = 80, },
		},
		[GetSpellInfo(24275)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK
					--200% crit (verify), Melee Hit
					["Name"] = "Hammer of Wrath",
					[0] = { School = { "Holy", "Melee" }, MeleeCrit = true, MeleeHit = true, APBonus = 0.15, SPBonus = 0.15, canCrit = true, Cooldown = 6, BaseIncrease = true, },
					[1] = { 351, 387, 12, 12, spellLevel = 44, },
					[2] = { 459, 507, 13, 14, spellLevel = 52, },
					[3] = { 570, 628, 15, 16, spellLevel = 60, },
					[4] = { 733, 809, 14, 14, spellLevel = 68, },
					[5] = { 878, 970, 16, 16, spellLevel = 74, },
					[6] = { 1139, 1257, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(20925)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					--No crits, Spell hit
					["Name"] = "Holy Shield",
					[0] = { School = "Holy", APBonus = 0.63, SPBonus = 0.72, NoDPS = true, NoDoom = true, sHits = 8, NoPeriod = true, Downrank = 9 },
					[1] = { 79, 79, spellLevel = 40, },
					[2] = { 116, 116, spellLevel = 50, },
					[3] = { 157, 157, spellLevel = 60, },
					[4] = { 208, 208, spellLevel = 70, Downrank = 4},
					[5] = { 235, 235, spellLevel = 75, },
					[6] = { 274, 274, spellLevel = 80, },
		},
		[GetSpellInfo(879)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					--150% crit, Spell hit
					["Name"] = "Exorcism",
					[0] = { School = "Holy", APBonus = 0.15, SPBonus = 0.15, canCrit = true, Cooldown = 15, BaseIncrease = true, },
					[1] = { 96, 110, 6, 6, spellLevel = 20, },
					[2] = { 173, 195, 8, 8, spellLevel = 28, },
					[3] = { 250, 280, 10, 12, spellLevel = 36, },
					[4] = { 350, 394, 12, 12, spellLevel = 44, },
					[5] = { 452, 506, 14, 14, spellLevel = 52, },
					[6] = { 564, 628, 16, 16, spellLevel = 60, },
					[7] = { 687, 765, 14, 14, spellLevel = 68, Downrank = 4 },
					[8] = { 787, 877, 16, 16, spellLevel = 73, },
					[9] = { 1028, 1146, 5, 5, spellLevel = 79, },
		},
		[GetSpellInfo(2812)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					--150% crit, Spell hit
					["Name"] = "Holy Wrath",
					[0] = { School = "Holy", APBonus = 0.07, SPBonus = 0.07, canCrit = true, BaseIncrease = true, Cooldown = 30, Downrank = 4 },
					[1] = { 399, 471, 6, 7, spellLevel = 50, },
					[2] = { 551, 649, 7, 8, spellLevel = 60, },
					[3] = { 777, 913, 8, 9, spellLevel = 69, },
					[4] = { 857, 1007, 12, 12, spellLevel = 72, },
					[5] = { 1050, 1234, 8, 8, spellLevel = 78, },
		},
		[GetSpellInfo(62124)] = {
					--BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					--150% crit, Spell hit
 					["Name"] = "Hand of Reckoning",
 					[0] = { School = "Holy", Cooldown = 8, APBonus = 0.5, SPBonus = 0, canCrit = true, NoLowLevelPenalty = true, NoDownrank = true },
 					[1] = { 1, 1, spellLevel = 16 },
 		},
		[GetSpellInfo(20473)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Holy Shock",
					["Text1"] = GetSpellInfo(20473),
					["Text2"] = GetSpellInfo(37455),
					[0] = { School = { "Holy", "Healing", "Holy Shock Heal" }, SPBonus = 0.807, canCrit = true, Cooldown = 6, Downrank = 7 },
					[1] = { 481, 519, spellLevel = 40, },
					[2] = { 644, 696, spellLevel = 48, },
					[3] = { 845, 915, spellLevel = 56, },
					[4] = { 1061, 1149, spellLevel = 64, Downrank = 5 },
					[5] = { 1258, 1362, spellLevel = 70, Downrank = 4 },
					[6] = { 2065, 2235, spellLevel = 75, Downrank = 4 },
					[7] = { 2401, 2599, spellLevel = 80, },

			["Secondary"] = {
					["Name"] = "Holy Shock",
					["Text1"] = GetSpellInfo(20473),
					["Text2"] = GetSpellInfo(48360),					
					[0] = { School = "Holy", canCrit = true, Cooldown = 6, Downrank = 7 },
					[1] = { 314, 340, spellLevel = 40, },
					[2] = { 431, 465, spellLevel = 48, },
					[3] = { 562, 608, spellLevel = 56, },
					[4] = { 693, 749, spellLevel = 64, Downrank = 5 },
					[5] = { 904, 978, spellLevel = 70, Downrank = 4 },
					[6] = { 1043, 1129, spellLevel = 75, Downrank = 4 },
					[7] = { 1296, 1402, spellLevel = 80, },
			},
		},
		[GetSpellInfo(26573)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					--No crits, Spell hit
					["Name"] = "Consecration",
					[0] = { School = "Holy", eDot = true, eDuration = 8, Cooldown = 8, APBonus = 0.32, SPBonus = 0.32, sTicks = 1, AoE = true, Downrank = 9 },
					[1] = { 72, 72, spellLevel = 20, },
					[2] = { 136, 136, spellLevel = 30, },
					[3] = { 224, 224, spellLevel = 40, },
					[4] = { 336, 336, spellLevel = 50, NoDownrank = true },
					[5] = { 448, 448, spellLevel = 60, },
					[6] = { 576, 576, spellLevel = 70, Downrank = 4 },
					[7] = { 696, 696, spellLevel = 75, },
					[8] = { 904, 904, spellLevel = 80, },
		},
		[GetSpellInfo(635)] = { --DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Holy Light",
					[0] = { School = { "Holy", "Healing" }, SPBonus = 2.5/3.5 * 1.25 * 1.88, canCrit = true, castTime = 2.5, BaseIncrease = true, Downrank = 5 },
					[1] = { 50, 60, 3, 4, spellLevel = 1, },
					[2] = { 96, 116, 5, 6, spellLevel = 6, },
					[3] = { 203, 239, 8, 9, spellLevel = 14, },
					[4] = { 397, 455, 12, 12, spellLevel = 22, },
					[5] = { 628, 708, 15, 16, spellLevel = 30, },
					[6] = { 894, 998, 19, 19, spellLevel = 38, },
					[7] = { 1209, 1349, 23, 23, spellLevel = 46, },
					[8] = { 1595, 1777, 26, 26, spellLevel = 54, Downrank = 6 },
					[9] = { 2034, 2266, 29, 29, spellLevel = 60, },
					[10] = { 2232, 2486, 32, 32, spellLevel = 62, },
					[11] = { 2818, 3138, 28, 28, spellLevel = 70, Downrank = 4 },
					[12] = { 4199, 4677, 41, 42, spellLevel = 75, },
					[13] = { 4888, 5444, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(19750)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Flash of Light",
					[0] = { School = { "Holy", "Healing" }, SPBonus = 1.009 --[[1.5/3.5 * 1.25--]], canCrit = true, castTime = 1.5, BaseIncrease = true, Downrank = 5 },
					[1] = { 81, 93, 5, 5, spellLevel = 20, },
					[2] = { 124, 144, 6, 7, spellLevel = 26, },
					[3] = { 189, 211, 8, 8, spellLevel = 34, },
					[4] = { 256, 288, 9, 10, spellLevel = 42, },
					[5] = { 346, 390, 11, 11, spellLevel = 50, },
					[6] = { 445, 499, 13, 13, spellLevel = 58, },
					[7] = { 588, 658, 12, 12, spellLevel = 66, Downrank = 4 },
					[8] = { 682, 764, 13, 14, spellLevel = 74, },
					[9] = { 785, 879, 3, 4, spellLevel = 79, },
		},
		[GetSpellInfo(53601)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Sacred Shield",
					[0] = { School = { "Holy", "Healing" }, SPBonus = 0.7515, castTime = 1.5, Cooldown = 6 },
					[1] = { 500, 500, spellLevel = 80, },
		},
		[GetSpellInfo(7294)] = {
					["Name"] = "Retribution Aura",
					[0] = { School = "Holy", SPBonus = 0.033, NoDPM = true, NoDPS = true, NoCasts = true, NoHaste = true, NoMPS = true, NoNextDPS = true, Unresistable = true, NoDownrank = true },
					[1] = { 10, 10, },
					[2] = { 18, 18, },
					[3] = { 27, 27, },
					[4] = { 37, 37, },
					[5] = { 48, 48, },
					[6] = { 62, 62, },
					[7] = { 112, 112, },
		},
		[GetSpellInfo(35395)] = {
					["Name"] = "Crusader Strike",
					[0] = { Melee = true, WeaponDamage = 0.75, Cooldown = 4, },
					[1] = { 0, 0, },
		},
		[GetSpellInfo(53385)] = {
					["Name"] = "Divine Storm",
					[0] = { Melee = true, WeaponDamage = 1.1, Cooldown = 10, NoNormalization = true, AoE = 4 },
					[1] = { 0, 0 },
		},
		[GetSpellInfo(53600)] = {
					["Name"] = "Shield of Righteousness",
					[0] = { School = "Holy", Melee = true, Cooldown = 6 },
					[1] = { 390, 390, spellLevel = 75 },
					[2] = { 520, 520, spellLevel = 80 },
		},
        	[GetSpellInfo(53595)] = {
					["Name"] = "Hammer of the Righteous",
					[0] = { School = "Holy", Melee = true, APBonus = 4/14, AoE = 3, Cooldown = 6 },
					[1] = { 0, 0, },
		},
		--Seals
		[GetSpellInfo(21084)] = {
					--Note: SP and AP bonuses handled as a special case
					["Name"] = "Seal of Righteousness",
					[0] = { School = { "Holy" , "Seal" }, Melee = true, APBonus = 0, SPBonus = 0, NoCrits = true, WeaponDPS = true, NoDPM = true, Unavoidable = true },
					[1] = { 0 },
		},
		[GetSpellInfo(20375)] = {
					["Name"] = "Seal of Command",
					[0] = { School = { "Holy" , "Seal" }, Melee = true, WeaponDamage = 0.36, WeaponDPS = true, NoDPM = true, NoNormalization = true, AoE = 3 },
					[1] = { 0 },
		},
		["Judgement of Righteousness"] = {
					["Name"] = "Judgement of Righteousness",
					["Text1"] = GetSpellInfo(10321),
					["Text2"] = GetSpellInfo(21084),
					[0] = { School = { "Holy", "Judgement" }, Melee = true, SPBonus = 0.32, APBonus = 0.2, Cooldown = 10, Unavoidable = true },
					[1] = { 0, 0 },
		},
		["Judgement of Command"] = {
					["Name"] = "Judgement of Command",
					["Text1"] = GetSpellInfo(10321),
					["Text2"] = GetSpellInfo(20375),
					[0] = { School = { "Holy", "Judgement", }, Melee = true, SPBonus = 0.13, APBonus = 0.08, WeaponDamage = 0.19, Cooldown = 10, Unavoidable = true, NoNormalization = true },
					[1] = { 0, 0 },
		},
		["Judgement of Light(s)"] = {
					["Name"] = "Judgement of Light",
					["Text1"] = GetSpellInfo(10321),
					["Text2"] = GetSpellInfo(20165),
					[0] = { School = { "Holy", "Judgement" }, Melee = true, SPBonus = 0.25, APBonus = 0.16, Cooldown = 10, Unavoidable = true },
					[1] = { 1, 1 },
		},
		["Judgement of Wisdom(s)"] = {
					["Name"] = "Judgement of Wisdom",
					["Text1"] = GetSpellInfo(10321),
					["Text2"] =  GetSpellInfo(20166),
					[0] = { School = { "Holy", "Judgement" }, Melee = true, SPBonus = 0.25, APBonus = 0.16, Cooldown = 10, Unavoidable = true },
					[1] = { 1, 1 },
		},
		["Judgement of Justice(s)"] = {
					["Name"] = "Judgement of Justice",
					["Text1"] = GetSpellInfo(10321),
					["Text2"] = GetSpellInfo(20164),
					[0] = { School = { "Holy", "Judgement" }, Melee = true, SPBonus = 0.25, APBonus = 0.16, Cooldown = 10, Unavoidable = true },
					[1] = { 1, 1 },
		},
		["Judgements"] = { 	[GetSpellInfo(21084)] = "Judgement of Righteousness",
					[GetSpellInfo(20375)] = "Judgement of Command",
					[GetSpellInfo(31801)] = "Judgement of Vengeance",
					[GetSpellInfo(53736)] = "Judgement of Corruption",
					[GetSpellInfo(20165)] = "Judgement of Light(s)",
					[GetSpellInfo(20166)] = "Judgement of Wisdom(s)",
					[GetSpellInfo(20164)] = "Judgement of Justice(s)"
		},
	}
	--Judgement of Light
	--Judgement of Wisdom
	--Judgement of Justice
	self.spellInfo[GetSpellInfo(20271)] = {
				[0] = function()
					for k, v in pairs(self.spellInfo["Judgements"]) do
						if UnitBuff("player", k) then
							return self.spellInfo[v][0], self.spellInfo[v]
						end
					end
				end
	}
	self.spellInfo[GetSpellInfo(53408)] = self.spellInfo[GetSpellInfo(20271)]
	self.spellInfo[GetSpellInfo(53407)] = self.spellInfo[GetSpellInfo(20271)]
	if horde then
		self.spellInfo[GetSpellInfo(53736)] = {
					["Name"] = "Seal of Corruption",
					[0] = { School = { "Holy", "Seal" }, Melee = true, SPBonus = 0, E_eDuration = 15, E_Ticks = 3, NoDPM = true, Unavoidable = true, NoNormalization = true },
					[1] = { 0, 0, },
		}
		self.spellInfo["Judgement of Corruption"] = {
					["Name"] = "Judgement of Corruption",
					["Text1"] = GetSpellInfo(10321),
					["Text2"] = GetSpellInfo(53736),
					[0] = { School = { "Holy", "Judgement" }, Melee = true, SPBonus = 0.22, APBonus = 0.14, Cooldown = 10, Unavoidable = true },
					[1] = { 1, 1 },
		}
	else
		self.spellInfo[GetSpellInfo(31801)] = {
					["Name"] = "Seal of Vengeance",
					[0] = { School = { "Holy", "Seal" }, Melee = true, SPBonus = 0, E_eDuration = 15, E_Ticks = 3, NoDPM = true, Unavoidable = true, NoNormalization = true },
					[1] = { 0, 0 },
		}
		self.spellInfo["Judgement of Vengeance"] = {
					["Name"] = "Judgement of Vengeance",
					["Text1"] = GetSpellInfo(10321),
					["Text2"] = GetSpellInfo(31801),
					[0] = { School = { "Holy", "Judgement" }, Melee = true, SPBonus = 0.22, APBonus = 0.14, Cooldown = 10, Unavoidable = true },
					[1] = { 1, 1 },
		}
	end
	self.talentInfo = {
	--HOLY:
		--Seals of the Pure (additive except multiplicative on SoR - 3.3.3)
		[GetSpellInfo(20332)] = { 	[1] = { Effect = 0.03, Melee = true, Spells = { "Judgement of Righteousness",  "Seal of Vengeance", "Judgement of Vengeance", "Seal of Corruption", "Judgement of Corruption"}, }, 
									[2] = { Effect = 0.03, Melee = true, Multiply = true, Spells = "Seal of Righteousness" }, },
		--Healing Light (additive - 3.3.3)
		[GetSpellInfo(20237)] = { 	[1] = { Effect = 0.04, Caster = true, Spells = { "Holy Light", "Flash of Light", "Holy Shock" }, }, },
		--Illumination
		[GetSpellInfo(20210)] = { 	[1] = { Effect = 0.06, Caster = true, Spells = { "Holy Light", "Flash of Light", "Holy Shock" }, ModType = "freeCrit" }, },
		--Sanctified Light
		[GetSpellInfo(20359)] = { 	[1] = { Effect = 2, Caster = true, Spells = { "Holy Light", "Holy Shock" }, ModType = "critPerc" }, },
		--Purifying Power
		[GetSpellInfo(31825)] = { 	[1] = { Effect = { -0.17, -0.33 }, Caster = true, Multiply = true, Spells = "Exorcism", ModType = "cooldown" }, 
									[2] = { Effect = { -0.17, -0.33 }, Caster = true, Spells = "Holy Wrath", ModType = "Purifying Power" }, },
        --Judgements of the Pure (additive - 3.3.3)
        [GetSpellInfo(53671)] = { 	[1] = { Effect = 0.05, Melee = true, Spells = { "Judgement", "Seal" }, }, },
		--Infusion of Light
        [GetSpellInfo(53569)]  = {   [1] = { Effect = 0.5, Spells = "Flash of Light", ModType = "Infusion of Light" }, },
        --Enlightened Judgements
        [GetSpellInfo(53556)]  = {   [1] = { Effect = 2, Spells = "All", ModType = "hitPerc" }, },
	--PROTECTION:
		--Divinity (multiplicative - 3.3.3)
		[GetSpellInfo(63646)] = { 	[1] = { Effect = 0.01, Caster = true, Spells = { "Holy Light", "Flash of Light", "Holy Shock Heal", "Gift of the Naaru" }, ModType = "Divinity" },
									[2] = { Effect = 0.01, Caster = true, Spells = "Flash of Light", ModType = "Divinity Bonus" },
									[3] = { Effect = 0.01, Caster = true, Spells = "Lifeblood", ModType = "Lifeblood Bonus" }, },
		--Divine Guardian
		[GetSpellInfo(53527)] = { 	[1] = { Effect = 0.1, Caster = true, Spells = "Sacred Shield" }, },
		--Improved Devotion Aura (multiplicative - 3.3.3)
		[GetSpellInfo(20138)] = { 	[1] = { Effect = 0.02, Caster = true, Spells = { "Holy Light", "Flash of Light", "Holy Shock Heal", "Gift of the Naaru", "Lifeblood" }, ModType = "Improved Devotion Aura" }, },
		--Redoubt
		[GetSpellInfo(20127)] = {	[1] = { Effect = 0.1, Melee = true, Spells = "Shield of Righteousness", ModType = "Redoubt" }, },
		--Touched by the Light
		[GetSpellInfo(53590)] = {	[1] = { Effect = 0.15, Caster = true, Spells = { "Holy Light", "Flash of Light", "Holy Shock Heal" }, ModType = "critM" }, },
	--RETRIBUTION:
		--Improved Judgements
		[GetSpellInfo(25956)] = { 	[1] = { Effect = -1, Melee = true, Spells = "Judgement", ModType = "cooldown" }, },
		--Sanctity of Battle (additive - 3.3.3)
		[GetSpellInfo(32043)] = { 	[1] = { Effect = 0.05, Spells = { "Exorcism", "Crusader Strike" }, }, },
		--Crusade (multiplicative - 3.3.3)
		[GetSpellInfo(31866)] = { 	[1] = { Effect = 0.01, Spells = "All", ModType = "Crusade" }, },
		--Two-Handed Weapon Specialization (multiplicative - 3.3.3)
		[GetSpellInfo(20111)] = { 	[1] = { Effect = 0.02, Melee = true, Spells = { "Attack", "Crusader Strike", "Divine Storm", "Seal of Righteousness", "Seal of Command", "Judgement" }, ModType = "Two-Handed Weapon Specialization" }, },
		--Sanctified Retribution
		[GetSpellInfo(31869)] = { 	[1] = { Effect = 0.50, Caster = true, Spells = "Retribution Aura", ModType = "bDmgM" }, },
		--The Art of War (additive - 3.3.3)
		[GetSpellInfo(53486)] = {	[1] = { Effect = 0.05, Melee = true, Spells = { "Crusader Strike", "Divine Storm", "Judgement of Command", "Judgement of Righteousness", "Judgement of Vengeance", "Judgement of Corruption" }, },
									--NOTE: Bugged in 3.3.0 -> Double effect on Judgement of Light/Wisdom/Justice
									[2] = { Effect = 0.10, Melee = true, Spells = { "Judgement of Light", "Judgement of Wisdom", "Judgement of Justice" }, }, },
		--Fanaticism
		[GetSpellInfo(31879)] = { 	[1] = { Effect = 6, Melee = true, Spells = "Judgement", ModType = "critPerc" }, },
		--Sheath of Light
		[GetSpellInfo(53501)] = { 	[1] = { Effect = 0.2, Caster = true, Spells = { "Holy Light", "Flash of Light", "Holy Shock Heal" }, ModType = "Sheath of Light" }, },

		--Sactified Wrath
		[GetSpellInfo(53375)] = {	[1] = { Effect = 25, Caster = true, Spells = "Hammer of Wrath", ModType = "critPerc" }, },
		---Righteous Vengeance
		[GetSpellInfo(53380)] = {	[1] = { Effect = 0.1, Melee = true, Spells = { "Judgement", "Crusader Strike", "Divine Storm" }, ModType = "Righteous Vengeance" }, },
	}
end