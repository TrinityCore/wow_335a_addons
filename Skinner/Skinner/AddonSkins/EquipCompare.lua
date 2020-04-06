if not Skinner:isAddonEnabled("EquipCompare") then return end

function Skinner:EquipCompare()
	if not self.db.profile.Tooltips.skin then return end

	if self.db.profile.Tooltips.style == 3 then
		ComparisonTooltip1:SetBackdrop(self.backdrop)
		ComparisonTooltip2:SetBackdrop(self.backdrop)
	end
	self:skinTooltip(ComparisonTooltip1)
	self:skinTooltip(ComparisonTooltip2)

end
