--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Team", "zhCN" )
if L then
L["Core: Team"] = true
L["Add"] = true
L["Add a member to the team list."] = true
L["Remove"] = true
L["Remove a member from the team list."] = true
L["Master"] = true
L["Set the master character."] = true
L["I Am Master"] = true
L["Set this character to be the master character."] = true
L["Invite"] = true
L["Invite team members to a party."] = true
L["Disband"] = true
L["Disband all team members from their parties."] = true
L["Push Settings"] = true
L["Push the team settings to all characters in the team."] = true
L["Team List"] = true
L["Up"] = true
L["Down"] = true
L["Set Master"] = true
L["Master Control"] = true
L["When Focus changes, set the Master to the Focus."] = true
L["When Master changes, promote Master to party"] = true
L["leader."] = true
L["Party Invitations Control"] = true
L["Accept from team."] = true
L["Accept from friends."] = true
L["Accept from guild."] = true
L["Decline from strangers."] = true
L["Party Loot Control"] = true
L["Automatically set the Loot Method"] = true
L["to..."] = true
L["Free For All"] = true
L["Master Looter"] = true
L["Slaves Opt Out of Loot"] = true
L["Slave"] = true
L["(Offline)"] = true
L["Enter name of character to add:"] = true
L["Are you sure you wish to remove %s from the team list?"] = true
L["A is not in my team list.  I can not set them to be my master."] = function( characterName )
	return characterName.." is not in my team list.  I can not set them to be my master."
end
L["Settings received from A."] = function( characterName )
	return "Settings received from "..characterName.."."
end
L["Jamba-Team"] = true
L["Invite Team To Group"] = true
L["Disband Group"] = true
L["Override: Set loot to Group Loot if stranger"] = true
L["in group."] = true
L["Add Party Members"] = true
L["Add members in the current party to the team."] = true
L["Friends Are Not Strangers"] = true
end
