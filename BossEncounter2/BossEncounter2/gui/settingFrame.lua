local Root = BossEncounter2;

local SettingPriority = Root.GetOrNewModule("SettingPriority");

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["SettingFrame"] = { };
local SettingFrame = Widgets["SettingFrame"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

local OPEN_TIME = 0.500;
local CLOSE_TIME = 0.500;
local XPOSITION = 0.50;
local YPOSITION = 0.50;

local REFRESH_RATE = 2.000;

local MAX_CHECKBUTTONS = 10;
local MAX_SLIDERS = 3;
local MAX_BIT_TABLES = 3;
local NUM_BITS_PER_BIT_TABLE = 8;

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Open(module)                                                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the setting frame.                                      *
-- * >> module: the module which gets edited.                         *
-- ********************************************************************
-- * Open the setting frame, to change the settings of a module.      *
-- ********************************************************************
local function Open(self, module)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end
    if type(module) ~= "table" then return; end

    -- Prepare the display vars
    self.status = "OPENING";
    self.timer = 0;
    self.module = module;

    self:Refresh();

    -- And display the frame
    self:Show();
    SettingFrame.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Refresh()                                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the setting frame.                                      *
-- ********************************************************************
-- * Refresh the setting frame: recalculate the necessary widgets,    *
-- * put them in place and set their value to the module's values.    *
-- ********************************************************************
local function Refresh(self)
    if type(self) ~= "table" then return; end
    if type(self.module) ~= "table" then return; end

    self.nextRefresh = REFRESH_RATE;

    local settingSchema = self.module.settings;
    local numSettings = #settingSchema;
    local setting, checkButton, slider;
    local lastSettingAssigned;
    local i, s, found;
    local b, button;
    local maxWidth = 256;
    local reqHeight = 48;
    local currentPositionY = -16;

    self:SetScale(1.00); -- If not set to 1, the get text size methods will fuck up.

    -- Configure the Next button.
    if ( settingSchema.nextOptions ) then
        self.nextModule = Root.GetOrNewModule(settingSchema.nextOptions);
        self.nextButton:Show();
  else
        self.nextModule = nil;
        self.nextButton:Hide();
    end

    -- First put checkbuttons in place.
    lastSettingAssigned = 0;
    for i=1, MAX_CHECKBUTTONS do
        checkButton = self.checkButtons[i];
        found = false;

        for s=lastSettingAssigned+1, numSettings do
            if s > numSettings then break; end

            setting = settingSchema[s];
            if ( setting.type == "BOOLEAN" ) then
                found = true;
                lastSettingAssigned = s;

                local optionLabel, optionExplanation, isLocked;
                local authColor = "|cffffffff";
                optionLabel = Root.ReadLocTable(setting.label) or setting.label or "???";
                optionExplanation = Root.ReadLocTable(setting.explain) or setting.explain or nil;
                isLocked = Root.EvaluateLock(setting.lock);

                checkButton:Show();
                checkButton:SetPoint("TOPLEFT", self, "TOPLEFT", 8, currentPositionY);

                checkButton:SetChecked(self.module:GetSetting(setting.id, true));
                checkButton.id = setting.id;
                checkButton.isPerCharacter = setting.isPerCharacter;
                checkButton.isBitTable = false;

                if ( isLocked ) then
                    authColor = "|cffa08080";
                    checkButton:LockHighlight();
                    checkButton.hasLock = true;
                    checkButton.lockValue = checkButton:GetChecked(); -- Value is frozen.
              else
                    checkButton:UnlockHighlight();
                    checkButton.hasLock = false;
                end

                checkButton.text:SetText(authColor..optionLabel.."|r");
                self:CreateTooltip(checkButton, optionLabel, optionExplanation, isLocked, setting.oneEnabledOnly, setting.isPerCharacter);

                -- Dynamic sizing of the setting frame.
                currentPositionY = currentPositionY - 32;
                reqHeight = reqHeight + 32;
                maxWidth = max(maxWidth, checkButton.text:GetStringWidth() + 52);

                break;
            end
        end
        if ( not found ) then
            checkButton:Hide();
        end
    end

    -- Then the sliders.
    lastSettingAssigned = 0;
    for i=1, MAX_SLIDERS do
        slider = self.sliders[i];
        found = false;

        for s=lastSettingAssigned+1, numSettings do
            if s > numSettings then break; end

            setting = settingSchema[s];
            if ( setting.type == "NUMBER" ) then
                found = true;
                lastSettingAssigned = s;

                local optionLabel, optionExplanation, isLocked;
                local authColor = "|cffffffff";
                optionLabel = Root.ReadLocTable(setting.label) or setting.label or "???";
                optionExplanation = Root.ReadLocTable(setting.explain) or setting.explain or nil;
                isLocked = Root.EvaluateLock(setting.lock);

                slider:Show();
                slider:SetPoint("TOPLEFT", self, "TOPLEFT", 8, currentPositionY);

                local lowBound, highBound, valueTemplate, step = "%d", "%d", "%d", setting.step;
                if ( step < 0.1 ) then
                    lowBound, highBound, valueTemplate = "%.2f", "%.2f", "%.2f";
            elseif ( step < 1 ) then
                    lowBound, highBound, valueTemplate = "%.1f", "%.1f", "%.1f";
                end

                lowBound = string.format(lowBound, setting.min);
                highBound = string.format(highBound, setting.max);

                slider:SetMinMaxValues(setting.min, setting.max);
                slider:SetValueStep(step);

                slider.valueTextTemplate = valueTemplate;
                slider.lowText:SetText(lowBound);
                slider.highText:SetText(highBound);

                slider.id = setting.id;
                slider.isPerCharacter = setting.isPerCharacter;
                slider:SetValue(self.module:GetSetting(setting.id, true) or 0);

                if ( isLocked ) then
                    authColor = "|cffa08080";
                    slider:Disable();
                    slider.hasLock = true;
                    slider.lockValue = slider:GetValue(); -- Value is frozen.
              else
                    slider:Enable();
                    slider.hasLock = false;
                end

                slider.text:SetText(authColor..optionLabel.."|r");
                self:CreateTooltip(slider, optionLabel, optionExplanation, isLocked, false, setting.isPerCharacter);

                -- Dynamic sizing of the setting frame.
                currentPositionY = currentPositionY - 40;
                reqHeight = reqHeight + 40;
                maxWidth = max(maxWidth, slider.text:GetStringWidth() + 172);

                break;
            end
        end
        if ( not found ) then
            slider:Hide();
        end
    end

    -- Then bit tables.
    lastSettingAssigned = 0;
    for i=1, MAX_BIT_TABLES do
        bitTable = self.bitTables[i];
        found = false;

        for s=lastSettingAssigned+1, numSettings do
            if s > numSettings then break; end

            setting = settingSchema[s];
            if ( setting.type == "BIT_TABLE" ) then
                found = true;
                lastSettingAssigned = s;

                bitTable:Show();

                local optionLabel;
                local optionExplanation, bitLocalization, bitTitle;
                local settingValue, bitValue;
                local totalWidth = 0;

                optionLabel = Root.ReadLocTable(setting.label) or setting.label or "???";

                for b=1, NUM_BITS_PER_BIT_TABLE do
                    button = bitTable.bits[b];

                    if ( b <= setting.bits ) then
                        optionExplanation = Root.ReadLocTable(setting.explain) or setting.explain or nil;
                        bitLocalization = setting.bitsTitle[GetLocale()] or setting.bitsTitle["default"];
                        bitTitle = bitLocalization[b] or "???";

                        button:Show();
                        button:SetPoint("BOTTOMLEFT", bitTable, "BOTTOMLEFT", 8+(b-1)*48, 4);

                        settingValue = self.module:GetSetting(setting.id, true) or 0;
                        bitValue = bit.band(settingValue, 2^(b-1));

                        button:SetChecked(bitValue ~= 0);
                        button:SetID(b);

                        optionExplanation = optionExplanation.."\n\n|cffffffff"..bitTitle.."|r";

                        button.text:SetText(string.sub(bitTitle, 1, 1)); -- First letter only.
                        self:CreateTooltip(button, optionLabel, optionExplanation, false, false, setting.isPerCharacter);

                        totalWidth = totalWidth + 48;
                   else
                        button:Hide(); -- Unused bit.
                    end
                end

                bitTable.id = setting.id;
                bitTable.isPerCharacter = setting.isPerCharacter;

                bitTable.title:SetText(optionLabel);
                bitTable:SetWidth(totalWidth+16);
                bitTable:SetPoint("TOPLEFT", self, "TOPLEFT", 8, currentPositionY);

                -- Dynamic sizing of the setting frame.
                currentPositionY = currentPositionY - 56;
                reqHeight = reqHeight + 56;
                maxWidth = max(maxWidth, totalWidth + 32);

                break;
            end
        end
        if ( not found ) then
            bitTable:Hide();
        end
    end

    self:SetWidth(maxWidth);
    self:SetHeight(reqHeight);
end

-- ********************************************************************
-- * self:Close([atOnce])                                             *
-- ********************************************************************
-- * >> self: the setting frame.                                      *
-- * >> atOnce: if set, setting frame will be hidden instantly.       *
-- ********************************************************************
-- * Close the setting frame.                                         *
-- ********************************************************************
local function Close(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "OPENING" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();

        -- Ask the setting priority module to broadcast our new setting values.
        SettingPriority:Broadcast();
  else
        self.status = "CLOSING";
        self.timer = 0;
    end
end

-- ********************************************************************
-- * self:CreateTooltip(object, title, description,                   *
-- *                    isLocked, isOneOnly, isPerCharacter)          *
-- ********************************************************************
-- * >> self: the setting frame.                                      *
-- * >> object: the object that receives the tooltip.                 *
-- * >> title: the title of the tooltip (can be nil).                 *
-- * >> description: the description of the tooltip (can be nil).     *
-- * >> isLocked: true if you can't modify the setting.               *
-- * >> isOneOnly: true if the setting is one-enabled-only.           *
-- * >> isPerCharacter: true if the setting is saved per character.   *
-- ********************************************************************
-- * Build the tooltip for one of the objects of the setting frame.   *
-- ********************************************************************
local function CreateTooltip(self, object, title, description, isLocked, isOneOnly, isPerCharacter)
    if type(self) ~= "table" or type(object) ~= "table" then return; end
    
    if ( isLocked ) then
        description = (description or "")..Root.Localise("SettingLock");
  else
        if ( isOneOnly ) then
            description = (description or "")..Root.Localise("SettingOne");
        end
        if ( isPerCharacter ) then
            description = (description or "")..Root.Localise("SettingPerCharacter");
        end
    end

    Root.SetTooltip(object, title, description);
end

-- ********************************************************************
-- * self:GetStatus()                                                 *
-- ********************************************************************
-- * >> self: the setting frame.                                      *
-- ********************************************************************
-- * Get the current internal status of the setting frame.            *
-- * Can be either OPENING, RUNNING, CLOSING or STANDBY.              *
-- ********************************************************************
local function GetStatus(self)
    if type(self) ~= "table" then return; end
    return self.status;
end

-- ********************************************************************
-- * self:NotifySettingChange(id)                                     *
-- ********************************************************************
-- * >> self: the setting frame.                                      *
-- * >> id: the id of the setting that changed.                       *
-- ********************************************************************
-- * Notify the module whose options are being changed that the value *
-- * of one of its options has indeed just been changed by the player.*
-- ********************************************************************
local function NotifySettingChange(self, id)
    if type(self) ~= "table" then return; end

    local m = self.module;
    if type(m) == "table" then
        if type(m.OnSettingChanged) == "function" then
            m:OnSettingChanged(id);
        end
    end
end

-- ********************************************************************
-- * self:SetDefaults()                                               *
-- ********************************************************************
-- * >> self: the setting frame.                                      *
-- ********************************************************************
-- * Use the default settings.                                        *
-- ********************************************************************
local function SetDefaults(self)
    if type(self) ~= "table" then return; end
    if type(self.module) ~= "table" then return; end

    local numSettings = #self.module.settings;
    local i, setting;

    for i=1, numSettings do
        setting = self.module.settings[i];

        local key = setting.id;
        if ( setting.isPerCharacter ) then key = key..":"..UnitGUID("player"); end

        self.module.settingsValue[key] = setting.defaultValue;

        self:NotifySettingChange(setting.id);
    end

    self:Refresh();
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function SettingFrame.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.00;
    self.module = nil;
    self.nextModule = nil;

    -- Methods
    self.Open = Open;
    self.Refresh = Refresh;
    self.Close = Close;
    self.CreateTooltip = CreateTooltip;
    self.GetStatus = GetStatus;
    self.NotifySettingChange = NotifySettingChange;
    self.SetDefaults = SetDefaults;

    -- Children
    self.title = Root.CreateFontString(self, "ARTWORK", "Big", nil, "MIDDLE", "BOTTOM");
    self.title:SetHeight(32);
    self.title:SetPoint("BOTTOM", self, "TOP", 0, -8);
    self.title:SetText(Root.Localise("Settings"));
    self.title:Show();

    self.closeButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.closeButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -8, 8);
    self.closeButton:SetWidth(64);
    self.closeButton:SetHeight(24);
    self.closeButton:SetText(CLOSE);
    self.closeButton:SetScript("OnClick", SettingFrame.OnCloseButtonClick);
    self.closeButton:Show();

    self.defaultButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.defaultButton:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 8, 8);
    self.defaultButton:SetWidth(80);
    self.defaultButton:SetHeight(24);
    self.defaultButton:SetText(DEFAULT);
    self.defaultButton:SetScript("OnClick", SettingFrame.OnDefaultButtonClick);
    self.defaultButton:Show();

    self.nextButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.nextButton:SetPoint("BOTTOM", self, "BOTTOM", 0, 8);
    self.nextButton:SetWidth(80);
    self.nextButton:SetHeight(24);
    self.nextButton:SetText(NEXT);
    self.nextButton:SetScript("OnClick", SettingFrame.OnNextButtonClick);
    self.nextButton:Show();

    local i;

    -- Prepare some checkbuttons.
    self.checkButtons = {};
    for i=1, MAX_CHECKBUTTONS do
        self.checkButtons[i] = CreateFrame("CheckButton", nil, self, "BossEncounter2_SettingFrameCheckButtonTemplate");
        self.checkButtons[i]:Hide();
    end

    -- Prepare some sliders.
    self.sliders = {};
    for i=1, MAX_SLIDERS do
        self.sliders[i] = CreateFrame("Slider", nil, self, "BossEncounter2_SettingFrameSliderTemplate");
        self.sliders[i]:Hide();
    end

    -- Prepare some bit tables.
    self.bitTables = {};
    for i=1, MAX_BIT_TABLES do
        self.bitTables[i] = CreateFrame("Frame", nil, self, "BossEncounter2_SettingFrameBitTableTemplate");
    end

    Root.SetBackdrop(self, "OPTION");
end

function SettingFrame.OnBitTableLoad(self)
    -- Properties
    self.isBitTable = true;

    -- Children
    self.title = Root.CreateFontString(self, "ARTWORK", "NormalYellow", nil, "MIDDLE", "MIDDLE");
    self.title:SetPoint("TOP", self, "TOP", 0, -8);

    local b;
    self.bits = {};
    for b=1, NUM_BITS_PER_BIT_TABLE do
        self.bits[b] = CreateFrame("CheckButton", nil, self, "BossEncounter2_SettingFrameCheckButtonTemplate");
        self.bits[b]:Hide();
    end

    Root.SetBackdrop(self, "OPTION");
end

function SettingFrame.OnUpdate(self, elapsed)
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

    if ( self.status == "RUNNING" ) then
        self.nextRefresh = max(0, self.nextRefresh - elapsed);
        if ( self.nextRefresh == 0 ) then
            self:Refresh();
        end

        -- Auto-close if the module does not allow access to its options.
        if ( not self.module:MayEditSettings() ) then
            self:Close();
        end
    end

    -- Application on the frame
    self:ClearAllPoints();
    self:SetScale(scale);
    self:SetAlpha(alpha);
    self:SetPoint("CENTER", self:GetParent(), "CENTER", Root.PctToPx("X", XPOSITION - 0.5), Root.PctToPx("Y", YPOSITION - 0.5));
end

function SettingFrame.OnCloseButtonClick(button)
    local self = button:GetParent();
    self:Close();
end

function SettingFrame.OnDefaultButtonClick(button)
    local self = button:GetParent();
    self:SetDefaults();
end

function SettingFrame.OnNextButtonClick(button)
    local self = button:GetParent();
    if ( not self.nextModule ) then return; end

    self.module = self.nextModule;
    self:Refresh();
end

function SettingFrame.OnCheckButtonClick(button)
    local self = button:GetParent();
    if ( self.isBitTable ) then
        SettingFrame.OnBitTableClick(button);
        return;
    end
    if ( button.hasLock ) then
        button:SetChecked(button.lockValue);
  else
        local key = button.id;
        if ( button.isPerCharacter ) then key = key..":"..UnitGUID("player"); end

        if ( button:GetChecked() ) then
            PlaySound("igMainMenuOptionCheckBoxOn");
            self.module.settingsValue[key] = true;
      else
            PlaySound("igMainMenuOptionCheckBoxOff");
            self.module.settingsValue[key] = false;
        end
        self:NotifySettingChange(button.id);
    end
end

function SettingFrame.OnBitTableClick(button)
    local bitTable = button:GetParent();
    local self = bitTable:GetParent();

    local key = bitTable.id;
    if ( bitTable.isPerCharacter ) then key = key..":"..UnitGUID("player"); end

    local bitRank = button:GetID()-1;
    local bitMask = bit.band((2^NUM_BITS_PER_BIT_TABLE-1) - 2^bitRank, self.module.settingsValue[key] or 0);
    local bitValue = 0;

    if ( button:GetChecked() ) then
        PlaySound("igMainMenuOptionCheckBoxOn");
        bitValue = 2^bitRank;
  else
        PlaySound("igMainMenuOptionCheckBoxOff");
    end

    self.module.settingsValue[key] = bit.bor(bitValue, bitMask);
    self:NotifySettingChange(bitTable.id);
end

function SettingFrame.OnSliderUpdate(slider, elapsed)
    if ( not slider.id ) then return; end

    local self = slider:GetParent();

    if ( slider.hasLock ) then
        slider:SetValue(slider.lockValue);
  else
        local key = slider.id;
        if ( slider.isPerCharacter ) then key = key..":"..UnitGUID("player"); end

        slider:GetParent().module.settingsValue[key] = slider:GetValue();
        self:NotifySettingChange(slider.id);
    end

    -- Update value text
    local newValueText = string.format(slider.valueTextTemplate or "%d", slider:GetValue());
    slider.valueText:SetText(newValueText);
end