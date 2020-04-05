local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Eregos Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Eregos fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Explosion"] = "Explosion",
        ["EnragedAssault"] = "Enraged assault",
        ["DiminishingReturns"] = "Diminished stop time: reset",

        -- 3. Misc
        ["RunAway"] = "Run away !",
        ["DiminishingReturnsWarning"] = ">> Stop time is fully effective again ! <<",

    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Explosion"] = "Explosion",
        ["EnragedAssault"] = "Assaut enragé",
        ["DiminishingReturns"] = "Rendement décroissant: fin",

        -- 3. Misc
        ["RunAway"] = "Fuyez !",
        ["DiminishingReturnsWarning"] = ">> Arrêt du temps est redevenu efficace ! <<",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnDR",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Stop Time diminishing returns",
            ["frFR"] = "Annoncer les rendements décroissants d'arrêt du temps",
        },
        explain = {
            ["default"] = "Display when the next Stop Time will have full duration on the boss. This occurs 15 sec after the last Stop Time has faded from Eregos.",
            ["frFR"] = "Affiche quand le prochain Arrêt du temps aura une durée complète sur le boss. Cela se produit 15 sec après que le dernier Arrêt du temps ait expiré.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Eregos";

local TIMESTOP_SPELLID = 49838;
local TIMESTOP_NAME = select(1, GetSpellInfo(TIMESTOP_SPELLID));

-- --------------------------------------------------------------------
-- **                       Definition stuff                         **
-- --------------------------------------------------------------------

Root[THIS_MODULE] = {
    -- --------------------------------------------------------------------
    -- **                            Properties                          **
    -- --------------------------------------------------------------------

    running = false, -- Never set this to true.
    data = nil, -- Never set this.
    status = nil,

    -- --------------------------------------------------------------------
    -- **                             Handlers                           **
    -- --------------------------------------------------------------------

    OnStart = Shared.OnStart,

    OnTrigger = function(self, uid, extraTable)
        if not self:TriggerMe() then return; end

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:PrepareBasicWidgets(nil, true);

        Root.Music.Play("PREPARATION_DUNGEON");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(90, 240, 5);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER6_TANKNSPANK1");

        self.StatusFrame:GetDriver():StartTiming();

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleEnragedAssault(34);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 51170 ) then
                    self:OnEnragedAssault();
                end
                if ( spellId == 51162 ) then
                    self:OnPlanarShift();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == TIMESTOP_SPELLID ) and ( targetGUID == self.data.guid ) then
                self:OnBossTimeStop();
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleEnragedAssault = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("EnragedAssault", timer, "AUTO", self:Localize("EnragedAssault"), "WARNING");
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPlanarShift = function(self)
        self.EventWatcher:GetDriver():AddEvent("Explosion", 18, "AUTO", self:Localize("Explosion"), "ALERT");
        self:AlertMe(self:Localize("RunAway"), 0.400, 3.500);

        self.EventWatcher:GetDriver():ClearEvent("EnragedAssault");
        self:ScheduleEnragedAssault(19);
    end,

    OnEnragedAssault = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("EnragedAssault");
        self:ScheduleEnragedAssault(34);
    end,

    OnBossTimeStop = function(self)
        local bossUID = Root.Unit.GetUID(self.data.guid);
        local found, timeLeft;
        if ( bossUID ) then
            found, timeLeft = Root.Unit.SearchEffect(bossUID, "DEBUFF", TIMESTOP_NAME);
        end
        if ( not timeLeft ) then return; end

        self.EventWatcher:GetDriver():ClearEvent("DiminishingReturns");
        self.EventWatcher:GetDriver():AddEvent("DiminishingReturns", 15 + timeLeft, "AUTO", self:Localize("DiminishingReturns"), "NORMAL", self.OnDRExpired, self);
    end,

    OnDRExpired = function(self)
        if ( self:GetSetting("warnDR") ) then
            self:AnnounceToRaid(self:Localize("DiminishingReturnsWarning"));
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(27656, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
