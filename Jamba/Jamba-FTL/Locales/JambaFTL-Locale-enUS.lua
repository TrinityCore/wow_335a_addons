-- Author      : olipcs
-- Create Date : 8/12/2009 
-- Version : 0.1
-- Credits: Many thanks goes to Jafula for the awsome JAMBA addon
--          Nearly all code where copy & pasted from Jafulas JAMBA 0.5 addon,
--          and only small additions where coded by me.
--          So again, many thanks Jafula, for making the Jamba 0.5 API so simple to use!     

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-FTL", "enUS", true )
L["FTL Helper"] = true
L["FTL Helper Options"] = true
L["Don't differenciate between left/right modifier states"] = true
L["If this Option is checked only plain modifiers like shift,alt,ctrl are used for FTL and not theri left/right versions. Hint: If you use Keyclone you miht have to check this!."] = true
L["Push Settings"] = true
L["Push the FTL settings to all characters in the team."] = true
L["Settings received from A."] = function( characterName )
	return "Settings received from "..characterName.."."
end
L["I am unable to fly to A."] = function( nodename )
	return "I am unable to fly to ."..nodename.."."
end
L[" "] = true
L["Information"] = true
L["Use left shift"] = true
L["Use left alt"] = true
L["Use left ctrl"] = true
L["Use right shift"] = true
L["Use right alt"] = true
L["Use right ctrl"] = true
L["Team List"] = true
L["Modifiers to use for selected toon"] = true
L["Options"] = true
L["If a modifier isn't used in a team, don't include it."] = true
L["Create / Update FTL Buttons"] = true
L["Only use Toons which are online"] = true
L["Use selected Toon in FTL"] = true
L["Update FTL-Button"] = true
L["Updates the FTL-Button on all Team members"] = true
L["Hint:Use the buttons by: /click JambaFTLAssist or /click JambaFTLTarget"] = true
