local Chinchilla = Chinchilla
local Chinchilla_Position = Chinchilla:NewModule("Position", "AceHook-3.0")
local self = Chinchilla_Position
local L = Chinchilla.L

Chinchilla_Position.desc = L["Allow for moving of the minimap and surrounding frames"]

local numHookedCaptureFrames = 0

function Chinchilla_Position:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("Position", {
		profile = {
			minimap = { "TOPRIGHT", 0, 0 },
			durability = { "TOPRIGHT", -143, -221 },
			questWatch = { "TOPRIGHT", -183, -226 },
			capture = { "TOPRIGHT", -9, -190 },
			worldState = { "TOP", 0, -50 },
			vehicleSeats = { "TOPRIGHT", -50, -250 },
			ticketStatus = { "TOPRIGHT", -180, 0 },
			boss = { "TOPRIGHT", 55, -236 },
			minimapLock = false,
			enabled = true,
		}
	})
	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local function Minimap_OnDragStart(this)
	MinimapCluster:StartMoving()
end

local function getPointXY(frame, newX, newY)
	local width, height = GetScreenWidth(), GetScreenHeight()
	local uiscale = UIParent:GetEffectiveScale()
	local scale = frame:GetEffectiveScale() / uiscale
	local point, x, y
	if newX then
		x = newX
		y = newY
	else
		x, y = frame:GetCenter()
		x = x*scale
		y = y*scale
	end
	if x < width/3 then
		x = x - frame:GetWidth()/2*scale
		point = "LEFT"

		if frame == MinimapCluster then
			if x < -35*scale then
				x = -35*scale
			end
		else
			if x < 0 then
				x = 0
			end
		end
	elseif x < width*2/3 then
		point = ""
		x = x - width/2
	else
		point = "RIGHT"
		x = x - width + frame:GetWidth()/2*scale

		if frame == MinimapCluster then
			if x > 17*scale then
				x = 17*scale
			end
		else
			if x > 0 then
				x = 0
			end
		end
	end

	if y < height/3 then
		y = y - frame:GetHeight()/2*scale
		point = "BOTTOM" .. point

		if frame == MinimapCluster then
			if y < -30*scale then
				y = -30*scale
			end
		else
			if y < 0 then
				y = 0
			end
		end
	elseif y < height*2/3 then
		if point == "" then
			point = "CENTER"
		end
		y = y - height/2
	else
		point = "TOP" .. point
		y = y - height + frame:GetHeight()/2*scale

		if frame == MinimapCluster then
			if y > 22*scale then
				y = 22*scale
			end
		else
			if y > 0 then
				y = 0
			end
		end
	end

	return point, x/scale, y/scale
end

local function Minimap_OnDragStop(this)
	MinimapCluster:StopMovingOrSizing()
	local point, x, y = getPointXY(MinimapCluster)
	self:SetMinimapPosition(point, x, y)
	LibStub("AceConfigRegistry-3.0"):NotifyChange("Chinchilla")
end

function Chinchilla_Position:OnEnable()
	self:SetMinimapPosition(nil, nil, nil)
	self:SetFramePosition('durability', nil, nil, nil)
	self:SetFramePosition('capture', nil, nil, nil)
	self:SetFramePosition('questWatch', nil, nil, nil)
	self:SetFramePosition('vehicleSeats', nil, nil, nil)
	self:SetFramePosition('boss', nil, nil, nil)
	WorldStateAlwaysUpFrame:SetWidth(200)
	WorldStateAlwaysUpFrame:SetHeight(60)
	WorldStateAlwaysUpFrame:EnableMouse(false)
	self:SetFramePosition('worldState', nil, nil, nil)
	self:SetFramePosition('ticketStatus', nil, nil, nil)
	self:SetLocked(nil)

	Minimap:SetClampedToScreen(true)

	-- hack so that frame positioning doesn't break
	MinimapCluster:SetMovable(true)
	MinimapCluster:StartMoving()
  	MinimapCluster:StopMovingOrSizing()

	self:SecureHook(DurabilityFrame, "SetPoint", "DurabilityFrame_SetPoint")
	self:SecureHook(VehicleSeatIndicator, "SetPoint", "VehicleSeatIndicator_SetPoint")
	self:SecureHook(WatchFrame, "SetPoint", "WatchFrame_SetPoint")
	-- self:RawHook("WatchFrame_GetRemainingSpace", "WatchFrame_GetRemainingSpace", true)
	self:SecureHook(WorldStateAlwaysUpFrame, "SetPoint", "WorldStateAlwaysUpFrame_SetPoint")
	self:SecureHook("WorldStateAlwaysUpFrame_Update")
end

function Chinchilla_Position:OnDisable()
	self:SetMinimapPosition(nil, nil, nil)
	self:ShowFrameMover('durability', false)
	self:ShowFrameMover('vehicleSeats', false)
	self:ShowFrameMover('capture', false)
	WorldStateAlwaysUpFrame:SetWidth(10)
	WorldStateAlwaysUpFrame:SetHeight(10)
	WorldStateAlwaysUpFrame:EnableMouse(true)
	self:ShowFrameMover('worldState', false)
	self:SetFramePosition('durability', nil, nil, nil)
	self:SetFramePosition('questWatch', nil, nil, nil)
	self:SetFramePosition('capture', nil, nil, nil)
	self:SetFramePosition('worldState', nil, nil, nil)
	self:SetFramePosition('vehicleSeats', nil, nil, nil)
	self:SetFramePosition('boss', nil, nil, nil)
	self:SetFramePosition('ticketStatus', nil, nil, nil)
	self:SetLocked(nil)
	-- self:RawHook("WatchFrame_GetRemainingSpace", "WatchFrame_GetRemainingSpace", true)

	Minimap:SetClampedToScreen(false)
end

local quadrantToShape = {
	"CORNER-TOPRIGHT",
	"SIDE-TOP",
	"CORNER-TOPLEFT",
	"SIDE-RIGHT",
	"ROUND",
	"SIDE-LEFT",
	"CORNER-BOTTOMRIGHT",
	"SIDE-BOTTOM",
	"CORNER-BOTTOMLEFT",
}

function Chinchilla_Position:IsLocked()
	return self.db.profile.minimapLock
end

function Chinchilla_Position:SetLocked(value)
	if value ~= nil then
		self.db.profile.minimapLock = value
	else
		value = self.db.profile.minimapLock
	end
	if not self:IsEnabled() then
		value = true
	end
	if value then
		Minimap:RegisterForDrag()
		MinimapZoneTextButton:RegisterForDrag()
		Minimap:SetScript("OnDragStart", nil)
		Minimap:SetScript("OnDragStop", nil)
		MinimapZoneTextButton:SetScript("OnDragStart", nil)
		MinimapZoneTextButton:SetScript("OnDragStop", nil)
		MinimapCluster:SetMovable(false)
	else
		Minimap:RegisterForDrag("LeftButton")
		MinimapZoneTextButton:RegisterForDrag("LeftButton")
		Minimap:SetScript("OnDragStart", Minimap_OnDragStart)
		Minimap:SetScript("OnDragStop", Minimap_OnDragStop)
		MinimapZoneTextButton:SetScript("OnDragStart", Minimap_OnDragStart)
		MinimapZoneTextButton:SetScript("OnDragStop", Minimap_OnDragStop)
		MinimapCluster:SetMovable(true)
	end
end

local lastQuadrant
function Chinchilla_Position:SetMinimapPosition(point, x, y)
	if point then
		self.db.profile.minimap[1] = point
	else
		point = self.db.profile.minimap[1]
	end
	if x then
		self.db.profile.minimap[2] = x
	else
		x = self.db.profile.minimap[2]
	end
	if y then
		self.db.profile.minimap[3] = y
	else
		y = self.db.profile.minimap[3]
	end
	if not self:IsEnabled() then
		point, x, y = "TOPRIGHT", 0, 0
	end
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint(point, UIParent, point, x, y)

	local x, y = MinimapCluster:GetCenter()
	local scale = MinimapCluster:GetEffectiveScale() / UIParent:GetEffectiveScale()
	x = x*scale
	y = y*scale
	local quadrant = 0
	local width, height = GetScreenWidth(), GetScreenHeight()
	if x < width/3 then
		quadrant = 1
	elseif x < width*2/3 then
		quadrant = 2
	else
		quadrant = 3
	end
	if y < height/3 then
		quadrant = quadrant + 0
	elseif y < height*2/3 then
		quadrant = quadrant + 3
	else
		quadrant = quadrant + 6
	end
	if lastQuadrant and lastQuadrant ~= quadrant and Chinchilla:GetModule("Appearance", true) and Chinchilla:GetModule("Appearance"):IsEnabled() and Chinchilla:GetModule("Appearance").db and Chinchilla:GetModule("Appearance").db.profile.shape == quadrantToShape[lastQuadrant] then
		Chinchilla:GetModule("Appearance"):SetShape(quadrantToShape[quadrant])
	end
	lastQuadrant = quadrant
end

local shouldntSetPoint = false
function Chinchilla_Position:DurabilityFrame_SetPoint(this)
	if shouldntSetPoint then
		return
	end
	self:SetFramePosition('durability', nil, nil, nil)
end

function Chinchilla_Position:WatchFrame_SetPoint(this)
	if shouldntSetPoint then
		return
	end
	self:SetFramePosition('questWatch', nil, nil, nil)
end

-- function Chinchilla_Position:WatchFrame_GetRemainingSpace(...)
-- 	return 500
-- end

function Chinchilla_Position:VehicleSeatIndicator_SetPoint(this)
	if shouldntSetPoint then
		return
	end
	self:SetFramePosition('vehicleSeats', nil, nil, nil)
end

function Chinchilla_Position:WorldStateAlwaysUpFrame_SetPoint(this)
	if shouldntSetPoint then
		return
	end
	self:SetFramePosition('worldState', nil, nil, nil)
end

function Chinchilla_Position:WorldStateCaptureBar_SetPoint(this)
	if shouldntSetPoint then
		return
	end
	self:SetFramePosition('capture', nil, nil, nil)
end

function Chinchilla_Position:WorldStateAlwaysUpFrame_Update(this)
	while numHookedCaptureFrames < NUM_EXTENDED_UI_FRAMES do
		numHookedCaptureFrames = numHookedCaptureFrames + 1
		self:SecureHook(_G["WorldStateCaptureBar" .. numHookedCaptureFrames], "SetPoint", "WorldStateCaptureBar_SetPoint")
		self:WorldStateCaptureBar_SetPoint()
	end
end

local nameToFrame = {
	minimap = MinimapCluster,
	boss = Boss1TargetFrame,
	durability = DurabilityFrame,
	questWatch = WatchFrame,
	worldState = WorldStateAlwaysUpFrame,
	vehicleSeats = VehicleSeatIndicator,
	ticketStatus = TicketStatusFrame,
}

local movers = {}
function Chinchilla_Position:SetFramePosition(frame, point, x, y)
	if point then
		self.db.profile[frame][1] = point
	else
		point = self.db.profile[frame][1]
	end
	if x then
		self.db.profile[frame][2] = x
	else
		x = self.db.profile[frame][2]
	end
	if y then
		self.db.profile[frame][3] = y
	else
		y = self.db.profile[frame][3]
	end
	if not self:IsEnabled() then
		-- TODO: get defaults for each frame
		point, x, y = "TOPRIGHT", -143, -221
	end
	shouldntSetPoint = true
	if movers[frame] and movers[frame]:IsShown() then
		movers[frame]:ClearAllPoints()
		movers[frame]:SetPoint(point, UIParent, point, x, y)
	else
		if frame == "capture" then
			for i = 1, NUM_EXTENDED_UI_FRAMES do
				_G["WorldStateCaptureBar" .. i]:ClearAllPoints()
				_G["WorldStateCaptureBar" .. i]:SetPoint(point, UIParent, point, x, y)
			end
		else
			nameToFrame[frame]:ClearAllPoints()
			nameToFrame[frame]:SetPoint(point, UIParent, point, x, y)
		end
	end
	shouldntSetPoint = false
end

local function mover_OnDragStart(this)
	this:StartMoving()
end

local function mover_OnDragStop(this)
	this:StopMovingOrSizing()
	local point, x, y = getPointXY(this)
	self:SetFramePosition(this.name, point, x, y)
	LibStub("AceConfigRegistry-3.0"):NotifyChange("Chinchilla")
end

local nameToNiceName = {
	durability = L["Durability"],
	questWatch = L["Quest tracker"],
	worldState = L["World state"],
	capture = L["Capture bar"],
	vehicleSeats = L["Vehicle seats"],
	ticketStatus = L["Ticket status"],
	boss = L["Boss frames"],
}

function Chinchilla_Position:ShowFrameMover(frame, value, force)
	local mover = movers[frame]
	if value == not not (mover and mover:IsShown()) then
		return
	end
	if not self:IsEnabled() and not force then
		value = false
	end
	if value and not mover then
		mover = CreateFrame("Frame", "Chinchilla_Position_" .. frame .. "_Mover", UIParent)
		movers[frame] = mover
		mover.name = frame
		if frame ~= 'capture' then
			mover:SetFrameStrata(nameToFrame[frame]:GetFrameStrata())
			mover:SetFrameLevel(nameToFrame[frame]:GetFrameLevel()+5)
		end
		mover:SetClampedToScreen(true)
		mover:EnableMouse(true)
		mover:SetMovable(true)
		mover:RegisterForDrag("LeftButton")
		mover:SetScript("OnDragStart", mover_OnDragStart)
		mover:SetScript("OnDragStop", mover_OnDragStop)
		local tex = mover:CreateTexture(mover:GetName() .. "_Texture", "BACKGROUND")
		tex:SetAllPoints(mover)
		tex:SetTexture(1, 0.5, 0, 0.5)
		local text = mover:CreateFontString(mover:GetName() .. "_FontString", "ARTWORK", "GameFontHighlight")
		text:SetPoint("CENTER")
		text:SetText(nameToNiceName[frame])
	end
	if not value then
		if mover then
			mover:Hide()
			self:SetFramePosition(frame, nil, nil, nil)
		end
	else
		if frame == 'capture' then
			mover:SetWidth(173)
			mover:SetHeight(26)
		else
			mover:SetWidth(nameToFrame[frame]:GetWidth())
			mover:SetHeight(nameToFrame[frame]:GetHeight())
		end
		shouldntSetPoint = true
		mover:Show()
		mover:ClearAllPoints()
		local data = self.db.profile[frame]
		local point, x, y = data[1], data[2], data[3]
		mover:SetPoint(point, UIParent, point, x, y)
		if frame == "capture" then
			for i = 1, NUM_EXTENDED_UI_FRAMES do
				_G["WorldStateCaptureBar" .. i]:ClearAllPoints()
				_G["WorldStateCaptureBar" .. i]:SetAllPoints(mover)
			end
		else
			nameToFrame[frame]:ClearAllPoints()
			nameToFrame[frame]:SetAllPoints(mover)
		end
		shouldntSetPoint = false
	end
end

Chinchilla_Position:AddChinchillaOption(function()
	local function movable_get(info)
		local frame = info[#info - 1]
		return movers[frame] and movers[frame]:IsShown()
	end

	local function movable_set(info, value)
		local frame = info[#info - 1]
		self:ShowFrameMover(frame, not not value)
	end

	local function x_get(info)
		local key = info[#info - 1]
		local frame = movers[key] or nameToFrame[key]
		if not frame then
			self:ShowFrameMover(key, true, true)
			self:ShowFrameMover(key, false, true)
			frame = movers[key]
		end
		local point = self.db.profile[key][1]
		local x = self.db.profile[key][2]
		if not x or not frame then
			return 0
		end
		x = x * frame:GetEffectiveScale() / UIParent:GetEffectiveScale()
		if point == "LEFT" or point == "BOTTOMLEFT" or point == "TOPLEFT" then
			return x - GetScreenWidth()/2 + frame:GetWidth()/2
		elseif point == "CENTER" or point == "TOP" or point == "BOTTOM" then
			return x
		else
			return x + GetScreenWidth()/2 - frame:GetWidth()/2
		end
	end

	local function y_get(info)
		local key = info[#info - 1]
		local frame = movers[key] or nameToFrame[key]
		if not frame then
			self:ShowFrameMover(key, true, true)
			self:ShowFrameMover(key, false, true)
			frame = movers[key]
		end
		local point = self.db.profile[key][1]
		local y = self.db.profile[key][3]
		if not y or not frame then
			return 0
		end
		y = y * frame:GetEffectiveScale() / UIParent:GetEffectiveScale()
		if point == "BOTTOM" or point == "BOTTOMLEFT" or point == "BOTTOMRIGHT" then
			return y - GetScreenHeight()/2 + frame:GetHeight()/2
		elseif point == "CENTER" or point == "LEFT" or point == "RIGHT" then
			return y
		else
			return y + GetScreenHeight()/2 - frame:GetHeight()/2
		end
	end

	local function x_set(info, value)
		local key = info[#info - 1]
		local y = y_get(info)
		local point, x, y = getPointXY(movers[key] or nameToFrame[key], value + GetScreenWidth()/2, y + GetScreenHeight()/2)
		if key == "minimap" then
			Chinchilla_Position:SetMinimapPosition(point, x, y)
		else
			Chinchilla_Position:SetFramePosition(key, point, x, y)
		end
	end

	local function y_set(info, value)
		local key = info[#info - 1]
		local x = x_get(info)
		local point, x, y = getPointXY(movers[key] or nameToFrame[key], x + GetScreenWidth()/2, value + GetScreenHeight()/2)
		if key == "minimap" then
			Chinchilla_Position:SetMinimapPosition(point, x, y)
		else
			Chinchilla_Position:SetFramePosition(key, point, x, y)
		end
	end

	local x_min = -math.floor(GetScreenWidth()/10 + 0.5)*5

	local x_max = math.floor(GetScreenWidth()/10 + 0.5)*5

	local y_min = -math.floor(GetScreenHeight()/10 + 0.5)*5

	local y_max = math.floor(GetScreenHeight()/10 + 0.5)*5

	return {
		name = L["Position"],
		desc = Chinchilla_Position.desc,
		type = 'group',
		args = {
			minimap = {
				name = L["Minimap"],
				desc = L["Position of the minimap on the screen"],
				type = 'group',
				inline = true,
				args = {
					lock = {
						name = L["Movable"],
						desc = L["Allow the minimap to be movable so you can drag it where you want"],
						type = 'toggle',
						order = 1,
						get = function(info)
							return not Chinchilla_Position:IsLocked()
						end,
						set = function(info, value)
							Chinchilla_Position:SetLocked(not value)
						end
					},
					x = {
						name = L["Horizontal position"],
						desc = L["Set the position on the x-axis for the minimap."],
						type = 'range',
						min = x_min,
						max = x_max,
						step = 1,
						bigStep = 5,
						get = x_get,
						set = x_set,
						order = 3,
					},
					y = {
						name = L["Vertical position"],
						desc = L["Set the position on the y-axis for the minimap."],
						type = 'range',
						min = y_min,
						max = y_max,
						step = 1,
						bigStep = 5,
						-- stepBasis = 0,
						get = y_get,
						set = y_set,
						order = 4,
					},
				}
			},
			durability = {
				name = L["Durability"],
				desc = L["Position of the metal durability man on the screen"],
				type = 'group',
				inline = true,
				args = {
					movable = {
						name = L["Movable"],
						desc = L["Show a frame that is movable to show where you want the durability man to be"],
						type = 'toggle',
						order = 1,
						get = movable_get,
						set = movable_set,
					},
					x = {
						name = L["Horizontal position"],
						desc = L["Set the position on the x-axis for the durability man."],
						type = 'range',
						min = x_min,
						max = x_max,
						step = 1,
						bigStep = 5,
						get = x_get,
						set = x_set,
						order = 3,
					},
					y = {
						name = L["Vertical position"],
						desc = L["Set the position on the y-axis for the durability man."],
						type = 'range',
						min = y_min,
						max = y_max,
						step = 1,
						bigStep = 5,
						-- stepBasis = 0,
						get = y_get,
						set = y_set,
						order = 4,
					},
				}
			},
			questWatch = {
				name = L["Quest and achievement tracker"],
				desc = L["Position of the quest/achievement tracker on the screen"],
				type = 'group',
				inline = true,
				args = {
					movable = {
						name = L["Movable"],
						desc = L["Show a frame that is movable to show where you want the quest tracker to be"],
						type = 'toggle',
						order = 1,
						get = movable_get,
						set = movable_set,
					},
					x = {
						name = L["Horizontal position"],
						desc = L["Set the position on the x-axis for the quest tracker."],
						type = 'range',
						min = x_min,
						max = x_max,
						step = 1,
						bigStep = 5,
						get = x_get,
						set = x_set,
						order = 3,
					},
					y = {
						name = L["Vertical position"],
						desc = L["Set the position on the y-axis for the quest tracker."],
						type = 'range',
						min = y_min,
						max = y_max,
						step = 1,
						bigStep = 5,
						-- stepBasis = 0,
						get = y_get,
						set = y_set,
						order = 4,
					},
				}
			},
			boss = {
				name = L["Boss frames"],
				desc = L["Position of the boss unit frames on the screen"],
				type = 'group',
				inline = true,
				args = {
					movable = {
						name = L["Movable"],
						desc = L["Show a frame that is movable to show where you want the boss frames to be"],
						type = 'toggle',
						order = 1,
						get = movable_get,
						set = movable_set,
					},
					x = {
						name = L["Horizontal position"],
						desc = L["Set the position on the x-axis for the boss frames."],
						type = 'range',
						min = x_min,
						max = x_max,
						step = 1,
						bigStep = 5,
						get = x_get,
						set = x_set,
						order = 3,
					},
					y = {
						name = L["Vertical position"],
						desc = L["Set the position on the y-axis for the boss frames."],
						type = 'range',
						min = y_min,
						max = y_max,
						step = 1,
						bigStep = 5,
						-- stepBasis = 0,
						get = y_get,
						set = y_set,
						order = 4,
					},
				},
			},
			vehicleSeats = {
				name = L["Vehicle seats"],
				desc = L["Position of the vehicle seat indicator on the screen"],
				type = 'group',
				inline = true,
				args = {
					movable = {
						name = L["Movable"],
						desc = L["Show a frame that is movable to show where you want the vehicle seat indicator to be"],
						type = 'toggle',
						order = 1,
						get = movable_get,
						set = movable_set,
					},
					x = {
						name = L["Horizontal position"],
						desc = L["Set the position on the x-axis for the vehicle seat indicator."],
						type = 'range',
						min = x_min,
						max = x_max,
						step = 1,
						bigStep = 5,
						get = x_get,
						set = x_set,
						order = 3,
					},
					y = {
						name = L["Vertical position"],
						desc = L["Set the position on the y-axis for the vehicle seat indicator."],
						type = 'range',
						min = y_min,
						max = y_max,
						step = 1,
						bigStep = 5,
						-- stepBasis = 0,
						get = y_get,
						set = y_set,
						order = 4,
					},
				}
			},
			ticketStatus = {
				name = L["Ticket status"],
				desc = L["Position of the ticket status indicator on the screen"],
				type = 'group',
				inline = true,
				args = {
					movable = {
						name = L["Movable"],
						desc = L["Show a frame that is movable to show where you want the ticket status indicator to be"],
						type = 'toggle',
						order = 1,
						get = movable_get,
						set = movable_set,
					},
					x = {
						name = L["Horizontal position"],
						desc = L["Set the position on the x-axis for the ticket status indicator."],
						type = 'range',
						min = x_min,
						max = x_max,
						step = 1,
						bigStep = 5,
						get = x_get,
						set = x_set,
						order = 3,
					},
					y = {
						name = L["Vertical position"],
						desc = L["Set the position on the y-axis for the ticket status indicator."],
						type = 'range',
						min = y_min,
						max = y_max,
						step = 1,
						bigStep = 5,
						-- stepBasis = 0,
						get = y_get,
						set = y_set,
						order = 4,
					},
				},
			},
			worldState = {
				name = L["World state"],
				desc = L["Position of the world state indicator on the screen"],
				type = 'group',
				inline = true,
				args = {
					movable = {
						name = L["Movable"],
						desc = L["Show a frame that is movable to show where you want the world state indicator to be"],
						type = 'toggle',
						order = 1,
						get = movable_get,
						set = movable_set,
					},
					x = {
						name = L["Horizontal position"],
						desc = L["Set the position on the x-axis for the world state indicator."],
						type = 'range',
						min = x_min,
						max = x_max,
						step = 1,
						bigStep = 5,
						get = x_get,
						set = x_set,
						order = 3,
					},
					y = {
						name = L["Vertical position"],
						desc = L["Set the position on the y-axis for the world state indicator."],
						type = 'range',
						min = y_min,
						max = y_max,
						step = 1,
						bigStep = 5,
						-- stepBasis = 0,
						get = y_get,
						set = y_set,
						order = 4,
					},
				}
			},
			capture = {
				name = L["Capture bar"],
				desc = L["Position of the capture bar on the screen"],
				type = 'group',
				inline = true,
				args = {
					movable = {
						name = L["Movable"],
						desc = L["Show a frame that is movable to show where you want the capture bar to be"],
						type = 'toggle',
						order = 1,
						get = movable_get,
						set = movable_set,
					},
					x = {
						name = L["Horizontal position"],
						desc = L["Set the position on the x-axis for the capture bar."],
						type = 'range',
						min = x_min,
						max = x_max,
						step = 1,
						bigStep = 5,
						get = x_get,
						set = x_set,
						order = 3,
					},
					y = {
						name = L["Vertical position"],
						desc = L["Set the position on the y-axis for the capture bar."],
						type = 'range',
						min = y_min,
						max = y_max,
						step = 1,
						bigStep = 5,
						-- stepBasis = 0,
						get = y_get,
						set = y_set,
						order = 4,
					},
				},
			},
		},
	}
end)
