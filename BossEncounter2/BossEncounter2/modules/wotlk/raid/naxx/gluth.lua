local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Gluth Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Gluth fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Decimate"] = "Decimate",

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Decimate"] = "Décimer",

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Gluth";

local ZOMBIE_ID = 16360;

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

        data.lastDecimate = 0;
        data.berserkTimer = 480;
        if ( Root.GetInstanceMode() == "HEROIC" ) then data.berserkTimer = 420; end

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.30, 0.35, 0.15, 0.45, 0.30); -- P/B/A/C/S

        self:PrepareBasicWidgets(data.berserkTimer, true);

        self:SetStrictRelevance(true); -- count adds, but only when they are set low-life.
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(self.data.berserkTimer/1.75, self.data.berserkTimer);
        self:SetNearVictoryThreshold(0.10, self.data.berserkTimer*0.9, 0.70); -- Near Victory theme when the boss gets below 10%, the time left is above 10% of berserk timer and 70% of the raid is alive.

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_MADNESS");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(self.data.berserkTimer, true);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleDecimate(110);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        -- Hack to deal with the unusual way Gluth is engaged.

        local hasTarget = self:GetTargetInfo();
        if ( hasTarget and self.status == "STANDBY" and UnitAffectingCombat("player") ) then
            self:OnEngaged();
            self.data.ignoreLeaveCombat = true;
            self.EventWatcher:GetDriver():AddEvent("RestoreCombatCheck", 45, "", "", "HIDDEN", self.RestoreCombatCheck, self);
        end

        Shared.OnUpdate(self, elapsed);
    end,

    OnCombatEvent = {
        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...)
            if ( self.running ) and ( spellId == 28375 or spellId == 54426 ) and ( actorGUID ) and ( actorGUID == self.data.guid ) then
                self:OnDecimate();
            end

            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, ...);
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleDecimate = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Decimate", timer, "AUTO", self:Localize("Decimate"), "ALERT");
    end,

    RestoreCombatCheck = function(self)
        self.data.ignoreLeaveCombat = false;
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnDecimate = function(self)
        if (( GetTime() - self.data.lastDecimate ) < 10) then return; end
        self.data.lastDecimate = GetTime();
        self:ScheduleDecimate(108);

        self:AddRelevantTargets(ZOMBIE_ID);
        self.EventWatcher:GetDriver():ClearEvent("RevokeDamageCount");
        self.EventWatcher:GetDriver():AddEvent("RevokeDamageCount", 30, "", "", "HIDDEN", self.RemoveRelevantTargets, self, ZOMBIE_ID);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(15932, THIS_MODULE, true);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
