-- Author      : RisM
-- Create Date : 5/21/2009 11:46:36 PM

-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local DEFAULT_SPEECHES = AceLocale:NewLocale("SpeakinSpell_DEFAULT_SPEECHES", "koKR", false)
if not DEFAULT_SPEECHES then return end

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")

SpeakinSpell:PrintLoading("Locales/DefaultSpeeches-enUS.lua")

-------------------------------------------------------------------------------
-- ADVERTISEMENTS for /ss ad
-------------------------------------------------------------------------------

DEFAULT_SPEECHES.ADVERTISEMENTS = {
	[[SpeakinSpell은 여러분이 마법을 사용하거나 버프 및 디버프를 받았을 경우 외부에 자동으로 알릴 수 있는 애드온입니다.]]
}

-------------------------------------------------------------------------------
-- DEFAULT SETTINGS FOR NEW SPELLS
-------------------------------------------------------------------------------

DEFAULT_SPEECHES.NEWSPELL = {
	[1] = "[<시전자|나>]님께서 [<대상|자신>]에게 <마법링크>를 시전하셨습니다.",
	[2] = "나는 [<플레이어>] 입니다. [<시전자>]은/는 [<대상종족>] [<대상직업>] [<대상|나>]에게 [<마법이름>]을/를 시전하고있습니다.(<마법링크>) ,그리고 나는 내옆에 내 소환수, [<소환수>]이/가 있습니다.",
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
		["UNIT_SPELLCAST_SENT야수 부르기"] = {
			["Messages"] = {
				"Heeere fido! Here boy! Come!", -- [1]
				"Don't worry, he's friendly", -- [2]
				"OK my pet's out now, so either he'll tank for us, or randomly pull aggro from a dozen mobs, we'll see...", -- [3]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "야수 부르기",
			},
		},
		["UNIT_SPELLCAST_SENTBESTIAL_WRATH"] = {
			["Messages"] = {
				"YEARRGH! Feel the wrath of <pet>!", -- [1]
				"Sick 'em, <pet>!", -- [2]
				"<pet> kill! <pet> kill!", -- [3]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Bestial Wrath",
			},
		},
		["UNIT_SPELLCAST_SENTMISDIRECT"] = {
			["Messages"] = {
				"No, no, go for <target>, he's the one biting your ankles!", -- [1]
				"<target> insulted your mother, you gonna take that??", -- [2]
				"<target> did it!", -- [3]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Misdirect",
			},
		},
		["UNIT_SPELLCAST_SENT죽은척하기"] = {
			["Messages"] = {
				"I'm not quite dead yet", -- [1]
				"Look ma, no health bar!", -- [2]
				"Darn, I'm dead. No really!", -- [3]
				"Repair costs? What's that? I'm a hunter!", -- [4]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "죽은척하기",
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
		["UNIT_SPELLCAST_SENTCHARGE"] = {
			["Messages"] = {
				"CHARGE!!!", -- [1]
				"Vroom Vroom!", -- [2]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Charge",
			},
		},
		["UNIT_SPELLCAST_SENTSHIELD_WALL"] = {
			["Messages"] = {
				"raises a shield", -- [1]
				"hides behind a shield", -- [2]
				"cowers behind a shield", -- [3]
				"raises a shield and cries NOT IN THE FACE! NOT IN THE FACE!", -- [4]
			},
			["Channels"] = {
				["Raid"] = "EMOTE",
				["Solo"] = "EMOTE",
				["Party"] = "EMOTE",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Shield Wall",
			},
		},
		["UNIT_SPELLCAST_SENTDEMORALIZING_SHOUT"] = {
			["Messages"] = {
				"RAWR! You're sad now!", -- [1]
				"You're GF likes me better! Ha!", -- [2]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Demoralizing Shout",
			},
		},
		["UNIT_SPELLCAST_SENTTAUNT"] = {
			["Messages"] = {
				"Get out of my sight you english kenniggits, or I shall be forced to taunt you a second time!", -- [1]
				"Your mother was a hamster and your father smelt of elderberries!", -- [2]
				"You hit like a small child!", -- [3]
				"You hit like a girl!", -- [4]
				"The fight is over here, coward!", -- [5]
				"Ni! Ni!", -- [6]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Taunt",
			},
			["Cooldown"] = 60,
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
		["UNIT_SPELLCAST_SENTHAND_OF_SALVATION"] = {
			["Messages"] = {
				"rubs down <target> releasing some of the threat.", -- [1]
				"slaps <target> with the backhand of salvation.", -- [2]
			},
			["Channels"] = {
				["Raid"] = "EMOTE",
				["Solo"] = "EMOTE",
				["Party"] = "EMOTE",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Hand Of Salvation",
			},
			["WhisperTarget"] = true,
		},
		["UNIT_SPELLCAST_SENTDIVINE_PLEA"] = {
			["Messages"] = {
				"Please Light, Don't let me go OOM. If the tank dies again I'm getting gkicked.", -- [1]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Divine Plea",
			},
			["WhisperTarget"] = true,
		},
		["UNIT_SPELLCAST_SENTREDEMPTION"] = {
			["Messages"] = {
				"Rezzing <target>", -- [1]
				"<target>, don't go into the light, return to the land of the living!", -- [2]
				"Rise, <target>, and live again!", -- [3]
				"Get yer lazy bones up, <target>!", -- [4]
				"The hand of God reaches down and brings <target> back to life", -- [5]
				"Granddaddy always said laughter was the best medicine. I guess it wasn't strong enough to keep <target> alive.", -- [6]
				"Arise <target>, and fear death no more; or at least until the next pull.", -- [7]
				"Bring out your dead! *throws <target> on the cart*", -- [8]
				"<target>, quit hitting on the Spirit Healer and come kill something!", -- [9]
				"YAY! I always wanted my very own <target>-zombie!", -- [10]
				"It just so happens that <target> is only MOSTLY dead. There's a big difference between mostly dead and all dead. Mostly dead is slightly alive.", -- [11]
				"<target> has failed at life, I'm giving him a second chance. That's right, not God, ME!!", -- [12]
				"Cool, I received 42 silver, 32 copper from the Corpse of <target>", -- [13]
				"<target>, this better not be another attempt to get me to give you mouth-to-mouth.", -- [14]
				"<target>, it's more mana efficient just to resurrect you.  Haha, I'm just kidding!", -- [15]
				"Well, <target>, if you had higher faction with <player>, you might have gotten a heal. How do you raise it? 1g donation = 15 rep.", -- [16]
				"<target>, by accepting this resurrection you hereby accept that you must forfeit your immortal soul to <player>. Please click 'Accept' to continue.", -- [17]
				"Folks, what we have here is a prime example of why <target> shouldn't tank.", -- [18]
				"Don't rush me <target>. You rush a miracle worker, you get rotten miracles.", -- [19]
				"Death comes for you <target>! With large, pointy teeth!", -- [20]
				"Resurrecting <target>. Side effects may include: nausea, explosive bowels, a craving for brains, and erectile dysfunction. Resurrection is not for everyone. Please consult a healer before dying.", -- [21]
				"Dammit <target>, I'm a doctor! Not a priest! ... Wait a second ... nevermind. Ressing <target>", -- [22]
				"... death defying feats are clearly not your strong point, <target>", -- [23]
				"Giving <target> another chance to noob it up. ", -- [24]
				"Hey <target>, can you check to see if Elvis is really dead? ... and can he fill your spot in the party?", -- [25]
				"<target> I *warned* you, but did you listen to me? Oh, no, you *knew*, didn't you? Oh, it's just a harmless little *bunny*, isn't it?", -- [26]
				"Tsk tsk, <target>. See, I told you to sacrifice that virgin to the Volcano God.", -- [27]
				"You don't deserve a cute rez macro, <target>. You deserve to die. But you already did, so, um... yeah.", -- [28]
				"Sorry <target>, I couldn't heal you. I was too busy being the tank.", -- [29]
				"Did it hurt, <target>, when you fell from Heaven? Oh, wait. You're dead. I don't know where I was going with that. Nevermind.", -- [30]
			},
			["Channels"] = {
				["Party"] = "PARTY",
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["BG"] = "BATTLEGROUND",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Redemption",
			},
			["WhisperTarget"] = true,
		},
		["UNIT_SPELLCAST_SENTDIVINE_INTERVENTION"] = {
			["Messages"] = {
				"It's a wipe! <target> has a DI.", -- [1]
				"DI is short for DIE in a good place, somewhere <target> will be able to rez you.", -- [2]
				"I, I just died in your arms tonight. Must've been something I said...", -- [3]
			},
			["Channels"] = {
				["Party"] = "PARTY",
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["BG"] = "BATTLEGROUND",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Divine Intervention",
			},
			["WhisperTarget"] = true,
		},
		["UNIT_SPELLCAST_SENTLAY_ON_HANDS"] = {
			["Messages"] = {
				"I don't want anybody else, when I think about you, I touch your self", -- [1]
				"Don't ask me how I laid my hands on you from way over here, but I just did", -- [2]
				"OH SHlT, OH SHlT, OH SHlT... HA! Fooled ya! :P", -- [3]
			},
			["Channels"] = {
				["Raid"] = "SAY",
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Lay On Hands",
			},
			["WhisperTarget"] = true,
		},
		["UNIT_SPELLCAST_SENTEXORCISM"] = {
			["Messages"] = {
				"The power of CHRIST compels you!", -- [1]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Exorcism",
			},
			["WhisperTarget"] = true,
			["Cooldown"] = 120,
		},
		["UNIT_SPELLCAST_SENTDIVINE_FAVOR"] = {
			["Messages"] = {
				"Dear Lord, I need a favor", -- [1]
				"Dear Lord, remember that one time I went to church back in '83? I need you to return the favor", -- [2]
				"I pity the fool who don't respect the light!", -- [3]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Divine Favor",
			},
			["WhisperTarget"] = true,
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
		["UNIT_SPELLCAST_SENTRITUAL_OF_REFRESHMENTRANK_2"] = {
			["Messages"] = {
				"Ritual of Refreshment is being placed near <player> please click to assist", -- [1]
				"C1ick 4 t@b1e", -- [2]
				"Magic Biscuits, Brownies, and Goo-balls $5. CDs $10. T-shirts $15. Enjoy the concert!", -- [3]
				"<player's> Tasty Strudel<TM> - WARNING: may cause nauseu, loss of appetite, blindness, fear, stunlock, or spontaneous transmutation into a sheep, pig, or turtle. Consult your doctor before eating <player's> Tasty Strudel<TM>", -- [4]
				"<player's> Tasty Strudel<TM> - Now with 30% more Flavor Power!", -- [5]
				"<player's> Tasty Strudel<TM> - Try all new Organic <player's> Tasty Strudel<TM>! Now in Teriaki Tofu Flavor!", -- [6]
				"<player's> Tasty Strudel<TM> - It's Strudeltastic<TM>!!", -- [7]
				"<player's> Tasty Strudel<TM> - Now with +35 Stamina Buff!! (also-gives-minus-thirty-five-stamina-debuff-no-actual-buff-may-be-visible-consult-your-doctor-before-eating <player's> Tasty Strudel<TM>)", -- [8]
				"<player's> Tasty Strudel<TM> - The Official Cereal of Beauty and the Beast VII: Beauty in Azeroth (sings) Be... a... pest! Be a pest! Put my patience to the test! RENT IT TODAY!", -- [9]
				"SHOWTIME: the feed-trough has been planted! Go on my dear piggies, grab and grunt for the win!", -- [10]
			},
			["Channels"] = {
				["Party"] = "SAY",
				["Solo"] = "SAY",
				["Raid"] = "SAY",
				["BG"] = "SAY",
				["Arena"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Ritual of Refreshment",
				["rank"] = "Rank 2",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_IRONFORGE"] = {
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Ironforge when we can summon Ironforge to us? Click to summon the city.", -- [2]
				"Ironforge? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Ironforge, not the middle of the ocean, Ironforge...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"Next stop: Ironforge. Home to all things great and small.", -- [8]
				"Hi ho, Hi ho, it's off to Ironforge we go!", -- [9]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [10]
			},
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Ironforge",
			},
		},
		["UNIT_SPELLCAST_SENTINVISIBILITY"] = {
			["Messages"] = {
				"Now you see me, soon you won't", -- [1]
				"If you can't see me, you can't hit me", -- [2]
				"Repair costs? What's that? I'm a mage", -- [3]
				"I have but one spell remaining that I have prepared for the day... sorry", -- [4]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Invisibility",
			},
		},
		["UNIT_SPELLCAST_SENTRITUAL_OF_REFRESHMENTRANK_1"] = {
			["Messages"] = {
				"Ritual of Refreshment is being placed near <player> please click to assist", -- [1]
				"C1ick 4 t@b1e", -- [2]
				"Magic Biscuits, Brownies, and Goo-balls $5. CDs $10. T-shirts $15. Enjoy the concert!", -- [3]
				"<player's> Magical Biscuits<TM> - WARNING: may cause nauseu, loss of appetite, blindness, fear, stunlock, or spontaneous transmutation into a sheep, pig, or turtle. Consult your doctor before eating <player's> Magical Biscuits<TM>", -- [4]
				"<player's> Magical Biscuits<TM> - Now with 30% more Flavor Power!", -- [5]
				"<player's> Magical Biscuits<TM> - Try all new Organic <player's> Magical Biscuits<TM>! Now in Teriaki Tofu Flavor!", -- [6]
				"<player's> Magical Biscuits<TM> - It's Mannabiscuitalisious<TM>!!", -- [7]
				"<player's> Magical Biscuits<TM> - Now with +35 Stamina Buff!! (also-gives-minus-thirty-five-stamina-debuff-no-actual-buff-may-be-visible-consult-your-doctor-before-eating <player's> Magical Biscuits<TM>)", -- [8]
				"<player's> Magical Biscuits<TM> - The Official Cereal of Beauty and the Beast VII: Beauty in Azeroth (sings) Be... a... pest! Be a pest! Put my patience to the test! RENT IT TODAY!", -- [9]
				"SHOWTIME: the feed-trough has been planted! Go on my dear piggies, grab and grunt for the win!", -- [10]
			},
			["Channels"] = {
				["Party"] = "SAY",
				["Solo"] = "SAY",
				["Raid"] = "SAY",
				["BG"] = "SAY",
				["Arena"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Ritual of Refreshment",
				["rank"] = "Rank 1",
			},
		},
		["UNIT_SPELLCAST_SENTSUMMON_WATER_ELEMENTAL"] = {
			["Messages"] = {
				"Yes, I AM a God!", -- [1]
				"Let me introduce you to my little friend.", -- [2]
				"Water never tasted so good", -- [3]
				"Water: from the glass to the blast", -- [4]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Summon Water Elemental",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_DALARAN"] = {
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Dalaran when we can summon Dalaran to us? Click to summon the city.", -- [2]
				"Dalaran? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Dalaran, not the middle of the ocean, Dalaran...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"Dalaran: it's not just for mages anymore", -- [8]
				"WTS portal to Dalaran: 18,899g... yeah it's a little more expensive than usual, but c'mon, how else am I gonna buy that war mammoth?", -- [9]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [10]
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
		["UNIT_SPELLCAST_SENTPORTAL:_SHATTRATH"] = {
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Shattrath when we can summon Shattrath to us? Click to summon the city.", -- [2]
				"Shattrath? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Shattrath, not the middle of the ocean, Shattrath...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"So people still visit Shattrath, huh?", -- [8]
				"Oh Shatt, it's a portal", -- [9]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [10]
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
		["UNIT_SPELLCAST_SENTMIRROR_IMAGE"] = {
			["Messages"] = {
				"I'd like to introduce you to my cousin Darrel, and my other cousin Darrel, and my other cousin Darrel", -- [1]
				"In case of emergency, the mages are here, here, here, and here", -- [2]
				"I look pretty good if I do say so myself, and so do I, and so do I, and so do I", -- [3]
				"And so begin the clone wars", -- [4]
				"I'm the real <player>!  No I am!  No I'm the real <player>!  No, no, I'm the original <player>!", -- [5]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Mirror Image",
			},
		},
		["UNIT_SPELLCAST_SENTPOLYMORPH"] = {
			["Messages"] = {
				"Sheeping <target>", -- [1]
				"<player> is casting polymorph on <target>", -- [2]
				"<target> is getting in touch with his inner spirit animal", -- [3]
				"Bah, <target>", -- [4]
				"Admit it! You only want me to use Polymorph for pulling initial aggro.  Coward!", -- [5]
				"Oh sure, you can't kill <target> fast enough so it falls on me to bend the laws of nature to turn it into a nice docile sheep. Sure, fine, no problem.", -- [6]
				"Well that was sheep number 1567... I should have been a shepherd.", -- [7]
				"1567, 1568, 1569, are you getting sleepy yet after counting all these sheep?", -- [8]
			},
			["Channels"] = {
				["Party"] = "PARTY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Polymorph",
			},
		},
		["UNIT_SPELLCAST_SENTICE_BLOCK"] = {
			["Messages"] = {
				"Is it cold in here, or is it just me?", -- [1]
				"I am INVINCIBLE!", -- [2]
				"Ice, ice, baby!", -- [3]
				"Wonder Twin power activate! Form of an ice cube.", -- [4]
				"HELP! I got trapped in a walk-in freezer.", -- [5]
				"Oops, I think I stepped in the hunter's ice trap.", -- [6]
				"Brrrr!", -- [7]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Ice Block",
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
		["UNIT_SPELLCAST_SENTPORTAL:_DARNASSUS"] = {
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Darnassus when we can summon Darnassus to us? Click to summon the city.", -- [2]
				"Darnassus? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Darnassus, not the middle of the ocean, Darnassus...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"Next stop: Darnassus, where you can hear the crickets.", -- [8]
				"Opening a portal to Darnassususs.. Darnsusas... Darna... uhh... Opening a portal to Darn", -- [9]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [10]
				"Darn-your-asses, get your butt through the portal! Now!", -- [11]
				"... Heading to Darnassus to pick up girls, huh? Good luck with that", -- [12]
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Darnassus",
			},			
		},
		["UNIT_SPELLCAST_SENTPORTAL:_THERAMORE"] = {
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Theramore when we can summon Theramore to us? Click to summon the city.", -- [2]
				"Theramore? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Theramore, not the middle of the ocean, Theramore...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"Tell Jaina I said \"hi\"", -- [8]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [9]
				"Please tell Jaina I'm sorry about what happened last night... I didn't wanted it to end that way *sigh*... I guess inviting the Tauren to join us was a bad idea after all.", -- [10]
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Theramore",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_STORMWIND"] = {
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Stormwind when we can summon Stormwind to us? Click to summon the city.", -- [2]
				"Stormwind? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Stormwind, not the middle of the ocean, Stormwind...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"Next stop: Stormwind. Watch your step, don't fall into the canals. The sharks might get you.", -- [8]
				"Why is it called Stormwind when there's never a storm or any wind there?", -- [9]
				"Why would you want to go to Stormwind? Don't you see enough Humans in real life?", -- [10]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [11]
				"If you bring me Betsey's dollie, I will pay you one 5000g.", -- [12]
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Stormwind",
				
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_EXODAR"] = {
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Exodar when we can summon Exodar to us? Click to summon the city.", -- [2]
				"Exodar? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Exodar, not the middle of the ocean, Exodar...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"Entering this portal will take you to the ends of the earth... I mean Exodar.", -- [8]
				"Ah yes, the Exodar... How did they crash into a PLANET??  That's what I want to know", -- [9]
				"Opening a portal to the Exodar: the crashed spaceship that is the perfect example of why NOT to alt-tab while on auto-run", -- [10]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [11]
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Exodar",
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
		["UNIT_SPELLCAST_SENTPORTAL:_STONARD"] = {
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Ironforge when we can summon Ironforge to us? Click to summon the city.", -- [2]
				"Ironforge? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Ironforge, not the middle of the ocean, Ironforge...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"Opening a portal to Stonard. Grab me a phat herb bag full of merry mana pot while you're there, eh?", -- [8]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [9]
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Stonard",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_THUNDER_BLUFF"] = {
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Ironforge when we can summon Ironforge to us? Click to summon the city.", -- [2]
				"Ironforge? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Ironforge, not the middle of the ocean, Ironforge...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"Now entering Thunder Bluff, where no one can hear you scream, probably because there's nobody else there", -- [8]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [9]
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Thunder Bluff",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_UNDERCITY"] = {
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Undercity when we can summon Undercity to us? Click to summon the city.", -- [2]
				"Undercity? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Undercity, not the middle of the ocean, Undercity...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"Opening a portal to Sewerville", -- [8]
				"Which part of Undercity do you think smells better?  The sewage or the rotting flesh?", -- [9]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [10]
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Undercity",
			},
		},
		["UNIT_SPELLCAST_SENTPORTAL:_SILVERMOON"] = {
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Silvermoon when we can summon Silvermoon to us? Click to summon the city.", -- [2]
				"Silvermoon? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Silvermoon, not the middle of the ocean, Silvermoon...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"Next stop: Silvermoon, where mailboxes outnumber even the blood elves", -- [8]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [9]
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Silvermoon",
			},			
		},
		["UNIT_SPELLCAST_SENTPORTAL:_ORGRIMMAR"] = {
			["Channels"] = {
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["Party"] = "PARTY",
			},
			["Messages"] = {
				"Entering this portal will take you to a far away city.", -- [1]
				"Why go to Orgrimmar when we can summon Orgrimmar to us? Click to summon the city.", -- [2]
				"Orgrimmar? Really? Why would you want to go there? Honestly, do you know who LIVES there??", -- [3]
				"Focus <player>, they want to go to Orgrimmar, not the middle of the ocean, Orgrimmar...", -- [4]
				"DISCLAIMER: I got my portal license off the AH. Use at your own risk.", -- [5]
				"... Chevron six encoded... Chevron seven LOCKED!", -- [6]
				"Here's your portal. That'll be 2500g please. Hey the reagent isn't cheap... oh wait, yes it is, nevermind.", -- [7]
				"WARNING: you might want to plug your nose before entering this portal. It smells like Orc where you're going.", -- [8]
				"Hurry up and go through the portal. The last person who waited too long lost his arm as it closed.", -- [9]
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Portal: Orgrimmar",
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
		["UNIT_SPELLCAST_SENTRESURRECTION"] = {
			["Messages"] = {
				"Rezzing <target>", -- [1]
				"<target>, don't go into the light, return to the land of the living!", -- [2]
				"Rise, <target>, and live again!", -- [3]
				"Get yer lazy bones up, <target>!", -- [4]
				"The hand of God reaches down and brings <target> back to life", -- [5]
				"Granddaddy always said laughter was the best medicine. I guess it wasn't strong enough to keep <target> alive.", -- [6]
				"Arise <target>, and fear death no more; or at least until the next pull.", -- [7]
				"Bring out your dead! *throws <target> on the cart*", -- [8]
				"<target>, quit hitting on the Spirit Healer and come kill something!", -- [9]
				"YAY! I always wanted my very own <target>-zombie!", -- [10]
				"It just so happens that <target> is only MOSTLY dead. There's a big difference between mostly dead and all dead. Mostly dead is slightly alive.", -- [11]
				"<target> has failed at life, I'm giving him a second chance. That's right, not God, ME!!", -- [12]
				"Cool, I received 42 silver, 32 copper from the Corpse of <target>", -- [13]
				"<target>, this better not be another attempt to get me to give you mouth-to-mouth.", -- [14]
				"<target>, it's more mana efficient just to resurrect you.  Haha, I'm just kidding!", -- [15]
				"Well, <target>, if you had higher faction with <player>, you might have gotten a heal. How do you raise it? 1g donation = 15 rep.", -- [16]
				"<target>, by accepting this resurrection you hereby accept that you must forfeit your immortal soul to <player>. Please click 'Accept' to continue.", -- [17]
				"Folks, what we have here is a prime example of why <target> shouldn't tank.", -- [18]
				"Don't rush me <target>. You rush a miracle worker, you get rotten miracles.", -- [19]
				"Death comes for you <target>! With large, pointy teeth!", -- [20]
				"Resurrecting <target>. Side effects may include: nausea, explosive bowels, a craving for brains, and erectile dysfunction. Resurrection is not for everyone. Please consult a healer before dying.", -- [21]
				"Dammit <target>, I'm a doctor! Not a priest! ... Wait a second ... nevermind. Ressing <target>", -- [22]
				"... death defying feats are clearly not your strong point, <target>", -- [23]
				"Giving <target> another chance to noob it up. ", -- [24]
				"Hey <target>, can you check to see if Elvis is really dead? ... and can he fill your spot in the party?", -- [25]
				"<target> I *warned* you, but did you listen to me? Oh, no, you *knew*, didn't you? Oh, it's just a harmless little *bunny*, isn't it?", -- [26]
				"Tsk tsk, <target>. See, I told you to sacrifice that virgin to the Volcano God.", -- [27]
				"You don't deserve a cute rez macro, <target>. You deserve to die. But you already did, so, um... yeah.", -- [28]
				"Sorry <target>, I couldn't heal you. I was too busy being the tank.", -- [29]
				"Did it hurt, <target>, when you fell from Heaven? Oh, wait. You're dead. I don't know where I was going with that. Nevermind.", -- [30]
			},
			["Channels"] = {
				["Party"] = "PARTY",
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["BG"] = "BATTLEGROUND",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Resurrection",
			},
		},
		["UNIT_SPELLCAST_SENTDESPERATE_PRAYER"] = {
			["Messages"] = {
				"Help me, Lord!", -- [1]
				"Dear Lord, I promise to be a better priest if you help <target> live another day.", -- [2]
				"Pater noster, qui es in caelis; Sanctificetur nomen tuum; Adveniat regnum tuum; Fiat voluntas tua, sicut in caelo, et in terra.", -- [3]
			},
			["Channels"] = {
				["Party"] = "PARTY",
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["BG"] = "BATTLEGROUND",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Desperate Prayer",
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
		["UNIT_SPELLCAST_SENTSOULSTONE_RESURRECTION"] = {
			["Messages"] = {
				"It's OK if we all die.  <target> has a soul stone", -- [1]
				"<target> is stoned... whoa, heavy", -- [2]
				"If you cherish the idea of a mass suicide, <target> can now self-resurrect, so all should be fine. Go ahead.", -- [3]
				"<target> can go afk to drink a cup of coffee or something, soulstone is in place to allow for the wipe...", -- [4]
				"<target> is soulstoned... full of confidence tonight aren't we?!", -- [5]
			},
			["Channels"] = {
				["Party"] = "PARTY",
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["BG"] = "BATTLEGROUND",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Soulstone Resurrection",
			},
			["WhisperTarget"] = true,
		},
		["UNIT_SPELLCAST_SENTRITUAL_OF_SUMMONING"] = {
			["Messages"] = {
				"Summoning <target> The Lazy, click to assist please", -- [1]
				"If you click on the portal, someone named <target> will show up and do your job for you.", -- [2]
				"Unscheduled off-world activation!", -- [3]
				"Step on board the Arcanum Taxi Cab! I am summoning <target>, please click on the portal.", -- [4]
				"Welcome aboard, <target>, you are flying on the ~Succubus Air Lines~ to <player>...", -- [5]
				"If you do not want a sprawling, phlegm-looking, asthmatic creature to come from this portal, click on it to help <target> find a path through Hell as quickly as possible!", -- [6]
				"Conjuring an Arcane Taxi Cab for <target>, please click the portal for the slacker please.", -- [7]
			},
			["Channels"] = {
				["Party"] = "PARTY",
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["BG"] = "BATTLEGROUND",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Ritual Of Summoning",
			},
			["WhisperTarget"] = true,
		},
		["UNIT_SPELLCAST_SENTRITUAL_OF_SOULS"] = {
			["Messages"] = {
				"Lock Candy! Get your lock candy here!", -- [1]
				"Mmmm cookies...", -- [2]
				"The green portal is better than the white one, click mine first!", -- [3]
				"Click for hearthstones... oh no no not the ones that send you home, i mean the ones that give you health... stupid typo", -- [4]
			},
			["Channels"] = {
				["Party"] = "PARTY",
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["BG"] = "BATTLEGROUND",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Ritual Of Souls",
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
		["SPELL_AURA_APPLIED_BUFF_FOREIGN정령의_서약"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "정령의 서약",
			},
			["Messages"] = {
				"[<시전자>]님께서 <마법링크>을 주셨어여~~난 계약서 싫은디 ㅋㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Solo"] = "YELL",
				["Party"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN상급_성역의_축복"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "상급 성역의 축복",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~피해가 줄어들거에요~~우왕굳~~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "SAY",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN대지의_보호막"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "대지의 보호막",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~대지의 힘이여 무한하라~~~ㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Solo"] = "YELL",
				["Party"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN선견의_부적"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "선견의 부적",
			},
			["Messages"] = {
				"[<시전자>]님께서 <마법링크>을 주셨어여~~~장신구 죽이는구나!~~~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF낙하산"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF",
				["name"] = "낙하산",
			},
			["Messages"] = {
				"<마법링크>이 펴졌구나~~~경치구경이나 할까~~~ㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "SAY",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT돌연변이_물고기_별미"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "돌연변이 물고기 별미",
			},
			["Messages"] = {
				"<마법링크>를 먹고선..", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN상급_왕의_축복"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "상급 왕의 축복",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~나는 왕이로소이다~~~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "SAY",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN피어나는_생명"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "피어나는 생명",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~생명이 모락모락~~~", -- [1]
			},
			["Channels"] = {
				["Solo"] = "YELL",
				["Party"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT암색_비취_광선"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "암색 비취 광선",
			},
			["Messages"] = {
				"[<대상>]! 받아라!~ <마법링크>!", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN신비한_지능"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "신비한 지능",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>를 주셨어여~ 머리가 좋아졌어여!~", -- [1]
			},
			["Channels"] = {
				["Raid"] = "EMOTE",
				["Solo"] = "YELL",
				["Party"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_DEBUFF_FOREIGN슬픔의_충격"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_DEBUFF_FOREIGN",
				["name"] = "슬픔의 충격",
			},
			["Messages"] = {
				"저런 빌어먹을 [<시전자|나>]뇬 같으니 <마법링크>를 써 썩을뇬아~~~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_DEBUFF_FOREIGN압착"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_DEBUFF_FOREIGN",
				["name"] = "압착",
			},
			["Messages"] = {
				"<마법링크>당했어여!~ 풀어주세영 된장..ㅠ.ㅠ", -- [1]
			},
			["Channels"] = {
				["Party"] = "SAY",
				["Solo"] = "SAY",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT혼란"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "혼란",
			},
			["Messages"] = {
				"<마법링크>이다!~ 어딜도망갈라고!~ ㅋㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT2특성_활성화"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "2특성 활성화",
			},
			["Messages"] = {
				"암살(PK)도적으로 변신!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN지휘의_외침"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "지휘의 외침",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여!~ 피통이 대박 빵빵~~~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT노움_순간이동기"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "노움 순간이동기",
			},
			["Messages"] = {
				"[가젯잔]으로 고고고고!~ ㅋㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN얼음길"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "얼음길",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여!~~물위를 걸어보자!~ 움하하하!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT소멸"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "소멸",
			},
			["Messages"] = {
				"<마법링크>했다!~ 안보이지롱!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF은신"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF",
				["name"] = "은신",
			},
			["Messages"] = {
				"<마법링크>이다!~ 숨어!~ ㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN상급_힘의_축복"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "상급 힘의 축복",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>를 주셨어여~~힘내자 힘!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT터보_충전_비행기"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "터보 충전 비행기",
			},
			["Messages"] = {
				"<마법링크>를 탑니다!~ 부럴털털 부럴털털~~~ㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "EMOTE",
				["Solo"] = "EMOTE",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT발차기"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "발차기",
			},
			["Messages"] = {
				"<마법링크>다!~ 어디서 되먹지 않은 마법을 쓸라구 콱!~", -- [1]
				"<마법링크>했더니 가랭이가 찢어졌네!~ ㅠ.ㅠ", -- [2]
				"니들이 <마법링크>를 알어? 가랭이가 찢어지는 고통을..ㅠ.ㅠ", -- [3]
				"<마법링크>했습니다!~ 다음분!~~", -- [4]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN야생의_징표"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "야생의 징표",
			},
			["Messages"] = {
				"[<시전자>]님께서 <마법링크>를 주셨어여~~큰걸로 안되나염..ㅠ.ㅠ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT온순한_기계설인"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				
				["name"] = "온순한 기계설인",
			},
			["Messages"] = {
				"귀여운 나의 <마법링크>이 나왔습니다~~이뻐해주세용~~홍홍홍", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN가시"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "가시",
			},
			["Messages"] = {
				"[<시전자>]님께서 <마법링크>를 주셨어여!~ 나치면 가시찔린다!~ ㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN선인의_인내력"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "선인의 인내력",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~~ 튼튼해졌삼~~~", -- [1]
			},
			["Channels"] = {
				["Solo"] = "EMOTE",
				["Party"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN피의_욕망"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "피의 욕망",
			},
			["Messages"] = {
				"아싸!~ <마법링크>이다!~ [<시전자>]님이 날려주셨어여!~ ㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_DEBUFF_FOREIGN바위_손아귀"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_DEBUFF_FOREIGN",
				["name"] = "바위 손아귀",
			},
			["Messages"] = {
				"힐해주세여~~  <마법링크>에 있어여 이런 된장~~~ㅠ.ㅠ", -- [1]
			},
			["Channels"] = {
				["Party"] = "SAY",
				["Solo"] = "SAY",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN암흑_보호의_기원"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "암흑 보호의 기원",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~더러운 기운이여 안녕!~~ㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_DEBUFF_FOREIGN암색_비취_광선"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_DEBUFF_FOREIGN",
				["name"] = "암색 비취 광선",
			},
			["Messages"] = {
				"[<시전자|나>]님이 <마법링크>을 쏴서 [<대상||나>]를 죽이려고해요!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF정신_이상"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF",
				["name"] = "정신 이상",
			},
			["Messages"] = {
				"<마법링크>으로 자객이 되었습니다!~ 밤길들 조심하삼!~ ㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN정신력의_기원"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "정신력의 기원",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~정신이 번쩍!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "SAY",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN회복"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "회복",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여..우왕 굳~~", -- [1]
			},
			["Channels"] = {
				["Solo"] = "YELL",
				["Party"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN보호의_손길"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "보호의 손길",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨습니다~~~스킬이 안나가여..ㅠ.ㅠ", -- [1]
			},
			["Channels"] = {
				["Party"] = "SAY",
				["Solo"] = "SAY",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_DEBUFF_FOREIGN실명"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_DEBUFF_FOREIGN",
				["name"] = "실명",
			},
			["Messages"] = {
				"[<시전자|나>]넘이 [<대상|나>]에게 <마법링크>을 걸었어여!~ 저런 쳐죽일넘!~ 안보이잖여!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "SAY",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN겨울의_뿔피리"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "겨울의 뿔피리",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>를 주셨어여~~날렵해졌어여~~ ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "SAY",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_DEBUFF_FOREIGN집중의_암흑_수정_렌즈"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_DEBUFF_FOREIGN",
				["name"] = "집중의 암흑 수정 렌즈",
			},
			["Messages"] = {
				"[<시전자||나>]님이 <마법링크>을 쏴서 [<대상||나>]를 죽이려고해요!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT생선_통구이"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "생선 통구이",
			},
			["Messages"] = {
				"<마법링크> 나왔시유!~~~음식밟는 사람 3대가 재수없음!~ ㅋㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT청동_비룡"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "청동 비룡",
			},
			["Messages"] = {
				"<마법링크>을 탑니다!~ 훨훨~~ㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "EMOTE",
				["Solo"] = "EMOTE",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN야생의_선물"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "야생의 선물",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~아~~발냄새~~~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "SAY",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN대지의_생명"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "대지의 생명",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~~생명이 모락모락!~ ㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Solo"] = "YELL",
				["Party"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT신축성_내피"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "신축성 내피",
			},
			["Messages"] = {
				"[낙하산]이구나~~~아래 경치좀 보자!~~~~ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN인내의_기원"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "인내의 기원",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>를 주셨어여~체력이 빵빵!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "SAY",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_DEBUFF_FOREIGN정신이상"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_DEBUFF_FOREIGN",
				["name"] = "정신이상",
			},
			["Messages"] = {
				"<마법링크>당했어여!~ ㅠ.ㅠ  짜증..ㅠ.ㅠ", -- [1]
			},
			["Channels"] = {
				["Party"] = "SAY",
				["Solo"] = "SAY",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_DEBUFF비행_제한_지역"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_DEBUFF",
				["name"] = "비행 제한 지역",
			},
			["Messages"] = {
				"<마법링크>이다!~ 떨어진다~~우웡~~~~", -- [1]
			},
			["Channels"] = {
				["Party"] = "SAY",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT작은_모닥불"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "작은 모닥불",
			},
			["Messages"] = {
				"<마법링크>핍니다~~~요리하실분들 모이세여~~ㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT바다거북"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "바다거북",
			},
			["Messages"] = {
				"절라느린 <마법링크>이구나~~~그래도 물속에서 빨러 이거왜이래~~~ㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT전력_질주"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "전력 질주",
			},
			["Messages"] = {
				"<마법링크>다!~ 전나게 달려보자!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF해적_선장"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF",
				["name"] = "해적 선장",
			},
			["Messages"] = {
				"<마법링크>이 되었습니다!~ 밤길들 조심하삼!~ㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF그림자_망토"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF",
				["name"] = "그림자 망토",
			},
			["Messages"] = {
				"<마법링크>다!~ 해로운 주문이여 물러가라!~~~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT전기_충격"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "전기 충격",
			},
			["Messages"] = {
				"<마법링크>! 너는 국산이냐 짱개산이냐!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "SAY",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT고철로봇"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "고철로봇",
			},
			["Messages"] = {
				"자자!~ 보따리상 <마법링크>이 왔어요~~수리하실분 수리하시고 살거있음 사삼!~ 쫌 비싸여 ㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "SAY",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT1특성_활성화"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "1특성 활성화",
			},
			["Messages"] = {
				"암살(레이드)도적으로 변신!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT회피"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "회피",
			},
			["Messages"] = {
				"<마법링크>다!~ 요리조리 싹싹!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT검은색_전투곰"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "검은색 전투곰",
			},
			["Messages"] = {
				"<마법링크>을 탑니다!~ 어흥~~ㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "EMOTE",
				["Solo"] = "EMOTE",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN신의_권능:_인내"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "신의 권능: 인내",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~피통커졌다!~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT귀환석"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "귀환석",
			},
			["Messages"] = {
				"에잉!~ 잼없다!~ <마법링크>쓰고 집에가자!~ ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN상급_지혜의_축복"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "상급 지혜의 축복",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>를 주셨어여~~ 저는 엠이 없는디 ㅋㅋㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT순간_효과_독_IX9_레벨"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["rank"] = "9 레벨",
				["name"] = "순간 효과 독 IX",
			},
			["Messages"] = {
				"<마법링크>을 발라보자~~~움하하하하", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN재생"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "재생",
			},
			["Messages"] = {
				"[<시전자>]님께서 <마법링크>을 주셨어여~~~피통이여 재생하라~~~~", -- [1]
			},
			["Channels"] = {
				["Solo"] = "YELL",
				["Party"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_DEBUFF_FOREIGN불타는_낙인"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_DEBUFF_FOREIGN",
				["name"] = "불타는 낙인",
			},
			["Messages"] = {
				"[<시전자|나>]가 [<대상|나>]에게 <마법링크>을 걸었어여!~ 저런 죽일넘!~ ㅡ.ㅡ?", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT속임수_거래"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "속임수 거래",
			},
			["Messages"] = {
				"[<대상>]님께 <마법링크>들어갑니다!~", -- [1]
				"[<대상>]님! <마법링크>먹고 어글 팍팍드삼!~", -- [2]
				"[<대상>]님아!~ <마법링크>받고 어글이 뭔지 보여주세요!~", -- [3]
				"[<대상>]님! <마법링크>때문에 행복하시죠? ㅋㅋㅋ", -- [4]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "SAY",
				["Raid"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN소생"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "소생",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~살아나는 느낌~~~", -- [1]
			},
			["Channels"] = {
				["Solo"] = "YELL",
				["Party"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN성난_해일"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "성난 해일",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~~피가 빵빵~~~", -- [1]
			},
			["Channels"] = {
				["Solo"] = "EMOTE",
				["Party"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT휴대용_우체통"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "휴대용 우체통",
			},
			["Messages"] = {
				"<마법링크>이 나왔어여~~수수료 1골!~ ㅋㅋㅋㅋ", -- [1]
			},
			["Channels"] = {
				["Party"] = "SAY",
				["Solo"] = "SAY",
				["Raid"] = "YELL",
			},
		},
		["UNIT_SPELLCAST_SENT채광"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "채광",
			},
			["Messages"] = {
				"광맥이다!~~ <마법링크>하자!~~움하하하하", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN빛의_봉화"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "빛의 봉화",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 [<대상||저>]에게 <마법링크>를 박으셨시유~~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["UNIT_SPELLCAST_SENT맹독_IX9_레벨"] = {
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["rank"] = "9 레벨",
				["name"] = "맹독 IX",
			},
			["Messages"] = {
				"<마법링크>을 발라보자~~~움하하하하", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
			},
		},
		["SPELL_AURA_APPLIED_BUFF인간의_환영"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF",
				["name"] = "인간의 환영",
			},
			["Messages"] = {
				"<마법링크>으로 인간이 되었구나!~~움하하하하", -- [1]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "YELL",
			},
		},
		["SPELL_AURA_APPLIED_BUFF_FOREIGN신비한_총명함"] = {
			["DetectedEvent"] = {
				["type"] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
				["name"] = "신비한 총명함",
			},
			["Messages"] = {
				"[<시전자|나>]님께서 <마법링크>을 주셨어여~~머리가 좋아졌어여~~~", -- [1]
			},
			["Channels"] = {
				["Party"] = "YELL",
				["Solo"] = "YELL",
				["Raid"] = "EMOTE",
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
		["UNIT_SPELLCAST_SENTREVIVE"] = {
			["Messages"] = {
				"Rezzing <target>", -- [1]
				"<target>, don't go into the light, return to the land of the living!", -- [2]
				"Rise, <target>, and live again!", -- [3]
				"Get yer lazy bones up, <target>!", -- [4]
				"The hand of God reaches down and brings <target> back to life", -- [5]
				"Granddaddy always said laughter was the best medicine. I guess it wasn't strong enough to keep <target> alive.", -- [6]
				"Arise <target>, and fear death no more; or at least until the next pull.", -- [7]
				"Bring out your dead! *throws <target> on the cart*", -- [8]
				"<target>, quit hitting on the Spirit Healer and come kill something!", -- [9]
				"YAY! I always wanted my very own <target>-zombie!", -- [10]
				"It just so happens that <target> is only MOSTLY dead. There's a big difference between mostly dead and all dead. Mostly dead is slightly alive.", -- [11]
				"<target> has failed at life, I'm giving him a second chance. That's right, not God, ME!!", -- [12]
				"Cool, I received 42 silver, 32 copper from the Corpse of <target>", -- [13]
				"<target>, this better not be another attempt to get me to give you mouth-to-mouth.", -- [14]
				"<target>, it's more mana efficient just to resurrect you.  Haha, I'm just kidding!", -- [15]
				"Well, <target>, if you had higher faction with <player>, you might have gotten a heal. How do you raise it? 1g donation = 15 rep.", -- [16]
				"<target>, by accepting this resurrection you hereby accept that you must forfeit your immortal soul to <player>. Please click 'Accept' to continue.", -- [17]
				"Folks, what we have here is a prime example of why <target> shouldn't tank.", -- [18]
				"Don't rush me <target>. You rush a miracle worker, you get rotten miracles.", -- [19]
				"Death comes for you <target>! With large, pointy teeth!", -- [20]
				"Resurrecting <target>. Side effects may include: nausea, explosive bowels, a craving for brains, and erectile dysfunction. Resurrection is not for everyone. Please consult a healer before dying.", -- [21]
				"Dammit <target>, I'm a doctor! Not a priest! ... Wait a second ... nevermind. Ressing <target>", -- [22]
				"... death defying feats are clearly not your strong point, <target>", -- [23]
				"Giving <target> another chance to noob it up. ", -- [24]
				"Hey <target>, can you check to see if Elvis is really dead? ... and can he fill your spot in the party?", -- [25]
				"<target> I *warned* you, but did you listen to me? Oh, no, you *knew*, didn't you? Oh, it's just a harmless little *bunny*, isn't it?", -- [26]
				"Tsk tsk, <target>. See, I told you to sacrifice that virgin to the Volcano God.", -- [27]
				"You don't deserve a cute rez macro, <target>. You deserve to die. But you already did, so, um... yeah.", -- [28]
				"Sorry <target>, I couldn't heal you. I was too busy being the tank.", -- [29]
				"Did it hurt, <target>, when you fell from Heaven? Oh, wait. You're dead. I don't know where I was going with that. Nevermind.", -- [30]
			},
			["Channels"] = {
				["Party"] = "PARTY",
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["BG"] = "BATTLEGROUND",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Revive",
			},
			["WhisperTarget"] = true,
		},
		["UNIT_SPELLCAST_SENTREBIRTH"] = {
			["Messages"] = {
				"Rezzing <target>", -- [1]
				"<target>, don't go into the light, return to the land of the living!", -- [2]
				"Rise, <target>, and live again!", -- [3]
				"Get yer lazy bones up, <target>!", -- [4]
				"The hand of God reaches down and brings <target> back to life", -- [5]
				"Granddaddy always said laughter was the best medicine. I guess it wasn't strong enough to keep <target> alive.", -- [6]
				"Arise <target>, and fear death no more; or at least until the next pull.", -- [7]
				"Bring out your dead! *throws <target> on the cart*", -- [8]
				"<target>, quit hitting on the Spirit Healer and come kill something!", -- [9]
				"YAY! I always wanted my very own <target>-zombie!", -- [10]
				"It just so happens that <target> is only MOSTLY dead. There's a big difference between mostly dead and all dead. Mostly dead is slightly alive.", -- [11]
				"<target> has failed at life, I'm giving him a second chance. That's right, not God, ME!!", -- [12]
				"Cool, I received 42 silver, 32 copper from the Corpse of <target>", -- [13]
				"<target>, this better not be another attempt to get me to give you mouth-to-mouth.", -- [14]
				"<target>, it's more mana efficient just to resurrect you.  Haha, I'm just kidding!", -- [15]
				"Well, <target>, if you had higher faction with <player>, you might have gotten a heal. How do you raise it? 1g donation = 15 rep.", -- [16]
				"<target>, by accepting this resurrection you hereby accept that you must forfeit your immortal soul to <player>. Please click 'Accept' to continue.", -- [17]
				"Folks, what we have here is a prime example of why <target> shouldn't tank.", -- [18]
				"Don't rush me <target>. You rush a miracle worker, you get rotten miracles.", -- [19]
				"Death comes for you <target>! With large, pointy teeth!", -- [20]
				"Resurrecting <target>. Side effects may include: nausea, explosive bowels, a craving for brains, and erectile dysfunction. Resurrection is not for everyone. Please consult a healer before dying.", -- [21]
				"Dammit <target>, I'm a doctor! Not a priest! ... Wait a second ... nevermind. Ressing <target>", -- [22]
				"... death defying feats are clearly not your strong point, <target>", -- [23]
				"Giving <target> another chance to noob it up. ", -- [24]
				"Hey <target>, can you check to see if Elvis is really dead? ... and can he fill your spot in the party?", -- [25]
				"<target> I *warned* you, but did you listen to me? Oh, no, you *knew*, didn't you? Oh, it's just a harmless little *bunny*, isn't it?", -- [26]
				"Tsk tsk, <target>. See, I told you to sacrifice that virgin to the Volcano God.", -- [27]
				"You don't deserve a cute rez macro, <target>. You deserve to die. But you already did, so, um... yeah.", -- [28]
				"Sorry <target>, I couldn't heal you. I was too busy being the tank.", -- [29]
				"Did it hurt, <target>, when you fell from Heaven? Oh, wait. You're dead. I don't know where I was going with that. Nevermind.", -- [30]
			},
			["Channels"] = {
				["Party"] = "PARTY",
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["BG"] = "BATTLEGROUND",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Rebirth",
			},
			["WhisperTarget"] = true,
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
		["UNIT_SPELLCAST_SENTRAISE_DEAD"] = {
			["Messages"] = {
				"It's alive... ALIVE!!!", -- [1]
				"Rise, my undead puppet, and do my bidding!", -- [2]
			},
			["Channels"] = {
				["Solo"] = "SAY",
				["Party"] = "SAY",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Raise Dead",
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
		["UNIT_SPELLCAST_SENTANCESTRAL_SPIRIT"] = {
			["Messages"] = {
				"Rezzing <target>", -- [1]
				"<target>, don't go into the light, return to the land of the living!", -- [2]
				"Rise, <target>, and live again!", -- [3]
				"Get yer lazy bones up, <target>!", -- [4]
				"The hand of God reaches down and brings <target> back to life", -- [5]
				"Granddaddy always said laughter was the best medicine. I guess it wasn't strong enough to keep <target> alive.", -- [6]
				"Arise <target>, and fear death no more; or at least until the next pull.", -- [7]
				"Bring out your dead! *throws <target> on the cart*", -- [8]
				"<target>, quit hitting on the Spirit Healer and come kill something!", -- [9]
				"YAY! I always wanted my very own <target>-zombie!", -- [10]
				"It just so happens that <target> is only MOSTLY dead. There's a big difference between mostly dead and all dead. Mostly dead is slightly alive.", -- [11]
				"<target> has failed at life, I'm giving him a second chance. That's right, not God, ME!!", -- [12]
				"Cool, I received 42 silver, 32 copper from the Corpse of <target>", -- [13]
				"<target>, this better not be another attempt to get me to give you mouth-to-mouth.", -- [14]
				"<target>, it's more mana efficient just to resurrect you.  Haha, I'm just kidding!", -- [15]
				"Well, <target>, if you had higher faction with <player>, you might have gotten a heal. How do you raise it? 1g donation = 15 rep.", -- [16]
				"<target>, by accepting this resurrection you hereby accept that you must forfeit your immortal soul to <player>. Please click 'Accept' to continue.", -- [17]
				"Folks, what we have here is a prime example of why <target> shouldn't tank.", -- [18]
				"Don't rush me <target>. You rush a miracle worker, you get rotten miracles.", -- [19]
				"Death comes for you <target>! With large, pointy teeth!", -- [20]
				"Resurrecting <target>. Side effects may include: nausea, explosive bowels, a craving for brains, and erectile dysfunction. Resurrection is not for everyone. Please consult a healer before dying.", -- [21]
				"Dammit <target>, I'm a doctor! Not a priest! ... Wait a second ... nevermind. Ressing <target>", -- [22]
				"... death defying feats are clearly not your strong point, <target>", -- [23]
				"Giving <target> another chance to noob it up. ", -- [24]
				"Hey <target>, can you check to see if Elvis is really dead? ... and can he fill your spot in the party?", -- [25]
				"<target> I *warned* you, but did you listen to me? Oh, no, you *knew*, didn't you? Oh, it's just a harmless little *bunny*, isn't it?", -- [26]
				"Tsk tsk, <target>. See, I told you to sacrifice that virgin to the Volcano God.", -- [27]
				"You don't deserve a cute rez macro, <target>. You deserve to die. But you already did, so, um... yeah.", -- [28]
				"Sorry <target>, I couldn't heal you. I was too busy being the tank.", -- [29]
				"Did it hurt, <target>, when you fell from Heaven? Oh, wait. You're dead. I don't know where I was going with that. Nevermind.", -- [30]
			},
			["Channels"] = {
				["Party"] = "PARTY",
				["Raid"] = "RAID",
				["Solo"] = "SAY",
				["BG"] = "BATTLEGROUND",
			},
			["DetectedEvent"] = {
				["type"] = "UNIT_SPELLCAST_SENT",
				["name"] = "Ancestral Spirit",
			},
			["WhisperTarget"] = true,
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
