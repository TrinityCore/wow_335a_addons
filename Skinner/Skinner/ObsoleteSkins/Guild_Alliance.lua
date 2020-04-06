
function Skinner:Guild_Alliance()
	if not self.db.profile.FriendsFrame then return end

	-- Tab
	self:SecureHook("GA_Tab_OnLoad", function()
--		self:Debug("GA_Tab_OnLoad: [%s, %s]", FriendsFrame.numTabs, this:GetName())
		local tabName = this
		self:keepRegions(tabName, {7, 8}) -- N.B. these regions are text & highlight
		self:moveObject(tabName, "+", 10, nil, nil)
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil ,0)
			self:setInactiveTab(tabName)
		else self:applySkin(tabName) end
	end)

-->>--	GA_ListFrame
	self:moveObject(GA_Options_Button, nil, nil, "+", 10)
	self:keepFontStrings(GAListFrameColumnHeaderName)
	self:applySkin(GAListFrameColumnHeaderName)
	self:moveObject(GAListFrameColumnHeaderName, nil, nil, "+", 10)
	self:keepFontStrings(GAListFrameColumnHeaderGuild)
	self:applySkin(GAListFrameColumnHeaderGuild)
	self:keepFontStrings(GAListFrameColumnHeaderLvl)
	self:applySkin(GAListFrameColumnHeaderLvl)
	self:keepFontStrings(GAListFrameColumnHeaderClass)
	self:applySkin(GAListFrameColumnHeaderClass)
	self:keepFontStrings(GA_ScrollBar)
	self:skinScrollBar(GA_ScrollBar)
	self:applySkin(GA_ScrollBar)
	self:moveObject(GA_Guild_Info, "-", 10, "1", 10)
	self:keepFontStrings(GA_DropDownMenu)

-->>--	Options Frame
	self:skinEditBox(GA_ChannelPassBox)
	self:applySkin(GA_Options_Frame)
-->>--	Setup Frame
	self:skinEditBox(GA_ChannelNameBox)
	self:applySkin(GA_SetupFrame)
-->>--	GuildControl Frame
	self:keepFontStrings(GA_DropDownMenu_Ranks)
	self:skinEditBox(GA_Mass_Message_Text, {9})
	self:applySkin(GA_GuildControl_Frame)
-->>--	InspectPaperDoll Frame
	self:keepFontStrings(GA_InspectPaperDollFrame)
	self:moveObject(GA_InspectNameText, "-", 14, "+", 4)
	self:moveObject(GA_Close_Paper_Doll, "-", 4, "+", 10)
	self:moveObject(GA_InspectHeadSlot, "-", 5, nil, nil)
	self:moveObject(GA_InspectMainHandSlot, "-", 5, nil, nil)
	self:moveObject(GA_InspectHandsSlot, "-", 5, nil, nil)
	self:keepFontStrings(GA_DropDownMenu_Stats)
	self:applySkin(GA_InspectPaperDollFrame)

end
