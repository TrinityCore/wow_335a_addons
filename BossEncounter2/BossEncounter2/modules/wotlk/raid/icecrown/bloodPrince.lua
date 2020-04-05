local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

local Distance = Root.GetOrNewModule("Distance");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Blood Prince Council Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Blood Prince Council fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["FlameTrigger"] = "Empowered Flames",

        -- 2. Events
        ["Switch"] = "Boss switch",

        -- 3. Misc
        ["Title"] = "Blood Council",
        ["EmpoweredShockAlert"] = "Shock incoming!",
        ["FocusWarning"] = ">> {rt8} %s is the new focus! {rt8} <<",
        ["FlamesSelf"] = "You're the target of the Empowered Flames!",
        ["FlamesWarning"] = ">> {rt7} Empowered Flames target: %s {rt7} <<",
        ["VortexAlert"]  = ">> {rt7} Vortex on: %s {rt7} <<",
        ["VortexSelf"]   = "Vortex on you!",
        ["VortexNearby"] = "Beware, vortex nearby!",
        ["PrisonSelf"] = "Watch your movements...",
    },
    ["frFR"] = {
        -- 1. Yells
        ["FlameTrigger"] = "Embrasement surpuissant",

        -- 2. Events
        ["Switch"] = "Changement",

        -- 3. Misc
        ["Title"] = "Conseil de sang",
        ["EmpoweredShockAlert"] = "Choc surpuissant imminent !",
        ["FocusWarning"] = ">> {rt8} %s est la nouvelle cible ! {rt8} <<",
        ["FlamesSelf"] = "Vous êtes la cible des flammes !",
        ["FlamesWarning"] = ">> {rt7} Cible des flammes : %s {rt7} <<",
        ["VortexAlert"]  = ">> {rt7} Vortex sur : %s {rt7} <<",
        ["VortexSelf"]   = "Vortex sur vous !",
        ["VortexNearby"] = "Prenez garde, vortex proche !",
        ["PrisonSelf"] = "Modérez vos déplacements !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnFocus",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn when focus changes",
            ["frFR"] = "Annoncer le changement de cible",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol when the main focus changes.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole quand la cible principale change.",
        },
    },
    [2] = {
        id = "warnFlames",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Show flames target",
            ["frFR"] = "Annoncer la cible des flammes",
        },
        explain = {
            ["default"] = "Display raid alerts and put symbols on targets of Empowered Flames.",
            ["frFR"] = "Affiche des alertes de raid et place des symboles sur les cibles des embrasements surpuissants.",
        },
    },
    [3] = {
        id = "warnVortex",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Shock Vortexes",
            ["frFR"] = "Annoncer les vortex",
        },
        explain = {
            ["default"] = "Display a raid alert and place symbols where shock vortexes spawn.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole là où les vortex apparaissent.",
        },
    },
    version = 2,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "BloodPrince";

local KELESETH_ID = 37972;
local VALANAR_ID = 37970;
local TALDARAM_ID = 37973;

local empoweredShockVortex = { -- 4.5s cast.
    [72039] = true,
    [73037] = true,
    [73038] = true,
    [73039] = true,
};

local shockVortex = { -- 1.5s cast.
    [72037] = true,
};

local switchBuff = {
    [70981] = true,
    [70982] = true,
    [70952] = true,
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

        self:SetDummyBossUnit("worldboss", 60, UnitAffectingCombat(uid)); -- No NPC is set as the main boss.

        data.title = self:Localize("Title");
        data.baseID = THIS_MODULE;

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.85, 0.90, 0.80, 0.70, 0.80); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.60, 0.70, 0.50, 0.60, 0.55); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(600, true);
        self.BossBar:Remove(true); -- Not used.

        Root.Music.Play("PREPARATION_GENERAL");

        self:ResetAdds();
        self:RegisterAdd(KELESETH_ID, false);
        self:RegisterAdd(VALANAR_ID,  false);
        self:RegisterAdd(TALDARAM_ID, false);

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 9, nil);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(270, 540);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER9_SURVIVAL1");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(600, true);

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("FlameTrigger"), self.OnFlames, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleSwitch(45);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( shockVortex[spellId] ) then
                    self:OnShockVortex();
                end
                if ( empoweredShockVortex[spellId] ) then
                    self:OnEmpoweredShockVortex();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( switchBuff[spellId] ) and ( targetGUID ) and ( targetName ) then
                    self:OnNewFocus(targetGUID, targetName);
                end
                if ( spellId == 72999 ) and ( targetGUID ) then
                    self:OnPrison(targetGUID);
                end

            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    EnableDistanceCheck = function(self, duration)
        -- The unit list will flash as soon as there is someone next to you.
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 9, 1);

        self.EventWatcher:GetDriver():ClearEvent("DisableCheck");
        self.EventWatcher:GetDriver():AddEvent("DisableCheck", duration, "", "", "HIDDEN", self.DisableDistanceCheck, self);
    end,

    DisableDistanceCheck = function(self)
        -- The unit list no longer flashes when there's someone next to you.
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 9, nil);
    end,

    ScheduleSwitch = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Switch", timer, "AUTO", self:Localize("Switch"), "WARNING");
    end,

    VortexOnBossTarget = function(self, try)
        local valanarGUID = self:GetAddGUID(VALANAR_ID);
        if ( valanarGUID ) then
            local guid, name, uid = self:GetTargetInfo(valanarGUID);
            if ( guid and name ) then
                if ( self:GetSetting("warnVortex") ) then
                    self:AnnounceToRaid(self:FormatLoc("VortexAlert", name));
                    self:PlaceSymbol(guid, 7, 4.00);
                end
                if guid == UnitGUID("player") then
                    self:AlertMe(self:Localize("VortexSelf"), 0.500, 2.500);
              else
                    if ( uid ) and ( Distance:Get("player", uid) <= 9 ) then
                        self:AlertMe(self:Localize("VortexNearby"), 0.500, 2.500);
                    end
                end
          elseif ( try < 10 ) then
                -- Target not yet available. Try again 0.1 sec later !
                self.EventWatcher:GetDriver():AddEvent("ShockVortexTarget", 0.100, "", "", "HIDDEN", self.VortexOnBossTarget, self, try+1);
            end
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnNewFocus = function(self, guid, name)
        self.EventWatcher:GetDriver():TriggerEvent("Switch");
        self:ScheduleSwitch(45);

        if ( self:GetSetting("warnFocus") ) then
            self:AnnounceToRaid(self:FormatLoc("FocusWarning", name));
            self:PlaceSymbol(guid, 8);
        end 
    end,

    OnEmpoweredShockVortex = function(self)
        self:EnableDistanceCheck(5);

        self:AlertMe(self:Localize("EmpoweredShockAlert"), 0.300, 3.500);
    end,

    OnShockVortex = function(self)
        self.EventWatcher:GetDriver():AddEvent("ShockVortexTarget", 0.200, "", "", "HIDDEN", self.VortexOnBossTarget, self, 1);
    end,

    OnFlames = function(self, target)
        if target == UnitName("player") then
            self:AlertMe(self:Localize("FlamesSelf"));
        end
        if ( self:GetSetting("warnFlames") ) then
            self:AnnounceToRaid(self:FormatLoc("FlamesWarning", target));
            self:PlaceSymbol(target, 7);
        end 
    end,

    OnPrison = function(self, guid)
        if not self:EvaluateCooldown("prison", 2.5) then
            return;
        end
        if ( guid == UnitGUID("player") ) then
            self:AlertMe(self:Localize("PrisonSelf"), 0.300, 3.000);
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(KELESETH_ID, THIS_MODULE, true);
    Root.NPCDatabase.Register(VALANAR_ID, THIS_MODULE, true);
    Root.NPCDatabase.Register(TALDARAM_ID, THIS_MODULE, true);
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
