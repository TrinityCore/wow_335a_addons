if not Skinner:isAddonEnabled("MailTo") then return end

function Skinner:MailTo()
	if not self.db.profile.MailFrame then return end

	self:keepRegions(MailToDropDownMenu, {4,5}) -- N.B. regions 4 & 5 are text
	self:moveObject(MailToDropDownMenu, "+", 12, nil, nil)

	self:moveObject(SendMailMoney, "-", 15, nil, nil)

-->>--	In Frame
	self:keepRegions(MailTo_InFrame, {6})
	MailTo_InFrame:SetWidth(MailTo_InFrame:GetWidth() * self.FxMult)
	MailTo_InFrame:SetHeight(MailTo_InFrame:GetHeight() * self.FyMult)
	self:moveObject(MailTo_InFrameTitleText, nil, nil, "-", 30)
	self:moveObject(MailTo_InFrameCloseButton, "+", 28, "+", 8)
	self:keepRegions(MailTo_InFrame_DropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:moveObject(MailTo_InFrame_DropDown, nil, nil, "+", 10)
--	self:moveObject(MailTo_InFrameServerButton, "+", 80, "+", 10)
	self:moveObject(MailTo_InFrameCol1, "-", 10, "+", 10)
	self:applySkin(MailTo_InFrame)
-->>--	Mailable Frame
	self:keepRegions(MailTo_MailableFrame, {1, 6, 7, 8})
	MailTo_MailableFrame:SetWidth(MailTo_MailableFrame:GetWidth() * self.FxMult)
	MailTo_MailableFrame:SetHeight(MailTo_MailableFrame:GetHeight() * self.FyMult)
	self:moveObject(MailTo_MailableFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(MailTo_MailableFrameRow1, nil, nil, "+", 30)
	self:moveObject(MailTo_MailableFramePrevPageButton, nil, nil, "-", 60)
	self:moveObject(MailTo_MailableFrameNextPageButton, nil, nil, "-", 60)
	self:applySkin(MailTo_MailableFrame)
-->>--	Tradeable Frame
	self:keepRegions(MailTo_TradableFrame, {1, 6, 7, 8})
	MailTo_TradableFrame:SetWidth(MailTo_TradableFrame:GetWidth() * self.FxMult)
	MailTo_TradableFrame:SetHeight(MailTo_TradableFrame:GetHeight() * self.FyMult)
	self:moveObject(MailTo_TradableFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(MailTo_TradableFrameRow1, nil, nil, "+", 30)
	self:moveObject(MailTo_TradableFramePrevPageButton, nil, nil, "-", 60)
	self:moveObject(MailTo_TradableFrameNextPageButton, nil, nil, "-", 60)
	self:applySkin(MailTo_TradableFrame)
-->>--	Auctionable Frame
	self:keepRegions(MailTo_AuctionableFrame, {1, 6, 7, 8})
	MailTo_AuctionableFrame:SetWidth(MailTo_AuctionableFrame:GetWidth() * self.FxMult)
	MailTo_AuctionableFrame:SetHeight(MailTo_AuctionableFrame:GetHeight() * self.FyMult)
	self:moveObject(MailTo_AuctionableFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(MailTo_AuctionableFrameRow1, nil, nil, "+", 30)
	self:moveObject(MailTo_AuctionableFramePrevPageButton, nil, nil, "-", 60)
	self:moveObject(MailTo_AuctionableFrameNextPageButton, nil, nil, "-", 60)
	self:applySkin(MailTo_AuctionableFrame)
-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then MailTo_MailableTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(MailTo_MailableTooltip, "OnShow", function(object)
--			self:Debug("MailTo_MailableTooltip_OnShow: [%s, %s]", this:GetName(), object:GetName())
			self:skinTooltip(MailTo_MailableTooltip)
			end)
	end

end
