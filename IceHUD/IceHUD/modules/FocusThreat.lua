local AceOO = AceLibrary("AceOO-2.0")

local IceFocusThreat = AceOO.Class(IceThreat)

-- constructor
function IceFocusThreat.prototype:init()
	IceFocusThreat.super.prototype.init(self, "FocusThreat", "focus")
end

function IceFocusThreat.prototype:GetDefaultSettings()
	local settings = IceFocusThreat.super.prototype.GetDefaultSettings(self)

	settings["side"] = IceCore.Side.Right
	settings["offset"] = 4

	return settings
end

-- Load us up
IceHUD.IceFocusThreat = IceFocusThreat:new()
