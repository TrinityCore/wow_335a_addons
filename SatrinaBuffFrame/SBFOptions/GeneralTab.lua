local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local _var

SBFOptions.GeneralTabInitialise = function(self)
	SBFOGeneralConfigButton.text:SetFormattedText(self.strings.GENERALCONFIG)
	SBFOCopyFromDropDown:Init(self.DropDownCallback, self.strings.COPYFROM)
	SBFOFrameNameEdit.label:SetFormattedText(self.strings.FRAMENAME)
  SBFOFrameBuffsCheckButtonText:SetFormattedText(self.strings.FRAMEBUFFS)
  SBFOFrameDebuffsCheckButtonText:SetFormattedText(self.strings.FRAMEDEBUFFS)
  SBFOFrameWhitelistCheckButtonText:SetFormattedText(self.strings.WHITELIST)
  SBFOFrameBlacklistCheckButtonText:SetFormattedText(self.strings.BLACKLIST)
  SBFOClickthroughCheckButtonText:SetFormattedText(self.strings.CLICKTHROUGH)
  SBFOFrameShowVehicleCheckButtonText:SetFormattedText(self.strings.SHOWVEHICLE)
	SBFOUnitDropDown:Init(self.DropDownCallback, self.strings.FRAMEUNIT)
  SBFOUnitDropDown.dropDownOptions = { noSort = true, }
  self:UnitDropDown_Initialise()
end

local vehicleCheckbox = function()
  if (_var.general.unit == "player") and _var.general.blacklist then
    SBFOptions:EnableCheckbox(SBFOFrameShowVehicleCheckButton)
    SBFOFrameShowVehicleCheckButton:SetChecked(_var.general.showVehicle)
  else
    SBFOptions:DisableCheckbox(SBFOFrameShowVehicleCheckButton)
    _var.general.showVehicle = false
  end
end

SBFOptions.GeneralTabSelectFrame = function(self, var)
  if var then
    _var = var
  end
  self:CopyFromDropDown_Initialise()
	ScrollingDropDown:SetSelected(SBFOUnitDropDown, self.curFrame.unit, ScrollingDropDown.TEXT)
  SBFOFrameNameEdit.edit:SetText(self.curFrame._var.general.frameName)
  self:Blacklist()
  SBFOClickthroughCheckButton:SetChecked(_var.general.clickthrough)
  SBFOFrameDebuffsCheckButton:SetChecked(_var.general.debuffs)
  SBFOFrameBuffsCheckButton:SetChecked(_var.general.buffs)
	SBFOUnitDropDown:SetText(_var.general.unit)
  vehicleCheckbox()
end

SBFOptions.CopyFromDropDown_Initialise = function(self)
  ScrollingDropDown:ClearItems(SBFOCopyFromDropDown)
	local info = SBF:GetTable()
  for i=1,100 do
		if SBF:FrameExists(i) and (i ~= SBFOptions.curFrame.id) then
			info.text = SBF.db.profile.frames[i].general.frameName
			info.value = i
			info.callback = SBFOptions.CopyFromDropDown_OnClick
			ScrollingDropDown:AddItem(SBFOCopyFromDropDown, info)
		end
	end
	SBF:PutTable(info)
end

SBFOptions.CopyFromDropDown_OnClick = function(item)
	local old = SBF.db.profile.frames[SBFOptions.curFrame.id]
  local new = SBF:CopyTable(SBF.db.profile.frames[item.value])
	for k,v in pairs(old.layout.point) do
		new.layout.point[k] = v
	end
  new.general.frameName = old.general.frameName
	SBF:PutTable(old)
	SBF.db.profile.frames[SBFOptions.curFrame.id] = new
  SBFOptions.curFrame._var = new
  ScrollingDropDown:SetSelected(SBFOCopyFromDropDown, nil)
  SBFOptions:SetupFrame(SBFOptions.curFrame, false)
	SBFOptions:SelectFrame(SBFOptions.curFrame)
end

local unitList = {
"player", "pet", "target", "targettarget", "focus", "focustarget", "vehicle", "party1", "party2", "party3", "party4", "partypet1", "partypet2", "partypet3", "partypet4", "mouseover", "arena1", "arena2", "arena3", "arena4", "arena5",
"raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10", "raid11", "raid12", "raid13", "raid14", "raid15", "raid16",  
"raid17", "raid18", "raid19", "raid20", "raid21", "raid22", "raid23", "raid24", "raid25", "raid26", "raid27", "raid28", "raid29", "raid30", "raid31", "raid32",
"raid33", "raid34", "raid35", "raid36", "raid37", "raid38", "raid39", "raid40"
}

SBFOptions.UnitDropDown_Initialise = function(self)
  ScrollingDropDown:ClearItems(SBFOUnitDropDown)
	local info = SBF:GetTable()
	for i,unit in pairs(unitList) do
    info.text = unit
    info.value = i
    info.selected = (self.curFrame.unit == unit)
    info.callback = SBFOptions.UnitDropDown_OnClick
    ScrollingDropDown:AddItem(SBFOUnitDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.UnitDropDown_OnClick = function(item)
  SBFOptions.curFrame.unit = item.text
  _var.general.unit = item.text
	SBFOUnitDropDown:SetText(item.text)
  vehicleCheckbox()
end

SBFOptions.FrameBuffs = function(self, checked)
  _var.general.buffs = checked
end

SBFOptions.FrameDebuffs = function(self, checked)
  _var.general.debuffs = checked
end

SBFOptions.Blacklist = function(self, toggle)
  if (toggle ~= nil) then
    SBFOptions.curFrame._var.general.blacklist = toggle
  end
  if SBFOptions.curFrame._var.general.blacklist then
    SBFOFrameBlacklistCheckButton:SetChecked(true)
    SBFOFrameWhitelistCheckButton:SetChecked(false)
  else
    SBFOFrameBlacklistCheckButton:SetChecked(false)
    SBFOFrameWhitelistCheckButton:SetChecked(true)
  end
end

SBFOptions.FrameName = function(self, escape)
  local old = _var.general.frameName
  if escape then
    SBFOFrameNameEditEdit:SetText(_var.general.frameName)
    return
  end
  local t = SBFOFrameNameEditEdit:GetText()
  if not t or (t == "") then
    SBFOFrameNameEditEdit:SetText(_var.general.frameName)
    return
  end
  for index,frame in pairs(SBF.frames) do
    if (frame.id ~= self.curFrame.id) and (t == frame._var.general.frameName) then
      SBFOFrameNameEditEdit:SetText(_var.general.frameName)
      return
    end
  end
  local vars
  if SBF.bfModule then
    vars = SBF.bfModule.db[old]
    SBF.bfModule:UndoGroup(old, true)
  end
  _var.general.frameName = t
  if SBF.bfModule then
    SBF.bfModule:SetupGroup(t, vars)
  end
  self:SetFrameNames(self.curFrame)
  SBFOptions:BuffFrameDropDown_Initialise()
end

SBFOptions.Clickthrough = function(self, checked)
  _var.general.clickthrough = checked
end

SBFOptions.ShowVehicle = function(self, checked)
  _var.general.showVehicle = checked
end