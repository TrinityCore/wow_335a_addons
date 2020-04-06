if not Skinner:isAddonEnabled("TomTom") then return end

function Skinner:TomTom()

	local function skinTTBlock()

		if TomTomBlock and TomTomBlock:IsShown() then
			TomTomBlock:SetFrameStrata("LOW")
			Skinner:applySkin(TomTomBlock)
		end

	end

	self:SecureHook(TomTom, "ShowHideCoordBlock", function() skinTTBlock() end)

	-- skin the Coordinate block
	skinTTBlock()

	if self.db.profile.Tooltips.skin then
		self:SecureHook(TomTomTooltip, "Show", function(this)
			if self.db.profile.Tooltips.style == 3 then TomTomTooltip:SetBackdrop(self.backdrop) end
			self:skinTooltip(TomTomTooltip)
		end)
	end

end
