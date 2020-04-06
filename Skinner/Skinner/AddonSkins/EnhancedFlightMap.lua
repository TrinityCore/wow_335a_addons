if not Skinner:isAddonEnabled("EnhancedFlightMap") then return end

function Skinner:EnhancedFlightMap()

	self:applySkin(EFM_ConfigScreen)
	self:applySkin(EFM_ConfigScreen_Panel_TimerOptions)
	self:applySkin(EFM_ConfigScreen_Panel_DisplayOptions)
	self:applySkin(EFM_ConfigScreenPanel2)

	self:applySkin(EFM_MapWindow)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then EFM_ToolTip:SetBackdrop(backdrop) end
		self:SecureHookScript(EFM_ToolTip, "OnShow", function(this)
--			self:Debug("EFM_ToolTip OnShow: [%s]", this)
			self:skinTooltip(EFM_ToolTip)
		end)
	end
	
end
