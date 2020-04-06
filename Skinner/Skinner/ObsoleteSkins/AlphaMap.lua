
function Skinner:AlphaMap() -- tested against v3.25.20400

	local AMBackdrop = CopyTable(self.backdrop)
	AMBackdrop.bgFile = nil
	
-->>-- Map Detail Frame
	-- hook this the manage the backdrop
	self:SecureHook(AlphaMapDetailFrame, "Show", function()
--		self:Debug("AMDF_Show")
		if AlphaMapDetailFrame:GetBackdrop() then
			self:applySkin(AlphaMapDetailFrame, nil, nil, nil, nil, AMBackdrop)
			AlphaMapDetailFrame.tfade:SetAlpha(0) -- hide the Gradient texture
		end
	end)
	self:skinUsingBD2(AlphaMapSliderFrame)

-->>-- Map Selector Frame
	self:applySkin(AlphaMapSelectorMovementFrame)
	self:skinDropDown(AlphaMapContinentDropDown)
	self:skinDropDown(AlphaMapZoneDropDown)

-->>-- Options Frame
	self:applySkin(AM_OptionsFrame)
	self:applySkin(AlphaMap_OptionsTabFrame)
	AM_OptionsFrameHeader:SetAlpha(0)
	self:moveObject(AM_OptionsFrameHeader, nil, nil, "-", 6)
	for i = 1, 5 do
		local tabObj = _G["AlphaMap_OptionsTabFrameTab"..i]
		if i == 1 then
			self:moveObject(tabObj, nil, nil, "-", 5)
		else
			self:moveObject(tabObj, "+", 12, nil, nil)
		end
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		tabObj:SetHeight(tabObj:GetHeight() + 6)
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabObj)
			else self:setInactiveTab(tabObj) end
		else self:applySkin(tabObj) end
	end
	if self.db.profile.TexturedTab then 
		self:SecureHook("AlphaMap_TabSelect", function(subFrame)
			for i = 1, 5 do
				local tabObj = _G["AlphaMap_OptionsTabFrameTab"..i]
				if i == AlphaMap_OptionsTabFrame.selectedTab then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
			end)
	end
	self:skinDropDown(AlphaMapDDPoint)
	self:skinDropDown(AlphaMapDDrelativePoint)

-->>-- Popup Frame
	self:applySkin(AMPopup)
	
-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AlphaMapTooltip:SetBackdrop(backdrop) end
		self:skinTooltip(AlphaMapTooltip)
		AlphaMapTooltip.SetBackdropBorderColor = function() end
	end
	
end
