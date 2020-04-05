local L = LibStub("AceLocale-3.0"):GetLocale("Critline")
local module

local _, addon = ...

local trees = {"dmg", "heal", "pet"}


local function createDisplayIcon()
	local button = CreateFrame("Button", nil, module)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetSize(22, 22)
	
	button:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			InterfaceOptionsFrame_OpenToCategory(addon.settings.basic)
		elseif button == "RightButton" then
			module:UpdateTree(self.tree, false)
		end
	end)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine("Critline", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		GameTooltip:AddLine(L["Left-click to open options\nRight-click to hide button"])
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	
	local icon = button:CreateTexture(nil, "OVERLAY")
	icon:SetPoint("CENTER")
	icon:SetSize(20, 20)
	button.icon = icon
	
	return button
end


local function createDisplay(parent)
	local frame = CreateFrame("Button", nil, module)
	frame:RegisterForDrag("RightButton")
	frame:SetPoint("LEFT", parent, "RIGHT")
	frame:SetSize(96, 22)
	frame:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = true,
	})
	frame:SetNormalFontObject("GameFontHighlightSmall")
	frame:SetPushedTextOffset(0, 0)
	frame:SetText("0/0")
	
	frame:SetScript("OnDragStart", function() module:StartMoving() end)
	frame:SetScript("OnDragStop", function() module:StopMovingOrSizing() end)
	frame:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		module:AddTooltipText(addon:GetSummaryRichText(parent.tree))
	end)
	frame:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	
	return frame
end


addon.display = CreateFrame("Frame", "CritlineDisplay", UIParent)
module = addon.display
module:SetMovable(true)
module:SetWidth(128)
module:SetPoint("CENTER")
module:SetBackdrop({
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = {left = 5, right = 101, top = 4, bottom = 4}
})
module:SetBackdropColor(0, 0, 0, 0.8)
module:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
module:RegisterEvent("ADDON_LOADED")
module:SetScript("OnEvent", function(self, event, addon)
	if addon == "Critline" then
		self:Setup()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)

module.dmgIcon = "Interface\\Icons\\Ability_SteelMelee"
module.healIcon = "Interface\\Icons\\Spell_Holy_FlashHeal"
module.petIcon = "Interface\\Icons\\Ability_Hunter_Pet_Bear"


module.dmgButton = createDisplayIcon()
module.dmgButton:SetPoint("TOPLEFT", 5, -4)
module.dmgButton.icon:SetTexture(module.dmgIcon)
module.dmgButton.tree = "dmg"

module.dmgFrame = createDisplay(module.dmgButton)
module.dmgFrame:SetBackdropColor(.25, 0, 0, .625)


module.healButton = createDisplayIcon()
module.healButton.icon:SetTexture(module.healIcon)
module.healButton.tree = "heal"

module.healFrame = createDisplay(module.healButton)
module.healFrame:SetBackdropColor(0, .25, 0, .625)


module.petButton = createDisplayIcon()
module.petButton.icon:SetTexture(module.petIcon)
module.petButton.tree = "pet"

module.petFrame = createDisplay(module.petButton)
module.petFrame:SetBackdropColor(0, 0, .25, .625)


function module:Setup()
	self:Update()
	self:SetScale(CritlineSettings.mainScale)

	local _, myClass = UnitClass("player")
	if CritlineSettings.firstLoad then -- by default on first time load, all trees are on
		local usedTrees = {
			-- CLASS = {dmg, heal, pet}
			DEATHKNIGHT = {true, false, false},
			DRUID = {true, true, false},
			HUNTER = {true, false, true},
			MAGE = {true, false, false},
			PALADIN = {true, true, false},
			PRIEST = {true, true, false},
			ROGUE = {true, false, false},
			SHAMAN = {true, true, false},
			WARLOCK = {true, false, true},
			WARRIOR = {true, false, false},
		}
		for i, tree in ipairs(trees) do
			if usedTrees[myClass] then
				CritlineSettings[tree.."Record"] = usedTrees[myClass][i]
				self:UpdateTree(tree, usedTrees[myClass][i])
			end
		end
		CritlineSettings.firstLoad = false
	else
		for i, tree in ipairs(trees) do
			self:UpdateTree(tree, CritlineSettings[tree.."Display"])
		end
	end
end


function module:Update()
	local rtfText
	for i, tree in ipairs(trees) do
		local normalRecord, critRecord = addon:GetHighest(tree)
		rtfText = format("%6d/%-6d", normalRecord, critRecord) -- rtfText will always be 13 chars long with / in the middle..this keeps all numbers aligned
		module[tree.."Frame"]:SetText(rtfText)
	end
end

addon:OnUpdateRegister(module.Update)


-- rearrange display buttons when any of them is shown or hidden
function module:UpdateTree(tree, enabled)
	local numVisibleButtons = 0
	
	local trees = {
		dmg = 4,
		heal = 5,
		pet = 6,
	}
	
	if enabled then
		self:Show()
		CritlineSettings[tree.."Display"] = true
		self[tree.."Button"]:Show()
		self[tree.."Frame"]:Show()
	else
		CritlineSettings[tree.."Display"] = false
		self[tree.."Button"]:Hide()
		self[tree.."Frame"]:Hide()
	end
	addon.settings.basic.options.checkButtons[trees[tree]]:SetChecked(enabled)
	
	-- check for anchors
	if self.healButton:IsShown() then
		self.healButton:ClearAllPoints()
		if self.dmgButton:IsShown() then
			self.healButton:SetPoint("TOP", self.dmgButton, "BOTTOM")
		else
			self.healButton:SetPoint("TOPLEFT", 5, -4)
		end
	end
	if self.petButton:IsShown() then
		self.petButton:ClearAllPoints()
		if self.healButton:IsShown() then
			self.petButton:SetPoint("TOP", self.healButton, "BOTTOM")
		elseif self.dmgButton:IsShown() then
			self.petButton:SetPoint("TOP", self.dmgButton, "BOTTOM")
		else
			self.petButton:SetPoint("TOPLEFT", 5, -4)
		end
	end
	
	if self.dmgButton:IsShown() then
		numVisibleButtons = numVisibleButtons + 1
	end
	if self.healButton:IsShown() then
		numVisibleButtons = numVisibleButtons + 1
	end
	if self.petButton:IsShown() then
		numVisibleButtons = numVisibleButtons + 1
	end
	
	self:SetHeight(numVisibleButtons * 22 + 8)
	
	if not (CritlineSettings.dmgDisplay or CritlineSettings.healDisplay or CritlineSettings.petDisplay) then
		self:Hide()
	end
end


function module:AddTooltipText(text)
	if text then
		-- Append a "\n" to the end 
		if text:sub(-1) ~= "\n" then
			text = text.."\n"
		end
		
		for text1, text2 in gmatch(text, "([^\t\n]*)\t?([^\t\n]*)\n") do
			if text2 ~= "" then
				GameTooltip:AddDoubleLine(text1, text2)
			elseif text1 ~= "" then
				GameTooltip:AddLine(text1)
			else
				GameTooltip:AddLine("\n")
			end
		end
		GameTooltip:Show()
	end
end