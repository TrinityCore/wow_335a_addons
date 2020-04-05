local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Grand Champions Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Grand Champions fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["ClearTrigger"] = "Your next",

        -- 2. Events

        -- 3. Misc
        ["Title"] = "Grd. Champions",
    },
    ["frFR"] = {
        -- 1. Yells
        ["ClearTrigger"] = "Votre prochain défi",

        -- 2. Events

        -- 3. Misc
        ["Title"] = "Grd. Champions",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "G-Champions";

local npc = {
    -- The faction key is the faction of the LOCAL PLAYER.
    -- That means the content of the table is the ENEMY NPCs this faction will have to face.

    ["ALLIANCE"] = { 35572, 35571, 35617, 35569, 35570 },
    ["HORDE"] = { 34702, 34701, 34657, 34703, 34705 },
};

local enemyList = { }; -- Will automatically be set.

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

        local data = self.data;

        data.ignoreList = { };
        data.onMount = false;

        data.title = self:Localize("Title");
        data.baseID = THIS_MODULE;

        self:GrabStaticWidgets();

        self:SetDummyBossUnit("elite", 240, UnitAffectingCombat(uid));

        self:PrepareBasicWidgets(nil, false);
        self.BossBar:Remove(true); -- Not needed.

        self:ResetAdds();
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(80, 180, 5);

        self:UpdateAddsCount(false);

        -- Root.Music.Play("THEME_MADNESS");

        self.StatusFrame:GetDriver():StartTiming();

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("ClearTrigger"), self.OnCleared, self);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = function(self, isWipe)
        if ( not self.running ) then return; end

        -- This encounter is special, because players could get a Failure although they just passed the first part of the encounter (the mounted combat).
        -- That's why we will prevent Failure from occuring if the encounter fails for any reason while the player is on a mount.

        if ( self.data.onMount ) then
            Shared.OnFailed(self, false);
      else
            Shared.OnFailed(self, isWipe);
        end
        return;
    end,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        local i, guid, name, uid, id;
        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            id = Root.Unit.GetMobID(guid);
            if ( uid ) and ( self:IsValidAdd(id) ) then
                if ( not self.data.ignoreList[guid] ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitHealth(uid) > 0 ) then
                    self.data.ignoreList[guid] = true;
                    self:RegisterAdd(id, false);
                end
            end
        end

        if UnitExists("vehicle") then
            self.data.onMount = true;
        end

        Shared.OnUpdate(self, elapsed);
    end,

    OnCombatEvent = Shared.OnCombatEvent,

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    IsValidAdd = function(self, id)
        if ( not id ) then return false; end
        local check;
        for _, check in ipairs(enemyList) do
            if ( check == id ) then return true; end
        end
        return false;
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
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);


    -- Browse the table according to the local player's faction.
    enemyList = npc[Root.GetPlayerFaction()];

    -- Register all possible NPCs.
    local id;
    for _, id in ipairs(enemyList) do
        Root.NPCDatabase.Register(id, THIS_MODULE, false);
    end
end
