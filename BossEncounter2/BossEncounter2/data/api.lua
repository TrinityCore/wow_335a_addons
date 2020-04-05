local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                              API                               **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * BossEncounter2_GetEncounterInfo()                                *
-- ********************************************************************
-- * Arguments:                                                       *
-- *   <none>                                                         *
-- ********************************************************************
-- * Get infos about the currently running boss module.               *
-- * This API is designed to be easily useable by external AddOns.    *
-- * If a boss module is not running:                                 *
-- * Return false                                                     *
-- * If a boss module is running:                                     *
-- * Return moduleName, encounterTitle, bossGUID, bossHpPercent,      *
-- *        encounterTime, aliveMembers, startingMembers.             *
-- * Some returns can be nil, so be careful.                          *
-- ********************************************************************
function BossEncounter2_GetEncounterInfo()
    local module = Root.Encounter.GetActiveModule();
    if ( module ) and ( module.running ) and ( module.data ) then
        local data = module.data;
        local isBossModule = data.name or data.guid;
        if ( isBossModule ) and ( not data.test ) then
            local moduleName = module:GetName();
            local encounterTitle = data.title or data.name or "???";
            local bossGUID = data.guid or nil;
            local bossHpPercent = nil;
            local encounterTime = data.globalTimer or 0;
            local aliveMembers = module:CountNumValidMembers() or nil;
            local startingMembers = data.startingPlayers or nil;

            local uid = Root.Unit.GetUID(bossGUID);
            if ( uid ) then
                bossHpPercent = UnitHealth(uid) * 100 / UnitHealthMax(uid);
            end

            return moduleName, encounterTitle, bossGUID, bossHpPercent, encounterTime, aliveMembers, startingMembers;
        end
    end
    return false;
end