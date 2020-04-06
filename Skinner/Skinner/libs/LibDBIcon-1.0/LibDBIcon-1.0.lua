--[[
Name: DBIcon-1.0
Revision: $Rev: 6 $
Author(s): Rabbit (rabbit.magtheridon@gmail.com)
Description: Allows addons to register to recieve a lightweight minimap icon as an alternative to more heavy LDB displays.
Dependencies: LibStub
License: GPL v2 or later.
]]

--[[
Copyright (C) 2008 Rabbit

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
]]

-----------------------------------------------------------------------
-- DBIcon-1.0
--
-- Disclaimer: Most of this code was ripped from Barrel but fixed, streamlined
--             and cleaned up a lot so that it no longer sucks.
--

local DBICON10 = "LibDBIcon-1.0"
local DBICON10_MINOR = tonumber(("$Rev: 6 $"):match("(%d+)"))
if not LibStub then error(DBICON10 .. " requires LibStub.") end
local ldb = LibStub("LibDataBroker-1.1", true)
if not ldb then error(DBICON10 .. " requires LibDataBroker-1.1.") end
local lib = LibStub:NewLibrary(DBICON10, DBICON10_MINOR)
if not lib then return end

lib.objects = lib.objects or {}
lib.callbackRegistered = lib.callbackRegistered or nil

function lib:IconCallback(event, name, key, value, dataobj)
	if lib.objects[name] then
		lib.objects[name].icon:SetTexture(dataobj.icon)
	end
end
if not lib.callbackRegistered then
	ldb.RegisterCallback(lib, "LibDataBroker_AttributeChanged__icon", "IconCallback")
	lib.callbackRegistered = true
end

-- Tooltip code ripped from Fortress
local function getAnchors(frame)
	local x, y = frame:GetCenter()
	local xFrom, xTo = "", ""
	local yFrom, yTo = "", ""
	if x < GetScreenWidth() / 3 then
		xFrom, xTo = "LEFT", "RIGHT"
	elseif x > GetScreenWidth() / 3 then
		xFrom, xTo = "RIGHT", "LEFT"
	end
	if y < GetScreenHeight() / 3 then
		yFrom, yTo = "BOTTOM", "TOP"
		return "BOTTOM"..xFrom, "TOP"..xTo
	elseif y > GetScreenWidth() / 3 then
		yFrom, yTo = "TOP", "BOTTOM"
	end
	local from = yFrom..xFrom
	local to = yTo..xTo
	return (from == "" and "CENTER" or from), (to == "" and "CENTER" or to)
end

local GameTooltip = GameTooltip
local function GT_OnLeave()
	GameTooltip:SetScript("OnLeave", GameTooltip.oldOnLeave)
	GameTooltip:Hide()
	GameTooltip:EnableMouse(false)
end

local function PrepareTooltip(frame, anchorFrame)
	if frame == GameTooltip then
		GameTooltip.oldOnLeave = GameTooltip:GetScript("OnLeave")
		GameTooltip:EnableMouse(true)
		GameTooltip:SetScript("OnLeave", GT_OnLeave)
	end
	frame:SetOwner(anchorFrame, "ANCHOR_NONE")
	frame:ClearAllPoints()
	local from, to = getAnchors(anchorFrame)
	frame:SetPoint(from, anchorFrame, to)	
end

local function onEnter(self)
	local o = self.dataObject
	if o.tooltip then
		PrepareTooltip(o.tooltip, self)
		if o.tooltiptext then
			o.tooltip:SetText(o.tooltiptext)
		end
		o.tooltip:Show()
	elseif o.OnTooltipShow then
		PrepareTooltip(GameTooltip, self)
		o.OnTooltipShow(GameTooltip)
		GameTooltip:Show()
	elseif o.tooltiptext then
		PrepareTooltip(GameTooltip, self)
		GameTooltip:SetText(o.tooltiptext)
		GameTooltip:Show()
	end
	if o.OnEnter then o.OnEnter(self) end
end

local function onLeave(self)
	local o = self.dataObject
	if MouseIsOver(GameTooltip) and (o.tooltiptext or o.OnTooltipShow) then return end	
	if o.tooltiptext or o.OnTooltipShow then
		GT_OnLeave(GameTooltip)
	end
	if o.OnLeave then o.OnLeave(self) end
end
--------------------------------------------------------------------------------

local minimapShapes = {
	["ROUND"] = {true, true, true, true},
	["SQUARE"] = {false, false, false, false},
	["CORNER-TOPLEFT"] = {true, false, false, false},
	["CORNER-TOPRIGHT"] = {false, false, true, false},
	["CORNER-BOTTOMLEFT"] = {false, true, false, false},
	["CORNER-BOTTOMRIGHT"] = {false, false, false, true},
	["SIDE-LEFT"] = {true, true, false, false},
	["SIDE-RIGHT"] = {false, false, true, true},
	["SIDE-TOP"] = {true, false, true, false},
	["SIDE-BOTTOM"] = {false, true, false, true},
	["TRICORNER-TOPLEFT"] = {true, true, true, false},
	["TRICORNER-TOPRIGHT"] = {true, false, true, true},
	["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
	["TRICORNER-BOTTOMRIGHT"] = {false, true, true, true},
}

local function updatePosition(button)
	local radius = button.db.radius or 80
	local rounding = button.db.rounding or 10
	local position = button.db.minimapPos or random(0, 360)
	button.db.minimapPos = position
	button.db.radius = radius

	local angle = math.rad(position)
	local x, y, q = math.cos(angle), math.sin(angle), 1
	if x < 0 then q = q + 1 end
	if y > 0 then q = q + 2 end
	local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
	local quadTable = minimapShapes[minimapShape]
	if quadTable[q] then
		x, y = x*radius, y*radius
	else
		local diagRadius = math.sqrt(2*(radius)^2)-rounding
		x = math.max(-radius, math.min(x*diagRadius, radius))
		y = math.max(-radius, math.min(y*diagRadius, radius))
	end
	button:SetPoint("CENTER", Minimap, "CENTER", x, y)
	if not button.db.hide then
		button:Show()
	else
		button:Hide()
	end
end

local function onClick(self, b) if self.dataObject.OnClick then self.dataObject.OnClick(self, b) end end
local function onMouseDown(self) self.icon:SetTexCoord(0, 1, 0, 1) end
local function onMouseUp(self) self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95) end

local function onUpdate(self)
	local mx, my = Minimap:GetCenter()
	local px, py = GetCursorPosition()
	local scale = Minimap:GetEffectiveScale()
	px, py = px / scale, py / scale
	self.db.minimapPos = math.deg(math.atan2(py - my, px - mx)) % 360
	updatePosition(self)
end

local function onDragStart(self)
	self:LockHighlight()
	self.icon:SetTexCoord(0, 1, 0, 1)
	self:SetScript("OnUpdate", onUpdate)
	GameTooltip:Hide()
end

local function onDragStop(self)
	self:SetScript("OnUpdate", nil)
	self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	self:UnlockHighlight()
end

local function updateAndKill(self, elapsed)
	self.total = self.total + elapsed
	if self.total <= 15 then 
		updatePosition(self)
		self:SetScript("OnUpdate", nil)
	end
end

function lib:Register(name, object, db)
	if not object.icon then error("Can't register LDB objects without icons set!") end
	if lib.objects[name] then error("Already registered, nubcake.") end

	local button = CreateFrame("Button", "LibDBIcon10_"..name, Minimap)
	button.dataObject = object
	button.db = db
	button:SetFrameStrata("MEDIUM")
	button:SetWidth(31); button:SetHeight(31)
	button:SetFrameLevel(8)
	button:RegisterForClicks("anyUp")
	button:RegisterForDrag("LeftButton")
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	local overlay = button:CreateTexture(nil, "OVERLAY")
	overlay:SetWidth(53); overlay:SetHeight(53)
	overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	overlay:SetPoint("TOPLEFT")
	local icon = button:CreateTexture(nil, "BACKGROUND")
	icon:SetWidth(20); icon:SetHeight(20)
	icon:SetTexture(object.icon)
	icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	icon:SetPoint("TOPLEFT", 7, -5)
	button.icon = icon

	button.total = 0
	button:SetScript("OnEnter", onEnter)
	button:SetScript("OnLeave", onLeave)
	button:SetScript("OnClick", onClick)
	button:SetScript("OnDragStart", onDragStart)
	button:SetScript("OnDragStop", onDragStop)
	button:SetScript("OnMouseDown", onMouseDown)
	button:SetScript("OnMouseUp", onMouseUp)
	button:SetScript("OnUpdate", updateAndKill)
	lib.objects[name] = button
	updatePosition(button)
end

function lib:Hide(name) lib.objects[name]:Hide() end
function lib:Show(name) lib.objects[name]:Show() end
function lib:IsRegistered(name)
	return lib.objects[name] and true or false
end

function lib:Refresh(name, db)
	local button = lib.objects[name]
	if db then button.db = db end
	updatePosition(button)
end
