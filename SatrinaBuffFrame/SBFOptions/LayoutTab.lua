local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local _var
local setup = false
local sbfo = SBFOptions


local rows = function(rows)
  if rows then
    SBFOBuffGrowthSliderLow:SetFormattedText(sbfo.strings.JUSTIFYLEFT)
    SBFOBuffGrowthSliderHigh:SetFormattedText(sbfo.strings.JUSTIFYRIGHT)
    SBFOBuffAnchorSliderLow:SetFormattedText(sbfo.strings.TOP)
    SBFOBuffAnchorSliderHigh:SetFormattedText(sbfo.strings.BOTTOM)
  else
    SBFOBuffGrowthSliderLow:SetFormattedText(sbfo.strings.UP)
    SBFOBuffGrowthSliderHigh:SetFormattedText(sbfo.strings.DOWN)
    SBFOBuffAnchorSliderLow:SetFormattedText(sbfo.strings.JUSTIFYLEFT)
    SBFOBuffAnchorSliderHigh:SetFormattedText(sbfo.strings.JUSTIFYRIGHT)
  end
end

SBFOptions.LayoutTabInitialise = function(self)
	SBFOBuffGrowthSlider:SetMinMaxValues(1,3)
	SBFOBuffGrowthSlider:SetValueStep(1)
	SBFOBuffGrowthSliderText:SetFormattedText("%s", sbfo.strings.BUFFGROWTH)

	SBFOBuffAnchorSlider:SetMinMaxValues(1,3)
	SBFOBuffAnchorSlider:SetValueStep(1)
	SBFOBuffAnchorSliderText:SetFormattedText("%s", sbfo.strings.BUFFANCHOR)

  SBFOBuffCountEdit.label:SetText(sbfo.strings.BUFFCOUNT)
	SBFOOpacitySliderLow:SetFormattedText(0.1)
	SBFOOpacitySliderHigh:SetFormattedText(1.0)
	SBFOOpacitySlider:SetMinMaxValues(0.1, 1.0)
	SBFOOpacitySlider:SetValueStep(0.1)
	SBFORowsCheckButtonText:SetFormattedText(self.strings.BUFFHORIZONTAL)
	SBFORowCountSliderLow:SetFormattedText(1)
	SBFORowCountSlider:SetValueStep(1)
	SBFOLayoutConfigButton.text:SetFormattedText(self.strings.LAYOUTCONFIG, self.curFrame.id)
  SBFOFrameVisibilityDropDown.dropDownOptions = { noSort = true, }
  SBFOBuffSortDropDown.dropDownOptions = { noSort = true, }
end

SBFOptions.LayoutTabSelectFrame = function(self, var)
  if var then
    _var = var
  end
	if (self.curFrame.id > 1) then
		SBFORemoveFrameButton:Enable()
	else
		SBFORemoveFrameButton:Disable()
	end
  if (_var.layout.rowCount > _var.layout.count) then
    _var.layout.rowCount = _var.layout.count
  end
  setup = true
  SBFOBuffCountEdit.edit:SetText(_var.layout.count)
	SBFORowCountSlider:SetValue(_var.layout.rowCount)
  SBFORowsCheckButton:SetChecked(_var.layout.rows)
	ScrollingDropDown:SetSelected(SBFOFrameVisibilityDropDown, _var.layout.visibility, ScrollingDropDown.VALUE)
	ScrollingDropDown:SetSelected(SBFOBuffSortDropDown, _var.layout.sort, ScrollingDropDown.VALUE)
	SBFORowCountSliderHigh:SetFormattedText(_var.layout.count)
	SBFORowCountSlider:SetMinMaxValues(1, _var.layout.count)
  SBFORowCountSlider:SetValue(_var.layout.rowCount)
  SBFOOpacitySlider:SetValue(_var.layout.opacity)
  SBFOBuffGrowthSlider:SetValue(_var.layout.growth)
  SBFOBuffAnchorSlider:SetValue(_var.layout.anchor)
	if self.curFrame._var.layout.rows then
		SBFORowCountSliderText:SetFormattedText("%s (%d)", self.strings.ROWCOUNT, self.curFrame._var.layout.rowCount)
	else
		SBFORowCountSliderText:SetFormattedText("%s (%d)", self.strings.COLCOUNT, self.curFrame._var.layout.rowCount)
	end
  rows(_var.layout.rows)
  setup = false
end


SBFOptions.InRows = function(self, checked)
	_var.layout.rows = checked
  rows(_var.layout.rows)
	self:SetupFrame(self.curFrame, true)
end

SBFOptions.FrameVisibilityDropDown_Initialise = function(self)
	SBFOFrameVisibilityDropDown:Init(self.DropDownCallback, self.strings.VISIBILITY)
	local info = SBF:GetTable()
	for i,v in ipairs(SBFOptions.strings.frameVisibility) do
		info.text	= v
		info.value	= i
		info.callback	= SBFOptions.FrameVisibilityDropDown_OnClick
		ScrollingDropDown:AddItem(SBFOFrameVisibilityDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.FrameVisibilityDropDown_OnClick = function(item)
	_var.layout.visibility = item.value
	ScrollingDropDown:SetSelected(SBFOFrameVisibilityDropDown, item.value)
  SBFOFrameVisibilityDropDown:SetFormattedText(item.text)
end

SBFOptions.BuffSortDropDown_Initialise = function(self)
	SBFOBuffSortDropDown:Init(self.DropDownCallback, self.strings.BUFFSORT)
	local info = SBF:GetTable()
	for i,v in pairs(SBF.sortOptions) do
		info.text = SBF.strings.sort[i]
		info.value = i
		info.callback = SBFOptions.BuffSortDropDown_OnClick
		ScrollingDropDown:AddItem(SBFOBuffSortDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.BuffSortDropDown_OnClick = function(item)
	ScrollingDropDown:SetSelected(SBFOBuffSortDropDown, item.value)
	_var.layout.sort = item.value
	SBF.sortFunc = SBF.sortOptions[item.value]
	for index,frame in pairs(SBF.frames) do
    SBF:FrameShowBuffs(frame)
	end
  SBFOBuffSortDropDown:SetFormattedText(item.text)
end

SBFOptions.SetCountColour = function(r,g,b)
	_var.count.colour = {r = r, g = g, b = b}
	SBFOCountColour.texture:SetVertexColor(r, g, b)
	SBFOptions:SetupFrame(self.curFrame, true)
end

SBFOptions.CancelCountColour = function(r,g,b)
	_var.count.colour = {r = r, g = g, b = b}
	SBFOCountColour.texture:SetVertexColor(r, g, b)
	SBFOptions:SetupFrame(self.curFrame, true)
end

SBFOptions.LayoutOpacitySliderChanged = function(self, slider)
  if  not setup and (slider:GetValue() ~= _var.layout.opacity) then
    _var.layout.opacity = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
  end
	SBFOOpacitySliderText:SetFormattedText("%s (%.1f)", self.strings.OPACITY, self.curFrame._var.layout.opacity)
end

SBFOptions.LayoutCountSliderChanged = function(self, slider)
  if  not setup and (slider:GetValue() ~= _var.layout.rowCount) then
    _var.layout.rowCount = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
  end
	SBFORowCountSliderHigh:SetFormattedText(_var.layout.count)
	SBFORowCountSlider:SetMinMaxValues(1, _var.layout.count)
	if self.curFrame._var.layout.rows then
		SBFORowCountSliderText:SetFormattedText("%s (%d)", self.strings.ROWCOUNT, self.curFrame._var.layout.rowCount)
	else
		SBFORowCountSliderText:SetFormattedText("%s (%d)", self.strings.COLCOUNT, self.curFrame._var.layout.rowCount)
	end
end

SBFOptions.GrowthSliderChanged = function(self, slider)
  if not setup and  (slider:GetValue() ~= _var.layout.growth) then
    _var.layout.growth = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
  end
end

SBFOptions.AnchorSliderChanged = function(self, slider)
  if not setup and  (slider:GetValue() ~= _var.layout.anchor) then
    _var.layout.anchor = slider:GetValue()
    self:SetupFrame(self.curFrame, true)
  end
end

SBFOptions.BuffCountEditEnterPressed = function(self, slider)
  local x = tonumber(SBFOBuffCountEdit.edit:GetText())
  if (x < 1) then
    x = 1
  end
  if (x > 100) then
   x = 100
  end
  if x and (x ~= _var.layout.count) then
    _var.layout.count = x
    self:SetupFrame(self.curFrame, false)
  end
  SBFOBuffCountEdit.edit:SetText(_var.layout.count)
end
