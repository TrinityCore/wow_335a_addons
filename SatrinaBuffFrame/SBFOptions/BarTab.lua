local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local _var

SBFOptions.BarTabInitialise = function(self)
	SBFOEnableBarsCheckButtonText:SetFormattedText(self.strings.SHOWBARS)
	SBFODebuffBarColourCheckButtonText:SetFormattedText(self.strings.DEBUFFBARCOLOUR)
	SBFOBarBuffColourLabel:SetFormattedText(self.strings.BARBUFFCOLOUR)
	SBFOBarDebuffColourLabel:SetFormattedText(self.strings.BARDEBUFFCOLOUR)
	SBFOBarBackdropColourLabel:SetFormattedText(self.strings.BARBACKDROP)
  SBFOBarDirectionSliderText:SetFormattedText(self.strings.BARDIRECTION)
  SBFOBarNoSparkButtonText:SetFormattedText(self.strings.BARNOSPARK)
	SBFOBarDirectionSlider:SetMinMaxValues(1,3)
	SBFOBarDirectionSlider:SetValueStep(1)
	SBFOBarRightClickButtonText:SetFormattedText(self.strings.BUFFRIGHTCLICK)
	SBFOBarTooltipButtonText:SetFormattedText(self.strings.NOTOOLTIPS)
	SBFOBarHeightEdit.label:SetText(self.strings.BARHEIGHT)
	SBFOBarWidthEdit.label:SetText(self.strings.BARWIDTH)
end

barDirectionLabels = function()
    if (_var.bar.height < _var.bar.width) then
      SBFOBarDirectionSliderLow:SetText(SBFOptions.strings.JUSTIFYLEFT)
      SBFOBarDirectionSliderHigh:SetText(SBFOptions.strings.JUSTIFYRIGHT)
    else
      SBFOBarDirectionSliderLow:SetText(SBFOptions.strings.UP)
      SBFOBarDirectionSliderHigh:SetText(SBFOptions.strings.DOWN)
    end
end

SBFOptions.BarTabSelectFrame = function(self, var)
  if var then
    _var = var
  end
	SBFOBarsConfigButton.text:SetFormattedText(self.strings.BARCONFIG, self.curFrame.id)
	SBFOEnableBarsCheckButton:SetChecked(_var.bar)
	if _var.bar then
		self:EnableCheckbox(SBFODebuffBarColourCheckButton)
		self:EnableColourButton(SBFOBarBuffColour, _var.bar.buffColour)
		self:EnableColourButton(SBFOBarBackdropColour, _var.bar.bgColour)
    SBFOBarTextureDropDown:Enable()
    SBFOBarBGTextureDropDown:Enable()
    SBFOBarDirectionSlider:Enable()
    if _var.bar.debuffBar then
			SBFOptions:DisableColourButton(SBFOBarDebuffColour)
		else
			SBFOptions:EnableColourButton(SBFOBarDebuffColour, _var.bar.debuffColour)
		end
    self:EnableCheckbox(SBFOBarRightClickButton)
    self:EnableCheckbox(SBFOBarTooltipButton)
    SBFOBarRightClickButton:SetChecked(_var.bar.disableRightClick)
    SBFOBarTooltipButton:SetChecked(_var.bar.noTooltips)

    SBFODebuffBarColourCheckButton:SetChecked(_var.bar.debuffBar)
    ScrollingDropDown:SetSelected(SBFOBarTextureDropDown, _var.bar.barTexture, ScrollingDropDown.TEXT)
    ScrollingDropDown:SetSelected(SBFOBarBGTextureDropDown, _var.bar.barBGTexture, ScrollingDropDown.TEXT)
    SBFOBarDirectionSlider:SetValue(_var.bar.direction)
		self:EnableCheckbox(SBFOBarNoSparkButton)
    SBFOBarNoSparkButton:SetChecked(_var.bar.hideSpark)
    SBFOBarWidthEdit.label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    SBFOBarHeightEdit.label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    SBFOApplyBarSizeButton:Enable()
    SBFOBarWidthEdit.edit:SetText(_var.bar.width)
    SBFOBarHeightEdit.edit:SetText(_var.bar.height)
    barDirectionLabels()
    
	else
    self:DisableCheckbox(SBFOBarRightClickButton)
    self:DisableCheckbox(SBFOBarTooltipButton)
		self:DisableCheckbox(SBFODebuffBarColourCheckButton)
		self:DisableCheckbox(SBFOBarNoSparkButton)
    SBFOBarTextureDropDown:Disable()
    SBFOBarBGTextureDropDown:Disable()
    SBFOBarDirectionSlider:Disable()
		self:DisableColourButton(SBFOBarBuffColour)
		self:DisableColourButton(SBFOBarDebuffColour)
		self:DisableColourButton(SBFOBarBackdropColour)
    SBFOBarWidthEdit.label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
    SBFOBarHeightEdit.label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
    SBFOApplyBarSizeButton:Disable()
	end
end

SBFOptions.EnableBars = function(self, checked)
	if checked then
    SBF:DoBarSavedVars(_var, true)
	else
    _var.bar = nil
	end
  SBFOptions:SetupFrame(self.curFrame, false)
  self:BarTabSelectFrame()
  self:AttachElementForMove(self.firstBuff.bar, self.curFrame._var.bar)
end

SBFOptions.DebuffBarColour = function(self, checked)
	_var.bar.debuffBar = checked
  if _var.bar.debuffBar then
    SBFOptions:DisableColourButton(SBFOBarDebuffColour)
  else
    SBFOptions:EnableColourButton(SBFOBarDebuffColour, _var.bar.debuffColour)
  end
  self:SetupFrame(self.curFrame, true)
end

SBFOptions.BarTextureDropDown_Initialise = function(self)
  SBFOBarTextureDropDown:Init(self.DropDownCallback, self.strings.BARTEXTURE)
	local info = SBF:GetTable()
	local bars = SML:List("statusbar")
  for k,v in pairs(bars) do
		info.text = v
		info.value = v
		info.callback = SBFOptions.BarTextureDropDown_OnClick
		ScrollingDropDown:AddItem(SBFOBarTextureDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.BarTextureDropDown_OnClick = function(item)
	_var.bar.barTexture = item.value
	SBFOptions:SetupFrame(SBFOptions.curFrame, true)
  SBFOBarTextureDropDown:SetFormattedText(item.text)
end

SBFOptions.BarBGTextureDropDown_Initialise = function(self)
  SBFOBarBGTextureDropDown:Init(self.DropDownCallback, self.strings.BARBGTEXTURE)
	local info = SBF:GetTable()
  info.callback = SBFOptions.BarBGTextureDropDown_OnClick
  
  local bg = SML:List("background")
  for k,v in pairs(bg) do
		info.text = v
		info.value = v
		ScrollingDropDown:AddItem(SBFOBarBGTextureDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.BarBGTextureDropDown_OnClick = function(item)
	_var.bar.barBGTexture = item.text
	-- _var.bar.barBGList = nil
	SBFOptions:SetupFrame(SBFOptions.curFrame, true)
  SBFOBarBGTextureDropDown:SetFormattedText(item.text)
end


SBFOptions.BarSizeEditEnterPressed = function(self)
  if _var.bar then
    local x = tonumber(SBFOBarWidthEdit.edit:GetText())
    local y = tonumber(SBFOBarHeightEdit.edit:GetText())
    local update = false
    if x and (x ~= _var.bar.width) then
      _var.bar.width = x
      update = true
    end
    if y and (y ~= _var.bar.height) then
      _var.bar.height = y
      update = true
    end
    if update then
      self:SetupFrame(self.curFrame, true)
    end
    SBFOBarWidthEdit.edit:SetText(_var.bar.width)
    SBFOBarHeightEdit.edit:SetText(_var.bar.height)
    barDirectionLabels()
  end
end

SBFOptions.BarWidthSliderChanged = function(self, slider)
  if (slider:GetValue() ~= _var.bar.width) then
    _var.bar.width = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
  end
  SBFOBarWidthSliderText:SetFormattedText("%s (%d)", self.strings.BARWIDTH, _var.bar.width)
end

SBFOptions.BarHeightSliderChanged = function(self, slider)
  if (slider:GetValue() ~= _var.bar.height) then
    _var.bar.height = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
  end
  SBFOBarHeightSliderText:SetFormattedText("%s (%d)", self.strings.BARHEIGHT, _var.bar.height)
end

-- Direction Slider
SBFOptions.BarDirectionSliderChanged = function(self, slider)
  if (slider:GetValue() ~= _var.bar.direction) then
    _var.bar.direction = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
    SBF:UpdateDurations(1)
  end
end

SBFOptions.BarRightClick = function(self, checked)
	_var.bar.disableRightClick = checked
end

SBFOptions.BarTooltips = function(self, checked)
	_var.bar.noTooltips = checked
end

SBFOptions.BarNoSpark = function(self, checked)
	_var.bar.hideSpark = checked
  self:SetupFrame(self.curFrame, true)
end
