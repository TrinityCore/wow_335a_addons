local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Freya Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Freya fight.

-- 25-man version:
-- No change.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells
        ["ConservatorTrigger"] = "Eonar, your servant requires aid",
        ["DetonateTrigger"] = "The swarm of the elements shall overtake you",
        ["TrioTrigger"] = "Children, assist me",
        ["TreeTrigger"] = "begins to grow",
        ["ClearTrigger"] = "His hold on me dissipates.",

        -- 2. Events
        ["Sunbeam"] = "Sunbeam",
        ["Tremor"] = "Tremor",

        -- 3. Misc
        ["TreeAlert"] = "A tree is growing !",
        ["GripAlert"] = "Take cover under a mushroom !",
        ["NatureFurySelf"] = "You have the bomb !",
        ["NatureFuryWarning"] = ">> {rt7} %s has the bomb ! {rt7} <<",
        ["TremorAlert"] = "Stop casting !",
        ["RootWarning"] = ">> Root on: <<",
    },
    ["frFR"] = {
        -- 1. Yells
        ["ConservatorTrigger"] = "Eonar, ta servante a besoin d'aide",
        ["DetonateTrigger"] = "La nuée des éléments va vous submerger",
        ["TrioTrigger"] = "Mes enfants, venez m'aider",
        ["TreeTrigger"] = "commence à pousser",
        ["ClearTrigger"] = "Son emprise sur moi se dissipe.",

        -- 2. Events
        ["Sunbeam"] = "Rayon de soleil",
        ["Tremor"] = "Tremblement de terre",

        -- 3. Misc
        ["TreeAlert"] = "Un arbre pousse !",
        ["GripAlert"] = "Allez sous un champignon !",
        ["NatureFurySelf"] = "Vous avez la bombe !",
        ["NatureFuryWarning"] = ">> {rt7} %s a la bombe ! {rt7} <<",
        ["TremorAlert"] = "Arrêtez d'incanter !",
        ["RootWarning"] = ">> Racine sur: <<",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "warnNatureFury",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Nature's Fury",
            ["frFR"] = "Annoncer la Fureur de la nature",
        },
        explain = {
            ["default"] = "Display a raid alert and put a symbol on the character that gets the Nature's Fury bomb.",
            ["frFR"] = "Affiche une alerte de raid et place un symbole sur la personne qui obtient la bombe de la Fureur de la nature.",
        },
    },
    [2] = {
        id = "warnRoot",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Warn Roots",
            ["frFR"] = "Annoncer les racines",
        },
        explain = {
            ["default"] = "Display a raid alert and put symbols on characters affected by roots.\n\nOnly applicable to hard mode.",
            ["frFR"] = "Affiche une alerte de raid et place des symboles sur les personnes affectées par les racines.\n\nSeulement applicable au mode difficile.",
        },
    },
    [3] = {
        id = "sunbeamSymbol",
        type = "BOOLEAN",
        lock = "SYMBOL",
        lockValue = false,
        defaultValue = false,
        oneEnabledOnly = true,
        label = {
            ["default"] = "Symbol: Sunbeam",
            ["frFR"] = "Symbole: Rayon de soleil",
        },
        explain = {
            ["default"] = "Put the square symbol on the target of the Sunbeam.",
            ["frFR"] = "Place le symbole carré sur la cible du Rayon de soleil.",
        },
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Freya";

local MUSIC_USED = {
    [0] = "TIER8_SURVIVAL3", -- 0 elder encounter
    [1] = "TIER8_DPSRACE1", -- 1 elder
    [2] = "TIER8_DPSRACE2", -- 2 elders
    [3] = "TIER8_DPSRACE3", -- 3 elders
};

local STORMLASHER_ID = 32919;
local SNAPLASHER_ID  = 32916;
local ELEMENTAL_ID   = 33202;
local CONSERVATOR_ID = 33203;

local BUFF_LIST = {
    ["BRIGHTLEAF"] = select(1, GetSpellInfo(62385)),
    ["IRONBRANCH"] = select(1, GetSpellInfo(62387)),
    ["STONEBARK"] = select(1, GetSpellInfo(62386)),
};

local REVIVABLE_ADDS = {
    [STORMLASHER_ID] = true,
    [SNAPLASHER_ID] = true,
    [ELEMENTAL_ID] = true,
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

        data.waveCount = 0;
        data.numElders = 0;
        data.elderChecklist = { };
        data.rootList = { };
        data.deathTime = { };
        data.ignoreAdds = true;
        data.silentAddKills = true;
        data.clearAnimation = "ALTERNATE";

        self:PrepareBasicWidgets(600, true);

        self.UnitList:Display();
        self.UnitList:GetDriver():AssignAlgorithm("DISTANCE_TOOCLOSE", false, 8);

        self:DefineRevivableAdds(REVIVABLE_ADDS, 12);
        self.AddWindow:GetDriver():AssignAlgorithm("REVIVE", THIS_MODULE);

        self:ResetAdds();
        self:RegisterAddEX(ELEMENTAL_ID, false, "DB");
        self:RegisterAddEX(SNAPLASHER_ID, false, "DB");
        self:RegisterAddEX(STORMLASHER_ID, false, "DB");
        self:RegisterAddEX(CONSERVATOR_ID, false, "DB");

        self:CheckElders();
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self.EventWatcher:GetDriver():AddEvent("ValidateElders", 5.000, "", "", "HIDDEN", self.ValidateElders, self);

        self:ChangePhase(1, true);

        self:SetScoreBenchmarks(420, 600);
        self:SetNearVictoryThreshold(0.25, 600-120, 0.70); -- Near Victory theme when the boss gets below 25.0%, there's at least 2 minutes left and 70% of the raid is alive.

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(600, true);

        self:ResetYellCallbacks();
        self:RegisterYellCallback(nil, self:Localize("ClearTrigger"), self.OnCleared, self);
        self:RegisterYellCallback(nil, self:Localize("ConservatorTrigger"), self.OnWaveTypeKnown, self, 3);
        self:RegisterYellCallback(nil, self:Localize("DetonateTrigger"), self.OnWaveTypeKnown, self, 2);
        self:RegisterYellCallback(nil, self:Localize("TrioTrigger"), self.OnWaveTypeKnown, self, 1);
        self:RegisterYellCallback("ANY", self:Localize("TreeTrigger"), self.OnTreeSpawn, self);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleNextWave(8.6);
        self:ScheduleSunbeam(15);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 62678 ) then
                    self:OnWaveSpawn();
                end
                if ( spellId == 62589 or spellId == 63571 ) and ( targetGUID ) then
                    self:OnNatureFury(targetGUID, targetName);
                end
            end
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                if ( spellId == 62623 or spellId == 62872 ) then
                    self:OnSunbeam();
                end
                if ( spellId == 62532 ) then
                    self:OnGrip();
                end
                if ( spellId == 62437 or spellId == 62859 or spellId == 62325 or spellId == 62932 ) then
                    self:OnTremor();
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 62861 or spellId == 62930 or spellId == 62283 or spellId == 62438 ) and ( targetGUID ) then
                if ( not Root.IsBlacklisted(targetName) ) then
                    self:OnRoot();
                    tinsert(self.data.rootList, targetGUID);
                    self:RegisterHealAssist(targetGUID, 0, 15, spellId);
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) and ( spellId == 62519 ) and ( stackAmount == 1 ) then
                self:OnPhaseTwo();
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    CheckElders = function(self)
        self.data.numElders = 0;
        wipe(self.data.elderChecklist);

        -- Scan for each elder buff.
        local uid = Root.Unit.GetUID(self.data.guid);
        if ( uid ) then
            local elder, buff, found;
            for elder, buff in pairs(BUFF_LIST) do
                found = Root.Unit.SearchEffect(uid, "BUFF", buff);
                if ( found ) then
                    self.data.numElders = self.data.numElders + 1;
                    self.data.elderChecklist[elder] = true;
                end
            end
        end

        self:EvaluateDifficulty();
    end,

    ValidateElders = function(self)
        self:CheckElders();
        if ( self.data.numElders > 0 ) then
            self:AlertMe(self:Localize("HardModeTrigger"));
        end
        Root.Music.Play(MUSIC_USED[self.data.numElders]);

        if ( self.data.elderChecklist["STONEBARK"] ) then
            self:ScheduleTremor(30 - 5);
        end
    end,

    EvaluateDifficulty = function(self) 
        if ( self.data.numElders == 0 ) then
            self:SetDifficultyMeter(0.25, 0.30, 0.30, 0.40, 0.25); -- P/B/A/C/S
    elseif ( self.data.numElders == 1 ) then
            self:SetDifficultyMeter(0.40, 0.50, 0.45, 0.40, 0.30); -- P/B/A/C/S
    elseif ( self.data.numElders == 2 ) then
            self:SetDifficultyMeter(0.60, 0.75, 0.65, 0.40, 0.35); -- P/B/A/C/S
    elseif ( self.data.numElders == 3 ) then
            self:SetDifficultyMeter(0.90, 1.00, 0.90, 0.40, 0.40); -- P/B/A/C/S
        end
    end,

    ScheduleNextWave = function(self, timer)
        local id = self.data.waveCount + 1;
        self.data.waveCount = id;
        self.EventWatcher:GetDriver():AddEvent("Wave", timer, "AUTO", self:FormatLoc("Wave", id, 6), "ALERT");
    end,

    ScheduleSunbeam = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Sunbeam", timer, "AUTO", self:Localize("Sunbeam"), "NORMAL");
    end,

    ScheduleTremor = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Tremor", timer, "AUTO", self:Localize("Tremor"), self:IfRole("CASTER", "WARNING_NOREMINDER", "NORMAL"));
    end,

    SearchSunbeamTarget = function(self, try)
        local guid, name, uid = self:GetTargetInfo();
        if ( guid ) then
            if ( self:GetSetting("sunbeamSymbol") ) then
                self:PlaceSymbol(guid, 6, 5.00);
            end
            self:RegisterHealAssist(guid, 0, 3.5, nil);
      elseif ( try < 30 ) then
            self.EventWatcher:GetDriver():AddEvent("SearchSunbeamTarget", 0.05, "", "", "HIDDEN", self.SearchSunbeamTarget, self, try+1);
        end
    end,

    AlertRoot = function(self)
        self:AnnounceUnitList(self.data.rootList, true, self:Localize("RootWarning"), 10.00);
    end,

    IsRelevantTarget = function(self, guid)
        -- During the Freya encounter, every mob is a relevant target excepted Freya throughout the whole phase 1.
        if ( self.running ) then
            if ( guid == self.data.guid ) and ( self.data.phase == 1 ) then
                return false, false;
            end
        end
        return Shared.IsRelevantTarget(self, guid);
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnPhaseTwo = function(self)
        if ( self.data.phase == 2 ) then return; end
        self:ChangePhase(2, true);

        self:RemoveAddsWidgets();
    end,

    OnWaveSpawn = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Wave");
        self.StatusFrame:SetStatus("TEXT", format("%d / %d", self.data.waveCount, 6), true);
        if ( self.data.waveCount < 6 ) then
            self:ScheduleNextWave(60); -- 60.35 in fact
        end
    end,

    OnSunbeam = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Sunbeam");
        self:ScheduleSunbeam(15);
        self.EventWatcher:GetDriver():AddEvent("SearchSunbeamTarget", 0.25, "", "", "HIDDEN", self.SearchSunbeamTarget, self, 1);
    end,

    OnNatureFury = function(self, guid, name)
        if ( guid == UnitGUID("player") ) then
            self:AlertMe(self:Localize("NatureFurySelf"), 0.500, 10.000);
        end
        if ( self:GetSetting("warnNatureFury") ) then
            self:AnnounceToRaid(self:FormatLoc("NatureFuryWarning", name));
            self:PlaceSymbol(guid, 7, 11.00);
        end
        self:RegisterHealAssist(guid, 0, 10, {62589, 63571});
    end,

    OnGrip = function(self)
        self:AlertMe(self:Localize("GripAlert"));
    end,

    OnTreeSpawn = function(self)
        if ( self:HasRole("DPS") ) then
            self:AlertMe(self:Localize("TreeAlert"));
        end
    end,

    OnWaveTypeKnown = function(self, waveType)
        if ( waveType == 1 ) then -- The trio
            self:RespawnAdd(ELEMENTAL_ID);
            self:RespawnAdd(SNAPLASHER_ID);
            self:RespawnAdd(STORMLASHER_ID);

    elseif ( waveType == 2 ) then -- Swarm
            -- Nothing speshul to do. :)

    elseif ( waveType == 3 ) then -- The conservator
            self:RespawnAdd(CONSERVATOR_ID);
        end
    end,

    OnRoot = function(self)
        if ( not self:EvaluateCooldown("root", 10) ) then return; end

        wipe(self.data.rootList);

        if ( self:GetSetting("warnRoot") ) then
            self.EventWatcher:GetDriver():AddEvent("AlertRoot", 0.250, "", "", "HIDDEN", self.AlertRoot, self);
        end
    end,

    OnTremor = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Tremor");

        if ( self.data.phase == 1 ) then
            self:ScheduleTremor(30);
      else
            self:ScheduleTremor(23);
        end

        local bigAlert = false;
        if ( self:HasRole("HEALER") ) then
            bigAlert = self:SuperAlert(2.0, self:Localize("TremorAlert"));
        end
        if ( not bigAlert ) then
            if ( self:HasRole("CASTER") or self:HasRole("HEALER") ) then
                self:AlertMe(self:Localize("TremorAlert"), 0.400, 2.500);
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
    Root.NPCDatabase.Register(32906, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
