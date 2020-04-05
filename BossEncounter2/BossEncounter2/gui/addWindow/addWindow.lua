local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");

Widgets["AddWindow"] = { };
local AddWindow = Widgets["AddWindow"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local EDGE_TEXTURE = Root.folder.."gfx\\AddWindowEdge";
local TILE_TEXTURE = Root.folder.."gfx\\AddWindowTile";

local NUM_ADD_ROWS = 10; -- This constant sets the maximum number of adds that can be handled by the add window.

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
-- * >> self: the add window.                                         *
-- * >> x: position of the X center of the add window.                *
-- * >> y: position of the Y center of the add window.                *
-- * >> scale: scale of the add window.                               *
-- ********************************************************************
-- * Starts displaying the add window.                                *
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
    self.centerY = y or aY or 0.35;
    self.scale = scale or aScale or 1;
    self.height = 24;

    self:Show();
    AddWindow.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * >> self: the add window.                                         *
-- * >> atOnce: if set, the add window will be hidden instantly.      *
-- ********************************************************************
-- * Stops displaying the add window.                                 *
-- * Note that this WILL NOT stop the driver. As such, it can be used *
-- * to temporarily remove the add window then display it again       *
-- * with the :Display method. If you want to completely release the  *
-- * add window, do not forget to clear the driver.                   *
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
-- * >> self: the add window.                                         *
-- ********************************************************************
-- * Get the driver of the current add window.                        *
-- ********************************************************************
local function GetDriver(self)
    if type(self) ~= "table" then return; end

    return self.Driver;
end

-- ********************************************************************
-- * self:GetNumRows()                                                *
-- ********************************************************************
-- * >> self: the add window.                                         *
-- ********************************************************************
-- * Get the number of add rows the add window can handle.            *
-- ********************************************************************
local function GetNumRows(self)
    return NUM_ADD_ROWS;
end

-- ********************************************************************
-- * self:GetRow(index)                                               *
-- ********************************************************************
-- * >> self: the add window.                                         *
-- * >> index: the index of the row to get.                           *
-- ********************************************************************
-- * Get one of the add rows. A second return is given, which tells   *
-- * if the row is available.                                         *
-- ********************************************************************
local function GetRow(self, index)
    local r = self.rows[index];
    if ( r ) then
        return r, (r.status == "STANDBY");
  else
        return nil, false;
    end
end

-- ********************************************************************
-- * self:GetFreeRow()                                                *
-- ********************************************************************
-- * >> self: the add window.                                         *
-- ********************************************************************
-- * Get an unused row on the add window.                             *
-- ********************************************************************
local function GetFreeRow(self)
    local i, row, free;
    for i=1, self:GetNumRows() do
        row, free = self:GetRow(i);
        if ( free ) then return row; end
    end
    return nil;
end

-- ********************************************************************
-- * self:ChangeBonusColumn(used, label, barLayout)                   *
-- ********************************************************************
-- * >> self: the add window.                                         *
-- * >> used: whether we want to use the bonus column or not.         *
-- * >> label: the label of the bonus column.                         *
-- * >> barLayout: the appearance of the bar of the bonus column.     *
-- ********************************************************************
-- * Change the bonus column of the add window.                       *
-- * Should be called by the driver when starting to handle adds.     *
-- ********************************************************************
local function ChangeBonusColumn(self, used, label, barLayout)
    if type(self) ~= "table" then return; end

    self.bonusUsed = used;
    self.bonusName = label;
    self.bonusLayout = barLayout;

    local nO, nS, hpO, hpS, bO, bS = self:GetColumnOffsets();

    self.nameText:SetWidth(nS);
    self.nameText:SetPoint("TOPLEFT", self, "TOPLEFT", nO, -4);

    self.hpText:SetWidth(hpS);
    self.hpText:SetPoint("TOPLEFT", self, "TOPLEFT", hpO, -4);

    self.bonusText:SetWidth(bS);
    self.bonusText:SetPoint("TOPLEFT", self, "TOPLEFT", bO, -4);
    self.bonusText:SetText(label);

    if ( used ) then self.bonusText:Show(); else self.bonusText:Hide(); end
end

-- ********************************************************************
-- * self:GetBonusColumnInfo()                                        *
-- ********************************************************************
-- * >> self: the add window.                                         *
-- ********************************************************************
-- * Get the layout of the bonus column.                              *
-- * Return used, label, barLayout.                                   *
-- ********************************************************************
local function GetBonusColumnInfo(self)
    if type(self) ~= "table" then return; end

    return self.bonusUsed or false, self.bonusName or "", self.bonusLayout or 0;
end

-- ********************************************************************
-- * self:GetColumnOffsets()                                          *
-- ********************************************************************
-- * >> self: the add window.                                         *
-- ********************************************************************
-- * Get the offsets of the name, HP and bonus columns according to   *
-- * the current layout.                                              *
-- * Return nameOffset, nameWidth, hpOffset, hpWidth,                 *
-- *        bonusOffset, bonusWidth.                                  *
-- ********************************************************************
local function GetColumnOffsets(self)
    if type(self) ~= "table" then return; end

    if ( self.bonusUsed ) then
        return 8, 100, 112, 84, 200, 48;
  else
        return 8, 118, 130, 118, 0, 64;
    end
end

-- ********************************************************************
-- * self:GetHeightRequired()                                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window.                                         *
-- ********************************************************************
-- * Get the height the add window should have given the rows         *
-- * currently used.                                                  *
-- ********************************************************************
local function GetHeightRequired(self)
    if type(self) ~= "table" then return; end

    local i, row, free;
    local maxHeight = 24;

    for i=self:GetNumRows(), 1, -1 do
        row, free = self:GetRow(i);
        if ( not free ) then
            maxHeight = max(maxHeight, row.reqHeight);
        end
    end

    return maxHeight;
end

-- ********************************************************************
-- * self:ChangeRowPosition(row, newPosition)                         *
-- ********************************************************************
-- * >> self: the add window.                                         *
-- * >> row: the row that gets moved.                                 *
-- * >> newPosition: the index of the new position. 1 is uppermost.   *
-- ********************************************************************
-- * Change the position of a row on the add window.                  *
-- * If another row is on the new position, they will get swapped.    * 
-- ********************************************************************
local function ChangeRowPosition(self, row, newPosition)
    local oldPosition = row.position or 0;
    local otherRow = self.occupiedPosition[newPosition];

    if ( newPosition < 1 ) then return; end
    if ( oldPosition == newPosition ) then return; end

    self.occupiedPosition[newPosition] = row;
    row:SetPosition(newPosition);

    if ( otherRow ) then
        self.occupiedPosition[oldPosition] = otherRow;
        otherRow:SetPosition(oldPosition);
  else
        -- No other row in the way !
        self.occupiedPosition[oldPosition] = nil;
    end
end

-- ********************************************************************
-- * self:IsLocked()                                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window.                                         *
-- ********************************************************************
-- * Determinate if the add window is locked because any of its rows  *
-- * is currently locked in combat due to a secure frame.             *
-- * A second return indicates if a secure element is currently used  *
-- * in the whole add window.                                         *
-- ********************************************************************
local function IsLocked(self)
    local i, row, locked, secure;
    for i=1, self:GetNumRows() do
        row = self:GetRow(i);
        locked, secure = row:IsLocked();
        if ( secure ) then
            return (InCombatLockdown() == 1), true;
        end
    end
    return false, false;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function AddWindow.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.000;
    self.height = 24;
    self.occupiedPosition = { };

    -- Methods
    self.Display = Display;
    self.Remove = Remove;
    self.GetDriver = GetDriver;
    self.GetNumRows = GetNumRows;
    self.GetRow = GetRow;
    self.GetFreeRow = GetFreeRow;
    self.ChangeBonusColumn = ChangeBonusColumn;
    self.GetBonusColumnInfo = GetBonusColumnInfo;
    self.GetColumnOffsets = GetColumnOffsets;
    self.GetHeightRequired = GetHeightRequired;
    self.ChangeRowPosition = ChangeRowPosition;
    self.IsLocked = IsLocked;

    -- Children
    self.hpText = Root.CreateFontString(self, "OVERLAY", "SmallYellow", nil, "LEFT", "MIDDLE");
    self.hpText:SetHeight(16);
    self.hpText:SetText(Root.Localise("HP"));
    self.nameText = Root.CreateFontString(self, "OVERLAY", "SmallYellow", nil, "LEFT", "MIDDLE");
    self.nameText:SetHeight(16);
    self.nameText:SetText(Root.Localise("Name"));
    self.bonusText = Root.CreateFontString(self, "OVERLAY", "SmallYellow", nil, "LEFT", "MIDDLE");
    self.bonusText:SetHeight(16);
    self.bonusText:Hide();

    self.rows = { };
    local i;
    for i=1, NUM_ADD_ROWS do
        self.rows[i] = CreateFrame("Frame", nil, self, "BossEncounter2_AddWindowRowTemplate");
        self.rows[i]:SetID(i);
        self:ChangeRowPosition(self.rows[i], i);
    end

    self.Driver = CreateFrame("Frame", nil, nil, "BossEncounter2_AddWindowDriverTemplate");
    self.Driver:Setup(self);

    self:SetBackdrop({
        bgFile = TILE_TEXTURE,
        edgeFile = EDGE_TEXTURE,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
        edgeSize = 8,
        tileSize = 8,
        tile = false,
    });
    self:SetBackdropBorderColor(1.0, 1.0, 1.0, 1.0);
    self:SetBackdropColor(1.0, 1.0, 1.0, 0.5);

    self:ChangeBonusColumn(false);
end

function AddWindow.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    local locked, secure = self:IsLocked();

    -- Open/close
    if ( self.status == "OPENING" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then self.status = "RUNNING"; end
    end
    if ( self.status == "CLOSING" ) and ( not locked ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then self:Remove(true); end
    end

    if ( self.status == "RUNNING" ) and ( not secure ) then
        -- OK, the add window does not use the secure functionnalities, we can resize it smoothly.
        local tHeight = self:GetHeightRequired();
        if ( self.height < tHeight ) then
            self.height = min(tHeight, self.height + 40 * elapsed);
     else
            self.height = max(tHeight, self.height - 80 * elapsed);
        end
elseif ( secure ) and ( not locked ) then
        -- Ow, the add window uses secure frame, we better make it the correct size instantly.
        self.height = self:GetHeightRequired();
    end

    -- Positionning handling
    local x, y = self.centerX, self.centerY; -- If not moving.
    local alpha = 1.0;
    local outscreenX = 1.25;
    if ( self.centerX < 0.5 ) then outscreenX = -0.25; end

    if ( secure ) then
        -- Too risky to do a scroll in/out animation since the player could go in combat anytime.
        if ( self.status == "OPENING" ) then
            alpha = 1 - self.timer / OPEN_TIME;
    elseif ( self.status == "CLOSING" ) then
            alpha = self.timer / CLOSE_TIME;
        end
  else
        if ( self.status == "OPENING" ) then
            x = outscreenX + ( self.centerX - outscreenX ) * (( 1 - self.timer / OPEN_TIME )^0.3);
    elseif ( self.status == "CLOSING" ) then
            x = outscreenX + ( self.centerX - outscreenX ) * (( self.timer / CLOSE_TIME )^0.3);
        end
    end

    -- Application on the frame
    local finalX, finalY = x * UIParent:GetWidth(), y * UIParent:GetHeight();
    self:ClearAllPoints();
    self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", finalX / self.scale, finalY / self.scale);
    self:SetScale(self.scale);
    self:SetHeight(self.height);
    self:SetAlpha(alpha);
end