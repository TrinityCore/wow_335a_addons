local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Deathwhisper Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Deathwhisper fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Adds"] = "Minions",
        ["Dominate"] = "Dominate",

        -- 3. Misc
        ["Title"] = "Deathwhisper",
        ["MCAlert"] = ">> Dominated: <<",
        ["DNDSelf"] = "Get out of the AoE!",
        ["SelfDestructAlert"] = ">> {rt7} is going to blow up! (%s) <<",
        ["SelfDestructSelf"] = "%s is gonna blow up!",
        ["GhostSelf"] = "A ghost is probably pursuing you!",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Adds"] = "Laquais",
        ["Dominate"] = "Domination",

        -- 3. Misc
        ["Title"] = "Murmemort",
        ["MCAlert"] = ">> Dominé : <<",
        ["DNDSelf"] = "Sortez de la zone !",
        ["SelfDestructAlert"] = ">> {rt7} va exploser ! (%s) <<",
        ["SelfDestructSelf"] = "%s va exploser !",
        ["GhostSelf"] = "Un fantôme vous poursuit probablement !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnDominateMind",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Dominate Mind",
            ["frFR"] = "Annoncer dominer l'esprit",
        },
        explain = {
            ["default"] = "Allows you to display a raid alert and put symbols on players who get mind controlled.",
            ["frFR"] = "Permet d'afficher une alerte de raid et de placer des symboles sur les joueurs qui subissent le contrôle mental.",
        },
    },
    [2] = {
        id = "warnMartyrdom",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Dark Martyrdom",
            ["frFR"] = "Annoncer sombre martyre",
        },
        explain = {
            ["default"] = "Allows you to display a raid alert and put symbols on Cult Adherents that are about to explode.",
            ["frFR"] = "Permet d'afficher une alerte de raid et de placer des symboles sur les adhérents du culte qui sont sur le point d'exploser.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Deathwhisper";

local BOSS_ID = 36855;

local dnd = {
    [71001] = true,
    [72108] = true,
    [72109] = true,
    [72110] = true,
};

local selfDestruct = {
    [70903] = true,
    [71236] = true,
    [72495] = true,
    [72496] = true,
    [72497] = true,
    [72498] = true,
    [72499] = true,
    [72500] = true,
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

        self:SetBossUnit(uid, 90);
        data.classification = "worldboss"; -- Hack (for some reason Deathwhisper is not considered a boss).

        data.title = self:Localize("Title");
        data.MCList = {};
        data.myThreatSituation = 0;
        data.addsInterval = 60;

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.75, 0.85, 0.65, 0.60, 0.65); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.50, 0.60, 0.40, 0.25, 0.35); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(600, true);

        Root.Music.Play("PREPARATION_GENERAL");

        self.AddWindow:Display(); -- Display Deathwhisper mana through AddWindow.
        self.AddWindow:GetDriver():AssignAlgorithm("MP");
        self.AddWindow:GetDriver():AddUnit(data.guid, nil, nil, "AUTO");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self.data.addsInterval = 45;
      else
            self.data.addsInterval = 60;
        end
        
        self:SetScoreBenchmarks(300, 600);

        self:ChangePhase(1, true);

        Root.Music.Play("TIER9_SURVIVAL2");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(600, true);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.95, nil, self.OnPhaseTwo, self); -- Kept in case of (good for disconnects).

        self:CheckThreat();

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleAdds(7.5);

        if self:GetFormatCode() ~= "10N" then
            self:ScheduleDominate(30);
        end
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( selfDestruct[spellId] ) and ( actorGUID ) and ( actorName ) then
                    self:OnSelfDestruct(actorGUID, actorName);
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 71289 ) and ( targetGUID ) and ( targetName ) then
                    self:OnDominateMind();
                    tinsert(self.data.MCList, targetGUID);
                end
                if ( dnd[spellId] ) and ( targetGUID ) then
                    if ( targetGUID == UnitGUID("player") ) then
                        self:OnDND();
                    end
                    self:RegisterHealAssist(targetGUID, 0, 2, nil);
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 70842 ) then
                self:OnPhaseTwo();
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    AlertMC = function(self)
        if ( self:GetSetting("warnDominateMind") ) then
            self:AnnounceUnitList(self.data.MCList, true, self:Localize("MCAlert"), 10.00);
        end
    end,

    ScheduleAdds = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Adds", timer, "AUTO", self:Localize("Adds"), "WARNING", self.OnAdds, self);
    end,

    ScheduleDominate = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Dominate", timer, "AUTO", self:Localize("Dominate"), "WARNING");
    end,

    CheckThreat = function(self)
        self.EventWatcher:GetDriver():AddEvent("CheckThreat", 0.5, "", "", "HIDDEN", self.CheckThreat, self);

        local threatSituation = UnitThreatSituation("player") or 0;
        if ( threatSituation ~= self.data.myThreatSituation ) then
            if ( threatSituation == 3 ) then
                -- Check the aggro is not from the boss.

                if ( not self:HasBossAggro("player") ) then
                    -- Okay, if we are in phase 2 this probably means a ghost is against us.

                    if ( self.data.phase == 2 ) then
                        if ( not self:EvaluateCooldown("ghost", 5) ) then return; end

                        self:AlertMe(self:Localize("GhostSelf"), 0.500, 4.000);
                    end
                end
            end
            self.data.myThreatSituation = threatSituation;
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnAdds = function(self)
        self:ScheduleAdds(self.data.addsInterval);
    end,

    OnPhaseTwo = function(self)
        if ( self.data.phase == 2 ) then return; end
        self:ChangePhase(2, true);

        self.EventWatcher:GetDriver():ClearEvent("Adds");
    end,

    OnDominateMind = function(self)
        if ( not self:EvaluateCooldown("mc", 5) ) then return; end

        self.EventWatcher:GetDriver():TriggerEvent("Dominate");
        self:ScheduleDominate(40);

        self.EventWatcher:GetDriver():AddEvent("AlertMC", 0.150, "", "", "HIDDEN", self.AlertMC, self);

        wipe(self.data.MCList);
    end,

    OnDND = function(self)
        self:AlertMe(self:Localize("DNDSelf"), 0.400, 2.500);
    end,

    OnSelfDestruct = function(self, guid, name)
        local uid = Root.Unit.GetUID(guid);
        if ( uid ) then
            if ( self:GetSetting("warnMartyrdom") ) then
                self:AnnounceToRaid(self:FormatLoc("SelfDestructAlert", name));
                self:PlaceSymbol(guid, 7);
            end
            if ( Root.GetDistance(uid) > 15 ) then return; end
        end
        self:AlertMe(self:FormatLoc("SelfDestructSelf", name), 0.250, 4.000);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(BOSS_ID, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
