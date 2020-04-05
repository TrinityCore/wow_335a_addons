if not Violation then return end 
-----------------------------------------------------------------------
-- Locale
-----------------------------------------------------------------------
local L = AceLibrary("AceLocale-2.2"):new("Violation: DamageTaken")

L:RegisterTranslations("enUS", function() return {
	["Damage taken"] = true,
	["DT"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Damage taken"] = "承受伤害",
	["DT"] = "承受伤害(DT)",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Damage taken"] = "承受傷害",
	["DT"] = "承受傷害(DT)",
} end)

L:RegisterTranslations("koKR", function() return {
	["Damage taken"] = "받은 피해량",
} end)

L:RegisterTranslations("frFR", function() return {
	["Damage taken"] = "Dégâts reçus",
	["DT"] = "DR",
} end)

L:RegisterTranslations("ruRU", function() return {
	["Damage taken"] = "Полученный урон",
	["DT"] = "ПУ",
} end)

-----------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------

local moduleName = "Damage taken"

-----------------------------------------------------------------------
-- Module declaration
-----------------------------------------------------------------------

local mod = Violation:NewModule(moduleName)
mod.revision = tonumber(("$Revision: 488 $"):sub(12, -3)) or 1
mod.version = 6
mod.violationCategory = "damage"

-----------------------------------------------------------------------
-- Module initialization
-----------------------------------------------------------------------

function mod:OnModuleEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnEvent")
end

-----------------------------------------------------------------------
-- Module implementation
-----------------------------------------------------------------------

function mod:GetDisplayName() return L["Damage taken"] end
function mod:GetShortDisplayName() return L["DT"] end

local events = {
	SWING_DAMAGE = true,
	RANGE_DAMAGE = true,
	SPELL_DAMAGE = true,
	SPELL_PERIODIC_DAMAGE = true,
	DAMAGE_SHIELD = true,
	DAMAGE_SPLIT = true,
}
function mod:OnEvent(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount)
	if not events[eventType] or not Violation:ShouldAccept(dstFlags) then return end
	if eventType == "SWING_DAMAGE" then
		amount = spellId
	end
	if amount and amount > 0 then
		self:OnData(Violation:GetReferenceGUID(dstGUID, dstFlags), amount)
	end
end

