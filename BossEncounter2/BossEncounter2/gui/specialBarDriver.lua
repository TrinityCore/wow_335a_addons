local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

Widgets["SpecialBarDriver"] = { };
local SpecialBarDriver = Widgets["SpecialBarDriver"];

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
    -- "Raid Mana" algorithm ******************
    -- Display the %mana remaining to the raid.
    -- No parameter.

    ["RAID_MANA"] = {
        colors = {0.0, 0.0, 1.0}, -- R/G/B
        bounds = {0, 100}, -- min/max

        OnUpdate = function(self, elapsed)
            local currentMana, maxMana = Root.Shared:GetRaidMana();
            local manaPct = math.floor(currentMana * 100 / maxMana + 0.5);
            local title = Root.FormatLoc("SpecialBar:RaidMana:Title");
            local text = manaPct.."%";
            return title, text, manaPct;
        end,
    },
};

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(ownedSpecialBar)                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the special bar driver.                                 *
-- * >> ownedSpecialBar: the special bar that will be controlled      *
-- * by the driver.                                                   *
-- ********************************************************************
-- * Setup the driver of a special bar.                               *
-- ********************************************************************
local function Setup(self, ownedSpecialBar)
    if type(self) ~= "table" or type(ownedSpecialBar) ~= "table" then return; end

    self.ownedSpecialBar = ownedSpecialBar;
    self:Clear();
end

-- ********************************************************************
-- * self:Clear()                                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the special bar driver.                                 *
-- ********************************************************************
-- * Clear the algorithm used to update the special bar.              *
-- ********************************************************************
local function Clear(self)
    if type(self) ~= "table" then return; end

    self.algorithm = nil;

    SpecialBarDriver.OnUpdate(self, 0);
end

-- ********************************************************************
-- * self:AssignAlgorithm(algorithm, ...)                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the special bar driver.                                 *
-- * >> algorithm: the table defining the algorithm to use. You can   *
-- * also input a string pointing to one of the predefined algorithms.*
-- * See above for information about how an algorithm table must be   *
-- * formatted. Passing nil to this parameter will transform this     *
-- * method call implicitly into a Clear method call.                 *
-- * >> ...: the parameters that will be used internally              *
-- * by the algorithm. This makes the algorithm more                  *
-- * flexible and allows you not to redo an algorithm whenever you    *
-- * have to change slightly a value. Do not use nil as a parameter ! *
-- ********************************************************************
-- * Assign an algorithm to the special bar driver.                   *
-- ********************************************************************
local function AssignAlgorithm(self, algorithm, ...)
    if type(self) ~= "table" then return; end

    if ( not algorithm ) then
        self:Clear();

elseif ( type(algorithm) == "string" ) then
        local predefinedAlgorithm = basicAlgorithms[algorithm];
        if type(predefinedAlgorithm) == "table" then
            self:AssignAlgorithm(predefinedAlgorithm, ...);
        end

elseif ( type(algorithm) == "table" ) then
        self.algorithm = algorithm;
        self.algorithm.parameters = {...};
        SpecialBarDriver.OnUpdate(self, 0);
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function SpecialBarDriver.OnLoad(self)
    -- Properties
    self.ownedSpecialBar = nil;
    self.algorithm = nil;
    self.nextUpdate = 0;

    -- Methods
    self.Setup = Setup;
    self.Clear = Clear;
    self.AssignAlgorithm = AssignAlgorithm;
end

function SpecialBarDriver.OnUpdate(self, elapsed)
    local mySpecialBar = self.ownedSpecialBar;
    if not ( mySpecialBar ) then return; end

    local i;
    local myAlgorithm = self.algorithm;

    if not ( myAlgorithm ) then
        -- No algorithm set => Clear the text on the bar (but keep the previous title).
        mySpecialBar:ChangeText("");
  else
        local title, text, value = myAlgorithm:OnUpdate(elapsed);

        mySpecialBar:ChangeTitle(title);
        mySpecialBar:ChangeText(text);
        mySpecialBar:SetValue(value);

        mySpecialBar:SetMinMaxValues(unpack(myAlgorithm.bounds));
        mySpecialBar:SetStatusBarColor(unpack(myAlgorithm.colors));
    end
end