local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Sartharion Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Sartharion fight.

-- 25-man version:
-- No change.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["LavaWaveAlert"] = "The lava",
        ["Drake1"] = "Tenebron! The eggs are yours",
        ["Drake2"] = "Shadron! Come to me!",
        ["Drake3"] = "Vesperon, the clutch is in danger!",

        -- 2. Events
        ["DrakeArrival"] = "%s arrival",
        ["DrakeActive"] = "%s active",
        ["LavaWave"] = "Lava wave",

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells
        ["LavaWaveAlert"] = "La lave",
        ["Drake1"] = "Tenebron",
        ["Drake2"] = "Shadron",
        ["Drake3"] = "Vesperon",

        -- 2. Events
        ["DrakeArrival"] = "%s arrive",
        ["DrakeActive"] = "%s actif",
        ["LavaWave"] = "Vague de lave",

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Sartharion";

local DRAKE_ID = {
    [1] = 30452, -- Tenebron
    [2] = 30451, -- Shadron
    [3] = 30449, -- Vesperon
};

local DRAKE_TIMER = {
    [1] = 30,
    [2] = 80,
    [3] = 120,
};

local DRAKE_NAME = {
    [1] = "Tenebron",
    [2] = "Shadron",
    [3] = "Vesperon",
};

local DRAKE_BUFF = {
    [61248] = 1,
    [58105] = 2,
    [61251] = 3,
};

local MUSIC_USED = {
    [0] = "TIER7_TANKNSPANK1", -- No drake encounter
    [1] = "TIER7_DPSRACE2", -- One drake
    [2] = "TIER7_DPSRACE1", -- Two ones
    [3] = "THEME_ULTIMATE", -- Three ones
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

        data.drakeChecklist = {};
        data.ignoreAdds = true; -- in case you use the violent 3-D method...

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        data.title = "Sartharion";

        self:EvaluateDifficulty();

        self:PrepareBasicWidgets(900, true);

        Root.Music.Play("PREPARATION_GENERAL");

        self:ResetAdds();
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self.EventWatcher:GetDriver():AddEvent("ValidateDrakes", 2.000, "", "", "HIDDEN", self.ValidateDrakes, self);
        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(900, true);

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("LavaWaveAlert"), self.OnLavaWave, self);
        self:RegisterYellCallback(nil, self:Localize("Drake1"), self.OnDrakeYell, self, 1);
        self:RegisterYellCallback(nil, self:Localize("Drake2"), self.OnDrakeYell, self, 2);
        self:RegisterYellCallback(nil, self:Localize("Drake3"), self.OnDrakeYell, self, 3);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleLavaWave(30);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 57491 ) then
                    self:RegisterHealAssist(targetGUID, 0, 10, spellId);
                end
                if ( DRAKE_BUFF[spellId] ) then
                    self:AddDrake(DRAKE_BUFF[spellId]);
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleLavaWave = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("LavaWave", timer, "AUTO", self:Localize("LavaWave"), "WARNING_NOREMINDER");
    end,

    AddDrake = function(self, id)
        if ( not self.running ) then return; end
        if ( self.data.drakeChecklist[id] ) then return; end
        self.data.drakeChecklist[id] = true;

        self.EventWatcher:GetDriver():AddEvent("Drake"..id, DRAKE_TIMER[id], "AUTO", self:FormatLoc("DrakeArrival", DRAKE_NAME[id]), "WARNING");  
        self:RegisterAddEX(DRAKE_ID[id], false, "DISABLE");
        self:EvaluateDifficulty();
    end,

    ValidateDrakes = function(self)
        local numDrakes = self:GetNumAdds();
        if ( numDrakes > 0 ) then
            self:UpdateAddsCount(false);
            if ( numDrakes == 3 ) then self.data.clearSequence = "FINAL"; end
        end
        Root.Music.Play(MUSIC_USED[numDrakes]);

        local time = 240 + numDrakes * 120;
        self:SetScoreBenchmarks(time/1.5, time);
        self:SetNearVictoryThreshold(0.10, nil, 0.70); -- Near Victory theme when the boss gets below 10.0% and 70% of the raid is alive.
    end,

    EvaluateDifficulty = function(self)
        local numDrakes = self:GetNumAdds();
        if ( numDrakes == 0 ) then
            self:SetDifficultyMeter(0.20, 0.25, 0.20, 0.30, 0.25); -- P/B/A/C/S
    elseif ( numDrakes == 1 ) then
            self:SetDifficultyMeter(0.40, 0.60, 0.35, 0.45, 0.45); -- P/B/A/C/S
    elseif ( numDrakes == 2 ) then
            self:SetDifficultyMeter(0.65, 0.80, 0.55, 0.65, 0.70); -- P/B/A/C/S
    elseif ( numDrakes == 3 ) then
            self:SetDifficultyMeter(0.90, 1.00, 0.80, 0.90, 1.00); -- P/B/A/C/S
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnDrakeYell = function(self, drakeID)
        self.EventWatcher:GetDriver():TriggerEvent("Drake"..drakeID);
        self.EventWatcher:GetDriver():AddEvent("DrakeActive"..drakeID, 12, "AUTO", self:FormatLoc("DrakeActive", DRAKE_NAME[drakeID]), "ALERT");
    end,

    OnLavaWave = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("LavaWave");
        self:ScheduleLavaWave(30);
        self:AlertMe("|cff2020ff"..self:Localize("LavaWave").."|r", 0.750, 4.000);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(28860, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
