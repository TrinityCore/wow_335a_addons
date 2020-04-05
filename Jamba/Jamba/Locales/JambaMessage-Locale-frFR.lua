--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Message", "frFR" )
if L then
L["Core: Message Display"] = "Cœur : Messages"
L["Push Settings"] = "Transférer"
L["Push the message settings to all characters in the team."] = "Transférer les réglages à tous les personnages de l'équipe"
L["Settings received from A."] = function( characterName )
	return string.format( "Réglages reçus de %s.", characterName )
end
L["Default Chat Window"] = "Fenêtre de dicussion par défaut"
L["Specific Chat Window"] = "Fenêtre de dicussion spécifique"
L["Whisper"] = "Chuchoter"
L["Party"] = "Groupe"
L["Guild"] = "Guilde"
L["Guild Officer"] = "Officier"
L["Raid"] = "Raid"
L["Raid Warning"] = "Avertissement de raid"
L["Channel"] = "Canal"
L["Area On Screen"] = "Zone sur l'écran"
L["Message Area List"] = "Liste des zones de message"
L["Add"] = "Ajouter"
L["Remove"] = "Supprimer"
L["Message Area Configuration"] = "Configuration de la zone de message"
L["Message Area Type"] = "Type de zone de message"
L["Tag"] = "Label"
L["Name"] = "Nom"
L["Password"] = "Mot de passe"
L["Save"] = "Enregistrer"
L["Enter name of the message area to add:"] = "Saisir le nom de la zone de message à ajouter :"
L['Are you sure you wish to remove "%s" from the message area list?'] = 'Etes-vous sûr(e) de vouloir supprimer "%s" de la liste des zones de message ?'
L["Default Message"] = "Message par défaut"
L["Default Warning"] = "Avertissement par défaut"
L["Default Proc Area"] = "Zone de proc"
L["Default Chat Whisper"] = "Chuchotement par défaut"
L["Mute"] = "Muet"
L["Mute (Default)"] = "muet (défaut)"
L["Parrot"] = "Parrot"
L["ERROR: Parrot Missing"] = "ERREUR : addon Parrot manquant"
L["ERROR: Could not find area: A"] = function( areaName )
	return string.format( "ERREUR : Impossible de trouver la zone : %s", areaName )
end
L[": "] = " :"
L[" whispers: "] = " chuchote "
L["ERROR: Not in a Party"] = "ERREUR : n'est pas dans un groupe"
L["ERROR: Not in a Guild"] = "ERREUR : n'est pas dans une guilde"
L["ERROR: Not in a Raid"] = "ERREUR : n'est pas dans un raid"
L["MikScrollingBattleText"] = "MikScrollingBattleText"
L["ERROR: MikScrollingBattleText Missing"] = "ERREUR : addon MikScrollingBattleText manquant"
L["ERROR: MikScrollingBattleText Disabled"] = "ERREUR : addon MikScrollingBattleText désactivé"
end
