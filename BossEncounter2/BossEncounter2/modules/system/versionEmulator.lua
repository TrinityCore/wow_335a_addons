local Root = BossEncounter2;

local VersionEmulator = Root.GetOrNewModule("VersionEmulator");

local AdvancedOptions = Root.GetOrNewModule("AdvancedOptions");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- A functionnal module that allows you to answer foreign AddOns version queries.

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

local emulators = {
    ["BigWigs"] = {
        running = false,
        myVersion = 0,
        sendTimer = 0,
        inGroup = false,

        IsRealInstalled = function(emu)
            if ( BigWigsLoader ) then return true; end
            return false;
        end,

        messageHandler = {
            ["BWVQ3"] = function(emu, message, distribution, sender)
                -- Version query command. It might also contain the sender's version number, though it is not used by BW itself.

                local n = tonumber(message) or 0;
                emu.myVersion = max(n, emu.myVersion);

                emu.sendTimer = 7; -- Conveniently wait 2 additionnal seconds (relative to BW original protocol) before sending the answer,
                                   -- so we can check in the answers that we have the highest possible version.

                Root.Debug("Received version query for BW.");
            end,

            ["BWOOD3"] = function(emu, message, distribution, sender)
                -- Out-of-date notice, tadaa! Magically morph our current version number...

                local n = tonumber(message) or 0;
                emu.myVersion = max(n, emu.myVersion);
            end,

            ["BWVR3"] = function(emu, message, distribution, sender)
                -- Release version query answer, we spy on these to find the best version number possible...

                local n = tonumber(message) or 0;
                emu.myVersion = max(n, emu.myVersion);
            end,

            ["BWVRA3"] = function(emu, message, distribution, sender)
                -- Alpha version query answer, we do not bother.
            end,
        },

        OnUpdate = function(emu, elapsed)
            if ( emu.sendTimer > 0 ) then
                emu.sendTimer = max(0, emu.sendTimer - elapsed);
                if ( emu.sendTimer == 0 ) then
                    if ( emu.myVersion > 0 ) then
                        -- Okay, we have a good version number to send :)
                        VersionEmulator:SendPacket("BWVR3", "GROUP", tostring(emu.myVersion));
                        Root.Debug("Answering BW version query with version "..emu.myVersion.."!");
                  else
                        -- Uh-oh, we were requested to send a version answer, but we have no idea of what to send... Let's wait a bit more...
                        emu.sendTimer = 5;
                    end
                end
            end

            if ( VersionEmulator:IsInGroup() ) and ( not emu.inGroup ) then
                emu.inGroup = true;

                local randomVersion = math.random(5000, 6500);
                if ( emu.myVersion > 0 ) then randomVersion = emu.myVersion; end

                VersionEmulator:SendPacket("BWVQ3", "GROUP", tostring(randomVersion));
                Root.Debug("Querying BW version.");

        elseif ( not VersionEmulator:IsInGroup() ) and ( emu.inGroup ) then
                emu.inGroup = false;
            end
        end,
    },

    ["DeadlyBossMods"] = {
        running = false,
        myRevision = 0,
        myVersion = "",
        myDisplayVersion = "",
        sendTimer = 0,
        inGroup = false,

        IsRealInstalled = function(emu)
            if ( DBM ) then return true; end
            return false;
        end,

        messageHandler = {
            ["DBMv4-Ver"] = function(emu, msg, channel, sender)
                -- Version query/request-all-in-one command.
                if ( msg == "Hi!" ) then -- lol.
                    -- This guy wants our version.
                    emu.sendTimer = 2; -- The original DBM protocol sends the answer at once, but since we do not want to be D/C by version spamming bastards,
                                       -- we will be smarter and wait 2 additionnal seconds.

                    Root.Debug("Received version query for DBM.");
              else
                    -- Someone posted a version answer.

                    local revision, version, displayVersion, locale = strsplit("\t", msg);
                    revision, version = tonumber(revision or "") or 0, tonumber(version or "") or 0;

                    if ( revision > emu.myRevision ) and ( displayVersion ) then
                        emu.myRevision = revision;
                        emu.myVersion = version;
                        emu.myDisplayVersion = displayVersion;
                    end
                end
            end,
        },

        OnUpdate = function(emu, elapsed)
            if ( emu.sendTimer > 0 ) then
                emu.sendTimer = max(0, emu.sendTimer - elapsed);
                if ( emu.sendTimer == 0 ) then
                    if ( emu.myRevision > 0 ) then
                        -- Okay, we have a good version number to send :)
                        local packet = string.format("%s\t%s\t%s\t%s", emu.myRevision, emu.myVersion, emu.myDisplayVersion, GetLocale());
                        VersionEmulator:SendPacket("DBMv4-Ver", "GROUP", packet);
                        Root.Debug("Answering DBM version query with revision "..emu.myRevision.."!");
                  else
                        -- Uh-oh, we were requested to send a version answer, but we have no idea of what to send... Let's wait a bit more...
                        emu.sendTimer = 5;
                    end
                end
            end

            if ( VersionEmulator:IsInGroup() ) and ( not emu.inGroup ) then
                emu.inGroup = true;
                VersionEmulator:SendPacket("DBMv4-Ver", "GROUP", "Hi!");
                Root.Debug("Querying DBM version.");

        elseif ( not VersionEmulator:IsInGroup() ) and ( emu.inGroup ) then
                emu.inGroup = false;
            end
        end,
    },
};

VersionEmulator.nextEnableCheck = -1;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * VersionEmulator:IsInGroup()                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Determinate if we are in a party or a raid.                      *
-- ********************************************************************
VersionEmulator.IsInGroup = function(self)
    return (GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0);
end


-- ********************************************************************
-- * VersionEmulator:UpdateEnable()                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- *    <none>                                                        *
-- ********************************************************************
-- * Determinate if each emulator should be running or not.           *
-- ********************************************************************
VersionEmulator.UpdateEnable = function(self)
    local name, emu;
    for name, emu in pairs(emulators) do
        if ( AdvancedOptions:GetSetting("Emulation-"..name) ) and ( not emu:IsRealInstalled() ) then
            if ( not emu.running ) then
                Root.Debug("Starting "..name.." version emulator.");
            end
            emu.running = true;
      else
            if ( emu.running ) then
                Root.Debug("Stopping "..name.." version emulator.");
            end
            emu.running = false;
        end
    end
    VersionEmulator.nextEnableCheck = GetTime() + 15;
end

-- ********************************************************************
-- * VersionEmulator:SendPacket(prefix, recipient, content)           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> prefix: the target AddOn prefix.                              *
-- * >> recipient: the recipient of the packet. This argument can be  *
-- * the name of a player, a GUID of a player in your group, an UID.  *
-- * Recipient can also be one of these magic words: GROUP, GUILD.    *
-- * GROUP will try to send to raid first, then party.                *
-- * >> content: the content of the packet.                           *
-- ********************************************************************
-- * Send a foreign AddOn packet to a player.                         *
-- ********************************************************************
VersionEmulator.SendPacket = function(self, prefix, recipient, content)
    if type(recipient) ~= "string" then return; end

    -- Try to get a name if a magic word was not provided.
    recipient = Root.Network.GetRecipient(recipient);
    if ( not recipient ) then return; end

    -- Past this point, we have a valid player name or a magic word.
    
    local channel, extra;

    channel = "WHISPER";
    extra = UnitName("player");

    if ( recipient == "GUILD" ) then
        channel = "GUILD";
        extra = nil;

elseif ( recipient == "GROUP" ) then
	if ( select(2, IsInInstance()) == "pvp" ) then
            channel = "BATTLEGROUND";
            extra = nil;

    elseif ( GetNumRaidMembers() > 0 ) then
            channel = "RAID";
            extra = nil;

    elseif ( GetNumPartyMembers() > 0 ) then
            channel = "PARTY";
            extra = nil;
        end
  else
        channel = "WHISPER";
        extra = recipient;
    end

    if ( ChatThrottleLib ) then
        ChatThrottleLib:SendAddonMessage("NORMAL", prefix, content, channel, extra);
  else
        SendAddonMessage(prefix, content, channel, extra);
    end
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

VersionEmulator.OnEnterWorld = function(self)
    self:UpdateEnable();
end

VersionEmulator.OnAddonMessage = function(self, prefix, content, distribution, sender)
    local name, emu, handler;
    for name, emu in pairs(emulators) do
        if ( emu.running ) then
            handler = emu.messageHandler[prefix];
            if ( handler ) then handler(emu, content, distribution, sender); end
        end
    end
end

VersionEmulator.OnUpdate = function(self, elapsed)
    -- Periodically check if the user changed one of the emulation options.
    if ( self.nextEnableCheck > -1 ) then
        if ( GetTime() > self.nextEnableCheck ) then
            self:UpdateEnable();
        end
    end

    local name, emu;
    for name, emu in pairs(emulators) do
        if ( emu.running ) and ( emu.OnUpdate ) then
            emu:OnUpdate(elapsed);
        end
    end
end