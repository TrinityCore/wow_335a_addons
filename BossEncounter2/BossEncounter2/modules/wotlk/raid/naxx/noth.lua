local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Noth Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Noth fight.

-- 25-man version:
-- No change

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        -- ["TeleportAlert"] = "teleport",

        -- 2. Events
        ["Curse"] = "Curse",
        ["CurseExplosion"] = "Curse explosion",
        ["TeleportToBalcony"] = "Teleport: Balcony",
        ["TeleportToRoom"] = "Teleport: Room",

        -- 3. Misc
    },
    ["frFR"] = {
        -- 1. Yells
        -- ["TeleportAlert"] = "se téléporte",

        -- 2. Events
        ["Curse"] = "Malédiction",
        ["CurseExplosion"] = "Explosion des malé.",
        ["TeleportToBalcony"] = "Téléport.: balcon",
        ["TeleportToRoom"] = "Téléport.: salle",

        -- 3. Misc
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Noth";

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

        data.toBalconyTimer = 90;
        data.toRoomTimer = 70;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        data.title = "Noth";

        self:SetDifficultyMeter(0.20, 0.10, 0.25, 0.10, 0.05); -- P/B/A/C/S

        self:PrepareBasicWidgets(nil, true);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(180, 360);

        self:ChangePhase(1, true);

        Root.Music.Play("TIER7_TANKNSPANK1");

        self.StatusFrame:GetDriver():StartTiming();

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleCurse(10);
        self:ScheduleTeleport("BALCONY");
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( spellId == 29213 or spellId == 54835 ) and ( actorGUID ) and ( actorGUID == self.data.guid ) then
                self:OnCurse();
            end
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleCurse = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Curse", timer, "AUTO", self:Localize("Curse"), "WARNING_NOREMINDER");
    end,

    ScheduleTeleport = function(self, where)
        if ( where == "BALCONY" ) then
            self.EventWatcher:GetDriver():AddEvent("TeleportToBalcony", self.data.toBalconyTimer, "AUTO", self:Localize("TeleportToBalcony"), "WARNING_NOREMINDER", self.OnBalcony, self);
    elseif ( where == "ROOM" ) then
            self.EventWatcher:GetDriver():AddEvent("TeleportToRoom", self.data.toRoomTimer, "AUTO", self:Localize("TeleportToRoom"), "WARNING_NOREMINDER", self.OnRoom, self);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnCurse = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Curse");
        self.EventWatcher:GetDriver():AddEvent("CurseExplosion", 10, "AUTO", self:Localize("CurseExplosion"), "ALERT");
        self:ScheduleCurse(60);
    end,

    OnBalcony = function(self)
        self:ChangePhase(2, true);

        self.data.timeOut = 120;
        self.data.timeOutTimer = 0;

	if ( self.data.toBalconyTimer == 90 ) then
	    self.data.toBalconyTimer = 110;
    elseif ( self.data.toBalconyTimer == 110 ) then
	    self.data.toBalconyTimer = 180;
	end

        self.EventWatcher:GetDriver():ClearEvent("Curse");

        self:ScheduleTeleport("ROOM");
    end,

    OnRoom = function(self)
        self:ChangePhase(1, true);

        self.data.timeOut = 60;
        self.data.timeOutTimer = 0;

	if ( self.data.toRoomTimer == 70 ) then
	    self.data.toRoomTimer = 95;
    elseif ( self.data.toRoomTimer == 95 ) then
	    self.data.toRoomTimer = 120;
	end

        self:ScheduleTeleport("BALCONY");
        self:ScheduleCurse(15);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(15954, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
