
function Skinner:EQL3()
	if not self.db.profile.QuestLog or self.initialized.EQL3 then return end
	self.initialized.EQL3 = true

	self:RawHook("QuestLog_UpdateQuestDetails", function(doNotScroll)
--		self:Debug("QuestLog_UpdateQuestDetails")
		self.hooks.QuestLog_UpdateQuestDetails(doNotScroll)
		for i = 1, 10 do
			local r, g, b, a = _G["EQL3_QuestLogObjective"..i]:GetTextColor()
			_G["EQL3_QuestLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		end
		local r, g, b, a = EQL3_QuestLogRequiredMoneyText:GetTextColor()
		EQL3_QuestLogRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		EQL3_QuestLogRewardTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
		EQL3_QuestLogItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		EQL3_QuestLogItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)

	EQL3_QuestLogFrame:SetWidth(EQL3_QuestLogFrame:GetWidth() - 20)
	self:keepFontStrings(EQL3_QuestLogFrame)
	self:moveObject(EQL3_QuestLogFrameCloseButton, "+", 28, "+", 8)
	self:keepFontStrings(EQL3_QuestLogListScrollFrame)
	self:skinScrollBar(EQL3_QuestLogListScrollFrame)
	self:applySkin(EQL3_QuestLogFrame)
	-- Details Frame
	self:keepFontStrings(EQL3_QuestLogFrame_Details)
	-- Description Frame
	EQL3_QuestLogFrame_Description:SetWidth(EQL3_QuestLogFrame_Description:GetWidth() + 40)
	self:moveObject(EQL3_QuestLogFrame_Description, "-", 3, nil, nil)
	self:keepFontStrings(EQL3_QuestLogFrame_Description)
	self:moveObject(EQL3_QuestLogFrameCloseButton2, "+", 20, "+", 8)
	self:moveObject(EQL3_QuestLogDetailScrollFrame, "+", 40, nil, nil)
	self:keepFontStrings(EQL3_QuestLogDetailScrollFrame)
	self:skinScrollBar(EQL3_QuestLogDetailScrollFrame)
	EQL3_QuestLogQuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	EQL3_QuestLogObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	EQL3_QuestLogDescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	EQL3_QuestLogQuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:applySkin(EQL3_QuestLogFrame_Description)

-->>--	Options Frame
	self:keepFontStrings(EQL3_OptionsFrame)
	self:moveObject(EQL3_OptionsFrameCloseButton, "+", 8, "+", 8)
	self:applySkin(EQL3_OptionsFrame_Header_Log)
	self:applySkin(EQL3_OptionsFrame_Header_Color)
	self:applySkin(EQL3_OptionsFrame_Header_Tracker)
	self:applySkin(EQL3_OptionsFrame_Header_Tooltip)
	self:applySkin(EQL3_OptionsFrame, true)

end
