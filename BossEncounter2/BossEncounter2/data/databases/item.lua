local Root = BossEncounter2;

Root.ItemDatabase = { };

-- --------------------------------------------------------------------
-- **                          Database                              **
-- --------------------------------------------------------------------

local itemTypes = {
    -- Only provide types that are useful for the mod.

    ["enUS"] = {
        -- Subtypes

        ["Cloth"] = "CLOTH",
        ["Leather"] = "LEATHER",
        ["Mail"] = "MAIL",
        ["Plate"] = "PLATE",

        ["Shields"] = "SHIELDS",
        ["Librams"] = "LIBRAMS",
        ["Idols"] = "IDOLS",
        ["Totems"] = "TOTEMS",
        ["Sigils"] = "SIGILS",
    },
    ["frFR"] = {
        -- Subtypes

        ["Tissu"] = "CLOTH",
        ["Cuir"] = "LEATHER",
        ["Mailles"] = "MAIL",
        ["Plaques"] = "PLATE",

        ["Bouclier"] = "SHIELDS",
        ["Librams"] = "LIBRAMS",
        ["Idoles"] = "IDOLS",
        ["Totems"] = "TOTEMS",
        ["Cachets"] = "SIGILS",
    },
}

local proficiency = {
    ["LEATHER"] = {
        ["DRUID"] = true,
        ["ROGUE"] = true,

        -- Not optimal users
        ["HUNTER"] = true,
        ["SHAMAN"] = true,
        ["DEATHKNIGHT"] = true,
        ["WARRIOR"] = true,
        ["PALADIN"] = true,
    },
    ["MAIL"] = {
        ["HUNTER"] = true,
        ["SHAMAN"] = true,

        -- Not optimal users
        ["DEATHKNIGHT"] = true,
        ["WARRIOR"] = true,
        ["PALADIN"] = true,
    },
    ["PLATE"] = {
        ["DEATHKNIGHT"] = true,
        ["WARRIOR"] = true,
        ["PALADIN"] = true,
    },

    ["SHIELDS"] = {
        ["SHAMAN"] = true,
        ["WARRIOR"] = true,
        ["PALADIN"] = true,
    },
    ["LIBRAMS"] = {
        ["PALADIN"] = true,
    },
    ["IDOLS"] = {
        ["DRUID"] = true,
    },
    ["TOTEMS"] = {
        ["SHAMAN"] = true,
    },
    ["SIGILS"] = {
        ["DEATHKNIGHT"] = true,
    },
};

-- --------------------------------------------------------------------
-- **                          Functions                             **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> ItemDatabase -> GetType(itemType)                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> itemType: the localized item type.                            *
-- ********************************************************************
-- * Unlocalize an item type string into a uppercase format.          *
-- ********************************************************************

function Root.ItemDatabase.GetType(itemType)
    local localeTable = itemTypes[GetLocale()];
    if ( localeTable ) then
        if ( localeTable[itemType] ) then return localeTable[itemType]; end
    end
    return "UNKNOWN";
end

-- ********************************************************************
-- * Root -> ItemDatabase -> IsProbablyUsable(itemLink, class)        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> itemType: the item link examined.                             *
-- * >> class: the UNLOCALIZED class name.                            *
-- ********************************************************************
-- * Determinate if the item is PROBABLY usable by the given class.   *
-- * This does NOT check the following:                               *
-- * => class restrictions                                            *
-- * => weapons proficiencies                                         *
-- * => gimmick items                                                 *
-- * As such, the main word is PROBABLY: this function is not an      *
-- * exhaustive check and the user should not rely on it              *
-- * to avoid errors while distributing loot.                         *
-- ********************************************************************

function Root.ItemDatabase.IsProbablyUsable(itemLink, class)
    local itemSubType = select(7, GetItemInfo(itemLink));
    itemSubType = Root.ItemDatabase.GetType(itemSubType);

    if ( itemSubType ) and ( proficiency[itemSubType] ) then
        if ( not proficiency[itemSubType][class] ) then return false; end
    end
    return true;
end