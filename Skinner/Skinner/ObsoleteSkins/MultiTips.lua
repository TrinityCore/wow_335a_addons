
function Skinner:MultiTips()

	if self.db.profile.Tooltips.skin then
		for i = 2, 5 do
			local irtt = _G["ItemRefTooltip"..i]
			if self.db.profile.Tooltips.style == 3 then irtt:SetBackdrop(self.backdrop) end
			self:RawHookScript(irtt, "OnShow", function(this)
				self.hooks[this].OnShow(this)
				self:skinTooltip(irtt)
			end)
		end
	end

end
