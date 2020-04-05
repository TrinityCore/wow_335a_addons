--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Macro", "frFR" )
if L then
L["Macro"] = true
L["Push Settings"] = "Transférer"
L["Push the macro settings to all characters in the team."] = "Transférer les réglages de macro à tous les personnages de l'équipe"
L["Settings received from A."] = function( characterName )
	return string.format( "Settings received from %s.", characterName )
end
L["Use"] = "Utiliser"
L["Add"] = "Ajouter"
L["Remove"] = "Supprimer"
L["Copy"] = "Copier"
L["Show"] = "Afficher"
L["Variable Sets"] = "Ensembles de variables"
L["Variables"] = "Variables"
L["Macro Sets"] = "Ensembles de macros"
L["Macros"] = "Macros"
L["Edit Variable"] = "Modifier variable"
L["Variable Name"] = "Nom de la variable"
L["Variable Value"] = "Valeur de la variable"
L["Variable Tag (prefix ! for not this tag)"] = "Label de variable (préfixe ! pour ne pas associer à ce label)"
L["Edit Macro"] = "Modifier macro"
L["Macro Name"] = "Nom de la macro"
L["Macro Text"] = "Texte de la macro"
L["Macro Key"] = "Raccourci clavier de la macro"
L["Macro Tag (prefix ! for not this tag)"] = "Label de la macro (préfixe ! pour ne pas associer à ce label)"
L["Macro: Macros"] = "Macro : Macros"
L["Macro: Variables"] = "Macro : Variables"
L["Macro Sets Control"] = "Contrôle des ensembles de macros"
L["Enable"] = "Activer"
L["Disable"] = "Désactiver"
L["Configure Macro Set"] = "Configurer l'ensemble de macros"
L["Variable Set"] = "Ensemble de variables"
L["Tag"] = "Label"
L["On"] = "Activé"
L["Off"] = "Désactivé"
L["Build Macros (Team)"] = "Générer macros (équipe)"
L["Enter name for this SET of variables:"] = "Saisir le nom de cet ensemble de variables :"
L['Are you sure you wish to remove "%s" from the variable SET list?'] = 'Etes-vous sûr(e) de vouloir supprimer "%s" de cet ensemble de variables ?'
L["Enter name for this variable:"] = "Saisir le nom de cette variable :"
L['Are you sure you wish to remove "%s" from the variable list?'] = 'Etes-vous sûr(e) de vouloir supprimer "%s" de cet ensemble de variables ?'
L["Enter name for this SET of macros:"] = "Entrer le nom de cet ensemble de macros :"
L['Are you sure you wish to remove "%s" from the macro SET list?'] = 'Etes-vous sûr(e) de vouloir supprimer "%s" de cet ensemble de macros ?'
L["Enter name for this macro:"] = "Saisir le nom de cette macro :"
L['Are you sure you wish to remove "%s" from the macro list?'] = 'Etes-vous sûr(e) de vouloir supprimer "%" de la liste des macros ?'
L["Enter name for the copy of this SET of variables:"] = "Saisir le nom de la copie de cet ensemble de variables :"
L["Enter name for the copy of this SET of macros:"] = "Saisie l nom de la copie de cet ensemble de macros :"
L["/click JMB_"] = "/click JMB_"
L["Macro Usage - press key assigned or copy /click below."] = "Utilisation de la macro - touche définie ou copiez la séquence /click :"
L["Use Macro and Variable Set"] = "Utiliser l'ensemble de macros et de variables"
L["Update the macros to use the specified macro and variable sets."] = "Mettre à jour les macros pour utiliser les ensemble de macros et de variables spéficiés."
L["Can not find macro set: X"] = function( macroSetName )
	return string.format( "Ne peut trouver l'ensemble de macros : %s", macroSetName )
end
L["Can not find variable set: X"] = function( variableSetName )
	return string.format( "Ne peut trouver l'ensemble de variables : %s", variableSetName )
end
L["Variable names must only be made up of letters and numbers."] = "Les noms de variables ne doivent être composés que de lettres et de chiffres."
L["Macro names must only be made up of letters and numbers."] = "Les nom de macros ne doivent être composés que de lettres et de chiffres."
L["Macro tags must only be made up of letters and numbers."] = "Les labels de macros ne doivent être composés que de lettres et de chiffres."
L["Please choose a macro set to use."] = "Choisissez svp l'ensemble de macro à utiliser."
L["Please choose a variable set to use."] = "Choisissez svp l'ensemble de variables à utiliser."
L["Using macros set: X"] = function( macroSetName )
	return string.format( "Utilisation de l'ensemble de macros : %s", macroSetName )
end
L["Using variables set: X"] = function( variableSetName )
	return string.format( "Utilisation de l'ensemble de variables : %s", variableSetName )
end
L["Actuellement en combat ; en attente de la fin du combat pour mettre à jour les macros."] = true
end
