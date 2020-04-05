--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Core", "frFR" )
if L then
L["Core"] = "Cœur"
L[": Profiles"] = " : Profils"
L["Core: Communications"] = "Cœur : Communications"
L["Push Settings"] = "Transférer"
L["Push settings to all characters in the team list."] = "Transférer les réglages à tous les personnages de l'équipe"
L["Push Settings For All The Modules"] = "Transférer les réglages pour tous les modules"
L["Push all module settings to all characters in the team list."] = "Transférer les réglages pour tous les modules à tous les personnages de l'équipe"
L["A: Failed to deserialize command arguments for B from C."] = function( libraryName, moduleName, sender )
	return libraryName..": Echec lors de la désérialisation des arguments pour "..moduleName.." depuis "..sender.."."
end
L["Settings received from A."] = function( characterName )
	return "Réglages reçus de "..characterName.."."
end
L["Team Online Channel"] = "Canal de communication de l'équipe"
L["Channel Name"] = "Nom du canal"
L["Channel Password"] = "Mot de passe du canal"
L["Change Channel (Debug)"] = "Changer de canal (debug)"
L["After you change the channel name or password, push the"] = "Après avoir changé le nom ou le mdp du canal, cliquez"
L["new settings to all your other characters and then log off"] = "sur transférer pour appliquer les réglages aux autres"
L["all your characters and log them on again."] = "personnages puis déconnectez et reconnectez-les."
L["Show Online Channel Traffic (For Debugging Purposes)"] = "Afficher le trafic du canal (debug)"
L["Change Channel"] = "Changer de canal"
L["Change the communications channel."] = "Changer le canal de communication"
L["Jamba"] = "Jamba"
L["Jafula's Awesome Multi-Boxer Assistant"] = "Jafula's Awesome Multi-Boxer Assistant"
L["Copyright 2008-2010 Michael 'Jafula' Miller"] = "Copyright 2008-2010 Michael 'Jafula' Miller"
L["Made in New Zealand"] = "Conçu en Nouvelle Zélande"
L["Special thanks to Daeri and dual-boxing.fr community for the French translation"] = "Remerciements particuliers à Daeri et à la communauté dual-boxing.fr pour la traduction française"
L["Help & Documentation"] = "Aide & Documentation"
L["http://multiboxhaven.com/wow/addons/jamba/"] = "http://multiboxhaven.com/wow/addons/jamba/"
L["For user manuals and documentation please visit:"] = "Pour consulter le manuel utilisateur et la documentation, merci de visiter : "
L["Other useful websites:"] = "Autre sites utiles : "
L["http://wow.jafula.com/addons/jamba/"] = "http://wow.jafula.com/addons/jamba/"
L["http://dual-boxing.com/"] = "http://dual-boxing.com/"
L["http://multiboxing.com/"] = "http://multiboxing.com/"
L["Special thanks to olipcs on dual-boxing.com for writing the FTL Helper module."] = "Remerciements spéciaux à olipcs de dual-boxing.com pour l'écriture du module assistant FTL."
L["Settings"] = "Réglages"
end
