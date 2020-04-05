local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Toravon Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Toravon fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Whiteout"] = "Whiteout",
        ["Orb"] = "Frozen Orb",

        -- 3. Misc

    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Whiteout"] = "Blanc aveuglant",
        ["Orb"] = "Orbe gelé",

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Toravon";

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

        data.title = "Toravon";

        self:SetDifficultyMeter(0.40, 0.50, 0.60, 0.15, 0.15); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);

        Root.Music.Play("PREPARATION_DUNGEON");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(180, 360);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_EASY");

        self.StatusFrame:GetDriver():StartTiming();

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleWhiteout(24);
        self:ScheduleOrb(11);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 72095 or spellId == 72091 ) then
                    self:OnOrb();
                end
                if ( spellId == 72096 or spellId == 72034 ) then
                    self:OnWhiteout();
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleWhiteout = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Whiteout", timer, "AUTO", self:Localize("Whiteout"), "WARNING");
    end,

    ScheduleOrb = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Orb", timer, "AUTO", self:Localize("Orb"), "WARNING");
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnWhiteout = function(self, count)
        self.EventWatcher:GetDriver():TriggerEvent("Whiteout");
        self:ScheduleWhiteout(38);
    end,

    OnOrb = function(self, count)
        self.EventWatcher:GetDriver():TriggerEvent("Orb");
        self:ScheduleOrb(33);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(38433, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
