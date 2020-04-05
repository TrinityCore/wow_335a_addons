local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Sindragosa Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Sindragosa fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["LiftTrigger"] = "Your incursion",

        -- 2. Events
        ["Lift"] = "Take off",
        ["Grip"] = "Grip",

        -- 3. Misc
        ["BlisteringColdAlert"] = "Blistering Cold",
        ["UnchainedMagicSelf"] = "Moderate your spellcasting!",
        ["Phase2"] = "Phase 2 starts",
        ["FirstLift"] = "First take off",
        ["TombWarning"] = ">> Ice tomb target(s): <<",
        ["ChilledSelf"] = "%dx Chilled",
        ["InstabilitySelf"] = "%dx Instability",
        ["BeaconSelf"] = "You're about to get frozen!",
    },
    ["frFR"] = {
        -- 1. Yells
        ["LiftTrigger"] = "Votre incursion",

        -- 2. Events
        ["Lift"] = "Décollage",
        ["Grip"] = "Poigne",

        -- 3. Misc
        ["BlisteringColdAlert"] = "Froid cinglant",
        ["UnchainedMagicSelf"] = "Modérez vos incantations !",
        ["Phase2"] = "Début de la phase 2",
        ["FirstLift"] = "Premier décollage",
        ["TombWarning"] = ">> Cible(s) du gel : <<",
        ["ChilledSelf"] = "Froid x%d",
        ["InstabilitySelf"] = "Instabilité x%d",
        ["BeaconSelf"] = "Vous allez être gelé !",
    },
};

local MYSTIC_BUFFET = GetSpellInfo(72529);

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "buffetToggle",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Toggle: Distance checker / Buffet counter",
            ["frFR"] = "Basculer : vérif. distance / compteur de rafales",
        },
        explain = {
            ["default"] = "Do you want to display the buffet counter in phase 2 (checked) or the distance checker? (unchecked)",
            ["frFR"] = "Préférez-vous afficher le compteur de rafales en phase 2 (coché) ou le vérificateur de distance ? (décoché)",
        },
    },
    [2] = {
        id = "warnTomb",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Ice Tombs",
            ["frFR"] = "Annoncer les gels",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol each time a raid member gets frozen in Ice Tombs.",
            ["frFR"] = "Affiche une alerte de raid et place un signe chaque fois qu'un membre du raid se fait congeler dans une tombe de glace.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Sindragosa";

local blisteringCold = {
    [70123] = true,
    [71047] = true,
    [71048] = true,
    [71049] = true,
};

local UnitListBuffetAlgorithm = {
    updateRate = 0.250,

    title = {
        ["default"] = "Mystic Buffet counter",
        ["frFR"] = "Compteur de rafales",
    },

    OnRefresh = function(self, driver, myTable)
        local i, guid, name, uid;
        local found, timeLeft, stackCount;
        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            if ( uid ) then
                if ( UnitInParty(uid) or UnitInRaid(uid) ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitIsVisible(uid) ) then
                    found, timeLeft, stackCount = Root.Unit.SearchEffect(uid, "DEBUFF", MYSTIC_BUFFET);
                    local realCount = 0;
                    if ( found ) then
                        local unitTable = driver:Allocate();
                        unitTable.guid = guid;
                        unitTable.text = tostring(stackCount);
                        unitTable.count = stackCount;
                        myTable[#myTable+1] = unitTable;
                        realCount = stackCount;
                    end
                    if ( guid == UnitGUID("player") ) then
                        if ( realCount >= 4 ) then
                            driver:ToggleFlash(1, 0, 0);
                      else
                            driver:ToggleFlash(nil);
                        end
                    end
                end
            end
        end
        Root.Sort.ByNumericField(myTable, "count", true);
        local title = Root.ReadLocTable(self.title);
        return title, "";
    end,
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

        self.data.tombList = { };

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(1.00, 1.00, 1.00, 0.85, 0.95); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(1.00, 1.00, 1.00, 0.50, 0.75); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(600, true);

        Root.Music.Play("PREPARATION_DUNGEON");

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 10, nil);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(300, 600);
        self:SetNearVictoryThreshold(0.10, 600-120, 0.70); -- Near Victory theme when the boss gets below 10%, the time left is above 2 minutes and 70% of the raid is alive.

        self:ChangePhase(1, true);

        Root.Music.Play("TIER9_TANKNSPANK3");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(600, true);
        self.TimerReminder:GetDriver():Clear(); -- No timer reminder for this fight. It might be used for blistering cold timer.

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("LiftTrigger"), self.OnTakeOff, self);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.87, self:Localize("FirstLift"));
        self:RegisterHealthThreshold(0.35, self:Localize("Phase2"), self.OnPhaseTwo, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleGrip(39);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( blisteringCold[spellId] ) then
                    self:OnBlisteringCold();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 69762 ) and ( targetGUID == UnitGUID("player") ) then
                    self:OnLocalUnchainedMagic();
                end
                if ( spellId == 70126 ) and ( targetGUID ) and ( targetName ) then
                    self:OnBeacon(targetGUID, targetName);
                end
                if ( spellId == 69766 ) and ( targetGUID ) then
                    self:OnInstability(targetGUID, stackAmount);
                end
                if ( spellId == 70106 ) and ( targetGUID ) then
                    self:OnChilled(targetGUID, stackAmount);
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleTakeOff = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("TakeOff", timer, "AUTO", self:Localize("Lift"), "WARNING");
    end,

    ScheduleGrip = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Grip", timer, "AUTO", self:Localize("Grip"), "WARNING");
    end,

    AnnounceTomb = function(self)
        if ( self:GetSetting("warnTomb") ) then
            self:AnnounceUnitList(self.data.tombList, true, self:Localize("TombWarning"), 20.00);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPhaseTwo = function(self)
        if ( self.data.phase == 2 ) then return; end
        self:ChangePhase(2, true);

        self.EventWatcher:GetDriver():ClearEvent("TakeOff");

        -- TODO: check grip timer is still correct

        if ( self:GetSetting("buffetToggle") ) then
            self.UnitList:GetDriver():AssignAlgorithm(UnitListBuffetAlgorithm);
            self.UnitList:Display();
        end

        self:ChangeMusic("HURRYUP");
    end,

    OnTakeOff = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("TakeOff");
        self:ScheduleTakeOff(110);

        self.EventWatcher:GetDriver():ClearEvent("Grip");
        self:ScheduleGrip(89);
    end,

    OnBlisteringCold = function(self)
        self:SuperAlert(5, self:Localize("BlisteringColdAlert"), nil, true, true);

        self.EventWatcher:GetDriver():TriggerEvent("Grip");
        self:ScheduleGrip(67);
    end,

    OnBeacon = function(self, guid, name)
        if ( guid == UnitGUID("player") ) then
            self:AlertMe(self:Localize("BeaconSelf"), 0.300, 4.000);
        end
        if ( self:EvaluateCooldown("beacon", 3) ) then
            wipe(self.data.tombList);
            self.EventWatcher:GetDriver():AddEvent("Tomb", 0.300, "", "", "HIDDEN", self.AnnounceTomb, self);
        end
        tinsert(self.data.tombList, guid);
    end,

    OnLocalUnchainedMagic = function(self)
        self:AlertMe(self:Localize("UnchainedMagicSelf"), 0.300, 7.000);
    end,

    OnChilled = function(self, guid, count)
        if ( count > 6 ) then
            self:RegisterHealAssist(guid, 0, 8);

            if ( math.fmod(count - 1, 2) == 0 ) and ( UnitGUID("player") == guid ) then
                self:AlertMe(self:FormatLoc("ChilledSelf", count), 0.300, 3.000);
            end
        end
    end,

    OnInstability = function(self, guid, count)
        if ( count > 4 ) then
            self:RegisterHealAssist(guid, 5, 6);

            if ( math.fmod(count - 1, 2) == 0 ) and ( UnitGUID("player") == guid ) then
                self:AlertMe(self:FormatLoc("InstabilitySelf", count), 0.300, 3.000);
            end
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(36853, THIS_MODULE, true);
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
