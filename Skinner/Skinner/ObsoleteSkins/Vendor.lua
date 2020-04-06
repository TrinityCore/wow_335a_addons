
function Skinner:Vendor()
	if not self.db.profile.AuctionUI then return end

-->>--	Buttons
	self:moveObject(self:getChild(AuctionFrame, 9), "-", 20, "+", 8)

-->>--	Scan Dialog
	local scanDialog = vendor.Scanner.scanDialog
	self:applySkin(scanDialog.frame)

-->>--	Snipe Create Dialog
	local sniperDialog = vendor.Sniper.snipeCreateDialog
	self:skinEditBox(sniperDialog.itemName, {9}, nil, true)
	self:skinMoneyFrame(sniperDialog.bid)
	self:moveObject(sniperDialog.bid, "-", 30, nil, nil, sniperDialog.itemName)
	self:skinMoneyFrame(sniperDialog.buyout)
	self:applySkin(sniperDialog.frame)

-->>--	Seller Frame
	local sellerObj = vendor.Seller
	self:moveObject(self:getRegion(sellerObj.frame, 1), nil, nil, "+", 6)
	self:applySkin(sellerObj.itemBut)
	self:skinDropDown(sellerObj.stackDropDown.button)
	self:skinDropDown(sellerObj.countDropDown.button)
	self:skinDropDown(sellerObj.prizingDropDown.button)
	self:skinDropDown(sellerObj.bidTypeDropDown.button)
	self:skinMoneyFrame(sellerObj.startPriceBut)
	self:moveObject(sellerObj.startPriceBut, nil, nil, "+", 3)
	self:skinMoneyFrame(sellerObj.buyoutPriceBut)
--	.frame

-->>--	Scan Result Frame
	local srf = vendor.Seller.scanResultFrame
	self:removeRegions(srf.browseScroll)
	self:skinScrollBar(srf.browseScroll)
	for _, v in pairs({ "NameSort", "CountSort", "OwnerSort", "BidSort", "BuyoutSort" }) do
		local but = _G["SalesScanResultFrame"..v]
		self:keepRegions(but, {4, 5, 6}) -- N.B. region 4 is text, 5 is arrow, 6 is highlight
		self:applySkin(but)
	end

-->>--	Tab
	local tabName = vendor.Seller.vendorTabButton
	self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
	else self:applySkin(tabName) end
	self:moveObject(tabName, "+", 3, nil, nil)
	if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end

	if self.db.profile.TexturedTab then
		self:RawHookScript(tabName, "OnClick", function(this)
			self.hooks[this].OnClick(this)
			for i = 1, AuctionFrame.numTabs do
				local tabName = _G["AuctionFrameTab"..i]
				if i == AuctionFrame.selectedTab then
					self:setActiveTab(tabName)
				else
					self:setInactiveTab(tabName)
				end
			end
		end)
	end

end
