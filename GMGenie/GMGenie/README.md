Game Master Genie
=======


About GM Genie
-------

[![Screenshot of GM Genie](http://www.chocochaos.com/gmgenie/GMGenie%200.7.thumb.jpg)](http://chocochaos.com/gmgenie/GMGenie%200.7.jpg)

GM Genie is an all-round GM addon for Trinitycore, aimed at making common tasks easier and quicker to accomplish. It provides tools for managing tickets, interacting with players on the server, building/spawning and much much more.

GM Genie is not and is never going to be a collection of buttons just to eliminate the need to type commands. I have personally never understood how that is useful in any way, so please don't make requests to add button x for command y, it is not going to happen. However, if you have ideas for new functionality that could provide new possibilities or make existing tasks vastly easier, be sure to mention them!



Installation Instructions
-------

*   **[Download most recent release (0.7.3).](http://www.chocochaos.com/gmgenie/GMGenie%200.7.3.zip)**
*   **[Download previous release (0.7.2)](http://www.chocochaos.com/gmgenie/GMGenie%200.7.2.zip)**, for servers that still use the old playerinfo format (not updated for >1 year).
*   **[Download older versions.](http://www.chocochaos.com/gmgenie/old/)**

Download the addon using one of the links above and extract it to the interface/addons directory in your WoW installation. When logging in, the addon should be enabled by default.

**Supported emulators:** TrinityCore (3.3.5 and 4.3.4)
**Supported client versions:** 3.3.5 and 4.3.4
**Supported client locales:** enUS and enGB



Current Functionaility
-------

*   **Hud aka the main window**
     Shows the amount of open tickets, both online and offline. Shows gm status and allows changing it. And provides quick access to the ticket and builder interface.
*   **Tickets**
    May not sound all too interesting, but decent ticket addons are hard to find these days. This one is extra cool as it has some neat functionality, including but not limited to:
    *   Read marking: easily see which tickets have and have not yet been read.
    *   Differentiation between online and offline tickets, including the option to hide offline tickets if you wish.
    *   Sort by tickets by id, name, creation date, modified date or assigned to.
    *   Show who else is reading the ticket while you are reading it.
    *   Quickly assigning the ticket to yourself with a single click, or to someone else by right clicking.
    *   The ability to set comments from within the ticket window, instantly updating the comment if someone else has the ticket open as well.
    *   Fully integrated with the awesome spy (see below).
*   **Spy aka playerinfo**
    Spy is a window showing all relevant info from the usefull playerinfo command. In addition, it provides access to several quick commands, macros and advanced character tools. Spy is opened automatically when a ticket is opened, and can be initialized manually by typing /why charactername or by right clicking a name in chat, going to quick commands and clicking spy.
    *   Appear, summon, freeze, unfreeze, revive, rename, customize, change race, change class, etc.
    *   Lookup other accounts and characters from the player.
    *   Show any current or past bans.
    *   Quick ccess to all whisper, mail and discipline macros (see below).
*   **Player macros**
    There are three types of player macros: whisper macros (which send pre-defined whispers), mail macros (to send pre-defined mails) and discipline macros (for any kind of pre-defined mutes or bans).
    Macros can be easily defined from the interface settings. Each type comes with several neat options to customise the macros to your needs.
    The macros can be accessed from the spy window, and when right clicking a player in chat (or somewhere else, as long as there is normally a player menu on right click).
*   **Builder**
    The builder allows exact movement, rotation and spawning of npcs and objects. The combination of these two options make it a pretty powerful tool that can be used to make almost anything in-game.
    In addition there is also a window to make "spawn macros". Usage requires a basic understanding of lua. A few examples:
    *   A cirlce with 18 chairs:
    
            for i=1, 18, 1 do
            go(5, 0, 0, 180, -1, 1, 176232);
            go(5, 0, 0, 200, -1, 0, 0);
            end
            
    *   A spiral of torches going up:
    
            for i=1, 400, 1 do
            local rotate = 2+0.05*(2.71828183^(0.0125*i))
            local up = rotate/100;
            go(0.25, 0, up, rotate, -1, 1, 180352);
            end
            
    An example of what can be accomplished once you are familiar with the builder:
    [http://www.youtube.com/watch?v=A_4r1vEJ3MQ](http://www.youtube.com/watch?v=A_4r1vEJ3MQ)

The above certainly isn't a complete list of what the addon can do, but there's no point making a wall of text that no one will read anyway. I'd highly encourage just testing some things out and see what it can do for you. If you know lua, a peek at the source code may also shed some light on the functionality.

The addon is released under the GPL (v3), so feel free to modify, redistribute or whatever you'd like to do with it. If you find any bugs, have ideas for improvements, want to provide a patch or whatever, please feel free to post it here.



Reposts and modifications
-------

Since GM Genie is under an open source license, any modifications and redistributions of the addon are explicitely allowed, as long as copyright and license notices remain intact.

However, I would appreciate it if you could drop me a message if you post/publish GM Genie somewhere. Partly because I like to know where it is being spread, but also so I can add new versions to those threads when they are released. It would be a shame if everyone keeps using some ancient version because it was once posted on a forum, and never updated there.

You can drop me an e-mail at gmgenie [at] chocochaos [dot] com

It's not a requirement to inform me, but I would appreciate it =)



Changelog
-------

### Version 0.7.3

*   Small changes and fixes:
    -   Code cleanup in several areas.
    -   Fixed the spy window (the new TrinityCore output format broke it).
    -   Security fix for ip banning functionality.

### Version 0.7.2

*   Cataclysm (up until 4.3.4) is now supported. Some quick testing has been done, but there may also be some issues that I missed. Consider cataclysm support to be in beta for now. Also, please note that the addon should still work fine in Wrath of the Lich King.
    -   Replaced all references to global variable this, event and arg1 with something else that does work.
    -   Manually updated the chronos library. Replaced the VARIABLES_LOADED event with ADDON_LOADED. AceTimer was also considered, but would have required more work to implement.
    -   Changed the loading process of GMGenie windows and textareas, so that backgrounds are once again loaded and the size is set correctly.
    -   Updated the interface version to 40300.
*   Small changes and fixes
    -   Fixed a small lua error on first load of the addon (related to the minimap button position).

### Version 0.7.1

*   Small changes and fixes
    -   When there is a large amount of offline tickets online tickets will now show up properly once again.

### Version 0.7

*   General changes:
    -   New hud, replacing the old minimap menu. This hud also shows gm/chat/visibility/whisper/fly/speed status, and allows changing it.
    -   When porting to a different map flight mode is automatically re-enabled (if it was enabled previously).
    -   Hyperlinks for gameobjects, gameobjects entries, creatures and creature entries now give a nice dropdown with usefull options when you click on them, instead of an annoying lua error. Options include: spawning/removing, porting to and listing spawned creatures/gameobjects.
    -   Generally a more consistent interface.
    -   Names in anticheat messages are now clickable (left click opens the spy window, makes you invisible, appears and show the kind of cheats detected, right click opens the usual player menu). This was tested on a non-standard anti-cheat though, so it may not work on all servers.
*   Changes to ticket interface:
    -   When showing offline tickets is enabled, offline tickets show up in red.
    -   Previously read tickets show up in a little darker colour than unread tickets.
    -   The ticket you're currently reading is shown in white.
    -   Refresh button moved to the top of the window, settings button removed (settings can be accessed through the interface options, like for all addons).
    -   Ticket count at the bottom of the window now separates online and offline tickets.
    -   Fixed a bug where some tickets would incorrectly be highlighted (as if they were being read) in the list.
*   Changes to the spy (playerinfo) window:
    -   You can now right click in the spy window to copy the playerinfo.
    -   A refresh button has been added at the top of the window.
    -   Latencies of 1k and higher now show up in red. Stripped the ms of the latency so that larger numbers fit in.
    -   Fixed using /spy without a name (using target instead when no name is specified).

### Version 0.6.1

*   Small changes and fixes
    -   Viewing ticket comments bugged out for tickets with multiple lines of text.

### Version 0.6

*   Major visible changes
    -   Ticket comment and assign/unassign fully fixed and implemented.
    -   Added mute and ban macros, with the option to announce to the server.
    -   The ticket window now shows other GMs reading the ticket, provided the GMs are in the same guild.
    -   Added character customisation options to the macro menus.
*   Small changes and fixes
    -   Fixed a very rare lua error in the ticket tracker.
    -   When pressing enter or escape in a text box it now automatically looses focus.
    -   Fixed all lua errors while tabbing through text boxes in the settings.

### Version 0.5

*   Major visible changes:
    -   Added teleport macros.
    -   Added an extra dropdown to the spy window for advanced commands (currently lookup player and baninfo).
    -   Added an advanced building tool (can be opened with /builder).
    -   Overhauled user interface.
    -   Added a minimap button with a menu for GM Genie. The button shows the number of tickets.
*   Small changes and fixes
    -   Fixed the previous and next page buttons that were missing from the ticket window.
    -   Double click the window title to reset it to it's default position.
    -   Made the text at the bottom of the ticket window a button (doesn't look like one but it is!). You can use it to easily turn offlines tickets on and off.
    -   Changed the spy window to show more detailed location information and include the player's phase (if online).
    -   Changed the (Un)root button from a secure button to a normal button and named in (Un)freeze. Now also works for players not in range and offline players. Also added freeze and unfreeze to the quick commands menu.
    -   Fix a bug where refreshing the spy window would sometimes give an error.
    -   Further code cleanup.
    -   Fixed a lua error when trying to open a ticket while the list was being refreshed.
    -   Fixed the auto-refresh of the ticket window and count.

### Version 0.3.1

*   Small changes and fixes
    -   Fixed a bug where dropdowns were loaded before checking saved variables, resulting in LUA errors is the defaults needed to be loaded.

### Version 0.3

*   Major visible changes:
    -   Added several quick commands (revive, appear, summon, spy) on right clicking someone's name.
    -   Added mail macros.
    -   Added dropdowns for mail and whisper macros when spying someone and when right clicking a name in the game.
*   Small changes and fixes
    -   Changed the regular expression to read ticket listings and tickets from chat, so that it now allows spaces in the created and last modified time (this will make the addon work on new TC revisions).
    -   Fixed a bug where tickets with an empty line at the start would not display correctly.
    -   All regular expressions and functions to read from chat moved to Chatreader.lua.
    -   Load saved variabled in Savedvariables.lua and allow setting defaults in that file (this allows creating a default preset for a server-specific distribution of GM Genie).
    -   Big code cleanup in several areas. Consistent naming for variables and functions, as far as possible without creating unnescessary extra variables.

### Version 0.2 and older

No changelogs kept.
