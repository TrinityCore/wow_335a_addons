if not Skinner:isAddonEnabled("Planner") then return end

function Skinner:Planner()
	if not self.db.profile.Tooltips.skin then return end

	if self.db.profile.Tooltips.style == 3 then PlannerTooltip:SetBackdrop(self.backdrop) end
	self:skinTooltip(PlannerTooltip)

end
