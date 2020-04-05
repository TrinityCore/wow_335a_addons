local _, playerClass = UnitClass("player")
local playerHealer = (playerClass == "PRIEST") or (playerClass == "SHAMAN") or (playerClass == "PALADIN") or (playerClass == "DRUID")
local playerCaster = (playerClass == "MAGE") or (playerClass == "PRIEST") or (playerClass == "WARLOCK")
local playerMelee = (playerClass == "ROGUE") or (playerClass == "WARRIOR") or (playerClass == "HUNTER")
local playerHybrid = (playerClass == "DEATHKNIGHT") or (playerClass == "DRUID") or (playerClass == "PALADIN") or (playerClass == "SHAMAN")

--Libraries
local L = LibStub("AceLocale-3.0"):GetLocale("DrDamage", true)
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local GT = LibStub:GetLibrary("LibGratuity-3.0")
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)
local DrDamage = DrDamage

--General
local settings
local _G = getfenv(0)
local type = type
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local math_floor = math.floor
local math_min = math.min
local math_max = math.max
local string_match = string.match
local string_format = string.format
local string_find = string.find
local string_sub = string.sub
local string_gsub = string.gsub
local string_len = string.len
local select = select
local next = next

--Module
local GameTooltip = GameTooltip
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local UnitLevel = UnitLevel
local UnitDamage = UnitDamage
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitAttackPower = UnitAttackPower
local UnitIsUnit = UnitIsUnit
local UnitClassification = UnitClassification
local UnitExists = UnitExists
local UnitIsPlayer = UnitIsPlayer
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local GetSpellName = GetSpellName
local GetSpellInfo = GetSpellInfo
local GetMacroSpell = GetMacroSpell
local GetMacroBody = GetMacroBody
local GetActionInfo = GetActionInfo
local GetPetActionInfo = GetPetActionInfo
local GetActionCooldown = GetActionCooldown
local GetSpellCooldown = GetSpellCooldown
local GetCursorInfo = GetCursorInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetItemGem = GetItemGem
local GetTime = GetTime
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local GetTalentInfo = GetTalentInfo
local GetNumTalentTabs = GetNumTalentTabs
local GetNumTalents = GetNumTalents
local GetGlyphSocketInfo = GetGlyphSocketInfo
local GetCombatRatingBonus = GetCombatRatingBonus
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local HasAction = HasAction
local IsEquippedItem = IsEquippedItem
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local SecureButton_GetModifiedAttribute = SecureButton_GetModifiedAttribute
local SecureButton_GetEffectiveButton = SecureButton_GetEffectiveButton
local ActionButton_GetPagedID = ActionButton_GetPagedID
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local GetZonePVPInfo = GetZonePVPInfo

--Module variables
local playerCompatible, playerEvents, DrD_Font, updateSetItems, dmgMod
local spellInfo, talentInfo, talents, PlayerHealth, TargetHealth
local ModStateEvent, ManaCost, PowerCost
local PlayerAura = DrDamage.PlayerAura
local TargetAura = DrDamage.TargetAura

DrDamage.visualChange = true
DrDamage.fullUpdate = false
DrDamage.manaBucket = false

--Local functions
function DrDamage.ClearTable(table)
	for k in pairs( table ) do
		table[k] = nil
	end
end
function DrDamage.Round(x, y)
	local temp = 10 ^ y
	return math_floor( x * temp  + 0.5 ) / temp
end
function DrDamage.MatchData( data, ... )
	if not data or not ... then
		return false
	end

	if type( data ) == "table" then
		for i = 1, select('#', ...) do
			if data[1] then
				for _, dataName in ipairs( data ) do
					for i = 1, select('#', ...) do
						if dataName == select(i, ...) then
							return true
						end
					end
				end
			else
				if data[select(i, ...)] then
					return true
				end
			end
		end
	else
		for i = 1, select('#', ...) do
			if data == select(i, ...) then
				return true
			end
		end
	end

	return false
end
local function DrD_Set(n)
	return function(info, v)
		settings[n] = v
		if not DrDamage.fullUpdate then DrDamage.fullUpdate = DrDamage:ScheduleTimer("UpdateAB", 0.4) end
	end
end
local DrD_ClearTable = DrDamage.ClearTable
local DrD_Round = DrDamage.Round
local DrD_MatchData = DrDamage.MatchData

--Load actionbar function
local ABfunc, ABdisable
local ABtable, ABobjects, ABrefresh = {}, {}, {}
local function DrD_DetermineAB()
	--Default
	for i = 1, 6 do
		for j = 1, 12 do
			table.insert(ABobjects,_G[((select(i,"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"))..j)])
		end
	end
	if playerClass == "SHAMAN" then
		for i = 1, 4 do
			table.insert(ABobjects,_G[("MultiCastActionButton"..i)])
		end
	end
	if playerClass == "WARLOCK" then
		local func = function(button)
			if button then
				local name = GetPetActionInfo(button:GetID())
				if name then
					local _, rank = GetSpellInfo(name)
					return nil, name, rank
				end
			end
		end
		ABrefresh["PetActionButton"] = function()
			for i=1,10 do
				ABtable["PetActionButton"..i] = func
			end
		end
	end
	if playerClass == "PALADIN" then
		local func = function(button)
			if button then
				local _, name = GetShapeshiftFormInfo(button:GetID())
				if name then
					local _, rank = GetSpellInfo(name)
					return nil, name, rank
				end
			end
		end
		ABrefresh["ShapeshiftButton"] = function()
			for i=1,7 do
				ABtable["ShapeshiftButton"..i] = func
			end
		end
	end
	if IsAddOnLoaded("Bartender4") then
		local func = function(button) if button.Secure then return button.Secure:GetActionID() else return button:GetActionID() end end
		ABrefresh["BT4Button"] = function()
			for i=1,120 do
				ABtable["BT4Button"..i] = func
			end
		end
		ABdisable = true
	end
	if nUI_DrDamageIntegration then
		ABrefresh["nUI"] = nUI_DrDamageIntegration( ABtable )
		ABdisable = true
	end
	if IsAddOnLoaded("Nurfed") then
		local func = function(button)
			if button.spell then
				if button.type == "spell" then
					local pid = Nurfed:getspell(button.spell)
					if pid then
						return nil, GetSpellName(pid, BOOKTYPE_SPELL)
					end
				elseif button.type == "macro" then
					local action, rank = GetMacroSpell(button.spell)
					if action then
						return nil, action, rank
					end
				end
			end
		end
		ABrefresh["Nurfed_Button"] = function()
			for i=1,120 do
				ABtable["Nurfed_Button"..i] = func
			end
		end
		ABdisable = true
	end
	if IsAddOnLoaded("Macaroon") then
		local func = function(button)
			if button.config and button.config.type == "action" then
				return SecureButton_GetModifiedAttribute(button,"action",SecureButton_GetEffectiveButton(button))
			end
			if button.macroshow then
				return nil, string_match(button.macroshow,"[^%(]+"), button.macrorank
			end
			if button.macrospell then
				return nil, string_match(button.macrospell,"[^%(]+"), button.macrorank
			end
		end
		ABrefresh["MacaroonButton"] = function()
			for _, button in pairs(Macaroon.Buttons) do
				ABtable[button[1]:GetName()] = func
			end
		end
	end
	if IsAddOnLoaded("Dominos") then
		local func = function(button) return SecureButton_GetModifiedAttribute(button,"action",SecureButton_GetEffectiveButton(button)) end
		ABrefresh["DominosActionButton"] = function()
			for i=1,120 do
				ABtable["DominosActionButton"..i] = func
			end
		end
	end
	if IsAddOnLoaded("IPopBar") then
		local func = function(button) return SecureButton_GetModifiedAttribute(button,"action",SecureButton_GetEffectiveButton(button)) end
		ABrefresh["IPopBarButton"] = function()
			for i=1,120 do
				ABtable["IPopBarButton"..i] = func
			end
		end
	end
	if IsAddOnLoaded("CT_BarMod") then
		--There's an object list available CT_BarMod.actionButtonList, index = actionID, value.hasAction
		local func = function(button) return button.object.id end
		ABrefresh["CT_BarModActionButton"] = function()
			for i=13,120 do
				ABtable["CT_BarModActionButton"..i] = func
			end
		end
	end
	if IsAddOnLoaded("RDX") then
		local func = function(button) return button:GetAttribute("action") end
		ABrefresh["RDX_ActionBars"] = function()
			for i=1,120 do
				ABtable["VFLButton"..i] = func
			end
		end
	end
	if not next(ABrefresh) then
		ABrefresh, ABtable = nil, nil
	end
	DrDamage:RefreshAB()
end

function DrDamage:RefreshAB()
	if ABrefresh then
		for k in pairs(ABtable) do
			ABtable[k] = nil
		end
		for _, func in pairs(ABrefresh) do
			func()
		end
	end
end

--Options table
DrDamage.options = { type='group', args = {} }
--Defaults table
DrDamage.defaults = {
	profile = {
		--Actionbar
		DisplayType = "AvgTotal",
		DisplayType2 = false,
		DisplayType_M = "AvgTotal",
		DisplayType_M2 = false,
		--
		ABText = true,
		DefaultAB = true,
		UpdateShift = false,
		UpdateAlt = false,
		UpdateCtrl = false,
		SwapCalc = false,
		HideAMacro = true,
		HideHotkey = false,
		Font = GameFontNormal:GetFont(),
		FontEffect = "OUTLINE",
		FontSize = 10,
		FontXPosition = 0,
		FontYPosition = 0,
		FontXPosition2 = 0,
		FontYPosition2 = 0,
		FontColorDmg = { r = 1, g = 1, b = 0.2 },
		FontColorHeal = { r = 0.4, g = 1.0, b = 0.3 },
		FontColorMana = { r = 0.4, g = 0.8, b = 1.0 },
		FontColorEnergy = { r = 1.0, g = 1.0, b = 0 },
		FontColorRage = { r = 1.0, g = 0.0, b = 0.0 },
		FontColorCasts1 = { r = 0.4, g = 1.0, b = 0.3 },
		FontColorCasts2 = { r = 1, g = 1, b = 0.2 },
		FontColorCasts3 = { r = 1, g = 0.08, b = 0.08 },
		--Tooltip
		Tooltip = "Always",
		Hints = true,
		PlusDmg = false,
		Coeffs = true,
		DispCrit = true,
		DispHit = true,
		AvgHit = true,
		AvgCrit = true,
		Ticks = true,
		Total = true,
		Extra = true,
		DPS = true,
		DPM = true,
		DPP = true,
		Doom = true,
		Casts = true,
		ManaUsage = false,
		Next = false,
		--Comparisons
		CompareStats = true,
		CompareSP = true,
		CompareAP = true,
		CompareExp = false,
		CompareArp = false,
		CompareHit = false,
		CompareCrit = false,
		CompareHaste = false,
		--Tooltip colors
		DefaultColor = false,
		TooltipTextColor1 = { r = 1.0, g = 1.0, b = 1.0 },
		TooltipTextColor2 = { r = 0.0, g = 0.7, b = 0.0 },
		TooltipTextColor3 = { r = 0.8, g = 0.8, b = 0.9 },
		TooltipTextColor4 = { r = 0.3, g = 0.6, b = 0.5 },
		TooltipTextColor5 = { r = 0.8, g = 0.1, b = 0.1 },
		TooltipTextColor6 = { r = 0.0, g = 1.0, b = 0.0 },
		--Custom Stats
		Custom = false,
		CustomAdd = true,
		SpellDamage = 0,
		AP = 0,
		HitRating = 0,
		CritRating = 0,
		HasteRating = 0,
		ExpertiseRating = 0,
		ArmorPenetrationRating = 0,
		MP5 = 0,
		--Calculation
		HitCalc = true,
		CritDepression = false,
		TwoRoll = true,
		TwoRoll_M = true,
		ManaConsumables = false,
		Dodge = true,
		Parry = false,
		Glancing = true,
		TargetAmount = 1,
		ComboPoints = 0,
		TargetLevel = 3,
		ArmorCalc = "Auto",
		Armor = 0,
		Resilience = 0,
		--Buffs
		PlayerAura = {},
		TargetAura = {},
		Consumables = {},
	}
}

function DrDamage:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("DrDamageDB", self.defaults)
	settings = self.db.profile
	AC:RegisterOptionsTable("DrDamage", self.options)
	self:RegisterChatCommand("drd", function() self:OpenConfig() end)
	self:RegisterChatCommand("drdmg", function() self:OpenConfig() end)
	self:RegisterChatCommand("drdamage", function() self:OpenConfig() end)
	local LDB = LibStub:GetLibrary("LibDataBroker-1.1", true)
	if LDB then
		LDB:NewDataObject("DrDamage", {
			type = "launcher",
			icon = "Interface\\Icons\\Spell_Holy_SearingLightPriest",
			OnClick = function(clickedframe, button)
				self:OpenConfig()
			end,
		})
	end
end

function DrDamage:OnEnable()
	if self.PlayerData then
		self.ClassSpecials = {}
		self.DmgCalculation = {}
		self.SetBonuses = {}
		self.RelicSlot = {}
		self.talents = {}
		self:PlayerData()
		self.PlayerData = nil
		PlayerHealth = self.PlayerHealth
		TargetHealth = self.TargetHealth
		spellInfo = self.spellInfo
		talentInfo = self.talentInfo
		talents = self.talents
		self:CommonData()
		self.CommonData = nil
	elseif not self.spellInfo and not self.talentInfo then
		return
	end

	self:RefreshConfig()
  	self:RegisterEvent("PLAYER_ENTERING_WORLD", function() self:UnregisterEvent("PLAYER_ENTERING_WORLD"); self:ScheduleTimer("Load", 3) end)
end

function DrDamage:OnDisable()
	if playerCompatible then
		local tempType = settings.ABText
		settings.ABText = false
		self:UpdateAB()
		settings.ABText = tempType
	end
end

local AuraIterate
function DrDamage:Load()
	if self.GeneralOptions then
		self:GeneralOptions()
		self.GeneralOptions = nil
	end
	if self.Caster_OnEnable then
		self:Caster_OnEnable()
		self.Caster_OnEnable = nil
	end
	if self.Melee_OnEnable then
		self:Melee_OnEnable()
		self.Melee_OnEnable = nil
	end
	if DrD_DetermineAB then
		DrD_DetermineAB()
		DrD_DetermineAB = nil
	end
	if not playerCompatible then
		--Make talent spell tables better suited for iteration
		for k in pairs( talentInfo ) do
			local talent = talentInfo[k]
			for i=1,#talent do
				local spelltable = talent[i].Spells
				if type(spelltable) == "table" then
					for j,v in ipairs( spelltable ) do
						spelltable[v] = true
						spelltable[j] = nil
					end
				end
			end
		end
		--Make buff spell tables better suited for iteration
		for _, v in pairs( PlayerAura ) do
			local spells = v.Spells
			if spells then
				if type(spells) == "table" then
					for i=1,#spells do
						spells[GetSpellInfo(spells[i])] = true
						spells[i] = nil
					end
				else
					v.Spells = GetSpellInfo(spells)
				end
			end
		end
		for _, v in pairs( TargetAura ) do
			local spells = v.Spells
			if spells then
				 if type(spells) == "table" then
					for i=1,#spells do
						spells[GetSpellInfo(spells[i])] = true
						spells[i] = nil
					end
				else
					v.Spells = GetSpellInfo(spells)
				end
			end
		end
		--Create talent and buff tables
		for name, spell in pairs( spellInfo ) do
			if spell[0] and type(spell[0]) ~= "function" then
				spell["Talents"] = {}
				spell["PlayerAura"] = {}
				spell["TargetAura"] = {}
				spell["Consumables"] = {}
				AuraIterate(name, spell, spell["PlayerAura"], PlayerAura)
				AuraIterate(name, spell, spell["TargetAura"], TargetAura)
				AuraIterate(name, spell, spell["Consumables"], self.Consumables)
				if spell["Secondary"] then
					spell = spell["Secondary"]
					spell["Talents"] = {}
					spell["PlayerAura"] = {}
					spell["TargetAura"] = {}
					spell["Consumables"] = {}
					AuraIterate(name, spell, spell["PlayerAura"], PlayerAura)
					AuraIterate(name, spell, spell["TargetAura"], TargetAura)
					AuraIterate(name, spell, spell["Consumables"], self.Consumables)
				end
			end
		end
		AuraIterate = nil
	end
	
	--A few options checks
	if (settings.Font ~= self.defaults.profile.Font) and not CreateFrame("Frame"):CreateFontString("DrDamage-Font"):SetFont(settings.Font,10) then
		settings.Font = GameFontNormal:GetFont()
	end
	if settings.TargetLevel > 3 or settings.TargetLevel < 0 then
		settings.TargetLevel = 3
	end
	local nocaster = (not settings.DisplayType and not settings.DisplayType2)
	local nomelee = (not settings.DisplayType_M and not settings.DisplayType_M2)
	if playerCaster and nocaster or playerMelee and nomelee or playerHybrid and nocaster and nomelee then
		settings.ABText = false
	end
	if LSM then
		LSM.RegisterCallback(self, "LibSharedMedia_Registered", function(event, media)
			if media == "font" then
				self.options.args.General.args.Actionbar.args.Font.values = LSM:HashTable("font")
			end
		end)
		LSM.RegisterCallback(self, "LibSharedMedia_SetGlobal", function(event, media, key)
			if media == "font" then
				DrD_Font = LSM:Fetch("font")
				self.visualChange = true
				self:UpdateAB()
			end
		end)
	end		
	ManaCost = (settings.DisplayType2 == "ManaCost")
	PowerCost = (settings.DisplayType_M2 == "PowerCost")
	DrD_Font = DrD_Font or settings.Font
	
	--Run startup functions
	self:ZONE_CHANGED_NEW_AREA()
	self:MetaGems()
	self:UpdateGlyphs()
	self:UpdateTalents()
	playerCompatible = true

	--Apply hooks and register events
	self:SecureHook(GameTooltip, "SetAction")
	self:SecureHook(GameTooltip, "SetSpell")
	self:SecureHook(GameTooltip, "SetTrainerService", "SetShapeshift" )
	if playerClass == "PALADIN" then
		self:SecureHook(GameTooltip, "SetShapeshift")
	end
	if playerClass == "WARLOCK" then
		self:SecureHook(GameTooltip, "SetPetAction", "SetShapeshift")
	end	

  	self:RegisterEvent("CHARACTER_POINTS_CHANGED","UPDATE_TALENTS")
  	self:RegisterEvent("PLAYER_TALENT_UPDATE","UPDATE_TALENTS")
	self:RegisterEvent("GLYPH_ADDED", "UpdateGlyphs")
	self:RegisterEvent("GLYPH_UPDATED", "UpdateGlyphs")
	self:RegisterEvent("GLYPH_REMOVED", "UpdateGlyphs")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig", true)
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig", true)
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig", true, true)
	
	if settings.ABText then
		self:TextEvents()
	end
end

function DrDamage:TextEvents()
	if not playerEvents then
		if settings.UpdateAlt or settings.UpdateCtrl or settings.UpdateShift then
			self:RegisterEvent( "MODIFIER_STATE_CHANGED" )
			ModStateEvent = true
		end
		if PlayerHealth or TargetHealth then
			self:RegisterBucketEvent("UNIT_HEALTH", 2.5)
		end
		if (playerClass == "SHAMAN" or playerClass == "WARLOCK" or playerClass == "ROGUE" or playerClass == "DEATHKNIGHT") then
			self:RegisterBucketEvent("UNIT_INVENTORY_CHANGED", 1.5)
		end
		if (playerClass == "SHAMAN") then
			self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
		end
		if (playerClass == "WARLOCK") then
			self:RegisterEvent("PET_BAR_HIDEGRID", "ACTIONBAR_HIDEGRID", true)
			--Lash of Pain, Shadow bite, Firebolt
			local spells = { [GetSpellInfo(7814)] = true, [GetSpellInfo(54049)] = true, [GetSpellInfo(3110)] = true, }
			self:RegisterEvent("PET_SPELL_POWER_UPDATE", "UpdateAB", spells)
		end
		if playerClass == "DRUID" or playerClass == "ROGUE" then
			self:RegisterEvent("UNIT_COMBO_POINTS")
		end
		if playerClass == "WARRIOR" then
			self:RegisterBucketEvent("UNIT_RAGE", 2)
		end
		if playerClass == "DRUID" then
			self:RegisterBucketEvent("UNIT_ENERGY", 2)
		end
		if playerClass == "HUNTER" then
			self:RegisterBucketEvent("UNIT_RANGEDDAMAGE", 1)
		end		
		self:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
		self:RegisterEvent("ACTIONBAR_HIDEGRID")
		self:RegisterEvent("EXECUTE_CHAT_LINE")
		self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("UPDATE_MACROS")
		self:RegisterEvent("LEARNED_SPELL_IN_TAB")
		self:RegisterEvent("UNIT_AURA")
		playerEvents = true
	end
end

function DrDamage:RefreshConfig(cb, reset)
	if self.Caster_RefreshConfig then self:Caster_RefreshConfig() end
	if self.Melee_RefreshConfig then self:Melee_RefreshConfig() end
	settings = self.db.profile
	if reset then
		DrD_Font = DrDamage.defaults.profile.Font
	end
	if cb then
		ManaCost = (settings.DisplayType2 == "ManaCost")
		PowerCost = (settings.DisplayType_M2 == "PowerCost")
		self.visualChange = true
		self:UpdateAB()
	end
end

function DrDamage:OpenConfig()
	InterfaceOptionsFrame:Hide()
	ACD:SetDefaultSize("DrDamage", 850, 705)
	ACD:Open("DrDamage")
	ACD:SelectGroup("DrDamage", "General", "Actionbar")
end

function DrDamage:CommonData()
	if select(2, UnitRace("player")) == "Draenei" then
		if playerClass == "PALADIN" or playerClass == "PRIEST" or playerClass == "SHAMAN" or playerClass == "MAGE" or playerClass == "DEATHKNIGHT" then
			--Gift of the Naaru
			spellInfo[GetSpellInfo(28880)] = {
						["Name"] = "Gift of the Naaru",
						[0] = { School = { "Holy", "Healing" }, Cooldown = 180, SPBonus = 1.88, eDot = true, eDuration = 15, sTicks = 3, NoSchoolTalents = true },
						[1] = { 35, 35, },
			}
			self.Calculation["Gift of the Naaru"] = function( calculation )
				local b, p, n = UnitAttackPower("player")
				local ap = b + p + n
				if ap > calculation.spellDmg then
					calculation.spellDmg = ap
					calculation.spellDmgM = 1.1
				end
				calculation.minDam = calculation.minDam + calculation.playerLevel * 15
				calculation.maxDam = calculation.minDam
			end
		elseif playerClass == "WARRIOR" or playerClass == "HUNTER" then
			self.ClassSpecials[GetSpellInfo(28880)] = function()
				local amount = 35 + UnitLevel("player") * 15 + 1.1 * self:GetAP()
				return amount, true
			end
		end
	end
	if select(2, UnitRace("player")) == "BloodElf" then
		if playerClass == "PALADIN" or playerClass == "PRIEST" or playerClass == "MAGE" or playerClass == "HUNTER" or playerClass == "WARLOCK" then
			--Arcane Torrent
			self.ClassSpecials[GetSpellInfo(28730)] = function()
				return 0.06 * UnitPowerMax("player",0), false, true
			end
		end
	end
	--Lifeblood
	if not playerMelee then
			spellInfo[GetSpellInfo(55428)] = {
						["Name"] = "Lifeblood",
						[0] = { School = { "Nature", "Healing" }, Cooldown = 180, SPBonus = 0, eDot = true, eDuration = 5, sTicks = 1, SelfHeal = true, NoSchoolTalents = true, NoDPM = true, NoCasts = true },
						[1] = { 300, 300, },
						[2] = { 480, 480, },
						[3] = { 720, 720, },
						[4] = { 900, 900, },
						[5] = { 1200, 1200, },
						[6] = { 3600, 3600, },
			}
			self.Calculation["Lifeblood"] = function( calculation, _, Talents )
				calculation.minDam = calculation.minDam + 0.016 * UnitHealthMax("player")
				calculation.maxDam = calculation.minDam
				if Talents["Lifeblood Bonus"] then
					if playerClass == "DRUID" and GetShapeshiftForm() ~= 3 then return end
					calculation.dmgM = calculation.dmgM * (1 + Talents["Lifeblood Bonus"])
				end
			end
	else
		self.ClassSpecials[GetSpellInfo(55428)] = function(rank)
			local base = select(rank or 6, 300, 480, 720, 900, 1200, 3600) + 0.016 * UnitHealthMax("player")
			local mult = 1
			if playerClass == "ROGUE" then
				--Quick Recovery
				mult = mult * (1 + select((self.talents[GetSpellInfo(31244)] or 3),0.1,0.2,0))
			end
			return (mult * base), true
		end
	end
end

function DrDamage:GeneralOptions()
	self.options.args.General = {
		type = 'group',
		name = "DrDamage",
		order = 1,
		args = {
			Actionbar = {
				type = 'group',
				name = L["Actionbar"],
				desc = L["Actionbar options."],
				order = 50,
				args = {
					DisplayType = {
						type = 'select',
						name = "1. " .. (playerHybrid and L["Spells"] or ""),
						desc = L["Choose what to display on the actionbar."],
						order = 1,
						hidden = playerMelee,
						values =  {
							["Avg"] = L["Average"],
							["AvgHit"] = L["Average Hit"],
							["AvgHitTotal"] = L["Average Hit + Extra"],
							["AvgTotal"] = L["Average Total"],
							["MinHit"] = L["Min Hit"],
							["MaxHit"] = L["Max Hit"],
							["AvgCrit"] = L["Average Crit"],
							["MinCrit"] = L["Min Crit"],
							["MaxCrit"] = L["Max Crit"],
							["MaxTotal"] = L["Max Total"],
							["DPS"] = L["DPS"],
							["DPSC"] = L["DPSC"],
							["DPSCD"] = L["DPSCD"],
							["DPM"] = L["DPM"],
							["MPS"] = L["MPS"],
							["CastTime"] = L["Cast Time"],
							["1"] = L["Disabled"],							
						},
						get = function() return settings["DisplayType"] or "1" end,
						set = function(info, v)
								if v == "1" then 
									settings["DisplayType"] = false
								else 
									settings["DisplayType"] = v 
									if not settings.ABText then
										settings.ABText = true
										self:TextEvents()
									end
								end
								self:UpdateAB()
						end,
					},
					DisplayType2 = {
						type = 'select',
						name = "2. " .. (playerHybrid and L["Spells"] or ""),
						desc = L["Choose what to display on the actionbar."],
						order = 2,
						hidden = playerMelee,
						values =  {
							["Avg"] = L["Average"],
							["AvgHit"] = L["Average Hit"],
							["AvgHitTotal"] = L["Average Hit + Extra"],
							["AvgTotal"] = L["Average Total"],
							["MinHit"] = L["Min Hit"],
							["MaxHit"] = L["Max Hit"],
							["AvgCrit"] = L["Average Crit"],
							["MinCrit"] = L["Min Crit"],
							["MaxCrit"] = L["Max Crit"],
							["MaxTotal"] = L["Max Total"],
							["DPS"] = L["DPS"],
							["DPSC"] = L["DPSC"],
							["DPSCD"] = L["DPSCD"],
							["DPM"] = L["DPM"],
							["MPS"] = L["MPS"],
							["CastTime"] = L["Cast Time"],
							["ManaCost"] = L["Mana Cost"],
							["Casts"] = L["Casts"],
							["1"] = L["Disabled"],
						},
						get = function() return settings["DisplayType2"] or "1" end,
						set = function(info, v)
								if v == "Casts" then
									if not self.manaBucket then
										self.manaBucket = self:RegisterBucketEvent("UNIT_MANA", 2)
									end
								else
									if self.manaBucket then
										self:UnregisterBucket(self.manaBucket)
										self.manaBucket = nil
									end
								end
								if v == "1" then 
									settings["DisplayType2"] = false
								else 
									settings["DisplayType2"] = v
									if not settings.ABText then
										settings.ABText = true
										self:TextEvents()
									end								
								end
								ManaCost = (v == "ManaCost")
								self:UpdateAB()
						end,
					},
					NewLine1 = {
						type= 'description',
						order = 3,
						name= '',
					},
					DisplayType_M = {
						type = 'select',
						name = "1. " .. (playerHybrid and (L["Melee"] .. "/" .. L["Ranged"]) or ""),
						desc = L["Choose what to display on the actionbar."],
						order = 4,
						hidden = playerCaster,
						values =  {
							["Avg"] = L["Average"],
							["AvgTotal"] = L["Average Total"],
							["AvgHit"] = L["Average Hit"],
							["AvgHitTotal"] = L["Average Hit + Extra"],
							["MinHit"] = L["Min Hit"],
							["MaxHit"] = L["Max Hit"],
							["MaxTotal"] = L["Max Total"],
							["AvgCrit"] = L["Average Crit"],
							["MinCrit"] = L["Min Crit"],
							["MaxCrit"] = L["Max Crit"],
							["DPM"] = (playerClass == "ROGUE" and L["DPE"] or playerClass == "WARRIOR" and L["DPR"] or playerClass == "DRUID" and L["DPP"] or L["DPM"]),
							["1"] = L["Disabled"],
						},
						get =  function() return settings["DisplayType_M"] or "1" end,
						set =  function(info,v) 
							if v == "1" then 
								settings["DisplayType_M"] = false
							else 
								settings["DisplayType_M"] = v
								if not settings.ABText then
									settings.ABText = true
									self:TextEvents()
								end								
							end 
							self:UpdateAB() 
						end,
					},
					DisplayType_M2 = {
						type = 'select',
						name = "2. " .. (playerHybrid and (L["Melee"] .. "/" .. L["Ranged"]) or ""),
						desc = L["Choose what to display on the actionbar."],
						order = 5,
						hidden = playerCaster,
						values =  {
							["Avg"] = L["Average"],
							["AvgTotal"] = L["Average Total"],
							["AvgHit"] = L["Average Hit"],
							["AvgHitTotal"] = L["Average Hit + Extra"],
							["MinHit"] = L["Min Hit"],
							["MaxHit"] = L["Max Hit"],
							["MaxTotal"] = L["Max Total"],
							["AvgCrit"] = L["Average Crit"],
							["MinCrit"] = L["Min Crit"],
							["MaxCrit"] = L["Max Crit"],
							["DPM"] = (playerClass == "ROGUE" and L["DPE"] or playerClass == "WARRIOR" and L["DPR"] or playerClass == "DRUID" and L["DPP"] or L["DPM"]),
							["DPS"] = L["DPS"],
							["DPSCD"] = L["DPSCD"],
							["PowerCost"] = L["Power Cost"],
							["1"] = L["Disabled"],
						},
						get =  function() return settings["DisplayType_M2"] or "1" end,
						set =  function(info,v)
							if v == "1" then
								settings["DisplayType_M2"] = false
							else
								settings["DisplayType_M2"] = v
								if not settings.ABText then
									settings.ABText = true
									self:TextEvents()
								end								
							end
							PowerCost = (v == "PowerCost")
							self:UpdateAB()
						end,
					},
					Update = {
						type = 'multiselect',
						name = L["Actionbar"],
						order = 22,
						width = 'full',
						values = {
								["ABText"] = L["Actionbar text on/off"],
								["DefaultAB"] =	L["Default actionbar support"],
								["SwapCalc"] = L["Swap calculation for double purpose abilities"],
								["UpdateShift"] = L["Update the actionbar with shift key"],
								["UpdateAlt"] = L["Update the actionbar with alt key"],
								["UpdateCtrl"] = L["Update the actionbar with ctrl key"],
								["HideAMacro"] = L["Hide macro name text"],
								["HideHotkey"] = L["Hide hotkey text"],
							},
						get = function(v, k) return settings[k] end,
						set = function(info, k, v)
							if (k == "UpdateShift") or (k == "UpdateAlt") or (k == "UpdateCtrl") then
								settings[k] = v
								if v and not ModStateEvent then
									self:RegisterEvent("MODIFIER_STATE_CHANGED")
									ModStateEvent = true
								elseif ModStateEvent and not settings.UpdateAlt and not settings.UpdateCtrl and not settings.UpdateShift then
									self:UnregisterEvent("MODIFIER_STATE_CHANGED")
									ModStateEvent = false
								end
							else
								if (k == "DefaultAB") then
									if v then
										settings.DefaultAB = true
										self:UpdateAB()
									else
										self:UpdateAB(nil, nil, true)
										settings.DefaultAB = false
									end
								else
									settings[k] = v
									self:UpdateAB()
									if (k == "ABText") and v and not playerEvents then
										self:TextEvents()
									end									
								end
							end

						end,
					},
					FontXPosition = {
						type = 'range',
						name =  "1. " .. L["Text X Position"],
						min = -20,
						max = 20,
						step = 1,
						order = 31,
						get =  function() return settings["FontXPosition"] end,
						set = function(i, v)
							settings["FontXPosition"] = v
							self.visualChange = true
							self:UpdateAB()
						end,
					},
					FontYPosition = {
						type = 'range',
						name = "1. " ..L["Text Y Position"],
						min = -40,
						max = 40,
						step = 1,
						order = 32,
						get =  function() return settings["FontYPosition"] end,
						set = function(i, v)
							settings["FontYPosition"] = v
							self.visualChange = true
							self:UpdateAB()
						end,
					},
					NewLine2 = {
						type= 'description',
						order = 33,
						name= '',
					},
					FontXPosition2 = {
						type = 'range',
						name = "2. " .. L["Text X Position"],
						min = -20,
						max = 20,
						step = 1,
						order = 36,
						disabled = function() return not (settings.DisplayType2 or settings.DisplayType_M2) end,
						get =  function() return settings["FontXPosition2"] end,
						set = function(i, v)
							settings["FontXPosition2"] = v
							self.visualChange = true
							self:UpdateAB()
						end,
					},
					FontYPosition2 = {
						type = 'range',
						name = "2. " .. L["Text Y Position"],
						min = -40,
						max = 40,
						step = 1,
						order = 37,
						disabled = function() return not (settings.DisplayType2 or settings.DisplayType_M2) end,
						get =  function() return settings["FontYPosition2"] end,
						set = function(i, v)
							settings["FontYPosition2"] = v
							self.visualChange = true
							self:UpdateAB()
						end,
					},
					NewLine3 = {
						type= 'description',
						order = 38,
						name= '',
					},
					FontSize = {
						type = 'range',
						name = L["Font Size"],
						min = 4,
						max = 24,
						step = 1,
						order = 60,
						get =  function() return settings["FontSize"] end,
						set = function(i, v)
							settings["FontSize"] = v
							self.visualChange = true
							self:UpdateAB()
						end,
					},
					UpdateAB = {
						type = 'execute',
						name = L["Update Actionbar"],
						desc = L["Forces an update to the actionbar."],
						order = 61,
						func = function() self.visualChange = true; self:UpdateAB() end,
					},
					NewLine4 = {
						type= 'description',
						order = 62,
						name= '',
					},
					FontEffect = {
						type = 'select',
						name = L["Font Effect"],
						values = { ["OUTLINE"] = L["Outline"], ["THICKOUTLINE"] = L["ThickOutline"], [""] = L["None"] },
						order = 65,
						get =	function() return settings["FontEffect"] end,
						set = 	function(i, v)
							settings["FontEffect"] = v
							self.visualChange = true
							self:UpdateAB()
						end,
					},
					TextTitle = {
						type = 'header',
						name = L["Text color"],
						order = 67,
					},
					FontColorDmg = {
						type = 'color',
						name = L["Damage text color"],
						order = 70,
						get = function() return settings.FontColorDmg.r, settings.FontColorDmg.g, settings.FontColorDmg.b end,
						set = function(info,rr,gg,bb)
							settings.FontColorDmg.r = rr
							settings.FontColorDmg.g = gg
							settings.FontColorDmg.b = bb
							self:UpdateAB()
						end,
					},
					FontColorHeal = {
						type = 'color',
						name = L["Heal text color"],
						order =75,
						get = function() return settings.FontColorHeal.r, settings.FontColorHeal.g, settings.FontColorHeal.b end,
						set = function(info,rr,gg,bb)
							settings.FontColorHeal.r = rr
							settings.FontColorHeal.g = gg
							settings.FontColorHeal.b = bb
							self:UpdateAB()
						end,
					},
					NewLine5 = {
						type= 'description',
						order = 76,
						name= '',
						hidden = (playerClass ~= "DRUID")
					},
					FontColorMana = {
						type = 'color',
						name = L["Mana text color"],
						order = 80,
						hidden = (playerMelee or playerClass == "DEATHKNIGHT") and playerClass ~= "HUNTER",
						get = function() return settings.FontColorMana.r, settings.FontColorMana.g, settings.FontColorMana.b end,
						set = function(info,rr,gg,bb)
							settings.FontColorMana.r = rr
							settings.FontColorMana.g = gg
							settings.FontColorMana.b = bb
							self:UpdateAB()
						end,
					},
					FontColorRage = {
						type = 'color',
						name = L["Rage text color"],
						order = 82,
						hidden = (playerClass ~= "DRUID" and playerClass ~= "WARRIOR"),
						get = function() return settings.FontColorRage.r, settings.FontColorRage.g, settings.FontColorRage.b end,
						set = function(info,rr,gg,bb)
							settings.FontColorRage.r = rr
							settings.FontColorRage.g = gg
							settings.FontColorRage.b = bb
							self:UpdateAB()
						end,
					},
					FontColorEnergy = {
						type = 'color',
						name = L["Energy text color"],
						order = 83,
						hidden = (playerClass ~= "DRUID" and playerClass ~= "ROGUE"),
						get = function() return settings.FontColorEnergy.r, settings.FontColorEnergy.g, settings.FontColorEnergy.b end,
						set = function(info,rr,gg,bb)
							settings.FontColorEnergy.r = rr
							settings.FontColorEnergy.g = gg
							settings.FontColorEnergy.b = bb
							self:UpdateAB()
						end,
					},
					NewLine6 = {
						type= 'description',
						order = 84,
						name= '',
						hidden = (playerClass == "DRUID")
					},
					FontColorCasts1 = {
						type = 'color',
						name = L["Casts text color"] .. " 1",
						order = 85,
						hidden = playerMelee or playerClass == "DEATHKNIGHT",
						get = function() return settings.FontColorCasts1.r, settings.FontColorCasts1.g, settings.FontColorCasts1.b end,
						set = function(info,rr,gg,bb)
							settings.FontColorCasts1.r = rr
							settings.FontColorCasts1.g = gg
							settings.FontColorCasts1.b = bb
							self:UpdateAB()
						end,
					},
					FontColorCasts2 = {
						type = 'color',
						name = L["Casts text color"] .. " 2",
						order = 90,
						hidden = playerMelee or playerClass == "DEATHKNIGHT",
						get = function() return settings.FontColorCasts2.r, settings.FontColorCasts2.g, settings.FontColorCasts2.b end,
						set = function(info,rr,gg,bb)
							settings.FontColorCasts2.r = rr
							settings.FontColorCasts2.g = gg
							settings.FontColorCasts2.b = bb
							self:UpdateAB()
						end,
					},
					FontColorCasts3 = {
						type = 'color',
						name = L["Casts text color"] .. " 3",
						order = 95,
						hidden = playerMelee or playerClass == "DEATHKNIGHT",
						get = function() return settings.FontColorCasts3.r, settings.FontColorCasts3.g, settings.FontColorCasts3.b end,
						set = function(info,rr,gg,bb)
							settings.FontColorCasts3.r = rr
							settings.FontColorCasts3.g = gg
							settings.FontColorCasts3.b = bb
							self:UpdateAB()
						end,
					},
				},
			},
			Tooltip = {
				type = 'group',
				name = L["Tooltip"],
				desc = L["Tooltip options."],
				order = 55,
				args = {
					DisplayTooltip = {
						type = 'select',
						name = L["Display tooltip"] ,
						values = {
							["Always"] = L["Always"],
							["Never"] = L["Never"],
							["Combat"] = L["Disable in combat"],
							["Alt"] = L["With Alt"],
							["Ctrl"] = L["With Ctrl"],
							["Shift"]= L["With Shift"]
						},
						order = 5,
						get = function() return settings.Tooltip end,
						set = function(info, k, v)
							settings.Tooltip = k
						end,
					},
					Hints = {
						type = 'toggle',
						name = L["Display tooltip hints"],
						order = 10,
						width = 'full',
						get = function() return settings["Hints"] end,
						set = function(i, v) self:ClearTooltip(); settings["Hints"] = v end,
					},
					Tooltip = {
						type = 'multiselect',
						name = L["Display"],
						order = 15,
						values = {
							["Coeffs"] = L["Show coefficients"],
							["DispCrit"]= L["Show crit %"],
							["DispHit"] = L["Show hit %"],
							["AvgHit"] = L["Show avg and hit range"],
							["AvgCrit"] = L["Show avg crit and crit range"],
							["Ticks"] = L["Show per tick"],
							["Total"] = L["Show avg total"],
							["Extra"] = L["Show additional effects"],
							["Next"] = L["Show stat increase values"],
							["DPS"] = L["Show DPS/HPS"],
							["CompareStats"] = L["Show stats for 1% increase"],
						},
						get = function(v, k) return settings[k] end,
						set = function(info, k, v) self:ClearTooltip(); settings[k] = v end,
					},
					Compare = {
						type = 'multiselect',
						name = L["Compare stats"],
						desc = L["Compare the selected stat to other stats in the tooltip."],
						order = 20,
						values = {
							["CompareCrit"] = L["Critical strike rating"],
							["CompareHit"] = L["Hit rating"],
						},
						get = function(v, k) return settings[k] end,
						set = function(info, k, v) self:ClearTooltip(); settings[k] = v end,
					},
					TooltipTextTitle = {
						type = 'header',
						name = L["Tooltip text color"],
						order = 20,
					},
					DefaultColor = {
						type = 'toggle',
						name = L["Default tooltip colors"],
						order = 25,
						width = 'full',
						get = function() return settings["DefaultColor"] end,
						set = function(i, v) self:ClearTooltip(); settings["DefaultColor"] = v end,
					},
					TooltipTextColor1 = {
						type = 'color',
						name = L["Tooltip text color"] .. " 1",
						order = 65,
						get = function() return settings.TooltipTextColor1.r, settings.TooltipTextColor1.g, settings.TooltipTextColor1.b end,
						set = function(info,rr,gg,bb)
							self:ClearTooltip()
							settings.TooltipTextColor1.r = rr
							settings.TooltipTextColor1.g = gg
							settings.TooltipTextColor1.b = bb
						end,
					},
					TooltipTextColor2 = {
						type = 'color',
						name = L["Tooltip text color"] .. " 2",
						order = 70,
						get = function() return settings.TooltipTextColor2.r, settings.TooltipTextColor2.g, settings.TooltipTextColor2.b end,
						set = function(info,rr,gg,bb)
							self:ClearTooltip()
							settings.TooltipTextColor2.r = rr
							settings.TooltipTextColor2.g = gg
							settings.TooltipTextColor2.b = bb
						end,
					},
					TooltipTextColor3 = {
						type = 'color',
						name = L["Tooltip text color"] .. " 3",
						order = 75,
						get = function() return settings.TooltipTextColor3.r, settings.TooltipTextColor3.g, settings.TooltipTextColor3.b end,
						set = function(info,rr,gg,bb)
							self:ClearTooltip()
							settings.TooltipTextColor3.r = rr
							settings.TooltipTextColor3.g = gg
							settings.TooltipTextColor3.b = bb
						end,
					},
					TooltipTextColor4 = {
						type = 'color',
						name = L["Tooltip text color"] .. " 4",
						order = 80,
						get = function() return settings.TooltipTextColor4.r, settings.TooltipTextColor4.g, settings.TooltipTextColor4.b end,
						set = function(info,rr,gg,bb)
							self:ClearTooltip()
							settings.TooltipTextColor4.r = rr
							settings.TooltipTextColor4.g = gg
							settings.TooltipTextColor4.b = bb
						end,
					},
					TooltipTextColor5 = {
						type = 'color',
						name = L["Tooltip text color"] .. " 5",
						order = 85,
						get = function() return settings.TooltipTextColor5.r, settings.TooltipTextColor5.g, settings.TooltipTextColor5.b end,
						set = function(info,rr,gg,bb)
							self:ClearTooltip()
							settings.TooltipTextColor5.r = rr
							settings.TooltipTextColor5.g = gg
							settings.TooltipTextColor5.b = bb
						end,
					},
					TooltipTextColor6 = {
						type = 'color',
						name = L["Tooltip text color"] .. " 6",
						order = 90,
						get = function() return settings.TooltipTextColor6.r, settings.TooltipTextColor6.g, settings.TooltipTextColor6.b end,
						set = function(info,rr,gg,bb)
							self:ClearTooltip()
							settings.TooltipTextColor6.r = rr
							settings.TooltipTextColor6.g = gg
							settings.TooltipTextColor6.b = bb
						end,
					},
				},

			},
			Calculation = {
				type = 'group',
				name = L["Calculation"],
				desc = L["Calculation options."],
				order = 60,
				args = {
					General = {
						type = 'multiselect',
						name = L["Calculation"],
						width = 'full',
						values = {
							["HitCalc"] = L["Hit calculation"],
						},
						order = 10,
						get = function(v, k) return settings[k] end,
						set = function(info, k, v)
							settings[k] = v
							self:UpdateAB()
						end,
					},
					TargetAmount = {
						type = 'range',
						name = L["Amount of targets"],
						desc = L["Select the maximum amount of targets for your AoE abilities."],
						min = 1,
						max = 10,
						step = 1,
						order = 45,
						get = function() return settings["TargetAmount"] end,
						set = function(info, v) settings["TargetAmount"] = v; self:UpdateAB() end,
					},
					ComboPoints = {
						type = 'range',
						name = L["Combo points"],
						desc = L["Manually set the amount of calculated combo points. When 0 is selected, the calculation is based on the current amount."],
						min = 0,
						max = 5,
						step = 1,
						order = 50,
						hidden = (playerClass ~= "ROGUE" and playerClass ~= "DRUID"),
						get = function() return settings["ComboPoints"] end,
						set = function(info,v) settings["ComboPoints"] = v; self:UpdateAB() end,
					},
					MitigationTitle = {
						type = 'header',
						name = L["Target mitigation calculation"],
						order = 55,
					},
					TargetLevel = {
						type = 'select',
						name = L["Target level"],
						desc = L["Target level compared to your level. Set as 3 for boss calculation."],
						values = {
							[0] = L["Current Target"],
							[1] = "+1",
							[2] = "+2",
							[3] = "+3",
						},
						order = 60,
						get = function() return settings["TargetLevel"] end,
						set = function(info, v) settings["TargetLevel"] = v; self:UpdateAB() end,
					},
					ArmorCalc = {
						type = 'select',
						name = L["Armor calculation"],
						values = {
							["Auto"] = L["Automatic"] .. "/" .. L["Manual"],
							["Boss"] = L["Boss"],
							["Manual"] = L["Manual"],
							["None"] = L["None"],
						},
						order = 65,
						hidden = playerCaster,
						get = function() return settings["ArmorCalc"] end,
						set = function(info, v) settings["ArmorCalc"] = v; self:UpdateAB() end,
					},
					NewLine1 = {
						type= 'description',
						order = 70,
						name= '',
					},
					Armor = {
						type = 'range',
						name = L["Target armor"],
						desc = L["Estimated target armor for non-boss enemies. Compare to tooltip numbers for desired mitigation."],
						min = 0,
						max = 50000,
						step = 1,
						order = 75,
						hidden = playerCaster,
						get = function() return settings["Armor"] end,
						set = function(info,v) settings["Armor"] = v; self:UpdateAB() end,
					},
					Resilience = {
						type = 'range',
						name = L["Target resilience"],
						desc = L["Input your target's resilience."],
						min = 0,
						max = 1500,
						step = 1,
						order = 80,
						get = function() return settings["Resilience"] end,
						set = function(info,v) settings["Resilience"] = v; self:UpdateAB() end,
					},
				},
			},
			Custom = {
				type = 'group',
				name = L["Modify Stats"],
				--desc = "",
				order = 95,
				args = {
					Custom = {
						type = 'toggle',
						name = L["Use custom stats"],
						desc = L["Manually set stats are used in calculations."],
						descStyle = 'inline',
						order = 50,
						width = 'full',
						get = function() return settings["Custom"] end,
						set = function(info, v) settings["Custom"] = v; self:UpdateAB() end,
					},
					CustomAdd = {
						type = 'toggle',
						name = L["Add custom stats"],
						desc = L["Manually set stats are added to your stats in calculations."],
						descStyle = 'inline',
						order = 55,
						width = 'full',
						get = function() return settings["CustomAdd"] end,
						set = function(info, v) settings["CustomAdd"] = v; self:UpdateAB() end,
					},
					SpellPower = {
						type = 'range',
						name = L["Spell power"],
						desc = L["Input spell power to use in calculations."],
						min = -20000,
						max = 20000,
						step = 1,
						order = 105,
						hidden = playerMelee or (playerClass == "DEATHKNIGHT"),
						get = function() return settings["SpellDamage"] end,
						set = DrD_Set("SpellDamage"),
					},
					AP = {
						type = 'range',
						name = L["AP"] .. " / " .. L["RAP"],
						desc = L["Input attack power to use in calculations."],
						min = -20000,
						max = 20000,
						step = 1,
						order = 106,
						hidden = playerCaster,
						get = function() return settings["AP"] end,
						set = DrD_Set("AP"),
					},
					CritRating = {
						type = 'range',
						name = L["Critical strike rating"],
						desc = L["Input critical strike rating to use in calculations."],
						min = -2000,
						max = 2000,
						step = 1,
						order = 110,
						get = function() return settings["CritRating"] end,
						set = DrD_Set("CritRating"),
					},
					HitRating = {
						type = 'range',
						name = L["Hit rating"],
						desc = L["Input hit rating to use in calculations."],
						min = -1500,
						max = 1500,
						step = 1,
						order = 115,
						get = function() return settings["HitRating"] end,
						set = DrD_Set("HitRating"),
					},
					HasteRating = {
						type = 'range',
						name = L["Haste rating"],
						desc = L["Input haste rating to use in calculations."],
						min = -5000,
						max = 5000,
						step = 1,
						order = 120,
						get = function() return settings["HasteRating"] end,
						set = DrD_Set("HasteRating"),
					},
					ManaPer5 = {
						type = 'range',
						name = L["Mana per 5"],
						desc = L["Input MP5 to use in calculations."],
						min = -5000,
						max = 5000,
						step = 1,
						order = 125,
						hidden = playerMelee or (playerClass == "DEATHKNIGHT"),
						get = function() return settings["MP5"] end,
						set = DrD_Set("MP5"),
					},
					ExpertiseRating = {
						type = 'range',
						name = L["Expertise rating"],
						desc = L["Input expertise rating to use in calculations."],
						min = -500,
						max = 500,
						step = 1,
						order = 130,
						hidden = playerCaster,
						get = function() return settings["ExpertiseRating"] end,
						set = DrD_Set("ExpertiseRating"),
					},
					ArmorPenetrationRating = {
						type = 'range',
						name = L["Armor penetration rating"],
						desc = L["Input armor penetration rating to use in calculations."],
						min = -1400,
						max = 1400,
						step = 1,
						order = 135,
						hidden = playerCaster,
						get = function() return settings["ArmorPenetrationRating"] end,
						set = DrD_Set("ArmorPenetrationRating"),
					},
				},
			},
			Aura = {
				type = 'group',
				name = L["Modify Buffs/Debuffs"],
				desc = L["Choose what buffs/debuffs to always include into calculations."],
				order = 100,
				args = {
					Player = {
						type = 'multiselect',
						name = L["Player"],
						desc = L["Choose player buffs/debuffs."],
						order = 1,
						values = {},
						get = function(v, k) return settings["PlayerAura"][k] end,
						set = function(info, k, v)
							local cat = PlayerAura[k].Category
							if v and cat then
								for n in pairs( settings["PlayerAura"] ) do
									local ocat = PlayerAura[n].Category
									if ocat and (cat == ocat) then
										settings["PlayerAura"][n] = nil
									end
								end
							end
							settings["PlayerAura"][k] = v or nil
							self:UpdateAB()
						end,
					},
					Target = {
						type = 'multiselect',
						name = L["Target"],
						desc = L["Choose target buffs/debuffs."],
						values = {},
						order = 3,
						get = function(v, k) return settings["TargetAura"][k] end,
						set = function(info, k, v)
							local cat = TargetAura[k].Category
							if v and cat then
								for n in pairs( settings["TargetAura"] ) do
									local ocat = TargetAura[n].Category
									if ocat and (cat == ocat) then
										settings["TargetAura"][n] = nil
									end
								end
							end
							settings["TargetAura"][k] = v or nil
							self:UpdateAB()
						end,
					},
					Consumables = {
						type = 'multiselect',
						name = L["Consumables"],
						desc = L["Choose consumables to include."],
						values = {},
						order = 2,
						get = function(v, k) return settings["Consumables"][k] end,
						set = function(info, k, v)
							local cat = self.Consumables[k].Category
							local cat2 = self.Consumables[k].Category2
							if v and cat then
								for n in pairs( settings.Consumables ) do
									local ocat = self.Consumables[n].Category
									local ocat2 = self.Consumables[n].Category2
									if ocat and (cat == ocat or cat2 and cat2 == ocat or ocat2 and (cat == ocat2 or cat2 and ocat2 == cat2)) then
										settings.Consumables[n] = nil
									end
								end
							end
							settings["Consumables"][k] = v or nil
							self:UpdateAB()
						end,
					},
				},
			},
			Talents = {
				type = "group",
				name = L["Modify Talents"],
				desc = L["Modify talents manually. Modified talents are not saved between sessions."],
				order = 150,
				args = {
					Reset = {
						type = "execute",
						name = L["Reset Talents"],
						desc = L["Reset talents to your current talent configuration."],
						order = 0,
						--disabled = function() return self.CustomTalents end,
						func = function() self:UpdateTalents() end,
					},
					Remove = {
						type = "execute",
						name = L["Remove Talents"],
						desc = L["Removes all talents from your current configuration."],
						order = 1,
						--disabled = function() return self.CustomTalents end,
						func = function()
							DrD_ClearTable(talents)
							self:UpdateTalents(true)
						end,
					},
				} ,
			},
			Reset = {
				type = 'group',
				name = L["Reset Options"],
				order = 200,
				args = {
					Reset = {
						type = 'execute',
						name = L["Reset Options"],
						confirm = true,
						order = 2,
						func = function() self.db:ResetProfile() end,
					},
				},
			},
		},
	}
	local optionsTable = self.options.args.General.args
	if playerCaster or playerHybrid then
		local tree = optionsTable.Calculation.args.General.values
		tree["TwoRoll"] = L["Two roll calculation"] .. " (" .. L["Spells"] .. ")"
		if playerClass ~= "DEATHKNIGHT" then
			tree["ManaConsumables"] = L["Include mana consumables"]
			tree = optionsTable.Tooltip.args.Tooltip.values
			tree["DPM"] = L["Show DPM/HPM"]
			tree["Doom"] = L["Show damage/healing until OOM"]
			tree["Casts"] = L["Show total casts and time until OOM"]
			tree["PlusDmg"] = L["Show efficient spellpower"]
			tree["ManaUsage"] = L["Show additional mana usage information"]			
			tree = optionsTable.Tooltip.args.Compare.values
			tree["CompareSP"] = L["Spell power"]
			tree["CompareHaste"] = L["Haste rating"]
		else
			local types = optionsTable.Actionbar.args.DisplayType_M.values
			types["DPM"] = nil
			types = optionsTable.Actionbar.args.DisplayType_M2.values
			types["DPM"] = nil
			types = optionsTable.Actionbar.args.DisplayType.values
			types["DPM"] = nil
			types["MPS"] = nil
			types["CastTime"] = nil
			types = optionsTable.Actionbar.args.DisplayType2.values
			types["DPM"] = nil
			types["MPS"] = nil
			types["CastTime"] = nil
			types["ManaCost"] = nil
			types["Casts"] = nil	
		end
		if playerHybrid then
			if playerClass ~= "DRUID" then
				optionsTable.Actionbar.args.DisplayType_M2.values["PowerCost"] = nil
			end
		end
	end
	if playerMelee or playerHybrid then
		local tree = optionsTable.Tooltip.args.Tooltip.values
		tree["DPP"] = L["Show damage per power"]
		tree = optionsTable.Tooltip.args.Compare.values
		tree["CompareArp"] = L["Armor penetration rating"]
		tree["CompareExp"] = L["Expertise rating"]
		tree["CompareAP"] = (playerClass == "HUNTER") and (L["AP"] .. "/" .. L["RAP"]) or L["AP"]		
		tree = optionsTable.Calculation.args.General.values
		tree["CritDepression"] = L["Crit depression calculation"] .. " (" .. L["Melee"] .. "/" .. L["Ranged"] .. ")"
		tree["Dodge"] = L["Dodge calculation"]
		tree["Parry"] = L["Parry calculation"]
		tree["Glancing"] = L["Glancing blow calculation"]
		tree["TwoRoll_M"] = L["Two roll calculation"] .. " (" .. L["Melee"] .. "/" .. L["Ranged"] .. ")"
	end
	if LSM then
		optionsTable.Actionbar.args.Font = {
			type = 'select',
			name = L["Font"],
			desc = L["Font"],
			values = LSM:HashTable("font"),
			order = 66,
			get =  function()
				if LSM:GetGlobal("font") then
					return LSM:GetGlobal("font")
				end
				for k, v in pairs(LSM:HashTable("font")) do
					if settings["Font"] == v then
						return k
					end
				end
			end,
			set = function(info, v, k)
				if not LSM:GetGlobal("font") then
					settings.Font = LSM:Fetch("font",v)
					DrD_Font = settings.Font
					self.visualChange = true
					self:UpdateAB()
				end
			end,
		}
		if AceGUISharedMediaWidgets then
			optionsTable.Actionbar.args.Font.dialogControl = 'LSM30_Font'
		end
		if LSM:GetGlobal("font") then
			DrD_Font = LSM:Fetch("font")
		end

	end
	local auraTable = optionsTable.Aura.args.Player.values
	local double = {}
	for k,v in pairs( PlayerAura ) do
		if not v.Update and not v.NoManual then
			local manual = v.Manual
			if not manual or not double[manual] then
				if v.ID then
					auraTable[k] = "|T" .. select(3,GetSpellInfo(v.ID)) .. ":17:17:-2:0|t" .. (manual or k)
				else
					auraTable[k] = manual or k
				end
				double[(manual or k)] = true
			else
				settings["PlayerAura"][k] = nil
			end
		else
			settings["PlayerAura"][k] = nil
		end
	end
	auraTable = optionsTable.Aura.args.Target.values
	double = {}
	for k,v in pairs( TargetAura ) do
		if not v.Update and not v.NoManual then
			local manual = v.Manual
			if not manual or not double[manual] then
				if v.ID then
					auraTable[k] = "|T" .. select(3,GetSpellInfo(v.ID)) .. ":17:17:-2:0|t" .. (manual or k)
				else
					auraTable[k] = manual or k
				end
				double[(manual or k)] = true
			else
				settings["TargetAura"][k] = nil
			end
		else
			settings["TargetAura"][k] = nil
		end
	end
	auraTable = optionsTable.Aura.args.Consumables.values
	for k,v in pairs( self.Consumables ) do
		if v.Category == "Food" then
			auraTable[k] = "|TInterface\\Icons\\Spell_Misc_Food:17:17:-2:0|t" .. k
		elseif v.ID then
			auraTable[k] = "|T" .. select(3,GetSpellInfo(v.ID)) .. ":17:17:-2:0|t" .. k
		elseif select(10,GetItemInfo(k)) then
			auraTable[k] = "|T" .. select(10,GetItemInfo(k)) .. ":17:17:-2:0|t" .. k
		else
			auraTable[k] = k
		end
	end
	local talentTable = optionsTable.Talents.args
	for t = 1, GetNumTalentTabs() do
		for i = 1, GetNumTalents(t) do
			local talentName, icon, _, _, _, maxRank = GetTalentInfo(t, i)
			if talentInfo[talentName] and not talentInfo[talentName].NoManual then
				talentTable[(string_gsub(talentName," +", ""))] = {
					type = 'range',
					name = "|T" .. icon .. ":20:20:-5:0|t" .. talentName,
					--disabled = function() return self.CustomTalents end,
					min = 0,
					max = maxRank,
					step = 1,
					order = 3 + i + (t-1) * 50,
					get = 	function() return talents[talentName] or 0 end,
					set = 	function(info, v)
							local value = math_floor(v+0.5)
							if value == 0 then value = nil end
							talents[talentName] = value
							self:UpdateTalents(true)
						end,
				}
			end
		end
		talentTable[("Tab" .. t)] = {
			type = 'header',
			name = --[["|T" .. select(2,GetTalentTabInfo(t)) .. ":30:30:-7:0|t" ..--]] GetTalentTabInfo(t),
			order = 2 + (t-1) * 49,
		}
	end
	AC:RegisterOptionsTable("DrDamage-Main", {
		type = 'group',
		name = "DrDamage",
		args = {
			Config = {
				type = "execute",
				name = L["Standalone Config"],
				func = self.OpenConfig,
			}
		}
	})
	AC:RegisterOptionsTable("DrDamage-Actionbar", optionsTable.Actionbar)
	AC:RegisterOptionsTable("DrDamage-Tooltip", optionsTable.Tooltip)
	AC:RegisterOptionsTable("DrDamage-Calculation", optionsTable.Calculation)
	AC:RegisterOptionsTable("DrDamage-Custom", optionsTable.Custom)
	AC:RegisterOptionsTable("DrDamage-Aura", optionsTable.Aura)
	AC:RegisterOptionsTable("DrDamage-Talents", optionsTable.Talents)
	AC:RegisterOptionsTable("DrDamage-Reset", optionsTable.Reset)
	ACD:AddToBlizOptions("DrDamage-Main", "DrDamage")
	ACD:AddToBlizOptions("DrDamage-Actionbar", optionsTable.Actionbar.name, "DrDamage")
	ACD:AddToBlizOptions("DrDamage-Tooltip", optionsTable.Tooltip.name, "DrDamage")
	ACD:AddToBlizOptions("DrDamage-Calculation", optionsTable.Calculation.name, "DrDamage")
	ACD:AddToBlizOptions("DrDamage-Custom", optionsTable.Custom.name, "DrDamage")
	ACD:AddToBlizOptions("DrDamage-Aura", optionsTable.Aura.name, "DrDamage")
	ACD:AddToBlizOptions("DrDamage-Talents", optionsTable.Talents.name, "DrDamage")
	ACD:AddToBlizOptions("DrDamage-Reset", optionsTable.Reset.name, "DrDamage")
end

--EVENTS:
--Event for weapon buff (poisons, spellstones etc) updates
local mbuff, obuff
function DrDamage:UNIT_INVENTORY_CHANGED(units)
	if units["player"] then
		local buff = self:GetWeaponBuff()
		local buff2 = self:GetWeaponBuff(true)
		if buff ~= mbuff or buff2 ~= obuff then
			mbuff = buff
			obuff = buff2
			self:CancelTimer(self.fullUpdate, true)
			self:UpdateAB()
		end
	end
end

DrDamage.healingMod = 1
function DrDamage:ZONE_CHANGED_NEW_AREA(event)
	local _, instance = IsInInstance()
	local old = self.healingMod
	if instance == "pvp" or instance == "arena" or GetZonePVPInfo() == "combat" then
		self.healingMod = 0.9
	else
		self.healingMod = 1
	end
	if event and (self.healingMod ~= old) then
		if not self.fullUpdate then
			self:UpdateAB()
		end
	end
end

--REQUIRES DELAY:
function DrDamage:ACTIONBAR_PAGE_CHANGED()
	if not self.fullUpdate then
		self.fullUpdate = self:ScheduleTimer("UpdateAB", 0.15)
	end
end

--Triggers after an ability is placed on the actionbar
function DrDamage:ACTIONBAR_HIDEGRID(update)
	if not self.fullUpdate and (update or (GetCursorInfo() == "spell" or GetCursorInfo() == "macro")) then
		self.fullUpdate = self:ScheduleTimer("UpdateAB", 0.15)
	end
end

--Shapeshift and update for certain auras (like Shadowform)
function DrDamage:UPDATE_SHAPESHIFT_FORM()
	if not self.fullUpdate then
		self.fullUpdate = self:ScheduleTimer("UpdateAB", 1)
	end
end

--Castsequence macro update triggers
local MacroTimer, Trigger
local shaman = (playerClass == "SHAMAN")
function DrDamage:MacroTrigger()
	Trigger = nil
	if not shaman then
		self:UnregisterEvent("ACTIONBAR_SLOT_CHANGED")
	end
end
function DrDamage:EXECUTE_CHAT_LINE()
	self:CancelTimer(MacroTimer, true)
	Trigger = true
	MacroTimer = self:ScheduleTimer("MacroTrigger", 0.5)
	if not shaman then
		self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
	end
end
function DrDamage:ACTIONBAR_SLOT_CHANGED(_, id)
	if Trigger then
		local gtype, pid = GetActionInfo(id)
		if gtype == "macro" then
			local name = GetMacroSpell(pid)
			if name and spellInfo[name] then
				if not self.fullUpdate then
					self:ScheduleTimer("UpdateAB", 0.5, nil, id)
					Trigger = nil
				end
			end
		end
	elseif shaman and (id == 133 or id == 134 or id == 135 or id == 136) then
		if not self.fullUpdate then
			self.fullUpdate = self:ScheduleTimer("UpdateAB", 0.25, nil, id)
		end
	end
end

--DELAYED EVENTS FOR INCREASED PERFORMANCE

--Main-hand, Off-hand, Ranged slot and meta gem updates
DrDamage.Damage_critMBonus = 0
DrDamage.Healing_critMBonus = 0
local MetaGemTimer
function DrDamage:PLAYER_EQUIPMENT_CHANGED(event, slot)
	updateSetItems = true
	if self.Melee_InventoryChanged then
		self:Melee_InventoryChanged((slot == 16), (slot == 17), (slot == 18))
	end
	if not MetaGemTimer then
		MetaGemTimer = self:ScheduleTimer("MetaGems", 0.20)
	end
	if not self.fullUpdate then
		self.fullUpdate = self:ScheduleTimer("UpdateAB", 0.3)
	end
end
function DrDamage:MetaGems()
	MetaGemTimer = nil
	self.Damage_critMBonus = 0
	self.Healing_critMBonus = 0
	self.MetaGem_BlockBonus = 0
	local helm = GetInventoryItemLink("player", 1)
	if helm then
		for i = 1, 3 do
			local mgem = tonumber(string_match(select(2, GetItemGem(helm, i)) or "",".-item:(%d+).*"))
			if mgem == 34220 or mgem == 41285 or mgem == 32409 or mgem == 41398 then
				if not self:IsMetaGemInactive() then
					self.Damage_critMBonus = 0.03
				end
				break
			elseif mgem == 41376 then
				if not self:IsMetaGemInactive() then
					self.Healing_critMBonus = 0.03
				end
				break
			elseif mgem == 41396 or mgem == 35501 then
				if not self:IsMetaGemInactive() then
					self.MetaGem_BlockBonus = 0.05
				end
			end
		end
	end
end

--Event for checking if the meta gem is greyed out in the head slot tooltip
function DrDamage:IsMetaGemInactive()
	if GT:SetInventoryItem("player", 1) then
		for j = 1, GT:NumLines() do
			if GT:GetLine(j) and string_find(GT:GetLine(j), "|cff808080.*808080") then
				return true
			end
		end
	end
end

--Event for skills and talents that update on certain health percentages
local pHealth, tHealth = 1, 1
function DrDamage:UNIT_HEALTH(units)
	if PlayerHealth and units["player"] then
		local value = PlayerHealth[1]
		local health = UnitHealth("player")/UnitHealthMax("player")
		if (health < value) ~= (pHealth < value) then
			self:UpdateAB(PlayerHealth[value])
		end
		pHealth = health
	end
	if units["target"] then
		local health = UnitHealth("target")/UnitHealthMax("target")
		for i=1,#TargetHealth do
			local value = tonumber(TargetHealth[i]) or UnitHealth("player")/UnitHealthMax("player")
			if (health < value) ~= (tHealth < value) then
				if TargetHealth[value] then
					self:UpdateAB(TargetHealth[value])
				else
					self:UpdateAB()
					tHealth = health
					return
				end
			end
		end
		tHealth = health
	end
end

function DrDamage:PLAYER_TARGET_CHANGED()
	if not self.fullUpdate then
		self.fullUpdate = self:ScheduleTimer("UpdateAB", 0.5)
	end
	self:TargetAuraUpdate(true)
	tHealth = TargetHealth and (UnitHealth("target")/UnitHealthMax("target"))
end

--Triggers after macros are updated
function DrDamage:UPDATE_MACROS()
	if not self.fullUpdate then
		self.fullUpdate = self:ScheduleTimer("UpdateAB", 0.75)
	end
end

--Triggers when new ranks of spells are learned
function DrDamage:LEARNED_SPELL_IN_TAB()
	if not self.fullUpdate then
		self.fullUpdate = self:ScheduleTimer("UpdateAB", 1.5)
	end
end

local PlayerAuraTimer, TargetAuraTimer
function DrDamage:UNIT_AURA(event, unit)
	if unit == "player" then
		if not PlayerAuraTimer then
			PlayerAuraTimer = self:ScheduleTimer("PlayerAuraUpdate", 0.75)
		end
	elseif unit == "target" then
		if not TargetAuraTimer then
			TargetAuraTimer = self:ScheduleTimer("TargetAuraUpdate", 1.5)
		end
	end
end

local oPlayerAura, nPlayerAura = {}, {}
local oTargetAura, nTargetAura = {}, {}

function DrDamage:PlayerAuraUpdate()
	PlayerAuraTimer = nil
	if self.fullUpdate then
		return
	end
	if dmgMod ~= select(7, UnitDamage("player")) then
		self:UpdateAB()
		return
	end
	if self.Caster_CheckBaseStats and self:Caster_CheckBaseStats() then
		self:UpdateAB()
		return
	end
	if self.Melee_CheckBaseStats and self:Melee_CheckBaseStats() then
		self:UpdateAB()
		return
	end
	--[[ Enable if ever needed
	if self.Calculation["PlayerAura"] then
		local update, spell = self.Calculation["PlayerAura"]
		if update then
			return self:UpdateAB(spell)
		end
	end
	--]]
	for i=1,40 do
		local name, rank, texture, count = UnitBuff("player",i)
		if name then
			if PlayerAura[name] then
				nPlayerAura[name] = rank .. count
			end
		else
			break
		end
	end
	for i=1,40 do
		local name, rank, texture, count = UnitDebuff("player",i)
		if name then
			if PlayerAura[name] then
				nPlayerAura[name] = rank .. count
			end
		else
			break
		end
	end
	local buffName, multi
	--Buff/debuff gained or count/rank changed
	for k,v in pairs(nPlayerAura) do
		if not oPlayerAura[k] or oPlayerAura[k] ~= v then
			multi = buffName
			buffName = k
		end
	end
	--Buff/debuff lost
	for k,v in pairs(oPlayerAura) do
		if not nPlayerAura[k] then
			multi = buffName
			buffName = k
		end
		oPlayerAura[k] = nil
	end
	--Copy new table to old and clear
	for k,v in pairs(nPlayerAura) do
		oPlayerAura[k] = v
		nPlayerAura[k] = nil
	end
	if buffName then
		self:UpdateAB(not multi and PlayerAura[buffName].Spells)
	end
end

function DrDamage:TargetAuraUpdate( changed )
	TargetAuraTimer = nil
	if self.fullUpdate and not changed then
		return
	end
	if self.Calculation["TargetAura"] then
		local update, spell = self.Calculation["TargetAura"]()
		if update and not changed then
			return self:UpdateAB(spell)
		end
	end
	if playerHealer then
		for i=1,40 do
			local name, rank, texture, count, _, _, _, unit = UnitBuff("target",i)
			if name then
				if TargetAura[name] then
					if unit and TargetAura[name].SelfCastBuff then
						if UnitIsUnit("player",unit) then
							nTargetAura[name] = rank .. count
						end
					else
						nTargetAura[name] = rank .. count
						--nTargetAura[name.."|"..texture] = rank .. count
					end
				end
			else break end
		end
	end
	for i=1,40 do
		local name, rank, texture, count, _, _, _, unit = UnitDebuff("target",i)
		if name then
			if TargetAura[name] then
				if unit and TargetAura[name].SelfCast then
					if UnitIsUnit("player",unit) then
						nTargetAura[name] = rank .. count
					end
				else
					nTargetAura[name] = rank .. count
					--nTargetAura[name.."|"..texture] = rank .. count
				end
			end
		else break end
	end
	local buffName, multi
	--Buff/debuff gained or count/rank changed
	for k,v in pairs(nTargetAura) do
		if not oTargetAura[k] or oTargetAura[k] ~= v then
			multi = buffName
			buffName = k
			--buffName = string_match(k,"[^|]+")
		end
	end
	--Buff/debuff lost
	for k,v in pairs(oTargetAura) do
		if not nTargetAura[k] then
			multi = buffName
			buffName = k
			--buffName = string_match(k,"[^|]+")
		end
		oTargetAura[k] = nil
	end
	--Copy new table to old and clear
	for k,v in pairs(nTargetAura) do
		oTargetAura[k] = v
		nTargetAura[k] = nil
	end
	if TargetAura[buffName] and not changed then
		self:UpdateAB(not multi and TargetAura[buffName].Spells)
	end
end

--Event for actionbar modifier key updates
local lastState = GetTime()
local ModTimer
function DrDamage:MODIFIER_STATE_CHANGED(event, state)
	if (state == "LALT" or state == "RALT") and settings.UpdateAlt or (state == "LCTRL" or state == "RCTRL") and settings.UpdateCtrl or (state == "LSHIFT" or state == "RSHIFT") and settings.UpdateShift then
		if GetTime() - lastState < 0.3 then
			self:CancelTimer(ModTimer, true)
			ModTimer = false
		else
			ModTimer = self:ScheduleTimer("UpdateAB", 0.3)
		end
		lastState = GetTime()
	end
end

--Talent updates
local TalentTimer, TalentIterate
function DrDamage:UPDATE_TALENTS()
	if not TalentTimer then
		TalentTimer = self:ScheduleTimer("UpdateTalents", 1)
	end
end
function DrDamage:UpdateTalents(manual, all)
	TalentTimer = nil
	if not manual and not self.CustomTalents then
		DrD_ClearTable( talents )
		for t = 1, GetNumTalentTabs() do
			for i = 1, GetNumTalents(t) do
				local talentName, _, _, _, currRank, maxRank = GetTalentInfo(t, i)
				if (currRank ~= 0 or all) and talentInfo[talentName] then
					talents[talentName] = all and maxRank or currRank
				end
			end
		end
	end
	--Load talents into appropriate spell data
	for _, spell in pairs( spellInfo ) do
		TalentIterate( spell["Name"], spell[0], spell["Talents"] )
		if spell["Secondary"] then
			TalentIterate( spell["Secondary"]["Name"], spell["Secondary"][0], spell["Secondary"]["Talents"] )
		end
	end
	if not self.fullUpdate then
		self:UpdateAB()
	end
end
TalentIterate = function( name, baseSpell, endtable )
	if not baseSpell or type(baseSpell) == "function" then return end
	DrD_ClearTable( endtable )
	local melee = baseSpell.Melee
	local school = baseSpell.School
	local s1,s2,s3
	if type(school) == "table" then
		s1 = school[1]
		s2 = school[2]
		s3 = school[3]
	else
		s1 = school or "Physical"
	end
	for talentName, talentRank in pairs( talents ) do
		local talentTable = talentInfo[talentName]
		for i=1,#talentTable do
			local talent = talentTable[i]
			if (melee and talent.Melee or talent.Caster and not melee or (not talent.Melee and not talent.Caster)) then
				local spells = talent.Spells
				if not DrD_MatchData(talent.Not,name,s2,s3) then
					if DrD_MatchData(spells,name,s3) or not baseSpell.NoSchoolTalents and DrD_MatchData(spells, "All", s1) or not baseSpell.NoTypeTalents and DrD_MatchData(spells, s2) then
						local number = #endtable + 1
						local modtype = talent.ModType
						local multiply = talent.Multiply
						endtable["Multiply"..number] = multiply
						endtable[number] = type(talent.Effect) == "table" and talent.Effect[talentRank] or talent.Effect * talentRank
						if not modtype then
							endtable[("ModType"..number)] = multiply and "dmgM" or "dmgM_Add"
						elseif modtype == "SpellDamage" then
							endtable[("ModType"..number)] = multiply and "spellDmgM" or "spellDmgM_Add"
						else
							endtable[("ModType"..number)] = modtype
						end
						--[===[@debug@
						endtable[talentName] = number
						--@end-debug@]===]
						if talent.Mod then
							local mod = talent.Mod
							if DrD_MatchData(mod[1], name, "All", s1, s2, s3) then
								mod[6] = talentRank
								endtable["Mod"..number] = mod
							end
						end
					end
				end
			end
		end
	end
end

local SetItems = {}
function DrDamage:GetSetAmount(set)
	--[===[@debug@
	if self.debug then
		return 8
	end
	--@end-debug@]===]
	if not updateSetItems and SetItems[set] then
		return SetItems[set]
	end

	if updateSetItems then
		DrD_ClearTable( SetItems )
		updateSetItems = false
	end

	local amount = 0
	local setData = self.SetBonuses[set]
	if setData then
		for _, itemID in ipairs(setData) do
			if IsEquippedItem(itemID) then
				amount = amount + 1
			end
		end
	end
	SetItems[set] = amount
	return amount
end

local Glyphs = {}
function DrDamage:HasGlyph(glyph)
	--[===[@debug@
	if self.debug then
		return true
	end
	--@end-debug@]===]
	return Glyphs[glyph]
end

function DrDamage:UpdateGlyphs()
	DrD_ClearTable(Glyphs)
	for i=1,6 do
		local _, _, id = GetGlyphSocketInfo(i)
		if id then Glyphs[id] = true end
	end
end

local lines = {}
local savedname, savedrank
local autoattack = GetSpellInfo(6603)

function DrDamage:ClearTooltip()
	if savedname then
		for i = 1, #lines do
			lines[i]["Left"] = nil
			lines[i]["Right"] = nil
			lines[i]["Rl"] = nil
			lines[i]["Gl"] = nil
			lines[i]["Bl"] = nil
			lines[i]["Rr"] = nil
			lines[i]["Gr"] = nil
			lines[i]["Br"] = nil
		end
		savedname = nil
		savedrank = nil
	end
end

function DrDamage:RedoTooltip(frame, name, rank)
	if savedname and savedname == name and savedrank == rank then
		frame:AddLine(" ")
		for i=1, #lines do
			if lines[i]["Right"] then
				frame:AddDoubleLine(lines[i]["Left"], lines[i]["Right"], lines[i]["Rl"], lines[i]["Gl"], lines[i]["Bl"], lines[i]["Rr"], lines[i]["Gr"], lines[i]["Br"])
			elseif lines[i]["Left"] and lines[i]["Left"] ~= " " then
				frame:AddLine(lines[i]["Left"], lines[i]["Rl"], lines[i]["Gl"], lines[i]["Bl"])
			end
		end
		frame:Show()
		return true
	end
end

function DrDamage:SaveTooltip(name, rank, size)
	local start
	local line = 1
	for i= size, GameTooltip:NumLines() do
		if not start and _G[("GameTooltipTextRight" .. i)]:GetText() then
			start = true
			savedname = name
			savedrank = rank
		end
		if start then
			if not lines[line] then
				lines[line] = {}
			end
			lines[line]["Left"] = _G[("GameTooltipTextLeft" .. i)]:GetText()
			lines[line]["Right"] = _G[("GameTooltipTextRight" .. i)]:GetText()
			lines[line]["Rl"], lines[line]["Gl"], lines[line]["Bl"] = _G[("GameTooltipTextLeft" .. i)]:GetTextColor()
			lines[line]["Rr"], lines[line]["Gr"], lines[line]["Br"] = _G[("GameTooltipTextRight" .. i)]:GetTextColor()
			line = line + 1
		end
	end
end

function DrDamage:SetSpell( frame, slot )
	if settings.Tooltip == "Never" then return end
	if settings.Tooltip == "Combat" and InCombatLockdown() then return end
	if settings.Tooltip == "Alt" and not IsAltKeyDown() then return end
	if settings.Tooltip == "Ctrl" and not IsControlKeyDown() then return end
	if settings.Tooltip == "Shift" and not IsShiftKeyDown() then return end

	local name, rank = GetSpellName(slot,BOOKTYPE_SPELL)

	if self:RedoTooltip(frame, name, rank) then return end

	if spellInfo[name] then
		local baseSpell = spellInfo[name][0]
		local secondary = spellInfo[name]["Secondary"]
		if type(baseSpell) == "function" then baseSpell = baseSpell() end

		local size = GameTooltip:NumLines() + 1

		if baseSpell and not baseSpell.NoTooltip then
			if playerCaster or playerHybrid and not baseSpell.Melee then
				self:CasterTooltip( frame, name, rank )
			elseif playerMelee or playerHybrid and baseSpell.Melee then
				self:MeleeTooltip( frame, name, rank )
			end
		end
		if savedname then
			self:ClearTooltip()
		end
		if name == autoattack then
			self:SaveTooltip(name, rank, 4)
		elseif (GetSpellCooldown(slot, BOOKTYPE_SPELL) > 0) and not secondary then
			self:SaveTooltip(name, rank, size)
		end
	end
end

function DrDamage:SetAction( frame, slot )
	if settings.Tooltip == "Never" then return end
	if settings.Tooltip == "Combat" and InCombatLockdown() then return end
	if settings.Tooltip == "Alt" and not IsAltKeyDown() then return end
	if settings.Tooltip == "Ctrl" and not IsControlKeyDown() then return end
	if settings.Tooltip == "Shift" and not IsShiftKeyDown() then return end

	local gtype, pid = GetActionInfo(slot)
	local name, rank, macro

	if (gtype == "spell" and pid ~= 0) then
		name, rank = GetSpellName(pid, gtype)
	elseif gtype == "macro" then
		name, rank = GetMacroSpell(pid)
		local macrotext = GetMacroBody(pid)
		if macrotext then
			macro = string_find(macrotext, "target=") or string_find(macrotext, "@")
		end
	end

	if self:RedoTooltip(frame, name, rank) then return end

	if name and spellInfo[name] then
		local baseSpell = spellInfo[name][0]
		local secondary = spellInfo[name]["Secondary"]
		if type(baseSpell) == "function" then baseSpell = baseSpell() end

		local size = GameTooltip:NumLines() + 1

		if baseSpell and not baseSpell.NoTooltip then
			rank = rank or select(2,GetSpellInfo(name))
			if playerCaster or playerHybrid and not baseSpell.Melee then
				self:CasterTooltip( frame, name, rank )
			elseif playerMelee or playerHybrid and baseSpell.Melee then
				self:MeleeTooltip( frame, name, rank )
			end
		end
		if savedname then
			self:ClearTooltip()
		end
		if (GetActionCooldown(slot) > 0 or macro) and not secondary then
			self:SaveTooltip(name, rank, size)
		end
	end
end

function DrDamage:SetShapeshift( frame, slot )
	if settings.Tooltip == "Never" then return end
	if settings.Tooltip == "Combat" and InCombatLockdown() then return end
	if settings.Tooltip == "Alt" and not IsAltKeyDown() then return end
	if settings.Tooltip == "Ctrl" and not IsControlKeyDown() then return end
	if settings.Tooltip == "Shift" and not IsShiftKeyDown() then return end

	local name, rank = frame:GetSpell()

	if name and spellInfo[name] then
		local baseSpell = spellInfo[name][0]
		if type(baseSpell) == "function" then baseSpell = baseSpell() end

		if baseSpell and not baseSpell.NoTooltip then
			if playerCaster or playerHybrid and not baseSpell.Melee then
				self:CasterTooltip( frame, name, rank )
			elseif playerMelee or playerHybrid and baseSpell.Melee then
				self:MeleeTooltip( frame, name, rank )
			end
		end
	end
end

local DrD_ProcessButton, DrD_CreateText
function DrDamage:UpdateAB(spell, uid, disable, mana)
	--	Used for debugging updates.
	--[[
	if spell then
		self:Print( "Update AB: Spell" )

		if type( spell ) == "table" then
			for k in pairs( spell ) do
				self:Print( "Updating: " .. k )
			end
		else
			self:Print( "Updating: " .. spell )
		end
	elseif uid then
		self:Print( "Update AB: ID" )

	else
		self:Print( "Update AB: All" )
	end
	--]]

	--Enable if needed
	--if ABfunc then
	--	ABfunc()
	--end
	if ABtable then
		for name, func in pairs(ABtable) do
			DrD_ProcessButton(_G[name], func, spell, uid, mana)
		end
	end
	if not ABdisable and settings.DefaultAB then
		for i, name in ipairs(ABobjects) do
			DrD_ProcessButton(name, ActionButton_GetPagedID, spell, uid, mana, disable)
		end
	end
	self.fullUpdate = nil
	self.visualChange = nil
	dmgMod = select(7, UnitDamage("player"))
	self:ClearTooltip()
end

DrD_ProcessButton = function(button, func, spell, uid, mana, disable)
	if not button then return end
	if not spell and not uid and not mana then
		local frame = button.drd
		if frame then frame:SetText(nil) end
		frame = button.drd2
		if frame then frame:SetText(nil) end
	end
	if not settings.ABText or disable then return end
	if button:IsVisible() then
		local id, name, rank = func(button)
		if id and (not HasAction(id) or uid and uid ~= id) then return end
		DrDamage:CheckAction(button, spell, id, name, rank, mana)
	end
end

function DrDamage:CheckAction(button, spell, id, name, rank, mana)
	local gtype, pid, macro
	if id then
		gtype, pid = GetActionInfo(id)
		if gtype == "spell" and (pid > 0) then
			name, rank = GetSpellName(pid, gtype)
		elseif gtype == "macro" then
			name, rank = GetMacroSpell(pid)
			macro = true
		end
	end
	if name then
		if spell and not DrD_MatchData(spell, name) then return end
		local r, g, b
		if settings.DisplayType2 == "Casts" then
			if tonumber(rank) and GetSpellInfo(name) then
				rank = string_gsub(select(2,GetSpellInfo(name)),"%d+", rank)
			end
			local _, _, _, manaCost, _, powerType = GetSpellInfo(name,rank)
			if manaCost and (manaCost > 0) and powerType == 0 then
				local text =  math_floor(UnitPower("player",0) / manaCost)
				local ctable
				if text >= 10 then
					ctable = settings.FontColorCasts1
				elseif text >= 5 then
					ctable = settings.FontColorCasts2
				else
					ctable = settings.FontColorCasts3
				end
				local r, g, b = ctable.r, ctable.g, ctable.b
				DrD_CreateText(button, true, text, nil, nil, nil, r, g, b)
			end
			if mana then return end
		end
		if ManaCost or PowerCost then
			if tonumber(rank) and GetSpellInfo(name) then
				rank = string_gsub(select(2,GetSpellInfo(name)),"%d+", rank)
			end
			local _, _, _, manaCost, _, powerType = GetSpellInfo(name,rank)
			if manaCost and (manaCost > 0) and (ManaCost and powerType == 0 or PowerCost and (playerMelee and powerType == 0 or powerType == 1 or powerType == 3)) then
				local ctable = (powerType == 1) and settings.FontColorRage or (powerType == 3) and settings.FontColorEnergy or settings.FontColorMana
				r, g, b = ctable.r, ctable.g, ctable.b
				DrD_CreateText(button, true, manaCost, nil, nil, nil, r, g, b)
				if ManaCost and not PowerCost and settings.DisplayType_M2 then
					r, g, b = nil, nil, nil
				end
			end
		end
		if self.ClassSpecials[name] then
			rank = rank and tonumber(string_match(rank,"%d+"))
			local text, healing, mana, full, r, g, b = self.ClassSpecials[name](rank)
			if type(text) == "number" then
				if healing then
					text = text * self.healingMod
				end
				if not full then
					text = math_floor(text + 0.5)
				end
			end
			return DrD_CreateText(button, nil, text, macro, healing, mana, r, g, b)
		end
		if spellInfo[name] then
			local baseSpell = settings.SwapCalc and spellInfo[name]["Secondary"] and spellInfo[name]["Secondary"][0] or spellInfo[name][0]
			if type(baseSpell) == "function" then baseSpell = baseSpell() end

			if baseSpell then
				local text, text2, healingSpell
				if playerCaster or playerHybrid and not baseSpell.Melee then
					healingSpell = type(baseSpell.School) == "table" and baseSpell.School[2] == "Healing"
					text, text2 = self:CasterCalc(name, rank)
				elseif playerMelee or playerHybrid and baseSpell.Melee then
					text, text2 = self:MeleeCalc(name, rank)
				end
				DrD_CreateText(button, nil, text, macro, healingSpell)
				if text2 then
					DrD_CreateText(button, true, text2, nil, healingSpell, nil, r, g, b)
				end
			end
		end
	end
end

DrD_CreateText = function(button, second, text, macro, healing, mana, r, g, b )
	if not text then
		return
	end
	if not r then
		local color = mana and settings.FontColorMana or healing and settings.FontColorHeal or settings.FontColorDmg
		r,g,b = color.r, color.g, color.b
	end
	if button then
		local drd
		if second then drd = button.drd2
		else drd = button.drd end
		if drd then
			if DrDamage.visualChange then
				if second then
					drd:SetPoint("TOPLEFT", button, "TOPLEFT", -15 + settings.FontXPosition2, settings.FontYPosition2 - 1)
					drd:SetPoint("TOPRIGHT", button, "TOPRIGHT", 15 + settings.FontXPosition2, settings.FontYPosition2 - 1)
				else
					drd:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -15 + settings.FontXPosition, settings.FontYPosition + 3)
					drd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 15 + settings.FontXPosition, settings.FontYPosition + 3)
				end
				drd:SetFont(DrD_Font, settings.FontSize, settings.FontEffect)
			end
			drd:SetTextColor(r,g,b)
			drd:SetText(text)
			drd:Show()
		else
			if second then
				drd = button:CreateFontString("drd2", "OVERLAY")
				button.drd2 = drd
				drd:SetPoint("TOPLEFT", button, "TOPLEFT", -15 + settings.FontXPosition2, settings.FontYPosition2 - 1)
				drd:SetPoint("TOPRIGHT", button, "TOPRIGHT", 15 + settings.FontXPosition2, settings.FontYPosition2 - 1)
			else
				drd = button:CreateFontString("drd", "OVERLAY")
				button.drd = drd
				drd:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -15 + settings.FontXPosition, settings.FontYPosition + 3)
				drd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 15 + settings.FontXPosition, settings.FontYPosition + 3)
			end
			drd:SetFont(DrD_Font, settings.FontSize, settings.FontEffect)
			drd:SetJustifyH("CENTER")
			drd:SetTextColor(r,g,b)
			drd:SetText(text)
			drd:Show()
		end
		if second then
			if settings.HideHotkey then
				local hotkey = _G[button:GetName().."HotKey"]
				if hotkey then hotkey:Hide() end
			end
		else
			if macro and settings.HideAMacro then
				local macro = _G[button:GetName().."Name"]
				if macro then macro:Hide() end
			end
		end
	else
		return "|cff".. string_format("%02x%02x%02x", r * 255, g * 255, b * 255) .. text .. "|r"
	end
end

--Credits to the author of RatingBuster (Whitetooth) for the formula!
local ratingTypes = { ["Hit"] = 8, ["Crit"] = 14, ["MeleeHit"] = 10, ["Haste"] = 10, ["MeleeHaste"] = 10, ["Resilience"] = 28.75, ["Expertise"] = 2.5, ["ArmorPenetration"] = 4.26655 }
if (playerClass == "DEATHKNIGHT") or (playerClass == "SHAMAN") or (playerClass == "PALADIN") or playerClass == ("DRUID") then
	ratingTypes["MeleeHaste"] = 10/1.3
end

function DrDamage:GetRating( rType, convertR, full )
	local playerLevel = UnitLevel("player")
	local base = ratingTypes[rType] or rType
	local rating, value

	if playerLevel > 70 then
		rating = base * (82/52) * ((131/63)^((playerLevel - 70)/10))
	elseif playerLevel > 60 then
		rating = base * 82 / (262 - 3 * playerLevel)
	elseif playerLevel > 10 then
		rating = base * ((playerLevel - 8) / 52)
	elseif 	playerLevel <= 10 then
		rating = base / 26
	end

	value = convertR and convertR/rating or rating
	value = full and value or DrD_Round(value,2)
	return value
end

function DrDamage:GetLevels()
	local playerLevel = UnitLevel("player")
	local targetLevel = UnitLevel("target")
	local boss

	if (UnitClassification("target") == "worldboss") then
		targetLevel = playerLevel + 3
		boss = true
	elseif targetLevel == 0 then
		targetLevel = playerLevel
	elseif targetLevel == -1 then
		targetLevel = playerLevel + 10
	end

	return playerLevel, math_max(playerLevel - 4, math_min(playerLevel + 10, targetLevel)), boss
end

--CORE: Base spell hit chance
local hitDataMOB = { [-4] = 100, [-3] = 99, [-2] = 98, [-1] = 97, [0] = 96, 95, 94, 83, 72, 61, 50, 39, 28, 17, 6 }
local hitDataPlayer = { [-4] = 100, [-3] = 99, [-2] = 98, [-1] = 97, [0] = 96, 95, 94, 87, 80, 73, 66, 59, 52, 45, 38 }
local hitMod = (select(2, UnitRace("player")) == "Draenei") and 1 or 0
function DrDamage:GetSpellHit(playerLevel, targetLevel)
	local player = (settings.TargetLevel == 0) and UnitIsPlayer("target")
	local delta = math_min(10,math_max(-4,targetLevel - playerLevel))
	return (player and hitDataPlayer[delta] or hitDataMOB[delta]) + hitMod + GetCombatRatingBonus(8)
end

local WeaponBuffScan = GetTime()
local WeaponBuff, WeaponBuffRank
function DrDamage:GetWeaponBuff(off)
	local mh, _, _, oh = GetWeaponEnchantInfo()
	local name, rank, buff

	if not off and mh then
		if GetTime() > WeaponBuffScan then
			WeaponBuffScan = GetTime() + 2
			GT:SetInventoryItem("player", 16)
			_, _, buff = GT:Find("^([^%(]+) %(%d+ [^%)]+%)$", nil, nil, false, true)
			if buff then
				name, rank = string_match(buff,"^(.*) (%d+)$")
			end
			WeaponBuff, WeaponBuffRank = name or buff, rank
		end
		return WeaponBuff, WeaponBuffRank
	elseif off and oh then
		GT:SetInventoryItem("player", 17)
		_, _, buff = GT:Find("^([^%(]+) %(%d+ [^%)]+%)$", nil, nil, false, true)
		if buff then
			name, rank = string_match(buff,"^(.*) (%d+)$")
		end
	end
	return name or buff, rank
end

function DrDamage:Calc(name, rank, tooltip, modify, debug)
	if not spellInfo or not name then return end
	if not spellInfo[name] then return end
	local baseSpell = settings.SwapCalc and spellInfo[name]["Secondary"] and spellInfo[name]["Secondary"][0] or spellInfo[name][0]
	if type(baseSpell) == "function" then baseSpell = baseSpell() end
	if baseSpell then
		if playerCaster or playerHybrid and not baseSpell.Melee then
			return self:CasterCalc(name, rank, tooltip, modify, debug)
		elseif playerMelee or playerHybrid and baseSpell.Melee then
			return self:MeleeCalc(name, rank, tooltip, modify, debug)
		end
	end
end

--Load aura iteration function
AuraIterate = function(name, spell, auratable, bufftable)
	local baseSpell = spell[0]
	local spellName = spell["Name"]
	local baseSchool = baseSpell.School
	local school, group, subType
	if type(baseSchool) == "table" then
		school = baseSchool[1]
		group = baseSchool[2]
		subType = baseSchool[3]
	else
		school = baseSchool or "Physical"
	end
	local healing = DrD_MatchData(baseSchool, "Healing")
	local caster = playerCaster or playerHybrid and not baseSpell.Melee
	local melee = playerMelee or playerHybrid and baseSpell.Melee
	local spell = caster and not DrD_MatchData(baseSchool, "Melee") or melee and DrD_MatchData(baseSchool, "Spell")
	local utility = (group == "Absorb") or (group == "Utility") or (group == "Pet")

	for buff, data in pairs(bufftable) do
		if not data.Update and (caster and (data.Caster or not data.Melee) or melee and (data.Melee or not data.Caster)) then
			if not data.Not or data.Not and not DrD_MatchData(data.Not, spellName, group, subType) then
				local buffschool = data.School
				if data.Spells and DrD_MatchData(data.Spells, name)
				or not healing and (not buffschool and not data.Spells or DrD_MatchData(buffschool, school))
				or spell and (DrD_MatchData(buffschool, "Spells") or not healing and not utility and DrD_MatchData(buffschool, "Damage Spells"))
				or healing and DrD_MatchData(buffschool, "Healing")
				or DrD_MatchData(buffschool, "All", group, subType) then
						auratable[buff] = true
				end
			end
		end
	end
end

function DrDamage.BuffCalc( data, calculation, ActiveAuras, Talents, baseSpell, buffName, index, apps, texture, rank, target )
	if index then
		if data.BuffID and select(11,UnitBuff(target,index)) ~= data.BuffID then
			return
		end
		if data.DebuffID and select(11,UnitDebuff(target,index)) ~= data.DebuffID then
			return
		end
		if data.Texture and texture and not string_find(texture, data.Texture) then
			return
		end
		if data.SelfCast then
			local unit = select(8,UnitDebuff(target,index))
			if not unit or not UnitIsUnit("player",unit) then return end
		end
		if data.SelfCastBuff then
			local unit = select(8,UnitBuff(target,index))
			if not unit or not UnitIsUnit("player",unit) then return end
		end
	end
	--Process active aura table
	if data.ActiveAura then
		if data.Ranks then
			ActiveAuras[data.ActiveAura] = rank and tonumber(string_match(rank,"%d+")) or data.Ranks
		elseif data.Index then
			ActiveAuras[data.ActiveAura] = index or 0
		else
			if apps and apps > 0 then
				ActiveAuras[data.ActiveAura] = apps
			else
				ActiveAuras[data.ActiveAura] = data.Apps or (ActiveAuras[data.ActiveAura] or 0) + 1
			end
		end
	end
	--Process category
	if data.Category and not data.SkipCategory then
		if ActiveAuras[data.Category] then return
		else ActiveAuras[data.Category] = true end
	end
	--Determine modtype
	local modType = data.ModType
	if modType and type(modType) == "function" then
		apps = apps or data.Apps
		rank = rank and tonumber(string_match(rank,"%d+")) or data.Ranks
		modType( calculation, ActiveAuras, Talents, index, apps, texture, rank, target )
	else
		--NOTE: For manually added buffs
		if not index and data.Mods or baseSpell.CustomHaste and data.CustomHaste then
			for k, v in pairs(data.Mods) do
				if type(k) == "number" then
					v(calculation, baseSpell)
				elseif calculation[k] then
					if type(v) == "function" then
						calculation[k] = v(calculation[k], baseSpell)
					else
						if data.Multiply then
							calculation[k] = calculation[k] * (1 + v)
						else
							calculation[k] = calculation[k] + v
						end
					end
				end
			end
		end
		local value = data.Value
		if not value then return end
		if data.Ranks then
			rank = rank and tonumber(string_match(rank,"%d+")) or data.Ranks
			value = (type(value) == "table") and value[rank] or value * rank
		end
		if data.Apps then
			apps = apps or data.Apps
			value = (type(value) == "table") and value[apps] or value * apps
		end
		if not modType then
			calculation.dmgM = calculation.dmgM * (1 + value)
		elseif calculation[modType] then
			if data.Multiply then
				calculation[modType] = calculation[modType] * (1 + value)
			else
				calculation[modType] = calculation[modType] + value
			end
		end
	end
end

function DrDamage:CompareTooltip(...)
	local value = select(1,...)
	local n = select("#",...) / 2
	local text, text2
	for i = 2, n do
		local stat = select(i,...)
		if stat then
			stat = DrD_Round(stat / value, 1)
			local abbr = select(i+n,...)
			text = text and (text .. "|" .. abbr) or abbr
			text2 = text2 and (text2 .. "/" .. stat) or stat
		end
	end
	if text then
		text = "+1 " .. select(1 + n,...) .. " (" .. text .. "):"
		return text, text2
	end
end