local _, playerClass = UnitClass("player")
if playerClass ~= "ROGUE" and playerClass ~= "WARRIOR" and playerClass ~= "HUNTER" and playerClass ~= "DRUID" and playerClass ~= "PALADIN" and playerClass ~= "SHAMAN" and playerClass ~= "DEATHKNIGHT" then return end
local playerHybrid = (playerClass == "DRUID") or (playerClass == "PALADIN") or (playerClass == "SHAMAN") or (playerClass == "DEATHKNIGHT")

--Libraries
DrDamage = DrDamage or LibStub("AceAddon-3.0"):NewAddon("DrDamage","AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceBucket-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("DrDamage", true)
local GT = LibStub:GetLibrary("LibGratuity-3.0")
local DrDamage = DrDamage

--General
local settings
local type = type
local next = next
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local math_abs = math.abs
local math_floor = math.floor
local math_ceil = math.ceil
local math_min = math.min
local math_max = math.max
local math_modf = math.modf
local string_match = string.match
local string_sub = string.sub
local string_gsub = string.gsub
local select = select

--Module
local GetSpellInfo = GetSpellInfo
local GetCritChance = GetCritChance
local GetRangedCritChance = GetRangedCritChance
local GetCombatRating = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus
local GetItemInfo = GetItemInfo
local GetItemStats = GetItemStats
local GetInventoryItemLink = GetInventoryItemLink
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local GetComboPoints = GetComboPoints
local GetShieldBlock = GetShieldBlock
local GetShapeshiftForm = GetShapeshiftForm
local GetExpertise = GetExpertise
local GetArmorPenetration = GetArmorPenetration
local GetSpellBonusDamage = GetSpellBonusDamage
local GetSpellCritChance = GetSpellCritChance
local UnitRangedDamage = UnitRangedDamage
local UnitRangedAttack = UnitRangedAttack
local UnitRangedAttackPower = UnitRangedAttackPower
local UnitDamage = UnitDamage
local UnitAttackSpeed = UnitAttackSpeed
local UnitAttackPower = UnitAttackPower
local UnitAttackBothHands = UnitAttackBothHands
local UnitExists = UnitExists
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType
local UnitIsPlayer = UnitIsPlayer
local UnitDebuff = UnitDebuff
local UnitBuff = UnitBuff
local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitGUID = UnitGUID
local OffhandHasWeapon = OffhandHasWeapon
local IsEquippedItem = IsEquippedItem

--Module variables
local DrD_ClearTable, DrD_Round, DrD_MatchData, DrD_DmgCalc, DrD_BuffCalc
local spellInfo, Calculation, PlayerAura, TargetAura, Consumables

function DrDamage:Melee_OnEnable()
	local ABOptions = self.options.args.General.args.Actionbar.args
	if settings.DisplayType_M then
		if not ABOptions.DisplayType_M.values[settings.DisplayType_M] then
			settings.DisplayType_M = "AvgTotal"
		end
	end
	if settings.DisplayType_M2 then
		if not ABOptions.DisplayType_M2.values[settings.DisplayType_M2] then
			settings.DisplayType_M2 = false
		end
	end

	self:Melee_InventoryChanged(true, true, true)
	if not self:GetWeaponType() then self:ScheduleTimer(function() self:Melee_InventoryChanged(true, true, true); self:UpdateAB() end, 10) end
	
	self.spellInfo[GetSpellInfo(6603)] = {
		["Name"] = "Attack",
		[0] = { AutoAttack = true, Melee = true, WeaponDamage = 1, NoNormalization = true, MeleeHaste = true },
		[1] = { 0 },
	}	

	DrD_ClearTable = self.ClearTable
	DrD_Round = self.Round
	DrD_MatchData = self.MatchData
	DrD_BuffCalc = self.BuffCalc
	spellInfo = self.spellInfo
	PlayerAura = self.PlayerAura
	TargetAura = self.TargetAura
	Consumables = self.Consumables
	Calculation = self.Calculation
end

function DrDamage:Melee_RefreshConfig()
	settings = self.db.profile
end

--Other events
function DrDamage:UNIT_COMBO_POINTS(event, unit)
	if settings.ComboPoints == 0 and unit == "player" then
		self:CancelTimer(self.fullUpdate, true)
		self.fullUpdate = self:ScheduleTimer("UpdateAB", 0.1)
	end
end

local oldValues = 0
function DrDamage:Melee_CheckBaseStats()
	local newValues =
	GetCombatRating(6)
	--+ GetCombatRating(7)
	--+ GetCombatRating(18)
	--+ GetCombatRating(19)
	+ self:GetAP()
	+ self:GetRAP()
	+ GetCritChance()
	+ GetRangedCritChance()
	+ UnitAttackSpeed("player")
	+ UnitDamage("player")
	+ select(3,UnitDamage("player"))
	+ UnitRangedDamage("player")
	+ select(2,UnitRangedDamage("player"))
	+ GetShieldBlock()
	+ GetArmorPenetration()
	+ GetExpertise()

	if newValues ~= oldValues then
		oldValues = newValues
		return true
	end

	return false
end

local mhType, ohType, rgType
function DrDamage:GetWeaponType()
	return mhType, ohType, rgType
end

local mhMin, mhMax, ohMin, ohMax, rgMin, rgMax = 0, 0, 0, 0, 0, 0
local mhSpeed, ohSpeed = 2.4, 2.4
local rgSpeed = 2.8

function DrDamage:Melee_InventoryChanged(mhslot, ohslot, rangedslot)
	if mhslot then
		local mh = GetInventoryItemLink("player", 16)
		if mh and GT:SetInventoryItem("player", 16) then
			for i = 3, GT:NumLines() do
				local line = GT:GetLine(i,true)
				line = line and string_match(line,"%d.%d+")
				if line then
					mhSpeed = tonumber((string_gsub(line,",","%.")))
					mhMin, mhMax = string_match(GT:GetLine(i), "(%d+)[^%d]+(%d+)")
					mhMin = tonumber(mhMin) or 0
					mhMax = tonumber(mhMax) or 0
					break
				end
			end
			mhType = select(7,GetItemInfo(mh))
		else
			mhType = nil
			mhMin, mhMax = 0, 0
			mhSpeed = UnitAttackSpeed("player")
		end
	end
	if ohslot then
		local oh = GetInventoryItemLink("player", 17)
		if oh and GT:SetInventoryItem("player", 17) then
			for i = 3, GT:NumLines() do
				local line = GT:GetLine(i,true)
				line = line and string_match(line,"%d.%d+")
				if line then
					ohSpeed = tonumber((string_gsub(line,",","%.")))
					ohMin, ohMax = string_match(GT:GetLine(i), "(%d+)[^%d]+(%d+)")
					ohMin = tonumber(ohMin) or 0
					ohMax = tonumber(ohMax) or 0
					break
				end
			end
			ohType = select(7,GetItemInfo(oh))
		else
			ohType = nil
			ohSpeed = select(2,UnitAttackSpeed("player"))
		end
	end
	if rangedslot then
		local ranged = GetInventoryItemLink("player", 18)
		if ranged and GT:SetInventoryItem("player", 18) then
			for i = 3, GT:NumLines() do
				local line = GT:GetLine(i,true)
				line = line and string_match(line,"%d.%d+")
				if line then
					rgSpeed = tonumber((string_gsub(line,",","%.")))
					rgMin, rgMax = string_match(GT:GetLine(i), "(%d+)[^%d]+(%d+)")
					rgMin = tonumber(rgMin) or 0
					rgMax = tonumber(rgMax) or 0
					break
				end


			end
			rgType = select(7,GetItemInfo(ranged))
		else
			rgType = nil
			rgMin, rgMax = 0, 0
			rgSpeed = UnitRangedDamage("player")
		end
	end
end

function DrDamage:GetMainhandBase()
	return mhMin, mhMax
end

function DrDamage:GetOffhandBase()
	return ohMin, ohMax
end

function DrDamage:GetRangedBase()
	return rgMin, rgMax
end

local statTable = {}
local ammoDmg = 0
local oldammo
function DrDamage:GetAmmoDmg()
	local ammo = GetInventoryItemLink("player", 0)
	if ammo then
		if ammo ~= oldammo then
			oldammo = ammo
			statTable["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = nil
			GetItemStats(ammo,statTable)
			ammoDmg = statTable["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] or 0
		end
	else
		oldammo = nil
		ammoDmg = 0
	end
	return ammoDmg * 3
end

function DrDamage:GetWeaponSpeed()
	return mhSpeed, ohSpeed, rgSpeed
end

function DrDamage:GetAP()
	local baseAP, posBuff, negBuff = UnitAttackPower("player")
	return baseAP + posBuff + negBuff
end

function DrDamage:GetRAP()
	local baseAP, posBuff, negBuff = UnitRangedAttackPower("player")
	return baseAP + posBuff + negBuff
end

local normalizationTable = {
	--[[
	"Daggers"
	"One-Handed Axes"
	"One-Handed Maces"
	"One-Handed Swords"
	"Fist Weapons"
	"Two-Handed Axes"
	"Two-Handed Maces"
	"Two-Handed Swords"
	"Polearms"
	"Staves"
	"Fishing Poles"
	--]]
	[GetSpellInfo(1180)] = 1.7,
	[GetSpellInfo(196)] = 2.4,
	[GetSpellInfo(198)] = 2.4,
	[GetSpellInfo(201)] = 2.4,
	[GetSpellInfo(15590)] = 2.4,
	[GetSpellInfo(197)] = 3.3,
	[GetSpellInfo(199)] = 3.3,
	[GetSpellInfo(202)] = 3.3,
	[GetSpellInfo(200)] = 3.3,
	[GetSpellInfo(227)] = 3.3,
	[GetSpellInfo(7738)] = 3.3,
}
function DrDamage:GetNormM()
	return mhType and normalizationTable[mhType] or 2, ohType and normalizationTable[ohType] or 2
end

function DrDamage:WeaponDamage(calculation, wspd)
	local min, max, omin, omax, mod
	local spd, normM, normM_O
	local mh, oh = self:GetNormM()
	local AP = calculation.AP
	local baseAP

	if calculation.ranged then
		_, min, max, _, _, mod = UnitRangedDamage("player")
		spd = rgSpeed
		normM = wspd and spd or 2.8
		baseAP = self:GetRAP()
	else
		min, max, omin, omax, _, _, mod = UnitDamage("player")
		baseAP = self:GetAP()

		if calculation.requiresForm then
			if calculation.requiresForm == 1 then
				spd = 2.5
				normM = 2.5
			elseif calculation.requiresForm == 3 then
				spd = 1
				normM = 1
			end
		else
			spd = mhSpeed
			normM = wspd and mhSpeed or mh
			normM_O = wspd and ohSpeed or oh
		end
	end

	local bonus, obonus = normM / 14
	--This is used to divide out possible bonuses included in the range returned by the API.
	mod = calculation.wDmgM * mod

	min = (min/(mod) - (baseAP / 14) * spd + bonus * AP)
	max = (max/(mod) - (baseAP / 14) * spd + bonus * AP)

	if calculation.offHand and omin and omax and ohSpeed then
		obonus = normM_O / 14
		omin = (omin/(calculation.offHdmgM * mod) - (baseAP / 14) * ohSpeed + obonus * AP) * calculation.offHdmgM
		omax = (omax/(calculation.offHdmgM * mod) - (baseAP / 14) * ohSpeed + obonus * AP) * calculation.offHdmgM
	end

	return min, max, omin, omax, bonus, obonus
end

function DrDamage:GetRageGain( avg, calculation )
    local level = calculation.playerLevel
	local avgFactor = 3.5 + 3.5 * (calculation.critPerc/100)
	local conversion = 0.0091107836 * level * level + 3.225598133 * level + 4.2652911
	return (3.75 * (avg / conversion) + 0.5 * (mhSpeed * avgFactor))
end

function DrDamage:GetMeleeHit(playerLevel, targetLevel, ranged, unarmed)
	local skill, skillO, hit, hitO
	if ranged then
		hit = 95 + GetCombatRatingBonus(7)
		hitO = hit
		skill = rgType and UnitRangedAttack("player")
	else
		hit = 95 + GetCombatRatingBonus(6)
		hitO = hit
		if not (unarmed or (settings.TargetLevel == 0) and UnitIsPlayer("target") or (playerClass == "DRUID" and GetShapeshiftForm() > 0)) then
			local mskill, _, oskill = UnitAttackBothHands("player")
			skill = mhType and mskill
			skillO = ohType and oskill
		end
	end
	skill = targetLevel * 5 - (skill or playerLevel * 5)
	skillO = targetLevel * 5 - (skillO or playerLevel * 5)
	hit = hit - math_max(-10,math_min(10,skill)) * 0.1 - math_max(0, skill - 10) * 0.4 - math_min(0, skill + 10) * 0.4
	hitO = hitO - math_max(-10,math_min(10,skillO)) * 0.1 - math_max(0, skillO - 10) * 0.4 - math_min(0, skillO + 10) * 0.4
	return hit, hitO
end

--Static tables
local powerTypes = { [0] = L["DPM"], [1] = L["DPR"], [3] = L["DPE"], [6] = L["DPRP"] }
local powerTypeNames = { [0] = L["Mana"], [1] = L["Rage"], [3] = L["Energy"], [6] = L["Runic Power"] }
local schoolTable = { ["Holy"] = 2, ["Fire"] = 3, ["Nature"] = 4, ["Frost"] = 5, ["Shadow"] = 6, ["Arcane"] = 7 }
local mobArmor = {
	--Initiate's Training Dummy (level 55)
	[32545] = 3230,
	--Expert's Training Dummy (level 60)
	[32666] = 3750,
	--Disciple's Training Dummy (level 65)
	[32542] = 5210,
	--Master's Training Dummy (level 70)
	[32667] = 6710,
	--Veteran's Training Dummy (level 75)
	[32543] = 8250,
	--Grandmaster's Training Dummy (level 80)
	[31144] = 9730,
	--Ebon Knight's Training Dummy (level 80)
	[32546] = 9730,
}

--Temporary tables
local calculation = {}
local ActiveAuras = {}
local AuraTable = {}
local Talents = {}
local CalculationResults = {}

function DrDamage:MeleeCalc( name, rank, tooltip, modify, debug )
	if not spellInfo or not name then return end
	if not rank then
		_, rank = GetSpellInfo(name)
	elseif tonumber(rank) and GetSpellInfo(name) then
		rank = string_gsub(select(2,GetSpellInfo(name)),"%d+", rank)
	end

	local spellTable = spellInfo[name]
	if not spellTable then return end
	local baseSpell = spellTable[0]

	if type(baseSpell) == "function" then
		baseSpell, spellTable = baseSpell()
		if not (baseSpell and spellTable) then return end
	end

	local spell = spellTable[(rank and tonumber(string_match(rank,"%d+"))) or 1]
	if not spell then return end
	local spellName = spellTable["Name"]
	local spellTalents = spellTable["Talents"]
	local spellPlayerAura = spellTable["PlayerAura"]
	local spellTargetAura = spellTable["TargetAura"]
	local spellConsumables = spellTable["Consumables"]
	local textLeft = spellTable["Text1"]
	local textRight = spellTable["Text2"]

	DrD_ClearTable( calculation )

	calculation.offHdmgM = 0.5
	calculation.offHand = OffhandHasWeapon()
	calculation.bDmgM = 1
	calculation.bDmgM_O = 1
	calculation.wDmgM = 1
	calculation.dmgM_Add = 0
	calculation.dmgM_dd_Add = 0
	calculation.dmgM_dd = 1
	calculation.dmgM_Extra = 1
	calculation.dmgM_Extra_Add = 0
	calculation.dmgM_Magic = 1
	calculation.APBonus = baseSpell.APBonus
	calculation.APM = 1
	calculation.NoCrits = baseSpell.NoCrits
	calculation.eDuration = spell.eDuration or baseSpell.eDuration or 0
	calculation.castTime = spell.castTime or baseSpell.castTime or 0
	calculation.WeaponDamage = spell.WeaponDamage or baseSpell.WeaponDamage
	calculation.DualAttack = baseSpell.DualAttack and 1
	calculation.actionCost = select(4,GetSpellInfo(name,rank)) or 0
	calculation.baseCost = calculation.actionCost
	calculation.powerType = select(6,GetSpellInfo(name,rank)) or 4
	calculation.cooldown = baseSpell.Cooldown or 0
	calculation.requiresForm = baseSpell.requiresForm
	calculation.hitPerc = 0
	calculation.name = name
	calculation.spellName = spellName
	calculation.tooltipName = textLeft
	calculation.tooltipName2 = textRight
	calculation.Hits = baseSpell.Hits
	calculation.freeCrit = 0
	calculation.bleedBonus = 1
	calculation.rageBonus = 1
	calculation.SPBonus = baseSpell.SPBonus
	calculation.spellDmg = baseSpell.SPBonus and GetSpellBonusDamage(2) or 0
	calculation.armorPen = GetArmorPenetration()/100
	calculation.armorM = 0
	--calculation.armorMod = 0
	calculation.mitigation = 1
	calculation.expertise, calculation.expertise_O = GetExpertise()
	calculation.dmgBonus = 0
	calculation.finalMod = 0
	calculation.E_eDuration = baseSpell.E_eDuration
	calculation.E_canCrit = baseSpell.E_canCrit
	calculation.extra = spell.Extra or 0
	calculation.extra_O = 0
	calculation.extraDamage = baseSpell.ExtraDamage
	calculation.extraDamage_O = 0
	calculation.extraDamBonus = 0
	calculation.extraDamBonus_O = 0
	calculation.extraChance = 1
	calculation.extraChance_O = 1
	calculation.blockValue = GetShieldBlock()
	calculation.aoe = baseSpell.AoE
	calculation.targets = settings.TargetAmount
	calculation.spd, calculation.ospd = UnitAttackSpeed("player")
	calculation.rspd =  UnitRangedDamage("player")
	calculation.spellCrit = 0
	calculation.spellHit = 0
	calculation.meleeCrit = 0
	calculation.meleeHit = 0
	
	--Determine levels used to calculate
	local playerLevel, targetLevel, boss = self:GetLevels()
	if settings.TargetLevel > 0 then
		targetLevel = playerLevel + settings.TargetLevel
	end
	calculation.playerLevel = playerLevel
	calculation.targetLevel = targetLevel

	if settings.ComboPoints == 0 then
		calculation.Melee_ComboPoints = GetComboPoints("player")
	else
		calculation.Melee_ComboPoints = settings.ComboPoints
	end

	--[[
	if not calculation.castTime then
		if baseSpell.NextMelee then
			calculation.castTime = mhSpeed
		elseif playerClass == "ROGUE" or playerClass == "DRUID" and GetShapeshiftForm() == 3 then
			calculation.castTime = 1
		elseif baseSpell.AutoShot then
			calculation.castTime = UnitRangedDamage("player")
		else
			calculation.castTime = 1.5
		end
	end
	--]]

	if type( baseSpell.School ) == "table" then
		calculation.school = baseSpell.School[1]
		calculation.group = baseSpell.School[2]
		calculation.subType = baseSpell.School[3]
	else
		calculation.school = baseSpell.School or "Physical"
	end

	if calculation.group == "Ranged" then
		calculation.ranged = true
		calculation.AP = self:GetRAP()
		calculation.critPerc = GetRangedCritChance()
		calculation.critM = 1
		calculation.dmgM = baseSpell.NoGlobalMod and 1 or select(6,UnitRangedDamage("player"))
		calculation.haste = 1 + (GetCombatRatingBonus(19)/100)
		calculation.hasteRating = GetCombatRating(19)
	else
		calculation.ranged = false
		calculation.AP = self:GetAP()
		calculation.critPerc = baseSpell.SpellCrit and GetSpellCritChance(schoolTable[baseSpell.SpellCrit] or 1) or GetCritChance()
		calculation.critM = baseSpell.SpellCrit and 0.5 or 1
		calculation.dmgM = baseSpell.NoGlobalMod and 1 or select(7,UnitDamage("player"))
		calculation.haste = baseSpell.BaseHaste or (1 + (GetCombatRatingBonus(18)/100))
		calculation.hasteRating = baseSpell.BaseHaste and 0 or GetCombatRating(18)
	end
	
	--Checks
	calculation.physical = (calculation.school == "Physical")
	calculation.unarmed = (calculation.school == "Physical" and not calculation.ranged) and not mhType or baseSpell.requiresForm
	if baseSpell.Weapon and baseSpell.Weapon ~= mhType
	or baseSpell.Offhand and baseSpell.Offhand ~= ohType
	or baseSpell.OffhandAttack and not ohType
	or calculation.ranged and not rgType
	or calculation.unarmed and not baseSpell.AutoAttack and not baseSpell.NoWeapon and not baseSpell.requiresForm then
		calculation.zero = true
	end

	calculation.spd = calculation.spd * calculation.haste
	calculation.ospd = calculation.ospd and calculation.ospd * calculation.haste
	calculation.rspd = calculation.rspd and calculation.rspd * calculation.haste

	if baseSpell.SpellHit then
		calculation.hit = self:GetSpellHit(playerLevel, targetLevel)
	else
		calculation.hit, calculation.hitO = self:GetMeleeHit(playerLevel, targetLevel, calculation.ranged, calculation.unarmed)
	end

	--CORE: Manual variables from profile:
	if settings.Custom then
		if settings.CustomAdd then
			calculation.AP = math_max(0, calculation.AP + settings.AP)
			calculation.spellDmg = math_max(0, calculation.spellDmg + settings.SpellDamage)
			calculation.expertise = math_max(0, calculation.expertise + self:GetRating("Expertise", settings.ExpertiseRating, true))
			calculation.expertise_O = math_max(0, (calculation.expertise_O or 0) + self:GetRating("Expertise", settings.ExpertiseRating, true))
			calculation.armorPen = math_max(0, calculation.armorPen + 0.01 * self:GetRating("ArmorPenetration", settings.ArmorPenetrationRating, true))
			if not baseSpell.NoManualRatings then
				calculation.haste = math_max(1,(calculation.haste + 0.01 * self:GetRating("MeleeHaste", settings.HasteRating, true)))
				calculation.hasteRating = math_max(0, calculation.hasteRating + settings.HasteRating)
			end
		else
			calculation.AP = math_max(0, settings.AP)
			calculation.spellDmg = math_max(0, settings.SpellDamage)
			calculation.expertise = math_max(0, self:GetRating("Expertise", settings.ExpertiseRating, true))
			calculation.expertise_O = math_max(0, self:GetRating("Expertise", settings.ExpertiseRating, true))
			calculation.armorPen = math_max(0, 0.01 * self:GetRating("ArmorPenetration", settings.ArmorPenetrationRating, true))
			if not baseSpell.NoManualRatings then
				calculation.haste = math_max(1,(0.01 * self:GetRating("MeleeHaste", settings.HasteRating, true)))
				calculation.hasteRating = math_max(0, settings.HasteRating)
				calculation.critPerc = calculation.critPerc - GetCombatRatingBonus((baseSpell.SpellCrit and 11 or 9))
				calculation.hitPerc = calculation.hitPerc - GetCombatRatingBonus((baseSpell.SpellHit and 8 or 6))
			end
		end
		if not baseSpell.NoManualRatings then
			calculation.spellHit = self:GetRating("Hit", settings.HitRating, true)
			calculation.meleeHit = self:GetRating("MeleeHit", settings.HitRating, true)
			calculation.meleeCrit = self:GetRating("Crit", settings.CritRating, true)
			calculation.spellCrit = calculation.meleeCrit
		end		
	end

	calculation.minDam = spell[1]
	calculation.maxDam = (spell[2] or spell[1])

	--RELICS
	if self.RelicSlot and self.RelicSlot[spellName] then
		local data = self.RelicSlot[spellName]
		local count = #data
		if count then
			for i = 1, count - 1, 2 do
				if data[i] and data[i+1] then
					if IsEquippedItem(data[i]) or debug then
						local modTypeAll = data["ModTypeAll"]
						local modType = data["ModType"..((i+1)/2)] or modTypeAll
						if not modType then
							calculation.minDam = calculation.minDam + data[i+1]
							calculation.maxDam = calculation.maxDam + data[i+1]
						elseif calculation[modType] then
							calculation[modType] = calculation[modType] + data[i+1]
						elseif modTypeAll then
							calculation[modTypeAll] = data[i+1]							
						end
					end
				end
			end
		end
	end

	--TALENTS
	for i=1,#spellTalents do
		local talentValue = spellTalents[i]
		local modType = spellTalents["ModType" .. i]

		if calculation[modType] then
			if spellTalents["Multiply" .. i] then
				calculation[modType] = calculation[modType] * (1 + talentValue)
			else
				calculation[modType] = calculation[modType] + talentValue
			end
		elseif self.Calculation[modType] then
			self.Calculation[modType](calculation, talentValue, baseSpell)
		else
			Talents[modType] = talentValue
		end
	end

	--BUFF/DEBUFF CALCULATION
	for index=1,40 do
		local buffName, rank, texture, apps = UnitBuff("player",index)
		if buffName then
			if spellPlayerAura[buffName] then
				DrD_BuffCalc( PlayerAura[buffName], calculation, ActiveAuras, Talents, baseSpell, buffName, index, apps, texture, rank, "player" )
				AuraTable[buffName] = true
			end
		else break end
	end
	for index=1,40 do
		local buffName, rank, texture, apps = UnitDebuff("player",index)
		if buffName then
			if spellPlayerAura[buffName] then
				DrD_BuffCalc( PlayerAura[buffName], calculation, ActiveAuras, Talents, baseSpell, buffName, index, apps, texture, rank, "player" )
				AuraTable[buffName] = true
			end
		else break end
	end
	for index=1,40 do
		local buffName, rank, texture, apps = UnitDebuff("target",index)
		if buffName then
			if spellTargetAura[buffName] then
				DrD_BuffCalc( TargetAura[buffName], calculation, ActiveAuras, Talents, baseSpell, buffName, index, apps, texture, rank, "target" )
				AuraTable[buffName] = true
			end
		else break end
	end
	if next(settings["PlayerAura"]) or debug then
		for buffName in pairs(debug and spellPlayerAura or settings["PlayerAura"]) do
			if spellPlayerAura[buffName] and not AuraTable[buffName] then
				DrD_BuffCalc( PlayerAura[buffName], calculation, ActiveAuras, Talents, baseSpell, buffName )
			end
		end
	end
	if next(settings["TargetAura"]) or debug then
		for buffName in pairs(debug and spellTargetAura or settings["TargetAura"]) do
			if spellTargetAura[buffName] and not AuraTable[buffName] then
				DrD_BuffCalc( TargetAura[buffName], calculation, ActiveAuras, Talents, baseSpell, buffName )
			end
		end
	end
	if next(settings["Consumables"]) or debug then
		for buffName in pairs(debug and spellConsumables or settings["Consumables"]) do
			if spellConsumables[buffName] then
				local aura = Consumables[buffName]
				if not UnitBuff("player", (aura.Alt or buffName)) then
					DrD_BuffCalc( aura, calculation, ActiveAuras, Talents, baseSpell, buffName )
				end
			end
		end
	end

	--CORE: Sum up crit and hit
	if baseSpell.SpellCrit then
		calculation.critPerc = calculation.critPerc + calculation.spellCrit
	else
		calculation.critPerc = calculation.critPerc + calculation.meleeCrit
	end
	if baseSpell.SpellHit then
		calculation.hitPerc = calculation.hitPerc + calculation.spellHit
	else
		calculation.hitPerc = calculation.hitPerc + calculation.meleeHit
	end
	--Store global modifier
	calculation.dmgM_global = calculation.dmgM
	--Add magic damage buffs
	if schoolTable[calculation.school] then
		calculation.dmgM = calculation.dmgM * calculation.dmgM_Magic
	end

	--ADD CLASS SPECIFIC MODS
	if Calculation[playerClass] then
		Calculation[playerClass]( calculation, ActiveAuras, Talents, spell, baseSpell )
	end
	if Calculation[spellName] then
		Calculation[spellName]( calculation, ActiveAuras, Talents, spell, baseSpell )
	end

	--Calculate haste modifiers, sum up AP
	calculation.spd = calculation.spd / calculation.haste
	calculation.ospd = calculation.ospd and calculation.ospd / calculation.haste
	calculation.rspd = calculation.rspd and calculation.rspd / calculation.haste
	calculation.AP = calculation.AP * calculation.APM

	--CRIT MODIFIER CALCULATION (NEEDS TO BE DONE AFTER TALENTS)
	if baseSpell.SpellCrit or baseSpell.SpellCritM then
		calculation.critM = calculation.critM * (1 + 3 * self.Damage_critMBonus)
	else
		calculation.critM = calculation.critM * (1 + 2 * self.Damage_critMBonus)
	end

	--CORE: CRIT DEPRESSION, GLANCING BLOWS, DODGE, PARRY
	if settings.TargetLevel > 0 or not UnitIsPlayer("target") then
		if not baseSpell.SpellHit or baseSpell.Avoidable then
			local deltaLevel = targetLevel - playerLevel
			if boss then
				calculation.critDepression = boss and 4.8
			elseif deltaLevel > 0 then
				calculation.critDepression = deltaLevel * 0.6 + ((deltaLevel >= 3) and 3 or 0)
			end
			if not calculation.ranged and not baseSpell.Unavoidable then
				if boss then
					calculation.dodge = 6.5 - (calculation.dodgeMod or 0)
					calculation.parry = 14 - (calculation.parryMod or 0)
				elseif deltaLevel >= 0 then
					calculation.dodge = 5 + deltaLevel * 0.2 + math_floor(deltaLevel/3) * 0.9 - (calculation.dodgeMod or 0)
					calculation.parry = 5 + deltaLevel * 0.2 + math_floor(deltaLevel/3) * 8.4 - (calculation.parryMod or 0)
				end
				if baseSpell.AutoAttack or baseSpell.Glancing then
					if boss then
						calculation.glancing = 24
						calculation.glancingM = 0.75
					elseif deltaLevel >= 0 then
						calculation.glancing = (deltaLevel + 1) * 6
						calculation.glancingM = 1 - (deltaLevel + 1) * 0.0625
					end
				end
				if baseSpell.NoParry then
					calculation.parry = nil
				end
				if calculation.NoDodge then
					calculation.dodge = nil
				end
			end
		end
	end

	--CORE: ARMOR
	if settings.ArmorCalc ~= "None" and (calculation.physical and not baseSpell.eDuration and not baseSpell.Bleed or baseSpell.Armor) then
		local armor = 0
		local armorLevel = UnitLevel("target")
		if boss and (settings.ArmorCalc == "Auto") or (settings.ArmorCalc == "Boss") then
			--Wotlk bosses have 10643 (used to be 13083) armor
			armor = 10643
			armorLevel = 83
		elseif settings.ArmorCalc == "Auto" then
			local GUID = not UnitIsPlayer("target") and UnitGUID("target")
			local targetID = GUID and tonumber(string_sub(GUID,9,12),16)
			armor = targetID and mobArmor[targetID] or settings.Armor
		elseif settings.ArmorCalc == "Manual" then
			armor = settings.Armor
		end	
		if armor and armor > 0 then
			if armorLevel == 0 then
				armorLevel = playerLevel
			elseif armorLevel == -1 then
				armorLevel = playerLevel + 10
			end			
			calculation.armorPen = math_min(1, calculation.armorPen)
			--Apply armor debuffs (eg. Sunder Armor)
			armor = armor * (1 - calculation.armorM) -- + calculation.armorMod
			local cap = armor
			if armorLevel >= 80 then
				--Calculate the armor constant (For a level 80 target, C=15232.5. For a level 83, C=16635.)
				local C = (playerLevel < 60) and (400 + 85 * armorLevel) or (400 + 85 * armorLevel + 4.5 * 85 * (armorLevel-59) - 380 * math_max(0,armorLevel - 80))
				--Calculate the armor penetration cap (Cap for level 83 target, (armor + 16635)/3)
				cap = math_min(armor,(armor + C)/3)
			end
			calculation.armorIgnore = calculation.armorM + (cap / armor) * calculation.armorPen
			calculation.armor = armor
			calculation.cap = cap
		end
	end
	
	--CORE: Save damage modifier for tooltip display before mitigation modifiers
	calculation.dmgM_Display = calculation.dmgM * calculation.dmgM_dd * (1 + calculation.dmgM_Add + calculation.dmgM_dd_Add) * (baseSpell.Bleed and calculation.bleedBonus or 1)

	--CORE: RESILIENCE
	if settings.Resilience > 0 then
		calculation.critPerc = calculation.critPerc - settings.Resilience / self:GetRating("Resilience")
		calculation.critM = calculation.critM * math_max(2/3 - 1/(3 * calculation.critM), 1 - 0.044 * (settings.Resilience / self:GetRating("Resilience")))
		calculation.dmgM = calculation.dmgM * math_max(0, 1 - 0.02 * settings.Resilience / self:GetRating("Resilience"))
		if calculation.E_dmgM then
			calculation.E_dmgM = calculation.E_dmgM * math_max(0, 1 - 0.02 * settings.Resilience / self:GetRating("Resilience"))
		end
		if calculation.extraWeaponDamage_dmgM then
			calculation.extraWeaponDamage_dmgM = calculation.extraWeaponDamage_dmgM * math_max(0, 1 - 0.02 * settings.Resilience / self:GetRating("Resilience"))
		end	
	end

	--CORE: SUM UP
	calculation.dmgM_Extra = calculation.dmgM_Extra * calculation.dmgM * (1 + calculation.dmgM_Add + calculation.dmgM_Extra_Add) * (not calculation.extraCrit and (baseSpell.BleedExtra and calculation.bleedBonus or 1) or 1)
	calculation.dmgM = calculation.dmgM * calculation.dmgM_dd * (1 + calculation.dmgM_Add + calculation.dmgM_dd_Add) * (baseSpell.Bleed and calculation.bleedBonus or 1)

	--AND NOW CALCULATE
	local avgTotal = DrD_DmgCalc( baseSpell, spell, false, false, tooltip )

	if tooltip and not calculation.zero and not baseSpell.NoNext then
		if settings.Next or settings.CompareStats or settings.CompareSP or settings.CompareAP or settings.CompareCrit or settings.CompareHit or settings.CompareExp or settings.CompareArp then
			CalculationResults.Stats = true
			if calculation.APBonus or calculation.WeaponDamage then
				calculation.AP = calculation.AP + 10
				CalculationResults.NextAP = DrD_Round( DrD_DmgCalc( baseSpell, spell, true ) - avgTotal, 2 )
				calculation.AP = calculation.AP - 10
			end
			if calculation.SPBonus then
				calculation.spellDmg = calculation.spellDmg + 10
				CalculationResults.NextSP = DrD_Round( DrD_DmgCalc( baseSpell, spell, true ) - avgTotal, 2 )
				calculation.spellDmg = calculation.spellDmg - 10
			end
			if calculation.mitigation < 1 then
				calculation.armorPen = calculation.armorPen + 0.01
				CalculationResults.NextARP = DrD_Round( DrD_DmgCalc( baseSpell, spell, true ) - avgTotal, 2 )
				calculation.armorPen = calculation.armorPen - 0.01
			end
			if not baseSpell.Unresistable then
				if calculation.dodge or calculation.parry then
					calculation.expertise = calculation.expertise + 1
					CalculationResults.NextExp = DrD_Round( DrD_DmgCalc( baseSpell, spell, true ) - avgTotal, 2 )
					calculation.expertise = calculation.expertise - 1
				end
				local temp = settings.HitCalc and avgTotal or DrD_DmgCalc( baseSpell, spell, true, true )
				local hitPerc = calculation.hitPerc
				calculation.hitPerc = calculation.hitPerc + 1
				CalculationResults.NextHit = DrD_Round( DrD_DmgCalc( baseSpell, spell, true, true ) - temp, 2 )
				calculation.hitPerc = hitPerc
			end
			if not calculation.NoCrits then
				calculation.critPerc = calculation.critPerc + 1
				if calculation.E_critPerc then calculation.E_critPerc = calculation.E_critPerc + 1 end
				if calculation.E_critPerc_O then calculation.E_critPerc_O = calculation.E_critPerc_O + 1 end
				if calculation.extra_critPerc then calculation.extra_critPerc = calculation.extra_critPerc + 1 end
				CalculationResults.NextCrit = DrD_Round( DrD_DmgCalc( baseSpell, spell, true ) - avgTotal, 2 )
			end			
		end
	end

	DrD_ClearTable( Talents )
	DrD_ClearTable( ActiveAuras )
	DrD_ClearTable( AuraTable )

	return settings.DisplayType_M and CalculationResults[settings.DisplayType_M], settings.DisplayType_M2 and CalculationResults[settings.DisplayType_M2], CalculationResults, debug and calculation
end

DrD_DmgCalc = function( baseSpell, spell, nextCalc, hitCalc, tooltip )
	local APmod, APoh = 0

	--if DrDamage.DmgCalculation[calculation.spellName] then
	--	APmod = DrDamage.DmgCalculation[calculation.spellName]( calculation, ActiveAuras, Talents, spell, baseSpell ) or 0
	--end

	--Calculation
	local minDam, maxDam = calculation.minDam * calculation.bDmgM, calculation.maxDam * calculation.bDmgM
	local minDam_O, maxDam_O
	local minCrit, maxCrit
	local minCrit_O, maxCrit_O
	local avgHit, avgHit_O
	local avgCrit,avgCrit_O
	local avgTotal, avgTotalMod
	local avgTotal_O = 0
	local eDuration = calculation.eDuration
	local baseDuration = spell.eDuration or baseSpell.eDuration
	local hits = calculation.Hits
	local perHit, ticks
	local baseAttack
	local hitPenaltyAvg, aoe, aoeO

	--CORE: Sum up hit chance
	local hit, hitO = calculation.hit + calculation.hitPerc, (calculation.hitO or calculation.hit) + calculation.hitPerc
	local hitPerc = hit
	local hitPerc_O = hitO
	local hitDW = baseSpell.AutoAttack and calculation.offHand and (hit - 19)
	local hitDWO = hitDW and (hitO - 19)

	--CORE: Minimum hit: 0%, Maximum hit: 100%
	if hitPerc > 100 then hitPerc = 100 elseif hitPerc < 0 then hitPerc = 0 end
	if hitPerc_O > 100 then hitPerc_O = 100 elseif hitPerc_O < 0 then hitPerc_O = 0 end
	if hitDW then
		if hitDW > 100 then hitDW = 100 elseif hitDW < 0 then hitDW = 0 end
		if hitDWO > 100 then hitDWO = 100 elseif hitDWO < 0 then hitDWO = 0 end
	end

	--CORE: Critical hit chance & Calculate crit cap (104.8% - miss - glancing - dodge rate - parry rate)
	local critCap = 100 + (calculation.critDepression or 0) - (100 - (hitDW or hitPerc)) - (calculation.glancing or 0)
	local critPerc = calculation.critPerc
	local dodge, parry
	if calculation.dodge then
		dodge = calculation.dodge - calculation.expertise * 0.25
		if dodge < 0 then dodge = 0 end
		critCap = critCap - dodge
	end
	if calculation.parry and settings.Parry then
		parry = calculation.parry - calculation.expertise * 0.25
		if parry < 0 then parry = 0 end
		critCap = critCap - parry
	end
	if critCap < 0 then critCap = 0 end
	if critPerc > critCap then
		critPerc = critCap
		if baseSpell.AutoAttack then calculation.critCapNote = true end 
	end
	if settings.CritDepression and calculation.critDepression then
		critPerc = critPerc - calculation.critDepression
	end
	if critPerc > 100 then
		critPerc = 100
	elseif critPerc < 0 then
		critPerc = 0
	end
	--CORE: Calculate mitigation
	if calculation.armor then
		local armor = math_max(0, calculation.armor - calculation.cap * calculation.armorPen)
		--Calculate mitigation based on player level
		if calculation.playerLevel < 60 then
			calculation.mitigation = 1 - math_min(0.75, armor / (armor + 400 + 85 * calculation.playerLevel))
		else
			calculation.mitigation = 1 - math_min(0.75, armor / (armor + (467.5 * calculation.playerLevel - 22167.5)))
		end
	end

	--CORE: Weapon Damage multiplier
	if calculation.WeaponDamage then
		local min, max
		min, max, minDam_O, maxDam_O, APmod, APoh = DrDamage:WeaponDamage(calculation, baseSpell.NoNormalization)
		minDam = minDam + min * calculation.WeaponDamage
		maxDam = maxDam + max * calculation.WeaponDamage
		--CORE: Off-hand attacks
		if calculation.offHand then
			--if calculation.ExtraMain then
			--	local min, max = DrDamage:WeaponDamage(calculation, baseSpell.NoNormalization)
			--	minDam_O = calculation.offHdmgM * (min * calculation.WeaponDamage + calculation.minDam * calculation.bDmgM)
			--	maxDam_O = calculation.offHdmgM * (max * calculation.WeaponDamage + calculation.maxDam * calculation.bDmgM)
			--elseif baseSpell.AutoAttack or calculation.DualAttack then
			if baseSpell.AutoAttack or calculation.DualAttack then
				minDam_O = minDam_O * calculation.WeaponDamage + calculation.minDam * calculation.bDmgM * calculation.bDmgM_O * (calculation.DualAttack or 1)
				maxDam_O = maxDam_O * calculation.WeaponDamage + calculation.maxDam * calculation.bDmgM * calculation.bDmgM_O * (calculation.DualAttack or 1)
				APmod = APmod + (APoh or 0)
			elseif baseSpell.OffhandAttack then
				minDam = minDam_O * calculation.WeaponDamage + calculation.minDam * calculation.bDmgM
				maxDam = maxDam_O * calculation.WeaponDamage + calculation.maxDam * calculation.bDmgM
				minDam_O = nil
				maxDam_O = nil
				APmod = (APoh or 0)
			end
		end
	end
	--CORE: Combo point calculation
	if baseSpell.ComboPoints then
		local cp = calculation.Melee_ComboPoints

		if cp > 0 then
			if spell.PerCombo then
				minDam = minDam + spell.PerCombo * ( cp - 1 )
				maxDam = maxDam + spell.PerCombo * ( cp - 1 )
			end
			if baseSpell.ExtraPerCombo then
				minDam = minDam + spell.ExtraPerCombo * baseSpell.ExtraPerCombo[cp]
				maxDam = maxDam + spell.ExtraPerCombo * baseSpell.ExtraPerCombo[cp]
			end
			if calculation.APBonus then
				if type( calculation.APBonus ) == "table" then
					minDam = minDam + calculation.APBonus[cp] * calculation.AP
					--if baseSpell.APBonusMax then
					--	maxDam = maxDam + baseSpell.APBonusMax[cp] * calculation.AP
					--	APmod = APmod + (calculation.APBonus[cp] + baseSpell.APBonusMax[cp])/2
					--else
						maxDam = maxDam + calculation.APBonus[cp] * calculation.AP
						APmod = APmod + calculation.APBonus[cp]
					--end
				else
					minDam = minDam + calculation.APBonus * cp * calculation.AP
					maxDam = maxDam + calculation.APBonus * cp * calculation.AP
					APmod = APmod + calculation.APBonus * cp
				end
			end
			if baseSpell.DurationPerCombo then
				eDuration = calculation.eDuration + baseSpell.DurationPerCombo * cp
				baseDuration = baseDuration + baseSpell.DurationPerCombo * cp
			end
		else
			calculation.zero = true
		end
	else
	--CORE: AP and SP modifier for non-combo point abilities
		if calculation.APBonus then
			minDam = minDam + calculation.APBonus * calculation.AP
			maxDam = maxDam + calculation.APBonus * calculation.AP
			APmod = APmod + calculation.APBonus
		end
		if calculation.SPBonus then
			minDam = minDam + calculation.SPBonus * calculation.spellDmg
			maxDam = maxDam + calculation.SPBonus * calculation.spellDmg
		end
	end
	--CORE: Powerbonus abilities, ferocious bite and enrage
	if spell.PowerBonus and calculation.powerType == UnitPowerType("player") then
		local bonus = math_min(calculation.maxCost, math_max(0,UnitPower("player",calculation.powerType) - calculation.baseCost))
		local value = (bonus + (calculation.extraPowerBonus or 0)) * (spell.PowerBonus + (baseSpell.PowerBonusAP or 0) * calculation.AP)
		minDam = minDam + value
		maxDam = maxDam + value
		if not nextCalc then
			calculation.actionCost = calculation.actionCost + bonus
		end
	end

	--CORE: Calculate final min-max range
	local modDuration = baseDuration and eDuration > baseDuration and (1 + (eDuration - baseDuration) / baseDuration) or 1
	minDam = calculation.dmgM * calculation.mitigation * (minDam * modDuration + calculation.dmgBonus) + (baseDuration and 0 or calculation.finalMod * calculation.mitigation)
	maxDam = calculation.dmgM * calculation.mitigation * (maxDam * modDuration + calculation.dmgBonus) + (baseDuration and 0 or calculation.finalMod * calculation.mitigation)

	--CORE: Show zero for not available abilities
	if calculation.zero then
		minDam = 0
		maxDam = 0
	end

	--CORE: Sum min and max to averages
	avgHit = ((minDam + maxDam) / 2)

	--CORE: Crit calculation
	local critBonus = 0
	local critBonus_O = 0
	if not calculation.NoCrits then
		minCrit = minDam + minDam * calculation.critM
		maxCrit = maxDam + maxDam * calculation.critM
		avgCrit = (minCrit + maxCrit) / 2
		critBonus = (critPerc / 100) * avgHit * calculation.critM
		avgTotal = avgHit + critBonus
	else
		avgCrit = avgHit
		avgTotal = avgHit
	end

	--CORE: Crit calculation for off-hand and dual attack
	if (calculation.DualAttack or baseSpell.AutoAttack) and calculation.offHand then
		minDam_O = calculation.dmgM * calculation.mitigation * (minDam_O + calculation.dmgBonus * calculation.bDmgM_O) + calculation.finalMod * calculation.bDmgM_O
		maxDam_O = calculation.dmgM * calculation.mitigation * (maxDam_O + calculation.dmgBonus * calculation.bDmgM_O) + calculation.finalMod * calculation.bDmgM_O
		avgHit_O = (minDam_O + maxDam_O)/2
		if not calculation.NoCrits then
			minCrit_O = minDam_O + minDam_O * calculation.critM
			maxCrit_O = maxDam_O + maxDam_O * calculation.critM
			avgCrit_O = (minCrit_O + maxCrit_O) / 2
			critBonus_O = (critPerc / 100) * avgHit_O * calculation.critM * (calculation.OffhandChance or 1)
			avgTotal_O = avgHit_O * (calculation.OffhandChance or 1) + critBonus_O
		else
			avgTotal_O = avgHit_O * (calculation.OffhandChance or 1)
		end
	end

	local extraDam, extraAvg, extraMin, extraMax
	local perTarget, targets
	if not calculation.zero then
		--CORE: Extra damage effect calculation
		if calculation.extraDamage then
			local extra = 0
			local extra_O = 0
			local extraDam_O = 0
			local extraAvgTotal = 0
			local extraAvgTotal_O = 0
			local critBonus_Extra = 0
			local critBonus_Extra_O = 0
			extraMin = 0
			extraMax = 0
			--Extra effect chance is based on crit chance
			if calculation.extraChanceCrit then
				calculation.extraChance = critPerc / 100
			end
			--if calculation.extraAvgChanceCrit then
			--	calculation.extraAvgChance = critPerc / 100
			--end
			if calculation.extraWeaponDamageChanceCrit then
				calculation.extraWeaponDamageChance = critPerc / 100
			end
			--Extra effect is derived from crit value (eg. Righteous Vengeance)
			if calculation.extraCrit then
				local value = calculation.extraCrit * (baseSpell.BleedExtra and calculation.bleedBonus or 1)
				extra = avgCrit * value
				extraMin = minCrit * value
				extraMax = maxCrit * value
				extraAvgTotal = extra * (calculation.extraCritChance or calculation.extraChance)
			end
			--Extra effect is derived from avg value
			--Main-hand (eg. Necrosis)
			if calculation.extraAvg then
				local value = calculation.extraAvg * calculation.dmgM_Extra / (calculation.dmgM * (calculation.extraAvgM and 1 or calculation.mitigation))
				extra = extra + avgTotal * value
				extraMin = extraMin + minDam * value
				extraMax = extraMax + (maxCrit or maxDam) * value
				extraAvgTotal = extraAvgTotal + avgTotal * value * (calculation.extraAvgChance or calculation.extraChance)
			end
			--Off-hand (eg. Necrosis)
			if calculation.extraAvg_O then
				local value = calculation.extraAvg_O * calculation.dmgM_Extra / (calculation.dmgM * (calculation.extraAvgM and 1 or calculation.mitigation))
				extra_O  = avgTotal_O * value
				extraMin = extraMin + minDam_O * value
				extraMax = extraMax + (maxCrit_O or maxDam_O) * value
				extraAvgTotal_O = extra_O * (calculation.extraAvgChance or calculation.extraChance)
			end
			--Extra effect is a multiplier of weapon damage
			--Main-hand (eg. Blood-Caked Blade, Deep Wounds)
			if calculation.extraWeaponDamage then
				local min, max  = DrDamage:WeaponDamage(calculation, not calculation.extraWeaponDamageNorm)
				local value = calculation.extraWeaponDamage * (calculation.extraWeaponDamage_dmgM or calculation.dmgM_Extra) * (calculation.extraWeaponDamageM and calculation.mitigation or 1)
				local bonus =  0.5 * (min + max) * value
				extra = extra + bonus
				extraMin = extraMin + min * value
				extraMax = extraMax + max * value
				extraAvgTotal = extraAvgTotal + bonus * (calculation.extraWeaponDamageChance or calculation.extraChance)
			end
			--Off-hand (eg. Blood-Caked Blade, Deep Wounds)
			if calculation.extraWeaponDamage_O then
				local _, _, min, max  = DrDamage:WeaponDamage(calculation, not calculation.extraWeaponDamageNorm)
				local value = calculation.extraWeaponDamage_O * (calculation.extraWeaponDamage_dmgM or calculation.dmgM_Extra) * (calculation.extraWeaponDamageM and calculation.mitigation or 1)
				local bonus =  0.5 * (min + max) 
				extra_O = extra_O + bonus
				extraMin = extraMin + min * value
				extraMax = extraMax + max * value
				extraAvgTotal_O = extraAvgTotal_O + bonus * (calculation.extraWeaponDamageChance or calculation.extraChance)
			end
			--Module effect can crit
			if calculation.extra_canCrit then
				if calculation.extra_critPerc then
					if calculation.extra_critPerc > 100 then calculation.extra_critPerc = 100
					elseif calculation.extra_critPerc < 0 then calculation.extra_critPerc = 0 end
				end
				critBonus_Extra = extra * ((calculation.extra_critPerc or critPerc) / 100) * (calculation.extra_critM or calculation.critM)
				critBonus_Extra_O = extra_O * ((calculation.extra_critPerc or critPerc) /100) * (calculation.extra_critM or calculation.critM)
				extraMax = extraMax * (1 + (calculation.extra_critM or calculation.critM))
			end
			--Main-hand extra damage effect from modules
			extraDam = (calculation.extra + calculation.extraDamage * calculation.AP + (calculation.extraDamageSP or 0) * (calculation.spellDmg + (calculation.E_spellDmg or 0))) * (calculation.E_dmgM or calculation.dmgM_Extra) * (calculation.extraM and calculation.mitigation or 1) + calculation.extraDamBonus
			--Off-hand extra damage effect from modules (Poisons, Flametongue, Frostbrand)
			extraDam_O = (calculation.extra_O + calculation.extraDamage_O * calculation.AP + (calculation.extraDamageSP_O or 0) * (calculation.spellDmg + (calculation.E_spellDmg_O or 0))) * (calculation.E_dmgM or calculation.dmgM_Extra) * (calculation.extraM and calculation.mitigation or 1) + calculation.extraDamBonus_O
			--Extended duration for extra damage effect
			if calculation.E_eDuration and baseSpell.E_eDuration and calculation.E_eDuration > baseSpell.E_eDuration then
				local modDuration = 1 + (calculation.E_eDuration - baseSpell.E_eDuration) / baseSpell.E_eDuration
				extraDam = extraDam * modDuration
			end
			--Extra effect can crit
			if calculation.E_canCrit then
				if calculation.E_critPerc then
					if calculation.E_critPerc > 100 then calculation.E_critPerc = 100
					elseif calculation.E_critPerc < 0 then calculation.E_critPerc = 0 end
				end
				if calculation.E_critPerc_O then
					if calculation.E_critPerc_O > 100 then calculation.E_critPerc_O = 100
					elseif calculation.E_critPerc_O < 0 then calculation.E_critPerc_O = 0 end
				end			
				critBonus_Extra = critBonus_Extra + extraDam * ((calculation.E_critPerc or critPerc) / 100) * (calculation.E_critM or calculation.critM) * calculation.extraChance
				critBonus_Extra_O = critBonus_Extra_O + extraDam_O * ((calculation.E_critPerc_O or critPerc) / 100) * (calculation.E_critM or calculation.critM) * calculation.extraChance_O
				extraMax = extraMax + (extraDam + extraDam_O) * (1 + (calculation.E_critM or calculation.critM))
			else
				extraMax = extraMax + extraDam + extraDam_O
			end
			--Adds extra effect to minimum damage
			extraMin = extraMin + extraDam + extraDam_O			
			--Sums up main-hand average for DPS calculation
			avgTotal = avgTotal + extraDam * calculation.extraChance + extraAvgTotal + critBonus_Extra
			--Sums up off-hand average for DPS calculation
			avgTotal_O = avgTotal_O + extraDam_O * calculation.extraChance_O + extraAvgTotal_O + critBonus_Extra_O
			--Sums the average extra effect
			extraAvg = extraDam * calculation.extraChance + extraDam_O * calculation.extraChance_O + critBonus_Extra + critBonus_Extra_O + extraAvgTotal + extraAvgTotal_O
			--The amount of damage done on combined successful procs, non-crit
			extraDam = extraDam + extraDam_O + extra + extra_O
			--AP bonus from extra module
			APmod = APmod + calculation.extraDamage + calculation.extraDamage_O
		end	
		--CORE: Per hit/tick calculation
		if hits then
			perHit = avgTotal + avgTotal_O
		elseif baseSpell.eDuration and baseSpell.Ticks then
			ticks = eDuration / baseSpell.Ticks
			perHit = avgHit / ticks
		elseif extraDam and baseSpell.E_eDuration and baseSpell.E_Ticks then
			ticks = calculation.E_eDuration / baseSpell.E_Ticks
			perHit = extraDam / ticks
		elseif extraDam and calculation.extraTicks then
			ticks = calculation.extraTicks
			perHit = extraDam / ticks
		end

		--CORE: Attacks that replace next melee, eg. Cleave, Heroic Strike, Raptor Strike
		if baseSpell.NextMelee then
			local min, max = DrDamage:WeaponDamage(calculation, true)
			baseAttack = calculation.dmgM * calculation.mitigation * 0.5 * (min + max)
			avgTotalMod = avgTotal - critBonus - baseAttack
			critBonus = avgTotalMod * (critPerc / 100) * calculation.critM + baseAttack * (math_max(0,critPerc - GetCritChance()) / 100) * calculation.critM
			avgTotalMod = avgTotalMod + critBonus
		end

		--CORE: Hit calculation
		if not baseSpell.Unresistable then
			local hit, hitO = 100, 100
			local avoidance, avoidanceO = 0, 0
			local calc
			if settings.HitCalc or hitCalc then
				hit = hitDW or hitPerc
				hitO = hitDWO or hitPerc_O
				calc = true
			end
			if settings.Parry and parry then
				avoidance = parry
				avoidanceO = parry
				calc = true
			end
			if settings.Dodge and dodge then
				avoidance = avoidance + dodge
				avoidanceO = avoidanceO + dodge
				calc = true
			end
			if settings.Glancing and calculation.glancing then
				avoidance = avoidance + calculation.glancing * calculation.glancingM
				avoidanceO = avoidanceO + calculation.glancing * calculation.glancingM
				calc = true
			end
			if calc then
				local tworoll = settings.TwoRoll_M and not baseSpell.AutoAttack and not baseSpell.AutoShot or baseSpell.SpellHit and settings.TwoRoll
				avoidance = avoidance / 100
				avoidanceO = avoidanceO / 100

				avgTotal = math_max(0, avgTotal - (avgTotal - critBonus) * avoidance - (avgTotal - (tworoll and 0 or critBonus)) * (1 - 0.01 * hit))
				hitPenaltyAvg = avgHit * avoidance + (avgHit + (tworoll and critBonus or 0)) * (1 - 0.01 * hit)
				if avgTotalMod then
					--Hit penalty and bonus for converting a white attack to special attack (possible +hit increase when dual wielding)
					local bonus = calculation.offHand and (hitPerc - math_min(100,math_max(0,calculation.hit + calculation.hitPerc - 19))) / 100 or 0
					avgTotalMod = avgTotalMod - (avgTotalMod - critBonus) * avoidance - (avgTotalMod - (tworoll and 0 or critBonus)) * (1 - 0.01 * hit) + baseAttack * bonus
				end
				if avgTotal_O > 0 then
					avgTotal_O = math_max(0, avgTotal_O - (avgTotal_O - critBonus_O) * avoidanceO - (avgTotal_O - (tworoll and 0 or critBonus_O)) * (1 - 0.01 * hitO))
				end
			end
		end

		--CORE: Multiple hit calculation
		if hits then
			avgTotal = avgTotal + (hits - 1) * avgTotal
			if calculation.DualAttack then
				avgTotal_O = avgTotal_O + (hits - 1) * avgTotal_O
			end
			--Not needed currently
			--if avgTotalMod then
			--	avgTotalMod = avgTotalMod + (hits - 1) * avgTotal
			--end
		end
		if calculation.aoe and calculation.targets > 1 then
			local aoeM = calculation.aoeM or 1
			targets = (type(calculation.aoe) == "number") and math_min(calculation.targets, calculation.aoe) or calculation.targets
			perTarget = (avgTotal + avgTotal_O) * aoeM
			aoe = (targets - 1) * avgTotal * aoeM
			aoeO = (targets - 1) * avgTotal_O * aoeM
			avgTotal = avgTotal + aoe
			avgTotal_O = avgTotal_O + aoeO 
			if avgTotalMod then
				avgTotalMod = avgTotalMod + (targets - 1) * avgTotal
			end
			if aoeM < 1 then
				targets = targets - 1
			end
			--TODO: Do we want this?
			--if baseSpell.E_AoE and ticks then
			--	ticks = ticks * targets
			--end
		end

		--CORE: Windfury calculation
		if calculation.WindfuryBonus then
			local min, max = DrDamage:WeaponDamage(calculation, true)
			local bspd = DrDamage:GetWeaponSpeed()
			local value = calculation.dmgM * calculation.mitigation * (calculation.WindfuryDmgM or 1) * 2
			local bonus = bspd * calculation.WindfuryBonus / 14
			local avgWf = (0.5 * (min+max) + bonus) * value
			local avgTotalWf =  avgWf * (1 + calculation.critM * critPerc / 100) * (hitPerc / 100) * calculation.WindfuryChance * ((hitDW or hitPerc) / 100)
			extraDam = (extraDam or 0) + avgWf
			extraAvg = (extraAvg or 0) + avgTotalWf
			extraMin = (extraMin or 0) + (min + bonus) * value
			extraMax = (extraMax or 0) + (max + bonus) * value * (1 + calculation.critM)
			avgTotal = avgTotal + avgTotalWf
		end
		if calculation.WindfuryBonus_O then
			local _, _, min, max = DrDamage:WeaponDamage(calculation, true)
			local _, bspd = DrDamage:GetWeaponSpeed()
			local value = calculation.dmgM * calculation.mitigation * (calculation.WindfuryDmgM or 1) * 2
			local bonus = bspd * calculation.WindfuryBonus_O / 14
			local avgWf_O = (0.5 * (min+max) + bonus) * value
			local avgTotalWf_O = avgWf_O * (1 + calculation.critM * critPerc / 100) * (hitPerc_O / 100) * calculation.WindfuryChance * ((hitDWO or hitPerc_O) / 100)
			extraDam = (extraDam or 0) + avgWf_O
			extraAvg = (extraAvg or 0) + avgTotalWf_O
			extraMin = (extraMin or 0) + (min + bonus) * value
			extraMax = (extraMax or 0) + (max + bonus) * (1 + calculation.critM)
			avgTotal_O = avgTotal_O + avgTotalWf_O
		end
	else
		avgTotal = 0
		avgTotal_O = 0
	end

	local avgCombined = (avgTotalMod or avgTotal) + avgTotal_O

	if nextCalc then
		return avgCombined
	else
		--CORE: DPS calculation
		local DPS, DPSCD
		if calculation.customDPS then
			DPS = calculation.customDPS
		elseif baseSpell.AutoAttack or baseSpell.WeaponDPS then
			if hits then DPS = (avgTotal / hits) / calculation.spd
			else DPS = avgTotal / calculation.spd end

			if calculation.ospd then
				DPS = DPS + avgTotal_O / calculation.ospd
			end
		elseif baseSpell.DPSrg then
			DPS = avgTotal / calculation.rspd
		else
			if eDuration > 0 then
				if calculation.customHaste then
					eDuration = eDuration / math_max(1,calculation.haste)
				end
				DPS = avgCombined / eDuration
			elseif extraDam and calculation.E_eDuration then
				if calculation.WeaponDPS then
					DPS = (avgCombined - extraAvg) / calculation.spd + extraAvg / calculation.E_eDuration
				else
					DPS = avgCombined / calculation.E_eDuration
				end
			end
			if calculation.cooldown > 0 then
				if baseSpell.NextMelee then
					DPSCD = DrD_Round(avgCombined / (calculation.cooldown + calculation.spd * select(2,math_modf(calculation.cooldown / calculation.spd))), 1)
				else
					DPSCD = DrD_Round(avgCombined / calculation.cooldown,1)
				end
			end
			--if calculation.castTime then
			--	DPS = avgCombined / calculation.castTime
			--end
		end
		local extraDPS
		if calculation.extra_DPS and DPS then
			extraDPS = (calculation.E_dmgM or calculation.dmgM) * (calculation.extraStacks_DPS or 1) * (calculation.extra_DPS + calculation.extraDamage_DPS * calculation.AP) / calculation.extraDuration_DPS
			DPS = DPS + extraDPS
		end
		--if calculation.procPerc then
		--	DPS = DPS * calculation.procPerc
		--end

		DrD_ClearTable( CalculationResults )

		CalculationResults.Avg =			math_floor(math_max(0, avgHit - (hitPenaltyAvg or 0) + critBonus + 0.5))
		CalculationResults.AvgHit = 		math_floor(avgHit + 0.5)
		CalculationResults.AvgHitTotal = 	math_floor(avgHit + (extraDam or 0) + 0.5)
		CalculationResults.AvgTotal = 		math_floor(avgTotal + avgTotal_O + 0.5)
		CalculationResults.MinHit = 		math_floor(minDam)
		CalculationResults.MaxHit = 		math_ceil(maxDam)
		CalculationResults.MaxTotal = 		math_ceil((maxCrit or maxDam) + (maxCrit_O or maxDam_O or 0) + (extraMax or 0) + (aoe or 0) + (aoeO or 0))
		CalculationResults.AvgCrit = 		math_floor(avgCrit + 0.5)

		if not calculation.NoCrits then
			CalculationResults.MinCrit = 	math_floor(minCrit)
			CalculationResults.MaxCrit = 	math_ceil(maxCrit)
		else
			CalculationResults.MinCrit = 	CalculationResults.Min
			CalculationResults.MaxCrit = 	CalculationResults.Max
		end
		if DPS then
			CalculationResults.DPS = DrD_Round(DPS,1)
			if eDuration > 0 then
				CalculationResults.DPS_Duration = DrD_Round(eDuration, 2)
			elseif calculation.E_eDuration then
				CalculationResults.DPS_Duration = DrD_Round(calculation.E_eDuration, 2)
			end
		end			
		if DPSCD then
			CalculationResults.DPSCD = DPSCD
		end

		if tooltip or settings.DisplayType_M == "DPM" or settings.DisplayType_M2 == "DPM" or settings.DisplayType_M2 == "PowerCost" then
			if powerTypes[calculation.powerType] and calculation.actionCost > 0 then
				CalculationResults.PowerType = powerTypes[calculation.powerType]
				if baseAttack and calculation.powerType == 1 then
					calculation.actionCost = calculation.actionCost + DrDamage:GetRageGain(baseAttack, calculation) * calculation.rageBonus
				end
				if calculation.freeCrit > 0 then
					calculation.actionCost = calculation.actionCost - calculation.actionCost * calculation.freeCrit * (critPerc / 100) * (hitPerc / 100)
				end
				--TODO: Do we want this cost or what the tooltip displays?
				if calculation.baseCost ~= calculation.actionCost then
					CalculationResults.PowerCost = math_floor(calculation.actionCost + 0.5)
				end
				CalculationResults.DPM = DrD_Round(avgCombined / calculation.actionCost, 1)
			end
			if not CalculationResults.DPM then
				CalculationResults.DPM = "\226\136\158"
			end
		end
		if tooltip then
			CalculationResults.Hit = 	DrD_Round(hitDW or hitPerc, 2)
			CalculationResults.AP = 	math_floor(calculation.AP + 0.5)
			CalculationResults.Ranged =	calculation.ranged
			CalculationResults.DmgM = 	DrD_Round(calculation.dmgM_Display, 3)
			CalculationResults.APM = 	DrD_Round(APmod, 3)

			if settings.Parry and parry then
				CalculationResults.Parry = parry
			end
			if settings.Dodge and dodge then
				CalculationResults.Dodge = dodge
			end
			if settings.Glancing and calculation.glancing then
				CalculationResults.Glancing = calculation.glancing
			end
			if calculation.mitigation < 1 then
				CalculationResults.Mitigation = DrD_Round((1 - calculation.mitigation) * 100, 2)
				CalculationResults.ArmorPen = DrD_Round(calculation.armorIgnore * 100, 2)
			end
			if not calculation.NoCrits or calculation.E_canCrit then
				CalculationResults.CritM =	DrD_Round( 100 + calculation.critM * 100, 2)
				CalculationResults.Crit = 	DrD_Round(critPerc, 2)
			end
			if avgHit_O then
				CalculationResults.AvgTotalM =	math_floor(avgTotal + 0.5)
				CalculationResults.AvgHitO = 	math_floor(avgHit_O + 0.5)
				CalculationResults.MinHitO = 	math_floor(minDam_O)
				CalculationResults.MaxHitO = 	math_ceil(maxDam_O)
				CalculationResults.HitO =		DrD_Round(hitDWO or hitPerc_O, 2)
				CalculationResults.AvgTotalO =  math_floor(avgTotal_O + 0.5)
				if not calculation.NoCrits then
					CalculationResults.MinCritO = 	math_floor(minCrit_O)
					CalculationResults.MaxCritO = 	math_ceil(maxCrit_O)
					CalculationResults.AvgCritO = 	math_floor(avgCrit_O + 0.5)
				end
			end
			if extraDam then
				CalculationResults.Extra = 		math_floor(extraAvg + 0.5)
				CalculationResults.ExtraMin =	math_floor(extraMin)
				CalculationResults.ExtraMax = 	math_ceil(extraMax)
				CalculationResults.ExtraName =	calculation.extraName
			end
			if extraDPS then
				CalculationResults.ExtraDPS = DrD_Round( extraDPS, 1)
				CalculationResults.ExtraNameDPS = calculation.extraName_DPS
			end
			if calculation.SPBonus and calculation.spellDmg > 0 then
				CalculationResults.SpellDmg = math_floor( calculation.spellDmg + 0.5 )
				CalculationResults.SpellDmgM = DrD_Round( calculation.SPBonus + (calculation.extraDamageSP or 0), 3 )
			end
			if perHit then
				if ticks and (not calculation.NoCrits and not baseSpell.E_eDuration and not calculation.extraTicks or baseSpell.E_eDuration and calculation.E_canCrit) then
					CalculationResults.PerCrit = math_floor( perHit * (1 + (not baseSpell.eDuration and calculation.E_critM or calculation.critM)) + 0.5 )
					CalculationResults.Crits = math_floor( ticks * (critPerc / 100) + 0.5 )
					ticks = ticks - CalculationResults.Crits
				end
				CalculationResults.Hits = 	ticks or hits
				CalculationResults.PerHit =	DrD_Round(perHit, 1)
			end
			if perTarget then
				CalculationResults.Targets = 	targets
				CalculationResults.PerTarget = 	math_floor(perTarget + 0.5)
			end
			--if calculation.procPerc then
			--	CalculationResults.ProcChance = DrD_Round(calculation.procPerc * 100,2)
			--end
			if calculation.tooltipName then
				CalculationResults.Name = calculation.tooltipName
			end
			if calculation.tooltipName2 then
				CalculationResults.Name2 = calculation.tooltipName2
			end
			if calculation.coeff then
				CalculationResults.Coeff = DrD_Round(calculation.coeff, 3)
				CalculationResults.CoeffV = math_floor(calculation.coeffv + 0.5)
			end
			if baseSpell.AutoAttack then
				CalculationResults.CritCap = DrD_Round(critCap, 2)
				if calculation.critCapNote then
					CalculationResults.CritCapNote = true
				end
			end
			--if calculation.hybridnote then
			--	CalculationResults.HybridNote = true
			--end
		end
		return avgCombined
	end
end


function DrDamage:MeleeTooltip( frame, name, rank )
	local value = select(3,self:MeleeCalc(name, rank, true))
	if not value then return end

	local baseSpell = spellInfo[name][0]
	if type(baseSpell) == "function" then baseSpell = baseSpell() end

	frame:AddLine(" ")

	local r, g, b = 1, 0.82745098, 0
	local rt, gt, bt = 1, 1, 1

	if CalculationResults.Name2 then
		frame:AddDoubleLine( CalculationResults.Name .. ":", CalculationResults.Name2, rt, gt, bt, r, g, b )
	elseif CalculationResults.Name then
		frame:AddLine( CalculationResults.Name, r, g, b )
		frame:AddLine(" ")
	end

	if not settings.DefaultColor then
		local c = settings.TooltipTextColor1
		rt, gt, bt = c.r, c.g, c.b
		c = settings.TooltipTextColor2
		r, g, b = c.r, c.g, c.b
	end

	if settings.Coeffs then
		if CalculationResults.Coeff then
			frame:AddDoubleLine(L["Coeffs"] .. ":", CalculationResults.Coeff .. "*" .. CalculationResults.CoeffV, rt, gt, bt, r, g, b  )
		else
			frame:AddDoubleLine(L["Coeffs"] .. ":", (CalculationResults.SpellDmg and (CalculationResults.SpellDmgM .. "*" .. CalculationResults.SpellDmg .. "/") or "") .. CalculationResults.APM .. "*" .. CalculationResults.AP, rt, gt, bt, r, g, b  )
		end
		frame:AddDoubleLine(L["Multiplier:"], (CalculationResults.DmgM * 100) .. "%", rt, gt, bt, r, g, b  )
		if CalculationResults.CritM then
			frame:AddDoubleLine(L["Crit Multiplier:"], CalculationResults.CritM .. "%", rt, gt, bt, r, g, b  )
		end
		if CalculationResults.Mitigation then
			local arp = CalculationResults.ArmorPen and CalculationResults.ArmorPen > 0
			frame:AddDoubleLine(arp and (L["Armor"] .. "/" .. L["ArP"] .. ":") or (L["Armor"] .. ":"), CalculationResults.Mitigation .. "%" .. (arp and ("/" .. CalculationResults.ArmorPen .. "%") or ""), rt, gt, bt, r, g, b )
		end
		--if CalculationResults.ProcChance then
		--	frame:AddDoubleLine(L["Proc Chance:"], CalculationResults.ProcChance .. "%", rt, gt, bt, r, g, b )
		--end		
		if CalculationResults.Dodge or CalculationResults.Parry or CalculationResults.Glancing then
			frame:AddDoubleLine((CalculationResults.Dodge and L["Dodge"] or "") .. (CalculationResults.Parry and (CalculationResults.Dodge and ("/" .. L["Parry"]) or L["Parry"]) or "") .. (CalculationResults.Glancing and ((CalculationResults.Dodge or CalculationResults.Parry) and ("/" .. L["Glancing"]) or L["Glancing"]) or "") .. ":", (CalculationResults.Dodge and (CalculationResults.Dodge .. "%") or "") .. (CalculationResults.Parry and (CalculationResults.Dodge and ("/" .. CalculationResults.Parry .. "%") or (CalculationResults.Parry .. "%")) or "") .. (CalculationResults.Glancing and ((CalculationResults.Dodge or CalculationResults.Parry) and ("/" .. CalculationResults.Glancing .. "%") or (CalculationResults.Glancing .. "%")) or ""), rt, gt, bt, r, g, b )
		end
	end

	if settings.DispCrit and CalculationResults.Crit then
		frame:AddDoubleLine(L["Crit:"], CalculationResults.Crit .. "%", rt, gt, bt, r, g, b )
		if CalculationResults.CritCap then
			frame:AddDoubleLine(L["Crit Cap:"], CalculationResults.CritCap .. "%", rt, gt, bt, r, g, b )
		end
	end

	if settings.DispHit and not baseSpell.Unresistable then
		frame:AddDoubleLine(L["Hit:"], CalculationResults.Hit .. "%", rt, gt, bt, r, g, b )
		if CalculationResults.HitO then
			frame:AddDoubleLine(L["Off-Hand"] .. " " .. L["Hit:"], CalculationResults.HitO .. "%", rt, gt, bt, r, g, b )
		end
	end

	if not settings.DefaultColor then
		local c = settings.TooltipTextColor3
		r, g, b = c.r, c.g, c.b
	end

	if settings.AvgHit or settings.AvgCrit then
		if CalculationResults.AvgHitO then
			frame:AddLine(L["Main Hand:"])
		end
	end
	if settings.AvgHit then
		frame:AddDoubleLine(L["Avg"] .. ":", CalculationResults.AvgHit .. " (".. CalculationResults.MinHit .."-".. CalculationResults.MaxHit ..")", rt, gt, bt, r, g, b )
	end
	if settings.AvgCrit and CalculationResults.AvgCrit > CalculationResults.AvgHit then
		frame:AddDoubleLine(L["Avg Crit:"], CalculationResults.AvgCrit .. " (".. CalculationResults.MinCrit .."-".. CalculationResults.MaxCrit ..")", rt, gt, bt, r, g, b )
	end

	if settings.Total and CalculationResults.AvgTotalM then
		frame:AddDoubleLine(L["Avg Total"] ..":", CalculationResults.AvgTotalM, rt, gt, bt, r, g, b)
	end

	if CalculationResults.AvgHitO and (settings.AvgHit or settings.AvgCrit) then
		frame:AddLine(L["Off-Hand"] .. ":")
		if settings.AvgHit then
			frame:AddDoubleLine(L["Avg"] .. ":", CalculationResults.AvgHitO .. " (".. CalculationResults.MinHitO .."-".. CalculationResults.MaxHitO ..")", rt, gt, bt, r, g, b )
		end
		if settings.AvgCrit and CalculationResults.AvgCritO then
			frame:AddDoubleLine(L["Avg Crit:"], CalculationResults.AvgCritO .. " (".. CalculationResults.MinCritO .."-".. CalculationResults.MaxCritO ..")", rt, gt, bt, r, g, b )
		end
		if settings.Total and CalculationResults.AvgTotalO then -- and CalculationResults.AvgTotalO > CalculationResults.AvgHitO then
			frame:AddDoubleLine(L["Avg Total"] .. ":", CalculationResults.AvgTotalO, rt, gt, bt, r, g, b  )
		end
	end
	if settings.Total and CalculationResults.AvgTotalO then
		frame:AddLine("---")
	end
	if settings.Extra and CalculationResults.Extra then
		frame:AddDoubleLine(L["Avg"] .. " " .. (CalculationResults.ExtraName or L["Additional"]) .. ":", CalculationResults.Extra .. " (" .. CalculationResults.ExtraMin .."-".. CalculationResults.ExtraMax .. ")", rt, gt, bt, r, g, b)
		--L["Max"] --This is to keep it in the localization app in case further need
	end
	if settings.Ticks then
		if CalculationResults.Hits and CalculationResults.PerHit and not baseSpell.NoHits then
			frame:AddDoubleLine(L["Dot"] .. " " .. L["Hits:"], CalculationResults.Hits .. "x ~" .. CalculationResults.PerHit, rt, gt, bt, r, g, b )
		end
		if CalculationResults.PerCrit and CalculationResults.Crits > 0 then
			frame:AddDoubleLine(L["Dot"] .. " " .. L["Crits:"], CalculationResults.Crits .. "x ~" .. CalculationResults.PerCrit, rt, gt, bt, r, g, b )
		end
		if CalculationResults.Targets then
			frame:AddDoubleLine(L["AoE"] .. ":", CalculationResults.Targets .. "x ~" .. CalculationResults.PerTarget, rt, gt, bt, r, g, b )
		end
	end
	if settings.Total then
		if CalculationResults.AvgTotalO then
			frame:AddDoubleLine(L["Combined Total:"], CalculationResults.AvgTotal, rt, gt, bt, r, g, b  )
		else
			frame:AddDoubleLine(L["Avg Total"] .. ":", CalculationResults.AvgTotal, rt, gt, bt, r, g, b)
		end
	end

	if not settings.DefaultColor then
		local c = settings.TooltipTextColor4
		r, g, b = c.r, c.g, c.b
	end

	local bType
	if CalculationResults.Ranged then
		bType = L["RAP"]
	else
		bType = L["AP"]
	end

	if CalculationResults.Stats then
		local apA = CalculationResults.NextAP and CalculationResults.NextAP > 0 and CalculationResults.AvgTotal * 0.1 / CalculationResults.NextAP
		local spA = CalculationResults.NextSP and CalculationResults.NextSP > 0 and CalculationResults.AvgTotal * 0.1 / CalculationResults.NextSP
		local critA = CalculationResults.NextCrit and CalculationResults.NextCrit > 0 and CalculationResults.AvgTotal * 0.01 / CalculationResults.NextCrit * self:GetRating("Crit", nil, true)
		local arpA = CalculationResults.NextARP and CalculationResults.NextARP > 0.5 and CalculationResults.AvgTotal * 0.01 / CalculationResults.NextARP * self:GetRating("ArmorPenetration",nil,true)
		local expA = CalculationResults.NextExp and CalculationResults.NextExp > 0.5 and CalculationResults.AvgTotal * 0.01 / CalculationResults.NextExp * self:GetRating("Expertise",nil,true)
		local rating = CalculationResults.NextHit and (CalculationResults.NextHit > 0.5) and (baseSpell.SpellHit and self:GetRating("Hit", nil, true) or self:GetRating("MeleeHit", nil, true))
		local hitA = rating and (CalculationResults.AvgTotal * 0.01 / CalculationResults.NextHit * rating)	
		
		if settings.Next then
			if CalculationResults.NextAP then
				frame:AddDoubleLine("+10 " .. bType .. ":", ((CalculationResults.NextAP > 0) and "+" or "") .. CalculationResults.NextAP, rt, gt, bt, r, g, b )
			end
			if CalculationResults.NextSP then
				frame:AddDoubleLine("+10 " .. L["SP"] .. ":", "+" .. CalculationResults.NextSP, rt, gt, bt, r, g, b )
			end		
			if CalculationResults.NextExp then
				frame:AddDoubleLine("+1 " .. L["Expertise"] .. " (" .. self:GetRating("Expertise") .. "):", ((CalculationResults.NextExp > 0) and "+" or "") .. CalculationResults.NextExp, rt, gt, bt, r, g, b )
			end
			if CalculationResults.NextARP then
				frame:AddDoubleLine("+1% " .. L["ArP"] .. " (" .. self:GetRating("ArmorPenetration") .. "):", ((CalculationResults.NextARP > 0) and "+" or "") .. CalculationResults.NextARP, rt, gt, bt, r, g, b )	
			end
			if CalculationResults.NextCrit then
				frame:AddDoubleLine("+1% " .. L["Crit"] .. " (" .. self:GetRating("Crit") .. "):", ((CalculationResults.NextCrit > 0) and "+" or "") .. CalculationResults.NextCrit, rt, gt, bt, r, g, b )
			end
			if CalculationResults.NextHit then
				frame:AddDoubleLine("+1% " .. L["Hit"] .. " (" .. self:GetRating("MeleeHit") .. "):", ((CalculationResults.NextHit > 0) and "+" or "") .. CalculationResults.NextHit, rt, gt, bt, r, g, b )
			end
		end
		if settings.CompareStats then
			local text, value
			local text2, value2
			if apA then
				local apA = DrD_Round(apA,1)
				text = bType
				value = apA
			end
			if critA then
				local critA = DrD_Round(critA,1)
				text = text and (text .. "|" .. L["Cr"]) or L["Cr"]
				value = value and (value .. "/" .. critA) or critA
			end		
			if hitA then
				local hitA = DrD_Round(hitA,1)
				text = text and (text .. "|" .. L["Ht"]) or L["Ht"]
				value = value and (value .. "/" .. hitA) or hitA	
			end			
			if spA then
				local spA = DrD_Round(spA,1)
				text2 = L["SP"]
				value2 = spA
			end
			if arpA then
				local arpA = DrD_Round(arpA,1)
				text2 = text2 and (text2 .. "|" .. L["ArP"]) or L["ArP"]
				value2 = value2 and (value2 .. "/" .. arpA) or arpA
			end				
			if expA then
				local expA = DrD_Round(expA,1)
				text2 = text2 and (text2 .. "|" .. L["Exp"]) or L["Exp"]
				value2 = value2 and (value2 .. "/" .. expA) or expA
			end				
			if text then
				frame:AddDoubleLine("+1% " .. L["Damage"] .. " (" .. text .. "):", value, rt, gt, bt, r, g, b )
			end
			if text2 then
				frame:AddDoubleLine("+1% " .. L["Damage"] .. " (" .. text2 .. "):", value2, rt, gt, bt, r, g, b )
			end
		end
		if settings.CompareSP and spA then
			local text, value = self:CompareTooltip(spA, apA, critA, hitA, expA, arpA, L["SP"], bType, L["Cr"], L["Ht"], L["Exp"], L["ArP"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end
		end		
		if settings.CompareAP and apA then
			local text, value = self:CompareTooltip(apA, spA, critA, hitA, expA, arpA, bType, L["SP"], L["Cr"], L["Ht"], L["Exp"], L["ArP"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end
		end
		if settings.CompareCrit and critA then
			local text, value = self:CompareTooltip(critA, spA, apA, hitA, expA, arpA, L["Cr"], L["SP"], bType, L["Ht"], L["Exp"], L["ArP"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end
		end
		if settings.CompareHit and hitA then
			local text, value = self:CompareTooltip(hitA, spA, apA, critA, expA, arpA, L["Ht"], L["SP"], bType, L["Cr"], L["Exp"], L["ArP"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end
		end
		if settings.CompareExp and expA then
			local text, value = self:CompareTooltip(expA, spA, apA, critA, hitA, arpA, L["Exp"], L["SP"], bType, L["Cr"], L["Ht"], L["ArP"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end
		end
		if settings.CompareArp and arpA then
			local text, value = self:CompareTooltip(arpA, spA, apA, critA, hitA, expA, L["ArP"], L["SP"], bType, L["Cr"], L["Ht"], L["Exp"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end		
		end
	end

	if not settings.DefaultColor then
		local c = settings.TooltipTextColor5
		r, g, b = c.r, c.g, c.b
	end

	if not baseSpell.NoDPS and settings.DPS then
		local extra
		if settings.Extra and CalculationResults.ExtraDPS then
			frame:AddDoubleLine(L["DPS"] .. " (" .. CalculationResults.ExtraNameDPS .. "):", CalculationResults.ExtraDPS, rt, gt, bt, r, g, b)
			extra = CalculationResults.ExtraDPS
		end
		if CalculationResults.DPS and (not extra or extra and CalculationResults.DPS > extra) then
			frame:AddDoubleLine(L["DPS"] .. ((CalculationResults.DPS_Duration and " (" .. CalculationResults.DPS_Duration .. "s):") or ":"), CalculationResults.DPS, rt, gt, bt, r, g, b )
		end
		if CalculationResults.DPSCD then
			frame:AddDoubleLine(L["DPS (CD):"], CalculationResults.DPSCD, rt, gt, bt, r, g, b )
		end
	end

	if settings.DPP and CalculationResults.DPM and CalculationResults.PowerType and not baseSpell.NoDPM then
		frame:AddDoubleLine( CalculationResults.PowerType .. ":", CalculationResults.DPM, rt, gt, bt, r, g, b )
	end

	if settings.Hints then
		if not settings.DefaultColor then
			local c = settings.TooltipTextColor6
			r, g, b = c.r, c.g, c.b
		end
		if CalculationResults.CritCapNote then
			frame:AddLine(L["Crit cap reached"], r, g, b)
		end
		--if CalculationResults.HybridNote then
		--	frame:AddLine("Hint: Add enemy armor from options", r, g, b)
		--end
	end
	frame:Show()
end