local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Thorim Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Thorim fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["AggroTrigger"] = "Interlopers|I remember you.",
        ["PhaseTwoTrigger"] = "Impertinent whelps",
        ["HardModeOffTrigger"] = "pitiful mortals",
        ["ClearTrigger"] = "Stay your arms",

        -- 2. Events
        ["HardModeDisabled"] = "Hard mode OFF",

        -- 3. Misc
        ["ColossusDeath"] = ">> The Colossus is dead ! (1/2) <<",
        ["GiantDeath"] = ">> The Giant is dead ! (2/2) <<",
        ["UnbalancingStrikeAlert"] = ">> %s has Unbalancing Strike debuff !! <<",
        ["BarrierAlert"] = "Do not melee for a while !!",
        ["DetonationSelf"] = "You have the bomb !!",
        ["DetonationOther"] = "%s has the bomb !!",
        ["GoAway"] = "Go away from %s !",
    },
    ["frFR"] = {
        -- 1. Yells
        ["AggroTrigger"] = "Des intrus|Je me souviens de vous.",
        ["PhaseTwoTrigger"] = "Avortons impertinents",
        ["HardModeOffTrigger"] = "Ces pitoyables mortels sont inoffensifs",
        ["ClearTrigger"] = "Retenez vos coups",

        -- 2. Events
        ["HardModeDisabled"] = "Mode difficile OFF",

        -- 3. Misc
        ["ColossusDeath"] = ">> Le Colosse est mort ! (1/2) <<",
        ["GiantDeath"] = ">> Le Géant est mort ! (2/2) <<",
        ["UnbalancingStrikeAlert"] = ">> %s subit Frappe déséquilibrante !! <<",
        ["BarrierAlert"] = "Arrêtez le CàC pendant un instant !!",
        ["DetonationSelf"] = "Vous avez la bombe !!",
        ["DetonationOther"] = "%s a la bombe !!",
        ["GoAway"] = "Eloignez-vous |2 %s !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnAddDeath",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn mini-boss deaths",
            ["frFR"] = "Annoncer les morts des mini-boss",
        },
        explain = {
            ["default"] = "Display a raid alert each time a mini-boss dies.",
            ["frFR"] = "Affiche une alerte de raid chaque fois qu'un mini-boss meurt.",
        },
    },
    [2] = {
        id = "warnUnbalancingStrike",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Unbalancing Strike",
            ["frFR"] = "Annoncer Frappe déséquilibrante",
        },
        explain = {
            ["default"] = "Display a raid alert each time Thorim does an Unbalancing Strike.",
            ["frFR"] = "Affiche une alerte de raid chaque fois que Thorim effectue une Frappe déséquilibrante.",
        },
    },
    [3] = {
        id = "detonationSymbol",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = false,
        label = {
            ["default"] = "Symbol: Rune Detonation",
            ["frFR"] = "Symbole: Détonation runique",
        },
        explain = {
            ["default"] = "Put the skull symbol on the target of the Rune Detonation.",
            ["frFR"] = "Place le symbole crâne sur la cible de la Détonation runique.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Thorim";

local THORIM_ID = 32865;
local SIF_ID = 33196;

local COLOSSUS_ID = 32872;
local GIANT_ID = 32873;

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

        data.ignoreAdds = true;
        data.ignoreLeaveCombat = true;
        data.ignoreAddsEngage = true;
        data.clearAnimation = "ALTERNATE";

        self:GrabStaticWidgets();

        self:SetBossUnit(uid, 360);

        self:SetDifficultyMeter(0.65, 0.55, 0.50, 0.55, 0.75); -- P/B/A/C/S

        self:PrepareBasicWidgets(375, true);
        self.BossBar:Remove(true); -- Do not show the boss bar yet.

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("AggroTrigger"), self.OnEngaged, self);
        self:RegisterYellCallback("ANY", self:Localize("PhaseTwoTrigger"), self.OnPhaseTwo, self);
        self:RegisterYellCallback("ANY", self:Localize("HardModeOffTrigger"), self.OnHardModeDisabled, self);
        self:RegisterYellCallback("ANY", self:Localize("ClearTrigger"), self.OnCleared, self);

        Root.Music.Play("PREPARATION_GENERAL");

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 10);

        self:ResetAdds();
        self:RegisterAddEX(COLOSSUS_ID, false, "DISABLE");
        self:RegisterAddEX(GIANT_ID, false, "DISABLE");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";

        self:SetScoreBenchmarks(360, 660);
        self:SetNearVictoryThreshold(0.125, nil, 0.70); -- Near Victory theme when the boss gets below 12.5% and 70% of the raid is alive.

        -- self.StatusFrame:GetDriver():StartTiming();

        if ( self.data.bossAlreadyFighting ) then
             -- Already fighting when the module was triggered.
             self.data.hardMode = false;
             self:OnPhaseTwo();
      else
             -- Normal engage after the aggro yell.
             self.data.hardMode = true; -- We got the engage yell. We can see when hard mode is about to expire.
             self:OnPhaseOne();
        end
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate, 

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 62130 ) and ( targetGUID ) and ( targetName ) then
                    self:OnUnbalancingStrike(targetGUID, targetName);
                end
                if ( spellId == 62338 ) and ( targetGUID ) then
                    self:OnBarrier(targetGUID);
                end
                if ( spellId == 62526 ) and ( targetGUID ) and ( targetName ) then
                    self:OnDetonation(targetGUID, targetName);
                end
            end
        end,

        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                if ( self:GetSetting("warnAddDeath") ) then
                    local id = Root.Unit.GetMobID(guid);
                    if ( id == COLOSSUS_ID ) then
                        self:AnnounceToRaid(self:Localize("ColossusDeath"));
                    end
                    if ( id == GIANT_ID ) then
                        self:AnnounceToRaid(self:Localize("GiantDeath"));
                    end
                end
            end

            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                       Special handlers                         **
    -- --------------------------------------------------------------------

    OnPhaseOne = function(self)
        if ( self.data.phase == 1 ) then return; end
        self:ChangePhase(1, true);

        self.data.timeOut = 360;
        self.data.timeOutTimer = 0;

        Root.Music.Play("THEME_EASY");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(375, true);
        self.TimerReminder:GetDriver():Clear(); -- No timer reminder for this fight. It's already used by the bomb timer.

        self.EventWatcher:GetDriver():AddEvent("HardModeDisabled", 175, "AUTO", self:Localize("HardModeDisabled"), "WARNING");
    end,

    OnPhaseTwo = function(self)
        if ( self.data.phase == 2 ) then return; end
        self:ChangePhase(2, true);

        self.data.timeOut = 60;
        self.data.timeOutTimer = 0;

        self.BossBar:Display();

        -- Disable add bars.
        self:RemoveAddsWidgets();

        -- Check for hard mode.
        self.EventWatcher:GetDriver():ClearEvent("HardModeDisabled");
        if ( self.data.hardMode ) then
            self:AlertMe(self:Localize("HardModeTrigger"));
            Root.Music.Play("THEME_MADNESS");
      else
            Root.Music.Play("HURRYUP");
        end

        -- Berserk timer disabled.
        self.StatusFrame:GetDriver():Pause();
        self.EventWatcher:GetDriver():ClearEvent("Berserk");
        self.data.lastMinuteTimer = 0;

        self.EventWatcher:Remove();
    end,

    OnHardModeDisabled = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("HardModeDisabled");
        self.EventWatcher:Remove();
        self.data.hardMode = false;
    end,

    OnUnbalancingStrike = function(self, guid, name)
        if ( self:GetSetting("warnUnbalancingStrike") ) then
            self:AnnounceToRaid(self:FormatLoc("UnbalancingStrikeAlert", name));
        end
        self:RegisterHealAssist(guid, 0, 7.5, 62130);
    end,

    OnBarrier = function(self, colossusGUID)
        local uid = Root.Unit.GetUID(colossusGUID);
        if ( uid ) then
            if ( Root.GetDistance(uid) <= 20 ) and ( self:HasRole("MELEE") ) then
                self:AlertMe(self:Localize("BarrierAlert"), 0.400, 4.000);
            end
        end
    end,

    OnDetonation = function(self, guid, name)
        if ( guid == UnitGUID("player") ) then
            self:AlertMe(self:Localize("DetonationSelf"), 0.400, 3.000);
      else
            local uid = Root.Unit.GetUID(guid);
            if ( uid ) then
                if ( Root.GetDistance(uid) <= 30 ) then
                    self:AlertMe(self:FormatLoc("DetonationOther", name), 0.400, 3.000);
                    self.TimerReminder:GetDriver():Start(4, 5, self:FormatLoc("GoAway", name));
                end
            end
        end
        if ( self:GetSetting("detonationSymbol") ) then
            self:PlaceSymbol(guid, 8, 4.00);
        end
        self:RegisterHealAssist(guid, 4, 6, nil);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(THORIM_ID, THIS_MODULE, true);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
