if not Skinner:isAddonEnabled("tekDebug") then return end

function Skinner:tekDebug()

	self:SecureHookScript(tekDebugPanel, "OnShow", function(this)
		for k, child in pairs{tekDebugPanel:GetChildren()} do
			if child:IsObjectType("Button") then
				if k == 1 then self:skinButton{obj=child, cb=true}
				else child:SetNormalTexture(nil) end -- remove button's background texture
			end
		end
		self:Unhook(tekDebugPanel, "OnShow")
	end)
	self:addSkinFrame{obj=tekDebugPanel, kfs=true, y1=-11}

end
