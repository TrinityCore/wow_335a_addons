local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Archavon Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Archavon fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["GrabYell"] = "lunges for",

        -- 2. Events
        ["Grab"] = "Grab",
        ["GrabEnd"] = "Grab: End",

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells
        ["GrabYell"] = "lance la main",

        -- 2. Events
        ["Grab"] = "Attraper",
        ["GrabEnd"] = "Attraper: fin",

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Archavon";

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

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        data.title = "Archavon";

        self:SetDifficultyMeter(0.10, 0.10, 0.05, 0.00, 0.10); -- P/B/A/C/S

        self:PrepareBasicWidgets(300, true);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(120, 300);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_MECHANICAL");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(300, true);

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("GrabYell"), self.OnGrab, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleGrab(47);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = Shared.OnCombatEvent,

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleGrab = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Grab", timer, "AUTO", self:Localize("Grab"), "WARNING_NOREMINDER");  
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnGrab = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Grab");
        self:ScheduleGrab(47);
        self.EventWatcher:GetDriver():AddEvent("GrabEnd", 10, "AUTO", self:Localize("GrabEnd"), self:IfRole("SHIELD", "WARNING", "NORMAL"));
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(31125, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
