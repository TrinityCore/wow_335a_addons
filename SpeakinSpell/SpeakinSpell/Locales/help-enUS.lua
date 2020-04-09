-- Author      : RisM
-- Create Date : 5/21/2009 11:56:30 PM

-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local HELPFILE = AceLocale:NewLocale("SpeakinSpell_HELPFILE", "enUS", true)
if not HELPFILE then return end

SpeakinSpell:PrintLoading("Locales/help-enUS.lua")

----------------------------------------------------------------------------------------
--[[ The format of each page is as follows:
	["Chapter Title"] = "Contents"
--]]

--ATTENTION TRANSLATORS:
--	The complete user's manual in this file is a long and wordy thing covering many topics
--	it is likely to grow and change in many ways and very often as I enhance SpeakinSpell
--	because this is where we fully document how to use each and every feature.
--
--	Because of this problem that the user's manual will change very frequently,
--	I made the programming code very flexible in how this data is used.
--	very flexible.
--
--	Unlike most of Locale-xxXX.lua, you are free to change the complete contents of
--	HELPFILE.PAGES (the following table)
--	including the table keys which are used as chapter titles
--	the contents of each chapter of course
--	the order of the contents
--	and you are also free to change the number of chapters to add, remove, and reorganize
--
--	I want you to be able to completely reorganize this user's manual as you see fit
--	Given that languages and cultures are very different, you may be able to convey the 
--	information better if you organized it differently.
--	You are free to do that and it should work - try it and see.
--	
----------------------------------------------------------------------------------------
HELPFILE.PAGES = {

----------------------------------------------------------------------------------------
["1. About SpeakinSpell"] = {
order = 1,
Summary = "About SpeakinSpell",
Contents = [[

Funny and/or Useful, SpeakinSpell will use random speeches in chat to announce when you use spells and other abilities, as well as items, procced effects, other events, and user-defined macros.

Works with all classes. Configurable for many different situations.

Curse download page:
http://wow.curse.com/downloads/wow-addons/details/speakinspell.aspx

Project home page:
http://www.wowace.com/projects/speakinspell/

Please submit any feature requests and bug reports here:
http://www.wowace.com/projects/speakinspell/create-ticket/

This help file is also available in your web browser here:
http://www.wowace.com/addons/speakinspell/pages/complete-user-manual/

Brought to you by |cff33ff99Stonarius of Antonidas|r and many other important people.

I stood on the shoulders of the Giants in the Playground - please read the credits!
]],
},

----------------------------------------------------------------------------------------
["2. Basic Instructions"] = {
order = 2,
Summary = "Getting Started with SpeakinSpell",
Contents = [[

How to setup SpeakinSpell in a few easy steps:

1. Login and play your toon for a few minutes.

2. Activate any abilities, trigger any procced effects, and encounter any other detectable events that you would like SpeakinSpell to announce.

3. Type "/ss" to access the interface options panel

4. Click on "Create New..." or type "/ss create" to create settings for a new spell or other event

5. Select the desired spell or event from the list and click the Create button. You will be taken to the settings page for that spell or event.

6. Change the settings to your tastes and write as many speeches as you want. Now whenever you cast that spell or encounter that event, SpeakinSpell will say one of your random messages for that event, using the channels and other rules that you defined.

7. Repeat until you run out of ideas for new announcements to write. 

]],
},

----------------------------------------------------------------------------------------
["3. Features"] = {
order = 3,
Summary = "Overview of All Features",
Contents = [[

Can detect a variety of "Speech Events" and automatically announce them in the chat using a random selection from a list of user-defined speeches (some defaults are provided for you as examples). This includes: 
- Spells you cast 
- All other abilities for any class (a warrior's Heroic Strike is also technically considered a "spell") 
- Anything you can equip in your action bar 
- Items 
- Procced effects (buffs that you receive from yourself) 
- NPC interactions
- Combat Events, Critical Strikes, Killing Blows, etc.
- Achievements
- Chat parsing events like someone said "ding"
- Other Events (Login, open trade window, etc)
- whenever you type "/ss macro something" 

Up to 100 speeches can be entered per spell. 

Each spells' random speeches can be directed to any chat channel you choose 

Supports different channel options for different scenarios: solo, group, raid, BG, and arena. 

Fully configurable through the interface options panel. 

Includes funny default speeches for many spells for all classes 

All of your settings apply only to this character.  All user-defined speeches and other settings are saved separately per character.

Supports many substitution variables such as <player>, <target>, <targetclass>, <targetrace>, and many more, including possessive forms, and ways to avoid naming yourself in the third person.

Never says the same message for a given spell twice in a row (unless you only have 1 message defined for that spell) 

Can be configured to only announce the use of a spell based on a random chance. This is a user-configurable percent chance per spell. This can be useful for roleplaying purposes, or to cut down on the amount of spell-triggered spam you generate in chat. 

Can be configured to use a cooldown on spell announcements for each spell. This can be used to prevent announcing spell casting too often for frequently used spells 

Can be configured to limit event announcements to once per combat and/or once per target.

Can whisper messages to the target of your spell. This can be useful for resurrect style spells, innervate, power infusion, etc. 

When you get compliments on your "macros" use "/ss ad" to tell your friends about SpeakinSpell. Some of the random ads are funny. Yes, it's an addon that spams random text in chat, and it has a feature to spam random text to advertise it's ability to spam random text. See "Chapter 4. Slash Commands" for details.

Detection of other events such as Login, Entering Combat, Changed Zone, etc.  See "Chapter 12. Other Events" for details.

Create your own event with Custom Defined User Macros. Type "/ss macro something" to make SpeakinSpell detect a pseudo spell event called "when I type: /ss macro something" which you can setup to be announced with random speeches. See "Chapter 11. Custom Macros" for details.

Allows content sharing with other SpeakinSpell users via invisible chat channels
]],
},

----------------------------------------------------------------------------------------
["4. Slash Commands"] = {
order = 4,
Summary = "/ss commands",
Contents = [[
/ss works as an abbreviation for /speakinspell

/speakinspell
- show options (same as "/ss toggle" or right-clicking the minimap button)

/speakinspell toggle
- open or re-open the SpeakinSpell GUI

/speakinspell options
- show General Settings

/speakinspell help
- show this help

/speakinspell create
- open the Create New... interface, to create message settings for a new event

/speakinspell messages
- open the Message Settings interface to edit your current settings

/speakinspell random
- open the Random Substitutions editor

/speakinspell import
- open the Import New Data interface

/speakinspell network
- open the network options GUI
- see also "/ss sync" below

/speakinspell colors
- open the color options interface

/speakinspell guides
- toggle setup guides on/off

/speakinspell reset
- reset all settings to defaults

/speakinspell eraseall
- erase all event triggers and speeches, leaving all other options unchanged

/speakinspell ad
- tell your friends about this addon (using a default channel)

/speakinspell ad /p
- tell your party (chat channel) about this addon (/s, /g, or /ra also works)

/speakinspell ad stonarius
- whisper to your friend Stonarius about this addon

/speakinspell macro <something>
- activate a Speech Event called "When I type: /ss macro <something>".  See also "11. Custom Macros"

/speakinspell testallsubs
- reports the value of all possible substitutions for the current event

/speakinspell memory
- shows how much memory SpeakinSpell is using

/speakinspell sync
- send a data sharing request to GUILD, RAID, PARTY, and BATTLEGROUND channels

/speakinspell sync playername
- send a data sharing request to playername

NOTE: all slash commands support all standard substitution values such as <target> and <player>.  For example "/ss ad <target>" or "/ss sync <target>"
]],
},

----------------------------------------------------------------------------------------
["5. < Substitutions >"] = {
order = 5,
Summary = "A comprehensive list of all substitutions you can use in your speeches, such as <target>, <caster>, <spellname>, etc.",
Contents = [[

Each random message may refer to the player casting the spell, the target of the spell, and several other pieces of information which may be provided for you automatically by SpeakinSpell

Following is a complete list of variables which you may insert in random messages to use this feature.  The angle brackets <> are required.

<player>
- Your name

<playertitle>
- Your current title, for example "the Explorer"

<playerfulltitle>
- your name with your title included

<caster>
- The name of the person or entity casting the spell or effect
- not always the same as <player>

<target>
- The name of the target on whom you are casting the spell.
- As often as possible, this will be the true actual target of your spell (not necessarily your currently selected target)
- If the target is undefined for an event, <target> will use the value of <selected>, <focus>, <mouseover>, or <player> (in that order)

<targetclass>
- Your target's class, as in "Casting DI on the <targetclass>" becomes "Casting DI on the Priest"

<targetrace>
- Your target's race, as in "Casting DI on the <targetrace>" becomes "Casting DI on the Dwarf"

<race>
<playerrace>
- your race

<class>
<playerclass>
- your class

<focus>
- The name of your focus target (/focus)

<selected>
- The name of your selected target only

<lasttarget>
- The last target specified by a UNIT_SPELLCAST_SENT Blizzard API notification

<mouseover>
- The name of the player or NPC under your mouse

<spellname>
- The complete name of the spell that you are casting (the spell's rank is not included)

<eventname>
- The name of the SpeakinSpell event (usually the same as <spellname>, but subtly different)

<name>
- same as <eventname>

<displayname>
- The full display name of the SpeakinSpell event as shown in the event selection lists in the SS options GUI
- ex. "When I start casting: <spellname>"

<eventtype> 
- The name of the category option this event falls under
- ex. "Spells, Abilities, and Items (Start Casting)"

<eventtypeprefix> 
- The event type prefix used in the <displayname>
- ex. "When I Start Casting: "

<spellrank> 
- The rank of the spell. 
- For greater flexibility, parentheses are not included by the substitution, so default usage would be "<spellname> (<spellrank>)" -> "Fishing (Artisan)" or "Arcane Intellect (Rank 2)" 

<spelllink>
- Creates a clickable link to the spell in chat

<displaylink>
- The complete name of the event as it would be shown by the option to Report Detected Speech Events, including a clickable link to the spell if applicable

<pet>
- The name of your combat pet (not for use with vanity pets)
- Due to a limitation of the WoW LUA API, this substitution does not work when summoning your pet. It only works after your pet has already been summoned.

<TM>
- The trademark symbol, as in Stonarius' Magical Biscuits™

<C>
- The copyright symbol, as in Copyright © 2008

<R>
- The registered trademark symbol, as in Speak & Spell ® is a registered trademark of Texas Instruments (or at least I assume it is)

<newline>
- This will split a speech into more than one line of text, so you can say two speeches at the same time
- "For the Horde!<newline>/cheer" will say "For the Horde!" in your selected channel, and then make you do "/cheer" at the same time.
- (For the same effect, it is also valid to type a new line into the multi-line edit boxes for the speeches)

Time and date substitutions
<mdyhms> - 12/31/09 24:00:00
<mdy> - 12/31/09
<hms> - 24:00:00
<md> - 12/31
<hm> - 24:00

<realm>
- The name of your realm server

<zone>
- The name of your current region, zone, or location, at a high level of the greater area, for example "Dalaran"

<subzone>
- The name of the smaller area you are in within the zone, for example "The Eventide"
- This will match the location shown on your minimap

<guild>
- The name of your guild

<home>
- The name of your home inn / hearthstone location

<arenaN>
- Opposing arena member with index N (1,2,3,4,5). 

<partyN>
- The Nth party member excluding the player (1,2,3 or 4). 

<partypetN>
- The pet of the Nth party member (N is 1,2,3, or 4) (Added in 1.5.0). 

<raidN>
- The raid member with raidIndex N (1,2,3,...,40). 

<raidpetN>
- The pet of the raid member with raidIndex N (1,2,3,...,40) (Added in 1.5.0) 

<vehicle>
- The current player's vehicle.

<scenario> 
- "The Arena", "A Battleground", "Wintergrasp", "A Raid", etc

Random Substitutions: <randomfaction>, <randomtaunt>, etc
- Various randomly-generated substitutions are available
- each time you use a random substutition, a different value will be used
- click on Random Substitutions to your left, or type "/ss random" to edit the lists

Also all other UnitId values which may be used with the UnitName() API, including targets of targets.

You can append the suffix target to any UnitId to get a UnitId which refers to that unit's target (e.g. "partypet2target"). This appending can be repeated indefinitely (e.g. "playertargettarget"), though you will observe an attendant performance hit if you overdo it, as the game engine has to jump from target to target.

If you are using a party or raid member's name as a unit, you need to use hyphens to separate the target chain (e.g. "Stonarius-target-target"). 

Also supports possessive forms of all of the above.  For details, see chapter 7. Possessive Forms.

]],
},

----------------------------------------------------------------------------------------
["6. Third Person|me"] = {
order = 6,
Summary = "How to avoid talking about yourself in the third-person by using advanced substitution forms like <target|me>",
Contents = [[

<target|me>
<target|myself>
<target|___>

Allows specifying alternate text to avoid speaking about yourself in the third person.

This works just like <target> unless that target is yourself, in which case the alternate text after the | is used instead.

For example, to announce the Priest spell Power Word: Shield, one might write a SpeakinSpell speech to say "Don't panic! I have protected <target|myself> from harm!"

When you cast Power Word: Shield on your friend, Stonarius, it comes out as "Don't panic! I have protected Stonarius from harm!"

And when you cast on yourself, it will say "Don't panic! I have protected myself from harm!" instead of using your own name.

This feature works for any substitution, for example:
My target is <target|myself>, I set my focus to <focus|me>, I have <selected|myself> selected, My mouse is over <mouseover|my portrait>, and I call this pet <pet|Junior>

In any case, if the substitution would use your own name, it will instead use the text to the right of the |.

This also works with possessive forms (see chapter 7. Possessive Forms)

Pronoun forms also support embedded substitutions using underscores instead of angle brackets, for example:
<target|_playerfulltitle_>

That example will use the substitution value for <playerfulltitle> if the <target> is the <player>
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

Pronoun forms also support embedded substitutions using underscores instead of angle brackets, for example:
<target*_randomboy_*_randomgirl_>

If the target is male, that example will use the value of the <randomboy> substitution.
]],
},

----------------------------------------------------------------------------------------
["9. <target> Info"] = {
order = 9,
Summary = [[Why doesn't it use the correct <target> name sometimes?

What if I'm focus casting?

What if I have the tank targetted but then use Healbot to raid heal someone else?]],
Contents = [[

Why doesn't it use the correct <target> name sometimes?
What if I'm focus casting?
What if I have the tank targetted but then use Healbot to raid heal someone else?

The WoW interface offers many ways to target and cast spells, only one of which is to select a target, and then cast a spell (on that target by default).  Take a moment to consider the many other ways to cast spells, such as clicking a spell first to get a special cursor, and then clicking on a target player or mob, or using focused casting (/focus), or macros, or other addons to target and cast your spells and abilities.

SpeakinSpell will use the actual true target of your spell as often as possible for providing your <target> name, just like using %t in a macro that you build in the default UI, which is what you would naturally expect.

However, in some cases, the spell targetting information is not provided by Blizzard's WoW LUA API when it notifies SpeakinSpell that a spell has been cast.  The most common of these cases include casting spells on dead players who released their spirits (i.e. resurrection), and non-targetable spells which are self-cast only (i.e. a Warrior's Shield Wall).

In these cases, SpeakinSpell has to make its best guess.  It will try to use a target name from the following sources (in this order):

1) the true target name provided with the spell casting event notification (if available)
2) UnitName("target") API, same value as <selected> = your selected target
3) UnitName("focus") API, same value as <focus> = your focus target
4) UnitName("mouseover") API, same value as <mouseover> = the player or NPC under your mouse

Failing all those, any unknown targets will show "<target>" as-is, unsubstituted.

Chances are pretty good that this method will retrieve the correct name of the target of your spell, but it's still not completely guaranteed because of the variety of ways to cast spells, use other abilities, and proc effects in WoW.

<lasttarget> - Spell Channeling events don't provide the <target> information either.  To assist with this, the <lasttarget> substitution refers to the target name provided with the last UNIT_SPELLCAST_SENT event notification (When I start casting...) because usually you "start casting" before you "start channeling" (but not always, as in the case of the Summoning Stone Effect, which skips to channeling)

If you are working with non-targettable spells, or certain spells which are simply bugged by Blizzard, then you should use <target> with care, and consider alternative substitutions for <caster>, <player>, <focus>, <selected>, <lasttarget>, or <mouseover> may be helpful for making your speeches come out as intended.

This limitation also applies to <targetrace> and <targetclass>.  The same target selection will be used to determine the race and class.
]],
},

----------------------------------------------------------------------------------------
["10. Resurrection"] = {
order = 10,
Summary = "Special Support for Resurrection Events",
Contents = [[
SpeakinSpell uses a smart module called LibResComm-1.0 by DathRarhek (Polleke) to fix the problem of unknown targets of resurrection spells, such as players who released their spirits, as described in chapter 9. <target> Info.

LibResComm also provides several other event notifications related to resurrection spells, all of which can be reported by SpeakinSpell.

These event hooks do not interfere with the default combat log events such as "when I start casting..." and both types of events will fire under slightly different rules with slightly different information.

LibResComm events provide the correct <target> and can detect additional events such as when a res has been declined, however, it doesn't know the <spellname>, and some of the events don't know the <caster>.

The standard spell casting events are less reliable about the <target> name, but are aware of the <spellname>.

By default, the long list of resurrection speeches provided with SpeakinSpell uses a shared list of speeches under "/ss macro rez" which is currently attached to the "Resurrection: Start Casting (I'm the caster)" event hook in the default settings for new users.

3.2.2.25 Update: SpeakinSpell players who started with SS before v3.2.2.25 may want to change your settings to use the new "Resurrection: Start Casting (I'm the caster)" event hook, instead of the standard "When I Start Casting:" event for your class, to make use of the improved <target> information.
]],
},

----------------------------------------------------------------------------------------
["11. Custom Macros"] = {
order = 11,
Summary = "How to create custom Speech Events",
Contents = [[

What Is a Custom Macro?

A Custom Macro is a kind of event which can be announced in the chat using a random speech just like any spell, ability, or other detected event.  They can also be used for more advanced applications to create a list of speeches that are shared by more than one spell, and to create separate lists of speeches which can be used by the same spell when you're in different scenarios.


How do I create a Custom Macro?

To get started creating a User-Defined Custom Macro Event, simply type in "/ss macro ___" and fill in the blank with whatever you want to call this macro.

If this is the first time you've typed this particular "/ss macro ___", then SpeakinSpell will prompt you to create new message settings for this event (as if you had also typed "/ss create")  You must type "/ss macro ___" at least once to make it show up under the Create New interface in the SpeakinSpell options.

If you already created message settings for the event "When I type: /ss macro something" then typing "/ss macro something" will trigger that event and speak one of your messages, just like a spell event.

If you would like to create a different Custom Macro, simply use a different name to fill in the blank.  The macro command must begin with "/ss macro" and then a space, but then you can give the rest of the macro any name you choose, in order to define any number of user-defined macros.


What can I use this for?

This features adds an extensive amount of flexibility into SpeakinSpell to allow you to do many advanced things.

User-Defined Events: The most obvious application is to announce events that SpeakinSpell is incapable of detecting automatically, such as events of human interaction including greetings, pull announcements, or battle cries.  You may use a WoW game macro (/m) to create a button that performs "/ss macro ____", and then click that button manually when you know the event has occured (or bind a key to it), for example to announce when you're about to pull, or to declare that the readycheck passed, or when you want to say hello to someone, or anything you can think of.  SpeakinSpell comes with a sample of this application for battle cries, when you type "/ss macro battlecry"

SpeakinSpell can trigger itself: Instead of creating a button, you may also use "/ss macro something" as one of your SpeakinSpell speeches for any spell or other event that SpeakinSpell announces, or even "/ss macro one thing<newline>/ss macro another thing" to have a single spell cast trigger two (or more) separate Custom Macro events every time you cast it.

Spell Groups: You may use this feature to create a group of spells which all share the same list of random speeches.  For example you could create "/ss macro fire spells" and then configure both of the events "When I start casting: Fireball" and "When I start casting: Scorch" to use a single random speech: "/ss macro fire spells".  Then put the list of speeches you want to share for those fire spells under the event "When I type: /ss macro fire spells".  Now when you cast Fireball, that will trigger "/ss macro fire spells" which will say a random speech from the same list used when you cast Scorch, because you set up Scorch so that it also says "/ss macro fire spells".

Same Spell, Different Speeches when grouped vs. solo: You may also use this feature to create separate lists of speeches for the same spell when you cast it in different scenarios.  For example if you want to say "I'm solo" when you cast Fireball when you're solo, but "I'm in a group" when you cast Fireball in a group, but never vice-versa, then you could configure "When I start casting: Fireball" to use the <newline> feature to simultaneously perform two Custom Macro events in the same speech, for example "/ss macro fireball solo<newline>/ss macro fireball group".  Then set up the event "When I type: /ss macro fireball solo" to say "I'm solo" using the Say channel when solo, but silent in the other situations.  Then do the same thing for your second event "When I type: /ss macro fireball group" but set it to only speak when you're in a group, but silent in other scenarios.  Every time you cast Fireball, it will trigger both events, one of which speaks with one set of speeches and settings only when solo, and the other which uses a separate list of speeches and settings only when in a group.
]],
},

----------------------------------------------------------------------------------------
["12. Other Events"] = {
order = 12,
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

Combat Event: Critical Strike
Combat Event: Killing Blow
- These 2 events support the following event-specific substitutions:
- <damage> is the amount of damage you dealt
- <school> is physical, arcane, fire, etc.
- <overkill> is the amount of overkill damage done by a killing blow
- Currently, killing blows are only detected based on dealing at least 1 point of overkill damage
- <name> and <eventname> are both "Combat Event: Critical Strike" or "Combat Event: Killing Blow"
- <spellname>, <spelllink>, and <displaylink> include the name of the spell or ability that you used to deal the critical strike or killing blow
- all other standard substitutions apply as usual
- Note that both of these events may be triggered simultaneously if you deal a killing blow with a critical strike.  In this case, the critical strike event will always be triggered first.

Combat Event: I Died
- This event is triggered when you die


-- NPC Interaction --
These events are related to interacting with NPCs and similar game objects such as mailboxes and barber chairs.

NPC: Open Gossip Window
- Signalled when right-clicking on most interactive NPCs
- Implemented by the Blizzard API notification event: GOSSIP_SHOW
- Many NPCs do not show this gossip window if they only offer a single option, but this event will fire in many of those cases anyway, though not 110% reliably unless there are 2 or more options in the gossip window

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

Achievement earned by me
- Supports the following event-specific substitutions:
- <achievement> is the name of the achievement
- <desc> describes the achievement
- <reward> is the reward (may be "")
- <points> is how many points the achievement was worth
- <spelllink> creates a clickable link to the achievement info
- <eventtypeprefix> is "Achievement earned by "
- <name> <eventname> and <spellname> are each "me"
- <displayname> is "Achievement earned by me"

Achievement earned by Someone Nearby
- <target> and <caster> are the name of the player who earned the achievement
- example uses include "/t <caster> grats!", "/s grats <caster>", and "/congrats <caster>"
- In this case <achievement> and <desc> use the same value as <spelllink>
- <reward> and <points> are not supported for this event
- <eventtypeprefix> is "Achievement earned by "
- <name> <eventname> and <spellname> are each "Someone Nearby"
- <displayname> is "Achievement earned by Someone Nearby"

Achievement earned by a guild member
- <target> and <caster> are the name of the player who earned the achievement
- example uses include "/t <caster> grats!", "/g grats <caster>", and "/congrats <caster>"
- In this case <achievement> and <desc> use the same value as <spelllink>
- <reward> and <points> are not supported for this event
- <eventtypeprefix> is "Achievement earned by "
- <name> <eventname> and <spellname> are each "a guild member"
- <displayname> is "Achievement earned by a guild member"


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
["13. Emotes"] = {
order = 13,
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
["14. Data Sharing"] = {
order = 14,
Summary = "Sharing your speeches, and other network communications",
Contents = [[
SpeakinSpell offers features to easily share your speeches and other creative content.

To share SpeakinSpell content:
1. Find another SpeakinSpell player
2. Send a sync request
3. Data will be exchanged silently 
4. Go to "/ss import" to browse the content you've collected.


1. Find another SpeakinSpell player...

The data sharing system uses invisible addon channels which are throttled to prevent lag, and limited to GUILD, RAID, PARTY, BATTLEGROUND, and WHISPER.

It doesn't use a global or realm-wide communication channel, but it can still be an easy way to share amongst your guild, group, and friends.


2. Send a sync request...

By default, you'll send a sync request to your guild, raid, party, and battleground when you login, and likewise, you'll receive a sync request from any other SpeakinSpell user in your guild, raid, party, or battleground whenever they login.

You can also request a sync at any time by typing "/ss sync" or "/ss sync <target>", or by using the buttons under "/ss network"

If you'd like to add more automation, go to "/ss create" where you can set up any detectable speech event to say "/ss sync" or "/ss sync <target>"

Sync requests are normally invisible, but if you'd like to be notified about sync requests and other data sharing events, you may set up announcements under "/ss create"


3. Data will be exchanged silently...

The data sharing system can exchange the following information:
- Version numbers, to let you know an upgrade is available
- The New Events Detected list of event hooks shown under "/ss create"
- The Event Table containing all of your speeches
- <randomsub> word lists

You can control whether and how much of this data to share.  Go to "/ss network" to review the options.

NOTE: The initial version of this data sharing system is not yet optimized, so it can take up to 5 minutes or more to complete the exchange.  Future versions will try to speed this up.


4. Go to "/ss import" to browse the content you've collected...

Your alternate characters' speeches are also available under "/ss import"

You can choose to use any one piece or group of content you like, or simply read it for inspiration to write your own, wittier speeches.
]],
},

----------------------------------------------------------------------------------------
["15. Change History"] = {
order = 15,
Summary = "Where to look for the change history",
Contents = [[

See \Interface\Addons\SpeakinSpell\ChangeLog.txt for complete version history at the major feature level

Consult the changes documented on the website for more detailed change history at the code file level.
Click on "Changes" at the following link:
http://wow.curse.com/downloads/wow-addons/details/speakinspell.aspx
]],
},

----------------------------------------------------------------------------------------
["16. Version Number"] = {
order = 16,
Summary = "How to Interpret the Version Number",
Contents = [[

The current version number is displayed on the General Settings screen, and shows in the chat when you login.

The SpeakinSpell version number is composed of the WoW client version number that SpeakinSpell was built and tested against, followed by an incremental SpeakinSpell version number.

For example the last time I updated this description, the current version of SpeakinSpell was 3.3.5.02, I tested it in WoW client version 3.3.5, and it's my second update to SpeakinSpell since that patch to WoW (about a week ago now).

Beta releases are generally stable and personally tested, but means I have less confidence about it being bug-free.
]],
},

----------------------------------------------------------------------------------------
["17. Non-English Game Clients"] = {
order = 17,
Summary = "Does SpeakinSpell work in my language?",
Contents = [[

How to Setup SpeakinSpell in Any Language

If SpeakinSpell has not yet been localized into your native language, don't worry, it can still work for you.

The core design concepts in SpeakinSpell which enable it to work on any spell for any class also enable it to work in any non-English version of the WoW game client. The slash commands and labels in the options interface will of course appear in English, as well as the default example spell settings and random speeches. However, the core functionality of detecting user-selected spells and events, and announcing them with user-defined speeches, will continue to function in any language.

If you would like to contribute to the effort to translate SpeakinSpell into your native language (or game-client language, or any language you can speak) a website tool is setup for that purpose here:
http://www.wowace.com/addons/speakinspell/localization/
]],
},

----------------------------------------------------------------------------------------
["18. Origin Story"] = {
order = 18,
Summary = [[The Origins of SpeakinSpell
(or... Lame Story of a Thanksgiving Dream)]],
Contents = [[

The Origins of SpeakinSpell
(or... Lame Story of a Thanksgiving Dream)


The name SpeakinSpell is a play on a common mode of speech in the American Midwest, also commonly used by the Dwarves of Azeroth, where we tend to drop the 'g' from words ending in "ing" and say Speakin' instead of Speaking.  So a Speakin' Spell is a spell that speaks.

SpeakinSpell is also intended to be a reference to an educational children's toy that I grew up with in the early 1980s.

http://en.wikipedia.org/wiki/Speak_&_Spell_(game)

SpeakinSpell was written entirely from scratch using Ace3 libraries and tutorials that I found online, and following some examples of code fragments and addon architecture concepts from Titan, Omen, and Recount. (all addons that I highly respect)

It was inspired by class-specific addons like Cryolysis for mages or Necrosis for warlocks.  The author's main character is a mage (Stonarius of Antonidas) and I, the author, quite enjoyed the humor of using the random speeches feature of Cryolisis2, particularly for announcing Ritual of Refreshment using my own customized random speeches, most of which were inspired by the advertising language I found on food boxes in my kitchen (for example a box of cereal that said "It's Cinnamontastic!™".  Seriously, I kid you not, they trademarked the word Cinnamontastic LOL)

Unfortunately, Cryolisis2 broke down when WoW 3.0 was released, and I was disappointed that the random speeches feature was not planned to be restored by the new author in the updated rewrite of Cryolysis3.  Something had to be done about that...

I also preferred to write my own customized random speeches for Cryolysis2, but the only way I had to do that was to edit LUA files, where my changes would always be lost whenever I installed a new updated version of the addon, which would of course overwrite the LUA files and destroy my changes.

So I dreamed of an in-game interface to edit the speeches, in a way that they would be saved in the SavedVariables files where they would be safe from changes to the supporting LUA code (which are necessary to keep addons running from patch to patch), so that future patches would not destroy the custom speeches that I had spent hours writing into the wittiest possible things I could think of to say about the spells that I was casting.

I also found (with Cryolisis2) that while Polymorph announcements could be nice in a 5-man group, they became quite annoying in 25-man raids when resheeping the same mob 20 times in a row throughout the same combat, in which situations I was often asked to turn it off.  Finding that a bit of a hassle to change the settings every time I joined or left a raid, I dreamed of having that logic built into my spell-speaking addon.

I dreamed about making that addon for a long time, maybe almost a year, but dreaded facing the learning curve.  Even though I have 11 years XP in C++, learning to program in LUA is like relearning how to play paladin after the 3.0 patch, and I just didn't feel like tackling that.  But then one day I randomly thought of the Speak & Spell toy, and thus the addon name Speakin' Spell, and thought "OK, that seals it, now I absolutley MUST make that addon" and the next day began the long weekend of Thanksgiving 2008, giving me ample time...

And so SpeakinSpell was born.

Thank you for using SpeakinSpell.  It's Mannabiscuitalicious!™ :P

er... ummm... compatible with WotLK and level 80 now... so uh...

Thank you for using SpeakinSpell.  It's Manastrudeltastic!™ :P
]],
},

----------------------------------------------------------------------------------------
["19. Credits"] = {
order = 19,
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


--ATTENTION TRANSLATORS:
-- When the user types an invalid /ss command
-- the interface options window will be opened to display this chapter of the user's manual defined above
-- to show which are the valid slash commands
HELPFILE.SLASH_COMMANDS = 4

