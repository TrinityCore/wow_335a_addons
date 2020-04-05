if not Violation then return end
-----------------------------------------------------------------------
-- Locale
-----------------------------------------------------------------------
local L = AceLibrary("AceLocale-2.2"):new("Violation: HealingTaken")

L:RegisterTranslations("enUS", function() return {
	["Healing taken"] = true,
	["HT"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Healing taken"] = "接受治疗",
	["HT"] = "接受治疗(HT)",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Healing taken"] = "承受治療",
	["HT"] = "承受治療(HT)",
} end)

L:RegisterTranslations("koKR", function() return {
	["Healing taken"] = "받은 치유량",
} end)

L:RegisterTranslations("frFR", function() return {
	["Healing taken"] = "Soins reçus",
	["HT"] = "SR",
} end)

L:RegisterTranslations("ruRU", function() return {
	["Healing taken"] = "Получено исцеления",
	["HT"] = "ПИ",
} end)

-----------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------

local moduleName = "Healing taken"

-----------------------------------------------------------------------
-- Module declaration
-----------------------------------------------------------------------

local mod = Violation:NewModule(moduleName)
mod.revision = tonumber(("$Revision: 488 $"):sub(12, -3)) or 1
mod.version = 6
mod.violationCategory = "healing"

-----------------------------------------------------------------------
-- Module initialization
-----------------------------------------------------------------------

function mod:OnModuleEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnEvent")
end

-----------------------------------------------------------------------
-- Module implementation
-----------------------------------------------------------------------

function mod:GetDisplayName() return L["Healing taken"] end
function mod:GetShortDisplayName() return L["HT"] end

function mod:OnEvent(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount, overheal, critical)
	if (eventType ~= "SPELL_HEAL" and eventType ~= "SPELL_PERIODIC_HEAL") or not Violation:ShouldAccept(dstFlags) then
		return
	end
	if amount and amount > 0 then
		self:OnData(Violation:GetReferenceGUID(dstGUID, dstFlags), amount - (tonumber(overheal) or 0))
	end
end

