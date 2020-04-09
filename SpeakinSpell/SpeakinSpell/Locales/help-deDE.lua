-- Autor      : leXin (Aiwendyl Das_Syndikat)
-- Erstellungsdatum : 24.07.2009

-- Deutsche Lokalisierungs-Datei für deDE.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local HELPFILE = AceLocale:NewLocale("SpeakinSpell_HELPFILE", "deDE", false)
if not HELPFILE then return end

SpeakinSpell:PrintLoading("Locales/help-deDE.lua")


----------------------------------------------------------------------------------------
--[[ Das Format jeder Seite ist wie folgend:
	["Kapitel Titel"] = "Inhalte"
--]]

--ACHTUNG ÜBERSETZER:
--	Das komplette Benutzerhandbuch in dieser Datei ist eine lange und wortreiche Angelegenheit die sich auf viele Themen bezieht.
--	Es wird voraussichtlich wachsen und sich sehr häufig in sehr vielen Wegen ändern jedes mal wenn ich SpeakinSpell erweitere,
--	weil dies hier ist der Ort ist wo vollständig dokumentiert wird wie jede Fähigkeit angewendet und benutzt wird.
--
--	Eben wegen diesem Problem, dass das Benutzerhandbuch sehr häufig geändert werden muss
--	habe ich den Programmiercode sehr flexibel darin gemacht wie diese Datei genutzt wird.
--	Sehr flexibel.
--
--	Anders als bei den meisten Locale-xxXX.lua, ist es dir erlaubt die kompletten Inhalte der
--	HELPFILE.PAGES zu ändern (Die folgenden Tabellen).
--	Mitsamt der Tabellen-Schlüssel welche als Kapitel Titel genutzt werden,
--	die Inhalte von jedem Kapitel natürlich
--	die Anordnung der Inhalte
--	und es steht dir ebenfalls offen die Nummern der Kapitel zu erweitern, löschen und neuzuordnen.
--
--	Ich möchte das du die Möglichkeit besitzt dieses Benutzerhandbuch komplett umzugestalten,
--	sodass es passend auf die unterschiedlichen Sprachen und Kulturen abgeändert werden kann,
--	gemäß dem Fall, dass es durch eine Umgestaltung leichter wird die informationen darin zu übermitteln.
--	Es steht dir frei das zu tun und es wird funktionieren - Versuch es und sieh selbst.
--	
----------------------------------------------------------------------------------------
HELPFILE.PAGES = {

----------------------------------------------------------------------------------------
["1. Über SpeakinSpell"] = {
order = 1,
Summary = "About SpeakinSpell",
Contents = [[

Unterhaltsam und/oder nützlich - SpeakinSpell wird zufällige (oder festgelegte) Sprüche in den gewünschten Chat ansagen wenn du je nach Einstellung einen Zauber, eine Fähigkeit, oder auch Items benutzt, sowie automatisch ausgelöste Effekte (z.B. Schmuckstücke) und Benutzer-definierte Makros. --- In englisch abändern!!!

Funktioniert mit sämtlichen Klassen. 
Einstellbar für unzählige verschiedene Situation (Raid, Schlachtfelder, Arena...)

Projekt Webseite:
http://www.wowace.com/projects/speakinspell/

Curse Downloadseite:
http://wow.curse.com/downloads/wow-addons/details/speakinspell.aspx

Bitte reiche alle Verbesserungsideen und Fehlermeldungen hier ein:
http://www.wowace.com/projects/speakinspell/create-ticket/

Präsentiert von Stonarius von Antonidas
In Zusammenarbeit mit leXin (Aiwendyl - Das Syndikat) für die komplette deutsche Übersetzung/Lokalisierung, sowie zahlreichen Erweiterungen.
]],
},

----------------------------------------------------------------------------------------
["2. Basisanleitung"] = {
order = 2,
Summary = "Getting Started with SpeakinSpell",
Contents = [[

Wie man SpeakinSpell in wenigen Schritten zum laufen bringt:

1. Logge ein und spiele deinen Charakter für ein paar Minuten.

2. Aktiviere oder benutze dabei jeden Zauber oder jede Fähigkeit. 
   Bringe jeden selbstauslösenden Proc-Effekt zum auftreten und sorge dafür, dass jedes andere von SpeakinSpell aufspürbare Ereignis auftritt, für das du gerne Ansagen einstellen würdest.

3. Tippe "/SpeakinSpell" (oder "/ss") um Zugriff auf das Optionsfenster zu bekommen.

4. Klicke auf "Erstelle neu.." oder tippe "/ss erstelle" um die Einstellungen für einen neuen Zauber/Fähigkeit oder für ein anderes Ereignis vorzunehmen.

5. Wähle den gewünschten Zauber/Fähigkeit oder das Ereignis von der Liste und klicke dann auf den "Erstellen" Button. 
   Dann wirst du automatisch zu der Einstellungsseite kommen für diesen gewählten Zauber/Fähigkeit oder das Ereignis.

6. Ändere die Einstellung deinen Wünschen entsprechend und schreibe soviele Sprüche wie du willst. 
   Von nun an wird jedesmal, wenn du den Zauber/Fähigkeit benutzt oder das gewählte Ereigniss (z.B. Procs) eintrifft eine deiner zuvor eingegebenen zufälligen Nachrichten in den jeweils eingestellten Chat gesendet.

7. Wiederhole das Ganze bis dir die Ideen für coole und nützliche zufällige Sprüche ausgehen.
]],
},

----------------------------------------------------------------------------------------
["3. Funktionen"] = {
order = 3,
Summary = "Overview of All Features",
Contents = [[

Erkennt verschiedenste "Ereignisse" für die in den Chat automatisch Sprüche angesagt werden unter Verwendung einer Zufallsliste mit vom Benutzer definierten Sprüchen (Einige Standarts sind als Beispiele voreingestellt). Das beinhaltet:
- Zauber die du wirkst.
- Alle anderen Fähigkeiten für jede Klasse (Der "Heldenhafte Stoß" eines Kriegers ist technisch gesehen auch ein "Zauber").
- Alles was du in deiner Aktionsleiste verwenden kannst.
- Items.
- Selbstauslösende Effekte (Buffs die du von dir selbst z.B. durch Schmuckstücke erhälst).
- Andere Ereignisse (Wie Einloggen etc.).
- Immer wenn du "/ss makro irgendetwas" eintippst.

Bis zu 100 Sprüche können für einen Zauber eingegeben werden.

Für jede Klasse stehen für mindestens 3 Fähigkeiten oder Zauber jeweils 10 deutsche Beispielsprüche bereit (Hinzugefügt von leXin)

Für jeden Zauber mitsamt seinen Sprüchen können einzelne Chat-Kanäle ausgewählt werden.

Unterstützt unterschiedliche Kanäle für verschiedene Szenarien: Solo, Gruppe, Schlachtzug, Schlachtfeld und Arena.

Vollständig durch das Options-Bedienfeld konfigurierbar.

Beinhaltet witzige voreingestellte Sprüche für viele Zauber sämtlicher Klassen.

Alle deine Einstellungen gelten nur für diesen Charakter. Alle Benutzer-definierten Sprüche und andere Einstellungen werden separat für jeden Charakter gespeichert.

Unterstützt viele Ersatz-Variablen wie <spieler>, <ziel>, <zielklasse>, <zielrasse> und noch viele mehr.

Sagt niemals zweimal infolge dieselbe Nachricht für einen gegebenen Zauber (Natürlich nur, wenn du mehr als 1 Spruch für diesen Zauber eingegeben hast).

Kann so konfiguriert werden, dass nur der Nutzen eines Zaubers basierend auf einer Zufallschance angesagt wird. 
Diese ist eine Benutzer-konfigurierte Prozentchance pro Zauber. Das kann für Rollenspielzwecke nützlich sein, oder um die Menge von Zauberausgelösten Spam der im Chat generiert wird zu senken.

Kann so konfiguriert werden, dass ein Abklingzeit für die Ansagen jedes Zaubers verwendet wird. Das kann genutzt werden um zu verhindern das zu häufig Ansagen für einen häufig benutzten Zauber vorkommen.

Can be configured to limit event announcements to once per combat and/or once per target.

Flüstert bei Bedarf Nachrichten automatisch zu dem Ziel deines Zaubers. Das kann für Wiederbelebungszauber oder z.B. Anregen nützlich sein.

Wenn du Komplimente bezüglich deiner "Makros" bekommst benutze "/ss weitersagen" um deine Freunde über SpeakinSpell zu informieren. 
Einige der Zufallswerbungen sind witzig gehalten. Ja, es ist schließlich ein Addon das zufällige Texte in den Chat spamt und es hat eine Funktion um Werbung für seine Fähigkeit zufällige Texte zu spammen zu machen. "/ss hilfe" im Spiel um mehr über detailierte Optionen betreffend der Werbung "/ss weitersagen" zu erfahren.

Erkennung von anderen ungewöhnlichen Ereignissen wie Einloggen. Tippe "/ss hilfe" im Spiel für die komplette Liste.

Gewohnheitsdefinierte Benutzermakros. Tippe "/ss makro irgendetwas" um dafür zu sorgen das SpeakinSpell ein pseudo Zauberereignis erkennt mit dem Namen "Wenn ich tippe: /ss makro irgendetwas" welches du so einstellen kannst, dass es zusammen mit zufälligen Sprüchen angesagt wird. Das kann z.B. für zufällige Schlachtrufe, Grüße, Abschiede benutzt werden oder was auch immer du definierst.
]],
},

----------------------------------------------------------------------------------------
["4. Slash Befehle"] = {
order = 4,
Summary = "/ss commands",
Contents = [[

/ss
- show options (same as "/ss toggle" or right-clicking the minimap button)

/ss toggle
- open or re-open the SpeakinSpell GUI

/ss optionen 
- Zeigt die Optionen.

/ss hilfe 
- Zeigt diese Hilfe.

/ss erstelle 
- Öffnet die Erstelle neu... Benutzeroberfläche, um Nachrichteneinstellung für ein neues Ereignis zu erstellen.

/ss nachrichten 
- Öffnet das Nachrichteneinstellungen Bedienfeld um deine momentanen Einstellungen zu ändern.

/ss import
- open the Import New Data interface

/ss colors
- open the color options interface

/ss zurücksetzen 
- Setzt alle deine Einstellungen auf Standart zurück.

/ss weitersagen 
- Informiert deine Freunde über dieses Addon (Benutzt dabei einen Standart-Kanal).

/ss weitersagen /p 
- Informiert deine Gruppe über dieses Addon (/s oder /ra funktionieren ebenfalls).

/ss weitersagen /w lexin 
- Wird deinen Freund "lexin" über dieses Addon informieren.

/ss makro <irgendetwas> 
- Aktiviert ein Ereigniss genannt "Wenn ich tippe: /ss makro irgendetwas". Siehe auch "10.Gebräuchliche Makros".

/ss testallsubs
- reports the value of all possible substitutions for the current event

/ss memory
- shows how much memory SpeakinSpell is using

]],
},

----------------------------------------------------------------------------------------
["5. Variablen"] = {
order = 5,
Summary = "A comprehensive list of all substitutions you can use in your speeches, such as <target>, <caster>, <spellname>, etc.",
Contents = [[

Jede zufällige Nachricht kann sich auf das Zauberwirken eines Spielers, auf das Ziel des Zaubers und viele verschiedene andere Informationen beziehen, welche von SpeakinSpell automatisch erkannt werden.

Folgend wird eine komplette Liste von verfügbaren Variablen aufgelistet, die bei Bedarf in eure zufällige Sprüche mit eingebaut werden können. Die eckigen Klammer <> werden dabei benötigt!

<spieler>
- Dein Name.

<playertitle>
- Your current title, for example "the Explorer"

<zauberwirker>
- Der Name der Person oder des Wesens das den Spruch oder Effekt wirkt.
- Nicht immer derselbe wie <spieler>.

<ziel>
- Der Name des Ziels auf das der Zauber gewirkt wird.
- So lange wie möglich wird dies das wahre aktuelle Ziel deines Zaubers sein (Nicht zwingend dein augenblicklich ausgewähltes Ziel).

<zielklasse>
- Die Klasse deines Ziels. (z.b. "Wirke xxx auf <zielklasse> wird zu "Wirke xxx auf den Priester").

<zielrasse>
- Die Rasse deines Ziels. (z.b. "Wirke xxx auf <zielrasse> wird zu "Wirke xxx auf den Zwerg").

<fokus>
- Der Name deines Fokusziels (/fokus).

<zaubername>
- Der komplette name des zaubers den du wirkst (Der Rang des Zaubers ist nicht beinhaltet).

<zauberrang> 
- Der Rang des Zaubers.
- Die gewöhnliche Anwendung würde wie folgt aussehen "<zaubername> (<zauberrang>)" -> "Arkane Intelligenz (Rang 2)".

<zauberlink>
- Erstellt im Chat einen anklickbaren Link zu dem Zauber.
- Entsprechend einer Einschränkung der WoW LUA API, funktioniert das nur für Zauber die in einem eigenen Zauberbuch zu finden sind. 
- Falls ein klickbarer Zauberlink nicht erstellt werden kann, wird ein unechter unklickbarer Link generiert wie [Auffüllen].

<begleiter>
- Der Name deines Begleiters (Nicht zur Benutzung mit Haustieren).
- Entsprechend einer Einschränkung der WoW LUA API, funktioniert diese Variable nicht, wenn du deinen Begleiter gerade beschwörst. Es funktioniert erst nachdem dein Begleiter bereits beschworen wurde.

<TM>
- Das Warenzeichen-Symbol, wie z.b. genutzt bei "lexin's magische Leckereien™"

<C>
- Das Urheberrecht-Symbol, wie z.b. genutzt bei Copyright © 2008

<R>
- Das registrierte Warenzeichen-Symbol, wie z.b. genutzt bei Speak & Spell ® ist ein registriertes Warenzeichen von Texas Instruments (Jedenfalls glaube ich, das es das ist!)

<randomfaction>
- will become the name of a random faction such as Horde, Alliance, Sindorei, Light, and over 80 more
- "For the glory of the <randomfaction>!" can become "For the glory of the Zandalar Tribe!" or many other random factions
- The list of random factions will include the name of your guild and any of your arena teams

<randomtaunt>
- will become a random insulting name, such as Meanie, Coward, Punk, N00b, and over 20 more
- "Die <randomtaunt>!" can become "Die Nub!" or "Die Son of a Hamster!" or many more

<newline>
- This will split a speech into more than one line of text, so you can say two speeches at the same time
- "For the Horde!<newline>/cheer" will say "For the Horde!" in your selected channel, and then make you do "/cheer" at the same time.

<realm>
- The name of your realm server

<zone>
- The name of your current region, zone, or location, at a high level of the greater area, for example "Dalaran"

<subzone>
- The name of the smaller area you are in within the zone, for example "the Eventide"
- This will match the location shown on your minimap

]],
},

----------------------------------------------------------------------------------------
["6. Variablen - Erweitert"] = {
order = 6,
Summary = "How to avoid talking about yourself in the third-person by using advanced substitution forms like <target|me>",
Contents = [[

<ziel|me>
<ziel|myself>
<ziel|___>

Erlaubt das bestimmen von alternativem Text um zu verhindern das über dich selbst in der dritten Person gesprochen wird.

Das funktioniert im Grunde genauso wie <ziel> abgesehen davon wenn du selbst das Ziel bist, in welchem Fall der alternative Text nach dem | benutzt wird.

Zum Beispiel damit für den Zauber Machtwort: Seelenstärke Ansagen kommen könnte jemand einen solchen Speakin Spell Spruch schreiben: "Keine panik! Ich habe <target|myself> vor Schaden bewahrt!".
- Wenn du dann Machtwort: Seelenstärke auf deinen Freund Lexin wirkst, würde "Keine Panik! Ich habe LeXin vor Schaden bewahrt!" angesagt werden.
- Und wenn du Machtwort: Seelenstärke dann auf dich selbst wirkst würde "Keine Panik! Ich habe myself vor Schaden bewahrt!" herauskommen anstelle deines eigenen Charakternamen.

<zauberwirker|I>
<zauberwirker|___>

Das funktioniert falls du der Zauberwirker bist.
]],
},

----------------------------------------------------------------------------------------
["7. Possessive Forms"] = {
order = 7,
Summary = "How to make SpeakinSpell use the correct possessive forms for names ending in 's'",
Contents = [[

Every substitution supports a possessive form, which will use the proper apostrophe for Stonarius' or Meneldill's, including:
<player's>
<focus'>
<pet's>
<selected's>
<mouseover's>
<randomfaction's>

... actually everything else too.

If the name ends in an S, it's possessive form will be like Stonarius', otherwise it will be like Meneldill's

If you are watching out for <third person|me> you can write <target's|mine>
]],
},

----------------------------------------------------------------------------------------
["8. Gender"] = {
order = 8,
Summary = "How to show male or female words in substitutions, based on the gender of your target",
Contents = [[

To refer to the gender of a substitution, use the * star symbol, followed by the text you want to show for a male and a female

Here is an example
The target is <target*male*female>

Combined with "third person or me" logic, we can write
<caster*he*she|I> cast a spell!

Possessive forms also work
<mouseover's*his*her|my> target is <mouseovertarget*a boy*a girl|me... hey!>

The male text always comes first, and then the female.  It's not sexist; it was arbitrary.

It chooses male or female text based on the gender of the unit whose name would otherwise be used.

If the gender is unknown or neutral, it will use the name instead.

]],
},

----------------------------------------------------------------------------------------
["9. <target> Info"] = {
order = 9,
Summary = [[Why doesn't it use the correct <target> name sometimes?

What if I'm focus casting?

What if I have the tank targetted but then use Healbot to raid heal someone else?]],
Contents = [[

Warum wird manchmal nicht der korrekte <ziel> Name benutzt?
Was ist wenn ich über Fokus (/Fokus) Zauber und Fähigkeiten wirke?
Was ist wenn ich den Tank im Ziel habe aber dann Healbot benutze um jemand anderen zu heilen?

Die WoW Benutzeroberfläche bietet viele verschiedene Wege Zauber auszuwählen und zu wirken, aber es ist nur einer davon der vorsieht ein Ziel auszuwählen und dann einen Zauber zu wirken (Normalerweise auf eben dieses Ziel). 
Nimm dir einen Moment Zeit um zu betrachten wie viele andere Wege es gibt einen Zauber zu wirken. Solche wie zuerst auf einen Zauber zu klicken um einen "umrandeten" Cursor zu erhalten und folglich auf ein Ziel oder einen Gegner zu klicken, oder auch mithilfe des (/Fokus) Befehls über Fokus wirken, oder Makros, oder andere Add ons um Ziele auszuwählen und dann Zauber oder Fähigkeiten zu wirken.

SpeakinSpell wird das aktuelle echte Ziel deines Zaubers so oft wie möglich nutzen um dein <ziel> Name zu unterstützen, genauso wie als ob du %t in einem Makro benutzt das du in deiner normalen WoW Benutzeroberfläche gebaut hast, so wie du es auch erwarten würdest.

Leider wird in manchen Fällen die Zauber Zielinformation nicht von Blizzard's WoW LUA API unterstützt wenn SpeakinSpell gemeldet wird, dass ein Zauber gewirkt wurde. Die meist verbreitetsten Fälle beinhalten das Wirken von Zaubern auf tote Spieler welche ihren Geist freigelassen haben (z.b. Wiederbelebung), sowie nicht-anwählbare Zauber welche nur selbstwirkend sind (z.b. Schildwall des Kriegers).

In diesen Fällen muss SpeakinSpell seine beste Einschätzung verwenden. Es wird versuchen einen Zielnamen von den folgenden Quellen zu nutzen (In dieser Reihenfolge):

1) Der Zielname unterstützt mit der Zauberwirkereignis-Benachrichtigung (Falls verfügbar wird dies das echte Zauberziel sein).
2) Andernfalls wird versucht dein derzeitig ausgewähltes Ziel zu verwenden, falls du eins angewählt hast (UnitName("target") API).
3) Andernfalls wird versucht der Name deines Fokusziels zu verwenden, falls du einen Fokus gesetzt hast (UnitName("focus") API).
4) Andernfalls wird von Selbstwirkung ausgegangen und dein eigener Name wird verwendet (UnitName("player") API).

Die Chancen stehen gut das diese Methode den korrekten Namen des Ziels deines Zaubers wiederauffinden kann, aber es ist nicht garantiert durch die Vielzahl an Möglichkeiten einen Zauber in WoW zu wirken.

Falls du mir nicht-anwählbaren Zaubern arbeitest, oder bestimmten Zaubern welche ganz einfach durch Blizzard verbuggt sind, dann solltest du <ziel> mit Vorsicht benutzen und über Alternativen für die Variablen <Zauberwirker>, <spieler> und <Fokus> nachdenken, was wohl in dem Fall nützlich sein wird, damit deine Sprüche korrekt ausgegeben werden.

Diese Einschränkung betrifft ebenfalls <zielrasse> und <zielklasse>.
]],
},

----------------------------------------------------------------------------------------
["10. Custom Macros"] = {
order = 10,
Summary = "How to create custom Speech Events",
Contents = [[

Du kannst SpeakinSpell auch dazu benutzen zufällige Schlachtschreie auszurufen mit einem Klick auf ein Button, oder auch Grüße, oder Abschiedsworte, oder eine Liste von Witzen die du geschrieben hast oder was auch immer du willst.

Ein SpeakinSpell "Custom Makro" ist eine Art von Ereignis welches in einen beliebigen Chat angesagt wird unter Verwendung eines zufälligen Spruches wie auch bei irgendeinem Zauber, einer Fähigkeit oder anderem erkannten Ereignis.

Du kannst gebräuchliche Makros erstellen und benutzen indem du folgendes tippst:
/ss makro irgendetwas

Falls dies das erste mal ist das du dieses einzelne Makro eingibst wird dich Speakinspill auffordern neue Nachrichteneinstellungen für dieses Ereignis zu erstellen.

Wenn du bereits Nachrichteneinstellungen für das Ereinis "Wenn ich tippe: /ss makro etwas" erstellt hast, dann wird das tippen von "/ss makro etwas" das Ereignis auslösen und eine deiner Nachrichten auswerfen, genauso wie ein Zauberereignis.

Du kannst "/ss makro etwas" in ein Makro (/m) packen, mit oder ohne irgendwelchen anderen Makrobefehlen.
]],
},

----------------------------------------------------------------------------------------
["11. Weitere Ereignisse"] = {
order = 11,
Summary = "A list of other Speech Events that SpeakinSpell can announce.",
Contents = [[

SpeakinSpell can also detect a variety of events which are not directly tied to casting spells.

There are several kinds of these other events, which fall into event type categories other than those used for the different kinds of spell events.

The following event types and specific events are currently supported:

-- Chat Events -- 
These events are triggered when someone says something to you in the chat

Chat Event: Whispered While In-Combat
- allows you to auto-reply with a randomized comment, for example "/r sorry can't talk right now, busy fighting with <selected>"
- <target> is the target of the event, meaning you, the player, who was the target of the whisper
- <caster> is the author of the message whispered to you
- <text> is a special substitution supported for this event only, and is the contents of the whisper.
- This can be used to relay the whisper into party chat for example "/p <caster> whispered me to say: <text>"
- This event will NOT be announced when you send a whisper to yourself

Chat Event: a guild member said "ding"
Chat Event: a party member said "ding"
- Searching for the word "ding" in the chat messages is not case-sensitive
- <caster> is the player who said "ding"
- For the guild chat version of this event, <target> is the name of the guild.  N/A to party chat.


-- Combat Events --
These events are miscellaneous combat-related events that are not directly tied to any of the other spell casting based events.

Combat Event: Entering Combat
Combat Event: Exiting Combat
- Theses two events are detected whenever you enter or exit the state of being "in combat" technically based on the WoW LUA API events PLAYER_REGEN_ENABLED and PLAYER_REGEN_DISABLED.

Combat Event: Yellow Damage (<damagetype>)
Combat Event: White Damage (<damagetype>)
- This is a group of events, Signalled when you score white or yellow damage with any spell, ability, or auto-attack
- Technically based on the Blizzard API event: COMBAT_LOG_EVENT_UNFILTERED, with eventtype="SPELL_DAMAGE" (yellow hits) or "SWING_DAMAGE" (white hits)
- <damagetype> is a string composed of all of the following that apply (in this order): 
- Crushing, Critical, Resisted, Blocked, Absorbed, Glancing, Killing Blow
- If none of those apply, then it will be a simple "Hit"
- example event name: "Combat Event: Yellow Damage (Critical, Killing Blow)" but many other permutations are also possible
- In addition to all standard substitutions, the following substitution values may also be used for these events:
- <damage> is the amount of damage dealt
- <school> is physical, arcane, fire, etc.
- <damagetype> has a substitution value that matches the <damagetype> in the event name
- <overkill> is a number >= 0 (<damagetype> will include "Killing Blow" only if overkill>0)
- <name> and <eventname> have the value "Yellow Damage (<damagetype>)"
- likewise, <displayname> is "Combat Event: Yellow Damage (<damagetype>)"
- however, <spellname> and <spelllink> will specify the spell or ability that was used to deal this damage
- all other standard substitutions apply as usual


-- NPC Interaction --
These events are related to interacting with NPCs and similar game objects such as mailboxes and barber chairs.

NPC: Open Gossip Window
- Signalled when right-clicking on most interactive NPCs
- Implemented by the Blizzard API notification event: GOSSIP_SHOW
- Many NPCs do not show this gossip window if they only offer a single option, but this event will fire in many of those cases anyway, though not 100% reliably unless there are 2 or more options in the gossip window

NPC: Talk to Vendor
- Signalled when you open an NPC vendor interface
- This event is sometimes preceded by the "NPC: Open Gossip Window" event, but not always

NPC: Talk to Trainer
- Signalled when you talk to a class trainer or profession trainer
- This event is usually preceded by the "NPC: Open Gossip Window" event, but not always

NPC: Talk to Flight Master
- Signalled when you open the "taxi map" interface from a Flight Master NPC
- This event is sometimes preceded by the "NPC: Open Gossip Window" event, but not always

NPC: Quest Greeting
- Fired when talking to an NPC that offers or accepts more than one quest, i.e. has more than one active or available quest. 
- This event is sometimes preceded by the "NPC: Open Gossip Window" event, but not always

NPC: Open Mailbox
- Signalled when you open the mailbox interface

NPC: Enter Barber Chair
NPC: Exit Barber Chair
- These events are announced when opening and closing the barber shop interface


-- Achievement Events --
These are signalled when someone earns an achievement

Achievement Earned by Me
- Announces when you earn an achievement.
- Supports the following event-specific substitutions (a bit more than the other achievement events):
- <achievement> is the name of the achievement
- <desc> describes the achievement
- <reward> is the reward (may be an empty string)
- <points> is how many points the achievement was worth
- <spelllink> creates a clickable link to the achievement info, as with a spell event

Achievement Earned by Someone Nearby
Achievement Earned by A Guild Member
- <target> and <caster> are the name of the player who earned the achievement
- example uses include "/t <caster> grats!", "/s grats <caster>", and "/congrats <caster>"
- For these events, <achievement> and <desc> use the same value as <spelllink>
- <reward> and <points> are not supported for these events, as they are when announcing your own achievements.


-- Misc. Events --
These miscellaneous events do not seem to fall into any other category

Misc. Event: SpeakinSpell Loaded
- This pseudo spell event is detected at login or whenever you reload your UI.

Misc. Event: Level Up
- Signalled when you level up

Misc. Event: a player sent me a rez
- Signalled when you are prompted to accept the rez
- <caster> is the caster of the rez spell
- <target> is you
- <spellname> and <spelllink> is unfortunately "a player sent me a rez"

Misc. Event: Open Trade Window
- Signalled when you open a trade window with another player
- <caster> is you
- <target> is the <selected> trade partner

Misc. Event: Changed Zone
Misc. Event: Changed Sub-Zone
- These two events are detected as you move around the world map.
- The Zone is the larger map region.  The Sub-Zone name is the smaller area, and what is usually displayed on your minimap.
- This applies to entering and exiting instances

Misc. Event: Begin /follow
Misc. Event: End /follow
- Announced when you begin or end auto-follow using the "/follow" command
- <target> is the name of the player you're following
]],
},

----------------------------------------------------------------------------------------
["12. Emotes"] = {
order = 12,
Summary = "How to use voice emotes and other slash commands in speeches",
Contents = [[

If you select Emote as a channel in the drop-down list, that represents the emote channel, which is equivalent to typing "/e makes strange gestures"

SpeakinSpell also supports the game's built-in voice emotes and other slash commands.

Just type them into your speeches with the slash at the beginning of a line like you normally would
/roar
/attacktarget
/yes
etc.

You can also use chat channel slash commands like /p to override the channel rules for a single speech.
/p usually I spam this macro in the /say channel, but this one message belongs in party chat
/2 this lets me spam global channel 2 in response to a SpeakinSpell event
etc.

You can also use SpeakinSpell to trigger itself by entering /ss commands into an event's random speeches
/ss macro fire spells
etc.

Other addons' commands usually work too
/wt
/qh settings
etc.

Any slash command supported by the game, or that you could use in a macro, will typically work.

Due to a limitation imposed by Blizzard, you can't use this feature to execute /cast and some other secure commands, because that could potentially be used for botting.  SpeakinSpell will show you a warning if you attempt to do this.
]],
},

----------------------------------------------------------------------------------------
["13. Änderungsverlauf"] = {
order = 13,
Summary = "Where to look for the change history",
Contents = [[

Siehe unter \Interface\Addons\SpeakinSpell\ChangeLog.txt für den kompletten Änderungsverlauf in ausführlicher Variante.

Ziehe das Änderungsdokument auf der Webseite für einen weiter detailierten Änderungsverlauf auf dem Kode Datenlevel hinzu.
Klicke bei folgendem Link auf "Änderungen":
http://wow.curse.com/downloads/wow-addons/details/speakinspell.aspx
]],
},

----------------------------------------------------------------------------------------
["14. Versionsnummer"] = {
order = 14,
Summary = "How to Interpret the Version Number",
Contents = [[

The current version number is displayed on the General Settings screen, and show in the chat when you login.

Wie man die Versionsnummer interpretiert:

Die SpeakinSpell Versionsnummer besteht aus der WoW Client Versionsnumer mit der Speakinspell erstellt und getestet wurde und daraus die wievielte Veröffentlichung diese Version ist.

Zum Beispiel: SpeakinSpell Version 3.0.3.05 wurde auf Basis des wow Clienten Version 3.0.3 erstellt und ist die 5 Veröffentlichung basierend auf dieser WoW Version.

Wenn WoW 3.1.0 erscheint wird die nächste SpeakinSpell Veröffentlichung also SpeakinSpell v3.1.0.01 sein.
]],
},

----------------------------------------------------------------------------------------
["15. Nicht-englische Spiele Clients"] = {
order = 15,
Summary = "Does SpeakinSpell work in my language?",
Contents = [[

Wie man SpeakinSpell in jeglicher Sprache einrichtet:

Falls SpeakinSpell noch nicht in deine Muttersprache übersetzt wurde nur keine Sorge, es kann trotzdem für dich funktionieren.

Das Kerndesign Konzept in SpeakinSpell welches SpeakinSpell ermöglicht für jeden Zauber und jede Klasse zu funktionieren sorgt ebenfalls dafür, dass es auch mit jeder Nicht-englischen Version des WoW Clients arbeitet. 
Die Slash-Befehle und Kennzeichen in der Options-Benuteroberfläche werden natürlich in Englisch erscheinen, genauso wie die Standartbeispiele für Zaubereinstellungen und zufällige Sprüche.
Dennoch wird die Kernfunktionalität für das Erkennen benutzerbestimmter Zauber und Ereignisse und das Ansagen dieser von benutzerbestimmten Sprüche in jeglicher Sprache weiterfunktionieren.
]],
},

----------------------------------------------------------------------------------------
["16. Herkunftsgeschichte"] = {
order = 16,
Summary = [[The Origins of SpeakinSpell
(or... Lame Story of a Thanksgiving Dream)]],
Contents = [[

Die Herkunftsgeschichte von SpeakinSpell - (Oder... Die lahme Geschichte eines Thanksgiving Traum)
(*Anm. d. Übersetzers: Warum zur Hölle mache ich mir eigentlich auch noch die Arbeit das hier zu übersetzen? >_< Was solls, das ist immerhin eine Güterklasse A Übersetzung!)


Der Name Speakinspell ist ein Sprachspiel aus einer üblichen Sprach-Variante(Dialekt) des amerikanischen mittleren Westen, wie sie auch überlicherweise im englischen bei Zwergen aus Azeroth benutzt wird indem dazu tendiert wird das "g" von englischen Wörtern die auf "ing" enden wegzulassen wie z.b. Speakin' anstelle von Speaking, shootin' anstelle von shooting.

SpeakinSpell besitzt ebenfalls einen Bezug zu dem berühmten Lern-Kinderspielzeug mit dem ich in den frühen achtzigern aufgewachsen bin.

http://en.wikipedia.org/wiki/Speak_&_Spell_(game)  (Nur in Englisch)

SpeakinSpell wurde vollständig unter der Verwendung von Ace3 Bibliotheken und Tutorials geschrieben die ich online gefunden habe, um dann einigen Beispielen von Kode-Fragmenten und Add On Architektur-Konzepten zu folgen wie sie bei Titan, Omen oder Recount verwendet werden. (Alles Add ons die ich sehr hoch schätze).

SpeakinSpell wurde inspiriert durch klassenspezifische Add ons wie Cryolysis für Magier oder Necrosis für Hexenmeister. 
Der Hauptcharakter des Autor's ist ein Magier (Stonarius von Antonidas) und ich, der Autor, liebte den Humor bei der Vewendung der "zufälligen Sprüche Funktion" von Cryolysis2. 
Insbesondere aber bei automatischen Ansagen meiner eigenen ausgedachten Sprüche durch die Benutzung des Zaubers "Ritual der Erfrischung" für die ich insbesondere durch die Werbesprüche inspiriert wurde die ich auf den Essensverpackungen in meiner Küche vorfand (Zum Beispiel eine Packung von Cereal (*Anm. d. Übersetzers: Glaube Müsli im Amiland) auf der steht: "Es ist Cinnamontastic!™. Ernsthaft, ich will euch nicht auf den Arm nehmen, sie haben das Wort Cinnamontastic rechtlich und amtlich registrieren lassen, lol!)

Bedauerlicherweise funktionierte Cryolysis2 nicht mehr als WoW 3.0 veröffentlich wurde und ich war ziemlich enttäuscht, dass die "zufällige Sprüche Funktion" in der aktualisierten und neugeschrieben Version von Cryolysis3 laut dem neuen Autor nicht wiederhgerstellt werden sollte. 
Etwas musste dagegen unternommen werden...

Ich bevorzugte immer meine eigenen zufälligen Sprüche für Cryolysis2 zu schreiben, aber der einzige Weg wie ich das machen konnte war die LUA Daten zu editieren wo meine Änderungen jedoch jedesmal verloren gingen immer dann ich eine neue aktualisierte Version des Add ons installierte, welche natürlich die LUA Daten überschreibt und meine Änderungen zerstört.

So träumte ich von einer Benutzeroberfläche um die Sprüche in einer Weise zu editieren, dass sie in den "Savedvariables" Daten gespeichert werden wo sie sicher sein würden vor den Änderungen des unterstützenden LUA Kode (Welche aber notwendig sind um Addons am laufen zu halten von Patch zu Patch), sodass kommende Patches nicht meine selbsterstellen Sprüche zerstören würden für die ich Stunden verbracht hatte um die möglichst witzigsten und geistreichsten Dinge automatisch anzusagen immer dann wenn ich einen Zauber wirke.

Ausserdem fand ich (Mit Cryolysis2) heraus, dass Verwandlungs-Ansagen in 5-Mann Gruppen sehr nett sein können. Sie wurden aber ziemlich nervig in 25-Mann Schlachtzügen, wenn es darum ging denselben Mob 20 mal hintereinander im gleichen Kampf neu zu verwandeln. Situationen in denen ich oft gefragt wurde die Sprüche abzustellen. Mit der Erkenntnis das es ein wenig nervig war die Einstellungen jedesmal umzustellen wenn ich einem Schlachtzug beitrat oder verließ, träumte ich darüber eine solche logische Funktion in einem "Zauber-sprechenden Add on" zu haben.

Ich träumte darüber ein solches Add on on zu erschaffen, vielleicht sogar ein ganzes Jahr, aber ich fürchtete die nötigen zu lernenden Sachkenntnisse. Auch wenn ich 10 Jahre Erfahung mit C++ habe, zu lernen in LUA zu programmieren ist wie das neulernen einen Paladin nach Patch 3.0 zu spielen und ich dachte, dass ich es nicht packen würde. Aber dann eines Tages dachte ich zufällig an das Speak & Spell Spielzug und das der Add on Name "Speakin' Spell" passen würde. Ich dachte: "Ok, das besiegelt es, nun MUSS ich dieses Add on machen!" und so begann der nächste Tag, der erste Tag des langen Wochenende Thanksgiving 2008, welches mir reichlich Zeit verschaffte...

Und so wurde SpeakinSpell geboren.

Danke dir dafür das du SpeakinSpell benutzt!. Es ist einfach Mannabiscuitalicious!™ :P

Er... Ummm... Kompatibel mit WotLK und Stufe 80 nun... also uh..

Danke dir dafür das du SpeakinSpell benutzt!. Es ist einfach Manastrudeltastic!™ :P
]],
},

----------------------------------------------------------------------------------------
["17. Credits"] = {
order = 17,
Summary = [[SpeakinSpell is brought to you by an educational children's toy, the letter 'R', and contributions from players like you...]],
Contents = [[

SpeakinSpell was created by |cff33ff99Stonarius of Antonidas|r

Additional coding by...
- Duerma

Primary Beta Testing, Arena Team Pwnage, Key Grip...
- Meneldill

Translators who help me in so many other ways...
- leXin for the German deDE
- troth75 for the Korean koKR

Many of the default speeches were blatantly stolen from...
- Cryolysis2
- Necrosis
- LunarSphere
- Ultimate Warcraft Battlecry Generator

Thanks for the open license guys!  I hope you like what I did with it.

Additional Content Packs Written by...
- Stonarius
- Meneldill
- leXin
- troth75
- Folji
- Dire Lemming

Special thanks to the authors of these addons that I used for copy-paste... *Ahem* I mean example code...
- Titan
- Omen
- Recount
- Healbot 
- Mountiful
- the WowAce libs

Additional thanks to...
- Blizzard Entertainment for this great game! ... hire me??
- The community on the wowace forums
- curse.com
- Microsoft Visual Studio, SubVersioN, and TortoiseSVN
- Texas Instruments for enabling E.T. to phone home
- The Order of the Stick
- Mom and Dad
- YOU!!

SpeakinSpell is made from 83% Recycled Materials.

No animals were harmed in the making of this addon.

... Well, the hunter popped a sheep with his aoe, but I resheeped with my /cast [target=focus] macro, and automatically said "Baaah! sheeped again <target>?!" and it was all good...
]],
},

----------------------------------------------------------------------------------------
} -- end HELPFILE.PAGES


--ACHTUNG ÜBERSETZER:
-- Wenn der Benutzer /ss help, oder irgendeinen ungültigen /ss Befehl eingibt
-- wird das Fenster für die Options-Benutzeroberfläche geöffnet um dieses Kapitel des Benutzerhandbuchs anzuzeigen, oberhalb definiert
-- muss der Name des Kapitels exakt mit dem Namen des zwischen den Klammern [] festgelegten "table key" übereinstimmen
-- Zum Beispiel, in Englisch legt der "table" oberhalb fest ["4. Slash Commands"] = [[ ... ]], also fügen wir hier das folgende ein:
HELPFILE.SLASH_COMMANDS = 4
