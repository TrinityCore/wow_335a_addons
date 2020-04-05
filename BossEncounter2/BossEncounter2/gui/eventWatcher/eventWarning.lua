local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");

Widgets["EventWarning"] = { };
local EventWarning = Widgets["EventWarning"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local BORDER_TEXTURE = Root.folder.."gfx\\EventWarningBorder";

local FADE_TIMER = 0.300;
local FADE_OFFSET = 0.06; -- Horizontal offset in %

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display(count, label[, x, y, scale])                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event warning.                                      *
-- * >> count: the amount of seconds to count. Should be 5 or 10.     *
-- * >> label: the label of the event.                                *
-- * >> x: position of the X center of the event warning.             *
-- * >> y: position of the Y center of the event warning.             *
-- * >> scale: the scale of the event warning.                        *
-- ********************************************************************
-- * Displays a more detailled event warning.                         *
-- ********************************************************************
local function Display(self, count, label, x, y, scale)
    if type(self) ~= "table" or ( not count ) then return; end
    if ( not self:IsFree() ) then return; end
    label = label or "";

    self.expire = GetTime() + count;

    self.timer = FADE_TIMER;
    self.status = "FADE_IN";

    -- Anchor and adjust according to the ID of the event warning.
    local aX, aY, aScale = Anchor:GetAnchorInfo(self);
    self.centerX = x or aX or 0.50;
    self.centerY = y or aY or 0.37;
    self.scale = scale or aScale or 1;
    self.centerY = self.centerY + (self:GetID()-1) * Root.PxToPct("Y", 72 * self.scale);

    self.PieTimer:Start(count);
    self.text:SetText(label);

    self:Show();
    EventWarning.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event warning.                                      *
-- * >> atOnce: if set, the event warning will be instantly removed.  *
-- ********************************************************************
-- * Remove an event warning.                                         *
-- ********************************************************************
local function Remove(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "FADE_IN" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.PieTimer:Stop();

        self.status = "STANDBY";
        self:Hide();
  else
        self.status = "FADE_OUT";
        self.timer = FADE_TIMER;
    end
end

-- ********************************************************************
-- * self:IsFree()                                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event warning.                                      *
-- ********************************************************************
-- * Determinate if a given event warning can be used.                *
-- ********************************************************************
local function IsFree(self)
    if type(self) ~= "table" then return false; end
    return (self.status ~= "FADE_IN" and self.status ~= "RUNNING");
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function EventWarning.OnLoad(self)
    -- Properties
    self.expire = nil;
    self.timer = 0;
    self.status = "STANDBY";

    -- Methods
    self.Display = Display;
    self.Remove = Remove;
    self.IsFree = IsFree;

    -- Children
    self.border = self:CreateTexture(nil, "BORDER");
    self.border:ClearAllPoints();
    self.border:SetWidth(256);
    self.border:SetHeight(64);
    self.border:SetPoint("RIGHT", self, "RIGHT", 0, 0);
    self.border:SetTexture(BORDER_TEXTURE);
    self.border:Show();

    self.text = Root.CreateFontString(self, "OVERLAY", "NormalYellow", nil, "MIDDLE", "BOTTOM");
    self.text:SetWidth(216);
    self.text:SetPoint("BOTTOM", self, "BOTTOMRIGHT", -130, 18);
    self.text:SetText("");
    self.text:Show(); 

    self.PieTimer = CreateFrame("Frame", nil, self, "BossEncounter2_EventWarningPieTimerTemplate");
    self.PieTimer:SetPoint("LEFT", self, "LEFT", 0, 0);

    -- Initial state
    self:Hide();
end

function EventWarning.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    if ( self.status == "FADE_IN" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then self.status = "RUNNING"; end
    end
    if ( self.status == "RUNNING" ) and ( self.expire ) then
        if ( GetTime() > self.expire ) then
            self:Remove(false);
        end
    end
    if ( self.status == "FADE_OUT" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then self:Remove(true); end
    end

    -- Positionning handling
    local x, y = self.centerX, self.centerY; -- If not moving.
    local alpha = 1.0;
    local progression, gxProgression;

    if ( self.status == "FADE_IN" ) then
        progression = 1 - self.timer / FADE_TIMER;
        if ( progression < 0.7 ) then
            gxProgression = progression ^ 0.5 * 1.2;
      else
            local x = progression - 0.7;
            gxProgression = -8.88 * x * x + 2.67 * x + 1;
        end
        x = x + FADE_OFFSET * (1 - gxProgression);
        alpha = progression;

  elseif ( self.status == "FADE_OUT" ) then
        progression = 1 - self.timer / FADE_TIMER;
        gxProgression = progression ^ 2;
        x = x - FADE_OFFSET * gxProgression;
        alpha = 1 - progression;
    end

    -- Application on the frame
    local finalX, finalY = x * UIParent:GetWidth(), y * UIParent:GetHeight();
    self:ClearAllPoints();
    self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", finalX / self.scale, finalY / self.scale);
    self:SetScale(self.scale);
    self:SetAlpha(alpha);
end