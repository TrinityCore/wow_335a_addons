local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Sapphiron Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Sapphiron fight.

-- 25-man version:
-- Less iceblocks.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["TakeOffWarning"] = "take off", -- ???
        ["BreathWarning"] = "deep breath",
        ["LandingWarning"] = "attack",

        -- 2. Events
        ["TakeOff"] = "Take off",
        ["Breath"] = "Breath",

        -- 3. Misc
        ["IceboltMessage"] = "WARNING! Iceblock on >> %s <<",
        ["TakeOffDenied"] = "Sapphiron will no longer take off !",
        ["TakeCover"] = "Take cover !",
    },
    ["frFR"] = {
        -- 1. Yells
        ["TakeOffWarning"] = "s'envole",
        ["BreathWarning"] = "inspire",
        ["LandingWarning"] = "reprend",

        -- 2. Events
        ["TakeOff"] = "Décollage",
        ["Breath"] = "Souffle",

        -- 3. Misc
        ["IceboltMessage"] = "ATTENTION! Bloc de givre sur >> %s <<",
        ["TakeOffDenied"] = "Saphiron ne décollera plus !",
        ["TakeCover"] = "Mettez-vous à couvert !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnFreeze",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Freeze",
            ["frFR"] = "Annoncer les gels",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol each time a raid member gets frozen prior the Breath.",
            ["frFR"] = "Affiche une alerte de raid et place un signe chaque fois qu'un membre du raid se fait geler avant un souffle.",
        },
    },
    [2] = {
        id = "breathCountdown",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Breath Countdown",
            ["frFR"] = "Compte à rebours du souffle",
        },
        explain = {
            ["default"] = "Display a countdown whenever a Breath is about to occur.",
            ["frFR"] = "Affiche un compte à rebours pour les souffles.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Sapphiron";

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

        data.currentSymbolSlot = 8;
        data.lastBreathDigit = 0;
        data.noTakeOff = false;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.50, 0.50, 0.40, 0.15, 0.25); -- P/B/A/C/S

        self:PrepareBasicWidgets(900, true);

        Root.Music.Play("PREPARATION_DUNGEON");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(300, 600);
        self:SetNearVictoryThreshold(0.10, 900-180, 0.70); -- Near Victory theme when the boss gets below 10%, the time left is above 3 minutes and 70% of the raid is alive.

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_NAXXRAMAS_ENDWING");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(900, true);
        self.TimerReminder:GetDriver():Clear(); -- No timer reminder for this fight. It will be used for breath timer.

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("TakeOffWarning"), self.OnTakeOff, self);
        self:RegisterYellCallback(nil, self:Localize("BreathWarning"), self.OnBreath, self);
        self:RegisterYellCallback(nil, self:Localize("LandingWarning"), self.OnLanding, self);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.10, nil, self.TakeOffDenied, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleTakeOff(50);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        local breathTimer = self.EventWatcher:GetDriver():GetEventTimer("Breath");
        if ( breathTimer and Root.CheckAuth("WARNING") and self:GetSetting("breathCountdown") ) then
            local breathDigit = math.floor(breathTimer);
            if ( breathDigit ~= self.data.lastBreathDigit ) then
                self.data.lastBreathDigit = breathDigit;
                if ( breathDigit >= 1 and breathDigit <= 9 ) then
                    self:AnnounceToRaid(breathDigit);
                end
            end
        end

        Shared.OnUpdate(self, elapsed);
    end,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 28522 ) and ( targetGUID ) and ( targetName ) then
                    self:OnIcebolt(targetGUID, targetName);
                end
                if ( spellId == 28542 or spellId == 55665 ) and ( targetGUID ) then
                    self:RegisterHealAssist(targetGUID, 0, 10, spellId);
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleTakeOff = function(self, timer)
        if ( not self.running ) then return; end
        if ( self.data.noTakeOff ) then return; end

        self.EventWatcher:GetDriver():AddEvent("TakeOff", timer, "AUTO", self:Localize("TakeOff"), "WARNING_NOREMINDER");  
    end,

    ScheduleBreath = function(self, timer)
        self.TimerReminder:GetDriver():Start(timer, timer, self:Localize("TakeCover"));
        self.EventWatcher:GetDriver():AddEvent("Breath", timer, "AUTO", self:Localize("Breath"), "NORMAL");
        self.EventWatcher:GetDriver():AddEvent("CleanUp", timer+3, "", "", "HIDDEN", self.ResetSymbols, self);
    end,

    ResetSymbols = function(self)
        self:ClearSymbols();
        self.data.currentSymbolSlot = 8;
        self.data.lastBreathDigit = 0;
    end,

    TakeOffDenied = function(self)
        if ( not self.running ) then return; end
        if ( self.data.noTakeOff ) then return; end

        self.data.noTakeOff = true;
        self.EventWatcher:GetDriver():ClearEvent("TakeOff");
        self:NotifyMe(self:Localize("TakeOffDenied"));
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnTakeOff = function(self)
        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 10, 3);
    end,

    OnBreath = function(self)
        self.UnitList:Remove();
        self.UnitList:GetDriver():Clear();

        self:ScheduleBreath(10);
    end,

    OnLanding = function(self)
        self:ScheduleTakeOff(65);
    end,

    OnIcebolt = function(self, guid, name)
        if ( self:GetSetting("warnFreeze") ) then
            self:AnnounceToRaid(self:FormatLoc("IceboltMessage", name));

            self:PlaceSymbol(guid, self.data.currentSymbolSlot);
            self.data.currentSymbolSlot = self.data.currentSymbolSlot - 1;
        end

        if ( guid == UnitGUID("player") ) then
            Minimap:PingLocation();
        end

        self:RegisterHealAssist(guid, 12, 22, 28522);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(15989, THIS_MODULE, true);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
