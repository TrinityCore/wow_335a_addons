if not Skinner:isAddonEnabled("RandomPet30") then return end

function Skinner:RandomPet30()

	Frame1:SetWidth(44)
	Frame1:SetHeight(44)
	RndPet30Btn:ClearAllPoints()
	RndPet30Btn:SetPoint("CENTER", Frame1)
	self:applySkin(Frame1)

end
