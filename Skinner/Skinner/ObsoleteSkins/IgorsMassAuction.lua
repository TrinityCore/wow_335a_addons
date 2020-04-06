
function Skinner:IgorsMassAuction()
	if not self.db.profile.AuctionUI then return end

-->>--	Mass Auction Frame
	IMA_AuctionFrameMassAuction:SetWidth(IMA_AuctionFrameMassAuction:GetWidth() + 74)
	IMA_AuctionFrameMassAuction:SetHeight(IMA_AuctionFrameMassAuction:GetHeight() - 6)
	self:moveObject(IMA_AuctionsCloseButton, "-", 74, "-", 6)
	self:moveObject(IMA_SetAllPricesButton, "-", 50, nil, nil)
	self:skinDropDown(IMA_PriceSchemeDropDown)

-->>--	Multiplier frame
	self:moveObject(IMA_MultiplierFramePriceCheckButton, nil, nil, "+", 1)
	self:moveObject(IMA_MultiplierFrameBuyoutCheckButton, nil, nil, "-", 1)
	self:skinEditBox(IMA_MultiplierFramePriceMultiplier, {6, 7}, nil, true)
	self:moveObject(IMA_MultiplierFramePriceMultiplier, "-", 10, nil, nil)
	self:moveObject(self:getRegion(IMA_MultiplierFramePriceMultiplier, 6), "+", 8, nil, nil)
	self:moveObject(self:getRegion(IMA_MultiplierFramePriceMultiplier, 7), "+", 10, nil, nil)
	self:skinEditBox(IMA_MultiplierFrameBuyoutMultiplier, {6, 7}, nil, true)
	self:moveObject(IMA_MultiplierFrameBuyoutMultiplier, "-", 10, nil, nil)
	self:moveObject(self:getRegion(IMA_MultiplierFrameBuyoutMultiplier, 6), "+", 8, nil, nil)
	self:moveObject(self:getRegion(IMA_MultiplierFrameBuyoutMultiplier, 7), "+", 10, nil, nil)

-->>-- All Same Price frame
	self:skinMoneyFrame(IMA_AllSamePriceFrameStartPrice, nil, true)
	self:moveObject(IMA_AllSamePriceFrameStartPriceGold, "-", 10, "+", 3)
	self:moveObject(IMA_AllSamePriceFrameStartPriceSilver, "-", 10, nil, nil)
	self:skinMoneyFrame(IMA_AllSamePriceFrameBuyoutPrice, nil, true)
	self:moveObject(IMA_AllSamePriceFrameBuyoutPriceGold, "-", 10, "+", 3)
	self:moveObject(IMA_AllSamePriceFrameBuyoutPriceSilver, "-", 10, nil, nil)
	self:skinEditBox(IMA_AllSamePriceFrameStackSize, {6, 7}, nil, true)
	IMA_AllSamePriceFrameStackSize:SetHeight(24)
	self:moveObject(IMA_AllSamePriceFrameStackSize, "-", 10, nil, nil)
	self:moveObject(self:getRegion(IMA_AllSamePriceFrameStackSize, 6), "+", 8, nil, nil)
	self:moveObject(self:getRegion(IMA_AllSamePriceFrameStackSize, 7), "+", 10, nil, nil)

-->>--	Items
	for i = 1, 18 do
		local but = _G["IMA_Item"..i.."ItemButton"]
		self:getRegion(but, 1):SetAlpha(0)
		self:applySkin(but)
		local mfsp  = _G["IMA_Item"..i.."StartPrice"]
		local mfbp  = _G["IMA_Item"..i.."BuyoutPrice"]
		self:skinMoneyFrame(mfsp)
		self:skinMoneyFrame(mfbp)
		self:moveObject(_G["IMA_Item"..i.."StartPriceSilver"], "-", 10, nil, nil)
		self:moveObject(_G["IMA_Item"..i.."BuyoutPriceSilver"], "-", 10, nil, nil)
	end

-->>--	Tab
	local tabName = AuctionFrameTab4
	if self.db.profile.TexturedTab then
		self:applySkin(tabName, nil, 0)
		self:setInactiveTab(tabName)
	else
		self:applySkin(tabName)
	end

-->>--	Send Frame
	self:keepFontStrings(IMA_AcceptSendFrame)
	self:applySkin(IMA_AcceptSendFrame, true)

end
