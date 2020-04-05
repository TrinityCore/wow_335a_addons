local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Tribunal Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Tribunal fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["EngageTrigger"] = "Countermeasures engaged",
        ["ClearTrigger"] = "The old magic fingers finally won through",

        -- 2. Events
        ["End"] = "Victory",

        -- 3. Misc
        ["Title"] = "Tribunal of Ages",
        ["FocusAdvice"] = "It is recommanded you set Brann as your /focus.",
    },
    ["frFR"] = {
        -- 1. Yells
        ["EngageTrigger"] = "Faille de sécurité détectée",
        ["ClearTrigger"] = "Ces vieux doigts",

        -- 2. Events
        ["End"] = "Victoire",

        -- 3. Misc
        ["Title"] = "Tribunal des Âges",
        ["FocusAdvice"] = "Il est recommandé de mettre en /focus Brann.",
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Tribunal";

local BRONZEBEARD_ID = 28070;

local DURATION = 274;

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

        data.title = self:Localize("Title");
        data.baseID = THIS_MODULE;

        data.clearAnimation = "ALTERNATE";
        data.brannGUID = UnitGUID(uid);
        data.ignoreStandardClear = true;
        data.ignoreWipe = true;
        data.ignoreCombatDelay = true;
        data.ignoreResults = true;
        data.ignoreAddsEngage = true;
        data.clearLockdown = 2700; -- Block retriggering of this boss module for 45 minutes.

        self:SetDummyBossUnit("elite", 60, false);

        self:PrepareBasicWidgets(nil, true);
        self.BossBar:Remove(true); -- Not needed.

        Root.Music.Play("PREPARATION_GENERAL");

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("EngageTrigger"), self.OnEngaged, self);
        self:RegisterYellCallback("ANY", self:Localize("ClearTrigger"), self.OnCleared, self);

        self:ResetAdds();
        self:RegisterAdd(BRONZEBEARD_ID, true);

        local focusGUID = UnitGUID("focus");
        if ( not focusGUID ) or ( focusGUID ~= data.brannGUID ) then
            self:NotifyMe(self:Localize("FocusAdvice"), 0.500, 7.500);
        end
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_EASY");

        self.StatusFrame:GetDriver():StartTiming();

        if ( self.data.bossAlreadyFighting ) then return; end

        self.EventWatcher:GetDriver():AddEvent("End", DURATION, "AUTO", self:Localize("End"), "NORMAL");
        self.TimerReminder:GetDriver():Start(DURATION, 30, "");
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                if ( self.data.brannGUID == guid ) then
                    self:OnFailed(true);
                end
            end
            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,
    },

    OnMobYell = Shared.OnMobYell,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(BRONZEBEARD_ID, THIS_MODULE, false, true); -- Bypass the hostile check.

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
