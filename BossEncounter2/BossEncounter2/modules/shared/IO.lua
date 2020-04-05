local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- ===========================================================================
    -- Get the module's name. The name is the key of the module in the root table.
    -- ===========================================================================

    GetName = function(self)
        return self.MODNAME or "UNKNOWN";
    end,

    -- =================================================================================
    -- Get the module boss ID. An ID is unique for each encounter, for each difficulty
    -- mode and for each raid size. The ID is used by the score subsystem to store
    -- and retrieve data. The ID is only available for query when the module is running.
    -- =================================================================================

    GetID = function(self)
        local data = self.data;
        if ( not data ) then return "?"; end

        local baseID = data.baseID or data.title or data.name or "?";
        local suffix = "";
        local displaySuffix = "";

        if ( self.isWrathRaid ) then -- "Is wrath raid" is a flag on the boss module itself.
            if ( data.raidSize == 25 ) then
                suffix = suffix.."|25";
                displaySuffix = "25";
          else
                suffix = suffix.."|10";
                displaySuffix = "10";
            end
        end
        if ( data.raidMode == "HEROIC" ) then
            suffix = suffix.."|H";
            if ( displaySuffix == "" ) then
                displaySuffix = Root.Localise("Heroic");
          else
                displaySuffix = displaySuffix..", "..Root.Localise("Heroic");
            end
        end
        if ( displaySuffix ~= "" ) then
            displaySuffix = " ("..displaySuffix..")";
        end

        return baseID..suffix, displaySuffix;
    end,

    -- ========================================================================
    -- The first method that has to be called when OnTrigger method is invoked.
    -- If it returns false, the trigger process has to be aborted.
    -- ========================================================================

    TriggerMe = function(self)
        if ( self.running ) then return false; end -- Can't trigger an already running module.

        self.data = Root.Encounter.Open(self);
        if type(self.data) ~= "table" then return false; end

        self.running = true;
        self.status = "STANDBY";
        return true;
    end,

    -- ================================================================
    -- The last method that has to be called when you release a module,
    -- particularly to free up the data table.
    -- ================================================================

    KillMe = function(self)
        if not ( self.running ) then return; end

        Root.Encounter.Release(self.data);
        self.data = nil;
        self.running = false;
        self.status = nil;


        -- The following line will reduce useless overhead but can be risky if things continue to reference the module through the global table after the module has finished.

        -- To avoid errors, make sure every widget is completely cleared in the OnFinish handler.


        if ( not self.avoidRepository ) then

            Root.PushModuleToRepository(self:GetName());

        end
    end,

    -- ===================================================================
    -- Basic check to see if boss and adds are dead to clear the encounter
    -- ===================================================================

    CheckStandardClear = function(self)
        local data = self.data;
        if ( data.ignoreStandardClear ) then return; end
        if ( data.bossDead ) then
            if ( data.ignoreAdds ) or ( self:GetNumAddsAlive() == 0 ) then
                self:OnCleared();
            end
        end
    end,

    -- =====================================
    -- Check for wipes at a reasonnable rate
    -- =====================================

    CheckWipe = function(self, elapsed)
        if not ( self.status == "STANDBY" or self.status == "ENGAGED" ) then return; end

        local data = self.data;
        if ( data.test ) then return; end
        if ( data.ignoreWipe ) then return; end

        if ( not (data.checkWipe or false) ) then
            if ( UnitAffectingCombat("player") ) or ( UnitIsDeadOrGhost("player") ) then
                data.checkWipe = true;
                data.nextWipeCheck = 5.000; -- First wipe check after 5 sec to make sure combat mode is triggered for everyone.
          else
                return; -- Only start checking for wipes after the local player has entered combat mode or is dead.
            end
        end

        data.nextWipeCheck = data.nextWipeCheck - elapsed;
        if ( data.nextWipeCheck <= 0 ) then
            data.nextWipeCheck = 3.000;
            local onlyInCombat = (self.status == "ENGAGED" and (self.data.guid or self:GetNumAddsAlive() > 0)); -- Only count in-combat members if the boss is engaged and it exists.
            if ( self:CountNumValidMembers(onlyInCombat) == 0 ) then
                self:OnFailed(true);
            end
        end
    end,

    -- =============================
    -- Check for boss module timeout
    -- =============================

    CheckTimeOut = function(self)
        if not ( self.status == "STANDBY" or self.status == "ENGAGED" ) then return; end

        local data = self.data;
        if ( data.test ) then return; end
        if ( (data.timeOutTimer or 0) >= (data.timeOut or 1) ) then
            self:OnFailed(false);
        end
    end,

    -- ====================================
    -- Check for boss getting out of combat
    -- ====================================

    CheckLeaveCombat = function(self)
        if not ( self.status == "STANDBY" or self.status == "ENGAGED" ) then return; end

        local data = self.data;
        if ( data.test ) then return; end
        if ( (data.outOfCombatTimer or 0) >= 1.000 ) then
            self:OnFailed(true);
        end
    end,

    -- =======================================================================
    -- Test a boss module. This disables wipe, leave combat and timeout checks
    -- =======================================================================

    Test = function(self, enemy, extraTable) -- For development / debugging purposes.
        if ( not self.running ) then
            Root.Encounter.ForceCooldownOff();
            Root.Encounter.PutSpecificCooldown(self, -1);
            self:OnTrigger(enemy or "target", extraTable);
        end
        if ( not self.running ) then return; end
        self.data.test = true;
        self:OnEngaged();
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");
