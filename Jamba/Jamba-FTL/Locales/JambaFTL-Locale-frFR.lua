-- Author      : olipcs
-- Create Date : 8/12/2009 
-- Version : 0.1
-- Credits: Many thanks goes to Jafula for the awsome JAMBA addon
--          Nearly all code where copy & pasted from Jafulas JAMBA 0.5 addon,
--          and only small additions where coded by me.
--          So again, many thanks Jafula, for making the Jamba 0.5 API so simple to use!     

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-FTL", "frFR" )
if L then
L["FTL Helper"] = "Assistant FTL"
L["FTL Helper Options"] = "Options de l'assistant FTL"
L["Don't differenciate between left/right modifier states"] = "Ne pas différencier les touches mod. gauche/droite"
L["If this Option is checked only plain modifiers like shift,alt,ctrl are used for FTL and not theri left/right versions. Hint: If you use Keyclone you miht have to check this!."] = "Si cette option est activée, seuls les touches modificatrices simples comme shift,alt,ctrl sont utilisées pour le FTL et non leurs versions gauche/droite. Conseil : vous devre peut-être activer ceci si vous utilisez Keyclone !"
L["Push Settings"] = "Transférer"
L["Push the FTL settings to all characters in the team."] = "Transférer les réglages FTL à tous les personnages de l'équipe."
L["Settings received from A."] = function( characterName )
	return "Réglages reçus de "..characterName.."."
end
L["I am unable to fly to A."] = function( nodename )
	return "Je ne peux pas voler vers "..nodename.."."
end
L[" "] = " "
L["Information"] = "Information"
L["Use left shift"] = "Utiliser shift gauche"
L["Use left alt"] = "Utiliser alt gauche"
L["Use left ctrl"] = "Utiliser ctrl gauche"
L["Use right shift"] = "Utiliser shift droite"
L["Use right alt"] = "Utiliser alt droite"
L["Use right ctrl"] = "Utiliser ctrl droite"
L["Team List"] = "Liste de l'équipe"
L["Modifiers to use for selected toon"] = "Touches modificatrices à utiliser pour le personnage sélectionné"
L["Options"] = "Options"
L["If a modifier isn't used in a team, don't include it."] = "Ne pas inclure toute touche mod. non utilisée"
L["Create / Update FTL Buttons"] = "Créer / mettre à jour les boutons FTL"
L["Only use Toons which are online"] = "Utiliser uniquement les personnages en ligne"
L["Use selected Toon in FTL"] = "Utiliser uniquement le personnage sélectionné en FTL"
L["Update FTL-Button"] = "Mettre à jour le bouton FTL"
L["Updates the FTL-Button on all Team members"] = "Mettre à jour le bouton FTL pour tous les membres de l'équipe"
L["Hint:Use the buttons by: /click JambaFTLAssist or /click JambaFTLTarget"] = "Conseil : utiliser les boutons via /click JambaFTLAssist ou /click JambaFTLTarget"
end
