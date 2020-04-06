local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local SBFOFilterButtons = {}
local _var

local commonFilters = {
  "a",
  "d<15",
  "d<30",
  "d<60",
  "D>10",
  "D>20",
  "ha",
  "c",
  "my",
  "to",
  "tr",
  "hm",
  "hd",
  "hp",
  "hc",
  "hu",
}


SBFOptions.FilterTabInitialise = function(self)
	for i=1,10 do
		SBFOFilterButtons[i] = _G["SBFOFilterList"..i]
	end
	SBFOCommonFiltersDropDown:Init(self.DropDownCallback, self.strings.COMMONFILTERS)
	SBFOUsedFiltersDropDown:Init(self.DropDownCallback, self.strings.USEDFILTERS)
  SBFOCommonFiltersDropDown.dropDownOptions = { noSort = true, }
  self:CommonFiltersDropDown_Initialise()
end

local blacklist = function()
  if _var.general.blacklist then
    SBFOFilterHintString:SetText(SBFOptions.strings.FILTERBLACKLIST)
  else
    SBFOFilterHintString:SetText(SBFOptions.strings.FILTERWHITELIST)
  end
end

SBFOptions.FilterTabSelectTab = function(self)
  blacklist()
  SBFOptions:UsedFiltersDropDown_Initialise()
end

SBFOptions.FilterTabSelectFrame = function(self, var)
  if var then
    _var = var
  end
  self:UpdateFilterList()
  blacklist()
end

SBFOptions.AddFilter = function(self)
	if SBFOptions.editFilter then
		_var.filters[SBFOptions.editFilter] = SBFOBuffFilterEdit.edit:GetText()
		SBFOAddFilterButton:SetFormattedText(SBFOptions.strings.ADDFILTER)
		SBFOptions.editFilter = nil
	else
		local str = SBFOBuffFilterEdit.edit:GetText()
		if (string.len(str) > 0) then
			table.insert(_var.filters, str)
		end
	end
	SBFOptions:UpdateFilterList()
	SBFOBuffFilterEdit.edit:SetText("")
	SBFOBuffFilterEdit.edit:ClearFocus()
  SBFOptions:UsedFiltersDropDown_Initialise()
end

SBFOptions.EditFilter = function(self)
	if SBFOptions.currentFilter then
		SBFOptions.editFilter = SBFOptions.currentFilter
		SBFOBuffFilterEdit.edit:SetText(_var.filters[SBFOptions.currentFilter])
		SBFOAddFilterButton:SetFormattedText(SBFOptions.strings.EDITFILTER)
	end
	SBFOptions:UpdateFilterList()
  SBFOptions:UsedFiltersDropDown_Initialise()
end

SBFOptions.RemoveFilter = function(self)
	if SBFOptions.currentFilter then
		table.remove(_var.filters, SBFOptions.currentFilter)
		SBFOptions.currentFilter = nil
	end
	SBFOptions:EditDone()
	SBFOptions:UpdateFilterList()
  SBFOptions:UsedFiltersDropDown_Initialise()
end

SBFOptions.SelectFilter = function(self, index)
	if _var.filters[index] then
		SBFOptions.currentFilter = index
		SBFOptions:EditDone()
		SBFOptions:UpdateFilterList()
	end
end

SBFOptions.EditDone = function(self)
	SBFOAddFilterButton:SetFormattedText(SBFOptions.strings.ADDFILTER)
	self.editFilter = nil
	SBFOBuffFilterEdit.edit:SetText("")
	SBFOBuffFilterEdit.edit:ClearFocus()
end

SBFOptions.UpdateFilterList = function(self)
	local offset = FauxScrollFrame_GetOffset(SBFOFilterListScrollFrame)
	local listIndex,str
	if not self then
		self = SBFOptions
	end
	
	for i=1,10 do
		local listIndex = offset + i
		button = SBFOFilterButtons[i]

		if _var.filters[listIndex] then
			button.label:SetFormattedText(_var.filters[listIndex])
			button.index = listIndex
		else	
			button.label:SetFormattedText("")
		end

		-- Highlight the selected filter
		if SBFOptions.currentFilter and (SBFOptions.currentFilter == listIndex) then
			button:LockHighlight()
			button.label:SetTextColor(1, 1, 1)
		else
			button:UnlockHighlight()
			button.label:SetTextColor(1, 0.82, 0)
		end
	end
	FauxScrollFrame_Update(SBFOFilterListScrollFrame, #_var.filters, 10, 14)
	
	if SBFOptions.currentFilter then
		SBFOFilterEditButton:Enable()
		SBFOFilterRemoveButton:Enable()
	else
		SBFOFilterEditButton:Disable()
		SBFOFilterRemoveButton:Disable()
	end
end

SBFOptions.RemoveFrameFilters = function(self, frame)
end

SBFOptions.ShowFilterHelp = function(self)
  if not SBFOFilterTab.pages then
    SBFOFilterTab.pages = {}
    local str
    for i,page in ipairs(SBFOptions.strings.FILTERHELPHTML) do
      str = SBFOptions.strings.OPENHTML
      for j,line in ipairs(page) do
        str = str..line
      end
      str = str..SBFOptions.strings.CLOSEHTML
      SBFOFilterTab.pages[i] = str
    end
  end
  SBFOHelpFrame.pages = SBFOFilterTab.pages
  SBFOHelpFrame.page = 1
  SBFOHelpFrame.pageStr:SetText(SBFOHelpFrame.page.."/"..#SBFOHelpFrame.pages)
  SBFOHelpFrame.html:SetText(SBFOHelpFrame.pages[SBFOHelpFrame.page])
  SBFOHelpFrame:Show()
end

SBFOptions.CommonFiltersDropDown_Initialise = function(self)
  ScrollingDropDown:ClearItems(SBFOCommonFiltersDropDown)
	local info = SBF:GetTable()
	for k,v in pairs(SBFOptions.strings.COMMONFILTERLIST) do
    info.text = v
    info.value = commonFilters[k]
    info.callback = SBFOptions.CommonFiltersDropDown_OnClick
    ScrollingDropDown:AddItem(SBFOCommonFiltersDropDown, info)
	end
	SBF:PutTable(info)
end

SBFOptions.CommonFiltersDropDown_OnClick = function(item)
	table.insert(_var.filters, item.value)
	SBFOptions:UpdateFilterList()
  SBFOptions:UsedFiltersDropDown_Initialise()
end

SBFOptions.UsedFiltersDropDown_Initialise = function(self)
  ScrollingDropDown:ClearItems(SBFOUsedFiltersDropDown)
	local info = SBF:GetTable()
	for i,f in pairs (SBF.db.profile.frames) do
    for k,v in pairs(f.filters) do
      info.text = v
      info.value = v
      info.callback = SBFOptions.UsedFiltersDropDown_OnClick
      ScrollingDropDown:AddItem(SBFOUsedFiltersDropDown, info)
    end
  end
	SBF:PutTable(info)
end

SBFOptions.UsedFiltersDropDown_OnClick = function(item)
	table.insert(_var.filters, item.value)
	SBFOptions:UpdateFilterList()
end
