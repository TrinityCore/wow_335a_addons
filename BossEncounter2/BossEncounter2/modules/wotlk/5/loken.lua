local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Loken Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Loken fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Nova"] = ">> NOVA !! <<",
        ["NovaSoon"] = "Nova soon !",
        ["NextNova"] = "Next nova",

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Nova"] = ">> NOVA !! <<",
        ["NovaSoon"] = "Nova imminente !",
        ["NextNova"] = "Nova suivante",

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnNova",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Novas",
            ["frFR"] = "Annoncer les novas",
        },
        explain = {
            ["default"] = "Display nova alerts.",
            ["frFR"] = "Affiche des alertes concernant les novas.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Loken";

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

        Root.Music.Play("PREPARATION_GENERAL");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(60, 180, 5);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER6_DPSRACE1");

        -- Start countdown
        self.StatusFrame:GetDriver():StartTiming();

        -- Do not bother for initial timer events if the fight started out-of-sync
        if ( self.data.bossAlreadyFighting ) then return; end

        -- Initial events
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( spellId == 59835 ) then
                self:OnNova();
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    OnNova = function(self, timer)
        if ( self:GetSetting("warnNova") ) then
            self:AnnounceToRaid(self:Localize("Nova"));
            self.EventWatcher:GetDriver():AddEvent("NextNovaWarning", 11, "", "", "HIDDEN", self.AnnounceToRaid, self, self:Localize("NovaSoon"));
        end
        self.EventWatcher:GetDriver():AddEvent("NextNova", 16, "AUTO", self:Localize("NextNova"), "NORMAL");  
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;

    -- Put in first argument the NPC ID of the boss that is being described.
    -- Set "true" in the third argument if the NPC apparears suddenly and might be selected too late by the player after spawning, thus triggering the module too late.

    Root.NPCDatabase.Register(28923, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
