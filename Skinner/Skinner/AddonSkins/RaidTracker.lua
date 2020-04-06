if not Skinner:isAddonEnabled("RaidTracker") then return end

function Skinner:RaidTracker()

-->>-- Raid Tracker Frame
	self:addSkinFrame{obj=RaidTrackerFrame, kfs=true, x1=10, y1=-10, x2=-2, y2=-6}

	-- RT_LogFrame SubFrame
	self:skinScrollBar{obj=RT_LogFrame}

	-- RT_DetailFramePlayers SubFrame
	RT_DetailFramePlayersText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinFFColHeads("RT_DetailFramePlayersTab", 3)
	for i = 1, 11 do
		_G["RT_DetailFramePlayersLine"..i.."Number"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFramePlayersLine"..i.."Name"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFramePlayersLine"..i.."Join"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFramePlayersLine"..i.."Leave"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		local text = self:getRegion(_G["RT_DetailFramePlayersLine"..i.."DeleteButton"], 1)
		text:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:skinScrollBar{obj=RT_DetailFramePlayers}

	-- RT_DetailFrameItems SubFrame
	self:keepFontStrings(RT_RarityDropdownFrame)
	self:skinFFColHeads("RT_DetailFrameItemsTab", 4)
	for i = 1, 6 do
		_G["RT_DetailFrameItemsLine"..i.."Description"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFrameItemsLine"..i.."Looted"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFrameItemsLine"..i.."Count"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		local text = self:getRegion(_G["RT_DetailFrameItemsLine"..i.."DeleteButton"], 1)
		text:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:skinScrollBar{obj=RT_DetailFrameItems}

	-- RT_DetailFrameRaids SubFrame
	RT_DetailFrameRaidsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:keepFontStrings(RT_DetailFrameRaidsTab1)
	self:applySkin(RT_DetailFrameRaidsTab1)
	self:keepFontStrings(RT_DetailFrameRaidsTabLooter)
	self:applySkin(RT_DetailFrameRaidsTabLooter)
	for i = 1, 11 do
		_G["RT_DetailFrameRaidsLine"..i.."Number"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFrameRaidsLine"..i.."Name"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFrameRaidsLine"..i.."Note"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		local text = self:getRegion(_G["RT_DetailFrameRaidsLine"..i.."DeleteButton"], 1)
		text:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:skinScrollBar{obj=RT_DetailFrameRaids}

	-- RT_DetailFrameEvents SubFrame
	RT_DetailFrameEventsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:keepFontStrings(RT_DetailFrameEventsTab1)
	self:applySkin(RT_DetailFrameEventsTab1)
	self:keepFontStrings(RT_DetailFrameEventsTabBoss)
	self:applySkin(RT_DetailFrameEventsTabBoss)
	for i = 1, 11 do
		_G["RT_DetailFrameEventsLine"..i.."Boss"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFrameEventsLine"..i.."Time"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:skinScrollBar{obj=RT_DetailFrameEvents}

-->>--	RT_ConfirmDeleteFrame
	self:addSkinFrame{obj=RT_ConfirmDeleteFrame, kfs=true, hdr=true}
-->>--	RT_EditNoteFrame
	self:skinEditBox(RT_EditNoteFrameTextBox, {6})
	self:addSkinFrame{obj=RT_EditNoteFrame, kfs=true, hdr=true}
-->>-- RT_AcceptWipeFrame
	self:addSkinFrame{obj=RT_AcceptWipeFrame, kfs=true, hdr=true}
-->>-- RT_ExportFrame
	self:skinEditBox(RT_ExportFrameTextBox, {6})
	self:addSkinFrame{obj=RT_ExportFrame, kfs=true, hdr=true}
-->>-- RT_EditBossFrame
	self:keepFontStrings(RT_EditBossFrameMenu)
	self:addSkinFrame{obj=RT_EditBossFrame, kfs=true, hdr=true}
-->>-- RT_EditCostFrame
	self:skinEditBox(RT_EditCostFrameTextBox, {6})
	self:addSkinFrame{obj=RT_EditCostFrame, kfs=true, hdr=true}
-->>--	RT_JoinLeaveFrame
	self:skinEditBox(RT_JoinLeaveFrameNameEB, {6})
	self:skinEditBox(RT_JoinLeaveFrameNoteEB, {6})
	self:skinEditBox(RT_JoinLeaveFrameTimeEB, {6})
	self:addSkinFrame{obj=RT_JoinLeaveFrame, kfs=true, hdr=true}
-->>--	Options Frame
	self:addSkinFrame{obj=RT_OptionsFrame, kfs=true, hdr=true}
-->>--	Item Options Frame
	self:skinScrollBar{obj=RT_ItemOptionsFrameListScroll}
	self:addSkinFrame{obj=RT_ItemOptionsFrameList, kfs=true}
	self:addSkinFrame{obj=RT_ItemOptionsFrameEdit, kfs=true}
	self:addSkinFrame{obj=RT_ItemOptionsFrame, kfs=true, hdr=true}

end
