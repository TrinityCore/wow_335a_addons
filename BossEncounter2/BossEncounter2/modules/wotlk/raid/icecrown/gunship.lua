local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Gunship Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Gunship fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["ClearTrigger"] = "brothers and sisters|Onward to the Lich King",

        -- 2. Events

        -- 3. Misc
        ["Title"] = "Gunship",
        ["BuffAlert"] = "The commander has %d stacks!",
    },
    ["frFR"] = {
        -- 1. Yells
        ["ClearTrigger"] = "Vous direz pas que|vers le [Rr]oi [Ll]iche",

        -- 2. Events

        -- 3. Misc
        ["Title"] = "Canonnière",
        ["BuffAlert"] = "Le commandant a %d empilements !",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "buffThreshold",
        type = "NUMBER",
        label = {
            ["default"] = "Alert threshold",
            ["frFR"] = "Seuil de l'alerte",
        },
        explain = {
            ["default"] = "When the enemy commander gets a number of powerup stacks equal to the value of this slider, an alert will trigger if you are his target.",
            ["frFR"] = "Quand le commandant ennemi obtient un nombre d'empilements du powerup égal à la valeur de cette glissière, une alerte sera déclenchée si vous êtes sa cible.",
        },
        min = 15,
        max = 30,
        step = 1,
        defaultValue = 25,
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Gunship";

-- The following will automatically be set.
local ENEMY_GUNSHIP_ID = -1;
local ALLY_GUNSHIP_ID  = -1;
local ENEMY_COMMANDER_ID = -1;
local ALLY_COMMANDER_ID  = -1;

local battleFury = {
    [69638] = true,
    [72306] = true,
    [72307] = true,
    [72308] = true,
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

    OnTrigger = function(self)
        if not self:TriggerMe() then return; end

        local data = self.data;

        data.clearLockdown = 1200; -- Block retriggering of this boss module for 20 minutes upon clear.
        data.ignoreAdds = true;
        data.silentAddKills = true;
        data.title = self:Localize("Title");

        self:GrabStaticWidgets();

        self:SetDummyBossUnit("worldboss", 180, UnitExists("boss1"));

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.30, 0.30, 0.30, 0.20, 0.20); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.20, 0.20, 0.20, 0.20, 0.20); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(nil, false);
        self.BossBar:Remove(true); -- Not yet.

        self:ResetYellCallbacks();
        self:RegisterYellCallback("ANY", self:Localize("ClearTrigger"), self.OnCleared, self);

        self:CheckCommanderPresence();

        self:SearchUnit(ENEMY_GUNSHIP_ID, self.OnBossFound);

        Root.Music.Play("PREPARATION_GENERAL");
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(300, 600);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("THEME_MADNESS");

        self.StatusFrame:GetDriver():StartTiming();

        self:ResetAdds();
        self:RegisterAddEX(ENEMY_GUNSHIP_ID, false, "DISABLE");
        self:RegisterAddEX(ALLY_GUNSHIP_ID, true, "DISABLE");
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                local id = Root.Unit.GetMobID(targetGUID);
                if ( battleFury[spellId] ) and ( id == ENEMY_COMMANDER_ID ) then
                    self:OnBattleFury(targetGUID, stackAmount);
                end
            end
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    CheckCommanderPresence = function(self)
        if ( self.status ~= "STANDBY" ) then return; end
        -- Try to find the ally commander. If he is found, that means we are in the boss zone and the module should keep running till the appropriate engage.

        local guid = Root.Unit.GetGUIDFromMobID(ALLY_COMMANDER_ID);
        if ( guid ) then
            self.data.timeOutTimer = 0;
        end

        self.EventWatcher:GetDriver():AddEvent("CheckCommander", 1.00, "", "", "HIDDEN", self.CheckCommanderPresence, self);
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnBossFound = function(self, uid)
        self:OnEngaged(); -- If the boss is found, that means it is engaged.

        self.data.name = UnitName(uid);
        self.data.guid = UnitGUID(uid);
        self.data.bossMaxHealth = UnitHealthMax(uid);
        self.data.bossDead = false;

        self.BossBar:Display();
        self.BossBar:GetDriver():SetWatch(self.data.guid);
    end,

    OnBattleFury = function(self, guid, count)
        if ( count == self:GetSetting("buffThreshold") ) then
            local tGUID = self:GetTargetInfo(guid);
            if ( tGUID == UnitGUID("player") ) then
                self:AlertMe(self:FormatLoc("BuffAlert", count), 0.400, 4.000);
            end
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;

    -- Determinate correct mobID according to the local player's faction.
    if ( Root.GetPlayerFaction() == "ALLIANCE" ) then
        ENEMY_GUNSHIP_ID = 37215;
        ALLY_GUNSHIP_ID  = 37540;
        ENEMY_COMMANDER_ID = 36939; -- Saurfang
        ALLY_COMMANDER_ID  = 36948; -- Muradin
  else
        ENEMY_GUNSHIP_ID = 37540;
        ALLY_GUNSHIP_ID  = 37215;
        ENEMY_COMMANDER_ID = 36948; -- Muradin
        ALLY_COMMANDER_ID  = 36939; -- Saurfang
    end

    Root.NPCDatabase.Register(ALLY_COMMANDER_ID, THIS_MODULE, true, true); -- Bypass friendly check.
    Root.NPCDatabase.Register(ENEMY_COMMANDER_ID, THIS_MODULE, true); -- In case of.
    Root.NPCDatabase.Register(ENEMY_GUNSHIP_ID, THIS_MODULE, true);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
