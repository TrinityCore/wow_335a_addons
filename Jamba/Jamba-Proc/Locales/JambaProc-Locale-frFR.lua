--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Proc", "frFR" )
if L then
L["Proc"] = "Proc"
L["Push Settings"] = "Appliquer les réglages"
L["Push the proc settings to all characters in the team."] = "Appliquer les réglages de proc à tous les personnages de l'équipe"
L["Settings received from A."] = function( characterName )
	return string.format( "Réglages reçus de %s.", characterName )
end
L["Proc"] = "Proc"
L["Enable Jamba-Proc"] = "Activer Jamba-proc"
L["Jamba Proc"] = "Jamba Proc"
L["Tag"] = "Label"
L["Proc List"] = "Liste des Procs"
L["Proc Configuration"] = "Configuration des Procs"
L["Display Text"] = "Afficher le texte"
L['Are you sure you wish to remove "%s" from the proc list?'] = 'Supprimer "%s" de la liste des procs ?'
L["Add"] = "Ajouter"
L["Remove"] = "Supprimer"
L["Save"] = "Enregistrer"
L["The Art of War"] = "L'art de la guerre"
L["Hot Streak"] = "Chaleur continue"
L["Missile Barrage"] = "Barrage de projectiles"
L["Fireball!"] = "Boule de feu"
L["Clearcasting (Shaman)"] = "Idées claires (Shaman)"
L["Clearcasting (Druid)"] = "Idées claires (Druide)"
L["Maelstrom Weapon"] = "Arme du Maelström"
L["Elune's Wrath"] = "Colère d'Elune"
L["Shadow Trance"] = "Transe de l'ombre"
L["Clearcasting (Mage)"] = "Idées claires (Mage)"
L["Infusion of Light"] = "Imprégnation de lumière"
L["Freezing Fog"] = "Brouillard givrant"
L["Lock and Load"] = "Prêt à tirer"
L["Eclipse (Lunar)"] = "Eclipse (lunaire)"
L["Eclipse (Solar)"] = "Eclipse (solaire)"
L["Appearance & Layout"] = "Apparence & Disposition"
L["Proc Bar Texture"] = "Texture de la barre de proc"
L["Proc Bar Font"] = "Police de caractère"
L["Proc Bar Font Size"] = "Taille de police"
L["Proc Bar Width"] = "Largeur de la barre"
L["Proc Bar Height"] = "Hauteur de la barre"
L["Proc Bar Spacing"] = "Espacement de barre"
L["Proc Duration (seconds)"] = "Durée (secondes)"
L["Proc Colour"] = "Couleur du proc"
L["Proc Sound"] = "Son du proc"
L["Toon-Name-1"] = "Nom-personnage-1"
L["Toon-Name-2"] = "Nom-personnage-2"
L["Toon-Name-3"] = "Nom-personnage-3"
L["Enter the ID of the spell to add:"] = "Entrer l'ID du sort à ajouter : "
L["Spell ID"] = "ID du sort"
L["Enable Jamba Proc"] = "Activer Jamba Proc"
L["Show Test Bars"] = "Afficher les barres de test"
L["Show Proc Bars Only On Master"] = "Afficher les barres sur le maître seulement"
L["Proc Information Text Displayed Here"] = "Le texte d'information du proc apparaît ici"
L["Blizzard"] = true -- Default status bar texture, check what LibSharedMedia has for default for each language.
L["Friz Quadrata TT"] = true -- Default status bar font, check what LibSharedMedia has for default for each language.
L["None"] = true -- Default sound, check what LibSharedMedia has for default for each language.
end
