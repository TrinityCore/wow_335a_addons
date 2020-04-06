if not Skinner:isAddonEnabled("UrbanAchiever") then return end

function Skinner:UrbanAchiever()
	if not self.db.profile.AchievementUI then return end
	
	-- bugfix to handle Initialize not called by Addon if it is the last addon loaded
	if not UrbanAchiever.frame and UrbanAchiever.Initialize then
		UrbanAchiever:Initialize()
	end

	local function skinStatusBar(sBaro)
		
		local sBar = sBaro:GetName()
		_G[sBar.."BorderLeft"]:SetAlpha(0)
		_G[sBar.."BorderRight"]:SetAlpha(0)
		_G[sBar.."BorderCenter"]:SetAlpha(0)
		
	end
	
	local this = UrbanAchiever
	local uaFrame = this.frame
	self:keepFontStrings(uaFrame)
	uaFrame.close:SetPoint("TOPRIGHT", uaFrame, "TOPRIGHT")
	self:skinButton{obj=uaFrame.close, cb=true}
	local uaPS = UrbanAchieverFramePointShield
	uaPS:SetAlpha(1)
	uaPS:SetPoint("TOP", uaFrame, "TOP", 60, -5)
	this.pointsText:SetPoint("LEFT", uaPS, "RIGHT", 5, 2)
	this.compPointsText:SetPoint("TOPRIGHT", uaFrame, "TOP", -67, -5)
	self:skinEditBox(self:getChild(uaFrame.editbox, 1), {9})
	skinStatusBar(uaFrame.summaryBar)
	self:glazeStatusBar(uaFrame.summaryBar, 0, _G[uaFrame.summaryBar:GetName().."BG"])
	skinStatusBar(uaFrame.comparisonSummaryBar)
	skinStatusBar(uaFrame.category[92])
	skinStatusBar(uaFrame.category[97])
	skinStatusBar(uaFrame.category[168])
	skinStatusBar(uaFrame.category[201])
	skinStatusBar(uaFrame.category[96])
	skinStatusBar(uaFrame.category[95])
	skinStatusBar(uaFrame.category[169])
	skinStatusBar(uaFrame.category[155])
	self:glazeStatusBar(uaFrame.comparisonSummaryBar, 0, _G[uaFrame.comparisonSummaryBar:GetName().."BG"])
	self:skinSlider(uaFrame.catScroll)
	self:skinSlider(uaFrame.achScroll)
	-- Category frame
	uaFrame.category.backdrop:SetAlpha(0)
	self:moveObject(uaFrame.category, "-", 10, nil, nil)
	self:applySkin(uaFrame.category)
	self:applySkin(uaFrame, true)

-->>-- Category Buttons
	local bDrop = CopyTable(self.backdrop)
	bDrop.edgeSize = 8
	for i = 1, #uaFrame.catButtons do
		local catBtn = uaFrame.catButtons[i]
		self:keepFontStrings(catBtn)
		self:getRegion(catBtn, 3):SetAlpha(1) -- highlight texture
		self:applySkin(catBtn, nil, nil, nil, nil, bDrop)
	end
-->>-- Achievement Display Frame
	skinStatusBar(uaFrame.display.bar)
	self:glazeStatusBar(uaFrame.display.bar, 0, _G[uaFrame.display.bar:GetName().."BG"])
	skinStatusBar(uaFrame.display.compareBar)
	self:glazeStatusBar(uaFrame.display.compareBar, 0, _G[uaFrame.display.compareBar:GetName().."BG"])
	self:skinSlider(uaFrame.criteriaScroll)

-->>-- Tabs
	for i = 1, #uaFrame.tabButtons do
		local tabObj = uaFrame.tabButtons[i]
		tabObj.backdrop:SetAlpha(0)
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			if i == 1 then
				self:setActiveTab(tabObj)
			else
				self:setInactiveTab(tabObj)
			end
		else
			self:applySkin(tabObj)
		end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook(this, "RefreshCategoryButtons", function(this)
			for i = 1, #uaFrame.tabButtons do
				if this.currentTab == "achievements" then
					self:setActiveTab(uaFrame.tabButtons[1])
					self:setInactiveTab(uaFrame.tabButtons[2])
				else
					self:setActiveTab(uaFrame.tabButtons[2])
					self:setInactiveTab(uaFrame.tabButtons[1])
				end
			end
		end)
	end

end
