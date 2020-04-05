--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Follow", "frFR" )
if L then
L["Follow"] = "Suivi"
L["Push Settings"] = "Transférer"
L["Push the follow settings to all characters in the team."] = "Transférer les réglages de suivi à tous les personnages de l'équipe"
L["Settings received from A."] = function( characterName )
	return string.format( "Réglages reçus de %s.", characterName )
end
L["Follow Broken!"] = "Suivi rompu !"
L["Follow After Combat"] = "Suivre après le combat"
L["Auto Follow After Combat"] = "Suivi automatique après le combat"
L["Delay Follow After Combat (s)"] = "Délai avant le suivi après le combat (s)"
L["Seconds To Delay Before Following After Combat"] = "Délai en seconde avant de suivre après le combat"
L["Use Different Master For Follow"] = "Choisir un autre maître à suivre"
L["Follow Master"] = "Suivre le maître"
L["Always Use Master As The Strobe Target"] = "Toujours utiliser le maître comme cible de répétition"
L["Follow Broken Warning"] = "Avertissement en cas de suivi rompu"
L["Warn If I Stop Following"] = "Avertir si j'arrête de suivre"
L["Follow Broken Message"] = "Message en cas de suivi rompu"
L["Do Not Warn If"] = "Ne pas avertir si"
L["In Combat"] = "En combat"
L["Any Member In Combat"] = "Tout membre en combat"
L["Follow Strobing"] = "Suivi répétitif"
L["Follow strobing is controlled by /jamba-follow commands."] = "Le suivi répétitif est contrôlé via les commandes /jamba-follow"
L["Pause Follow Strobing If"] = "Mettre en pause le suivi répétitif si"
L["Drinking/Eating"] = "En train de manger/boire"
L["Tag For Pause Follow Strobe"] = "Label de pause de suivi répétitif"
L["Frequency (s)"] = "Délai (s)"
L["Frequency In Combat (s)"] = "Délai en combat (s)"
L["Send Warning Area"] = "Zone d'envoi des avertissements"
L["Follow The Master"] = "Suivre le maître"
L["Follow the current master."] = "Suivre le maître actuel"
L["Follow A Target"] = "Suivre une cible"
L["Follow the target specified."] = "Suivre la cible spéficiée."
L["Auto Follow After Combat"] = "Suivi automatique après le combat"
L["Automatically follow after combat."] = "Suivre automatiquement après le combat."
L["Begin Follow Strobing Target."] = "Commencer à suivre la cible de manière répétée."
L["Begin a sequence of follow commands that strobe every second (configurable) a specified target."] = "Démarrer l'envoi répété (par défaut toutes les secondes) de commandes de suivi sur une cible spécifique."
L["Begin Follow Strobing Me."] = "Commencer à me suivre de manière répétée"
L["Begin a sequence of follow commands that strobe every second (configurable) this character."] = "Démarrer l'envoi répété (par défaut toutes les secondes) de commande de suivi sur ce personnage."
L["Begin Follow Strobing Last Target."] = "Commencer à suivre de manière répétée la dernière cible."
L["Begin a sequence of follow commands that strobe every second (configurable) the last follow target character."] = "Démarrer l'envoi répété (par défaut toutes les secondes) de commande de suivi sur le dernier personnage suivi."
L["End Follow Strobing."] = "Arrêter le suivi stroboscopique"
L["End the strobing of follow commands."] = "Arrêter l'envoi stroboscopique de commandes de suivi"
L["Master"] = "Maître"
L["Set the follow master character."] = "Choisir le personnage maître de suivi"
L["on"] = "activé"
L["off"] = "désactivé"
L["Drink"] = "Boisson"
L["Food"] = "Nourriture"
L["In A Vehicle"] = "Dans un véhicule"
end
