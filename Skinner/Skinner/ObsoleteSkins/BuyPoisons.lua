
function Skinner:BuyPoisons()
	if not self.db.profile.MerchantFrames then return end

	self:keepRegions(BuyPoisonsFrame, {6, 7, 8}) -- N.B. regions 6-8 are text

	BuyPoisonsFrame:SetWidth(BuyPoisonsFrame:GetWidth() * self.FxMult)
	BuyPoisonsFrame:SetHeight(BuyPoisonsFrame:GetHeight() * self.FyMult)

	self:moveObject(BuyPoisonsVersionText, nil, nil, "+", 6)
	self:moveObject(BuyPoisonsFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(BuyPoisonsItem1, "-", 6, "+", 30)
	self:moveObject(BuyPoisonsPageText, "+", 12, "-", 59)
	self:moveObject(BuyPoisonsPrevPageButton, "-", 5, "-", 60)
	self:moveObject(BuyPoisonsNextPageButton, "-", 5, "-", 60)
	self:moveObject(BuyPoisonsMoneyFrame, "+", 30, "-", 58)

	self:applySkin(BuyPoisonsFrame)

end
