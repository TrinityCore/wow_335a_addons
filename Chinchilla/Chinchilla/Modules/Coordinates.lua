
local Coordinates = Chinchilla:NewModule("Coordinates", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Chinchilla")

Coordinates.displayName = L["Coordinates"]
Coordinates.desc = L["Show coordinates on or near the minimap"]


local coordString
local function recalculateCoordString()
	local sep

	if ("%.1f"):format(1.1) == "1,1" then sep = " x "
	else sep = ", " end

	local prec = Coordinates.db.profile.precision

	coordString = ("%%.%df%s%%.%df"):format(prec, sep, prec)
end

function Coordinates:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("Coordinates", {
		profile = {
			precision = 1,
			scale = 1,
			positionX = -30,
			positionY = -50,
			background = {
				TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,
				TOOLTIP_DEFAULT_BACKGROUND_COLOR.g,
				TOOLTIP_DEFAULT_BACKGROUND_COLOR.b,
				1,
			},
			border = {
				TOOLTIP_DEFAULT_COLOR.r,
				TOOLTIP_DEFAULT_COLOR.g,
				TOOLTIP_DEFAULT_COLOR.b,
				1,
			},
			textColor = {
				0.8,
				0.8,
				0.6,
				1,
			},
			enabled = true,
		},
	})

	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local frame, timerID
function Coordinates:OnEnable()
	if not frame then
		frame = CreateFrame("Frame", "Chinchilla_Coordinates_Frame", Minimap)
		frame:SetBackdrop({
			bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
			edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
			tile = true,
			tileSize = 16,
			edgeSize = 16,
			insets = {
				left = 4,
				right = 4,
				top = 4,
				bottom = 4,
			},
		})

		frame:SetWidth(1)
		frame:SetHeight(1)

		local text = frame:CreateFontString(frame:GetName() .. "_FontString", "ARTWORK", "GameFontNormalSmall")
		frame.text = text
		text:SetPoint("CENTER")

		function frame:Update()
			local x, y = GetPlayerMapPosition("player")
			if x == 0 and y == 0 then
				-- instance or can't get coords
				self:Hide()
			else
				if not self:IsShown() then
					self:Show()
					Coordinates:Update()
					return
				end
				text:SetText(coordString:format(x*100, y*100))
			end
		end

		frame:SetScript("OnDragStart", function(this) this:StartMoving() end)
		frame:SetScript("OnDragStop", function(this)
			this:StopMovingOrSizing()

			local cx, cy = this:GetCenter()
			local scale = frame:GetEffectiveScale() / UIParent:GetEffectiveScale()

			cx, cy = cx*scale, cy*scale

			local mx, my = Minimap:GetCenter()
			local mscale = Minimap:GetEffectiveScale() / UIParent:GetEffectiveScale()

			mx, my = mx*mscale, my*mscale

			local x, y = cx - mx, cy - my

			self.db.profile.positionX = x/scale
			self.db.profile.positionY = y/scale
			self:Update()

			LibStub("AceConfigRegistry-3.0"):NotifyChange("Chinchilla")
		end)
	end

	frame:Show()

	-- need these otherwise the frame won't scale on login
	recalculateCoordString()
	self:ScheduleTimer("Update", 0)

	timerID = self:ScheduleRepeatingTimer(frame.Update, 0.1, frame)
end

function Coordinates:OnDisable()
	self:CancelTimer(timerID)
	frame:Hide()
end

function Coordinates:Update()
	if not self:IsEnabled() then return end

	recalculateCoordString()

	frame:SetScale(self.db.profile.scale)
	frame.text:SetText(coordString:format(12.345, 23.456))
	frame:SetFrameLevel(MinimapCluster:GetFrameLevel()+7)
	frame:SetWidth(frame.text:GetWidth() + 12)
	frame:SetHeight(frame.text:GetHeight() + 12)
	frame.text:SetTextColor(unpack(self.db.profile.textColor))
	frame:SetBackdropColor(unpack(self.db.profile.background))
	frame:SetBackdropBorderColor(unpack(self.db.profile.border))
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", Minimap, "CENTER", self.db.profile.positionX, self.db.profile.positionY)
	frame:Update()
end

function Coordinates:SetMovable(value)
	frame:SetMovable(value)
	frame:EnableMouse(value)

	if value then frame:RegisterForDrag("LeftButton")
	else frame:RegisterForDrag() end
end


function Coordinates:GetOptions()
	return {
		precision = {
			name = L["Precision"],
			desc = L["Set the amount of numbers past the decimal place to show."],
			type = 'range',
			min = 0,
			max = 3,
			step = 1,
			get = function(info)
				return self.db.profile.precision
			end,
			set = function(info, value)
				self.db.profile.precision = value
				self:Update()
			end,
		},
		scale = {
			name = L["Size"],
			desc = L["Set the size of the coordinate display."],
			type = 'range',
			min = 0.25,
			max = 4,
			step = 0.01,
			bigStep = 0.05,
			isPercent = true,
			get = function(info)
				return self.db.profile.scale
			end,
			set = function(info, value)
				self.db.profile.scale = value
				self:Update()
			end,
		},
		background = {
			name = L["Background"],
			desc = L["Set the background color"],
			type = 'color',
			hasAlpha = true,
			get = function(info)
				return unpack(self.db.profile.background)
			end,
			set = function(info, r, g, b, a)
				local t = self.db.profile.background
				t[1] = r
				t[2] = g
				t[3] = b
				t[4] = a
				self:Update()
			end,
		},
		border = {
			name = L["Border"],
			desc = L["Set the border color"],
			type = 'color',
			hasAlpha = true,
			get = function(info)
				return unpack(self.db.profile.border)
			end,
			set = function(info, r, g, b, a)
				local t = self.db.profile.border
				t[1] = r
				t[2] = g
				t[3] = b
				t[4] = a
				self:Update()
			end,
		},
		textColor = {
			name = L["Text"],
			desc = L["Set the text color"],
			type = 'color',
			hasAlpha = true,
			get = function(info)
				return unpack(self.db.profile.textColor)
			end,
			set = function(info, r, g, b, a)
				local t = self.db.profile.textColor
				t[1] = r
				t[2] = g
				t[3] = b
				t[4] = a
				self:Update()
			end,
		},
		position = {
			name = L["Position"],
			desc = L["Set the position of the coordinate indicator"],
			type = 'group',
			inline = true,
			args = {
				movable = {
					name = L["Movable"],
					desc = L["Allow the coordinate indicator to be moved"],
					type = 'toggle',
					get = function(info)
						return frame and frame:IsMovable()
					end,
					set = function(info, value)
						self:SetMovable(value)
					end,
					order = 1,
					disabled = function()
						return not frame
					end,
				},
				x = {
					name = L["Horizontal position"],
					desc = L["Set the position on the x-axis for the coordinate indicator relative to the minimap."],
					type = 'range',
					min = -math.floor(GetScreenWidth()/5 + 0.5)*5,
					max = math.floor(GetScreenWidth()/5 + 0.5)*5,
					step = 1,
					bigStep = 5,
					get = function(info)
						return self.db.profile.positionX
					end,
					set = function(info, value)
						self.db.profile.positionX = value
						self:Update()
					end,
					order = 2,
				},
				y = {
					name = L["Vertical position"],
					desc = L["Set the position on the y-axis for the coordinate indicator relative to the minimap."],
					type = 'range',
					min = -math.floor(GetScreenHeight()/5 + 0.5)*5,
					max = math.floor(GetScreenHeight()/5 + 0.5)*5,
					step = 1,
					bigStep = 5,
					get = function(info)
						return self.db.profile.positionY
					end,
					set = function(info, value)
						self.db.profile.positionY = value
						self:Update()
					end,
					order = 3,
				},
			},
		},
--[[		position = {
			name = L["Position"],
			desc = L["Set the position of the coordinate indicator"],
			type = 'choice',
			choices = {
				["BOTTOM;BOTTOM"] = L["Bottom, inside"],
				["TOP;BOTTOM"] = L["Bottom, outside"],
				["TOP;TOP"] = L["Top, inside"],
				["BOTTOM;TOP"] = L["Top, outside"],
				["TOPLEFT;TOPLEFT"] = L["Top-left"],
				["BOTTOMLEFT;BOTTOMLEFT"] = L["Bottom-left"],
				["TOPRIGHT;TOPRIGHT"] = L["Top-right"],
				["BOTTOMRIGHT;BOTTOMRIGHT"] = L["Bottom-right"]
			},
			get = function()
				return self.db.profile.point .. ";" .. self.db.profile.relpoint
			end,
			set = function(value)
				self.db.profile.point, self.db.profile.relpoint = value:match("(.*);(.*)")
				self:Update()
			end,
]]--		},
	}
end
