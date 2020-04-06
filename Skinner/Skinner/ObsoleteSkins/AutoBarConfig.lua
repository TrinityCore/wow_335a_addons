
function Skinner:AutoBarConfig()

	self:SecureHook(AutoBarConfig, "TabButtonOnClick", function(self, tabId)
		for i = 1, AutoBarConfigFrame.numTabs do
			local tabName = _G["AutoBarConfigFrameTab"..i]
			if i == tabId then
				Skinner:setActiveTab(tabName)
			else
				Skinner:setInactiveTab(tabName)
			end
		end
	end)

	self:keepFontStrings(AutoBarConfigFrame)
	self:keepFontStrings(AutoBarConfigFrameBarDockTo)
	self:keepFontStrings(AutoBarConfigFrameProfileSetShared)
	self:applySkin(AutoBarConfigFrame)

	for i = 1, AutoBarConfigFrame.numTabs do
		local tabName = _G["AutoBarConfigFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 1)
			self:setActiveTab(tabName)
		else
			self:setInactiveTab(tabName)
		end
	end

end
