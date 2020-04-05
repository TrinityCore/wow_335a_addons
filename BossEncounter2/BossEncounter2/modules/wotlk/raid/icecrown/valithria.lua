local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Valithria Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Valithria fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["EngageTrigger"] = "Intruders have breached the inner sanctum",
        ["PortalTrigger"] = "I have opened a portal",

        -- 2. Events
        ["Skeleton"] = "Skeleton %d",
        ["Portal"] = "Portal",

        -- 3. Misc
        ["SkeletonWarning"] = ">> Skeleton soon! <<",
        ["SkeletonAlert"] = ">> {rt8} Skeleton seen! {rt8} <<",
        ["ManaVoidSelf"] = "Do not stay here!",
    },
    ["frFR"] = {
        -- 1. Yells
        ["EngageTrigger"] = "Des intrus",
        ["PortalTrigger"] = "un portail",

        -- 2. Events
        ["Skeleton"] = "Squelette %d",
        ["Portal"] = "Portail",

        -- 3. Misc
        ["SkeletonWarning"] = ">> Squelette bientôt ! <<",
        ["SkeletonAlert"] = ">> {rt8} Squelette repéré ! {rt8} <<",
        ["ManaVoidSelf"] = "Ne restez pas là !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnSkeleton",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn skeletons",
            ["frFR"] = "Annoncer les squelettes",
        },
        explain = {
            ["default"] = "Display a raid alert when a skeleton is seen and put the skull symbol on it.",
            ["frFR"] = "Affiche une alerte de raid et place le symbole crâne chaque fois qu'un squelette est aperçu.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Valithria";

local skeletonTimer = {
    60, 50, 55, 38, 44, 30, -- Due to the method used to detect, only rough approx is needed.
};

local manaVoid = {
    [71086] = true,
    [71179] = true,
    [71743] = true,
    [72030] = true,
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

        data.title = "Valithria";
        data.ignoreStandardClear = true;
        data.ignoreLeaveCombat = true;
        data.clearAnimation = "ALTERNATE";
        data.skeletonChecklist = { };
        data.skeletonCount = 0;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid, 60);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.75, 0.75, 0.75, 0.90, 0.75); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.50, 0.50, 0.50, 0.65, 0.50); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(nil, true);

        Root.Music.Play("PREPARATION_GENERAL");

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("EngageTrigger"), self.OnEngaged, self);
        self:RegisterYellCallback("ANY", self:Localize("PortalTrigger"), self.OnPortal, self);

        self:ScanSkeleton();
        self:ScanBossInCombat();
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        local themeDuration = Root.Music.GetLastMinuteThemeDuration();
        self.data.lastMinuteTimer = max(0, 420 - themeDuration);

        self:SetScoreBenchmarks(180, 360);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER9_SURVIVAL3");

        self.StatusFrame:GetDriver():StartTiming();

        self.EventWatcher:GetDriver():ClearEvent("ScanBossInCombat");

        self.data.bossAlreadyFighting = self.data.bossAlreadyFighting or UnitAffectingCombat("player");
        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleSkeleton(50, 1);
        self:SchedulePortal(46);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overdamage, school, special, resisted, blocked, absorbed)
            if ( self.running ) then
                if ( manaVoid[spellId] ) and ( (amount or 0) > 0 ) and ( targetGUID ) then
                    self:OnManaVoid(targetGUID);
                end
            end
            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overdamage, school, special, resisted, blocked, absorbed);
        end,

        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                if ( self.data.guid == guid ) then
                    self:OnFailed(true); -- Valithria has died.
                end
            end
            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 71189 ) then
                    self:OnCleared(); -- Valithria has been saved.
                end
            end
        end,

        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then

            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then

            end
        end,
    },
  
    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleSkeleton = function(self, timer, count)
	self.EventWatcher:GetDriver():AddEvent("Skeleton", timer, "AUTO", self:FormatLoc("Skeleton", count), self:IfRole("DPS", "WARNING", "NORMAL"));

        if self:GetSetting("warnSkeleton") then
	    self.EventWatcher:GetDriver():AddEvent("SkeletonWarning", timer - 5, "", "", "HIDDEN", self.AnnounceToRaid, self, self:Localize("SkeletonWarning"));
        end
    end,

    SchedulePortal = function(self, timer)
	self.EventWatcher:GetDriver():AddEvent("Portal", timer, "AUTO", self:Localize("Portal"), self:IfRole("HEALER", "WARNING_NOREMINDER", "NORMAL"));
    end,

    ScanSkeleton = function(self)
        self.EventWatcher:GetDriver():AddEvent("ScanSkeleton", 0.100, "", "", "HIDDEN", self.ScanSkeleton, self);

        local guid = Root.Unit.GetGUIDFromMobID(36791);
        if ( guid ) then
            local uid = Root.Unit.GetUID(guid);
            if ( uid ) then

                self:OnSkeletonSpawn(uid);
            end
        end
    end,

    ScanBossInCombat = function(self)
        if UnitGUID("boss1") == self.data.guid then
            self:OnEngaged();
      else
            self.EventWatcher:GetDriver():AddEvent("ScanBossInCombat", 0.500, "", "", "HIDDEN", self.ScanBossInCombat, self);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPortal = function(self)
	self.EventWatcher:GetDriver():TriggerEvent("Portal");

        self:SchedulePortal(46);
    end,

    OnSkeletonSpawn = function(self, uid)
        local guid = UnitGUID(uid);

        if ( self.data.skeletonChecklist[guid] ) then return; end

        self.data.skeletonChecklist[guid] = true;
        self.data.skeletonCount = self.data.skeletonCount + 1;

        if self:GetSetting("warnSkeleton") then
            self:AnnounceToRaid(self:Localize("SkeletonAlert"));
            self:PlaceSymbol(uid, 8);
        end

	self.EventWatcher:GetDriver():ClearEvent("SkeletonWarning");
	self.EventWatcher:GetDriver():TriggerEvent("Skeleton");

        local count = min(self.data.skeletonCount, #skeletonTimer);
        self:ScheduleSkeleton(skeletonTimer[count], self.data.skeletonCount + 1);

        self:OnEngaged(); -- In case you have been D/C.
    end,

    OnManaVoid = function(self, guid)
        if ( guid == UnitGUID("player") ) then
            if ( self:EvaluateCooldown("manaVoid", 4) ) then
                self:AlertMe(self:Localize("ManaVoidSelf"), 0.300, 3.000);
            end
        end
        self:RegisterHealAssist(guid, 0, 2, nil);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(36789, THIS_MODULE, false, true); -- Bypass the friendly check.

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
