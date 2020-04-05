--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-ItemUse", "frFR" )
if L then
L["Item Use"] = "Utilisation des Objets"
L["Push Settings"] = "Appliquer les réglages"
L["Push the item use settings to all characters in the team."] = "Appliquer les réglages d'utilisation d'objets à tous les personnages de l'équipe"
L["Settings received from A."] = function( characterName )
	return string.format( "Réglages reçus de %s.", characterName )
end
L["Blizzard Tooltip"] = "Bulle d'aide Blizzard"
L["Blizzard Dialog Background"] = "Fond de dialogue BLizzard"
L["Item Use Options"] = "Options de l'utilisation d'objets"
L["Show Item Bar"] = "Afficher la barre d'objets"
L["Only On Master"] = "Uniquement sur le maître"
L["Message Area"] = "Zone de message"
L["Items"] = "Objets"
L["Stack Items Vertically"] = "Empiler les objets verticalement"
L["Scale"] = "Echelle"
L["Border Style"] = "Style de bordure"
L["Background"] = "Fond"
L["Number Of Items"] = "Nombre d'objets"
L["Appearance & Layout"] = "Apparence & mise en forme"
L["Item Size"] = "Taille d'objet"
L["Messages"] = "Messages"
L["Hide Item Bar In Combat"] = "Cacher la barre d'objets en combat"
L["Hide Item Bar"] = "Cacher la barre d'objets"
L["Hide the item bar panel."] = "Cacher le panneau"
L["Show Item Bar"] = "Afficher la barre d'objet"
L["Show the item bar panel."] = "Afficher le panneau"
L["Jamba-Item-Use"] = "Jamba-Item-Use"
L["Item 1"] = "Objet 1"
L["Item 2"] = "Objet 2"
L["Item 3"] = "Objet 3"
L["Item 4"] = "Objet 4"
L["Item 5"] = "Objet 5"
L["Item 6"] = "Objet 6"
L["Item 7"] = "Objet 7"
L["Item 8"] = "Objet 8"
L["Item 9"] = "Objet 9"
L["Item 10"] = "Objet 10"
L["I do not have X."] = function( name )
	return string.format( "Je ne possède pas %s.", name )
end
L["Transparency"] = "Transparence"
L["Border Colour"] = true
L["Background Colour"] = true
end
