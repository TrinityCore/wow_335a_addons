-- 
-- Enchant functions
-- 
local _G = _G
local sbf = _G.SBF
local GetWeaponEnchantInfo = _G.GetWeaponEnchantInfo
local GetInventoryItemLink = _G.GetInventoryItemLink
local GetInventoryItemTexture = _G.GetInventoryItemTexture
local CancelItemTempEnchantment = _G.CancelItemTempEnchantment
local tinsert = _G.tinsert
local tremove = _G.tremove
local ipairs = _G.ipairs
local pairs = _G.pairs
local smatch = _G.string.match
local format = _G.format

sbf.InventoryChanged = function(self, event, unit)
  if (unit == "player") then
    local update = false
    local itemLink, itemID
    for _,i in pairs(self.enchantID) do
      itemLink = GetInventoryItemLink("player", i)
      if itemLink then
        itemID = smatch(itemLink, "Hitem:(.-):")
        if not self.enchants[i].itemID or (self.enchants[i].itemID and (self.enchants[i].itemID ~= itemID)) then
          if not self.enchantTimer then
            self.enchantTimer = self:ScheduleTimer("EnchantChanged", 1)
          end
        end
      end
    end
  end
end

sbf.enchantID = {16, 17, 18}
sbf.SetupEnchants = function(self)
	if not self.enchants then
		self.enchants = {}
	end
	for _,i in pairs(self.enchantID) do
		if not self.enchants[i] then
			self.enchants[i] = self:GetTable()
			self.enchants[i].auraType = self.ENCHANT
			self.enchants[i].type = "ENCHANT"
			self.enchants[i].invID = i
			self.enchants[i].cancelNum = i-15
      self.enchants[i].static = true
      self.enchants[i].untilCancelled = false
      self.enchants[i].unit = "player"
      self.enchants[i].caster = "player"
      self.enchants[i].castable = true
      self.enchants[i].castableBy = "ANYONE"
      self.enchants[i].casterClass = self.playerClass
      self.enchants[i].casterIsPlayer = true
      self.enchants[i].duration = 3600
		end
	end
end

sbf.ThirtyMinuteEnchant = function(self, buff)
  for k,v in pairs(self.strings.thirtyMinuteEnchants) do
    if string.match(buff.name, v) then
      buff.duration = 1800
    end
  end
end

sbf.AddEnchants = function()
  local self = sbf
  self:UpdateEnchants()
	for index,enchant in pairs(self.enchants) do
		if enchant.hasBuff and enchant.name then
			self:InsertEnchant(index)
		end
	end
end

sbf.InsertEnchant = function(self, invID)
  if not self.buffs["player"] then
    return
  end
  for k,v in ipairs(self.buffs["player"]) do
		if (v.invID == invID) then
			return
		end
	end
  tinsert(self.buffs["player"], self.enchants[invID])
end

sbf.RemoveEnchants = function()
  local self = sbf
  if not self.buffs["player"] then
    return
  end
  local removed
  while true do
    removed = false
    for k,v in ipairs(self.buffs["player"]) do
      if v.invID then
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


sbf.GetEnchantName = function(self, invID)
  SBFTooltip:SetOwner(UIParent,"ANCHOR_NONE") 
	SBFTooltip:ClearLines()
  SBFTooltip:SetInventoryItem("player", invID)
	local name, lines
  lines = SBFTooltip:NumLines()
  self:debugmsg(8, "Tooltip has %d lines", lines)
	if true then
    for i=2,lines do
      line = _G["SBFTooltipTextLeft"..i]:GetText()
      if line then
        self:debugmsg(8, "Tooltip line %d -> %s", i, line)
        name = string.match(line, "^(.-) %(.+%) %(.+%)$")
        if not name then
          name = string.match(line, "^(.-) %(.+%)$")
        end
        if name then
          self:debugmsg(8, "Found enchant name: %s", name)
          return name, false
        end
      end
    end
  end
	local l = GetInventoryItemLink("player", invID)
	if l then
		local name = GetItemInfo(l)
		if name then
      return name, true
    end
	end
  return format("Temporary Enchant %d", invID), true
end

--[[
sbf.EnchantDuration = function(self, buff)
	if self.showingOptions then
    return
  end
  if self.db.global.spells[buff.name] then 
    if self.db.global.spells[buff.name][1] and (self.db.global.spells[buff.name][1] > buff.timeLeft) then
      buff.duration = self.db.global.spells[buff.name][1]
    else
      buff.duration = ceil(buff.timeLeft)
    end
  else
    buff.duration = ceil(buff.timeLeft)
  end
end
]]

sbf.UpdateEnchants = function(self)
  if not self then
    self = SBF
  end
	if not self.showingOptions then
    for k,v in pairs(sbf.enchantID) do
      self.enchants[v].last = self.enchants[v].timeLeft
    end
		self.enchants[16].hasBuff, self.enchants[16].timeLeft, self.enchants[16].count, 
		self.enchants[17].hasBuff, self.enchants[17].timeLeft, self.enchants[17].count,
		self.enchants[18].hasBuff, self.enchants[18].timeLeft, self.enchants[18].count = GetWeaponEnchantInfo()
		local update = false
		for k,v in pairs(self.enchants) do
			if v.hasBuff then
				v.timeLeft = v.timeLeft/1000
        v.expiryTime = GetTime() + v.timeLeft
        v.index = 100 + k -- make sure that .index is always valid for sorting
				if not v.name then
          v.texture = GetInventoryItemTexture("player", v.invID)
          v.name, v.showItem = self:GetEnchantName(v.invID)
          v.itemID = smatch(GetInventoryItemLink("player", v.invID), "Hitem:(.-):")
          v.filterName = strlower(v.name)
          sbf:ThirtyMinuteEnchant(v)
        end
			else
        v.hasBuff = false
				v.name = nil
				self:PutTable(v.warned)
        v.warned = nil
			end
		end
	end
end

sbf.CancelEnchant = function(self, buff)
  CancelItemTempEnchantment(buff.cancelNum)
  buff.hasBuff = nil
  buff.name = nil
  self:PutTable(buff.warned)
  buff.warned = nil
  self.getAuras["player"] = true
end
