--[[################ FFEvents.lua ######################
    # Follow Felankor
    # A World of Warcraft UI AddOn
    # By Felankor
    #
    # IMPORTANT: I do not mind people looking at my code
    # to learn from it. If you use any parts of my code
    # please give me credit in your comments. I will
    # do the same if I ever use any code from another
    # AddOn. Thanks.
    ###################################################]]--

--[[#########################################
    #        Event Related Functions
    #########################################]]

local FFAuthorised = ""; --Used to store either Yes or No for the whisper log
local FF_Sender = FFWHISPLOG_UNKNOWN; --Used to store the name for the whisper log
local FF_HidePartyInvite = false; --Set to true when a party invite is automatically accepted
    
function FF_OnEvent(event)

    if (event == "ADDON_LOADED") then--If an addon was just loaded
        if (arg1 == "FollowFelankor") then--If this was the addon that was loaded
            FF_LoadVariables();--Load the variables into the addon
            FFOptions_Load(); --Set up the option panels
            FF_UpdateStatus();
            FF_UpdateMounts();
        end
        
    end
    
    if (event == "COMPANION_UPDATE") then --If the mount list was updated
        FF_UpdateMounts();
    end

    if (FF_Options['Enabled'] == 1) then
        
        if (event == "CHAT_MSG_WHISPER") then --If the event was a whisper
            FF_ParseWhisper(event);
        end
        
        if (event == "CHAT_MSG_ADDON") then --If the event was a message from an addon
            FF_ParseAddonMessage(event);
        end
        
        if (event == "AUTOFOLLOW_BEGIN") then
            FF_Leader = arg1;
            FF_Following=true;
            
            if (FF_Announce_Following == true) then
                
                if (FF_Options_Announcements['AnnounceFollowStart'] == 1) then
                    
                    if (GetNumRaidMembers() > 0) then --If player is in a raid
                        FF_SendRaidMessage(FFMSG_FOLLOWING..FF_Leader); --Tell the raid who we are following
                    elseif (GetNumPartyMembers() > 0) then --If player is in a party
                        FF_SendPartyMessage(FFMSG_FOLLOWING..FF_Leader); --Tell the party who we are following
                    end
                    
                end
                
            else --If the player started the auto follow him/her self (i.e. it wasn't started by using a whisper command)
                
                SendAddonMessage(FF_AddonMessagePrefix, "FollowingYou", "WHISPER", FF_Leader); --Send a message to the person I'm following (If they are using Follow Felankor they will be told I am following)
                
            end
            
        end
        
        if (event == "AUTOFOLLOW_END") then
            FF_Following=false;
            
            -----------------------------------------------------------------------------------
            -- AUTOFOLLOW_END seems to fire more than once when u stop following someone
            -- By clearing FF_Leader the first time it is fired and checking if it is empty
            -- every time. It stops the FFMSG_STOPPED_FOLLOWING message being repeated in chat
            -----------------------------------------------------------------------------------
            
            if (FF_Leader ~= "") then --Check if FF_Leader is empty (see comment above for details)
                if (FF_Announce_Following == true) then
                    
                    if (FF_Options_Announcements['AnnounceFollowStop'] == 1) then
                        
                        if (GetNumRaidMembers() > 0) then --If player is in a raid
                            FF_SendRaidMessage(FFMSG_STOPPED_FOLLOWING..FF_Leader); --Tell the raid we stopped following
                        elseif (GetNumPartyMembers() > 0) then --If player is in a party
                            FF_SendPartyMessage(FFMSG_STOPPED_FOLLOWING..FF_Leader); --Tell the party we stopped following
                        end
                        
                    end
                    
                else --If the player started the auto follow him/her self (i.e. it wasn't started by using a whisper command)
                    
                    SendAddonMessage(FF_AddonMessagePrefix, "StoppedFollowingYou", "WHISPER", FF_Leader); --Send a message to the person I'm following (If they are using Follow Felankor they will be told I am following)
                    
                end
                
            end
            
            FF_Announce_Following = false;
            FF_Leader = ""; --Clear the leader
            
        end
        
        if (event == "CHAT_MSG_SYSTEM") then
        
            if (string.sub(arg1, 13, 15) == "AFK") then --If the user went AFK
            
                if (FF_Following == false) then
                    
                    if (FF_Options_Announcements['AnnounceAFK'] == 1) then
                        
                        if (GetNumRaidMembers() > 0) then
                            FF_SendRaidMessage(FFMSG_AFK);
                        elseif (GetNumPartyMembers() > 0) then
                            FF_SendPartyMessage(FFMSG_AFK);
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
        if (event == "PARTY_INVITE_REQUEST") then
        
            if (FF_Options['AllowAutoAcceptParty'] == 1) then
                FF_Sender=arg1; --Get name of sender
                FF_SenderID = FF_AuthoriseSender(FF_Sender, false, false, true, true);--Check if the player is a guild member or a friend
                if (FF_SenderID ~= nil) then --If the sender was authorised
                    AcceptGroup();--Accept the invitation
                    FF_HidePartyInvite = true;
                    FF_SendWhisper(FFMSG_PARTY_AUTO_ACCEPTED, FF_Sender);
                    FFAuthorised = FFWHISPLOG_YES;
                else
                    FFAuthorised = FFWHISPLOG_NO;
                end
            
            end
            
            if (FF_Options["EnableLogging"] == 1) then
                --Log this whisper
                LogWhisper(FFWHISPLOG_PARTY_INVITE, FF_Sender, FFAuthorised);
            end
            FFAuthorised = ""; --Clear the string
        
        end
        
        if (event == "PARTY_MEMBERS_CHANGED") then
            
            if (FF_HidePartyInvite == true) then --Set when a party invite is automatically accepted
                StaticPopup_Hide("PARTY_INVITE");--Hide the party invite box
            end
            
            if (GetNumPartyMembers() > 0) then --If the player is in a group
                --Hide PartyStatus Frames and request new status check
                SendAddonMessage(FF_AddonMessagePrefix, "StatusCheck", "PARTY"); --Find out if the party members are using Follow Felankor
            end
            
            FF_CheckForUpdate();
            --FF_UpdatePartyStatus will be called twice if a reply is received to the SendAddonMessage sent above. This is necessary because this will
            --fire before players responses are received and if players a moved around in a raid the other call won't happen and the status wont update.
            FF_UpdatePartyStatus();
            
        end
        
        if (event == "GUILD_ROSTER_UPDATE") then
            
            SendAddonMessage(FF_AddonMessagePrefix, "StatusCheck", "GUILD"); --Find out if the guild members are using Follow Felankor
            
            FF_CheckForUpdate();
        end
        
        if (event == "RESURRECT_REQUEST") then
            
            if (FF_Options['AllowAcceptResurrect'] == 1) then
                FF_Sender=arg1; --Get name of sender
                FF_SenderID = FF_AuthoriseSender(FF_Sender, true, true, true, true);--Check if the player is a guild, raid or party member or a friend
                if (FF_SenderID ~= nil) then --If the sender was authorised
                    AcceptResurrect();
                    
                    if (FF_Options_Announcements['AnnounceResurrection'] == 1) then
                        
                        if (GetNumRaidMembers() > 0) then
                            FF_SendRaidMessage(FFMSG_RESURRECT_AUTO_ACCEPTED..FF_Sender);
                        elseif (GetNumPartyMembers() > 0) then
                            FF_SendPartyMessage(FFMSG_RESURRECT_AUTO_ACCEPTED..FF_Sender);
                        else
                            FF_SendWhisper(FFMSG_RESURRECT_AUTO_ACCEPTED, FF_Sender);
                        end
                        
                    end
                    
                    FFAuthorised = FFWHISPLOG_YES;
                
                else
                    FFAuthorised = FFWHISPLOG_NO;
                end
            
            end
            
            if (FF_Options["EnableLogging"] == 1) then
                --Log this whisper
                LogWhisper(FFWHISPLOG_RESURRECT_REQUEST, FF_Sender, FFAuthorised);
            end
            FFAuthorised = ""; --Clear the string
            
        end
        
        --[[######### NPC Frame Events #########]]
        
        if (event == "MERCHANT_SHOW") then
            FF_MerchantStatus = 1; --Set the merchant status to open
        end
        
        if (event == "MERCHANT_CLOSED") then
            FF_MerchantStatus = 0; --Set the merchant status to closed
        end
        
        if (event == "AUCTION_HOUSE_SHOW") then
            FF_AuctionStatus = 1; --Set the auction house status to open
        end
        
        if (event == "AUCTION_HOUSE_CLOSED") then
            FF_AuctionStatus = 0; --Set the auction house status to closed
        end
        
        if (event == "BANKFRAME_OPENED") then
            FF_BankStatus = 1; --Set the bank status to open
        end
        
        if (event == "BANKFRAME_CLOSED") then
            FF_BankStatus = 0; --Set the bank status to closed
        end
        
        if (event == "GUILDBANKFRAME_OPENED") then
            FF_GuildBankStatus = 1; --Set the guild bank status to open
        end
        
        if (event == "GUILDBANKFRAME_CLOSED") then
            FF_GuildBankStatus = 0; --Set the guild bank status to closed
        end
        
        if (event == "TAXIMAP_OPENED") then
            FF_TaxiMapStatus = 1; --Set the taxi map status to open
        end
        
        if (event == "TAXIMAP_CLOSED") then
            FF_TaxiMapStatus = 0; --Set the taxi map status to closed
        end
        
        if (event == "LOOT_OPENED") then
            FF_LootStatus = 1; --Set the loot box status to open
        end
        
        if (event == "LOOT_CLOSED") then
            FF_LootStatus = 0; --Set the loot box status to closed
        end
        
    end --End: if (FF_Options['Enabled'] == 1) then
    
    ------------------------------------------------------
    -- The following Whisper & Slash command needs to work
    -- if the addon is disabled. That is why it is here
    -- instead of in the FF_ParseWhisper function.
    ------------------------------------------------------
    
    if (event == "CHAT_MSG_WHISPER") then
        
        if (string.sub(string.lower(arg1), 1, string.len(FFWHISP_CHECK)) == FFWHISP_CHECK) then --If the command was FFWHISP_CHECK
            local FF_Status = nil;
            FF_Sender=arg2;
            
            if (FF_Options['Enabled'] == 1) then
                FF_Status = "Enabled";
            else
                FF_Status = "Disabled";
            end
            
            FF_SendWhisper(FFMSG_ADDON_NAME.." v"..GetAddOnMetadata("FollowFelankor", "Version").." ("..FF_Status..")", FF_Sender);
            
            FFAuthorised = FFWHISPLOG_YES;
            if (FF_Options["EnableLogging"] == 1) then
                --Log this whisper
                LogWhisper(FFWHISP_CHECK, FF_Sender, FFAuthorised);
            end
            FFAuthorised = ""; --Clear the string
        end
        
    end --End: if (event == "CHAT_MSG_WHISPER") then
    
    if (event == "CHAT_MSG_ADDON") then --If the event was a message from an addon
        
        if (arg1 == FF_AddonMessagePrefix) then --If the message wasn't from Follow Felankor
            
            if (arg2 == "ForcedStatusCheck") then --If the message was asking for a status check (triggered with the /ff_CheckStatus command)
                SendAddonMessage(FF_AddonMessagePrefix, "ForcedStatusReply: "..FF_Version.." "..FF_Options['Enabled'], "WHISPER", arg4); --Reply to the message with the version and status of Follow Felankor
                
                if (FF_Options_Announcements["StatusCheckNotify"] == 1) then --If the "Notify me when somebody uses /ff_CheckStatus on me" option is ticked
                    FF_LocalMessage(arg4..FFMSG_STATUS_CHECK_REQUESTED); --Tell the user that a status check has been requested
                end
                
            end --End: if (arg2 == "ForcedStatusCheck") then
            
            if (string.sub(arg2, 1, 18) == "ForcedStatusReply:") then --If the message is a reply to the /ff_CheckStatus command
                
                local PlayersFF_Enabled = 0;
                if (string.sub(arg2, string.len(arg2), string.len(arg2)) == "1") then --If the players FF is enabled
                    PlayersFF_Enabled = FFMSG_ENABLED;
                else
                    PlayersFF_Enabled = FFMSG_DISABLED;
                end
                
                FF_LocalMessage(arg4..FFMSG_STATUS_REPLY_PART1..string.sub(arg2, 19, (string.len(arg2) - 2))..FFMSG_STATUS_REPLY_PART2..PlayersFF_Enabled..".");
                
            end --End: if (string.sub(arg2, 1, 18) == "ForcedStatusReply:") then
            
        end --End: if (arg1 == FF_AddonMessagePrefix) then
        
    end --End: if (event == "CHAT_MSG_ADDON") then
    
end

function FF_ParseWhisper(event)
--[[ NOTE: usage of FF_AuthoriseSender(Sender, Party(true/false), Raid(true/false), Guild(true/false), Friend(true/false));]]
    if (arg1 and arg2) then --If a message and sender were present
        
        FF_Sender_Banned = false;
        for i=1, table.getn(FF_Ban_List) do
            if (FF_Ban_List[i] == string.lower(arg2)) then
                FF_Sender_Banned = true;
            end
        end
        
        if (FF_Sender_Banned == false) then
            
            if ((string.sub(string.lower(arg1), 1, string.len(FFWHISP_FOLLOW)) == FFWHISP_FOLLOW) or (string.sub(string.lower(arg1), 1, string.len(FFWHISP_FOLLOW_ALIAS)) == FFWHISP_FOLLOW_ALIAS)) then --If the message is !ff_follow
            
                if (string.sub(string.lower(arg1), 1, string.len(FFWHISP_MOUNTFLYING)) ~= FFWHISP_MOUNTFLYING) then --FFWHISP_FOLLOW_ALIAS (!ff_f) can is called when !ff_fly is whispered. Make sure this wasn't !ff_fly
                    FF_Sender=arg2; --Get name of sender
                    FF_SenderID = FF_AuthoriseSender(FF_Sender, true, true, true, true);--Check if the player is a guild, party or raid member or a friend
                    
                    if (FF_SenderID ~= nil) then --If the sender was authorised
                        
                        FF_PermitFollow = 1; --Allow auto follow by default (We will check if the user is busy before following)
                        
                        if (FF_Options['PreventFollowWhenBusy'] == 1) then --If the follow whisper command should be prevented if the player is busy (e.g. using auction house or npc)
                            
                            if (FF_MerchantStatus == 1) then --If an NPC window is open
                                FF_PermitFollow = 0; --Prevent auto follow
                            elseif (FF_AuctionStatus == 1) then --If the auction house is open
                                FF_PermitFollow = 0; --Prevent auto follow
                            elseif (FF_BankStatus == 1) then --If the bank is open
                                FF_PermitFollow = 0; --Prevent auto follow
                            elseif (FF_GuildBankStatus == 1) then --If the guild bank is open
                                FF_PermitFollow = 0; --Prevent auto follow
                            elseif (FF_TaxiMapStatus == 1) then --If the flight master/taxi map frame is open
                                FF_PermitFollow = 0; --Prevent auto follow
                            elseif (FF_LootStatus == 1) then --If a loot box is open
                                FF_PermitFollow = 0; --Prevent auto follow
                            end
                            
                        end
                        
                        if (FF_PermitFollow == 1) then
                            FF_SendWhisper(FFMSG_ATTEMPTING_FOLLOW, FF_Sender); --Tell the player you are trying to follow them
                            
                            if (string.len(FF_SenderID) > 5) then
                                
                                if ((string.sub(string.lower(FF_SenderID), 0, 4) == "party") or (string.sub(string.lower(FF_SenderID), 0, 3) == "raid")) then
                                
                                    if (CheckInteractDistance(FF_SenderID, 4) == nil) then --Check if the player is close enough
                                        
                                        FF_SendWhisper(FFMSG_COME_CLOSER, FF_Sender); --Tell the player that they need to come closer
                                        
                                    else
                                        
                                        FF_Announce_Following = true;
                                        FollowUnit(FF_SenderID);
                                        
                                    end
                                    
                                else --If the player is not in your group/raid the CheckInteractDistance function will not work with player name. We just have to attempt to follow.
                                    
                                    FF_Announce_Following = false;
                                    FollowUnit(FF_SenderID);
                                    
                                end
                                
                            else --The player is not in a group/raid so the CheckInteractDistance function will not work with player name. We just have to attempt to follow.
                                
                                FF_Announce_Following = false;
                                FollowUnit(FF_SenderID);
                                
                            end
                            FFAuthorised = FFWHISPLOG_YES;
                            
                        else
                            FF_SendWhisper(FFMSG_TOO_BUSY_TO_FOLLOW, FF_Sender); --Tell the player that you cannot follow them right now because you are busy
                        end
                        
                    else
                        FFAuthorised = FFWHISPLOG_NO;
                        FF_SendWhisper(FFMSG_CANT_FOLLOW, FF_Sender); --Tell the player you cant follow them
                        
                    end
                    
                    if (FF_Options["EnableLogging"] == 1) then
                        --Log this whisper
                        LogWhisper(FFWHISP_FOLLOW, FF_Sender, FFAuthorised);
                    end
                    FFAuthorised = ""; --Clear the string
                    
                end
                
            end --End: FFWHISP_FOLLOW
            
            if ((string.sub(string.lower(arg1), 1, string.len(FFWHISP_INVITE_ME)) == FFWHISP_INVITE_ME) or (string.sub(string.lower(arg1), 1, string.len(FFWHISP_INVITE_ME_ALIAS)) == FFWHISP_INVITE_ME_ALIAS)) then --If the message is !ff_inviteme
                FF_Sender=arg2; --Get name of sender
                FF_SenderID = FF_AuthoriseSender(FF_Sender, false, false, true, true);--Check if the player is a guild member or a friend
                
                if (FF_SenderID ~= nil) then --If the sender was authorised
                        
                    FFAuthorised = FFWHISPLOG_YES;
                        
                    if (FF_Options['AllowInviteRequests'] == 1) then
                        
                        if ((IsPartyLeader()) or (GetNumPartyMembers() == 0)) then --If the player is group leader or  isnt in a party
                            
                            FF_SenderID = FF_AuthoriseSender(FF_Sender, true, false, false, false);--Check if the player is allready in our group
                            
                            if (FF_SenderID == nil) then --if the sender is not allready in our group
                                
                                InviteUnit(FF_Sender); --Invite the player to your party/group
                                
                                if (FF_Options_Announcements['AnnounceAutoInvite'] == 1) then
                                    
                                    if (GetNumRaidMembers() > 0) then
                                        FF_SendRaidMessage(FF_Sender..FFMSG_AUTO_INVITED);
                                    elseif (GetNumPartyMembers() > 0) then
                                        FF_SendPartyMessage(FF_Sender..FFMSG_AUTO_INVITED);
                                    end
                                    
                                end
                                
                            else
                                
                                FF_SendWhisper(FFMSG_ALLREADY_IN_PARTY, FF_Sender); --Tell the player they are allready in the group
                                
                            end
                            
                        else
                            
                            if (FF_Options_Announcements['AnnounceRequestInviteForFriend'] == 1) then --If FF should ask the party leader to invite the person who sent !FF_InviteMe
                                FF_SendPartyMessage(FFMSG_PLEASE_INVITE_FRIEND_TO_GROUP..FF_Sender..". "..FFMSG_THANK_YOU);
                                FF_SendWhisper(FFMSG_NOT_PARTY_LEADER.." "..FFMSG_REQUESTING_INVITE_FOR_YOU, FF_Sender); --Tell the sender the player is not the party leader, but FF has asked if they can be invited
                            else
                                FF_SendWhisper(FFMSG_NOT_PARTY_LEADER, FF_Sender); --Tell the sender the player is not the party leader
                            end
                            
                        end
                        
                    else
                        FF_SendWhisper(FFMSG_AUTO_INVITES_OFF, FF_Sender); --Tell the user you can't invite them
                    end
                    
                else
                    FF_SendWhisper(FFMSG_NOT_FRIEND_GUILD, FF_Sender); --Tell the user you can't invite them
                    FFAuthorised = FFWHISPLOG_NO;
                end
                
                if (FF_Options["EnableLogging"] == 1) then
                    --Log this whisper
                    LogWhisper(FFWHISP_INVITE_ME, FF_Sender, FFAuthorised);
                end
                FFAuthorised = ""; --Clear the string
                
            end --End: FFWHISP_INVITE_ME
            
            if ((string.sub(string.lower(arg1), 1, string.len(FFWHISP_MOUNTGROUND)) == FFWHISP_MOUNTGROUND) or (string.sub(string.lower(arg1), 1, string.len(FFWHISP_MOUNTGROUND_ALIAS)) == FFWHISP_MOUNTGROUND_ALIAS)) then --If the message is !ff_mount or !ff_m
                FF_Sender=arg2; --Get name of sender
                FF_SenderID = FF_AuthoriseSender(FF_Sender, true, true, true, true);--Check if the player is a guild member, party/raid member or a friend
                
                if (FF_SenderID ~= nil) then --If the sender was authorised
                    
                    FF_SendWhisper(FFMSG_ATTEMPTING_MOUNT, FF_Sender);
                    FF_MountGround(FF_Sender);
                    FFAuthorised = FFWHISPLOG_YES;
                    
                else
                
                    FF_SendWhisper(FFMSG_DONT_KNOW_YOU, FF_Sender); --Tell the player you cant sit or stand
                    FFAuthorised = FFWHISPLOG_NO;
                    
                end
                
                if (FF_Options["EnableLogging"] == 1) then
                    --Log this whisper
                    LogWhisper(FFWHISP_MOUNTGROUND, FF_Sender, FFAuthorised);
                end
                FFAuthorised = ""; --Clear the string
                
            end --End: FFWHISP_MOUNTGROUND
            
            if ((string.sub(string.lower(arg1), 1, string.len(FFWHISP_MOUNTRGROUND)) == FFWHISP_MOUNTRGROUND) or (string.sub(string.lower(arg1), 1, string.len(FFWHISP_MOUNTRGROUND_ALIAS)) == FFWHISP_MOUNTRGROUND_ALIAS)) then --If the message is !ff_rmount or !ff_rm
                FF_Sender=arg2; --Get name of sender
                FF_SenderID = FF_AuthoriseSender(FF_Sender, true, true, true, true);--Check if the player is a guild member, party/raid member or a friend
                
                if (FF_SenderID ~= nil) then --If the sender was authorised
                    
                    FF_SendWhisper(FFMSG_ATTEMPTING_MOUNT, FF_Sender);
                    FF_MountRandomGround(FF_Sender);
                    FFAuthorised = FFWHISPLOG_YES;
                    
                else
                
                    FF_SendWhisper(FFMSG_DONT_KNOW_YOU, FF_Sender); --Tell the player you cant sit or stand
                    FFAuthorised = FFWHISPLOG_NO;
                    
                end
                
                if (FF_Options["EnableLogging"] == 1) then
                    --Log this whisper
                    LogWhisper(FFWHISP_MOUNTRGROUND, FF_Sender, FFAuthorised);
                end
                FFAuthorised = ""; --Clear the string
                
            end --End: FFWHISP_MOUNTRGROUND
            
            if (string.sub(string.lower(arg1), 1, string.len(FFWHISP_MOUNTFLYING)) == FFWHISP_MOUNTFLYING) then --If the message is !ff_fly
                FF_Sender=arg2; --Get name of sender
                FF_SenderID = FF_AuthoriseSender(FF_Sender, true, true, true, true);--Check if the player is a guild member, party/raid member or a friend
                
                if (FF_SenderID ~= nil) then --If the sender was authorised
                    
                    FF_SendWhisper(FFMSG_ATTEMPTING_MOUNT, FF_Sender);
                    FF_MountFlying(FF_Sender);
                    FFAuthorised = FFWHISPLOG_YES;
                    
                else
                
                    FF_SendWhisper(FFMSG_DONT_KNOW_YOU, FF_Sender); --Tell the player you cant sit or stand
                    FFAuthorised = FFWHISPLOG_NO;
                    
                end
                
                if (FF_Options["EnableLogging"] == 1) then
                    --Log this whisper
                    LogWhisper(FFWHISP_MOUNTFLYING, FF_Sender, FFAuthorised);
                end
                FFAuthorised = ""; --Clear the string
                
            end --End: FFWHISP_MOUNTFLYING
            
            if (string.sub(string.lower(arg1), 1, string.len(FFWHISP_MOUNTRFLYING)) == FFWHISP_MOUNTRFLYING) then --If the message is !ff_rfly
                FF_Sender=arg2; --Get name of sender
                FF_SenderID = FF_AuthoriseSender(FF_Sender, true, true, true, true);--Check if the player is a guild member, party/raid member or a friend
                
                if (FF_SenderID ~= nil) then --If the sender was authorised
                    
                    FF_SendWhisper(FFMSG_ATTEMPTING_MOUNT, FF_Sender);
                    FF_MountRandomFlying(FF_Sender);
                    FFAuthorised = FFWHISPLOG_YES;
                    
                else
                
                    FF_SendWhisper(FFMSG_DONT_KNOW_YOU, FF_Sender); --Tell the player you cant sit or stand
                    FFAuthorised = FFWHISPLOG_NO;
                    
                end
                
                if (FF_Options["EnableLogging"] == 1) then
                    --Log this whisper
                    LogWhisper(FFWHISP_MOUNTRFLYING, FF_Sender, FFAuthorised);
                end
                FFAuthorised = ""; --Clear the string
                
            end --End: FFWHISP_MOUNTRFLYING
            
            if (string.sub(string.lower(arg1), 1, string.len(FFWHISP_SIT)) == FFWHISP_SIT) then --If the message is !ff_sitorstand
                FF_Sender=arg2; --Get name of sender
                
                FF_SenderID = FF_AuthoriseSender(FF_Sender, true, true, true, true);--Check if the player is a guild member, party/raid member or a friend
                
                if (FF_SenderID ~= nil) then --If the sender was authorised
                
                    DoEmote("sit");
                    FFAuthorised = FFWHISPLOG_YES;
                    
                else
                
                    FF_SendWhisper(FFMSG_DONT_KNOW_YOU, FF_Sender); --Tell the player you cant sit or stand
                    FFAuthorised = FFWHISPLOG_NO;
                    
                end
                
                if (FF_Options["EnableLogging"] == 1) then
                    --Log this whisper
                    LogWhisper(FFWHISP_SIT, FF_Sender, FFAuthorised);
                end
                FFAuthorised = ""; --Clear the string
                
            end --End: FFWHISP_SIT
            
            if (string.sub(string.lower(arg1), 1, string.len(FFWHISP_STAND)) == FFWHISP_STAND) then --If the message is !ff_sitorstand
                FF_Sender=arg2; --Get name of sender
                
                FF_SenderID = FF_AuthoriseSender(FF_Sender, true, true, true, true);--Check if the player is a guild member, party/raid member or a friend
                
                if (FF_SenderID ~= nil) then --If the sender was authorised
                
                    DoEmote("stand");
                    FFAuthorised = FFWHISPLOG_YES;
                    
                else
                
                    FF_SendWhisper(FFMSG_DONT_KNOW_YOU, FF_Sender); --Tell the player you cant sit or stand
                    FFAuthorised = FFWHISPLOG_NO;
                    
                end
                
                if (FF_Options["EnableLogging"] == 1) then
                    --Log this whisper
                    LogWhisper(FFWHISP_STAND, FF_Sender, FFAuthorised);
                end
                FFAuthorised = ""; --Clear the string
                
            end --End: FFWHISP_STAND
            
            if (string.sub(string.lower(arg1), 1, string.len(FFWHISP_HELP)) == FFWHISP_HELP) then--If the message is !ff_help or !ff_help command
                FF_Sender=arg2;
                local FF_CommandStartPos = string.len(FFWHISP_HELP) + 2;
                local FF_Help_With=nil;
                local FF_CommandFound=false;
                
                FFAuthorised = FFWHISPLOG_YES;
                
                if (string.len(arg1) > (FF_CommandStartPos)) then--if the message has a command
                    FF_Help_With = string.lower(string.sub(arg1, FF_CommandStartPos));
                end
                
                if (FF_Help_With ~= nil) then--If the message has a command
                    
                    for i=1, table.getn(FFWHISP_HELP_TABLE) do--For every command in the table
                    
                        if (FF_Help_With == string.lower(string.sub(FFWHISP_HELP_TABLE[i], 2, string.len(FFWHISP_HELP_TABLE[i])))) then--If the command is in the table
                            FF_SendWhisper(FF_HELP_DESCRIPTIONS_TABLE[i], FF_Sender);--Give the user help for the command
                            FF_CommandFound = true;
                        end
                        
                    end
                    
                    if (FF_CommandFound == false) then
                        FF_SendWhisper(FFMSG_HELP_UNKOWN_COMAND..FF_Help_With, FF_Sender);--Tell the user that the command does not exist
                    end
                
                else
                
                    local FF_AvailableCommands={};
                    local j=1;
                    
                    for i=1, table.getn(FFWHISP_COMMAND_LIST) do--For every command in the table
                    
                        if (FF_AvailableCommands[1] ~= nil) then--If the table is not empty
                            
                            if (string.len(FF_AvailableCommands[j]) >= 220) then--If the table slot is holding more than 220 characters
                                j = j +1;--Start using a new slot in the table
                            end
                            
                            FF_AvailableCommands[j] = FF_AvailableCommands[j]..", "..FFWHISP_COMMAND_LIST[i];--Add the command to the slot
                            
                        else
                            FF_AvailableCommands[j] = FFWHISP_COMMAND_LIST[i];--Add the first command to the slot
                        end
                        
                    end
                    
                    FF_SendWhisper(FFMSG_HELP_AVAILABLE_COMMANDS, FF_Sender);--Whisper command header
                    
                    for i=1, table.getn(FF_AvailableCommands) do--For everything we just added to the table
                    
                        FF_SendWhisper(FF_AvailableCommands[i], FF_Sender);--Send the user the list of commands
                        
                    end
                    
                    FF_SendWhisper(FFMSG_HELP_MORE_INFO, FF_Sender);--Tell the user how to get more help
                    
                    FF_AvailableCommands={};--Clear the table
                    
                end
                
                if (FF_Options["EnableLogging"] == 1) then
                    --Log this whisper
                    LogWhisper(FFWHISP_HELP, FF_Sender, FFAuthorised);
                end
                FFAuthorised = ""; --Clear the string
                
            end --End: FFWHISP_HELP
            
            --[[#######################################################
                #              Fun Whisper Commands
                #####################################################]]
            
            if ((string.sub(string.lower(arg1), 1, string.len(FFWHISP_DANCE)) == FFWHISP_DANCE) or (string.sub(string.lower(arg1), 1, string.len(FFWHISP_DANCE_ALIAS)) == FFWHISP_DANCE_ALIAS)) then --If the message is !ff_dance
                FF_Sender=arg2; --Get name of sender
                FF_SenderID = FF_AuthoriseSender(FF_Sender, true, true, true, true);--Check if the player is a guild member, party/raid member or a friend
                                    
                if (FF_SenderID ~= nil) then --If the sender was authorised
                    DoEmote("dance");--Start dancing
                    FFAuthorised = FFWHISPLOG_YES;
                else
                    FF_SendWhisper(FFMSG_DONT_KNOW_YOU, FF_Sender); --Tell the player you cant dance
                    FFAuthorised = FFWHISPLOG_NO;
                end
                
                if (FF_Options["EnableLogging"] == 1) then
                    --Log this whisper
                    LogWhisper(FFWHISP_DANCE, FF_Sender, FFAuthorised);
                end
                FFAuthorised = ""; --Clear the string
                
            end --End: FFWHISP_DANCE
            
            if (string.sub(string.lower(arg1), 1, string.len(FFWHISP_EMOTE)) == FFWHISP_EMOTE) then--If the message is !ff_emote
                
                FF_Sender=arg2;
                FF_SenderID = FF_AuthoriseSender(FF_Sender, false, false, true, true);--Check if the player is a guild member or a friend
                
                local FF_EmotionStartPos = string.len(FFWHISP_EMOTE) + 2;
                local FF_Emotion = nil;
                
                if (string.len(arg1) > (FF_EmotionStartPos)) then--if the message has a command
                    FF_Emotion = string.lower(string.sub(arg1, FF_EmotionStartPos));
                end
                
                if (FF_Options['AllowEmoteCommand'] == 1) then
                    
                    if (FF_SenderID ~= nil) then
                        
                        FFAuthorised = FFWHISPLOG_YES;
                        
                        if (FF_Emotion ~= nil) then--If the message has a command
                            
                            DoEmote(FF_Emotion);
                            
                        else
                            
                            FF_SendWhisper(FFWHISP_EMOTE_HELP, FF_Sender);--Tell the user how to use the command
                            
                        end
                        
                    else
                        FFAuthorised = FFWHISPLOG_NO;
                    end
                    
                else
                    
                    FF_SendWhisper(FFMSG_EMOTE_COMMAND_DISABLED, FF_Sender);--Tell the command has been disabled in the options
                    FFAuthorised = FFWHISPLOG_NO;
                    
                end
                
                if (FF_Options["EnableLogging"] == 1) then
                    --Log this whisper
                    if (FF_Emotion ~= nil) then
                        LogWhisper(FFWHISP_EMOTE.." "..string.lower(FF_Emotion), FF_Sender, FFAuthorised);
                    else
                        LogWhisper(FFWHISP_EMOTE, FF_Sender, FFAuthorised);
                    end
                    
                end
                FFAuthorised = ""; --Clear the string
                
            end --End: FFWHISP_EMOTE
            
        end --End: if (FF_Sender_Banned == false) then
        
    end --End: if (arg1 and arg2) then

    FF_Sender = FFWHISPLOG_UNKNOWN;
    
end

function FF_ParseAddonMessage(event)

    if (arg1 and arg2 and arg3 and arg4) then --If all the arguments are present
        
        if (arg1 ~= FF_AddonMessagePrefix) then --If the message wasn't from Follow Felankor
            return 0; --Exit the function
        end
        
    --[[#######################################################
        #               Receiving Questions
        #####################################################]]
        
        if (arg2 == "StatusCheck") then
            SendAddonMessage(FF_AddonMessagePrefix, "StatusReply: "..FF_Version.." "..FF_Options['Enabled'], arg3, arg4); --Reply to the message with version and status of Follow Felankor
        end
        
    --[[#######################################################
        #               Receiving Replies
        #####################################################]]
        
        if (string.sub(arg2, 1, 12) == "StatusReply:") then
            
            if (arg3 == "PARTY") then
                
                if (table.getn(FF_PartyUsers) > 0) then
                       
                    local i = 0;
                    
                    --Remove players that are no longer in the group
                    for i=1, table.getn(FF_PartyUsers) do --For each group member in FF_PartyUsers
                        if (UnitInParty(FF_PartyUsers[i][0]) == false) then --If the unit is no longer in the group
                            table.remove(FF_PartyUsers, i) --Remove the unit from the list
                        end
                    end
                    
                    for i = 1, table.getn(FF_PartyUsers) do --For each user in the table
                        
                        if (FF_PartyUsers[i][1] == arg4) then --If the sender is allready in the table
                            return 0; --Exit the function to stop the user being added twice
                        end
                        
                    end
                    
                end
                
                --If the user didn't exist in the table add them
                local FF_newKey = 0;    
                
                if (FF_PartyUsers == nil) then
                    FF_newKey = 1;
                else
                    FF_newKey = (table.getn(FF_PartyUsers) + 1);
                end
                
                table.insert(FF_PartyUsers, FF_newKey, {arg4, string.sub(arg2, 13, (string.len(arg2) - 2)), string.sub(arg2, (string.len(arg2) - 1), string.len(arg2))}); --FF_PartyUsers[x][1] = Username; FF_PartyUsers[x][2] = Version (Format: vX.X.X [X0X00]); FF_PartyUsers[x][3] = Enabled (Format: 1 or 0);
                
                FF_UpdatePartyStatus(); --Update the party status icons
                
            elseif (arg3 == "RAID") then
                
                if (GetNumRaidMembers() > 0) then
                    if (table.getn(FF_RaidUsers) > 0) then
                        
                        local i = 0;
                        
                        --Remove players that are no longer in the raid
                        for i=1, table.getn(FF_RaidUsers) do --For each raid member in FF_RaidUsers
                            if (UnitInRaid(FF_RaidUsers[i][0]) == false) then --If the unit is no longer in the raid
                                table.remove(FF_RaidUsers, i) --Remove the unit from the list
                            end
                        end
                        
                        for i = 1, table.getn(FF_RaidUsers) do --For each user in the table
                            
                            if (FF_RaidUsers[i][1] == arg4) then --If the sender is allready in the table
                                return 0; --Exit the function to stop the user being added twice
                            end
                            
                        end
                        
                    end
                    
                    --If the user didn't exist in the table add them
                    local FF_newKey = 0;    
                    
                    if (FF_RaidUsers == nil) then
                        FF_newKey = 1;
                    else
                        FF_newKey = (table.getn(FF_RaidUsers) + 1);
                    end
                    
                    table.insert(FF_RaidUsers, FF_newKey, {arg4, string.sub(arg2, 13, (string.len(arg2) - 2)), string.sub(arg2, (string.len(arg2) - 1), string.len(arg2))});
                    
                else
                    FF_RaidUsers = {}; --Empty the table because the user is not in a raid
                end
                    
            elseif (arg3 == "GUILD") then
                
                if (GetNumGuildMembers(false) > 0) then --Get number of guild members (false = dont include offline members)
                    
                    if (table.getn(FF_GuildUsers) > 0) then
                        
                        local i = 0;
                        
                        for i = 1, table.getn(FF_GuildUsers) do --For each user in the table
                            
                            if (FF_GuildUsers[i][1] == arg4) then --If the sender is allready in the table
                                return 0; --Exit the function to stop the user being added twice
                            end
                            
                        end
                        
                    end
                    
                    --If the user didn't exist in the table add them
                    local FF_newKey = 0;    
                    
                    if (FF_GuildUsers == nil) then
                        FF_newKey = 1;
                    else
                        FF_newKey = (table.getn(FF_GuildUsers) + 1);
                    end
                        
                    table.insert(FF_GuildUsers, FF_newKey, {arg4, string.sub(arg2, 13, (string.len(arg2) - 2)), string.sub(arg2, (string.len(arg2) - 1), string.len(arg2))});
                    
                else
                    FF_GuildUsers = {}; --Empty the table because the user is not in a guild or there are no guild members online
                end
                
            elseif (arg3 == "WHISPER") then
                
                if (table.getn(FF_Users) > 0) then
                    
                    local i = 0;
                    
                    for i = 1, table.getn(FF_Users) do --For each user in the table
                        
                        if (FF_Users[i][1] == arg4) then --If the sender is allready in the table
                            return 0; --Exit the function to stop the user being added twice
                        end
                        
                    end
                    
                end
                
                --If the user didn't exist in the table add them
                local FF_newKey = 0;    
                
                if (FF_Users == nil) then
                    FF_newKey = 1;
                else
                    FF_newKey = (table.getn(FF_Users) + 1);
                end
                
                table.insert(FF_Users, FF_newKey, {arg4, string.sub(arg2, 13, (string.len(arg2) - 2)), string.sub(arg2, (string.len(arg2) - 1), string.len(arg2))});
                
                
            end
            
        end --End: if (string.sub(arg2, 1, 12) == "StatusReply:") then
        
        if (arg2 == "FollowingYou") then
            FF_LocalMessage(arg4..FFMSG_IS_FOLLOWING_YOU);
        end
        
        if (arg2 == "StoppedFollowingYou") then
            FF_LocalMessage(arg4..FFMSG_STOPPED_FOLLOWING_YOU);
        end
        
    end --End: if (arg1 and arg2 and arg3 and arg4) then

end

function FF_AuthoriseSender(FF_AuthSender, FF_AuthParty, FF_AuthRaid, FF_AuthGuild, FF_AuthFriend)

    if (FF_AuthParty == true) then--If party should be checked
        for i=1, GetNumPartyMembers() do --For every party member
    
            if (UnitName("party"..i) == FF_Sender) then --If the player is in the party
                FF_AuthSender = "party"..i;
                return FF_AuthSender;
            end
        
        end
        
    end
    
    if (FF_AuthRaid == true) then--If raid should be checked
        for i=1, GetNumRaidMembers() do --For every raid member
        
            if (UnitName("raid"..i) == FF_Sender) then --If the player is in the raid
                FF_AuthSender = "raid"..i;
                return FF_AuthSender;
            end
        
        end
        
    end
    
    if (FF_AuthGuild == true) then--If guild should be checked
        
        if (IsInGuild() == 1) then --If the player is in a guild
            
            GuildRoster(); --Update the guild list
            
            for i=1, GetNumGuildMembers() do --for each guild member
    
                FF_GuildMemberName = GetGuildRosterInfo(i); --Get guild member name
                if (FF_GuildMemberName == FF_AuthSender) then --If the player is a guild member
                    return FF_AuthSender;
                end
    
            end
            
        end
        
    end
    
    if (FF_AuthFriend == true) then--If friend should be checked
        ShowFriends(); --Update friend list
        for i=1, GetNumFriends() do
    
            FF_FriendName = GetFriendInfo(i); --Get the names of friends in the friend list
            if (FF_FriendName == FF_AuthSender) then --If the player is a friend
                return FF_AuthSender;
            end
        
        end
        
    end
    
    return nil; --The player was not in the party, raid, guild or friends list
end