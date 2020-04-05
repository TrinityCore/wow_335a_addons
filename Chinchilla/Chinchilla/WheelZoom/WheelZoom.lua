local Chinchilla = Chinchilla
local Chinchilla_WheelZoom = Chinchilla:NewModule("WheelZoom")
local self = Chinchilla_WheelZoom
local L = Chinchilla.L

Chinchilla_WheelZoom.desc = L["Use the mouse wheel to zoom in and out on the minimap."]

function Chinchilla_WheelZoom:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("WheelZoom", {
		profile = {
			enabled = true,
		}
	})
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local frame
function Chinchilla_WheelZoom:OnEnable()
	if not frame then
		frame = CreateFrame("Frame", "Chinchilla_WheelZoom_Frame", Minimap)
		frame:SetAllPoints(Minimap)
		frame:SetScript("OnMouseWheel", function(this, change)
			if change > 0 then
				Minimap_ZoomIn()
			else
				Minimap_ZoomOut()
			end
		end)
	end
	frame:EnableMouseWheel(true)
end

function Chinchilla_WheelZoom:OnDisable()
	frame:EnableMouseWheel(false)
end

Chinchilla_WheelZoom:AddChinchillaOption(function() return {
	name = L["Wheel zoom"],
	desc = Chinchilla_WheelZoom.desc,
	type = 'group',
	args = {
	}
} end)
