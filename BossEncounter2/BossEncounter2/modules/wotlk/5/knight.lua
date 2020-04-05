local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Black Knight Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Black Knight fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["PhaseTwoTrigger"] = "My rotting flesh was just getting ",
        ["PhaseThreeTrigger"] = "I have no need for bones ",

        -- 2. Events

        -- 3. Misc
        ["MarkAlert"] = ">> {rt7} %s has become vulnerable ! {rt7} <<",
        ["MarkSelf"] = "You are vulnerable !",
    },
    ["frFR"] = {
        -- 1. Yells
        ["PhaseTwoTrigger"] = "Cette chair pourrie ne faisait que me ralentir",
        ["PhaseThreeTrigger"] = "Pas besoin de mes os pour vous vaincre",

        -- 2. Events

        -- 3. Misc
        ["MarkAlert"] = ">> {rt7} %s est devenu vulnérable ! {rt7} <<",
        ["MarkSelf"] = "Vous êtes vulnérable !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnMark",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Marked for death",
            ["frFR"] = "Annoncer la marque de la mort",
        },
        explain = {
            ["default"] = "Display an alert and place a symbol when someone is marked for death.",
            ["frFR"] = "Affiche une alerte et place un symbole quand quelqu'un obtient la marque de la mort.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Knight";

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

    OnTrigger = function(self, uid)
        if not self:TriggerMe() then return; end

        self:GrabStaticWidgets();

        self.data.ignoreStandardClear = true;

        self:SetBossUnit(uid, 60);

        self:PrepareBasicWidgets(nil, false);

        self:SetStrictRelevance(true); -- damage done to army of the dead / ghoul is not relevant.
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(110, 300, 5);

        self:ChangePhase(1, true);

        Root.Music.Play("TIER6_DPSRACE1");

        self.StatusFrame:GetDriver():StartTiming();

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("PhaseTwoTrigger"), self.OnPhaseTwo, self);
        self:RegisterYellCallback(nil, self:Localize("PhaseThreeTrigger"), self.OnPhaseThree, self);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 67823 or spellId == 67882 ) and ( targetGUID ) and ( targetName ) then
                self:OnMark(targetGUID, targetName);
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPhaseTwo = function(self)
        if ( self.data.phase >= 2 ) then return; end
        self:ChangePhase(2, true);
    end,

    OnPhaseThree = function(self)
        if ( self.data.phase >= 3 ) then return; end
        self:ChangePhase(3, true);

        self.data.bossDead = false;
        self.data.ignoreStandardClear = false;

        self:ChangeMusic("HURRYUP");
    end,

    OnMark = function(self, guid, name)
        if ( self:GetSetting("warnMark") ) then
            self:AnnounceToRaid(self:FormatLoc("MarkAlert", name));
            self:PlaceSymbol(guid, 7, 10.00);
        end
        if ( guid == UnitGUID("player") ) then
            self:AlertMe(self:Localize("MarkSelf"), 0.400, 4.000);
        end
        self:RegisterHealAssist(guid, 0, 10);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(35451, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
