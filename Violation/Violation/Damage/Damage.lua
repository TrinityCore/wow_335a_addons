if not Violation then return end
-----------------------------------------------------------------------
-- Locale
-----------------------------------------------------------------------
local L = AceLibrary("AceLocale-2.2"):new("Violation: Damage")

L:RegisterTranslations("enUS", function() return {
	["Damage done"] = true,
	["D"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Damage done"] = "伤害输出",
	["D"] = "伤害(D)",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Damage done"] = "造成傷害",
	["D"] = "傷害(D)",
} end)

L:RegisterTranslations("koKR", function() return {
	["Damage done"] = "입힌 피해량",
} end)

L:RegisterTranslations("frFR", function() return {
	["Damage done"] = "Dégâts infligés",
	["D"] = "D",
} end)

L:RegisterTranslations("ruRU", function() return {
	["Damage done"] = "Нанесенный урон",
	["D"] = "НУ",
} end)

-----------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------

local moduleName = "Damage done"

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

function mod:GetDisplayName() return L["Damage done"] end
function mod:GetShortDisplayName() return L["D"] end

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
		self:OnData(Violation:GetReferenceGUID(srcGUID, srcFlags), amount)
	end
end

