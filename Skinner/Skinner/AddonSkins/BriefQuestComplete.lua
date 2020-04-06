if not Skinner:isAddonEnabled("BriefQuestComplete") then return end

function Skinner:BriefQuestComplete()

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then BQCTooltip:SetBackdrop(self.Backdrop[1]) end
		self:HookScript(BQCTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
