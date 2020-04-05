local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Leviathan Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Flame Leviathan fight.

-- 25-man version:
-- No change.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["PursueTrigger"] = "pursues",

        -- 2. Events
        ["ShutdownEnd"] = "System recovery",
        ["TargetSwitch"] = "Target change",

        -- 3. Misc
        ["ShutdownAlert"] = "Leviathan is vulnerable !",
        ["PursueSelf"] = "Run away !",
        ["TowerCount"] = "%d tower(s)",
    },
    ["frFR"] = {
        -- 1. Yells
        ["PursueTrigger"] = "poursuit",

        -- 2. Events
        ["ShutdownEnd"] = "Reprise des systèmes",
        ["TargetSwitch"] = "Chang. de cible",

        -- 3. Misc
        ["ShutdownAlert"] = "Léviathan est vulnérable !",
        ["PursueSelf"] = "Fuyez !",
        ["TowerCount"] = "%d tour(s)",
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Leviathan";

local BUFF_LIST = {
    [1] = select(1, GetSpellInfo(65076)), -- T. of Storms
    [2] = select(1, GetSpellInfo(65075)), -- T. of Flames
    [3] = select(1, GetSpellInfo(65077)), -- T. of Frost
    [4] = select(1, GetSpellInfo(64482)), -- T. of Life
};

local MUSIC_USED = {
    [0] = "THEME_MADNESS", -- No tower encounter
    [1] = "TIER8_SURVIVAL3", -- One tower
    [2] = "TIER8_SURVIVAL2", -- Two towers
    [3] = "TIER8_SURVIVAL1", -- Three towers
    [4] = "THEME_ULTIMATE", -- Four towers
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

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        data.title = "Leviathan";
        data.voidDamage = true; -- Ignore damage done because of the vehicles.

        self:CheckTowers();

        self:PrepareBasicWidgets(nil, true);
        self.EventWatcher:GetDriver():ClearAllEvents(); -- Events not yet.

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("PursueTrigger"), self.OnNewTarget, self);

        self:SetStrictRelevance(true);
        self:AddRelevantTargets(33142); -- the boss body and turrets are relevant targets.
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self.EventWatcher:GetDriver():AddEvent("ValidateTowers", 2.000, "", "", "HIDDEN", self.ValidateTowers, self);
        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        self.StatusFrame:GetDriver():StartTiming();
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 62475 ) then
                self:OnShutdown();
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 62475 ) then
                self:OnShutdownEnd();
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    CheckTowers = function(self)
        self.data.numTowers = 0;

        -- Scan for each tower buff.
        local uid = Root.Unit.GetUID(self.data.guid);
        if ( uid ) then
            local i, found;
            for i=1, #BUFF_LIST do
                found = Root.Unit.SearchEffect(uid, "BUFF", BUFF_LIST[i]);
                if ( found ) then
                    self.data.numTowers = self.data.numTowers + 1;
                end
            end
        end

        self:EvaluateDifficulty();
    end,

    ValidateTowers = function(self)
        self:CheckTowers();

        local numTowers = self.data.numTowers;
        if ( numTowers > 0 ) then
            self:AlertMe(self:Localize("HardModeTrigger"));
            self.StatusFrame:SetStatus("TEXT", self:FormatLoc("TowerCount", numTowers), true);
            if ( numTowers == 4 ) then
                -- Special cheer up for 4-towers mode.
                self.data.clearSequence = "FINAL";
                self:SetNearVictoryThreshold(0.075, nil, 0.40);
            end
        end
        Root.Music.Play(MUSIC_USED[numTowers]);

        local time = 180 + numTowers * 120;
        self:SetScoreBenchmarks(time/2, time);
    end,

    EvaluateDifficulty = function(self) 
        if ( self.data.numTowers == 0 ) then
            self:SetDifficultyMeter(0.25, 0.10, 0.30, 0.25, 0.20); -- P/B/A/C/S
    elseif ( self.data.numTowers == 1 ) then
            self:SetDifficultyMeter(0.35, 0.25, 0.40, 0.35, 0.40); -- P/B/A/C/S
    elseif ( self.data.numTowers == 2 ) then
            self:SetDifficultyMeter(0.50, 0.50, 0.55, 0.45, 0.60); -- P/B/A/C/S
    elseif ( self.data.numTowers == 3 ) then
            self:SetDifficultyMeter(0.70, 0.75, 0.75, 0.55, 0.80); -- P/B/A/C/S
    elseif ( self.data.numTowers == 4 ) then
            self:SetDifficultyMeter(0.90, 1.00, 0.95, 0.65, 1.00); -- P/B/A/C/S
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnShutdown = function(self)
        if ( not self:EvaluateCooldown("shutdown", 3) ) then return; end

        self:AlertMe(self:Localize("ShutdownAlert"));

        self.EventWatcher:GetDriver():ClearEvent("TargetSwitch");
        self.EventWatcher:GetDriver():AddEvent("ShutdownEnd", 20, "AUTO", self:Localize("ShutdownEnd"), "ALERT");
    end,

    OnShutdownEnd = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("ShutdownEnd");
    end,

    OnNewTarget = function(self, target)
        self:OnEngaged(); -- Fix to laggy engage
        self.data.ignoreLeaveCombat = true;

        if target == UnitName("player") then
            self:AlertMe(self:Localize("PursueSelf"));
        end

        self.EventWatcher:GetDriver():TriggerEvent("TargetSwitch");
        self.EventWatcher:GetDriver():AddEvent("TargetSwitch", 30, "AUTO", self:Localize("TargetSwitch"), "WARNING");
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(33113, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
