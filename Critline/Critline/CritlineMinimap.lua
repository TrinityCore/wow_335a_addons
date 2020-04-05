local L = LibStub("AceLocale-3.0"):GetLocale("Critline")
local module

local _, addon = ...

local trees = {"dmg", "heal", "pet"}


addon.minimap = CreateFrame("Button", "CritlineMinimapFrame", Minimap)
module = addon.minimap
module:SetFrameStrata("LOW")
module:SetToplevel(true)
module:SetMovable(true)
module:RegisterForClicks("LeftButtonUp", "RightButtonUp")
module:RegisterForDrag("LeftButton")
module:SetPoint("TOPLEFT", -15, 0)
module:SetSize(33, 33)
module:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
module:Hide()
module:RegisterEvent("ADDON_LOADED")
module:SetScript("OnEvent", function(self, event, addon)
	if addon == "Critline" then
		if CritlineSettings.showMinimap then
			self:Show()
		else
			self:Hide()
		end 
		self:Move()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)

module:SetScript("OnClick", function(self, button)
	if button == "LeftButton" then
		if addon.display:IsVisible() then
			for _, tree in ipairs(trees) do
				addon.display:UpdateTree(tree, false)
			end
		else
			if (CritlineSettings.dmgDisplay or CritlineSettings.healDisplay or CritlineSettings.petDisplay) then
				addon.display:Show()
			else
				-- if all trees are hidden when minimap is called to show, reload with default class settings
				CritlineSettings.firstLoad = true
				addon.display:Setup()
			end
		end
	elseif button == "RightButton" then
		InterfaceOptionsFrame_OpenToCategory(addon.settings.basic)
	end
	self.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
end)

module:SetScript("OnHide", function(self)
	self.isDragging = false
end)

module:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:AddLine("Critline")
	GameTooltip:AddLine(L["Left-click to toggle summary frame\nRight-click to open options\nDrag to move"], HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	GameTooltip:Show()
end)

module:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

module:SetScript("OnMouseDown", function(self)
	self.icon:SetTexCoord(0, 1, 0, 1)
end)

module:SetScript("OnMouseUp", function(self)
	self.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
end)

module:SetScript("OnDragStart", function(self)
	self:LockHighlight()
	self.isDragging = true
end)

module:SetScript("OnUpdate", function(self)
	if self.isDragging then
		local xpos, ypos = GetCursorPosition()
		local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()
		
		xpos = xmin - xpos / Minimap:GetEffectiveScale() + 70
		ypos = ypos / Minimap:GetEffectiveScale() - ymin - 70
		
		CritlineSettings.minimapPos = atan2(ypos, xpos)
		self:Move()
	end
end)

module:SetScript("OnDragStop", function(self)
	self:UnlockHighlight()
	self.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
	self.isDragging = false
end)

local icon = module:CreateTexture()
icon:SetTexture(addon.display.dmgIcon)
icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
icon:SetPoint("TOPLEFT", 7, -6)
icon:SetSize(21, 21)
module.icon = icon

local border = module:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
border:SetPoint("TOPLEFT")
border:SetSize(56, 56)


function module:Move()
	local xpos, ypos
	local angle = CritlineSettings.minimapPos

	xpos = 80 * cos(angle)
	ypos = 80 * sin(angle)

	self:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", (52 - xpos), (ypos - 52))
end