if not(GetLocale() == "deDE") then
    return;
end

local L = WeakAuras.L

-- Options translation
L["Actions and Animations: 1/7"] = "Aktionen und Animationen: 1/7"
L["Actions and Animations: 2/7"] = "Aktionen und Animationen: 2/7"
L["Actions and Animations: 3/7"] = "Aktionen und Animationen: 3/7"
L["Actions and Animations: 4/7"] = "Aktionen und Animationen: 4/7"
L["Actions and Animations: 5/7"] = "Aktionen und Animationen: 5/7"
L["Actions and Animations: 6/7"] = "Aktionen und Animationen: 6/7"
L["Actions and Animations: 7/7"] = "Aktionen und Animationen: 7/7"
L["Actions and Animations Text"] = [=[Um die Animation zu testen muss die Anzeige versteckt und wieder eingeblendet werden. Dies lässt sich über den Ansicht-Knopf in der Seitenleiste erreichen.

Durch mehrmaliges Betätigen lässt sich die Start-Animation sehen.]=] -- Needs review
L["Activation Settings: 1/5"] = "Aktivierungseinstellungen: 1/5"
L["Activation Settings: 2/5"] = "Aktivierungseinstellungen: 2/5"
L["Activation Settings: 3/5"] = "Aktivierungseinstellungen: 3/5"
L["Activation Settings: 4/5"] = "Aktivierungseinstellungen: 4/5"
L["Activation Settings: 5/5"] = "Aktivierungseinstellungen: 5/5"
L["Activation Settings Text"] = "Da du ein %s bist, kannst du die Spielerklassen-Optionen aktivieren und %s auswählen." -- Needs review
L["Auto-cloning: 1/10"] = "Auto-Klonen: 1/10" -- Needs review
L["Auto-cloning 1/10 Text"] = [=[Die größte in |cFF8800FF1.4|r enthaltene Neuerung ist |cFFFF0000Auto-Klonen|r. |cFFFF0000Auto-Klonen|r erlaubt deinen Anzeigen sich automatisch zu vervielfältigen, um Informationen mehrerer Quellen anzuzeigen. Einer Dynamischen Gruppe hinzugefügt erlaubt dies die Anzeige umfangreicher dynamischer Informationssätze.

Es gibt drei Auslöser-Typen, die |cFFFF0000Auto-Klonen|r unterstützen: Voll-Scan Auras, Gruppen-Auras, and Mehrziel-Auras.]=] -- Needs review
L["Beginners Finished Text"] = [=[Hiermit ist die Einführung abgeschlossen. Allerdings hast du gerade mal einen kleinen Einblick in die Macht von |cFF8800FFWeakAuras|r bekommen.

Zukünftig werden |cFFFFFF00Weitere|r |cFFFF7F00Fortgeschrittene|r |cFFFF0000Tutorials|r veröffentlicht, die einen tieferen Einblick in |cFF8800FFWeakAuras|r endlose Möglichkeiten bieten werden.]=] -- Needs review
L["Beginners Guide Desc"] = "Einführung" -- Needs review
L["Beginners Guide Desc Text"] = "Eine Einführung in dir Grundeinstellungsmöglichkeiten von WeakAuras" -- Needs review
L["Create a Display: 1/5"] = "Eine Anzeige erzeugen: 1/5" -- Needs review
L["Create a Display: 2/5"] = "Eine Anzeige erzeugen: 2/5" -- Needs review
L["Create a Display: 3/5"] = "Eine Anzeige erzeugen: 3/5" -- Needs review
L["Create a Display: 4/5"] = "Eine Anzeige erzeugen: 4/5" -- Needs review
L["Create a Display: 5/5"] = "Eine Anzeige erzeugen: 5/5" -- Needs review
L["Create a Display Text"] = [=[Obwohl das Anzeige-Tab Schieberegler zur Steuerung von Breite, Höhe und X-/Y-Positionierung besitzt, gibt es eine einfachere Möglichkeit deine Anzeige zu bewegen und in der Größe anzupassen.

Du kannst deine Anzeige einfach anklicken und irgendwo auf den Bildschirm ziehen oder ihre Ecken anklicken und daran ziehen, um die Größe zu verändern.

Ebenso kannst du Shift drücken, um den Bewegungs-/Größeneinstellungsrahmen für genauere Positionierung zu verstecken.]=] -- Needs review
L["Display Options: 1/4"] = "Anzeige-Einstellungen: 1/4" -- Needs review
L["Display Options 1/4 Text"] = "Wähle jetzt eine Fortschrittsbalken-Anzeige aus (oder lege eine neue an)." -- Needs review
L["Display Options: 2/4"] = "Anzeige-Einstellungen: 2/4" -- Needs review
L["Display Options 2/4 Text"] = [=[|cFFFFFFFFFortschrittsbalken-|r und |cFFFFFFFFSymbol-Anzeigen|r haben nun eine Einstellungsmöglichkeit Tooltips beim Darüberhalten der Maus anzuzeigen.

Diese Einstellung ist nur verfügbar, wenn die Anzeige einen Auslöser der auf einer Aura, einem Gegenstand, oder einem Zauber basiert besitzt.]=] -- Needs review
L["Display Options: 4/4"] = "Anzeige-Einstellungen: 4/4" -- Needs review
L["Display Options 4/4 Text"] = "Zu guter letzt erlaubt der neue Anzeigentyp |cFFFFFFFFModell|r jedes beliebige 3D Modell aus den Spieldateien zu nutzen." -- Needs review
L["Dynamic Group Options: 2/4"] = "Dynamische Gruppen Einstellungen: 2/4" -- Needs review
L["Dynamic Group Options 2/4 Text"] = [=[Die größte Verbesserung der |cFFFFFFFFDynamischen Gruppen|r ist eine neue Auswahlmöglichkeit für die Wachstumseinstellung.

Wähle \"Kreisförmig\" um sie im Einsatz zu sehen.]=] -- Needs review
L["Dynamic Group Options: 3/4"] = "Dynamische Gruppen Einstellungen: 3/4" -- Needs review
L["Dynamic Group Options 3/4 Text"] = [=[Die Konstanter Faktor Einstellung ermöglicht dir die Kontrolle darüber, wie deine kreisförmige Gruppe wächst.

Eine kreisförmige Gruppe mit konstantem Abstand gewinnt an Radius je mehr Anzeigen hinzugefügt werden, während ein konstanter Radius dazu führt, dass Anzeigen näher aneinander rücken, je mehr hinzugefügt werden.]=] -- Needs review
L["Dynamic Group Options: 4/4"] = "Dynamische Gruppen Einstellungen: 4/4" -- Needs review
L["Dynamic Group Options 4/4 Text"] = [=[Dynamische Gruppen können ihre Elemente nun automatisch nach Verbleibender Zeit sortieren..

Anzeigen, die keine Verbleibende Zeit besitzen, werden je nach Auswahl von \"Aufsteigend\" oder \"Absteigend\" entsprechend oben oder unten plaziert..]=] -- Needs review
L["Finished"] = "Abgeschlossen" -- Needs review
L["Full-scan Auras: 2/10"] = "Komplett gescannte Auren: 2/10" -- Needs review
L["Full-scan Auras 2/10 Text"] = "Aktiviere zunächst die Kompletter Scan Einstellung." -- Needs review
L["Full-scan Auras: 3/10"] = "Komplett gescannte Auren: 3/10" -- Needs review
L["Full-scan Auras 3/10 Text"] = [=[|cFFFF0000Auto-Klonen|r kann nun über die \"%s\"-Einstellung aktiviert werden.

Dies sorgt dafür, dass für jeden den Parametern entsprechenden Treffer eine neue Anzeige angelegt wird.]=] -- Needs review
L["Full-scan Auras: 4/10"] = "Komplett gescannte Auren: 4/10" -- Needs review
L["Full-scan Auras 4/10 Text"] = [=[Ein Popup sollte aufgetaucht sein, das dich darauf hinweist, dass |cFFFF0000auto-geklonte|r Anzeigen im Allgemeinen in Dynamischen Gruppen verwendet werden sollten.

Drücke \"Ja\"um |cFF8800FFWeakAuras|r zu erlauben deine Anzeige automatisch in eine Dynamische Gruppe zu verschieben.]=] -- Needs review
L["Full-scan Auras: 5/10"] = "Komplett gescannte Auren: 5/10" -- Needs review
L["Full-scan Auras 5/10 Text"] = "Deaktiviere die Kompletter Scan Einstellung um andere Einheit Einstellungen zu reaktivieren." -- Needs review
L["Group Auras 6/10"] = "Gruppen Auren: 6/10" -- Needs review
L["Group Auras 6/10 Text"] = "Wähle jetzt \"Gruppe\" für die Einheiten-Einstellung." -- Needs review
L["Group Auras: 7/10"] = "Gruppen Auren: 7/10" -- Needs review
L["Group Auras 7/10 Text"] = [=[|cFFFF0000Auto-Klonen|r wird wieder über die \"%s\" Einstellung aktiviert.

Eine neue Anzeige wird für jedes Gruppenmitglied erstellt, das von der/den angegebenen Aura/Auren betroffen ist.]=] -- Needs review
L["Group Auras: 8/10"] = "Gruppen Auren: 8/10" -- Needs review
L["Group Auras 8/10 Text"] = "Aktivieren der %s Einstellung für eine Gruppen Aura mit aktiviertem |cFFFF0000Auto-Klonen|r sorgt dafür, dass für jedes Gruppenmitglied, das |cFFFFFFFFnicht|r von der/den angegebenen Aura/Auren betroffen ist, eine Anzeige erstellt wird." -- Needs review
L["Home"] = "Startseite" -- Needs review
L["Multi-target Auras: 10/10"] = "Mehrfachziel-Auren: 10/10" -- Needs review
L["Multi-target Auras 10/10 Text"] = [=[|cFFFF0000Auto-Klonen|r ist für Mehrfachziel-Auren standardmäßig aktiviert.

Auslöser für Mehrfachziel-Auren unterscheiden sich dadurch von normalen Aura-Auslösern, dass sie auf Kampf-Events reagieren, was heißt, dass sie durch Auren auf Gegnern ausgelöst werden, die niemand als Ziel hat (obwohl gewisse dynamische Informationen nicht verfügbar sind, solange niemand in deiner Gruppe den Gegner als Ziel hat).

Deshalb sind Mehrfachziel-Auren eine gute Wahl zur Verfolgung von DoTs auf mehreren Gegnern.]=] -- Needs review
L["Multi-target Auras: 9/10"] = "Mehrfachziel-Auren: 9/10" -- Needs review
L["Multi-target Auras 9/10 Text"] = "Wähle zum Abschluss\"Mehrfachziel\" bei der Einheiten Einstellung." -- Needs review
L["New in 1.4:"] = "Neu in 1.4:" -- Needs review
L["New in 1.4 Desc:"] = "Neu in 1.4" -- Needs review
L["New in 1.4 Desc Text"] = "Wirf einen Blick auf die neuen Features in WeakAuras 1.4" -- Needs review
L["New in 1.4 Finnished Text"] = [=[Selbstverständlich beinhaltet |cFF8800FFWeakAuras 1.4|r mehr neue Features als auf einmal abgedeckt werden können, auch ohne die zahllosen Bugfixes und Effizienzsteigerungen zu erwähnen.

Hoffentlich hat diese Einführung dich wenigstens über die wichtigsten neuen Funktionen aufgeklärt, die dir zur Verfügung stehen.

Wir danken dir vielmals für die Nutzung von |cFF8800FFWeakAuras|r!]=] -- Needs review
L["New in 1.4 Text1"] = [=[Version 1.4 von |cFF8800FFWeakAuras|r führt mehrere neu mächtige Features ein.

Diese Einführung bietet einen Überblick der wichtigsten neuen Funktionen und deren Nutzung.]=] -- Needs review
L["New in 1.4 Text2"] = "Lege zunächst eine neue Anzeige zu Demonstrationszwecken an." -- Needs review
L["Previous"] = "Zurück" -- Needs review
L["Trigger Options: 1/4"] = "Auslöser Einstellungen: 1/4" -- Needs review
L["Trigger Options 1/4 Text"] = [=[Zusätzlich zu \"Mehrfachziel\" gibt es noch eine Alternative für die Einheiten Einstellung: Konkrete Einheit.

Wähle sie aus, um ein neues Textfeld anlegen zu können.]=] -- Needs review
L["Trigger Options: 2/4"] = "Auslöser Einstellungen: 2/4" -- Needs review
L["Trigger Options 2/4 Text"] = [=[In diesem Feld kannst du den Namen eines beliebigen Spielers in deiner Gruppe, oder einer speziellen Unit ID angeben. Unit IDs wie \"boss1\", \"boss2\", usw. sind besonders für Schlachtzugsbegegnungen sehr hilfreich.

Alle Auslöser, die die Angabe einer Einheit ermöglichen (nicht nur Aura Auslöser) unterstützen nun die Konkrete Einheit Einstellung.]=] -- Needs review
L["Trigger Options: 3/4"] = "Auslöser Einstellungen: 3/4" -- Needs review
L["Trigger Options 3/4 Text"] = [=[|cFF8800FFWeakAuras 1.4|r bringt auch ein paar neue Auslöser-Typen mit sich.

Wähle die Status Kategorie um einen Blick auf sie zu werfen.]=] -- Needs review
L["Trigger Options: 4/4"] = "Auslöser Einstellungen: 4/4" -- Needs review
L["Trigger Options 4/4 Text"] = [=[Der |cFFFFFFFFEinheitencharakterisierungs|r Auslöser ermöglicht die Festelellung von Namen, Klasse, Feindseligkeit und ob es sich um einen Spieler- oder Nicht-Spieler-Charakter handelt.

Auslöser für |cFFFFFFFFGlobale Abklingzeit|r und |cFFFFFFFFSwing Timer|r ergänzen den Zauber Auslöser.]=] -- Needs review
L["WeakAuras Tutorials"] = "WeakAuras Einführungen" -- Needs review
L["Welcome"] = "Willkommen" -- Needs review
L["Welcome Text"] = [=[Willkommen zur |cFF8800FFWeakAuras|r Einführung.

Diese Einführung wird dir zeigen, wie WeakAuras genutzt werden kann und dabei grundlegende Einstellungen erläutern.]=] -- Needs review



