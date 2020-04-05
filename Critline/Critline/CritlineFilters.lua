local L = LibStub("AceLocale-3.0"):GetLocale("Critline")
local module

local _, addon = ...

-- amount of buttons in the spell and mob filter scroll lists
local MAXSPELLFILTERBUTTONS = 15
local NUMMOBFILTERBUTTONS = 20

local treeList

local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff

-- mobs whose received hits won't be tracked due to various vulnerabilities
local specialMobs = {
	[12460] = true,	-- Death Talon Wyrmguard
	[12461] = true,	-- Death Talon Overseer
	[14020] = true,	-- Chromaggus
	[15339] = true,	-- Ossirian the Unscarred
	[15928] = true,	-- Thaddius
	[16803] = true, -- Death Knight Understudy
	[22841] = true,	-- Shade of Akama
	[33329] = true, -- Heart of the Deconstructor
	[33670] = true, -- Aerial Command Unit
	[34496] = true, -- Eydis Darkbane
	[34497] = true, -- Fjola Lightbane
	[34797] = true, -- Icehowl
	[38567] = true, -- Phantom Hallucination
}

-- auras that when gained will suppress record tracking
local specialAuras = {
	[18173] = true,	-- Burning Adrenaline (Vaelastrasz the Corrupt)
	[41337] = true,	-- Aura of Anger (Reliquary of Souls)
	[41350] = true,	-- Aura of Desire (Reliquary of Souls)
	[44335] = true,	-- Energy Feedback (Vexallus)
	[44406] = true,	-- Energy Infusion (Vexallus)
	[53642] = true,	-- Might of Mograine (Light's Hope Chapel)
	[55849] = true,	-- Power Spark (Malygos)
	[56330] = true,	-- Iron's Bane (Storm Peaks quest)
	[56648] = true,	-- Potent Fungus (Amanitar)
	[57524] = true, -- Metanoia (Valkyrion Aspirant)
	[58026] = true,	-- Blessing of the Crusade (Icecrown quest)
	[58361] = true,	-- Might of Mograine (Patchwerk)
	[58549] = true,	-- Tenacity (Lake Wintergrasp)
	[59641] = true,	-- Warchief's Blessing (The Battle For The Undercity)
	[60964] = true,	-- Strength of Wrynn (The Battle For The Undercity)
	[61888] = true, -- Overwhelming Power (Assembly of Iron - 10 man hard mode)
	[62243] = true, -- Unstable Sun Beam (Elder Brightleaf)
	[62650] = true, -- Fortitude of Frost (Yogg-Saron)
	[62670] = true, -- Resilience of Nature (Yogg-Saron)
	[62671] = true, -- Speed of Invention (Yogg-Saron)
	[62702] = true, -- Fury of the Storm (Yogg-Saron)
	[63277] = true, -- Shadow Crash (General Vezax)
	[63711] = true, -- Storm Power (Hodir)
	[64320] = true, -- Rune of Power (Assembly of Iron)
	[64321] = true, -- Potent Pheromones (Freya)
	[64637] = true, -- Overwhelming Power (Assembly of Iron - 25 man hard mode)
	[72219] = true, -- Gastric Bloat (Festergut)
}

OrigSpellButton_OnModifiedClick = SpellButton_OnModifiedClick


local function spellButtonOnClick(self)
	if self:GetChecked() then
		PlaySound("igMainMenuOptionCheckBoxOn")
		module:AddSpell(UIDropDownMenu_GetSelectedValue(treeList), self.spell, self.isPeriodic)
	else
		PlaySound("igMainMenuOptionCheckBoxOff")
		module:DeleteSpell(UIDropDownMenu_GetSelectedValue(treeList), self.spell, self.isPeriodic)
	end
end


-- template function for spell filter check buttons
local function createSpellButton(self)
	local checkButton = CreateFrame("CheckButton", nil, self, "OptionsBaseCheckButtonTemplate")
	checkButton:SetPushedTextOffset(0, 0)
	checkButton:SetScript("OnClick", spellButtonOnClick)
	
	local checkButtonText = checkButton:CreateFontString(nil, nil, "GameFontHighlight")
	checkButtonText:SetPoint("LEFT", checkButton, "RIGHT", 0, 1)
	checkButtonText:SetJustifyH("LEFT")
	checkButton:SetFontString(checkButtonText)
	
	return checkButton
end


local function mobButtonOnClick(self)
	local scrollFrame = module.mobFilter.scrollFrame
	local offset = FauxScrollFrame_GetOffset(scrollFrame)
	local id = self:GetID()
	
	if scrollFrame.selected then
		if scrollFrame.selected - offset == id then
			-- clicking the selected button, clear selection
			self:UnlockHighlight()
			scrollFrame.selected = nil
		else
			-- clear selection if visible, and set new selection
			local prevHighlight = module.mobFilter.buttons[scrollFrame.selected - offset]
			if prevHighlight then
				prevHighlight:UnlockHighlight()
			end
			self:LockHighlight()
			scrollFrame.selected = id + offset
		end
	else
		-- no previous selection, just set new and lock highlight
		self:LockHighlight()
		scrollFrame.selected = id + offset
	end
	
	-- enable/disable "Delete" button depending on if selection exists
	if scrollFrame.selected then
		module.mobFilter.deleteButton:Enable()
	else
		module.mobFilter.deleteButton:Disable()
	end
end


-- template function for mob filter buttons
local function createMobButton(self)
	local button = CreateFrame("Button", nil, self)
	button:SetSize(300, 16)
	button:SetNormalFontObject("GameFontNormal")
	button:SetHighlightFontObject("GameFontHighlight")
	button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	button:SetFontString(button:CreateFontString())
	button:SetPushedTextOffset(0, 0)
	button:SetScript("OnClick", mobButtonOnClick)
	return button
end

	
addon.filters = CreateFrame("Frame")
module = addon.filters
module.name = FILTERS
module.parent = "Critline"
InterfaceOptions_AddCategory(module)

module.specialAuras = specialAuras


-- spell filter frame
local spellFilter = CreateFrame("Frame", nil, module)
spellFilter:SetPoint("TOP", 0, -56)
spellFilter:SetSize(300, (MAXSPELLFILTERBUTTONS * 22 + 4))

do	-- spell filter buttons
	spellFilter.buttons = {}
	local buttons = spellFilter.buttons
	for i = 1, MAXSPELLFILTERBUTTONS do
		local button = createSpellButton(spellFilter)
		if i == 1 then
			button:SetPoint("TOPLEFT")
		else
			button:SetPoint("TOP", buttons[i - 1], "BOTTOM", 0, 4)
		end
		buttons[i] = button
	end
end

module.spellFilter = spellFilter


-- spell filter scroll frame
local spellScrollFrame = CreateFrame("ScrollFrame", "CritlineSpellFilterScrollFrame", module.spellFilter, "FauxScrollFrameTemplate")
spellScrollFrame:SetAllPoints()
spellScrollFrame:SetScript("OnShow", function(self)
	FauxScrollFrame_SetOffset(self, 0)
	self.scrollBar:SetValue(0)
	self:Update()
end)
spellScrollFrame:SetScript("OnVerticalScroll", function(self, offset) FauxScrollFrame_OnVerticalScroll(self, offset, 22, self.Update) end)
spellScrollFrame.scrollBar = CritlineSpellFilterScrollFrameScrollBar
spellFilter.scrollFrame = spellScrollFrame


-- spell filter tree dropdown
treeList = CreateFrame("Frame", "CritlineSpellFilterTree", module.spellFilter, "UIDropDownMenuTemplate")
treeList:SetPoint("BOTTOMRIGHT", module.spellFilter, "TOPRIGHT", 16, 0)

do	-- initialize filter tree dropdown
	local function onClick(self)
		UIDropDownMenu_SetSelectedValue(treeList, self.value)
		FauxScrollFrame_SetOffset(spellScrollFrame, 0)
		spellScrollFrame.scrollBar:SetValue(0)
		spellScrollFrame:Update()
	end
	
	local info = {}
	
	UIDropDownMenu_Initialize(treeList, function(self)
		wipe(info)
		info.text = DAMAGE
		info.value = "dmg"
		info.func = onClick
		UIDropDownMenu_AddButton(info)
		
		wipe(info)
		info.text = HEALS
		info.value = "heal"
		info.func = onClick
		UIDropDownMenu_AddButton(info)

		wipe(info)
		info.text = PET
		info.value = "pet"
		info.func = onClick
		UIDropDownMenu_AddButton(info)
	end)
	
	UIDropDownMenu_SetWidth(treeList, 120)
	UIDropDownMenu_SetSelectedValue(treeList, "dmg")
end

spellFilter.treeList = treeList


-- mob filter frame
local mobFilter = CreateFrame("Frame", nil, module)
mobFilter:SetPoint("TOP", 0, -56)
mobFilter:SetSize(300, (NUMMOBFILTERBUTTONS * 16))
mobFilter:Hide()
mobFilter:SetScript("OnShow", function(self)
	local scrollFrame = self.scrollFrame
	if scrollFrame.selected then
		local prevHighlight = module.mobFilter.buttons[scrollFrame.selected - FauxScrollFrame_GetOffset(scrollFrame)]
		if prevHighlight then
			prevHighlight:UnlockHighlight()
		end
		scrollFrame.selected = nil
		-- scrollFrame:Update()
		self.deleteButton:Disable()
	end
end)

do	-- mob filter buttons
	mobFilter.buttons = {}
	local buttons = mobFilter.buttons
	for i = 1, NUMMOBFILTERBUTTONS do
		local button = createMobButton(mobFilter)
		if i == 1 then
			button:SetPoint("TOP")
		else
			button:SetPoint("TOP", buttons[i - 1], "BOTTOM")
		end
		button:SetID(i)
		buttons[i] = button
	end
end

module.mobFilter = mobFilter


-- mob filter scroll frame
local mobScrollFrame = CreateFrame("ScrollFrame", "CritlineMobFilterScrollFrame", module.mobFilter, "FauxScrollFrameTemplate")
mobScrollFrame:SetAllPoints()
mobScrollFrame:SetScript("OnShow", function(self)
	FauxScrollFrame_SetOffset(self, 0)
	self.scrollBar:SetValue(0)
	self:Update()
end)
mobScrollFrame:SetScript("OnVerticalScroll", function(self, offset) FauxScrollFrame_OnVerticalScroll(self, offset, 16, self.Update) end)
mobScrollFrame.scrollBar = CritlineMobFilterScrollFrameScrollBar
mobFilter.scrollFrame = mobScrollFrame


local addTargetButton = CreateFrame("Button", nil, module.mobFilter, "UIPanelButtonTemplate")
addTargetButton:SetPoint("TOPLEFT", module.mobFilter, "BOTTOMLEFT")
addTargetButton:SetSize(96, 24)
addTargetButton:SetText(L["Add target"])
addTargetButton:SetScript("OnClick", function()
	local targetName = UnitName("target")
	if targetName then
		-- we don't want to add PCs to the filter
		if UnitIsPlayer("target") then
			addon:Message(L["Cannot add players to mob filter."])
		else
			module:AddMob(targetName)
		end
	else
		addon:Message(L["No target selected."])
	end
end)
mobFilter.addTargetButton = addTargetButton


local addByNameButton = CreateFrame("Button", nil, module.mobFilter, "UIPanelButtonTemplate")
addByNameButton:SetPoint("TOP", module.mobFilter, "BOTTOM")
addByNameButton:SetSize(96, 24)
addByNameButton:SetText(L["Add by name"])
addByNameButton:SetScript("OnClick", function()
	StaticPopup_Show("CRITLINE_ADD_MOB_BY_NAME")
end)
mobFilter.addByNameButton = addByNameButton


local deleteButton = CreateFrame("Button", nil, module.mobFilter, "UIPanelButtonTemplate")
deleteButton:SetPoint("TOPRIGHT", module.mobFilter, "BOTTOMRIGHT")
deleteButton:SetSize(96, 24)
deleteButton:SetText(L["Delete mob"])
deleteButton:Disable()
deleteButton:SetScript("OnClick", function(self)
	local btns = module.mobFilter.buttons
	if mobScrollFrame.selected then
		local selectedMob = CritlineMobFilter[mobScrollFrame.selected]
		tremove(CritlineMobFilter, mobScrollFrame.selected)
		local prevHighlight = btns[mobScrollFrame.selected - FauxScrollFrame_GetOffset(mobScrollFrame)]
		if prevHighlight then
			prevHighlight:UnlockHighlight()
		end
		mobScrollFrame.selected = nil
		mobScrollFrame:Update()
		self:Disable()
		addon:Message(L["%s removed from mob filter."]:format(selectedMob))
	end
end)
mobFilter.deleteButton = deleteButton


StaticPopupDialogs["CRITLINE_ADD_MOB_BY_NAME"] = {
	text = L["Enter mob name:"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	OnAccept = function(self)
		local name = self.editBox:GetText():trim()
		if not name:match("%S+") then
			addon:Message(L["Invalid mob name."])
			return
		end
		module:AddMob(name)
	end,
	EditBoxOnEnterPressed = function(self)
		local name = self:GetText():trim()
		if not name:match("%S+") then
			addon:Message(L["Invalid mob name."])
			return
		end
		module:AddMob(name)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	OnShow = function(self)
		self.editBox:SetFocus()
	end,
	OnHide = function(self)
		if ChatFrameEditBox:IsVisible() then
			ChatFrameEditBox:SetFocus()
		end
		self.editBox:SetText("")
	end,
	timeout = 0,
	exclusive = 0,
	whileDead = 1,
}


-- filter type dropdown
local filterType = CreateFrame("Frame", "CritlineFilterType", module, "UIDropDownMenuTemplate")
filterType:SetPoint("BOTTOMLEFT", module.spellFilter, "TOPLEFT", -16, 0)

do	-- initialize filter type dropdown
	local info = {}
	
	UIDropDownMenu_Initialize(filterType, function(self)
		wipe(info)
		info.text = L["Spell filter"]
		info.value = 1
		info.func = function()
			UIDropDownMenu_SetSelectedValue(self, 1)
			module.mobFilter:Hide()
			module.spellFilter:Show()
		end
		UIDropDownMenu_AddButton(info)
		
		wipe(info)
		info.text = L["Mob filter"]
		info.value = 2
		info.func = function()
			UIDropDownMenu_SetSelectedValue(self, 2)
			module.spellFilter:Hide()
			module.mobFilter:Show()
		end
		UIDropDownMenu_AddButton(info)
	end)

	UIDropDownMenu_SetWidth(filterType, 120)
	UIDropDownMenu_SetSelectedValue(filterType, 1)
end

module.filterType = filterType


function SpellButton_OnModifiedClick(self, button, ...)
	if module.spellFilter:IsVisible() and module:GetParent() and IsShiftKeyDown() then
		local spellID = SpellBook_GetSpellID(self:GetID())
		if spellID > MAX_SPELLS then
			return
		end
		module:AddSpell(UIDropDownMenu_GetSelectedValue(treeList), (GetSpellName(spellID, SpellBookFrame.bookType)))
		return
    end
    OrigSpellButton_OnModifiedClick(self, button, ...)
end


local spells = {}

function spellScrollFrame:Update()
	local selectedTree = UIDropDownMenu_GetSelectedValue(treeList)
	
	wipe(spells)
	
	for _, v in ipairs(CritlineDB[selectedTree]) do
		spells[#spells + 1] = v
	end
	
	local size = #spells
	
	FauxScrollFrame_Update(self, size, MAXSPELLFILTERBUTTONS, 22)
	
	local offset = FauxScrollFrame_GetOffset(self)
	
	for line = 1, MAXSPELLFILTERBUTTONS do
		local button = module.spellFilter.buttons[line]
		local lineplusoffset = line + offset
		if lineplusoffset <= size then
			local data = spells[lineplusoffset]
			button.spell = data.spellName
			button.isPeriodic = data.isPeriodic
			button:SetText(addon:GetFullSpellName(selectedTree, data.spellName, data.isPeriodic))
			button:SetChecked(data.filtered)
			button:Show()
		else
			button:Hide()
		end
	end
end


function mobScrollFrame:Update()
	local size = #CritlineMobFilter
	
	FauxScrollFrame_Update(self, size, NUMMOBFILTERBUTTONS, 16)
	
	local offset = FauxScrollFrame_GetOffset(self)
	
	for line = 1, NUMMOBFILTERBUTTONS do
		local button = module.mobFilter.buttons[line]
		local lineplusoffset = line + offset
		if lineplusoffset <= size then
			if self.selected then
				if self.selected - offset == line then
					button:LockHighlight()
				else
					button:UnlockHighlight()
				end
			end
			button:SetText(CritlineMobFilter[lineplusoffset])
			button:Show()
		else
			button:Hide()
		end
	end
end


function module:AddSpell(tree, spell, isPeriodic)
	local data = addon:GetSpellFromDB(tree, spell, isPeriodic)
	if not data then
		tinsert(CritlineDB[tree], {
			spellName = spell,
			isPeriodic = isPeriodic,
			filtered = true,
		})
		addon:SortMainDBTree(tree)
		spellScrollFrame:Update()
	elseif not data.filtered then
		data.filtered = true
		addon:RebuildAllTooltips()
	end
end


function module:DeleteSpell(tree, spell, isPeriodic)
	local data, pos = addon:GetSpellFromDB(tree, spell, isPeriodic)
	if data.filtered then
		data.filtered = nil
		if not (data.normal or data.crit) then
			tremove(CritlineDB[tree], pos)
			spellScrollFrame:Update()
		end
		addon:RebuildAllTooltips()
	end
end


function module:AddMob(name)
	if self:IsMobInFilter(name) then
		addon:Message(L["%s is already in mob filter."]:format(name))
	else
		tinsert(CritlineMobFilter, name)
		mobScrollFrame:Update()
		addon:Message(L["%s added to mob filter."]:format(name))
	end
end


function module:IsMobInFilter(mobName, GUID)
	-- GUID is provided if the function was called from the combat event handler
	if GUID and not CritlineSettings.ignoreMobFilter then
		if specialMobs[tonumber(GUID:sub(6, 12), 16)] then
			addon:Debug("Mob ("..mobName..") is in integrated filter.")
			return true
		end
	end
	for i, v in ipairs(CritlineMobFilter) do
		if v:lower() == mobName:lower() then
			addon:Debug("Mob ("..mobName..") is in custom filter.")
			return true
		end
	end
	return false
end


-- check if a spell passes the filters depending on inverted setting
function module:SpellPassesFilter(tree, spell, isPeriodic)
	local inFilter = addon:GetSpellFromDB(tree, spell, isPeriodic).filtered
	local isInverted = CritlineSettings.invertFilter
	return not (isInverted or inFilter) or (isInverted and inFilter)
end


-- scan for filtered auras from the specialAuras table
function module:HasSpecialAura()
	for i = 1, 40 do
		if specialAuras[select(11, UnitBuff("player", i))] or specialAuras[select(11, UnitDebuff("player", i))] then
			return true
		end
	end
	return false
end