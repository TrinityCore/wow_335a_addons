if not Skinner:isAddonEnabled("Highlight") then return end

function Skinner:Highlight()

	self:skinEditBox{obj=Highlight_EditBox, x=-4, y=-1}
	self:skinEditBox{obj=Highlight_Count, x=6}

end
