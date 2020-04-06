local AceOO = AceLibrary("AceOO-2.0")

IceCustomMana = AceOO.Class(IceTargetMana)

-- Constructor --
function IceCustomMana.prototype:init()
	IceCustomMana.super.prototype.init(self, "IceCustomMana", "focustarget")
-- these aren't working...don't know why
--[[	self:SetDefaultColor("CustomManaMana", 52, 64, 221)
	self:SetDefaultColor("CustomManaRage", 235, 44, 26)
	self:SetDefaultColor("CustomManaEnergy", 228, 242, 31)
	self:SetDefaultColor("CustomManaFocus", 242, 149, 98)
	self:SetDefaultColor("CustomManaRunicPower", 52, 64, 221)
]]--
end

function IceCustomMana.prototype:GetDefaultSettings()
	local settings = IceCustomMana.super.prototype.GetDefaultSettings(self)

	settings["side"] = IceCore.Side.Left
	settings["offset"] = -4
	settings["classColor"] = false
	settings["barVerticalOffset"] = 0
	settings["scale"] = 1
	settings["customBarType"] = "Mana"
	settings["unitToTrack"] = "focustarget"

	return settings
end


-- OVERRIDE
function IceCustomMana.prototype:GetOptions()
	local opts = IceCustomMana.super.prototype.GetOptions(self)

	opts["hideBlizz"] = nil

	opts["customHeader"] = {
		type = 'header',
		name = "Custom bar settings",
		order = 20.1,
	}

	opts["deleteme"] = {
		type = 'execute',
		name = 'Delete me',
		desc = 'Deletes this custom module and all associated settings. Cannot be undone!',
		func = function()
			local dialog = StaticPopup_Show("ICEHUD_DELETE_CUSTOM_MODULE")
			if dialog then
				dialog.data = self
			end
		end,
		order = 20.2,
	}

	opts["name"] = {
		type = 'text',
		name = 'Bar name',
		desc = 'The name of this bar (must be unique!).\n\nRemember to press ENTER after filling out this box with the name you want or it will not save.',
		get = function()
			return self.elementName
		end,
		set = function(v)
			if v~= "" then
				IceHUD.IceCore:RenameDynamicModule(self, v)
			end
		end,
		disabled = function()
			return not self.moduleSettings.enabled
		end,
		usage = "<a name for this bar>",
		order = 20.3,
	}

	opts["unitToTrack"] = {
		type = 'text',
		name = 'Unit to track',
		desc = 'Enter which unit that this bar should be monitoring the mana of (e.g.: focustarget, pettarget, etc.)\n\nRemember to press ENTER after filling out this box with the name you want or it will not save.',
		get = function()
			return self.moduleSettings.unitToTrack
		end,
		set = function(v)
			v = string.lower(v)
			self.moduleSettings.unitToTrack = v
			self:SetUnit(v)
			self:Redraw()
			self:CheckCombat()
		end,
		disabled = function()
			return not self.moduleSettings.enabled
		end,
		order = 20.4,
	}

	return opts
end


function IceCustomMana.prototype:Enable(core)
	self.registerEvents = false
	self:SetUnit(self.moduleSettings.unitToTrack)
	IceCustomMana.super.prototype.Enable(self, core)

	self:CreateFrame()

	self:ScheduleRepeatingEvent(self.elementName, self.Update, IceHUD.IceCore:UpdatePeriod(), self)
end

function IceCustomMana.prototype:Disable(core)
	IceCustomMana.super.prototype.Disable(self, core)

	self:CancelScheduledEvent(self.elementName)
end
--[[
function IceCustomMana.prototype:Update(unit)
	self.color = "CustomManaMana"

	self:Show(true)

	local manaType = UnitPowerType(self.unit)

	if (self.moduleSettings.scaleManaColor) then
		self.color = "CustomManaColor"
	end

	if (manaType == 1) then
		self.color = "CustomManaRage"
	elseif (manaType == 2) then
		self.color = "CustomManaFocus"
	elseif (manaType == 3) then
		self.color = "CustomManaEnergy"
	elseif (manaType == 6) then
		self.color = "CustomManaRunicPower"
	end

	if (self.tapped) then
		self.color = "Tapped"
	end

	IceCustomMana.super.prototype.Update(self, unit)
end
]]--
function IceCustomMana.prototype:SetUnit(unit)
	IceCustomMana.super.prototype.SetUnit(self, unit)
	if self.frame ~= nil and self.frame.button ~= nil then
		self.frame.button:SetAttribute("unit", self.unit)
	end
	self:RegisterFontStrings()
end
