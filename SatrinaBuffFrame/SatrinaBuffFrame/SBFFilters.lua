--
-- Filter Functions
--
local _G = _G
local sbf = _G.SBF
local ipairs = ipairs
local pairs = pairs
local tonumber = tonumber
local tostring = tostring
local strlower = strlower
local sgmatch = _G.string.gmatch
local sfind = _G.string.find
local slen = _G.string.len
local sbyte = _G.string.byte
local ssub = _G.string.sub
local smatch = _G.string.match
local sgsub = _G.string.gsub
local UnitAura = _G.UnitAura
local UnitInRaid = _G.UnitInRaid
local GetNumPartyMembers = _G.GetNumPartyMembers
local fr = 0

-- commands
local DMINUTES = 1
local DSECONDS = 2
local RMINUTES = 3
local RSECONDS = 4
local NAME = 5
local AURA = 6
local SPELLID = 7

local DEBUFFCURSE = 10
local DEBUFFMAGIC = 11
local DEBUFFDISEASE = 12
local DEBUFFPOISON = 13
local DEBUFFUNTYPED = 14
local DEBUFFCLEANSE = 15

local MINE = 20
local CASTABLE = 21
local PURGABLE = 22
local STEALABLE = 23

local ENCHANT = 30
local TOTEM = 31
local TRACKING = 32

local TOOLTIP = 40

local HELP = 50
local HARM = 51
local PLAYERCASTER = 52
local NPCCASTER = 53
local PARTYCASTER = 54
local VEHICLE = 55

local NOT = 0
local EQ = 1
local NE = 2
local AP = 3
local NAP = 4
local LT = 5
local LE = 6
local GT = 7
local GE = 8

sbf.BuffSchool = function(self, buff, str)
	if self.showingOptions or not buff or not buff.index then
		return false
	end
  if buff.name == "Recently Bandaged" then
    return true
  end
	if (buff.debuffType == str) then
		return true
	end
	SBFTooltip:SetUnitAura(buff.unit, buff.index, buff.filter); 
	local text = SBFTooltipTextRight1:GetText()
	if str then
		if text and sfind(text, str) then
			return true
		end
	elseif not SBFTooltipTextRight1:GetText() then
		return true
	end
	return false
end

sbf.ScanBuffTooltip = function(self, buff, str)
  if self.showingOptions or not buff or not buff.index then
    return false
  end
	local line
	SBFTooltip:SetUnitAura(buff.unit, buff.index, buff.filter); 
	for i=1,SBFTooltip:NumLines() do
		line = _G["SBFTooltipTextLeft"..i]:GetText()
		if sfind(strlower(line), str) then
			return true
		end
		line = _G["SBFTooltipTextRight"..i]:GetText()
		if line and sfind(strlower(line), str) then
			return true
		end
	end
	return false
end

local EvaluateExpression = function(expr, buff)
  local rc, subrc, a
  rc = true
  for _,ex in pairs(expr) do
    if ((ex.c == DSECONDS) or (ex.c == DMINUTES) or (ex.c == RSECONDS) or (ex.c == RMINUTES)) then
      if buff.untilCancelled then
        subrc = false
      else
        -- Buff duration, seconds
        if (ex.c == DSECONDS) then
          a = buff.duration or 0
        -- Buff duration, minutes
        elseif (ex.c == DMINUTES) then
          a = (buff.duration or 0)/60
        -- Buff time remaining, seconds
        elseif (ex.c == RSECONDS) then
          a = (buff.timeLeft or 0)
        -- Buff time remaining, minutes
        elseif (ex.c == RMINUTES) then
          a = floor(buff.timeLeft or 0)/60
        end
        if a then
          if (ex.m == LT) then
           subrc = (a < ex.d)
          elseif (ex.m == LE) then
           subrc = (a <= ex.d)
          elseif (ex.m == GT) then
           subrc = (a > ex.d)
          elseif (ex.m == GE) then
           subrc = (a >= ex.d)
          end
        end
      end
    -- Act on spellId
    elseif (ex.c == SPELLID) then
      if (ex.m == EQ) then
        subrc = (ex.d == buff.spellId)
      elseif (ex.m == NE) then
        subrc = not (ex.d == buff.spellId)
      end
    -- Act on buff name
    elseif (ex.c == NAME) then
      if (ex.m == EQ) then
        subrc = (ex.d == buff.filterName)
      elseif (ex.m == NE) then
        subrc = not (ex.d == buff.filterName)
      elseif (ex.m == AP) then
        subrc = (sfind(buff.filterName, ex.d) ~= nil)
      elseif (ex.m == NAP) then
        subrc = (sfind(buff.filterName, ex.d) == nil)
      end
    else
      -- Temporary item enchants
      if (ex.c == ENCHANT) then
        subrc = (buff.auraType == sbf.ENCHANT)
      -- my buffs
      elseif (ex.c == MINE) then
        subrc = (buff.caster == "player")
      -- my buffs
      elseif (ex.c == CASTABLE) then
        subrc = (buff.castableBy == sbf.playerClass) or (buff.castableBy == "ANYONE" and not SBF.db.global.anyAsMine)
      elseif (ex.c == PURGABLE) then
        subrc = buff.dispellable == true
      elseif (ex.c == STEALABLE) then
        subrc = buff.stealable == true
      -- tracking buff
      elseif (ex.c == TRACKING) then
        subrc = buff.isTracking == true
      -- totems
      elseif (ex.c == TOTEM) then
        subrc = (buff.auraType == sbf.TOTEM)
      -- tooltip text
      elseif (ex.c == TOOLTIP) then
        subrc = sbf:ScanBuffTooltip(buff, ex.d)
      -- debuff flag
      elseif (buff.auraType == sbf.HARMFUL) and (ex.c == DEBUFFPOISON) then
        subrc = (buff.debuffType == sbf.POISON)
      elseif (buff.auraType == sbf.HARMFUL) and (ex.c == DEBUFFDISEASE) then
        subrc = (buff.debuffType == sbf.DISEASE)
      elseif (buff.auraType == sbf.HARMFUL) and (ex.c == DEBUFFCURSE) then
        subrc = (buff.debuffType == sbf.CURSE)
      elseif (buff.auraType == sbf.HARMFUL) and (ex.c == DEBUFFMAGIC) then
        subrc = (buff.debuffType == sbf.MAGIC)
      elseif (buff.auraType == sbf.HARMFUL) and (ex.c == DEBUFFUNTYPED) then
        subrc = (buff.debuffType == sbf.NONE)
      -- untilCancelled flag
      elseif (ex.c == AURA) then
        subrc = (buff.untilCancelled == true)
      elseif (ex.c == HELP) then
        subrc = UnitIsFriend("player", buff.unit) == 1
      elseif (ex.c == HARM) then
        subrc = UnitIsEnemy("player", buff.unit) == 1
      elseif (ex.c == PLAYERCASTER) then
          subrc = buff.casterIsPlayer 
      elseif (ex.c == NPCCASTER) then
        if not buff.static then
          subrc = not buff.casterIsPlayer 
        else
          subrc = false
        end
      elseif (ex.c == PARTYCASTER) and buff.caster then
        subrc = UnitInParty(buff.caster) or UnitInRaid(buff.caster)
      elseif (ex.c == VEHICLE) then
        subrc = (buff.caster == "vehicle")
      end
      -- negate it if specified
      if (ex.m == NE or ex.m == NOT or ex.m == NAP) then
        subrc = not subrc
      end
    end
    rc = rc and subrc
  end
	return rc
end

local bad = function(x)
  if (x == "") or (x == nil) then
    return true
  end
  return false
end

local what = function(x)
  if x == nil then
    return "nil"
  elseif x == "" then
    return "empty string"
  else
    return x
  end
end

local getOperator = function(op)
  if (op == nil) then
    return nil
  end
  if (op == "=") then
    return EQ
  elseif (op == "!=") then
    return NE
  elseif (op == "~") then
    return AP
  elseif (op == "!~") then
    return NAP
  elseif (op == "<") then
    return LT
  elseif (op == "<=") then
    return LE
  elseif (op == ">") then
    return GT
  elseif (op == ">=") then
    return GE
  elseif (op == "!") then
    return NOT
  else
    return nil
  end
end

local isNegation = function(op, flt)
  if not op then
    return nil
  elseif (op == "!") then
    return NOT
  else
    SBF:Print(format("Invalid operator for filter |cff00d2ff%s|r in frame %d.  Operator given was |cff00ff00%s|r.  Operator discarded, check your filter", flt, fr, what(op)))
  end
end

local makeFilter = function(c,m,d,expr)
  local t = {}
  local rFilter = false
  t.ex = expr
  if (c == "d") then
    if bad(d) then
      SBF:Print(format("Invalid argument for filter %s.  Argument given was %s", c, what(d)))
      return
    end
    if bad(m) then
      SBF:Print(format("Invalid operator for filter %s.  Operator given was %s", c, what(m)))
      return
    end
    t.m = getOperator(m)
    t.c = DSECONDS
    t.d = tonumber(d)
  elseif (c == "D") then
    if bad(d) then
      SBF:Print(format("Invalid argument for filter %s.  Argument given was %s", c, what(d)))
      return
    end
    if bad(m) then
      SBF:Print(format("Invalid operator for filter %s.  Operator given was %s", c, what(m)))
      return
    end
    t.m = getOperator(m)
    t.c = DMINUTES
    t.d = tonumber(d)
  elseif (c == "R") then
    if bad(d) then
      SBF:Print(format("Invalid argument for filter %s.  Argument given was %s", c, what(d)))
      return
    end
    if bad(m) then
      SBF:Print(format("Invalid operator for filter %s.  Operator given was %s", c, what(m)))
      return
    end
    t.m = getOperator(m)
    t.c = RMINUTES
    t.d = tonumber(d)
    rFilter = true
  elseif (c == "r") then
    if bad(d) then
      SBF:Print(format("Invalid argument for filter %s.  Argument given was %s", c, what(d)))
      return
    end
    if bad(m) then
      SBF:Print(format("Invalid operator for filter %s.  Operator given was %s", c, what(m)))
      return
    end
    t.m = getOperator(m)
    t.c = RSECONDS
    t.d = tonumber(d)
    rFilter = true
  elseif (c == "id") then
    if bad(d) then
      SBF:Print(format("Invalid argument for filter %s.  Argument given was %s", c, what(d)))
      return
    end
    if bad(m) then
      SBF:Print(format("Invalid operator for filter %s.  Operator given was %s", c, what(m)))
      return
    end
    t.m = getOperator(m)
    t.c = SPELLID
    t.d = tonumber(d)
  elseif (c == "n") then
    if bad(d) then
      SBF:Print(format("Invalid argument for filter %s.  Argument given was %s", c, what(d)))
      return
    end
    if bad(m) then
      SBF:Print(format("Invalid operator for filter %s.  Operator given was %s", c, what(m)))
      return
    end
    t.m = getOperator(m)
    t.c = NAME
    t.d = strlower(d)
    t.esc = string.gsub(t.d, "([%-%+%?%*%(%)])", "%%%1")
  elseif (c == "tt") then
    if bad(d) then
      SBF:Print(format("Invalid argument for filter %s.  Argument given was %s", c, what(d)))
      return
    end
    if bad(m) then
      SBF:Print(format("Invalid operator for filter %s.  Operator given was %s", c, what(m)))
      return
    end
    t.m = getOperator(m)
    t.c = TOOLTIP
    t.d = strlower(d)
  elseif (c == "a") then
    t.c = AURA
    t.m = isNegation(m, c)
  elseif (c == "hc") then
    t.c = DEBUFFCURSE
    t.m = isNegation(m, c)
  elseif (c == "hm") then
    t.c = DEBUFFMAGIC
    t.m = isNegation(m, c)
  elseif (c == "hd") then
    t.c = DEBUFFDISEASE
    t.m = isNegation(m, c)
  elseif (c == "hp") then
    t.c = DEBUFFPOISON
    t.m = isNegation(m, c)
  elseif (c == "hu") then
    t.c = DEBUFFUNTYPED
    t.m = isNegation(m, c)
  elseif (c == "ha") then
    t.c = PURGABLE
    t.m = isNegation(m, c)
  elseif (c == "s") then
    t.c = STEALABLE
    t.m = isNegation(m, c)
  elseif (c == "my") then
    t.c = MINE
    t.m = isNegation(m, c)
  elseif (c == "c") then
    t.c = CASTABLE
    t.m = isNegation(m, c)
  elseif (c == "e") then
    t.c = ENCHANT
    t.m = isNegation(m, c)
  elseif (c == "to") then
    t.c = TOTEM
    t.m = isNegation(m, c)
  elseif (c == "tr") then
    t.c = TRACKING
    t.m = isNegation(m, c)
  elseif (c == "help") then
    t.c = HELP
    t.m = isNegation(m, c)
  elseif (c == "harm") then
    t.c = HARM
    t.m = isNegation(m, c)
  elseif (c == "player") then
    t.c = PLAYERCASTER
    t.m = isNegation(m, c)
  elseif (c == "npc") then
    t.c = NPCCASTER
    t.m = isNegation(m, c)
  elseif (c == "party") then
    t.c = PARTYCASTER
    t.m = isNegation(m, c)
  elseif (c == "v") then
    t.c = VEHICLE
    t.m = isNegation(m, c)
  else
    SBF:Print(format("Invalid command specified in filter \"%s\"", expr))
    return
  end
  return t, rFilter
end

local MakeFilters = function(filterStrings, frame)
  fr = frame
  local filterTable = sbf:GetTable()
  local c,m,d,t,f,tokenString,rFilter
  for index,str in pairs(filterStrings) do
    tokenString = string.format("%s.", str)
    t = sbf:GetTable()
    for expr in string.gmatch(tokenString, "(.-)[&.]") do
      c,m,d,f = nil,nil,nil,nil
      c = smatch(expr, "^(%a+)$") 
      if c then
        f,rFilter = makeFilter(c,m,d,str)
      else
        m,c = smatch(expr, "^([~!<>=][~=]?)(%a+)$") 
        if c then
          f,rFilter = makeFilter(c,m,d,str)
        else
          c,m,d = smatch(expr, "^(%a+)([~!<>=][~=]?)(.*)$") 
          if c then 
            f,rFilter = makeFilter(c,m,d,str)
          else
            SBF:Print(format("Invalid filter \"%s\"", expr))
          end
        end
      end
      if f then
        table.insert(t, f)
      else
        SBF:Print(format("Not adding filter \"%s\" for frame %s", str, SBF.db.profile.frames[frame].general.frameName))
      end
    end
    if (#t > 0) then
      table.insert(filterTable, t)
      if rFilter then
        SBF.frames[frame].rFilter = true
      end
    else
      sbf:PutTable(t)
    end
  end
  return filterTable
end

local EvaluateFilter = function(f, buff)
  for k,v in ipairs(f) do
    if not EvaluateExpression(v, buff) then
      return false
    end
  end
  return true
end

sbf.TokenizeFilters = function(self)
  for k,v in pairs(self.db.profile.frames) do
    if k then
      self.frames[k].rFilter = false
      self:PutTable(self.frames[k].filters)
      self.frames[k].filters = MakeFilters(v.filters, k)
    end
  end
end

sbf.DoFilters = function(self, buff, f)
  fr = f
	local rc = false
  for _,filter in ipairs(self.frames[f].filters) do
    if EvaluateExpression(filter, buff) then
      return true
    end
	end
  return false
end