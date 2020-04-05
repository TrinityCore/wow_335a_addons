local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- XT-002 Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles XT-002 fight.

-- 25-man version:
-- No change.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["HeartExposedWarning"] = "I will rest",
        ["HeartClosedWarning"] = "ready to play",

        -- 2. Events
        ["HeartClosed"] = "Exposed heart: end",
        ["TympanicTantrum"] = "CD: Tympanic Tantrum",
        ["HeartThreshold"] = "Heart gets exposed (%d)",

        -- 3. Misc
        ["GoAway"] = "Go away from the raid !",
        ["LightBombSelf"] = "You have the Light Bomb !",
        ["LightBombAlert"] = ">> {rt6} %s has the Light Bomb ! {rt6} <<",
        ["GravityBombSelf"] = "You have the Gravity Bomb !",
        ["GravityBombAlert"] = ">> {rt7} %s has the Gravity Bomb ! {rt7} <<",
        ["HeartAlert"] = "Aim for the heart !",
        ["BurstAlert"] = "|cffffff00%s|r is about to take heavy damage !!",
        ["BurstSelf"] = "You are about to take heavy damage !!",
    },
    ["frFR"] = {
        -- 1. Yells
        ["HeartExposedWarning"] = "Je vais me reposer",
        ["HeartClosedWarning"] = "prêt à jouer",

        -- 2. Events
        ["HeartClosed"] = "Coeur exposé: fin",
        ["TympanicTantrum"] = "Recharge: Colère assourdissante",
        ["HeartThreshold"] = "Le coeur devient exposé (%d)",

        -- 3. Misc
        ["GoAway"] = "Eloignez-vous du raid !",
        ["LightBombSelf"] = "Vous avez la bombe de lumière !",
        ["LightBombAlert"] = ">> {rt6} %s a la bombe de lumière ! {rt6} <<",
        ["GravityBombSelf"] = "Vous avez la bombe à gravité !",
        ["GravityBombAlert"] = ">> {rt7} %s a la bombe à gravité ! {rt7} <<",
        ["HeartAlert"] = "Visez le coeur !",
        ["BurstAlert"] = "|cffffff00%s|r va bientôt subir de lourds dégâts !!",
        ["BurstSelf"] = "Vous allez bientôt subir de lourds dégâts !!",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnLightBomb",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Light Bomb",
            ["frFR"] = "Annoncer la bombe de lumière",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on the character that gets the Light Bomb.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole sur la personne qui obtient la bombe de lumière.",
        },
    },
    [2] = {
        id = "warnGravityBomb",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Gravity Bomb",
            ["frFR"] = "Annoncer la bombe à gravité",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on the character that gets the Gravity Bomb.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole sur la personne qui obtient la bombe à gravité.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "XT-002";

local HEART_ID = 33329;

local BERSERK_TIMER = 600;

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

        data.lastGravityBombTarget = nil;
        data.lastGravityBombTime = -999;
        data.lastTympanicTantrum = -999;
        data.ignoreAdds = true;
        data.silentAddKills = true;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.55, 0.65, 0.65, 0.35, 0.30); -- P/B/A/C/S

        data.title = "XT-002";

        self:PrepareBasicWidgets(BERSERK_TIMER, true);

        self:ResetAdds();
        self:RegisterAddEX(HEART_ID, false, "DB");

        self:SetRelevantDamagePending(false); -- Count the damage done to the heart as valid as soon as it is dealt.
        self:AddRelevantTargets(HEART_ID);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(180, 600);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_MECHANICAL");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(BERSERK_TIMER, true);
        self.TimerReminder:GetDriver():Clear(); -- No timer reminder for this fight. It's already used by the gravity bomb timer.

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("HeartExposedWarning"), self.OnHeartRevealed, self);
        self:RegisterYellCallback(nil, self:Localize("HeartClosedWarning"), self.OnHeartClosed, self);

        self:ChangePhase(1, true);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.75, self:FormatLoc("HeartThreshold", 1));
        self:RegisterHealthThreshold(0.50, self:FormatLoc("HeartThreshold", 2));
        self:RegisterHealthThreshold(0.25, self:FormatLoc("HeartThreshold", 3));

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleTympanicTantrum(self:GetInitialTympanicTantrumTimer());
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( spellId == 62776 ) and ( actorGUID ) and ( actorGUID == self.data.guid ) then
                self:OnTympanicTantrum();
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 63018 or spellId == 65121 ) then
                    self:OnLightBomb(targetGUID, targetName);
            elseif ( spellId == 63024 or spellId == 64234 ) then
                    self:OnGravityBomb(targetGUID, targetName);
            elseif ( spellId == 64193 or spellId == 65737 ) then
                    self:OnHeartbreak();
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ShowDistanceUnitList = function(self, duration, distance)
        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, distance, 1);
        self.EventWatcher:GetDriver():ClearEvent("HideUnitList");
        self.EventWatcher:GetDriver():AddEvent("HideUnitList", duration, "", "", "HIDDEN", self.RemoveDistanceCheck, self);
    end,

    RemoveDistanceCheck = function(self)
        self.UnitList:Remove();
        self.UnitList:GetDriver():Clear();
    end,

    ScheduleTympanicTantrum = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("TympanicTantrum", timer, "AUTO", self:Localize("TympanicTantrum"), self:IfRole("SHIELD", "WARNING_NOREMINDER", "NORMAL"));  
    end,

    GetInitialTympanicTantrumTimer = function(self)
        if ( Root.GetInstanceMode() == "HEROIC" ) then return 32; end -- Seems to be longer sometimes...
        return 32;
    end,

    BurstCheck = function(self)
        if ( (GetTime() - self.data.lastGravityBombTime) < 4 ) and ( (GetTime() - self.data.lastTympanicTantrum) < 4) then
            local uid = Root.Unit.GetUID(self.data.lastGravityBombTarget);
            if ( uid ) and ( UnitInRange(uid) ) then
                if ( UnitName("player") == self.data.lastGravityBombTarget ) then
                    self:AlertMe(self:Localize("BurstSelf"), 0.400, 6.000);
              elseif ( self:HasRole("HEALER") ) then
                    self:AlertMe(self:FormatLoc("BurstAlert", self.data.lastGravityBombTarget), 0.400, 6.000);
                end
            end
            -- Nullify last gravity bomb data to avoid double warning.
            self.data.lastGravityBombTarget = nil;
            self.data.lastGravityBombTime = -999;
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnTympanicTantrum = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("TympanicTantrum");
        self:ScheduleTympanicTantrum(70);

        self.data.lastTympanicTantrum = GetTime();

        self:BurstCheck();
    end,

    OnLightBomb = function(self, guid, name)
        if ( guid == UnitGUID("player") ) then
            self:ShowDistanceUnitList(10, 8);
            self:AlertMe(self:Localize("LightBombSelf"), 0.500, 9.000);
        end
        if ( self:GetSetting("warnLightBomb") ) then
            self:AnnounceToRaid(self:FormatLoc("LightBombAlert", name));
            self:PlaceSymbol(guid, 6, 10.00);
        end
        self:RegisterHealAssist(guid, 0, 10, {63018, 65121});
    end,

    OnGravityBomb = function(self, guid, name)
        if ( guid == UnitGUID("player") ) then
            self:ShowDistanceUnitList(10, 12);
            self:AlertMe(self:Localize("GravityBombSelf"), 0.500, 9.000);
            self.TimerReminder:GetDriver():Start(9, 10, self:Localize("GoAway"));
        end
        if ( self:GetSetting("warnGravityBomb") ) then
            self:AnnounceToRaid(self:FormatLoc("GravityBombAlert", name));
            self:PlaceSymbol(guid, 7, 10.00);
        end
        self:RegisterHealAssist(guid, 8, 10, {63024, 64234});

        self.data.lastGravityBombTarget = name;
        self.data.lastGravityBombTime = GetTime();

        self:BurstCheck();
    end,

    OnHeartRevealed = function(self)
        if ( self.data.phase == 2 ) then return; end
        self:ChangePhase(2, true);
        self.EventWatcher:GetDriver():ClearEvent("TympanicTantrum");
        self.EventWatcher:GetDriver():AddEvent("HeartClosed", 35, "AUTO", self:Localize("HeartClosed"), "ALERT");
        self.EventWatcher:GetDriver():AddEvent("HeartAlert", 3, "", "", "HIDDEN", self.OnHeartAlert, self);
    end,

    OnHeartAlert = function(self)
        if ( self:HasRole("DPS") ) then
            self:AlertMe(self:Localize("HeartAlert"));
        end
    end,

    OnHeartClosed = function(self)
        if ( self.data.phase == 1 ) then return; end
        self:ChangePhase(1, true);
        self.EventWatcher:GetDriver():TriggerEvent("HeartClosed");
        self:ScheduleTympanicTantrum(self:GetInitialTympanicTantrumTimer());
    end,

    OnHeartbreak = function(self)
        -- Immediately cause the heart to close and trigger hard mode.
        -- No berserk timer extension.
        self:OnHeartClosed(); -- TODO: is it really needed ?
        self:AlertMe(self:Localize("HardModeTrigger"));

        self:ResetHealthThresholds(); -- No longer health thresholds on the boss bar.
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(33293, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
