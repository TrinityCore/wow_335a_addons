--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-ItemUse", "enUS", true )
L["Item Use"] = true
L["Push Settings"] = true
L["Push the item use settings to all characters in the team."] = true
L["Settings received from A."] = function( characterName )
	return string.format( "Settings received from %s.", characterName )
end
L["Blizzard Tooltip"] = true
L["Blizzard Dialog Background"] = true
L["Item Use Options"] = true
L["Show Item Bar"] = true
L["Only On Master"] = true
L["Message Area"] = true
L["Items"] = true
L["Stack Items Vertically"] = true
L["Scale"] = true
L["Border Style"] = true
L["Background"] = true
L["Number Of Items"] = true
L["Appearance & Layout"] = true
L["Item Size"] = true
L["Messages"] = true
L["Hide Item Bar In Combat"] = true
L["Hide Item Bar"] = true
L["Hide the item bar panel."] = true
L["Show Item Bar"] = true
L["Show the item bar panel."] = true
L["Jamba-Item-Use"] = true
L["Item 1"] = true
L["Item 2"] = true
L["Item 3"] = true
L["Item 4"] = true
L["Item 5"] = true
L["Item 6"] = true
L["Item 7"] = true
L["Item 8"] = true
L["Item 9"] = true
L["Item 10"] = true
L["I do not have X."] = function( name )
	return string.format( "I do not have %s.", name )
end
L["Transparency"] = true
L["Border Colour"] = true
L["Background Colour"] = true
