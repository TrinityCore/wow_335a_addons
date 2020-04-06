if not Skinner:isAddonEnabled("EnhancedTradeSkills") then return end

function Skinner:EnhancedTradeSkills()
	if not self.db.profile.TradeSkillUI then return end

	self:addSkinFrame{obj=PinkyConfigFrame, hdr=true, y1=4, y2=4}

	if IsAddOnLoaded("FramesResized") then
		self:removeRegions(TradeSkillFrame_MidTextures)
		self:removeRegions(TradeSkillListScrollFrame_MidTextures)
		self:removeRegions(TradeSkillDetailScrollFrame)
		self:moveObject(TradeSkillDetailScrollFrame, "-", 5, nil, nil)
		self:skinScrollBar(TradeSkillDetailScrollFrame)
		self:moveObject(TradeSkillCreateButton, nil, nil, "+", 20)
		self:moveObject(TradeSkillCancelButton, nil, nil, "+", 20)
	end

end

function Skinner:EnhancedTradeCrafts()
	if not self.db.profile.CraftFrame then return end

	if IsAddOnLoaded("FramesResized") then
		self:removeRegions(CraftFrame_MidTextures)
		self:removeRegions(CraftListScrollFrame_MidTextures)
		self:moveObject(CraftCreateButton, nil, nil, "+", 20)
		self:moveObject(CraftCancelButton, nil, nil, "+", 20)
	end

end
