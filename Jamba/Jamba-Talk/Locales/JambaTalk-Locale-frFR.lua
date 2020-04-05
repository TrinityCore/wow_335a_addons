--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Talk", "frFR" )
if L then
L["Talk"] = "Discussion"
L["Push Settings"] = "Transférer"
L["Push the talk settings to all characters in the team."] = "Transférer les réglages de discussion à tous les personnages de l'équipe"
L["Settings received from A."] = function( characterName )
	return string.format( "Réglages reçus de %s.", characterName )
end
L["Talk Options"] = "Options de discussion"
L["Forward Whispers And Relay"] = "Transférer les chuchotements"
L["Chat Snippets"] = "Extraits de conversation"
L["Remove"] = "Supprimer"
L["Add Snippet"] = "Ajouter extrait"
L["Snippet Text"] = "Extrait de texte"
L["Add"] = "Ajouter"
L["Talk Messages"] = "Messages de discussion"
L["Message Area"] = "Zone de message"
L["Enter the shortcut text for this chat snippet:"] = "Saisir le raccourci pour cet extrait de conversation : "
L["Are you sure you wish to remove the selected chat snippet?"] = "Etes-vous sûr(e) de vouloir supprimer l'extrait de conversation sélectionné ?"
L["<GM>"] = "<MJ>"
L["GM"] = "MJ"
L[" whispers: "] = "chuchote : "
L["Fake Whispers For Clickable Player Names"] = "Simuler chuchotements aux joueurs"
L["Enable Chat Snippets"] = "Permettre extraits de conversation"
end
