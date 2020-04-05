local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");

Widgets["StatusFrame"] = { };
local StatusFrame = Widgets["StatusFrame"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local CLOCK = Root.folder.."gfx\\Clock";

local CLOCK_ANIMATION_RATE = 1/12;

local STATUS_BLINK_TIMER = 3.00;
local CLOCK_COLOR_TIMER = 1.00;

local FADE_TIME = 1.00;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display([x, y, scale])                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the status frame.                                       *
-- * >> x: position of the X center of the status frame.              *
-- * >> y: position of the Y center of the status frame.              *
-- * >> scale: the scale of the status frame.                         *
-- ********************************************************************
-- * Starts displaying the status frame.                              *
-- * N.B: x/y/scale parameters take precedence before                 *
-- * anchor positions.                                                *
-- ********************************************************************
local function Display(self, x, y, scale)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    self.status = "OPENING";
    self.timer = FADE_TIME;

    local aX, aY, aScale = Anchor:GetAnchorInfo(self);
    self.centerX = x or aX or 0.50;
    self.centerY = y or aY or (1 - (16 + self:GetHeight()/2) / UIParent:GetHeight());
    self.scale = scale or aScale or 1;

    self.clockFrame = -1;
    self.clockTimer = 0;
    self.clockAnimated = false;
    self.clockBlinking = false;
    self.clockClockwise = 0;
    self.statusBlinkTimer = 0;

    self:SetTitle("");
    self:SetStatus("TEXT", "", false);

    self:Show();
    StatusFrame.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * >> self: the status frame.                                       *
-- * >> atOnce: if set, the status frame will be hidden instantly.    *
-- ********************************************************************
-- * Stops displaying the status frame.                               *
-- * Services like the watch will have to be stopped separately.      *
-- ********************************************************************
local function Remove(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "OPENING" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        self:SetBlinking(false); -- Force watch text blinking off.
        self.status = "CLOSING";
        self.timer = FADE_TIME;
    end
end

-- ********************************************************************
-- * self:GetDriver()                                                 *
-- ********************************************************************
-- * >> self: the status frame.                                       *
-- ********************************************************************
-- * Get the driver of the current status frame.                      *
-- * The driver controls the watch of the status frame.               *
-- ********************************************************************
local function GetDriver(self)
    if type(self) ~= "table" then return; end

    return self.Driver;
end

-- ********************************************************************
-- * self:StartClock(mode)                                            *
-- ********************************************************************
-- * >> self: the status frame.                                       *
-- * >> mode: 0 = counterclockwise, 1 = clockwise, nil = last used.   *
-- ********************************************************************
-- * Start or resume the clock ticking. This method is purely         *
-- * graphical: to really count the time up (or down) you have to use *
-- * the driver of the status frame.                                  *
-- ********************************************************************
local function StartClock(self, mode)
    if type(self) ~= "table" then return; end

    self.clockAnimated = true;
    self.clockClockwise = mode or self.clockClockwise or 0;
end

-- ********************************************************************
-- * self:StopClock()                                                 *
-- ********************************************************************
-- * >> self: the status frame.                                       *
-- ********************************************************************
-- * Stop the clock ticking.                                          *
-- ********************************************************************
local function StopClock(self)
    if type(self) ~= "table" then return; end

    self.clockAnimated = false;
end

-- ********************************************************************
-- * self:SetBlinking(state)                                          *
-- ********************************************************************
-- * >> self: the status frame.                                       *
-- * >> state: if set, makes the watch text blink. Nil/false to stop. *
-- ********************************************************************
-- * Start/stop making the watch text blinking.                       *
-- ********************************************************************
local function SetBlinking(self, state)
    if type(self) ~= "table" then return; end

    self.clockBlinking = state;
end

-- ********************************************************************
-- * self:SetTitle(text)                                              *
-- ********************************************************************
-- * >> self: the status frame.                                       *
-- * >> text: the title text.                                         *
-- ********************************************************************
-- * Change the title text. It is highly recommanded to call this     *
-- * method right after using Display method as the title will be     *
-- * otherwise an empty string.                                       *
-- ********************************************************************
local function SetTitle(self, text)
    if type(self) ~= "table" then return; end

    self.title:SetText(text);
end

-- ********************************************************************
-- * self:SetStatus(type, parameter, blink)                           *
-- ********************************************************************
-- * >> self: the status frame.                                       *
-- * >> statusType: the kind of status to display.                    *
-- * Can be either TEXT or PHASE.                                     *
-- * If you use TEXT, parameter should be what to display.            *
-- * The text will be justified in the middle.                        *
-- * If you use PHASE, parameter should be the phase number.          *
-- * >> blink: if set, the text will also blink briefly.              *
-- * For PHASE blinks, only the phase number will blink.              *
-- ********************************************************************
-- * Change the status text. It is highly recommanded to call this    *
-- * method right after using Display method as the status will be    *
-- * otherwise an empty string.                                       *
-- ********************************************************************
local function SetStatus(self, statusType, parameter, blink)
    if type(self) ~= "table" then return; end

    if ( statusType == "TEXT" ) then
        self.statusMain:SetText(parameter or "");
        self.statusMain:SetWidth(112);
        self.statusMain:SetPoint("TOP", self, "TOP", 0, -30);
        self.statusMain:Show();

        self.statusAlt:Hide();

  elseif ( statusType == "PHASE" ) then
        self.statusMain:SetText(parameter or "?");
        self.statusMain:SetWidth(32);
        self.statusMain:SetPoint("TOP", self, "TOP", 32, -29); -- Numbers are abnormally low. Raise them a little.
        self.statusMain:Show();

        self.statusAlt:SetText(Root.Localise("Phase"));
        self.statusAlt:SetWidth(64);
        self.statusAlt:SetPoint("TOP", self, "TOP", -16, -30);
        self.statusAlt:Show();
    end

    if ( blink ) then
        self.statusBlinkTimer = STATUS_BLINK_TIMER;
    end
end

-- ********************************************************************
-- * self:ChangeSecureCommand(macroText)                              *
-- ********************************************************************
-- * >> self: the status frame.                                       *
-- * >> text: the macro text that is to be executed when clicking     *
-- * the secure button.                                               *
-- ********************************************************************
-- * Change the macro text of the secure button of the status frame.  *
-- * The macro will be enabled once the combat mode starts.           *
-- * Input nil to completely hide the button.                         *
-- ********************************************************************
local function ChangeSecureCommand(self, macroText)
    if type(self) ~= "table" then return; end
    local button = self.secureButton;
    button.command = macroText;
    button.needUpdate = true;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function StatusFrame.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.000;
    self.clockFrame = 0;
    self.clockTimer = 0;
    self.clockAnimated = false;
    self.clockBlinking = false;
    self.clockClockwise = 0;
    self.clockColorTimer = 0.00;
    self.statusBlinkTimer = 0;

    -- Methods
    self.Display = Display;
    self.Remove = Remove;
    self.GetDriver = GetDriver;
    self.StartClock = StartClock;
    self.StopClock = StopClock;
    self.SetBlinking = SetBlinking;
    self.SetTitle = SetTitle;
    self.SetStatus = SetStatus;
    self.ChangeSecureCommand = ChangeSecureCommand;

    -- Children
    self.title = Root.CreateFontString(self, "OVERLAY", "NormalYellow", nil, "MIDDLE", "MIDDLE");
    self.title:SetWidth(112);
    self.title:SetHeight(16);
    self.title:SetPoint("TOP", self, "TOP", 0, -8);
    self.title:Show();

    self.statusMain = Root.CreateFontString(self, "OVERLAY", "Big", 24, "MIDDLE", "MIDDLE");
    self.statusMain:SetHeight(24);
    self.statusMain:Hide();
    self.statusAlt = Root.CreateFontString(self, "ARTWORK", "Big", 24, "MIDDLE", "MIDDLE");
    self.statusAlt:SetHeight(24);
    self.statusAlt:Hide();

    self.clock = self:CreateTexture(nil, "ARTWORK");
    self.clock:SetTexture(CLOCK);
    self.clock:SetWidth(16);
    self.clock:SetHeight(16);
    self.clock:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 16, 8);
    self.clock:Show();

    self.watch = Root.CreateFontString(self, "OVERLAY", "NormalYellow", nil, "MIDDLE", "MIDDLE");
    self.watch:SetWidth(70);
    self.watch:SetHeight(16);
    self.watch:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 42, 8);
    self.watch:Show();

    -- The option button has priority over the secure button. I thought that was not possible, but it seems I was wrong :D
    self.optionButton = CreateFrame("Button", nil, self);
    self.optionButton:SetAllPoints(self);
    self.optionButton:EnableMouse(true);
    self.optionButton:RegisterForClicks("LeftButtonUp");
    self.optionButton:SetScript("OnClick", StatusFrame.OnOptionButtonClick);
    self.optionButton:SetFrameLevel(self:GetFrameLevel()+2);
    self.optionButton:Show();
    self.optionButtonText = Root.CreateFontString(self.optionButton, "OVERLAY", "NormalYellow", nil, "MIDDLE", "MIDDLE");
    self.optionButtonText:SetHeight(32);
    self.optionButtonText:SetPoint("TOP", self, "TOP", 0, -24);
    self.optionButtonText:SetText(Root.Localise("Setup"));

    -- The secure button has UIParent as parent and not the StatusFrame to avoid protecting the StatusFrame. The same thing applies for anchors.
    self.secureButton = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate");
    self.secureButton:SetAttribute("type1", "macro");
    self.secureButton:SetScript("OnUpdate", StatusFrame.OnSecureButtonUpdate);
    self.secureButton.fakeParent = self;
    self.secureButton:Hide();

    self.Driver = CreateFrame("Frame", nil, nil, "BossEncounter2_StatusFrameDriverTemplate");
    self.Driver:Setup(self);

    Root.SetBackdrop(self, "TOOLTIP");
end

function StatusFrame.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    local alpha = 1.00;

    -- Open/close
    if ( self.status == "OPENING" ) then
        self.timer = max(0, self.timer - elapsed);
        alpha = 1 - self.timer / FADE_TIME;
        if ( self.timer == 0 ) then self.status = "RUNNING"; end
    end
    if ( self.status == "CLOSING" ) then
        self.timer = max(0, self.timer - elapsed);
        alpha = self.timer / FADE_TIME;
        if ( self.timer == 0 ) then self:Remove(true); end
    end

    -- Animate the clock if asked.
    if ( self.clockAnimated ) then
        self.clockTimer = self.clockTimer - elapsed;
    end
    while ( self.clockTimer <= 0.00 ) do
        self.clockTimer = self.clockTimer + CLOCK_ANIMATION_RATE;
        if ( self.clockClockwise == 0 ) then
             self.clockFrame = math.fmod(self.clockFrame + 1, 6);
      else
             self.clockFrame = self.clockFrame - 1;
             if ( self.clockFrame < 0 ) then self.clockFrame = self.clockFrame + 6; end
        end
        self.clock:SetTexCoord(0.01+self.clockFrame*(1/8), (self.clockFrame+1)*(1/8)-0.01, 0.0, 1.0);
    end

    -- Update the watch text and color.
    local currentTimer, currentMode = self:GetDriver():GetTimer();
    local timeString = Root.FormatCountdownString("%M'%S''%C", currentTimer);
    local r, g, b = 0, 1, 0;

    if ( currentMode == "COUNTDOWN" or currentMode == "COUNTDOWN_STANDBY" ) then
        if ( currentTimer <= 60.0 ) then
            self.clockColorTimer = math.fmod(self.clockColorTimer + elapsed, CLOCK_COLOR_TIMER);
      else
            self.clockColorTimer = 0.00;
        end
        local animState = self.clockColorTimer / CLOCK_COLOR_TIMER;

        -- Special color scheme for countdown mode.
        if ( currentTimer == 0.0 ) then
            r, g, b = 1, 1, 1;

    elseif ( currentTimer <= 30.0 ) then
            timeString = Root.TextGradient(timeString, 1, 1, 0, 1, 0, 0, -0.5 + 2 * animState);

    elseif ( currentTimer <= 60.0 ) then
            timeString = Root.TextGradient(timeString, 0, 1, 0, 1, 1, 0, -0.5 + 2 * animState);
        end
    end

    self.watch:SetText(timeString);
    self.watch:SetTextColor(r, g, b);

    -- Blinking of the watch text.
    if ( self.clockBlinking ) then
        local toggle = math.fmod( GetTime() , 0.5 );
        if ( toggle < 0.125 ) then
            self.watch:SetAlpha(0);
      else
            self.watch:SetAlpha(1);
        end
  else
        self.watch:SetAlpha(1);
    end

    -- Settings invitation
    local allowed = select(1, self:GetDriver():GetSettingAccess());

    if ( allowed == true ) then
        self.statusMain:SetAlpha(0);
        self.statusAlt:SetAlpha(0);
        self.optionButton:Show();

        self.optionButtonText:SetText( Root.TextGradient(Root.Localise("Setup"), 0, 1, 1, 0.75, 0, 1, 0.5 + sin(GetTime()/3.000 * 360)) );
        -- local mod = sin(GetTime()/3.000 * 360) * 0.5;
        -- self.optionButtonText:SetTextColor(0.5 - mod, 1.0, 0.5 + mod);
  else
        -- Blinking of the status text.
        -- It is prevented if the settings are accessable.

        self.optionButton:Hide();
        self.statusAlt:SetAlpha(1);

        if ( self.statusBlinkTimer > 0 ) then
            self.statusBlinkTimer = max(0, self.statusBlinkTimer - elapsed);

            local toggle = math.fmod(self.statusBlinkTimer, 0.5);
            if ( toggle > 0.375 ) then
                self.statusMain:SetAlpha(0);
          else
                self.statusMain:SetAlpha(1);
            end
      else
            self.statusMain:SetAlpha(1);
        end
    end

    -- Application on the frame
    local finalX, finalY = self.centerX * UIParent:GetWidth(), self.centerY * UIParent:GetHeight();
    self:ClearAllPoints();
    self:SetAlpha(alpha);
    self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", finalX / self.scale, finalY / self.scale);
    self:SetScale(self.scale);

    -- Handle secure button
    StatusFrame.OnSecureButtonUpdate(self.secureButton, elapsed);
end

function StatusFrame.OnSecureButtonUpdate(button, elapsed)
    -- Make sure the secure button is correctly set up and visible at the right time.
    -- This handler is called both by the StatusFrame and the SecureButton.
    if ( InCombatLockdown() ) then return; end

    local self = button.fakeParent; -- self is the StatusFrame.

    if ( button.needUpdate ) then
        button.needUpdate = false;
        -- Activate or deactivate the secure button.
        if ( button.command ) then
            Root.SetAllPointsSecure(button, self, 1);
            button:SetAttribute("macrotext1", button.command);
            button:Show();
      else
            button:Hide();
        end
    end

    if ( self:IsShown() and button.command ) then
        button:Show();
  else
        button:Hide();
    end
end

function StatusFrame.OnOptionButtonClick(button, click)
    local self = button:GetParent(); -- self is the StatusFrame.
    if type(self) ~= "table" then return; end
    if click ~= "LeftButton" then return; end

    self:GetDriver():OnOptionButtonClick();
end