if not Skinner:isAddonEnabled("PoMTracker") then return end

function Skinner:PoMTracker()

	self:skinButton{obj=PoMOptionFrame_CloseButton, cb=true}
	self:addSkinFrame{obj=PoMOptionFrame, y1=-7, x2=-7}
	
	self:addSkinFrame{obj=pomtracker2}
	
	self:glazeStatusBar(pomtrackerstatusBar, 0)
	
	self:skinButton{obj=pomtracker3_Button1, x1=-2, y1=1, x2=1, y2=-1}

end
