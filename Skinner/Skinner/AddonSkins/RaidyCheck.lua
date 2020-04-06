if not Skinner:isAddonEnabled("RaidyCheck") then return end

function Skinner:RaidyCheck()

-->>-- Anchor frame
	self:skinAllButtons{obj=RaidyCheck.anchor, x1=-1, y1=-1}
	self:addSkinFrame{obj=RaidyCheck.anchor, kfs=true, y2=-2, nb=true}

-->>-- Panel
	-- skin it here as the Backdrop and colours are changed after LibQTip creates it
	self.ignoreLQTT["RaidyCheck"] = true
	self:SecureHook(RaidyCheck, "UpdatePanel", function(this)
		if LibStub("LibQTip-1.0"):IsAcquired("RaidyCheck") then
			for key, tooltip in LibStub("LibQTip-1.0"):IterateTooltips() do
				if key == "RaidyCheck" then self:applySkin{obj=tooltip} end
			end	
		end
	end)

end
