local Root = BossEncounter2;

local SettingPriority = Root.GetOrNewModule("SettingPriority");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- A functionnal module that determinates who has priority on a
-- given oneEnabledOnly setting.

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local settingRankScore = {
    ["NORMAL"] = 0,
    ["ASSIST"] = 10,
    ["LEADER"] = 50,
    ["ADMIN"] = 99,
};

SettingPriority.list = { };

SettingPriority.module = nil;
SettingPriority.nextModuleCheck = GetTime() + 5;

SettingPriority.lastBroadcast = -999;
SettingPriority.nextBroadcast = nil;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * SettingPriority:CheckModule()                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Check if the current active module has changed.                  *
-- ********************************************************************

SettingPriority.CheckModule = function(self)
    local module = Root.Encounter.GetActiveModule();
    if ( self.module ~= module ) then
        self.module = module;

        wipe(self.list);

        -- Entered a new module. Immediately broadcast and query.
        if type(module) == "table" then
            self.lastBroadcast = -999;
            self:Broadcast();
            self:Query();
        end
    end

    self.nextModuleCheck = GetTime() + 3;
end

-- ********************************************************************
-- * SettingPriority:GetModuleSettings()                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get the settings table of the currently active module.           *
-- ********************************************************************

SettingPriority.GetModuleSettings = function(self)
    local module = self.module;
    if type(module) == "table" then
        return module.settings or nil;
    end
    return nil;
end

-- ********************************************************************
-- * SettingPriority:IsValidSetting(setting)                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> setting: the ID of the setting checked.                       *
-- ********************************************************************
-- * Determinate if a given setting from the current module is        *
-- * handled by SettingPriority system. It must be a one-enabled-only *
-- * setting. Also return the setting's lock condition.               *
-- ********************************************************************

SettingPriority.IsValidSetting = function(self, setting)
    local settings = SettingPriority:GetModuleSettings();
    if type(settings) == "table" then
        local i;
        for i=1, #settings do
            if ( settings[i].id == setting ) and ( settings[i].oneEnabledOnly ) then
                return true, settings[i].lock;
            end
        end
    end
    return false, nil;
end

-- ********************************************************************
-- * SettingPriority:Query()                                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Ask the raid to send the state of their one-enabled-only         *
-- * settings. This will allow us to maintain the priority list.      *
-- ********************************************************************

SettingPriority.Query = function(self)
    if type(self:GetModuleSettings()) ~= "table" then return; end
    Root.Network.Send("SETTING-QUERY", "GROUP");
end

-- ********************************************************************
-- * SettingPriority:Broadcast()                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Tell the raid of the state of our one-enabled-only settings.     *
-- * This will allow them to maintain their priority list.            *
-- ********************************************************************

SettingPriority.Broadcast = function(self)
    local settings = self:GetModuleSettings();
    if type(settings) ~= "table" then return; end

    if (GetTime() - self.lastBroadcast) < 3.000 then
        self.nextBroadcast = self.lastBroadcast + 5.000; -- Can't do that now. Delay a bit the request.
        return;
    end

    -- Past this point, we execute the broadcasting.

    self.lastBroadcast = GetTime();

    local i, id, enabled;
    for i=1, #settings do
        id = settings[i].id;
        if ( settings[i].oneEnabledOnly ) then
            -- This setting is a "one-enabled-only" one.
            -- Broadcast it.
            if self.module:GetSetting(id, true) then enabled = 1; else enabled = 0; end
            Root.Network.Send("SETTING-NOTIFY", "GROUP", id, enabled, Root.version);
        end
    end
end

-- ********************************************************************
-- * SettingPriority:Change(name, setting, value, version)            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the player.                                 *
-- * >> setting: the ID of the setting that changed.                  *
-- * >> value: its new value.                                         *
-- * >> version: BE2 version of the player.                           *
-- ********************************************************************
-- * Acknowledge a change in a setting's value for a given player.    *
-- * Will also make sure this player is in our priority list.         *
-- ********************************************************************

SettingPriority.Change = function(self, name, setting, value, version)
    if ( not self:IsValidSetting(setting) ) then return; end
    local settings = self:GetModuleSettings();

    local i, t, found;
    found = false;
    for i=1, #self.list do
        t = self.list[i];
        if ( t.name == name ) then
            found = true;
            break;
        end
    end
    if ( not found ) then
        t = { name = name, version = version , score = 0 };
        tinsert(self.list, t);
    end
    t[setting] = value;
end

-- ********************************************************************
-- * SettingPriority:Arrange()                                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Recalculate the list order, based on the rank and the BE2        *
-- * version each member of the raid has.                             *
-- ********************************************************************

SettingPriority.Arrange = function(self)
    local i, t, auth;
    for i=1, #self.list do
        t = self.list[i];
        auth = Root.CheckRaidAuth(t.name) or "NORMAL";
        if Root.Network.IsAdmin(t.name) then auth = "ADMIN"; end
        t.score = 100 * t.version + settingRankScore[auth];
    end
    Root.Sort.ByName(self.list, false);
    Root.Sort.ByNumericField(self.list, "score", true); -- Highest score people first.
end

-- ********************************************************************
-- * SettingPriority:CheckSettingAuth(who, setting)                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> who: the name of the player examined.                         *
-- * >> setting: the ID of the setting that is checked.               *
-- ********************************************************************
-- * Check a given entity has the authorization to enable the given   *
-- * setting.                                                         *
-- ********************************************************************

SettingPriority.CheckSettingAuth = function(self, who, setting)
    local valid, lock = self:IsValidSetting(setting);
    if ( not valid ) then return false; end
    if ( not UnitIsConnected(who) ) then return false; end
    if ( not lock ) then return true; end

    local authLevel = Root.CheckRaidAuth(who);
    if ( lock == "SUPERADMIN" ) then
         if ( authLevel == "LEADER" ) then return true; end
elseif ( lock == "ADMIN" ) or ( lock == "SYMBOL" ) then
         if ( authLevel == "ASSIST" or authLevel == "LEADER" ) then return true; end
elseif ( lock == "WARNING" ) then
         if ( authLevel == "ASSIST" or authLevel == "LEADER" ) then return true; end
         if ( GetNumRaidMembers() == 0 and GetNumPartyMembers() > 0 ) then return true; end
    end
    return false;
end

-- ********************************************************************
-- * SettingPriority:HasPriority(who, setting)                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> who: the name of the player examined.                         *
-- * >> setting: the ID of the setting that is checked.               *
-- ********************************************************************
-- * The final-user function: determinate if a given player (usually  *
-- * yourself) has priority for a given one-enabled-only setting.     *
-- ********************************************************************

SettingPriority.HasPriority = function(self, who, setting)
    if ( not self:IsValidSetting(setting) ) then
        return true; -- Not a valid setting, so it means it's a not only-one-enabled setting, so we consider we have priority.
    end

    -- This setting is a one-enabled-only setting.
    self:Arrange();
    local i, t;
    for i=1, #self.list do
        t = self.list[i];
        if ( t.name == who ) then
            break; -- No longer browse the list, people below are of lower priority.
      else
            if ( t[setting] ) and ( self:CheckSettingAuth(t.name, setting) ) then
                return false; -- This guy has higher priority and has enabled the setting and has permission.
            end
        end
    end
    return true;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

SettingPriority.OnStart = function(self)
    -- Register net commands.
    Root.Network.Define("SETTING-QUERY", "S", "NORMAL", false);
    Root.Network.Define("SETTING-NOTIFY", "s", "NORMAL", true);
end

SettingPriority.OnNetCommand = function(self, command, sender, ...)
    if ( command == "SETTING-NOTIFY" ) then
        local setting, value, version = ...;
        if ( value == "1" ) then value = true; else value = false; end
        self:Change(sender, setting, value, version);
    end
    if ( command == "SETTING-QUERY" ) then
        self:Broadcast();
    end
end

SettingPriority.OnUpdate = function(self)
    if ( GetTime() > self.nextModuleCheck ) then
        self:CheckModule();
    end
    if ( self.nextBroadcast ) and ( GetTime() > self.nextBroadcast ) then
        self.nextBroadcast = nil;
        self:Broadcast();
    end
end

SettingPriority.Debug = function(self)
    Root.Print("SETTING PRIORITY LIST:");
    local i, t, k, v;
    for i=1, #self.list do
        t = self.list[i];
        Root.Print(string.format("%d. %s (ver %d) = %d", i, t.name, t.version, t.score));
        for k, v in pairs(t) do
            if ( k ~= "name" and k ~= "version" ) then
                Root.Print(k.."="..tostring(v or false));
            end
        end
    end
end