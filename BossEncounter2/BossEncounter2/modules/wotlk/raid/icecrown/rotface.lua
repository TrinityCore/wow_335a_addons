local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Rotface Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Rotface fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events

        -- 3. Misc
        ["InfectionSelf"] = "You are infected!",
        ["SprayAlert"] = ">> Slime Spray incoming! <<",
        ["BombingAlert"] = "Bombing incoming!!",
        ["BombingExplain"] = "Move out of the area!",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events

        -- 3. Misc
        ["InfectionSelf"] = "Vous êtes infecté !",
        ["SprayAlert"] = ">> Projection de gelée ! <<",
        ["BombingAlert"] = "Bombardement !!",
        ["BombingExplain"] = "Sortez du périmètre !",
    },
};

local MUTATED_INFECTION = GetSpellInfo(71224);

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "symbolRaidInfection",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Symbols: Infections",
            ["frFR"] = "Symboles : infections",
        },
        explain = {
            ["default"] = "Put symbols on people who are infected.",
            ["frFR"] = "Place des symboles sur les personnes infectées.",
        },
    },
    [2] = {
        id = "warnRaidInfection",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Alerts: Infections",
            ["frFR"] = "Alertes : infections",
        },
        explain = {
            ["default"] = "Tell who is infected.",
            ["frFR"] = "Indique qui est infecté.",
        },
    },
    [3] = {
        id = "warnSlimeSpray",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Announce Slime Sprays",
            ["frFR"] = "Annoncer les projections de gelée",
        },
        explain = {
            ["default"] = "Display a raid alert whenever the boss starts casting Slime Spray.",
            ["frFR"] = "Affiche une alerte de raid chaque fois que le boss incante Projection de gelée.",
        },
    },
    version = 2,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Rotface";

local infection = {
    [69674] = true,
    [71224] = true,
    [73022] = true,
    [73023] = true,
};

local explosion = {
    [69832] = true,
    [69833] = true,
    [69839] = true,
    [71209] = true,
    [73029] = true,
    [73030] = true,
};

local UnitListDebuffAlgorithm = {
    updateRate = 0.300,
    lastAlert = 0,

    title = {
        ["default"] = "People infected",
        ["frFR"] = "Personnes infectées",
    },
    summary = {
        ["default"] = "Total number: |cffff4000%d|r",
        ["frFR"] = "Nombre total: |cffff4000%d|r",
    },

    OnRefresh = function(self, driver, myTable)
        local i, guid, name, uid;
        local symbolAuth = Root.CheckAuth("SYMBOL") and Root[THIS_MODULE]:GetSetting("symbolRaidInfection");
        local warningAuth = Root.CheckAuth("WARNING") and Root[THIS_MODULE]:GetSetting("warnRaidInfection");
        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            if ( uid ) then
                if ( UnitInParty(uid) or UnitInRaid(uid) ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitIsVisible(uid) ) then
                    local hasDebuff, timeLeft = Root.Unit.SearchEffect(uid, "DEBUFF", MUTATED_INFECTION);
                    if ( hasDebuff ) then
                        -- This unit has the infection debuff.
                        local unitTable = driver:Allocate();
                        unitTable.guid = guid;
                        unitTable.timeLeft = timeLeft;
                        unitTable.text = Root.FormatLoc("SecondFormat", timeLeft);
                        unitTable.r = 1.00;
                        unitTable.g = 0.25;
                        unitTable.b = 0.00;
                        tinsert(myTable, unitTable);

                  elseif ( symbolAuth ) then
                        if ( (GetRaidTargetIndex(uid) or 0) > 6 ) then
                            SetRaidTarget(uid, 0);
                        end
                    end
                end
            end
        end
        Root.Sort.ByNumericField(myTable, "timeLeft", true);

        local targetSet;
        local alertMessage = "";

        local frequency = 5.0;
        if ( Root[THIS_MODULE].data ) then
            local bossUID = Root.Unit.GetUID(Root[THIS_MODULE].data.guid);
            if ( bossUID ) then
                frequency = 2.0 + 3.0 * (UnitHealth(bossUID) / UnitHealthMax(bossUID)) ^ 2;
            end
        end

        for i=1, #myTable do
            uid = Root.Unit.GetUID(myTable[i].guid);
            symbol = GetRaidTargetIndex(uid) or 0;

            if ( symbolAuth ) then
                targetSet = 9-i;

                if ( symbol ~= targetSet ) and ( symbol > 6 or symbol == 0 ) then
                    SetRaidTarget(uid, targetSet);
                end
          else
                targetSet = 0;
            end

            local name = UnitName(uid);
            if name then
                if ( targetSet > 0 ) then
                    alertMessage = alertMessage .. string.format("{rt%d} %s (%d s)", targetSet, name, myTable[i].timeLeft);
              else
                    alertMessage = alertMessage .. string.format("%s (%d s)", name, myTable[i].timeLeft);
                end
                if ( i < #myTable ) then
                    alertMessage = alertMessage .. " || ";
                end
            end
        end
        if ( warningAuth ) and ( #alertMessage > 0 ) and (GetTime() - (self.lastAlert or 0)) > frequency then
            self.lastAlert = GetTime();
            Root[THIS_MODULE]:AnnounceToRaid(string.format(">> %s <<", alertMessage));
        end

        local title = Root.ReadLocTable(self.title);
        local summary = string.format(Root.ReadLocTable(self.summary), #myTable);
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

        data.explosionList = { };

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.75, 0.65, 0.65, 1.00, 0.80); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.50, 0.50, 0.50, 0.90, 0.80); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(nil, false);

        Root.Music.Play("PREPARATION_GENERAL");

        self.UnitList:GetDriver():AssignAlgorithm(UnitListDebuffAlgorithm);
        self.UnitList:Display();
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(240, 360);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER8_SURVIVAL2");

        self.StatusFrame:GetDriver():StartTiming();
        -- self.StatusFrame:GetDriver():Resume();
        -- self:ScheduleBerserk(300, false);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                self:CheckExplosion(guid);
            end
            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( infection[spellId] ) and ( targetGUID ) then
                    if ( targetGUID == UnitGUID("player") ) then
                        self:OnLocalPlayerInfection();
                    end
                    self:RegisterHealAssist(targetGUID, 0, 12, spellId);
                end
            end
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 69508 ) then
                    self:OnSlimeSpray();
                end
                if ( explosion[spellId] ) then
                    self:OnExplosionPrepare(actorGUID);
                end
            end
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    CheckExplosion = function(self, guid)
        if ( not self.running ) then return; end
        if ( not self.data.explosionList[guid] ) then return; end
        if ( not self:EvaluateCooldown("explosion", 5) ) then return; end
        self.data.explosionList[guid] = false;

        -- Ooze bombing incoming!

        self:SuperAlert(4.5, self:Localize("BombingAlert"), self:Localize("BombingExplain"), false, true);
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnLocalPlayerInfection = function(self)
        self:AlertMe(self:Localize("InfectionSelf"), 0.500, 5.000);
    end,

    OnSlimeSpray = function(self)
        if ( self:GetSetting("warnSlimeSpray") ) then
            self:AnnounceToRaid(self:Localize("SprayAlert"));
        end
    end,

    OnExplosionPrepare = function(self, guid)
        if ( not self.running ) then return; end
        self.data.explosionList[guid] = true;
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(36627, THIS_MODULE, false);
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
