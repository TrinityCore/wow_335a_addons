local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Manager = Root.GetOrNewModule("Manager");
local RaidFrameSearcher = Root.GetOrNewModule("RaidFrameSearcher");

Widgets["HealAssist"] = { };
local HealAssist = Widgets["HealAssist"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

local OPEN_TIME = 0.300;
local CLOSE_TIME = 0.300;

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local layouts = {
    ["RECTANGLE"] = {
        texture = Root.folder.."gfx\\HealAssist",
        rate = 0.05,
        frames = 7,
        horizontal = 58/64,
        ratio = 1.75, -- Width divided by height
    },
    ["RECTANGLE-WIDE"] = {
        texture = Root.folder.."gfx\\HealAssist2W",
        rate = 0.05,
        frames = 6,
        horizontal = 1,
        ratio = 4,
    },
    ["SQUARE"] = {
        texture = Root.folder.."gfx\\HealAssist2",
        rate = 0.05,
        frames = 6,
        horizontal = 1,
        ratio = 1,
    },
};

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Start(guid)                                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the heal assist widget.                                 *
-- * >> guid: the GUID of the guy that must receive heals.            *
-- ********************************************************************
-- * Activate a heal assist widget. This widget places an animated    *
-- * red border around the raid frame of the guy that needs healing.  *
-- ********************************************************************
local function Start(self, guid)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    -- Find the raid frame of this player.
    local parent, ofsX, ofsY, expX, expY, layout = RaidFrameSearcher:SearchFrame(guid);
    if ( not parent ) then return; end

    self:SetParent(parent);

    local width, height = parent:GetWidth() + expX, parent:GetHeight() + expY;

    -- Set the correct texture & animation data
    layout = layout or self:GetRecommandedShape(width, height);
    local animData = layouts[layout];
    self.texture:SetTexture(animData.texture);
    self.animMaxFrames = animData.frames;
    self.animRate = animData.rate;
    self.animHorizontal = animData.horizontal;

    -- Prepare the display vars
    self.status = "OPENING";
    self.timer = 0;
    self.animFrame = 0;
    self.animTimer = 0;

    -- Resize according to the raid frame properties.
    self:SetWidth(width);
    self:SetHeight(height);
    self.ofsX = ofsX;
    self.ofsY = ofsY;

    -- Start as green.
    self.colorStatus = "GREEN";
    self.colorTimer = 0;
    self.colorTimerMax = 0;

    -- And display the frame
    self:Show();
    HealAssist.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove([atOnce])                                            *
-- ********************************************************************
-- * >> self: the heal assist widget.                                 *
-- * >> atOnce: if set, the frame will be hidden instantly.           *
-- ********************************************************************
-- * Remove one heal assist widget.                                   *
-- ********************************************************************
local function Remove(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "OPENING" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        self.status = "CLOSING";
        self.timer = 0;
    end
end


-- ********************************************************************
-- * self:TurnRed(animDuration)                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the heal assist widget.                                 *
-- * >> animDuration: the amount of time to perform the color change. *
-- ********************************************************************
-- * Turn red the heal assist widget.                                 *
-- ********************************************************************
local function TurnRed(self, animDuration)
    if type(self) ~= "table" then return; end
    if ( self.status == "STANDBY" ) then return; end
    if ( self.colorStatus == "RED" ) then return; end

    self.colorStatus = "RED";
    self.colorTimer = animDuration;
    self.colorTimerMax = animDuration;
end

-- ********************************************************************
-- * self:GetStatus()                                                 *
-- ********************************************************************
-- * >> self: the heal assist widget.                                 *
-- ********************************************************************
-- * Get the current internal status of one heal assist widget.       *
-- * Can be either OPENING, RUNNING, CLOSING or STANDBY.              *
-- ********************************************************************
local function GetStatus(self)
    if type(self) ~= "table" then return; end
    return self.status;
end

-- ********************************************************************
-- * self:GetRecommandedShape(width, height)                          *
-- ********************************************************************
-- * >> self: the heal assist widget.                                 *
-- * >> width, height: the dimensions of the widget.                  *
-- ********************************************************************
-- * Determinate the ideal shape for the heal assist widget.          *
-- ********************************************************************
local function GetRecommandedShape(self, width, height)
    if type(self) ~= "table" then return; end

    local target = width / height;
    local closestDelta, closestLayout;
    local name, info, delta;

    closestDelta = 99999;
    closestLayout = "RECTANGLE";

    for name, info in pairs(layouts) do
        delta = math.abs(target - info.ratio);
        if ( delta < closestDelta ) then
            closestDelta = delta;
            closestLayout = name;
        end
    end

    return closestLayout;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function HealAssist.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.00;
    self.colorStatus = "GREEN";
    self.colorTimer = 0;
    self.colorTimerMax = 0;
    self.animFrame = 0;
    self.animTimer = 0;
    self.animMaxFrames = 1;
    self.animRate = 1;
    self.animHorizontal = 1;
    self.ofsX = 0;
    self.ofsY = 0;

    -- Methods
    self.Start = Start;
    self.Remove = Remove;
    self.TurnRed = TurnRed;
    self.GetStatus = GetStatus;
    self.GetRecommandedShape = GetRecommandedShape;

    -- Children
    self.texture = self:CreateTexture(nil, "OVERLAY");
    self.texture:SetAllPoints(self);
end

function HealAssist.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    local alpha = 1.00;

    -- Open / close
    if ( self.status == "OPENING" ) then
        self.timer = min(OPEN_TIME, self.timer + elapsed);
        alpha = self.timer / OPEN_TIME;
        if ( self.timer == OPEN_TIME ) then self.status = "RUNNING"; end
    end
    if ( self.status == "CLOSING" ) then
        self.timer = min(CLOSE_TIME, self.timer + elapsed);
        alpha = 1 - self.timer / CLOSE_TIME;
        if ( self.timer == CLOSE_TIME ) then self:Remove(true); end
    end

    -- Animation handling
    while ( self.animTimer <= 0.0 ) do
        self.animTimer = self.animTimer + self.animRate;
        self.animFrame = math.fmod(self.animFrame, self.animMaxFrames) + 1;
        self.texture:SetTexCoord(0, self.animHorizontal, (self.animFrame-1)/8, self.animFrame/8 - 0.001);
    end
    self.animTimer = self.animTimer - elapsed;

    -- Color handling
    self.colorTimer = max(0, self.colorTimer - elapsed);
    if ( self.colorStatus == "RED" ) then
        local progression = 1 - self.colorTimer / max(0.01, self.colorTimerMax);
        self.texture:SetVertexColor(progression, 1 - progression, 0);

elseif ( self.colorStatus == "GREEN" ) then
        self.texture:SetVertexColor(0, 1, 0);
    end

    self:ClearAllPoints();
    self:SetPoint("CENTER", self:GetParent(), "CENTER", self.ofsX, self.ofsY);
    self:SetAlpha(alpha);
end