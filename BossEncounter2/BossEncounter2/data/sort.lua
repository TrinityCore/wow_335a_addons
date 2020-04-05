local Root = BossEncounter2;

Root.Sort = { };

-- --------------------------------------------------------------------
-- **                          Sort data                             **
-- --------------------------------------------------------------------


-- --------------------------------------------------------------------
-- **                         Local functions                        **
-- --------------------------------------------------------------------

local NUMERIC_SORT_FIELD = "NULL";

local function ByDateSortFunc(item1, item2)
    if ( item1.date ) then
        return item1.date < item2.date;

elseif ( item1.creationDate ) then
        return item1.creationDate < item2.creationDate;
    end

    return false;
end

local function ByDateRevertSortFunc(item1, item2)
    return ( not ByDateSortFunc(item1, item2) );
end

local function ByNameSortFunc(item1, item2)
    local name1, name2 = item1, item2;
    if type(item1) == "table" and type(item2) == "table" then
        name1, name2 = item1.name, item2.name;
    end
    if type(name1) ~= "string" or type(name2) ~= "string" then
        return false;
    end

    local length = min(#name1, #name2);
    local b1, b2, i;

    for i=1, length do
        b1 = strbyte(name1, i);
        b2 = strbyte(name2, i);
        if ( b1 < b2 ) then
            return true;
    elseif ( b1 > b2 ) then
            return false;
        end
    end

    if ( #name1 < #name2 ) then
        return true;
    end
    return false;
end

local function ByNameRevertSortFunc(item1, item2)
    return ( not ByNameSortFunc(item1, item2) );
end

local function ByNumericFieldSortFunc(item1, item2)
    return item1[NUMERIC_SORT_FIELD] < item2[NUMERIC_SORT_FIELD];
end

local function ByNumericFieldRevertSortFunc(item1, item2)
    return item1[NUMERIC_SORT_FIELD] > item2[NUMERIC_SORT_FIELD];
end

-- --------------------------------------------------------------------
-- **                         Sort functions                         **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> Sort -> ByDate(theTable, revert)                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> theTable: the table containing the items to sort.             *
-- * >> revert: revert the sorting order. True will put the more      *
-- * recent items first. False will put the least ones first.         *
-- ********************************************************************
-- * Sort a table containing sub-tables with a .date or .creationDate *
-- * field in normal or reversed order.                               *
-- ********************************************************************
function Root.Sort.ByDate(theTable, revert)
    if ( not revert ) then
        table.sort(theTable, ByDateSortFunc);
  else
        table.sort(theTable, ByDateRevertSortFunc);
    end
end

-- ********************************************************************
-- * Root -> Sort -> ByName(theTable, revert)                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> theTable: the table containing the items to sort.             *
-- * >> revert: revert the sorting order. True will put the more      *
-- * Z-items first. False will put A-items first.                     *
-- ********************************************************************
-- * Sort a table containing sub-tables with .name field in normal    *
-- * or reversed order.                                               *
-- ********************************************************************
function Root.Sort.ByName(theTable, revert)
    if ( not revert ) then
        table.sort(theTable, ByNameSortFunc);
  else
        table.sort(theTable, ByNameRevertSortFunc);
    end
end

-- ********************************************************************
-- * Root -> Sort -> ByNumericField(theTable, field, revert)          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> theTable: the table containing the items to sort.             *
-- * >> revert: revert the sorting order. True will put the highest   *
-- * items first. False will put the lowest items first.              *
-- ********************************************************************
-- * Sort a table containing sub-tables with a custom numeric field   *
-- * in increasing or decreasing order.                               *
-- ********************************************************************
function Root.Sort.ByNumericField(theTable, field, revert)
    NUMERIC_SORT_FIELD = field;
    if ( not revert ) then
        table.sort(theTable, ByNumericFieldSortFunc);
  else
        table.sort(theTable, ByNumericFieldRevertSortFunc);
    end
end