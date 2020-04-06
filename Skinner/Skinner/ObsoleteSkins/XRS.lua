
function Skinner:XRS()

	local function skinXRS()

		if not Skinner.skinned[XRSFrame] then
			XRS.SetColorGradient = function() end
			XRS.framegradient:Hide()
			XRS.db.profile.Texture = Skinner.db.profile.StatusBar.texture
			Skinner:applySkin(XRSFrame)
			XRSFrame.SetBackdropColor = function() end
			XRSFrame.SetBackdropBorderColor = function() end
			if Skinner.db.profile.Tooltips.skin then
				Skinner:skinTooltip(XRSTooltip)
				if Skinner.db.profile.Tooltips.style == 3 then XRSTooltip:SetBackdrop(Skinner.backdrop) end
			end
		end

	end

	self:SecureHook(XRS, "SetupFrames", skinXRS)

	-- remember to reskin on reloadui
	if getglobal("XRSFrame") ~= nil then skinXRS() end

end
