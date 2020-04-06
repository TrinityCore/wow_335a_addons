if not Skinner:isAddonEnabled("FramesResized") then return end

function Skinner:FramesResized()

	if self.db.profile.LootFrame and LootFrame_MidTextures then
		local title = LootFrame_MidTextures:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		title:SetText(self:getRegion(LootFrame, 3):GetText())
		title:SetPoint("CENTER", -24, 150)
		self:addSkinFrame{obj=LootFrame_MidTextures, kfs=true, x1=8, y1=-47, x2=-68}
	end

	if self.db.profile.QuestLog and QuestLogFrame_MidTextures then
		self:removeRegions(QuestLogFrame_MidTextures)
	end

	-- move & resize the resized RaidInfo frame ;-)
	if FramesResized_SV.RaidInfo_Resize then
		self:moveObject{obj=RaidInfoFrame, x=GetNumRaidMembers() > 0 and 20 or 0, y=17}
		RaidInfoFrame.SetPoint = function() end
		RaidInfoFrame:SetHeight(250 + 158 + 22)
		RaidInfoScrollFrame:SetHeight(158 + 158 + 22)
	end

-->>-- Options panel
	self:addSkinFrame{obj=FramesResizedPanel_LootFrame_Box, x1=1, y1=-1, x2=-1, y2=1}
	self:addSkinFrame{obj=FramesResizedPanel_RaidInfo_Box, x1=1, y1=-1, x2=-1, y2=1}
	self:addSkinFrame{obj=FramesResizedPanel_TraidSkillUI_Box, x1=1, y1=-1, x2=-1, y2=1}
	self:addSkinFrame{obj=FramesResizedPanel_TrainerUI_Box, x1=1, y1=-1, x2=-1, y2=1}
	
	if IsAddOnLoaded("Blizzard_TradeSkillUI") then self:FR_TradeSkillUI() end
	if IsAddOnLoaded("Blizzard_TrainerUI") then self:FR_TrainerUI() end

end

function Skinner:FR_TradeSkillUI()

	if self.db.profile.TradeSkillUI and TradeSkillFrame_MidTextures then
		self:removeRegions(TradeSkillFrame_MidTextures)
		self:removeRegions(TradeSkillListScrollFrame_MidTextures)
	end

end

function Skinner:FR_TrainerUI()

	if self.db.profile.TrainerUI and ClassTrainerFrame_MidTextures then
		self:removeRegions(ClassTrainerFrame_MidTextures)
		self:removeRegions(ClassTrainerListScrollFrame_MidTextures)
	end

end
