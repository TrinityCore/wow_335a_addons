local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["BossBarDriver"] = { };
local BossBarDriver = Widgets["BossBarDriver"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- The required boss health to have a boss bar using ALL color layers.
-- Bosses that have more than this threshold will have an invariant boss bar till it starts dropping below this threshold.
-- In-between values will be interpolated linearly.

local expectedFullBossHealth = {
    [0] = 0,
    [1] = 1500,
    [60] = 4000000,   
    [70] = 16000000,
    [80] = 40000000,
    [85] = 80000000,
};

-- Same thing for elite "boss"-like mobs (for instance Group quests).

local expectedFullEliteHealth = {
    [0] = 0,
    [1] = 300,
    [60] = 150000,
    [70] = 700000,
    [80] = 1500000,
    [85] = 3000000,
};

-- Same thing for players.

local expectedFullPlayerHealth = { 
    [0] = 0,
    [1] = 1500,
    [60] = 15000,   
    [70] = 40000,
    [80] = 75000,
    [85] = 150000,
};

-- Same thing for normal mobs.

local expectedFullNormalHealth = expectedFullPlayerHealth; -- Similar to players.

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

-- ** Shake controls **
local SHAKE_DURATION = 1.000; -- 2.000;
local MAX_SHAKE_MAGNITUDE = 1.000;
local DIFFERENCE_TO_SHAKE_POWER = 1.000; -- When the target value varies by 1, by how much shake power increase ?
local SHAKE_ROTATION_TIMER = 0.500; -- The amount of time to let the shake do a complete turn.

-- ** Variation controls **
local CHANGE_RATE = 1.000; -- The max value change in 1 second.

-- ** Size stuff **
local DEFAULT_MAX_LENGTH = 384;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(ownedBar)                                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- * >> ownedBar: the boss bar that is controlled by the driver.      *
-- ********************************************************************
-- * Setup the driver of a boss bar.                                  *
-- ********************************************************************
local function Setup(self, ownedBar)
    if type(self) ~= "table" or type(ownedBar) ~= "table" then return; end

    self.ownedBar = ownedBar;
    self.guid = nil;
    self.currentValue = 0;
    self.shakePower = 0;
    self.shakeTimer = false;

    self:ClearThresholds(true);
end

-- ********************************************************************
-- * self:SetWatch(guid[, maxLength])                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- * >> guid: the GUID of the unit that is to be watched.             *
-- * "none" magic string can be used.                                 *
-- * >> maxLength: the max length the boss bar can have for the new   *
-- * watched unit. If not specified, maximal maximum will be used. :p *
-- ********************************************************************
-- * Set the unit watched by the boss bar driver.                     *
-- * Calling this method alone is not enough to completely set up the *
-- * boss bar. You'll need to call its :Display method too.           *
-- ********************************************************************
local function SetWatch(self, guid, maxLength)
    if type(self) ~= "table" or type(self.ownedBar) ~= "table" then return; end

    self.guid = guid;
    self.acknowledged = false;
    self.dead = false;
    self.maxLength = maxLength or DEFAULT_MAX_LENGTH;
    self.lastSymbol = 0;
    self:ChangeTargetValue(0, false);

    self.ownedBar:ChangeText("");
    self.ownedBar:ChangeTitle("");
    self.ownedBar:ChangeSymbol(0);

    self:ClearThresholds(true);
end

-- ********************************************************************
-- * self:ChangeTargetValue(value, useShake)                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- * >> value: the new target value.                                  *
-- * >> useShake: whether to use a shake effect when the bar varies.  *
-- ********************************************************************
-- * Setup the driver of a boss bar.                                  *
-- ********************************************************************
local function ChangeTargetValue(self, value, useShake)
    if type(self) ~= "table" then return; end

    local difference = math.abs(self.targetValue - value);

    self.targetValue = value;

    if ( useShake and difference > 0 ) then
        local oldPower, oldAngle = self:GetShakePower(), select(2, self:GetShakeInfo());

        self.shakePower = min(MAX_SHAKE_MAGNITUDE, max(oldPower, difference * DIFFERENCE_TO_SHAKE_POWER));
        self.shakeTimer = 0;

        -- Tadaaaa! Uber equation resolution to find the new shakeSpinTimer so as to have a smooth change.

        local newAngle = asin( oldPower / self.shakePower * sin(oldAngle) );
        if ( oldAngle >= 90 and oldAngle < 270 ) then
            self.shakeSpinTimer = (SHAKE_ROTATION_TIMER / 360) * math.fmod(180 - newAngle + 360, 360);
      else
            self.shakeSpinTimer = (SHAKE_ROTATION_TIMER / 360) * newAngle;
        end
  else
        -- self.shakeTimer = false;
        -- EDIT: Let the current shake finish at least.
    end
end

-- ********************************************************************
-- * self:GetShakePower()                                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- ********************************************************************
-- * Get the current shake power.                                     *
-- ********************************************************************
local function GetShakePower(self)
    if type(self) ~= "table" then return; end

    if ( not self.shakeTimer ) then
        return 0;
  else
        -- return self.shakePower * max(0, 1 - (self.shakeTimer / SHAKE_DURATION)^1);
        local factor = math.exp(-self.shakeTimer / SHAKE_DURATION);
        if ( factor < 0.001 ) then factor = 0; end
        return self.shakePower * factor;
    end
end

-- ********************************************************************
-- * self:GetConversionRate(maxHealth, isPlayer, classification,      *
-- *                        maxLength)                                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- * >> maxHealth: the max health of the unit being monitored.        *
-- * >> isPlayer: whether the "boss" is a player character.           *
-- * >> classification: the classification of the unit.               *
-- * Can be normal, elite, rare, rareelite, boss.                     *
-- * >> maxLength: the max length allowed by the bar.                 *
-- ********************************************************************
-- * Get the health to boss bar value conversion rate.                *
-- * It indicates how hard the boss bar will fail for each HP the     *
-- * monitored unit loses.                                            *
-- * A second return value is given, which indicates how long the bar *
-- * should be.                                                       *
-- ********************************************************************
local function GetConversionRate(self, maxHealth, isPlayer, classification, maxLength)
    if type(self) ~= "table" or type(self.ownedBar) ~= "table" then return; end

    local length = maxLength;

    local expectedHealthTable = expectedFullNormalHealth;
    if ( isPlayer ) then expectedHealthTable = expectedFullPlayerHealth; end
    if ( classification == "elite" or classification == "rareelite" ) then expectedHealthTable = expectedFullEliteHealth; end
    if ( classification == "worldboss" ) then expectedHealthTable = expectedFullBossHealth; end
    local challengeRating = min(1, maxHealth / Root.LinearInterpolation(expectedHealthTable, UnitLevel("player")));

    local normalisation = challengeRating * self.ownedBar:GetNumColorLayers();

    if ( normalisation < 1 ) then
        length = math.floor(maxLength + (256 - maxLength) * (1 - normalisation));
        normalisation = 1;
    end

    return normalisation / maxHealth, length;
end

-- ********************************************************************
-- * self:NotifyDeath()                                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- ********************************************************************
-- * Notify the currently watched unit has died.                      *
-- ********************************************************************
local function NotifyDeath(self)
    if type(self) ~= "table" then return; end
    if ( self.dead ) then return; end

    self.dead = true;

    self.ownedBar:ChangeText("|cffffff00"..DEAD.."|r");
end

-- ********************************************************************
-- * self:NotifyRez()                                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- ********************************************************************
-- * Notify the currently watched unit has rezzed.                    *
-- ********************************************************************
local function NotifyRez(self)
    if type(self) ~= "table" then return; end
    if ( not self.dead ) then return; end

    self.dead = false;

    self.ownedBar:ChangeText("");
end

-- ********************************************************************
-- * self:GetShakeInfo()                                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- ********************************************************************
-- * Get the current shake offset performed on the boss bar and its   *
-- * angle. Return shakeOffset, shakeAngle.                           *                     
-- ********************************************************************
local function GetShakeInfo(self)
    if type(self) ~= "table" then return; end

    local shakeAngle = (self.shakeSpinTimer / SHAKE_ROTATION_TIMER) * 360;

    return self:GetShakePower()/2 * sin(shakeAngle), shakeAngle;
end

-- ********************************************************************
-- * self:ClearThresholds(instantly)                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- * >> instantly: if set, the graphical markers will be removed      *
-- * without any animation.                                           *
-- ********************************************************************
-- * Remove all defined health thresholds on the bar.                 *
-- ********************************************************************
local function ClearThresholds(self, instantly)
    if type(self) ~= "table" then return; end

    local bar = self.ownedBar;
    if ( not bar ) then return; end

    local frame = bar:GetThresholdFrame();
    frame:Clear(instantly);

    wipe(self.threshold);
end

-- ********************************************************************
-- * self:AddThreshold(threshold, label)                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- * >> threshold: the life ratio threshold.                          *
-- * >> label: the label that will be displayed on the bar.           *
-- ********************************************************************
-- * Add an health threshold to the bar.                              *
-- ********************************************************************
local function AddThreshold(self, threshold, label)
    if type(self) ~= "table" then return; end

    local newEntry = Root.Table.Alloc()

    newEntry.label = label;
    newEntry.value = threshold;
    newEntry.visible = false;

    tinsert(self.threshold, newEntry);
end

-- ********************************************************************
-- * self:RemoveThreshold(label, instantly)                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- * >> label: the label allowing us to identify the threshold.       *
-- * >> instantly: if set, the graphical marker will be removed       *
-- * without any animation.                                           *
-- ********************************************************************
-- * Remove an health threshold from the bar.                         *
-- ********************************************************************
local function RemoveThreshold(self, label, instantly)
    if type(self) ~= "table" then return; end

    local bar = self.ownedBar;
    if ( not bar ) then return; end

    local frame = bar:GetThresholdFrame();
    local i, t;
    for i=#self.threshold, 1, -1 do
        t = self.threshold[i];
        if ( t.label == label ) then
            if ( t.visible ) then
                frame:Remove(t.label);
            end
            Root.Table.Recycle(t);
            tremove(self.threshold, i);
        end
    end
end

-- ********************************************************************
-- * self:UpdateThresholds(currentValue, health, healthMax)           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the boss bar driver.                                    *
-- * >> currentValue: current value filled by the bar.                *
-- * 1 means the first layer is completely filled etc.                *
-- * >> health, healthMax: health data of the unit being monitored.   *
-- ********************************************************************
-- * Update the health thresholds.                                    *
-- ********************************************************************
local function UpdateThresholds(self, currentValue, health, healthMax)
    if type(self) ~= "table" then return; end

    local bar = self.ownedBar;
    if ( not bar ) then return; end

    local frame = bar:GetThresholdFrame();
    local minVisible = max(0, currentValue - 0.9);

    local i, t, position, visible;
    local closestLabel, closestValue = nil, 99999;
    local distance;

    for i=1, #self.threshold do
        t = self.threshold[i];

        position = t.value * healthMax * self.conversionRate;
        if ( position >= minVisible ) and ( position <= currentValue ) then
            visible = true;
      else
            visible = false;
        end

        if ( not t.visible ) and ( visible ) then
            frame:Add(math.fmod(position, 1), t.label, t.value);
    elseif ( t.visible ) and ( not visible ) then
            frame:Remove(t.label);
        end
        t.visible = visible;

        distance = math.abs(currentValue - position);
        if ( distance < closestValue ) and ( distance <= 0.30 ) then
            closestValue = distance;
            closestLabel = t.label;
        end
    end

    if ( not closestLabel ) and ( self.thresholdFocus ) then
        self.thresholdFocus = nil;
        frame:HideBubble(false);

elseif ( closestLabel ) then
        self.thresholdFocus = closestLabel;
        frame:ShowBubble(closestLabel);
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function BossBarDriver.OnLoad(self)
    -- Properties
    self.ownedBar = nil;
    self.guid = nil;
    self.acknowledged = false;
    self.dead = false;
    self.currentValue = 0;
    self.targetValue = 0;
    self.shakePower = 0;
    self.shakeSpinTimer = 0;
    self.shakeTimer = false;
    self.lastSymbol = 0;
    self.threshold = { };
    self.thresholdFocus = nil;

    -- Methods
    self.Setup = Setup;
    self.SetWatch = SetWatch;
    self.ChangeTargetValue = ChangeTargetValue;
    self.GetShakePower = GetShakePower;
    self.GetConversionRate = GetConversionRate;
    self.NotifyDeath = NotifyDeath;
    self.NotifyRez = NotifyRez;
    self.GetShakeInfo = GetShakeInfo;
    self.ClearThresholds = ClearThresholds;
    self.AddThreshold = AddThreshold;
    self.RemoveThreshold = RemoveThreshold;
    self.UpdateThresholds = UpdateThresholds;

    -- Combat parsing registration
    Root.Combat.RegisterCallback(BossBarDriver.OnCombatEvent, self);
end

function BossBarDriver.OnUpdate(self, elapsed)
    local myBar = self.ownedBar;
    local guid = self.guid;
    if ( not myBar ) or ( not guid ) then return; end

    -- Grab unit informations
    if ( guid == "none" ) then
        self.targetValue = 0;
  else
        local uid = Root.Unit.GetUID(guid);
        local useShake = true;

        -- Acknowledgment
        if ( uid ) and ( not self.acknowledged ) then
            -- Grabbing info regarding the unit.
            self.acknowledged = true;

            self.unitName = select(1, UnitName(uid));
            self.maxHealth = UnitHealthMax(uid);
            self.isPlayer = UnitIsPlayer(uid);
            self.classification = UnitClassification(uid);
            self.conversionRate, self.intendedLength = self:GetConversionRate(self.maxHealth, self.isPlayer, self.classification, self.maxLength);

            myBar:ChangeTitle(self.unitName);
            myBar:ChangeWidth(self.intendedLength, false);
            myBar:ChangeText("");

            useShake = false; -- Do not shake the boss bar for the first update.
        end

        -- Death transition stuff
        if ( self.dead ) then
            if ( uid ) and ( not UnitIsDeadOrGhost(uid) ) then
                -- Watched unit has rezzed.
                if ( UnitHealth(uid) or 0 ) > 0 then -- Additionnal check, "in case of".
                    self:NotifyRez();
                    useShake = false;
                end
          else
                -- Force to 0 for dead entities even if we do not have a pointer to the unit.
                self:ChangeTargetValue(0, useShake);
            end
      else
            if ( uid ) and ( UnitIsDeadOrGhost(uid) ) then
                -- Watched unit has died but we didn't catch the Death event.
                self:NotifyDeath();
            end
        end

        -- Question mark stuff
        if ( uid or self.dead ) then
            myBar:SetQuestionMarkStatus(false);
      else
            myBar:SetQuestionMarkStatus(true);
        end

        -- Health update
        if ( uid ) then
            if ( not self.dead ) then
                local health = UnitHealth(uid);
                local healthMax = UnitHealthMax(uid);
                local healthRatio = health / healthMax;
                local currentValue = health * self.conversionRate;
                self:ChangeTargetValue(currentValue, useShake);

                local barText = string.format("%.2f%%", min(100, healthRatio * 100));
                self.ownedBar:ChangeText(barText);

                self:UpdateThresholds(currentValue, health, healthMax);
            end
      else
            -- Not accessable unit.
        end

        -- Symbol change check
        if ( uid ) then
            local currentSymbol = GetRaidTargetIndex(uid);
            if ( currentSymbol ~= self.lastSymbol ) then
                self.lastSymbol = currentSymbol;
                self.ownedBar:ChangeSymbol(currentSymbol);
            end
        end
    end

    -- Update the owned bar accordingly

    if ( self.shakeTimer ) then
        self.shakeTimer = self.shakeTimer + elapsed;
        self.shakeSpinTimer = math.fmod(self.shakeSpinTimer + elapsed, SHAKE_ROTATION_TIMER);
    end

    local diff = self.targetValue - self.currentValue;
    local speed = CHANGE_RATE * elapsed;

    if ( diff ~= 0 ) then
        if ( diff < 0 ) then
            self.currentValue = max(self.targetValue, self.currentValue - speed);
      else
            self.currentValue = min(self.targetValue, self.currentValue + speed);
        end
    end

    if ( myBar:GetQuestionMarkStatus() ) then
        myBar:ChangeValue(0);
  else
        myBar:ChangeValue(self.currentValue + select(1, self:GetShakeInfo()));
    end
end

BossBarDriver.OnCombatEvent = {
    ["DEATH"] = function(self, guid, name, flags, subType)
        if ( self.guid and guid == self.guid ) then
            self:NotifyDeath();
        end
    end,
};