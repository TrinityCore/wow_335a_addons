local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

local Distance = Root.GetOrNewModule("Distance");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Saurfang Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Saurfang fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Frenzy"] = "Frenzy",
        ["BloodBeasts"] = "Blood Beasts",

        -- 3. Misc
        ["Title"] = "Saurfang",
        ["RuneAlert"] = ">> %s has the Rune of Blood! <<",
        ["MarkAlert"] = ">> %s has the Mark of the Fallen Champion! <<",
        ["TooClose"] = "You are not spaced enough.",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Frenzy"] = "Frénésie",
        ["BloodBeasts"] = "Bêtes de sang",

        -- 3. Misc
        ["Title"] = "Saurcroc",
        ["RuneAlert"] = ">> %s a la rune de sang ! <<",
        ["MarkAlert"] = ">> %s a la marque du champion déchu ! <<",
        ["TooClose"] = "Vous n'êtes pas assez espacé.",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "checkSelfPlacement",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Check placement",
            ["frFR"] = "Vérifier mon placement",
        },
        explain = {
            ["default"] = "Warn you when you stay next to 1 player for too long (2 on 25 players mode). No effect if you are in melee range.",
            ["frFR"] = "Permet de vous avertir quand vous restez trop proche d'1 joueur trop longtemps (2 en mode 25 joueurs). Aucun effet si vous êtes à portée du corps à corps.",
        },
    },
    [2] = {
        id = "warnRuneOfBlood",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Rune of Blood",
            ["frFR"] = "Annoncer la rune de sang",
        },
        explain = {
            ["default"] = "Display a raid alert each time a raid member gets the Rune of Blood.",
            ["frFR"] = "Affiche une alerte de raid chaque fois qu'un membre du raid obtient la rune de sang.",
        },
    },
    [3] = {
        id = "warnMarks",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Marks",
            ["frFR"] = "Annoncer les marques",
        },
        explain = {
            ["default"] = "Display a raid alert for each Mark of the Fallen Champion cast on the raid.",
            ["frFR"] = "Affiche une alerte de raid pour chaque marque du champion déchu lancée sur le raid.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Saurfang";

local summon = {
    [72173] = true,
    [72356] = true,
    [72357] = true,
    [72358] = true,
};

local rune = {
    [72408] = true,
    [72409] = true,
    [72410] = true,
    [72447] = true,
    [72448] = true,
    [72449] = true,
};

local mark = {
    [72255] = true,
    [72256] = true,
    [72293] = true,
    [72444] = true,
    [72445] = true,
    [72446] = true,
};

local bloodBoil = {
    [72385] = true,
    [72441] = true,
    [72442] = true,
    [72443] = true,
};

local POSITION_CHECK_INTERVAL = 1.00;
local POSITION_FAILURE_THRESHOLD = 10;

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

        data.positionFailures = 0;
        data.title = self:Localize("Title");

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(1.00, 1.00, 0.90, 0.20, 0.75); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.70, 0.70, 0.60, 0.10, 0.50); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(480, true);

        local threshold = self:GetProximityThreshold();
        if ( not self:HasRole("CASTER") ) then threshold = 6 * threshold; end
        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 12, threshold);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(300, 480);
        self:SetNearVictoryThreshold(0.10, 480-60, 0.90); -- Near Victory theme when the boss gets below 10%, the time left is above 1 minute and 90% of the raid is alive.

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER9_DPSRACE3");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(480, true);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.30, self:Localize("Frenzy"));

        self:OnPositionCheck();
        self:OnRaidPositionCheck();

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleBloodBeasts(41);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( summon[spellId] ) then
                    self:OnBloodBeasts();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( rune[spellId] ) and ( targetName ) then
                    self:OnRune(targetName);
                end
                if ( mark[spellId] ) and ( targetGUID ) and ( targetName ) then
                    self:OnMark(targetName);
                    self:RegisterHealAssist(targetGUID, 0, 480, spellId);
                end
                if ( bloodBoil[spellId] ) and ( targetGUID ) then
                    self:RegisterHealAssist(targetGUID, 3, 15, spellId);
                    -- self:AnnounceToRaid(string.format("{rt8} DOT PHYSIQUE: %s {rt8}", targetName));
                    -- self:PlaceSymbol(targetGUID, 8, 8);
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleBloodBeasts = function(self, timer)
        -- Tanks & melee damage dealers will want to also have the alert, since they must stop AOEing.
        self.EventWatcher:GetDriver():AddEvent("BloodBeasts", timer, "AUTO", self:Localize("BloodBeasts"), self:IfRole("OFFENSIVE", "WARNING_NOREMINDER", "NORMAL"));
    end,

    CheckPosition = function(self)
        local distance = self:GetDistance(self.data.guid) or 30;
        if ( distance <= 10 ) then return true; end

        if ( self.UnitList:GetDriver():GetNumUnits() < self:GetProximityThreshold() ) then
            return true;
      else
            return false;
        end
    end,

    GetProximityThreshold = function(self)
        local mode, size = Root.GetInstanceFormat();
        if ( size == 25 ) then return 2; end
        return 1;
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnBloodBeasts = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("BloodBeasts");
        self:ScheduleBloodBeasts(41);
    end,

    OnRune = function(self, name)
        if ( self:GetSetting("warnRuneOfBlood") ) then
            self:AnnounceToRaid(self:FormatLoc("RuneAlert", name));
        end
    end,

    OnMark = function(self, name)
        if ( self:GetSetting("warnMarks") ) then
            self:AnnounceToRaid(self:FormatLoc("MarkAlert", name));
        end
    end,

    OnPositionCheck = function(self)
        -- Position is not a problem for melees.
        if ( not self:HasRole("CASTER") ) then return; end
        if ( UnitIsDeadOrGhost("player") ) then return; end
        if ( not self:GetSetting("checkSelfPlacement") ) then return; end

        self.EventWatcher:GetDriver():AddEvent("PositionCheck", POSITION_CHECK_INTERVAL, "", "", "HIDDEN", self.OnPositionCheck, self);

        if ( not self:CheckPosition() ) then
            self.data.positionFailures = self.data.positionFailures + 1;
            if ( self.data.positionFailures >= POSITION_FAILURE_THRESHOLD ) then
                self:AlertMe(self:Localize("TooClose"), 0.500, 3.500);
                self.data.positionFailures = 0;
            end
      else
            self.data.positionFailures = 0;
        end
    end,

    OnRaidPositionCheck = function(self)
        self.EventWatcher:GetDriver():AddEvent("RaidPositionCheck", 8, "", "", "HIDDEN", self.OnRaidPositionCheck, self);

        -- Feature aborted. After all, this boss has become so weak additionnal features aren't needed.
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(37813, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
