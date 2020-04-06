
function Skinner:Mirror()

	if self.db.profile.Tooltips.skin then
		for i = 1, 2 do
			local mtt = _G["MirrorTooltip"..i]
			if self.db.profile.Tooltips.style == 3 then mtt:SetBackdrop(self.backdrop) end
			self:SecureHook(mtt, "Show", function(this)
				self:skinTooltip(mtt)
			end)
		end
	end

end
