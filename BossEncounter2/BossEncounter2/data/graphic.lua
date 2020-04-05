local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                         Graphic data                           **
-- --------------------------------------------------------------------

local RANK_TEXTURE = Root.folder.."gfx\\Rank";

local rankTexCoords = {
    ["S"] = {  0/256,  32/256, 0, 1},
    ["A"] = { 32/256,  64/256, 0, 1},
    ["B"] = { 64/256,  96/256, 0, 1},
    ["C"] = { 96/256, 128/256, 0, 1},
    ["D"] = {128/256, 160/256, 0, 1},
    ["E"] = {160/256, 192/256, 0, 1},
    ["-"] = {192/256, 228/256, 0, 1},
    ["?"] = Root.folder.."gfx\\QuestionMark",
};

local backdropLayouts = {
    ["TOOLTIP"] = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
        edgeSize = 16,
        tileSize = 16,
        tile = true,
        borderColor = {0.5, 0.5, 0.5, 1.0},
        color = {0.09, 0.09, 0.19, 0.5},
    },
    ["OPTION"] = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
        edgeSize = 16,
        tileSize = 16,
        tile = true,
        borderColor = {0.4, 0.4, 0.4, 1.0},
        color = {0.1, 0.1, 0.2, 0.5},
    },
    ["BUBBLE"] = {
        bgFile = Root.folder.."gfx\\HealthThresholdBubbleInside",
        edgeFile = Root.folder.."gfx\\HealthThresholdBubble",
        insets = { left = 16, right = 16, top = 16, bottom = 16 },
        edgeSize = 16,
        tileSize = 16,
        tile = true,
        borderColor = {1.0, 1.0, 1.0, 0.5},
        color = {1.0, 1.0, 1.0, 0.5},
    },
    ["BLUE"] = {
        bgFile = Root.folder.."gfx\\BlueFrameInside",
        edgeFile = Root.folder.."gfx\\BlueFrame",
        insets = { left = 16, right = 16, top = 16, bottom = 16 },
        edgeSize = 16,
        tileSize = 16,
        tile = true,
        borderColor = {1.0, 1.0, 1.0, 1.0},
        color = {1.0, 1.0, 1.0, 0.8},
    },
};

local CLASS_BUTTONS = {
	["WARRIOR"]	= {0, 0.25, 0, 0.25},
	["MAGE"]	= {0.25, 0.49609375, 0, 0.25},
	["ROGUE"]	= {0.49609375, 0.7421875, 0, 0.25},
	["DRUID"]	= {0.7421875, 0.98828125, 0, 0.25},
	["HUNTER"]	= {0, 0.25, 0.25, 0.5},
	["SHAMAN"]	= {0.25, 0.49609375, 0.25, 0.5},
	["PRIEST"]	= {0.49609375, 0.7421875, 0.25, 0.5},
	["WARLOCK"]	= {0.7421875, 0.98828125, 0.25, 0.5},
	["PALADIN"]	= {0, 0.25, 0.5, 0.75},
	["DEATHKNIGHT"]	= {0.25, 0.49609375, 0.5, 0.75},
};

local localizedTextures = {
    ["NEWRECORD"] = {
        file = "NewRecord",
        realWidth = 128,
        realHeight = 16,
        default = 113,
        frFR = 121,
    },
};

-- --------------------------------------------------------------------
-- **                       Graphic functions                        **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> PctToPx(axis, percentage)                                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> axis: either "x" or "y". "X" and "Y" works too.               *
-- * >> percentage: the percentage to grab the pixel equivalence for. *
-- ********************************************************************
-- * Grab the amount of pixels that a percentage of one of the screen *
-- * axis does. The value returned will increase as the computer's    *
-- * resolution does of course. Be careful, the value is relative to  *
-- * UIParent.                                                        *
-- ********************************************************************
function Root.PctToPx(axis, percentage)
    if type(percentage) == "string" then
        percentage = tonumber(percentage);
    end
    if type(percentage) ~= "number" then return 0; end
    if ( axis == "x" or axis == "X" ) then
        return percentage * UIParent:GetWidth();
elseif ( axis == "y" or axis == "Y" ) then
        return percentage * UIParent:GetHeight();
  else
        error("PctToPx: unknown axis.", 0);
        return;
    end
end

-- ********************************************************************
-- * Root -> PxToPct(axis, pixel)                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> axis: either "x" or "y". "X" and "Y" works too.               *
-- * >> pixel: the pixel to grab the percentage equivalence for.      *
-- ********************************************************************
-- * Grab the percentage an amount of pixels that one of the screen   *
-- * axis does. The value returned will increase as the computer's    *
-- * resolution does of course. Be careful, the value is relative to  *
-- * UIParent.                                                        *
-- ********************************************************************
function Root.PxToPct(axis, pixel)
    if type(pixel) == "string" then
        pixel = tonumber(pixel);
    end
    if type(pixel) ~= "number" then return 0; end
    if ( axis == "x" or axis == "X" ) then
        return pixel / UIParent:GetWidth();
elseif ( axis == "y" or axis == "Y" ) then
        return pixel / UIParent:GetHeight();
  else
        error("PxToPct: unknown axis.", 0);
        return;
    end
end

-- ********************************************************************
-- * Root -> SetRankOnTexture(texture, rank)                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> texture: the texture adjusted.                                *
-- * >> rank: the rank to show on the texture.                        *
-- ********************************************************************
-- * Apply the correct rank texture on a texture object.              *
-- ********************************************************************
function Root.SetRankOnTexture(texture, rank)
    if not rank then
        texture:Hide();
        return;
    end

    local coords = rankTexCoords[rank];
    if not coords then return; end

    if type(coords) == "table" then
        texture:SetTexture(RANK_TEXTURE);
        texture:SetTexCoord(unpack(coords));
elseif type(coords) == "string" then
        texture:SetTexture(coords);
        texture:SetTexCoord(0, 1, 0, 1);
    end
    texture:Show();
end

-- ********************************************************************
-- * Root -> RotateTexture(texture, angle)                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> texture: the desired texture.                                 *
-- * >> angle: the rotation angle.                                    *
-- ********************************************************************
-- * Make a texture rotate around its center.                         *
-- ********************************************************************
function Root.RotateTexture(texture, angle)
    local c, s = cos(angle), sin(angle);
    texture:SetTexCoord(0.5-s, 0.5+c, 0.5+c, 0.5+s, 0.5-c, 0.5-s, 0.5+s, 0.5-c);
end

-- ********************************************************************
-- * Root -> SetBackdrop(frame, layout)                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> frame: the frame that has its backdrop changed.               *
-- * >> layout: the layout to use for the backdrop. See above.        *
-- ********************************************************************
-- * Quickly change a frame's backdrop according to presets.          *
-- ********************************************************************
function Root.SetBackdrop(frame, layout)
    local info = backdropLayouts[layout];
    if ( not info ) then return; end

    frame:SetBackdrop(info);
    frame:SetBackdropBorderColor(unpack(info.borderColor));
    frame:SetBackdropColor(unpack(info.color));
end

-- ********************************************************************
-- * Root -> SetIcon(texture, icon)                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> texture: the texture on which the icon is displayed.          *
-- * >> icon: either a class name or a raid target ID.                *
-- * 0 and nil can be passed to hide the texture as well.             *
-- ********************************************************************
-- * Quick method of putting an icon on a texture.                    *
-- ********************************************************************
function Root.SetIcon(texture, icon)
    if type(icon) == "string" then
        texture:SetTexture("Interface\\WorldStateFrame\\Icons-Classes");
        texture:SetTexCoord(unpack(CLASS_BUTTONS[icon]));
        texture:Show();

elseif type(icon) == "number" and icon > 0 then
        texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
        SetRaidTargetIconTexture(texture, icon);
        texture:Show();
  else
        texture:Hide();
    end
end

-- ********************************************************************
-- * Root -> TextGradient(text, r, g, b, lR, lG, lB, lightPosition)   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> text: the text which gets colorized.                          *
-- * >> r, g, b: the base color of the text.                          *
-- * >> lR, lG, lB: the color of the text when it is fully exposed    *
-- * to the light. The light has an AoE of 50% of text's length.      *
-- * >> lightPosition: the position of the light. This value is in %, *
-- * with 0 being on the first char and 1 on the last char.           *
-- * Light will only modify text color if it's between -0.5 and 1.5.  *
-- ********************************************************************
-- * Colorize a text char per char using a gradient.                  *
-- ********************************************************************
function Root.TextGradient(text, r, g, b, lR, lG, lB, lightPosition)
    local length = #text;
    local newChar;
    local newText = "";
    local i, lightPower;
    local cR, cG, cB;
    for i=1, length do
        if ( length == 1 ) then
            lightPower = 0;
      else
            local fullLight = (i-1) / (length-1);
            local delta = math.abs( lightPosition - fullLight );
            lightPower = max(0, 1.00 - delta / 0.50);
        end
        cR = r + ( lR - r ) * lightPower;
        cG = g + ( lG - g ) * lightPower;
        cB = b + ( lB - b ) * lightPower;
        newChar = Root.GetColorCode(cR, cG, cB)..string.sub(text, i, i);
        newText = newText..newChar;
    end
    return newText;
end

-- ********************************************************************
-- * Root -> GetLocalizedTextureInfo(textureName)                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> textureName: the texture internal name. See the table above.  *
-- ********************************************************************
-- * Get infos allowing you to handle and get the right localized     *
-- * texture. Return:                                                 *
-- *     filename, width, realWidth, height.                          *
-- ********************************************************************
function Root.GetLocalizedTextureInfo(textureName)
    local t = localizedTextures[textureName];
    if ( not t ) then return "", 0; end

    local filename = t.file or "";
    local suffix = "";
    local width = t.default or 0;
    local locale = GetLocale();
    
    if t[locale] then
        width = t[locale];
        suffix = "-"..locale;
    end

    return Root.folder.."gfx\\"..filename..suffix, width, t.realWidth or 0, t.realHeight or 0;
end

-- ********************************************************************
-- * Root -> SetLocalizedTexture(texture, textureName)                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> texture: the texture object set.                              *
-- * >> textureName: the texture internal name. See the table above.  *
-- ********************************************************************
-- * Display a localized texture.                                     *
-- ********************************************************************
function Root.SetLocalizedTexture(texture, textureName)
    local filename, width, realWidth, height = Root.GetLocalizedTextureInfo(textureName);

    texture.t_usedWidth = width;
    texture.t_realWidth = realWidth;
    texture.t_height = height;
    texture:SetTexture(filename);
    texture:SetTexCoord(0, width/realWidth, 0, 1);
    texture:SetWidth(width);
    texture:SetHeight(height);
end