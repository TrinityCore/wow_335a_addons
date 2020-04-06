local AceOO = AceLibrary("AceOO-2.0")

local PetMana = AceOO.Class(IceUnitBar)

-- Constructor --
function PetMana.prototype:init()
	PetMana.super.prototype.init(self, "PetMana", "pet")
	
	self:SetDefaultColor("PetMana", 62, 54, 152)
	self:SetDefaultColor("PetRage", 171, 59, 59)
	self:SetDefaultColor("PetEnergy", 218, 231, 31)
	self:SetDefaultColor("PetFocus", 242, 149, 98)
	
	self.scalingEnabled = true
end


-- OVERRIDE
function PetMana.prototype:GetDefaultSettings()
	local settings = PetMana.super.prototype.GetDefaultSettings(self)

	settings["side"] = IceCore.Side.Left
	settings["offset"] = -2
	settings.scale = 0.7
	settings["textVerticalOffset"] = 4
	settings["upperText"] = "[PercentMP:Round]"
	settings["lowerText"] = ""
	settings["barVerticalOffset"] = 35

	return settings
end


-- OVERRIDE
--[[
function PetMana.prototype:CreateFrame()
	PetMana.super.prototype.CreateFrame(self)

	local point, relativeTo, relativePoint, xoff, yoff = self.frame.bottomUpperText:GetPoint()
	if (point == "TOPLEFT") then
		point = "BOTTOMLEFT"
	else
		point = "BOTTOMRIGHT"
	end
	
	self.frame.bottomUpperText:ClearAllPoints()
	self.frame.bottomUpperText:SetPoint(point, relativeTo, relativePoint, 0, 0)
end
]]

function PetMana.prototype:Enable(core)
	PetMana.super.prototype.Enable(self, core)

	self:RegisterEvent("PET_UI_UPDATE",	 "CheckPet");
	self:RegisterEvent("PLAYER_PET_CHANGED", "CheckPet");
	self:RegisterEvent("PET_BAR_CHANGED", "CheckPet");
	self:RegisterEvent("UNIT_PET", "CheckPet");
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "CheckPet")

	self:RegisterEvent("UNIT_MANA", "Update")
	self:RegisterEvent("UNIT_MAXMANA", "Update")
	self:RegisterEvent("UNIT_RAGE", "Update")
	self:RegisterEvent("UNIT_MAXRAGE", "Update")
	self:RegisterEvent("UNIT_ENERGY", "Update")
	self:RegisterEvent("UNIT_MAXENERGY", "Update")
	self:RegisterEvent("UNIT_FOCUS", "Update")
	self:RegisterEvent("UNIT_MAXFOCUS", "Update")

	self:RegisterEvent("UNIT_DISPLAYPOWER", "ManaType")

	self:CheckPet()
	self:ManaType(self.unit)
end


function PetMana.prototype:CheckPet()
	self:CheckForVehicle()

	if (UnitExists(self.unit)) then
		self:Show(true)
		self:ManaType(self.unit)
		self:Update(self.unit)
	else
		self:Show(false)
	end
end


function PetMana.prototype:ManaType(unit)
	if (unit ~= self.unit) then
		return
	end
	
	self.manaType = UnitPowerType(self.unit)
	self:Update(self.unit)
end


function PetMana.prototype:SetupOnUpdate(enable)
	if enable then
		self.frame:SetScript("OnUpdate", function() self:Update(self.unit) end)
	else
		-- make sure the animation has a chance to finish filling up the bar before we cut it off completely
		if self.CurrScale ~= self.DesiredScale then
			self.frame:SetScript("OnUpdate", function() self:MyOnUpdate() end)
		else
			self.frame:SetScript("OnUpdate", nil)
		end
	end
end


function PetMana.prototype:MyOnUpdate()
	PetMana.super.prototype.MyOnUpdate(self)

	if self.CurrScale == self.DesiredScale then
		self:SetupOnUpdate(false)
	end
end


function PetMana.prototype:CheckForVehicle()
	local lastUnit = self.unit

	if UnitIsUnit("pet", "vehicle") or UnitHasVehicleUI("player") then
		self.unit = "vehicle"
	else
		self.unit = "pet"
	end

	if self.unit ~= lastUnit then
		self:ManaType(self.unit)
	end
end


function PetMana.prototype:Update(unit)
	self:CheckForVehicle()

	PetMana.super.prototype.Update(self)

	if (unit and (unit ~= self.unit)) then
		return
	end

	if ((not UnitExists(unit)) or (self.maxMana == 0)) then
		self:Show(false)
		return
	else
		self:Show(true)
	end

	if (self.manaPercentage == 1 and self.manaType ~= 1 and self.manaType ~= 6)
		or (self.manaPercentage == 0 and (self.manaType == 1 or self.manaType == 6)) then
		self:SetupOnUpdate(false)
	elseif GetCVarBool("predictedPower") then
		self:SetupOnUpdate(true)
	end

	local color = "PetMana"
	if (self.moduleSettings.scaleManaColor) then
		color = "ScaledManaColor"
	end
	if not (self.alive) then
		color = "Dead"
	else
		if (self.manaType == 1) then
			color = "PetRage"
		elseif (self.manaType == 2) then
			color = "PetFocus"
		elseif (self.manaType == 3) then
			color = "PetEnergy"
		end
	end

	if self.maxMana > 0 then
		self:UpdateBar(self.manaPercentage, color)
	end

	if not IceHUD.IceCore:ShouldUseDogTags() then
		self:SetBottomText1(math.floor(self.manaPercentage * 100))
	end
end


-- OVERRIDE
function PetMana.prototype:GetOptions()
	local opts = PetMana.super.prototype.GetOptions(self)

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
IceHUD.PetMana = PetMana:new()
