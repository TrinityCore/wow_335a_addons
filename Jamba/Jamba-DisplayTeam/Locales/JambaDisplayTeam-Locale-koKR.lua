--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-DisplayTeam", "koKR" )
if L then
L["Display: Team"] = true
L["Push Settings"] = true
L["Push the display team settings to all characters in the team."] = true
L["Settings received from A."] = function( characterName )
	return string.format( "Settings received from %s.", characterName )
end
L[" "] = true
L["("] = true
L[")"] = true
L[" / "] = true
L["%"] = true
L["Blizzard"] = true
L["Blizzard Tooltip"] = true
L["Blizzard Dialog Background"] = true
L["Show"] = true
L["Name"] = true
L["Level"] = true
L["Values"] = true
L["Percentage"] = true
L["Show Team List"] = true
L["Only On Master"] = true
L["Appearance & Layout"] = true
L["Stack Bars Vertically"] = true
L["Status Bar Texture"] = true
L["Border Style"] = true
L["Background"] = true
L["Scale"] = true
L["Show"] = true
L["Width"] = true
L["Height"] = true
L["Portrait"] = true
L["Follow Status Bar"] = true
L["Experience Bar"] = true
L["Health Bar"] = true
L["Power Bar"] = true
L["Jamba Team"] = true
L["Hide Team Display"] = true
L["Hide the display team panel."] = true
L["Show Team Display"] = true
L["Show the display team panel."] = true
L["Hide Team List In Combat"] = true
L["Transparency"] = true
L["Border Colour"] = true
L["Background Colour"] = true
end
