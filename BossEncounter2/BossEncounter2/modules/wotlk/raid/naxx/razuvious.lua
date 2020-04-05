local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Razuvious Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Razuvious fight.

-- 25-man version:
-- 4 adds instead of 2.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events

        -- 3. Misc
        ["ShieldWarning"] = ">> {rt%d} no longer protected in %d sec ! <<",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events

        -- 3. Misc
        ["ShieldWarning"] = ">> {rt%d} ne pourra plus tanker dans %d sec ! <<",
    },
};

local SHIELD_BUFF = select(1, GetSpellInfo(29061));

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnTankSwitch",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn tank switches",
            ["frFR"] = "Annoncer les changements de tank",
        },
        explain = {
            ["default"] = "Display an alert each time a tank should switch.",
            ["frFR"] = "Affiche une alerte à chaque fois qu'un des tanks doit changer.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Razuvious";

local ADD_ID = 16803;

local ShieldAlgorithm = {
    label = {
        ["default"] = "Shield",
        ["frFR"] = "Bouclier",
    },
    layout = 3,
    allowDead = false,

    lastWarning = 0,

    GetValue = function(self, uid)
        local hasBuff, timeLeft = Root.Unit.SearchEffect(uid, "BUFF", SHIELD_BUFF);
        if ( hasBuff ) then
            -- This understudy is going to lose his shield.
            local module = Root[THIS_MODULE];
            if ( timeLeft < 5.90 ) and ( GetTime() - self.lastWarning ) > 7.00 and Root.CheckAuth("WARNING") and module:GetSetting("warnTankSwitch") then
                self.lastWarning = GetTime();
                local symbol = GetRaidTargetIndex(uid);
                if ( symbol ) and ( symbol ~= 0 ) then
                    module:AnnounceToRaid(module:FormatLoc("ShieldWarning", symbol, timeLeft));
                end
            end
            return timeLeft * 10, 20 * 10;
        end
        return 0, 20 * 10;
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

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        data.title = "Razuvious";

        -- We've got 2 adds with the same name to handle in a special and hardcoded fashion.
        data.students = { };
        data.ignoreList = { };
        local numAdds = 2;
        if ( Root.GetInstanceMode() == "HEROIC" ) then numAdds = 4; end
        local i;
        for i=1, numAdds do
            data.students[i] = {
                found = false,
                guid = nil,
            };
        end

        self:SetDifficultyMeter(0.25, 0.25, 0.15, 0.15, 0.30); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, false);

        Root.Music.Play("PREPARATION_GENERAL");

        self.AddWindow:Display();
        self.AddWindow:GetDriver():AssignAlgorithm(ShieldAlgorithm);

        self:SetStrictRelevance(true); -- do not count damage done to adds.
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(150, 300);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER7_TANKNSPANK3");

        self.StatusFrame:GetDriver():StartTiming();
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        local i, guid, name, uid, id;
        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            id = Root.Unit.GetMobID(guid);
            if ( uid ) and ( id ) and ( id == ADD_ID ) then
                if ( not self.data.ignoreList[guid] ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitHealth(uid) > 0 ) then
                    self:AddUnderstudyMob(uid);
                end
            end
        end

        Shared.OnUpdate(self, elapsed);
    end, 

    OnCombatEvent = Shared.OnCombatEvent,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    AddUnderstudyMob = function(self, uid)
        local data = self.data;
        local guid = UnitGUID(uid);
        data.ignoreList[guid] = true;
        local i;
        for i=1, #data.students do
            if ( not data.students[i].found ) then
                data.students[i].found = true;
                data.students[i].guid = guid;
                self.AddWindow:GetDriver():AddUnit(guid);
                break;
            end
        end
    end,

    RemoveAddsWidgets = function(self)  -- Overwrite the normal routine because we use a special add system for this fight.
        if type(self.AddBar) ~= "table" then return; end

        self.AddWindow:Remove();
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(16061, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
