local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["AddWindowRow"] = { };
local AddWindowRow = Widgets["AddWindowRow"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local BAR_TEXTURE = Root.folder.."gfx\\AddBars";

local BAR_UPDATE_RATE = 0.050;
local VARIATION_PER_SEC = 0.25;

local OPEN_TIME = 0.500;
local CLOSE_TIME = 0.400;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display()                                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- ********************************************************************
-- * Displays an add row inside the add window.                       *
-- ********************************************************************
local function Display(self)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    self.status = "OPENING";
    self.timer = OPEN_TIME;

    local used, label, barLayout = self:GetParent():GetBonusColumnInfo();
    local nameOffset, nameWidth, hpOffset, hpWidth, bonusOffset, bonusWidth = self:GetParent():GetColumnOffsets();

    self:SetBarLayout(1, 2, hpWidth, true);
    self:SetBarLayout(2, barLayout, bonusWidth, used);

    self.hpBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", hpOffset, 0);
    self.bonusBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", bonusOffset, 0);

    self.nameOffset = nameOffset;
    self.nameWidth = nameWidth;

    self:Show();
    AddWindowRow.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove(atOnce)                                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- * >> atOnce: specifies if the row should be hidden at once.        *
-- ********************************************************************
-- * Remove an add row inside the add window.                         *
-- ********************************************************************
local function Remove(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "OPENING" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    self:GetSecureFrame():Remove();

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        self.status = "CLOSING";
        self.timer = CLOSE_TIME;
    end
end

-- ********************************************************************
-- * self:DefineBar(index, bar, transitionBar, bgBar, font, blink)    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- * >> index: index where are stored the constants in the config.    *
-- * >> bar: the bar we want to set.                                  *
-- * >> transitionBar: the transition bar we want to set.             *
-- * >> bgBar: the background layer we want to set.                   *
-- * >> font: the font object used to display bar's value.            *
-- * >> blink: if set, the font will blink when the value gets low.   *
-- ********************************************************************
-- * Define a bar inside the add row.                                 *
-- ********************************************************************
local function DefineBar(self, index, bar, transitionBar, bgBar, font, blink)
    self.bars[index] = {
        bar = bar,
        tBar = transitionBar,
        bgBar = bgBar,
        font = font,
        currentFraction = 1,
        targetFraction = 1,
        max = 0,
        suffix = "",
        blink = blink or false,
    };
    bar:SetTexture(BAR_TEXTURE);
    bar:SetHeight(3);
    transitionBar:SetHeight(3);
    bgBar:SetTexture(BAR_TEXTURE);
    bgBar:SetTexCoord(0, 1, 0/32, 4/32);
    bgBar:SetHeight(4);
    bgBar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0);
    font:SetPoint("BOTTOMRIGHT", bgBar, "TOPRIGHT", 0, 0);
end

-- ********************************************************************
-- * self:SetBarLayout(index, layout, width, used)                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- * >> index: index of the bar to change.                            *
-- * >> layout: the ID of the layout. See below:                      *
-- * 1=Teal bar     2=Blue bar     3=Orange bar                       *
-- * >> width: the total width of the bar.                            *
-- * >> used: whether the bar is used or not.                         *
-- ********************************************************************
-- * Change the layout of one of the bars.                            *
-- ********************************************************************
local function SetBarLayout(self, index, layout, width, used)
    if type(self) ~= "table" then return; end

    local barTable = self.bars[index];
    local bar, tBar, bg = barTable.bar, barTable.tBar, barTable.bgBar;

    barTable.layout = layout;
    barTable.width = width;
    barTable.used = used;

    bg:SetWidth(width);
    bar:SetTexCoord(0, 1, (layout * 8)/32, (layout * 8 + 1)/32);

    self:UpdateBar(barTable, 0);
end

-- ********************************************************************
-- * self:SetBarValue(index, fraction, max, instant)                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- * >> index: index of the bar to change.                            *
-- * >> fraction: the new fill value, between 0~1.                    *
-- * >> max: the max bar value.                                       *
-- * >> instant: true if the bar has to change instantly.             *
-- ********************************************************************
-- * Change the value of one of the bars.                             *
-- * Fraction can be "?". If that is the case, the value on the bar   *
-- * will be replaced by ?'s.                                         *
-- ********************************************************************
local function SetBarValue(self, index, fraction, max, instant)
    if type(self) ~= "table" then return; end

    if type(fraction) == "number" then
        fraction = math.max(0, math.min(1, fraction));
    end

    local barTable = self.bars[index];

    if ( instant ) and ( fraction ~= "?" ) then
        barTable.currentFraction = fraction;
    end
    barTable.targetFraction = fraction;
    barTable.max = max or barTable.max;

    self:UpdateBar(barTable, 0);
end

-- ********************************************************************
-- * self:SetBarSuffix(index, suffix)                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- * >> index: index of the bar to change.                            *
-- * >> suffix: the suffix string.                                    *
-- ********************************************************************
-- * Change the string suffix of a bar.                               *
-- ********************************************************************
local function SetBarSuffix(self, index, suffix)
    if type(self) ~= "table" then return; end

    local barTable = self.bars[index];

    barTable.suffix = suffix;

    self:UpdateBar(barTable, 0);
end

-- ********************************************************************
-- * self:UpdateBars(elapsed)                                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- * >> elapsed: the time elapsed.                                    *
-- ********************************************************************
-- * Update all bars from the row.                                    *
-- ********************************************************************
local function UpdateBars(self, elapsed)
    if type(self) ~= "table" then return; end

    local i;
    for i=1, #self.bars do
        self:UpdateBar(self.bars[i], elapsed);
    end
end

-- ********************************************************************
-- * self:UpdateBar(t, elapsed)                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- * >> t: the table of the bar to update.                            *
-- * >> elapsed: the time elapsed.                                    *
-- ********************************************************************
-- * Update one of the bar from the row.                              *
-- ********************************************************************
local function UpdateBar(self, t, elapsed)
    if type(self) ~= "table" or type(t) ~= "table" then return; end
    elapsed = elapsed or 0;

    if ( not t.used ) then
        t.bar:Hide();
        t.tBar:Hide();
        t.bgBar:Hide();
        t.font:Hide();
        return;
    end

    t.bgBar:Show();

    if ( t.targetFraction == "?" ) then
        local num = 2;
        if ( t.width > 64 ) then num = 4; end
        t.font:SetText(strrep("?", num), 0.75);
        return;
    end

    local barWidth = t.width-1;

    if ( t.currentFraction == t.targetFraction ) then
        t.tBar:Hide();
  else
        t.tBar:Show();
        t.tBar:ClearAllPoints();

        local tWidth = (t.targetFraction - t.currentFraction) * barWidth;
        if ( tWidth < 0 ) then
            t.tBar:SetTexture(0.75, 0, 0);
            t.tBar:SetWidth(-tWidth);
            t.tBar:SetPoint("LEFT", t.bar, "LEFT", t.targetFraction * barWidth, 0);
      else
            t.tBar:SetTexture(0, 0.75, 0);
            t.tBar:SetWidth(tWidth);
            t.tBar:SetPoint("RIGHT", t.bar, "LEFT", t.targetFraction * barWidth, 0);
        end

        if ( t.currentFraction < t.targetFraction ) then
            t.currentFraction = min(t.targetFraction, t.currentFraction + VARIATION_PER_SEC * elapsed);
    elseif ( t.currentFraction > t.targetFraction ) then
            t.currentFraction = max(t.targetFraction, t.currentFraction - VARIATION_PER_SEC * elapsed);
        end
    end

    if ( t.currentFraction == 0 ) then
        t.bar:Hide();
  else
        t.bar:SetWidth(barWidth * t.currentFraction);
        t.bar:Show();
    end

    local r, g, b = 1, 1, 1;
    local fraction = t.targetFraction;
    if ( t.targetFraction == "?" ) then fraction = t.currentFraction; end

    if ( t.max > 0 ) then
        if ( fraction <= 0 ) then
            r, g, b = 1, 0, 0;
    elseif ( t.currentFraction <= 0.25 ) then
            if ( t.blink ) and ( fraction <= 0.20 ) then
                local mod = sin(math.fmod(GetTime() / 0.75 * 180, 180));
                r, g, b = 1, mod, 0;
          else
                r, g, b = 1, 1, 0;
            end
        end
    end

    local currentValue = math.floor(t.currentFraction * t.max + 0.5);
    t.font:SetNumericText(currentValue, t.width, 0.75, r, g, b, t.suffix);
end

-- ********************************************************************
-- * self:SetName(name, icon)                                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- * >> name: the name of the entity on the row.                      *
-- * >> icon: the ID of the raid symbol it has or a class name.       *
-- ********************************************************************
-- * Set the name of the entity of a row as well as its symbol.       *
-- ********************************************************************
local function SetName(self, name, symbol)
    self.nameText:SetText(name);

    Root.SetIcon(self.symbol, symbol);

    if ( symbol ) and ( symbol ~= 0 ) then
        self.symbol:SetPoint("LEFT", self, "LEFT", self.nameOffset, 0);
        self.nameText:SetPoint("LEFT", self, "LEFT", self.nameOffset + 16, -2);
        self.nameText:SetWidth(self.nameWidth - 16);
  else
        self.nameText:SetPoint("LEFT", self, "LEFT", self.nameOffset, -2);
        self.nameText:SetWidth(self.nameWidth);
    end
end

-- ********************************************************************
-- * self:SetPosition(index)                                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- * >> index: the row position. 1 is the uppermost.                  *
-- ********************************************************************
-- * Set an add row at a given position on the add window.            *
-- ********************************************************************
local function SetPosition(self, index)
    self.position = index;
    self.reqHeight = 24 + index * 20;
    self:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", 0, -index * 20);
end

-- ********************************************************************
-- * self:GetSecureFrame()                                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- ********************************************************************
-- * Get the secure frame of the add row.                             *
-- ********************************************************************
local function GetSecureFrame(self)
    return self.SecureFrame;
end

-- ********************************************************************
-- * self:IsLocked()                                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window row.                                     *
-- ********************************************************************
-- * Determinate if a row is locked because it has enabled its        *
-- * secure frame in combat. A second return indicates if the secure  *
-- * frame is currently used (regardless of combat state).            *
-- ********************************************************************
local function IsLocked(self)
    local secureFrame = self:GetSecureFrame();
    if ( secureFrame:IsRunning() ) then
        return InCombatLockdown() ~= nil, true;
    end
    return false, false;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function AddWindowRow.OnLoad(self)
    -- Properties
    self.nextBarUpdate = 0;
    self.status = "STANDBY";
    self.timer = 0;
    self.position = 0;
    self.reqHeight = 0;

    -- Methods
    self.Display = Display;
    self.Remove = Remove;
    self.DefineBar = DefineBar;
    self.SetBarLayout = SetBarLayout;
    self.SetBarValue = SetBarValue;
    self.SetBarSuffix = SetBarSuffix;
    self.UpdateBars = UpdateBars;
    self.UpdateBar = UpdateBar;
    self.SetName = SetName;
    self.SetPosition = SetPosition;
    self.GetSecureFrame = GetSecureFrame;
    self.IsLocked = IsLocked;

    -- Children
    self.bars = { };
    self.hpBar = self:CreateTexture(nil, "BORDER");
    self.hpBarBackground = self:CreateTexture(nil, "BACKGROUND");
    self.hpBarTransition = self:CreateTexture(nil, "ARTWORK");
    self.bonusBar = self:CreateTexture(nil, "BORDER");
    self.bonusBarBackground = self:CreateTexture(nil, "BACKGROUND");
    self.bonusBarTransition = self:CreateTexture(nil, "ARTWORK");

    self.hpFont = CreateFrame("Frame", nil, self, "BossEncounter2_AddWindowRowFontTemplate");
    self.bonusFont = CreateFrame("Frame", nil, self, "BossEncounter2_AddWindowRowFontTemplate");

    self.nameText = Root.CreateFontString(self, "OVERLAY", "SmallWhite", nil, "LEFT", "MIDDLE");
    self.nameText:SetHeight(16);

    self.symbol = self:CreateTexture(nil, "OVERLAY");
    self.symbol:SetWidth(16);
    self.symbol:SetHeight(16);
    self.symbol:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
    self.symbol:Hide();

    self:DefineBar(1, self.hpBar,       self.hpBarTransition,    self.hpBarBackground, self.hpFont,    true);
    self:DefineBar(2, self.bonusBar, self.bonusBarTransition, self.bonusBarBackground, self.bonusFont, false);

    self.SecureFrame = CreateFrame("Frame", nil, self, "BossEncounter2_SecureFrameTemplate");

    -- Initial state
    self:Hide();
end

function AddWindowRow.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    local locked, secure = self:GetParent():IsLocked();
    local alpha = 1.0;

    -- Open/close
    if ( self.status == "OPENING" ) then
        if ( self:GetParent().height >= self.reqHeight ) then
            self.timer = max(0, self.timer - elapsed);
        end
        if ( self.timer == 0 ) then self.status = "RUNNING"; end
        alpha = 1 - self.timer / OPEN_TIME;
    end
    if ( self.status == "CLOSING" ) and ( not locked ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then self:Remove(true); end
        alpha = self.timer / CLOSE_TIME;
    end

    self:SetAlpha(alpha);

    if ( self.status == "RUNNING" ) then
        self.nextBarUpdate = self.nextBarUpdate - elapsed;
        while ( self.nextBarUpdate <= 0 ) do
            self.nextBarUpdate = self.nextBarUpdate + BAR_UPDATE_RATE;
            self:UpdateBars(BAR_UPDATE_RATE);
        end
    end
end