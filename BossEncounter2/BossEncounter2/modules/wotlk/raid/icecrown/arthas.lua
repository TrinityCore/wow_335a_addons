local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

local Distance = Root.GetOrNewModule("Distance");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- The Lich King (Arthas) Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Arthas fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["IntroTrigger"] = "vaunted justice has finally arrived",

        -- 2. Events
        ["FinalPhase"] = "Final Phase",
        ["Transition"] = "Transition %d",
        ["Quake"] = "Quake",
        ["RagingSpirit"] = "Raging Spirit",
        ["Plague"] = "Necrotic Plague",
        ["Infest"] = "Infest",
        ["Horror"] = "Horror",
        ["Valkyr"] = "Val'kyr",
        ["VileSpirits"] = "Vile Spirits enabled",
        ["HarvestSoul"] = "Harvest Soul",
        ["SoulReaper"] = "Soul Reaper",
        ["Defile"] = "Defile",

        -- 3. Misc
        ["Title"] = "The Lich King",
        ["Start"] = "Start of combat",
        ["RemorselessWinterAlert"] = "Remorseless Winter incoming!",
        ["QuakeAlert"] = "Quake incoming!",
        ["PlagueAlert"] = ">> {rt7} Necrotic Plague: %s {rt7} <<",
        ["PlagueSelf"] = "You have the Necrotic Plague!",
        ["EnrageAlert"] = ">> %s is enraged! <<",
        ["HarvestSoulAlert"] = ">> {rt7} Harvest Soul: %s {rt7} <<",
        ["SoulReaperWarning"] = "Soul Reaper incoming!",
        ["DefileTickSelf"] = "Get out of the area!",
        ["DefileSelf"] = "Defile on you!",
        ["DefileSay"] = "Defile here!",
        ["DefileNear"] = "Defile nearby!",
    },
    ["frFR"] = {
        -- 1. Yells
        ["IntroTrigger"] = "arrive la fameuse", -- TODO: check!

        -- 2. Events
        ["FinalPhase"] = "Phase finale",
        ["Transition"] = "Transition %d",
        ["Quake"] = "Secousse",
        ["RagingSpirit"] = "Esprit déchaîné",
        ["Plague"] = "Peste nécrotique",
        ["Infest"] = "Infester",
        ["Horror"] = "Horreur",
        ["Valkyr"] = "Val'kyr",
        ["VileSpirits"] = "Esprits vils actifs",
        ["HarvestSoul"] = "Moisson d'âmes",
        ["SoulReaper"] = "Faucheur",
        ["Defile"] = "Profanation",

        -- 3. Misc
        ["Title"] = "Le Roi Liche",
        ["Start"] = "Début du combat",
        ["RemorselessWinterAlert"] = "Hiver impitoyable imminent !",
        ["QuakeAlert"] = "Secousse imminente !",
        ["PlagueAlert"] = ">> {rt7} Peste nécrotique: %s {rt7} <<",
        ["PlagueSelf"] = "Vous avez la peste nécrotique !",
        ["EnrageAlert"] = ">> %s enrage ! <<",
        ["HarvestSoulAlert"] = ">> {rt7} Moisson d'âmes : %s {rt7} <<",
        ["SoulReaperWarning"] = "Faucheur imminent !",
        ["DefileTickSelf"] = "Sortez de la zone !",
        ["DefileSelf"] = "Profanation sur vous !",
        ["DefileSay"] = "Profanation ici !",
        ["DefileNear"] = "Profanation à proximité !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnPlague",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Necrotic Plague",
            ["frFR"] = "Annoncer la peste nécrotique",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol whenever a raid member gets the Necrotic Plague.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole chaque fois qu'un membre du raid obtient la peste nécrotique.",
        },
    },

    [2] = {
        id = "warnHarvestSoul",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Harvest Soul",
            ["frFR"] = "Annoncer la moisson d'âmes",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on the target of Harvest Soul.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole sur la cible de moisson d'âmes.",
        },
    },

    [3] = {
        id = "warnEnrage",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Enrage",
            ["frFR"] = "Annoncer l'enrager",
        },
        explain = {
            ["default"] = "Display a raid alert whenever a Shambling Horror enrages.",
            ["frFR"] = "Affiche une alerte de raid chaque fois qu'une horreur titubante devient enragée.",
        },
    },

    [4] = {
        id = "defileSymbol",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Symbol: Defile",
            ["frFR"] = "Symbole : profanation",
        },
        explain = {
            ["default"] = "Put a symbol on the target of Defile.",
            ["frFR"] = "Place un symbole sur la cible de profanation.",
        },
    },

    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Arthas";

local necroticPlague = {
    [70337] = true,
    [70338] = true,
    [73785] = true,
    [73786] = true,
    [73787] = true,
    [73912] = true,
    [73913] = true,
    [73914] = true,
};

local winter = {
    [68981] = true,
    [72259] = true,
    [74270] = true,
    [74273] = true,
};

local enrage = {
    [72143] = true,
    [72146] = true,
    [72147] = true,
    [72148] = true,
};

local infest = {
    [70541] = true,
    [73779] = true,
    [73780] = true,
    [73781] = true,
};

local harvest = {
    [68980] = true,
    [74325] = true,
    [74326] = true,
    [74327] = true,
};

local soulReaper = {
    [69409] = true,
    [73797] = true,
    [73798] = true,
    [73799] = true,
};

local defile = {
    [72754] = true,
    [73708] = true,
    [73709] = true,
    [73710] = true,
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

        data.title = self:Localize("Title");
        data.clearSequence = "FINAL";

        self:SetBossUnit(uid, 180);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(1.00, 1.00, 1.00, 1.00, 1.00); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(1.00, 1.00, 1.00, 1.00, 1.00); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(900, true);

        self:ChangePhase(0, false);

        Root.Music.Play("PREPARATION_BADGUY");

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("IntroTrigger"), self.OnIntro, self);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.70, self:FormatLoc("Transition", 1));
        self:RegisterHealthThreshold(0.40, self:FormatLoc("Transition", 2));
        self:RegisterHealthThreshold(0.10, self:FormatLoc("Transition", 3));

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 10, nil);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(720, 1200);
        self:SetNearVictoryThreshold(0.075, nil, nil); -- Near Victory theme when the boss gets below 7.5%.

        self:ChangeMusic("THEME_NAXXRAMAS_ENDWING");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(900, true);

        self:OnPhaseOne(self.data.bossAlreadyFighting);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, ...)
            if ( self.running ) then
                if ( defile[spellId] ) and ( targetGUID ) then
                    self:OnDefileDamage(targetGUID);
                end
            end
            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, ...);
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 72350 ) then
                    self:OnPhaseFour();
                end
                if ( spellId == 72262 ) then
                    self:OnQuake();
                end
                if ( winter[spellId] ) then
                    self:OnRemorselessWinter();
                end
                if ( infest[spellId] ) then
                    self:OnInfest();
                end
                if ( spellId == 70498 ) then
                    self:OnVileSpirits();
                end
                if ( spellId == 72762 ) then
                    self:OnDefileCast();
                end
            end
        end,

        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( necroticPlague[spellId] ) and ( targetGUID ) and ( targetName ) then
                    self:OnPlague(targetGUID, targetName);
                end
                if ( spellId == 69200 ) and ( targetGUID ) and ( targetName ) then
                    self:OnRagingSpirit(targetGUID, targetName);
                end
                if ( harvest[spellId] ) and ( targetGUID ) and ( targetName ) then
                    self:OnHarvestSoul(targetGUID, targetName);
                end
                if ( soulReaper[spellId] ) and ( targetGUID ) and ( targetName ) then
                    self:OnSoulReaper(targetGUID, targetName);
                end
            end
        end,

        ["SUMMON"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 70372 ) then
                    self:OnHorrorSpawned();
                end
                if ( spellId == 69037 ) then
                    self:OnValkyrSpawned();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( enrage[spellId] ) and ( targetGUID ) and ( targetName ) then
                    self:OnEnrage(targetGUID, targetName);
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    SchedulePlague = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Plague", timer, "AUTO", self:Localize("Plague"), "WARNING");
    end,

    ScheduleRagingSpirit = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("RagingSpirit", timer, "AUTO", self:Localize("RagingSpirit"), "WARNING");
    end,

    ScheduleInfest = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Infest", timer, "AUTO", self:Localize("Infest"), self:IfRole("HEALER", "ALERT", "WARNING"));
    end,

    ScheduleHorror = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Horror", timer, "AUTO", self:Localize("Horror"), "WARNING");
    end,

    ScheduleValkyr = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Valkyr", timer, "AUTO", self:Localize("Valkyr"), "WARNING");
    end,

    ScheduleHarvestSoul = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("HarvestSoul", timer, "AUTO", self:Localize("HarvestSoul"), "WARNING");
    end,

    ScheduleSoulReaper = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("SoulReaper", timer, "AUTO", self:Localize("SoulReaper"), self:IfRole("SHIELD", "WARNING", "NORMAL"));
    end,

    ScheduleDefile = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Defile", timer, "AUTO", self:Localize("Defile"), "WARNING");
    end,

    FinishingPhase = function(self)
        self.EventWatcher:GetDriver():ClearEvent("Infest");
        self.EventWatcher:GetDriver():ClearEvent("Reaper");
        self.EventWatcher:GetDriver():ClearEvent("Defile");

        if ( self.data.phase == 1 ) then
            self.EventWatcher:GetDriver():ClearEvent("Plague");
            self.EventWatcher:GetDriver():ClearEvent("Horror");

    elseif ( self.data.phase == 2 ) then
            self.EventWatcher:GetDriver():ClearEvent("Valkyr");
        end

        self.EventWatcher:GetDriver():AddEvent("Quake", 60, "AUTO", self:Localize("Quake"), "WARNING_NOREMINDER");
        self:ScheduleRagingSpirit(15);
    end,

    AdvancePhase = function(self)
        self:ScheduleDefile(30);

        self.EventWatcher:GetDriver():TriggerEvent("Quake");
        self.EventWatcher:GetDriver():ClearEvent("RagingSpirit");

        if ( self.data.phase == 1 ) then
            self:OnPhaseTwo();

    elseif ( self.data.phase == 2 ) then
            self:OnPhaseThree();
        end
    end,

    ScanDefile = function(self)
        local guid, name, uid = self:GetTargetInfo();
        if ( guid and uid ) then
            if ( self:GetSetting("defileSymbol") ) then
                self:PlaceSymbol(guid, 6, 5.00);
            end
            if ( guid == UnitGUID("player") ) then
                self:AlertMe(self:Localize("DefileSelf"), 0.200, 2.500);
                Root.Say(self:Localize("DefileSay"), false, "SAY");
          else
                if ( Distance:Get("player", uid) <= 15 ) then
                    self:AlertMe(self:Localize("DefileNear"), 0.200, 2.500);
                end
            end
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    -- Flow control

    OnIntro = function(self)
        self:ChangeMusic("SILENCE");
        self.StatusFrame:SetStatus("TEXT", self:Localize("Introduction"), true);
        self.EventWatcher:GetDriver():AddEvent("Start", 53, "AUTO", self:Localize("Start"), "NORMAL");
    end,

    OnPhaseOne = function(self, alreadyEngaged)
        if ( self.data.phase >= 1 ) then return; end
        self:ChangePhase(1, true);

        self.EventWatcher:GetDriver():TriggerEvent("Start");

        if ( alreadyEngaged ) then return; end

        self:SchedulePlague(31);
    end,

    OnPhaseTwo = function(self)
        if ( self.data.phase >= 2 ) then return; end
        self:ChangePhase(2, true);

        self.data.timeOutTimer = 0;

        self:ChangeMusic("TIER9_FINALBOSS");

        self:ScheduleInfest(13);
        self:ScheduleValkyr(24);
    end,

    OnPhaseThree = function(self)
        if ( self.data.phase >= 3 ) then return; end
        self:ChangePhase(3, true);

        self.data.timeOutTimer = 0;

        self:ScheduleHarvestSoul(12);
    end,

    OnPhaseFour = function(self)
        if ( self.data.phase >= 4 ) then return; end
        self:ChangePhase(4, true);

        -- Temporarily disallows interruption of the boss module
        self.data.timeOutTimer = 0;
        self.data.ignoreWipe = true;
        self.data.ignoreLeaveCombat = true;
        self.data.lastMinuteTimer = 0;

        -- Stop berserk + timers.
        self.StatusFrame:GetDriver():Pause();
        self.TimerReminder:GetDriver():Clear();
        self.EventWatcher:GetDriver():ClearAllEvents();
        self.EventWatcher:Remove();
        self.UnitList:Remove();
        self.UnitList:GetDriver():Clear();

        Root.Music.Play("SILENCE");

        self.EventWatcher:GetDriver():AddEvent("FinalPhase", 160, "AUTO", self:Localize("FinalPhase"), "ALERT");
    end,

    -- Handlers

    OnRemorselessWinter = function(self)
        self:FinishingPhase();

        self:AlertMe(self:Localize("RemorselessWinterAlert"), 0.400, 3.000);
    end,

    OnQuake = function(self)
        self:AlertMe(self:Localize("QuakeAlert"), 0.400, 3.000);

        self:AdvancePhase();
    end,

    OnRagingSpirit = function(self, guid, name)
        self.EventWatcher:GetDriver():TriggerEvent("RagingSpirit");
        self:ScheduleRagingSpirit(23);

        -- TODO
    end,

    OnPlague = function(self, guid, name)
        self.EventWatcher:GetDriver():TriggerEvent("Plague");
        self:SchedulePlague(30);

        if ( UnitGUID("player") == guid ) then
            self:AlertMe(self:Localize("PlagueSelf"), 0.300, 3.000);
        end

        if ( self:GetSetting("warnPlague") and self:IsUnitAffiliated(guid) ) then
            self:AnnounceToRaid(self:FormatLoc("PlagueAlert", name));
            self:PlaceSymbol(guid, 7, 4.00);
        end
    end,

    OnEnrage = function(self, guid, name)
        if ( self:GetSetting("warnEnrage") ) then
            self:AnnounceToRaid(self:FormatLoc("EnrageAlert", name));
        end
    end,

    OnInfest = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Infest");
        self:ScheduleInfest(22);
    end,

    OnHorrorSpawned = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Horror");
        self:ScheduleHorror(60);
    end,

    OnValkyrSpawned = function(self)
        if ( not self:EvaluateCooldown("valkyr", 5) ) then return; end

        self.EventWatcher:GetDriver():TriggerEvent("Valkyr");
        self:ScheduleValkyr(47);
    end,

    OnVileSpirits = function(self)
        self.EventWatcher:GetDriver():AddEvent("VileSpirits", 25.0, "AUTO", self:Localize("VileSpirits"), "ALERT");
    end,

    OnHarvestSoul = function(self, guid, name)
        self.EventWatcher:GetDriver():TriggerEvent("HarvestSoul");
        self:ScheduleHarvestSoul(75);

        self:RegisterHealAssist(guid, 0, 5);

        if ( self:GetSetting("warnHarvestSoul") ) then
            self:AnnounceToRaid(self:FormatLoc("HarvestSoulAlert", name));
            self:PlaceSymbol(guid, 7, 5.00);
        end
    end,

    OnSoulReaper = function(self, guid, name)
        self.EventWatcher:GetDriver():TriggerEvent("SoulReaper");
        self:ScheduleSoulReaper(30);

        self:RegisterHealAssist(guid, 4, 5);

        if ( self:HasRole("SHIELD") ) then
            self:AlertMe(self:Localize("SoulReaperWarning"), 0.400, 3.000);
        end
    end,

    OnDefileCast = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Defile");
        self:ScheduleDefile(32);

        self.EventWatcher:GetDriver():AddEvent("ScanDefile", 0.150, "", "", "HIDDEN", self.ScanDefile, self);
    end,

    OnDefileDamage = function(self, guid)
        self:RegisterHealAssist(guid, 0, 2);

        if ( UnitGUID("player") == guid ) then
            if ( not self:EvaluateCooldown("defile", 2) ) then return; end
            self:AlertMe(self:Localize("DefileTickSelf"), 0.100, 1.500);
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(36597, THIS_MODULE, true);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
