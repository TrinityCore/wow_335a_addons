local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Faction Champions Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Faction Champions fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events

        -- 3. Misc
        ["Title"] = "Champions",
        ["QuickActionExplain"] = "When |cffff2020right-clicking|r on a add row, you will attempt to cast the following ability on this add :\n|cff00ff00%s|r (%s)\n\nYou must know this ability for this to work.",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events

        -- 3. Misc
        ["Title"] = "Champions",
        ["QuickActionExplain"] = "En |cffff2020cliquant avec le bouton droit|r sur une ligne de la fenêtre d'adds, vous tenterez d'utiliser la technique suivante sur cet add :\n|cff00ff00%s|r (%s)\n\nVous devez connaître la technique pour que cette fonction marche.",
    },
};

-- --------------------------------------------------------------------
-- **                             Settings                           **
-- --------------------------------------------------------------------

local mySettings = {
    [1] = {
        id = "enableQuickActions",
        type = "BOOLEAN",
        defaultValue = true,
        label = {
            ["default"] = "Enable quick actions",
            ["frFR"] = "Activer les actions rapides",
        },
        explain = nil, -- Will be dynamically set according to the local player's class.
    },
    version = 1,
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Champions";

local CrowdControlAlgorithm = {
    label = {
        ["default"] = "Crowd.C",
        ["frFR"] = "C.Foule",
    },
    layout = 3,
    allowDead = false,

    GetValue = function(self, uid)
        local guid = UnitGUID(uid);
        return self:GetValueMasked(guid);
    end,

    GetValueMasked = function(self, guid)
        local current, max = Root[THIS_MODULE]:GetCrowdControl(guid);
        return current, max;
    end,
};

local crowdControlSpells = {
    -- List here all player crowd controls that can be used in this fight.

    -- Stun
    5211, 22570, 408, 853, 46968, 44572, 12798, -- Bash, Maim, Kidney Shot, Hammer of J., Shockwave, Deep Freeze, Imp. Revenge

    -- Banish
    710, 33786, -- Banish, Cyclone

    -- Polymorph
    118, 28272, 28271, 59634, 61305, 61721, -- Polymorph (6 versions)
    51514, -- Hex

    -- Fear
    5782, 5484, 8122, 5246, -- Fear, Howl of Terror, Psychic Scream, Intimidating Shout
    10326, 1513, -- Turn Evil, Scare Beast

    -- Incapacitate
    20066, 6770, 1776, -- Repentance, Sap, Gouge

    -- Freeze
    1499, 49203, -- Freezing Trap, Hungering Cold

    -- Sleep
    2637, 24132, -- Hibernate, Wyvern Sting

    -- Roots
    339, 122, 33395, -- Entangling Roots, Frost Nova, Freeze

    -- Disorient
    19503, 31661, 2094, -- Scatter Shot, Dragon's Breath, Blind

    -- Miscellaneous
    605, -- Mind Control [should not work]
    9484, -- Shackle Undead
    6358, -- Seduction
};

local npc = {
    -- The faction key is the faction of the LOCAL PLAYER.
    -- That means the content of the table is the ENEMY NPCs this faction will have to face.

    -- INFO: 06 NPC fought in 10-man normal (heroic too ?).
    --       10 NPC fought in 25-man normal (heroic too ?).

    ["ALLIANCE"] = {
        { id = 34458, class = "DEATHKNIGHT", role = "DPS"  }, -- Gorgrim Shadowcleave
        { id = 34451, class = "DRUID"      , role = "DPS"  }, -- Birana Stormhoof
        { id = 34459, class = "DRUID"      , role = "HEAL" }, -- Erin misthoof
        { id = 34448, class = "HUNTER"     , role = "DPS"  }, -- Ruh'kah
        { id = 34449, class = "MAGE"       , role = "DPS"  }, -- Ginselle Blightslinger
        { id = 34445, class = "PALADIN"    , role = "HEAL" }, -- Liandra Suncaller
        { id = 34456, class = "PALADIN"    , role = "DPS"  }, -- Malithas Brightblade
        { id = 34447, class = "PRIEST"     , role = "HEAL" }, -- Caiphus the Stern
        { id = 34441, class = "PRIEST"     , role = "DPS"  }, -- Vivienne Blackwhisper
        { id = 34454, class = "ROGUE"      , role = "DPS"  }, -- Maz'dinah
        { id = 34444, class = "SHAMAN"     , role = "HEAL" }, -- Thrakgar
        { id = 34455, class = "SHAMAN"     , role = "DPS"  }, -- Broln Stouthorn
        { id = 34450, class = "WARLOCK"    , role = "DPS"  }, -- Harkzog
        { id = 34453, class = "WARRIOR"    , role = "DPS"  }, -- Narrhok Steelbreaker
        -- { id = 31144, class = "WARRIOR"    , role = "DPS"  }, -- Test
    },
    ["HORDE"] = {
        { id = 34461, class = "DEATHKNIGHT", role = "DPS"  }, -- Tyrius Duskblade
        { id = 34460, class = "DRUID"      , role = "DPS"  }, -- Kavina Grovesong
        { id = 34469, class = "DRUID"      , role = "HEAL" }, -- Melador Valestrider
        { id = 34467, class = "HUNTER"     , role = "DPS"  }, -- Alyssia Moonstalker
        { id = 34468, class = "MAGE"       , role = "DPS"  }, -- Noozle Whizzlestick
        { id = 34471, class = "PALADIN"    , role = "DPS"  }, -- Baelnor Lightbearer
        { id = 34465, class = "PALADIN"    , role = "HEAL" }, -- Velanaa
        { id = 34466, class = "PRIEST"     , role = "HEAL" }, -- Anthar Forgemender
        { id = 34473, class = "PRIEST"     , role = "DPS"  }, -- Brienna Nightfell
        { id = 34472, class = "ROGUE"      , role = "DPS"  }, -- Irieth Shadowstep
        { id = 34470, class = "SHAMAN"     , role = "HEAL" }, -- Saamul
        { id = 34463, class = "SHAMAN"     , role = "DPS"  }, -- Shaabad
        { id = 34474, class = "WARLOCK"    , role = "DPS"  }, -- Serissa Grimdabbler
        { id = 34475, class = "WARRIOR"    , role = "DPS"  }, -- Shocuul
    },
};

-- The following tables will automatically be populated.
local enemyList = { };
local enemyLookup = { };
local crowdControls = { };

local CC_UPDATE_RATE = 1.00;
local CC_MAX_DURATION = 10;

local timeToClear = {
    ["10N"] = 480,
    ["10H"] = 600,
    ["25N"] = 600,
    ["25H"] = 780,
};

local quickActionSpells = {
    -- List here all player crowd controls that can be quickly used by the player by right-clicking on an add row, indexed by class UPPERCASED name.

    ["DEATHKNIGHT"] = 49576, -- Death Grip (not a true CC, but what else can be put =D)
    ["DRUID"] = 33786,       -- Cyclone
    ["HUNTER"] = 24132,      -- Wyvern Sting
    ["MAGE"] = 12824,        -- Polymorph
    ["PALADIN"] = 853,       -- Hammer of J.
    ["PRIEST"] = nil,        -- N/A
    ["ROGUE"] = 2094,        -- Blind
    ["SHAMAN"] = 51514,      -- Hex
    ["WARLOCK"] = 5782,      -- Fear
    ["WARRIOR"] = nil,       -- N/A
};

local QUICK_ACTION_SPELL = nil;

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

    OnEnterWorld = function(self)
        local locName, class = UnitClass("player");
        if ( not quickActionSpells[class] ) then
            -- Remove the options for this boss module if the player's class do not have a quick action spell set in the table above.
            self.settings = nil;
      else
            -- Elsewise translate the quick action spell name and provide the explanation of the quick action feature.
            QUICK_ACTION_SPELL = GetSpellInfo(quickActionSpells[class]);
            if ( QUICK_ACTION_SPELL ) then
                mySettings[1].explain = self:FormatLoc("QuickActionExplain", QUICK_ACTION_SPELL, locName);
            end
        end

        Shared.OnEnterWorld(self);
    end,

    OnSettingChanged = function(self, id)
        if ( id == "enableQuickActions" ) then
            self:UpdateQuickAction();
        end
    end,

    OnTrigger = function(self, uid)
        if not self:TriggerMe() then return; end

        local data = self.data;

        data.ignoreList = { };
        data.nextCCUpdate = 0;
        data.nearVictoryTriggered = false;
        data.ignoreAddsEngage = true;

        data.title = self:Localize("Title");
        data.baseID = THIS_MODULE;

        self:GrabStaticWidgets();

        self:SetDummyBossUnit("worldboss", 60, UnitAffectingCombat("player")); -- No NPC is set as the main boss.

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.70, 0.75, 0.55, 1.00, 0.70); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.40, 0.45, 0.25, 0.70, 0.40); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(nil, false);
        self.BossBar:Remove(true); -- Not needed.

        Root.Music.Play("PREPARATION_GENERAL");

        self.AddWindow:GetDriver():AssignAlgorithm(CrowdControlAlgorithm);
        self:ResetAdds();
        self:UpdateQuickAction();
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(self:GetExpectedTime()/2, self:GetExpectedTime());

        self:UpdateAddsCount(false);

        Root.Music.Play("THEME_MADNESS");

        self.StatusFrame:GetDriver():StartTiming();
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        -- Scan for new mobs.

        local i, guid, name, uid, id;
        for i=1, Root.Unit.GetNumUID() do
            guid, name = Root.Unit.GetUID(i);
            uid = Root.Unit.GetUID(guid);
            id = Root.Unit.GetMobID(guid);
            if ( uid ) and ( enemyLookup[id] ) then
                if ( not self.data.ignoreList[guid] ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitHealth(uid) > 0 ) then
                    self.data.ignoreList[guid] = true;

                    local class, role = self:GetMobInfo(id);
                    self:RegisterAddEX(id, false, "AUTO", class, role);
                end
            end
        end

        -- Determinate if the combat has started.

        if ( self.status == "STANDBY" and UnitAffectingCombat("player") ) then
            self:OnEngaged();
        end

        -- Update CC timers.

        self.data.nextCCUpdate = max(0, self.data.nextCCUpdate - elapsed);
        if ( self.data.nextCCUpdate == 0 ) then
            self:UpdateAllCC();
        end

        Shared.OnUpdate(self, elapsed);
    end,

    OnCombatEvent = {
        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellName ) and ( crowdControls[spellName] ) and ( targetGUID ) then
                    self:OnCrowdControl("GAIN", targetGUID, spellName);
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( spellName ) and ( crowdControls[spellName] ) and ( targetGUID ) then
                    self:OnCrowdControl("LOSE", targetGUID, spellName);
                end
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    OnMobYell = Shared.OnMobYell,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    GetExpectedTime = function(self)
        return timeToClear[self:GetFormatCode()] or 60;
    end,

    CheckStandardClear = function(self)
        -- Overide the clear check function to incorporate the near victory trigger.

        local data = self.data;
        local addRemaining = self:GetNumAddsAlive();

        if ( addRemaining == 0 ) then
            self:OnCleared();
    elseif ( addRemaining <= 2 ) and ( not data.nearVictoryTriggered ) then
            data.nearVictoryTriggered = true;
            Root.Music.Play("VICTORYNEAR");
        end
    end,

    GetMobInfo = function(self, id)
        local data;
        for _, data in ipairs(enemyList) do
            if ( data.id == id ) then
                return data.class, data.role;
            end
        end
        return "UNKNOWN", "UNKNOWN";
    end,

    GetCCTable = function(self, guid)
        if ( not self.data ) then return nil; end
        if ( not self.data.cc ) then
            self.data.cc = { };
        end
        if ( not self.data.cc[guid] ) then
            self.data.cc[guid] = { };
        end
        return self.data.cc[guid];
    end,

    GetCrowdControl = function(self, guid)
        -- Returns when a crowd control will expire on a mob. The longest possible CC duration will be returned.

        local t = self:GetCCTable(guid);
        if ( not t ) then return 0, 0, nil; end

        local start, duration, ccName = nil, nil, nil;
        local name, data, cStart, cDuration;
        for name, data in pairs(t) do
            cStart, cDuration = data.start, data.duration;
            if ( cStart+cDuration ) > ((start or 0) + (duration or 0)) then
                -- This CC is more powerful than the one we have memorized.
                start, duration = cStart, cDuration;
                ccName = name;
            end
        end

        if ( start ) and ( duration ) and ( ccName ) then
            local timeLeft = max(0, start + duration - GetTime());
            -- return max(0, start + duration - GetTime()), duration, ccName;
            return min(timeLeft, CC_MAX_DURATION), CC_MAX_DURATION, ccName;
      else
            return 0, 0, nil;
        end
    end,

    UpdateAllCC = function(self)
        self.data.nextCCUpdate = CC_UPDATE_RATE;

        local ccTable = self.data.cc;
        if ( not ccTable ) then return; end

        local guid, unitCC, name;
        for guid, unitCC in pairs(ccTable) do
            for name in pairs(unitCC) do
                self:TryUpdate(guid, name);
            end
        end
    end,

    TryUpdate = function(self, guid, spellName)
        -- Try updating the duration of one of the CCs on the target. Won't do anything if the unit cannot be accessed.

        local t = self:GetCCTable(guid);
        if ( not t ) then return; end

        local data = t[spellName];
        if ( not data ) then return; end

        local uid = Root.Unit.GetUID(guid);
        if ( not uid ) then return; end

        local found, start, duration = Root.Unit.SearchEffectRaw(uid, "DEBUFF", spellName);
        if ( not found ) then
            self:OnCrowdControl("LOSE", guid, spellName);
            return;
        end
        data.start, data.duration = start, duration;
    end,

    UpdateQuickAction = function(self)
        if self:GetSetting("enableQuickActions") then
            self.AddWindow:GetDriver():SetSecureCommand("/cast [button:2] "..(QUICK_ACTION_SPELL or "?"));
      else
            self.AddWindow:GetDriver():SetSecureCommand(nil);
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnCrowdControl = function(self, action, guid, spellName)
        -- Register this crowd control on the unit.
        -- print(action.."> "..spellName.." on "..guid);

        local t = self:GetCCTable(guid);
        if ( not t ) then return; end

        if ( action == "GAIN" ) then
            t[spellName] = {
                start = GetTime(),
                duration = 8, -- Will be auto-completed.
            };
            self:TryUpdate(guid, spellName);

    elseif ( action == "LOSE" ) then
            t[spellName] = nil;
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root[THIS_MODULE].settings = mySettings;
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);


    -- Browse the table according to the local player's faction.
    enemyList = npc[Root.GetPlayerFaction()];

    -- Register all possible NPCs.
    local data;
    for _, data in ipairs(enemyList) do
        enemyLookup[data.id] = true;
        Root.NPCDatabase.Register(data.id, THIS_MODULE, false);
    end

    -- Get the name of CC spells.
    local id, name;
    for _, id in pairs(crowdControlSpells) do
        name = GetSpellInfo(id);
        if ( name ) then
            crowdControls[name] = true;
        end
    end
end
