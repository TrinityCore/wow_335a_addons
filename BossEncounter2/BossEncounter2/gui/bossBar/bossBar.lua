local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");

Widgets["BossBar"] = { };
local BossBar = Widgets["BossBar"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

local colorLayers = {
    [1] = {1.00, 0.00, 0.00, 1.00},
    [2] = {1.00, 1.00, 0.00, 1.00},
    [3] = {0.00, 1.00, 0.00, 1.00},
    [4] = {0.00, 1.00, 1.00, 1.00},
    [5] = {0.00, 0.00, 1.00, 1.00},
    [6] = {1.00, 0.00, 1.00, 1.00},
    [7] = {1.00, 0.50, 0.00, 1.00},
    [8] = {0.50, 1.00, 0.00, 1.00},
    [9] = {1.00, 1.00, 1.00, 1.00},
};

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local EDGE_TEXTURE = Root.folder.."gfx\\BossBarEdge";
local TILE_TEXTURE = Root.folder.."gfx\\BossBarTile";
local BOSSTAG_TEXTURE = Root.folder.."gfx\\BossTag";
local ADDTAG_TEXTURE = Root.folder.."gfx\\AddTag";
local ALLYTAG_TEXTURE = Root.folder.."gfx\\AllyTag";
local QUESTIONMARK_TEXTURE = Root.folder.."gfx\\QuestionMark";

local WIDTH_ADJUSTMENT_RATE = 256; -- Per sec.

-- In sec.
local OPEN_TIME = 0.70;
local CLOSE_TIME = 0.40;

local TITLE_FADE_DURATION = 0.500; -- In sec.
local TEXT_FADE_DURATION  = 0.500; -- In sec.

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display([x, y, fixedWidth, scale])                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar.                                           *
-- * >> x: position of the X center of the boss bar (Between 0-1).    *
-- * >> y: position of the Y center of the boss bar (Between 0-1).    *
-- * >> fixedWidth: if set, the boss bar will have a fixed width and  *
-- * will ignore calls to ChangeWidth method. Passing nil to this     *
-- * parameter will lift this restriction.                            *
-- * >> scale: the scale of the boss bar.                             *
-- ********************************************************************
-- * Starts displaying the boss bar.                                  *
-- * N.B: x/y/scale parameters take precedence before                 *
-- * anchor positions.                                                *
-- ********************************************************************
local function Display(self, x, y, fixedWidth, scale)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    local aX, aY, aScale, aEnabled = Anchor:GetAnchorInfo(self);
    if ( not aEnabled ) then return; end

    self.status = "OPENING";
    self.timer = OPEN_TIME;

    self.centerX = x or aX or 0.5;
    self.centerY = y or aY or 0.3;
    self.scale = scale or aScale or 1;

    -- Set current width (not changing target width !) to 64.
    self.width = 64;
    self:SetWidth(self.width);
    self.CurrentLayer:Update();
    self.NextLayer:Update();

    if ( fixedWidth ) then
        self.fixedWidth = false;
        self:ChangeWidth(fixedWidth);
        self.fixedWidth = true;
    end

    self.titleAlpha = 0.00;
    self.textAlpha = 0.00;

    self:Show();
    BossBar.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- * >> atOnce: if set, the boss bar will be hidden instantly.        *
-- ********************************************************************
-- * Stops displaying the boss bar.                                   *
-- * Note that this WILL NOT stop the driver. As such, it can be used *
-- * to temporarily remove the bar then display it again with the     *
-- * :Display method. If you want to completely release the bar, do   *
-- * not forget to set the GUID watched by the driver to "none".      *
-- ********************************************************************
local function Remove(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "OPENING" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        self.status = "CLOSING";
        self.timer = CLOSE_TIME;
    end
end

-- ********************************************************************
-- * self:ChangeWidth(width, atOnce)                                  *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- * >> width: the new desired width.                                 *
-- * >> atOnce: if set, the boss bar will update instantly.           *
-- ********************************************************************
-- * Change at once the width of a boss bar.                          *
-- ********************************************************************
local function ChangeWidth(self, width, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.fixedWidth ) then return; end

    self.targetWidth = min(384, max(64, width));

    if ( atOnce ) then
        self.width = self.targetWidth;
        self:SetWidth(self.width);
        self.CurrentLayer:Update();
        self.NextLayer:Update();
    end
end

-- ********************************************************************
-- * self:ChangeValue(value)                                          *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- * >> value: the new desired value. Values greater than 1 will      *
-- * show new layers of differently colored bars to apparear above    *
-- * the lowest layer.                                                *
-- ********************************************************************
-- * Change at once the value of a boss bar.                          *
-- ********************************************************************
local function ChangeValue(self, value)
    if type(self) ~= "table" then return; end

    value = max(0, value);

    local nextLayer = min(#colorLayers, math.floor(value));
    local currentLayer = min(#colorLayers, nextLayer + 1);
    local currentLayerRemaining = value - math.floor(value);

    self.CurrentLayer:SetPortion(currentLayerRemaining);
    self.CurrentLayer:ChangeColor(unpack(colorLayers[currentLayer]));
    if ( nextLayer == 0 ) then
        self.NextLayer:SetPortion(0);
  else
        self.NextLayer:SetPortion(1);
        self.NextLayer:ChangeColor(unpack(colorLayers[nextLayer]));
    end
end

-- ********************************************************************
-- * self:GetDriver()                                                 *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- ********************************************************************
-- * Get the driver of the current boss bar. To make the boss bar     *
-- * works by itself, you need to call methods from its driver.       *
-- ********************************************************************
local function GetDriver(self)
    if type(self) ~= "table" then return; end

    return self.Driver;
end

-- ********************************************************************
-- * self:GetThresholdFrame()                                         *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- ********************************************************************
-- * Get the threshold frame of the current boss bar. This is the     *
-- * frame which handles health threshold tags and explanation bubble.*
-- ********************************************************************
local function GetThresholdFrame(self)
    if type(self) ~= "table" then return; end

    return self.ThresholdFrame;
end

-- ********************************************************************
-- * self:GetNumColorLayers()                                         *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- ********************************************************************
-- * Get the number of different color layers.                        *
-- ********************************************************************
local function GetNumColorLayers(self)
    if type(self) ~= "table" then return; end

    return #colorLayers;
end

-- ********************************************************************
-- * self:GetQuestionMarkStatus()                                     *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- ********************************************************************
-- * Get whether the question mark is displayed or not.               *
-- ********************************************************************
local function GetQuestionMarkStatus(self)
    if type(self) ~= "table" then return; end

    return self.questionMarkStatus;
end

-- ********************************************************************
-- * self:SetQuestionMarkStatus(state)                                *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- * >> state: whether to display it or not (false/true).             *
-- ********************************************************************
-- * Set whether the question mark is to be displayed or not.         *
-- ********************************************************************
local function SetQuestionMarkStatus(self, state)
    if type(self) ~= "table" then return; end

    self.questionMarkStatus = state;
end

-- ********************************************************************
-- * self:ChangeTitle(title)                                          *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- * >> title: the title of the boss bar. Generally the boss name.    *
-- ********************************************************************
-- * Set the title of the boss bar.                                   *
-- ********************************************************************
local function ChangeTitle(self, title)
    if type(self) ~= "table" then return; end

    self.titleString = title;
    self.titleAlpha = 0.00;
end

-- ********************************************************************
-- * self:ChangeText(text)                                            *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- * >> text: the text inside of the boss bar.                        *
-- ********************************************************************
-- * Set the text inside the boss bar (its health, % or Dead tag).    *
-- ********************************************************************
local function ChangeText(self, text)
    if type(self) ~= "table" then return; end

    self.textString = text;
end

-- ********************************************************************
-- * self:ChangeTag(tag)                                              *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- * >> tag: the tag to use ("BOSS", "ADD" or "ALLY").                *
-- ********************************************************************
-- * Change the tag at the left of the boss bar.                      *
-- ********************************************************************
local function ChangeTag(self, tag)
    if type(self) ~= "table" then return; end

    if ( tag == "BOSS" ) then
        self.bossTag:SetTexture(BOSSTAG_TEXTURE);
        self.bossTag:SetWidth(64);
        self.bossTag:SetHeight(16);

elseif ( tag == "ADD" ) then
        self.bossTag:SetTexture(ADDTAG_TEXTURE);
        self.bossTag:SetWidth(64);
        self.bossTag:SetHeight(16);

elseif ( tag == "ALLY" ) then
        self.bossTag:SetTexture(ALLYTAG_TEXTURE);
        self.bossTag:SetWidth(64);
        self.bossTag:SetHeight(16);
    end

    self.bossTag:Show();
end

-- ********************************************************************
-- * self:ChangeSymbol(id)                                            *
-- ********************************************************************
-- * >> self: the boss bar.                                           *
-- * >> id: the new symbol id. Put 0 or nil to clear it.              *
-- ********************************************************************
-- * Change the symbol next to the title. If you use a symbol, the    *
-- * text will have a slight offset to make room for it.              *
-- ********************************************************************
local function ChangeSymbol(self, id)
    if type(self) ~= "table" then return; end

    self.symbolID = id or 0;

    self.symbol:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
    SetRaidTargetIconTexture(self.symbol, self.symbolID);
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function BossBar.OnLoad(self)
    -- Children
    self.bossTag = self:CreateTexture(nil, "OVERLAY");
    self.bossTag:SetTexCoord(0, 1, 0, 1);
    self.bossTag:SetWidth(64);
    self.bossTag:SetHeight(16);
    self.bossTag:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 0);
    self.bossTag:Hide(); 

    self.questionMark = self:CreateTexture(nil, "OVERLAY");
    self.questionMark:SetTexture(QUESTIONMARK_TEXTURE);
    self.questionMark:SetTexCoord(0, 1, 0, 1);
    self.questionMark:SetWidth(24);
    self.questionMark:SetHeight(24);
    self.questionMark:SetPoint("CENTER", self, "CENTER", 0, 3);
    self.questionMark:Hide();

    self.NextLayer = CreateFrame("Frame", nil, nil, "BossEncounter2_BossBarLayerTemplate");
    self.CurrentLayer = CreateFrame("Frame", nil, nil, "BossEncounter2_BossBarLayerTemplate");
    self.ThresholdFrame = CreateFrame("Frame", nil, nil, "BossEncounter2_BossBarThresholdTemplate");
    self.NextLayer:Setup(self, 1);
    self.CurrentLayer:Setup(self, 2);
    self.ThresholdFrame:Setup(self, 3, 5);

    self.TextLayer = CreateFrame("Frame", nil, self);
    self.TextLayer:SetFrameLevel(self:GetFrameLevel() + 4);
    self.title = Root.CreateFontString(self.TextLayer, "OVERLAY", "NormalWhite", nil, "RIGHT", "BOTTOM");
    self.title:SetHeight(16);
    self.title:Hide();
    self.text = Root.CreateFontString(self.TextLayer, "OVERLAY", "NormalWhite", nil, "MIDDLE", "BOTTOM");
    self.text:SetHeight(16);
    self.text:Hide();
    self.symbol = self.TextLayer:CreateTexture(nil, "OVERLAY");
    self.symbol:SetWidth(16);
    self.symbol:SetHeight(16);
    self.symbol:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -8, 0);
    self.symbol:Hide(); 

    -- Backdrop
    local myBackdrop = { bgFile = TILE_TEXTURE,
                         edgeFile = EDGE_TEXTURE,
                         tileSize = 8,
                         edgeSize = 8,
                         tile = false,
                         insets = { left = 1, right = 2, top = 2, bottom = 7 } };
    self:SetBackdrop(myBackdrop);
    self:SetBackdropBorderColor(1.0, 1.0, 1.0, 1.0);
    self:SetBackdropColor(1.0, 1.0, 1.0, 1.0);

    -- Properties
    self.status = "STANDBY";
    self.timer = 0.000;
    self.questionMarkStatus = false;
    self.width = 64;
    self.targetWidth = 64;
    self.titleString = "";
    self.titleAlpha = 0.00;
    self.textString = "";
    self.textAlpha = 0.00;
    self.symbolID = 0;

    -- Methods
    self.Display = Display;
    self.Remove = Remove;
    self.ChangeWidth = ChangeWidth;
    self.ChangeValue = ChangeValue;
    self.GetDriver = GetDriver;
    self.GetThresholdFrame = GetThresholdFrame;
    self.GetNumColorLayers = GetNumColorLayers;
    self.GetQuestionMarkStatus = GetQuestionMarkStatus;
    self.SetQuestionMarkStatus = SetQuestionMarkStatus;
    self.ChangeTitle = ChangeTitle;
    self.ChangeText = ChangeText;
    self.ChangeTag = ChangeTag;
    self.ChangeSymbol = ChangeSymbol;

    self.Driver = CreateFrame("Frame", nil, nil, "BossEncounter2_BossBarDriverTemplate");
    self.Driver:Setup(self);

    -- Initial setup
    self:ChangeValue(0);
    self:ChangeTag("BOSS");
end

function BossBar.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    -- We implictly want the bar to shrink to 64 pixels length when shutting down, while preventing it from recentering itself around its center.
    local effectiveTargetWidth = 64;
    if ( self.status ~= "CLOSING" ) then
        effectiveTargetWidth = self.targetWidth;
        self.alignOffset = self.targetWidth/2;
    end

    -- Question mark handling. Forcefully hide it if the boss bar is not at its target width or is moving.
    if ( self.questionMarkStatus and self.status == "RUNNING" and self.width == effectiveTargetWidth ) then
        self.questionMark:Show();
  else
        self.questionMark:Hide();
    end

    -- Open/close
    if ( self.status == "OPENING" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then self.status = "RUNNING"; end
    end
    if ( self.status == "CLOSING" ) and ( self.width == effectiveTargetWidth ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then self:Remove(true); end
    end

    -- Positionning handling
    local x, y = self.centerX, self.centerY; -- If not moving.
    local outscreenY = 1.1;
    if ( self.centerY < 0.5 ) then outscreenY = -0.1; end

    if ( self.status == "OPENING" ) then
        y = outscreenY + ( self.centerY - outscreenY ) * (( 1 - self.timer / OPEN_TIME )^0.3);
elseif ( self.status == "CLOSING" ) then
        y = outscreenY + ( self.centerY - outscreenY ) * (( self.timer / CLOSE_TIME )^0.3);
    end

    -- Smooth width adjustment. We wait till boss bar is positionned before allowing sizing.
    local difference = effectiveTargetWidth - self.width;
    if ( difference ~= 0 and self.status ~= "OPENING" ) then
    if ( self.status ~= "CLOSING" or self.titleAlpha <= 0.00 ) then
        local speed = WIDTH_ADJUSTMENT_RATE * elapsed;
        if ( difference > 0 ) then
            self.width = min(effectiveTargetWidth, self.width + speed);
      else
            self.width = max(effectiveTargetWidth, self.width - speed);
        end
        self:SetWidth(self.width);
        self.CurrentLayer:Update();
        self.NextLayer:Update();
    end
    end

    -- Application on the frame
    local finalX, finalY = x * UIParent:GetWidth(), y * UIParent:GetHeight();
    self:ClearAllPoints();
    self:SetPoint("LEFT", UIParent, "BOTTOMLEFT", finalX / self.scale - self.alignOffset, finalY / self.scale);
    self:SetScale(self.scale);

    -- Title handling
    if ( self.status == "RUNNING" ) and ( self.width == effectiveTargetWidth ) then
        self.titleAlpha = min(1, self.titleAlpha + elapsed / TITLE_FADE_DURATION);
  elseif ( self.status ~= "RUNNING" ) then
        self.titleAlpha = max(0, self.titleAlpha - elapsed / TITLE_FADE_DURATION);
    end
    if ( self.titleAlpha > 0.00 ) and ( not self.questionMarkStatus ) then
        -- self.title:SetWidth(self.width - 72);
        self.title:SetText(self.titleString);
        self.title:ClearAllPoints();
        self.title:SetPoint("BOTTOMLEFT", self.bossTag, "BOTTOMRIGHT", 0, 0);
        if ( self.symbolID == 0 ) then
            self.title:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -8, 0);
            self.symbol:Hide();
      else
            self.title:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -26, 0);
            self.symbol:SetAlpha(self.titleAlpha);
            self.symbol:Show();
        end
        self.title:SetAlpha(self.titleAlpha);
        self.title:Show();
  else
        self.title:Hide();
        self.symbol:Hide();
    end

    -- Text handling
    if ( self.status == "RUNNING" ) and ( self.width == effectiveTargetWidth ) then
        self.textAlpha = min(1, self.textAlpha + elapsed / TEXT_FADE_DURATION);
  elseif ( self.status ~= "RUNNING" ) then
        self.textAlpha = max(0, self.textAlpha - elapsed / TEXT_FADE_DURATION);
    end
    if ( self.textAlpha > 0.00 ) and ( not self.questionMarkStatus ) then
        self.text:SetWidth(self.width - 32);
        self.text:SetText(self.textString);
        self.text:ClearAllPoints();
        self.text:SetPoint("CENTER", self, "CENTER", 0, 4);
        self.text:SetAlpha(self.textAlpha);
        self.text:Show();
  else
        self.text:Hide();
    end

    -- Health threshold handling

    if ( not self.questionMarkStatus ) and ( self.status == "RUNNING" ) and ( self.width == effectiveTargetWidth ) then
        self.ThresholdFrame:Show();
  else
        self.ThresholdFrame:Hide();
    end
end