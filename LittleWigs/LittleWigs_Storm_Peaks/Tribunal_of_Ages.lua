-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Tribunal of Ages", "Halls of Stone")
if not mod then return end
mod.partycontent = true
mod.otherMenu = "The Storm Peaks"
mod:RegisterEnableMob(28070)
mod.toggleOptions = {"timers", "bosskill"}

-------------------------------------------------------------------------------
--  Localization

local L = mod:NewLocale("enUS", true)
if L then

L["defeat_trigger"] = "The old magic fingers"
L["enable_trigger"] = "Time to get some answers"
L["engage_trigger"] = "Now keep an eye out"
L["fail_trigger"] = "Not yet, not"
L["moduleName"] = "Tribunal of Ages"
L["timers"] = "Timers"
L["timers_desc"] = "Timers for various events that take place."
L["victory"] = "Victory!"
L["wave"] = "First wave!"

end
L = mod:GetLocale()

mod.displayName = L["moduleName"]

-------------------------------------------------------------------------------
--  Initialization

function mod:OnRegister()
	self:RegisterEnableYell(L["enable_trigger"])
end

function mod:OnBossEnable()
	self:Yell("Engage", L["engage_trigger"])
	self:Yell("Reboot", L["fail_trigger"])
	self:Yell("Win", L["defeat_trigger"])
end

function mod:OnEngage()
	self:Bar("timers", self.displayName, 45, "Achievement_Character_Dwarf_Male")
	self:Bar("timers", L["victory"], 315, "INV_Misc_PocketWatch_01")
end
