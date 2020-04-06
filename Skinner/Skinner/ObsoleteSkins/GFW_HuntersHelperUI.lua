
function Skinner:GFW_HuntersHelperUI()

	FHH_UI:SetWidth(FHH_UI:GetWidth() * self.FxMult)
	FHH_UI:SetHeight(FHH_UI:GetHeight() * self.FyMult)
	self:keepFontStrings(FHH_UI)
	self:moveObject(FHH_UITitleText, nil, nil, "+", 8)
	self:moveObject(FHH_UICloseButton, "+", 29, "+", 8)
	self:skinDropDown(FHH_UIViewByDropDown)
	self:skinEditBox(FHH_UIEditBox, {9})
	self:skinDropDown(FHH_UIKnownDropDown)
	self:skinDropDown(FHH_UIFamilyDropDown)
	self:keepFontStrings(FHH_UIExpandButtonFrame)
	self:removeRegions(FHH_UIListScrollFrame)
	self:skinScrollBar(FHH_UIListScrollFrame)
	self:removeRegions(FHH_UIDetailScrollFrame)
	self:skinScrollBar(FHH_UIDetailScrollFrame)
	self:moveObject(FHH_UIListScrollFrame, "+", 39, nil, nil)
	self:moveObject(FHH_UITrainingPointsText, nil, nil, "-", 70)
	self:moveObject(FHH_UIOptionsButton, "-", 6, nil, nil)
	self:moveObject(FHH_UITrainButton, "-", 6, nil, nil)
	self:applySkin(FHH_UI)

end
