local AceOO = AceLibrary("AceOO-2.0")

local FocusMana = AceOO.Class(IceUnitBar)


-- Constructor --
function FocusMana.prototype:init()
	FocusMana.super.prototype.init(self, "FocusMana", "focus")
	
	self:SetDefaultColor("FocusMana", 52, 64, 221)
	self:SetDefaultColor("FocusRage", 235, 44, 26)
	self:SetDefaultColor("FocusEnergy", 228, 242, 31)
	self:SetDefaultColor("FocusFocus", 242, 149, 98)
end


function FocusMana.prototype:GetDefaultSettings()
	local settings = FocusMana.super.prototype.GetDefaultSettings(self)

	settings["enabled"] = false
	settings["side"] = IceCore.Side.Right
	settings["offset"] = -2
	settings["scale"] = 0.7
	settings["upperText"] = "[PercentMP:Round]"
	settings["lowerText"] = ""
	settings["barVerticalOffset"] = 35

	return settings
end


function FocusMana.prototype:Enable(core)
	FocusMana.super.prototype.Enable(self, core)

	self:RegisterEvent("UNIT_MANA", "Update")
	self:RegisterEvent("UNIT_MAXMANA", "Update")
	self:RegisterEvent("UNIT_RAGE", "Update")
	self:RegisterEvent("UNIT_MAXRAGE", "Update")
	self:RegisterEvent("UNIT_ENERGY", "Update")
	self:RegisterEvent("UNIT_MAXENERGY", "Update")
	self:RegisterEvent("UNIT_FOCUS", "Update")
	self:RegisterEvent("UNIT_MAXFOCUS", "Update")
	self:RegisterEvent("UNIT_AURA", "Update")
	self:RegisterEvent("UNIT_FLAGS", "Update")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED", "UpdateFocus")

	self:Update(self.unit)
end

function FocusMana.prototype:UpdateFocus()
	self:Update(self.unit)
end

function FocusMana.prototype:Update(unit)
	FocusMana.super.prototype.Update(self)
	if (unit and (unit ~= self.unit)) then
		return
	end
	
	if ((not UnitExists(unit)) or (self.maxMana == 0)) then
		self:Show(false)
		return
	else	
		self:Show(true)
	end
	
	
	local manaType = UnitPowerType(self.unit)
	
	local color = "FocusMana"
	if (self.moduleSettings.scaleManaColor) then
		color = "ScaledManaColor"
	end
	if (manaType == 1) then
		color = "FocusRage"
	elseif (manaType == 2) then
		color = "FocusFocus"
	elseif (manaType == 3) then
		color = "FocusEnergy"
	end
	
	if (self.tapped) then
		color = "Tapped"
	end
	
	self:UpdateBar(self.manaPercentage, color)

	if not IceHUD.IceCore:ShouldUseDogTags() then
		self:SetBottomText1(math.floor(self.manaPercentage * 100))
		self:SetBottomText2(self:GetFormattedText(self.mana, self.maxMana), color)
	end
end


-- OVERRIDE
function FocusMana.prototype:GetOptions()
	local opts = FocusMana.super.prototype.GetOptions(self)

	opts["scaleManaColor"] = {
		type = "toggle",
		name = "Color bar by mana %",
		desc = "Colors the mana bar from MaxManaColor to MinManaColor based on current mana %",
		get = function()
			return self.moduleSettings.scaleManaColor
		end,
		set = function(value)
			self.moduleSettings.scaleManaColor = value
			self:Redraw()
		end,
		disabled = function()
			return not self.moduleSettings.enabled
		end,
		order = 51
	}

	return opts
end


-- Load us up
IceHUD.FocusMana = FocusMana:new()
