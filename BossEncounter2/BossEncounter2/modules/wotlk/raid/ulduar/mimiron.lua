local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Mimiron Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Mimiron fight.

-- 25-man version:
-- No change.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["EngageTrigger"] = "We haven't much time",
	["HardMode"] = "Now why would you go",
	["Phase2Trigger"] = "Positively marvelous results",
	["Phase3Trigger"] = "Thank you, friends",
	["Phase4Trigger"] = "Preliminary testing phase",
        ["ClearTrigger"] = "It would appear that I made a slight miscalculation",

        -- 2. Events
        ["PhaseActivation"] = "Phase %s starts",
        ["PlasmaBlast"] = "Plasma Blast",
        ["LaserBarrage"] = "Laser Barrage",
        ["MagneticEnd"] = "The ACU takes off",
        ["Shock"] = "Shock Blast",
        ["FrostBomb"] = "Frost Bomb",
        ["FrostBombExplosion"] = "F.B. : Explosion",
        ["Flames"] = "Flame Suppressant",

        -- 3. Misc
        ["NoBagSlot"] = "|cffff0000You don't have any free slot in your bags.|r",
        ["LootMethod"] = "|cffffff00Free for all loot method is highly recommanded.|r",
        ["ShockBlastAlert"] = "Go away from the boss !",
        ["LaserBarrageAlert"] = "Laser Barrage incoming !",
        ["PlasmaBlastAlert"] = "Plasma Blast incoming !",
        ["MagneticAlert"] = "The ACU is vulnerable !",
        ["BombSpawnAlert"] = ">> A mobile bomb has spawned !! <<",
        ["FrostBombAlert"] = "The frost bomb is about to explode !",
    },
    ["frFR"] = {
        -- 1. Yells
        ["EngageTrigger"] = "Nous n'avons pas beaucoup de temps",
	["HardMode"] = "pourquoi avez",
	["Phase2Trigger"] = "Résultats parfaitement formidables",
	["Phase3Trigger"] = "Merci, les amis",
	["Phase4Trigger"] = "Fin de la phase d'essais",
        ["ClearTrigger"] = "une minime erreur de calcul",

        -- 2. Events
        ["PhaseActivation"] = "Activation phase %s",
        ["PlasmaBlast"] = "Explosion de plasma",
        ["LaserBarrage"] = "Barrage laser",
        ["MagneticEnd"] = "L'UCA redécolle",
        ["Shock"] = "Horion explosif",
        ["FrostBomb"] = "Bombe de givre",
        ["FrostBombExplosion"] = "B.G. : explosion",
        ["Flames"] = "Coupe-flamme",

        -- 3. Misc
        ["NoBagSlot"] = "|cffff0000Vous n'avez pas de place dans vos sacs.|r",
        ["LootMethod"] = "|cffffff00Le mode de butin libre est fortement recommandé.|r",
        ["ShockBlastAlert"] = "Eloignez-vous du boss !",
        ["LaserBarrageAlert"] = "Barrage laser imminent !",
        ["PlasmaBlastAlert"] = "Explosion de plasma imminente !",
        ["MagneticAlert"] = "L'UCA est vulnérable !",
        ["BombSpawnAlert"] = ">> Une bombe mobile est apparue !! <<",
        ["FrostBombAlert"] = "La bombe de givre va exploser !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "plasmaBlastAlert",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Warn me of Plasma Blast",
            ["frFR"] = "Me prévenir d'Explosion de plasma",
        },
        explain = {
            ["default"] = "Display a personnal alert whenever the tank is about to get hit by Plasma Blast. It is recommanded that the tank and healers enable this option.",
            ["frFR"] = "Affiche une alerte personnelle chaque fois que le tank va subir l'Explosion de plasma. Il est recommandé au tank et aux soigneurs d'activer cette option.",
        },
    },
    [2] = {
        id = "warnBombSpawn",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn mobile bombs",
            ["frFR"] = "Annoncer les bombes mobiles",
        },
        explain = {
            ["default"] = "Display a raid alert each time a mobile bomb is summoned.",
            ["frFR"] = "Affiche une alerte de raid chaque fois qu'une bombe mobile est invoquée.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Mimiron";

local LEVIATHAN_ID = 33432;
local VX_ID        = 33651;
local AERIAL_ID    = 33670;

local REVIVABLE_ADDS = {
    [LEVIATHAN_ID] = true,
    [VX_ID] = true,
    [AERIAL_ID] = true,
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

        data.ignoreStandardClear = true; -- Just in case.
        data.ignoreLeaveCombat = true; -- Since the parts despawn, this check is useless. It could also cause problems when switching phases...
        data.hardMode = false;
        data.silentAddKills = true;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid, 120, true);

        self:SetDifficultyMeter(0.85, 1.00, 0.70, 0.45, 0.55); -- P/B/A/C/S

        self:PrepareBasicWidgets(900, true);
        self.BossBar:Remove(true); -- Do not show the boss bar yet.

        Root.Music.Play("PREPARATION_GENERAL");

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("EngageTrigger"), self.OnEngaged, self);
        self:RegisterYellCallback(nil, self:Localize("HardMode"), self.OnHardMode, self);
        self:RegisterYellCallback(nil, self:Localize("Phase2Trigger"), self.OnPhaseTwo, self);
        self:RegisterYellCallback(nil, self:Localize("Phase3Trigger"), self.OnPhaseThree, self);
        self:RegisterYellCallback(nil, self:Localize("Phase4Trigger"), self.OnPhaseFour, self);
        self:RegisterYellCallback(nil, self:Localize("ClearTrigger"), self.OnCleared, self);

        self:CheckBagSlots();
        self:CheckLootMethod();

        self:DefineRevivableAdds(REVIVABLE_ADDS, 10);
        self.AddWindow:GetDriver():AssignAlgorithm("REVIVE", THIS_MODULE);

        self:ResetAdds();
        self:RegisterAddEX(LEVIATHAN_ID, false, "DB");
        self:RegisterAddEX(VX_ID, false, "DB");
        self:RegisterAddEX(AERIAL_ID, false, "DB");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;
        self.data.timeOut = 120;

        self:SetScoreBenchmarks(420, 840);

        self:ChangePhase(1, true);

        Root.Music.Play("THEME_MECHANICAL");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(900, true);

        self:SearchUnit(LEVIATHAN_ID, self.OnBossFound);

        self:SchedulePlasmaBlast(20);
        self:ScheduleShock(30);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 63631 ) then
                    self:OnShockBlast();
                end
                if ( spellId == 62997 or spellId == 64529 ) then
                    self:OnPlasmaBlast();
                end
                if ( spellId == 64570 ) then
                    self:OnFlames();
                end
                if ( spellId == 64623 ) then
                    self:OnFrostBomb();
                end
            end
        end,

        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 63414 ) then
                    self:OnLaserBarrage();
                end
            end
        end,

        ["SUMMON"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 64444 ) or ( spellId == 64436 ) then
                    self:OnMagnetic();
                end
                if ( spellId == 63811 ) then
                    self:OnBombSpawned();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 63666 or spellId == 65026 ) and ( targetGUID ) then
                    self:RegisterHealAssist(targetGUID, 0, 8, spellId);
                end
            end
        end,
    },
  
    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    CheckBagSlots = function(self)
        if ( Root.GetNumFreeBagSlots() >= 1 ) then return; end
        self:AlertMe(self:Localize("NoBagSlot"), 1.000, 8.000);
    end,

    CheckLootMethod = function(self)
        local lootMethod = GetLootMethod();
        if ( lootMethod ~= "freeforall" ) and ( Root.CheckAuth("SUPERADMIN") ) then
            self:AlertMe(self:Localize("LootMethod"), 1.000, 8.000);
        end
    end,

    SchedulePhaseActivation = function(self, number, timer)
        self.EventWatcher:GetDriver():AddEvent("Phase"..number, timer, "AUTO", self:FormatLoc("PhaseActivation", number), "WARNING");
    end,

    SchedulePlasmaBlast = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("PlasmaBlast", timer, "AUTO", self:Localize("PlasmaBlast"), self:IfRole("SHIELD", "WARNING", "NORMAL"));
    end,

    ScheduleLaserBarrage = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("LaserBarrage", timer, "AUTO", self:Localize("LaserBarrage"), "NORMAL");
    end,

    ScheduleShock = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Shock", timer, "AUTO", self:Localize("Shock"), self:IfRole("MELEE", "WARNING", "NORMAL"));
    end,

    ScheduleFrostBomb = function(self, timer)
        if ( not self.data.hardMode ) then return; end
        self.EventWatcher:GetDriver():AddEvent("FrostBomb", timer, "AUTO", self:Localize("FrostBomb"), "WARNING");
    end,

    ScheduleFlames = function(self, timer)
        if ( not self.data.hardMode ) then return; end
        self.EventWatcher:GetDriver():AddEvent("Flames", timer, "AUTO", self:Localize("Flames"), "WARNING");
    end,

    ClearBossEvents = function(self)
        self.EventWatcher:GetDriver():ClearEvent("PlasmaBlast");
        self.EventWatcher:GetDriver():ClearEvent("LaserBarrage");
        self.EventWatcher:GetDriver():ClearEvent("Shock");
        self.EventWatcher:GetDriver():ClearEvent("FrostBomb");
        self.EventWatcher:GetDriver():ClearEvent("Flames");
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnHardMode = function(self)
        self.data.hardMode = true;

        self:OnEngaged(); -- Make sure the fight is engaged.

        Root.Music.Play("THEME_MADNESS");

        self:AlertMe(self:Localize("HardModeTrigger"));
        self.StatusFrame:GetDriver():Clear();
        self.StatusFrame:GetDriver():StartCountdown(600);
        self.StatusFrame:SetBlinking(true); -- Make the berserk timer blinks for 5 sec.
        self.EventWatcher:GetDriver():AddEvent("StopBerserkBlinking", 5.000, "", "", "HIDDEN", self.StatusFrame.SetBlinking, self.StatusFrame, false);
        self.EventWatcher:GetDriver():ClearEvent("Berserk");
        self:ScheduleBerserk(600, true);
        self.EventWatcher:GetDriver():ChangeEvent("Berserk", nil, nil, "BOOM !", nil, nil);

        self:ScheduleFlames(70);
    end,

    OnPhaseTwo = function(self)
        if ( self.data.phase >= 2 ) then return; end
        self:ChangePhase(2, true);

        self.data.timeOutTimer = 0;
        self.data.timeOut = 120;

        self.BossBar:Remove();
        self:SearchUnit(VX_ID, self.OnBossFound);

        self:SchedulePhaseActivation(2, 40);
        self:ClearBossEvents();

        self:ChangeMusic("TIER8_SURVIVAL1");

        self:ScheduleFrostBomb(45);
    end,

    OnPhaseThree = function(self)
        if ( self.data.phase >= 3 ) then return; end
        self:ChangePhase(3, true);

        self.data.timeOutTimer = 0;
        self.data.timeOut = 120;

        self.BossBar:Remove();
        self:SearchUnit(AERIAL_ID, self.OnBossFound);

        self:SchedulePhaseActivation(3, 25);
        self:ClearBossEvents();

        self:CheckBagSlots();
        self:CheckLootMethod();
    end,

    OnPhaseFour = function(self)
        if ( self.data.phase >= 4 ) then return; end
        self:ChangePhase(4, true);

        self.data.timeOutTimer = 0;
        self.data.timeOut = 120;

        self.data.ignoreStandardClear = false; -- Necessary because the victory yell may lag out of the time window where the raid is still in combat.

        self:RespawnAdd(LEVIATHAN_ID);
        self:RespawnAdd(VX_ID);
        self:RespawnAdd(AERIAL_ID);

        -- We leave the aerial unit as the main boss.
        self.BossBar:Remove();
        self:SetNearVictoryThreshold(0.10, nil, 0.70); -- Near Victory theme when the boss gets below 10.0% and 70% of the raid is alive.

        self:ChangeMusic("HURRYUP");

        self:SchedulePhaseActivation(4, 25);
        self:ClearBossEvents();

        self:ScheduleShock(60);
        self:ScheduleFrostBomb(30);
    end,

    OnBossFound = function(self, uid)
        self.data.name = UnitName(uid);
        self.data.guid = UnitGUID(uid);

        self.BossBar:Display();
        self.BossBar:GetDriver():SetWatch(self.data.guid);
    end,

    OnShockBlast = function(self)
        local distance = self:GetDistance(self.data.guid);
        if ( distance ) and ( not self:HasRole("MELEE") ) then
            if ( distance > 20 ) then return; end
        end
        if ( not self:SuperAlert(4.5, self:Localize("ShockBlastAlert"), nil, true, false) ) then
            self:AlertMe(self:Localize("ShockBlastAlert"), 0.300, 3.500);
        end
        self.EventWatcher:GetDriver():TriggerEvent("Shock");
        self:ScheduleShock(34);
    end,

    OnPlasmaBlast = function(self)
        if ( self:GetSetting("plasmaBlastAlert") ) then
            self:AlertMe(self:Localize("PlasmaBlastAlert"), 0.300, 4.000);
        end
        local bossTargetGUID = self:GetTargetInfo();
        if ( bossTargetGUID ) then
            self:RegisterHealAssist(bossTargetGUID, 3, 9, {62997, 64529});
        end
        self.EventWatcher:GetDriver():TriggerEvent("PlasmaBlast");
        self:SchedulePlasmaBlast(30);
    end,

    OnLaserBarrage = function(self)
        if ( not self:EvaluateCooldown("barrage", 15) ) then return; end

        self:AlertMe(self:Localize("LaserBarrageAlert"), 0.400, 3.500);

        self.EventWatcher:GetDriver():TriggerEvent("LaserBarrage");
        self:ScheduleLaserBarrage(60);
    end,

    OnMagnetic = function(self)
        if ( self:HasRole("DPS") ) then
             self:AlertMe(self:Localize("MagneticAlert"));
        end
        self.EventWatcher:GetDriver():AddEvent("MagneticEnd", 15, "AUTO", self:Localize("MagneticEnd"), self:IfRole("DPS", "WARNING", "NORMAL"));
    end,

    OnBombSpawned = function(self)
        if ( self:GetSetting("warnBombSpawn") ) then
            self:AnnounceToRaid(self:Localize("BombSpawnAlert"));
        end
    end,

    OnFlames = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Flames");
        self:ScheduleFlames(80);
    end,

    OnFrostBomb = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("FrostBomb");
        self:ScheduleFrostBomb(30);

        self:AlertMe(self:Localize("FrostBombAlert"), 0.400, 10);
        self.EventWatcher:GetDriver():AddEvent("FrostBombExplosion", 10, "AUTO", self:Localize("FrostBombExplosion"), "ALERT");
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(33350, THIS_MODULE, true);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
