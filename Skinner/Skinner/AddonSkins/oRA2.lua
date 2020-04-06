if not Skinner:isAddonEnabled("oRA2") then return end

function Skinner:oRA2_Leader()

	local lr = oRA and oRA:GetModule("LeaderReady", true)
	if lr then
		local rf = self:findFrame2(UIParent, "Frame", 325, 325)
		if rf then
			self:addSkinFrame{obj=rf, kfs=true}
		end
	end

end

function Skinner:oRA2_Participant()

	local pr = oRA and oRA:GetModule("ParticipantReady", true)
	if pr then
		self:SecureHook(pr, "SetupFrames", function()
			local rf = self:findFrame2(UIParent, "Frame", 125, 325)
			if rf then
				self:addSkinFrame{obj=rf, kfs=true}
			end
			self:Unhook(pr, "SetupFrames")
		end)
	end

end
