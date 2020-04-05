local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Anub'Rekhan Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Anub'Rekhan fight.

-- 25-man version:
-- Locust Swarm - Lasts 20 sec. instead of 16 sec.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["LocustSwarmYell"] = "swarm",

        -- 2. Events
        ["LocustSwarm"] = "Locust Swarm",
        ["LocustSwarmEnd"] = "Locust Swarm: End",

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells
        ["LocustSwarmYell"] = "nuée",

        -- 2. Events
        ["LocustSwarm"] = "Sauterelles",
        ["LocustSwarmEnd"] = "Sauterelles: fin",

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Anub'Rekhan";

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

        self:SetDifficultyMeter(0.10, 0.15, 0.10, 0.00, 0.05); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(150, 300);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER7_TANKNSPANK1");

        self.StatusFrame:GetDriver():StartTiming();

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("LocustSwarmYell"), self.OnLocustSwarm, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleLocustSwarm(89) -- 72);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = Shared.OnCombatEvent,

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleLocustSwarm = function(self, timer)
        local eventType = "NORMAL";
        if ( self:HasRole("HEALER") or self:HasRole("MELEE") ) then eventType = "WARNING_NOREMINDER"; end
        self.EventWatcher:GetDriver():AddEvent("LocustSwarm", timer, "AUTO", self:Localize("LocustSwarm"), eventType);  
    end,

    GetLocustSwarmDuration = function(self)
        if ( Root.GetInstanceMode() == "HEROIC" ) then return 20; end
        return 16;
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnLocustSwarm = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("LocustSwarm");  
        self:ScheduleLocustSwarm(103);
        self.EventWatcher:GetDriver():AddEvent("LocustSwarmEnd", self:GetLocustSwarmDuration(), "AUTO", self:Localize("LocustSwarmEnd"), self:IfRole("SHIELD", "WARNING", "NORMAL"));  
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(15956, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
