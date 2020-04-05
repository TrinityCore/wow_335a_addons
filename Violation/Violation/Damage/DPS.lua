if not Violation then return end
-----------------------------------------------------------------------
-- Locale
-----------------------------------------------------------------------
local L = AceLibrary("AceLocale-2.2"):new("Violation: DPS")

L:RegisterTranslations("enUS", function() return {
	["Damage per Second"] = true,
	["DPS"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Damage per Second"] = "每秒伤害",
	["DPS"] = "每秒伤害(DPS)",	
} end)
	
L:RegisterTranslations("zhTW", function() return {
	["Damage per Second"] = "每秒傷害",
	["DPS"] = "每秒傷害(DPS)",
} end)
	
L:RegisterTranslations("koKR", function() return {
	["Damage per Second"] = "초당 피해량",
} end)

L:RegisterTranslations("frFR", function() return {
	["Damage per Second"] = "Dégâts par seconde",
	["DPS"] = "DPS",
} end)

L:RegisterTranslations("ruRU", function() return {
	["Damage per Second"] = "Урона в секунду",
	["DPS"] = "УВС",
} end)

-----------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------

local seconds = nil
local damageDone = nil
local moduleName = "Damage per Second"
local isInCombat = {}
local combatStartTime = {}
local lastShotTime = {}
local isInCombat = {}

local COMBAT_TIMEOUT = 4

-----------------------------------------------------------------------
-- Module declaration
-----------------------------------------------------------------------

local mod = Violation:NewModule(moduleName)
mod.revision = tonumber(("$Revision: 488 $"):sub(12, -3)) or 1
mod.version = 6
mod.hidePercentage = true
mod.violationCategory = "damage"

-----------------------------------------------------------------------
-- Module initialization
-----------------------------------------------------------------------

function mod:OnModuleEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnEvent")
	self:RegisterEvent("PLAYER_REGEN_ENABLED") -- handle player dps time via regen enabled
	self:ScheduleRepeatingEvent( self.CheckPartyCombat, 1, self )
end

function mod:OnReset()
	if type(seconds) == "table" then
		seconds = mod:del(seconds)
	end
	seconds = mod:new()
	
	if type(damageDone) == "table" then
		damageDone = mod:del(damageDone)
	end
	damageDone = mod:new()

	for k in pairs(combatStartTime) do
		combatStartTime[k] = nil
	end
	for k in pairs(lastShotTime) do
		lastShotTime[k] = nil
	end
end

-----------------------------------------------------------------------
-- Module implementation
-----------------------------------------------------------------------

function mod:GetDisplayName() return L["Damage per Second"] end
function mod:GetShortDisplayName() return L["DPS"] end

function mod:OnData(name, input)
	self.data[name] = nil
	self.dirty = true
end

function mod:IsDirty()
	return self.dirty or next(isInCombat)
end

local function getDuration(name)
	local duration = seconds[name] or 0
	if combatStartTime[name] then
		duration = duration + math.max(lastShotTime[name] - combatStartTime[name], 1.5)
	end
	return math.max(duration, 1.5) 
end

local function calculateData(name)
	return math.floor((damageDone[name] or 0) / getDuration(name))
end

local moduleData = {}
function mod:GetData(name)
	if name then
		return self.data[name] or calculateData(name)
	else
		for k, v in pairs(moduleData) do
			moduleData[k] = nil
		end
		for name in pairs(damageDone) do
			moduleData[name] = calculateData(name)
		end
		for name, value in pairs(self.data) do
			moduleData[name] = value 
		end
		return moduleData
	end
end

function mod:UpdateDPS(name)
	self:OnData(name, true)
end

function mod:ResetDPSTimer(name)
	if combatStartTime[name] then
		seconds[name] = getDuration(name)

		combatStartTime[name] = nil
		lastShotTime[name] = nil

		self:UpdateDPS(name)
	end	
end

function mod:CheckDPSTimer(name)
	if lastShotTime[name] and lastShotTime[name] + COMBAT_TIMEOUT < GetTime() then
		self:ResetDPSTimer(name)
	end
end

local events = {
	SWING_DAMAGE = true,
	RANGE_DAMAGE = true,
	SPELL_DAMAGE = true,
	SPELL_PERIODIC_DAMAGE = true,
	DAMAGE_SHIELD = true,
	DAMAGE_SPLIT = true,
}
function mod:OnEvent(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount)
	if not events[eventType] or not Violation:ShouldAccept(srcFlags) then return end
	if eventType == "SWING_DAMAGE" then
		amount = spellId
	end
	if amount and amount > 0 then
		local guid = Violation:GetReferenceGUID(srcGUID, srcFlags)
	 	self:CheckDPSTimer(guid)

	 	local newTime = GetTime()
		combatStartTime[guid] = combatStartTime[guid] or newTime
		lastShotTime[guid] = newTime
		damageDone[guid] = (damageDone[guid] or 0) + amount

		self:UpdateDPS(guid)
	end
end

-----------------------------------------------------------------------
-- Combat status watching
-----------------------------------------------------------------------

function mod:PLAYER_REGEN_ENABLED()
	mod:ResetDPSTimer(UnitGUID("player"))
end

function mod:CheckPartyCombat()
	for name, id in pairs(Violation.roster) do
		if isInCombat[id] then
			if not UnitAffectingCombat(name) then
				isInCombat[id] = nil
				mod:ResetDPSTimer(id)
			else
				mod:CheckDPSTimer(id)
			end
		elseif UnitAffectingCombat(name) then
			isInCombat[id] = true
		end
	end
end
