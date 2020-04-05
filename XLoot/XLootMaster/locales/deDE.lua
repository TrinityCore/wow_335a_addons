-- When translating, please leave all tokens ([item], etc) in english, the parser will not handle translated tokens. Thanks =)
local L = AceLibrary("AceLocale-2.2"):new("XLootMaster")

L:RegisterTranslations("deDE", function()
	return {
		["Self loot"] = "Selbst Looten",
		["Priority Looters"] = "Priorit\195\164tsspieler",
		["No priority players"] = "Keine Priorit\195\164tsspieler",
		["Possible victims"] = "M\195\182gliche Opfer",
		["Move up"] = "Bewege nach oben",
		["Move Down"] = "Bewege nach unten",
		["Remove"] = "Entferne",
		["Random"] = "Zuf\195\164llig",
		["Give to random player"] = "An zuf\195\164lligen Spieler verteilen",
		["Clear list and announce new roll"] = "L\195\182sche Liste und k\195\188ndige neue W\195\188rfelrunde an",
		["|cFF2255FFListening... |cFF44FF44%s|cFF2255FF seconds left"] = "|cFF2255FFLausche... |cFF44FF44%s|cFF2255FF sekunden \195\188brig",
		["|CFFBBBBBBRoll finished"] = "|CFFBBBBBBW\195\188rfelrunde beendet",
		[">> Priority configuration"] = ">> Priorit\195\164tskonfiguration",
		
		["Never"] = "Nie",
		-- ["XLoot Master"] = true,
		["XLoot Master plugin, replacement for the standard Master Looter dropdown."] = "XLoot Master Plugin, Ersatz f\195\188r das Standard Pl\195\188ndermeister Men\195\188",
		["Item tooltip"] = "Item-Tooltip",
		["Show a tooltip for the ML item when mousing over it."] = "Zeige dem PM einen Item-Tooltip beim dr\195\188berfahren mit dem Cursor",
		["Player tooltip"] = "Spieler-Tooltip",
		["Show a tooltip for each player when mousing over them."] = "Zeige ein Tooltip f\195\188r jeden Spieler beim dr\195\188berfahren mit dem Cursor",
		["Value utilities"] = "Hilfsmittel",
		-- ["Various tools such as tracking dkp assignments, broadcasting value along with assignment, and such. |cffff0000Doesn't do much yet.|r"] = true,
		["Awarded item text"] = "Angek\195\188ndigter Text",
		["Default: |cffff0000[name] awarded [item][method]|r\n[name] is replaced with the name of the player, \n[item] with the item link, \n[method] with any special note (dkp, random), if it exists, eg: ' (Random)'."] = "Standard: |cffff0000[name] bekommt [item][method]|r\n[name] der Name des Spielers, \n[item] das Item, \n[method] die Sonderinformation (dkp, random), wenn vorhanden, zB: ' (Random)'.",
		["A string containing any of [range], [item], or [time]"] = "Ein Wort, welches eins von [range], [item], oder [time] beinhaltet",
		["Thresholds"] = "Grenzwerte",
		["Confirmation threshold"] = "Best\195\164tigungsgrenzwert",
		["The lowest quality of item to open the assignment confirmation window for."] = "Die niedrigste Qualit\195\164t eines Items, welches das Best\195\164tigungsfenster \195\182ffnet.",
		["Item value threshold"] = "Itemgrenzwert",
		["The lowest quality of item to open the assignment |cFF22EE22and value|r confirmation window for."] = "Die niedrigste Qualit\195\164t eines Items, welches das Best\195\164tigungsfenster und Zuordnungsfenster (|cFF22EE22Wert|r) \195\182ffnet.",
		["Announce to group..."] = "Melde der Gruppe...",
		["Announce to /rw..."] = "Melde dem Schlachtzug...",
		["Announce to guild..."] = "Melde der Gilde...",
		["Randomization"] = "Zuf\195\164lligkeitsmen\195\188",
		["Random menu"] = "Zufallsmen\195\188",
		["Show the Random menu for loot distribution."] = "Zeigt das Zufallsmen\195\188 f\195\188r die Lootverteilung.",
		["Capture /rolls"] = "Erfasse /w\195\188rfeln",
		["Capture party member /roll #'s"] = "Erfasse die W\195\188rfe aller Gruppenmitglieder",
		["Show all rolls"] = "Zeige alle W\195\188rfe",
		["If enabled, show all rolls during a request, even ones not matching set range."] = "Wenn Aktiviert, werden alle W\195\188rfe angezeigt, selbst diejenigen die au\195\159erhalb des Bereichs sind.",
		["Roll timeout"] = "Zeitlimit beim W\195\188rfeln",
		["Length of time to capture rolls"] = "Die Zeit w\195\164hrend W\195\188rfe erfasst werden",
		["Roll range"] = "Wurfgeltungsbereich",
		["Range to request players to roll in"] = "Der Bereich in der Spieler w\195\188rfeln sollten",
		["Roll request text"] = "Anzuk\195\188ndigender Text bei Wurf",
		["Default: |cffff0000Attention! Please /roll [range] for [item]. Ends in [time] seconds.|r\n[range] is replaced with the range you pick, \n[item] with the item link, \n[time] with seconds in countdown."] = "Standard: |cffff0000Achtung! Bitte, /w\195\188rfeln [range] f\195\188r [item]. Endet in [time] Sekunden.|r\n[range] wird ersetzt mit dem ausgew\195\164hlten Bereich, \n[item] mit dem Item, \n[time] mit den Sekunden des Countdowns.",
		-- ["A string containing any of [range], [item], or [time]"] = "Ein Wort, welches eins von [range], [item], oder [time] beinhaltet", no need? same as above.
		
		[" Please enter the value of the item."] = " Bitte den Wert des Items eintragen.",
		["Value: "] = "Wert: ",
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