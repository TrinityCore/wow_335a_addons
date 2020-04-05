--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Taxi", "frFR" )
if L then
L["Taxi"] = "Vols"
L["Taxi Options"] = "Options de Vol"
L["Take Master's Taxi"] = "Prendre le même vol que le maître"
L["Take the same flight as the master did (slaves's must have NPC Flight Master window open)."] = "Prendre le même vol que le master (la fenêtre de choix de trajet doit être ouverte chez les esclaves)."
L["Push Settings"] = "Appliquer les réglages"
L["Push the taxi settings to all characters in the team."] = "Appliquer les réglages de Vol à tous les personnages de l'équipe."
L["Settings received from A."] = function( characterName )
	return "Réglages reçus de "..characterName.."."
end
L["I am unable to fly to A."] = function( nodename )
	return "Je suis incapable de voler vers "..nodename.."."
end
end
