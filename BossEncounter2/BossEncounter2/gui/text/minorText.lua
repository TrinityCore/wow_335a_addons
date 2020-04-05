local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");

Widgets["MinorText"] = { };
local MinorText = Widgets["MinorText"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local DEFAULT_YPOSITION = 0.74;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display(text, openTime[, holdTime, removeTime])             *
-- *                                                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the minor text frame.                                   *
-- * >> text: what is to be displayed.                                *
-- * >> openTime: the time it will take to the text to apparear.      *
-- *                                                                  *
-- * The following args are optionnal. If you do not pass them, the   *
-- * text will stay until removed by the other methods:               *
-- * >> holdTime: the time the text will stay.                        *
-- * >> removeTime: the time it will take to the text to fade out.    *
-- ********************************************************************
-- * Displays a minor text on-screen.                                 *
-- ********************************************************************
local function Display(self, text, openTime, holdTime, removeTime)
    if type(self) ~= "table" then return; end

    if ( self.status ~= "READY" ) then
        self:Clear();
    end

    if ( self.status == "READY" ) then
        -- Adjust Y position according to anchor.
        local aY = select(2, Anchor:GetAnchorInfo(self));
        if ( aY ) then
            self:ChangeYPosition(aY - (self:GetID()-1) * 0.04); -- Further texts will expend downward.
        end
        
        local i;
        for i=1, 2 do
            self.fontString[i]:SetText(text);
            self.fontString[i]:ClearAllPoints();
            self.fontString[i]:Hide();
        end

        self.currentTime = 0;
        self.openTime = openTime;
        self.holdTime = holdTime;
        self.removeTime = removeTime;

        self.status = "OPENING";
        self:Show();
    end
end

-- ********************************************************************
-- * self:Release(removeTime)                                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the minor text frame.                                   *
-- * >> removeTime: the time it will take to the text to get out.     *
-- ********************************************************************
-- * Releases a minor text that was undefinitely stuck on-screen.     *
-- ********************************************************************
local function Release(self, removeTime)
    if type(self) ~= "table" then return; end

    if ( self.status == "OPENING" or self.status == "HOLDING" ) then
        self.holdTime = 0;
        self.removeTime = removeTime;
    end
end

-- ********************************************************************
-- * self:Clear()                                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the minor text frame.                                   *
-- ********************************************************************
-- * Instantly clears the minor text.                                 *
-- ********************************************************************
local function Clear(self)
    if type(self) ~= "table" then return; end

    self:Hide();
    self.status = "READY";
end

-- ********************************************************************
-- * self:ChangeYPosition([position])                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the minor text frame.                                   *
-- * >> position: new vertical position, between 0~1. 0.5 is middle.  *
-- * If nil, the default position will be used.                       *
-- ********************************************************************
-- * Changes the Y position of the minor text.                        *
-- ********************************************************************
local function ChangeYPosition(self, position)
    if type(self) ~= "table" then return; end

    self.yPosition = position or DEFAULT_YPOSITION;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function MinorText.OnLoad(self)
    -- Children
    self.fontString = { };
    local i;
    for i=1, 2 do
        self.fontString[i] = Root.CreateFontString(self, "OVERLAY", "Big", 28, "MIDDLE", "MIDDLE");
    end

    -- Properties
    self.status = "READY";
    self.yPosition = DEFAULT_YPOSITION;

    -- Methods
    self.Display = Display;
    self.Release = Release;
    self.Clear = Clear;
    self.ChangeYPosition = ChangeYPosition;
end

function MinorText.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end
    if ( self.status == "READY" ) then self:Hide(); return; end

    -- Status transition

    self.currentTime = self.currentTime + elapsed;

    if ( self.status == "OPENING" ) then
        if ( self.currentTime >= self.openTime ) then
            self.currentTime = 0;
            self.status = "HOLDING";
        end

elseif ( self.status == "HOLDING" ) then
        if ( self.holdTime ) then
            if ( self.currentTime >= self.holdTime ) then
                self.currentTime = 0;
                self.status = "CLOSING";
            end
        end

elseif ( self.status == "CLOSING" ) then
        if ( self.currentTime >= self.removeTime ) then
            self.currentTime = 0;
            self:Clear();
            return;
        end
    end

    -- Now update properties

    local alpha = 1.000;

    if ( self.status == "OPENING" ) then
        alpha = self.currentTime / self.openTime;

elseif ( self.status == "CLOSING" ) then
        alpha = 1 - self.currentTime / self.removeTime;
    end

    local i, offset;
    for i=1, 2 do
        offset = (1 - alpha) * 32;
        self.fontString[i]:ClearAllPoints();
        self.fontString[i]:SetAlpha(alpha);
        self.fontString[i]:SetPoint("CENTER", self, "CENTER", -offset * (-1)^i, -offset * (-1)^i + Root.PctToPx("Y", self.yPosition - 0.5));
        if ( alpha < 1 ) or ( i == 1 ) then
            self.fontString[i]:Show();
      else
            self.fontString[i]:Hide();
        end
    end
end
