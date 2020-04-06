if not Skinner:isAddonEnabled("MTLove") then return end

function Skinner:MTLove()

	self:applySkin(MTLove_Frame)
	MTLove_Frame.SetBackdropColor = function() end
	MTLove_Frame.SetBackdropBorderColor = function() end
	self:applySkin(MTLove_Frame_Counter)
	MTLove_Frame_Counter.SetBackdropColor = function() end
	MTLove_Frame_Counter.SetBackdropBorderColor = function() end
	self:glazeStatusBar(MTLove_Frame_StatusBar0, 0)
	self:glazeStatusBar(MTLove_Frame_StatusBar1, 0)
	self:applySkin(MTLove_TT_Frame)
	MTLove_TT_Frame.SetBackdropColor = function() end
	MTLove_TT_Frame.SetBackdropBorderColor = function() end
	self:glazeStatusBar(MTLove_TT_Frame_StatusBar, 0)
	self:applySkin(MTLove_TT_Frame_Counter)
	MTLove_TT_Frame_Counter.SetBackdropColor = function() end
	MTLove_TT_Frame_Counter.SetBackdropBorderColor = function() end
	self:applySkin(MTLove_TargetCounter_Counter)
	MTLove_TargetCounter_Counter.SetBackdropColor = function() end
	MTLove_TargetCounter_Counter.SetBackdropBorderColor = function() end
	self:applySkin(MTLove_FocusCounter_Counter)
	MTLove_FocusCounter_Counter.SetBackdropColor = function() end
	MTLove_FocusCounter_Counter.SetBackdropBorderColor = function() end

end
