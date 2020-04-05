local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Loatheb Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Loatheb fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["InevitableDoom"] = "Inevitable Doom",

        -- 3. Misc
        ["SporeCount"] = "Spore %d",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["InevitableDoom"] = "Malé. inévitable",

        -- 3. Misc
        ["SporeCount"] = "Spore %d",
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Loatheb";

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

        data.sporeCount = 0;
        data.doomInterval = 30;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.20, 0.00, 0.25, 0.00, 0.05); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(180, 360);
        self:SetNearVictoryThreshold(0.10, nil, 0.70); -- Near Victory theme when the boss gets below 10% and 70% of the raid is alive.

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_NAXXRAMAS_ENDWING");

        self.StatusFrame:GetDriver():StartTiming();

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleInevitableDoom(120);
        self.EventWatcher:GetDriver():AddEvent("DoomFaster", 300, "", "", "HIDDEN", self.ChangeDoomSpeed, self, 15);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 29234 ) then
                    self:OnSporeSpawned();
                end
                if ( spellId == 29204 or spellId == 55052 ) then
                    self:OnInevitableDoom();
                end
            end
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleInevitableDoom = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("InevitableDoom", timer, "AUTO", self:Localize("InevitableDoom"), self:IfRole("HEALER", "WARNING", "NORMAL"));
    end,

    ChangeDoomSpeed = function(self, newInterval)
        self.data.doomInterval = newInterval;
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnSporeSpawned = function(self)
        self.data.sporeCount = self.data.sporeCount + 1;
        self.StatusFrame:SetStatus("TEXT", self:FormatLoc("SporeCount", self.data.sporeCount), true);
    end,

    OnInevitableDoom = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("InevitableDoom");
        self:ScheduleInevitableDoom(self.data.doomInterval);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(16011, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
