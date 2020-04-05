local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Kologarn Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Kologarn fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["EyebeamFocusWarning"] = "focuses his eyes",

        -- 2. Events
        ["LeftArmRespawn"] = "Left arm respawn",
        ["RightArmRespawn"] = "Right arm respawn",
        ["Shockwave"] = "CD: Shockwave",
        ["Grip"] = "Grip",

        -- 3. Misc
        ["GripWarning"] = ">> Grip on: <<",
        ["GripAlert"] = "Attack Kologarn's hand !",
        ["GripSelf"] = "You have been gripped !",
        ["ArmorDebuffAlert"] = ">> %s has %d stacks of armor debuff !! <<",
        ["EyebeamDamageAlert"] = "You are in the beam !",
        ["EyebeamFocusAlert"] = "|cffffff00The beam pursues you !|r",
        ["KiteBeam"] = "Kite the beam !",
    },
    ["frFR"] = {
        -- 1. Yells
        ["EyebeamFocusWarning"] = "concentre son regard",

        -- 2. Events
        ["LeftArmRespawn"] = "Réapp. bras gauche",
        ["RightArmRespawn"] = "Réapp. bras droit",
        ["Shockwave"] = "Recharge: onde de choc",
        ["Grip"] = "Poigne",

        -- 3. Misc
        ["GripWarning"] = ">> Poigne sur: <<",
        ["GripAlert"] = "Attaquez la main de Kologarn !",
        ["GripSelf"] = "Vous avez été saisi !",
        ["ArmorDebuffAlert"] = ">> %s a %d empilements de l'affaiblissement d'armure !! <<",
        ["EyebeamDamageAlert"] = "Vous êtes dans le rayon !",
        ["EyebeamFocusAlert"] = "|cffffff00Le rayon vous poursuit !|r",
        ["KiteBeam"] = "Promenez le rayon !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnGrip",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn grips",
            ["frFR"] = "Annoncer les poignes",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol when someone gets gripped by Kologarn's hand.",
            ["frFR"] = "Afficher une alerte de raid et place un symbole quand quelqu'un est saisi par la main de Kologarn.",
        },
    },
    [2] = {
        id = "warnArmorDebuff",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn armor debuff (2+)",
            ["frFR"] = "Annoncer affaiblissement de l'armure (2+)",
        },
        explain = {
            ["default"] = "Display a raid alert when a tank gets 2 stacks or above of armor debuff.",
            ["frFR"] = "Affiche une alerte de raid quand un tank obtient 2 empilements ou plus de l'affaiblissement de l'armure.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Kologarn";

local GRIP_BREAK_DAMAGE_NORMAL = 100000;
local GRIP_BREAK_DAMAGE_HEROIC = 450000;

local LEFT_ARM_ID = 32933;
local RIGHT_ARM_ID = 32934;

local SpecialBarGripAlgorithm = {
    colors = {1.0, 0.2, 0.2}, -- R/G/B
    bounds = {0, 1}, -- min/max

    title = {
        ["default"] = "Grip release",
        ["frFR"] = "Relâcher poigne",
    },

    OnUpdate = function(self, elapsed)
        -- No parameter.
        local dmgValue, list, actor, threshold = Root[THIS_MODULE]:GetGripInfo();
        if not ( dmgValue ) then
            return "", "", 0;
        end

        local title = Root.ReadLocTable(self.title);
        local text = string.format("%d", dmgValue);

        return title, text, dmgValue / threshold;
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

        data.gripGUID = nil;
        data.gripList = {};
        data.gripHP = nil;
        data.rightArmDead = false;
        data.ignoreAdds = true;
        data.silentAddKills = true;
        data.armRespawnTimer = 49;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.55, 0.70, 0.40, 0.10, 0.15); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);

        self:ResetAdds();
        self:RegisterAdd(LEFT_ARM_ID, false);
        self:RegisterAdd(RIGHT_ARM_ID, false);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(150, 300);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER8_DPSRACE1");

        self.StatusFrame:GetDriver():StartTiming();

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("EyebeamFocusWarning"), self.OnEyebeamFocus, self);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...)
            if ( self.running ) then
                if ( self.data.gripGUID ) and ( targetGUID ) and ( targetGUID == self.data.gripGUID ) then
                    self:OnGripDamaged(select(3, ...));
                end
                if ( spellId == 63976 or spellId == 63346 or spellId == 63368 ) and ( targetGUID ) then
                    self:OnEyebeamDamage(targetGUID);
                end
                if ( spellId == 63783 or spellId == 63982 ) then
                    self:OnShockwave();
                end
            end

            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...);
        end,

        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                local id = Root.Unit.GetMobID(guid);
                if ( id == LEFT_ARM_ID ) then
                    self:ScheduleArmRespawn("Left", self.data.armRespawnTimer, LEFT_ARM_ID);
                    self.EventWatcher:GetDriver():ClearEvent("Shockwave");
            elseif ( id == RIGHT_ARM_ID ) then
                    self:ScheduleArmRespawn("Right", self.data.armRespawnTimer, RIGHT_ARM_ID);
                    self.EventWatcher:GetDriver():ClearEvent("Grip");
                    self.data.rightArmDead = true;
                end
            end

            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 64290 or spellId == 64292 ) and ( not Root.IsBlacklisted(targetName) ) then
                    self:OnGrip();
                    tinsert(self.data.gripList, targetGUID);
                    self:RegisterHealAssist(targetGUID, 0, 15, spellId);
                end
                if ( spellId == 63355 or spellId == 64002 ) and ( targetGUID ) and ( targetName ) then
                    self:OnArmorDebuff(stackAmount, targetGUID, targetName);
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 64290 or spellId == 64292 ) then
                self:OnGripEnd(targetGUID);
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },
  
    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    GetGripInfo = function(self)
        if ( self.status == "ENGAGED" ) then
            return self.data.gripHP, self.data.gripList, self.data.gripGUID, self:GetGripBreakThreshold();
        end
        return nil, nil, nil, self:GetGripBreakThreshold();
    end,

    GetGripBreakThreshold = function(self)
        if ( Root.GetInstanceMode() == "HEROIC" ) then return GRIP_BREAK_DAMAGE_HEROIC; end
        return GRIP_BREAK_DAMAGE_NORMAL;
    end,

    ScheduleArmRespawn = function(self, which, timer, respawnID)
        self.EventWatcher:GetDriver():AddEvent(which.."ArmRespawn", timer, "AUTO", self:Localize(which.."ArmRespawn"), "WARNING");
        self.EventWatcher:GetDriver():AddEvent(which.."ArmRegistration", timer - 5, "", "", "HIDDEN", self.OnRespawnSoon, self, respawnID);
    end,

    GetRightArmGUID = function(self)
        local i, id, guid;
        for i=1, self:GetNumAdds() do
            id, guid = self:GetAddInfo(i);
            if ( id == RIGHT_ARM_ID ) then
                return guid;
            end
        end
    end,

    AlertGrip = function(self)
        if ( self:GetSetting("warnGrip") ) then
            self:AnnounceUnitList(self.data.gripList, true, self:Localize("GripWarning"), 15.00);
        end
        local i, foundPlayer;
        foundPlayer = false;
        for i=1, #self.data.gripList do
            if ( self.data.gripList[i] == UnitGUID("player") ) then
                foundPlayer = true;
            end
        end
        if ( foundPlayer ) then
            self:AlertMe(self:Localize("GripSelf"));
    elseif ( self:HasRole("DPS") ) then
            self:AlertMe(self:Localize("GripAlert"));
        end
    end,

    ScheduleShockwave = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Shockwave", timer, "AUTO", self:Localize("Shockwave"), self:IfRole("HEALER", "WARNING_NOREMINDER", "NORMAL"));
    end,

    ScheduleGrip = function(self, timer)
        if ( self.data ) and ( self.data.rightArmDead ) then return; end
        self.EventWatcher:GetDriver():AddEvent("Grip", timer, "AUTO", self:Localize("Grip"), "NORMAL");
    end,

    RemoveDistanceCheck = function(self)
        self.UnitList:Remove();
        self.UnitList:GetDriver():Clear();
    end,

    CanCreditPendingDamage = function(self, guid)
        local id = Root.Unit.GetMobID(guid);
        if ( id == LEFT_ARM_ID ) or ( id == RIGHT_ARM_ID ) then
            return (self.status == "RUNNING"); -- Register pending damage done on the arm if the boss body is not dead yet.
        end
        return true;
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnGrip = function(self)
        if ( not self:EvaluateCooldown("grip", 5) ) then return; end

        self.EventWatcher:GetDriver():TriggerEvent("Grip");
        self.EventWatcher:GetDriver():AddEvent("AlertGrip", 0.250, "", "", "HIDDEN", self.AlertGrip, self);

        wipe(self.data.gripList);
        self.data.gripGUID = self:GetRightArmGUID();
        self.data.gripHP = self:GetGripBreakThreshold();

        self.SpecialBar:GetDriver():AssignAlgorithm(SpecialBarGripAlgorithm);
        self.SpecialBar:Display();
    end,

    OnGripEnd = function(self, guid)
        local i;
        for i=#self.data.gripList, 1, -1 do
            if ( self.data.gripList[i] == guid ) then
                tremove(self.data.gripList, i);
            end
        end
        if ( #self.data.gripList == 0 ) then
            self.data.gripGUID = nil;
            self.data.gripHP = nil;

            self.SpecialBar:Remove();

            self:ScheduleGrip(13.5);
        end
    end,

    OnGripDamaged = function(self, amount)
        if ( not self.running ) then return; end
        if ( not self.data.gripHP ) then return; end

        self.data.gripHP = max(0, self.data.gripHP - amount);
    end,

    OnShockwave = function(self)
        if ( not self:EvaluateCooldown("shockwave", 5) ) then return; end

        self.EventWatcher:GetDriver():TriggerEvent("Shockwave");
        self:ScheduleShockwave(16);
    end,

    OnArmorDebuff = function(self, count, guid, name)
        if ( count >= 2 ) then
            if ( self:GetSetting("warnArmorDebuff") ) then
                self:AnnounceToRaid(self:FormatLoc("ArmorDebuffAlert", name, count));
            end
            self:RegisterHealAssist(guid, 0, 5, nil);
        end
    end,

    OnRespawnSoon = function(self, respawnID)
        if ( respawnID == RIGHT_ARM_ID ) then
            self.data.rightArmDead = false;
        end
        self:RespawnAdd(respawnID);
    end,

    OnEyebeamDamage = function(self, guid)
        self:RegisterHealAssist(guid, 0, 3, nil);
        if ( guid == UnitGUID("player") ) then
            if ( not self:EvaluateCooldown("eyebeamAlert", 5) ) then return; end
            self:AlertMe(self:Localize("EyebeamDamageAlert"), 0.250, 4.000);
        end
    end,

    OnEyebeamFocus = function(self)
        self.data["CD:eyebeamAlert"] = GetTime() + 15; -- Prevent damage alerts, as the focus alert is enough by itself.
        self:AlertMe(self:Localize("EyebeamFocusAlert"), 0.250, 11.000);

        self.TimerReminder:GetDriver():Start(10, 15, self:Localize("KiteBeam"));

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 5, 1);
        self.EventWatcher:GetDriver():ClearEvent("HideUnitList");
        self.EventWatcher:GetDriver():AddEvent("HideUnitList", 12, "", "", "HIDDEN", self.RemoveDistanceCheck, self);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(32930, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
