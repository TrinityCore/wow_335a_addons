local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Gothik Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Gothik fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["GothikTeleport"] = "I have waited",

        -- 2. Events
        ["Arrival"] = "Gothik arrival",

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells
        ["GothikTeleport"] = "J'ai attendu",

        -- 2. Events
        ["Arrival"] = "Gothik arrive",

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "placeSymbols",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Place symbols on dangerous enemies",
            ["frFR"] = "Placer des symboles sur les ennemis dangereux",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Gothik";

local waveInfo = { -- Time at which the wave spawns after the start of the fight.
    [1] = 30 -2,
    [2] = 50 -2,
    [3] = 70 -2,
    [4] = 80 -2,
    [5] = 90 -2,
    [6] = 105 -2,
    [7] = 115 -2,
    [8] = 130 -2,
    [9] = 140 -2,
    [10] = 150 -2,
    [11] = 155 -2,
    [12] = 170 -2,
    [13] = 180 -2,
    [14] = 190 -2,
    [15] = 200 -2,
    [16] = 205 -2,
    [17] = 210 -2,
    [18] = 230 -2,
    [19] = 245 -2,
};

local targetPriorityA = {
    [16149] = 3,
    [16150] = 2,
    [16148] = 1,
};

local targetPriorityB = {
    [16126] = 2,
    [16125] = 1,
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

        data.waveCount = 0;
        data.ignoreLeaveCombat = true;
        data.targetListA = {};
        data.targetListB = {};
        data.lastSymbolTriggered = -999;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid, 300);

        data.title = "Gothik";

        self:SetDifficultyMeter(0.20, 0.00, 0.10, 0.35, 0.20); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);
        self.BossBar:Remove(true); -- Do not show the boss bar yet.

        Root.Music.Play("PREPARATION_GENERAL");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(315, 420);

        self:ChangePhase(1, true);

        Root.Music.Play("THEME_EASY");

        self.StatusFrame:GetDriver():StartTiming();

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("GothikTeleport"), self.OnPhaseTwo, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleNextWave();
        self.EventWatcher:GetDriver():AddEvent("Arrival", 270, "AUTO", self:Localize("Arrival"), "WARNING");
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        local targetListA = self.data.targetListA;
        local targetListB = self.data.targetListB;
        wipe(targetListA);
        wipe(targetListB);

        if ( Root.CheckAuth("SYMBOL") and self:GetSetting("placeSymbols") ) then
            local i, guid, name, uid, id;
            for i=1, Root.Unit.GetNumUID() do
                guid, name = Root.Unit.GetUID(i);
                uid = Root.Unit.GetUID(guid);
                id = Root.Unit.GetMobID(guid);
                if ( uid ) and ( id ) then
                    if ( targetPriorityA[id] ) then
                        tinsert(targetListA, uid.."|"..targetPriorityA[id]);
                    end
                    if ( targetPriorityB[id] ) then
                        tinsert(targetListB, uid.."|"..targetPriorityB[id]);
                    end
                end
            end
        end

        table.sort(targetListA, self.MySorting);
        table.sort(targetListB, self.MySorting);

        if #targetListA > 0 and ( GetTime() - self.data.lastSymbolTriggered ) < 0.500 then
            uid, _ = strsplit("|", targetListA[1], 2);
            if ( GetRaidTargetIndex(uid) ~= 8 ) then
                SetRaidTarget(uid, 8);
                self.data.lastSymbolTriggered = GetTime();
            end
        end
        if #targetListB > 0 and ( GetTime() - self.data.lastSymbolTriggered ) < 0.500 then
            uid, _ = strsplit("|", targetListB[1], 2);
            if ( GetRaidTargetIndex(uid) ~= 7 ) then
                SetRaidTarget(uid, 7);
                self.data.lastSymbolTriggered = GetTime();
            end
        end

        Shared.OnUpdate(self, elapsed);
    end,

    OnCombatEvent = Shared.OnCombatEvent,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleNextWave = function(self)
        local id = self.data.waveCount + 1;
        if ( id > #waveInfo ) then return; end
        local timeDelta = waveInfo[id] - (waveInfo[id-1] or 0);
        self.data.waveCount = id;
        self.EventWatcher:GetDriver():AddEvent("Wave", timeDelta, "AUTO", self:FormatLoc("Wave", id, #waveInfo), "NORMAL", self.OnWaveSpawn, self);
    end,

    MySorting = function(item1, item2)
        local uid1, score1 = strsplit("|", item1, 2);
        local uid2, score2 = strsplit("|", item2, 2);
        score1 = tonumber(score1) or 0;
        score2 = tonumber(score2) or 0;
        if ( score1 > score2 ) then return true; end
        return false;
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPhaseTwo = function(self)
        self:ChangePhase(2, true);
        self.EventWatcher:GetDriver():TriggerEvent("Arrival");
        self.EventWatcher:GetDriver():ClearEvent("Wave");
        self.EventWatcher:Remove();

        self.data.timeOut = 60;
        self.data.timeOutTimer = 0;

        self.BossBar:Display();

        self.data.ignoreLeaveCombat = false;

        Root.Music.Play("THEME_MADNESS");
    end,

    OnWaveSpawn = function(self)
        self.StatusFrame:SetStatus("TEXT", format("%d / %d", self.data.waveCount, #waveInfo), true);
        self:ScheduleNextWave();
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(16060, THIS_MODULE, true);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
