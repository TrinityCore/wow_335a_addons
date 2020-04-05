
local Location = Chinchilla:NewModule("Location", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Chinchilla")

Location.displayName = L["Location"]
Location.desc = L["Show zone information on or near minimap"]


function Location:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("Location", {
		profile = {
			scale = 1.2,
			positionX = 0,
			positionY = 70,
			showClose = true,
			background = {
				TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 1,
			},
			border = {
				TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b, 1,
			},
--			textColor = {
--				1, 0.82, 0, 1,
--			},
			enabled = true,
		},
	})

	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

local frame
function Location:OnEnable()
	if not frame then
		frame = CreateFrame("Frame", "Chinchilla_Location_Frame", MinimapCluster)
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
				bottom = 4
			}
		})

		frame:SetWidth(1)
		frame:SetHeight(1)

		local text = frame:CreateFontString(frame:GetName() .. "_FontString", "ARTWORK", "GameFontNormalSmall")
		frame.text = text
		text:SetPoint("CENTER")

		frame:SetScript("OnDragStart", function(this)
			this:StartMoving()
		end)
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

		local closeButton = CreateFrame("Button", frame:GetName() .. "_CloseButton", frame)
		frame.closeButton = closeButton

		closeButton:SetWidth(27)
		closeButton:SetHeight(27)
		closeButton:SetPoint("LEFT", frame, "RIGHT", -6, 0)

		closeButton:SetScript("OnClick", function(this, button)
			if Minimap:IsShown() then
				PlaySound("igMiniMapClose")
				Minimap:Hide()
				this:SetNormalTexture("Interface\\Buttons\\UI-Panel-ExpandButton-Up")
				this:SetPushedTexture("Interface\\Buttons\\UI-Panel-ExpandButton-Down")
			else
				PlaySound("igMiniMapOpen")
				Minimap:Show()
				this:SetNormalTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Up")
				this:SetPushedTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Down")
			end
			UpdateUIPanelPositions()
		end)

		closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Up")
		closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Down")
		closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
	end

	frame:Show()

	if self.db.profile.showClose then
		frame.closeButton:Show()
	else
		frame.closeButton:Hide()
	end

	self:Update()
	self:RegisterEvent("ZONE_CHANGED", "Update")
	self:RegisterEvent("ZONE_CHANGED_INDOORS", "Update")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Update")

	MinimapBorderTop:Hide()
	MinimapZoneTextButton:Hide()

	if Chinchilla:GetModule("ShowHide", true) then
		Chinchilla:GetModule("ShowHide"):Update()
	end
end

function Location:OnDisable()
	frame:Hide()

	MinimapBorderTop:Show()
	MinimapZoneTextButton:Show()

	if Chinchilla:GetModule("ShowHide", true) then
		Chinchilla:GetModule("ShowHide"):Update()
	end
end

function Location:Update()
	if not self:IsEnabled() then
		return
	end

	local scale = self.db.profile.scale

	frame:SetScale(scale)
	frame:SetFrameLevel(MinimapCluster:GetFrameLevel()+7)

	frame.closeButton:SetFrameLevel(MinimapCluster:GetFrameLevel()+7)

	frame:SetBackdropColor(unpack(self.db.profile.background))
	frame:SetBackdropBorderColor(unpack(self.db.profile.border))

	frame:ClearAllPoints()
	frame:SetPoint("CENTER", MinimapCluster, "CENTER", self.db.profile.positionX+9/scale, self.db.profile.positionY+4/scale)

	frame.text:SetText(GetMinimapZoneText())
	frame:SetWidth(frame.text:GetWidth() + 12)
	frame:SetHeight(frame.text:GetHeight() + 12)

	local pvpType = GetZonePVPInfo()

	if pvpType == "sanctuary" then
		frame.text:SetTextColor(0.41, 0.8, 0.94)
	elseif pvpType == "arena" then
		frame.text:SetTextColor(1.0, 0.1, 0.1)
	elseif pvpType == "friendly" then
		frame.text:SetTextColor(0.1, 1.0, 0.1)
	elseif pvpType == "hostile" then
		frame.text:SetTextColor(1.0, 0.1, 0.1)
	elseif pvpType == "contested" then
		frame.text:SetTextColor(1.0, 0.7, 0.0)
	else
		frame.text:SetTextColor(1.0, 0.82, 0.0)
	end
end

function Location:SetMovable(value)
	frame:SetMovable(value)
	frame:EnableMouse(value)

	if value then frame:RegisterForDrag("LeftButton")
	else frame:RegisterForDrag() end
end


function Location:GetOptions()
	return {
		scale = {
			name = L["Size"],
			desc = L["Set the size of the location display."],
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
			end
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
			end
		},
--[[		textColor = {
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
			end
]]--		},
		showClose = {
			name = L["Show close button"],
			desc = L["Show the button to hide the minimap"],
			type = 'toggle',
			get = function(info)
				return self.db.profile.showClose
			end,
			set = function(info, value)
				self.db.profile.showClose = value
				if frame then
					if value then
						frame.closeButton:Show()
					else
						frame.closeButton:Hide()
					end
				end
			end
		},
		position = {
			name = L["Position"],
			desc = L["Set the position of the location indicator"],
			type = 'group',
			inline = true,
			args = {
				movable = {
					name = L["Movable"],
					desc = L["Allow the location indicator to be moved"],
					type = 'toggle',
					get = function(info)
						return frame and frame:IsMovable()
					end,
					set = function(info, value)
						self:SetMovable(value)
					end,
					order = 1,
					disabled = function(info)
						return not frame
					end,
				},
				x = {
					name = L["Horizontal position"],
					desc = L["Set the position on the x-axis for the location indicator relative to the minimap."],
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
					desc = L["Set the position on the y-axis for the location indicator relative to the minimap."],
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
	}
end
