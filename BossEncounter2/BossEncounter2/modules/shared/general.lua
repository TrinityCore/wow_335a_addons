local Root = BossEncounter2;
local Manager = Root.GetOrNewModule("Manager");
local GlobalOptions = Root.GetOrNewModule("GlobalOptions");
local Distance = Root.GetOrNewModule("Distance");
local EncounterStats = Root.GetOrNewModule("EncounterStats");

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- =======================================
    -- Grab local references to static widgets
    -- =======================================

    GrabStaticWidgets = function(self)
        self.BossBar = Manager:GetBossBar();
        self.StatusFrame = Manager:GetStatusFrame();
        self.EventWatcher = Manager:GetEventWatcher();
        self.ClearedAnim = Manager:GetClearedAnimation();
        self.ResultSeq = Manager:GetResultSequence();
        self.TimerReminder = Manager:GetTimerReminder();
        self.SuperAlertFrame = Manager:GetSuperAlert();
        self.UnitList = Manager:GetUnitList();
        self.SpecialBar = Manager:GetSpecialBar();
        self.AddWindow = Manager:GetAddWindow();
    end,

    -- ==============================
    -- Setup and display core widgets
    -- ==============================

    PrepareBasicWidgets = function(self, timeLimit, hasEvents)
        local data = self.data;

        self.BossBar:Display();
        self.BossBar:GetDriver():SetWatch(data.guid);

        self.StatusFrame:Display();
        self.StatusFrame:SetTitle(data.title or data.name);
        self:PrintAttempt();
        self.StatusFrame:ChangeSecureCommand(nil);
        self:PrepareSettingsEdit(self.StatusFrame);
        if ( data.bossSelectable and data.name ) then self.StatusFrame:ChangeSecureCommand("/target [combat] "..data.name); end

        self.timeLimit = timeLimit;
        if ( timeLimit ) then
            self.StatusFrame:GetDriver():StartCountdown(timeLimit, nil);
            self.StatusFrame:GetDriver():Pause();
      else
            self.StatusFrame:GetDriver():Clear();
        end

        if ( hasEvents ) then
            self.EventWatcher:Display();
            self.EventWatcher:GetDriver():ClearAllEvents();
        end

        self.AddWindow:GetDriver():AssignAlgorithm(nil);

        -- Even if there is no initial event, set the correct config for the event watcher.
        local mode = "TEXTUAL";
        local useGraphical = GlobalOptions:GetSetting("UseGraphicalEventWarning") or false;
        if ( useGraphical ) then mode = "GRAPHICAL"; end
        self.EventWatcher:GetDriver():ToggleWarningMode(mode);
        self.EventWatcher:SetTimeScale(GlobalOptions:GetSetting("EventWatcherTimeScale") or 1);

        self:OpenDifficultyMeter();

        self.ClearedAnim:Stop();
        self.ResultSeq:Stop();

        if ( GlobalOptions:GetSetting("ShowHealAssist") ) then
            self:InitializeHealAssistSystem();
        end
    end,

    -- ===============================
    -- Remove easily all basic widgets
    -- ===============================

    RemoveBasicWidgets = function(self, stopDrivers)
        self.BossBar:Remove();
        self.StatusFrame:Remove();
        self.StatusFrame:ChangeSecureCommand(nil);
        self.EventWatcher:Remove();
        self.ClearedAnim:Stop();
        self.TimerReminder:Remove();
        self.SuperAlertFrame:Remove();
        self.UnitList:Remove();
        self.SpecialBar:Remove();
        self.AddWindow:Remove();
        -- self.ResultSeq:Stop();

        if ( stopDrivers ) then
            self.BossBar:GetDriver():SetWatch(nil);
            self.StatusFrame:GetDriver():Pause();
            self.EventWatcher:GetDriver():ClearAllEvents();
            self.TimerReminder:GetDriver():Clear();
            self.UnitList:GetDriver():Clear();
            self.SpecialBar:GetDriver():Clear();
            self.AddWindow:GetDriver():Clear(true);
        end
    end,

    -- =======================================================================
    -- Search for an unit with the given mobID and call the specified callback
    -- once it is found. The callback must be a module's method.
    -- The UID of the unit when it is found will be passed to the callback.
    -- Very handy for bosses that are not accessible from the start, like KT.
    -- =======================================================================

    SearchUnit = function(self, mobID, callback)
        if ( not mobID ) or ( type(callback) ~= "function" ) then
            error("SearchUnit: invalid parameters.");
        end

        self.data.searchUnitID = mobID;
        self.data.searchUnitCallback = callback;
    end,

    -- ================================================
    -- The update function for the search unit service. 
    -- Should be called in OnUpdate handler.
    -- ================================================

    SearchUnitUpdate = function(self)
        local id, callback = self.data.searchUnitID, self.data.searchUnitCallback;
        if ( not id ) then return; end

        local guid = Root.Unit.GetGUIDFromMobID(id);
        if ( guid ) then
            local uid = Root.Unit.GetUID(guid);
            if ( uid ) then
                self.data.searchUnitID = nil;
                self.data.searchUnitCallback = nil;
                callback(self, uid);
            end
        end
    end,

    -- ============================================================================
    -- Set easily a berserk event in the event watcher and/or in the timer reminder
    -- Provide finalBerserkTimer only if the berserk you are scheduling can be     
    -- delayed in the boss fight (by advancing in phases for instance).
    -- ============================================================================

    ScheduleBerserk = function(self, timer, useEvent, finalBerserkTimer)
        local useRemind = GlobalOptions:GetSetting("ShowBerserkReminder");
        if ( useEvent ) then
            local eventType = "REMINDER";
            if ( not useRemind ) then eventType = "NORMAL"; end
            self.EventWatcher:GetDriver():AddEvent("Berserk", timer, "AUTO", self:Localize("Berserk"), eventType);
      else
            if ( useRemind ) then self.TimerReminder:GetDriver():Start(timer, 20, self:Localize("HurryUp")); end
        end
        local themeDuration = Root.Music.GetLastMinuteThemeDuration(); -- Usually 60 sec. 
        self.data.lastMinuteTimer = max(0, (finalBerserkTimer or timer) - themeDuration); -- If the berserk timer is below the theme duration, there will be no Last minute theme played at all.
    end,

    -- ========================================================
    -- Change a berserk event in the middle of a boss fight.
    -- ScheduleBerserk must have been called with useEvent=true
    -- if you want to use this method.
    -- ========================================================

    ChangeBerserk = function(self, newBerserkTimer)
        local newTimer = newBerserkTimer - self.data.globalTimer;
        local berserkTimer = self.EventWatcher:GetDriver():GetEventTimer("Berserk");
        local delta;

        if ( berserkTimer ) then
            -- Event still here. Extend it directly.
            delta = newTimer - berserkTimer;
            if ( newTimer > 0 ) then
                self.EventWatcher:GetDriver():ChangeEvent("Berserk", newTimer);
          else
                self.EventWatcher:GetDriver():TriggerEvent("Berserk");
            end
      elseif ( newTimer > 0 ) then
            -- No longer there.
            delta = newTimer;
            self.EventWatcher:GetDriver():AddEvent("Berserk", newTimer, "AUTO", self:Localize("Berserk"), "REMINDER");
        end

        if ( newTimer > 0 ) then
            if ( delta >= 1 ) then
                self:NotifyMe(self:FormatLoc("BerserkTimerExtended", Root.GetTimeString(delta)), 0.500, 5.000);
        elseif ( delta <= -1 ) then
                self:NotifyMe(self:FormatLoc("BerserkTimerReduced", Root.GetTimeString(-delta)), 0.500, 5.000);
            end
        end

        newTimer = max(0, newTimer);
        self.StatusFrame:GetDriver():StartCountdown(newTimer);
        self.StatusFrame:SetBlinking(true); -- Make the berserk timer blinks for 5 sec.
        if ( newTimer > 5 ) then
            self.EventWatcher:GetDriver():AddEvent("StopBerserkBlinking", 5.000, "", "", "HIDDEN", self.StatusFrame.SetBlinking, self.StatusFrame, false);
        end
    end,

    -- ==============================================
    -- Get the GUID, name and UID of the boss target.
    -- You can specify another GUID if you want.
    -- ==============================================

    GetTargetInfo = function(self, otherGUID)
        local bossUID = Root.Unit.GetUID(otherGUID or self.data.guid);
        if ( bossUID ) then
            local targetUID, targetGUID, targetName;
            targetUID = bossUID.."target";
            targetGUID = UnitGUID(targetUID);
            targetName = UnitName(targetUID);
            return targetGUID, targetName, targetUID;
        end
        return nil, nil, nil;
    end,

    -- =====================================
    -- Determinate if the specified unit has
    -- the aggro from the boss.
    -- =====================================

    HasBossAggro = function(self, unit)
        if ( not UnitExists(unit) ) then
            unit = Root.Unit.GetUID(unit);
        end
        local bossUID = Root.Unit.GetUID(self.data.guid);
        if ( bossUID ) and ( unit ) then
            local isTanking = UnitDetailedThreatSituation(unit, bossUID);
            return isTanking;
      else
            return nil;
        end
    end,

    -- ========================
    -- Easy phase change switch
    -- ========================

    ChangePhase = function(self, phase, notify)
        self.data.phase = phase;

        if ( notify ) then
            self.StatusFrame:SetStatus("PHASE", phase, true);
            Root.Sound.Play("PHASECHANGE");

            local majorText = Manager:GetFreeMajorText();
            if ( majorText ) then
                majorText:Display(Root.Localise("Phase").." "..phase, 0.750, 3, 3.000, 0.750, 3);
            end
        end
    end,

    -- =======================================================================================
    -- Get the current filter mask to use with all aspects of a fight that requires filtering,
    -- based on the current raid/dungeon difficulty mode.
    -- =======================================================================================

    GetCurrentFilterMask = function(self)
        local mode, size = Root.GetInstanceFormat();
        if ( mode == "NORMAL" and size == 10 ) then return 0x01; end
        if ( mode == "NORMAL" and size == 25 ) then return 0x02; end
        if ( mode == "HEROIC" and size == 10 ) then return 0x04; end
        if ( mode == "HEROIC" and size == 25 ) then return 0x08; end
        return 0xFF;
    end,

    -- =================================================================
    -- Determinate if a bit table matches the current filter. See above.
    -- =================================================================

    IsMatchingFilter = function(self, value)
        local mask = self:GetCurrentFilterMask();
        if ( bit.band(value, mask) > 0 ) then return true; end
        return false;
    end,

    -- ====================================================
    -- Determinate the code of the current instance format.
    -- Can be 10N, 10H, 25N, 25H.
    -- ====================================================

    GetFormatCode = function(self)
        return select(3, Root.GetInstanceFormat());
    end,

    -- ====================================================
    -- Determinate if the given unit is affiliated with us.
    -- ====================================================

    IsUnitAffiliated = function(self, uid)
        if ( not UnitExists(uid) ) then uid = Root.Unit.GetUID(uid); end
        if ( not uid ) then return false; end

        if ( UnitIsUnit(uid, "player") or UnitInRaid(uid) or UnitInParty(uid) ) then
            return true;
        end
        return false;
    end,

    -- ====================================================
    -- Check if the boss module should be engaged according
    -- to the combat state of the given unit.
    -- ====================================================

    EvaluateEngage = function(self, uid)
        if ( not self.data ) or ( not uid ) or ( self.status ~= "STANDBY" ) then
            return false;
        end

        local data = self.data;
        if ( data.guid == UnitGUID(uid) ) then
            -- Evaluating the state of the boss.
      else
            -- Evaluating the state of an add.
            if ( data.ignoreAddsEngage ) then
                return false;
            end
        end

        if ( data.safeEngage ) then
            if ( self:IsUnitAffiliated(uid.."target") ) then
                return UnitAffectingCombat(uid);
          else
                return false;
            end
      else
            return UnitAffectingCombat(uid);
        end
    end,

    -- ====================================================
    -- Allows one to reduce the number of calls that can be
    -- done to a function over a period of time.
    -- Duration is in sec. Return true if the CD is OFF,
    -- return false if the call should be aborted.
    -- ====================================================

    EvaluateCooldown = function(self, identifier, duration)
        if ( not self.data ) or type(identifier) ~= "string" or type(duration) ~= "number" then
            return false;
        end
        identifier = "CD:"..identifier;
        local last = self.data[identifier];
        if ( not last ) or ( GetTime() > (last + duration) ) then
            self.data[identifier] = GetTime();
            return true;
      else
            return false;
        end
    end,

    -- =================================================================================================
    -- Try to determinate the distance (in yards) between two arbitrary units as accurately as possible. 
    -- This is only possible if the units are friendly or else the approximation will be rough and 
    -- must involve the player. GUIDs/names/UIDs can all be passed to this function.
    -- Nil will be returned if no result can be provided. Unit2 will default to "player".
    -- =================================================================================================

    GetDistance = function(self, unit1, unit2)
        unit2 = unit2 or "player";

        if ( not UnitExists(unit1) ) then unit1 = Root.Unit.GetUID(unit1); end
        if ( not UnitExists(unit2) ) then unit2 = Root.Unit.GetUID(unit2); end
        if ( not unit1 ) then return nil; end
        if ( not unit2 ) then return nil; end

        return Distance:Get(unit1, unit2, false);
    end,

    -- =================================================================================================
    -- Determinate if it is worthy to show the end sequence for this boss.
    -- This function should be called only after the OnCleared handler has been invoked or it will not
    -- return a correct value; the return might be based on the previous boss instead.
    -- =================================================================================================

    ShouldShowEndSequence = function(self)
        if ( self.data.clearAnimation == "EPICFAIL" ) then
            return true;
        end

        local name, attempts, attemptScore, speedScore, techniqueScore, clearTime, previousTime, previousScore, numKilled, sequence, dps = EncounterStats:GetCurrentInfo();

        local killThreshold = 3;
        if ( sequence == "NORMAL" ) then killThreshold = 1; end

        if ( numKilled >= killThreshold ) and ( previousScore ) then
            local newScore = (attemptScore or 0) + (speedScore or 0) + (techniqueScore or 0);
            if ( newScore <= previousScore ) then
                return false;
            end
        end

        return true;
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");