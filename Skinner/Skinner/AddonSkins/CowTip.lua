if not Skinner:isAddonEnabled("CowTip") then return end

function Skinner:CowTip()

	local CTAdb = CowTip:GetDatabaseNamespace("Appearance")
	if CTAdb then
		CTAdb.profile.borderColor = self.tbColour
		CTAdb.profile.bgColor["other"] = self.bColour
	end
	local CTHBdb = CowTip:GetDatabaseNamespace("HealthBar")
	if CTHBdb then CTHBdb.profile.texture = self.db.profile.StatusBar.texture end
	local CTPBdb = CowTip:GetDatabaseNamespace("PowerBar")
	if CTPBdb then CTPBdb.profile.texture = self.db.profile.StatusBar.texture end

end
