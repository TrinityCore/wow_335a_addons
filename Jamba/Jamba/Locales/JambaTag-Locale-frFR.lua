--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Tag", "frFR" )
if L then
L["Core: Tags"] = "Cœur : labels"
L["Add"] = "Ajouter"
L["Add a tag to the this character."] = "Ajouter un label à ce personnage"
L["Remove"] = "Supprimer"				
L["Remove a tag from this character."] = "Supprimer un label de ce personnage"
L["Push Settings"] = "Appliquer les réglages"
L["Push the tag settings to all characters in the team."] = "Appliquer les réglages à tous les personnages de l'équipe"
L["Team List"] = "Liste de l'équipe"
L["Tag List"] = "Liste des labels"
L["Enter a tag to add:"] = "Saisir un label à ajouter : "
L["Are you sure you wish to remove %s from the tag list for %s?"] = "Etes-vous sûr(e) de vouloir supprimer  %s de la liste des labels pour %s ?"
L["Settings received from A."] = function( characterName )
	return "Réglages reçus de "..characterName.."."
end
L["master"] = "maître"
L["slave"] = "esclave"
L["all"] = "tous"
L["justme"] = "moiuniquement"
end
