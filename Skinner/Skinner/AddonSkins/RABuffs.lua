if not Skinner:isAddonEnabled("RABuffs") then return end

function Skinner:RABuffs()

-->>--	RAB Settings Frame
	RAB_SettingsFrame:SetWidth(RAB_SettingsFrame:GetWidth() * self.FxMult)
	RAB_SettingsFrame:SetHeight(RAB_SettingsFrame:GetHeight() * self.FyMult)
	self:moveObject(RAB_SettingsTitleText, nil, nil, "+", 10)
	self:moveObject(RAB_SettingsCloseButton, "+", 28, "+", 8)
	self:keepRegions(RAB_Settings_TopNavigation, {})
	self:moveObject(RAB_Settings_TopNavigationTab1, "-", 20, nil, nil)
	for i = 1, 3 do
		local togTab = _G["RAB_Settings_TopNavigationTab"..i]
		self:keepRegions(togTab, {7, 8})
		togTab:SetHeight(togTab:GetHeight() - 5)
		self:moveObject(_G[togTab:GetName().."Text"], "-", 2, "+", 3)
		self:moveObject(_G[togTab:GetName().."HighlightTexture"], "-", 2, "+", 5)
		self:applySkin(togTab)
	end
	self:keepRegions(RAB_SettingsFrame, {7})
	self:applySkin(RAB_SettingsFrame, nil)

-->>--	Settings Panel 1
	self:keepRegions(RAB_SettingsPanel1, {1, 2})
	self:keepRegions(RAB_SettingsPanel1Frame1, {})
	self:skinScrollBar(RAB_SettingsPanel1Frame1)
	self:keepRegions(RAB_SettingsPanel1Frame2, {1, 2})
	self:keepRegions(RAB_SettingsPanel1Frame3, {1, 2})

-->>--	Settings Panel 2 Frame 1 (User Interface)
	self:keepRegions(RAB_SettingsPanel2, {1,2})
	self:keepRegions(RAB_SettingsPanel2Divider, {})
	self:keepRegions(RAB_Settings_localizationSelector, {4, 5}) -- N.B. regions 4 & 5 are text

-->>--	Settings Frame 2 (Layout)
	self:keepRegions(RAB_SettingsPanel3, {1,2})
	self:keepRegions(RAB_SettingsPanel3Divider, {})
	self:keepRegions(RAB_SettingsPanel3Custom, {1,2,3,4,5,6})
	self:keepRegions(RAB_SettingsPanel3Content, {5,6,7,8})
	self:keepRegions(RAB_Settings_LayoutScrollBar, {})
	self:skinScrollBar(RAB_Settings_LayoutScrollBar)
	self:keepRegions(RAB_BarListContainer, {})
	self:keepRegions(RAB_BarDetail_GroupLimits, {})
	self:keepRegions(RAB_BarDetail_ClassLimits, {})
	self:keepRegions(RAB_BarDetailContainer, {1,2,3,4,5,6})
	self:moveObject(RAB_BarDetail_Label, "-", 4, "-", 4)
	self:skinEditBox(RAB_BarDetail_Label, {9})
	self:moveObject(RAB_QueryDetail_CustomName, "-", 4, "+", 4)
	self:skinEditBox(RAB_QueryDetail_CustomName, {9})
	self:moveObject(RAB_QueryDetail_CustomID, "-", 4, "+", 4)
	self:skinEditBox(RAB_QueryDetail_CustomID, {9})
	self:moveObject(RAB_QueryDetail_CustomMatch, "-", 4, "+", 4)
	self:skinEditBox(RAB_QueryDetail_CustomMatch, {9})
	self:keepRegions(RAB_QueryDetail_CustomClassLimits, {1})
	self:keepRegions(RAB_QueryDetail_BigThreshold, {})
	self:keepRegions(RAB_QueryDetail_ClassLimits, {1})
	self:keepRegions(RAB_QueryDetail_RecastAdjust, {})
	self:keepRegions(RAB_Settings_profileSelector, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(RAB_BarDetail_Type, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(RAB_BarDetail_OutputTarget, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(RAB_BarDetail_ShowState, {4,5}) -- N.B. regions 4 & 5 are text

-->>--	Settings Frame 3 (Queries)
	self:keepRegions(RAB_Settings_querySelector, {4,5}) -- N.B. regions 4 & 5 are text

-->>--	Tabs
	-- hook these to manage textured tabs
	if self.db.profile.TexturedTab then
		self:SecureHookScript(RAB_SettingsFrame, "OnShow", function()
			self:moveObject(RAB_SettingsFrameTab2, "+", 10, nil, nil)
			self:moveObject(RAB_SettingsFrameTab3, "+", 10, nil, nil)
		end)
		self:SecureHook("RAB_cfgMain_FocusPage", function(key)
			for i = 1, 3 do
				if (i == RAB_SettingsFrame.selectedTab) then
					self:setActiveTab(_G["RAB_SettingsFrameTab"..i])
				else
					self:setInactiveTab(_G["RAB_SettingsFrameTab"..i])
				end
			end
		end)
	end
	self:moveObject(RAB_SettingsFrameTab1, "-", 10, "-", 70)
	for i = 1, 3  do
		local tabName = _G["RAB_SettingsFrameTab"..i]
		self:keepRegions(tabName, {7,8})
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0)
		else self:applySkin(tabName) end
	end

-->>--	RAB Secure Header
	self:keepRegions(RAB_Menu, {4,5})
	self:keepRegions(RABFrame, {})
	self:applySkin(RABFrame)
	self:applySkin(RAB_Title)

-->>--	Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			RAB_Tooltip:SetBackdrop(self.backdrop)
			RAB_Spelltip:SetBackdrop(self.backdrop)
		end
		self:skinTooltip(RAB_Tooltip)
		self:skinTooltip(RAB_Spelltip)
	end

end
