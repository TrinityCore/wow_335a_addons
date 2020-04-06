
function Skinner:PartyQuests()

-->>-- List Frame
	self:SecureHook(PartyQuests.Frame, "ShowQuestLog", function()
		self:moveObject(PartyQuestsFrameCount, nil, nil, "+", 20)
		if IsAddOnLoaded("DoubleWide") or IsAddOnLoaded("beql") then
			if not PartyQuestsFrame.moved then
				self:moveObject(PartyQuestsFrame, "-", 60, nil, nil)
				PartyQuestsFrame.moved = true
			end
		end
	end)
	self:SecureHookScript(PartyQuestsFrame, "OnHide", function(this)
		if IsAddOnLoaded("DoubleWide") then PartyQuestsFrame.moved = false end
	end)

	self:keepFontStrings(PartyQuestsFrame)
	local div = 1
	if IsAddOnLoaded("DoubleWide") then div = 1.9 end
	if IsAddOnLoaded("beql") then if not beql.db.char.saved.minimized then div = 1.95 else div = 1.1 end end
	PartyQuestsFrame:SetWidth(QuestLogFrame:GetWidth() / div)
	PartyQuestsFrame:SetHeight(QuestLogFrame:GetHeight())
	if not div == 1 then self:moveObject(PartyQuestsFrame, "-", 60, nil, nil) end
	self:moveObject(PartyQuestsFrameTitleText, nil, nil, "+", 6)
	self:moveObject(PartyQuestsFrameCloseButton, "+", 30, "+", 8)
	self:keepFontStrings(PartyQuestsFrameCount)
	self:moveObject(PartyQuestsFrameTree, "-", 5, nil, nil)
	self:moveObject(PartyQuestsFrameHelpIcon, "-", 10, "-", 64)
	self:keepFontStrings(PartyQuestsFrameTreeListScrollFrame)
	self:skinScrollBar(PartyQuestsFrameTreeListScrollFrame)
	self:applySkin(PartyQuestsFrame)

-->>--	Tabs
	self:skinFFToggleTabs("PartyQuestsFrameToggleTab")

-->>--	Log Frame
	self:keepFontStrings(PartyQuestsLogFrame)
	PartyQuestsLogFrame:SetWidth(PartyQuestsFrame:GetWidth())
	PartyQuestsLogFrame:SetHeight(PartyQuestsFrame:GetHeight())
	self:moveObject(PartyQuestsLogFrameTitleText, nil, nil, "+", 13)
	self:moveObject(PartyQuestsLogFrameCloseButton, "+", 26, "+", 16)
	self:moveObject(PartyQuestsLogFrameQuestCount, nil, nil, "+", 20)
	self:moveObject(PartyQuestsLogDetailScrollFrame, "-", 10, nil, nil)
	self:keepFontStrings(PartyQuestsLogDetailScrollFrame)
	self:skinScrollBar(PartyQuestsLogDetailScrollFrame)
	self:moveObject(PartyQuestsLogFrameAbandonButton, nil, nil, "-", 60)
	self:moveObject(PartyQuestsLogFrameShareButton, nil, nil, "-", 60)
	self:moveObject(PartyQuestsLogFrameExitButton, nil, nil, "-", 60)
	self:applySkin(PartyQuestsLogFrame)

-->>--	Quest Text Colour
	PartyQuestsLogQuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	PartyQuestsLogObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	PartyQuestsLogTimerText:SetTextColor(self.BTr, self.BTg, self.BTb)
	PartyQuestsLogSuggestedGroupNum:SetTextColor(self.HTr, self.HTg, self.HTb)
	PartyQuestsLogDescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	PartyQuestsLogQuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)

end
