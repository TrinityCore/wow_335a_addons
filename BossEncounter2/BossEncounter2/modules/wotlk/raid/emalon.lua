local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Emalon Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Emalon fight.

-- 25-man version:
-- No change.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Overcharge"] = "Overcharge",

        -- 3. Misc
        ["OverchargedAlertNoSymbol"] = ">> A minion is overcharged ! (no symbol) <<",
        ["OverchargedAlert"] = ">> {rt%d} is overcharged ! <<",
        ["OverchargeSoon"] = ">> Get ready, Overcharge soon !! <<",
        ["LightningNovaAlert"] = "Lightning nova incoming !",
        ["FocusAlert"] = "Focus the right minion !",
        ["NovaAlert"] = ">> Nova ! <<",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Overcharge"] = "Surcharge",

        -- 3. Misc
        ["OverchargedAlertNoSymbol"] = ">> Un séide est en surcharge ! (pas de symbole) <<",
        ["OverchargedAlert"] = ">> {rt%d} est en surcharge ! <<",
        ["OverchargeSoon"] = ">> Préparez-vous, Surcharge bientôt !! <<",
        ["LightningNovaAlert"] = "Nova en incantation !",
        ["FocusAlert"] = "Attaquez le bon séide !",
        ["NovaAlert"] = ">> Nova ! <<",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnOverchargedMinion",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Overcharged minion",
            ["frFR"] = "Annoncer le séide surchargé",
        },
        explain = {
            ["default"] = "Display an alert and put the skull symbol whenever Emalon overcharges a minion. A pre-emptive warning will also be displayed.",
            ["frFR"] = "Affiche une alerte et place le symbole crâne quand un séide est surchargé par Emalon. Une annonce préventive sera également affichée.",
        },
    },
    [2] = {
        id = "warnNova",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Nova",
            ["frFR"] = "Annoncer la nova",
        },
        explain = {
            ["default"] = "Display a raid warning when the boss casts his nova.",
            ["frFR"] = "Affiche un avertissement de raid quand le boss incante sa nova.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Emalon";

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

        self:SetBossUnit(uid);

        data.title = "Emalon";
        data.overchargedGUID = nil;

        self:SetDifficultyMeter(0.35, 0.35, 0.25, 0.15, 0.35); -- P/B/A/C/S

        self:PrepareBasicWidgets(360, true);

        Root.Music.Play("PREPARATION_GENERAL");

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 10, 4);

        self:SetStrictRelevance(true);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(180, 300);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_MADNESS");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(360, true);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleOvercharge(45);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["HEAL"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...)
            if ( self.running ) and ( spellId == 64218 ) and ( targetGUID ) then
                self:OnOverchargedMinion(targetGUID);
            end
            Shared.OnCombatEvent["HEAL"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...);
        end,
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( spellId == 64216 or spellId == 65279 ) then
                self:OnLightningNova();
            end
        end,
        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                if ( self.data.overchargedGUID == guid ) then
                    self:OnOverchargedMinionDeath();
                end
            end
            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleOvercharge = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Overcharge", timer, "AUTO", self:Localize("Overcharge"), self:IfRole("OFFENSIVE", "WARNING_NOREMINDER", "NORMAL"));
        if ( self:GetSetting("warnOverchargedMinion") ) then
            self.EventWatcher:GetDriver():AddEvent("OverchargeAlert", timer-7, "", "", "HIDDEN", self.AnnounceToRaid, self, self:Localize("OverchargeSoon"));
        end
    end,

    PlaceSymbolOnMinion = function(self, guid, try)
        local uid = Root.Unit.GetUID(guid);
        if ( uid ) then
            self:PlaceSymbol(uid, 8);
            self:AnnounceToRaid(self:FormatLoc("OverchargedAlert", 8));
      elseif ( try < 200 ) then
            self.EventWatcher:GetDriver():AddEvent("CheckSymbol", 0.05, "", "", "HIDDEN", self.PlaceSymbolOnMinion, self, guid, try+1);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnOverchargedMinion = function(self, guid)
        if ( not self.running ) then return; end
        if ( not self:EvaluateCooldown("overcharge", 15) ) then return; end
        self.data.overchargedGUID = guid;

        self:AlertMe(self:Localize("FocusAlert"), 0.300, 5.000);

        self.EventWatcher:GetDriver():TriggerEvent("Overcharge");
        self.EventWatcher:GetDriver():ClearEvent("OverchargeAlert");
        self:ScheduleOvercharge(45);
        self.EventWatcher:GetDriver():AddEvent("Boom", 20, "AUTO", "BOOM !", "ALERT");

        if ( self:GetSetting("warnOverchargedMinion") ) then
            self:PlaceSymbolOnMinion(guid, 1);
        end

        self.AddWindow:Display();
        self.AddWindow:GetDriver():AddUnit(guid);

        self:AddRelevantTargets(guid);
    end,

    OnOverchargedMinionDeath = function(self)
        self.data.overchargedGUID = nil;
        self.EventWatcher:GetDriver():ClearEvent("CheckSymbol");

        local timeLeft = self.EventWatcher:GetDriver():GetEventTimer("Boom") or 0;
        if ( timeLeft <= 1 ) then
            self.EventWatcher:GetDriver():TriggerEvent("Boom"); -- Probably exploded.
      else
            self.EventWatcher:GetDriver():ClearEvent("Boom"); -- Did not explode.
        end

        self.AddWindow:Remove();
        self.AddWindow:GetDriver():Clear();
    end,

    OnLightningNova = function(self)
        if ( not self.running ) then return; end
        if ( self:GetSetting("warnNova") ) then
            self:AnnounceToRaid(self:Localize("NovaAlert"));
        end
        local distance = self:GetDistance(self.data.guid);
        if ( distance ) and ( not self:HasRole("MELEE") ) then
            if ( distance > 25 ) then return; end
        end
        self:AlertMe(self:Localize("LightningNovaAlert"), 0.500, 3.000);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(33993, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
