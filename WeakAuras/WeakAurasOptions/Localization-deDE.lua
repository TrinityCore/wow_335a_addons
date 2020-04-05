if not(GetLocale() == "deDE") then
    return;
end

local L = WeakAuras.L

-- Options translation
L["1 Match"] = "1 Treffer"
L["Actions"] = "Aktionen"
L["Activate when the given aura(s) |cFFFF0000can't|r be found"] = "Aktiviere falls die angegebenen Auren |cFFFF0000nicht|r gefunden werden"
L["Add a new display"] = "Neue Anzeige hinzufügen"
L["Add Dynamic Text"] = "Dynamischen Text hinzufügen"
L["Addon"] = "Addon"
L["Addons"] = "Addons"
L["Add to group %s"] = "Zur Gruppe %s hinzufügen"
L["Add to new Dynamic Group"] = "Neue dynamische Gruppe hinzufügen"
L["Add to new Group"] = "Neue Gruppe hinzufügen"
L["Add Trigger"] = "Auslöser hinzufügen"
L["A group that dynamically controls the positioning of its children"] = "Eine Gruppe, die dynamisch die Position ihrer Kinder steuert"
L["Align"] = "Ausrichten"
L["Allow Full Rotation"] = "Erlaubt eine vollständige Rotation"
L["Alpha"] = "Transparenz"
L["Anchor"] = "Anker"
L["Anchor Point"] = "Ankerpunkt"
L["Angle"] = "Winkel"
L["Animate"] = "Animieren"
L["Animated Expand and Collapse"] = "Erweitern und Verbergen animieren"
L["Animation relative duration description"] = [=[Die Dauer der Animation relativ zur Dauer der Anzeige als Bruchteil (1/2), als Prozent (50%) oder als Dezimal (0.5).
|cFFFF0000Notiz:|r Falls die Anzeige keine Dauer besitzt (zb. Aura ohne Dauer) wird diese Animation nicht ausgeführt.

|cFF4444FFFBeispiel:|r
Falls die Dauer der Animation auf |cFF00CC0010%|r gesetzt wurde und die Dauer der Anzeige 20 Sekunden beträgt (zb. Debuff), dann wird diese Animation über eine Dauer von 2 Sekunden abgespielt.
Falls die Dauer der Animation auf |cFF00CC0010%|r gesetzt wurde undfür die Anzeige keine Dauer bekannt ist (Meistens kann diese auch manuell festgelegt werden) wird diese Animation nicht abgespielt.]=]
L["Animations"] = "Animationen"
L["Animation Sequence"] = "Animations-Sequenz"
L["Aquatic"] = "Wasser"
L["Aura (Paladin)"] = "Paladin Aura"
L["Aura(s)"] = "Auren"
L["Auto"] = "Auto"
L["Auto-cloning enabled"] = "Auto-Klonen aktiviert"
L["Automatic Icon"] = "Automatisches Symbol"
L["Backdrop Color"] = "Hintergrundfarbe" -- Needs review
L["Backdrop Style"] = "Hintergrundstil" -- Needs review
L["Background"] = "Hintergrund"
L["Background Color"] = "Hintergrundfarbe"
L["Background Inset"] = "Hintergrundeinzug"
L["Background Offset"] = "Hintergrundversatz"
L["Background Texture"] = "Hintergrundtextur"
L["Bar Alpha"] = "Balkentransparenz"
L["Bar Color"] = "Balkenfarbe"
L["Bar Color Settings"] = "Balkenfarben Einstellungen" -- Needs review
L["Bar in Front"] = "Balken im Vordergrund" -- Needs review
L["Bar Texture"] = "Balkentextur"
L["Battle"] = "Angriff"
L["Bear"] = "Bär"
L["Berserker"] = "Berserker"
L["Blend Mode"] = "Blendmodus"
L["Blood"] = "Blut"
L["Border"] = "Rand"
L["Border Color"] = "Randfarbe" -- Needs review
L["Border Inset"] = "Rahmeneinlassung" -- Needs review
L["Border Offset"] = "Randversatz"
L["Border Settings"] = "Rahmeneinstellungen" -- Needs review
L["Border Size"] = "Rahmengröße" -- Needs review
L["Border Style"] = "Rahmenstil" -- Needs review
L["Bottom Text"] = "Text unten"
L["Button Glow"] = "Aktionsleisten Glanz"
L["Can be a name or a UID (e.g., party1). Only works on friendly players in your group."] = "Kann ein Name oder eine UID (zb. party1) sein. Funktioniert nur für freundliche Spieler innerhalb deiner Gruppe."
L["Cancel"] = "Abbrechen"
L["Cat"] = "Katze"
L["Change the name of this display"] = "Den Namen der Anzeige ändern"
L["Channel Number"] = "Chatnummer"
L["Check On..."] = "Prüfen auf..."
L["Choose"] = "Auswählen"
L["Choose Trigger"] = "Auslöser Auswählen"
L["Choose whether the displayed icon is automatic or defined manually"] = "Symbol automatisch oder manuell auswählen"
L["Clone option enabled dialog"] = [=[
Eine Option die |cFFFF0000Auto-Klonen|r verwendet wurde aktiviert.

|cFFFF0000Auto-Klonen|r dupliziert automatisch eine Anzeige um mehrere passende Quellen (zb. Auren) darzustellen.
Solange die Anzeige sich nicht in einer |cFF22AA22Dynamischen Gruppe|r befindet, werden alle Klone nur hintereinander angeordnet.

Soll die Anzeige in einer neuen |cFF22AA22Dynamischen Gruppe|r plaziert werden?]=]
L["Close"] = "Schließen"
L["Collapse"] = "Minimieren"
L["Collapse all loaded displays"] = "Alle geladenen Anzeigen minimieren"
L["Collapse all non-loaded displays"] = "Alle nicht geladenen Anzeigen minimieren"
L["Color"] = "Farbe"
L["Compress"] = "Stauchen"
L["Concentration"] = "Konzentration"
L["Constant Factor"] = "Konstanter Faktor"
L["Control-click to select multiple displays"] = "|cFF8080FF(CTRL-Klick)|r Mehrere Anzeigen auswählen"
L["Controls the positioning and configuration of multiple displays at the same time"] = "Eine Gruppe, die die Position und Konfiguration ihrer Kinder kontrolliert"
L["Convert to..."] = "Umwandeln zu..."
L["Cooldown"] = "Abklingzeit"
L["Copy"] = "Kopieren"
L["Copy settings from..."] = "Kopiere Einstellungen von ..."
L["Copy settings from another display"] = "Kopiere Einstellungen von einer anderen Anzeige"
L["Copy settings from %s"] = "Kopiere Einstellungen von %s"
L["Count"] = "Anzahl"
L["Creating buttons: "] = "Erstelle Schaltflächen:"
L["Creating options: "] = "Erstelle Optionen:"
L["Crop X"] = "Abschneiden (X)"
L["Crop Y"] = "Abschneiden (Y)"
L["Crusader"] = "Kreuzfahrer"
L["Custom Code"] = "Benutzerdefinierter Code"
L["Custom Trigger"] = "Benutzerdefinierter Auslöser"
L["Custom trigger event tooltip"] = [=[Wähle die Events, die den benutzerdefinierten Auslöser aufrufen sollen.
Mehrere Events können durch Komma oder Leerzeichen getrennt werden.

|cFF4444FFBeispiel:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
L["Custom trigger status tooltip"] = [=[Wähle die Events, die den benutzerdefinierten Auslöser aufrufen sollen.
Da es sich um einen Zustands-Auslöser handelt, kann es passieren, dass WeakAuras nicht die in der WoW-API spezifizierten Argumente übergibt.
Mehrere Events können durch Komma oder Leerzeichen getrennt werden.

|cFF4444FFBeispiel:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
L["Custom Untrigger"] = "Benutzerdefinierter Umkehr-Auslöser"
L["Custom untrigger event tooltip"] = [=[Wähle die Events, die den benutzerdefinierten Umkehr-Auslöser aufrufen sollen.
Diese Events müssen nicht denen der benutzerdefinierten Auslöser entsprechen.
Mehrere Events können durch Komma oder Leerzeichen getrennt werden.

|cFF4444FFBeispiel:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
L["Death"] = "Tod"
L["Death Rune"] = "Todes Rune"
L["Debuff Type"] = "Debufftyp"
L["Defensive"] = "Defensive"
L["Delete"] = "Löschen"
L["Delete all"] = "Alle löschen"
L["Delete children and group"] = "Lösche Gruppe und ihre Kinder"
L["Deletes this display - |cFF8080FFShift|r must be held down while clicking"] = "|cFF8080FF(SHIFT-Klick)|r Lösche Anzeige"
L["Delete Trigger"] = "Auslöser löschen"
L["Desaturate"] = "Entsättigen"
L["Devotion"] = "Hingabe"
L["Disabled"] = "Deaktiviert"
L["Discrete Rotation"] = "Rotation um x90°"
L["Display"] = "Anzeige"
L["Display Icon"] = "Anzeigesymbol"
L["Display Text"] = "Anzeige-Text"
L["Distribute Horizontally"] = "Horizontal verteilen"
L["Distribute Vertically"] = "Vertical verteilen"
L["Do not copy any settings"] = "Keine Einstellungen kopieren"
L["Do not group this display"] = "Anzeige nicht gruppieren"
L["Duplicate"] = "Duplizieren"
L["Duration Info"] = "Dauerinformationen"
L["Duration (s)"] = "Dauer (s)"
L["Dynamic Group"] = "Dynamische Gruppe"
L["Dynamic text tooltip"] = [=[Es werden einige spezielle Codes für dynamischen Text angeboten:

|cFFFF0000%p|r - Fortschritt - Die verbleibende Dauer der Anzeige
|cFFFF0000%t|r - Gesamt - Die maximale Dauer der Anzeige
|cFFFF0000%n|r - Name - Der (dynamische) Name der Anzeige (zb. Auraname) oder die ID der Anzeige
|cFFFF0000%i|r - Symbol - Das (dynamische) Symbol der Anzeige
|cFFFF0000%s|r - Stacks - Die Anzahl der Stacks
|cFFFF0000%c|r - Custom - Verwendet den String-Rückgabewert der benutzerdefinierten Lua-Funktion]=]
L["Enabled"] = "Aktivieren"
L["Enter an aura name, partial aura name, or spell id"] = "Auraname, Teilname oder Zauber-ID"
L["Event Type"] = "Ereignistyp"
L["Expand"] = "Erweitern"
L["Expand all loaded displays"] = "Alle geladenen Anzeigen erweitern"
L["Expand all non-loaded displays"] = "Alle nicht geladenen Anzeigen erweitern"
L["Expand Text Editor"] = "Erweiterter Texteditor"
L["Expansion is disabled because this group has no children"] = "Erweitern nicht möglich, da Gruppe keine Kinder besitzt"
L["Export"] = "Exportieren"
L["Export to Lua table..."] = "Als Lua-Tabelle exportieren..."
L["Export to string..."] = "Als Klartext exportieren..."
L["Fade"] = "Verblassen"
L["Finish"] = "Endanimation"
L["Fire Resistance"] = "Feuerresistenz"
L["Flight(Non-Feral)"] = "Flug"
L["Font"] = "Schriftart"
L["Font Flags"] = "Schrifteinstellungen" -- Needs review
L["Font Size"] = "Schriftgröße"
L["Font Type"] = "Schriftart" -- Needs review
L["Foreground Color"] = "Vordergrundfarbe"
L["Foreground Texture"] = "Vordergrundtextur"
L["Form (Druid)"] = "Form (Druide)"
L["Form (Priest)"] = "Form (Priester)"
L["Form (Shaman)"] = "Form (Schamane)"
L["Form (Warlock)"] = "Form (Hexenmeister)"
L["Frame"] = "Frame"
L["Frame Strata"] = "Frame-Schicht"
L["Frost"] = "Frost"
L["Frost Resistance"] = "Frostresistenz"
L["Full Scan"] = "Kompletter Scan"
L["Ghost Wolf"] = "Geisterwolf"
L["Glow Action"] = "Leuchtaktion"
L["Group aura count description"] = [=[
Anzahl an Gruppen-/Raidmitgliedern die von einer der Auren betroffen sein muss um den Trigger auszulösen.
Es kann entweder ein fixer Wert sein (zb. 5) oder relativ sein (zb. 50%).
Falls die Zahl im Format als Bruch (1/2), Prozent (50%) oder Dezimal (0.5) vorliegt, wird sie relativ zur Größe der aktuellen Gruppenstärke gesetzt.

|cFF4444FFBeispiel:|r
 > 0 - Lößt aus, wenn jemand betroffen ist
 = 100%% - Lößt aus, wenn alle betroffen sind
 != 2 - Lößt aus, wenn weniger oder mehr als 2 Spieler betroffen sind
 <= 0.8 - Lößt aus, wenn 80%% betroffen sind (4/5, 8/10 oder 20/25)
 > 1/2 - Lößt aus, wenn die Hälfte der Mitglieder betroffen sind
 >= 0 - Lößt immer aus]=]
L["Group Member Count"] = "Gruppengröße"
L["Group (verb)"] = "Gruppe"
L["Height"] = "Höhe"
L["Hide this group's children"] = "Kinder der Gruppe verbergen"
L["Hide When Not In Group"] = "Falls nicht in Gruppe, dann verbergen"
L["Horizontal Align"] = "Horizontal Ausrichten"
L["Icon Info"] = "Symbolinfo"
L["Ignored"] = "Ignoriert"
L["Ignore GCD"] = "Globale Abklingzeit ignorieren"
L["%i Matches"] = "%i Treffer"
L["Import"] = "Importieren"
L["Import a display from an encoded string"] = "Anzeige von Klartext importieren"
L["Justify"] = "Ausrichten"
L["Left Text"] = "Text links"
L["Load"] = "Laden"
L["Loaded"] = "Geladen"
L["Main"] = "Hauptanimation"
L["Main Trigger"] = "Hauptauslößer"
L["Mana (%)"] = "Mana (%)"
L["Manage displays defined by Addons"] = "Bearbeite Anzeigen von externen Addons"
L["Message Prefix"] = "Nachrichtenprefix"
L["Message Suffix"] = "Nachrichtensuffix"
L["Metamorphosis"] = "Metamorphose"
L["Mirror"] = "Spiegeln"
L["Model"] = "Modell"
L["Moonkin/Tree/Flight(Feral)"] = "Mondkin"
L["Move Down"] = "Runter bewegen"
L["Move this display down in its group's order"] = "Anzeige innerhalb der Gruppe nach unten bewegen"
L["Move this display up in its group's order"] = "Anzeige innerhalb der Gruppe nach oben bewegen"
L["Move Up"] = "Hoch bewegen"
L["Multiple Displays"] = "Mehrere Anzeigen"
L["Multiple Triggers"] = "Mehrere Auslöser"
L["Multiselect ignored tooltip"] = [=[
|cFFFF0000Ignoriert|r - |cFF777777Einfach|r - |cFF777777Mehrfach|r
Diese Option wird nicht verwendet um zu prüfen wann die Anzeige geladen wird.]=]
L["Multiselect multiple tooltip"] = [=[
|cFFFF0000Ignoriert|r - |cFF777777Einfach|r - |cFF777777Mehrfach|r
Beliebige Anzahl an Werten zum vergleichen können ausgewählt werden.]=]
L["Multiselect single tooltip"] = [=[
|cFFFF0000Ignoriert|r - |cFF777777Einfach|r - |cFF777777Mehrfach|r
Nur ein Wert kann ausgewählt werden.]=]
L["Must be spelled correctly!"] = "Muss korrekt geschrieben sein!"
L["Name Info"] = "Namensinfo"
L["Negator"] = "Negator"
L["New"] = "Neu"
L["Next"] = "Weiter"
L["No"] = "Nein"
L["No Children"] = "Keine Kinder"
L["Not all children have the same value for this option"] = "Nicht alle Kinder besitzten den selben Wert"
L["Not Loaded"] = "Nicht geladen"
L["No tooltip text"] = "Kein Tooltip"
L["% of Progress"] = "Fortschritt in %"
L["Okay"] = "Okey"
L["On Hide"] = "Beim Ausblenden"
L["Only match auras cast by people other than the player"] = "Nur Auren von anderen Spielern"
L["Only match auras cast by the player"] = "Nur Auren vom Spieler selbst"
L["On Show"] = "Beim Einblenden"
L["Operator"] = "Operator"
L["or"] = "oder"
L["Orientation"] = "Orientierung"
L["Other"] = "Sonstige"
L["Outline"] = "Umriss"
L["Own Only"] = "Nur eigene"
L["Player Character"] = "Spieler Charakter (PC)"
L["Play Sound"] = "Sound abspielen"
L["Presence (DK)"] = "Präsenz (Todesritter)"
L["Presence (Rogue)"] = "Präsenz (Schurke)"
L["Prevents duration information from decreasing when an aura refreshes. May cause problems if used with multiple auras with different durations."] = "Verhindert, dass die Anzeige der Dauer der Aura sich verringert beim erneuern. Kann zu Problemen bei mehreren Auren führen!"
L["Primary"] = "Erste"
L["Progress Bar"] = "Fortschrittsbalken"
L["Progress Texture"] = "Fortschrittstextur"
L["Put this display in a group"] = "Anzeige zu einer Gruppe hinzufügen"
L["Ready For Use"] = "Benutzterfertig"
L["Re-center X"] = "Zentrum (X)"
L["Re-center Y"] = "Zentrum (Y)"
L["Remaining Time Precision"] = "Genauigkeit der verbleibenden Zeit"
L["Remove this display from its group"] = "Anzeige aus Gruppe entfernen"
L["Rename"] = "Umbennen"
L["Requesting display information"] = "Forde Anzeigeinformationen von %s an"
L["Required For Activation"] = "Vorrausgesetzt für Aktivierung"
L["Retribution"] = "Vergeltung"
L["Right-click for more options"] = "|cFF8080FF(Right-Klick)|r Mehr Optionen"
L["Right Text"] = "Text rechts"
L["Rotate"] = "Rotieren"
L["Rotate In"] = "Nach innen rotieren"
L["Rotate Out"] = "Nach außen rotieren"
L["Rotate Text"] = "Text rotieren"
L["Rotation"] = "Rotation"
L["Same"] = "Gleich"
L["Search"] = "Suchen"
L["Secondary"] = "Zweite"
L["Send To"] = "Senden an"
L["Set tooltip description"] = "Tooltipbeschreibung festlegen"
L["Shadow Dance"] = "Schattentanz"
L["Shadowform"] = "Schattenform"
L["Shadow Resistance"] = "Schattenresistenz"
L["Shift-click to create chat link"] = "|cFF8080FF(Shift-Klick)|r Chatlink erstellen"
L["Show all matches (Auto-clone)"] = "Alle Treffer anzeigen (Auto-Klonen)"
L["Show players that are |cFFFF0000not affected"] = "Zeige Spieler die |cFFFF0000nicht|r betroffen sind"
L["Shows a 3D model from the game files"] = "Zeigt ein 3D Modell"
L["Shows a custom texture"] = "Zeigt eine benutzerdefinierte Textur"
L["Shows a progress bar with name, timer, and icon"] = "Zeigt einen Fortschrittsbalken mit Name, Zeitanzeige und Symbol"
L["Shows a spell icon with an optional a cooldown overlay"] = "Zeigt ein (Zauber-) Symbol mit optionalem Abklingzeit-Overlay"
L["Shows a texture that changes based on duration"] = "Zeigt eine Textur, die sich über die Zeit verändert"
L["Shows one or more lines of text, which can include dynamic information such as progress or stacks"] = "Zeigt ein oder mehrere Zeilen Text an, der dynamische Informationen anzeigen kann, z.B. Fortschritt oder Stacks"
L["Shows the remaining or expended time for an aura or timed event"] = "Zeigt die verbleibende oder verstrichene Zeit einer Aura oder eines zeitlichen Ereignisses"
L["Show this group's children"] = "Kinder der Gruppe anzeigen"
L["Size"] = "Größe"
L["Slide"] = "Gleiten"
L["Slide In"] = "Einschieben"
L["Slide Out"] = "Ausschieben"
L["Sort"] = "Sortieren"
L["Sound"] = "Sound"
L["Sound Channel"] = "Soundkanal"
L["Sound File Path"] = "Sounddatei"
L["Space"] = "Abstand"
L["Space Horizontally"] = "Horizontaler Abstand"
L["Space Vertically"] = "Verticaler Abstand"
L["Spell ID"] = "Zauber-ID"
L["Spell ID dialog"] = [=[
Es wurde eine Aura/Zauber/ect. über |cFFFF0000Spell-ID|r definiert.

|cFF8800FFWeakAuras|r kann standardmäßig aus Performancegründen nicht zwischen Auren/Zaubern/ect. mit selben Namen aber unterschiedlichen |cFFFF0000Spell-IDs|r unterscheiden.
Wird allerdings |cFFFF0000Alle Auren scannen (CPU-Intensiv)|r aktiviert kann |cFF8800FFWeakAuras|r explizit nach bestimmten |cFFFF0000Spell-IDs|r suchen.

Soll |cFFFF0000Alle Auren scannen (CPU-Intensiv)|r aktiviert werden um diese |cFFFF0000Spell-ID|r zu finden?]=]
L["Stack Count"] = "Stackanzahl"
L["Stack Count Position"] = "Stackposition"
L["Stack Info"] = "Stackinfo"
L["Stacks Settings"] = "Stacks Einstellungen"
L["Stagger"] = "Taumeln"
L["Stance (Warrior)"] = "Haltung (Krieger)"
L["Start"] = "Start"
L["Stealable"] = "Zauberraub"
L["Stealthed"] = "Getarnt"
L["Sticky Duration"] = "Tesa-Dauer"
L["Temporary Group"] = "Temporäre Gruppe"
L["Text"] = "Text"
L["Text Color"] = "Textfarbe"
L["Text Position"] = "Textposition"
L["Text Settings"] = "Text Einstellungen"
L["Texture"] = "Textur"
L["The children of this group have different display types, so their display options cannot be set as a group."] = "Anzeigeoptionen für diese Gruppe können nicht dargetsellt werden, weil die Kinder dieser Gruppe verschiedene Anzeigetypen haben."
L["The duration of the animation in seconds."] = "Die Dauer der Animation in Sekunden."
L["The type of trigger"] = "Auslösertyp"
L["This condition will not be tested"] = "Diese Bedingungen werden nicht getestet"
L["This display is currently loaded"] = "Diese Anzeige ist zur Zeit geladen"
L["This display is not currently loaded"] = "Diese Anzeige ist zur Zeit nicht geladen"
L["This display will only show when |cFF00FF00%s"] = "Diese Anzeige wird nur eingezeigt, wenn |cFF00FF00%s"
L["This display will only show when |cFFFF0000 Not %s"] = "Diese Anzeige wird nur eingezeigt, wenn |cFF00FF00 nicht %s"
L["This region of type \"%s\" has no configuration options."] = "Diese Region vom Typ \"%s\" besitzt keine Einstellungsmöglichkeiten." -- Needs review
L["Time in"] = "Zeit in"
L["Timer"] = "Zeitgeber"
L["Timer Settings"] = "Timer Einstellungen"
L["Toggle the visibility of all loaded displays"] = "Sichtbarkeit aller geladener Anzeigen umschalten"
L["Toggle the visibility of all non-loaded displays"] = "Sichtbarkeit aller nicht geladener Anzeigen umschalten"
L["Toggle the visibility of this display"] = "Sichtbarkeit aller Anzeigen umschalten"
L["to group's"] = "an Gruppe"
L["Tooltip"] = "Tooltip"
L["Tooltip on Mouseover"] = "Tooltip bei Mausberührung"
L["Top Text"] = "Text oben"
L["to screen's"] = "an Bildschirm"
L["Total Time Precision"] = "Gesamtzeit Genauigkeit"
L["Tracking"] = "Aufspüren"
L["Travel"] = "Reise"
L["Trigger"] = "Auslöser"
L["Trigger %d"] = "Auslöser %d"
L["Triggers"] = "Auslöser"
L["Type"] = "Typ"
L["Ungroup"] = "Nicht gruppiert"
L["Unholy"] = "Unheilig"
L["Unit Exists"] = "Einheit existiert"
L["Unlike the start or finish animations, the main animation will loop over and over until the display is hidden."] = "Anders als die Start- und Endanimation wird die Hauptanimation immer wieder wiederholt, bis die Anzeige in den Endstatus versetzt wird."
L["Unstealthed"] = "Entarnt"
L["Update Custom Text On..."] = "Aktualisiere benutzerdefinierten Text bei..."
L["Use Full Scan (High CPU)"] = "Alle Auren scannen (CPU-Intensiv)"
L["Use tooltip \"size\" instead of stacks"] = "Benutzte Tooltipgröße anstatt Stacks"
L["Vertical Align"] = "Vertikale Ausrichtung"
L["View"] = "Anzeigen"
L["Width"] = "Breite"
L["X Offset"] = "X-Versatz"
L["X Scale"] = "Skalierung (X)"
L["Yes"] = "Ja"
L["Y Offset"] = "Y-Versatz"
L["Y Scale"] = "Skalierung (Y)"
L["Z Offset"] = "Z-Versatz"
L["Zoom"] = "Zoom"
L["Zoom In"] = "Einzoomen"
L["Zoom Out"] = "Auszoomen"



