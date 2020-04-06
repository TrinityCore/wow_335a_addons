
function Skinner:BtmScan()
	if not self.db.profile.AuctionUI then return end
--	self:Debug("BtmScan Loaded: [%s]", AuctionFrame.numTabs)

	-- loop until tab button created
	if not AuctionFrameTabBtmScan then
		self:ScheduleTimer("BtmScan", 0.1)
		return
	end

	self:RawHookScript(AuctionFrameTabBtmScan, "OnClick", function()
--		self:Debug("AuctionFrameTabBtmScan-OnClick")
		self.hooks[AuctionFrameTabBtmScan].OnClick()
		self:moveObject(BtmScanLogFrame:GetParent(), "-", 10, nil, nil)
	end)

-->>--	Prompt & Input Frames
	self:applySkin(BtmScan.Prompt)
	self:keepFontStrings(BtmScanInputScroll)
	self:skinScrollBar(BtmScanInputScroll)
	self:applySkin(BtmScan.Input)

	self:keepFontStrings(BtmScanLogFrame)
	self:skinScrollBar(BtmScanLogFrame)
	BtmScanLogFrame:GetParent():SetWidth(BtmScanLogFrame:GetParent():GetWidth() + 10)
	self:applySkin(BtmScanLogFrame:GetParent())

	self:keepRegions(AuctionFrameTabBtmScan, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	self:moveObject(AuctionFrameTabBtmScan, "+", 3, nil, nil)
	if AuctionFrameTabTransactions then self:moveObject(AuctionFrameTabTransactions, "+", 3, nil, nil) end
	if self.db.profile.TexturedTab then
		self:applySkin(AuctionFrameTabBtmScan, nil, 0)
		self:setInactiveTab(AuctionFrameTabBtmScan)
	else
		self:applySkin(AuctionFrameTabBtmScan)
	end

end
