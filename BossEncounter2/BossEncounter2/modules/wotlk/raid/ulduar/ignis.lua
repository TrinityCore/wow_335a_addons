local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Ignis Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Ignis fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Construct"] = "Construct",
        ["FlameJets"] = "Flame Jets",
        ["SlagPot"] = "Slag Pot",
        ["SlagPotEnd"] = "Slag Pot: end",

        -- 3. Misc
        ["ConstructCount"] = "Const. %d",
        ["FlameJetsAlert"] = "Stop casting !",
        ["SlagPotAlert"] = ">> {rt7} %s in the Slag Pot ! {rt7} <<",
        ["BrittleAlert"] = ">> A construct is ready to be shattered ! <<",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Construct"] = "Assemblage",
        ["FlameJets"] = "Flots de flammes",
        ["SlagPot"] = "Marmite",
        ["SlagPotEnd"] = "Marmite: fin",

        -- 3. Misc
        ["ConstructCount"] = "Assem. %d",
        ["FlameJetsAlert"] = "Arrêtez d'incanter !",
        ["SlagPotAlert"] = ">> {rt7} %s dans la marmite ! {rt7} <<",
        ["BrittleAlert"] = ">> Un assemblage est prêt à être brisé ! <<",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnSlagPot",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Slag Pot",
            ["frFR"] = "Annoncer la Marmite !",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on the character put into the Slag Pot.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole sur la personne qui est envoyée dans la marmite de scories.",
        },
    },
    [2] = {
        id = "warnBrittle",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Brittle",
            ["frFR"] = "Annoncer Fragile",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol when a construct is ready to be shattered.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole quand un assemblage est prêt à être détruit.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Ignis";

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

        data.constructCount = 0;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        data.title = "Ignis";

        self:SetDifficultyMeter(0.45, 0.55, 0.30, 0.05, 0.45); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);

        self:SetStrictRelevance(true);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(270, 540);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER8_TANKNSPANK2");

        self.StatusFrame:GetDriver():StartTiming();

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleConstruct(10);
        self:ScheduleFlameJets(22);
        -- self:ScheduleSlagPot(0);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 62717 or spellId == 63477 ) then
                    self:OnSlagPot(targetGUID, targetName);
                end
                if ( spellId == 62382 ) or ( spellId == 67114 ) then
                    self:OnBrittle(targetGUID);
                end
            end
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 62488 ) then -- Same spellId for both versions.
                    self:OnConstructSpawned();
                end
                if ( spellId == 62680 or spellId == 63472 ) then
                    self:OnFlameJets();
                end
            end
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    GetConstructTimer = function(self)
        if ( Root.GetInstanceMode() == "HEROIC" ) then return 30; end
        return 40;
    end,

    ScheduleConstruct = function(self, timer) -- Timer optionnal
        self.EventWatcher:GetDriver():AddEvent("Construct", timer or self:GetConstructTimer(), "AUTO", self:Localize("Construct"), self:IfRole("TANK", "WARNING", "NORMAL"));
    end,

    ScheduleFlameJets = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("FlameJets", timer, "AUTO", self:Localize("FlameJets"), self:IfRole("CASTER", "WARNING_NOREMINDER", "NORMAL"));
    end,

    ScheduleSlagPot = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("SlagPot", timer, "AUTO", self:Localize("SlagPot"), "WARNING");
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnConstructSpawned = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Construct");
        self:ScheduleConstruct();

        self.data.constructCount = self.data.constructCount + 1;
        self.StatusFrame:SetStatus("TEXT", self:FormatLoc("ConstructCount", self.data.constructCount), true);
    end,

    OnBrittle = function(self, guid)
        if ( self:GetSetting("warnBrittle") ) then
            self:AnnounceToRaid(self:Localize("BrittleAlert"));
            self:PlaceSymbol(guid, 8);
        end

        self:AddRelevantTargets(guid);
        self.EventWatcher:GetDriver():AddEvent("RevokeDamageCount", 10, "", "", "HIDDEN", self.RemoveRelevantTargets, self, guid);
    end,

    OnFlameJets = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("FlameJets");
        self:ScheduleFlameJets(26);

        if ( self:HasRole("CASTER") ) then
            self:AlertMe(self:Localize("FlameJetsAlert"), 0.400, 3.500);
        end
    end,

    OnSlagPot = function(self, guid, name)
        self.EventWatcher:GetDriver():TriggerEvent("SlagPot");
        -- self:ScheduleSlagPot(0);

        self.EventWatcher:GetDriver():AddEvent("SlagPotEnd", 10, "AUTO", self:Localize("SlagPotEnd"), self:IfRole("HEALER", "WARNING", "NORMAL"));

        if ( self:GetSetting("warnSlagPot") ) and ( not Root.IsBlacklisted(name) ) then
            self:AnnounceToRaid(self:FormatLoc("SlagPotAlert", name));
            self:PlaceSymbol(guid, 7, 12.00);
        end

        self:RegisterHealAssist(guid, 0, 10, {62717, 63477});
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(33118, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
