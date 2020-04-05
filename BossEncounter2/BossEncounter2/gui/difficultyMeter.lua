local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["DifficultyMeter"] = { };
local DifficultyMeter = Widgets["DifficultyMeter"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

local OPEN_TIME = 0.50;
local CLOSE_TIME = 0.50;

local DEFAULT_XPOSITION = 0.50;
local DEFAULT_YPOSITION = 0.50;

local TRANSITION_TIME = 1.00;

local CHECK_INTERVAL = 0.25;

local FLASH_CYCLE = 1.00;

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local criterias = {
    [1] = {
        name = "POWER",
        text = Root.Localise("DM-Power"),
        explain = Root.Localise("DM-PowerExplain"),
    },
    [2] = {
        name = "BURST",
        text = Root.Localise("DM-Burst"),
        explain = Root.Localise("DM-BurstExplain"),
    },
    [3] = {
        name = "AOE",
        text = Root.Localise("DM-AOE"),
        explain = Root.Localise("DM-AOEExplain"),
    },
    [4] = {
        name = "CHAOS",
        text = Root.Localise("DM-Chaos"),
        explain = Root.Localise("DM-ChaosExplain"),
    },
    [5] = {
        name = "SKILL",
        text = Root.Localise("DM-Skill"),
        explain = Root.Localise("DM-SkillExplain"),
    },
}

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Open(module)                                                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the difficulty meter.                                   *
-- * >> module: the module the difficulty meter describes.            *
-- ********************************************************************
-- * Open the difficulty meter and show difficulty for a given boss   *
-- * module. The difficulty meter will update automatically if the    *
-- * difficulty info from the module changes.                         *
-- ********************************************************************
local function Open(self, module)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end
    if type(module) ~= "table" then return; end

    -- Check the module hasn't been displayed at all in this session.
    if type(module.GetName) == "function" then
        local moduleName = module:GetName();
        if ( moduleName ) then
            if ( self.noSpamMemory[moduleName] ) then return; end
        end
    end

    -- Prepare the display vars
    self.status = "OPENING";
    self.timer = 0;
    self.module = module;
    self.nextRefresh = 0;
    self.flashTimer = 0;
    self.fightPts = 0;

    -- All points start at zero
    local i, me;
    for i=1, #self.criterias do
        me = self.criterias[i];
        me.currentValue = 0.00;
        me.startValue = 0.00;
        me.targetValue = -1;
    end
    Root.SetRankOnTexture(self.encounterRankTexture, nil);

    -- And display the frame
    self:Show();
    DifficultyMeter.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Close([atOnce])                                             *
-- ********************************************************************
-- * >> self: the difficulty meter.                                   *
-- * >> atOnce: if set, difficulty meter will be hidden instantly.    *
-- ********************************************************************
-- * Close the difficulty meter.                                      *
-- ********************************************************************
local function Close(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "OPENING" and self.status ~= "RUNNING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        if ( self.status == "OPENING" ) then
            self.timer = (1 - (self.timer / OPEN_TIME)) * CLOSE_TIME;
      else
            self.timer = 0;
        end
        self.status = "CLOSING";
    end
end

-- ********************************************************************
-- * self:CheckDataChange()                                           *
-- ********************************************************************
-- * >> self: the difficulty meter.                                   *
-- ********************************************************************
-- * Check if the current diagram shown by the difficulty meter does  *
-- * not match the module difficulty data. If there is a difference,  *
-- * we do a smooth update.                                           *
-- ********************************************************************
local function CheckDataChange(self)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "RUNNING" ) then return; end

    local i, tVal, mVal, hasChanged;
    local total = 0;
    hasChanged = false;

    for i=1, #self.criterias do
        tVal = self.criterias[i].targetValue;
        mVal = self.module:GetDifficultyMeter(criterias[i].name);

        if ( mVal ) then
            if ( tVal ~= mVal ) then hasChanged = true; end

            self.criterias[i].startValue = self.criterias[i].currentValue;
            self.criterias[i].targetValue = mVal;

            total = total + mVal;
        end
    end

    if ( hasChanged ) then
        self.transitionTimer = TRANSITION_TIME;

        -- Put the rank texture.
        local pts = 360 * total / #self.criterias;
        local rank = Root.PtsToRank(pts);
        if ( pts == 360 ) then rank = "?"; end -- Uber mega hard encounter
        Root.SetRankOnTexture(self.encounterRankTexture, rank);
        self.fightPts = pts;
    end

    self.nextRefresh = CHECK_INTERVAL;
end

-- ********************************************************************
-- * self:UpdateValues(elapsed)                                       *
-- ********************************************************************
-- * >> self: the difficulty meter.                                   *
-- * >> elapsed: time elapsed since the last call.                    *
-- ********************************************************************
-- * Progressively extend each bar of the difficulty meter            *
-- * toward its final value.                                          *
-- ********************************************************************
local function UpdateValues(self, elapsed)
    if type(self) ~= "table" then return; end
    local i;

    if ( self.transitionTimer > 0 ) then
        -- Stop the flashing
        if ( self.flashTimer > 0 ) then
            self.flashTimer = self.flashTimer + elapsed;
            if ( self.flashTimer >= FLASH_CYCLE ) then self.flashTimer = 0; end
        end

        self.transitionTimer = max(0, self.transitionTimer - elapsed);
        local progression = 1 - self.transitionTimer / TRANSITION_TIME;

        local s, t;
        for i=1, #self.criterias do
            s, t = self.criterias[i].startValue, self.criterias[i].targetValue;
            self.criterias[i].currentValue = s + (t - s) * progression;
        end
  else
        -- Free flashing
        self.flashTimer = math.fmod(self.flashTimer + elapsed, FLASH_CYCLE);
    end
end

-- ********************************************************************
-- * self:DrawBars()                                                  *
-- ********************************************************************
-- * >> self: the difficulty meter.                                   *
-- ********************************************************************
-- * Draw each bar of the difficulty meter to its current value.      *
-- ********************************************************************
local function DrawBars(self)
    if type(self) ~= "table" then return; end

    local i, bar;
    for i=1, #self.criterias do
        local value = self.criterias[i].currentValue;
        local r, g, b;

        bar = self.criterias[i].bar;
        bar:SetValue(value);

        r = value;
        g = 0.2;
        b = 1 - value;

        if ( value == 1.0 ) or ( self.criterias[i].startValue == 1.0 ) then
            local add = sin(self.flashTimer * 180 / FLASH_CYCLE);
            r = r + add;
            g = g + add;
            b = b + add;
        end

        bar:SetStatusBarColor(min(1, r), min(1, g), min(1, b));
    end

    if ( self.fightPts == 360 ) then -- Insane fight.
        local black = sin(self.flashTimer * 180 / FLASH_CYCLE);
        self.encounterRankTexture:SetVertexColor(black, black, black);
  else
        self.encounterRankTexture:SetVertexColor(1, 1, 1);
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function DifficultyMeter.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.00;
    self.module = module;
    self.nextRefresh = 0;
    self.transitionTimer = 0;
    self.flashTimer = 0;
    self.fightPts = 0;
    self.noSpamMemory = { };

    -- Methods
    self.Open = Open;
    self.Close = Close;
    self.CheckDataChange = CheckDataChange;
    self.UpdateValues = UpdateValues;
    self.DrawBars = DrawBars;

    -- Children
    self.title = Root.CreateFontString(self, "ARTWORK", "Big", nil, "MIDDLE", "BOTTOM");
    self.title:SetHeight(32);
    self.title:SetPoint("BOTTOM", self, "TOP", 0, -8);
    self.title:SetText(Root.Localise("DM-Title"));
    self.title:Show();

    self.closeButton = CreateFrame("Button", nil, self, "OptionsButtonTemplate");
    self.closeButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -8, 8);
    self.closeButton:SetWidth(64);
    self.closeButton:SetHeight(24);
    self.closeButton:SetText(CLOSE);
    self.closeButton:SetScript("OnClick", DifficultyMeter.OnCloseButtonClick);
    self.closeButton:Show();

    self.encounterRank = Root.CreateFontString(self, "ARTWORK", "Big", 20, "MIDDLE", "MIDDLE");
    self.encounterRank:SetHeight(20);
    self.encounterRank:ClearAllPoints();
    self.encounterRank:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 8, 8);
    self.encounterRank:SetText(Root.Localise("Rank"));
    self.encounterRank:Show();

    self.encounterRankTexture = self:CreateTexture(nil, "OVERLAY");
    self.encounterRankTexture:SetWidth(24);
    self.encounterRankTexture:SetHeight(24);
    self.encounterRankTexture:SetPoint("LEFT", self.encounterRank, "RIGHT", 8, 0);
    self.encounterRankTexture:Hide();

    local i, me;
    self.criterias = { };
    for i=1, #criterias do
        self.criterias[i] = {
            currentValue = 0.00,
            startValue = 0.00,
            targetValue = 0.00,
            bar = CreateFrame("StatusBar", nil, self),
            title = Root.CreateFontString(self, "ARTWORK", "NormalWhite", nil, "MIDDLE", "BOTTOM"),
        };

        me = self.criterias[i];
        me.bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        me.bar:SetMinMaxValues(0, 1);
        me.bar:SetWidth(192);
        me.bar:SetHeight(8);
        me.bar:SetPoint("LEFT", self, "TOPLEFT", 16, -8 - (i)*32);

        me.bar.tooltipTitle = criterias[i].text;
        me.bar.tooltipExplain = criterias[i].explain;
        me.bar:EnableMouse(true);
        me.bar:SetScript("OnEnter", DifficultyMeter.OnEnterBar);
        me.bar:SetScript("OnLeave", DifficultyMeter.OnLeaveBar);

        me.bar.background = me.bar:CreateTexture(nil, "BACKGROUND");
        me.bar.background:SetAllPoints(me.bar);
        me.bar.background:SetTexture(0, 0, 0, 0.5);

        me.title:SetHeight(16);
        me.title:SetText(Root.Localise(criterias[i].text));
        me.title:ClearAllPoints();
        me.title:SetPoint("BOTTOMLEFT", me.bar, "TOPLEFT", 0, 0);
    end

    Root.SetBackdrop(self, "TOOLTIP");
end

function DifficultyMeter.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    local alpha = 1.00;

    -- Open/close
    if ( self.status == "OPENING" ) then
        self.timer = min(OPEN_TIME, self.timer + elapsed);
        alpha = self.timer / OPEN_TIME;
        if ( self.timer == OPEN_TIME ) then
            self.status = "RUNNING";
            self.nextRefresh = 0;
        end
    end
    if ( self.status == "CLOSING" ) then
        self.timer = min(CLOSE_TIME, self.timer + elapsed);
        alpha = 1 - self.timer / CLOSE_TIME;
        if ( self.timer == CLOSE_TIME ) then self:Close(true); end
    end

    if ( self.status == "RUNNING" ) then
        self.nextRefresh = max(0, self.nextRefresh - elapsed);
        if ( self.nextRefresh == 0 ) then
            self:CheckDataChange();
        end
    end

    if ( self.status == "OPENING" or self.status == "RUNNING" ) then
        -- We consider it's time to remove the difficulty meter when the module does not allow access to its options.
        if ( not self.module:MayEditSettings() ) then
            self:Close();
        end
    end

    -- Update the bars
    self:UpdateValues(elapsed);
    self:DrawBars();

    -- Application on the frame
    self:ClearAllPoints();
    self:SetAlpha(alpha);
    self:SetPoint("CENTER", self:GetParent(), "CENTER", Root.PctToPx("X", DEFAULT_XPOSITION - 0.5), Root.PctToPx("Y", DEFAULT_YPOSITION - 0.5));
end

function DifficultyMeter.OnCloseButtonClick(button)
    local self = button:GetParent();

    local module = self.module;
    -- The user directly closed the difficulty meter. We won't show this module difficulty meter for the rest of this session.
    if type(module.GetName) == "function" then
        local moduleName = module:GetName();
        if ( moduleName ) then
            self.noSpamMemory[moduleName] = true;
        end
    end

    self:Close();
end

function DifficultyMeter.OnEnterBar(self)
    if ( self.tooltipTitle ) then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(self.tooltipTitle, nil, nil, nil, nil, 1);
    end
    if ( self.tooltipExplain ) then
        GameTooltip:AddLine(self.tooltipExplain, "", 1.0, 1.0, 1.0);
        GameTooltip:Show();
    end
end

function DifficultyMeter.OnLeaveBar(self)
    GameTooltip:Hide();
end