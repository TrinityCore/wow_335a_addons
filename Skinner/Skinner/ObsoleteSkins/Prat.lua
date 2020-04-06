
function Skinner:Prat()

	if PratWhoFrame then
		self:removeRegions(PratWhoScrollFrame)
		self:skinScrollBar(PratWhoScrollFrame)
		self:applySkin(PratWhoFrame)
		self:removeRegions(PratWhoFrame, {1, 2})
	end
	
	if PratCCFrame then
		self:removeRegions(PratCCFrameScroll)
		self:skinScrollBar(PratCCFrameScroll)
		self:applySkin(PratCCFrame)
	end
	
end
