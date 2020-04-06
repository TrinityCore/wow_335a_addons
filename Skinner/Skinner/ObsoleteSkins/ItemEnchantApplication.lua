
function Skinner:ItemEnchantApplication()

	self:SecureHook(ItemEnchantApplication, "SetPoint", function()
		if ItemEnchantApplication.frame then
			self:applySkin(ItemEnchantApplication.frame)
		end
	end)

end
