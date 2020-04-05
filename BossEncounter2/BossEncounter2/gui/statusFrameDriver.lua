local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["StatusFrameDriver"] = { };
local StatusFrameDriver = Widgets["StatusFrameDriver"];

local Manager = Root.GetOrNewModule("Manager");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(ownedStatusFrame)                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the status frame driver.                                *
-- * >> ownedStatusBar: the status frame that will be controlled      *
-- * by the driver. Note a status frame driver can be attached to no  *
-- * status bar, in such case it can be used to act as an invisible   *
-- * global encounter timer.                                          *
-- ********************************************************************
-- * Setup the driver of a status frame.                              *
-- ********************************************************************
local function Setup(self, ownedStatusFrame)
    if type(self) ~= "table" then return; end

    self.ownedStatusFrame = ownedStatusFrame;
    self:Clear();
end

-- ********************************************************************
-- * self:Clear()                                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the status frame driver.                                *
-- ********************************************************************
-- * Clear the countdown or timing of the status frame driver.        *
-- ********************************************************************
local function Clear(self)
    if type(self) ~= "table" then return; end

    self.timer = 0;
    self.mode = "STANDBY";
    self.callback = nil;
    self.paused = false;

    if ( self.ownedStatusFrame ) then
        self.ownedStatusFrame:StopClock();
        self.ownedStatusFrame:SetBlinking(false);
    end
end

-- ********************************************************************
-- * self:StartCountdown(amount[, callback])                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the status frame driver.                                *
-- * >> callback: the function to be called when the                  *
-- * countdown expires. Can be nil.                                   *
-- ********************************************************************
-- * Start the watch of the status frame in countdown mode.           *
-- ********************************************************************
local function StartCountdown(self, amount, callback)
    if type(self) ~= "table" then return; end

    self.timer = amount;
    self.mode = "COUNTDOWN";
    self.callback = callback;
    self.paused = false;

    if ( self.ownedStatusFrame ) then
        self.ownedStatusFrame:StartClock(0); -- Counterclockwise
        self.ownedStatusFrame:SetBlinking(false);
    end
end

-- ********************************************************************
-- * self:StartTiming()                                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the status frame driver.                                *
-- ********************************************************************
-- * Start the watch of the status frame in elapsed mode.             *
-- ********************************************************************
local function StartTiming(self)
    if type(self) ~= "table" then return; end

    self.timer = 0;
    self.mode = "TIMING";
    self.callback = nil;
    self.paused = false;

    if ( self.ownedStatusFrame ) then
        self.ownedStatusFrame:StartClock(1); -- Clockwise
        self.ownedStatusFrame:SetBlinking(false);
    end
end

-- ********************************************************************
-- * self:Pause()                                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the status frame driver.                                *
-- ********************************************************************
-- * Pause the current countdown or timing.                           *
-- ********************************************************************
local function Pause(self)
    if type(self) ~= "table" then return; end
    if ( self.mode == "STANDBY" or self.mode == "COUNTDOWN_STANDBY" ) then return; end

    self.paused = true;

    if ( self.ownedStatusFrame ) then
        self.ownedStatusFrame:StopClock();
    end
end

-- ********************************************************************
-- * self:Resume()                                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the status frame driver.                                *
-- ********************************************************************
-- * Resume the current countdown or timing.                          *
-- ********************************************************************
local function Resume(self)
    if type(self) ~= "table" then return; end
    if ( self.mode == "STANDBY" or self.mode == "COUNTDOWN_STANDBY" ) then return; end

    self.paused = false;

    if ( self.ownedStatusFrame ) then
        self.ownedStatusFrame:StartClock(nil); -- Whatever previous state we were in.
        self.ownedStatusFrame:SetBlinking(false);
    end
end

-- ********************************************************************
-- * self:GetTimer()                                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the status frame driver.                                *
-- ********************************************************************
-- * Get the current value in the timer. Also return the mode used.   *
-- ********************************************************************
local function GetTimer(self)
    if type(self) ~= "table" then return; end

    return self.timer, self.mode;
end

-- ********************************************************************
-- * self:SetSettingAccess(module)                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the status frame driver.                                *
-- * >> module: the module whose settings will be accessed.           *
-- * Nil will prevent the settings access.                            *
-- ********************************************************************
-- * Configure the driver to allow access to a module's settings or   *
-- * not. The access is done by clicking on the status frame owning   *
-- * this driver.                                                     *
-- ********************************************************************
local function SetSettingAccess(self, module)
    if type(self) ~= "table" then return; end
    if type(module) ~= "table" then return; end

    self.settingAccess = module;
end

-- ********************************************************************
-- * self:GetSettingAccess()                                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the status frame driver.                                *
-- ********************************************************************
-- * Return true if you can open the settings window by clicking on   *
-- * the status frame. A second return is given, indicating which     *
-- * module has its settings modified.                                *
-- ********************************************************************
local function GetSettingAccess(self)
    if type(self) ~= "table" then return false, nil; end
    if type(self.ownedStatusFrame) ~= "table" then return false, nil; end

    local module = self.settingAccess;
    local allowed = false;

    if ( type(module) == "table" ) and ( module:MayEditSettings() ) and ( self.ownedStatusFrame.status == "RUNNING" ) then
        if ( Manager:GetSettingFrame():GetStatus() == "STANDBY" ) then
            allowed = true;
        end
    end

    return allowed, module;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function StatusFrameDriver.OnLoad(self)
    -- Properties
    self.ownedStatusFrame = nil;
    self.timer = 0;
    self.mode = "STANDBY";
    self.callback = nil;
    self.paused = false;
    self.settingAccess = nil;

    -- Methods
    self.Setup = Setup;
    self.Clear = Clear;
    self.StartCountdown = StartCountdown;
    self.StartTiming = StartTiming;
    self.Pause = Pause;
    self.Resume = Resume;
    self.GetTimer = GetTimer;
    self.SetSettingAccess = SetSettingAccess;
    self.GetSettingAccess = GetSettingAccess;
    self.OnOptionButtonClick = StatusFrameDriver.OnOptionButtonClick;
end

function StatusFrameDriver.OnUpdate(self, elapsed)
    -- Note: "Countdown standby" is the special state of a countdown that has finished but hasn't been cleared.
    if ( self.mode == "STANDBY" or self.mode == "COUNTDOWN_STANDBY" ) then
        self.timer = 0;

elseif ( self.mode == "TIMING" ) and ( not self.paused ) then
        self.timer = self.timer + elapsed;

elseif ( self.mode == "COUNTDOWN" ) and ( not self.paused ) then
        self.timer = max(0, self.timer - elapsed);

        if ( self.timer == 0 ) then
            self.mode = "COUNTDOWN_STANDBY";
            if ( self.ownedStatusFrame ) then
                self.ownedStatusFrame:StopClock();
                self.ownedStatusFrame:SetBlinking(true);
            end
            if ( self.callback ) then
                self.callback();
                self.callback = nil;
            end
        end
    end
end

function StatusFrameDriver.OnOptionButtonClick(self)
    -- Called when the user clicks on the status frame to open the option panel.

    local allowed, module = self:GetSettingAccess();

    if ( allowed and module ) then
        Manager:GetSettingFrame():Open(module);
    end
end