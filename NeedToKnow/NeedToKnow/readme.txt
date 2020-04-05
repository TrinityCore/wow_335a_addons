
--------------------
NeedToKnow
by Kitjan
--------------------


NeedToKnow allows you to monitor specific buffs and debuffs of your choosing as timer bars that always appear in a consistent place on your screen in a consistent color.  It's especially useful for monitoring frequently used short-duration buffs and debuffs.  For example, a rogue could configure NeedToKnow to show timer bars for Slice and Dice, Rupture, and their own stack of Deadly Poison VII.  A death knight could use it to track their own diseases on a mob.  NeedToKnow also works with procs and on-use trinkets.  The number, size, position, and appearance of timer bars are all customizable.  


------------
Instructions
------------

General options are available in the Blizzard interface options menu.  You can type "/needtoknow" or "/ntk" to lock/unlock the addon.  To configure individual bars, right click them while unlocked.  Bars work while locked.  

When entering your settings, be careful with your spelling and capitalization.  Also remember that buffs and debuffs sometimes have different names than the items and abilities that apply them.  The Death Knight ability Icy Touch, for example, applies a DoT called Frost Fever.   


----------
Change log
----------

2.8.0
- Added the ability to track increases in spell duration, especially useful for dps druids
- Marked as being a 3.3 addon
- Fixed: Took advantage of a new 3.3 API to get the spell id of active buffs and debuffs.  Bars that check spellid should be much more reliable and, for example, be able to tell the difference between the two different Death's Verdict procs
- Fixed: Totem timing is much more accurate
- Fixed: Visual cast times now updates based on changes in haste and other casting-time-affecting abilities

2.7.1
- Fixed: Accidentally removed the background color picker

2.7.0
- Added options for how the time text is formatted. The current style is the default, with mm:ss and ss.t as other options
- Added "visual cast time" overlay which can be used to tell when there's less than some critical amount of time left on an aura
- Hid the spark when the aura lasts longer than the bar (either an infinite duration, or using the Max duration feature.)
- Hid the time text when the aura has an infinite duration

2.6.0
- Added support for a new "Buff or Debuff" type: Totem. Type in the name of the totem to watch for (can be a partial string.)
- Fixed a parse error in the DE localization
- Slightly improved performance of "target of target"
- Added two new /ntk options: show and hide. They can be used to temporarily show and hide the ntk groups.

2.5.2
-Changed event parsing to try to be more robust (see autobot's errors)

2.5.1
-Trying a different strategy for identifying "only cast by me" spells
-When editing the watched auras, the edit field starts with the current value
-Configuring by SpellID is automatically detected and does not need a menu item checked

2.5
-Fixed ToT issue
-Added support for SpellID

2.4.3
-Added SharedMedia support, uses LibSharedMedia-3.0
-Greatly improved performance

2.4.2
-Fixed a bug with the multiple buffs per line
-Fixed a small bug with resize button showing
-Optimized performance slightly

2.4.1 

-Fixed character restriction on buff names, no accepts up to 255 characters.
-Added Russian localization

2.4

-Brought up to 3.2 API standards
-Added multiple buffs/debuffs per bar
-Dual-Specialization support

Version 2.2
-  Added option to show bars with a fixed maximum duration
-  Fixed an issue with targetoftarget
-  Added koKR localization.  Thanks, metalchoir! 
-  Added deDE localization.  Thanks, sp00n & Fxfighter! 

Version 2.1
-  Updated for WoW 3.1 
-  Can now track spells cast by player's pet or vehicle
-  Can now track buffs/debuffs on player's vehicle
-  Added options for background color, bar spacing, bar padding, bar opacity
-  Fixed a problem with buff charges not showing as consumed

Version 2.0.1
-  Updated for WoW 3.0
-  Can now track (de)buffs applied by others
-  Added option to only show buffs/debuffs if applied by self

Version 2.0
-  Added support for monitoring debuffs
-  Added support for variable numbers of bars
-  Added support for separate groups of bars
-  Added support for monitoring buffs/debuffs on target, focus, pet, or target of target
-  Bars are now click-through while locked
-  Reminder icons have been been greatly expanded in functionality and split off into their own addon: TellMeWhen
-  Cleaner bar graphics
-  Users of older versions will need to re-enter settings 

Version 1.2
-  Updated for WoW 2.4 API changes

Version 1.1.1
-  Icons should now work properly with item cooldowns.
-  Reset button should now work properly when you first use the AddOn.

Version 1.1
-  Icons will now show when reactive abilities (Riposte, Execute, etc.) are available.  
-  Added options for bar color and texture.  
-  Added graphical user interface.  Most slash commands gone.  
-  Added localization support.  Translations would be much appreciated.  
-  Users of older version will need to re-enter settings.  

Version 1.0
-  Hello world!

