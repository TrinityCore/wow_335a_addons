if not Skinner:isAddonEnabled("Hadar_FocusFrame") then return end

function Skinner:Hadar_FocusFrame()

	self:applySkin(FocusMainFrame)
	self:glazeStatusBar(FocusMainFrame.barFrames[1].bar[1], 0)
	self:glazeStatusBar(FocusMainFrame.barFrames[1].bar[2], 0)
	self:glazeStatusBar(FocusMainFrame.barFrames[1].bar[3], 0)
	self:glazeStatusBar(FocusMainFrame.barFrames[2].bar[1], 0)
	self:glazeStatusBar(FocusMainFrame.barFrames[2].bar[2], 0)
	self:glazeStatusBar(FocusMainFrame.barFrames[2].bar[3], 0)

end
