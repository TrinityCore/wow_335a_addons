local Root = BossEncounter2;

local Version = Root.GetOrNewModule("Version");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- A functionnal module that allows you to query BE2 version of other players.

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local VERSION_COOLDOWN = 2.5;
local QUERY_TIME = 4.0;
local SINGLE_QUERY_TIME = 2.5;

Version.running = false;
Version.timeOut = -1;

Version.answerCooldown = { };
Version.queryCooldown = -1;

Version.answers = { };
Version.names = { };

-- Possible answers:
-- [false] = not answered yet / no answer
-- [-1] = disconnected
-- [0] = unknown
-- [1, 2, 3...] = version 1, 2, 3...

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Version:CanQuery()                                               *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Return true if you may perform a version query now.              *
-- ********************************************************************

Version.CanQuery = function(self)
    if ( self.running ) then return false; end
    if ( GetTime() < self.queryCooldown ) then return false; end
    return true;
end

-- ********************************************************************
-- * Version:Query(recipient)                                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> recipient: a player name or a player GUID or GUILD or GROUP.  *
-- ********************************************************************
-- * Query the version of BE2.                                        *
-- ********************************************************************

Version.Query = function(self, recipient)
    if ( not self:CanQuery() ) then return false; end

    recipient = Root.Network.GetRecipient(recipient);
    if ( not recipient ) then return; end

    wipe(self.answers);
    wipe(self.names);

    local i;

    if ( recipient == "GROUP" ) then
        -- Group version check.
        local totalIndex = 0;
        local baseUID = nil;
        if ( GetNumRaidMembers() > 0 ) then
            totalIndex = GetNumRaidMembers();
            baseUID = "raid";
      else
            if ( GetNumPartyMembers() > 0 ) then
                totalIndex = GetNumPartyMembers();
                baseUID = "party";
            end
        end
        for i=1, totalIndex do
            if ( not UnitIsUnit("player", baseUID..i) ) then
                if ( UnitIsConnected(baseUID..i) ) then
                    self.answers[i] = false;
              else
                    self.answers[i] = -1;
                end
                self.names[i] = UnitName(baseUID..i);
            end
        end

elseif ( recipient == "GUILD" ) then
        -- Guild version check.
        local num = GetNumGuildMembers(false);
        local name, online;
        local count = 0;
        for i=1, num do
            name, _, _, _, _, _, _, _, online = GetGuildRosterInfo(i);
            if ( online ) and ( name ~= UnitName("player") ) then
                count = count + 1;
                self.answers[count] = false;
                self.names[count] = name;
            end
        end
  else
        -- Individual.
        self.answers[1] = false;
        self.names[1] = recipient;
    end

    if ( #self.names == 1 ) then
        self.timeOut = GetTime() + SINGLE_QUERY_TIME;
  else
        self.timeOut = GetTime() + QUERY_TIME;
    end
    self.running = true;
    self.queryCooldown = GetTime() + VERSION_COOLDOWN;

    Root.Network.Send("VERSION-QUERY", recipient);

    return true;
end

-- ********************************************************************
-- * Version:PrintResults()                                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Show the version query results. Should be called at the timeout. *
-- ********************************************************************

Version.PrintResults = function(self)
    Root.Print(Root.FormatLoc("Console-VersionResults", #self.names), true);
    Root.Print(Root.FormatLoc("Console-VersionSelf", Root.version), true);

    local i, name, result;
    for i=1, #self.names do
        name = self.names[i];
        result = self.answers[i];

        if ( not result ) then
            result = Root.Localise("Console-VersionNoAnswer");
    elseif ( result == 0 ) then
            result = Root.Localise("Console-VersionUnknown");
    elseif ( result == -1 ) then
            result = Root.Localise("Console-VersionDisconnected");
      else
            result = string.format("|cff00ff00BossEncounter2 v%d|r", result or 0);
        end

        Root.Print(string.format("%d. %s: %s", i, name, result), true);
    end

    self.running = false;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

Version.OnStart = function(self)
    -- Register net commands.
    Root.Network.Define("VERSION-QUERY", "V", "NORMAL", false);
    Root.Network.Define("VERSION-ANSWER", "v", "NORMAL", false);
end

Version.OnNetCommand = function(self, command, sender, ...)
    if ( command == "VERSION-QUERY" ) then
        if ( GetTime() < (self.answerCooldown[sender] or -1) ) then return; end
        self.answerCooldown[sender] = GetTime() + VERSION_COOLDOWN;

        -- Okay, not a spam, can reply.
        Root.Network.Send("VERSION-ANSWER", sender, Root.version);

elseif ( command == "VERSION-ANSWER" ) then
        if ( not self.running ) then return; end -- Wasn't doing a version check. Who cares ?

        local i, allDone;
        allDone = true;
        for i=1, #self.names do
            if ( self.names[i] == sender ) then
                self.answers[i] = tonumber(select(1, ...)) or 0;
            end
            if ( not self.answers[i] ) then
                allDone = false;
            end
        end
        if ( allDone ) then
            self:PrintResults();
        end
    end
end

Version.OnUpdate = function(self)
    if ( not self.running ) then return; end
    if ( GetTime() < self.timeOut ) then return; end

    -- Time up for version answers !
    self:PrintResults();
end