local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                       Environment data                         **
-- --------------------------------------------------------------------

local raidDifficulty = {
    [1] = { "NORMAL", 10, "10N" },
    [2] = { "NORMAL", 25, "25N" },
    [3] = { "HEROIC", 10, "10H" },
    [4] = { "HEROIC", 25, "25H" },
};

-- --------------------------------------------------------------------
-- **                      Environment functions                     **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> GetInstanceMode()                         - DEPRECATED - *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get the type of the instance.                                    *
-- * This function is deprecated as of 3.2 and existing modules using *
-- * it should switch to GetInstanceFormat instead.                   *
-- * 10-man will always return "NORMAL" and 25-man will always return *
-- * "HEROIC" in 3.3+.                                                *
-- * Returns either "NONE", "NORMAL" or "HEROIC".                     *
-- ********************************************************************
function Root.GetInstanceMode()
    local size = select(2, Root.GetInstanceFormat());
    if ( size == 25 ) then
        return "HEROIC";
elseif ( size == 1 ) then
        return "NONE";
  else
        return "NORMAL";
    end
end

-- ********************************************************************
-- * Root -> GetInstanceFormat()                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get the format of the current instance (mode and size).          *
-- * This function makes the difference between 5, 5-H,               *
-- * 10, 10-H, 25, 25-H as of 3.2 patch, using two return values.     *
-- * GetInstanceMode can still be used for pre-3.2 instances.         *
-- * Updated for 3.3's dynamic difficulty toggle.                     *
-- ********************************************************************
function Root.GetInstanceFormat()
    local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo();

    if ( type == "party" or type == "raid" ) then
        if ( type == "raid" ) then
            if ( isDynamic ) then
                if ( dynamicDifficulty == 1 ) then
                    return "HEROIC", maxPlayers, maxPlayers.."H";
              else
                    return "NORMAL", maxPlayers, maxPlayers.."N";
                end
          else
                if ( difficultyIndex >= 3 ) then
                    return "HEROIC", maxPlayers, maxPlayers.."H";
              else
                    return "NORMAL", maxPlayers, maxPlayers.."N";
                end
            end
      else
            if ( difficultyIndex == 2 ) then
                return "HEROIC", maxPlayers, maxPlayers.."H";
          else
                return "NORMAL", maxPlayers, maxPlayers.."N";
            end
        end
    end

    return "NONE", 1, "1";
end

-- ********************************************************************
-- * Root -> CheckAuth("authType")                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> authType: the authorization type to check.                    *
-- * Can be: SUPERADMIN, ADMIN, WARNING, SYMBOL.                      *
-- ********************************************************************
-- * Returns whether you have the authorization or not to do a given  *
-- * operation on the raid or the party.                              *
-- ********************************************************************
function Root.CheckAuth(authType)
    if ( GetNumRaidMembers() > 0 ) then
        if ( IsRaidLeader() or IsRaidOfficer() ) then
            if ( authType == "SUPERADMIN" and IsRaidOfficer() ) then
                return false;
            end
            return true;
        end
elseif ( GetNumPartyMembers() > 0 ) then
        if ( authType == "WARNING" or authType == "SYMBOL" ) then
            return true;
        end
        if ( IsPartyLeader() ) then
            return true;
        end
    end
    return false;
end

-- ********************************************************************
-- * Root -> EvaluateLock(lockCondition)                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> lockCondition: the lock condition for it to be active.        *
-- * Can be: ADMIN, WARNING, SYMBOL or a function returning true.     *
-- ********************************************************************
-- * Returns whether a lock is active on the module settings frame.   *
-- * A lock is put on options you do not have the permission to use.  *
-- ********************************************************************
function Root.EvaluateLock(lockCondition)
    if ( lockCondition == "ADMIN" or lockCondition == "WARNING" or lockCondition == "SYMBOL" ) then
        return (not Root.CheckAuth(lockCondition));
elseif type(lockCondition) == "function" then
        return lockCondition();
    end
    return false;
end

-- ********************************************************************
-- * Root -> CheckRaidAuth(unit)                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> unit: can be an UID, name or GUID of someone in your raid.    *
-- ********************************************************************
-- * Get the rank of the given unit in the raid or party.             *
-- * Can be LEADER, ASSIST or NORMAL.                                 *
-- ********************************************************************
function Root.CheckRaidAuth(unit)
    if ( not UnitExists(unit) ) then
        -- Invalid UID, try to redirect.
        unit = Root.Unit.GetUID(unit);
    end
    if ( not unit ) then return "NORMAL"; end
    if ( GetNumRaidMembers() > 0 ) then
        if ( UnitInRaid(unit) ) then
            local unitName = UnitName(unit);
            local i, name, rank;
            for i=1, GetNumRaidMembers() do
                name, rank = GetRaidRosterInfo(i);
                if ( name == unitName ) then
                    if ( rank == 2 ) then return "LEADER"; end
                    if ( rank == 1 ) then return "ASSIST"; end
                end
            end
        end
  else
        if ( UnitInParty(unit) ) then
            if ( UnitIsPartyLeader(unit) ) then
                return "LEADER";
            end
        end
    end
    return "NORMAL";
end

-- ********************************************************************
-- * Root -> GetPlayerFaction([uid])                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> uid: provide this if you want to query another unit.          *
-- ********************************************************************
-- * Get the local player's faction.                                  *
-- * Can also be used for other units if uid is provided.             *
-- ********************************************************************
function Root.GetPlayerFaction(uid)
    local faction = UnitFactionGroup(uid or "player");
    if ( not faction ) then
        return "NONE";
  else
        return string.upper(faction);
    end
end

-- ********************************************************************
-- * Root -> BootFromRaid(unit[, reason])                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> unit: can be an UID, name or GUID of someone in your raid.    *
-- * >> reason: why the unit was kicked. Optionnal.                   *
-- ********************************************************************
-- * Try to kick an unit from the raid. Will do & say nothing if you  *
-- * do not have the permission to do this.                           *
-- * Return true if kick command was issued successfully.             *
-- * Return false if not.                                             *
-- ********************************************************************
function Root.BootFromRaid(unit, reason)
    if ( not UnitExists(unit) ) then
        -- Invalid UID, try to redirect.
        unit = Root.Unit.GetUID(unit);
    end
    if ( not unit ) then return false; end

    local name = UnitName(unit);
    if ( not name ) then return false; end
    if ( UnitIsUnit(unit, "player") ) then return false; end

    local permission = true;
    local myAuth = Root.CheckRaidAuth("player");
    local targetAuth = Root.CheckRaidAuth(unit);
     
    if ( myAuth ~= "LEADER" and myAuth ~= "ASSIST" ) then
        -- We're not a raid officer/leader, so we cannot kick anyone.
        permission = false;

elseif ( myAuth == "ASSIST" ) then
        -- If we are a raid officer, then we can kick anybody but the other officers (and leader of course).
        if ( targetAuth == "LEADER" or targetAuth == "ASSIST" ) then
            permission = false;
        end

elseif ( myAuth == "LEADER" ) then
        -- We are the raid leader, so we can do anything we want.
    end

    -- Ok, so finally, do we have the permission to remove the player ?

    if ( permission ) then
        if ( reason ) then
            Root.Say(reason, true);
        end
        UninviteUnit(unit);
    end

    return permission;
end
