-- 
-- Totem timer functions
-- 

local _G = _G
local sbf = _G.SBF
local ipairs = _G.ipairs
local pairs = _G.pairs
local tinsert = _G.tinsert
local tremove = _G.tremove
local GetTotemInfo = _G.GetTotemInfo
local sfind = string.find

local debugMask = 64
SBF.totems = {}

local totemTextures = {
  "Interface\\Icons\\Spell_Nature_StoneSkinTotem",
  "Interface\\Icons\\Spell_Nature_StoneClawTotem",
  "Interface\\Icons\\Spell_Nature_StrengthOfEarthTotem02",
  "Interface\\Icons\\Spell_FireResistanceTotem_01",
  "Interface\\Icons\\Spell_FrostResistanceTotem_01",
  "Interface\\Icons\\Spell_Nature_GroundingTotem",
  "Interface\\Icons\\Spell_Nature_InvisibilityTotem",
  "Interface\\Icons\\Spell_Nature_StrengthOfEarthTotem02",
  "Interface\\Icons\\Spell_Fire_SearingTotem",
  "Interface\\Icons\\Spell_Nature_EarthBindTotem",
  "Interface\\Icons\\Spell_Fire_SealOfFire",
  "Interface\\Icons\\Spell_Nature_TremorTotem",
  "Interface\\Icons\\INV_Spear_04",
  "Interface\\Icons\\Spell_Nature_PoisonCleansingTotem",
  "Interface\\Icons\\Spell_Fire_SelfDestruct",
  "Interface\\Icons\\Spell_Nature_ManaRegenTotem",
  "Interface\\Icons\\Spell_Nature_GuardianWard",
  "Interface\\Icons\\Spell_Nature_NatureResistanceTotem",
  "Interface\\Icons\\Spell_Nature_Windfury",
  "Interface\\Icons\\Spell_Nature_RemoveCurse",
  "Interface\\Icons\\Spell_Nature_EarthBind",
  "Interface\\Icons\\Spell_Nature_DiseaseCleansingTotem",
  "Interface\\Icons\\Spell_Frost_SummonWaterElemental",
  "Interface\\Icons\\Spell_Fire_TotemOfWrath",
  "Interface\\Icons\\Spell_Nature_Brilliance",
  "Interface\\Icons\\Spell_Nature_SlowingTotem",
  "Interface\\Icons\\Spell_Nature_EarthElemental_Totem",
  "Interface\\Icons\\Spell_Fire_Elemental_Totem",
}

SBF.IsTotemIcon = function(self, buff)
  for k,v in ipairs(self.totemTextures) do
    if (buff.texture == v) then
      if (buff.name == self.strings.SPELL_COMBUSTION) or (buff.name == self.strings.SPELL_FR_AURA) then
        return false
      end
      return true
    end
  end
end

-- Totems that give you a buff
--{ "BuffName"] = "GetTotemInfoName" }

SBF.IsBuffTotem = function(self, name)
  for k,v in ipairs(self.strings.buffTotems) do
    if sfind(name, v) then
      return v
    end
  end
  return nil
end

SBF.FindBuffTotem = function(self, name)
  if not self.hasTotems or self.db.profile.noTotemTimers then
    return nil
  end
  
  self:debugmsg(debugMask, "Looking for totem as buff: %s", name)
  for k,v in ipairs(self.buffs["player"]) do
    if sfind(v.name, name) and (v.index < 100 or v.index > 199)then
      self:debugmsg(debugMask, "Found totem as buff: %s", v.name)
      return v
    end
  end
  self:debugmsg(debugMask, "Did not find %s totem as buff", name)
  return nil
end

SBF.AddTotems = function()
  local self = sbf
  if not self.hasTotems or self.db.profile.noTotemTimers then
    return
  end
  
  self:debugmsg(debugMask, "Checking totems")
  local name, start, duration, icon, buff, isBuffTotem
  
  for i=1,4 do
    if self.totems[i] then
      self.totems[i].cleanup = 1
    end
  end
  
  for i=1,4 do
    _, name, start, duration, icon = GetTotemInfo(i)
    if name and (start > 0) then
      buff = nil
      isBuffTotem = self:IsBuffTotem(name)
      if (isBuffTotem ~= nil) then
        buff = self:FindBuffTotem(isBuffTotem)
      end
      if not buff then
        if (not isBuffTotem and not SBF.db.profile.noTotemNonBuffs) or (isBuffTotem and SBF.db.profile.totemOutOfRange) then
          if not self.totems[i] then
            self:debugmsg(debugMask, "Creating totem: %s", name)
            self.totems[i] = self:GetTable()
            self.totems[i].caster = "player"
            self.totems[i].castable = true
            self.totems[i].castableBy = sbf.playerClass
            self.totems[i].casterClass = self.playerClass
            self.totems[i].casterIsPlayer = true
            self:CasterName(self.totems[i])
          else
            self:debugmsg(debugMask, "Reusing created totem: %s", self.totems[i].name)
          end
          buff = self.totems[i]
          buff.texture = icon
          buff.name = name
          buff.filterName = strlower(name)
          buff.createdTotem = true
          buff.static = true
          buff.unit = "player"
          buff.index = 200 + i
        end
      else
        self:debugmsg(debugMask, "Reusing buff totem: %s", buff.name)
      end
      if buff then
        buff.start = start
        buff.duration = duration
        buff.expiryTime = start + duration
        buff.timeLeft = GetTotemTimeLeft(i)
        buff.auraType = self.TOTEM
        buff.type = "HELPFUL"
        buff.untilCancelled = false
        buff.totemName = name
        buff.totemSlot = i
        buff.cleanup = nil
        self:CacheSpell(buff)
      end
    end
  end
  
  for i=1,4 do
    if self.totems[i] and self.totems[i].cleanup then
      self:debugmsg(debugMask, "Destroying created totem: %s", self.totems[i].name)
      self:PutTable(self.totems[i])
      self.totems[i] = nil
    end
  end
  
  for i=1,4 do
    if self.totems[i] then
      tinsert(self.buffs["player"], self.totems[i])
    end
  end
end


SBF.RemoveTotems = function(self)
  local self = sbf
  if not self.buffs["player"] then
    return
  end
  if not self.hasTotems or self.db.profile.noTotemTimers then
    return false
  end

  local removed
  while true do
    removed = false
    for k,v in ipairs(self.buffs["player"]) do
      if v.createdTotem then
        v._slot = nil
        tremove(self.buffs["player"], k)
        removed = true
      end
    end
    if not removed then
      return
    end
  end
end

SBF.TotemUpdate = function(self)
  self:ForceGet(nil, "player")
end