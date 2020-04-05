local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local argTable = { };

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

local me = {
    -- ============================================
    -- Initialize or reset the yell callback system
    -- ============================================

    ResetYellCallbacks = function(self)
        local data = self.data;
        if ( not data ) then return; end
        if ( not data.yells ) then
            data.yells = { };
      else
            local k;
            for k in ipairs(data.yells) do
                data.yells[k] = nil;
            end
        end
    end,

    -- ===============================================
    -- Add a yell that will trigger the given callback
    -- ===============================================

    RegisterYellCallback = function(self, npcName, matches, callback, ...)
        local data = self.data;
        if ( not data ) then return; end
        if ( not callback ) then return; end

        data.yells[#data.yells+1] = {
            npc = npcName or data.name,
            matches = matches,
            callback = callback,
            args = {...},
        };
    end,

    -- ===========================================================
    -- Parse a yell and fire associated callback if it's matching.
    -- ===========================================================

    HandleYells = function(self, message, source, target)
        local data = self.data;
        if ( not data ) then return; end
        if ( not data.yells ) then return; end

        local i, ii, me, match, numMatches, try;
        for i=1, #data.yells do
            me = data.yells[i];
            if ( source == me.npc ) or ( me.npc == "ANY" ) then
                match = false;

                numMatches = select('#', strsplit("|", me.matches));
                for ii=1, numMatches do
                    try = select(ii, strsplit("|", me.matches));
                    if ( string.find(message, try) ) then
                        match = true;
                        break;
                    end
                end

                if ( match ) then
                    wipe(argTable);
                    for ii=1, #me.args do
                        tinsert(argTable, me.args[ii]);
                    end

                    if ( target ) then tinsert(argTable, target); end
                    tinsert(argTable, message);

                    me.callback(unpack(argTable));
                end
            end
        end
    end,
};

-- --------------------------------------------------------------------
-- **                             Install                            **
-- --------------------------------------------------------------------

Root.InsertToModule(me, "Shared");