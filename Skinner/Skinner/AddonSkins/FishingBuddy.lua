if not Skinner:isAddonEnabled("FishingBuddy") then return end

function Skinner:FishingBuddy()

	self:addSkinFrame{obj=FishingBuddyFrame, kfs=true, x1=10, y1=-13, x2=-31, y2=69}
-->>--	Locations Frame
	self:keepFontStrings(FishingLocationsFrame)
	self:keepFontStrings(FishingLocationExpandButtonFrame)
	self:skinScrollBar{obj=FishingLocsScrollFrame}
	-- m/p buttons
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook(FishingBuddy.Locations, "Update", function(...)
			for i = 1, 21 do
				self:checkTex(_G["FishingLocations"..i])
			end
			self:checkTex(FishingLocationsCollapseAllButton)
		end)
	end
	for i = 1, 21 do
		self:skinButton{obj=_G["FishingLocations"..i], mp=true}
	end
	self:skinButton{obj=FishingLocationsCollapseAllButton, mp=true}

-->>--	Options Frame
	self:keepFontStrings(FishingOptionsFrame)
	self:skinDropDown{obj=FishingBuddyOption_EasyCastKeys}
	self:skinDropDown{obj=FishingBuddyOption_OutfitMenu}
-->>-- Tabs (side)
	for i = 1, 3 do
		self:removeRegions(_G["FishingBuddyOptionTab"..i], {1}) -- N.B. other regions are icon and highlight
	end

-->>--	Tabs (bottom)
	for i = 1, FishingBuddyFrame.numTabs do
		local tabObj = _G["FishingBuddyFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
    self.tabFrames[FishingBuddyFrame] = true

end
