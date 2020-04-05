if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then return end
local GetSpellInfo = GetSpellInfo
local GetCritChance = GetCritChance
local GetInventoryItemLink = GetInventoryItemLink
local GetShapeshiftForm = GetShapeshiftForm
local IsEquippedItem = IsEquippedItem
local UnitPower = UnitPower
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsUnit = UnitIsUnit
local UnitCreatureType = UnitCreatureType
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local string_match = string.match
local string_lower = string.lower
local string_find = string.find
local string_split = string.split
local math_floor = math.floor
local tonumber = tonumber
local select = select
local math_max = math.max

--Spell hit abilities: Icy Touch, Blood Boil, Death Coil, Death and Decay, Howling Blast. (Unholy Blight, Corpse Explosion?)

function DrDamage:PlayerData()
	--Health updates
	self.TargetHealth = { [1] = 0.351 }
	--Class specials
	--Death Pact
	self.ClassSpecials[GetSpellInfo(48743)] = function()
		return 0.4 * UnitHealthMax("player"), true
	end
--TALENTS
	self.Calculation["Two-Handed Weapon Specialization"] = function( calculation, value, baseSpell )
		if self:GetNormM() == 3.3 and calculation.WeaponDamage then
			calculation.wDmgM = calculation.wDmgM * (1 + value)
			if baseSpell.AutoAttack then calculation.dmgM = calculation.dmgM * (1 + value)
			else calculation.dmgM_dd = calculation.dmgM_dd * (1 + value) end
		end
	end
	self.Calculation["Nerves of Cold Steel"] = function( calculation, value )
		if self:GetNormM() == 1.7 or self:GetNormM() == 2.4 then
			calculation.hitPerc = calculation.hitPerc + value
		end
	end
	self.Calculation["Wandering Plague"] = function( calculation, value )
		calculation.E_canCrit = true
		calculation.E_critPerc = GetCritChance() + calculation.meleeCrit
		calculation.E_critM = value
	end
	self.Calculation["Threat of Thassarian"] = function( calculation, value )
		calculation.DualAttack = 0.5
		calculation.OffhandChance = value
	end
--GENERAL
	local undead = string_lower(GetSpellInfo(5502))
	local ri = "|T" .. select(3,GetSpellInfo(53343)) .. ":16:16:1:-1|t"
	local lb = "|T" .. select(3,GetSpellInfo(53331)) .. ":16:16:1:-1|t" 
	local diseaseCount = 0
	self.Calculation["DEATHKNIGHT"] = function( calculation, ActiveAuras, Talents, spell, baseSpell )
		diseaseCount = 0
		if ActiveAuras["Frost Fever"] then diseaseCount = 1 end
		if ActiveAuras["Blood Plague"] then diseaseCount = diseaseCount + 1 end
		if ActiveAuras["Crypt Fever"] then diseaseCount = diseaseCount + 1 end
		if ActiveAuras["Ebon Plague"] then diseaseCount = diseaseCount + 1 end

		if not baseSpell.Melee then
			calculation.spellDmgM = 0
			calculation.spellDmgM_dot = 0
			calculation.critM = calculation.critM + 0.5

			if calculation.instant and GetShapeshiftForm() == 3 then
				calculation.castTime = 1
			end
		else
			if baseSpell.SpellCrit then
				calculation.critM = calculation.critM + 0.5
			end
		end
		if not calculation.healingSpell then
			if Talents["Black Ice"] and (calculation.school == "Frost" or calculation.school == "Shadow") then
				--Multiplicative - 3.3.3
				calculation.dmgM = calculation.dmgM * (1 + Talents["Black Ice"])
				--BUG: Rage of Rivendare double stacks with Black Ice
				if Talents["Rage of Rivendare"] and ActiveAuras["Blood Plague"] then
					calculation.dmgM = calculation.dmgM * (1 + Talents["Black Ice"] * Talents["Rage of Rivendare"])
				end
			end
			if Talents["Tundra Stalker"] then
				--BUG: Tundra Stalker double stacks on Frost Fever from Howling Blast
				if calculation.spellName == "Howling Blast" then
					calculation.dmgM_Extra = calculation.dmgM_Extra + (1 * Talents["Tundra Stalker"])
				end
				if ActiveAuras["Frost Fever"] then
					--Multiplicative - 3.3.3
					calculation.dmgM = calculation.dmgM + (1 * Talents["Tundra Stalker"])
				end
			end
			if Talents["Rage of Rivendare"] then
				--BUG: Rage of Rivendare double stacks on Blood Plague
				if calculation.spellName == "Plague Strike" then
					calculation.dmgM_Extra = calculation.dmgM_Extra + (1 * Talents["Rage of Rivendare"])
				end
				if ActiveAuras["Blood Plague"] then
					--Multiplicative - 3.3.3
					calculation.dmgM = calculation.dmgM + (1 * Talents["Rage of Rivendare"])
				end
			end
			if Talents["Merciless Combat"] and UnitHealth("target") ~= 0 and (UnitHealth("target") / UnitHealthMax("target")) <= 0.35 then
				--Multiplicative - 3.3.3
				calculation.dmgM_dd = calculation.dmgM_dd + (1 * Talents["Merciless Combat"])
			end
			if ActiveAuras["Hysteria"] and not calculation.physical then
				calculation.dmgM = calculation.dmgM / 1.2
			end
			if calculation.WeaponDamage and calculation.group ~= "Disease" then
				local lichbane, lichbane_O, razorice, razorice_O
				local mh = GetInventoryItemLink("player",16)
				if mh then
					local _, _, rune = string_split(":",mh)
					lichbane = (rune == "3366")
					razorice = (rune == "3370")
				end
				if (baseSpell.AutoAttack or calculation.DualAttack) and calculation.offHand then
					local _, _, rune = string_split(":",GetInventoryItemLink("player",17))
					lichbane_O = (rune == "3366")
					razorice_O = (rune == "3370")
				end
				--Rune of Razorice (3370) 2% extra weapon damage as Frost damage	
				if razorice or razorice_O then
					local min, max = self:GetMainhandBase()
					--Cinderglacier and Black Ice applies. Seems like Frost Vulnerability doesn't.
					local bonus = math_max(1, 0.02 * (1/2) * (min+max) * calculation.dmgM_Magic * (1 + (Talents["Black Ice"] or 0)) * (ActiveAuras["Cinderglacier"] or 1)) --* (ActiveAuras["Frost Vulnerability"] or 1)
					calculation.extraDamage = 0
					if razorice then 
						calculation.extraDamBonus = bonus
						calculation.extraName = ri
					end
					if razorice_O then 
						calculation.extraDamBonus_O = bonus 
						calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. ri) or ri
					end
					
				end				
				--Rune of Lichbane (3366) 2% extra weapon damage as Fire damage or 4% versus Undead targets.
				if lichbane or lichbane_O then
					local min, max = self:GetMainhandBase()
					local target = UnitCreatureType("target")
					local bonus = math_max(1, 0.02 * (1/2) * (min+max) * calculation.dmgM_Magic)
					if target and string_find(undead,string_lower(target)) then
						bonus = 2 * bonus
					end				
					calculation.extraDamage = 0
					if lichbane then 
						calculation.extraDamBonus = bonus
						calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. lb) or lb
					end
					if lichbane_O then 
						calculation.extraDamBonus_O = bonus
						calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. lb) or lb
					end
				end
			end
		end
		if Talents["Impurity"] then
			if calculation.APBonus then
				calculation.APBonus = calculation.APBonus * (1 + Talents["Impurity"])
			end
			if calculation.extraDamage then
				calculation.extraDamage = calculation.extraDamage * (1 + Talents["Impurity"])
			end
		end
	end
--ABILITIES
	local necrosis = "|T" .. select(3,GetSpellInfo(51465)) .. ":16:16:0:-1|t"
	local bcb = "|T" .. select(3,GetSpellInfo(49219)) .. ":16:16:1:-1|t"	
	self.Calculation["Attack"] = function( calculation, ActiveAuras, Talents )
		if Talents["Necrosis"] then
			local dmgM = calculation.dmgM_Magic * (ActiveAuras["Cinderglacier"] or 1) * (1 + (Talents["Black Ice"] or 0))
			calculation.extraDamage = 0
			calculation.extraAvg = Talents["Necrosis"] * dmgM
			calculation.extraAvgM = true
			calculation.extraAvgChance = 1
			calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. necrosis) or necrosis
			if calculation.offHand then
				calculation.extraAvg_O = Talents["Necrosis"] * dmgM
			end
		end
		if Talents["Blood-Caked Blade"] then
			local mh = not calculation.unarmed
			local oh = calculation.offHand
			if mh or oh then
				calculation.extraDamage = 0
				calculation.extraName = calculation.extraName and (calculation.extraName .. "+" .. bcb) or bcb
				calculation.extraWeaponDamageChance = Talents["Blood-Caked Blade"]
				calculation.extraWeaponDamageM = true
			end
			if mh then
				calculation.extraWeaponDamage = 0.25 + diseaseCount * 0.125
			end
			if oh then
				calculation.extraWeaponDamage_O = 0.25 + diseaseCount * 0.125
			end
		end
	end
	self.Calculation["Blood Strike"] = function( calculation, ActiveAuras )
		--Sigil of the Dark Rider
		if IsEquippedItem(39208) then
			calculation.dmgBonus = calculation.dmgBonus + 22.5 * diseaseCount
		end
		--Multiplicative - 3.3.3
		calculation.dmgM = calculation.dmgM * (1 + diseaseCount * 0.125 * ((self:GetSetAmount( "T8 - Damage" ) >= 4) and 1.2 or 1))
		--Glyph of Blood Strike (multiplicative - 3.3.3)
		if self:HasGlyph(59332) and ActiveAuras["Snare"] then
			calculation.dmgM = calculation.dmgM * 1.2
		end
		if self:GetSetAmount( "T9 - Defense" ) >= 2 then
			--Additive - 3.3.3
			calculation.dmgM_Add = calculation.dmgM_Add + 0.05
		end
	end
	self.Calculation["Heart Strike"] = function( calculation )
		--Sigil of the Dark Rider
		if IsEquippedItem(39208) then
			calculation.dmgBonus = calculation.dmgBonus + 22.5 * diseaseCount
		end
		--Multiplicative - 3.3.3
		calculation.dmgM = calculation.dmgM * (1 + diseaseCount * 0.1 * ((self:GetSetAmount( "T8 - Damage" ) >= 4) and 1.2 or 1))
		if self:GetSetAmount( "T9 - Defense" ) >= 2 then
			--Additive - 3.3.3
			calculation.dmgM_Add = calculation.dmgM_Add + 0.05
		end
		if self:GetSetAmount( "T10 - Damage" ) >= 2 then
			--TODO: Additive/multiplicative?
			calculation.dmgM_Add = calculation.dmgM_Add + 0.07
		end
		if calculation.targets >= 2 then
			calculation.extraDamage = 0
			calculation.extraAvg = 0.5
			calculation.extraAvgM = true
			calculation.dmgM_Extra = calculation.dmgM
		end
	end
	self.Calculation["Scourge Strike"] = function( calculation, ActiveAuras, Talents )
		calculation.finalMod = calculation.finalMod * calculation.dmgM
		if diseaseCount > 0 then
			--Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * (1 + diseaseCount * 0.12 * calculation.dmgM_Magic * (ActiveAuras["Cinderglacier"] or 1) * (1 + (Talents["Black Ice"] or 0)) * ((self:GetSetAmount( "T8 - Damage" ) >= 4) and 1.2 or 1))
			--Is this a better way of displaying it?
			--calculation.extraDamage = 0
			--calculation.extraAvg = diseaseCount * 0.25 * ((self:GetSetAmount( "T8 - Damage" ) >= 4) and 1.2 or 1)
			--calculation.dmgM_Extra = calculation.dmgM_Extra * calculation.dmgM_Magic * (ActiveAuras["Cinderglacier"] or 1) * (1 + (Talents["Black Ice"] or 0))
		end
		if self:GetSetAmount( "T7 - Damage" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end
		if self:GetSetAmount( "T10 - Damage" ) >= 2 then
			--TODO: Additive/multiplicative?
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
	end
	self.Calculation["Obliterate"] = function( calculation )
		if diseaseCount > 0 then
			--Additive - 3.3.3
			calculation.dmgM_Add = calculation.dmgM_Add + diseaseCount * 0.125 * ((self:GetSetAmount( "T8 - Damage" ) >= 4) and 1.2 or 1)
		end
		--Glyph of Obliterate (additive - 3.3.3)
		if self:HasGlyph(58671) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.25
		end
		if self:GetSetAmount( "T7 - Damage" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end		
		if self:GetSetAmount( "T10 - Damage" ) >= 2 then
			--TODO: Additive/multiplicative?
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
	end
	self.Calculation["Blood Boil"] = function( calculation, ActiveAuras, Talents, spell )
		if ActiveAuras["Blood Plague"] or ActiveAuras["Frost Fever"] then
			calculation.minDam = calculation.minDam + spell.diseaseBonus
			calculation.maxDam = calculation.maxDam + spell.diseaseBonus
			calculation.APBonus = calculation.APBonus + 0.035 * (1 + (Talents["Impurity"] or 0))
		end
	end
	local ff = GetSpellInfo(59921)
	self.Calculation["Icy Touch"] = function( calculation, _, Talents )
		calculation.extra = 5 * 0.32 * calculation.playerLevel * 1.15
		calculation.extraName = ff
		--Glyph of Icy Touch (additive/multiplicative? - Currently doesn't matter)
		if self:HasGlyph(58631) then
			calculation.dmgM_Extra_Add = calculation.dmgM_Extra_Add + 0.2
		end
		if Talents["Glacier Rot"] and diseaseCount > 0 then
			--Multiplicative - 3.3.3
			calculation.dmgM_dd = calculation.dmgM_dd * (1 + Talents["Glacier Rot"])
		end
	end
	self.Calculation["Chains of Ice"] = function( calculation, _, Talents )
		calculation.extra = 5 * 0.32 * calculation.playerLevel * 1.15
		calculation.extraName = ff
		--Glyph of Icy Touch (additive/multiplicative? - Currently doesn't matter)
		if self:HasGlyph(58631) then
			calculation.dmgM_Extra_Add = calculation.dmgM_Extra_Add + 0.2
		end
		--Glyph of Chains of Ice
		if self:HasGlyph(58620) then
			calculation.minDam = 144
			calculation.maxDam = 156
			calculation.NoCrits = false
			calculation.APBonus = 0.08 * (1 + (Talents["Impurity"] or 0))
			--BUG: Glacier Rot applies to Chains of Ice dd part
			if Talents["Glacier Rot"] and diseaseCount > 0 then
				--Multiplicative - 3.3.3
				calculation.dmgM_dd = calculation.dmgM_dd * (1 + Talents["Glacier Rot"])
			end			
		end
	end
	self.Calculation["Howling Blast"] = function( calculation, _, Talents, spell )
		if Talents["Glacier Rot"] and diseaseCount > 0 then
			--Multiplicative - 3.3.3
			calculation.dmgM_dd = calculation.dmgM_dd * (1 + Talents["Glacier Rot"])
		end
		--Glyph of Howling Blast
		if self:HasGlyph(63335) then
			calculation.extra = 5 * 0.32 * calculation.playerLevel
			calculation.extraName = ff
			calculation.extraDamage = 0.275 * (1 + (Talents["Impurity"] or 0))
			--Glyph of Icy Touch (additive/multiplicative? - Currently doesn't matter)
			if self:HasGlyph(58631) then
				calculation.dmgM_Extra_Add = calculation.dmgM_Extra_Add + 0.2
			end			
		end
	end
	self.Calculation["Frost Strike"]  = function( calculation, _, Talents )
		if Talents["Glacier Rot"] and diseaseCount > 0 then
			--Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * (1 + Talents["Glacier Rot"])
		end
		if self:GetSetAmount( "T8 - Damage" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 8
		end
	end
	local bp = GetSpellInfo(59879)
	self.Calculation["Plague Strike"] = function( calculation, ActiveAuras, Talents )
		calculation.extra = 5 * 0.38875 * calculation.playerLevel * 1.15
		calculation.extraName = bp
		calculation.dmgM_Extra = calculation.dmgM_Extra * calculation.dmgM_Magic * (1 + (Talents["Black Ice"] or 0))
		if ActiveAuras["Hysteria"] then
			calculation.dmgM_Extra = calculation.dmgM_Extra / 1.2
		end
		--Glyph of Plague Strike (multiplicative - 3.3.3)
		if self:HasGlyph(58657) then
			calculation.dmgM_dd = calculation.dmgM_dd * 1.2
		end
		if self:GetSetAmount( "T7 - Defense" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 10
		end
		if self:GetSetAmount( "T9 - Damage" ) >= 4 then
			calculation.E_canCrit = true
		end
	end
	local ub = "|T" .. select(3,GetSpellInfo(49194)) .. ":16:16:1:-1|t"
	self.Calculation["Death Coil"] = function( calculation, _, Talents )
		if not calculation.healingSpell then
			if Talents["Unholy Blight"] then
				calculation.extraName = ub
				calculation.extraTicks = 10
				--Glyph of Unholy Blight
				calculation.extraAvg = 0.1 * (self:HasGlyph(63332) and 1.4 or 1)
			end
		end
		--Glyph of Dark Death (additive - 3.3.3)
		if self:HasGlyph(63333) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.15
		end		
		if self:GetSetAmount( "T8 - Damage" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 8
		end
	end
	self.Calculation["Death and Decay"] = function( calculation )
		--Glyph of Death and Decay
		if self:HasGlyph(58629) then
			--TODO: Additive/multiplicative?
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
		if self:GetSetAmount( "T10 - Defense" ) >= 2 then
			--TODO: Additive/multiplicative?
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Death Strike"] = function( calculation )
		--Glyph of Death Strike (Multiplicative - 3.3.3 - Increase damage by 2% for every 2 RP, max of 25%)
		if self:HasGlyph(59336) then
			local power = UnitPower("player", 6)
			if power > 25 then power = 25 end
			calculation.dmgM = calculation.dmgM * (1 + power/100)
		end
		if self:GetSetAmount( "T7 - Damage" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Rune Strike"] = function( calculation )
		--Glyph of Rune Strike
		if self:HasGlyph(58669) then
			calculation.critPerc = calculation.critPerc + 10
		end
		if self:GetSetAmount( "T8 - Defense" ) >= 2 then
			--TODO: Additive/multiplicative?
			calculation.dmgM_Add = calculation.dmgM_Add + 0.1
		end
	end
	self.Calculation["Rune Tap"] = function( calculation, _, Talents )
		calculation.minDam = UnitHealthMax("player")
		calculation.maxDam = calculation.minDam
		--Glyph of Rune Tap (multiplicative - 3.3.3)
		calculation.dmgM = 0.1 * (self:HasGlyph(59327) and 1.1 or 1) * (1 + (Talents["Improved Rune Tap"] or 0))
	end
	self.Calculation["Summon Gargoyle"] = function( calculation )
		--Assume one second is wasted
		calculation.sHits = math_floor((30 - 1) / (2 / calculation.haste))
		calculation.APBonus = calculation.APBonus * calculation.sHits
		calculation.haste = 1
		calculation.canCrit = true
		calculation.critM = 0.5
		calculation.critPerc = 5
		calculation.critM_custom = true
	end
--SETS
	self.SetBonuses["T7 - Damage"] =
		{ 39617, 39618, 39619 , 39620 , 39621, -- T7
		40550, 40552, 40554, 40556, 40557 }  -- T7.5
	self.SetBonuses["T7 - Defense"] =
        	{ 39623, 39624, 39625, 39626, 39627,  -- T7
		40559, 40563, 40565, 40567, 40568 } -- T7.5
	self.SetBonuses["T8 - Damage"] =
		{ 45340, 45341, 45342, 45343, 45344,  -- T8
		46111, 46113, 46115, 46116, 46117 } -- T8.5
	self.SetBonuses["T8 - Defense"] =
		{ 45335, 45336, 45337, 45338, 45339,  -- T8
		46118, 46119, 46120, 46121, 46122 } -- T8.5
	self.SetBonuses["T9 - Damage"] =
		{ 48501, 48502, 48503, 48504, 48505,
		48472, 48474, 48476, 48478, 48480,
		48481, 48482, 48483, 48484, 48485,
		48490, 48489, 48488, 48487, 48486,
		48500, 48499, 48498, 48497, 48496,
		48491, 48492, 48493, 48494, 48495 }
	self.SetBonuses["T9 - Defense"] =
		{ 48558, 48559, 48560, 48561, 48562,
		48529, 48531, 48533, 48535, 48537,
		48557, 48555, 48556, 48554, 48553,
		48548, 48550, 48549, 48551, 48552,
		48538, 48540, 48539, 48541, 48542,
		48547, 48545, 48546, 48544, 48543 }
	self.SetBonuses["T10 - Damage"] =
		{ 50098, 50097, 50096, 50095, 50094,
		51125, 51314, 51126, 51313, 51127,
		51312, 51128, 51311, 51129, 51310 }
	self.SetBonuses["T10 - Defense"] =
		{ 50853, 50854, 50855, 50856, 50857,
		51130, 51309, 51131, 51308, 51132,
		51307, 51133, 51306, 51134, 51305 }
--RELICS
--Melee
	--Sigil of the Dark Rider
	self.RelicSlot["Blood Strike"] = { 39208, 45, ModType1 = "dmgBonus" } --Applies 45 to base and 45 divided over 2(or 4?) diseases
	self.RelicSlot["Heart Strike"] = { 39208, 45, ModType1 = "dmgBonus" } --Applies 45 to base and 45 divided over 2(or 4?) diseases
	--Sigil of the Venegeful Heart
	self.RelicSlot["Frost Strike"] = { 45254, 113, ModType1 = "dmgBonus" } --MH: 113 * talents OH: 113 * 1.15 (Nerves of Cold Steel) * talents	
	--Sigil of Awareness (base damage, not modified by offhand penalty)
	self.RelicSlot["Obliterate"] ={ 40207, 336, ModType1 = "dmgBonus" }
	self.RelicSlot["Death Strike"] = { 40207, 315, ModType1 = "dmgBonus" }
	--Sigil of Awareness (BUG? 189 -> 292), Sigil of Arthritic Binding (BUG? 0.9 * 91.35)
	self.RelicSlot["Scourge Strike"] = { 40207, 292, 40875, 0.9 * 91.35, }
--Caster (NOTE: default ModType for caster is spellpower, so here you need to specify either "Base" or "finalMod")
	--Sigil of the Frozen Conscience
	self.RelicSlot["Icy Touch"] = { 40822, 111, ModType1 = "Base" }
	-- Sigil of the Venegeful Heart, Sigil of the Wild Buck
	self.RelicSlot["Death Coil"] = { 45254, 380, 40867, 80, ModType1 = "Base", ModType2 = "Base" }

--AURA
--Player
	--Killing Machine
	self.PlayerAura[GetSpellInfo(51124)] = { Spells = { 45477, 49184, 49143 }, Value = 100, ModType = "critPerc", ID = 51124 }
	--Death Chill
	self.PlayerAura[GetSpellInfo(49796)] = { Spells = { 45477, 49184, 49143, 49020 }, Value = 100, ModType = "critPerc", ID = 49796 }
	--Hysteria (needs to be divided out from multiplier)
	self.PlayerAura[GetSpellInfo(49016)] = { ActiveAura = "Hysteria", NoManual = true }
--Target
	--Vampiric Blood
	self.TargetAura[GetSpellInfo(55233)] = { School = "Healing", Value = 0.35, NoManual = true }
	--Frost Fever
	self.TargetAura[GetSpellInfo(55095)] = { ActiveAura = "Frost Fever", SelfCast = true, ID = 55095 }
	--Blood Plague
	self.TargetAura[GetSpellInfo(55078)] = { ActiveAura = "Blood Plague", SelfCast = true, ID = 55078 }
--Snares
	--Icy Clutch
	self.TargetAura[GetSpellInfo(50434)] = 	{ ActiveAura = "Snare", Spells = 45902, Manual = "Snared", ID = 50434 }
	--Desecration
	self.TargetAura[GetSpellInfo(55666)] = 	self.TargetAura[GetSpellInfo(50434)]
	--Glyph of Heart Strike
	self.TargetAura[GetSpellInfo(58617)] = 	self.TargetAura[GetSpellInfo(50434)]
	--Infected Wounds
	self.TargetAura[GetSpellInfo(58179)] = 	self.TargetAura[GetSpellInfo(50434)]
	--Frostfire bolt
	self.TargetAura[GetSpellInfo(47610)] = 	self.TargetAura[GetSpellInfo(50434)]
	--Frostbolt
	self.TargetAura[GetSpellInfo(116)] = 	self.TargetAura[GetSpellInfo(50434)]
	--Slow
	self.TargetAura[GetSpellInfo(31589)] = 	self.TargetAura[GetSpellInfo(50434)]
--Custom
	--Cinderglacier
	self.PlayerAura[GetSpellInfo(53386)] = { ID = 53386, ModType = 
		function( calculation, ActiveAuras )
			if calculation.school == "Frost" or calculation.school == "Shadow" then
				calculation.dmgM = calculation.dmgM * 1.2
			elseif calculation.group == "Disease" then
				calculation.dmgM_Extra = calculation.dmgM_Extra * 1.2
			else
				ActiveAuras["Cinderglacier"] = 1.2
			end
		end
	}
	--Bloody Vengeance
	self.PlayerAura[GetSpellInfo(50447)] = { School = { ["Damage Spells"] = true, ["Disease"] = true }, Apps = 3, NoManual = true, ModType =
		function( calculation, _, _, index, apps )
			if index then
				local id = select(11,UnitBuff("player",index))
				local bonus = (id == 50449) and 0.03 or (id == 50448) and 0.02 or (id == 50447) and 0.01
				bonus = (bonus or 0.03) * apps
				if calculation.physical then
					calculation.dmgM_Extra = calculation.dmgM_Extra / (1 + bonus)
				else
					calculation.dmgM = calculation.dmgM / (1 + bonus)
				end
			end
		end
	}
	--Frost Vulnerability (Rune of Razorice)
	self.TargetAura[GetSpellInfo(51714)] = { Apps = 5, SelfCast = true, ID = 51714, ModType =
		function( calculation, ActiveAuras, _, _, apps )
			if calculation.school == "Frost" then
				calculation.dmgM = calculation.dmgM * (1 + 0.02 * apps)
			elseif calculation.spellName == "Attack" then
				ActiveAuras["Frost Vulnerability"] = 1 + 0.02 * apps
			end
		end
	}	
	--Crypt Fever
	self.TargetAura[GetSpellInfo(50510)] = { Ranks = 3, ID = 50510, ModType =
		function( calculation, ActiveAuras, _, index, _, _, rank )
			if calculation.group == "Disease" and not ActiveAuras["Disease bonus"] then
				--Multiplicative - 3.3.3
				calculation.dmgM_Extra = calculation.dmgM_Extra * (1 + 0.1 * rank)
				ActiveAuras["Disease bonus"] = true
			end
			if index then
				local unit = select(8,UnitDebuff("target",index))
				if unit and UnitIsUnit("player",unit) then
					ActiveAuras["Crypt Fever"] = true
				end
			else
				ActiveAuras["Crypt Fever"] = true
			end
		end
	}
	--Ebon Plague
	self.TargetAura[GetSpellInfo(51726)] = { Ranks = 3, Category = "+13% dmg", SkipCategory = true, ID = 51726, ModType =
		function( calculation, ActiveAuras, _, index, _, _, rank )
			if not ActiveAuras["+13% dmg"] then
				calculation.dmgM_Magic = calculation.dmgM_Magic * (1 + (select(rank, 0.04, 0.09, 0.13) or 0))
				ActiveAuras["+13% dmg"] = true
			end
			if calculation.group == "Disease" and not ActiveAuras["Disease bonus"] then
				calculation.dmgM_Extra = calculation.dmgM_Extra * 1.3
				ActiveAuras["Disease bonus"] = true
			end
			if index then
				local unit = select(8,UnitDebuff("target",index))
				if unit and UnitIsUnit("player",unit) then
					ActiveAuras["Ebon Plague"] = true
				end
			else
				ActiveAuras["Ebon Plague"] = true
			end
		end
	}

	self.spellInfo = {
		--BLOOD
		[GetSpellInfo(45902)] = {
				["Name"] = "Blood Strike",
				[0] = { Melee = true, WeaponDamage = 0.4 },
				[1] = { 104 },
				[2] = { 118 },
				[3] = { 138.8 },
				[4] = { 164.4 },
				[5] = { 250 },
				[6] = { 305.6 },
		},
		[GetSpellInfo(55050)] = {
				["Name"] = "Heart Strike",
				[0] = { Melee = true, WeaponDamage = 0.5 },
				[1] = { 125 },
				[2] = { 142 },
				[3] = { 167 },
				[4] = { 197.5 },
				[5] = { 300.5 },
				[6] = { 368 },
		},
		[GetSpellInfo(48721)] = {
				["Name"] = "Blood Boil",
				[0] = { School = "Shadow", canCrit = true, APBonus = 0.06, AoE = true },
				[1] = { 89, 107, diseaseBonus = 45, spellLevel = 58 },
				[2] = { 116, 140, diseaseBonus = 59, spellLevel = 66 }, --TODO: real diseaseBonus
				[3] = { 149, 181, diseaseBonus = 76, spellLevel = 72 }, --TODO: real diseaseBonus
				[4] = { 180, 220, diseaseBonus = 95, spellLevel = 78 },
		},
		[GetSpellInfo(48982)] = {
				["Name"] = "Rune Tap",
				[0] = { School = { "Shadow", "Healing" }, Cooldown = 60 },
				[1] = { 0, 0 }
		},
		--FROST
		[GetSpellInfo(49020)] = {
				["Name"] = "Obliterate",
				[0] = { Melee = true, WeaponDamage = 0.8 },
				[1] = { 198.4  },
				[2] = { 244  },
				[3] = { 381.6  },
				[4] = { 467.2  },
		},
		[GetSpellInfo(49143)] = {
				["Name"] = "Frost Strike",
				[0] = { School = "Frost", Melee = true, WeaponDamage = 0.55 },
				[1] = { 52.2 },
				[2] = { 56.65 },
				[3] = { 63.25 },
				[4] = { 78.1 },
				[5] = { 110.55 },
				[6] = { 137.5 },
		},
		[GetSpellInfo(56815)] = {
				["Name"] = "Rune Strike",
				[0] = { Melee = true, WeaponDamage = 1.5, APBonus = 0.15, NextMelee = true, NoNormalization = true, Unavoidable = true },
				[1] = { 0 },
		},
		[GetSpellInfo(45477)] = {
				["Name"] = "Icy Touch",
				[0] = { School = { "Frost", "Disease", "Spell" }, Melee = true, SpellHit = true, SpellCrit = "Frost", APBonus = 0.1, ExtraDamage = 5 * 0.06325, E_eDuration = 15, E_Ticks = 3 },
				[1] = { 127, 137, },
				[2] = { 144, 156, },
				[3] = { 161, 173, },
				[4] = { 187, 203, },
				[5] = { 227, 245, },
		},
		[GetSpellInfo(45524)] = {
				["Name"] = "Chains of Ice",
				[0] = { School = { "Frost", "Disease", "Spell" }, Melee = true, SpellHit = true, SpellCrit = "Frost", NoCrits = true, ExtraDamage = 5 * 0.06325, E_eDuration = 15, E_Ticks = 3 },
				[1] = { 0, 0 },
		},
		[GetSpellInfo(49184)] = {
				["Name"] = "Howling Blast",
				--NOTE: Marked as Disease and E_eDuration for Glyph
				[0] = { School = { "Frost", "Disease", "Spell" }, Melee = true, SpellHit = true, SpellCrit = "Frost", APBonus = 0.2, E_Ticks = 3, E_eDuration = 15, Cooldown = 8, AoE = true, E_AoE = true },
				[1] = { 198, 214, },
				[2] = { 324, 352, },
				[3] = { 441, 479, },
				[4] = { 518, 562, },
		},
		--UNHOLY
		[GetSpellInfo(45462)] = {
				["Name"] = "Plague Strike",
				[0] = { School = { "Physical", "Disease" }, Melee = true, WeaponDamage = 0.5, E_eDuration = 15, E_Ticks = 3, ExtraDamage = 5 * 0.06325 },
				[1] = { 62.5 },
				[2] = { 75.5 },
				[3] = { 89 },
				[4] = { 108 },
				[5] = { 157 },
				[6] = { 189 },
		},
		[GetSpellInfo(49998)] = {
				["Name"] = "Death Strike",
				[0] = { Melee = true, WeaponDamage = 0.75 },
				[1] = { 84 },
				[2] = { 97.5 },
				[3] = { 123.75 },
				[4] = { 187.5 },
				[5] = { 222.75 },
		},
		[GetSpellInfo(55090)] = {
				["Name"] = "Scourge Strike",
				[0] = { Melee = true, WeaponDamage = 0.7 },
				[1] = { 238 },
				[2] = { 293 },
				[3] = { 457 },
				[4] = { 560 },
		},
		[GetSpellInfo(52375)] = {
				["Name"] = "Death Coil",
				["Text1"] = GetSpellInfo(52375),
				["Text2"] = GetSpellInfo(48360),				
				[0] = { School = "Shadow", canCrit = true, APBonus = 0.15 },
				[1] = { 184, 184, },
				[2] = { 208, 208, },
				[3] = { 275, 275, },
				[4] = { 381, 381, },
				[5] = { 443, 443, },
			["Secondary"] = {
				["Name"] = "Death Coil",
				["Text1"] = GetSpellInfo(52375),
				["Text2"] = GetSpellInfo(37455),
				[0] = { School = { "Shadow", "Healing" }, canCrit = true, APBonus = 0.15 },
				[1] = { 276, 276, },
				[2] = { 312, 312, },
				[3] = { 412.5, 412.5, },
				[4] = { 571.5, 571.5, },
				[5] = { 664.5, 664.5, },
			},
		},
		[GetSpellInfo(43265)] = {
				["Name"] = "Death and Decay",
				[0] = { School = "Shadow", canCrit = true, eDot = true, eDuration = 10, sHits = 10, Cooldown = 30, APBonus = 0.48, AoE = true, NoPeriod = true },
				[1] = { 26, 26, },
				[2] = { 34, 34, },
				[3] = { 49, 49, },
				[4] = { 62, 62, },
		},
		[GetSpellInfo(49158)] = {
				["Name"] = "Corpse Explosion",
				[0] = { School = "Shadow", canCrit = true, APBonus = 0.105, AoE = true },
				[1] = { 166, 166, },
				[2] = { 192, 192, },
				[3] = { 262, 262, },
				[4] = { 383, 383, },
				[5] = { 443, 443, },
		},
		[GetSpellInfo(49206)] = {
				["Name"] = "Summon Gargoyle",
				[0] = { School = "Nature", eDot = true, eDuration = 30, SPBonus = 0, APBonus = 0.35, BaseIncrease = true, MeleeHit = true, MeleeHaste = true, CustomHaste = true, NoNext = true, NoPeriod = true, NoDownrank = true },
				[1] = { 51, 69, 57, 77, spellLevel = 60 }
		},
	}
	self.talentInfo = {
	--BLOOD
		--Subversion
		[GetSpellInfo(48997)] = { 	[1] = { Effect = 3, Spells = { "Blood Strike", "Heart Strike", "Obliterate", "Scourge Strike" }, ModType = "critPerc", }, },
		--Two-Handed Weapon Specialization (multiplicative - 3.3.3)
		[GetSpellInfo(55107)] = { 	[1] = { Effect = 0.02, Melee = true, Spells = "All", ModType = "Two-Handed Weapon Specialization" }, },
		--Improved Rune Tap
		[GetSpellInfo(48985)] = {	[1] = { Effect = { 0.33, 0.66, 1 }, Spells = "Rune Tap", ModType = "Improved Rune Tap", },
									[2] = { Effect = -10, Spells = "Rune Tap", ModType = "cooldown", }, },
		--Bloody Strikes (additive - 3.3.3)
		[GetSpellInfo(48977)] = {	[1] = { Effect = 0.05, Spells = "Blood Strike", },
									[2] = { Effect = 0.15, Spells = "Heart Strike", },
									[3] = { Effect = 0.1, Spells = "Blood Boil", }, },
		--Improved Death Strike (additive? - currently doesn't matter)
		[GetSpellInfo(62905)] = {	[1] = { Effect = 0.15, Spells = "Death Strike" },
									[2] = { Effect = 3, Spells = "Death Strike", ModType = "critPerc" }, },
		--Might of Mograine
		[GetSpellInfo(49023)] = {	[1] = { Effect = 0.15, Spells = { "Blood Strike", "Death Strike", "Heart Strike" }, ModType = "critM", },
									[2] = { Effect = 0.075, Spells = "Blood Boil", ModType = "critM" }, },
		--Blood Gorged
		[GetSpellInfo(61154)] = {	[1] = { Effect = 0.02, Melee = true, Spells = "All", ModType = "armorPen" }, },
	--FROST
		--Improved Icy Touch (additive? - currently doesn't matter)
		[GetSpellInfo(49175)] = {	[1] = { Effect = 0.05, Spells = "Icy Touch", ModType = "dmgM_dd_Add" }, },
		--Black Ice (multiplicative - 3.3.3)
		[GetSpellInfo(49140)] = {	[1] = { Effect = 0.02, Spells = { "Frost", "Shadow", "Scourge Strike", "Attack", "Plague Strike" }, ModType = "Black Ice"}, },
		--Nerves of Cold Steel
		[GetSpellInfo(49226)] = {	[1] = { Effect = 1, Melee = true, Spells = { "Physical", "Frost Strike" }, ModType = "Nerves of Cold Steel" },
									[2] = { Effect = { 0.08, 0.16, 0.25 }, Melee = true, Spells = { "Attack", "Death Strike", "Obliterate", "Plague Strike", "Blood Strike", "Frost Strike" }, ModType = "offHdmgM", Multiply = true  },
									[3] = { Effect = { 0.08, 0.16, 0.25 }, Melee = true, Spells = { "Death Strike", "Obliterate", "Plague Strike", "Blood Strike", "Frost Strike" }, ModType = "bDmgM_O", Multiply = true  }, NoManual = true },
		--Annihilation
		[GetSpellInfo(51468)] = {	[1] = { Effect = 1, Melee = true, Spells = { "Scourge Strike", "Death Strike", "Plague Strike", "Rune Strike", "Frost Strike", "Obliterate", "Heart Strike", "Blood Strike" }, ModType = "critPerc" }, },
		--Glacier Rot (multiplicative - 3.3.3)
		[GetSpellInfo(49471)] = {	[1] = { Effect = { 0.07, 0.13, 0.2 }, Spells = { "Icy Touch", "Howling Blast", "Frost Strike", "Chains of Ice" }, ModType = "Glacier Rot" }, },
		--Merciless Combat (multiplicative - 3.3.3)
		[GetSpellInfo(49024)] = {	[1] = { Effect = 0.06, Spells = { "Icy Touch", "Howling Blast", "Obliterate", "Frost Strike" }, ModType = "Merciless Combat" }, },
		--Rime
		[GetSpellInfo(49188)] = {	[1] = { Effect = 5, Spells = { "Icy Touch", "Obliterate" }, ModType = "critPerc" }, },
		--Threat of Thassarian
		[GetSpellInfo(65661)] = {	[1] = { Effect = { 0.3, 0.6, 1 }, Spells = { "Death Strike", "Obliterate", "Plague Strike", "Blood Strike", "Frost Strike", "Rune Strike" }, ModType = "Threat of Thassarian" }, },
		--Blood of the North (additive - 3.3.3)
		[GetSpellInfo(54639)] = {	[1] = { Effect = { 0.03, 0.06, 0.10 }, Spells = { "Blood Strike", "Frost Strike" } }, },
		--Guile of Gorefiend
		[GetSpellInfo(50187)] = {	[1] = { Effect = 0.15, Spells = { "Blood Strike", "Frost Strike", "Howling Blast", "Obliterate" }, ModType = "critM", }, },
		--Tundra Stalker (multiplicative - 3.3.3 - BUG: Doesn't apply to Chains of Ice?)
		[GetSpellInfo(49202)] = {	[1] = { Effect = 0.03, Spells = "All", Not = { "Attack", "Chains of Ice" }, ModType = "Tundra Stalker" }, },
	--UNHOLY
		--Vicious Strikes
		[GetSpellInfo(51745)] = {	[1] = { Effect = 3, Melee = true, Spells = { "Plague Strike", "Scourge Strike" }, ModType = "critPerc" },
									[2] = { Effect = 0.15, Melee = true, Spells = { "Plague Strike", "Scourge Strike" }, ModType = "critM" }, },
		--Virulence
		[GetSpellInfo(48962)] = {	[1] = { Effect = 1, Spells = { "Blood Boil", "Icy Touch", "Death and Decay", "Howling Blast", "Death Coil", "Unholy Blight", "Corpse Explosion" }, ModType = "hitPerc" }, },
		--Epidemic
		[GetSpellInfo(49562)] = {	[1] = { Effect = 3, Spells = { "Icy Touch", "Plague Strike", "Howling Blast" }, ModType = "E_eDuration" }, },
		--Morbidity (additive - 3.3.3)
		[GetSpellInfo(48963)] = {	[1] = { Effect = 0.05, Spells = "Death Coil" },
									[2] = { Effect = -5, Spells = "Death and Decay", ModType = "cooldown" }, },
		--Outbreak (TODO: additive?)
		[GetSpellInfo(49013)] = {	[1] = { Effect = 0.1, Spells = "Plague Strike", ModType = "dmgM_dd_Add" },
									[2] = { Effect = { 0.07, 0.13, 0.2 }, Spells = "Scourge Strike" }, },
		--Necrosis
		[GetSpellInfo(51459)] = {	[1] = { Effect = 0.04, Spells = "Attack", ModType = "Necrosis" }, },
		--Blood-Caked Blade
		[GetSpellInfo(49627)] = {	[1] = { Effect = 0.1, Spells = "Attack", ModType = "Blood-Caked Blade" }, },
		--Unholy Blight
		[GetSpellInfo(49194)] = {	[1] = { Effect = 1, Caster = true, Spells = "Death Coil", ModType = "Unholy Blight" }, },
		--Impurity (multiplicative - 3.3.3)
		[GetSpellInfo(49220)] = {	[1] = { Effect = 0.04, Spells = "All", ModType = "Impurity" }, },
		--Wandering Plague
		[GetSpellInfo(49217)] = {	[1] = { Effect = { 0.33, 0.66, 1 }, Melee = true, Spells = "Disease", ModType = "Wandering Plague" }, },
		--Rage of Rivendare (multiplicative - 3.3.3)
		[GetSpellInfo(50117)] = {	[1] = { Effect = 0.02, Spells = "All", Not = { "Attack", "Summon Gargoyle" }, ModType = "Rage of Rivendare" }, },

	}
end