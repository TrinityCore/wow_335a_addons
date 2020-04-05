[[Category:Addons]]
{{Addon Infobox|{{PAGENAME}}}}


== Decursive 2.1 ==

Main download: [http://www.2072productions.com/?to=decursive.php official web site]  --- [http://www.2072productions.com/outpages/?to=Decursive-2.1.Archa.exe&download=1 Autoinstalling version for windows] --- [http://www.2072productions.com/?to=decursive-newsletter.php Decursive Newsletter] 

Questions, bug reports, etc... --> [http://www.wowace.com/forums/index.php?topic=4328 Ace forum discussion thread]

----

This is a cleaning mod. Its job is to help a class that can remove afflictions
to do it with ease in every conditions (playing solo, in small groups or in big
raids).

Decursive is dedicated to the memory of Bertrand Sense known as Glorfindal on
the European server Les Sentinelles.
He was the raid leader of [http://www.wow-horizon.org our guild]

----

===  Decursive Main Features  ===

* Support all cleansing spells in all localizations.
* Minimal memory and CPU usage in all conditions.
* Users can choose the types of affliction they want to cure and prioritize them.
* Mages can Sheep mind-controlled players.
* Druids can Cyclone mind-controlled players.
* Two solutions available to cleans afflictions: Macro and Micro-Unit Frames (MUFs)
* Cleansing macro auto-configuration (cure people by mouse-overing and hitting a key)
* User customisable debuff filtering system.
* Easy configurable player priority and skip list.

* Powerful interface:
** Highly customizable (scale, transparency, etc...)
** Saves screen real estate, Decursive interface is very discreet.
** Multiple alert system: visual and auditive.
** Clever ordering of micro-unit-frames to maximize cleansing efficiency.
** Show player classes and status (in range, cloaked, afflicted, Mind-controlled)
** Very simple and intuitive.
** Tool-tip help system for options and actions.

* Ace2 framework: Uses the powerful Ace2 libraries.
** Decursive options are accessible through a drop down menu or a static option panel.
** Option can be saved/loaded to/from different profiles.
** Optimized event management system and more...


To have details about all these features, read what follows.

Currently Decursive is configured to automatically select Druid, Priest, Mage,
Paladin, Shaman, Felhunter, and Doomguard cleansing spells. Mage are also able
to monitor mind controlled unit and sheep them if needed.



==== The Micro-Unit Frames (MUFs) ====

Decursive makes your life easier, it clearly shows you who is afflicted by
something you can remove, this is done using "Micro-unit-frames" (MUF): a
micro-unit-frame is a little square on your screen that changes of appearance
according to the unit status.  If you click on a MUF, it automatically cast a
cleaning spell, the choice of the spell depends of the mouse button you click,
Decursive manages the button mapping automatically.

===== MUFs have several colors: =====

* '''Full red''': the unit is in range and is affected by something you can cure by left-clicking on the MUF.

* '''Transparent red''': the unit is out of range and affected by something you could cure by left-clicking on the MUF.

* '''Full blue: idem as red but with right-clicking instead of left-clicking.

* '''Full orange: idem as blue or red but with ctrl-left-clicking.

* '''Transparent grey: The unit does not exists.

* '''Dark Transparent green: the unit is in scan range and is not afflicted by something you can cure.

* '''Transparent purple: The unit is too far to be scan or cured.

* '''Transparent light-green: The unit is cloaked.

* Any color but with a little '''green square''' in the middle : the unit is MIND-CONTROLLED.

* '''Black''', the unit has been blacklisted because it was out-of-sight when you tried to cure it, the time in blacklist can be change in the options.

''The informations above are also indicated by tool-tips in the game.''

MUFs display is done according to your settings, you can change their number
and size easily (only when not in combat).

MUFs are very discreet when no action is required, you can see right through
them.

You can change the spell mapping when you are not in combat, the mapping is
done according to your cure priorities ; go to the "curing options", the
priorities are indicated by green numbers in front of the affliction types.

Besides casting, MUFs allow you to target the units by middle-clicking,
ctrl-middle-clicking will focus them. (To clear the focused unit, use the
command /clearfocus)

MUFs are organized intelligently by default, you're always first then the rest
of your group, the groups after yours, the group before yours and the pets (you
can choose to monitor them or not) and, at last, your focused unit (changed
using the command /focus 'name' or by ctrl-middle-clicking on a MUF).
You can completely change this order by using the priority and skip list, a
very manageable list of players.

Decursive has been written with optimisation, quality and performances in mind,
it should not affect you refresh rate at all.


----
'''IMPORTANT:'''

'''TO MOVE THE MUFS, ALT-CLICK AND HOLD THE HANDLE JUST ABOVE THE FIRST MUF (IT'''
'''HAS THE SAME SIZE AS A MUF AND HIGHLIGHTS WHEN YOUR MOUSE POINTER IS OVER IT).'''

'''This handle has several uses, a tooltip explains them all.'''
----

=== Decursive's MACRO ===

Decursive also creates and manages a macro that allows you to cure units (or
other unit frames) you mouse-over, you choose the key in Decursive's options.
Hitting the key alone will try to cast the first spell, ctrl-hitting, the
second and shift-hitting will try to cast the third. Decursive will show you
if the unit beneath your cursor is afflicted by something through its
'live-list'. You can also take the macro and place it on one of your action
bar using the default Macros window.

'''NOTE: To change the key, use the graphical menu, the graphical menu is accessed
by right-clicking the handle or the "Decursive" bar.  You can also use the
command line for exemple, "/dcr macro SetKey V" wlll set the new key to [V].'''


Decursive uses the expertise of the Ace2 libraries (those libraries are
embedded, you don't need to install any dependency).

Many options are available, don't forget to try them.

'''Decursive also have a skip list, people in this list will be completely ignored and not displayed in the MUFs.'''
----
=== Decursive's commands ===

''Commands you can use:''

; ''/DCRSHOW''
: To show main Decursive bar (also available by right-shift-clicking the MUFs handle)
: Note that this bar is also the anchor of the live-list (moving this bar moves the live-list).

; ''/DCRHIDE''
: To hide the Decursive bar (leaving live-list displayed)

; ''/DCROPTIONS''
: To show a static option panel

; ''/DCRRESET''
: To reset Decursive windows position to the middle of your screen (useful
: when you loose a frame)

; ''/DCRPRADD''
: Add the current target to the priority list

; ''/DCRPRCLEAR''
: clear the priority list

; ''/DCRPRSHOW''
: Display the priority list UI (where you can add, delete, move players)
: (Ctrl-left-clicking the MUFs handle does the same)

; ''/DCRSKADD''
: Add the current target to the skip list

; ''/DCRSKCLEAR''
: Clear the skip list

; ''/DCRSKSHOW''
: Display the skip list UI (where you can add,delete,clear)
: (Shift-right-clicking the MUFs handle does the same)

'''NOTE:'''
All these commands can also be bound to a key through the key-binding
WoW interface.
----

=== What you can do ===

* '''in main Decursive bar'''<br>
Middle-Clicking or ctrl-left-clicking on the label "Decursive" will hide
the buttons and lock the frame and the live-list.
Alt-Click to move the bar and the live-list.

* '''In WoW key binding interface'''<br>
You can bind a lot of things to keys under "Decursive" section.

* '''Bind the decursive macro to a key'''<br>
This is done through Decursive menu options (Decursive maintain its macro
and update it according to your settings and capabilities)

Hitting the bound key will cure the unit under your mouse pointer (the
key alone is the first spell, use ctrl+key for 2nd spell and shift for
the third)

* '''The MUFs'''<br>
If you've displayed the Micro-Unit-Frame (on by default) you can click on the micro-frames to cure, target or focus.

* '''In the option menu'''<br>
** You can choose what you want to cure and the priority of each affliction, the priority determines what affliction is shown first but also the key mapping of your spells (look at the tool-tips to know the current bindings)
** you can choose/add/delete debuffs to ignore while in combat per class, it avoids to waste time and mana ; Decurive already has a comprehensive Debuff list ignored on specific classes.
** You can easily organize the unit frame order by using the priority and skip list, clicking on the buttons in the Decursive bar (These list can be displayed by clicking on the MUF handle).
** you can save your options per character/server/class and create option profiles.

* '''Choose the appearance of the Micro-Unit frames''', you can change the size the number of unit displayed, the number of units per lines...

* '''Move the Micro-Unit frames''' by alt-left-clicking above the first one, there is a handle to move the frame.

----
=== Options ===

<u>There are several ways to access the options</u>:

* On the "Decursive" bar or on the MUFs handle, '''right-click''' to display a
*: drop-down menu option.
* Shift-right-click on the handle to display a static option panel.
* Type '''/Dcr''' to access the options by command line.
* Type '''/Dcroptions''' to display a static option panel.

Note that each options has an explanation tool-tip. Just explore the menus.
----

=== Frequently Asked Questions ===


*; How do I move the Micro-unit frames?
:	To move the MUFs, press Alt and left-click and hold the handle just above the first MUF (it has the same size as a MUF and highlights when your mouse pointer is over it). This handle has several uses, a tool-tip (in	the lower right corner of your screen) explains them all.


*;	How do I move the live-list?
:	Display the "Decursive" bar (/dcrshow or shift-right-click on the MUF handle) and alt-click to move the bar (The live-list is anchored to this bar).

*;	Alright I have just one thing to say about this mod, no matter what key	I bind it to... It only cleanse when he feels like it. I could push the key I bind cleanse like 300 time and it does not even try to attempt. If I click on a friend or myself now it will go right away. I remember the old one when we didn't have to click on people face to do so, that's why it was very useful in	raids. Anyone knows how to fix it? Or it’s just that way?
:	You have to over the unit or unit's unit-frame you want to cure and then press the curring key... Or click on one of the MUF with the mouse-button corresponding to the color of the MUF.  How fast "Decursive" removes debuffs only depends on you...



*; How do I remove the 'focus' unit of the MUFs?
: Type /clearfocus


*; The old Decursive was so simple, why is it so complicate now?
: It's because of Blizzard changes in WoW 2.0, Add-ons can no longer target units or cast spells directly...

*; If by clicking on a specific MUF can cast spells on the specific target, wouldn't it stand to reason that if you code one button to change to the name of the priority target you would then only need one MUF instead of multiple MUFs?
: No it's impossible, unit-frame cannot be modified while the player is	in combat... Blizzard wants players to take actions and think to play. So single-button-casting add-ons are impossible since WoW 2.0. Player have to choose manually their target and the spells they want to use.
: Decursive uses new Blizzard's "click casting" solution, it's the only way for add-ons to use spells and target players.

*; Since 2.X a lot of people in my raid group have heard that Decursive has been banned by Blizzard and using it might result in penalties on ones account. 

: This is not true. The only add-ons that could put a player in troubles are add-ons that don't respect the rules set by Blizzard, such as add-ons that	allows communication between different factions. Decursive breaks no rule of that kind. When Blizzard disapproves an add-on they simply disable the API it uses to work. This is what happened when WoW 2.0 came out, a lot of add-ons where completely unusable (Decursive was part of them).
: With Decursive, players still have to choose their target and the spells they	want to use on that specific target, this is what Blizzard wants. They disapproved Decursive 1.x because players had only one button to press to remove all afflictions	without even thinking...
: You can ask to a Game Master in game if you still have some doubts about Decursive status.

