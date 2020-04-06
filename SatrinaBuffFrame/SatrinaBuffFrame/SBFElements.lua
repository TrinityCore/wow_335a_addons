-- The idea for caster names in tooltips comes from Jaredrebecci@Barthilas and his nifty little CastBy addon

local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')
local _G = _G
local sbf = _G.SBF
local GetTime = _G.GetTime
local tinsert = _G.tinsert
local tremove = _G.tremove
local CreateFrame = _G.CreateFrame
local ipairs = _G.ipairs
local pairs = _G.pairs
local floor = _G.floor
local smatch = _G.string.match
local sgsub = _G.string.gsub
local sfind = _G.string.find
local sgmatch = _G.string.gmatch
local sbyte = _G.string.byte
local tonumber = _G.tonumber
local DestroyTotem = _G.DestroyTotem
local CancelUnitBuff = _G.CancelUnitBuff


local debugMask = 8

--
-- Buff Bars
--
local bars = {}
local barCount = 0
local barsOut = 0
local element

sbf.GetBar = function(self)
	if (#bars > 0) then
    barsOut = barsOut + 1
    return tremove(bars)
  end
	barCount = barCount + 1
	element = CreateFrame("Button", "SBFBuffBar"..barCount, UIParent, "SBFBuffBarTemplate")
  element.type = "bar"
  barsOut = barsOut + 1
	return element
end

sbf.PutBar = function(self, bar)
	if bar then
    bar._buff = nil
		bar:ClearAllPoints()
		bar:Hide()
    barsOut = barsOut - 1
    tinsert(bars, bar)
	end
end

sbf.SetupBar = function(self, bar, var)
end

local warn = 1
local timer = 0.1

sbf.frameAdjustments = 0
sbf.FrameLevels = function(self, frame, slot)
  if frame and slot then
    local var = frame._var
    local f = frame:GetFrameLevel()
    
    if slot.icon and (slot.icon:GetFrameLevel() ~= f+1) then
      slot.icon:SetFrameLevel(f+1)
      if self.bfModule and slot.icon.__bf_normaltexture then
        slot.icon.__bf_normaltexture:SetDrawLayer("OVERLAY")
      end
    end
    if slot.bar and (slot.bar:GetFrameLevel() ~= f+1) then
      slot.bar:SetFrameLevel(f+1)
    end
    if slot.name and (slot.name:GetFrameLevel() ~= f+var.name.frameLevel) then
      slot.name:SetFrameLevel(f+var.name.frameLevel)
    end
    if slot.count and (slot.count:GetFrameLevel() ~= f+var.count.frameLevel) then
      slot.count:SetFrameLevel(f+var.count.frameLevel)
    end
    if slot.timer and (slot.timer:GetFrameLevel() ~= f+var.timer.frameLevel) then
      slot.timer:SetFrameLevel(f+var.timer.frameLevel)
    end
  end
end

local s
-- update bars on every OnUpdate so that they animate smoothly
sbf.UpdateDurations = function(self, elapsed)
  local var,buff,w
  for i,frame in pairs(self.frames) do
    frame.warn = frame.warn + elapsed
    frame.timer = frame.timer + elapsed
    var = frame._var
    if (#frame.buffs > 0) then
      for j,slot in ipairs(frame.slots) do
        if slot.updateFrameLevel and (slot.updateFrameLevel > 0) then
          slot.updateFrameLevel = slot.updateFrameLevel - 1
          if (slot.updateFrameLevel == 0) then
            self:FrameLevels(frame, slot)
          end
        end
        buff = slot._buff
        if buff then
          if buff.untilCancelled then
            if slot.bar then
              -- Update bar if present
              self:DoBar(var, slot.bar)
            end
          elseif buff.expiryTime then
            -- Update the time left
            buff.timeLeft = max(0, buff.expiryTime - GetTime())
            if buff.timeLeft  and buff.duration then
              buff.timeLeft = min(buff.timeLeft, buff.duration)
            end
            
            if (frame.warn >= 1.00) then
              self:ExpiryWarning(buff, slot, var, i)
            end

            -- Update bar if present
            self:DoBar(var, slot.bar)
          end
          
          if (frame.timer >= frame.timerUpdate) then
            if slot.timer then
              if buff.untilCancelled then
                if frame._var.timer.naTimer then
                  slot.timer.text:SetText(self.strings.NA)
                  slot.timer:Show()
                else
                  slot.timer:Hide()
                end
              else
                self:SetBuffTime(slot.timer, buff.timeLeft, var.timer.format, var.timer.milliseconds)
              end
            end
          end
        --[[ else
          if slot.timer then
            self:SetBuffTime(slot.timer, 0, var.timer.format)
          end
          if slot.bar then
            slot.bar.bar:SetWidth(0)
          end ]]-- 
        end 
      end
    end
    if (frame.warn >= 1.00) then
      frame.warn = 0
    end
    if (frame.timer >= frame.timerUpdate) then
      frame.timer = 0
    end
  end
end

local w, fastBar
sbf.DoBar = function(self, var, bar)
  if var and bar then
    local buff = bar._buff
    if not buff or not buff.duration or not buff.timeLeft then
      return
    end
    if buff.untilCancelled then
      bar.sparkRight:Hide()
      bar.sparkLeft:Hide()
      if self.db.profile.auraMaxTime then
        w = var.bar.width
      else
        w = 0.1
      end
      bar.bar:SetWidth(w)
    else
      --if not buff.duration then
      --  print("duration", buff.name)
      --end
      --if not buff.timeLeft then
      --  print("timeLeft", buff.name)
      --end
      fastBar = false
      if var.bar.fastBar then
        if var.expiry.minimumDuration and var.expiry.warnAtTime then
          fastBar = (buff.duration >= var.expiry.minimumDuration) and (buff.timeLeft <= var.expiry.warnAtTime)
        end
      end
      if (buff.timeLeft < 0) then
        w = 0.1
      elseif fastBar then
        if (var.bar.width > var.bar.height) then
          w = var.bar.width * buff.timeLeft / var.expiry.warnAtTime
        else
          w = var.bar.height * buff.timeLeft/ var.expiry.warnAtTime
        end
      else
        if (var.bar.width > var.bar.height) then
          w = var.bar.width * buff.timeLeft / buff.duration      
        else
          w = var.bar.height * buff.timeLeft / buff.duration      
        end
      end
      if w then
        if (var.bar.width > var.bar.height) then
          if (w > var.bar.width) then
            w = var.bar.width
          elseif (w <= 0) then
            w = 0.1
          end
          bar.bar:SetWidth(w)
          if not var.bar.hideSpark then
            if var.bar.direction == 1 then
              bar.sparkRight:Show()
              bar.sparkLeft:Hide()
              bar.sparkRight:ClearAllPoints()
              bar.sparkRight:SetPoint("LEFT", bar, "LEFT", w - 8, 0)
            elseif var.bar.direction == 3 then
              bar.sparkRight:Hide()
              bar.sparkLeft:Show()
              bar.sparkLeft:ClearAllPoints()
              bar.sparkLeft:SetPoint("RIGHT", bar, "RIGHT", -w + 8, 0)
            else
              bar.sparkRight:Show()
              bar.sparkLeft:Show()
              bar.sparkLeft:ClearAllPoints()
              bar.sparkRight:ClearAllPoints()
              bar.sparkLeft:SetPoint("CENTER", bar, "CENTER", w/2, 0)
              bar.sparkRight:SetPoint("CENTER", bar, "CENTER", -w/2, 0)
            end
          end
        else
          if (w > var.bar.height) then
            w = var.bar.height
          elseif (w <= 0) then
            w = 0.1
          end
          bar.bar:SetHeight(w)
          if not var.bar.hideSpark then
            if var.bar.direction == 1 then
              bar.sparkRight:Show()
              bar.sparkLeft:Hide()
              bar.sparkRight:ClearAllPoints()
              bar.sparkRight:SetPoint("TOP", bar, "TOP", var.bar.width/16, -w + 16)
            elseif var.bar.direction == 3 then
              bar.sparkRight:Hide()
              bar.sparkLeft:Show()
              bar.sparkLeft:ClearAllPoints()
              bar.sparkLeft:SetPoint("BOTTOM", bar, "BOTTOM", var.bar.width/16, w - 16)
            else
              bar.sparkRight:Show()
              bar.sparkLeft:Show()
              bar.sparkLeft:ClearAllPoints()
              bar.sparkRight:ClearAllPoints()
              bar.sparkLeft:SetPoint("CENTER", bar, "CENTER", 0, w/2)
              bar.sparkRight:SetPoint("CENTER", bar, "CENTER", 0, -w/2)
            end
          end
        end
      end
    end
  end
end

sbf.SetBarColour = function(self, bar, colour, alpha)
  bar.bar:SetVertexColor(colour.r, colour.g, colour.b, colour.a or alpha or 1)
end

--
-- Buff Icons
--
local icons = {}
local iconCount = 0
local iconsOut = 0

sbf.GetIcon = function(self)
	if (#icons > 0) then
    iconsOut = iconsOut + 1
    return tremove(icons)
  end
  iconCount = iconCount + 1
  iconsOut = iconsOut + 1
  element = CreateFrame("Button", "SBFBuffIcon"..iconCount, UIParent, "SBFBuffIconTemplate")
  element.type = "icon"
  return element
end

sbf.PutIcon = function(self, icon)
	if icon then
    icon._buff = nil
    icon:SetScript("OnUpdate", nil)
    icon:ClearAllPoints()
    icon:Hide()
    iconsOut = iconsOut - 1
    tinsert(icons, icon)
  end
end

SBF.BuffIcon_OnUpdate = function(self)
  local buff = self._buff
  if buff then
    local var = self:GetParent():GetParent()._var
    if var and not SBF.showingOptions and not buff.untilCancelled and (floor(buff.timeLeft or 0) <= (var.expiry.warnAtTime or 0)) then
      self:SetAlpha(SBF.alpha)
      if self.overlay then
        self.overlay:SetAlpha(1)
      end
      buff.update = false
    end
  end
end

--
-- Buff Timers
--
local timers = {}
local timerCount = 0
local timersOut = 0

sbf.GetTimer = function(self)
	if (#timers > 0) then
    timersOut = timersOut + 1
    return tremove(timers)
  end
  timerCount = timerCount + 1
  timersOut = timersOut + 1
  element = CreateFrame("Frame", "SBFBuffTimer"..timerCount, UIParent, "SBFBuffTimerTemplate")
  element.type = "timer"
  return element
end

sbf.PutTimer = function(self, timer)
	if timer then
		timer.buff = nil
    timer:ClearAllPoints()
		timer:Hide()
    timersOut = timersOut - 1
    tinsert(timers, timer)
	end
end

local dayAbbr = sgsub(DAY_ONELETTER_ABBR, " ", "")
local hourAbbr = sgsub(HOUR_ONELETTER_ABBR, " ", "")
local minAbbr = sgsub(MINUTE_ONELETTER_ABBR, " ", "")
local secAbbr = sgsub(SECOND_ONELETTER_ABBR, " ", "")
local msAbbr = "%2.1fs"
local msAbbr2 = "%2.1f s"

sbf.timerFormat2 = "%02d:%02d"
sbf.timerFormat3 = "%02d:%04.1f"
sbf.SetBuffTime = function(self, timer, timeLeft, timerFormat, milliseconds)
  if not timeLeft or not timer or not timerFormat then
    return
  end
	if (timerFormat == 1) then
		if (timeLeft <= 5) and milliseconds then
      timer.text:SetFormattedText("%2.1f s", timeLeft)
    else
      timer.text:SetFormattedText(SecondsToTimeAbbrev(timeLeft))
    end
	elseif (timerFormat == 2) then
		if (timeLeft <= 5) and milliseconds then
      timer.text:SetFormattedText(self.timerFormat3, floor(timeLeft/60), mod(timeLeft, 60))
    else
      timer.text:SetFormattedText(self.timerFormat2, floor(timeLeft/60), mod(timeLeft, 60))
    end
	elseif (timerFormat == 3) then
		if (timeLeft <= 5) and milliseconds then
      timer.text:SetFormattedText("%2.1f", timeLeft)
    else
      timer.text:SetFormattedText("%d", timeLeft)
    end
	elseif (timerFormat == 4) then
		if (timeLeft <= 5) and milliseconds then
      timer.text:SetFormattedText("%2.1f", timeLeft)
    elseif (floor(timeLeft) <= 60) then
      timer.text:SetFormattedText("%d", floor(timeLeft))
    else
      timer.text:SetFormattedText("")      
    end
  elseif (timerFormat == 5) then
    timer.text:SetFormattedText("")      
	elseif (timerFormat == 6) then
		if (timeLeft >= 86400) then
			timer.text:SetFormattedText(dayAbbr, ceil(timeLeft/ 86400))
		elseif (timeLeft >= 3600) then
			timer.text:SetFormattedText(hourAbbr, ceil(timeLeft/ 3600))
		elseif (timeLeft >= 60) then
			timer.text:SetFormattedText(minAbbr, ceil(timeLeft / 60))
		elseif timeLeft <= 5 and milliseconds then
			timer.text:SetFormattedText(msAbbr, timeLeft)
		else
			timer.text:SetFormattedText(secAbbr, floor(timeLeft))
		end
	elseif (timerFormat == 7) then
    if (timeLeft >= 86400) then
			timer.text:SetFormattedText(dayAbbr, ceil(timeLeft/ 86400))
		elseif (timeLeft >= 3600) then
			timer.text:SetFormattedText(hourAbbr, ceil(timeLeft/ 3600))
		elseif (timeLeft >= 60) then
			timer.text:SetFormattedText(minAbbr, ceil(timeLeft / 60))
		elseif timeLeft <= 5 and milliseconds then
			timer.text:SetFormattedText("%2.1f", timeLeft)
    else
			timer.text:SetFormattedText(floor(timeLeft))
		end 
	end
end

--
-- Buff Names
--
local names = {}
local nameCount = 0
local namesOut = 0

sbf.GetName = function(self)
	if (#names > 0) then
    namesOut = namesOut + 1
    return tremove(names)
  end
  nameCount = nameCount + 1
  namesOut = namesOut + 1
	element = CreateFrame("Button", "SBFBuffName"..nameCount, UIParent, "SBFBuffNameTemplate")
  element.type = "name"
  return element
end

sbf.PutName = function(self, name)
	if name then
		name.buff = nil
    name:ClearAllPoints()
		name:Hide()
    namesOut = namesOut - 1
    tinsert(names, name)
	end
end

-- Roman numeral conversion
local roman = { 
  {1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"}, {100, "C"}, {90, "XC"}, 
  {50, "L"}, {40, "L"}, {10, "X"}, {9, "IX"}, {5, "V"}, {4, "IV"}, {1, "I"}, }

local toRoman = function(n)
  if not n then
    return ""
  end
  -- Theoretically you can do any number here, but MMMMMMMMMMMMMMMMMMMMMMM is pretty silly!
  local s = ""
	for k,v in ipairs(roman) do
    while (n - v[1] >= 0) do
      s = s ..v[2]
      n = n - v[1]
    end
  end
	return s
end

-- replace rank placeholder in a string
local rankFmt = function(nFmt, buff, var)
  if buff then
    if nFmt and var.name then
      local rank = smatch(nFmt, "[Rr][Aa][Nn][Kk]%[.-%]")
      if rank then
        local rank = smatch(nFmt, "[Rr][Aa][Nn][Kk]%[.-%]")
        if rank then
          rank = sgsub(rank, "[%(%)%[%]%+%.%*]", "%%%1")
          if (buff.rank == "") or not buff.rank or (buff.rank == 0) then
            nFmt = sgsub(nFmt, rank, "")
            nFmt = sgsub(nFmt, "  ", " ")
          else
            local replace = sgsub(rank, "[Rr][Aa][Nn][Kk]%%%[(.+)%%%]", "%1")
            if sfind(replace, "[Rr][Oo][mM][Aa][nN]") then
              replace = sgsub(replace, "[Rr][Oo][mM][Aa][nN]", toRoman(buff.rank))
            end
            if sfind(replace, "[Aa][Rr][Aa][Bb][Ii][Cc]") then
              replace = sgsub(replace, "[Aa][Rr][Aa][Bb][Ii][Cc]", buff.rank)
            end
            nFmt = sgsub(nFmt, rank, replace)
          end
        end
      end
    end
  end
  return nFmt
end

-- replace count placeholder in a string
local countFmt = function(nFmt, buff, var)
  if buff then
    if nFmt and var.name then
      local count = smatch(nFmt, "[cC][Oo][Uu][Nn][Tt]%[.+%]")
      if count then
        count = sgsub(count, "[%(%)%[%]%+%.%*]", "%%%1")
        local replace = sgsub(count, "[cC][Oo][Uu][Nn][Tt]%%%[(.+)%%%]", "%1")

        if sfind(replace, "[nN][Oo][Rr][Mm][Aa][Ll]") then
          if buff.hadCount and buff.count and (buff.count > 1) then
            replace = sgsub(replace, "[nN][Oo][Rr][Mm][Aa][Ll]", buff.count)
          else
            nFmt = sgsub(nFmt, count, "")
            nFmt = sgsub(nFmt, "  ", " ")
          end
        end

        if sfind(replace, "[aA][Ll][Ww][Aa][yY][sS]") then
          local c = buff.count
          if not c or (c == 0) then 
            c = 1 
          end
          replace = sgsub(replace, "[aA][Ll][Ww][Aa][yY][sS]", c)
        end

        if sfind(replace, "[sS][tT][Aa][cC][kK]") then
          if buff.hadCount then
            replace = sgsub(replace, "[sS][tT][Aa][cC][kK]", buff.count or 1)
          else
            nFmt = sgsub(nFmt, count, "")
            nFmt = sgsub(nFmt, "  ", " ")
          end
        end

        nFmt = sgsub(nFmt, count, replace)
      end
    end
  end
  return nFmt
end

local strTmp = CreateFrame("Button")
local shortName = function(name, supershort)
	strTmp:SetFormattedText("")
	for word in sgmatch(name, "[^%s]+") do 
    if not supershort or (supershort and (sbyte(word, 1) > 64) and (sbyte(word, 1) < 91)) then
      if tonumber(word) then
        strTmp:SetFormattedText("%s%s", strTmp:GetText() or "", word)
      else
        strTmp:SetFormattedText("%s%s", strTmp:GetText() or "", smatch(word, "^."))
      end
      if sfind(word, "[:]") then
        strTmp:SetFormattedText("%s:", strTmp:GetText())
      end
    end
	end
	return strTmp:GetText()
end

local truncateName = function(name, a, b)
  if name then
    strTmp:SetFormattedText("")
    strTmp:SetFormattedText(string.sub(name, a, b))
    return strTmp:GetText()
  end
end

local ofChop = function(name)
  local a,b = string.find(name, SBF.strings.OFTHE)
  if not a then
    a,b = string.find(name, SBF.strings.OF)
  end
  if b then
    return string.sub(name, b+2)
  end
  return name
end

-- replace name placeholder in a string
local nameFmt = function(nFmt, buff, var)
  if buff and buff.name then
    if nFmt and var.name then
      local alpha, beta
      local name = smatch(nFmt, "[nN][aA][mM][eE]%[.-%]")
      if name then
        name = sgsub(name, "[%(%)%[%]%+%.%*]", "%%%1")
        local replace = sgsub(name, "[nN][aA][mM][eE]%%%[(.+)%%%]", "%1")

        if sfind(replace, "[Ff][Uu][Ll][Ll]") then
          replace = sgsub(replace, "[Ff][Uu][Ll][Ll]", buff.name)
        elseif sfind(replace, "[Xx][Ss][Hh][Oo][Rr][Tt]") then
          replace = sgsub(replace, "[Xx][Ss][Hh][Oo][Rr][Tt]", shortName(buff.name, true))
        elseif sfind(replace, "[Ss][Hh][Oo][Rr][Tt]") then
          replace = sgsub(replace, "[Ss][Hh][Oo][Rr][Tt]", shortName(buff.name, false))
        elseif sfind(replace, "[Tt][Rr][Uu][Nn][Cc]") then
          alpha = string.match(replace, "[Tt][Rr][Uu][Nn][Cc]:(..?.?)")
          replace = sgsub(replace, "[Tt][Rr][Uu][Nn][Cc]:..?.?", truncateName(buff.name, 1, tonumber(alpha) or 20))
        elseif sfind(replace, "[Cc][Hh][Oo][Pp]") then
          alpha = string.match(replace, "[Cc][Hh][Oo][Pp]:(..?.?)")
          replace = sgsub(replace, "[Cc][Hh][Oo][Pp]:..?.?", truncateName(buff.name, tonumber(alpha) or 20))
        elseif sfind(replace, "[Oo][Ff]") then
          alpha = string.match(replace, "[oO][Ff]")
          replace = sgsub(replace, "[oO][Ff]", ofChop(buff.name))
        end
        
        nFmt = sgsub(nFmt, name, replace)
      end
    end
  else
    if not buff then
      -- sbf:Print("No buff given to format name")
    elseif not buff.name then
      -- sbf:Print("Buff has no name to format")
    end
  end
  return nFmt
end


sbf.FormatName = function(self, buff, var)
  if var and var.name then
    local nFmt = var.name.nameFormat
    -- name format string
    nFmt = nameFmt(nFmt, buff, var)
    -- rank format string
    nFmt = rankFmt(nFmt, buff, var)
    -- count format string
    nFmt = countFmt(nFmt, buff, var)
    
    return nFmt
  else
    return buff.name
  end
end

--
-- Buff Counts
--
local counts = {}
local countCount = 0
local countsOut = 0

sbf.GetCount = function(self)
	if (#counts > 0) then
    countsOut = countsOut + 1
    return tremove(counts)
  end
  countCount = countCount + 1
  countsOut = countsOut + 1
	element = CreateFrame("Frame", "SBFBuffCount"..countCount, UIParent, "SBFBuffCountTemplate")
  element.type = "count"
  return element
end

sbf.PutCount = function(self, count)
	if count then
		count.buff = nil
    count:ClearAllPoints()
		count:Hide()
    countsOut = countsOut - 1
    tinsert(counts, count)
	end
end


--
-- Buff Anchors
--
local anchors = {}
local anchorCount = 0

sbf.GetAnchor = function(self)
	if (#anchors > 0) then
    return tremove(anchors)
  end
  anchorCount = anchorCount + 1
	local a = CreateFrame("Frame", "SBFBuffAnchor"..anchorCount, UIParent, "SBFBuffAnchorTemplate")
  a.dot:SetBackdropColor(1,0,0,1)
  return a
end

sbf.PutAnchor = function(self, anchor)
	if anchor then
		anchor.buff = nil
    anchor:ClearAllPoints()
		anchor:Hide()
    anchor:SetFrameStrata("LOW")
    tinsert(anchors, anchor)
	end
end

sbf.ElementStats = function(self)
  self:Print(format("%d icons created: %d out, %d in", iconCount, iconsOut, #icons))
  self:Print(format("%d timers created: %d out, %d in", timerCount, timersOut, #timers))
  self:Print(format("%d counts created: %d out, %d in", countCount, countsOut, #counts))
  self:Print(format("%d bars created: %d out, %d in", barCount, barsOut, #bars))
  self:Print(format("%d names created: %d out, %d in", nameCount, namesOut, #names))
end

--
-- Utility
--
sbf.FastUpdates = function(self, elapsed)
  sbf:UpdateDurations(elapsed)
end

local var, elementVar, unit, buff
sbf.ShowTooltip = function(self)
  if self._buff then
    GameTooltip:SetOwner(self)
    var = self:GetParent():GetParent()._var
    elementVar = var[self.type]
    unit = self._buff.unit or PLAYER
    if not sbf.showingOptions and not elementVar.noTooltips then
      if (self._buff.auraType == sbf.ENCHANT) and self._buff.hasBuff then
        if self._buff.showItem then
          GameTooltip:SetInventoryItem(unit, self._buff.invID)
        else
          GameTooltip:SetText(self._buff.name)
          GameTooltip:AddLine(SecondsToTime(self._buff.timeLeft or 0, true))
          GameTooltip:Show()
        end
      elseif self._buff.totemSlot then
        GameTooltip:SetTotem(self._buff.totemSlot)
      elseif self._buff.isTracking then
        GameTooltip:SetText(self._buff.name)
      elseif self._buff.name then
        GameTooltip:SetUnitAura(unit, self._buff.index, self._buff.filter)
        if self._buff.casterName and not SBF.db.profile.settings.noCasterName then
          GameTooltip:AddLine(self._buff.casterName)
        end
        GameTooltip:Show()
      end
    end
  else
    GameTooltip:SetText(sbf.strings.BUFFERROR)
  end
end

sbf.HideTooltip = function(self)
	GameTooltip:Hide()
end

sbf.Buff_OnClick = function(self, button)
  if not sbf.showingOptions then
    local var = self:GetParent():GetParent()._var
    local elementVar = self.isBar and var.bar or var.icon
    if self._buff.isTracking then
      ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, 0, -5)
		elseif (button == "RightButton") and not IsShiftKeyDown() then
			if (self._buff.auraType == sbf.ENCHANT) then
        SBF:CancelEnchant(self._buff)
			elseif self._buff.totemSlot then
        if string.find(self._buff.name, SBF.strings.SENTRYTOTEM) then
          CancelUnitBuff(self._buff.unit, self._buff.index, self._buff.filter)
        else
          DestroyTotem(self._buff.totemSlot)
        end
      else
        -- CancelUnitBuff(self._buff.unit, self._buff.index, self._buff.filter)
        sbf:Print("Dismissing buffs by right click is currently unavailable due to Blizzard shenanigans.")
			end
		elseif (button == "LeftButton") then
      if IsAltKeyDown() then
        sbf:PrintBuff(self._buff)
      end
		end
	end
end

sbf.PrintBuff = function(self, buff)
  print(UnitAura(buff.unit, buff.index, buff.filter))
  for k,v in pairs(buff) do
    sbf:Print(format("%s => %s", tostring(k), tostring(v)))
  end
end

-- SBF_Buff_OnClick = sbf.Buff_OnClick