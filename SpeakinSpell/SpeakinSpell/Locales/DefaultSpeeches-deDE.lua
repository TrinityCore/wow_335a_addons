-- Author      : RisM
-- Create Date : 5/21/2009 11:46:36 PM

-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local DEFAULT_SPEECHES = AceLocale:NewLocale("SpeakinSpell_DEFAULT_SPEECHES", "deDE", false)
if not DEFAULT_SPEECHES then return end

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")

SpeakinSpell:PrintLoading("Locales/DefaultSpeeches-enUS.lua")

-------------------------------------------------------------------------------
-- ADVERTISEMENTS for /ss ad
-------------------------------------------------------------------------------

DEFAULT_SPEECHES.ADVERTISEMENTS = {
	[[Gefallen an meinen Makros gefunden? Besorg dir auch das Add on "SpeakinSpell", jetzt auch komplett in Deutsch!]],
}

-------------------------------------------------------------------------------
-- DEFAULT SETTINGS FOR NEW SPELLS
-------------------------------------------------------------------------------

DEFAULT_SPEECHES.NEWSPELL = {
	[1] = "<spieler> wirkt <zaubername> (<zauberrang>) auf <ziel>",
	[2] = "ZuTUN: Na los, schreib selbst Sprüche für SpeakinSpell! Ich sage immer nur <zaubername>. Wie öde..",
}

-------------------------------------------------------------------------------
-- DEFAULT SPEECH TEMPLATES FOR VARIOUS KINDS OF PLAYERS
-------------------------------------------------------------------------------

DEFAULT_SPEECHES.Templates = {

-------------------------------------------------------------------------------
-- Template: Battlecries, <randomtaunt> and <randomfaction>
-------------------------------------------------------------------------------

{
	name = "Battlecries",
	desc = "Random Battlecries (/ss macro battlecry) including <randomfaction> and <randomtaunt>",
	Attributes = {
		selected = true,
	},
	Content = {
		RandomSubs = {
			-- <randomfaction> substitutions
			-- This is a list of possible values which can be substituted for <randomfaction>
			-- intended for random battlecries... "Feel the wrath of the <randomfaction>!" becomes...
			-- "Feel the wrath of the Tauren!" or "Feel the wrath of the Pie!" or "Feel the wrath of the Ladies Undergarments!" 
			["randomfaction"] = {
				"Legion",
				"Horde",
				"Fel Horde",
				"Scourge",
				"Alliance",
				"Tauren",
				"Taunka",
				"Ladies' Undergarments",
				"Forsaken",
				"Sindorei",
				"Beer",
				"Pie",
				"Naaru",
				"Lich King",
				"Old Gods",
				"Warchief",
				"Azshara",
				"Grand Alliance",
				"Holy Light",
				"Ancients",
				"King",
				"Defilers",
				"Argent Dawn",
				"Argent Crusade",
				"Kalu'ak",
				"Frenzyheart Tribe",
				"Oracles",
				"Wyrmrest Accord",
				"Kirin Tor",
				"Knights of the Ebon Blade",
				"Valiance Expedition",
				"Silver Covenant",
				"Explorers' League",
				"Warsong Offensive",
				"Hand of Vengeance",
				"Silverwing Sentinels",
				"League of Arathor",
				"Stormpike Guard",
				"Warsong Outriders",
				"Frostwolf Clan",
				"Steamwheedle Cartel",
				"Sha'tar",
				"Ashtongue Deathsworn",
				"Cenarion Expedition",
				"Cenarion Circle",
				"Thorium Brotherhood",
				"Wintersaber Trainers",
				"Violet Eye",
				"Silver Hand",
				"Black Dragonflight",
				"Green Dragonflight",
				"Red Dragonflight",
				"Bronze Dragonflight",
				"Infinite Dragonflight",
				"Scarlet Crusade",
				"Syndicate",
				"Zandalar Tribe",
				"Consortium",
				"Mag'har",
				"Aldor",
				"Scryers",
				"Shattered Sun Offensive",
				"Sha'tari Skyguard",
				"Gelkis Clan Centaur",
				"Hydraxian Waterlords",
				"Keepers of Time",
				"Magram Clan Centaur",
				"Warriors of the Night",
				"Dichotomy of good and evil",
				"love of Elune",
				"Ironforge Dwarves",
				"Darnassian Elves",
				"Gnomeregan Exiles",
				"Murkblood",
				"Light",
				"Illidari",
				"Forces of Darkness",
				"Forces of the Light",
				"Friends of the Happy Friendly Helping Time",
			}, -- end <randomfaction> for "All Players" template
			-- <randomtaunt> substitutions
			-- This is a list of possible values which can be substituted for <randomtaunt>
			-- intended for random battlecries... "Feel my wrath, <randomtaunt>!" becomes...
			-- "Feel my wrath, Punk!" or "Feel my wrath, Be-otch!" or "Feel my wrath, Sweet Cheeks!"
			-- also consider "Feel my wrath, you <randomtaunt>!" -> "Feel my wrath, you Son of a hamster!"
			["randomtaunt"] = {
				"Punk",
				"Be-otch",
				"Sweet Cheeks",
				"Chicken",
				"Coward",
				"You",
				"Frail piece of chicken dung",
				"Weakling",
				--"Whiskey soaked, foaming at the mouth, toilet talking, pea soup spewing, sweating blood, demon breath, Alice Cooper loving punk",
				"Meanie",
				"Meanie-head",
				"Jerk-face",
				"Pudding for brains",
				"Baby",
				"Baby-eater",
				"Tard",
				"N00b",
				"Nub",
				"Git",
				"Self-righteous Git",
				"Evil-doer",
				"Do-gooder",
				"Goody two-shoes",
				"Evil Nasty Meanie-Head",
				"...Mean... Person...",
				"Idiot",
				"Witch",
				"Leroy",
				"@$&*%!",
				"No-Good, Rotten, Scoundrel",
			}, -- end <randomtaunt> for "All Players" template
		}, -- end Random Subs
		EventTable = {
			["MACROMACRO_ATTACK_OR_CHARGE"] = {
				["DetectedEvent"] = {
					["type"] = "MACRO",
					["name"] = "macro attack or charge",
				},
				["Messages"] = {
					"/attacktarget",
					"/charge",
				},
			},
			["MACROMACRO_BATTLECRY"] = {
				["DetectedEvent"] = {
					["type"] = "MACRO",
					["name"] = "macro battlecry",
				},
				["Messages"] = {
					"/ss macro attack or charge",
					"/ss macro attack or charge\nFeel the wrath of the <randomfaction>, <randomtaunt>!",
					"/ss macro attack or charge\nDIE, <target>! Feel the wrath of the <randomfaction>!",
					"/ss macro attack or charge\nDIE, <randomtaunt>! Feel the wrath of the <randomfaction>!",
					"/ss macro attack or charge\nDIE, <target>! Your evil shall never triumph!",
					"/ss macro attack or charge\nDIE, <randomtaunt>! Your evil shall never triumph!",
					"/ss macro attack or charge\nDIE, <target>, you <randomtaunt>! Feel the wrath of the <randomfaction>!",
					"/ss macro attack or charge\nDIE! <target>! Your evil shall be purged!",
					"/ss macro attack or charge\nDIE! <randomtaunt>! Your evil shall be purged!",
					"/ss macro attack or charge\n<target>! Face me and the might of the <randomfaction>!  You will die, <randomtaunt>!",
					"/ss macro attack or charge\nLight BURN you, <target>!",
					"/ss macro attack or charge\nHow dare you insult my mother, <randomtaunt> - Prepare to die!",
					"/ss macro attack or charge\nHow dare you insult the <randomfaction>, you <randomtaunt> - Prepare to die!",
					"/ss macro attack or charge\n<target>! Your very existance is an insult to the <randomfaction>, you <randomtaunt> - Prepare to die!",
					"/ss macro attack or charge\nFor the <randomfaction>!",
					"/ss macro attack or charge\n/y Kill the <target>!",
					"/ss macro attack or charge\nAll who betray the light shall be punished!",
					"/ss macro attack or charge\nI smite thee, <target>, in the name of the <randomfaction>!",
					"/ss macro attack or charge\nYour evil ends here, <target>!",
					"/ss macro attack or charge\nYou DARE face me, <target>?!",
					"/ss macro attack or charge\nI swear by all that is holy, I will make <target> and the <randomfaction> pay for your crimes against the <randomfaction>!",
					"/ss macro attack or charge\nThe Light shall never fade!",
					"/ss macro attack or charge\nYou will face justice!",
					"/ss macro attack or charge\nThere can be only one!",
					"/ss macro attack or charge\nFor Cenarius!",
					"/ss macro attack or charge\nFor the Horde!",
					"/ss macro attack or charge\nFor the Alliance!",
					"/ss macro attack or charge\nSpoooon!!",
					"/ss macro attack or charge\nNot in the face! NOT IN THE FACE!!",
					"/ss macro attack or charge\nI'm gonna light you up, <randomtaunt>!",
					"/ss macro attack or charge\nFeel my wrath, <randomtaunt>!",
					"/ss macro attack or charge\nFeel my wrath, you <randomtaunt>!",
					"/ss macro attack or charge\nLeeerrooooyyy Jeennkiinnnns!!!",
					"/ss macro attack or charge\nFor Leroy Jenkins!",
					"/ss macro attack or charge\nGet 'em chums!",
					"/ss macro attack or charge\n'Allo <target>, my name is <player>, you killed my father, prepare to die!",
					"/ss macro attack or charge\nThat is the last time you insult my mother, you <randomtaunt>!",
				},
				["Channels"] = {
					["Solo"] = "YELL",
					["Party"] = "YELL",
					["Raid"] = "YELL",
					["BG"] = "YELL",
					["WG"] = "YELL",
				},
				["RPLanguage"] = "Random",
				["RPLanguageRandomChance"] = 0.10,
			},
		}, -- end EventTable
	},
},

-------------------------------------------------------------------------------
-- Template: Random Names <randomboy> and <randomgirl>
-------------------------------------------------------------------------------

{
	name = "Random Names",
	desc = "Adds <randomboy> and <randomgirl> substitutions",
	Content = {
		RandomSubs = {
		-- boy's names
		["randomboy"] = {
			"Josh",
			"John",
			"Rob",
			"Jimboe",
			"Jim",
			"Jimmy",
			"Robbie",
			"Bob",
			"Robert",
			"Pierre",
			"Andy",
			"Nichlas",
			"Nate",
			"Mike",
			"Dale",
			"Jerry",
		}, -- end <randomboy>
		-- girl's names
		["randomgirl"] = {
			"Tracy",
			"Camille",
			"Kitty",
			"Erin",
			"Jeannie",
			"Erica",
			"Alison",
			"Bethany",
			"Meredith",
			"Shannon",
			"Jesse",
			"Mae",
			"Carrie",
			"Michele",
			"Katie",
			"Sally",
			"Serena",
		}, -- end <randomgirl>
	},
	},
},

-------------------------------------------------------------------------------
-- Template: <randomnonsense>
-------------------------------------------------------------------------------

{
	name = "<randomnonsense>",
	desc = "A list of randomly silly words with no apparent theme, for use in blurting out unrelated things",
	Content = {
		RandomSubs = {
		["randomnonsense"] = {
			"Kumquat",
			"Kalamazoo",
			"Pie",
			"Santa Claus",
			"zomgwtfnob!!!1!",
			"MAD LIBS!",
			"Crazy",
			"Delicious",
			"Parrot",
			"Arctic",
			"Durotar",
			"Goldshire",
			"Lumberjack",
			"Redrum",
			"... what was I saying? ...",
			"BLEEP",
			"%&^@$%#%",
		}, -- end <randomnonsense>
	},
	},
},

-------------------------------------------------------------------------------
-- Template: Eating
-------------------------------------------------------------------------------

{
	name = "Eating",
	desc = "Speech announcements for eating",
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTFOOD"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Food",
			},
			["Messages"] = {
				"sits down for a snack. Mmm!", -- [1]
				"sits down for a quick bite.", -- [2]
				"sits down to stuff their mouth full of food.", -- [3]
				"lets out a drag of breath and sits down for something to eat.", -- [4]
			},
			["Channels"] = {
				["Solo"] = "EMOTE",
				["Party"] = "EMOTE",
			},
			["Frequency"] = 0.2,
		},
	},
	},
},

-------------------------------------------------------------------------------
-- Template: Dwarf (any class)
-------------------------------------------------------------------------------

{
	name = "Dwarven Racials",
	desc = "Speeches for Dwarven racial abilities",
	Attributes = {
		race = "DWARF",
		selected = true,
	},
	Content = {
		EventTable = {
		["SPELL_AURA_APPLIED_BUFFSTONEFORM"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF",
				["name"] = "Stoneform",
			},
			["Messages"] = {
				"turns their skin to rock!", -- [1]
				"turns to stone!", -- [2]
				"becomes stoned-skinned!", -- [3]
			},
			["Channels"] = {
				["Party"] = "EMOTE",
				["Solo"] = "EMOTE",
				["Raid"] = "EMOTE",
			},
			["Cooldown"] = 30,
			["Frequency"] = 0.15,
		},
	},
	},
}, -- end Dwarf Template

-------------------------------------------------------------------------------
-- Template: Human (any class)
-------------------------------------------------------------------------------

{
	name = "Human Racials",
	desc = "Speeches for Human racial abilities",
	Attributes = {
		race = "HUMAN",
		selected = true,
	},
	Content = {
		EventTable = {
		["SPELL_AURA_APPLIED_BUFFEVERY_MAN_FOR_HIMSELF"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF",
				["name"] = "Every Man for Himself",
			},
			["Messages"] = {
				"I used <spelllink>", -- [1]
			},
			["Channels"] = {
				["Arena"] = "RAID",
			},
		},
	},
	},
}, -- end Human Template

-------------------------------------------------------------------------------
-- Template: Forsaken / Undead (any class)
-------------------------------------------------------------------------------

{
	name = "Forsaken Racials",
	desc = "Speeches for Forsaken (Undead) Racial Abilities",
	Attributes = {
		race = "SCOURGE",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTWILL_OF_THE_FORSAKENRACIAL"] = {
			["DetectedEvent"] = {
				["name"] = "Will of the Forsaken",
				["rank"] = "Racial",
			},
			["Messages"] = {
				"unleashes the will of the Forsaken!", -- [1]
				"calls on the will of the Forsaken to break free!", -- [2]
				"breaks loose from their ailments with the will of the Forsaken!", -- [3]
			},
			["Channels"] = {
				["Party"] = "EMOTE",
				["Solo"] = "EMOTE",
				["Raid"] = "EMOTE",
			},
			["Frequency"] = 0.05,
		},
	},
	},
}, -- end Undead Template

-------------------------------------------------------------------------------
-- Template: Hunter (any race)
-------------------------------------------------------------------------------

{
	name = "Hunter",
	desc = "Default sample speeches for Hunters",
	Attributes = {
		class = "HUNTER",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTTIER_RUFEN"] = {
			["Messages"] = {
				"Hierher mein Tierchen! Hier bin ich! JETZT KOMM ENDLICH!!", -- [1]
				"Keine Sorge, meistens.. ist mein Begleiter friedlich gestimmt.", -- [2]
				"Ok, da ist mein Kleiner. Er hat manchmal solche Launen.. Die Feinde anlocken und uns alle in den Tod reissen, aber was macht das schon?", -- [3]
				"Mein Kleiner beisst nur bei schlechter Laune, also sei ein wenig Rücksichtsvoll!", -- [4]
				"Aufgepasst, ich kann mein Tier nicht auf passiv stellen und Knurren lässt sich ebenfalls nicht abstellen!", -- [5]
				"Komm her zu mir, bei Fuß! Verdammt bei Fuß hab ich gesagt warum zum Teufel setzt du dich nun hin?!", -- [6]
				"Und wieder einmal stellt sich die Frage, wie mein Begleiter aus dem Nichts erscheinen kann..", -- [7]
				"Wir zwei sind bereits durch dick und dünn gegangen.. Meistens gestaltete es sich durch gemeinsames davonlaufen.", -- [8]
				"Ich brauche dich hier, mein Freund!", -- [9]
				"Ich glaube, dass hier bald schon Jemand mit der Bisskraft meines Begleiters Bekanntschaft machen wird!", -- [10]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Tier Rufen",
			},
		},
		["UNIT_SPELLCAST_SENTIRREFÜHRUNG"] = {
			["Messages"] = {
				"Nein, nicht mich! Schnapp dir <ziel>, er ist derjenige der deine Kinder töten und deine Sippe ausrotten will!", -- [1]
				"<ziel> hat deine Mutter beleidigt, willst du das auf dir sitzen lassen?", -- [2]
				"Hey, <ziel> hat den Pfeil geschossen und mir danach den Bogen zugeworfen, wirklich!", -- [3]
				"SHOWTIME! Dann zeig mal, wieviel Prügel du aushälst <ziel>!", -- [4]
				"Letzter Aufruf! Seht zu wie <Ziel> von einer Horde wütender Mobs verprügelt wird! Eintritt nur 10 Gold!", -- [5]
				"Ähm, ignoriere einfach dieses komische Zeichen über dir <Ziel>. Alles wird gut!", -- [6]
				"*Flötet scheinheilig und wirkt dabei klammheimlich Irreführung auf <Ziel>.", -- [7]
				"Was?! Sieh mich nicht so an! Los schnapp dir <ziel>, blödes Vieh!", -- [8]
				"Ich bin unschuldig! Ganz im Gegensatz zu <Ziel>!", -- [9]
				"Sieh mal <begleiter>, wir zwei schauen uns nun gemütlich an wie <ziel> für unsere Taten büßen muss.", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Irreführung",
			},
		},
		["UNIT_SPELLCAST_SENTTOTSTELLEN"] = {
			["Messages"] = {
				"Noch.. bin ich nicht Tod, aber verflucht nah dran!", -- [1]
				"*Murmelt* Bitte, Bitte fall drauf rein.", -- [2]
				"Um diesen Schrei nachzuahmen musste ich wochenlang üben.", -- [3]
				"Repkosten? Was ist das? Ich bin Jäger!", -- [4]
				"Na, also wenn das nicht Theaterreif war, was meint ihr?", -- [5]
				"Was? Kein Apllaus? Lasst euch erstmal so gekonnt hinfallen, das will geübt sein!", -- [6]
				"Verfluchter Mist, genau auf das Steißbein! Schmerz lass nach!", -- [7]
				"Wie oft habe ich dir gesagt das wenn ich es tue, du dich auch totstellen sollst <begleiter>!", -- [8]
				"Ähm, mir ist nur was runtergefallen, ehrlich!", -- [9]
				"Ich leiste euch vom Boden aus moralischen Beistand, ich glaube fest an euch!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Totstellen",
			},
		},
	},
	},
}, -- end Hunter Template

-------------------------------------------------------------------------------
-- Template: Warrior (any race)
-------------------------------------------------------------------------------

{
	name = "Warrior",
	desc = "Default sample speeches for Warriors",
	Attributes = {
		class = "WARRIOR",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTSCHILDWALL"] = {
			["Messages"] = {
				"verkeilt das Schild als SCHILDWALL auf dem Boden und verschanzt sich dahinter.", -- [1]
				"beisst grunzend die Zähne zusammen und versteckt sich hinter dem als SCHILDWALL fungierenden Schild.", -- [2]
				"knurrt laut auf als die Attacken den SCHILDWALL erfordern", -- [3]
				"kauert sich hinter das SCHILDWALL und wimmert \"Nicht ins Gesicht, nicht ins Gesicht!\"", -- [4]
				"positioniert den SCHILD zu einem WALL und duckt sich dahinter.", -- [5]
				"schreit auf vor Schmerz als die Hiebe zu zahlreich werden und der SCHILDWALL erforderlich wird.", -- [6]
				"wirft einen ängstlichen Blick zu den Heilern und ruft \"He, Leute! Hier vorne wirds brenzlig!\"", -- [7]
				"formt ein stummes Gebet auf den Lippen und verlagert das Gewicht von Innen gegen den schützenden SCHILDWALL.", -- [8]
				"zieht die Angriffe zurück und verwendet alles darauf sich Hinter den SCHILDWALL zu hocken.", -- [9]
				"reisst mit Wucht das Schild zwischen sich und die Kreaturen, um die meisten Hiebe mit dem SCHILDWALL abzufangen", -- [10]
			},
			["Channels"] = {
				["Raid"] = "EMOTE",
				["Solo"] = "EMOTE",
				["Party"] = "EMOTE",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Schildwall",
			},
		},
		["UNIT_SPELLCAST_SENTHINRICHTEN"] = {
			["Messages"] = {
				"Asche zu Asche..", -- [1]
				"Bereit für deine Schöpfer?!", -- [2]
				"Ich bin gekommen um dich zu holen <ziel>..", -- [3]
				"Es gibt keine Gnade, Nachsicht in einer Welt voller Krieg!", -- [4]
				"Genieße deinen letzten Atemzug..", -- [5]
				"Kinder?.. Frau? Pah, das ist mir egal!", -- [6]
				"Verabschiede dich <ziel>!", -- [7]
				"Deine Zeit ist gekommen!", -- [8]
				"Hör auf zu Wimmern <ziel> und stirb ehrenvoll!", -- [9]
				"Dein Lebenslicht endet hier!", -- [10]
				"Ich bin dein Richter!", -- [11]
				"Töten, oder getötet werden..", -- [12]
				"Ruhe in frieden.. Oder auch nicht.", -- [13]
				"Präzise und tödlich!", -- [14]
				"Execute!", -- [15]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Hinrichten",
			},
		},
		["UNIT_SPELLCAST_SENTHERAUSFORDERUNGSRUF"] = {
			["Messages"] = {
				"Sind das eure Ärsche oder eure Gesichter, mit denen ihr mich da anglotzt?!!", -- [1]
				"Eure Mütter kacken euch zum Nikolaus die Schuhe voll!", -- [2]
				"Was soll das werden?! Ihr schlagt ja zu wie nen haufen räudiger Gnome!", -- [3]
				"Hat mich da gerade was berührt? Oh ihr wart es!", -- [4]
				"Ich reiss' eure Köpfe ab und piss euch in die Hälse!", -- [5]
				"Ihr seid so hässlich, ihr könntet glatt moderne Kunstwerke sein!", -- [6]
				"*Brüllt herausfordernd* Wie siehts aus ihr Versager?! Alle gegen mich? Versuchts nur!!", -- [7]
				"Ich bin noch nie soviel Scheisse auf einem Haufen begegnet, bis ich euch sah!", -- [8]
				"Erbärmlich! Seht euch nur an, was für ein Verein von Krüppeln und Versager ihr seid!", -- [9]
				"Herausforderungsruf: Eure Mütter sind so hässlich sie wollten an einem Hässlichkeitskontest mitmachen und die Organisatoren sagten \"Sorry, keine Profis!\"", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Herausforderungsruf",
			},
		},
	},
	},
}, -- end Warrior Template

-------------------------------------------------------------------------------
-- Template: Paladin (any race)
-------------------------------------------------------------------------------

{
	name = "Paladin",
	desc = "Default sample speeches for Paladins",
	Attributes = {
		class = "PALADIN",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTHAND_DES_SCHUTZES"] = {
			["Messages"] = {
				"Du hast genau 10 Sekunden bevor die Blase ausläuft <ziel>. Ich schlage dir vor zu beten.", -- [1]
				"Und da will einer sagen NUR wir Palas hätten Blasenschwächen..", -- [2]
				"Nutze Verbände oder nimm die Beine in die Hand <ziel>.", -- [3]
				"Du brauchst mir nicht zu danken, das Wissen, dass ich dich vor dem Tod bewahrt habe reicht mir <ziel>.", -- [4]
				"Denk dran.. in der Blase gibts kein Handyempfang <ziel>!", -- [5]
				"Tu, was immer du auch am liebsten tust, doch solltest du in spätestens 10 Sekunden fertig sein <ziel>!", -- [6]
				"Hach, ich liebe es einfach diese Taste zu drücken <ziel>.", -- [7]
				"Hm, was wäre schon ein Pala ohne seine Blasen <ziel>?", -- [8]
				"Wirke Hand des Schutzes auf <ziel> Was glaubt ihr wieviele Leben dieses Ding bereits gerettet hat?", -- [9]
				"Hey <ziel>, du gibst aber' nen niedlichen, ähm Blase-Hase ab.", -- [10]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Hand Des Schutzes",
			},
		},
		["UNIT_SPELLCAST_SENTGÖTTLICHE_BITTE"] = {
			["Messages"] = {
				"Licht!, bitte lass mich nicht oom gehen.", -- [1]
				"Mana, MANA!, ich spüre wie es durch meine Adern fließt!", -- [2]
				"Hey achtung, meine Heilleistungen werden für 15 Sekunden geschwächt!", -- [3]
				"YAH GUTER STOFF!", -- [4]
				"Initialisiere göttliche Manaeinspritzung!", -- [5]
				"Mana Mana badi bidibi - Nutze göttliche Bitte für extra Mana!.", -- [6]
				"Yeah Baby, ich liebe dieses Gefühl wenn es regt!", -- [7]
				"Manaflut aktiviert!, regge 25% meines Gesamtmanas!", -- [8]
				"Garghl, schneller, schneller, schneller! brauche Mana!", -- [9]
				"Mana, Mana, Mana! Wenn der Tank schon wieder stirbt werde ich noch gekickt!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Göttliche Bitte",
			},
		},
		["UNIT_SPELLCAST_SENTHAND_DER_ERLÖSUNG"] = {
			["Messages"] = {
				"Schalt mal lieber ein Gang runter <ziel>. ", -- [1]
				" *Ohrfeigt <ziel> mit der Rückhand der Erlösung* ", -- [2]
				"He Tank, ich will <ziel> bei dir verpetzen, da er sich nicht zu bremsen weiß! ", -- [3]
				"Achtung, Achtung! Hier spricht die Küstenwa... ähh die Aggrowache, halten sie sofort an <ziel> und stellen sie den Motor ab! ", -- [4]
				"Schaden in allen Ehren, ist dir deine Haut nicht wichtiger <ziel>? ", -- [5]
				"Teert und Federt <ziel> für sein Aggroverhalten! ", -- [6]
				"Danke, <ziel>, nun muss ich meine Zeit echt auch noch mit dieser Aggrodrossel verschwenden.. ", -- [7]
				"<ziel> gewinnt einen Strafzettel für zu schnelles rasen im Bedrohungsmeter, 5g für jeden in der Nähe! ", -- [8]
				"He, beruhig dich <ziel>! ", -- [9]
				"Hoo mein Pferdchen *zieht die Aggrozügel bei <ziel> an* ", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Hand Der Erlösung",
			},
		},
		["UNIT_SPELLCAST_SENTGÖTTLICHES_EINGREIFEN"] = {
			["Messages"] = {
				"<ziel> bekommt göttliches Eingreifen.", -- [1]
				"Tada!, keine Repkosten für mich und <ziel>!", -- [2]
				"Hey <ziel>, dafür will ich als erstes belebt werden!", -- [3]
				"Mein Leben für deins, nutze es klug <ziel>!", -- [4]
				"Hah! Ich bin ein Held! <ziel> ist der \"über\"lebende Beweis!", -- [5]
				"Licht!, dieser Schmerz, ich...", -- [6]
				"Möge meine Seele das Schild ersetzen das uns hätte vor diesem Schicksal bewahren sollen!", -- [7]
				"Meine Zeit ist gekommen..", -- [8]
				"Nimm das Geschenk meines Lebens an <Ziel>", -- [9]
				"Verfluchtet mist! Ich hasse Situationen wo das nötig ist!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Party"] = "PARTY",
				["BG"] = "SAY",
				["Solo"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Göttliches Eingreifen",
			},
		},
		["UNIT_SPELLCAST_SENTHANDAUFLEGUNG"] = {
			["Messages"] = {
				"Du bist auserwählt <ziel>! Handauflegung!", -- [1]
				"Fragt mich nicht wie ich <ziel> aus dieser Entfernung meine Hand auflegen konnte!", -- [2]
				"Handauflegung: Na, wo soll der Onkel Doktor pieksen <ziel>?", -- [3]
				"Licht!, erinnere dich an das mal als ich zur Kirche ging damals'83? Nun brauche ich den Gefallen zurück!", -- [4]
				"Ich bemitleide die Dummköpfe die sich davon nicht beeindrucken lassen! Healadin ftw!", -- [5]
				"Spür die heilende Macht des Imbadins <ziel>!", -- [6]
				"Hrhr, ich liebe es anderen die Handaufzulegen.", -- [7]
				"Wo hättest du es denn gern <ziel>, am Po? Wirke Handauflegung!", -- [8]
				"Hey <ziel>, wie wärs wenn ich auch in zweisamen stunden Handauflegung auf dich wirke?", -- [9]
				"Spüre meine.. ähm warme und zarte Hand <ziel>! Wirke Handauflegung!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Handauflegung",
			},
		},
		["UNIT_SPELLCAST_SENTERLÖSUNG"] = {
			["Messages"] = {
				"NEIN NEIN! noch nicht <ziel>! Ich lasse dich nicht gehen mein Freund!", -- [1]
				"Wende dich ab, verlasse den Lichterpfad <ziel>, komm zurück in die Welt der Lebenden!", -- [2]
				"Erhebe dich, <ziel>, atme den Hauch des Lebens, den ich dir als Teil meiner selbst schenke *flüstert*..", -- [3]
				"Gratia plena, Dominus tecum benedicta tu in mulieribus *haucht* Ergreife meine Hand, mein Innerstes ruft nach dir <ziel>..", -- [4]
				"Vergib mir, <ziel> *leise* ich kann dich noch nicht ziehen lassen..", -- [5]
				"Et expecto resurrectionem <ziel> mortuorium et vitam venturi saeculi.", -- [6]
				"Noch ist nicht die rechte Zeit zu ruhen <Ziel>, wir brauchen dich doch hier.", -- [7]
				"Sei stark und finde den Weg zurück <ziel>, finde die Kraft in Denjenigen die dich lieben und brauchen.", -- [8]
				"Verzeih mir, dass ich das Recht nehme über deine Seele zu richten <ziel>, doch du musst umkehren..", -- [9]
				"Zuviele Dinge lässt du ungeklärt zurück <ziel>.. Ich als die Hand meines Gottes rufe dich zurück! Gehe noch nicht..", -- [10]
				"Licht!, ich als dein Streiter, dein Schild beschwöre dich!.. Leih mir die Gabe einzugreifen, <ziel>`s Seele zurückzuführen, amen.", -- [11]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Erlösung",
			},
		},
	},
	},
}, -- end Paladin Template

-------------------------------------------------------------------------------
-- Template: Mage (any race)
-------------------------------------------------------------------------------

{
	name = "Mage",
	desc = "Default sample speeches for Mages (all races/factions, some portals not included)",
	Attributes = {
		class = "MAGE",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTUNSICHTBARKEIT"] = {
			["Messages"] = {
				"Schau genau hin und zähle bis 20.", -- [1]
				"Ich geh'ne Runde im Nether spazieren.", -- [2]
				"Viel Spaß beim whipen! Ich verdrück mich.", -- [3]
				"*Flüstert* Schemenhaft..", -- [4]
				"War ich vielleicht die ganze Zeit nur ein Trugbild deiner Sinne?..", -- [5]
				"Initialisiere Dimensionswechsel!", -- [6]
				"Vielleicht sehen wir uns beim sonnen in Mulgore wieder.", -- [7]
				"Sorry, dringende Geschäfte warten!", -- [8]
				"Von nun an müsst ihr ohne mich klarkommen, oder eben sterben. He, nicht traurig sein, Life is a bitch!", -- [9]
				"Sagt Ernie, das ich ihn liebe!, Woot? Wer zur Hölle ist Ernie?! Verrückter Addonübersetzer..", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Unsichtbarkeit",
			},
		},
		["UNIT_SPELLCAST_SENTTISCHLEIN_DECK_DICH"] = {
			["Messages"] = {
				"Tischlein deck dich wurde in der Nähe von <spieler> gesetzt, bitte Pfoten an den Tisch zum unterstützen!", -- [1]
				"K1ick 4 t@b1e.", -- [2]
				"Magisches Gebäck, Brownies und Goo-balls 5€. CDs 10€. T-shirts 15€. Genieß' die Show!", -- [3]
				"<spieler's> Magisches Gebäck<TM> - WARNUNG: Erzeugt möglicherweise Übelkeit, Appetitsverlust, Blindheit, Panikattacken, Dauerstuns, oder spontane Verwandlungen in ein Schaf, Schwein oder Schildkröte. Fragen sie ihren Arzt oder Apotheker vor dem Verzehr.", -- [4]
				"<spieler's> Magisches Gebäck<TM> - Nur jetzt! mit 30% weniger Kalorien!", -- [5]
				"<spieler's> Magisches Gebäck<TM> - Probiere <spieler's> Magisches Gebäck<TM>! 100% aus ökologischem Anbau, nur jetzt in Teriaki Tofu Geschmack!", -- [6]
				"<spieler's> Magisches Gebäck<TM> - Hände an den Tisch und keine Bewegung!", -- [7]
				"<spieler's> Magisches Gebäck<TM> - Jetzt mit +35 Ausdauer Buff!! (Der Spieler übernimmt hiermit keine Gewähr für Probleme mit dem Buffeffekt) ", -- [8]
				"<spieler's> Magisches Gebäck<TM> - Bitte keine Krümel an Tauben und Enten verfüttern, nach neuesten Studien kann es zu Explosionen kommen, wir danken für ihr Verständnis.", -- [9]
				"SHOWTIME: Futtertrog abgesetzt! Na los ihr Schweinchen, greift und grunzt um die Wette!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Party"] = "SAY",
				["BG"] = "SAY",
				["Solo"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Tischlein Deck Dich",
			},
		},
		["UNIT_SPELLCAST_SENTSPIEGELBILD"] = {
			["Messages"] = {
				"Ich würde dir gerne Jemanden vorstellen mein Cousin Darrel, mein anderer Cousin Darrel und natürlich mein anderer Cousin Darrel.", -- [1]
				"In einem Notfall sind die Magier hier zu finden, hier und hier und natürlich hier drüben!", -- [2]
				"Ich schätze ich seh ganz gut aus wenn ich das so sagen kann. Da stimme ich dir völlig zu! Ich hier drüben auch und ich sagte es ja Gestern schon!", -- [3]
				"Und so fingen die Clonkriege an..", -- [4]
				"Was schaust du so entsetzt?! Vier mal ich, ein Grund zur Freude!", -- [5]
				"Quadro-Technik! Was für eine Bereicherung für die Welt!", -- [6]
				"Mach vier! die Kraft von vier Magiern. Jetzt neu bei jedem gewerbstätigen Magier zu beanstanden.", -- [7]
				"Also aufgepasst! Du machst den Spül, du wäschst unsere Kleidung und du da treibst was zu Essen auf und ich? Ich trage schwer an der Verantwortung!", -- [8]
				"Lenkt mich nicht ab, sonst machen die Anderen was sie wollen! Neulich wollten sie mich einen Wasserfall hinabstoßen!", -- [9]
				"Aufgepasst Team!, der dort drüben hat sein Schutzgeld nicht bezahlt. Zeit für' ne Abreibung!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Spiegelbild",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_DALARAN"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Dalaran gehen wenn wir Dalaran zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Dalaran? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Dalaran gelangen, nicht in die Mitte des Ozeans, Dalaran.. Ozean.. Dalaran.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den Alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Haltet verdammt nochmal die Klappe, ich muss mich konzentrieren, oder wollt ihr auf der anderen Seite IN einer Wand herauskommen?!", -- [11]
				"Macht dann bitte 18958 Gold... Na, nun glotzt mich nicht so an! Irgendwie muss man doch das Geld fürs Mammuth verdienen!", -- [12]
				"Wundert euch nicht, falls ihr beim durchschreiten des Leyliniennetz Skelette neben dem Pfad seht.. Hin und wieder stolpert Jemand, kommt vom Pfad ab und verdurstet dann.", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Dalaran",
			},
		},
		["UNIT_SPELLCAST_SENTWASSERELEMENTAR_BESCHWÖREN"] = {
			["Messages"] = {
				"Ja verdammt, ich bin dein Gott! Wie oft muss ich dir das noch sagen Frosty?!", -- [1]
				"Lasst mich meinen kleinen Freund Vorstellen, Opfer das ist Frosty, Frosty deine Opfer.", -- [2]
				"Asche zu Asche und Frost zu Frost..", -- [3]
				"Geduld bitte, ich muss mich erst mit meinem Elementar Frosty beraten!", -- [4]
				"...und Gott sprach, es werde Frost!", -- [5]
				"Schon als Kind habe ich gerne mit Wasser gespielt.. bis an dem Tag als Joe ertrank.", -- [6]
				"Spritzig, feucht und tödlich, Frosty weiß was er zu bieten hat!", -- [7]
				"Na, wer ist nun in der Übermacht?!", -- [8]
				"Wer braucht schon Feuermagier wenn man DAS haben kann?", -- [9]
				"Ich fürchte mein Elementar Frosty kann dein Gesicht ganz und gar nicht leiden <Ziel>.", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Wasserelementar Beschwören",
			},
		},
		["UNIT_SPELLCAST_SENTKAMPFESHITZE"] = {
			["Messages"] = {
				"Du oder ich..", -- [1]
				"Burn, baby, burn!", -- [2]
				"Argh.. ich.. zu.. zu heiß innerlich!", -- [3]
				"Spiel niemals mit dem Feuer sagten sie damals.. Heute weiß ich es besser!", -- [4]
				"Zeit mich an dir abzukühlen, Sweetie!", -- [5]
				"Verflucht ich kann nicht anhalten!, die Hitze!, whaa!", -- [6]
				"Ich geb dir 3 Sekunden.. 1..2.. to late baby!", -- [7]
				"Ich bring jedes Eis zum schmelzen! Wer braucht also schon Frost?!", -- [8]
				"*Keusch* Krittische Überladung.. Tanze im Feuer!", -- [9]
				"Asche zu Asche..", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Kampfeshitze",
			},
		},
		["UNIT_SPELLCAST_SENTEISBLOCK"] = {
			["Messages"] = {
				"Ist es hier drin wirklich kalt, oder kommt die Kälte von mir?", -- [1]
				"Ich bin UNBESIEGBAR! Naja solange ihr mit Spitzhacken fort bleibt!", -- [2]
				"Ice, ice, baby!", -- [3]
				"Hier drin ist noch Platz für einen!", -- [4]
				"HILFE! holt mich hier raus!", -- [5]
				"Mist!, nicht schon wieder die Jägerfalle!", -- [6]
				"EISIG! Haltet schonmal die Handtücher bereit.", -- [7]
				"He, ich habe mich nur verklickt, ehrlich! *Hüstel*", -- [8]
				"Ich bin zäh wie ein Köter!, vielleicht klappts ja beim nächsten Mal!", -- [9]
				"*Seufzt* Seht mich an, Was tut man nicht alles um sein Leben zumindest einige Herzschläge zu verlängern..", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Eisblock",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_SHATTRATH"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Shattrath gehen wenn wir Shattrath zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Shattrath? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Shattrath gelangen, nicht in die Mitte des Ozeans, Shattrath.. Ozean.. Shattrath.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Beeindruckend, es gibt also tatsächlich noch Leute die hierhin wollen? Naja, wie auch immer.", -- [11]
				"Lasst besser die Hände an eurem Gepäck wenn ihr das untere Viertel kreuzt. Glaubt mir, ich spreche aus Erfahrung..", -- [12]
				"Alles klar, auf nach Shattrath.. Hm, wenn ihr dort seid sagt A'dal er hat nen' knall..", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Shattrath",
			},
		},
	},
	},
}, -- end Mage Template

-------------------------------------------------------------------------------
-- Template: Alliance Mage
-------------------------------------------------------------------------------

{
	name = "Mage Portals (Alliance)",
	desc = "Portal announcements for Alliance cities",
	Attributes = {
		class	= "MAGE",
		faction = "ALLIANCE",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTPORTAL:_EXODAR"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Exodar gehen wenn wir Exodar zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Exodar? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Exodar gelangen, nicht in die Mitte des Ozeans, Exodar.. Ozean.. Exodar.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. Oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Öffne ein Portal zur Exodar: Das beste Beispiel warum man nicht Auto-run aktiviert lassen sollte, während man auf dem Desktop ist!", -- [11]
				"Die Exodar also... Mit deutschen Ingenieuren an Bord wäre der Absturz nicht passiert!", -- [12]
				"Willkommen auf der Exodar, dem besten existierenden Grund warum man Zusatzversicherungen für Fahrzeuge abschließen sollte.", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Exodar",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_THERAMORE"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Theramore gehen wenn wir Theramore zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Theramore? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Theramore gelangen, nicht in die Mitte des Ozeans, Theramore.. Ozean.. Theramore.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. Oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss", -- [10]
				"Richtet Jaina Grüße von mir aus.. Ah, und sagt ihr bitte das ich behalte was ich neulich sah. Ich meine was sie da machte, diese Sache da mit Thrall. Ich behalte es für mich!", -- [11]
				"Weiß eigentlich inzwischen Jemand ob das Sumpfstädtchen immernoch als unabhängig gilt?", -- [12]
				"Sagt Jaina bitte das mit letzter Nacht tut mir leid.. Ich habe nicht gewollt das es so endet *seufzt*\".. Ich schätze den Tauren einzuladen war zuviel des Guten.", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Theramore",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_DARNASSUS"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Darnassus gehen wenn wir Darnassus zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Darnassus? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Darnassus gelangen, nicht in die Mitte des Ozeans, Darnassus.. Ozean.. Darnassus.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. Oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Fragt mich bloß nicht wie hoch die Kosten sind um ein solches nachtelfisches Haus im Winter zu beheizen!", -- [11]
				".. nach Darnassus also, doch vergesst nicht, dass die meisten Elfen auf gleichgeschlechtliche Liebe stehen. Also keine falschen Hoffnungen!", -- [12]
				"Nächster Halt: Darnassus, Heimat der Baumkuschler.", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Darnassus",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_STURMWIND"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Sturmwind gehen wenn wir Sturmwind zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Sturmwind? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Sturmwind gelangen, nicht in die Mitte des Ozeans, Sturmwind.. Ozean.. Sturmwind.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. Oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Nächster Halt: Sturmwind. Passt auf wo ihr hintretet und fallt nicht in die Kanäle, denn die Haie sind immer hungrig.", -- [11]
				"Warum eigentlich Sturmwind? Hier ist niemals irgendein Wind oder Sturm zu sehn!", -- [12]
				"Wer es schafft mir Bettsy die Puppe zu bringen bekommt von mir 5000 Gold!", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Sturmwind",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_EISENSCHMIEDE"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Eisenschmiede gehen wenn wir Eisenschmiede zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Eisenschmiede? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Eisenschmiede gelangen, nicht in die Mitte des Ozeans, Eisenschmiede.. Ozean.. Eisenschmiede.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. Oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Nächster Halt: Eisenschmiede. Heimat des Humpens und des Steins, das Reich in die Welt der Kleinen.", -- [11]
				"Hi ho, Hi ho, nach Ironforge weg go!", -- [12]
				"Ähm wenn ihr schonmal dort seid... wäre einer von euch so freundlich und könnte meine beschädigte Gürtelschnalle zu Granty dem Schmied bringen? Es gibt ihn wirklich!, Ehrenwort!", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Eisenschmiede",
			},
		},
	},
	},
}, -- end Alliance Mage Template

-------------------------------------------------------------------------------
-- Template: Horde Mage
-------------------------------------------------------------------------------

{
	name = "Mage Portals (Horde)",
	desc = "Portal announcements for Horde cities",
	Attributes = {
		class	= "MAGE",
		faction = "HORDE",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTPORTAL:_STEINARD"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Steinard gehen wenn wir Steinard zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Steinard? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Steinard gelangen, nicht in die Mitte des Ozeans, Steinard.. Ozean.. Steinard.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Öffne ein Portal nach Steinard. Ein guter Ort um Leichen zu verstecken, eh?! Vergiss was ich gesagt habe!", -- [11]
				"Steinard.. verdammt, STEINARD! Wer denkt sich eine solche Übersetzung aus?! Nun klingt es wie ein Konzentrationslager aus dem zweiten Weltkrieg..", -- [12]
				"Was zur Hölle wollt ihr in Steinard?!", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Steinard",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_ORGRIMMAR"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Orgrimmar gehen wenn wir Orgrimmar zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Orgrimmar? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Orgrimmar gelangen, nicht in die Mitte des Ozeans, Orgrimmar.. Ozean.. Orgrimmar.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. Oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Vielleicht möchtest du vorher dein Aftershave auftragen?.. Seit die Trolle hier sind liegen noch mehr Exkremente auf den Wegen..", -- [11]
				"Meidet es das Fleisch der Metzgerin Olvia, die mir beibrachte, dasses mehr als eine Art gibt die toten Körper der Feind zu entsorgen..", -- [12]
				"Wenn ihr wüsstest.. Was Nachts an den \"Freudenfeuern\" getrieben wird die überall' rumstehn..", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Orgrimmar",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_SILBERMOND"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Silbermond gehen wenn wir Silbermond zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Silbermond? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Silbermond gelangen, nicht in die Mitte des Ozeans, Silbermond.. Ozean.. Silbermond.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Nächster Halt: Silbermond, wo die Anzahl der Briefkästen die Elfenpopulation übersteigt.", -- [11]
				"Lasst besser die Finger von den fliegenden Besen.. Die Arkanwächter mögen es gar nicht wenn man versucht sie zu stehlen.. Ich spreche aus Erfahrung..", -- [12]
				"Silbermond also. Es ist schon beeindruckend, dass die Sin'dorei selbst mit einer halb besetzten Heimatstadt noch immer an ihrer Eitelkeit festhalten, meint ihr nicht?", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Silbermond",
			},
		},
		["UNIT_SPELLCAST_SENTVERWANDLUNG"] = {
			["Messages"] = {
				"Verwandle <ziel>. Ähm, das war doch richtig oder?", -- [1]
				"Achja übrigens, im Falle von Aoe-Schaden wird mein Sheep mit 30k Schaden explodieren.. Aber ihr braucht nicht vorsichtig zu sein..", -- [2]
				"<ziel> wird sicherlich ein nettes Haustier abgeben.. für 50 Sekunden.", -- [3]
				"Warum bei Sargaeras <ziel>?? Das andere Ziel wär viel einfacher zu verwandeln! Naja was solls..", -- [4]
				"Lasst die Griffel von <ziel>!", -- [5]
				"He du da! Schau mein Sheep nicht so an!, wenn du es raushaust wirst du das Nächste sein!", -- [6]
				"Das wäre dann Nummer 1567. Meine Güte ich hätte in die Schafzuchtbranche einsteigen sollen..", -- [7]
				"Tztz, und für sowas soll ich mein Mana verschwende, Ja?!", -- [8]
				"Da hat wohl jemand die Hosen voll, <ziel> macht auf mich nen' ungefährlichen Eindruck.. Naja zumindest solange ich es nicht tanken muss.", -- [9]
				"Gib es zu! Ich soll dieses blöde Schaf nur machen um keine Initialaggro zu ziehen!, Feigling!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Verwandlung",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_UNTERSTADT"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Unterstadt gehen wenn wir Unterstadt zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Unterstadt? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Unterstadt gelangen, nicht in die Mitte des Ozeans, Unterstadt.. Ozean.. Unterstadt.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. Oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Wonach stinkt es in Unterstadt deiner Meinung nach mehr? Nach Abwasser oder nach verrotendem Fleisch?", -- [11]
				"Ich habe schon immer gesagt das es ein Fehler ist sich mit den Apothekern zu verbrüdern, aber es hört ja Niemand auf mich!", -- [12]
				"Ich hörte das manche Besucher von Unterstadt einfach verschwinden... Immer schön auf der Hut bleiben.", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Unterstadt",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_DONNERFELS"] = {
			["Messages"] = {
				"Der Betreiber des Portals haftet hiermit nicht für.. Ähm \"verlorengegangene\" Ausrüstungs,- und Wertgegenstände.", -- [1]
				"Warum nach Donnerfels gehen wenn wir Donnerfels zu uns beschwören können? Klicke hier um die Stadt zu beschwören.", -- [2]
				"Donnerfels? Wirklich? Warum willst du ausgerechnet dorthin? Ganz ehrlich, weißt du eigentlich WER dort alles lebt??", -- [3]
				"*Murmelt* Sie wollen also nach Donnerfels gelangen, nicht in die Mitte des Ozeans, Donnerfels.. Ozean.. Donnerfels.. Ozean..", -- [4]
				"WARNUNG: Ich habe meine Portal-lizens im Auktionshaus ersteigert, Benutzung auf eigene Gefahr.", -- [5]
				"Nicht geplante Leylinienaktivierung erfolgreich!", -- [6]
				"Hier ist das Portal. Das macht dann bitte 2500 Gold. Hey, die Reagenzienen sind verdammt teuer!.. oh warte, hm, doch sind recht günstig, naja macht nix.", -- [7]
				"Jaja, dafür sind wir gut genug.. Kekse und Portale, unsere Zeit wird auch noch kommen! Und nun Abmarsch!", -- [8]
				"Was steht ihr so unnütz herum während ich euch wieder mit einem Portal bedienen darf?! Tanzt gefälligst, massiert mich oder macht euch sonst brauchbar!", -- [9]
				"..und denkt immer schön an den alten Hubert, der zu spät das Portal betrat und die Hälfte seiner Gliedmaßen zurückließ als es sich schloss.", -- [10]
				"Manchmal muss ich daran denken, wie gut man in Donnerfels ein Feuer legen könnte.. Eine Stadt nur bestehend aus Zelten und Einwohnern mit Fell.. Verlockend..", -- [11]
				"Ich rate euch, verbringt niemals die Nacht in einer der taurischen Tavernen, wenn nebenan ein taurisches Liebespaar übernachtet.. Es ähnelte dem Erdbeben, das damals unser Haus zerstörte.", -- [12]
				"Ich hörte von einigen besonderen Vorlieben des alten Cairne.. Fragt ihn besser niemals danach!", -- [13]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Donnerfels",
			},
		},
	},
	},
}, -- end Horde Mage Template

-------------------------------------------------------------------------------
-- Template: Priest (any race)
-------------------------------------------------------------------------------

{
	name = "Priest",
	desc = "Default sample speeches for Priests",
	Attributes = {
		class = "PRIEST",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTVERBLASSEN"] = {
			["Messages"] = {
				"Verschleiere.. unternehmt in der Zeit was!", -- [1]
				"Initialisiere Phasenverschiebung!", -- [2]
				"Ich könnte hier drüben Hilfe gebrauchen!", -- [3]
				"Lasst ab von mir!", -- [4]
				"Arhh, ich will nicht sterben!", -- [5]
				"Meine Zauber und Gebete erzeugen zuviel Bedrohung!", -- [6]
				"Haltet sie von mir fern!", -- [7]
				"Lange halte ich das nicht aus, helft mir!", -- [8]
				"Lenkt die Aufmerksamkeit auf euch, ich will nicht sterben!", -- [9]
				"Verblasse ins nirgendwo.. Und das nicht grundlos!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Verblassen",
			},
		},
		["UNIT_SPELLCAST_SENTVERZWEIFELTES_GEBET"] = {
			["Messages"] = {
				"Erhöre meine Gebete!, stärke meinen Willen!, gib mir Kraft!", -- [1]
				"Oh, du mein geliebtes Gestirn, stehe mir in dieser dunkelsten Stunde bei!", -- [2]
				"Pater noster, qui es in caelis; Sanctificetur nomen tuum; Adveniat regnum tuum; Fiat voluntas tua, sicut in caelo, et in terra.", -- [3]
				"Elune, Mondgöttin aller Geschöpfe, spende einem deiner Kinder in Not Kraft und deinen Segen!", -- [4]
				"Macht, die du über mich gebietest! Lass mich neue Kraft schöpfen und nicht wanken!", -- [5]
				"Patre et filio simul adoratur et conglorificatur qui locutus est per prophetas! Stehe mir bei!", -- [6]
				"Göttliche Macht, heile mein Fleisch und helfe mir deine Lehren weiterhin zu Leben!", -- [7]
				"Licht!, stärke meine Seele und mein geschunendes Fleisch!", -- [8]
				"Argh, ich bekomme hier zuviel ab, nutze verzweifeltes Gebet!", -- [9]
				"Helft mir! Sie reissen zu große Wunden in meinen Körper!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Verzweifeltes Gebet",
			},
		},
		["UNIT_SPELLCAST_SENTAUFERSTEHUNG"] = {
			["Messages"] = {
				"NEIN NEIN! noch nicht <ziel>! Ich lasse dich nicht gehen mein Freund!", -- [1]
				"Wende dich ab, verlasse den Lichterpfad <ziel>, komm zurück in die Welt der Lebenden!", -- [2]
				"Erhebe dich, <ziel>, atme den Hauch des Lebens, den ich dir als Teil meiner selbst schenke *flüstert*..", -- [3]
				"Gratia plena, Dominus tecum benedicta tu in mulieribus. Ergreife meine Hand, mein Innerstes ruft nach dir <ziel>..", -- [4]
				"Vergib mir, <ziel> *leise* Ich kann dich noch nicht ziehen lassen..", -- [5]
				"Et expecto resurrectionem mortuorium et vitam venturi saeculi.. <ziel>, deine Seele ist noch nicht fertig hier..", -- [6]
				"Noch ist nicht die rechte Zeit zu ruhen <Ziel>, wir brauchen dich doch hier.", -- [7]
				"Sei stark und finde den Weg zurück <ziel>, finde die Kraft in Denjenigen die dich lieben und brauchen.", -- [8]
				"Verzeih mir, dass ich das Recht nehme über deine Seele zu richten <ziel>, doch du musst umkehren..", -- [9]
				"Zuviele Dinge lässt du ungeklärt zurück <ziel>.. Ich als die Hand meines Gottes rufe dich zurück! Gehe noch nicht..", -- [10]
				"Mein priesterlicher Eid zwingt mich!.. Sieh es mir nach <ziel>! Richte nicht zu rasch, denn Zeit deiner Ruhe wird kommen..", -- [11]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Auferstehung",
			},
		},
	},
	},
}, -- end Priest Template

-------------------------------------------------------------------------------
-- Template: Warlock (any race)
-------------------------------------------------------------------------------

{
	name = "Warlock",
	desc = "Default sample speeches for Warlocks",
	Attributes = {
		class = "WARLOCK",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTRITUAL_DER_SEELEN"] = {
			["Messages"] = {
				"Grüne Schlemmsteine zu haben! Woraus sie bestehen?! Glaub mir Kindchen.. Das willst du nicht wissen..", -- [1]
				"Mmm Lutschbonbons, zäh und schleimig, so wie ich sie liebe! Was schaut ihr mich denn immer so schräg an?!", -- [2]
				"Los, herkommen und bedienen! Diese bleiben auch nicht so lange in den Zähnen kleben wie die letzten, ehrlich!", -- [3]
				"Was glaubt ihr eigentlich wie schwer das ist jedes mal diesen verfluchten Brunnen aus dem Nether zu beschwören? Der wiegt mindestens 100 Kilo!", -- [4]
				"Probiert meine neuen Lutschbonbons, nur 2 Gramm fett!", -- [5]
				"*Murmelt verstohlen* Hey <begleiter> du weißt ja wies läuft.. Nachdem sie alle durch die Gesundheitssteine gelähmt sind, musst du ihnen das Gold aus den Taschen räumen..", -- [6]
				"Hach, sieh doch <begleiter>! Wie sie sich alle schubsen, drängen und um die Wette \"quieken\". Der Anblick lohnt sich jedes mal!", -- [7]
				"Achtung, Achtung! Gesundheitsbrunnen abgesetzt, der Kampf um die Steinchen kann nun beginnen!", -- [8]
				"Los, Pfoten in den Brunnen und Stein herausnehmen oder ich befehle <begleiter> für die nächste Stunde zu singen!", -- [9]
				"Ach wie gut das Jeder weiß, dass ich Gesundheitssteine' scheiß! Von wegen.. Wer sich nun nicht am Brunnen bedient hat Pech gehabt!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Party"] = "SAY",
				["BG"] = "SAY",
				["Solo"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Ritual Der Seelen",
			},
		},
		["UNIT_SPELLCAST_SENTRITUAL_DER_BESCHWÖRUNG"] = {
			["Messages"] = {
				"Beschwöre <ziel> wegen einem tragischen Fall von chronischer Faulheit! Bitte einmal klicken!", -- [1]
				"Wenn ihr mir endlich mit dem Portal helft wird bald darauf <ziel> kommen um eine Woche lang euer bedingungsloser Sklave zu sein.", -- [2]
				"*Murmelt* Hm, war das nun das Portal für Gefährten, oder doch das Tor der Höllenbestien?..", -- [3]
				"Komm her <begleiter>!, JETZT BEWEG DICH ENDLICH <begleiter> UND HELF MIR MIT DEM PORTAL! Es ist jedes mal das Gleiche..", -- [4]
				"Seht mich nicht immer so misstrauisch an! Ich versichere euch, diesmal wird wirklich kein Level 95 Elitedämon herauskommen!", -- [5]
				"Das wäre dann Nummer 2598.. Ich wäre besser in die Reisebranche eingestiegen..", -- [6]
				"Warum zum Henker <ziel>?.. Hinterher muss ich wegen seinen schmutzigen Stiefel jedesmal den Portalboden schrubben!", -- [7]
				"Nutze die schwarze Magie haben sie gesagt.. Labe dich an der Macht haben sie gesagt.. Und nun stehe ich hier und darf <ziel> beschwören.", -- [8]
				"Abstimmung! Soll ich das Portal schließen nachdem <ziel> eingetreten ist? Es sind schon so manche auf dem Weg durch den Nether verloren gegangen..", -- [9]
				"Ich bin nicht das Beschwörungsdienstmädchen für <ziel> oder Irgendjemanden sonst! Wenn das so weitergeht kündige ich!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Ritual Der Beschwörung",
			},
		},
		["UNIT_SPELLCAST_SENTSEELENSTEINAUFERSTEHUNG"] = {
			["Messages"] = {
				"Falls wir alle in heillosem Gemetzel den Tod finden.. <ziel> hat ein Seelenstein.", -- [1]
				"<ziel> ist nun stoned... Hm, hoffentlich nutzt er uns so noch etwas.", -- [2]
				"<ziel's> Seele ist nun an den Stein gebunden. Ich frage mich was passiert wenn wir den Stein zersplittern würden..", -- [3]
				"*Flüstert* Ich liebe es mich an fremden Seelen zu bedienen..", -- [4]
				"Wow, wenn ihr sehen würdet was für Gedanken und Gefühle in <ziel>`s Seele ruhen..", -- [5]
				"Hey <ziel>, deine Seele ist nun gesichert.. Aber ich finde die Anderen haben das Recht zu wissen, dass du ihnen bei nächster Gelegenheit gern nen' Dolch in den Rücken rammen würdest.", -- [6]
				"Seele von <ziel> gesichert. Viel Unschuld war dort jedoch nicht mehr zu finden..", -- [7]
				"Hmm, du hast so eine zarte Seele <ziel>. Was hätte ich sie nur gern an mich genommen statt sie in den Stein zu sichern..", -- [8]
				"Du brauchst die Seele nicht zufällig zurück <ziel>? Meine Dämonen müssen bald gefüttert werden..", -- [9]
				"Ich glaube du wärst bei uns gut aufgehoben <ziel>.. Deine Seele sagt mir das du eine Affinität zu schwarzer Magie besitzt.", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Seelensteinauferstehung",
			},
		},
	},
	},
}, -- end Warlock Template

-------------------------------------------------------------------------------
-- Template: Rogue
-------------------------------------------------------------------------------

{
	name = "Rogue",
	desc = "Default sample speeches for rogues",
	Attributes = {
		class = "ROGUE",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTTRITT"] = {
			["Messages"] = {
				"Autsch, der Tritt hat gesessen!", -- [1]
				"Argh! Warum zur Hölle dort ein Trittschutz <ziel>?", -- [2]
				"Verfluchte Scheisse! Ich brech mir bei den Tritten irgendwann den Fuß!", -- [3]
				"Hah, der Tritt war saftig, was <ziel>?", -- [4]
				"Ich liebe es im Kampf zu treten!", -- [5]
				"..und zack! Der Tritt hat gesessen!", -- [6]
				"Der Tritt wird ne Hübsche Verstauchung bescheren!", -- [7]
				"Warum nur mit Klingen kämpfen, wenns auch leichter geht? Tritt getroffen!", -- [8]
				"Ähm, der Tritt hat zwar gesessen, aber obs am Hintern von <ziel> so effektiv ist, ist ne' andre Frage.", -- [9]
				"Tritt raus!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Tritt",
			},
		},
		["UNIT_SPELLCAST_SENTVERSCHWINDEN"] = {
			["Messages"] = {
				"Und zisch und Klack und Weg! Wo ist er nur hin?.. Und wo ist das Bier?", -- [1]
				"Wo war ich?.. Ah ja..", -- [2]
				"Den letzten beissen die Hunde!", -- [3]
				"Sorry, dringende Geschäfte warten!", -- [4]
				"Von nun an müsst ihr ohne mich klarkommen, oder eben sterben. He, nicht traurig sein, Life is a bitch!", -- [5]
				"Hm, es sieht brenzlig aus.. Nein das ist nichts für mich..", -- [6]
				"Sorry Jungs, von nun an heißts Jeder für sich!", -- [7]
				"Viel Spaß beim whipen! Ich verdrück mich.", -- [8]
				"Repkosten? Hm da muss ich im Fremdwörterbuch nachschlagen, mom..", -- [9]
				"Vielleicht sehen wir uns beim sonnen in Mulgore wieder.", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Verschwinden",
			},
		},
		["UNIT_SPELLCAST_SENTADRENALINRAUSCH"] = {
			["Messages"] = {
				"JAHHH guter Stoff!", -- [1]
				"Ehre?! Was soll das sein? Ist das ein vorteilhafter Kampftrick?", -- [2]
				"Jetzt reichts!", -- [3]
				"Nun hast du die Grenze überschritten <ziel>!", -- [4]
				"Halts Maul und reiz mich nicht!", -- [5]
				"Zeit für einen kleinen.. Klingentanz!", -- [6]
				"Ich.. kann mich nicht mehr.. kontrollieren..", -- [7]
				"Spüre meine Kaltblütigkeit <ziel>!", -- [8]
				"Zu.. viel.. Zuviel Adrenalin!!", -- [9]
				"Niemals die Deckung sinken lassen..NIEMALS!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Adrenalinrausch",
			},
		},
	},
	},
}, -- end Rogue Template

-------------------------------------------------------------------------------
-- Template: Druid (any race)
-------------------------------------------------------------------------------

{
	name = "Druid",
	desc = "Default sample speeches for Druids",
	Attributes = {
		class = "DRUID",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTWIEDERBELEBUNG"] = {
			["Messages"] = {
				"NEIN NEIN! noch nicht <ziel>! Ich lasse dich nicht gehen mein Freund!", -- [1]
				"Wende dich ab, verlasse den Lichterpfad <ziel>, komm zurück in die Welt der Lebenden!", -- [2]
				"Erhebe dich, <ziel>, atme den Hauch des Lebens, den ich dir als Teil meiner selbst schenke *flüstert*..", -- [3]
				"Gratia plena, Dominus tecum benedicta tu in mulieribus.. Ergreife meine Hand, mein Innerstes ruft nach dir <ziel>..", -- [4]
				"Vergib mir, <ziel> *leise* ich kann dich noch nicht ziehen lassen..", -- [5]
				"Et expecto resurrectionem mortuorium et vitam venturi saeculi.. <ziel>, deine Seele ist noch nicht fertig hier.", -- [6]
				"Noch ist nicht die rechte Zeit zu ruhen <Ziel>, wir brauchen dich doch hier.", -- [7]
				"Sei stark und finde den Weg zurück <ziel>, finde die Kraft in Denjenigen die dich lieben und brauchen!", -- [8]
				"Verzeih mir, dass ich das Recht nehme über deine Seele zu richten <ziel>, doch du musst nun umkehren..", -- [9]
				"Zuviele Dinge lässt du ungeklärt zurück <ziel>.. Ich als die Hand meines Gottes rufe dich zurück! Gehe noch nicht..", -- [10]
				"Geliebte Natur! opfere durch mich einen Teil deiner selbst.. Atme und lebe <ziel> .. Ich trage die Schuld und zahle mit Jahren. ", -- [11]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Wiederbelebung",
			},
		},
		["UNIT_SPELLCAST_SENTBERSERKER"] = {
			["Messages"] = {
				"'s Fell beginnt sich vor Zorn gefährlich aufzurichten wobei sich die Ohren kampfbereit anlegen.", -- [1]
				"scheint in einen tierhaften Blutrausch zu verfallen, wobei die Augen <ziel> voller Aggressivität und Wut entgegenblitzen.", -- [2]
				"beginnt wie besessen mit den scharfen Krallen auf die Kreaturen vor sich einzudreschen.", -- [3]
				"stößt ein wütendes Brllen aus um dann halb aufgerichtet, voller Zorn, auf <ziel> loszugehen.", -- [4]
				"fletscht bedrohlich die Zähne und schnappt vor Wut geräuschvoll in die Luft", -- [5]
				"beginnt vor Wut und Aufregung zu hecheln, wobei Blut und Fleischstückchen des Feindes aus <spieler's> Maul brökeln.", -- [6]
				"schnappt feste mit dem Maul zu und verkeilt den Biss wie verrückt in <ziel>`s Leib.", -- [7]
				"`s Nackenfell fängt an sich agressiv zu sträuben.", -- [8]
				"beisst immer wieder zu und beginnt wie besessen den Kopf herumzureissen, um dadurch brutalst Brocken von <ziel's> Fleisch herauszuzerren.", -- [9]
				"fängt förmlich an ohne Gnade einen Hagel aus scharfen Tatzenhieben auf <ziel> und die Kreaturen in seiner Umgebung niedergehen zu lassen.", -- [10]
			},
			["Channels"] = {
				["Raid"] = "EMOTE",
				["Solo"] = "EMOTE",
				["Party"] = "EMOTE",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Berserker",
			},
		},
		["UNIT_SPELLCAST_SENTWIEDERGEBURT"] = {
			["Messages"] = {
				"NEIN NEIN! noch nicht <ziel>! Ich lasse dich nicht gehen mein Freund!", -- [1]
				"Wende dich ab, verlasse den Lichterpfad <ziel>, komm zurück in die Welt der Lebenden!", -- [2]
				"Erhebe dich, <ziel>, atme den Hauch des Lebens, den ich dir als Teil meiner selbst schenke *flüstert*..", -- [3]
				"Gratia plena, Dominus tecum benedicta tu in mulieribus.. Ergreife meine Hand, mein Innerstes ruft nach dir <ziel>..", -- [4]
				"Vergib mir, <ziel> *leise* ich kann dich noch nicht ziehen lassen..", -- [5]
				"Et expecto resurrectionem mortuorium et vitam venturi saeculi.. <ziel>, deine Seele ist noch nicht fertig hier.", -- [6]
				"Noch ist nicht die rechte Zeit zu ruhen <Ziel>, wir brauchen dich doch hier.", -- [7]
				"Sei stark und finde den Weg zurück <ziel>, finde die Kraft in Denjenigen die dich lieben und brauchen!", -- [8]
				"Verzeih mir, dass ich das Recht nehme über deine Seele zu richten <ziel>, doch du musst nun umkehren..", -- [9]
				"Zuviele Dinge lässt du ungeklärt zurück <ziel>.. Ich als die Hand meines Gottes rufe dich zurück! Gehe noch nicht..", -- [10]
				"Geliebte Natur! opfere durch mich einen Teil deiner selbst.. Atme und lebe <ziel> .. Ich trage die Schuld und zahle mit Jahren. ", -- [11]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Wiedergeburt",
			},
		},
		["UNIT_SPELLCAST_SENTNATURGEWALT"] = {
			["Messages"] = {
				"Brennholz gefällig?!", -- [1]
				"Darf ich euch meine drei Freunde vorstellen? Joachim, Peter und Annette. Was? Fantasygame?! Das sind wohl Fantasynamen!!!", -- [2]
				"Ich habe die halbe Nacht mit schnitzen verbracht, es hat sich wohl gelohnt!", -- [3]
				"Schonmal versucht mit solchen Moonkinhänden zu schnitzen? Ich kann euch sagen... Einfach ist es nicht..", -- [4]
				"Warum ich ein Geweih habe, obwohl ich von Eulen abstamme?.. Ähm, das... ist eines unserer tieferen Geheinisse!", -- [5]
				"Na, wer ist nun in der Übermacht?!", -- [6]
				"... und du da fängst etwas Wild, du da entzündest ein Feuer und du da hinten dienst dafür als Brennholz.. Hey ich hab schließlich Hunger!", -- [7]
				"Hey Natur, weißt du noch als ich die leere Flasche vom Waldboden aufgehoben hab vor 3 jahren? Nun brauch ich den Gefallen zurück! Schick mir Bäume!", -- [8]
				"Na los ihr drei, verprügelt <ziel>!", -- [9]
				"Masse statt Klasse! Auf <ziel> meine Bäume!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Naturgewalt",
			},
		},
		["UNIT_SPELLCAST_SENTANREGEN"] = {
			["Messages"] = {
				"<ziel> hat's wohl nötig, wirke Anregen!..", -- [1]
				"Hrhr, ich stehe darauf dich anzuregen <ziel>.. Wie siehts aus, hättest du nachher noch Zeit?..", -- [2]
				"Na, hat da Jemand vergessen die Manahaushaltshausaufgaben zu machen <ziel>?..", -- [3]
				"Whoa, alle Manabatterien auf voller Kraft <ziel>?", -- [4]
				"That's the Way aha aha, I like it! Rege <ziel> an!", -- [5]
				"<ziel> angeregt! Ähm, ich tue das nur weil ich es muss, ehrlich!..*hust*", -- [6]
				" *Murmelt* Ich sollte eine pauschale Summe für jedes Anregen erheben.. 5G, oder 10G, was meinst du <ziel>?", -- [7]
				"... und das wäre dann Nummer 1498 <ziel>. Hab viel Übung im Anregen!", -- [8]
				"Hey <ziel> schalt mal nen' Gang runter.. Bist ja fast schon ein Stammkunde fürs Anregen..", -- [9]
				"Achtung! Achtung, hier spricht die Küstenw.. ähh die Manawache! Verlangsamen sie ihr Tempo <ziel> und schalten sie den Motor ab!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Anregen",
			},
		},
	},
	},
}, -- end Druid Template

-------------------------------------------------------------------------------
-- Template: Death Knight
-------------------------------------------------------------------------------

{
	name = "Death Knight",
	desc = "Default sample speeches for Death Knights",
	Attributes = {
		class = "DEATHKNIGHT",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTTODESGRIFF"] = {
			["Messages"] = {
				"Na los, komm her zu mir <ziel>, unwürdige Kreatur!", -- [1]
				"Hups, das war zu nah.. Hey, geh weg von mir <ziel>! Halt! ARHH!", -- [2]
				"Schon als Kind liebte ich das Angeln in jeglicher Form. Ob es nun um Frauen oder Fische ging..", -- [3]
				"Moment mal.. Irgendwoher kenne ich das doch.. Star wars?!", -- [4]
				"Helft mir Mächte des Finstren! Bringt <ziel> zu mir!", -- [5]
				"Die Lauffaulheit ist schon schlimm dieser Tage.. He was guckt ihr mich an? <ziel> ist von alleine zufällig auf mich zugeflogen!", -- [6]
				"Lust mit mir und meiner Klinge zu kuscheln <ziel>?", -- [7]
				"Eins, zwei, drei, vier Eckstein alles muss versteckt sein! Hah, zu spät <ziel>!", -- [8]
				"Pah, wer will schon ewig Leben?! Komm her <ziel>!", -- [9]
				"Nun wirst du meine Wut, meinen Hass! Meinen ZORN kennenlernen <ziel>!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Todesgriff",
			},
		},
		["UNIT_SPELLCAST_SENTTOTENERWECKUNG"] = {
			["Messages"] = {
				" *Grinst düster* Seht nur wie es lebt..<ziel> es LEBT ERNEUT!!!", -- [1]
				"Erhebe dich aufs neue <ziel>!", -- [2]
				"Du hast mir noch einen Dienst zu erfüllen <ziel>..", -- [3]
				"Werde meine untote Marionette und folge meinem Willen <ziel>!", -- [4]
				"Es ist immer wieder ein Vergnügen zu sehen... Das der Tod erst der Anfang ist!", -- [5]
				"Was gibt es da so entsetzt zu starren?! Tote sind Waffen!.", -- [6]
				"Bei uns Todesrittern ist es wie bei euch Lebenden.. Die stärkeren Geschöpfe knechten die Schwächeren. Nicht wahr <ziel>?", -- [7]
				"Nein, für dich gibt es keine Erlösung <ziel>.", -- [8]
				"Sei bereit mir im Tod zu dienen <ziel>. Ich dulde keinen Widerspruch!", -- [9]
				"<ziel> deine Zeit ist gekommen! Diene mir jetzt!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Totenerweckung",
			},
		},
		["UNIT_SPELLCAST_SENTTODESSTREITROSS_VON_ACHERUS"] = {
			["Messages"] = {
				"Ich rufe dich, mein treuer Begleiter im Tod!", -- [1]
				"Für mich gibt es nur noch wenige Dinge denen ich vertraue.. Hier siehst du eines von Jenen.", -- [2]
				"Eiris sazun idisi sazun hera duoder!", -- [3]
				"Zeit zu gehn..", -- [4]
				"Ich werde zurückkommen, wenn die Zeit gekommen ist.", -- [5]
				"Mein Streitross allein, hat Dinge gesehen und erlebt.. Dinge die nicht einmal in deinen Alpträumen Gestalt annehmen könnten.", -- [6]
				"Es wird Zeit mein Ross! sin uuoz birenkit thu biguol en sinthgunt!", -- [7]
				"Mein Ross ernährt sich von lebendem Fleisch.. Kommt ihm besser nicht zu nahe.", -- [8]
				"Hübsch, nicht wahr?", -- [9]
				"Ich würde ja ein anderes Reittier knechten. Doch sobald sie den Tod an mir riechen versuchen sie alle voller Panik zu flüchten..", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Todesstreitross Von Acherus",
			},
		},
	},
	},
}, -- end Death Knight Template

-------------------------------------------------------------------------------
-- Template: Shaman (all races)
-------------------------------------------------------------------------------

{
	name = "Shaman",
	desc = "Default sample speeches for Shamans",
	Attributes = {
		class = "SHAMAN",
		selected = true,
	},
	Content = {
		EventTable = {
		["UNIT_SPELLCAST_SENTHELDENTUM"] = {
			["Messages"] = {
				"Lass knack'n!", -- [1]
				"Wirke Heldenturm! Schnallt euch an Jungs, jetzt gehts rund!", -- [2]
				"Ehre, wem Ehre gebührt! Zünde Heldentum!", -- [3]
				"Verflucht! Jetzt aber zackig! Wirke Heldentum!", -- [4]
				"Los! Gebt alles was ihr habt, vollen Stoff!", -- [5]
				"Zündet alles was ihr habt! Heldentum!", -- [6]
				"Zeit für Rock'n'Roll Baby!", -- [7]
				"Wollt ihr denn ewig Leben?!", -- [8]
				"Bleifuß! Strengt euch an Jungs! Heldentum draußen!", -- [9]
				"Jetzt beginnt der Tanz! 40 Sekunden Vollgas!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Heldentum",
			},
		},
		["UNIT_SPELLCAST_SENTREINKARNATION"] = {
			["Messages"] = {
				"NEIN! Noch bin ICH nicht Tod!", -- [1]
				"Was für Idioten, sie machen es sich zu einfach mit mir..", -- [2]
				"Pah! So schnell gebe ich nicht auf!", -- [3]
				"Tztz.. Sie dachten also wirklich, ich wäre so leicht kleinzukriegen..", -- [4]
				"Liegenbleiben ist für die Schwachen!", -- [5]
				"Steh auf, wenn du am Boden bist.. Hat eigentlich mal Jemand von euch die toten Hosenträger droppen sehn?", -- [6]
				"Nah.. Der Tod ist einfach nichts für mich..", -- [7]
				".. Zwar nicht mit Totstellen vergleichbar, aber dafür kann ich wenigstens rezen!", -- [8]
				"Noch nie ein Stehaufmännchen gesehn? Na dann wird es aber Zeit. Gestatten <spieler>.", -- [9]
				"Jedes mal wenn dieser verfluchte Text erscheint heißt das ich habe kurz zuvor Repkosten kassiert. Also geht mir nicht auf den Sack!", -- [10]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "PARTY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Reinkarnation",
			},
		},
		["UNIT_SPELLCAST_SENTGEIST_DER_AHNEN"] = {
			["Messages"] = {
				"NEIN NEIN! noch nicht <ziel>! Ich lasse dich nicht gehen mein Freund!", -- [1]
				"Wende dich ab, verlasse den Lichterpfad <ziel>, komm zurück in die Welt der Lebenden!", -- [2]
				"Erhebe dich, <ziel>, atme den Hauch des Lebens, den ich dir als Teil meiner selbst schenke *flüstert*..", -- [3]
				"Gratia plena, Dominus tecum benedicta tu in mulieribus *haucht* Ergreife meine Hand, mein Innerstes ruft nach dir <ziel>..", -- [4]
				"Vergib mir, <ziel> *leise* ich kann dich noch nicht ziehen lassen..", -- [5]
				"Et expecto resurrectionem mortuorium et vitam venturi saeculi.. <ziel>, deine Seele ist noch nicht fertig hier..", -- [6]
				"Noch ist nicht die rechte Zeit zu ruhen <Ziel>, wir brauchen dich doch hier.", -- [7]
				"Sei stark und finde den Weg zurück <ziel>, finde die Kraft in Denjenigen die dich lieben und brauchen.", -- [8]
				"Verzeih mir, dass ich das Recht nehme über deine Seele zu richten <ziel>, doch du musst umkehren..", -- [9]
				"Zuviele Dinge lässt du ungeklärt zurück <ziel>.. Ich als die Hand meines Gottes rufe dich zurück! Gehe noch nicht..", -- [10]
				"Die Geister... Sie sind gewillt dir eine weitere Chance zu geben.. Nutze die Chance nicht so tollkühn wie die Erste <ziel> flüstern sie..", -- [11]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Geist Der Ahnen",
			},
		},
	},
	},
}, -- end Shaman Template

-------------------------------------------------------------------------------
-- MOUNT MACROS
-------------------------------------------------------------------------------
--"/ss macro mount"
--"/ss macro mount swim"
--"/ss macro mount qiraj"
--"/ss macro mount flight"
--"/ss macro mount flight fast"
--"/ss macro mount flight 310"
--"/ss macro mount ground"
--"/ss macro mount ground fast"

{
	name = "Mounts and Pets",
	desc = [[Announcements for summoning mounts and vanity pets.
Your known summoning spells are mapped to variations of "/ss macro mount" events, in order to share speeches between similar categories of companions.]],
	Attributes = {
		selected = true,
	},
	Content = {
		EventTable = {
			-- NOTE: Template_BuildAuto_MountRedirects will setup redirects for mount "spells" to trigger these macros
			["MACROMACRO_MOUNT_OR_PET"] = {
				DetectedEvent = {
					type = "MACRO",
					name = "macro mount or pet",
				},
				Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
				Messages = {
					[[The instructions said "just add water" and... Whoa! a <spellname>!]],
					[[Hold on a sec, lemme get my <spellname> out of my bags... don't ask how I stuffed him in there; you don't want to know.]],
					[[I'll get a cute little <spellname>, and I will call him George, and I will hug him, and squeeze him, and love him forever!]],
					[[/e whistles for <player*his*her> <spellname>]],
					[[This is my <spellname>, I call him "Spot" ... it's a long story, about a blue dress and a girl named Monica]],
					[[OK <spellname>, I'll let you out to play, but no humping the tank's leg this time!]],
					[[Nobody expects the <spellname>!]],
					[[Nobody expects the Spanish Inquisition! Our primary weapon is Fear and Surprise! Our TWO primary weapons are Fear, Surprise, and <spellname>!]],
					[[Accio <spellname>!]],
					[[This is my pet <spellname>, I call him Indiana]],
					[[Go-Go Gadget <spellname>!]],
					[[<spellname><R> is a registered trademark of <randomfaction> Industries and their parent company, <randomfaction> Global Ltd., used under license by <player>.]],
				},
			}, --"/ss macro mount or pet"
			["MACROMACRO_PET"] = {
				DetectedEvent = {
					type = "MACRO",
					name = "macro pet",
				},
				Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
				Messages = {
					[[/ss macro mount or pet]], -- shared speeches
					[[My familiar? Oh you mean <spellname>?? Oh yeah, of course he's been here the whole time...]],
					[[This one time, I walked into a bar with a <spellname> on my shoulder...
The bartender said "Hey where'd you get that thing?"
The <spellname> said "<home>, they got 'em all over the place!!"
/e mutters "smart-ass <spellname>"]],
					[[Don't mind the <spellname>, it's not really a spy for the <randomfaction>, I swear!]],
					[[Watch out for the <spellname>, for it comes with sharp, pointy teeth!
/e makes Sharp Pointy Teeth gestures with <player*his*her> fingers]],
				},
			}, --"/ss macro mount"
			["MACROMACRO_MOUNT"] = {
				DetectedEvent = {
					type = "MACRO",
					name = "macro mount",
				},
				Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
				Messages = {
					[[/ss macro mount or pet]], -- shared speeches
					[[Hi-ho <spellname> - away!]],
					[[I like the fuel-efficiency of my <spellname>, but the emissions really stink, phew!
/e plugs <player*his*her> nose]],
					[[Yeah I'm still driving this old <spellname>, but when i get a little more gold, I'd like to upgrade to a hybrid vehicle, like maybe a Centaur or a Dragonkin]],
					[[This day we ride; Ride for wrath; ride for Ruin!!]],
					[[Quickly -- We must ride to the aid of the <randomfaction>!]],
					[[Ride! Ride for the glory of the <randomfaction>!]],
					[[Come <spellname>, we must flee from <subzone>, with haste!]],
					[[Bah, I can't stand to be in <subzone> anymore. Let's get out of here.]],
					[[Check out this leet <spellname> - booya! it was totally worth killing those 800 frogs in Darnassus to unlock the vendor who sells it, which I assure you is not easy to do as a <race>]],
					[[This <spellname> dropped for me off a Wolpertinger in Swamp of Sorrows... I swear it!]],
					[[Dude, where's my <spellname>? Oh... there it is... nvm]],
					[[Whoa <spellname>... easy boy...]],
					[[/e hops onto <player*his*her> <spellname>]],
					[[My <spellname> really hates it when I run up his nose like that, but Legolas made it look so cool...]],
					[[Does it always smell this bad in <subzone> or is that my <spellname>?]],
					[[Quickly <spellname>, we must make haste, for there is a One-Day-Only sale at Macy's!]],
					[[<spellname><TM> - the mount of choice for all the best <race> <class>s in <subzone>!]],
					[[Normally I spam a random macro when I mount up, but <spellname> is so lame, it just doesn't deserve one]],
				},
			}, --"/ss macro mount"
			["MACROMACRO_MOUNT_SWIM"] = {
				DetectedEvent = {
					type = "MACRO",
					name = "macro mount swim",
				},
				Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
				Messages = {
					[[/ss macro mount]], -- include generic speeches for other mounts
					[[Let's go for a swim, <spellname>]],
				},
			}, --"/ss macro mount swim"
			["MACROMACRO_MOUNT_QIRAJ"] = {
				DetectedEvent = {
					type = "MACRO",
					name = "macro mount qiraj",
				},
				Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
				Messages = {
					[[/ss macro mount]], -- include generic speeches for other mounts
					[[My <spellname> loves it here in <subzone>]],
					[[Do you think this <spellname> clashes with the color theme here in <subzone>?]],
				},
			}, --"/ss macro mount qiraj"
			["MACROMACRO_MOUNT_FLIGHT"] = {
				DetectedEvent = {
					type = "MACRO",
					name = "macro mount flight",
				},
				Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
				Messages = {
					[[/ss macro mount]], -- include generic speeches for other mounts
					[[Up, up and away!]],
					[[All aboard <spellname> airways!]],
				},
			}, --"/ss macro mount flight"
			["MACROMACRO_MOUNT_FLIGHT_FAST"] = {
				DetectedEvent = {
					type = "MACRO",
					name = "macro mount flight fast",
				},
				Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
				Messages = {
					[[/ss macro mount flight]], -- include generic speeches for other mounts
					[[Ohhh yeeeaah this <spellname> was totally worth the 5kg]],
				},
			}, --"/ss macro mount flight fast"
			["MACROMACRO_MOUNT_FLIGHT_310"] = {
				DetectedEvent = {
					type = "MACRO",
					name = "macro mount flight 310",
				},
				Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
				Messages = {
					[[/ss macro mount flight fast]], -- include generic speeches for other mounts
					[[I just saw a shooting star, I'm gonna go chase it on my <spellname>]],
					[[OK <spellname>, I had to go through some serious @$%&#% to get you, so you'd better fly REAL damn fast]],
					[[That's not just any <spellname>, mate, that's a Firebolt!]],
				},
			}, --"/ss macro mount flight 310"
			["MACROMACRO_MOUNT_GROUND"] = {
				DetectedEvent = {
					type = "MACRO",
					name = "macro mount ground",
				},
				Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
				Messages = {
					[[/ss macro mount]], -- include generic speeches for other mounts
					[[Oh my <spellname>? I call her "Pokey"]],
					[[What do you mean <spellname>s can't fly? I fly off cliffs on this one all the time...]],
				},
			}, --"/ss macro mount ground"
			["MACROMACRO_MOUNT_GROUND_FAST"] = {
				DetectedEvent = {
					type = "MACRO",
					name = "macro mount ground fast",
				},
				Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
				Messages = {
					[[/ss macro mount ground]], -- include generic speeches for other mounts
					[[I've heard this term "epic mount" but I don't see anything epic about a plain ol' <spellname>]],
				},
			}, --"/ss macro mount ground fast"
		},
	},
},

-------------------------------------------------------------------------------
} -- end DEFAULT_SPEECHES.Templates
