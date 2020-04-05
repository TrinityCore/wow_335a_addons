if not Violation then return end
-----------------------------------------------------------------------
-- Locale
-----------------------------------------------------------------------
local L = AceLibrary("AceLocale-2.2"):new("Violation: HPS")

L:RegisterTranslations("enUS", function() return {
	["Healing per Second"] = true,
	["HPS"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Healing per Second"] = "每秒治疗",
	["HPS"] = "每秒治疗(HPS)",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Healing per Second"] = "每秒治療",
	["HPS"] = "每秒治療(HPS)",
} end)

L:RegisterTranslations("koKR", function() return {
	["Healing per Second"] = "초당 치유량",
} end)

L:RegisterTranslations("frFR", function() return {
	["Healing per Second"] = "Soins par seconde",
	["HPS"] = "SPS",
} end)

L:RegisterTranslations("ruRU", function() return {
	["Healing per Second"] = "Исцеления в секунду",
	["HPS"] = "ИВС",
} end)

-----------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------

local seconds = nil
local healingDone = nil
local moduleName = "Healing per Second"
local isInCombat = {}
local combatStartTime = {}
local lastHealTime = {}

local COMBAT_TIMEOUT = 4

-----------------------------------------------------------------------
-- Module declaration
-----------------------------------------------------------------------

local mod = Violation:NewModule(moduleName)
mod.revision = tonumber(("$Revision: 488 $"):sub(12, -3)) or 1
mod.version = 6
mod.hidePercentage = true
mod.violationCategory = "healing"

-----------------------------------------------------------------------
-- Module initialization
-----------------------------------------------------------------------

function mod:OnModuleEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnEvent")
	self:RegisterEvent("PLAYER_REGEN_ENABLED") -- handle player dps time via regen enabled
	self:ScheduleRepeatingEvent(self.CheckPartyCombat, 1, self)
end

function mod:OnReset()
	if type(seconds) == "table" then
		seconds = mod:del(seconds)
	end
	seconds = mod:new()
	
	if type(healingDone) == "table" then
		healingDone = mod:del(healingDone)
	end
	healingDone = mod:new()

	for k in pairs(combatStartTime) do
		combatStartTime[k] = nil
	end
	for k in pairs(lastHealTime) do
		lastHealTime[k] = nil
	end
end

-----------------------------------------------------------------------
-- Module implementation
-----------------------------------------------------------------------

function mod:GetDisplayName() return L["Healing per Second"] end
function mod:GetShortDisplayName() return L["HPS"] end

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
		duration = duration + math.max((lastHealTime[name] or GetTime()) - combatStartTime[name], 1.5)
	end
	return math.max(duration, 1.5)
end

local function calculateData(name)
	return math.floor((healingDone[name] or 0) / getDuration(name))
end

local moduleData = {}
function mod:GetData(name)
	if name then
		return self.data[name] or calculateData(name)
	else
		for k, v in pairs( moduleData ) do
			moduleData[k] = nil
		end
		for name in pairs(healingDone) do
			moduleData[name] = calculateData(name)
		end
		for name, value in pairs(self.data) do
			moduleData[name] = value 
		end
		return moduleData
	end
end

function mod:UpdateHPS(name)
	self:OnData(name, true)
end

function mod:ResetHPSTimer(name)
	if combatStartTime[name] then
		seconds[name] = getDuration(name)
		
		combatStartTime[name] = nil
		lastHealTime[name] = nil
		
		self:UpdateHPS(name)
	end
end

function mod:CheckHPSTimer(name)
	if lastHealTime[name] and lastHealTime[name] + COMBAT_TIMEOUT < GetTime() then
		self:ResetHPSTimer(name)
	end
end


function mod:OnEvent(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount, overheal, critical)
	if (eventType ~= "SPELL_HEAL" and eventType ~= "SPELL_PERIODIC_HEAL") or not Violation:ShouldAccept(srcFlags) then
		return
	end
	if amount and amount > 0 then
		amount = amount - (tonumber(overheal) or 0)
		
		self:CheckHPSTimer()

	 	local newTime = GetTime()
		local guid = Violation:GetReferenceGUID(srcGUID, srcFlags)
		combatStartTime[guid] = combatStartTime[guid] or newTime
		lastHealTime[guid] = newTime
		healingDone[guid] = (healingDone[guid] or 0) + amount	

		mod:UpdateHPS(guid)
	end
end

-----------------------------------------------------------------------
-- Combat status watching
-----------------------------------------------------------------------

function mod:PLAYER_REGEN_ENABLED()
	mod:ResetHPSTimer(UnitGUID("player"))
end

function mod:CheckPartyCombat()
	for name, id in pairs(Violation.roster) do
		if isInCombat[id] then
			if not UnitAffectingCombat(name) then
				isInCombat[id] = nil
				mod:ResetHPSTimer(id)
			else
				mod:CheckHPSTimer(id)			
			end
		elseif UnitAffectingCombat(name) then
			isInCombat[id] = true
		end
	end
end
