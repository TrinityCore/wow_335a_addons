
function Skinner:OneBag()
	if not self.db.profile.ContainerFrames or self.initialized.OneBag then return end
	self.initialized.OneBag = true

	self:applySkin(OneBagFrame, nil, nil, OneBag.db.profile.colors.bground.a, 200)
	if OneRingFrame then self:applySkin(OneRingFrame, nil, nil, OneRing.db.profile.colors.bground.a, 100) end
	if OneViewFrame then self:applySkin(OneViewFrame, nil, nil, OneView.db.profile.colors.bground.a, 200) end

end
