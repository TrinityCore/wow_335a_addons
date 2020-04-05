local Root = BossEncounter2;

-- --------------------------------------------------------------------
-- **                     Localisation data                          **
-- --------------------------------------------------------------------

-- Test command
-- local GetLocale = function() return "enUS"; end

-- For module specific localizations, put them in the dedicated localization table of the said module.

local MISSING_TRANSLATION = "%s"; -- Leave this one in English.

local modLocale = {
    ["default"] = {
        -- Widgets
        ["Settings"] = "Settings",
        ["SettingLock"] = "\n\n|cffff0000You can't change this option, maybe because you do not have the permission to do so. Try getting a promote.|r",
        ["SettingOne"] = "\n\n|cff00ff00Only one person in the raid can have this option enabled during the fight. Users of the newest version will have priority.|r",
        ["SettingPerCharacter"] = "\n\n|cff8080ffThis option is saved per character; you will be able to choose other values for your other characters.|r",
        ["EventWatcher"] = "Incoming events",
        ["EventWatcherWarning"] = "%s in %d sec",
        ["Performances"] = "Performances",
        ["UsefulDPS"] = "Relevant DPS",
        ["UsefulDPSExplanation"] = "This is the DPS done after removing irrelevant or lost damage.\nDamage is lost when the target has survived.\nDamage is irrelevant when done to targets that are not defeated by brute force.\n\nPoint your mouse on a bar to retrieve the player's name.",
        ["UsefulDPSEntry"] = "%d) %d DPS%s (%.2f%%)\n\nSuperfluous: %d DPS\nRelevance: %d%%",
        ["UsefulDPSChat"] = "********** Relevant DPS **********",
        ["UsefulDPSEntryChat"] = "%d) %s - %d%s (%.2f%%) || Superfluous: %d || Relevance: %d%%",
        ["UsefulDPSPet"] = " [%d from pet]",
        ["AverageDPS"] = "Average: %d",
        ["Attempt"] = "Attempts",
        ["Speed"] = "Speed",
        ["Technique"] = "Technique",
        ["Rank"] = "Rank",
        ["Record"] = "Record",
        ["NewRecord"] = "New record!",
        ["PtsAmount"] = "%d pts",
        ["Defeated"] = "|cffff2020%s|r has been defeated in %d |4attempt:attempts; !",
        ["FightTime"] = "Fight time: %s",
        ["TimeRecord"] = "Previous best time: %s",
        ["IncompleteFight"] = "|cffff2020Incomplete fight|r",
        ["HurryUp"] = "HURRY UP!",
        ["DistanceFormat"] = "%.1f yds",
        ["HealthFormat"] = "%d HP",
        ["SecondFormat"] = "%.1f s.",
        ["CoupDeGrace"] = "Coup De Grâce !",
        ["UnitList:DistanceTooClose:Title"] = "People within |cffff4000%d yds|r",
        ["UnitList:DistanceTooClose:Summary"] = "Total number: |cffff4000%d|r",
        ["UnitList:BelowHealth:Title"] = "People below |cffff4000%d HP|r",
        ["UnitList:BelowHealth:Summary"] = "Total number: |cffff4000%d|r",
        ["SpecialBar:RaidMana:Title"] = "Raid mana",
        ["DisconnectWarning"] = "/!\\ %s has been disconnected. /!\\",
        ["Name"] = "Name",
        ["HP"] = "HP",
        ["Announce"] = "Announce",
        ["Heroic"] = "heroic",
        ["Try"] = "Attempt %d",
        ["IncompleteModule"] = "This boss module is incomplete.",

        -- States
        ["Standby"] = "Standby",
        ["Engaged"] = "Engaged",
        ["Success"] = "|cff00ff00Success!|r",
        ["Failure"] = "|cffff0000Failure|r",
        ["Expiration"] = "|cffff0000Expired|r",
        ["Introduction"] = "Intro",
        ["Phase"] = "Phase",
        ["Setup"] = "Click here\nto configure",

        -- Common events
        ["Berserk"] = "Berserk",
        ["Enrage"] = "Enrage",
        ["NextWhirlwind"] = "Next Whirlwind",
        ["WhirlwindEnd"] = "End of Whirlwind",
        ["KnockAway"] = "Knock Away",
        ["Release"] = "Release",
        ["Quake"] = "Quake",
        ["Nova"] = "Nova",
        ["Wave"] = "Wave %d/%d",
        ["Teleport"] = "Teleport",
        ["BerserkTimerExtended"] = "Berserk timer extended (+%s)",
        ["BerserkTimerReduced"] = "Berserk timer reduced (-%s)",
        ["HardModeTrigger"] = "** |cffff2020Hard mode enabled !|r **",

        -- Console
        ["Console-Startup"] = "Loaded and ready (version %d and %d music plugin(s)).\nTarget a boss to trigger its module or type /BE2 to access commands.",
        ["Console-BadSyntax"] = "Bad syntax for this slash command. Try:\n",
        ["Console-Unknown"] = "You specified an unknown command. Suggestions:\n",
        ["Console-Broken"] = "|cffff0000The command could not run, though it should have.|r",
        ["Console-Beta"] = "This is the first time BossEncounter2 BETA is run on this computer.\n\n|rBETA means the AddOn is available for public testing and is not exempt of bugs nor complete. Not all options are implemented, and missing ones will come in later versions.\n\nYou can access slash commands with /BE2.",
        ["Console-Release"] = "This is the first time BossEncounter2 version %d is run on this computer.\n\nYou can access slash commands with |cffffff00/BE2|r. Though the AddOn is provided with default settings, you might want to adjust those with |cffffff00/BE2 anchor|r and |cffffff00/BE2 options|r.",
        ["Console-Author"] = "Author: |cff00ff00MrCool|r.\nMain character: |cff00ff00Eilylune|r on |cff00ff00Drek'Thar|r server (EU FR).\nYou may contact me to provide bug reports.",
        ["Console-WipeAllData"] = "Are you sure you want to erase all BossEncounter2 save data, including positions of widgets and records ? The AddOn will behave the same way it would if it was run for the first time.\n\nYour interface will be reloaded.",
        ["Console-SaveReset"] = "|cffff0000All BossEncounter2 saved data (including options and performances) have been erased because of important changes made to the AddOn save system.|r",
        ["Console-VersionQueryForbidden"] = "You can't do this yet. Try waiting a moment.",
        ["Console-VersionQueryStarted"] = "Querying versions... Please wait a few seconds.",
        ["Console-VersionResults"] = "Version query results (%d):",
        ["Console-VersionUnknown"] = "|cffff0000Unknown version|r",
        ["Console-VersionDisconnected"] = "|cff808080Disconnected|r",
        ["Console-VersionNoAnswer"] = "|cffffff00No answer|r",
        ["Console-VersionSelf"] = "You are using version %d.",
        ["Console-VersionGuild"] = "GUILD",
        ["Console-VersionGroup"] = "GROUP",
        ["Console-MusicPluginListHeader"] = "Music plugin list (%d loaded) :",
        ["Console-MusicPluginListEntry"] = "%d. |cffffff00%s|r (version %d) : %d musics, created by %s.",
        ["Console-MusicPluginActivateSuccess"] = "Plugin #%d (|cffffff00%s|r) activated !",
        ["Console-MusicPluginActivateFailure"] = "The plugin number you have specified is not correct.\nCheck the desired plugin is loaded with /BE music list.",
        ["Console-MusicPluginExplainNoPlugin"] = "BossEncounter2 can be enhanced with special music plugins. Official plugins can be downloaded through the links given on BossEncounter2 page on Curse and WoWInterface sites.\n\nThese plugins are installed in the same way as Addons: you unzip the file in the ''AddOns'' folder.",
        ["Console-MusicPluginExplainUsage"] = "It looks like you have installed %d music plugin(s) for BossEncounter2.\n\nTo add more plugins, install them like normal AddOns and check they are enabled on the character screen. You can select the plugin to use if you have more than one through /BE music activate X, where X is the number of the plugin given by the /BE music list command.",
        ["Console-MusicPluginDeprecated"] = "The music plugin you are using no longer fits the specifications of BossEncounter2 music plugin system. It will continue to work, but it is HIGHLY recommanded you update it.\n\nIf it is an official plugin, you should be able to find an updated version on BossEncounter2 page of Curse and WoWInterface sites.",
        ["Console-IncompleteFightExplain"] = "You got an |cffff0000''incomplete fight''|r. This occurs when the boss module is started *after* the boss has entered combat. As a consequence, timers were incorrect. Please make sure you select each boss before the pull to avoid this.",
        ["Console-EnchantList"] = "Enchanters list (%d):",
        ["Console-EnchantAddSuccess"] = "%s has been added in the enchanter list.",
        ["Console-EnchantAddFailure"] = "%s is already in the enchanter list.",
        ["Console-EnchantRemoveSuccess"] = "%s has been removed from the enchanter list.",
        ["Console-EnchantRemoveFailure"] = "%s is not in the enchanter list.",
        ["Console-EnchantTargetError"] = "Your target is invalid. Make sure you target a player.",
        ["Console-EnchantTargetMagicWord"] = "target",
        ["Console-NoSequenceReplay"] = "No end sequence to replay: you haven't defeated a boss in this game session.",
        ["Console-NoAdminIgnore"] = "You may not ignore %s as long as BossEncounter2 is running.",
        ["Console-BE2Disabled"] = "BossEncounter2 is now asleep. Use /BE2 start to restart it.",
        ["Console-BE2Enabled"] = "BossEncounter2 is now running. Use /BE2 stop to put it in sleep mode.",
        ["Console-BE2StartDisabled"] = "BossEncounter2 is currently in sleep mode. Use /BE2 start to restart it.",

        -- Auto-reply
        ["AutoReply-Header"] = "%s is currently in combat against the following boss: [%s]",
        ["AutoReply-Body"] = "Boss %s HP, combat time: %s.",
        ["AutoReply-Tail"] = "%s raid members remaining.",

        -- Anchors
        ["Anchor-BossBar"] = "Boss health",
        ["Anchor-EventWatcher"] = "Event watcher",
        ["Anchor-StatusFrame"] = "Status box",
        ["Anchor-UnitList"] = "Unit list",
        ["Anchor-MajorText"] = "Major messages",
        ["Anchor-MinorText"] = "Messages",
        ["Anchor-AddBars"] = "Add bars",
        ["Anchor-SpecialBar"] = "Special bar",
        ["Anchor-EventWarning"] = "Event bar",
        ["Anchor-AddWindow"] = "Add window",

        -- Anchor control frame
        ["ACF-NoFocus"] = "Drag a widget.",
        ["ACF-DefaultX"] = "Default X",
        ["ACF-DefaultY"] = "Default Y",
        ["ACF-Finish"] = "Finish",
        ["ACF-Copy"] = "Import",
        ["ACF-Enable"] = "Enable this widget",
        ["ACF-Scale"] = "Scale",

        -- Difficulty meter
        ["DM-Title"] = "Difficulty",
        ["DM-Power"] = "Power",
        ["DM-PowerExplain"] = "The Power meter measures the overall difficulty of the boss.",
        ["DM-Burst"] = "Burst",
        ["DM-BurstExplain"] = "The Burst meter measures the spike damage or pressure that can be put on the raid at a given time.",
        ["DM-AOE"] = "AoE",
        ["DM-AOEExplain"] = "The AoE meter measures how much AoE damage the raid is going to sustain.",
        ["DM-Chaos"] = "Chaos",
        ["DM-ChaosExplain"] = "The Chaos meter measures how confusing or unpredictable the fight is.",
        ["DM-Skill"] = "Skill",
        ["DM-SkillExplain"] = "The Skill meter measures how hard each raid member has to invest himself (including understanding and execution of the fight) to pass the boss.",

        -- Loot assigner
        ["LootAssigner"] = "Assign loot",
        ["LA-Disenchant"] = "Disenchant",
        ["LA-Assign"] = "Assign",
        ["LA-List"] = "List",
        ["LA-Confirm"] = "Confirm",
        ["LA-DisenchantAuth"] = "Disenchant permission",
        ["LA-DisenchantNone"] = "No enchanter",
        ["LA-DisenchantReady"] = "Enchanter: |cffffffff%s|r",
        ["LA-EnterName"] = "Enter the name of the player that should receive the loot. Mind the capital letters.",
        ["LA-ConfirmAssign"] = "Confirm |cffffffff%s|r by clicking several times in a row on the confirm button.",
        ["LA-ConfirmBar"] = "Confirm-O-Meter",
        ["LA-Unusable"] = "|cffff0000WARNING: |cffffffff%s|r cannot use this item. Click on confirm button several times to send nonetheless.",
        ["LA-MeritLow"] = "|cffff0000WARNING: |cffffffff%s|r has a very low merit. Click on confirm button several times to send nonetheless.",
        ["LA-Executing"] = "Loot assignment is going to be performed...",
        ["LA-TimeOut"] = "Time out",
        ["LA-AssignNotFound"] = "|cffff0000ERROR:|r |cffffffff%s|r is not on the possible candidates list !",
        ["LA-NoEnchantExplain"] = "You haven't defined any enchanters. Use |cffffff00/BE enchanter add|r to add an enchanter.",
        ["LA-Random"] = "|cffffff00Random|r",

        -- Epic fail messages
        ["EF-1"] = "For some things, there's just no excuse.",
        ["EF-2"] = "Seriously, how the fuck did you manage that?",
        ["EF-3"] = "Are you even trying?",
    },

    ["frFR"] = {
        -- Widgets
        ["Settings"] = "Réglages",
        ["SettingLock"] = "\n\n|cffff0000Vous ne pouvez pas changer cette option, peut être parce que vous n'avez pas la permission de le faire. Essayez d'obtenir le rang d'assistant ou de meneur.|r",
        ["SettingOne"] = "\n\n|cff00ff00Seule une personne du raid peut avoir cette option activée durant le combat. Les utilisateurs de la version la plus récente auront priorité.|r",
        ["SettingPerCharacter"] = "\n\n|cff8080ffCette option est sauvegardée par personnage; vous pourrez choisir d'autres valeurs pour vos autres personnages.|r",
        ["EventWatcher"] = "Evènements imminents",
        ["EventWatcherWarning"] = "%s dans %d sec",
        ["Performances"] = "Performances",
        ["UsefulDPS"] = "DPS pertinent",
        ["UsefulDPSExplanation"] = "Ceci est le DPS fait après avoir retiré les dégâts non pertinents :\nles dégâts faits aux cibles qui ont survécu ainsi qu'aux cibles qui\nne peuvent pas être tuées de façon normale ne sont pas comptés.\n\nPointez votre souris sur une barre pour retrouver le nom du joueur.",
        ["UsefulDPSEntry"] = "%d) %d DPS%s (%.2f %%)\n\nSuperflu: %d DPS\nPertinence: %d%%",
        ["UsefulDPSChat"] = "********** DPS pertinent **********",
        ["UsefulDPSEntryChat"] = "%d) %s - %d%s (%.2f%%) || Superflu: %d || Pertinence: %d%%",
        ["UsefulDPSPet"] = " [%d du familier]",
        ["AverageDPS"] = "Moyenne: %d",
        ["Attempt"] = "Tentatives",
        ["Speed"] = "Rapidité",
        ["Technique"] = "Technique",
        ["Rank"] = "Rang",
        ["Record"] = "Record",
        ["NewRecord"] = "Nouveau record !",
        ["PtsAmount"] = "%d pts",
        ["Defeated"] = "|cffff2020%s|r a été vaincu(e) en %d |4tentative:tentatives; !",
        ["FightTime"] = "Durée du combat: %s",
        ["TimeRecord"] = "Meilleur temps précédent: %s",
        ["IncompleteFight"] = "|cffff2020Combat incomplet|r",
        ["HurryUp"] = "Dépêchez-vous !",
        ["DistanceFormat"] = "%.1f m",
        ["HealthFormat"] = "%d PV",
        ["SecondFormat"] = "%.1f s.",
        ["CoupDeGrace"] = "Coup de grâce !",
        ["UnitList:DistanceTooClose:Title"] = "Ceux à moins de |cffff4000%d m|r",
        ["UnitList:DistanceTooClose:Summary"] = "Nombre total: |cffff4000%d|r",
        ["UnitList:BelowHealth:Title"] = "Ceux en dessous de |cffff4000%d PV|r",
        ["UnitList:BelowHealth:Summary"] = "Nombre total: |cffff4000%d|r",
        ["SpecialBar:RaidMana:Title"] = "Mana du raid",
        ["DisconnectWarning"] = "/!\\ %s a été déconnecté(e). /!\\",
        ["Name"] = "Nom",
        ["HP"] = "PV",
        ["Announce"] = "Annoncer",
        ["Heroic"] = "héroïque",
        ["Try"] = "Essai %d",
        ["IncompleteModule"] = "Ce module de boss est incomplet.",

        -- States
        ["Standby"] = "En attente",
        ["Engaged"] = "Engagé",
        ["Success"] = "|cff00ff00Succès!|r",
        ["Failure"] = "|cffff0000Echec|r",
        ["Expiration"] = "|cffff0000Expiré|r",
        ["Introduction"] = "Intro",
        ["Phase"] = "Phase",
        ["Setup"] = "Cliquer ici\npour configurer",

        -- Common events
        ["Berserk"] = "Berserk",
        ["Enrage"] = "Enrager",
        ["NextWhirlwind"] = "Prochain tourbillon",
        ["WhirlwindEnd"] = "Fin du tourbillon",
        ["KnockAway"] = "Repousser au loin",
        ["Release"] = "Libération",
        ["Quake"] = "Séisme",
        ["Nova"] = "Nova",
        ["Wave"] = "Vague %d/%d",
        ["Teleport"] = "Téléportation",
        ["BerserkTimerExtended"] = "Temps du berserk étendu (+%s)",
        ["BerserkTimerReduced"] = "Temps du berserk réduit (-%s)",
        ["HardModeTrigger"] = "** |cffff2020Mode difficile activé !|r **",

        -- Console
        ["Console-Startup"] = "Chargé et prêt (version %d et %d plugin(s) musical(aux)).\nCiblez un boss pour enclencher son module ou tapez /BE2 pour accéder aux commandes.",
        ["Console-BadSyntax"] = "Mauvaise syntaxe pour cette commande slash. Essayez :\n",
        ["Console-Unknown"] = "Vous avez entré une commande inconnue. Suggestions:\n",
        ["Console-Broken"] = "|cffff0000La commande n'a pas pu être exécutée, alors qu'elle aurait dû.|r",
        ["Console-Beta"] = "Ceci est la première fois que BossEncounter2 BETA est lancé sur cet ordinateur.\n\n|rBETA signifie que l'AddOn est disponible pour des tests publics et n'est pas exempte de bugs ni complète. Les options ne sont pas toutes implementées; celles qui manquent viendront dans les versions futures.\n\nVous pouvez accéder aux commandes slash avec /BE2.",
        ["Console-Release"] = "Ceci est la première fois que BossEncounter2 version %d est lancé sur cet ordinateur.\n\nVous pouvez accéder aux commandes slash avec |cffffff00/BE2|r. L'AddOn a une configuration par défaut, toutefois il est conseillé d'affiner les réglages avec |cffffff00/BE2 attache|r et |cffffff00/BE2 options|r.",
        ["Console-Author"] = "Auteur: |cff00ff00MrCool|r.\nPersonnage principal: |cff00ff00Eilylune|r sur le serveur |cff00ff00Drek'Thar|r (EU FR).\nIl est possible de me contacter pour des rapports de bugs.",
        ["Console-WipeAllData"] = "Êtes-vous sûr(e) de vouloir effacer toutes les données sauvegardées de BossEncounter2, incluant la position des gadgets et les records ? L'AddOn se comportera comme si elle était lancée pour la première fois.\n\nVotre interface sera rechargée.",
        ["Console-SaveReset"] = "|cffff0000Toutes les données sauvegardées de BossEncounter2 (incluant les options et les performances) ont été effacées à cause de changements importants effectuées sur le système de sauvegarde de l'AddOn.|r",
        ["Console-VersionQueryForbidden"] = "Vous ne pouvez pas encore faire cela. Essayez de patienter un instant.",
        ["Console-VersionQueryStarted"] = "Début de la requête de version... Veuillez patienter quelques secondes.",
        ["Console-VersionResults"] = "Résultats de la requête de version (%d):",
        ["Console-VersionUnknown"] = "|cffff0000Version inconnue|r",
        ["Console-VersionDisconnected"] = "|cff808080Déconnecté(e)|r",
        ["Console-VersionNoAnswer"] = "|cffffff00Pas de réponse|r",
        ["Console-VersionSelf"] = "Vous utilisez la version %d.",
        ["Console-VersionGuild"] = "GUILDE",
        ["Console-VersionGroup"] = "GROUPE",
        ["Console-MusicPluginListHeader"] = "Liste des plugins musicaux (%d chargé(s)) :",
        ["Console-MusicPluginListEntry"] = "%d. |cffffff00%s|r (version %d) : %d musiques, créé par %s.",
        ["Console-MusicPluginActivateSuccess"] = "Plugin #%d (|cffffff00%s|r) activé !",
        ["Console-MusicPluginActivateFailure"] = "Le numéro de plugin n'est pas correct.\nVérifiez que le plugin désiré est chargé avec /BE musique liste.",
        ["Console-MusicPluginExplainNoPlugin"] = "BossEncounter2 peut être amélioré avec des plugins musicaux spéciaux. Les plugins officiels peuvent être téléchargés en suivant les liens qui se trouvent sur la page de BossEncounter2 sur Curse et WoWInterface.\n\nCes plugins s'installent comme des AddOns standards: vous dézippez le fichier dans le dossier ''AddOns''.",
        ["Console-MusicPluginExplainUsage"] = "Il semblerait que vous ayez installé %d plugin(s) musical(aux) pour BossEncounter2.\n\nPour ajouter des plugins supplémentaires, installez-les de la même façon qu'une AddOn et vérifiez qu'ils sont activés sur l'écran des personnages. Vous pouvez choisir le plugin à utiliser si vous en avez plus d'un avec la commande /BE musique activer X, où X est le numéro du plugin. Ce numéro peut être obtenu par la commande /BE musique liste.",
        ["Console-MusicPluginDeprecated"] = "Le plugin musical que vous utilisez ne correspond plus parfaitement au format utilisé par le système musical de BossEncounter2. Il continuera de fonctionner, mais il est FORTEMENT recommandé que vous le mettiez à jour.\n\nS'il s'agit d'un plugin officiel, vous devriez pouvoir trouver une version mise à jour sur la page de BossEncounter2 sur Curse et WoWInterface.",
        ["Console-IncompleteFightExplain"] = "Vous avez eu un |cffff0000''combat incomplet''|r. Ceci se produit quand le module de boss est lancé *après* que celui-ci soit entré en combat. En conséquence, les ''timers'' ont été incorrects. Veuillez vous assurer de bien sélectionner le boss avant de démarrer le combat pour éviter cela.",
        ["Console-EnchantList"] = "Liste des enchanteurs (%d):",
        ["Console-EnchantAddSuccess"] = "%s a été ajouté(e) dans la liste des enchanteurs.",
        ["Console-EnchantAddFailure"] = "%s est déjà dans la liste des enchanteurs.",
        ["Console-EnchantRemoveSuccess"] = "%s a été retiré(e) de la liste des enchanteurs.",
        ["Console-EnchantRemoveFailure"] = "%s n'est pas dans la liste des enchanteurs.",
        ["Console-EnchantTargetError"] = "Votre cible est incorrecte. Assurez-vous de bien cibler un joueur.",
        ["Console-EnchantTargetMagicWord"] = "cible",
        ["Console-NoSequenceReplay"] = "Pas de séquence de fin à rejouer: vous n'avez pas vaincu de boss durant cette session de jeu.",
        ["Console-NoAdminIgnore"] = "Vous ne pouvez pas ignorer %s tant que BossEncounter2 est activé.",
        ["Console-BE2Disabled"] = "BossEncounter2 est maintenant en veille. Utiliser /BE2 lancer pour le réactiver.",
        ["Console-BE2Enabled"] = "BossEncounter2 est maintenant opérationnel. Utiliser /BE2 stop pour le mettre en veille.",
        ["Console-BE2StartDisabled"] = "BossEncounter2 est actuellement en veille. Utiliser /BE2 lancer pour le réactiver.",

        -- Auto-reply
        ["AutoReply-Header"] = "%s est actuellement en combat contre le boss suivant: [%s]",
        ["AutoReply-Body"] = "Boss %s PV, temps de combat: %s.",
        ["AutoReply-Tail"] = "%s membres du raid en vie.",

        -- Anchors
        ["Anchor-BossBar"] = "Vie du boss",
        ["Anchor-EventWatcher"] = "Evènements",
        ["Anchor-StatusFrame"] = "Boîte d'état",
        ["Anchor-UnitList"] = "Liste d'unités",
        ["Anchor-MajorText"] = "Messages urgents",
        ["Anchor-MinorText"] = "Messages",
        ["Anchor-AddBars"] = "Barres d'adds",
        ["Anchor-SpecialBar"] = "Barre spéciale",
        ["Anchor-EventWarning"] = "Barre d'évènement",
        ["Anchor-AddWindow"] = "Fenêtre d'adds",

        -- Anchor control frame
        ["ACF-NoFocus"] = "Tirez un gadget.",
        ["ACF-DefaultX"] = "X original",
        ["ACF-DefaultY"] = "Y original",
        ["ACF-Finish"] = "Terminer",
        ["ACF-Copy"] = "Importer",
        ["ACF-Enable"] = "Activer ce gadget",
        ["ACF-Scale"] = "Echelle",

        -- Difficulty meter
        ["DM-Title"] = "Difficulté",
        ["DM-Power"] = "Puissance",
        ["DM-PowerExplain"] = "La Puissance mesure la difficulté globale du combat.",
        ["DM-Burst"] = "Pression",
        ["DM-BurstExplain"] = "La Pression mesure les dégâts soudains et la pression infligés au raid à un moment donné.",
        ["DM-AOE"] = "Zonage",
        ["DM-AOEExplain"] = "Le Zonage mesure la quantité de dégâts que le raid subira des attaques à effet de zone.",
        ["DM-Chaos"] = "Chaos",
        ["DM-ChaosExplain"] = "Le Chaos mesure la confusion ou l'imprévisibilité du combat.",
        ["DM-Skill"] = "Talent",
        ["DM-SkillExplain"] = "Le Talent mesure l'investissement (incluant la compréhension et l'exécution de la stratégie) que chaque membre du raid doit fournir pour passer le boss.",

        -- Loot assigner
        ["LootAssigner"] = "Assigner le butin",
        ["LA-Disenchant"] = "Désenchanter",
        ["LA-Assign"] = "Assigner",
        ["LA-List"] = "Liste",
        ["LA-Confirm"] = "Confirmer",
        ["LA-DisenchantAuth"] = "Autorisation de déz.",
        ["LA-DisenchantNone"] = "Pas d'enchanteur",
        ["LA-DisenchantReady"] = "Enchanteur: |cffffffff%s|r",
        ["LA-EnterName"] = "Entrez le nom de la personne qui doit recevoir le butin. Respectez les majuscules.",
        ["LA-ConfirmAssign"] = "Confirmez |cffffffff%s|r en cliquant successivement plusieurs fois sur le bouton confirmer.",
        ["LA-ConfirmBar"] = "Niveau de confirmation",
        ["LA-Unusable"] = "|cffff0000ATTENTION: |cffffffff%s|r ne peut pas utiliser cet objet. Cliquez sur confirmer plusieurs fois pour lui envoyer malgré tout.",
        ["LA-MeritLow"] = "|cffff0000ATTENTION: |cffffffff%s|r a un mérite très bas. Cliquez sur confirmer plusieurs fois pour lui envoyer malgré tout.",
        ["LA-Executing"] = "L'assignement du butin va s'effectuer...",
        ["LA-TimeOut"] = "Temps imparti",
        ["LA-AssignNotFound"] = "|cffff0000ERREUR:|r |cffffffff%s|r n'est pas sur la liste des candidats possible.",
        ["LA-NoEnchantExplain"] = "Vous n'avez pas défini d'enchanteurs. Utilisez |cffffff00/BE enchanteur ajouter|r pour ajouter un enchanteur.",
        ["LA-Random"] = "|cffffff00Aléatoire|r",

        -- Epic fail messages
        ["EF-1"] = "Pour certaines choses, il n'y a aucune excuse.",
        ["EF-2"] = "Sérieusement, comment avez-vous fait cela ?",
        ["EF-3"] = "Est-ce que vous faites vraiment un effort ?",
    },
};

-- --------------------------------------------------------------------
-- **                    Localisation functions                      **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> Localise(key, noError)                                   *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> key: what to localise. If not found on the correct locale,    *
-- * will use default value. If there is no default value, this       *
-- * function will return formatted MISSING_TRANSLATION.              *
-- * >> noError: if set and the localisation is not available, this   *
-- * function will return nil instead of missing translation.         *
-- ********************************************************************

function Root.Localise(key, noError)
    local locale = modLocale[GetLocale()];
    local defaultlocale = modLocale["default"];

    if ( locale ) and ( locale[key] ) then
        return locale[key];
  else
        if ( defaultlocale ) and ( defaultlocale[key] ) then
            return defaultlocale[key];
        end
    end

    if ( noError ) then return nil; end

    return string.format(MISSING_TRANSLATION, key);
end

-- A mirror for other writings of Localise :p

Root.Localize = Root.Localise;

-- ********************************************************************
-- * Root -> Unlocalise(translation)                                  *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> translation: translation thing to unlocalise.                 *
-- * If there is an error, <translation> value will be returned.      *
-- ********************************************************************

function Root.Unlocalise(translation)
    local locale = modLocale[GetLocale()];
    local defaultlocale = modLocale["default"];
    local k, t;

    if ( locale ) then
        for k, t in pairs(locale) do
            if ( t == translation ) then
                return k;
            end
        end
    end

    if ( defaultlocale ) then
        for k, t in pairs(defaultlocale) do
            if ( t == translation ) then
                return k;
            end
        end
    end

    return translation;
end

-- ********************************************************************
-- * Root -> FormatLoc(key, ...)                                      *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> key: what to localise. If not found on the correct locale,    *
-- * will use default value. If there is no default value, this       *
-- * function will return formatted MISSING_TRANSLATION.              *
-- * >> ...: the arguments to pass to the format function.            *
-- ********************************************************************
-- * This acts like Localise, but it passes the localised string to a *
-- * format function, using parameters sent with "..." holder.        *
-- ********************************************************************

function Root.FormatLoc(key, ...)
    local localisation = Root.Localise(key, 1);
    if ( localisation ) then
        return string.format(localisation, ...);
  else
        return string.format(MISSING_TRANSLATION, key);
    end
end

-- ********************************************************************
-- * Root -> Root.ReadLocTable(table)                                 *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> table: the table containing the localised strings.            *
-- ********************************************************************
-- * Pick the string for your language in a localised table.          *
-- * A localised table is a table that contains indexes equal to each *
-- * language code. Eg: ["frFR"] = "Bonjour !"                        *
-- * If not found, value of ["default"] key will be returned or nil.  *
-- * If the input is a string, this string will be returned.          *
-- ********************************************************************

function Root.ReadLocTable(table)
    if type(table) == "string" then return table; end
    if type(table) ~= "table" then return nil; end
    return table[GetLocale()] or table["default"] or nil;
end

