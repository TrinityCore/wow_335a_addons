local L = LibStub("AceLocale-3.0"):NewLocale("Details", "enUS", true) 
if not L then return end 

--------------------------------------------------------------------------------------------------------------------------------------------

L["ABILITY_ID"] = "ability id"
L["STRING_"] = ""
L["STRING_ABSORBED"] = "Absorbed"
L["STRING_ACTORFRAME_NOTHING"] = "nothing to report"
L["STRING_ACTORFRAME_REPORTAT"] = "at"
L["STRING_ACTORFRAME_REPORTOF"] = "of"
L["STRING_ACTORFRAME_REPORTTARGETS"] = "report for targets of"
L["STRING_ACTORFRAME_REPORTTO"] = "report for"
L["STRING_ACTORFRAME_SPELLDETAILS"] = "Spell details"
L["STRING_ACTORFRAME_SPELLSOF"] = "Spells of"
L["STRING_ACTORFRAME_SPELLUSED"] = "All spells used"
L["STRING_AGAINST"] = "against"
L["STRING_ALIVE"] = "Alive"
L["STRING_ANCHOR_BOTTOM"] = "Bottom"
L["STRING_ANCHOR_BOTTOMLEFT"] = "Bottom Left"
L["STRING_ANCHOR_BOTTOMRIGHT"] = "Bottom Right"
L["STRING_ANCHOR_LEFT"] = "Left"
L["STRING_ANCHOR_RIGHT"] = "Right"
L["STRING_ANCHOR_TOP"] = "Top"
L["STRING_ANCHOR_TOPLEFT"] = "Top Left"
L["STRING_ANCHOR_TOPRIGHT"] = "Top Right"
L["STRING_ATACH_DESC"] = "Window #%d makes group with the window #%d."
L["STRING_ATTRIBUTE_CUSTOM"] = "Custom"
L["STRING_ATTRIBUTE_DAMAGE"] = "Damage"
L["STRING_ATTRIBUTE_DAMAGE_DEBUFFS"] = "Auras & Voidzones"
L["STRING_ATTRIBUTE_DAMAGE_DEBUFFS_REPORT"] = "Debuff Damage and Uptime"
L["STRING_ATTRIBUTE_DAMAGE_DONE"] = "Damage Done"
L["STRING_ATTRIBUTE_DAMAGE_DPS"] = "DPS"
L["STRING_ATTRIBUTE_DAMAGE_ENEMIES"] = "Enemies"
L["STRING_ATTRIBUTE_DAMAGE_FRAGS"] = "Frags"
L["STRING_ATTRIBUTE_DAMAGE_FRIENDLYFIRE"] = "Friendly Fire"
L["STRING_ATTRIBUTE_DAMAGE_TAKEN"] = "Damage Taken"
L["STRING_ATTRIBUTE_ENERGY"] = "Energy"
L["STRING_ATTRIBUTE_ENERGY_ENERGY"] = "Energy Generated"
L["STRING_ATTRIBUTE_ENERGY_MANA"] = "Mana Restored"
L["STRING_ATTRIBUTE_ENERGY_RAGE"] = "Rage Generated"
L["STRING_ATTRIBUTE_ENERGY_RUNEPOWER"] = "Runic Power Generated"
L["STRING_ATTRIBUTE_HEAL"] = "Heal"
L["STRING_ATTRIBUTE_HEAL_DONE"] = "Healing Done"
L["STRING_ATTRIBUTE_HEAL_ENEMY"] = "Enemy Healed"
L["STRING_ATTRIBUTE_HEAL_HPS"] = "HPS"
L["STRING_ATTRIBUTE_HEAL_OVERHEAL"] = "Overhealing"
L["STRING_ATTRIBUTE_HEAL_PREVENT"] = "Damage Prevented"
L["STRING_ATTRIBUTE_HEAL_TAKEN"] = "Healing Taken"
L["STRING_ATTRIBUTE_MISC"] = "Miscellaneous"
L["STRING_ATTRIBUTE_MISC_BUFF_UPTIME"] = "Buff Uptime"
L["STRING_ATTRIBUTE_MISC_CCBREAK"] = "CC Breaks"
L["STRING_ATTRIBUTE_MISC_DEAD"] = "Deaths"
L["STRING_ATTRIBUTE_MISC_DEBUFF_UPTIME"] = "Debuff Uptime"
L["STRING_ATTRIBUTE_MISC_DEFENSIVE_COOLDOWNS"] = "Cooldowns"
L["STRING_ATTRIBUTE_MISC_DISPELL"] = "Dispells"
L["STRING_ATTRIBUTE_MISC_INTERRUPT"] = "Interrupts"
L["STRING_ATTRIBUTE_MISC_RESS"] = "Ress"
L["STRING_AUTO"] = "auto"
L["STRING_AUTOSHOT"] = "Auto Shot"
L["STRING_BLOCKED"] = "Blocked"
L["STRING_BOTTOM"] = "bottom"
L["STRING_CCBROKE"] = "Crowd Control Removed"
L["STRING_CENTER"] = "center"
L["STRING_CHANGED_TO_CURRENT"] = "Segment changed to current"
L["STRING_CHANNEL_RAID"] = "Raid"
L["STRING_CHANNEL_SAY"] = "Say"
L["STRING_CHANNEL_WHISPER"] = "Whisper"
L["STRING_CHANNEL_WHISPER_TARGET_COOLDOWN"] = "Whisper Cooldown Target"
L["STRING_CHANNEL_YELL"] = "Yell"
L["STRING_CLOSEALL"] = "All Details windows are close, Type '/details new' to re-open."
L["STRING_COMMAND_LIST"] = "command list"
L["STRING_COOLTIP_NOOPTIONS"] = "no options"
L["STRING_CRITICAL_HITS"] = "Critical Hits"
L["STRING_CRITICAL_ONLY"] = "critical"
L["STRING_CURRENT"] = "Current"
L["STRING_CURRENTFIGHT"] = "Current Fight"
L["STRING_CUSTOM_ACTIVITY_ALL"] = "Activity Time"
L["STRING_CUSTOM_ACTIVITY_ALL_DESC"] = "Shows the activity results for each player in the raid group."
L["STRING_CUSTOM_ACTIVITY_DPS"] = "Damage Activity Time"
L["STRING_CUSTOM_ACTIVITY_DPS_DESC"] = "Tells how much time each character spent doing damage."
L["STRING_CUSTOM_ACTIVITY_HPS"] = "Healing Activity Time"
L["STRING_CUSTOM_ACTIVITY_HPS_DESC"] = "Tells how much time each character spent doing healing."
L["STRING_CUSTOM_ATTRIBUTE_DAMAGE"] = "Damage"
L["STRING_CUSTOM_ATTRIBUTE_HEAL"] = "Heal"
L["STRING_CUSTOM_ATTRIBUTE_SCRIPT"] = "Custom Script"
L["STRING_CUSTOM_AUTHOR"] = "Author:"
L["STRING_CUSTOM_AUTHOR_DESC"] = "Who created this display."
L["STRING_CUSTOM_CANCEL"] = "Cancel"
L["STRING_CUSTOM_CREATE"] = "Create"
L["STRING_CUSTOM_CREATED"] = "The new display has been created."
L["STRING_CUSTOM_DESCRIPTION"] = "Desc:"
L["STRING_CUSTOM_DESCRIPTION_DESC"] = "Description about what this display does."
L["STRING_CUSTOM_DONE"] = "Done"
L["STRING_CUSTOM_EDIT"] = "Edit"
L["STRING_CUSTOM_EDITCODE_DESC"] = "This is a advanced function where the user can create its own display code."
L["STRING_CUSTOM_EDIT_SEARCH_CODE"] = "Edit Search Code"
L["STRING_CUSTOM_EDIT_TOOLTIP_CODE"] = "Edit Tooltip Code"
L["STRING_CUSTOM_EDITTOOLTIP_DESC"] = "This is the code which runs after the used hover over a row using this display."
L["STRING_CUSTOM_ENEMY_DT"] = " Damage Taken"
L["STRING_CUSTOM_EXPORT"] = "Export"
L["STRING_CUSTOM_FUNC_INVALID"] = "Custom script is invalid an cannot refresh the window."
L["STRING_CUSTOM_HEALTHSTONE_DEFAULT"] = "Healthstone Used"
L["STRING_CUSTOM_HEALTHSTONE_DEFAULT_DESC"] = "Show who in your raid group used the healthstone."
L["STRING_CUSTOM_ICON"] = "Icon:"
L["STRING_CUSTOM_IMPORT"] = "Import"
L["STRING_CUSTOM_IMPORT_ALERT"] = "Display loaded, click Import to confirm."
L["STRING_CUSTOM_IMPORT_BUTTON"] = "Import"
L["STRING_CUSTOM_IMPORTED"] = "The display has been successful imported."
L["STRING_CUSTOM_IMPORT_ERROR"] = "Import failed, invalid string."
L["STRING_CUSTOM_LONGNAME"] = "Name too long, maximum allowed 32 characters."
L["STRING_CUSTOM_NAME"] = "Name:"
L["STRING_CUSTOM_NAME_DESC"] = "Insert the name of your new custom display."
L["STRING_CUSTOM_NEW"] = "Create New Display"
L["STRING_CUSTOM_PASTE"] = "Paste Here:"
L["STRING_CUSTOM_POT_DEFAULT"] = "Potion Used"
L["STRING_CUSTOM_POT_DEFAULT_DESC"] = "Show who in your raid used a potion during the encounter."
L["STRING_CUSTOM_STORM_DEFAULT"] = "Storm Power Uptime"
L["STRING_CUSTOM_STORM_DEFAULT_DESC"] = "Show uptime of Storm Power buff for your raid."
L["STRING_CUSTOM_REMOVE"] = "Remove"
L["STRING_CUSTOM_REPORT"] = "(custom)"
L["STRING_CUSTOM_SAVE"] = "Save Changes"
L["STRING_CUSTOM_SAVED"] = "The display has been saved."
L["STRING_CUSTOM_SHORTNAME"] = "Name need at least 5 characters."
L["STRING_CUSTOM_SOURCE"] = "Source:"
L["STRING_CUSTOM_SOURCE_DESC"] =[=[Who is triggering the effect.

The button in the right shows a list of npcs from raid encounters.]=]
L["STRING_CUSTOM_SPELLID"] = "Spell Id:"
L["STRING_CUSTOM_SPELLID_DESC"] =[=[Opcional, is the spell used by the source to apply the effect on the target.

The button in the right shows a list of spells from raid encounters.]=]
L["STRING_CUSTOM_TARGET"] = "Target:"
L["STRING_CUSTOM_TARGET_DESC"] =[=[This is the target of the source.

The button in the right shows a list of npcs from raid encounters.]=]
L["STRING_CUSTOM_TEMPORARILY"] = "(|cFFFFC000timerarily|r)"
L["STRING_DAMAGE"] = "Damage"
L["STRING_DAMAGE_DPS_IN"] = "DPS received from"
L["STRING_DAMAGE_FROM"] = "Took damage from"
L["STRING_DAMAGE_TAKEN_FROM"] = "Damage Taken From"
L["STRING_DAMAGE_TAKEN_FROM2"] = "applied damage with"
L["STRING_DEFENSES"] = "Defenses"
L["STRING_DETACH_DESC"] = "Break Window Group"
L["STRING_DISPELLED"] = "Buffs/Debuffs Removed"
L["STRING_DODGE"] = "Dodge"
L["STRING_DOT"] = "(DoT)"
L["STRING_DPS"] = "Dps"
L["STRING_EMPTY_SEGMENT"] = "Empty Segment"
L["STRING_ENVIRONMENTAL_DROWNING"] = "Environment(Drowning)"
L["STRING_ENVIRONMENTAL_FALLING"] = "Environment(falling)"
L["STRING_ENVIRONMENTAL_FATIGUE"] = "Environment(Fatigue)"
L["STRING_ENVIRONMENTAL_FIRE"] = "Environment(Fire)"
L["STRING_ENVIRONMENTAL_LAVA"] = "Environment(Lava)"
L["STRING_ENVIRONMENTAL_SLIME"] = "Environment(Slime)"
L["STRING_EQUILIZING"] = "Sharing encounter data"
L["STRING_ERASE"] = "delete"
L["STRING_ERASE_DATA"] = "Reset All Data"
L["STRING_ERASE_DATA_OVERALL"] = "Reset Overall Data"
L["STRING_ERASE_IN_COMBAT"] = "Schedule overall wipe after this combat."
L["STRING_EXAMPLE"] = "Example"
L["STRING_FAIL_ATTACKS"] = "Attack Failures"
L["STRING_FIGHTNUMBER"] = "Fight #"
L["STRING_FREEZE"] = "This segment is not available at the moment"
L["STRING_FROM"] = "From"
L["STRING_GENERAL"] = "General"
L["STRING_GLANCING"] = "Glancing"
L["STRING_HEAL"] = "Heal"
L["STRING_HEAL_ABSORBED"] = "Heal absorbed"
L["STRING_HEAL_CRIT"] = "Heal Critical"
L["STRING_HEALING_FROM"] = "Healing received from"
L["STRING_HEALING_HPS_FROM"] = "HPS received from"
L["STRING_HELP_ERASE"] = "Remove all segments stored."
L["STRING_HELP_INSTANCE"] =[=[Click: open a new window.

Mouse over: display a menu with all closed windows, you can reopen anyone at any time.]=]
L["STRING_HELP_MENUS"] =[=[Gear Menu: changes the game mode.
Solo: tools where you can play by your self.
Group: display only actors which make part of your group.
All: show everything.
Raid: assistance tools for raid or pvp groups.

Book Menu: Change the segment, in Details! segments are dynamic and the windows change the displaying encounter data when a fight finishes.

Sword Menu: Change the attribute which this window shown.]=]
L["STRING_HELP_MODEALL"] = "This mode will show every player, npc, boss with data captured by Details!."
L["STRING_HELP_MODEGROUP"] = "Use this option to display only you or players which are in your group or raid."
L["STRING_HELP_MODERAID"] = "The raid mode is the opposite of self mode, this plugins are intended to work with data captured from your group. You can change the plugin on sword menu."
L["STRING_HELP_MODESELF"] = "The self mode plugins are intended to focus only on you. Use the sword menu to choose which plugin you want to use."
L["STRING_HELP_RESIZE"] = "Resize and lock buttons."
L["STRING_HELP_STATUSBAR"] =[=[Statusbar can hold three plugins: one in left, another in the center and right side.

Right click: select another plugin to show.

Left click: open the options window.]=]
L["STRING_HELP_STRETCH"] = "Click, hold and pull to stretch the window."
L["STRING_HELP_SWITCH"] =[=[Right click: shows up the fast switch panel.

Left click on a switch option: change the window attribute.
Right click: closes switch.

You can right click over icons to choose another attribute.]=]
L["STRING_HITS"] = "Hits"
L["STRING_HPS"] = "Hps"
L["STRING_IMAGEEDIT_ALPHA"] = "Transparency"
L["STRING_IMAGEEDIT_COLOR"] = "Color"
L["STRING_IMAGEEDIT_CROPBOTTOM"] = "Crop Bottom"
L["STRING_IMAGEEDIT_CROPLEFT"] = "Crop Left"
L["STRING_IMAGEEDIT_CROPRIGHT"] = "Crop Right"
L["STRING_IMAGEEDIT_CROPTOP"] = "Crop Top"
L["STRING_IMAGEEDIT_DONE"] = "DONE"
L["STRING_IMAGEEDIT_FLIPH"] = "Flip Horizontal"
L["STRING_IMAGEEDIT_FLIPV"] = "Flip Vertical"
L["STRING_INSTANCE_LIMIT"] = "max window amount has been reached, you can modify this limit on options panel. Also you can reopen closed windows over(#) window menu." -- Needs review
L["STRING_INTERFACE_OPENOPTIONS"] = "Open Options Panel"
L["STRING_ISA_PET"] = "This Actor is a Pet"
L["STRING_KILLED"] = "Killed"
L["STRING_LAST_COOLDOWN"] = "last cooldown used"
L["STRING_LEFT"] = "left"
L["STRING_LEFTCLICK_DAMAGETAKEN"] = "|cFFFFCC00left button|r: real-time damage taken"
L["STRING_LEFT_CLICK_SHARE"] = "Left click to report."
L["STRING_LOCK_DESC"] = "Lock or unlock the window"
L["STRING_LOCK_WINDOW"] = "lock"
L["STRING_MASTERY"] = "Mastery"
L["STRING_MAXIMUM"] = "Maximum"
L["STRING_MEDIA"] = "Media"
L["STRING_MELEE"] = "Melee"
L["STRING_MENU_CLOSE_INSTANCE"] = "Close this window"
L["STRING_MENU_CLOSE_INSTANCE_DESC"] = "A closed window is considered inactive and can be reopened at any time using the # window button."
L["STRING_MENU_CLOSE_INSTANCE_DESC2"] = "For fully destroy a window check out miscellaneous section over options panel."
L["STRING_MIDDLECLICK_DAMAGETAKEN"] = "|cFFFFCC00middle button|r: player detail window"
L["STRING_MINIMAPMENU_LOCK"] = "Lock"
L["STRING_MINIMAPMENU_NEWWINDOW"] = "Create New Window"
L["STRING_MINIMAPMENU_REOPEN"] = "Reopen Window"
L["STRING_MINIMAPMENU_REOPENALL"] = "Reopen All"
L["STRING_MINIMAPMENU_RESET"] = "Reset"
L["STRING_MINIMAPMENU_UNLOCK"] = "Unlock"
L["STRING_MINIMAP_TOOLTIP1"] = "|cFFCFCFCFleft click|r: open options panel"
L["STRING_MINIMAP_TOOLTIP11"] = "|cFFCFCFCFleft click|r: clear all segments"
L["STRING_MINIMAP_TOOLTIP12"] = "|cFFCFCFCFleft click|r: show/hide windows"
L["STRING_MINIMAP_TOOLTIP2"] = "|cFFCFCFCFright click|r: quick menu"
L["STRING_MINIMUM"] = "Minimum"
L["STRING_MINITUTORIAL_1"] =[=[Window Button:

Click to open a new Details! window.

Mouse over to reopen closed windows.]=]
L["STRING_MINITUTORIAL_2"] =[=[Stretch Button:

Click, hold and pull to stretch the window.

Release the button to restore normal size.]=]
L["STRING_MINITUTORIAL_3"] =[=[Resize and Lock Buttons:

Use this to change the size of the window.

Locking it, make the window unmovable.]=]
L["STRING_MINITUTORIAL_4"] =[=[Shortcut Panel:

When you right click a bar or window background, shortcut panel is shown.]=]
L["STRING_MINITUTORIAL_5"] =[=[Micro Displays:

These shows important informations.

Left Click to config.

Right Click to choose other widget.]=]
L["STRING_MINITUTORIAL_6"] =[=[Group Windows:

Move a window near other to create a group.

Always group with previous window number, example: #5 make group with #4, #2 group with #1.]=]
L["STRING_MINITUTORIAL_BOOKMARK1"] = "Right click at any point over the window to open the bookmarks!"
L["STRING_MINITUTORIAL_BOOKMARK2"] = "Bookmarks gives quick access to favorite displays."
L["STRING_MINITUTORIAL_BOOKMARK3"] = "Use right click to close the bookmark panel."
L["STRING_MINITUTORIAL_BOOKMARK4"] = "Don't show this again."
L["STRING_MISS"] = "Miss"
L["STRING_MODE_ALL"] = "Everything"
L["STRING_MODE_GROUP"] = "Group & Raid"
L["STRING_MODE_PLUGINS"] = "plugins"
L["STRING_MODE_RAID"] = "Plugins: Raid"
L["STRING_MODE_SELF"] = "Plugins: Solo Play"
L["STRING_MORE_INFO"] = "See right box for more info."
L["STRING_MUSIC_DETAILS_ROBERTOCARLOS"] =[=[There's no use trying to forget
For a long time in your life I will live
Details as small of us]=]
L["STRING_NEWROW"] = "waiting refresh..."
L["STRING_NEWS_REINSTALL"] = "Found problems after a update? try '/details reinstall' command."
L["STRING_NEWS_TITLE"] = "What's New In This Version"
L["STRING_NO"] = "No"
L["STRING_NOCLOSED_INSTANCES"] =[=[There is no closed windows,
click to open a new one.]=]
L["STRING_NO_DATA"] = "data already has been cleaned"
L["STRING_NOLAST_COOLDOWN"] = "no cooldown used"
L["STRING_NOMORE_INSTANCES"] =[=[Max amount of windows reached.
Change the limit over options panel.]=]
L["STRING_NORMAL_HITS"] = "Normal Hits"
L["STRING_NO_SPELL"] = "no spell has been used"
L["STRING_NO_TARGET"] = "No target found."
L["STRING_NO_TARGET_BOX"] = "No Targets Avaliable"
L["STRING_OPTIONS_ADVANCED"] = "Advanced"
L["STRING_OPTIONS_ALPHAMOD_ANCHOR"] = "Transparency Modifiers:"
L["STRING_OPTIONS_ALWAYS_USE"] = "Use On All Characters"
L["STRING_OPTIONS_ALWAYS_USE_DESC"] = "When enabled, all characters will use the selected profile, otherwise, a panel is shown asking which profile to use."
L["STRING_OPTIONS_ANCHOR"] = "Side"
L["STRING_OPTIONS_ANIMATEBARS"] = "Animate Bars"
L["STRING_OPTIONS_ANIMATEBARS_DESC"] = "Enable animations for all bars."
L["STRING_OPTIONS_ANIMATESCROLL"] = "Animate Scroll Bar"
L["STRING_OPTIONS_ANIMATESCROLL_DESC"] = "When enabled, scrollbar uses a animation when showing up or hiding."
L["STRING_OPTIONS_APPEARANCE"] = "Appearance"
L["STRING_OPTIONS_ATTRIBUTE_TEXT"] = "Title Text Settings"
L["STRING_OPTIONS_ATTRIBUTE_TEXT_DESC"] = "This options controls the title text of window."
L["STRING_OPTIONS_AUTO_SWITCH"] = "All Roles |cFFFFAA00(in combat)|r"
L["STRING_OPTIONS_AUTO_SWITCH_COMBAT"] = "|cFFFFAA00(in combat)|r"
L["STRING_OPTIONS_AUTO_SWITCH_DAMAGER_DESC"] = "When in damager specialization, this window show the selected attribute or plugin."
L["STRING_OPTIONS_AUTO_SWITCH_DESC"] =[=[When you enter in combat, this window show the selected attribute or plugin.

|cFFFFFF00Important|r: The individual attribute chosen for each role overwrites the attribute selected here.]=]
L["STRING_OPTIONS_AUTO_SWITCH_HEALER_DESC"] = "When in healer specialization, this window show the selected attribute or plugin."
L["STRING_OPTIONS_AUTO_SWITCH_TANK_DESC"] = "When in tank specialization, this window show the selected attribute or plugin."
L["STRING_OPTIONS_AUTO_SWITCH_WIPE"] = "After Wipe"
L["STRING_OPTIONS_AUTO_SWITCH_WIPE_DESC"] = "After a fail attempt in defeat a raid encounter, this window automatically show this attribute."
L["STRING_OPTIONS_AVATAR"] = "Choose Avatar"
L["STRING_OPTIONS_AVATAR_ANCHOR"] = "Identity:"
L["STRING_OPTIONS_AVATAR_DESC"] = "Avatars is also broadcasted for your guild mates and shown on the top of tooltips when hover over a bar and in the player details window."
L["STRING_OPTIONS_BAR_BACKDROP_ANCHOR"] = "Border:"
L["STRING_OPTIONS_BAR_BACKDROP_COLOR"] = "Color"
L["STRING_OPTIONS_BAR_BACKDROP_COLOR_DESC"] = "Changes the border color."
L["STRING_OPTIONS_BAR_BACKDROP_ENABLED"] = "Enabled"
L["STRING_OPTIONS_BAR_BACKDROP_ENABLED_DESC"] = "Enable or disable row borders."
L["STRING_OPTIONS_BAR_BACKDROP_SIZE"] = "Size"
L["STRING_OPTIONS_BAR_BACKDROP_SIZE_DESC"] = "Increase or decrease the border size."
L["STRING_OPTIONS_BAR_BACKDROP_TEXTURE"] = "Texture"
L["STRING_OPTIONS_BAR_BACKDROP_TEXTURE_DESC"] = "Changes the border appearance."
L["STRING_OPTIONS_BAR_BCOLOR"] = "Background Color"
L["STRING_OPTIONS_BAR_BCOLOR_DESC"] =[=[Choose the background texture color.
This color is ignored if by class slider is actived.]=]
L["STRING_OPTIONS_BAR_BTEXTURE"] = "Texture"
L["STRING_OPTIONS_BAR_BTEXTURE_DESC"] = "This texture lies below the top texture, the size is always the same as the window width."
L["STRING_OPTIONS_BAR_COLORBYCLASS"] = "Color By Class"
L["STRING_OPTIONS_BAR_COLORBYCLASS2"] = "By Class"
L["STRING_OPTIONS_BAR_COLORBYCLASS2_DESC"] = "When enabled, the color chosen is ignored and the color of the actor class which is currently showing in the bar is used instead."
L["STRING_OPTIONS_BAR_COLORBYCLASS_DESC"] = "When enabled, the color chosen is ignored and the color of the actor class which is currently showing in the bar is used instead."
L["STRING_OPTIONS_BAR_COLOR_DESC"] =[=[Choose the texture color.
This color is ignored if by class slider is actived.]=]
L["STRING_OPTIONS_BAR_FOLLOWING"] = "Always Show Me"
L["STRING_OPTIONS_BAR_FOLLOWING_ANCHOR"] = "Player Bar:"
L["STRING_OPTIONS_BAR_FOLLOWING_DESC"] = "When enabled, your bar will always be shown even when you aren't at the top ranked players."
L["STRING_OPTIONS_BARGROW_DIRECTION"] = "Grow Direction"
L["STRING_OPTIONS_BARGROW_DIRECTION_DESC"] = "The side which the bars start being shown in the window."
L["STRING_OPTIONS_BAR_HEIGHT"] = "Height"
L["STRING_OPTIONS_BAR_HEIGHT_DESC"] = "Increase or decrease the bar height."
L["STRING_OPTIONS_BAR_ICONFILE"] = "Icon File"
L["STRING_OPTIONS_BAR_ICONFILE1"] = "No Icon"
L["STRING_OPTIONS_BAR_ICONFILE2"] = "Default"
L["STRING_OPTIONS_BAR_ICONFILE3"] = "Default(black white)"
L["STRING_OPTIONS_BAR_ICONFILE4"] = "Default(transparent)"
L["STRING_OPTIONS_BAR_ICONFILE5"] = "Rounded Icons"
L["STRING_OPTIONS_BAR_ICONFILE6"] = "Default(transparent black white)"
L["STRING_OPTIONS_BAR_ICONFILE_DESC"] =[=[Path for a custom icon file.

The image needs to be a .tga file, 256x256 pixels with alpha channel.]=]
L["STRING_OPTIONS_BAR_ICONFILE_DESC2"] = "Select the icon pack to use."
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM"] = "Custom Text Enabled"
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM2"] = ""
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM2_DESC"] =[=[|cFFFFFF00{data1}|r: generally represents the player position number.

|cFFFFFF00{data2}|r: is always the player name.

|cFFFFFF00{data3}|r: in some cases, this value represent the player's faction or role icon.

|cFFFFFF00{func}|r: runs a customized Lua function adding its return value to the text.
Example: 
{func return 'hello azeroth'}

|cFFFFFF00Scape Sequences|r: use to change color or add textures. Search 'UI escape sequences' for more information.]=]
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM_DESC"] = "When enabled, left text is formated following the rules in the box."
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM"] = "Custom Text Enabled"
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM2"] = ""
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM2_DESC"] =[=[|cFFFFFF00{data1}|r: is the first number passed, generally this number represents the total done.

|cFFFFFF00{data2}|r: is the second number passed, most of the times represents the per second average.

|cFFFFFF00{data3}|r: third number passed, normally is the percentage. 

|cFFFFFF00{func}|r: runs a customized Lua function adding its return value to the text.
Example: 
{func return 'hello azeroth'}

|cFFFFFF00Scape Sequences|r: use to change color or add textures. Search 'UI escape sequences' for more information.]=]
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM_DESC"] = "When enabled, right text is formated following the rules in the box."
L["STRING_OPTIONS_BARS"] = "Bar General Settings"
L["STRING_OPTIONS_BARS_DESC"] = "This options control the bar appearance."
L["STRING_OPTIONS_BARSORT_DIRECTION"] = "Sort Direction"
L["STRING_OPTIONS_BARSORT_DIRECTION_DESC"] = "Ascending or descending order of bar numbers."
L["STRING_OPTIONS_BAR_SPACING"] = "Spacing"
L["STRING_OPTIONS_BAR_SPACING_DESC"] = "Increase or decrease the gap size between each row."
L["STRING_OPTIONS_BARSTART"] = "Bar Start After Icon"
L["STRING_OPTIONS_BARSTART_DESC"] = "When disabled the top texture starts at the icon left side instead of the right(useful with transpant icons)."
L["STRING_OPTIONS_BAR_TEXTURE"] = "Texture"
L["STRING_OPTIONS_BAR_TEXTURE_DESC"] =[=[This is the texture used on the top of bar.
The size is changed according with the percentage.]=]
L["STRING_OPTIONS_CAURAS"] = "Collect Auras"
L["STRING_OPTIONS_CAURAS_DESC"] =[=[Enable capture of:

- |cFFFFFF00Buffs Uptime|r
- |cFFFFFF00Debuffs Uptime|r
- |cFFFFFF00Void Zones|r
-|cFFFFFF00 Cooldowns|r]=]
L["STRING_OPTIONS_CDAMAGE"] = "Collect Damage"
L["STRING_OPTIONS_CDAMAGE_DESC"] =[=[Enable capture of:

- |cFFFFFF00Damage Done|r
- |cFFFFFF00Damage Per Second|r
- |cFFFFFF00Friendly Fire|r
- |cFFFFFF00Damage Taken|r]=]
L["STRING_OPTIONS_CENERGY"] = "Collect Energy"
L["STRING_OPTIONS_CENERGY_DESC"] =[=[Enable capture of:

- |cFFFFFF00Mana Restored|r
- |cFFFFFF00Rage Generated|r
- |cFFFFFF00Energy Generated|r
- |cFFFFFF00Runic Power Generated|r]=]
L["STRING_OPTIONS_CHANGE_CLASSCOLORS"] = "Modify Class Colors"
L["STRING_OPTIONS_CHANGE_CLASSCOLORS_DESC"] = "Select new colors for classes."
L["STRING_OPTIONS_CHANGELOG"] = "Version Notes"
L["STRING_OPTIONS_CHART_ADD"] = "Add Data"
L["STRING_OPTIONS_CHART_ADD2"] = "Add"
L["STRING_OPTIONS_CHART_ADDAUTHOR"] = "Author: "
L["STRING_OPTIONS_CHART_ADDCODE"] = "Code: "
L["STRING_OPTIONS_CHART_ADDICON"] = "Icon: "
L["STRING_OPTIONS_CHART_ADDNAME"] = "Name: "
L["STRING_OPTIONS_CHART_ADDVERSION"] = "Version: "
L["STRING_OPTIONS_CHART_AUTHOR"] = "Author"
L["STRING_OPTIONS_CHART_AUTHORERROR"] = "Author name is invalid."
L["STRING_OPTIONS_CHART_CANCEL"] = "Cancel"
L["STRING_OPTIONS_CHART_CLOSE"] = "Close"
L["STRING_OPTIONS_CHART_CODELOADED"] = "The code is already loaded and cannot be displayed."
L["STRING_OPTIONS_CHART_EDIT"] = "Edit Code"
L["STRING_OPTIONS_CHART_ENABLED"] = "Enabled"
L["STRING_OPTIONS_CHART_EXPORT"] = "Export"
L["STRING_OPTIONS_CHART_FUNCERROR"] = "Function is invalid."
L["STRING_OPTIONS_CHART_ICON"] = "Icon"
L["STRING_OPTIONS_CHART_IMPORT"] = "Import"
L["STRING_OPTIONS_CHART_IMPORTERROR"] = "The import string is invalid."
L["STRING_OPTIONS_CHART_NAME"] = "Name"
L["STRING_OPTIONS_CHART_NAMEERROR"] = "The name is invalid."
L["STRING_OPTIONS_CHART_PLUGINWARNING"] = "Install Chart Viewer Plugin for display custom charts."
L["STRING_OPTIONS_CHART_REMOVE"] = "Remove"
L["STRING_OPTIONS_CHART_SAVE"] = "Save"
L["STRING_OPTIONS_CHART_VERSION"] = "Version"
L["STRING_OPTIONS_CHART_VERSIONERROR"] = "Version is invalid."
L["STRING_OPTIONS_CHEAL"] = "Collect Heal"
L["STRING_OPTIONS_CHEAL_DESC"] =[=[Enable capture of:

- |cFFFFFF00Healing Done|r
- |cFFFFFF00Absorbs|r
- |cFFFFFF00Healing Per Second|r
- |cFFFFFF00Overhealing|r
- |cFFFFFF00Healing Taken|r
- |cFFFFFF00Enemy Healed|r
- |cFFFFFF00Damage Prevented|r]=]
L["STRING_OPTIONS_CLEANUP"] = "Auto Erase Trash Segments"
L["STRING_OPTIONS_CLEANUP_DESC"] = "When enabled, trash cleanup segments are removed automatically after two others segments."
L["STRING_OPTIONS_CLOSE_BUTTON_ANCHOR"] = "Close Button:"
L["STRING_OPTIONS_CLOSE_OVERLAY"] = "Overlay Color"
L["STRING_OPTIONS_CLOSE_OVERLAY_DESC"] = "Change the close button overlay color."
L["STRING_OPTIONS_CLOUD"] = "Cloud Capture"
L["STRING_OPTIONS_CLOUD_DESC"] = "When enabled, the data of disabled collectors are collected within others raid members."
L["STRING_OPTIONS_CMISC"] = "Collect Misc"
L["STRING_OPTIONS_CMISC_DESC"] =[=[Enable capture of:

- |cFFFFFF00Crowd Control Break|r
- |cFFFFFF00Dispells|r
- |cFFFFFF00Interrupts|r
- |cFFFFFF00Resurrection|r
- |cFFFFFF00Deaths|r]=]
L["STRING_OPTIONS_COLOR"] = "Color"
L["STRING_OPTIONS_COLORANDALPHA"] = "Color & Alpha"
L["STRING_OPTIONS_COLORFIXED"] = "Fixed Color"
L["STRING_OPTIONS_COMBAT_ALPHA"] = "Modify When"
L["STRING_OPTIONS_COMBAT_ALPHA_1"] = "No Changes"
L["STRING_OPTIONS_COMBAT_ALPHA_2"] = "While In Combat"
L["STRING_OPTIONS_COMBAT_ALPHA_3"] = "While Out of Combat"
L["STRING_OPTIONS_COMBAT_ALPHA_4"] = "While Out of a Group"
L["STRING_OPTIONS_COMBAT_ALPHA_DESC"] =[=[Select how combat affect the window transparency.

|cFFFFFF00No Changes|r: Doesn't modify the alpha.

|cFFFFFF00While In Combat|r: When your character enter in a combat, the alpha chosen is applied on the window.

|cFFFFFF00While Out of Combat|r: The alpha is applied whenever your character isn't in combat.

|cFFFFFF00While Out of a Group|r: When you aren't in party or a raid group, the window assumes the selected alpha.

|cFFFFFF00Important|r: This option overwrite the alpha determined by Auto Transparency feature.]=]
L["STRING_OPTIONS_COMBATTWEEKS"] = "Combat Tweeks"
L["STRING_OPTIONS_COMBATTWEEKS_DESC"] = "Behavioral adjustments on how Details! deal with some combat aspects."
L["STRING_OPTIONS_CONFIRM_ERASE"] = "Do you want erase data?"
L["STRING_OPTIONS_CUSTOMSPELL_ADD"] = "Add Spell"
L["STRING_OPTIONS_CUSTOMSPELLTITLE"] = "Edit Spells Settings"
L["STRING_OPTIONS_CUSTOMSPELLTITLE_DESC"] = "This panel alows you modify the name and icon of spells."
L["STRING_OPTIONS_DATABROKER"] = "Data Broker:"
L["STRING_OPTIONS_DATABROKER_TEXT"] = "Text"
L["STRING_OPTIONS_DATABROKER_TEXT1_DESC"] =[=[|cFFFFFF00{dmg}|r: player damage done.

|cFFFFFF00{dps}|r: player effective damage per second.

|cFFFFFF00{dpos}|r: rank position between members of the raid or party group on damage.

|cFFFFFF00{ddiff}|r: damage difference between you and the first place.

|cFFFFFF00{heal}|r: player healing done.

|cFFFFFF00{hps}|r: player effective healing per second.

|cFFFFFF00{hpos}|r: rank position between members of the raid or party group on healing.

|cFFFFFF00{hdiff}|r: healing difference between you and the first place.

|cFFFFFF00{time}|r: fight elapsed time.]=]
L["STRING_OPTIONS_DATABROKER_TEXT_ADD1"] = "Player Damage Done"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD2"] = "Player Effective Dps"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD3"] = "Damage Position"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD4"] = "Damage Difference"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD5"] = "Player Healing Done"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD6"] = "Player Effective Hps"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD7"] = "Healing Position"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD8"] = "Healing Difference"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD9"] = "Elapsed Combat Time"
L["STRING_OPTIONS_DATACHARTTITLE"] = "Create Timed Data for Charts"
L["STRING_OPTIONS_DATACHARTTITLE_DESC"] = "This panel alows you to create customized data captures for charts creation."
L["STRING_OPTIONS_DATACOLLECT_ANCHOR"] = "Data Types:"
L["STRING_OPTIONS_DESATURATE_MENU"] = "Desaturate Menu"
L["STRING_OPTIONS_DESATURATE_MENU_DESC"] = "Enabling this option, all menu icons on toolbar became black and white."
L["STRING_OPTIONS_DISABLED_RESET"] = "Reset through this button is current disabled, select on its tooltip menu."
L["STRING_OPTIONS_DISABLE_GROUPS"] = "Disable Grouping"
L["STRING_OPTIONS_DISABLE_GROUPS_DESC"] = "When enabled, a window do not group when placed close to another window."
L["STRING_OPTIONS_DISABLE_RESET"] = "Disable Reset Button"
L["STRING_OPTIONS_DISABLE_RESET_DESC"] = "When enabled, is necessary use the tooltip menu from reset button instead of just click on it."
L["STRING_OPTIONS_ED"] = "Erase Data"
L["STRING_OPTIONS_ED1"] = "Manually"
L["STRING_OPTIONS_ED2"] = "Prompt"
L["STRING_OPTIONS_ED3"] = "Auto"
L["STRING_OPTIONS_ED_DESC"] =[=[|cFFFFFF00Manually|r: the user needs to click on the reset button.

|cFFFFFF00Prompt|r: ask to reset on entering on a new instance.

|cFFFFFF00Auto|r: clear data after enter on a new instance.]=]
L["STRING_OPTIONS_EDITIMAGE"] = "Edit Image"
L["STRING_OPTIONS_EDITINSTANCE"] = "Editing Window:"
L["STRING_OPTIONS_ERASECHARTDATA"] = "Erase Charts"
L["STRING_OPTIONS_ERASECHARTDATA_DESC"] = "During the logout, all data gathered for build the charts is erased."
L["STRING_OPTIONS_EXTERNALS_TITLE"] = "Externals Widgets"
L["STRING_OPTIONS_EXTERNALS_TITLE2"] = "This options controls the behavior of many foreign widgets."
L["STRING_OPTIONS_GENERAL"] = "General Settings"
L["STRING_OPTIONS_GENERAL_ANCHOR"] = "General:"
L["STRING_OPTIONS_HIDECOMBATALPHA"] = "Modify To"
L["STRING_OPTIONS_HIDECOMBATALPHA_DESC"] =[=[Changes the transparency to this value when your character matches with the chosen rule.

|cFFFFFF00Zero|r: fully hidden, can't interact within the window.

|cFFFFFF001 - 100|r: not hidden, only the transparency is changed, you can interact with the window.]=]
L["STRING_OPTIONS_HIDE_ICON"] = "Hide Icon"
L["STRING_OPTIONS_HIDE_ICON_DESC"] =[=[When enabled, the icon on the top left corner isn't draw.

Some skins may prefer remove this icon.]=]
L["STRING_OPTIONS_HOTCORNER"] = "Show button"
L["STRING_OPTIONS_HOTCORNER_ACTION"] = "On Click"
L["STRING_OPTIONS_HOTCORNER_ACTION_DESC"] = "Select what to do when the button on the Hotcorner bar is clicked with the left mouse button."
L["STRING_OPTIONS_HOTCORNER_ANCHOR"] = "Hotcorner:"
L["STRING_OPTIONS_HOTCORNER_DESC"] = "Show or hide the button over Hotcorner panel."
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK"] = "Enable Quick Click"
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK_DESC"] =[=[Enable oe disable the Quick Click feature for Hotcorners.

Quick button is localized at the further top left pixel, moving your mouse all the way to there, activities the top left hot corner and if clicked an action is performed.]=]
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK_FUNC"] = "Quick Click On Click"
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK_FUNC_DESC"] = "Select what to do when the Quick Click button on Hotcorner is clicked."
L["STRING_OPTIONS_INSBUTTON_X"] = "Instance Button X"
L["STRING_OPTIONS_INSBUTTON_X_DESC"] = "Change the window button position."
L["STRING_OPTIONS_INSBUTTON_Y"] = "Instance Button Y"
L["STRING_OPTIONS_INSBUTTON_Y_DESC"] = "Change the window button position."
L["STRING_OPTIONS_INSTANCE_ALPHA"] = "Background Alpha"
L["STRING_OPTIONS_INSTANCE_ALPHA2"] = "Background Color"
L["STRING_OPTIONS_INSTANCE_ALPHA2_DESC"] = "This option let you change the color of the window background."
L["STRING_OPTIONS_INSTANCE_ALPHA_DESC"] = "This option let you change the transparency of the window background."
L["STRING_OPTIONS_INSTANCE_BACKDROP"] = "Background Texture"
L["STRING_OPTIONS_INSTANCE_BACKDROP_DESC"] =[=[Select the background texture used by this window.

|cFFFFFF00Default|r: Details Background.]=]
L["STRING_OPTIONS_INSTANCE_BUTTON_ANCHOR"] = "Window Button:"
L["STRING_OPTIONS_INSTANCE_COLOR"] = "Window Color"
L["STRING_OPTIONS_INSTANCE_COLOR_DESC"] =[=[Change the color and alpha of this window.

|cFFFFFF00Important|r: the alpha chosen here are overwritten with |cFFFFFF00Auto Transparency|r values when enabled.

|cFFFFFF00Important|r: selecting the window color overwrite any color customization over the statusbar.]=]
L["STRING_OPTIONS_INSTANCE_CURRENT"] = "Auto Switch To Current"
L["STRING_OPTIONS_INSTANCE_CURRENT_DESC"] = "Whenever a combat start and there is no other window on current segment, this window auto switch to current segment."
L["STRING_OPTIONS_INSTANCE_DELETE"] = "Delete"
L["STRING_OPTIONS_INSTANCE_DELETE_DESC"] =[=[Remove permanently a window.
Your game screen may reload during the erase process.]=]
L["STRING_OPTIONS_INSTANCE_OVERLAY"] = "Overlay Color"
L["STRING_OPTIONS_INSTANCE_OVERLAY_DESC"] = "Change the window button overlay color."
L["STRING_OPTIONS_INSTANCES"] = "Windows:"
L["STRING_OPTIONS_INSTANCE_SKIN"] = "Skin"
L["STRING_OPTIONS_INSTANCE_SKIN_DESC"] = "Modify window appearance based on a skin theme."
L["STRING_OPTIONS_INSTANCE_STATUSBAR_ANCHOR"] = "Statusbar:"
L["STRING_OPTIONS_INSTANCE_STATUSBARCOLOR"] = "Color and Transparency"
L["STRING_OPTIONS_INSTANCE_STATUSBARCOLOR_DESC"] =[=[Select the color used by the statusbar.

|cFFFFFF00Important|r: this option overwrite the color and transparency chosen over Window Color.]=]
L["STRING_OPTIONS_INSTANCE_STRATA"] = "Layer Strata"
L["STRING_OPTIONS_INSTANCE_STRATA_DESC"] =[=[Selects the layer height that the frame will be placed on.

Low layer is the default and makes the window stay behind of the most interface panels.

Using high layer the window might stay in front of the major others panels.

When changing the layer height you may find some conflict with others panels, overlapping each other.]=]
L["STRING_OPTIONS_INSTANCE_TEXTCOLOR"] = "Text Color"
L["STRING_OPTIONS_INSTANCE_TEXTCOLOR_DESC"] = "Change the window button text color."
L["STRING_OPTIONS_INSTANCE_TEXTFONT"] = "Text Font"
L["STRING_OPTIONS_INSTANCE_TEXTFONT_DESC"] = "Change the window button text font."
L["STRING_OPTIONS_INSTANCE_TEXTSIZE"] = "Text Size"
L["STRING_OPTIONS_INSTANCE_TEXTSIZE_DESC"] = "Change the window button text size."
L["STRING_OPTIONS_INTERFACEDIT"] = "Interface Edit Mode"
L["STRING_OPTIONS_LEFT_MENU_ANCHOR"] = "Menu Settings:"
L["STRING_OPTIONS_LOCKSEGMENTS"] = "Segments Locked"
L["STRING_OPTIONS_LOCKSEGMENTS_DESC"] = "When enabled, changing a segment in any window does change in all the others opened windows too."
L["STRING_OPTIONS_MAXINSTANCES"] = "Max Window Amount"
L["STRING_OPTIONS_MAXINSTANCES_DESC"] =[=[Limit the amount of windows which can be created.

Clicking on the window button(#1) opens a new window.

Hold hover it to show a menu with closed window which can be reopened.]=]
L["STRING_OPTIONS_MAXSEGMENTS"] = "Max. Segments"
L["STRING_OPTIONS_MAXSEGMENTS_DESC"] =[=[This option control how many segments you want to maintain.

Recommended value is |cFFFFFF0012|r, but feel free to adjust this number to be comfortable for you.

Computers with |cFFFFFF002GB|r or less memory ram should keep low segments amount, this can help your system overall.]=]
L["STRING_OPTIONS_MEMORYT"] = "Memory Threshold"
L["STRING_OPTIONS_MEMORYT_DESC"] =[=[Details! have internal mechanisms to handle memory and try adjust it self within the amount of memory avaliable on your system.

Also is recommeded keep the amount of segments low on systems with |cFFFFFF002GB|r or less of memory.]=]
L["STRING_OPTIONS_MENU2_X"] = "Menu Pos X"
L["STRING_OPTIONS_MENU2_X_DESC"] = "Change the position of all right menu buttons, the first slider changes the horizontal axis, the second changes the vertical axis."
L["STRING_OPTIONS_MENU2_Y"] = "Menu Pos Y"
L["STRING_OPTIONS_MENU2_Y_DESC"] = "Change the position of all right menu buttons, the first slider changes the horizontal axis, the second changes the vertical axis."
L["STRING_OPTIONS_MENU_ALPHA"] = "Transparency When Interacting:"
L["STRING_OPTIONS_MENU_ALPHAENABLED"] = "Enabled"
L["STRING_OPTIONS_MENU_ALPHAENABLED_DESC"] =[=[When enabled, the transparency changes automatically when you hover and leave the window.

|cFFFFFF00Important|r: This settings overwrites the alpha selected on Window Color option under Window Settings section.]=]
L["STRING_OPTIONS_MENU_ALPHAENTER"] = "When Interacting"
L["STRING_OPTIONS_MENU_ALPHAENTER_DESC"] = "When you have the mouse over the window, the transparency changes to this value."
L["STRING_OPTIONS_MENU_ALPHAICONSTOO"] = "Affect Buttons"
L["STRING_OPTIONS_MENU_ALPHAICONSTOO_DESC"] = "If enabled, all icons, buttons, also have their alpha affected by this feature."
L["STRING_OPTIONS_MENU_ALPHALEAVE"] = "Stand by"
L["STRING_OPTIONS_MENU_ALPHALEAVE_DESC"] = "When you don't have the mouse over the window, the transparency changes to this value."
L["STRING_OPTIONS_MENU_ALPHAWARNING"] = "Auto Transparency is enabled, alpha may not be affected."
L["STRING_OPTIONS_MENU_ANCHOR"] = "Menu Anchor Side"
L["STRING_OPTIONS_MENU_ANCHOR_DESC"] = "Change if the left menu is attached within left side of window or in the right side."
L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORX"] = "Pos X"
L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORX_DESC"] = "Adjust the attribute text location on the X axis."
L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORY"] = "Pos Y"
L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORY_DESC"] = "Adjust the attribute text location on the Y axis."
L["STRING_OPTIONS_MENU_ATTRIBUTE_ENABLED"] = "Enabled"
L["STRING_OPTIONS_MENU_ATTRIBUTE_ENABLED_DESC"] = "Enable or disable the attribute name which is current shown on this window."
L["STRING_OPTIONS_MENU_ATTRIBUTE_FONT"] = "Text Font"
L["STRING_OPTIONS_MENU_ATTRIBUTE_FONT_DESC"] = "Select the text font for attribute text."
L["STRING_OPTIONS_MENU_ATTRIBUTESETTINGS_ANCHOR"] = "Settings:"
L["STRING_OPTIONS_MENU_ATTRIBUTE_SHADOW"] = "Shadow"
L["STRING_OPTIONS_MENU_ATTRIBUTE_SHADOW_DESC"] = "Enable or disable the shadow on the text."
L["STRING_OPTIONS_MENU_ATTRIBUTE_SIDE"] = "Text Anchor"
L["STRING_OPTIONS_MENU_ATTRIBUTE_SIDE_DESC"] = "Choose where the text is anchored."
L["STRING_OPTIONS_MENU_ATTRIBUTETEXT_ANCHOR"] = "Texts:"
L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTCOLOR"] = "Text Color"
L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTCOLOR_DESC"] = "Change the attribute text color."
L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTSIZE"] = "Text Size"
L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTSIZE_DESC"] = "Adjust the size of attribute text."
L["STRING_OPTIONS_MENU_AUTOHIDE_ANCHOR"] = "Auto Hide Menu Buttons"
L["STRING_OPTIONS_MENU_AUTOHIDE_DESC"] = "When enabled the menu automatically hides it self when the mouse leaves the window and shows up when you are interacting with it again."
L["STRING_OPTIONS_MENU_AUTOHIDE_LEFT"] = "Auto Hide Menu"
L["STRING_OPTIONS_MENU_AUTOHIDE_RIGHT"] = "Auto Hide Menu"
L["STRING_OPTIONS_MENU_BUTTONSSIZE"] = "Buttons Size"
L["STRING_OPTIONS_MENU_BUTTONSSIZE_DESC"] = "Choose the buttons size. This also modify the buttons added by plugins."
L["STRING_OPTIONSMENU_COMBAT"] = "Combat"
L["STRING_OPTIONSMENU_DATACHART"] = "Data for Charts"
L["STRING_OPTIONSMENU_DATACOLLECT"] = "Data Collector"
L["STRING_OPTIONSMENU_DATAFEED"] = "Data Feed"
L["STRING_OPTIONSMENU_DISPLAY"] = "Display"
L["STRING_OPTIONSMENU_DISPLAY_DESC"] = "Overall basic adjustments and quick window control."
L["STRING_OPTIONS_MENU_FONT_SIZE"] = "Menus Text Size"
L["STRING_OPTIONS_MENU_FONT_SIZE_DESC"] = "Modify the font size on all menus."
L["STRING_OPTIONS_MENU_IGNOREBARS"] = "Ignore Rows"
L["STRING_OPTIONS_MENU_IGNOREBARS_DESC"] = "When enabled, all rows on this window aren't affected by this mechanism."
L["STRING_OPTIONSMENU_LEFTMENU"] = "Menus: Left Buttons"
L["STRING_OPTIONSMENU_MISC"] = "Miscellaneous"
L["STRING_OPTIONSMENU_PERFORMANCE"] = "Performance Tweaks"
L["STRING_OPTIONSMENU_PLUGINS"] = "Plugins Management"
L["STRING_OPTIONSMENU_PROFILES"] = "Profiles"
L["STRING_OPTIONSMENU_RAIDTOOLS"] = "Raid Tools"
L["STRING_OPTIONSMENU_RIGHTMENU"] = "Menus: Right Buttons"
L["STRING_OPTIONSMENU_ROWSETTINGS"] = "Row Settings"
L["STRING_OPTIONSMENU_ROWTEXTS"] = "Row Texts"
L["STRING_OPTIONS_MENU_SHOWBUTTONS"] = "Show Buttons"
L["STRING_OPTIONS_MENU_SHOWBUTTONS_DESC"] = "Choose which buttons are shown on the toolbar."
L["STRING_OPTIONSMENU_SHOWHIDE"] = "Show & Hide Settings"
L["STRING_OPTIONSMENU_SKIN"] = "Skin Selection"
L["STRING_OPTIONSMENU_SPELLS"] = "Spell Customization"
L["STRING_OPTIONSMENU_TITLETEXT"] = "Title Text"
L["STRING_OPTIONSMENU_TOOLTIP"] = "Tooltips"
L["STRING_OPTIONSMENU_WALLPAPER"] = "Wallpaper"
L["STRING_OPTIONSMENU_WINDOW"] = "Window Settings"
L["STRING_OPTIONS_MENU_X"] = "Menu Pos X"
L["STRING_OPTIONS_MENU_X_DESC"] = "Change the position of all left menu buttons, the first slider changes the horizontal axis, the second changes the vertical axis."
L["STRING_OPTIONS_MENU_Y"] = "Menu Pos Y"
L["STRING_OPTIONS_MENU_Y_DESC"] = "Change the position of all left menu buttons, the first slider changes the horizontal axis, the second changes the vertical axis."
L["STRING_OPTIONS_MICRODISPLAYSSIDE"] = "Micro Displays Anchor"
L["STRING_OPTIONS_MICRODISPLAYSSIDE_DESC"] = "Place the micro displays on the top of the window or on the bottom side."
L["STRING_OPTIONS_MICRODISPLAYWARNING"] = "Micro displays isn't shown because statusbar is disabled."
L["STRING_OPTIONS_MINIMAP"] = "Show Icon"
L["STRING_OPTIONS_MINIMAP_ACTION"] = "On Click"
L["STRING_OPTIONS_MINIMAP_ACTION1"] = "Open Options Panel"
L["STRING_OPTIONS_MINIMAP_ACTION2"] = "Reset Segments"
L["STRING_OPTIONS_MINIMAP_ACTION3"] = "Show/Hide Windows"
L["STRING_OPTIONS_MINIMAP_ACTION_DESC"] = "Select what to do when the icon on the minimap is clicked with the left mouse button."
L["STRING_OPTIONS_MINIMAP_ANCHOR"] = "Minimap:"
L["STRING_OPTIONS_MINIMAP_DESC"] = "Show or Hide minimap icon."
L["STRING_OPTIONS_MISCTITLE"] = "Miscellaneous Settings"
L["STRING_OPTIONS_MISCTITLE2"] = "This options controls several options."
L["STRING_OPTIONS_NICKNAME"] = "Nickname"
L["STRING_OPTIONS_NICKNAME_DESC"] =[=[Replace your character name.

The nickname is also broadcasted for guild members and Details! shown it instead of your character name.]=]
L["STRING_OPTIONS_OPEN_ROWTEXT_EDITOR"] = "Row Text Editor"
L["STRING_OPTIONS_OPEN_TEXT_EDITOR"] = "Open Text Editor"
L["STRING_OPTIONS_OVERALL_ALL"] = "All Segments"
L["STRING_OPTIONS_OVERALL_ALL_DESC"] = "All segments are added to overall data."
L["STRING_OPTIONS_OVERALL_ANCHOR"] = "Overall Data:"
L["STRING_OPTIONS_OVERALL_CHALLENGE"] = "Clear On Challenge Mode"
L["STRING_OPTIONS_OVERALL_CHALLENGE_DESC"] = "When enabled, overall data is automatically wiped when a new challenge mode run begins."
L["STRING_OPTIONS_OVERALL_DUNGEONBOSS"] = "Dungeon Bosses"
L["STRING_OPTIONS_OVERALL_DUNGEONBOSS_DESC"] = "Segments with dungeon bosses are added to overall data."
L["STRING_OPTIONS_OVERALL_DUNGEONCLEAN"] = "Dungeon Trash"
L["STRING_OPTIONS_OVERALL_DUNGEONCLEAN_DESC"] = "Segments with dungeon trash mobs cleanup are added to overall data."
L["STRING_OPTIONS_OVERALL_NEWBOSS"] = "Clear On New Boss"
L["STRING_OPTIONS_OVERALL_NEWBOSS_DESC"] = "When enabled, overall data is automatically wiped when facing a different raid boss."
L["STRING_OPTIONS_OVERALL_RAIDBOSS"] = "Raid Bosses"
L["STRING_OPTIONS_OVERALL_RAIDBOSS_DESC"] = "Segments with raid encounters are added to overall data."
L["STRING_OPTIONS_OVERALL_RAIDCLEAN"] = "Raid Trash"
L["STRING_OPTIONS_OVERALL_RAIDCLEAN_DESC"] = "Segments with raid trash mobs cleanup are added to overall data."
L["STRING_OPTIONS_PANIMODE"] = "Panic Mode"
L["STRING_OPTIONS_PANIMODE_DESC"] = "When enabled and you got dropped from the game(by a disconnect, for instance) and you are fighting against a boss encounter, all segments are erased, this make your logoff process faster."
L["STRING_OPTIONS_PERCENT_TYPE"] = "Percentage Type"
L["STRING_OPTIONS_PERCENT_TYPE_DESC"] =[=[Changes the percentage method:

|cFFFFFF00Relative Total|r: the percentage shows the actor fraction of total amount made by all raid members.

|cFFFFFF00Relative Top Player|r: the percentage is relative within the amount score of the top player.]=]
L["STRING_OPTIONS_PERFORMANCE"] = "Performance"
L["STRING_OPTIONS_PERFORMANCE1"] = "Performance Tweaks"
L["STRING_OPTIONS_PERFORMANCE1_DESC"] = "This options can help save some cpu usage."
L["STRING_OPTIONS_PERFORMANCE_ANCHOR"] = "General:"
L["STRING_OPTIONS_PERFORMANCE_ARENA"] = "Arena"
L["STRING_OPTIONS_PERFORMANCE_BG15"] = "Battleground 15"
L["STRING_OPTIONS_PERFORMANCE_BG40"] = "Battleground 40"
L["STRING_OPTIONS_PERFORMANCECAPTURES"] = "Data Collector"
L["STRING_OPTIONS_PERFORMANCECAPTURES_DESC"] = "This options are responsible for analysis and collect combat data."
L["STRING_OPTIONS_PERFORMANCE_DUNGEON"] = "Dungeon"
L["STRING_OPTIONS_PERFORMANCE_ENABLE"] = "Enabled"
L["STRING_OPTIONS_PERFORMANCE_ENABLE_DESC"] = "If enable, this settings is apply when your raid match with the raid type selected."
L["STRING_OPTIONS_PERFORMANCE_MYTHIC"] = "Mythic"
L["STRING_OPTIONS_PERFORMANCE_PROFILE_LOAD"] = "Performance Profile Changed: "
L["STRING_OPTIONS_PERFORMANCEPROFILES_ANCHOR"] = "Performance Profiles:"
L["STRING_OPTIONS_PERFORMANCE_RAID15"] = "Raid 10-15"
L["STRING_OPTIONS_PERFORMANCE_RAID30"] = "Raid 16-30"
L["STRING_OPTIONS_PERFORMANCE_RF"] = "Raid Finder"
L["STRING_OPTIONS_PERFORMANCE_TYPES"] = "Type"
L["STRING_OPTIONS_PERFORMANCE_TYPES_DESC"] = "This is the types of raid where different options can automatically change."
L["STRING_OPTIONS_PICKCOLOR"] = "color"
L["STRING_OPTIONS_PICONS_DIRECTION"] = "Plugin Icons Direction"
L["STRING_OPTIONS_PICONS_DIRECTION_DESC"] = "Change the direction which plugins icons are displayed on the toolbar."
L["STRING_OPTIONS_PLUGINS"] = "Plugins"
L["STRING_OPTIONS_PLUGINS_AUTHOR"] = "Author"
L["STRING_OPTIONS_PLUGINS_ENABLED"] = "Enabled"
L["STRING_OPTIONS_PLUGINS_NAME"] = "Name"
L["STRING_OPTIONS_PLUGINS_OPTIONS"] = "Options"
L["STRING_OPTIONS_PLUGINS_RAID_ANCHOR"] = "Raid Plugins"
L["STRING_OPTIONS_PLUGINS_SOLO_ANCHOR"] = "Solo Plugins"
L["STRING_OPTIONS_PLUGINS_TOOLBAR_ANCHOR"] = "Toolbar Plugins"
L["STRING_OPTIONS_PLUGINS_VERSION"] = "Version"
L["STRING_OPTIONS_PRESETNONAME"] = "Give a name to your preset."
L["STRING_OPTIONS_PRESETTOOLD"] = "This preset is too old and cannot be loaded at this version of Details!."
L["STRING_OPTIONS_PROFILE_COPYOKEY"] = "Profile successful copied."
L["STRING_OPTIONS_PROFILE_FIELDEMPTY"] = "Name field is empty."
L["STRING_OPTIONS_PROFILE_LOADED"] = "Profile loaded:"
L["STRING_OPTIONS_PROFILE_NOTCREATED"] = "Profile not created."
L["STRING_OPTIONS_PROFILE_POSSIZE"] = "Save Size and Position"
L["STRING_OPTIONS_PROFILE_POSSIZE_DESC"] = "When enabled, this profile preserves the positioning and size of windows."
L["STRING_OPTIONS_PROFILE_REMOVEOKEY"] = "Profile successful removed."
L["STRING_OPTIONS_PROFILES_ANCHOR"] = "Settings:"
L["STRING_OPTIONS_PROFILES_COPY"] = "Copy Profile From"
L["STRING_OPTIONS_PROFILES_COPY_DESC"] = "Copy all settings from the selected profile to current profile overwriting all values."
L["STRING_OPTIONS_PROFILES_CREATE"] = "Create Profile"
L["STRING_OPTIONS_PROFILES_CREATE_DESC"] = "Create a new profile."
L["STRING_OPTIONS_PROFILES_CURRENT"] = "Current Profile:"
L["STRING_OPTIONS_PROFILES_CURRENT_DESC"] = "This is the name of current actived profile."
L["STRING_OPTIONS_PROFILE_SELECT"] = "select a profile."
L["STRING_OPTIONS_PROFILE_SELECTEXISTING"] = "Select a existing profile or continue using a new one for this character:"
L["STRING_OPTIONS_PROFILES_ERASE"] = "Remove Profile"
L["STRING_OPTIONS_PROFILES_ERASE_DESC"] = "Remove the selected profile."
L["STRING_OPTIONS_PROFILES_RESET"] = "Reset Current Profile"
L["STRING_OPTIONS_PROFILES_RESET_DESC"] = "Reset all settings of the selected profile to default values."
L["STRING_OPTIONS_PROFILES_SELECT"] = "Select Profile"
L["STRING_OPTIONS_PROFILES_SELECT_DESC"] = "Load a profile, all settings are overwrite by the new profile settings."
L["STRING_OPTIONS_PROFILES_TITLE"] = "Profiles"
L["STRING_OPTIONS_PROFILES_TITLE_DESC"] = "This options allow you share the same settings between different characters."
L["STRING_OPTIONS_PROFILE_USENEW"] = "Use New Profile"
L["STRING_OPTIONS_PS_ABBREVIATE"] = "Abbreviation Type"
L["STRING_OPTIONS_PS_ABBREVIATE_COMMA"] = "Comma"
L["STRING_OPTIONS_PS_ABBREVIATE_DESC"] =[=[Choose the abbreviation method.

|cFFFFFF00None|r: no abbreviation, the raw number is shown.

|cFFFFFF00ToK I|r: the number is abbreviated showing the fractional-part.

59874 = 59.8K
520.600 = 520.6K
19.530.000 = 19.53M

|cFFFFFF00ToK II|r: Is the same as ToK I, but, numbers between one hundred and one million doesn't show fractional-part.

59874 = 59.8K
520.600 = 520K
19.530.000 = 19.53M

|cFFFFFF00ToM I|r: Numbers ewhichs or biggest of one million doesn't show the fractional-part.

59874 = 59.8K
520.600 = 520.6K
19.530.000 = 19M

|cFFFFFF00Lower|r: The letters K and M are lowercase.

|cFFFFFF00Upper|r: The letter K and M are uppercase.]=]
L["STRING_OPTIONS_PS_ABBREVIATE_NONE"] = "None"
L["STRING_OPTIONS_PS_ABBREVIATE_TOK"] = "ToK I Upper"
L["STRING_OPTIONS_PS_ABBREVIATE_TOK0"] = "ToM I Upper"
L["STRING_OPTIONS_PS_ABBREVIATE_TOK0MIN"] = "ToM I Lower"
L["STRING_OPTIONS_PS_ABBREVIATE_TOK2"] = "ToK II Upper"
L["STRING_OPTIONS_PS_ABBREVIATE_TOK2MIN"] = "ToK II Lower"
L["STRING_OPTIONS_PS_ABBREVIATE_TOKMIN"] = "ToK I Lower"
L["STRING_OPTIONS_PVPFRAGS"] = "Only Pvp Frags"
L["STRING_OPTIONS_PVPFRAGS_DESC"] = "When enabled, only kills against enemy players count on |cFFFFFF00damage > frags|r display."
L["STRING_OPTIONS_REALMNAME"] = "Remove Realm Name"
L["STRING_OPTIONS_REALMNAME_DESC"] =[=[When enabled, the realm name of character isn't displayed with the name, see the example below:

|cFFFFFF00Disabled|r: Charles-Netherwing
|cFFFFFF00Enabled|r: Charles]=]
L["STRING_OPTIONS_REPORT_ANCHOR"] = "Report:"
L["STRING_OPTIONS_REPORT_HEALLINKS"] = "Helpful Spell Links"
L["STRING_OPTIONS_REPORT_HEALLINKS_DESC"] =[=[When sending a report and this option is enabled, |cFF55FF55helpful|r spells are reported with the spell link instead of its name.

|cFFFF5555Harmful|r spells are reported with links by default.]=]
L["STRING_OPTIONS_RESET_BUTTON_ANCHOR"] = "Reset Button:"
L["STRING_OPTIONS_RESET_OVERLAY"] = "Overlay Color"
L["STRING_OPTIONS_RESET_OVERLAY_DESC"] =[=[Modify the reset button overlay color.

Only applied when reset button is hosted by this window.]=]
L["STRING_OPTIONS_RESET_SMALL"] = "Always Small"
L["STRING_OPTIONS_RESET_SMALL_DESC"] =[=[When enabled, reset button always shown as his smaller size.

Only applied when reset button is hosted by this window.]=]
L["STRING_OPTIONS_RESET_TEXTCOLOR"] = "Text Color"
L["STRING_OPTIONS_RESET_TEXTCOLOR_DESC"] =[=[Modify the reset button text color.

Only applied when reset button is hosted by this window.]=]
L["STRING_OPTIONS_RESET_TEXTFONT"] = "Text Font"
L["STRING_OPTIONS_RESET_TEXTFONT_DESC"] =[=[Modify the reset button text font.

Only applied when reset button is hosted by this window.]=]
L["STRING_OPTIONS_RESET_TEXTSIZE"] = "Text Size"
L["STRING_OPTIONS_RESET_TEXTSIZE_DESC"] =[=[Modify the reset button text size.

Only applied when reset button is hosted by this window.]=]
L["STRING_OPTIONS_RESET_TO_DEFAULT"] = "Reset to Default"
L["STRING_OPTIONS_ROW_SETTING_ANCHOR"] = "General:"
L["STRING_OPTIONS_RT_COOLDOWN1"] = "%s used on %s!"
L["STRING_OPTIONS_RT_COOLDOWN2"] = "%s used!"
L["STRING_OPTIONS_RT_COOLDOWNS_ANCHOR"] = "Announce Cooldowns:"
L["STRING_OPTIONS_RT_COOLDOWNS_CHANNEL"] = "Channel"
L["STRING_OPTIONS_RT_COOLDOWNS_CHANNEL_DESC"] = "Which chat channel is used to send the alert message."
L["STRING_OPTIONS_RT_COOLDOWNS_CUSTOM"] = "Custom Text"
L["STRING_OPTIONS_RT_COOLDOWNS_CUSTOM_DESC"] =[=[Type your own phrase to send.

Use |cFFFFFF00{spell}|r to add the cooldown spell name.

Use |cFFFFFF00{target}|r to add the player target name.]=]
L["STRING_OPTIONS_RT_COOLDOWNS_ONOFF"] = "Enabled"
L["STRING_OPTIONS_RT_COOLDOWNS_ONOFF_DESC"] = "When you use a cooldown, a message is sent through the selected channel."
L["STRING_OPTIONS_RT_COOLDOWNS_SELECT"] = "Ignored Cooldown List"
L["STRING_OPTIONS_RT_COOLDOWNS_SELECT_DESC"] = "Choose which cooldowns should be ignored."
L["STRING_OPTIONS_RT_DEATH_MSG"] = "Details! %s's Death"
L["STRING_OPTIONS_RT_DEATHS_ANCHOR"] = "Announce Deaths:"
L["STRING_OPTIONS_RT_DEATHS_FIRST"] = "Only First"
L["STRING_OPTIONS_RT_DEATHS_FIRST_DESC"] = "Make it only annouce the first X deaths during the encounter."
L["STRING_OPTIONS_RT_DEATHS_HITS"] = "Hits Amount"
L["STRING_OPTIONS_RT_DEATHS_HITS_DESC"] = "When annoucing the death, show how many hits."
L["STRING_OPTIONS_RT_DEATHS_ONOFF"] = "Enabled"
L["STRING_OPTIONS_RT_DEATHS_ONOFF_DESC"] = "When a raid member dies, it send to raid channel what killed that player."
L["STRING_OPTIONS_RT_DEATHS_WHERE"] = "Instances"
L["STRING_OPTIONS_RT_DEATHS_WHERE1"] = "Raid & Dungeon"
L["STRING_OPTIONS_RT_DEATHS_WHERE2"] = "Only Raid"
L["STRING_OPTIONS_RT_DEATHS_WHERE3"] = "Only Dungeon"
L["STRING_OPTIONS_RT_DEATHS_WHERE_DESC"] =[=[Select where deaths can be reported.

|cFFFFFF00Important|r for raids /raid channel is used, /p while in dungeons.]=]
L["STRING_OPTIONS_RT_FIRST_HIT"] = "First Hit"
L["STRING_OPTIONS_RT_FIRST_HIT_DESC"] = "Prints over chat panel(|cFFFFFF00only for you|r) who delivered the first hit, usually is who started the fight."
L["STRING_OPTIONS_RT_IGNORE_TITLE"] = "Ignore Cooldowns"
L["STRING_OPTIONS_RT_INFOS"] = "Extra Informations:"
L["STRING_OPTIONS_RT_INFOS_PREPOTION"] = "Pre Potion Usage"
L["STRING_OPTIONS_RT_INFOS_PREPOTION_DESC"] = "When enabled and after a raid encounter, prints in your chat(|cFFFFFF00only for you|r) who used a potion before the pull."
L["STRING_OPTIONS_RT_INTERRUPT"] = "%s interrupted!"
L["STRING_OPTIONS_RT_INTERRUPT_ANCHOR"] = "Announce Interrupts:"
L["STRING_OPTIONS_RT_INTERRUPT_NEXT"] = "Next: %s"
L["STRING_OPTIONS_RT_INTERRUPTS_CHANNEL"] = "Channel"
L["STRING_OPTIONS_RT_INTERRUPTS_CHANNEL_DESC"] = "Which chat channel is used to send the alert message."
L["STRING_OPTIONS_RT_INTERRUPTS_CUSTOM"] = "Custom Text"
L["STRING_OPTIONS_RT_INTERRUPTS_CUSTOM_DESC"] =[=[Type your own phrase to send.

Use |cFFFFFF00{spell}|r to add the interrupted spell name.

Use |cFFFFFF00{next}|r to add the name of the next player filled in the 'next' box.]=]
L["STRING_OPTIONS_RT_INTERRUPTS_NEXT"] = "Next Player"
L["STRING_OPTIONS_RT_INTERRUPTS_NEXT_DESC"] = "When exists a interrupt sequence, place the player name responsible for the next interrupt."
L["STRING_OPTIONS_RT_INTERRUPTS_ONOFF"] = "Enabled"
L["STRING_OPTIONS_RT_INTERRUPTS_ONOFF_DESC"] = "When you successful interrupt a spell cast, a message is sent."
L["STRING_OPTIONS_RT_INTERRUPTS_WHISPER"] = "Whisper To"
L["STRING_OPTIONS_RT_OTHER_ANCHOR"] = "General:"
L["STRING_OPTIONS_RT_TITLE"] = "Tools for Raiders"
L["STRING_OPTIONS_RT_TITLE_DESC"] = "In this panel you can active several mechanisms for help you during raids."
L["STRING_OPTIONS_SAVELOAD"] = "Save and Load"
L["STRING_OPTIONS_SAVELOAD_APPLYALL"] = "The current skin has been applied in all other windows."
L["STRING_OPTIONS_SAVELOAD_APPLYALL_DESC"] = "Apply the current skin on all windows created."
L["STRING_OPTIONS_SAVELOAD_APPLYTOALL"] = "Apply in all Windows"
L["STRING_OPTIONS_SAVELOAD_CREATE_DESC"] =[=[Type the custom skin name on the field and click on create button.

This process create a custom skin which you can load on others windows or just save for another time.]=]
L["STRING_OPTIONS_SAVELOAD_DESC"] = "This options allow you to save or load predefined settings."
L["STRING_OPTIONS_SAVELOAD_ERASE_DESC"] = "This option erase a previous saved skin."
L["STRING_OPTIONS_SAVELOAD_EXPORT"] = "Export"
L["STRING_OPTIONS_SAVELOAD_EXPORT_COPY"] = "Press CTRL + C"
L["STRING_OPTIONS_SAVELOAD_EXPORT_DESC"] = "Saves the skin in text format."
L["STRING_OPTIONS_SAVELOAD_IMPORT"] = "Import"
L["STRING_OPTIONS_SAVELOAD_IMPORT_DESC"] = "Import a skin in text format."
L["STRING_OPTIONS_SAVELOAD_IMPORT_OKEY"] = "Skin successful imported."
L["STRING_OPTIONS_SAVELOAD_LOAD"] = "Apply"
L["STRING_OPTIONS_SAVELOAD_LOAD_DESC"] = "Choose one of the previous saved skins to apply on the current selected window."
L["STRING_OPTIONS_SAVELOAD_MAKEDEFAULT"] = "Set Standard"
L["STRING_OPTIONS_SAVELOAD_PNAME"] = "Name"
L["STRING_OPTIONS_SAVELOAD_REMOVE"] = "Erase"
L["STRING_OPTIONS_SAVELOAD_RESET"] = "Load Default Skin"
L["STRING_OPTIONS_SAVELOAD_SAVE"] = "save"
L["STRING_OPTIONS_SAVELOAD_SKINCREATED"] = "Skin created."
L["STRING_OPTIONS_SAVELOAD_STD_DESC"] =[=[Set the current appearance as Standard Skin.

This skin is applied on all new windows created.]=]
L["STRING_OPTIONS_SAVELOAD_STDSAVE"] = "Standard Skin has been saved, new windows will be using this skin by default."
L["STRING_OPTIONS_SCROLLBAR"] = "Scroll Bar"
L["STRING_OPTIONS_SCROLLBAR_DESC"] =[=[Enable ou Disable the scroll bar.

By default, Details! scroll bars are replaced by a mechanism that stretches the window.

The |cFFFFFF00stretch handle|r is outside over window button/menu(left of close button).]=]
L["STRING_OPTIONS_SEGMENTSSAVE"] = "Segments Saved"
L["STRING_OPTIONS_SEGMENTSSAVE_DESC"] =[=[This options controls how many segments you wish save between game sesions.

High values can make your character logoff take more time

If you rarelly use the data of last day, it`s high recommeded leave this option in |cFFFFFF001|r.]=]
L["STRING_OPTIONS_SHOWHIDE"] = "Show & Hide settings"
L["STRING_OPTIONS_SHOWHIDE_DESC"] = "Controls when a window should hide or appear on the screen."
L["STRING_OPTIONS_SHOW_SIDEBARS"] = "Show Borders"
L["STRING_OPTIONS_SHOW_SIDEBARS_DESC"] = "Show or hide window borders."
L["STRING_OPTIONS_SHOW_STATUSBAR"] = "Show Statusbar"
L["STRING_OPTIONS_SHOW_STATUSBAR_DESC"] = "Show or hide the bottom statusbar."
L["STRING_OPTIONS_SHOW_TOTALBAR"] = "Show Total Bar"
L["STRING_OPTIONS_SHOW_TOTALBAR_COLOR_DESC"] = "Select the color. The transparency value follow the row alpha value."
L["STRING_OPTIONS_SHOW_TOTALBAR_DESC"] = "Show or hide the total bar."
L["STRING_OPTIONS_SHOW_TOTALBAR_ICON"] = "Icon"
L["STRING_OPTIONS_SHOW_TOTALBAR_ICON_DESC"] = "Select the icon shown on the total bar."
L["STRING_OPTIONS_SHOW_TOTALBAR_INGROUP"] = "Only in Group"
L["STRING_OPTIONS_SHOW_TOTALBAR_INGROUP_DESC"] = "Total bar aren't shown if you isn't in a group."
L["STRING_OPTIONS_SIZE"] = "Size"
L["STRING_OPTIONS_SKIN_A"] = "Skin Settings"
L["STRING_OPTIONS_SKIN_A_DESC"] = "This options allows you to change the skin."
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON1"] = "Align Within Right Chat"
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON1_DESC"] = "Move and resize the windows |cFFFFFF00#1|r and |cFFFFFF00#2|r placing over the right chat window."
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON2"] = "Set Tooltip Border to Black"
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON2_DESC"] =[=[Modify tooltip's:

Border Color to: |cFFFFFF00Black|r.
Border Size to: |cFFFFFF0016|r.
Texture to: |cFFFFFF00Blizzard Tooltip|r.]=]
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"] = "Remove Tooltip Border"
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"] =[=[Modify tooltip's:

Border Color to: |cFFFFFF00Transparent|r.]=]
L["STRING_OPTIONS_SKIN_EXTRA_OPTIONS_ANCHOR"] = "Skin Options:"
L["STRING_OPTIONS_SKIN_LOADED"] = "skin successful loaded."
L["STRING_OPTIONS_SKIN_PRESETS_ANCHOR"] = "Save Skin:"
L["STRING_OPTIONS_SKIN_REMOVED"] = "skin removed."
L["STRING_OPTIONS_SKIN_RESET_TOOLTIP"] = "Reset Tooltip Border"
L["STRING_OPTIONS_SKIN_RESET_TOOLTIP_DESC"] = "Set the tooltip's border color and texture to default."
L["STRING_OPTIONS_SKIN_SELECT"] = "select a skin"
L["STRING_OPTIONS_SKIN_SELECT_ANCHOR"] = "Skin Selection:"
L["STRING_OPTIONS_SOCIAL"] = "Social"
L["STRING_OPTIONS_SOCIAL_DESC"] = "Tell how you want to be known in your guild enviorement."
L["STRING_OPTIONS_SPELL_ADD"] = "Add"
L["STRING_OPTIONS_SPELL_ADDICON"] = "New Icon: "
L["STRING_OPTIONS_SPELL_ADDNAME"] = "New Name: "
L["STRING_OPTIONS_SPELL_ADDSPELL"] = "Add Spell"
L["STRING_OPTIONS_SPELL_ADDSPELLID"] = "SpellId: "
L["STRING_OPTIONS_SPELL_CLOSE"] = "Close"
L["STRING_OPTIONS_SPELL_ICON"] = "Icon"
L["STRING_OPTIONS_SPELL_IDERROR"] = "Invalid spell id."
L["STRING_OPTIONS_SPELL_INDEX"] = "Index"
L["STRING_OPTIONS_SPELL_NAME"] = "Name"
L["STRING_OPTIONS_SPELL_NAMEERROR"] = "Invalid spell name."
L["STRING_OPTIONS_SPELL_NOTFOUND"] = "Spell not found."
L["STRING_OPTIONS_SPELL_REMOVE"] = "Remove"
L["STRING_OPTIONS_SPELL_RESET"] = "Reset"
L["STRING_OPTIONS_SPELL_SPELLID"] = "Spell ID"
L["STRING_OPTIONS_SPELL_SPELLID_DESC"] =[=[A ID is a unique number to identify the spell inside World of Warcraft. There is many ways to get the number:

- On the Player Details Window, hold shift while hover over spells bars.
- Type the spell name in the SpellId field, a tooltip is shown with suggested spells.
- Community web sites, most of them have the spellid on the address link.
- Browsing the spell cache below:]=]
L["STRING_OPTIONS_STRETCH"] = "Stretch Button Anchor"
L["STRING_OPTIONS_STRETCH_DESC"] =[=[Alternate the stretch button position.

|cFFFFFF00Top|r: the grab is placed on the top right corner.

|cFFFFFF00Bottom|r: the grab is placed on the bottom center.]=]
L["STRING_OPTIONS_STRETCHTOP"] = "Stretch Button Always On Top"
L["STRING_OPTIONS_STRETCHTOP_DESC"] =[=[The stretch button will be placed on the FULLSCREEN strata and always stay higher than the others frames.

|cFFFFFF00Important|r: Moving the grab for a high layer, it might stay in front of others frames like backpacks, use only if you really need.]=]
L["STRING_OPTIONS_SWITCH_ANCHOR"] = "Switches:"
L["STRING_OPTIONS_SWITCHINFO"] = "|cFFF79F81 LEFT DISABLED|r  |cFF81BEF7 RIGHT ENABLED|r"
L["STRING_OPTIONS_TESTBARS"] = "Create Test Bars"
L["STRING_OPTIONS_TEXT"] = "Bar Text Settings"
L["STRING_OPTIONS_TEXT_DESC"] = "This options control the appearance of the window row texts."
L["STRING_OPTIONS_TEXTEDITOR_CANCEL"] = "Cancel"
L["STRING_OPTIONS_TEXTEDITOR_CANCEL_TOOLTIP"] = "Finish the editing and ignore any change in the code."
L["STRING_OPTIONS_TEXTEDITOR_COLOR"] = "Color"
L["STRING_OPTIONS_TEXTEDITOR_COLOR_TOOLTIP"] = "Select the text and then click on the color button to change selected text color."
L["STRING_OPTIONS_TEXTEDITOR_COMMA"] = "Comma"
L["STRING_OPTIONS_TEXTEDITOR_COMMA_TOOLTIP"] =[=[Add a function to format numbers separating with commas.
Example: 1000000 to 1.000.000.]=]
L["STRING_OPTIONS_TEXTEDITOR_DATA"] = "[Data %s]"
L["STRING_OPTIONS_TEXTEDITOR_DATA_TOOLTIP"] =[=[Add a data feed:

|cFFFFFF00Data 1|r: normaly represents the total done by the actor or the position number.

|cFFFFFF00Data 2|r: in most cases represents the DPS, HPS or player's name.

|cFFFFFF00Data 3|r: represents the percent done by the actor, spec or faction icon.]=]
L["STRING_OPTIONS_TEXTEDITOR_DONE"] = "Done"
L["STRING_OPTIONS_TEXTEDITOR_DONE_TOOLTIP"] = "Finish the editing and save the code."
L["STRING_OPTIONS_TEXTEDITOR_FUNC"] = "Function"
L["STRING_OPTIONS_TEXTEDITOR_FUNC_TOOLTIP"] =[=[Add a empty function.
Functions must always return a number.]=]
L["STRING_OPTIONS_TEXTEDITOR_RESET"] = "Reset"
L["STRING_OPTIONS_TEXTEDITOR_RESET_TOOLTIP"] = "Clear all code and add the default code."
L["STRING_OPTIONS_TEXTEDITOR_TOK"] = "ToK"
L["STRING_OPTIONS_TEXTEDITOR_TOK_TOOLTIP"] =[=[Add a function to format numbers abbreviating its values.
Example: 1500000 to 1.5kk.]=]
L["STRING_OPTIONS_TEXT_FIXEDCOLOR"] = "Text Color"
L["STRING_OPTIONS_TEXT_FIXEDCOLOR_DESC"] =[=[Change the text color of both left and right texts.

Ignored if |cFFFFFFFFcolor by class|r is enabled.]=]
L["STRING_OPTIONS_TEXT_FONT"] = "Text Font"
L["STRING_OPTIONS_TEXT_FONT_DESC"] = "Change the font of both left and right texts."
L["STRING_OPTIONS_TEXT_LCLASSCOLOR"] = "Color By Class"
L["STRING_OPTIONS_TEXT_LCLASSCOLOR_DESC"] = "When enabled, the color chosen is ignored and the color of the actor class which is currently showing in the bar is used instead."
L["STRING_OPTIONS_TEXT_LEFT_ANCHOR"] = "Left Text:"
L["STRING_OPTIONS_TEXT_LOUTILINE"] = "Text Shadow"
L["STRING_OPTIONS_TEXT_LOUTILINE_DESC"] = "Enable or disable the outline for left text."
L["STRING_OPTIONS_TEXT_LPOSITION"] = "Show Number"
L["STRING_OPTIONS_TEXT_LPOSITION_DESC"] = "Show position number on the player's name left side."
L["STRING_OPTIONS_TEXT_RCLASSCOLOR"] = "Color By Class"
L["STRING_OPTIONS_TEXT_RCLASSCOLOR_DESC"] = "When enabled, the color chosen is ignored and the color of the actor class which is currently showing in the bar is used instead."
L["STRING_OPTIONS_TEXT_RIGHT_ANCHOR"] = "Right Text:"
L["STRING_OPTIONS_TEXT_ROUTILINE"] = "Text Shadow"
L["STRING_OPTIONS_TEXT_ROUTILINE_DESC"] = "Enable or disable the outline for right text."
L["STRING_OPTIONS_TEXT_ROWCOLOR"] = "Color"
L["STRING_OPTIONS_TEXT_ROWCOLOR2"] = "Color"
L["STRING_OPTIONS_TEXT_ROWCOLOR_NOTCLASS"] = "By Class"
L["STRING_OPTIONS_TEXT_ROWICONS_ANCHOR"] = "Icons:"
L["STRING_OPTIONS_TEXT_SIZE"] = "Text Size"
L["STRING_OPTIONS_TEXT_SIZE_DESC"] = "Change the size of both left and right texts."
L["STRING_OPTIONS_TEXT_TEXTUREL_ANCHOR"] = "Lower Texture:"
L["STRING_OPTIONS_TEXT_TEXTUREU_ANCHOR"] = "Upper Texture:"
L["STRING_OPTIONS_TIMEMEASURE"] = "Time Measure"
L["STRING_OPTIONS_TIMEMEASURE_DESC"] =[=[|cFFFFFF00Activity|r: the timer of each raid member is put on hold if his activity is ceased and back again to count when is resumed, common way of measure Dps and Hps.

|cFFFFFF00Effective|r: used on rankings, this method uses the elapsed combat time for measure the Dps and Hps of all raid members.]=]
L["STRING_OPTIONS_TOOLBAR2_SETTINGS"] = "Right Menu Settings"
L["STRING_OPTIONS_TOOLBAR2_SETTINGS_DESC"] = "This options change the reset, window and close buttons from the toolbar menu on the top of the window."
L["STRING_OPTIONS_TOOLBAR_SETTINGS"] = "Left Menu Settings"
L["STRING_OPTIONS_TOOLBAR_SETTINGS_DESC"] = "This options change the main menu on the top of the window."
L["STRING_OPTIONS_TOOLBARSIDE"] = "Toolbar Anchor"
L["STRING_OPTIONS_TOOLBARSIDE_DESC"] =[=[Place the toolbar on the top or bottom side of window.

When alternating the position, title text won't change, check out |cFFFFFF00Title Text|r section for more options.]=]
L["STRING_OPTIONS_TOOLS_ANCHOR"] = "Tools:"
L["STRING_OPTIONS_TOOLTIP_ANCHOR"] = "Settings:"
L["STRING_OPTIONS_TOOLTIP_ANCHORTEXTS"] = "Texts:"
L["STRING_OPTIONS_TOOLTIPS_ABBREVIATION"] = "Abbreviation Type"
L["STRING_OPTIONS_TOOLTIPS_ABBREVIATION_DESC"] = "Choose how the numbers displayed on tooltips are formated."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_ATTACH"] = "Tooltip Side"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_ATTACH_DESC"] = "Which side of tooltip is used to fit with the anchor attach side."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_BORDER"] = "Border:"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_POINT"] = "Anchor:"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_RELATIVE"] = "Anchor Side"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_RELATIVE_DESC"] = "Which side of the anchor the tooltip will be placed."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TEXT"] = "Tooltip Anchor"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TEXT_DESC"] = "right click to lock."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO"] = "Anchor"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO1"] = "Window Row"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO2"] = "Point on Screen"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_CHOOSE"] = "Move Anchor Point"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_CHOOSE_DESC"] = "Move the anchor position when Anchor is set to |cFFFFFF00Point on Screen|r."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_DESC"] = "Tooltips attaches on the hovered row or on a chosen point in the game screen."
L["STRING_OPTIONS_TOOLTIPS_BACKGROUNDCOLOR"] = "Background Color"
L["STRING_OPTIONS_TOOLTIPS_BACKGROUNDCOLOR_DESC"] = "Choose the color used on the background."
L["STRING_OPTIONS_TOOLTIPS_BORDER_COLOR"] = "Color"
L["STRING_OPTIONS_TOOLTIPS_BORDER_COLOR_DESC"] = "Change the border color."
L["STRING_OPTIONS_TOOLTIPS_BORDER_SIZE"] = "Size"
L["STRING_OPTIONS_TOOLTIPS_BORDER_SIZE_DESC"] = "Change the border size."
L["STRING_OPTIONS_TOOLTIPS_BORDER_TEXTURE"] = "Texture"
L["STRING_OPTIONS_TOOLTIPS_BORDER_TEXTURE_DESC"] = "Modify the border texture file."
L["STRING_OPTIONS_TOOLTIPS_FONTCOLOR"] = "Text Color"
L["STRING_OPTIONS_TOOLTIPS_FONTCOLOR_DESC"] = "Change the color used on tooltip texts."
L["STRING_OPTIONS_TOOLTIPS_FONTFACE"] = "Text Font"
L["STRING_OPTIONS_TOOLTIPS_FONTFACE_DESC"] = "Choose the font used on tooltip texts."
L["STRING_OPTIONS_TOOLTIPS_FONTSHADOW"] = "Text Shadow"
L["STRING_OPTIONS_TOOLTIPS_FONTSHADOW_DESC"] = "Enable or disable the shadow in the text."
L["STRING_OPTIONS_TOOLTIPS_FONTSIZE"] = "Text Size"
L["STRING_OPTIONS_TOOLTIPS_FONTSIZE_DESC"] = "Increase or decrease the size of tooltip texts"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE"] = "Maximize Method"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE1"] = "On Shift Ctrl Alt"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE2"] = "Always Maximized"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE3"] = "Only Shift Block"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE4"] = "Only Ctrl Block"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE5"] = "Only Alt Block"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE_DESC"] =[=[Select the method used to expand the information shown on the tooltip.

|cFFFFFF00 On Control Keys|r: tooltip box is expanded when Shift, Ctrl or Alt keys is pressed.

|cFFFFFF00 Always Maximized|r: the tooltip always show all information without any amount limitations.

|cFFFFFF00 Only Shift Block|r: the first block on the tooltip is always expanded by default.

|cFFFFFF00 Only Ctrl Block|r: the second block is always expanded by default.

|cFFFFFF00 Only Alt Block|r: the third block is always expanded by default.]=]
L["STRING_OPTIONS_TOOLTIPS_OFFSETX"] = "Distance X"
L["STRING_OPTIONS_TOOLTIPS_OFFSETX_DESC"] = "How far horizontally the tooltip is placed from its anchor."
L["STRING_OPTIONS_TOOLTIPS_OFFSETY"] = "Distance Y"
L["STRING_OPTIONS_TOOLTIPS_OFFSETY_DESC"] = "How far vertically the tooltip is placed from its anchor."
L["STRING_OPTIONS_TOOLTIPS_SHOWAMT"] = "Show Amount"
L["STRING_OPTIONS_TOOLTIPS_SHOWAMT_DESC"] = "Shows a number indicating how many spells, targets and pets have in the tooltip."
L["STRING_OPTIONS_TOOLTIPS_TITLE"] = "Tooltips"
L["STRING_OPTIONS_TOOLTIPS_TITLE_DESC"] = "This options controls the appearance of tooltips."
L["STRING_OPTIONS_TOTALBAR_ANCHOR"] = "Total Bar:"
L["STRING_OPTIONS_WALLPAPER_ALPHA"] = "Alpha:"
L["STRING_OPTIONS_WALLPAPER_ANCHOR"] = "Wallpaper Selection:"
L["STRING_OPTIONS_WALLPAPER_BLUE"] = "Blue:"
L["STRING_OPTIONS_WALLPAPER_CBOTTOM"] = "Crop(|cFFC0C0C0bottom|r):"
L["STRING_OPTIONS_WALLPAPER_CLEFT"] = "Crop(|cFFC0C0C0left|r):"
L["STRING_OPTIONS_WALLPAPER_CRIGHT"] = "Crop(|cFFC0C0C0right|r):"
L["STRING_OPTIONS_WALLPAPER_CTOP"] = "Crop(|cFFC0C0C0top|r):"
L["STRING_OPTIONS_WALLPAPER_FILE"] = "File:"
L["STRING_OPTIONS_WALLPAPER_GREEN"] = "Green:"
L["STRING_OPTIONS_WALLPAPER_LOAD"] = "Load Image"
L["STRING_OPTIONS_WALLPAPER_LOAD_DESC"] = "Select a image from your hard drive to use as wallpaper."
L["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"] =[=[The image needs:

- To be in Truevision TGA format(.tga extension).
- Be inside WOW/Interface/ root folder.
- The size must be 256 x 256 pixels.
- The game must be closed before paste the file.]=]
L["STRING_OPTIONS_WALLPAPER_LOAD_FILENAME"] = "File Name:"
L["STRING_OPTIONS_WALLPAPER_LOAD_FILENAME_DESC"] = "Insert only the name of the file, excluding path and extension."
L["STRING_OPTIONS_WALLPAPER_LOAD_OKEY"] = "Load"
L["STRING_OPTIONS_WALLPAPER_LOAD_TITLE"] = "From Computer:"
L["STRING_OPTIONS_WALLPAPER_LOAD_TROUBLESHOOT"] = "Troubleshoot"
L["STRING_OPTIONS_WALLPAPER_LOAD_TROUBLESHOOT_TEXT"] =[=[If the wallpaper got full green color:

- Restarted the wow client.
- Make sure the image have 256 width and 256 height.
- Check if the image is in .TGA format and make sure it's saved with 32 bits/pixel.
- Is inside Interface folder, for example: C:/Program Files/World of Warcraft/Interface/]=]
L["STRING_OPTIONS_WALLPAPER_RED"] = "Red:"
L["STRING_OPTIONS_WC_ANCHOR"] = "Quick Window Control(#%s):"
L["STRING_OPTIONS_WC_BOOKMARK"] = "Manage Bookmarks"
L["STRING_OPTIONS_WC_BOOKMARK_DESC"] = "Open config panel for bookmarks."
L["STRING_OPTIONS_WC_CLOSE"] = "Close"
L["STRING_OPTIONS_WC_CLOSE_DESC"] =[=[Close this window.

When closed, the window is considered inactive and can be reopened at any time using the # window button.

For completely remove a window go to miscellaneous section.]=]
L["STRING_OPTIONS_WC_CREATE"] = "Create Window"
L["STRING_OPTIONS_WC_CREATE_DESC"] = "Create a new window."
L["STRING_OPTIONS_WC_LOCK"] = "Lock"
L["STRING_OPTIONS_WC_LOCK_DESC"] =[=[Lock or Unlock the window.

When locked, the window can not be moved.]=]
L["STRING_OPTIONS_WC_REOPEN"] = "Reopen"
L["STRING_OPTIONS_WC_UNLOCK"] = "Unlock"
L["STRING_OPTIONS_WC_UNSNAP"] = "Ungroup"
L["STRING_OPTIONS_WC_UNSNAP_DESC"] = "Break the link with others windows."
L["STRING_OPTIONS_WINDOW"] = "Options Panel"
L["STRING_OPTIONS_WINDOW_ANCHOR"] = "Appearance Adjustments:"
L["STRING_OPTIONS_WINDOW_SCALE"] = "Scale"
L["STRING_OPTIONS_WINDOW_SCALE_DESC"] = "Adjust the scale of the window."
L["STRING_OPTIONS_WINDOWSPEED"] = "Update Interval"
L["STRING_OPTIONS_WINDOWSPEED_DESC"] =[=[Seconds between each update on opened windows.

|cFFFFFF000.05|r: real time update.

|cFFFFFF000.3|r: update about 3 times each second.

|cFFFFFF003.0|r: update once every 3 seconds.]=]
L["STRING_OPTIONS_WINDOW_TITLE"] = "Window Settings"
L["STRING_OPTIONS_WINDOW_TITLE_DESC"] = "This options control the window appearance of selected window."
L["STRING_OPTIONS_WP"] = "Wallpaper Settings"
L["STRING_OPTIONS_WP_ALIGN"] = "Align"
L["STRING_OPTIONS_WP_ALIGN_DESC"] =[=[Select how the wallpaper will align within the window.

- |cFFFFFF00Fill|r: auto resize and align with all corners.

- |cFFFFFF00Center|r: doesn`t resize and align with the center of the window.

-|cFFFFFF00Stretch|r: auto resize on vertical or horizontal and align with left-right or top-bottom sides.

-|cFFFFFF00Four Corners|r: align with specified corner, no auto resize is made.]=]
L["STRING_OPTIONS_WP_DESC"] = "This options control the wallpaper of window."
L["STRING_OPTIONS_WP_EDIT"] = "Edit Image"
L["STRING_OPTIONS_WP_EDIT_DESC"] = "Open the image editor to change some wallpaper aspects."
L["STRING_OPTIONS_WP_ENABLE"] = "Show"
L["STRING_OPTIONS_WP_ENABLE_DESC"] =[=[Enable or Disable the wallpaper of the window.

Select the category and the image you want on the two following boxes.]=]
L["STRING_OPTIONS_WP_GROUP"] = "Category"
L["STRING_OPTIONS_WP_GROUP2"] = "Wallpaper"
L["STRING_OPTIONS_WP_GROUP2_DESC"] = "Select the wallpaper, for more, choose a diferent category on the left dropbox."
L["STRING_OPTIONS_WP_GROUP_DESC"] = "In this box, you select the group of the wallpaper, the images of this category can be chosen on the next dropbox."
L["STRING_OVERALL"] = "Overall"
L["STRING_OVERHEAL"] = "Overheal"
L["STRING_OVERHEALED"] = "Overhealed"
L["STRING_PARRY"] = "Parry"
L["STRING_PERCENTAGE"] = "Percentage"
L["STRING_PET"] = "Pet"
L["STRING_PETS"] = "Pets"
L["STRING_PLAYER_DETAILS"] = "Player Details"
L["STRING_PLAYERS"] = "Players"
L["STRING_PLEASE_WAIT"] = "Please wait"
L["STRING_PLUGIN_CLEAN"] = "None"
L["STRING_PLUGIN_CLOCKNAME"] = "Encounter Time"
L["STRING_PLUGIN_CLOCKTYPE"] = "Clock Type"
L["STRING_PLUGIN_DURABILITY"] = "Durability"
L["STRING_PLUGIN_FPS"] = "Framerate"
L["STRING_PLUGIN_GOLD"] = "Gold"
L["STRING_PLUGIN_LATENCY"] = "Latency"
L["STRING_PLUGIN_MINSEC"] = "Minutes & Seconds"
L["STRING_PLUGIN_NAMEALREADYTAKEN"] = "Details! can't install plugin because his name already has been taken"
L["STRING_PLUGINOPTIONS_ABBREVIATE"] = "Abbreviate"
L["STRING_PLUGINOPTIONS_COMMA"] = "Comma"
L["STRING_PLUGINOPTIONS_FONTFACE"] = "Select Font Style"
L["STRING_PLUGINOPTIONS_NOFORMAT"] = "None"
L["STRING_PLUGINOPTIONS_TEXTALIGN"] = "Text Align"
L["STRING_PLUGINOPTIONS_TEXTALIGN_X"] = "Text Align X"
L["STRING_PLUGINOPTIONS_TEXTALIGN_Y"] = "Text Align Y"
L["STRING_PLUGINOPTIONS_TEXTCOLOR"] = "Text Color"
L["STRING_PLUGINOPTIONS_TEXTSIZE"] = "Font Size"
L["STRING_PLUGINOPTIONS_TEXTSTYLE"] = "Text Style"
L["STRING_PLUGIN_PATTRIBUTENAME"] = "Attribute"
L["STRING_PLUGIN_PDPSNAME"] = "Raid Dps"
L["STRING_PLUGIN_PSEGMENTNAME"] = "Segment"
L["STRING_PLUGIN_SECONLY"] = "Seconds Only"
L["STRING_PLUGIN_SEGMENTTYPE"] = "Segment Type"
L["STRING_PLUGIN_SEGMENTTYPE_1"] = "Fight #X"
L["STRING_PLUGIN_SEGMENTTYPE_2"] = "Encounter Name"
L["STRING_PLUGIN_SEGMENTTYPE_3"] = "Encounter Name Plus Segment"
L["STRING_PLUGIN_THREATNAME"] = "My Threat"
L["STRING_PLUGIN_TIME"] = "Clock"
L["STRING_PLUGIN_TIMEDIFF"] = "Last Combat Difference"
L["STRING_PLUGIN_TOOLTIP_LEFTBUTTON"] = "Config current plugin"
L["STRING_PLUGIN_TOOLTIP_RIGHTBUTTON"] = "Choose another plugin"
L["STRING_RAID_WIDE"] = "[*] raid wide cooldown"
L["STRING_REPORT"] = "for"
L["STRING_REPORT_BUTTON_TOOLTIP"] = "Click to open Report Dialog"
L["STRING_REPORT_FIGHT"] = "fight"
L["STRING_REPORT_FIGHTS"] = "fights"
L["STRING_REPORTFRAME_COPY"] = "Copy & Paste"
L["STRING_REPORTFRAME_CURRENT"] = "Current"
L["STRING_REPORTFRAME_CURRENTINFO"] = "Display only data which are current being shown(if supported)."
L["STRING_REPORTFRAME_GUILD"] = "Guild"
L["STRING_REPORTFRAME_INSERTNAME"] = "insert player name"
L["STRING_REPORTFRAME_LINES"] = "Lines"
L["STRING_REPORTFRAME_OFFICERS"] = "Officer Channel"
L["STRING_REPORTFRAME_PARTY"] = "Party"
L["STRING_REPORTFRAME_RAID"] = "Raid"
L["STRING_REPORTFRAME_REVERT"] = "Reverse"
L["STRING_REPORTFRAME_REVERTED"] = "reversed"
L["STRING_REPORTFRAME_REVERTINFO"] = "Reverse result, showing in ascending order(if supported)."
L["STRING_REPORTFRAME_SAY"] = "Say"
L["STRING_REPORTFRAME_SEND"] = "Send"
L["STRING_REPORTFRAME_WHISPER"] = "Whisper"
L["STRING_REPORTFRAME_WHISPERTARGET"] = "Whisper Target"
L["STRING_REPORTFRAME_WINDOW_TITLE"] = "Create Report"
L["STRING_REPORT_INVALIDTARGET"] = "Whisper target not found"
L["STRING_REPORT_LAST"] = "Last"
L["STRING_REPORT_LASTFIGHT"] = "last fight"
L["STRING_REPORT_LEFTCLICK"] = "Click to open report dialog"
L["STRING_REPORT_PREVIOUSFIGHTS"] = "previous fights"
L["STRING_REPORT_SINGLE_BUFFUPTIME"] = "buff uptime for"
L["STRING_REPORT_SINGLE_COOLDOWN"] = "cooldowns used by"
L["STRING_REPORT_SINGLE_DEATH"] = "Death of"
L["STRING_REPORT_SINGLE_DEBUFFUPTIME"] = "debuff uptime for"
L["STRING_RESISTED"] = "Resisted"
L["STRING_RESIZE_ALL"] = "Freely resize all windows"
L["STRING_RESIZE_COMMON"] =[=[Resize
]=]
L["STRING_RESIZE_HORIZONTAL"] =[=[Resize the width off all
 windows in the group]=]
L["STRING_RESIZE_VERTICAL"] =[=[Resize the heigth off all
 windows in the group]=]
L["STRING_RIGHT"] = "right"
L["STRING_RIGHTCLICK_CLOSE_LARGE"] = "Click with right mouse button to close this window."
L["STRING_RIGHTCLICK_CLOSE_MEDIUM"] = "Use right click to close this window."
L["STRING_RIGHTCLICK_CLOSE_SHORT"] = "Right click to close."
L["STRING_RIGHTCLICK_TYPEVALUE"] = "right click to type the value"
L["STRING_SEE_BELOW"] = "see below"
L["STRING_SEGMENT"] = "Segment"
L["STRING_SEGMENT_EMPTY"] = "this segment is empty"
L["STRING_SEGMENT_END"] = "End"
L["STRING_SEGMENT_ENEMY"] = "Enemy"
L["STRING_SEGMENT_LOWER"] = "segment"
L["STRING_SEGMENT_OVERALL"] = "Overall Data"
L["STRING_SEGMENT_START"] = "Start"
L["STRING_SEGMENT_TIME"] = "Time"
L["STRING_SEGMENT_TRASH"] = "Trash Cleanup"
L["STRING_SHORTCUT_RIGHTCLICK"] = "right click to close"
L["STRING_SLASH_CAPTUREOFF"] = "all captures has been turned off."
L["STRING_SLASH_CAPTUREON"] = "all captures has been turned on."
L["STRING_SLASH_CHANGES"] = "updates"
L["STRING_SLASH_CHANGES_ALIAS1"] = "news"
L["STRING_SLASH_CHANGES_ALIAS2"] = "changes"
L["STRING_SLASH_CHANGES_DESC"] = "shows up the latest changes made on this version."
L["STRING_SLASH_DISABLE"] = "disable"
L["STRING_SLASH_DISABLE_DESC"] = "turn off all captures of data."
L["STRING_SLASH_ENABLE"] = "enable"
L["STRING_SLASH_ENABLE_DESC"] = "turn on all captures of data."
L["STRING_SLASH_HIDE"] = "hide"
L["STRING_SLASH_HIDE_ALIAS1"] = "close"
L["STRING_SLASH_HIDE_DESC"] = "close all opened windows."
L["STRING_SLASH_NEW"] = "new"
L["STRING_SLASH_NEW_DESC"] = "create a new window."
L["STRING_SLASH_OPTIONS"] = "options"
L["STRING_SLASH_OPTIONS_DESC"] = "open the options panel."
L["STRING_SLASH_SHOW"] = "show"
L["STRING_SLASH_SHOW_ALIAS1"] = "open"
L["STRING_SLASH_SHOW_DESC"] = "reopen all closed windows."
L["STRING_SLASH_WIPECONFIG"] = "reinstall"
L["STRING_SLASH_WIPECONFIG_CONFIRM"] = "Click To Continue With The Reinstall"
L["STRING_SLASH_WIPECONFIG_DESC"] = "set Details! configuration to defaults for this character, use this if Details! aren't working properlly."
L["STRING_SLASH_WORLDBOSS"] = "worldboss"
L["STRING_SLASH_WORLDBOSS_DESC"] = "run a macro showing which boss you killed this week."
L["STRING_SPELL_INTERRUPTED"] = "Spells interrupted"
L["STRING_SPELLS"] = "Spells"
L["STRING_STATUSBAR_NOOPTIONS"] = "This widget doesn't have options."
L["STRING_SWITCH_CLICKME"] = "left click me"
L["STRING_SWITCH_WARNING"] = "Role changed. Switching: |cFFFFAA00%s|r  "
L["STRING_TARGET"] = "Target"
L["STRING_TARGETS"] = "Targets"
L["STRING_TIME_OF_DEATH"] = "Death"
L["STRING_TOOOLD"] = "could not be installed because your Details! version is too old."
L["STRING_TOP"] = "top"
L["STRING_TOTAL"] = "Total"
L["STRING_UNKNOW"] = "Unknown"
L["STRING_UNKNOWSPELL"] = "Unknow Spell"
L["STRING_UNLOCK"] =[=[Spread out windows
 in this button]=]
L["STRING_UNLOCK_WINDOW"] = "unlock"
L["STRING_UPTADING"] = "updating"
L["STRING_VERSION_UPDATE"] = "new version: what's changed? click here"
L["STRING_VOIDZONE_TOOLTIP"] = "Damage and Time:"
L["STRING_WAITPLUGIN"] =[=[waiting for
plugins]=]
L["STRING_WELCOME_1"] =[=[|cFFFFFFFFWelcome to Details! Quick Setup Wizard

|rThis guide will help you with some important configurations.
You can skip this at any time just clicking on 'skip' button.]=]
L["STRING_WELCOME_11"] = "if you change your mind, you can always modify again through options panel"
L["STRING_WELCOME_12"] = "Select the update speed and animations. Also if your computer have 2GB or less memory ram, its likely you want to reduce and the amount of segments."
L["STRING_WELCOME_13"] = ""
L["STRING_WELCOME_14"] = "Update Speed"
L["STRING_WELCOME_15"] =[=[Delay length between each update in the window.
Standard value is |cFFFFFF000.5|r seconds, recommeded value for raiders is |cFFFFFF001.0|r.]=]
L["STRING_WELCOME_16"] = "Enable Animations"
L["STRING_WELCOME_17"] = "When enabled, this feature makes the bars in the window softly slide instead of 'jump' to corresponding size."
L["STRING_WELCOME_2"] = "if you change your mind, you can always modify again through options panel"
L["STRING_WELCOME_21"] = "Max Segments"
L["STRING_WELCOME_22"] =[=[Recommended values based on memory amount:

|cFFFFFF001GB|r: 5 segments.
|cFFFFFF002GB|r: 10 segments.
|cFFFFFF00>= 3GB|r: 11-25 segments.

|cFFFFFF00Important:|r memory usage by addons doesn't affect your framerate.]=]
L["STRING_WELCOME_26"] = "Using the Interface: Stretch"
L["STRING_WELCOME_27"] =[=[- When you have the mouse over a Details! window, a |cFFFFFF00small hook|r will appear over the window button. |cFFFFFF00Click, hold and pull|r up to |cFFFFFF00stretch|r the window, releasing the mouse click, the window |cFFFFFF00back to original|r size.

- If you miss a |cFFFFBB00scroll bar|r, you can active it on the options panel.]=]
L["STRING_WELCOME_28"] = "Using the Interface: Window Button"
L["STRING_WELCOME_29"] =[=[Window button basically do three things:

- show |cFFFFFF00what window|r is it through the |cFFFFFF00#number|r,
- open a |cFFFFFF00new window|r when clicked.
- show a menu with |cFFFFFF00closed windows|r which can be reopened at any time.]=]
L["STRING_WELCOME_3"] = "Choose your DPS and HPS prefered method:"
L["STRING_WELCOME_30"] = "Using the Interface: Bookmarks"
L["STRING_WELCOME_31"] =[=[- Right click |cFFFFFF00on a bar|r or in the window background to open the |cFFFFFF00Bookmarks Panel|r.
- You can choose a display right clicking on a bookmark icon.
- Left click on a bookmark to |cFFFFFF00change|r the display shown in the window
- Right clicking anywhere |cFFFFFF00closes|r the Bookmark panel.]=]
L["STRING_WELCOME_32"] = "Using the Interface: Group Windows"
L["STRING_WELCOME_33"] = "You can |cFFFFFF00group windows|r in vertical or horizontal. A window always group with |cFFFFFF00previous window number|r: like the image in the right, window |cFFFFFF00#5|r grouped with |cFFFFFF00#4|r. When a grouped window is stretched, all other windows in the |cFFFFFF00cluster are also|r stretched."
L["STRING_WELCOME_34"] = "Using the Interface: Micro Display"
L["STRING_WELCOME_35"] = "All windows have three |cFFFFFF00mini widgets|r located at the bottom of window. |cFFFFFF00Right clicking|r pops up a menu and with |cFFFFFF00left click|r displays a options panel for that widget."
L["STRING_WELCOME_36"] = "Using the Interface: Plugins"
L["STRING_WELCOME_37"] = "|cFFFFFF00Threat, tank avoidance, and others|r are handled by |cFFFFFF00plugins|r. You can open a new window, select '|cFFFFFF00Plugins|r' and choose what you want at |cFFFFFF00sword|r menu."
L["STRING_WELCOME_38"] = "Ready to Raid!"
L["STRING_WELCOME_39"] =[=[Thank you for choosing Details!

Feel free to always send feedbacks and bug reports to us.]=]
L["STRING_WELCOME_4"] = "Activity Time: "
L["STRING_WELCOME_41"] = "Interface and Memory Tweaks:"
L["STRING_WELCOME_42"] = "Quick Appearance Settings"
L["STRING_WELCOME_43"] = "Choose your prefered skin:"
L["STRING_WELCOME_44"] = "Wallpaper"
L["STRING_WELCOME_45"] = "For more customization options, check the options panel."
L["STRING_WELCOME_46"] = "Import Settings"
L["STRING_WELCOME_47"] = "Texture(from "
L["STRING_WELCOME_48"] = "Font(from "
L["STRING_WELCOME_49"] = "Font Size(from "
L["STRING_WELCOME_5"] = "Effective Time: "
L["STRING_WELCOME_50"] = "Bar Spacing(from "
L["STRING_WELCOME_51"] = "Bar Height(from "
L["STRING_WELCOME_52"] = "Bar Background(from "
L["STRING_WELCOME_53"] = "Growth Direction(from "
L["STRING_WELCOME_54"] = "Bar Color(from "
L["STRING_WELCOME_55"] = "Title(from "
L["STRING_WELCOME_56"] = "Background(from "
L["STRING_WELCOME_57"] = "Import basic settings from addons already installed."
L["STRING_WELCOME_58"] =[=[Predefined sets of appearance configurations.

|cFFFFFF00Important|r: all settings can be modified later on the options panel.]=]
L["STRING_WELCOME_59"] = "Enable background wallpaper."
L["STRING_WELCOME_6"] = "the timer of each raid member is put on hold if his activity is ceased and back again to count when is resumed."
L["STRING_WELCOME_7"] = "used for rankings, this method uses the elapsed combat time for measure the Dps and Hps of all raid members."
L["STRING_YES"] = "Yes"
