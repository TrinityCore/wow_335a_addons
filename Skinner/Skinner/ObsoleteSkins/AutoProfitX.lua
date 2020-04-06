
function Skinner:AutoProfitX()
	if not self.db.profile.MerchantFrames then return end

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AutoProfitX_Tooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(AutoProfitX_Tooltip)
	end

end
