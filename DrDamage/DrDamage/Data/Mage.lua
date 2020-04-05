if select(2, UnitClass("player")) ~= "MAGE" then return end
local GetSpellInfo = GetSpellInfo
local GetSpellCritChance = GetSpellCritChance
local UnitBuff = UnitBuff
local UnitPowerMax = UnitPowerMax
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local math_max = math.max
local math_floor = math.floor
local ipairs = ipairs
local UnitDebuff = UnitDebuff

function DrDamage:PlayerData()
	--Health Updates
	self.TargetHealth = { [1] = 0.35 }
	--Special AB info
	--Evocation
	self.ClassSpecials[GetSpellInfo(12051)] = function()
		return 0.6 * UnitPowerMax("player",0), false, true
	end
	--Torment the Weak
	local snareList = {
	--Hunter snares: Wing Clip, Frost trap, Concussive Shot,
	(GetSpellInfo(2974)), (GetSpellInfo(13810)), (GetSpellInfo(5116)),
	--Rogue snares: Crippling Poison, Deadly Throw
	(GetSpellInfo(25809)), (GetSpellInfo(26679)),
	--Warrior snares: Hamstring, Piercing Howl
	(GetSpellInfo(1715)), (GetSpellInfo(12323)),
	--Shaman snares: Frost Shock, Earthbind,
	(GetSpellInfo(8056)), (GetSpellInfo(3600)),
	--Others: Curse of Exhaustion, Mind Flay, Dazed, Desecration, Icy Clutch (from Chilblains)
	(GetSpellInfo(18223)), (GetSpellInfo(15407)), (GetSpellInfo(29703)), (GetSpellInfo(55784)), (GetSpellInfo(50434))
	}
--GENERAL
	self.Calculation["MAGE"] = function( calculation, ActiveAuras, Talents, spell )
		if self:GetSetAmount( "T7" ) >= 4 then
			calculation.critM = calculation.critM + 0.025
		end
		if self.db.profile.ManaConsumables then --Assumes usage of Mana Sapphires and includes Glyph of Mana Gem
			calculation.manaRegen = calculation.manaRegen + 28.458 * (self:HasGlyph(56367) and 1.4 or 1) * ((self:GetSetAmount( "T7" ) >= 2) and 1.25 or 1)
		end
		if Talents["Torment the Weak"] then --Multiplicative - 3.3.3
			if ActiveAuras["Snare"] then
				calculation.dmgM = calculation.dmgM * (1 + Talents["Torment the Weak"])
			else
				--Snares that aren't handled actively, i.e. don't trigger updates
				for _,k in ipairs(snareList) do
					if UnitDebuff("target", k) then
						calculation.dmgM = calculation.dmgM * (1 + Talents["Torment the Weak"])
						break
					end
				end
			end
		end
		if Talents["Molten Fury"] then --Multiplicative - 3.3.3
			if UnitHealth("target") ~= 0 and (UnitHealth("target") / UnitHealthMax("target")) < 0.35 then
				calculation.dmgM = calculation.dmgM * (1 + Talents["Molten Fury"])
			end
		end
		if Talents["Shatter"] and (ActiveAuras["Frozen"] or ActiveAuras["Deep Freeze"]) then
			calculation.critPerc = calculation.critPerc + Talents["Shatter"]
		end
	end
--TALENTS
	local ignite = GetSpellInfo(11119)
	self.Calculation["Ignite"] = function( calculation, value )
		calculation.extraCrit = value
		calculation.extraChanceCrit = true
		calculation.extraTicks = 2
		calculation.extraName = ignite
	end
--ABILITIES
	self.Calculation["Ice Lance"] = function( calculation, ActiveAuras )
		if (ActiveAuras["Frozen"] or ActiveAuras["Deep Freeze"]) then
			--Glyph of Ice Lance
			local bonus = self:HasGlyph(56377) and (calculation.targetLevel > calculation.playerLevel) and 1 or 0
			calculation.spellDmgM = calculation.spellDmgM  * (3 + bonus)
			calculation.bDmgM = calculation.bDmgM  + 2 + bonus
		end
	end
	self.Calculation["Frostfire Bolt"] = function( calculation, ActiveAuras, Talents )
		--Note: Double dips spell damage from mind mastery
		calculation.spellDmg = calculation.spellDmg + (calculation.int * (Talents["Mind Mastery"] or 0))
		--Glyph of Frostfire (additive - 3.3.3)
		if self:HasGlyph( 61205 ) then
			calculation.dmgM_dd_Add = calculation.dmgM_dd_Add + 0.02
			calculation.critPerc = calculation.critPerc + 2
		end
		if self:GetSetAmount("T9") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Arcane Missiles"] = function( calculation, ActiveAuras, _, spell, baseSpell )
		--Glyph of Arcane Missiles
		if self:HasGlyph( 56363 ) then
			calculation.critM = calculation.critM + 0.125
		end
		if ActiveAuras["Missile Barrage"] then
			calculation.castTime = calculation.castTime - 2.5
		end
		if self:GetSetAmount("T9") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Fireball"] = function( calculation, _, _, spell )
		calculation.extraDotDmg = spell.extraDotDmg	
		if self:GetSetAmount("T9") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Frostbolt"] = function( calculation )
		--Glyph of Frostbolt (additive - 3.3.3)
		if self:HasGlyph( 56370 ) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.05
		end
		if self:GetSetAmount("T9") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.Calculation["Ice Barrier"] = function( calculation )
		--Glyph of Ice Barrier
		if self:HasGlyph( 63095 ) then
			calculation.dmgM = calculation.dmgM * 1.3
		end
	end
	self.Calculation["Living Bomb"] = function( calculation )
		--Glyph of Living Bomb
		if self:HasGlyph( 63091 ) then
			calculation.hybridCanCrit = true
		end
	end
	self.Calculation["Mirror Image"] = function( calculation )
		--Glyph of Mirror Image
		if self:HasGlyph(63093) then
			calculation.minDam = calculation.minDam * (4/3)
			calculation.maxDam = calculation.maxDam * (4/3)
			calculation.spellDmgM = calculation.spellDmgM * (4/3)
		end
		calculation.critPerc = calculation.critPerc - GetSpellCritChance(5) + 5
		calculation.critM = 0.5
	end
	local DP = GetSpellInfo(48090)
	local DS = GetSpellInfo(48073)
	self.Calculation["Summon Water Elemental"] = function( calculation, ActiveAuras, Talents, _ , baseSpell )
		--TODO: Implement manual hit rating?
		--calculation.hitPerc = self:GetSpellHit()
		calculation.critPerc = calculation.critPerc - GetSpellCritChance(5) + 5
		calculation.critM = 0.5
		--Calculate water elemental spell damage
		local SP = 0
		if UnitBuff("player",DP) then
			SP = 0.1 * calculation.SpellDmg
		end
		if ActiveAuras["Totem of Wrath"] and SP < 280 then
			SP = 280
		end
		if UnitBuff("player",DS) and SP < 80 then
			SP = 80
		end
		calculation.spellDmg = (1/3) * calculation.spellDmg + SP
		--Glyph of Summon Water Elemental
		if self:HasGlyph(56373) then
			calculation.cooldown = calculation.cooldown - 30
		end
		if Talents["Cold as Ice"] then
			calculation.cooldown = calculation.cooldown * (1 - Talents["Cold as Ice"])
		end
		local bonus = 11.5 * (calculation.playerLevel - 50)
		local haste = 1 * (1 + (ActiveAuras["Bloodlust"] and 0.3 or 0)) * (1 + (ActiveAuras["Wrath of Air"] and 0.05 or 0))
		calculation.minDam = calculation.minDam + bonus
		calculation.maxDam = calculation.maxDam + bonus

		--Glyph of Eternal Water
		if self:HasGlyph(70937) then
			calculation.instant = nil
			calculation.castTime = 2.5
			calculation.haste = haste
			calculation.hasteRating = 0
			calculation.cooldown = nil
			baseSpell.NoDPM = true
			baseSpell.NoDoom = true
			baseSpell.NoDPSC = true
			baseSpell.eDot = false
		else
			local duration = 42.5 + (Talents["Enduring Winter"] or 0)
			local hits = math_floor( duration/(2.5/haste) + 0.5 )
			calculation.sHits = hits
			calculation.spellDmgM = calculation.spellDmgM * hits
			calculation.eDuration = duration
			baseSpell.NoDPM = false
			baseSpell.NoDoom = false
			baseSpell.NoDPSC = false
			baseSpell.eDot = true
		end
	end
	self.Calculation["Fire Blast"] = function( calculation, ActiveAuras )
		--Glyph of Fire Blast
		if self:HasGlyph(56369) and (ActiveAuras["Stun"] or ActiveAuras["Deep Freeze"]) then
			calculation.critPerc = calculation.critPerc + 50
		end
	end
	self.Calculation["Scorch"] = function( calculation )
		--Glyph of Scorch (additive - 3.3.3)
		if self:HasGlyph(56371) then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.2
		end
	end
	self.Calculation["Arcane Blast"] = function( calculation )
		if self:GetSetAmount("T9") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
--SETS
	self.SetBonuses["T7"] = { 39491, 39492, 39493, 39494, 39495, 40415, 40416, 40417, 40418, 40419 }
	self.SetBonuses["T9"] = { 47748, 47749, 47750, 47751, 47752, 47773, 47774, 47775, 47776, 47777, 47753, 47754, 47755, 47756, 47757, 47762, 47761, 47760, 47759, 47758, 47772, 47771, 47770, 47769, 47768, 47763, 47764, 47765, 47766, 47767 }
--AURA
--Player
	--Presence of Mind
	self.PlayerAura[GetSpellInfo(12043)] = { Update = true }
	--Frozen Core
	self.PlayerAura[GetSpellInfo(71182)] = { Update = true, Spells = { 116, 44614 } }
	--Icy Veins
	self.PlayerAura[GetSpellInfo(12472)] = { Mods = { ["haste"] = function(v) return v*1.2 end }, ID = 12472 }
	--Arcane Power
	self.PlayerAura[GetSpellInfo(12042)] = { Value = 0.2, ID = 12042, ModType = "dmgM_Add", Mods = { function(calculation) calculation.manaCost = calculation.manaCost + calculation.baseCost * 0.2 end }, Not = { "Summon Water Elemental", "Mirror Image" } }
	--Missile Barrage
	self.PlayerAura[GetSpellInfo(44401)] = { ActiveAura = "Missile Barrage", Spells = 5143, ID = 44401 }
	--Hot Streak
	self.PlayerAura[GetSpellInfo(44445)] = { Update = true, Spells = 11366, ID = 44445 }
	--Fingers of Frost
	self.PlayerAura[GetSpellInfo(44544)] = { ActiveAura = "Frozen", NoManual = true }
	--Firestarter
	self.PlayerAura[GetSpellInfo(54741)] = { Update = true }
	--Fireball! (Brain Freeze)
	self.PlayerAura[GetSpellInfo(57761)] = { Update = true, Spells = { 133, 44614 } }
--Target
	--Frost Nova
	self.TargetAura[GetSpellInfo(122)]   = { ActiveAura = "Frozen", ID = 122, Manual = GetSpellInfo(50635) }
	--Frostbite
	self.TargetAura[GetSpellInfo(12494)] = self.TargetAura[GetSpellInfo(122)]
	--Deep Freeze
	self.TargetAura[GetSpellInfo(44572)] = { ActiveAura = "Deep Freeze", NoManual = true }
--Snares (shows up as Slow in the menu)
	--Thunder Clap
	self.TargetAura[GetSpellInfo(47502)] = { ActiveAura = "Snare", Manual = GetSpellInfo(31589), ID = 47502 }
	--Infected Wounds
	self.TargetAura[GetSpellInfo(58179)] = self.TargetAura[GetSpellInfo(47502)]
	--Frost Fever
	self.TargetAura[GetSpellInfo(55095)] = self.TargetAura[GetSpellInfo(47502)]
	--Slow
	self.TargetAura[GetSpellInfo(31589)] = self.TargetAura[GetSpellInfo(47502)]
	--Frostbolt
	self.TargetAura[GetSpellInfo(116)] = self.TargetAura[GetSpellInfo(47502)]
	--Cone of Cold
	self.TargetAura[GetSpellInfo(120)] = self.TargetAura[GetSpellInfo(47502)]
	--Blast Wave
	self.TargetAura[GetSpellInfo(11113)] = self.TargetAura[GetSpellInfo(47502)]
	--Chilled (Ice and Frost Armor debuff, also Improved Blizzard)
	self.TargetAura[GetSpellInfo(7321)] = self.TargetAura[GetSpellInfo(47502)]
	--Frostfire bolt
	self.TargetAura[GetSpellInfo(47610)] = self.TargetAura[GetSpellInfo(47502)]
--Stuns
	--Impact
	self.TargetAura[GetSpellInfo(12355)] = { ActiveAura = "Stun", Spells = 2136, Manual = GetSpellInfo(47923), ID = 8643 }
	--Gouge
	self.TargetAura[GetSpellInfo(1776)] = self.TargetAura[GetSpellInfo(12355)]
	--Repentance
	self.TargetAura[GetSpellInfo(20066)] = self.TargetAura[GetSpellInfo(12355)]
	--Maim
	self.TargetAura[GetSpellInfo(22570)] = self.TargetAura[GetSpellInfo(12355)]
	--Bash
	self.TargetAura[GetSpellInfo(8983)] = self.TargetAura[GetSpellInfo(12355)]
	--Pounce
	self.TargetAura[GetSpellInfo(9005)] = self.TargetAura[GetSpellInfo(12355)]
	--Intimidation
	self.TargetAura[GetSpellInfo(19577)] = self.TargetAura[GetSpellInfo(12355)]
	--Hammer of Justice
	self.TargetAura[GetSpellInfo(10308)] = self.TargetAura[GetSpellInfo(12355)]
	--Stun (Seal of Justice)
	self.TargetAura[GetSpellInfo(20170)] = self.TargetAura[GetSpellInfo(12355)]
	--Kidney Shot
	self.TargetAura[GetSpellInfo(8643)] = self.TargetAura[GetSpellInfo(12355)]
	--Cheap Shot
	self.TargetAura[GetSpellInfo(1833)] = self.TargetAura[GetSpellInfo(12355)]
	--Shadowfury
	self.TargetAura[GetSpellInfo(30283)] = self.TargetAura[GetSpellInfo(12355)]
	--Intercept
	self.TargetAura[GetSpellInfo(30153)] = self.TargetAura[GetSpellInfo(12355)]
	--Charge
	self.TargetAura[GetSpellInfo(7922)] = self.TargetAura[GetSpellInfo(12355)]
	--Concussion Blow
	self.TargetAura[GetSpellInfo(12809)] = self.TargetAura[GetSpellInfo(12355)]
--Custom
	--Moonkin Aura
	self.PlayerAura[GetSpellInfo(24907)]["Not"] = "Mirror Image"
	--Elemental Oath
	self.PlayerAura[GetSpellInfo(51466)]["Not"] = "Mirror Image"
	--Bloodlust
	if self.PlayerAura[GetSpellInfo(2825)] then self.PlayerAura[GetSpellInfo(2825)]["ActiveAura"] = "Bloodlust"
	--Heroism
	else self.PlayerAura[GetSpellInfo(32182)]["ActiveAura"] = "Bloodlust" end
	--Totem of Wrath
	self.PlayerAura[GetSpellInfo(30706)]["ActiveAura"] = "Totem of Wrath"
	--Wrath of Air
	self.PlayerAura[GetSpellInfo(3738)]["ActiveAura"] = "Wrath of Air"
--Custom
	--Arcane Blast
	self.PlayerAura[GetSpellInfo(30451)] = { School = "Arcane", Ranks = 1, Apps = 4, ID = 30451, ModType =
		function( calculation, _, _, index, apps )
			--Glyph of Arcane Blast (additive - 3.3.3)
			calculation.dmgM_Add = calculation.dmgM_Add + apps * (0.15 + (self:HasGlyph(62210) and 0.03 or 0))
			if not index and calculation.spellName == "Arcane Blast" then
				calculation.manaCost = calculation.manaCost + calculation.baseCost * apps * 1.75
			end
		end
	}
	--Combustion
	self.PlayerAura[GetSpellInfo(11129)] = { School = { ["Fire"] = true, ["Frostfire"] = true }, Apps = 3, ID = 11129, ModType =
		function( calculation, _, _, _, apps )
			calculation.critPerc = calculation.critPerc + apps * 10
			calculation.critM = calculation.critM + 0.25
		end
	}

	self.spellInfo = {
	--FIRE
		[GetSpellInfo(133)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Fireball",
					[0] = { School = "Fire", canCrit = true, castTime = 3.5, eDuration = 8, sTicks = 2, BaseIncrease = true, Downrank = 4 },
					[1] = { 14, 22, 2, 3, extraDotDmg = 2, spellLevel = 1, castTime = 1.5, eDuration = 4, },
					[2] = { 31, 45, 3, 4, extraDotDmg = 3, spellLevel = 6, castTime = 2, eDuration = 6, },
					[3] = { 53, 73, 4, 4, extraDotDmg = 6, spellLevel = 12, castTime = 2.5, eDuration = 6, },
					[4] = { 84, 116, 5, 6, extraDotDmg = 12, spellLevel = 18, castTime = 3, },
					[5] = { 139, 187, 7, 8, extraDotDmg = 20, spellLevel = 24, },
					[6] = { 199, 265, 8, 9, extraDotDmg = 28, spellLevel = 30, },
					[7] = { 255, 335, 9, 10, extraDotDmg = 32, spellLevel = 36, },
					[8] = { 318, 414, 10, 11, extraDotDmg = 40, spellLevel = 42, },
					[9] = { 392, 506, 12, 12, extraDotDmg = 52, spellLevel = 48, },
					[10] = { 475, 609, 13, 14, extraDotDmg = 60, spellLevel = 54, },
					[11] = { 561, 715, 14, 15, extraDotDmg = 72, spellLevel = 60, },
					[12] = { 596, 760, 15, 16, extraDotDmg = 76, spellLevel = 60, },
					[13] = { 633, 805, 16, 16, extraDotDmg = 84, spellLevel = 66, },
					[14] = { 717, 913, 16, 17, extraDotDmg = 92, spellLevel = 70, },
					[15] = { 783, 997, 18, 19, extraDotDmg = 100, spellLevel = 74, },
					[16] = { 888, 1132, 10, 11, extraDotDmg = 116, spellLevel = 78, },
		},
		[GetSpellInfo(2948)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Scorch",
					[0] = { School = "Fire", canCrit = true, BaseIncrease = true, Downrank = 4 },
					[1] = { 53, 65, 3, 4, spellLevel = 22, },
					[2] = { 77, 93, 4, 5, spellLevel = 28, },
					[3] = { 100, 120, 5, 6, spellLevel = 34, },
					[4] = { 133, 159, 6, 6, spellLevel = 40, },
					[5] = { 162, 192, 6, 7, spellLevel = 46, },
					[6] = { 200, 239, 7, 8, spellLevel = 52, },
					[7] = { 233, 275, 8, 9, spellLevel = 58, },
					[8] = { 269, 317, 9, 10, spellLevel = 64, Downrank = 5 },
					[9] = { 305, 361, 10, 10, spellLevel = 70, },
					[10] = { 321, 379, 10, 11, spellLevel = 73, },
					[11] = { 376, 444, 6, 7, spellLevel = 78, },
		},
		[GetSpellInfo(2136)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Fire Blast",
					[0] = { School = "Fire", canCrit = true, Cooldown = 8, BaseIncrease = true, Downrank = 5 },
					[1] = { 24, 32, 3, 3, spellLevel = 6, },
					[2] = { 57, 71, 5, 5, spellLevel = 14, },
					[3] = { 103, 127, 7, 7, spellLevel = 22, },
					[4] = { 168, 202, 9, 9, spellLevel = 30, },
					[5] = { 242, 290, 11, 11, spellLevel = 38, },
					[6] = { 332, 394, 13, 13, spellLevel = 46, },
					[7] = { 431, 509, 15, 15, spellLevel = 54, },
					[8] = { 539, 637, 16, 17, spellLevel = 61, },
					[9] = { 664, 786, 18, 19, spellLevel = 70, },
					[10] = { 760, 900, 20, 20, spellLevel = 74, },
					[11] = { 925, 1095, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(2120)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Flamestrike",
					[0] = { School = "Fire", castTime = 2, canCrit = true, eDuration = 8, sTicks = 2, SPBonus = 0.2357, dotFactor = 0.488, BaseIncrease = true, AoE = true, HybridAoE = true, Downrank = 5 },
					[1] = { 52, 68, 3, 3, hybridDotDmg = 48, spellLevel = 16, },
					[2] = { 96, 122, 4, 4, hybridDotDmg = 88, spellLevel = 24, },
					[3] = { 154, 192, 5, 5, hybridDotDmg = 140, spellLevel = 32, },
					[4] = { 220, 272, 6, 7, hybridDotDmg = 196, spellLevel = 40, },
					[5] = { 291, 359, 7, 8, hybridDotDmg = 264, spellLevel = 48, },
					[6] = { 375, 459, 8, 9, hybridDotDmg = 340, spellLevel = 56, },
					[7] = { 471, 575, 9, 10, hybridDotDmg = 424, spellLevel = 64, },
					[8] = { 688, 842, 11, 12, hybridDotDmg = 620, spellLevel = 72, Downrank = 4 },
					[9] = { 873, 1067, 3, 4, hybridDotDmg = 780, spellLevel = 79, },
		},
		[GetSpellInfo(44614)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Frostfire Bolt",
					[0] = { School = "Frostfire", Double = { 3, 5 }, canCrit = true, castTime = 3, eDuration = 9, sTicks = 3, BaseIncrease = true },
					[1] = { 629, 731, 15, 16, extraDotDmg = 60, spellLevel = 75, },
					[2] = { 722, 838, 0, 0, extraDotDmg = 90, spellLevel = 80, },
		},
		[GetSpellInfo(11366)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Pyroblast",
					[0] = { School = "Fire", castTime = 5, canCrit = true, eDuration = 12, sTicks = 3, SPBonus = 1.15, dotFactor = 0.2, BaseIncrease = true, Downrank = 6 },
					[1] = { 141, 187, 7, 8, hybridDotDmg = 56, spellLevel = 20, },
					[2] = { 180, 236, 13, 14, hybridDotDmg = 72, spellLevel = 24, },
					[3] = { 255, 327, 15, 16, hybridDotDmg = 96, spellLevel = 30, },
					[4] = { 329, 419, 18, 18, hybridDotDmg = 124, spellLevel = 36, },
					[5] = { 407, 515, 20, 21, hybridDotDmg = 156, spellLevel = 42, },
					[6] = { 503, 631, 22, 23, hybridDotDmg = 188, spellLevel = 48, },
					[7] = { 600, 750, 25, 26, hybridDotDmg = 228, spellLevel = 54, },
					[8] = { 708, 898, 27, 28, hybridDotDmg = 268, spellLevel = 60, },
					[9] = { 846, 1074, 30, 30, hybridDotDmg = 312, spellLevel = 66, },
					[10] = { 939, 1191, 32, 33, hybridDotDmg = 356, spellLevel = 70, },
					[11] = { 1014, 1286, 23, 24, hybridDotDmg = 384, spellLevel = 73, },
					[12] = { 1190, 1510, 20, 21, hybridDotDmg = 452, spellLevel = 77, },
		},
		[GetSpellInfo(11113)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Blast Wave",
					[0] = { School = "Fire", canCrit = true, sFactor = 0.90 * 1/2, Cooldown = 45, BaseIncrease = true, AoE = true, Downrank = 6 },
					[1] = { 154, 186, 6, 6, spellLevel = 30, },
					[2] = { 201, 241, 7, 8, spellLevel = 36, },
					[3] = { 277, 329, 8, 9, spellLevel = 44, },
					[4] = { 365, 433, 9, 10, spellLevel = 52, },
					[5] = { 462, 544, 11, 12, spellLevel = 60, },
					[6] = { 533, 627, 12, 13, spellLevel = 65, },
					[7] = { 616, 724, 13, 14, spellLevel = 70, Downrank = 5 },
					[8] = { 882, 1038, 13, 14, spellLevel = 75, Downrank = 5 },
					[9] = { 1047, 1233, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(31661)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Dragon's Breath",
					[0] = { School = "Fire", canCrit = true, sFactor = 0.90 * 1/2, Cooldown = 20, BaseIncrease = true, AoE = true, Downrank = 6 },
					[1] = { 370, 430, 12, 12, spellLevel = 50, },
					[2] = { 454, 526, 9, 10, spellLevel = 56, },
					[3] = { 574, 666, 10, 11, spellLevel = 64, },
					[4] = { 680, 790, 12, 12, spellLevel = 70, },
					[5] = { 935, 1085, 10, 11, spellLevel = 75, },
					[6] = { 1101, 1279, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(44457)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Living Bomb",
					[0] = { School = "Fire", canCrit = true, eDuration = 12, SPBonus = 0.4, dotFactor = 0.8, sTicks = 3, AoE = true, Downrank = 6 },
					[1] = { 306, 306, hybridDotDmg = 612, spellLevel = 60, },
					[2] = { 512, 512, hybridDotDmg = 1024, spellLevel = 70, },
					[3] = { 690, 690, hybridDotDmg = 1380, spellLevel = 80, },
		},
	--FROST
		[GetSpellInfo(116)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Frostbolt",
					[0] = { School = "Frost", castTime = 3, canCrit = true, SPBonus = (3/3.5), BaseIncrease = true, Downrank = 4 },
					[1] = { 18, 20, 2, 2, castTime = 1.5, spellLevel = 4, },
					[2] = { 31, 35, 2, 3, castTime = 1.8, spellLevel = 8, },
					[3] = { 51, 57, 3, 4, castTime = 2.2, spellLevel = 14, },
					[4] = { 74, 82, 4, 5, castTime = 2.6, spellLevel = 20, },
					[5] = { 126, 138, 6, 6, spellLevel = 26, },
					[6] = { 174, 190, 6, 7, spellLevel = 32, },
					[7] = { 227, 247, 8, 8, spellLevel = 38, },
					[8] = { 292, 316, 9, 10, spellLevel = 44, },
					[9] = { 353, 383, 10, 11, spellLevel = 50, },
					[10] = { 429, 463, 11, 12, spellLevel = 56, },
					[11] = { 515, 555, 12, 13, spellLevel = 60, },
					[12] = { 536, 578, 12, 13, spellLevel = 63, },
					[13] = { 597, 643, 14, 14, spellLevel = 69, },
					[14] = { 630, 680, 15, 16, spellLevel = 70, },
					[15] = { 702, 758, 16, 17, spellLevel = 75, },
					[16] = { 799, 861, 4, 5, spellLevel = 79, },
		},
		[GetSpellInfo(10)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Blizzard",
					[0] = { School = "Frost", canCrit = true, castTime = 8, SPBonus = (8/3.5) * 0.5, BaseIncrease = true, sTicks = 1, Channeled = true, AoE = true, Downrank = 5 },
					[1] = { 288, 288, 0, 0, spellLevel = 20, },
					[2] = { 504, 504, 8, 8, spellLevel = 28, },
					[3] = { 736, 736, 8, 8, spellLevel = 36, },
					[4] = { 1024, 1024, 8, 8, spellLevel = 44, },
					[5] = { 1328, 1328, 8, 8, spellLevel = 52, },
					[6] = { 1696, 1696, 16, 16, spellLevel = 60, },
					[7] = { 2184, 2184, 16, 16, spellLevel = 68, },
					[8] = { 2800, 2800, 16, 16, spellLevel = 74, },
					[9] = { 3408, 3408, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(120)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Cone of Cold",
					[0] = { School = "Frost", canCrit = true, SPBonus= (1.5/3.5) * 0.5, Cooldown = 10, BaseIncrease = true, AoE = true, Downrank = 5 },
					[1] = { 98, 108, 4, 4, spellLevel = 26, },
					[2] = { 146, 160, 5, 5, spellLevel = 34, },
					[3] = { 203, 223, 6, 6, spellLevel = 42, },
					[4] = { 264, 290, 6, 7, spellLevel = 50, },
					[5] = { 335, 365, 7, 8, spellLevel = 58, },
					[6] = { 410, 448, 8, 9, spellLevel = 66, Downrank = 4 },
					[7] = { 559, 611, 9, 10, spellLevel = 72, Downrank = 4 },
					[8] = { 707, 773, 2, 3, spellLevel = 79, },
		},
		[GetSpellInfo(122)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Frost Nova",
					[0] = { School = "Frost", canCrit = true, SPBonus = 0.193, Cooldown = 25, BaseIncrease = true, AoE = true, Downrank = 4 },
					[1] = { 19, 21, 2, 3, spellLevel = 10, },
					[2] = { 33, 37, 2, 3, spellLevel = 26, },
					[3] = { 52, 58, 2, 3, spellLevel = 40, },
					[4] = { 70, 80, 2, 3, spellLevel = 54, },
					[5] = { 230, 260, 3, 4, spellLevel = 67, Downrank = 7 },
					[6] = { 365, 415, 3, 4, spellLevel = 75, },
		},
		[GetSpellInfo(30455)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Ice Lance",
					[0] = { School = "Frost", canCrit = true, sFactor = 1/3, BaseIncrease = true, Downrank = 4 },
					[1] = { 161, 187, 12, 13, spellLevel = 66, },
					[2] = { 182, 210, 5, 6, spellLevel = 72, },
					[3] = { 221, 255, 2, 3, spellLevel = 78, },
		},
		[GetSpellInfo(11426)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Ice Barrier",
					[0] = { School = { "Frost", "Absorb" }, Cooldown = 30, SPBonus = 0.8053, NoGlobalMod = true, NoTargetAura = true, NoSchoolTalents = true, NoNext = true, NoDPS = true, NoDoom = true, Unresistable = true, NoDPM = true, BaseIncrease = true, Downrank = 6 },
					[1] = { 438, 438, 16, 16, spellLevel = 40, },
					[2] = { 549, 549, 19, 19, spellLevel = 46, },
					[3] = { 678, 678, 21, 21, spellLevel = 52, },
					[4] = { 818, 818, 24, 24, spellLevel = 58, },
					[5] = { 925, 925, 26, 26, spellLevel = 64, },
					[6] = { 1075, 1075, 28, 28, spellLevel = 70, },
					[7] = { 2800, 2800, 60, 60, spellLevel = 75, },
					[8] = { 3300, 3300, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(31687)] = {
					["Name"] = "Summon Water Elemental",
					[0] = { School = { "Frost", "Pet" }, SPBonus = 5/6, Cooldown = 180, canCrit = true, NoGlobalMod = true, NoNext = true, NoSchoolTalents = true, NoDownrank = true, NoManualRatings = true },
					[1] = { 256, 328, spellLevel = 50, },
		},
		[GetSpellInfo(44572)] = {
					["Name"] = "Deep Freeze",
					[0] = { School = "Frost", canCrit = true, SPBonus = 7.5/3.5, BaseIncrease = true, Cooldown = 30, NoDownrank = true },
					[1] = { 1469, 1741, 900, 900, spellLevel = 60, },
		},
	--ARCANE
		[GetSpellInfo(5143)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Arcane Missiles",
					[0] = { School = "Arcane", SPBonus = 1.4305, canCrit = true, castTime = 5, sHits = 5, BaseIncrease = true, Channeled = true, Downrank = 4 },
					[1] = { 24, 24, 1, 2, castTime = 3, spellLevel = 8, sHits = 3, },
					[2] = { 36, 36, 1, 2, castTime = 4, spellLevel = 16, sHits = 4, },
					[3] = { 56, 56, 2, 2, spellLevel = 24, },
					[4] = { 83, 83, 2, 3, spellLevel = 32, },
					[5] = { 115, 115, 2, 3, spellLevel = 40, },
					[6] = { 151, 151, 3, 4, spellLevel = 48, },
					[7] = { 192, 192, 3, 4, spellLevel = 56, },
					[8] = { 230, 230, 4, 4, spellLevel = 60, },
					[9] = { 240, 240, 3, 4, spellLevel = 63, Downrank = 5 },
					[10] = { 260, 260, 4, 5, spellLevel = 69, },
					[11] = { 280, 280, 5, 6, spellLevel = 70, },
					[12] = { 320, 320, 6, 6, spellLevel = 75, },
					[13] = { 360, 360, 1, 2, spellLevel = 79, },
                },
		[GetSpellInfo(1449)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Arcane Explosion",
					[0] = { School = "Arcane", canCrit = true, sFactor = 1/2, BaseIncrease = true, AoE = true, Downrank = 5 },
					[1] = { 32, 36, 2, 2, spellLevel = 14, },
					[2] = { 57, 63, 3, 3, spellLevel = 22, },
					[3] = { 97, 105, 4, 5, spellLevel = 30, },
					[4] = { 139, 151, 4, 5, spellLevel = 38, },
					[5] = { 186, 202, 5, 6, spellLevel = 46, },
					[6] = { 243, 263, 6, 7, spellLevel = 54, },
					[7] = { 306, 330, 7, 8, spellLevel = 62, },
					[8] = { 377, 407, 8, 8, spellLevel = 70, },
					[9] = { 481, 519, 8, 8, spellLevel = 76, },
					[10] = { 538, 582, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(30451)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Arcane Blast",
					[0] = { School = "Arcane", canCrit = true, castTime = 2.5, BaseIncrease = true, Downrank = 4 },
					[1] = { 842, 978, 20, 20, spellLevel = 64, },
					[2] = { 897, 1041, 21, 22, spellLevel = 71, },
					[3] = { 1047, 1215, 24, 25, spellLevel = 76, },
					[4] = { 1185, 1377, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(44425)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Arcane Barrage",
					[0] = { School = "Arcane",  SPBonus = 2.5/3.5, canCrit = true, Cooldown = 3, BaseIncrease = true, Downrank = 6 },
					[1] = { 386, 470, 15, 15, spellLevel = 60, },
					[2] = { 709, 865, 93, 93, spellLevel = 70, },
					[3] = { 936, 1144, 0, 0, spellLevel = 80, },
		},
		[GetSpellInfo(1463)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Mana Shield",
					[0] = { School = { "Arcane", "Absorb" }, SPBonus = 0.8053, NoGlobalMod = true, NoTargetAura = true, NoSchoolTalents = true, NoDPS = true, NoNext = true, NoDPM = true, NoDoom = true, Unresistable = true, Downrank = 7 },
					[1] = { 120, 120, spellLevel = 20, },
					[2] = { 210, 210, spellLevel = 28, },
					[3] = { 300, 300, spellLevel = 36, },
					[4] = { 390, 390, spellLevel = 44, },
					[5] = { 480, 480, spellLevel = 52, },
					[6] = { 570, 570, spellLevel = 60, },
					[7] = { 715, 715, spellLevel = 68, },
					[8] = { 1080, 1080, spellLevel = 73, Downrank = 4 },
					[9] = { 1330, 1330, spellLevel = 79, },
        	},
		--Mirror Image
		--NOTE: information taken from the front page of EJ's thread.  http://elitistjerks.com/f75/t30655-wotlk_complete_mage_compendium_3_1_updated/
		--12 * (88-98 + 0.05c) + 24 * (163-169 + 0.1c) = 12 Fire Blast + 24 Frostbolt
		[GetSpellInfo(55342)] = {
					["Name"] = "Mirror Image",
					[0] = { School = "Arcane", eDot = true, eDuration = 30, SPBonus = 3, Cooldown = 180, canCrit = true, NoSchoolTalents = true, NoDownrank = true, NoManualRatings = true, NoNext = true },
					[1] = { 4968, 5232, spellLevel = 80, },
		},
		[GetSpellInfo(6143)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Frost Ward",
					[0] = { School = { "Frost", "Absorb" }, SPBonus = 0.8053, NoGlobalMod = true, NoTargetAura = true, NoSchoolTalents = true, NoDPS = true, NoNext = true, NoDPM = true, NoDoom = true, Unresistable = true, Downrank = 9 },
					[1] = { 165, 165, spellLevel = 22, },
					[2] = { 290, 290, spellLevel = 32, },
					[3] = { 470, 470, spellLevel = 42, },
					[4] = { 675, 675, spellLevel = 52, Downrank = 7 },
					[5] = { 875, 875, spellLevel = 60,  },
					[6] = { 1125, 1125, spellLevel = 70, Downrank = 8 },
					[7] = { 1950, 1950, spellLevel = 79, },
		},
		[GetSpellInfo(543)] = {
					--DONE: BASE OK, INCREASE OK, COEFFICIENT OK, DOWNRANK OK
					["Name"] = "Fire Ward",
					[0] = { School = { "Fire", "Absorb" }, SPBonus = 0.8053, NoGlobalMod = true, NoTargetAura = true, NoSchoolTalents = true, NoDPS = true, NoNext = true, NoDPM = true, NoDoom = true, Unresistable = true, Downrank = 9 },
					[1] = { 165, 165, spellLevel = 20, },
					[2] = { 290, 290, spellLevel = 30, },
					[3] = { 470, 470, spellLevel = 40, },
					[4] = { 675, 675, spellLevel = 50, },
					[5] = { 875, 875, spellLevel = 60, Downrank = 8 },
					[6] = { 1125, 1125, spellLevel = 69, },
					[7] = { 1950, 1950, spellLevel = 78, },
		},
	}
	self.talentInfo = {
	--ARCANE:
		--Arcane Focus
		[GetSpellInfo(11222)] = {	[1] = { Effect = 1, Spells = "Arcane", ModType = "hitPerc" }, },
		--Spell Impact (additive - 3.3.3 - Tested Arcane Explosion, Scorch, Ice Lance)
		[GetSpellInfo(11242)] = {	[1] = { Effect = 0.02, Spells = { "Arcane Explosion", "Arcane Blast", "Blast Wave", "Fire Blast", "Scorch", "Ice Lance", "Cone of Cold" }, },
									[2] = { Effect = 0.02, Spells = "Fireball", ModType = "dmgM_dd_Add" }, },
		--Torment the Weak (multiplicative - 3.3.3)
		[GetSpellInfo(29447)] = {	[1] = { Effect = 0.04, Spells = { "Frostbolt", "Fireball", "Frostfire Bolt", "Arcane Missiles", "Arcane Blast", "Arcane Barrage", "Pyroblast" }, ModType = "Torment the Weak" }, },
		--Arcane Instability (multiplicative - 3.3.3)
		[GetSpellInfo(15058)] = {	[1] = { Effect = 0.01, Multiply = true, Spells = "All" }, },
		--Arcane Empowerment (additive - 3.3.3)
		[GetSpellInfo(31579)] = { 	[1] = { Effect = 0.15, Spells = "Arcane Missiles", ModType = "SpellDamage", },
									[2] = { Effect = 0.03, Spells = "Arcane Blast", ModType = "SpellDamage", }, },
		--Mind Mastery
		[GetSpellInfo(31584)] = { 	[1] = { Effect = 0.03, Spells = "Frostfire Bolt", ModType = "Mind Mastery" }, },
		--Spell Power
		[GetSpellInfo(35578)] = { 	[1] = { Effect = 0.125, Spells = "All", ModType = "critM" }, },
	--FIRE:
		--Improved Fire Blast
		[GetSpellInfo(11078)] = { 	[1] = { Effect = -1, Spells = "Fire Blast", ModType = "cooldown", }, },
		--Incineration
		[GetSpellInfo(18459)] = { 	[1] = { Effect = 2, Spells = { "Fire Blast", "Scorch", "Arcane Blast", "Cone of Cold" }, ModType = "critPerc", }, },
		--Ignite
		[GetSpellInfo(11119)] = { 	[1] = { Effect = 0.08, Spells = { "Fire", "Frostfire Bolt" }, ModType = "Ignite", }, },
		--World in Flames
		[GetSpellInfo(11108)] = {	[1] = { Effect = 2, Spells = { "Flamestrike", "Pyroblast", "Blast Wave", "Dragon's Breath", "Living Bomb", "Blizzard", "Arcane Explosion" }, ModType = "critPerc", }, },
		--Improved Scorch
		[GetSpellInfo(11095)] = { 	[1] = { Effect = 1, Spells = { "Scorch", "Fireball", "Frostfire Bolt" }, ModType = "critPerc" }, },
		--Master of Elements
		[GetSpellInfo(29074)] = { 	[1] = { Effect = 0.1, Spells = "All", ModType = "freeCrit" }, },
		--Playing with Fire (multiplicative - 3.3.3)
		[GetSpellInfo(31638)] = { 	[1] = { Effect = 0.01, Multiply = true, Spells = "All", }, },
		--Fire Power (additive - 3.3.3 - Tested Scorch, Fire Blast with Spell Impact)
		[GetSpellInfo(11124)] = {	[1] = { Effect = 0.02, Spells = { "Fireball", "Flamestrike", "Pyroblast", "Blast Wave", "Scorch", "Fire Blast", "Dragon's Breath", "Frostfire Bolt", "Living Bomb" }, },},
		--Molten Fury
		[GetSpellInfo(31679)] = {	[1] = { Effect = 0.06, Spells = "All", ModType = "Molten Fury", }, },
		--Empowered Fire (additive - 3.3.3)
		[GetSpellInfo(31656)] = { 	[1] = { Effect = 0.05, Spells = { "Fireball", "Frostfire Bolt", "Pyroblast" }, ModType = "SpellDamage" }, },
		--Burnout
		[GetSpellInfo(44449)] = {	[1] = { Effect = 0.05, Spells = "All", ModType = "critM" }, },
	--FROST:
		--Ice Floes
		[GetSpellInfo(31670)] = {	[1] = { Effect = { -1.75, -3.5, 5 }, Spells = "Frost Nova", ModType = "cooldown" },
									[2] = { Effect = { -0.7, -1.4, -2 }, Spells = "Cone of Cold", ModType = "cooldown" }, },
		--Ice Shards
		[GetSpellInfo(11207)] = { 	[1] = { Effect = { 0.165, 0.33, 0.5 }, Spells = { "Frost", "Frostfire Bolt" }, ModType = "critM", }, },
		--Precision
		[GetSpellInfo(29438)] = { 	[1] = { Effect = 1, Spells = "All", ModType = "hitPerc" }, },
		--Permafrost
		[GetSpellInfo(11175)] = { 	[1] = { Effect = { 0, 3, 3 }, Spells = "Frostfire Bolt", ModType = "eDuration" }, },
		--Piercing Ice (multiplicative - 3.3.3)
		[GetSpellInfo(11151)] = { 	[1] = { Effect = 0.02, Multiply = true, Spells = { "Frost", "Frostfire Bolt" }, }, },
		--Shatter
		[GetSpellInfo(11170)] = { 	[1] = { Effect = { 17, 34, 50 }, Spells = "All", ModType = "Shatter" }, },
		--Improved Cone of Cold (additive - 3.3.3)
		[GetSpellInfo(11190)] = { 	[1] = { Effect = { 0.15, 0.25, 0.35 }, Spells = "Cone of Cold", }, },
		--Cold as Ice
		[GetSpellInfo(55091)] = {	[1] = { Effect = { -3, -6 }, Spells = "Ice Barrier", ModType = "cooldown" },
									[2] = { Effect = 0.1, Spells = "Summon Water Elemental", ModType = "Cold as Ice" }, },
		--Winter's Chill
		[GetSpellInfo(11180)] = { 	[1] = { Effect = 1, Spells = "Frostbolt", ModType = "critPerc" }, },
		--Arctic Winds (multiplicative - 3.3.3)
		[GetSpellInfo(31674)] = { 	[1] = { Effect = 0.01, Multiply = true, Spells = { "Frost", "Frostfire Bolt" }, }, },
		--Empowered Frostbolt (additive - 3.3.3)
		[GetSpellInfo(31682)] = { 	[1] = { Effect = 0.05, Spells = "Frostbolt", ModType = "SpellDamage" }, },
		--Enduring Winter
		[GetSpellInfo(44557)] = { 	[1] = { Effect = 5, Spells = "Summon Water Elemental", ModType = "Enduring Winter" }, },
		--Chilled to the Bone (additive - 3.3.3 - Tested with Frostbolt and Ice Lance)
		[GetSpellInfo(44566)] = { 	[1] = { Effect = 0.01, Spells = { "Frostbolt", "Frostfire Bolt", "Ice Lance" }, }, },
	}
end