local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Heigan Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Heigan fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["TeleportWarning"] = "The end is upon you",

        -- 2. Events
        ["Release"] = "End of dance",

        -- 3. Misc
        ["GetReady"] = "Get ready to dance !",
    },
    ["frFR"] = {
        -- 1. Yells
        ["TeleportWarning"] = "Votre fin est venue",

        -- 2. Events
        ["Release"] = "Fin de la danse",

        -- 3. Misc
        ["GetReady"] = "Préparez-vous à danser !",
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Heigan";

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

        data.title = Root.ReadLocTable({
            ["default"] = "Heigan",
            ["frFR"] = "Heigen",
        });

        self:SetDifficultyMeter(0.15, 0.20, 0.10, 0.25, 0.25); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(180, 420);

        self:ChangePhase(1, true);

        Root.Music.Play("TIER7_SURVIVAL3");

        self.StatusFrame:GetDriver():StartTiming();

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("TeleportWarning"), self.OnTeleport, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleTeleport(90);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = Shared.OnCombatEvent,

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleTeleport = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Teleport", timer, "AUTO", self:Localize("Teleport"), "ALERT");
    end,

    ScheduleRelease = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Release", timer, "AUTO", self:Localize("Release"), "WARNING", self.OnRelease, self);
    end,

    DanseMessage = function(self)
        self:AlertMe(self:Localize("GetReady"), 0.750, 4.000);
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnTeleport = function(self)
        self:ChangePhase(2, true);

        self.EventWatcher:GetDriver():TriggerEvent("Teleport");
        self.EventWatcher:GetDriver():AddEvent("DanseMsg", 4, "", "", "HIDDEN", self.DanseMessage, self);
        self:ScheduleRelease(45);
    end,

    OnRelease = function(self)
        self:ChangePhase(1, true);
        self:ScheduleTeleport(90);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(15936, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
