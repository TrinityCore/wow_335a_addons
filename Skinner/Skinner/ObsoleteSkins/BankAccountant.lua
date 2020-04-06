
function Skinner:BankAccountant()

	self:SecureHook(BankAccountant, "InitGUI", function()
		self:applySkin(BankAccountantFrame)
		self:Unhook(BankAccountant, "InitGUI")
	end)

end
