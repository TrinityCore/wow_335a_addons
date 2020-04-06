if not Skinner:isAddonEnabled("CT_RaidTracker") then return end

function Skinner:CT_RaidTracker()

-->>-- Raid Tracker Frame
	CT_RaidTrackerFrame:SetWidth(CT_RaidTrackerFrame:GetWidth() * self.FxMult)
	CT_RaidTrackerFrame:SetHeight(CT_RaidTrackerFrame:GetHeight() * self.FyMult)
	self:moveObject(CT_RaidTrackerExpandButtonFrame, "-", 20, "+", 10)
	self:moveObject(CT_RaidTrackerTitle1, nil, nil, "+", 10)
	self:moveObject(CT_RaidTrackerFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(CT_RaidTrackerFrameView2Button, "-", 10, "-", 45)
	self:moveObject(CT_RaidTrackerFrameBackButton, "+", 30, "-", 45)
	self:keepFontStrings(CT_RaidTrackerFrame)
	self:applySkin(CT_RaidTrackerFrame)

	self:keepFontStrings(CT_EmptyRaidTrackerFrame)

	-- Raid List Scroll Frame
	self:keepFontStrings(CT_RaidTrackerListScrollFrame)
	self:moveObject(CT_RaidTrackerListScrollFrame, "-", 6, "+", 10)
	self:skinScrollBar(CT_RaidTrackerListScrollFrame)

	-- Raid Participant Scroll Frame
	self:moveObject(CT_RaidTrackerParticipantsText, nil, nil, "+", 10)
	CT_RaidTrackerParticipantsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:moveObject(CT_RaidTrackerTab1, nil, nil, "+", 10)
	self:keepFontStrings(CT_RaidTrackerTab1)
	self:keepFontStrings(CT_RaidTrackerTab2)
	self:keepFontStrings(CT_RaidTrackerTab3)
	if self.db.profile.TexturedTab then
		self:applySkin(CT_RaidTrackerTab1, nil, 0)
		self:applySkin(CT_RaidTrackerTab2, nil, 0)
		self:applySkin(CT_RaidTrackerTab3, nil, 0)
	else
		self:applySkin(CT_RaidTrackerTab1)
		self:applySkin(CT_RaidTrackerTab2)
		self:applySkin(CT_RaidTrackerTab3)
	end
	self:moveObject(CT_RaidTrackerPlayerLine1, nil, nil, "+", 10)
	for i = 1, 11 do
		_G["CT_RaidTrackerPlayerLine"..i.."Number"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerLine"..i.."Name"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerLine"..i.."Join"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerLine"..i.."Leave"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:keepFontStrings(CT_RaidTrackerDetailScrollFramePlayers)
	CT_RaidTrackerDetailScrollFramePlayersScrollBar:SetHeight(CT_RaidTrackerDetailScrollFramePlayersScrollBar:GetHeight() - 50)
	self:moveObject(CT_RaidTrackerDetailScrollFramePlayersScrollBar, nil, nil, "-", 38)
	self:skinScrollBar(CT_RaidTrackerDetailScrollFramePlayers)

	-- Raid Player Scroll Frame
	self:moveObject(CT_RaidTrackerPlayerText, nil, nil, "+", 10)
	CT_RaidTrackerPlayerText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:moveObject(CT_RaidTrackerPlayerRaidTab1, nil, nil, "+", 10)
	self:keepFontStrings(CT_RaidTrackerPlayerRaidTab1)
	self:keepFontStrings(CT_RaidTrackerPlayerRaidTabLooter)
	if self.db.profile.TexturedTab then
		self:applySkin(CT_RaidTrackerPlayerRaidTabLooter, nil, 0)
		self:applySkin(CT_RaidTrackerPlayerRaidTab1, nil, 0)
	else
		self:applySkin(CT_RaidTrackerPlayerRaidTab1)
		self:applySkin(CT_RaidTrackerPlayerRaidTabLooter)
	end
	self:moveObject(CT_RaidTrackerPlayerRaid1, nil, nil, "+", 10)
	for i = 1, 11 do
		_G["CT_RaidTrackerPlayerRaid"..i.."Number"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerRaid"..i.."Name"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerRaid"..i.."Note"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:keepFontStrings(CT_RaidTrackerDetailScrollFramePlayer)
	CT_RaidTrackerDetailScrollFramePlayerScrollBar:SetHeight(CT_RaidTrackerDetailScrollFramePlayerScrollBar:GetHeight() - 50)
	self:moveObject(CT_RaidTrackerDetailScrollFramePlayerScrollBar, nil, nil, "-", 38)
	self:skinScrollBar(CT_RaidTrackerDetailScrollFramePlayer)

	-- Raid Bosses Scroll Frame
	self:moveObject(CT_RaidTrackerEventsText, nil, nil, "+", 10)
	CT_RaidTrackerEventsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:moveObject(CT_RaidTrackerPlayerBossesTab1, nil, nil, "+", 10)
	self:keepFontStrings(CT_RaidTrackerPlayerBossesTab1)
	self:keepFontStrings(CT_RaidTrackerPlayerBossesTabBoss)
	if self.db.profile.TexturedTab then
		self:applySkin(CT_RaidTrackerPlayerBossesTab1, nil, 0)
		self:applySkin(CT_RaidTrackerPlayerBossesTabBoss, nil, 0)
	else
		self:applySkin(CT_RaidTrackerPlayerBossesTab1)
		self:applySkin(CT_RaidTrackerPlayerBossesTabBoss)
	end
	self:moveObject(CT_RaidTrackerBosses1, nil, nil, "+", 10)
	for i = 1, 11 do
		_G["CT_RaidTrackerBosses"..i.."Boss"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerBosses"..i.."Time"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:keepFontStrings(CT_RaidTrackerDetailScrollFrameEvents)
	CT_RaidTrackerDetailScrollFrameEventsScrollBar:SetHeight(CT_RaidTrackerDetailScrollFrameEventsScrollBar:GetHeight() - 50)
	self:moveObject(CT_RaidTrackerDetailScrollFrameEventsScrollBar, nil, nil, "-", 38)
	self:skinScrollBar(CT_RaidTrackerDetailScrollFrameEvents)

	-- Raid Items Scroll Frame
	self:moveObject(CT_RaidTrackerItemsText, nil, nil, "+", 10)
	CT_RaidTrackerItemsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:moveObject(CT_RaidTrackerRarityDropDown, nil, nil, "+", 10)
	self:keepFontStrings(CT_RaidTrackerRarityDropDown)
	self:moveObject(CT_RaidTrackerItemTab1, nil, nil, "+", 10)
	self:keepFontStrings(CT_RaidTrackerItemTab1)
	self:keepFontStrings(CT_RaidTrackerItemTab2)
	self:keepFontStrings(CT_RaidTrackerItemTab3)
	self:keepFontStrings(CT_RaidTrackerItemTab4)
	if self.db.profile.TexturedTab then
		self:applySkin(CT_RaidTrackerItemTab1, nil, 0)
		self:applySkin(CT_RaidTrackerItemTab2, nil, 0)
		self:applySkin(CT_RaidTrackerItemTab3, nil, 0)
		self:applySkin(CT_RaidTrackerItemTab4, nil, 0)
	else
		self:applySkin(CT_RaidTrackerItemTab1)
		self:applySkin(CT_RaidTrackerItemTab2)
		self:applySkin(CT_RaidTrackerItemTab3)
		self:applySkin(CT_RaidTrackerItemTab4)
	end
	self:moveObject(CT_RaidTrackerItem1, nil, nil, "+", 10)
	for i = 1, 5 do
		_G["CT_RaidTrackerItem"..i.."Description"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerItem"..i.."Looted"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerItem"..i.."Count"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:keepFontStrings(CT_RaidTrackerDetailScrollFrameItems)
	CT_RaidTrackerDetailScrollFrameItemsScrollBar:SetHeight(CT_RaidTrackerDetailScrollFrameItemsScrollBar:GetHeight() - 50)
	self:moveObject(CT_RaidTrackerDetailScrollFrameItemsScrollBar, nil, nil, "-", 38)
	self:skinScrollBar(CT_RaidTrackerDetailScrollFrameItems)

-->>--	Accept Delete Frame
	CT_RaidTrackerAcceptDeleteFrameHeaderTexture:Hide()
	self:moveObject(CT_RaidTrackerAcceptDeleteFrameHeaderText, nil, nil, "+", 8)
	self:applySkin(CT_RaidTrackerAcceptDeleteFrame)

-->>--	Edit Note Frame
	CT_RaidTrackerEditNoteFrameHeaderTexture:Hide()
	self:moveObject(CT_RaidTrackerEditNoteFrameTitle, nil, nil, "-", 8)
	self:skinEditBox(CT_RaidTrackerEditNoteFrameNoteEB, {9})
	self:applySkin(CT_RaidTrackerEditNoteFrame)

-->>--	URL Frame
	self:skinEditBox(URLFrameEditBox, {9})
	self:applySkin(URLFrame, true)

-->>--	Join Leave Frame
	CT_RaidTrackerJoinLeaveFrameHeaderTexture:Hide()
	self:moveObject(CT_RaidTrackerJoinLeaveFrameTitle, nil, nil, "+", 8)
	self:skinEditBox(CT_RaidTrackerJoinLeaveFrameNameEB, {9})
	self:skinEditBox(CT_RaidTrackerJoinLeaveFrameNoteEB, {9})
	self:skinEditBox(CT_RaidTrackerJoinLeaveFrameTimeEB, {9})
	self:applySkin(CT_RaidTrackerJoinLeaveFrame)

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then CT_RTTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(CT_RTTooltip)
	end

-->>--	Options Frame
	CT_RaidTrackerOptionsFrameTitle:Hide()
	self:moveObject(CT_RaidTrackerOptionsFrameCloseButton, "+", 8, "+", 8)
	self:applySkin(CT_RaidTrackerOptionsFrame)

-->>--	Item Options Frame
	RaidWarnFrameTitle:Hide()
	self:moveObject(CT_RaidTracker_ItemOptions_CloseButton, "+", 6, "+", 6)
	self:keepFontStrings(CT_RaidTracker_ItemOptions_ScrollBar)
	self:skinScrollBar(CT_RaidTracker_ItemOptions_ScrollBar)
	self:applySkin(CT_RaidTracker_ItemOptions_ScrollFrame)
	self:applySkin(CT_RaidTrackerItemOptionsFrame)

	self:applySkin(CT_RaidTracker_ItemOptions_EditFrame)

end
