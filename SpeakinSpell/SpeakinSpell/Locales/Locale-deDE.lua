-- Deutsche Lokalisierungsdatei für -locale deDE-
-- Übersetzt vom Englischen ins Deutsche von Lexin


local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("SpeakinSpell", "deDE", false)
if not L then return end

SpeakinSpell:PrintLoading("Locales/Locale-deDE.lua")


-------------------------------------------------------------------------------
-- SLASH BEFEHLE (ZIEHE NICHT DAS VORANSTEHEND / MIT EIN)
-------------------------------------------------------------------------------


-- "/SpeakinSpell" Befehle und Abkürzungen.
L["speakinspell"] = "speakinspell"
L["ss"] = "ss"

-- Parameter für "/ss etwas"
L["options"]	= "optionen"	-- /ss Optionen
L["reset"]		= "zurücksetzen"-- /ss zurücksetzen
L["help"]		= "hilfe"		-- /ss hilfe
L["create"]	= "erstelle"	-- /ss erstelle
L["macro"]		= strlower(MACRO) -- /ss macro
L["colors"]		= strlower(COLORS) -- /ss colors
L["messages"]  = "nachrichten"	-- /ss nachrichten

L["advertise"]	= "weitersagen"	-- /ss weitersagen
L["ad "]		= "weitersagen "		-- benutzt in /ss weitersagen /w spielername (Falls der Spielername fehlt, wird das ausgewählte Ziel verwendet.)
L["ad /s"]		= "weitersagen /s"		-- /ss weitersagen /s
L["ad /p"]		= "weitersagen /p"		-- /ss weitersagen /p
L["ad /ra"]	= "weitersagen /ra"		-- /ss weitersagen /ra


-------------------------------------------------------------------------------
-- CHAT KANALNAMEN
-------------------------------------------------------------------------------
-- Diese Kanalnamen werden als anwählbare "Listenoptionen" im GUI dargestellt.


L["SAY"]			= "Sagen (/s)"
L["PARTY"]			= "Gruppe (/p)"
L["RAID"]			= "Schlachtzug (/ra)"
L["BATTLEGROUND"]	= "Schlachtfeld (/bg)"
L["EMOTE"]			= "Emote (/em)"
L["YELL"]			= "Schreien (/y)"
L["RAID_WARNING"]	= "Schlachtzugswarnung (/sw)"
L["Silent"]			= "Deaktiviert" -- Nachrichten sind ausgeschaltet.
L["GUILD"]			= "Guild (/g)"
L["SPEAKINSPELL CHANNEL"]	= "Self-Chat (SpeakinSpell:)"
L["SELF RAID WARNING CHANNEL"] = "Self-Only Raid Warning"
L["RAID_BOSS_WHISPER"]	= "Boss Whisper"
L["MYSTERIOUS VOICE"]="[Mysterious Voice] whispers:"
L["COMM TRAFFIC RX"]	= "Comm Traffic Received (Rx)"
L["COMM TRAFFIC TX"]	= "Comm Traffic Sent (Tx)"


-------------------------------------------------------------------------------
-- ERSATZVARIABLEN (SUBSTITUTION TABLES)
-------------------------------------------------------------------------------
-- Dies sind die Ersatzvariablen welche in den zufälligen Sprüchen genutzt werden können.

L["target"] = "ziel"
L["focus"] = "fokus"
L["targetclass"] = "zielklasse"
L["targetrace"] = "zielrasse"
L["player"] = "spieler"
L["caster"] = "zauberwirker"
L["spellname"] = "zaubername"
L["spellrank"] = "zauberrang"
L["spelllink"] = "zauberlink"
L["pet"] = "begleiter"


-------------------------------------------------------------------------------
-- ARTEN VON EREIGNISSEN
-------------------------------------------------------------------------------

-- Die Typen der Ereignisse, wie sie in der Liste der erkannten Ereignisse erscheinen

-- Benenne die Liste unter Nachrichteneinstellungen.
L["Select a Speech Event"] = "Wähle einen Zauber/Fähigkeit oder ein anderes Ereignis."
L["Select a spell from the list to configure the random announcements for that spell."] = "Wähle einen hinzugefügten Zauber, eine Fähigkeit oder anderes Ereignis von der Liste um zufällige Sprüche dafür zu konfigurieren."
-- Ein anderer Tooltip der für dieselbe Art von Liste unter Erstelle neu genutzt wird.
L["This is a list of all the detected spells, abilities, items, and procced effects which SpeakinSpell has seen you cast or receive recently."] = [[Dies ist eine Liste von allen Zaubern, Fähigkeiten, Items, Proc-Effekten und anderen Ereignissen, welche Speakinspell kürzlich automatisch erkannt hat.]]

-- Akürzungen die in der Liste von Zaubern benutzt werden
L["Misc. Event: "] = "Systemereignis: "-- ..Ereignisname
L["When I Type: /ss "] = "Wenn ich folgendes tippe: /ss "-- ..Eingabe ==> "Benutzer Makroevent: /ss makro etwas"
L["When I buff myself with: "]	= "Wenn ich mich selbst buffe mit: "--..zaubername
L["When I debuff myself with: "] = "Wenn ich mich selbst debuffe mit: "--..zaubername
L["When someone else buffs me with: "]	= "Wenn sonst jemand mich bufft mit: "--..zaubername
L["When someone else debuffs me with: "]= "Wenn sonst jemand mich debufft mit: "--..zaubername
L["When I Start Casting: "] = "Wenn ich das Zauberwirken starte: "--..zaubername (rang)


L["_ Show All Types of Events _"] = "Zeige alle Typen von Ereignissen"
L["Misc. Events"] = "Nur Systemereignisse"
L["/ss macro things you type"] = "Nur /ss makro Sachen die du schreibst"
L["Self Buffs (includes procs)"] = "Nur Selbstbuffs (Beinhaltet Proc-Effekte)"
L["Self Debuffs"] = "Nur Selbstdebuffs"
L["Buffs from Others (includes totems)"] = "Nur Buffs von Anderen"--..zaubername
L["Debuffs from Others"] = "Nur Debuffs von Anderen"--..zaubername
L["Spells, Abilities, and Items (Start Casting)"] = "Nur Zauber und Fähigkeiten"


-- Die Namen der "Ereignis" Arten
L["SpeakinSpell Loaded"]	= "SpeakinSpell geladen."
L["Entering Combat"]		= "Kampf beigetreten."
L["Exiting Combat"]			= "Kampf verlassen."


-------------------------------------------------------------------------------
-- OPTIONS UND MENÜPUNKTE SOWIE DAZUGEHÖRIGE TOOLTIPS
-------------------------------------------------------------------------------


L["General Settings"] = "Allgemeine Einstellungen."
L["General Settings for SpeakinSpell"] = "Allgemeine Einstellungen für SpeakinSpell."

L["Message Settings"] = "Nachrichteneinstellungen"
L["Create New..."] = "Erstelle neu..."
L["SpeakinSpell Help"] = "SpeakinSpell Hilfe"

L["Click here to create settings for a new spell, ability, effect, macro, or other event"] = "Klicke hier um Einstellungen für einen neuen Zauber, Fähigkeit, Effekt, Makro oder anderem Ereignis zu erstellen."

L["Stop SpeakinSpell from announcing the selected spell or event"] = "Stoppe Ansagen für den angewählten Zauber/Fähigkeit oder das Ereignis."

L["Enable Automatic SpeakinSpell Event Announcements"] = "Aktiviere SpeakinSpell."

L[
[[Enable this option to make SpeakinSpell show you (and only you) all of your own spell casting events and other events that can be announced.

This includes any spell, ability, item, /ss macro things, or automatically obtained effect (e.g. Trinkets or Talents) that you cast or use.]]
] = 
[[Aktiviere diese Funktion damit SpeakinSpell nur für dich sichtbar im Chat alle gewirkten Ereignisse anzeigt die SpeakinSpell automatisch erkennt.

Das beinhaltet alle Zauber, Fähigkeiten, Gegenstände oder selbstauslösende Effekte (z.B. Schmuckstücke oder Talente) die du benutzt oder automatisch wirkst.]]

L["Show Debugging Messages (verbose)"] = "Zeige ausführliche SpeakinSpell-Nachrichten zu Fehlersuche."

L["Remove the selected spell from the list"] = "Löscht den ausgewählten Zauber/Fähigkeit oder das Ereignis von der Liste."

L["Select the channel to use for this spell, while..."] = "Wähle den Kanal aus in den der oben ausgewählte Zauber oder die Fähigkeit die Sprüche sendet, während du..."

L["In a Battleground"] = "... in einem Schlachtfeld bist."
L["Select which channel to use for this spell while in a Battleground"] = "Wähle welcher Kanal für den oben ausgewählten Zauber oder die Fähigkeit genutzt wird, während du in einem Schlachtfeld bist."

L["In a Raid"] = "... in einem Schlachtzug bist."
L["Select which channel to use for this spell while in a Raid"] = "Wähle welcher Kanal für die Ansagen des oben ausgewählten Zauber oder die Fähigkeit genutzt wird, während du in einem Schlachtzug bist."

L["In a Party"] = "... in einer Gruppe bist."
L["Select which channel to use for this spell while in a Party"] = "Wähle welcher Kanal für den oben ausgewählten Zauber oder die Fähigkeit genutzt wird, während du in einer Gruppe bist."

L["By yourself"] = "... alleine bist."
L["Select which channel to use for this spell while playing solo"] = "Wähle welcher Kanal für den oben ausgewählten Zauber oder die Fähigkeit genutzt wird, während du alleine bist."

L["In Arena"] = "... in der Arena bist."
L["Select which channel to use for this spell while playing in the Arena"] = "Wähle welcher Kanal für den oben ausgewählten Zauber oder die Fähigkeit genutzt wird, während du in der Arena bist."

L["Whisper the message to your <target>"] = "Flüstere den Spruch zu deinem <Ziel>."
L[
[[Enable whispering the announcement to the friendly <target> of your spell.

Non-spell Speech Events also have a <target>. This uses the same target as the <target> substitution, and will not whisper to yourself.]]
] = [[Aktiviere das Flüstern zu einem "freundlichen" Ziel.
Funktioniert nicht falls du einen Zauber oder eine Fähigkeit auf dich selbst wirkst, oder einen Feind anwählst.]]

L["Random Chance (%)"] = "Prozentchance für das Auftreten eines Spruchs."
L[
[[You have a random chance to say a message each time you use the selected spell, based on this selected percentage.

100% will always speak. 0% will never speak.]]
] = [[
Jedes mal wenn du den oben ausgewählten Zauber oder die Fähigkeit benutzt, hast du basierend auf deinem ausgewählten Prozentwert eine Chance einen Spruch in den Chat zu senden. 

Bei 100% erscheint immer ein Spruch, bei 0% niemals.]]

L["Cooldown (seconds)"] = "Abklingzeit bis zum nächsten Spruch (In Sekunden)."
L["To prevent SpeakinSpell from speaking in the chat too often for this spell, you can set a cooldown for how many seconds must pass before SpeakinSpell will announce this spell again."] = [[
Um zu verhindern das SpeakinSpell für den ausgewählten Zauber/Fähigkeit oder Ereignis zu oft Sprüche in den Chat sendet kann eine Abklingzeit festgesetzt werden. 

Damit kann man bestimmen, wieviele Sekunden vergangen sein müssen bis SpeakinSpell für diesen Zauber, die Fähigkeit oder das Ereignis erneut einen Spruch senden kann.]]

L["Select a Category of Events"] = "Wähle eine bestimmte Kategorie von Ereignissen."
L["Show only this kind of event in the list below"] = "Zeige lediglich die ausgewählte Art von Ereignissen in der Liste unterhalb."

L["Select the new spell event you want to announce in chat above, then push this button"] = "Wähle oberhalb das neue Ereignis, für das du Ansagen in den Chat einstellen willst und bestätige hiermit."

L["Random Speech <number>"] = "Zufälliger Spruch <number>." -- Die Variable %d wird mit einer Nummer von 1 bis 50 ersetzt.
L[
[[Write an announcement for this event.

Duplicates of speeches listed above will not be accepted]]
] = "Gib hier etwas Witziges ein das gesagt werden soll." 


-------------------------------------------------------------------------------
-- ADDON MELDUNGEN (Keine zufälligen Sprüche - Diese sind System/Runtime-Nachrichten)
-------------------------------------------------------------------------------


L["Default settings restored"] = "Standarteinstellungen wiederhergestellt."


-------------------------------------------------------------------------------
-- DIE GEWÖHNLICHE NACHRICHT FÜR EINEN ZAUBER
-------------------------------------------------------------------------------


L["WARNING: can't execute protected command: <text>"] = "WARNUNG: Kann den verbotenen Befehl nicht ausführen: <text>"

L["Any Rank"] = "Jeden Rang"


------------------------------------------
---------- oldversions.lua      ----------
------------------------------------------
-- [buildlocales.py copy]

-- Localization of this file has to be careful because some localized strings
-- were used as functional table keys and may be required to match old data
--
-- If the L[] value is in source data, then it must be preserved forever in
--		order to be able to find matching data in old saved data
-- If the L[] value is a destination value, then it may use the newest value
--		which can freely be changed in order to perfect the translation
--		or change the way the UI looks
-- If the L[] value is not used in data at all because it is a status message
--		then it may be changed freely
-- Old transtions need to be saved following this naming convention
-- For locale files that didn't exist yet in these older versions, use English

-- DO NOT CHANGE! -- the value of L["/macro"] in release 3.1.2.05
L["3.1.2.05 /macro"] = "macro" --verified from SVN

-- DO NOT CHANGE! -- the <newline> substitution key word from 3.2.2.02
L["3.2.2.02 <newline>"] = "<newline>" --verified from SVN, had not been translated yet

-- DO NOT CHANGE! -- display names for some event hooks in 3.2.2.14
L["3.2.2.14 Entering Combat"] = "Kampf beigetreten." --verified from SVN
L["3.2.2.14 Exiting Combat"] = "Kampf verlassen." --verified from SVN
L["3.2.2.14 Whispered While In-Combat"] = "Whispered While In-Combat" --verified from SVN, had not been translated yet

-- REFERENCED OUTSIDE THIS FILE (authorized list) --
-- These are expected overlaps with other code files
-- The following warnings will be auto-detected by the script
-- The dominant translations used elsewhere in the UI may be used, and freely changed
--L["SpeakinSpell Loaded"] already defined under:SpeakinSpell.lua
--L["<newline>"] already defined under:gui/currentmessages.lua

-- OK TO CHANGE --
-- the remaining definitions below are auto-generated
-- they may be changed freely to provide the best possible translation

-- [buildlocales.py end of copy]
