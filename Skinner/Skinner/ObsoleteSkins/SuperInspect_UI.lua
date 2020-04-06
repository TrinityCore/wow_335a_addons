
function Skinner:SuperInspect_UI()
	if not self.db.profile.InspectUI or self.initialized.SuperInspect then return end
	self.initialized.SuperInspect = true

	self:removeRegions(SuperInspectFrameHeader, {1, 2, 3, 4})
	self:removeRegions(SuperInspect_ItemBonusesFrame, {1})
	self:removeRegions(SuperInspect_COHBonusesFrame, {1})
	self:removeRegions(SuperInspect_USEBonusesFrame, {1})
	self:removeRegions(SuperInspect_SnTBonusesFrame, {1})
	self:removeRegions(SuperInspect_InRangeFrame, {3})
	self:removeRegions(SuperInspect_HonorFrame, {1})
	self:removeRegions(SuperInspect_ItemBonusesFrameCompare, {1})
	self:removeRegions(SuperInspect_Button_ShowHonor, {2, 4})
	self:removeRegions(SuperInspect_Button_ShowBonuses, {2, 4})
	self:removeRegions(SuperInspect_Button_ShowMobInfo, {2, 4})
	self:removeRegions(SuperInspect_Button_ShowItems, {2, 4})

	SuperInspectFramePortrait:SetAlpha(0)
	SuperInspect_BackgroundTopLeft:Hide()
	SuperInspect_BackgroundTopRight:Hide()
	SuperInspect_BackgroundBotLeft:Hide()
	SuperInspect_BackgroundBotRight:Hide()
	SIInfoDetailHeader:Hide()
	SIInfoDetailCorner:Hide()

	SuperInspect_InRangeFrame:SetHeight(SuperInspect_InRangeFrame:GetHeight() * self.FyMult - 35)

	self:moveObject(SuperInspect_InRangeFrame, nil, nil, "+", 32)
	self:moveObject(SuperInspect_InRangeFrame_Text, "-", 20, "-", 25)
	self:moveObject(SuperInspect_InRangeFrame_Text2, "-", 20, "-", 25)
	self:moveObject(SuperInspect_ItemBonusesFrameCompare, "+", 10, nil, nil)

	self:removeRegions(SuperInspect_ItemBonusesScrollFrame)
	self:skinScrollBar(SuperInspect_ItemBonusesScrollFrame)
	self:removeRegions(SIInfoScrollFrame)
	self:skinScrollBar(SIInfoScrollFrame)

	self:glazeStatusBar(SuperInspect_HonorFrameProgressBar, -2)
	self:applySkin(SuperInspectFrame)
	self:applySkin(SuperInspect_ItemBonusesFrame, nil, 0.6, 0.6)
	self:applySkin(SuperInspect_COHBonusesFrame, nil, 0.6, 0.6)
	self:applySkin(SuperInspect_USEBonusesFrame, nil, 0.6, 0.6)
	self:applySkin(SuperInspect_SnTBonusesFrame, nil, 0.6, 0.6)
	self:applySkin(SuperInspect_InRangeFrame, nil, 0)
	self:applySkin(SIInfoFrame)
	self:applySkin(SuperInspect_HonorFrame)
	self:applySkin(SuperInspect_ItemBonusesFrameCompare)
	self:applySkin(SuperInspect_BonusFrameParentTab1)
	self:applySkin(SuperInspect_BonusFrameParentTab2)
	self:applySkin(SuperInspect_BonusFrameParentTab3)
	self:applySkin(SuperInspect_BonusFrameParentTab4)
	self:applySkin(SuperInspect_Button_ShowHonor)
	self:applySkin(SuperInspect_Button_ShowBonuses)
	self:applySkin(SuperInspect_Button_ShowMobInfo)
	self:applySkin(SuperInspect_Button_ShowItems)

end
