local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Vezax Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Vezax fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["VaporTrigger"] = "A cloud of saronite vapors",

        -- 2. Events
        ["Vapor"] = "Crystal %d/%d",
        ["Surge"] = "Surge Darkness",
        ["SurgeEnd"] = "Surge Darkness: end",

        -- 3. Misc
        ["VaporCount"] = "Cryst. %d",
        ["SurgeAlert"] = "Run away from the boss !",
        ["MarkSelf"] = "You have the Mark of the Faceless !!",
        ["MarkAlert"] = ">> {rt7} %s has the Mark of the Faceless ! {rt7} <<",
        ["CrashSelf"] = "|cffff4040Get moving !|r",
        ["CrashAlert"] = ">> {rt8} Shadow Crash on %s ! {rt8} <<",
        ["GoAway"] = "Stay away from the others !",
    },
    ["frFR"] = {
        -- 1. Yells
        ["VaporTrigger"] = "Un nuage",

        -- 2. Events
        ["Vapor"] = "Cristal %d/%d",
        ["Surge"] = "Vague ténèbres",
        ["SurgeEnd"] = "Vague ténèbres: fin",

        -- 3. Misc
        ["VaporCount"] = "Crist. %d",
        ["SurgeAlert"] = "Eloignez-vous du boss !",
        ["MarkSelf"] = "Vous avez la marque du Sans-visage !!",
        ["MarkAlert"] = ">> {rt7} %s a la marque du Sans-visage ! {rt7} <<",
        ["CrashSelf"] = "|cffff4040Déplacez-vous !|r",
        ["CrashAlert"] = ">> {rt8} Déferlante d'ombre sur %s ! {rt8} <<",
        ["GoAway"] = "Eloignez-vous des autres !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "surgeOfDarknessAlert",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Warn me of Surge of Darkness",
            ["frFR"] = "Me prévenir de Vague de ténèbres",
        },
        explain = {
            ["default"] = "Display a personnal alert whenever the boss gains Surge of Darkness. It is recommanded that the tank enables this option.",
            ["frFR"] = "Affiche une alerte personnelle chaque fois que le boss gagne Vague de ténèbres. Il est recommandé au tank d'activer cette option.",
        },
    },
    [2] = {
        id = "warnMark",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Mark of the Faceless",
            ["frFR"] = "Annoncer la marque du Sans-visage",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on the character that gets the Mark of the Faceless.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole sur la personne qui obtient la marque du Sans-visage.",
        },
    },
    [3] = {
        id = "warnShadowCrash",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Shadow Crash",
            ["frFR"] = "Annoncer la Déferlante d'ombre",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on the target of Shadow Crash.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole sur le personnage ciblé par la Déferlante d'ombre.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Vezax";

local ANIMUS_ID = 33524;

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

        data.currentVapor = 0;
        data.ignoreAdds = true;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.60, 0.65, 0.45, 0.25, 0.45); -- P/B/A/C/S

        self:PrepareBasicWidgets(600, true);

        self:ResetAdds();

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 15, 5);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(360, 600);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER8_TANKNSPANK2");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(600, true);
        self.TimerReminder:GetDriver():Clear(); -- No timer reminder for this fight. It's already used by the mark timer.

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("VaporTrigger"), self.OnSaroniteVapors, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleSaroniteVapors(30);
        self:ScheduleSurge(60);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 62662 ) then
                    self:OnSurgeOfDarkness();
                end
                if ( spellId == 63145 ) then
                    self:OnHardMode();
                end
            end
        end,
        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 63276 ) then
                    self:OnMark(targetGUID, targetName);
                end
                if ( spellId == 60835 or spellId == 62660 ) then
                    self.EventWatcher:GetDriver():AddEvent("ScanShadowCrash", 0.10, "", "", "HIDDEN", self.ScanShadowCrash, self);
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleSurge = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Surge", timer, "AUTO", self:Localize("Surge"), self:IfRole("SHIELD", "WARNING", "NORMAL"));
    end,

    ScheduleSaroniteVapors = function(self, timer)
        local id = self.data.currentVapor + 1;
        if ( id > 6 ) then return; end
        self.data.currentVapor = id;
        self.EventWatcher:GetDriver():AddEvent("Vapor", timer, "AUTO", self:FormatLoc("Vapor", id, 6), "WARNING");
    end,

    ScanShadowCrash = function(self)
        local bossTargetGUID, bossTargetName = self:GetTargetInfo();
        if ( bossTargetGUID and bossTargetName ) then
            self:OnShadowCrash(bossTargetGUID, bossTargetName);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnHardMode = function(self)
        self:AlertMe(self:Localize("HardModeTrigger"));
        self:ChangeMusic("THEME_MADNESS");
        self:RegisterAddEX(ANIMUS_ID, false, "DISABLE");
    end,

    OnSurgeOfDarkness = function(self)
        if ( self:GetSetting("surgeOfDarknessAlert") ) then
            self:AlertMe(self:Localize("SurgeAlert"), 0.400, 3.000);
        end
        self.EventWatcher:GetDriver():AddEvent("SurgeEnd", 13, "AUTO", self:Localize("SurgeEnd"), self:IfRole("TANK", "WARNING", "NORMAL"));
        self.EventWatcher:GetDriver():TriggerEvent("Surge");
        self:ScheduleSurge(60);
    end,

    OnSaroniteVapors = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Vapor");
        self.StatusFrame:SetStatus("TEXT", self:FormatLoc("VaporCount", self.data.currentVapor), true);
        self:ScheduleSaroniteVapors(30);
    end,

    OnMark = function(self, guid, name)
        if ( guid == UnitGUID("player") ) then
            -- self:SuperAlert(10, self:Localize("MarkSelf"), self:Localize("GoAway"), false, true);
            self:AlertMe(self:Localize("MarkSelf"), 0.400, 8.000);
        end
        if ( self:GetSetting("warnMark") ) then
            self:AnnounceToRaid(self:FormatLoc("MarkAlert", name));
            self:PlaceSymbol(guid, 7, 10.00);
        end
    end,

    OnShadowCrash = function(self, guid, name)
        if ( guid == UnitGUID("player") ) then
            self:AlertMe(self:Localize("CrashSelf"), 0.400, 8.000);
      else
            local distance = self:GetDistance(guid);
            if ( distance ) and ( distance <= 10 ) then
                 self:AlertMe(self:Localize("CrashSelf"), 0.400, 8.000);
            end
        end
        if ( self:GetSetting("warnShadowCrash") ) then
            self:AnnounceToRaid(self:FormatLoc("CrashAlert", name));
            self:PlaceSymbol(guid, 8, 4.00);
        end
        self:RegisterHealAssist(guid, 2.5, 5, nil);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(33271, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
