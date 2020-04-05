local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["BossBarLayer"] = { };
local BossBarLayer = Widgets["BossBarLayer"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local TEXTURE = Root.folder.."gfx\\BossBarContent";

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(parent, priority)                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar layer.                                     *
-- * >> parent: the boss bar the boss bar layer belongs to.           *
-- * Nil will clear the parent and the layer will become hidden.      *
-- * >> priority: the priority order when several layers overlap with *
-- * each other (default 1).                                          *
-- ********************************************************************
-- * Setup a boss bar layer.                                          *
-- ********************************************************************
local function Setup(self, parent, priority)
    if type(self) ~= "table" then return; end

    self.parent = parent;
    self.priority = max(1, priority or 1);
    self:Update();
end

-- ********************************************************************
-- * self:SetPortion(endPortion)                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar layer.                                     *
-- * >> endPortion: the end position of the portion that will be      *
-- * drawn. It can be between 0 and 1.                                *
-- ********************************************************************
-- * Change the portion of the bar layer that will be drawn.          *
-- ********************************************************************
local function SetPortion(self, endPortion)
    if type(self) ~= "table" then return; end

    self.endPortion = max(0, min(1, endPortion or 0));
    self:Update();
end

-- ********************************************************************
-- * self:ChangeColor(r, g, b[, a])                                   *
-- ********************************************************************
-- * >> self: the boss bar layer.                                     *
-- * >> r, g, b[, a]: red, green, blue and alpha values.              *
-- ********************************************************************
-- * Change the color of the boss bar layer.                          *
-- ********************************************************************
local function ChangeColor(self, r, g, b, a)
    if type(self) ~= "table" then return; end

    self.left:SetVertexColor(r, g, b);
    self.middle:SetVertexColor(r, g, b);
    self.right:SetVertexColor(r, g, b);

    if type(a) == "number" then
        self.left:SetAlpha(a);
        self.middle:SetAlpha(a);
        self.right:SetAlpha(a);
    end
end

-- ********************************************************************
-- * self:Update()                                                    *
-- ********************************************************************
-- * >> self: the boss bar layer.                                     *
-- ********************************************************************
-- * Update the boss bar layer. Important to be called when resizing  *
-- * its parent. If no parent is defined, the layer will be hidden.   *
-- ********************************************************************
local function Update(self)
    if type(self) ~= "table" then return; end

    local parent, priority, endPortion = self.parent, self.priority, self.endPortion;

    if type(parent) ~= "table" then
        self:Hide();
        return;
    end

    local width = parent:GetWidth() - 4;

    self:SetParent(parent);
    self:SetFrameLevel(parent:GetFrameLevel() + priority);
    self:SetWidth(width);
    self:SetPoint("LEFT", parent, "LEFT", 2, 2);

    if ( endPortion == 0 ) then
        self:Hide();
  else
        local littleThreshold = 8/width;
        local middleThreshold = 1 - 16/width;

        local leftLittleCoeff = min(1, self.endPortion / littleThreshold);
        local middleCoeff = max(0, min(1, (self.endPortion - littleThreshold) / middleThreshold));
        local rightLittleCoeff = max(0, min(1, (self.endPortion - (1-littleThreshold)) / littleThreshold));

        if ( leftLittleCoeff > 0 ) then
            self.left:ClearAllPoints();
            self.left:SetTexCoord(0, (8 * leftLittleCoeff)/32, 0, 1);
            self.left:SetWidth(8 * leftLittleCoeff);
            self.left:SetPoint("LEFT", self, "LEFT", 0, 0);
            self.left:Show();
      else
            self.left:Hide();
        end
        if ( middleCoeff > 0 ) then
            self.middle:ClearAllPoints();
            self.middle:SetTexCoord(8/32, 16/32, 0, 1);
            self.middle:SetWidth((width-16) * middleCoeff);
            self.middle:SetPoint("LEFT", self.left, "RIGHT", 0, 0);
            self.middle:Show();
      else
            self.middle:Hide();
        end
        if ( rightLittleCoeff > 0 ) then
            self.right:ClearAllPoints();
            self.right:SetTexCoord(16/32, (16 + 8 * rightLittleCoeff)/32, 0, 1);
            self.right:SetWidth(8 * rightLittleCoeff);
            self.right:SetPoint("LEFT", self.middle, "RIGHT", 0, 0);
            self.right:Show();
      else
            self.right:Hide();
        end

        self:Show();
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function BossBarLayer.OnLoad(self)
    local height = 8;
    self:SetHeight(height);

    -- Children
    self.left = self:CreateTexture(nil, "BACKGROUND");
    self.left:SetTexture(TEXTURE);
    self.left:SetHeight(height);
    self.left:Show();
    self.middle = self:CreateTexture(nil, "BACKGROUND");
    self.middle:SetTexture(TEXTURE);
    self.middle:SetHeight(height);
    self.middle:Show();
    self.right = self:CreateTexture(nil, "BACKGROUND");
    self.right:SetTexture(TEXTURE);
    self.right:SetHeight(height);
    self.right:Show();

    -- Properties
    self.parent = nil;
    self.priority = 1;
    self.endPortion = 0;

    -- Methods
    self.Setup = Setup;
    self.SetPortion = SetPortion;
    self.ChangeColor = ChangeColor;
    self.Update = Update;

    self:Update();
end