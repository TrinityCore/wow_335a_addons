if not Skinner:isAddonEnabled("HatTrick") then return end

function Skinner:HatTrick()

	self:moveObject(HelmCheckBox, "-", 6, "+", 12)
	self:moveObject(CloakCheckBox, "-", 6, "+", 12)

end
