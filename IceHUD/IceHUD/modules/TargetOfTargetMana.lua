local AceOO = AceLibrary("AceOO-2.0")

local TargetTargetMana = AceOO.Class(IceTargetMana)

local SelfDisplayModeOptions = {"Hide", "Normal"}

-- Constructor --
function TargetTargetMana.prototype:init()
	TargetTargetMana.super.prototype.init(self, "TargetTargetMana", "targettarget")

	self:SetDefaultColor("TargetTargetMana", 52, 64, 221)
	self:SetDefaultColor("TargetTargetRage", 235, 44, 26)
	self:SetDefaultColor("TargetTargetEnergy", 228, 242, 31)
	self:SetDefaultColor("TargetTargetFocus", 242, 149, 98)
	self:SetDefaultColor("TargetTargetRunicPower", 52, 64, 221)
end

function TargetTargetMana.prototype:GetDefaultSettings()
	local settings = TargetTargetMana.super.prototype.GetDefaultSettings(self)

	settings["side"] = IceCore.Side.Right
	settings["offset"] = 11
	settings["upperText"] = "[PercentMP:Round]"
	settings["lowerText"] = "[FractionalMP:PowerColor]"
	settings["barVerticalOffset"] = 35
	settings["scale"] = 0.7
	settings["enabled"] = false
	settings["selfDisplayMode"] = "Normal"

	return settings
end

function TargetTargetMana.prototype:GetOptions()
	local opts = TargetTargetMana.super.prototype.GetOptions(self)

	opts["selfDisplayMode"] = {
		type = "text",
		name = "Self Display Mode",
		desc = "What this bar should do whenever the player is the TargetOfTarget",
		get = function()
			return self.moduleSettings.selfDisplayMode
		end,
		set = function(value)
			self.moduleSettings.selfDisplayMode = value
			self:Redraw()
		end,
		disabled = function()
			return not self.moduleSettings.enabled
		end,
		validate = SelfDisplayModeOptions,
		order = 44,
	}
	
	return opts
end

function TargetTargetMana.prototype:Enable(core)
	self.registerEvents = false
	-- make sure the super class doesn't override our color selection
	self.determineColor = false
	TargetTargetMana.super.prototype.Enable(self, core)

	self:ScheduleRepeatingEvent(self.elementName, self.Update, 0.1, self, "targettarget")
end

function TargetTargetMana.prototype:Disable(core)
	TargetTargetMana.super.prototype.Disable(self, core)

	self:CancelScheduledEvent(self.elementName)
end

function TargetTargetMana.prototype:Update(unit)
	self.color = "TargetTargetMana"

	if self.moduleSettings.selfDisplayMode == "Hide" and UnitIsUnit("player", self.unit) then
		self:Show(false)
		return
	end

	self:Show(true)

	local manaType = UnitPowerType(self.unit)

	if (self.moduleSettings.scaleManaColor) then
		self.color = "ScaledManaColor"
	end

	if (manaType == 1) then
		self.color = "TargetTargetRage"
	elseif (manaType == 2) then
		self.color = "TargetTargetFocus"
	elseif (manaType == 3) then
		self.color = "TargetTargetEnergy"
	elseif (manaType == 6) then
		self.color = "TargetTargetRunicPower"
	end

	if (self.tapped) then
		self.color = "Tapped"
	end

	TargetTargetMana.super.prototype.Update(self, unit)
end

-- Load us up
IceHUD.TargetTargetMana = TargetTargetMana:new()
