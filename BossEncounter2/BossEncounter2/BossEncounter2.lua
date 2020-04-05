-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                           INSTALLER                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- /!\ This file has to be loaded first.

BossEncounter2 = { };

local Root = BossEncounter2;

-- Global stuff
Root.folder = "Interface\\AddOns\\BossEncounter2\\";
Root.version = 42;
Root.beta = false;
Root.debug = false;
Root.enabled = false;

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- Minimum time before the user may close the First time run popup.
local WELCOME_READ_TIMER = 30;

local criticalHandlers = {
    -- Flag here the handlers that have to be sent to modules,
    -- even if they are waiting in the repository.

    ["OnStart"] = true,
    ["OnEnterWorld"] = true,
};

-- --------------------------------------------------------------------
-- **                            Functions                           **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> GetOrNewModule(moduleName)                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> moduleName: the name of the module.                           *
-- ********************************************************************
-- * Gets an existing module's table object or create it if it does   *
-- * not exist. Whatever this function does, it'll return the table.  *
-- ********************************************************************
function Root.GetOrNewModule(moduleName)
    if type(moduleName) ~= "string" then return; end
    if type(Root[moduleName]) == "table" then return Root[moduleName]; end
    Root[moduleName] = { };
    return Root[moduleName];
end

-- ********************************************************************
-- * Root -> InvokeHandler(handlerName, ...)                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> handlerName: the name of the handler to call.                 *
-- * >> ...: arguments to pass to the handler.                        *
-- ********************************************************************
-- * Invoke a given handler on all registered modules.                *
-- ********************************************************************
function Root.InvokeHandler(handlerName, ...)
    if type(handlerName) ~= "string" then return; end
    local k, v, h;
    for k, v in pairs(Root) do
        if type(v) == "table" then
            h = v[handlerName];
            if type(h) == "function" then
                h(v, ...);
            end
        end
    end
    if ( criticalHandlers[handlerName] ) then
        Root.InvokeRepositoryHandler(handlerName, ...);
    end
end

-- ********************************************************************
-- * Root -> SetEnabled(state)                                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> state: whether BE2 is enabled or not.                         *
-- ********************************************************************
-- * Set the "enabled" state of BE2. If it is not set, BE2 will not   *
-- * trigger boss modules.                                            *
-- ********************************************************************
function Root.SetEnabled(state)
    if ( state ) and ( not Root.enabled ) then
        Root.enabled = true;
        Root.Print(Root.Localise("Console-BE2Enabled"), true);

  elseif ( not state ) and ( Root.enabled ) then
        Root.enabled = false;
        Root.Print(Root.Localise("Console-BE2Disabled"), true);
    end
end

-- --------------------------------------------------------------------
-- **                            Handlers                            **
-- --------------------------------------------------------------------

function Root.OnLoad(self)
    self:RegisterEvent("VARIABLES_LOADED");
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("PLAYER_REGEN_DISABLED");
    self:RegisterEvent("PLAYER_REGEN_ENABLED");
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    self:RegisterEvent("CHAT_MSG_MONSTER_YELL");
    self:RegisterEvent("CHAT_MSG_MONSTER_WHISPER");
    self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE");
    self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE");
    self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER");

    self:RegisterEvent("PLAYER_TARGET_CHANGED");
    self:RegisterEvent("PLAYER_FOCUS_CHANGED");
    self:RegisterEvent("UNIT_TARGET");
    self:RegisterEvent("PARTY_MEMBERS_CHANGED");
    self:RegisterEvent("RAID_ROSTER_UPDATE");
    self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT");
    self:RegisterEvent("UNIT_ENTERED_VEHICLE");

    self:RegisterEvent("SPELLS_CHANGED");

    self:RegisterEvent("CHAT_MSG_ADDON");
    self:RegisterEvent("CHAT_MSG_WHISPER");

    self:RegisterEvent("LOOT_OPENED");
    self:RegisterEvent("LOOT_SLOT_CLEARED");
    self:RegisterEvent("LOOT_CLOSED");
    self:RegisterEvent("OPEN_MASTER_LOOT_LIST");
    self:RegisterEvent("UPDATE_MASTER_LOOT_LIST");

    self:RegisterEvent("ZONE_CHANGED");
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
    self:RegisterEvent("ZONE_CHANGED_INDOORS");

    self:RegisterEvent("IGNORELIST_UPDATE");
end

function Root.OnEvent(self, event, ...)
    if ( event == "VARIABLES_LOADED" ) then
        Root.OnStart();
        Root.InvokeHandler("OnStart");
        return;
    end
    if ( event == "PLAYER_ENTERING_WORLD" ) then
        Root.InvokeHandler("OnEnterWorld");
        return;
    end
    if ( event == "PLAYER_REGEN_DISABLED" ) then
        Root.InvokeHandler("OnEnterCombat");
        return;
    end
    if ( event == "PLAYER_REGEN_ENABLED" ) then
        Root.InvokeHandler("OnLeaveCombat");
        return;
    end
    if ( event == "COMBAT_LOG_EVENT_UNFILTERED" ) then
        Root.InvokeHandler("OnCombatEvent", ...);
        return;
    end
    if ( event == "CHAT_MSG_MONSTER_YELL" or event == "CHAT_MSG_MONSTER_WHISPER" or event == "CHAT_MSG_RAID_BOSS_EMOTE" or event == "CHAT_MSG_RAID_BOSS_WHISPER" ) then
        local text, npc, _, _, target = ...;
        local channel = "YELL";
        if ( event == "CHAT_MSG_MONSTER_WHISPER" )   then channel = "WHISPER"; end
        if ( event == "CHAT_MSG_RAID_BOSS_EMOTE" )   then channel = "RAID_EMOTE"; end
        if ( event == "CHAT_MSG_RAID_BOSS_WHISPER" ) then channel = "RAID_WHISPER"; end
        Root.InvokeHandler("OnMobYell", text, npc, channel, target);
        return;
    end
    if ( event == "CHAT_MSG_MONSTER_EMOTE" ) then
        local text, npc, _, _, target = ...;
        Root.InvokeHandler("OnMobYell", string.format(text, npc), npc, "EMOTE", target);
        return;
    end

    if ( event == "PLAYER_TARGET_CHANGED" ) then
        Root.Unit.RebuildList();
        Root.InvokeHandler("OnTargetChanged");
        return;
    end
    if ( event == "PLAYER_FOCUS_CHANGED" or event == "UNIT_TARGET" or event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" ) then
        Root.Unit.RebuildList();
        return;
    end
    if ( event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" ) then
        Root.Unit.RebuildList();
        return;
    end

    if ( event == "UNIT_ENTERED_VEHICLE" ) then
        Root.Unit.RebuildList();
        local unit = ...;
        if ( unit == "player" ) then
            Root.InvokeHandler("OnVehicleEntered");
        end
        return;
    end
    if ( event == "UNIT_EXITED_VEHICLE" ) then
        Root.Unit.RebuildList();
        local unit = ...;
        if ( unit == "player" ) then
            Root.InvokeHandler("OnVehicleExited");
        end
        return;
    end

    if ( event == "SPELLS_CHANGED" ) then
        Root.SetupDistanceScanner();
        return;
    end

    if ( event == "CHAT_MSG_ADDON" ) then
        Root.InvokeHandler("OnAddonMessage", ...);
        return;
    end
    if ( event == "CHAT_MSG_WHISPER" ) then
        Root.InvokeHandler("OnWhisper", ...);
        return;
    end

    if ( event == "LOOT_OPENED" or event == "LOOT_SLOT_CLEARED" or event == "LOOT_CLOSED" ) then
        Root.InvokeHandler("OnLootChange", event, ...);
        return;
    end
    if ( event == "OPEN_MASTER_LOOT_LIST" ) then
        Root.InvokeHandler("OnLootAssignBegin", ...);
        return;
    end
    if ( event == "UPDATE_MASTER_LOOT_LIST" ) then
        Root.InvokeHandler("OnLootAssignUpdate", ...);
        return;
    end

    if ( string.sub(event, 1, 12) == "ZONE_CHANGED" ) then
        Root.InvokeHandler("OnZoneChanged", ...);
        return;
    end

    if ( event == "IGNORELIST_UPDATE" ) then
        Root.InvokeHandler("OnIgnoreChanged");
        return;
    end
end

function Root.OnUpdate(self, elapsed)
    Root.InvokeHandler("OnUpdate", elapsed);
end

function Root.OnStart()
    if ( Root.Save.CheckVersion() == 1 ) then
        Root.Print(Root.Localise("Console-SaveReset"));
    end
    Root.Save.UpdateProfile();

    local hasRead, key;
    if ( Root.beta ) then
        -- Beta welcome
        key = "readBetaMsgVer"..Root.version;
        hasRead = Root.Save.Get("config", key) or false;
        if ( not hasRead ) then
            Root.Save.Set("config", key, true);

            StaticPopupDialogs["BE2_BETA_POPUP"] = {
	        text = Root.Localise("Console-Beta"),
	        button1 = OKAY,
                timeout = 0,
                whileDead = 1,
            };

            StaticPopup_Show("BE2_BETA_POPUP");
        end
  else
        -- Release welcome
        key = "readReleaseMsgVer"..Root.version;
        hasRead = Root.Save.Get("config", key) or false;
        if ( not hasRead ) then
            Root.Save.Set("config", key, true);

            StaticPopupDialogs["BE2_RELEASE_POPUP"] = {
	        text = Root.FormatLoc("Console-Release", Root.version),
	        button1 = OKAY,
                timeout = 0,
                whileDead = 1,

                OnShow = function(self)
                    getglobal(self:GetName().."Button1"):Disable();
                    self.closeTimer = WELCOME_READ_TIMER;
                end,
                OnUpdate = function(self, elapsed)
                    if ( self.closeTimer > 0 ) then
                        self.closeTimer = max(0, self.closeTimer - elapsed);
                        if ( self.closeTimer == 0 ) then
                            getglobal(self:GetName().."Button1"):Enable();
                        end
                    end
                end,
            };

            StaticPopup_Show("BE2_RELEASE_POPUP");
        end
    end

    Root.Print(Root.FormatLoc("Console-Startup", Root.version, Root.Music.GetNumPlugins()));

    -- Prepare music plugin explain popups

    StaticPopupDialogs["BE2_MUSICPLUGIN_NOPLUGIN"] = {
	text = Root.Localise("Console-MusicPluginExplainNoPlugin"),
	button1 = OKAY,
	timeout = 0,
	whileDead = 1,
    };

    StaticPopupDialogs["BE2_MUSICPLUGIN_USAGE"] = {
	text = Root.Localise("Console-MusicPluginExplainUsage"),
	button1 = OKAY,
	timeout = 0,
	whileDead = 1,
    };

    -- Try to activate the last music plugin used. If it no longer exists, the 1st loaded plugin will be used.

    Root.Music.ActivatePlugin(Root.Save.Get("config", "lastMusicPlugin"));

    -- Check for deprecated music plugins.

    local i, deprecated;
    deprecated = false;
    for i=1, Root.Music.GetNumPlugins() do
        deprecated = deprecated or select(7, Root.Music.GetPluginInfo(i));
    end
    if ( deprecated ) then
        key = "readDeprecatedPluginVer"..Root.version;
        hasRead = Root.Save.Get("config", key) or false;
        if ( not hasRead ) then
            Root.Save.Set("config", key, true);

            StaticPopupDialogs["BE2_DEPRECATED_PLUGIN"] = {
	        text = Root.Localise("Console-MusicPluginDeprecated"),
	        button1 = OKAY,
                timeout = 0,
                whileDead = 1,
	        showAlert = 1,
            };

            StaticPopup_Show("BE2_DEPRECATED_PLUGIN");
        end
    end
end

