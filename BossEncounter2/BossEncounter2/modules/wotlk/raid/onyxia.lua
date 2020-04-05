local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Onyxia (remake) Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Onyxia (remake) fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["Phase2Trigger"] = "from above",
        ["Phase3Trigger"] = "It seems you'll need another lesson",
        ["BreathTrigger"] = "Onyxia takes in a deep breath",

        -- 2. Events
        ["TakeOff"] = "Onyxia takes off",
        ["Landing"] = "Onyxia lands",

        -- 3. Misc
        ["DeepBreath"] = "Deep Breath incoming !",
        ["NovaWarning"] = "Casting nova !",
    },
    ["frFR"] = {
        -- 1. Yells
        ["Phase2Trigger"] = "Cet exercice dénué de sens m'ennuie.",
        ["Phase3Trigger"] = "Il semble que vous ayez besoin d'une autre leçon",
        ["BreathTrigger"] = "inspiration",

        -- 2. Events
        ["TakeOff"] = "Onyxia décolle",
        ["Landing"] = "Onyxia attérit",

        -- 3. Misc
        ["DeepBreath"] = "Souffle imminent !",
        ["NovaWarning"] = "Nova en incantation !",
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Onyxia";

local ONYXIA_ID = 10184;
local GUARD_ID = 36561;

local blastNova = {
    [68958] = true,
};

-- --------------------------------------------------------------------
-- **                       Definition stuff                         **
-- --------------------------------------------------------------------

Root[THIS_MODULE] = {
    -- --------------------------------------------------------------------
    -- **                            Properties                          **
    -- --------------------------------------------------------------------

    isWrathRaid = true,

    -- --------------------------------------------------------------------
    -- **                             Handlers                           **
    -- --------------------------------------------------------------------

    OnStart = Shared.OnStart,

    OnTrigger = function(self, uid, extraTable)
        if not self:TriggerMe() then return; end

        local data = self.data;

        data.ignoreAdds = true;
        data.silentAddKills = true;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.35, 0.40, 0.35, 0.20, 0.30); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);
        self.EventWatcher:Remove(true); -- Not needed yet.

        Root.Music.Play("PREPARATION_DUNGEON");

        self:ResetAdds();
        self:RegisterAddEX(GUARD_ID, false, "DB");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(240, 480);

        self:ChangePhase(1, true);

        Root.Music.Play("THEME_ULTIMATE");

        self.StatusFrame:GetDriver():StartTiming();

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("Phase2Trigger"), self.OnPhaseTwo, self);
        self:RegisterYellCallback(nil, self:Localize("Phase3Trigger"), self.OnPhaseThree, self);
        self:RegisterYellCallback(nil, self:Localize("BreathTrigger"), self.OnDeepBreath, self);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.65, self:Localize("TakeOff"));
        self:RegisterHealthThreshold(0.40, self:Localize("Landing"));
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( blastNova[spellId] ) then
                self:OnBlastNova(actorGUID);
            end
        end,

        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                local id = Root.Unit.GetMobID(guid);
                if ( id == GUARD_ID ) then
                    self:ScheduleGuardRespawn(5); -- dummy value. Doesn't matter as long as it is shorter than the real respawn timer.
                end
            end

            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleGuardRespawn = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("GuardRespawn", timer, "", "", "HIDDEN", self.RespawnAdd, self, GUARD_ID);
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPhaseTwo = function(self)
        if ( self.data.phase >= 2 ) then return; end
        self:ChangePhase(2, true);
    end,

    OnPhaseThree = function(self)
        if ( self.data.phase >= 3 ) then return; end
        self:ChangePhase(3, true);

        self:ChangeMusic("HURRYUP");
    end,

    OnDeepBreath = function(self)
        self:SuperAlert(8, self:Localize("DeepBreath"), "", true, true);
--[[
        self:AlertMe(self:Localize("DeepBreath"), 0.300, 5.500);
        self.TimerReminder:GetDriver():Start(6, 10);
]]
    end,

    OnBlastNova = function(self, guid)
        local distance = self:GetDistance(guid);
        if ( distance ) and ( distance <= 10 ) then
            self:AlertMe(self:Localize("NovaWarning"), 0.400, 5.000);
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(ONYXIA_ID, THIS_MODULE, false);
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
