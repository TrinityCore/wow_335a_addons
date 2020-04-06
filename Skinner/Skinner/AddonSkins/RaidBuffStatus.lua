if not Skinner:isAddonEnabled("RaidBuffStatus") then return end

function Skinner:RaidBuffStatus()

	self:addSkinFrame{obj=RBSFrame, kfs=true}
	self:addSkinFrame{obj=RBSTalentsFrame, kfs=true}
	self:addSkinFrame{obj=RBSOptionsFrame, kfs=true}

end
