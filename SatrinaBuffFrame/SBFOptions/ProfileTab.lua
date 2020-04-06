local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')

SBFOptions.ProfileTabInitialise = function(self, var)
  SBFONewProfileButton:SetText(self.strings.NEWPROFILEBUTTON)
  StaticPopupDialogs["SBFO_CONFIRM_REMOVE_PROFILE"] = {
    text = SBFOptions.strings.CONFIRMREMOVEPROFILE,
    button1 = YES,
    button2 = NO,
    OnAccept = function (self) SBFOptions:DeleteProfile(self.data) end,
    OnCancel = function (self) end,
    hideOnEscape = 1,
    timeout = 0,
  }

  StaticPopupDialogs["SBFO_NEW_PROFILE"] = {
    text = SBFOptions.strings.NEWPROFILE,
    button1 = OKAY,
    button2 = CANCEL,
    OnAccept = function(self)
      SBF.db:SetProfile(self.editBox:GetText())
      SBF:ProfileChanged(true)
      self:Hide()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    hasEditBox = 1,
    maxLetters = 32,
    OnShow = function(self)
      self.button1:Disable()
      self.button2:Enable()
      self.editBox:SetFocus()
    end,
    OnHide = function(self)
      if ChatFrameEditBox:IsShown() then
        ChatFrameEditBox:SetFocus()
      end
      self.editBox:SetText("")
    end,
    EditBoxOnEnterPressed = function(self)
      if self:GetParent().button1:IsEnabled() then
        SBF.db:SetProfile(self:GetParent().editBox:GetText())
        SBF:ProfileChanged(true)
        self:GetParent():Hide()
      end
    end,
    EditBoxOnTextChanged = function (self)
      local parent = self:GetParent()
      if (string.len(parent.editBox:GetText()) > 0) then
        parent.button1:Enable()
      else
        parent.button1:Disable()
      end
    end,
    EditBoxOnEscapePressed = function(self)
      self:GetParent():Hide()
    end
  }  
end

SBFOptions.SetupProfiles = function(self)
	self:UsingProfileDropDown_Initialise()
	self:CopyProfileDropDown_Initialise()
	self:DeleteProfileDropDown_Initialise()
end

SBFOptions.ProfileTabSelectTab = function(self)
  self:SetupProfiles()
end

SBFOptions.NewProfile = function(self)
  local dialog = StaticPopup_Show("SBFO_NEW_PROFILE")
end

SBFOptions.UsingProfileDropDown_Initialise = function(self)
	SBFOUsingProfileDropDown:Init(self.DropDownCallback, self.strings.USINGPROFILE)
  ScrollingDropDown:ClearItems(SBFOUsingProfileDropDown)
  local profiles = SBF.db:GetProfiles()
	local info = SBF:GetTable()
	info.callback	= SBFOptions.UsingProfileDropDown_OnClick
	for k,v in pairs(profiles) do
    info.text	= v
		info.value = v
		ScrollingDropDown:AddItem(SBFOUsingProfileDropDown, info)
	end
	SBF:PutTable(info)
  ScrollingDropDown:SetSelected(SBFOUsingProfileDropDown, SBF.db:GetCurrentProfile())
end

SBFOptions.UsingProfileDropDown_OnClick = function(item)
	SBF.db:SetProfile(item.value)
  ScrollingDropDown:SetSelected(SBFOUsingProfileDropDown, SBF.db:GetCurrentProfile())
  SBF:ProfileChanged(true)
end

SBFOptions.CopyProfileDropDown_Initialise = function(self)
	SBFOCopyProfileDropDown:Init(self.DropDownCallback, self.strings.COPYPROFILE)
  ScrollingDropDown:ClearItems(SBFOCopyProfileDropDown)
  local profiles = SBF.db:GetProfiles()
	local info = SBF:GetTable()
	info.callback	= SBFOptions.CopyProfileDropDown_OnClick
	for k,v in pairs(profiles) do
		if (v ~= SBF.db:GetCurrentProfile()) then
			info.text	= v
			info.value = v
			ScrollingDropDown:AddItem(SBFOCopyProfileDropDown, info)
		end
	end
	SBF:PutTable(info)
end

SBFOptions.CopyProfileDropDown_OnClick = function(item)
	SBF.db:CopyProfile(item.value)
  SBF:ProfileChanged(true)
end

SBFOptions.DeleteProfileDropDown_Initialise = function(self)
	SBFODeleteProfileDropDown:Init(self.DropDownCallback, self.strings.DELETEPROFILE)
  ScrollingDropDown:ClearItems(SBFODeleteProfileDropDown)
  local profiles = SBF.db:GetProfiles()
	local info = SBF:GetTable()
	info.callback	= SBFOptions.DeleteProfileDropDown_OnClick
	for k,v in pairs(profiles) do
		if (v ~= SBF.db:GetCurrentProfile()) then
			info.text	= v
			info.value = v
			ScrollingDropDown:AddItem(SBFODeleteProfileDropDown, info)
		end
	end
	SBF:PutTable(info)
end

SBFOptions.DeleteProfileDropDown_OnClick = function(item)
  local dialog = StaticPopup_Show("SBFO_CONFIRM_REMOVE_PROFILE", item.value)
  dialog.data = item.value
end

SBFOptions.DeleteProfile = function(self, profile)
  SBF.db:DeleteProfile(profile)
  self:CopyProfileDropDown_Initialise()
  self:DeleteProfileDropDown_Initialise()
end