
function Skinner:ReagentHeaven()

	ReagentHeavenFrame:SetWidth(ReagentHeavenFrame:GetWidth() - 30)
	ReagentHeavenFrame:SetHeight(ReagentHeavenFrame:GetHeight() - 70)

	self:removeRegions(ReagentHeavenFrame)

	self:removeRegions(ReagentHeavenListScrollFrame)
	self:skinScrollBar(ReagentHeavenListScrollFrame)

	self:applySkin(ReagentHeavenFrame)

end
