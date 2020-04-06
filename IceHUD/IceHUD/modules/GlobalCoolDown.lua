local AceOO = AceLibrary("AceOO-2.0")

local GlobalCoolDown = AceOO.Class(IceBarElement)

-- Constructor --
function GlobalCoolDown.prototype:init()
	GlobalCoolDown.super.prototype.init(self, "GlobalCoolDown", "player")

	self.moduleSettings = {}
	self.moduleSettings.barVisible = {bar = true, bg = false}
	self.moduleSettings.desiredLerpTime = 0
	self.moduleSettings.shouldAnimate = false

	self.unit = "player"
	self.startTime = nil
	self.duration = nil
	self.spellId = _FindSpellId(self:GetSpellName())

	self:SetDefaultColor("GlobalCoolDown", 0.1, 0.1, 0.1)
end

-- 'Public' methods -----------------------------------------------------------

-- OVERRIDE
function GlobalCoolDown.prototype:Enable(core)
	GlobalCoolDown.super.prototype.Enable(self, core)
	
	self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN", "CooldownStateChanged")

	self:ScheduleRepeatingEvent(self.elementName, self.UpdateGlobalCoolDown, 0.05, self)

	self:Show(false)
end

function GlobalCoolDown.prototype:Disable(core)
	GlobalCoolDown.super.prototype.Disable(self, core)

	self:CancelScheduledEvent(self.elementName)
end

function GlobalCoolDown.prototype:GetSpellName()
	local defaultSpells;
	if (IceHUD.WowVer >= 30000) then
		defaultSpells = {
			ROGUE=GetSpellInfo(1752), -- sinister strike
			PRIEST=GetSpellInfo(139), -- renew
			DRUID=GetSpellInfo(774), -- rejuvenation
			WARRIOR=GetSpellInfo(6673), -- battle shout
			MAGE=GetSpellInfo(168), -- frost armor
			WARLOCK=GetSpellInfo(1454), -- life tap
			PALADIN=GetSpellInfo(1152), -- purify
			SHAMAN=GetSpellInfo(324), -- lightning shield
			HUNTER=GetSpellInfo(1978), -- serpent sting
			DEATHKNIGHT=GetSpellInfo(47541) -- death coil
		}
	else
		defaultSpells = {
			ROGUE=GetSpellInfo(1752), -- sinister strike
			PRIEST=GetSpellInfo(139), -- renew
			DRUID=GetSpellInfo(774), -- rejuvenation
			WARRIOR=GetSpellInfo(6673), -- battle shout
			MAGE=GetSpellInfo(168), -- frost armor
			WARLOCK=GetSpellInfo(1454), -- life tap
			PALADIN=GetSpellInfo(1152), -- purify
			SHAMAN=GetSpellInfo(324), -- lightning shield
			HUNTER=GetSpellInfo(1978) -- serpent sting
		}
	end
	local _, unitClass = UnitClass("player")
	return defaultSpells[unitClass]
end

-- OVERRIDE
function GlobalCoolDown.prototype:GetDefaultSettings()
	local settings = GlobalCoolDown.super.prototype.GetDefaultSettings(self)

	settings["enabled"] = false
	settings["side"] = IceCore.Side.Left
	settings["offset"] = 6
	settings["shouldAnimate"] = false
	settings["desiredLerpTime"] = nil
	settings["lowThreshold"] = 0
	settings["barVisible"]["bg"] = false
	settings["usesDogTagStrings"] = false

	return settings
end

-- OVERRIDE
function GlobalCoolDown.prototype:GetOptions()
	local opts = GlobalCoolDown.super.prototype.GetOptions(self)

	opts["shouldAnimate"] = nil
	opts["desiredLerpTime"] = nil
	opts["lowThreshold"] = nil
	opts["textSettings"] = nil
	
	return opts	
end

-- 'Protected' methods --------------------------------------------------------

function _FindSpellId(spellName)
	if not spellName then
		return nil
	end

	for tab = 1, 4 do
		local _, _, offset, numSpells = GetSpellTabInfo(tab)

		for i = (1+offset), (offset+numSpells) do
			local spell = GetSpellName(i, BOOKTYPE_SPELL)

			if spell:lower() == spellName:lower() then
				return i
			end
		end
	end

	return nil
end

function GlobalCoolDown.prototype:UpdateSpell()
	if not self.spellId then
		self.spellId = _FindSpellId(self:GetSpellName())
	end	
end

function GlobalCoolDown.prototype:CooldownStateChanged()
	self:UpdateSpell()

	if not self.spellId then
		return
	end

	local start, dur = GetSpellCooldown(self.spellId, BOOKTYPE_SPELL)

	if dur > 0 and dur <= 1.5 then
		self.startTime = start
		self.duration = dur

	self.CurrScale = 1
		self.frame:SetFrameStrata("TOOLTIP")
		self:Show(true)
		self.frame.bg:SetAlpha(0)
	else
		self.duration = nil
		self.startTime = nil

		self:Show(false)
	end
end

function GlobalCoolDown.prototype:UpdateGlobalCoolDown()
	if (self.duration ~= nil) and (self.startTime ~= nil) then
		remaining = GetTime() - self.startTime

		if (remaining > self.duration) then
			self.duration = nil
			self.startTime = nil

			self:Show(false)
		else
			self:UpdateBar(1 - (self.duration ~= 0 and remaining / self.duration or 0), "GlobalCoolDown", 0.8)
		end
	else
		self:Show(false)
	end
end

-- Load us up
IceHUD.GlobalCoolDown = GlobalCoolDown:new()
