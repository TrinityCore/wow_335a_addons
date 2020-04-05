local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Kel'Thuzad Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Kel'Thuzad fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["Kel'Thuzad"] = "Kel'Thuzad",
        ["TriggerYell"] = "Minions, servants, soldiers",
        ["PhaseTwoWarning"] = "Pray for mercy|Scream your dying breath|The end is upon you",
        ["PhaseTwoEmote"] = "strikes",
        ["PhaseThreeYell"] = "I require aid",

        -- 2. Events
        ["Phase2"] = "Phase 2",
        ["Guardians"] = "Guardians",
        ["FrostBlast"] = "CD: Frost blast",
        ["AddSummon"] = "Crypt Lords arrival",

        -- 3. Misc
        ["FrostBlastWarning"] = ">> HEAL on: <<",
    },
    ["frFR"] = {
        -- 1. Yells
        ["Kel'Thuzad"] = "Kel'Thuzad",
        ["TriggerYell"] = "Serviteurs, valets et soldats",
        ["PhaseTwoWarning"] = "Faites vos prières|Hurlez et expirez|Votre fin est proche",
        ["PhaseTwoEmote"] = "frappe",
        ["PhaseThreeYell"] = "j'ai besoin d'aide",

        -- 2. Events
        ["Phase2"] = "Phase 2",
        ["Guardians"] = "Gardiens",
        ["FrostBlast"] = "Recharge: trait de givre",
        ["AddSummon"] = "Arrivée des seigneurs des cryptes",

        -- 3. Misc
        ["FrostBlastWarning"] = ">> SOINS sur: <<",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnFrostBlast",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Frost Blast",
            ["frFR"] = "Annoncer les traits de givre",
        },
        explain = {
            ["default"] = "Display raid alerts and put symbols on Frost Blast targets.",
            ["frFR"] = "Affiche des alertes de raid et place des symboles sur les personnes subissant le trait de givre.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Kel'Thuzad";

local KELTHUZAD_ID = 15990;

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

    OnTrigger = function(self, uid)
        if not self:TriggerMe() then return; end

        local data = self.data;

        self:GrabStaticWidgets();

        self:SetDummyBossUnit("worldboss", 420, uid ~= nil);

        data.frostBlastList = {};

        data.title = self:Localize("Kel'Thuzad");
        data.baseID = THIS_MODULE;

        self:SetDifficultyMeter(0.60, 0.60, 0.45, 0.35, 0.15); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);
        self.BossBar:Remove(true); -- Do not show the boss bar yet.
        self:CloseDifficultyMeter(true); -- Do not show the difficulty meter yet.

        self:OnEngaged(uid);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self, uid)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        if ( not uid ) then -- Normally engaged.
            self:ChangePhase(1, true);
            Root.Music.Play("THEME_EASY");
        end

        self.StatusFrame:GetDriver():StartTiming();

        self:SetScoreBenchmarks(360, 720);
        self:SetNearVictoryThreshold(0.125, nil, 0.70); -- Near Victory theme when the boss gets below 12.5% and 70% of the raid is alive.

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("PhaseTwoWarning"), self.OnPhaseTwoWarning, self);
        self:RegisterYellCallback("ANY", self:Localize("PhaseTwoEmote"), self.OnPhaseTwo, self);
        self:RegisterYellCallback("ANY", self:Localize("PhaseThreeYell"), self.OnPhaseThree, self);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.45, self:Localize("AddSummon"));

        if ( uid ) then -- Emergency recovery after a disconnect.
            self:OnPhaseTwo();
      else
            self.EventWatcher:GetDriver():AddEvent("Phase2", 226, "AUTO", self:Localize("Phase2"), "WARNING_NOREMINDER", self.OnPhaseTwo, self);
            self.EventWatcher:GetDriver():AddEvent("DifficultyMeter", 6, "", "", "HIDDEN", self.OpenDifficultyMeter, self);  
        end  
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 27808 ) then
                if ( not Root.IsBlacklisted(targetName) ) then
                    self:OnFrostBlast();
                    tinsert(self.data.frostBlastList, targetGUID);
                    self:RegisterHealAssist(targetGUID, 0, 7, 27808);
                end
            end
        end,
    },

    OnMobYell = function(self, message, source)
        if ( not self.running ) then
            if ( source == self:Localize("Kel'Thuzad") ) and ( string.find(message, self:Localize("TriggerYell")) ) then
                self:OnTrigger(nil);
            end
      else
            self:HandleYells(message, source);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                       Special handlers                         **
    -- --------------------------------------------------------------------

    OnPhaseTwoWarning = function(self)
        if ( self.data.phase == 2 ) then return; end
        self.EventWatcher:GetDriver():ChangeEvent("Phase2", 16);
    end,

    OnPhaseTwo = function(self)
        if ( self.data.phase == 2 ) then return; end
        self:ChangePhase(2, true);

        self.EventWatcher:GetDriver():TriggerEvent("Phase2");

        self.data.timeOut = 60;
        self.data.timeOutTimer = 0;

        self:SearchUnit(KELTHUZAD_ID, self.OnBossFound);

        Root.Music.Stop();

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 10, 1);
    end,

    OnBossFound = function(self, uid)
        if ( self.data.phase < 2 ) then self:OnPhaseTwo(); end -- Make sure we are at least in Phase 2.

        self.data.name = UnitName(uid);
        self.data.guid = UnitGUID(uid);
        self.data.bossMaxHealth = UnitHealthMax(uid);
        self.data.bossDead = false;

        self.BossBar:Display();
        self.BossBar:GetDriver():SetWatch(self.data.guid);

        Root.Music.Play("TIER7_FINALBOSS");

        self:ScheduleFrostBlast(25);
    end,

    OnPhaseThree = function(self)
        if ( self.data.phase == 3 ) then return; end
        self:ChangePhase(3, true);

        self:ChangeMusic("HURRYUP");

        self.EventWatcher:GetDriver():AddEvent("Guardians", 15, "AUTO", self:Localize("Guardians"), self:IfRole("SHIELD", "WARNING_NOREMINDER", "NORMAL"));
    end,

    OnFrostBlast = function(self)
        if ( not self:EvaluateCooldown("frostBlast", 5) ) then return; end

        wipe(self.data.frostBlastList);

        if ( self:GetSetting("warnFrostBlast") ) then
            self.EventWatcher:GetDriver():AddEvent("AlertFrostBlast", 0.250, "", "", "HIDDEN", self.AlertFrostBlast, self);
        end

        self.EventWatcher:GetDriver():TriggerEvent("FrostBlast");
        self:ScheduleFrostBlast(30);
    end,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleFrostBlast = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("FrostBlast", timer, "AUTO", self:Localize("FrostBlast"), self:IfRole("HEALER", "WARNING", "NORMAL"));
    end,

    AlertFrostBlast = function(self)
        self:AnnounceUnitList(self.data.frostBlastList, true, self:Localize("FrostBlastWarning"), 7.00);
    end,

    -- Can only access settings during the boring phase 1.

    MayEditSettings = function(self)
        if ( self.status == "ENGAGED" ) and ( self.data ) then
            local timeElapsed = self.data.globalTimer or 0;
            if ( timeElapsed > 5 and self.data.phase == 1 ) then
                return true; -- Allow exceptionnal access to options during phase 1, 5 sec after the trigger.
            end

    elseif ( self.status == "STANDBY" ) then
            return true; -- Will never occur I fear.
        end
        return false;
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;

    -- This is added in case you have a disconnect.
    Root.NPCDatabase.Register(KELTHUZAD_ID, THIS_MODULE, true);


    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], true); -- this module needs to be always set in the global table.
end
