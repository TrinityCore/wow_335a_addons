if not Skinner:isAddonEnabled("BuyEmAll") then return end

function Skinner:BuyEmAll()

	self:keepRegions(BuyEmAllFrame, {5})
	self:applySkin(BuyEmAllFrame, nil)

end
