local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["SecureFrame"] = { };
local SecureFrame = Widgets["SecureFrame"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local modes = {
    ["BUTTON"] = {
        frame = "actionButton",

        update = function(self, name)
            self:SetAttribute("*type*", "macro");
            local macroText = "/targetexact "..name;
            if ( self.command ) then
                macroText = macroText.."\n"..self.command;
            end
            self:SetAttribute("*macrotext*", macroText);
            self:Show();
        end,
    },
};

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(mode, name[, frame])                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the secure frame.                                       *
-- * >> mode: the mode used to interact with the unit.                *
-- * Only "BUTTON" available.                                         *
-- * >> name: the name of the unit monitored.                         *
-- * >> frame: the frame above which the secure frame will be placed. *
-- * If the secure frame has a parent and frame is not specified,     *
-- * the parent will be used instead.                                 *
-- ********************************************************************
-- * Start displaying a secure frame positionned above another frame. *
-- * If you want to specify a custom command to be called when the    *
-- * button is right-clicked, call the SetCommand method after using  *
-- * the Setup method.                                                *
-- ********************************************************************
local function Setup(self, mode, name, frame)
    if ( not modes[mode] ) or ( not name ) then return; end

    local secureFrame = self[modes[mode].frame];
    frame = frame or self:GetParent();
    if ( not secureFrame ) or ( not frame ) then return; end

    self.running = true;
    self.mode = mode;
    self.name = name;
    self.frame = frame;
    self.secureFrame = secureFrame;
    secureFrame.command = nil;

    self:Update();
end

-- ********************************************************************
-- * self:SetCommand(command)                                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the secure frame.                                       *
-- * >> command: a macro slash command. It will be executed after the *
-- * /target UnitName command.                                        *
-- ********************************************************************
-- * Set a custom macro command that will be executed when            *
-- * clicking on the secure frame. It will be executed after          *
-- * the target command.                                              *
-- ********************************************************************
local function SetCommand(self, command)
    if ( not self:IsRunning() ) then
        return;
    end
    self.secureFrame.command = command;
    -- print("Got "..(command or "null").." command !");
end

-- ********************************************************************
-- * self:Remove()                                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the secure frame.                                       *
-- ********************************************************************
-- * Remove the secure frame as soon as possible.                     *
-- ********************************************************************
local function Remove(self)
    self.running = false;
    self.mode = nil;
    self.name = nil;
    self.frame = nil;

    self:Update();
end

-- ********************************************************************
-- * self:Update()                                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the secure frame.                                       *
-- ********************************************************************
-- * Update the functionalities of the secure frame.                  *
-- * Can only be called out of combat.                                *
-- ********************************************************************
local function Update(self)
    if ( InCombatLockdown() ) then return; end

    local secureFrame, frame, name = self.secureFrame, self.frame, self.name;

    -- Remove unwanted buttons
    local i, button;
    for i=1, #self.buttons do
        button = self.buttons[i];
        if ( not self.running ) or ( button ~= secureFrame ) then
            button:Hide();
        end
    end

    -- Update the currently active button
    if ( self.running ) then
        if ( frame:IsShown() ) then
            Root.SetAllPointsSecure(secureFrame, frame, 1);
            modes[self.mode].update(secureFrame, name);
      else
            secureFrame:Hide();
        end
    end
end

-- ********************************************************************
-- * self:IsRunning()                                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the secure frame.                                       *
-- ********************************************************************
-- * Get whether a secure frame is running or not.                    *
-- * Running means the frame using it should be unable to hide        *
-- * itself till the secure frame can finally be removed.             *
-- ********************************************************************
local function IsRunning(self)
    if ( self.secureFrame ) then
        return self.secureFrame:IsShown();
    end
    return false;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function SecureFrame.OnLoad(self)
    -- Properties
    self.running = false;
    self.mode = nil;
    self.name = nil;
    self.frame = nil;
    self.secureFrame = nil;

    -- Methods
    self.Setup = Setup;
    self.Remove = Remove;
    self.Update = Update;
    self.IsRunning = IsRunning;
    self.SetCommand = SetCommand;

    -- Children
    self.actionButton = CreateFrame("Button", nil, UIParent, "BossEncounter2_SecureButtonTemplate");

    self.buttons = { };
    tinsert(self.buttons, self.actionButton);
end

function SecureFrame.OnUpdate(self, elapsed)
    if ( not InCombatLockdown() ) then
        self:Update();
    end
end