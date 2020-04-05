--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Macro", "esES" )
if L then
L["Macro"] = true
L["Push Settings"] = true
L["Push the macro settings to all characters in the team."] = true
L["Settings received from A."] = function( characterName )
	return string.format( "Settings received from %s.", characterName )
end
L["Use"] = true
L["Add"] = true
L["Remove"] = true
L["Copy"] = true
L["Show"] = true
L["Variable Sets"] = true
L["Variables"] = true
L["Macro Sets"] = true
L["Macros"] = true
L["Edit Variable"] = true
L["Variable Name"] = true
L["Variable Value"] = true
L["Variable Tag (prefix ! for not this tag)"] = true
L["Edit Macro"] = true
L["Macro Name"] = true
L["Macro Text"] = true
L["Macro Key"] = true
L["Macro Tag (prefix ! for not this tag)"] = true
L["Macro: Macros"] = true
L["Macro: Variables"] = true
L["Macro Sets Control"] = true
L["Enable"] = true
L["Disable"] = true
L["Configure Macro Set"] = true
L["Variable Set"] = true
L["Tag"] = true
L["On"] = true
L["Off"] = true
L["Build Macros (Team)"] = true
L["Enter name for this SET of variables:"] = true
L['Are you sure you wish to remove "%s" from the variable SET list?'] = true
L["Enter name for this variable:"] = true
L['Are you sure you wish to remove "%s" from the variable list?'] = true
L["Enter name for this SET of macros:"] = true
L['Are you sure you wish to remove "%s" from the macro SET list?'] = true
L["Enter name for this macro:"] = true
L['Are you sure you wish to remove "%s" from the macro list?'] = true
L["Enter name for the copy of this SET of variables:"] = true
L["Enter name for the copy of this SET of macros:"] = true
L["/click JMB_"] = true
L["Macro Usage - press key assigned or copy /click below."] = true
L["Use Macro and Variable Set"] = true
L["Update the macros to use the specified macro and variable sets."] = true
L["Can not find macro set: X"] = function( macroSetName )
	return string.format( "Can not find macro set: %s", macroSetName )
end
L["Can not find variable set: X"] = function( variableSetName )
	return string.format( "Can not find variable set: %s", variableSetName )
end
L["Variable names must only be made up of letters and numbers."] = true
L["Macro names must only be made up of letters and numbers."] = true
L["Macro tags must only be made up of letters and numbers."] = true
L["Please choose a macro set to use."] = true
L["Please choose a variable set to use."] = true
L["Using macros set: X"] = function( macroSetName )
	return string.format( "Using macros set: %s", macroSetName )
end
L["Using variables set: X"] = function( variableSetName )
	return string.format( "Using variables set: %s", variableSetName )
end
L["In combat, waiting until after combat to update the macros."] = true
end