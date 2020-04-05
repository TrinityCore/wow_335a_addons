local Root = BossEncounter2;
local GlobalOptions = Root.GetOrNewModule("GlobalOptions");
local AdvancedOptions = Root.GetOrNewModule("AdvancedOptions");
local EncounterStats = Root.GetOrNewModule("EncounterStats");

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local expectedDecentDPS = {
    [1] = 10,
    [10] = 50,
    [40] = 200,
    [60] = 400,
    [70] = 900,
    [80] = 2000, 
};

local NULL_TABLE = { };

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- =================================
    -- Standard way of starting a module
    -- =================================

    OnStart = function(self) -- Called upon end of all mods initialization.
        if ( self.LOADED ) then return; end

        -- Populate with shared methods.
        Root.AddSharedToBossModule(self);

        -- Combat parsing registration, if it's needed.
        if ( self.OnCombatEvent ) then
            Root.Combat.RegisterCallback(self.OnCombatEvent, self);
        end

        self.LOADED = true;
    end,

    -- ========================================================
    -- Fired when informations about local player are available
    -- ========================================================

    OnEnterWorld = function(self)
        self:OnStart(); -- Sometimes OnEnterWorld can be called before OnStart..

        -- Prepare module settings.
        self:InitializeSettings();
    end,

    -- =====================================
    -- Standard way of triggering the module
    -- =====================================

    OnTrigger = function(self, uid, extraTable) -- Called when the boss is spotted and selectable (but not in combat yet).
        if not self:TriggerMe() then return; end

        local data = self.data;

        -- Get references of static widgets

        self:GrabStaticWidgets();

        -- Extra table specifications

        extraTable = extraTable or NULL_TABLE;

        data.timeLimit = extraTable.timeLimit or nil;
        data.music = extraTable.music or nil;
        data.ignoreCombatDelay = extraTable.ignoreCombatDelay or false;
        data.ignoreLeaveCombat = extraTable.ignoreLeaveCombat or false;
        data.ignoreWipe = extraTable.ignoreWipe or false;
        data.ignoreAdds = extraTable.ignoreAdds or false;
        data.ignoreAddsEngage = extraTable.ignoreAddsEngage or false;
        data.silentAddKills = extraTable.silentAddKills or false;
        data.ignoreResults = extraTable.ignoreResults or false;
        data.ignoreStandardClear = extraTable.ignoreStandardClear or false;
        data.scoreBenchmark = extraTable.scoreBenchmark or NULL_TABLE;
        data.clearSequence = extraTable.clearSequence or nil;
        data.clearAnimation = extraTable.clearAnimation or "NORMAL";
        data.safeEngage = extraTable.safeEngage or false;
        data.wipeLockdown = extraTable.wipeLockdown or 30;
        data.clearLockdown = extraTable.clearLockdown or 30;

        if ( extraTable.preMusic ) then Root.Music.Play(extraTable.preMusic); end
        if ( extraTable.title ) then data.title = Root.ReadLocTable(extraTable.title); else data.title = nil; end

        if ( extraTable.engageTrigger ) or ( extraTable.clearTrigger ) then
            self:ResetYellCallbacks();
            if ( extraTable.engageTrigger ) then self:RegisterYellCallback("ANY", Root.ReadLocTable(extraTable.engageTrigger), self.OnEngaged, self); end
            if ( extraTable.clearTrigger  ) then self:RegisterYellCallback("ANY", Root.ReadLocTable(extraTable.clearTrigger),  self.OnCleared, self); end
        end

        -- Advanced widgets specifications

        data.distanceChecker = extraTable.distanceChecker or nil;

        -- Set the boss

        self:SetBossUnit(uid, extraTable.timeOut);

        -- Basic GUI

        self:PrepareBasicWidgets(data.timeLimit, false);

        -- Advanced GUI

        if ( data.distanceChecker ) then
            self.UnitList:Display();
            self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, data.distanceChecker, nil);
        end


        -- Adds

        self:ResetAdds();

        if ( extraTable.adds ) then
            local i, id;
            for i, id in pairs(extraTable.adds) do
                self:RegisterAdd(id, false);
            end
        end

        -- Health thresholds

        self:ResetHealthThresholds();

        if ( extraTable.healthThresholds ) then
            local i, healthThreshold;
            for i, healthThreshold in pairs(extraTable.healthThresholds) do
                self:RegisterHealthThreshold(healthThreshold.value, Root.ReadLocTable(healthThreshold.label));
            end
        end
    end,

    -- ====================================
    -- Standard way of releasing the module
    -- ====================================

    OnFinish = function(self) -- Called when the encounter finishes, either after a success or failure.
        if ( not self.running ) then return; end

        self:RemoveBasicWidgets(true);
        self:RemoveAddsWidgets();
        self:RemoveHealAssistWidgets();

        self:KillMe();
    end,

    -- ========================
    -- Standard way of engaging
    -- ========================

    OnEngaged = function(self) -- Called when the boss is engaged (the fight starts precisely at the time this handler is invoked).
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        if ( self:GetNumAdds() > 0 ) then
            -- There are adds.
            self:UpdateAddsCount(false);
      else
            -- No add, nothing special to show.
            self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);
        end

        if ( self.data.music ) then
            Root.Music.Play(self.data.music);
        end

        if ( self.data.timeLimit ) then
            -- Start countdown
            self.StatusFrame:GetDriver():Resume();
            self:ScheduleBerserk(self.data.timeLimit, false);
      else
            self.StatusFrame:GetDriver():StartTiming();
        end

        local scoreBenchmark = self.data.scoreBenchmark;
        local playerSlots = scoreBenchmark.playerSlots or max(self:GetMaxMembers() or 1, self:CountNumValidMembers());

        if ( scoreBenchmark.greatTime and scoreBenchmark.poorTime ) then
            self:SetScoreBenchmarks(scoreBenchmark.greatTime, scoreBenchmark.poorTime, playerSlots);
      else
            local expectedDPS = Root.LinearInterpolation(expectedDecentDPS, UnitLevel("player")) * (playerSlots * 0.8);
            local expectedTime = (self.data.bossMaxHealth or 1) / expectedDPS;

            self:SetScoreBenchmarks(expectedTime * 2/3, expectedTime * 3/2, playerSlots);
        end
    end,

    -- ========================
    -- Standard way of clearing
    -- ========================

    OnCleared = function(self) -- Called when the encounter is won (usually done by killing the main boss NPC).
        if ( not self.running ) or ( self.status ~= "STANDBY" and self.status ~= "ENGAGED" ) then return; end

        self.status = "CLEARED";
        self.exitDelay = 8.000;
        self.animDelay = 0.100; -- Give a little delay so we can see if we landed the Coup De Grace. :)

        -- Validate the number of remaining alive players.
        self.data.survivingPlayers = self:CountNumValidMembers();

        -- Validate the state of raid mana pool.
        self.data.remainingMana, self.data.totalMana = self:GetRaidMana();

        -- Memorize the clear time.
        self.data.clearTime = GetTime();

        -- Register the success now all score data is available.
        EncounterStats:BossCleared(self);

        -- Try to see if it was a painfully bad attempt on a otherwise well-known boss.
        if ( EncounterStats:CurrentClearIsTerrible() ) then
            self.data.clearAnimation = "EPICFAIL";
        end

        self.StatusFrame:SetStatus("TEXT", self:Localize("Success"), false);

        self.StatusFrame:GetDriver():Pause();
        self.StatusFrame:SetBlinking(true);
        self.EventWatcher:GetDriver():ClearAllEvents();
        self.TimerReminder:GetDriver():Clear();
        self.UnitList:GetDriver():Clear();
        self.SpecialBar:GetDriver():Clear();
        self.AddWindow:GetDriver():Clear();

        self:RemoveHealAssistWidgets();

        -- Block retriggering of this boss module for X sec (default 30).
        Root.Encounter.PutSpecificCooldown(self, self.data.clearLockdown or 30);
    end,

    -- =======================
    -- Standard way of failing
    -- =======================

    OnFailed = function(self, isWipe) -- Called when the encounter is failed (wipeout, special defeat condition, time-out, main boss going out of combat etc.).
        if ( not self.running ) or ( self.status ~= "STANDBY" and self.status ~= "ENGAGED" ) then return; end

        if ( isWipe ) then
            -- Happily register the failure as a wipe.
            EncounterStats:BossFailed(self);
            self.StatusFrame:SetStatus("TEXT", self:Localize("Failure"), true);

            -- Block retriggering of this boss module for X sec (default 30).
            Root.Encounter.PutSpecificCooldown(self, self.data.wipeLockdown or 30);
      else
            self.StatusFrame:SetStatus("TEXT", self:Localize("Expiration"), true);
        end

        self.status = "FAILED";
        self.exitDelay = 5.000;

        Root.Music.Stop();

        self.StatusFrame:GetDriver():Pause();
        self.EventWatcher:GetDriver():ClearAllEvents();
        self.BossBar:Remove();
        self.TimerReminder:GetDriver():Clear();
        self.UnitList:GetDriver():Clear();
        self.SpecialBar:GetDriver():Clear();
        self.AddWindow:GetDriver():Clear();

        -- self:RemoveAddsWidgets();
        self:RemoveHealAssistWidgets();
    end,

    -- =======================
    -- Default way of updating
    -- =======================

    OnUpdate = function(self, elapsed) -- Called periodically.
        if ( not self.running ) then return; end
        local data = self.data;

        if ( self.status == "STANDBY" or self.status == "ENGAGED" ) then
            -- The unit search service
            self:SearchUnitUpdate();

            -- Check the main boss status
            self:HandleBoss(elapsed);

            -- Now the adds handling portion
            self:HandleAdds(elapsed);

            -- Now do the wipe check periodically
            self:CheckWipe(elapsed);

            -- The heal assist service
            self:HandleHealAssists(elapsed);

            -- Check time-out value
            self:CheckTimeOut();

    elseif ( self.status == "CLEARED" or self.status == "FAILED" ) then
            if ( self.animDelay and self.status == "CLEARED" ) and ( self.animDelay > 0 ) then
                self.animDelay = max(0, self.animDelay - elapsed);
                if ( self.animDelay == 0 ) then
                    local hasCoupDeGrace = (self.data.coupDeGrace == UnitGUID("player"));

                    Root.Music.Play("SILENCE");

                    if ( self.data.clearAnimation == "ALTERNATE" ) then
                        Root.Sound.Play("CLEAREDALTERNATE");
                elseif ( self.data.clearAnimation == "EPICFAIL" ) then
                        Root.Sound.Play("EPICFAIL");
                  else
                        if ( hasCoupDeGrace ) then
                            Root.Sound.Play("COUPDEGRACE");
                      else
                            Root.Sound.Play("CLEARED");
                        end
                    end
                    self.ClearedAnim:Play(self.data.clearAnimation, hasCoupDeGrace);
                end
            end

            self.exitDelay = max(0, self.exitDelay - elapsed);
            if ( self.exitDelay == 0 ) then
                if ( self.status == "FAILED" ) then
                    self:OnFinish();

            elseif ( self.status == "CLEARED" ) and ( ( not UnitAffectingCombat("player") ) or data.ignoreCombatDelay ) then
                    if ( not data.ignoreResults ) then
                        if ( not AdvancedOptions:GetSetting("MaskEndSequence") ) or ( self:ShouldShowEndSequence() ) then
                            self.ResultSeq:Play();
                        end
                    end
                    self:OnFinish();
                end
            end
        end

        if ( self.status == "ENGAGED" ) then
            -- Increment the internal fight clock.
            data.globalTimer = data.globalTimer + elapsed;

            -- Decrements the last-minute prior berserk timer.
            if data.lastMinuteTimer and data.lastMinuteTimer > 0 then
                data.lastMinuteTimer = max(0, data.lastMinuteTimer - elapsed);

                if ( data.lastMinuteTimer == 0 ) then
                    -- We are in the last minute of the berserk timer.
                    -- Trigger the Last minute tune if we do not have triggered the near victory tune.
                    self:TriggerLastMinuteTheme();
                end
            end
        end
    end,

    -- =================================
    -- Default way of handling mob yells
    -- =================================

    OnMobYell = function(self, message, source, channel, target)
        if ( not self.running ) then return; end

        self:HandleYells(message, source, target);
    end,

    -- ==========================================
    -- Default way of handling connect/disconnect
    -- ==========================================

    OnConnectChange = function(self, guid, name, state)
        if ( not self.running ) then return; end

        if ( name ) and ( not state ) then -- The guy has (been) disconnected.
            --[[
            local warnDisconnect = GlobalOptions:GetSetting("ShowDisconnectAlerts");

            if ( warnDisconnect ) and ( Root.CheckAuth("WARNING") ) then
                self:AnnounceToRaid(self:FormatLoc("DisconnectWarning", name));
            end
            ]]
        end
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");
