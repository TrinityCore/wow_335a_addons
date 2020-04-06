local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local sbfo = SBFOptions
local _var
local currentParent
local currentChildIndex

local FlowListButtons = {}
SBFOptions.FlowTabInitialise = function(self)
	for i=1,10 do
		FlowListButtons[i] = _G["SBFOFlowList"..i]
	end
  SBFOFlowFrameParentDropDown:Init(self.DropDownCallback, self.strings.STICKTOFRAME)
  SBFOFlowFrameChildDropDown:Init(self.DropDownCallback, self.strings.FLOWCHILDFRAME)
	SBFOFlowConfigButton.text:SetFormattedText(self.strings.FLOWCONFIG)
  SBFOFlowChildUpButton:SetFormattedText(self.strings.UP)
	SBFOFlowChildDownButton:SetFormattedText(self.strings.DOWN)
	SBFOFlowChildRemoveButtonText:SetFormattedText(self.strings.REMOVE)
end

SBFOptions.FlowTabSelectFrame = function(self, var)
  if var then
    _var = var
  end
  -- SBF:CheckFlows()
  self:FlowFrameParentDropDown_Initialise()
  self:InitFlow()
end

SBFOptions.InitFlow = function(self)
  SBFOFlowFrameChildDropDown:Disable()
  if currentParent then
    ScrollingDropDown:SetSelected(SBFOFlowFrameParentDropDown, currentParent, ScrollingDropDown.VALUE)
    currentChildIndex = nil
    self:GetChildFrames()
  end
  self:ManageFlowChildButtons()
end

-- Parent dropdown
SBFOptions.FlowFrameParentDropDown_Initialise = function(self)
  ScrollingDropDown:ClearItems(SBFOFlowFrameParentDropDown)
	local info = SBF:GetTable()
	for i=1,100 do
    if SBF:FrameExists(i) and not SBF:IsFlowChild(i) then
      info.text = SBF.db.profile.frames[i].general.frameName
      info.value = i
      info.callback = SBFOptions.FlowFrameParentDropDown_OnClick
      ScrollingDropDown:AddItem(SBFOFlowFrameParentDropDown, info)
    end
	end
	SBF:PutTable(info)
end

SBFOptions.FlowFrameParentDropDown_OnClick = function(item)
  currentParent = item.value
  sbfo:InitFlow()
  ScrollingDropDown:SetSelected(SBFOFlowFrameParentDropDown, currentParent, ScrollingDropDown.VALUE)
end

-- Manage list buttons
SBFOptions.ManageFlowChildButtons = function(self)
  if currentChildIndex then
    SBFOFlowChildUpButton:Enable()
    SBFOFlowChildDownButton:Enable()
    SBFOFlowChildRemoveButton:Enable()
  else
    SBFOFlowChildUpButton:Disable()
    SBFOFlowChildDownButton:Disable()
    SBFOFlowChildRemoveButton:Disable()
  end
  for i=1,10 do
    if i == currentChildIndex then
      FlowListButtons[i]:LockHighlight()
    else
      FlowListButtons[i]:UnlockHighlight()
    end
  end
end

-- Populate list with child frames
SBFOptions.GetChildFrames = function(self)
  if not currentParent then
    return
  end
  SBFOFlowFrameChildDropDown:Enable()
  self:FlowFrameChildDropDown_Initialise()
  for i=1,10 do
    FlowListButtons[i].label:SetFormattedText("")
    FlowListButtons[i].frame = nil
    FlowListButtons[i].index = nil
  end
  if _var.flow[currentParent] then
    for index,child in pairs(_var.flow[currentParent]) do
      FlowListButtons[index].label:SetFormattedText(SBF.db.profile.frames[child].general.frameName)
      FlowListButtons[index].frame = child
      FlowListButtons[index].index = index
    end
  end
  self:ManageFlowChildButtons()
end

-- Child dropdown
SBFOptions.FlowFrameChildDropDown_Initialise = function(self)
  ScrollingDropDown:ClearItems(SBFOFlowFrameChildDropDown)
	local info = SBF:GetTable()
	for i=1,100 do
		if SBF:FrameExists(i) and (i ~= currentParent) and not SBF:HasFlowChildren(i) and not SBF:IsFlowChild(i) and (SBF:FrameUnit(i) == SBF:FrameUnit(currentParent)) then
			info.text = SBF.db.profile.frames[i].general.frameName
			info.value = i
			info.callback = SBFOptions.FlowFrameChildDropDown_OnClick
			ScrollingDropDown:AddItem(SBFOFlowFrameChildDropDown, info)
		end
	end
	SBF:PutTable(info)
end

SBFOptions.FlowFrameChildDropDown_OnClick = function(item)
  if not _var.flow[currentParent] then
    _var.flow[currentParent] = SBF:GetTable()
  end
  table.insert(_var.flow[currentParent], item.value)
  sbfo:GetChildFrames()
end

-- select a child
SBFOptions.SelectFlowChild = function(self, button)
  if currentChildIndex then
    FlowListButtons[currentChildIndex]:UnlockHighlight()
  end
  currentChildIndex = button.index
  self:ManageFlowChildButtons()
end

SBFOptions.FlowChildUp = function(self)
  if currentChildIndex and (currentChildIndex > 1) then
    local f
    f = table.remove(_var.flow[currentParent], currentChildIndex)
    currentChildIndex = currentChildIndex - 1
    table.insert(_var.flow[currentParent], currentChildIndex, f)
    self:GetChildFrames()
  end
end

SBFOptions.FlowChildDown = function(self)
  if currentChildIndex and (currentChildIndex < #_var.flow[currentParent]) then
    local f
    f = table.remove(_var.flow[currentParent], currentChildIndex)
    currentChildIndex = currentChildIndex + 1
    table.insert(_var.flow[currentParent], currentChildIndex, f)
    self:GetChildFrames()
  end
end

SBFOptions.RemoveFlowChild = function(self)
  if currentChildIndex then
    FlowListButtons[currentChildIndex]:UnlockHighlight()
    table.remove(_var.flow[currentParent], currentChildIndex)
    if (#_var.flow[currentParent] == 0) then
      SBF:PutTable(_var.flow[currentParent])
      _var.flow[currentParent] = nil
    end
    currentChildIndex = nil
    self:GetChildFrames()
    self:FlowFrameParentDropDown_Initialise()
  end
end