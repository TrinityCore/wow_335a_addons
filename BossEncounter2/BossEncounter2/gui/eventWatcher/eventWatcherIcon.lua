local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["EventWatcherIcon"] = { };
local EventWatcherIcon = Widgets["EventWatcherIcon"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local PIN_TEXTURE = Root.folder.."gfx\\EventIconNumerical";

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display(number or texture)                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event icon.                                         *
-- * >> number or texture: a number OR a texture.                     *
-- ********************************************************************
-- * Displays an event icon, either with a game texture or a numbered *
-- * pin.                                                             *
-- ********************************************************************
local function Display(self, texture)
    if type(self) ~= "table" or ( not texture ) then return; end

    local tryNumber = tonumber(texture);
    if ( tryNumber ) then
        -- It's a number displayed in the pin.
        self.pin:SetTexture(PIN_TEXTURE);
        self.text:SetText(tryNumber);
        self:Show();

elseif type(texture) == "string" then
        -- It's a given texture.
        self.pin:SetTexture(texture);
        self.text:SetText("");
        self:Show();
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function EventWatcherIcon.OnLoad(self)
    -- Properties

    -- Methods
    self.Display = Display;

    -- Children
    self.pin = self:CreateTexture(nil, "BACKGROUND");
    self.pin:SetTexCoord(0, 1, 0, 1);
    self.pin:SetAllPoints(self);
    self.pin:Show(); 

    self.text = Root.CreateFontString(self, "OVERLAY", "NormalWhite", nil, "MIDDLE", "MIDDLE");
    self.text:SetPoint("CENTER", self, "CENTER", 0, 0);
    self.text:Show(); 

    -- Initial state
    self:Hide();
end