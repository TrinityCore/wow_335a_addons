
function Skinner:Auctioneer()
	if not self.db.profile.AuctionFrame or self.initialized.Auctioneer then return end
--	self:Debug("Auctioneer Loaded: [%s]", AuctionFrame.numTabs)

	if AuctionFrame.numTabs < 5  then
		self:ScheduleEvent(self.Auctioneer, 0.1, self)
		return
	end

	self.initialized.Auctioneer= true

	for _, tabName in pairs({AuctionFrameTabSearch, AuctionFrameTabPost}) do
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0)
			self:setInactiveTab(tabName)
		else
			self:applySkin(tabName)
		end
		if IsAddOnLoaded("IgorsMassAuction") then self:moveObject(tabName, "+", 3, nil, nil) end
	end

-->>--	Search Frame
	for _, v in pairs({"SavedSearch", "Search", "BidTimeLeft", "BidCategory", "BidMinQuality", "BuyoutCategory", "BuyoutMinQuality", "PlainCategory", "PlainMinQuality", "ListColumn1", "ListColumn2", "ListColumn3", "ListColumn4", "ListColumn5", "ListColumn6"}) do
		self:keepFontStrings(_G["AuctionFrameSearch"..v.."DropDown"])
	end

	self:moveObject(AuctionFrameSearchSavedSearchDropDownButton, "+", 2, nil, nil)

	for i = 1, 6 do
		local afslc = _G["AuctionFrameSearchListColumn"..i.."Sort"]
		self:keepRegions(afslc, {4, 5, 6}) -- N.B. region 4 is text, 5 is the arrow, 6 is the highlight
		self:applySkin(afslc)
	end

	self:keepFontStrings(AuctionFrameSearchListScrollFrame)
	self:skinScrollBar(AuctionFrameSearchListScrollFrame)

	self:skinMoneyFrame(AuctionFrameSearchBidMinProfit, true)
	self:skinMoneyFrame(AuctionFrameSearchBuyoutMinProfit, true)
	self:skinMoneyFrame(AuctionFrameSearchCompeteUndercut, true)
	self:skinMoneyFrame(AuctionFrameSearchPlainMaxPrice, true)

	self:skinEditBox(AuctionFrameSearchSaveSearchEdit, {9})
	self:moveObject(AuctionFrameSearchBidMinPercentLessEdit, nil, nil, "+", 4)
	self:skinEditBox(AuctionFrameSearchBidMinBidPctEdit, {9})
	self:skinEditBox(AuctionFrameSearchBidMinPercentLessEdit, {9})
	self:moveObject(AuctionFrameSearchBidSearchEdit, "-", 5, "+", 4)
	self:skinEditBox(AuctionFrameSearchBidSearchEdit, {9})
	self:moveObject(AuctionFrameSearchBuyoutMinPercentLessEdit, nil, nil, "+", 4)
	self:skinEditBox(AuctionFrameSearchBuyoutMinPercentLessEdit, {9})
	self:moveObject(AuctionFrameSearchBuyoutSearchEdit, "-", 5, "+", 4)
	self:skinEditBox(AuctionFrameSearchBuyoutSearchEdit, {9})
	self:moveObject(AuctionFrameSearchPlainSearchEdit, "-", 5, "+", 4)
	self:skinEditBox(AuctionFrameSearchPlainSearchEdit, {9})

-->>--	Post Frame
	self:removeRegions(AuctionFramePostAuctionItem, {1}) -- N.B. all other regions are text or icon texture
	self:applySkin(AuctionFramePostAuctionItem)

	for _, v in pairs({"PriceModel", "ListColumn1", "ListColumn2", "ListColumn3", "ListColumn4", "ListColumn5", "ListColumn6"}) do
		self:keepFontStrings(_G["AuctionFramePost"..v.."DropDown"])
	end

	for i = 1, 6 do
		local afplc = _G["AuctionFramePostListColumn"..i.."Sort"]
		self:keepRegions(afplc, {4, 5, 6}) -- N.B. region 4 is text, 5 is the arrow, 6 is the highlight
		self:applySkin(afplc)
	end

	self:keepFontStrings(AuctionFramePostListScrollFrame)
	self:skinScrollBar(AuctionFramePostListScrollFrame)

	self:moveObject(AuctionFramePostStartPrice, "-", 5, "+", 5)
	self:skinMoneyFrame(AuctionFramePostStartPrice, true)
	self:moveObject(AuctionFramePostBuyoutPrice, "-", 5, "+", 5)
	self:skinMoneyFrame(AuctionFramePostBuyoutPrice, true)

	self:moveObject(AuctionFramePostStackSize, "-", 5, "+", 5)
	self:skinEditBox(AuctionFramePostStackSize, {9})
	self:skinEditBox(AuctionFramePostStackCount, {9})
	AuctionFramePostStackCount:SetWidth(AuctionFramePostStackCount:GetWidth() + 5)
	self:moveObject(AuctionFramePostStackCount, "-", 8, nil, nil)

end
