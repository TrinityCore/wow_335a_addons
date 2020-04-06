local _G = _G
local ftype = "u"

-- list of Tooltips to check to see whether we should colour the Tooltip Border or not
-- use strings as the objects may not exist when we start
Skinner.ttCheck = {"GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ShoppingTooltip3", "ItemRefTooltip", "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2", "ItemRefShoppingTooltip3"}
-- list of Tooltips used when the Tooltip style is 3
-- using a metatable to manage tooltips when they are added in different functions
Skinner.ttList = setmetatable({}, {__newindex = function(t, k, v)
--    Skinner:Debug("ttList newindex: [%s, %s, %s]", t, k, v)
    rawset(t, k, v)
    -- set the backdrop if required
	if Skinner.db.profile.Tooltips.style == 3 then
	    _G[v]:SetBackdrop(Skinner.Backdrop[1])
	end
    -- hook the OnShow method
	Skinner:HookScript(_G[v], "OnShow", function(this)
		Skinner:skinTooltip(this)
		if this == GameTooltip and Skinner.db.profile.Tooltips.glazesb then
			Skinner:glazeStatusBar(GameTooltipStatusBar, 0)
		end
	end)
	Skinner:skinTooltip(_G[v]) -- skin here so tooltip initially skinnned when logged on
end})
-- Set the Tooltip Border
Skinner.ttBorder = true

function Skinner:Tooltips()
	if not self.db.profile.Tooltips.skin or self.initialized.Tooltips then return end
	self.initialized.Tooltips = true

	-- 	change the default Tooltip Border colour here
	TOOLTIP_DEFAULT_COLOR = CopyTable(self.db.profile.TooltipBorder)

	-- fix for TinyTip tooltip becoming 'fractured'
	if self.db.profile.Tooltips.style == 3 then
		local c = self.db.profile.Backdrop
		TOOLTIP_DEFAULT_BACKGROUND_COLOR = {c.r, c.g, c.b}
        -- self:setTTBackdrop(true)
	end

    -- skin Item Ref Tooltip's close button
	self:skinButton{obj=ItemRefCloseButton, cb=true}

	local counts = 0
	local GTSBevt
	local function checkGTHeight(cHeight)

		counts = counts + 1

		if cHeight ~= ceil(GameTooltip:GetHeight()) then
			Skinner:skinTooltip(GameTooltip)
			Skinner:CancelTimer(GTSBevt, true)
			GTSBevt = nil
			counts = 0
		end

		if counts == 10 or GameTooltipStatusBar:IsShown() then
			Skinner:CancelTimer(GTSBevt, true)
			GTSBevt = nil
			counts = 0
		end

	end

	-- Hook this to deal with GameTooltip FadeHeight issues
	self:HookScript(GameTooltipStatusBar, "OnHide", function(this)
		if GameTooltip:IsShown() then
			local gtH = ceil(GameTooltip:GetHeight())
			if not GTSBevt then
				GTSBevt = self:ScheduleRepeatingTimer(checkGTHeight, 0.1, gtH)
			end
		end
	end)

    -- add tooltips to table to set backdrop and hook OnShow method
    for _, tooltip in pairs(self.ttCheck) do
	    self:add2Table(self.ttList, tooltip)
    end
    self:add2Table(self.ttList, "SmallTextTooltip")

	-- Hook this to skin the GameTooltip StatusBars
	self:SecureHook("GameTooltip_ShowStatusBar", function(this, ...)
		if GameTooltipStatusBar1 then
			self:removeRegions(GameTooltipStatusBar1, {2})
			if Skinner.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(GameTooltipStatusBar1, 0)
			end
		end
		if GameTooltipStatusBar2 then
			self:removeRegions(GameTooltipStatusBar2, {2})
			if Skinner.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(GameTooltipStatusBar2, 0)
			end
			self:Unhook("GameTooltip_ShowStatusBar")
		end
	end)

end

function Skinner:MirrorTimers()
	if not self.db.profile.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	for i = 1, MIRRORTIMER_NUMTIMERS do
		local bar = "MirrorTimer"..i
		local mTimer = _G[bar]
		local mTimerText = _G[bar.."Text"]
		local mTimerBG = self:getRegion(mTimer, 1)
		local mTimerSB = _G[bar.."StatusBar"]
		self:removeRegions(mTimer, {3})
		mTimer:SetHeight(mTimer:GetHeight() * 1.25)
		self:moveObject{obj=mTimerText, y=-2}
		mTimerBG:SetWidth(mTimerBG:GetWidth() * 0.75)
		mTimerSB:SetWidth(mTimerSB:GetWidth() * 0.75)
		if self.db.profile.MirrorTimers.glaze then
			self:glazeStatusBar(mTimerSB, 0, mTimerBG)
		end
	end

end

function Skinner:CastingBar()
	if not self.db.profile.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	local modUF = self:GetModule("UnitFrames", true):IsEnabled() and self:GetModule("UnitFrames", true)
	-- hook this to move the spark down on the casting bar
	self:SecureHook("CastingBarFrame_OnUpdate", function(this, ...)
		local barSpark = _G[this:GetName().."Spark"]
		local yOfs = -3
		if this == CastingBarFrame then
		elseif this == TargetFrameSpellBar
		and modUF
		and modUF.db.profile.target
		then
		elseif this == FocusFrameSpellBar
		and modUF
		and modUF.db.profile.focus
		then
		else yOfs = 0
		end
		self:moveObject{obj=barSpark, y=yOfs}
	end)

	for _, prefix in pairs{"", "Pet"} do

		local cbfName = prefix.."CastingBarFrame"
		_G[cbfName.."Border"]:SetAlpha(0)
		self:changeShield(_G[cbfName.."BorderShield"], _G[cbfName.."Icon"])
		_G[cbfName.."Flash"]:SetAllPoints()
		self:moveObject{obj=_G[cbfName.."Text"], y=-2}
		if self.db.profile.CastingBar.glaze	then
			self:glazeStatusBar(_G[cbfName], 0, self:getRegion(_G[cbfName], 1), {_G[cbfName.."Flash"]})
		end

	end

end

function Skinner:StaticPopups()
	if not self.db.profile.StaticPopups or self.initialized.StaticPopups then return end
	self.initialized.StaticPopups = true

	if self.modBtns then
		-- hook this to handle close button texture changes
		self:SecureHook("StaticPopup_Show", function(...)
			for i = 1, STATICPOPUP_NUMDIALOGS do
				local spcb = _G["StaticPopup"..i.."CloseButton"]
				local nTex = spcb:GetNormalTexture() and spcb:GetNormalTexture():GetTexture() or nil
				if nTex:find("HideButton") then spcb:SetText(self.modBtns.minus)
				elseif nTex:find("MinimizeButton") then spcb:SetText(self.modBtns.mult)
				end
			end
		end)
	end

	for i = 1, STATICPOPUP_NUMDIALOGS do
		local sPU = "StaticPopup"..i
		self:skinEditBox{obj=_G[sPU.."EditBox"]}
		self:skinEditBox{obj=_G[sPU.."WideEditBox"]}
		self:skinMoneyFrame{obj=_G[sPU.."MoneyInputFrame"]}
		self:addSkinFrame{obj=_G[sPU], ft=ftype, x1=6, y1=-6, x2=-6, y2=6}
		-- prevent FrameLevel from being changed (LibRock does this)
		self.skinFrame[_G[sPU]].SetFrameLevel = function() end
		_G[sPU.."ItemFrameNameFrame"]:SetTexture(nil)
	end

end

function Skinner:ChatMenus()
	if not self.db.profile.ChatMenus or self.initialized.ChatMenus then return end
	self.initialized.ChatMenus = true

	self:addSkinFrame{obj=ChatMenu, ft=ftype}
	self:addSkinFrame{obj=EmoteMenu, ft=ftype}
	self:addSkinFrame{obj=LanguageMenu, ft=ftype}
	self:addSkinFrame{obj=VoiceMacroMenu, ft=ftype}
	self:addSkinFrame{obj=GeneralDockManagerOverflowButtonList, ft=ftype}

end

function Skinner:ChatTabs()
	if not self.db.profile.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	-- hook this to handle Tab alpha changes as they have been reparented
	self:SecureHook("FCFTab_UpdateAlpha", function(this)
		local chatTab = _G[this:GetName().."Tab"]
		local tabSF = self.skinFrame[chatTab]
		if chatTab.hasBeenFaded then
			tabSF:SetAlpha(chatTab.mouseOverAlpha)
		else
			tabSF:SetAlpha(chatTab.noMouseAlpha)
		end
	end)

	for i = 1, NUM_CHAT_WINDOWS do
		local tabName = _G["ChatFrame"..i.."Tab"]
		self:keepRegions(tabName, {7, 8, 9, 10, 11}) --N.B. region 7 is glow, 8-10 are highlight, 11 is text
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, y1=-8, y2=-5}
		-- hook this to fix tab gradient texture overlaying text & highlight
		self:SecureHook(tabName, "SetParent", function(this, parent)
			local tabSF = self.skinFrame[this]
			if parent == GeneralDockManager.scrollFrame.child then
				tabSF:SetParent(GeneralDockManager)
			else
				tabSF:SetParent(this)
				tabSF:SetFrameLevel(1) -- reset frame level so that the texture is behind text etc
			end
		end)
	end

end

function Skinner:ChatFrames()
	if not self.db.profile.ChatFrames or self.initialized.ChatFrames then return end
	self.initialized.ChatFrames = true

	local clqbf = "CombatLogQuickButtonFrame"
	local clqbf_c = clqbf.."_Custom"
	local yOfs1 = 4
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame"..i]
		if cf == COMBATLOG
		and _G[clqbf_c]:IsShown()
		then
			yOfs1 = 31
		else
			yOfs1 = 4
		end
		self:addSkinFrame{obj=cf, ft=ftype, x1=-4, y1=yOfs1, x2=4, y2=-8}
	end

	-- CombatLog Quick Button Frame & Progress Bar
	if self.db.profile.CombatLogQBF then
		if _G[clqbf_c] then
			self:keepFontStrings(_G[clqbf_c])
			self:addSkinFrame{obj=_G[clqbf_c], ft=ftype, x1=-4, x2=4}
			self:adjHeight{obj=_G[clqbf_c], adj=4}
			self:glazeStatusBar(_G[clqbf_c.."ProgressBar"], 0, _G[clqbf_c.."Texture"])
		else
			self:glazeStatusBar(_G[clqbf.."ProgressBar"], 0, _G[clqbf.."Texture"])
		end
	end

	-- minimized chat frames
	self:SecureHook("FCF_CreateMinimizedFrame", function(chatFrame)
		local cfm = _G[chatFrame:GetName().."Minimized"]
		self:removeRegions(cfm, {1, 2, 3})
		self:addSkinFrame{obj=cfm, ft=ftype, x1=1, y1=-2, x2=-1, y2=2}
	end)

end

function Skinner:ChatConfig()
	if not self.db.profile.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:addSkinFrame{obj=ChatConfigFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=ChatConfigCategoryFrame, ft=ftype}
	self:addSkinFrame{obj=ChatConfigBackgroundFrame, ft=ftype}

-->>--	Chat Settings
	for i = 1, #CHAT_CONFIG_CHAT_LEFT do
		_G["ChatConfigChatSettingsLeftCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigChatSettingsLeft, ft=ftype}

	self:addSkinFrame{obj=ChatConfigChatSettingsClassColorLegend, ft=ftype}

-->>--	Channel Settings
	self:SecureHook(ChatConfigChannelSettings, "Show", function(this, ...)
		for i = 1, #ChatConfigChannelSettingsLeft.checkBoxTable do
			_G["ChatConfigChannelSettingsLeftCheckBox"..i]:SetBackdrop(nil)
		end
	end)
	self:addSkinFrame{obj=ChatConfigChannelSettingsLeft, ft=ftype}
	self:addSkinFrame{obj=ChatConfigChannelSettingsClassColorLegend, ft=ftype}

-->>--	Other Settings
	for i = 1, #CHAT_CONFIG_OTHER_COMBAT do
		_G["ChatConfigOtherSettingsCombatCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsCombat, ft=ftype}

	for i = 1, #CHAT_CONFIG_OTHER_PVP do
		_G["ChatConfigOtherSettingsPVPCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsPVP, ft=ftype}

	for i = 1, #CHAT_CONFIG_OTHER_SYSTEM do
		_G["ChatConfigOtherSettingsSystemCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsSystem, ft=ftype}

	for i = 1, #CHAT_CONFIG_CHAT_CREATURE_LEFT do
		_G["ChatConfigOtherSettingsCreatureCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsCreature, ft=ftype}

-->>--	Combat Settings
	-- Filters
	ChatConfigCombatSettingsFiltersScrollFrameScrollBarBorder:Hide()
	self:skinScrollBar{obj=ChatConfigCombatSettingsFiltersScrollFrame} --, noRR=true}
	self:addSkinFrame{obj=ChatConfigCombatSettingsFilters, ft=ftype}

	-- Message Sources
	if COMBAT_CONFIG_MESSAGESOURCES_BY then
		for i = 1, #COMBAT_CONFIG_MESSAGESOURCES_BY do
			_G["CombatConfigMessageSourcesDoneByCheckBox"..i]:SetBackdrop(nil)
		end
		self:addSkinFrame{obj=CombatConfigMessageSourcesDoneBy, ft=ftype}
	end
	if COMBAT_CONFIG_MESSAGESOURCES_TO then
		for i = 1, #COMBAT_CONFIG_MESSAGESOURCES_TO do
			_G["CombatConfigMessageSourcesDoneToCheckBox"..i]:SetBackdrop(nil)
		end
		self:addSkinFrame{obj=CombatConfigMessageSourcesDoneTo, ft=ftype}
	end

	-- Colors
	for i = 1, #COMBAT_CONFIG_UNIT_COLORS do
		_G["CombatConfigColorsUnitColorsSwatch"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=CombatConfigColorsUnitColors, ft=ftype}

	local clrize, ccccObj
	for i, v in ipairs{"Highlighting", "UnitName", "SpellNames", "DamageNumber", "DamageSchool", "EntireLine"} do
		clrize = i > 1 and "Colorize" or ""
		ccccObj = _G["CombatConfigColors"..clrize..v]
		self:addSkinFrame{obj=ccccObj, ft=ftype}
	end

	-- Settings
	self:skinEditBox{obj=CombatConfigSettingsNameEditBox , regs={9}}

	-- Tabs
	for i = 1, #COMBAT_CONFIG_TABS do
		local tabName = _G["CombatConfigTab"..i]
		self:keepRegions(tabName, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
		self:addSkinFrame{obj=tabName, ft=ftype, y1=-8, y2=-4}
	end

end

function Skinner:ChatEditBox()
	-- don't use an initialized value to allow for dynamic changes
	if not self.db.profile.ChatEditBox.skin then return end

	-- these addons replace the Chat Edit Box
	if IsAddOnLoaded("NeonChat") or IsAddOnLoaded("Chatter") or IsAddOnLoaded("Prat-3.0") then return end

	for i = 1, NUM_CHAT_WINDOWS do
		local cfeb = _G["ChatFrame"..i.."EditBox"]
		if self.db.profile.ChatEditBox.style == 1 then -- Frame
			local kRegions = CopyTable(self.ebRegions)
			table.insert(kRegions, 12)
			self:keepRegions(cfeb, kRegions)
			self:addSkinFrame{obj=cfeb, ft=ftype, x1=2, y1=-2, x2=-2}
		elseif self.db.profile.ChatEditBox.style == 2 then -- Editbox
			self:skinEditBox{obj=cfeb, regs={12}, noHeight=true}
		else -- Borderless
			self:removeRegions(cfeb, {6, 7, 8})
			self:addSkinFrame{obj=cfeb, ft=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
		end
	end

end

function Skinner:LootFrame()
	if not self.db.profile.LootFrame or self.initialized.LootFrame then return end
	self.initialized.LootFrame = true

	-- shrink the size of the LootFrame
	-- move the title and close button and reduce the height of the skinFrame by 34
	self:moveObject{obj=self:getRegion(LootFrame, 3), x=-12, y=-34} -- title
	self:moveObject{obj=LootCloseButton, y=-34}
	for i = 1, LOOTFRAME_NUMBUTTONS do
		_G["LootButton"..i.."NameFrame"]:SetTexture(nil)
	end
	self:addSkinFrame{obj=LootFrame, ft=ftype, kfs=true, x1=8, y1=-47, x2=-68}

end

function Skinner:GroupLoot()
	if not self.db.profile.GroupLoot.skin or self.initialized.GroupLoot then return end
	self.initialized.GroupLoot = true

	local f = GameFontNormalSmall:GetFont()

	self:skinDropDown{obj=GroupLootDropDown}

	for i = 1, NUM_GROUP_LOOT_FRAMES do

		local glf = "GroupLootFrame"..i
		local glfo = _G[glf]
		self:keepFontStrings(glfo)
		_G[glf.."SlotTexture"]:SetTexture(self.esTex)
		_G[glf.."NameFrame"]:SetTexture(nil)
		self:removeRegions(_G[glf.."Timer"], {1})
		self:glazeStatusBar(_G[glf.."Timer"], 0)
		-- hook this to skin the group loot frame
		self:SecureHook(glfo, "Show", function(this)
			this:SetBackdrop(nil)
		end)

		if self.db.profile.GroupLoot.size == 1 then

			self:addSkinFrame{obj=glfo, ft=ftype, x1=4, y1=-5, x2=-4, y2=5}

		elseif self.db.profile.GroupLoot.size == 2 then

			glfo:SetScale(0.75)
			self:addSkinFrame{obj=glfo, ft=ftype, x1=4, y1=-5, x2=-4, y2=5}

		elseif self.db.profile.GroupLoot.size == 3 then

			glfo:SetScale(0.75)
			self:moveObject{obj=_G[glf.."SlotTexture"], x=95, y=4} -- Loot item icon
			_G[glf.."Name"]:SetAlpha(0)
			_G[glf.."RollButton"]:ClearAllPoints()
			_G[glf.."RollButton"]:SetPoint("RIGHT", _G[glf.."PassButton"], "LEFT", 5, -5)
			_G[glf.."GreedButton"]:ClearAllPoints()
			_G[glf.."GreedButton"]:SetPoint("RIGHT", _G[glf.."RollButton"], "LEFT", 0, 0)
			_G[glf.."DisenchantButton"]:ClearAllPoints()
			_G[glf.."DisenchantButton"]:SetPoint("RIGHT", _G[glf.."GreedButton"], "LEFT", 0, 0)
			self:adjWidth{obj=_G[glf.."Timer"], adj=-28}
			self:moveObject{obj=_G[glf.."Timer"], x=-3}
			self:addSkinFrame{obj=glfo, ft=ftype, x1=102, y1=-5, x2=-4, y2=16}

		end

	end

end

function Skinner:ContainerFrames()
	if not self.db.profile.ContainerFrames.skin or self.initialized.ContainerFrames then return end
	self.initialized.ContainerFrames = true

	for i = 1, NUM_CONTAINER_FRAMES do
		local frameObj = _G["ContainerFrame"..i]
		self:addSkinFrame{obj=frameObj, ft=ftype, kfs=true, x1=8, y1=-4, x2=-3}
		-- resize and move the bag name to make it more readable
		local frameName = _G["ContainerFrame"..i.."Name"]
		frameName:SetWidth(145)
		self:moveObject{obj=frameName, x=-30}
	end

end

function Skinner:StackSplit()
	if not self.db.profile.StackSplit or self.initialized.StackSplit then return end
	self.initialized.StackSplit = true

	-- handle different addons being loaded
	if IsAddOnLoaded("EnhancedStackSplit") then
		self:addSkinFrame{obj=StackSplitFrame, ft=ftype, kfs=true, y2=-24}
	else
		self:addSkinFrame{obj=StackSplitFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}
	end

end

function Skinner:ItemText()
	if not self.db.profile.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	self:SecureHookScript(ItemTextFrame, "OnShow", function(this)
		ItemTextPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)

	self:skinScrollBar{obj=ItemTextScrollFrame}
	self:glazeStatusBar(ItemTextStatusBar, 0)
	self:moveObject{obj=ItemTextPrevPageButton, x=-55} -- move prev button left
	self:addSkinFrame{obj=ItemTextFrame, ft=ftype, kfs=true, x1=10, y1=-13, x2=-32, y2=71}

end

function Skinner:ColorPicker()
	if not self.db.profile.Colours or self.initialized.Colours then return end
	self.initialized.Colours = true

	ColorPickerFrame:SetBackdrop(nil)
	ColorPickerFrameHeader:SetAlpha(0)
	self:skinSlider(OpacitySliderFrame, 4)
	self:addSkinFrame{obj=ColorPickerFrame, ft=ftype, x1=4, y1=2, x2=-6, y2=4}

-->>-- Opacity Frame, used by BattlefieldMinimap amongst others
	OpacityFrame:SetBackdrop(nil)
	self:skinSlider{obj=OpacityFrameSlider, size=3}
	self:addSkinFrame{obj=OpacityFrame, ft=ftype}

end

function Skinner:WorldMap()
	if not self.db.profile.WorldMap.skin or self.initialized.WorldMap then return end
	self.initialized.WorldMap = true

	if not IsAddOnLoaded("Mapster")
	and not IsAddOnLoaded("AlleyMap")
	then
		local function sizeUp()

			self.skinFrame[WorldMapFrame]:ClearAllPoints()
			self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 102, 1)
			self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", -102, 1)

		end
		local function sizeDown()

			if not WORLDMAP_SETTINGS.advanced then -- frame not moveable
				x1, y1, x2, y2 = 12, -12, -20, -10
			else -- frame moveable
				x1, y1, x2, y2 = 0, 2, 0, 0
			end
			self.skinFrame[WorldMapFrame]:ClearAllPoints()
			self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", x1, y1)
			self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", x2, y2)

		end
		-- handle size change
		self:SecureHook("WorldMap_ToggleSizeUp", function()
			sizeUp()
		end)
		self:SecureHook("WorldMap_ToggleSizeDown", function()
			sizeDown()
		end)
		self:SecureHook("WorldMapFrame_ToggleAdvanced", function()
			if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE -- Patch
			then
				sizeDown()
			end
		end)
		-- handle different map addons being loaded or fullscreen required
		if self.db.profile.WorldMap.size == 2 then
			self:addSkinFrame{obj=WorldMapFrame, ft=ftype, kfs=true, y1=1, x2=1}
		elseif not IsAddOnLoaded("MetaMap") and not IsAddOnLoaded("Cartographer_LookNFeel") then
			self:addSkinFrame{obj=WorldMapFrame, ft=ftype, kfs=true}
			if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE -- Patch
			then
				sizeDown()
			else
				sizeUp()
			end
		end
	end

	-- textures removed as they are shown and alphas are changed
	WorldMapFrameMiniBorderLeft:SetTexture(nil)
	WorldMapFrameMiniBorderRight:SetTexture(nil)

	self:skinDropDown{obj=WorldMapContinentDropDown}
	self:skinDropDown{obj=WorldMapZoneDropDown}
	self:skinDropDown{obj=WorldMapZoneMinimapDropDown}
	self:skinDropDown{obj=WorldMapLevelDropDown}
	if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE
	then
		self:skinButton{obj=WorldMapFrameCloseButton, cb=true}
	else
		self:skinButton{obj=WorldMapFrameCloseButton, cb=true}
	end
	self:skinScrollBar{obj=WorldMapQuestScrollFrame}
	self:skinScrollBar{obj=WorldMapQuestDetailScrollFrame}
	self:skinScrollBar{obj=WorldMapQuestRewardScrollFrame}

-->>-- Tooltip(s)
	if self.db.profile.Tooltips.skin
	and self.db.profile.Tooltips.style == 3
	then
	    self:add2Table(self.ttList, "WorldMapTooltip")
	    self:add2Table(self.ttList, "WorldMapCompareTooltip1")
	    self:add2Table(self.ttList, "WorldMapCompareTooltip2")
	    self:add2Table(self.ttList, "WorldMapCompareTooltip3")
	end

end

function Skinner:HelpFrame()
	if not self.db.profile.HelpFrame or self.initialized.HelpFrame then return end
	self.initialized.HelpFrame = true

	local hfTitle = self:getRegion(HelpFrame, 11)
	local kbTitle = self:getRegion(KnowledgeBaseFrame, 2)
	-- hook these to manage frame titles
	self:SecureHook("HelpFrame_ShowFrame", function(key)
		hfTitle:SetAlpha(0)
		kbTitle:SetAlpha(0)
		if key == "KBase" then
			kbTitle:SetAlpha(1)
		else
			hfTitle:SetAlpha(1)
		end
	end)
	self:SecureHook("HelpFrame_PopFrame", function()
		if HelpFrame.openFrame and HelpFrame.openFrame:GetName() == "KnowledgeBaseFrame" then
			hfTitle:SetAlpha(0)
			kbTitle:SetAlpha(1)
		end
	end)

-->>--	Ticket Status Frame
	self:addSkinFrame{obj=TicketStatusFrameButton, ft=ftype}

-->>--	Help Frame
	self:moveObject{obj=hfTitle, y=-8}
	self:addSkinFrame{obj=HelpFrame, ft=ftype, kfs=true, x1=6, y1=-6, x2=-45, y2=14}

-->>--	KnowledgeBase Frame
	self:keepFontStrings(KnowledgeBaseFrame)
	self:moveObject{obj=kbTitle, y=-8}
	self:skinButton{obj=GMChatOpenLog}
	self:skinEditBox{obj=KnowledgeBaseFrameEditBox}
	self:skinDropDown{obj=KnowledgeBaseFrameCategoryDropDown}
	self:skinDropDown{obj=KnowledgeBaseFrameSubCategoryDropDown}
	KnowledgeBaseFrameDivider:Hide()
	KnowledgeBaseFrameDivider2:Hide()
-->>-- Article Scroll Frame
	self:skinScrollBar{obj=KnowledgeBaseArticleScrollFrame}
	self:skinButton{obj=KnowledgeBaseArticleScrollChildFrameBackButton, as=true}
-->>-- Talk to a GM panel
-->>-- Report an Issue panel
-->>-- Character Stuck panel
-->>--	Open Ticket SubFrame
	HelpFrameOpenTicketDivider:Hide()
	self:skinScrollBar{obj=HelpFrameOpenTicketScrollFrame}
-->>-- View Response SubFrame
	self:skinScrollBar{obj=HelpFrameViewResponseIssueScrollFrame}
	HelpFrameViewResponseDivider:Hide()
	self:skinScrollBar{obj=HelpFrameViewResponseMessageScrollFrame}

end

function Skinner:Tutorial()
	if not self.db.profile.Tutorial then return end

	TutorialFrame:DisableDrawLayer("BACKGROUND")
	TutorialFrame:DisableDrawLayer("BORDER")
	TutorialTextBorder:SetAlpha(0)
	self:skinScrollBar{obj=TutorialFrameTextScrollFrame}
	self:addSkinFrame{obj=TutorialFrame, ft=ftype, x1=10, y1=-11, x2=1}

	-- skin the alert button(s)
	self:addSkinButton{obj=_G["TutorialFrameAlertButton"], parent=_G["TutorialFrameAlertButton"], x1=-3, y1=5, x2=5, y2=-3}

end

function Skinner:GMSurveyUI()
	if not self.db.profile.GMSurveyUI or self.initialized.GMSurveyUI then return end
	self.initialized.GMSurveyUI = true

	self:keepFontStrings(GMSurveyHeader)
	self:moveObject{obj=GMSurveyHeaderText, y=-8}
	self:addSkinFrame{obj=GMSurveyFrame, ft=ftype, kfs=true, y1=-6, x2=-45}

	self:skinScrollBar{obj=GMSurveyScrollFrame}

	for i = 1, MAX_SURVEY_QUESTIONS do
		local gmsQ = _G["GMSurveyQuestion"..i]
		self:applySkin{obj=gmsQ, ft=ftype} -- must use applySkin otherwise text is behind gradient
		gmsQ.SetBackdropColor = function() end
		gmsQ.SetBackdropBorderColor = function() end
	end

	self:skinScrollBar{obj=GMSurveyCommentScrollFrame}
	self:applySkin{obj=GMSurveyCommentFrame, ft=ftype} -- must use applySkin otherwise text is behind gradient

end

function Skinner:InspectUI()
	if not self.db.profile.InspectUI or self.initialized.InspectUI then return end
	self.initialized.InspectUI = true

	self:addSkinFrame{obj=InspectFrame, ft=ftype, kfs=true, x1=10, y1=-12, x2=-32, y2=69}

	-- Inspect Model Frame
	self:keepRegions(InspectPaperDollFrame, {5, 6, 7}) -- N.B. regions 5-7 are text
	self:makeMFRotatable(InspectModelFrame)

-->>--	PVP Frame
	self:keepFontStrings(InspectPVPFrame)
	for i = 1, 3 do
		_G["InspectPVPTeam"..i.."StandardBar"]:Hide()
		self:addSkinFrame{obj=_G["InspectPVPTeam"..i], hat=true, x1=-40, y1=4, x2=-20, y2=-4}
	end

-->>--	Talent Frame
	self:keepRegions(InspectTalentFrame, {6, 7, 8, 9, 10}) -- N.B. 6, 7, 8 & 9 are the background picture, 10 is text
	InspectTalentFrameCloseButton:Hide()
	self:skinScrollBar{obj=InspectTalentFrameScrollFrame}
	self:keepFontStrings(InspectTalentFramePointsBar)
	self:skinFFToggleTabs("InspectTalentFrameTab")
	self:moveObject{obj=InspectTalentFrameTab1, x=-30}

-->>--	Frame Tabs
	for i = 1, InspectFrame.numTabs do
		local tabName = _G["InspectFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[InspectFrame] = true

end

function Skinner:WorldState()
	if not self.db.profile.BattleScore or self.initialized.BattleScore then return end
	self.initialized.BattleScore = true

	self:skinScrollBar{obj=WorldStateScoreScrollFrame}
	self:addSkinFrame{obj=WorldStateScoreFrame, ft=ftype, kfs=true, x1=10, y1=-15, x2=-113, y2=70}

-->>-- Tabs
	for i = 1, 3 do
		local tabName = _G["WorldStateScoreFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=7, y1=8, x2=-7, y2=10}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[WorldStateScoreFrame] = true

end

function Skinner:BattlefieldMinimap()
	if not self.db.profile.BattlefieldMm or self.initialized.BattlefieldMm then return end
	self.initialized.BattlefieldMm = true

	-- change the skinFrame's opacity as required
	self:SecureHook("BattlefieldMinimap_UpdateOpacity", function(opacity)
		local alpha = 1.0 - BattlefieldMinimapOptions.opacity
		if ( alpha >= 0.15 ) then alpha = alpha - 0.15 end
		self.skinFrame[BattlefieldMinimap]:SetAlpha(alpha)
		self.skinFrame[BattlefieldMinimap].tfade:SetAlpha(alpha)
	end)

-->>--	Minimap Tab
	self:keepRegions(BattlefieldMinimapTab, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
	asopts = self.isTT and {ba=1} or nil
	self:addSkinFrame{obj=BattlefieldMinimapTab, ft=ftype, noBdr=self.isTT, aso=asopts, y1=-7, y2=-7}
	self:moveObject{obj=BattlefieldMinimapTabText, y=-1} -- move text down
-->>--	Minimap
	-- change the draw layer so that the map is visible
	for i = 1, NUM_WORLDMAP_DETAIL_TILES do
		_G["BattlefieldMinimap"..i]:SetDrawLayer("ARTWORK")
	end

	-- Create a frame to skin as using the BattlefieldMinimap one causes issues with Capping
	self:addSkinFrame{obj=BattlefieldMinimap, ft=ftype, bg=true, x1=-4, y1=4, x2=-2, y2=-1}
	-- hide the textures as the alpha values are changed in game
	BattlefieldMinimapCorner:Hide()
	BattlefieldMinimapBackground:Hide()

	if IsAddOnLoaded("Capping") then
		if type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
	end

end

function Skinner:ScriptErrors()
	if not self.db.profile.ScriptErrors or self.initialized.ScriptErrors then return end
	self.initialized.ScriptErrors = true

	-- skin Basic Script Errors Frame (BasicControls.xml)
	self:addSkinFrame{obj=BasicScriptErrors, kfs=true, ft=ftype}

end

function Skinner:DropDowns()
	if not self.db.profile.DropDowns or self.initialized.DropDowns then return end
	self.initialized.DropDowns = true

	self:SecureHook("UIDropDownMenu_CreateFrames", function(level, index)
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			local ddl = "DropDownList"..i
			local ddlObj = _G[ddl]
			if not self:IsHooked(ddlObj, "Show") then
				self:SecureHook(ddlObj, "Show", function()
					_G[ddl.."Backdrop"]:Hide()
					_G[ddl.."MenuBackdrop"]:Hide()
					if not self.skinFrame[ddlObj] then
						self:addSkinFrame{obj=ddlObj, ft=ftype, kfs=true}
					end
				end)
			end
		end
	end)

end

function Skinner:MinimapButtons()
	if not self.db.profile.MinimapButtons or self.initialized.MinimapButtons then return end
	self.initialized.MinimapButtons = true

	local minBtn = self.db.profile.MinimalMMBtns

	local function mmKids(mmObj)

		local mmObjName = mmObj.GetName and mmObj:GetName() or "<Anon>"

		for i = 1, mmObj:GetNumChildren() do
			local obj = select(i, mmObj:GetChildren())
			local objName = obj:GetName()
			local objType = obj:GetObjectType()
			if not (Skinner.sBut[obj] or Skinner.skinFrame[obj]) and objName
			and (objType == "Button" or objType == "Frame" and objName == "MiniMapMailFrame") then
				for i = 1, obj:GetNumRegions() do
					local reg = select(i, obj:GetRegions())
					if reg:GetObjectType() == "Texture" then
						local regName = reg:GetName()
						local regTex = reg:GetTexture()
						local regDL = reg:GetDrawLayer()
						-- change the DrawLayer to make the Icon show if required
						if (regName and regName:find("[Ii]con"))
						or (regTex and regTex:find("[Ii]con")) then
							if regDL == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
							-- centre the icon
							reg:ClearAllPoints()
							reg:SetPoint("CENTER")
						elseif (regName and regName:find("Border"))
						or (regTex and regTex:find("TrackingBorder")) then
							reg:SetTexture(nil)
							obj:SetWidth(32)
							obj:SetHeight(32)
							if not minBtn then
								if objType == "Button" then
									Skinner:addSkinButton{obj=obj, parent=obj, sap=true}
								else
									Skinner:addSkinFrame{obj=obj, ft=ftype}
								end
							end
						end
					end
				end
			elseif objName and objType == "Frame" then
				mmKids(obj)
			end
		end

	end

	-- skin Minimap children
	mmKids(Minimap)

	-- skin other Blizzard buttons
	if not minBtn then
		for _, obj in pairs{GameTimeFrame, MinimapZoomIn, MinimapZoomOut} do
			self:addSkinButton{obj=obj, parent=obj, sap=true}
		end
	end
	-- change Mail icon
	MiniMapMailIcon:SetTexture([[Interface\Minimap\Tracking\Mailbox.blp]])
	-- resize other buttons
	MiniMapMailFrame:SetWidth(28)
	MiniMapMailFrame:SetHeight(28)
	GameTimeFrame:SetWidth(36)
	GameTimeFrame:SetHeight(36)
	MiniMapVoiceChatFrame:SetWidth(32)
	MiniMapVoiceChatFrame:SetHeight(32)
	MiniMapVoiceChatFrameIcon:ClearAllPoints()
	MiniMapVoiceChatFrameIcon:SetPoint("CENTER")

	-- MiniMap Tracking button
	MiniMapTracking:DisableDrawLayer("BACKGROUND")
	MiniMapTrackingIcon:SetParent(MiniMapTrackingButton)
	MiniMapTrackingIcon:ClearAllPoints()
	MiniMapTrackingIcon:SetPoint("CENTER")
	-- change this to stop the icon being moved
	MiniMapTrackingIcon.SetPoint = function() end

	-- move GameTime a.k.a. Calendar texture up a layer
	GameTimeFrame:GetNormalTexture():SetDrawLayer("BORDER")
	GameTimeFrame:GetPushedTexture():SetDrawLayer("BORDER")
	GameTimeFrame:GetFontString():SetDrawLayer("BORDER")

	-- skin any moved Minimap buttons if required
	if IsAddOnLoaded("MinimapButtonFrame") then mmKids(MinimapButtonFrame) end

	-- show the Bongos minimap icon if required
	if IsAddOnLoaded("Bongos") then Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK") end

	-- skin other minimap buttons as required
	if not minBtn then
		local mmButs = {
			["SmartBuff"] = SmartBuff_MiniMapButton,
			["WebDKP"] = WebDKP_MinimapButton,
			["GuildAds"] = GuildAdsMinimapButton,
			["Outfitter"] = OutfitterMinimapButton,
			["Perl_Config"] = PerlButton,
			["WIM"] = WIM3MinimapButton,
			["DBM-Core"] = DBMMinimapButton,
		}
		for addon, obj in pairs(mmButs) do
			if IsAddOnLoaded(addon) then
				self:addSkinButton{obj=obj, parent=obj, sap=true}
			end
		end
		mmButs = nil
	end

end

if Skinner.isPTR then
	function Skinner:FeedbackUI()
		if not self.db.profile.Feedback or self.initialized.Feedback then return end
		self.initialized.Feedback = true

		local bbR, bbG, bbB, bbA = unpack(self.bbColour)

		self:keepFontStrings(FeedbackUITitleFrm)
		FeedbackUIWelcomeFrame:SetBackdrop(nil)
		self:keepFontStrings(FeedbackUI_ModifierKeyDropDown)
		self:addSkinFrame{obj=FeedbackUI_ModifierKeyDropDownList, ft=ftype}
		self:keepFontStrings(FeedbackUI_MouseButtonDropDown)
		self:addSkinFrame{obj=FeedbackUI_MouseButtonDropDownList, ft=ftype}
--[=[
		self:skinButton{obj=FeedbackUIBtnClose, cb=true}
		self:skinButton{obj=FeedbackUIWelcomeFrameSurveysBtn}
		self:skinButton{obj=FeedbackUIWelcomeFrameSuggestionsBtn}
		self:skinButton{obj=FeedbackUIWelcomeFrameBugsBtn}
--]=]
		self:addSkinFrame{obj=FeedbackUI, ft=ftype, kfs=true}

	-->-- Survey Frame
		FeedbackUISurveyFrame:SetBackdrop(nil)
		self:keepFontStrings(FeedbackUISurveyFrameSurveysPanelDdlCategory)
		self:addSkinFrame{obj=FeedbackUISurveyFrameSurveysPanelDdlCategoryList, ft=ftype}
		self:keepFontStrings(FeedbackUISurveyFrameSurveysPanelDdlStatus)
		self:addSkinFrame{obj=FeedbackUISurveyFrameSurveysPanelDdlStatusList, ft=ftype}
		FeedbackUISurveyFrameSurveysPanelHeadersColumnUnderline:SetAlpha(0)
		for i = 1, 8 do
			self:skinButton{obj=_G["FeedbackUISurveyFrameSurveysPanelScrollButtonsOption"..i.."Btn"], mp2=true}
		end
		self:skinUsingBD{obj=FeedbackUISurveyFrameSurveysPanelScrollScrollControls, size=3}
		FeedbackUISurveyFrameSurveysPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISurveyFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISurveyFrameStatusPanelLine:SetAlpha(0)
		FeedbackUISurveyFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		self:addSkinFrame{obj=FeedbackUISurveyFrameStepThroughPanelHeader, ft=ftype, x1=1, y1=-1, x2=-1, y2=1}
		self:addSkinFrame{obj=FeedbackUISurveyFrameStepThroughPanelEdit, ft=ftype}
		self:skinScrollBar{obj=FeedbackUISurveyFrameStepThroughPanelEditInput}
		self:skinUsingBD{obj=FeedbackUISurveyFrameStepThroughPanelScrollScrollControls, size=3}
--[=[
		self:skinButton{obj=FeedbackUISurveyFrameBack}
		self:skinButton{obj=FeedbackUISurveyFrameSkip}
		self:skinButton{obj=FeedbackUISurveyFrameReset}
		self:skinButton{obj=FeedbackUISurveyFrameSubmit}
--]=]
		-- skin the alert buttons
		for i = 1, 10 do
			local tfabObj = _G["FeedbackUISurveyFrameSurveysPanelAlertFrameButton"..i]
			self:addSkinButton{obj=tfabObj, parent=tfabObj, x1=-2, y1=2, x2=1, y2=1}
		end

	-->>-- Suggestion Frame
		FeedbackUISuggestFrame:SetBackdrop(nil)
		FeedbackUISuggestFrameInfoPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISuggestFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISuggestFrameStatusPanelLine:SetAlpha(0)
		FeedbackUISuggestFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		self:addSkinFrame{obj=FeedbackUISuggestFrameStepThroughPanelHeader, ft=ftype, x1=1, y1=-1, x2=-1, y2=1}
		self:addSkinFrame{obj=FeedbackUISuggestFrameStepThroughPanelEdit, ft=ftype}
		self:skinScrollBar{obj=FeedbackUISuggestFrameStepThroughPanelEditInput}
		self:skinUsingBD{obj=FeedbackUISuggestFrameStepThroughPanelScrollScrollControls, size=3}
--[=[
		self:skinButton{obj=FeedbackUISuggestFrameBack}
		self:skinButton{obj=FeedbackUISuggestFrameReset}
		self:skinButton{obj=FeedbackUISuggestFrameSubmit}
--]=]

	-->>-- Bug Frame
		FeedbackUIBugFrame:SetBackdrop(nil)
		FeedbackUIBugFrameInfoPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUIBugFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUIBugFrameStatusPanelLine:SetAlpha(0)
		FeedbackUIBugFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		self:addSkinFrame{obj=FeedbackUIBugFrameStepThroughPanelHeader, ft=ftype, x1=1, y1=-1, x2=-1, y2=1}
		self:addSkinFrame{obj=FeedbackUIBugFrameStepThroughPanelEdit, ft=ftype}
		self:skinScrollBar{obj=FeedbackUIBugFrameStepThroughPanelEditInput}
		self:skinUsingBD{obj=FeedbackUIBugFrameStepThroughPanelScrollScrollControls, size=3}
--[=[
		self:skinButton{obj=FeedbackUIBugFrameBack}
		self:skinButton{obj=FeedbackUIBugFrameReset}
		self:skinButton{obj=FeedbackUIBugFrameSubmit}
--]=]

		-- make the QuestLog Tip Label text visible
		FeedbackUIQuestLogTipLabel:SetTextColor(self.BTr, self.BTg, self.BTb)

	end
end
