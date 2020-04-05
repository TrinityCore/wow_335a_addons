-- German Localization:
-- Done by Suan(Kaz'goroth)
if (GetLocale()=="deDE") then
	loothog_version = "3.3.3"
	LOOTHOG_TITLE = "Loothog " .. loothog_version
	BINDING_NAME_LOOTHOGTOGGLE = "Show/Hide Window"
	BINDING_HEADER_LOOTHOG = "LootHog"
	LOOTHOG_ROLL_PATTERN = "(.+) würfelt. Ergebnis: (%d+) %((%d+)%-(%d+)%)" --hopefully fixes the Â character problems
	LOOTHOG_PASS_PATTERN = "passe"
	LOOTHOG_RESETONWATCH_PATTERN = "hat mit einem Wurf von"
	LOOTHOG_RESETONWATCH_PATTERN2 = "dasselbe Ergebnis gehabt!"

-- size of the main and options/config window
	LOOTHOG_UI_MAIN_WIDTH = "190"
	LOOTHOG_UI_CONFIG_WIDTH = "410"
	LOOTHOG_UI_CONFIG_HEIGHT = "520"

	LOOTHOG_ADDON_LABEL_OPTIONS = "Global Options"
	LOOTHOG_ADDON_LABEL_HANDLE = "Roll Handling"
	LOOTHOG_ADDON_LABEL_RULES = "Rules"
	LOOTHOG_ADDON_LABEL_ABOUT = "About"

	LOOTHOG_LABEL_DELIMITER = "------------------"
	LOOTHOG_LABEL_WINNERSDELIMITER = "=================="
	LOOTHOG_LABEL_CHATLISTTOP = "Würfe in aufsteigender Reihenfolge"
	LOOTHOG_LABEL_ROLLS = "LootHog Würfelergebnisse"
	LOOTHOG_LABEL_RULES = "LootHog Regeln"
	LOOTHOG_LABEL_READY = "Bereit..."	-- Means that LootHog is ready to receive /random rolls.
	LOOTHOG_LABEL_OPTIONS = "LootHog Optionen"
	LOOTHOG_LABEL_HOLDING = "Warten..."	-- Means that the user has clicked "Hold" to prevent the timeout.
	LOOTHOG_LABEL_NOTIMEOUT = "TimeOut aus."
	LOOTHOG_LABEL_TIMELEFT = "TimeOut: %s Sek."	-- (seconds)
	LOOTHOG_LABEL_COUNTDOWN = "Countdown"
	LOOTHOG_LABEL_COUNT = "W\195\188rfe:%s, Spieler:%s"	-- (roll count, player count)

	LOOTHOG_BUTTON_CLEAR = "L\195\182schen"
	LOOTHOG_BUTTON_OPTIONS = "Optionen"
	LOOTHOG_BUTTON_HOLD = "Warten"
	LOOTHOG_BUTTON_UNHOLD = "Warten aus"
	LOOTHOG_BUTTON_ANNOUNCE = "Ansagen"
	LOOTHOG_BUTTON_ASSIGN = "Assign"
	LOOTHOG_BUTTON_YETTOROLL = "Nicht gew\195\188rfelt"
	LOOTHOG_BUTTON_INFO = "Entfernen"
	LOOTHOG_BUTTON_ROLL = "W\195\188rfeln (1-100)"
	LOOTHOG_BUTTON_OFFSPEC = "Sec Roll"
	LOOTHOG_BUTTON_PASS = "Passen"
	LOOTHOG_BUTTON_COUNTDOWN = "Countdown"
	LOOTHOG_BUTTON_START = "Start"
	LOOTHOG_BUTTON_RULES = "Regeln"
	LOOTHOG_BUTTON_MODE = "Mode"
	LOOTHOG_BUTTON_ANNOUNCERULES = "Regeln Ausgeben"
	LOOTHOG_BUTTON_ANNOUNCELOOT = "Loot Ausgeben"
	LOOTHOG_LABEL_OFF = "Loothog Rolls - Off"
	LOOTHOG_LABEL_ON = "Loothog Rolls - Auto"
	LOOTHOG_LABEL_MANUAL = "Loothog Rolls - Manual"
	LOOTHOG_LABEL_QUIET = "Loothog Rolls - Quiet"


	LOOTHOG_OPTION_ENABLE = "LootHog aktivieren"	
	LOOTHOG_OPTION_MANUAL = "Würfe nur zählen, wenn ich LootHog gestartet habe"
	LOOTHOG_OPTION_QUIET = "Quiet Mode"
	LOOTHOG_OPTION_AUTOSHOW = "LootHog automatisch zeigen sobald jemand würfelt"	
	LOOTHOG_OPTION_RESETONWATCH = "LootHog deaktivieren wenn jemand anderes den Gewinner ankündigt"	
	LOOTHOG_OPTION_GROUPONLY = "Würfelergebisse nur von Gruppenmitgliedern anzeigen"
	LOOTHOG_OPTION_SHOWALLLOOTBUTTON = "Zeige den 'Loot ausgeben' Button"
	LOOTHOG_OPTION_MASTERLOOTERONLY = "Nur wenn ich Plündermeister bin"
	LOOTHOG_OPTION_OVERRIDEREFRESH = "Überschreibe Standard-Intervall. Erneuere alle "
	LOOTHOG_OPTION_FRAMES = "Frames"

	LOOTHOG_OPTION_LISTTOCHAT = "Ausgabe von maximal"
	LOOTHOG_OPTION_LISTTOCHAT2 = "Würfelergebnissen in den Chat"

	LOOTHOG_OPTION_PREVENT = "Ausgabe der /random Befehle im Chat verhindern"
	LOOTHOG_OPTION_CLOSEONANNOUNCE = "LootHog schließen nach Bekanntgabe des Siegers"
	LOOTHOG_OPTION_CLEARONCLOSE = "Würfe löschen wenn das Hautpfenster geschlossen wird"
	LOOTHOG_OPTION_ACK = "Bestätige Würfe über /whisper an die Spieler"

	LOOTHOG_OPTION_REJECT = "Lehne Würfe mit Werten ausserhalb von (1-100) ab"
    LOOTHOG_OPTION_LOWER = " - "
    LOOTHOG_OPTION_UPPER = ")"
    LOOTHOG_OPTION_NOTIFYME = "Mir anzeigen wenn ein Wurf abgelehn wurde"
  LOOTHOG_OPTION_OFFSPEC = "Offspec Würfe erlauben ("
    LOOTHOG_OPTION_OFFSPEC_LOWER = " - "
    LOOTHOG_OPTION_OFFSPEC_UPPER = ")"
  LOOTHOG_OPTION_AUTOOFFSPEC = "Automatisch Offspec ansagen wenn keiner würfelt"
    LOOTHOG_OPTION_ANNOUNCEOFFSPEC = "Ansage für Offspec:"
    LOOTHOG_OPTION_OFFSPEC_ROLL_TEXT = "OFFSPEC!"
    LOOTHOG_OPTION_OFFSPECTIMEOUT = "Offspec-Timeout aktivieren und einstellen auf"
  LOOTHOG_OPTION_REJECTCLASS = "Würfe von ungültigen Klassen verweigern"
    LOOTHOG_OPTION_ANNOUNCEREJECT = "Abgelehnte Würfe im Chatfenster ansagen"

  LOOTHOG_OPTION_ANNOUNCEONCLEAR = "Beim Löschen ausgeben:"
    LOOTHOG_OPTION_NEW_ROLL_TEXT = "New roll starting now !"
	LOOTHOG_OPTION_ANNOUNCETIMEOUT = "TimeOut beim start bekanntgeben"
   	LOOTHOG_OPTION_ANNOUNCECLASS = "Gültige Klassen ansagen"
   	LOOTHOG_OPTION_ANNOUNCECLASSTK = "Nur für Marken"

  LOOTHOG_OPTION_TIMEOUT1 = "LootHog automatisch ausblenden nach"	
  	LOOTHOG_OPTION_TIMEOUT2 = "Sekunden"
  	LOOTHOG_OPTION_AUTOCOUNTDOWN = "Automatischer Countdown in den letzen"
		
    LOOTHOG_OPTION_AUTOEXTEND = "Timer auf"
	  LOOTHOG_OPTION_TIMEOUT3 = "Sek. setzen, bei einen Wurf in den letzen"
	  LOOTHOG_OPTION_ANNOUNCEEXTEND = "Erweiterte Ansagen"

	LOOTHOG_OPTION_FINALIZE = "Beenden der Würfelrunde nach Ablauf des TimeOuts"
	LOOTHOG_OPTION_AUTOASSIGN = "Automatically assign loot"
	LOOTHOG_OPTION_FINALIZEROLLS = "Beenden der Würfelrunde sobald alle gewürfelt haben"

    LOOTHOG_RULES_INTROLABEL = "Am Anfang der Regeln ausgeben:"
    LOOTHOG_RULES_INTRO = "Loothog Regeln:"
    LOOTHOG_RULES_ONEEPIC = "Nur ein Epic por Person"
    LOOTHOG_RULES_ONESET = "Nur ein Set-Teil / eine Marke pro Person"
    LOOTHOG_RULES_RESET = "Zurücksetzen wenn alle etwas bekommen haben"
	LOOTHOG_RULES_DISENCHANTER = "will disenchant items. "

    LOOTHOG_RULES_CHAT_DKP1 = "Ein Epic"
    LOOTHOG_RULES_CHAT_DKP2 = " und ein Set-Teil / eine Marke bekommen"
    LOOTHOG_RULES_CHAT_DKP3 = "Ein Set-Teil / eine Marke"
    LOOTHOG_RULES_CHAT_DKP4 = " pro Person."
    LOOTHOG_RULES_CHAT_RESET = "Du kannst erneut würfeln wenn alle Loot bekommen haben."
    LOOTHOG_RULES_CHAT_TIMEOUT = "Du hast %s Sekunden Zeit um zu würfeln."
    LOOTHOG_RULES_CHAT_BOUNDS = "Würfe von %s bis %s sind erlaubt."
    LOOTHOG_RULES_CHAT_OFFSPEC = " Für OffSpec würfle bitte von %s bis %s (/rnd %s %s)"
    LOOTHOG_RULES_CHAT_CLASSES = "Nur Würfe von Klassen die das Item auch benutzen können werden akzeptiert"

	LOOTHOG_MSG_LOAD = "LootHog v%s wurde geladen. Zum öffnen der Optionen /loothog tippen."	-- (version)
	LOOTHOG_MSG_INFO = "LootHog-Information: Durch Tippen des Textes \"%s\" kann man bei einer Würfelrunde verzichten."	-- (pass pattern)
	LOOTHOG_MSG_CHEAT = "%ss Wurf von %s (%s-%s) wird ignoriert."	-- (player, roll, max_roll, min_roll)
	LOOTHOG_MSG_CHEATCLASS = "Ignoriere %s's Wurf von %s (Ungültige Klasse)"
	LOOTHOG_MSG_ACK = "Dein Wurf von (%s) wurde gezählt.	Viel Glück!"	-- (roll)
	LOOTHOG_MSG_OFFSPEC_ACK = "Got your offspec roll (%s).  Good luck!"  -- (roll)
	LOOTHOG_MSG_ACK_PASS = "Du hast darauf verzichtet zu würfeln!"
	LOOTHOG_MSG_DUPE = "%s hat mehr als einmal gewürfelt. Der Wurf wird nicht gezählt!"	-- (player)
	LOOTHOG_MSG_WINNER = "%s%s hat mit einem Wurf von %s gewonnen! (%s-%s)" --(player, group, roll, min, max)
	LOOTHOG_MSG_ROLLS = "%s: %s hat eine %s gewürfelt"	-- (roll posistion, player, roll)
	LOOTHOG_MSG_ROLLS_OFFSPEC = "%s: %s rolled %s (Offspec)."  -- (roll posistion, player, roll)
	LOOTHOG_MSG_GROUP = "Gruppe"
	LOOTHOG_MSG_NOTGROUP= "Gruppe nicht gefunden"
	LOOTHOG_MSG_STAT = "Gesamtanzahl der Würfe: "
	LOOTHOG_MSG_HOLDCONT = "Loothog: Zähle Countdown bei %s Sekunden weiter."
	LOOTHOG_MSG_HOLDSTART = "Loothog: Countdown bei %s Sekunden angehalten."
	LOOTHOG_MSG_RESET = "Loothog: Neuer Wurf gefunden, Countdown auf %s Sekunden zurückgesetzt."
	LOOTHOG_MSG_TIMEANNOUNCE = "Nach %s Sekunden wird die Würfelrunde beendet!"
	LOOTHOG_MSG_CLASSES = "Klassen"
	

-- The following variables are used to build a string of this type, in the case of a tie:
-- "Gnomechomsky, Saucytails, and Pionerka tied with 98's!"
-- I don't know if a literal substitution can provide a proper translation. Feedback is welcome. :)
	LOOTHOG_MSG_AND = " und "
	LOOTHOG_MSG_TIED = " haben mit %s das selbe Ergebnis gehabt!"	-- (roll)
	LOOTHOG_MSG_YETTOPASS = "Folgende Spieler haben noch nicht gew\195\188rfelt oder verzichtet (per schreiben von %s in den Chat):" --(LOOTHOG_PASS_PATTERN)
	LOOTHOG_MSG_REMOVEROLL = "<LootHog>: %ss Ergebnis von %s wurde entfernt." -- (player, roll)

	LOOTHOG_DEATHKNIGHT_CLASS = "Todesritter"
	LOOTHOG_WARLOCK_CLASS = "Hexenmeister"
	LOOTHOG_PALADIN_CLASS = "Paladin"
	LOOTHOG_DRUID_CLASS = "Druide"
	LOOTHOG_MAGE_CLASS = "Magier"
	LOOTHOG_SHAMAN_CLASS = "Schamane"
	LOOTHOG_PRIEST_CLASS = "Priester"
	LOOTHOG_ROGUE_CLASS = "Schurke"
	LOOTHOG_HUNTER_CLASS = "Jäger"
	LOOTHOG_WARRIOR_CLASS = "Krieger"


	Loothog_Armor = "Rüstung"
	Loothog_Weapon = "Waffe"
	Loothog_Miscellaneous = "Sonstiges"
	Loothog_Cloth = "Stoff"
	Loothog_Leather = "Leder"
	Loothog_Mail = "Schwere Rüstung"
	Loothog_Plate = "Platte"
	
	Loothog_Bows = "Bogen"
	Loothog_Crossbows = "Armbrust"
	Loothog_Daggers = "Dolch"
	Loothog_Guns = "Schusswaffe"
	Loothog_FishingPoles = "Angel"
	Loothog_FistWeapons = "Faustwaffe"
	Loothog_OneHandedAxes = "Einhandaxt"
	Loothog_OneHandedMaces = "Einhandstreitkolben"
	Loothog_OneHandedSwords = "Einhandschwert"
	Loothog_Polearms = "Satngenwaffe"
	Loothog_Staves = "Stab"
	Loothog_Thrown = "Wurfwaffe"
	Loothog_TwoHandedAxes = "Zweihandaxt"
	Loothog_TwoHandedMaces = "Zweihandstreitkolben"
	Loothog_TwoHandedSwords = "Zweihandschwert"
	Loothog_Wands = "Zauberstab"

	LOOTHOG_SLASH_TITLE = "Slash Kommandos"
	LOOTHOG_SLASH_TITLEUL = "============="
	LOOTHOG_SLASH_ROLL = "/LH Roll wwürfelt in den angegebenen Grenzen (%s - %s)"
	LOOTHOG_SLASH_LINK = "/LH <ItemLink> wstartet Loothog  und gibt das Item an."
	LOOTHOG_SLASH_CONFIG = "/LH Config oder /LH Options lädt das Eistellungs Fenster"
	LOOTHOG_SLASH_TOGGLE = "/LH enable schaltet Loothog ein / aus"
	LOOTHOG_SLASH_MANUAL = "/LH manual schaltet manuellen Modus ein / aus"
	LOOTHOG_SLASH_MODE = "/LH mode schaltet zwische den Modi um (Aus, Auto, Manuell)"
	LOOTHOG_SLASH_COUNTDOWN = "/LH Countdown startet den Countdown von %s Sekunden"
	LOOTHOG_SLASH_HOLD = "/LH Hold Pausiert den Countdown bzw. lässt ihn weiterlaufen"
	LOOTHOG_SLASH_HOLDRESET = "Loothog wird den Countdown bei %s Sekunden fortsetzen"
	LOOTHOG_SLASH_KICK = "/LH Kick löscht das beste Würfelergebnis"
	LOOTHOG_SLASH_ANNOUNCE = "/LH Announce gibt den Gewinner im Chat aus"
	LOOTHOG_SLASH_ASSIGN = "/LH Assign will assign loot to the winner (or DEer or Yourself)"
	LOOTHOG_SLASH_CLEAR = "/LH Clear löscht alle Würfelergebnise und schlatet in den Standby-Betrieb"
	LOOTHOG_SLASH_NOTROLLED = "/LH Notrolled gibt eine Liste der Spieler aus, die noch nicht gewürfelt haben"
	LOOTHOG_SLASH_LIST = "/LH list listet die besten %s Spieler auf"
	LOOTHOG_SLASH_START = "/LH Start startet loothog aus dem Standby"
	LOOTHOG_SLASH_START1 = "Loothog startet den eingestellten Countdown"
	LOOTHOG_SLASH_OFFSPEC = "/LH offspec würfelt für Offspec (%s - %s)"
	LOOTHOG_SLASH_RULES = "/LH Rules gibt die Regeln im Gruppen- / Raidchat aus"
	LOOTHOG_SLASH_RESET = "/LH Reset löscht alle Einstellungen und stellt die standard Einstellungen wiederher"
	LOOTHOG_SLASH_HELP = "/LH Help zeigt dieses Fenster"

	LOOTHOG_ABOUT_SEPERATOR = "**************************"
	LOOTHOG_ABOUT_AUTHOR = "Autor: "
	LOOTHOG_ABOUT_AUTHORNAME = "Leucocepha, Serenity - Proudmoore"
	LOOTHOG_ABOUT_THANKS = "Dank geht an: "
	LOOTHOG_ABOUT_THANKS1 = "Chompers für das ursprüngliche AddOn"
	LOOTHOG_ABOUT_THANKS2 = "Suan (Kaz'goroth) - Coding, Deutsche Übersetzung"
	LOOTHOG_ABOUT_THANKS3 = "Codeus - Coding"
	LOOTHOG_ABOUT_THANKS4 = "dblixer - Offspec Coding"
	LOOTHOG_ABOUT_THANKS5 = "Erytheia - Code Bereiningung, Testen"
	LOOTHOG_ABOUT_THANKS6 = "Devilcat - Bugfixes"
	LOOTHOG_ABOUT_THANKS7 = "m0rgoth - Französische Übersetzung"
  	LOOTHOG_ABOUT_THANKS8 = "ShyMun - Spanish Translation"
  	LOOTHOG_ABOUT_THANKS9 = "Ufi82 - German Translation"

	LOOTHOG_ERROR_NOLOOT = "LOOTHOG ERROR : Can't find loot item"
	LOOTHOG_ERROR_NOMEMBER = "LOOTHOG ERROR : Can't find raid member"
	LOOTHOG_ERROR_LOOTWINDOW = "LOOTHOG ERROR :: You must have the loot window open to assign loot"
	LOOTHOG_ERROR_PARTY = "LOOTHOG ERROR :: You must be in a party or raid to assign loot"
	LOOTHOG_ERROR_MASTERLOOTER = "LOOTHOG ERROR :: You must be the Master Looter to assign loot"
end