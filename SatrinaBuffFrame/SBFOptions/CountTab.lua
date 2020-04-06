local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local _var

SBFOptions.CountTabInitialise = function(self)
	SBFOCountColourLabel:SetFormattedText(self.strings.STACKCOLOUR)
	SBFOEnableCountsCheckButtonText:SetFormattedText(self.strings.SHOWCOUNTS)
  SBFOCountOutlineCheckButtonText:SetText(self.strings.OUTLINEFONT)
  SBFOCountJustifySliderText:SetText(self.strings.JUSTIFY)
  SBFOCountJustifySliderLow:SetText(self.strings.JUSTIFYLEFT)
  SBFOCountJustifySliderHigh:SetText(self.strings.JUSTIFYRIGHT)
	SBFOCountJustifySlider:SetMinMaxValues(1,3)
	SBFOCountJustifySlider:SetValueStep(1)
	SBFOCountFontSizeSliderLow:SetFormattedText(6)
	SBFOCountFontSizeSliderHigh:SetFormattedText(34)
	SBFOCountFontSizeSlider:SetMinMaxValues(6, 34)
	SBFOCountFontSizeSlider:SetValueStep(1)
end

SBFOptions.CountTabSelectFrame = function(self, var)
  if var then
    _var = var
  end
	SBFOCountsConfigButton.text:SetFormattedText(self.strings.COUNTCONFIG, self.curFrame.id)
  SBFOEnableCountsCheckButton:SetChecked(_var.count)
  if _var.count then
    SBFOCountFontSizeSlider:Enable()
    SBFOCountJustifySlider:Enable()
    self:EnableCheckbox(SBFOCountOutlineCheckButton)
    SBFOCountOutlineCheckButton:SetChecked(_var.count.outline)
    self:EnableColourButton(SBFOCountColour, _var.count.colour)
    SBFOCountFontDropDown:Enable()

    SBFOCountJustifySlider:SetValue(SBF.justify[_var.count.justify])
    ScrollingDropDown:SetSelected(SBFOCountFontDropDown, _var.count.font, ScrollingDropDown.TEXT)
    SBFOCountFontSizeSlider:SetValue(_var.count.fontSize)
  else
    SBFOTimerFontSizeSlider:Disable()
    SBFOCountJustifySlider:Disable()
    self:DisableCheckbox(SBFOCountOutlineCheckButton)
    self:DisableColourButton(SBFOCountColour)
    SBFOCountFontDropDown:Disable()
  end
end

SBFOptions.EnableCounts = function(self, checked)
	if checked then
    SBF:DoCountSavedVars(_var, true)
	else
    _var.count = nil
	end
  SBFOptions:SetupFrame(self.curFrame)
  self:CountTabSelectFrame()
  self:AttachElementForMove(self.firstBuff.count, self.curFrame._var.count)
end

-- Outline
SBFOptions.CountOutline = function(self, checked)
	_var.count.outline = checked
	self:SetupFrame(self.curFrame, true)
end

-- Justify Slider
SBFOptions.CountJustifySliderChanged = function(self, slider)
  local v = slider:GetValue()
  if (v ~= SBF.justify[_var.count.justify]) then
    _var.count.justify = SBF.justify[v]
    self:SetupFrame(self.curFrame, true)
  end
end

-- Font dropdown
SBFOptions.CountFontDropDown_Initialise = function(self)
	SBFOCountFontDropDown:Init(self.DropDownCallback, self.strings.FONT)
	local info = SBF:GetTable()
	local fonts = SML:List("font")
	for k,v in pairs(fonts) do
		info.text = v
		info.value = v
		info.callback = SBFOptions.CountFontDropDown_OnClick
		ScrollingDropDown:AddItem(SBFOCountFontDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.CountFontDropDown_OnClick = function(item)
	ScrollingDropDown:SetSelected(SBFOCountFontDropDown, item.value)
	_var.count.font = item.value
	SBFOptions:SetupFrame(SBFOptions.curFrame, true)
  SBFOCountFontDropDown:SetFormattedText(item.text)
end

SBFOptions.CountFontSizeSliderChanged = function(self, slider)
  if (slider:GetValue() ~= _var.count.fontSize) then
    _var.count.fontSize = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
  end
  SBFOCountFontSizeSliderText:SetFormattedText(self.strings.FONTSIZE, self.curFrame._var.count.fontSize)
end