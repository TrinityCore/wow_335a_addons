local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
local lbf = LibStub("LibButtonFacade", true)

local _G = _G
local sbf = _G.SBF
local GetCursorPosition = _G.GetCursorPosition
local CreateFrame = _G.CreateFrame
local ipairs = _G.ipairs
local pairs = _G.pairs
local tinsert = _G.tinsert
local tremove = _G.tremove
local floor = _G.floor
local InCombatLockdown = _G.InCombatLockdown

local debugMask = 4
local debugMask2 = 32

-- 
-- Frames
-- 

local verticalJustifyMap = { [1] = "TOP", [2] = "CENTER", [3] = "BOTTOM", ["TOP"] = 1, ["CENTER"] = 2, ["BOTTOM"] = 3, }

--
-- Secure Button stuff
--
local SecureButton = function(button, isPlayer)
  button:SetAttribute("*type1", "onClick")
  if true then return end
  
  if (isPlayer) then
    button:SetAttribute("type2", "cancelaura")
    button:SetAttribute("unit", "player")
  else
    button:SetAttribute("type2", nil)
    button:SetAttribute("unit", nil)
  end
end

--
-- Frame creation
--
sbf.CreateFrames = function(self, frame)
	local f
  
	if not frame then
    while (#self.frames > 0) do
      self:PutBuffFrame(tremove(self.frames))
    end
  end
	
	for i,var in pairs(self.db.profile.frames) do
    if not frame or (frame == i) then
      if self.frames[i] then
        f = self.frames[i]
      else
        f = self:GetBuffFrame()
        local t1,t2 = f:GetName().."Tab1", f:GetName().."Tab2"
        f.tab1 = _G[t1] or CreateFrame("Frame", t1, UIParent, "BuffFrameDragTabTemplate")
        f.tab2 = _G[t2] or CreateFrame("Frame", t2, UIParent, "BuffFrameDragTabTemplate")
      end
      f.id = i
      f._var = var
      
      f.tab1:ClearAllPoints()
      f.tab2:ClearAllPoints()
      f.tab1:SetPoint("BOTTOM", f, "TOP")
      f.tab2:SetPoint("TOP", f, "BOTTOM")
      f.tab1.frame = f
      f.tab2.frame = f
      f.tab1.label:SetFormattedText(var.general.frameName)
      f.tab2.label:SetFormattedText(var.general.frameName)

      f.buffs = f.buffs or {}
      
      if not var.layout.point then
        if (i == 1) then
          self.db.profile.frames[i].layout.point = {"TOPRIGHT", -65, -250}
        elseif (i == 2) then
          self.db.profile.frames[i].layout.point = {"TOPRIGHT", -110, -250}
        else
          self.db.profile.frames[i].layout.point = {"CENTER", 0, 0}
        end
      end
      f:Show()
      f:ClearAllPoints()
      f:SetPoint(var.layout.point[1], UIParent, var.layout.point[1], var.layout.point[2], var.layout.point[3])
      self.frames[i] = f
      if frame then
        return f
      end
    end
	end
end

local frames = {}
sbf.GetBuffFrame = function(self)
	for i,frame in pairs(frames) do
		if not frame.inUse then
			frame.inUse = true
			return frame
		end
	end
	i = #frames + 1
	local f = CreateFrame("Frame", "SBFFrame"..i, UIParent, "SBFBuffFrameTemplate")
	tinsert(frames, f)
	f.inUse = true
	return f
end

sbf.PutBuffFrame = function(self, f)
	if f then
    f.tab1:Hide()
    f.tab2:Hide()
    if f.buffs then
      while (#f.buffs > 0) do
        self:ExpireBuff(tremove(f.buffs), true)
      end
    end
    if f.slots then
      while (#f.slots > 0) do
        self:PutSlot(tremove(f.slots))
      end
    end
    f._var = nil
    f:ClearAllPoints()
    f:Hide()
    f.inUse = false
  end
end

sbf.ClearFrame = function(self, frame)
  while (#frame.slots > 0) do
    self:PutSlot(tremove(frame.slots))
  end
end

sbf.FillFrame = function(self, frame)
  local slot
  for i=1,frame._var.layout.count do
    slot = self:PopulateSlot(frame._var.icon, frame._var.timer, frame._var.bar, frame._var.name, frame._var.count)
    slot.index = i
    if slot.icon then
      SecureButton(slot.icon, frame._var.general.unit == "player")
    end
    if slot.bar then
      SecureButton(slot.bar, frame._var.general.unit == "player")
    end
    if slot.name then
      SecureButton(slot.name, frame._var.general.unit == "player")
    end
    tinsert(frame.slots, slot)
  end
end


--
-- Frame buffs
--
sbf.ClearBuffFrames = function(self, unit, f)
  for i,frame in pairs(self.frames) do
    if not f or (frame == f) then
      if (frame.unit == unit) or self.showingOptions then
        if frame.buffs then
          while (#frame.buffs > 0) do
            tremove(frame.buffs)
          end
        end
      end
    end
	end
end

--
-- Frame setup
--
sbf.SetupFrames = function(self, leaveSlots)
  self.flash = false
  for index,frame in pairs(self.frames) do
    if frame._var.expiry.flash then
      self.flash = true
    end
    self:SetupFrame(frame, leaveSlots)
  end
  self:SetupExtents()
end

sbf.SetupFrame = function(self, frame, leaveSlots)
  if not frame or not frame._var then
    --debugmsg self:debugmsg(debugMask, "Error setting up frame %d", frame.id or 0)
    return
  end
  if not frame.slots then
    frame.slots = self:GetTable()
  end

  --debugmsg self:debugmsg(debugMask, "Setting up %d slots in frame %d", frame._var.layout.count, frame.id)
  
  if not leaveSlots then
    self:ClearFrame(frame)
    self:FillFrame(frame)
  end
  
	local var = frame._var
  local backdrop
  
  if var.bar then
    backdrop = { bgFile = SML:Fetch("background", var.bar.barBGTexture), tile = true, tileSize = 4, }
  end
  
  if var.timer and var.timer.milliseconds then
    frame.timerUpdate = 0.09
  else
    frame.timerUpdate = 0.97
  end
  frame.warn = 0
  frame.timer = 0
  
  frame:SetAlpha(var.layout.opacity)
  frame:EnableMouse(var.general.clickthrough ~= true)
  if self.bfModule then
    self.bfModule:UndoGroup(frame._var.general.frameName)
  end
	for j,slot in ipairs(frame.slots) do
    if var.icon then
      slot.icon:Show()
      slot.icon:SetParent(slot.anchor)
      slot.icon:ClearAllPoints()
      slot.icon:SetPoint("CENTER", slot.anchor, "CENTER", var.icon.x, var.icon.y)
      slot.icon:SetWidth(var.icon.size)
      slot.icon:SetHeight(var.icon.size)
      slot.icon.border:SetHeight(var.icon.size + 2)
      slot.icon.border:SetWidth(var.icon.size + 2)
      slot.icon:EnableMouse(var.general.clickthrough ~= true)
      slot.icon.cooldownSweep:SetReverse(var.icon.reverseCooldown)
      slot.icon:SetAlpha(var.icon.opacity)
      if var.icon.suppressCooldownTimer then
        if IsAddOnLoaded("OmniCC") then
          slot.icon.cooldownSweep.noCooldownCount = true
        end
      else 
        slot.icon.cooldownSweep.noCooldownCount = nil
      end
    end

    if var.timer then
      slot.timer:Show()
      slot.timer:SetParent(slot.anchor)
      slot.timer:ClearAllPoints()
      slot.timer:SetPoint("CENTER", slot.anchor, "CENTER", var.timer.x, var.timer.y)
			slot.timer.text:SetJustifyH(var.timer.justify)
			slot.timer.text:SetFont(SML:Fetch("font", var.timer.font), var.timer.fontSize, (var.timer.outline and "OUTLINE" or nil))
    end

    if var.bar then
      slot.bar:Show()
      slot.bar:SetParent(slot.anchor)
      slot.bar:ClearAllPoints()
      slot.bar:SetPoint("CENTER", slot.anchor, "CENTER", var.bar.x, var.bar.y)
      slot.bar:SetWidth(var.bar.width)
      slot.bar:SetHeight(var.bar.height)
      slot.bar:SetBackdrop(backdrop)
      slot.bar:SetBackdropColor(var.bar.bgColour.r, var.bar.bgColour.g, var.bar.bgColour.b, var.bar.bgColour.a) 
      slot.bar.bar:ClearAllPoints()
      if (var.bar.width > var.bar.height) then
        slot.bar.bar:SetPoint(self.justify[var.bar.direction], slot.bar, self.justify[var.bar.direction], 0, 0)
      else
        slot.bar.bar:SetPoint(verticalJustifyMap[var.bar.direction], slot.bar, verticalJustifyMap[var.bar.direction], 0, 0)
        slot.bar.sparkRight:SetRotation(1.5708)
        slot.bar.sparkRight:SetWidth(var.bar.width * 2.7)
        slot.bar.sparkLeft:SetRotation(1.5708)
        slot.bar.sparkLeft:SetWidth(var.bar.width * 2.7)
        slot.bar.rotated = true
      end
      slot.bar.bar:SetWidth(var.bar.width)
      slot.bar.bar:SetHeight(var.bar.height)
      slot.bar.bar:SetTexture(SML:Fetch("statusbar", var.bar.barTexture), true)
      slot.bar:EnableMouse(var.general.clickthrough ~= true)
      if var.bar.hideSpark then
        slot.bar.sparkLeft:Hide()
        slot.bar.sparkRight:Hide()
      elseif var.bar.direction == 1 then
        slot.bar.sparkLeft:Hide()
        slot.bar.sparkRight:Show()
        slot.bar.sparkRight:ClearAllPoints()
        slot.bar.sparkRight:SetPoint("RIGHT", slot.bar, "RIGHT", 0, 0)
      elseif var.bar.direction == 3 then
        slot.bar.sparkLeft:Show()
        slot.bar.sparkRight:Hide()
        slot.bar.sparkLeft:ClearAllPoints()
        slot.bar.sparkLeft:SetPoint("LEFT", slot.bar, "LEFT", 0, 0)
      else
        slot.bar.sparkLeft:Show()
        slot.bar.sparkRight:Show()
        slot.bar.sparkLeft:ClearAllPoints()
        slot.bar.sparkLeft:SetPoint("LEFT", slot.bar, "LEFT", 0, 0)
        slot.bar.sparkRight:ClearAllPoints()
        slot.bar.sparkRight:SetPoint("RIGHT", slot.bar, "RIGHT", 0, 0)
      end
      
      if var.bar.disableRightClick then
        slot.bar:RegisterForClicks("LeftButtonUp")
      else
        slot.bar:RegisterForClicks("LeftButtonUp", "RightButtonUp")
      end
    end
    
    if var.name then
      slot.name:SetParent(slot.anchor)
      slot.name:ClearAllPoints()
      slot.name:SetPoint("CENTER", slot.anchor, "CENTER", var.name.x, var.name.y)
			slot.name.text:SetFont(SML:Fetch("font", var.name.font), var.name.fontSize, (var.name.outline and "OUTLINE" or nil))
			slot.name.text:SetJustifyH(var.name.justify)
      if var.name.mouseActive then
        slot.name:SetScript("OnEnter", self.ShowTooltip)
        slot.name:SetScript("OnLeave", self.HideTooltip)
        slot.name:RegisterForClicks("LeftButtonUp", "RightButtonUp")
      else
        slot.name:SetScript("OnEnter", nil)
        slot.name:SetScript("OnLeave", nil)
        slot.name:RegisterForClicks()
      end
      
      slot.name:Show()
    end

    if var.count then
      slot.count:SetParent(slot.anchor)
      slot.count:ClearAllPoints()
      slot.count:SetPoint("CENTER", slot.anchor, "CENTER", var.count.x, var.count.y)
      slot.count.text:SetVertexColor(var.count.colour.r, var.count.colour.g, var.count.colour.b)
      slot.count.text:SetJustifyH(var.count.justify)
			slot.count.text:SetFont(SML:Fetch("font", var.count.font), var.count.fontSize, var.count.outline and "OUTLINE" or nil)
    end
    slot.anchor:Show()
	end
  if self.bfModule then
    self.bfModule:SetupGroup(frame._var.general.frameName)
  end
	self:ArrangeFrame(frame)
  frame:SetPoint(var.layout.point[1], UIParent, var.layout.point[1], var.layout.point[2], var.layout.point[3])
  self:PutTable(frame.extent)
  frame.extent = nil
end


sbf.ArrangeFrame = function(self, frame)
  if not frame or not frame._var then
    --debugmsg self:debugmsg(debugMask, "Error arranging frame %d", frame.id or 0)
    return
  end
	local var = frame._var
  local	x = var.layout.x
	local y = var.layout.y
	
	if var.bar then
		x = x + var.bar.width
	end
	
	if (#frame.slots > 0) then
		local rowCount, inRows, left, lastAnchor, offX, offY, buffCount, rowMin, leftovers
		local curSlot, slot, lastSlot, lastRowAnchor
		
		buffCount = var.layout.count
		rowCount = var.layout.rowCount
		inRows = var.layout.rows
		rowMin = floor(buffCount/rowCount)
		leftovers = buffCount - (rowMin * rowCount)
    left =  (var.layout.growth == 1)
    offX = 32 + x
    offY = 32 + y
    
    -- state:  1 = buff left or bottom, 2 = buff right or top
    local rowState, colState, anchorRight, anchorLeft, anchorTop, anchorBottom
    remain = rowCount
    for i=1,#frame.slots do
      slot = frame.slots[i]
      slot.anchor:ClearAllPoints()
      slot.anchor:SetParent(frame)
      
      if (i == 1) then
        anchorRight = slot.anchor
        anchorLeft = slot.anchor
        anchorTop = slot.anchor
        anchorBottom = slot.anchor
        nextAnchor = slot.anchor
        slot.anchor:SetPoint("CENTER", frame)
        remain = remain - 1
        rowState,colState = 0,0
      elseif (inRows and rowCount > 1) or (not inRows and rowCount == 1) then
        if (remain == rowCount) then
          if (var.layout.anchor == 1) or ((var.layout.anchor == 2) and (colState == 1)) then
            slot.anchor:SetPoint("CENTER", anchorBottom, "CENTER", 0, offY * -1)
            anchorBottom = slot.anchor
          else
            slot.anchor:SetPoint("CENTER", anchorTop, "CENTER", 0, offY)
            anchorTop = slot.anchor
          end
          anchorRight = slot.anchor
          anchorLeft = slot.anchor
          remain = remain - 1
          colState = mod(colState+1, 2)
          rowState = 0
        else
          if ((var.layout.growth == 2) and (rowState == 1)) or (var.layout.growth == 1) then
            slot.anchor:SetPoint("CENTER", anchorLeft, "CENTER", offX * -1, 0)
            anchorLeft = slot.anchor
          else
            slot.anchor:SetPoint("CENTER", anchorRight, "CENTER", offX, 0)
            anchorRight = slot.anchor
          end
          remain = remain - 1
          if (remain == 0) then
            remain = rowCount
          end
          if (var.layout.growth == 2) or (var.layout.anchor == 2) then
            rowState = mod(rowState+1,2)
          end
        end
      else
        if (remain == rowCount) then
          if (var.layout.anchor == 3) or ((var.layout.anchor == 2) and (rowState == 1)) then
            slot.anchor:SetPoint("CENTER", anchorLeft, "CENTER", offX * -1, 0)
            anchorLeft = slot.anchor
          else
            slot.anchor:SetPoint("CENTER", anchorRight, "CENTER", offX, 0)
            anchorRight = slot.anchor
          end
          anchorTop = slot.anchor
          anchorBottom = slot.anchor
          remain = remain - 1
          rowState = mod(rowState+1, 2)
          colState = 0
        else
          if ((var.layout.growth == 2) and (colState == 1)) or (var.layout.growth == 3) then
            slot.anchor:SetPoint("CENTER", anchorTop, "CENTER", 0, offY * -1)
            anchorTop = slot.anchor
          else
            slot.anchor:SetPoint("CENTER", anchorBottom, "CENTER", 0, offY)
            anchorBottom = slot.anchor
          end
          remain = remain - 1
          if (remain == 0) then
            remain = rowCount
          end
          if (var.layout.growth == 2) or (var.layout.anchor == 2) then
            colState = mod(colState+1,2)
          end
        end
      end
    end
	end
end

--
-- Frame visibility
--
sbf.SetupExtents = function(self)
  for index,frame in pairs(self.frames) do
    for j,slot in pairs(frame.slots) do
      if slot.icon then
        slot.icon:Show()
      end
      if slot.bar then
        slot.bar:Show()
      end
      slot.anchor.dot:Hide()
    end
  end
  self.getExtents = true
  -- OnUpdate will call GetExtents on the next update cycle, after the icons and bars have actually shown
end

sbf.GetExtents = function(self)
  self.scale = UIParent:GetEffectiveScale()
  for index,frame in pairs(self.frames) do
    self:GetExtent(frame)
    self:FrameLevels(frame)
  end
  if not self.showingOptions then
    for index,frame in pairs(self.frames) do
      for _,slot in pairs(frame.slots) do
        if slot.icon then
          slot.icon:Hide()
        end
        if slot.bar then
          slot.bar:Hide()
        end
        slot.anchor.dot:Hide()
      end
    end
  end
  -- should have all extents now
  self.getExtents = false
end


sbf.GetExtent = function(self, frame)
  if (type(frame) == "number") then
    frame = self.frames[frame]
  end
  
  if not frame.slots or (#frame.slots == 0) then
    return
  end
	
  local top, right, bottom, left = 0,0,99999,99999
  local t,r,b,l
  for index,slot in pairs(frame.slots) do
    if slot.icon then
      t,b,l,r = slot.icon:GetTop(), slot.icon:GetBottom(), slot.icon:GetLeft(), slot.icon:GetRight()
      if (t > top) then
        top = t
      end
      if (l < left) then
        left = l
      end
      if (r > right) then
        right = r
      end
      if (b < bottom) then
        bottom = b
      end
    end
    if slot.bar then
      t,b,l,r = slot.bar:GetTop(), slot.bar:GetBottom(), slot.bar:GetLeft(), slot.bar:GetRight()
      if (t > top) then
        top = t
      end
      if (l < left) then
        left = l
      end
      if (r > right) then
        right = r
      end
      if (b < bottom) then
        bottom = b
      end
    end
  end
  
  if not frame.extent then
    frame.extent = self:GetTable()
  end
  frame.extent.left = left
  frame.extent.right = right
  frame.extent.top = top
  frame.extent.bottom = bottom
  return true
end

sbf.FrameVisibility = function(self, unit, f)
  if self.getExtents then
    return
  end
  local partyMembers = GetNumPartyMembers()
  local hidePartyInRaid = UnitInRaid("player") and self.db.global.hideParty and (GetCVar("hidePartyInRaid") == "1")
	for i,frame in pairs(self.frames) do
    if not f or (f == frame) then
      if not unit or (frame.unit == unit) then
        if self.showingOptions then
          frame:Show()
        elseif frame.isParty and hidePartyInRaid then
          frame:Hide()
        elseif (frame._var.layout.visibility == 5) and frame.extent then  -- Mouseover
          if self:MouseIsOver(i) then
            frame:Show()
          else
            frame:Hide()
          end
        elseif (frame._var.layout.visibility == 2) then -- Never
            frame:Hide()
        elseif (frame._var.layout.visibility == 3) then -- Combat
          if InCombatLockdown() then
            frame:Show()
          else
            frame:Hide()
          end
        elseif (frame._var.layout.visibility == 4) then -- Out of Combat
          if InCombatLockdown() then
            frame:Hide()
          else
            frame:Show()
          end
        elseif (frame._var.layout.visibility == 6) then -- Solo
          if (partyMembers > 0) or UnitInRaid("player") then
            frame:Hide()
          else
            frame:Show()
          end
        elseif (frame._var.layout.visibility == 7) then -- Party
          if (partyMembers > 0) and not UnitInRaid("player") then
            frame:Show()
          else
            frame:Hide ()
          end
        elseif (frame._var.layout.visibility == 8) then -- Raid
          if UnitInRaid("player") then
            frame:Show()
          else
            frame:Hide()
          end
        elseif (frame._var.layout.visibility == 9) then -- Party or Raid
          if (partyMembers > 0) or UnitInRaid("player") then
            frame:Show()
          else
            frame:Hide()
          end
        elseif (frame._var.layout.visibility == 10) then -- Friendly
          if UnitIsFriend("player", frame._var.general.unit) then
            frame:Show()
          else
            frame:Hide()
          end
        elseif (frame._var.layout.visibility == 11) then -- Hostile
          if UnitIsEnemy("player", frame._var.general.unit) then
            frame:Show()
          else
            frame:Hide()
          end
        else
          frame:Show()
        end
      end
		end
	end
end

sbf.MouseIsOver = function(self, frame)
  if not frame then
    return
  end
  local s = self.frames[frame]:GetEffectiveScale()
	local extent = self.frames[frame].extent
	if extent then
    local x, y = GetCursorPosition()
    x = x/s
    y = y/s
		return (x >= extent.left) and (x <= extent.right) and (y >= extent.bottom) and (y <= extent.top)
	end
	return false
end

--
-- Frame buff slots
-- 
sbf.PopulateSlot = function(self, icon, timer, bar, name, count)
  local slot = self:GetTable()
  slot.anchor = self:GetAnchor()
  if icon then
    slot.icon = self:GetIcon()
    slot.icon.start = 0
    slot.icon.duration = 0
    slot.icon:Show()
  end
  if timer then
    slot.timer = self:GetTimer()
  end
  if bar then
    slot.bar = self:GetBar()
    slot.bar:Show()
  end
  if name then
    slot.name = self:GetName()
  end
  if count then
    slot.count = self:GetCount()
  end
  return slot
end

sbf.PutSlot = function(self, slot)
  if slot then
    self:PutAnchor(slot.anchor)
    slot.anchor = nil
    self:PutIcon(slot.icon)
    slot.icon = nil
    self:PutTimer(slot.timer)
    slot.timer = nil
    self:PutBar(slot.bar)
    slot.bar = nil
    self:PutName(slot.name)
    slot.name = nil
    self:PutCount(slot.count)
    slot.count = nil
    self:PutTable(slot, true)
  end
end

--
-- Buffs are in the frames, show 'em
--
sbf.ShowBuffs = function(self, unit, f)
  local buff, var, colour
  for i,frame in pairs(self.frames) do
    if not f or (i == frame) then
      if not f or (frame.unit == unit) or (not frame.unit and unit == "player") then
        self:FrameShowBuffs(frame)
      end
    end
  end
end

local white = {1,1,1}
local skin
local findBorderColour = function(frameName)
  if sbf.bfModule then
    skin = sbf.db.profile.buttonFacade[frameName]
    if skin then
      if skin.colours then
        if skin.colours.Normal then
          return skin.colours.Normal
        end
      end
      if skin.skin then
        if sbf.bfModule.skins[skin.skin] then
          if sbf.bfModule.skins[skin.skin].Normal then
            if sbf.bfModule.skins[skin.skin].Normal.Color  then
              return sbf.bfModule.skins[skin.skin].Normal.Color      
            end
          end
        end
      end
    end
  end
  return white
end

--
-- Show the buffs for a frame
--
sbf.FrameShowBuffs = function(self, frame)
  if not frame or not frame.slots or (#frame.slots == 0) then
    return
  end

  local normalColour 
  normalColour = findBorderColour(frame._var.general.frameName)
  
  --debugmsg self:debugmsg(debugMask, "Showing buffs unit '%s' in frame %d", frame.unit, frame.id)
  local var = frame._var
  local buff, debuffColour, warnExpire
  frame.stickySlot = nil
  for j,slot in ipairs(frame.slots) do
    buff = frame.buffs[j]
    if buff then
      --debugmsg self:debugmsg(debugMask2, "frame %d, slot %d -> %s", frame.id, j, buff.name)
      slot._buff = buff
      frame.stickySlot = slot
      
      debuffColour = DebuffTypeColor[buff.debuffType] or DebuffTypeColor.none
      
      if var.name then
        slot.name._buff = buff  -- so OnEnter can do the tooltip without backflips
        slot.name.text:SetText(self:FormatName(buff, var))
        if buff.auraType and (buff.auraType < self.HARMFUL) then
          slot.name.text:SetVertexColor(var.name.buffColour.r, var.name.buffColour.g, var.name.buffColour.b, var.name.buffColour.a) 
        elseif buff.auraType and (buff.auraType == self.HARMFUL) and var.name.colourNameAsDebuff then
          slot.name.text:SetVertexColor(debuffColour.r, debuffColour.g, debuffColour.b, 1)
        else
          slot.name.text:SetVertexColor(var.name.debuffColour.r, var.name.debuffColour.g, var.name.debuffColour.b, var.name.debuffColour.a) 
        end
        if (buff.unit == "player") then
          if (buff.type == "ENCHANT") then
            -- slot.name:SetAttribute("target-slot", buff.invID)
            -- slot.name:SetAttribute("index", nil)
          else
            -- slot.name:SetAttribute("target-slot", nil)
            -- slot.name:SetAttribute("index", buff.index)
          end
        end
        if sbf.showingOptions then
          slot.name:SetBackdropColor(0.5, 0.5, 0.5, 0.75)
        else
          slot.name:SetBackdropColor(0,0,0,0)
        end
        slot.name:Show()
      end
      
      if var.count then
        if buff.count and ((buff.count > 1) or (buff.hadCount and var.count.showOneCount)) or sbf.showingOptions then
          slot.count.text:SetText(buff.count)
          if sbf.showingOptions then
            slot.count:SetBackdropColor(0.5, 0.5, 0.5, 0.75)
          else
            slot.count:SetBackdropColor(0,0,0,0)
          end
          slot.count:Show() 
        else
          slot.count:Hide()
        end
      end
      
      if var.timer then
        warnExpire = not buff.untilCancelled and (self:IsAlwaysWarn(buff.name, frame.id) or ((buff.duration or 0) >= var.expiry.minimumDuration))
        if not buff.untilCancelled then
          local colour
          -- self:SetBuffTime(slot.timer, buff.timeLeft, var.timer.format)
          if (buff.auraType == self.HARMFUL) and var.timer.debuffColour then
            colour = debuffColour
          elseif warnExpire and ((buff.timeLeft or 0) <= var.expiry.warnAtTime) then
            colour = var.timer.expiringColour
            if var.expiry.flash and slot.icon then
              slot.icon:SetScript("OnUpdate", self.BuffIcon_OnUpdate)
            end
          else
            colour = var.timer.regularColour
          end
          slot.timer.text:SetVertexColor(colour.r, colour.g, colour.b)
          self:SetBuffTime(slot.timer, buff.timeLeft, var.timer.format, var.timer.milliseconds)
          if sbf.showingOptions then
            slot.timer:SetBackdropColor(0.5, 0.5, 0.5, 0.75)
          else
            slot.timer:SetBackdropColor(0,0,0,0)
          end
          slot.timer:Show()
        else
          slot.timer:Hide()
        end
      end

      if var.icon then
        slot.icon._buff = buff  -- so OnEnter can do the tooltip without backflips
        slot.icon.icon:SetTexture(buff.texture)
        if not self.showingOptions and not buff.untilCancelled and var.expiry.flash and (floor(buff.timeLeft or 0) <= (var.expiry.warnAtTime or 0)) then
          slot.icon:SetAlpha(self.alpha)
        else
          slot.icon:SetAlpha(var.icon.opacity)
        end
        slot.icon:Show()
        if var.icon.cooldown and not buff.untilCancelled and buff.start and buff.duration and not self.showingOptions then
          if (slot.icon.start ~= buff.start) then
            CooldownFrame_SetTimer(slot.icon.cooldownSweep, buff.start, buff.duration, 1)
            slot.icon.start = buff.start
            slot.icon.cooldownSweep:Show()
          end
        else
          slot.icon.start = 0
          slot.icon.cooldownSweep:Hide()
        end
        if (buff.unit == "player") then
          if (buff.type == "ENCHANT") then
            -- slot.icon:SetAttribute("target-slot", buff.invID)
            -- slot.icon:SetAttribute("index", nil)
          else
            -- slot.icon:SetAttribute("target-slot", nil)
            -- slot.icon:SetAttribute("index", buff.index)
          end
        end
      end

      if var.bar then
        if (buff.unit == "player") then
          if (buff.type == "ENCHANT") then
            -- slot.bar:SetAttribute("target-slot", buff.invID)
            -- slot.bar:SetAttribute("index", nil)
          else
            -- slot.bar:SetAttribute("target-slot", nil)
            -- slot.bar:SetAttribute("index", buff.index)
          end
        end
        slot.bar._buff = buff
        slot.bar.border:Hide()
        self:DoBar(var, slot.bar)
        slot.bar:Show()
      end
    
      if (buff.auraType == self.HARMFUL) then
        if slot.bar then
          if var.bar.debuffBar then
            self:SetBarColour(slot.bar, debuffColour, 1)
          else
            self:SetBarColour(slot.bar, var.bar.debuffColour)
          end
        end
        if slot.icon then
          if self.bfModule then
            if not var.icon.noBFIconBorder then
              lbf:SetNormalVertexColor(slot.icon, debuffColour.r, debuffColour.g, debuffColour.b, 1)
            else
              lbf:SetNormalVertexColor(slot.icon, normalColour[1], normalColour[2], normalColour[3])
            end
          end
          if not var.icon.noIconBorder then
            slot.icon.border:Show()
            slot.icon.border:SetVertexColor(debuffColour.r, debuffColour.g, debuffColour.b, 1)
          else
            slot.icon.border:Hide()
          end
        end
      else
        if slot.bar then
          self:SetBarColour(slot.bar, var.bar.buffColour)
        end
        if slot.icon then
          if self.bfModule then
            lbf:SetNormalVertexColor(slot.icon, normalColour[1], normalColour[2], normalColour[3])
          end
          if not var.icon.noIconBorder then
            slot.icon.border:Show()
            slot.icon.border:SetVertexColor(normalColour[1], normalColour[2], normalColour[3])
          else
            slot.icon.border:Hide()
          end
        end
      end
    else
      if slot.bar then
        slot.bar:Hide()
        -- slot.bar:SetAttribute("index", nil)
        -- slot.bar:SetAttribute("target-slot", nil)
      end
      if slot.timer then
        slot.timer:Hide()
      end
      if slot.icon then
        slot.icon:Hide()
        -- slot.icon:SetAttribute("index", nil)
        -- slot.icon:SetAttribute("target-slot", nil)
      end
      if slot.count then
        slot.count:Hide()
      end
      if slot.name then
        slot.name:Hide()
        -- slot.name:SetAttribute("index", nil)
        -- slot.name:SetAttribute("target-slot", nil)
      end
    end
    if self.showingOptions then
      slot.anchor.dot:Show()
    else
      slot.anchor.dot:Hide()
    end
    slot.updateFrameLevel = 3
  end
end

