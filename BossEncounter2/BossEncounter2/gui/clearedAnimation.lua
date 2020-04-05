local Root = BossEncounter2;
local Preload = Root.GetOrNewModule("Preload");
local Widgets = Root.GetOrNewModule("Widgets");

Widgets["ClearedAnimation"] = { };
local ClearedAnimation = Widgets["ClearedAnimation"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

local TEXTURE = Root.folder.."gfx\\Cleared";
local FLASH_TEXTURE = Root.folder.."gfx\\Flash";

local lettersOffset = {
    [1] = -224,
    [2] = -160,
    [3] = -96,
    [4] = -32,
    [5] = 32,
    [6] = 96,
    [7] = 160,
    [8] = 224,
}

-- All anims parameter
local CLOSE_TIME = 2.000; -- Both anims
local LETTER_ANIM_DURATION = 0.300; -- Normalised value between 0 and 1.

-- NORMAL anim parameters
local ZOOM_DURATION = 1.500;

-- ALTERNATE anim parameters
local APPEAR_DURATION = 2.500;

local NUM_EPICFAIL_MESSAGES = 3;
local EPICFAIL_TEXTURE = Root.folder.."gfx\\EpicFail";
local EPICFAIL_IMAGE_TEXTURE = Root.folder.."gfx\\EpicFailImage";

-- --------------------------------------------------------------------
-- **                              Anims                             **
-- --------------------------------------------------------------------

local ANIMS = {
    ["NORMAL"] = {
        OnStart = function(self, coupDeGrace)
            self.status = "ZOOMING";
            self.timer = ZOOM_DURATION;

            self.flash:SetWidth(1024);
            self.flash:SetHeight(1024);
            self.flash:SetAlpha(1);

            self.coupDeGrace = coupDeGrace;
            if ( coupDeGrace ) then self.coupDeGraceText:Show(); end

            self.flash:Show();
            self.blank:Show();

            local i;
            for i=1, #self.letters do
                self.letters[i]:Show();
            end
        end,

        OnEnd = function(self)
            self.coupDeGrace = nil;

            self.coupDeGraceText:Hide();
            self.flash:Hide();
            self.blank:Hide();

            local i;
            for i=1, #self.letters do
                self.letters[i]:Hide();
            end
        end,

        OnUpdate = function(self, elapsed)
            local i;
            local letterProgression;
            local globalProgression;
            local beginAnim, endAnim;

            if ( self.status == "ZOOMING" ) then
                self.timer = max(0, self.timer - elapsed);
                if ( self.timer == 0 ) then
                    self.status = "WAITING";

                    self.flash:Hide();
                    self.blank:Hide();
                end

                -- Update each letter.
                globalProgression = 1 - self.timer / ZOOM_DURATION;

                for i=1, #self.letters do
                    -- Determinate the progression, which is a bounded value between 0.000 and 1.000.
                    beginAnim = (i-1) * ((1.0 - LETTER_ANIM_DURATION) / (#self.letters-1));
                    endAnim = beginAnim + LETTER_ANIM_DURATION;
                    letterProgression = ( globalProgression - beginAnim ) / ( endAnim - beginAnim);
                    letterProgression = max(0.000, min(letterProgression, 1.000));

                    -- Apply the progression on the letter
                    local zoom = 1 / letterProgression;
                    self.letters[i]:SetAlpha(min(1, letterProgression / 0.200));
                    self.letters[i]:SetWidth(64 * zoom);
                    self.letters[i]:SetHeight(128 * zoom);
                    self.letters[i]:ClearAllPoints();
                    self.letters[i]:SetPoint("CENTER", self, "CENTER", lettersOffset[i] * zoom, 0);
                end

                if ( self.coupDeGrace ) then
                    self.coupDeGraceText:SetAlpha(globalProgression);
                    self.coupDeGraceText:SetPoint("CENTER", self, "CENTER", 512 * (1 - globalProgression)^2, -96);
                end

        elseif ( self.status == "WAITING" ) then
                -- Waiting for the Stop method call.

        elseif ( self.status == "CLOSING" ) then
                self.timer = max(0, self.timer - elapsed);
                if ( self.timer == 0 ) then
                    self:Stop(true);
                    return;
                end

                -- Update each letter.
                globalProgression = 1 - self.timer / CLOSE_TIME;

                for i=1, #self.letters do
                    -- Determinate the progression, which is a bounded value between 0.000 and 1.000.
                    beginAnim = (i-1) * ((1.0 - LETTER_ANIM_DURATION) / (#self.letters-1));
                    endAnim = beginAnim + LETTER_ANIM_DURATION;
                    letterProgression = ( globalProgression - beginAnim ) / ( endAnim - beginAnim);
                    letterProgression = max(0.000, min(letterProgression, 1.000));

                    -- Apply the progression on the letter
                    self.letters[i]:SetAlpha(1 - letterProgression);
                end

                if ( self.coupDeGrace ) then
                    self.coupDeGraceText:SetAlpha(1 - globalProgression);
                end
            end

            -- Flash handling
            if ( self.status == "ZOOMING" ) then
                local beginX, beginY, endX, endY;
                local x, y, progression;
                progression = 1 - self.timer / ZOOM_DURATION;
                beginX = 0-(512 / WorldFrame:GetWidth());
                beginY = 0-(512 / WorldFrame:GetHeight());
                endX = 1+(512 / WorldFrame:GetWidth());
                endY = 1+(512 / WorldFrame:GetHeight());
                x = beginX + ( endX - beginX ) * progression;
                y = beginY + ( endY - beginY ) * progression;

                Root.RotateTexture(self.flash, progression * 180);
                self.flash:ClearAllPoints();
                self.flash:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", x * WorldFrame:GetWidth(), y * WorldFrame:GetHeight());
                self.blank:SetAlpha((1 - progression) * 0.75);
            end
        end,
    },
    ["ALTERNATE"] = {
        OnStart = function(self, coupDeGrace)
            self.status = "APPEARING";
            self.timer = APPEAR_DURATION;

            self.flash:SetWidth(512);
            self.flash:SetHeight(512);

            self.flash:Show();
            self.blank:Show();

            local i;
            for i=1, #self.letters do
                self.letters[i]:Show();
            end
        end,

        OnEnd = function(self)
            self.flash:Hide();
            self.blank:Hide();

            local i;
            for i=1, #self.letters do
                self.letters[i]:Hide();
            end
        end,

        OnUpdate = function(self, elapsed)
            local i;
            local letterProgression;
            local globalProgression;
            local beginAnim, endAnim;

            if ( self.status == "APPEARING" ) then
                self.timer = max(0, self.timer - elapsed);
                if ( self.timer == 0 ) then
                    self.status = "WAITING";

                    self.flash:Hide();
                    self.blank:Hide();
                end

                -- Update each letter.
                globalProgression = 1 - self.timer / APPEAR_DURATION;

                for i=1, #self.letters do
                    -- Determinate the progression, which is a bounded value between 0.000 and 1.000.
                    beginAnim = (i-1) * ((1.0 - LETTER_ANIM_DURATION) / (#self.letters-1));
                    endAnim = beginAnim + LETTER_ANIM_DURATION;
                    letterProgression = ( globalProgression - beginAnim ) / ( endAnim - beginAnim);
                    letterProgression = max(0.000, min(letterProgression, 1.000));

                    -- Apply the progression on the letter
                    letterJumpOffset = 32 - cos(letterProgression * 360) * 32;
                    self.letters[i]:SetAlpha(min(1, letterProgression / 0.200));
                    self.letters[i]:ClearAllPoints();
                    self.letters[i]:SetWidth(64);
                    self.letters[i]:SetHeight(128);
                    self.letters[i]:SetPoint("CENTER", self, "CENTER", lettersOffset[i], letterJumpOffset - 16);
                end

        elseif ( self.status == "WAITING" ) then
                -- Waiting for the Stop method call.

        elseif ( self.status == "CLOSING" ) then
                self.timer = max(0, self.timer - elapsed);
                if ( self.timer == 0 ) then
                    self:Stop(true);
                    return;
                end

                -- Update each letter.
                globalProgression = 1 - self.timer / CLOSE_TIME;

                for i=1, #self.letters do
                    -- Determinate the progression, which is a bounded value between 0.000 and 1.000.
                    beginAnim = (i-1) * ((1.0 - LETTER_ANIM_DURATION) / (#self.letters-1));
                    endAnim = beginAnim + LETTER_ANIM_DURATION;
                    letterProgression = ( globalProgression - beginAnim ) / ( endAnim - beginAnim);
                    letterProgression = max(0.000, min(letterProgression, 1.000));

                    -- Apply the progression on the letter
                    self.letters[i]:SetAlpha(1 - letterProgression);
                end
            end

            -- Flash handling
            if ( self.status == "APPEARING" ) then
                local x, a, b;
                x = (lettersOffset[1] - 32) + ( (lettersOffset[8] + 32) - (lettersOffset[1] - 32) ) * globalProgression;

                if ( globalProgression <= 0.10 ) then
                    a = min(1, globalProgression / 0.10);
            elseif ( globalProgression >= 0.90 ) then
                    a = 1 - max(0, (globalProgression - 0.90) / 0.10);
              else
                    a = 1;
                end

                b = max(0, 1 - globalProgression / 0.30);
                self.blank:SetAlpha(b);

                Root.RotateTexture(self.flash, globalProgression * 240);

                self.flash:ClearAllPoints();
                self.flash:SetPoint("CENTER", WorldFrame, "CENTER", x, 0);
                self.flash:SetAlpha(a);
            end
        end,
    },
    ["EPICFAIL"] = {
        OnStart = function(self, coupDeGrace)
            self.status = "ZOOMING";
            self.timer = ZOOM_DURATION;
            self.bonusRotationTimer = 0;

            local bonusTextID = math.random(1, NUM_EPICFAIL_MESSAGES);
            local bonusText = '" '..Root.Localise("EF-"..bonusTextID)..' "';

            self.bonusText:SetText(bonusText);
            self.bonusTexture1:SetTexture(EPICFAIL_TEXTURE);
            self.bonusTexture1:ClearAllPoints();
            self.bonusTexture1:SetPoint("CENTER", self, "CENTER", 0, 0);
            self.bonusTexture2:SetTexture(EPICFAIL_IMAGE_TEXTURE);
            self.bonusTexture2:ClearAllPoints();
            self.bonusTexture2:SetWidth(512 * 3/4);
            self.bonusTexture2:SetHeight(350 * 3/4);
            self.bonusTexture2:SetPoint("BOTTOM", self, "CENTER", 0, 64);
            self.flash:ClearAllPoints();
            self.flash:SetPoint("CENTER", WorldFrame, "CENTER", 0, 0);

            self.bonusText:Show();
            self.bonusTexture1:Show();
            self.bonusTexture2:Show();
            self.flash:Show();
            self.blank:Show();
        end,

        OnEnd = function(self)
            self.bonusRotationTimer = nil;

            self.bonusText:Hide();
            self.bonusTexture1:Hide();
            self.bonusTexture2:Hide();
            self.flash:Hide();
            self.blank:Hide();
        end,

        OnUpdate = function(self, elapsed)
            if ( self.status == "ZOOMING" ) then
                self.timer = max(0, self.timer - elapsed);
                if ( self.timer == 0 ) then
                    self.status = "WAITING";

                    self.blank:Hide();
                end

                local progression = 1 - self.timer / ZOOM_DURATION;

                self.bonusText:SetAlpha(progression);
                self.bonusText:SetPoint("CENTER", self, "CENTER", 512 * (1 - progression)^2, -64);

                self.bonusTexture1:SetAlpha(0.5 + progression * 0.5);
                self.bonusTexture2:SetAlpha(progression);

                local zoom = 4 - progression * 3;
                self.bonusTexture1:SetWidth(512 * zoom);
                self.bonusTexture1:SetHeight(128 * zoom);

                self.flash:SetAlpha(progression);

        elseif ( self.status == "WAITING" ) then
                -- Waiting for the Stop method call.

        elseif ( self.status == "CLOSING" ) then
                self.timer = max(0, self.timer - elapsed);
                if ( self.timer == 0 ) then
                    self:Stop(true);
                    return;
                end

                local progression = 1 - self.timer / CLOSE_TIME;

                self.bonusText:SetAlpha(1 - progression);
                self.bonusTexture1:SetAlpha(1 - progression);
                self.bonusTexture2:SetAlpha(1 - progression);

                self.flash:SetAlpha(1 - progression);
            end

            -- Lighting handling
            if ( self.status == "ZOOMING" ) then
                local progression = 1 - self.timer / ZOOM_DURATION;

                self.blank:SetAlpha((1 - progression) * 0.75);
            end

            self.bonusRotationTimer = self.bonusRotationTimer + elapsed;
            Root.RotateTexture(self.flash, self.bonusRotationTimer * 30);
        end,
    },
};

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Play([animation, coupDeGrace])                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the animation frame.                                    *
-- * >> animation: the animation used: NORMAL, ALTERNATE, EPICFAIL.   *
-- * >> coupDeGrace: true if you dealt the Coup De Grace yourself.    *
-- ********************************************************************
-- * Starts playing the cleared animation.                            *
-- ********************************************************************
local function Play(self, animation, coupDeGrace)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "STANDBY" and self.status ~= "CLOSING" ) then return; end

    self.animation = animation or "NORMAL";
    ANIMS[self.animation].OnStart(self, coupDeGrace);

    self:Show();
    ClearedAnimation.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:Stop(atOnce)                                                *
-- ********************************************************************
-- * >> self: the animation frame.                                    *
-- * >> atOnce: if set, the animation frame will be hidden at once.   *
-- ********************************************************************
-- * Stops playing the cleared animation.                             *
-- ********************************************************************
local function Stop(self, atOnce)
    if type(self) ~= "table" then return; end
    if ( self.status ~= "ZOOMING" and self.status ~= "WAITING" and self.status ~= "APPEARING" ) and ( not atOnce ) then return; end

    if ( atOnce ) then
        self.status = "STANDBY";
        ANIMS[self.animation].OnEnd(self);
        self:Hide();
  else
        self.status = "CLOSING";
        self.timer = CLOSE_TIME;
    end
end

-- ********************************************************************
-- * self:GetStatus()                                                 *
-- ********************************************************************
-- * >> self: the animation frame.                                    *
-- ********************************************************************
-- * Get the current internal status of the animation frame.          *
-- ********************************************************************
local function GetStatus(self)
    if type(self) ~= "table" then return; end

    return self.status;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function ClearedAnimation.OnLoad(self)
    -- Properties
    self.status = "STANDBY";
    self.timer = 0.000;
    self.animation = "NORMAL";
    self.coupDeGrace = false;

    -- Methods
    self.Play = Play;
    self.Stop = Stop;
    self.GetStatus = GetStatus;

    -- Children
    self.flash = self:CreateTexture(nil, "BACKGROUND");
    self.flash:SetTexture(FLASH_TEXTURE);
    self.flash:Hide();

    self.blank = self:CreateTexture(nil, "OVERLAY");
    self.blank:SetTexture(1, 1, 1, 1);
    self.blank:SetAllPoints(WorldFrame);
    self.blank:Hide();

    self.coupDeGraceText = Root.CreateFontString(self, "BACKGROUND", "Big", 40, "MIDDLE", "MIDDLE");
    self.coupDeGraceText:SetText(Root.Localise("CoupDeGrace"));
    self.coupDeGraceText:Hide();

    local i;
    self.letters = { };
    for i=1, #lettersOffset do
        local layer = "ARTWORK";
        if ( i == 1 ) then -- Special priority problem for the first texture. X_x
            layer = "BORDER";
        end
        self.letters[i] = self:CreateTexture(nil, layer);
        self.letters[i]:SetTexture(TEXTURE);
        self.letters[i]:SetTexCoord((i-1)*(64/512), i*(64/512), 0, 1);
    end

    self.bonusTexture1 = self:CreateTexture(nil, "OVERLAY");
    self.bonusTexture1:Hide();

    self.bonusTexture2 = self:CreateTexture(nil, "ARTWORK");
    self.bonusTexture2:Hide();

    self.bonusText = Root.CreateFontString(self, "BACKGROUND", "Visible", 32, "MIDDLE", "MIDDLE");
    self.bonusText:Hide();

    self:SetWidth(lettersOffset[#self.letters] + 64);
    self:SetHeight(128);

    -- Fixed position
    self:SetPoint("CENTER", WorldFrame, "CENTER", 0, 0);

    -- Greater draw priority
    self:SetFrameLevel(self:GetFrameLevel()+3);
end

function ClearedAnimation.OnUpdate(self, elapsed)
    if type(self) ~= "table" then return; end

    if ( self.status == "STANDBY" ) or ( not self.animation ) then
        self:Hide();
        return;
    end

    ANIMS[self.animation].OnUpdate(self, elapsed);
end

-- --------------------------------------------------------------------
-- **                             Preload                            **
-- --------------------------------------------------------------------

do
    -- We add here heavy textures that should not be loaded on the fly while in combat to avoid a performance loss.
    Preload:Add(TEXTURE);
    Preload:Add(FLASH_TEXTURE);
    Preload:Add(EPICFAIL_TEXTURE);
    Preload:Add(EPICFAIL_IMAGE_TEXTURE);
end