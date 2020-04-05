local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Grobbulus Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Grobbulus fight.

-- 25-man version:
-- Shorter berserk timer.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Infection"] = "You are infected!",

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Infection"] = "Vous êtes infecté !",

        -- 3. Misc
    },
};

local MUTATING_INJECTION = GetSpellInfo(28169);

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnRaidInfection",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Raid Injection",
            ["frFR"] = "Annoncer les injections sur le raid",
        },
        explain = {
            ["default"] = "Display raid alerts and put symbols on people that are infected.",
            ["frFR"] = "Affiche des alertes de raid et place des symboles sur les personnes infectées.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Grobbulus";

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
        local symbolAuth = Root.CheckAuth("SYMBOL") and Root[THIS_MODULE]:GetSetting("warnRaidInfection");
        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            if ( uid ) then
                if ( UnitInParty(uid) or UnitInRaid(uid) ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitIsVisible(uid) ) then
                    local hasDebuff, timeLeft = Root.Unit.SearchEffect(uid, "DEBUFF", MUTATING_INJECTION);
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
                        if ( GetRaidTargetIndex(uid) ~= 0 ) then
                            SetRaidTarget(uid, 0);
                        end
                    end
                end
            end
        end
        Root.Sort.ByNumericField(myTable, "timeLeft", true);
        if ( symbolAuth ) then
            local targetSet;
            local alertMessage = "";
            local frequency = 5.0;
            if ( Root[THIS_MODULE].data ) then
                local bossUID = Root.Unit.GetUID(Root[THIS_MODULE].data.guid);
                if ( bossUID ) then
                    frequency = 1.5 + 3.5 * (UnitHealth(bossUID) / UnitHealthMax(bossUID));
                end
            end
            for i=1, #myTable do
                targetSet = 9-i;
                uid = Root.Unit.GetUID(myTable[i].guid);
                if ( GetRaidTargetIndex(uid) ~= targetSet ) then
                    SetRaidTarget(uid, targetSet);
                end
                local name = UnitName(uid);
                if name then
                    alertMessage = alertMessage .. string.format("{rt%d} %s (%d s)", targetSet, name, myTable[i].timeLeft);
                    if ( i < #myTable ) then
                        alertMessage = alertMessage .. " || ";
                    end
                end
            end
            if ( #alertMessage > 0 ) and (GetTime() - (self.lastAlert or 0)) > frequency then
                self.lastAlert = GetTime();
                Root[THIS_MODULE]:AnnounceToRaid(string.format(">> %s <<", alertMessage));
            end
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

        data.berserkTimer = 720;
        if ( Root.GetInstanceMode() == "HEROIC" ) then data.berserkTimer = 540; end
        data.ignoreCombatDelay = true;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.25, 0.20, 0.10, 0.35, 0.30); -- P/B/A/C/S

        self:PrepareBasicWidgets(data.berserkTimer, false);

        self.UnitList:GetDriver():AssignAlgorithm(UnitListDebuffAlgorithm);
        self.UnitList:Display();
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(self.data.berserkTimer/2, self.data.berserkTimer);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER7_SURVIVAL2");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(self.data.berserkTimer, false);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 28169 ) and ( targetGUID ) then
                if ( targetGUID == UnitGUID("player") ) then
                    self:OnLocalPlayerInjection();
                end
                self:RegisterHealAssist(targetGUID, 8, 12, nil);
            end
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    OnLocalPlayerInjection = function(self)
        self:AlertMe(self:Localize("Infection"), 0.750, 4.000);
    end,

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
    Root.NPCDatabase.Register(15931, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
