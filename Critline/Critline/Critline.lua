local L = LibStub("AceLocale-3.0"):GetLocale("Critline")
local playerGUID, specialAuras, hasSpecialAura, inVehicle
local outOfControl, Critline_MindControlled
local debugging

-- local references to commonly used functions and variables for faster access
local HasPetUI = HasPetUI
local UnitGUID = UnitGUID
local tonumber = tonumber
local CombatLog_Object_IsA = CombatLog_Object_IsA
local bor = bit.bor
local band = bit.band

local COMBATLOG_FILTER_ME = COMBATLOG_FILTER_ME
local COMBATLOG_FILTER_MINE = COMBATLOG_FILTER_MINE
local COMBATLOG_FILTER_MY_PET = COMBATLOG_FILTER_MY_PET
local COMBATLOG_OBJECT_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY
local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local COMBATLOG_OBJECT_TYPE_GUARDIAN = COMBATLOG_OBJECT_TYPE_GUARDIAN


local _, addon = ...

addon.summary = {dmg = "", heal = "", pet = ""}


local addonFrame = CreateFrame("Frame")
addonFrame:RegisterEvent("ADDON_LOADED")
addonFrame:RegisterEvent("PLAYER_LOGIN")
addonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
addonFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
addonFrame:RegisterEvent("UNIT_EXITED_VEHICLE")
addonFrame:RegisterEvent("PLAYER_CONTROL_LOST")
addonFrame:RegisterEvent("PLAYER_CONTROL_GAINED")
addonFrame:RegisterEvent("PLAYER_DEAD")
addonFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
addonFrame:SetScript("OnEvent", function(self, event, ...)
	return addon[event] and addon[event](addon, ...)
end)
addon.core = addonFrame


local splash = CreateFrame("MessageFrame", "CritlineSplashFrame", UIParent)
splash.locked = true
splash:SetFrameStrata("LOW")
splash:SetMovable(true)
splash:RegisterForDrag("LeftButton")
splash:SetPoint("CENTER")
splash:SetSize(512, 96)
splash:SetFontObject("NumberFontNormalHuge")
splash:SetScript("OnUpdate", function(self)
	if not self.locked then
		self:AddMessage(L["Critline splash frame unlocked"], CritlineSettings.spellColor)
		self:AddMessage(L["Drag to move"], CritlineSettings.amountColor)
		self:AddMessage(L["Right-click to lock"], CritlineSettings.amountColor)
	end
end)
splash:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
		self.locked = true
		self:EnableMouse(false)
		self:Clear()
	end
end)
splash:SetScript("OnDragStart", function(self)
	if not self.locked then
		self:StartMoving()
	end
end)
splash:SetScript("OnDragStop", splash.StopMovingOrSizing)

splash.OldAddMessage = splash.AddMessage

function splash:AddMessage(msg, color, ...)
	self:OldAddMessage(msg, color.r, color.g, color.b, ...)
end

addon.splash = splash


local tempClassPets = {
	[510] = true,	-- Water Elemental
	[11859] = true,	-- Doomguard
	[15438] = true,	-- Greater Fire Elemental
	[29264] = true,	-- Spirit Wolf
}


local swingDamage = function(...)
	local amount, _, school, _, _, _, critical = ...
	return MELEE, amount, critical, school
end

local spellDamage = function(...)
	local _, spellName, _, amount, _, school, _, _, _, critical = ...
	return spellName, amount, critical, school
end

local healing = function(...)
	local _, spellName, _, amount, _, _, critical = ...
	return spellName, amount, critical, 0
end


local combatEvents = {
	SWING_DAMAGE = swingDamage,
	RANGE_DAMAGE = spellDamage,
	SPELL_DAMAGE = spellDamage,
	SPELL_PERIODIC_DAMAGE = spellDamage,
	SPELL_HEAL = healing,
	SPELL_PERIODIC_HEAL = healing,
}


local recordSorters = {
	-- alpha: sort by name
	alpha = function(a, b)
		if a.spellName == b.spellName then
			return not a.isPeriodic
		else
			return a.spellName < b.spellName
		end
	end,
	-- crit: sort by crit > normal > name
	crit = function(a, b)
		if (a.crit and a.crit.amount or 0) == (b.crit and b.crit.amount or 0) then
			if (a.normal and a.normal.amount or 0) == (b.normal and b.normal.amount or 0) then
				return a.spellName < b.spellName
			else
				return (a.normal and a.normal.amount or 0) > (b.normal and b.normal.amount or 0)
			end
		else
			return (a.crit and a.crit.amount or 0) > (b.crit and b.crit.amount or 0)
		end
	end,
	-- normal: sort by normal > crit > name
	normal = function(a, b)
		if (a.normal and a.normal.amount or 0) == (b.normal and b.normal.amount or 0) then
			if (a.crit and a.crit.amount or 0) == (b.crit and b.crit.amount or 0) then
				return a.spellName < b.spellName
			else
				return (a.crit and a.crit.amount or 0) > (b.crit and b.crit.amount or 0)
			end
		else
			return (a.normal and a.normal.amount or 0) > (b.normal and b.normal.amount or 0)
		end
	end,
}


-- tooltip for :GetLevelFromGUID()
addon.tooltip = CreateFrame("GameTooltip", "CritlineTooltip", nil, "GameTooltipTemplate")


function addon:Initialize()
	self:Debug("Initializing...")

	CritlineSettings = CritlineSettings or {}
	
	local defaultSettings = {
		-- setting = defaultValue
		firstLoad = true,
		minimapPos = 0,
		tooltipFormat = "",
		
		-- basic options
		dmgRecord = true,
		healRecord = true,
		petRecord = true,
		
		dmgDisplay = true,
		healDisplay = true,
		petDisplay = true,
		
		recordPvE = true,
		recordPvP = true,
		
		showMinimap = true,
		showSplash = true,
		chatOutput = false,
		playSound = true,
		screenshot = false,
		detailedTooltip = false,
		levelAdjust = -1,
		
		-- advanced options
		invertFilter = false,
		suppressMC = false,
		dontFilterMagic = false,
		ignoreMobFilter = false,
		ignoreAuraFilter = false,
		
		oldRecord = false,
		sctSplash = false,
		spellColor = {
			r = 1,
			g = 1,
			b = 0,
		},
		amountColor = {
			r = 1,
			g = 1,
			b = 1,
		},
		summarySort = "crit",
		
		mainScale = 1,
		splashScale = 1,
		splashTimer = 2,
	}
	
	-- remove potentially deprecated options
	for setting in pairs(CritlineSettings) do
		if defaultSettings[setting] == nil then
			CritlineSettings[setting] = nil
		end
	end
	
	-- set current or (if necessary) default values
	for setting, value in pairs(defaultSettings) do
		if CritlineSettings[setting] == nil then
			CritlineSettings[setting] = value
		end
	end
	
	-- records database
	if not CritlineDB then
		CritlineDB = {
			dmg = {},
			heal = {},
			pet = {},
		}
		self:Debug("Database created.")
	end
	
	if not CritlineMobFilter then
		CritlineMobFilter = {}
		self:Debug("Mob filter created.")
	end
	
	self:RebuildAllTooltips()
	self:Debug("Initialization completed.")
end


function addon:SettingsReset()
	wipe(CritlineSettings)
	self:Initialize()
end


function addon:ResetAll()
	wipe(CritlineSettings)
	wipe(CritlineDB)
	-- blank out tooltip text for all trees
	for k in pairs(self.summary) do
		self.summary[k] = ""
	end
	self:Initialize()
end


function addon:ADDON_LOADED(addon)
	if addon == "Critline" then
		self.spellFilter = self.filters.spellFilter.scrollFrame
		specialAuras = self.filters.specialAuras
		self:Initialize()
		self.core:UnregisterEvent("ADDON_LOADED")
	end
end


function addon:PLAYER_LOGIN()
	playerGUID = UnitGUID("player")
	self:Debug("playerGUID: "..playerGUID)
	
	if self.filters:HasSpecialAura() then
		hasSpecialAura = true
		self:Debug("Filtered aura detected. Suppressing record tracking.")
	end
end


function addon:PLAYER_ENTERING_WORLD()
	inVehicle = UnitInVehicle("player")
end


function addon:UNIT_ENTERED_VEHICLE(unit)
	if unit == "player" then
		inVehicle = true
		self:Debug("Entered vehicle. Suppressing record tracking.")
	end
end


function addon:UNIT_EXITED_VEHICLE(unit)
	if unit == "player" then
		inVehicle = false
		self:Debug("Exited vehicle. Resuming record tracking.")
	end
end


function addon:PLAYER_CONTROL_LOST()
	-- this covers fear, taxi, mind control, and others
	outOfControl = true
end


function addon:PLAYER_CONTROL_GAINED()
	outOfControl = false
end


function addon:PLAYER_DEAD()
	hasSpecialAura = self.filters:HasSpecialAura()
end


function addon:COMBAT_LOG_EVENT_UNFILTERED(timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	-- we seem to get events with standard arguments equal to nil, so they need to be ignored
	if not (timestamp and eventType) then
		self:Debug("nil errors on start")
		return
	end

	-- if we don't have a destName (who we hit or healed) and we don't have a sourceName (us or our pets) then we leave
	if not (destName or sourceName) then
		self:Debug("nil source/dest")
		return
	end
	
	if inVehicle then
		-- don't want to track vehicle attacks
		self:Debug("In a vehicle. Return.")
		return
	end
	
	if (outOfControl and CritlineSettings.suppressMC) then
		-- we are suppressing mind control events, time to leave
		self:Debug("Out of control. Return.")
		return
	end
	
	-- check for filtered auras
	if CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME) then
		local spellID = ...
		if specialAuras[spellID] then
			if eventType == "SPELL_AURA_APPLIED" then
				-- if we gain any aura in the filter we can just stop tracking records
				hasSpecialAura = true
				self:Debug("Filtered aura detected. Suppressing record tracking.")
			elseif (eventType == "SPELL_AURA_REMOVED" or eventType == "SPELL_AURA_BROKEN" or eventType == "SPELL_AURA_BROKEN_SPELL" or eventType == "SPELL_AURA_STOLEN") then
				-- if we lost a special aura we have to check if any other filtered auras remain
				if not self.filters:HasSpecialAura() then
					hasSpecialAura = false
					self:Debug("No filtered aura detected. Resuming record tracking.")
				end
			end
			return
		end
	end
	
	if hasSpecialAura and not CritlineSettings.ignoreAuraFilter then
		self:Debug("Filtered aura detected. Return.")
		return
	end
	
	local isPet
	
	-- if sourceGUID is not us or our pet, we leave
	if not CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) then
		local isMyPet = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MY_PET)
		local isGuardian = band(sourceFlags, COMBATLOG_OBJECT_TYPE_GUARDIAN) ~= 0
		-- only register if it's a real pet, or a guardian type pet that's included in the filter
		if isMyPet and ((not isGuardian and HasPetUI()) or tempClassPets[tonumber(sourceGUID:sub(6, 12), 16)]) then
			isPet = true
			-- self:Debug(format("This is my pet (%s)", sourceName))
		else
			-- self:Debug("This is not me, my trap or my pet; return.")
			return
		end
	else
		-- self:Debug(format("This is me or my trap (%s)", sourceName))
	end
	
	if combatEvents[eventType] then
		local isHeal
		local isPeriodic
		if eventType:find("_HEAL$") then
			isHeal = true
			if isPet then
				return
			end
		end
		if eventType:find("_PERIODIC_") then
			isPeriodic = true
		end
		local spellName, amount, critical, school = combatEvents[eventType](...)
		self:HitHandle(destGUID, destName, destFlags, spellName, amount, critical, isHeal, isPet, school, isPeriodic)
	end
end


function addon:HitHandle(destGUID, destName, destFlags, spellName, amount, critical, isHeal, isPet, school, isPeriodic)
	-- below are some checks to see if we want to register the hit at all
	if amount == 0 then
		self:Debug("amount == 0. Return.")
		return
	end
	
	if self.filters:IsMobInFilter(destName, destGUID) then
		return
	end
	
	local isPlayer = band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0
	local friendlyFire = band(destFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 0
	local hostileTarget = band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0
	
	if not (isPlayer or CritlineSettings.recordPvE) then
		self:Debug(format("Target (%s) is an NPC and recordPvE == false. Return.", destName))
		return
	end
	
	if isPlayer and not (isHeal or friendlyFire or CritlineSettings.recordPvP) then
		self:Debug(format("Target (%s) is a player and recordPvP == false. Return.", destName))
		return
	end
	
	-- don't want damage done to friendly units
	if friendlyFire and not isHeal then
		self:Debug(format("Friendly fire (%s). Return.", spellName))
		return
	end
	
	-- nor healing to hostile units
	if hostileTarget and isHeal then
		self:Debug(format("Healing to hostile target (%s). Return.", spellName))
		return
	end

	local targetLevel = self:GetLevelFromGUID(destGUID)
	local levelDiff = 0
	if (targetLevel > 0) and (targetLevel < UnitLevel("player")) then
		levelDiff = (UnitLevel("player") - targetLevel)
	end
	
	-- ignore level adjustment if magic damage and the setting is enabled
	if not isHeal and (CritlineSettings.levelAdjust >= 0) and (CritlineSettings.levelAdjust < levelDiff) and (school == 1 or not CritlineSettings.dontFilterMagic) then
		-- target level is too low to pass level filter
		self:Debug(format("Target (%s) level too low (%d) and damage school is filtered. Return.", destName, targetLevel))
		return
	end
	
	-- we only want damage spells from the pet
	if isHeal and isPet then
		self:Debug("Pet healing. Return.")
		return
	end

	local tree = "dmg"
	
	if isPet then
		tree = "pet"
	elseif isHeal then
		tree = "heal"
	end

	-- exit if not recording type dmg
	if not CritlineSettings[tree.."Record"] then
		self:Debug(format("Not recording this tree (%s). Return.", tree))
		return
	end
	
	local hitType = critical and "crit" or "normal"
	
	local data = self:GetSpellFromDB(tree, spellName, isPeriodic)
	
	-- create spell database entries as required
	if not data then
		self:Debug(format("Creating data for %s (%s)", self:GetFullSpellName(tree, spellName, isPeriodic), tree))
		data = {
			spellName = spellName,
			isPeriodic = isPeriodic,
		}
		tinsert(CritlineDB[tree], data)
		self:SortMainDBTree(tree)
	end
	
	if not data[hitType] then
		-- self:Debug(format("Creating CritlineDB.%s.%s.%s...", tree, spell, hitType))
		data[hitType] = {amount = 0}
	end
	
	data = data[hitType]

	if (data.amount < amount) then
		local oldAmount = data.amount
		data.amount = amount
		data.target = destName
		data.targetLevel = targetLevel
		data.isPvPTarget = isPlayer
		
		self.announce:Update()		-- update announce..
		self.reset:Update()			-- ..reset..
		self.spellFilter:Update()	-- ..and filter list
		
		if self.filters:SpellPassesFilter(tree, spellName, isPeriodic) then
			self:DisplayNewRecord(self:GetFullSpellName(tree, spellName, isPeriodic), amount, critical, oldAmount)
			self:RebuildAllTooltips() --feyde...since Tooltips are now cached, we have to reset them to update the new record data.
		end
	end
end


local red1 = {r = 1, g = 0, b = 0}
local red255 = {r = 255, g = 0, b = 0}

function addon:DisplayNewRecord(spell, amount, crit, oldAmount)
	spell = format(L["New %s record!"], spell)
	if CritlineSettings.oldRecord then
		amount = format("%d (%d)", amount, oldAmount)
	end
	local spellColor = CritlineSettings.spellColor
	local amountColor = CritlineSettings.amountColor
	
	if CritlineSettings.showSplash then
		if CritlineSettings.sctSplash then
			-- check if any custom SCT addon is loaded and use it accordingly
			if MikSBT then
				if crit then
					MikSBT.DisplayMessage(L["Critical!"], nil, true, 255, 0, 0)
				end
				MikSBT.DisplayMessage(spell, nil, true, spellColor.r * 255, spellColor.g * 255, spellColor.b * 255)
				MikSBT.DisplayMessage(amount, nil, true, amountColor.r * 255, amountColor.g * 255, amountColor.b * 255)
			elseif SCT then
				if crit then
					SCT:DisplayMessage(L["Critical!"], red255)
				end
				SCT:DisplayMessage(spell, spellColor)
				SCT:DisplayMessage(amount, amountColor)
			elseif Parrot then
				local Parrot = Parrot:GetModule("Display")
				Parrot:ShowMessage(amount, nil, true, amountColor.r, amountColor.g, amountColor.b)
				Parrot:ShowMessage(spell, nil, true, spellColor.r, spellColor.g, spellColor.b)
				if crit then
					Parrot:ShowMessage(L["Critical!"], nil, true, 1, 0, 0)
				end
			elseif SHOW_COMBAT_TEXT == "1" then
				CombatText_AddMessage(amount, CombatText_StandardScroll, amountColor.r, amountColor.g, amountColor.b)
				CombatText_AddMessage(spell, CombatText_StandardScroll, spellColor.r, spellColor.g, spellColor.b)
				if crit then
					CombatText_AddMessage(L["Critical!"], CombatText_StandardScroll, 1, 0, 0)
				end
			end
		else
			self.splash:Clear()
			if crit then
				self.splash:AddMessage(L["Critical!"], red1)
			end
			self.splash:AddMessage(spell, spellColor)
			self.splash:AddMessage(amount, amountColor)
		end
	end
	
	if CritlineSettings.chatOutput then
		self:Message(format("%s %s %s", spell, amount, crit and L["Critical!"] or ""))
	end
	
	if CritlineSettings.playSound then 
		PlaySound("LEVELUP", 1, 1, 0, 1, 3) 
	end
	
	if CritlineSettings.screenshot then 
		TakeScreenshot() 
	end
end


function addon:GetLevelFromGUID(destGUID)
	self.tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	self.tooltip:SetHyperlink("unit:"..destGUID)
	
	local level = -1
	
	for i = 1, self.tooltip:NumLines() do
		local mytext = _G["CritlineTooltipTextLeft"..i]
		local text = mytext:GetText()
		if text then
			if text:match(LEVEL) then -- our destGUID has the word Level in it.
				level = text:match("(%d+)")  -- find the level
				if level then  -- if we found the level, break from the for loop
					level = tonumber(level)
				else
					-- well, the word Level is in this tooltip, but we could not find the level
					-- either the destGUID is at least 10 levels higher than us, or we just couldn't find it.
					level = -1
				end
			end
		end
	end	
	return level
end


-- return spell table from database, given tree, spell name and isPeriodic value
function addon:GetSpellFromDB(tree, spellName, isPeriodic)
	for i, v in ipairs(CritlineDB[tree]) do
		if v.spellName == spellName and v.isPeriodic == isPeriodic then
			return v, i
		end
	end
end


function addon:GetFullSpellName(tree, spellName, isPeriodic)
	local suffix = ""
	if isPeriodic then
		if tree == "heal" then
			suffix = L[" (HoT)"]
		else
			suffix = L[" (DoT)"]
		end
	end
	return format("%s%s", spellName, suffix)
end


function addon:GetFullTargetName(tree, target, isPvPTarget)
	local suffix = ""
	if isPvPTarget then
		suffix = format(" (%s)", PVP)
	end
	return format("%s%s", target, suffix)
end


-- retrieves the top, non filtered record amounts and spell names for a given tree
function addon:GetHighest(tree)
	local normalRecord, critRecord = 0, 0
	local normalSpell, critSpell
	
	for i, v in ipairs(CritlineDB[tree]) do
		local normal = v.normal
		if normal and normal.amount > normalRecord then
			if self.filters:SpellPassesFilter(tree, v.spellName, v.isPeriodic) then
				normalRecord = normal.amount
				normalSpell = v.spellName
			end
		end
		local crit = v.crit
		if crit and crit.amount > critRecord then
			if self.filters:SpellPassesFilter(tree, v.spellName, v.isPeriodic) then
				critRecord = crit.amount
				critSpell = v.spellName
			end
		end
	end
	return normalRecord, critRecord, normalSpell, critSpell
end


function addon:RebuildAllTooltips()
	for k, v in pairs(self.summary) do
		self.summary[k] = "" -- have to rebuild cached data when a spell is filtered to update tooltips
		self:GetSummaryRichText(k)
	end
	self:DoUpdate()
end


function addon:GetSummaryRichText(tree)
	-- This is for code optimization. We only build the rich summary when a new record is hit.
	-- Then a new record is recorded, the engine will blank out the Critline_Summary[tree]
	-- This causes the tree to be rebuilt when this function is called.
	-- tree is "dmg", "heal" or "pet"
	
	if #self.summary[tree] == 0 then
		self.summary[tree] = self:BuildSummaryRichText(tree)
	end
	return self.summary[tree]
end


local trees = {dmg = "damage", heal = "healing", pet = "pet"}
local sortedSpells = {}

function addon:BuildSummaryRichText(tree)
	local highlight = HIGHLIGHT_FONT_COLOR_CODE
	local green = GREEN_FONT_COLOR_CODE
	local commonFormat = "$sn\n"
	local normalFormat = "   |cffc0c0c0"..L["Normal"]..":|r $na\t$nt ($nl)\n"
	local critFormat = "   |cffc0c0c0"..L["Crit"]..":|r $ca\t$ct ($cl)\n"
	
	-- attempt to dismantle user provided tooltip format
	local tooltipFormat
	if CritlineSettings.tooltipFormat ~= "" then
		tooltipFormat = CritlineSettings.tooltipFormat.."\n"
		tooltipFormat = tooltipFormat:gsub("\\t", "\t")
		tooltipFormat = tooltipFormat:gsub("\\n", "\n")
		commonFormat = ""
		normalFormat = ""
		critFormat = ""
		for line in tooltipFormat:gmatch("[^\n]+") do
			local normalMatch = line:match("$n[atl]")
			local critMatch = line:match("$c[atl]")
			if normalMatch and critMatch then
				commonFormat = commonFormat..line.."\n"
			elseif normalMatch then
				normalFormat = line.."\n"
			elseif critMatch then
				critFormat = line.."\n"
			else
				commonFormat = line.."\n"
			end
		end
	end
	
	-- $sn - Spell name
	
	-- $na - Amount for normal record
	-- $nt - Target name for normal record
	-- $nl - Target level for normal record
	
	-- $ca - Amount for crit record
	-- $ct - Target name for crit record
	-- $cl - Target level for crit record
	
	wipe(sortedSpells)
	
	for _, v in ipairs(CritlineDB[tree]) do
		if (v.normal or v.crit) and self.filters:SpellPassesFilter(tree, v.spellName, v.isPeriodic) then
			tinsert(sortedSpells, {
				spellName = v.spellName,
				isPeriodic = v.isPeriodic,
				normal = v.normal,
				crit = v.crit,
			})
		end
	end
	
	sort(sortedSpells, recordSorters[CritlineSettings.summarySort])

	local rtfAttack = ""
	local normalRecord, critRecord = self:GetHighest(tree)
	
	for _, data in pairs(sortedSpells) do
		local formattedEntry
		local normalStr, normalAmount, normalTarget, normalTargetLevel = normalFormat
		local critStr, critAmount, critTarget, critTargetLevel = critFormat
		local suffix = ""
		
		-- get stored normal data
		local normal = data.normal
		if normal then
			normalAmount = (normal.amount == normalRecord and green or highlight)..normal.amount.."|r"
			normalTarget = highlight..self:GetFullTargetName(tree, normal.target, normal.isPvPTarget).."|r"
			normalTargetLevel = (normal.targetLevel > 0) and normal.targetLevel or "??"
		else
			normalStr = ""
			normalAmount = highlight.."0|r"
		end
		
		-- get stored crit data
		local crit = data.crit
		if crit then
			critAmount = (crit.amount == critRecord and green or highlight)..crit.amount.."|r"
			critTarget = highlight..self:GetFullTargetName(tree, crit.target, crit.isPvPTarget).."|r"
			critTargetLevel = (crit.targetLevel > 0) and crit.targetLevel or "??"
		else
			critStr = ""
			critAmount = "|cff56a3ff0|r"
		end
		
		if CritlineSettings.detailedTooltip then
			formattedEntry = commonFormat..normalStr..critStr
		else
			formattedEntry = "$sn\t$na"..(crit and "/$ca" or "").."\n"
		end
		
		if data.isPeriodic then
			for _, v in ipairs(sortedSpells) do
				if v.spellName == data.spellName and not v.isPeriodic then
					suffix = tree == "heal" and L[" (HoT)"] or L[" (DoT)"]
					break
				end
			end
		end
		
		-- substitute tags with database values
		formattedEntry = formattedEntry:gsub("$sn", format("%s%s", data.spellName, suffix))
		
		formattedEntry = formattedEntry:gsub("$na", normalAmount)
		formattedEntry = formattedEntry:gsub("$nt", normalTarget or "")
		formattedEntry = formattedEntry:gsub("$nl", normalTargetLevel or "")
		
		formattedEntry = formattedEntry:gsub("$ca", critAmount)
		formattedEntry = formattedEntry:gsub("$ct", critTarget or "")
		formattedEntry = formattedEntry:gsub("$cl", critTargetLevel or "")
		
		rtfAttack = rtfAttack..formattedEntry
	end
	
	if #rtfAttack == 0 then
		return "|cffffffffCritline "..trees[tree].."\n"..L["No records"]
	end
	
	return strsub("|cffffffffCritline "..trees[tree].."\n"..rtfAttack, 1, -2)
end


function addon:SortMainDBTree(tree)
	sort(CritlineDB[tree], recordSorters.alpha)
end


CLOU_Handles = {}

function addon:DoUpdate()
	for _, v in pairs(CLOU_Handles) do
		v()
	end
end


function addon:OnUpdateRegister(newhandler)
	tinsert(CLOU_Handles, newhandler)
end


function addon:ToggleDebug()
	debugging = not debugging
	self:Message("Debugging "..(debugging and "enabled" or "disabled"))
end


--[[ misc help functions ]]
function addon:Debug(msg)
	if debugging then
		DEFAULT_CHAT_FRAME:AddMessage("|cff56a3ffCritlineDebug:|r "..msg)
	end
end


function addon:Message(msg)
	if msg then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00Critline:|r "..msg)
	end
end