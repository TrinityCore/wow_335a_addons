
function Skinner:LootScroll()

	self:removeRegions(LootScrollFrame)
	self:skinScrollBar(LootScrollFrame)
	self:moveObject(LootScrollFrame, "-", 15, "+", 40)
	LootFrame:SetWidth(LootFrame:GetWidth() + 15)

end
