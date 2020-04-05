local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Marrowgar Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Marrowgar fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["NextWhirlwind"] = "CD: Whirlwind",
        ["WhirlwindEnd"] = "End of Whirlwind",

        -- 3. Misc
        ["Title"] = "Marrowgar",
        ["ImpaleSelf"] = "You have been impaled!",
        ["ImpaleAlert"] = ">> Impaled: <<",
        ["FireSelf"] = "|cff8080ffAvoid flames!|r",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["NextWhirlwind"] = "Prochain tourbillon",
        ["WhirlwindEnd"] = "Tourbillon: fin",

        -- 3. Misc
        ["Title"] = "Gargamoelle",
        ["ImpaleSelf"] = "Vous avez été empalé !",
        ["ImpaleAlert"] = ">> Empalé : <<",
        ["FireSelf"] = "|cff8080ffEvitez les flammes!|r",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnImpale",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Impale",
            ["frFR"] = "Annoncer les empalements",
        },
        explain = {
            ["default"] = "Allows you to display the list of people getting impaled.",
            ["frFR"] = "Permet d'annoncer la liste des personnes se retrouvant empalées.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Marrowgar";

local BOSS_ID = 36612;
local BONE_ID_1 = 36619;
local BONE_ID_2 = 38712;
local BONE_ID_3 = 38711;

local impale = {
    [69062] = true,
    [69065] = true,
};

local flame = {
    [69146] = true,
    [70823] = true,
    [70824] = true,
    [70825] = true,
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

        self:SetBossUnit(uid);

        data.title = self:Localize("Title");
        data.ignoreAdds = true;
        data.silentAddKills = true;
        data.impaleList = {};
        data.whirlwindDuration = 20;

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.80, 0.90, 0.90, 0.70, 0.60); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.60, 0.70, 0.70, 0.50, 0.40); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(600, true);

        self:ResetAdds();
        self:RegisterAddEX(BONE_ID_1, false, "DB");
        self:RegisterAddEX(BONE_ID_2, false, "DB");
        self:RegisterAddEX(BONE_ID_3, false, "DB");

        Root.Music.Play("PREPARATION_GENERAL");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self.data.whirlwindDuration = 34;
      else
            self.data.whirlwindDuration = 20;
        end

        self:SetScoreBenchmarks(300, 600);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_MADNESS");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(600, true);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleWhirlwind(45);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( impale[spellId] ) and ( targetGUID ) and ( targetName ) then
                    self:OnImpale();
                    tinsert(self.data.impaleList, targetGUID);
                    self:RegisterHealAssist(targetGUID, 0, 30, spellId);
                end
                if ( flame[spellId] ) and ( targetGUID ) then
                    self:RegisterHealAssist(targetGUID, 0, 5, spellId);
                    if ( targetGUID == UnitGUID("player") ) then
                        self:OnSelfFlame();
                    end
                end
                if ( spellId == 69076 ) then
                    self:OnWhirlwind();
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 69076 ) then
                self:OnWhirlwindEnd();
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    AlertImpale = function(self)
        if ( self:GetSetting("warnImpale") ) then
            self:AnnounceUnitList(self.data.impaleList, true, self:Localize("ImpaleAlert"), 10.00);
        end
        local i;
        for i=1, #self.data.impaleList do
            if ( self.data.impaleList[i] == UnitGUID("player") ) then
                self:AlertMe(self:Localize("ImpaleSelf"));
                return;
            end
        end
    end,

    ScheduleWhirlwind = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("NextWhirlwind", timer, "AUTO", self:Localize("NextWhirlwind"), "WARNING");
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnImpale = function(self)
        if ( not self:EvaluateCooldown("impale", 5) ) then return; end

        self:RespawnAdd(BONE_ID_1);
        self:RespawnAdd(BONE_ID_2);
        self:RespawnAdd(BONE_ID_3);

        self.EventWatcher:GetDriver():AddEvent("AlertImpale", 0.150, "", "", "HIDDEN", self.AlertImpale, self);

        wipe(self.data.impaleList);
    end,

    OnWhirlwind = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("NextWhirlwind");
        self.EventWatcher:GetDriver():AddEvent("WhirlwindEnd", self.data.whirlwindDuration, "AUTO", self:Localize("WhirlwindEnd"), self:IfRole("OFFENSIVE", "ALERT", "WARNING"));
        self:ScheduleWhirlwind(70 + self.data.whirlwindDuration);
    end,

    OnWhirlwindEnd = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("WhirlwindEnd");
    end,

    OnSelfFlame = function(self)
        self:AlertMe(self:Localize("FireSelf"), 0.150, 1.500);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(BOSS_ID, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
