local Chinchilla = Chinchilla
local Chinchilla_Compass = Chinchilla:NewModule("Compass")
local self = Chinchilla_Compass
local L = Chinchilla.L

Chinchilla_Compass.desc = L["Show direction indicators on the minimap"]

function Chinchilla_Compass:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("Compass", {
		profile = {
			radius = 61,
			color = { 1, 0.82, 0, 1 },
			fontSize = 12,
			nonNorthSize = 0.8,
			enabled = false,
		}
	})
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local rotateMinimap

local function hideBlizzDirections()
	MinimapCompassTexture:Hide()
	MinimapNorthTag:Hide()
end

local hideBlizzDirections_frame = CreateFrame("Frame")
hideBlizzDirections_frame:Hide()
hideBlizzDirections_frame:SetScript("OnUpdate", function(self)
	self:Hide()
	hideBlizzDirections()
end)

local frame
local function repositionCompass()
	hideBlizzDirections_frame:Show()
	local angle = 0
	if rotateMinimap then
		angle = -GetPlayerFacing()
	end
	local radius = Chinchilla_Compass.db.profile.radius
	frame.east:SetPoint("CENTER", Minimap, "CENTER", radius*math.cos(angle), radius*math.sin(angle))
	frame.north:SetPoint("CENTER", Minimap, "CENTER", radius*math.cos(angle + math.pi/2), radius*math.sin(angle + math.pi/2))
	frame.west:SetPoint("CENTER", Minimap, "CENTER", radius*math.cos(angle + math.pi), radius*math.sin(angle + math.pi))
	frame.south:SetPoint("CENTER", Minimap, "CENTER", radius*math.cos(angle + math.pi*3/2), radius*math.sin(angle + math.pi*3/2))
end

function Chinchilla_Compass:OnEnable()
	if not frame then
		frame = CreateFrame("Frame", "Chinchilla_Compass_Frame", Minimap)
		frame:SetAllPoints()
		local north = frame:CreateFontString(frame:GetName() .. "_North", "ARTWORK", "GameFontNormal")
		frame.north = north
		north:SetText("N")
		local east = frame:CreateFontString(frame:GetName() .. "_East", "ARTWORK", "GameFontNormalSmall")
		frame.east = east
		east:SetText("E")
		local south = frame:CreateFontString(frame:GetName() .. "_South", "ARTWORK", "GameFontNormalSmall")
		frame.south = south
		south:SetText("S")
		local west = frame:CreateFontString(frame:GetName() .. "_West", "ARTWORK", "GameFontNormalSmall")
		frame.west = west
		west:SetText("W")
	end

	hideBlizzDirections()
	frame:Show()

	rotateMinimap = GetCVar("rotateMinimap") == "1" -- delay CVar check otherwise compass won't rotate after exitting
	repositionCompass()
	if rotateMinimap then
		frame:SetScript("OnUpdate", repositionCompass)
	end
	self:SetFontSize(nil)
	self:SetColor(nil)
end

function Chinchilla_Compass:OnDisable()
	frame:Hide()
	if rotateMinimap then
		MinimapCompassTexture:Show()
	else
		MinimapNorthTag:Show()
	end
end

function Chinchilla_Compass:OnRotateMinimapUpdate(value)
	rotateMinimap = value
	if self:IsEnabled() then
		if value then
			frame:SetScript("OnUpdate", repositionCompass)
		else
			frame:SetScript("OnUpdate", nil)
			repositionCompass()
		end
	end
end

function Chinchilla_Compass:SetRadius(value)
	Chinchilla_Compass.db.profile.radius = value
	if self:IsEnabled() then
		repositionCompass()
	end
end

function Chinchilla_Compass:SetColor(r, g, b, a)
	local color = Chinchilla_Compass.db.profile.color

	if r then
		color[1] = r
		color[2] = g
		color[3] = b
		color[4] = a
	else
		r, g, b, a = unpack(color)
	end
	
	if frame then
		frame.north:SetTextColor(r, g, b, a)
		frame.east:SetTextColor(r, g, b, a)
		frame.south:SetTextColor(r, g, b, a)
		frame.west:SetTextColor(r, g, b, a)
	end
end

function Chinchilla_Compass:SetFontSize(value)
	if value then
		self.db.profile.fontSize = value
	else
		value = self.db.profile.fontSize
	end
	
	local nonNorthSize = self.db.profile.nonNorthSize
	if frame then
		local font, _, style = frame.north:GetFont()
		frame.north:SetFont(font, value, style)
		frame.east:SetFont(font, value*nonNorthSize, style)
		frame.south:SetFont(font, value*nonNorthSize, style)
		frame.west:SetFont(font, value*nonNorthSize, style)
	end
end

function Chinchilla_Compass:SetNonNorthSize(value)
	self.db.profile.nonNorthSize = value
	self:SetFontSize(nil)
end

Chinchilla_Compass:AddChinchillaOption(function() return {
	name = L["Compass"],
	desc = Chinchilla_Compass.desc,
	type = 'group',
	args = {
		radius = {
			name = L["Radius"],
			desc = L["The distance from the center of the minimap to show the indicators."],
			type = 'range',
			min = 50,
			max = 100,
			step = 1,
			get = function(info)
				return Chinchilla_Compass.db.profile.radius
			end,
			set = function(info, value)
				Chinchilla_Compass:SetRadius(value)
			end,
		},
		color = {
			name = L["Color"],
			desc = L["Color of the indicators"],
			type = 'color',
			hasAlpha = true,
			get = function(info)
				return unpack(Chinchilla_Compass.db.profile.color)
			end,
			set = function(info, r, g, b, a)
				Chinchilla_Compass:SetColor(r, g, b, a)
			end,
		},
		fontSize = {
			name = L["Size"],
			desc = L["Size of the indicators"],
			type = 'range',
			min = 6,
			max = 24,
			step = 1,
			get = function(info)
				return Chinchilla_Compass.db.profile.fontSize
			end,
			set = function(info, value)
				Chinchilla_Compass:SetFontSize(value)
			end,
		},
		nonNorthSize = {
			name = L["Non-north size"],
			desc = L["Size of the east, west, and south indicators relative to the north indicator"],
			type = 'range',
			min = 0.5,
			max = 1,
			step = 0.01,
			bigStep = 0.05,
			isPercent = true,
			get = function(info)
				return Chinchilla_Compass.db.profile.nonNorthSize
			end,
			set = function(info, value)
				Chinchilla_Compass:SetNonNorthSize(value)
			end,
		},
	}
} end)
