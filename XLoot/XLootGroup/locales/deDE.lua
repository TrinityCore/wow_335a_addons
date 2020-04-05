local L = AceLibrary("AceLocale-2.2"):new("XLootGroup")

L:RegisterTranslations("deDE", function()
	return {
		["Show countdown text"] = "Zeigt Countdowntext",
		["Show small text beside the item indicating how much time remains"] = "Zeigt einen kleinen Text neben dem Item an, welcher die verbleibende Zeit anzeigt",
		["Show current rolls"] = "Zeigt die derzeitigen W\195\188rfe",
		["Show small text beside the item indicating how many have chosen what to roll"] = "Zeigt einen kleinen Text neben dem Item an, welcher die derzeitigen Bedarf/Gier/Passen W\195\188rfe anzeigt",
		["Fade out rows"] = "Zeilen ausblenden",
		["Smoothly fade rows out once rolled on."] = "Zeilen werden weich ausgeblendet, nachdem darauf gew\195\188rfelt wurde.",
		["Roll button size"] = "Gr\195\182\195\159e der W\195\188rfelschaltfl\195\164che",
		["Size of the Need, Greed, Disenchant and Pass buttons"] = "Gr\195\182\195\159e der Bedarf/Gier/Passen Schaltfl\195\164chen",
		-- ["XLoot Group"] = true,
		["A stack of frames for showing group loot information"] = "Ein Fensterstapel um Informationen zum Gruppenloot anzuzeigen",
		["Trim item names to..."] = "K\195\188rzt Itemnamen ab...",
		["Length in characters to trim item names to"] = "L\195\164nge in Buchstaben ab der Itemnamen gek\195\188rzt werden soll",
		["Prevent rolls on BoP items"] = "Vermeidet W\195\188rfe auf BoP Items",
		["Locks the Need and Greed buttons for any BoP items"] = "Sperrt die Bedarf/Gier Schaltfl\195\164chen bei jedem BoP Item",
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