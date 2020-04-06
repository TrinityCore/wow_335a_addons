if not Skinner:isAddonEnabled("!Swatter") then return end

function Skinner:Swatter()

	self:skinScrollBar{obj=SwatterErrorInputScroll}
	self:addSkinFrame{obj=SwatterErrorFrame}

end
