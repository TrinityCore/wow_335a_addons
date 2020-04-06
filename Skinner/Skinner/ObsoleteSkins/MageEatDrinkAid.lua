
function Skinner:MageEatDrinkAid()

	self:moveObject(MEDA_Panel, "+", 25, "+", 10)
	MEDA_Panel:SetAlpha(1)
	self:applySkin(MEDA_Panel)

end
