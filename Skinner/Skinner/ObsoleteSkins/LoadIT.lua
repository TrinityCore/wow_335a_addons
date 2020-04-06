
function Skinner:LoadIT()

	self:keepFontStrings(LoadITOptionsFrame)
	self:keepFontStrings(LoadITmenuFrame)
	self:moveObject(LoadITmenuFrameCloseButton, "+", 30, "+", 8)
	self:moveObject(LoadITLoadAddonButton, "-", 10, "-", 80)
	LoadITmenuFrame:SetWidth(LoadITmenuFrame:GetWidth() * self.FxMult)
	LoadITmenuFrame:SetHeight(LoadITmenuFrame:GetHeight() * self.FyMult)
	self:applySkin(LoadITmenuFrame, nil)
-->>--	Live Tab
	self:keepFontStrings(LoadITLiveScrollFrame)
	self:skinScrollBar(LoadITLiveScrollFrame)
	self:moveObject(LoadITLiveScrollFrame, "+", 30, nil, nil)
	self:keepFontStrings(LoadITLiveFrame)
	self:keepFontStrings(LoadITLiveFrameColumnHeader1)
	self:keepFontStrings(LoadITLiveFrameColumnHeader2)
	self:keepFontStrings(LoadITLiveFrameColumnHeader3)
	self:moveObject(LoadITLiveFrameCheckAllButton, "+", 30, "-", 70)
	self:moveObject(LoadITLiveFrameUnCheckAllButton, "+", 30, "-", 70)
-->>--	Profile Tab
	self:keepFontStrings(LoadITProfileScrollFrame)
	self:skinScrollBar(LoadITProfileScrollFrame)
	self:keepFontStrings(LoadITProfileFrame)
	self:keepFontStrings(LoadITProfileFrameColumnHeader1)
	self:keepFontStrings(LoadITProfileFrameColumnHeader2)
	self:keepFontStrings(LoadITProfileFrameColumnHeader3)
	self:keepFontStrings(DDProfiles)
-->>--	Edit Tab
	self:keepFontStrings(LoadITEditScrollFrame)
	self:skinScrollBar(LoadITEditScrollFrame)
	self:keepFontStrings(LoadITEditFrameColumnHeader1)
	self:keepFontStrings(LoadITEditFrameColumnHeader2)
	self:keepFontStrings(LoadITEditFrameColumnHeader3)
	self:keepFontStrings(LoadITEditFrame)
-->>--	Tabs
	for i = 1, 5 do
		local tabName = _G["LoadITmenuFrameTab"..i]
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:applySkin(tabName) end
		self:keepRegions(tabName, {7,8})
		if i == 1 then
			self:moveObject(tabName, "-", 10, "-", 70)
			if self.db.profile.TexturedTab then
				self:setActiveTab(tabName)
				self:SecureHook("LoadIToptTab_OnClick", function(id)
					for i = 1, 5 do
						local tabName = _G["LoadITmenuFrameTab"..i]
						if i == id then
							self:setActiveTab(tabName)
						else
							self:setInactiveTab(tabName)
						end
					end
				end)
			end
		else
			self:moveObject(tabName, "+", 10, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
	end

end
