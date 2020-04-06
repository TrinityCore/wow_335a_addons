
function Skinner:LinkHeaven()
	if not self.db.profile.Tooltips.skin then return end

	self:applySkin(LinkHeavenDropDown)

	for i = 1, 20 do
		local lhtt = _G["LH_TOOLTIP_"..i]
		if self.db.profile.Tooltips.style == 3 then lhtt:SetBackdrop(self.backdrop) end
		self:skinTooltip(lhtt)
	end

end
