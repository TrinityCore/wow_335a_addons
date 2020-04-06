
function Skinner:HealingEstimator()

-->>-- HealingEstimator Bar
	self:removeRegions(HealingEstimator, {1, 3, 16}) -- N.B. region 1 is Background, 3 is portrait ring, 16 is bar border
	self:glazeStatusBar(HealingEstimatorBar, 0)
	self:glazeStatusBar(HealingEstimatorHealingBar, 0)
	
-->>-- HealingEstimator Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then HealingEstimatorTooltip:SetBackdrop(backdrop) end
		self:skinTooltip(HealingEstimatorTooltip)
	end
	
-->>-- HealingEstimator Menu
	HealEstOptionsFrameHeader:Hide()
	self:moveObject(HealEstOptionsFrameHeader, nil, nil, "-", 6)
	self:applySkin(HealingEstimatorMenu)
	self:applySkin(HE1OptionsFrameDisplay)
	self:applySkin(HE2OptionsFrameDisplay)
	self:applySkin(HE3OptionsFrameDisplay)
	
-->>-- HealingEstimator ChartFrame
	self:keepFontStrings(HealingEstimatorChartFrame)
	self:moveObject(HealingEstimatorChartFrameCloseButton, "+", 42, "+", 3)
	self:applySkin(HealingEstimatorChartFrame, true)
	self:skinDropDown(HealingEstimatorChartFrameDropMenu)
	
-->>-- Minimap button
	self:addSkinButton(HealingEstimatorPieChart, HealingEstimatorPieChart, HealingEstimatorPieChart)
	HealingEstimatorPieChartArtwork:SetAlpha(0)
	
end
