--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Sell", "frFR" )
if L then
L["Sell: Greys"] = "Vente : Objets gris"
L["Push Settings"] = "Transférer"
L["Push the sell settings to all characters in the team."] = "Transférer les réglages de vente à tous les personnages de l'équipe"
L["Settings received from A."] = function( characterName )
	return string.format( "Réglages reçus de %s.", characterName )
end
L["Are you sure you wish to remove the selected item from the auto sell poor items exception list?"] = "Etes-vous sûr(e) de vouloir supprimer l'objet sélectionné de la liste des exceptions de vente automatique d'objets gris ?"
L["Are you sure you wish to remove the selected item from the auto sell other items list?"] = "Etes-vous sûr(e) de vouloir supprimer l'objet sélectionné de la liste des de vente automatique des autres objets ?"
L["I have sold: X"] = function( itemLink )
	return string.format( "J'ai vendu : %s", itemLink )
end
L["DID NOT SELL: X"] = function( itemLink )
	return string.format( "JE N'AI PAS VENDU : %s", itemLink )
end
L["Sell: Others"] = "Vendre : Autres"
L["Sell Greys"] = "Vendre les objets gris"
L["Sell Others"] = "Vendre les autres objets"
L["Auto Sell Poor Quality Items"] = "Vendre automatiquement les objets gris"
L["Except For These Poor Quality Items"] = "Sauf ces objets gris"
L["Add Exception"] = "Ajouter une exception"
L["Exception Item (drag item to box)"] = "Objet exclus (glisser l'objet dans la zone)"
L["Exception Tag"] = "Label de l'exception"
L["Remove"] = "Supprimer"
L["Add"] = "Ajouter"
L["Sell Others"] = "Vendre les autres objets"
L["Auto Sell Items"] = "Vendre automatiquement les objets"
L["Other Item (drag item to box)"] = "Autre objet (glisser l'objet dans la zone)"
L["Other Tag"] = "Label de cet autre objet"
L["Message Area"] = "Zone de message"
L["Item tags must only be made up of letters and numbers."] = "Les labels d'objet doivent être composés uniquement de lettres et de chiffres."
L["Add Other"] = "Ajouter autre"
L["Sell Messages"] = "Messages de vente"
L["Sell Item On All Toons"] = "Vendre les objets sur tous les personnages"
L["Hold Alt While Selling An Item To Sell On All Toons"] = "Maintenir ALT pour vendre sur tous les personnages"
L["PopOut"] = "PopOut"
L["Show the sell other settings in their own window."] = "Afficher les réglages de vente des autres objets dans leur propre fenêtre."
end
