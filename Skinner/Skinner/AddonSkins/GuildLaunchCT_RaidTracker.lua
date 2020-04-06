if not Skinner:isAddonEnabled("GuildLaunchCT_RaidTracker") then return end

function Skinner:GuildLaunchCT_RaidTracker()

	-- Option Frame tabs
	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("CT_RaidTracker_OptionsFrame_TabClick",function(...)
			for i = 1, 7 do
				local tabSF = self.skinFrame[_G["CT_RaidTrackerOptionsFrameTab"..i]]
				if i == CT_RaidTrackerOptionsFrame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

-->>-- RaidTracker Frame
	self:keepFontStrings(CT_EmptyRaidTrackerFrame)
	self:skinScrollBar{obj=CT_RaidTrackerListScrollFrame}
	self:addSkinFrame{obj=CT_RaidTrackerFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=48}

	-- Raid Participant Scroll Frame
	CT_RaidTrackerParticipantsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	for i = 1, 3 do
		local tabObj = _G["CT_RaidTrackerTab"..i]
		self:keepFontStrings(tabObj)
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0)
		else
			self:applySkin(tabObj)
		end
	end
	for i = 1, 11 do
		_G["CT_RaidTrackerPlayerLine"..i.."Number"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerLine"..i.."Name"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerLine"..i.."Join"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerLine"..i.."Leave"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerLine"..i.."DeleteText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerLine"..i.."DeleteText"].SetTextColor = function() end
	end
	self:skinScrollBar{obj=CT_RaidTrackerDetailScrollFramePlayers}

	-- Raid Player Scroll Frame
	CT_RaidTrackerPlayerText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinScrollBar{obj=CT_RaidTrackerDetailScrollFramePlayer}
	self:keepFontStrings(CT_RaidTrackerPlayerRaidTab1)
	self:keepFontStrings(CT_RaidTrackerPlayerRaidTabLooter)
	if self.db.profile.TexturedTab then
		self:applySkin(CT_RaidTrackerPlayerRaidTabLooter, nil, 0)
		self:applySkin(CT_RaidTrackerPlayerRaidTab1, nil, 0)
	else
		self:applySkin(CT_RaidTrackerPlayerRaidTab1)
		self:applySkin(CT_RaidTrackerPlayerRaidTabLooter)
	end
	for i = 1, 11 do
		_G["CT_RaidTrackerPlayerRaid"..i.."Number"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerRaid"..i.."Name"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerRaid"..i.."Note"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerRaid"..i.."DeleteText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerPlayerRaid"..i.."DeleteText"].SetTextColor = function() end
	end
	-- Raid Bosses Scroll Frame
	CT_RaidTrackerEventsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinScrollBar{obj=CT_RaidTrackerDetailScrollFrameEvents}
	self:keepFontStrings(CT_RaidTrackerPlayerBossesTab1)
	self:keepFontStrings(CT_RaidTrackerPlayerBossesTabBoss)
	if self.db.profile.TexturedTab then
		self:applySkin(CT_RaidTrackerPlayerBossesTab1, nil, 0)
		self:applySkin(CT_RaidTrackerPlayerBossesTabBoss, nil, 0)
	else
		self:applySkin(CT_RaidTrackerPlayerBossesTab1)
		self:applySkin(CT_RaidTrackerPlayerBossesTabBoss)
	end
	for i = 1, 11 do
		_G["CT_RaidTrackerBosses"..i.."Boss"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerBosses"..i.."Time"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	-- Raid Items Scroll Frame
	CT_RaidTrackerItemsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinDropDown{obj=CT_RaidTrackerRarityDropDown}
	self:skinScrollBar{obj=CT_RaidTrackerDetailScrollFrameItems}
	for i = 1, 4 do
		local tabObj = _G["CT_RaidTrackerItemTab"..i]
		self:keepFontStrings(tabObj)
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0)
		else
			self:applySkin(tabObj)
		end
	end
	for i = 1, 5 do
		_G["CT_RaidTrackerItem"..i.."Description"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerItem"..i.."Looted"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerItem"..i.."Count"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerItem"..i.."DeleteText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["CT_RaidTrackerItem"..i.."DeleteText"].SetTextColor = function() end
	end

	-- other frames
	self:addSkinFrame{obj=CT_RaidTrackerAcceptDeleteFrame, kfs=true, y1=4, y2=4}
	self:skinEditBox{obj=CT_RaidTrackerEditNoteFrameNoteEB, regs={9}, noWidth=true}
	self:addSkinFrame{obj=CT_RaidTrackerEditNoteFrame, kfs=true, y1=4, y2=4}
	self:skinEditBox{obj=URLFrameEditBox, regs={9}, noWidth=true}
	self:addSkinFrame{obj=URLFrame, kfs=true, y1=4, y2=4}
	self:skinEditBox{obj=CT_RaidTrackerJoinLeaveFrameNameEB, regs={6}, noWidth=true}
	self:skinEditBox{obj=CT_RaidTrackerJoinLeaveFrameNoteEB, regs={6}, noWidth=true}
	self:skinEditBox{obj=CT_RaidTrackerJoinLeaveFrameTimeEB, regs={6}, noWidth=true}
	self:addSkinFrame{obj=CT_RaidTrackerJoinLeaveFrame, kfs=true}
	self:addSkinFrame{obj=CT_RaidTrackerAcceptWipeFrame, kfs=true, y1=4, y2=4}
	self:skinDropDown{obj=CT_RaidTrackerNextBossFrameBossDropdown}
	self:addSkinFrame{obj=CT_RaidTrackerNextBossFrame, kfs=true, y1=4, y2=4}
	self:skinEditBox{obj=CT_RaidTrackerEditCostFrameNoteEB, regs={9}, noWidth=true}
	self:addSkinFrame{obj=CT_RaidTrackerEditCostFrame, kfs=true, y1=4, y2=4}

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then CT_RTTooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHook(CT_RTTooltip, "Show", function()
			self:skinTooltip(CT_RTTooltip)
		end)
	end
	
-->>-- Options Frame
	myFrameHeader:SetPoint("TOP", CT_RaidTrackerOptionsFrame, "TOP", 0, 7)
	self:addSkinFrame{obj=CT_RaidTrackerOptionsFrame, kfs=true, y2=-2}
	
	-- Tabs
	for i = 1, 7 do
		local tabName = _G["CT_RaidTrackerOptionsFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabName, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	
-->>-- ItemOptions Frame
	self:skinScrollBar{obj=CT_RaidTracker_ItemOptions_ScrollBar}
	self:addSkinFrame{obj=CT_RaidTracker_ItemOptions_ScrollFrame, kfs=true}
	self:addSkinFrame{obj=CT_RaidTracker_ItemOptions_EditFrame, kfs=true}
	self:addSkinFrame{obj=CT_RaidTrackerItemOptionsFrame, kfs=true, x1=8, y1=-8, x2=-8, y2=8}
	-- hook this to move the title
	self:SecureHookScript(CT_RaidTrackerItemOptionsFrame, "OnShow", function(this)
		self:moveObject{obj=self:getRegion(CT_RaidTrackerItemOptionsFrame, 2), y=-10}
		self:Unhook(CT_RaidTrackerItemOptionsFrame, "OnShow")
	end)
	
end
