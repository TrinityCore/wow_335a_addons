local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Yogg-Saron Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Yogg-Saron fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["EngageTrigger"] = "The time to strike",
	["Phase2Trigger"] = "I am the lucid dream",
	["Phase3Trigger"] = "Look upon the true face",
        ["ClearTrigger"] = "Your fate is sealed.",
        ["PortalTrigger"] = "Portals open into",

        -- 2. Events
        ["InduceMadness"] = "Induce Madness",
        ["Portal"] = "Portal",
        ["Empower"] = "Empower",

        -- 3. Misc
        ["GetOut"] = "Get out through portal!",
        ["TurnAround"] = "Turn around!",
        ["MadnessAlert"] = ">> Induce Madness cast started. You have 60 sec! <<",
        ["BrainAlert"] = ">> Linked brains: <<",
        ["BrainSelf"] = "You are linked to |cffffff00%s|r!!",
        ["MaladyAlert"] = ">> {rt7} Malady of the Mind on %s! {rt7} <<",
        ["SqueezeAlert"] = ">> {rt6} %s has been grabbed! {rt6} <<",
        ["SqueezeInfo"] = "%s has been grabbed!",
        ["SqueezeSelf"] = "You have been grabbed!",
        ["Phase3"] = "Phase 3 starts",
    },
    ["frFR"] = {
        -- 1. Yells
        ["EngageTrigger"] = "Il sera bientôt temps de",
	["Phase2Trigger"] = "Je suis le rêve éveillé",
	["Phase3Trigger"] = "Contemplez le vrai visage de la mort",
        ["ClearTrigger"] = "Votre destin est scellé.",
        ["PortalTrigger"] = "Des portails s'ouvrent",

        -- 2. Events
        ["InduceMadness"] = "Susciter la folie",
        ["Portal"] = "Portail",
        ["Empower"] = "Renforcement",

        -- 3. Misc
        ["GetOut"] = "Sortez par le portail !",
        ["TurnAround"] = "Retournez-vous !",
        ["MadnessAlert"] = ">> Début de l'incantation de susciter la folie. Vous avez 60 sec ! <<",
        ["BrainAlert"] = ">> Cerveaux liés : <<",
        ["BrainSelf"] = "Vous êtes lié à |cffffff00%s|r !!",
        ["MaladyAlert"] = ">> {rt7} Mal de la raison sur %s ! {rt7} <<",
        ["SqueezeAlert"] = ">> {rt6} %s a été saisi(e) ! {rt6} <<",
        ["SqueezeInfo"] = "%s a été saisi !",
        ["SqueezeSelf"] = "Vous avez été saisi !",
        ["Phase3"] = "Début de la phase 3",
    },
};

local SANITY = GetSpellInfo(63050);

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnMadness",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Induce Madness",
            ["frFR"] = "Prévenir de Susciter la folie",
        },
        explain = {
            ["default"] = "Display a raid alert when Yogg-Saron's brain begins casting Induce Madness.",
            ["frFR"] = "Affiche une alerte de raid quand Yogg-Saron commence à incanter Susciter la folie.",
        },
    },
    [2] = {
        id = "warnBrainLink",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Brain Link",
            ["frFR"] = "Prévenir des cerveaux liés",
        },
        explain = {
            ["default"] = "Display a raid alert and put symbols on the characters that get Brain link debuff.",
            ["frFR"] = "Affiche une alerte de raid et place des symboles sur les personnes affectées par cerveaux liés.",
        },
    },
    [3] = {
        id = "warnMalady",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Malady of the Mind",
            ["frFR"] = "Prévenir de Mal de la raison",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on the character that gets Malady of the Mind debuff.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole sur la personne affectée par Mal de la raison.",
        },
    },
    [4] = {
        id = "warnSqueeze",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Squeeze",
            ["frFR"] = "Prévenir d'écrasement",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on characters that are grabbed by Constrictor Tentacles.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole sur les personnes attrapées par les tentacules constricteurs.",
        },
    },
    version = 3,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "YoggSaron";

local YOGGSARON_ID = 33288;
local BRAIN_ID     = 33890;
local SARA_ID      = 33134;

local INFLUENCE_TENTACLE_ID = 33943;

local healAssistList = {
    [63134] = 20, -- Sara
    [63147] = 12,

    [64157] = 12, -- Tentacles
    [64152] = 18,
    [64125] = 20, -- infinite duration
    [64126] = 20, -- infinite duration

    [64159] = 5, -- Immortal guardians
    [64160] = 5,
};

local SpecialBarSanityAlgorithm = {
    colors = {1.0, 0.0, 0.2}, -- R/G/B
    bounds = {0, 1}, -- min/max

    title = {
        ["default"] = "Sanity",
        ["frFR"] = "Santé mentale",
    },

    OnUpdate = function(self)
        local sanity = Root[THIS_MODULE]:GetSanityCount();

        -- Dynamically change the colors.
        local bright = 0;
        if ( sanity <= 30 ) then bright = math.abs(cos(GetTime()/0.350*90)) * 0.7; end

        self.colors[1] = math.min(1, 1 - (sanity / 100) + bright);  -- R
        self.colors[2] = math.min(1, (sanity / 100) + bright);      -- G
        self.colors[3] = bright;                                    -- B

        local title = Root.ReadLocTable(self.title);
        local text = sanity.."%";

        return title, text, sanity / 100;
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

        data.ignoreAdds = true;
        data.silentAddKills = true;
        data.ignoreStandardClear = true; -- Just in case.
        data.ignoreLeaveCombat = true;
        data.clearSequence = "FINAL";

        data.sanityCount = 100;
        data.brainGUID = nil;
        data.brainList = {};
        data.inMind = false;

        data.title = "Yogg-Saron";
        data.baseID = THIS_MODULE;

        self:ChangePhase(0, false);

        self:GrabStaticWidgets();

        self:SetDummyBossUnit("worldboss", 120, UnitAffectingCombat(uid));

        self:SetDifficultyMeter(0.65, 0.60, 0.40, 0.75, 0.80); -- P/B/A/C/S

        self:PrepareBasicWidgets(900, true);
        self.BossBar:Remove(true); -- Do not show the boss bar yet.

        Root.Music.Play("PREPARATION_BADGUY");

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("EngageTrigger"), self.OnEngaged, self);
        self:RegisterYellCallback("ANY", self:Localize("Phase2Trigger"), self.OnPhaseTwo, self);
        self:RegisterYellCallback("ANY", self:Localize("Phase3Trigger"), self.OnPhaseThree, self);
        self:RegisterYellCallback("ANY",  self:Localize("ClearTrigger"), self.OnCleared, self);
        self:RegisterYellCallback("ANY", self:Localize("PortalTrigger"), self.OnPortal, self);

        self:ResetAdds();
        self:RegisterAddEX(SARA_ID, false, "DISABLE");

        self:SearchUnit(YOGGSARON_ID, self.OnBossFound);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOut = 300;
        self.data.timeOutTimer = 0;

        self:ChangePhase(1, true);

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(900, true);
        self.TimerReminder:GetDriver():Clear(); -- No timer reminder for this fight. It's already used by the mind insane timer.

        Root.Music.Play("TIER8_FINALBOSS");

        self:SetScoreBenchmarks(420, 840);
        self:SetNearVictoryThreshold(0.075, 900-180, 0.70); -- Near Victory theme when the boss gets below 7.5%, there is at least 3 minutes left and 70% of the raid is alive.
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        if ( self.data.phase == 2 ) and ( not self.data.brainGUID ) then 
            -- Try to find the brain.
            local brainGUID = Root.Unit.GetGUIDFromMobID(BRAIN_ID);
            if ( brainGUID ) then
                local brainUID = Root.Unit.GetUID(brainGUID);
                if ( brainUID ) then
                    self:OnBrainFound(brainUID);
                end
            end
        end

        -- Check if the local player has targetted an influence tentacle or the mind.
        -- This means he is in the brain.

        if ( self.data.phase == 2 ) then
            local guid = UnitGUID("target");
            local id = Root.Unit.GetMobID(guid);
            if ( id == INFLUENCE_TENTACLE_ID ) or ( id == BRAIN_ID ) then
                if ( not self.data.inMind ) then
                    self:OnMindEntered();
                end
            end
        end

        Shared.OnUpdate(self, elapsed);
    end,

    OnCombatEvent = {
        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...)
            if ( self.running ) then
                if ( spellId == 64163 or spellId == 64164 or spellId == 64167 or spellId == 64168 ) and ( targetGUID == UnitGUID("player") ) then
                    self:OnGaze();
                end
            end
            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...);
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 64059 ) then
                    self:OnMadnessInit();
                end
                if ( spellId == 64465 ) then
                    self:OnEmpower();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 63050 ) and ( targetGUID == UnitGUID("player") ) then
                    self:OnSanityChange();
                end
                if ( spellId == 63042 ) and ( targetGUID ) then
                    self:OnDominateMind(targetGUID, targetName);
                end
                if ( spellId == 63881 or spellId == 63830 ) and ( targetGUID ) then
                    self:OnMalady(targetGUID, targetName);
                end
                if ( spellId == 63802 or spellId == 63803 ) and ( targetGUID ) then
                    self:OnBrain();
                    tinsert(self.data.brainList, targetGUID);
                    self:RegisterHealAssist(targetGUID, 0, 5, spellId);
                end
                if ( spellId == 64125 or spellId == 64126 ) and ( targetGUID ) then
                    self:OnSqueeze(targetGUID, targetName);
                end

                -- Show heal assist for various debuffs throughout the fight.
                local healAssistDuration = healAssistList[spellId];
                if ( healAssistDuration ) and ( targetGUID ) then
                    local uid = Root.Unit.GetUID(targetGUID);
                    if ( uid ) and ( not Root.IsBlacklisted(targetName) ) then
                        local ok = UnitInParty(uid) or UnitInRaid(uid) or false;
                        if ( ok ) then -- We do this check 'coz some debuffs can be cast on mobs.
                            self:RegisterHealAssist(targetGUID, 0, healAssistDuration, spellId);
                        end
                    end
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 63050 ) and ( targetGUID == UnitGUID("player") ) then
                    self:OnSanityChange();
                end
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    GetSanityCount = function(self)
        if ( not self.running ) then return 100; end
        return self.data.sanityCount;
    end,

    SchedulePortal = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Portal", timer, "AUTO", self:Localize("Portal"), "WARNING_NOREMINDER");
    end,

    ScheduleEmpower = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Empower", timer, "AUTO", self:Localize("Empower"), "WARNING");
    end,

    AlertBrain = function(self)
        if ( #self.data.brainList == 1 ) then return; end
        if ( self:GetSetting("warnBrainLink") ) then
            self:AnnounceUnitList(self.data.brainList, true, self:Localize("BrainAlert"), 30.00);
        end
        local i, foundPlayer, other;
        foundPlayer = false;
        other = "???";
        for i=1, #self.data.brainList do
            if ( self.data.brainList[i] == UnitGUID("player") ) then
                foundPlayer = true;
          else
                other = self.data.brainList[i];
            end
        end
        if ( foundPlayer ) then
            if ( other ~= "???" ) then
                local uid = Root.Unit.GetUID(other);
                if ( uid ) then
                    other = UnitName(uid);
                end
            end
            self:AlertMe(self:FormatLoc("BrainSelf", other), 0.400, 3.500);
        end
    end,

    StartGetOutTimer = function(self, timer)
        self.TimerReminder:GetDriver():Start(timer, 10, self:Localize("GetOut"));
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnBossFound = function(self, uid)
        self.data.name = UnitName(uid);
        self.data.guid = UnitGUID(uid);

        -- If Yogg-Saron is here, that means we are in P2 at least.
        self:OnPhaseTwo();
    end,

    OnPhaseTwo = function(self)
        if ( not self.running ) then return; end
        if ( self.data.phase >= 2 ) then return; end
        self:ChangePhase(2, true);

        self.data.timeOut = 120;
        self.data.timeOutTimer = 0;

        self:RemoveAddsWidgets();

        self:SchedulePortal(78); -- might be different in 25/10-man?
        -- self:SchedulePortal(62);
    end,

    OnPhaseThree = function(self)
        if ( not self.running ) then return; end
        if ( self.data.phase >= 3 ) then return; end
        self:ChangePhase(3, true);

        self.data.timeOut = 60;
        self.data.timeOutTimer = 0;

        self.BossBar:Display();
        self.BossBar:GetDriver():SetWatch(self.data.guid);

        self.EventWatcher:GetDriver():ClearEvent("InduceMadness");
        self.EventWatcher:GetDriver():ClearEvent("Portal");
        self.TimerReminder:GetDriver():Clear();

        self:ScheduleEmpower(46);

        self:ChangeMusic("HURRYUP");
    end,

    OnSanityChange = function(self)
        local found, timeLeft, count = Root.Unit.SearchEffect("player", "DEBUFF", SANITY);
        if ( found ) then
            count = max(1, count);
      else
            count = 0;
        end

        self.data.sanityCount = count;

        if ( count > 0 ) then
            self.SpecialBar:GetDriver():AssignAlgorithm(SpecialBarSanityAlgorithm);
            self.SpecialBar:Display();
      else
            self.SpecialBar:Remove();
        end
    end,

    OnBrainFound = function(self, uid)
        local guid = UnitGUID(uid);

        self.data.brainGUID = guid;

        self.BossBar:Display();
        self.BossBar:GetDriver():SetWatch(guid);
        self.BossBar:GetDriver():AddThreshold(0.30, self:Localize("Phase3"));
    end,

    OnMindEntered = function(self)
        self.data.inMind = true;

        local timeLeft = self.EventWatcher:GetDriver():GetEventTimer("InduceMadness");
        if ( timeLeft ) then
            self:StartGetOutTimer(timeLeft);
        end
    end,

    OnPortal = function(self)
        if ( self.data.phase ~= 2 ) then return; end

        self.data.inMind = false;

        self.EventWatcher:GetDriver():TriggerEvent("Portal");
        self:SchedulePortal(90);
    end,

    OnMadnessInit = function(self)
        if ( self:GetSetting("warnMadness") ) then
            self:AnnounceToRaid(self:Localize("MadnessAlert"));
        end
        self.EventWatcher:GetDriver():AddEvent("InduceMadness", 60, "AUTO", self:Localize("InduceMadness"), "NORMAL");
        if ( self.data.inMind ) then
            self:StartGetOutTimer(60);
        end
    end,

    OnEmpower = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Empower");
        self:ScheduleEmpower(46);
    end,

    OnGaze = function(self)
        if ( not self:EvaluateCooldown("gazeAlert", 5) ) then return; end

        self:AlertMe(self:Localize("TurnAround"), 0.250, 4.000);
    end,

    OnMalady = function(self, guid, name)
        if ( self:GetSetting("warnMalady") ) then
            self:AnnounceToRaid(self:FormatLoc("MaladyAlert", name));
            self:PlaceSymbol(guid, 7, 5.00);
        end
    end,

    OnBrain = function(self)
        if ( not self:EvaluateCooldown("brain", 15) ) then return; end

        self.EventWatcher:GetDriver():AddEvent("AlertBrain", 0.250, "", "", "HIDDEN", self.AlertBrain, self);

        wipe(self.data.brainList);
    end,

    OnSqueeze = function(self, guid, name)
        if ( self:GetSetting("warnSqueeze") ) then
            self:AnnounceToRaid(self:FormatLoc("SqueezeAlert", name));
            self:PlaceSymbol(guid, 6, 15.00);
        end
        if ( self:HasRole("DPS") and not self.data.inMind ) then
            if guid == UnitGUID("player") then
                self:AlertMe(self:Localize("SqueezeSelf"), 0.350, 4.000);
          else
                self:AlertMe(self:FormatLoc("SqueezeInfo", name), 0.350, 4.000);
            end
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(SARA_ID, THIS_MODULE, false, true); -- Bypass the friendly check.
    Root.NPCDatabase.Register(YOGGSARON_ID, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
