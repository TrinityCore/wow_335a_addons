local Root = BossEncounter2;
local GlobalOptions = Root.GetOrNewModule("GlobalOptions");

local SettingPriority = Root.GetOrNewModule("SettingPriority");

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- =========================================================
    -- This method should be called in the OnEnterWorld handler.
    -- It is very important to call this in the OnEnterWorld to
    -- make sure we have the local player's GUID information.
    -- It will make sure the module has its own setting table.
    -- =========================================================

    InitializeSettings = function(self)
        if type(self.settings) ~= "table" then return; end

        local moduleSettings = Root.Save.Get("config", self:GetName());
        if type(moduleSettings) ~= "table" then moduleSettings = { }; end

        local i, id, perCharacter, default, key;
        local newVersion = false;

        if (moduleSettings["version"] ~= self.settings["version"]) then
            newVersion = true;
        end

        if ( newVersion ) then
            wipe(moduleSettings);
            moduleSettings["version"] = self.settings["version"];
        end

        for i=1, #self.settings do
            id = self.settings[i].id;
            perCharacter = self.settings[i].isPerCharacter or false;
            default = self.settings[i].defaultValue;

            if ( perCharacter ) then
                local guid = UnitGUID("player");
                key = id..":"..guid;
          else
                key = id;
            end

            if ( moduleSettings[key] == nil ) or ( newVersion ) then
                moduleSettings[key] = default;
            end
        end
        
        Root.Save.Set("config", self:GetName(), moduleSettings);
        self.settingsValue = moduleSettings;
    end,

    -- ===============================================
    -- Get the value of one of the settings parameter.
    -- ===============================================

    GetSetting = function(self, id, bypassLock)
        if type(self.settings) ~= "table" then return nil; end
        if type(self.settingsValue) ~= "table" then return nil; end

        local i, perCharacter;
        perCharacter = false;

        for i=1, #self.settings do
            if ( self.settings[i].id == id ) then
                perCharacter = self.settings[i].isPerCharacter or false;

                if ( not bypassLock ) then
                    if Root.EvaluateLock(self.settings[i].lock) then
                        -- Lock enabled.
                        return self.settings[i].lockValue;
                    end
                    if ( self.settings[i].oneEnabledOnly ) and ( not SettingPriority:HasPriority(UnitName("player"), id) ) then
                        -- We do not have priority on this setting, so we shut the fuck up.
                        return false;
                    end
                end

                break;
            end
        end

        if ( perCharacter ) then
            return self.settingsValue[id..":"..UnitGUID("player")];
        end

        return self.settingsValue[id];
    end,

    -- =====================================================================
    -- Give access to the module's internal settings through a status frame.
    -- This method will still be called if there's no setting, to block the
    -- clicks on the status frame.
    -- =====================================================================

    PrepareSettingsEdit = function(self, statusFrame)
        if type(self.settings) == "table" and #self.settings > 0 then
            -- There are settings.
            statusFrame:GetDriver():SetSettingAccess(self);
            -- self.settingAccessTime = GetTime();
      else
            -- No setting.
            statusFrame:GetDriver():SetSettingAccess(nil);
            -- self.settingAccessTime = nil;
        end

    end,

    -- =====================================================================
    -- Determinate if the module allows access to its settings.
    -- To provide your own condition, override this function.
    -- =====================================================================

    MayEditSettings = function(self)
        -- if ( not self.settingAccessTime ) or ( (GetTime() - self.settingAccessTime) < 5 ) then 
        --     return false;
        -- end
        return (self.status == "STANDBY");
    end,

    -- ==========================================================================
    -- Determinate if the local player has enabled the filter for the given role.
    -- Possible explicit roles: DPS_MELEE, DPS_RANGED, HEAL, TANK.
    -- Possible implicit roles: MELEE, CASTER, DPS, SHIELD, OFFENSIVE.
    -- =====================================================================

    HasRole = function(self, role)
        return GlobalOptions:HasRole(role);
    end,

    -- ==========================================================================
    -- Return ifTrue value if the local player has the specified role.
    -- Return ifFalse if not.
    -- See above for the role list.
    -- =====================================================================

    IfRole = function(self, role, ifTrue, ifFalse)
        local result = GlobalOptions:HasRole(role);
        if ( result ) then return ifTrue; else return ifFalse; end
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");