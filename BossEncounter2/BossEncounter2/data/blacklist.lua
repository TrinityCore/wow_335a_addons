local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                        Blacklist data                          **
-- --------------------------------------------------------------------

-- Bastards are excluded here. x)

local BLACKLIST = {
    ["8ae39ee50c0ea6b19555fc84b1b95c41"] = true, -- D(test)
};

-- --------------------------------------------------------------------
-- **                      Blacklist functions                       **
-- --------------------------------------------------------------------

Root.IsBlacklisted = function(name)
    if type(MD5) ~= "table" then return false; end
    local hash = MD5:Hash((name or "?").."-"..(GetRealmName() or "?")) or "?";
    return BLACKLIST[hash] or false;
end

Root.AddTempBlacklist = function(name)
    if ( not name ) then return; end
    if ( not GetRealmName() ) then return; end
    if type(MD5) ~= "table" then return; end
    local hash = MD5:Hash(name.."-"..GetRealmName());
    if ( not hash ) then return; end
    BLACKLIST[hash] = true;
end