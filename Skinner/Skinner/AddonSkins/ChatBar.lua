if not Skinner:isAddonEnabled("ChatBar") then return end

function Skinner:ChatBar()

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then ChatBarFrameTooltip:SetBackdrop(self.Backdrop[1]) end
		self:HookScript(ChatBarFrameTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
