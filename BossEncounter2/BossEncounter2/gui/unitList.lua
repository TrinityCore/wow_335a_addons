local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");

Widgets["UnitList"] = { };
local UnitList = Widgets["UnitList"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local MAIN_TEXTURE = Root.folder.."gfx\\UnitList";
local TAIL_TEXTURE = Root.folder.."gfx\\UnitListTail";
local FLASH_TEXTURE = Root.folder.."gfx\\UnitListFlash";

local NUM_ROWS = 10;

-- In sec.
local OPEN_TIME = 0.70;
local CLOSE_TIME = 0.40;

local FLASH_TIMER = 1.000; -- The amount of time to do one flash cycle (pi rad).

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display([x, y, scale])                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the unit list.                                          *
-- * >> x: position of the X center of the unit list.                 *
-- * >> y: position of the Y center of the unit list.                 *
-- * >> scale: scale of the unit list.                                *
-- ********************************************************************
-- * Starts displaying the unit list.                                 *
-- * N.B: x/y parameters take precedence before                       *
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

    self:SetFlash(nil);

    self:Show();
    UnitList.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * >> self: the unit list.                                          *
-- * >> atOnce: if set, the unit list will be hidden instantly.       *
-- ********************************************************************
-- * Stops displaying the unit list.                                  *
-- * Note that this WILL NOT stop the driver. As such, it can be used *
-- * to temporarily remove the unit list then display it again        *
-- * with the :Display method. If you want to completely release the  *
-- * unit list, do not forget to clear the driver task.               *
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
-- * >> self: the unit list.                                          *
-- ********************************************************************
-- * Get the driver of the current unit list.                         *
-- ********************************************************************
local function GetDriver(self)
    if type(self) ~= "table" then return; end

    return self.Driver;
end

-- ********************************************************************
-- * self:SetRegionInRow(region, rowId, anchorPoint, ofsX, ofsY)      *
-- ********************************************************************
-- * >> self: the unit list.                                          *
-- * >> region: the region to reanchor.                               *
-- * >> rowId: the row ID in which we will put the region.            *
-- * >> anchorPoint: the anchor point of the region being set.        *
-- * >> ofsX, ofsY: offsets.                                          *
-- ********************************************************************
-- * Set the given region inside the given unit list row.             *
-- ********************************************************************
local function SetRegionInRow(self, region, rowId, anchorPoint, ofsX, ofsY)
    if type(self) ~= "table" then return; end

    if ( rowId == "TITLE" ) then rowId = 10; end
    if ( rowId == "SUMMARY" ) then rowId = 9; end

    region:ClearAllPoints();
    region:SetPoint(anchorPoint, self, "BOTTOMLEFT", ofsX, (10 - rowId) * 16 + 8 + ofsY);
end

-- ********************************************************************
-- * self:GetNumRows()                                                *
-- ********************************************************************
-- * >> self: the unit list.                                          *
-- ********************************************************************
-- * Get the number of detailed rows an unit list can handle.         *
-- ********************************************************************
local function GetNumRows(self)
    return NUM_ROWS;
end

-- ********************************************************************
-- * self:ChangeRow(rowId, guid, text[, r, g, b])                     *
-- ********************************************************************
-- * >> self: the unit list.                                          *
-- * >> rowId: the row ID to change. 1-3 are valid. 4 is reserved.    *
-- * >> guid: the GUID of the raid member that is shown in the row.   *
-- * The class and name will be automatically found for this person.  *
-- * >> text: the text to be displayed on the right side.             *
-- * >> r, g, b: new color of the text.                               *
-- ********************************************************************
-- * Change a row of the unit list.                                   *
-- ********************************************************************
local function ChangeRow(self, rowId, guid, text, r, g, b)
    if type(self) ~= "table" then return; end
    if ( rowId < 1 or rowId > (NUM_ROWS-2) ) then return; end

    local uid = Root.Unit.GetUID(guid);
    local name = nil;
    local raidIcon = 0;
    local classIcon = nil;

    if ( uid ) then
        name = UnitName(uid);
        raidIcon = GetRaidTargetIndex(uid) or 0;
        if ( UnitIsPlayer(uid) ) then
            classIcon = select(2, UnitClass(uid));
        end
    end

    Root.SetIcon(self.rows[rowId].icon, (raidIcon > 0 and raidIcon) or classIcon);

    self.rows[rowId].text:SetText(text or "");
    if ( r and g and b ) then
        self.rows[rowId].text:SetTextColor(r, g, b);
    end

    if ( name ) and ( guid == UnitGUID("player") ) then name = "|cffffffff"..name.."|r"; end
    self.rows[rowId].name:SetText(name or "");
end

-- ********************************************************************
-- * self:ChangeTitle(title)                                          *
-- ********************************************************************
-- * >> self: the unit list.                                          *
-- * >> title: the new title of what's being shown in the unit list.  *
-- ********************************************************************
-- * Change the title of the unit list.                               *
-- ********************************************************************
local function ChangeTitle(self, title)
    if type(self) ~= "table" then return; end
    title = title or "";

    local titleRow = self.rows[NUM_ROWS];
    titleRow.text:SetText(title);
end

-- ********************************************************************
-- * self:ChangeSummary(text)                                         *
-- ********************************************************************
-- * >> self: the unit list.                                          *
-- * >> title: the new text of the unit list summary.                 *
-- ********************************************************************
-- * Change the summary of the unit list.                             *
-- ********************************************************************
local function ChangeSummary(self, text)
    if type(self) ~= "table" then return; end
    text = text or "";

    local summaryRow = self.rows[NUM_ROWS - 1];
    summaryRow.text:SetText(text);
end

-- ********************************************************************
-- * self:SetFlash([r, g, b])                                         *
-- ********************************************************************
-- * >> self: the unit list.                                          *
-- * >> r, g, b: the color of the flash.                              *
-- * Provide nil to "r" to cancel the flash.                          *
-- ********************************************************************
-- * Make a flashing border around the unit list.                     *
-- ********************************************************************
local function SetFlash(self, r, g, b)
    if type(self) ~= "table" then return; end

    if not ( r ) then
        self.flashTimer = nil;
  else
        self.flashTexture:SetVertexColor(r, g or 0, b or 0);
        self.flashTimer = 0;
    end
end

-- ********************************************************************
-- * self:IsFlashing()                                                *
-- ********************************************************************
-- * >> self: the unit list.                                          *
-- ********************************************************************
-- * Determinate if the unit list is flashing.                        *
-- ********************************************************************
local function IsFlashing(self, r, g, b)
    if type(self) ~= "table" then return false; end
    if ( self.flashTimer ) then return true; end
    return false;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function UnitList.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.000;

    -- Methods
    self.Display = Display;
    self.Remove = Remove;
    self.GetDriver = GetDriver;
    self.SetRegionInRow = SetRegionInRow;
    self.GetNumRows = GetNumRows;
    self.ChangeRow = ChangeRow;
    self.ChangeTitle = ChangeTitle;
    self.ChangeSummary = ChangeSummary;
    self.SetFlash = SetFlash;
    self.IsFlashing = IsFlashing;

    -- Children
    self.mainTexture = self:CreateTexture(nil, "BACKGROUND");
    self.mainTexture:SetTexture(MAIN_TEXTURE);
    self.mainTexture:SetTexCoord(0, 1, 0, 1);
    self.mainTexture:SetWidth(192);
    self.mainTexture:SetHeight(128);
    self.mainTexture:SetPoint("TOP", self, "TOP", 0, 0);
    self.mainTexture:Show(); 

    self.tailTexture = self:CreateTexture(nil, "BACKGROUND");
    self.tailTexture:SetTexture(TAIL_TEXTURE);
    self.tailTexture:SetTexCoord(0, 1, 0, 1);
    self.tailTexture:SetWidth(192);
    self.tailTexture:SetHeight(32);
    self.tailTexture:SetPoint("BOTTOM", self, "BOTTOM", 0, 0);
    self.tailTexture:Show();

    self.flashTexture = self:CreateTexture(nil, "BACKGROUND");
    self.flashTexture:SetTexture(FLASH_TEXTURE);
    self.flashTexture:SetTexCoord(0, 160/256, 0, 192/256);
    self.flashTexture:SetWidth(240);
    self.flashTexture:SetHeight(192);
    self.flashTexture:SetPoint("CENTER", self, "CENTER", 0, 0);
    self.flashTexture:Show();

    self.rows = { };
    local i, row;
    for i=1, NUM_ROWS do
        row = {
            icon = self:CreateTexture(nil, "ARTWORK"),
            name = Root.CreateFontString(self, "OVERLAY", "NormalYellow", nil, nil, "MIDDLE"),
            text = Root.CreateFontString(self, "OVERLAY", "NormalYellow", nil, nil, "MIDDLE"),
        };

        self.rows[i] = row;

        row.icon:SetWidth(16);
        row.icon:SetHeight(16);
        row.name:SetHeight(16);
        row.text:SetHeight(16);

        self:SetRegionInRow(row.icon, i, "LEFT", 4, 0);

        if ( i <= (NUM_ROWS - 2) ) then
            row.name:SetWidth(80);
            row.name:SetJustifyH("LEFT");
            self:SetRegionInRow(row.name, i, "LEFT", 24, 0);

            row.text:SetWidth(80);
            row.text:SetJustifyH("RIGHT");
            self:SetRegionInRow(row.text, i, "LEFT", 108, 0);

            self:ChangeRow(i, nil, "");

    elseif ( i == (NUM_ROWS - 1) ) then
            row.text:SetWidth(184);
            row.text:SetJustifyH("LEFT");
            self:SetRegionInRow(row.text, i, "LEFT", 4, 0);
            row.name:Hide();
            row.icon:Hide();

    elseif ( i == NUM_ROWS ) then
            row.text:SetWidth(184);
            row.text:SetJustifyH("MIDDLE");
            self:SetRegionInRow(row.text, i, "CENTER", 96, 0);
            row.name:Hide();
            row.icon:Hide();
        end
    end

    self.Driver = CreateFrame("Frame", nil, nil, "BossEncounter2_UnitListDriverTemplate");
    self.Driver:Setup(self);

    self:ChangeTitle("");
    self:ChangeSummary("");
    self:SetFlash(nil);
end

function UnitList.OnUpdate(self, elapsed)
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

    -- Flash handling
    local flashAlpha = 0;
    if ( self.flashTimer ) then
        self.flashTimer = math.fmod(self.flashTimer + elapsed, FLASH_TIMER);
        flashAlpha = sin(self.flashTimer / FLASH_TIMER * 180);
    end
    self.flashTexture:SetAlpha(flashAlpha);

    -- Application on the frame
    local finalX, finalY = x * UIParent:GetWidth(), y * UIParent:GetHeight();
    self:ClearAllPoints();
    self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", finalX / self.scale, finalY / self.scale);
    self:SetScale(self.scale);
end