local Root = BossEncounter2;

local Distance = Root.GetOrNewModule("Distance");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- A module that provides distance services while in combat.

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local scaleByID = {
    -- Note: Sub-tables indexed by number refer to the floor number.

    -- Zones to debug the system
    ["DALARAN"] = {
        [1] = 774, -- Surface
        [2] = 524, -- Sub-level
    },

    -- Raids which support the map distance->real distance system
    ["NAXXRAMAS"] = {
        [1] = 1018, -- Abomination zone
        [2] = 1018, -- Spider zone
        [3] = 1117, -- Military zone
        [4] = 1117, -- Pest zone
        [5] = 1927, -- Central zone
        [6] =  610, -- Final zone
    },
    ["ULDUAR"] = {
        [1] = 3060, -- The big courtyard
        [2] =  623, -- Antechamber
        [3] = 1237, -- Guardians
        [4] =  848, -- Yogg prison
        [5] = 1460, -- Spark of Imagination
        [6] =  000, -- Algalon
    },
    ["THEARGENTCOLISEUM"] = {
        [1] = 344,  -- Surface
        [2] = 689,  -- Sub-level
    },
    ["ICECROWNCITADEL"] = {
        [1] = 1260, -- Lower level
        [2] = 1000, -- Gunship floor
        [3] =  180, -- Saurfang floor
        [4] =  720, -- Sindragosa floor
        [5] = 1070, -- Higher floors
        [6] = 0000,
        [7] =  273, -- The Frozen Throne
        [8] = 0000,
    },
    ["MALYGOS"] = 0, -- TODO
    ["THEOBSIDIANSANCTUM"] = 1082,
    ["VAULTOFARCHAVON"] = 842,

    -- WotLK instances which could use the system
    ["THENEXUS"] = 987,
    ["UTGARDKEEP"] = 650, -- TODO: check the index
    ["AHNKAHET"] = 0, -- TODO
    ["HALLSOFLIGHTNING"] = 659,
    ["ULDUAR77"] = 857, -- This is Halls of Stone
    ["DRAKTHARONKEEP"] = 577, -- TODO: Check the index! Might mismatch.
    ["PITOFSARON"] = 1432,

    -- Raids for which the system cannot be used:
    -- Pre-BC
    -- BC
    -- Onyxia (lack of map even though the raid has been remade).
};

Distance.meterScale = 0;
Distance.determinating = false;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Distance:Refresh()                                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Refresh the distance system to make sure current map scale       *
-- * is loaded.                                                       *
-- ********************************************************************

Distance.Refresh = function(self)
    SetMapToCurrentZone();

    self.zone = strupper(GetMapInfo() or "");

    local ID = self.zone;

    self.zoneID = ID;

    local level = GetCurrentMapDungeonLevel();
    if DungeonUsesTerrainMap() then
        -- level = level - 1;
    end
    level = max(1, level);

    local scaleInfo = scaleByID[ID] or nil;
    if type(scaleInfo) == "number" then
        self.meterScale = scaleInfo;
elseif type(scaleInfo) == "table" then
        self.meterScale = scaleInfo[level] or 0;
  else
        self.meterScale = 0;
    end

    if ( self.meterScale > 0 ) then
        Root.Debug(string.format("Zone changed! Zone: %s, ID: %s, Floor: %d, Scale: %.4f", self.zone, ID, level, self.meterScale));
  else
        Root.Debug(string.format("Unknown scale for zone! Zone: %s, ID: %s, Floor: %d", self.zone, ID, level));
    end
end

-- ********************************************************************
-- * Distance:Get(unit, otherUnit, noMapEstimation)                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> unit, otherUnit: the two units that are checked.              *
-- * >> noMapEstimation: if set, no map estimation will be allowed.   *
-- ********************************************************************
-- * Determinate the distance between two units. The map estimation   *
-- * allows a wider range of results, but can only be used with 2     *
-- * friendly units. If the map estimation is not allowed, one of the *
-- * two units must be the player himself.                            *
-- * The result is either nil or a value in yards.                    *
-- ********************************************************************

Distance.Get = function(self, unit, otherUnit, noMapEstimation)
    otherUnit = otherUnit or "player";
    mapDistance = Root.GetUnitMapDistance(unit, otherUnit);

    if (mapDistance < 50000 and (not noMapEstimation) and (self.meterScale > 0)) then
        return math.floor(self.meterScale * mapDistance * 10 + 0.5) / 10; -- 1-digit floating precision.
  else
        -- Fall back to the standard, approximate way, always involving the local player.
        if ( unit == "player" ) then
            return Root.GetDistance(otherUnit);
    elseif ( otherUnit == "player" ) then
            return Root.GetDistance(unit);
      else
            return nil;
        end
    end
end

-- ********************************************************************
-- * Distance:Determinate(spellId)                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> unit, otherUnit: the two units that are checked.              *
-- * >> spellId: the ID of the spell used for the estimation.         *
-- ********************************************************************
-- * Starts a process to determinate empirically the meter scale of   *
-- * the current map. SpellID works well with buff/healing spells.    *
-- ********************************************************************

Distance.Determinate = function(self, spellId)
    local guid = UnitGUID("target");
    if ( self.determinating ) or ( not guid ) then
        return false;
    end

    self.targetGUID = guid;
    self.spellName, _, _, _, _, _, _, _, self.spellRange = GetSpellInfo(spellId);
    self.phase = "outOfRange";

    if ( not self.spellRange ) then
        return false;
    end

    self.determinating = true;
    return true;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

Distance.OnEnterWorld = function(self)
    self:Refresh();
end

Distance.OnZoneChanged = function(self)
    self:Refresh();
end

Distance.OnUpdate = function(self)
    if ( self.determinating ) then
        local uid = Root.Unit.GetUID(self.targetGUID);
        if ( uid ) then
            local inRange = IsSpellInRange(self.spellName, uid);
            if ( inRange == 0 ) and ( self.phase == "outOfRange" ) then
                self.phase = "inRange";
            end
            if ( inRange == 1 ) and ( self.phase == "inRange" ) then
                self.determinating = false;

                local mapDistance = Root.GetUnitMapDistance("player", uid);
                if ( mapDistance < 50000 ) and ( mapDistance > 0 ) then
                    local mapScale = self.spellRange / mapDistance;

                    Root.Print(string.format("Map distance between you and the unit: %.5f for %.2f meters => meter scale is %.2f", mapDistance, self.spellRange, mapScale));
                end
            end
        end
    end
end
