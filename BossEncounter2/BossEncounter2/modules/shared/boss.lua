local Root = BossEncounter2;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local defaultTimeOut = {
    ["worldboss"] = 60.000,
    ["elite"] = 30.000,
    ["rareelite"] = 30.000,
    ["rare"] = 30.000,
    ["normal"] = 15.000,
    ["default"] = 15.000,
};

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- ======================================================================
    -- Set the passed UID as the boss unit and updates data table accordingly
    -- ======================================================================

    SetBossUnit = function(self, uid, customTimeOut, notSelectable)
        uid = uid or "none";

        local data = self.data;

        data.name = UnitName(uid);
        data.guid = UnitGUID(uid);
        data.classification = UnitClassification(uid);
        data.timeOut = customTimeOut or defaultTimeOut[data.classification] or defaultTimeOut["default"];
        data.timeOutTimer = 0;
        data.bossDead = false;
        data.bossMaxHealth = UnitHealthMax(uid);
        data.bossSelectable = ( not notSelectable );

        local mobID = Root.Unit.GetMobID(data.guid);
        if ( mobID ) then
            data.baseID = tostring(mobID);
        end

        local inCombat = UnitAffectingCombat(uid);
        if ( data.safeEngage ) then
            if ( self:IsUnitAffiliated(uid.."target") ) then
                data.bossAlreadyFighting = inCombat;
         else
                return false;
            end
      else
            data.bossAlreadyFighting = inCombat;
        end
    end,

    -- ======================================================================
    -- Set the boss as a dummy unit, useful when there is no main boss or
    -- when you want to use exclusively the add window widget.
    -- Note that if you use a dummy boss, then it will be flagged as dead
    -- from the start.
    -- ======================================================================

    SetDummyBossUnit = function(self, classification, timeOut, alreadyFighting)
        local data = self.data;

        data.name = nil;
        data.guid = "";
        data.classification = classification;
        data.timeOut = timeOut or defaultTimeOut[classification] or defaultTimeOut["default"];
        data.timeOutTimer = 0;
        data.bossDead = true;
        data.bossMaxHealth = nil;
        data.bossAlreadyFighting = alreadyFighting;
        data.bossSelectable = false;

        data.ignoreLeaveCombat = true;
    end,

    -- ===========================================================================
    -- Handle the main boss unit, increasing timeOutTimer if it can't be accessed.
    -- The timeOutTimer will not increase if there is no boss.
    -- ===========================================================================

    HandleBoss = function(self, elapsed)
        local data = self.data;
        if ( not data.guid ) then return; end

        -- Check the main boss status
        local uid = Root.Unit.GetUID(data.guid);
        if ( uid ) then
            data.timeOutTimer = 0;

            if ( self:EvaluateEngage(uid) ) then
                self:OnEngaged();
            end
            if ( not UnitAffectingCombat(uid) and self.status == "ENGAGED" ) and ( not UnitIsDeadOrGhost(uid) ) and ( not data.ignoreLeaveCombat ) then
                data.outOfCombatTimer = (data.outOfCombatTimer or 0) + elapsed;
                self:CheckLeaveCombat();
          else
                data.outOfCombatTimer = 0;
            end

            if ( self.status == "ENGAGED" ) then
                local healthFraction = UnitHealth(uid) / UnitHealthMax(uid);

                -- Check if we trigger some special theme
                self:CheckNearVictory(healthFraction);

                -- Check if we breached through one of the defined health thresholds.
                self:HandleHealthThresholds(healthFraction);
            end
      else
            data.timeOutTimer = data.timeOutTimer + elapsed;
        end
    end,

    -- ===================================
    -- Reset the list of health thresholds
    -- that will trigger a callback.
    -- ===================================

    ResetHealthThresholds = function(self)
        local data = self.data;
        if ( not data ) then return; end
        if ( not data.healthThresholds ) then
            data.healthThresholds = { };
      else
            wipe(data.healthThresholds);
        end
        self.BossBar:GetDriver():ClearThresholds(true);
    end,

    -- =================================================================================
    -- Add a new callback to be fired when the boss gets below a given health threshold.
    -- A non-nil label will be displayed on the boss health bar.
    -- =================================================================================

    RegisterHealthThreshold = function(self, threshold, label, callback, ...)
        local data = self.data;
        if ( not data ) or ( not threshold ) then return; end
        if ( not data.healthThresholds ) then return; end

        local newEntry = {
            threshold = threshold,
            callback = callback,
            label = label,
            args = {...},
        };
        tinsert(data.healthThresholds, newEntry);

        if ( label ) then
            -- This threshold should be visible in the UI.
            self.BossBar:GetDriver():AddThreshold(threshold, label);
        end
    end,

    -- =================================================================================
    -- Add a new callback to be fired when the boss gets below a given health threshold.
    -- A non-nil label will be displayed on the boss health bar.
    -- =================================================================================

    TriggerHealthThreshold = function(self, index)
        local data = self.data;
        if ( not data ) then return; end
        if ( not data.healthThresholds ) then return; end

        local info = data.healthThresholds[index];
        if ( not info ) then return; end

        if ( info.callback ) then
            info.callback(unpack(info.args));
        end
        if ( info.label ) then
            self.BossBar:GetDriver():RemoveThreshold(info.label, false);
        end

        tremove(data.healthThresholds, index);
    end,

    -- ==================================================
    -- Evaluate each of the registered health thresholds.
    -- ==================================================

    HandleHealthThresholds = function(self, healthFraction)
        local data = self.data;
        if ( not data ) then return; end
        if ( not data.healthThresholds ) then return; end

        local i, info;
        for i=#data.healthThresholds, 1, -1 do
            info = data.healthThresholds[i];
            if ( healthFraction <= info.threshold ) then
                self:TriggerHealthThreshold(i);
            end
        end
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");