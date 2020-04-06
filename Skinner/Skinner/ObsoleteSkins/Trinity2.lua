
local function skinTBTabs(tabNamePrefix)

	local T2RP = Trinity2.RegisteredPanels
	local tabCount = 1
	for i = 1, #T2RP do
		if (T2RP[i][3] == "advanced") then
			local tabName = _G[tabNamePrefix.."Tab"..tabCount]
			Skinner:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
			if Skinner.db.profile.TexturedTab then Skinner:applySkin(tabName, nil, 0)
			else Skinner:applySkin(tabName) end
			if tabCount == 1 then
				Skinner:moveObject(tabName, "+", 6, "+", 6)
			else
				Skinner:moveObject(tabName, "+", 16, nil, nil)
			end
			if Skinner.db.profile.TexturedTab then
			 	if tabCount == 1 and tabNamePrefix == "Trinity2DockFrameOptions"
			 	or tabCount == 2 and tabNamePrefix == "Trinity2BindingEditor"
			 	or tabCount == 3 and tabNamePrefix == "TrinityBars2ButtonEditor" then Skinner:setActiveTab(tabName)
				else Skinner:setInactiveTab(tabName) end
			end
			local tabNameText = _G[tabNamePrefix.."Tab"..tabCount.."Text"]
			local tabNameTW = math.floor(tabNameText:GetWidth())
			local tabNameHL = _G[tabNamePrefix.."Tab"..tabCount.."HighlightTexture"]
			Skinner:moveObject(tabNameText, nil, nil, "-", 4)
			Skinner:moveObject(tabNameHL, "-", 8, "-", 5)
			tabCount = tabCount + 1
		end
	end
	-- set this here so that the resizeTabs function works
	_G[tabNamePrefix].numTabs = tabCount - 1

end

function Skinner:Trinity2()

-->>--	Dock Frame Options (Panel 1)
	self:applySkin(Trinity2DockFrameOptionsHeader)
	self:keepFontStrings(Trinity2DockFrameOptions)
	Trinity2DockFrameOptionsCurrentDockEdit1:SetWidth(Trinity2DockFrameOptionsCurrentDockEdit1:GetWidth() - 5)
	Trinity2DockFrameOptionsCurrentDockEdit2:SetWidth(Trinity2DockFrameOptionsCurrentDockEdit2:GetWidth() - 10)
	Trinity2DockFrameOptionsCurrentDockEdit3:SetWidth(Trinity2DockFrameOptionsCurrentDockEdit3:GetWidth() - 10)
	self:skinEditBox(Trinity2DockFrameOptionsCurrentDockEdit1, {15})
	self:applySkin(Trinity2DockFrameOptionsCurrentDockEdit1PopUp)
	self:skinEditBox(Trinity2DockFrameOptionsCurrentDockEdit2, {15})
	self:skinEditBox(Trinity2DockFrameOptionsCurrentDockEdit3, {15})
	self:applySkin(Trinity2DockFrameOptionsCurrentDock)
	self:applySkin(Trinity2DockFrameOptionsCheckOptionsFrame)
	self:skinEditBox(Trinity2DockFrameOptionsAdjustableOptionsFrameEdit1, {15})
	self:skinEditBox(Trinity2DockFrameOptionsAdjustableOptionsFrameEdit2, {15})
	self:skinEditBox(Trinity2DockFrameOptionsAdjustableOptionsFrameEdit3, {15})
	self:skinEditBox(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit1, {15})
	self:applySkin(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit1PopUp)
	self:skinEditBox(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit2, {15})
	self:applySkin(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit2PopUp)
	self:skinEditBox(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit3, {15})
	self:applySkin(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit3PopUp)
	self:applySkin(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1)
	self:applySkin(Trinity2DockFrameOptionsAdjustableOptionsFrame)
	self:applySkin(Trinity2DockFrameOptionsRDCDocks)
	Trinity2DockFrameOptionsColorPickerFrameEdit1:SetWidth(Trinity2DockFrameOptionsColorPickerFrameEdit1:GetWidth() - 5)
	Trinity2DockFrameOptionsColorPickerFrameEdit2:SetWidth(Trinity2DockFrameOptionsColorPickerFrameEdit2:GetWidth() - 5)
	self:skinEditBox(Trinity2DockFrameOptionsColorPickerFrameEdit1, {15})
	self:skinEditBox(Trinity2DockFrameOptionsColorPickerFrameEdit2, {15})
	self:skinEditBox(Trinity2ColorPickerRedValue)
	self:skinEditBox(Trinity2ColorPickerGreenValue)
	self:skinEditBox(Trinity2ColorPickerBlueValue)
	self:skinEditBox(Trinity2ColorPickerHexValue)
	self:applySkin(Trinity2ColorPicker)
	self:applySkin(Trinity2DockFrameOptionsColorPickerFrame)
	self:applySkin(Trinity2DockFrameOptions)
-->>--	Tabs
	skinTBTabs("Trinity2DockFrameOptions")
	-- Hook this to resize the Tabs
	self:SecureHook(Trinity2DockFrameOptions, "Show", function(this)
		self:resizeTabs(Trinity2DockFrameOptions)
	end)

-->>--	Binding Editor (Panel 2)
	self:applySkin(Trinity2BindingEditorHeader)
	self:keepFontStrings(Trinity2BindingEditor)
	self:applySkin(Trinity2BindingEditorCurrentDock)
	self:skinEditBox(Trinity2BindingEditorCurrentDockEdit1, {15})
	self:applySkin(Trinity2BindingEditorCurrentDockEdit1PopUp)
	self:applySkin(Trinity2BindingEditor)

	self:keepFontStrings(Trinity2DockFrameEditorBottom)
	self:skinEditBox(Trinity2DockFrameEditorBottomEdit1, {15})
	self:applySkin(Trinity2DockFrameEditorBottom)
-->>--	Tabs
	skinTBTabs("Trinity2BindingEditor")
	-- Hook this to resize the Tabs
	self:SecureHook(Trinity2BindingEditor, "Show", function(this)
		self:resizeTabs(Trinity2BindingEditor)
	end)

-->>--	Options
	self:applySkin(Trinity2OptionsHeader)
	self:keepFontStrings(Trinity2Options)
	self:skinEditBox(Trinity2OptionsEdit1, {15})
	self:applySkin(Trinity2OptionsEdit1PopUp)
	Trinity2OptionsEdit2:SetWidth(Trinity2OptionsEdit2:GetWidth() - 10)
	self:skinEditBox(Trinity2OptionsEdit2, {15})
	self:applySkin(Trinity2OptionsEdit2PopUp)
	self:keepFontStrings(Trinity2OptionsData1ScrollFrame1)
	self:skinScrollBar(Trinity2OptionsData1ScrollFrame1, nil, nil, true)
	self:applySkin(Trinity2OptionsData1)
	self:applySkin(Trinity2Options)

end

function Skinner:TrinityBars2()

-->>--	Button Editor (Panel 3)
	self:applySkin(TrinityBars2ButtonEditorHeader)
	self:keepFontStrings(TrinityBars2ButtonEditor)
	TrinityBars2ButtonEditorCurrentButtonEdit1:SetWidth(TrinityBars2ButtonEditorCurrentButtonEdit1:GetWidth() - 5)
	self:skinEditBox(TrinityBars2ButtonEditorCurrentButtonEdit1, {15})
	self:applySkin(TrinityBars2ButtonEditorCurrentButtonEdit1PopUp)
	TrinityBars2ButtonEditorCurrentButtonEdit2:SetWidth(TrinityBars2ButtonEditorCurrentButtonEdit2:GetWidth() - 5)
	self:skinEditBox(TrinityBars2ButtonEditorCurrentButtonEdit2, {15})
	self:applySkin(TrinityBars2ButtonEditorCurrentButtonEdit2PopUp)
	self:applySkin(TrinityBars2ButtonEditorCurrentButton)
	self:applySkin(TrinityBars2ButtonEditorCheckOptionsBG)
	self:applySkin(TrinityBars2ButtonEditorCheckOptions)
	TrinityBars2ButtonEditorAnchorOptionsEdit1:SetWidth(TrinityBars2ButtonEditorAnchorOptionsEdit1:GetWidth() - 10)
	self:skinEditBox(TrinityBars2ButtonEditorAnchorOptionsEdit1, {15})
	self:applySkin(TrinityBars2ButtonEditorAnchorOptionsEdit1PopUp)
	RaiseFrameLevel(TrinityBars2ButtonEditorAnchorOptionsEdit1)
	self:skinEditBox(TrinityBars2ButtonEditorAnchorOptionsEdit2, {15})
	self:applySkin(TrinityBars2ButtonEditorAnchorOptionsEdit2PopUp)
	RaiseFrameLevel(TrinityBars2ButtonEditorAnchorOptionsEdit2)
	self:applySkin(TrinityBars2ButtonEditorAnchorOptionsBG)
	self:applySkin(TrinityBars2ButtonEditorAnchorOptions)
	self:skinEditBox(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit1, {15})
	self:applySkin(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit1PopUp)
	self:skinEditBox(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit2, {15})
	self:applySkin(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit2PopUp)
	self:skinEditBox(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit3, {15})
	self:applySkin(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit3PopUp)
	self:applySkin(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1)
	self:applySkin(TrinityBars2ButtonEditorAdjustableOptionsFrame)
	self:applySkin(TrinityBars2ButtonEditor)
-->>--	Action Edit Frame
	self:skinEditBox(TrinityBars2ButtonEditorActionEditSliderEdit101, {15})
	self:applySkin(TrinityBars2ButtonEditorActionEditBackdrop)
	self:applySkin(TrinityBars2ButtonEditorActionEdit)
	TrinityBars2ButtonEditorActionEdit:SetFrameLevel(TrinityBars2ButtonEditorActionEdit:GetFrameLevel() + 5)
-->>--	Slot Edit Frame
	self:skinEditBox(TrinityBars2ButtonEditorSlotEditSliderEdit102, {15})
	self:applySkin(TrinityBars2ButtonEditorSlotEditBackdrop)
	self:applySkin(TrinityBars2ButtonEditorSlotEdit)
	TrinityBars2ButtonEditorSlotEdit:SetFrameLevel(TrinityBars2ButtonEditorSlotEdit:GetFrameLevel() + 5)
-->>--	Macro Edit Frame
	self:skinEditBox(TrinityBars2ButtonEditorMacroEditNameEdit, {15})
	self:removeRegions(TrinityBars2ButtonEditorMacroEditScrollFrame1)
	self:skinScrollBar(TrinityBars2ButtonEditorMacroEditScrollFrame1, nil, nil, true)
	self:applySkin(TrinityBars2ButtonEditorMacroEditBG)
	self:applySkin(TrinityBars2ButtonEditorMacroEditTooltipEdit)
	self:removeRegions(TrinityBars2ButtonEditorMacroEditScrollFrame2)
	self:skinScrollBar(TrinityBars2ButtonEditorMacroEditScrollFrame2, nil, nil, true)
	self:removeRegions(TrinityBars2ButtonEditorMacroEditScrollFrame3)
	self:skinScrollBar(TrinityBars2ButtonEditorMacroEditScrollFrame3, nil, nil, true)
	self:applySkin(TrinityBars2ButtonEditorMacroEditScrollFrame3BG)
	self:applySkin(TrinityBars2ButtonEditorMacroEdit)

-->>-- Tabs
	skinTBTabs("TrinityBars2ButtonEditor")
	-- Hook this to resize the Tabs
	self:SecureHook(TrinityBars2ButtonEditor, "Show", function(this)
		self:resizeTabs(TrinityBars2ButtonEditor)
	end)

-->>-- Option Templates
	self:applySkin(TrinityBars2Options_TemplatesHeader)
	self:keepFontStrings(TrinityBars2Options_Templates)
	self:skinEditBox(TrinityBars2Options_TemplatesEdit3, {15, 16})
	self:applySkin(TrinityBars2Options_TemplatesEdit3PopUp)
	self:skinEditBox(TrinityBars2Options_TemplatesEdit5, {15})
	self:applySkin(TrinityBars2Options_TemplatesTemplateBorder)

-->>--	Option Storage
	self:applySkin(TrinityBars2Options_StorageHeader)

-->>--	Options
	self:applySkin(TrinityBars2OptionsHeader)
	self:keepFontStrings(TrinityBars2Options)
	self:skinEditBox(TrinityBars2OptionsEdit1, {15})
	self:applySkin(TrinityBars2OptionsEdit1PopUp)
	TrinityBars2OptionsEdit2:SetWidth(TrinityBars2OptionsEdit2:GetWidth() - 10)
	self:skinEditBox(TrinityBars2OptionsEdit2, {15, 16})
	self:applySkin(TrinityBars2OptionsEdit2PopUp)
	self:applySkin(TrinityBars2OptionsDropdownBorder, nil, nil, nil, 25)
	self:applySkin(TrinityBars2OptionsCheckbuttonBorder, nil, nil, nil, 150)
	self:applySkin(TrinityBars2OptionsSliderBorder)
	for i = 1, 6 do
		local seb = _G["TrinityBars2OptionsSliderEdit"..i]
		self:skinEditBox(seb, {15})
		seb:SetWidth(seb:GetWidth() - 5)
	end

end
