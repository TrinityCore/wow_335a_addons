
function Skinner:BaudMenu()

	self:applySkin(BaudMenuFrame, true)
-->>--	Options Frame
	self:applySkin(BaudMenuScrollBox)
	self:removeRegions(BaudMenuScrollBoxScrollBar)
	self:skinScrollBar(BaudMenuScrollBoxScrollBar)
	self:applySkin(BaudMenuOptionsFrame, true)

end
