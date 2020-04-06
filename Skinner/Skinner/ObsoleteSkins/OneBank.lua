
function Skinner:OneBank()
	if not self.db.profile.BankFrame or self.initialized.OneBank then return end
	self.initialized.OneBank = true

	self:applySkin(OneBankFrame)
	self:applySkin(OBBBagFra)

	-- hook these to stop the Backdrop colours from being changed
	self:Hook(OneBankFrame, "SetBackdropColor", function() end, true)
	self:Hook(OBBBagFra, "SetBackdropColor", function() end, true)

end
