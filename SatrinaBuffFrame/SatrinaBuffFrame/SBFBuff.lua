local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
--
-- Buff Functions
-- 

local _G = _G
local sbf = _G["SBF"]
local UnitAura = UnitAura
local tonumber = tonumber
local pairs = pairs
local ipairs = ipairs
local smatch = string.match
local tinsert = tinsert
local tremove = tremove
local GetTime = GetTime

local debugMask = 2

local buffCallouts = {}

sbf.AddCallout = function(self, unit, add, remove)
  if not (unit and add and remove) then
    error("SBF:AddCallout(unit, addFunction, removeFunction)")
    return
  end
  table.insert(buffCallouts, {unit, add, remove})
end

sbf.TOTEM = 1
sbf.TRACKING = 2
sbf.ENCHANT = 10
-- Auras ENCHANT and below are static tables, will not be recycled
-- Auras above ENCHANT will have their tables recycled when they end.  
sbf.HELPFUL = 20
-- Auras below HARMFUL will get buff expiration notices if the frame is set to give them
sbf.HARMFUL = 30

local filters = {
  [20] = "HELPFUL",
  [30] = "HARMFUL", }

local maxBuffs = { 
  [20] = 40, 
  [30] = 40, }
  
local textDesc = {
  [sbf.TOTEM] = "totem",
  [sbf.TRACKING] = "tracking",
  [sbf.ENCHANT] = "enchant",
  [sbf.HELPFUL] = "buff",
  [sbf.HARMFUL] = "debuff",
}

sbf.NONE = "none"
SBF.MAGIC = "Magic"
SBF.CURSE = "Curse"
SBF.DISEASE = "Disease"
SBF.POISON = "Poison"

-- Register units
sbf.RegisterUnits = function(self)
  self.ttunit = false
  self:PutTable(self.buffs)
  self.buffs = self:GetTable()
  self:PutTable(self.debuffs)
  self.debuffs = self:GetTable()

  local unit
  self:PutTable(self.units)
  self.units = self:GetTable()
  for k,v in pairs(self.db.profile.frames) do
    unit = v.general.unit
    self.units[unit] = true
    if UnitExists(unit) then
      self:UnitGUID(unit)
    end
    self.frames[k].unit = unit
    if (unit == "targettarget") then
      self.ttunit = true
    end
    self.frames[k].isParty = string.find(unit, "party") ~= nil
    if v.general.debuffs and not self.debuffs[unit] then
      self.debuffs[unit] = self:GetTable()
    end
    if v.general.buffs and not self.buffs[unit] then
      self.buffs[unit] = self:GetTable()
    end
    self.lastUpdate[unit] = 0
  end
  if not self.buffs["vehicle"] then
    self.buffs["vehicle"] = self:GetTable()
    self.units["vehicle"] = true
  end
  if not self.debuffs["vehicle"] then
    self.debuffs["vehicle"] = self:GetTable()
    self.lastUpdate["vehicle"] = 0
  end
end

sbf.TrackingUnit = function(self, unit)
  return (self.units[unit] ~= nil)
end

local getCastable= function(unit)
  local i = 1
  sbf:PutTable(castableBuffs)
  castableBuffs = sbf:GetTable()
  local name, rank, texture, count, debuffType, duration, expiryTime, caster, isStealable, consolidate, spellId = UnitBuff(unit, i, 1) 
  while spellId do
    if (caster == "player") then
      local t = sbf:GetTable()
      t.name = name
      t.spellId = spellId
      t.expiryTime = expiryTime
      tinsert(castableBuffs, t)
    end
    i = i + 1
    name, rank, texture, count, debuffType, duration, expiryTime, caster, isStealable, consolidate, spellId = UnitBuff(unit, i, 1) 
  end
  
  i = 1
  sbf:PutTable(castableDebuffs)
  castableDebuffs = sbf:GetTable()
  local name, rank, texture, count, debuffType, duration, expiryTime, caster, isStealable, consolidate, spellId = UnitDebuff(unit, i, nil) 
  while spellId do
    if (caster == "player") then
      local t = sbf:GetTable()
      t.name = name
      t.spellId = spellId
      t.expiryTime = expiryTime
      tinsert(castableDebuffs, t)
    end
    i = i + 1
    name, rank, texture, count, debuffType, duration, expiryTime, caster, isStealable, consolidate, spellId = UnitDebuff(unit, i, nil) 
  end
end

local dispellableDebuffs = function(unit)
  local i = 1
  sbf:PutTable(dispellable)
  dispellable = sbf:GetTable()
  local name, rank, texture, count, debuffType, duration, expiryTime, caster, isStealable, consolidate, spellId = UnitDebuff(unit, i, 1) 
  while spellId do
    local t = sbf:GetTable()
    t.name = name
    t.spellId = spellId
    t.expiryTime = expiryTime
    tinsert(dispellable, t)
    i = i + 1
    name, rank, texture, count, debuffType, duration, expiryTime, caster, isStealable, consolidate, spellId = UnitDebuff(unit, i, 1) 
  end
end

local isCastable = function(buff)
  -- buff.castable, buff.castableBy = sbf:Castable(buff)
  -- if not buff.castable then
    if (buff.auraType == SBF.HARMFUL) and SBF:ValueIn(castableDebuffs, "spellId", buff.spellId) then
      buff.castable = true
      buff.castableBy = sbf.playerClass
    elseif SBF:ValueIn(castableBuffs, "spellId", buff.spellId) then
      buff.castable = true
      buff.castableBy = sbf.playerClass
    end
  -- end
end

local isDispellable = function(buff)
  buff.dispellable = sbf:Dispellable(buff)
  if dispellable and (buff.dispellable == nil) then
    for k,v in pairs(dispellable) do
      if (v.spellId == buff.spellId) then
        buff.dispellable = true
      end
    end
  end
end

-- Update auras
sbf.UpdateUnitAuras = function(self, unit)
  if not unit then
    --debugmsg self:debugmsg(debugMask, "Invalid unit specified for UpdateUnitAuras")
    return
  end
	if not self then
    self = sbf
  end
  if self.showingOptions then
		return
	end
  local t
	if self.getAuras[unit] then
    --debugmsg self:debugmsg(debugMask, "Get auras for |cff00ffaa%s|r", unit)
    for k,v in pairs(buffCallouts) do
      if (v[1] == unit) then
        v[3]()
      end
    end
    getCastable(unit)
    self:IterateAuras(unit, self.buffs, self.HELPFUL)
    self:IterateAuras(unit, self.debuffs, self.HARMFUL)
    for k,v in pairs(buffCallouts) do
      if (v[1] == unit) then
        v[2]()
      end
    end
  end
  self:DoUnit(unit)
end

sbf.DoUnit = function(self, unit)
  self:UntilCancelled(unit)
  self:ClearBuffFrames(unit)
  self:PopulateFrames(unit)
  self:SortBuffs(unit)
  self:DoFlow(unit)
  self:ShowBuffs(unit)
end

sbf.DoRFilter = function(self, frame)
  self:ClearBuffFrames(frame.unit, frame)
  self:PopulateFrame(frame)
  if (#frame.buffs > 0) then
    self:SortBuffs(frame.unit, frame)
    self:DoFlow(frame.unit, frame)
    self:FrameShowBuffs(frame)
  end
end

-- Update the auras in a given list for a given unit
local rankRegex = RANK.." (..?)"
sbf.IterateAuras = function(self, unit, list, auraType)
  if not unit then
    --debugmsg self:debugmsg(debugMask, "Invalid unit specified for IterateAuras")
    return 0
  end
  if not list then
    --debugmsg self:debugmsg(debugMask, "No aura list specified for unit %s in UpdateUnitAuras", unit)
    return 0
  end
  if not auraType then
    --debugmsg self:debugmsg(debugMask, "No aura type specified for unit %s in UpdateUnitAuras", unit)
    return 0
  end
  
  local unitList = list[unit]
  if not unitList then
    --debugmsg self:debugmsg(debugMask, "Not tracking buff type |cff00aaff%s|r for unit |cff00ffaa%s|r", unit, filters[auraType])
    return 0
  end
  -- print(string.format("Iterating auras of type |cff00aaff%s|r for |cff00ffaa%s|r", filters[auraType], unit))

	local i,k,index,buff,exists,filter
  
	for i,buff in ipairs(unitList) do
		buff.discard = true
    buff.refreshed = false -- flag buffs with same name but multiple instances so we don't discard extras
	end
  
  local bars = 0
  local i = 1
  local name, rank, texture, count, debuffType, duration, expiryTime, caster, isStealable, consolidate, spellId = UnitAura(unit, i, filters[auraType]) 
  while name and spellId do
		exists = false
    if ((unit == "player") and (caster ~= "vehicle")) or (unit ~= "player") then
      for k,buff in ipairs(unitList) do
        if (spellId == buff.spellId and expiryTime == buff.expiryTime) and not buff.refreshed then
          exists = true
          buff.index = i
          buff.count = count
          buff.expiryTime = expiryTime
          buff.timeLeft = max(0, buff.expiryTime - GetTime())        
          if buff.untilCancelled or (buff.timeLeft > 0) then
            buff.discard = false
          end
          buff.refreshed = true
          break
        end
      end
 
      if name and spellId and not exists then
        buff = self:GetTable()
        buff.warned = self:GetTable()
        buff.index = i
        buff.filter = filters[auraType]
        buff.unit = unit
        buff.name = name
        buff.filterName = strlower(name)
        buff.stealable = (isStealable == 1)
        buff.texture = texture
        buff.count = count
        buff.spellId = spellId
        buff.hadCount = (count > 0)
        buff.debuffType = debuffType or self.NONE
        buff.duration = duration
        buff.start = expiryTime - duration
        buff.rank = tonumber(smatch(rank, rankRegex))
        buff.expiryTime = expiryTime
        buff.timeLeft = max(0, buff.expiryTime - GetTime())        
        buff.untilCancelled = (expiryTime == 0)
        buff.auraType = auraType
        if caster then
          buff.caster = caster
          _, buff.casterClass = UnitClass(buff.caster)
          buff.casterIsPlayer = (UnitIsPlayer(buff.caster))
        end
        isCastable(buff)
        isDispellable(buff)
        self:CacheSpell(buff)
        if not buff.castable and (buff.caster == "player") then
          -- Probably spellstolen
          buff.caster = nil
        end
        self:CasterName(buff)
        if buff.untilCancelled then
          buff.maxTime = self.db.profile.auraMaxTime
        end
        SBF:AuraGained(buff)
        tinsert(unitList, buff)
			end
		end
    i = i + 1
    name, rank, texture, count, debuffType, duration, expiryTime, caster, isStealable, consolidate, spellId = UnitAura(unit, i, filters[auraType]) 
	end

	local clear
  repeat
    clear = true
    for i,buff in ipairs(unitList) do
      if not buff.static and buff.discard then
        clear = false
        self:ExpireBuff(tremove(unitList, i))
        break
      end
    end
  until clear
  
  return #unitList
end

sbf.ClearAuras = function(self)
  for unit,buffList in pairs(self.buffs) do
    while (#buffList > 0) do
      self:ExpireBuff(tremove(buffList), true)
    end
  end
  for unit,buffList in pairs(self.debuffs) do
    while (#buffList > 0) do
      self:ExpireBuff(tremove(buffList), true)
    end
  end
end

-- Expire a buff
sbf.ExpireBuff = function(self, buff, quiet)
  if not buff then
    --debugmsg self:debugmsg(debugMask, "Invalid buff or no slot attached to buff in ExpireBuff")
    return
  end
  SBF:AuraExpired(buff)
  if buff.auraType and (buff.auraType > self.ENCHANT) then
    --debugmsg self:debugmsg(1, "Expiring buff |cff00ffaa%s|r", buff.name)
    self:PutTable(buff)
  end
end

-- New Aura
sbf.AuraGained = function(self, buff)
  if buff then
    --debugmsg self:debugmsg(debugMask, "Gained %s |cff00ffaa%s|r", textDesc[buff.auraType], buff.name)
  end
end

-- Aura expiring
sbf.AuraExpired = function(self, buff)
  if buff then
    --debugmsg self:debugmsg(debugMask, "Buff |cff00ffaa%s|r expired", buff.name)
  end
end

-- Buff about to expire
sbf.ExpiryWarning = function(self, buff, slot, var, frame)
  if not buff then
    --debugmsg self:debugmsg(debugMask, "No buff specified for ExpiryWarning")
    return
  end

  if not buff.warned then
    buff.warned = self:GetTable()
  end
  
  if var then
    local warnExpire = not buff.untilCancelled and (self:IsAlwaysWarn(buff.name, frame) or ((buff.duration or 0) >= var.expiry.minimumDuration))
    if warnExpire and not buff.warned[frame] and not buff.untilCancelled and not UnitIsDead("player") 
    and not UnitIsGhost("player") and (floor(buff.timeLeft or 0) == var.expiry.warnAtTime) then
      --debugmsg self:debugmsg(debugMask, "Expiry warning for |cff00ffaa%s|r", buff.name)
      buff.warned[frame] = true
      if var.timer and not var.timer.debuffColour then
        slot.timer.text:SetVertexColor(var.timer.expiringColour.r, var.timer.expiringColour.g, var.timer.expiringColour.b)
      end
      if var.icon and var.expiry.flash then
        slot.icon:SetScript("OnUpdate", self.BuffIcon_OnUpdate)
      end
      if var.expiry.textWarning then
        local frame = _G[var.expiry.frame or "ChatFrame1"]
        frame:AddMessage(string.format("|cff00ff00%s|r %s", tostring(buff.name), self.strings.BUFFEXPIRE))
      end
      if var.expiry.sctWarn then
        self:CombatTextWarning(buff, var)
      end
      if var.expiry.soundWarning then
        local s = SML:Fetch("sound", var.expiry.sound)
        if s then
          PlaySoundFile(s)
        end
      end
		end
	end
end

SBF.IsFlowChild = function(self, f)
  if not f then
    --debugmsg self:debugmsg(debugMask, "No frame specified for IsFlowChild")
    return
  end
  for frame,data in pairs(self.db.profile.flow) do
    for index,child in pairs(data) do
      if (child == f) then
        return frame
      end
    end
  end
  return nil
end

SBF.HasFlowChildren = function(self, f)
  if not f then
    --debugmsg self:debugmsg(debugMask, "No frame specified for HasFlowChildren")
    return
  end
  for frame,data in pairs(self.db.profile.flow) do
    if (frame == f) then
      return true
    end
  end
  return false
end


sbf.DoFlow = function(self, unit, f)
  --debugmsg self:debugmsg(128, "flowing %s", unit)
  if not unit then
    --debugmsg self:debugmsg(debugMask, "Invalid unit specified for DoFlow")
    return
  end
  local srcFrame, n, buff
  for index,frame in pairs(self.frames) do
    if not f or (frame == f) then
      if (frame.unit == unit) and (#frame.buffs < frame._var.layout.count) and self:HasFlowChildren(index) then
        -- this much room left for Flow buffs
        n = frame._var.layout.count - #frame.buffs 
        --debugmsg self:debugmsg(128, "flowing up to %d buffs into frame %d", n, index)
        if (n > 0) then
          for i,f in pairs(self.db.profile.flow[index]) do
            srcFrame = self.frames[f]
            if not srcFrame then
              break
            end
            --debugmsg self:debugmsg(128, "flowing from frame %d (%d)", srcFrame.id, #srcFrame.buffs)
            while (n > 0) and (#srcFrame.buffs > 0) do
              buff = tremove(srcFrame.buffs)
              --debugmsg self:debugmsg(128, "flowing buff %s", buff.name)
              buff.flowFrom = f
              tinsert(frame.buffs, buff)
              n = n - 1
            end
          end
        end
      end
    end
  end
end

-- Magic for until cancelled buffs
sbf.UntilCancelled = function(self, unit)
  if not unit then
    --debugmsg self:debugmsg(debugMask, "Invalid unit specified for UntilCancelled")
    return
  end
  if self.buffs[unit] then
    for i,buff in ipairs(self.buffs[unit]) do
      if buff.untilCancelled then
        if self.db.profile.auraMaxTime then
          buff.timeLeft = 9999
          if buff.isTracking then
            buff.timeLeft = buff.timeLeft + 1
          end
        else
          buff.timeLeft = 0
        end
      end
    end
  end
  if self.debuffs[unit] then
    for i,buff in ipairs(self.debuffs[unit]) do
      if buff.untilCancelled then
        if self.db.profile.auraMaxTime then
          buff.timeLeft = 9999
        else
          buff.timeLeft = 0
        end
      end
    end
  end
end

-- Screw you table.sort
local i,high,low,tmp,num
local sort = function(t, func)
  num = #t
  if (num == 1) then
    return
  end
  for i=2,num do
    high = i
    repeat
      low = high - 1
      if func(t[low], t[high]) then
        tmp = t[low]
        t[low] = t[high]
        t[high] = tmp
        high = low
      else
        break
      end
    until (high <= 1)
  end
end

sbf.SortBuffs = function(self, unit, f)
  if not unit then
    --debugmsg self:debugmsg(debugMask, "Invalid unit specified for SortBuffs")
    return
  end
  for index,frame in pairs(self.frames) do 
    if not f or (frame == f) then
      if (frame.unit == unit) then
        if tonumber(frame._var.layout.sort) and self.sortOptions[frame._var.layout.sort] then
          sort(frame.buffs, self.sortOptions[frame._var.layout.sort])
        else
          --debugmsg self:debugmsg(debugMask, "Invalid sort specified")
        end
      end
    end
  end
end

local buffList, list, filter, insert
sbf.PopulateFrames = function(self, unit)
  if not unit then
    --debugmsg self:debugmsg(debugMask, "Invalid unit specified for PopulateFrames")
    return
  end
  for i,f in pairs(self.frames) do
    if f.unit == unit then
      self:PopulateFrame(f)
      --debugmsg self:debugmsg(128, "frame %d -> %d", i, #self.frames[i].buffs)
    end
  end
end

sbf.PopulateFrame = function(self, frame)
  if self.showingOptions then
    return
  end
  
  if not frame then
    --debugmsg self:debugmsg(debugMask, "No frame specified for PopulateFrame")
    return
  end
  
  if frame._var.general.buffs then
    self:GetBuffs(self.buffs[frame.unit], frame)
  end
  if frame._var.general.debuffs then
    self:GetBuffs(self.debuffs[frame.unit], frame)
  end
  return true
end

sbf.GetBuffs = function(self, buffList, frame)
  if not buffList then
    return
  end
  
  local blacklist = frame._var.general.blacklist

  for i,buff in ipairs(buffList) do
    insert = false
    
    insert = self:DoFilters(buff, frame.id) 
    if blacklist then
      insert = not insert
    end
    if insert then
      tinsert(frame.buffs, buff)
    end
  end
end

local colour, colourTable, c, id, class
sbf.CasterName = function(self, buff)
    if not colourTable then
      colourTable = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
    end
    if not buff.caster then
      buff.casterName = nil
      return
    end
    if buff.casterIsPlayer then
      if buff.casterClass then
        c = colourTable[buff.casterClass]
        buff.casterName = format("|cff%02x%02x%02x%s|r", c.r*255, c.g*255, c.b*255, UnitName(buff.caster))
      end
    elseif (buff.caster == "vehicle") or (buff.caster == "pet") then
      c = colourTable[self.playerClass]
      buff.casterName = format("%s <|cff%02x%02x%02x%s|r>", UnitName(buff.caster), c.r*255, c.g*255, c.b*255, UnitName("player"))
    elseif smatch(buff.caster, "partypet") and not smatch(buff.caster, "target") then
      id = smatch(buff.caster, ".-(%d%d?)$")
      _, class = UnitClass("party"..id)
      c = colourTable[class]
      buff.casterName = format("%s <|cff%02x%02x%02x%s|r>", UnitName(buff.caster), c.r*255, c.g*255, c.b*255, UnitName("party"..id))
    elseif smatch(buff.caster, "raidpet") and not smatch(buff.caster, "target") then
      id = smatch(buff.caster, ".-(%d%d?)$")
      _, class = UnitClass("raid"..id)
      c = colourTable[class]
      buff.casterName = format("%s <|cff%02x%02x%02x%s|r>", UnitName(buff.caster), c.r*255, c.g*255, c.b*255, UnitName("raid"..id))
    else -- npc caster likely
      buff.casterName = UnitName(buff.caster)
    end
end