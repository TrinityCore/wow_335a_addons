if not Skinner:isAddonEnabled("GroupCalendar") then return end

function Skinner:GroupCalendar()
-- This is for GroupCalendar version 3

	-- check to see which version is loaded
	if GroupCalendar.VersionString then self:GroupCalendar_v4() return end

	-- remove other version
	self.GroupCalendar_v4 = nil

-->>--	Group Calendar Frame
	GroupCalendarFrame:SetWidth(GroupCalendarFrame:GetWidth() * self.FxMult + 20)
	GroupCalendarFrame:SetHeight(GroupCalendarFrame:GetHeight() * self.FyMult + 20)
	self:keepFontStrings(GroupCalendarFrame)
	self:getChild(GroupCalendarFrame, 1):Hide() -- hide the clock in the TLHC
	self:moveObject(GroupCalendarCloseButton, "-", 4, "+", 8)
	self:applySkin(GroupCalendarFrame)
-->>--	Calendar SubFrame
	self:keepFontStrings(GroupCalendarCalendarFrame)
	self:moveObject(GroupCalendarMonthYearText, "-", 15, nil, nil)
	self:moveObject(GroupCalendarCalendarFrameWeekdayLabel0, "-", 15, nil, nil)
	self:moveObject(GroupCalendarDay0, "-", 15, nil, nil)
	self:moveObject(GroupCalendarUseServerTime, nil, nil, "+", 10)
-->>--	Setup SubFrame
	self:keepFontStrings(GroupCalendarSetupFrame)
	self:moveObject(self:getRegion(GroupCalendarSetupFrame,1), "-", 15, "+", 15)
	self:moveObject(CalendarConfigModeMenu, "-", 15, "+", 30)
	self:keepFontStrings(CalendarConfigModeMenuConfigMode)
	self:skinEditBox(GroupCalendarChannelName, {9})
	self:skinEditBox(GroupCalendarChannelPassword, {9})
	self:skinEditBox(CalendarTrustedPlayerName, {9})
	self:keepFontStrings(GroupCalendarTrustMinRank)
-->>--	Excluded Players
	GroupCalendarExcludeGroup:SetHeight(GroupCalendarExcludeGroup:GetHeight() + 5)
	self:keepFontStrings(CalendarExcludedPlayersList)
	self:moveObject(CalendarExcludedPlayersListScrollFrame, nil, nil, "-", 3)
	self:moveObject(CalendarExcludedPlayersListItem0, nil, nil, "-", 3)
	self:keepFontStrings(CalendarExcludedPlayersListScrollFrame)
	self:skinScrollBar(CalendarExcludedPlayersListScrollFrame)
	self:applySkin(CalendarExcludedPlayersList)
	self:applySkin(GroupCalendarExcludeGroup)
-->>--	About SubFrame
	self:keepFontStrings(GroupCalendarAboutFrame)
	self:moveObject(GroupCalendarAboutTitleVersion, "-", 8, nil, nil)
	self:moveObject(GroupCalendarGuildURL, "-", 8, nil, nil)
-->>--	Side Panel
	GroupCalendarSidePanel:SetWidth(GroupCalendarFrame:GetWidth())
	GroupCalendarSidePanel:SetHeight(GroupCalendarFrame:GetHeight())
	self:keepFontStrings(GroupCalendarSideListScrollbarTrench)
	self:keepFontStrings(GroupCalendarSideListScrollFrame)
	self:skinScrollBar(GroupCalendarSideListScrollFrame)
	self:moveObject(GroupCalendarSidePanelCloseButton, "-", 4, "-", 4)
	self:keepFontStrings(GroupCalendarSidePanel)
	self:moveObject(GroupCalendarSidePanel, "-", 3, "+", 21)
	self:applySkin(GroupCalendarSidePanel)
	-- Tabs
	for i = 1, 3 do
		local tabName = _G["GroupCalendarFrameTab"..i]
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 21)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 10, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook("GroupCalendar_ShowPanel", function(tabNo)
			self:setInactiveTab(GroupCalendarFrameTab1)
			self:setInactiveTab(GroupCalendarFrameTab2)
			self:setInactiveTab(GroupCalendarFrameTab3)
			self:setActiveTab(_G["GroupCalendarFrameTab"..tabNo])
		end)
	end

-->>--	Calendar Editor Frame
	CalendarEditorFrame:SetWidth(GroupCalendarFrame:GetWidth())
	CalendarEditorFrame:SetHeight(GroupCalendarFrame:GetHeight())
	self:moveObject(CalendarEditorFrame, "-", 3, "+", 21)
	self:moveObject(CalendarEditorCloseButton, "-", 4, "-", 4)
	self:keepFontStrings(CalendarEditorScrollFrame)
	self:skinScrollBar(CalendarEditorScrollFrame)
	self:keepFontStrings(CalendarEditorScrollbarTrench)
	self:keepFontStrings(CalendarEditorFrame)
	self:applySkin(CalendarEditorFrame)

-->>--	Calendar Event Editor Frame
	CalendarEventEditorFrame:SetWidth(GroupCalendarFrame:GetWidth())
	CalendarEventEditorFrame:SetHeight(GroupCalendarFrame:GetHeight())
	self:moveObject(CalendarEventEditorFrame, "-", 3, "+", 21)
	self:moveObject(CalendarEventEditorCloseButton, "-", 4, "-", 4)
	CalendarEventEditorEventBackground:Hide()
	self:keepFontStrings(CalendarEventEditorDurationDuration)
	self:keepFontStrings(CalendarEventEditorDuration)
	self:keepFontStrings(CalendarEventEditorTimeAMPM)
	self:keepFontStrings(CalendarEventEditorTimeMinute)
	self:keepFontStrings(CalendarEventEditorTimeHour)
	self:keepFontStrings(CalendarEventEditorTime)
	self:keepFontStrings(CalendarEventEditorEventFrame)
	self:keepFontStrings(CalendarEventTypeEventType)
	self:keepFontStrings(CalendarEventType)
	self:skinEditBox(CalendarEventTitle, {9})
	self:skinEditBox(CalendarEventMinLevel, {9})
	self:skinEditBox(CalendarEventMaxLevel, {9})
	CalendarEventDescriptionFrame:SetWidth(CalendarEventDescriptionFrame:GetWidth() + 10)
	CalendarEventDescriptionFrame:SetHeight(CalendarEventDescriptionFrame:GetHeight() + 10)
	self:moveObject(self:getRegion(CalendarEventDescriptionScrollFrame, 1), "-", 10, "+", 3)
	self:moveObject(CalendarEventDescription, "-", 5, nil, nil)
	self:keepFontStrings(CalendarEventDescriptionFrame)
	self:applySkin(CalendarEventDescriptionFrame)
	self:keepFontStrings(CalendarEventDescriptionScrollFrame)
	self:moveObject(CalendarEventDescriptionScrollFrame, "+", 8, "-", 7)
	self:moveObject(CalendarEventDescriptionLimit, "-", 10, nil, nil)
	self:skinScrollBar(CalendarEventDescriptionScrollFrame)
	self:keepFontStrings(CalendarEventEditorFrame)
	self:applySkin(CalendarEventEditorFrame)
	-- hook these to manage display options
	self:SecureHook("CalendarEventEditor_OnShow", function()
		HideUIPanel(CalendarEditorFrame)
	end)
	self:SecureHook("CalendarEventEditor_OnHide", function()
		GroupCalendar_SelectDate(gCalendarActualDate)
	end)
	-- Tabs
	for i = 1, 2 do
		local tabName = _G["CalendarEventEditorFrameTab"..i]
		if i == 1 then
			self:moveObject(tabName, nil, nil, "+", 4)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "-", 10, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook("CalendarEventEditor_ShowPanel", function(tabNo)
			self:setInactiveTab(CalendarEventEditorFrameTab1)
			self:setInactiveTab(CalendarEventEditorFrameTab2)
			self:setActiveTab(_G["CalendarEventEditorFrameTab"..tabNo])
		end)
	end

-->>--	Calendar Event Editor Attendance Frame
	self:keepRegions(CalendarEventEditorAttendanceExpandAll, {7, 8})
	self:keepRegions(CalendarEventEditorAttendanceGroupTab, {7, 8})
	self:keepFontStrings(CalendarEventEditorAttendanceScrollFrame)
	self:skinScrollBar(CalendarEventEditorAttendanceScrollFrame)
	self:keepFontStrings(CalendarEventEditorAttendanceScrollbarTrench)
	self:keepFontStrings(CalendarEventEditorAttendanceGroupView)
	self:keepFontStrings(CalendarEventEditorAttendanceMainViewTotals)
	self:keepFontStrings(CalendarEventEditorAttendanceMainViewAutoConfirmMenu)
	self:keepFontStrings(CalendarEventEditorAttendanceMainViewAutoConfirm)
	self:keepFontStrings(CalendarEventEditorAttendanceMainView)
	self:keepFontStrings(CalendarEventEditorAttendanceViewMenu)
	self:keepFontStrings(CalendarEventEditorAttendance)
	self:keepFontStrings(CalendarEventEditorAttendanceFrame)

-->>--	Add Player Frame
	self:keepFontStrings(CalendarAddPlayerFrameWhisper)
	self:keepFontStrings(CalendarAddPlayerFrameGuildRankMenu)
	self:keepFontStrings(CalendarAddPlayerFrameGuildRank)
	self:keepFontStrings(CalendarAddPlayerFrameClassMenu)
	self:keepFontStrings(CalendarAddPlayerFrameClass)
	self:keepFontStrings(CalendarAddPlayerFrameRaceMenu)
	self:keepFontStrings(CalendarAddPlayerFrameRace)
	self:keepFontStrings(CalendarAddPlayerFrameStatusMenu)
	self:skinEditBox(CalendarAddPlayerFrameName, {9})
	self:skinEditBox(CalendarAddPlayerFrameLevel, {9})
	self:skinEditBox(CalendarAddPlayerFrameComment, {9})
	self:skinEditBox(CalendarAddPlayerFrameWhisperReply, {9})
	self:keepFontStrings(CalendarAddPlayerFrame)
	self:applySkin(CalendarAddPlayerFrame, true)

-->>--	Calendar Class Limits Frame
	for _, v in pairs(self.classTable) do
		local cMin = _G["CalendarClassLimitsFrame"..v.."Min"]
		local cMax = _G["CalendarClassLimitsFrame"..v.."Max"]
		self:skinEditBox(cMin)
		self:moveObject(cMin, "-", 6, "-", 4)
		self:skinEditBox(cMax)
		self:moveObject(cMax, "-", 4, nil, nil)
	end
	self:keepFontStrings(CalendarClassLimitsFrameMaxPartySize)
	self:applySkin(CalendarClassLimitsFrame, true)

-->>--	Calendar Event Viewer Frame
	CalendarEventViewerFrame:SetWidth(GroupCalendarFrame:GetWidth())
	CalendarEventViewerFrame:SetHeight(GroupCalendarFrame:GetHeight())
	self:keepFontStrings(CalendarEventViewerFrame)
	self:moveObject(CalendarEventViewerFrame, "-", 3, "+", 21)
	self:moveObject(EventViewerCloseButton, "-", 4, "-", 4)
	CalendarEventViewerParchment:SetAlpha(0)
	self:keepFontStrings(CalendarEventViewerCharacterMenu)
	self:keepFontStrings(CalendarEventViewerCharacter)
	self:keepFontStrings(CalendarEventViewerDescription)
	self:keepFontStrings(CalendarEventViewerEventFrame)
	self:keepFontStrings(CalendarEventViewerAttendanceGroupView)
	self:keepRegions(CalendarEventViewerAttendanceGroupTab, {7, 8})
	self:keepFontStrings(CalendarEventViewerAttendanceViewMenu)
	self:keepFontStrings(CalendarEventViewerAttendanceScrollFrame)
	self:skinScrollBar(CalendarEventViewerAttendanceScrollFrame)
	self:keepFontStrings(CalendarEventViewerAttendanceMainViewAutoConfirmMenu)
	self:keepFontStrings(CalendarEventViewerAttendanceMainViewAutoConfirm)
	self:keepFontStrings(CalendarEventViewerAttendanceMainViewTotals)
	self:keepFontStrings(CalendarEventViewerAttendanceMainView)
	self:keepFontStrings(CalendarEventViewerAttendanceScrollbarTrench)
	self:keepFontStrings(CalendarEventViewerAttendance)
	self:keepFontStrings(CalendarEventViewerAttendanceFrame)
	self:skinEditBox(CalendarEventViewerComment, {9})
	self:applySkin(CalendarEventViewerFrame)
-->>--	Attendance Frame
	self:keepRegions(CalendarEventViewerAttendanceExpandAll, {7, 8})
	self:keepRegions(CalendarEventViewerAttendanceGroupTab, {7, 8})
	self:keepFontStrings(CalendarEventViewerAttendanceScrollFrame)
	self:skinScrollBar(CalendarEventViewerAttendanceScrollFrame)
	self:keepFontStrings(CalendarEventViewerAttendanceScrollbarTrench)
	self:keepFontStrings(CalendarEventViewerAttendanceGroupView)
	self:keepFontStrings(CalendarEventViewerAttendanceMainViewTotals)
	self:keepFontStrings(CalendarEventViewerAttendanceMainViewAutoConfirmMen)
	self:keepFontStrings(CalendarEventViewerAttendanceMainViewAutoConfirm)
	self:keepFontStrings(CalendarEventViewerAttendanceMainView)
	self:keepFontStrings(CalendarEventViewerAttendanceViewMenu)
	self:keepFontStrings(CalendarEventViewerAttendance)
	self:keepFontStrings(CalendarEventViewerAttendanceFrame)
	-- Tabs
	for i = 1, 2 do
		local tabName = _G["CalendarEventViewerFrameTab"..i]
		if i == 1 then
			self:moveObject(tabName, nil, nil, "+", 4)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "-", 10, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook("CalendarEventViewer_ShowPanel", function(tabNo)
			self:setInactiveTab(CalendarEventViewerFrameTab1)
			self:setInactiveTab(CalendarEventViewerFrameTab2)
			self:setActiveTab(_G["CalendarEventViewerFrameTab"..tabNo])
			end)
	end

end

function Skinner:GroupCalendar_v4()
-- This is for GroupCalendar version 4

	-- remove other version
	self.GroupCalendar = nil

-->>--	Group Calendar Frame
	GroupCalendarFrame:SetWidth(GroupCalendarFrame:GetWidth() * self.FxMult + 20)
	GroupCalendarFrame:SetHeight(GroupCalendarFrame:GetHeight() * self.FyMult + 20)
	self:moveObject(GroupCalendarCloseButton, "-", 4, "+", 8)
	GroupCalendarFrameClock:Hide()
	self:keepFontStrings(GroupCalendarCalendarFrame)
	self:moveObject(GroupCalendarMonthYearText, "-", 13, nil, nil)
	self:moveObject(GroupCalendarCalendarFrameWeekdayLabel0, "-", 13, nil, nil)
	self:moveObject(GroupCalendarDay0, "-", 13, nil, nil)
-->>--	Side Panel
	self:keepFontStrings(GroupCalendarSideListScrollbarTrench)
	self:removeRegions(GroupCalendarSideListScrollFrame)
	self:skinScrollBar(GroupCalendarSideListScrollFrame)
	self:moveObject(GroupCalendarSidePanelCloseButton, "-", 4, "-", 4)
	self:keepFontStrings(GroupCalendarSidePanel)
	self:moveObject(GroupCalendarSidePanel, "-", 4, "-", 3)
	self:applySkin(GroupCalendarSidePanel)
-->>--	Excluded Players
	GroupCalendarExcludeGroup:SetHeight(GroupCalendarExcludeGroup:GetHeight() + 5)
	self:skinEditBox(CalendarTrustedPlayerName, {9})
	self:moveObject(CalendarExcludedPlayersListScrollFrame, nil, nil, "-", 3)
	self:moveObject(CalendarExcludedPlayersListItem0, nil, nil, "-", 3)
	self:removeRegions(CalendarExcludedPlayersListScrollFrame)
	self:skinScrollBar(CalendarExcludedPlayersListScrollFrame)
	self:keepFontStrings(CalendarExcludedPlayersList)
	self:applySkin(CalendarExcludedPlayersList)
	self:applySkin(GroupCalendarExcludeGroup)
-->>--	Backup Frame
	self:skinDropDown(GroupCalendarBackupFrameCharacterMenu, nil, true)
	self:moveObject(GroupCalendarBackupFrameBackupNow, nil, nil, "-", 30)
	self:SecureHook(GroupCalendarBackupFrame, "Show", function(this)
--		self:Debug("GCBF_Show: [%s]", GroupCalendarBackupFrameBackup1 or "nil")
		self:moveObject(GroupCalendarBackupFrameBackup1, "-", 50, nil, nil)
		self:Unhook(GroupCalendarBackupFrame, "Show")
	end)
-->>--	About Frame
	self:moveObject(GroupCalendarAboutTitleVersion, "-", 10, nil, nil)
	self:moveObject(GroupCalendarGuildURL, "-", 10, nil, nil)
	self:keepFontStrings(GroupCalendarAboutFrame)
-->>--	Setup Frame
	self:keepFontStrings(GroupCalendarSetupFrame)
	self:moveObject(self:getRegion(GroupCalendarSetupFrame, 1), "-", 13, "+", 15)
	self:moveObject(CalendarConfigModeMenu, "-", 13, "+", 30)
	self:skinDropDown(CalendarConfigModeMenu, nil, true)
	self:skinDropDown(GroupCalendarTrustMinRank, nil, true)
	self:skinEditBox(GroupCalendarChannelName, {9})
	self:skinEditBox(GroupCalendarChannelPassword, {9})
	self:keepFontStrings(GroupCalendarFrame)
	self:applySkin(GroupCalendarFrame)
	-- Tabs
	for i = 1, #GroupCalendar.PanelFrames do
		local tabName = _G["GroupCalendarFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 21)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 10, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook(GroupCalendar, "ShowPanel", function(pPanelIndex)
			for i = 1, #GroupCalendar.PanelFrames do
				local tabName = _G["GroupCalendarFrameTab"..i]
				if i == GroupCalendarFrame.selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end

-->>--	Calendar Editor Frame
	CalendarEditorFrame:SetHeight(GroupCalendarFrame:GetHeight())
	self:moveObject(CalendarEditorFrame, "-", 4, "+", 21)
	self:moveObject(CalendarEditorCloseButton, "-", 4, "-", 4)
	self:removeRegions(CalendarEditorScrollFrame)
	self:skinScrollBar(CalendarEditorScrollFrame)
	self:keepFontStrings(CalendarEditorScrollbarTrench)
	self:keepFontStrings(CalendarEditorFrame)
	self:applySkin(CalendarEditorFrame)


-->>--	Add Player Frame
	self:skinEditBox(CalendarAddPlayerFrameName, {9})
	self:keepFontStrings(CalendarAddPlayerFrameRankMenu)
	self:keepFontStrings(CalendarAddPlayerFrameRoleMenu)
	self:keepFontStrings(CalendarAddPlayerFrameStatusMenu)
	self:skinEditBox(CalendarAddPlayerFrameLevel, {9})
	self:keepFontStrings(CalendarAddPlayerFrameClassMenu)
	self:keepFontStrings(CalendarAddPlayerFrameRaceMenu)
	self:skinEditBox(CalendarAddPlayerFrameComment, {9})
	self:keepFontStrings(CalendarAddPlayerFrame)
	self:applySkin(CalendarAddPlayerFrame, true)
	self:keepFontStrings(CalendarAddPlayerFrameWhisper)
	self:skinEditBox(CalendarAddPlayerFrameWhisperReply, {9})

-->>--	Calendar Role Limits Frame
	for _, v in pairs({ "MH", "MT", "MD", "RD" }) do
		local cMin = _G["CalendarRoleLimitsFrame"..v.."Min"]
		local cMax = _G["CalendarRoleLimitsFrame"..v.."Max"]
		self:skinEditBox(cMin)
		self:moveObject(cMin, "-", 4, "-", 4)
		self:skinEditBox(cMax)
		self:moveObject(cMax, "-", 2, nil, nil)
	end
	self:skinEditBox(CalendarRoleLimitsFrameMHPRIESTMin)
	self:skinEditBox(CalendarRoleLimitsFrameMHDRUIDMin)
	self:skinEditBox(CalendarRoleLimitsFrameMHPALADINMin)
	self:skinEditBox(CalendarRoleLimitsFrameMHSHAMANMin)
	self:skinEditBox(CalendarRoleLimitsFrameMTDRUIDMin)
	self:skinEditBox(CalendarRoleLimitsFrameMTPALADINMin)
	self:skinEditBox(CalendarRoleLimitsFrameMTWARRIORMin)
	self:skinEditBox(CalendarRoleLimitsFrameMTDEATHKNIGHTMin)
	self:skinEditBox(CalendarRoleLimitsFrameMDDRUIDMin)
	self:skinEditBox(CalendarRoleLimitsFrameMDPALADINMin)
	self:skinEditBox(CalendarRoleLimitsFrameMDSHAMANMin)
	self:skinEditBox(CalendarRoleLimitsFrameMDWARRIORMin)
	self:skinEditBox(CalendarRoleLimitsFrameMDROGUEMin)
	self:skinEditBox(CalendarRoleLimitsFrameMDDEATHKNIGHTMin)
	self:skinEditBox(CalendarRoleLimitsFrameRDPRIESTMin)
	self:skinEditBox(CalendarRoleLimitsFrameRDDRUIDMin)
	self:skinEditBox(CalendarRoleLimitsFrameRDSHAMANMin)
	self:skinEditBox(CalendarRoleLimitsFrameRDHUNTERMin)
	self:skinEditBox(CalendarRoleLimitsFrameRDMAGEMin)
	self:skinEditBox(CalendarRoleLimitsFrameRDWARLOCKMin)
	self:skinDropDown(CalendarRoleLimitsFrameMaxPartySize, nil, true)
	self:applySkin(CalendarRoleLimitsFrame, true)

-->>--	Calendar Class Limits Frame
	for _, v in pairs(self.classTable) do
		if v == "DeathKnight" then v= "Deathknight" end
		local cMin = _G["CalendarClassLimitsFrame"..v.."Min"]
		local cMax = _G["CalendarClassLimitsFrame"..v.."Max"]
		self:skinEditBox(cMin)
		self:moveObject(cMin, "-", 6, "-", 4)
		self:skinEditBox(cMax)
		self:moveObject(cMax, "-", 4, nil, nil)
	end
	self:skinDropDown(CalendarClassLimitsFrameMaxPartySize, nil, true)
	self:applySkin(CalendarClassLimitsFrame, true)

-->>--	Calendar Event Viewer Frame
	CalendarEventViewerFrame:SetWidth(GroupCalendarFrame:GetWidth())
	CalendarEventViewerFrame:SetHeight(GroupCalendarFrame:GetHeight())
	self:keepFontStrings(CalendarEventViewerFrame)
	self:moveObject(CalendarEventViewerFrame, "-", 4, "+", 21)
	self:moveObject(CalendarEventViewerFrameCloseButton, "-", 4, "-", 4)
	CalendarEventViewerFrameParchment:SetAlpha(0)
	-- Event Frame
	self:keepFontStrings(CalendarEventViewerFrameEventFrame)
	self:skinEditBox(CalendarEventViewerFrameEventFrameComment, {9})
	self:skinDropDown(CalendarEventViewerFrameEventFrameCharacterMenu, nil, true)
	self:skinDropDown(CalendarEventViewerFrameEventFrameRoleMenu, nil, true)
	self:applySkin(CalendarEventViewerFrame)
	-- Attendance Frame
	self:keepFontStrings(CalendarEventViewerFrameAttendanceFrame)
	self:keepFontStrings(CalendarEventViewerFrameAttendanceFrameList)
	self:keepRegions(CalendarEventViewerFrameAttendanceFrameListExpandAll, {7, 8})
	self:keepRegions(CalendarEventViewerFrameAttendanceFrameListGroupTab, {7, 8})
	self:skinDropDown(CalendarEventViewerFrameAttendanceFrameListViewMenu, nil, true)
	self:keepFontStrings(CalendarEventViewerFrameAttendanceFrameListMainView)
	self:keepFontStrings(CalendarEventViewerFrameAttendanceFrameListMainViewClassTotals)
	self:keepFontStrings(CalendarEventViewerFrameAttendanceFrameListMainViewRoleTotals)
	self:keepFontStrings(CalendarEventViewerFrameAttendanceFrameListMainViewAutoConfirm)
	self:keepFontStrings(CalendarEventViewerFrameAttendanceFrameListGroupView)
	self:skinDropDown(CalendarEventViewerFrameAttendanceFrameListMainViewAutoConfirmMenu, nil, true)
	self:keepFontStrings(CalendarEventViewerFrameAttendanceFrameListScrollbarTrench)
	self:keepFontStrings(CalendarEventViewerFrameAttendanceFrameListScrollFrame)
	self:skinScrollBar(CalendarEventViewerFrameAttendanceFrameListScrollFrame)
	-- Editor Frame
	CalendarEventViewerFrameEditFrameBackground:Hide()
	self:skinDropDown(CalendarEventViewerFrameEditFrameTypeMenu, nil, true)
	self:skinEditBox(CalendarEventViewerFrameEditFrameTitle, {9})
	self:skinDropDown(CalendarEventViewerFrameEditFrameTimeHour, nil, true)
	self:skinDropDown(CalendarEventViewerFrameEditFrameTimeMinute, nil, true)
	self:skinDropDown(CalendarEventViewerFrameEditFrameTimeAMPM, nil, true)
	self:moveObject(CalendarEventViewerFrameEditFrameTimeZone, "+", 160, nil, nil)
	self:skinDropDown(CalendarEventViewerFrameEditFrameDurationMenu, nil, true)
	self:skinEditBox(CalendarEventViewerFrameEditFrameMinLevel, {9})
	self:skinEditBox(CalendarEventViewerFrameEditFrameMaxLevel, {9})
	CalendarEventViewerFrameEditFrameDescriptionFrame:SetWidth(CalendarEventViewerFrameEditFrameDescriptionFrame:GetWidth() + 10)
	CalendarEventViewerFrameEditFrameDescriptionFrame:SetHeight(CalendarEventViewerFrameEditFrameDescriptionFrame:GetHeight() + 10)
	self:moveObject(CalendarEventViewerFrameEditFrameDescriptionFrameScrollFrame, "+", 8, "-", 7)
	self:keepFontStrings(CalendarEventViewerFrameEditFrameDescriptionFrameScrollFrame)
	self:skinScrollBar(CalendarEventViewerFrameEditFrameDescriptionFrameScrollFrame)
	self:moveObject(CalendarEventViewerFrameEditFrameDescriptionFrameLimit, "-", 10, nil, nil)
	self:keepFontStrings(CalendarEventViewerFrameEditFrameDescriptionFrame)
	self:applySkin(CalendarEventViewerFrameEditFrameDescriptionFrame)
	-- Tabs
	for i = 1, 3 do
		local tabName = _G["CalendarEventViewerFrameTab"..i]
		if i == 1 then
			self:moveObject(tabName, nil, nil, "+", 4)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "-", 10, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook(GroupCalendar.EventViewer, "ShowPanel", function(this, pPanelIndex)
			for i = 1, 3 do
				local tabName = _G["CalendarEventViewerFrameTab"..i]
				if i == this.selectedTab then
					self:setActiveTab(tabName)
				else
					self:setInactiveTab(tabName)
				end
			end
		end)
	end

end
