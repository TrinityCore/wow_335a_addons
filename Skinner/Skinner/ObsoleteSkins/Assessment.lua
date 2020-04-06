
function Skinner:Assessment()

	local ABI = Assessment:GetModule("BarInterface", true)

	local function skinABIWindows()

		for i = 1, ABI.db.profile.windows.count do
			local frame = ABI.windows[i] and ABI.windows[i].frame or nil
--			Skinner:Debug("skinABIWindows: [%s, %s]", ABI.db.profile.windows.count, frame)
			if frame and not frame.skinned then
				Skinner:keepFontStrings(frame)
				Skinner:applySkin(frame)
				Skinner:RawHook(frame, "SetBackdrop", function() end, true)
				Skinner:RawHook(frame, "SetBackdropColor", function() end, true)
				Skinner:RawHook(frame, "SetBackdropBorderColor", function() end, true)
				frame.skinned = true
			end
		end

	end

	if ABI then
		self:SecureHook(ABI, "CreateWindows", function()
--			self:Debug("ABI_CW")
			skinABIWindows()
		end)
		skinABIWindows()
	end

end
