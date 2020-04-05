-- Script array, not saved
MonkeySpeedTemp = {}
MonkeySpeedTemp.deltaTime = 0
MonkeySpeedTemp.currentUnit = "player"
MonkeySpeedTemp.currentSpeed = 0.0

function MonkeySpeed_Init()
	
	MonkeySpeedFrame:SetMinResize(20, 20)
	
	if (MonkeySpeedVars == nil) then
	MonkeySpeedVars = {
		shown = true,
		showBorder = true,
		frameLocked = false,
		showPercent = true,
		showBar = true,
		absoluteSpeed = false,
		rightClickOpensConfig = true,
		frameColour = {
			r = 0,
			g = 0,
			b = 0,
			a = 1,
			},
		borderColour = {
			r = 1,
			g = 0.7,
			b = 0,
			},
		speedColour1 = {
			r = 1,
			g = 0,
			b = 0,
			},
		speedColour2 = {
			r = 1,
			g = 0.5,
			b = 0,
			},
		speedColour3 = {
			r = 1,
			g = 1,
			b = 0,
			},
		speedColour4 = {
			r = 0,
			g = 1,
			b = 0,
			},
		speedColour5 = {
			r = 0,
			g = 1,
			b = 0.5,
			},
		speedColour6 = {
			r = 0,
			g = 1,
			b = 1,
			},
		speedColour7 = {
			r = 1,
			g = 0,
			b = 1,
			},
		speedColour8 = {
			r = 0.5,
			g = 0,
			b = 1,
			},
		speedColour9 = {
			r = 0,
			g = 0,
			b = 1,
			},
		speedColour10 = {
			r = 0,
			g = 0,
			b = .5,
			},
	}
	end
	
	MonkeySpeedFrame:SetBackdropBorderColor(MonkeySpeedVars.borderColour.r, MonkeySpeedVars.borderColour.g, MonkeySpeedVars.borderColour.b)
	
	MonkeySpeed_shown_Changed()
	MonkeySpeed_showBorder_Changed()
	MonkeySpeed_frameLocked_Changed()
	MonkeySpeed_showBar_Changed()
	MonkeySpeed_showPercent_Changed()
	
	local MonkeySpeedOptions = CreateFrame("FRAME", "MonkeySpeedOptions")
	MonkeySpeedOptions.name = GetAddOnMetadata("MonkeySpeed", "Title")
	MonkeySpeedOptions.default = function (self) MonkeySpeed_ResetConfig() end
	MonkeySpeedOptions.refresh = function (self) MonkeySpeed_RefreshConfig() end
	InterfaceOptions_AddCategory(MonkeySpeedOptions)
	
	local MonkeySpeedOptionsHeader = MonkeySpeedOptions:CreateFontString(nil, "ARTWORK")
	MonkeySpeedOptionsHeader:SetFontObject(GameFontNormalLarge)
	MonkeySpeedOptionsHeader:SetPoint("TOPLEFT", 16, -16)
	MonkeySpeedOptionsHeader:SetText(GetAddOnMetadata("MonkeySpeed", "Title") .. " " .. GetAddOnMetadata("MonkeySpeed", "Version"))
	
	local MonkeySpeedGeneral = MonkeySpeedOptions:CreateFontString(nil, "ARTWORK")
	MonkeySpeedGeneral:SetFontObject(GameFontWhite)
	MonkeySpeedGeneral:SetPoint("TOPLEFT", MonkeySpeedOptionsHeader, "BOTTOMLEFT", 0, -6)
	MonkeySpeedGeneral:SetText(MONKEYSPEED_GENERAL_OPTIONS)
	
	local MonkeySpeedCB1 = CreateFrame("CheckButton", "MonkeySpeedCB1", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB1:SetPoint("TOPLEFT", MonkeySpeedGeneral, "BOTTOMLEFT", 2, -4)
	MonkeySpeedCB1:SetScript("OnClick", function(self) MonkeySpeedVars.shown = (not MonkeySpeedVars.shown) 
																MonkeySpeed_shown_Changed() end)
	MonkeySpeedCB1Text:SetText(MONKEYSPEED_shown_DESC)
	
	MonkeySpeedC1 = CreateFrame("Button", "MonkeySpeedC1" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC1:SetPoint("TOPLEFT", MonkeySpeedGeneral, "BOTTOMLEFT", 175, -8)
	getglobal("MonkeySpeedC1" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_frameColour_DESC)
	getglobal("MonkeySpeedC1" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC1:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.frameColour
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_frameColour_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_frameColour_Changed
		ColorPickerFrame.opacityFunc = MonkeySpeed_frameColour_Changed
		ColorPickerFrame.hasOpacity = true
		ColorPickerFrame.opacity = colour.a
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b, a = colour.a}
		ColorPickerFrame:Show()
	end)
	
	local MonkeySpeedCB2 = CreateFrame("CheckButton", "MonkeySpeedCB2", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB2:SetPoint("TOPLEFT", MonkeySpeedCB1, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB2:SetScript("OnClick", function(self) MonkeySpeedVars.showBorder = (not MonkeySpeedVars.showBorder) 
																MonkeySpeed_showBorder_Changed() end)
	MonkeySpeedCB2Text:SetText(MONKEYSPEED_showBorder_DESC)
	
	MonkeySpeedC2 = CreateFrame("Button", "MonkeySpeedC2" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC2:SetPoint("TOPLEFT", MonkeySpeedCB1, "BOTTOMLEFT", 173, -8)
	getglobal("MonkeySpeedC2" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_borderColour_DESC)
	getglobal("MonkeySpeedC2" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC2:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.borderColour
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_borderColour_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_borderColour_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	local MonkeySpeedCB3 = CreateFrame("CheckButton", "MonkeySpeedCB3", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB3:SetPoint("TOPLEFT", MonkeySpeedCB2, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB3:SetScript("OnClick", function(self) MonkeySpeedVars.frameLocked = (not MonkeySpeedVars.frameLocked) 
																MonkeySpeed_frameLocked_Changed() end)
	MonkeySpeedCB3Text:SetText(MONKEYSPEED_frameLocked_DESC)

	local MonkeySpeedCB4 = CreateFrame("CheckButton", "MonkeySpeedCB4", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB4:SetPoint("TOPLEFT", MonkeySpeedCB3, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB4:SetScript("OnClick", function(self) MonkeySpeedVars.showBar = (not MonkeySpeedVars.showBar) 
																MonkeySpeed_showBar_Changed() end)
	MonkeySpeedCB4Text:SetText(MONKEYSPEED_showBar_DESC)
	
	local MonkeySpeedCB5 = CreateFrame("CheckButton", "MonkeySpeedCB5", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB5:SetPoint("TOPLEFT", MonkeySpeedCB4, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB5:SetScript("OnClick", function(self) MonkeySpeedVars.showPercent = (not MonkeySpeedVars.showPercent) 
																MonkeySpeed_showPercent_Changed() end)
	MonkeySpeedCB5Text:SetText(MONKEYSPEED_showPercent_DESC)
	
	local MonkeySpeedCB6 = CreateFrame("CheckButton", "MonkeySpeedCB6", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB6:SetPoint("TOPLEFT", MonkeySpeedCB5, "BOTTOMLEFT", 0, -4)
	MonkeySpeedCB6:SetScript("OnClick", function(self) MonkeySpeedVars.absoluteSpeed = (not MonkeySpeedVars.absoluteSpeed) end)
	MonkeySpeedCB6Text:SetText(MONKEYSPEED_absoluteSpeed_DESC)
	
	local MonkeySpeedMisc = MonkeySpeedOptions:CreateFontString(nil, "ARTWORK")
	MonkeySpeedMisc:SetFontObject(GameFontWhite)
	MonkeySpeedMisc:SetPoint("TOPLEFT", MonkeySpeedCB6, "BOTTOMLEFT", -2, -4)
	MonkeySpeedMisc:SetText(MONKEYSPEED_MISC_OPTIONS)
	
	local MonkeySpeedCB7 = CreateFrame("CheckButton", "MonkeySpeedCB7", MonkeySpeedOptions, "OptionsCheckButtonTemplate")
	MonkeySpeedCB7:SetPoint("TOPLEFT", MonkeySpeedMisc, "BOTTOMLEFT", 2, -4)
	MonkeySpeedCB7:SetScript("OnClick", function(self) MonkeySpeedVars.rightClickOpensConfig = (not MonkeySpeedVars.rightClickOpensConfig) end)
	MonkeySpeedCB7Text:SetText(MONKEYSPEED_rightClickOpensConfig_DESC)
	
	MonkeySpeedC3 = CreateFrame("Button", "MonkeySpeedC3" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC3:SetPoint("TOPLEFT", MonkeySpeedCB7, "BOTTOMLEFT", 5, -8)
	getglobal("MonkeySpeedC3" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_speedColour1_DESC)
	getglobal("MonkeySpeedC3" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC3:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour1
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour1_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour1_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC4 = CreateFrame("Button", "MonkeySpeedC4" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC4:SetPoint("TOPLEFT", MonkeySpeedCB7, "BOTTOMLEFT", 160, -8)
	getglobal("MonkeySpeedC4" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_speedColour2_DESC)
	getglobal("MonkeySpeedC4" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC4:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour2
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour2_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour2_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC5 = CreateFrame("Button", "MonkeySpeedC5" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC5:SetPoint("TOPLEFT", MonkeySpeedC3, "BOTTOMLEFT", 0, -10)
	getglobal("MonkeySpeedC5" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_speedColour3_DESC)
	getglobal("MonkeySpeedC5" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC5:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour3
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour3_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour3_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC6 = CreateFrame("Button", "MonkeySpeedC6" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC6:SetPoint("TOPLEFT", MonkeySpeedC3, "BOTTOMLEFT", 155, -10)
	getglobal("MonkeySpeedC6" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_speedColour4_DESC)
	getglobal("MonkeySpeedC6" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC6:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour4
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour4_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour4_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC7 = CreateFrame("Button", "MonkeySpeedC7" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC7:SetPoint("TOPLEFT", MonkeySpeedC5, "BOTTOMLEFT", 0, -10)
	getglobal("MonkeySpeedC7" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_speedColour5_DESC)
	getglobal("MonkeySpeedC7" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC7:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour5
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour5_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour5_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC8 = CreateFrame("Button", "MonkeySpeedC8" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC8:SetPoint("TOPLEFT", MonkeySpeedC5, "BOTTOMLEFT", 155, -10)
	getglobal("MonkeySpeedC8" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_speedColour6_DESC)
	getglobal("MonkeySpeedC8" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC8:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour6
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour6_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour6_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC9 = CreateFrame("Button", "MonkeySpeedC9" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC9:SetPoint("TOPLEFT", MonkeySpeedC7, "BOTTOMLEFT", 0, -10)
	getglobal("MonkeySpeedC9" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_speedColour7_DESC)
	getglobal("MonkeySpeedC9" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC9:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour7
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour7_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour7_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC10 = CreateFrame("Button", "MonkeySpeedC10" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC10:SetPoint("TOPLEFT", MonkeySpeedC7, "BOTTOMLEFT", 155, -10)
	getglobal("MonkeySpeedC10" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_speedColour8_DESC)
	getglobal("MonkeySpeedC10" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC10:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour8
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour8_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour8_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC11 = CreateFrame("Button", "MonkeySpeedC11" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC11:SetPoint("TOPLEFT", MonkeySpeedC9, "BOTTOMLEFT", 0, -10)
	getglobal("MonkeySpeedC11" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_speedColour9_DESC)
	getglobal("MonkeySpeedC11" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC11:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour9
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour9_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour9_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
	
	MonkeySpeedC12 = CreateFrame("Button", "MonkeySpeedC12" .. "_ColourBnt", MonkeySpeedOptions, "MonkeyColourButtonTemplate")
	MonkeySpeedC12:SetPoint("TOPLEFT", MonkeySpeedC9, "BOTTOMLEFT", 155, -10)
	getglobal("MonkeySpeedC12" .. "_ColourBnt_Text"):SetText(MONKEYSPEED_speedColour10_DESC)
	getglobal("MonkeySpeedC12" .. "_ColourBnt_BorderTexture"):SetVertexColor(1.0, 1.0, 1.0)
	MonkeySpeedC12:SetScript("OnClick", function(self) local colour = MonkeySpeedVars.speedColour10
		ColorPickerFrame:Hide()
		ColorPickerFrame.func = MonkeySpeed_speedColour10_Changed
		ColorPickerFrame.cancelFunc = MonkeySpeed_speedColour10_Changed
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(colour.r, colour.g, colour.b)
		ColorPickerFrame.previousValues = {r = colour.r, g = colour.g, b = colour.b}
		ColorPickerFrame:Show()
	end)
end

function MonkeySpeed_ResetConfig()
	MonkeySpeedVars.shown = true
	
	MonkeySpeedVars.frameColour.r = 0
	MonkeySpeedVars.frameColour.g = 0
	MonkeySpeedVars.frameColour.b = 0
	MonkeySpeedVars.frameColour.a = 1
	
	MonkeySpeedVars.showBorder =true
	
	MonkeySpeedVars.borderColour.r = 1
	MonkeySpeedVars.borderColour.g = 0.7
	MonkeySpeedVars.borderColour.b = 0
	
	MonkeySpeedVars.speedColour1.r = 1
	MonkeySpeedVars.speedColour1.g = 0
	MonkeySpeedVars.speedColour1.b = 0
	
	MonkeySpeedVars.speedColour2.r = 1
	MonkeySpeedVars.speedColour2.g = 0.5
	MonkeySpeedVars.speedColour2.b = 0
	
	MonkeySpeedVars.speedColour3.r = 1
	MonkeySpeedVars.speedColour3.g = 1
	MonkeySpeedVars.speedColour3.b = 0
	
	MonkeySpeedVars.speedColour4.r = 0
	MonkeySpeedVars.speedColour4.g = 1
	MonkeySpeedVars.speedColour4.b = 0
	
	MonkeySpeedVars.speedColour5.r = 0
	MonkeySpeedVars.speedColour5.g = 1
	MonkeySpeedVars.speedColour5.b = .5
	
	MonkeySpeedVars.speedColour6.r = 0
	MonkeySpeedVars.speedColour6.g = 1
	MonkeySpeedVars.speedColour6.b = 1
	
	MonkeySpeedVars.speedColour7.r = 1
	MonkeySpeedVars.speedColour7.g = 0
	MonkeySpeedVars.speedColour7.b = 1
	
	MonkeySpeedVars.speedColour8.r = 0.5
	MonkeySpeedVars.speedColour8.g = 0
	MonkeySpeedVars.speedColour8.b = 1
	
	MonkeySpeedVars.speedColour9.r = 0
	MonkeySpeedVars.speedColour9.g = 0
	MonkeySpeedVars.speedColour9.b = 1
	
	MonkeySpeedVars.speedColour10.r = 0
	MonkeySpeedVars.speedColour10.g = 0
	MonkeySpeedVars.speedColour10.b = .5

	MonkeySpeedVars.frameLocked = false
	MonkeySpeedVars.showBar = true
	MonkeySpeedVars.showPercent = true
	MonkeySpeedVars.absoluteSpeed = false
	MonkeySpeedVars.rightClickOpensConfig = true
	
	MonkeySpeedFrame:SetHeight(30)
	MonkeySpeedFrame:SetWidth(110)
	MonkeySpeedFrame:ClearAllPoints()
	MonkeySpeedFrame:SetPoint("TOP", nil, "TOP", 0, -50)
	
	MonkeySpeedFrame:SetBackdropBorderColor(MonkeySpeedVars.borderColour.r, MonkeySpeedVars.borderColour.g, MonkeySpeedVars.borderColour.b)
	
	MonkeySpeed_shown_Changed()
	MonkeySpeed_showBorder_Changed()
	MonkeySpeed_frameLocked_Changed()
	MonkeySpeed_showBar_Changed()
	MonkeySpeed_showPercent_Changed()
end

function MonkeySpeed_RefreshConfig()
	MonkeySpeedCB1:SetChecked(MonkeySpeedVars.shown)
	MonkeySpeedCB2:SetChecked(MonkeySpeedVars.showBorder)
	MonkeySpeedCB3:SetChecked(MonkeySpeedVars.frameLocked)
	MonkeySpeedCB4:SetChecked(MonkeySpeedVars.showBar)
	MonkeySpeedCB5:SetChecked(MonkeySpeedVars.showPercent)
	MonkeySpeedCB6:SetChecked(MonkeySpeedVars.absoluteSpeed)
	MonkeySpeedCB7:SetChecked(MonkeySpeedVars.rightClickOpensConfig)
	
	getglobal("MonkeySpeedC1_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.frameColour.r, MonkeySpeedVars.frameColour.g, MonkeySpeedVars.frameColour.b)
	getglobal("MonkeySpeedC2_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.borderColour.r, MonkeySpeedVars.borderColour.g, MonkeySpeedVars.borderColour.b)
	getglobal("MonkeySpeedC3_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.speedColour1.r, MonkeySpeedVars.speedColour1.g, MonkeySpeedVars.speedColour1.b)
	getglobal("MonkeySpeedC4_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.speedColour2.r, MonkeySpeedVars.speedColour2.g, MonkeySpeedVars.speedColour2.b)
	getglobal("MonkeySpeedC5_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.speedColour3.r, MonkeySpeedVars.speedColour3.g, MonkeySpeedVars.speedColour3.b)
	getglobal("MonkeySpeedC6_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.speedColour4.r, MonkeySpeedVars.speedColour4.g, MonkeySpeedVars.speedColour4.b)
	getglobal("MonkeySpeedC7_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.speedColour5.r, MonkeySpeedVars.speedColour5.g, MonkeySpeedVars.speedColour5.b)
	getglobal("MonkeySpeedC8_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.speedColour6.r, MonkeySpeedVars.speedColour6.g, MonkeySpeedVars.speedColour6.b)
	getglobal("MonkeySpeedC9_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.speedColour7.r, MonkeySpeedVars.speedColour7.g, MonkeySpeedVars.speedColour7.b)
	getglobal("MonkeySpeedC10_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.speedColour8.r, MonkeySpeedVars.speedColour8.g, MonkeySpeedVars.speedColour8.b)
	getglobal("MonkeySpeedC11_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.speedColour9.r, MonkeySpeedVars.speedColour9.g, MonkeySpeedVars.speedColour9.b)
	getglobal("MonkeySpeedC12_ColourBnt_SwatchTexture"):SetVertexColor(MonkeySpeedVars.speedColour10.r, MonkeySpeedVars.speedColour10.g, MonkeySpeedVars.speedColour10.b)
end
