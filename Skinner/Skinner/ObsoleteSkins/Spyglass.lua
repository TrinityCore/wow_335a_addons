
function Skinner:Spyglass()
	if not self.db.profile.InspectUI then return end

	self:moveObject(InspectSummaryFrame, "+", 12, "+", 26)
	self:applySkin(InspectSummaryFrame)

end
