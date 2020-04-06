
function Skinner:TankPoints()
	self:applySkin(TankPointsCalculatorFrame)
	self:removeRegions(TankPointsCalculatorFrame, {1})
end
