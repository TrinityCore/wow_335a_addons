--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Follow", "koKR" )
if L then
L["Follow"] = true
L["Push Settings"] = true
L["Push the follow settings to all characters in the team."] = true
L["Settings received from A."] = function( characterName )
	return string.format( "Settings received from %s.", characterName )
end
L["Follow Broken!"] = true
L["Follow After Combat"] = true
L["Auto Follow After Combat"] = true
L["Delay Follow After Combat (s)"] = true
L["Seconds To Delay Before Following After Combat"] = true
L["Use Different Master For Follow"] = true
L["Follow Master"] = true
L["Always Use Master As The Strobe Target"] = true
L["Follow Broken Warning"] = true
L["Warn If I Stop Following"] = true
L["Follow Broken Message"] = true
L["Do Not Warn If"] = true
L["In Combat"] = true
L["Any Member In Combat"] = true
L["Follow Strobing"] = true
L["Follow strobing is controlled by /jamba-follow commands."] = true
L["Pause Follow Strobing If"] = true
L["Drinking/Eating"] = true
L["Tag For Pause Follow Strobe"] = true
L["Frequency (s)"] = true
L["Frequency In Combat (s)"] = true
L["Send Warning Area"] = true
L["Follow The Master"] = true
L["Follow the current master."] = true
L["Follow A Target"] = true
L["Follow the target specified."] = true
L["Auto Follow After Combat"] = true
L["Automatically follow after combat."] = true
L["Begin Follow Strobing Target."] = true
L["Begin a sequence of follow commands that strobe every second (configurable) a specified target."] = true
L["Begin Follow Strobing Me."] = true
L["Begin a sequence of follow commands that strobe every second (configurable) this character."] = true
L["Begin Follow Strobing Last Target."] = true
L["Begin a sequence of follow commands that strobe every second (configurable) the last follow target character."] = true
L["End Follow Strobing."] = true
L["End the strobing of follow commands."] = true
L["Master"] = true
L["Set the follow master character."] = true
L["on"] = true 
L["off"] = true
L["Drink"] = true
L["Food"] = true
L["In A Vehicle"] = true
end
