local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Festergut Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Festergut fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events

        -- 3. Misc
        ["GasSporeSelf"] = "You have a Gas Spore!",
        ["GasSporeAlert"] = ">> Gas Spore: <<",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events

        -- 3. Misc
        ["GasSporeSelf"] = "Vous avez une spore gazeuse !",
        ["GasSporeAlert"] = ">> Spore gazeuse: <<",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnGasSpore",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Gas Spores",
            ["frFR"] = "Annoncer les spores gazeuses",
        },
        explain = {
            ["default"] = "Display raid alerts and put symbols on people that get the Gas Spores.",
            ["frFR"] = "Affiche des alertes de raid et place des symboles sur les personnes qui obtiennent les spores gazeuses.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Festergut";

local gasSpore = {
    [69278] = true,
    [69279] = true,
    [71221] = true,
};

local vileGas = {
    [69240] = true,
    [71218] = true,
    [72272] = true,
    [72273] = true,
    [73019] = true,
    [73020] = true,
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

        data.sporeList = {};

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.90, 0.90, 0.90, 0.60, 0.60); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.70, 0.60, 0.60, 0.40, 0.40); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(300, false);

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 8, 40);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(180, 300);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER9_SURVIVAL2");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(300, false);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( gasSpore[spellId] ) and ( targetGUID ) then
                    self:OnGasSpore(targetGUID);
                end
                if ( vileGas[spellId] ) and ( targetGUID ) then
                    self:RegisterHealAssist(targetGUID, 0, 6, spellId);
                end
            end
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    AlertGasSpore = function(self)
        if ( self:GetSetting("warnGasSpore") ) then
            self:AnnounceUnitList(self.data.sporeList, true, self:Localize("GasSporeAlert"), 10.00);
        end
        local i;
        for i=1, #self.data.sporeList do
            if ( self.data.sporeList[i] == UnitGUID("player") ) then
                self:AlertMe(self:Localize("GasSporeSelf"));
                return;
            end
        end
    end,


    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnGasSpore = function(self, guid)
        if ( self:EvaluateCooldown("gas", 5) ) then
            self.EventWatcher:GetDriver():AddEvent("AlertGasSpore", 0.150, "", "", "HIDDEN", self.AlertGasSpore, self);
            wipe(self.data.sporeList);
        end
        if ( self:EvaluateCooldown("gas:"..guid, 3) ) then
            tinsert(self.data.sporeList, guid);
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(36626, THIS_MODULE, false);
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
