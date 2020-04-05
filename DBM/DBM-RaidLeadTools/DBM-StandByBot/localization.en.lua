DBM_StandbyBot_Translations = {}

local L = DBM_StandbyBot_Translations

L.InRaidGroup		= "Sorry, but you have to leave the raid group before going standby."
L.LeftRaidGroup 	= "You have left our raid group. Please don't forget to whisper me \"!sb\" if you wan't to be standby."
L.AddedSBUser		= "You are now standby. Please stay available until we need you or removed from the SB-list."
L.UserIsAllreadySB	= "Sorry, you are already standby. To remove yourself from the list please whisper me \"!sb off\"."
L.NotStandby		= "Sorry, you are currently not registerd as a standby member. Please whisper me \"!sb\"."
L.NoLongerStandby	= "You are no longer standby. Your were standby for %d hours and %d minutes."

L.PostStandybyList	= "Currently on standby:"

L.Local_AddedPlayer	= "[SB]: %s is now standby."
L.Local_RemovedPlayer	= "[SB]: %s is no longer standby."
L.Local_CantRemove	= "Sorry, can't remove player."
L.Local_CleanList	= "SB list cleaned because (requested by %s)"

L.Current_StandbyTime	= "Standby times from %s:"
L.DateTimeFormat	= "%c"

L.History_OnJoin	= "[%s]: %s is now SB"
L.History_OnLeave	= "[%s]: %s leaves SB after %s min"
L.SB_History_Saved	= "The standby-list was saved as ID %s."
L.SB_History_NotSaved	= "No player was standby --> no history was saved"

L.SB_History_Line	= "[ID=%d] Raid at %s with %d members"


-- GUI
L.TabCategory_Standby	= "Standby-Bot"
L.AreaGeneral		= "General Standby-Bot Settings"
L.Enable		= "Enable standby-bot (!sb)"
L.SendWhispers		= "Send information whisper on Raidleave to players"
L.AreaStandbyHistory	= "Standby history"
L.NoHistoryAvailable	= "There are no saved raids with standby players"

L.Button_ResetHistory	= "reset"
L.SB_Documentation	= [[This standby module allows raid leaders to manage players who currently can't raid because of a full raid or something like this. All listed commands can be used in the guildchat. 

!sb               - shows a list of standby players
!sb times         - shows the current standby times
!sb add <nick>    - adds a player to standby
!sb del <nick>    - removes a player from standby
!sb save          - saves the current status
!sb reset         - clears the standby list
!sb history [id]  - shows the standby history

Players who want to be standby have to whisper '!sb' to the player who is running this mod. A confirmation will be send to that player. To get off the standby-list they have to whisper '!sb off'.
]]

L.Button_ShowClients		= "Show clients"
L.Local_NoRaid			= "You have to be in a raid group to use this function"
L.Local_Version			= "%s: %s"	-- Lacrosa: r123	(please don't translate this line)




