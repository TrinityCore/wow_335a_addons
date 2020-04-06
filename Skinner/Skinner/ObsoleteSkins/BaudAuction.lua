
function Skinner:BaudAuction()
	if not self.db.profile.AuctionUI then return end

	for i = 1, 7 do
		local ch = _G["BaudAuctionFrameCol"..i]
		self:keepFontStrings(ch)
		self:applySkin(ch)
	end

	self:keepFontStrings(BaudAuctionBrowseScrollBoxScrollBar)
	self:skinScrollBar(BaudAuctionBrowseScrollBoxScrollBar)
	BaudAuctionProgressBarBorder:Hide()
	self:glazeStatusBar(BaudAuctionProgressBar, 0)
	self:applySkin(BaudAuctionProgress)

	self:skinMoneyFrame(BaudAuctionUnitPrice)
	self:moveObject(self:getRegion(BaudAuctionUnitPrice, 1), nil, nil, "-", 2)

end
