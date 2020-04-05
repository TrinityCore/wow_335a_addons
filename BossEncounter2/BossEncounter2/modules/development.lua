local Root = BossEncounter2;
local Shared = Root.Shared;
local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Development Module

-- --------------------------------------------------------------------
-- **                            Description                         **
-- --------------------------------------------------------------------

-- Provides a special module which eases development of new boss modules by
-- registering the various yells, spells and enemies of a boss encounter.

-- --------------------------------------------------------------------
-- **                            Localization                        **
-- --------------------------------------------------------------------

local myLocalization = {
    ["default"] = {
        ["FeedbackHeader"] = "-- Boss module development feedback --",
        ["Duration"] = "Combat duration: %s",
        ["MainTarget"] = "Main target: NPCID=%s, nom=%s",

        ["YellHeader"] = "A/ Registered messages:",
        ["YellEntry"] = "%d. At %s, from [%s]: ''%s''",

        ["EnemyHeader"] = "B/ Encountered enemies:",
        ["EnemyEntry"] = "%d. NPCID=%d, name=%s, maxHealth=%d, maxMana=%d",

        ["AbilityHeader"] = "C/ Enemy abilities detected:",
        ["AbilityEntry"] = "%d. At %s, source <NPCID=%d, name=%s> on target [%s] => SpellID=%d, name=%s",

        ["EffectHeader"] = "D/ Enemy buffs detected:",
        ["EffectGainEntry"] = "%d. <GAIN> At %s, on NPCID=%d, name=%s => SpellID=%d, name=%s",
        ["EffectLossEntry"] = "%d. <LOSS> At %s, on NPCID=%d, name=%s => SpellID=%d, name=%s",

        ["None"] = "None",

        ["SampleNumber"] = "Number of samples: %d",
        ["SampleSaved"] = "Sample saved successfully (number %d).",
        ["SampleDeleted"] = "Sample deleted successfully.",
    },

    ["frFR"] = {
        ["FeedbackHeader"] = "-- Rapport de développement de module de boss --",
        ["Duration"] = "Durée du combat: %s",
        ["MainTarget"] = "Cible principale: NPCID=%s, nom=%s",

        ["YellHeader"] = "A/ Messages enregistrés:",
        ["YellEntry"] = "%d. A %s, de [%s]: ''%s''",

        ["EnemyHeader"] = "B/ Ennemis rencontrés:",
        ["EnemyEntry"] = "%d. NPCID=%d, nom=%s, vieMAX=%d, manaMAX=%d",

        ["AbilityHeader"] = "C/ Capacités des ennemis détectées:",
        ["AbilityEntry"] = "%d. A %s, source <NPCID=%d, nom=%s> sur la cible [%s] => SpellID=%d, nom=%s",

        ["EffectHeader"] = "D/ Buffs détectés sur les ennemis:",
        ["EffectGainEntry"] = "%d. <GAIN> A %s, sur NPCID=%d, nom=%s => SpellID=%d, nom=%s",
        ["EffectLossEntry"] = "%d. <PERTE> A %s, sur NPCID=%d, nom=%s => SpellID=%d, nom=%s",

        ["None"] = "Aucun(e)",

        ["SampleNumber"] = "Nombre d'échantillons: %d",
        ["SampleSaved"] = "Echantillon sauvegardé avec succès (N° %d).",
        ["SampleDeleted"] = "Echantillon supprimé avec succès.",
    },
};

-- --------------------------------------------------------------------
-- **                     Pre-definition stuff                       **
-- --------------------------------------------------------------------

local THIS_MODULE = "Development";

local UNIT_LIST_CHECK_INTERVAL = 0.500;
local PRINT_TO_RAID_CHAT = false;

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

    OnTrigger = function(self, uid, extraTable)
        if ( self.running ) then return; end

        -- Overide some config to ease the development.

        extraTable = extraTable or { };
        extraTable.title = {["default"] = "Development"};
        extraTable.timeLimit = nil;
        extraTable.timeOut = 86400; -- 1 day is enough I guess.
        extraTable.ignoreCombatDelay = true;
        extraTable.ignoreLeaveCombat = true;
        extraTable.ignoreWipe = true;
        extraTable.ignoreResults = true;

        Shared.OnTrigger(self, uid, extraTable);

        if ( not self.data ) then return; end
        local data = self.data;

        -- Prepare development tools.

        data.development = {
            checkUnitList = 0,

            yell = {

            },
            enemy = {
                lookup = { },
            },
            ability = {
                lookup = { },
            },
            effect = {
                lookup = { },
            },
        };
    end,

    OnFinish = function(self)
        if ( not self.running ) then return; end

        -- Finalize the development table by copying some of the data table fields & print all infos got.

        local dev = self.data.development;

        dev.globalTimer = self.data.globalTimer;
        dev.guid = self.data.guid or "???";
        dev.name = self.data.name or "???";

        self:DevPrintInfo(dev);

        -- Record the report in the database for a future parsing.

        self:SaveNewSample(dev);

        -- Remove the development tools.

        Shared.OnFinish(self);
    end,

    OnEngaged = function(self)
        if ( not self.running ) or ( self.status ~= "STANDBY" ) then return; end

        Shared.OnEngaged(self, nil, true, self.data.music);
    end,

    OnCleared = Shared.OnCleared,

    OnFailed = Shared.OnFailed,

    OnUpdate = function(self, elapsed)
        if ( not self.running ) then return; end

        -- Development stuff

        local dev = self.data.development;
        dev.checkUnitList = max(0, dev.checkUnitList - elapsed);
        if ( dev.checkUnitList == 0 ) and ( self.status == "ENGAGED" ) then
            dev.checkUnitList = UNIT_LIST_CHECK_INTERVAL;

            -- Browse the unit list.
            local i, guid, name, id, npcId;
            for i=1, Root.Unit.GetNumUID() do
                guid, name = Root.Unit.GetUID(i);
                id = Root.Unit.GetUID(guid);
                if ( guid and id and name ) and ( name ~= UNKNOWN ) then
                    if ( Root.Unit.GetTypeFromGUID(guid) == "npc" ) then
                        if ( not UnitIsFriend("player", id) ) and ( UnitAffectingCombat(id) ) then
                            -- Ok, we've got a hostile, NPC as target. Register it.

                            npcId = Root.Unit.GetMobID(guid);

                            self:DevRegisterEnemy(npcId, name, UnitHealthMax(id), UnitManaMax(id));
                        end
                    end
                end
            end
        end

        Shared.OnUpdate(self, elapsed);
    end,

    OnCombatEvent = {
        ["DEATH"] = function(self, guid, name, flags, subType)
            if ( self.running ) then
                -- self:DevRegisterAbility(0, name, "N/A", 0, "Mort");
            end

            Shared.OnCombatEvent["DEATH"](self, guid, name, flags, subType);
        end,

        ["DAMAGE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overdamage, school, special, resisted, blocked, absorbed)
            if ( self.running ) then
                local npcId = Root.Unit.GetMobID(actorGUID);
                if ( self:IsEnemyRegistered(npcId) ) then
                    -- self:DevRegisterAbility(actorGUID, actorName, targetName, spellId, spellName);
                end
            end

            Shared.OnCombatEvent["DAMAGE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overdamage, school, special, resisted, blocked, absorbed);
        end,

        ["MISS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, missType, amountMissed, school)
            if ( self.running ) then
                local npcId = Root.Unit.GetMobID(actorGUID);
                if ( self:IsEnemyRegistered(npcId) ) then
                    -- self:DevRegisterAbility(actorGUID, actorName, targetName, spellId, spellName);
                end
            end
        end,

        ["HEAL"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, isPeriodic, amount, overheal, school, special)
            if ( self.running ) then
                local npcId = Root.Unit.GetMobID(actorGUID);
                if ( self:IsEnemyRegistered(npcId) ) then
                    -- self:DevRegisterAbility(actorGUID, actorName, targetName, spellId, spellName);
                end
            end
        end,

        ["CAST_START"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                local npcId = Root.Unit.GetMobID(actorGUID);
                if ( self:IsEnemyRegistered(npcId) ) then
                    self:DevRegisterAbility(actorGUID, actorName, targetName, spellId, spellName);
                end
            end
        end,

        ["CAST_SUCCESS"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, spellId, spellName, school)
            if ( self.running ) then
                local npcId = Root.Unit.GetMobID(actorGUID);
                if ( self:IsEnemyRegistered(npcId) ) then
                    self:DevRegisterAbility(actorGUID, actorName, targetName, spellId, spellName);
                end
            end
        end,

        ["EFFECT_GAIN"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                local npcId = Root.Unit.GetMobID(targetGUID);
                if ( self:IsEnemyRegistered(npcId) ) and ( effectType == "BUFF" ) then
                    self:DevRegisterEffect(targetGUID, targetName, spellId, spellName, "Gain");
                end
            end
        end,

        ["EFFECT_FADE"] = function(self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount)
            if ( self.running ) then
                local npcId = Root.Unit.GetMobID(targetGUID);
                if ( self:IsEnemyRegistered(npcId) ) and ( effectType == "BUFF" ) then
                    self:DevRegisterEffect(targetGUID, targetName, spellId, spellName, "Loss");
                end
            end

            Shared.OnCombatEvent["EFFECT_FADE"](self, actorGUID, actorName, actorFlags, targetGUID, targetName, targetFlags, class, spellId, spellName, school, effectType, stackAmount);
        end,
    },

    OnMobYell = function(self, message, source, yellType)
        if ( not self.running ) then return; end

        -- Development stuff

        self:DevRegisterYell(source, message);

        Shared.OnMobYell(self, message, source, yellType);
    end,

    -- --------------------------------------------------------------------
    -- **                             Methods                            **
    -- --------------------------------------------------------------------

    DevRegisterYell = function(self, speaker, message)
        local dev = self.data.development;

        dev.yell[#dev.yell+1] = {
            timestamp = self.data.globalTimer,
            speaker = speaker,
            message = message,
        };
    end,

    DevRegisterEnemy = function(self, npcId, name, maxHealth, maxMana)
        local dev = self.data.development;
        if ( not npcId ) then return; end
        if ( self:IsEnemyRegistered(npcId) ) then return; end

        dev.enemy.lookup[npcId] = true;
        dev.enemy[#dev.enemy+1] = {
            timestamp = self.data.globalTimer,
            npcId = npcId,
            name = name,
            maxHealth = maxHealth,
            maxMana = maxMana,
        };
    end,

    IsEnemyRegistered = function(self, npcId)
        if ( not npcId ) then return false; end
        local dev = self.data.development;
        if ( dev.enemy.lookup[npcId] ) then return true; end
        return false;
    end,

    DevRegisterAbility = function(self, guid, name, target, spellId, spellName)
        if ( not spellId ) or ( not guid ) then return; end

        local dev = self.data.development;
        local npcId = Root.Unit.GetMobID(guid);
        if ( not npcId ) then return; end
        -- if ( self:IsAbilityRegistered(npcId, spellId) ) then return; end

        if ( dev.ability.lookup[npcId] ) then
            dev.ability.lookup[npcId][spellId] = true;
      else
            dev.ability.lookup[npcId] = { [spellId] = true };
        end

        dev.ability[#dev.ability+1] = {
            timestamp = self.data.globalTimer,
            npcId = npcId,
            name = name or UNKNOWN,
            target = target or UNKNOWN,
            spellId = spellId,
            spellName = spellName or UNKNOWN,
        };
    end,

    IsAbilityRegistered = function(self, npcId, spellId)
        if ( not npcId ) or ( not spellId ) then return false; end
        local dev = self.data.development;
        if ( dev.ability.lookup[npcId] ) then
            if ( dev.ability.lookup[npcId][spellId] ) then
                return true;
            end
        end
        return false;
    end,

    DevRegisterEffect = function(self, guid, name, spellId, spellName, action)
        if ( not spellId ) or ( not guid ) then return; end

        local dev = self.data.development;
        local npcId = Root.Unit.GetMobID(guid);
        if ( not npcId ) then return; end
        -- if ( self:IsEffectRegistered(npcId, spellId) ) then return; end

        if ( dev.effect.lookup[npcId] ) then
            dev.effect.lookup[npcId][spellId] = true;
      else
            dev.effect.lookup[npcId] = { [spellId] = true };
        end

        dev.effect[#dev.effect+1] = {
            timestamp = self.data.globalTimer,
            npcId = npcId,
            name = name or UNKNOWN,
            spellId = spellId,
            spellName = spellName or UNKNOWN,
            action = action,
        };
    end,

    IsEffectRegistered = function(self, npcId, spellId)
        if ( not npcId ) or ( not spellId ) then return false; end
        local dev = self.data.development;
        if ( dev.effect.lookup[npcId] ) then
            if ( dev.effect.lookup[npcId][spellId] ) then
                return true;
            end
        end
        return false;
    end,

    DevPrintInfo = function(self, devTable)
        local dev = devTable;
        local p = self.DevPrintLine;
        local l = self.Localize;
        local fl = self.FormatLoc;
        local t = self.GetTimestamp;
        local i;

        p(self, l(self, "FeedbackHeader"));
        p(self, fl(self, "Duration", t(self, dev.globalTimer)));
        p(self, fl(self, "MainTarget", tostring(Root.Unit.GetMobID(dev.guid) or "?"), dev.name or UNKNOWN));

        p(self, l(self, "YellHeader"));
        if ( #dev.yell == 0 ) then
            p(self, l(self, "None"));
      else
            for i=1, #dev.yell do
                p(self, fl(self, "YellEntry", i, t(self, dev.yell[i].timestamp), dev.yell[i].speaker, dev.yell[i].message));
            end
        end

        p(self, l(self, "EnemyHeader"));
        if ( #dev.enemy == 0 ) then
            p(self, l(self, "None"));
      else
            for i=1, #dev.enemy do
                p(self, fl(self, "EnemyEntry", i, dev.enemy[i].npcId, dev.enemy[i].name, dev.enemy[i].maxHealth, dev.enemy[i].maxMana));
            end
        end

        p(self, l(self, "AbilityHeader"));
        if ( #dev.ability == 0 ) then
            p(self, l(self, "None"));
      else
            for i=1, #dev.ability do
                p(self, fl(self, "AbilityEntry", i, t(self, dev.ability[i].timestamp), dev.ability[i].npcId, dev.ability[i].name, dev.ability[i].target, dev.ability[i].spellId, dev.ability[i].spellName));
            end
        end

        p(self, l(self, "EffectHeader"));
        if ( #dev.effect == 0 ) then
            p(self, l(self, "None"));
      else
            for i=1, #dev.effect do
                p(self, fl(self, "Effect"..dev.effect[i].action.."Entry", i, t(self, dev.effect[i].timestamp), dev.effect[i].npcId, dev.effect[i].name, dev.effect[i].spellId, dev.effect[i].spellName));

            end
        end
    end,

    DevPrintLine = function(self, text)
        if ( GetNumRaidMembers() > 0 and PRINT_TO_RAID_CHAT ) then
            SendChatMessage(text, "RAID");
      else
            Root.Print(text);
        end
    end,

    GetTimestamp = function(self, time)
        return Root.FormatCountdownString("%H:%M'%S''%C", time);
    end,

    -- --------------------------------------------------------------------
    -- **                             Database                           **
    -- --------------------------------------------------------------------

    SaveNewSample = function(self, devTable)
        local num = self:GetNumSamples() + 1;
        Root.Save.Set("dev", "num", num);
        Root.Save.Set("dev", num, devTable);
        Root.Print(self:FormatLoc("SampleSaved", num));
    end,

    GetNumSamples = function(self)
        return Root.Save.Get("dev", "num");
    end,

    ReadSample = function(self, id)
        local num = self:GetNumSamples();
        if ( id >= 1 and id <= num ) then
            local devTable = Root.Save.Get("dev", id);
            if type(devTable) == "table" then
                self:DevPrintInfo(devTable);
                return;
            end
        end
        self:ListSamples();
    end,

    DeleteSample = function(self, id)
        local num = self:GetNumSamples();
        if ( id >= 1 and id <= num ) then
            num = num - 1;
            local i, t;
            for i=id, num do
                t = Root.Save.Get("dev", i+1);
                Root.Save.Set("dev", i, t);
            end
            Root.Save.Set("dev", num+1, nil);
            Root.Save.Set("dev", "num", num);
            Root.Print(self:Localize("SampleDeleted"));
            return; 
        end
        self:ListSamples();
    end,

    ListSamples = function(self)
        local num = self:GetNumSamples();
        Root.Print(self:FormatLoc("SampleNumber", num));
        local i, t;
        for i=1, num do
            t = Root.Save.Get("dev", i);
            Root.Print(string.format("%d. %s", i, t.name));
        end
    end,
};

-- --------------------------------------------------------------------
-- **                       Post-definition stuff                    **
-- --------------------------------------------------------------------

do
    Root[THIS_MODULE].localization = myLocalization;
    Root.InstallBossModule(THIS_MODULE, Root[THIS_MODULE], true);
end