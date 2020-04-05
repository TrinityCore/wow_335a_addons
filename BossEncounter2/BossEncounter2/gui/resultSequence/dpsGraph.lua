local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["DPSGraph"] = { };
local DPSGraph = Widgets["DPSGraph"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local MAX_COLUMNS = 25;

local DEFAULT_SCROLL_TIME = 0.500;
local DEFAULT_XPOSITION = 0.65;
local DEFAULT_YPOSITION = 0.45;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display([x, y, time])                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the graph.                                              *
-- * >> x, y: position of the X/Y center of the graph.                *
-- * >> time: the time needed to scroll-in the graph.                 *
-- ********************************************************************
-- * Display the DPS graph.                                           *
-- ********************************************************************
local function Display(self, x, y, time)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    self.status = "OPENING";
    self.timer = time or DEFAULT_SCROLL_TIME;
    self.timerMax = time or DEFAULT_SCROLL_TIME;

    self.centerX = x or DEFAULT_XPOSITION;
    self.centerY = y or DEFAULT_YPOSITION;

    self.average:Show();

    -- And display the frame
    self:Show();
    DPSGraph.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce, time)                                        *
-- ********************************************************************
-- * >> self: the graph.                                              *
-- * >> atOnce: if set, the graph will be hidden instantly.           *
-- * >> time: the time we'll have to take to perform the scroll-out   *
-- * animation. Note this parameter is not useful if atOnce is true.  *
-- ********************************************************************
-- * Stops displaying the DPS graph.                                  *
-- ********************************************************************
local function Remove(self, atOnce, time)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "OPENING" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        self.status = "CLOSING";
        self.timer = time;
        self.timerMax = time;
    end
end

-- ********************************************************************
-- * self:Reset()                                                     *
-- ********************************************************************
-- * >> self: the graph.                                              *
-- ********************************************************************
-- * Hide all elements of the graph.                                  *
-- ********************************************************************
local function Reset(self)
    if type(self) ~= "table" then return; end

    -- Hide all columns
    local i;
    for i=1, MAX_COLUMNS do
        self.columns[i]:Hide();
    end

    -- Remove average line
    self.averageFraction = 0;
    self.average:Hide();

    self.growTimer = 0;
    self.growTimerMax = 0;
end

-- ********************************************************************
-- * self:SetNumUsedColumns(num)                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the graph.                                              *
-- * >> num: the number of columns that will get displayed.           *
-- ********************************************************************
-- * Set the number of columns that will get displayed in the graph.  *
-- ********************************************************************
local function SetNumUsedColumns(self, num)
    if type(self) ~= "table" then return; end

    self.usedColumns = max(5, num);

    local sizePerColumn = 480 / self.usedColumns;
    local i, column;
    for i=1, MAX_COLUMNS do
        column = self.columns[i];
        column:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 16 + sizePerColumn * (i-1) + 0.1 * sizePerColumn, 32);
        column:SetWidth(0.8 * sizePerColumn);
    end
end

-- ********************************************************************
-- * self:GetNumColumns()                                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the graph.                                              *
-- ********************************************************************
-- * Get the max number of columns displayable in the graph.          *
-- ********************************************************************
local function GetNumColumns(self)
    if type(self) ~= "table" then return; end

    return MAX_COLUMNS;
end

-- ********************************************************************
-- * self:GetColumn(index)                                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the graph.                                              *
-- * >> index: the index of the column to get.                        *
-- ********************************************************************
-- * Get the max number of columns that will get displayed in the     *
-- * graph and the number of columns that are set as used.            *
-- ********************************************************************
local function GetColumn(self, index)
    if type(self) ~= "table" then return; end

    return self.columns[index];
end

-- ********************************************************************
-- * self:AutosetColumns(dpsTable, growTimer)                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the graph.                                              *
-- * >> dpsTable: the DPS table to pull DPS info from.                *
-- * >> growTimer: the time for columns to grow.                      *
-- ********************************************************************
-- * Automatically set up the columns according to a DPS table.       *
-- * graph and the number of columns that are set as used.            *
-- ********************************************************************
local function AutosetColumns(self, dpsTable, growTimer)
    if type(self) ~= "table" then return; end

    local numEntries = min(self:GetNumColumns(), #dpsTable);
    local i, column, special;

    self:SetNumUsedColumns(numEntries);
    -- self:SetNumUsedColumns(25);
    self:SetMaximum(dpsTable.maximum);

    self.averageFraction = dpsTable.average / self:GetMaximum();

    for i=1, self:GetNumColumns() do
        column = self:GetColumn(i);
        if ( i <= numEntries ) then
            special = nil;
            if ( dpsTable[i].guid == dpsTable.coupDeGrace ) then special = "KILLING_BLOW"; end

            column:Set(dpsTable[i].class, dpsTable[i].dps, special);

            -- Tooltip setup
            local pct = dpsTable[i].dps * 100 / dpsTable.total;
            local wastedDPS = max(0, dpsTable[i].totalDps - dpsTable[i].dps);
            local relevancePct = min(100, dpsTable[i].dps * 100 / dpsTable[i].totalDps);

            local petString = "";
            if ( dpsTable[i].pet > 0 ) then
                petString = Root.FormatLoc("UsefulDPSPet", dpsTable[i].pet);
            end

            local detail = Root.FormatLoc("UsefulDPSEntry", i, dpsTable[i].dps, petString, pct, wastedDPS, relevancePct + 0.5);
            Root.SetTooltip(column, dpsTable[i].name, detail);
      else
            column:Hide();
        end
    end

    self.growTimer = growTimer;
    self.growTimerMax = math.max(1, growTimer);
end

-- ********************************************************************
-- * self:SetMaximum(value)                                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the graph.                                              *
-- * >> value: the max value in the graph.                            *
-- ********************************************************************
-- * Set the max value of the graph.                                  *
-- ********************************************************************
local function SetMaximum(self, value)
    if type(self) ~= "table" then return; end

    self.maximum = value;
end

-- ********************************************************************
-- * self:GetMaximum()                                                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the graph.                                              *
-- ********************************************************************
-- * Get the max value of the graph.                                  *
-- ********************************************************************
local function GetMaximum(self)
    if type(self) ~= "table" then return; end

    return math.max(1, self.maximum);
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function DPSGraph.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0;
    self.timerMax = 0;
    self.usedColumns = 5;
    self.maximum = 0;
    self.averageFraction = 0;
    self.growTimer = 0;
    self.growTimerMax = 0;

    -- Methods
    self.Display = Display;
    self.Remove = Remove;
    self.Reset = Reset;
    self.SetNumUsedColumns = SetNumUsedColumns;
    self.GetNumColumns = GetNumColumns;
    self.GetColumn = GetColumn;
    self.AutosetColumns = AutosetColumns;
    self.SetMaximum = SetMaximum;
    self.GetMaximum = GetMaximum;

    -- Children
    self.title = Root.CreateFontString(self, "ARTWORK", "Big", nil, "MIDDLE", "BOTTOM");
    self.title:SetHeight(32);
    self.title:SetPoint("BOTTOM", self, "TOP", 0, -8);
    self.title:SetText(Root.Localise("UsefulDPS"));
    self.title:Show();

    self.columns = { };
    local i;
    for i=1, MAX_COLUMNS do
        self.columns[i] = CreateFrame("Button", nil, self, "BossEncounter2_DPSGraphColumnTemplate");
    end

    self.average = CreateFrame("Frame", nil, self);
    self.average:SetWidth(480);
    self.average:SetHeight(1);
    self.average:SetFrameLevel(self:GetFrameLevel() + 2);
    self.average.texture = self.average:CreateTexture(nil, "BACKGROUND");
    self.average.texture:SetAllPoints(true);
    self.average.texture:SetTexture(1, 1, 1);
    self.average.label = Root.CreateFontString(self.average, "ARTWORK", "SmallWhite", nil, "RIGHT", "BOTTOM");
    self.average.label:SetPoint("BOTTOMRIGHT", self.average, "TOPRIGHT", 0, 0);

    self.explanation = Root.CreateFontString(self, "ARTWORK", "SmallYellow", nil, "MIDDLE", "MIDDLE");
    self.explanation:SetWidth(384);
    self.explanation:SetHeight(192);
    self.explanation:SetPoint("CENTER", self, "CENTER", 0, 0);
    self.explanation:SetText(Root.Localise("UsefulDPSExplanation"));
    self.explanation:Show();

    Root.SetBackdrop(self, "BLUE");

    self:Reset();
end

function DPSGraph.OnUpdate(self, elapsed)
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

    self.growTimer = max(0, self.growTimer - elapsed);
    local progression = 0;
    if ( self.growTimerMax ~= 0 ) then
        progression = 1 - self.growTimer / self.growTimerMax;
    end
    local gxProgression = sin(progression * 90)^2;

    -- Column handling
    local i, column;
    for i=1, self:GetNumColumns() do
        column = self:GetColumn(i);
        column:Update(progression, gxProgression, 176);
    end

    -- Explanation handling
    self.explanation:SetAlpha(1 - progression);

    -- Average handling
    self.average:SetPoint("BOTTOM", self, "BOTTOM", 0, 31 + 176 * gxProgression * self.averageFraction);
    self.average.label:SetAlpha(progression);
    if ( self.growTimerMax ~= 0 ) then
        self.average.label:SetText(Root.FormatLoc("AverageDPS", gxProgression * self:GetMaximum() * self.averageFraction));
    end

    -- Positionning handling
    local x = self.centerX; -- If not moving.
    local outscreenX = 1.50;

    if ( self.status == "OPENING" ) then
        x = outscreenX + ( self.centerX - outscreenX ) * (( 1 - self.timer / self.timerMax )^1.0);
   elseif ( self.status == "CLOSING" ) then
        x = outscreenX + ( self.centerX - outscreenX ) * (( self.timer / self.timerMax )^0.3);
    end

    local parent = self:GetParent();
    local finalX = (x - 0.5) * parent:GetWidth();
    local finalY = (self.centerY - 0.5) * parent:GetHeight();

    -- Application on the frame
    self:ClearAllPoints();
    self:SetPoint("CENTER", parent, "CENTER", finalX, finalY);
end