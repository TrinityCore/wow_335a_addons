if select(2, UnitClass("player")) ~= "HUNTER" then return end
local GetSpellInfo = GetSpellInfo
local UnitCreatureType = UnitCreatureType
local UnitRangedDamage = UnitRangedDamage
local GetTrackingTexture = GetTrackingTexture
local GetInventoryItemLink = GetInventoryItemLink
local IsEquippedItem = IsEquippedItem
local tonumber = tonumber
local string_match = string.match
local string_find = string.find
local string_lower = string.lower
local select = select
local math_min = math.min
local math_max = math.max

local trackingtypes = {
	--Track Beasts
	["Interface\\Icons\\Ability_Tracking"] = true,
	--Track Demons
	["Interface\\Icons\\Spell_Shadow_SummonFelHunter"] = true,
	--Track Dragonkin
	["Interface\\Icons\\INV_Misc_Head_Dragon_01"] = true,
	--Track Elementals
	["Interface\\Icons\\Spell_Frost_SummonWaterElemental"] = true,
	--Track Giants
	["Interface\\Icons\\Ability_Racial_Avatar"] = true,
	--Track Humanoids
	["Interface\\Icons\\Spell_Holy_PrayerOfHealing"] = true,
	--Track Undead
	["Interface\\Icons\\Spell_Shadow_DarkSummoning"] = true,
 }
--Track Beasts, Sense Demons, Track Dragonkin, Track Elementals, Track Giants, Track Humanoids, Sense Undead
local tracking = string_lower(GetSpellInfo(1494) .. GetSpellInfo(5500) .. GetSpellInfo(19879) .. GetSpellInfo(19880) .. GetSpellInfo(19882) .. GetSpellInfo(19883) .. GetSpellInfo(5502))

function DrDamage:PlayerData()
--EVENTS
	local oldammo = GetInventoryItemLink("player", 0)
	function DrDamage:UNIT_RANGEDDAMAGE(unit)
		if unit["player"] then
			local newammo = GetInventoryItemLink("player", 0)
			if newammo ~= oldammo then
				oldammo = newammo
				if not self.fullUpdate then
					self:UpdateAB()
				end
			end
		end
	end
--GENERAL
	local piercingshots = GetSpellInfo(53234)
	self.Calculation["HUNTER"] = function( calculation, ActiveAuras, Talents, spell, baseSpell )
		if ActiveAuras["Serpent Sting"] and Talents["Noxious Stings"] then --Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * (1 + Talents["Noxious Stings"])
		end
		if ActiveAuras["Hunter's Mark"] and Talents["Marked for Death"] then --Multiplicative - 3.3.3
			calculation.dmgM = calculation.dmgM * (1 + Talents["Marked for Death"])
		end
		if Talents["Rapid Killing"] and ActiveAuras["Rapid Killing"] then --Additive - 3.3.3
			calculation.dmgM_Add = calculation.dmgM_Add + Talents["Rapid Killing"]
		end		
		if Talents["Improved Tracking"] and calculation.subType ~= "Trap" and GetTrackingTexture() and trackingtypes[GetTrackingTexture()] then --Multiplicative - 3.3.3
			local target = UnitCreatureType("target")
			if target and string_find(tracking,string_lower(target)) then
				calculation.dmgM = calculation.dmgM * (1 + Talents["Improved Tracking"])
			end
		end		
		if ActiveAuras["Frozen"] and Talents["Point of No Escape"] then
			calculation.critPerc = calculation.critPerc + Talents["Point of No Escape"]
		end
		if Talents["Piercing Shots"] then
			calculation.extraDamage = 0
			calculation.extraCrit = Talents["Piercing Shots"]
			calculation.extraChanceCrit = true
			calculation.extraTicks = 8
			calculation.extraName = piercingshots
		end
		if spell.spellLevel then
			local mod = math_min(1,math_max(0,(22 + spell.spellLevel + (spell.Downrank or 5) - calculation.playerLevel) * 0.05))
			if mod < 1 then
				if calculation.APBonus then
					calculation.APBonus = calculation.APBonus * mod
				end
				if calculation.extraDamage  then
					calculation.extraDamage = calculation.extraDamage * mod
				end
			end		
		end
	end
--TALENTS
	local wildquiver = GetSpellInfo(53215)
	self.Calculation["Wild Quiver"] = function( calculation, value )
		calculation.extraDamage = 0
		calculation.extraWeaponDamage = 0.8
		calculation.extraChance = value
		calculation.extra_canCrit = true
		calculation.extraName = wildquiver
	end
	self.Calculation["Ranged Weapon Specialization"] = function( calculation, value )
		calculation.wDmgM = calculation.wDmgM * (1 + value)
		calculation.dmgM = calculation.dmgM * (1 + value)
	end
--ABILITIES
	self.Calculation["Steady Shot"] = function( calculation, ActiveAuras, _, spell )
		local min, max = self:GetRangedBase()
		local spd = select(3,self:GetWeaponSpeed())
		local ammo = self:GetAmmoDmg()
		if spd then
			calculation.minDam = calculation.minDam + min/spd * 2.8 + ammo * 2.8
			calculation.maxDam = calculation.maxDam + max/spd * 2.8 + ammo * 2.8
		end
		if ActiveAuras["Dazed"] then
			calculation.minDam = calculation.minDam + 175
			calculation.maxDam = calculation.maxDam + 175
		end
		--Glyph of Steady Shot (multiplicative - 3.3.3)
		if self:HasGlyph(56826) and ActiveAuras["Serpent Sting"] then
			calculation.dmgM = calculation.dmgM * 1.1
		end
	end
	self.Calculation["Aimed Shot"] = function( calculation, ActiveAuras, Talents )
		if ActiveAuras["Improved Steady Shot"] then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.15
		end
		--Glyph of Trueshot Aura
		if self:HasGlyph(56842) and ActiveAuras["Trueshot Aura"] then
			calculation.critPerc = calculation.critPerc + 10
		end
		--Glyph of Aimed Shot
		if self:HasGlyph(56824) then
			calculation.cooldown = calculation.cooldown - 2
		end
	end
	self.Calculation["Multi-Shot"] = function( calculation )
		--Gladiator's Chain Gauntlets
		if IsEquippedItem( 28335 ) or IsEquippedItem( 31961 ) or IsEquippedItem( 33665 ) then
			calculation.dmgM = calculation.dmgM * 1.05
		end
		--Glyph of Multi-Shot
		if self:HasGlyph(56836) then
			calculation.cooldown = calculation.cooldown - 1
		end

	end
	self.Calculation["Arcane Shot"] = function ( calculation, ActiveAuras, Talents )
		if ActiveAuras["Improved Steady Shot"] then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.15
		end
	end
	self.Calculation["Chimera Shot"] = function ( calculation, ActiveAuras, Talents )
		if ActiveAuras["Improved Steady Shot"] then
			calculation.dmgM_Add = calculation.dmgM_Add + 0.15
		end
		if ActiveAuras["Serpent Sting"] then
			--Modify Chimera tooltip to include damage on targets with Serpent Sting active
			local dmgtoadd = (1 + (Talents["Improved Stings"] or 0)) * (self:GetRAP() * 0.2 + select(ActiveAuras["Serpent Sting"], 20, 40, 80, 140, 210, 290, 385, 490, 555, 660, 990, 1210))
			calculation.minDam = calculation.minDam + 0.4 * dmgtoadd
			calculation.maxDam = calculation.maxDam + 0.4 * dmgtoadd
		end
		--Glyph of Chimera Shot
		if self:HasGlyph(63065) then
			calculation.cooldown = calculation.cooldown - 1
		end
	end
	self.Calculation["Explosive Shot"] = function ( calculation )
		--Glyph of Explosive Shot
		if self:HasGlyph(63066) then
			calculation.critPerc = calculation.critPerc + 4
		end
	end
	self.Calculation["Explosive Trap"] = function ( calculation, ActiveAuras, Talents, spell )
		--Glyph of Explosive Trap
		if self:HasGlyph(63068) then
			calculation.E_canCrit = true
			calculation.critM = 0.5
		end
		--BUG: WHAT THE FUCK IS THIS SHIT??? 3.3.3
		if not Talents["Careful Aim"] then
			calculation.extra = calculation.extra + (spell.ExtraBonus or 0)
		end
		--NOTE: Direct damage part does not benefit from +dmg% (tested Ferocious Inspiration, Aspect of the Viper, Improved Tracking). Benefits from Noxious Stings.
		calculation.dmgM_Extra = calculation.dmgM * select(6,UnitRangedDamage("player"))
		--Base damage gain:
		local playerLevel = calculation.playerLevel
		local spellLevel = spell.spellLevel
		if playerLevel > spellLevel then
			if playerLevel >= 80 then
				calculation.minDam = calculation.minDam + spell[3]
				calculation.maxDam = calculation.maxDam + spell[4]
			else
				local gainLevels = math_min(80 - spellLevel, spell.Downrank or 5)
				calculation.minDam = calculation.minDam + spell[3] * math_min(1,(playerLevel - spellLevel) / gainLevels)
				calculation.maxDam = calculation.maxDam + spell[4] * math_min(1,(playerLevel - spellLevel) / gainLevels)
			end
		end		
	end
	self.Calculation["Black Arrow"] = function ( calculation, _, Talents, spell )
		--BUG: WHAT THE FUCK IS THIS SHIT??? 3.3.3
		if not Talents["Careful Aim"] then
			calculation.minDam = calculation.minDam + (spell.ExtraBonus or 0)
			calculation.maxDam = calculation.maxDam + (spell.ExtraBonus or 0)
		end
	end		
	self.Calculation["Immolation Trap"] = function ( calculation, ActiveAuras, Talents )
		--Glyph of Immolation Trap
		if self:HasGlyph(56846) then
			calculation.eDuration = calculation.eDuration - 6
			calculation.minDam = calculation.minDam * 1.2
			calculation.maxDam = calculation.maxDam * 1.2
			calculation.APBonus = calculation.APBonus * 1.2
			--BUG?: Talents effects are halved - 3.3.3
			calculation.dmgM_Add = calculation.dmgM_Add * 0.5
		end
		--NOTE: Does not benefit from +dmg% (tested Ferocious Inspiration, Aspect of the Viper, Improved Tracking). Benefits from Noxious Stings.		
	end
	self.Calculation["Serpent Sting"] = function ( calculation, _, Talents )
		--Glyph of Serpent Sting
		if self:HasGlyph(56832) then
			calculation.eDuration = calculation.eDuration + 6
		end
		if self:GetSetAmount("T8") >= 2 then
			calculation.dmgM = calculation.dmgM * 1.1
		end
		if self:GetSetAmount("T9") >= 2 then
			calculation.NoCrits = false
			calculation.critM = (1 + (Talents["Mortal Shots"] or 0))
		end
	end
	self.Calculation["Kill Shot"] = function ( calculation )
		--Glyph of Kill Shot
		if self:HasGlyph(63067) then
			calculation.cooldown = calculation.cooldown - 6
		end
	end
	self.Calculation["Wyvern Sting"] = function ( calculation )
		--Glyph of Wyvern Sting
		if self:HasGlyph(56848) then
			calculation.cooldown = calculation.cooldown - 6
		end
	end
	self.Calculation["Volley"] = function ( calculation, _, Talents )
		--BUG: This is weird... (last tested: 3.3.3)
		if not Talents["Careful Aim"] then
			calculation.minDam = calculation.minDam + 31.5
			calculation.maxDam = calculation.maxDam + 31.5
		end
		if select(3,self:GetWeaponType()) then
			calculation.haste = calculation.haste * select(3,self:GetWeaponSpeed()) / (calculation.rspd * 1.15)
		end
		calculation.customHaste = true
	end
--SETS
	self.SetBonuses["T8"] = { 45360, 45361, 45362, 45363, 45364, 46141, 46142, 46143, 46144, 46145 }
	self.SetBonuses["T9"] = { 48250, 48251, 48252, 48253, 48254, 48275, 48276, 48277, 48278, 48279, 48273, 48272, 48271, 48270, 48274, 48266, 48267, 48268, 48269, 48265, 48256, 48257, 48258, 48259, 48255, 48263, 48262, 48261, 48260, 48264 }
--AURA
--Player
	--Rapid Killing
	self.PlayerAura[GetSpellInfo(35098)] = { ActiveAura = "Rapid Killing", ID = 35098 }
	--Trueshot Aura
	self.PlayerAura[GetSpellInfo(31519)] = { ActiveAura = "Trueshot Aura", ID = 31519, Mods = { ["AP"] = function(v) return v * 1.1 end }, Category = "+10% AP" }	
	--Improved Steady Shot
	self.PlayerAura[GetSpellInfo(53220)] = { Spells = { 19434, 3044, 53209 }, ActiveAura = "Improved Steady Shot", ID = 53220, Multiply = true, Mods = { ["actionCost"] = -0.2 } }
	--Sniper Training
	self.PlayerAura[GetSpellInfo(53302)] = { Spells = { 56641, 19434, 3674, 53301 }, ModType = "dmgM_Add", Value = 0.02, Ranks = 3, ID = 53302 }
	--Aspect of the Viper
	self.PlayerAura[GetSpellInfo(34074)] = { ActiveAura = "Aspect of the Viper", NoManual = true }
--Target
	--Freezing Trap Effect
	self.TargetAura[GetSpellInfo(3355)] = { ActiveAura = "Frozen", ID = 3355, Manual = GetSpellInfo(3355) }
	--Frost Trap Aura
	self.TargetAura[GetSpellInfo(13810)] = self.TargetAura[GetSpellInfo(3355)]
	--Freezing Arrow Effect
	self.TargetAura[GetSpellInfo(60210)] = self.TargetAura[GetSpellInfo(3355)]
	--Dazed
	self.TargetAura[GetSpellInfo(1604)] = { ActiveAura = "Dazed", Spells = 34120, ID = 1604 }
	--Black Arrow
	self.TargetAura[GetSpellInfo(63672)] = { Value = 0.06, Not = "Black Arrow", ID = 63672 }
	--Serpent Sting
	self.TargetAura[GetSpellInfo(1978)] = { ActiveAura = "Serpent Sting", Ranks = 12, ID = 1978 }
--Custom
	--Hunter's Mark
	self.TargetAura[GetSpellInfo(1130)] = { School = "Ranged", Ranks = 5, ID = 1130, ModType =
		function( calculation, ActiveAuras, Talents, _, _, _, rank )
			--Glyph of Hunter's Mark
			calculation.AP = calculation.AP + (select(rank, 20, 45, 75, 110, 500)) * (1 + (Talents["Improved Hunter's Mark"] or 0) + (self:HasGlyph(56829) and 0.2 or 0))
			ActiveAuras["Hunter's Mark"] = true
		end
	}

	self.spellInfo = {
		[GetSpellInfo(75)] = {
			["Name"] = "Auto Shot",
			[0] = { School = { "Physical", "Ranged", "Shot" }, WeaponDamage = 1, NoNormalization = true, AutoShot = true, DPSrg = true },
			[1] = { 0 },
		},
		[GetSpellInfo(3044)] = {
			["Name"] = "Arcane Shot",
			[0] = { School = { "Arcane", "Ranged", "Shot" }, Cooldown = 6, APBonus = 0.15 },
			[1] = { 15, spellLevel = 6, },
			[2] = { 23, spellLevel = 12, },
			[3] = { 36, spellLevel = 20, },
			[4] = { 65, spellLevel = 28, },
			[5] = { 91, spellLevel = 36, },
			[6] = { 125, spellLevel = 44, },
			[7] = { 158, spellLevel = 52, Downrank = 7 },
			[8] = { 200, spellLevel = 60, Downrank = 7 },
			[9] = { 273, spellLevel = 69, Downrank = 4 },
			[10] = { 402, spellLevel = 73, Downrank = 4 },
			[11] = { 492, spellLevel = 79, },
		},
		[GetSpellInfo(19434)] = {
			["Name"] = "Aimed Shot",
			[0] = { School = { "Physical", "Ranged", "Shot" }, WeaponDamage = 1, Cooldown = 10, BleedExtra = true, },
			[1] = { 5 },
			[2] = { 35 },
			[3] = { 55 },
			[4] = { 90 },
			[5] = { 110 },
			[6] = { 150 },
			[7] = { 205 },
			[8] = { 345 },
			[9] = { 408 },
		},
		[GetSpellInfo(2643)] = {
			["Name"] = "Multi-Shot",
			[0] = { School = { "Physical", "Ranged", "Shot" }, WeaponDamage = 1, Cooldown = 10, AoE = 3 },
			[1] = { 0 },
			[2] = { 40 },
			[3] = { 80 },
			[4] = { 120 },
			[5] = { 150 },
			[6] = { 205 },
			[7] = { 333 },
			[8] = { 408 },
		},
		[GetSpellInfo(19503)] = {
			["Name"] = "Scatter Shot",
			[0] = { School = { "Physical", "Ranged", "Shot" }, WeaponDamage = 0.5, Cooldown = 30 },
			[1] = { 0 },
		},
		[GetSpellInfo(34490)] = {
			["Name"] = "Silencing Shot",
			[0] = { School = { "Physical", "Ranged", "Shot" }, WeaponDamage = 0.5, Cooldown = 20 },
			[1] = { 0 },
		},
		[GetSpellInfo(34120)] = {
			["Name"] = "Steady Shot",
			[0] = { School = { "Physical", "Ranged", "Shot" }, castTime = 2, APBonus = 0.1, DPSrg = true, BleedExtra = true },
			[1] = { 45 },
			[2] = { 108 },
			[3] = { 198 },
			[4] = { 252 },
		},
		[GetSpellInfo(1510)] = {
			["Name"] = "Volley",
			[0] = { School = { "Arcane", "Ranged", }, eDuration = 6, Ticks = 1, APBonus = 6 * 0.0837, AoE = true },
			[1] = { 312 },
			[2] = { 474 },
			[3] = { 630 },
			[4] = { 1008 },
			[5] = { 1740 },
			[6] = { 2118 },
		},
		[GetSpellInfo(53351)] = {
			["Name"] = "Kill Shot",
			[0] = { School = { "Physical", "Ranged", "Shot" }, WeaponDamage = 2, APBonus = 0.4, Cooldown = 15 },
			[1] = { 410 },
			[2] = { 500 },
			[3] = { 650 },
		},
		[GetSpellInfo(53209)] = {
			["Name"] = "Chimera Shot",
			[0] = { School = { "Nature", "Ranged", "Shot" }, WeaponDamage = 1.25, Cooldown = 10, BleedExtra = true },
			[1] = { 0 },
		},
		[GetSpellInfo(13795)] = {
			["Name"] = "Immolation Trap",
			[0] = { School = { "Fire", "Ranged", "Trap" }, NoGlobalMod = true, SpellCritM = true, Unresistable = true, APBonus = 0.1, NoCrits = true, eDuration = 15, Ticks = 3, Cooldown = 30, NoWeapon = true },
			[1] = { 105, spellLevel = 16, },
			[2] = { 215, spellLevel = 26, },
			[3] = { 340, spellLevel = 36, },
			[4] = { 510, spellLevel = 46, },
			[5] = { 690, spellLevel = 56, Downrank = 6 },
			[6] = { 985, spellLevel = 65, Downrank = 5 },
			[7] = { 1540, spellLevel = 72, Downrank = 4 },
			[8] = { 1885, spellLevel = 78, Downrank = 2 },
		},
		[GetSpellInfo(13813)] = {
			["Name"] = "Explosive Trap",
			[0] = { School = { "Fire", "Ranged", "Trap" }, NoGlobalMod = true, SpellCritM = true, Unresistable = true, APBonus = 0.1, AoE = true, NoCrits = true, ExtraDamage = 1, E_eDuration = 20, E_Ticks = 2, E_AoE = true, Cooldown = 30, NoWeapon = true, AoE = true },
			[1] = { 100, 130, 3, 4, Extra = 150, spellLevel = 34, Downrank = 5, }, --Guessed downrank
			[2] = { 139, 187, 5, 6, Extra = 240, spellLevel = 44, Downrank = 5, }, --Guessed downrank
			[3] = { 201, 257, 6, 8, Extra = 330, spellLevel = 54, Downrank = 6, },
			[4] = { 263, 337, 8, 9, Extra = 450, ExtraBonus = 30, spellLevel = 61, Downrank = 6, },
			[5] = { 434, 556, 7, 8, Extra = 740, ExtraBonus = 50, spellLevel = 71, Downrank = 4, },
			[6] = { 523, 671, 8, 8, Extra = 900, ExtraBonus = 60, spellLevel = 77, Downrank = 3, },
		},
		[GetSpellInfo(19386)] = {
			["Name"] = "Wyvern Sting",
			[0] = { School = { "Nature", "Ranged" }, NoCrits = true, eDuration = 6 },
			[1] = { 300 },
			[2] = { 420 },
			[3] = { 600 },
			[4] = { 942 },
			[5] = { 2082 },
			[6] = { 2460 },
		},
		[GetSpellInfo(1978)] = {
			["Name"] = "Serpent Sting",
			[0] = { School = { "Nature", "Ranged" }, SpellCritM = true, APBonus = 0.2, NoCrits = true, eDuration = 15, Ticks = 3 },
			[1] = { 20, spellLevel = 4, },
			[2] = { 40, spellLevel = 10, },
			[3] = { 80, spellLevel = 18, },
			[4] = { 140, spellLevel = 26, },
			[5] = { 210, spellLevel = 34, },
			[6] = { 290, spellLevel = 42, },
			[7] = { 385, spellLevel = 50, },
			[8] = { 490, spellLevel = 58, Downrank = 1 },
			[9] = { 555, spellLevel = 60, Downrank = 6 },
			[10] = { 660, spellLevel = 67, Downrank = 5 },
			[11] = { 990, spellLevel = 73, Downrank = 6 },
			[12] = { 1210, spellLevel = 79, },
		},
		[GetSpellInfo(2973)] = {
			["Name"] = "Raptor Strike",
			[0] = { WeaponDamage = 1, Cooldown = 6, NextMelee = true, NoNormalization = true },
			[1] = { 5 },
			[2] = { 11 },
			[3] = { 21 },
			[4] = { 34 },
			[5] = { 50 },
			[6] = { 80 },
			[7] = { 110 },
			[8] = { 140 },
			[9] = { 170 },
			[10] = { 275 },
			[11] = { 335 },
		},
		[GetSpellInfo(1495)] = {
			["Name"] = "Mongoose Bite",
			[0] = { Cooldown = 5, APBonus = 0.2, NoWeapon = true, NoNormalization = true },
			[1] = { 25 },
			[2] = { 45 },
			[3] = { 75 },
			[4] = { 115 },
			[5] = { 150 },
			[6] = { 280 },
		},
		[GetSpellInfo(19306)] = {
			["Name"] = "Counterattack",
			[0] = { Cooldown = 5, APBonus = 0.2, NoWeapon = true, Unavoidable = true },
			[1] = { 48 },
			[2] = { 84 },
			[3] = { 132 },
			[4] = { 196 },
			[5] = { 288 },
			[6] = { 342 },
		},
		[GetSpellInfo(3674)] = {
			["Name"] = "Black Arrow",
			[0] = { School = { "Shadow", "Ranged" }, Cooldown = 30, APBonus = 0.115, NoCrits = true, eDuration = 15, Ticks = 3 },
			[1] = { 785, ExtraBonus = 7 },
			[2] = { 940, ExtraBonus = 7 },
			[3] = { 1205, ExtraBonus = 7 },
			[4] = { 1480, ExtraBonus = 46 },
			[5] = { 2240, ExtraBonus = 46 },
			[6] = { 2765, ExtraBonus = 7 },
		},
		[GetSpellInfo(53301)] = {
			["Name"] = "Explosive Shot",
			[0] = { School = { "Fire", "Ranged", "Shot" }, APBonus = 0.14, Cooldown = 6, Hits = 3, NoHits = true },
			[1] = { 144, 172 },
			[2] = { 221, 265 },
			[3] = { 325, 391 },
			[4] = { 386, 464 },
		},
	}
	self.talentInfo = {
	--BEAST MASTERY:
		--Ferocious Inspiration (Arcane Shot bonus is additive - 3.3.3)
		[GetSpellInfo(34455)] = {	[1] = { Effect = 0.03, Spells = { "Arcane Shot", "Steady Shot" }, }, },
		--Spirit Bond
		[GetSpellInfo(19578)] = { 	[1] = { Effect = 0.05, Caster = true, Spells = "Lifeblood", ModType = "Lifeblood Bonus" }, },
	--MARKMANSHIP:
		--Focused Aim
		[GetSpellInfo(53620)] = { 	[1] = { Effect = 1, Spells = "All", ModType = "hitPerc", }, },
		--Careful Aim
		[GetSpellInfo(34482)] = {	[1] = { Effect = 1, Spells = { "Explosive Trap", "Volley", "Black Arrow" }, ModType = "Careful Aim" }, },
		--Improved Hunter's Mark
		[GetSpellInfo(19421)] = {	[1] = { Effect = 0.1, Spells = "Ranged", ModType = "Improved Hunter's Mark" }, },
		--Mortal Shots
		[GetSpellInfo(19485)] = {	[1] = { Effect = 0.06, Spells = "Ranged", Not = "Auto Shot", ModType = "critM" }, 
									[2] = { Effect = 0.03, Spells = "Serpent Sting", ModType = "Mortal Shots" }, },
		--Improved Arcane Shot (additive - 3.3.3)
		[GetSpellInfo(19454)] = {	[1] = { Effect = 0.05, Spells = "Arcane Shot" }, },
		--Rapid Killing (additive - 3.3.3)
		[GetSpellInfo(34948)] = {	[1] = { Effect = 0.1, Spells = { "Aimed Shot", "Arcane Shot", "Chimera Shot" }, ModType = "Rapid Killing"  }, },
		--Improved Stings (A/M - currently doesn't matter)
		[GetSpellInfo(19464)] = {	[1] = { Effect = 0.1, Spells = { "Serpent Sting", "Wyvern Sting" } },
									[2] = { Effect = 0.1, Spells = "Chimera Shot", ModType = "Improved Stings" } },
		--Barrage (A/M - currently doesn't matter)
		[GetSpellInfo(19461)] = {	[1] = { Effect = 0.04, Spells = { "Aimed Shot", "Multi-Shot", "Volley" } }, },
		--Piercing Shots
		[GetSpellInfo(53234)] = {	[1] = { Effect = 0.1, Spells = { "Aimed Shot", "Steady Shot", "Chimera Shot" }, ModType = "Piercing Shots" }, },
		--Ranged Weapon Specialization (multiplicative - 3.3.3)
		[GetSpellInfo(19507)] = {	[1] = { Effect = { 0.01, 0.03, 0.05 }, Spells = { "Shot", "Volley" }, ModType = "Ranged Weapon Specialization" }, },
		--Improved Barrage
		[GetSpellInfo(35104)] = {	[1] = { Effect = 4, Spells = { "Aimed Shot", "Multi-Shot" }, ModType = "critPerc" }, },
		--Wild Quiver
		[GetSpellInfo(53215)] = {	[1] = { Effect = 0.04, Spells = "Auto Shot", ModType = "Wild Quiver" }, },
		--Marked for Death (multiplicative - 3.3.3)
		[GetSpellInfo(53241)] = { 	[1] = { Effect = 0.01, Spells = "Shot", ModType = "Marked for Death" },
									[2] = { Effect = 0.02, Spells = { "Aimed Shot", "Arcane Shot", "Steady Shot", "Kill Shot", "Chimera Shot" }, ModType = "critM" }, },
	--SURVIVAL:
		--Improved Tracking (multiplicative - 3.3.3)
		[GetSpellInfo(52783)] = {	[1] = { Effect = 0.01, Spells = "Ranged", ModType = "Improved Tracking" }, },
		--Savage Strikes
		[GetSpellInfo(19159)] = {	[1] = { Effect = 10, Spells = { "Raptor Strike", "Mongoose Bite", "Counterattack" }, ModType = "critPerc" }, },
		--Trap Mastery (additive - 3.3.3)
		[GetSpellInfo(19376)] = {	[1] = { Effect = 0.1, Spells = { "Immolation Trap", "Black Arrow" },  },
									[2] = { Effect = 0.1, Spells = "Explosive Trap", ModType = "dmgM_Extra_Add" }, },
		--Survival Instincts
		[GetSpellInfo(34494)] = {	[1] = { Effect = 2, Spells = { "Arcane Shot", "Steady Shot", "Explosive Shot" }, ModType = "critPerc" }, },
		--T.N.T. (additive - 3.3.3)
		[GetSpellInfo(56333)] = {	[1] = { Effect = 0.02, Spells = { "Explosive Shot", "Explosive Trap", "Immolation Trap", "Black Arrow" }, }, },
		--Resourcefulness
		[GetSpellInfo(34491)] = {	[1] = { Effect = -2, Spells = { "Explosive Trap", "Immolation Trap", "Black Arrow" }, ModType = "cooldown" }, },
		--Thrill of the Hunt
		[GetSpellInfo(34497)] = { 	[1] = { Effect = { 0.4*(1/3), 0.4*(2/3), 0.4 }, Spells = "Shot", ModType = "freeCrit" }, },
		--Noxious Stings (multiplicative - 3.3.3)
		[GetSpellInfo(53295)] = { 	[1] = { Effect = 0.01, Spells = "All", ModType = "Noxious Stings" }, },
		--Point of No Escape
		[GetSpellInfo(53298)] = {	[1] = { Effect = 3, Spells = "All", ModType = "Point of No Escape" }, },
		--Sniper Training (Kill Shot bonus only, rest handled elsewhere)
		[GetSpellInfo(53302)] = {	[1] = { Effect = 5, Spells = "Kill Shot", ModType = "critPerc" }, },
	}
end
