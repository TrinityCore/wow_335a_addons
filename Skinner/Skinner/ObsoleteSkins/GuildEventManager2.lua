
function Skinner:GuildEventManager2()

-->>--	Main Frame
	self:applySkin(GEMMainFrame)

	-- Tabs
	for i = 1, GEMMainFrame.numTabs do
		local tabName = _G["GEMMainFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		if i == 1 then
			self:moveObject(tabName, "-", 20, "+", 5)
			self:setActiveTab(tabName)
		else
			self:moveObject(tabName, "+", 11, nil,nil)
			self:setInactiveTab(tabName)
		end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook("GEMMain_SelectTab", function(id)
			for i = 1, GEMMainFrame.numTabs do
				local tabName = _G["GEMMainFrameTab"..i]
				if i == id then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
			end)
	end
	self:resizeTabs(GEMMainFrame)

-->>--	List Frame (Events Tab)
	self:keepFontStrings(GEMListFrameCalViewResetsDropDown)
	self:keepFontStrings(GEMEventItemScrollFrame)
	self:skinScrollBar(GEMEventItemScrollFrame)
	self:keepFontStrings(GEMListFrameRerollDropDown)
	self:moveObject(GEMListFrameCommentString, "+", 40, nil, nil)
	self:skinEditBox(GEMListFrameComment, {9})
	self:moveObject(GEMListFrameComment, "-", 40, nil, nil)
	-- Details Frame
	GEMListDetailsFrame:SetHeight(GEMListDetailsFrame:GetHeight() + 30)
	self:moveObject(GEMListDetailsFrame_Descr_Title, nil, nil, "+", 50)
	self:moveObject(GEMListDetailsFrame_SortType_Title, nil, nil, "+", 30)
	self:applySkin(GEMListDetailsFrame)
	-- Limitations Frame
	GEMListLimitationsFrame:SetHeight(GEMListLimitationsFrame:GetHeight() + 30)
	self:applySkin(GEMListLimitationsFrame)
	-- Admin Frame
	GEMListAdminFrame:SetHeight(GEMListAdminFrame:GetHeight() + 30)
	self:keepFontStrings(GEMListAdminItemScrollFrame)
	self:skinScrollBar(GEMListAdminItemScrollFrame)
	self:applySkin(GEMListAdminFrame)

	-- Tabs
	self:SecureHook(GEMListMiddleFrame, "Show", function(this)
		for i = 1, GEMListMiddleFrame.numTabs do
			local tabName = _G["GEMListMiddleFrameTab"..i]
			self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
			self:applySkin(tabName)
			if i == 1 then
				self:moveObject(tabName, "+", 10, "+", 5)
		  	else
				self:moveObject(tabName, "+", 15, nil,nil)
			end
		end
		self:resizeTabs(GEMListMiddleFrame)
		self:Unhook(GEMListMiddleFrame, "Show")
		end)

-->>--	New Frame (New Tab)
	self:skinEditBox(GEMNew_Where, {9})
	self:keepFontStrings(GEMNew_Event_ZoneDropDown)
	self:skinEditBox(GEMNew_Comment, {9})
	self:skinEditBox(GEMNew_Count, {9})
	self:skinEditBox(GEMNew_MinLevel, {9})
	self:skinEditBox(GEMNew_MaxLevel, {9})
	self:skinEditBox(GEMNew_Limit_Warrior_Min, {9})
	self:skinEditBox(GEMNew_Limit_Warrior_Max, {9})
	self:skinEditBox(GEMNew_Limit_Paladin_Min, {9})
	self:skinEditBox(GEMNew_Limit_Paladin_Max, {9})
	self:skinEditBox(GEMNew_Limit_Shaman_Min, {9})
	self:skinEditBox(GEMNew_Limit_Shaman_Max, {9})
	self:skinEditBox(GEMNew_Limit_Rogue_Min, {9})
	self:skinEditBox(GEMNew_Limit_Rogue_Max, {9})
	self:skinEditBox(GEMNew_Limit_Mage_Min, {9})
	self:skinEditBox(GEMNew_Limit_Mage_Max, {9})
	self:skinEditBox(GEMNew_Limit_Warlock_Min, {9})
	self:skinEditBox(GEMNew_Limit_Warlock_Max, {9})
	self:skinEditBox(GEMNew_Limit_Hunter_Min, {9})
	self:skinEditBox(GEMNew_Limit_Hunter_Max, {9})
	self:skinEditBox(GEMNew_Limit_Druid_Min, {9})
	self:skinEditBox(GEMNew_Limit_Druid_Max, {9})
	self:skinEditBox(GEMNew_Limit_Priest_Min, {9})
	self:skinEditBox(GEMNew_Limit_Priest_Max, {9})
	self:keepFontStrings(GEMNewRerollDropDown)
	self:keepFontStrings(GEMNewChannelDropDown)
	self:skinEditBox(GEMNewTemplate_Name, {9})
	self:keepFontStrings(GEMNewTemplateListDropDown)
	self:applySkin(GEMNewTemplateBorderFrame)
	self:keepFontStrings(GEMNewSortingListDropDown)
	self:applySkin(GEMNewSortingBorderFrame)

-->>--	Players Frame (Members Tab)
	self:keepFontStrings(GEMPlayerItemScrollFrame)
	self:skinScrollBar(GEMPlayerItemScrollFrame)
	self:moveObject(GEMPlayerItemScrollFrame, "+", 16, nil, nil)

	-- Tabs
	self:SecureHook(GEMPlayersFrame, "Show", function(this)
		for i = 1, getn(GEM_ChannelsByInt) do
			local tabName = _G["GEMPlayersFrameTab"..i]
			if tabName and not tabName.skinned then
				self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
				self:applySkin(tabName)
				if i == 1 then
					self:moveObject(tabName, "+", 10, "+", 5)
			  	else
					self:moveObject(tabName, "+", 11, nil, nil)
				end
				tabName:SetWidth(tabName:GetTextWidth() + 20)
				tabName.skinned = true
			end
		end
		self:resizeTabs(GEMPlayersFrame)
		end)

-->>--	Options Frame (Options Tab)
	self:keepFontStrings(GEMOptionsFrameChannelsListScrollFrame)
	self:skinScrollBar(GEMOptionsFrameChannelsListScrollFrame)
	self:skinEditBox(GEMOptionsFrameChannelsListAddChannel, {9})
	self:skinEditBox(GEMOptionsFrameChannelsListAddPassword, {9})
	self:skinEditBox(GEMOptionsFrameChannelsListAddAlias, {9})
	self:skinEditBox(GEMOptionsFrameChannelsListAddSlash, {9})
	self:skinEditBox(GEMOptions_Comment, {9})
	self:skinEditBox(GEMOptions_ChannelBipValue, {9})
	self:skinEditBox(GEMOptions_DateFormat, {9})
	self:applySkin(GEMOptionsFrameChannelsList)

-->>--	Calendar Frame
	self:keepFontStrings(GEMCalendarHourDropDown)
	self:keepFontStrings(GEMCalendarMinuteDropDown)
	self:applySkin(GEMCalendarHourBorderFrame)
	self:applySkin(GEMCalendarTextBorderFrame)
	self:keepFontStrings(GEMCalendarMonthDropDown)
	self:keepFontStrings(GEMCalendarYearDropDown)
	self:applySkin(GEMCalendarDateBorderFrame)
	self:applySkin(GEMCalendarFrame)

-->>--	External Frame
	self:keepFontStrings(GEMExternalClassDropDown)
	self:skinEditBox(GEMExternalFrame_Name, {9})
	self:skinEditBox(GEMExternalFrame_Guild, {9})
	self:skinEditBox(GEMExternalFrame_Level, {9})
	self:skinEditBox(GEMExternalFrame_Comment, {9})
	self:applySkin(GEMExternalClassBorderFrame)
	self:applySkin(GEMExternalFrame)
	GEMExternalFrame:SetFrameStrata("DIALOG")

-->>--	Auto New Members Frame
	self:moveObject(GEMNewAutoMembersFramePHeader1, "-", 10, nil, nil)
	self:keepFontStrings(GEMNewAutoMembersFramePItemScrollFrame)
	self:skinScrollBar(GEMNewAutoMembersFramePItemScrollFrame)
	self:moveObject(GEMNewAutoMembersFrameRHeader1, "-", 10, nil, nil)
	self:keepFontStrings(GEMNewAutoMembersFrameRItemScrollFrame)
	self:skinScrollBar(GEMNewAutoMembersFrameRItemScrollFrame)
	self:applySkin(GEMNewAutoMembersFrame)

-->>--	List Banned Frame
	self:keepFontStrings(GEMListBannedItemScrollFrame)
	self:skinScrollBar(GEMListBannedItemScrollFrame)
	self:applySkin(GEMListBannedFrame)

end
