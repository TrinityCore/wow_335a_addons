if not Skinner:isAddonEnabled("AuctionLite") then return end

function Skinner:AuctionLite()

-->>-- Buy frame
	self:skinEditBox{obj=BuyName, regs={9}}
	self:skinEditBox{obj=BuyQuantity, regs={9}}
	self:skinDropDown{obj=BuyAdvancedDropDown}
	self:skinScrollBar{obj=BuyScrollFrame}

-->>-- Sell frame
	self:skinScrollBar{obj=SellScrollFrame}
	self:skinDropDown{obj=SellRememberDropDown}
	self:addSkinButton{obj=SellItemButton, parent=SellItemButton}
	self:skinEditBox{obj=SellStacks, regs={9}}
	self:skinEditBox{obj=SellSize, regs={9}}
	self:skinMoneyFrame{obj=SellBidPrice}
	self:skinMoneyFrame{obj=SellBuyoutPrice}

end
