local Root = BossEncounter2;

local GlobalOptions = Root.GetOrNewModule("GlobalOptions");

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["AddWindowDriver"] = { };
local AddWindowDriver = Widgets["AddWindowDriver"];

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                            GUI PART                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                             Locals                             **
-- --------------------------------------------------------------------

-- This table contains the basic algorithms that can be used freely by the modules.
-- Simply pass the algorithm name to the AssignAlgorithm method and provide the parameters
-- asked by the algorithm to start it.

local basicAlgorithms = {
    -- MP algorithm *********************************
    -- Simply displays the mana points of the target.

    ["MP"] = {
        label = {
            ["default"] = "MP",
            ["frFR"] = "PM",
        },
        layout = 1, -- 1=Teal, 2=Blue, 3=Orange
        allowDead = false,

        GetValue = function(self, uid)
            return UnitPower(uid, SPELL_POWER_MANA), UnitPowerMax(uid, SPELL_POWER_MANA);
        end,
    },

    -- Revive algorithm ****************************************************
    -- Monitors time left before an add will revive after being killed
    -- First parameter must be the module holding the GetReviveTimer method.

    ["REVIVE"] = {
        label = {
            ["default"] = "Regen",
            ["frFR"] = "Régen",
        },
        layout = 3,
        allowDead = true,

        GetValue = function(self, uid)
            local guid = UnitGUID(uid);
            return self:GetValueMasked(guid);
        end,

        GetValueMasked = function(self, guid)
            local module = self.parameters[1];
            return Root[module]:GetReviveTimer(guid);
        end,
    },
};

local ROLE_COLOR = {
    ["DPS"]  = "|cffff0000",
    ["HEAL"] = "|cff00ff00",
};

local function colorizeName(name, role)
    local colorInfo = nil;
    if ( role ) then colorInfo = ROLE_COLOR[role]; end
    if ( colorInfo ) then
        return colorInfo..name.."|r";
  else
        return name;
    end
end

local UNKNOWN_NAME = "?????";

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(ownedAddWindow)                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window driver.                                  *
-- * >> ownedAddWindow: the add window that will be controlled        *
-- * by the driver.                                                   *
-- ********************************************************************
-- * Setup the driver of an unit list.                                *
-- ********************************************************************
local function Setup(self, ownedAddWindow)
    if type(self) ~= "table" or type(ownedAddWindow) ~= "table" then return; end

    self.ownedAddWindow = ownedAddWindow;
    self:Clear(true);
end

-- ********************************************************************
-- * self:Clear(removeAlgorithm)                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window driver.                                  *
-- * >> removeAlgorithm: provide true to also remove the algorithm.   *
-- ********************************************************************
-- * Clear all adds.                                                  *
-- ********************************************************************
local function Clear(self, removeAlgorithm)
    if type(self) ~= "table" then return; end

    local i;
    for i=#self.units, 1, -1 do
        self:RemoveUnit(i);
    end

    if ( removeAlgorithm ) then
        self:AssignAlgorithm(nil);
    end

    self:SetSecureCommand(nil);
end

-- ********************************************************************
-- * self:AssignAlgorithm(algorithm, ...)                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window driver.                                  *
-- * >> algorithm: the table defining the algorithm to use. You can   *
-- * also input a string pointing to one of the predefined algorithms.*
-- * See above for information about how an algorithm table must be   *
-- * formatted.                                                       *
-- * >> ...: the parameters that will be used internally              *
-- * by the algorithm. This makes the algorithm more                  *
-- * flexible and allows you not to redo an algorithm whenever you    *
-- * have to change slightly a value. Do not use nil as a parameter ! *
-- ********************************************************************
-- * Assign the algorithm used to determinate the value of the bonus  *
-- * bar. It can be predefined algorithm or a custom one.             *
-- * Passing nil will clear the algorithm.                            *
-- ********************************************************************
local function AssignAlgorithm(self, algorithm, ...)
    if type(self) ~= "table" then return; end

    local window = self.ownedAddWindow;

    if ( not algorithm ) then
        self.algorithm = nil;
        window:ChangeBonusColumn(false);

elseif ( type(algorithm) == "string" ) then
        local predefinedAlgorithm = basicAlgorithms[algorithm];
        if type(predefinedAlgorithm) == "table" then
            self:AssignAlgorithm(predefinedAlgorithm, ...);
        end

elseif ( type(algorithm) == "table" ) then
        self.algorithm = algorithm;
        self.algorithm.parameters = {...};

        window:ChangeBonusColumn(true, Root.ReadLocTable(algorithm.label), algorithm.layout);
    end
end

-- ********************************************************************
-- * self:SetSecureCommand(command)                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window driver.                                  *
-- * >> command: the command that will be executed when clicking on   *
-- * a clickable add row. It will be issued after the targetting.     *
-- ********************************************************************
-- * Assign a macro command to be run when clicking on one of the     *
-- * adds rows. This can be called on the fly, but will not work at   *
-- * once while in combat.                                            *
-- ********************************************************************
local function SetSecureCommand(self, command)
    if type(self) ~= "table" then return; end

    self.secureCommand = command;
    self.refreshCommand = true;
end

-- ********************************************************************
-- * self:AddUnit(guid[, class, role, clickName])                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window driver.                                  *
-- * >> guid: the GUID of the unit to add.                            *
-- * Submit a mobID in case of pending units for whom you do not know *
-- * the GUID yet.                                                    *
-- * >> class, role: the class and role of the add. Optional.         *
-- * Inputting these will put an icon in front of the name as well as *
-- * coloring the name.                                               *
-- * >> clickName: if provided, the system will attempt to make the   *
-- * add row clickable to target the mob. BE WARNED that using this   *
-- * feature will restrict the frame in combat.                       *
-- * "AUTO" is a magic word that will make clickName take the correct *
-- * value as soon as the mob can be accessed.                        *
-- ********************************************************************
-- * Add an unit to watch.                                            *
-- ********************************************************************
local function AddUnit(self, guid, class, role, clickName)
    if type(self) ~= "table" then return; end
    if ( not guid ) then return; end
    guid = tostring(guid);

    local newUnit = {
        row = nil,
        guid = guid,
        name = nil,
        displayName = UNKNOWN_NAME,
        known = false,
        dead = false,
        symbol = 0,
        class = class,
        role = role,
        update = true,
        lastAccess = 0,
        lastHP = nil,
        lastHPM = nil,
        damageHP = 0,
        clickName = clickName,
    };

    tinsert(self.units, newUnit);
end

-- ********************************************************************
-- * self:ReplaceUnit(guid, newGUID[, class, role, clickName])        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window driver.                                  *
-- * >> guid: the GUID of the add to replace.                         *
-- * >> newGUID: the new GUID.                                        *
-- * >> class, role: the class and role of the add. Optional.         *
-- * Inputting these will put an icon in front of the name as well as *
-- * coloring the name.                                               *
-- * >> clickName: if provided, the system will attempt to make the   *
-- * add row clickable to target the mob. BE WARNED that using this   *
-- * feature will restrict the frame in combat.                       *
-- * "AUTO" is a magic word that will make clickName take the correct *
-- * value as soon as the mob can be accessed.                        *
-- ********************************************************************
-- * Replace GUID of an unit by another one.                          *
-- * This is useful for pending units designated through their mobID. *
-- ********************************************************************
local function ReplaceUnit(self, guid, newGUID, class, role, clickName)
    if type(self) ~= "table" then return; end
    if ( not guid ) or ( not newGUID ) then return; end
    guid = tostring(guid);
    newGUID = tostring(newGUID);

    local i, unit;
    for i=#self.units, 1, -1 do
        unit = self.units[i];
        if ( unit.guid == guid ) then
            unit.guid = newGUID;
            unit.name = nil;
            unit.displayName = UNKNOWN_NAME;
            unit.known = false;
            unit.dead = false;
            unit.symbol = 0;
            unit.class = class or unit.class;
            unit.role = role or unit.role;
            unit.update = true;
            unit.lastAccess = 0;
            unit.lastHP = nil;
            unit.lastHPM = nil;
            unit.clickName = clickName or unit.clickName;
            unit.damageHP = 0;
        end
    end
end

-- ********************************************************************
-- * self:RemoveUnit(guid or id)                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window driver.                                  *
-- * >> guid or id: the GUID or index of the add.                     *
-- ********************************************************************
-- * Remove an add from the add window.                               *
-- ********************************************************************
local function RemoveUnit(self, who)
    if type(self) ~= "table" then return; end

    if type(who) == "string" then
        local i;
        for i=#self.units, 1, -1 do
            if ( self.units[i].guid == who ) then
                self:RemoveUnit(i);
            end
        end
elseif type(who) == "number" then
        local row = self.units[who].row;
        if ( row ) then row:Remove(); end
        tremove(self.units, who);
    end
end

-- ********************************************************************
-- * self:UpdateUnit(index, locked)                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window driver.                                  *
-- * >> index: index of the unit to update.                           *
-- * >> locked: if true, no row can be moved or allocated.            *
-- ********************************************************************
-- * Update an unit.                                                  *
-- ********************************************************************
local function UpdateUnit(self, index, locked)
    if type(self) ~= "table" then return; end

    local u = self.units[index];
    local guid = u.guid;
    local uid = Root.Unit.GetUID(guid);
    local algorithm = self.algorithm;

    -- Acknowledgment
    if ( uid ) and ( not u.known ) then
        -- Grabbing info regarding the unit.
        u.known = true;
        u.name = UnitName(uid);
        u.displayName = colorizeName(u.name, u.role);
        u.update = true;
        if ( u.clickName == "AUTO" ) then
            u.clickName = u.name;
        end
    end

    local bonusFraction, bonus, bonusMax = "?", "?", nil;

    -- We use the estimated HP value in case we can't access the NPC.

    local healthFraction, health, healthMax = "?", u.lastHP, u.lastHPM;
    if ( health and healthMax ) then
        healthFraction = (health - u.damageHP) / healthMax;
        healthFraction = min(1, max(0, healthFraction));
    end

    -- Death transition stuff
    if ( u.dead ) then
        if ( uid ) and ( not UnitIsDeadOrGhost(uid) ) then
            -- Watched unit has rezzed.
            if ( UnitHealth(uid) or 0 ) > 0 then -- Additionnal check, "in case of".
                self:FlagDead(guid, false);
            end
      else
            -- Force to 0 for dead entities even if we do not have a pointer to the unit.
            healthFraction, bonusFraction = 0, 0;
        end
    end

    -- Health value update
    if ( uid ) and ( not u.dead ) then
        if ( UnitIsDeadOrGhost(uid) ) then
            self:FlagDead(guid, true);
        end
        health, healthMax = UnitHealth(uid), UnitHealthMax(uid);
        healthFraction = health / max(1, healthMax);

        u.lastAccess = "NOW";
        u.lastHP = health;
        u.lastHPM = healthMax;
        u.damageHP = 0;
  else
        u.lastAccess = GetTime();
    end

    -- Bonus value update
    if ( algorithm ) and ( not u.dead or algorithm.allowDead ) then
        if ( uid ) then
            bonus, bonusMax = algorithm.GetValue(algorithm, uid);
    elseif ( algorithm.GetValueMasked ) and ( u.guid ) then
            bonus, bonusMax = algorithm.GetValueMasked(algorithm, u.guid);
        end
        if ( bonus == "?" ) then
            bonusFraction = "?";
    elseif ( bonusMax and bonusMax ~= 0 ) then
            bonusFraction = bonus / bonusMax;
      else
            bonusFraction = 0;
        end
    end

    -- Symbol change check
    if ( uid ) and ( not u.dead ) then
        local currentSymbol = GetRaidTargetIndex(uid) or 0;
        if ( currentSymbol ~= u.symbol ) then
            u.symbol = currentSymbol;
            u.update = true;
        end
    end

    -- Try to allocate an unused row if the unit has still none.
    local window = self.ownedAddWindow;
    local numRows = window:GetNumRows();

    if ( not locked ) then
        if ( not u.row ) and ( index <= numRows ) then
            local row = window:GetFreeRow();
            if ( row ) then
                u.row = row;
                row:Display();
                row:SetBarValue(1, 0, 0, true);
                row:SetBarValue(2, 0, 0, true);
                row:SetBarValue(1, "?", nil, true);
                row:SetBarValue(2, "?", nil, true);
            end
     elseif ( u.row ) and ( index > numRows ) then -- Should never occur since the display priority of the adds is never changed.
            u.row:Remove();
            u.row = nil;
        end
    end

    -- The following may only take place if the add being handled has a row.
    local row = u.row;
    if ( not row ) then return; end

    -- The add window driver's secure command has been updated,
    -- forward the new command to the secure frame.
    if ( self.refreshCommand ) then
        row:GetSecureFrame():SetCommand(self.secureCommand);
    end

    if ( self.showPercentage ) then
        healthMax = 100;
        row:SetBarSuffix(1, "%");
  else
        row:SetBarSuffix(1, "");
    end
    row:SetBarValue(1, healthFraction, healthMax, false);
    row:SetBarValue(2, bonusFraction, bonusMax, false);

    if ( u.update ) then
        u.update = false;

        if ( u.symbol > 0 ) then
            row:SetName(u.displayName, u.symbol);
      else
            row:SetName(u.displayName, u.class);
        end

        if ( u.clickName ) and ( u.clickName ~= "AUTO" ) then
            row:GetSecureFrame():Setup("BUTTON", u.clickName);
            row:GetSecureFrame():SetCommand(self.secureCommand);
      else
            row:GetSecureFrame():Remove();
        end
    end

    -- Determinate if the row can be moved up.
    if ( row.position > 1 ) and ( not locked ) then
        local otherRow = window.occupiedPosition[row.position - 1];
        local free = true;
        if ( otherRow ) then
            free = select(2, window:GetRow(otherRow:GetID()));
        end
        if ( free ) then
            window:ChangeRowPosition(row, row.position - 1);
        end
    end
end

-- ********************************************************************
-- * self:FlagDead(guid or id, state)                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window driver.                                  *
-- * >> guid or id: the GUID or index of the add to flag.             *
-- * >> state: whether the unit is dead or alive.                     *
-- ********************************************************************
-- * Flags an add as dead or alive.                                   *
-- ********************************************************************
local function FlagDead(self, who, state)
    if type(self) ~= "table" then return; end

    if type(who) == "string" then
        local i;
        for i=#self.units, 1, -1 do
            if ( self.units[i].guid == who ) then
                self:FlagDead(i, state);
            end
        end
elseif type(who) == "number" then
        local u = self.units[who];
        u.dead = state;
        if ( state ) then
            u.symbol = 0;
            u.update = true;
        end
    end
end

-- ********************************************************************
-- * self:OnDamage(guid, value, zero)                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the add window driver.                                  *
-- * >> guid: the GUID of the add that took damage.                   *
-- * >> value: the damage value.                                      *
-- * >> zero: whether the add has been put to zero HP or not          *
-- * (set this when there is overkill damage).                        *
-- * If value is negative, then zero has another meaning: it means    *
-- * then that the unit got to full health.                           *
-- ********************************************************************
-- * Called when an unit sustains damage in combat.                   *
-- * Can be called for heals as well, just give a negative value.     *
-- ********************************************************************
local function OnDamage(self, guid, value, zero)
    if type(self) ~= "table" then return; end

    local i, u;
    for i=#self.units, 1, -1 do
        u = self.units[i];
        if ( u.guid == guid ) then
            if ( u.lastAccess ~= "NOW" ) then
                if ( zero ) and ( value >= 0 ) then
                    u.damageHP = 0;
                    u.lastHP = 0;
            elseif ( zero ) and ( value < 0 ) then
                    u.damageHP = 0;
                    u.lastHP = u.lastHPM;
              else
                    u.damageHP = u.damageHP + value;
                end
            end
        end
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function AddWindowDriver.OnLoad(self)
    -- Properties
    self.ownedAddWindow = nil;
    self.units = { };
    self.algorithm = nil;
    self.updateConfig = 0;
    self.secureCommand = nil;
    self.refreshCommand = false;

    -- Methods
    self.Setup = Setup;
    self.Clear = Clear;
    self.AssignAlgorithm = AssignAlgorithm;
    self.SetSecureCommand = SetSecureCommand;
    self.AddUnit = AddUnit;
    self.ReplaceUnit = ReplaceUnit;
    self.RemoveUnit = RemoveUnit;
    self.UpdateUnit = UpdateUnit;
    self.FlagDead = FlagDead;
    self.OnDamage = OnDamage;

    -- Combat parsing registration
    Root.Combat.RegisterCallback(AddWindowDriver.OnCombatEvent, self);
end

function AddWindowDriver.OnUpdate(self, elapsed)
    local locked, secure = self.ownedAddWindow:IsLocked();

    local i;
    for i=#self.units, 1, -1 do
        self:UpdateUnit(i, locked);
    end
    self.refreshCommand = false;

    self.updateConfig = max(0, self.updateConfig - elapsed);
    if ( self.updateConfig == 0 ) then
        self.updateConfig = 5.00;
        self.showPercentage = GlobalOptions:GetSetting("UseAddHealthPercentage");
    end
end

AddWindowDriver.OnCombatEvent = {
    ["DAMAGE"] = function(self, _, _, _, guid, _, _, _, _, _, _, amount, overkill, _, _, _, _, _)
        self:OnDamage(guid, amount, (overkill or 0) > 0);
    end,
    ["HEAL"] = function(self, _, _, _, guid, _, _, _, _, _, _, amount, overheal, _, _, _)
        self:OnDamage(guid, -amount, (overheal or 0) > 0);
    end,
    ["DEATH"] = function(self, guid, name, flags, subType)
        self:FlagDead(guid, true);
    end,
};



