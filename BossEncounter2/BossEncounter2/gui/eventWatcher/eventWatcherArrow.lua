local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["EventWatcherArrow"] = { };
local EventWatcherArrow = Widgets["EventWatcherArrow"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local TEXTURE = Root.folder.."gfx\\EventArrow";

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display(time, icon)                                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the event arrow.                                        *
-- * >> time: the position of the arrow (0 is the big white mark).    *
-- * >> icon: the icon shown above the arrow. Can be a number or a    *
-- * texture path.                                                    *
-- ********************************************************************
-- * Displays an event icon, either with a game texture or a numbered *
-- * pin.                                                             *
-- ********************************************************************
local function Display(self, time, icon)
    if type(self) ~= "table" then return; end

    if not ( time ) then
        self:Hide();
        return;
    end

    local eventWatcher = self:GetParent();
    local width = eventWatcher:GetWidth();
    local timeScale = eventWatcher:GetTimeScale();

    if ( time < 0 ) then -- The red section is unaffected by time scale and 1 tick = 1 sec.
        timeScale = 1;
    end

    local tick = time / timeScale; -- The big tick between the yellow and red zone is the tick 0.
    local x = (88/128 - 8/128 * tick) * width;

    self:Show();
    --[[
    if ( time > 10.5 ) then
        self:Hide();
elseif ( time > 10.0 ) then
        self:SetAlpha(1 - (time-10)/0.5);
elseif ( time < -4.5 ) then
        self:Hide();
elseif ( time < -4.0 ) then
        self:SetAlpha(1 + (time+4)/0.5);
  else
        self:SetAlpha(1.00);
    end
    ]]
    if ( tick > 10.5 ) then
        self:Hide();
elseif ( tick > 10.0 ) then
        self:SetAlpha(1 - (tick-10)/0.5);
elseif ( tick < -4.5 ) then
        self:Hide();
elseif ( tick < -4.0 ) then
        self:SetAlpha(1 + (tick+4)/0.5);
  else
        self:SetAlpha(1.00);
    end

    self.icon:Display(icon);

    self:SetPoint("BOTTOM", eventWatcher, "BOTTOMLEFT", x+1, 65);
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function EventWatcherArrow.OnLoad(self)
    -- Properties

    -- Methods
    self.Display = Display;

    -- Children
    self.texture = self:CreateTexture(nil, "ARTWORK");
    self.texture:SetTexture(TEXTURE);
    self.texture:SetTexCoord(0, 1, 0, 1);
    self.texture:SetAllPoints(self);
    self.texture:Show(); 

    self.icon = CreateFrame("Frame", nil, self, "BossEncounter2_EventWatcherIconTemplate");
    self.icon:SetPoint("BOTTOM", self, "TOP", 0, -1);

    -- Initial state
    self:Hide();
end