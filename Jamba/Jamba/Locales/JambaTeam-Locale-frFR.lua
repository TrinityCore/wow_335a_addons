--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Team", "frFR" )
if L then
L["Core: Team"] = "Cœur : Equipe"
L["Add"] = "Ajouter"
L["Add a member to the team list."] = "Ajouter un membre à l'équipe"
L["Remove"] = "Supprimer"
L["Remove a member from the team list."] = "Supprimer un membre de l'équipe"
L["Master"] = "Maître"
L["Set the master character."] = "Choisir le maître."
L["I Am Master"] = "Je suis le maître"
L["Set this character to be the master character."] = "Choisir ce personnage comme maître"
L["Invite"] = "Inviter"
L["Invite team members to a party."] = "Inviter les membres de l'équipe dans un groupe"
L["Disband"] = "Dégrouper"
L["Disband all team members from their parties."] = "Dégrouper tous les membres de l'équipes de leurs groupes"
L["Push Settings"] = "Appliquer les réglages"
L["Push the team settings to all characters in the team."] = "Appliquer les réglages à tous les personnages de l'équipe"
L["Team List"] = "Liste de l'équipe"
L["Up"] = "Haut"
L["Down"] = "Bas"
L["Set Master"] = "Maître"
L["Master Control"] = "Contrôle du maître"
L["When Focus changes, set the Master to the Focus."] = "Quand le focus change, le choisir comme maître"
L["When Master changes, promote Master to party"] = "Quand le maître change, le promouvoir chef"
L["leader."] = "de groupe"
L["Party Invitations Control"] = "Contrôle des invitations de groupe"
L["Accept from team."] = "Accepter de l'équipe"
L["Accept from friends."] = "Acceptert des amis"
L["Accept from guild."] = "Accepter de la guilde"
L["Decline from strangers."] = "Accepter des étrangers"
L["Party Loot Control"] = "Contrôle du butin de groupe"
L["Automatically set the Loot Method to..."] = "Changer automatiquement la méthode d'attribution en :"
L["Automatically set the Loot Method"] = "Changer automatiquement la méthode"
L["to..."] = "d'attribution en :"
L["Free For All"] = "Butin libre"
L["Master Looter"] = "Maître du butin"
L["Slaves Opt Out of Loot"] = "Les esclaves passent automatiquement"
L["Slave"] = "Esclave"
L["(Offline)"] = "(Hors-ligne)"
L["Enter name of character to add:"] = "Saisir le nom du personnage à ajouter :"
L["Are you sure you wish to remove %s from the team list?"] = "Etes-vous sûr(e) de vouloir enlever %s de l'équipe ?"
L["A is not in my team list.  I can not set them to be my master."] = function( characterName )
	return characterName.." n'est pas dans mon équipe.  Je ne peux pas le choisir comme maître."
end
L["Settings received from A."] = function( characterName )
	return "Réglages recus de "..characterName.."."
end
L["Jamba-Team"] ="Equipe Jamba"
L["Invite Team To Group"] = "Inviter l'équipe dans le groupe"
L["Disband Group"] = "Dégrouper"
L["Override: Set loot to Group Loot if stranger"] = "Forcer en butin de groupe si un étranger"
L["in group."] = "dans le groupe"
L["Add Party Members"] = "Ajouter des membres du groupe"
L["Add members in the current party to the team."] = "Ajouter les membres du le groupe actuel à l'équipe."
L["Friends Are Not Strangers"] = "Les amis ne sont pas étrangers"
end
