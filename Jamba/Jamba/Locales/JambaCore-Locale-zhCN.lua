--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Core", "zhCN" )
if L then
L["Core"] = true
L[": Profiles"] = true
L["Core: Communications"] = true
L["Push Settings"] = true
L["Push settings to all characters in the team list."] = true
L["Push Settings For All The Modules"] = true
L["Push all module settings to all characters in the team list."] = true
L["A: Failed to deserialize command arguments for B from C."] = function( libraryName, moduleName, sender )
	return libraryName..": Failed to deserialize command arguments for "..moduleName.." from "..sender.."."
end
L["Settings received from A."] = function( characterName )
	return "Settings received from "..characterName.."."
end
L["Team Online Channel"] = true
L["Channel Name"] = true
L["Channel Password"] = true
L["Change Channel (Debug)"] = true
L["After you change the channel name or password, push the"] = true
L["new settings to all your other characters and then log off"] = true
L["all your characters and log them on again."] = true
L["Show Online Channel Traffic (For Debugging Purposes)"] = true
L["Change Channel"] = true
L["Change the communications channel."] = true
L["Jamba"] = true
L["Jafula's Awesome Multi-Boxer Assistant"] = true
L["Copyright 2008-2010 Michael 'Jafula' Miller"] = true
L["Made in New Zealand"] = true
L["Help & Documentation"] = true
L["http://multiboxhaven.com/wow/addons/jamba/"] = true
L["For user manuals and documentation please visit:"] = true
L["Other useful websites:"] = true
L["http://wow.jafula.com/addons/jamba/"] = true
L["http://dual-boxing.com/"] = true
L["http://multiboxing.com/"] = true
L["Special thanks to olipcs on dual-boxing.com for writing the FTL Helper module."] = true
L["Settings"] = true
end
