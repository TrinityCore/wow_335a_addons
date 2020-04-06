
function Skinner:HealersAssist()

	self:keepFontStrings(HAConfFrame)
	self:applySkin(HAConfFrame)
	self:applySkin(HealersAssistMainFrame)

	self:RawHook(HealersAssistMainFrame, "SetBackdropColor", function(r, g, b, a)
		self.hooks[HealersAssistMainFrame]["SetBackdropColor"](HealersAssistMainFrame, self.db.profile.Backdrop.r or .5, self.db.profile.Backdrop.g or .5, self.db.profile.Backdrop.b or .5, HA_Config["BackdropAlpha"]/100 -.1 or 0)
		local orientation = self.db.profile.Gradient.rotate and "HORIZONTAL" or "VERTICAL"
		local gradientOn = self.db.profile.Gradient.invert and {orientation, self.MaxR, self.MaxG, self.MaxB, HA_Config["BackdropAlpha"]/100, self.MinR, self.MinG, self.MinB, self.MinA} or {orientation, self.MinR, self.MinG, self.MinB, self.MinA, self.MaxR, self.MaxG, self.MaxB, HA_Config["BackdropAlpha"]/100}
		HealersAssistMainFrame.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and gradientOn or self.gradientOff))
	end, true)

	self:RawHook(HealersAssistMainFrame, "SetBackdropBorderColor", function(r, g, b, a)
		self.hooks[HealersAssistMainFrame]["SetBackdropBorderColor"](HealersAssistMainFrame, self.db.profile.BackdropBorder.r or .5, self.db.profile.BackdropBorder.g or .5, self.db.profile.BackdropBorder.b or .5, HA_Config["BackdropAlpha"]/100 -.1 or 0)
	end, true)

end
