Factionizer - A faction reputation management tool
--------------------------------------------------

History
-------
On August 10 2007 john.ra reported in alt.games.warcraft the URL of
the following reputation calculator.

	http://reputation.mygamesonline.org/

I thought it was awseome. Unfortunately it went offline for quite some time
due to over-traffic and during that time I had the idea that it would be
very neat to have something like this, especially considering that the
information to calculate everything was more or less available from the
WoWWiki faction pages.

Urbin, Dun-Morogh (EU)


Features
--------
This addon displays how many reputation points are missing to the next
reputation level in your reputation window. In addition, it extends the
reputation detail window by showing how many points you need for your
next reputation level and how you can best gain this reputation.


Thanks
------
To Shanti, Luidor/Dougi and Milamber of <Hüter des weißen Feuers>,
Syrenia of <Orden des Blutraben> and Tattoo of <Dark Desire> of
EU-Dun Morogh for their help on localising the faction names.


Sources
-------
All information regarding the reputation gained for each faction comes
from http://www.wowwiki.com/Faction. German localisation of quests, mobs
and items come from http://www.buffed.de/


Slash commands
--------------
/fz help	Show supported slash commands
/fz about	Show version info
/fz urbin	List all addons by Urbin
/fz status	Show configuration status
/fz enable | disable | toggle <setting>
	<setting>	Enable/Disable/Toggle showing of
				mobs
				items
				quests
				instances | dungeons
			that give reputationg ains
	<setting>
	missing		Missing reputation text in reputation frame
	details		Extended reputation detail frame
	chat		Extended reputation gain chat message
	suppress	Suppress original reputation gain chat message
	all		Include all <settings> in enable/disable/toggle
/fz list		Show list of all factions grouped by standing
/fz list <standing>	Show list of all factions with wich you have
			the given standing

/fz phase [1-4 | all | clear ]	Define which phase the Shattered Sun Offensive
				is currently in. All sets all phases and sub-
				phases to completed
/fz sso [1-4 | all | clear ]	same as /fz phase <command>
/fz phase2b [ 0-2 ]		Define subphase 2b (Sanctum)
/fz phase3b [ 0-2 ]		Define subphase 3b (Portal)
/fz phase4b [ 0-2 ]		Define subphase 4b (Anvil & Forge)
/fz phase4c [ 0-2 ]		Define subphase 4c (Sanctum)


Todo list
---------
- add item tooltips to show what they can be used for [low prio]
- add about, history, todo frames [low prio]
- add limit numbers for timbermaw, aldor, sha'tar rep
- use Ace for localisation (suggested by Chaoslux) [low prio]
- 4 digit numbers in last column are cut off:
  http://img205.imageshack.us/img205/4896/ishot0803061gp6.jpg
  (reported by anavolver)
- check if reputation calculation is correct (reported by CYPSYAN)

- "Aww, it appears Factionizer doesn't work with the Shattered Sun anymore.
  I'm using a German client and it always states there is no information on
  this reputation level/this faction :(" (reported by ckaotik)
- "Another thing I noticed: You can only earn Sha'tari reputation by giving in
  Aldor/Scryer Quests until one point before honored." (reported by ckaotik)

- add option to "show as experience bar" when faction gain is detected
  (suggested by SilverShadow)
- add support to show "till exalted" instead of "next level" (suggested by
  LunaCeleste and Fudge)
- add support for AddonLoader
  (http://wow.curse.com/downloads/wow-addons/details/acp.aspx,
  http://www.wowwiki.com/AddonLoader) (suggested by Xanobia)

- get french, spanish and russian localisation for "Ashen Verdict"
- get russian localisation for the new hated to unfriendly Steamwheedle quests
- get russion localisation for various new quests and spillover dungeon entries
- add WotLK spillover reps for alliance/horde factions in russian localisation


Version history
---------------
30300.3
- cleaned up WotLK alliance and horde main factions including spillover
  250 rep for their own faction
  125 for their "umbrella factions"
  62.5 for their sister factions
- updated Steamwheedle rep gains to start at Hated (reported by Fudge)
- added Hated to Unfriendly quests for Steamwheedle Cartel
- updated Commendation Badges for patch 3.3
- updated Wyrmrest for patch 3.3
- updated Sons of Hodir for patch 3.3
- updated Knights of Ebon Blade for patch 3.3
- updated Argent Crusade for patch 3.3

30300.2
- added 4 Argent Tournament quest for the Frostborn and Explorer's League
  for 125/2 rep each
- Kirin Tor cooking daily updated (up to 195 from 150 rep)
- Kirin Tor jewelcrafting daily updated (up to 32 from 25 rep)
- added Ashtongue Deathsworn rep (8k for full clear) (reported by Choam)


30300.1
- adjusted toc for patch 3.3
- added "Sons of Hodir Commendation Badge" for 500 rep
- added "Waterlogged Recipe" for 250 Kirin Tor rep
- fixed Arathi Basin wins from 2000 to 1600 resources (reported by Choam)
- fixed Arathi Basin quest from 200 to 160 (reported Codex)
- added Ashen Verdict as Faction (not yet localised, details added yet)

30200.4
- moved the whole chat frame on event hook to the new chat filter system
  in the hope that this will solve the various issues with the chat hook
  (contributions by Wilgorix and Tandanu)

30200.3
- added esMX in parallel to esES
- really fixed arg12 passing to chat event handler (reported by funkydude)

30200.2
- added daily BC quests for consortium rep
- added russian quest text, fixed russian faction name encoding (thanks
  a huge bunch to Bagdad)

30200.1
- fixed faction name from "Silvermoon" to "Silvermoon City" and "Defilers"
  to "The Defilers" (reported by eworikum)
- spanish localisation of faction names (curtesy of Syldavia of Uldum)
- added arg12 to obsolete chat handler due to added coloured names in chat
- fixed toc for patch 3.2

30100.3
- russian localisation of faction names (curtesy of Alifar)

30100.2
- adjusted rep for Sethek Normal (reported by Skyfawn)
- adjusted rep for Twilight cultists (reported by Motoss)
- localised Argent Tournament quests
- fixed Pa'Troll (proper name Troll Patrol)
- added Commendation Badges that can be gotten for Champion's Writs (reported
  by Speeddymon)

30100.1
- fixed toc for patch 3.1
- added Dalaran fishing daily for Kirin tor

30008.4
- fixed lowest possible rep from 0 to 1 for Free Knot and Gordok Ogre Suit
  in order to properly show up (reported by Chaoslux)
- completed french faction names (thanks to the Armory)
- various corrections (reported by Motoss and athenalesa, elaborated
  excellently by Chaoslux):
  - fixed "The Mag'har", it was missing the article
  - fixed Bloodsail Bucaneers (now lists quests starting at hated instead of
    neutral)
  - fixed Syndicate (now lists quests starting at hated instead of
    neutral)
  - fixed Magram and Gelkis clan centaurs (now lists quests starting at hated
    instead of neutral)
  - added Horde Expedition and Alliance Vanguard

30008.3
- revised Brood of Nozdormu rep gains (reported by quantorsht)
- some more missing german localisation (reported by toxxic1975)
- added "Can't get Ear-Nough" which gives 150 Cenarion Exp rep (reported
  by Alisiya)

30008.2
- fixed name of "The Scales of the Sands" (reported by Chaoslux)
- changed "Thrusting Hodir's Spear" to give 500 rep instead of 350
- added championing gain (suggested by nintodne)
- Free Knot! the quest in Dire Maul gives 350 rep with all four goblins, from
  0 Hated to 999 Exalted, as well as Gordok Ogre Suit giving 75. (Chaoslux)
- Epic Darkmoon Decks gives 350 rep upon turn in, as well as the low level
  decks (Rogues,Mages,Swords,Demon) give 25 rep, till 999 exalted. (Chaoslux)
- localised WotLK entries for deDE
- fixed The Scale of the Sands for english localisation as well (german had
  been fixed earlier)
- fixed Explorer's league
- fixed various typos and quest names

30008.1
- added Commendetion Badges given for normal level 80 daily dungeon quests
  (reported by nintodne)
- added daily level 80 normal and heroic dungeon quests
- added Vrykul Bone quests for Ebon Blade (reported by nintodne)
- added "Shoot them up" for Ebon Blade (reported by RenScotson)
- removed distinction between grey/non-grey mobs as all mobs now give full
  rep (pointed out by mysticalos)

30003.2
- added scale of sands mobs (in addition to full clear) (suggested by Chaoslux)
- updated various northrend factions
- added field to show reputation needed until exalted

30003.1
- added first Northrend factions and daily quests for some of them
  (what I found on WoWWiki so far, still a bit shaky, I guess)

30002.2
- added command /fz sso all to bring all Shattered Sun phases to completed
  (suggested by SilverShadow)
- updated various reps (Timbermaw, Steamwheedle cartel, Sporegar, Argent
  Dawn)

30002.1
- adjusted toc for patch 3.0.2
- changed code to match all the API changes of patch 3.0.2
- fixed Shattari Skyguard quests in BEM
- fixed title of "The not-so-friendly skies..."
- fixed number of [Netherwing crystals] to 30

20400.8
- fixed heroic slave pens and underbog not being listed as giving rep for
  CE when revered in locales other than deDE (reported by CYPSYAN)
- reduced rep for Multiphase Survey from 250 to 150 (reported by Elvenblood)
- fixed heroic ramparts & blood furnace being available at honored
- fixed sethek halls and auchenai crypt availability
- fixed heroic shadow lab reputation

20400.7
- added Nagrand PvP Quests (reported by CYPSYAN)
- name of phase 4c fixed
- localised some phases in german
- added possibility to exclude some quests from the summary in order to better
  show how long it takes to the next reputation level if one does not do all
  daily quests (suggested by Tony M)

20400.6
- fixed some of the deDE localisations of faction names
  (based on data provided by Hatryn)
- full deDE localisation of all quest/mob/item data (using www.buffed.de)

20400.5
- now showing active quests in colour so it should be easier to
  estimate how much reputation you're likely to get when finishing
  them
- changed header in Blizzard's reputation window from "(Missing)"
  to "(to next)" (in the german localisation from "(Fehlend)" to
  "(zur nächsten)" as this caused a lot of confusion (people thought
  it was an error message
- made chat frame to which messages are printed configurable (suggested
  by dylanparry)

20400.4
- updated Shattari Skyguard reputation gains (reported by Samrec)

20400.3
- fixed bug when displaying status (reported by Linmaris)
- fixed german localisation (umlauts to UTF) (reported by Linmaris)

20400.2
- filtering quests for Shattered Sun Offensive based on phase
- fixed bug that disallowed expanding the "Inactive" reputation group

20400.1
- added Shattered Sun Offensive reputation
- "Uncataloged Species" now only listed to give Cenarion Expedition until
  honoured (reported by hohner)
- updated TOC for patch 2.4.0
- added possibility to list all addons by Urbin

20300.2
- fixed FIZ_Entries nil exception (reported by Eanon)

20300.2
- tooltip now shows how long a quest/instance/mob/item yields reputation
- updated frostsaber rep (reported by sir-markus)
- corrected incorrect help display (reported by Ken)
- reputation for WSG and AB wins (reported by Brutalisdk)
- added #Note keyword to TOC for WoWUiUpdater (suggested by Chmee)
- added "/fz de" command to show german standing names for people like
  me who are playing on a german speaking realm using an english client
- fixed spelling for various item names
- added Tanaris pirates who give steamwheedle cartel rep
- added coilfang reservoir instance rep gains
- added Sporeggar rep mobs
- added rep for various heroic instances

20300.1
- added new instances and mobs for some outland factions

20300.1
- fixed TOC for patch 2.3.0

20200.5
- added possibility to sort reputation frame by standing

20200.4
- doubled Timbermaw Hold, Cenarion Circle, Argent Dawn Reputation (patch 2.2)
- Fixed various typos in quest names
- added /fz list <standing> command to show all factions with which you have
  a certain standing

20200.3
- showing reputation in bags, bank and completed quests as a small grey bar
  in the reputation window
- fixed various quest names
- localised the options button
- completed tooltips for options

20200.2
- adjusted reputation from 250 to 350 of "The Relic's Emanation"
- added consideration of completed (non-item) quests
- added buttons to collapse / expand all entries
- added buttons to show / hide all types of reputation gain methods
- improved displayed list (showing items carried that can be used in list)
- added key binding to open reputation window and reputation detail window
  at the same time

20200.1
- fixed TOC for patch 2.2.0
- detail frame is now showing experience gained in the current session
- added slash commands to enable/disable settings
- fixed suppressing of original chat messages (works now)

20103.7
- now showing "preview" reputation available due to bag and bank contents
  (suggested by LoTekGuru and ASKF)
- added repeatable AV PvP and old world main faction quests
- added 10% bonus for Humans (reported by CatrionaR)
- added Scryer, Aldor and Sha'tar single mark turn-ins (reported by CatrionaR)
- extended tooltip to show details for each way to gain reputation

20103.6.1
- fixed typo in FIZ_DumpReputationChangesToChat()

20103.6
- added missing tooltips for option window
- removed dummy entries for Ironforge
- added key binding to open options

20103.5
- Showing spillover reputation (reputation gained for all factions), when
  any reputation is gained at all (suggested by CatrionaR)
- added configuration options

20103.4
- All Factions but "Syndicate" localised in deDE. The Addon will now work
  with the German client, even though the hints will contain the English
  names of quests, instances and items
- fixed some flaws in the German localisation.

20103.3
- added checkboxes to filter Q/D/M/I information
- added text to indicate if no information for a faction is available
- prepared code for localisation
- fixed a bug where the detail window was not updated when reputation
  values changed
- German localisation of output texts done (but still missing faction
  names, so the German version won't work; also, still missing German
  texts for all the data)

20103.2
- added items category
- added limits
- extended reputation window with missing reputation
- /fz displays selected or watched faction info if not faction name is
  specified


20103.1
- first version
