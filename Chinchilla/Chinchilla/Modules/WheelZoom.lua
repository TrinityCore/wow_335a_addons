
local WheelZoom = Chinchilla:NewModule("WheelZoom")
local L = LibStub("AceLocale-3.0"):GetLocale("Chinchilla")

WheelZoom.displayName = L["Wheel zoom"]
WheelZoom.desc = L["Use the mouse wheel to zoom in and out on the minimap."]


function WheelZoom:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("WheelZoom", {
		profile = {
			enabled = true,
		},
	})

	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local frame
function WheelZoom:OnEnable()
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

function WheelZoom:OnDisable()
	frame:EnableMouseWheel(false)
end

--[[
function WheelZoom:GetOptions()
	return {
	}
end
]]--