local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

local Distance = Root.GetOrNewModule("Distance");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Northrend Beasts Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Northrend Beasts fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["GlobalTrigger"] = "Hailing from the deepest",
        ["JormungarTrigger"] = "Steel yourselves",
        ["IcehowlTrigger"] = "The air itself freezes",
        ["ChargeTrigger"] = "glares at",

        -- 2. Events
        ["NextPhase"] = "Phase %d",
        ["JormungarSpray"] = "Spray / Swipe",
        ["JormungarEmerge"] = "Emerge",
        ["JormungarSubmerge"] = "Submerge",
        ["IcehowlStun"] = "Stun ends",
        ["IcehowlButt"] = "CD: Butt",

        -- 3. Misc
        ["Title"] = "North. Beasts",
        ["ImpaleAlert"] = ">> %s has %d Impale stacks!! <<",
        ["FireSelf"] = "|cff8080ffYou are burning!!|r",
        ["FireTossed"] = "A bomb has been tossed...",
        ["SnoboldAlert"] = ">> {rt%d} New snobold close to %s! {rt%d} <<",
        ["SnoboldShortage"] = "No snobolds remaining!",
        ["ToxinSelf"] = "You have the Paralytic Toxin!",
        ["ToxinExplain"] = "Paralysis",
        ["BurningBileSelf"] = "You are a bomb!",
        ["BurningBileAlert"] = ">> Burning Bile: <<",
        ["SlimeSelf"] = "You are in the slime! Hmm...",
        ["ChargeSelf"] = "Move away!",
        ["ChargeSelfExplain"] = "You are about to be charged!",
        ["ChargeAlert"] = ">> {rt7} %s is about to be charged! Move away! {rt7} <<",
        ["IcehowlEnrage"] = "Icehowl is enraged!!",
    },
    ["frFR"] = {
        -- 1. Yells
        ["GlobalTrigger"] = "Arrivant tout droit des plus noires et profondes cavernes",
        ["JormungarTrigger"] = "Apprêtez",
        ["IcehowlTrigger"] = "L'air se gèle",
        ["ChargeTrigger"] = "fusille",

        -- 2. Events
        ["NextPhase"] = "Phase %d",
        ["JormungarSpray"] = "Jet / Balayage",
        ["JormungarEmerge"] = "Déterrement",
        ["JormungarSubmerge"] = "Enfouissement",
        ["IcehowlStun"] = "Etourdissement: fin",
        ["IcehowlButt"] = "Recharge: coup de tête",

        -- 3. Misc
        ["Title"] = "Bêtes du Norf.",
        ["ImpaleAlert"] = ">> %s a %d empilements d'empaler !! <<",
        ["FireSelf"] = "|cff8080ffVous brûlez !!|r",
        ["FireTossed"] = "Une bombe a été lancée...",
        ["SnoboldAlert"] = ">> {rt%d} Nouveau frigbold proche de %s ! {rt%d} <<",
        ["SnoboldShortage"] = "Il ne reste plus de frigbolds !",
        ["ToxinSelf"] = "Vous avez la toxine paralysante !",
        ["ToxinExplain"] = "Paralysie",
        ["BurningBileSelf"] = "Vous êtes une bombe !",
        ["BurningBileAlert"] = ">> Bile brûlante : <<",
        ["SlimeSelf"] = "Vous êtes dans la bave ! Hmm...",
        ["ChargeSelf"] = "Eloignez-vous !",
        ["ChargeSelfExplain"] = "Vous allez être bientôt chargé(e) !",
        ["ChargeAlert"] = ">> {rt7} %s va être chargé(e) ! Ne restez pas à côté ! {rt7} <<",
        ["IcehowlEnrage"] = "Glace-hurlante est enragé !!",
    },
};

local FIRE_BOMB = GetSpellInfo(66317);
local FIRE_BOMB_TOSS = GetSpellInfo(66313);

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnImpale",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Impale",
            ["frFR"] = "Annoncer les empaler",
        },
        explain = {
            ["default"] = "Display a raid alert when a tank receives 3 stacks or more of the Impale debuff.",
            ["frFR"] = "Affiche une alerte de raid quand un tank reçoit 3 empilements ou plus de l'empaler.",
        },
    },
    [2] = {
        id = "warnSnobold",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Snobolds",
            ["frFR"] = "Annoncer les frigbolds",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol each time a raid member gets a Snobold.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole chaque fois qu'un membre du raid reçoit un frigbold.",
        },
    },
    [3] = {
        id = "warnBurningBile",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Burning Bile",
            ["frFR"] = "Annoncer la bile brûlante",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol each time a raid member gets the Burning Bile debuff.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole chaque fois qu'un membre du raid obtient l'affaiblissement bile brûlante.",
        },
    },
    [4] = {
        id = "warnCharge",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn charge",
            ["frFR"] = "Annoncer la charge",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol each time a raid member is about to be charged.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole chaque fois qu'un membre du raid est sur le point d'être chargé.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Beasts";

local GORMOK_ID     = 34796;
local ACIDMAW_ID    = 35144;
local DREADSCALE_ID = 34799;
local ICEHOWL_ID    = 34797;

local SNOBOLD_ID = 34800;

local snoboldCount = {
    ["10N"] = 4,
    ["10H"] = 4,
    ["25N"] = 4,
    ["25H"] = 4,
};

local gormokImpale = {
    [67477] = true,
    [66331] = true,
    [67478] = true,
    [67479] = true,
};

local gormokStomp = {
    [66330] = true,
    [67647] = true,
    [67648] = true,
    [67649] = true,
};

local jormungarToxin = {
    [66823] = 20,
    [67618] = 20,
    [67619] = 10,
    [67620] = 10,
};

local jormungarSpray = {
    -- Poison
    [67617] = true,
    [67616] = true,
    [67615] = true,
    [66901] = true,

    -- Fire
    [67629] = true,
    [67628] = true,
    [67627] = true,
    [66902] = true,
};

local jormungarSlime = {
    [67640] = true,
    [67639] = true,
    [67638] = true,
    [66881] = true,
};

local icehowlEnrage = {
    [66759] = true,
    [67658] = true,
    [67657] = true,
    [67659] = true,
};

local icehowlButt = {
    [67654] = true,
    [67655] = true,
    [67656] = true,
    [66770] = true,
}

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

    OnTrigger = function(self, uid)
        if not self:TriggerMe() then return; end

        local data = self.data;

        data.mode = Root.GetInstanceFormat();
        data.title = self:Localize("Title");
        data.baseID = THIS_MODULE;
        data.ignoreLeaveCombat = true;
        data.snoboldCount = 0;
        data.snoboldSeen = 0;
        data.snoboldAssigned = { };
        data.bileList = {};
        data.initialSpray = 10;

        self:GrabStaticWidgets();

        self:SetDummyBossUnit("worldboss", 60, UnitAffectingCombat(uid or "player"));

        if ( data.mode == "HEROIC" ) then
            self:SetDifficultyMeter(0.95, 1.00, 0.75, 0.40, 0.65); -- P/B/A/C/S
            data.stackableFire = true;
            self:PrepareBasicWidgets(150, true);
      else
            self:SetDifficultyMeter(0.70, 0.80, 0.40, 0.30, 0.35); -- P/B/A/C/S
            data.stackableFire = false;
            self:PrepareBasicWidgets(900, true);
        end
        self.BossBar:Remove(true); -- Do not show the boss bar yet.

        self:ResetAdds();
        self:RegisterAddEX(GORMOK_ID, false, "DB");
        self:RegisterAddEX(ACIDMAW_ID, false, "DB");
        self:RegisterAddEX(DREADSCALE_ID, false, "DB");
        self:RegisterAddEX(ICEHOWL_ID, false, "DB");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(420, 780);

        self:UpdateAddsCount(false);
        self:ChangePhase(0, false);

        self.StatusFrame:GetDriver():Resume();
        if ( self.data.mode ~= "HEROIC" ) then
            self:ScheduleBerserk(900, true);
            self.TimerReminder:GetDriver():Clear(); -- No timer reminder for this fight. It's already used by the paralysis timer.
        end

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("JormungarTrigger"), self.OnPhaseTwo, self);
        self:RegisterYellCallback("ANY", self:Localize("IcehowlTrigger"), self.OnPhaseThree, self);
        self:RegisterYellCallback("ANY", self:Localize("ChargeTrigger"), self.OnIcehowlCharge, self);

        self:OnPhaseOne();
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, ...)
            if ( self.running ) then
                if ( spellName == FIRE_BOMB ) and ( targetGUID ) and ( not self.data.stackableFire ) then
                    self:OnGormokFireDamage(targetGUID);
                end
                if ( jormungarSlime[spellId] ) and ( targetGUID ) then
                    if ( targetGUID == UnitGUID("player") ) then
                        self:OnJormungarSlimeDamage();
                    end
                    self:RegisterHealAssist(targetGUID, 0, 2, nil);
                end
                if ( spellId == 66408 ) and ( actorGUID ) and ( targetGUID ) and ( targetName ) then
                    self:OnGormokSnoboldSeen(actorGUID, targetGUID, targetName);
                end
            end

            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, ...);
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellName == FIRE_BOMB_TOSS ) then
                    self:OnGormokFireTossed();
                end
                if ( gormokStomp[spellId] ) then
                    self:OnGormokStomp(spellName);
                end
                if ( jormungarSpray[spellId] ) then
                    self:OnJormungarSpray();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                -- ***** Gormok *****
                if ( spellName == FIRE_BOMB ) and ( targetGUID ) and ( self.data.stackableFire ) then
                    self:OnGormokFireDamage(targetGUID);
                end
                if ( gormokImpale[spellId] ) and ( targetGUID ) and ( targetName ) then
                    self:OnGormokImpale(stackAmount, targetGUID, targetName);
                end
                if ( spellId == 66407 ) and ( actorGUID ) and ( targetGUID ) and ( targetName ) then -- Snobolled (66406) does not work.
                    self:OnGormokSnoboldSeen(actorGUID, targetGUID, targetName);
                end

                -- ***** Jormungar *****
                if ( spellId == 66869 ) and ( targetGUID ) and ( targetName ) then
                    self:OnJormungarBurningBile();
                    tinsert(self.data.bileList, targetGUID);
                    self:RegisterHealAssist(targetGUID, 0, 24, spellId);
                end
                if ( jormungarToxin[spellId] ) and ( targetGUID ) then
                    self:OnJormungarToxin("GAIN", targetGUID, jormungarToxin[spellId]);
                end

                -- ***** Icehowl *****
                if ( spellId == 66758 ) then
                    self:OnIcehowlStun();
                end
                if ( icehowlButt[spellId] ) then
                    self:OnIcehowlButt();
                end
                if ( icehowlEnrage[spellId] ) then
                    self:OnIcehowlEnrage();
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( jormungarToxin[spellId] ) and ( targetGUID ) then
                self:OnJormungarToxin("LOSE", targetGUID);
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,

        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                local id = Root.Unit.GetMobID(guid);
                if ( id == SNOBOLD_ID ) then
                    self:OnGormokSnoboldKilled();
                end
            end
            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,
    },
  
    OnMobYell = function(self, message, source, channel, target)
        if ( not self.running ) then
            if ( string.find(message, self:Localize("GlobalTrigger")) ) then
                self:OnTrigger(nil);
            end
      else
            self:HandleYells(message, source, target);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    GetMaxSnobolds = function(self)
        return snoboldCount[self:GetFormatCode()];
    end,

    AlertBile = function(self)
        if ( self:GetSetting("warnBurningBile") ) then
            self:AnnounceUnitList(self.data.bileList, true, self:Localize("BurningBileAlert"), 23.00);
        end
        local i;
        for i=1, #self.data.bileList do
            if ( self.data.bileList[i] == UnitGUID("player") ) then
                self:AlertMe(self:Localize("BurningBileSelf"));
                return;
            end
        end
    end,

    ScheduleSpray = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("JormungarSpray", timer, "AUTO", self:Localize("JormungarSpray"), "WARNING");
    end,

    ChangeCountdown = function(self, timer)
        self.StatusFrame:GetDriver():Clear();
        self.StatusFrame:GetDriver():StartCountdown(timer);
        self.StatusFrame:SetBlinking(true);
        self.EventWatcher:GetDriver():ClearEvent("StopCountdownBlinking");
        self.EventWatcher:GetDriver():AddEvent("StopCountdownBlinking", 5.00, "", "", "HIDDEN", self.StatusFrame.SetBlinking, self.StatusFrame, false);
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    -- ***************
    -- Gormok handlers
    -- ***************

    OnGormokFireDamage = function(self, guid)
        self:RegisterHealAssist(guid, 0, 2);

        if ( UnitGUID("player") == guid ) then
            if ( not self:EvaluateCooldown("fireAlert", 1) ) then return; end
            self:AlertMe(self:Localize("FireSelf"), 0.100, 1.000);
        end
    end,

    OnGormokFireTossed = function(self)
        if ( not self:EvaluateCooldown("fireToss", 2.5) ) then return; end

        local uid = Root.Unit.GetUID(self.data.guid);
        if ( uid ) then
            if ( Root.GetDistance(uid) <= 15 ) then return; end
        end

        self:NotifyMe(self:Localize("FireTossed"));
    end,

    OnGormokSnoboldSeen = function(self, snobold, guid, name)
        if ( not self.running ) then return; end

        local info = self.data.snoboldAssigned[snobold];
        if ( info ) and ( info.host == guid ) then return; end
        local firstSeen = false;

        if ( not info ) then
            -- This snobold has been seen for the first time.
            firstSeen = true;

            self.data.snoboldSeen = self.data.snoboldSeen + 1;
            info = { host = guid, symbol = math.fmod(self.data.snoboldSeen - 1, 4) + 1 };
            self.data.snoboldAssigned[snobold] = info;
      else
            -- This snobold has switched host.
            info.host = guid;
        end

        if ( self:GetSetting("warnSnobold") ) then
            self:PlaceSymbol(info.host, info.symbol, 20);
            if ( firstSeen ) then self:AnnounceToRaid(self:FormatLoc("SnoboldAlert", info.symbol, name, info.symbol)); end
        end
    end,

    OnGormokSnoboldKilled = function(self)
        self.data.snoboldCount = self.data.snoboldCount + 1;
        if ( self.data.snoboldCount == self:GetMaxSnobolds() ) and ( self.data.phase == 1 ) then
            self:NotifyMe(self:Localize("SnoboldShortage"));
        end
    end,

    OnGormokImpale = function(self, count, guid, name)
        if ( count >= 3 ) then
            if ( self:GetSetting("warnImpale") ) then
                self:AnnounceToRaid(self:FormatLoc("ImpaleAlert", name, count));
            end
            self:RegisterHealAssist(guid, 0, 20, nil);
        end
    end,

    OnGormokStomp = function(self, spellName)
        self.EventWatcher:GetDriver():TriggerEvent("GormokStomp");
        self.EventWatcher:GetDriver():AddEvent("GormokStomp", 21, "AUTO", spellName, self:IfRole("MELEE", "WARNING", "NORMAL"));
    end,

    -- *******************
    -- Jormungars handlers
    -- *******************

    OnJormungarToxin = function(self, action, guid, paralysisTime)
        if ( UnitGUID("player") ~= guid ) then return; end

        if ( action == "GAIN" ) then
            self:AlertMe(self:Localize("ToxinSelf"), 0.500, 9.000);
            self.TimerReminder:GetDriver():Start(paralysisTime, 21, self:Localize("ToxinExplain"));
      else
            self.TimerReminder:GetDriver():Clear();
        end
    end,

    OnJormungarBurningBile = function(self)
        if ( not self:EvaluateCooldown("bile", 5) ) then return; end

        self.EventWatcher:GetDriver():AddEvent("AlertBile", 0.150, "", "", "HIDDEN", self.AlertBile, self);

        wipe(self.data.bileList);
    end,

    OnJormungarSlimeDamage = function(self)
        if ( not self:EvaluateCooldown("slime", 4) ) then return; end

        self:AlertMe(self:Localize("SlimeSelf"), 0.400, 2.500);
    end,

    OnJormungarSpray = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("JormungarSpray");
        self:ScheduleSpray(20);
    end,

    OnJormungarEmerge = function(self)
        if ( not self.running ) then return; end

        self:ScheduleSpray(self.data.initialSpray);
        if ( self.data.initialSpray == 10 ) then
            self.data.initialSpray = 20;
      else
            self.data.initialSpray = 10;
        end

        self.EventWatcher:GetDriver():AddEvent("JormungarSubmerge", 45, "AUTO", self:Localize("JormungarSubmerge"), "WARNING", self.OnJormungarSubmerge, self);
    end,

    OnJormungarSubmerge = function(self)
        self.EventWatcher:GetDriver():ClearEvent("JormungarSpray");
        self.EventWatcher:GetDriver():AddEvent("JormungarEmerge", 10, "AUTO", self:Localize("JormungarEmerge"), "WARNING", self.OnJormungarEmerge, self);
    end,

    -- ****************
    -- Icehowl handlers
    -- ****************

    OnIcehowlCharge = function(self, target)
        if ( self:GetSetting("warnCharge") ) then
            self:AnnounceToRaid(self:FormatLoc("ChargeAlert", target));
            self:PlaceSymbol(target, 7, 8.00);
        end
        local fireSelf = false;
        if target == UnitName("player") then
            fireSelf = true;
      else
            local tUID = Root.Unit.GetUID(target);
            if ( tUID ) and ( Distance:Get("player", tUID) <= 22.0 ) then -- 22yds is enough I believe.
                fireSelf = true;
            end
        end
        if ( fireSelf ) then
            if ( not self:SuperAlert(3.5, self:Localize("ChargeSelf"), self:Localize("ChargeSelfExplain"), true) ) then
                self:AlertMe(self:Localize("ChargeSelf"));
            end
        end
    end,

    OnIcehowlStun = function(self)
        self.EventWatcher:GetDriver():AddEvent("IcehowlStun", 15, "AUTO", self:Localize("IcehowlStun"), "WARNING");
    end,

    OnIcehowlButt = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("IcehowlButt");
        self.EventWatcher:GetDriver():AddEvent("IcehowlButt", 12.5, "AUTO", self:Localize("IcehowlButt"), self:IfRole("MELEE", "WARNING", "NORMAL"));
    end,

    OnIcehowlEnrage = function(self)
        self:AlertMe(self:Localize("IcehowlEnrage"), 0.400, 3.500);
    end,

    -- *************
    -- Flow handlers
    -- *************

    OnPhaseOne = function(self)
        if ( self.data.phase >= 1 ) then return; end
        self:ChangePhase(1, false);

        self:ChangeMusic("THEME_MIGHT");

        self:SearchUnit(GORMOK_ID, self.OnBossFound);

        -- If we are in heroic difficulty, add the phase timers.
        if ( self.data.mode == "HEROIC" ) then
            self.EventWatcher:GetDriver():AddEvent("Phase2", 150, "AUTO", self:FormatLoc("NextPhase", 2), "ALERT");
        end
    end,

    OnPhaseTwo = function(self)
        if ( self.data.phase >= 2 ) then return; end
        self:ChangePhase(2, false);

        self:ChangeMusic("TIER9_SURVIVAL2");

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 10, 4);

        self.BossBar:Remove();

        self.EventWatcher:GetDriver():ClearEvent("GormokStomp");

        self.EventWatcher:GetDriver():AddEvent("JormungarEmerge", 15, "AUTO", self:Localize("JormungarEmerge"), "WARNING", self.OnJormungarEmerge, self);

        -- If we are in heroic difficulty, add the phase timers.
        if ( self.data.mode == "HEROIC" ) then
            self.EventWatcher:GetDriver():TriggerEvent("Phase2");
            self:ChangeCountdown(200);
            self.EventWatcher:GetDriver():AddEvent("Phase3", 200, "AUTO", self:FormatLoc("NextPhase", 3), "ALERT");
        end
    end,

    OnPhaseThree = function(self)
        if ( self.data.phase >= 3 ) then return; end
        self:ChangePhase(3, false);

        self:ChangeMusic("HURRYUP");

        self.UnitList:Remove();

        self:SearchUnit(ICEHOWL_ID, self.OnBossFound);

        self.EventWatcher:GetDriver():ClearEvent("JormungarSpray");
        self.EventWatcher:GetDriver():ClearEvent("JormungarEmerge");
        self.EventWatcher:GetDriver():ClearEvent("JormungarSubmerge");

        if ( self.data.mode == "HEROIC" ) then
            self.EventWatcher:GetDriver():TriggerEvent("Phase3");

            -- In heroic, we have 220 sec to PWN Icehowl.
            self:ChangeCountdown(220);
            self:ScheduleBerserk(220, true);
        end
    end,

    OnBossFound = function(self, uid)
        self.data.name = UnitName(uid);
        self.data.guid = UnitGUID(uid);

        self.BossBar:Display();
        self.BossBar:GetDriver():SetWatch(self.data.guid);

        if ( self.data.phase == 3 ) then
            self:SetNearVictoryThreshold(0.15, nil, 0.70); -- Near Victory theme when the boss gets below 15% and 70% of the raid is alive.
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(GORMOK_ID, THIS_MODULE, true); -- Gormok set as the main boss.

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], true); -- this module needs to be always set in the global table.
end
