local L = LibStub("AceLocale-3.0"):GetLocale("Critline")
local module

local _, addon = ...

local templates = addon.templates


local function addTitle(self, text)
	self.title = self:CreateFontString(nil, nil, "GameFontNormalLarge")
	self.title:SetPoint("TOPLEFT", 16, -16)
	self.title:SetPoint("RIGHT", -16, 0)
	self.title:SetJustifyH("LEFT")
	self.title:SetJustifyV("TOP")
	self.title:SetText(text)
end


addon.settings = CreateFrame("Frame")
module = addon.settings
addTitle(module, "Critline")
module:RegisterEvent("ADDON_LOADED")
module:SetScript("OnEvent", function(self, event, addon)
	if addon == "Critline" then
		self:LoadSettings()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
module.name = "Critline"
InterfaceOptions_AddCategory(module)

module.subText = module:CreateFontString(nil, nil, "GameFontHighlightSmall")
module.subText:SetHeight(32)
module.subText:SetPoint("TOPLEFT", module.title, "BOTTOMLEFT", 0, -8)
module.subText:SetPoint("RIGHT", -32, 0)
module.subText:SetJustifyH("LEFT")
module.subText:SetJustifyV("TOP")
module.subText:SetNonSpaceWrap(true)
module.subText:SetText(L["Saves your high normal and critical damage records and flashes a message if you break the record."])


SlashCmdList["CRITLINE"] = function(msg)
	msg = msg:trim():lower()
	if msg == "debug" then
		addon:ToggleDebug()
	elseif msg == "reset" then
		addon.display:ClearAllPoints()
		addon.display:SetPoint("CENTER")
	else
		module:OpenSettingsFrame()
	end
end

SLASH_CRITLINE1 = "/critline"
SLASH_CRITLINE2 = "/cl"


module.basic = CreateFrame("Frame")
addTitle(module.basic, L["Basic options"])
module.basic.name = L["Basic options"]
module.basic.parent = "Critline"
InterfaceOptions_AddCategory(module.basic)


module.advanced = CreateFrame("Frame")
addTitle(module.advanced, L["Advanced options"])
module.advanced.name = L["Advanced options"]
module.advanced.parent = "Critline"
InterfaceOptions_AddCategory(module.advanced)


do	-- create basic options
	module.basic.options = {
		checkButtons = {},
	}
	
	local options = module.basic.options
	
	local optionsData = {
		{
			text = L["Record damage"],
			tooltipText = L["Check to enable damage events to be recorded."],
			setting = "dmgRecord",
		},
		{
			text = L["Record healing"],
			tooltipText = L["Check to enable healing events to be recorded."],
			setting = "healRecord",
		},
		{
			text = L["Record pet damage"],
			tooltipText = L["Check to enable pet damage events to be recorded."],
			setting = "petRecord",
		},
		{
			text = L["Show damage"],
			tooltipText = L["Show damage in summary frame."],
			setting = "dmgDisplay",
		},
		{
			text = L["Show healing"],
			tooltipText = L["Show healing in summary frame."],
			setting = "healDisplay",
		},
		{
			text = L["Show pet damage"],
			tooltipText = L["Show pet damage in summary frame."],
			setting = "petDisplay",
		},
		{
			text = L["Record PvE"],
			tooltipText = L["Disable to ignore records where the target is an NPC."],
			setting = "recordPvE",
		},
		{
			text = L["Record PvP"],
			tooltipText = L["Disable to ignore records where the target is a player."],
			setting = "recordPvP",
		},
		{
			text = L["Minimap button"],
			tooltipText = L["Show button on minimap."],
			setting = "showMinimap",
			newColumn = true,
		},
		{
			text = L["Splash frame"],
			tooltipText = L["Shows the new record on the middle of the screen."],
			setting = "showSplash",
		},
		{
			text = L["Chat output"],
			tooltipText = L["Prints new record notifications to the chat frame."],
			setting = "chatOutput",
		},
		{
			text = L["Play sound"],
			tooltipText = L["Plays a sound on a new record."],
			setting = "playSound",
		},
		{
			text = L["Screenshot"],
			tooltipText = L["Saves a screenshot on a new record."],
			setting = "screenshot",
		},
		{
			text = L["Detailed summary"],
			tooltipText = L["Use detailed format in the Critline summary tooltip."],
			setting = "detailedTooltip",
		},
	}
	
	for i, v in ipairs(optionsData) do
		local button = templates:CreateCheckButton(module.basic)
		if i == 1 then
			button:SetPoint("TOPLEFT", module.basic.title, "BOTTOMLEFT", -2, -16)
		elseif v.newColumn then
			button:SetPoint("TOPLEFT", module.basic.title, "BOTTOM", 0, -16)
		else
			button:SetPoint("TOP", options.checkButtons[i - 1], "BOTTOM", 0, -8)
		end
		button:SetText(v.text)
		button.tooltipText = v.tooltipText
		button.setting = v.setting
		options.checkButtons[i] = button
	end
	
	-- level adjustment slider
	local slider = templates:CreateSlider(module.basic, "CritlineLevelFilter")
	slider:SetMinMaxValues(-1, 10)
	slider:SetValueStep(1)
	slider:SetPoint("TOPLEFT", options.checkButtons[#optionsData], "BOTTOMLEFT", 4, -24)
	slider:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		if value == -1 then
			self.valueText:SetText(OFF)
		else
			self.valueText:SetText(tostring(value))
		end
		CritlineSettings.levelAdjust = value
	end)
	CritlineLevelFilterLow:SetText(OFF)
	CritlineLevelFilterHigh:SetText("10")
	CritlineLevelFilterText:SetText(L["Level adjustment"])
	slider.tooltipText = L["If level difference between you and the target is greater than this setting, records will not be registered."]
	options.slider = slider
end


do	-- create advanced options
	module.advanced.options = {
		checkButtons = {},
		colorButtons = {},
		buttons = {},
		sliders = {},
	}
	
	local options = module.advanced.options
	local columnEnd
	
	local optionsData = {
		{
			text = L["Invert spell filter"],
			tooltipText = L["Enable to include rather than exclude selected spells in the spell filter."],
			setting = "invertFilter",
		},
		{
			text = L["Suppress mind control"],
			tooltipText = L["Suppress all records while mind controlled."],
			setting = "suppressMC",
		},
		{
			text = L["Don't filter magic"],
			tooltipText = L["Enable to let magical damage ignore the level adjustment."],
			setting = "dontFilterMagic",
		},
		{
			text = L["Ignore mob filter"],
			tooltipText = L["Enable to ignore integrated mob filter."],
			setting = "ignoreMobFilter",
		},
		{
			text = L["Ignore aura filter"],
			tooltipText = L["Enable to ignore integrated aura filter."],
			setting = "ignoreAuraFilter",
		},
		{
			text = L["Show old record"],
			tooltipText = L["Display previous record along with \"New record\" messages."],
			setting = "oldRecord",
			newColumn = true,
		},
		{
			text = L["Use combat text splash"],
			tooltipText = L["Enable to use scrolling combat text for \"New record\" messages instead of the default splash frame."],
			setting = "sctSplash",
		},
	}
	
	for i, v in ipairs(optionsData) do
		local button = templates:CreateCheckButton(module.advanced)
		if i == 1 then
			button:SetPoint("TOPLEFT", module.advanced.title, "BOTTOMLEFT", -2, -16)
		elseif v.newColumn then
			columnEnd = i - 1
			button:SetPoint("TOPLEFT", module.advanced.title, "BOTTOM", 0, -16)
		else
			button:SetPoint("TOP", options.checkButtons[i - 1], "BOTTOM", 0, -8)
		end
		button:SetText(v.text)
		button.tooltipText = v.tooltipText
		button.setting = v.setting
		options.checkButtons[i] = button
	end
	
	-- splash frame spell name color
	local spellColor = templates:CreateColorButton(module.advanced)
	spellColor:SetID(1)
	spellColor:SetPoint("TOPLEFT", options.checkButtons[#optionsData], "BOTTOMLEFT", 0, -8)
	spellColor:SetText(L["Spell color"])
	spellColor.tooltipText = L["Set the color for the spell text in the splash frame."]
	options.colorButtons[1] = spellColor
	
	-- splash frame amount color
	local amountColor = templates:CreateColorButton(module.advanced)
	amountColor:SetID(2)
	amountColor:SetPoint("TOPLEFT", spellColor, "BOTTOMLEFT", 0, -8)
	amountColor:SetText(L["Amount color"])
	amountColor.tooltipText = L["Set the color for the amount text in the splash frame."]
	options.colorButtons[2] = amountColor
	
	local sliderName = "CritlineAdvancedSlider"
	
	local sliderData = {
		{
			minValue = 0.5,
			maxValue = 1,
			defaultValue = 1,
			valueStep = 0.05,
			pos = {"TOPLEFT", amountColor, "BOTTOMLEFT", 4, -24},
			text = L["Splash frame scale"],
			tooltipText = L["Sets the scale of the splash frame."],
			lowText = "50%",
			highText = "100%",
			onValueChanged = function(self)
				local value = self:GetValue()
				self.valueText:SetFormattedText("%.0f%%", value * 100)
				local splash = addon.splash
				local os = splash:GetScale()
				addon.splash:SetScale(value)
				local point, relativeTo, relativePoint, xOff, yOff = splash:GetPoint()
				splash:SetPoint(point, relativeTo, relativePoint, (xOff*os/value), (yOff*os/value))
				CritlineSettings.splashScale = value
			end,
		},
		{
			minValue = 0.5,
			maxValue = 3,
			defaultValue = 2,
			valueStep = 0.5,
			pos = {"TOP", sliderName.."1", "BOTTOM", 0, -32},
			text = L["Splash frame timer"],
			tooltipText = L["Sets the number of seconds you wish to display the splash frame."],
			lowText = "0.5",
			highText = "3",
			onValueChanged = function(self)
				local value = self:GetValue()
				self.valueText:SetText(tostring(value))
				addon.splash:SetTimeVisible(value)
				CritlineSettings.splashTimer = value
			end,
		},
		{
			minValue = 0.5,
			maxValue = 1.5,
			defaultValue = 1,
			valueStep = 0.05,
			pos = {"TOPLEFT", options.checkButtons[columnEnd], "BOTTOMLEFT", 4, -24},
			text = L["Summary frame scale"],
			tooltipText = L["Sets the scale of the summary frame."],
			lowText = "50%",
			highText = "150%",
			onValueChanged = function(self)
				local value = self:GetValue()
				self.valueText:SetFormattedText("%.0f%%", value * 100)
				local display = addon.display
				local os = display:GetScale()
				display:SetScale(value)
				local point, relativeTo, relativePoint, xOff, yOff = display:GetPoint()
				display:SetPoint(point, relativeTo, relativePoint, (xOff*os/value), (yOff*os/value))
				CritlineSettings.mainScale = value
			end,
		},
	}
	
	local x, y, anchor, relativePoint = 4, -24, "TOPLEFT", "BOTTOMLEFT"
	
	for i, v in ipairs(sliderData) do
		local slider = templates:CreateSlider(module.advanced, sliderName..i)
		if i == 2 then
			x, y, anchor, relativePoint = 0, -40, "TOP", "BOTTOM"
		end
		slider:SetMinMaxValues(v.minValue, v.maxValue)
		slider:SetValueStep(v.valueStep)
		slider:SetPoint(unpack(v.pos))
		slider:SetScript("OnValueChanged", v.onValueChanged)
		_G[sliderName..i.."Low"]:SetText(v.lowText)
		_G[sliderName..i.."High"]:SetText(v.highText)
		_G[sliderName..i.."Text"]:SetText(v.text)
		slider.tooltipText = v.tooltipText
		options.sliders[i] = slider
	end
	
	-- move splash screen
	local moveSplash = CreateFrame("Button", "CritlineMoveSplashButton", module.advanced, "UIPanelButtonTemplate2")
	moveSplash:SetPoint("TOP", sliderName.."2", "BOTTOM", 0, -24)
	moveSplash:SetSize(148, 24)
	moveSplash:SetText(L["Move splash screen"])
	moveSplash:SetScript("OnClick", function()
		InterfaceOptionsFrame:Hide()
		addon.splash.locked = false
		addon.splash:EnableMouse(true)
	end)
	options.buttons[1] = moveSplash
	
	-- edit tooltip format
	local editTooltip = CreateFrame("Button", "CritlineEditTooltipButton", module.advanced, "UIPanelButtonTemplate2")
	editTooltip:SetPoint("TOP", moveSplash, "BOTTOM", 0, -8)
	editTooltip:SetSize(148, 24)
	editTooltip:SetText(L["Edit tooltip format"])
	editTooltip:SetScript("OnClick", function()
		StaticPopup_Show("CRITLINE_EDIT_TOOLTIP_FORMAT")
	end)
	options.buttons[2] = editTooltip
	
	-- summary sort dropdown
	local sorting = CreateFrame("Frame", "CritlineSummarySorting", module.advanced, "UIDropDownMenuTemplate")
	sorting:SetPoint("TOPLEFT", sliderName.."3", "BOTTOMLEFT", -13, -40)
	sorting.label = sorting:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall")
	sorting.label:SetPoint("BOTTOMLEFT", sorting, "TOPLEFT", 16, 3)
	sorting.label:SetText(L["Sort summary spells:"])
	options.summarySort = sorting
end


-- "edit tooltip format" popup
StaticPopupDialogs["CRITLINE_EDIT_TOOLTIP_FORMAT"] = {
	text =
		"$sn - Spell name\n\n"..

		"$na - Amount for normal record\n"..
		"$nt - Target name for normal record\n"..
		"$nl - Target level for normal record\n\n"..

		"$ca - Amount for crit record\n"..
		"$ct - Target name for crit record\n"..
		"$cl - Target level for crit record\n\n"..
		
		"\\n - New line\n"..
		"\\t - Right aligned\n\n"..
		
		"Leave empty to set to default."
	,
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	OnAccept = function(self)
		local text = self.editBox:GetText()
		CritlineSettings.tooltipFormat = text
		addon:RebuildAllTooltips()
	end,
	EditBoxOnEnterPressed = function(self)
		CritlineSettings.tooltipFormat = self:GetText()
		addon:RebuildAllTooltips()
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	OnShow = function(self)
		self.editBox:SetText(CritlineSettings.tooltipFormat)
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


function module:LoadSettings()
	local options = module.basic.options
	
	for _, btn in ipairs(options.checkButtons) do
		btn:SetChecked(CritlineSettings[btn.setting])
	end
	
	options.slider:SetValue(CritlineSettings.levelAdjust)
	
	options = module.advanced.options
	
	for _, btn in ipairs(options.checkButtons) do
		btn:SetChecked(CritlineSettings[btn.setting])
	end
	
	local function onClick(self)
		UIDropDownMenu_SetSelectedValue(options.summarySort, self.value)
		CritlineSettings.summarySort = self.value
		addon:RebuildAllTooltips()
	end
	
	local info = {}
	
	UIDropDownMenu_Initialize(options.summarySort, function(self)
		info.text = L["Alphabetically"]
		info.value = "alpha"
		info.func = onClick
		UIDropDownMenu_AddButton(info)
		info.checked = nil
		
		info.text = L["By crit record"]
		info.value = "crit"
		info.func = onClick
		UIDropDownMenu_AddButton(info)
		info.checked = nil
		
		info.text = L["By normal record"]
		info.value = "normal"
		info.func = onClick
		UIDropDownMenu_AddButton(info)
		info.checked = nil
	end)
	
	UIDropDownMenu_SetWidth(options.summarySort, 120)
	UIDropDownMenu_SetSelectedValue(options.summarySort, CritlineSettings.summarySort)
	
	local spell = CritlineSettings.spellColor
	local amount = CritlineSettings.amountColor
	local colorButtons = options.colorButtons
	colorButtons[1].swatch:SetVertexColor(spell.r, spell.g, spell.b)
	colorButtons[2].swatch:SetVertexColor(amount.r, amount.g, amount.b)
	
	local sliders = options.sliders
	sliders[1]:SetValue(CritlineSettings.splashScale)
	sliders[2]:SetValue(CritlineSettings.splashTimer)
	sliders[3]:SetValue(CritlineSettings.mainScale)
	addon.splash:SetTimeVisible(CritlineSettings.splashTimer)
end


function module:OpenSettingsFrame()
	InterfaceOptionsFrame_OpenToCategory(module.basic)
end