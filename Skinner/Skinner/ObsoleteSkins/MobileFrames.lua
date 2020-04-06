
function Skinner:MobileFrames()

	self:checkAndRun("AuctionUI")
	self:checkAndRun("InspectUI")
	self:checkAndRun("MacroUI")
	self:checkAndRun("TalentUI")
	self:checkAndRun("TradeSkillUI")
	self:checkAndRun("TrainerUI")

	-- skin the Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then MobileFramesTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(MobileFramesTooltip)
	end

end
