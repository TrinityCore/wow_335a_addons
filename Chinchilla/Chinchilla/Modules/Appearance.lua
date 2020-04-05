
local Appearance = Chinchilla:NewModule("Appearance", "AceEvent-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Chinchilla")

Appearance.displayName = L["Appearance"]
Appearance.desc = L["Allow for a customized look of the minimap"]


local DEFAULT_MINIMAP_WIDTH = Minimap:GetWidth()
local DEFAULT_MINIMAP_HEIGHT = Minimap:GetHeight()
local MINIMAP_POINTS = {}

for i = 1, Minimap:GetNumPoints() do
	MINIMAP_POINTS[i] = { Minimap:GetPoint(i) }
end


local rotateMinimap = GetCVar("rotateMinimap") == "1"
function Appearance:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("Appearance", {
		profile = {
			scale = 1,
			blipScale = 1,
			alpha = 1,
			combatAlpha = 1,
			borderColor = { 1, 1, 1, 1 },
			buttonBorderAlpha = 1,
			strata = "BACKGROUND",
			frameLevel = 1,
			shape = "CORNER-BOTTOMLEFT",
			borderStyle = "Blizzard",
			borderRadius = 80,
			enabled = true,
		},
	})

	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local borderStyles = {}
function Appearance:AddBorderStyle(english, localized, round, square)
	if type(english) ~= "string" then
		error(("Bad argument #2 to `AddBorderStyle'. Expected %q, got %q"):format("string", type(english)), 2)
	elseif borderStyles[english] then
		error(("Bad argument #2 to `AddBorderStyle'. %q already provided"):format(english), 2)
	elseif type(localized) ~= "string" then
		error(("Bad argument #3 to `AddBorderStyle'. Expected %q, got %q"):format("string", type(localized)), 2)
	elseif type(round) ~= "string" then
		error(("Bad argument #4 to `AddBorderStyle'. Expected %q, got %q"):format("string", type(round)), 2)
	elseif type(square) ~= "string" then
		error(("Bad argument #5 to `AddBorderStyle'. Expected %q, got %q"):format("string", type(square)), 2)
	end

	borderStyles[english] = { localized, round, square }
end

Chinchilla.AddBorderStyle = Appearance.AddBorderStyle
Appearance:AddBorderStyle("Blizzard",   L["Blizzard"], [[Interface\AddOns\Chinchilla\Art\Border-Blizzard-Round]],   [[Interface\AddOns\Chinchilla\Art\Border-Blizzard-Square]])
Appearance:AddBorderStyle("Thin",       L["Thin"],     [[Interface\AddOns\Chinchilla\Art\Border-Thin-Round]],       [[Interface\AddOns\Chinchilla\Art\Border-Thin-Square]])
Appearance:AddBorderStyle("Alliance",   L["Alliance"], [[Interface\AddOns\Chinchilla\Art\Border-Alliance-Round]],   [[Interface\AddOns\Chinchilla\Art\Border-Alliance-Square]])
Appearance:AddBorderStyle("Tooltip",    L["Tooltip"],  [[Interface\AddOns\Chinchilla\Art\Border-Tooltip-Round]],    [[Interface\AddOns\Chinchilla\Art\Border-Tooltip-Square]])
Appearance:AddBorderStyle("Tubular",    L["Tubular"],  [[Interface\AddOns\Chinchilla\Art\Border-Tubular-Round]],    [[Interface\AddOns\Chinchilla\Art\Border-Tubular-Square]])
Appearance:AddBorderStyle("Flat",       L["Flat"],     [[Interface\AddOns\Chinchilla\Art\Border-Flat-Round]],       [[Interface\AddOns\Chinchilla\Art\Border-Flat-Square]])
Appearance:AddBorderStyle("Chinchilla", "Chinchilla",  [[Interface\AddOns\Chinchilla\Art\Border-Chinchilla-Round]], [[Interface\AddOns\Chinchilla\Art\Border-Chinchilla-Square]])

local RotateBorder_frame = CreateFrame("Frame")
RotateBorder_frame:Hide()
RotateBorder_frame:SetScript("OnUpdate", function()
	Appearance:RotateBorder()
end)

local cornerTextures = {}
local fullTexture
function Appearance:OnEnable()
	self:SetScale()
	self:SetAlpha()
	self:SetFrameStrata()
	self:SetFrameLevel()
	self:SetShape()
	self:SetBorderColor()
	self:SetButtonBorderAlpha()

	MinimapBorder:Hide()

	if rotateMinimap then
		if fullTexture then
			fullTexture:Show()
		end
	else
		for i,v in ipairs(cornerTextures) do
			v:Show()
		end
	end

	self:RegisterEvent("MINIMAP_UPDATE_ZOOM")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:ScheduleRepeatingTimer("RecheckMinimapButtons", 1)

	--[[ these issues seem to have been fixed with the custom mask textures
	self:AddEventListener("CVAR_UPDATE", "CVAR_UPDATE", 0.05)
	if IsMacClient() then --temporary hack to try and fix minimaps going black for Mac users. ~Ellipsis
		self:AddEventListener("DISPLAY_SIZE_CHANGED", "CVAR_UPDATE")
		self:AddEventListener("ZONE_CHANGED_NEW_AREA", "CVAR_UPDATE")
	end
	--]]
end

function Appearance:OnDisable()
	self:SetScale()
	self:SetAlpha()
	self:SetFrameStrata()
	self:SetFrameLevel()
	self:SetShape()
	self:SetBorderColor()
	self:SetButtonBorderAlpha()

	MinimapBorder:Show()
	Minimap:SetMaskTexture([[Textures\MinimapMask]])

	if fullTexture then
		fullTexture:Hide()
	end

	for i,v in ipairs(cornerTextures) do
		v:Hide()
	end

	if Chinchilla:GetModule("MoveButtons", true) then
		Chinchilla:GetModule("MoveButtons"):Update()
	end
end

local indoors
function Appearance:MINIMAP_UPDATE_ZOOM()
	local zoom = Minimap:GetZoom()

	if GetCVar("minimapZoom") == GetCVar("minimapInsideZoom") then
		Minimap:SetZoom(zoom < 2 and zoom + 1 or zoom - 1)
	end

	indoors = GetCVar("minimapZoom")+0 ~= Minimap:GetZoom()
	Minimap:SetZoom(zoom)

	self:SetAlpha()
end

local inCombat = InCombatLockdown()
function Appearance:PLAYER_REGEN_ENABLED()
	inCombat = false
	self:SetAlpha()
end

function Appearance:PLAYER_REGEN_DISABLED()
	inCombat = true
	self:SetCombatAlpha()
end

local minimapButtons = {}
do
	local tmp = {}

	local function fillTmp(...)
		for i = 1, select('#', ...) do
			tmp[i] = select(i, ...)
		end
	end

	function Appearance:RecheckMinimapButtons()
		fillTmp(Minimap:GetChildren())

		local found = false

		for _, v in ipairs(tmp) do
			if minimapButtons[v] == nil then
				if (v:GetObjectType() == "Frame" or v:GetObjectType() == "Button") and v:GetName() then
					local name = v:GetName()

					if name:find("MinimapButton$") and _G[name .. "Overlay"] then
						minimapButtons[v] = true
						found = true
					else
						minimapButtons[v] = false
					end
				else
					minimapButtons[v] = false
				end
			end
		end

		wipe(tmp)

		if found then
			self:SetButtonBorderAlpha(nil)
		end
	end
end

function Appearance:OnRotateMinimapUpdate(value)
	rotateMinimap = value

	if value then
		if fullTexture then
			fullTexture:Show()
		end

		for i,v in ipairs(cornerTextures) do
			v:Hide()
		end
	else
		if fullTexture then
			fullTexture:Hide()
		end

		for i,v in ipairs(cornerTextures) do
			v:Show()
		end
	end

	self:SetShape(nil)
	Minimap:SetFrameLevel(MinimapCluster:GetFrameLevel()+1)
end

function Appearance:SetScale(value)
	if value then self.db.profile.scale = value
	else value = self.db.profile.scale end

	local blipScale = self.db.profile.blipScale

	if not self:IsEnabled() then
		value = 1
		blipScale = 1
	end

	Minimap:SetWidth(DEFAULT_MINIMAP_WIDTH / blipScale)
	Minimap:SetHeight(DEFAULT_MINIMAP_HEIGHT / blipScale)
	Minimap:SetScale(blipScale)

	for _, v in ipairs { Minimap:GetChildren() } do
		v:SetScale(1 / blipScale)
	end

	for _, v in ipairs(MINIMAP_POINTS) do
		Minimap:SetPoint(v[1], v[2], v[3], v[4]/blipScale, v[5]/blipScale)
	end

	MinimapCluster:SetScale(value)

	local zoom = Minimap:GetZoom()
	Minimap:SetZoom(zoom < 2 and zoom + 1 or zoom - 1)
	Minimap:SetZoom(zoom)
end

function Appearance:SetBlipScale(value)
	if value then
		self.db.profile.blipScale = value
		self:SetScale(nil)
	end
end

function Appearance:SetAlpha(value)
	if value then self.db.profile.alpha = value
	else value = self.db.profile.alpha end

	if not self:IsEnabled() or indoors then
		value = 1
	end

	if not inCombat then
		MinimapCluster:SetAlpha(value)
	else
		MinimapCluster:SetAlpha(self.db.profile.combatAlpha)
	end
end

function Appearance:SetCombatAlpha(value)
	if value then self.db.profile.combatAlpha = value
	else value = self.db.profile.combatAlpha end

	if not self:IsEnabled() or indoors then
		value = 1
	end

	if inCombat then
		MinimapCluster:SetAlpha(value)
	end
end

function Appearance:SetFrameStrata(value)
	if value then self.db.profile.strata = value
	else value = self.db.profile.strata end

	if not self:IsEnabled() then
		value = "BACKGROUND"
	end

	MinimapCluster:SetFrameStrata(value)
end

function Appearance:SetFrameLevel(value)
	if value then self.db.profile.frameLevel = value
	else value = self.db.profile.frameLevel end

	if not self:IsEnabled() then
		value = 1
	end

	MinimapCluster:SetFrameLevel(value)
end

local roundShapes = {
	{
		["ROUND"] = true,
		["CORNER-TOPLEFT"] = true,
		["SIDE-LEFT"] = true,
		["SIDE-TOP"] = true,
		["TRICORNER-TOPRIGHT"] = true,
		["TRICORNER-TOPLEFT"] = true,
		["TRICORNER-BOTTOMLEFT"] = true,
	},
	{
		["ROUND"] = true,
		["CORNER-TOPRIGHT"] = true,
		["SIDE-RIGHT"] = true,
		["SIDE-TOP"] = true,
		["TRICORNER-BOTTOMRIGHT"] = true,
		["TRICORNER-TOPRIGHT"] = true,
		["TRICORNER-TOPLEFT"] = true,
	},
	{
		["ROUND"] = true,
		["CORNER-BOTTOMLEFT"] = true,
		["SIDE-LEFT"] = true,
		["SIDE-BOTTOM"] = true,
		["TRICORNER-TOPLEFT"] = true,
		["TRICORNER-BOTTOMLEFT"] = true,
		["TRICORNER-BOTTOMRIGHT"] = true,
	},
	{
		["ROUND"] = true,
		["CORNER-BOTTOMRIGHT"] = true,
		["SIDE-RIGHT"] = true,
		["SIDE-BOTTOM"] = true,
		["TRICORNER-BOTTOMLEFT"] = true,
		["TRICORNER-BOTTOMRIGHT"] = true,
		["TRICORNER-TOPRIGHT"] = true,
	},
}

function Appearance:SetShape(shape)
	if shape then self.db.profile.shape = shape
	else shape = self.db.profile.shape end

	if not self:IsEnabled() then
		return
	end

	if rotateMinimap and shape ~= "SQUARE" then
		RotateBorder_frame:Show()
		shape = "ROUND"
	else
		RotateBorder_frame:Hide()
	end

	if rotateMinimap then
		if not fullTexture then
			local borderRadius = self.db.profile.borderRadius

			fullTexture = MinimapBackdrop:CreateTexture("Chinchilla_Appearance_MinimapFullTexture", "ARTWORK")
			fullTexture:SetWidth(borderRadius*2 * 2^0.5)
			fullTexture:SetHeight(borderRadius*2 * 2^0.5)
			fullTexture:SetPoint("CENTER", Minimap, "CENTER")
		end
	else
		if not cornerTextures[1] then
			local borderRadius = self.db.profile.borderRadius

			for i = 1, 4 do
				local tex = MinimapBackdrop:CreateTexture("Chinchilla_Appearance_MinimapCorner" .. i, "ARTWORK")
				cornerTextures[i] = tex
				cornerTextures[i]:SetWidth(borderRadius)
				cornerTextures[i]:SetHeight(borderRadius)
			end

			cornerTextures[1]:SetPoint("BOTTOMRIGHT", Minimap, "CENTER")
			cornerTextures[1]:SetTexCoord(0, 0.5, 0, 0.5)

			cornerTextures[2]:SetPoint("BOTTOMLEFT", Minimap, "CENTER")
			cornerTextures[2]:SetTexCoord(0.5, 1, 0, 0.5)

			cornerTextures[3]:SetPoint("TOPRIGHT", Minimap, "CENTER")
			cornerTextures[3]:SetTexCoord(0, 0.5, 0.5, 1)

			cornerTextures[4]:SetPoint("TOPLEFT", Minimap, "CENTER")
			cornerTextures[4]:SetTexCoord(0.5, 1, 0.5, 1)
		end
	end

	local borderStyle = borderStyles[self.db.profile.borderStyle] or borderStyles.Blizzard
	local round = borderStyle and borderStyle[2] or [[Interface\AddOns\Chinchilla\Art\Border-Blizzard-Round]]
	local square = borderStyle and borderStyle[3] or [[Interface\AddOns\Chinchilla\Art\Border-Blizzard-Square]]

	if rotateMinimap then
		fullTexture:SetTexture(shape ~= "SQUARE" and round or square)
		fullTexture:SetTexCoord(
			0.5 - 0.5^0.5, 0.5 - 0.5^0.5,
			0.5 - 0.5^0.5, 0.5 + 0.5^0.5,
			0.5 + 0.5^0.5, 0.5 - 0.5^0.5,
			0.5 + 0.5^0.5, 0.5 + 0.5^0.5
		)

		if shape ~= "SQUARE" then
			self:RotateBorder()
		end
	else
		for i,v in ipairs(cornerTextures) do
			v:SetTexture(roundShapes[i][shape] and round or square)
		end
	end

	self:SetBorderColor() -- prevent border reverting to white, not sure if there's a way around this
	Minimap:SetMaskTexture([[Interface\AddOns\Chinchilla\Art\Mask-]] .. shape)

	if Chinchilla:GetModule("MoveButtons", true) then
		Chinchilla:GetModule("MoveButtons"):Update()
	end
end

local math_pi = math.pi
local math_cos = math.cos
local math_sin = math.sin

function Appearance:RotateBorder()
	local angle = GetPlayerFacing()

	fullTexture:SetTexCoord(
		math_cos(angle + math_pi*3/4) + 0.5, -math_sin(angle + math_pi*3/4) + 0.5,
		math_cos(angle - math_pi*3/4) + 0.5, -math_sin(angle - math_pi*3/4) + 0.5,
		math_cos(angle + math_pi*1/4) + 0.5, -math_sin(angle + math_pi*1/4) + 0.5,
		math_cos(angle - math_pi*1/4) + 0.5, -math_sin(angle - math_pi*1/4) + 0.5
	)
end

function Appearance:SetBorderStyle(style)
	if style then self.db.profile.borderStyle = style
	else return end

	self:SetShape()
end

function Appearance:SetBorderRadius(value)
	if value then self.db.profile.borderRadius = value
	else return end

	if cornerTextures[1] then
		for i,v in ipairs(cornerTextures) do
			v:SetWidth(value)
			v:SetHeight(value)
		end
	end

	if fullTexture then
		fullTexture:SetWidth(value*2 * 2^0.5)
		fullTexture:SetHeight(value*2 * 2^0.5)
	end
end

function Appearance:SetBorderColor(r, g, b, a)
	if r and g and b and a then
		self.db.profile.borderColor[1] = r
		self.db.profile.borderColor[2] = g
		self.db.profile.borderColor[3] = b
		self.db.profile.borderColor[4] = a
	else
		r = self.db.profile.borderColor[1]
		g = self.db.profile.borderColor[2]
		b = self.db.profile.borderColor[3]
		a = self.db.profile.borderColor[4]
	end

	if not self:IsEnabled() then
		return
	end

	for i,v in ipairs(cornerTextures) do
		v:SetVertexColor(r, g, b, a)
	end

	if fullTexture then
		fullTexture:SetVertexColor(r, g, b, a)
	end
end

local buttonBorderTextures = {
	MiniMapBattlefieldBorder,
	MiniMapWorldBorder,
	MiniMapMailBorder,
	MiniMapTrackingButtonBorder,
	MiniMapVoiceChatFrameBorder,
	MiniMapLFGFrameBorder,
	MiniMapRecordingBorder,
}

function Appearance:SetButtonBorderAlpha(alpha)
	if alpha then self.db.profile.buttonBorderAlpha = alpha
	else alpha = self.db.profile.buttonBorderAlpha end

	if not self:IsEnabled() then
		alpha = 1
	end

	for i, v in ipairs(buttonBorderTextures) do
		v:SetAlpha(alpha)
	end

	for k, v in pairs(minimapButtons) do
		if v then
			_G[k:GetName() .. "Overlay"]:SetAlpha(alpha)
		end
	end
end

function Appearance:GetOptions()
	local shape_choices = {
		["ROUND"] = L["Round"],
		["SQUARE"] = L["Square"],
		["CORNER-TOPRIGHT"] = L["Corner, top-right rounded"],
		["CORNER-TOPLEFT"] = L["Corner, top-left rounded"],
		["CORNER-BOTTOMRIGHT"] = L["Corner, bottom-right rounded"],
		["CORNER-BOTTOMLEFT"] = L["Corner, bottom-left rounded"],
		["SIDE-TOP"] = L["Side, top rounded"],
		["SIDE-RIGHT"] = L["Side, right rounded"],
		["SIDE-BOTTOM"] = L["Side, bottom rounded"],
		["SIDE-LEFT"] = L["Side, left rounded"],
		["TRICORNER-TOPRIGHT"] = L["Tri-corner, bottom-left square"],
		["TRICORNER-BOTTOMRIGHT"] = L["Tri-corner, top-left square"],
		["TRICORNER-BOTTOMLEFT"] = L["Tri-corner, top-right square"],
		["TRICORNER-TOPLEFT"] = L["Tri-corner, bottom-right square"],
	}

	local shape_choices_alt = { ["ROUND"] = L["Round"], ["SQUARE"] = L["Square"] }

	return {
		scale = {
			name = L["Size"],
			desc = L["Set how large the minimap is"],
			type = 'range',
			min = 0.25,
			max = 4,
			step = 0.01,
			bigStep = 0.05,
			get = function()
				return self.db.profile.scale
			end,
			set = function(_, value)
				self:SetScale(value)
			end,
			isPercent = true,
		},
		blipScale = {
			name = L["Blip size"],
			desc = L["Set how large the blips on the minimap are"],
			type = 'range',
			min = 0.25,
			max = 4,
			step = 0.01,
			bigStep = 0.05,
			get = function()
				return self.db.profile.blipScale
			end,
			set = function(_, value)
				self:SetBlipScale(value)
			end,
			isPercent = true,
		},
		alpha = {
			name = L["Opacity"],
			desc = L["Set how transparent or opaque the minimap is when not in combat"],
			type = 'range',
			min = 0,
			max = 1,
			step = 0.01,
			bigStep = 0.05,
			get = function()
				return self.db.profile.alpha
			end,
			set = function(_, value)
				self:SetAlpha(value)
			end,
			isPercent = true,
		},
		combatAlpha = {
			name = L["Combat opacity"],
			desc = L["Set how transparent or opaque the minimap is when in combat"],
			type = 'range',
			min = 0,
			max = 1,
			step = 0.01,
			bigStep = 0.05,
			get = function()
				return self.db.profile.combatAlpha
			end,
			set = function(_, value)
				self:SetCombatAlpha(value)
			end,
			isPercent = true,
		},
		strata = {
			name = L["Strata"],
			desc = L["Set which layer the minimap is layered on in relation to others in your interface."],
			type = 'select',
			values = {
				BACKGROUND = L["Background"],
				LOW = L["Low"],
				MEDIUM = L["Medium"],
				HIGH = L["High"],
				DIALOG = L["Dialog"],
				FULLSCREEN = L["Fullscreen"],
				FULLSCREEN_DIALOG = L["Fullscreen-dialog"],
				TOOLTIP = L["Tooltip"]
			},
			-- choiceOrder = {
			-- 	"BACKGROUND",
			-- 	"LOW",
			-- 	"MEDIUM",
			-- 	"HIGH",
			-- 	"DIALOG",
			-- 	"FULLSCREEN",
			-- 	"FULLSCREEN_DIALOG",
			-- 	"TOOLTIP"
			-- },
			get = function()
				return self.db.profile.strata
			end,
			set = function(_, value)
				self:SetFrameStrata(value)
			end
		},
		frameLevel = {
			name = L["Frame level"],
			desc = L["Set which frame level the minimap is layered on in relation to others in your interface."],
			type = 'range',
			min = 0,
			max = 50,
			step = 1,
			get = function()
				return self.db.profile.frameLevel
			end,
			set = function(_, value)
				self:SetFrameLevel(value)
			end,
		},
		shape = {
			name = L["Shape"],
			desc = L["Set the shape of the minimap."],
			type = 'select',
			values = function()
				return rotateMinimap and shape_choices_alt or shape_choices
			end,
			get = function()
				local shape = self.db.profile.shape

				if rotateMinimap then
					if shape == "SQUARE" then return "SQUARE"
					else return "ROUND" end
				else
					return shape
				end
			end,
			set = function(info, value)
				self:SetShape(value)
			end,
		},
		borderAlpha = {
			name = L["Border color"],
			desc = L["Set the color the minimap border is."],
			type = 'color',
			hasAlpha = true,
			get = function()
				return unpack(self.db.profile.borderColor)
			end,
			set = function(_, ...)
				self:SetBorderColor(...)
			end,
		},
		borderStyle = {
			name = L["Border style"],
			desc = L["Set what texture style you want the minimap border to use."],
			type = 'select',
			values = function()
				local t = {}
				for k, v in pairs(borderStyles) do t[k] = v[1] end
				return t
			end,
			get = function()
				return self.db.profile.borderStyle
			end,
			set = function(_, value)
				self:SetBorderStyle(value)
			end,
		},
		borderRadius = {
			name = L["Border radius"],
			desc = L["Set how large the border texture is."],
			type = 'range',
			min = 50,
			max = 200,
			step = 1,
			bigStep = 5,
			get = function()
				return self.db.profile.borderRadius
			end,
			set = function(_, value)
				self:SetBorderRadius(value)
			end,
		},
		buttonBorderAlpha = {
			name = L["Button border opacity"],
			desc = L["Set how transparent or opaque the minimap button borders are."],
			type = 'range',
			min = 0,
			max = 1,
			step = 0.01,
			bigStep = 0.05,
			get = function()
				return self.db.profile.buttonBorderAlpha
			end,
			set = function(_, value)
				self:SetButtonBorderAlpha(value)
			end,
			isPercent = true,
		},
	}
end

function _G.GetMinimapShape()
	if not Appearance.db then return "ROUND" end

	if Appearance:IsEnabled() and not rotateMinimap then
		return Appearance.db.profile.shape
	else
		if Appearance.db.profile.shape == "SQUARE" then return "SQUARE"
		else return "ROUND" end
	end
end
