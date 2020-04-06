
function Skinner:AxuItemMenus()

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then ItemMenuTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(ItemMenuTooltip)
	end

end
