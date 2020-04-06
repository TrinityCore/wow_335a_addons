if not Skinner:isAddonEnabled("Armory") then return end

function Skinner:Armory()

-->>--	Main Frame
	-- move portrait down and right
	self:moveObject{obj=ArmoryFramePortrait, x=6, y=-10}
	self:moveObject{obj=ArmoryFramePortraitButton, x=6, y=-10}
	-- move character selection button to top of portrait
	self:moveObject{obj=ArmoryFrameLeftButton, x=-2, y=54}
	self:moveObject{obj=ArmoryFrameRightButton, x=-2, y=54}
	self:addSkinFrame{obj=ArmoryFrame, kfs=true, x1=10, y1=-12, x2=-31, y2=71}
	ArmoryFramePortrait:SetAlpha(1) -- used to delete characters
	self:moveObject{obj=ArmoryBuffFrame, y=-2}

-->>--	Frame Tabs
	for i = 1, ArmoryFrame.numTabs do
		local tabObj = _G["ArmoryFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[ArmoryFrame] = true

-->>--	Frame Line Tabs
	for i = 1, ARMORY_MAX_LINE_TABS do
		local tabName = _G["ArmoryFrameLineTab"..i]
		self:removeRegions(tabName, {1}) -- N.B. region 2 is the icon, 3 is the text
		-- Move the first entry as all the others are positioned from it
		if i == 1 then self:moveObject{obj=tabName, x=-2} end
	end

-->>-- DropDown Menus
	for i = 1, 2 do
		local ddM = "ArmoryDropDownList"..i
		_G[ddM.."Backdrop"]:SetAlpha(0)
		_G[ddM.."MenuBackdrop"]:SetAlpha(0)
		self:addSkinFrame{obj=_G[ddM], kfs=true}
	end

-->>--	PaperDoll Frame
	self:keepFontStrings(ArmoryPaperDollFrame)
	self:addSkinFrame{obj=ArmoryGearSetFrame, kfs=true}
	self:addSkinFrame{obj=ArmoryPaperDollTalentFrame, kfs=true}
	for i = 1, 2 do
		local sBar = "ArmoryPaperDollTradeSkillFrame"..i
		self:glazeStatusBar(_G[sBar.."Bar"])
		self:glazeStatusBar(_G[sBar.."BackgroundBar"])
		_G[sBar.."BackgroundBar"]:SetStatusBarColor(unpack(self.sbColour))
	end
	self:addSkinFrame{obj=ArmoryPaperDollTradeSkillFrame, kfs=true}
	self:glazeStatusBar(ArmoryHealthBar)
	self:glazeStatusBar(ArmoryHealthBackgroundBar)
	self:glazeStatusBar(ArmoryManaBar)
	self:glazeStatusBar(ArmoryManaBackgroundBar)
	self:addSkinFrame{obj=ArmoryHealthFrame, kfs=true, y2=-6}
	self:skinDropDown{obj=ArmoryPlayerStatFrameLeftDropDown}
	self:skinDropDown{obj=ArmoryPlayerStatFrameRightDropDown}
	self:addSkinFrame{obj=ArmoryAttributesFrame, kfs=true, y2=-8}
	self:removeRegions(ArmoryAmmoSlot, {1}) -- remove texture

-->>-- Pet Frame
	self:keepFontStrings(ArmoryPetFrame)
	self:addSkinFrame{obj=ArmoryPetAttributesFrame, kfs=true, x2=1}
	self:skinScrollBar{obj=ArmoryPetTalentFrameScrollFrame}
	for i = 1, ArmoryPetFrame.numTabs do
		local tabObj = _G["ArmoryPetFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=2, y1=2, x2=-2, y2=-4}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[ArmoryPetFrame] = true

-->>--	Talents Frame
	self:keepRegions(ArmoryTalentFrame, {5, 6, 7, 8}) -- N.B. 5-8 are the background pictures
	ArmoryTalentFrameBackgroundBottomLeft:SetHeight(144)
	ArmoryTalentFrameBackgroundBottomRight:SetHeight(144)
	self:skinScrollBar{obj=ArmoryTalentFrameScrollFrame}
	-- Tabs
	for i = 1, ArmoryTalentFrame.numTabs do
		local tabObj = _G["ArmoryTalentFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=2, y1=2, x2=-2, y2=-4}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[ArmoryTalentFrame] = true

-->>--	PVP Frame
	self:keepFontStrings(ArmoryPVPFrame)

-->>--	PVP Team Details Frame
	self:addSkinFrame{obj=ArmoryPVPTeamDetails, kfs=true}

-->>--	Other Frame (parent for the Reputation, Skills, RaidInfo & Currency Frames)
	self:keepFontStrings(ArmoryOtherFrame)
	-- Tabs
	for i = 1, ArmoryOtherFrame.numTabs do
		local tabObj = _G["ArmoryOtherFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=2, y1=2, x2=-2, y2=-4}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[ArmoryOtherFrame] = true

	-- Reputation SubFrame
	self:keepFontStrings(ArmoryReputationFrame)
	self:skinScrollBar{obj=ArmoryReputationListScrollFrame}

	for i = 1, ARMORY_NUM_FACTIONS_DISPLAYED do
		local bar = "ArmoryReputationBar"..i
		self:skinButton{obj=_G[bar.."ExpandOrCollapseButton"], mp=true, ty=0} -- treat as just a texture
		_G[bar.."ReputationBarLeftTexture"]:SetAlpha(0)
		_G[bar.."ReputationBarRightTexture"]:SetAlpha(0)
		 _G[bar.."Background"]:SetAlpha(0)
		self:glazeStatusBar(_G[bar.."ReputationBar"], 0)
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryReputationFrame_Update", function()
			for i = 1, ARMORY_NUM_FACTIONS_DISPLAYED do
				self:checkTex(_G["ArmoryReputationBar"..i.."ExpandOrCollapseButton"])
			end
		end)
	end

	--	Skills SubFrame
	self:keepFontStrings(ArmorySkillFrame)
	self:skinScrollBar{obj=ArmorySkillListScrollFrame}

	for i = 1, ARMORY_NUM_SKILLS_DISPLAYED do
		local bar = "ArmorySkillRankFrame"..i
		self:removeRegions(_G[bar.."Border"], {1}) -- N.B. region 2 is highlight
		self:glazeStatusBar(_G[bar], 0, _G[bar.."Background"], {_G[bar.."FillBar"]})
		self:skinButton{obj=_G["ArmorySkillTypeLabel"..i], mp=true}
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmorySkillFrame_UpdateSkills", function()
			for i = 1, ARMORY_NUM_SKILLS_DISPLAYED do
				self:checkTex(_G["ArmorySkillTypeLabel"..i])
			end
		end)
	end

	--	RaidInfo SubFrame
	self:keepFontStrings(ArmoryRaidInfoFrame)
	self:skinScrollBar{obj=ArmoryRaidInfoScrollFrame}

	-- Currency SubFrame
	self:keepFontStrings(ArmoryTokenFrame)
	self:skinSlider(ArmoryTokenFrameContainerScrollBar)
	-- remove header textures
	for i = 1, #TokenFrameContainer.buttons do
		ArmoryTokenFrameContainer.buttons[i].categoryLeft:SetAlpha(0)
		ArmoryTokenFrameContainer.buttons[i].categoryRight:SetAlpha(0)
	end

-->>--	Inventory Frame
	self:keepFontStrings(ArmoryInventoryMoneyBackgroundFrame)
	self:skinEditBox(ArmoryInventoryFrameEditBox, {9})
	self:keepFontStrings(ArmoryInventoryExpandButtonFrame)
	self:skinButton{obj=ArmoryInventoryCollapseAllButton, mp=true}
	self:addSkinFrame{obj=ArmoryInventoryFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}
	-- Tabs
	for i = 1, ArmoryInventoryFrame.numTabs do
		local tabObj = _G["ArmoryInventoryFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=1, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[ArmoryInventoryFrame] = true

	-- Icon View SubFrame
	self:skinScrollBar{obj=ArmoryInventoryIconViewFrame}
	-- m/p buttons
	for i = 1, 19 do
		self:skinButton{obj=_G["ArmoryInventoryContainer"..i.."Label"], mp=true}
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryInventoryIconViewFrame_Update", function()
			for i = 1, 19 do
				self:checkTex(_G["ArmoryInventoryContainer"..i.."Label"])
			end
		end)
	end
	-- List View SubFrame
	self:skinScrollBar{obj=ArmoryInventoryListViewScrollFrame}
	-- m/p buttons
	for i = 1, ARMORY_INVENTORY_LINES_DISPLAYED do
		self:skinButton{obj=_G["ArmoryInventoryLine"..i], mp=true}
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryInventoryListViewFrame_Update", function()
			for i = 1, ARMORY_INVENTORY_LINES_DISPLAYED do
				local btn = _G["ArmoryInventoryLine"..i]
				self:checkTex(btn)
				if not self.sBut[btn]:IsShown() then -- not a header line
					btn:GetNormalTexture():SetAlpha(1) -- show item icon
				end
			end
		end)
	end
	-- GuildBank SubFrame
	if IsAddOnLoaded("ArmoryGuildBank") and AGB:GetConfigIntegrate() then
		self:skinScrollBar{obj=ArmoryInventoryGuildBankScrollFrame}
		-- m/p buttons
		for i = 1, ARMORY_INVENTORY_LINES_DISPLAYED do
			self:skinButton{obj=_G["ArmoryInventoryGuildBankLine"..i], mp=true}
		end
		if self.modBtns then
			-- hook to manage changes to button textures
			self:SecureHook("ArmoryInventoryGuildBankFrame_Update", function()
				for i = 1, ARMORY_INVENTORY_LINES_DISPLAYED do
					local btn = _G["ArmoryInventoryGuildBankLine"..i]
					self:checkTex(btn)
					if not self.sBut[btn]:IsShown() then -- not a header line
						btn:GetNormalTexture():SetAlpha(1) -- show item icon
					end
				end
			end)
		end
	end

-->>--	QuestLog
	self:SecureHook("ArmoryQuestInfo_Display", function(...)
		-- headers
		ArmoryQuestInfoTitleHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		ArmoryQuestInfoDescriptionHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		ArmoryQuestInfoObjectivesHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		ArmoryQuestInfoRewardsHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		-- other text
		ArmoryQuestInfoDescriptionText:SetTextColor(self.BTr, self.BTg, self.BTb)
		ArmoryQuestInfoObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
		ArmoryQuestInfoGroupSize:SetTextColor(self.BTr, self.BTg, self.BTb)
		ArmoryQuestInfoRewardText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- reward frame text
		ArmoryQuestInfoItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoSpellLearnText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoHonorFrameReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoArenaPointsFrameReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoTalentFrameReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoXPFrameReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoReputationText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- reputation rewards
		for i = 1, ARMORY_MAX_REPUTATIONS do
			_G["ArmoryQuestInfoReputation"..i.."Faction"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		local r, g, b = ArmoryQuestInfoRequiredMoneyText:GetTextColor()
		ArmoryQuestInfoRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		-- objectives
		for i = 1, ARMORY_MAX_OBJECTIVES do
			local r, g, b = _G["ArmoryQuestInfoObjective"..i]:GetTextColor()
			_G["ArmoryQuestInfoObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		end
	end)

	ArmoryQuestInfoTimerText:SetTextColor(self.BTr, self.BTg, self.BTb)
	ArmoryQuestInfoAnchor:SetTextColor(self.BTr, self.BTg, self.BTb)

	self:skinEditBox{obj=ArmoryQuestLogFrameEditBox, regs={9}}
	self:removeRegions(ArmoryQuestLogCollapseAllButton, {5, 6, 7})
	self:skinButton{obj=ArmoryQuestLogCollapseAllButton, mp=true}
	self:keepFontStrings(ArmoryEmptyQuestLogFrame)
	-- m/p buttons
	for i = 1, ARMORY_QUESTS_DISPLAYED do
		self:skinButton{obj=_G["ArmoryQuestLogTitle"..i], mp=true}
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryQuestLog_Update", function()
			for i = 1, ARMORY_QUESTS_DISPLAYED do
				self:checkTex(_G["ArmoryQuestLogTitle"..i])
			end
		end)
	end
	self:skinScrollBar{obj=ArmoryQuestLogListScrollFrame}
	self:skinScrollBar{obj=ArmoryQuestLogDetailScrollFrame}
	self:addSkinFrame{obj=ArmoryQuestLogFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=52}

	for i = 1, ARMORY_MAX_NUM_ITEMS do
		_G["ArmoryQuestInfoItem"..i.."NameFrame"]:SetTexture(nil)
	end

-->>--	Spellbook
	self:addSkinFrame{obj=ArmorySpellBookFrame, kfs=true, x1=10, y1=-12, x2=-31, y2=71}

	self:SecureHook("ArmorySpellBookFrame_Update", function(showing)
		if ArmorySpellBookFrame.bookType ~= INSCRIPTION then
			ArmorySpellBookTitleText:Show()
		else
			ArmorySpellBookTitleText:Hide() -- hide Inscriptions title
		end
	end)

	for i = 1, SPELLS_PER_PAGE do
		_G["ArmorySpellButton"..i.."Background"]:SetAlpha(0)
		_G["ArmorySpellButton"..i.."SpellName"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G["ArmorySpellButton"..i.."SubSpellName"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end

	-- Tabs (bottom)
	for i = 1, 3 do
		local tabObj = _G["ArmorySpellBookFrameTabButton"..i]
		self:keepRegions(tabObj, {1, 3}) -- N.B. region 1 is text, 3 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=14, y1=-16, x2=-10, y2=18}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ArmoryToggleSpellBook", function(bookType)
			for i = 1, 3 do
				local tabName = _G["ArmorySpellBookFrameTabButton"..i]
				local tabSF = self.skinFrame[tabName]
				if tabName.bookType == bookType then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	-- Tabs (side)
	for i = 1, MAX_SKILLLINE_TABS do
		self:removeRegions(_G["ArmorySpellBookSkillLineTab"..i], {1}) -- N.B. other regions are icon and highlight
	end
	-- Glyphs SubFrame
	self:removeRegions(ArmoryGlyphFrame, {1, 2}) -- icon and background

-->>-- Achievements
	self:skinEditBox(ArmoryAchievementFrameEditBox, {9})
	self:skinScrollBar{obj=ArmoryAchievementListScrollFrame}
	self:addSkinFrame{obj=ArmoryAchievementFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=71}

	for i = 1, ARMORY_NUM_FACTIONS_DISPLAYED do
		local bar = "ArmoryAchievementBar"..i
		_G[bar.."Background"]:SetAlpha(0)
		_G[bar.."AchievementBarLeftTexture"]:SetAlpha(0)
		_G[bar.."AchievementBarRightTexture"]:SetAlpha(0)
		self:glazeStatusBar(_G[bar.."AchievementBar"], 0)
		self:skinButton{obj=_G[bar.."ExpandOrCollapseButton"], mp=true} -- treat as just a texture
	end
	-- collapse all button
	self:removeRegions(ArmoryAchievementCollapseAllButton, {1, 2, 3}) -- textures
	self:skinButton{obj=ArmoryAchievementCollapseAllButton, mp=true} -- treat as just a texture
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryAchievementFrame_Update", function()
			for i = 1, ARMORY_NUM_FACTIONS_DISPLAYED do
				self:checkTex(_G["ArmoryAchievementBar"..i.."ExpandOrCollapseButton"])
			end
			self:checkTex(ArmoryAchievementCollapseAllButton)
		end)
	end

	-- hook this to manage displaying the rows
	self:SecureHook("ArmoryAchievementFrame_SetRowType", function(achievementRow, rowType, hasQuantity)
		local achievementRowName = achievementRow:GetName()
		local sBar = _G[achievementRowName.."AchievementBar"]
		if sBar:GetValue() == 0 then
			self.sbGlazed[sBar].bg:Hide()
		else
			self.sbGlazed[sBar].bg:Show()
		end
	end)

	-- Tabs
	for i = 1, ArmoryAchievementFrame.numTabs do
		local tabObj = _G["ArmoryAchievementFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[ArmoryAchievementFrame] = true

-->>-- Social Frame
	self:skinFFToggleTabs("ArmorySocialFrameTab", 3, true)
	self:addSkinFrame{obj=ArmorySocialFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=71}
	-- Friends SubFrame
	self:skinScrollBar{obj=ArmoryFriendsListScrollFrame}
	-- Ignore SubFrame
	self:skinScrollBar{obj=ArmoryIgnoreListScrollFrame}
	-- Events SubFrame
	self:skinScrollBar{obj=ArmoryEventsListScrollFrame}

-->>--	Tradeskills
	self:removeRegions(ArmoryTradeSkillRankFrameBorder, {1}) -- N.B. region 2 is bar texture
	self:glazeStatusBar(ArmoryTradeSkillRankFrame, 0)
	self:skinEditBox(ArmoryTradeSkillFrameEditBox, {9})
	self:moveObject{obj=ArmoryTradeSkillFrameEditBox, y=2}
	self:removeRegions(ArmoryTradeSkillExpandButtonFrame)
	self:skinDropDown{obj=ArmoryTradeSkillSubClassDropDown}
	self:skinDropDown{obj=ArmoryTradeSkillInvSlotDropDown}
	self:skinScrollBar{obj=ArmoryTradeSkillListScrollFrame}
	self:skinScrollBar{obj=ArmoryTradeSkillDetailScrollFrame}
	self:keepFontStrings(ArmoryTradeSkillDetailScrollChildFrame)
	self:addSkinFrame{obj=ArmoryTradeSkillFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}
	for i = 1, ARMORY_TRADE_SKILLS_DISPLAYED do
		self:skinButton{obj=_G["ArmoryTradeSkillSkill"..i], mp=true}
	end
	-- collapse all button
--	self:removeRegions(ArmoryTradeSkillCollapseAllButton, {1, 2, 3}) -- textures
	self:skinButton{obj=ArmoryTradeSkillCollapseAllButton, mp=true} -- treat as just a texture
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryTradeSkillFrame_Update", function()
			for i = 1, ARMORY_TRADE_SKILLS_DISPLAYED do
				self:checkTex(_G["ArmoryTradeSkillSkill"..i])
			end
			self:checkTex(ArmoryTradeSkillCollapseAllButton)
		end)
	end
	for i = 1, ARMORY_MAX_TRADE_SKILL_REAGENTS do
		_G["ArmoryTradeSkillReagent"..i.."NameFrame"]:SetTexture(nil)
	end

end

function Skinner:ArmoryGuildBank()

	if AGB:GetConfigIntegrate() then return end

	self:keepFontStrings(ArmoryGuildBankMoneyBackgroundFrame)
	self:skinEditBox{obj=ArmoryGuildBankFrameEditBox, regs={9}}
	self:skinDropDown{obj=ArmoryGuildBankFilterDropDown}
	self:skinDropDown{obj=ArmoryGuildBankNameDropDown}
	self:skinScrollBar{obj=ArmoryGuildBankScrollFrame}
	self:skinButton{obj=ArmoryGuildBankFrameCloseButton, cb=true, tx=0}
	self:removeRegions(ArmoryGuildBankFrame, {10, 11, 12, 13}) -- remove frame textures
	self:addSkinFrame{obj=ArmoryGuildBankFrame, bg=true, x1=6, y1=-11, x2=-32, y2=71}
	-- move portrait and delete button
	self:moveObject{obj=ArmoryGuildBankFramePortrait, x=3, y=-10}
	self:moveObject{obj=ArmoryGuildBankFrameDeleteButton, x=3, y=-10}
	-- make portrait square and same size as guild tabard texture(s)
	ArmoryGuildBankFramePortrait:SetTexCoord(0.2, 0.8, 0.2, 0.8)
	ArmoryGuildBankFramePortrait:SetWidth(54)
	ArmoryGuildBankFramePortrait:SetHeight(52)

end
