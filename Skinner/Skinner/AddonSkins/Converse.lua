if not Skinner:isAddonEnabled("Converse") then return end

function Skinner:Converse()

	self:addSkinFrame{obj=ConverseFrame, kfs=true, x1=10, y1=-11, y2=8}
	self:skinScrollBar{obj=ConverseFrameItemsScrollFrame}
	self:moveObject{obj=ConverseFrameItemsScrollFrame, x=-2}
	self:skinScrollBar{obj=ConverseFrameHistoryScrollFrame}
	self:addSkinFrame{obj=ConverseFrameLinksPanel, kfs=true, y1=-3, x2=-2, y2=8}
	self:skinEditBox{obj=ConverseFrameAltEditFrameText}

end
