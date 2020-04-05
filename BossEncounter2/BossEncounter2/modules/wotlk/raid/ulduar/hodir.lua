local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Hodir Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Hodir fight.

-- 25-man version:
-- No change.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["ClearTrigger"] = "I am released from his grasp!",

        -- 2. Events
        ["NextFlashFreeze"] = "Next Flash Freeze",
        ["FlashFreeze"] = "Flash Freeze",
        ["FrozenBlows"] = "CD: Frozen Blows",
        ["FrozenBlowsEnd"] = "Frozen Blows: end",

        -- 3. Misc
        ["FlashFreezeAlert"] = ">> Get ready to go on a mound ! <<",
        ["BitingColdAlert"] = ">> %s has %d stacks of Biting Cold !! <<",
        ["BitingColdSelf"] = "Stop standing still !",
    },
    ["frFR"] = {
        -- 1. Yells
        ["ClearTrigger"] = "de son emprise",

        -- 2. Events
        ["NextFlashFreeze"] = "Gel instant. suivant",
        ["FlashFreeze"] = "Gel instantané",
        ["FrozenBlows"] = "Recharge: Coups gelés",
        ["FrozenBlowsEnd"] = "Coups gelés: fin",

        -- 3. Misc
        ["FlashFreezeAlert"] = ">> Préparez-vous à monter sur un monticule ! <<",
        ["BitingColdAlert"] = ">> %s a %d empilements de Froid mordant !! <<",
        ["BitingColdSelf"] = "Ne restez pas immobile !",
    },
};

local BITING_COLD = GetSpellInfo(62188);
local FROZEN_DEBUFF = GetSpellInfo(61969);

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnFlashFreeze",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Flash Freeze",
            ["frFR"] = "Annoncer les gels instantanés",
        },
        explain = {
            ["default"] = "Display a raid alert for Flash Freezes.",
            ["frFR"] = "Affiche une alerte de raid pour les gels instantanés.",
        },
    },
    [2] = {
        id = "warnBitingCold",
        type = "BOOLEAN",
        lock = "WARNING",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Biting Cold (3+)",
            ["frFR"] = "Annoncer Froid mordant (3+)",
        },
        explain = {
            ["default"] = "Display a raid alert when someone gets 3 stacks or above of Biting Cold debuff.\n\nTip - Enable this only when you learn the encounter.",
            ["frFR"] = "Affiche une alerte de raid quand quelqu'un obtient 3 empilements ou plus de l'affaiblissement Froid mordant.\n\nConseil - N'activez ceci que lorsque vous apprenez le combat.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Hodir";

local ALERT_COOLDOWN = 3.000; -- Time before a new biting cold alert can be made.

local npc = {
    -- The faction key is the faction of the LOCAL PLAYER.
    -- Filter specifies in which modes the NPC is there.

    ["ALLIANCE"] = {
        { id = 32897, filter = 0x03, class = "PRIEST" , role = "HEAL" }, -- Field Medic Penny [10/25]
        { id = 33326, filter = 0x02, class = "PRIEST" , role = "HEAL" }, -- Field Medic Jessi [25]
        { id = 32893, filter = 0x03, class = "MAGE"   , role = "DPS"  }, -- Missy Flamecuffs [10/25]
        { id = 33327, filter = 0x02, class = "MAGE"   , role = "DPS"  }, -- Sissy Flamecuffs [25]
        { id = 32901, filter = 0x03, class = "DRUID"  , role = "DPS"  }, -- Ellie Nightfeather [10/25]
        { id = 33325, filter = 0x02, class = "DRUID"  , role = "DPS"  }, -- Eivi Nightfeather [25]
        { id = 32900, filter = 0x03, class = "SHAMAN" , role = "DPS"  }, -- Elementalist Avuun [10/25]
        { id = 33328, filter = 0x02, class = "SHAMAN" , role = "DPS"  }, -- Elementalist Mahfuun [25]

    },
    ["HORDE"] = {
        { id = 32948, filter = 0x03, class = "PRIEST" , role = "HEAL" }, -- Battle-Priest Eliza [10/25]
        { id = 33330, filter = 0x02, class = "PRIEST" , role = "HEAL" }, -- Battle-Priest Gina [25]
        { id = 32946, filter = 0x03, class = "MAGE"   , role = "DPS"  }, -- Veesha Blazeweaver [10/25]
        { id = 33331, filter = 0x02, class = "MAGE"   , role = "DPS"  }, -- Amira Blazeweaver [25]
        { id = 32941, filter = 0x03, class = "DRUID"  , role = "DPS"  }, -- Tor Greycloud [10/25]
        { id = 33333, filter = 0x02, class = "DRUID"  , role = "DPS"  }, -- Kar Greycloud [25]
        { id = 32950, filter = 0x03, class = "SHAMAN" , role = "DPS"  }, -- Spiritwalker Yona [10/25]
        { id = 33332, filter = 0x02, class = "SHAMAN" , role = "DPS"  }, -- Spiritwalker Tara [25]
    },
};

local UnitListBitingColdAlgorithm = {
    updateRate = 0.250,

    title = {
        ["default"] = "Biting Cold counter",
        ["frFR"] = "Compteur de Froid mordant",
    },
    summary = {
        ["default"] = "Move to reset it.",
        ["frFR"] = "Bougez pour l'enlever.",
    },

    lastCount = {},

    OnRefresh = function(self, driver, myTable)
        local i, guid, name, uid;
        local found, timeLeft, stackCount;
        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            if ( uid ) then
                if ( UnitInParty(uid) or UnitInRaid(uid) ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitIsVisible(uid) ) then
                    found, timeLeft, stackCount = Root.Unit.SearchEffect(uid, "DEBUFF", BITING_COLD);
                    local realCount = 0;
                    if ( found ) then
                        local unitTable = driver:Allocate();
                        unitTable.guid = guid;
                        unitTable.text = tostring(stackCount);
                        unitTable.count = stackCount;
                        myTable[#myTable+1] = unitTable;
                        realCount = stackCount;
                    end
                    if ( realCount > (self.lastCount[guid] or 0) ) then
                        Root[THIS_MODULE]:OnBitingCold(realCount, guid, name);
                    end
                    if ( guid == UnitGUID("player") ) then
                        if ( realCount >= 3 ) then
                            driver:ToggleFlash(1, 0, 0);
                      else
                            driver:ToggleFlash(nil);
                        end
                    end
                    self.lastCount[guid] = realCount;
                end
            end
        end
        Root.Sort.ByNumericField(myTable, "count", true);
        local title = Root.ReadLocTable(self.title);
        local summary = Root.ReadLocTable(self.summary);
        return title, summary;
    end,
};

local allyList = { };

local FrozenAlgorithm = {
    label = {
        ["default"] = "Frozen",
        ["frFR"] = "Gelé(e)",
    },
    layout = 3,
    allowDead = false,

    GetValue = function(self, uid)
        Root[THIS_MODULE]:UpdateFreezeStatus(uid);

        local guid = UnitGUID(uid);
        return self:GetValueMasked(guid);
    end,

    GetValueMasked = function(self, guid)
        return Root[THIS_MODULE]:GetFreezeStatus(guid);
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

        data.clearAnimation = "ALTERNATE";
        data.alertAllowed = 2;
        data.alertCooldown = ALERT_COOLDOWN;
        data.freezeList = { };

        self:GrabStaticWidgets();

        self:SetBossUnit(uid);

        self:SetDifficultyMeter(0.65, 0.80, 0.65, 0.35, 0.25); -- P/B/A/C/S

        self:PrepareBasicWidgets(480, true);

        self.UnitList:GetDriver():AssignAlgorithm(UnitListBitingColdAlgorithm);
        self.UnitList:Display();

        self.AddWindow:GetDriver():AssignAlgorithm(FrozenAlgorithm);

        self:ResetAdds();
        local info;
        for _, info in pairs(allyList) do
            if ( self:IsMatchingFilter(info.filter) ) then
                self:RegisterAddEX(info.id, true, "DB", info.class, info.role);
            end
        end
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(150, 480);
        self:SetNearVictoryThreshold(0.10, 480-60, 0.70); -- Near Victory theme when the boss gets below 10%, there is 1 minute left and 70% of the raid is alive.

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER8_SURVIVAL1");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(480, true);

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("ClearTrigger"), self.OnCleared, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        -- self:ScheduleFlashFreeze(50);
        self:ScheduleFrozenBlows(60);
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
            if ( self.running ) and ( spellId == 61968 ) then
                self:OnFlashFreeze();
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellId == 62478 or spellId == 63512 ) then
                    self:OnFrozenBlows();
                end
                if ( spellName == FROZEN_DEBUFF ) then
                    self:SetFreezeStatus(targetGUID, true);
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellName == FROZEN_DEBUFF ) then
                self:SetFreezeStatus(targetGUID, false);
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    ScheduleFlashFreeze = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("NextFlashFreeze", timer, "AUTO", self:Localize("NextFlashFreeze"), "WARNING_NOREMINDER");  
    end,

    ScheduleFrozenBlows = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("FrozenBlows", timer, "AUTO", self:Localize("FrozenBlows"), self:IfRole("SHIELD", "WARNING_NOREMINDER", "NORMAL"));  
    end,

    UpdateFreezeStatus = function(self, uid)
        if ( not self.running ) then return; end

        -- local found, timeLeft, stackCount = Root.Unit.SearchEffect(uid, "DEBUFF", FROZEN_DEBUFF);
        local found, timeLeft, stackCount = Root.Unit.SearchEffect(uid, "BUFF", FROZEN_DEBUFF);
        local guid = UnitGUID(uid);

        self:SetFreezeStatus(guid, found);
    end,

    SetFreezeStatus = function(self, guid, state)
        if ( not self.running ) then return; end

        local id = Root.Unit.GetMobID(guid) or guid;
        self.data.freezeList[tostring(id)] = state;
    end,

    GetFreezeStatus = function(self, guid)
        if ( not self.running ) then return 0, 0; end

        local id = Root.Unit.GetMobID(guid) or guid;
        local value = self.data.freezeList[tostring(id)];

        if ( value == nil ) or ( value == true ) then
            return 1, 1;
    elseif ( value == false ) then
            return 0, 0;
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnFlashFreeze = function(self)
        if ( self:GetSetting("warnFlashFreeze") ) then
            self:AnnounceToRaid(self:Localize("FlashFreezeAlert"));
        end
        self.EventWatcher:GetDriver():TriggerEvent("NextFlashFreeze");
        self.EventWatcher:GetDriver():AddEvent("FlashFreeze", 9.00, "AUTO", self:Localize("FlashFreeze"), "ALERT");  
        self:ScheduleFlashFreeze(50);
    end,

    OnFrozenBlows = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("FrozenBlows");
        self:ScheduleFrozenBlows(50);
        self.EventWatcher:GetDriver():AddEvent("FrozenBlowsEnd", 20.00, "AUTO", self:Localize("FrozenBlowsEnd"), self:IfRole("SHIELD", "WARNING", "NORMAL")); 

        local bossTargetGUID = self:GetTargetInfo();
        if ( bossTargetGUID ) then
            self:RegisterHealAssist(bossTargetGUID, 0, 20, nil);
        end
    end,

    OnBitingCold = function(self, count, guid, name)
        if ( not self.running ) then return; end
        if ( count >= 3 ) and ( not Root.IsBlacklisted(name) ) then
            if ( self:GetSetting("warnBitingCold") ) and ( self.data.alertAllowed > 0 ) then
                self.data.alertAllowed = self.data.alertAllowed - 1;
                self:AnnounceToRaid(self:FormatLoc("BitingColdAlert", name, count));
            end
            self:RegisterHealAssist(guid, 0, 5, nil);
        end
        if ( count >= 2 ) and ( guid == UnitGUID("player") ) then
            self:AlertMe(self:Localize("BitingColdSelf"), 0.500, 3.000);
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.NPCDatabase.Register(32845, THIS_MODULE, false);
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);


    -- Browse the table according to the local player's faction.
    allyList = npc[Root.GetPlayerFaction()];
end
