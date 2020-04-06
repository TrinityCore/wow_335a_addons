
function Skinner:Proximo()

	self:SecureHook(Proximo, "MakeFrame", function()
--		self:Debug("P_MF")
		self:applySkin(Proximo.frame)
		Proximo.frame.SetBackdropColor = function() end
		Proximo.frame.SetBackdropBorderColor = function() end
	end)

end
