local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["DPSGraphColumn"] = { };
local DPSGraphColumn = Widgets["DPSGraphColumn"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local BAR = Root.folder.."gfx\\Bar";
local KILLING_BLOW = Root.folder.."gfx\\KillingBlowTag";

local SPECIAL_SWAY_TIME = 1.00;

local BLACK = { r = 0, g = 0, b = 0 };

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Set(class, dps[, special])                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the graph column.                                       *
-- * >> class: the class represented by this column.                  *
-- * >> dps: the DPS value.                                           *
-- * >> special: any special flag for this column. Currently, this    *
-- * can be: KILLING_BLOW.                                            *
-- ********************************************************************
-- * Starts displaying a column in the dps graph.                     *
-- ********************************************************************
local function Set(self, class, dps, special)
    if type(self) ~= "table" then return; end

    local graph = self:GetParent();

    self.visible = true;
    self.fraction = dps / graph:GetMaximum();
    self.dps = dps;

    local color = RAID_CLASS_COLORS[class] or BLACK;
    if ( graph.usedColumns >= 15 ) then
        self.bar:SetVertexColor(color.r, color.g, color.b);
        self.bar:SetTexture(BAR);
        self.outline:Show();
        self.outline:SetVertexColor(color.r, color.g, color.b);
 else
        self.bar:SetVertexColor(1, 1, 1);
        self.bar:SetTexture(color.r, color.g, color.b);
        self.outline:Hide();
    end
    Root.SetIcon(self.class, class);

    if ( special == "KILLING_BLOW" ) then
        self.special:Show();
        self.special:SetTexture(KILLING_BLOW);
  else
        self.special:Hide();
    end

    self:Update(0, 0, 1);
    self:Show();
end

-- ********************************************************************
-- * self:Update(progression, gxProgression, availableHeight)         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the graph column.                                       *
-- * >> progression: the progression of the grow.                     *
-- * >> gxProgression: the nice progression of the grow.              *
-- * It is a number between 0 and 1.                                  *
-- * >> availableHeight: the available height for bars.               *
-- ********************************************************************
-- * Update a column of the graph.                                    *
-- ********************************************************************
local function Update(self, progression, gxProgression, availableHeight)
    if type(self) ~= "table" then return; end
    if ( not self.visible ) then return; end

    local size = math.max(1, self.fraction * gxProgression * availableHeight);
    local displayDPS = self.dps * gxProgression;

    self:SetHeight(size);
    self.label:SetText(string.format("%d", displayDPS));
    self.class:SetAlpha(progression);

    local sway = sin(math.fmod(GetTime(), SPECIAL_SWAY_TIME) / SPECIAL_SWAY_TIME * 180) * 6;
    self.special:SetPoint("BOTTOM", self, "TOP", 0, 16 + sway);
    self.special:SetAlpha(progression);
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function DPSGraphColumn.OnLoad(self)
    -- Properties
    self.visible = false;

    -- Methods
    self.Set = Set;
    self.Update = Update;

    -- Children
    self.bar = self:CreateTexture(nil, "BACKGROUND");
    self.bar:SetAllPoints(true);
    self.outline = self:CreateTexture(nil, "ARTWORK");
    self.outline:ClearAllPoints();
    self.outline:SetTexture(1, 1, 1);
    self.outline:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0);
    self.outline:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, -1);

    self.class = self:CreateTexture(nil, "BACKGROUND");
    self.class:SetWidth(16);
    self.class:SetHeight(16);
    self.class:SetPoint("TOP", self, "BOTTOM", 0, -2);

    self.special = self:CreateTexture(nil, "OVERLAY");
    self.special:SetWidth(64);
    self.special:SetHeight(8);

    self.label = Root.CreateFontString(self, "ARTWORK", "SmallWhite", nil, "MIDDLE", "BOTTOM");
    self.label:SetWidth(64);
    self.label:SetHeight(20);
    self.label:SetPoint("BOTTOM", self, "TOP", 0, 2);
    self.label:Show();
end
