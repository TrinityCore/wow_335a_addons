local Root = BossEncounter2;

Root.Unit = {
    nextUpdate = 0,
    nextDisconnectCheck = 0,
    mouseoverGUID = "none",
};

-- --------------------------------------------------------------------
-- **                             Data                               **
-- --------------------------------------------------------------------

local UIDLookup = { };
local UnitList = { };

local connectState = { };

local UPDATE_UNIT_LIST_RATE = 0.300;
local CHECK_DISCONNECT_RATE = 0.250;

-- Useful table for building the unit list.

local StaticPassList = { };
local TempPassList   = { };
local TargetPassList = { };

local AddTargetToTable = function(uid, target, nestLevels)
    local i;
    for i=1, nestLevels do
        target[#target+1] = uid..strrep("target", i);
    end
end;

local me = {
    player = true,
    pet = true,
    vehicle = true,
}

local affiliations = nil;

-- --------------------------------------------------------------------
-- **                              API                               **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> Unit -> GetTypeFromGUID(guid)                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> guid: the GUID of who is checked.                             *
-- ********************************************************************
-- * Determinates the unit type of the unit a GUID belongs to.        *
-- * Will either return "npc" (incl. pets) or "player".               *
-- * "unknown" may be returned in case of erroneous data.             *
-- ********************************************************************
function Root.Unit.GetTypeFromGUID(guid)
    if ( not guid ) then return "unknown"; end
    --[[
    local typeCreature = tonumber(string.sub(guid, 5, 5), 16);
    local isPlayer = bit.band(typeCreature, 0x00f) == 8;
    local isNPC = bit.band(typeCreature, 0x00f) == 3;
    local isPet = bit.band(typeCreature, 0x00f) == 4;
    ]]
    local typeCreature = string.sub(guid, 3, 3);
    if ( typeCreature == "F" ) then return "npc"; end
    return "player";
end

-- ********************************************************************
-- * Root -> Unit -> GetMobID(guid)                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> guid: the GUID to extract the mob ID from.                    *
-- ********************************************************************
-- * Get the mob ID portion of a GUID (returns decimal number).       *
-- ********************************************************************
function Root.Unit.GetMobID(guid)
    if ( not guid ) then return nil; end
    if not ( Root.Unit.GetTypeFromGUID(guid) == "npc" ) then return nil; end
    local id = string.sub(guid, -12, -7);
    return tonumber(id, 16) or nil;
end

-- ********************************************************************
-- * Root -> Unit -> GetNumUID()                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Get the numbers of different units that are listed in the global *
-- * unit list. No unit apparears twice in this list, so if Bob can   *
-- * be accessed from "player" and "target" UIDs, the UID that will   *
-- * be kept to access Bob will be "player".                          *
-- ********************************************************************
function Root.Unit.GetNumUID()
    return #UnitList;
end

-- ********************************************************************
-- * Root -> Unit -> GetUID(guid or name or index)                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> guid or name: the GUID or name to find an UID for.            *
-- *                             - OR -                               *
-- * >> index: the index to get info about in the global unit list.   *
-- ********************************************************************
-- * Try to get an UID pointing at the given GUID or name.            *
-- * This function has a high chance for failing.                     *
-- * In that case, nil will be returned.                              *
-- *                             - OR -                               *
-- * You can also explore with this function the global unit list by  *
-- * passing the index of the element of the list you want to get     *
-- * infos from. GUID and name will then be returned.                 *
-- ********************************************************************
function Root.Unit.GetUID(value)
    if type(value) == "number" then
        -- Find the nth entry in the global unit list.
        local info = UnitList[value];
        if info then
            return strsplit("|", info, 2);
        end

  elseif type(value) == "string" then
        -- Find a guid or name in the quick lookup table.
        local expectedUID = UIDLookup[value];

        if ( expectedUID ) then
            local name = UnitName(expectedUID);
            local guid = UnitGUID(expectedUID);

            if ( value == name or value == guid ) then -- Safety check in case UIDs have changed in-between.
                return expectedUID;
            end
        end
    end

    return nil;
end

-- ********************************************************************
-- * Root -> Unit -> RebuildList()                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Calling this API will ask a complete reconstruction of           *
-- * accessable units by either their name or GUID.                   *
-- * This is now necessary for GetUID function.                       *
-- * RebuildUnitList should be called whenever any UID changes or at  *
-- * a reasonnable periodic update rate.                              *
-- ********************************************************************
function Root.Unit.RebuildList()
    local k, i;

    -- Clean up
    wipe(UnitList);
    wipe(UIDLookup);

    wipe(StaticPassList);
    wipe(TempPassList);
    wipe(TargetPassList);

    -- Upvalue
    local Add = Root.Unit.AddToList;

    -- Enumeration of stuff in the correct priority list.
    -- Static UIDs will get the first slots (the more stable ones), temporary UIDs will get not-so-stable slots and target UIDs will get the most unstable ones.

    tinsert(StaticPassList, "player"); -- Make sure player IS in the list, even if it appears twice.
    if ( GetNumRaidMembers() > 0 ) then
        for i=1, GetNumRaidMembers(), 1 do
            tinsert(StaticPassList, "raid"..i);
            tinsert(TempPassList, "raidpet"..i);
        end
  else
        for i=1, GetNumPartyMembers(), 1 do
            tinsert(StaticPassList, "party"..i);
            tinsert(TempPassList, "partypet"..i);
        end
    end
    for i=1, 4 do
        tinsert(StaticPassList, "boss"..i);
    end

    -- Temp UIDs enumeration.
    tinsert(TempPassList, "pet");
    tinsert(TempPassList, "target");
    tinsert(TempPassList, "focus");
    tinsert(TempPassList, "mouseover");
    tinsert(TempPassList, "vehicle");

    -- The target of target UIDs are automatically generated from Static and Temp UIDs.

    -- Do each pass.
    Add(StaticPassList, AddTargetToTable, TargetPassList, 3);
    Add(TempPassList, AddTargetToTable, TargetPassList, 3);
    Add(TargetPassList);

    -- Schedule the next rebuild

    Root.Unit.nextUpdate = GetTime() + UPDATE_UNIT_LIST_RATE;

    -- Fire unit list updated handler

    Root.InvokeHandler("OnUnitListUpdated");
end

-- ********************************************************************
-- * Root -> Unit -> AddToList(UID or list[, callback, ...])          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> UID: the unit to add to the unit list and lookup table.       *
-- *                          - OR -                                  *
-- * >> list: a list containing UIDs we should try to add.            *
-- * >> callback: callback to call each time an unit is added         *
-- * succesfully in the global unit list, passing UID.                *
-- * >> ...: arguments to pass to callback.                           *
-- ********************************************************************
-- * This will add the given unit's name and guid to the lookup table *
-- * and create if it doesn't exist yet an entry for the unit in the  *
-- * global unit list.                                                *
-- * Returns nil if the unit has already been referenced (through     *
-- * another but equivalent UID for exemple) or if the unit doesn't   *
-- * exist.                                                           *
-- * Returns 1 if the unit has been added to the list successfully.   *
-- ********************************************************************
function Root.Unit.AddToList(UID, callback, ...)
    if type(UID) == "table" then
        local k, v, result;
        for k, v in ipairs(UID) do
            Root.Unit.AddToList(v, callback, ...);
        end

elseif type(UID) == "string" then
        if not ( UnitExists(UID) ) then return nil; end
        local name = UnitName(UID);
        local guid = UnitGUID(UID);
        Root.Unit.ResolveAffiliation(UID);
        if not ( UIDLookup[name] ) then UIDLookup[name] = UID; end
        if not ( UIDLookup[guid] ) then
            -- GUID still not in the lookup. First occurence of this entity in the list.
            UIDLookup[guid] = UID;
            UnitList[#UnitList+1] = guid.."|"..name;
            if type(callback) == "function" then
                callback(UID, ...);
            end
            return 1;
        end
    end
    return nil;
end

-- ********************************************************************
-- * Root -> Unit -> GetGUIDFromMobID(mobID)                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> mobID: the mobID we want to find an instance of.              *
-- ********************************************************************
-- * Get the GUID of the first instance of the mobID that is          *
-- * encountered in the global unit list.                             *
-- ********************************************************************
function Root.Unit.GetGUIDFromMobID(mobID)
    if not mobID then return nil; end

    local i, guid, name;
    for i=1, Root.Unit.GetNumUID() do
        guid, name = Root.Unit.GetUID(i);
        if ( Root.Unit.GetMobID(guid) == mobID ) and ( name ~= UNKNOWN ) then
            return guid;
        end
    end

    return nil;
end

-- ********************************************************************
-- * Root -> Unit -> SearchEffect(uid, effectType, effectName,        *
-- *                              lookForMine)                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> uid: the unit to check.                                       *
-- * >> effectType: either BUFF or DEBUFF.                            *
-- * >> effectName: the name of the effect.                           *
-- * >> lookForMine: determinate if only buffs/debuffs put by the     *
-- * player are valid results                                         *
-- ********************************************************************
-- * Check if a given effect is present on the given unit.            *
-- * Returns true, timeLeft on the effect and stackCount if present.  *
-- *         false, nil, nil if not.                                  *
-- ********************************************************************
function Root.Unit.SearchEffect(uid, effectType, effectName, lookForMine)
    local api = UnitDebuff;
    if ( effectType == "BUFF" ) then api = UnitBuff; end

    local i;
    for i=1, 40 do
        local name, rank, icon, count, debuffType, duration, timeLeft, caster, isStealable = api(uid, i);
        if ( name == effectName ) then
            if ( not lookForMine ) or ( lookForMine and me[caster] ) then
                timeLeft = max(0, (timeLeft or 0) - GetTime());
                return true, timeLeft, count;
            end
        end
    end

    return false, nil, nil;
end

-- ********************************************************************
-- * Root -> Unit -> SearchEffectRaw(uid, effectType, effectName)     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> uid: the unit to check.                                       *
-- * >> effectType: either BUFF or DEBUFF.                            *
-- * >> effectName: the name of the effect.                           *
-- ********************************************************************
-- * Check if a given effect is present on the given unit.            *
-- * Returns true, startTime, duration, stackCount if present.        *
-- *         false, nil, nil, nil if not.                             *
-- ********************************************************************
function Root.Unit.SearchEffectRaw(uid, effectType, effectName)
    local api = UnitDebuff;
    if ( effectType == "BUFF" ) then api = UnitBuff; end

    local i;
    for i=1, 40 do
        local name, rank, icon, count, debuffType, duration, expiration, caster, isStealable = api(uid, i);
        if ( name == effectName ) then
            return true, expiration - duration, duration, count;
        end
    end

    return false, nil, nil, nil;
end

-- ********************************************************************
-- * Root -> Unit -> EnumerateRaid(theTable)                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> theTable: the table that will contain the UID enumeration.    *
-- ********************************************************************
-- * Put all UIDs of raid members in a table. If you are not in a     *
-- * raid, party UIDs including yourself will be put instead.         *
-- * Pets are ignored.                                                *
-- ********************************************************************
function Root.Unit.EnumerateRaid(theTable)
    local i;
    if ( GetNumRaidMembers() > 0 ) then
        for i=1, GetNumRaidMembers() do
            tinsert(theTable, "raid"..i);
        end
  else
        if ( GetNumPartyMembers() > 0 ) then
            for i=1, GetNumPartyMembers() do
                tinsert(theTable, "party"..i);
            end
        end
        tinsert(theTable, "player");
    end
end

-- ********************************************************************
-- * Root -> Unit -> CheckDisconnect()                                *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Calling this API will check if any raid member has gone from     *
-- * connected to disconnected status.                                *
-- ********************************************************************
function Root.Unit.CheckDisconnect()
    local baseUID = "party";
    local maxIndex = GetNumPartyMembers();
    if ( GetNumRaidMembers() > 0 ) then
        baseUID = "raid";
        maxIndex = GetNumRaidMembers();
    end
    local i, uid, guid, connected, name;
    for i=1, maxIndex do
        uid = baseUID..i;
        guid = UnitGUID(uid);
        connected = UnitIsConnected(uid) or 0;
        name = UnitName(uid);
        if ( connectState[guid] ) and ( connected ~= connectState[guid] ) then
            if ( connected == 0 ) then
                -- This guy has (been) disconnected.
                Root.InvokeHandler("OnConnectChange", guid, name, false);
            end
            if ( connected == 1 ) and ( UnitAffectingCombat("player") ) then
                -- This guy has reconnected.
                Root.InvokeHandler("OnConnectChange", guid, name, true);
            end
        end
        connectState[guid] = connected;
    end

    -- Schedule the next check

    Root.Unit.nextDisconnectCheck = GetTime() + CHECK_DISCONNECT_RATE;
end

-- ********************************************************************
-- * Root -> Unit -> GetPetMasterUID(petUID)                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> petUID: the UID of the pet.                                   *
-- ********************************************************************
-- * Determinate the UID of the master of a pet, if possible.         *
-- ********************************************************************
function Root.Unit.GetPetMasterUID(petUID)
    if ( not petUID ) then
        return nil;
    end
    
    -- First obvious check
    if UnitIsUnit("pet", petUID) or UnitIsUnit("vehicle", petUID) then
        return "player";
    end

    -- Now check the raid/party
    local i, baseUID, total;
    if ( GetNumRaidMembers() > 0 ) then
        baseUID = "raid";
        total = GetNumRaidMembers();
elseif ( GetNumPartyMembers() > 0 ) then
        baseUID = "party";
        total = GetNumPartyMembers();
  else
        total = 0;
    end
    for i=1, total do
        if ( UnitIsUnit(baseUID.."pet"..i, petUID) ) then
            return baseUID..i;
        end
    end

    return nil;
end

-- ********************************************************************
-- * Root -> Unit -> ResolveAffiliation(uid)                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> uid: the unit parsed.                                         *
-- ********************************************************************
-- * Resolve the affiliation of a given unit.                         *
-- ********************************************************************
function Root.Unit.ResolveAffiliation(uid)
    if ( not affiliations ) then return; end

    local guid = UnitGUID(uid);
    if ( affiliations[guid] ) then
        -- Already resolved this unit.
        -- However, we will recompute if the unit is not a partner: it could have become one in the meantime.
        if ( affiliations[guid].partner ) then
            return;

      else

            Root.Table.Recycle(affiliations[guid]);
        end
    end

    local isPlayer = UnitIsPlayer(uid);

    local classToken = select(2, UnitClass(uid));



    -- If the unit is a player, we only proceed if we can get its class info, elsewise we will retry later.
    if ( isPlayer ) and ( not classToken ) then return; end



    local info = Root.Table.Alloc();
    info.name = UnitName(uid);

    if ( UnitInParty(uid) or UnitInRaid(uid) or UnitIsUnit(uid, "player") ) then
        -- Unit is affiliated with us.
        info.partner = true;
  else
        info.partner = false;
    end

    if ( isPlayer ) then
        -- This unit is a player.
        info.type = "PLAYER";
        info.class = classToken;
        info.master = nil;
  else
        -- This unit could be a pet.
        local masterUID = Root.Unit.GetPetMasterUID(uid);
        if ( masterUID ) then
            -- It is indeed a pet.
            info.type = "PET";
            info.class = "PET";
            info.master = UnitGUID(masterUID);

            if ( UnitInParty(masterUID) or UnitInRaid(masterUID) or UnitIsUnit(masterUID, "player") ) then
                -- The master is affiliated with us, so we are affiliated with the pet.
                info.partner = true;
            end
      else
            -- Likely to be a normal NPC, or a guardian.
            info.type = "NPC";
            info.class = "NPC";
            info.master = nil;
        end
    end


    affiliations[guid] = info;

    -- Note: this function is bad for handling treants / spirit wolves.
end

-- ********************************************************************
-- * Root -> Unit -> GetAffiliation(guid)                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> guid: the GUID of the unit queried.                           *
-- ********************************************************************
-- * Retrieve the affiliation of a given unit.                        *
-- * Return isPartner, type, name, class or master                    *
-- ********************************************************************
function Root.Unit.GetAffiliation(guid)
    if ( not affiliations ) or ( not affiliations[guid] ) then
        return false, "UNKNOWN", UNKNOWN, nil;
    end
    local info = affiliations[guid];
    if ( info.type == "PLAYER" ) then
        return info.partner, info.type, info.name, info.class;
  else
        return info.partner, info.type, info.name, info.master;
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

Root.Unit.OnUpdate = function(self, elapsed)
    -- Mouseover change polling ourself, 'cause the mouseover event does not trigger when the mouseover unit is lost.
    local mouseoverGUID = UnitGUID("mouseover") or "none";
    if ( self.mouseoverGUID ~= mouseoverGUID ) then
        self.mouseoverGUID = mouseoverGUID;
        Root.Unit.RebuildList();
    end

    -- Periodic unit list rebuilding regardless of events occuring.
    if GetTime() > (self.nextUpdate or 0) then
        Root.Unit.RebuildList();
    end

    if GetTime() > (self.nextDisconnectCheck or 0) then
        Root.Unit.CheckDisconnect();
    end
end;

Root.Unit.OnEnterWorld = function(self)
    if ( affiliations ) then
        Root.Table.Recycle(affiliations, true);
    end
    affiliations = Root.Table.Alloc();
end
