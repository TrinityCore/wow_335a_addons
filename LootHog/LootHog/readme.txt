LootHog detects and tracks rolls which are made with '/random' or '/roll' and sorts them, allowing raid leaders to announce roll winners quickly and easily.

Features/Options
################

* Automatically show window when someone rolls (optional)
* Announce configured settings and rules to party/raid
* Configurable timer: Starts when the first roll is detected (or Loothog Started manually).
* Announce that new roll has started, and announce the time players have to roll.
* Announce Offspec roll if no winners for the inital roll.  Separately configured timeout and Announcement.
* Configurable Offspec Range
* Prevent /random rolls from appearing in the chatlog
* Acknowledge rolls via /whisper to roller
* Count rolls from group members only or entire raid
* Reject rolls with bounds other than those configured
* Reject multiple rolls
* Ability to "Hold" timer.  After releasing the timer, timer will restart from where it left off.
  -  OR if AutoExtend is turned on, it will restart from configured time if timer is lower.
* Countdown - Manually activated or can start in the last few seconds of timer (configurable)
* AutoExtend if roll is detected in the last few seconds of timer (configurable)
* Finalize rolling and announce winner after configurable timer expires
* Finalize rolling when all group members have rolled
* Assign Loot to winner
* Announce the group of the winner (Raid)
* Submit complete list of rolls to chat when announcing
* Deactivate LootHog if someone else announces  (using Loothog)
* Close LootHog window after announcing a winner
* MyAddon - Support
* Support for "Offspec" roll boundaries
* Mode button - "Off", "Quiet", "Auto", "Manual"

Commands:
#########

/lh or /loothog
open the LootHog window

-  Note: All slash commands can be accessed via /lh or /loothog

/lh options
/lh config
Open the options screen

/lh enable - Turns loothog on or off
/lh roll - Roll using the configured boundaries
/lh offspec - Roll using the configured offspec bounaries
/lh countdown - Starts countdown
/lh kick - Kicks the top roll from consideration
/lh clear - Clears all rolls ready for next set
/lh hold - Holds the countdown at current time
/lh announce - Announces the winner (and top rolls if configured)
/lh assign - Assigns loot to the winner (raid only)
/lh notrolled - Lists the members of the party not yet rolled
/lh list - Lists number of rolls as configured.
/lh start - Starts roll sequence without first detecting a roll
/lh start <itemlink> - Starts roll sequence without first detecting a roll and announces item being rolled for.
	-  Can also use /lh <itemlink>
/lh help - Shows list of slash commands
/lh reset - Reset all settings back to default

Optional Extras
###############
Titan Users can get the Titan Plugin Here : http://wow.curse.com/downloads/wow-addons/details/titan-loothog-3_2_0.aspx
				
Authors:
#######
IronEagleNZ aka Leucocepha@Serenity on Proudmoore


Special Thanks to:
##################

Chompers - for the original addon
Suan(Kaz'goroth) - for addition code
Codeus - Coding
dblixer - Offspec Coding
Erytheia - Code Cleanup, Testing
Devilcat - Bugfixes
m0rgoth - french translation
ShyMun - Spanish translation
Ufi82 - German translation


IMPORTANT!
##########

I'm not the original creator of the addon.
Full Credits goes to Chompers for the idea and initial creation!

Changelog
#########
3.3.3
-----
* Updated TOC to current Version
* FEATURE CHANGE: Offspec Range is now configurable - Thanks to dblixer
* NEW FEATURE: New "Quiet" mode - Operates as old school Loothog.  Counting rolls, but no spam to chat.
* NEW FEATURE: Assign!!!
		-  Must be in a Raid
		-  Must be Loot Master
		-  Must have loot window open
		-  Must have started LootHog by /lh <itemlink> /lh start <itemlink> or "Start" button.
		-  Announce button will change to "Assign" at conclusion of rolls.  
			-  Will return to "Announce" after assigning loot
			-  Will return to "Announce" if new roll is started
		-  Option to Auto Assign
* UPDATE: Added Icecrown Citadel tokens to the token list (Announce valid classes, reject invalid classes)
* TRANSLATION: Spanish Translation thanks to ShyMun
* TRANSLATION UPDATE: German Translation thanks to Ufi82
* BUGFIX:  Reported bug "attempt to perform arithmetic on global 'loothog_current_interval' (a nil value)"
		-  I was unable to replicate this error but have hopefully implemented a fix for it anyway.

3.3.0
-----
* BUGFIX: Rolls of "0" (ie. when someone types pass) are no longer considered a winning roll
* BUGFIX (Sort of) : Using Manual Mode will stop the rolls being cleared if someone rolls after the timeout has expired.

* CHANGED SLASH COMMAND: Changed "/LH Activate" to "/LH Start" - This makes more sense to me, and easier to type. 
			 /LH Activate will still work if you prefer

* FEATURE CHANGE: On/Off button is now "MODE" button.  This will toggle through, On/Off/Manual.  Window title modified to display mode.
		- "ON" - Loothog will automatically detect new rolls.
		- "Manual" - Loothog will wait until it is told to start. (/LH start, /LH <itemlink> or "Start")
* FEATURE CHANGE: If Loothog is not active (not counting rolls), the "Countdown" button will display "Start"
		- Button will change to Countdown after Loothog detects a roll (Auto) or you manually start roll collection.

* NEW FEATURE: "Manual Mode" - 	Can be turned on by the Mode Button or in the Global Options Menu.
* NEW FEATURE: "Announce All Loot" A new button in the middle of the Loothog Window will announce all loot in a Raid Warning.
		-  Off by default.  Can be turned on in the Global Options.
		-  Option to only display if you are the Master Looter
		-  If you do not have Raid Warning rights, Loot will be linked into normal chat window.
		-  Button will hide when Loothog is started to not obscure the rolls
		***** NOTE: I am not overly happy with the position or look of this button.
			    I thought it would be useful for some people though, and have run out of places to put it.
* NEW FEATURE: If loot Window is open, pressing the "Start" button or typing /LH start.  Will link the last item in the loot window.
		- Example:  This is the same as typing /LH <itemlink> for the bottom item.
			 -  This is over-ridden by /LH <itemlink> if you want to start a roll for a different item.
* NEW FEATURE: New rolls are announce with a raid warning.
		- Only when an item is included in the announcement by using /LH <itemlink>, /LH Start or "Start" with an open loot window.
		- You must be promoted (Raid Leader or Assistant).  If you are not, announcement is made in normal chat window.
		- If there is no itemlink associated with the roll. (ie. New roll detected automatically) announcement is in the normal chat window.
* NEW FEATURE: AUTO OFFSPEC - If there are no winning rolls, Loothog will announce an Offspec Roll.
				- Remember a "Pass" is no longer considered a winning roll
				- Can be enabled in the Roll Handling Options
				- Timeout must be enabled
				- Individually configurable offspec Announcement (Required)
				- Individually configurable Offspec Timer (Required)
				- Enabling Offspec Roll boundaries will disable Auto Offspec
				- Enabling Auto Offspec will disabled Offspec roll boundaries

* NEW OPTION: In the Roll Handling Options: "Tell me when a roll has been rejected" Turns off the local chat message for rejected rolls.
* NEW OPTION: In the Global Options: "Override default refresh interval" Allows you to change the refresh interval.
		- Why you are playing WoW with less than 10 FPS though, I don't know. :P
* OTHER NEW OPTIONS: In the Roll Handling Options you can turn on Auto Offspec.  
		   - All three options will be enabled/disabled at once. Tick boxes are there simply to show that it will happen.
		   - Disabling the Loothog Timeout will also disable the Auto Offspec Options.
* ADDITIONAL THANKS: 	Additional thanks to DevilCat for assisting with the Bug Fixes, making my job a little easier.
			Hopefully this addon will make your job a little easier when giving out loot.

3.2.0
-----
* ALL CONFIGURATION OPTIONS HAVE BEEN MOVED TO THE DEFAULT BLIZZARD ADDON OPTIONS INTERFACE
  =========================================================================================
* BUGFIX: Support for rejecting classes for all localized languages.  Note: This will not work until Localization is updated
* BUGFIX: Debug information in previous version has been removed

* NEW FEATURE: Off/On Button.  Toggle Loothog Off and On from the main window
* NEW FEATURE: Boundaries are now configurable, (Default: 1 - 100)
* NEW FEATURE: Support for OffSpec Rolls.  
	NOTE: 	Offspec boundaries are the same range as Onspec with the low boundary one higher than Onspec (ie. Onspec: 1 - 100, Offspec: 101 - 200)
		When Offspec is enabled, a new button will appear to offspec roll
* NEW FEATURE: Can announce rules to party/raid based on Loothog settings.
	NOTE: 	Additional button on main window to announce rules
* NEW FEATURE: Additional settings available for rules announcement (eg. One Set piece, One Epic etc)

* Added slash commands :	/loothog enable (Turns loothog on or off)
				/loothog roll (Rolls with the configured boundaries)
				/loothog offspec (Rolls with the configured offspec boundaries)
				/loothog reset (Reset all settings back to default)
				/loothog help (Shows list of slash commands)
* Added Information : List of Slash commands in Options Interface


3.1.4
-----
* BUGFIX: No longer announces twice in certain situations
* BUGFIX: No longer announces extension while timer on hold
* BUGFIX: Now remembers settings for "Enabled loothog" and rejecting out of bound rolls.  
	NOTE:  These options are now defaulted to off.  You will need to enable these if you are a new user of loothog.
* Added slash commands :	/loothog activate  (Manually starts roll sequence without detecting a roll)
				/loothog activate <itemlink> (/loothog <itemlink>) As above, announces item at start and end of sequence
* Added functionality for "/loothog activate <itemlink>" :		Option to announce valid classes for weapons/armour/tokens (trinkets, totems, Idols, Rings, Neckpieces etc not included)
									-  Announce can be configured to only announce for tokens
									Option to reject rolls from invalid classes
									-  Announce rejected rolls option will announce for out of bounds rolls and classes
* Added option to clear rolls when closed.  This will clear the rolls if manually closed or set to close on announce

3.1.3
-----
* BUGFIX: loading old settings from a previous version should now work
* BUGFIX: design-changes in the option window 
* some minor changes in the localisation files


3.1.2
-------
* BUGFIX : Current rollset will clear when Countdown is clicked if timeout expired or winner has been announced


3.1.1
-------
* Changed Option "Announce on Clear" to "Announce on Start".  Clearing the rollset will still announce
* Added an option to announce the timeout when new roll set started
* Countdown logic changed.  Added option to turn on/off Auto Countdown
* Clicking countdown manually will advance timer to configured countdown time
	- If Timeout is disabled clicking countdown will start countdown at configured time
* Second click of countdown will "silence" the countdown
* Added slash commands : 	/loothog countdown
				/loothog kick
				/loothog clear
				/loothog hold
				/loothog announce
				/loothog notrolled
				/loothog list - Lists number of rolls as configured.
  Addon should now be able to be fully functional without opening window if you prefer
* Option to change the number of rolls to announce.  Was previously all in raid.  (Too much spam for 25 man raids)
* BUGFIX : New rolls will no longer reset timer
	-  If a new roll is detected when timer is below threshold, option to reset to threshold.
* BUGFIX : "Hold" will no longer reset timer, unless timer below threshold and configured to do so
	-  Threshold is configurable.
* Clicking Clear no longer automatically closes the loothog window.
* Added option to finalize when all group members have rolled.

3.1.0
-----
* Only in raid the group number is announced - not only on loot master
* Small Size-Bug corrected - Main Window should now a little bit smaller
* Should now work with a spanish client (not fulled tested! and still not complete translated)
* Move Version to 3.1 - because a old 3.0.0 version exist
* Change title of main window to "LootHog Rolls"
* Show and Option-Button in Interface/Addons
* MyAddons - Support moved into the toc file
* Add "/lh config"
* Little Layout-Change in config window.
* Timeout now announced in chat, when "Finalize rolling after timeout expires" is activ
* Now the countdown start value can be set 

2.7.1
-----
* "Group 1"/"Group not found"-Translation is now possible
* Add support for localization (koKR, zhCN, zhTW, ruRU, esES, esMX)
  (at the moment nothing is translated! when you have translated one file, please
  send it to me (info (ad) gpihome.de)

2.7 (Susan)
-----------
* Update Toc