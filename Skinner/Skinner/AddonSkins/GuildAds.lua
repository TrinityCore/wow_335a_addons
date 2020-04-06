if not Skinner:isAddonEnabled("GuildAds") then return end

function Skinner:GuildAds()

	local function skinGuildAdsMain()

	-->>-- Main Frame
		Skinner:moveObject(GuildAdsText, nil, nil, "+", 14)
		Skinner:moveObject(GuildAdsVersion, nil, nil, "+", 14)
		Skinner:moveObject(GuildAdsCloseButton, "-", 2, "+", 12)
		Skinner:keepFontStrings(GuildAdsMainWindowFrame)
		Skinner:applySkin(GuildAdsMainWindowFrame)

	-->>-- Trade Frame
		if GuildAdsTradeFrame then
			-->>-- Main Frame
			-- tabs
			Skinner:skinFFToggleTabs("GuildAds_MyTab", 4)
			-- sort headers
			for i = 1, 7 do
				Skinner:keepRegions(_G["GuildAdsTradeColumnHeader"..i], {4, 5}) -- N.B. region 4 is the text, 5 is the arrow
				Skinner:applySkin(_G["GuildAdsTradeColumnHeader"..i])
			end
			Skinner:removeRegions(GuildAdsGlobalAdScrollFrame)
			Skinner:skinScrollBar(GuildAdsGlobalAdScrollFrame)
			Skinner:keepRegions(GuildAdsTradeTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
			if Skinner.db.profile.TexturedTab then
				Skinner:applySkin(GuildAdsTradeTab, nil, 0, 1)
				Skinner:setActiveTab(GuildAdsTradeTab)
			else Skinner:applySkin(GuildAdsTradeTab) end
			Skinner:moveObject(GuildAdsTradeTab, nil, nil, "+", 18)
			-->>-- MyAds subFrame
			-- sort headers
			for i = 1, 6 do
				Skinner:keepRegions(_G["GuildAdsMyAdsColumnHeader"..i], {4, 5}) -- N.B. region 4 is the text, 5 is the arrow
				Skinner:applySkin(_G["GuildAdsMyAdsColumnHeader"..i])
			end
			Skinner:moveObject(GuildAdsMyAdsColumnHeader1, nil, nil, "+", 2)
			Skinner:removeRegions(GuildAdsMyAdScrollFrame)
			Skinner:skinScrollBar(GuildAdsMyAdScrollFrame)
			Skinner:skinEditBox(GuildAdsEditBox)
			Skinner:skinEditBox(GuildAdsEditCount, {6})
			-->>-- Trade Filter Frame
			Skinner:keepFontStrings(GuildAdsTradeFilterFrame)
			Skinner:moveObject(GuildAdsTradeFilterFrame, nil, nil, "-", 2)
			Skinner:applySkin(GuildAdsTradeFilterFrame)
			-- filters
			for i = 1, 15 do
				Skinner:keepRegions(_G["FilterTradeButton"..i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
				Skinner:applySkin(_G["FilterTradeButton"..i])
			end
			Skinner:removeRegions(BrowseFilterTradeScrollFrame)
			Skinner:skinScrollBar(BrowseFilterTradeScrollFrame)
			Skinner:skinEditBox(GuildAds_Filter_BrowseName, {9})
			-- hide filter texture when filter is clicked
			Skinner:SecureHook(GuildAdsTrade.filterClass, "filterButtonSetType", function(button)
			    _G[button:GetName().."NormalTexture"]:SetAlpha(0)
			end)
			Skinner:skinDropDown(GuildAds_Filter_ZoneDropDown)
			Skinner:skinDropDown(GuildAdsTradeContextMenu)
		end

	-->>-- Reputation Frame
		for	i = 1, 19 do
			local gaRB = _G["GuildAdsReputationBar"..i]
			Skinner:keepFontStrings(gaRB)
			Skinner:glazeStatusBar(gaRB, 0)
		end
		Skinner:removeRegions(GuildAdsReputationListScrollFrame)
		Skinner:skinScrollBar(GuildAdsReputationListScrollFrame)
		Skinner:moveObject(GuildAdsFactionNoneButton, nil, nil, "+", 10)
		Skinner:applySkin(GuildAdsFactionOptionsFrame)
		Skinner:keepRegions(GuildAdsFactionTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if Skinner.db.profile.TexturedTab then
			Skinner:applySkin(GuildAdsFactionTab, nil, 0, 1)
			Skinner:setInactiveTab(GuildAdsFactionTab)
		else Skinner:applySkin(GuildAdsFactionTab) end
		Skinner:moveObject(GuildAdsFactionTab, "+", 4, nil, nil)

	-->>-- Skill Frame
		-- tabs
		Skinner:skinFFToggleTabs("GuildAds_MySkillTab", 2)
		Skinner:removeRegions(GuildAdsSkillAdScrollFrame)
		Skinner:skinScrollBar(GuildAdsSkillAdScrollFrame)
		for i = 1, 21 do
			local gaSABSB = _G["GuildAdsSkillAdButton"..i.."SkillBar"]
			Skinner:glazeStatusBar(gaSABSB, 0)
			local gaSABSBB = _G["GuildAdsSkillAdButton"..i.."SkillBarBorder"]
			gaSABSBB:Hide()
		end
		Skinner:keepRegions(GuildAdsSkillTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if Skinner.db.profile.TexturedTab then
			Skinner:applySkin(GuildAdsSkillTab, nil, 0, 1)
			Skinner:setInactiveTab(GuildAdsSkillTab)
		else Skinner:applySkin(GuildAdsSkillTab) end
		Skinner:moveObject(GuildAdsSkillTab, "+", 4, nil, nil)

	-->>-- Quests Frame
		-- sort headers
		for i = 1, 5 do
			Skinner:keepRegions(_G["GuildAdsQuestColumnHeader"..i], {4, 5}) -- N.B. region 4 is the text, 5 is the arrow
			Skinner:applySkin(_G["GuildAdsQuestColumnHeader"..i])
		end
		Skinner:removeRegions(GuildAdsQuestScrollFrame)
		Skinner:skinScrollBar(GuildAdsQuestScrollFrame)
		Skinner:keepRegions(GuildAdsQuestTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if Skinner.db.profile.TexturedTab then
			Skinner:applySkin(GuildAdsQuestTab, nil, 0, 1)
			Skinner:setInactiveTab(GuildAdsQuestTab)
		else Skinner:applySkin(GuildAdsQuestTab) end
		Skinner:moveObject(GuildAdsQuestTab, "+", 4, nil, nil)

	-->>-- Guild Frame
		Skinner:skinDropDown(GuildAds_Filter_ClassDropDown)
		-- sort headers
		for i = 1, 5 do
			Skinner:keepRegions(_G["GuildAdsGuildColumnHeader"..i], {4, 5}) -- N.B. region 4 is the text, 5 is the arrow
			Skinner:applySkin(_G["GuildAdsGuildColumnHeader"..i])
		end
		Skinner:removeRegions(GuildAdsPeopleGlobalAdScrollFrame)
		Skinner:skinScrollBar(GuildAdsPeopleGlobalAdScrollFrame)
		Skinner:keepRegions(GuildAdsGuildTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if Skinner.db.profile.TexturedTab then
			Skinner:applySkin(GuildAdsGuildTab, nil, 0, 1)
			Skinner:setInactiveTab(GuildAdsGuildTab)
		else Skinner:applySkin(GuildAdsGuildTab) end
		Skinner:moveObject(GuildAdsGuildTab, "+", 4, nil, nil)

	-->>-- Forum Frame
		-- sort headers
		for i = 1, 3 do
			Skinner:keepRegions(_G["GuildAdsForumColumnHeader"..i], {4, 5}) -- N.B. region 4 is the text, 5 is the arrow
			Skinner:applySkin(_G["GuildAdsForumColumnHeader"..i])
		end
		self:removeRegions(GuildAdsForumPostLineScrollFrame)
		self:skinScrollBar(GuildAdsForumPostLineScrollFrame)
		self:skinEditBox(GuildAdsForumSubjectEditBox, {6})
		self:moveObject(GuildAdsForumSubjectEditBox, "-", 10, "+", 2)
		self:removeRegions(GuildAdsForumBodyScrollFrame)
		self:skinScrollBar(GuildAdsForumBodyScrollFrame)
		Skinner:keepRegions(GuildAdsForumTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if Skinner.db.profile.TexturedTab then
			Skinner:applySkin(GuildAdsForumTab, nil, 0, 1)
			Skinner:setInactiveTab(GuildAdsForumTab)
		else Skinner:applySkin(GuildAdsForumTab) end
		Skinner:moveObject(GuildAdsForumTab, "+", 6, nil, nil)

	-->>-- Inspect Window Frame
		Skinner:keepFontStrings(GuildAdsInspectWindowFrame)
		Skinner:moveObject(GuildAdsInspectWindowFrame, "-", 8, "+", 35)
		Skinner:applySkin(GuildAdsInspectWindowFrame)
	-->>-- Inventory Frame
		Skinner:moveObject(GuildAdsInspectHeadSlot, "+", 40, "-", 13)
		Skinner:moveObject(GuildAdsInspectHandsSlot, "+", 44, "-", 13)
		Skinner:moveObject(GuildAdsInspectMainHandSlot, "+", 42, "-", 40)
		Skinner:keepRegions(GuildAdsInventoryTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if Skinner.db.profile.TexturedTab then
			Skinner:applySkin(GuildAdsInventoryTab, nil, 0, 1)
			Skinner:setActiveTab(GuildAdsInventoryTab)
		else Skinner:applySkin(GuildAdsInventoryTab) end
		Skinner:moveObject(GuildAdsInventoryTab, nil, nil, "+", 3)
	-->>-- Talent Frame
		Skinner:keepRegions(GuildAdsTalentFrame, {6, 7, 8, 9, 10, 14, 15, 16}) -- N.B. 6-9 are the background picture, 10, 14-16 are text regions
		Skinner:moveObject(GuildAdsTalentFrame, nil, nil, "+", 20)
		GuildAdsTalentFrameTitleText:Hide()
		GuildAdsTalentFrameCloseButton:Hide()
		Skinner:removeRegions(GuildAdsTalentFrameScrollFrame)
		Skinner:skinScrollBar(GuildAdsTalentFrameScrollFrame)
		for i = 1, 5 do
			local tft = _G["GuildAdsTalentFrameTab"..i]
			Skinner:keepFontStrings(tft)
			if i ~= 1 then Skinner:moveObject(tft, "+", 12, nil, nil) end
			Skinner:applySkin(tft)
		end
		Skinner:keepRegions(GuildAdsTalentTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if Skinner.db.profile.TexturedTab then
			Skinner:applySkin(GuildAdsTalentTab, nil, 0, 1)
			Skinner:setInactiveTab(GuildAdsTalentTab)
		else Skinner:applySkin(GuildAdsTalentTab) end
		Skinner:moveObject(GuildAdsTalentTab, "+", 4, nil, nil)

	-->>-- Tooltip
		if GuildAdsGameTooltip then
			if Skinner.db.profile.Tooltips.skin then
				if Skinner.db.profile.Tooltips.style == 3 then GuildAdsGameTooltip:SetBackdrop(Skinner.backdrop) end
				Skinner:skinTooltip(GuildAdsGameTooltip)
			end
		end

	end

	local function skinGuildAdsOptions()

	-->>-- Options Frame
		if GuildAdsOptionsWindowFrame then
			GuildAdsOptionsWindowFrame:SetHeight(GuildAdsOptionsWindowFrame:GetHeight() - 160)
			GuildAdsOptionsWindowHeader:Hide()
			Skinner:moveObject(GuildAdsOptionsWindowHeader, nil, nil, "-", 6)
			Skinner:applySkin(GuildAdsOptionsWindowFrame)
		end

	-->>-- Channel Options Frame
		if GuildAdsChannelOptionsFrame then
			Skinner:skinEditBox(GuildAds_ChannelAliasEditBox, {15})
			Skinner:skinEditBox(GuildAds_ChannelCommandEditBox, {15})
			Skinner:skinEditBox(GuildAds_ChannelEditBox, {15})
			Skinner:skinEditBox(GuildAds_ChannelPasswordEditBox, {15})
			Skinner:applySkin(GuildAdsChannelOptionsFrame)
			Skinner:keepRegions(GuildAdsChannelOptionsTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
			if Skinner.db.profile.TexturedTab then
				Skinner:applySkin(GuildAdsChannelOptionsTab, nil, 0, 1)
				Skinner:setActiveTab(GuildAdsChannelOptionsTab)
			else Skinner:applySkin(GuildAdsChannelOptionsTab) end
			Skinner:moveObject(GuildAdsChannelOptionsTab, nil, nil, "+", 1)
		end

	-->>-- Trade Options Frame
		if GuildAdsTradeOptionsFrame then
			Skinner:applySkin(GuildAdsTradeOptionsFrame)
			Skinner:keepRegions(GuildAdsTradeOptionsTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
			if Skinner.db.profile.TexturedTab then
				Skinner:applySkin(GuildAdsTradeOptionsTab, nil, 0, 1)
				Skinner:setInactiveTab(GuildAdsTradeOptionsTab)
			else Skinner:applySkin(GuildAdsTradeOptionsTab) end
			Skinner:moveObject(GuildAdsTradeOptionsTab, "+", 6, nil, nil)
		end

	-->>-- MinimapButton Options Frame
		if GuildAdsMinimapButtonOptions then
			Skinner:applySkin(GuildAdsMinimapButtonOptions)
			Skinner:keepRegions(GuildAdsMinimapButtonTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
			if Skinner.db.profile.TexturedTab then
				Skinner:applySkin(GuildAdsMinimapButtonTab, nil, 0, 1)
				Skinner:setInactiveTab(GuildAdsMinimapButtonTab)
			else Skinner:applySkin(GuildAdsMinimapButtonTab) end
			Skinner:moveObject(GuildAdsMinimapButtonTab, "+", 6, nil, nil)
		end

	-->>-- Admin Options Frame
		if GuildAdsAdminOptionsFrame then
			Skinner:applySkin(GuildAdsAdminOptionsFrame)
			Skinner:keepRegions(GuildAdsAdminOptionsTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
			if Skinner.db.profile.TexturedTab then
				Skinner:applySkin(GuildAdsAdminOptionsTab, nil, 0, 1)
				Skinner:setInactiveTab(GuildAdsAdminOptionsTab)
			else Skinner:applySkin(GuildAdsAdminOptionsTab) end
			Skinner:moveObject(GuildAdsAdminOptionsTab, "+", 6, nil, nil)
		end

	end

	-- hook these so that we know when to skin the frames
	self:SecureHook(GuildAds, "ToggleMainWindow", function()
		skinGuildAdsMain()
		self:Unhook(GuildAds, "ToggleMainWindow")
	end)

	self:SecureHook(GuildAds, "ToggleOptionsWindow", function()
		skinGuildAdsOptions()
		self:Unhook(GuildAds, "ToggleOptionsWindow")
	end)

	if self.db.profile.TexturedTab then
		-- hook these to manage the tabs
		self:SecureHook(GuildAdsWindow, "SelectTab", function(this, tab)
			self:setActiveTab(tab)
		end)
		self:SecureHook(GuildAdsWindow, "DeselectTab", function(this, tab)
			self:setInactiveTab(tab)
		end)
	end

end
