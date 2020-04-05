--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-DisplayTeam", "frFR" )
if L then
L["Display: Team"] = "Affichage : Equipe"
L["Push Settings"] = "Transférer"
L["Push the display team settings to all characters in the team."] = "Transférer les réglages d'affichage à tous les personnages de l'équipe"
L["Settings received from A."] = function( characterName )
	return string.format( "Réglages reçus de %s.", characterName )
end
L[" "] = " "
L["("] = "("
L[")"] = ")"
L[" / "] = " / "
L["%"] = "%"
L["Blizzard"] = true
L["Blizzard Tooltip"] = true
L["Blizzard Dialog Background"] = true
L["Show"] = "Afficher"
L["Name"] = "Nom"
L["Level"] = "Niveau"
L["Values"] = "Valeurs"
L["Percentage"] = "Pourcentage"
L["Show Team List"] = "Afficher la liste de l'équipe"
L["Only On Master"] = "Seulement sur le Maître"
L["Appearance & Layout"] = "Apparence & Mise en forme"
L["Stack Bars Vertically"] = "Empiler les barres verticalement"
L["Status Bar Texture"] = "Texture de la barre de status"
L["Border Style"] = "Style de bordure"
L["Background"] = "Fond"
L["Scale"] = "Echelle"
L["Show"] = "Afficher"
L["Width"] = "Largeur"
L["Height"] = "Hauteur"
L["Portrait"] = "Portrait"
L["Follow Status Bar"] = "Barre de status du suivi"
L["Experience Bar"] = "Barre d'expérience"
L["Health Bar"] = "Barre de vie"
L["Power Bar"] = "Barrer d'énergie"
L["Jamba Team"] = "Equipe Jamba"
L["Hide Team Display"] = "Cacher l'équipe"
L["Hide the display team panel."] = "Cacher le panneau de l'équipe"
L["Show Team Display"] = "Afficher l'équipe"
L["Show the display team panel."] = "Afficher le panneau de l'équipe"
L["Hide Team List In Combat"] = "Cacher l'équipe en combat"
L["Transparency"] = "Transparence"
L["Border Colour"] = true
L["Background Colour"] = true
end
