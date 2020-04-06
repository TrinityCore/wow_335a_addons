
function Skinner:SW_Stats()

	-- hook this function to handle Tabs
	self:RawHook("SW_TabClick", function(oTab)
--		self:Debug("SW_TabClick: [%s]", oTab:GetName())
		self.hooks.SW_TabClick(oTab)
		if string.find( oTab:GetName(), "SW_FrameConsole_Tab" ) then
			if self.db.profile.TexturedTab then self:applySkin(SW_FrameConsole_Tab1, nil, 0, 1)
			else self:applySkin(SW_FrameConsole_Tab1) end
			if self.db.profile.TexturedTab then self:applySkin(SW_FrameConsole_Tab2, nil, 0, 1)
			else self:applySkin(SW_FrameConsole_Tab2) end
			self:setInactiveTab(SW_FrameConsole_Tab1)
			self:setInactiveTab(SW_FrameConsole_Tab2)
			self:setActiveTab(oTab)
		else
			if self.db.profile.TexturedTab then self:applySkin(SW_BarSettingsFrameV2_Tab1, nil, 0, 1)
			else self:applySkin(SW_BarSettingsFrameV2_Tab1) end
			if self.db.profile.TexturedTab then self:applySkin(SW_BarSettingsFrameV2_Tab2, nil, 0, 1)
			else self:applySkin(SW_BarSettingsFrameV2_Tab2) end
			if self.db.profile.TexturedTab then self:applySkin(SW_BarSettingsFrameV2_Tab3, nil, 0, 1)
			else self:applySkin(SW_BarSettingsFrameV2_Tab3) end
			self:setInactiveTab(SW_BarSettingsFrameV2_Tab1)
			self:setInactiveTab(SW_BarSettingsFrameV2_Tab2)
			self:setInactiveTab(SW_BarSettingsFrameV2_Tab3)
			self:setActiveTab(oTab)
		end
	end)

-->>--	SW_BarSettingsFrameV2
	self:keepFontStrings(SW_BarSettingsFrameV2_Tab1)
	if self.db.profile.TexturedTab then self:applySkin(SW_BarSettingsFrameV2_Tab1, nil, 0, 1)
	else self:applySkin(SW_BarSettingsFrameV2_Tab1) end
	self:keepFontStrings(SW_BarSettingsFrameV2_Tab2)
	if self.db.profile.TexturedTab then self:applySkin(SW_BarSettingsFrameV2_Tab2, nil, 0, 1)
	else self:applySkin(SW_BarSettingsFrameV2_Tab2) end
	self:keepFontStrings(SW_BarSettingsFrameV2_Tab3)
	if self.db.profile.TexturedTab then self:applySkin(SW_BarSettingsFrameV2_Tab3, nil, 0, 1)
	else self:applySkin(SW_BarSettingsFrameV2_Tab3) end
	self:setActiveTab(SW_BarSettingsFrameV2_Tab1)
	self:setInactiveTab(SW_BarSettingsFrameV2_Tab2)
	self:setInactiveTab(SW_BarSettingsFrameV2_Tab3)
	self:keepFontStrings(SW_BarSettingsFrameV2)
	self:keepFontStrings(SW_InfoTypeDropDown)
	self:keepFontStrings(SW_SchoolDropDown)
	self:keepFontStrings(SW_ClassFilterDropDown)
	self:applySkin(SW_BarSettingsFrameV2, nil)

-->>--	SW_GeneralSettings
	self:keepFontStrings(SW_GeneralSettings)
	self:applySkin(SW_GeneralSettings, nil)

-->>--	SW_BarFrame1
	self:keepFontStrings(SW_BarFrame1)
	self:applySkin(SW_BarFrame1, nil)

-->>--	SW_BarSyncFrame
	self:keepFontStrings(SW_BarSyncFrame)
	self:applySkin(SW_BarSyncFrame, nil)

-->>--	SW_FrameConsole
	self:keepFontStrings(SW_FrameConsole_Tab1)
	if self.db.profile.TexturedTab then self:applySkin(SW_FrameConsole_Tab1, nil, 0, 1)
	else self:applySkin(SW_FrameConsole_Tab1) end
	self:keepFontStrings(SW_FrameConsole_Tab2)
	if self.db.profile.TexturedTab then self:applySkin(SW_FrameConsole_Tab2, nil, 0, 1)
	else self:applySkin(SW_FrameConsole_Tab2) end
	self:setActiveTab(SW_FrameConsole_Tab1)
	self:setInactiveTab(SW_FrameConsole_Tab2)
	self:applySkin(SW_FrameConsole_Title, nil)
	self:keepFontStrings(SW_FrameConsole)
	self:applySkin(SW_FrameConsole, nil)

-->>--	SW_BarReportFrame
	self:skinEditBox(SW_BarReportFrame_VarText_EditBox, {})
	self:keepFontStrings(SW_BarReportFrame)
	self:applySkin(SW_BarReportFrame, nil)

-->>-- Timeline Frame
	self:keepFontStrings(SW_TL_Selector)
	self:skinScrollBar(SW_TL_Selector)
	self:applySkin(SW_TimeLine)

-->>-- Target Selector Frame
	self:skinEditBox(SW_TargetFilterBox, {9})
	self:keepFontStrings(SW_Target_SelectorScroll)
	self:skinScrollBar(SW_Target_SelectorScroll)
	self:applySkin(SW_TargetSelector)

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then SW_SpellHookTT:SetBackdrop(self.backdrop) end
		self:skinTooltip(SW_SpellHookTT)
	end

end

function Skinner:SW_UniLog()

	self:skinEditBox(SW_UL_FilterSource, {9})
	self:skinEditBox(SW_UL_FilterTarget, {9})
	self:skinEditBox(SW_UL_FilterWhat, {9})
	self:applySkin(SW_UniLogFrame)

end
