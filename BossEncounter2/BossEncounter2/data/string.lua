local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                           String data                          **
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- **                         String functions                       **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> FormatCountdownString(formatString, time[,               *
-- *                               hrsNoPad, minNoPad, secNoPad])     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> formatString: the format string.                              *
-- * The following tokens can be used:                                *
-- * %S for seconds, %M for minutes, %H for hours, %C for 1/100th s.  *
-- * >> time: the time amount (in sec) that will be used for          *
-- * this formatting.                                                 *
-- * >> xNoPad: if set, it will prevent the format function from      *
-- * adding a "0" if value of x is below 10.                          *
-- ********************************************************************
-- * Format a countdown or countdown-like string.                     *
-- ********************************************************************

function Root.FormatCountdownString(formatString, time, hrsNoPad, minNoPad, secNoPad)
    if type(time) ~= "number" or type(formatString) ~= "string" then return "INVALID"; end
    
    local hrs, min, sec, cen;

    -- Extract each component

    hrs = math.floor( math.floor(time) / 3600 );
    min = math.floor( math.fmod( math.floor(time) / 60 , 60 ) );
    sec = math.floor( math.fmod( math.floor(time) , 60 ) );
    cen = math.floor( math.fmod( math.floor(time * 100) , 100 ) );

    -- Pads a "0" if below 10 to look pretty (0:4 is dumb for instance, 00:04 is nice),
    -- given there is not a noPad parameter set to prevent us doing this.

    if ( hrs < 10 and not hrsNoPad ) then hrs = "0"..tostring(hrs); else hrs = tostring(hrs); end
    if ( min < 10 and not minNoPad ) then min = "0"..tostring(min); else min = tostring(min); end
    if ( sec < 10 and not secNoPad ) then sec = "0"..tostring(sec); else sec = tostring(sec); end
    if ( cen < 10 ) then cen = "0"..tostring(cen); else cen = tostring(cen); end

    -- Build the result string

    local text = formatString;
    text = string.gsub(text, "%%H", hrs);
    text = string.gsub(text, "%%M", min);
    text = string.gsub(text, "%%S", sec);
    text = string.gsub(text, "%%C", cen);
    return text;
end

-- ********************************************************************
-- * Root -> Print(text, short)                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> text: stuff to be printed in the chat.                        *
-- * >> short: if set, print BE2 as prefix instead of BossEncounter2. *
-- ********************************************************************
-- * Print a message in the chat frame.                               *
-- ********************************************************************
function Root.Print(text, short)
    if not ( DEFAULT_CHAT_FRAME ) then return; end
    if ( short ) then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00BE2 - |cffffffff"..text);
  else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00BossEncounter2 - |cffffffff"..text);
    end
end

-- ********************************************************************
-- * Root -> Debug(text)                                              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> text: stuff to be printed in the chat.                        *
-- ********************************************************************
-- * Print a message in the chat frame, only if in debug mode.        *
-- ********************************************************************
function Root.Debug(text)
    if not ( Root.debug ) then return; end
    if not ( DEFAULT_CHAT_FRAME ) then return; end
    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00BE2Debug - |cffffffff"..text);
end

-- ********************************************************************
-- * Root -> GetTimeString(value)                                     *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> value: value in seconds.                                      *
-- ********************************************************************
-- * Transforms a second value in a human readable string.            *
-- ********************************************************************
function Root.GetTimeString(value)
    value = math.floor((value or 0) + 0.5);
    if ( value >= 3600 ) then
        return Root.FormatCountdownString("%H h %M min %S sec", value, true, true, true);
elseif ( value >= 60 ) then
        return Root.FormatCountdownString("%M min %S sec", value, true, true, true);
  else
        return Root.FormatCountdownString("%S sec", value, true, true, true);
    end
end

-- ********************************************************************
-- * Root -> Whisper(text, target, usePrefix)                         *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> text: the whisper text.                                       *
-- * >> target: the target of the whisper.                            *
-- * >> usePrefix: if set, <BossEncounter2> will be added at the      *
-- * beginning of the message.                                        *
-- ********************************************************************
-- * Send a whisper on the chat.                                      *
-- ********************************************************************
function Root.Whisper(text, target, usePrefix)
    if ( usePrefix ) then text = "<BossEncounter2> "..text; end
    SendChatMessage(text, "WHISPER", nil, target);
end

-- ********************************************************************
-- * Root -> Say(text, usePrefix[, channel])                          *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> text: the text to say on chat.                                *
-- * >> usePrefix: if set, <BossEncounter2> will be added at the      *
-- * beginning of the message.                                        *
-- * >> channel: if specified, this will force the output there.      *
-- ********************************************************************
-- * Send a whisper on the chat.                                      *
-- ********************************************************************
function Root.Say(text, usePrefix, channel)
    if ( usePrefix ) then text = "<BossEncounter2> "..text; end

    local tchannel = "SAY";
    if ( GetNumRaidMembers() > 0 ) then
        tchannel = "RAID";
elseif ( GetNumPartyMembers() > 0 ) then
        tchannel = "PARTY";
    end
    if ( channel ) then
        tchannel = channel;
    end

    SendChatMessage(text, tchannel);
end

-- ********************************************************************
-- * Root -> Output(text, where)                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> text: the text to display.                                    *
-- * >> where: where to display the text.                             *
-- * Can be one of the following:                                     *
-- * OFFICER: the officer channel.                                    *
-- * GUILD: the guild channel.                                        *
-- * GROUP: the raid/party channel.                                   *
-- * SELF: to self.                                                   *
-- * name: whisper to the player named "name".                        *
-- ********************************************************************
-- * Send a message to the chat (advanced mode).                      *
-- ********************************************************************
function Root.Output(text, where)
    if ( where == "SELF" ) then
        Root.Print(text, true);
        return;

elseif ( where == "OFFICER" or where == "GUILD" or where == "GROUP" ) then
        if ( where == "GROUP" ) then
            Root.Say(text, false);
      else
            SendChatMessage(text, where);
        end
  else
        Root.Whisper(text, where, false);
        return;
    end
end

-- ********************************************************************
-- * Root -> GetColorCode(r, g, b)                                    *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> r, g, b: color components, between 0.00 ~ 1.00.               *
-- ********************************************************************
-- * Get the escape sequence representing the given color.            *
-- ********************************************************************
function Root.GetColorCode(r, g, b)
    r = math.floor(r * 255 + 0.5);
    rH = string.format("%x", r);
    if #rH < 2 then rH = "0"..rH; end

    g = math.floor(g * 255 + 0.5);
    gH = string.format("%x", g);
    if #gH < 2 then gH = "0"..gH; end

    b = math.floor(b * 255 + 0.5);
    bH = string.format("%x", b);
    if #bH < 2 then bH = "0"..bH; end

    return "|cff"..rH..gH..bH;
end