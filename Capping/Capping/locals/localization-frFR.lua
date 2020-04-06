if GetLocale() ~= "frFR" then return end

-- fr translations provided by pingouin47
-- Updated by Pettigrow
CappingLocale:CreateLocaleTable({
	-- battlegrounds
	["Alterac Valley"] = "Vallée d'Alterac", 
	["Arathi Basin"] = "Bassin d'Arathi", 
	["Warsong Gulch"] = "Goulet des Chanteguerres",
	["Eye of the Storm"] = "L'Œil du cyclone",
	["Wintergrasp"] = "Joug-d'hiver",
	["Isle of Conquest"] = "Île des Conquérants",

	-- options menu
	["Auto Quest Turnins"] = "Rendre auto. les quêtes",
	["Bar"] = "Barres",
	["Width"] = "Longueur",
	["Height"] = "Hauteur",
	["Texture"] = "Texture",
	["Map Scale"] = "Échelle de la carte",
	["Hide Border"] = "Masquer la bordure",
	["Port Timer"] = "Délais de téléportation",
	["Wait Timer"] = "Délais d'attente",
	["Show/Hide Anchor"] = "Montrer/Masquer l'ancre",
	["Narrow Map Mode"] = "Carte locale réduite",
	["Narrow Anchor Left"] = "Réduire l'ancrage à gauche",
	--["Test"] = "Test",
	["Flip Growth"] = "Séparer par type",
	["Single Group"] = "Un seul groupe",
	["Move Scoreboard"] = "Repositionner le tableau de score",
	["Spacing"] = "Espacement",
	["Request Sync"] = "Demander une synchro",
	["Fill Grow"] = "Remplir au lieu de vider",
	["Fill Right"] = "Inverser le sens",
	["Font"] = "Police d'écriture",
	["Time Position"] = "Position de la durée",
	["Border Width"] = "Largeur de bordure",
	["Send to BG"] = "Envoyer au canal CdB",
	["Send to SAY"] = "Envoyer au canal Dire",
	["Cancel Timer"] = "Annuler le délai",
	["Move Capture Bar"] = "Repositionner la barre de capture",
	["Move Vehicle Seat"] = "Repositionner le véhicule de siège",

	-- etc timers
	["Port: %s"] = "Port : %s", -- bar text for time remaining to port into a bg
	["Queue: %s"] = "File : %s",
	["Battle Begins"] = "Début de la bataille", -- bar text for bg gates opening (why can't they all be the same?)
	["1 minute"] = "1 minute",
	["60 seconds"] = "60 secondes",
	["30 seconds"] = "30 secondes",
	["15 seconds"] = "15 secondes",
	["One minute until"] = "commence dans une minute",
	["Forty five seconds"] = "commence dans quarante-cinq secondes",
	["Thirty seconds until"] = "commence dans trente secondes",
	["Fifteen seconds until"] = "commence dans quinze secondes",
	["has begun"] = "commence !", -- start of arena key phrase
	["%s: %s - %d:%02d"] = "%s : %s - %d:%02d restantes", -- chat message after shift left-clicking a bar

	-- AB
	["Bases: (%d+)  Resources: (%d+)/(%d+)"] = "Bases : (%d+)  Ressources: (%d+)/(%d+)",
	["has assaulted"] = "a attaqué",
	["claims the"] = "a pris",
	["has taken the"] = "s'est emparée",
	["has defended the"] = "a défendu",
	["Final: %d - %d"] = "Final : %d - %d", -- final score text
	["wins %d-%d"] = "Victoire %d - %d", -- final score chat message

	-- WSG
	["was picked up by (.+)!"] = "a été ramassé par (.+) !",
	--["was picked up by (.+)!2"] = true,
	["dropped"] = "a été lâché",
	["captured the"] = "a pris le drapeau de",
	["Flag respawns"] = "Réapparition drapeau(x)",
	["%s's flag carrier: %s (%s)"] = "Porteur du drapeau %s : %s (%s)", -- chat message

	-- AV
	-- NPC
	["Smith Regzar"] = "Forgeron Regzar",
	["Murgot Deepforge"] = "Murgot Forge-profonde",
	["Primalist Thurloga"] = "Primaliste Thurloga",
	["Arch Druid Renferal"] = "Archidruide Ranfarouche",
	["Stormpike Ram Rider Commander"] = "Commandant Chevaucheur de bélier Foudrepique",
	["Frostwolf Wolf Rider Commander"] = "Commandant Chevaucheur de loup Loup-de-givre ",

	-- patterns
	--["Upgrade to"] = true, -- the option to upgrade units in AV
	--["Wicked, wicked, mortals!"] = true, -- what Ivus says after being summoned
	["Ivus begins moving"] = "Ivus commence à bouger",
	["WHO DARES SUMMON LOKHOLAR"] = "QUI OSE INVOQUER LOKHOLAR", -- what Lok says after being summoned -- à vérifier
	["The Ice Lord has arrived!"] = "Le seigneur des glaces est arrivé !",
	["Lokholar begins moving"] = "Lokholar commence à bouger",

	-- EotS
	["^(.+) has taken the flag!"] = "^(.+) a pris le drapeau !",
	["Bases: (%d+)  Victory Points: (%d+)/(%d+)"] = "Bases : (%d+)  Points de victoire : (%d+)/(%d+)",

	-- IoC
	 -- node keywords (text is also displayed on timer bar)
	["Alliance Keep"] = "Donjon de l'Alliance",
	["Horde Keep"] = "Donjon de la Horde",
	-- Siege Engine keyphrases
	["Goblin"] = "gobelin",  -- Horde mechanic name keyword
	["seaforium bombs"] = "bombes à l'hydroglycérine",  -- start (after capturing the workshop)
	["It's broken"] = "Encore cassé",  -- start again (after engine is destroyed)
	["halfway"] = "Je dois en être à la moitié",  -- middle
})
