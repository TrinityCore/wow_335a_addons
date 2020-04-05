local Root = BossEncounter2;
local EncounterStats = Root.GetOrNewModule("EncounterStats");

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["ResultSequence"] = { };
local ResultSequence = Widgets["ResultSequence"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local MASK_FINAL_ALPHA = 0.30;

local RESULT_TEXT_YPOSITION = 0.78;
local RESULT_TEXT_HEIGHT = 30;
local TIME_TEXT_YPOSITION = 0.70;
local TIME_TEXT_HEIGHT = 25;

-- In sec.
local FADE_DURATION = 0.300;
local SCROLL_DURATION = 0.400;

-- Sequence definitions

local clearSequences = {
    ["NORMAL"] = {
        music = "NORMALCLEAR",
        waitTimer =  1.70, -- Time before introducing the performance frame after the result text has been shown.
        showTimer =  2.00, -- Time the performance frame will need to take to show up.
        prePause  =  1.40, -- Time the performance frame will wait until we play the performance sequence. That is, growing bars and showing the rank.
        growTimer =  1.40, -- Time the bars in the performance frame have to grow to their final value.
        rankTimer =  0.50, -- Time the rank texture has to zoom in.
        postPause = 15.00, -- Time the performance frame will wait after showing its final results before getting out of the screen.
        hideTimer =  2.00, -- Time the performance frame will need to take to get out of screen.
    },
    ["MINI"] = { -- Should be used for any kind of miniboss.
        music = "MINICLEAR",
        waitTimer =  0.30,
        showTimer =  2.00,
        prePause  =  0.80,
        growTimer =  2.20,
        rankTimer =  0.50,
        postPause = 20.00,
        hideTimer =  2.00,
    },
    ["RAID"] = {
        music = "RAIDCLEAR",
        waitTimer =  0.30,
        showTimer =  2.00,
        prePause  =  0.80,
        growTimer =  2.20,
        rankTimer =  0.50,
        postPause = 20.00,
        hideTimer =  2.00,
    },
    ["FINAL"] = { -- Should be used for hard, final bosses at the end of raid instances.
        music = "FINALCLEAR",
        waitTimer =  0.00, -- 0.80
        showTimer =  1.30, -- 1.20
        prePause  =  0.70,
        growTimer =  3.40,
        rankTimer =  0.40,
        postPause = 30.00,
        hideTimer =  2.00,
    },
    ["FAIL"] = {
        music = "SILENCE",
        waitTimer =  0.30,
        showTimer =  2.00,
        prePause  =  0.80,
        growTimer =  2.20,
        rankTimer =  0.50,
        postPause = 20.00,
        hideTimer =  2.00,
    },
};

-- Add 0.7 from the start of the music to account for the fade out and text scrolling.

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Play(callback, ...)                                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the result sequence frame.                              *
-- * >> callback: the function to be called at the end of the seq.    *
-- * >> ...: extra parameters to pass to callback. Avoid using nil !! *
-- ********************************************************************
-- * Starts playing the result sequence.                              *
-- ********************************************************************
local function Play(self, callback, ...)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then
        if callback then callback(...); end
        return;
    end

    self.status = "OPENING";
    self.timer = FADE_DURATION;
    self.callback = callback;
    self.args = {...};

    local name, attempts, attemptScore, speedScore, techniqueScore, clearTime, previousTime, previousScore, numKilled, sequence, dps = EncounterStats:GetCurrentInfo();

    clearSequence = clearSequences[sequence];
    if ( not clearSequence ) then return; end

    if ( attemptScore and speedScore and techniqueScore ) then
        self.hasNewRecord = (attemptScore + speedScore + techniqueScore) > (previousScore or 0);
        self.attempt, self.speed, self.technique = attemptScore, speedScore, techniqueScore;
        self.previousScore = previousScore;
        self.noPerformanceScore = false;
  else
        self.noPerformanceScore = true;
    end

    self.dps = dps;

    -- Prepare the things that do not vary in the sequence.

    self.resultText:SetText(Root.FormatLoc("Defeated", name, attempts));
    if ( clearTime ) then
        local timeText = Root.FormatLoc("FightTime", Root.FormatCountdownString("%M ' %S '' %C", clearTime, false, false, false));
        if ( previousTime ) then
            timeText = timeText.."\n"..Root.FormatLoc("TimeRecord", Root.FormatCountdownString("%M ' %S '' %C", previousTime, false, false, false));
        end
        self.timeText:SetText(timeText);
  else
        self.timeText:SetText(Root.Localise("IncompleteFight"));
    end

    -- Change the timings of the performance frame according to the Clear music used.

    self.performanceWaitTimer = clearSequence.waitTimer;
    self.performanceShowTimer = clearSequence.showTimer;
    self.performancePrePause = clearSequence.prePause;
    self.performanceGrowTimer = clearSequence.growTimer;
    self.performanceRankTimer = clearSequence.rankTimer;
    self.performancePostPause = clearSequence.postPause;
    self.performanceHideTimer = clearSequence.hideTimer;

    Root.Music.Play(clearSequence.music);

    self:Show();
    ResultSequence.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Stop(atOnce)                                                *
-- ********************************************************************
-- * >> self: the result sequence frame.                              *
-- * >> atOnce: if set, the sequence frame will be hidden at once.    *
-- ********************************************************************
-- * Stops playing the result sequence.                               *
-- ********************************************************************
local function Stop(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status == "STANDBY" or self.status == "CLOSING" ) and ( not atOnce ) then return; end

    Root.Music.Stop();

    self:GetPerformanceFrame():Remove(atOnce, FADE_DURATION);
    self:GetDPSGraph():Remove(atOnce, FADE_DURATION);

    if ( atOnce ) then
        self.status = "STANDBY";
        self:Hide();
  else
        self.status = "CLOSING";
        self.timer = FADE_DURATION;
    end

    if ( self.callback ) then
        -- Disarm further calls of the callback.
        local callback = self.callback;
        self.callback = nil;
        callback(unpack(self.args));
    end
end

-- ********************************************************************
-- * self:GetStatus()                                                 *
-- ********************************************************************
-- * >> self: the result sequence frame.                              *
-- ********************************************************************
-- * Get the current internal status of the result sequence frame.    *
-- ********************************************************************
local function GetStatus(self)
    if type(self) ~= "table" then return; end

    return self.status;
end

-- ********************************************************************
-- * self:GetPerformanceFrame()                                       *
-- ********************************************************************
-- * >> self: the result sequence frame.                              *
-- ********************************************************************
-- * Get the performance frame attached to the given result frame.    *
-- ********************************************************************
local function GetPerformanceFrame(self)
    if type(self) ~= "table" then return; end

    return self.PerformanceFrame;
end

-- ********************************************************************
-- * self:GetDPSGraph()                                               *
-- ********************************************************************
-- * >> self: the result sequence frame.                              *
-- ********************************************************************
-- * Get the DPS graph attached to the given result frame.            *
-- ********************************************************************
local function GetDPSGraph(self)
    if type(self) ~= "table" then return; end

    return self.DPSGraph;
end

-- ********************************************************************
-- * self:PrintDPS()                                        - DEBUG - *
-- ********************************************************************
-- * >> self: the result sequence frame.                              *
-- ********************************************************************
-- * Print in plain text the content of the DPS table.                *
-- ********************************************************************
local function PrintDPS(self)
    if type(self) ~= "table" then return; end
    if type(self.dps) ~= "table" then return; end

    local i, info;
    for i=1, #self.dps do
        info = self.dps[i];

        Root.Print(string.format("%d. %s: %d (%s)", i, info.name, info.dps, info.class), true);
        if ( self.dps.coupDeGrace == info.guid ) then
            Root.Print(info.name.." got the killing blow!", true);
        end
    end

    Root.Print("Average DPS: "..self.dps.average, true);
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function ResultSequence.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.000;

    -- Methods
    self.Play = Play;
    self.Stop = Stop;
    self.GetStatus = GetStatus;
    self.GetPerformanceFrame = GetPerformanceFrame;
    self.GetDPSGraph = GetDPSGraph;
    self.PrintDPS = PrintDPS;

    -- Children
    self.mask = self:CreateTexture(nil, "BACKGROUND");
    self.mask:SetTexture(0, 0, 0, 1);
    self.mask:SetAllPoints(self);
    self.mask:Hide();

    self.resultText = Root.CreateFontString(self, "OVERLAY", "Big", RESULT_TEXT_HEIGHT, "MIDDLE", "MIDDLE");
    self.resultText:Hide();
    self.timeText = Root.CreateFontString(self, "OVERLAY", "Big", TIME_TEXT_HEIGHT, "MIDDLE", "MIDDLE");
    self.timeText:Hide();

    self.PerformanceFrame = CreateFrame("Frame", nil, self, "BossEncounter2_PerformanceFrameTemplate");
    self.DPSGraph = CreateFrame("Frame", nil, self, "BossEncounter2_DPSGraphTemplate");

    -- Fixed position
    self:SetAllPoints(WorldFrame);

    -- Greater draw priority
    self:SetFrameLevel(self:GetFrameLevel()+2);
end

function ResultSequence.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) then
        self:Hide();
        return;
    end

    -- Status transition

    local progression = 0;

    if ( self.status == "OPENING" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then
            self.status = "SCROLLING";
            self.timer = SCROLL_DURATION;
        end

        progression = 1 - self.timer / FADE_DURATION;

elseif ( self.status == "SCROLLING" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then
            self.status = "PERFORMANCE_WAITING";
            self.timer = self.performanceWaitTimer;
        end

        progression = 1 - self.timer / SCROLL_DURATION;

elseif ( self.status == "PERFORMANCE_WAITING" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then
            if ( not self.noPerformanceScore ) then
                self.status = "PERFORMANCE_SHOWING";

                local halfWidth  = 475 / self:GetWidth();
                local perfWidth  = 150 / self:GetWidth();
                local graphWidth = 300 / self:GetWidth();

                self:GetPerformanceFrame():Display(0.5 - halfWidth + perfWidth, 0.45, self.performanceShowTimer, self.previousScore);
                self:GetDPSGraph():Reset();
                self:GetDPSGraph():Display(0.5 + halfWidth - graphWidth, 0.45, self.performanceShowTimer);
          else
                self.status = "PERFORMANCE_PREPAUSE";
                self.timer = self.performanceShowTimer + self.performancePrePause;

                self:GetDPSGraph():Reset();
                self:GetDPSGraph():Display(0.5, 0.45, self.performanceShowTimer);
            end
        end

elseif ( self.status == "PERFORMANCE_SHOWING" ) then
        if ( self:GetPerformanceFrame():GetDisplayStatus() ~= "OPENING" ) then
            self.status = "PERFORMANCE_PREPAUSE";
            self.timer = self.performancePrePause;
            -- self:PrintDPS();
        end

elseif ( self.status == "PERFORMANCE_PREPAUSE" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then
            if ( not self.noPerformanceScore ) then
                self.status = "PERFORMANCE_RUNNING";

                self:GetPerformanceFrame():Animate(self.attempt, self.speed, self.technique, self.performanceGrowTimer, self.performanceRankTimer, self.hasNewRecord);
                self:GetDPSGraph():AutosetColumns(self.dps, self.performanceGrowTimer);
          else
                self.status = "PERFORMANCE_POSTPAUSE";
                self.timer = self.performanceGrowTimer + self.performancePostPause;

                self:GetDPSGraph():AutosetColumns(self.dps, self.performanceGrowTimer);
            end
        end

elseif ( self.status == "PERFORMANCE_RUNNING" ) then
        if ( self:GetPerformanceFrame():GetAnimationStatus() == "STANDBY" ) then
            self.status = "PERFORMANCE_POSTPAUSE";
            self.timer = self.performancePostPause;
        end

elseif ( self.status == "PERFORMANCE_POSTPAUSE" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then
            self:Stop(false);
        end

elseif ( self.status == "CLOSING" ) then
        self.timer = max(0, self.timer - elapsed);
        if ( self.timer == 0 ) then
            self:Stop(true);
        end

        progression = 1 - self.timer / FADE_DURATION;
    end

    -- Mask handling

    if ( self.status == "OPENING" ) then
        self.mask:SetAlpha(progression * MASK_FINAL_ALPHA);
        self.mask:Show();
elseif ( self.status == "CLOSING" ) then
        self.mask:SetAlpha((1 - progression) * MASK_FINAL_ALPHA);
        self.mask:Show();
  else
        self.mask:SetAlpha(MASK_FINAL_ALPHA);
        self.mask:Show();
    end

    -- Common vars declaration

    local ofsX, alpha;

    -- Scrolling text handling

    ofsX = 0.0;
    alpha = 1.0;

    if ( self.status == "OPENING" ) then
        alpha = 0;

elseif ( self.status == "CLOSING" ) then
        alpha = 1 - progression;

elseif ( self.status == "SCROLLING" ) then
        ofsX = 0.75 - 0.75 * (progression);
    end

    if ( alpha > 0 ) then
        self.resultText:SetAlpha(alpha);
        self.resultText:Show();
        self.timeText:SetAlpha(alpha);
        self.timeText:Show();
  else
        self.resultText:Hide();
        self.timeText:Hide();
    end
    self.resultText:ClearAllPoints();
    self.resultText:SetPoint("CENTER", self, "CENTER", ofsX * self:GetWidth(), (RESULT_TEXT_YPOSITION - 0.5) * self:GetHeight());
    self.timeText:ClearAllPoints();
    self.timeText:SetPoint("CENTER", self, "CENTER", -ofsX * self:GetWidth(), (TIME_TEXT_YPOSITION - 0.5) * self:GetHeight());
end