if not Skinner:isAddonEnabled("QuestHistory") then return end

function Skinner:QuestHistory()

	self:keepFontStrings(QuestHistoryFrame)
	QuestHistoryFrame:SetWidth(QuestHistoryFrame:GetWidth() * self.FxMult + 25)
	QuestHistoryFrame:SetHeight(QuestHistoryFrame:GetHeight() - 15)
	self:moveObject(QuestHistoryFrameCloseButton, "+", 42, "+", 4)
	self:keepFontStrings(QuestHistorySortDropDown1)
	self:skinEditBox(QuestHistoryFrameSearchEditBox, {9})
	self:keepFontStrings(QuestHistoryListScrollFrame)
	self:skinScrollBar(QuestHistoryListScrollFrame)
	self:moveObject(QuestHistoryFrameCancelButton, "+", 35, "-", 15)
	self:moveObject(QuestHistoryFrameSearchButton, nil, nil, "-", 15)
	self:moveObject(QuestHistoryFrameClearButton, nil, nil, "-", 15)
	self:moveObject(QuestHistoryFrameSubmitButton, nil, nil, "-", 15)
	self:applySkin(QuestHistoryFrame, true)

-->>--	Options Frame
	self:keepFontStrings(QuestHistoryOptionsFrame)
	QuestHistoryOptionsFrame:SetHeight(QuestHistoryFrame:GetHeight())
	self:keepFontStrings(QuestHistoryCharacterDropDown1)
	self:applySkin(QuestHistoryOptionsFrameShow)
	self:applySkin(QuestHistoryOptionsFrameLog)
	self:applySkin(QuestHistoryOptionsFrameRepair)
	self:applySkin(QuestHistoryOptionsFrameOther)
	self:moveObject(QuestHistoryOptionsFrameCancelButton, nil, nil, "-", 10)
	self:applySkin(QuestHistoryOptionsFrame, true)
-->>--	Edit Frame
	self:keepFontStrings(QuestHistoryEditFrame)
	QuestHistoryEditFrame:SetWidth(QuestHistoryEditFrame:GetWidth() * self.FxMult)
	QuestHistoryEditFrame:SetHeight(QuestHistoryEditFrame:GetHeight() * self.FyMult + 20)
	self:moveObject(QuestHistoryEditTitle, nil, nil, "+", 8)
	self:moveObject(QuestHistoryEditFrameCloseButton, "+", 28, "+", 8)
	local EB_Names = { "LevelAccepted", "LevelCompleted", "MoneyRewarded", "XPRewarded", "AcceptedOrder", "Level", "CompletedOrder", "Category", "Tag", "QuestGiver", "QuestCompleter", "AcceptedZone", "AcceptedX", "AcceptedY", "CompletedZone", "CompletedX", "CompletedY", "TimeAccepted", "TimeCompleted", "TimesAbandoned", "TimesFailed", }
	for i, v in pairs(EB_Names) do
		local ebName = _G["QuestHistoryEdit"..v.."EditBox"]
		self:skinEditBox(ebName, {9})
		self:moveObject(ebName, "-", 2, "+", 2)
		ebName:SetHeight(20)
	end
	self:moveObject(QuestHistoryEditFrameAddButton, "-", 10, "-", 45)
	self:moveObject(QuestHistoryEditFrameSaveButton, "-", 10, "-", 45)
	self:moveObject(QuestHistoryEditFrameExitButton, "+", 30, "-", 45)
	self:keepFontStrings(QuestHistoryEditListScrollFrame)
	self:skinScrollBar(QuestHistoryEditListScrollFrame)
	self:skinEditBox(QuestHistoryEditTitleEditBox, {9})
	QuestHistoryEditTitleEditBox:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestHistoryEditObjectivesEditBox:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestHistoryEditDescriptionEditBox:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:applySkin(QuestHistoryEditFrame)
-->>--	Confirm Frame
	self:keepFontStrings(QuestHistoryConfirmFrame)
	QuestHistoryConfirmFrame:SetWidth(QuestHistoryConfirmFrame:GetWidth() * self.FxMult)
	QuestHistoryConfirmFrame:SetHeight(QuestHistoryConfirmFrame:GetHeight() * self.FyMult + 20)
	self:applySkin(QuestHistoryConfirmFrame, true)
-->>--	Detail Frame
	self:keepFontStrings(QuestHistoryDetailFrame)
	QuestHistoryDetailFrame:SetWidth(QuestHistoryDetailFrame:GetWidth() * self.FxMult)
	QuestHistoryDetailFrame:SetHeight(QuestHistoryDetailFrame:GetHeight() * self.FyMult + 20)
	self:moveObject(QuestHistoryDetailTitle, nil, nil, "+", 8)
	self:moveObject(QuestHistoryDetailFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(QuestHistoryDetailPreviousButton, "-", 10, "-", 45)
	self:moveObject(QuestHistoryDetailFrameExitButton, "+", 30, "-", 45)
	self:keepFontStrings(QuestHistoryDetailListScrollFrame)
	self:skinScrollBar(QuestHistoryDetailListScrollFrame)
	self:keepFontStrings(QuestHistoryDetailNotesScrollFrame)
	self:skinScrollBar(QuestHistoryDetailNotesScrollFrame)
	self:keepFontStrings(QuestHistoryDetailScrollFrame)
	self:skinScrollBar(QuestHistoryDetailScrollFrame)
	QuestHistoryDetailQuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestHistoryDetailObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 10 do
		_G["QuestHistoryDetailObjective"..i]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	QuestHistoryDetailRequiredMoneyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestHistoryDetailDescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestHistoryDetailQuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestHistoryDetailRewardTitleText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestHistoryDetailRewardTitleText.SetTextColor = function() end
	QuestHistoryDetailItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestHistoryDetailItemChooseText.SetTextColor = function() end
	QuestHistoryDetailItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestHistoryDetailItemReceiveText.SetTextColor = function() end
	self:applySkin(QuestHistoryDetailFrame)

end
