local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["PerformanceFrame"] = { };
local PerformanceFrame = Widgets["PerformanceFrame"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

local DEFAULT_SCROLL_TIME = 0.500;
local DEFAULT_XPOSITION = 0.30;
local DEFAULT_YPOSITION = 0.45;

local DEFAULT_BAR_GROW_TIME = 1.40;
local DEFAULT_RANKING_TIME = 0.50;

local NEW_RECORD_BLINK_TIME = 0.90;

local HALO_TEXTURE = Root.folder.."gfx\\Halo";
local HALO_SIZE = 128;

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local criterias = {
    [1] = {
        name = "Attempt",
        value = "attempt",
        color = {0.00, 0.00, 1.00},
    },
    [2] = {
        name = "Speed",
        value = "speed",
        color = {1.00, 0.00, 0.00},
    },
    [3] = {
        name = "Technique",
        value = "technique",
        color = {0.00, 1.00, 0.00},
    },
}

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Display([x, y, time, recordScore])                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the performance frame.                                  *
-- * >> x, y: position of the X/Y center of the performance frame.    *
-- * >> time: the time needed to scroll-in the performance frame.     *
-- * >> recordScore: the current or previous record score. Nil can be *
-- * used to say none.                                                *
-- ********************************************************************
-- * Starts displaying the performance frame.                         *
-- ********************************************************************
local function Display(self, x, y, time, recordScore)
    if type(self) ~= "table" then return; end
    if ( self.displayStatus ~= "STANDBY" and self.displayStatus ~= "CLOSING" ) then return; end

    -- Prepare the display vars
    self.displayStatus = "OPENING";
    self.displayTimer = 0;
    self.displayTimerMax = time or DEFAULT_SCROLL_TIME;
    self.centerX = x or DEFAULT_XPOSITION;
    self.centerY = y or DEFAULT_YPOSITION;

    -- Reset the animation vars and widgets
    self.animationStatus = "STANDBY";
    self.animationTimer = 0.00;

    -- 1. Set record
    self.newRecordLabel:Hide();
    self.halo:Hide();
    if ( not recordScore ) then
        self.rankRecordPoints:SetText("");
        Root.SetRankOnTexture(self.rankRecordTexture, "-");
  else
        Root.SetPointsText(self.rankRecordPoints, recordScore, 300);
        Root.SetRankOnTexture(self.rankRecordTexture, Root.PtsToRank(recordScore));
    end

    -- 2. Set current rank
    self.rankNowTexture:SetAlpha(0);
    Root.SetPointsText(self.rankNowPoints, 0);

    -- 3. Set criterias
    local i, me;
    for i=1, #self.criterias do
        me = self.criterias[i];
        me.bar:SetValue(0);
        Root.SetPointsText(me.valueText, 0);
    end

    self.closeButton:Disable();

    -- And display the frame
    self:Show();
    PerformanceFrame.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Remove([atOnce, time])                                      *
-- ********************************************************************
-- * >> self: the performance frame.                                  *
-- * >> atOnce: if set, performance frame will be hidden instantly.   *
-- * >> time: the time we'll have to take to perform the scroll-out   *
-- * animation. Note this parameter is not useful if atOnce is true.  *
-- ********************************************************************
-- * Stops displaying the performance frame.                          *
-- ********************************************************************
local function Remove(self, atOnce, time)
    if type(self) ~= "table" then return; end
    if ( self.displayStatus ~= "OPENING" and self.displayStatus ~= "RUNNING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.displayStatus = "STANDBY";
        self:Hide();
  else
        self.displayStatus = "CLOSING";
        self.displayTimer = 0;
        self.displayTimerMax = time or DEFAULT_SCROLL_TIME;
    end
end

-- ********************************************************************
-- * self:Animate(attempt, speed, technique[,                         *
-- *              growTimer, rankTimer, hasNewRecord, recordScore])   *
-- ********************************************************************
-- * >> self: the performance frame.                                  *
-- * >> attempt, speed, technique: the value of each criteria. 0~120. *
-- * >> growTimer: the time it will be needed by the performance      *
-- * frame to grow the criteria bars to their final value.            *
-- * >> rankTimer: the time it will be needed by tdhe performance     *
-- * frame to show the deserved rank.                                 *
-- * >> hasNewRecord: if true, the New record message will be         *
-- * flashing on the rank texture.                                    *
-- ********************************************************************
-- * Animates the performance frame by growing each one of its        *
-- * criteria bars then popping in the rank texture. Can also mention *
-- * a new record beaten.                                             *
-- ********************************************************************
local function Animate(self, attempt, speed, technique, growTimer, rankTimer, hasNewRecord)
    if type(self) ~= "table" then return; end
    if ( self.animationStatus ~= "STANDBY" ) then return; end

    self.animationStatus = "GROWING";
    self.animationTimer = growTimer;
    self.growTimer = growTimer;
    self.rankTimer = rankTimer;
    self.hasNewRecord = hasNewRecord;

    self.attempt = attempt;
    self.speed = speed;
    self.technique = technique;
    self.points = attempt + speed + technique;
end

-- ********************************************************************
-- * self:GetDisplayStatus()                                          *
-- ********************************************************************
-- * >> self: the performance frame.                                  *
-- ********************************************************************
-- * Get the current internal display status of the performance frame.*
-- * Can be either OPENING, RUNNING, CLOSING or STANDBY.              *
-- ********************************************************************
local function GetDisplayStatus(self)
    if type(self) ~= "table" then return; end

    return self.displayStatus;
end

-- ********************************************************************
-- * self:GetAnimationStatus()                                        *
-- ********************************************************************
-- * >> self: the performance frame.                                  *
-- ********************************************************************
-- * Get the current internal anim status of the performance frame.   *
-- * Can be either STANDBY, GROWING, RANKING or NEWRECORD.            *
-- ********************************************************************
local function GetAnimationStatus(self)
    if type(self) ~= "table" then return; end

    return self.animationStatus;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function PerformanceFrame.OnLoad(self)
    -- Properties
    self.displayStatus = "STANDBY";
    self.displayTimer = 0.00;
    self.animationStatus = "STANDBY";
    self.animationTimer = 0.00;

    -- Methods
    self.Display = Display;
    self.Remove = Remove;
    self.Animate = Animate;
    self.GetDisplayStatus = GetDisplayStatus;
    self.GetAnimationStatus = GetAnimationStatus;

    -- Children
    self.title = Root.CreateFontString(self, "ARTWORK", "Big", nil, "MIDDLE", "BOTTOM");
    self.title:SetHeight(32);
    self.title:SetPoint("BOTTOM", self, "TOP", 0, -8);
    self.title:SetText(Root.Localise("Performances"));
    self.title:Show();

    self.closeButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.closeButton:SetPoint("TOPLEFT", self, "TOPLEFT", 8, -8);
    self.closeButton:SetWidth(32);
    self.closeButton:SetHeight(16);
    self.closeButton:SetText("X");
    self.closeButton:SetScript("OnClick", PerformanceFrame.OnCloseButtonClick);
    self.closeButton:Show();

    self.rankNow = Root.CreateFontString(self, "ARTWORK", "Big", 20, "MIDDLE", "BOTTOM");
    self.rankNow:SetHeight(20);
    self.rankNow:ClearAllPoints();
    self.rankNow:SetPoint("BOTTOM", self, "TOPRIGHT", -48, -32);
    self.rankNow:SetText(Root.Localise("Rank"));
    self.rankNow:Show();

    self.rankNowTexture = self:CreateTexture(nil, "ARTWORK");
    self.rankNowTexture:SetPoint("CENTER", self.rankNow, "BOTTOM", 0, -2 - 12);
    self.rankNowTexture:Hide();

    self.rankNowPoints = Root.CreateFontString(self, "ARTWORK", "NormalYellow", nil, "RIGHT", "BOTTOM");
    self.rankNowPoints:SetWidth(56);
    self.rankNowPoints:SetHeight(8);
    self.rankNowPoints:ClearAllPoints();
    self.rankNowPoints:SetPoint("TOP", self.rankNow, "BOTTOM", 0, -8 - 24);
    self.rankNowPoints:Show();

    self.recordLabel = Root.CreateFontString(self, "ARTWORK", "NormalYellow", nil, "MIDDLE", "BOTTOM");
    self.recordLabel:SetHeight(8);
    self.recordLabel:ClearAllPoints();
    self.recordLabel:SetPoint("BOTTOM", self, "TOPRIGHT", -48, -88);
    self.recordLabel:SetText(Root.Localise("Record"));
    self.recordLabel:Show();

    self.rankRecord = Root.CreateFontString(self, "ARTWORK", "Big", 20, "MIDDLE", "BOTTOM");
    self.rankRecord:SetHeight(20);
    self.rankRecord:ClearAllPoints();
    self.rankRecord:SetPoint("TOP", self.recordLabel, "BOTTOM", 0, -4);
    self.rankRecord:SetText(Root.Localise("Rank"));
    self.rankRecord:Show();

    self.rankRecordTexture = self:CreateTexture(nil, "ARTWORK");
    self.rankRecordTexture:SetWidth(24);
    self.rankRecordTexture:SetHeight(24);
    self.rankRecordTexture:SetPoint("CENTER", self.rankRecord, "BOTTOM", 0, -2 - 12);
    self.rankRecordTexture:Hide();

    self.rankRecordPoints = Root.CreateFontString(self, "ARTWORK", "NormalYellow", nil, "RIGHT", "BOTTOM");
    self.rankRecordPoints:SetWidth(56);
    self.rankRecordPoints:SetHeight(8);
    self.rankRecordPoints:ClearAllPoints();
    self.rankRecordPoints:SetPoint("TOP", self.rankRecord, "BOTTOM", 0, -8 - 24);
    self.rankRecordPoints:Show();

    self.newRecordLabel = self:CreateTexture(nil, "ARTWORK");
    Root.SetLocalizedTexture(self.newRecordLabel, "NEWRECORD");
    self.newRecordLabel:SetPoint("BOTTOMLEFT", self, "BOTTOM", -self.newRecordLabel.t_usedWidth/2 - 24, 8);
    self.newRecordLabel:Hide();

    self.haloFrame = CreateFrame("Frame", nil, self);
    self.haloFrame:SetFrameLevel(self:GetFrameLevel() + 2);
    self.halo = self.haloFrame:CreateTexture(nil, "OVERLAY");
    self.halo:SetWidth(HALO_SIZE);
    self.halo:SetHeight(HALO_SIZE);
    self.halo:SetTexture(HALO_TEXTURE);
    self.halo:Hide();

    local i, me;
    self.criterias = { };
    for i=1, #criterias do
        self.criterias[i] = {
            bar = CreateFrame("StatusBar", nil, self),
            title = Root.CreateFontString(self, "ARTWORK", "SmallYellow", nil, "LEFT", "BOTTOM"),
            valueText = Root.CreateFontString(self, "ARTWORK", "NormalYellow", nil, "RIGHT", "BOTTOM"),
            value = criterias[i].value,
            color = criterias[i].color,
        }
        me = self.criterias[i];
        me.bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        me.bar:SetMinMaxValues(0, 120);
        me.bar:SetWidth(160);
        me.bar:SetHeight(6);
        me.bar:SetPoint("LEFT", self, "TOPLEFT", 16, -8 - (i)*36);

        me.bar.background = me.bar:CreateTexture(nil, "BACKGROUND");
        me.bar.background:SetAllPoints(me.bar);
        me.bar.background:SetTexture(0, 0, 0, 0.5);

        me.title:SetHeight(8);
        me.title:ClearAllPoints();
        me.title:SetPoint("BOTTOMLEFT", me.bar, "TOPLEFT", 0, 0);
        me.title:SetText(Root.Localise(criterias[i].name));
        me.valueText:SetWidth(56);
        me.valueText:SetHeight(8);
        me.valueText:ClearAllPoints();
        me.valueText:SetPoint("BOTTOMRIGHT", me.bar, "TOPRIGHT", 0, 0);
    end

    Root.SetBackdrop(self, "TOOLTIP");
end

function PerformanceFrame.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.displayStatus == "STANDBY" ) then
        self:Hide();
        return;
    end

    -- Open/close
    if ( self.displayStatus == "OPENING" ) then
        self.displayTimer = min(self.displayTimerMax, self.displayTimer + elapsed);
        if ( self.displayTimer == self.displayTimerMax ) then self.displayStatus = "RUNNING"; end
    end
    if ( self.displayStatus == "CLOSING" ) then
        self.displayTimer = min(self.displayTimerMax, self.displayTimer + elapsed);
        if ( self.displayTimer == self.displayTimerMax ) then self:Remove(true); end
    end
    -- Positionning handling
    local y = self.centerY;
    local outscreenY = 1.2;
    if ( self.centerY <= 0.5 ) then outscreenY = -0.2; end

    if ( self.displayStatus == "OPENING" ) then
        y = outscreenY + ( self.centerY - outscreenY ) * (( self.displayTimer / self.displayTimerMax )^1.0);
elseif ( self.displayStatus == "CLOSING" ) then
        y = outscreenY + ( self.centerY - outscreenY ) * (( 1 - self.displayTimer / self.displayTimerMax )^0.5);
    end

    -- Animation handling
    self.animationTimer = max(0, self.animationTimer - elapsed);
    if ( self.animationStatus == "GROWING" ) then
        local progression = 1 - self.animationTimer / self.growTimer;

        local i, me, value, r, g, b;
        for i=1, #self.criterias do
            me = self.criterias[i];
            value = (self[me.value] or 0) * progression;
            me.bar:SetValue(value);
            Root.SetPointsText(me.valueText, value, 100);
            r, g, b = unpack(me.color);
            -- r = r * min(1, progression + 0.5);
            -- g = g * min(1, progression + 0.5);
            -- b = b * min(1, progression + 0.5);
            me.bar:SetStatusBarColor(r, g, b);
        end

        Root.SetPointsText(self.rankNowPoints, (self.attempt + self.speed + self.technique) * progression, 300);

        if ( self.animationTimer == 0 ) then
            self.animationStatus = "RANKING";
            self.animationTimer = self.rankTimer;
            Root.SetRankOnTexture(self.rankNowTexture, Root.PtsToRank(self.points));
        end

elseif ( self.animationStatus == "RANKING" ) then
        local progression = 1 - self.animationTimer / self.rankTimer;
        local scaling = 8 / (progression * 7 + 1);

        self.rankNowTexture:SetWidth(24 * scaling);
        self.rankNowTexture:SetHeight(24 * scaling);
        self.rankNowTexture:SetAlpha(progression);

        if ( self.animationTimer == 0 ) then
            if ( self.hasNewRecord ) then
                self.animationStatus = "NEWRECORD";
                self.animationTimer = NEW_RECORD_BLINK_TIME;
                Root.Sound.Play("NEWRECORD");
          else
                self.animationStatus = "STANDBY";
            end
            self.closeButton:Enable();
        end

elseif ( self.animationStatus == "NEWRECORD" ) then
        local progression = -0.2 + (1.4 * (1 - self.animationTimer/ NEW_RECORD_BLINK_TIME));
        local displayProportion = min(1, max(0, progression));
        local uWidth, rWidth = self.newRecordLabel.t_usedWidth, self.newRecordLabel.t_realWidth;

        if ( displayProportion > 0 ) then
            self.newRecordLabel:Show();
            self.newRecordLabel:SetTexCoord(0, displayProportion * uWidth / rWidth, 0, 1);
            self.newRecordLabel:SetWidth(displayProportion * uWidth);
      else
            self.newRecordLabel:Hide();
        end

        local alpha = 1;
        if ( progression < 0 ) then
            alpha = 1 + progression / 0.2;
    elseif ( progression > 1.0 ) then
            alpha = 1 - (progression - 1.0) / 0.2;
        end


        self.halo:Show();
        self.halo:SetPoint("CENTER", self.newRecordLabel, "LEFT", uWidth * progression, 0);
        self.halo:SetAlpha(alpha);
        self.halo:SetWidth(HALO_SIZE * alpha);
        self.halo:SetHeight(HALO_SIZE * alpha);
        Root.RotateTexture(self.halo, progression * 360);

        if ( self.animationTimer == 0 ) then
            self.animationStatus = "STANDBY";
        end
    end

    local parent = self:GetParent();
    local finalX = (self.centerX - 0.5) * parent:GetWidth();
    local finalY = (y - 0.5) * parent:GetHeight();

    -- Application on the frame
    self:ClearAllPoints();
    self:SetPoint("CENTER", parent, "CENTER", finalX, finalY);
end

function PerformanceFrame.OnCloseButtonClick(button)
    local resultSeq = button:GetParent():GetParent();
    button:Disable();
    resultSeq:Stop();
end
