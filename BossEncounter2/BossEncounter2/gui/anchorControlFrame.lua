local Root = BossEncounter2;
local Widgets = Root.GetOrNewModule("Widgets");
local Anchor = Root.GetOrNewModule("Anchor");

Widgets["AnchorControlFrame"] = { };
local AnchorControlFrame = Widgets["AnchorControlFrame"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

local OPEN_TIME = 0.500;
local CLOSE_TIME = 0.500;

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local backdropBorder = { [1] = {1.0, 0.4, 0.2, 1.0}, [2] = {0.4, 1.0, 0.2, 1.0}, [3] = {0.4, 0.4, 1.0, 1.0}, };
local backdrop = {       [1] = {1.0, 0.2, 0.1, 0.5}, [2] = {0.2, 1.0, 0.1, 0.5}, [3] = {0.2, 0.2, 1.0, 0.5}, };

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Open()                                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the anchor control frame.                               *
-- ********************************************************************
-- * Open the anchor control frame, to change the anchors.            *
-- ********************************************************************
local function Open(self)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    -- Prepare the display vars
    self.status = "OPENING";
    self.timer = 0;

    -- No initial focus
    self:SetFocus(nil);

    -- And display the frame
    self:Show();
    AnchorControlFrame.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Close([atOnce])                                             *
-- ********************************************************************
-- * >> self: the anchor control frame.                               *
-- * >> atOnce: if set, the frame will be hidden instantly.           *
-- ********************************************************************
-- * Close the anchor control frame.                                  *
-- ********************************************************************
local function Close(self, atOnce)
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
-- * self:GetStatus()                                                 *
-- ********************************************************************
-- * >> self: the anchor control frame.                               *
-- ********************************************************************
-- * Get the current internal status of the anchor control frame.     *
-- * Can be either OPENING, RUNNING, CLOSING or STANDBY.              *
-- ********************************************************************
local function GetStatus(self)
    if type(self) ~= "table" then return; end
    return self.status;
end

-- ********************************************************************
-- * self:SetFocus(widget)                                            *
-- ********************************************************************
-- * >> self: the anchor control frame.                               *
-- * >> widget: the widget the anchor control frame will focus on.    *
-- * Pass nil to clear the focus.                                     *
-- ********************************************************************
-- * Change the anchor control frame's focus.                         *
-- ********************************************************************
local function SetFocus(self, widget)
    if type(self) ~= "table" or (type(widget) ~= "table" and widget) then return; end

    self.focus = widget;

    local x, y, scale, enabled, id, shape, width, height, label, removable;
    local scalingEnabled = false;
    local enableButtonAllowed = false;

    if ( widget ) then
        x, y, scale, enabled, id, shape, width, height, label, _, _, removable = Anchor:GetAnchorInfo(widget);
        self.text:SetText(label);

        -- Axis widgets only need a Y position. Also axis widgets can't be scaled.
        if ( shape ~= "AXIS" ) then
            self.defaultXButton:Enable();
            scalingEnabled = true;
      else
            self.defaultXButton:Disable();
        end
        self.defaultYButton:Enable();

        enableButtonAllowed = removable;
  else
        self.text:SetText(Root.Localise("ACF-NoFocus"));
        self.defaultXButton:Disable();
        self.defaultYButton:Disable();
    end

    if ( scalingEnabled ) then
        self.scaleSlider:Enable();
        self.scaleSlider.text:SetText(Root.Localise("ACF-Scale"));
        self.scaleSlider:SetValue(widget.scale or 1);
        self.scaleSlider.enabled = true;
        self.scaleSlider.lastValue = nil;
  else
        self.scaleSlider:Disable();
        self.scaleSlider.text:SetText("|cff808080"..Root.Localise("ACF-Scale").."|r");
        self.scaleSlider.enabled = false;
    end

    if ( enableButtonAllowed ) then
        self.enableButton.text:SetText(Root.Localise("ACF-Enable"));
        self.enableButton.enabled = true;
        self.enableButton:SetChecked(enabled);
  else
        self.enableButton.text:SetText("|cff808080"..Root.Localise("ACF-Enable").."|r");
        self.enableButton.enabled = false;
        self.enableButton:SetChecked(true);
    end

    -- Backdrop choice !

    if ( not widget ) then
        self:ChangeBackdrop(3);
elseif ( enableButtonAllowed ) then
        self:ChangeBackdrop(2);
  else
        self:ChangeBackdrop(1);
    end
end

-- ********************************************************************
-- * self:GetFocus()                                                  *
-- ********************************************************************
-- * >> self: the anchor control frame.                               *
-- ********************************************************************
-- * Get the widget anchor control frame is being focused upon.       *
-- ********************************************************************
local function GetFocus(self)
    if type(self) ~= "table" then return; end
    return self.focus;
end

-- ********************************************************************
-- * self:ChangeBackdrop(id)                                          *
-- ********************************************************************
-- * >> self: the anchor control frame.                               *
-- * >> id: the ID of the backdrop to use.                            *
-- ********************************************************************
-- * Change the backdrop of the anchor control frame.                 *
-- ********************************************************************
local function ChangeBackdrop(self, id)
    if type(self) ~= "table" then return; end

    self:SetBackdropBorderColor(unpack(backdropBorder[id]));
    self:SetBackdropColor(unpack(backdrop[id]));
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function AnchorControlFrame.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.00;
    self.focus = nil;

    -- Methods
    self.Open = Open;
    self.Close = Close;
    self.GetStatus = GetStatus;
    self.SetFocus = SetFocus;
    self.GetFocus = GetFocus;
    self.ChangeBackdrop = ChangeBackdrop;

    -- Children
    self.text = Root.CreateFontString(self, "ARTWORK", "SmallWhite", nil, "LEFT", "MIDDLE");
    self.text:SetWidth(128);
    self.text:SetHeight(48);
    self.text:SetPoint("LEFT", self, "LEFT", 8, 0);
    self.text:SetText("");
    self.text:Show();

    -- Bottom row controls
    self.copyButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.copyButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -8, 8);
    self.copyButton:SetWidth(80);
    self.copyButton:SetHeight(24);
    self.copyButton:SetText(Root.Localise("ACF-Copy"));
    self.copyButton:SetScript("OnClick", AnchorControlFrame.OnCopyButtonClick);
    self.copyButton:Show();

    self.defaultYButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.defaultYButton:SetPoint("RIGHT", self.copyButton, "LEFT", -8, 0);
    self.defaultYButton:SetWidth(80);
    self.defaultYButton:SetHeight(24);
    self.defaultYButton:SetText(Root.Localise("ACF-DefaultY"));
    self.defaultYButton:SetScript("OnClick", AnchorControlFrame.OnDefaultButtonClick);
    self.defaultYButton:Show();
    self.defaultYButton.axis = "Y";

    self.enableButton = CreateFrame("CheckButton", nil, self, "BossEncounter2_SettingFrameCheckButtonTemplate");
    self.enableButton:SetPoint("RIGHT", self.defaultYButton, "LEFT", -136, 0);
    self.enableButton:SetScript("OnClick", AnchorControlFrame.OnEnableButtonClick);
    self.enableButton:Show();

    -- Top row controls
    self.finishButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.finishButton:SetPoint("TOPRIGHT", self, "TOPRIGHT", -8, -8);
    self.finishButton:SetWidth(80);
    self.finishButton:SetHeight(24);
    self.finishButton:SetText(Root.Localise("ACF-Finish"));
    self.finishButton:SetScript("OnClick", AnchorControlFrame.OnFinishButtonClick);
    self.finishButton:Show();

    self.defaultXButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.defaultXButton:SetPoint("RIGHT", self.finishButton, "LEFT", -8, 0);
    self.defaultXButton:SetWidth(80);
    self.defaultXButton:SetHeight(24);
    self.defaultXButton:SetText(Root.Localise("ACF-DefaultX"));
    self.defaultXButton:SetScript("OnClick", AnchorControlFrame.OnDefaultButtonClick);
    self.defaultXButton:Show();
    self.defaultXButton.axis = "X";

    self.scaleSlider = CreateFrame("Slider", nil, self, "BossEncounter2_AnchorControlFrameSliderTemplate");
    self.scaleSlider:SetMinMaxValues(0.50, 2.00);
    self.scaleSlider:SetValueStep(0.01);
    self.scaleSlider.lowText:SetText("0.50");
    self.scaleSlider.highText:SetText("2.00");
    self.scaleSlider:SetPoint("RIGHT", self.defaultXButton, "LEFT", -8, 0);

    -- Make draggable
    Root.MakeDraggable(self);

    -- Initial position
    self:SetPoint("CENTER", self:GetParent(), "CENTER", 0, 0);

    Root.SetBackdrop(self, "TOOLTIP");
end

function AnchorControlFrame.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    local alpha = 1.00;
    local scale = 1.00;

    -- Open/close
    if ( self.status == "OPENING" ) then
        self.timer = min(OPEN_TIME, self.timer + elapsed);
        alpha = self.timer / OPEN_TIME;
        scale = max(0.01, alpha);
        if ( self.timer == OPEN_TIME ) then self.status = "RUNNING"; end
    end
    if ( self.status == "CLOSING" ) then
        self.timer = min(CLOSE_TIME, self.timer + elapsed);
        alpha = 1 - self.timer / CLOSE_TIME;
        scale = max(0.01, alpha);
        if ( self.timer == CLOSE_TIME ) then self:Close(true); end
    end

    -- Query value of the scale slider.
    local slider = self.scaleSlider;
    if ( self.focus ) and ( slider.enabled ) then
        -- Update value text
        local value = slider:GetValue();
        if ( value ~= slider.lastValue ) then
            slider.lastValue = value;
            self.focus:ChangeScale(value);
            local valueText = string.format("%.2f", value);
            slider.valueText:SetText(valueText);
        end
  else
        slider.lastValue = nil;
        slider.valueText:SetText("");
    end

    -- Application on the frame
    self:SetScale(scale);
    self:SetAlpha(alpha);
end

function AnchorControlFrame.OnDefaultButtonClick(button)
    local self = button:GetParent();
    local widget = self:GetFocus();

    if type(widget) == "table" then
        widget:RestoreDefaultPosition(button.axis);
    end
end

function AnchorControlFrame.OnEnableButtonClick(button)
    local self = button:GetParent();
    local widget = self:GetFocus();

    if ( button.enabled ) then
        Anchor:Toggle(widget.anchorID, button:GetChecked() ~= nil);
  else
        button:SetChecked(true);
    end
end

function AnchorControlFrame.OnCopyButtonClick(button)
    local self = button:GetParent();

    -- Issue the copy order to the anchor edit mode module.
    Root["AnchorMode"]:OnCopyQuery();
end

function AnchorControlFrame.OnFinishButtonClick(button)
    local self = button:GetParent();

    -- Issue the finish order to the anchor edit mode module.
    Root["AnchorMode"]:OnFinish();
end