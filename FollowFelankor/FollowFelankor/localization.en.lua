--[[############# localization.en.lua ##################
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
    
--NOTE: Sorry but I am unable to provide localization files for any other languages as I don't speak them...

FFMSG_ADDON_NAME = "Follow Felankor";
FFOPTIONSPANELS_TEXT_COLOUR = "|cFFFFFFFF";
FFHELPDIALOG_COMMAND_COLOUR = "|cFF0000FF";
FFHELPDIALOG_DESCRIPTION_COLOUR = "|cFFFFFFFF";
FF_END_COLOUR = "|r";

--[[#########################################
    #           Slash Commands
    #########################################]]

FFSLASH_MENU = "/ff_Menu";
FFSLASH_MENU_ALIAS = "/ff_m";
FFSLASH_MENU_HELP = FFSLASH_MENU.." (Alias: "..FFSLASH_MENU_ALIAS.."): Displays the "..FFMSG_ADDON_NAME.." menu. You can access all of the "..FFMSG_ADDON_NAME.." controls from this menu.";
FFSLASH_MENU_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_MENU.." (Alias: "..FFSLASH_MENU_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Displays the "..FFMSG_ADDON_NAME.." menu. You can access all of the "..FFMSG_ADDON_NAME.." controls from this menu.";

FFSLASH_ENABLE_ADDON = "/ff_Enable";
FFSLASH_ENABLE_ADDON_ALIAS = "/ff_e";
FFSLASH_ENABLE_ADDON_HELP = FFSLASH_ENABLE_ADDON.."(Alias: "..FFSLASH_ENABLE_ADDON_ALIAS.."): Enables "..FFMSG_ADDON_NAME;
FFSLASH_ENABLE_ADDON_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_ENABLE_ADDON.."(Alias: "..FFSLASH_ENABLE_ADDON_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Enables "..FFMSG_ADDON_NAME;

FFSLASH_DISABLE_ADDON = "/ff_Disable";
FFSLASH_DISABLE_ADDON_ALIAS = "/ff_d";
FFSLASH_DISABLE_ADDON_HELP = FFSLASH_DISABLE_ADDON.."(Alias: "..FFSLASH_DISABLE_ADDON_ALIAS.."): Disables "..FFMSG_ADDON_NAME;
FFSLASH_DISABLE_ADDON_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_DISABLE_ADDON.."(Alias: "..FFSLASH_DISABLE_ADDON_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Disables "..FFMSG_ADDON_NAME;

FFSLASH_ADDON_STATUS = "/ff_Status";
FFSLASH_ADDON_STATUS_ALIAS = "/ff_s";
FFSLASH_ADDON_STATUS_HELP = FFSLASH_ADDON_STATUS.."(Alias: "..FFSLASH_ADDON_STATUS_ALIAS.."): Displays the status (enabled or disabled) of "..FFMSG_ADDON_NAME;
FFSLASH_ADDON_STATUS_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_ADDON_STATUS.."(Alias: "..FFSLASH_ADDON_STATUS_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Displays the status (enabled or disabled) of "..FFMSG_ADDON_NAME;

FFSLASH_SHOW_OPTIONS = "/ff_Options";
FFSLASH_SHOW_OPTIONS_ALIAS = "/ff_o";
FFSLASH_SHOW_OPTIONS_HELP = FFSLASH_SHOW_OPTIONS.." (Alias: "..FFSLASH_SHOW_OPTIONS_ALIAS.."): Shows the "..FFMSG_ADDON_NAME.." options dialog.";
FFSLASH_SHOW_OPTIONS_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_SHOW_OPTIONS.." (Alias: "..FFSLASH_SHOW_OPTIONS_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Shows the "..FFMSG_ADDON_NAME.." options dialog.";

FFSLASH_ALLOW_INVITE_REQUESTS = "/ff_AllowInviteRequests";
FFSLASH_ALLOW_INVITE_REQUESTS_ALIAS = "/ff_air";
FFSLASH_ALLOW_INVITE_REQUESTS_USAGE = "Usage: "..FFSLASH_ALLOW_INVITE_REQUESTS.." on/off";
FFSLASH_ALLOW_INVITE_REQUESTS_HELP = FFSLASH_ALLOW_INVITE_REQUESTS.." (Alias: "..FFSLASH_ALLOW_INVITE_REQUESTS_ALIAS.."): Enables and disables allowing invite requests from friends and guild members. "..FFSLASH_ALLOW_INVITE_REQUESTS_USAGE;
FFSLASH_ALLOW_INVITE_REQUESTS_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_ALLOW_INVITE_REQUESTS.." (Alias: "..FFSLASH_ALLOW_INVITE_REQUESTS_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Enables and disables allowing invite requests from friends and guild members. "..FFSLASH_ALLOW_INVITE_REQUESTS_USAGE;

FFSLASH_AUTO_ACCEPT_PARTY = "/ff_AutoAcceptGroup";
FFSLASH_AUTO_ACCEPT_PARTY_ALIAS = "/ff_aag";
FFSLASH_AUTO_ACCEPT_PARTY_USAGE = "Usage: "..FFSLASH_AUTO_ACCEPT_PARTY.." on/off";
FFSLASH_AUTO_ACCEPT_PARTY_HELP = FFSLASH_AUTO_ACCEPT_PARTY.." (Alias: "..FFSLASH_AUTO_ACCEPT_PARTY_ALIAS.."): Enables and disables auto accepting group invite requests from friends and guild members. "..FFSLASH_AUTO_ACCEPT_PARTY_USAGE;
FFSLASH_AUTO_ACCEPT_PARTY_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_AUTO_ACCEPT_PARTY.." (Alias: "..FFSLASH_AUTO_ACCEPT_PARTY_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Enables and disables auto accepting group invite requests from friends and guild members. "..FFSLASH_AUTO_ACCEPT_PARTY_USAGE;

FFSLASH_ACCEPT_RESURRECT = "/ff_AutoAcceptResurrect";
FFSLASH_ACCEPT_RESURRECT_ALIAS = "/ff_aar";
FFSLASH_ACCEPT_RESURRECT_USAGE = "Usage: "..FFSLASH_ACCEPT_RESURRECT.." on/off";
FFSLASH_ACCEPT_RESURRECT_HELP = FFSLASH_ACCEPT_RESURRECT.." (Alias: "..FFSLASH_ACCEPT_RESURRECT_ALIAS.."): Enables and disables auto accepting resurrection requests from friends and guild/group/raid members. "..FFSLASH_ACCEPT_RESURRECT_USAGE;
FFSLASH_ACCEPT_RESURRECT_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_ACCEPT_RESURRECT.." (Alias: "..FFSLASH_ACCEPT_RESURRECT_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Enables and disables auto accepting resurrection requests from friends and guild/group/raid members. "..FFSLASH_ACCEPT_RESURRECT_USAGE;
    
FFSLASH_ALLOW_EMOTE_COMMAND = "/ff_AllowEmoteCommand";
FFSLASH_ALLOW_EMOTE_COMMAND_ALIAS = "/ff_aec";
FFSLASH_ALLOW_EMOTE_COMMAND_USAGE = "Usage: "..FFSLASH_ALLOW_EMOTE_COMMAND.." on/off";
--NOTE: FFSLASH_ALLOW_EMOTE_HELP and FFSLASH_ALLOW_EMOTE_HELPDIALOG have been put under the Whisper Commands section because it needs a variable that hasnt been declared yet.

FFSLASH_CREATE_MACROS = "/ff_CreateMacros";
FFSLASH_CREATE_MACROS_ALIAS = "/ff_cm";
FFSLASH_CREATE_MACROS_HELP = FFSLASH_CREATE_MACROS.." (Alias: "..FFSLASH_CREATE_MACROS_ALIAS.."): Creates a set of macros that can be used to send whisper commands to players that have "..FFMSG_ADDON_NAME.." to save you typing them.";
FFSLASH_CREATE_MACROS_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_CREATE_MACROS.." (Alias: "..FFSLASH_CREATE_MACROS_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Creates a set of macros that can be used to send whisper commands to players that have "..FFMSG_ADDON_NAME.." to save you typing them.";

FFSLASH_BAN_LIST_BAN = "/ff_Ban";
FFSLASH_BAN_LIST_BAN_ALIAS = "/ff_b";
FFSLASH_BAN_LIST_BAN_HELP = FFSLASH_BAN_LIST_BAN.." (Alias: "..FFSLASH_BAN_LIST_BAN_ALIAS.."): Bans a player from commanding you with whisper commands. Usage: "..FFSLASH_BAN_LIST_BAN.." PlayerName";
FFSLASH_BAN_LIST_BAN_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_BAN_LIST_BAN.." (Alias: "..FFSLASH_BAN_LIST_BAN_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Bans a player from commanding you with whisper commands. Usage: "..FFSLASH_BAN_LIST_BAN.." PlayerName";

FFSLASH_BAN_LIST_UNBAN = "/ff_Unban";
FFSLASH_BAN_LIST_UNBAN_ALIAS = "/ff_ub";
FFSLASH_BAN_LIST_UNBAN_HELP = FFSLASH_BAN_LIST_UNBAN.." (Alias: "..FFSLASH_BAN_LIST_UNBAN_ALIAS.."): Unbans a player that is banned from commanding you with whisper commands. Usage: "..FFSLASH_BAN_LIST_UNBAN.." PlayerName";
FFSLASH_BAN_LIST_UNBAN_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_BAN_LIST_UNBAN.." (Alias: "..FFSLASH_BAN_LIST_UNBAN_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Unbans a player that is banned from commanding you with whisper commands. Usage: "..FFSLASH_BAN_LIST_UNBAN.." PlayerName";

FFSLASH_BAN_LIST_SHOW_BANS = "/ff_WhosBanned";
FFSLASH_BAN_LIST_SHOW_BANS_ALIAS = "/ff_wb";
FFSLASH_BAN_LIST_SHOW_BANS_HELP = FFSLASH_BAN_LIST_SHOW_BANS.." (Alias: "..FFSLASH_BAN_LIST_SHOW_BANS_ALIAS.."): Lists all the players that are currently banned from controlling you using whisper commands.";
FFSLASH_BAN_LIST_SHOW_BANS_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_BAN_LIST_SHOW_BANS.." (Alias: "..FFSLASH_BAN_LIST_SHOW_BANS_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Lists all the players that are currently banned from controlling you using whisper commands.";

FFSLASH_ANNOUNCE = "/ff_Announce";
FFSLASH_ANNOUNCE_ALIAS = "/ff_a";
FFSLASH_ANNOUNCE_HELP = FFSLASH_ANNOUNCE.." (Alias: "..FFSLASH_ANNOUNCE_ALIAS.."): Announces to your group or raid that you are using "..FFMSG_ADDON_NAME.." and how they can make you follow them.";
FFSLASH_ANNOUNCE_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_ANNOUNCE.." (Alias: "..FFSLASH_ANNOUNCE_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Announces to your group or raid that you are using "..FFMSG_ADDON_NAME.." and how they can make you follow them.";

FFSLASH_USE_GMOUNT = "/ff_UseGMount";
FFSLASH_USE_GMOUNT_ALIAS = "/ff_ugm";
FFSLASH_USE_GMOUNT_USAGE = "Usage: "..FFSLASH_USE_GMOUNT.." Mount Name to set mount (E.g. "..FFSLASH_USE_GMOUNT.." Mechano Hog). "..FFSLASH_USE_GMOUNT.." clear to clear prefered mount.";
FFSLASH_USE_GMOUNT_HELP = FFSLASH_USE_GMOUNT.." (Alias: "..FFSLASH_USE_GMOUNT_ALIAS.."): Sets which ground mount should be summoned when somebody whispers the ground mount command to you.";
FFSLASH_USE_GMOUNT_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_USE_GMOUNT.." (Alias: "..FFSLASH_USE_GMOUNT_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Sets which ground mount should be summoned when somebody whispers the ground mount command to you.";

FFSLASH_USE_FMOUNT = "/ff_UseFMount";
FFSLASH_USE_FMOUNT_ALIAS = "/ff_ufm";
FFSLASH_USE_FMOUNT_USAGE = "Usage: "..FFSLASH_USE_FMOUNT.." Mount Name to set mount (E.g. "..FFSLASH_USE_FMOUNT.." Swift Green Windrider). "..FFSLASH_USE_FMOUNT.." clear to clear prefered mount.";
FFSLASH_USE_FMOUNT_HELP = FFSLASH_USE_FMOUNT.." (Alias: "..FFSLASH_USE_FMOUNT_ALIAS.."): Sets which flying mount should be summoned when somebody whispers the flying mount command to you.";
FFSLASH_USE_FMOUNT_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_USE_FMOUNT.." (Alias: "..FFSLASH_USE_FMOUNT_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Sets which flying mount should be summoned when somebody whispers the flying mount command to you.";

FFSLASH_CHECK_STATUS = "/ff_CheckStatus";
FFSLASH_CHECK_STATUS_ALIAS = "/ff_cs";
FFSLASH_CHECK_STATUS_USAGE = "Usage: "..FFSLASH_CHECK_STATUS.." Player (E.g. "..FFSLASH_CHECK_STATUS.." Felankor)";
FFSLASH_CHECK_STATUS_HELP = FFSLASH_CHECK_STATUS.." (Alias: "..FFSLASH_CHECK_STATUS_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Checks if a player is using "..FFMSG_ADDON_NAME..". If you do not receive a reply, the player is not using "..FFMSG_ADDON_NAME..".";
FFSLASH_CHECK_STATUS_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_CHECK_STATUS.." (Alias: "..FFSLASH_CHECK_STATUS_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Checks if a player is using "..FFMSG_ADDON_NAME..". If you do not receive a reply, the player is not using "..FFMSG_ADDON_NAME..".";

FFSLASH_SHOW_HELP = "/ff_Help";
FFSLASH_SHOW_HELP_ALIAS = "/ff_h";
FFSLASH_SHOW_HELP_HELP = FFSLASH_SHOW_HELP.." (Alias: "..FFSLASH_SHOW_HELP_ALIAS.."): Lists available commands. Type "..FFSLASH_SHOW_HELP.." command for more information. (E.g. "..FFSLASH_SHOW_HELP.." "..string.sub(FFSLASH_ENABLE_ADDON, 2, string.len(FFSLASH_ENABLE_ADDON))..") NOT "..FFSLASH_SHOW_HELP.." "..FFSLASH_ENABLE_ADDON.." (I.e. No / on the command you need help with)";--If translating ONLY change the parts in quotes(" ")
FFSLASH_SHOW_HELP_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_SHOW_HELP.." (Alias: "..FFSLASH_SHOW_HELP_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Lists available commands. Type "..FFSLASH_SHOW_HELP.." command for more information. (E.g. "..FFSLASH_SHOW_HELP.." "..string.sub(FFSLASH_ENABLE_ADDON, 2, string.len(FFSLASH_ENABLE_ADDON))..") NOT "..FFSLASH_SHOW_HELP.." "..FFSLASH_ENABLE_ADDON.." (I.e. No / on the command you need help with)";--If translating ONLY change the parts in quotes(" ")

--[[#########################################
    #           Whisper Commands
    #########################################]]

FFWHISP_FOLLOW = "!ff_follow";
FFWHISP_FOLLOW_ALIAS = "!ff_f";
FFWHISP_FOLLOW_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_FOLLOW.." (Alias: "..FFWHISP_FOLLOW_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Makes me follow you.";
FFWHISP_FOLLOW_HELP = FFWHISP_FOLLOW.." (Alias: "..FFWHISP_FOLLOW_ALIAS.."): Makes me follow you.";

FFWHISP_INVITE_ME = "!ff_inviteme";
FFWHISP_INVITE_ME_ALIAS = "!ff_im";
FFWHISP_INVITE_ME_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_INVITE_ME.." (Alias: "..FFWHISP_INVITE_ME_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Makes me invite you to my group. (Only works if your on my friend list or in my guild)";
FFWHISP_INVITE_ME_HELP = FFWHISP_INVITE_ME.." (Alias: "..FFWHISP_INVITE_ME_ALIAS.."): Makes me invite you to my group. (Only works if your on my friend list or in my guild)";

FFWHISP_SIT = "!ff_sit";
FFWHISP_SIT_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_SIT..": "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Makes me sit down.";
FFWHISP_SIT_HELP = FFWHISP_SIT..": Makes me sit down.";

FFWHISP_STAND = "!ff_stand";
FFWHISP_STAND_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_STAND..": "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Makes me stand up.";
FFWHISP_STAND_HELP = FFWHISP_STAND..": Makes me stand up.";

FFWHISP_DANCE = "!ff_dance";
FFWHISP_DANCE_ALIAS = "!ff_d";
FFWHISP_DANCE_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_DANCE.." (Alias: "..FFWHISP_DANCE_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Makes me dance.";
FFWHISP_DANCE_HELP = FFWHISP_DANCE.." (Alias: "..FFWHISP_DANCE_ALIAS.."): Makes me dance.";

FFWHISP_EMOTE = "!ff_emote";
FFWHISP_EMOTE_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_EMOTE..": "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Performs the requested emotion. Usage: "..FFWHISP_EMOTE.." emotion (E.g. "..FFWHISP_EMOTE.." wave)";
FFWHISP_EMOTE_HELP = FFWHISP_EMOTE..": Performs the requested emotion. Usage: "..FFWHISP_EMOTE.." emotion (E.g. "..FFWHISP_EMOTE.." wave)";

FFWHISP_CHECK = "!ff_check";
FFWHISP_CHECK_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_CHECK..": "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Used to tell you if a player has "..FFMSG_ADDON_NAME.." installed. Also tells you the version they are using and if it is enabled.";
FFWHISP_CHECK_HELP = FFWHISP_CHECK..": Used to tell you if a player has "..FFMSG_ADDON_NAME.." installed. Also tells you the version they are using and if it is enabled.";

FFWHISP_HELP = "!ff_help";
FFWHISP_HELP_HELP = FFWHISP_HELP..": Displays the help dialog. Type "..FFWHISP_HELP.." command for more information. (E.g. "..FFWHISP_HELP.." "..string.sub(FFWHISP_FOLLOW, 2, string.len(FFWHISP_FOLLOW))..") NOT "..FFWHISP_HELP.." "..FFWHISP_FOLLOW.." (I.e. No ! on the command you need help with)";
FFWHISP_HELP_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_HELP..": "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Whispers help to you. Type "..FFWHISP_HELP.." command for more information. (E.g. "..FFWHISP_HELP.." "..string.sub(FFWHISP_FOLLOW, 2, string.len(FFWHISP_FOLLOW))..") NOT "..FFWHISP_HELP.." "..FFWHISP_FOLLOW.." (I.e. No ! on the command you need help with)";

FFWHISP_MOUNTGROUND = "!ff_mount";
FFWHISP_MOUNTGROUND_ALIAS = "!ff_m";
FFWHISP_MOUNTGROUND_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_MOUNTGROUND.." (Alias: "..FFWHISP_MOUNTGROUND_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Makes you use a ground mount. (If you have set which ground mount should be used using "..FFSLASH_USE_GMOUNT.." that mount will be used first. If not, a random level 40 mount will be used if available, otherwise a random level 20 mount will be used.)";
FFWHISP_MOUNTGROUND_HELP = FFWHISP_MOUNTGROUND.." (Alias: "..FFWHISP_MOUNTGROUND_ALIAS.."): Makes me use a ground mount. (If I have set a prefered ground mount, that will be used first. If not, a random level 40 mount will be used if available, otherwise a random level 20 mount will be used.)";

FFWHISP_MOUNTRGROUND = "!ff_Rmount";
FFWHISP_MOUNTRGROUND_ALIAS = "!ff_rm";
FFWHISP_MOUNTRGROUND_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_MOUNTRGROUND.." (Alias: "..FFWHISP_MOUNTRGROUND_ALIAS.."): "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Makes me use a random ground mount.";
FFWHISP_MOUNTRGROUND_HELP = FFWHISP_MOUNTRGROUND.." (Alias: "..FFWHISP_MOUNTGROUND_ALIAS.."): Makes me use a random ground mount.";

FFWHISP_MOUNTFLYING = "!ff_fly";
FFWHISP_MOUNTFLYING_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_MOUNTFLYING..": "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Makes you use a flying mount. (If you have set which flying mount should be used using "..FFSLASH_USE_FMOUNT.." that mount will be used first. If not, a random level 40 mount will be used if available, otherwise a random level 20 mount will be used.)";
FFWHISP_MOUNTFLYING_HELP = FFWHISP_MOUNTFLYING..": Makes me use a flying mount. (If I have set a prefered flying mount, that will be used first. If not, a random level 40 mount will be used if available, otherwise a random level 20 mount will be used.)";

FFWHISP_MOUNTRFLYING = "!ff_Rfly";
FFWHISP_MOUNTRFLYING_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFWHISP_MOUNTRFLYING..": "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Makes me use a random flying mount.";
FFWHISP_MOUNTRFLYING_HELP = FFWHISP_MOUNTRFLYING..": Makes me use a random flying mount.";

--[[#########################################
    #       Slash Commands Continued
    #########################################]]
--[[ NOTE: These FFSLASH variables have been put here because they need variables from the Whisper Commands section ]]
FFSLASH_ALLOW_EMOTE_COMMAND_HELP = FFSLASH_ALLOW_EMOTE_COMMAND..": Enables and disables use of the "..FFWHISP_EMOTE.." whisper command. "..FFSLASH_ALLOW_EMOTE_COMMAND_USAGE;
FFSLASH_ALLOW_EMOTE_COMMAND_HELPDIALOG = FFHELPDIALOG_COMMAND_COLOUR..FFSLASH_ALLOW_EMOTE_COMMAND..": "..FFHELPDIALOG_DESCRIPTION_COLOUR.."Enables and disables use of the "..FFWHISP_EMOTE.." whisper command. "..FFSLASH_ALLOW_EMOTE_COMMAND_USAGE;

--[[#########################################
    #           Full Messages
    #########################################]]

FFMSG_AFK = "I am AFK send tell/whisper saying !ff_follow to make me follow you.";

FFMSG_ATTEMPTING_FOLLOW = "Attempting to follow you.";
FFMSG_COME_CLOSER = "You need to come closer.";
FFMSG_CANT_FOLLOW = "I can't follow you. Your not in my group/raid.";
FFMSG_TOO_BUSY_TO_FOLLOW = "Sorry, I can't follow you right now because I'm busy. (E.g. Using NPC, auction house or looting)";

FFMSG_AUTO_INVITES_OFF = "Sorry I can't invite you, auto invites is disabled.";
FFMSG_NOT_FRIEND_GUILD = "Sorry I can't invite you, your not on my friends list or in my guild.";
FFMSG_DONT_KNOW_YOU = "Sorry you can't command me because I don't know you.";

FFMSG_PARTY_AUTO_ACCEPTED = "Your group invite was automatically accepted by "..FFMSG_ADDON_NAME;
FFMSG_RAID_AUTO_ACCEPTED =  "Your raid invite was automatically accepted by "..FFMSG_ADDON_NAME;

FFMSG_NOT_PARTY_LEADER = "Sorry I'm not the group leader.";
FFMSG_REQUESTING_INVITE_FOR_YOU = "An automatic request has been sent to the party asking if you can be invited.";
FFMSG_ALLREADY_IN_PARTY = "You are allready in my group.";

FFMSG_THANK_YOU = "Thank you.";

FFMSG_EMOTE_COMMAND_DISABLED = "Sorry "..FFWHISP_EMOTE.." is disabled.";

FFMSG_MACROS_CREATED = FFMSG_ADDON_NAME.." macros created.";

FFMSG_FOLLOWING_PLAYERS_BANNED = "The following players are banned from commanding you:";
FFMSG_NO_BANNED_PLAYERS = "There are no players banned from commanding you.";

FFMSG_HELP_AVAILABLE_COMMANDS = "Available commands are: ";

FFMSG_HELP_MORE_INFO = "Whisper or tell "..FFWHISP_HELP.." command for more information. (E.g. "..FFWHISP_HELP.." "..string.sub(FFWHISP_FOLLOW, 2, string.len(FFWHISP_FOLLOW))..") NOT "..FFWHISP_HELP.." "..FFWHISP_FOLLOW.." (I.e. No ! on the command you need help with)";--If translating ONLY change the parts in quotes(" ")

FFMSG_ALLOWING_INVITE_REQUESTS = FFMSG_ADDON_NAME.." is now allowing invite requests (!ff_inviteme) from friends and guild members.";
FFMSG_BLOCKING_INVITE_REQUESTS = FFMSG_ADDON_NAME.." is now blocking invite requests (!ff_inviteme) from friends and guild members.";

FFMSG_ALLOWING_AUTO_ACCEPT_PARTY = "Auto accept group invites is now on. (Only accepts group invites from guild members and friends)";
FFMSG_BLOCKING_AUTO_ACCEPT_PARTY = "Auto accept group invites is now off.";

FFMSG_ALLOWING_AUTO_ACCEPT_RESURRECT = "Auto accept resurrect is now on. (Only accepts resurrect from guild, group or raid members and friends)";
FFMSG_BLOCKING_AUTO_ACCEPT_RESURRECT = "Auto accept resurrect is now off.";

FFMSG_ALLOWING_EMOTE_COMMAND = FFMSG_ADDON_NAME.." is now allowing the emote command (!ff_emote) from friends and guild members.";
FFMSG_BLOCKING_EMOTE_COMMAND = FFMSG_ADDON_NAME.." is now blocking the emote command (!ff_emote) from friends and guild members.";

FFMSG_SLASH_HELP_MORE_INFO = "Type "..FFSLASH_SHOW_HELP.." command for more information. (E.g. "..FFSLASH_SHOW_HELP.." "..string.sub(FFSLASH_ENABLE_ADDON, 2, string.len(FFSLASH_ENABLE_ADDON))..") NOT "..FFSLASH_SHOW_HELP.." "..FFSLASH_ENABLE_ADDON.." (I.e. No / on the command you need help with)";--If translating ONLY change the parts in quotes(" ")

FFMSG_ADDON_STARTUP_HELP1 = "Type "..FFSLASH_SHOW_OPTIONS.." to display the "..FFMSG_ADDON_NAME.." options dialog";
FFMSG_ADDON_STARTUP_HELP2 = "Type "..FFSLASH_SHOW_HELP.." for help with using "..FFMSG_ADDON_NAME;

FFMSG_ANNOUNCEMENT = "Im using "..FFMSG_ADDON_NAME..". If I go AFK whisper/tell "..FFWHISP_FOLLOW.." to make me follow you or "..FFWHISP_HELP.." for more commands.";

FFMSG_ATTEMPTING_MOUNT = "Attempting to mount/dismount.";
FFMSG_NOMOUNTS = "Sorry no supported mounts were found.";
FFMSG_FLYING = "I must land first.";
FFMSG_CANT_FLY_HERE = "I can't fly here.";
FFMSG_GMOUNT_CLEARED = "Your prefered ground mount has been cleared. A random ground mount will now be used instead.";
FFMSG_FMOUNT_CLEARED = "Your prefered flying mount has been cleared. A random flying mount will now be used instead.";

--[[#########################################
    #           Partial Messages
    #########################################]]
FFMSG_ADDON_LOADED = " Loaded";
FFMSG_ADDON_ENABLED = " Enabled";
FFMSG_ADDON_DISABLED = " Disabled";

FFMSG_ENABLED = " is Enabled";
FFMSG_DISABLED = " is Disabled";

FFMSG_HELP_UNKOWN_COMAND = "Unkown command: ";
FFMSG_SLASH_COMMAND_UNKOWN = "Unknown Command: ";

FFMSG_FOLLOWING = "Following ";
FFMSG_STOPPED_FOLLOWING = "Stopped following ";
FFMSG_IS_FOLLOWING_YOU = " is following you.";
FFMSG_STOPPED_FOLLOWING_YOU = " stopped following you.";

FFMSG_AUTO_INVITED = " was auto invited to the group/raid upon his request by "..FFMSG_ADDON_NAME.." because he is in my friends list or guild.";
FFMSG_PLEASE_INVITE_FRIEND_TO_GROUP = "Automatic Request: A friend/guild member has asked me if they can join the group. If it's ok, could the group leader please invite ";

FFMSG_RESURRECT_AUTO_ACCEPTED = "Automatically accepted resurrect from ";

FFMSG_PLAYER_BANNED = " has been banned from commanding you.";
FFMSG_PLAYER_UNBANNED = " has been unbanned and is now able to command you.";
FFMSG_PLAYER_WASNT_BANNED = " couldn't be banned from commanding you. Please try again.";
FFMSG_PLAYER_ALLREADY_BANNED = " is allready banned from commanding you.";

FFMSG_STATIC_GMOUNT_SET = "Static ground mount set to: ";
FFMSG_STATIC_GMOUNT_NOT_FOUND = "You do not have this mount: ";
FFMSG_STATIC_FMOUNT_SET = "Static flying mount set to: ";
FFMSG_STATIC_FMOUNT_NOT_FOUND = "You do not have this mount: ";

FFMSG_USING_NEWER_VERSION_START = " is using a newer version of "..FFMSG_ADDON_NAME.." (v";
FFMSG_USING_NEWER_VERSION_END = "). You can download the latest version at www.wowinterface.com";

FFMSG_CHECKING_STATUS_START = "Checking if ";
FFMSG_CHECKING_STATUS_STOP = " is using "..FFMSG_ADDON_NAME..". If you do NOT receive a reply, the player is NOT using Follow Felankor. Try it on yourself if you are confused.";
FFMSG_STATUS_REPLY_PART1 = " is using version ";
FFMSG_STATUS_REPLY_PART2 = " of "..FFMSG_ADDON_NAME.." and it";
FFMSG_STATUS_CHECK_REQUESTED = " requested a "..FFMSG_ADDON_NAME.." status check using the "..FFSLASH_CHECK_STATUS.." command.";

--[[#########################################
    #           FFMenu Frame
    #########################################]]
FFMENU_TITLE = FFMSG_ADDON_NAME;
FFMENU_CANCEL_BUTTON = "Cancel";
FFMENU_OPTIONS_BUTTON = "Options";
FFMENU_BAN_LIST_BUTTON = "Ban List";
FFMENU_LOG_BUTTON = "Whisper Log";
FFMENU_MACROS_BUTTON = "Create Macros";
FFMENU_HELP_BUTTON = "Help";

--[[#########################################
    #           Minimap Button
    #########################################]]
    
FFMINIMAP_TOOLTIP_LEFT1 = "Open "..FFMSG_ADDON_NAME.." Menu";
FFMINIMAP_TOOLTIP_RIGHT1 = "Left-Click";
FFMINIMAP_TOOLTIP_LEFT2 = "Move Button";
FFMINIMAP_TOOLTIP_RIGHT2 = "Right-Click + Drag";

--[[#########################################
    #          FF Unit Popup Menu
    #########################################]]
    
FFUPM_FOLLOW = "Follow Me";
FFUPM_INVITEME = "Invite Me";
FFUPM_SIT = "Sit";
FFUPM_STAND = "Stand";
FFUPM_CHECK = "Check for addon";
    
--[[#########################################
    #          FFOptions Panels
    #########################################]]
    
FFOPTIONS_ANNOUNCEMENTS_PANEL = "Announcements";
FFOPTIONS_TIP1 = FFOPTIONSPANELS_TEXT_COLOUR.."Tip 1: Put the mouse over the check boxes to see a description\nof each option."..FF_END_COLOUR;
FFOPTIONS_TIP2 = FFOPTIONSPANELS_TEXT_COLOUR.."Tip 2: Click the small + next to "..FFMSG_ADDON_NAME.." in the\nlist on the left for more options."..FF_END_COLOUR;

--Options panel
FFOPTIONS_ENABLE_ADDON = FFOPTIONSPANELS_TEXT_COLOUR.."Enable "..FFMSG_ADDON_NAME..FF_END_COLOUR;
FFOPTIONS_ENABLE_ADDON_TOOLTIP = "Enables "..FFMSG_ADDON_NAME;
FFOPTIONS_ALLOW_INVITE_REQUESTS = FFOPTIONSPANELS_TEXT_COLOUR.."Enable Invite Requests"..FF_END_COLOUR;
FFOPTIONS_ALLOW_INVITE_REQUESTS_TOOLTIP = "Enables use of the "..FFWHISP_INVITE_ME.." whisper command. (From: Guild, Friends)";
FFOPTIONS_AUTO_ACCEPT_PARTY = FFOPTIONSPANELS_TEXT_COLOUR.."Enable Auto Accept Group Invites"..FF_END_COLOUR;
FFOPTIONS_AUTO_ACCEPT_PARTY_TOOLTIP = "Enables auto accept group invites.  (From: Guild, Friends)";
FFOPTIONS_AUTO_ACCEPT_RESURRECT = FFOPTIONSPANELS_TEXT_COLOUR.."Enable Auto Accept Resurrect"..FF_END_COLOUR;
FFOPTIONS_AUTO_ACCEPT_RESURRECT_TOOLTIP = "Enables auto accept resurrect. (From: Group, Raid, Guild, Friends)";
FFOPTIONS_PREVENT_FOLLOW_WHEN_BUSY = FFOPTIONSPANELS_TEXT_COLOUR.."Prevent Auto Follow When Busy"..FF_END_COLOUR;
FFOPTIONS_PREVENT_FOLLOW_WHEN_BUSY_TOOLTIP = "Prevents somebody using the "..FFWHISP_FOLLOW.." command on you when you are busy.\n(E.g. looting, using auction house or bank etc)";
FFOPTIONS_PARTY_STATUS_ICONS = FFOPTIONSPANELS_TEXT_COLOUR.."Show Party Status Icons"..FF_END_COLOUR;
FFOPTIONS_PARTY_STATUS_ICONS_TOOLTIP = "Places a small blue icon on the group/party portraits of players in your\ngroup/party who are using "..FFMSG_ADDON_NAME..".";
FFOPTIONS_ENABLE_MINIMAP_BUTTON = FFOPTIONSPANELS_TEXT_COLOUR.."Enable MiniMap Button"..FF_END_COLOUR;
FFOPTIONS_ENABLE_MINIMAP_BUTTON_TOOLTIP = "Enables the "..FFMSG_ADDON_NAME.." MiniMap button.";
FFOPTIONS_ALLOW_EMOTE_COMMAND = FFOPTIONSPANELS_TEXT_COLOUR.."Enable Emote Command"..FF_END_COLOUR;
FFOPTIONS_ALLOW_EMOTE_COMMAND_TOOLTIP = "Enables use of the "..FFWHISP_EMOTE.." whisper command. (From: Guild, Friends)";
FFOPTIONS_ENABLE_LOGGING = FFOPTIONSPANELS_TEXT_COLOUR.."Enable Whisper Command Logging"..FF_END_COLOUR;
FFOPTIONS_ENABLE_LOGGING_TOOLTIP = "Logs when somebody sends you a whisper command.\nYou can access the log viewer from the "..FFMSG_ADDON_NAME.." menu.";

--Announcements panel
FFOPTIONS_ENABLE_ALL_ANNOUNCEMENTS = FFOPTIONSPANELS_TEXT_COLOUR.."Enable Announcements"..FF_END_COLOUR;
FFOPTIONS_ENABLE_ALL_ANNOUNCEMENTS_TOOLTIP = "Checked: Enables ticked announcements. Unchecked: Disables ALL announcements.";
FFOPTIONS_ENABLE_ANNOUNCE_FSTART = FFOPTIONSPANELS_TEXT_COLOUR.."Enable \"Started following\" announcements"..FF_END_COLOUR;
FFOPTIONS_ENABLE_ANNOUNCE_FSTART_TOOLTIP = "Announces when someone makes you follow them by using the follow whisper command.";
FFOPTIONS_ENABLE_ANNOUNCE_FSTOP = FFOPTIONSPANELS_TEXT_COLOUR.."Enable \"Stopped following\" announcements"..FF_END_COLOUR;
FFOPTIONS_ENABLE_ANNOUNCE_FSTOP_TOOLTIP = "Announces when you stop following someone. Useful if you get stuck on something.";
FFOPTIONS_ENABLE_ANNOUNCE_AFK = FFOPTIONSPANELS_TEXT_COLOUR.."Enable AFK Announcement"..FF_END_COLOUR;
FFOPTIONS_ENABLE_ANNOUNCE_AFK_TOOLTIP = "Announces when you go AFK and tells party/raid members how to make you follow them.";
FFOPTIONS_ENABLE_ANNOUNCE_RES = FFOPTIONSPANELS_TEXT_COLOUR.."Enable Announcing Auto Resurrection Accepts"..FF_END_COLOUR;
FFOPTIONS_ENABLE_ANNOUNCE_RES_TOOLTIP = "Announces when "..FFMSG_ADDON_NAME.." automaticaly accepts a resurrection request.";
FFOPTIONS_ENABLE_ANNOUNCE_AUTO_INVITE = FFOPTIONSPANELS_TEXT_COLOUR.."Enable Announcing Auto Group/Party Invites"..FF_END_COLOUR;
FFOPTIONS_ENABLE_ANNOUNCE_AUTO_INVITE_TOOLTIP = "Announces when "..FFMSG_ADDON_NAME.." automaticaly invites a friend or guild member\nto the group/party because they requested it with a whipser command.";
FFOPTIONS_ENABLE_ANNOUNCE_INVITE_REQUESTED = FFOPTIONSPANELS_TEXT_COLOUR.."Enable Announcing a Group/Party Invite Request"..FF_END_COLOUR;
FFOPTIONS_ENABLE_ANNOUNCE_INVITE_REQUESTED_TOOLTIP = "Announces when a friend/guild member has requested to join the group/party using the "..FFWHISP_INVITE_ME.." whisper command\nand asks the group/party leader to invite them. NOTE: This only happens if you are NOT the group/party leader.";
FFOPTIONS_ENABLE_STATUS_CHECK_NOTIFICATION = FFOPTIONSPANELS_TEXT_COLOUR.."Notify me when somebody requests a status check."..FF_END_COLOUR;
FFOPTIONS_ENABLE_STATUS_CHECK_NOTIFICATION_TOOLTIP = "Notifies you when somebody uses the "..FFSLASH_CHECK_STATUS.." command on you.";

--[[#########################################
    #        FFWhisperLog Dialog
    #########################################]]

FFWHISPLOG_YES = "Yes";
FFWHISPLOG_NO = "No";
FFWHISPLOG_PARTY_INVITE = "(Group Invite)";
FFWHISPLOG_RESURRECT_REQUEST = "(Resurrect Request)";
FFWHISPLOG_UNKNOWN = "(Unknown)";

FFWHISPLOG_DATE_HEADER = "Date";
FFWHISPLOG_COMMAND_HEADER = "Command or Event";
FFWHISPLOG_NAME_HEADER = "Sender";
FFWHISPLOG_AUTHORISED_HEADER = "Auth";

FFWHISPLOG_DATE_SORT_ASC = "Date (New-Old)";
FFWHISPLOG_DATE_SORT_DESC = "Date (Old-New)";
FFWHISPLOG_COMMAND_SORT_ASC = "Command (Z-A)";
FFWHISPLOG_COMMAND_SORT_DESC = "Command (A-Z)";
FFWHISPLOG_NAME_SORT_ASC = "Sender (Z-A)";
FFWHISPLOG_NAME_SORT_DESC = "Sender (A-Z)";
FFWHISPLOG_AUTHORISED_SORT_ASC = "Authorised (Z-A)";
FFWHISPLOG_AUTHORISED_SORT_DESC = "Authorised (A-Z)";

FFWHISPLOG_SORTED_BY_LABEL = "Currently sorted by:";

FFWHISPLOG_TITLE = FFMSG_ADDON_NAME.." Whisper Command Log";
FFWHISPLOG_OK_BUTTON = "OK";
FFWHISPLOG_CLEAR_LOG = "Clear Log";

--[[#########################################
    #          FFHelp Dialog
    #########################################]]
    
FFHELPDIALOG_TITLE = FFMSG_ADDON_NAME.." Help";
FFHELPDIALOG_OK = "OK";
FFHELPDIALOG_SLASHHELP = "Slash Command Help";
FFHELPDIALOG_SLASH_DESCRIPTION = FFHELPDIALOG_DESCRIPTION_COLOUR.."Click a command for help."..FF_END_COLOUR;
FFHELPDIALOG_WHISPERHELP = "Whisper Command Help (The following commands must be sent to you in a whisper from your friends/guild)";
FFHELPDIALOG_WHISPER_DESCRIPTION = FFHELPDIALOG_DESCRIPTION_COLOUR.."Click a whisper command for help."..FF_END_COLOUR;

--[[#########################################
    #          FFBanList Dialog
    #########################################]]

FFBANLIST_TITLE = FFMSG_ADDON_NAME.." Ban List";
FFBANLIST_OK = "OK";
FFBANLIST_LABEL = "Banned Players";
FFBAN_LABEL = "Ban:";
FFBANLIST_BAN = "Ban";
FFBANLIST_UNBAN_ALL = "Unban All";
FFBANLIST_UNBAN = "Unban Selected";
FFBANLIST_SORT_ASC = "Sort (Z-A)"; --The message to display on the sort button IF the current order is A-Z
FFBANLIST_SORT_DESC = "Sort (A-Z)"; --The message to display on the sort button IF the current order is Z-A
FFBANLIST_ASC = "(A-Z)";
FFBANLIST_DESC = "(Z-A)";

--[[#########################################
    #            Macro Names
    #########################################]]
FFMACRO_FOLLOW_NAME = "Follow [FF]";
FFMACRO_SIT_NAME = "Sit [FF]";
FFMACRO_STAND_NAME = "Stand [FF]";
FFMACRO_INVITE_ME_NAME = "Invite Me [FF]";
FFMACRO_DANCE_NAME = "Dance [FF]";
FFMACRO_MOUNT_GROUND = "Ground Mount [FF]";
FFMACRO_MOUNT_FLYING = "Flying Mount [FF]";

--[[#########################################
    #         Mount Search Strings
    #########################################]]
FFMOUNTS_FLYING_SEARCH1 = "Outland";
FFMOUNTS_FLYING_SEARCH2 = "Northrend";
FFMOUNTS_FAST_FLYING_SEARCH = "fast mount";
FFMOUNTS_SWIMMING_SEARCH = "swimmer";
FFMOUNTS_FAST_GROUND_SEARCH = "fast mount";
FFMOUNTS_FLY_AND_GROUND_SEARCH = "changes depending on your Riding skill and location"; --E.g. Celestial Steed

--[[#########################################
    #             Help Tables
    #########################################]]

    --[[--------------------------------------------------------------------
    FFWHISP_HELP_TABLE is used for matching against the argument on the FFWHISP_HELP command. (so that help can be provided for aliases)
    FFWHISP_COMMAND_LIST is used for displaying available commands when FFWHISP_HELP is sent with no argument.
    FF_HELP_DESCRIPTIONS_TABLE is used to give the help description for commands when FFWHISP_HELP is sent with an argument.
    ------------------------------------------------------------------------]]
    
--NOTE: Include Aliases in this list
FFWHISP_HELP_TABLE = {
    FFWHISP_FOLLOW,
    FFWHISP_FOLLOW_ALIAS,
    FFWHISP_INVITE_ME,
    FFWHISP_INVITE_ME_ALIAS,
    FFWHISP_MOUNTGROUND,
    FFWHISP_MOUNTGROUND_ALIAS,
    FFWHISP_MOUNTFLYING,
    FFWHISP_MOUNTFLYING_ALIAS,
    FFWHISP_MOUNTRGROUND,
    FFWHISP_MOUNTRGROUND_ALIAS,
    FFWHISP_MOUNTRFLYING,
    FFWHISP_MOUNTRFLYING_ALIAS,
    FFWHISP_SIT,
    FFWHISP_STAND,
    FFWHISP_DANCE,
    FFWHISP_DANCE_ALIAS,
    FFWHISP_EMOTE,
    FFWHISP_CHECK,
    FFWHISP_HELP
}

--NOTE: DONT include aliases in this table
FFWHISP_COMMAND_LIST = {
    FFWHISP_FOLLOW,
    FFWHISP_INVITE_ME,
    FFWHISP_MOUNTGROUND,
    FFWHISP_MOUNTFLYING,
    FFWHISP_MOUNTRGROUND,
    FFWHISP_MOUNTRFLYING,
    FFWHISP_SIT,
    FFWHISP_STAND,
    FFWHISP_DANCE,
    FFWHISP_EMOTE,
    FFWHISP_CHECK,
    FFWHISP_HELP
}

--NOTE: This should contain the FFWHISP_......._HELPDIALOG for every whisper command
FFHELPDIALOG_WHISPER_HELP = {
    FFWHISP_FOLLOW_HELPDIALOG,
    FFWHISP_INVITE_ME_HELPDIALOG,
    FFWHISP_MOUNTGROUND_HELPDIALOG,
    FFWHISP_MOUNTFLYING_HELPDIALOG,
    FFWHISP_MOUNTRGROUND_HELPDIALOG,
    FFWHISP_MOUNTRFLYING_HELPDIALOG,
    FFWHISP_SIT_HELPDIALOG,
    FFWHISP_STAND_HELPDIALOG,
    FFWHISP_DANCE_HELPDIALOG,
    FFWHISP_EMOTE_HELPDIALOG,
    FFWHISP_CHECK_HELPDIALOG,
    FFWHISP_HELP_HELPDIALOG
}


--NOTE: in the next table, if a command has an alias repeat the help variable twice
FF_HELP_DESCRIPTIONS_TABLE = {
    FFWHISP_FOLLOW_HELP,
    FFWHISP_FOLLOW_HELP,
    FFWHISP_INVITE_ME_HELP,
    FFWHISP_INVITE_ME_HELP,
    FFWHISP_MOUNTGROUND_HELP,
    FFWHISP_MOUNTGROUND_HELP,
    FFWHISP_MOUNTFLYING_HELP,
    FFWHISP_MOUNTFLYING_HELP,
    FFWHISP_MOUNTRGROUND_HELP,
    FFWHISP_MOUNTRGROUND_HELP,
    FFWHISP_MOUNTRFLYING_HELP,
    FFWHISP_SIT_HELP,
    FFWHISP_STAND_HELP,
    FFWHISP_DANCE_HELP,
    FFWHISP_DANCE_HELP,
    FFWHISP_EMOTE_HELP,
    FFWHISP_CHECK_HELP,
    FFWHISP_HELP_HELP
}

    --[[--------------------------------------------------------------------
    FFSLASH_HELP_TABLE is used for matching against the argument on the FFSLASH_HELP command. (so that help can be provided for aliases)
    FFSLASH_HELP_LIST_COMMANDS_TABLE is used for displaying available commands when FFSLASH_HELP is sent with no argument.
    FFSLASH_HELP_DESCRIPTIONS_TABLE is used to give the help description for commands when FFSLASH_HELP is sent with an argument.
    ------------------------------------------------------------------------]]
    
--NOTE: Include Aliases in this list
FFSLASH_HELP_TABLE = {
    FFSLASH_MENU,
    FFSLASH_MENU_ALIAS,
    FFSLASH_SHOW_OPTIONS,
    FFSLASH_SHOW_OPTIONS_ALIAS,
    FFSLASH_ENABLE_ADDON,
    FFSLASH_ENABLE_ADDON_ALIAS,
    FFSLASH_DISABLE_ADDON,
    FFSLASH_DISABLE_ADDON_ALIAS,
    FFSLASH_ADDON_STATUS,
    FFSLASH_ADDON_STATUS_ALIAS,
    FFSLASH_ALLOW_INVITE_REQUESTS,
    FFSLASH_ALLOW_INVITE_REQUESTS_ALIAS,
    FFSLASH_AUTO_ACCEPT_PARTY,
    FFSLASH_AUTO_ACCEPT_PARTY_ALIAS,
    FFSLASH_ACCEPT_RESURRECT,
    FFSLASH_ACCEPT_RESURRECT_ALIAS,
    FFSLASH_ALLOW_EMOTE_COMMAND,
    FFSLASH_ALLOW_EMOTE_COMMAND_ALIAS,
    FFSLASH_BAN_LIST_BAN,
    FFSLASH_BAN_LIST_BAN_ALIAS,
    FFSLASH_BAN_LIST_UNBAN,
    FFSLASH_BAN_LIST_UNBAN_ALIAS,
    FFSLASH_BAN_LIST_SHOW_BANS,
    FFSLASH_BAN_LIST_SHOW_BANS_ALIAS,
    FFSLASH_USE_GMOUNT,
    FFSLASH_USE_GMOUNT_ALIAS,
    FFSLASH_USE_FMOUNT,
    FFSLASH_USE_FMOUNT_ALIAS,
    FFSLASH_CREATE_MACROS,
    FFSLASH_CREATE_MACROS_ALIAS,
    FFSLASH_ANNOUNCE,
    FFSLASH_ANNOUNCE_ALIAS,
    FFSLASH_CHECK_STATUS,
    FFSLASH_CHECK_STATUS_ALIAS,
    FFSLASH_SHOW_HELP,
    FFSLASH_SHOW_HELP_ALIAS
}

--NOTE: DONT include aliases in this table
FFSLASH_HELP_LIST_COMMANDS_TABLE = {
    FFSLASH_MENU,
    FFSLASH_SHOW_OPTIONS,
    FFSLASH_ENABLE_ADDON,
    FFSLASH_DISABLE_ADDON,
    FFSLASH_ADDON_STATUS,
    FFSLASH_ALLOW_INVITE_REQUESTS,
    FFSLASH_AUTO_ACCEPT_PARTY,
    FFSLASH_ACCEPT_RESURRECT,
    FFSLASH_ALLOW_EMOTE_COMMAND,
    FFSLASH_BAN_LIST_BAN,
    FFSLASH_BAN_LIST_UNBAN,
    FFSLASH_BAN_LIST_SHOW_BANS,
    FFSLASH_USE_GMOUNT,
    FFSLASH_USE_FMOUNT,
    FFSLASH_CREATE_MACROS,
    FFSLASH_ANNOUNCE,
    FFSLASH_CHECK_STATUS,
    FFSLASH_SHOW_HELP
}

--NOTE: This should contain the FFSLASH_......._HELPDIALOG for every slash command
FFHELPDIALOG_SLASH_COMMAND_HELP = {
    FFSLASH_MENU_HELPDIALOG,
    FFSLASH_SHOW_OPTIONS_HELPDIALOG,
    FFSLASH_ENABLE_ADDON_HELPDIALOG,
    FFSLASH_DISABLE_ADDON_HELPDIALOG,
    FFSLASH_ADDON_STATUS_HELPDIALOG,
    FFSLASH_ALLOW_INVITE_REQUESTS_HELPDIALOG,
    FFSLASH_AUTO_ACCEPT_PARTY_HELPDIALOG,
    FFSLASH_ACCEPT_RESURRECT_HELPDIALOG,
    FFSLASH_ALLOW_EMOTE_COMMAND_HELPDIALOG,
    FFSLASH_BAN_LIST_BAN_HELPDIALOG,
    FFSLASH_BAN_LIST_UNBAN_HELPDIALOG,
    FFSLASH_BAN_LIST_SHOW_BANS_HELPDIALOG,
    FFSLASH_USE_GMOUNT_HELPDIALOG,
    FFSLASH_USE_FMOUNT_HELPDIALOG,
    FFSLASH_CREATE_MACROS_HELPDIALOG,
    FFSLASH_ANNOUNCE_HELPDIALOG,
    FFSLASH_CHECK_STATUS_HELPDIALOG,
    FFSLASH_SHOW_HELP_HELPDIALOG
}

--NOTE: in the next table, if a command has an alias repeat the help variable twice
FFSLASH_HELP_DESCRIPTIONS_TABLE = {
    FFSLASH_MENU_HELP,
    FFSLASH_MENU_HELP,
    FFSLASH_SHOW_OPTIONS_HELP,
    FFSLASH_SHOW_OPTIONS_HELP,
    FFSLASH_ENABLE_ADDON_HELP,
    FFSLASH_ENABLE_ADDON_HELP,
    FFSLASH_DISABLE_ADDON_HELP,
    FFSLASH_DISABLE_ADDON_HELP,
    FFSLASH_ADDON_STATUS_HELP,
    FFSLASH_ADDON_STATUS_HELP,
    FFSLASH_ALLOW_INVITE_REQUESTS_HELP,
    FFSLASH_ALLOW_INVITE_REQUESTS_HELP,
    FFSLASH_AUTO_ACCEPT_PARTY_HELP,
    FFSLASH_AUTO_ACCEPT_PARTY_HELP,
    FFSLASH_ACCEPT_RESURRECT_HELP,
    FFSLASH_ACCEPT_RESURRECT_HELP,
    FFSLASH_ALLOW_EMOTE_COMMAND_HELP,
    FFSLASH_ALLOW_EMOTE_COMMAND_HELP,
    FFSLASH_BAN_LIST_BAN_HELP,
    FFSLASH_BAN_LIST_BAN_HELP,
    FFSLASH_BAN_LIST_UNBAN_HELP,
    FFSLASH_BAN_LIST_UNBAN_HELP,
    FFSLASH_BAN_LIST_SHOW_BANS_HELP,
    FFSLASH_BAN_LIST_SHOW_BANS_HELP,
    FFSLASH_USE_GMOUNT,
    FFSLASH_USE_GMOUNT,
    FFSLASH_USE_FMOUNT,
    FFSLASH_USE_FMOUNT,
    FFSLASH_CREATE_MACROS_HELP,
    FFSLASH_CREATE_MACROS_HELP,
    FFSLASH_ANNOUNCE_HELP,
    FFSLASH_ANNOUNCE_HELP,
    FFSLASH_CHECK_STATUS,
    FFSLASH_CHECK_STATUS,
    FFSLASH_SHOW_HELP_HELP,
    FFSLASH_SHOW_HELP_HELP
}

--[[#########################################
    #          myAddOn Help
    #########################################]]

local Help_Page1 = FFMSG_ADDON_NAME.." Help\n===================\n\nType: "..FFSLASH_MENU.." or "..FFSLASH_MENU_ALIAS.." to open the "..FFMSG_ADDON_NAME.." menu.\nThis menu lets you access all of the controls for "..FFMSG_ADDON_NAME.."\n\nType: "..FFSLASH_SHOW_HELP.." or "..FFSLASH_SHOW_HELP_ALIAS.." to view the "..FFMSG_ADDON_NAME.." help dialog.";

FF_META_HELP_VARIABLE = {
Help_Page1
}