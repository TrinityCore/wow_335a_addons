if not Violation then return end
-----------------------------------------------------------------------
-- Locale
-----------------------------------------------------------------------
local L = AceLibrary("AceLocale-2.2"):new("Violation: Overhealing")

L:RegisterTranslations("enUS", function() return {
	["Overhealing done"] = true,
	["OH"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Overhealing done"] = "过量治疗",
	["OH"] = "过量治疗(OH)",	
} end)

L:RegisterTranslations("zhTW", function() return {
	["Overhealing done"] = "過量治療",
	["OH"] = "過量治療(OH)",	
} end)

L:RegisterTranslations("koKR", function() return {
	["Overhealing done"] = "오버힐량",
} end)

L:RegisterTranslations("frFR", function() return {
	["Overhealing done"] = "Soins en excès",
	["OH"] = "SE",
} end)

L:RegisterTranslations("ruRU", function() return {
	["Overhealing done"] = "Избыточное исцеление",
	["OH"] = "ИИ",
} end)

-----------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------

local moduleName = "Overhealing done"

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
-- Module implementation(craftedPetGUIDs
-----------------------------------------------------------------------

function mod:GetDisplayName() return L["Overhealing done"] end
function mod:GetShortDisplayName() return L["OH"] end

function mod:OnEvent(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount, overheal, critical)
	if (eventType ~= "SPELL_HEAL" and eventType ~= "SPELL_PERIODIC_HEAL") or not Violation:ShouldAccept(srcFlags) then
		return
	end
	if overheal and overheal > 0 then
		self:OnData(Violation:GetReferenceGUID(srcGUID, srcFlags), overheal)
	end
end
