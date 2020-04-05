
local ShowHide = Chinchilla:NewModule("ShowHide", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Chinchilla")

ShowHide.displayName = L["Show / Hide"]
ShowHide.desc = L["Show and hide interface elements of the minimap"]


function ShowHide:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("ShowHide", {
		profile = {
			boss = true,
			battleground = true,
			north = true,
			locationBar = true,
			locationText = true,
			difficulty = true,
			map = true,
			mail = true,
			lfg = true,
			dayNight = true,
			track = true,
			voice = true,
			zoom = true,
			record = true,
			vehicleSeats = true,
			ticketStatus = true,

			enabled = true,
		},
	})

	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local frames = {
	boss = Chinchilla_BossAnchor,
	battleground = MiniMapBattlefieldFrame,
	difficulty = MiniMapInstanceDifficulty,
	north = MinimapNorthTag,
	map = MiniMapWorldMapButton,
	mail = MiniMapMailFrame,
	lfg = MiniMapLFGFrame,
	dayNight = GameTimeFrame,
	track = MiniMapTracking,
	voice = MiniMapVoiceChatFrame,
	zoomIn = MinimapZoomIn,
	zoomOut = MinimapZoomOut,
	vehicleSeats = VehicleSeatIndicator,
	record = IsMacClient() and MiniMapRecordingButton or nil,
}

local framesShown = {}

function ShowHide:OnEnable()
	for k,v in pairs(frames) do
		framesShown[v] = v:IsShown()
		self:SecureHook(frames[k], "Show", "frame_Show")
		self:SecureHook(frames[k], "Hide", "frame_Hide")
	end

	framesShown[MinimapZoneTextButton] = not not MinimapZoneTextButton:IsShown()

	self:SecureHook(MinimapZoneTextButton, "Show", "MinimapZoneTextButton_Show")
	self:SecureHook(MinimapZoneTextButton, "Hide", "MinimapZoneTextButton_Hide")
	self:Update()
end

function ShowHide:OnDisable()
	for k, v in pairs(frames) do
		if framesShown[v] then
			v:Show()
		end
	end

	if framesShown[MinimapZoneTextButton] then
		MinimapBorderTop:Show()
		MinimapZoneTextButton:Show()
	end
end

function ShowHide:Update()
	if not self:IsEnabled() then return end

	for key, frame in pairs(frames) do
		if key == "zoomOut" or key == "zoomIn" then
			key = "zoom"
		end

		local value = self.db.profile[key]

		if key == "boss" then
			self:SetBoss(value)
		elseif not value then
		 	if frame:IsShown() then
				frame:Hide()
				framesShown[frame] = true
			end
		else
			if framesShown[frame] then
				frame:Show()
			end
		end
	end

	if Chinchilla:GetModule("Location", true) and Chinchilla:GetModule("Location"):IsEnabled() then
		MinimapBorderTop:Hide()
		MinimapZoneTextButton:Hide()
	elseif not self.db.profile.locationBar then
		MinimapBorderTop:Hide()

		if not self.db.profile.locationText then
			MinimapZoneTextButton:Hide()
		else
			MinimapZoneTextButton:Show()
		end
	else
		MinimapBorderTop:Show()
		MinimapZoneTextButton:Show()
	end
end

function ShowHide:frame_Show(object)
	local object_k

	for k,v in pairs(frames) do
		if v == object then
			if k == "zoomIn" or k == "zoomOut" then
				object_k = "zoom"
			else
				object_k = k
			end
			break
		end
	end

	if object_k and not self.db.profile[object_k] then
		object:Hide()
	end

	framesShown[object] = true
end

function ShowHide:frame_Hide(object)
	framesShown[object] = false
end


function ShowHide:MinimapZoneTextButton_Show(object)
	if not self.db.profile.locationText or (Chinchilla:GetModule("Location", true) and Chinchilla:GetModule("Location"):IsEnabled()) then
		MinimapBorderTop:Hide()
		MinimapZoneTextButton:Hide()
	end

	framesShown[object] = true
end

function ShowHide:MinimapZoneTextButton_Hide(object)
	framesShown[object] = false
end


function ShowHide:SetBoss(value)
	if value then
		Boss1TargetFrame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		Boss2TargetFrame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		Boss3TargetFrame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		Boss4TargetFrame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	else
		Boss1TargetFrame:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		Boss2TargetFrame:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		Boss3TargetFrame:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		Boss4TargetFrame:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	end
end


function ShowHide:GetOptions()
	local function get(info)
		local key = info[#info]
		return self.db.profile[key]
	end

	local function set(info, value)
		local key = info[#info]

		self.db.profile[key] = value
		self:Update(key, value)
	end

	return {
		battleground = {
			name = L["Battleground"],
			desc = L["Show the battleground indicator"],
			type = 'toggle',
			get = get,
			set = set,
		},
		north = {
			name = L["North"],
			desc = L["Show the north symbol on the minimap"],
			type = 'toggle',
			get = get,
			set = set,
		},
		difficulty = {
			name = L["Instance difficulty"],
			desc = L["Show the instance difficulty flag on the minimap"],
			type = 'toggle',
			get = get,
			set = set,
		},
		locationBar = {
			name = L["Location bar"],
			desc = L["Show the location bar above the minimap"],
			type = 'toggle',
			get = get,
			set = set,
			disabled = function()
				return not self.db.profile.locationText
			end,
		},
		locationText = {
			name = L["Location text"],
			desc = L["Show the location text above the minimap"],
			type = 'toggle',
			get = get,
			set = set,
		},
		map = {
			name = L["World map"],
			desc = L["Show the world map button"],
			type = 'toggle',
			get = get,
			set = set,
		},
		mail = {
			name = L["Mail"],
			desc = L["Show the mail indicator"],
			type = 'toggle',
			get = get,
			set = set,
		},
		lfg = {
			name = L["LFG"],
			desc = L["Show the looking for group indicator"],
			type = 'toggle',
			get = get,
			set = set,
		},
		dayNight = {
			name = L["Calendar"],
			desc = L["Show the calendar"],
			type = 'toggle',
			get = get,
			set = set,
		},
		clock = {
			name = L["Clock"],
			desc = L["Show the clock"],
			type = 'toggle',
			get = function(info)
				return GetCVar("showClock") == "1"
			end,
			set = function(info, value)
				SetCVar("showClock", value and "1" or "0")
				InterfaceOptionsDisplayPanelShowClock_SetFunc(value and "1" or "0")
			end,
		},
		track = {
			name = L["Tracking"],
			desc = L["Show the tracking indicator"],
			type = 'toggle',
			get = get,
			set = set,
		},
		voice = {
			name = L["Voice chat"],
			desc = L["Show the voice chat button"],
			type = 'toggle',
			get = get,
			set = set,
		},
		zoom = {
			name = L["Zoom"],
			desc = L["Show the zoom in and out buttons"],
			type = 'toggle',
			get = get,
			set = set,
		},
		record = IsMacClient() and {
			name = L["Recording"],
			desc = L["Show the recording button"],
			type = 'toggle',
			get = get,
			set = set,
		} or nil,
		vehicleSeats = {
			name = L["Vehicle seats"],
			desc = L["Show the vehicle seats indicator"],
			type = 'toggle',
			get = get,
			set = set,
		},
		boss = {
			name = L["Boss frames"],
			desc = L["Show the boss unit frames"],
			type = "toggle",
			get = get,
			set = set,
		},
	}
end
