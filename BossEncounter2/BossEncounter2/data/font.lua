local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                            Font data                           **
-- --------------------------------------------------------------------

local STRING_MODELS = {
    ["SmallYellow"] = {
        inherits = "GameFontNormalSmall",
    },
    ["SmallWhite"] = {
        inherits = "GameFontHighlightSmall",
    },
    ["NormalYellow"] = {
        inherits = "GameFontNormal",
    },
    ["NormalWhite"] = {
        inherits = "GameFontHighlight",
    },
    ["Big"] = {
        inherits = "NumberFontNormalHuge",
    },
    ["Visible"] = {
        inherits = "SubZoneTextFont",
    },
};

-- --------------------------------------------------------------------
-- **                          Font functions                        **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> CreateFontString(owner, layer, base[, height,            *
-- *                          justifyH, justifyV])                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> owner: the frame that will own the font string.               *
-- * >> layer: the layer that will receive the font string.           *
-- * >> base: the base font model to use. See above.                  *
-- * The following arguments are optionnal:                           *
-- * >> height: the height of the font.                               *
-- * >> justifyH/V: the horizontal/vertical justifications.           *
-- ********************************************************************
-- * Create a font string using a common font pool.                   *
-- ********************************************************************

function Root.CreateFontString(owner, layer, base, height, justifyH, justifyV)
    local info = STRING_MODELS[base];
    if ( not info ) then return nil; end

    local fontString = owner:CreateFontString(nil, layer or "ARTWORK", info.inherits);

    if ( height ) then fontString:SetTextHeight(height); end
    fontString:SetJustifyH(justifyH or "MIDDLE");
    fontString:SetJustifyV(justifyV or "MIDDLE");

    return fontString;
end