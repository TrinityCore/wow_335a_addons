local _, playerClass = UnitClass("player")
if playerClass ~= "DRUID" and playerClass ~="MAGE" and playerClass ~="PALADIN" and playerClass ~="PRIEST" and playerClass ~="SHAMAN" and playerClass ~="WARLOCK" and playerClass ~= "DEATHKNIGHT" then return end
local playerHealer = (playerClass == "PRIEST") or (playerClass == "SHAMAN") or (playerClass == "PALADIN") or (playerClass == "DRUID")
local playerHybrid = (playerClass == "DRUID") or (playerClass == "PALADIN") or (playerClass == "SHAMAN") or (playerClass == "DEATHKNIGHT")

--Libraries
DrDamage = LibStub("AceAddon-3.0"):NewAddon("DrDamage","AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceBucket-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("DrDamage", true)
local GT = LibStub:GetLibrary("LibGratuity-3.0")
local DrDamage = DrDamage

--General
local settings
local type = type
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local next = next
local math_abs = math.abs
local math_floor = math.floor
local math_ceil = math.ceil
local math_min = math.min
local math_max = math.max
local string_match = string.match
local string_sub = string.sub
local string_gsub = string.gsub
local string_find = string.find
local select = select

--Module
local UnitDamage = UnitDamage
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local UnitLevel = UnitLevel
local UnitPower = UnitPower
local UnitPowerType = UnitPowerType
local UnitIsPlayer = UnitIsPlayer
local UnitIsFriend = UnitIsFriend
local UnitExists = UnitExists
local UnitStat = UnitStat
local UnitRangedDamage = UnitRangedDamage
local GetSpellInfo = GetSpellInfo
local GetSpellBonusDamage = GetSpellBonusDamage
local GetSpellBonusHealing = GetSpellBonusHealing
local GetSpellCritChance = GetSpellCritChance
local GetCritChance = GetCritChance
local GetCombatRating = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus
local GetRangedCritChance = GetRangedCritChance
local GetManaRegen = GetManaRegen
local GetTalentInfo = GetTalentInfo
local HasWandEquipped = HasWandEquipped
local IsEquippedItem = IsEquippedItem
local IsShiftKeyDown = IsShiftKeyDown

--Module variables
local DrD_ClearTable, DrD_Round, DrD_MatchData, DrD_DmgCalc, DrD_BuffCalc
local spellInfo, PlayerAura, TargetAura, Consumables, Calculation

function DrDamage:Caster_OnEnable()
	local ABOptions = self.options.args.General.args.Actionbar.args
	if settings.DisplayType then
		if not ABOptions.DisplayType.values[settings.DisplayType] then
			settings.DisplayType = "AvgTotal"
		end
	end
	if settings.DisplayType2 then
		if not ABOptions.DisplayType2.values[settings.DisplayType2] then
			settings.DisplayType2 = false
		end
		if settings.DisplayType2 == "Casts" then
			self.manaBucket = self:RegisterBucketEvent("UNIT_MANA", 2)
		end
	end
	if not playerHybrid then
		local displayTypeTable = { ["Avg"] = 1, ["AvgTotal"] = 1, ["AvgHit"] = 2, ["AvgHitTotal"] = 2, ["AvgCrit"] = 3, ["MinHit"] = 4, ["MaxHit"] = 5, ["MinCrit"] = 6, ["MaxCrit"] = 7, ["MaxTotal"] = 7, ["DPS"] = 8, ["DPSC"] = 8, ["DPSCD"] = 8, ["CastTime"] = 9 }
		self.ClassSpecials[GetSpellInfo(5019)] = function()
			if not HasWandEquipped() then return "" end
			local speed, min, max = UnitRangedDamage("player")
			local avg = (min + max) / 2
			local avgTotal = avg * (1 + 0.005 * GetRangedCritChance())
			local DPS = avgTotal / speed
			local display = settings.DisplayType and displayTypeTable[settings.DisplayType]
			if display then
				local text = select(display, avgTotal, avg, 1.5 * avg, min, max, 1.5 * min, 1.5 * max, DPS, DrD_Round(speed, 2))
				return text, nil, nil, (display == 9)
			end
		end
	end	

	DrD_ClearTable = self.ClearTable
	DrD_BuffCalc = self.BuffCalc
	DrD_Round = self.Round
	DrD_MatchData = self.MatchData
	spellInfo = self.spellInfo
	PlayerAura = self.PlayerAura
	TargetAura = self.TargetAura
	Consumables = self.Consumables
	Calculation = self.Calculation
end

function DrDamage:Caster_RefreshConfig()
	settings = self.db.profile
end

local oldValues = 0
function DrDamage:Caster_CheckBaseStats()
	local newValues = 0

	for i = 2, 7 do
		newValues = newValues + GetSpellBonusDamage(i)
		--newValues = newValues + GetSpellCritChance(i)
	end
	newValues = newValues 
	+ GetSpellCritChance(3) 
	+ GetSpellBonusHealing() 
	+ GetCombatRating(8) 
	--+ GetCombatRating(20) 
	+ GetManaRegen("player")
	+ select(7,GetSpellInfo(18960))
	--+ select(2,UnitStat("player",4))
	--+ select(2,UnitStat("player",5))

	if newValues ~= oldValues then
		oldValues = newValues
		return true
	end

	return false
end

local oldMana = UnitPower("player",0)
local trigger = 20 + UnitLevel("player") * 3
function DrDamage:UNIT_MANA(units)
	if units["player"] then
		local playerMana = UnitPower("player",0)
		if math_abs(playerMana - oldMana) >= trigger then
			oldMana = playerMana
			if not self.fullUpdate then
				self:UpdateAB(nil, nil, nil, true)
			end
		end
	end
end

--Static tables
local schoolTable = { ["Holy"] = 2, ["Fire"] = 3, ["Nature"] = 4, ["Frost"] = 5, ["Shadow"] = 6, ["Arcane"] = 7 }
local potion_sickness = GetSpellInfo(53787)
local ABRound = { ["DPS"] = true, ["DPSC"] = true, ["DPSCD"] = true, ["MPS"] = true }

--Temporary tables
local calculation = {}
local ActiveAuras = {}
local AuraTable = {}
local Talents = {}
local CalculationResults = {}

local function ModifyTable( table )
	if table then
		for k, v in pairs( table ) do
			if calculation[k] then
				local sign, value = string_sub(v,1,1), tonumber(string_sub(v,2))
				if sign == "=" then
					calculation[k] = value
				elseif sign == "+" then
					calculation[k] = calculation[k] + value
				elseif sign == "-" then
					calculation[k] = calculation[k] - value
				elseif sign == "*" then
					calculation[k] = calculation[k] * value
				elseif sign == "/" then
					calculation[k] = calculation[k] / value
				end
			end
		end
	end
end

function DrDamage:CasterCalc( name, rank, tooltip, modify, debug )
	if not spellInfo or not name then return end
	if not rank then
		_, rank = GetSpellInfo(name)
	elseif tonumber(rank) and GetSpellInfo(name) then
		rank = string_gsub(select(2,GetSpellInfo(name)),"%d+", rank)
	end

	local spellTable
	if spellInfo[name]["Secondary"] and (settings.SwapCalc and (not tooltip or not IsShiftKeyDown()) or not settings.SwapCalc and tooltip and IsShiftKeyDown()) then
		spellTable = spellInfo[name]["Secondary"]
	else
		spellTable =  spellInfo[name]
	end

	if not spellTable then return end
	local baseSpell = spellTable[0]

	if type(baseSpell) == "function" then
		baseSpell, spellTable  = baseSpell()
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

	if type(baseSpell.School) == "table" then
		calculation.school = baseSpell.School[1]
		calculation.group = baseSpell.School[2]
		calculation.subType = baseSpell.School[3]
	else
		calculation.school = baseSpell.School
	end

	local healingSpell = (calculation.group == "Healing")					--Healing spell (boolean)
	calculation.healingSpell = healingSpell									--Healing spell, boolean
	calculation.name = name													--Ability name, localized
	calculation.spellName = spellName										--Ability name, enUS
	calculation.tooltipName = textLeft										--Text to display on left side of first line
	calculation.tooltipName2 = textRight									--Text to display on right side of first line
	calculation.minDam = spell[1]											--Spell initial base min damage
	calculation.maxDam = spell[2]											--Spell initial base max damage
	calculation.eDuration = spell.eDuration or baseSpell.eDuration or baseSpell.Channeled and calculation.castTime or 1	--Effect duration
	calculation.cooldown = baseSpell.Cooldown or 0							--Spell's cooldown
	calculation.sHits = spell.sHits or baseSpell.sHits						--Amount of hits of spell
	calculation.sTicks = baseSpell.sTicks									--Time between ticks of the spell
	calculation.canCrit = baseSpell.canCrit									--Crits true/false
	calculation.hybridDotDmg = spell.hybridDotDmg							--DoT portion of hybrid spells
	calculation.manaCost = select(4,GetSpellInfo(name,rank)) or 0			--Mana cost
	calculation.baseCost = calculation.manaCost
	calculation.powerType = select(6,GetSpellInfo(name,rank))				--Power cost type
	calculation.manaRegen = select(2, GetManaRegen("player"))				--Mana regen while casting
	calculation.playerMana = UnitPower("player",0)
	calculation.spirit = select(2,UnitStat("player",5))						--Player spirit
	calculation.int = select(2,UnitStat("player",4))						--Player intellect
	calculation.aoe = baseSpell.AoE											--Spell aoe amount
	calculation.targets = settings.TargetAmount								--Target amount for aoe spells
	calculation.chainFactor = baseSpell.chainFactor							--Chain effect spells
	calculation.leechBonus = baseSpell.Leech or 0							--Leech amount	
	
	--Calculation variables
	calculation.bDmgM = 1													--Base multiplier
	calculation.dmgM = 1													--Final multiplier
	calculation.dmgM_dot = 1												--Final multiplier to DoT portion
	calculation.dmgM_dd = 1													--Final coefficient multiplier for hybrid spells
	calculation.dmgM_dd_Add = 0												--Final coefficient additive modifier for hybrid spells
	calculation.dmgM_dot_Add = 0											--Talents: DoT Damage multiplier additive
	calculation.dmgM_Add = 0												--Talents: Damage multiplier additive
	calculation.dmgM_Magic = 1												--Magic damage modifier (CoE, Ebon Plague, Earth and Moon)
	calculation.finalMod = 0 												--Modifier to final damage +/-
	calculation.finalMod_M = 1												--Modifier to calculated total damage
	--calculation.finalMod_fM = 0											--Modifier to final damage with dmgM coefficient
	--calculation.finalMod_sM = 0											--Modifier to final damage with spellDmgM coefficient
	--calculation.finalMod_dot = 0											--Modifier to final dot damage +/-
	calculation.spellCrit = 0
	calculation.spellHit = 0
	calculation.meleeCrit = 0
	calculation.meleeHit = 0
	calculation.freeCrit = 0												--Mana crit modifier		

	--CORE: Spell damage and coefficients
	calculation.spellDmg = healingSpell and GetSpellBonusHealing() or baseSpell.Double and math_max(GetSpellBonusDamage(baseSpell.Double[1]),GetSpellBonusDamage(baseSpell.Double[2])) or GetSpellBonusDamage(schoolTable[calculation.school] or 1)
	calculation.spellDmg_dd = 0
	calculation.spellDmg_dot = 0
	calculation.spellDmgM = baseSpell.SPBonus or (healingSpell and 1.88 or 1) * (baseSpell.eDot and (calculation.eDuration / 15) or ((spell.castTime or baseSpell.castTime or 1.5) / 3.5))
	calculation.spellDmgM_Add = 0
	calculation.spellDmgM_dot = baseSpell.dotFactor or calculation.eDuration / 15
	calculation.spellDmgM_dot_Add = 0
	calculation.APBonus = baseSpell.APBonus or 0
	calculation.AP = baseSpell.APBonus and self:GetAP() or 0
	calculation.APM = 1
	
	--Determine levels used to calculate
	local playerLevel, targetLevel, boss = self:GetLevels()
	if settings.TargetLevel > 0 then
		targetLevel = playerLevel + settings.TargetLevel
	end
	calculation.playerLevel = playerLevel
	calculation.targetLevel = targetLevel
	local target = not healingSpell and "target" or (not UnitExists("target") or baseSpell.SelfHeal) and "player" or UnitIsFriend("target","player") and "target" or UnitIsFriend("targettarget","player") and "targettarget" or "player"	
	calculation.target = target
	
	--CORE: Calculate hit
	if baseSpell.MeleeHit then
		calculation.hitPerc = self:GetMeleeHit(playerLevel, targetLevel, nil, true)
	else
		calculation.hitPerc = self:GetSpellHit(playerLevel, targetLevel)
	end

	--CORE: Calculate crit
	if baseSpell.MeleeCrit then
		calculation.critM = 1
		calculation.critPerc = GetCritChance()
	else
		calculation.critM = 0.5
		calculation.critPerc = baseSpell.Double and math_max(GetSpellCritChance(baseSpell.Double[1]), GetSpellCritChance(baseSpell.Double[2])) or GetSpellCritChance(schoolTable[calculation.school] or 1)
	end

	--CORE: Calculate modified cast time
	local ct = select(7, GetSpellInfo(name,rank))
	if baseSpell.MeleeHaste then
		calculation.haste = 1 + 0.01 * GetCombatRatingBonus(19)
		calculation.hasteRating = GetCombatRating(19)
	else
		calculation.haste = 1.5 / (0.00015 * (select(7,GetSpellInfo(18960))))
		calculation.hasteRating = GetCombatRating(20)
	end
	if not ct or ct == 0 then
		if baseSpell.Channeled then
			calculation.castTime = (spell.castTime or baseSpell.castTime)
		else
			calculation.instant = true
			calculation.castTime = 1.5
		end
	else
		calculation.castTime = ct/1000 * calculation.haste
	end

	--CORE: Process modification tables
	if self.CasterGlobalModify then
		local modify = self.CasterGlobalModify
		ModifyTable( modify["All"] )
		ModifyTable( modify[calculation.school] )
		ModifyTable( modify[calculation.group] )
		ModifyTable( modify[spellName] )
	end
	--[[
	if modify and type(modify) == "table" then
		ModifyTable( modify )
	end
	--]]

	--CORE: Manual variables from profile:
	if settings.Custom then
		if settings.CustomAdd then
			calculation.spellDmg = math_max(0, calculation.spellDmg + settings.SpellDamage)
			calculation.AP = math_max(0, calculation.AP + settings.AP)
			calculation.manaRegen = math_max(0, calculation.manaRegen + settings.MP5/5)
			if not baseSpell.NoManualRatings then
				calculation.haste = math_max(1,(calculation.haste + 0.01 * self:GetRating((baseSpell.MeleeHaste and "MeleeHaste" or "Haste"), settings.HasteRating, true)))
				calculation.hasteRating = math_max(0, calculation.hasteRating + settings.HasteRating)			
			end
		else
			calculation.spellDmg = math_max(0, settings.SpellDamage)
			calculation.AP = math_max(0, settings.AP)
			calculation.manaRegen = math_max(0, settings.MP5/5)
			if not baseSpell.NoManualRatings then
				calculation.haste = math_max(1,(calculation.haste - GetCombatRatingBonus(20)/100 + 0.01 * self:GetRating((baseSpell.MeleeHaste and "MeleeHaste" or "Haste"), settings.HasteRating, true)))
				calculation.hasteRating = math_max(0, settings.HasteRating)
				calculation.critPerc = calculation.critPerc - GetCombatRatingBonus((baseSpell.MeleeCrit and 9 or 11))
				calculation.hitPerc = calculation.hitPerc - GetCombatRatingBonus((baseSpell.MeleeHit and 6 or 8))
			end
		end
		if not baseSpell.NoManualRatings then
			calculation.spellHit = self:GetRating("Hit", settings.HitRating, true)
			calculation.meleeHit = self:GetRating("MeleeHit", settings.HitRating, true)
			calculation.meleeCrit = self:GetRating("Crit", settings.CritRating, true)
			calculation.spellCrit = calculation.meleeCrit
		end
	end

	--CORE: Add mana potions if not potion sickness
	if settings.ManaConsumables and not UnitDebuff("player", potion_sickness) then
		calculation.playerMana = calculation.playerMana + 4300
	end

	--CORE: Random item bonuses to base values not supplied by API
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
							calculation.spellDmg = calculation.spellDmg + data[i+1]
						elseif calculation[modType] then
							calculation[modType] = calculation[modType] + data[i+1]
						elseif modType == "Base" then
							calculation.minDam = calculation.minDam + data[i+1]
							calculation.maxDam = calculation.maxDam + data[i+1]
						elseif modType == "BaseSP" then
							calculation.minDam = calculation.minDam + calculation.spellDmgM * data[i+1]
							calculation.maxDam = calculation.maxDam + calculation.spellDmgM * data[i+1]
						elseif modTypeAll then
							calculation[modTypeAll] = data[i+1]
						end
					end
				end
			end
		end
	end

	--CORE: Base value increase after levelups:
	if baseSpell.BaseIncrease then
		local spellLevel = spell.spellLevel
		if playerLevel >= 80 then
			calculation.minDam = calculation.minDam + spell[3]
			calculation.maxDam = calculation.maxDam + spell[4]
		elseif playerLevel > spellLevel then
			--local rank = rank and tonumber(string_match(rank,"%d+"))
			--local nextrank = rank and spellInfo[name][rank+1]
			--if nextrank then
			local gain = (type(baseSpell.BaseIncrease) == "number") and baseSpell.BaseIncrease
			local gainLevels = math_min(80 - spellLevel, gain or spell.Downrank or baseSpell.Downrank or 5)
			calculation.minDam = calculation.minDam + spell[3] * math_min(1,(playerLevel - spellLevel) / gainLevels)
			calculation.maxDam = calculation.maxDam + spell[4] * math_min(1,(playerLevel - spellLevel) / gainLevels)
		end
		calculation.minDam = math_floor(calculation.minDam)
		calculation.maxDam = math_ceil(calculation.maxDam)
	end
	
	--CORE: Factor for downranking, factor for spells under level 20
	calculation.penaltyMod = 1
	if spell.spellLevel then
		if (spell.spellLevel < 20) and not baseSpell.NoLowLevelPenalty then
			calculation.penaltyMod = 1 - ((20 - spell.spellLevel) * 0.0375)
		end
		if not (spell.NoDownrank or baseSpell.NoDownrank) then
			local mod = math_min(1,math_max(0,(22 + spell.spellLevel + (spell.Downrank or baseSpell.Downrank or 5) - playerLevel) * 0.05))
			if mod < 1 then
				calculation.penaltyMod = calculation.penaltyMod * mod
				calculation.downrank = true
			end
		end
	end	

	--CORE: Apply talents
	for i=1,#spellTalents do
		local talentValue = spellTalents[i]
		local modType = spellTalents[("ModType" .. i)]
		local mod = spellTalents["Mod"..i]

		if calculation[modType] then
			if spellTalents[("Multiply" .. i)] then
				calculation[modType] = calculation[modType] * (1 + talentValue)
			else
				calculation[modType] = calculation[modType] + talentValue
			end
		elseif self.Calculation[modType] then
			self.Calculation[modType](calculation, talentValue)
		else
			Talents[modType] = talentValue
		end
		if mod then
			local _, _, _, _, cur = GetTalentInfo(mod[2],mod[3])
			if mod[6] - cur ~= 0 then
				calculation[mod[4]] = mod[5](calculation[mod[4]], cur, mod[6])
			end
		end
	end

	--CORE: Buffs/Debuffs
	local mod = baseSpell.NoGlobalMod and 1 or healingSpell and self.healingMod or (select(7, UnitDamage("player")) or 1) * (self.casterMod or 1)
	if mod and mod > 0 then calculation.dmgM = calculation.dmgM * mod end
	--BUFF/DEBUFF -- DAMAGE/HEALING -- PLAYER
	for index=1,40 do
		local buffName, rank, texture, apps = UnitBuff("player",index)
		if buffName then
			if spellPlayerAura[buffName] then
				DrD_BuffCalc( PlayerAura[buffName], calculation, ActiveAuras, Talents, baseSpell, buffName, index, apps, texture, rank, "player" )
				AuraTable[buffName] = true
			end
		else break end
	end
	--DEBUFF -- DAMAGE/HEALING -- PLAYER
	for index=1,40 do
		local buffName, rank, texture, apps = UnitDebuff("player",index)
		if buffName then
			if spellPlayerAura[buffName] then
				DrD_BuffCalc( PlayerAura[buffName], calculation, ActiveAuras, Talents, baseSpell, buffName, index, apps, texture, rank, "player" )
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
	if not baseSpell.NoTargetAura then
		--DEBUFF -- DAMAGE/HEALING -- TARGET
		for index=1,40 do
			local buffName, rank, texture, apps = UnitDebuff(target,index)
			if buffName then
				if spellTargetAura[buffName] then
					DrD_BuffCalc( TargetAura[buffName], calculation, ActiveAuras, Talents, baseSpell, buffName, index, apps, texture, rank, target )
					AuraTable[buffName] = true
				end
			else break end
		end
		--BUFF - HEALING -- TARGET
		if healingSpell then
			for index=1,40 do
				local buffName, rank, texture, apps = UnitBuff(target,index)
				if buffName then
					if spellTargetAura[buffName] then
						DrD_BuffCalc( TargetAura[buffName], calculation, ActiveAuras, Talents, baseSpell, buffName, index, apps, texture, rank, target )
						AuraTable[buffName] = true
					end
				else break end
			end
		end
		if next(settings["TargetAura"]) or debug then
			for buffName in pairs(debug and spellTargetAura or settings["TargetAura"]) do
				if spellTargetAura[buffName] and not AuraTable[buffName] then
					DrD_BuffCalc( TargetAura[buffName], calculation, ActiveAuras, Talents, baseSpell, buffName )
				end
			end
		end
	end

	--CORE: Sum up buffs, hit and crit
	if baseSpell.MeleeCrit then
		calculation.critPerc = calculation.critPerc + calculation.meleeCrit
	else
		calculation.critPerc = calculation.critPerc + calculation.spellCrit
	end
	if baseSpell.MeleeHit then
		calculation.hitPerc = calculation.hitPerc + calculation.meleeHit
	else
		calculation.hitPerc = calculation.hitPerc + calculation.spellHit
	end
	if not healingSpell then
		calculation.dmgM = calculation.dmgM * calculation.dmgM_Magic
	end

	if Calculation[playerClass] then
		Calculation[playerClass]( calculation, ActiveAuras, Talents, spell, baseSpell )
	end
	if Calculation[spellName] then
		Calculation[spellName]( calculation, ActiveAuras, Talents, spell, baseSpell )
	end

	--CORE: Add Haste
	calculation.castTime = calculation.castTime / calculation.haste

	--CORE: Calculate crit depression
	if settings.TargetLevel > 0 or not UnitIsPlayer("target") then
		if settings.CritDepression and baseSpell.MeleeCrit then
			if boss then
				calculation.critPerc = calculation.critPerc - 4.8
			else
				local deltaLevel = math_max(0,targetLevel - playerLevel)
				calculation.critPerc = calculation.critPerc - deltaLevel * 0.6 + ((deltaLevel >= 3) and 3 or 0)
			end
		end
		--TODO: Spell crit depression?
	end

	--CORE: Crit modifier
	if not calculation.critM_custom then
		if baseSpell.MeleeCrit then
			calculation.critM = calculation.critM * (1 + 2 * self.Damage_critMBonus)
		else
			calculation.critM = calculation.critM * (1 + 3 * (healingSpell and self.Healing_critMBonus or self.Damage_critMBonus))
		end
	end

	--CORE: Resilience
	if settings.Resilience > 0 and not healingSpell then
		calculation.critPerc = calculation.critPerc - settings.Resilience / self:GetRating("Resilience")
		calculation.critM = calculation.critM * math_max(2/3 - 1/(3 * calculation.critM), 1 - 0.044 * (settings.Resilience / self:GetRating("Resilience")))
		calculation.dmgM = calculation.dmgM * (1 - math_min(1, 0.02 * settings.Resilience / self:GetRating("Resilience")))
	end

	--CORE: Damage modifier
	if not calculation.dmgM_custom then
		calculation.dmgM_dot = calculation.dmgM_dot * calculation.dmgM * (1 + calculation.dmgM_Add + calculation.dmgM_dot_Add)
		calculation.dmgM = baseSpell.eDot and calculation.dmgM_dot or calculation.dmgM * (1 + calculation.dmgM_Add + calculation.dmgM_dd_Add)
	end

	--CORE: Sum spell power coefficient
	calculation.spellDmgM = (calculation.spellDmgM + calculation.spellDmgM_Add) * (baseSpell.HybridDownrank and 1 or calculation.penaltyMod) * (baseSpell.sFactor or 1)
	calculation.spellDmgM_dot = (calculation.spellDmgM_dot + calculation.spellDmgM_dot_Add) * calculation.penaltyMod * (baseSpell.sFactor or 1)
	calculation.APBonus = calculation.APBonus * calculation.penaltyMod
	calculation.AP = calculation.AP * calculation.APM

	--CORE: Reset cooldown if <= 0
	if calculation.cooldown and calculation.cooldown <= 0 then
		calculation.cooldown = nil
	end

	local returnAvgTotal = DrD_DmgCalc( baseSpell, spell, false, false, tooltip )

	if tooltip and not baseSpell.NoNext then
		if settings.Next or settings.CompareStats or settings.CompareSP or settings.CompareAP or settings.CompareCrit or settings.CompareHit or settings.CompareHaste then
			CalculationResults.Stats = true
			if calculation.canCrit then
				calculation.critPerc = calculation.critPerc + 1
				CalculationResults.NextCrit = DrD_Round( DrD_DmgCalc( baseSpell, spell, true ) - returnAvgTotal, 2 )
				calculation.critPerc = calculation.critPerc - 1
			end
			if (calculation.spellDmgM > 0) or (calculation.spellDmgM_dot > 0) then
				calculation.spellDmg = calculation.spellDmg + 10
				CalculationResults.NextSP = DrD_Round( DrD_DmgCalc( baseSpell, spell, true ) - returnAvgTotal, 2 )
				calculation.spellDmg = calculation.spellDmg - 10
			end
			if calculation.APBonus > 0 then
				calculation.AP = calculation.AP + 10
				CalculationResults.NextAP = DrD_Round( DrD_DmgCalc( baseSpell, spell, true ) - returnAvgTotal, 2 )
				calculation.AP = calculation.AP - 10
			end			
			if not healingSpell and not baseSpell.Unresistable then
				local temp = settings.HitCalc and returnAvgTotal or DrD_DmgCalc( baseSpell, spell, true, true )
				calculation.hitPerc = calculation.hitPerc + 1
				CalculationResults.NextHit = DrD_Round( DrD_DmgCalc( baseSpell, spell, true, true ) - temp, 2 )
			end
		end
	end

	DrD_ClearTable( Talents )
	DrD_ClearTable( ActiveAuras )
	DrD_ClearTable( AuraTable )

	local text1 = settings.DisplayType and (ABRound[settings.DisplayType] and math_floor(CalculationResults[settings.DisplayType] + 0.5) or CalculationResults[settings.DisplayType])
	local text2 = settings.DisplayType2 and (ABRound[settings.DisplayType2] and math_floor(CalculationResults[settings.DisplayType2] + 0.5) or CalculationResults[settings.DisplayType2])
	return text1, text2, CalculationResults, calculation, debug and ActiveAuras
end

local function DrD_FreeCrits( casts, calculation )
	local total = casts
	local mod = calculation.freeCrit * calculation.critPerc / 100
	for i = 1, 5 do
		casts = math_floor(mod * casts)
		if casts == 0 then break end
		total = total + casts
	end
	return total
end

DrD_DmgCalc = function( baseSpell, spell, nextCalc, hitCalc, tooltip )
	--CORE: Initialize variables
	local eDuration = calculation.eDuration
	local baseDuration = spell.eDuration or baseSpell.eDuration
	local baseHits = spell.sHits or baseSpell.sHits
	local modDuration = baseDuration and (eDuration > baseDuration) and (1 + (eDuration - baseDuration) / baseDuration) or 1
	local modHits = baseHits and (calculation.sHits > baseHits) and (1 + (calculation.sHits - baseHits) / baseHits) or 1
	local dispSpellDmgM = calculation.spellDmgM * modHits

	--CORE: Basic min/max calculation
	local calcMinDmg = calculation.dmgM_dd * calculation.dmgM * (calculation.bDmgM * calculation.minDam * (calculation.sHits or 1) + (modHits * ((calculation.spellDmg + calculation.spellDmg_dd) * calculation.spellDmgM + calculation.AP * calculation.APBonus))) + calculation.finalMod --+ calculation.finalMod_fM * calculation.dmgM --+ calculation.finalMod_sM * calculation.spellDmgM
	local calcMaxDmg = calculation.dmgM_dd * calculation.dmgM * (calculation.bDmgM * calculation.maxDam * (calculation.sHits or 1) + (modHits * ((calculation.spellDmg + calculation.spellDmg_dd) * calculation.spellDmgM + calculation.AP * calculation.APBonus))) + calculation.finalMod --+ calculation.finalMod_fM * calculation.dmgM --+ calculation.finalMod_sM * calculation.spellDmgM
	local calcDotDmg = 0

	--CORE: Effects extended by talents. (Imp. SW:P etc.)
	if baseSpell.eDot and (modDuration > 1) then
		calcMinDmg = calcMinDmg * modDuration
		calcMaxDmg = calcMaxDmg * modDuration
		dispSpellDmgM = dispSpellDmgM * modDuration
	end

	--CORE: Calculate average
	local calcAvgDmg = (calcMinDmg + calcMaxDmg) / 2

	--CORE: Critical hits
	local calcAvgCrit, calcAvgDmgCrit, calcMinCrit, calcMaxCrit
	local critBonus, critBonus_dot = 0, 0
	if calculation.critPerc > 100 then
		calculation.critPerc = 100
	elseif calculation.critPerc < 0 then
		calculation.critPerc = 0
	end
	if calculation.canCrit then
		calcMinCrit = calcMinDmg + calcMinDmg * calculation.critM
		calcMaxCrit = calcMaxDmg + calcMaxDmg * calculation.critM
		critBonus = (calculation.critPerc / 100) * calcAvgDmg * calculation.critM
		calcAvgCrit = (calcMinCrit + calcMaxCrit) / 2
		calcAvgDmgCrit = calcAvgDmg + critBonus
	else
		calcAvgCrit = calcAvgDmg
		calcAvgDmgCrit = calcAvgDmg
	end

	--DOT: Hybrid
	if calculation.hybridDotDmg then
		calcDotDmg = calculation.dmgM_dot * ( calculation.spellDmgM_dot * (calculation.spellDmg + calculation.spellDmg_dot) + calculation.hybridDotDmg ) * modDuration
		dispSpellDmgM = dispSpellDmgM + calculation.spellDmgM_dot * modDuration
		if calculation.hybridCanCrit then
			critBonus_dot = calcDotDmg * (calculation.critPerc / 100) * (calculation.critM_dot or calculation.critM)
			calcDotDmg = calcDotDmg + critBonus_dot
		end
	end

	--DOT: Extra DoT, eg. fireball. Uncomment extraDotF if functionality ever needed.
	if calculation.extraDotDmg then
		calcDotDmg = calcDotDmg + calculation.dmgM_dot * calculation.extraDotDmg * modDuration --* baseSpell.extraDotF * calculation.penaltyMod * calculation.spellDmg
		--dispSpellDmgM = dispSpellDmgM + baseSpell.extraDotF * calculation.penaltyMod * modDuration
	end

	--DOT: Final modifier
	--calcDotDmg = calcDotDmg + calculation.finalMod_dot

	--SPECIAL: Extra effects
	local extra = calculation.extra or 0
	local extraMin, extraMax = extra, extra
	local extraAvg
	if calculation.extraCrit then
		extra = extra + calcAvgCrit * calculation.extraCrit
		extraMin = extraMin + (calcMinCrit or calcMinDmg) * calculation.extraCrit
		extraMax = extraMax + (calcMaxCrit or calcMaxDmg) * calculation.extraCrit
	elseif calculation.extraAvg then
		extra = extra + calcAvgDmgCrit * calculation.extraAvg
		extraMin = extraMin + calcMinDmg * calculation.extraAvg
		extraMax = extraMax + (calcMaxCrit or calcMaxDmg) * calculation.extraAvg	
	end
	if calculation.extraChanceCrit then
		calculation.extraChance = calculation.critPerc / 100
	end
	if calculation.extraDamage then
		local bonus = calculation.extraDamage * calculation.spellDmg
		extra = extra + bonus
		extraMin = extraMin + bonus
		extraMax = extraMax + bonus
	end
	if calculation.extraBonus then
		local bonus = calculation.extraDmgM or calculation.dmgM
		extra = extra * bonus
		extraMin = extraMin * bonus
		extraMax = extraMax * bonus
	end
	if calculation.extraCanCrit then
		extraAvg = extra * (1 + calculation.critM * calculation.critPerc / 100) * (calculation.extraChance or 1)
		extraMax = extraMax * (1 + calculation.critM)
	else
		extraAvg = extra * (calculation.extraChance or 1)
	end
	if calculation.extraCritEffect then 
		extraAvg = extraAvg + calculation.extraCritEffect * extraMax * (calculation.critPerc / 100)
		extraMax = extraMax + calculation.extraCritEffect * extraMax
	end

	--SPECIAL: Final average modifiers (lightning overload) and effects from modules
	calcAvgDmgCrit = calcAvgDmgCrit * calculation.finalMod_M + extraAvg

	--CORE: Hit calculation:
	local hitPenalty, hitPenaltyAvg = 0, 0
	if calculation.hitPerc > 100 then
		calculation.hitPerc = 100
	elseif calculation.hitPerc < 0 then
		calculation.hitPerc = 0
	end
	if not calculation.healingSpell and not baseSpell.Unresistable then
		if settings.HitCalc or hitCalc then
			if (settings.TwoRoll and not baseSpell.MeleeHit) or (settings.TwoRoll_M and baseSpell.MeleeHit) then
				hitPenalty = calcAvgDmgCrit * ((calculation.hitPerc / 100) - 1)
				hitPenaltyAvg = (calcAvgDmg + critBonus) * ((calculation.hitPerc / 100) - 1)
			else
				hitPenalty = (calcAvgDmgCrit - critBonus) * ((calculation.hitPerc / 100) - 1)
				hitPenaltyAvg = calcAvgDmg * ((calculation.hitPerc / 100) - 1)
			end
			calcAvgDmgCrit = calcAvgDmgCrit + hitPenalty
		end
	end

	local perHit, ticks
	if not nextCalc then
		--CORE: Per hit calculation
		if calculation.sHits then
			ticks = calculation.sHits
			perHit = calcAvgDmg / ticks
		elseif calculation.sTicks and (not spell.extraDotDmg or spell.extraDotDmg and not calculation.extraTicks) then
			ticks = eDuration / calculation.sTicks
			perHit = ((calculation.hybridDotDmg or calculation.extraDotDmg) and (calcDotDmg - critBonus_dot) or calcAvgDmg) / ticks
			if baseSpell.DotCap then
				ticks = math_ceil(calculation.hybridDotDmg / perHit)
				calcDotDmg = ticks * perHit
				dispSpellDmgM = dispSpellDmgM - calculation.spellDmgM_dot + (calculation.spellDmgM_dot / 6) * ticks
				eDuration = ticks * calculation.sTicks
			end
		elseif calculation.extraTicks then
			ticks = calculation.extraTicks
			perHit = extra / ticks
		end
	end

	--CORE: AoE and Chain effects (chain lightning, chain heal)
	local aoe, targets, perTarget
	if calculation.targets > 1 then
		if calculation.aoe then
			targets = (type(calculation.aoe) == "number") and math_min(calculation.targets, calculation.aoe) or calculation.targets
			if calculation.chainFactor then
				aoe = calcAvgDmgCrit * (calculation.chainFactor + (targets >= 3 and calculation.chainFactor^2 or 0) + (targets >= 4 and calculation.chainFactor^3 or 0))
				targets = targets - 1
			else
				aoe = calcAvgDmgCrit * (targets - 1)
				perTarget = calcAvgDmgCrit
			end
			if baseSpell.HybridAoE then
				aoe = (aoe or 0) + calcDotDmg * (targets - 1)
				perTarget = (perTarget or 0) + calcDotDmg
				--TODO: Do we want this to display?
				--if ticks then
				--	ticks = ticks * (targets - 1)
				--end
			end
		elseif baseSpell.ExtraAoE then
			targets = (calculation.targets - 1) * (calculation.sHits or 1)
			calcAvgDmgCrit = calcAvgDmgCrit - extraAvg
			aoe = extraAvg * targets
			perTarget = extraAvg
		end
		calcAvgDmgCrit = calcAvgDmgCrit + (aoe or 0)
	end

	--CORE: Remove average penalty for dot not hitting (when the main spell doesn't hit)
	if hitPenalty > 0 then
		calcAvgDmgCrit = calcAvgDmgCrit - calcDotDmg * (1 - ( calculation.hitPerc / 100))
	end

	--SPECIAL: Stacking spells, not used by anything at the moment
	--[[if baseSpell.Stacks then
		if calculation.extraDotDmg then
			perHit = calcAvgDmgCrit
			ticks = "~" .. baseSpell.Stacks
			calcAvgDmgCrit = calcAvgDmgCrit + calculation.extraDotDmg * (baseSpell.Stacks - 1) * calculation.dmgM_dot
		end
	end
	--]]

	local calcDPS, spamDmg, spamDPS
	if not nextCalc then
		--CORE: Minimum GCD 1s
		if calculation.castTime < 1 then
			calculation.castTime = 1
		else
			calculation.castTime = DrD_Round(calculation.castTime,3)
		end
		--CORE: Maximum GCD 1.5s
		if calculation.instant and calculation.castTime > 1.5 then
			calculation.castTime = 1.5
		end
		if calculation.customHaste and calculation.sTicks then
			eDuration = eDuration / calculation.haste
			calculation.sTicks = calculation.sTicks / calculation.haste
		elseif calculation.sTicks and baseSpell.Channeled then
			calculation.sTicks = calculation.sTicks / calculation.haste
		elseif calculation.sHits and not baseSpell.NoPeriod then
			calculation.sTicks = (calculation.instant and eDuration or calculation.castTime) / calculation.sHits
		end
		--CORE: DPS calculation
		if baseSpell.eDot or calculation.hybridDotDmg then
			calcDPS = ( calcAvgDmgCrit + calcDotDmg ) / eDuration
			if baseSpell.DotStacks then
				spamDmg = (calcDotDmg - perHit) * (baseSpell.DotStacks)
				spamDPS = (calcDotDmg / eDuration) * (baseSpell.DotStacks)
			elseif calculation.hybridDotDmg then
				spamDmg = calcAvgDmgCrit + (calculation.sTicks and (math_floor((calculation.cooldown or calculation.castTime)/calculation.sTicks) * perHit) or 0)
				spamDPS = spamDmg / (calculation.cooldown or calculation.castTime)
			end
		elseif calculation.extraDotDmg then
			calcDPS = calcAvgDmgCrit / calculation.castTime + calcDotDmg / eDuration
		else
			calcDPS = calcAvgDmgCrit / calculation.castTime
		end
	end

	--CORE: Add dot portion to total average value
	if not baseSpell.NoDotAverage then
		calcAvgDmgCrit = calcAvgDmgCrit + calcDotDmg
	end

	if nextCalc then
		return calcAvgDmgCrit
	else
		DrD_ClearTable( CalculationResults )

		CalculationResults.Avg =			math_floor(calcAvgDmg + hitPenaltyAvg + critBonus + 0.5)
		CalculationResults.AvgHit = 		math_floor((calculation.sHits and perHit or calcAvgDmg) + 0.5)
		CalculationResults.AvgHitTotal = 	math_floor((calcAvgDmg + calcDotDmg)/(calculation.sHits or 1) + 0.5)
		CalculationResults.AvgTotal = 		math_floor(calcAvgDmgCrit + 0.5)
		CalculationResults.MinHit = 		math_floor(calcMinDmg)
		CalculationResults.MaxHit = 		math_ceil(calcMaxDmg)
		CalculationResults.MaxTotal = 		math_ceil(calcDotDmg + (calcMaxCrit or calcMaxDmg) + (aoe or 0) + extra)
		CalculationResults.CastTime = 		DrD_Round(calculation.castTime, 2)
		
		if calculation.canCrit and not calculation.sHits then
			CalculationResults.MinCrit =	math_floor( calcMinCrit )
			CalculationResults.MaxCrit = 	math_ceil( calcMaxCrit )
			CalculationResults.AvgCrit = 	math_floor( calcAvgCrit + 0.5 )
		else
			CalculationResults.MinCrit =	CalculationResults.MinHit
			CalculationResults.MaxCrit = 	CalculationResults.MaxHit
			CalculationResults.AvgCrit = 	CalculationResults.AvgHit		
		end		
		if baseSpell.NoDPS then
			CalculationResults.DPS = 		CalculationResults.AvgTotal
			CalculationResults.DPSC = 		CalculationResults.AvgTotal
		else
			CalculationResults.DPS = 		DrD_Round(calcDPS, 1)
			CalculationResults.DPSC = 		not baseSpell.NoDPSC and DrD_Round(calcAvgDmgCrit / calculation.castTime, 1) or CalculationResults.DPS
		end

		CalculationResults.DPSCD = 			calculation.cooldown and DrD_Round(calcAvgDmgCrit / calculation.cooldown, 1) or CalculationResults.DPS

		if calculation.manaCost > 0 then
			local manaCost = 				calculation.manaCost * (1 - ((calculation.canCrit and calculation.critPerc or 0)/100) * calculation.freeCrit)
			CalculationResults.DPM = 		DrD_Round(calcAvgDmgCrit / manaCost, 1)
			CalculationResults.MPS = 		DrD_Round(manaCost / calculation.castTime, 1)
		else
			CalculationResults.DPM = 		"\226\136\158"
			CalculationResults.MPS = 		0
			CalculationResults.NoCost = 	true
		end
		--CORE: Write tooltip data
		if tooltip then
			CalculationResults.Healing = 			calculation.healingSpell
			CalculationResults.HitRate = 			DrD_Round( calculation.hitPerc, 2 )
			CalculationResults.DotDmg = 			math_floor( calcDotDmg + 0.5 )
			CalculationResults.DmgM = 				DrD_Round( calculation.dmgM, 3 )
			CalculationResults.Cooldown = 			calculation.cooldown

			if calculation.canCrit then
				CalculationResults.CritRate = 		DrD_Round( calculation.critPerc, 2 )
				CalculationResults.CritM =			DrD_Round( 100 + calculation.critM * 100, 2)
			end
			if calculation.APBonus > 0 then
				CalculationResults.AP = 			math_floor( calculation.AP + 0.5 )
				CalculationResults.APBonus = 		DrD_Round( calculation.APBonus, 3 )
			end
			if dispSpellDmgM > 0 then
				CalculationResults.SpellDmg = 		math_floor( calculation.spellDmg + 0.5 )
				CalculationResults.SpellDmgM = 		DrD_Round( dispSpellDmgM, 3 )
			end
			if not baseSpell.eDot and (calculation.castTime > 1) and not baseSpell.NoHaste or baseSpell.eDot and calculation.customHaste then
				CalculationResults.Haste = 			math_max(0,calculation.hasteRating)
			end
			if calculation.instant then
				CalculationResults.GCD = 			calculation.castTime
			end
			if calculation.tooltipName then
				CalculationResults.Name = 			calculation.tooltipName
			end
			if calculation.tooltipName2 then
				CalculationResults.Name2 = 			calculation.tooltipName2
			end
			if spamDPS then
				CalculationResults.SpamDPS =		DrD_Round( spamDPS, 1 )
			end
			if aoe then
				CalculationResults.AoE = 			math_floor( aoe + 0.5 )
				CalculationResults.Targets = 		targets
				if perTarget then
					CalculationResults.PerTarget =	math_floor( perTarget + 0.5 )
				end
			end
			if extra > 0 then
				CalculationResults.Extra =			math_floor( extraAvg + 0.5 )
				CalculationResults.ExtraMin =		math_floor( extraMin )
				CalculationResults.ExtraMax = 		math_ceil( extraMax )
				CalculationResults.ExtraName =		calculation.extraName
				--CalculationResults.ExtraDPS = 	DrD_Round( extraDPS, 1 )
			end
			if perHit and ticks then
				if calculation.canCrit and not calculation.hybridDotDmg and not calculation.extraDotDmg and not calculation.extraTicks or calculation.hybridCanCrit and calculation.hybridDotDmg then
					CalculationResults.PerCrit = 	DrD_Round( perHit + (calculation.critM_dot or calculation.critM) * perHit, 1 )
					CalculationResults.Crits = 		math_floor( ticks * (calculation.critPerc / 100) + 0.5 )
					ticks = 						ticks - CalculationResults.Crits
				end
				CalculationResults.PerHit = 		DrD_Round( perHit, 1 )
				CalculationResults.Hits = 			ticks
				if calculation.sTicks then
					CalculationResults.Ticks = 		DrD_Round( calculation.sTicks, 2 )
				end
			end
			if baseSpell.Leech and calculation.leechBonus ~= 1 or not baseSpell.Leech and calculation.leechBonus > 0 then
				if not baseSpell.DotLeech then
					CalculationResults.AvgLeech = 	DrD_Round( calcAvgDmg * calculation.leechBonus, 1 )
				end
				if perHit then
					CalculationResults.PerHitHeal = DrD_Round( perHit * calculation.leechBonus, 1 )
				end
			end
			if calculation.downrank then
				CalculationResults.Downrank = math_floor(100 - 100 * calculation.penaltyMod + 0.5)
			end
			if calculation.powerType == 0 and not baseSpell.NoManaCalc then
				local manaCost = calculation.manaCost
				if manaCost > 0 then
					local costMod = (1 - ((calculation.canCrit and calculation.critPerc or 0)/100) * calculation.freeCrit)
					if costMod < 1 then
						CalculationResults.TrueManaCost = DrD_Round(manaCost * costMod, 1)
					end
					local castTime = math_max((calculation.cooldown or 0), calculation.castTime)
					local PlayerMana = calculation.playerMana
					local base_casts = (calculation.freeCrit > 0) and calculation.canCrit and DrD_FreeCrits(math_floor(PlayerMana / manaCost), calculation) or math_floor(PlayerMana / manaCost)
					local casts = base_casts
					local regen_speed = calculation.manaRegen
					local regen_casts = 0 --math_floor(calculation.manaMod / manaCost)
					local regen_total = 0 --regen_casts * castTime * regen_speed

					if castTime <= 10 then
						for i = 1, 5 do
							local regen_new = casts * castTime * regen_speed
							casts = (calculation.freeCrit > 0) and calculation.canCrit and DrD_FreeCrits(math_floor(regen_new / manaCost), calculation) or math_floor(regen_new / manaCost)
							regen_total = regen_total + regen_new
							regen_casts = regen_casts + casts
							if casts == 0 then break end
						end
						CalculationResults.SOOM = DrD_Round((base_casts + regen_casts) * castTime, 1)
					end

					if spamDmg then
						CalculationResults.SpamDPM = DrD_Round(spamDmg / (CalculationResults.TrueManaCost or manaCost), 1)
					end
					if (base_casts + regen_casts) > 1000 then
						CalculationResults.castsBase = "\226\136\158"
						CalculationResults.castsRegen = 0
						CalculationResults.DOOM = "\226\136\158"
						CalculationResults.SOOM = nil
					else
						CalculationResults.castsBase = base_casts
						CalculationResults.castsRegen = regen_casts
						CalculationResults.DOOM = math_floor(CalculationResults.DPM * (PlayerMana + regen_total) + 0.5)
					end
				else
					CalculationResults.castsBase = "\226\136\158"
					CalculationResults.castsRegen = 0
				end
			elseif calculation.powerType == 6 then
				CalculationResults.RunicPower = L["PRP"] .. ":"
			end
		end
		return calcAvgDmgCrit
	end
end

function DrDamage:CasterTooltip( frame, name, rank )
	local value = select(3,self:CasterCalc(name, rank, true))
	if not value then return end

	local baseSpell
	if spellInfo[name]["Secondary"] and ((settings.SwapCalc and not IsShiftKeyDown()) or (IsShiftKeyDown() and not settings.SwapCalc)) then
		baseSpell = spellInfo[name]["Secondary"][0]
	else
		baseSpell = spellInfo[name][0]
		if type(baseSpell) == "function" then baseSpell = baseSpell() end
	end

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

	local healingSpell = CalculationResults.Healing
	local spellType, spellAbbr

	if healingSpell then
		spellType = L["Heal"]
		spellAbbr = L["H"]
	else
		spellType = L["Dmg"]
		spellAbbr = L["D"]
	end

	if settings.PlusDmg then
		local sp = CalculationResults.SpellDmgM and DrD_Round( CalculationResults.SpellDmg * CalculationResults.SpellDmgM * CalculationResults.DmgM, 1 )
		local ap = CalculationResults.APBonus and DrD_Round( CalculationResults.AP * CalculationResults.APBonus * CalculationResults.DmgM, 1 )
		if ap or sp then
			frame:AddDoubleLine(L["Effective"] .. " " .. (sp and L["SP"] or "") .. (sp and ap and "/" or "") .. (ap and L["AP"] or "") .. ":", (sp or "") .. (sp and ap and "/" or "") .. (ap or ""), rt, gt, bt, r, g, b )
		end
	end

	if settings.Coeffs then
		local sp = CalculationResults.SpellDmgM
		local ap = CalculationResults.APBonus
		if ap or sp then
			frame:AddDoubleLine(L["Coeffs"] --[[.. (sp and ap and (" " .. L["SP"] .. "/" .. L["AP"]) or "")--]] .. ":", (sp and (sp .."*" .. CalculationResults.SpellDmg) or "") .. (sp and ap and "/" or "") .. (ap and (ap .. "*" .. CalculationResults.AP) or ""), rt, gt, bt, r, g, b )
		end
		frame:AddDoubleLine(L["Multiplier:"], (CalculationResults.DmgM * 100) .. "%", rt, gt, bt, r, g, b )
		if CalculationResults.CritM then
			frame:AddDoubleLine(L["Crit Multiplier:"], CalculationResults.CritM .. "%", rt, gt, bt, r, g, b )
		end
	end

	if settings.DispCrit and CalculationResults.CritRate then
		frame:AddDoubleLine(L["Crit:"], CalculationResults.CritRate .. "%", rt, gt, bt, r, g, b )
	end

	if settings.DispHit and not baseSpell.Unresistable and not healingSpell then
		frame:AddDoubleLine(L["Hit:"], CalculationResults.HitRate .. "%", rt, gt, bt, r, g, b )
	end

	if not settings.DefaultColor then
		local c = settings.TooltipTextColor3
		r, g, b = c.r, c.g, c.b
	end

	if settings.AvgHit then
		frame:AddDoubleLine(L["Avg"] .. ":", CalculationResults.AvgHit .. " (".. CalculationResults.MinHit .."-".. CalculationResults.MaxHit ..")", rt, gt, bt, r, g, b )

		if CalculationResults.AvgLeech then
			frame:AddDoubleLine(L["Avg Heal:"], CalculationResults.AvgLeech, rt, gt, bt, r, g, b )
		end
	end

	if settings.AvgCrit and CalculationResults.AvgCrit > CalculationResults.AvgHit then
		frame:AddDoubleLine(L["Avg Crit:"], CalculationResults.AvgCrit .. " (".. CalculationResults.MinCrit .."-".. CalculationResults.MaxCrit ..")", rt, gt, bt, r, g, b )
	end

	if settings.Extra and CalculationResults.Extra then
		frame:AddDoubleLine(L["Avg"] .. " " .. (CalculationResults.ExtraName or L["Additional"]) .. ":", CalculationResults.Extra .. " (" .. CalculationResults.ExtraMin .."-".. CalculationResults.ExtraMax .. ")", rt, gt, bt, r, g, b)
	end

	if settings.Ticks and CalculationResults.PerHit then
		frame:AddDoubleLine(L["Hits:"], CalculationResults.Hits .. "x ~" .. CalculationResults.PerHit, rt, gt, bt, r, g, b )

		if CalculationResults.PerCrit and CalculationResults.Crits > 0 then
			frame:AddDoubleLine(L["Crits:"], CalculationResults.Crits .. "x ~" .. CalculationResults.PerCrit, rt, gt, bt, r, g, b )
		end
		if CalculationResults.PerHitHeal then
			frame:AddDoubleLine(L["Hits Heal:"], CalculationResults.Hits .. "x ~" .. CalculationResults.PerHitHeal, rt, gt, bt, r, g, b )
		end
		if baseSpell.DotStacks then
			frame:AddDoubleLine(L["Ticks:"] .. " (x" .. baseSpell.DotStacks .. ")", CalculationResults.Hits .. "x ~" .. (CalculationResults.PerHit * baseSpell.DotStacks), rt, gt, bt, r, g, b )
		end
		if CalculationResults.Ticks then
			frame:AddDoubleLine(L["Period:"], CalculationResults.Ticks .. "s", rt, gt, bt, r, g, b )
		end
	end

	if settings.Extra then
		if CalculationResults.DotDmg > 0 then
			frame:AddDoubleLine((healingSpell and L["Hot"] or L["Dot"]) .. ":", CalculationResults.DotDmg, rt, gt, bt, r, g, b )
		end
		if CalculationResults.AoE then
			if CalculationResults.PerTarget then
				frame:AddDoubleLine(L["AoE"] .. ":", CalculationResults.Targets .. "x ~" .. CalculationResults.PerTarget, rt, gt, bt, r, g, b )
			else
				frame:AddDoubleLine(L["AoE"] .. " (" .. CalculationResults.Targets .. "):", CalculationResults.AoE, rt, gt, bt, r, g, b )
			end
		end
	end

	if settings.Total and CalculationResults.AvgTotal ~= CalculationResults.AvgHit then
		frame:AddDoubleLine(L["Avg Total"] .. ":", CalculationResults.AvgTotal, rt, gt, bt, r, g, b )
	end

	if not settings.DefaultColor then
		local c = settings.TooltipTextColor4
		r, g, b = c.r, c.g, c.b
	end

	if CalculationResults.Stats then
		local spA = CalculationResults.NextSP and (CalculationResults.NextSP > 0) and (CalculationResults.AvgTotal * 0.1) / CalculationResults.NextSP
		local apA = CalculationResults.NextAP and (CalculationResults.NextAP > 0) and (CalculationResults.AvgTotal * 0.1) / CalculationResults.NextAP
		local critA = CalculationResults.NextCrit and (CalculationResults.NextCrit > 0) and (CalculationResults.AvgTotal * 0.01 / CalculationResults.NextCrit * self:GetRating("Crit", nil, true ))
		local hasA = CalculationResults.Haste and (self:GetRating("Haste",nil,true) + 0.01 * CalculationResults.Haste)
		local rating = CalculationResults.NextHit and (CalculationResults.NextHit > 0.5) and (baseSpell.MeleeHit and self:GetRating("MeleeHit", nil, true) or self:GetRating("Hit", nil, true))
		local hitA = rating and (CalculationResults.AvgTotal * 0.01 / CalculationResults.NextHit * rating)

		if settings.Next then
			if apA then frame:AddDoubleLine("+10 " .. L["AP"] .. ":", "+" .. CalculationResults.NextAP, rt, gt, bt, r, g, b ) end
			if spA then frame:AddDoubleLine("+10 " .. L["SP"] .. ":", "+" .. CalculationResults.NextSP, rt, gt, bt, r, g, b ) end
			if critA then frame:AddDoubleLine("+1% " .. L["Crit"] .. " (" .. self:GetRating("Crit") .. "):", "+" .. CalculationResults.NextCrit, rt, gt, bt, r, g, b ) end
			if hitA then frame:AddDoubleLine("+1% " .. L["Hit"] .. " (" .. DrD_Round(rating,2).. "):", "+" .. CalculationResults.NextHit, rt, gt, bt, r, g, b ) end
		end
		if settings.CompareStats then
			local text, value
			if spA then
				text = L["SP"]
				value = DrD_Round(spA, 1)
			end
			if apA then
				local apA = DrD_Round(apA,1)
				text = text and (text .. "|" .. L["AP"]) or L["AP"]
				value = value and (value .. "/" .. apA) or apA
			end
			if critA then
				local critA = DrD_Round(critA,1)
				text = text and (text .. "|" .. L["Cr"]) or L["Cr"]
				value = value and (value .. "/" .. critA) or critA
			end
			if hitA then
				local hitA = DrD_Round(hitA, 1)
				text = text and (text .. "|" .. L["Ht"]) or L["Ht"]
				value = value and (value .. "/" .. hitA) or hitA
			end
			if hasA then
				local hasA = DrD_Round(hasA, 1)
				text = text and (text .. "|" .. L["Ha"]) or L["Ha"]
				value = value and (value .. "/" .. hasA) or hasA
			end
			if text then
				frame:AddDoubleLine("+1% " .. (baseSpell.NoNextDPS and L["Damage"] or (spellAbbr .. (CalculationResults.SpamDPS and L["PSC"] or L["PS"]))) .. " (" .. text .. "):", value, rt, gt, bt, r, g, b )
			end
		end
		if settings.CompareSP and spA then
			local text, value = self:CompareTooltip(spA, apA, critA, hitA, hasA, L["SP"], L["AP"], L["Cr"], L["Ht"], L["Ha"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end
		end
		if settings.CompareAP and apA then
			local text, value = self:CompareTooltip(apA, spA, critA, hitA, hasA, L["AP"], L["SP"], L["Cr"], L["Ht"], L["Ha"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end
		end		
		if settings.CompareCrit and critA then
			local text, value = self:CompareTooltip(critA, spA, apA, hitA, hasA, L["Cr"], L["SP"], L["AP"], L["Ht"], L["Ha"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end
		end
		if settings.CompareHit and hitA then
			local text, value = self:CompareTooltip(hitA, spA, apA, critA, hasA, L["Ht"], L["SP"], L["AP"], L["Cr"], L["Ha"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end
		end
		if settings.CompareHaste and hasA then
			local text, value = self:CompareTooltip(hasA, spA, apA, critA, hitA, L["Ha"], L["SP"], L["AP"], L["Cr"], L["Ht"])
			if text then frame:AddDoubleLine(text, value, rt, gt, bt, r, g, b ) end
		end
	end

	if not settings.DefaultColor then
		local c = settings.TooltipTextColor5
		r, g, b = c.r, c.g, c.b
	end

	if settings.DPS and not baseSpell.NoDPS then
		if CalculationResults.DPSC ~= CalculationResults.DPS then
			frame:AddDoubleLine(spellAbbr .. L["PS"] .. "/" .. spellAbbr .. L["PSC"] .. ":", CalculationResults.DPS .. ((CalculationResults.ExtraDPS and ("+" .. CalculationResults.ExtraDPS)) or "") .. "/" .. CalculationResults.DPSC, rt, gt, bt, r, g, b)
		else
			frame:AddDoubleLine(spellAbbr .. L["PS"] .. ":", CalculationResults.DPS .. ((CalculationResults.ExtraDPS and ("+" .. CalculationResults.ExtraDPS)) or "") , rt, gt, bt, r, g, b)
		end
		if CalculationResults.SpamDPS then
			frame:AddDoubleLine(spellAbbr .. L["PS (spam):"], CalculationResults.SpamDPS, rt, gt, bt, r, g, b)
		end
		if CalculationResults.DPSCD and CalculationResults.Cooldown then
			frame:AddDoubleLine(spellAbbr .. L["PS (CD):"], CalculationResults.DPSCD, rt, gt, bt, r, g, b)
		end
	end

	if settings.DPM and CalculationResults.DPM and not CalculationResults.NoCost and not baseSpell.NoDPM then
		frame:AddDoubleLine(spellAbbr .. (CalculationResults.RunicPower or L["PM:"]), CalculationResults.DPM, rt, gt, bt, r, g, b )
		if CalculationResults.SpamDPM and CalculationResults.SpamDPM ~= CalculationResults.DPM then
			frame:AddDoubleLine(spellAbbr .. L["PM (spam):"], CalculationResults.SpamDPM, rt, gt, bt, r, g, b )
		end
	end

	if settings.Doom and CalculationResults.DOOM and not baseSpell.NoDoom then
		frame:AddDoubleLine(spellAbbr .. L["OOM:"], CalculationResults.DOOM, rt, gt, bt, r, g, b )
	end

	if settings.Casts and CalculationResults.castsBase and not baseSpell.NoCasts then
		frame:AddDoubleLine(L["Casts"] .. ((CalculationResults.castsRegen > 0) and ("+" .. L["Regen"] .. ":") or ":"), CalculationResults.castsBase .. ((CalculationResults.castsRegen > 0 and ("+" .. CalculationResults.castsRegen)) or "") .. ((CalculationResults.SOOM and (" (" .. CalculationResults.SOOM .. "s)")) or ""), rt, gt, bt, r, g, b )
	end

	if settings.ManaUsage then
		if CalculationResults.TrueManaCost then
			frame:AddDoubleLine(L["True Mana Cost:"], CalculationResults.TrueManaCost, rt, gt, bt, r, g, b)
		end
		if CalculationResults.MPS and not CalculationResults.NoCost and not baseSpell.NoMPS then
			frame:AddDoubleLine(L["MPS"] .. ":", CalculationResults.MPS, rt, gt, bt, r, g, b)
		end
		if CalculationResults.GCD then
			frame:AddDoubleLine(L["GCD"] .. ":", CalculationResults.GCD .. "s", rt, gt, bt, r, g, b)
		end
	end

	if settings.Hints then
		if not settings.DefaultColor then
			local c = settings.TooltipTextColor6
			r, g, b = c.r, c.g, c.b
		end
		if spellInfo[name]["Secondary"] and not IsShiftKeyDown() then
			frame:AddLine(L["Hold Shift for secondary tooltip"], r, g, b)
		end
		if CalculationResults.Downrank then
			frame:AddLine(L["Low rank penalty applies"] .. " (" .. CalculationResults.Downrank .. "%)", r, g, b)
		end
	end
	frame:Show()
end