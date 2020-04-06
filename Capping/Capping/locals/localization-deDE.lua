if GetLocale() ~= "deDE" then return end

-- de translations provided by Farook
CappingLocale:CreateLocaleTable({
	-- battlegrounds
	["Alterac Valley"] = "Alteractal", 
	["Arathi Basin"] = "Arathibecken", 
	["Warsong Gulch"] = "Kriegshymnenschlucht",
	["Eye of the Storm"] = "Auge des Sturms",
	["Wintergrasp"] = "Tausendwintersee",
	["Isle of Conquest"] = "Insel der Eroberung",

	-- options menu
	["Auto Quest Turnins"] = "Autom. Questabgabe",
	["Bar"] = "Leiste",
	["Width"] = "Breite",
	["Height"] = "Höhe",
	["Texture"] = "Textur",
	["Map Scale"] = "Kartenskalierung",
	["Hide Border"] = "Rahmen ausblenden",
	["Port Timer"] = "Port Timer",
	["Wait Timer"] = "Wartezeit Timer",
	["Show/Hide Anchor"] = "Anker anzeigen/verstecken",
	["Narrow Map Mode"] = "Karte verkleinern",
	["Narrow Anchor Left"] = "Karte verkleinern anker links",
	--["Test"] = "Test",
	["Flip Growth"] = "Anstieg umdrehen",
	["Single Group"] = "Einzelne Gruppe",
	["Move Scoreboard"] = "Scoreboard repositionieren",
	["Spacing"] = "Abstand",
	["Request Sync"] = "Synchronisation anfragen",
	["Fill Grow"] = "Füllung anwachsend",
	["Fill Right"] = "Füllung nach rechts",
	["Font"] = "Schriftart",
	["Time Position"] = "Zeitposition",
	["Border Width"] = "Randbreite",
	["Send to BG"] = "Zum SCHLACHTFELD senden",
	["Send to SAY"] = "Zu SAGEN senden",
	["Cancel Timer"] = "Timer abbrechen",
	["Move Capture Bar"] = "Fortschrittsleiste repositionieren",
	["Move Vehicle Seat"] = "Fahrzeugsitz repositionieren",

	-- etc timers
	--["Port: %s"] = "Port: %s", -- bar text for time remaining to port into a bg
	["Queue: %s"] = "Warteschlange: %s",
	["Battle Begins"] = "Schlachtfeld beginnt", -- bar text for bg gates opening
	["1 minute"] = "1 Minute",
	["60 seconds"] = "60 Sekunden",
	["30 seconds"] = "30 Sekunden",
	["15 seconds"] = "15 Sekunden",
	["One minute until"] = "Eine Minute bis",
	["Forty five seconds"] = "Fünfvierzig Sekunden bis",
	["Thirty seconds until"] = "Dreißig Sekunden bis",
	["Fifteen seconds until"] = "Fünfzehn Sekunden bis",
	["has begun"] = "hat begonnen", -- start of arena key phrase
	["%s: %s - %d:%02d"] = "%s: %s - %d:%02d verbleibend", -- chat message after shift left-clicking a bar

	-- AB
	["Bases: (%d+)  Resources: (%d+)/(%d+)"] = "Basen: (%d+)  Ressourcen: (%d+)/(%d+)", -- arathi basin scoreboard
	["has assaulted"] = "angegriffen!",
	["claims the"] = "besetzt!",
	["has taken the"] = "eingenommen!",
	["has defended the"] = "verteidigt!",
	["Final: %d - %d"] = "Endstand: %d - %d", -- final score text
	["wins %d-%d"] = "siegt %d-%d", -- final score chat message

	-- WSG
	["was picked up by (.+)!"] = "(.+) hat die Flagge der (%a+) aufgenommen!",
	--["was picked up by (.+)!2"] = true,
	["dropped"] = "fallen lassen!",
	["captured the"] = "errungen!",
	["Flag respawns"] = "Flaggen",
	["%s's flag carrier: %s (%s)"] = "%s's Flaggenträger: %s (%s)",

	-- AV
	 -- NPC
	["Smith Regzar"] = "Schmied Regzar",
	["Murgot Deepforge"] = "Murgot Tiefenschmied",
	-- ["Primalist Thurloga"] = "Primalistin Thurloga",  -- same as default
	["Arch Druid Renferal"] = "Erzdruide Renferal",
	["Stormpike Ram Rider Commander"] = "Kommandant der Sturmlanzenwidderreiter",		
	["Frostwolf Wolf Rider Commander"] = "Wolfsreiterkommandant der Frostwölfe", 

	 -- patterns
	--["Upgrade to"] = "Upgrade", -- the option to upgrade units in AV	 === NEEDS TO BE CHECKED ===
	["Wicked, wicked, mortals!"] = "Böse, böse sterbliche Wesen!", -- what Ivus says after being summoned
	["Ivus begins moving"] = "Ivus setzt sich in Bewegung",
	["WHO DARES SUMMON LOKHOLAR"] = "WER WAGT ES, LOKHOLAR ZU BESCHWÖREN", -- what Lok says after being summoned
	["The Ice Lord has arrived!"] = "Der Eislord ist da!",
	["Lokholar begins moving"] = "Lokholar setzt sich in Bewegung",

	-- EotS
	["^(.+) has taken the flag!"] = "^(.+) hat die Fahne erobert!",
	["Bases: (%d+)  Victory Points: (%d+)/(%d+)"] = "Basen: (%d+)  Siegespunkte: (%d+)/(%d+)",
	
	-- IoC    -- translated by yoshimo
	 -- node keywords (text is also displayed on timer bar)
	["Alliance Keep"] = "Allianzfestung",
	["Horde Keep"] = "Hordenfestung",
	 -- Siege Engine keyphrases
	--["Goblin"] = true,  -- Horde mechanic name keyword  (same as default)
	["seaforium bombs"] = "diese Zephyriumbomben",  -- start (after capturing the workshop)
	["It's broken"] = "kaputt",  -- start again (after engine is destroyed)
	["halfway"] = "Haltet",  -- middle
})