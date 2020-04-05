local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["TimerReminder"] = { };
local TimerReminder = Widgets["TimerReminder"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local TEXT_BLINK_TIMER = 1.00;

-- In sec.
local FADE_TIME = 0.50;
local DEFAULT_RED_THRESHOLD = 30;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(y, redThreshold)                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the timer reminder frame.                               *
-- * >> y: vertical position for the timer reminder.                  *
-- * >> redThreshold: the threshold under which the time countdown    *
-- * will be displayed in red.                                        *
-- ********************************************************************
-- * Sets up the timer reminder frame.                                *
-- ********************************************************************
local function Setup(self, y, redThreshold)
    if type(self) ~= "table" then return; end

    self.y = y or 0.50;
    self.redThreshold = redThreshold or DEFAULT_RED_THRESHOLD;
end

-- ********************************************************************
-- * self:Display()                                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the timer reminder frame.                               *
-- ********************************************************************
-- * Starts displaying the timer reminder.                            *
-- ********************************************************************
local function Display(self)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    self.status = "OPENING";
    self.timer = FADE_TIME;

    self:Show();
    TimerReminder.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * >> self: the timer reminder frame.                               *
-- * >> atOnce: if set, the timer reminder will be hidden instantly.  *
-- ********************************************************************
-- * Stops displaying the timer reminder.                             *
-- * This will not stop the driver from continuing ticking.           *
-- ********************************************************************
local function Remove(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "OPENING" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        self.status = "CLOSING";
        self.timer = FADE_TIME;
    end
end

-- ********************************************************************
-- * self:GetDriver()                                                 *
-- ********************************************************************
-- * >> self: the timer reminder frame.                               *
-- ********************************************************************
-- * Get the driver of the current timer reminder frame.              *
-- * The driver controls the timer ticking.                           *
-- ********************************************************************
local function GetDriver(self)
    if type(self) ~= "table" then return; end

    return self.Driver;
end

-- ********************************************************************
-- * self:ChangeText(text, blink)                                     *
-- ********************************************************************
-- * >> self: the timer reminder frame.                               *
-- * >> text: the text that will blink below the big timer.           *
-- * >> blink: whether to make the text blink or not.                 *
-- ********************************************************************
-- * Change the text below the timer reminder.                        *
-- * This text can be set to blink.                                   *
-- * method right after using Display method as the title will be     *
-- * otherwise an empty string.                                       *
-- ********************************************************************
local function ChangeText(self, text, blink)
    if type(self) ~= "table" then return; end

    text = text or "";
    if ( self.textString == text ) then return; end

    self.textString = text;
    self.text:SetText(text);

    if ( blink ) then
        self.textBlinkTimer = 0;
  else
        self.textBlinkTimer = nil;
    end
end

-- ********************************************************************
-- * self:ChangeTime(time, sound)                                     *
-- ********************************************************************
-- * >> self: the timer reminder frame.                               *
-- * >> time: the time amount to be shown in the timer reminder.      *
-- * >> sound: if one of the digit changed, do we play a sound ?      *
-- ********************************************************************
-- * Change the timer text of the timer reminder.                     *
-- * The timer will automatically be colored in red under the         *
-- * internal time threshold of the timer reminder.                   *
-- ********************************************************************
local function ChangeTime(self, time, sound)
    if type(self) ~= "table" then return; end

    time = time or 0;
    local displayedTime = math.floor(time + 0.99);
    if ( self.previousTime == displayedTime ) then return; end

    self.previousTime = displayedTime;

    local countdownString = Root.FormatCountdownString("%M : %S", displayedTime, false, false, false);
    self.time:SetText(countdownString);

    if ( displayedTime <= self.redThreshold ) then
        self.time:SetTextColor(1.0, 0.2, 0.2);
  else
        self.time:SetTextColor(1.0, 1.0, 1.0);
    end

    if ( sound ) then
        Root.Sound.Play("TIMETICK");
    end
end

-- ********************************************************************
-- * self:GetStatus()                                                 *
-- ********************************************************************
-- * >> self: the timer reminder frame.                               *
-- ********************************************************************
-- * Get the current internal status of the timer reminder frame.     *
-- * Can return: STANDBY, OPENING, RUNNING, CLOSING                   *
-- ********************************************************************
local function GetStatus(self)
    if type(self) ~= "table" then return; end

    return self.status;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function TimerReminder.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.000;
    self.textString = nil;
    self.textBlinkTimer = nil;
    self.previousTime = nil;

    -- Methods
    self.Setup = Setup;
    self.Display = Display;
    self.Remove = Remove;
    self.GetDriver = GetDriver;
    self.ChangeText = ChangeText;
    self.ChangeTime = ChangeTime;
    self.GetStatus = GetStatus;

    -- Children
    self.text = Root.CreateFontString(self, "OVERLAY", "Visible", 24, "MIDDLE", "MIDDLE");
    self.text:SetPoint("BOTTOM", self, "BOTTOM", 0, 0);
    self.text:Show();

    self.time = Root.CreateFontString(self, "ARTWORK", "Big", 56, "MIDDLE", "MIDDLE");
    self.time:SetPoint("TOP", self, "TOP", 0, 0);
    self.time:Show();

    self.Driver = CreateFrame("Frame", nil, nil, "BossEncounter2_TimerReminderDriverTemplate");
    self.Driver:Setup(self);

    -- Initial state
    self:Setup(nil, nil);
    self:ChangeText("", false);
    self:ChangeTime(0, false);
end

function TimerReminder.OnUpdate(self, elapsed)
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

    -- Blinking of the watch text.
    if ( self.textBlinkTimer ) then
        self.textBlinkTimer = math.fmod(self.textBlinkTimer + elapsed, TEXT_BLINK_TIMER);

        if ( self.textBlinkTimer < (TEXT_BLINK_TIMER/2) ) then
            self.text:SetAlpha(0);
      else
            self.text:SetAlpha(1);
        end
  else
        self.text:SetAlpha(1);
    end

    -- Application on the frame
    local finalX, finalY = 0.50 * UIParent:GetWidth(), self.y * UIParent:GetHeight();
    self:ClearAllPoints();
    self:SetAlpha(alpha);
    self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", finalX, finalY);
end
