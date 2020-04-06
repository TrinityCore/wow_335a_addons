if not Skinner:isAddonEnabled("Volumizer") then return end

function Skinner:Volumizer()

	VolumizerPanel.ChangeBackdrop = function() end

	self:SecureHookScript(VolumizerPanel, "OnShow", function(this)
		self:applySkin{obj=VolumizerPanel, kfs=true}
		local bdr = self:getChild(VolumizerPanel, 1)
		bdr:SetBackdrop(nil)
		self:removeRegions(bdr, {1})
		self:moveObject(self:getRegion(self:getChild(bdr, 1), 1), nil, nil, "-", 6)
		self:Unhook(VolumizerPanel, "OnShow")
	end)

end
