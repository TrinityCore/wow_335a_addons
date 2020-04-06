local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local _var

SBFOptions.TimerTabInitialise = function(self)
	SBFOEnableTimersCheckButtonText:SetFormattedText(self.strings.SHOWTIMERS)
	SBFOTimerFontSizeSliderLow:SetFormattedText(6)
	SBFOTimerFontSizeSliderHigh:SetFormattedText(34)
	SBFOTimerFontSizeSlider:SetMinMaxValues(6, 34)
	SBFOTimerFontSizeSlider:SetValueStep(1)
	SBFOTimerOutlineCheckButtonText:SetFormattedText(self.strings.OUTLINEFONT)
	SBFOTimerNACheckButtonText:SetFormattedText(self.strings.TIMERNA)
  SBFOTimerJustifySliderText:SetText(self.strings.JUSTIFY)
  SBFOTimerJustifySliderLow:SetText(self.strings.JUSTIFYLEFT)
  SBFOTimerJustifySliderHigh:SetText(self.strings.JUSTIFYRIGHT)
	SBFOTimerJustifySlider:SetMinMaxValues(1,3)
	SBFOTimerJustifySlider:SetValueStep(1)
	SBFORegularTimerColourLabel:SetFormattedText(self.strings.TIMERCOLOUR)
	SBFODebuffTimerCheckButtonText:SetFormattedText(self.strings.DEBUFFTIMER)
  SBFOTimerMillisecondCheckButtonText:SetFormattedText(self.strings.TIMERMS)
  SBFOTimerFormatDropDown.dropDownOptions = { noSort = true, }
end

SBFOptions.TimerTabSelectFrame = function(self, var)
  SBFOTimersConfigButton.text:SetFormattedText(self.strings.TIMERCONFIG, self.curFrame.id)
  if var then
    _var = var
  end
  SBFOEnableTimersCheckButton:SetChecked(_var.timer)
 	if _var.timer then
    SBFOptions:EnableCheckbox(SBFODebuffTimerCheckButton, _var.timer.debuffColour)
    SBFOptions:EnableCheckbox(SBFOTimerOutlineCheckButton)
    SBFOptions:EnableCheckbox(SBFOTimerMillisecondCheckButton)
    SBFOTimerMillisecondCheckButton:SetChecked(_var.timer.milliseconds)
    SBFOTimerOutlineCheckButton:SetChecked(_var.timer.outline)
    SBFOptions:EnableCheckbox(SBFOTimerNACheckButton)
    SBFOTimerNACheckButton:SetChecked(_var.timer.naTimer)
    self:EnableColourButton(SBFORegularTimerColour, _var.timer.regularColour)
    self:EnableColourButton(SBFOExpireTimerColour, _var.timer.expiringColour)
    SBFOTimerFontSizeSlider:Enable()
    SBFOTimerFontSizeSlider:SetValue(_var.timer.fontSize)
    ScrollingDropDown:SetSelected(SBFOTimerFontDropDown, _var.timer.font, ScrollingDropDown.TEXT)
    ScrollingDropDown:SetSelected(SBFOTimerFormatDropDown, _var.timer.format, ScrollingDropDown.VALUE)
    SBFOTimerJustifySlider:Enable()
    SBFOTimerJustifySlider:SetValue(SBF.justify[_var.timer.justify])
  else
    self:DisableCheckbox(SBFOTimerMillisecondCheckButton)
    self:DisableCheckbox(SBFOTimerOutlineCheckButton)
    self:DisableCheckbox(SBFOTimerNACheckButton)
    self:DisableCheckbox(SBFODebuffTimerCheckButton)
    self:DisableColourButton(SBFORegularTimerColour)
    self:DisableColourButton(SBFOExpireTimerColour)
    SBFOTimerFontSizeSlider:Disable()
    SBFOTimerJustifySlider:Disable()
  end
end

SBFOptions.EnableTimers = function(self, checked)
	if checked then
    SBF:DoTimerSavedVars(_var, true)
	else
    _var.timer = nil
	end
  SBFOptions:SetupFrame(self.curFrame)
  self:TimerTabSelectFrame()
  self:AttachElementForMove(self.firstBuff.timer, self.curFrame._var.timer)
end

-- Justify Slider
SBFOptions.TimerJustifySliderChanged = function(self, slider)
  local v = slider:GetValue()
  if (v ~= SBF.justify[_var.timer.justify]) then
    _var.timer.justify = SBF.justify[v]
    self:SetupFrame(self.curFrame, true)
  end
end

SBFOptions.DebuffTimer = function(self, checked)
	_var.timer.debuffColour = checked
  self:SetupFrame(self.curFrame, true)
end

SBFOptions.TimerOutline = function(self, checked)
	_var.timer.outline = checked
	self:SetupFrame(self.curFrame, true)
end

SBFOptions.TimerNA = function(self, checked)
	_var.timer.naTimer = checked
	self:SetupFrame(self.curFrame, true)
end

SBFOptions.TimerMilliseconds = function(self, checked)
	_var.timer.milliseconds = checked
end


SBFOptions.TimerFontDropDown_Initialise = function(self)
	SBFOTimerFontDropDown:Init(self.DropDownCallback, self.strings.FONT)
	local info = SBF:GetTable()
	local fonts = SML:List("font")
	for k,v in pairs(fonts) do
		info.text = v
		info.value = v
		info.callback = SBFOptions.TimerFontDropDown_OnClick
		ScrollingDropDown:AddItem(SBFOTimerFontDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.TimerFontDropDown_OnClick = function(item)
	ScrollingDropDown:SetSelected(SBFOTimerFontDropDown, item.value)
	_var.timer.font = item.value
	SBFOptions:SetupFrame(SBFOptions.curFrame, true)
  SBFOTimerFontDropDown:SetFormattedText(item.text)
end

SBFOptions.TimerDropDown_Initialise = function(self)
	SBFOTimerFormatDropDown:Init(self.DropDownCallback, self.strings.TEXT_FORMAT)
	local info = SBF:GetTable()
	for i,v in ipairs(SBFOptions.strings.timerFormats) do
		info.text	= v
		info.value	= i
		info.callback	= SBFOptions.TimerDropDown_OnClick
		ScrollingDropDown:AddItem(SBFOTimerFormatDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.TimerDropDown_OnClick = function(item)
	ScrollingDropDown:SetSelected(SBFOTimerFormatDropDown, item.value)
	_var.timer.format = item.value
  SBFOptions:SetupFrame(SBFOptions.curFrame, true)
  SBFOTimerFormatDropDown:SetFormattedText(item.text)
end

SBFOptions.TimerFontSizeSliderChanged = function(self, slider)
  if (slider:GetValue() ~= _var.timer.fontSize) then
    _var.timer.fontSize = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
  end
  SBFOTimerFontSizeSliderText:SetFormattedText(self.strings.FONTSIZE, self.curFrame._var.timer.fontSize)
end