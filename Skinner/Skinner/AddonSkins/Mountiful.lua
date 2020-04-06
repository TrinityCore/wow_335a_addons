if not Skinner:isAddonEnabled("Mountiful") then return end

function Skinner:Mountiful()

	-- tab
	self:skinFFToggleTabs("PetPaperDollFrameTab", 4)
	-- main frame
	self:skinButton{obj=MountifulFrame_Close, cb=true}
	self:addSkinFrame{obj=MountifulFrame}
	self:addSkinFrame{obj=MountifulFrame_LeftPane}
	self:addSkinFrame{obj=mountifulrightpanel}

end
