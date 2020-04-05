local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                          Distance data                         **
-- --------------------------------------------------------------------

-- Input here a list of common spells and items ID that are useful to check the distance.
-- For spells, do not input each rank of the spell, only one is sufficient.
-- Please do not enter spells that for some reason, have a varying range among ranks or spells/items that do not require one and only one target.
-- Also do not enter spells/items that target yourself, as it wouldn't be useful to determine your distance with someone else.

local distanceRules = {
    FRIEND = {
        SPELL = {
             2050, -- Priest heal (lesser heal)
             5185, -- Druid heal (healing touch)
              331, -- Shaman heal (healing wave)
              635, -- Paladin heal (holy light)
              136, -- Hunter heal (mend pet)

             1243, -- Priest buff (pw:f)
             1126, -- Druid buff (motw)
              131, -- Shaman buff (water breathing)
            19740, -- Paladin buff (bom)
             1459, -- Mage buff (dampen magic)
             5697, -- Warlock buff (unending breath)
             3411, -- Warrior buff (intervene)
        },
        ITEM = {
            1251, 2581, 3530, 3531, 6450, 6451, 8544, 8545, 14529, 14530, 21990, 21991, 34721, 34722, -- Bandages
        },
    },
    ENEMY = {
        SPELL = {
            585, 589, 605, 25596, -- Priest harmful spells (smite, sw:p, mind control, mind soothe)
            5176, 5211, 33786, 2908, 16979, -- Druid harmful spells and techs (wrath, bash, cyclone, soothe animal, feralcharge)
            403, 8042, 8050, 17364, -- Shaman harmful spells and techs (lb, earthshock, flameshock, stormstrike)
            20271, 879, 35395, -- Paladin harmful spells and techs (judgement, exorcism, crusaderstrike)
            1978, 2974, -- Hunter harmful spells and techs (serpentsting, wingclip)
            133, 116, 118, 2136, -- Mage harmful spells (fireball, frostbolt, polymorph, fireblast)
            686, 5782, -- Warlock harmful spells (shadowbolt, fear)
            53, 2094, 36554, -- Rogue harmful techs (backstab, blind, shadowstep)
            772, 100, -- Warrior harmful techs (rend, charge)
        },
        ITEM = {
            24268, 41509, -- Nets
        },
    },
};

local knownItemRanges = {
    [1251] = 15, -- Bandages common range

    [24268] = 25, -- Net
    [41509] = 25, -- Net


};

-- Each variation of bandage
knownItemRanges[2581]  = knownItemRanges[1251];
knownItemRanges[3530]  = knownItemRanges[1251];
knownItemRanges[3531]  = knownItemRanges[1251];
knownItemRanges[6450]  = knownItemRanges[1251];
knownItemRanges[6451]  = knownItemRanges[1251];
knownItemRanges[8544]  = knownItemRanges[1251];
knownItemRanges[8545]  = knownItemRanges[1251];
knownItemRanges[14529] = knownItemRanges[1251];
knownItemRanges[14530] = knownItemRanges[1251];
knownItemRanges[21990] = knownItemRanges[1251];
knownItemRanges[21991] = knownItemRanges[1251];
knownItemRanges[34721] = knownItemRanges[1251];
knownItemRanges[34722] = knownItemRanges[1251];

-- WARNING: do not put anything in the distanceScanner table: it is automatically filled up and updated.

local distanceScanner = { };
local lastAdjust = 0;

-- --------------------------------------------------------------------
-- **                        Distance functions                      **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> GetDistance(unit)                                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> unit: the unit with which you will be checked.                *
-- ********************************************************************
-- * Get a rough distance approximation between you and another unit. *
-- * At worst this function will return 50000 yds, never nil.         *
-- ********************************************************************
function Root.GetDistance(unit)
    local distance = 50000;

    if UnitIsUnit("player", unit) then return 0; end
    if not UnitIsVisible(unit) then return 50000; end

    if CheckInteractDistance(unit, 4) then
        distance = min(distance, 28);
    end
    if CheckInteractDistance(unit, 3) then
        distance = min(distance, 10);
    end

    local index, info;
    for index, info in ipairs(distanceScanner) do
        if ( info.target == "ENEMY" and UnitCanAttack("player", unit) ) or ( info.target == "FRIEND" and UnitCanAssist("player", unit) ) then
            if ( info.type == "SPELL" ) then
                if ( IsSpellInRange(info.name, unit) == 1 ) then
                    distance = min(distance, info.range);
                end

        elseif ( info.type == "ITEM" ) then
                if ( IsItemInRange(info.name, unit) == 1 ) then
                    distance = min(distance, info.range);
                end
            end
        end
    end

    return distance;
end

-- ********************************************************************
-- * Root -> SetupDistanceScanner()                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Set up the distance scanner according to the spells you know.    *
-- * Should be called (and recalled) whenever your spellbook changes. *
-- ********************************************************************
function Root.SetupDistanceScanner()
    local k;
    local reaction, categories;
    local category, id;
    local name, maxRange;

    for k in ipairs(distanceScanner) do distanceScanner[k] = nil; end

    for reaction, categories in pairs(distanceRules) do
        for category, ids in pairs(categories) do
            for _, id in pairs(ids) do
                name, maxRange = nil, nil;
                if ( category == "SPELL" ) then
                    name, _, _, _, _, _, _, _, maxRange = GetSpellInfo(id);

              elseif ( category == "ITEM" ) then
                    name, _, _, _, _, _, _, _, _, _ = GetItemInfo(id);
                    maxRange = knownItemRanges[id];
                end
                if ( name and maxRange and maxRange > 0 and maxRange < 50000 ) then
                    distanceScanner[#distanceScanner+1] = {
                        target = reaction,
                        type = category,
                        name = name,
                        range = math.floor(maxRange + 0.5),
                    };
                end
            end
        end
    end
end

-- ********************************************************************
-- * Root -> GetUnitMapDistance(unit, otherUnit)                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> unit: the first unit.                                         *
-- * >> otherUnit: the other unit.                                    *
-- ********************************************************************
-- * Get the map distance between 2 units (usually the player and X). *
-- * 50000 is returned if invalid.                                    *
-- ********************************************************************
function Root.GetUnitMapDistance(unit, otherUnit)
    if ((GetTime() - lastAdjust) > 1.0 ) then
        SetMapToCurrentZone();
        lastAdjust = GetTime();
    end

    local x1, y1 = GetPlayerMapPosition(unit);
    local x2, y2 = GetPlayerMapPosition(otherUnit);
    if ( x1 == 0 and y1 == 0 ) or ( x2 == 0 and y2 == 0 ) then
        -- One (or both) of the units has invalid coords.
        return 50000;
    end
    return Root.MapDistance(x1, y1, x2, y2);
end