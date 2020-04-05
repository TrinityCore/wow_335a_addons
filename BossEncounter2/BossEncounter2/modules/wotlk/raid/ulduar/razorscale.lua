local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Razorscale Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Razorscale fight.

-- 25-man version:
-- No change.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["TakeOffWarning"] = "deep breath",
        ["LandingWarning"] = "Move quickly!",
        ["LockedWarning"] = "grounded permanently!",
        ["HarpoonResetWarning"] = "Give us a moment",
        ["HarpoonResetShortWarning"] = "the turrets",
        ["HarpoonTriggerWarning"] = "Harpoon Turret",

        -- 2. Events
        ["TakeOff"] = "Breath & take off",
        ["Harpoon"] = "Harpoon %d/%d",
        ["Grounded"] = "Razorscale grounded permanently",

        -- 3. Misc
        ["DevouringFlameAlert"] = ">> Devouring Flame on %s <<",
        ["DevouringFlameSelf"] = "Do not stay here !",
        ["LandingAlert"] = ">> Razorscale is about to be locked on the ground ! <<",
        ["FocusAdvice"] = "It is recommanded you set the boss as /focus.",
    },
    ["frFR"] = {
        -- 1. Yells
        ["TakeOffWarning"] = "inspire",
        ["LandingWarning"] = "Faites vite",
        ["LockedWarning"] = "au sol pour de bon",
        ["HarpoonResetWarning"] = "Laissez un instant",
        ["HarpoonResetShortWarning"] = "Reconstruisons les tourelles",
        ["HarpoonTriggerWarning"] = "Tourelle à harpon",

        -- 2. Events
        ["TakeOff"] = "Souffle & décollage",
        ["Harpoon"] = "Harpon %d/%d",
        ["Grounded"] = "Tranchécaille au sol pour de bon",

        -- 3. Misc
        ["DevouringFlameAlert"] = ">> {rt7} Flame dévorante sur %s {rt7} <<",
        ["DevouringFlameSelf"] = "Ne restez pas là !",
        ["LandingAlert"] = ">> Tranchécaille va bientôt pouvoir être amenée au sol ! <<",
        ["FocusAdvice"] = "Il est recommandé de mettre en /focus le boss.",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnLanding",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Landing",
            ["frFR"] = "Annoncer les attérissages",
        },
        explain = {
            ["default"] = "Display a raid alert when Razorscale is about to be chained on the ground.",
            ["frFR"] = "Affiche une alerte de raid quand Tranchécaille est sur le point d'être enchainée au sol.",
        },
    },
--[[
    [2] = {
        id = "warnDevouringFlame",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Devouring Flame",
            ["frFR"] = "Annoncer les flammes dévorantes",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol each time a Devouring Flame is about to appear on a raid member.",
            ["frFR"] = "Affiche une alerte de raid et place un signe chaque fois qu'une flamme dévorante est sur le point d'apparaître sur un membre du raid.",
        },
    },
]]
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Razorscale";

local BERSERK_TIMER = 930;

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

        data.currentHarpoon = 0;
        data.lastTargetGUID = nil;
        data.lastDevouringFlame = -999;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.35, 0.35, 0.35, 0.35, 0.35); -- P/B/A/C/S

        self:PrepareBasicWidgets(BERSERK_TIMER, true);

        Root.Music.Play("PREPARATION_DUNGEON");

        --[[
        local focusGUID = UnitGUID("focus");
        if ( not focusGUID ) or ( focusGUID ~= data.guid ) then
            self:NotifyMe(self:Localize("FocusAdvice"), 0.500, 7.500);
        end
        ]]

        -- Register callbacks at once.

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("TakeOffWarning"), self.OnTakeOff, self);
        self:RegisterYellCallback("ANY", self:Localize("LandingWarning"), self.OnLanding, self);
        self:RegisterYellCallback(nil, self:Localize("LockedWarning"), self.OnLockedDown, self);
        self:RegisterYellCallback("ANY", self:Localize("HarpoonResetWarning"), self.OnHarpoonBegin, self, 55);
        self:RegisterYellCallback("ANY", self:Localize("HarpoonResetShortWarning"), self.OnHarpoonBegin, self, 20);
        self:RegisterYellCallback("ANY", self:Localize("HarpoonTriggerWarning"), self.OnHarpoonTriggered, self);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(240, 480);

        Root.Music.Play("TIER8_SURVIVAL2");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(BERSERK_TIMER, true);

        self:OnTakeOff();

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.50, self:Localize("Grounded"));
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( spellId == 63236 or spellId == 63816 ) and ( actorGUID ) and ( actorGUID == self.data.guid ) then
                self:OnDevouringFlameCast();
            end
        end,

        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( spellId == 62796 or spellId == 63815 ) and ( targetGUID ) then
                self:OnFireball(targetGUID);
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    DevouringOnBossTarget = function(self, try)
        local uid = Root.Unit.GetUID(self.data.guid);
        if ( uid ) then
            local tName = UnitName(uid.."target");
            local tGUID = UnitGUID(uid.."target");
            if ( tName and tGUID ) then
                if ( self:GetSetting("warnDevouringFlame") ) and ( not Root.IsBlacklisted(tName) ) then
                    self:AnnounceToRaid(self:FormatLoc("DevouringFlameAlert", tName));
                    self:PlaceSymbol(tGUID, 7, 5.00);
                end
                if tGUID == UnitGUID("player") then
                    self:AlertMe(self:Localize("DevouringFlameSelf"));
              else
                    local tUID = Root.Unit.GetUID(tGUID);
                    if ( tUID ) and ( Root.GetDistance(tUID) <= 10 ) then
                        self:AlertMe(self:Localize("DevouringFlameSelf"));
                    end
                end
                self:RegisterHealAssist(tGUID, 4, 10, nil);
          elseif ( try < 12 ) then
                -- Target not yet available. Try again 0.1 sec later !
                self.EventWatcher:GetDriver():AddEvent("DevouringFlameTarget", 0.100, "", "", "HIDDEN", self.DevouringOnBossTarget, self, try+1);
            end
        end
    end,

    ScheduleTakeOff = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("TakeOff", timer, "AUTO", self:Localize("TakeOff"), "ALERT");
    end,

    GetNumHarpoons = function(self)
        if ( Root.GetInstanceMode() == "HEROIC" ) then return 4; end
        return 2;
    end,

    ScheduleHarpoon = function(self, number, timer)
        self.EventWatcher:GetDriver():AddEvent("Harpoon"..number, timer, "AUTO", self:FormatLoc("Harpoon", number, self:GetNumHarpoons()), "NORMAL");
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnFireball = function(self, guid)
        self:RegisterHealAssist(guid, 1.5, 5);
    end,

    OnDevouringFlameCast = function(self)
        -- Seems like this will no longer work since 3.2.

        if ( self.status ~= "ENGAGED" ) then return; end
        self.data.lastDevouringFlame = GetTime();
        self.EventWatcher:GetDriver():AddEvent("DevouringFlameTarget", 0.300, "", "", "HIDDEN", self.DevouringOnBossTarget, self, 1);
    end,

    OnLanding = function(self)
        if ( self.data.phase == 2 or self.data.phase == 3 ) then return; end

        self:ChangePhase(2, true);

        self.BossBar:Display();
        self.EventWatcher:GetDriver():ClearEvent("HideBar");

        self:ScheduleTakeOff(38);
    end,

    OnLandingSoon = function(self)
        if ( self:GetSetting("warnLanding") ) then
            self:AnnounceToRaid(self:Localize("LandingAlert"));
        end
    end,

    OnTakeOff = function(self)
        if ( self.data.phase == 1 or self.data.phase == 3 ) then return; end

        self:ChangePhase(1, true);

        self.EventWatcher:GetDriver():TriggerEvent("TakeOff");

        self.EventWatcher:GetDriver():AddEvent("HideBar", 15, "", "", "HIDDEN", self.BossBar.Remove, self.BossBar);
    end,

    OnLockedDown = function(self)
        if ( self.data.phase == 3 ) then return; end

        self:ChangePhase(3, true);

        self.BossBar:Display();
        self.EventWatcher:GetDriver():ClearEvent("HideBar");
        self.EventWatcher:GetDriver():ClearEvent("TakeOff");
    end,

    OnHarpoonBegin = function(self, timer)
        self.data.currentHarpoon = 0;
        self:ScheduleHarpoon(1, timer);
    end,

    OnHarpoonTriggered = function(self)
        local ID = self.data.currentHarpoon + 1;
        self.data.currentHarpoon = ID;
        self.EventWatcher:GetDriver():TriggerEvent("Harpoon"..ID);

        local numHarpoons = self:GetNumHarpoons();
        if ( ID < numHarpoons ) then
            self:ScheduleHarpoon(ID + 1, 20);
            if ( ID == (numHarpoons-1)) then
                -- Special alert.
                self.EventWatcher:GetDriver():AddEvent("AboutToLandWarning", 10, "", "", "HIDDEN", self.OnLandingSoon, self);
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
    Root.NPCDatabase.Register(33186, THIS_MODULE, true);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
