local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local _var
local sbfo = SBFOptions
local setup = false

local cooldownAddonPresent = (IsAddOnLoaded("OmniCC") == 1)

local DoSuppressCooldownTimer = function()
  if cooldownAddonPresent then
    if IsAddOnLoaded("OmniCC") then
      SBFOIconSuppressCooldownTimerButtonText:SetFormattedText(sbfo.strings.SUPPRESSOMNICCTIMER)
    -- else IsAddonLoaded("OtherCooldownAddon") then
      -- SBFOIconSuppressCooldownTimerButtonText:SetFormattedText(sbfo.strings.SUPPRESSOTHERTIMER)
    end
  else
    SBFOIconSuppressCooldownTimerButton:Hide()
  end
  if cooldownAddonPresent and _var.icon.cooldown then
    sbfo:EnableCheckbox(SBFOIconSuppressCooldownTimerButton)
    SBFOIconSuppressCooldownTimerButton:SetChecked(_var.icon.suppressCooldownTimer)
  else
    sbfo:DisableCheckbox(SBFOIconSuppressCooldownTimerButton)
  end
  if _var.icon.cooldown then
    sbfo:EnableCheckbox(SBFOIconReverseCooldownButton)
  else
    sbfo:DisableCheckbox(SBFOIconReverseCooldownButton)
  end
end

SBFOptions.IconTabInitialise = function(self)
	SBFOEnableIconsCheckButtonText:SetFormattedText(self.strings.SHOWICONS)
	SBFOIconSizeEdit.label:SetText(self.strings.ICONSIZE)
	SBFOIconRightClickButtonText:SetFormattedText(self.strings.BUFFRIGHTCLICK)
	SBFOIconTooltipButtonText:SetFormattedText(self.strings.NOTOOLTIPS)
	SBFOIconCooldownButtonText:SetFormattedText(self.strings.COOLDOWN)
	SBFOIconReverseCooldownButtonText:SetFormattedText(self.strings.REVERSECOOLDOWN)
  SBFONoIconBorderButtonText:SetFormattedText(self.strings.NOBORDER)
  if SBF.bfModule then
    SBFONoIconBFBorderButtonText:SetFormattedText(self.strings.NOBFBORDER)
  else
    self:DisableCheckbox(SBFONoIconBFBorderButton)
  end
	SBFOIconOpacitySliderLow:SetFormattedText(0.1)
	SBFOIconOpacitySliderHigh:SetFormattedText(1.0)
	SBFOIconOpacitySlider:SetMinMaxValues(0.1, 1.0)
	SBFOIconOpacitySlider:SetValueStep(0.1)
end

SBFOptions.IconTabSelectFrame = function(self, var)
  if var then
    _var = var
  end
	setup = true
  SBFOIconsConfigButton.text:SetFormattedText(self.strings.ICONCONFIG, self.curFrame.id)
  SBFOEnableIconsCheckButton:SetChecked(_var.icon)
 	if self.curFrame._var.icon then
    SBFOIconSizeEdit.label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    SBFOApplyIconSizeButton:Enable()
    SBFOIconSizeEdit.edit:SetText(_var.icon.size)
    self:EnableCheckbox(SBFOIconRightClickButton)
    self:EnableCheckbox(SBFOIconTooltipButton)
    SBFOIconRightClickButton:SetChecked(_var.icon.disableRightClick)
    SBFOIconCooldownButton:SetChecked(_var.icon.cooldown)
    SBFOIconReverseCooldownButton:SetChecked(_var.icon.reverseCooldown)
    SBFOIconTooltipButton:SetChecked(_var.icon.noTooltips)
    SBFONoIconBorderButton:SetChecked(_var.icon.noIconBorder)
    SBFONoIconBFBorderButton:SetChecked(_var.icon.noIconBFBorder)
    DoSuppressCooldownTimer()
    SBFOIconOpacitySlider:Enable()
    SBFOIconOpacitySlider:SetValue(_var.icon.opacity)
  else
    SBFOIconSizeEdit.label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
    SBFOApplyIconSizeButton:Disable()
    self:DisableCheckbox(SBFOIconRightClickButton)
    self:DisableCheckbox(SBFOIconTooltipButton)
    self:DisableCheckbox(SBFOIconCooldownButton)
    self:DisableCheckbox(SBFOIconReverseCooldownButton)
    SBFOIconOpacitySlider:Disable()
  end
  setup = false
end

SBFOptions.EnableIcons = function(self, checked)
	if checked then
    SBF:DoIconSavedVars(_var, true)
	else
    _var.icon = nil
	end
  SBFOptions:SetupFrame(self.curFrame)
  self:IconTabSelectFrame()
  self:AttachElementForMove(self.firstBuff.icon, self.curFrame._var.icon)
end

SBFOptions.IconSizeEditEnterPressed = function(self, slider)
  if _var.icon then
    local x = tonumber(SBFOIconSizeEdit.edit:GetText())
    if x and (x ~= _var.icon.size) then
      _var.icon.size = x
      self:SetupFrame(self.curFrame, true)
    end
    SBFOIconSizeEdit.edit:SetText(_var.icon.size)
  end
end

SBFOptions.IconRightClick = function(self, checked)
	_var.icon.disableRightClick = checked
end

SBFOptions.IconTooltips = function(self, checked)
	_var.icon.noTooltips = checked
end

SBFOptions.IconCooldown = function(self, checked)
	_var.icon.cooldown = checked
  DoSuppressCooldownTimer()
end

SBFOptions.ReverseCooldown = function(self, checked)
	_var.icon.reverseCooldown = checked
end

SBFOptions.SuppressCooldownTimer = function(self, checked)
	_var.icon.suppressCooldownTimer = checked
  DoSuppressCooldownTimer()
end

SBFOptions.NoIconBorder = function(self, checked)
	_var.icon.noIconBorder = checked
  SBFOptions:SetupFrame(self.curFrame)
end

SBFOptions.NoIconBFBorder = function(self, checked)
	_var.icon.noBFIconBorder = checked
  SBFOptions:SetupFrame(self.curFrame)
end

SBFOptions.IconOpacitySliderChanged = function(self, slider)
  if  not setup and (slider:GetValue() ~= _var.icon.opacity) then
    _var.icon.opacity = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
  end
	SBFOIconOpacitySliderText:SetFormattedText("%s (%.1f)", self.strings.OPACITY, _var.icon.opacity)
end
