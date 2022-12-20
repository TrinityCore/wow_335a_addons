# TrinityAdmin Changelog
### -=[ Revision 59 - 12/20/2022]=-
- Improved tab layouts, spacing for readability
- Fixed explore cheat command syntax
- Misc spacing tweaks for some UI elements
- Revamped jail commands
  - Drop SetJail functions in place of built-in Horde and Alliance jail locations (Stockade for alliance, Crypt for 
  Horde)
  - Hardcoded xyz coords since these locations don't appear to have named teleports
  - Freezes player so they can't escape via hearth or portal
  - Prevents player from jailing themselves or NPCs
### -=[ Revision 58 - 10/20/2019]=-
- FIX: Typo in GM on/off command

### -=[ Revision 57 - 10/18/2019]=-
- FIX Diff graph LUA error (Not actually updating)

### -=[ Revision 56 - 8/23/2019]=-
- Added Tool Tip to WHO tap
- FIXED server information tab now showing TrinityCore rev.
- Removed Locale section from CHANGELOG
- Converted CHANGELOG 4>2 spaces

### -=[ Revision 55 - 8/21/2019]=-
- Changed version specific build to 3.3.5
- Updated TOC for version 3.3.5
- updated README to reflect 3.3.5
- Corrected flip flopped Emote buttons on the NPC Tab
- Fixed a few spelling errors

### -=[ Revision 54 - 11/13/2018]=-
- Fixed Tele Tab function with previous commit
- Removed multiple files for non-existing tabs
- Removed excessive spacing
- Cleaned trailing whitespace

### -=[ Revision 53 - 10/19/2018]=-
- NPC Corrections/Adjustments:
  - Changed button layout/corrected alignment

### -=[ Revision 52 - 10/18/2018]=-
- TAB Corrections/Adjustments:
  - Merged CHAR2 tab into CHAR
  - Removed NPC2 Tab

### -=[ Revision 51 - 10/14/2018]=-
- TAB Corrections/Adjustments:
  - Removed PvP Tab
  - Removed EVENT Tab
  - Removed RPG Tab
  - Removed VENDOR Tab
  - Removed AhBOT Tab

### -=[ Revision 50 - 10/10/2018]=-
- Char Corrections/Adjustments:
  - Merged CHAR2 tab into CHAR
  - Removed CHAR2 Tab

### -=[ Revision 49 - 10/06/2018]=-
- Char Corrections/Adjustments:
  - Changed button layout/Corrected alignment
  - Changed scale of 3D model view
  - Changed 3D model view control buttons
- NPC Corrections/Adjustments:
  - Changed button layout/Corrected alignment
  - Changed scale of 3D model view
  - Changed 3D model view control buttons

### -=[ Revision 48 - 10/03/2018]=-
- Nomalized TABS to use all UPPERCASE names
- GM Corrections/Adjustments:
  - Changed button layout/Corrected alignment
- Who Corrections/Adjustments:
  - Changed button layout/Corrected alignment
- Char Corrections/Adjustments:
  - Swap modify_textbox with level_up dropdown
  - Centered Rotate and Zoom buttons over 3D view
- Char2 Corrections/Adjustments:
  - Moved Parameter input & text
- LookUpButtons Frame:
  - Changed button layout/Corrected alignment
- NPC2 Corrections/Adjustments:
  - FIX TYPO: Removed [] from WayAdd & WayShow buttons
  - FIX TYPO: Corrected enUS locals WayAdd/WayShow
  - FIX Textbox width to match button width
  - ADD 'Distance' discription text

### -=[ Revision 47 - 9/24/2018]=-
- Corrected layout alignment in the Server Tab:
  - FIXED Reload Scripts -> changed to .reload smart_scripts

### -=[ Revision 46 - 9/23/2018]=-
- MOD Main Window layout:
  - Moved Language dropdown closer to the change button
  - Realigned lower window frames
  - Changed lower right frame text alignment
- Corrected layout alignmnet the Misc Tab:
  - ADD Move checkbox to Misc Tab

### -=[ Revision 45 - 1/18/2012]=-
- Added "Reload" Linkifier button to the output of ".npc info" to reload the creature_template

### -=[ Revision 44 - 1/15/2011]=-
- Forgot to update internal revision string, fixed

### -=[ Revision 43 - 1/15/2011]=-
Touchups to r42 changes. Changed "Spawn on Move" to "Add on Move", then added "Move on Move" so you
can "move" gobs finally (it actually deletes and recreates the gob to get around the .gob move bug)

### -=[ Revision 42 - 1/15/2011]=-
- Major changes to GOB tab:
- ADD Model viewer to see targeted model with rotate/zoom
- ADD Move/spawn system for builders
- ADD detailed gobject info displayed when you click OBJTarget
- New file added, models.lua. Please close WoW and restart to load new file.
Note: Displaying gobject models was NOT a straightforward thing. The Model widget is capable, if
passed the path (in the MPQs) to the model. We get this path from the GameObjectDisplayInfo.dbc
file. I created the models.lua file as a crossreference between DisplayID (of a gobject) and the
path (in the MPQs) where the model is... and this models.lua file is ginormous (I have 45,621 model
paths in this file). As a result, TrinityAdmin now takes up a tad over 8Mb of RAM. If this is unacceptable
for you, open models.lua and delete all but the first line. You might get an occaisional error, but you
can ignore them. Credits: I swiped most of the Spawn/Move code and some of the gobject model view code
from an addon called Glitchy's Object Playground. Glitchy wrote OP for ArcEmu, and released it on MMOwned
a long time ago. I updated and converted pieces of his code to make this work. Props to Glitchy.
Note2: The Gob info boxes can become messy due to a race condition. Since WoW LUA has no Sleep() function,
I cannot prevent this. Click the Obj Target button to reset the info boxes.

### -=[ Revision 41 - 1/10/2011]=-
- ADD new NPC2 tab - Please close WoW and restart to load new files!!!
- Moved all NPC Waypoint/movement related buttons to NPC2
- Fixed MvRandom, NPCStay, NPCStayDEl, and MvWaypt buttons
- ADD .reset all spells, all talents, and achievements to Reset subroutine
- ADD .combatstop, .maxskill, .freeze, .unfreeze, .listfreeze, .possess, .unpossess to CHAR tab
- ADD .possess and .unpossess to NPC tab
- ADD .recall and .repairitems to CHAR tab

### -=[ Revision 40 - 1/8/2011]=-
- ADD .cometome command to NPC tab
- Added enUS locale for above

### -=[ Revision 39 - 1/8/2011]=-
- ADD .bindsight to NPC tab
- ADD .unbindsight to NPC tab. Note: this command is broken in core on my core revision.
- ADD .bindsight to CHAR tab
- ADD .unbindsight to CHAR tab. Note: this command is broken in core on my core revision.
- ADD .char rename, customize, changerace, and changefaction to CHAR tab
- ADD enUS locale for the above items

### -=[ Revision 38 - 1/8/2011]=-
- Misc code formatting cleanup
- ADD aspeed, arena, bwalk, drunk, fly, gender, honor, mount, phase, runicpower, speed, standstate, swim, and tp to Modify
- Updated enUS locale for above adds
- Rearranged GOB tab, added labels. Preparing to add more content here.
- ADD .gob activate, add temp, info, phase to GOB tab
- updated enUS locale for above adds
- ADD/MOD added missing tables to Reload. Removed individual tables that are reloaded with an all_xxxx command...
  so now the list fits the screen, but you may have to choose an all_xxxx command to reload the table you want.

### -=[ Revision 37 - 1/4/2011]=-
- Wiki changes

### -=[ Revision 36 - 1/4/2011]=-
- You'd think after years of programming experience, I'd not get in this sort of mess. Like letting my code on two
different machines get out of sync. Like trying to commit with conflicts o' plenty. Fixed. Ignore r25-r35.

### -=[ Revision 24 - 1/4/2011]=-
- Merry (Belated) Christmas!
- Numerous bugs fixed from issue tracker
- New camera functions and rearrangement of model frame on Char and NPC tabs
- Speed and Scale sliders now have Reset buttons
- Tweak to DisplayID browser
- Found some more .namego and .goname, changed to .appear and .summon

### -=[ Revision 23 - 12/12/2010]=-
- ADD NPC DisplayID broser

### -=[ Revision 22 - 9/6/2010]=-
- FIX version string

### -=[ Revision 21 - 9/6/2010]=-
- FIX for new .summon, .appear, .groupsummon commands

### -=[ Revision 20 - 8/10/2010]=-
- FIX Whisper issues with 3.3.5a client
- MOD Revive button on Char tab is now always available
- FIX Server Info spamming when Show Chat Output is ON.

### -=[ Revision 19 - 4/13/2010]=-
- FIX issue 36 WHO tab overlap
- FIX issue 35 TICKET - Online list not working
- FIX issue with Nil object error in tele scrolling on startup
- FIX Ticket scrolling issue reported by Kitharo
- ADD MISC tab, checkbox for Chat Output. When off (default), TrinityAdmin does not display output of most
  commands in chat window (for example, .server info) but does display the results in the appropriate part
  of TrinityAdmin. When ON, both TrinityAdmin native AND chatwindow outputs are displayed.
- ADD MISC tab, an editbox to specify how often the Diff graph (on Server tab) is updated. 4000 (~1 minute) is default.
- It is reported that r19 with Chat Output ON allows all the chat window clickable links to work properly. Please verify.
- It is also reported that deDe clients with deDe selected in TrintiyAdmin and deDe selected in Core is now working properly.

### -=[ Revision 18 - 4/7/2010]=-
Note: This version is compatible with TC2 revision 7757+
- FIX: WHO tab functioning with new entries in Trinity_String (MANY thanks to TC Devs for the changes!!!)
- ADD: Map-Zone to WHO tab. Note: this is NOT realtime since it pulls from the database after save
- Fix: PairsbyKeys startup error
- Fix: Tickets Online functions
- MOD: Removed IP address from the list on Who tab. IP is still in details.
- MOD: In Item search frame, click= add item to target inventory, right-click= list item. Changed this to: click=add, r-click=remove. Multiple amounts work for removing too, can enter either a positive or negative munber to be removed.
- FIX: Server info no longer spamming chat window

### -=[ Revision 17 - 3/4/2010 ]=-
- ADD: deDE localisation

### -=[ Revision 16 - 2/26/2010 ]=-
- UPDATE: svSV locale updated
- UPDATE: Close Mail popup when send button clicked - Thanks, Shocker!
- ADD: Ticket tab, new button to view tickets of online players only (.ticket onlinelist) Thanks, Shocker!
- UPDATE: Change minimapicon when a new ticket is received. Now more obvious and with a 'T'. Thanks, Kitharo! Issue #25 closed
- UPDATE: Moved Tele Add and Tele Del buttons to GM tab, rather than Char2 tab.
- ADD: On WHO tab: .char customize, .char delete, .char rename, .ban (1 day), .ban (perm), Jail (Alliance), Jail(Horde), UnJail

### -=[ Revision 15 - 2/25/2010 ]=-
- FIX: Issue #23 Ticket list not clearing when last ticket closed
- FIX: Issue #24 Tickets with IDs containing '00' not displaying - ta.sql MUST be reapplied
- The above two issues found and fixed by Shocker. Thanks m8!

### -=[ Revision 14 - 2/24/2010 ]=-
- Fixed internal revision number, forgotten at last commit.

### -=[ Revision 13 - 2/24/2010 ]=-
This is a major release, incorporating many, many fixes along with
some major new features (Tickets, Who). This release would NOT have
happened without the generous and patient assistance of Kitharo (from
Land of Legends). All of us owe Kitharo a great debt for testing TrinityAdmin
on one of the world's largest servers and providing detailed feedback
so that I could make Tickets work again. Thank you, my friend!

- Added 'GM Chat' command to GM tab
- Added Waterwalk command to GM tab
- Added acccount lock/unlock command to GM tab
- Added PvP tab
- Modified sizes of tabs
- Added Event tab
- Added RPG tab
- Added Vendor tab
- Added AhBot tab
- Added Who tab
- Mail error fixed. Note you still cant send big messages.. 230 apprx charatcers is the server limit
- TICKET TAB NOW FULLY FUNCTIONAL
- Update frequency of the Udate Diff graph changed to approx 1 minute
- Server info auto refreshes every 1 minute
- Added complete WHO system on WHO tab: see who is online, click for detailed info
- Integrated MUCh more complete teleport table from old MangAdmin (thanks, Gimp & Pryd!!!)
- Updated localisation for enUS, frFR, svSV
- Localisation for csCZ, deDE, plPL, huHU, itIT, ptPT, ruRU are in-progress
- Removed support for fiFI, liLI, zhCN, nlNL languages until translators can be found
- Added .gm ingame, .gm list, and .pet create
- Added .pet learn, .pet unlearn, .pet tp
- Added .lookup taxinode, .go taxinode
- Added .go trigger
- Added .cast, .cast back, .cast dist, .cast self, .cast target
- added .list item
- Added .account create, .account delete, .account set addon, .account set gmlevel, .account set password
- added .gmnotify
- Logo updated (Thanks Lyrr123!!!)

## Locale Team:
### Supported Locales:
- [x] enUS: iotech