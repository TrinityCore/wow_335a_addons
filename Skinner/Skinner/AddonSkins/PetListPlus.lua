if not Skinner:isAddonEnabled("PetListPlus") then return end

function Skinner:PetListPlus()

	self:skinButton{obj=PetListPlus.close}
	self:getRegion(PetListPlus.model, 1):SetAlpha(0) -- model background
	self:skinButton{obj=PetListPlus.random}
	self:skinSlider{obj=PetListPlus.scrollBar}

end
