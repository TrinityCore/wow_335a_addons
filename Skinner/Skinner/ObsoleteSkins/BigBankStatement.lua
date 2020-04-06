
function Skinner:BigBankStatement()

	local bbs_df = BigBankStatement_DisplayFrame
	self:keepFontStrings(bbs_df)
	bbs_df:SetWidth(bbs_df:GetWidth() * self.FxMult)
	bbs_df:SetHeight(bbs_df:GetHeight() * self.FyMult)
	self:moveObject(BigBankStatement_CloseButton, "+", 22, "+", 8)
	self:moveObject(self:getRegion(bbs_df, 3), nil, nil, "-", 32)
	self:moveObject(self:getRegion(bbs_df, 4), nil, nil, "-", 36)
	self:moveObject(self:getRegion(bbs_df, 5), nil, nil, "-", 36)
	self:moveObject(BigBankStatement_HelpText, nil, nil, "-", 32)
	self:moveObject(BigBankStatement_Item1, "-", 12, nil, nil)
	self:moveObject(BigBankStatement_WebsiteText, nil, nil, "-", 40)
	self:moveObject(BigBankStatement_VersionText, nil, nil, "-", 40)
	self:keepFontStrings(BigBankStatement_ServerDropDown)
	self:keepFontStrings(BigBankStatement_PlayerDropDown)
	self:moveObject(BigBankStatement_TotalMoneyFrame, nil, nil, "-", 70)
	self:applySkin(bbs_df)

	for i = 0, 11 do
		local cb = _G["BigBankStatement_ContainerFrame"..i]
		self:keepFontStrings(cb)
		self:applySkin(cb)
	end

end
