
function Skinner:DemonTrainerFrame()

	DemonTrainerFrame:SetWidth(DemonTrainerFrame:GetWidth() * self.FxMult)
	DemonTrainerFrame:SetHeight(DemonTrainerFrame:GetHeight() * self.FyMult)
	self:keepFontStrings(DemonTrainerFrame)
	self:moveObject(DemonTrainerFrameNameText, nil, nil, "+", 9)
	self:moveObject(DemonTrainerFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(DemonTrainerFrameFilterDropDown, nil, nil, "+", 20)
	self:skinDropDown(DemonTrainerFrameFilterDropDown)
	self:moveObject(DemonTrainerFrameExpandButtonFrame, nil, nil, "+", 20)
	self:keepFontStrings(DemonTrainerFrameExpandButtonFrame)
	self:moveObject(DemonTrainerFrameSkill1, nil, nil, "+", 10)
	self:moveObject(DemonTrainerFrameListScrollFrame, "+", 30, "+", 10)
	self:removeRegions(DemonTrainerFrameListScrollFrame)
	self:skinScrollBar(DemonTrainerFrameListScrollFrame)
	self:removeRegions(DemonTrainerFrameDetailScrollFrame)
	self:skinScrollBar(DemonTrainerFrameDetailScrollFrame)
	self:moveObject(DemonTrainerFrameMoneyFrame, "-", 10, "-", 76)
	self:moveObject(DemonTrainerFrameBuyButton, "-", 10, "-", 6)
	self:moveObject(DemonTrainerFrameCancelButton, "-", 10, "-", 6)
	self:applySkin(DemonTrainerFrame)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then DemonTrainerFrameTT:SetBackdrop(backdrop) end
		self:skinTooltip(DemonTrainerFrameTT)
	end

end
