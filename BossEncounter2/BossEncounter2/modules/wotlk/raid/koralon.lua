local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Koralon Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Koralon fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["BurningFury"] = "Burning Fury %d",
        ["MeteorFistsEnd"] = "Meteor Fists: end",

        -- 3. Misc
        ["BurningFuryCount"] = "Fury %d",
        ["FireSelf"] = "|cff8080ffYou are burning !!|r",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["BurningFury"] = "Furie ardente %d",
        ["MeteorFistsEnd"] = "Poings météores: fin",

        -- 3. Misc
        ["BurningFuryCount"] = "Furie %d",
        ["FireSelf"] = "|cff8080ffVous brûlez !!|r",
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Koralon";

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

        data.title = "Koralon";

        self:SetDifficultyMeter(0.50, 0.70, 0.60, 0.10, 0.15); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);

        Root.Music.Play("PREPARATION_DUNGEON");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(180, 360);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_MIGHT");

        self.StatusFrame:GetDriver():StartTiming();

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleBurningFury(1, 20);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, ...)
            if ( self.running ) then
                local isPeriodic = ...;
                if ( spellId == 67332 or spellId == 66684 ) then
                    self:OnFireDamage(targetGUID, isPeriodic);
                end
            end

            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, ...);
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 66721 ) then
                    self:OnBurningFury(stackAmount or 1);
                end
                if ( spellId == 66725 or spellId == 66808 ) then -- TODO: check
                    self:OnMeteorFists();
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleBurningFury = function(self, count, timer)
        self.EventWatcher:GetDriver():AddEvent("BurningFury"..count, timer, "AUTO", self:FormatLoc("BurningFury", count), "NORMAL");
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnFireDamage = function(self, guid, periodic)
        self:RegisterHealAssist(guid, 0, 2);

        if ( UnitGUID("player") == guid ) and ( periodic ) then
            if ( not self:EvaluateCooldown("fireAlert", 1) ) then return; end
            self:AlertMe(self:Localize("FireSelf"), 0.100, 1.000);
        end
    end,

    OnBurningFury = function(self, count)
        self.EventWatcher:GetDriver():TriggerEvent("BurningFury"..count);
        self.StatusFrame:SetStatus("TEXT", self:FormatLoc("BurningFuryCount", count), true);
        self:ScheduleBurningFury(count+1, 20);
    end,

    OnMeteorFists = function(self)
        self.EventWatcher:GetDriver():AddEvent("MeteorFistsEnd", 15, "AUTO", self:Localize("MeteorFistsEnd"), self:IfRole("SHIELD", "WARNING", "NORMAL"));
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(35013, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
