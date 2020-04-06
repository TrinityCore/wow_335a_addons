if not Skinner:isAddonEnabled("UberQuest") then return end

function Skinner:UberQuest()
	if not self.db.profile.QuestLog then return end

	-- Hook this to move the QuestLog Count
	self:SecureHook("UberQuest_QuestLogUpdateQuestCount", function(numQuests)
		self:moveObject(UberQuest_QuestLogCount, nil, nil, "+", 16)
	end)

	-- Hook this to update Quest Text colours (MUST use SecureHook otherwise scroll frame breaks)
	self:SecureHook(UberQuest_Details_Scroll, "UpdateScrollChildRect", function()
--		self:Debug("UberQuest_Details_Scroll - UpdateScrollChildRect")
		UberQuest_Details_ScrollChild_QuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
		UberQuest_Details_ScrollChild_ObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
		UberQuest_Details_ScrollChild_TimerText:SetTextColor(self.HTr, self.HTg, self.HTb)
		for i = 1, 10 do
			local r, g, b, a = _G["UberQuest_Details_ScrollChild_Objective"..i]:GetTextColor()
			_G["UberQuest_Details_ScrollChild_Objective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		end
		local r, g, b, a = UberQuest_Details_ScrollChild_RequiredMoneyText:GetTextColor()
		UberQuest_Details_ScrollChild_DescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
		UberQuest_Details_ScrollChild_QuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
		UberQuest_Details_ScrollChild_RequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		UberQuest_Details_ScrollChild_RewardTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
		UberQuest_Details_ScrollChild_ItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		UberQuest_Details_ScrollChild_ItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)

	-- Quest List Frame
	self:keepFontStrings(UberQuest_List)
	UberQuest_List:SetWidth(UberQuest_List:GetWidth() * self.FxMult)
	UberQuest_List:SetHeight(UberQuest_List:GetHeight() * self.FyMult)
	self:moveObject(UberQuest_List_Title, nil, nil, "+", 12)
	self:keepFontStrings(UberQuest_QuestLogCount)
	self:moveObject(UberQuest_List_CloseButton, "+", 30, "+", 8)
	self:moveObject(UberQuest_List_AbandonButton, "-", 12, "-", 70)
	self:moveObject(UberQuest_List_ConfigButton, "-", 20, "+", 10)
	self:moveObject(UberQuest_List_CloseButton2, "+", 32, "-", 70)
	self:moveObject(UberQuest_List_Scroll, "+", 42, "+", 4)
	self:keepFontStrings(UberQuest_List_Scroll)
	self:skinScrollBar(UberQuest_List_Scroll)
	-- movement values
	local xOfs, yOfs = 8, 6
--	UberQuest__HighlightFrame
	self:moveObject(UberQuest_List_Title1, "-", xOfs, "+", yOfs)
	self:moveObject(UberQuest_List_Scroll, "-", xOfs, "+", yOfs)
	self:moveObject(UberQuest_List_ExpandButtonFrame, "-", xOfs, "+", yOfs)
	self:removeRegions(UberQuest_List_ExpandButtonFrame_CollapseAllButton, {7, 8, 9})
	self:applySkin(UberQuest_List)

	-- Details Frame
	self:keepFontStrings(UberQuest_Details)
	UberQuest_Details:SetWidth(UberQuest_Details:GetWidth() * self.FxMult)
	UberQuest_Details:SetHeight(UberQuest_Details:GetHeight() * self.FyMult)
	self:moveObject(UberQuest_Details, "+", 46, "-", 6)
	self:moveObject(UberQuest_Details_Title, nil, nil, "+", 12)
	self:moveObject(UberQuest_Details_CloseButton, "+", 26, "+", 14)
	self:moveObject(UberQuest_Details_Exit, "+", 28, "-", 66)
	self:keepFontStrings(UberQuest_Details_Scroll)
	self:moveObject(UberQuest_Details_Scroll, "-", 10, "+", 20)
	self:skinScrollBar(UberQuest_Details_Scroll)
	UberQuest_Details_ScrollChild_QuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	UberQuest_Details_ScrollChild_ObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	UberQuest_Details_ScrollChild_TimerText:SetTextColor(self.HTr, self.HTg, self.HTb)
	for i = 1, 10 do
		local r, g, b, a = _G["UberQuest_Details_ScrollChild_Objective"..i]:GetTextColor()
		_G["UberQuest_Details_ScrollChild_Objective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
	end
	local r, g, b, a = UberQuest_Details_ScrollChild_RequiredMoneyText:GetTextColor()
	UberQuest_Details_ScrollChild_RequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
	UberQuest_Details_ScrollChild_DescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	UberQuest_Details_ScrollChild_QuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	UberQuest_Details_ScrollChild_RewardTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	UberQuest_Details_ScrollChild_ItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
	UberQuest_Details_ScrollChild_ItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:applySkin(UberQuest_Details)

	-- Config Frame
	self:moveObject(UberQuest_ConfigFrame, "+", 36, "-", 6)
	UberQuest_ConfigFrame:SetWidth(UberQuest_ConfigFrame:GetWidth() + 10)
	UberQuest_ConfigFrameBackdrop:Hide()
	self:moveObject(UberQuest_ConfigFrame_ResetMinion, "-", 5, nil, nil)
	self:moveObject(UberQuest_ConfigFrame_CloseButton, "+", 5, nil, nil)
	self:applySkin(UberQuest_ConfigFrame)

	-- Minion Frame
	UberQuest_MinionBackdrop:Hide()
	self:applySkin(UberQuest_Minion)

end
