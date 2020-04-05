local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Training Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Training Dummies fights.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["End"] = "End of training",

        -- 3. Misc
        ["Title"] = "Training",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["End"] = "Fin de l'entraînement",

        -- 3. Misc
        ["Title"] = "Entraînement",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "trainingDuration",
        type = "NUMBER",
        label = {
            ["default"] = "Training duration",
            ["frFR"] = "Durée de l'entraînement",
        },
        explain = {
            ["default"] = "Set the amount of time you have before the training ends (in seconds).",
            ["frFR"] = "Règle la quantité de temps avant que l'entraînement prenne fin (en secondes).",
        },
        min = 15,
        max = 900,
        step = 15,
        defaultValue = 180,
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Training";

-- --------------------------------------------------------------------
-- **                       Definition stuff                         **
-- --------------------------------------------------------------------

Root[THIS_MODULE] = {
    -- --------------------------------------------------------------------
    -- **                            Properties                          **
    -- --------------------------------------------------------------------

    running = false, -- Never set this to true.
    data = nil, -- Never set this.
    status = nil,

    -- --------------------------------------------------------------------
    -- **                             Handlers                           **
    -- --------------------------------------------------------------------

    OnStart = Shared.OnStart,

    OnTrigger = function(self, uid, extraTable)
        if not self:TriggerMe() then return; end

        local data = self.data;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid, 45);

        data.title = self:Localize("Title");
        data.ignoreCombatDelay = true;
        data.ignoreLeaveCombat = true;
        data.ignoreWipe = true;
        data.ignoreStandardClear = true;
        data.clearAnimation = "ALTERNATE";
        data.clearSequence = "NORMAL";
        data.nullScore = true;
        data.clearLockdown = 30;
        data.wipeLockdown = 0;

        self:PrepareBasicWidgets(nil, false);
        self.BossBar:Remove(true); -- Not needed.

        Root.Music.Play("PREPARATION_GENERAL");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_EASY");

        local timer = self:GetSetting("trainingDuration");
        self.StatusFrame:GetDriver():StartCountdown(timer, nil);
        self.TimerReminder:GetDriver():Start(timer, 20, self:Localize("End"));
        self.EventWatcher:GetDriver():AddEvent("End", timer, "", "", "HIDDEN", self.OnCleared, self);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        -- Hack to deal with the unusual way training dummies are engaged.

        if ( self.status == "STANDBY" and UnitAffectingCombat("player") ) then
            self:OnEngaged();
        end

        Shared.OnUpdate(self, elapsed);
    end,

    OnCombatEvent = Shared.OnCombatEvent,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(31146, THIS_MODULE, false);
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end