
function Skinner:TipBuddy()
	if not self.db.profile.Tooltips.skin then return end

	if self.db.profile.Tooltips.style == 3 then TipBuddyTooltip:SetBackdrop(self.backdrop) end
	self:skinTooltip(TipBuddyTooltip)

end
