local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Iron Council Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Iron Council fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["DeathRune"] = "CD: Death Rune",
        ["LightningTendrilsEnd"] = "Lightning Tendrils: end",
        ["Overwhelm"] = "%s's death",

        -- 3. Misc
        ["Title"] = "Assembly of Iron",
        ["OverloadAlert"] = "|cffff2020Do not stay close from Brundir !|r",
        ["PunchAlert"] = "Fusion punch incoming !",
        ["DeathRuneAlert"] = "|cffff0000Get out|r from the Death Rune !",
        ["TendrilsTarget"] = ">> {rt7} Tendrils target: %s {rt7} <<",
        ["TendrilsSelf"] = "Brundir is pursuing you !",
        ["WhirlAlert"] = "Interrupt Brundir !",
        ["OverwhelmSelf"] = "You will explode in %s seconds !!",
        ["OverwhelmAlert"] = ">> {rt8} %s has Overwhelming Power !! {rt8} <<",
        ["FocusAdvice"] = "It is recommanded you set |cffffff00Brundir|r as /focus.",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["DeathRune"] = "Recharge: rune de mort",
        ["LightningTendrilsEnd"] = "Vrilles d'éclair: fin",
        ["Overwhelm"] = "Mort |2 %s",

        -- 3. Misc
        ["Title"] = "Assemblée de Fer",
        ["OverloadAlert"] = "|cffff2020Ne restez pas près de Brundir !|r",
        ["PunchAlert"] = "Coup de poing fusion imminent !",
        ["DeathRuneAlert"] = "|cffff0000Sortez|r de la rune de mort !",
        ["TendrilsTarget"] = ">> {rt7} Cible des vrilles: %s {rt7} <<",
        ["TendrilsSelf"] = "Brundir vous poursuit !",
        ["WhirlAlert"] = "Interrompez Brundir !",
        ["OverwhelmSelf"] = "Vous allez exploser dans %s secondes !!",
        ["OverwhelmAlert"] = ">> {rt8} %s a puissance accablante !! {rt8} <<",
        ["FocusAdvice"] = "Il est recommandé de mettre en /focus |cffffff00Brundir|r.",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "fusionPunchAlert",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Warn me of Fusion Punch",
            ["frFR"] = "Me prévenir des coups de poing fusion",
        },
        explain = {
            ["default"] = "Display a personnal alert whenever the tank is about to get hit by Fusion Punch. It is recommanded that the tank and healers enable this option.",
            ["frFR"] = "Affiche une alerte personnelle chaque fois que le tank va subir le coup de poing fusion. Il est recommandé au tank et aux soigneurs d'activer cette option.",
        },
    },
    [2] = {
        id = "lightningWhirlAlert",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Warn me of Lightning Whirl",
            ["frFR"] = "Me prévenir d'éclair tourbillonnant",
        },
        explain = {
            ["default"] = "Display a personnal alert whenever Brundir starts his Lightning Whirl. It is recommanded the people able to interrupt him enable this option.",
            ["frFR"] = "Affiche une alerte personnelle chaque fois que Brundir commence son éclair tourbillonnant. Il est recommandé aux personnes pouvant l'interrompre d'activer cette option.",
        },
    },
    [3] = {
        id = "warnLightningTendrils",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Lightning Tendrils",
            ["frFR"] = "Annoncer les Vrilles d'éclair",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on the target of Lightning Tendrils.",
            ["frFR"] = "Affiche une alerte de raid et place un signe sur la cible des Vrilles d'éclair.",
        },
    },
    [4] = {
        id = "warnOverwhelm",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Overwhelming Power",
            ["frFR"] = "Annoncer puissance accablante",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on the target of Overwhelming Power.",
            ["frFR"] = "Affiche une alerte de raid et place un signe sur la personne qui reçoit puissance accablante.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "IronCouncil";

local STEELBREAKER_ID = 32867;
local MOLGEIM_ID = 32927;
local BRUNDIR_ID = 32857;

local ShieldAlgorithm = {
    label = {
        ["default"] = "Shield",
        ["frFR"] = "Bouclier",
    },
    layout = 3,
    allowDead = false,

    GetValue = function(self, uid)
        local guid = UnitGUID(uid);
        return self:GetValueMasked(guid);
    end,

    GetValueMasked = function(self, guid)
        if ( Root.Unit.GetMobID(guid) ~= MOLGEIM_ID ) then
            return 0, 0;
        end
        return Root[THIS_MODULE]:GetShieldAmount();
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

        data.lastTendrilsTarget = nil;
        data.shieldAmount = 0;
        data.shieldAmountMax = 20000;
        if ( Root.GetInstanceMode() == "HEROIC" ) then data.shieldAmountMax = 50000; end

        self:GrabStaticWidgets();

        self:SetDummyBossUnit("worldboss", 60, UnitAffectingCombat(uid)); -- No NPC is set as the main boss.

        data.title = self:Localize("Title");
        data.baseID = THIS_MODULE;

        self:SetDifficultyMeter(0.60, 0.70, 0.50, 0.40, 0.30); -- P/B/A/C/S

        self:PrepareBasicWidgets(900, true);
        self.BossBar:Remove(true); -- Not needed.

        Root.Music.Play("PREPARATION_GENERAL");

        self.AddWindow:GetDriver():AssignAlgorithm(ShieldAlgorithm);

        self:ResetAdds();
        self:RegisterAdd(STEELBREAKER_ID, false);
        self:RegisterAdd(MOLGEIM_ID, false);
        self:RegisterAdd(BRUNDIR_ID, false);

        local focusGUID = UnitGUID("focus");
        if ( not focusGUID ) or ( Root.Unit.GetMobID(focusGUID) ~= BRUNDIR_ID ) then
            self:NotifyMe(self:Localize("FocusAdvice"), 0.500, 7.500);
        end

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 15, 5);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(360, 780);

        self:UpdateAddsCount(false);

        Root.Music.Play("TIER8_TANKNSPANK1");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(900, true);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...)
            if ( self.running ) then
                if ( targetGUID ) and ( Root.Unit.GetMobID(targetGUID) == MOLGEIM_ID ) then
                    local amount, overdamage, school, special, resisted, blocked, absorbed = select(3, ...);
                    self:OnShieldDamaged((amount or 0) + (resisted or 0) + (blocked or 0) + (absorbed or 0));
                end
            end

            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...);
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( spellId == 61903 or spellId == 63493 ) then
                self:OnFusionPunch();
            end
        end,

        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 61869 or spellId == 63481 ) then
                    self:OnOverload();
                end
                if ( spellId == 63483 or spellId == 61915 ) then
                    self:OnLightningWhirl();
                end
                if ( spellId == 62269 or spellId == 63490 ) then
                    self:OnDeathRune();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 62269 or spellId == 63490 ) and ( targetGUID ) then
                    if ( targetGUID == UnitGUID("player") ) then
                        self:OnLocalPlayerDeathRune();
                    end
                    self:RegisterHealAssist(targetGUID, 0, nil, spellId);
                end
                if ( spellId == 61887 or spellId == 63486 ) then
                    self:OnLightningTendrils();
                end
                if ( spellId == 62274 or spellId == 63489 ) then
                    self:OnShieldGained();
                end
                if ( spellId == 61888 or spellId == 64637 ) and ( targetGUID and targetName ) then
                    self:OnOverwhelmAdded(targetGUID, targetName);
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 61887 or spellId == 63486 ) then
                    self:OnLightningTendrilsEnd();
                end
                if ( spellId == 62274 or spellId == 63489 ) then
                    self:OnShieldRemoved();
                end
                if ( spellId == 61888 or spellId == 64637 ) and ( targetGUID ) then
                    self:OnOverwhelmRemoved(targetGUID);
                end
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    CheckLightningTendrilsTarget = function(self)
        local brundirGUID = self:GetAddGUID(BRUNDIR_ID);
        if ( brundirGUID ) then
            local guid, name, uid = self:GetTargetInfo(brundirGUID);
            if ( guid and name ) and ( guid ~= self.data.lastTendrilsTarget ) then
                self.data.lastTendrilsTarget = guid;

                if ( self:GetSetting("warnLightningTendrils") ) then
                    self:AnnounceToRaid(self:FormatLoc("TendrilsTarget", name));
                    self:PlaceSymbol(guid, 7);
                end

                if ( guid == UnitGUID("player") ) then
                    self:AlertMe(self:Localize("TendrilsSelf"), 0.400, 5.000);
                end
            end
        end
        self.EventWatcher:GetDriver():AddEvent("LT-Target", 0.100, "", "", "HIDDEN", self.CheckLightningTendrilsTarget, self);
    end,

    GetOverwhelmTimer = function(self)
        if ( Root.GetInstanceMode() == "HEROIC" ) then return 30; end
        return 60;
    end,

    GetShieldAmount = function(self)
        if ( not self.running ) or ( not self.data ) then return 0, 0; end
        return self.data.shieldAmount, self.data.shieldAmountMax;
    end,

    CheckStandardClear = function(self)
        if ( not self.running ) then return; end

        local hardMode = true;
        local i, mobID, guid, name, ally, dead;
        for i=1, self:GetNumAdds() do
            mobID, guid, name, ally, dead = self:GetAddInfo(i);
            if ( mobID == MOLGEIM_ID ) and ( not dead ) then
                hardMode = false;
            end
            if ( mobID == BRUNDIR_ID ) and ( not dead ) then
                hardMode = false;
            end
            if ( mobID == STEELBREAKER_ID ) and ( dead ) then
                hardMode = false;
            end
        end
        if ( hardMode ) then
            self:ChangeMusic("HURRYUP");
            self:AlertMe(self:Localize("HardModeTrigger"));
        end

        Shared.CheckStandardClear(self);
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnOverload = function(self)
        local brundirGUID = self:GetAddGUID(BRUNDIR_ID);
        local distance = self:GetDistance(brundirGUID);
        if ( distance ) and ( distance > 25 ) then
            return;
        end
        self:AlertMe(self:Localize("OverloadAlert"), 0.400, 6.000);
    end,

    OnFusionPunch = function(self)
        if ( self:GetSetting("fusionPunchAlert") ) then
            self:AlertMe(self:Localize("PunchAlert"), 0.400, 3.000);
        end

        local steelbreakerGUID = self:GetAddGUID(STEELBREAKER_ID);
        if ( not steelbreakerGUID ) then return; end

        local steelbreakerTarget = self:GetTargetInfo(steelbreakerGUID);
        if ( steelbreakerTarget ) then
            self:RegisterHealAssist(steelbreakerTarget, 3, 8, {61903, 63493});
        end
    end,

    OnDeathRune = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("DeathRune");
        self.EventWatcher:GetDriver():AddEvent("DeathRune", 30, "AUTO", self:Localize("DeathRune"), "WARNING");
    end,

    OnLocalPlayerDeathRune = function(self)
        self:AlertMe(self:Localize("DeathRuneAlert"), 0.400, 3.000);
    end,

    OnLightningWhirl = function(self)
        if ( self:GetSetting("lightningWhirlAlert") ) then
            self:AlertMe(self:Localize("WhirlAlert"), 0.400, 3.000);
        end
    end,

    OnLightningTendrils = function(self)
        self.EventWatcher:GetDriver():AddEvent("LT-End", 35, "AUTO", self:Localize("LightningTendrilsEnd"), "WARNING");
        self.data.lastTendrilsTarget = nil;
        self.EventWatcher:GetDriver():AddEvent("LT-Target", 0.100, "", "", "HIDDEN", self.CheckLightningTendrilsTarget, self);
    end,

    OnLightningTendrilsEnd = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("LT-End");
        self.EventWatcher:GetDriver():ClearEvent("LT-Target");

        local lastTarget = self.data.lastTendrilsTarget;
        if ( lastTarget ) then self:PlaceSymbol(lastTarget, 0); end
    end,

    OnShieldGained = function(self)
        self.data.shieldAmount = self.data.shieldAmountMax;
    end,

    OnShieldRemoved = function(self)
        self.data.shieldAmount = 0;
    end,

    OnShieldDamaged = function(self, amount)
        self.data.shieldAmount = max(0, self.data.shieldAmount - amount);
    end,

    OnOverwhelmAdded = function(self, guid, name)
        local duration = self:GetOverwhelmTimer();
        self.EventWatcher:GetDriver():AddEvent("Overwhelm:"..guid, duration, "AUTO", self:FormatLoc("Overwhelm", name), "ALERT");
        if ( guid == UnitGUID("player") ) then
             self:AlertMe(self:FormatLoc("OverwhelmSelf", duration), 0.400, 5.000);
            self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 15, 1);
        end
        if ( self:GetSetting("warnOverwhelm") ) then
            self:AnnounceToRaid(self:FormatLoc("OverwhelmAlert", name));
            self:PlaceSymbol(guid, 8);
        end
    end,

    OnOverwhelmRemoved = function(self, guid)
        self.EventWatcher:GetDriver():TriggerEvent("Overwhelm:"..guid);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(STEELBREAKER_ID, THIS_MODULE, false);
    Root.NPCDatabase.Register(MOLGEIM_ID, THIS_MODULE, false);
    Root.NPCDatabase.Register(BRUNDIR_ID, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
