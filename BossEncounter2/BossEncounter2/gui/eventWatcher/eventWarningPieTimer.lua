local Root = BossEncounter2;
local Preload = Root.GetOrNewModule("Preload");
local Widgets = Root.GetOrNewModule("Widgets");

Widgets["EventWarningPieTimer"] = { };
local EventWarningPieTimer = Widgets["EventWarningPieTimer"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local BORDER_TEXTURE = Root.folder.."gfx\\PieTimerBorder";
local PIE_QUARTER_TEXTURE = Root.folder.."gfx\\PieTimer";
local FLASH_TEXTURE = Root.folder.."gfx\\Halo";

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Start(count)                                                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the pie timer.                                          *
-- * >> count: the amount of seconds to count. Should be 5 or 10.     *
-- ********************************************************************
-- * Displays a timer inside a pie that gets smaller and smaller as   *
-- * the time runs out.                                               *
-- ********************************************************************
local function Start(self, count)
    if type(self) ~= "table" or ( not count ) then return; end

    self.lastDigit = nil;
    self.timer = count;
    self.start = GetTime();

    EventWarningPieTimer.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Stop()                                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the pie timer.                                          *
-- ********************************************************************
-- * Stop the timer.                                                  *
-- ********************************************************************
local function Stop(self)
    if type(self) ~= "table" then return; end

    self.timer = nil;
    self.start = nil;

    EventWarningPieTimer.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:SetPie(ratio)                                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the pie timer.                                          *
-- * >> ratio: the radio of the pie filled.                           *
-- ********************************************************************
-- * Set the pie graphic on the pie timer.                            *
-- ********************************************************************
local function SetPie(self, ratio)
    if type(self) ~= "table" or ( not ratio ) then return; end

    local i, pie;
    local partZero, partFull, partFill;
    for i=1, 4 do
        pie = self.pieParts[i];

        -- Calculate the part filled for each pie quarter.
        partZero = (4-i) * 0.25;
        partFull = (5-i) * 0.25;
        if ( ratio <= partZero ) then 
            partFill = 0;
    elseif ( ratio >= partFull ) then
            partFill = 1;
      else
            partFill = (ratio - partZero) / (partFull - partZero);
        end

        -- Select the right image and rotate appropriately.

        pieImage = math.floor(16 - partFill * 16 + 0.5);
        if ( pieImage < 16 ) then
            pie:SetTexCoord(self:GetPieTexCoords(pieImage, (i-1)*(-90)));
            pie:Show();
      else
            pie:Hide();
        end
    end
end

-- ********************************************************************
-- * self:GetPieTexCoords(image, angle)                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the pie timer.                                          *
-- * >> image: the image to select on the texture. Between 0-15.      *
-- * >> angle: the angle. Must be either 0°, 90°, 180° or 270°.       *
-- ********************************************************************
-- * Find appropriate texture coordinates for the pie texture.        *
-- ********************************************************************
local function GetPieTexCoords(self, image, angle)
    local x = math.fmod(image, 4);
    local y = math.floor(image / 4);
    local cx = 0.125 + x * 0.25;
    local cy = 0.125 + y * 0.25;

    local s = 0.125 - 0.5/256;

    angle = math.fmod(angle+360, 360);

    if ( angle == 0 ) then
        return cx-s, cx+s, cy-s, cy+s;
elseif ( angle == 90 ) then
        return cx-s, cy+s, cx+s, cy+s, cx-s, cy-s, cx+s, cy-s;
elseif ( angle == 180 ) then 
        return cx+s, cx-s, cy+s, cy-s;
elseif ( angle == 270 ) then
        return cx+s, cy-s, cx-s, cy-s, cx+s, cy+s, cx-s, cy+s;
    end
    return 0, 0, 0, 0;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function EventWarningPieTimer.OnLoad(self)
    -- Properties
    self.lastDigit = nil;
    self.timer = nil;
    self.start = nil;

    -- Methods
    self.Start = Start;
    self.Stop = Stop;
    self.SetPie = SetPie;
    self.GetPieTexCoords = GetPieTexCoords;

    -- Children
    local i;
    self.pieParts = { };
    for i=1, 4 do
        self.pieParts[i] = self:CreateTexture(nil, "ARTWORK");
        self.pieParts[i]:SetWidth(self:GetWidth()/2);
        self.pieParts[i]:SetHeight(self:GetHeight()/2);
        self.pieParts[i]:SetTexture(PIE_QUARTER_TEXTURE);
        self.pieParts[i]:Show(); 
    end
    self.pieParts[1]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0);
    self.pieParts[2]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0);
    self.pieParts[3]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
    self.pieParts[4]:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0);

    self.border = self:CreateTexture(nil, "BORDER");
    self.border:SetWidth(self:GetWidth()*1.25);
    self.border:SetHeight(self:GetHeight()*1.25);
    self.border:SetPoint("CENTER", self, "CENTER", 0, 0);
    self.border:SetTexture(BORDER_TEXTURE);
    self.border:Show();

    self.halo = self:CreateTexture(nil, "BACKGROUND");
    self.halo:SetWidth(self:GetWidth()*3.5);
    self.halo:SetHeight(self:GetHeight()*3.5);
    self.halo:SetPoint("CENTER", self, "CENTER", 0, 0);
    self.halo:SetTexture(FLASH_TEXTURE);
    self.halo:Show();

    self.timerText = Root.CreateFontString(self, "OVERLAY", "Big", 26, "MIDDLE", "MIDDLE");
    self.timerText:SetPoint("CENTER", self, "CENTER", 0, 1);
    self.timerText:SetText("");
    self.timerText:Show(); 

    self:SetPie(0);

    self:Show();
end

function EventWarningPieTimer.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.start ) then
        local timeLeft = min(self.timer, max(0, self.timer - GetTime() + self.start));
        local digit = math.floor(timeLeft+0.99);

        if ( self.lastDigit ) and ( self.lastDigit ~= digit ) then
            Root.Sound.Play("TICK");
        end
        self.lastDigit = digit;

        self.timerText:SetText(digit);

        self:SetPie(timeLeft / self.timer);
    end

    Root.RotateTexture(self.halo, GetTime() * 45);
end

-- --------------------------------------------------------------------
-- **                             Preload                            **
-- --------------------------------------------------------------------

do
    -- We add here heavy textures that should not be loaded on the fly while in combat to avoid a performance loss.
    Preload:Add(BORDER_TEXTURE);
    Preload:Add(PIE_QUARTER_TEXTURE);
    Preload:Add(FLASH_TEXTURE);
end