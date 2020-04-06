if not Skinner:isAddonEnabled("xcalc") then return end

function Skinner:xcalc()

	self:SecureHook(xcalc, "windowframe", function(this)
		self:skinAllButtons{obj=xcalc_window, x1=-2, y1=-2, x2=2, y2=2}
		self:addSkinFrame{obj=xcalc_window, kfs=true, nb=true, y1=2}
		self:Unhook(xcalc, "windowframe")
	end)

	self:SecureHook(xcalc, "optionframe", function(this)
		self:addSkinFrame{obj=xcalc_optionwindow, kfs=true, y1=2}
		self:Unhook(xcalc, "optionframe")
	end)

end
