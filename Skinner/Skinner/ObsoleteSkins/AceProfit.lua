
function Skinner:AceProfit()

	self:moveObject(AceProfit_TreasureModel, nil, nil, "+", 28)
	self:moveObject(AceProfit_AutosellButton, nil, nil, "+", 28)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AceProfitTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(AceProfitTooltip)
	end

end
