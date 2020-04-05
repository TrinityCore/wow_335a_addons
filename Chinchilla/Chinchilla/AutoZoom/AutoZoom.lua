local Chinchilla = Chinchilla
local Chinchilla_AutoZoom = Chinchilla:NewModule("AutoZoom", "AceHook-3.0")
local self = Chinchilla_AutoZoom
local L = Chinchilla.L

Chinchilla_AutoZoom.desc = L["Automatically zoom out after a specified time."]

function Chinchilla_AutoZoom:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("AutoZoom", {
		profile = {
			time = 20,
			enabled = true,
		}
	})
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local frame
local nextZoomOutTime = 0
function Chinchilla_AutoZoom:OnEnable()
	if not frame then
		frame = CreateFrame("Frame")
		frame:SetScript("OnUpdate", function(this, elapsed)
			local currentTime = GetTime()
			if nextZoomOutTime <= currentTime then
				if Minimap:GetZoom() > 0 then
					Minimap_ZoomOut()
					nextZoomOutTime = currentTime -- reset and do it every frame
				else
					this:Hide()
				end
			end
		end)
	end
	frame:Show()
	self:SecureHook(Minimap, "SetZoom", "Minimap_SetZoom")
end

function Chinchilla_AutoZoom:OnDisable()
	frame:Hide()
end

function Chinchilla_AutoZoom:Minimap_SetZoom(...)
	frame:Show()
	nextZoomOutTime = GetTime() + self.db.profile.time
end

Chinchilla_AutoZoom:AddChinchillaOption(function() return {
	name = L["Auto zoom"],
	desc = Chinchilla_AutoZoom.desc,
	type = 'group',
	args = {
		time = {
			name = L["Time to zoom"],
			desc = L["Set the time it takes between manually zooming in and automatically zooming out"],
			type = 'range',
			min = 1,
			max = 60,
			step = 0.1,
			bigStep = 1,
			get = function(info)
				return self.db.profile.time
			end,
			set = function(info, value)
				self.db.profile.time = value
			end
		}
	}
} end)
