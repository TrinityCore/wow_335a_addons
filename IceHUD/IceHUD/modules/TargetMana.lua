local AceOO = AceLibrary("AceOO-2.0")

IceTargetMana = AceOO.Class(IceUnitBar)
IceTargetMana.prototype.registerEvents = true
IceTargetHealth.prototype.color = nil
IceTargetMana.prototype.determineColor = true


-- Constructor --
function IceTargetMana.prototype:init(moduleName, unit)
	if not moduleName or not unit then
		IceTargetMana.super.prototype.init(self, "TargetMana", "target")
	else
		IceTargetMana.super.prototype.init(self, moduleName, unit)
	end
	
	self:SetDefaultColor("TargetMana", 52, 64, 221)
	self:SetDefaultColor("TargetRage", 235, 44, 26)
	self:SetDefaultColor("TargetEnergy", 228, 242, 31)
	self:SetDefaultColor("TargetFocus", 242, 149, 98)
	self:SetDefaultColor("TargetRunicPower", 52, 64, 221)
end


function IceTargetMana.prototype:GetDefaultSettings()
	local settings = IceTargetMana.super.prototype.GetDefaultSettings(self)

	settings["side"] = IceCore.Side.Right
	settings["offset"] = 2
	settings["upperText"] = "[PercentMP:Round]"
	settings["lowerText"] = "[FractionalMP:PowerColor]"
	settings["onlyShowMana"] = false

	return settings
end


function IceTargetMana.prototype:Enable(core)
	IceTargetMana.super.prototype.Enable(self, core)

	if self.registerEvents then
		self:RegisterEvent("UNIT_MAXMANA", "Update")
		self:RegisterEvent("UNIT_MAXRAGE", "Update")
		self:RegisterEvent("UNIT_MAXENERGY", "Update")
		self:RegisterEvent("UNIT_MAXFOCUS", "Update")
		self:RegisterEvent("UNIT_AURA", "Update")
		self:RegisterEvent("UNIT_FLAGS", "Update")

		self:RegisterEvent("UNIT_MANA", "Update")
		self:RegisterEvent("UNIT_RAGE", "Update")
		self:RegisterEvent("UNIT_ENERGY", "Update")
		self:RegisterEvent("UNIT_FOCUS", "Update")

		-- DK rune stuff
		if IceHUD.WowVer >= 30000 then
			self:RegisterEvent("UNIT_RUNIC_POWER", "Update")
			self:RegisterEvent("UNIT_MAXRUNIC_POWER", "Update")
		end
	end

	self:Update(self.unit)
end



function IceTargetMana.prototype:Update(unit)
	IceTargetMana.super.prototype.Update(self)
	if (unit and (unit ~= self.unit)) then
		return
	end

	if ((not UnitExists(self.unit)) or (self.maxMana == 0)) then
		self:Show(false)
		return
	else	
		self:Show(true)
	end

	local manaType = UnitPowerType(self.unit)

	if self.moduleSettings.onlyShowMana and manaType ~= 0 then
		self:Show(false)
		return
	end

	if self.determineColor then
		self.color = "TargetMana"

		if (self.moduleSettings.scaleManaColor) then
			self.color = "ScaledManaColor"
		end

		if (manaType == 1) then
			self.color = "TargetRage"
		elseif (manaType == 2) then
			self.color = "TargetFocus"
		elseif (manaType == 3) then
			self.color = "TargetEnergy"
		elseif (manaType == 6) then
			self.color = "TargetRunicPower"
		end

		if (self.tapped) then
			self.color = "Tapped"
		end
	end
	
	self:UpdateBar(self.manaPercentage, self.color)

	if not IceHUD.IceCore:ShouldUseDogTags() then
		self:SetBottomText1(math.floor(self.manaPercentage * 100))
		self:SetBottomText2(self:GetFormattedText(self.mana, self.maxMana), color)
	end
end


-- OVERRIDE
function IceTargetMana.prototype:GetOptions()
	local opts = IceTargetMana.super.prototype.GetOptions(self)

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

	opts["onlyShowMana"] = {
		type = 'toggle',
		name = 'Only show if target uses mana',
		desc = 'Will only show this bar if the target uses mana (as opposed to rage, energy, runic power, etc.)',
		get = function()
			return self.moduleSettings.onlyShowMana
		end,
		set = function(v)
			self.moduleSettings.onlyShowMana = v
			self:Redraw()
		end,
		disabled = function()
			return not self.moduleSettings.enabled
		end
	}

	return opts
end


-- Load us up
IceHUD.TargetMana = IceTargetMana:new()
