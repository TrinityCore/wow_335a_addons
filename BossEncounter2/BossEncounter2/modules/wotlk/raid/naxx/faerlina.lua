local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Faerlina Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Faerlina fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Frenzy"] = "Frenzy",
        ["WidowEmbrace"] = "W. Embrace: End",

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Frenzy"] = "Frénésie",
        ["WidowEmbrace"] = "Etreinte: fin",

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Faerlina";

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

        self.data.title = "Faerlina";

        self:SetDifficultyMeter(0.10, 0.20, 0.15, 0.00, 0.05); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self.data.hasFrenzy = false;
        self.data.currentFrenzy = 0;

        self:SetScoreBenchmarks(150, 300);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER7_DPSRACE1");

        self.StatusFrame:GetDriver():StartTiming();

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleFrenzy(65);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( targetGUID ) and ( targetGUID == self.data.guid ) and ( spellId == 28798 or spellId == 54100 ) then
                self:OnFrenzy();
            end
            if ( self.running ) and ( targetGUID ) and ( targetGUID == self.data.guid ) and ( spellId == 28732 or spellId == 54097 ) then
                self:OnWidowEmbrace();
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( targetGUID ) and ( targetGUID == self.data.guid ) and ( spellId == 28798 or spellId == 54100 ) then
                self:OnFrenzyFade();
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleFrenzy = function(self, timer)
        local currentFrenzy = self.data.currentFrenzy + 1;
        self.data.currentFrenzy = currentFrenzy;
        self.EventWatcher:GetDriver():AddEvent("Frenzy"..currentFrenzy, timer, "AUTO", self:FormatLoc("Frenzy", currentFrenzy), "ALERT");
    end,

    ScheduleWidowEmbrace = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("WidowEmbrace", timer, "AUTO", self:Localize("WidowEmbrace"), "NORMAL");
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnFrenzy = function(self)
        self.data.hasFrenzy = true;
        self.EventWatcher:GetDriver():TriggerEvent("Frenzy"..self.data.currentFrenzy);
    end,

    OnFrenzyFade = function(self)
        self.data.hasFrenzy = false;
        self:ScheduleFrenzy(65);
    end,

    OnWidowEmbrace = function(self)
        self.EventWatcher:GetDriver():ClearEvent("WidowEmbrace");
        self:ScheduleWidowEmbrace(30);

        if ( not self.data.hasFrenzy ) then
            -- Add killed while she didn't have the Frenzy.
            -- If Frenzy timer is below 30 sec, set it back to 30 sec.

            local frenzyEvent = "Frenzy"..self.data.currentFrenzy;
            local frenzyTimer = self.EventWatcher:GetDriver():GetEventTimer(frenzyEvent);

            if ( frenzyTimer ) and ( frenzyTimer < 30.0 ) then
                self.EventWatcher:GetDriver():ChangeEvent(frenzyEvent, 30);
            end
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(15953, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
