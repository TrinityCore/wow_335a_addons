if not Skinner:isAddonEnabled("InspectEquip") then return end

function Skinner:InspectEquip()

	self:SecureHook(InspectEquip_InfoWindow, "Show", function(this, ...)
		self:moveObject(InspectEquip_InfoWindow, "+", 25, "+", 13)
	end)
	self:applySkin(InspectEquip_InfoWindow)

end
