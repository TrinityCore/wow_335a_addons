local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Jaraxxus Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Jaraxxus fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Portal"] = "Portal",
        ["Eruption"] = "Eruption",
        ["Flame"] = "Flame",
        ["Incinerate"] = "Incinerate",
        ["Boom"] = "Boom!",

        -- 3. Misc
        ["Powerup"] = ">> Jaraxxus has %d stacks of the powerup! <<",
        ["FlameSelf"] = "Move away!",
        ["FlameWarning"] = ">> {rt7} Flames are spawning under %s! {rt7} <<",
        ["IncinerateExplain"] = "|cffffff00%s|r needs |cffff0000%d|r points of heal!",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Portal"] = "Portail",
        ["Eruption"] = "Eruption",
        ["Flame"] = "Flamme",
        ["Incinerate"] = "Incinérer",
        ["Boom"] = "Boum !",

        -- 3. Misc
        ["Powerup"] = ">> Jaraxxus a %d empilements du powerup ! <<",
        ["FlameSelf"] = "Déplacez-vous !",
        ["FlameWarning"] = ">> {rt7} Des flammes apparaissent sous %s ! {rt7} <<",
        ["IncinerateExplain"] = "|cffffff00%s|r a besoin de |cffff0000%d|r points de soin !",
    },
};

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
            ["default"] = "Warn Jaraxxus Powerup +5",
            ["frFR"] = "Annoncer les powerups sur Jaraxxus 5+",
        },
        explain = {
            ["default"] = "Display a raid alert whenever Jaraxxus gets the damage increase buff (stacked 5 times or more).",
            ["frFR"] = "Affiche une alerte de raid chaque fois que Jaraxxus obtient l'effet d'augmentation de ses dégâts (5 empilements ou plus).",
        },
    },
    [2] = {
        id = "warnFlame",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Flame",
            ["frFR"] = "Annoncer les flammes",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol whenever someone is targetted by flames.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole chaque fois que quelqu'un est ciblé par les flammes.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Jaraxxus";

local MISTRESS_ID = 34826;
local PORTAL_ID   = 34825;
local VOLCANO_ID  = 34813;

local incinerate = {
    [67051] = {85000, 12},
    [67050] = {40000, 12},
    [66237] = {30000, 15},
    [67049] = {60000, 15},
};

local power = {
    [66228] = true,
    [67009] = true,
    [67106] = true,
    [67107] = true,
    [67108] = true,
};

local flame = {
    [66197] = true,
    [68123] = true,
    [68124] = true,
    [68125] = true,
};

local eruption = {
    [66258] = true,
    [67901] = true,
    [67902] = true,
    [67903] = true,
};

local portal = {
    [66269] = true,
    [67898] = true,
    [67899] = true,
    [67900] = true,
};

local SpecialBarIncinerateAlgorithm = {
    colors = {0.2, 1.0, 0.2}, -- R/G/B
    bounds = {0, 1}, -- min/max

    title = {
        ["default"] = "Incinerate",
        ["frFR"] = "Incinérer",
    },

    OnUpdate = function(self, elapsed)
        local hp, hpMax = Root[THIS_MODULE]:GetIncinerateHealth();

        local title = Root.ReadLocTable(self.title);
        local text = string.format("%d / %d", hpMax - hp, hpMax);

        return title, text, 1 - hp/hpMax;
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

    OnTrigger = function(self, uid)
        if not self:TriggerMe() then return; end

        local data = self.data;

        data.ignoreLeaveCombat = true;
        data.incinerateGUID = nil;
        data.incinerateAmount = 0;
        data.incinerateAmountMax = 1;
        data.ignoreAdds = true;
        data.silentAddKills = true;
        data.powerUpStack = 0;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.65, 0.75, 0.65, 0.55, 0.50); -- P/B/A/C/S
            data.selectableDoodads = true;
      else
            self:SetDifficultyMeter(0.50, 0.55, 0.50, 0.40, 0.35); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(600, true);

        self:ResetAdds();
        self:RegisterAddEX(MISTRESS_ID, false, "DB");
        if ( data.selectableDoodads ) then
            self:RegisterAddEX(PORTAL_ID, false, "DB");
            self:RegisterAddEX(VOLCANO_ID, false, "DB");
        end

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 10, 4);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(300, 600);
        self:SetNearVictoryThreshold(0.10, 600-90, 0.70); -- Near Victory theme when the boss gets below 10%, there's 1.5 minute left and 70% of the raid is alive.

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER9_DPSRACE3");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(600, true);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:SchedulePortal(20);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["HEAL"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overheal, school, special, absorbed)
            if ( self.running ) then
                if ( self.data.incinerateGUID ) and ( targetGUID == self.data.incinerateGUID ) then
                    local exactAmount = (amount or 0) + (absorbed or 0);
                    self:OnIncinerateAbsorb(exactAmount);
                end
            end
            Shared.OnCombatEvent["HEAL"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overheal, school, special, absorbed);
        end,

        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( flame[spellId] ) and ( targetGUID ) and ( targetName ) then
                    self:OnFlame(targetGUID, targetName);
                end
                if ( eruption[spellId] ) then
                    self:OnEruption();
                end
                if ( portal[spellId] ) then
                    self:OnPortal();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( power[spellId] ) and ( targetGUID == self.data.guid ) then
                    self:OnPower();
                    self.data.powerUpStack = max(self.data.powerUpStack, stackAmount);
                end
                if ( incinerate[spellId] ) and ( targetGUID ) and ( targetName ) then
                    self:OnIncinerateStart(incinerate[spellId][1], incinerate[spellId][2], targetGUID, targetName);
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( incinerate[spellId] ) then
                    self:OnIncinerateEnd();
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    GetIncinerateHealth = function(self)
        if ( not self.data ) then return 0, 1; end
        return self.data.incinerateAmount, self.data.incinerateAmountMax;
    end,

    SchedulePortal = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Portal", timer, "AUTO", self:Localize("Portal"), "WARNING");
    end,

    ScheduleEruption = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Eruption", timer, "AUTO", self:Localize("Eruption"), "WARNING");
    end,

    ScheduleFlame = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Flame", timer, "AUTO", self:Localize("Flame"), "NORMAL");
    end,

    ScheduleIncinerate = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Incinerate", timer, "AUTO", self:Localize("Incinerate"), self:IfRole("HEALER", "ALERT", "NORMAL"));
    end,

    WarnPower = function(self)
        local count = self.data.powerUpStack;
        if ( self:GetSetting("warnPowerup") ) and ( count >= 5 ) then
            self:AnnounceToRaid(self:FormatLoc("Powerup", count));
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPortal = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Portal");
        self:ScheduleEruption(60);
        -- self:SchedulePortal(121);

        self:RespawnAdd(MISTRESS_ID);
        if ( self.data.selectableDoodads ) then
            self:RespawnAdd(PORTAL_ID);
        end
    end,

    OnEruption = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Eruption");
        self:SchedulePortal(60);
        -- self:ScheduleEruption(120.5);

        if ( self.data.selectableDoodads ) then
            self:RespawnAdd(VOLCANO_ID);
        end
    end,

    OnIncinerateStart = function(self, amount, timer, guid, name)
        self.EventWatcher:GetDriver():TriggerEvent("Incinerate");
        self:ScheduleIncinerate(24);
        self.EventWatcher:GetDriver():AddEvent("Boom", timer, "AUTO", self:Localize("Boom"), self:IfRole("HEALER", "ALERT", "WARNING"));

        self.data.incinerateAmount, self.data.incinerateAmountMax = amount, amount;
        self.data.incinerateGUID = guid;

        self:RegisterHealAssist(guid, 0, timer);

        self.SpecialBar:GetDriver():AssignAlgorithm(SpecialBarIncinerateAlgorithm);
        self.SpecialBar:Display();

        if self:HasRole("HEALER") then
            self:AlertMe(self:FormatLoc("IncinerateExplain", name, amount), 0.500, 6.000);
        end
    end,

    OnIncinerateAbsorb = function(self, amount)
        self.data.incinerateAmount = max(0, self.data.incinerateAmount - amount);
    end,

    OnIncinerateEnd = function(self)
        self.data.incinerateAmount = 0;

        local timeLeft = self.EventWatcher:GetDriver():GetEventTimer("Boom") or 0;
        if ( timeLeft <= 1 ) then
            self.EventWatcher:GetDriver():TriggerEvent("Boom"); -- Probably exploded.
      else
            self.EventWatcher:GetDriver():ClearEvent("Boom"); -- Did not explode.
        end

        self.SpecialBar:Remove();
    end,

    OnFlame = function(self, guid, name)
        self.EventWatcher:GetDriver():TriggerEvent("Flame");
        self:ScheduleFlame(31);

        if ( UnitGUID("player") == guid ) then
            self:AlertMe(self:Localize("FlameSelf"), 0.400, 7.000);
        end
        if ( self:GetSetting("warnFlame") ) then
            self:AnnounceToRaid(self:FormatLoc("FlameWarning", name));
            self:PlaceSymbol(guid, 7, 7.00);
        end
        self:RegisterHealAssist(guid, 0, 7);
    end,

    OnPower = function(self)
        if ( not self:EvaluateCooldown("powerUp", 3) ) then return; end

        self.EventWatcher:GetDriver():AddEvent("WarnPower", 0.150, "", "", "HIDDEN", self.WarnPower, self);

        self.data.powerUpStack = 0;
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(34780, THIS_MODULE, true);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
