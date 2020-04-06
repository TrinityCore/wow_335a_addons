local _G = _G
local sbf = _G.SBF
local ipairs = _G.ipairs
local pairs = _G.pairs
local tinsert = _G.tinsert
local tremove = _G.tremove
local sfind = string.find
local ssub = string.sub
local band = bit.band

local guids = {}

-- TODO: Keep raid/party member GUIDs in here.
SBF.UnitGUID = function(self, unit)
  if UnitExists(unit) then
    guids[unit] = UnitGUID(unit)
    guids[UnitGUID(unit)] = unit
  else 
    if guids[unit] then
      guids[guids[unit]] = nil
    end
    guids[unit] = nil
  end
end

local t

SBF.CombatLog = function(self, wat, _, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, arg1, arg2, arg3, arg4, arg5, arg6)
  if (event == "SPELL_DISPEL") and guids[sourceGUID] and (band(ssub(sourceGUID, 1, 5), "0x00F") == 0) then
    -- arg1 = my spell id, arg2 = my spell name, arg3 = my spell school, arg4 = dispelled spell id, arg5 = dispelled spell name. arg6 = dispelled aura type
    --if SBF.db.global.spells[arg5] then
    --  if not SBF.db.global.spells[arg5][6] then
    --    SBF.db.global.spells[arg5][6] = {}
    --  end
    --  self:InsertUnique(SBF.db.global.spells[arg5][6], select(2, UnitClass(guids[sourceGUID])))
    --end
  elseif sfind(event, "SPELL_AURA") and self.ttunit and UnitExists("targettarget") and not self.inCombat then
    self:ForceGet(nil, "targettarget")
  elseif (destGUID == guids["player"]) then
    if sfind(event, "ENCHANT") then
      -- if we refresh a temp enchant then we'll get ENCHANT_REMOVED and ENCHANT_APPLIED back-to-back
      -- so rather than calling ForceGet here, we let both events pass with only one update call.
      if not self.enchantTimer then
        self.enchantTimer = self:ScheduleTimer("EnchantChanged", 1)
      end
    end
  end
end