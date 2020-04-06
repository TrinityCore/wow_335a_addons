
function Skinner:JasonQuest()

	self:SecureHook(JQuest, "Log_RefreshDetails", function(this)
--		self:Debug("JQuest:Log_RefreshDetails")
		for i = 1, 10 do
			local r, g, b, a = _G["JQuestLogObjective"..i]:GetTextColor()
			_G["JQuestLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		end
	end)
	JQuest.Log_RefreshTextures = function() end

	self:keepFontStrings(JQuestLogFrame)
	JQuestLogFrame:SetWidth(QuestLogFrame:GetWidth())
	JQuestLogFrame:SetHeight(QuestLogFrame:GetHeight())
	self:moveObject(JQuestLogTitleText, nil, nil, "+", 8)
	self:moveObject(JQuestFrameCloseButton, "-", 4, "+", 8)
	self:applySkin(JQuestLogFrame)

	local xOfs, yOfs = 0, 15
	self:moveObject(JQuestLogVersionText, "-", xOfs, "+", yOfs)
	self:moveObject(JQuestLogQuestCount, "-", xOfs, "+", yOfs)
	local xOfs, yOfs = 0, 24
	self:moveObject(JQuestLogTitle1, "-", xOfs, "+", yOfs)
	self:moveObject(JQuestLogListScrollFrame, "-", xOfs, "+", yOfs)

	self:keepFontStrings(JQuestLogListScrollFrame)
	self:skinScrollBar(JQuestLogListScrollFrame)
	self:keepFontStrings(JQuestLogDetailScrollFrame)
	self:skinScrollBar(JQuestLogDetailScrollFrame)
	self:keepFontStrings(EmptyJQuestLogFrame)

	for i = 1, MAX_PARTY_MEMBERS do
		local tabName = _G["JQuestTab"..i]
		self:removeRegions(tabName, {1})
	end

	JQuestLogQuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	JQuestLogObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 10 do
		local r, g, b, a = _G["JQuestLogObjective"..i]:GetTextColor()
		_G["JQuestLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
	end
	JQuestLogSuggestedGroupNum:SetTextColor(self.HTr, self.HTg, self.HTb)
	JQuestLogDescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	JQuestLogQuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)

-->>--	Search EditBox
	self:SecureHook(JQuest, "AceEvent_FullyInitialized", function(this)
		self:skinEditBox(JQuest_SearchEditBox, {})
		JQuest_SearchLabel:SetAlpha(1)
		self:Unhook(JQuest, "AceEvent_FullyInitialized"	)
	end)

end
