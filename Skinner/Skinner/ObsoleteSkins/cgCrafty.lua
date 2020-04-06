
function Skinner:cgCrafty()
	if not self.db.profile.TradeSkillUI or self.initialized.cgCrafty then return end
	self.initialized.cgCrafty = true

	self:skinEditBox(self:getChild(cgcFrame, 1), {})
	self:keepRegions(cgcFrame, {})
	self:applySkin(cgcFrame, nil)
	if CraftFrame then
		cgcFrame:SetWidth(CraftFrame:GetWidth())
		self:moveObject(cgcFrame, "+", 5, nil, nil)
	end
	if TradeSkillFrame then
		cgcFrame:SetWidth(TradeSkillFrame:GetWidth())
		self:moveObject(cgcFrame, "+", 1, nil, nil)
	end

	self:SecureHook(cgc, "CRAFT_SHOW", function()
		cgcFrame:SetWidth(CraftFrame:GetWidth())
		self:moveObject(cgcFrame, "+", 5, nil, nil)
	end)
	self:SecureHook(cgc, "TRADE_SKILL_SHOW", function()
		cgcFrame:SetWidth(TradeSkillFrame:GetWidth())
		self:moveObject(cgcFrame, "+", 1, nil, nil)
	end)

end
