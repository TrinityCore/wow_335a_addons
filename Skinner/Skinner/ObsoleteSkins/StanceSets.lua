
function Skinner:StanceSets()

	StanceSetsFrame:SetWidth(StanceSetsFrame:GetWidth() * self.FxMult)
	StanceSetsFrame:SetHeight(StanceSetsFrame:GetHeight() * self.FyMult)
	self:keepRegions(StanceSetsFrame, {6})
	self:moveObject(StanceSetsCloseButton, "+", 28, "+", 8)
	self:moveObject(StanceSetsCloseButton2, "-", 10, "+", 14)
	self:applySkin(StanceSetsFrame)

end
