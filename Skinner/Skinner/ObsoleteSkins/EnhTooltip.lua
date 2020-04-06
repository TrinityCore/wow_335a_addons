
function Skinner:EnhTooltip()
	if not self.db.profile.Tooltips.skin or self.initialized.EnhTooltip then return end
	self.initialized.EnhTooltip = true

	if self.db.profile.Tooltips.style == 3 then EnhancedTooltip:SetBackdrop(self.backdrop) end

	self:RawHookScript(EnhancedTooltip, "OnShow", function(this)
--		self:Debug("EnhancedTooltip_OnShow: [%s]", this:GetName())
		self.hooks[EnhancedTooltip].OnShow(this)
		self:skinTooltip(this)
		end)

end
