local Chinchilla = Chinchilla
local Chinchilla_MoveButtons = Chinchilla:NewModule("MoveButtons")
local self = Chinchilla_MoveButtons
local L = Chinchilla.L

Chinchilla_MoveButtons.desc = L["Move buttons around the minimap"]

local buttons = {
	battleground = MiniMapBattlefieldFrame,
	difficulty = MiniMapInstanceDifficulty,
	map = MiniMapWorldMapButton,
	mail = MiniMapMailFrame,
	lfg = MiniMapLFGFrame,
	dayNight = GameTimeFrame,
	clock = TimeManagerClockButton,
	track = MiniMapTracking,
	voice = MiniMapVoiceChatFrame,
	zoomIn = MinimapZoomIn,
	zoomOut = MinimapZoomOut,
	record = IsMacClient() and MiniMapRecordingButton or nil,
}

local buttonReverse = {}
for k,v in pairs(buttons) do
	buttonReverse[v] = k
end

local buttonStarts = {}

local function getOffset(deg)
	local angle = math.rad(deg)

	local cos, sin = math.cos(angle), math.sin(angle)

	local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"

	local round = true
	if minimapShape == "ROUND" then
		-- do nothing
	elseif minimapShape == "SQUARE" then
		round = false
	elseif minimapShape == "CORNER-TOPRIGHT" then
		if cos < 0 or sin < 0 then
			round = false
		end
	elseif minimapShape == "CORNER-TOPLEFT" then
		if cos > 0 or sin < 0 then
			round = false
		end
	elseif minimapShape == "CORNER-BOTTOMRIGHT" then
		if cos < 0 or sin > 0 then
			round = false
		end
	elseif minimapShape == "CORNER-BOTTOMLEFT" then
		if cos > 0 or sin > 0 then
			round = false
		end
	elseif minimapShape == "SIDE-LEFT" then
		if cos > 0 then
			round = false
		end
	elseif minimapShape == "SIDE-RIGHT" then
		if cos < 0 then
			round = false
		end
	elseif minimapShape == "SIDE-TOP" then
		if sin < 0 then
			round = false
		end
	elseif minimapShape == "SIDE-BOTTOM" then
		if sin > 0 then
			round = false
		end
	elseif minimapShape == "TRICORNER-TOPRIGHT" then
		if cos < 0 and sin < 0 then
			round = false
		end
	elseif minimapShape == "TRICORNER-TOPLEFT" then
		if cos > 0 and sin < 0 then
			round = false
		end
	elseif minimapShape == "TRICORNER-BOTTOMRIGHT" then
		if cos < 0 and sin > 0 then
			round = false
		end
	elseif minimapShape == "TRICORNER-BOTTOMLEFT" then
		if cos > 0 and sin > 0 then
			round = false
		end
	end

	local radius = Chinchilla_MoveButtons.db.profile.radius

	if round then
		return radius * cos, radius * sin
	else
		local x = radius * 2^0.5 * cos
		local y = radius * 2^0.5 * sin
		if x < -radius then
			x = -radius
		elseif x > radius then
			x = radius
		end
		if y < -radius then
			y = -radius
		elseif y > radius then
			y = radius
		end
		return x, y
	end
end

local function getAngle(x1, y1)
	local x2, y2 = Minimap:GetCenter()
	local scale = Minimap:GetEffectiveScale() / UIParent:GetEffectiveScale()
	x2 = x2*scale
	y2 = y2*scale
	local x, y = x1 - x2, y1 - y2
	local deg = math.deg(math.atan2(y, x))
	while deg < 0 do
		deg = deg + 360
	end
	while deg > 360 do
		deg = deg - 360
	end
	return math.floor(deg + 0.5)
end

local function getPointXY(frame, x, y)
	local width, height = GetScreenWidth(), GetScreenHeight()
	local uiscale = UIParent:GetEffectiveScale()
	local scale = frame:GetEffectiveScale() / uiscale

	local point
	if x < width/3 then
		point = "LEFT"
	elseif x < width*2/3 then
		point = ""
		x = x - width/2
	else
		point = "RIGHT"
		x = x - width
	end
	if y < height/3 then
		point = "BOTTOM" .. point
	elseif y < height*2/3 then
		if point == "" then
			point = "CENTER"
		end
		y = y - height/2
	else
		point = "TOP" .. point
		y = y - height
	end

	return point, x/scale, y/scale
end

local function button_OnUpdate(this)
	this:ClearAllPoints()
	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	local deg
	x, y = x / scale, y / scale
	if not IsAltKeyDown() then
		deg = math.floor(getAngle(x, y) + 0.5)
		local k = buttonReverse[this]
		self.db.profile[k] = deg
	else
		local k = buttonReverse[this]
		deg = self.db.profile[k]
		if type(deg) ~= "table" then
			deg = {}
			self.db.profile[k] = deg
		end
		local point, x, y = getPointXY(this, x, y)
		deg[1] = point
		deg[2] = x
		deg[3] = y
	end
	this:ClearAllPoints()
	if type(deg) == "table" then
		this:SetPoint("CENTER", UIParent, deg[1], deg[2], deg[3])
	else
		this:SetPoint("CENTER", Minimap, "CENTER", getOffset(deg))
	end

	LibStub("AceConfigRegistry-3.0"):NotifyChange("Chinchilla")
end
local function button_OnDragStart(this)
	this.isMoving = true
	this:SetScript("OnUpdate", button_OnUpdate)
	this:StartMoving()
end
local function button_OnDragStop(this)
	if not this.isMoving then
		return
	end
	this.isMoving = nil
	this:SetScript("OnUpdate", nil)
	this:StopMovingOrSizing()
	button_OnUpdate(this)
end

function Chinchilla_MoveButtons:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("MoveButtons", {
		profile = {
			lock = false,
			radius = 80,
			enabled = true,
		}
	})
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end

	for k,v in pairs(buttons) do
		if type(self.db.profile[v]) == "table" and #self.db.profile[v] == 2 then
			table.insert(self.db.profile[v], "BOTTOMLEFT")
		end
		buttonStarts[k] = getAngle(v:GetCenter())
	end
end

function Chinchilla_MoveButtons:OnEnable()
	self:SetLocked(nil)
	self:Update()
end

function Chinchilla_MoveButtons:OnDisable()
	self:SetLocked(nil)
	for k,v in pairs(buttons) do
		local deg = buttonStarts[k]
		v:ClearAllPoints()
		v:SetPoint("CENTER", Minimap, "CENTER", getOffset(deg))
		v:SetClampedToScreen(false)
	end
end

function Chinchilla_MoveButtons:Update()
	for k,v in pairs(buttons) do
		local deg = self.db.profile[k] or buttonStarts[k]
		if not deg then
			deg = getAngle(v:GetCenter())
		end
		v:ClearAllPoints()
		if type(deg) == "table" then
			v:SetPoint("CENTER", UIParent, deg[1], deg[2], deg[3])
			v:SetClampedToScreen(true)
		else
			v:SetPoint("CENTER", Minimap, "CENTER", getOffset(deg))
			v:SetClampedToScreen(false)
		end
	end
end

local function get(info)
	local key = info[#info - 1]
	return self.db.profile[key] or getAngle(buttons[key]:GetCenter())
end
local angle_get = get

local function set(info, value)
	local key = info[#info - 1]
	self.db.profile[key] = value
	if not self:IsEnabled() then
		return
	end
	buttons[key]:ClearAllPoints()
	buttons[key]:SetPoint("CENTER", Minimap, "CENTER", getOffset(value))
end
local angle_set = set

local function attach_get(info)
	local key = info[#info - 1]
	return not self.db.profile[key] or type(self.db.profile[key]) == "number"
end

local function not_attach_get(info)
	local key = info[#info - 1]
	return not attach_get(key)
end

local function attach_set(info, value)
	local key = info[#info - 1]
	if not value then
		self.db.profile[key] = { "BOTTOMLEFT", buttons[key]:GetCenter() }
	else
		self.db.profile[key] = getAngle(buttons[key]:GetCenter())
		buttons[key]:ClearAllPoints()
		buttons[key]:SetPoint("CENTER", Minimap, "CENTER", getOffset(self.db.profile[key]))
	end
end

local function x_get(info)
	local key = info[#info - 1]
	local frame = buttons[key]
	local point = self.db.profile[key][1]
	local x = self.db.profile[key][2]
	if not x then
		return 0
	end
	x = x * frame:GetEffectiveScale() / UIParent:GetEffectiveScale()
	if point == "LEFT" or point == "BOTTOMLEFT" or point == "TOPLEFT" then
		return x - GetScreenWidth()/2
	elseif point == "CENTER" or point == "TOP" or point == "BOTTOM" then
		return x
	else
		return x + GetScreenWidth()/2
	end
end

local function y_get(info)
	local key = info[#info - 1]
	local frame = buttons[key]
	local point = self.db.profile[key][1]
	local y = self.db.profile[key][3]
	if not y then
		return 0
	end
	y = y * frame:GetEffectiveScale() / UIParent:GetEffectiveScale()
	if point == "BOTTOM" or point == "BOTTOMLEFT" or point == "BOTTOMRIGHT" then
		return y - GetScreenHeight()/2
	elseif point == "CENTER" or point == "LEFT" or point == "RIGHT" then
		return y
	else
		return y + GetScreenHeight()/2
	end
end

local function x_set(info, value)
	local key = info[#info - 1]
	local data = self.db.profile[key]
	local y = y_get(info)
	local point, x, y = getPointXY(buttons[key], value + GetScreenWidth()/2, y + GetScreenHeight()/2)
	data[1] = point
	data[2] = x
	data[3] = y
	if not self:IsEnabled() then
		return
	end
	buttons[key]:ClearAllPoints()
	buttons[key]:SetPoint("CENTER", UIParent, unpack(data))
end

local function y_set(info, value)
	local key = info[#info - 1]
	local data = self.db.profile[key]
	local x = x_get(info)
	local point, x, y = getPointXY(buttons[key], x + GetScreenWidth()/2, value + GetScreenHeight()/2)
	data[1] = point
	data[2] = x
	data[3] = y
	if not self:IsEnabled() then
		return
	end
	buttons[key]:ClearAllPoints()
	buttons[key]:SetPoint("CENTER", UIParent, unpack(data))
end

local x_min = -math.floor(GetScreenWidth()/10 + 0.5) * 5

local x_max = math.floor(GetScreenWidth()/10 + 0.5) * 5

local y_min = -math.floor(GetScreenHeight()/10 + 0.5) * 5

local y_max = math.floor(GetScreenHeight()/10 + 0.5) * 5

function Chinchilla_MoveButtons:IsLocked()
	return self.db.profile.lock
end

function Chinchilla_MoveButtons:SetLocked(value)
	if value ~= nil then
		self.db.profile.lock = value
	else
		value = self.db.profile.lock
	end
	if not self:IsEnabled() then
		value = true
	end
	if value then
		for k,v in pairs(buttons) do
			v:SetMovable(false)
			v:RegisterForDrag()
			v:SetScript("OnDragStart", nil)
			v:SetScript("OnDragStop", nil)
		end
	else
		for k,v in pairs(buttons) do
			v:SetMovable(true)
			v:RegisterForDrag("LeftButton")
			v:SetScript("OnDragStart", button_OnDragStart)
			v:SetScript("OnDragStop", button_OnDragStop)
		end
	end
end

function Chinchilla_MoveButtons:SetRadius(value)
	if value then
		self.db.profile.radius = value
	end
	self:Update()
end

Chinchilla_MoveButtons:AddChinchillaOption(function()
	local args = {
		attach = {
			name = L["Attach to minimap"],
			desc = L["Whether to stay attached to the minimap or move freely.\nNote: If you hold Alt while dragging, it will automatically unattach."],
			type = 'toggle',
			get = attach_get,
			set = attach_set,
			order = 1,
		},
		angle = {
			name = L["Angle"],
			desc = L["Angle on the minimap"],
			type = 'range',
			min = 0,
			max = 360,
			step = 1,
			bigStep = 5,
			get = angle_get,
			set = angle_set,
			hidden = not_attach_get,
		},
		x = {
			name = L["Horizontal position"],
			desc = L["Horizontal position of the button on-screen"],
			type = 'range',
			min = x_min,
			max = x_max,
			step = 1,
			bigStep = 5,
			get = x_get,
			set = x_set,
			hidden = attach_get,
		},
		y = {
			name = L["Vertical position"],
			desc = L["Vertical position of the button on-screen"],
			type = 'range',
			min = y_min,
			max = y_max,
			step = 1,
			bigStep = 5,
			get = y_get,
			set = y_set,
			hidden = attach_get,
		},
	}

	return {
		name = L["Move Buttons"],
		desc = Chinchilla_MoveButtons.desc,
		type = 'group',
		args = {
			lock = {
				name = L["Lock"],
				desc = L["Lock buttons in place so that they won't be mistakenly dragged"],
				type = 'toggle',
				order = 2,
				get = function(info)
					self:IsLocked()
				end,
				set = function(info, value)
					self:SetLocked(value)
				end,
			},
			radius = {
				name = L["Radius"],
				desc = L["Set how far away from the center to place buttons on the minimap"],
				type = 'range',
				order = 3,
				min = 60,
				max = 100,
				step = 1,
				get = function(info)
					return Chinchilla_MoveButtons.db.profile.radius
				end,
				set = function(info, value)
					self:SetRadius(value)
				end,
			},
			battleground = buttons.battleground and {
				name = L["Battleground"],
				desc = L["Set the position of the battleground indicator"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			map = buttons.map and {
				name = L["World map"],
				desc = L["Set the position of the world map button"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			mail = buttons.mail and {
				name = L["Mail"],
				desc = L["Set the position of the mail indicator"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			lfg = buttons.lfg and {
				name = L["LFG"],
				desc = L["Set the position of the looking for group indicator"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			dayNight = buttons.dayNight and {
				name = L["Calendar"],
				desc = L["Set the position of the calendar"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			clock = buttons.clock and {
				name = L["Clock"],
				desc = L["Set the position of the clock"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			difficulty = buttons.difficulty and {
				name = L["Instance difficulty"],
				desc = L["Set the position of the instance difficulty indicator"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			track = buttons.track and {
				name = L["Tracking"],
				desc = L["Set the position of the tracking indicator"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			voice = buttons.voice and {
				name = L["Voice chat"],
				desc = L["Set the position of the voice chat button"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			zoomIn = buttons.zoomIn and {
				name = L["Zoom in"],
				desc = L["Set the position of the zoom in button"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			zoomOut = buttons.zoomOut and {
				name = L["Zoom out"],
				desc = L["Set the position of the zoom out button"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
			record = buttons.record and {
				name = L["Recording"],
				desc = L["Set the position of the recording button"],
				type = 'group',
				inline = true,
				args = args,
			} or nil,
		}
	}
end)
