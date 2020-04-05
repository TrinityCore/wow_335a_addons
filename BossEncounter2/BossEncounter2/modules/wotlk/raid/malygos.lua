local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Malygos Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Malygos fight.

-- 25-man version:
-- 4 melee and 8 caster adds (instead of 2, 4)

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["Phase2"] = "I had hoped to end your lives quickly",
        ["PhaseEnd2"] = "If you intend to reclaim",
        ["Phase3"] = "Now your benefactors make their",
        ["Surge"] = "gaze",

        -- 2. Events
        ["Spark"] = "Spark spawns",
        ["Vortex"] = "Vortex",
        ["VortexEnd"] = "End of Vortex",
        ["DeepBreath"] = "Breath",
        ["TakeOff"] = "Malygos takes off",

        -- 3. Misc
        ["SurgeAlert"] = "Shield yourself !",
        ["SparkStatus"] = "Spark %d",
        ["MalygosPowerup"] = ">> Malygos got the powerup !! <<",
        ["Phase3Advice1"] = "Put as many DoT stacks as possible to defeat Malygos.",
        ["Phase3Advice2"] = "Do |cffff0000NOT|r let the DoT expire !",
    },
    ["frFR"] = {
        -- 1. Yells
        ["Phase2"] = "Je pensais mettre rapidement",
        ["PhaseEnd2"] = "Si c'est la magie",
        ["Phase3"] = "Vos bienfaiteurs font enfin",
        ["Surge"] = "regard",

        -- 2. Events
        ["Spark"] = "Arrivée étincelle",
        ["Vortex"] = "Vortex",
        ["VortexEnd"] = "Fin du Vortex",
        ["DeepBreath"] = "Souffle",
        ["TakeOff"] = "Malygos décolle",

        -- 3. Misc
        ["SurgeAlert"] = "Activez le bouclier !",
        ["SparkStatus"] = "Etinc. %d",
        ["MalygosPowerup"] = ">> Malygos a reçu le powerup !! <<",
        ["Phase3Advice1"] = "Placez autant d'empilements du DoT que possible pour vaincre Malygos.",
        ["Phase3Advice2"] = "Ne laissez |cffff0000PAS|r le DoT expirer !",
    },
};

local ENGULF_SPELLID = 56092;
local ENGULF_NAME = GetSpellInfo(ENGULF_SPELLID);
local ARCANE_BARRAGE_NAME = GetSpellInfo(56397);

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnPowerup",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Malygos Powerup",
            ["frFR"] = "Annoncer les powerups sur Malygos",
        },
        explain = {
            ["default"] = "Display a raid alert whenever Malygos gets the damage increase from a power spark.",
            ["frFR"] = "Affiche une alerte de raid chaque fois que Malygos obtient l'augmentation de ses dégâts via une étincelle de puissance.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Malygos";

local ADD_ID_MELEE = 30245;
local ADD_ID_CASTER = 30249;

local SpecialBarEngulfAlgorithm = {
    colors = {1.0, 0.0, 0.2}, -- R/G/B
    bounds = {0, 1}, -- min/max

    title = {
        ["default"] = "DoT expiration",
        ["frFR"] = "Expiration du DoT",
    },

    OnUpdate = function(self, elapsed)
        -- Parameter1: timeLeft
        -- Parameter2: duration
        local vars = self.parameters;
        if ( not vars[1] ) or ( not vars[2] ) then
            return "", "", 0;
        end

        if ( vars[1] > 0 ) then
            vars[1] = max(0, vars[1] - elapsed);

            if ( vars[1] == 0 ) then
                Root[THIS_MODULE]:OnEngulfBarExpired();
            end
        end

        -- Dynamically change the colors.
        self.colors[1] = 1 - (vars[1] / vars[2])^0.75;  -- R
        self.colors[2] = (vars[1] / vars[2])^1.5;       -- G

        local count = Root[THIS_MODULE]:GetMyEngulfInfo();
        count = max(1, count);
        local title = Root.ReadLocTable(self.title);
        local text = string.format("|cffffff00x%d|r (%d s)", count, vars[1]);

        return title, text, vars[1] / vars[2];
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

        data.sparkCount = 0;
        data.meleeCount = 0;
        data.casterCount = 0;
        data.myDrake = nil;
        data.engulfCount = 0;
        data.engulfDuration = 0;
        data.engulfStart = 0;

        self:GrabStaticWidgets();

        data.title = "Malygos";
        data.clearSequence = "FINAL";

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.65, 0.75, 0.75, 0.30, 0.50); -- P/B/A/C/S

        self:PrepareBasicWidgets(600, true);

        Root.Music.Play("PREPARATION_DUNGEON");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(360, 600);
        self:SetNearVictoryThreshold(0.075, 600-60, 0.70); -- Near Victory theme when the boss gets below 7.5%, the time left is above 1 minute and 70% of the raid is alive.

        self:ChangePhase(1, true);

        Root.Music.Play("THEME_ULTIMATE");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(600, true);

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("Phase2"), self.OnPhaseTwo, self);
        self:RegisterYellCallback(nil, self:Localize("PhaseEnd2"), self.OnPhaseTwoEnd, self);
        self:RegisterYellCallback(nil, self:Localize("Phase3"), self.OnPhaseThree, self);
        self:RegisterYellCallback("ANY", self:Localize("Surge"), self.OnSelfSurge, self);

        self:ResetHealthThresholds();
        self:RegisterHealthThreshold(0.50, self:Localize("TakeOff"));

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleSpark(25);
        self:ScheduleVortex(29);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        if ( not self.data.myDrake ) then
            -- Poll in case we get a vehicle in the meantime.
            local vehicleGUID = UnitGUID("vehicle");
            if ( vehicleGUID and self.data.phase == 3 ) then
                self.data.myDrake = vehicleGUID;
            end
        end

        Shared.OnUpdate(self, elapsed);
    end,

    OnCombatEvent = {
        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) and ( guid ) then
                local id = Root.Unit.GetMobID(guid);
                if ( id == ADD_ID_MELEE ) then
                    self.data.meleeCount = self.data.meleeCount + 1;
                    self:UpdateAddCounter();
                end
                if ( id == ADD_ID_CASTER ) then
                    self.data.casterCount = self.data.casterCount + 1;
                    self:UpdateAddCounter();
                end
            end

            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,

        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 56105 ) then
                    self:OnVortex();
            elseif ( spellName == ARCANE_BARRAGE_NAME ) then
                    self:OnArcaneBarrage(targetGUID, targetName);
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 56152 ) and ( targetGUID == self.data.guid ) then
                self:OnMalygosPowerSpark();
            end
            if ( self.running ) and ( spellId == ENGULF_SPELLID ) and ( targetGUID == self.data.guid ) then
                if ( self.data.myDrake ) and ( actorGUID ) and ( actorGUID == self.data.myDrake ) then
                    self:OnEngulfStack(stackAmount);
                end
            end
        end,
    },

    OnMobYell = function(self, msg, source, channel, target)
        if ( not self.running ) then return; end

        if ( channel == "RAID_EMOTE" ) then
            if ( self.data.phase == 1 ) then
                -- Spark.
                self:OnSpark();

        elseif ( self.data.phase == 2 ) then
                -- Breath.
                self:OnDeepBreath();
            end
        end

        Shared.OnMobYell(self, msg, source, channel, target);
    end, 

    OnVehicleExited = function(self)
        if ( not self.running ) then return; end

        self.data.myDrake = nil;
    end,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleSpark = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Spark", timer, "AUTO", self:Localize("Spark"), self:IfRole("OFFENSIVE", "WARNING_NOREMINDER", "NORMAL"));  
    end,

    ScheduleVortex = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Vortex", timer, "AUTO", self:Localize("Vortex"), "WARNING");
    end,

    ScheduleDeepBreath = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("DeepBreath", timer, "AUTO", self:Localize("DeepBreath"), "WARNING_NOREMINDER");
    end,

    UpdateAddCounter = function(self)
        if ( self.data.phase ~= 2 ) then return; end
        local melee, caster = self:GetAddCounts();
        self.StatusFrame:SetStatus("TEXT", string.format("%d/%d   %d/%d", self.data.meleeCount, melee, self.data.casterCount, caster), true);
        Root.Sound.Play("ADDCHANGE");
    end,

    GetAddCounts = function(self)
        if ( Root.GetInstanceMode() == "HEROIC" ) then return 4, 8; end
        return 2, 4;
    end,

    GetMyEngulfInfo = function(self)
        if ( not self.running ) then return 0, 0, 0; end

        local count, timeLeft, duration;

        count = self.data.engulfCount or 0;
        duration = self.data.engulfDuration or 0;
        timeLeft = max(0, duration - (GetTime() - self.data.engulfStart or 0));

        return count, timeLeft, duration;
    end,

    ValidateEngulf = function(self, count, timeLeft, duration)
        self.SpecialBar:GetDriver():AssignAlgorithm(SpecialBarEngulfAlgorithm, timeLeft, duration);
        self.SpecialBar:Display();
    end,

    TestDrake = function(self, enemy) -- For development / debugging purposes.
        self:Test(enemy);
        if ( self.running ) then
            self:OnPhaseThree();
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPhaseTwo = function(self)
        if ( self.data.phase >= 2 ) then return; end
        self:ChangePhase(2, true);

        self.data.timeOut = 420;
        self.data.timeOutTimer = 0;

        self.EventWatcher:GetDriver():AddEvent("HideBar", 30, "", "", "HIDDEN", self.BossBar.Remove, self.BossBar);

        self.EventWatcher:GetDriver():ClearEvent("Spark");
        self.EventWatcher:GetDriver():ClearEvent("Vortex");

        self:ScheduleDeepBreath(92);
    end,

    OnPhaseTwoEnd = function(self)
        if ( self.data.phase ~= 2 ) then return; end
        self.data.timeOutTimer = 0;
        self:ChangeMusic("SILENCE");
        self.BossBar:Display();

        self.EventWatcher:GetDriver():ClearEvent("DeepBreath");
        self.EventWatcher:GetDriver():ClearEvent("HideBar");
    end,

    OnPhaseThree = function(self)
        if ( self.data.phase >= 3 ) then return; end
        self:ChangePhase(3, true);

        self.data.timeOut = 60;
        self.data.timeOutTimer = 0;

        self:ChangeMusic("HURRYUP");

        self.EventWatcher:Remove();

        -- Delayed advices
        if ( self:HasRole("OFFENSIVE") ) then
            self.EventWatcher:GetDriver():AddEvent("Advice1",  5, "", "", "HIDDEN", self.NotifyMe, self, self:Localize("Phase3Advice1"), nil, 7);
            self.EventWatcher:GetDriver():AddEvent("Advice2", 14, "", "", "HIDDEN", self.NotifyMe, self, self:Localize("Phase3Advice2"), nil, 6);
        end
    end,

    OnSpark = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Spark");
        self:ScheduleSpark(30);

        self.data.sparkCount = self.data.sparkCount + 1;
        self.StatusFrame:SetStatus("TEXT", self:FormatLoc("SparkStatus", self.data.sparkCount), true);
    end,

    OnVortex = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Vortex");
        self.EventWatcher:GetDriver():AddEvent("VortexEnd", 10, "AUTO", self:Localize("VortexEnd"), "NORMAL", self.OnVortexEnd, self);
        self.EventWatcher:GetDriver():FreezeEvent("Spark", true);

        self:ScheduleVortex(59);
    end,

    OnVortexEnd = function(self)
        self.EventWatcher:GetDriver():FreezeEvent("Spark", false);
    end,

    OnDeepBreath = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("DeepBreath");
        self:ScheduleDeepBreath(59);
    end,

    OnSelfSurge = function(self)
        self:AlertMe(self:Localize("SurgeAlert"), 0.400, 3.000);
    end,

    OnMalygosPowerSpark = function(self)
        if ( self.data.phase ~= 1 ) then return; end
        if ( self:GetSetting("warnPowerup") ) then
            self:AnnounceToRaid(self:Localize("MalygosPowerup"));
        end
        local bossTargetGUID = self:GetTargetInfo();
        if ( bossTargetGUID ) then
            self:RegisterHealAssist(bossTargetGUID, 0, 8);
        end
    end,

    OnEngulfStack = function(self, count)
        local bossUID = Root.Unit.GetUID(self.data.guid);
        local found, timeLeft;
        if ( bossUID ) then
            found, timeLeft = Root.Unit.SearchEffect(bossUID, "DEBUFF", ENGULF_NAME, true);
        end
        if ( not timeLeft ) then return; end

        self.data.engulfDuration = timeLeft;
        self.data.engulfStart = GetTime();
        self.data.engulfCount = max(1, count);

        self:ValidateEngulf(self:GetMyEngulfInfo());
    end,

    OnEngulfBarExpired = function(self)
        if ( not self.running ) then return; end

        -- Gets called when the engulf bar has finished ticking.
        self.SpecialBar:Remove();
    end,

    OnArcaneBarrage = function(self, guid, name)
        self:RegisterHealAssist(guid, 2.5, 5);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(28859, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
