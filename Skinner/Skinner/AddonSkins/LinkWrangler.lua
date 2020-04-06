if not Skinner:isAddonEnabled("LinkWrangler") then return end

function Skinner:LinkWrangler()
	if not self.db.profile.Tooltips.skin then return end

	self:SecureHook(LinkWrangler, "TooltipOnShow", function(frame)
--		self:Debug("LW_TOS: [%s]", frame:GetName() or "nil")
		if frame and not self.skinned[frame] then
			if self.db.profile.Tooltips.skin then
				if self.db.profile.Tooltips.style == 3 then frame:SetBackdrop(self.backdrop)	end
				self:skinTooltip(frame)
			end
		end
	end)

end
