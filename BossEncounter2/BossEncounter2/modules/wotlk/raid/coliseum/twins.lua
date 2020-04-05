local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Twin Val'kyr Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Handles Twin Val'kyr fight.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        -- 1. Yells

        -- 2. Events
        ["Action"] = "Shield or Vortex",
        ["LightVortex"] = "|cffffff50Light Vortex|r",
        ["DarkVortex"] = "|cff4040b0Dark Vortex|r",

        -- 3. Misc
        ["Title"] = "Twin Val'kyr",
        ["VortexAlert"] = "%s incoming !",
    },
    ["frFR"] = {
        -- 1. Yells

        -- 2. Events
        ["Action"] = "Bouclier ou vortex",
        ["LightVortex"] = "|cffffff50Vortex lumineux|r",
        ["DarkVortex"] = "|cff6060d0Vortex sombre|r",

        -- 3. Misc
        ["Title"] = "Jumelles Val'kyr",
        ["VortexAlert"] = "%s incanté !",
    },
};

local LIGHT_BUFF = GetSpellInfo(67223);
local DARK_BUFF = GetSpellInfo(67176);

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Twins";

local EDYIS_ID = 34496;
local FJOLA_ID = 34497;

local BERSERK_TIMER = 480;

local shield = {
    -- Light shield
    [65858] = 175000,
    [67259] = 700000,
    [67260] = 300000,
    [67261] = 1200000,

    -- Dark shield
    [65874] = 175000,
    [67256] = 700000,
    [67257] = 300000,
    [67258] = 1200000,
};

local vortex = {
    [66046] = "LIGHT",
    [67206] = "LIGHT",
    [67207] = "LIGHT",
    [67208] = "LIGHT",

    [66058] = "DARK",
    [67182] = "DARK",
    [67183] = "DARK",
    [67184] = "DARK",
};

local ShieldAlgorithm = {
    label = {
        ["default"] = "Shield",
        ["frFR"] = "Bouclier",
    },
    layout = 3,
    allowDead = false,

    GetValue = function(self, uid)
        local guid = UnitGUID(uid);
        return self:GetValueMasked(guid);
    end,

    GetValueMasked = function(self, guid)
        return Root[THIS_MODULE]:GetShieldAmount(guid);
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

    OnTrigger = function(self, uid)
        if not self:TriggerMe() then return; end

        local data = self.data;

        data.shieldName = "-NOTHING-";
        data.shieldGUID = "";
        data.shieldID = -1;
        data.shieldValue = 0;
        data.shieldValueMax = 0;

        data.title = self:Localize("Title");
        data.baseID = THIS_MODULE;

        self:GrabStaticWidgets();

        self:SetBossUnit(uid, 60, true); -- Set arbitrarily one of the twins as the main boss.
        -- This is necessary for the near victory handler.

        local difficulty = Root.GetInstanceFormat();
        if ( difficulty == "HEROIC" ) then
            self:SetDifficultyMeter(0.60, 0.60, 0.80, 0.60, 0.80); -- P/B/A/C/S
      else
            self:SetDifficultyMeter(0.40, 0.35, 0.50, 0.40, 0.65); -- P/B/A/C/S
        end

        self:PrepareBasicWidgets(BERSERK_TIMER, true);
        self.BossBar:Remove(true); -- Not needed.

        self.AddWindow:GetDriver():AssignAlgorithm(ShieldAlgorithm);

        self:ResetAdds();
        self:RegisterAdd(EDYIS_ID, false);
        self:RegisterAdd(FJOLA_ID, false);

        self:SetStrictRelevance(true);
        self:SetIgnoreHealing(true);
    end,

    OnFinish = Shared.OnFinish,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        self.status = "ENGAGED";
        self.data.timeOutTimer = 0;

        self:SetScoreBenchmarks(270, 540);
        self:SetNearVictoryThreshold(0.10, 540-60, 0.70);

        self.StatusFrame:SetStatus("TEXT", self:Localize("Engaged"), true);

        Root.Music.Play("TIER9_TANKNSPANK2");

        self.StatusFrame:GetDriver():Resume();
        self:ScheduleBerserk(BERSERK_TIMER, true);

        if ( self.data.bossAlreadyFighting ) then return; end

        self:ScheduleAction(45);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = Shared.OnUpdate,

    OnCombatEvent = {
        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overdamage, school, special, resisted, blocked, absorbed)
            if ( self.running ) then
                if ( self.data.shieldGUID ~= "" ) then
                    local realAmount = (amount or 0) + (absorbed or 0);

                    -- Shield active. Print debug info
                    local id = Root.Unit.GetMobID(targetGUID) or -1;
                    -- print("Damage", targetName, targetGUID, id, "=", realAmount);

                    if ( id == self.data.shieldID ) then
                        -- print("Shield damaged ("..realAmount..")");
                        self:OnShieldDamaged(realAmount);
                    end
                end
            end

            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overdamage, school, special, resisted, blocked, absorbed);
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) and ( vortex[spellId] ) then
                self:OnVortex(vortex[spellId]);
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( shield[spellId] ) then
                    self:OnShieldGained(targetGUID, targetName, shield[spellId]);
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                if ( shield[spellId] ) then
                    self:OnShieldRemoved();
                end
            end
            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    GetShieldAmount = function(self, guid)
        local data = self.data;
        if ( not self.running ) or ( not data ) then return 0, 0; end

        if ( guid == self.data.shieldGUID ) then
            return self.data.shieldValue, self.data.shieldValueMax;
      else
            return 0, 0;
        end
    end,

    GetEssence = function(self, uid)
        if ( Root.Unit.SearchEffect(uid, "DEBUFF", LIGHT_BUFF) ) then
            return "LIGHT";
    elseif ( Root.Unit.SearchEffect(uid, "DEBUFF", DARK_BUFF) ) then
            return "DARK";
      else
            return "NONE";
        end
    end,

    ScheduleAction = function(self, timer)
        self.EventWatcher:GetDriver():AddEvent("Action", timer, "AUTO", self:Localize("Action"), "WARNING");
    end,

    LocVortex = function(self, matchingEssence)
        if ( matchingEssence == "LIGHT" ) then
            return self:Localize("LightVortex");
      else
            return self:Localize("DarkVortex");
        end
    end,

    -- --------------------------------------------------------------------
    -- **                        Special handlers                        **
    -- --------------------------------------------------------------------

    OnShieldGained = function(self, guid, name, amount)
        self.data.shieldName = name;
        self.data.shieldGUID = guid;
        self.data.shieldID = Root.Unit.GetMobID(guid) or -1;
        self.data.shieldValue = amount;
        self.data.shieldValueMax = amount;
        self:OnActionPerformed();

        -- message(string.format("Shield on %s [%s, %d] for %d", name, guid, self.data.shieldID, amount));
    end,

    OnShieldRemoved = function(self)
        self.data.shieldName = "-NOTHING-";
        self.data.shieldGUID = "";
        self.data.shieldID = -1;
        self.data.shieldValue = 0;
        self.data.shieldValueMax = 0;
    end,

    OnShieldDamaged = function(self, amount)
        if ( not self.data.shieldValue ) then
            return;
        end
        self.data.shieldValue = max(0, self.data.shieldValue - amount);
    end,

    OnVortex = function(self, matchingEssence)
        local vName = self:LocVortex(matchingEssence);
        self:OnActionPerformed();
        self.EventWatcher:GetDriver():AddEvent("Vortex", 8, "AUTO", vName, "ALERT");
        if ( matchingEssence ~= self:GetEssence("player") ) then
            self:AlertMe(self:FormatLoc("VortexAlert", vName), 0.500, 4.500);
        end
    end,

    OnActionPerformed = function(self)
        self.EventWatcher:GetDriver():TriggerEvent("Action");
        self:ScheduleAction(45);
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.NPCDatabase.Register(EDYIS_ID, THIS_MODULE, false);
    Root.NPCDatabase.Register(FJOLA_ID, THIS_MODULE, false);

    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], false);
end
