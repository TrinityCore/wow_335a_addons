--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Purchase", "frFR" )
if L then
L["Purchase"] = "Achats"
L["Push Settings"] = "Transférer"
L["Push the purchase settings to all characters in the team."] = "Transférer les réglages d'achats à tous les personnages de l'équipe"
L["Settings received from A."] = function( characterName )
	return string.format( "Réglages reçus de %s.", characterName )
end
L["Purchase Items"] = "Acheter des objets"
L["Auto Buy Items"] = "Acheter en auto"
L["Remove"] = "Supprimer"
L["Add Item"] = "Ajouter objet"
L["Item (drag item to box from your bags)"] = "Objet (glisser l'objet depuis vos sacs)"
L["Tag"] = "Label"
L["Add"] = "Ajouter"
L["Purchase Messages"] = "Messages d'achats"
L["Message Area"] = "Zone de message"
L["Are you sure you wish to remove the selected item from the auto buy items list?"] = "Etes-vous sûr(e) de vouloir supprimer l'objet sélectionné de la liste des objets à acheter automatiquement ?"
L["Amount to buy must be a number."] = "La quantité à acheter doit être un nombre."
L["Item tags must only be made up of letters and numbers."] = "Les labels d'objet doivent être uniquement composés de chiffres et de lettres."
L["Amount"] = "Quantité"
L["I do not have enough space in my bags to complete my purchases."] = "Je n 'ai pas assez de place libre dans mon sac pour compléter mes achats."
L["I do not have enough money to complete my purchases."] = "Je n'ai pas assez d'argent pour compléter mes achats."
L["I do not have enough other currency to complete my purchases."] = "Je n'ai pas assez d'autre monnaie pour compléter mes achats."
L["Overflow"] = "Dépassement"
L["PopOut"] = true
L["Show the purchase settings in their own window."] = "Afficher les réglages d'acaht dans leur propre fenêtre."
end
