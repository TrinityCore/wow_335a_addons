local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["AddWindowRowFont"] = { };
local AddWindowRowFont = Widgets["AddWindowRowFont"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local FONT_TEXTURE = Root.folder.."gfx\\AddBarsDigits";
local TEXTURE_WIDTH = 256;

local FONT_MAP = {
    ["0"] =  0,
    ["1"] =  1,
    ["2"] =  2,
    ["3"] =  3,
    ["4"] =  4,
    ["5"] =  5,
    ["6"] =  6,
    ["7"] =  7,
    ["8"] =  8,
    ["9"] =  9,
    ["K"] = 10,
    ["M"] = 11,
    ["?"] = 12,
    ["/"] = 13,
    ["%"] = 14,
};

local FONT_OFFSET = {
    ["default"] = 16,
    ["/"] = 8,
    ["%"] = 18,
};

local TEXTURE_CHUNK = FONT_OFFSET["default"] / TEXTURE_WIDTH;

local COMPRESS_CHAR = { "K", "M" };

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:SetText(text[, scale, r, g, b])                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row font.                                *
-- * >> text: what to display. Nil will hide the frame.               *
-- * >> scale: the scale to use. Default 1.                           *
-- * >> r, g, b: the color of the text. Default white.                *
-- ********************************************************************
-- * Displays a special font for HP figures etc. into an add row.     *
-- ********************************************************************
local function SetText(self, text, scale, r, g, b)
    text = tostring(text or "");
    if ( #text == 0 ) then
        self:Hide();
        return;
    end

    local i, texture, car, map, carSize, offset, size;

    -- Free all textures to rebuild the text.

    for i=#self.usedTextures, 1, -1 do
        texture = self.usedTextures[i];
        texture:Hide();
        tinsert(self.freeTextures, texture);
        tremove(self.usedTextures, i);
    end

    -- Build the text.

    offset = 0;
    size = 0;

    for i=1, #text do
        car = string.sub(text, i, i);
        map = FONT_MAP[car];
        if ( map ) then
            carSize = FONT_OFFSET[car] or FONT_OFFSET["default"];
            size = size + carSize;

            texture = self:GetFreeTexture();
            texture:SetTexCoord(TEXTURE_CHUNK * map, TEXTURE_CHUNK * (map+1), 0, 1);
            texture:SetPoint("LEFT", self, "LEFT", offset, 0);
            texture:SetVertexColor(r or 1, g or 1, b or 1);
            texture:Show();

            offset = offset + carSize;
      else
            -- Unknown character. Do not display.
        end
    end

    self:SetWidth(size);
    self:SetHeight(16);
    self:SetScale(scale or 1);
    self:Show();
end

-- ********************************************************************
-- * self:GetFreeTexture()                                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row font.                                *
-- ********************************************************************
-- * Get a free texture.                                              *
-- ********************************************************************
local function GetFreeTexture(self)
    local t = self.freeTextures[1];
    if ( t ) then
        tremove(self.freeTextures, 1);
  else
        t = self:CreateTexture(nil, "ARTWORK");
        t:ClearAllPoints();
        t:SetWidth(16);
        t:SetHeight(16);
        t:SetTexture(FONT_TEXTURE);
    end
    tinsert(self.usedTextures, t);
    return t;
end

-- ********************************************************************
-- * self:SetNumericText(text, availableWidth[, scale,                *
-- *                     r, g, b, suffix])                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row font.                                *
-- * >> text: what to display.                                        *
-- * >> availableWidth: the width available (in px) to display text.  *
-- * >> scale: the scale to use. Default 1.                           *
-- * >> r, g, b: the color of the text. Default white.                *
-- * >> suffix: the suffix string to append at the end of the string. *
-- ********************************************************************
-- * Displays a numeric value, reducing its length with "K" and "M"   *
-- * if necessary.                                                    *
-- ********************************************************************
local function SetNumericText(self, text, availableWidth, scale, r, g, b, suffix)
    if type(text) ~= "number" then return; end
    suffix = suffix or "";

    local maxDigits = min(6, math.floor(availableWidth / (16 * scale)));

    local step = 0;
    local msg = tostring(text);
    while ( #msg > maxDigits ) and ( step < #COMPRESS_CHAR ) do
        step = step + 1;
        text = math.floor(text / 1000 + 0.5);
        msg = tostring(text)..COMPRESS_CHAR[step];
    end

    if ( #msg <= maxDigits ) then self:SetText(msg..suffix, scale, r, g, b); end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function AddWindowRowFont.OnLoad(self)
    -- Properties

    -- Methods
    self.SetText = SetText;
    self.GetFreeTexture = GetFreeTexture;
    self.SetNumericText = SetNumericText;

    -- Children
    self.usedTextures = { };
    self.freeTextures = { };

    -- Initial state
    self:Hide();
end