-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Gal'darah", "Gundrak")
if not mod then return end
mod.partyContent = true
mod.otherMenu = "Zul'Drak"
mod:RegisterEnableMob(29306)
mod.toggleOptions = {"forms", "bosskill"}

-------------------------------------------------------------------------------
--  Locals

local formannounce = false

-------------------------------------------------------------------------------
--  Localization

local L = mod:NewLocale("enUS", true)
if L then

L["form_rhino"] = "Rhino Form Soon"
L["forms"] = "Forms"
L["forms_desc"] = "Warn before Gal'darah changes forms."
L["form_troll"] = "Troll Form Soon"

end
L = mod:GetLocale()

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	if bit.band(self.db.profile.forms, BigWigs.C.MESSAGE) == BigWigs.C.MESSAGE then
		self:RegisterEvent("UNIT_HEALTH")
	end
	self:Death("Win", 29306)
end

function mod:OnEngage()
	formannounce = false
end

-------------------------------------------------------------------------------
--  Event Handlers

local function between(value, low, high)
	if (value >= low) and (value <= high) then
		return true
	end
end

function mod:UNIT_HEALTH(event, msg)
	if UnitName(msg) ~= mod.displayName then return end
	local currentHealth = UnitHealth(msg)
	local maxHealth = UnitHealthMax(msg)
	local percentHealth = (currentHealth/maxHealth)*100
	if not formannounce and (between(percentHealth, 75, 78) or between(percentHealth, 25, 28)) then
		self:Message("forms", L["form_rhino"], "Attention")
		formannounce = true
	elseif not formannounce and between(percentHealth, 50, 53) then
		self:Message("forms", L["form_troll"], "Attention")
		formannounce = true
	elseif formannounce and (between(percentHealth, 54, 74) or between(percentHealth, 29, 49)) then
		formannounce = false
	end
end
