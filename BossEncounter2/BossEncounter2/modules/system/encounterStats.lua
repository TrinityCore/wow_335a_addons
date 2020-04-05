local Root = BossEncounter2;

local EncounterStats = Root.GetOrNewModule("EncounterStats");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- Provides ways to memorize the stats of the various boss encounters
-- and to pull the data when needed.

-- --------------------------------------------------------------------
-- **                            Data                                **
-- --------------------------------------------------------------------

local currentInfo = {
    name = nil,
    attempts = 0,
    attempt = 0,
    speed = 0,
    technique = 0,
    clearTime = nil,
    previousTime = nil,
    previousScore = nil,
    numKilled = 0,
    sequence = "NORMAL",
    dps = { },
};

-- FOR DEBUG
--[[
local currentInfo = {
    name = "Test",
    attempts = 1,
    attempt = 100,
    speed = 100,
    technique = 100,
    clearTime = 10,
    previousTime = nil,
    previousScore = nil,
    numKilled = 0,
    sequence = "MINI",
    dps = {
        coupDeGrace = 2,
    },
};
do
    -- Generate a test sample
    local i, dps, sum, maximum;
    sum, maximum = 0, 0;
    for i=1, 5 do
        dps = 15000 / ((i-1)/8 + 1);
        sum = sum + dps;
        tinsert(currentInfo.dps, {guid = i, name = "Guy "..i, dps = dps, class = "DRUID", special = nil});
        maximum = math.max(maximum, dps);
    end
    currentInfo.dps.average = sum / 5;
    currentInfo.dps.total = sum;
    currentInfo.dps.maximum = maximum;
end
]]

local classificationToSequence = {
    ["worldboss"] = "RAID",
    ["elite"] = "NORMAL",
    ["rareelite"] = "MINI",
    ["rare"] = "MINI",
    ["normal"] = "NORMAL",
    ["default"] = "NORMAL",
};

local tryCountScore = {
    [1] = 120,
    [2] = 100,
    [3] =  75,
    [4] =  50,
    [5] =  25,
};

local EMPTY_TABLE = { };

-- --------------------------------------------------------------------
-- **                          Constants                             **
-- --------------------------------------------------------------------

-- After this amount of seconds has passed since the last boss attempt,
-- the attempt counter for this boss will be reset.
local ATTEMPT_COUNT_EXPIRE_TIMER = 21600;

-- --------------------------------------------------------------------
-- **                           Methods                              **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * EncounterStats:GetInfo(id)                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> id: the identifier of the boss fight. This ID is chosen by    *
-- * the boss module itself. It can be anything, a number or string.  *
-- ********************************************************************
-- * Get history data about a given boss encounter.                   *
-- * These informations are character-specific.                       *
-- * Return:                                                          *
-- *    name, numAttempts, numKilled, bestScore, bestTime             *
-- *                                                                  *
-- * name: the name of the encounter, usually the main boss name.     *
-- * numAttempts: the current attempt number. 1 if it is the first    *
-- * time the boss is fought. The attempt number will reset after     *
-- * enough time has passed since last attempt.                       *
-- * numKilled: the number of times the boss has been killed.         *
-- * bestScore, bestTime: best score/time data for this boss.         *
-- * bestScore and bestTime will be nil if the boss was never killed. *
-- ********************************************************************

EncounterStats.GetInfo = function(self, id)
    local t = self:Access(id, false);
    if ( not t ) then
        return UNKNOWN, 1, 0, nil, nil;
    end
    local numAttempts = self:GetAttemptCount(t) + 1;
    return t.name, numAttempts, t.kills, t.score, t.combatTime;
end

-- ********************************************************************
-- * EncounterStats:GetCurrentInfo()                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get infos about the boss encounter that has just been cleared.   *
-- * It will provide comparison data with the previous record for     *
-- * that encounter.                                                  *
-- * Return:                                                          *
-- *    name, attempts, attemptScore, speedScore, techniqueScore,     *
-- * clearTime, previousTime, previousScore, numKilled, sequence, dps *
-- *                                                                  *
-- * name: the name of the encounter, usually the main boss name.     *
-- * attempts: the attempts used to defeat the encounter.             *
-- * attempt, score, technique: the various score criterias.          *
-- * clearTime, previousTime: the time the encounter lasted.          *
-- * previousScore: the previous best score.                          *
-- * numKilled: the number of times the boss has been killed.         *
-- * sequence: the clear sequence that should be played.              *
-- * dps: the table containing DPS data for members of the raid.      *
-- *                                                                  *
-- * Note that clearTime will be nil if the fight was incomplete.     *
-- * previousTime and previousScore will be nil if no record exists.  *
-- ********************************************************************

EncounterStats.GetCurrentInfo = function(self)
    local t = currentInfo;
    return t.name, t.attempts, t.attempt, t.speed, t.technique, t.clearTime, t.previousTime, t.previousScore, t.numKilled, t.sequence, t.dps;
end

-- ********************************************************************
-- * EncounterStats:BossCleared(module)                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> module: the boss module that announces proudly that the boss  *
-- * has been killed.                                                 *
-- ********************************************************************
-- * Acknowledges that the player has killed a boss.                  *
-- * This method will directly query data from the boss module.       *
-- * Once this method is called, the GetCurrentInfo method will be    *
-- * available to get the score of the boss that has been killed.     *
-- ********************************************************************

EncounterStats.BossCleared = function(self, module)
    local id, displaySuffix = module:GetID();
    local data = module.data;
    if ( not id ) then return; end
    if ( not data ) then return; end

    local t = self:Access(id, true);
    if ( not t ) then return; end

    -- PHASE 1 - Prepare data for processing

    -- Load previous history for this boss, if any.
    local _, numAttempts, numKilled, prevScore, prevTime = self:GetInfo(id);

    local battleName = (data.title or data.name or "?")..displaySuffix;
    local clearSequence = data.clearSequence or classificationToSequence[data.classification or "default"];

    local battleDuration = data.globalTimer or 0;
    local invalidDuration = data.bossAlreadyFighting or false;

    local totalDamage = data.totalDamage or 0;
    local manaFraction = min(1, (data.remainingMana or 1) / (data.totalMana or 1) * 1.50); -- If the raid has up to 1/3 mana, we still consider it as full mana.
    local poorTime = data.poorTime or nil;
    local greatTime = data.greatTime or nil;
    local remainingPlayers = data.survivingPlayers or 0;
    local startingPlayers = data.startingPlayers or 0;
    local maxPlayers = data.maxPlayers or 1;
    local surviveRatio = remainingPlayers / startingPlayers;

    local attempt, speed, technique;
    local totalPoints;

    -- PHASE 2 - Calculate each criteria and the final score.

    -- Attempt score calculation:
    -- * 120 points on the first try.
    -- * 100 points on the second try.
    -- * 75 points on 3rd.
    -- * 50 points on 4th.
    -- * 25 points on 5th.
    -- * 0 point on 6th+.

    attempt = tryCountScore[numAttempts] or 0;

    -- Speed calculation:
    -- * 50 points if the player has cleared the boss in the expected time limit.
    -- * The result is between 0~120 points.

    if ( not poorTime ) or ( not greatTime ) or ( invalidDuration ) then
        speed = 0;
  else
        if ( battleDuration >= poorTime ) then
            speed = 0;
      else
            speed = (poorTime - battleDuration) / (poorTime - greatTime) * 100;
            speed = min(120, max(0, speed));
            speed = math.floor(speed + 0.5);
        end
    end

    -- Technique calculation:
    -- * Up to 75 pts based on the % of people that survived.
    -- * Up to 25 pts based on the % of mana remaining to the raid.
    -- * Bonus granted for each player slot unused below the maximal number of players (24 players out of 25 => +5 pts, 9 players out of 10 => +12.5 pts).

    local survivalPoints = ( math.exp(10/3 * (surviveRatio-1)) - 0.05 * (1-surviveRatio) ) * 75;
    local manaPoints = manaFraction * 25;
    local bonusPoints = (maxPlayers - startingPlayers) / maxPlayers * 125;

    technique = survivalPoints + manaPoints + bonusPoints;
    technique = min(120, max(0, technique));
    technique = math.floor(technique + 0.5);

    -- Final score calculation:
    -- * Simply the sum of all three criterias.
    -- * It is between 0~360.

    totalPoints = attempt + speed + technique;

    -- PHASE 3 - Update data for this boss encounter.

    if ( not prevScore ) or ( prevScore < totalPoints ) then
        t.score = totalPoints;
    end
    if (( not prevTime ) or ( prevTime > battleDuration )) and ( not invalidDuration ) then
        t.combatTime = battleDuration;
    end
    t.name = battleName;
    t.kills = numKilled + 1;
    t.attempts = 0;
    t.lastTry = 0;
    t.lastClear = time();

    -- PHASE 4 - Set current info table

    currentInfo.name = battleName;
    currentInfo.attempts = numAttempts;
    currentInfo.attempt = attempt;
    currentInfo.speed = speed;
    currentInfo.technique = technique;
    currentInfo.clearTime = battleDuration;
    currentInfo.previousTime = prevTime;
    currentInfo.previousScore = prevScore;
    currentInfo.numKilled = numKilled + 1;
    currentInfo.sequence = clearSequence;
    currentInfo.dps = self:CreateDPSTable(data);

    if ( invalidDuration ) then
        currentInfo.clearTime = nil;
        Root.Print(Root.Localise("Console-IncompleteFightExplain"));
    end

    -- PHASE 5 - If score info is to be null, then erase all points data.

    if ( data.nullScore ) then
        t.score = 0;
        currentInfo.attempt = nil;
        currentInfo.speed = nil;
        currentInfo.technique = nil;
    end

    -- PHASE 6 - If the performance is crap, overide the sequence with FAIL sequence.

    if ( self:CurrentClearIsTerrible() ) then
        currentInfo.sequence = "FAIL";
    end
end

-- ********************************************************************
-- * EncounterStats:BossFailed(module)                                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> module: the boss module that announces shamefully that the    *
-- * boss has been PHAILED.                                           *
-- ********************************************************************
-- * Acknowledges that the player pathetically wiped on a boss.       *
-- * Be careful not to call this when it is not a wipe.               *
-- ********************************************************************

EncounterStats.BossFailed = function(self, module)
    local id = module:GetID();
    if ( not id ) then return; end

    local t = self:Access(id, true);
    if ( not t ) then return; end

    t.attempts = self:GetAttemptCount(t) + 1;
    t.lastTry = time();
end

-- ********************************************************************
-- * EncounterStats:Access(id, writeMode)                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> id: the ID of the boss fight whose data is accessed.          *
-- * >> writeMode: set this to create a table if no data currently    *
-- * exists for this boss fight.                                      *
-- ********************************************************************
-- * Access the data table of a boss fight.                           *
-- * Will return the data table or nil.                               *
-- ********************************************************************

EncounterStats.Access = function(self, id, writeMode)
    if ( not self.DB ) then return nil; end

    local t = self.DB[id];
    if ( not t ) and ( writeMode ) then
        t = {
            name = UNKNOWN, -- Populate the new entry with default values.
            attempts = 0,
            kills = 0,
            score = nil,
            combatTime = nil,
            lastClear = 0,
            lastTry = 0,
        };
        self.DB[id] = t;
    end
    return t or nil;
end

-- ********************************************************************
-- * EncounterStats:GetAttemptCount(dataTable)                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> dataTable: a boss fight data table.                           *
-- ********************************************************************
-- * Get the real attempt number, taking in account the expire timer. *
-- ********************************************************************

EncounterStats.GetAttemptCount = function(self, dataTable)
    local elapsed = time() - dataTable.lastTry;
    if ( dataTable.lastTry == 0 ) or ( elapsed > ATTEMPT_COUNT_EXPIRE_TIMER ) then
        return 0;
  else
        return dataTable.attempts;
    end
end

-- ********************************************************************
-- * EncounterStats:CreateDPSTable(dataTable)                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> dataTable: a boss fight data table.                           *
-- ********************************************************************
-- * Generate a DPS table by parsing the data table.                  *
-- ********************************************************************

EncounterStats.CreateDPSTable = function(self, dataTable)
    local damageTable = dataTable.damageDone; -- Raw damage data table passed by the encounter module.
    local sourceTable = { };                  -- Table containing relevant damage per source.
    local sourceTotalTable = { };             -- Table containing total damage per source.
    local sourcePetTable = { };               -- Table listing the pet contribution per source.
    local dpsTable = { };                     -- Final output as DPS

    local combatDuration = dataTable.globalTimer or 0;
    if ( dataTable.invalidDuration ) then
        combatDuration = 0;
    end

    if ( damageTable ) and ( combatDuration > 0 ) then
        local target, targetTable, source, damage;
        for target, targetTable in pairs(damageTable) do
            -- Note: total damage is relevant + pending + irrelevant damage.
            for source, damage in pairs(targetTable["RELEVANT"] or EMPTY_TABLE) do
                sourceTable[source] = (sourceTable[source] or 0) + damage;
                sourceTotalTable[source] = (sourceTotalTable[source] or 0) + damage;
            end
            for source, damage in pairs(targetTable["PENDING"] or EMPTY_TABLE) do
                sourceTotalTable[source] = (sourceTotalTable[source] or 0) + damage;
            end
            for source, damage in pairs(targetTable["IRRELEVANT"] or EMPTY_TABLE) do
                sourceTotalTable[source] = (sourceTotalTable[source] or 0) + damage;
            end
        end

        -- We have now the relevant & total damage by each source.
        -- Determinate now which sources are part of the raid.
        -- Handle pets, etc.

        local isPartner, unitType, name, parameter; -- parameter is "class" if the unit is a player, "master" if it is a pet and has no meaning otherwise.
        for source, damage in pairs(sourceTable) do
            isPartner, unitType, name, parameter = Root.Unit.GetAffiliation(source);

            if ( isPartner ) then
                if ( unitType == "PET" ) and ( parameter ) then
                    sourcePetTable[parameter] = (sourcePetTable[parameter] or 0) + damage;

            elseif ( unitType == "PLAYER" ) then
                    tinsert(dpsTable, {guid = source, name = name or "?", class = parameter or nil});
                end
            end
        end

        local i, info, thisDps, thisTotalDps, sum, total, maximum;

        -- Finally, compile the final DPS done after taking pets in account.

        sum, total, maximum = 0, 0, 0;

        for _, info in ipairs(dpsTable) do
            -- The useful dps from the pet is computed beforehand.
            if ( sourcePetTable[info.guid] ) then
                info.pet = sourcePetTable[info.guid] / combatDuration;
          else
                info.pet = 0;
            end
            thisDps = sourceTable[info.guid] / combatDuration + info.pet;
            thisTotalDps = sourceTotalTable[info.guid] / combatDuration + info.pet;
            info.dps = thisDps;
            info.totalDps = thisTotalDps;
            sum = sum + thisDps;
            total = total + 1;
            maximum = math.max(maximum, thisDps);
        end

        -- Remove false damage dealers (that is to say, healers in most cases...).

        local threshold = sum / (3 * math.max(1, total));

        for i=#dpsTable, 1, -1 do
            if ( dpsTable[i].dps < threshold ) then
                tremove(dpsTable, i);
            end
        end

        -- Recompute stats after false damage dealers have been removed.

        sum, total = 0, 0;
        for _, info in ipairs(dpsTable) do
            sum = sum + info.dps;
            total = total + 1;
        end
        if ( total > 0 ) then
            dpsTable.average = sum / total;
      else
            dpsTable.average = 0;
        end
        dpsTable.maximum = maximum;
        dpsTable.total = sum;

        -- Sort the table

        Root.Sort.ByNumericField(dpsTable, "dps", true);
  else
        dpsTable.average = 0;
        dpsTable.maximum = 0;
        dpsTable.total = 0;
    end

    dpsTable.coupDeGrace = dataTable.coupDeGrace;

    return dpsTable;
end

-- ********************************************************************
-- * EncounterStats:PrintDPSToChat(dpsTable, destination)             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> dpsTable: the DPS table being printed.                        *
-- * >> destination: where the table should be printed.               *
-- ********************************************************************
-- * Print a DPS table on the chat.                                   *
-- * Destination is one of valid values of "where" in Root -> Output. *
-- ********************************************************************

EncounterStats.PrintDPSToChat = function(self, dpsTable, destination)
    local O = Root.Output;
    local L = Root.Localise;
    local FL = Root.FormatLoc;
    local i, pct, wastedDPS, relevancePct, petString;

    O(L("UsefulDPSChat"), destination);
    for i=1, #dpsTable do
        pct = dpsTable[i].dps * 100 / dpsTable.total;
        wastedDPS = max(0, dpsTable[i].totalDps - dpsTable[i].dps);
        relevancePct = min(100, dpsTable[i].dps * 100 / dpsTable[i].totalDps);

        petString = "";
        if ( dpsTable[i].pet > 0 ) then
            petString = Root.FormatLoc("UsefulDPSPet", dpsTable[i].pet);
        end

        O(FL("UsefulDPSEntryChat", i, dpsTable[i].name, dpsTable[i].dps, petString, pct, wastedDPS, relevancePct + 0.5), destination);
    end
    O(FL("AverageDPS", dpsTable.average), destination);
end

-- ********************************************************************
-- * EncounterStats:CurrentClearIsTerrible()                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Determinate if we had a terrible performance on the boss we've   *
-- * just killed.                                                     *
-- ********************************************************************

EncounterStats.CurrentClearIsTerrible = function(self)
    local name, attempts, attemptScore, speedScore, techniqueScore, clearTime, previousTime, previousScore, numKilled, sequence, dps = EncounterStats:GetCurrentInfo();
    local totalScore = (attemptScore or 0) + (speedScore or 0) + (techniqueScore or 0);

    if ( attempts > 5 ) and ( numKilled > 5 ) and ( totalScore < 100 ) then
        return true;
  else
        return false;
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

EncounterStats.OnStart = function(self)
    -- Grab the DB table.
    self.DB = Root.Save.Get("record", "encounter", "active") or { };
    Root.Save.Set("record", "encounter", self.DB, "active");
end
