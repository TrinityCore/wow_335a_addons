local ScrollingDropDown = LibStub and LibStub:GetLibrary('LibScrollingDropDown-1.0')
local sbfo = SBFOptions
local strings = SBFOptions.strings
local SBFOSpellListButtons = {}
local _var
local _buffs = true
local _currentSpellIndex = -1

local blacklist = function()
  if _var.general.blacklist then
    SBFOSpellFilterNameCheckButtonText:SetFormattedText(strings.BLACKLISTCHECK)
    SBFOSpellFilterIdCheckButtonText:SetFormattedText(strings.BLACKLISTIDCHECK)
  else
    SBFOSpellFilterNameCheckButtonText:SetFormattedText(strings.WHITELISTCHECK)
    SBFOSpellFilterIdCheckButtonText:SetFormattedText(strings.WHITELISTIDCHECK)
  end
end

SBFOptions.SpellTabInitialise = function(self)
  SBFOSpellTTLEditLabel:SetText(self.strings.SPELLTTL)
  SBFOSpellMineCheckButtonText:SetText(self.strings.MINE)
	for i=1,10 do
		SBFOSpellListButtons[i] = _G["SBFOSpellList"..i]
	end
end

SBFOptions.SpellTabSelectTab = function(self)
  blacklist()
  SBFOSpellTTLEdit.edit:SetText(SBF.db.global.spellTTL)
end

SBFOptions.SpellTabSelectFrame = function(self, var)
  if var then
    _var = var
  end
  self:SetSpellList(true)
  blacklist()
end

SBFOptions.SpellFilterName = function(self, checked)
	local spell = self.cache[_currentSpellIndex]
  local filterIndex, filter = self:FindFilter(spell)
  if filterIndex then 
    table.remove(_var.filters, filterIndex)
  end
  if checked then
    local flt = format("n=%s", strlower(spell.name))
    if SBFOSpellMineCheckButton:GetChecked() then
      flt = flt .. "&my"
    end
    if filterIndex then
      table.insert(_var.filters, filterIndex, flt)
    else
      table.insert(_var.filters, flt)
    end
  end
  self:FindFilter(spell)
	self:UpdateSpellList()
	self:SelectSpell()
end

SBFOptions.SpellFilterId = function(self, checked)
	local spell = self.cache[_currentSpellIndex]
  local filterIndex, filter,isId = self:FindFilter(spell)
  if filterIndex then 
    table.remove(_var.filters, filterIndex)
  end
  if checked then
    local flt = format("id=%d", spell.spellId)
    if SBFOSpellMineCheckButton:GetChecked() then
      flt = flt .. "&my"
    end
    if filterIndex then
      table.insert(_var.filters, filterIndex, flt)
    else
      table.insert(_var.filters, flt)
    end
  end
  self:FindFilter(spell)
	self:UpdateSpellList()
	self:SelectSpell()
end

SBFOptions.SpellMine = function(self)
  if (SBFOSpellFilterNameCheckButton:GetChecked() == 1) then
    self:SpellFilterName(true)
  elseif (SBFOSpellFilterIdCheckButton:GetChecked() == 1) then
    self:SpellFilterId(true)
  end
end

SBFOptions.AlwaysWarn = function(self, checked)
	if checked then
		SBF:AddAlwaysWarn(self.cache[_currentSpellIndex], self.curFrame.id)
	else
		SBF:RemoveAlwaysWarn(self.cache[_currentSpellIndex], self.curFrame.id)
	end
	self:UpdateSpellList()
end

SBFOptions.ClearSpellCache = function(self)
  SBF:PutTable(SBF.db.global.spells)
  SBF.db.global.spells = SBF:GetTable()
  self:SetSpellList(true)
end

SBFOptions.SetSpellList = function(self, buffs)
  if buffs then
    SBFOShowBuffsCheckButton:SetChecked(true)
    SBFOShowDebuffsCheckButton:SetChecked(false)
  else
    SBFOShowBuffsCheckButton:SetChecked(false)
    SBFOShowDebuffsCheckButton:SetChecked(true)
  end
  _buffs = (buffs == true)
  self:FillSpellList()
end

local sortfunc = function(a,b)
  return a.name < b.name
end

SBFOptions.FillSpellList = function(self)
  self.cacheSize = #SBF.db.global.spells
  SBF:PutTable(self.cache)
  self.cache = SBF:GetTable()
  local pattern = strlower(SBFOSpellFilterEdit.edit:GetText())
  for spellId,data in pairs(SBF.db.global.spells) do 
    if data[3] then
      if (data[3] >= SBF.HARMFUL) and not _buffs then
        if not pattern or string.find(strlower(data[7]), pattern) then
          table.insert(self.cache, {["spellId"] = spellId, ["name"] = data[7]})
        end
      elseif (data[3] < SBF.HARMFUL) and _buffs then
        if not pattern or string.find(strlower(data[7]), pattern) then
          table.insert(self.cache, {["spellId"] = spellId, ["name"] = data[7]})
        end
      end
    else
      SBF.db.global.spells[spellId] = nil
    end
  end
  table.sort(self.cache, sortfunc)
  _currentSpellIndex = -1
  self:UpdateSpellList()
  self:SelectSpell()
end

SBFOptions.UpdateSpellList = function(self)
	local listIndex, spell, frame, filter, alwaysWarn, filterFrame, filter, rFilterFrame, rFilter
	local offset = FauxScrollFrame_GetOffset(SBFOSpellListScrollFrame)
	if not SBFOptions.fauxBuff then
		SBFOptions.fauxBuff = {}
	end

  for i=1,10 do
    listIndex = offset + i
    button = SBFOSpellListButtons[i]
    spell = SBFOptions.cache[listIndex]

    if spell then
      button.label:SetFormattedText("%s (%d)", spell.name, spell.spellId)
      button.index = listIndex

      filter = sbfo:FindFilter(spell)
      alwaysWarn = SBF:IsAlwaysWarn(spell.name, sbfo.curFrame.id)
      if filter or alwaysWarn then
        button.label:SetTextColor(GREEN_FONT_COLOR.r,GREEN_FONT_COLOR.g,GREEN_FONT_COLOR.b)
      elseif filterFrame or rFilterFrame then
        button.label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      else
        button.label:SetTextColor(GRAY_FONT_COLOR.r,GRAY_FONT_COLOR.g,GRAY_FONT_COLOR.b)
      end
    else	
      button.label:SetFormattedText("")
      button.listIndex = nil
    end

    -- Highlight selected 
    if (_currentSpellIndex == listIndex) then
      button:LockHighlight()
    else
      button:UnlockHighlight()
    end
	end
	FauxScrollFrame_Update(SBFOSpellListScrollFrame, #SBFOptions.cache, 10, 14)
end

SBFOptions.FindFilter = function(self, spell)
  if not spell then
    return
  end
  local s = string.gsub(strlower(spell.name), "([%-%+%?%(%)%.])", "%%%1")
  local flt = format("n=%s", s)
  for k,v in pairs(_var.filters) do
    if string.match(v, flt) then
      return k,v,false
    end
  end
  flt = format("id=%d", spell.spellId)
  for k,v in pairs(_var.filters) do
    if string.match(v, flt) then
      return k,v,true
    end
  end
  return nil
end

SBFOptions.SelectSpell = function(self, index)
	if index then
    _currentSpellIndex = index
  end
  if (_currentSpellIndex > 0) then
    local spell = self.cache[_currentSpellIndex]
    local filterIndex,filter,isId = self:FindFilter(spell)
    if filter then
      SBFOSpellName:SetFormattedText("%s (%s)", spell.name, filter)
    else
      SBFOSpellName:SetFormattedText("%s", spell.name)
    end

    SBFOptions:EnableCheckbox(SBFOSpellFilterNameCheckButton)
    SBFOSpellFilterNameCheckButton:SetChecked(isId == false)
    SBFOptions:EnableCheckbox(SBFOSpellFilterIdCheckButton)
    SBFOSpellFilterIdCheckButton:SetChecked(isId == true)

    SBFOptions:EnableCheckbox(SBFOAlwaysWarnCheckButton)
    SBFOAlwaysWarnCheckButton:SetChecked(SBF:IsAlwaysWarn(spell, sbfo.curFrame.id))
    
    local isCastable = SBF:Castable(spell, (_buffs and "HELPFUL" or "HARMFUL"))
    if isCastable and (SBFOSpellFilterNameCheckButton:GetChecked() == 1) or (SBFOSpellFilterIdCheckButton:GetChecked() == 1) then
      sbfo:EnableCheckbox(SBFOSpellMineCheckButton)
      if filter and string.match(filter, "&my") then
        SBFOSpellMineCheckButton:SetChecked(true)
      else
        SBFOSpellMineCheckButton:SetChecked(false)
      end
    else
      sbfo:DisableCheckbox(SBFOSpellMineCheckButton)
    end
  else
    SBFOSpellName:SetText()
    SBFOptions:DisableCheckbox(SBFOAlwaysWarnCheckButton)
    SBFOptions:DisableCheckbox(SBFOSpellFilterNameCheckButton)
    SBFOptions:DisableCheckbox(SBFOSpellFilterIdCheckButton)
    SBFOptions:DisableCheckbox(SBFOSpellMineCheckButton)
    button:UnlockHighlight()
  end
	self:UpdateSpellList()
end

SBFOptions.SpellTTLEditEnterPressed = function(self, slider)
  local x = tonumber(SBFOSpellTTLEdit.edit:GetText())
  if x then
    SBF.db.global.spellTTL = x
  end
  SBFOSpellTTLEdit.edit:SetText(SBF.db.global.spellTTL)
end
