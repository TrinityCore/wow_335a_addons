local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");

Widgets["MajorText"] = { };
local MajorText = Widgets["MajorText"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local DEFAULT_YPOSITION = 0.70;
local NUM_TRAILS = 5;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display(text, time, power[, holdTime,                       *
-- *              removeTime, removePower])                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the major text frame.                                   *
-- * >> text: what is to be displayed.                                *
-- * >> time: the time it will take to the text to be centered.       *
-- * >> power: defines the kind of movement (linear if power = 1).    *
-- *                                                                  *
-- * The following args are optionnal. If you do not pass them, the   *
-- * text will stay until removed by the other methods:               *
-- * >> holdTime: the time the text will stay.                        *
-- * >> removeTime: the time it will take to the text to get out.     *
-- * >> removePower: the type of movement when getting out.           *
-- ********************************************************************
-- * Displays a major text on-screen, using a scroll                  *
-- * and a blur effect.                                               *
-- ********************************************************************
local function Display(self, text, time, power, holdTime, removeTime, removePower)
    if type(self) ~= "table" then return; end

    if ( self.status ~= "READY" ) then
        self:Clear();
    end

    if ( self.status == "READY" ) then
        -- Adjust Y position according to anchor.
        local aY = select(2, Anchor:GetAnchorInfo(self));
        if ( aY ) then
            self:ChangeYPosition(aY - (self:GetID()-1) * 0.05); -- Further texts will expend downward.
        end
        
        local i;
        for i=1, NUM_TRAILS do
            self.fontString[i]:SetText(text);
            self.fontString[i]:ClearAllPoints();
            self.fontString[i]:Hide();
        end

        self.offscreenFactorClip = Root.PxToPct("X", self.fontString[1]:GetStringWidth()) / 2;
        self.currentTime = 0;
        self.openTime = time;
        self.holdTime = holdTime;
        self.removeTime = removeTime;
        self.openPower = power;
        self.removePower = removePower;
        self.status = "OPENING";
        self:Show();
    end
end

-- ********************************************************************
-- * self:Release(removeTime, removePower)                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the major text frame.                                   *
-- * >> removeTime: the time it will take to the text to get out.     *
-- * >> removePower: the type of movement when getting out.           *
-- ********************************************************************
-- * Releases a major text that was undefinitely stuck on-screen.     *
-- ********************************************************************
local function Release(self, removeTime, removePower)
    if type(self) ~= "table" then return; end

    if ( self.status == "OPENING" or self.status == "HOLDING" ) then
        self.holdTime = 0;
        self.removeTime = removeTime;
        self.removePower = removePower;
    end
end

-- ********************************************************************
-- * self:Clear()                                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the major text frame.                                   *
-- ********************************************************************
-- * Instantly clears the major text.                                 *
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
-- * >> self: the major text frame.                                   *
-- * >> position: new vertical position, between 0~1. 0.5 is middle.  *
-- * If nil, the default position will be used.                       *
-- ********************************************************************
-- * Changes the Y position of the major text.                        *
-- ********************************************************************
local function ChangeYPosition(self, position)
    if type(self) ~= "table" then return; end

    self.yPosition = position or DEFAULT_YPOSITION;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function MajorText.OnLoad(self)
    -- Children
    self.fontString = { };
    local i;
    for i=1, NUM_TRAILS do
        self.fontString[i] = Root.CreateFontString(self, "OVERLAY", "Big", 32, "MIDDLE", "MIDDLE");
        self.fontString[i]:SetAlpha(1.0 - (i-1)*(1/NUM_TRAILS));
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

function MajorText.OnUpdate(self, elapsed)
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

    local leadTexturePosition = 0.500; -- 0.5 <-> Middle screen (on X-axis)

    if ( self.status == "OPENING" ) then
        leadTexturePosition = 0.500 + (0.500 + self.offscreenFactorClip) * (1 - self.currentTime / self.openTime) ^ self.openPower;

elseif ( self.status == "CLOSING" ) then
        leadTexturePosition = 0.500 - (0.500 + self.offscreenFactorClip) * (self.currentTime / self.removeTime) ^ self.removePower;
    end

    self.fontString[1]:ClearAllPoints();
    self.fontString[1]:SetPoint("CENTER", self, "BOTTOMLEFT", Root.PctToPx("X", leadTexturePosition), Root.PctToPx("Y", self.yPosition));
    self.fontString[1]:Show();

    local i;
    for i=NUM_TRAILS, 2, -1 do
        if ( self.fontString[i-1]:GetNumPoints() > 0 ) then
            local point, relativeTo, relativePoint, xOfs, yOfs = self.fontString[i-1]:GetPoint(1);
            self.fontString[i]:ClearAllPoints();
            self.fontString[i]:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs);
            self.fontString[i]:Show();
      else
            self.fontString[i]:Hide();
        end
    end
end
