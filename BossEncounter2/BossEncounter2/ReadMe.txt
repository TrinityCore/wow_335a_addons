**************
BossEncounter2
**************

Caution
=======
Only French and English languages are implemented.
You can use BossEncounter2 with other languages at your own risk.

FAQ
===
Q: How do I use BossEncounter2 ?
A: Turn it on in the character selection screen.
Then, when you see the boss, select it to launch its module.
Some bosses do not need to be selected to be triggered.

Q: How can I move/resize the widgets ?
A: Type "/BE2 anchor" in-game to open a special mode to move your widgets. You can also change their scaling (but no arbitrary resize).

Q: A boss module does not end after a wipe. What do I do ?
A: Type /BE clear, this should fix it.

Q: A boss module has been interrupted for no reason. What do I do ?
A: Send me a report from the boss fight !

Q: I selected a boss, and BossEncounter2 does not react ! What gives ?
A: The boss you selected is probably not supported.
Please refer to BC_raid_status and WotLK_raid_status text files in /modules folder to see if a given boss is supported.
I do not intend to add classic bosses.
If the boss is supported, maybe it's because you have been disconnected during the fight and BossEncounter2 is not able to recover it.
If the boss is supported and you were not in combat when you selected the boss, please send a bug report including the boss name.

Q: What does Attempts, Speed and Technique mean?
A: These 3 criterias tell how well you performed on a boss fight.
Attempts measures how many attempts you've needed to take the boss down (only one attempt needed = max points).
Speed measures how quickly you killed the boss in the actual combat.
Technique measures your survival and mana management skills.
Each criteria goes from 0 to 120, above 100 it means exceptionnal performance.

Q: What about BossEncounter ONE ?
A: BE1 was an Addon I created a long time ago (at the beginning of TBC) but I have never published it.

Q: Some timers are inaccurate, WTF ?
A: It's impossible for some boss abilities to exactly determinate when the boss will use them, that's the case for abilities
that are only restricted by a cooldown (generally these events are prefixed with "CD:" or "Cooldown:" tag).
It's also possible that not enough data have been gathered for this boss and thus the timers are inaccurate.

Q: What are those "Incomplete fight" tags ?
A: A fight is flagged as incomplete when the boss was already in combat when you triggered its boss module.
This prevents timers from being accurate and sets your Speed criteria to zero.
To avoid this, always make sure to select the boss before pulling it.

Special thanks
==============
- My guild Nalonwe for testing the mod.
- Supernico (Vaskin @ Throk'feroth) for providing WotLK dungeon bosses.