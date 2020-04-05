--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Purchase", "koKR" )
if L then
L["Purchase"] = true
L["Push Settings"] = true
L["Push the purchase settings to all characters in the team."] = true
L["Settings received from A."] = function( characterName )
	return string.format( "Settings received from %s.", characterName )
end
L["Purchase Items"] = true
L["Auto Buy Items"] = true
L["Remove"] = true
L["Add Item"] = true
L["Item (drag item to box from your bags)"] = true
L["Tag"] = true
L["Add"] = true
L["Purchase Messages"] = true
L["Message Area"] = true
L["Are you sure you wish to remove the selected item from the auto buy items list?"] = true
L["Amount to buy must be a number."] = true
L["Item tags must only be made up of letters and numbers."] = true
L["Amount"] = true
L["I do not have enough space in my bags to complete my purchases."] = true
L["I do not have enough money to complete my purchases."] = true
L["I do not have enough other currency to complete my purchases."] = true
L["Overflow"] = true
L["PopOut"] = true
L["Show the purchase settings in their own window."] = true
end
