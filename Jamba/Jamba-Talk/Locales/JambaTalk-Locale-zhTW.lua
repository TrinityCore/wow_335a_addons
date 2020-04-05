--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Talk", "zhTW" )
if L then
L["Talk"] = true
L["Push Settings"] = true
L["Push the talk settings to all characters in the team."] = true
L["Settings received from A."] = function( characterName )
	return string.format( "Settings received from %s.", characterName )
end
L["Talk Options"] = true
L["Forward Whispers And Relay"] = true
L["Chat Snippets"] = true
L["Remove"] = true
L["Add Snippet"] = true
L["Snippet Text"] = true
L["Add"] = true
L["Talk Messages"] = true
L["Message Area"] = true
L["Enter the shortcut text for this chat snippet:"] = true
L["Are you sure you wish to remove the selected chat snippet?"] = true
L["<GM>"] = true
L["GM"] = true
L[" whispers: "] = true
L["Fake Whispers For Clickable Player Names"] = true
L["Enable Chat Snippets"] = true
end
