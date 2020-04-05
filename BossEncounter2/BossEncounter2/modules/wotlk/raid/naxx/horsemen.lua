local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Four Horsemen Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Four Horsemen fight.

-- 25-man version:
-- No change.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Meteor"] = "Meteor",

        -- 3. Misc
        ["Title"] = "Four Horsemen",
        ["MarkAlert"] = ">> %s has %d stacks of %s's mark ! <<",
        ["MarkSelf"] = "Check your marks !",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Meteor"] = "Météore",

        -- 3. Misc
        ["Title"] = "Quatre Cavaliers",
        ["MarkAlert"] = ">> %s a %d empilements de la marque de %s ! <<",
        ["MarkSelf"] = "Contrôlez vos marques !",
    },
};

local KORTHAZZ_MARK  = select(1, GetSpellInfo(28832));
local RIVENDARE_MARK = select(1, GetSpellInfo(28834));
local BLAUMEUX_MARK  = select(1, GetSpellInfo(28833));
local ZELIEK_MARK    = select(1, GetSpellInfo(28835));

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnMark",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Marks (5+)",
            ["frFR"] = "Annoncer les marques (5+)",
        },
        explain = {
            ["default"] = "Display a raid alert when someone gets 5 stacks or above of one of the marks.",
            ["frFR"] = "Affiche une alerte de raid quand quelqu'un obtient 5 empilements ou plus d'une des marques.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Horsemen";

local marks = {
    [1] = {
        id = "korthazz",
        debuff = KORTHAZZ_MARK,
        text = "|cff00ff00%d|r",
        mob = "Korthazz",
    },
    [2] = {
        id = "rivendare",
        debuff = RIVENDARE_MARK,
        text = "|cffff00ff%d|r",
        mob = Root.ReadLocTable({["enUS"] = "Rivendare", ["frFR"] = "Vaillefendre"}),
    },
    [3] = {
        id = "blaumeux",
        debuff = BLAUMEUX_MARK,
        text = "|cffff0000%d|r",
        mob = "Blaumeux",
    },
    [4] = {
        id = "zeliek",
        debuff = ZELIEK_MARK,
        text = "|cffffffff%d|r",
        mob = "Zeliek",
    },
};

local UnitListMarkAlgorithm = {
    updateRate = 0.500,

    title = {
        ["default"] = "Mark counter",
        ["frFR"] = "Compteur de marques",
    },
    summary = {
        ["default"] = "|cff00ff00Korthazz |cffff00ffRiven. |cffff0000Blaum. |cffffffffZeliek",
        ["frFR"] = "|cff00ff00Korthazz |cffff00ffVaille. |cffff0000Blaum. |cffffffffZeliek",
    },

    lastCount = {},

    OnRefresh = function(self, driver, myTable)
        local i, guid, name, uid, m;
        local found, timeLeft, stackCount, totalCount, lastCount;
        local flash = false;

        -- Make sure the last count table is defined for each mark.
        for m=1, #marks do
            if type(self.lastCount[marks[m].id]) ~= "table" then self.lastCount[marks[m].id] = {}; end
        end

        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            if ( uid ) then
                if ( UnitInParty(uid) or UnitInRaid(uid) ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitIsVisible(uid) ) then
                    local unitTable = driver:Allocate();
                    unitTable.guid = guid;
                    unitTable.text = "";
                    totalCount = 0;

                    for m=1, #marks do
                        found, timeLeft, stackCount = Root.Unit.SearchEffect(uid, "DEBUFF", marks[m].debuff);
                        stackCount = stackCount or 0;
                        totalCount = totalCount + stackCount;
                        unitTable[marks[m].id] = stackCount;
                        unitTable.text = unitTable.text..format(marks[m].text, stackCount);
                        unitTable.text = unitTable.text.." ";

                        lastCount = self.lastCount[marks[m].id];
                        if ( stackCount > (lastCount[guid] or 0) ) then
                            Root[THIS_MODULE]:OnMark(m, stackCount, guid, name);
                        end
                        lastCount[guid] = stackCount;

                        if ( guid == UnitGUID("player") ) and ( stackCount >= 4 ) then
                            flash = true;
                        end
                    end

                    unitTable.count = totalCount;
                    unitTable.text = unitTable.text.."|cffffff00("..totalCount..")";
                    myTable[#myTable+1] = unitTable;
                end
            end
        end

        if ( flash ) then
            driver:ToggleFlash(1, 0, 0);
      else
            driver:ToggleFlash(nil);
        end

        Root.Sort.ByNumericField(myTable, "count", true);
        local title = Root.ReadLocTable(self.title);
        local summary = Root.ReadLocTable(self.summary);
        return title, summary;
    end,
};

local ALERT_COOLDOWN = 3.000;

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

        self:SetDummyBossUnit("worldboss", 60, UnitAffectingCombat(uid)); -- No NPC is set as the main boss.

        data.title = self:Localize("Title");
        data.baseID = THIS_MODULE;

        data.nearVictoryTriggered = false; -- Special way of handling near victory theme in this fight.
        data.alertAllowed = 2;
        data.alertCooldown = ALERT_COOLDOWN;

        self:SetDifficultyMeter(0.35, 0.30, 0.20, 0.35, 0.35); -- P/B/A/C/S

        self:PrepareBasicWidgets(1200, true);
        self.BossBar:Remove(true); -- Not needed.

        Root.Music.Play("PREPARATION_GENERAL");

        self:ResetAdds();
        self:RegisterAdd(16064, false);
        self:RegisterAdd(30549, false);
        self:RegisterAdd(16065, false);
        self:RegisterAdd(16063, false);

        self.UnitList:GetDriver():AssignAlgorithm(UnitListMarkAlgorithm);
        self.UnitList:Display();
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(240, 480);

        self:UpdateAddsCount(false);

        Root.Music.Play("THEME_NAXXRAMAS_ENDWING");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(1200, true);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleMeteor(12);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        -- Handle alert cooldown to prevent spam
        if ( self.data.alertAllowed < 2 ) then
            self.data.alertCooldown = max(0, self.data.alertCooldown - elapsed);
            if ( self.data.alertCooldown == 0 ) then
                self.data.alertAllowed = self.data.alertAllowed + 1;
                self.data.alertCooldown = ALERT_COOLDOWN;
            end
        end

        Shared.OnUpdate(self, elapsed);
    end,

    OnCombatEvent = {
        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            -- Don't do a GUID check for spellcasting because the main boss is not fixed.

            if ( self.running ) and ( spellId == 28884 or spellId == 57467 ) then 
                self:ScheduleMeteor(13.5);
            end
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleMeteor = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Meteor", timer, "AUTO", self:Localize("Meteor"), "NORMAL");  
    end,

    CheckStandardClear = function(self)
        -- Overide the clear check function to incorporate the near victory trigger.

        local data = self.data;
        local addRemaining = self:GetNumAddsAlive();

        if ( addRemaining == 0 ) then
            self:OnCleared();
    elseif ( addRemaining == 1 ) and ( not data.nearVictoryTriggered ) then
            data.nearVictoryTriggered = true;
            Root.Music.Play("VICTORYNEAR");
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnMark = function(self, index, count, guid, name)
        if ( not self.running ) then return; end
        if ( count >= 5 ) and ( not Root.IsBlacklisted(name) ) then
            if ( self:GetSetting("warnMark") ) and ( self.data.alertAllowed > 0 ) then
                self.data.alertAllowed = self.data.alertAllowed - 1;
                self:AnnounceToRaid(self:FormatLoc("MarkAlert", name, count, marks[index].mob or "?"));
            end
            self:RegisterHealAssist(guid, 0, 5, nil);
        end
        if ( count >= 4 ) and ( guid == UnitGUID("player") ) then
            self:AlertMe(self:Localize("MarkSelf"));
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(16064, THIS_MODULE, false);
    Root.NPCDatabase.Register(30549, THIS_MODULE, false);
    Root.NPCDatabase.Register(16065, THIS_MODULE, false);
    Root.NPCDatabase.Register(16063, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
