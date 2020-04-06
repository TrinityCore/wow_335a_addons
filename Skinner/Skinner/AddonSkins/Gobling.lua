if not Skinner:isAddonEnabled("Gobling") then return end

function Skinner:Gobling()

	self:skinEditBox{obj=GoblingFrame_Input, regs={9}}
	self:addSkinFrame{obj=GoblingFrame, x1=6, y1=-6, x2=-6, y2=6}

end
