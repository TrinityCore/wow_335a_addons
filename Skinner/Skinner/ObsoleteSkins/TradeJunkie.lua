
function Skinner:TradeJunkie()
	if not self.db.profile.TradeSkillUI and self.db.profile.CraftFrame then return end

	self:moveObject(TJ_OpenButtonTradeSkill, nil, nil, "+", 11)
	self:moveObject(TJ_OpenButtonCraft, nil, nil, "+", 11)
	self:moveObject(TradeJunkieTitle, "+", 50, "-", 4)
	self:keepFontStrings(TradeJunkieMain)
	self:moveObject(TradeJunkieMain_CloseButton, "-", 6, "-", 5)
	self:keepFontStrings(TradeJunkieScrollBar)
	self:skinScrollBar(TradeJunkieScrollBar)
	TradeJunkieScrollBar:ClearAllPoints()
	TradeJunkieScrollBar:SetPoint("TOPLEFT", TradeJunkieMain, "TOPLEFT", 20, -60)
	TradeJunkieScrollBar:SetWidth(284)
	TradeJunkieScrollBar:SetHeight(170)
	self:moveObject(TJHorizontalBarLeftTrade, nil, nil, "-", 40)
	self:applySkin(TradeJunkieMain)

	-- Resize & move the frame if required
	self:SecureHook("TradeJunkie_Attach", function(attachTo)
--		self:Debug("TradeJunkie_Attach: [%s]", attachTo)
		if attachTo == "ATSWFrame" then
			TradeJunkieMain:SetWidth(ATSWFrame:GetWidth() / 2)
			TradeJunkieMain:SetHeight(ATSWFrame:GetHeight())
		elseif attachTo == "SkilletFrame" then
			TradeJunkieMain:SetWidth(SkilletFrame:GetWidth() / 2 + 20)
			TradeJunkieMain:SetHeight(SkilletFrame:GetHeight())
		elseif attachTo == "CraftFrame" then
			TradeJunkieMain:SetWidth(CraftFrame:GetWidth())
			TradeJunkieMain:SetHeight(CraftFrame:GetHeight())
		else
			TradeJunkieMain:SetWidth(TradeSkillFrame:GetWidth())
			TradeJunkieMain:SetHeight(TradeSkillFrame:GetHeight())
		end
		self:moveObject(TradeJunkieMain, "+", 33, "+", 13)
	end)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then TradeJunkieTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(TradeJunkieTooltip)
	end

end
