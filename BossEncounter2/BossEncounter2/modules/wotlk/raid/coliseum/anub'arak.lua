local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");
local EncounterStats = Root.GetOrNewModule("EncounterStats");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Anub'arak Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Anub'arak fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["BurrowWarning"] = "burrows into the ground",
        ["BurrowEndWarning"] = "emerges from the ground",

        -- 2. Events
        ["Burrow"] = "Submerge",
        ["BurrowEnd"] = "Submerge: End",
        ["Swarm"] = "Swarm gets summoned",

        -- 3. Misc
        ["IcyDepths"] = "The Icy Depths",
        ["PursuedAlert"] = ">> {rt7} Anub'arak target: %s {rt7} <<",
        ["PursuedSelf"] = "You are pursued by Anub'arak !",
        ["Kick-Waterwalking"] = "%s has been kicked from the raid for casting Water Walking on someone else in this zone.",
        ["Kick-PathOfFrost"] = "%s has been kicked from the raid for enabling Path of Frost in this zone.",
        ["Kick-PathOfFrostAll"] = "All deathknights have been kicked from the raid as one of them has enabled Path of Frost in this zone.",
        ["Kick-PathOfFrostAllPreventive"] = "All deathknights have been preventively kicked from the raid: they are not trusted.",
        ["SphereCount"] = "%d/%d Orbs",
    },
    ["frFR"] = {
        -- 1. Yells
        ["BurrowWarning"] = "s'enfonce dans le sol",
        ["BurrowEndWarning"] = "surgit de la terre",

        -- 2. Events
        ["Burrow"] = "Submerger",
        ["BurrowEnd"] = "Submerger: fin",
        ["Swarm"] = "Invocation de l'essaim",

        -- 3. Misc
        ["IcyDepths"] = "Les Profondeurs glacées",
        ["PursuedAlert"] = ">> {rt7} Cible d'Anub'arak: %s {rt7} <<",
        ["PursuedSelf"] = "Vous êtes poursuivi par Anub'arak !",
        ["Kick-Waterwalking"] = "%s a été renvoyé(e) du raid pour avoir placé Marche sur l'eau sur quelqu'un d'autre dans cette zone.",
        ["Kick-PathOfFrost"] = "%s a été renvoyé(e) du raid pour avoir activé Passage de givre dans cette zone.",
        ["Kick-PathOfFrostAll"] = "Tous les chevaliers de la mort ont été renvoyés du raid car l'un d'entre eux a activé Passage de givre dans cette zone.",
        ["Kick-PathOfFrostAllPreventive"] = "Tous les chevaliers de la mort ont été préventivement renvoyés du raid par manque de confiance.",
        ["SphereCount"] = "%d/%d orbes",
    },
};

local WATER_WALKING = GetSpellInfo(546);
local PATH_OF_FROST = GetSpellInfo(3714);

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnTarget",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn new target",
            ["frFR"] = "Annoncer les nouvelles cibles",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol when Anub'arak switches his target.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole chaque fois qu'Anub'arak change de cible.",
        },
    },
    [2] = {
        id = "preventFallAbuse",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = true,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Prevent fall abuses",
            ["frFR"] = "Prévenir les abus sur la chute",
        },
        explain = {
            ["default"] = [[Kick any person on the raid who tries to perform one of the following actions:
- Shaman casting Water Walking on someone else.
- Deathknight enabling Path of Frost.

Remark: all deathknights will be kicked from the raid if a Path of Frost aura is already active when the boss module triggers.]],
            ["frFR"] = [[Supprime du raid toute personne qui tente d'effectuer l'une des actions suivantes:
- Chaman lançant Marche sur l'eau sur quelqu'un d'autre.
- Chevalier de la mort activant Passage de givre.

Remarque: tous les chevaliers de la mort seront supprimés du raid si une aura Passage de givre est déjà active quand le module de boss s'enclenche.]],
        },
    },
    [3] = {
        id = "notTrusted",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = false,
        label = {
            ["default"] = "Preventive kick",
            ["frFR"] = "Renvoi préventif",
        },
        explain = {
            ["default"] = "Enable this to kick pre-emptively all deathknights from the raid when falling into the Icy Depths... This only occurs for the 1st boss attempt.",
            ["frFR"] = "Activer ceci pour renvoyer préventivement du raid tous les chevaliers de la mort durant la chute dans les Profondeurs glacées... Cela ne se produit que pour le 1er essai sur le boss.",
        },
    },
    version = 2,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Anub'arak";

local BOSS_ID = 34564;

local SPHERE_ID = 34606;
local NUM_SPHERES = 6;

local leechingSwarmSpells = {
    [66118] = true,
    [66125] = true,
    [67630] = true,
    [68647] = true,
    [68646] = true,
};

local penCold = {
    [66013] = true,
    [67700] = true,
    [68509] = true,
    [68510] = true,
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

    OnTrigger = function(self)
        if not self:TriggerMe() then return; end

        local data = self.data;

        data.ignoreLeaveCombat = true;
        data.clearSequence = "FINAL";
        data.kickDecision = {};
        data.title = "Anub'arak";
        data.baseID = THIS_MODULE;
        data.spheres = 0;
        data.clearLockdown = 1800; -- Block retriggering of this boss module for 30 minutes.
        data.wipeLockdown = 0;     -- Revoke the CD for this module because of the in-zone trigger.

        self:GrabStaticWidgets();

        self:SetDummyBossUnit("worldboss", 180, UnitAffectingCombat("player"));

        self:SearchUnit(BOSS_ID, self.OnBossFound);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(1.00, 1.00, 1.00, 0.90, 1.00); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.70, 0.80, 0.60, 0.35, 0.50); -- P/B/A/C/S
            data.unlimitedSpheres = true;
        end

        self:PrepareBasicWidgets(570, true);
        self.BossBar:Remove(true); -- Hide till we find the boss.

        Root.Music.Play("PREPARATION_BADGUY");

        local attempt = select(2, EncounterStats:GetInfo(self:GetID()));
        local preventive = false;
        if ( attempt <= 1 and self:GetSetting("notTrusted") ) then
            preventive = true;
        end

        self:RemoveHarmfulBuff();
        self:ScanForHarmfulAura(preventive);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(240, 570);
        self:SetNearVictoryThreshold(0.10, 570-60, 0.70); -- Near Victory theme when the boss gets below 10% and 70% of the raid is alive + 1 minute left.

        self:ChangePhase(1, true);

        Root.Music.Play("TIER9_FINALBOSS");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(570, true);

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("BurrowWarning"), self.OnBurrow, self);
        self:RegisterYellCallback("ANY", self:Localize("BurrowEndWarning"), self.OnBurrowEnd, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleBurrow(80);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                local id = Root.Unit.GetMobID(guid);
                if ( id == SPHERE_ID ) then
                    self:OnSphereDeath();
                end
            end

            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 67322 ) and ( actorGUID == self.data.guid ) then
                    self:OnBurrow();
                end
                if ( leechingSwarmSpells[spellId] ) then
                    self:OnLeechingSwarm();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 67574 ) then
                    self:OnPursued(targetGUID, targetName);
                end
                if ( penCold[spellId] ) then
                    self:RegisterHealAssist(targetGUID, 0, 18, spellId);
                end
                if ( spellName == WATER_WALKING ) then
                    if ( targetGUID == UnitGUID("player") ) then
                        self:RemoveHarmfulBuff();
                    end
                    self:OnHarmfulBuff("WATERWALKING", actorGUID, actorName, targetGUID);
                end
                if ( spellName == PATH_OF_FROST ) then
                    self:OnHarmfulBuff("PATH", actorGUID, actorName, targetGUID);
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleBurrow = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("NextBurrow", timer, "AUTO", self:Localize("Burrow"), "WARNING");
    end,

    ScanForHarmfulAura = function(self, preventive)
        local hasAura = Root.Unit.SearchEffect("player", "BUFF", PATH_OF_FROST);
        if ( self:GetSetting("preventFallAbuse") or preventive ) and ( hasAura or preventive ) and ( not UnitAffectingCombat("player") ) then
            local message;
            if ( hasAura ) then
                message = "Kick-PathOfFrostAll";
          else
                message = "Kick-PathOfFrostAllPreventive";
            end

            -- Oh-oh, a DK has enabled PoF on us (or we do prevention), time to do some kickin' =X

            local kickOccured = false;
            local checkList = Root.Table.Alloc();
            Root.Unit.EnumerateRaid(checkList);

            local i, uid, class, name;
            for i=1, #checkList do
                uid = checkList[i];
                class = select(2, UnitClass(uid));
                name = UnitName(uid);
                if ( class == "DEATHKNIGHT" ) then
                    if ( Root.BootFromRaid(uid) ) then
                        kickOccured = true;
                        Root.Whisper(self:Localize(message), name, true);
                    end
                end
            end
            if ( kickOccured ) then
                Root.Say(self:Localize(message), true);
            end

            Root.Table.Recycle(checkList);
        end
    end,

    GetRemainingSpheres = function(self)
        if ( self.data.unlimitedSpheres ) then
            return -1;
      else
            return max(0, NUM_SPHERES - self.data.spheres);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnZoneChanged = function(self)
        local subZone = GetSubZoneText();
        if ( not self.running ) and ( subZone == self:Localize("IcyDepths") ) then
            self:OnTrigger(nil);
        end
    end,

    OnBossFound = function(self, uid)
        self.data.name = UnitName(uid);
        self.data.guid = UnitGUID(uid);
        self.data.bossMaxHealth = UnitHealthMax(uid);
        self.data.bossDead = false;

        self.BossBar:Display();
        self.BossBar:GetDriver():SetWatch(self.data.guid);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.30, self:Localize("Swarm"));
        -- self:RegisterHealthThreshold(0.85, "Test"); -- FOR DEBUGGING
    end,

    OnBurrow = function(self)
        if ( self.data.phase ~= 1 ) then return; end
        self:ChangePhase(2, true);

        self.EventWatcher:GetDriver():TriggerEvent("NextBurrow");
        self.EventWatcher:GetDriver():AddEvent("BurrowEnd", 63, "AUTO", self:Localize("BurrowEnd"), "WARNING");
    end,

    OnBurrowEnd = function(self)
        if ( self.data.phase ~= 2 ) then return; end
        self:ChangePhase(1, true);

        self.EventWatcher:GetDriver():TriggerEvent("BurrowEnd");
        self:ScheduleBurrow(80);
    end,

    OnLeechingSwarm = function(self)
        if ( self.data.phase == 3 ) then return; end
        self:ChangePhase(3, true);

        self:ChangeMusic("HURRYUP");

        self.EventWatcher:GetDriver():ClearEvent("NextBurrow");

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("BELOW_HEALTH", false, 3500);
    end,

    OnPursued = function(self, guid, name)
        if ( self:GetSetting("warnTarget") ) and ( not Root.IsBlacklisted(name) ) then
            self:AnnounceToRaid(self:FormatLoc("PursuedAlert", name));
            self:PlaceSymbol(guid, 7);
        end
        if ( guid == UnitGUID("player") ) then
            self:AlertMe(self:Localize("PursuedSelf"), 0.300, 4.000);
        end
    end,

    OnSphereDeath = function(self)
        self.data.spheres = self.data.spheres + 1;

        local numRemaining = self:GetRemainingSpheres();
        if ( numRemaining >= 0 ) then
            self.StatusFrame:SetStatus("TEXT", self:FormatLoc("SphereCount", numRemaining, NUM_SPHERES), true);
        end
    end,

    OnHarmfulBuff = function(self, buff, actorGUID, actorName, victim)
        -- This handler is an easter egg !

        if ( actorGUID == victim ) then
            return; -- Don't bother if the player kills himself.
        end
        if ( not self:GetSetting("preventFallAbuse") ) then
            return;
        end
        if ( UnitAffectingCombat("player") ) then
            return;
        end

        local lastKick = self.data.kickDecision[actorGUID] or -999;
        if (( GetTime() - lastKick ) < 2 ) then return; end
        self.data.kickDecision[actorGUID] = GetTime();

        -- Okay, let's start kickin' some butt

        if ( buff == "WATERWALKING" ) then
            Root.BootFromRaid(actorGUID, self:FormatLoc("Kick-Waterwalking", actorName));

    elseif ( buff == "PATH" ) then
            Root.BootFromRaid(actorGUID, self:FormatLoc("Kick-PathOfFrost", actorName));
        end
    end,

    RemoveHarmfulBuff = function(self)
        CancelUnitBuff("player", WATER_WALKING);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(BOSS_ID, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], true); -- this module needs to be always set in global table.
end
