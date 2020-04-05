local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");

Widgets["SpecialBar"] = { };
local SpecialBar = Widgets["SpecialBar"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local OPEN_TIME = 0.70;
local CLOSE_TIME = 0.40;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display([x, y, scale])                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the special bar.                                        *
-- * >> x: position of the X center of the special bar.               *
-- * >> y: position of the Y center of the special bar.               *
-- * >> scale: scale of the special bar.                              *
-- ********************************************************************
-- * Starts displaying the special bar.                               *
-- * N.B: x/y/scale parameters take precedence before                 *
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
    self.centerY = y or aY or 0.65;
    self.scale = scale or aScale or 1;

    self:Show();
    SpecialBar.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * >> self: the special bar.                                        *
-- * >> atOnce: if set, the special bar will be hidden instantly.     *
-- ********************************************************************
-- * Stops displaying the special bar.                                *
-- * Note that this WILL NOT stop the driver. As such, it can be used *
-- * to temporarily remove the special bar then display it again      *
-- * with the :Display method. If you want to completely release the  *
-- * special bar, do not forget to clear the driver task.             *
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
-- * >> self: the special bar.                                        *
-- ********************************************************************
-- * Get the driver of the current special bar.                       *
-- ********************************************************************
local function GetDriver(self)
    if type(self) ~= "table" then return; end

    return self.Driver;
end

-- ********************************************************************
-- * self:ChangeTitle(title)                                          *
-- ********************************************************************
-- * >> self: the special bar.                                        *
-- * >> title: the new title.                                         *
-- ********************************************************************
-- * Change the title of the special bar.                             *
-- ********************************************************************
local function ChangeTitle(self, title)
    if type(self) ~= "table" then return; end
    title = title or "";
    self.title:SetText(title);
end

-- ********************************************************************
-- * self:ChangeText(text)                                            *
-- ********************************************************************
-- * >> self: the special bar.                                        *
-- * >> title: the new text to display inside the bar.                *
-- ********************************************************************
-- * Change the text of the special bar.                              *
-- ********************************************************************
local function ChangeText(self, text)
    if type(self) ~= "table" then return; end
    text = text or "";
    self.text:SetText(text);
end

-- + :SetValue(value)
-- + :SetMinMaxValues(min, max)

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function SpecialBar.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.000;

    -- Methods
    self.Display = Display;
    self.Remove = Remove;
    self.GetDriver = GetDriver;
    self.ChangeTitle = ChangeTitle;
    self.ChangeText = ChangeText;

    -- Children
    self.title = Root.CreateFontString(self, "OVERLAY", "NormalYellow", nil, "MIDDLE", "MIDDLE");
    self.title:SetHeight(16);
    self.title:SetPoint("BOTTOM", self, "TOP", 0, 0);
    self.title:Show();

    self.text = Root.CreateFontString(self, "OVERLAY", "SmallWhite", nil, "MIDDLE", "MIDDLE");
    self.text:SetHeight(12);
    self.text:SetPoint("CENTER", self, "CENTER", 0, 0);
    self.text:Show();

    self.Driver = CreateFrame("Frame", nil, nil, "BossEncounter2_SpecialBarDriverTemplate");
    self.Driver:Setup(self);

    self:ChangeTitle("");
    self:ChangeText("");
end

function SpecialBar.OnUpdate(self, elapsed)
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

    -- Application on the frame
    local finalX, finalY = x * UIParent:GetWidth(), y * UIParent:GetHeight();
    self:ClearAllPoints();
    self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", finalX / self.scale, finalY / self.scale);
    self:SetScale(self.scale);
end