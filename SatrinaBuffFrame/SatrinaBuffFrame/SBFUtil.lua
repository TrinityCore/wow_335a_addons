local _G = _G
local sbf = _G.SBF
local tinsert = _G.tinsert
local tremove = _G.tremove
local tonumber = _G.tonumber
local tostring = _G.tostring

local debugMask = 16
-- Make sure SBFUtil.lua is loading after SBFBuff.lua
local enchant = SBF.ENCHANT

sbf.ValueIn = function(self, table, arg1, arg2)
  for k,v in pairs(table) do
    if arg2 then
      if (v[arg1] == arg2) then
        return true
      elseif (v == arg1) then
        return true
      end
    end
  end
  return false
end

local tableCount = function(table, item)
  local count = 0
  for k,v in pairs(table) do
    if (v == item) then
      count = count + 1
    end
  end
  return count
end

sbf.InsertUnique = function(self, t, value)
  if (tableCount(t, value) == 0) then
    tinsert(t, value)
  end
end

sbf.FindFrame = function(self, name)
  for _,frame in pairs(self.frames) do
    if (frame._var.general.frameName == name) then
      return frame
    end
  end
  return nil
end

sbf.RemoveAlwaysWarn = function(self, name, frame)
  if sbf.db.profile.frames[frame] then
    sbf.db.profile.frames[frame].alwaysWarn[name] = nil
  end
end

sbf.AddAlwaysWarn = function(self, name, frame)
  if sbf.db.profile.frames[frame] then
    sbf.db.profile.frames[frame].alwaysWarn[name] = true
  end
end

sbf.IsAlwaysWarn = function(self, name, frame)
  if sbf.db.profile.frames[frame] then
    return (sbf.db.profile.frames[frame].alwaysWarn[name] == true)
  end
  return false
end

sbf.CastableExclude = function(self, name)
  for k,v in pairs(self.strings.castableExclude) do
    if string.find(strlower(name), tolower(v)) then
      return true
    end
  end
  return false
end

local c
sbf.Castable = function(self, buff)
  if buff.spellId then
    if self.db.global.spells[buff.spellId] and self.db.global.spells[buff.spellId][4] then
      return (self.db.global.spells[buff.spellId][4] == self.playerClass) or (self.db.global.spells[buff.spellId][4] == "ANYONE"), self.db.global.spells[buff.spellId][4]
    end
  elseif buff.name then
    if self.db.global.spells[buff.name] and self.db.global.spells[buff.name][4] then
      return (self.db.global.spells[buff.name][4] == self.playerClass) or (self.db.global.spells[buff.name][4] == "ANYONE"), self.db.global.spells[buff.name][4]
    end
  end
  return nil, nil -- isCastable will update cache on nil return
end

sbf.Dispellable = function(self, buff)
  if (type(buff) == "table") and buff.spellId then
    if self.db.global.spells[buff.spellId] and self.db.global.spells[buff.spellId][6] then
      return self:ValueIn(self.db.global.spells[buff.spellId][6], self.playerClass)
    end
  end
  return nil -- isDispellable will update on nil return
end

sbf.CacheSpell = function(self, buff)
  local new = false
  if (buff.spellId) then
    if not self.db.global.spells[buff.spellId] then
      self.db.global.spells[buff.spellId] = {}
      new = true
    end
    
    if not self.db.global.spells[buff.spellId][1] or (self.db.global.spells[buff.spellId][1] < buff.duration) then
      self.db.global.spells[buff.spellId][1] = buff.duration
      new = true
    end
    if not self.db.global.spells[buff.spellId][2] then
      self.db.global.spells[buff.spellId][2] = buff.untilCancelled
    end
    if not self.db.global.spells[buff.spellId][3] then
      self.db.global.spells[buff.spellId][3] = buff.auraType
    end
    if not self.db.global.spells[buff.spellId][4] and buff.casterIsPlayer then
      self.db.global.spells[buff.spellId][4] = buff.casterClass
    elseif (self.db.global.spells[buff.spellId][4] ~= self.playerClass) and buff.castable and buff.casterIsPlayer then
      -- This should fix up effects like flasks and such
      self.db.global.spells[buff.spellId][4] = "ANYONE"
      new = true
    end
    if buff.dispellable then
      if not self.db.global.spells[buff.spellId][6] then
        self.db.global.spells[buff.spellId][6] = {}
      end
      self:InsertUnique(self.db.global.spells[buff.spellId][6], self.playerClass)
      new = true
    end
    self.db.global.spells[buff.spellId][5] = time()
    self.db.global.spells[buff.spellId][7] = buff.name
    return new
  end
  return false
end

sbf.EmptyFunc = function()
end

--
-- Misc.
--

sbf.DisableDefaultBuffFrame = function(self)
  if not sbf.db.profile.showDefaultBuffs then
    BuffFrame:ClearAllPoints() 
    BuffFrame:SetPoint("BOTTOM", UIParent, "TOP", 0, 100)
    BuffFrame:UnregisterAllEvents()
    BuffFrame:SetScript("OnUpdate", nil)
    BuffFrame:Hide()
    -- Just try to re-show the frame now, random addon!
    BuffFrame.SetPoint = self.EmptyFunc
    BuffFrame.Show = self.EmptyFunc
  end

  if not sbf.db.profile.showDefaultEnchants then
    TemporaryEnchantFrame:ClearAllPoints()
    TemporaryEnchantFrame:SetPoint("BOTTOM", UIParent, "TOP", 0, 100)
    TemporaryEnchantFrame:SetScript("OnUpdate", nil)
    TemporaryEnchantFrame:Hide()
    TempEnchant1:SetScript("OnUpdate", nil)
    TempEnchant1:Hide()
    TempEnchant2:SetScript("OnUpdate", nil)
    TempEnchant2:Hide()
    -- In this case, the GM ticket frame would be the guilty one to re-anchor it.
    TemporaryEnchantFrame.SetPoint = self.EmptyFunc
    TemporaryEnchantFrame.Show = self.EmptyFunc
  end
end

--
-- Buff Sorting
--
sbf.NoSort = function(a,b) -- Ascending index
  if (a == nil) then return false end
	if (b == nil) then return true end
	if SBF.db.profile.enchantsFirst then
    if a.auraType and b.auraType and (a.auraType ~= b.auraType) then
      if (a.auraType == enchant) then return false end
      if (b.auraType == enchant) then return true end
    end
  end
	if not tonumber(a.index) then return false end
	if not tonumber(b.index) then return true end
  return a.index > b.index
end

sbf.AscendingNameSort = function(a,b)
	if (a == nil) then return false end
	if (b == nil) then return true end
	if SBF.db.profile.enchantsFirst then
    if a.auraType and b.auraType and (a.auraType ~= b.auraType) then
      if (a.auraType == enchant) then return false end
      if (b.auraType == enchant) then return true end
    end
  end
	if (type(a.name) ~= "string") or not tostring(a.name) then return false end
	if (type(b.name) ~= "string") or not tostring(b.name) then return true end
	return a.name > b.name
end

sbf.DescendingNameSort = function(a,b)
	if (a == nil) then return true end
	if (b == nil) then return false end
	if SBF.db.profile.enchantsFirst then
    if a.auraType and b.auraType and (a.auraType ~= b.auraType) then
      if (a.auraType == enchant) then return false end
      if (b.auraType == enchant) then return true end
    end
  end
	if (type(a.name) ~= "string") or not tostring(a.name) then return true end
	if (type(b.name) ~= "string") or not tostring(b.name) then return false end
  return a.name < b.name
end

sbf.AscendingTimeSort = function(a,b)
  if (a == nil) then return false end
	if (b == nil) then return true end
	if SBF.db.profile.enchantsFirst then
    if a.auraType and b.auraType and (a.auraType ~= b.auraType) then
      if (a.auraType == enchant) then return false end
      if (b.auraType == enchant) then return true end
    end
  end
	if (type(a.timeLeft) ~= "number") or not tonumber(a.timeLeft) then return false end
	if (type(a.timeLeft) ~= "number") or not tonumber(b.timeLeft) then return true end
	return a.timeLeft > b.timeLeft
end

sbf.DescendingTimeSort = function(a,b)
	if (a == nil) then return true end
	if (b == nil) then return false end
	if SBF.db.profile.enchantsFirst then
    if a.auraType and b.auraType and (a.auraType ~= b.auraType) then
      if (a.auraType == enchant) then return false end
      if (b.auraType == enchant) then return true end
    end
  end
	if not tonumber(a.timeLeft) then return true end
	if not tonumber(b.timeLeft) then return false end
	return a.timeLeft < b.timeLeft
end

sbf.AscendingDurationSort = function(a,b)
  if (a == nil) then return false end
	if (b == nil) then return true end
	if SBF.db.profile.enchantsFirst then
    if a.auraType and b.auraType and (a.auraType ~= b.auraType) then
      if (a.auraType == enchant) then return false end
      if (b.auraType == enchant) then return true end
    end
  end
	if (type(a.duration) ~= "number") or not tonumber(a.duration) then return false end
	if (type(a.duration) ~= "number") or not tonumber(b.duration) then return true end
	return a.duration > b.duration
end

sbf.DescendingDurationSort = function(a,b)
	if (a == nil) then return true end
	if (b == nil) then return false end
	if SBF.db.profile.enchantsFirst then
    if a.auraType and b.auraType and (a.auraType ~= b.auraType) then
      if (a.auraType == enchant) then return false end
      if (b.auraType == enchant) then return true end
    end
  end
	if not tonumber(a.duration) then return true end
	if not tonumber(b.duration) then return false end
	return a.duration < b.duration
end

--
-- Alpha cycle for flashing buffs
--
sbf.UpdateAlpha = function(self, elapsed)
	self.flashTime = self.flashTime - elapsed
	if (self.flashTime < 0) then
		local overtime = -self.flashTime
		if self.flashState then
			self.flashState = nil
			self.flashTime = BUFF_FLASH_TIME_OFF
		else
			self.flashState = 1
			self.flashTime = BUFF_FLASH_TIME_ON
		end
		if (overtime < self.flashTime) then
			self.flashTime = self.flashTime - overtime
		end
	end

	if self.flashState then
		self.alpha = (BUFF_FLASH_TIME_ON - self.flashTime) / BUFF_FLASH_TIME_ON
	else
		self.alpha = self.flashTime / BUFF_FLASH_TIME_ON
	end
	self.alpha = (self.alpha * (1 - BUFF_MIN_ALPHA)) + BUFF_MIN_ALPHA
	if enchTimer then
		enchTimer = enchTimer - elapsed
	end
end

sbf.FrameUnit = function(self, frame)
  if (type(frame) == "number") then
    if not self.db.profile.frames[frame] then
      return nil
    else
      return self.db.profile.frames[frame].general.unit
    end
  else
    if not frame or not frame._var then
      return nil
    else
      return frame._var.general.unit
    end
  end
end

sbf.FrameExists = function(self, frame)
  return self.db.profile.frames[frame] ~= nil
end