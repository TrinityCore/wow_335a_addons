
function Skinner:myBindings()
	if not self.db.profile.MenuFrames then return end

	self:keepRegions(myBindingsOptionsFrame, {7, 8, 9, 10, 11, 12, 14}) -- N.B. regions 7 - 12, 14 are text

	myBindingsOptionsFrame:SetHeight(myBindingsOptionsFrame:GetHeight() - 15)

	self:removeRegions(myBindingsOptionsHeadingsScrollFrame)
	self:skinScrollBar(myBindingsOptionsHeadingsScrollFrame)
	self:removeRegions(myBindingsOptionsBindingsScrollFrame)
	self:skinScrollBar(myBindingsOptionsBindingsScrollFrame)

	for i = 1, 18 do
		self:removeRegions(_G["myBindingsOptionsBindCategory"..i], {1})
		self:applySkin(_G["myBindingsOptionsBindCategory"..i])
	end
	for i = 1, 18 do
		self:removeRegions(_G["myBindingsOptionsBindHeader"..i], {1})
		self:applySkin(_G["myBindingsOptionsBindHeader"..i])
	end

	self:moveObject(myBindingsOptionsFrameOutputText, nil, nil, "-", 15)
	self:moveObject(myBindingsOptionsFrameGameDefaultsButton, nil, nil, "-", 15)
	self:moveObject(myBindingsOptionsFrameConfirmBindButton, nil, nil, "-", 15)
	self:moveObject(myBindingsOptionsFrameCancelBindButton, nil, nil, "-", 15)
	self:moveObject(myBindingsOptionsFrameUnbindButton, nil, nil, "-", 15)
	self:moveObject(myBindingsOptionsFrameOkayButton, nil, nil, "-", 15)
	self:moveObject(myBindingsOptionsFrameCancelButton, nil, nil, "-", 15)

	self:applySkin(myBindingsOptionsFrame, true)

end
