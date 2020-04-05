local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["TimerReminderDriver"] = { };
local TimerReminderDriver = Widgets["TimerReminderDriver"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local REMINDER_DURATION = 5.00;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(ownedTimerReminder)                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the timer reminder driver.                              *
-- * >> ownedTimerReminder: the timer reminder frame that will be     *
-- * controlled by the driver.                                        *
-- ********************************************************************
-- * Setup the driver of a timer reminder frame.                      *
-- ********************************************************************
local function Setup(self, ownedTimerReminder)
    if type(self) ~= "table" then return; end

    self.child = ownedTimerReminder;
    self:Clear();
end

-- ********************************************************************
-- * self:Clear()                                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the timer reminder driver.                              *
-- ********************************************************************
-- * Clear the current timer ticking. Doing that will forcefully      *
-- * hide the controlled timer reminder frame.                        *
-- ********************************************************************
local function Clear(self)
    if type(self) ~= "table" then return; end

    self.timer = 0;
    self.running = false;

    self.child:Remove();
end

-- ********************************************************************
-- * self:Start(amount, threshold, thresholdText)                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the timer reminder driver.                              *
-- * >> amount: the countdown that will get periodically reminded.    *
-- * >> threshold: the threshold under which the timer reminder will  *
-- * be permanently displayed.                                        *
-- * >> thresholdText: the text to be displayed under the countdown   *
-- * when below the threshold. If not specified, it will be Hurry Up. *
-- ********************************************************************
-- * Start the timer reminder.                                        *
-- ********************************************************************
local function Start(self, amount, threshold, thresholdText)
    if type(self) ~= "table" then return; end
    if ( self.running ) then return; end

    self.timer = amount;
    self.running = true;
    self.reminderRate = max(30, amount/15);
    self.nextReminder = self.reminderRate;
    self.hideTimer = 0;
    self.threshold = threshold or 30;
    self.thresholdText = thresholdText or Root.Localise("HurryUp");

    self.child:Remove(); -- The timer reminder begins hidden.
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function TimerReminderDriver.OnLoad(self)
    -- Properties
    self.child = nil;
    self.timer = 0;
    self.running = false;
    self.reminderRate = 0;
    self.nextReminder = 0;
    self.hideTimer = 0;
    self.threshold = 0;
    self.thresholdText = "";

    -- Methods
    self.Setup = Setup;
    self.Clear = Clear;
    self.Start = Start;
end

function TimerReminderDriver.OnUpdate(self, elapsed)
    if ( not self.running ) then return; end

    -- Tick the time left away

    self.timer = max(0, self.timer - elapsed);

    -- Update the owned timer reminder frame

    local child = self.child;

    if ( child:GetStatus() == "STANDBY" ) then
        -- Timer reminder not shown. See when we'll remind it for the next time.

        self.nextReminder = max(0, self.nextReminder - elapsed);
        if ( self.timer <= self.threshold ) or ( self.nextReminder == 0.00 ) then
            self.nextReminder = self.reminderRate;
            self.hideTimer = REMINDER_DURATION;
            child:Display();
            child:ChangeText("", false);
            child:ChangeTime(self.timer, false);
        end
  else
        -- Timer reminder being displayed. See when we end the current reminding iteration, except if we are below the threshold.
        -- Also the timer can only pulse while it's fading in or while it's running.

        self.hideTimer = max(0, self.hideTimer - elapsed);
        if ( self.hideTimer == 0 ) and ( self.timer > self.threshold ) then
            child:Remove();

    elseif ( child:GetStatus() == "OPENING" or child:GetStatus() == "RUNNING" ) then
            child:ChangeTime(self.timer, true);

            if ( self.timer <= self.threshold ) then
                child:ChangeText(self.thresholdText, true);
          else
                child:ChangeText("", false);
            end
        end
    end

    -- Check expiration

    if ( self.timer == 0 ) then
        self:Clear();
        return;
    end
end