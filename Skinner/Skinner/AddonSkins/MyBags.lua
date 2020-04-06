if not Skinner:isAddonEnabled("MyBags") then return end

function Skinner:MyBags()

	self:applySkin(MyBankFrame)
	self:applySkin(MyInventoryFrame)

end
