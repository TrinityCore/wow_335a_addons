local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["BossBarThreshold"] = { };
local BossBarThreshold = Widgets["BossBarThreshold"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local TAG = Root.folder.."gfx\\HealthThresholdTag";

local NUM_TAGS = 5;

local FADE_TIME = 0.500;
local BOUNCE_TIME = 1.000;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(parent, level, bubbleLevel)                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar threshold frame.                           *
-- * >> parent: the boss bar the threshold frame belongs to.          *
-- * >> level: how many frame levels the threshold frame gets raised. *
-- * >> bubbleLevel: same thing for the bubble.                       *
-- ********************************************************************
-- * Setup a boss bar threshold frame.                                *
-- * Health thresholds and explanation bubble get all displayed on    *
-- * this frame.                                                      *
-- ********************************************************************
local function Setup(self, parent, level, bubbleLevel)
    if type(self) ~= "table" or type(parent) ~= "table" then return; end

    self.parent = parent;
    self:SetParent(parent);
    self:SetFrameLevel(parent:GetFrameLevel() + level);
    self.bubble:SetFrameLevel(parent:GetFrameLevel() + bubbleLevel);
    self:Clear();
end

-- ********************************************************************
-- * self:Clear(instantly)                                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar threshold frame.                           *
-- * >> instantly: do we remove instantly all defined thresholds?     *
-- ********************************************************************
-- * Change the portion of the bar layer that will be drawn.          *
-- ********************************************************************
local function Clear(self, instantly)
    if type(self) ~= "table" then return; end

    local i, tag;
    for i=1, NUM_TAGS do
        tag = self.tags[i];
        tag.label = nil;
        if ( instantly ) then
            tag.alpha = 0;
        end
    end

    self:HideBubble(instantly);
end

-- ********************************************************************
-- * self:Add(position, label, value)                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar threshold frame.                           *
-- * >> position: position of the new threshold tag.                  *
-- * Must be between 0~1, 1 means the extreme right of the bar.       *
-- * >> label: the label used to identify the tag.                    *
-- * >> value: the health ratio at which the tag is triggered.        *
-- ********************************************************************
-- * Add a new visible threshold tag.                                 *
-- * Return true if the tag was successfully displayed.               *
-- ********************************************************************
local function Add(self, position, label, value)
    if type(self) ~= "table" then return; end

    local tag = self:GetFree();
    if ( not tag ) then return false; end

    tag.label = label;
    tag.alpha = 0;
    tag.position = position;
    tag.percentage = math.floor(value * 100 + 0.499);

    return true;
end

-- ********************************************************************
-- * self:Remove(label, instantly)                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar threshold frame.                           *
-- * >> label: the label used to identify the tag to remove.          *
-- * >> instantly: do we remove instantly the threshold tag?          *
-- ********************************************************************
-- * Add a new visible threshold tag.                                 *
-- ********************************************************************
local function Remove(self, label, instantly)
    if type(self) ~= "table" then return; end

    local tag = self:Find(label);
    if ( not tag ) then return; end

    tag.label = nil;
    if ( instantly ) then
        tag.alpha = 0;
    end

    if ( label == self.bubble.label ) then
        self:HideBubble(instantly);
    end
end

-- ********************************************************************
-- * self:GetFree()                                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar threshold frame.                           *
-- ********************************************************************
-- * Try to get a free tag slot.                                      *
-- ********************************************************************
local function GetFree(self)
    if type(self) ~= "table" then return; end

    local i, tag;
    for i=1, NUM_TAGS do
        tag = self.tags[i];
        if ( not tag.label ) and ( tag.alpha == 0 ) then
            return tag;
        end
    end
    return nil;
end

-- ********************************************************************
-- * self:Find(label)                                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar threshold frame.                           *
-- * >> label: the label to look for.                                 *
-- ********************************************************************
-- * Try to find a threshold tag with a given label.                  *
-- ********************************************************************
local function Find(self, label)
    if type(self) ~= "table" then return; end

    local i, tag;
    for i=1, NUM_TAGS do
        tag = self.tags[i];
        if ( tag.label == label ) then
            return tag;
        end
    end
    return nil;
end

-- ********************************************************************
-- * self:ShowBubble(label)                                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar threshold frame.                           *
-- * >> label: the label the bubble is linked to.                     *
-- ********************************************************************
-- * Add a new visible threshold tag.                                 *
-- ********************************************************************
local function ShowBubble(self, label)
    if type(self) ~= "table" then return; end

    local bubble = self.bubble;
    if ( bubble.label == label ) then
        return;
    end

    local tag = self:Find(label);
    if ( not tag ) then return; end

    bubble.alpha = 0;
    bubble.position = tag.position;
    bubble.label = label;
    bubble.bounceTimer = 0;
    bubble.text:SetText(string.format("%d%% - %s", tag.percentage, label));

    local textWidth = bubble.text:GetStringWidth();
    bubble:SetWidth(textWidth + 32);
end

-- ********************************************************************
-- * self:HideBubble(instantly)                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar threshold frame.                           *
-- * >> instantly: do we remove instantly the bubble?                 *
-- ********************************************************************
-- * Remove the bubble.                                               *
-- ********************************************************************
local function HideBubble(self, instantly)
    if type(self) ~= "table" then return; end

    local bubble = self.bubble;
    if ( not bubble.label ) then
        return;
    end

    bubble.label = nil;
    if ( instantly ) then
        bubble.alpha = 0;
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function BossBarThreshold.OnLoad(self)
    -- Children
    local i, tag;
    self.tags = { };
    for i=1, NUM_TAGS do
        tag = self:CreateTexture(nil, "BACKGROUND");
        tag.alpha = 0;
        tag.position = 0;
        tag.label = nil;
        tag.percentage = 0;
        tag:SetTexture(TAG);
        tag:SetWidth(8);
        tag:SetHeight(16);
        tag:SetTexCoord(0, 1, 16/32, 32/32);
        -- tag:SetWidth(8);
        -- tag:SetHeight(24);

        self.tags[i] = tag;
    end

    local bubble = CreateFrame("Frame", nil, self);
    bubble.alpha = 0;
    bubble.position = 0;
    bubble.label = nil;
    bubble.bounceTimer = 0;
    bubble:SetHeight(32);
    bubble.text = Root.CreateFontString(bubble, "OVERLAY", "NormalYellow", nil, "MIDDLE", "MIDDLE");
    bubble.text:SetAllPoints(true);
    bubble.text:Show();
    Root.SetBackdrop(bubble, "BUBBLE");
    self.bubble = bubble;

    -- Properties
    self.parent = nil;

    -- Methods
    self.Setup = Setup;
    self.Clear = Clear;
    self.Add = Add;
    self.Remove = Remove;
    self.GetFree = GetFree;
    self.Find = Find;
    self.ShowBubble = ShowBubble;
    self.HideBubble = HideBubble;
end

function BossBarThreshold.OnUpdate(self, elapsed)
    local parent = self.parent;
    if ( not parent ) then return; end

    -- Handle the bubble

    local bubble = self.bubble;
    if ( bubble.label ) then
        bubble.alpha = min(1, bubble.alpha + elapsed / FADE_TIME);
        bubble.bounceTimer = math.fmod(bubble.bounceTimer + elapsed, BOUNCE_TIME);
  else
        bubble.alpha = max(0, bubble.alpha - elapsed / FADE_TIME);
    end

    local bounce = sin(bubble.bounceTimer / BOUNCE_TIME * 180);

    bubble:SetAlpha(bubble.alpha);
    bubble:SetPoint("BOTTOM", parent, "TOPLEFT", parent:GetWidth() * bubble.position, 6 + bounce * 4);

    -- Handle each tag

    local i, tag;
    for i=1, NUM_TAGS do
        tag = self.tags[i];
        if ( tag.label ) then
            tag.alpha = min(1, tag.alpha + elapsed / FADE_TIME);
      else
            tag.alpha = max(0, tag.alpha - elapsed / FADE_TIME);
        end
        if ( tag.label == bubble.label ) then -- This tag is being developped by the bubble.
            tag:SetVertexColor(1-bounce, 1-bounce, 1-bounce);
      else
            tag:SetVertexColor(1, 1, 1);   
        end
        tag:SetAlpha(tag.alpha);
        tag:SetPoint("CENTER", parent, "LEFT", parent:GetWidth() * tag.position - 0.5, -2); -- , 2);
    end
end
