local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local countTable = {};

local manaUserThreshold = {
    [1] = 70 * 1.4,
    [60] = 2000 * 1.4,
    [70] = 4000 * 1.4,
    [80] = 7000 * 1.4,
};

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- ================================================================
    -- Count the number of ( visible AND alive ) party and raid members
    -- You are accounted for in this method.
    -- ================================================================

    CountNumValidMembers = function(self, excludeOutOfCombat)
        local count = 0;
        local i, uid;

        wipe(countTable);
        Root.Unit.EnumerateRaid(countTable);

        for i=1, #countTable do
            uid = countTable[i];
            if UnitIsVisible(uid) and not UnitIsDeadOrGhost(uid) then
                if ( not excludeOutOfCombat ) or ( UnitAffectingCombat(uid) ) then
                    count = count + 1;
                end
            end
        end

        return count;
    end,

    -- ====================================================================
    -- Return the max amount of party members that can be used in the
    -- current environment. If you are in a party instance, 5 is
    -- returned. In a raid instance, nil is returned because it can be
    -- either 10, 25 or 40. Elsewise, if you are alone, 1 is returned, if
    -- you're in a party, 5 is returned. If you're in a raid 40 is returned
    -- ====================================================================

    GetMaxMembers = function(self)
        inInstance, instanceType = IsInInstance();
        if ( inInstance and instanceType == "party" ) then
            return 5;
    elseif ( inInstance and instanceType == "raid" ) then
            return nil;
      else
            if GetNumRaidMembers() > 0 then
                return 40;
        elseif GetNumPartyMembers() > 0 then
                return 5;
          else
                return 1;
            end
        end
        return nil;
    end,

    -- ===============================================================================
    -- DEPRECATED - Set the values which are considered to be an average performance
    -- for the boss in terms of time needed to kill the boss and max size of the raid.
    -- The new score system no longer needs such a weird function and an alternative
    -- and simpler to use version should be used.
    -- See SetScoreBenchmarks method.
    -- ===============================================================================

    CalculateEfficientStats = function(self, bossHealth, mode, parameter, maxPlayers)
        bossHealth = bossHealth or self.data.bossMaxHealth;
        if ( not bossHealth ) or ( not mode ) or ( not parameter ) then return; end

        local numPlayers = self:CountNumValidMembers() or 1;
        self.data.startingPlayers = numPlayers;
        self.data.maxPlayers = maxPlayers;

        local efficientTime = 0;
        if ( mode == "TIME" ) then
            efficientTime = parameter;

      elseif ( mode == "DPS" ) then
            efficientTime = bossHealth / self.data.efficientDPS;
        end
        self.data.poorTime  = efficientTime * 3/2;
        self.data.greatTime = efficientTime * 2/3;

        self:WarnDeprecated("CalculateEfficientStats");
    end,

    -- ===============================================================================
    -- Set the values which are considered to be an average performance
    -- for the boss in terms of time needed to kill the boss and max size of the raid.
    -- greatTime specifies how fast a great performance should be (100 pts).
    -- poorTime specifies how slow a crappy performance should be (0 pt).
    -- playerSlots specify how many players can participate to the boss fight at MAX.
    -- playerSlots parameter is optionnal if the module is flagged as a WotLK raid.
    -- ===============================================================================

    SetScoreBenchmarks = function(self, greatTime, poorTime, playerSlots)
        local numPlayers = self:CountNumValidMembers() or 1;

        self.data.startingPlayers = numPlayers;

        if ( not playerSlots ) then
            if ( self.isWrathRaid ) then
                self.data.maxPlayers = self:GetMaxLKRaidPlayers();
          else
                self.data.maxPlayers = numPlayers;
            end
      else
            self.data.maxPlayers = playerSlots;
        end

        self.data.poorTime = poorTime;
        self.data.greatTime = greatTime;
    end,

    -- ===============================================================================
    -- Reset variables that are essential for score calculation but not the encounter:
    -- currently the total damage done on the boss
    -- ===============================================================================

    ResetScoreCounters = function(self)
        self:WarnDeprecated("ResetScoreCounters");
    end,

    -- ======================================================
    -- Get the max number of people in a WotLK raid instance.
    -- ======================================================

    GetMaxLKRaidPlayers = function(self)
        local mode, size = Root.GetInstanceFormat();
        return size;
    end,

    -- ===============================================================================
    -- Get the max and current mana of the raid. Only those who have a big enough mana
    -- pool are counted. For instance, retribution paladins and feral druids will be
    -- discarded, as well as most hunters/enhance shamans.
    -- ===============================================================================

    GetRaidMana = function(self)
        local currentMana, maxMana = 0, 0;
        local i, uid;
        local curValue, maxValue, manaThreshold;

        wipe(countTable);
        Root.Unit.EnumerateRaid(countTable);

        for i=1, #countTable do
            uid = countTable[i];
            if UnitIsVisible(uid) and not UnitIsDeadOrGhost(uid) then
                curValue = UnitPower(uid, SPELL_POWER_MANA);
                maxValue = UnitPowerMax(uid, SPELL_POWER_MANA);
                if ( maxValue > 0 ) then
                    manaThreshold = Root.LinearInterpolation(manaUserThreshold, UnitLevel(uid));
                    if ( maxValue > manaThreshold ) then
                        currentMana = currentMana + curValue;
                        maxMana = maxMana + maxValue;
                    end
                end
            end
        end

        return max(1, currentMana), max(1, maxMana);
    end,

    -- ================================================================================================
    -- Determinate if damage done to the given unit is relevant for the DPS parser.
    -- It is now consolidated in a single string return.
    -- Return: result
    -- Possible results:
    -- IGNORE - The damage will not be recorded at all.
    -- IRRELEVANT - The damage will be recorded but will automatically be considered as useless damage.
    -- PENDING - The damage will be recorded but will not be relevant until flagged so.
    -- RELEVANT - The damage is relevant.
    -- ====================================================================================

    IsRelevantTarget = function(self, guid)
        if ( self.running ) and ( self.status == "ENGAGED" ) then
            -- If for some reason we should ignore damage done...

            if ( self.data.voidDamage ) then
                return "IGNORE";
            end

            -- If the target is affiliated with us, ignore damage (friendly fire).

            local uid = Root.Unit.GetUID(guid);
            if ( uid ) and ( self:IsUnitAffiliated(uid) ) then
                return "IGNORE";
            end

            -- Determinate if the unit is on the relevant targets list

            local id = Root.Unit.GetMobID(guid);
            local specificRelevance = false;
            if ( self.data.relevantTargets ) then
                if ( id and self.data.relevantTargets[id] ) or ( self.data.relevantTargets[guid] ) then
                    specificRelevance = true;
                end
            end

            -- Check against explicit adds and boss units
            -- ******************************************

            if ( guid == self.data.guid ) then
                return "RELEVANT"; -- Damaging the main boss unit is generally relevant :)
            end

            if ( self.data.addsLookup ) and ( self.data.addsLookup[guid] ) and ( not specificRelevance ) then
                -- This unit is a registered add. Damaging it should be relevant.
                -- If the add is explicitly flagged as a relevant target, then it will obey to the explicit relevant targets rules on the section below.
                if ( self.data.ignoreAdds ) then
                    -- However, if adds are optionnal (that means, killing them is not necessary to clear the boss), the score gain will be pending.
                    return "PENDING";
              else
                    return "RELEVANT";
                end
            end

            -- Past this point, we check against mobs that are not adds nor boss
            -- *****************************************************************

            if ( self.data.strictRelevance ) then
                if ( specificRelevance ) then
                    if ( self.data.relevanceNoPending ) then
                        return "RELEVANT";
                  else
                        return "PENDING";
                    end
              else
                    return "IRRELEVANT";
                end
          else
                if ( specificRelevance ) then
                    if ( self.data.relevanceNoPending ) then
                        return "RELEVANT";
                  else
                        return "PENDING";
                    end
              else
                    return "PENDING";
                end
            end
        end

        return "IGNORE";
    end,

    -- ============================================================================
    -- Add a list of targets to the relevant targets list.
    -- You can pass GUIDs or mobIDs. GUIDs are of course more specific than mobIDs.
    -- ============================================================================

    AddRelevantTargets = function(self, ...)
        if ( not self.running ) then return; end
        if ( not self.data.relevantTargets ) then self.data.relevantTargets = { }; end

        local nArgs = select('#', ...);
        local i, arg;
        for i=1, nArgs do
            arg = select(i, ...);
            self.data.relevantTargets[arg] = true;
        end
    end,

    -- ============================================================================
    -- Remove a list of targets to the relevant targets list.
    -- You can pass GUIDs or mobIDs. GUIDs are of course more specific than mobIDs.
    -- ============================================================================

    RemoveRelevantTargets = function(self, ...)
        if ( not self.running ) then return; end
        if ( not self.data.relevantTargets ) then return; end

        local nArgs = select('#', ...);
        local i, arg;
        for i=1, nArgs do
            arg = select(i, ...);
            self.data.relevantTargets[arg] = nil;
        end
    end,

    -- ===============================================
    -- Specify that no damage must be counted excepted
    -- if it's against one of the defined target.
    -- ===============================================

    SetStrictRelevance = function(self, flag)
        if ( not self.running ) then return; end

        self.data.strictRelevance = flag;
    end,

    -- ===================================================
    -- Specify that the targets flagged as relevant do not 
    -- have to die to validate the damage done to them.
    -- ===================================================

    SetRelevantDamagePending = function(self, pending)
        if ( not self.running ) then return; end

        self.data.relevanceNoPending = (not pending);
    end,

    -- ===============================================
    -- Specify that heals done on the mobs will not be
    -- deducted from total damage done.
    -- ===============================================

    SetIgnoreHealing = function(self, flag)
        if ( not self.running ) then return; end

        self.data.ignoreHealing = flag;
    end,

    -- =====================================================
    -- Get the table listing damage done on a unit.
    -- Possible damage types: RELEVANT, IRRELEVANT, PENDING.
    -- =====================================================

    GetTargetDamageTable = function(self, target, damageType)
        if ( not self.running ) then return nil; end
        if ( not self.data.damageDone ) then self.data.damageDone = { }; end

        local t = self.data.damageDone;
        if ( not t[target] ) then t[target] = { }; end

        t = t[target];

        if ( not t[damageType] ) then t[damageType] = { }; end
        return t[damageType];
    end,

    -- ====================================================================================
    -- Determinate if pending damage done to a dying unit should be credited to their
    -- respective damage dealers. Generally, this is true excepted in some cases.
    -- Kologarn arms is a good exemple: when the main body dies, so do the arms.
    -- That's why you'd not want to credit pending damage once the body dies.
    -- ====================================================================================

    CanCreditPendingDamage = function(self, guid)
        local result = self:IsRelevantTarget(guid);
        if ( result == "RELEVANT" or result == "PENDING" ) then
            return true;
      else
            return false;
        end
    end,

    -- ============================================================================
    -- Credit damage to a damage dealer, either as relevant, pending or irrelevant.
    -- ============================================================================

    CreditDamage = function(self, source, target, amount)
        local result = self:IsRelevantTarget(target);
        if ( result == "IGNORE" ) then return; end

        local targetTable = self:GetTargetDamageTable(target, result);
        if ( not targetTable ) then return; end
        targetTable[source] = (targetTable[source] or 0) + amount;
    end,

    -- ====================================
    -- Remove some damage done to a target.
    -- ====================================

    RollbackDamage = function(self, target, amount)
        local pendingTable    = self:GetTargetDamageTable(target, "PENDING");
        local relevantTable   = self:GetTargetDamageTable(target, "RELEVANT");
        local irrelevantTable = self:GetTargetDamageTable(target, "IRRELEVANT");

        local source, damage;
        local total = 0;

        for source, damage in pairs(pendingTable)    do total = total + damage; end
        for source, damage in pairs(relevantTable)   do total = total + damage; end
        for source, damage in pairs(irrelevantTable) do total = total + damage; end

        if ( total <= 0 ) then return; end

        for source, damage in pairs(pendingTable) do
            pendingTable[source] = pendingTable[source] * ((total - amount) / total);
        end
        for source, damage in pairs(relevantTable) do
            relevantTable[source] = relevantTable[source] * ((total - amount) / total);
        end
        for source, damage in pairs(irrelevantTable) do
            irrelevantTable[source] = irrelevantTable[source] * ((total - amount) / total);
        end
    end,

    -- =========================================================================
    -- Credit all pending damage on a target to their respective damage dealers.
    -- The magic word ADDS credit all pending damage on defined adds.
    -- =========================================================================

    CreditPendingDamage = function(self, target)
        if ( target == "ADDS" ) then
            local i, guid;
            for i=1, self:GetNumAdds() do
                guid = select(2, self:GetAddInfo(i));
                if ( guid ) then
                    self:CreditPendingDamage(guid);
                end
            end
            return;
        end

        local pendingTable  = self:GetTargetDamageTable(target, "PENDING");
        local relevantTable = self:GetTargetDamageTable(target, "RELEVANT");

        local source, damage;
        for source, damage in pairs(pendingTable) do
            relevantTable[source] = (relevantTable[source] or 0) + damage;
            pendingTable[source] = 0;
        end
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");