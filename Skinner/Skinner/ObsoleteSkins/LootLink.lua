
function Skinner:LootLink()

	function skinLLQSSF()

		local frame = LootLink.QUICKSEARCH_SEARCH_FRAME

		Skinner:applySkin(frame)
		frame.SetBackdropBorderColor = function() end

		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT", LootLink_ResultsFrame, "BOTTOMLEFT", 10, 5)

	end

	self:SecureHook(LootLink, "Main_LoadPlugin", function(LootLink, pluginName, existenceObjName, isAddon)
--		self:Debug("LootLink_Main_LoadPlugin: [%s, %s, %s]", pluginName, existenceObjName, isAddon)
-->>--	LL Options Frame
		if pluginName == "Options" and not self.skinned[LootLink_Options_DisplayFrame] then
			self:moveObject(LootLink_Options_HeaderText, nil, nil, "-", 8)
			self:skinDropDown(LootLink_Options_TooltipSettingsDD)
			self:skinEditBox(LootLink_Options_AutoLinkBotMinLengthEB, {9})
			self:skinDropDown(LootLink_Options_AutoLinkBotWatchedChannelsDD)
			self:skinDropDown(LootLink_Options_MinStoredRarityDD)
			self:skinDropDown(LootLink_Options_MinDisplayedRarityDD)
			self:skinDropDown(LootLink_Options_DataSharingBroadcastChannelsDD)
			self:keepFontStrings(LootLink_Options_DisplayFrame)
			self:applySkin(LootLink_Options_DisplayFrame)
		elseif pluginName == "QuickSearch" then
			skinLLQSSF()
		end
		end)

-->>--	LL Results Frame
	LootLink_ResultsFrame:SetWidth(LootLink_ResultsFrame:GetWidth() * self.FxMult)
	LootLink_ResultsFrame:SetHeight(LootLink_ResultsFrame:GetHeight() * self.FyMult)
	self:moveObject(LootLink_ResultsFrame_TitleButton, nil, nil, "+", 8)
	self:moveObject(LootLink_ResultsFrame_OptionsButton, "-", 30, nil, nil)
	self:moveObject(LootLink_ResultsFrame_CloseButton, "+", 28, "+", 8)
	self:skinDropDown(LootLink_ResultsFrame_SortTypeDD)
	self:removeRegions(LootLink_ResultsFrame_ListScrollFrame)
	self:skinScrollBar(LootLink_ResultsFrame_ListScrollFrame)
	self:keepFontStrings(LootLink_ResultsFrame)
	self:applySkin(LootLink_ResultsFrame)
	if LootLink_QuickSearch_SearchFrame then skinLLQSSF() end
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then LootLink_ResultsTooltip:SetBackdrop(self.backdrop) end
		self:SecureHook(LootLink_ResultsTooltip, "Show", function(this)
			self:skinTooltip(LootLink_ResultsTooltip)
			end)
	end

-->>--	LL Search Frame
	self:moveObject(LootLink_SearchFrame_HeaderText, mil, nil, "-", 8)
	self:skinDropDown(LootLink_SearchFrame_TypeAndSubtypeDD)
	self:skinDropDown(LootLink_SearchFrame_RarityDD)
	self:skinDropDown(LootLink_SearchFrame_EquipLocationDD)
	self:skinDropDown(LootLink_SearchFrame_BindTypeDD)
	self:skinEditBox(LootLink_SearchFrame_AllTextEB, {9})
	self:skinEditBox(LootLink_SearchFrame_NameEB, {9})
	self:skinEditBox(LootLink_SearchFrame_MinEquipLevelEB, {9})
	self:skinEditBox(LootLink_SearchFrame_MaxEquipLevelEB, {9})
	self:skinEditBox(LootLink_SearchFrame_MinItemLevelEB, {9})
	self:skinEditBox(LootLink_SearchFrame_MaxItemLevelEB, {9})
	self:keepFontStrings(LootLink_SearchFrame)
	self:applySkin(LootLink_SearchFrame)

	self:getRegion(LootLink_ToggleButton_Button, 1):SetAlpha(0)
	LootLink_ToggleButton_ButtonText:ClearAllPoints()
	LootLink_ToggleButton_ButtonText:SetPoint("CENTER", LootLink_ToggleButton_Button, "CENTER")
	self:applySkin(LootLink_ToggleButton_Button)

end
