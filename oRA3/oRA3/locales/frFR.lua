local L = LibStub("AceLocale-3.0"):NewLocale("oRA3", "frFR")
if not L then return end
-- Generic
L["Name"] = "Nom"
L["Checks"] = "Vérif."
L["Disband Group"] = "Dissoudre raid"
L["Disbands your current party or raid, kicking everyone from your group, one by one, until you are the last one remaining.\n\nSince this is potentially very destructive, you will be presented with a confirmation dialog. Hold down Control to bypass this dialog."] = "Dissout votre groupe ou raid actuel en renvoyant ses membres un par un jusqu'à ce que vous soyez le dernier présent.\n\nComme il s'agit d'une méthode radicale, une fenêtre de dialogue de confirmation vous sera présentée. Maintenez enfoncé la touche Contrôle pour éviter son apparition."
L["Options"] = "Options"
L["<oRA3> Disbanding group."] = "<oRA3> Dissolution du groupe de raid."
L["Are you sure you want to disband your group?"] = "Êtes-vous sûr de vouloir dissoudre votre groupe ?"
L["Unknown"] = "Inconnu"

-- Core

L["Open with raid pane"] = "Ouvrir avec le panneau de raid"
L.toggleWithRaidDesc = "Ouvre et ferme le panneau de oRA3 automatiquement en même temps que le panneau de raid de Blizzard. Si vous désactivez cette option, vous pouvez toujours ouvrir le panneau de oRA3 en utilisant son raccourci clavier ou une commande slash, telle que |cff44ff44/radur|r."
L["Show interface help"] = "Afficher l'aide de l'interface"
L.showHelpTextsDesc = "L'interface de oRA3 est remplie de textes d'aide permettant de mieux comprendre les différents éléments de l'interface. Désactiver cette option enlèvera ces textes, limitant l'encombrement sur chaque panneau. |cffff4411Nécessite parfois un rechargement de l'interface.|r"

L["Slash commands"] = "Commandes « / »"
L.slashCommands = [[
oRA3 supporte toute une série de commandes « / » (ou slash) pour vous aider rapidement en raid.

|cff44ff44/radur|r - ouvre la liste des durabilités.
|cff44ff44/razone|r - ouvre la liste des zones.
|cff44ff44/rares|r - ouvre la liste des résistances.
|cff44ff44/radisband|r - dissout instantanément le raid sans vérification.
|cff44ff44/raready|r - fait l'appel.
|cff44ff44/rainv|r - invite l'entièreté de la guilde dans votre groupe de raid.
|cff44ff44/razinv|r - invite les membres de la guilde situés dans votre zone.
|cff44ff44/rarinv <nom du rang>|r - invite les membres de la guilde du rang donné.
]]

-- Ready check module
L["The following players are not ready: %s"] = "Les joueurs suivants ne sont pas prêts : %s"
L["Ready Check (%d seconds)"] = "Appel (%d |4seconde:secondes;)"
L["Ready"] = "Prêt"
L["Not Ready"] = "Pas prêt"
L["No Response"] = "Pas de réponse"
L["Offline"] = "Hors ligne"
L["Play a sound when a ready check is performed."] = "Joue un son quand un appel est lancé."
L["Show window"] = "Afficher la fenêtre"
L["Show the window when a ready check is performed."] = "Affiche la fenêtre quand un appel est lancé."
L["Hide window when done"] = "Cacher la fenêtre une fois fini"
L["Automatically hide the window when the ready check is finished."] = "Cache automatiquement la fenêtre quand l'appel est terminé."
L["Hide players who are ready"] = "Cacher les joueurs qui sont prêts"
L["Hide players that are marked as ready from the window."] = "Enlève les joueurs qui sont prêt de la fenêtre."

-- Durability module
L["Durability"] = "Durabilité"
L["Average"] = "Moyenne"
L["Broken"] = "Cassé"
L["Minimum"] = "Minimum"

-- Resistances module
L["Resistances"] = "Résistances"
L["Frost"] = "Givre"
L["Fire"] = "Feu"
L["Shadow"] = "Ombre"
L["Nature"] = "Nature"
L["Arcane"] = "Arcanes"

-- Invite module
L["Invite"] = "Invit."
L["All max level characters will be invited to raid in 10 seconds. Please leave your groups."] = "Tous les personnages de niveau maximal seront invités dans le raid dans 10 sec. Veuillez quitter vos groupes."
L["All characters in %s will be invited to raid in 10 seconds. Please leave your groups."] = "Tous les personnages se trouvant à %s seront invités dans le raid rans 10 sec. Veuillez quitter vos groupes."
L["All characters of rank %s or higher will be invited to raid in 10 seconds. Please leave your groups."] = "Tous les personnages de rang %s ou supérieur seront invités dans le raid dans 10 sec. Veuillez quitter vos groupes." 
L["<oRA3> Sorry, the group is full."] = "<oRA3> Désolé, le groupe de raid est complet."
L["Invite all guild members of rank %s or higher."] = "Invite tous les membres de votre guilde ayant le rang %s ou supérieur."
L["Keyword"] = "Mot-clé"
L["When people whisper you the keywords below, they will automatically be invited to your group. If you're in a party and it's full, you will convert to a raid group. The keywords will only stop working when you have a full raid of 40 people. Setting a keyword to nothing will disable it."] = "Toute personne vous chuchotant un des mots-clés ci-dessous sera automatiquement invité dans votre groupe de raid. Si vous êtes dans un groupe complet, ce dernier sera converti en groupe de raid. Le mot-clé cessera de fonctionner une fois le groupe de raid complet. Ne mettez rien comme mots-clés pour désactiver cette fonction."
L["Anyone who whispers you this keyword will automatically and immediately be invited to your group."] = "Toute personne qui vous chuchote ce mot-clé sera automatiquement et immédiatement invité dans votre groupe de raid."
L["Guild Keyword"] = "Mot-clé de guilde"
L["Any guild member who whispers you this keyword will automatically and immediately be invited to your group."] = "Tout membre de votre guilde qui vous chuchote ce mot-clé sera automatiquement et immédiatement invité dans votre groupe de raid."
L["Invite guild"] = "Inviter la guilde"
L["Invite everyone in your guild at the maximum level."] = "Invite tous les membres de votre guilde de niveau maximal."
L["Invite zone"] = "Inviter la zone"
L["Invite everyone in your guild who are in the same zone as you."] = "Invite tous les membres de votre guilde se trouvant dans la même zone que vous."
L["Guild rank invites"] = "Invitation selon le rang de guilde"
L["Clicking any of the buttons below will invite anyone of the selected rank AND HIGHER to your group. So clicking the 3rd button will invite anyone of rank 1, 2 or 3, for example. It will first post a message in either guild or officer chat and give your guild members 10 seconds to leave their groups before doing the actual invites."] = "En cliquant sur un des boutons ci-dessous, vous inviterez toutes les personnes du rang choisi ainsi que ceux des rangs SUPÉRIEURS dans votre groupe de raid. Un délai de 10 secondes est accordé avant l'envoi des invitations."

-- Promote module
L["Demote everyone"] = "Dégrader tout le monde"
L["Demotes everyone in the current group."] = "Dégrade toutes les personnes présentes dans le groupe actuel."
L["Promote"] = "Nomination"
L["Mass promotion"] = "Nomination en masse"
L["Everyone"] = "Tout le monde"
L["Promote everyone automatically."] = "Nomme automatiquement assistants tout le monde."
L["Guild"] = "Guilde"
L["Promote all guild members automatically."] = "Nomme automatiquement assistants tous les membres de votre guilde."
L["By guild rank"] = "Par rang de guilde"
L["Individual promotions"] = "Promotions individuelles"
L["Note that names are case sensitive. To add a player, enter a player name in the box below and hit Enter or click the button that pops up. To remove a player from being promoted automatically, just click his name in the dropdown below."] = "Notez que les noms sont sensibles à la casse. Pour ajouter un joueur, entrez son nom dans la boîte de saisie ci-dessous et appuyez sur Entrée ou cliquez sur le bouton qui apparaît. Pour enlever un joueur, cliquez tout simplement sur son nom dans le menu déroulant ci-dessous."
L["Add"] = "Ajouter"
L["Remove"] = "Enlever"

-- Cooldowns module
L["Open monitor"] = "Ouvrir le moniteur"
L["Cooldowns"] = "Recharges"
L["Monitor settings"] = "Paramètres du moniteur"
L["Show monitor"] = "Afficher le moniteur"
L["Lock monitor"] = "Verrouiller le moniteur"
L["Show or hide the cooldown bar display in the game world."] = "Affiche ou non l'affichage des temps de recharge via des barres."
L["Note that locking the cooldown monitor will hide the title and the drag handle and make it impossible to move it, resize it or open the display options for the bars."] = "Notez que le verrouillage du moniteur des temps de regarde cachera le titre et la poignée de saisie, rendant ainsi le moniteur impossible à déplacer ou à redimensionner. Il ne sera également pas possible d'ouvrir le menu des options des barres."
L["Only show my own spells"] = "Afficher uniquement mes propres sorts"
L["Toggle whether the cooldown display should only show the cooldown for spells cast by you, basically functioning as a normal cooldown display addon."] = "Affiche ou non uniquement les temps de recharge concernant votre personnage."
L["Cooldown settings"] = "Paramètres des temps de recharge"
L["Select which cooldowns to display using the dropdown and checkboxes below. Each class has a small set of spells available that you can view using the bar display. Select a class from the dropdown and then configure the spells for that class according to your own needs."] = "Choississez les temps de recharge à afficher en vous aidant du menu déroulant et des cases à cocher ci-dessous. Chaque classe possède un nombre limité de sorts que vous pouvez voir via l'affichage par barres. Choissisez une classe via le menu déroulant et configurer ses sorts selon vos besoins."
L["Select class"] = "Choix de la classe"
L["Never show my own spells"] = "Ne jamais afficher mes propres sorts"
L["Toggle whether the cooldown display should never show your own cooldowns. For example if you use another cooldown display addon for your own cooldowns."] = "Enlève ou non vos propres temps de recharge de l'affichage des temps de recharge. À cocher par exemple si vous utilisez un autre addon pour afficher vos temps de recharge."

-- monitor
L["Cooldowns"] = "Recharge"
L["Right-Click me for options!"] = "Clic droit pour les options !"
L["Bar Settings"] = "Paramètres des barres"
L["Spawn test bar"] = "Afficher une barre de test"
L["Use class color"] = "Couleur de classe"
L["Custom color"] = "Couleur personnalisée"
L["Height"] = "Hauteur"
L["Scale"] = "Échelle"
L["Texture"] = "Texture"
L["Icon"] = "Icône"
L["Show"] = "Afficher"
L["Duration"] = "Durée"
L["Unit name"] = "Nom unité"
L["Spell name"] = "Nom du sort"
L["Short Spell name"] = "Nom des sorts raccourcis"
L["Label Align"] = "Alignement du libellé"
L["Left"] = "Gauche"
L["Right"] = "Droite"
L["Center"] = "Centre"
L["Grow up"] = "Ajouter vers le haut"

-- Zone module
L["Zone"] = "Zone"

-- Loot module
L["Leave empty to make yourself Master Looter."] = "Laissez vide pour faire de vous le maître du butin."
L["Let oRA3 to automatically set the loot mode to what you specify below when entering a party or raid."] = "Laisse oRA3 définir automatiquement la méthode de fouille selon ce que vous avez spécifié ci-dessous quand vous entrez dans un groupe (de raid)."
L["Set the loot mode automatically when joining a group"] = "Définir auto. le mode du butin en rejoignant un groupe"

-- Tanks module
L["Tanks"] = "Tanks"
L.tankTabTopText = "Cliquez sur les joueurs de la liste du bas pour les nommer tank personnel. Si vous souhaitez obtenir de l'aide, survolez le '?' avec votre souris."
-- L["Remove"] is defined above
L.deleteButtonHelp = "Enlève ce joueur de la liste des tanks."
L["Blizzard Main Tank"] = "Tank principal Blizzard"
L.tankButtonHelp = "Définit ou non ce joueur comme étant un tank principal Blizzard."
L["Save"] = "Sauver"
L.saveButtonHelp = "Sauvegarde ce tank dans votre liste personnelle. Chaque fois que vous serez groupé avec ce joueur, il sera indiqué comme étant un tank personnel."
L["What is all this?"] = "Qu'est-ce que tout cela ?"
L.tankHelp = "Les joueurs de la liste du haut sont vos tanks personnels triés. Ils ne sont pas partagés avec le raid, et tout le monde peut avoir une liste de tanks personnelle différente. Cliquer sur un nom de la liste du bas permet d'ajouter le joueur dans votre liste personnelle.\n\nCliquer sur l'icône en forme de bouclier ajoutera cette personne dans la liste des tanks principaux de Blizzard. Les tanks de Blizzard sont partagées entre tous les membres de votre raid et vous devez être au moins assistant pour faire cela.\n\nLes tanks qui apparaissent dans la liste car ajoutés par quelqu'un d'autre dans la liste des tanks principaux de Blizzard seront enlevés de la liste une fois qu'ils ne sont plus des tanks principaux de Blizzard.\n\nUtiliser la coche pour sauvegarder un tank entre les sessions. La prochaine fois que vous serez dans un raid avec cette personne, il sera automatiquement définit comme étant un tank personnel."
L["Sort"] = "Trier"
L["Click to move this tank up."] = "Cliquez pour faire monter ce tank."
L["Show"] = "Afficher"
L.showButtonHelp = "Affiche ce tank dans votre affichage des tanks personnels. Cette option n'a des effets que localement et ne changera pas son statut de tank pour tous les autres membres du groupe."
