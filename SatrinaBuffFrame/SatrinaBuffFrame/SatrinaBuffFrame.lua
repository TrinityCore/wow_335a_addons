-- $Date: 2009-09-12 15:21:12 -0400 (Sat, 12 Sep 2009) $
SBF = LibStub("AceAddon-3.0"):NewAddon("SBF", "AceEvent-3.0", "AceConsole-3.0", "AceTimer-3.0")
SBF._beta = false
SBF.strings = {}

--
-- Thanks to Yarlir@Area52 for various tweaks and fixes!
--


local SML = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0')

local _G = _G
local sbf = SBF
local format = _G.format
local ipairs = _G.ipairs
local pairs = _G.pairs
local GetTime = _G.GetTime
local InCombatLockdown = _G.InCombatLockdown
local sfind = string.find

local debugMask = 1

sbf.revision = tonumber(("$Revision: 129 $"):match("%d+"))

-- This is a bitmask
debugBitMask = {
  [1] = "General",
  [2] = "Buffs",
  [4] = "Frames",
  [8] = "Display",
  [16] = "Tracking/Enchants/Totems",
  [32] = "Saved Variables",
  [64] = "Totems",
  [128] = "Filters",
  [256] = "Table recycling",
}
sbf.debug = 0

sbf.debugmsg = function(self, level, fmt, ...)
  if (self.debug > 0) and (bit.band(level, self.debug) == level) then
    if fmt then
      self:Print(format("[%s] %s", debugBitMask[level], format(fmt, ...)))
    else
      self:Print("debugmsg: format was nil")
    end
  end
end

local function InterfaceOptionsPanel()
 local f = CreateFrame("Frame")
 f.name = "Satrina Buff Frames"
 local button = CreateFrame("Button", nil, f, "OptionsButtonTemplate")
 button:SetPoint("CENTER")
 button:SetText("/sbf options")
 button:SetScript("OnClick", function() InterfaceOptionsFrameCancel_OnClick(); HideUIPanel(GameMenuFrame); SBF:OpenOptions(); end)
 InterfaceOptions_AddCategory(f)
end

--
-- Ace Stuff
--

sbf.OnInitialize = function(self)
  self.updateDelay = 1.0
  self.frameDelay = 0.5
  self.durationIncrement = 1.0
  self.flashCount = 0
  self.justify = {[1] = "LEFT", [2] = "CENTER", [3] = "RIGHT", ["LEFT"] = 1, ["CENTER"] = 2, ["RIGHT"] = 3}
  
  self.version = tonumber(GetAddOnMetadata("SatrinaBuffFrame", "Version"))
  self.minor = tonumber(GetAddOnMetadata("SatrinaBuffFrame", "X-MinorVersion"))

	if self._beta then
		self.versionStr = format("%.01f beta %d", self.version, self.minor)
	else
		self.versionStr = format("%.01f.%d", self.version, self.minor)
	end

  self.sbfoVersion = tonumber(GetAddOnMetadata("SBFOptions", "Version"))
  self.sbfoMinor = tonumber(GetAddOnMetadata("SBFOptions", "X-MinorVersion"))

	if self._beta then
		self.sbfoVersionStr = format("%.01f beta %d", self.version, self.minor)
	else
		self.sbfoVersionStr = format("%.01f.%d", self.version, self.minor)
	end
	
	self.sortOptions = {
		self.NoSort,
		self.AscendingTimeSort,
		self.DescendingTimeSort,
		self.AscendingNameSort,
		self.DescendingNameSort,
		self.AscendingDurationSort,
		self.DescendingDurationSort,
	}

  self:RegisterChatCommand("sbf", "ChatCommand")
  
	self.updateFrame = CreateFrame("Frame")
  self.frames = {}
  self.setup = {}
  
  self.lastUpdate = {}
  
  self.getAuras = {
    ["player"] = false
  }
	
  self.flash = false
	self.flashTime = 0
	self.flashState = 1

	self.alpha = 1
	self.alphaStep = 0.1

  self.castable = {["HELPFUL"] = {}, ["HARMFUL"] = {}}

	self.classDispel = {
		MAGE = { self.strings.CURSE },
		PRIEST = { self.strings.DISEASE, self.strings.MAGIC },
		DRUID = { self.strings.CURSE, self.strings.POISON},
		PALADIN = { self.strings.POISON, self.strings.DISEASE, self.strings.MAGIC },
		SHAMAN = { self.strings.DISEASE, self.strings.POISON },
		DEATHKNIGHT = {},
		WARRIOR = {},
		ROGUE = {},
		HUNTER = {},
		WARLOCK = {},
	}
	
	SML:Register("sound", sbf.strings.sounds[1], [[Sound\Spells\AntiHoly.wav]])
	SML:Register("sound", sbf.strings.sounds[2], [[Sound\interface\iTellMessage.wav]])
	SML:Register("sound", sbf.strings.sounds[3], [[Sound\interface\AuctionWindowOpen.wav]])
	SML:Register("sound", sbf.strings.sounds[4], [[Sound\interface\FriendJoin.wav]])
	SML:Register("sound", sbf.strings.sounds[5], [[Sound\Creature\Murloc\mMurlocAggroOld.wav]])
  
  if self.sounds then
    for index,data in pairs(self.sounds) do
      SML:Register("sound", data[1], data[2])
    end
  else
    self:Print("Could not find the user sounds file.  Does SatrinaBuffFrame\Media\SBFSounds.lua exist?")
  end

  self:AddCallout("player", self.AddEnchants, self.RemoveEnchants)
  self:AddCallout("player", self.AddTotems, self.RemoveTotems)
  self:AddCallout("player", self.AddTrackingBuff, self.RemoveTrackingBuff)
  
  -- Options Stub
  InterfaceOptionsPanel()
  hooksecurefunc("InterfaceOptionsListButton_OnClick", self.CheckOptionsClick)
end

sbf.CheckOptionsClick = function(listButton, mouseButton)
  if listButton.element and (listButton.element.name == SBF.addonName) then
    SBF:OpenOptions()
  end
end

sbf.OnDisable = function(self)
	self:Print(self.strings.DISABLE)
end

sbf.OnEnable = function(self)
  if (self.version ~= self.sbfoVersion) or (self.version == self.sbfoVersion and self.minor ~= self.sbfoMinor) then
    self:Print(format(self.strings.OPTIONSVERSION, self.sbfoVersionStr, self.versionStr))
    self.versionMismatch = true
  end
  
  self.player = UnitName("player")
	_,self.playerClass = UnitClass("player")
  self.scale = UIParent:GetEffectiveScale()

	self:SetupEnchants()
  self:RegisterEvent("PLAYER_ENTERING_WORLD", "EnterWorld")
	self.db = LibStub("AceDB-3.0"):New("SBFDB", self.defaultVars)
  self:DisableDefaultBuffFrame()

  self.bfModule = SBFBFLoad()
  self:ProfileChanged()

  sbf.update = 0
  self.updateFrame:SetScript("OnUpdate", self.OnUpdate)
  if (self.db.global.message == true) then
    self:ScheduleTimer("Message", 4)
  end
end

sbf.Message = function(self)
  self:Print(format("SBF v%.1f.%d", self.version, self.minor))
  for k,v in pairs(self.message) do
    self:Print(v)
  end
  self.db.global.message = false
end

sbf.FinishSetup = function(self)
  self:GetExtents()
	self:RegisterEvent("UNIT_AURA", "UnitAura")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "UnitVehicle")
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "UnitVehicle")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "TargetChanged")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED", "FocusChanged")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "InventoryChanged")
  self:RegisterEvent("MINIMAP_UPDATE_TRACKING", "UpdateTracking", true)
  self:RegisterEvent("PLAYER_REGEN_ENABLED", "Cleanup")
  self:RegisterEvent("PARTY_MEMBERS_CHANGED", "PartyChanged")
  self:RegisterEvent("UNIT_PET", "PetChanged")
  self:RegisterEvent("RAID_ROSTER_UPDATE", "RaidChanged")
  self:RegisterEvent("PLAYER_REGEN_DISABLED", "CombatStatus", true)
  self:RegisterEvent("PLAYER_REGEN_ENABLED", "CombatStatus", false)
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "CombatLog", false)
  
  self.db.RegisterCallback(self, "OnProfileChanged", "ProfileChanged", self)
  
  self.checkVisibility = false
  for k,v in pairs(SBF.db.profile.frames) do
    if v.layout.visibility and (v.layout.visibility > 1) then
      self.checkVisibility = true
    end
    if string.find(v.general.unit, "party") and SBF.db.global.hideParty then
      self.checkVisibility = true
    end
  end
  self.hasTotems = (self.playerClass == "SHAMAN")
  if self.hasTotems then
    self:RegisterEvent("PLAYER_TOTEM_UPDATE", "TotemUpdate")
  end
  self:UpdateTracking()
  self:ForceAll()
end


sbf.Cleanup = function(self)
  self:ForceGet(nil, "player")
end

sbf.ToggleActive = function(self)
  -- Don't allow the user to try and disable SBF
	self:Print(self.strings.DISABLE)
end

--
-- Timers
--
local combat = 0
local visibility = 0

SBF.OnUpdate = function(self, e)
  combat = combat + e
  sbf.update = sbf.update + e
  visibility = visibility + e
  
  if (sbf.getExtents == true) then 
    sbf:FinishSetup()
  else
    if sbf.flash then
      sbf:UpdateAlpha(e)
    end
    if combat >= sbf.db.global.combatUpdate then
      combat = 0
      sbf:CombatTimer()
    end
    if sbf.update >= sbf.updateDelay then
      sbf.update = 0
      sbf:Update()
    end
    if visibility >= sbf.frameDelay then
      visibility = 0
      if sbf.checkVisibility then
        sbf:FrameVisibility()
      end
      if sbf.units.mouseover then
        sbf:ForceGet(nil, "mouseover")
      end
    end

    if not sbf.showingOptions then
      sbf:FastUpdates(e)
    end
  end
end

SBF.StopTimers = function(self)
end

SBF.CombatStatus = function(self, combat)
  self.inCombat = combat
  if not combat then
    --debugmsg self:debugmsg(debugMask, "Leaving combat")
    for unit in pairs(self.units) do
      self:ForceGet(nil, unit, true)
    end
  else
    --debugmsg self:debugmsg(debugMask, "Entering combat")
  end
end

SBF.CombatTimer = function(self)
  if self.inCombat then
    for unit in pairs(self.units) do
      self:ForceGet(nil, unit, true)
    end
  end
end
--
-- Update Stuff
--
SBF.EnchantChanged = function(self)
  self.getAuras["player"] = true
  self.enchantTimer = nil
end

SBF.TargetChanged = function(self, event)
  --debugmsg self:debugmsg(debugMask, "Target changed")
  self:ForceGet(event, "target", true)
  if self.buffs["targettarget"] or self.debuffs["targettarget"] then
    self:ForceGet(event, "targettarget", true)
  end
  self.checkVisibility = true
end

SBF.UnitVehicle = function(self, event, unit)
  if (unit == "player") then
    for index,frame in pairs(self.frames) do
      if (frame._var.general.unit == "player") and UnitInVehicle("player") and frame._var.general.showVehicle then
        frame.unit = "vehicle"
      elseif (frame._var.general.unit == "player") and not UnitInVehicle("player") then
        frame.unit = "player"
      end
    end
    self:ForceGet(event, "vehicle", true)
  end
end

SBF.FocusChanged = function(self, event)
  --debugmsg self:debugmsg(debugMask, "Focus changed")
  self:ForceGet(event, "focus", true)
  if self.buffs["focustarget"] then
    self:ForceGet(event, "focustarget", true)
  end
  self.checkVisibility = true
end

SBF.PartyChanged = function(self, event)
  --debugmsg self:debugmsg(debugMask, "Party changed")
  self:ForceGet(event, "party1", true)
  self:ForceGet(event, "party2", true)
  self:ForceGet(event, "party3", true)
  self:ForceGet(event, "party4", true)
  self.checkVisibility = true
end

SBF.PetChanged = function(self, event, unit)
  --debugmsg self:debugmsg(debugMask, "Pet changed")
  if (unit == "player") then
    self:ForceGet(event, "pet")
  else
    self:ForceGet(event, unit.."pet")
  end
end

SBF.RaidChanged = function(self, event, unit)
  --debugmsg self:debugmsg(debugMask, "Raid changed")
  for _,frame in pairs(self.frames) do
    if frame.unit and sfind(frame.unit, "raid") then
      self:ForceGet(event, frame.unit)
    end
  end
  self.checkVisibility = true
end

SBF.UnitAura = function(self, event, unit)
  if not self.inCombat then
    self:ForceGet(event, unit)
  end
end

SBF.ForceAll = function(self)
  if not self.units then
    return
  end
  for unit in pairs(self.units) do
    self:ForceGet(nil, unit)
  end
end

SBF.ForceGet = function(self, event, unit)
  if self.getExtents or not self:TrackingUnit(unit) then
    return
  end
  --debugmsg self:debugmsg(debugMask, "Force get for %s", unit)
  self:UnitGUID(unit)
  self.getAuras[unit] = true
  self:Update(unit)
end

SBF.Update = function(self)
  for unit,needsUpdate in pairs(self.getAuras) do
    if (needsUpdate == true) then
      self:UpdateUnitAuras(unit)
      self.getAuras[unit] = false
    end
  end
  for index,frame in pairs(self.frames) do
    if frame.rFilter then
      -- update any frames for non updating units that have r filters
      self:DoRFilter(frame)
    end
  end
end


SBF.RefreshBuffs = function(self)
  self:ClearBuffFrames()
  self:ClearAuras()
	self.getAuras["player"] = true
end

SBF.AccelerateUpdate = function(self)
  if (self.update < 0.8) then
    self.update = 0.8
  end
end

sbf.EnterWorld = function(self, event)
  if self.hasTotems then
    self:TotemUpdate()
  end
  if UnitInVehicle("player") then
    self:UnitVehicle("UNIT_ENTERED_VEHICLE", "player")
  end
end

--
-- Slash command and options
--
sbf.ChatCommand = function(self, args)
  if args then
    local cmd, arg = string.match(args, "(.-) (.*)")
    
    if not cmd then
      cmd = strlower(args)
    else
      cmd = strlower(cmd)
    end
    
    if (cmd == "options") then
      self:OpenOptions()
    elseif (cmd == "hide") then
      self:DisableDefaultBuffFrame()
    elseif (cmd == "fix") then
      for index,frame in pairs(self.db.profile.frames) do
        if frame.general then
          self:Print(format("Trying to fix settings for frame %s", frame.general.frameName or "unknown"))
        else
          self:Print("Trying to fix settings for broken frame")
        end
        self:ValidateFrameVars(index)
      end
      self:DoSavedVars(true)
    elseif (cmd == "reset") then
      self.db:ResetProfile()
      self:DoSavedVars()
      ReloadUI()
    elseif (cmd == "throttle") then
      local v = tonumber(arg)
      if not v or (v < 0.05) or (v > 1.0) then
        self:Print(self.strings.INVALIDTHROTTLE)
      else
        self.db.global.combatUpdate = floor(v * 1000 + 0.5)/1000
        self:Print(format(self.strings.THROTTLECHANGED, v))
      end
     -- elseif (cmd == "profile") then
      -- self.db:SetProfile(arg)
    elseif (cmd == "debug") then
      local v = tonumber(arg)
      if v and (v >= 0) then
        self.debug = v
        if (v == 0) then
          SBF:Print("Debugging disabled")
        else
          for i,str in pairs(debugBitMask) do
            if (bit.band(v, i) == i) then
              SBF:Print(format("%s debugging enabled", str))
            end
          end
        end
      end
    elseif (cmd == "stats") then
      self:ElementStats()
      self:TableStats()
    else
      DEFAULT_CHAT_FRAME:AddMessage(format(self.strings.SLASHHEADER, self.versionStr))
      for k,v in pairs(self.strings.SLASHOPTIONS) do
        DEFAULT_CHAT_FRAME:AddMessage(v)
      end
      DEFAULT_CHAT_FRAME:AddMessage(format(self.strings.SLASHTHROTTLE, self.db.global.combatUpdate))
    end
  end
end

sbf.OpenOptions = function(self)
  if self.optionsMismatch then
    self:Print(format(self.strings.OPTIONSVERSION, self.sbfoVersionStr, self.versionStr))
    return
  end
	if not IsAddOnLoaded("SBFOptions") then
    local loaded, message = LoadAddOn("SBFOptions")
    if not loaded then
      if (message == "DISABLED") then
        self:Print(self.strings.DISABLEDSBFO)
        return
      end
    end
  end
  self:ClearBuffFrames()
  self:ClearAuras()
  SBFOptions:ShowOptions()
end

sbf.CloseOptions = function(self)
  self.scale = UIParent:GetEffectiveScale()
  self:TokenizeFilters()
  self:ClearBuffFrames()
  self:SetupFrames()
	self.showingOptions = nil
  
  collectgarbage()
  self:RegisterUnits()
  self:UnitVehicle(nil, "player")
  self:SetupExtents()
end