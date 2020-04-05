local Root = BossEncounter2;
local Preload = Root.GetOrNewModule("Preload");
local Widgets = Root.GetOrNewModule("Widgets");

Widgets["SuperAlert"] = { };
local SuperAlert = Widgets["SuperAlert"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

local OPEN_TIME   = 0.20; -- Huge sign zooms in, UIParent is less visible.
local SCROLL_TIME = 0.15; -- Huge sign moves and position itself while border appears; red flash kicks in.
local FADE_TIME   = 0.40; -- Everything fades out and UIParent is reverted.

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local SIGN_TEXTURE = Root.folder.."gfx\\HugeWarningSign";
local BAR_BORDER_TEXTURE = Root.folder.."gfx\\HugeWarningBar";
local BAR_INSIDE_TEXTURE = Root.folder.."gfx\\HugeWarningBarInside";

local FLASH_INTENSITY = 0.10;
local FLASH_VAR = 0.25; -- this means +/- 25%
local UI_PARENT_ALPHA = 0.33;
local SIGN_OFS_X, SIGN_OFS_Y = -256, 8;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display(timer, message[, instruction, hideInterface])       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the super alert frame.                                  *
-- * >> timer: the timer before the very bad thing goes off.          *
-- * >> message[, instruction]: message to display.                   *
-- * >> hideInterface: set this to true to hide the UI. Useful to     *
-- * force UI freaks (especially healers) to pay attention to alerts. *
-- ********************************************************************
-- * Starts displaying the super alert frame.                         *
-- ********************************************************************
local function Display(self, timer, message, instruction, hideInterface)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    self.status = "OPENING";
    self.animTimer = OPEN_TIME;
    self.hideInterface = hideInterface or false;

    self.timer = timer;
    self.timerMax = timer;

    self.text:SetText(message);
    self.text:Show();
    if ( instruction ) and ( #instruction > 0 ) then
        self.text:SetPoint("BOTTOM", self.bar, "TOP", 0, 48);
        self.instruction:SetText(instruction);
        self.instruction:Show();
  else
        self.text:SetPoint("BOTTOM", self.bar, "TOP", 0, 8);
        self.instruction:Hide();
    end

    self:Show();
    SuperAlert.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * >> self: the super alert frame.                                  *
-- * >> atOnce: if set, the super alert will be hidden instantly.     *
-- ********************************************************************
-- * Stops displaying the super alert.                                *
-- ********************************************************************
local function Remove(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status == "STANDBY" or self.status == "CLOSING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        self.status = "CLOSING";
        self.animTimer = FADE_TIME;
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function SuperAlert.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.animTimer = 0.000;
    self.timer = 0.000;
    self.timerMax = 0.000;

    -- Methods
    self.Display = Display;
    self.Remove = Remove;

    -- Children
    self.flash = self:CreateTexture(nil, "BACKGROUND");
    self.flash:SetTexture(1, 0, 0, 1);
    self.flash:SetAllPoints(self);

    self.bar = CreateFrame("StatusBar", nil, self);
    self.bar:SetMinMaxValues(0, 1);
    self.bar:SetStatusBarTexture(BAR_INSIDE_TEXTURE);
    self.bar:SetWidth(512);
    self.bar:SetHeight(64);
    self.bar:SetPoint("CENTER", self, "CENTER", 128, -64);
    self.bar.background = self.bar:CreateTexture(nil, "BACKGROUND");
    self.bar.background:SetAllPoints(self.bar);
    self.bar.background:SetTexture(BAR_BORDER_TEXTURE);

    self.sign = CreateFrame("Frame", nil, self);
    self.sign:SetWidth(256);
    self.sign:SetHeight(256);
    self.sign.texture = self.sign:CreateTexture(nil, "OVERLAY");
    self.sign.texture:SetAllPoints(self.sign);
    self.sign.texture:SetTexture(SIGN_TEXTURE);

    self.text = Root.CreateFontString(self.bar, "OVERLAY", "Big", 64, "MIDDLE", "BOTTOM");
    self.instruction = Root.CreateFontString(self.bar, "OVERLAY", "Visible", 24, "MIDDLE", "BOTTOM");
    self.instruction:SetPoint("BOTTOM", self.bar, "TOP", 0, 8);

    -- Fixed position
    self:SetAllPoints(WorldFrame);
end

function SuperAlert.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    self.timer = max(0, self.timer - elapsed);
    self.bar:SetValue((26/512) + (460/512) * self.timer / self.timerMax);

    local signScale = 1;
    local signAlpha = 1;
    local signOffsetX, signOffsetY = SIGN_OFS_X, SIGN_OFS_Y;
    local borderAlpha = 1;
    local uiAlpha = UI_PARENT_ALPHA;
    local flashAlpha = FLASH_INTENSITY;

    self.animTimer = max(0, self.animTimer - elapsed);

    -- Open/close
    if ( self.status == "OPENING" ) then
        progression = 1 - self.animTimer / OPEN_TIME;

        signOffsetX, signOffsetY = 0, 0;
        signAlpha = progression;
        signScale = 5 - 4 * progression;
        borderAlpha = 0;
        uiAlpha = 1 + ( UI_PARENT_ALPHA - 1 ) * progression;
        flashAlpha = 0;

        if ( self.animTimer == 0 ) then
            self.status = "SCROLLING";
            self.animTimer = SCROLL_TIME;
        end

elseif ( self.status == "SCROLLING" ) then
        progression = 1 - self.animTimer / SCROLL_TIME;

        signOffsetX, signOffsetY = SIGN_OFS_X * progression, SIGN_OFS_Y * progression;
        borderAlpha = progression;
        flashAlpha = FLASH_INTENSITY * progression;

        if ( self.animTimer == 0 ) then
            self.status = "RUNNING";
        end

elseif ( self.status == "RUNNING" ) then
        if ( self.timer == 0 ) then
            self:Remove(false);
        end

elseif ( self.status == "CLOSING" ) then
        progression = 1 - self.animTimer / FADE_TIME;

        signAlpha = 1 - progression;
        borderAlpha = 1 - progression;
        flashAlpha = FLASH_INTENSITY * (1 - progression);
        uiAlpha = UI_PARENT_ALPHA + ( 1 - UI_PARENT_ALPHA ) * progression;

        if ( self.animTimer == 0 ) then
            self:Remove(true);
        end
    end

    -- Post calculation adjustments

    if ( not self.hideInterface ) then
        uiAlpha = 1; -- Prevent interface alpha change.
    end
    flashAlpha = max(0, min(1, flashAlpha * (1 + FLASH_VAR * sin(GetTime() / 1.00 * 360))));

    -- Application on the frame components

    self.sign:SetPoint("CENTER", self, "CENTER", signOffsetX, signOffsetY);
    self.sign:SetAlpha(signAlpha);
    self.sign:SetScale(signScale);
    self.bar:SetAlpha(borderAlpha);
    self.flash:SetAlpha(flashAlpha);
    UIParent:SetAlpha(uiAlpha);
end

-- --------------------------------------------------------------------
-- **                             Preload                            **
-- --------------------------------------------------------------------

do
    -- We add here heavy textures that should not be loaded on the fly while in combat to avoid a performance loss.
    -- It is especially important for SuperAlert widget which uses some big textures at a critical point of the combat.
    -- We cannot afford to lose a couple 1/10ths of second because of the texture loading: the game must remain fluid.
    Preload:Add(SIGN_TEXTURE);
    Preload:Add(BAR_BORDER_TEXTURE);
    Preload:Add(BAR_INSIDE_TEXTURE);
end