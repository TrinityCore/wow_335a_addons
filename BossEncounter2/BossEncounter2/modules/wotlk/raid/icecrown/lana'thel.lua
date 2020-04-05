local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Lana'thel Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Lana'thel fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["InitialBite"] = "Initial bite",
        ["Bite"] = "Bite round %d",

        -- 3. Misc
        ["Title"] = "Lana'thel",
        ["PactAlert"] = ">> Pact: <<",
        ["PactSelf"] = "You are linked to |cffffff00%s|r!!",
        ["ShadowsSelf"] = "Move away!",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["InitialBite"] = "Morsure initiale",
        ["Bite"] = "Morsure round %d",

        -- 3. Misc
        ["Title"] = "Lana'thel",
        ["PactAlert"] = ">> Pacte : <<",
        ["PactSelf"] = "Vous êtes relié à |cffffff00%s|r !!",
        ["ShadowsSelf"] = "Déplacez-vous !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnPact",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Pacts",
            ["frFR"] = "Annoncer les pactes",
        },
        explain = {
            ["default"] = "Display a raid alert and put symbols on players linked by the pact.",
            ["frFR"] = "Affiche une alerte de raid et place des signes sur les joueurs liés par le pacte.",
        },
    },
    version = 1,
};

local QUEEN_ESSENCE = GetSpellInfo(71530);
local BLOODTHIRST = GetSpellInfo(70877);

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Lana'thel";

local pact = {
    [71340] = true,
};

local shadows = {
    [71264] = true,
    [71265] = true,
    [71266] = true,
    [71277] = true,
    [72638] = true,
    [72639] = true,
    [72640] = true,
    [72890] = true,
};

local UnitListVampireAlgorithm = {
    updateRate = 0.300,

    title = {
        ["default"] = "Vampire timers",
        ["frFR"] = "Timers vampire",
    },
    summary = {
        ["default"] = "|cffff2020Bloodthirst|r / |cff00ff00OK|r",
        ["frFR"] = "|cffff2020Soif de sang|r / |cff00ff00OK|r",
    },

    OnRefresh = function(self, driver, myTable)
        local i, guid, name, uid;
        local hasDebuff, timeLeft, unitTable;

        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            if ( uid ) then
                if ( UnitInParty(uid) or UnitInRaid(uid) ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitIsVisible(uid) ) then
                    local frenzy = false;
                    hasDebuff, timeLeft = Root.Unit.SearchEffect(uid, "DEBUFF", QUEEN_ESSENCE);
                    if ( not hasDebuff ) or ( not timeLeft ) then
                        frenzy = true;
                        hasDebuff, timeLeft = Root.Unit.SearchEffect(uid, "DEBUFF", BLOODTHIRST);
                    end
                    if ( hasDebuff ) then
                        unitTable = driver:Allocate();
                        unitTable.guid = guid;
                        unitTable.timeLeft = timeLeft;
                        unitTable.text = Root.FormatLoc("SecondFormat", timeLeft);
                        if ( not frenzy ) then
                            unitTable.r, unitTable.g, unitTable.b = 0.00, 1.00, 0.00;
                      else
                            unitTable.r, unitTable.g, unitTable.b = 1.00, 0.12, 0.12;
                        end
                        tinsert(myTable, unitTable);
                    end
                end
            end
        end

        Root.Sort.ByNumericField(myTable, "timeLeft", true);

        local title = Root.ReadLocTable(self.title);
        local summary = Root.ReadLocTable(self.summary);

        return title, summary;
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

        local data = self.data;

        data.biteRound = 0;
        data.pactList = {};

        data.title = self:Localize("Title");

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.90, 0.90, 0.95, 0.65, 1.00); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.80, 0.70, 0.80, 0.50, 0.90); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(320, true);

        Root.Music.Play("PREPARATION_BADGUY");

        self.UnitList:GetDriver():AssignAlgorithm(UnitListVampireAlgorithm);
        self.UnitList:Display();
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(180, 330);
        self:SetNearVictoryThreshold(0.15, 330-60, 0.90); -- Near Victory theme when the boss gets below 15%, the time left is above 1 minute and 90% of the raid is alive.

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_NAXXRAMAS_ENDWING"); -- Hooray!

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(320, true);

        if ( self.data.bossAlreadyFighting ) then return; end

        self.EventWatcher:GetDriver():AddEvent("InitialBite", 15, "AUTO", self:Localize("InitialBite"), "ALERT", self.OnInitialBite, self);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( pact[spellId] ) and ( targetGUID ) then
                    self:OnPact();
                    tinsert(self.data.pactList, targetGUID);
                end
                if ( shadows[spellId] ) and ( targetGUID ) then
                    self:OnShadows(targetGUID);
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    AlertPact = function(self)
        if ( #self.data.pactList == 1 ) then return; end
        if ( self:GetSetting("warnPact") ) then
            self:AnnounceUnitList(self.data.pactList, true, self:Localize("PactAlert"), 15.00);
        end
        local i, foundPlayer, other;
        foundPlayer = false;
        other = "???";
        for i=1, #self.data.pactList do
            if ( self.data.pactList[i] == UnitGUID("player") ) then
                foundPlayer = true;
          else
                other = self.data.pactList[i];
            end
        end
        if ( foundPlayer ) then
            if ( other ~= "???" ) then
                local uid = Root.Unit.GetUID(other);
                if ( uid ) then
                    other = UnitName(uid);
                end
            end
            self:AlertMe(self:FormatLoc("PactSelf", other), 0.400, 3.500);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnInitialBite = function(self)
        self.data.biteRound = 1;

        self:OnBite();
    end,

    OnBite = function(self)
        -- self.EventWatcher:GetDriver():TriggerEvent("Bite");

        if ( self.data.biteRound < 5 ) then
            self.data.biteRound = self.data.biteRound + 1;

            -- self.EventWatcher:GetDriver():AddEvent("Bite", 75, "AUTO", self:FormatLoc("Bite", self.data.biteRound), "WARNING", self.OnBite, self);
        end
    end,

    OnPact = function(self)
        if ( not self:EvaluateCooldown("pact", 5) ) then return; end

        self.EventWatcher:GetDriver():AddEvent("AlertPact", 0.250, "", "", "HIDDEN", self.AlertPact, self);

        wipe(self.data.pactList);
    end,

    OnShadows = function(self, guid)
        if guid == UnitGUID("player") then
            if ( not self:EvaluateCooldown("shadows", 5) ) then return; end

            self:AlertMe(self:Localize("ShadowsSelf"), 0.400, 7.000);
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(37955, THIS_MODULE, false);
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
