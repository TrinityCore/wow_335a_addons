
function Skinner:OneBank()
	if not self.db.profile.BankFrame or self.initialized.OneBank then return end
	self.initialized.OneBank = true

	self:applySkin(OneBankFrame, nil, nil, OneBank.db.profile.colors.bground.a, 300)

end
