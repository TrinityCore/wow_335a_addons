-- $Date: 2009-09-12 14:00:55 -0400 (Sat, 12 Sep 2009) $
SBFOptions  = LibStub("AceAddon-3.0"):NewAddon("SBFOptions", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

SBFOptions.strings = {}
SBFOptions.optionsElapsed = 0
SBFOptions.curFrame = SBF.frames[1]
SBFOptions.curTab = 1
SBFOptions.dirty = false

local ColourFrame = LibStub and LibStub:GetLibrary('LibColourFrame-1.0')
local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')

local self = SBFOptions

SBFOptions.OnInitialize = function(self)
	UIPanelWindows["SatrinaBuffFrameOptions"] =		{ area = "center",	pushable = 0,	whileDead = 1 }
	SBFONewFrameButton:SetFormattedText(self.strings.NEWFRAME)
	SBFORemoveFrameButton:SetFormattedText(self.strings.REMOVEFRAME)
	
  self:GeneralTabInitialise()
  self:IconTabInitialise()
  self:CountTabInitialise()
  self:TimerTabInitialise()
  self:BarTabInitialise()
  self:NameTabInitialise()
  self:LayoutTabInitialise()
  self:ExpiryTabInitialise()
  self:FlowTabInitialise()
  self:FilterTabInitialise()
  self:SpellTabInitialise()
  
  SBFOptions:SetupFrameLevelWindow()
  
	SBFOFilterEditButton:SetFormattedText(self.strings.EDIT)
	SBFOFilterRemoveButton:SetFormattedText(self.strings.REMOVE)
	SBFOClearSpellsButton:SetFormattedText(self.strings.CLEARSPELLS)
	
  SBFOResetButton:SetFormattedText(self.strings.RESET)
	SBFOVersionString:SetFormattedText(self.strings.VERSION2, SBF.versionStr)
	SBFOHint:SetFormattedText(self.strings.HINT)
	SBFOHint2:SetFormattedText(self.strings.HINT2)
	SBFOHint3:SetFormattedText(self.strings.HINT3)
	SBFOGlobalConfigButton.text:SetFormattedText(self.strings.GLOBALCONFIG)
	SBFOProfileConfigButton.text:SetFormattedText(self.strings.PROFILECONFIG)
	SBFOFilterConfigButton.text:SetFormattedText(self.strings.FILTERCONFIG)
	SBFOSpellsConfigButton.text:SetFormattedText(self.strings.SPELLCONFIG)
	SBFOFilterEditButton:Disable()

	self.tabs = { SBFOGeneralTab, SBFOLayoutTab, SBFOIconTab, SBFOTimerTab, SBFOCountTab, SBFOBarTab, SBFONameTab, 
                SBFOExpiryTab, SBFOFilterTab, SBFOSpellTab, SBFOFlowTab, SBFOGlobalTab, SBFOProfileTab }
	
  SBFOTabsFrame:SetBackdropColor(0,0,0,1)
  -- SBFOPositionWindow:SetBackdropColor(0,0,0,1)
  
 
	SBFOBuffFilterEdit.label:SetFormattedText(self.strings.FILTER)
  SBFOSpellFilterEdit.label:SetFormattedText(self.strings.SPELLFILTER)
	SBFOAddFilterButton:SetFormattedText(self.strings.ADDFILTER)
	SBFOFilterHelpButton:SetFormattedText(self.strings.FILTERHELP)

	SBFOShowBuffsCheckButtonText:SetFormattedText(self.strings.SHOWBUFFS)
	SBFOShowDebuffsCheckButtonText:SetFormattedText(self.strings.SHOWDEBUFFS)

	SBFOAuraMaxTimeCheckButtonText:SetFormattedText(self.strings.AURAMAXTIME)
	SBFOEnchantsFirstCheckButtonText:SetFormattedText(self.strings.ENCHANTSFIRST)
	SBFOTrackingCheckButtonText:SetFormattedText(self.strings.TRACKING)
  SBFOTotemTimersButtonText:SetFormattedText(self.strings.TOTEMTIMERS)

  SBFOPositionWindowBottom:SetFormattedText(self.strings.POSITIONBOTTOM)

	SBFOShowBuffsCheckButton:SetChecked(true)
	SBFOShowDebuffsCheckButton:SetChecked(false)

	for k,v in pairs(SBF.db.profile.frames) do
		if v.timer then
      ColourFrame:AddCopy(nil, v.timer.regularColour.r, v.timer.regularColour.g, v.timer.regularColour.b)
      ColourFrame:AddCopy(nil, v.timer.expiringColour.r, v.timer.expiringColour.g, v.timer.expiringColour.b)
    end
		if v.count then
      ColourFrame:AddCopy(nil, v.count.colour.r, v.count.colour.g, v.count.colour.b)
    end
		if v.bar then
      ColourFrame:AddCopy(nil, v.bar.buffColour.r, v.bar.buffColour.g, v.bar.buffColour.b)
      ColourFrame:AddCopy(nil, v.bar.debuffColour.r, v.bar.debuffColour.g, v.bar.debuffColour.b)
      ColourFrame:AddCopy(nil, v.bar.bgColour.r, v.bar.bgColour.g, v.bar.bgColour.b)
    end
    if v.name then
      ColourFrame:AddCopy(nil, v.name.buffColour.r, v.name.buffColour.g, v.name.buffColour.b)
    end
		ColourFrame:AddCopy(nil, v.expiry.sctColour.r, v.expiry.sctColour.g, v.expiry.sctColour.b)
	end
	
  self:InitScrollingDropDowns()
 
  self.cacheSize = 0
end

SBFOptions.DropDownCallback = function(obj)
  ScrollingDropDown:Open(obj:GetParent())
end

SBFOptions.Reset = function(self)
  SBF.db:ResetProfile()
  SBF:DoSavedVars()
  SBF:CreateFrames()
  SBF:SetupFrames()
  SBFOptions:SetupFrames()
	SBFOptions:SelectFrame(1)
end

SBFOptions.SelectTab = function(self, tab)
	self.tabchange = true
  
  if tab then
		SBFOptions.curTab = tab
	end

  SBFOHelpFrame:Hide()

  if (tab > 10) then
    SBFOBuffFrameDropDown:Hide()
    SBFOCurrentFrameString:Hide()
  else
    SBFOBuffFrameDropDown:Show()
    SBFOCurrentFrameString:Show()
  end
  
  if (tab == SBFOSpellsConfigButton:GetID()) then
    SBFOptions:SpellTabSelectTab()
  elseif (tab == SBFOFilterConfigButton:GetID()) then
    SBFOptions:FilterTabSelectTab()
  elseif (tab == SBFOGlobalConfigButton:GetID()) then
    self:GlobalTabSelectTab()
  elseif (tab == SBFOProfileConfigButton:GetID()) then
    self:ProfileTabSelectTab()
  end
  
  self:AttachPositionWindow()
  self:AttachFrameLevelWindow()
  
	for k,v in pairs(SBFOptions.tabs) do
		if (k == SBFOptions.curTab) then
			v:Show()
		else
			v:Hide()
		end
	end
  self.tabchange = false
end

SBFOptions.SelectFrame = function(self, f)
	self.framechange = true
  if f then
    if type(f) == "number" then
      self.curFrame = SBF.frames[f]
    else
      self.curFrame = f
    end
	end
	
  local var = self.curFrame._var
  
	for k,frame in pairs(SBF.frames) do
		if (frame == self.curFrame) then
			frame.tab1.label:SetTextColor(0,1,0)
			frame.tab2.label:SetTextColor(0,1,0)
		else
			frame.tab1.label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			frame.tab2.label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		end
	end
  self:SetFrameNames(self.curFrame)
  self.firstBuff = self.curFrame.slots[1]
  
	self.curFrame.extent = nil
	self:IconTabSelectFrame(var)
	self:CountTabSelectFrame(var)
	self:TimerTabSelectFrame(var)
	self:BarTabSelectFrame(var)
	self:NameTabSelectFrame(var)
	self:ExpiryTabSelectFrame(var)
	self:LayoutTabSelectFrame(var)
	self:GeneralTabSelectFrame(var)
	self:SpellTabSelectFrame(var)
	self:FilterTabSelectFrame(var)

	self:FlowTabSelectFrame(SBF.db.profile)
  
  self:InitialiseGlobalDropDowns()
  SBFOCurrentFrameString:SetFormattedText(self.strings.CURRENTFRAME, self.curFrame.id)
  self:AttachPositionWindow()
  self:AttachFrameLevelWindow()

	ScrollingDropDown:SetSelected(SBFOBuffFrameDropDown, SBFOptions.curFrame.id, ScrollingDropDown.VALUE)
  self.framechange = false
end

SBFOptions.InitialiseGlobalDropDowns = function(self)
	self:BuffFrameDropDown_Initialise()
end

SBFOptions.InitScrollingDropDowns = function(self)
	self:BarTextureDropDown_Initialise()
	self:BarBGTextureDropDown_Initialise()
	self:BuffSortDropDown_Initialise()
	self:FrameVisibilityDropDown_Initialise()
	self:SoundWarningDropDown_Initialise()
	self:MinTimeDropDown_Initialise()
	self:ExpireTimeDropDown_Initialise()
	self:ExpireFrameDropDown_Initialise()
	self:NameFontDropDown_Initialise()
	self:CountFontDropDown_Initialise()
	self:TimerDropDown_Initialise()
	self:TimerFontDropDown_Initialise()
end


SBFOptions.ShowOptions = function(self)
	SBF.showingOptions = 1
	self:SetupFrames()
	self:GlobalTabInitialise()
	self:ProfileTabInitialise()
	self:SelectFrame(1)
	self:SelectTab(1)
	SBF:FrameVisibility()
	ShowUIPanel(SatrinaBuffFrameOptions)
end

SBFOptions.CloseOptions = function(self)
	self:CancelTimer(self.timer)
  self:HideDragTabs()
  SBF:CloseOptions()
end

SBFOptions.SetupFrames = function(self, leaveSlots)
	for index,frame in pairs(SBF.frames) do
		self:SetupFrame(frame, leaveSlots)
	end
  SBF:UpdateDurations(1)
end

SBFOptions.SetupFrame = function(self, frame, leaveSlots)
	self:MakeBuffs(frame)
  SBF:SetupFrame(frame, leaveSlots)
  SBF:FrameShowBuffs(frame)
	self:ShowDragTabs(frame)
  self:ShowAnchors(frame)
end

SBFOptions.ShowAnchors = function(self, frame)
  for i,slot in ipairs(frame.slots) do
    slot.anchor.dot:Show()
  end
end

SBFOptions.MakeBuffs = function(self, frame)
	local buff, button
	local var = frame._var
  local t

  SBF:ClearBuffFrames(nil, frame)

  for i = 1,var.layout.count do
    buff = SBF:GetTable()
    buff._var = var
    buff.index = i
    buff.frame = frame
    buff.name = "Buff of the Test "..i
    buff.rank = i - 1
    buff.texture = SBFOptions:GetIcon((i == 1))
    buff.opacity = var.layout.opacity
    if (i == var.layout.count) then
      buff.timeLeft = 60000
      buff.duration = 60000
      buff.expiryTime = GetTime() + 60000
    else
      buff.timeLeft = var.layout.count - i + 1
      buff.duration = var.layout.count
      buff.expiryTime = GetTime() + var.layout.count - i + 1
    end
    buff.count = i
    buff.hadCount = true
    if (mod(i,2) == 0) then
      buff.auraType = SBF.HARMFUL
      buff.type = "HARMFUL"
      buff.debuffType = self:GetDebuffType(i)
    else
      buff.auraType = SBF.HELPFUL
      buff.type = "HELPFUL"
    end
    table.insert(frame.buffs, buff)
  end
end

SBFOptions.SetFrameNames = function(self, frame)
  local x = 15
  frame.tab1.label:SetText(frame._var.general.frameName)
  frame.tab2.label:SetText(frame._var.general.frameName)
  frame.tab1.label:SetWidth(300)
  local w = frame.tab1.label:GetStringWidth()
  frame.tab1:SetWidth(w + x)
  frame.tab1.label:SetWidth(w + x)
  frame.tab2:SetWidth(w + x)
  frame.tab2.label:SetWidth(w + x)
end

SBFOptions.ShowDragTabs = function(self, frame)
  frame.tab1:Show()
  frame.tab2:Show()
  self:SetFrameNames(frame)
end

SBFOptions.HideDragTabs = function(self)
	for i,frame in pairs(SBF.frames) do
    frame.tab1:Hide()
		frame.tab2:Hide()
  end
end


--
-- Frames
--

SBFOptions.RemoveFrame = function(self)
	if (self.curFrame.id == 1) then
		ChatFrame1:AddMessage(self.strings.DELETEERROR)
	else
		local s,f
		s = SBF.db.profile.frames[self.curFrame.id]
    SBF.db.profile.frames[self.curFrame.id] = nil
    SBF:CheckFlows()
		SBF:PutTable(s)
		SBF.frames[self.curFrame.id] = nil
    SBF:PutBuffFrame(self.curFrame)
    SBFOptions:InitialiseGlobalDropDowns()
    SBFOptions:InitScrollingDropDowns()
		SBFOptions:SelectFrame(1)
    self:SelectTab(1)
	end
	self:BuffFrameDropDown_Initialise()
end

SBFOptions.NewFrame = function(self)
	local frame,last,f
  for i=1,100 do
    if not SBF.db.profile.frames[i] then
      frame = i
      break
    end
  end
	SBF:ValidateFrameVars(frame, true)
  f = SBF:CreateFrames(frame)
  SBF:SetupFrame(f)
  SBFOptions:SetupFrames(true)
  SBFOptions:InitScrollingDropDowns()
  SBFOptions:InitialiseGlobalDropDowns()
	SBFOptions:SelectFrame(frame)
	self:SelectTab(1)
	self:BuffFrameDropDown_Initialise()
end

SBFOptions.BuffFrameDropDown_Initialise = function(self)
  ScrollingDropDown:ClearItems(SBFOBuffFrameDropDown)
  SBFOBuffFrameDropDown:Init(self.DropDownCallback, nil) -- self.strings.BUFFFRAME)
  local info = SBF:GetTable()
	info.callback = SBFOptions.BuffFrameDropDown_OnClick
	for i,frame in pairs(SBF.frames) do
    if SBF.db.profile.frames[i] then
      info.text = SBF.db.profile.frames[i].general.frameName
      info.value = i
      ScrollingDropDown:AddItem(SBFOBuffFrameDropDown, info)
    end
	end
	SBF:PutTable(info)
end

SBFOptions.BuffFrameDropDown_OnClick = function(item)
	CloseDropDownMenus(1)
	SBFOptions:SelectFrame(item.value)
end


--
-- Support
--

SBFOptions.ColourPicker = function(self, control, colourVar)
	self.currentColour = colourVar
	self.currentControl = control
  if self.currentColour.a then
    ColourFrame:Open(SBFOptions.ColourCallback, self.currentColour.r, self.currentColour.g, self.currentColour.b, self.currentColour.a)
  else
    ColourFrame:Open(SBFOptions.ColourCallback, self.currentColour.r, self.currentColour.g, self.currentColour.b)
  end
end

SBFOptions.ColourCallback = function(r,g,b,a)
	SBFOptions.currentColour.r = r
	SBFOptions.currentColour.g = g
	SBFOptions.currentColour.b = b
  if a then
    SBFOptions.currentColour.a = a
  end
	SBFOptions.currentControl.texture:SetVertexColor(r, g, b)
	SBFOptions:SetupFrame(SBFOptions.curFrame, true)
end

SBFOptions.DisableColourButton = function(self, button)
	button:Disable()
	button.label:SetTextColor(0.5, 0.5, 0.5)
	button.texture:SetVertexColor(0, 0, 0, 0)
end

SBFOptions.EnableColourButton = function(self, button, colour)
	button:Enable()
	button.label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	button.texture:SetVertexColor(colour.r, colour.g, colour.b, colour.a)
end

SBFOptions.CopyTable = function(self, srcFrame, dstFrame)
	for k,v in pairs(srcFrame) do
		if (type(v) == "table") then
			dstFrame[k] = {}
			SBFOptions:CopyTable(v, dstFrame[k])
		else
			dstFrame[k] = v
		end
	end
end

SBFOptions.EnableCheckbox = function(self, checkbox, checked)
	BlizzardOptionsPanel_CheckButton_Enable(checkbox, true, checked)
end

SBFOptions.DisableCheckbox = function(self, checkbox)
	checkbox:SetChecked(nil)
	BlizzardOptionsPanel_CheckButton_Disable(checkbox)
end

SBFOptions.GetIcon = function(self, first)
	if first then
		self.iconCount = 1
	else
		self.iconCount = self.iconCount + 1
		if (self.iconCount > #self.icons) then
			self.iconCount = 1
		end
	end
	return self.icons[self.iconCount]
end

SBFOptions.icons = {
	"Interface\\Icons\\INV_Misc_QuestionMark",
	"Interface\\Icons\\Spell_Shadow_RagingScream",
	"Interface\\Icons\\Spell_Nature_Regeneration",
	"Interface\\Icons\\Spell_Holy_WordFortitude",
	"Interface\\Icons\\Spell_Holy_MagicalSentry",
	"Interface\\Icons\\Ability_Warrior_BattleShout",
	"Interface\\Icons\\Ability_DualWield",
	"Interface\\Icons\\Ability_Druid_Maul",
	"Interface\\Icons\\Spell_Frost_FrostArmor02",
	"Interface\\Icons\\Ability_Hunter_Misdirection",
	"Interface\\Icons\\Ability_Mount_Gryphon_01",
	"Interface\\Icons\\Ability_Rogue_SliceDice",
	"Interface\\Icons\\Spell_Holy_FlashHeal",
	"Interface\\Icons\\Spell_Holy_GreaterBlessingofKings",
	"Interface\\Icons\\Spell_Nature_LightningShield",
	"Interface\\Icons\\Spell_Shadow_ManaBurn",
	"Interface\\Icons\\Spell_Shadow_Curse",
	"Interface\\Icons\\Spell_Ice_MagicDamage",
	"Interface\\Icons\\Spell_Holy_Vindication",
	"Interface\\Icons\\Spell_Holy_Renew",
	"Interface\\Icons\\Spell_Fire_Immolation",
	"Interface\\Icons\\Spell_Nature_HealingTouch",
	"Interface\\Icons\\Ability_Druid_TravelForm",
	"Interface\\Icons\\Spell_Fire_Incinerate",
	"Interface\\Icons\\Ability_Hunter_AimedShot",
	"Interface\\Icons\\Spell_Frost_Frostbolt",
	"Interface\\Icons\\Ability_Mage_Invisibility",
	"Interface\\Icons\\Ability_Mount_Kodo_01",
	"Interface\\Icons\\Spell_Arcane_PortalStormWind",
	"Interface\\Icons\\Ability_Warrior_Intervene",
	"Interface\\Icons\\Spell_Nature_RockBiter",
	"Interface\\Icons\\Spell_Arcane_TeleportSilvermoon",
}

SBFOptions.GetDebuffType = function(self, j)
	local i = mod(j,5)
	if i == 0  then 
		return "Curse"
	elseif  i == 1 then
		return "Magic"
	elseif  i == 2 then
		return "Poison"
	elseif  i == 3 then
		return "Disease"
	elseif  i == 4 then
		return "none"
	end
end

--
-- Element movement
--
SBFOptions.AttachFrameLevelWindow = function(self)
  if false then -- (self.curTab == 4) or (self.curTab == 5) or (self.curTab == 7) then
    SBFOFrameLevelWindow:Show()
    if (self.curTab == 3) then
      self:AttachElementForFrameLevel(self.firstBuff.icon, self.curFrame._var.icon)
    elseif (self.curTab == 4) then
      self:AttachElementForFrameLevel(self.firstBuff.timer, self.curFrame._var.timer)
    elseif (self.curTab == 5) then
      self:AttachElementForFrameLevel(self.firstBuff.count, self.curFrame._var.count)
    elseif (self.curTab == 6) then
      self:AttachElementForFrameLevel(self.firstBuff.bar, self.curFrame._var.bar)
    elseif (self.curTab == 7) then
      self:AttachElementForFrameLevel(self.firstBuff.name, self.curFrame._var.name)
    end
  else
    self:AttachElementForFrameLevel(nil)
    SBFOFrameLevelWindow:Hide()
  end
end

SBFOptions.AttachPositionWindow = function(self)
  if (self.curTab > 1) and (self.curTab < 8) then
    SBFOPositionWindow:Show()
    if (self.curTab == 2) then
      SBFOPositionWindowTop:SetFormattedText(self.strings.BUFFPOSITION)
      self:AttachElementForMove(self.firstBuff.anchor, self.curFrame._var.layout)
    elseif (self.curTab == 3) then
      SBFOPositionWindowTop:SetFormattedText(self.strings.ICONPOSITION)
      self:AttachElementForMove(self.firstBuff.icon, self.curFrame._var.icon)
    elseif (self.curTab == 4) then
      SBFOPositionWindowTop:SetFormattedText(self.strings.TIMERPOSITION)
      self:AttachElementForMove(self.firstBuff.timer, self.curFrame._var.timer)
    elseif (self.curTab == 5) then
      SBFOPositionWindowTop:SetFormattedText(self.strings.COUNTPOSITION)
      self:AttachElementForMove(self.firstBuff.count, self.curFrame._var.count)
    elseif (self.curTab == 6) then
      SBFOPositionWindowTop:SetFormattedText(self.strings.BARPOSITION)
      self:AttachElementForMove(self.firstBuff.bar, self.curFrame._var.bar)
    elseif (self.curTab == 7) then
      SBFOPositionWindowTop:SetFormattedText(self.strings.NAMEPOSITION)
      self:AttachElementForMove(self.firstBuff.name, self.curFrame._var.name)
    end
  else
    SBFOPositionWindow:Hide()
    self:AttachElementForMove(nil)
  end
end

local DragStart = function(self)
  ChatFrame1:AddMessage("DragStart: "..self:GetName())
  self:StartMoving()
end

local DragStop = function(self)
  self:StopMovingOrSizing()
  local anchor,f,x,y
  anchor,_,_,x,y = self:GetPoint()
  -- Ugh.  Re-anchors to UIParent when you stop dragging.  WHY!
  ChatFrame1:AddMessage(format("DragStop: %s %s %d,%d", self:GetName(), anchor, x, y))
end

SBFOptions.AttachElementForMove = function(self, element, var)
  if var then
    SBFOPositionWindow.var = var
    SBFOPositionWindow:Show()
    SBFOPositionWindowXEdit.edit:SetText(var.x)
    SBFOPositionWindowYEdit.edit:SetText(var.y)
  else
    SBFOPositionWindow:Hide()
  end
end

SBFOptions.Nudge = function(self, direction, increment)
  if (direction == "up") then
    SBFOPositionWindow.var.y = SBFOPositionWindow.var.y + increment
  elseif (direction == "down") then
    SBFOPositionWindow.var.y = SBFOPositionWindow.var.y - increment
  elseif (direction == "left") then
    SBFOPositionWindow.var.x = SBFOPositionWindow.var.x - increment
  else
    SBFOPositionWindow.var.x = SBFOPositionWindow.var.x + increment
  end
  SBFOPositionWindowXEdit.edit:SetText(SBFOPositionWindow.var.x)
  SBFOPositionWindowYEdit.edit:SetText(SBFOPositionWindow.var.y)
  self:SetupFrame(self.curFrame, true)
end

SBFOptions.PositionEditEnterPressed = function(self)
  local x,y = tonumber(SBFOPositionWindowXEdit.edit:GetText()), tonumber(SBFOPositionWindowYEdit.edit:GetText())
  if x then
    SBFOPositionWindow.var.x = x
  end
  if y then
    SBFOPositionWindow.var.y = y
  end
  self:SetupFrame(self.curFrame, true)
end

SBFOptions.SetupFrameLevelWindow = function(self)
  SBFOFrameLevelWindowSliderText:SetFont(GameFontNormalSmall:GetFont(), 10)
  SBFOFrameLevelWindowSliderLow:SetFont(GameFontNormalSmall:GetFont(), 9)
  SBFOFrameLevelWindowSliderHigh:SetFont(GameFontNormalSmall:GetFont(), 9)
	SBFOFrameLevelWindowSliderLow:SetFormattedText(1)
	SBFOFrameLevelWindowSliderHigh:SetFormattedText(4)
	SBFOFrameLevelWindowSlider:SetMinMaxValues(1, 4)
	SBFOFrameLevelWindowSlider:SetValueStep(1)
end

SBFOptions.AttachElementForFrameLevel = function(self, element, var)
  if false then
    SBFOFrameLevelWindow:Hide()
    return
  end
  if var then
    SBFOFrameLevelWindow.var = var
    SBFOFrameLevelWindow:Show()
    SBFOFrameLevelWindowSlider:SetValue(var.frameLevel - 2)
  else
    SBFOFrameLevelWindow.var = nil
    SBFOFrameLevelWindow:Hide()
  end
end

SBFOptions.FrameLevelSliderChanged = function(self)
  if not self.tabchange and not self.framechange then
    local level = SBFOFrameLevelWindowSlider:GetValue() + 2
    if (level ~= SBFOFrameLevelWindow.var.frameLevel) then
      SBFOFrameLevelWindow.var.frameLevel = level
      self:SetupFrame(SBFOptions.curFrame, true)
    end
  end
	SBFOFrameLevelWindowSliderText:SetFormattedText(self.strings.FRAMELEVEL, SBFOFrameLevelWindow.var.frameLevel - 2)
end