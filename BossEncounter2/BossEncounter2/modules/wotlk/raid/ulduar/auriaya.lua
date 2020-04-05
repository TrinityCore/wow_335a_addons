local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Auriaya Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Auriaya fight.

-- 25-man version:
-- No change.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["FeralDefenderSpawn"] = "Feral Defender spawn",
        ["HorrifyingScreech"] = "Horrifying screech & Sentinel blast",
        ["SonicScreech"] = "CD: Sonic Screech",

        -- 3. Misc
        ["SonicScreechAlert"] = "Orient the boss toward the raid !",

    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["FeralDefenderSpawn"] = "App. défenseur farouche",
        ["HorrifyingScreech"] = "Hurlement terrifiant & Déflagration",
        ["SonicScreech"] = "Recharge: Hurlement sonore",

        -- 3. Misc
        ["SonicScreechAlert"] = "Orientez le boss vers le raid !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnSonicScreech",
        type = "BOOLEAN",
        defaultValue = false,
        label = {
            ["default"] = "Warn Sonic Screech",
            ["frFR"] = "Annoncer le Hurlement sonore",
        },
        explain = {
            ["default"] = "Display a personnal alert each time Auriaya is about to cast Sonic Screech. This option should be enabled by the main tank.",
            ["frFR"] = "Affiche une alerte personnelle chaque fois qu'Auriaya est sur le point de lancer Hurlement sonore. Il est conseillé au tank principal d'activer cette option.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Auriaya";

local FERAL_DEFENDER_ID = 34035;

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

        data.ignoreAdds = true;
        data.silentAddKills = true;
        data.firstSpawn = true;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.50, 0.60, 0.25, 0.15, 0.30); -- P/B/A/C/S

        self:PrepareBasicWidgets(600, true);

        self:ResetAdds();

        self:SetStrictRelevance(true);
        self:AddRelevantTargets(34014, 34034); -- Sentries and swarms are relevant targets. Feral defender is not.
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(300, 600);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER8_TANKNSPANK1");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(600, true);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleSonicScreech(58.4);
        self:ScheduleFeralDefenderSpawn(61);
        self:ScheduleHorrifyingScreech(39.5);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 64422 or spellId == 64688 ) then
                    self:OnSonicScreech();
                end
                if ( spellId == 64386 ) then
                    self:OnHorrifyingScreech();
                end
            end
        end,

        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                local id = Root.Unit.GetMobID(guid);
                if ( id == FERAL_DEFENDER_ID ) then
                    self:ScheduleFeralDefenderSpawn(30);
                end
            end

            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 64455 ) then
                -- Defender spawned. Does not fire for respawns.
                self:OnFeralDefenderSpawn();
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleFeralDefenderSpawn = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("FeralDefenderSpawn", timer, "AUTO", self:Localize("FeralDefenderSpawn"), self:IfRole("TANK", "WARNING_NOREMINDER", "NORMAL"));
        self.EventWatcher:GetDriver():AddEvent("FeralDefenderRegister", timer, "", "", "HIDDEN", self.OnFeralDefenderSpawn, self);
    end,

    ScheduleHorrifyingScreech = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("HorrifyingScreech", timer, "AUTO", self:Localize("HorrifyingScreech"), "WARNING_NOREMINDER");
    end,

    ScheduleSonicScreech = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("SonicScreech", timer, "AUTO", self:Localize("SonicScreech"), "ALERT");
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnSonicScreech = function(self)
        if ( self:GetSetting("warnSonicScreech") ) then
            self:AlertMe(self:Localize("SonicScreechAlert"), 0.300, 3.000);
        end
        self.EventWatcher:GetDriver():TriggerEvent("SonicScreech");
        self:ScheduleSonicScreech(29);
    end,

    OnFeralDefenderSpawn = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("FeralDefenderSpawn");
        self.EventWatcher:GetDriver():ClearEvent("FeralDefenderRegister");

        if ( self.data.firstSpawn ) then
            self.data.firstSpawn = false;
            self:RegisterAddEX(FERAL_DEFENDER_ID, false, "DISABLE");
      else
            self:RespawnAdd(FERAL_DEFENDER_ID);
        end
    end,

    OnHorrifyingScreech = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("HorrifyingScreech");
        self:ScheduleHorrifyingScreech(37.7);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(33515, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
