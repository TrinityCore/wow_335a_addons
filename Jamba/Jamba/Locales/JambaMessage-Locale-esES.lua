--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Message", "esES" )
if L then
L["Core: Message Display"] = true
L["Push Settings"] = true
L["Push the message settings to all characters in the team."] = true
L["Settings received from A."] = function( characterName )
	return string.format( "Settings received from %s.", characterName )
end
L["Default Chat Window"] = true
L["Specific Chat Window"] = true
L["Whisper"] = true
L["Party"] = true
L["Guild"] = true
L["Guild Officer"] = true
L["Raid"] = true
L["Raid Warning"] = true
L["Channel"] = true
L["Area On Screen"] = true
L["Message Area List"] = true
L["Add"] = true
L["Remove"] = true
L["Message Area Configuration"] = true
L["Message Area Type"] = true
L["Tag"] = true
L["Name"] = true
L["Password"] = true
L["Save"] = true
L["Enter name of the message area to add:"] = true
L['Are you sure you wish to remove "%s" from the message area list?'] = true
L["Default Message"] = true
L["Default Warning"] = true
L["Default Proc Area"] = true
L["Default Chat Whisper"] = true
L["Mute"] = true
L["Mute (Default)"] = true
L["Parrot"] = true
L["ERROR: Parrot Missing"] = true
L["ERROR: Could not find area: A"] = function( areaName )
	return string.format( "ERROR: Could not find area: %s", areaName )
end
L[": "] = true
L[" whispers: "] = true
L["ERROR: Not in a Party"] = true
L["ERROR: Not in a Guild"] = true
L["ERROR: Not in a Raid"] = true
L["MikScrollingBattleText"] = true
L["ERROR: MikScrollingBattleText Missing"] = true
L["ERROR: MikScrollingBattleText Disabled"] = true
end
