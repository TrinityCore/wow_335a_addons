
function Skinner:Tankadin()

	self:applySkin(Tankadin_RF_Frame)
	self:applySkin(Tankadin_AD_Frame)
	self:moveObject(Tankadin_Info_Frame_Name_Text, "+", 4, nil, nil)
	self:applySkin(Tankadin_Info_Frame)

-->>-- Options Frame
	self:keepFontStrings(Tankadin_Options_TabContainerFrame)
	myFrameHeader:Hide()
	self:moveObject(myFrameHeader, nil, nil, "-", 6)
	self:applySkin(Tankadin_Options_TabContainerFrame)
	-- Tabs
	for i = 1, 6 do
		local tabName = _G["Tankadin_Options_TabContainerFrameTab"..i]
		if i == 1 then
			self:moveObject(tabName, "-", 23, "-", 2)
		else
			self:moveObject(tabName, "+", 9, nil, nil)
		end
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabName)
			else self:setInactiveTab(tabName) end
		else self:applySkin(tabName) end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook("Tankadin_Options_ChangeFrame", function()
			for i = 1, 6 do
				local tabName = _G["Tankadin_Options_TabContainerFrameTab"..i]
				if i == Tankadin_Options_TabContainerFrame.selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end

end
