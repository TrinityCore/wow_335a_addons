local _G = _G
local sbf = _G.SBF
local tinsert = _G.tinsert
local tremove = _G.tremove
local GetTrackingInfo = _G.GetTrackingInfo

local debugMask = 16

--
-- Tracking icon
--
sbf.AddTrackingBuff = function()
  local self = sbf
  if not self.db.profile.showTracking then
    return
  end
  if self.db.profile.trackFirst then
    tinsert(self.buffs["player"], 1, self.trackingBuff)
  else
    tinsert(self.buffs["player"], self.trackingBuff)
  end
end

sbf.RemoveTrackingBuff = function(self)
  local self = sbf
  if not sbf.buffs["player"] then
    return
  end
  for k,v in pairs(sbf.buffs["player"]) do
    if v.isTracking then
      self:debugmsg(debugMask, "Remove tracking buff from position %d in player buffs", k)
      tremove(sbf.buffs["player"], k)
      return
    end
  end
end

sbf.UpdateTracking = function(self, wasEvent)
  if not self.db.profile.showTracking then
    return
  end
  MiniMapTracking:Hide()
  if not self.trackingBuff then
    self.trackingBuff = {
      duration = 0, 
      untilCancelled = true, 
      auraType = self.TRACKING, 
      type = "TRACKING", 
      isTracking = true, 
      static = true, 
      count = 0, 
      hadCount = false, 
      unit = "player",
      caster = "player",
      castable = true,
      castableBy = "ANYONE",
      casterClass = self.playerClass,
      casterIsPlayer = true,
    }
    self:CasterName(self.trackingBuff)
  end
 
  local name, texture, active
  self.trackingBuff.name = self.strings.NOTRACKING
  self.trackingBuff.texture = [[Interface\Minimap\Tracking\None]]
  for i=1,GetNumTrackingTypes() do 
    name, texture, active = GetTrackingInfo(i)
    if active then
      self.trackingBuff.name = name
      self.trackingBuff.texture = texture
    end
  end
  self.trackingBuff.filterName = strlower(name)
  -- self:CacheSpell(self.trackingBuff)
  
  if wasEvent then
    self:ForceGet(nil, "player")
  end
end