local sbf = SBF
local debugMask = 32
--
-- Saved Vars
-- 
sbf.defaultVars = {
  global = {
    spells = {},
    version = SBF.version
  },
  char = {
    frames = {},
  },
}

sbf.CheckFlows = function(self)
  if self.db.profile.flow then
    local clear
    for i,parent in pairs(self.db.profile.flow) do
      repeat
        clear = true
        for k,child in pairs(parent) do
          if not self:FrameUnit(child) or (self:FrameUnit(i) ~= self:FrameUnit(child)) then
            clear = false
            table.remove(parent, child)
            break
          end
        end
      until clear
    end
  end
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

local removeDuplicates = function(t)
  local newtable = {}
  for k,v in pairs(t) do
    if(tableCount(newtable, v) == 0) then
      table.insert(newtable, v)
    end
  end
  return newtable
end

sbf.DoSavedVars = function(self, verbose)
  local new = false
  if not self.db.profile.frames then
		self.db.profile.frames = {}
    new = true
	end

  self:ValidateFrameVars(1, true)
  if new then
    self:ValidateFrameVars(2, true)
  end
  for i = 2,100 do
    self:ValidateFrameVars(i)
	end

  self.db.global.combatUpdate = self.db.global.combatUpdate or 0.2
  if (self.db.global.combatUpdate < 0.1) or (self.db.global.combatUpdate > 0.5) then
    self.db.global.combatUpdate = 0.2
  end

  if IsAddOnLoaded("ButtonFacade") then
    self.db.profile.buttonFacade = self.db.profile.buttonFacade or {}
  end
  
  -- cleanup old stuff
  self.db.global.throttlePeriod = nil
  self.db.profile.alwaysWarnList = nil
  self.db.profile.exclusionList = nil
  self.db.profile.buffFrameList = nil
  self.db.profile.castable = nil
  self.db.profile.filters = nil
	self.db.global.castable = nil
  self.db.profile.enableFilters = nil
  
  for index,frame in pairs(self.db.profile.frames) do
    frame.frameName = nil
    frame.unit = nil
  end
  
  self.db.profile.flow = self.db.profile.flow or {}
  self.db.profile.settings = self.db.profile.settings or {}

  self:ValidateSpellList()

  self:minorUpdate()
  
  self.db.global.version = self.version

  if self.db.global.message == nil then
    self.db.global.message = true
  end
  
  self:CheckFlows()
  
  -- force a GC cycle to clean up our mess
  collectgarbage()
end

sbf.ValidateSpellList = function(self)
  self.db.global.spells = self.db.global.spells or {}
  self.db.global.spellTTL = 30
  self.spellTTL = 30
  local cutoff = time() - (self.db.global.spellTTL * 86400)
  
  for k,v in pairs(self.db.global.spells) do
    -- Duplicates in castable list
    if v[6] then
      v[6] = removeDuplicates(v[6])
    else
      v[6] = {}
    end
    -- Timestamps
    if not v[5] then
      v[5] = time()
    end
    if v[5] < cutoff then
      self.db.global.spells[k] = nil
    end
  end
end

-- Validate an individual frame's saved vars
sbf.ValidateFrameVars = function(self, i, create)
	local new = false
	if not self.db.profile.frames[i] then
		if create then
      self.db.profile.frames[i] = {}
      new = true
    else
      return
    end
	end
	local v = self.db.profile.frames[i]
  
  v.layout = v.layout or {}
	if (i == 1) then
		v.layout.count = v.layout.count or 20
		v.layout.point = v.layout.point or {"TOPRIGHT", -65, -250}
    v.layout.rowCount = v.layout.rowCount or 20
    v.layout.growth = v.layout.growth or 3
    v.layout.anchor = v.layout.anchor or 1
	elseif (i == 2) then
		v.layout.count = v.layout.count or 16
		v.layout.point = v.layout.point or {"TOPRIGHT", -110, -250}
    v.layout.rowCount = v.layout.rowCount or 16
    v.layout.growth = v.layout.growth or 3
    v.layout.anchor = v.layout.anchor or 1
	else
		v.layout.count = v.layout.count or 10
		v.layout.point = v.layout.point or {"CENTER", 0, 0}
    v.layout.rowCount = v.layout.rowCount or 10
    v.layout.growth = v.layout.growth or 3
    v.layout.anchor = v.layout.anchor or 1
	end

  v.layout.rows = v.layout.rows
	v.layout.scale = nil
	v.layout.visibility = v.layout.visibility or 1
  v.layout.sort = v.layout.sort or 1
	v.layout.opacity = v.layout.opacity or 1
	v.layout.x = v.layout.x or 0
	v.layout.y = v.layout.y or 0
	v.layout.anchor = v.layout.anchor or 1
	v.layout.rowCount = v.layout.rowCount or 1
  v.layout.growth = v.layout.growth or 3
  v.layout.reverse = nil
	v.layout.bottom = nil
  
	v.expiry = v.expiry or {}
  v.expiry.flash = v.expiry.flash
	v.expiry.sctWarn = v.expiry.sctWarn
	v.expiry.sound = v.expiry.sound or "None"
	v.expiry.soundWarning = v.expiry.soundWarning
	v.expiry.minimumDuration = v.expiry.minimumDuration or 0
	v.expiry.warnAtTime = v.expiry.warnAtTime or 30
	v.expiry.textWarning = v.expiry.textWarning
  v.expiry.frame = v.expiry.frame or "ChatFrame1"
	v.expiry.sctColour = v.expiry.sctColour or {r=GREEN_FONT_COLOR.r, g=GREEN_FONT_COLOR.g, b=GREEN_FONT_COLOR.b}
  if SCT and (SCT:Get("SHOWFADE", SCT.FRAMES_TABLE) == SCT.MSG) then
    v.expiry.sctCrit = false
  end

  self:DoGeneralSavedVars(v, new, i)
  self:DoTimerSavedVars(v, new)
  self:DoCountSavedVars(v, new)
  self:DoIconSavedVars(v, new)
  self:DoNameSavedVars(v)
  self:DoBarSavedVars(v)

	v.disableRightClick = v.disableRightClick
  v.filters = v.filters or {}
  v.list = v.list or {}
  v.alwaysWarn = v.alwaysWarn or {}
  
	return v
end

sbf.DoGeneralSavedVars = function(self, v, new, frameNum)
  v.general = v.general or {}
  v.general.unit = v.general.unit or "player"
  
  -- new installation setup for frames 1 and 2
  if new then
    if frameNum == 1 then
      v.general.buffs = true
      v.general.frameName = "Buffs"
      v.general.blacklist = true
    elseif (frameNum == 2) then
      v.general.debuffs = true
      v.general.frameName = "Debuffs"
      v.general.blacklist = true
    else
      v.general.debuffs = true
      v.general.frameName = "SBF "..frameNum
      v.general.blacklist = false
    end
  else
    if frameNum == 1 then
      if not v.general.buffs and not v.general.debuffs then
        v.general.buffs = true
      end
    elseif (frameNum == 2) then
      if not v.general.buffs and not v.general.debuffs then
        v.general.debuffs = true
      end
    end
  end
  
  if (v.general.blacklist == nil) then
    v.general.blacklist = false
  end
  v.general.frameName = v.general.frameName or format(self.strings.DRAGTAB, frameNum)
end

-- Timer is a default configuration element
sbf.DoTimerSavedVars = function(self, v, new)
  if v.timer or new then
    if new then
      v.timer = {}
    end
    v.timer.fontSize = v.timer.fontSize or 10
    v.timer.regularColour = v.timer.regularColour or {r=NORMAL_FONT_COLOR.r, g=NORMAL_FONT_COLOR.g, b=NORMAL_FONT_COLOR.b}
    v.timer.expiringColour = v.timer.expiringColour or {r=NORMAL_FONT_COLOR.r, g=NORMAL_FONT_COLOR.g, b=NORMAL_FONT_COLOR.b}
    v.timer.justify = v.timer.justify or "CENTER"
    v.timer.font = v.timer.font or "Friz Quadrata TT"
    v.timer.scale = nil
    v.timer.y = v.timer.y or -15
    v.timer.x = v.timer.x or 0
    v.timer.format = v.timer.format or 2
    v.timer.frameLevel = v.timer.frameLevel or 4
  end
end

-- Count is a default configuration element
sbf.DoCountSavedVars = function(self, v, new)
  if v.count or new then
    if new then
      v.count = {}
    end
    v.count.x = v.count.x or 0
    v.count.y = v.count.y or -4
    v.count.colour = v.count.colour or {r=HIGHLIGHT_FONT_COLOR.r, g=HIGHLIGHT_FONT_COLOR.g, b=HIGHLIGHT_FONT_COLOR.b}
    v.count.justify = v.count.justify or "CENTER"
    v.count.font = v.count.font or "Friz Quadrata TT"
    v.count.fontSize = v.count.fontSize or 10
    v.count.frameLevel = v.count.frameLevel or 4
  end
end
  
-- Icon is a default configuration element
sbf.DoIconSavedVars = function(self, v, new)
  if v.icon or new then
    if new then
      v.icon = {}
    end
    v.icon.x = v.icon.x or 0
    v.icon.y = v.icon.y or 0
    v.icon.size = v.icon.size or 20
    v.icon.frameLevel = v.icon.frameLevel or 3
    v.icon.opacity = v.icon.opacity or 1
  end
end

-- Bar is not a default configuration element
sbf.DoBarSavedVars = function(self, v, new)
  if v.bar or new then
    if new then
      v.bar = {}
    end
    v.bar.width = v.bar.width or 200
    v.bar.height = v.bar.height or 20
    v.bar.x = v.bar.x or 110
    v.bar.y = v.bar.y or 0
    v.bar.barTexture = v.bar.barTexture or "Blizzard"
    v.bar.position = v.bar.position or "LEFT"
    v.bar.buffColour = v.bar.buffColour or {r = 0.0, g = 0.7, b = 1.0, a = 1.0 }
    v.bar.buffColour.a = v.bar.buffColour.a or 1.0
    v.bar.debuffColour = v.bar.debuffColour or {r = 0.7, g = 0.0, b = 0.0, a = 1.0 }
    v.bar.debuffColour.a = v.bar.debuffColour.a or 1.0
    v.bar.bgColour = v.bar.bgColour or {r = 0.0, g = 0.0 , b=0.0, a = 0.3}
    v.bar.bgColour.a = v.bar.bgColour.a or 0.0
    v.bar.barBGTexture = v.bar.barBGTexture or "Blizzard Tooltip"
    v.bar.barBGList = nil -- v.bar.barBGList or "background"
    v.bar.direction = v.bar.direction or 1
    if not v.bar.bgColour.a then
      v.bar.bgColour.a = 1
    end
    v.bar.frameLevel = v.bar.frameLevel or 3
    v.bar.overrideColours = v.bar.overrideColours or {}
  end
end
  
-- Name is not a default configuration element
sbf.DoNameSavedVars = function(self, v, new)
  if v.name or new then
    if new then
      v.name = {}
    end
    v.name.x = v.name.x or 20
    v.name.y = v.name.y or 0
    v.name.justify = v.name.justify or "CENTER"
    v.name.font = v.name.font or "Friz Quadrata TT"
    v.name.fontSize = v.name.fontSize or 12
    if v.name.colour then
      v.name.buffColour = v.name.colour
    end
    v.name.buffColour= v.name.buffColour or {r=NORMAL_FONT_COLOR.r, g=NORMAL_FONT_COLOR.g, b=NORMAL_FONT_COLOR.b, a = 1.0}
    v.name.buffColour.a = v.name.buffColour.a or 1.0
    v.name.debuffColour= v.name.debuffColour or {r=NORMAL_FONT_COLOR.r, g=NORMAL_FONT_COLOR.g, b=NORMAL_FONT_COLOR.b, a = 1.0}
    v.name.nameFormat = v.name.nameFormat or "Name[full] Rank[roman]"
    v.name.frameLevel = v.name.frameLevel or 4
  end
end

sbf.SetProfile = function(self, profile)
  if profile then
    for k,v in pairs(self.db:GetProfiles()) do
      if (v == profile) then
        self.db:SetProfile(profile)
        return
      end
    end
    self:Print(format("Profile \"%s\" not found", profile))
  else
    self:Print(self.db:GetCurrentProfile())
  end
end
local i = 0
sbf.ProfileChanged = function(self, redoBF)
  self:ClearBuffFrames()
  self:PutTable(self.buffs)
  self.buffs = self:GetTable()
  self:PutTable(self.debuffs)
  self.debuffs = self:GetTable()
  self:DoSavedVars()
  if self.bfModule and self.bfModule:HasGroups() then
    for index,frame in pairs(self.frames) do
      self.bfModule:UndoGroup(frame._var.general.frameName, true)
    end
    ButtonFacade.options.args.addons.args["SBF"] = nil
    collectgarbage()
  end
  self:CreateFrames()
  self:SetupFrames()
  if self.bfModule and self.bfModule:HasGroups() then
    ButtonFacade:ElementListUpdate("SBF")
  end
  self:TokenizeFilters()
  self:RegisterUnits()
  self:UnitVehicle(nil, "player")
  self:SetupExtents()

  if self.showingOptions then
    SBFOptions:SetupFrames()
    SBFOptions:SelectFrame(1)
    SBFOptions:SetupProfiles()
  end
end

sbf.minorUpdate = function(self)
  if not self.db.global.minor or self.db.global.minor < 25 then
    self.db.global.spells = {}
    self.db.global.message = true
  end
  self.db.global.minor = self.minor
end

sbf.message = {
  "Your spells list has been cleared, and you'll have to go play for a bit to repopulate it",
  "Check out the change log on WoWInterface, Curse, or the SBF site for what's new in 3.1.25",
  "Thanks for using SBF!",
}



