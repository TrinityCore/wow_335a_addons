local Root = BossEncounter2;
local GlobalOptions = Root.GetOrNewModule("GlobalOptions");
local AutoReply = Root.GetOrNewModule("AutoReply");

-- --------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////
-- --                              MODULE                            --
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- --------------------------------------------------------------------

-- A functionnal module that automatically answers people while a boss
-- fight is occuring.

-- --------------------------------------------------------------------
-- **                              Data                              **
-- --------------------------------------------------------------------

AutoReply.cooldown = { };

local AUTOREPLY_COOLDOWN = 60;

-- --------------------------------------------------------------------
-- **                             Methods                            **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * AutoReply:CanWhisper(name)                                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the guy checked.                            *
-- ********************************************************************
-- * Determinate if a guy can be whispered. Prevent spamming.         *
-- ********************************************************************

AutoReply.CanWhisper = function(self, name)
    if type(name) ~= "string" then return false; end
    if ( not GlobalOptions:GetSetting("AutoReplyInCombat") ) then return false; end

    local cooldown = self.cooldown[name] or -999;
    if ( GetTime() < cooldown ) then return false; end

    return true;
end

-- ********************************************************************
-- * AutoReply:Submit(name)                                           *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the target.                                 *
-- ********************************************************************
-- * Send an auto-reply explaining the state of the boss fight.       *
-- ********************************************************************

AutoReply.Submit = function(self, name)
    if ( not self:CanWhisper(name) ) then return; end

    local moduleName, encounterTitle, bossGUID, bossHpPercent, encounterTime, aliveMembers, startingMembers = BossEncounter2_GetEncounterInfo();
    if ( not moduleName ) or ((encounterTime or 0) <= 0) then return; end

    -- Ok, a module is running past this point. Build the answer.

    local header = Root.Localise("AutoReply-Header");
    local body = Root.Localise("AutoReply-Body");
    local tail = Root.Localise("AutoReply-Tail");
    local clock = Root.FormatCountdownString("%M'%S", encounterTime, true, true, false);

    header = string.format(header, UnitName("player"), encounterTitle or "??");

    if ( bossHpPercent ) then
        body = string.format(body, math.floor(bossHpPercent+0.5).."%", clock);
  else
        body = string.format(body, "??", clock);
    end

    if ( aliveMembers and startingMembers ) then
        tail = string.format(tail, aliveMembers.."/"..startingMembers);
elseif ( aliveMembers ) then
        tail = string.format(tail, aliveMembers);
  else
        tail = string.format(tail, "??");
    end

    Root.Whisper(header, name, true);
    Root.Whisper(body, name, false);
    Root.Whisper(tail, name, false);

    -- Put a cooldown to avoid spam.

    self.cooldown[name] = GetTime() + AUTOREPLY_COOLDOWN;
end

-- --------------------------------------------------------------------
-- **                             Handlers                           **
-- --------------------------------------------------------------------

AutoReply.OnWhisper = function(self, ...)
    local _, name, _, _, _, flag = ...;

    if ( flag ~= 'GM' ) then
        -- Try to access the player that whispered. If we can't, then it is necessarily outside of our party.
        local uid = Root.Unit.GetUID(name);
        if ( not uid ) then
            -- Ok, this guy is outside of the raid.
            self:Submit(name);
        end
    end
end