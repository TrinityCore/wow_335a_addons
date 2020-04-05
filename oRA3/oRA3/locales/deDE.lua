local L = LibStub("AceLocale-3.0"):NewLocale("oRA3", "deDE")

if not L then return end

-- Generic
L["Name"] = "Name"
L["Checks"] = "Checks"
L["Disband Group"] = "Gruppe auflösen"
L["Disbands your current party or raid, kicking everyone from your group, one by one, until you are the last one remaining.\n\nSince this is potentially very destructive, you will be presented with a confirmation dialog. Hold down Control to bypass this dialog."] = "Löst die Gruppe oder den Schlachtzug auf, indem nacheinander jeder rausgeworfen wird, bis nur noch du übrig bist.\n\nDa dies sehr destruktiv sein kann, wirst du eine Bestätigung sehen. Halte STRG gedrückt, um diesen Dialog zu umgehen."
L["Options"] = "Optionen"
L["<oRA3> Disbanding group."] = "<oRA3> Gruppe aufgelöst."
L["Are you sure you want to disband your group?"] = "Bist du sicher, dass du die Gruppe auflösen willst?"
L["Unknown"] = "Unbekannt"

-- Core
L["Toggle oRA3 Pane"] = "oRA3 Fenster öffnen/schließen"
L["Open with raid pane"] = "Mit Schlachtzugsfenster öffnen"
L.toggleWithRaidDesc = "Öffnet und schließt das oRA3 Fenster zusammen mit Blizzards Schlachtzugsfenster. Falls du diese Option deaktivierst, kannst du das oRA3 Fenster nach wie vor via Tastenbelegung oder einem Befehl öffnen, z.B. |cff44ff44/radur|r."
L["Show interface help"] = "Interface Hilfe anzeigen"
L.showHelpTextsDesc = "Das oRA3 Interface ist voll von hilfreichen Tips, die eine bessere Beschreibung der einzelnen Elemente liefern und deren Funktion erklären. Falls du diese Option deaktivierst, begrenzt du das Durcheinander in allen Fenstern. |cffff4411Manche Fenster benötigen ein Neuladen des Interfaces.|r"

L["Slash commands"] = "Befehle"
L.slashCommands = [[
oRA3 verfügt über eine Reihe von Befehlen, die in hektischer Raidumgebung hilfreich sein können. Für den Fall, dass du in den alten CTRA-Tagen nicht dabei warst: Eine kleine Referenz. Alle Befehle haben diverse Abkürzungen, aber manchmal auch längere, aussagekräftigere Alternativen.

|cff44ff44/radur|r - Öffnet die Haltbarkeitsliste.
|cff44ff44/razone|r - Öffnet die Zonenliste.
|cff44ff44/rares|r - Öffnet die Widerstandsliste.
|cff44ff44/radisband|r - Löst die Gruppe ohne Bestätigung auf.
|cff44ff44/raready|r - Führt einen Bereitschaftscheck durch.
|cff44ff44/rainv|r - Läd die gesamte Gilde in deine Gruppe ein.
|cff44ff44/razinv|r - Läd Gildenmitglieder in deiner aktuellen Zone ein.
|cff44ff44/rarinv <rank name>|r - Läd Gildenmitglieder eines bestimmten Rangs ein.
]]

-- Ready check module
L["The following players are not ready: %s"] = "Die folgenden Spieler sind nicht bereit: %s"
L["Ready Check (%d seconds)"] = "Bereitschaftscheck (%d Sekunden)"
L["Ready"] = "Bereit"
L["Not Ready"] = "Nicht bereit"
L["No Response"] = "Keine Antwort"
L["Offline"] = "Offline"
L["Play a sound when a ready check is performed."] = "Sound abspielen, wenn ein Bereitschaftscheck durchgeführt wird."
L["Show window"] = "Fenster anzeigen"
L["Show the window when a ready check is performed."] = "Zeigt das Fenster, wenn ein Bereitschaftscheck durchgeführt wird."
L["Hide window when done"] = "Fenster nach Durchlauf schließen"
L["Automatically hide the window when the ready check is finished."] = "Schließt das Fenster automatisch, sobald der Bereitschaftscheck durchgelaufen ist."
L["Hide players who are ready"] = "Bereite Spieler ausblenden"
L["Hide players that are marked as ready from the window."] = "Blendet Spieler, die als bereit markiert wurden, aus dem Fenster aus."

-- Durability module
L["Durability"] = "Haltbarkeit"
L["Average"] = "Durchschnitt"
L["Broken"] = "Kaputt"
L["Minimum"] = "Minimum"

-- Resistances module
L["Resistances"] = "Widerstände"
L["Frost"] = "Frost"
L["Fire"] = "Feuer"
L["Shadow"] = "Schatten"
L["Nature"] = "Natur"
L["Arcane"] = "Arkan"

-- Invite module
L["Invite"] = "Einladen"
L["All max level characters will be invited to raid in 10 seconds. Please leave your groups."] = "Alle Charaktere auf Maximallevel werden in 10 Sekunden in den Raid eingeladen. Bitte verlasst Eure Gruppen."
L["All characters in %s will be invited to raid in 10 seconds. Please leave your groups."] = "Alle Charaktere in %s werden in 10 Sekunden in den Raid eingeladen. Bitte verlasst Eure Gruppen."
L["All characters of rank %s or higher will be invited to raid in 10 seconds. Please leave your groups."] = "Alle Charaktere des Rangs %s oder höher werden in 10 Sekunden in den Raid eingeladen. Bitte verlasst Eure Gruppen." 
L["<oRA3> Sorry, the group is full."] = "<oRA3> Sorry, die Gruppe ist voll."
L["Invite all guild members of rank %s or higher."] = "Läd alle Gildenmitglieder des Rangs %s oder höher ein."
L["Keyword"] = "Schlüsselwort"
L["When people whisper you the keywords below, they will automatically be invited to your group. If you're in a party and it's full, you will convert to a raid group. The keywords will only stop working when you have a full raid of 40 people. Setting a keyword to nothing will disable it."] = "Wenn Spieler Dir das unten aufgeführte Schlüsselwort zuflüstern, werden sie automatisch in deine Gruppe eingeladen. Wenn du in einer bereits vollen Gruppe bist, wird diese in eine Raidgruppe umgewandelt. Die Schlüsselwortmethode funktioniert so lange, bis der Raid volle 40 Mann erreicht hat. Wenn nichts als Schlüsselwort angegeben wird, wird die Methode ausgeschalten."
L["Anyone who whispers you this keyword will automatically and immediately be invited to your group."] = "Jeder, der Dir dieses Schlüsselwort zuflüstert, wird automatisch und sofort in deine Gruppe eingeladen."
L["Guild Keyword"] = "Gildenschlüsselwort"
L["Any guild member who whispers you this keyword will automatically and immediately be invited to your group."] = "Jedes Gildenmitglied, das Dir dieses Schlüsselwort zuflüstert, wird automatisch und sofort in deine Gruppe eingeladen."
L["Invite guild"] = "Gilde einladen"
L["Invite everyone in your guild at the maximum level."] = "Läd jeden in deiner Gilde ein, der auf Maximallevel ist."
L["Invite zone"] = "Zone einladen"
L["Invite everyone in your guild who are in the same zone as you."] = "Läd jeden in deiner Gilde ein, der sich in der selben Zone wie Du aufhält."
L["Guild rank invites"] = "Gildenränge einladen"
L["Clicking any of the buttons below will invite anyone of the selected rank AND HIGHER to your group. So clicking the 3rd button will invite anyone of rank 1, 2 or 3, for example. It will first post a message in either guild or officer chat and give your guild members 10 seconds to leave their groups before doing the actual invites."] = "Sobald Du auf einen der unteren Buttons klickst, werden alle Mitglieder des ausgewählten Rangs UND DARÜBERLIEGENDE in deine Gruppe eingeladen. Dementsprechend läd z.B. das Klicken auf den dritten Button jeden des Rangs 1, 2 und 3 ein. Dies wird zudem entweder eine Nachricht im Gilden- oder Offizierschat auslösen, die deinen Gildenmitgliedern 10 Sekunden Zeit gibt, ihre Gruppen zu verlassen, bevor sie wirklich eingeladen werden."

-- Promote module
L["Demote everyone"] = "Massendegradierung"
L["Demotes everyone in the current group."] = "Degradiert jeden in deiner aktuellen Gruppe."
L["Promote"] = "Befördern"
L["Mass promotion"] = "Massenbeförderung"
L["Everyone"] = "Jeder"
L["Promote everyone automatically."] = "Befördert automatisch jeden."
L["Guild"] = "Gilde"
L["Promote all guild members automatically."] = "Befördert automatisch alle Gildenmitglieder."
L["By guild rank"] = "Nach Gildenrang"
L["Individual promotions"] = "Individuelle Beförderungen"
L["Note that names are case sensitive. To add a player, enter a player name in the box below and hit Enter or click the button that pops up. To remove a player from being promoted automatically, just click his name in the dropdown below."] = "Beachte, dass Spielernamen abhängig von Groß- und Kleinschreibung sowie Sonderzeichen sind. Um einen Spieler hinzuzufügen, musst Du seinen Namen in der untenstehenden Box eingeben und Enter oder den aufpoppenden Button drücken. Um einen Spieler zu entfernen, musst Du nur seinen Namen im Dropdown Menü anklicken."
L["Add"] = "Hinzufügen"
L["Remove"] = "Entfernen"

-- Cooldowns module
L["Open monitor"] = "Anzeige öffnen"
L["Cooldowns"] = "Cooldowns"
L["Monitor settings"] = "Einstellungen der Anzeige"
L["Show monitor"] = "Anzeige einschalten"
L["Lock monitor"] = "Anzeige sperren"
L["Show or hide the cooldown bar display in the game world."] = "Schaltet die Anzeige der Cooldowns in der Spielwelt ein oder aus."
L["Note that locking the cooldown monitor will hide the title and the drag handle and make it impossible to move it, resize it or open the display options for the bars."] = "Beachte, dass das Sperren der Anzeige den Titel versteckt und die Möglichkeiten entfernt, die Größe zu ändern, die Anzeige zu bewegen oder die Leistenoptionen aufzurufen."
L["Only show my own spells"] = "Nur eigene Zaubersprüche anzeigen"
L["Toggle whether the cooldown display should only show the cooldown for spells cast by you, basically functioning as a normal cooldown display addon."] = "Entscheidet, ob nur eigene Abklingzeiten angezeigt werden sollen. Funktioniert wie ein normales Addon zur Anzeige eigener Cooldowns."
L["Cooldown settings"] = "Auswahl der Cooldowns"
L["Select which cooldowns to display using the dropdown and checkboxes below. Each class has a small set of spells available that you can view using the bar display. Select a class from the dropdown and then configure the spells for that class according to your own needs."] = "Wähle über das untenstehende Dropdown Menü und die Checkboxen, welche Cooldowns angezeigt werden sollen. Jede Klasse verfügt über ein paar voreingestellte Zaubersprüche, deren Cooldowns dann über die Anzeige eingesehen werden können. Wähle eine Klasse und markiere dann die Sprüche, die deinen Vorlieben entsprechen."
L["Select class"] = "Klasse wählen"
L["Never show my own spells"] = "Niemals eigene Zaubersprüche anzeigen"
L["Toggle whether the cooldown display should never show your own cooldowns. For example if you use another cooldown display addon for your own cooldowns."] = "Entscheidet, ob nur die Abklingzeiten anderer Spieler angezeigt werden sollen. Nützlich, wenn Du z.B. zur Anzeige deiner Cooldowns ein anderes Addon nutzt."

-- monitor
L["Cooldowns"] = "Cooldowns"
L["Right-Click me for options!"] = "Rechts-klicken für Optionen!"
L["Bar Settings"] = "Leisteneinstellungen"
L["Spawn test bar"] = "Testleiste erzeugen"
L["Use class color"] = "Klassenfarben"
L["Custom color"] = "Eigene Farbe"
L["Height"] = "Höhe"
L["Scale"] = "Skalierung"
L["Texture"] = "Textur"
L["Icon"] = "Symbol"
L["Show"] = "Anzeigen"
L["Duration"] = "Dauer"
L["Unit name"] = "Spielername"
L["Spell name"] = "Zauberspruch"
L["Short Spell name"] = "Zauberspruch abkürzen"
L["Label Align"] = "Textausrichtung"
L["Left"] = "Links"
L["Right"] = "Rechts"
L["Center"] = "Mittig"
L["Grow up"] = "Nach oben erweitern"

-- Zone module
L["Zone"] = "Zone"

-- Loot module
L["Leave empty to make yourself Master Looter."] = "Freilassen, um dich selbst zum Plündermeister zu machen."
L["Let oRA3 to automatically set the loot mode to what you specify below when entering a party or raid."] = "Lässt oRA3 die Plündermethode bei Gruppen- oder Schlachtzugsbeitritt automatisch auf unten angegebenes setzen."
L["Set the loot mode automatically when joining a group"] = "Die Plündermethode bei Gruppenbeitritt automatisch setzen"

-- Tanks module
L["Tanks"] = "Tanks"
L.tankTabTopText = "Klicke auf Spieler in der unteren Liste, um sie zu persönlichen Tanks zu machen. Falls du Hilfe bei den verschiedenen Optionen brauchst, solltest du deine Maus über das Fragezeichen bewegen."
-- L["Remove"] is defined above
L.deleteButtonHelp = "Entfernt den Spieler aus der Tankliste."
L["Blizzard Main Tank"] = "Blizzard Main Tank"
L.tankButtonHelp = "Setzt oder entfernt den Blizzard MT-Status."
L["Save"] = "Speichern"
L.saveButtonHelp = "Speichert den Tank in deiner persönlichen Liste. Von nun an wird dieser Tank immer als persönlicher Tank gesetzt, sobald ihr zusammen in einer Gruppe seid."
L["What is all this?"] = "Um was geht es hier?"
L.tankHelp = "Spieler in der oberen Liste sind deine persönlichen, sortierten Tanks. Diese Liste wird nicht mit dem Raid geteilt, jeder kann daher eine andere persönliche Tankliste haben. Sobald du einen Namen in der unteren Liste anklickst, wird dieser zu deiner persönlichen Tankliste hinzugefügt.\n\nSobald du auf das Schild-Symbol klickst, wird der Spieler zum Blizzard Main Tank befördert. Blizzard MTs werden für alle Schlachtzugsmitglieder gesetzt, daher musst du Assistent oder höher sein.\n\nTanks, die in der Liste erscheinen, weil jemand anders sie als Blizzard MT gesetzt hat, werden automatisch aus der Liste gelöscht, sobald ihr Tankstatus entfernt wird.\n\nBenutze das grüne Häckchen, um Tanks zwischen Schlachtzügen zu speichern. Sobald du das nächste Mal mit diesem Spieler in einem Schlachtzug bist, wird er automatisch als persönlicher Tank gesetzt."
L["Sort"] = "Sortieren"
L["Click to move this tank up."] = "Hier klicken, um den Tank nach oben zu schieben."
L["Show"] = "Einblenden"
L.showButtonHelp = "Blendet diesen Tank in deiner Tankanzeige ein. Diese Option hat nur einen lokalen Effekt und verändert nicht den Tankstatus des betroffenen Spielers für alle anderen Gruppenmitglieder."
