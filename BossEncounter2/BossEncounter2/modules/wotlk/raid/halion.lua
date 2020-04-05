local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Halion Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Halion fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["OrbTrigger"] = "pulse with dark energy",

        -- 2. Events
        ["TwilightCutter"] = "Twilight Cutter",

        -- 3. Misc
        ["Phase2"] = "Phase 2 - Shadow realm",
        ["Phase3"] = "Phase 3 - Both realms",
        ["DebuffSelf"] = "Get away!",
        ["Combustion"] = ">> {rt6} Combustion on %s {rt6} <<",
        ["Consumption"] = ">> {rt7} Consumption on %s {rt7} <<",
        ["BeamWarning"] = "|cffff4040Mind the beam!|r",
    },
    ["frFR"] = {
        -- 1. Yells
        ["OrbTrigger"] = "énergie",

        -- 2. Events
        ["TwilightCutter"] = "Tranchant crépusc.",

        -- 3. Misc
        ["Phase2"] = "Phase 2 - Crépuscule",
        ["Phase3"] = "Phase 3 - Les deux",
        ["DebuffSelf"] = "Eloignez-vous !",
        ["Combustion"] = ">> {rt6} Combustion sur %s {rt6} <<",
        ["Consumption"] = ">> {rt7} Consomption sur %s {rt7} <<",
        ["BeamWarning"] = "|cffff4040Prenez garde au rayon !|r",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnDebuff",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn debuffs",
            ["frFR"] = "Annoncer les débuffs",
        },
        explain = {
            ["default"] = "Place a square symbol on Combustion targets. Place a cross symbol on Consumption targets. Also display raid warnings.",
            ["frFR"] = "Place le symbole carré sur les cibles de Combustion. Place le symbole croix sur les cibles de Consomption. Affiche également des avertissements de raid.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Halion";

local BOSS_ID = 39863;
local BOSS_ALT_ID = 40142;

local BERSERK_TIMER = 600;

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

        data.clearSequence = "FINAL";
        data.baseID = THIS_MODULE;
        data.silentAddKills = true;
        data.ignoreStandardClear = true;
        data.voidDamage = true; -- Ignore damage done because of the phasing.
        data.activeBoss = "UNKNOWN";

        self:GrabStaticWidgets();

        self:SetBossUnit(uid, 120, true);

        self:GrabStaticWidgets();

        self:ChangePhase(0, false);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.90, 0.90, 0.75, 0.65, 0.75); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.75, 0.85, 0.60, 0.50, 0.70); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(BERSERK_TIMER, true);

        self:ResetAdds();
        self:RegisterAddEX(BOSS_ID, false, "DISABLE", nil, "DPS"); -- Fire
        self:RegisterAddEX(BOSS_ALT_ID, false, "DISABLE", nil, "HEAL"); -- Shadow
        self.AddWindow:Remove(true); -- We don't need this in fact.

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("OrbTrigger"), self.OnTwilightCutter, self);

        Root.Music.Play("PREPARATION_DUNGEON");

        self:ResetHealthThresholds();

        self:CheckActive();
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(BERSERK_TIMER / 2, BERSERK_TIMER);
        self:SetNearVictoryThreshold(0.075, BERSERK_TIMER-90, 0.70); -- Near Victory theme when the boss gets below 7.5%, the time left is above 1.5 minute and 70% of the raid is alive.

        self:ChangePhase(1, true);

        Root.Music.Play("THEME_ULTIMATE");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(BERSERK_TIMER, true);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 74792 or spellId == 74562 ) then
                self:OnDebuffApplied(targetGUID, targetName, spellId);
            end
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleTwilightCutter = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("TwilightCutter", timer, "AUTO", self:Localize("TwilightCutter"), "WARNING_NOREMINDER");  
    end,

    FlagAddDeath = function(self, index, isDead) -- Overload the flag add as dead method.
        if ( isDead ) then
            self:OnCleared();
        end
        Shared.FlagAddDeath(self, index, isDead);
    end,

    CheckActive = function(self)
        local guid;
        guid = Root.Unit.GetGUIDFromMobID(BOSS_ID);
        if ( guid ) and ( self.data.activeBoss ~= "FIRE" ) then
            self.data.guid = guid;
            self.data.activeBoss = "FIRE";
            self.BossBar:GetDriver():SetWatch(guid);
            if ( self.data.phase < 3 ) then
                self:RegisterHealthThreshold(0.755, self:Localize("Phase2"), self.OnPhaseTwo, self);
            end
        end
        guid = Root.Unit.GetGUIDFromMobID(BOSS_ALT_ID);
        if ( guid ) and ( self.data.activeBoss ~= "SHADOW" ) then
            self.data.guid = guid;
            self.data.activeBoss = "SHADOW";
            self.BossBar:GetDriver():SetWatch(guid);
            if ( self.data.phase < 3 ) then
                self:RegisterHealthThreshold(0.505, self:Localize("Phase3"), self.OnPhaseThree, self);
            end
        end
        self.EventWatcher:GetDriver():AddEvent("CheckActive", 1, "", "", "HIDDEN", self.CheckActive, self);
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPhaseTwo = function(self)
        if ( self.data.phase >= 2 ) then return; end
        self:ChangePhase(2, true);

        self.data.timeOutTimer = 0;

        self:ScheduleTwilightCutter(34);
    end,

    OnPhaseThree = function(self)
        if ( self.data.phase >= 3 ) then return; end
        self:ChangePhase(3, true);

        self.data.timeOutTimer = 0;

        -- self.BossBar:Remove(false);
    end,

    OnTwilightCutter = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("TwilightCutter");
        self:ScheduleTwilightCutter(33);

        if ( self.data.activeBoss == "SHADOW" ) then -- Safety measure, shouldn't be necessary.
            self:AlertMe(self:Localize("BeamWarning"), 0.400, 3.000);
        end
    end,

    OnDebuffApplied = function(self, guid, name, spellId)
        if ( guid == UnitGUID("player") ) then
            self:AlertMe(self:Localize("DebuffSelf"), 0.500, 4.000);
        end
        if self:GetSetting("warnDebuff") then
            if ( spellId == 74792 ) then
                self:PlaceSymbol(guid, 7, 8.00); -- Shadow
                self:AnnounceToRaid(self:FormatLoc("Consumption", name));
          else
                self:PlaceSymbol(guid, 6, 8.00); -- Fire
                self:AnnounceToRaid(self:FormatLoc("Combustion", name));
            end
        end
        self:RegisterHealAssist(guid, 2, 30, spellId);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(BOSS_ID, THIS_MODULE, false);

    Root.NPCDatabase.Register(BOSS_ALT_ID, THIS_MODULE, false);
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
