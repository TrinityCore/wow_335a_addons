if not Skinner:isAddonEnabled("AutoProfit") then return end

function Skinner:AutoProfit()
	if not self.db.profile.MerchantFrames then return end

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AutoProfit_Tooltip:SetBackdrop(self.Backdrop[1]) end
		self:skinTooltip(AutoProfit_Tooltip)
	end
end
