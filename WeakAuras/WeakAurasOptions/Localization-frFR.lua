if not(GetLocale() == "frFR") then
    return;
end

local L = WeakAuras.L

-- Options translation
L["1 Match"] = "1 Correspondance"
L["Actions"] = "Actions"
L["Activate when the given aura(s) |cFFFF0000can't|r be found"] = "Activer quand l'aura |cFFFF0000ne peut|r être trouvée"
L["Add a new display"] = "Ajouter un nouveau graphique"
L["Add Dynamic Text"] = "Ajouter du texte dynamique"
L["Addon"] = "Addon"
L["Addons"] = "Addons"
L["Add to group %s"] = "Ajouter au groupe %s"
L["Add to new Dynamic Group"] = "Ajouter à un nouveau groupe dynamique"
L["Add to new Group"] = "Ajouter à un nouveau groupe"
L["Add Trigger"] = "Ajouter un déclencheur"
L["A group that dynamically controls the positioning of its children"] = "Un groupe qui contrôle dynamiquement le positionnement de ses enfants"
L["Align"] = "Aligner"
L["Allow Full Rotation"] = "Permettre une rotation complète"
L["Alpha"] = "Alpha"
L["Anchor"] = "Ancrage"
L["Anchor Point"] = "Point d'ancrage"
L["Angle"] = "Angle"
L["Animate"] = "Animer"
L["Animated Expand and Collapse"] = "Expansion et réduction animés"
L["Animation relative duration description"] = [=[La durée de l'animation par rapport à la durée du graphique, exprimée en fraction (1/2), pourcentage (50%), ou décimal (0.5).
|cFFFF0000Note :|r si un graphique n'a pas de progression (déclencheur d'événement sans durée définie, aura sans durée, etc), l'animation ne jouera pas.

|cFF4444FFPar exemple :|r
Si la durée de l'animation est définie à |cFF00CC0010%|r, et le déclencheur du graphique est une amélioration qui dure 20 secondes, l'animation de début jouera pendant 2 secondes.
Si la durée de l'animation est définie à |cFF00CC0010%|r, et le déclencheur du graphique n'a pas de durée définie, aucune d'animation de début ne jouera (mais elle jouerait si vous aviez spécifié une durée en secondes).
]=]
L["Animations"] = "Animations"
L["Animation Sequence"] = "Séquence d'animation"
L["Aquatic"] = "Aquatique"
L["Aura (Paladin)"] = "Aura (Paladin)"
L["Aura(s)"] = "Aura(s)"
L["Auto"] = "Auto"
L["Auto-cloning enabled"] = "Auto-clonage activé"
L["Automatic Icon"] = "Icône automatique"
L["Backdrop Color"] = "Couleur de Fond"
L["Backdrop Style"] = "Style de Fond"
L["Background"] = "Arrière-plan"
L["Background Color"] = "Couleur de fond"
L["Background Inset"] = "Encart d'arrière-plan"
L["Background Offset"] = "Décalage du Fond "
L["Background Texture"] = "Texture du Fond"
L["Bar Alpha"] = "Alpha de la Barre"
L["Bar Color"] = "Couleur de barre"
L["Bar Color Settings"] = "Réglages Couleur de Barre"
L["Bar in Front"] = "Barre devant"
L["Bar Texture"] = "Texture de barre"
L["Battle"] = "Combat"
L["Bear"] = "Ours"
L["Berserker"] = "Berserker"
L["Blend Mode"] = "Mode du fusion"
L["Blood"] = "Sang"
L["Border"] = "Bordure"
L["Border Color"] = "Couleur de Bordure"
L["Border Inset"] = "Encart Fond"
L["Border Offset"] = "Décalage Bordure"
L["Border Settings"] = "Réglages de Bordure"
L["Border Size"] = "Taille de Bordure"
L["Border Style"] = "Style de Bordure"
L["Bottom Text"] = "Texte du bas"
L["Button Glow"] = "Bouton allumé"
L["Can be a name or a UID (e.g., party1). Only works on friendly players in your group."] = "Peut être un nom ou un UID (par ex. party1). Fonctionne uniquement pour les joueurs amicaux de votre groupe."
L["Cancel"] = "Annuler"
L["Cat"] = "Chat"
L["Change the name of this display"] = "Changer le nom de ce graphique"
L["Channel Number"] = "Numéro de canal"
L["Check On..."] = "Vérifier sur..."
L["Choose"] = "Choisir"
L["Choose Trigger"] = "Choisir un déclencheur"
L["Choose whether the displayed icon is automatic or defined manually"] = "Choisir si l'icône affichée est automatique ou définie manuellement"
L["Clone option enabled dialog"] = [=[
Vous avez activé une option qui utilise l'|cFFFF0000Auto-clonage|r.

L'|cFFFF0000Auto-clonage|r permet à un graphique d'être automatiquement dupliqué pour afficher plusieurs sources d'information.
A moins que vous mettiez ce graphique dans un |cFF22AA22Groupe Dynamique|r, tous les clones seront affichés en tas l'un sur l'autre.

Souhaitez-vous que ce graphiques soit placé dans un nouveau |cFF22AA22Groupe Dynamique|r ?]=]
L["Close"] = "Fermer"
L["Collapse"] = "Réduire"
L["Collapse all loaded displays"] = "Réduire tous les graphiques chargés"
L["Collapse all non-loaded displays"] = "Réduire tous les graphiques non-chargés"
L["Color"] = "Couleur"
L["Compress"] = "Compresser"
L["Concentration"] = "Concentration"
L["Constant Factor"] = "Facteur constant"
L["Control-click to select multiple displays"] = "Contrôle-Clic pour sélectionner plusieurs graphiques"
L["Controls the positioning and configuration of multiple displays at the same time"] = "Contrôle la position et la configuration de plusieurs graphiques en même temps"
L["Convert to..."] = "Convertir en..."
L["Cooldown"] = "Recharge"
L["Copy"] = "Copier"
L["Copy settings from..."] = "Copier les réglages de..."
L["Copy settings from another display"] = "Copier les réglages d'un autre graphique"
L["Copy settings from %s"] = "Copier les réglages de %s"
L["Count"] = "Compte"
L["Creating buttons: "] = "Création de boutons :"
L["Creating options: "] = "Création d'options :"
L["Crop X"] = "Couper X"
L["Crop Y"] = "Couper Y"
L["Crusader"] = "Croisé"
L["Custom Code"] = "Code personnalisé"
L["Custom Trigger"] = "Déclencheur personnalisé"
L["Custom trigger event tooltip"] = [=[
Choisissez quels évènements peuvent activer le déclencheur.
Plusieurs évènements peuvent être spécifiés avec des virgules ou des espaces.

|cFF4444FFPar exemple:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED
]=]
L["Custom trigger status tooltip"] = [=[
Choisissez quels évènements peuvent activer le déclencheur.
Comme c'est un déclencheur de type statut, les évènements spécifiés peuvent être appelés par WeakAuras sans les arguments attendus.
Plusieurs évènements peuvent être spécifiés avec des virgules ou des espaces.

|cFF4444FFPar exemple:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED
]=]
L["Custom Untrigger"] = "Désactivation personnalisée"
L["Custom untrigger event tooltip"] = [=[
Choisissez quels évènements peuvent causer la désactivation.
Cela peut être des évènements différents de ceux du déclencheur.
Plusieurs évènements peuvent être spécifiés avec des virgules ou des espaces.

|cFF4444FFPar exemple:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED
]=]
L["Death"] = "Mort"
L["Death Rune"] = "Rune de Mort"
L["Debuff Type"] = "Type d'affaiblissement"
L["Defensive"] = "Défensif"
L["Delete"] = "Supprimer"
L["Delete all"] = "Supprimer tout"
L["Delete children and group"] = "Supprimer enfants et groupe"
L["Deletes this display - |cFF8080FFShift|r must be held down while clicking"] = "Supprime ce graphique - |cFF8080FFMaj|r doit être maintenu en cliquant"
L["Delete Trigger"] = "Supprimer le déclencheur"
L["Desaturate"] = "Dé-saturer"
L["Devotion"] = "Dévotion"
L["Disabled"] = "Désactivé"
L["Discrete Rotation"] = "Rotation individuelle"
L["Display"] = "Graphique"
L["Display Icon"] = "Icône du graphique"
L["Display Text"] = "Texte du graphique"
L["Distribute Horizontally"] = "Distribuer horizontalement"
L["Distribute Vertically"] = "Distribuer verticalement"
L["Do not copy any settings"] = "Ne copier aucun réglage"
L["Do not group this display"] = "Ne pas grouper ce graphique"
L["Duplicate"] = "Dupliquer"
L["Duration Info"] = "Info de durée"
L["Duration (s)"] = "Durée (s)"
L["Dynamic Group"] = "Groupe Dynamique"
L["Dynamic text tooltip"] = [=[
Il y a plusieurs codes spéciaux disponibles pour rendre ce texte dynamique :

|cFFFF0000%p|r - Progression - Le temps restant sur un compteur, ou une valeur autre
|cFFFF0000%t|r - Total - La durée maximum d'un compteur, ou le maximum d'une valeur autre
|cFFFF0000%n|r - Nom - Le nom du graphique (souvent le nom d'une aura), ou l'ID du graphique s'il n'y a pas de nom dynamique
|cFFFF0000%i|r - Icône - L'icône associée à l'affichage
|cFFFF0000%s|r - Pile - La taille de la pile d'une aura (généralement)
|cFFFF0000%c|r - Personnalisé - Vous permet de définir une fonction Lua personnalisée qui donne un texte à afficher]=]
L["Enabled"] = "Activé"
L["Enter an aura name, partial aura name, or spell id"] = "Entrez un nom d'aura, nom d'aura partiel ou ID de sort"
L["Event Type"] = "Type d'évènement"
L["Expand"] = "Agrandir"
L["Expand all loaded displays"] = "Agrandir tous graphiques chargés"
L["Expand all non-loaded displays"] = "Agrandir tous graphiques non-chargés"
L["Expand Text Editor"] = "Agrandir éditeur de texte"
L["Expansion is disabled because this group has no children"] = "Agrandissement désactivé car ce groupe n'a pas d'enfants"
L["Export"] = "Exporter"
L["Export to Lua table..."] = "Exporter une table Lua..."
L["Export to string..."] = "Exporter en texte..."
L["Fade"] = "Fondu"
L["Finish"] = "Finir"
L["Fire Resistance"] = "Résistance au Feu"
L["Flight(Non-Feral)"] = "Vol(non-Féral)"
L["Font"] = "Police"
L["Font Flags"] = "Style de Police"
L["Font Size"] = "Taille de Police"
L["Font Type"] = "Type de police"
L["Foreground Color"] = "Couleur premier-plan"
L["Foreground Texture"] = "Texture premier-plan"
L["Form (Druid)"] = "Forme (Druide)"
L["Form (Priest)"] = "Forme (Prêtre)"
L["Form (Shaman)"] = "Forme (Chaman)"
L["Form (Warlock)"] = "Forme (Démoniste)"
L["Frame"] = "Cadre"
L["Frame Strata"] = "Strate du cadre"
L["Frost"] = "Givre"
L["Frost Resistance"] = "Résistance au Givre"
L["Full Scan"] = "Scan Complet"
L["Ghost Wolf"] = "Loup fantôme"
L["Glow Action"] = "Action de l'éclat"
L["Group aura count description"] = [=[Le nombre de membres du %s qui doivent être affectés par une ou plus des auras désignées pour que le graphique soit déclenché.
Si le nombre entré est un entier (par ex. 5), le nombre de membres du raid affectés sera comparé au nombre entré.
Si le nombre entré est decimal (par ex. 0.5), une fraction (par ex. 1/2), ou un pourcentage (par ex. 50%%), alors cette fraction du %s doit être affecté.

|cFF4444FFPar exemple :|r
|cFF00CC00> 0|r le déclenchera quand n'importe qui du %s est affecté
|cFF00CC00= 100%%|r le déclenchera quand tout le monde dans le %s est affecté
|cFF00CC00!= 2|r le déclenchera quand le nombre de membres du %s affectés est différent de 2
|cFF00CC00<= 0.8|r le déclenchera quand quand moins de 80%% du %s est affecté (4 sur 5 membres du groupe, 8 sur 10 ou 20 sur 25 du raid )
|cFF00CC00> 1/2|r le déclenchera quand plus de la moitié du %s est affecté
|cFF00CC00>= 0|r le déclenchera toujours, quoi qu'il arrive
]=]
L["Group Member Count"] = "Nombre de membres du groupe"
L["Group (verb)"] = "Grouper"
L["Height"] = "Hauteur"
L["Hide this group's children"] = "Cacher les enfants de ce groupe"
L["Hide When Not In Group"] = "Cacher hors d'un groupe"
L["Horizontal Align"] = "Aligner horizontalement"
L["Icon Info"] = "Info d'icône"
L["Ignored"] = "Ignoré"
L["Ignore GCD"] = "Ignorer Recharge Globale"
L["%i Matches"] = "%i Correspondances"
L["Import"] = "Importer"
L["Import a display from an encoded string"] = "Importer un graphique d'un texte encodé"
L["Justify"] = "Justification"
L["Left Text"] = "Texte de gauche"
L["Load"] = "Charger"
L["Loaded"] = "Chargé"
L["Main"] = "Principal"
L["Main Trigger"] = "Déclencheur principal"
L["Mana (%)"] = "Mana (%)"
L["Manage displays defined by Addons"] = "Gérer graphiques définis par addons"
L["Message Prefix"] = "Préfixe du message"
L["Message Suffix"] = "Suffixe du message"
L["Metamorphosis"] = "Métamorphose"
L["Mirror"] = "Miroir"
L["Model"] = "Modèle"
L["Moonkin/Tree/Flight(Feral)"] = "Sélénien/Arbre/Vol(Farouche)"
L["Move Down"] = "Descendre"
L["Move this display down in its group's order"] = "Descend ce graphique dans l'ordre de son groupe"
L["Move this display up in its group's order"] = "Monte ce graphique dans l'ordre de son groupe"
L["Move Up"] = "Monter"
L["Multiple Displays"] = "Graphiques multiples"
L["Multiple Triggers"] = "Déclencheur multiples"
L["Multiselect ignored tooltip"] = [=[
|cFFFF0000Ignoré|r - |cFF777777Unique|r - |cFF777777Multiple|r
Cette option ne sera pas utilisée pour déterminer quand ce graphique doit être chargé]=]
L["Multiselect multiple tooltip"] = [=[
|cFF777777Ignoré|r - |cFF777777Unique|r - |cFF00FF00Multiple|r
Plusieurs valeurs peuvent être choisies]=]
L["Multiselect single tooltip"] = [=[
|cFF777777Ignoré|r - |cFF00FF00Unique|r - |cFF777777Multiple|r
Seule une unique valeur peut être choisie]=]
L["Must be spelled correctly!"] = "Doit être épelé correctement !"
L["Name Info"] = "Info du nom"
L["Negator"] = "Pas"
L["New"] = "Nouveau"
L["Next"] = "Suivant"
L["No"] = "Non"
L["No Children"] = "Pas d'enfant"
L["Not all children have the same value for this option"] = "Tous les enfants n'ont pas la même valeur pour cette option"
L["Not Loaded"] = "Non chargé"
L["No tooltip text"] = "Pas d'infobulle"
L["% of Progress"] = "% de progression"
L["Okay"] = "Okay"
L["On Hide"] = "Au masquage"
L["Only match auras cast by people other than the player"] = "Ne considérer que les auras lancées par d'autres que le joueur"
L["Only match auras cast by the player"] = "Ne considérer que les auras lancées par le joueur"
L["On Show"] = "A l'affichage"
L["Operator"] = "Opérateur"
L["or"] = "ou"
L["Orientation"] = "Orientation"
L["Other"] = "Autre"
L["Outline"] = "Contour"
L["Own Only"] = "Le mien uniquement"
L["Player Character"] = "Personnage Joueur"
L["Play Sound"] = "Jouer un son"
L["Presence (DK)"] = "Présence"
L["Presence (Rogue)"] = "Présence"
L["Prevents duration information from decreasing when an aura refreshes. May cause problems if used with multiple auras with different durations."] = "Empêche l'info de durée de décroitre quand une aura est rafraichie. Peut causer des problèmes si utilisé avec plusieurs auras de différentes durées."
L["Primary"] = "Primaire"
L["Progress Bar"] = "Barre de progression"
L["Progress Texture"] = "Texture de progression"
L["Put this display in a group"] = "Mettre ce graphique dans un groupe"
L["Ready For Use"] = "Prêt à l'emploi"
L["Re-center X"] = "Recentrer X"
L["Re-center Y"] = "Recentrer Y"
L["Remaining Time Precision"] = "Précision du temps restant"
L["Remove this display from its group"] = "Retirer ce graphique de son groupe"
L["Rename"] = "Renommer"
L["Requesting display information"] = "Demande d'info de graphique à %s..."
L["Required For Activation"] = "Requis pour l'activation"
L["Retribution"] = "Vindicte"
L["Right-click for more options"] = "Clic-droit pour plus d'options"
L["Right Text"] = "Texte de droite"
L["Rotate"] = "Tourner"
L["Rotate In"] = "Rotation entrante"
L["Rotate Out"] = "Rotation sortante"
L["Rotate Text"] = "Tourner le texte"
L["Rotation"] = "Rotation"
L["Same"] = "Le même"
L["Search"] = "Chrecher"
L["Secondary"] = "Secondaire"
L["Send To"] = "Envoyer vers"
L["Set tooltip description"] = "Définir description d'infobulle"
L["Shadow Dance"] = "Danse de l'ombre"
L["Shadowform"] = "Forme d'Ombre"
L["Shadow Resistance"] = "Résistance à l'Ombre"
L["Shift-click to create chat link"] = "Maj-Clic pour créer un |cFF8800FF[Lien]"
L["Show all matches (Auto-clone)"] = "Montrer toutes correspondances (Auto-Clone)"
L["Show players that are |cFFFF0000not affected"] = "Montrer les joueurs |cFFFF0000non-affectés"
L["Shows a 3D model from the game files"] = "Montre un modèle 3D tiré du jeu"
L["Shows a custom texture"] = "Montre une texture personnalisée"
L["Shows a progress bar with name, timer, and icon"] = "Affiche une barre de progression avec nom, temps, icône"
L["Shows a spell icon with an optional a cooldown overlay"] = "Affiche une icône de sort avec optionnellement la recharge sur-imprimée"
L["Shows a texture that changes based on duration"] = "Affiche une texture qui change selon la durée"
L["Shows one or more lines of text, which can include dynamic information such as progress or stacks"] = "Affiche une ligne de texte ou plus, qui peut inclure des infos dynamiques telles que progression ou piles."
L["Shows the remaining or expended time for an aura or timed event"] = "Affiche le temps restant ou étendu d'une aura ou évènement"
L["Show this group's children"] = "Montrer les enfants de ce groupe"
L["Size"] = "Taille"
L["Slide"] = "Glisser"
L["Slide In"] = "Glisser entrant"
L["Slide Out"] = "Glisser sortant"
L["Sort"] = "Trier"
L["Sound"] = "Son"
L["Sound Channel"] = "Canal sonore"
L["Sound File Path"] = "Chemin fichier son"
L["Space"] = "Espacer"
L["Space Horizontally"] = "Espacer horizontalement"
L["Space Vertically"] = "Espacer verticalement"
L["Spell ID"] = "ID de sort"
L["Spell ID dialog"] = [=[Vous avez spécifié une aura par |cFFFF0000ID de sort|r.

Par défaut, |cFF8800FFWeakAuras|r ne peut distinguer entre des auras de même nom mais d'|cFFFF0000ID de sort|r différents.
Cependant, si l'option Scan Complet est activée, |cFF8800FFWeakAuras|r peut chercher des |cFFFF0000ID de sorts|r spécifiques.

Voulez-vous activer le Scan Complet pour chercher cet |cFFFF0000ID de sort|r ?]=]
L["Stack Count"] = "Nombre de Piles"
L["Stack Count Position"] = "Position Nombre de Piles"
L["Stack Info"] = "Info de Piles"
L["Stacks Settings"] = "Réglages de Piles"
L["Stagger"] = "Report"
L["Stance (Warrior)"] = "Posture"
L["Start"] = "Début"
L["Stealable"] = "Volable"
L["Stealthed"] = "Furtif"
L["Sticky Duration"] = "Durée épinglée"
L["Temporary Group"] = "Groupe temporaire"
L["Text"] = "Texte"
L["Text Color"] = "Couleur Texte"
L["Text Position"] = "Position Texte"
L["Text Settings"] = "Réglages de Texte"
L["Texture"] = "Texture"
L["The children of this group have different display types, so their display options cannot be set as a group."] = "Les enfants de ce groupe ont différent types de graphiques, leurs options de graphique ne peuvent donc pas être changées en groupe."
L["The duration of the animation in seconds."] = "La durée de l'animation en secondes."
L["The type of trigger"] = "Le type de déclencheur"
L["This condition will not be tested"] = "Cette condition ne sera pas évaluée"
L["This display is currently loaded"] = "Ce graphique est actuellement chargé"
L["This display is not currently loaded"] = "Ce graphique n'est pas actuellement chargé"
L["This display will only show when |cFF00FF00%s"] = "Ce graphique ne s'affichera que quand |cFF00FF00%s"
L["This display will only show when |cFFFF0000 Not %s"] = "Ce graphique ne s'affichera que quand |cFFFF0000 Pas %s"
L["This region of type \"%s\" has no configuration options."] = "Cette région de type \"%s\" n'a pas d'options de configuration."
L["Time in"] = "Temps entrant"
L["Timer"] = "Chrono"
L["Timer Settings"] = "Réglages de Chrono"
L["Toggle the visibility of all loaded displays"] = "Change la visibilité de tous les graphiques chargés"
L["Toggle the visibility of all non-loaded displays"] = "Change la visibilité de tous les graphiques non-chargés"
L["Toggle the visibility of this display"] = "Change la visibilité de ce graphique"
L["to group's"] = "au groupe..."
L["Tooltip"] = "Infobulle"
L["Tooltip on Mouseover"] = "Infobulle à la souris"
L["Top Text"] = "Texte du Haut"
L["to screen's"] = "à l'écran..."
L["Total Time Precision"] = "Précision Temps total"
L["Tracking"] = "Suivi"
L["Travel"] = "Voyage"
L["Trigger"] = "Déclencheur"
L["Trigger %d"] = "Déclencheur %d"
L["Triggers"] = "Déclencheurs"
L["Type"] = "Type"
L["Ungroup"] = "Dégrouper"
L["Unholy"] = "Impie"
L["Unit Exists"] = "L'unité existe"
L["Unlike the start or finish animations, the main animation will loop over and over until the display is hidden."] = "Contrairement aux animations de début et de fin, l'animation principale bouclera tant que le graphique est visible."
L["Unstealthed"] = "Fin de furtivité"
L["Update Custom Text On..."] = "Mettre à jour Texte Perso sur..."
L["Use Full Scan (High CPU)"] = "Utiliser Scan Complet (CPU élevé)"
L["Use tooltip \"size\" instead of stacks"] = "Utiliser la \"taille\" de l'infobulle plutôt que la pile"
L["Vertical Align"] = "Aligner verticalement"
L["View"] = "Vue"
L["Width"] = "Largeur"
L["X Offset"] = "Décalage X"
L["X Scale"] = "Echelle X"
L["Yes"] = "Oui"
L["Y Offset"] = "Décalage Y"
L["Y Scale"] = "Echelle Y"
L["Z Offset"] = "Décalage Z"
L["Zoom"] = "Zoom"
L["Zoom In"] = "Zoom entrant"
L["Zoom Out"] = "Zoom sortant"



