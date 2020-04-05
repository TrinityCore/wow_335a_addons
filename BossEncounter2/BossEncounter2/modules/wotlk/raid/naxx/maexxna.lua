local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Maexxna Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Maexxna fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["WebSpray"] = "Web Spray",
        ["WebWrap"] = "Web Wrap",
        ["Spiders"] = "Spiders",
        ["Frenzy"] = "Maexxna gets frenzied",

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["WebSpray"] = "Jet de toile",
        ["WebWrap"] = "Entoilage",
        ["Spiders"] = "Araignées",
        ["Frenzy"] = "Maexxna devient enragée",

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Maexxna";

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

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.20, 0.35, 0.05, 0.05, 0.10); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);

        Root.Music.Play("PREPARATION_DUNGEON");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(150, 270);
        self:SetNearVictoryThreshold(0.10, nil, 0.70);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_NAXXRAMAS_ENDWING");

        self.StatusFrame:GetDriver():StartTiming();

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.30, self:Localize("Frenzy"));

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleWebWrap(20);
        self:ScheduleSpiders(30);
        self:ScheduleWebSpray(40);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( spellId == 29484 or spellId == 54125 ) then
                self:OnWebSpray();
            end
        end,
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 28776 ) then
                    self:RegisterHealAssist(targetGUID, 0, 5, spellId);
                end
                if ( spellId == 28622 ) then
                    self:OnWebWrap(targetGUID, targetName);
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleWebSpray = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("WebSpray", timer, "AUTO", self:Localize("WebSpray"), "WARNING_NOREMINDER");
    end,

    ScheduleWebWrap = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("WebWrap", timer, "AUTO", self:Localize("WebWrap"), "NORMAL");
    end,

    ScheduleSpiders = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Spiders", timer, "AUTO", self:Localize("Spiders"), self:IfRole("DPS", "WARNING_NOREMINDER", "NORMAL"));
    end,

    -- --------------------------------------------------------------------
    -- **                             Handlers                           **
    -- --------------------------------------------------------------------

    OnWebSpray = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("WebSpray");
        self:ScheduleWebWrap(20);
        self:ScheduleSpiders(30);
        self:ScheduleWebSpray(40);
    end,

    OnWebWrap = function(self, guid, name)
        self.EventWatcher:GetDriver():TriggerEvent("WebWrap");
        self:RegisterHealAssist(guid, 0, 20, 28622);
        if ( UnitGUID("player") == guid ) then
            Minimap:PingLocation();
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;

    -- Put in first argument the NPC ID of the boss that is being described.
    -- Set "true" in the third argument if the NPC apparears suddenly and might be selected too late by the player after spawning, thus triggering the module too late.

    Root.NPCDatabase.Register(15952, THIS_MODULE, false);


    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
