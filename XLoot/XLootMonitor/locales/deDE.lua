local L = AceLibrary("AceLocale-2.2"):new("XLootMonitor")

L:RegisterTranslations("deDE", function()
	return {
		catGrowth = "Zeilenaufbau",
		catLoot = "Loot",
		catPosSelf = "Ankerpunkt...",
		catPosTarget = "Zu...",
		catPosOffset = "Fenster Versatz...",
		catModules = "Module",
		
		moduleHistory = "XLoot Aufzeichnung",
		moduleActive = "Aktiv",
		
		historyTime = "Zeige nach Zeit",
		historyPlayer = "Zeige nach Spieler",
		["View by item"] = "Zeige nach Item",
		historyClear = "L\195\182sche derzeitige Aufzeichnung",
		historyEmpty = "Keine Aufzeichnung vorhanden",
		historyTrunc = "Maximale Item Weite",
		historyMoney = "Gelootetes Geld",
		["Export history"] = "Export der Aufzeichnung",
		["No export handlers found"] = "Keine Epxortsteuerungsprogramme gefunden",
		["Simple XML copy-export"] = "Einfacher XML Export",
		["Copy-Paste Pipe Separated List"] = "Kopieren/Einf\195\188gen",
		["Press Control-C to copy the log"] = "Dr\195\188cke STRG+C um das Log zu kopieren",
		
		["Display Options"] = "Anzeige Optionen",
		
		optStacks = "Stapel/Anker",
		optLockAll = "Sperre alle Fenster",
		optPositioning = "Positionierung",
		optMonitor = "XLoot Monitor",
		optAnchor = "Zeige Anker",
		optPosVert = "Vertikal",
		optPosHoriz = "Horizontal",
		optTimeout = "Zeitlimit",
		optDirection = "Richtung",
		optThreshold = "Stapelgrenze",
		optQualThreshold = "Qualit\195\164tsgrenze",
		optSelfQualThreshold = "Eigene Qualit\195\164tsgrenze",
		optUp = "Hoch",
		optDown = "Runter",
		optMoney = "Zeige gelootete M\195\188nzen",
		["Show countdown text"] = "Zeige Countdowntext",
		["Show totals of your items"] = "Zeige Gesamtanzahl deiner Items",
		["Show small text beside the item indicating how much time remains"] = "Zeige kleinen Text neben dem Item, welcher die verbleibende Zeit anzeigt",
		["Trim item names to..."] = "K\195\188rze Itemnamen ab...",
		["Length in characters to trim item names to"] = "L\195\164nge in Buchstaben ab der Itemnamen gek\195\188rzt werden soll",
		["Show winning group loot"] = "Zeige gewonnennen Gruppenloot",
		["Show group roll choices"] = "Zeige die Wahl, der Gruppenmitglieder",
		
		descStacks = "Optionen f\195\188r alle individuellen Stapel, wie Anker, Sichtbarkeit und Zeitlimit.",
		descPositioning = "Position und Anhang von Zeilen im Stapel",
		descMonitor = "XLootMonitor Plugin Konfiguration",
		descAnchor = "Zeige Anker f\195\188r diesen Stapel",
		descPosVert = "Versetzt die Reihe vertikal von dem Ankerpunkt um die eingestellte Menge",
		descPosHoriz = "Versetzt die Reihe horizontal von dem Ankerpunkt um die eingestellte Menge",
		descTimeout = "Zeit bis zum ausblenden der Reihen. |cFFFF5522Auf 0 setzten um das Ausblenden ganz zu deaktivieren",
		descDirection = "Richtung des Aufbaus der Reihen",
		descThreshold = "Maximale Anzahl von Reihen",
		descQualThreshold = "Die niedrigste Qualit\195\164t der anderen Items die vom Monitor angezeigt werden",
		descSelfQualThreshold = "Die niedrigste Qualit\195\164t der eigenen Items die vom Monitor angezeigt werden",
		descMoney = "Zeigt die geteilte Anzahl der M\195\188nzen welche gelootet wurden. |cFFFF0000Beinhaltet noch keine einzelne M\195\188nzen.|r",
		
		optPos = {
			TOPLEFT = "Obere linke Ecke",
			TOP = "Oberer Rand",
			TOPRIGHT = "Obere rechte Ecke",
			RIGHT = "Rechter Rand",
			BOTTOMRIGHT = "Untere rechte Ecke",
			BOTTOM = "Unterer Rand",
			BOTTOMLEFT = "Untere linke Ecke",
			LEFT = "Linker Rand",
		},
			-- TOPLEFT = "Top left corner", two times?
		
		linkErrorLength = "Durch diesen Link w\195\188rde die Nachricht zu lang. Sende oder l\195\182sche die Nachricht und versuche es erneut.",
		
		playerself = "Du", 
	}
end)
-- -- 
--    Ä : \195\132
--    Ö : \195\150
--    Ü : \195\156
--    ü : \195\188
--    ä : \195\164                    
--    ö : \195\182
--    ß : \195\159
-- -- 