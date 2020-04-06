if not Skinner:isAddonEnabled("EavesDrop") then return end

function Skinner:EavesDrop()

	self:keepRegions(EavesDropTab, {4})
	self:moveObject(EavesDropTab, "+", 10, "-", 4)
	self:moveObject(EavesDropTabText, "+", -5, "+", 5)
	if self.db.profile.TexturedTab then self:applySkin(EavesDropTab, nil, 0) else self:applySkin(EavesDropTab) end
	self:keepRegions(EavesDropFrame, {12,13})
	self:applySkin(EavesDropFrame)
	self:applySkin(EavesDropHistoryFrame)

end
