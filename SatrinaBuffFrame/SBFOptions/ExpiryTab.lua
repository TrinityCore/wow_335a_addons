local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local _var

SBFOptions.ExpiryTabInitialise = function(self)
	SBFOSCTColourLabel:SetFormattedText(self.strings.SCTCOLOUR)
	SBFOTextWarningCheckButtonText:SetFormattedText(self.strings.EXPIREWARN)
	SBFOSoundWarningCheckButtonText:SetFormattedText(self.strings.EXPIRESOUND)
	SBFOFlashBuffCheckButtonText:SetFormattedText(self.strings.FLASHBUFF)
	SBFOExpireTimerColourLabel:SetFormattedText(self.strings.EXPIRECOLOUR)
	SBFOSoundWarningDropDownLabel:SetFormattedText(self.strings.WARNSOUND)
	SBFOSCTCritCheckButtonText:SetFormattedText(self.strings.SCTCRIT)
	SBFOAlwaysWarnCheckButtonText:SetFormattedText(self.strings.ALWAYSWARN)
	SBFOFastBarCheckButtonText:SetFormattedText(self.strings.FASTBAR)
  self.hasSCT = MikSBT or SCT or Parrot or (_G["SHOW_COMBAT_TEXT"] == "1")
  if MikSBT then
    self.scrollingAddOn = "MikSBT"
  elseif SCT then
    self.scrollingAddOn = "SCT"
  elseif Parrot then
    self.scrollingAddOn = "Parrot"
  else
    self.scrollingAddOn = NONE
  end
	SBFOSCTWarnCheckButtonText:SetFormattedText(self.strings.SCTWARN, self.scrollingAddOn)
end

SBFOptions.ExpiryTabSelectFrame = function(self, var)
  if var then
    _var = var
  end
	SBFOExpiryConfigButton.text:SetFormattedText(self.strings.WARNCONFIG, self.curFrame.id)
	if self.hasSCT then
    SBFOptions:EnableCheckbox(SBFOSCTCritCheckButton)
    SBFOptions:EnableCheckbox(SBFOSCTWarnCheckButton)
    SBFOptions:EnableColourButton(SBFOSCTColour, _var.expiry.sctColour)
    if SCT and (SCT:Get("SHOWFADE", SCT.FRAMES_TABLE) == SCT.MSG) then
      SBFOSCTCritCheckButton:SetChecked(false)
    else
      SBFOSCTCritCheckButton:SetChecked(_var.expiry.sctCrit)
    end
    SBFOSCTWarnCheckButton:SetChecked(_var.expiry.sctWarn)
  else
    SBFOptions:DisableCheckbox(SBFOSCTCritCheckButton)
    SBFOptions:DisableCheckbox(SBFOSCTWarnCheckButton)
    SBFOptions:DisableColourButton(SBFOSCTColour)
  end
  
  if _var.expiry.soundWarning then
		SBFOSoundWarningDropDown:Enable()
	else
		SBFOSoundWarningDropDown:Disable()
	end
	if _var.bar then
		SBFOptions:EnableCheckbox(SBFOFastBarCheckButton)
		SBFOFastBarCheckButton:SetChecked(_var.bar.fastBar)
	else
		SBFOptions:DisableCheckbox(SBFOFastBarCheckButton)
	end
	if _var.expiry.textWarning then
		SBFOExpireFrameDropDown:Enable()
	else
		SBFOExpireFrameDropDown:Disable()
	end

	SBFOTextWarningCheckButton:SetChecked(var.expiry.textWarning)
	SBFOSoundWarningCheckButton:SetChecked(var.expiry.soundWarning)
	if _var.icon then
    SBFOptions:EnableCheckbox(SBFOFlashBuffCheckButton)
    SBFOFlashBuffCheckButton:SetChecked(_var.expiry.flash)
  else
    SBFOptions:DisableCheckbox(SBFOFlashBuffCheckButton)
  end
	ScrollingDropDown:SetSelected(SBFOExpireTimeDropDown, var.expiry.warnAtTime, ScrollingDropDown.VALUE)
	ScrollingDropDown:SetSelected(SBFOExpireFrameDropDown, var.expiry.frame, ScrollingDropDown.TEXT)
	ScrollingDropDown:SetSelected(SBFOSoundWarningDropDown, var.expiry.sound, ScrollingDropDown.TEXT)
	ScrollingDropDown:SetSelected(SBFOMinTimeDropDown, var.expiry.minimumDuration, ScrollingDropDown.VALUE)
end

SBFOptions.TextWarning = function(self, checked)
	_var.expiry.textWarning = checked
	self:SelectFrame()
end

SBFOptions.SoundWarning = function(self, checked)
	_var.expiry.soundWarning = checked
	self:SelectFrame()
end

SBFOptions.SCTWarn = function(self, checked)
	_var.expiry.sctWarn = checked
	self:SelectFrame()
end

SBFOptions.FlashBuff = function(self, checked)
	_var.expiry.flash = checked
end

SBFOptions.SCTCrit = function(self, checked)
	if SCT and (SCT:Get("SHOWFADE", SCT.FRAMES_TABLE) == SCT.MSG) then
    ChatFrame1:AddMessage(self.strings.SCTCRITTTM1)
    ChatFrame1:AddMessage(self.strings.SCTCRITTTM2)
    _var.expiry.sctCrit = false
    self:SetChecked(false)
  else
    _var.expiry.sctCrit = checked
  end
end

SBFOptions.FastBar = function(self, checked)
	_var.bar.fastBar = checked
end

SBFOptions.expireTimes = {5,10,15,20,30,45,60,90,120}
SBFOptions.ExpireTimeDropDown_Initialise = function(self)
	SBFOExpireTimeDropDown:Init(self.DropDownCallback, self.strings.EXPIRETIME)
	SBFOExpireTimeDropDown.dropDownOptions = SBF:GetTable()
  SBFOExpireTimeDropDown.dropDownOptions.noSort = true
  SBFOExpireTimeDropDown.dropDownOptions.tooltip = self.strings.WARNTIMETT

	local info = SBF:GetTable()
	for v,i in pairs(SBFOptions.expireTimes) do
		info.text = i.." sec"
		info.value = i
		info.callback = SBFOptions.ExpireTimeDropDown_OnClick
		ScrollingDropDown:AddItem(SBFOExpireTimeDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.ExpireTimeDropDown_OnClick = function(item)
	ScrollingDropDown:SetSelected(SBFOExpireTimeDropDown, item.value)
	_var.expiry.warnAtTime = item.value
  SBFOExpireTimeDropDown:SetFormattedText(item.text)
end

SBFOptions.chatFrames = {"ChatFrame1", "ChatFrame2", "ChatFrame3", "ChatFrame4", "ChatFrame5", "ChatFrame6", "ChatFrame7"}
SBFOptions.ExpireFrameDropDown_Initialise = function(self)
	SBFOExpireFrameDropDown:Init(self.DropDownCallback, self.strings.EXPIREFRAME)
	local info = SBF:GetTable()
	for v,i in pairs(SBFOptions.chatFrames) do
		info.text = i
		info.value = i
		info.callback = SBFOptions.ExpireFrameDropDown_OnClick
		ScrollingDropDown:AddItem(SBFOExpireFrameDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.ExpireFrameDropDown_OnClick = function(item)
	ScrollingDropDown:SetSelected(SBFOExpireFrameDropDown, item.value)
	_var.expiry.frame = item.value
  _G[item.value]:AddMessage(string.format(SBFOptions.strings.EXPIREFRAMETEST, SBFOptions.curFrame.id))
  SBFOExpireFrameDropDown:SetFormattedText(item.text)
end

SBFOptions.SoundWarningDropDown_Initialise = function(self)
	SBFOSoundWarningDropDown:Init(self.DropDownCallback, self.strings.WARNSOUND)
	SBFOSoundWarningDropDown.dropDownOptions = SBF:GetTable()
  SBFOSoundWarningDropDown.dropDownOptions.noSort = true

	local info = SBF:GetTable()
	local sounds = SML:List("sound")
	for k,v in pairs(sounds) do
		info.text = v
		info.value = v
		info.callback = SBFOptions.SoundWarningDropDown_OnClick
		ScrollingDropDown:AddItem(SBFOSoundWarningDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.SoundWarningDropDown_OnClick = function(item)
	ScrollingDropDown:SetSelected(SBFOSoundWarningDropDown, item.value)
	_var.expiry.sound = item.value
	PlaySoundFile(SML:Fetch("sound", item.value))
  SBFOSoundWarningDropDown:SetFormattedText(item.text)
end

SBFOptions.minTimes = {1000,0,1,2,3,5,10,20,30}
SBFOptions.MinTimeDropDown_Initialise = function(self)
	SBFOMinTimeDropDown:Init(self.DropDownCallback, self.strings.MINTIME)
	SBFOMinTimeDropDown.dropDownOptions = SBF:GetTable()
  SBFOMinTimeDropDown.dropDownOptions.noSort = true
  SBFOMinTimeDropDown.dropDownOptions.tooltip = self.strings.MINTIMETT
  local info
	for i,t in pairs(SBFOptions.minTimes) do
		local info = SBF:GetTable()
		if (t == 1000) then
			info.text = SBFOptions.strings.USERWARN
		elseif (t == 0) then
			info.text = SBFOptions.strings.ALLWARN
		else
			info.text = t.." min"
		end
		info.value = t * 60
		info.callback = SBFOptions.MinTimeDropDown_OnClick
		ScrollingDropDown:AddItem(SBFOMinTimeDropDown, info)
		SBF:PutTable(info)
	end
end

SBFOptions.MinTimeDropDown_OnClick = function(item)
	ScrollingDropDown:SetSelected(SBFOMinTimeDropDown, item.value, ScrollingDropDown.VALUE)
	_var.expiry.minimumDuration = item.value
  SBFOMinTimeDropDown:SetFormattedText(item.text)
end
