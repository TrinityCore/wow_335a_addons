local Root = BossEncounter2;

Root.Table = { };

-- --------------------------------------------------------------------
-- **                           Table data                           **
-- --------------------------------------------------------------------

local freeTables = { };

-- --------------------------------------------------------------------
-- **                         Table functions                        **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> Table -> Alloc()                                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Allocate a new table. Unused tables will be used for allocation  *
-- * first instead of creating new ones.                              *
-- * Use Recycle once you have finished using the table.              *
-- ********************************************************************

function Root.Table.Alloc()
    if #freeTables > 0 then
        local t = freeTables[#freeTables];
        freeTables[#freeTables] = nil;
        return t;
    end
    return { };
end

Root.Table.Allocate = Root.Table.Alloc;

-- ********************************************************************
-- * Root -> Table -> Recycle(theTable[, includeNesting])             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> theTable: a reference to the table you are recycling.         *
-- * >> includeNesting: if set, all tables contained within the table *
-- * will also be recycled (advanced / risky use if careless).        *
-- ********************************************************************
-- * Free a table once you no longer use it, so it can be reused      *
-- * later. This function also returns nil so you can easily void     *
-- * the reference.                                                   *
-- ********************************************************************

function Root.Table.Recycle(theTable, includeNesting)
    local k, v;
    for k, v in pairs(theTable) do
        theTable[k] = nil;
        if ( includeNesting ) and ( type(v) == "table" ) then
            Root.Table.Recycle(v, true);
        end
    end
    freeTables[#freeTables+1] = theTable;
    return nil;
end

Root.Table.Free = Root.Table.Recycle;