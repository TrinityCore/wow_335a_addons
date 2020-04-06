if not Skinner:isAddonEnabled("DailiesQuestTracker") then return end

function Skinner:DailiesQuestTracker()

	local bc = self.db.profile.Backdrop
	local bbc = self.db.profile.BackdropBorder
	self:SecureHook("DQT_OnHoverTooltip", function()
		local r, g, b = Rewards_Tooltip:GetBackdropBorderColor()
		r = ("%.2f"):format(r)
		g = ("%.2f"):format(g)
		b = ("%.2f"):format(b)
		if r == "1.00" and g == "1.00" and b == "1.00" then
			Rewards_Tooltip:SetBackdropColor(bc.r, bc.g, bc.b)
			Rewards_Tooltip:SetBackdropBorderColor(bbc.r, bbc.g, bbc.b)
		end
	end)
	
	-- handle DailiesQuestTracker changing tooltip colours
	ResetTheTooltip = function()
		DailiesQuestTracker_Tooltip:Show()
	end
	
end
