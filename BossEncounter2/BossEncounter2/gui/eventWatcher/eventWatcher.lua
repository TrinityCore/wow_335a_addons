local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");

Widgets["EventWatcher"] = { };
local EventWatcher = Widgets["EventWatcher"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local TOP_TEXTURE = Root.folder.."gfx\\EventWatcherTop";
local BOTTOM_TEXTURE = Root.folder.."gfx\\EventWatcherBottom";

local NUM_DETAILED_ROWS = 4;
local NUM_ARROWS = 10;

-- In sec.
local OPEN_TIME = 0.70;
local CLOSE_TIME = 0.40;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display([x, y, scale])                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event watcher.                                      *
-- * >> x: position of the X center of the event watcher.             *
-- * >> y: position of the Y center of the event watcher.             *
-- * >> scale: the scale of the event watcher.                        *
-- ********************************************************************
-- * Starts displaying the event watcher.                             *
-- * N.B: x/y/scale parameters take precedence before                 *
-- * anchor positions.                                                *
-- ********************************************************************
local function Display(self, x, y, scale)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    local aX, aY, aScale, aEnabled = Anchor:GetAnchorInfo(self);
    if ( not aEnabled ) then return; end

    self.status = "OPENING";
    self.timer = OPEN_TIME;

    self.centerX = x or aX or 0.75;
    self.centerY = y or aY or 0.55;
    self.scale = scale or aScale or 1;

    self:Show();
    EventWatcher.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * >> self: the event watcher.                                      *
-- * >> atOnce: if set, the event watcher will be hidden instantly.   *
-- ********************************************************************
-- * Stops displaying the event watcher.                              *
-- * Note that this WILL NOT stop the driver. As such, it can be used *
-- * to temporarily remove the event watcher then display it again    *
-- * with the :Display method. If you want to completely release the  *
-- * event watcher, do not forget to clear driver's events.           *
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
-- * self:GetDriver()                                                 *
-- ********************************************************************
-- * >> self: the event watcher.                                      *
-- ********************************************************************
-- * Get the driver of the current event driver. To make the event    *
-- * watcher shows event, you have to define them in its driver.      *
-- ********************************************************************
local function GetDriver(self)
    if type(self) ~= "table" then return; end

    return self.Driver;
end

-- ********************************************************************
-- * self:SetRegionInRow(region, rowId, anchorPoint, ofsX, ofsY)      *
-- ********************************************************************
-- * >> self: the event watcher.                                      *
-- * >> region: the region to reanchor.                               *
-- * >> rowId: the row ID in which we will put the region.            *
-- * >> anchorPoint: the anchor point of the region being set.        *
-- * >> ofsX, ofsY: offsets.                                          *
-- ********************************************************************
-- * Set the given region inside a row of the event watcher.          *
-- ********************************************************************
local function SetRegionInRow(self, region, rowId, anchorPoint, ofsX, ofsY)
    if type(self) ~= "table" then return; end

    region:ClearAllPoints();
    region:SetPoint(anchorPoint, self, "BOTTOMLEFT", ofsX, (4 - rowId) * 16 + 8 + ofsY);
end

-- ********************************************************************
-- * self:ChangeRow(rowId, icon, text, countdownText[, r, g, b])      *
-- ********************************************************************
-- * >> self: the event watcher.                                      *
-- * >> rowId: the row ID to change. 1-3 are valid. 4 is reserved.    *
-- * >> icon: the icon to display.                                    *
-- * Can be a texture path, a number or nil.                          *
-- * >> text: the text to be displayed next to the icon. Nil to hide. *
-- * >> countdownText: text shown on the right side. Nil to hide.     *
-- * >> r, g, b: new color of the text.                               *
-- ********************************************************************
-- * Change an upcoming event row of the event watcher.               *
-- ********************************************************************
local function ChangeRow(self, rowId, icon, text, countdownText, r, g, b)
    if type(self) ~= "table" then return; end
    if ( rowId < 1 or rowId >= NUM_DETAILED_ROWS ) then return; end

    if ( icon ) then
        self.rows[rowId].icon:Display(icon);
  else
        self.rows[rowId].icon:Hide();
    end
    self.rows[rowId].countdownText:SetText(countdownText or "");

    if ( r and g and b ) then
        self.rows[rowId].text:SetTextColor(r, g, b);
        self.rows[rowId].textSmall:SetTextColor(r, g, b);
        self.rows[rowId].countdownText:SetTextColor(r, g, b);
    end

    -- Text handling: switch between the normal and small font.
    local textObj, textSmallObj = self.rows[rowId].text, self.rows[rowId].textSmall;

    textObj:SetText(text or "");
    textSmallObj:SetText(text or "");
    local size = textObj:GetStringWidth() / self:GetEffectiveScale();
    if ( size >= 104 ) then
        textObj:Hide();
        textSmallObj:Show();
  else
        textObj:Show();
        textSmallObj:Hide();
    end
end

-- ********************************************************************
-- * self:SetTimeScale(timePerTick)                                   *
-- ********************************************************************
-- * >> self: the event watcher.                                      *
-- * >> timePerTick: the new time per tick desired.                   *
-- ********************************************************************
-- * Change the time scale of the event watcher. See GetTimeScale.    *
-- ********************************************************************
local function SetTimeScale(self, timePerTick)
    if type(self) ~= "table" then return; end
    if type(timePerTick) ~= "number" then return; end

    self.timeScale = max(0.20, timePerTick);
end

-- ********************************************************************
-- * self:GetNumRows()                                                *
-- ********************************************************************
-- * >> self: the event watcher.                                      *
-- ********************************************************************
-- * Get the number of detailed rows an event watcher can handle.     *
-- ********************************************************************
local function GetNumRows(self)
    return NUM_DETAILED_ROWS;
end

-- ********************************************************************
-- * self:GetNumArrows()                                              *
-- ********************************************************************
-- * >> self: the event watcher.                                      *
-- ********************************************************************
-- * Get the number of arrows an event watcher can handle.            *
-- ********************************************************************
local function GetNumArrows(self)
    return NUM_ARROWS;
end

-- ********************************************************************
-- * self:GetArrow(arrowId)                                           *
-- ********************************************************************
-- * >> self: the event watcher.                                      *
-- * >> arrowId: the arrow ID to get. 1-5 are valid.                  *
-- ********************************************************************
-- * Get an event arrow object from the event watcher.                *
-- ********************************************************************
local function GetArrow(self, arrowId)
    if type(self) ~= "table" then return; end
    if ( arrowId < 1 or arrowId > NUM_ARROWS ) then return; end

    return self.arrows[arrowId];
end

-- ********************************************************************
-- * self:GetTimeScale()                                              *
-- ********************************************************************
-- * >> self: the event watcher.                                      *
-- ********************************************************************
-- * Get the time scale used in the event watcher.                    *
-- * The time scale is the time amount represented by each tick.      *
-- ********************************************************************
local function GetTimeScale(self)
    return self.timeScale;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function EventWatcher.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.000;
    self.timeScale = 1.000;

    -- Methods
    self.Display = Display;
    self.Remove = Remove;
    self.GetDriver = GetDriver;
    self.SetRegionInRow = SetRegionInRow;
    self.ChangeRow = ChangeRow;
    self.SetTimeScale = SetTimeScale;
    self.GetNumRows = GetNumRows;
    self.GetNumArrows = GetNumArrows;
    self.GetArrow = GetArrow;
    self.GetTimeScale = GetTimeScale;

    -- Children
    self.topTexture = self:CreateTexture(nil, "BACKGROUND");
    self.topTexture:SetTexture(TOP_TEXTURE);
    self.topTexture:SetTexCoord(0, 1, 0, 1);
    self.topTexture:SetWidth(192);
    self.topTexture:SetHeight(32);
    self.topTexture:SetPoint("TOP", self, "TOP", 0, 0);
    self.topTexture:Show(); 

    self.bottomTexture = self:CreateTexture(nil, "BACKGROUND");
    self.bottomTexture:SetTexture(BOTTOM_TEXTURE);
    self.bottomTexture:SetTexCoord(0, 1, 0, 1);
    self.bottomTexture:SetWidth(192);
    self.bottomTexture:SetHeight(64);
    self.bottomTexture:SetPoint("BOTTOM", self, "BOTTOM", 0, 0);
    self.bottomTexture:Show();

    self.Driver = CreateFrame("Frame", nil, nil, "BossEncounter2_EventWatcherDriverTemplate");
    self.Driver:Setup(self);

    self.rows = { };
    local i, row;
    for i=1, NUM_DETAILED_ROWS do
        row = {
            icon = CreateFrame("Frame", nil, self, "BossEncounter2_EventWatcherIconTemplate"),
            text = Root.CreateFontString(self, "OVERLAY", "NormalYellow", nil, nil, "MIDDLE"),
            textSmall = Root.CreateFontString(self, "OVERLAY", "SmallYellow", nil, nil, "MIDDLE"),
            countdownText = Root.CreateFontString(self, "OVERLAY", "NormalYellow", nil, nil, "MIDDLE"),
        }

        self.rows[i] = row;

        self:SetRegionInRow(row.icon, i, "LEFT", 4, 0);

        row.text:SetHeight(16);
        row.textSmall:SetHeight(16);
        row.countdownText:SetHeight(16);

        if ( i < NUM_DETAILED_ROWS ) then -- The last row is special.
            row.text:SetWidth(112);
            row.text:SetJustifyH("LEFT");
            self:SetRegionInRow(row.text, i, "LEFT", 24, 0);
            row.text:SetText("");

            row.textSmall:SetWidth(112);
            row.textSmall:SetJustifyH("LEFT");
            self:SetRegionInRow(row.textSmall, i, "LEFT", 24, 0);
            row.textSmall:SetText("");

            row.countdownText:SetWidth(48);
            row.countdownText:SetJustifyH("MIDDLE");
            self:SetRegionInRow(row.countdownText, i, "LEFT", 140, 0);
            row.countdownText:SetText("");
      else
            row.text:SetWidth(184);
            row.text:SetJustifyH("MIDDLE");
            self:SetRegionInRow(row.text, i, "CENTER", 96, 0);
            row.text:SetText(Root.Localise("EventWatcher"));

            row.textSmall:Hide();
        end
    end

    self.arrows = { };
    for i=1, NUM_ARROWS do
        self.arrows[i] = CreateFrame("Frame", nil, self, "BossEncounter2_EventWatcherArrowTemplate");
    end
end

function EventWatcher.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    -- Open/close
    if ( self.status == "OPENING" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then self.status = "RUNNING"; end
    end
    if ( self.status == "CLOSING" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then self:Remove(true); end
    end

    -- Positionning handling
    local x, y = self.centerX, self.centerY; -- If not moving.
    local outscreenX = 1.2;
    if ( self.centerX < 0.5 ) then outscreenX = -0.2; end

    if ( self.status == "OPENING" ) then
        x = outscreenX + ( self.centerX - outscreenX ) * (( 1 - self.timer / OPEN_TIME )^0.3);
elseif ( self.status == "CLOSING" ) then
        x = outscreenX + ( self.centerX - outscreenX ) * (( self.timer / CLOSE_TIME )^0.3);
    end

    -- Application on the frame
    local finalX, finalY = x * UIParent:GetWidth(), y * UIParent:GetHeight();
    self:ClearAllPoints();
    self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", finalX / self.scale, finalY / self.scale);
    self:SetScale(self.scale);
end