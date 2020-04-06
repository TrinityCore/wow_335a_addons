
function Skinner:ShieldLeft()

	self:keepFontStrings(ShieldLeft)
	self:glazeStatusBar(ShieldLeftFrameStatusBar, 0)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then ShieldLeftTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(ShieldLeftTooltip)
	end

end
