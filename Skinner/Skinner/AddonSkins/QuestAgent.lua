if not Skinner:isAddonEnabled("QuestAgent") then return end

function Skinner:QuestAgent()
	if not self.db.profile.QuestLog then return end
	
	local function chgTextCols()
		
		for i = 1, 10 do
			local r, g, b, a = _G["QuestAgent_QuestLogObjective"..i]:GetTextColor()
			_G["QuestAgent_QuestLogObjective"..i]:SetTextColor(Skinner.BTr - r, Skinner.BTg - g, Skinner.BTb)
		end
		QuestAgent_QuestLogRewardTitleText:SetTextColor(Skinner.HTr, Skinner.HTg, Skinner.HTb)
		QuestAgent_QuestLogRequiredMoneyText:SetTextColor(Skinner.BTr, Skinner.BTg, Skinner.BTb)
			
	end
	
	self:SecureHook(QuestAgent, "ShowQuest", function(this, q, name)
		chgTextCols()
		QuestAgent_QuestLogItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestAgent_QuestLogItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestAgent_QuestLogSpellLearnText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)
	
	QuestAgent_QuestLogQuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestAgent_QuestLogObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestAgent_QuestLogTimerText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestAgent_QuestLogSuggestedGroupNum:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestAgent_QuestLogDescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestAgent_QuestLogQuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestAgent_QuestLogPlayerTitleText:SetTextColor(self.BTr, self.BTg, self.BTb)
	chgTextCols()
	
	self:skinScrollBar{obj=QuestAgent_QuestLogDetailScrollFrame}
	self:addSkinFrame{obj=QuestAgent_QuestLogFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=48}
	
	self:addSkinFrame{obj=QuestAgentUpdateDialog}
	
end
