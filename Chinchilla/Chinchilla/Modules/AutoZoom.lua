
local AutoZoom = Chinchilla:NewModule("AutoZoom", "AceHook-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Chinchilla")

AutoZoom.displayName = L["Auto zoom"]
AutoZoom.desc = L["Automatically zoom out after a specified time."]


function AutoZoom:OnInitialize()
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


function AutoZoom:OnEnable()
	self:SecureHook(Minimap, "SetZoom", "Minimap_SetZoom")
end

function AutoZoom:OnDisable()
	self:CancelAllTimers()
end


function AutoZoom:Minimap_SetZoom(_, zoomLevel)
	if zoomLevel > 0 then
		self:ScheduleTimer("ZoomOut", self.db.profile.time)
	end
end

function AutoZoom:ZoomOut()
	Minimap:SetZoom(0)
end


function AutoZoom:GetOptions()
	return {
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
			end,
		},
	}
end
