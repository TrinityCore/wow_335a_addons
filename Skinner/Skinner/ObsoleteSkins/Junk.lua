
function Skinner:Junk()

	local junkButton = self:getChild(MerchantBuyBackItem, 3)
	if junkButton:GetObjectType() == "Button" and math.floor(junkButton:GetHeight()) == 32 and math.floor(junkButton:GetWidth()) == 32 then
		self:moveObject(junkButton, nil, nil, "+", 28)
	end

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then JunkTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(JunkTooltip)
	end

end
