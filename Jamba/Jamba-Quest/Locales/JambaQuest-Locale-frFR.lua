--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Quest", "frFR" )
if L then
L["Quest"] = "Quêtes"
L["Push Settings"] = "Transférer"
L["Push the quest settings to all characters in the team."] = "Transférer les réglages de quête à tous les personnages de l'équipe"
L["Settings received from A."] = function( characterName )
	return string.format( "Réglages reçus de %s.", characterName )
end
L[": "] = " : "
L["Completion"] = "Validation"
L[" "] = " "
L["Information"] = "Information"
L["Jamba-Quest treats any team member as the Master."] = "Jamba traite tout membre de l'équipe comme le maître."
L["Quest actions by one character will be actioned by the other"] = "Les actions de quête d'un perso seront imitées par"
L["characters regardless of who the Master is."] = "les autres personnages peu importe le maître"
L["Quest Selection & Acceptance"] = "Choix et acceptation de quête"
L["Toon Select & Decline Quest With Team"] = "Le personnage choisit & refuse la quête avec l'équipe"
L["All Auto Select Quests"] = "Tous choisissent automatiquement les quêtes"
L["Accept Quests"] = "Accepter les quêtes"
L["Toon Accept Quest From Team"] = "Le personnage accepte les quêtes de l'équipe"
L["Do Not Auto Accept Quests"] = "Ne pas accepter automatiquement de quête"
L["All Auto Accept ANY Quest"] = "Tous acceptent automatiquement TOUTES les quêtes"
L["Only Auto Accept Quests From:"] = "Accepter uniquement les quêtes de(s) :"
L["Team"] = "L'équipe"
L["NPC"] = "PNJ"
L["Friends"] = "Amis"
L["Party"] = "Groupe"
L["Raid"] = "Raid"
L["Guild"] = "Guilde"
L["Master Auto Share Quests When Accepted"] = "Le maître partage les quêtes d'escorte"
L["Toon Auto Accept Escort Quest From Team"] = "Le perso auto-accepte les escorte de l'équipe"
L["Other Options"] = "Autres options"
L["Show Jamba-Quest Log With WoW Quest Log"] = "Afficher le log de Jamba-Quest dans le log de WoW"
L["Quest Completion"] = "Validation de quête"
L["Enable Auto Quest Completion"] = "Activer la validation automatique des quêtes"
L["Quest Has No Rewards Or One Reward:"] = "La quête ne propose aucune ou une récompense :"
L["Toon Do Nothing"] = "Le personnage ne fait rien"
L["Toon Complete Quest With Team"] = "Le personnage valide la quête avec l'équipe"
L["All Automatically Complete Quest"] = "Tous les personnages valident la quête automatiquement"
L["Quest Has More Than One Reward:"] = "La quête propose plus d'une récompense :"
L["Toon Choose Same Reward As Team"] = "Le personnage choisit la même récompense que l'équipe"
L["Toon Must Choose Own Reward"] = "Il doit choisir sa propre récompense"
L["If Modifier Keys Pressed, Toon Choose Same Reward"] = "Si ces touches sont pressées, il choisit la même"
L["As Team Otherwise Toon Must Choose Own Reward"] = "récompense que l'équipe, sinon il doit choisir lui-même"
L["Ctrl"] = "Ctrl"
L["Shift"] = "Shift"
L["Alt"] = "Alt"
L["Override: If Toon Already Has Reward Selected,"] = "Forcer : si le personnage a déjà choisi sa récompense, "
L["Choose That Reward"] = "alors choisir cette récompense"
L["Accepted Quest: A"] = function( questName )
	return string.format( "Quête acceptée : %s", questName )
end
L["Automatically Accepted Quest: A"] = function( questName )
	return string.format( "Quête automatiquement acceptée : %s", questName )
end
L["Automatically Accepted Quest: A"] = function( questName )
	return string.format( "Quête automatiquement acceptée : %s", questName )
end
L["Quest has X reward choices."] = function( choices )
	return string.format( "La quête propose %s choix de récompense.", choices )
end
L["Completed Quest: A"] = function( questName )
	return string.format( "Quête terminée : %s", questName )
end
L["Automatically Accepted Escort Quest: A"] = function( questName )
	return string.format( "Quête d'escorte automatiquement acceptée : %s", questName )
end
L["I do not have the quest: A"] = function( questName )
	return string.format( "Je n'ai pas la quête : %s", questName )
end
L["I have abandoned the quest: A"] = function( questName )
	return string.format( "J'ai abandonné la quête : %s", questName )
end
L["Sharing Quest: A"] = function( questName )
	return string.format( "Partage de la quête : %s", questName )
end
L["Abandon"] = "Abandonner"
L["Select"] = "Choisir"
L["Jamba-Quest"] = "Jamba-Quest"
L["Share"] = "Partager"
L["Track"] = "suivre"
L["Track All"] = "Tout suivre"
L["Abandon All"] = "Tout Abandonner"
L["Share All"] = "Tout partager"
L["(No Quest Selected)"] = "(Aucune quête sélectionnée)"
L["You must select a quest from the quest log in order to action it on your other characters."] = "Vous devez choisir une quête dans le journal pour l'actionner sur vos autres personnages."
L['Abandon "%s"?'] = 'Abandonner "%s" ?'
L["This will abandon ALL quests ON every toon!  Yes, this means you will end up with ZERO quests in your quest log!  Are you sure?"] = "Ceci va provoquer l'abandon de TOUTES les quêtes sur chaque personnage ! Oui, cela signifie que votre journal de quête sera VIDE ! Etes-vous sûr(e) ?"
L["Send Message Area"] = "Zone d'envoi de message"
L["Send Warning Area"] = "Zone d'envoi d'avertissement"
L["Set The Auto Select Functionality"] = "Activer la fonction de choix automatique"
L["Set the auto select functionality."] = "Activer la fonction de choix automatique."
L["toggle"] = "Inverser"
L["off"] = "Désactiver"
L["on"] = "Activer"
L["Hold Shift To Override Auto Select/Auto Complete"] = "Touche Shift pour forcer validation auto/choix auto"
L["Toon Auto Chooses Best Reward"] = "Le perso. choisit la meilleure récompense auto."
L["N/A"] = true
L["Update"] = true
L["Border Colour"] = true
L["Background Colour"] = true
L["<Map>"] = true
L["Lines Of Info To Display (Reload UI To See Change)"] = true
L["Quest Watcher Width (Reload UI To See Change)"] = true
L["DONE"] = true
end
