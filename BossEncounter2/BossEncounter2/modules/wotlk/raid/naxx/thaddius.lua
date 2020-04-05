local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Thaddius Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Thaddius fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["ThaddiusIncoming"] = "overloads",

        -- 2. Events
        ["MagneticPull"] = "Magnetic Pull",
        ["ThaddiusActivation"] = "Thaddius coming",
        ["PolarityShift"] = "Polarity Shift",

        -- 3. Misc
        ["PolarityShiftWarning"] = ">> Watch your polarity ! <<",
        ["MinusMove"] = "%s <<< MINUS <<<",
        ["PlusMove"] = ">>> PLUS >>> %s",
        ["Advance"] = "Advance: %d%%",
        ["Delay"] = "Delay: %d%%",
        ["ExplainAssist"] = ">> If you get a symbol, place yourself on the '+' side. <<",
        ["PolaritySelf-"] = "You are [|cffff2020-|r] now !!",
        ["PolaritySelf+"] = "You are [|cff3030ff+|r] now !!",
    },
    ["frFR"] = {
        -- 1. Yells
        ["ThaddiusIncoming"] = "entre en surcharge",

        -- 2. Events
        ["MagneticPull"] = "Attraction",
        ["ThaddiusActivation"] = "Thaddius arrive",
        ["PolarityShift"] = "Chang. polarité",

        -- 3. Misc
        ["PolarityShiftWarning"] = ">> Regardez votre signe ! <<",
        ["MinusMove"] = "%s <<< MOINS <<<",
        ["PlusMove"] = ">>> PLUS >>> %s",
        ["Advance"] = "Avance: %d%%",
        ["Delay"] = "Retard: %d%%",
        ["ExplainAssist"] = ">> Si vous obtenez un symbole, placez-vous du côté des '+'. <<",
        ["PolaritySelf-"] = "Vous êtes [|cffff2020-|r] maintenant !!",
        ["PolaritySelf+"] = "Vous êtes [|cff3030ff+|r] maintenant !!",
    },
};

local POSITIVE_CHARGE = {
    ["default"] = "Positive Charge",
    ["frFR"] = "Charge positive",
};

local NEGATIVE_CHARGE = {
    ["default"] = "Negative Charge",
    ["frFR"] = "Charge négative",
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnDelays",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn delays",
            ["frFR"] = "Annoncer les retards",
        },
        explain = {
            ["default"] = "Display each minute the delay on the % of boss life.",
            ["frFR"] = "Affiche le retard à chaque minute sur le % de vie du boss.",
        },
    },
    [2] = {
        id = "warnSwitches",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn switches",
            ["frFR"] = "Annoncer les changements",
        },
        explain = {
            ["default"] = "Warn the polarity shifts. In 10-man version, symbols will also be put on the '+' side.",
            ["frFR"] = "Prévient des changements de polarité. Pour la version 10, des symboles seront également placés sur le côté '+'.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Thaddius";

local UnitListPolarityAlgorithm = {
    updateRate = 0.500,

    title = {
        ["default"] = "Polarities",
        ["frFR"] = "Polarités",
    },
    summary = {
        ["default"] = "Be careful when switching !",
        ["frFR"] = "Attention aux changements !",
    },

    OnRefresh = function(self, driver, myTable)
        local i, guid, name, uid;
        local symbolAuth = Root.CheckAuth("SYMBOL") and Root[THIS_MODULE]:GetSetting("warnSwitches");

        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            if ( uid ) then
                if ( UnitInParty(uid) or UnitInRaid(uid) ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitIsVisible(uid) ) then
                    local isMinus = Root.Unit.SearchEffect(uid, "DEBUFF", Root.ReadLocTable(NEGATIVE_CHARGE));
                    local isPlus = Root.Unit.SearchEffect(uid, "DEBUFF", Root.ReadLocTable(POSITIVE_CHARGE));

                    if (( not isMinus ) and ( not isPlus )) then
                        if ( GetRaidTargetIndex(uid) ~= 0 ) and ( symbolAuth ) then
                            SetRaidTarget(uid, 0);
                        end
                  else
                        local unitTable = driver:Allocate();
                        if ( isPlus ) then
                            unitTable.text = "+";
                            unitTable.r = 0.00;
                            unitTable.b = 1.00;
                      else
                            unitTable.text = "-";
                            unitTable.r = 1.00;
                            unitTable.b = 0.00;
                        end
                        unitTable.guid = guid;
                        unitTable.g = 0.00;
                        myTable[#myTable+1] = unitTable;
                    end
                end
            end
        end
        table.sort(myTable, self.MySortFunction);
        if ( symbolAuth ) then
            local targetSet;
            for i=1, #myTable do
                if ( myTable[i].text == "+" ) and ( i <= 8 ) then
                    targetSet = 9-i;
               else
                    targetSet = 0;
                end
                uid = Root.Unit.GetUID(myTable[i].guid);
                if ( GetRaidTargetIndex(uid) ~= targetSet ) then
                    SetRaidTarget(uid, targetSet);
                end
            end
        end
        local title = Root.ReadLocTable(self.title);
        local summary = Root.ReadLocTable(self.summary);
        return title, summary;
    end,

    MySortFunction = function(item1, item2)
        if ( item1.text == "+" and item2.text == "-" ) then return true; end
        return false;
    end,
};

local FIRST_ADD_ID = 15929;
local SECOND_ADD_ID = 15930;
local THADDIUS_ID = 15928;

local REVIVABLE_ADDS = {
    [FIRST_ADD_ID] = true,
    [SECOND_ADD_ID] = true,
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

        self:SetDummyBossUnit("worldboss", 45, UnitAffectingCombat(uid));
        data.ignoreAdds = true;
        data.bossDead = false;

        data.polarity = { };
        data.achievementFailed = false;

        data.title = "Thaddius";
        data.baseID = THIS_MODULE;

        self:SetDifficultyMeter(0.30, 0.15, 0.25, 0.45, 0.50); -- P/B/A/C/S

        self:PrepareBasicWidgets(360, true);
        self.BossBar:Remove(true); -- Do not show the boss bar yet.

        Root.Music.Play("PREPARATION_BADGUY");

        -- Now handle adds and their bars.
        -- Revive system can't be used here because the adds have a fake death.

        self:ResetAdds();
        self:RegisterAddEX(FIRST_ADD_ID, false, "DISABLE");
        self:RegisterAddEX(SECOND_ADD_ID, false, "DISABLE");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:ChangePhase(1, true);

        Root.Music.Play("THEME_MECHANICAL");

        self:SetScoreBenchmarks(300, 480);

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("ThaddiusIncoming"), self.OnPhaseTwo, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleMagneticPull();
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( spellId == 28089 ) and ( actorGUID ) and ( actorGUID == self.data.guid ) then
                self:OnPolarityShiftCasting();
            end
        end,

        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...)
            if ( self.running ) and ( spellId == 28059 or spellId == 28084 ) then
                if ( not self.data.achievementFailed ) then
                    self.data.achievementFailed = true;
                    -- self:AnnounceToRaid(">> Le HF vient d'être loupé, gg ! <<");
                end
            end

            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...);
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleMagneticPull = function(self)
        self.EventWatcher:GetDriver():AddEvent("MagneticPull", 20.5, "AUTO", self:Localize("MagneticPull"), self:IfRole("SHIELD", "WARNING", "NORMAL"), self.OnMagneticPull, self);
    end,

    SchedulePolarityShift = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("PolarityShift", timer, "AUTO", self:Localize("PolarityShift"), "ALERT");
    end,

    ComparePolarity = function(self, silent)
        local polarity = self.data.polarity;
        local plusList = "";
        local minusList = "";

        -- OK, build the list of affected people and compare it with the old one.
        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            if ( uid ) then
                if ( UnitInParty(uid) or UnitInRaid(uid) ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitIsVisible(uid) ) then
                    local isMinus = Root.Unit.SearchEffect(uid, "DEBUFF", Root.ReadLocTable(NEGATIVE_CHARGE));
                    local isPlus = Root.Unit.SearchEffect(uid, "DEBUFF", Root.ReadLocTable(POSITIVE_CHARGE));
                    local oldPolarity, currentPolarity;

                    -- Combine the booleans in an easier to read string and get the old polarity.
                    oldPolarity = polarity[guid] or "N";
                    if ( isMinus ) then
                        currentPolarity = "-";
                elseif ( isPlus ) then
                        currentPolarity = "+";
                  else
                        currentPolarity = "N";
                    end

                    -- Check if polarity changed and if it's not neutral.
                    if ( currentPolarity ~= oldPolarity ) then
                        if ( currentPolarity == "-" ) then
                            if ( minusList == "" ) then
                                minusList = name;
                          else
                                minusList = minusList..", "..name;
                            end
                    elseif ( currentPolarity == "+" ) then
                            if ( plusList == "" ) then
                                plusList = name;
                          else
                                plusList = plusList..", "..name;
                            end
                        end
                        if ( currentPolarity ~= "N" and oldPolarity ~= "N" ) then self:RegisterHealAssist(guid, 5, 10, nil); end

                        if ( currentPolarity ~= "N" ) and ( name == UnitName("player") ) then
                            -- That's our polarity !
                            self:AlertMe(self:Localize("PolaritySelf"..currentPolarity), 0.400, 2.500);
                        end
                    end

                    polarity[guid] = currentPolarity;
                end
            end
        end

        -- OK, print the change list if needed.
        if ( not silent ) then
            if ( minusList ~= "" ) then
                self:AnnounceToRaid(self:FormatLoc("MinusMove", minusList));
            end
            if ( plusList ~= "" ) then
                self:AnnounceToRaid(self:FormatLoc("PlusMove", plusList));
            end
        end
    end,

    ShowAdvance = function(self, expectedHealthPct)
        local uid = Root.Unit.GetUID(self.data.guid);
        if ( uid ) and ( self:GetSetting("warnDelays") ) then
            local health = UnitHealth(uid);
            local max = UnitHealthMax(uid);
            local pct = health / max;
            local delta = expectedHealthPct - pct;

            if delta > 0 then
                self:AnnounceToRaid(self:FormatLoc("Advance", delta*100));
          else
                self:AnnounceToRaid(self:FormatLoc("Delay", -delta*100));
            end
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnMagneticPull = function(self)
        if ( not self:EvaluateCooldown("magneticPull", 10) ) then return; end

        self:ScheduleMagneticPull();
    end,

    OnPhaseTwo = function(self)
        if ( self.data.phase == 2 ) then return; end
        self:ChangePhase(2, true);

        self.EventWatcher:GetDriver():ClearEvent("MagneticPull");

        self.data.timeOut = 60;
        self.data.timeOutTimer = 0;

        self:SearchUnit(THADDIUS_ID, self.OnBossFound);

        self.EventWatcher:GetDriver():AddEvent("ThaddiusActivation", 5, "AUTO", self:Localize("ThaddiusActivation"), "ALERT");
        self:RemoveAddsWidgets();

        Root.Music.Stop();
        self.StatusFrame:SetBlinking(true);

        -- The polarity unit list tool is only really useable in 10-man version.
        if not ( Root.GetInstanceMode() == "HEROIC" ) then
            if ( self:GetSetting("warnSwitches") ) then
                self:AnnounceToRaid(self:Localize("ExplainAssist"));
            end
            self.UnitList:GetDriver():AssignAlgorithm(UnitListPolarityAlgorithm);
            self.UnitList:Display();
        end

        self:ComparePolarity(true);

        self:CreditPendingDamage("ADDS");
    end,

    OnBossFound = function(self, uid)
        self.data.name = UnitName(uid);
        self.data.guid = UnitGUID(uid);
        self.data.bossMaxHealth = UnitHealthMax(uid);

        self.BossBar:Display();
        self.BossBar:GetDriver():SetWatch(self.data.guid);

        self.StatusFrame:SetBlinking(false);
        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(360, true);

        self:SchedulePolarityShift(15);
        Root.Music.Play("THEME_NAXXRAMAS_ENDWING");

        self:SetNearVictoryThreshold(0.15, self.data.globalTimer+360-40, 0.80); -- Near Victory theme when the boss gets below 15%, the time left is above 40 seconds and 80% of the raid is alive.

        self.EventWatcher:GetDriver():AddEvent("ShowAdvance1",  60, "", "", "HIDDEN", self.ShowAdvance, self, 0.8333);
        self.EventWatcher:GetDriver():AddEvent("ShowAdvance2", 120, "", "", "HIDDEN", self.ShowAdvance, self, 0.6666);
        self.EventWatcher:GetDriver():AddEvent("ShowAdvance3", 180, "", "", "HIDDEN", self.ShowAdvance, self, 0.5000);
        self.EventWatcher:GetDriver():AddEvent("ShowAdvance4", 240, "", "", "HIDDEN", self.ShowAdvance, self, 0.3333);
        self.EventWatcher:GetDriver():AddEvent("ShowAdvance5", 300, "", "", "HIDDEN", self.ShowAdvance, self, 0.1666);
    end,

    OnPolarityShiftCasting = function(self)
        local warn = self:GetSetting("warnSwitches");
        local showList = ( Root.GetInstanceMode() ~= "HEROIC" ) and ( warn );

        if ( warn ) then
            self:AnnounceToRaid(self:Localize("PolarityShiftWarning"));
        end

        -- 1 fake second is added to the effective casting time, to make up for debuff update latency.
        self.EventWatcher:GetDriver():AddEvent("ComparePolarity", 4, "", "", "HIDDEN", self.ComparePolarity, self, (not showList));

        self:SchedulePolarityShift(31);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;

    -- Any of these two NPCs will trigger the module.
    Root.NPCDatabase.Register(FIRST_ADD_ID, THIS_MODULE, true);
    Root.NPCDatabase.Register(SECOND_ADD_ID, THIS_MODULE, true);



    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
