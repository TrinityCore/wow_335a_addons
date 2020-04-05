local L = AceLibrary("AceLocale-2.2"):new("XLootMonitor")

L:RegisterTranslations("frFR", function()
	return {
		catGrowth = "Orientation des lignes",
		catLoot = "Loot",
		catPosSelf = "Point d'ancrage...",
		catPosTarget = "Vers...",
		catPosOffset = "D\195\169calage de la fen\195\170tre...",
		catModules = "Modules",
		
		moduleHistory = "Historique des loots",
		moduleActive = "Actif",
		
		historyTime = "Voir chronologiquement",
		historyPlayer = "Voir par joueur",
		["View by item"] = "Voir par objet",
		historyClear = "Effacer l'historique actuel",
		historyEmpty = "Pas d'historique \195\160 afficher",
		historyTrunc = "Longeur maximum pour les objets",
		historyMoney = "Argent ramass\195\169",
		["Export history"] = "Exporter l'historique",
		["No export handlers found"] = "Aucun outils d'exportation trouv\195\169",
		
		["Loot Monitor"] = "Moniteur de Loot",
					
		optStacks = "Piles/Ancres",
		optLockAll = "V\195\169rouiller toutes les fen\195\170tres",
		optPositioning = "Positionnement",
		optMonitor = "XLoot Monitor",
		optAnchor = "Afficher l'ancrage",
		optPosVert = "Verticalement",
		optPosHoriz = "Horizontalement",
		optTimeout = "Dur\195\169 d'affichage",
		optDirection = "Direction",
		optThreshold = "Nombre de ligne affich\195\169",
		optQualThreshold = "Seuil de raret\195\169",
		optSelfQualThreshold = "Seuil de raret\195\169 personnel",
		optUp = "Haut",
		optDown = "Bas",
		optMoney = "Afficher l'argent ramass\195\169",
		["Show countdown text"] = "Afficher le compte \195\160 rebours",
		["Show small text beside the item indicating how much time remains"] = "Affiche le temps restant pr\195\168s de l'objet",
		["Trim item names to..."] = "Tronquer le nom des objets \195\160...",
		["Length in characters to trim item names to"] = "Longueur en caract\195\168re sur laquelle les noms d'objet doivent \195\170tre tronqu\195\169",
		
		descStacks = "Options pour chaque ligne individuelle, tel que l'ancrage ou la dur\195\169 d'affichage.",
		descPositioning = "Position de chaque ligne",
		descMonitor = "Configuration des plugins pour XLootMonitor",
		descAnchor = "Afficher l'ancrage pour cette ligne",
		descPosVert = "D\195\169cale la ligne verticalement depuis le point que vous avez choisie d'ancrer du nombre sp\195\169cifi\195\169",
		descPosHoriz = "D\195\169cale la ligne horizontalement depuis le point que vous avez choisie d'ancrer du nombre sp\195\169cifi\195\169",
		descTimeout = "Dur\195\169 avant disparition des lignes. |cFFFF5522A 0, d\195\169sactive la disparition compl\195\168tement",
		descDirection = "Direction de l'affichage des lignes de loot",
		descThreshold = "Nombre maximum de lignes affich\195\169 simultan\195\169ment",
		descQualThreshold = "Raret\195\169 minimum rencontr\195\169 par les autres membres pour \195\170tre affich\195\169 par le moniteur",
		descSelfQualThreshold = "Raret\195\169 minimum rencontr\195\169 par vous m\195\170me pour \195\170tre affich\195\169 par le moniteur",
		descMoney = "Afficher l'argent partag\195\169 quand vous \195\170tes en groupe |cFFFF0000N'inclut pas encore l'argent en solo.|r",
		
		optPos = {
			TOPLEFT = "Coin sup\195\169rieur gauche",
			TOP = "Bord sup\195\169rieur",
			TOPRIGHT = "Coin sup\195\169rieur droit",
			RIGHT = "Bord droit",
			BOTTOMRIGHT = "Coin inf\195\169rieur droit",
			BOTTOM = "Bord infr\195\169rieur",
			BOTTOMLEFT = "Coin inf\195\169rieur gauche",
			LEFT = "Bord gauche",
			TOPLEFT = "Coin sup\195\169rieur gauche",
		},
		
		linkErrorLength = "Ins\195\169rer l'objet rendrait le message trop long. Envoyer ou effacer le message actuel, puis r\195\169essayer.",
		
		playerself = "Vous", 
	}
end)

