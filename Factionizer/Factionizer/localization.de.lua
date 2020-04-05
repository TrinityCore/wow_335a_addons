-- Deutsch (German)
-------------------
if (GetLocale() == "deDE") then
FIZ_TXT = {}

-- Ae	\195\132	ae	\195\164
-- Oe	\195\150	oe	\195\182
-- Ue	\195\156	ue	\195\188

-- ß : \195\159

-- Binding names
BINDING_HEADER_FACTIONIZER	= "Factionizer";
BINDING_NAME_SHOWCONFIG		= "Optionsfenster zeigen"
BINDING_NAME_SHOWDETAILS	= "Ruf-Detailfenster zeigen"

-- help
FIZ_TXT.help		= "Ein Werkzeug, um Deinen Ruf zu managen"
FIZ_TXT.command		= "Kommando nicht erkannt"
FIZ_TXT.usage		= "Gebrauch"
FIZ_TXT.helphelp	= "Zeigt diesen Hilfstext"
FIZ_TXT.helpabout	= "Zeigt Autoren-Information an"
FIZ_TXT.helpstatus	= "Konfigurationsstatus anzeigen"
FIZ_TXT.help_urbin	= "Listet Details aller Addons von Urbin"
FIZ_TXT.helpphase	= "Definiert die Hauptphase (1=Sanctum, 2=Armory, 3=Hafen)"
FIZ_TXT.helpsubphase	= "Definiert die Unterphase (1=im Bau, 2=gebaut)"
-- about
FIZ_TXT.by		= "von"
FIZ_TXT.version		= "Version"
FIZ_TXT.date		= "Datum"
FIZ_TXT.web		= "Webseite"
FIZ_TXT.slash		= "Slash Kommando"
FIZ_TXT.urbin		= "Andere addons von Urbin"
-- status
FIZ_TXT.status		= "Status"
FIZ_TXT.disabled	= "inaktiv"
FIZ_TXT.enabled		= "aktiv"
FIZ_TXT.statMobs	= "Mobs zeigen [M]"
FIZ_TXT.statQuests	= "Quests zeigen [Q]"
FIZ_TXT.statInstances	= "Instanzen zeigen [D]"
FIZ_TXT.statItems	= "Gegenst\195\164nde zeigen [I]"
FIZ_TXT.statMissing	= "Fehlenden Ruf zeigen"
FIZ_TXT.statDetails	= "Erweiteres Detail Fenster zeigen"
FIZ_TXT.statChat	= "Detaillierte Chat Meldung"
FIZ_TXT.statSuppress	= "Original Chat Meldung unterdr\195\188cken"
FIZ_TXT.statPreview	= "Voransicht f\195\188r Ruf im Ruf-Fenster anzeigen"
-- XML UI elements
FIZ_TXT.showQuests	= "Zeige Quests"
FIZ_TXT.showInstances	= "Zeige Instanzen"
FIZ_TXT.showMobs	= "Zeige Mobs"
FIZ_TXT.showItems	= "Zeige Gegenst\195\164nde"
FIZ_TXT.showAll		= "Alles zeigen"
FIZ_TXT.showNone	= "Nichts zeigen"
FIZ_TXT.expand		= "Aufklappen"
FIZ_TXT.collapse	= "Zuklappen"
FIZ_TXT.supressNoneFaction	= "Ausschluss l\195\182schen: Fraktion"
FIZ_TXT.supressNoneGlobal	= "Ausschluss l\195\182schen: Alle"
FIZ_TXT.suppressHint	= "Auf eine Quest rechtsklicken, um sie vom der Zusammenfassung auszuschliessen"
-- options dialog
FIZ_TXT.showMissing	= "Fehlenden Ruf im Ruf-Fenster anzeigen"
FIZ_TXT.extendDetails	= "Erweitertes Detail-Fenster anzeigen"
FIZ_TXT.gainToChat	= "Detaillierte Rufgewinne in den Chat schreiben"
FIZ_TXT.suppressOriginalGain = "Original-Rufgewinn-Nachrichten unterdr\195\188cken"
FIZ_TXT.showPreviewRep	= "Ruf-Vorschau im Ruf Fenster zeigen"
FIZ_TXT.defaultChatFrame 	= "Default Chat Fenster verwenden"
FIZ_TXT.chatFrame		= "Verwende Chat Fenster %d (%s)"
FIZ_TXT.usingDefaultChatFrame	= "Verwende standard Chatfenster"
FIZ_TXT.usingChatFrame		= "Verwende Chatfenster"
-- various LUA
FIZ_TXT.options		= "Optionen"
FIZ_TXT.orderByStanding = "Nach Ruf sortieren"
FIZ_TXT.lookup		= "Schlage Fraktion "
FIZ_TXT.lookup2		= " nach"
FIZ_TXT.allFactions	= "Zeige alle Fraktionen"
FIZ_TXT.missing		= "(zur n\195\164chsten)"
FIZ_TXT.missing2	= "Fehlend"
FIZ_TXT.heroic		= "Heroisch"
FIZ_TXT.normal		= "Normal"
-- FIZ_ShowFactions
FIZ_TXT.faction		= "Fraktion"
FIZ_TXT.is		= "ist"
FIZ_TXT.withStanding	= "mit Ruf"
FIZ_TXT.needed		= "ben\195\182tigt"
FIZ_TXT.mob		= "[Mob]"
FIZ_TXT.limited		= "ist limitiert auf"
FIZ_TXT.limitedPl	= "sind limitiert auf"
FIZ_TXT.quest		= "[Quest]"
FIZ_TXT.instance	= "[Instanz]"
FIZ_TXT.items		= "[Gegenstand]"
FIZ_TXT.unknown		= "ist diesem Spieler nicht bekannt."
-- ReputationDetails
FIZ_TXT.currentRep	= "Aktueller Ruf"
FIZ_TXT.neededRep	= "Ben\195\182tigter Ruf"
FIZ_TXT.missingRep	= "Fehlender Ruf"
FIZ_TXT.repInBag	= "Ruf in Taschen"
FIZ_TXT.repInBagBank	= "Ruf in Taschen und Bank"
FIZ_TXT.repInQuest	= "Ruf in Quests"
FIZ_TXT.factionGained	= "Diesmal erhalten"
FIZ_TXT.noInfo		= "Keine Informationen f\195\188r diese Fraktion/Rufstufe verf\195\188gbar."
FIZ_TXT.toExalted	= "Ruf bis Ehrf\195\188rchtig"
-- to chat
FIZ_TXT.stats		= " (Total: %s%d, \195\188brig: %d)"
-- UpdateList
FIZ_TXT.mobShort	= "[M]"
FIZ_TXT.questShort	= "[Q]"
FIZ_TXT.instanceShort	= "[D]"
FIZ_TXT.itemsShort	= "[I]"
FIZ_TXT.mobHead		= "Ruf erlangen durch T\195\182ten dieses Mobs"
FIZ_TXT.questHead	= "Ruf erlangen durch Erf\195\188llen dieser Quest"
FIZ_TXT.instanceHead	= "Ruf erlangen durch Durchlaufen dieser Instanz"
FIZ_TXT.itemsHead	= "Ruf erlangen durch Abgeben dieser Gegenst\195\164nde"
FIZ_TXT.mobTip		= "Jedesmal, wenn Du diesen Mob t\195\182test, erlangst Du Ruf. Wenn Du das oft genug tust, hilft Dir das die n\195\164chste Ruf-Stufe zu erreichen."
FIZ_TXT.questTip	= "Jedesmal, wenn Du diese wiederholbare oder Tagesquest erf\195\188llst, erlangst Du Ruf.Wenn Du das oft genug tust, hilft Dir das die n\195\164chste Ruf-Stufe zu erreichen."
FIZ_TXT.instanceTip1	= "Jedesmal, wenn Du diese Instanz l\195\164ufst, erlangst Du Ruf. Wenn Du das oft genug tust, hilft Dir das die n\195\164chste Ruf-Stufe zu erreichen."
FIZ_TXT.itemsName	= "Gegenst\195\164nde abgeben"
FIZ_TXT.itemsTip	= "Jedesmal, wenn Du die aufgef\195\188hrten Gegenst\195\164nde abgibst, erlangst Du Ruf. Wenn Du das oft genug tust, hilft Dir das die n\195\164chste Ruf-Stufe zu erreichen."
FIZ_TXT.allOfTheAbove	= "Zusammenfassung der %d oben aufgef\195\188hrten Quests"
FIZ_TXT.questSummaryHead = FIZ_TXT.allOfTheAbove
FIZ_TXT.questSummaryTip	= "Dieser Eintrag zeigt eine Zusammenfassung aller oben aufegf\195\188hrten Quests.\r\nDies ist n\195\188tzlich, unter der Annahme, dass alle aufgef\195\188hrten Quests Tagesquests sind, da Dir dies anzeigt, wie lange es dauert, bis Du die n\195\164chste Ruf-Stufe erreichst, wenn Du jeden Tag alle Tagesquests erf\195\188llst."
FIZ_TXT.complete	= "Erf\195\188llt"
FIZ_TXT.active		= "Aktiv"
FIZ_TXT.inBag		= "In Taschen"
FIZ_TXT.turnIns		= "Abgeben:"
FIZ_TXT.reputation	= "Ruf:"
FIZ_TXT.inBagBank	= "In Taschen und Bank"
FIZ_TXT.questCompleted	= "Quest erf\195\188llt"
FIZ_TXT.timesToDo	= "Zu erf\195\188llen:"
FIZ_TXT.instance2	= "Instanz:"
FIZ_TXT.mode		= "Modus:"
FIZ_TXT.timesToRun	= "Zu laufen:"
FIZ_TXT.mob2		= "Mob:"
FIZ_TXT.location	= "Ort:"
FIZ_TXT.toDo		= "Zu erledigen:"
FIZ_TXT.quest2		= "Quest:"
FIZ_TXT.itemsRequired	= "Ben\195\182tigte Gegenst\195\164nde"
FIZ_TXT.maxStanding	= "Gibt ruf bis"
-- SSO phases
FIZ_TXT.sso_warning	= "F\195\188r diesen Server wurde die Phase der Shattered Sun Offensive noch nicht definiert. Auf den meisten Servern, alle Phasen sind abgeschlossen. Um dies schnell zu definieren, gib '/fz sso all' ein."
FIZ_TXT.sso_status	= "Phasen-Status der Shattered Sun Offensive"
FIZ_TXT.sso_unknown	= "Unbekannt"
FIZ_TXT.sso_main	= "Hauptphase"
FIZ_TXT.sso_phase2b	= "Phase 2B"
FIZ_TXT.sso_phase3b	= "Phase 3B"
FIZ_TXT.sso_phase4b	= "Phase 4B"
FIZ_TXT.sso_phase4c	= "Phase 4C"
FIZ_TXT.phase1		= "Phase 1: Sun's Reach Sanctum im Bau"
FIZ_TXT.phase2		= "Phase 2: Sun's Reach Waffenkammer im Bau"
FIZ_TXT.phase3		= "Phase 3: Sun's Reach Hafen im Bau"
FIZ_TXT.phase4		= "Phase 4: Letzte Anstrengung"
FIZ_TXT.phase2bWaiting	= "Warte auf Bauende des Sanctum"
FIZ_TXT.phase2bActive	= "Sunwell Portal im Bau"
FIZ_TXT.phase2bDone	= "Sunwell Portal gebaut"
FIZ_TXT.phase3bWaiting	= "Warte auf Bauende der Waffenkammer"
FIZ_TXT.phase3bActive	= "Amboss und Schmiede im Bau"
FIZ_TXT.phase3bDone	= "Amboss und Schmiede gebaut"
FIZ_TXT.phase4Waiting	= "Warte auf Bauende des Hafens"
FIZ_TXT.phase4bActive	= "Denkmal der Gefallenen im Bau"
FIZ_TXT.phase4bDone	= "Denkmal der Gefallenen gebaut"
FIZ_TXT.phase4cActive	= "Alchemielabor im Bau"
FIZ_TXT.phase4cDone	= "Alchemielabor gebaut"
-- skills
FIZ_TXT.skillHerb	= "Kr\195\164uterkunde"
FIZ_TXT.skillSkin	= "K\195\188rschnerei"
FIZ_TXT.skillMine	= "Bergbau"
FIZ_TXT.skillFish	= "Angeln"
FIZ_TXT.skillCook	= "Kochkunst"
FIZ_TXT.skillAid	= "Erste Hilfe"
FIZ_TXT.skillAlch	= "Alchimie"
FIZ_TXT.skillSmith	= "Schmiedekunst"
FIZ_TXT.skillEnch	= "Verzauberkunst"
FIZ_TXT.skillEngi	= "Ingenieurskunst"
FIZ_TXT.skillJewel	= "Juwelenschleifen"
FIZ_TXT.skillLw	= "Lederverarbeitung"
FIZ_TXT.skillTail	= "Schneiderei"

-- Tooltip
FIZ_TXT.elements = {}
FIZ_TXT.elements.name = {}
FIZ_TXT.elements.tip = {}

FIZ_TXT.elements.name.FIZ_ShowMobsButton	= FIZ_TXT.showMobs
FIZ_TXT.elements.tip.FIZ_ShowMobsButton		= "Diese Option aktivieren, um Mobs anzuzeigen, die Deinen Ruf verbessern k\195\182nnen."
FIZ_TXT.elements.name.FIZ_ShowQuestButton	= FIZ_TXT.showQuests
FIZ_TXT.elements.tip.FIZ_ShowQuestButton	= "Diese Option aktivieren, um Quests anzuzeigen, die Deinen Ruf verbessern k\195\182nnen."
FIZ_TXT.elements.name.FIZ_ShowItemsButton	= FIZ_TXT.showItems
FIZ_TXT.elements.tip.FIZ_ShowItemsButton	= "Diese Option aktivieren, um Gegenst\195\164nde anzuzeigen, die Deinen Ruf verbessern k\195\182nnen."
FIZ_TXT.elements.name.FIZ_ShowInstancesButton	= FIZ_TXT.showInstances
FIZ_TXT.elements.tip.FIZ_ShowInstancesButton	= "Diese Option aktivieren, um Instanzen anzuzeigen die Deinen Ruf verbessern k\195\182nnen."

FIZ_TXT.elements.name.FIZ_ShowAllButton		= FIZ_TXT.showAll
FIZ_TXT.elements.tip.FIZ_ShowAllButton		= "Auf diesen Knopf klicken, um alle vier links stehenden Optionen zu aktivieren. Es werden Mobs, Quests, Gegenst\195\164nde und Instanzen angezeigt, die Deinen Ruf der ausgew\195\164hlten Fraktion verbessern."
FIZ_TXT.elements.name.FIZ_ShowNoneButton	= FIZ_TXT.showNone
FIZ_TXT.elements.tip.FIZ_ShowNoneButton		= "Auf diesen Knopf klicken, um alle vier links stehenden Optionen zu deaktivieren. \r\nEs werden keine Methoden, den Ruf mit der ausgew\195\164hlten Fraktion zu steigern angezeigt."

FIZ_TXT.elements.name.FIZ_ExpandButton		= FIZ_TXT.expand
FIZ_TXT.elements.tip.FIZ_ExpandButton		= "Auf diesen Knopf klicken, um alle Eintr\195\164ge aufzuklappen. Dies zeigt die Gegenst\195\164nde an, die f\195\188r die jeweiligen Sammel-Quests ben\195\182tigt werden."
FIZ_TXT.elements.name.FIZ_CollapseButton	= FIZ_TXT.collapse
FIZ_TXT.elements.tip.FIZ_CollapseButton		= "Auf diesen Knopf klicken, um alle Eintr\195\164ge zuzuklappen. Dies zeigt keine Gegenst\195\164nde an, die f\195\188r die jeweiligen Sammel-Quests ben\195\182tigt werden."

FIZ_TXT.elements.name.FIZ_EnableMissingBox		= FIZ_TXT.showMissing
FIZ_TXT.elements.tip.FIZ_EnableMissingBox		= "Diese Option aktivieren, um im Ruffenster hinter der Rufstufe die fehlenden Rufpunkte anzuzeigen, die n\195\182tig sind, um die n\195\164chste Stufe zu erreichen."
FIZ_TXT.elements.name.FIZ_ExtendDetailsBox		= FIZ_TXT.extendDetails
FIZ_TXT.elements.tip.FIZ_ExtendDetailsBox		= "Diese Option aktivieren, um eine erweiterte Version anzuzeigen.\r\nZus\195\164tzlich zum normalen Fenster, werden dann die fehlenden Rufpunkte angezeigt, und eine Liste von Mobs, Quests, Gegenst\195\164nden und Instanzen, die dazu dienen diesen Ruf zu erlangen."
FIZ_TXT.elements.name.FIZ_GainToChatBox			= FIZ_TXT.gainToChat
FIZ_TXT.elements.tip.FIZ_GainToChatBox			= "Diese Option aktivieren, um im Chat den Ruf mit allen Fraktionen anzuzeigen.\r\nDies weicht von den Standardnachrichten ab, welche nur den gewonnen Ruf mit der Hautpfraktion anzeigt."
FIZ_TXT.elements.name.FIZ_SupressOriginalGainBox	= FIZ_TXT.suppressOriginalGain
FIZ_TXT.elements.tip.FIZ_SupressOriginalGainBox		= "Diese Option aktivieren, um die Standard-Ruf-Nachrichten im Chat zu unterdr\195\188cken.\r\nDies ist sinnvoll, wenn die erweiterten Nachrichten aktiviert wurden, damit die Rufmeldungen nicht zweimal angezeigt werden."
FIZ_TXT.elements.name.FIZ_ShowPreviewRepBox		= FIZ_TXT.showPreviewRep
FIZ_TXT.elements.tip.FIZ_ShowPreviewRepBox		= "Diese Option aktivieren, um den Ruf, der durch Abgeben von abgeschlossenen Quests und gesammelten Gegenst\195\164nden gewonnen werden kann, als grauen Balken \195\188ber dem normalen Rufbalken im Ruffenster anzuzeigen."
end
