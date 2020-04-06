if not Skinner:isAddonEnabled("TradeTabs") then return end

function Skinner:TradeTabs()
	if not self.db.profile.TradeSkillUI then return end

	local function skinTradeTabs(frame, xAdj, xOfs)

-- 		Skinner:Debug("skinTradeTabs: [%s, %s, %s]", frame:GetName(), xAdj, xOfs)

		local prev

		for i = 1, frame:GetNumChildren() do
			local obj = select(i, frame:GetChildren())
			if obj:GetName() == nil and obj:IsObjectType("CheckButton") then
				Skinner:removeRegions(obj, {1}) -- N.B. other regions are icon and highlight
				if not prev then Skinner:moveObject(obj, xAdj, xOfs, "+", 14)
				else Skinner:moveObject(obj, nil, nil, "+", 8, prev) end
				prev = obj
			end
			frame.ttskinned = true
		end

	end

	self:SecureHook(TradeTabs , "Initialize", function()
		if IsAddOnLoaded("Skillet") and not SkilletFrame.ttskinned then
			skinTradeTabs(SkilletFrame, "-", 2)
		else
			if TradeSkillFrame and not TradeSkillFrame.ttskinned then
				skinTradeTabs(TradeSkillFrame, "+", 30)
			end
		end
		self:Unhook(TradeTabs, "Initialize")
	end)

end
