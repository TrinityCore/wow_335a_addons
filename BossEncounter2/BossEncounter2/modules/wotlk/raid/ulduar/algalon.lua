local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Algalon Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Algalon fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events

        -- 3. Misc
        ["Lockout"] = "Boss despawn",
        ["NoHelp"] = "No help given on this boss! Good luck!",
        ["Phase2"] = "Start of phase 2",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events

        -- 3. Misc
        ["Lockout"] = "Disparition du boss",
        ["NoHelp"] = "Aucune aide sur ce boss ! Bonne chance !",
        ["Phase2"] = "Début de la phase 2",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
--[[
    [1] = {
        id = "warnAddDeath",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn mini-boss deaths",
            ["frFR"] = "Annoncer les morts des mini-boss",
        },
        explain = {
            ["default"] = "Display a raid alert each time a mini-boss dies.",
            ["frFR"] = "Affiche une alerte de raid chaque fois qu'un mini-boss meurt.",
        },
    },
    [2] = {
        id = "warnUnbalancingStrike",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Unbalancing Strike",
            ["frFR"] = "Annoncer Frappe déséquilibrante",
        },
        explain = {
            ["default"] = "Display a raid alert each time Thorim does an Unbalancing Strike.",
            ["frFR"] = "Affiche une alerte de raid chaque fois que Thorim effectue une Frappe déséquilibrante.",
        },
    },
    [3] = {
        id = "detonationSymbol",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = false,
        label = {
            ["default"] = "Symbol: Rune Detonation",
            ["frFR"] = "Symbole: Détonation runique",
        },
        explain = {
            ["default"] = "Put the skull symbol on the target of the Rune Detonation.",
            ["frFR"] = "Place le symbole crâne sur la cible de la Détonation runique.",
        },
    },
]]
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Algalon";

local ATTEMPT_TIMER = 3600;

-- --------------------------------------------------------------------
-- **                       Definition stuff                         **
-- --------------------------------------------------------------------

Root[THIS_MODULE] = {
    -- --------------------------------------------------------------------
    -- **                            Properties                          **
    -- --------------------------------------------------------------------

    isWrathRaid = true,
    firstEngage = 0, -- Special, time-persistant property of this module to determinate how much time there's left to try Algalon.

    -- --------------------------------------------------------------------
    -- **                             Handlers                           **
    -- --------------------------------------------------------------------

    OnStart = Shared.OnStart,

    OnTrigger = function(self, uid, extraTable)
        if not self:TriggerMe() then return; end

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(1.00, 1.00, 1.00, 1.00, 1.00); -- P/B/A/C/S

        self.data.title = "Algalon";
        self.data.clearSequence = "FINAL";

        self:PrepareBasicWidgets(360, true);

        Root.Music.Play("PREPARATION_BADGUY");

        self:NotifyMe(self:Localize("NoHelp"));

        -- Determinate the time amount left to do attempts on this boss.
        local timeLeft = self:GetAttemptTimeLeft();
        if ( timeLeft > 0 ) then
            self.EventWatcher:GetDriver():AddEvent("Lockout", timeLeft, "AUTO", self:Localize("Lockout"), "NORMAL");
        end
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        -- Memorize the time of the first engage.
        if ( self.firstEngage == 0 ) then self.firstEngage = GetTime(); end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(210, 360);
        self:SetNearVictoryThreshold(0.125, nil, 0.50); -- Near Victory theme when the boss gets below 12.5% and 50% of the raid is alive.

        self:ChangePhase(1, true);

        Root.Music.Play("THEME_ULTIMATE");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(360, true);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.20, self:Localize("Phase2"), self.OnPhaseTwo, self);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = Shared.OnCombatEvent,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    GetAttemptTimeLeft = function(self)
        -- Get the time amount there's left to do attempts on Algalon.
        if ( self.firstEngage == 0 ) then
            return -1; -- unlimited amount for now.
      else
            return max(0, ATTEMPT_TIMER + self.firstEngage - GetTime());
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPhaseTwo = function(self)
        if ( self.data.phase == 2 ) then return; end
        self:ChangePhase(2, true);

        self:ChangeMusic("HURRYUP");

    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(32871, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
