local Root = BossEncounter2;

local Widgets = Root.GetOrNewModule("Widgets");

local Distance = Root.GetOrNewModule("Distance");

Widgets["UnitListDriver"] = { };
local UnitListDriver = Widgets["UnitListDriver"];

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
    -- "Distance Too Close" algorithm ****************************
    -- Display a list of raid members that are too close from you.
    -- The following parameters are accepted:
    -- 1st: true/false -> sets whether pets are counted or not.
    -- 2nd: integer -> the distance threshold, in yards.
    -- 3rd: integer -> the people amount threshold on which or after which a red border will appear around the unit list (i.e: 2 means ">= 2").

    ["DISTANCE_TOOCLOSE"] = {
        updateRate = 0.100,

        OnRefresh = function(self, driver, myTable)
            local i, guid, name, uid;
            for i=1, Root.Unit.GetNumUID() do
                guid, name = Root.Unit.GetUID(i);
                uid = Root.Unit.GetUID(guid);
                if ( uid ) then
                    if ( UnitInParty(uid) or UnitInRaid(uid) ) and ( not UnitIsUnit("player", uid) ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitIsVisible(uid) ) then
                        -- Ok, this unit is potentially valid.
                        -- Check for pets allowance.
                        if ( self.parameters[1] ) or ( Root.Unit.GetTypeFromGUID(guid) == "player" ) then
                            local distance = Distance:Get(uid);
                            if ( distance <= self.parameters[2] ) then
                                -- This one is too close.
                                local unitTable = driver:Allocate();
                                unitTable.guid = guid;
                                unitTable.distance = distance;
                                unitTable.text = Root.FormatLoc("DistanceFormat", distance);
                                unitTable.r = 1.00;
                                unitTable.g = 0.25;
                                unitTable.b = 0.00;
                                myTable[#myTable+1] = unitTable;
                            end
                        end
                    end
                end
            end
            local threshold = self.parameters[3];
            if ( threshold ) then
                if ( #myTable >= threshold ) and ( UnitAffectingCombat("player") ) then
                    driver:ToggleFlash(1, 0, 0);
              else
                    driver:ToggleFlash(nil);
                end
            end
            Root.Sort.ByNumericField(myTable, "distance", false);
            local title = Root.FormatLoc("UnitList:DistanceTooClose:Title", self.parameters[2]);
            local summary = Root.FormatLoc("UnitList:DistanceTooClose:Summary", #myTable);
            return title, summary;
        end,
    },

    -- "Below X health" algorithm ********************************************
    -- Display a list of raid members that are below a given health threshold.
    -- The following parameters are accepted:
    -- 1st: true/false -> sets whether pets are counted or not.
    -- 2nd: integer -> the health threshold.

    ["BELOW_HEALTH"] = {
        updateRate = 0.100,

        OnRefresh = function(self, driver, myTable)
            local i, guid, name, uid;
            for i=1, Root.Unit.GetNumUID() do
                guid, name = Root.Unit.GetUID(i);
                uid = Root.Unit.GetUID(guid);
                if ( uid ) then
                    if ( UnitInParty(uid) or UnitInRaid(uid) ) and ( not UnitIsDeadOrGhost(uid) ) and ( UnitIsVisible(uid) ) then
                        -- Ok, this unit is potentially valid.
                        -- Check for pets allowance.
                        if ( self.parameters[1] ) or ( Root.Unit.GetTypeFromGUID(guid) == "player" ) then
                            local health = UnitHealth(uid);
                            if ( health <= self.parameters[2] ) then
                                -- This one is below the HP threshold.
                                local unitTable = driver:Allocate();
                                unitTable.guid = guid;
                                unitTable.health = health;
                                unitTable.text = Root.FormatLoc("HealthFormat", health);
                                unitTable.r = 1.00;
                                unitTable.g = 0.25;
                                unitTable.b = 0.00;
                                myTable[#myTable+1] = unitTable;
                            end
                        end
                    end
                end
            end
            Root.Sort.ByNumericField(myTable, "health", false);
            local title = Root.FormatLoc("UnitList:BelowHealth:Title", self.parameters[2]);
            local summary = Root.FormatLoc("UnitList:BelowHealth:Summary", #myTable);
            return title, summary;
        end,
    },

    -- Internal unit list algorithm **********************************************
    -- Display the current internal system unit list, to evaluate its performance.
    -- No parameter.                                      - ONLY FOR DEVELOPMENT -

    ["INTERNAL_UNITLIST"] = {
        updateRate = 0.100,

        OnRefresh = function(self, driver, myTable)
            local i, guid, name;
            for i=1, Root.Unit.GetNumUID() do
                guid, name = Root.Unit.GetUID(i);
                local unitTable = driver:Allocate();
                unitTable.guid = guid;
                unitTable.text = i;
                myTable[#myTable+1] = unitTable;
            end
            local title = "INTERNAL UNIT LIST";
            local summary = "TOTAL: "..#myTable;
            return title, summary;
        end,
    },
};

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * self:Setup(ownedUnitList)                                        *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the unit list driver.                                   *
-- * >> ownedUnitList: the unit list that will be controlled          *
-- * by the driver.                                                   *
-- ********************************************************************
-- * Setup the driver of an unit list.                                *
-- ********************************************************************
local function Setup(self, ownedUnitList)
    if type(self) ~= "table" or type(ownedUnitList) ~= "table" then return; end

    self.ownedUnitList = ownedUnitList;
    self:Clear();
end

-- ********************************************************************
-- * self:Clear()                                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the unit list driver.                                   *
-- ********************************************************************
-- * Clear the acquisition algorithm used to create the unit list,    *
-- * thus effectively voiding the content of the unit list.           *
-- ********************************************************************
local function Clear(self)
    if type(self) ~= "table" then return; end

    self.algorithm = nil;

    self:Refresh();
end

-- ********************************************************************
-- * self:AssignAlgorithm(algorithm, ...)                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the unit list driver.                                   *
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
-- * Assign an algorithm to the unit list driver.                     *
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
        self:Refresh();
    end
end

-- ********************************************************************
-- * self:Refresh()                                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the unit list driver.                                   *
-- ********************************************************************
-- * Refresh the owned unit list according to the current algorithm   *
-- * that's being used by the unit list. If none is set, the content  *
-- * of the unit list will be erased.                                 *
-- ********************************************************************
local function Refresh(self)
    if type(self) ~= "table" then return; end

    local myUnitList = self.ownedUnitList;
    if not ( myUnitList ) then return; end

    local i;
    local myAlgorithm = self.algorithm;

    self.unitInfo = self:Recycle(self.unitInfo); -- Erase in case unitInfo field has a table.

    if not ( myAlgorithm ) then
        self.nextUpdate = 1.000;

        -- No algorithm set => Clear the rows and summary (but keep the previous title).

        myUnitList:ChangeSummary("");

        for i=1, myUnitList:GetNumRows() do
            myUnitList:ChangeRow(i, nil, "");
        end
  else
        self.nextUpdate = myAlgorithm.updateRate or 0.200;

        self.unitInfo = self:Allocate();

        local title, summary = myAlgorithm:OnRefresh(self, self.unitInfo);
        local myInfo;

        myUnitList:ChangeTitle(title);
        myUnitList:ChangeSummary(summary);

        for i=1, myUnitList:GetNumRows() do
            myInfo = self.unitInfo[i];
            if ( myInfo ) then
                myUnitList:ChangeRow(i, myInfo.guid, myInfo.text, myInfo.r, myInfo.g, myInfo.b);
          else
                myUnitList:ChangeRow(i, nil, "");
            end
        end
    end
end

-- ********************************************************************
-- * self:GetNumUnits()                                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the unit list driver.                                   *
-- ********************************************************************
-- * Get the current number of units in the unit list of the driver.  *
-- ********************************************************************
local function GetNumUnits(self)
    if type(self) ~= "table" then return; end
    if ( not self.unitInfo ) then return 0; end

    return #self.unitInfo;
end

-- ********************************************************************
-- * self:GetUnitGUID(index)                                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the unit list driver.                                   *
-- * >> index: the unit at the i position in the unit list.           *
-- ********************************************************************
-- * Get the GUID of the unit at the given position in the unit list. *
-- ********************************************************************
local function GetUnitGUID(self, index)
    if type(self) ~= "table" then return; end
    if ( not self.unitInfo ) then return nil; end
    if ( not self.unitInfo[index] ) then return nil; end

    return self.unitInfo[index].guid or nil;
end

-- ********************************************************************
-- * self:Recycle(theTable)                                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the unit list driver.                                   *
-- * >> theTable: the table you no longer use.                        *
-- ********************************************************************
-- * Free the memory used by the table. Calling this method will      *
-- * remove all content in the table and will Recycle sub-tables      *
-- * within the table passed as a parameter.                          *
-- * For convenience, this function return nil, so you can void a     *
-- * reference and clean the table object itself at the same time.    *
-- ********************************************************************
local function Recycle(self, theTable)
    if type(self) ~= "table" or type(theTable) ~= "table" then return nil; end

    local k, v;
    for k, v in pairs(theTable) do
        theTable[k] = nil;
        if type(v) == "table" then
            self:Recycle(v);
        end
    end

    self.freeTables[#self.freeTables+1] = theTable;

    return nil;
end

-- ********************************************************************
-- * self:Allocate()                                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the unit list driver.                                   *
-- ********************************************************************
-- * Allocate a new and empty table.                                  *
-- * Please pass this table to the Recycle method to reclaim the      *
-- * memory it used when you no longer use it.                        *
-- ********************************************************************
local function Allocate(self)
    if type(self) ~= "table" then return; end

    local newTable = nil;

    if #self.freeTables > 0 then
        newTable = self.freeTables[#self.freeTables];
        self.freeTables[#self.freeTables] = nil;
  else
        newTable = { };
    end

    return newTable;
end

-- ********************************************************************
-- * self:ToggleFlash([r, g, b])                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> self: the unit list driver.                                   *
-- * >> r, g, b: colors of the flash (default red). Provide nil to    *
-- * red to stop the flash.                                           *
-- ********************************************************************
-- * Toggle the flash on the unit list commanded by the driver.       *
-- * This method can be called on a OnRefresh and will not do         *
-- * anything if a flash is already running.                          *
-- ********************************************************************
local function ToggleFlash(self, r, g, b)
    if type(self) ~= "table" then return; end

    local myUnitList = self.ownedUnitList;
    if not ( myUnitList ) then return; end

    local isFlashing = myUnitList:IsFlashing();

    if ( r ) and ( not isFlashing ) then
        myUnitList:SetFlash(r, g, b);
elseif ( not r ) and ( isFlashing ) then
        myUnitList:SetFlash(nil);
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

function UnitListDriver.OnLoad(self)
    -- Properties
    self.ownedUnitList = nil;
    self.algorithm = nil;
    self.nextUpdate = 0;
    self.freeTables = {};

    -- Methods
    self.Setup = Setup;
    self.Clear = Clear;
    self.AssignAlgorithm = AssignAlgorithm;
    self.Refresh = Refresh;
    self.GetNumUnits = GetNumUnits;
    self.GetUnitGUID = GetUnitGUID;
    self.Recycle = Recycle;
    self.Allocate = Allocate;
    self.ToggleFlash = ToggleFlash;
end

function UnitListDriver.OnUpdate(self, elapsed)
    self.nextUpdate = max(0, self.nextUpdate - elapsed);
    if ( self.nextUpdate == 0 ) then
        self:Refresh();
    end
end