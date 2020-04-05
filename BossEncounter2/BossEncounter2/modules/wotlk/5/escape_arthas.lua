local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Escape Lich King Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Escape the Lich King fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["EngageTrigger"] = "cold embrace",
        ["HalfTrigger"] = "Another dead end",
        ["ClearTrigger"] = "FIRE",

        -- 2. Events

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells
        ["EngageTrigger"] = "froide étreinte",
        ["HalfTrigger"] = "Encore un cul%-de%-sac",
        ["ClearTrigger"] = "FEU",

        -- 2. Events

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Escape_Arthas";

local ARTHAS_ID = 36954;

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

        self:SetBossUnit(uid, 180);

        data.title = Root.TextGradient("???????", 1, 0, 0, 1, 1, 0, 0.5); -- It is intended.
        data.baseID = THIS_MODULE;

        data.clearAnimation = "ALTERNATE";
        data.ignoreStandardClear = true;
        data.ignoreLeaveCombat = true;
        data.safeEngage = true; -- Do not trigger until the engage trigger is fired.

        self:PrepareBasicWidgets(nil, false);
        self.BossBar:Remove(true); -- Not needed.

        Root.Music.Play("PREPARATION_DUNGEON");

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("EngageTrigger"), self.OnEngaged, self);
        self:RegisterYellCallback("ANY", self:Localize("HalfTrigger"), self.OnHalfWay, self);
        self:RegisterYellCallback("ANY", self:Localize("ClearTrigger"), self.OnCleared, self);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER9_DPSRACE3");

        self.StatusFrame:GetDriver():StartTiming();
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = Shared.OnCombatEvent,

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnHalfWay = function(self)
        self.data.timeOutTimer = -180;
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(ARTHAS_ID, THIS_MODULE, true, true); -- Bypass the hostile check.

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
