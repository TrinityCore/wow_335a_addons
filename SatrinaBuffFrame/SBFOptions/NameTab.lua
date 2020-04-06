local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local _var

SBFOptions.NameTabInitialise = function(self)
	SBFOEnableNamesCheckButtonText:SetFormattedText(self.strings.SHOWNAMES)
	SBFONameFontSizeSliderLow:SetFormattedText(6)
	SBFONameFontSizeSliderHigh:SetFormattedText(34)
	SBFONameFontSizeSlider:SetMinMaxValues(6, 34)
	SBFONameFontSizeSlider:SetValueStep(1)
	SBFONameOutlineCheckButtonText:SetFormattedText(self.strings.OUTLINEFONT)
  SBFONameJustifySliderText:SetText(self.strings.JUSTIFY)
  SBFONameJustifySliderLow:SetText(self.strings.JUSTIFYLEFT)
  SBFONameJustifySliderHigh:SetText(self.strings.JUSTIFYRIGHT)
	SBFONameJustifySlider:SetMinMaxValues(1,3)
	SBFONameJustifySlider:SetValueStep(1)
	SBFONameBuffColourLabel:SetFormattedText(self.strings.NAMEBUFFCOLOUR)
	SBFONameDebuffColourLabel:SetFormattedText(self.strings.NAMEDEBUFFCOLOUR)
  SBFOColourNameAsDebuffCheckButtonText:SetText(self.strings.DEBUFFBARCOLOUR)
  SBFONameNameFormatEditLabel:SetText(self.strings.NAMEFORMAT)
  SBFONameFormatButton:SetText(APPLY)
  SBFONameFormatHelpButton:SetText(self.strings.HELP)
  SBFONameActiveCheckButtonText:SetText(self.strings.NAMEACTIVE)
end

SBFOptions.NameTabSelectFrame = function(self, var)
  if var then
    _var = var
  end
	SBFONamesConfigButton.text:SetFormattedText(self.strings.NAMECONFIG, self.curFrame.id)
  SBFOEnableNamesCheckButton:SetChecked(_var.name)
 	if self.curFrame._var.name then
    SBFONameFontDropDown:Enable()
    SBFONameJustifySlider:Enable()
    SBFONameFontSizeSlider:Enable()
		self:EnableColourButton(SBFONameBuffColour, _var.name.buffColour)
    self:EnableCheckbox(SBFONameOutlineCheckButton)
    self:EnableCheckbox(SBFOColourNameAsDebuffCheckButton)
    SBFONameOutlineCheckButton:SetChecked(_var.name.outline)
    if _var.name.colourNameAsDebuff then
			self:DisableColourButton(SBFONameDebuffColour)
		else
			self:EnableColourButton(SBFONameDebuffColour, _var.name.debuffColour)
		end

    ScrollingDropDown:SetSelected(SBFONameFontDropDown, _var.name.font, ScrollingDropDown.TEXT)
    SBFONameJustifySlider:SetValue(SBF.justify[_var.name.justify])
    SBFONameFontSizeSlider:SetValue(_var.name.fontSize)
    SBFONameNameFormatEditText:SetText(_var.name.nameFormat)
    self:EnableCheckbox(SBFONameActiveCheckButton)
    SBFONameActiveCheckButton:SetChecked(_var.name.mouseActive)
  else
		SBFONameFontDropDown:Disable()
		SBFONameJustifySlider:Disable()
		SBFONameFontSizeSlider:Disable()
		self:DisableColourButton(SBFONameBuffColour)
		self:DisableColourButton(SBFONameDebuffColour)
		self:DisableCheckbox(SBFOColourNameAsDebuffCheckButton)
    self:DisableCheckbox(SBFONameOutlineCheckButton)
    self:DisableCheckbox(SBFONameActiveCheckButton)
  end
end

SBFOptions.EnableNames = function(self, checked)
	if checked then
    SBF:DoNameSavedVars(_var, true)
	else
    _var.name = nil
	end
  SBFOptions:SetupFrame(self.curFrame, false)
  self:NameTabSelectFrame()
  self:AttachElementForMove(self.firstBuff.name, self.curFrame._var.name)
end

-- Colour name by debuff type
SBFOptions.ColourNameAsDebuff = function(self, checked)
	_var.name.colourNameAsDebuff = checked
  if _var.name.colourNameAsDebuff then
    SBFOptions:DisableColourButton(SBFONameDebuffColour)
  else
    SBFOptions:EnableColourButton(SBFONameDebuffColour, _var.name.debuffColour)
  end
  self:SetupFrame(self.curFrame, true)
end

-- Justify Slider
SBFOptions.NameJustifySliderChanged = function(self, slider)
  local v = slider:GetValue()
  if (v ~= SBF.justify[_var.name.justify]) then
    _var.name.justify = SBF.justify[v]
    self:SetupFrame(self.curFrame, true)
  end
end

SBFOptions.NameOutline = function(self, checked)
	_var.name.outline = checked
	self:SetupFrame(self.curFrame, true)
end

SBFOptions.NameFontDropDown_Initialise = function(self)
	SBFONameFontDropDown:Init(self.DropDownCallback, self.strings.FONT)
	local info = SBF:GetTable()
	local fonts = SML:List("font")
	for k,v in pairs(fonts) do
		info.text = v
		info.value = v
		info.callback = SBFOptions.NameFontDropDown_OnClick
		ScrollingDropDown:AddItem(SBFONameFontDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.NameFontDropDown_OnClick = function(item)
	ScrollingDropDown:SetSelected(SBFONameFontDropDown, item.value)
	_var.name.font = item.value
	SBFOptions:SetupFrame(SBFOptions.curFrame, true)
  SBFONameFontDropDown:SetFormattedText(item.text)
end

SBFOptions.NameDropDown_Initialise = function(self)
	SBFONameFormatDropDown:Init(self.DropDownCallback, self.strings.TEXT_FORMAT)
	local info = SBF:GetTable()
	for i,v in ipairs(SBFOptions.strings.nameFormats) do
		info.text	= v
		info.value	= i
		info.callback	= SBFOptions.NameDropDown_OnClick
		ScrollingDropDown:AddItem(SBFONameFormatDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.NameDropDown_OnClick = function(item)
	ScrollingDropDown:SetSelected(SBFONameFormatDropDown, item.value)
	_var.name.format = item.value
  SBFOptions:SetupFrame(SBFOptions.curFrame, true)
  SBFONameFormatDropDown:SetFormattedText(item.text)
end

SBFOptions.NameFontSizeSliderChanged = function(self, slider)
  if (slider:GetValue() ~= _var.name.fontSize) then
    _var.name.fontSize = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
  end
  SBFONameFontSizeSliderText:SetFormattedText(self.strings.FONTSIZE, self.curFrame._var.name.fontSize)
end

SBFOptions.NameNameFormatChanged = function(self)
  _var.name.nameFormat = SBFONameNameFormatEditText:GetText()
  SBF:FrameShowBuffs(self.curFrame)
end

SBFOptions.ShowNameHelp = function(self)
  if not SBFONameTab.pages then
    SBFONameTab.pages = {}
    local str
    for i,page in ipairs(SBFOptions.strings.NAMEHELPHTML) do
      str = SBFOptions.strings.OPENHTML
      for j,line in ipairs(page) do
        str = str..line
      end
      str = str..SBFOptions.strings.CLOSEHTML
      SBFONameTab.pages[i] = str
    end
  end
  SBFOHelpFrame.pages = SBFONameTab.pages
  SBFOHelpFrame.page = 1
  SBFOHelpFrame.pageStr:SetText(SBFOHelpFrame.page.."/"..#SBFOHelpFrame.pages)
  SBFOHelpFrame.html:SetText(SBFOHelpFrame.pages[SBFOHelpFrame.page])
  SBFOHelpFrame:Show()
end

SBFOptions.NameActive = function(self, checked)
  _var.name.mouseActive = checked
  self:SetupFrame(self.curFrame, true)
end