-- Notes for translators:
-- 1) If you aren't translating a string, don't put it your locale file
-- 2) You should never have 
--   SBFOptions.strings.X = SBFOptions.strings.X or "y"
--   You should only have
--   SBFOptions.strings.X = "y"

-- General Tab
SBFOptions.strings.GENERALCONFIG = SBFOptions.strings.GENERALCONFIG or "General"
SBFOptions.strings.FRAMEUNIT = SBFOptions.strings.FRAMEUNIT or "Frame unit"
SBFOptions.strings.FRAMENAME = SBFOptions.strings.FRAMENAME or "Frame name"
SBFOptions.strings.FRAMEBUFFS = SBFOptions.strings.FRAMEBUFFS or "Show buffs"
SBFOptions.strings.FRAMEDEBUFFS = SBFOptions.strings.FRAMEDEBUFFS or "Show debuffs"
SBFOptions.strings.WHITELIST = SBFOptions.strings.WHITELIST or "Whitelist"
SBFOptions.strings.WHITELISTTT = SBFOptions.strings.WHITELISTTT or "Whitelist means \"show me nothing except what I say to\""
SBFOptions.strings.BLACKLIST = SBFOptions.strings.BLACKLIST or "Blacklist"
SBFOptions.strings.BLACKLISTTT = SBFOptions.strings.BLACKLISTTT or "Blacklist means \"show me everything except what I say not to\""
SBFOptions.strings.CLICKTHROUGH = SBFOptions.strings.CLICKTHROUGH or "Clickthrough"
SBFOptions.strings.CLICKTHROUGHTT = SBFOptions.strings.CLICKTHROUGHTT or "A frame set to clickthrough will not accept any mouse input at all"
SBFOptions.strings.SHOWVEHICLE = SBFOptions.strings.SHOWVEHICLE or "Vehicle buffs"  -- 3.1.13
SBFOptions.strings.SHOWVEHICLETT = SBFOptions.strings.SHOWVEHICLETT or "Show vehicle buffs in this frame when mounted" -- 3.1.13

-- Layout Tab
SBFOptions.strings.BIG = SBFOptions.strings.BIG or "Big"
SBFOptions.strings.LAYOUTCONFIG = SBFOptions.strings.LAYOUTCONFIG or "Layout"
SBFOptions.strings.BUFF_SCALE = SBFOptions.strings.BUFF_SCALE or "Scale"
SBFOptions.strings.OPACITY = SBFOptions.strings.OPACITY or "Opacity"
SBFOptions.strings.BUFFHORIZONTAL = SBFOptions.strings.BUFFHORIZONTAL or "Rows"
SBFOptions.strings.BUFFFLIP = SBFOptions.strings.BUFFFLIP or "Flip"
SBFOptions.strings.REVERSEBUFF = SBFOptions.strings.REVERSEBUFF or "Reverse order"
SBFOptions.strings.XSPACING = SBFOptions.strings.XSPACING or "Horizontal spacing"
SBFOptions.strings.YSPACING = SBFOptions.strings.YSPACING or "Vertical spacing"
SBFOptions.strings.ROWCOUNT = SBFOptions.strings.ROWCOUNT or "Buffs per row"
SBFOptions.strings.COLCOUNT = SBFOptions.strings.COLCOUNT or "Buffs per column"
SBFOptions.strings.BUFFCOUNT = SBFOptions.strings.BUFFCOUNT or "Number of buffs"
SBFOptions.strings.BUFFSORT = SBFOptions.strings.BUFFSORT or "Sorting"
SBFOptions.strings.BUFFRIGHTCLICK = SBFOptions.strings.BUFFRIGHTCLICK or "Disable right click in this frame"
SBFOptions.strings.NOTOOLTIPS = SBFOptions.strings.NOTOOLTIPS or "No tooltips"
SBFOptions.strings.NOTOOLTIPSTT = SBFOptions.strings.NOTOOLTIPSTT or "Do not show tooltips for buffs in this frame"
SBFOptions.strings.MIRRORBUFFS = SBFOptions.strings.MIRRORBUFFS or "Mirror buffs in frames 1 and 2"
SBFOptions.strings.RIGHTCLICKTT = SBFOptions.strings.RIGHTCLICKTT or "Right click will not dismiss buffs"
SBFOptions.strings.MIRRORTT1 = SBFOptions.strings.MIRRORTT1 or "Buffs will appear in buff frame 1 as well as in this frame"
SBFOptions.strings.MIRRORTT2 = SBFOptions.strings.MIRRORTT2 or "Debuffs will appear in buff frame 2 as well as in this frame"
SBFOptions.strings.VISIBILITY = SBFOptions.strings.VISIBILITY or "Frame visibility"
SBFOptions.strings.BUFFPOSITION = SBFOptions.strings.BUFFPOSITION or "Buff spacing"
SBFOptions.strings.BUFFGROWTH = SBFOptions.strings.BUFFGROWTH or "Buff growth"
SBFOptions.strings.BUFFANCHOR = SBFOptions.strings.BUFFANCHOR or "Anchor point"
SBFOptions.strings.TOP = SBFOptions.strings.TOP or "Top"
SBFOptions.strings.BOTTOM = SBFOptions.strings.BOTTOM or "Bottom"

-- Timer tab
SBFOptions.strings.SHOWTIMERS = SBFOptions.strings.SHOWTIMERS or "Show buff timers"
SBFOptions.strings.TIMERCONFIG = SBFOptions.strings.TIMERCONFIG or "Timers"
SBFOptions.strings.TEXT_POSITIONY = SBFOptions.strings.TEXT_POSITIONY or "Timer vertical"
SBFOptions.strings.TEXT_POSITIONX = SBFOptions.strings.TEXT_POSITIONX or "Timer horizontal"
SBFOptions.strings.TEXT_FORMAT = SBFOptions.strings.TEXT_FORMAT or "Timer format"
SBFOptions.strings.TIMERCOLOUR = SBFOptions.strings.TIMERCOLOUR or "Timer text colour"
SBFOptions.strings.EXPIRECOLOUR = SBFOptions.strings.EXPIRECOLOUR or "Expiring timer colour"
SBFOptions.strings.TIMERPOSITION = SBFOptions.strings.TIMERPOSITION or "Timer position"
SBFOptions.strings.TIMERNA = SBFOptions.strings.TIMERNA or "N/A for auras"
SBFOptions.strings.TIMERMS = SBFOptions.strings.TIMERMS or "Show 1/10 seconds"
SBFOptions.strings.TIMERMSTT = SBFOptions.strings.TIMERMSTT or "Show 1/10 second on timers when under 5 seconds remaining"

-- Icon Tab
SBFOptions.strings.SHOWICONS = SBFOptions.strings.SHOWICONS or "Show buff icons"
SBFOptions.strings.ICONCONFIG = SBFOptions.strings.ICONCONFIG or "Icons"
SBFOptions.strings.ICONPOSITION = SBFOptions.strings.ICONPOSITION or "Icon position"
SBFOptions.strings.ICONSIZE = SBFOptions.strings.ICONSIZE or "Icon size"
SBFOptions.strings.COOLDOWN = SBFOptions.strings.COOLDOWN or "Cooldown sweep on icons"
SBFOptions.strings.REVERSECOOLDOWN = SBFOptions.strings.REVERSECOOLDOWN or "Reverse cooldown sweep"
SBFOptions.strings.SUPPRESSOMNICCTIMER = SBFOptions.strings.SUPPRESSOMNICCTIMER or "Suppress OmniCC timers on cooldown sweep"
SBFOptions.strings.NOBORDER = SBFOptions.strings.NOBORDER or "Do not show SBF icon borders"
SBFOptions.strings.NOBFBORDER = SBFOptions.strings.NOBFBORDER or "Do not colour ButtonFacade borders"

-- Count Tab
SBFOptions.strings.SHOWCOUNTS = SBFOptions.strings.SHOWCOUNTS or "Show buff counts"
SBFOptions.strings.COUNTCONFIG = SBFOptions.strings.COUNTCONFIG or "Counts"
SBFOptions.strings.STACKCOLOUR = SBFOptions.strings.STACKCOLOUR or "Count text colour"
SBFOptions.strings.COUNTPOSITION = SBFOptions.strings.COUNTPOSITION or "Count position"

-- Bar Tab
SBFOptions.strings.BARCONFIG = SBFOptions.strings.BARCONFIG or "Bars"
SBFOptions.strings.SHOWBARS = SBFOptions.strings.SHOWBARS or "Show buff bars"
SBFOptions.strings.BARDIRECTION = SBFOptions.strings.BARDIRECTION or "Bar direction"
SBFOptions.strings.BARWIDTH = SBFOptions.strings.BARWIDTH or "Bar width"
SBFOptions.strings.BARHEIGHT = SBFOptions.strings.BARHEIGHT or "Bar height"
SBFOptions.strings.BARTEXTURE = SBFOptions.strings.BARTEXTURE or "Bar texture"
SBFOptions.strings.BARBGTEXTURE = SBFOptions.strings.BARBGTEXTURE or "Background texture" -- 3.1.17
SBFOptions.strings.BARBUFFCOLOUR = SBFOptions.strings.BARBUFFCOLOUR or "Buff bar colour"
SBFOptions.strings.BARDEBUFFCOLOUR = SBFOptions.strings.BARDEBUFFCOLOUR or "Debuff bar colour"
SBFOptions.strings.BARBACKDROP = SBFOptions.strings.BARBACKDROP or "Bar background colour"
SBFOptions.strings.DEBUFFBARCOLOUR = SBFOptions.strings.DEBUFFBARCOLOUR or "Colour debuff names by type"
SBFOptions.strings.DEBUFFBARCOLOURTT1 = SBFOptions.strings.DEBUFFBARCOLOURTT1 or "The bar will be coloured using the debuff type's colour"
SBFOptions.strings.DEBUFFBARCOLOURTT2 = SBFOptions.strings.DEBUFFBARCOLOURTT2 or "(curse, magic, poison, etc.)"
SBFOptions.strings.BARPOSITION = SBFOptions.strings.BARPOSITION or "Bar position"
SBFOptions.strings.BARNOSPARK = SBFOptions.strings.BARNOSPARK or "No spark on bar"

-- Name Tab
SBFOptions.strings.SHOWNAMES = SBFOptions.strings.SHOWNAMES or "Show buff names"
SBFOptions.strings.NAMECONFIG = SBFOptions.strings.NAMECONFIG or "Names"
SBFOptions.strings.NAMEBUFFCOLOUR = SBFOptions.strings.NAMEBUFFCOLOUR or "Buff colour"
SBFOptions.strings.NAMEDEBUFFCOLOUR = SBFOptions.strings.NAMEDEBUFFCOLOUR or "Debuff colour"
SBFOptions.strings.NAMECOUNT = SBFOptions.strings.NAMECOUNT or "Count format"
SBFOptions.strings.NAMEFORMAT = SBFOptions.strings.NAMEFORMAT or "Name format"
SBFOptions.strings.NAMERANK = SBFOptions.strings.NAMERANK or "Rank format"
SBFOptions.strings.DEBUFFNAMECOLOUR = SBFOptions.strings.DEBUFFNAMECOLOUR or "Colour debuff names by type"
SBFOptions.strings.DEBUFFNAMECOLOURTT1 = SBFOptions.strings.DEBUFFNAMECOLOURTT1 or "The name will be coloured using the debuff type's colour"
SBFOptions.strings.DEBUFFNAMECOLOURTT2 = SBFOptions.strings.DEBUFFNAMECOLOURTT2 or "(curse, magic, poison, etc.)"
SBFOptions.strings.NAMEPOSITION = SBFOptions.strings.NAMEPOSITION or "Name position"
-- v3.1.5
SBFOptions.strings.NAMEACTIVE = SBFOptions.strings.NAMEACTIVE or "Activate mouse"
SBFOptions.strings.NAMEACTIVETT = SBFOptions.strings.NAMEACTIVETT or "Buff names will show tooltips, allow you to click to dismiss, etc." 

-- Expiry Tab
SBFOptions.strings.WARNCONFIG = SBFOptions.strings.WARNCONFIG or "Expiry"
SBFOptions.strings.EXPIREWARN = SBFOptions.strings.EXPIREWARN or "Text expiry warning"
SBFOptions.strings.EXPIREWARNTT = SBFOptions.strings.EXPIREWARNTT or "Adds a notice in chat when a buff is close to expiring"
SBFOptions.strings.EXPIRENOTICE = SBFOptions.strings.EXPIRENOTICE or "Text expiry notice"
SBFOptions.strings.EXPIRENOTICETT = SBFOptions.strings.EXPIRENOTICETT or "Adds a notice in chat when a buff expires"
SBFOptions.strings.EXPIRESOUND = SBFOptions.strings.EXPIRESOUND or "Sound expiry warning"
SBFOptions.strings.SOUNDCHOOSE = SBFOptions.strings.SOUNDCHOOSE or "Expiry sound"
SBFOptions.strings.WARNSOUND = SBFOptions.strings.WARNSOUND or "Warning sound"
SBFOptions.strings.MINTIME = SBFOptions.strings.MINTIME or "Minimum duration"
SBFOptions.strings.EXPIRETIME = SBFOptions.strings.EXPIRETIME or "Warn at"
SBFOptions.strings.EXPIREFRAME = SBFOptions.strings.EXPIREFRAME or "Chat frame"
SBFOptions.strings.EXPIREFRAMETEST = SBFOptions.strings.EXPIREFRAMETEST or "Expiry warnings for buff frame %d will appear here"
SBFOptions.strings.SCTCOLOUR = SBFOptions.strings.SCTCOLOUR or "Colour"
SBFOptions.strings.FASTBAR = SBFOptions.strings.FASTBAR or "Fast bar expiry"
SBFOptions.strings.SCTWARN = SBFOptions.strings.SCTWARN or "Expiry warnings in %s"
SBFOptions.strings.SCTCRIT = SBFOptions.strings.SCTCRIT or "Show as crit"
SBFOptions.strings.SCTCRITTT1 = SBFOptions.strings.SCTCRITTT1 or "Will show expiry warnings in scrolling combat text as a critical hit, if available"
SBFOptions.strings.SCTCRITTTM1 = SBFOptions.strings.SCTCRITTTM1 or "You currently have SCT set up to show buffs fading as messages."
SBFOptions.strings.SCTCRITTTM2 = SBFOptions.strings.SCTCRITTTM2 or "This SCT setting does not permit the messages to be shown as crits"
SBFOptions.strings.FLASHBUFF = SBFOptions.strings.FLASHBUFF or "Flash buff icon when expiring"
SBFOptions.strings.USERWARN = SBFOptions.strings.USERWARN or "Selected buffs only"
SBFOptions.strings.ALLWARN = SBFOptions.strings.ALLWARN or "All buffs"

-- Frame stick tab
SBFOptions.strings.FLOWCONFIG = SBFOptions.strings.FLOWCONFIG or "Buff Flowing"
SBFOptions.strings.STICKTOFRAME = SBFOptions.strings.STICKTOFRAME or "Parent"
SBFOptions.strings.FLOWCHILDFRAME = SBFOptions.strings.FLOWCHILDFRAME or "Add child"
SBFOptions.strings.FLOWEXPIRY = SBFOptions.strings.FLOWEXPIRY or "Use child settings for expiry"

-- Spells Tab
SBFOptions.strings.BLACKLISTCHECK = SBFOptions.strings.BLACKLISTCHECK or "Do not show this buff (by name)"
SBFOptions.strings.WHITELISTCHECK = SBFOptions.strings.WHITELISTCHECK or "Show this buff (by name)"
-- 3.1.25
SBFOptions.strings.BLACKLISTIDCHECK = SBFOptions.strings.BLACKLISTIDCHECK or "Do not show this buff (by spellID)"
SBFOptions.strings.WHITELISTIDCHECK = SBFOptions.strings.WHITELISTIDCHECK or "Show this buff (by spellID)"
-- 3.1.25
SBFOptions.strings.ALWAYSWARN = SBFOptions.strings.ALWAYSWARN or "Always warn when expiring"
SBFOptions.strings.MINE = SBFOptions.strings.MINE or "Cast by me"
SBFOptions.strings.CASTABLE = SBFOptions.strings.CASTABLE or "Cast by anyone of my class"
SBFOptions.strings.DEFAULTFRAME = SBFOptions.strings.DEFAULTFRAME or "Default frame"
SBFOptions.strings.SPELLFILTER = SBFOptions.strings.SPELLFILTER or "Search spells"
SBFOptions.strings.AURA = SBFOptions.strings.AURA or "Aura"
SBFOptions.strings.CLEARSPELLS = SBFOptions.strings.CLEARSPELLS or "Clear Data"
SBFOptions.strings.CLEARSPELLSTT1 = SBFOptions.strings.CLEARSPELLSTT1 or "Clear SBF's cache of buff data"
SBFOptions.strings.CLEARSPELLSTT2 = SBFOptions.strings.CLEARSPELLSTT2 or "Use this if you are having problems with filters or buff display"
SBFOptions.strings.CLEARSPELLSTT3 = SBFOptions.strings.CLEARSPELLSTT3 or "(will not affect your always warn/show in frame/do not show settings)"
SBFOptions.strings.SPELLCONFIG = SBFOptions.strings.SPELLCONFIG or "Spells"
SBFOptions.strings.LISTBUFFSTT = SBFOptions.strings.LISTBUFFSTT or "Shows buffs in the list on this tab"
SBFOptions.strings.LISTDEBUFFSTT = SBFOptions.strings.LISTDEBUFFSTT or "Shows debuffs in the list on this tab"
SBFOptions.strings.SPELLTTL = SBFOptions.strings.SPELLTTL or "Spell Lifetime" -- 3.1.13
SBFOptions.strings.SPELLTTLHELP = SBFOptions.strings.SPELLTTLHELP or { -- 3.1.13
  "Spell Lifetime",
  "This is the number of days that a spell's information will be kept by SBF.",
  "Every time an effect is seen by SBF, the spell lifetime is reset.  If a",
  "spell goes for this many days without being seen by SBF, it will be removed",
  "from the spell list (until it is seen again).",
  "This setting is global for all characters.",
}

-- Global Tab
SBFOptions.strings.GLOBALCONFIG = SBFOptions.strings.GLOBALCONFIG or "Global Options"
SBFOptions.strings.HOME = SBFOptions.strings.HOME or "Home"
SBFOptions.strings.AURAMAXTIME = SBFOptions.strings.AURAMAXTIME or "Auras have max time"
SBFOptions.strings.AURAMAXTIMETT1 = SBFOptions.strings.AURAMAXTIMETT1 or "When selected, auras (spells without duration)"
SBFOptions.strings.AURAMAXTIMETT2 = SBFOptions.strings.AURAMAXTIMETT2 or "will appear as the spells with the longest time remaining."
SBFOptions.strings.ENCHANTSFIRST = SBFOptions.strings.ENCHANTSFIRST or "Show item enchants first"
SBFOptions.strings.DISABLEBF = SBFOptions.strings.DISABLEBF or "Disable ButtonFacade in SBF"
SBFOptions.strings.TOTEMNONBUFF = SBFOptions.strings.TOTEMNONBUFF or "Do not show non-buff totems"
SBFOptions.strings.TOTEMOUTOFRANGE = SBFOptions.strings.TOTEMOUTOFRANGE or "Show buff totems when out of range"
SBFOptions.strings.TOTEMTIMERS = SBFOptions.strings.TOTEMTIMERS or "Do not show totem timers"
SBFOptions.strings.HIDEPARTY = SBFOptions.strings.HIDEPARTY or "Use \"Hide Party Interface\" option flag"
SBFOptions.strings.HIDEPARTYTT1 = SBFOptions.strings.HIDEPARTYTT1 or "Checking this makes buff frames for party members honour the"
SBFOptions.strings.HIDEPARTYTT2 = SBFOptions.strings.HIDEPARTYTT2 or "\"Hide Party Interface in Raid\" option in the Interface/Party&Raid options"
SBFOptions.strings.NOCASTERNAME = SBFOptions.strings.NOCASTERNAME or "Don't show caster names in tooltips"  -- 3.1.13

-- Profile Tab
SBFOptions.strings.PROFILECONFIG = SBFOptions.strings.PROFILECONFIG or "Profiles"

-- Misc
SBFOptions.strings.VERSION2 = SBFOptions.strings.VERSION2 or "Satrina Buff Frames |cff00ff00%s|r"
SBFOptions.strings.HINT3 = SBFOptions.strings.HINT3 or "http://evilempireguild.org/SBF"
SBFOptions.strings.HINT2 = SBFOptions.strings.HINT2 or "Alt+Drag to move me"
SBFOptions.strings.HINT = SBFOptions.strings.HINT or "Have a question?  Need help? Try here first:"
SBFOptions.strings.FRAME = SBFOptions.strings.FRAME or "Frame %d"
SBFOptions.strings.USINGPROFILE = SBFOptions.strings.USINGPROFILE or "Using profile"
SBFOptions.strings.COPYPROFILE = SBFOptions.strings.COPYPROFILE or "Copy profile"
SBFOptions.strings.DELETEPROFILE = SBFOptions.strings.DELETEPROFILE or "Delete profile"
SBFOptions.strings.NEWPROFILE = SBFOptions.strings.NEWPROFILE or "Enter the name for the new profile"
SBFOptions.strings.CONFIRMREMOVEPROFILE = SBFOptions.strings.CONFIRMREMOVEPROFILE or "Are you sure you want to delete profile %s?"
SBFOptions.strings.NEWPROFILEBUTTON = SBFOptions.strings.NEWPROFILEBUTTON or "New Profile"

SBFOptions.strings.BUFFFRAME = SBFOptions.strings.BUFFFRAME or "Buff Frame"
SBFOptions.strings.BUFFFRAMENUM = SBFOptions.strings.BUFFFRAMENUM or "Buff frame %d"
SBFOptions.strings.CURRENTFRAME = SBFOptions.strings.CURRENTFRAME or "Current Frame:"
SBFOptions.strings.NEWFRAME = SBFOptions.strings.NEWFRAME or "New Frame"
SBFOptions.strings.REMOVE = SBFOptions.strings.REMOVE or "Remove"
SBFOptions.strings.REMOVEFRAME = SBFOptions.strings.REMOVEFRAME or "Remove Frame"
SBFOptions.strings.REMOVEFRAMETT = SBFOptions.strings.REMOVEFRAMETT or "Remove this buff frame"
SBFOptions.strings.DELETEERROR = SBFOptions.strings.DELETEERROR or "You cannot remove buff frames 1 or 2, or the enchants frame"
SBFOptions.strings.DEFAULT_TOOLTIP = SBFOptions.strings.DEFAULT_TOOLTIP or "Reset this frame's layout and expiry settings to the defaults"
SBFOptions.strings.DEFAULTS = SBFOptions.strings.DEFAULTS or "Defaults"
SBFOptions.strings.DEBUFFTIMER = SBFOptions.strings.DEBUFFTIMER or "Colour debuff timer by type"
SBFOptions.strings.DEBUFFTIMERTT1 = SBFOptions.strings.DEBUFFTIMERTT1 or "The timer will be coloured using the debuff type's colour"
SBFOptions.strings.DEBUFFTIMERTT2 = SBFOptions.strings.DEBUFFTIMERTT2 or "(curse, magic, poison, etc.)"
SBFOptions.strings.NEWFRAMETT = SBFOptions.strings.NEWFRAMETT or "Create a new buff frame"
SBFOptions.strings.NONE = SBFOptions.strings.NONE or "None"
SBFOptions.strings.HELP = SBFOptions.strings.HELP or "Help"
SBFOptions.strings.POSITIONBOTTOM = SBFOptions.strings.POSITIONBOTTOM or "Hold Alt to move by 10"
SBFOptions.strings.FRAMELEVEL = SBFOptions.strings.FRAMELEVEL or "Frame level %d"

SBFOptions.strings.FONT = SBFOptions.strings.FONT or "Font"
SBFOptions.strings.FONTSIZE = SBFOptions.strings.FONTSIZE or "Font size (%d)"
SBFOptions.strings.OUTLINEFONT = SBFOptions.strings.OUTLINEFONT or "Outline Font"

SBFOptions.strings.RESET = SBFOptions.strings.RESET or "Reset Frames"
SBFOptions.strings.RESETFRAMESTT = SBFOptions.strings.RESETFRAMESTT or "Reset to SBF default frames"

SBFOptions.strings.SHOWINFRAMEDELETE = SBFOptions.strings.SHOWINFRAMEDELETE or "Removing show in frame %d for %s"
SBFOptions.strings.SHOWFILTER = SBFOptions.strings.SHOWFILTER or "Matching filter %d:%s"
SBFOptions.strings.FILTERBLOCKED = SBFOptions.strings.FILTERBLOCKED or "Filter(s) overriden by show in buff frame %d"
SBFOptions.strings.SHOWBUFFS = SBFOptions.strings.SHOWBUFFS or "List buffs"
SBFOptions.strings.SHOWDEBUFFS = SBFOptions.strings.SHOWDEBUFFS or "List debuffs"
SBFOptions.strings.DURATION = SBFOptions.strings.DURATION or "Duration"

SBFOptions.strings.JUSTIFY = SBFOptions.strings.JUSTIFY or "Justify"
SBFOptions.strings.JUSTIFYRIGHT = SBFOptions.strings.JUSTIFYRIGHT or "Right"
SBFOptions.strings.JUSTIFYLEFT = SBFOptions.strings.JUSTIFYLEFT or "Left"

SBFOptions.strings.REFRESH = SBFOptions.strings.REFRESH or "Bar update rate"
SBFOptions.strings.COPYFROM = SBFOptions.strings.COPYFROM or "Copy from"
SBFOptions.strings.TRACKING = SBFOptions.strings.TRACKING or "Show tracking"

-- Filters Tab
SBFOptions.strings.FILTERCONFIG = SBFOptions.strings.FILTERCONFIG or "Filters"
SBFOptions.strings.FILTER = SBFOptions.strings.FILTER or "New Filter"
SBFOptions.strings.ADDFILTER = SBFOptions.strings.ADDFILTER or "Add Filter"
SBFOptions.strings.EDITFILTER = SBFOptions.strings.EDITFILTER or "Edit Filter"
SBFOptions.strings.FILTERHELP = SBFOptions.strings.FILTERHELP or "Filter Help"
SBFOptions.strings.UP = SBFOptions.strings.UP or "Up"
SBFOptions.strings.DOWN = SBFOptions.strings.DOWN or "Down"
SBFOptions.strings.EDIT = SBFOptions.strings.EDIT or "Edit"
SBFOptions.strings.FILTERBLACKLIST = SBFOptions.strings.FILTERBLACKLIST or "Filtered buffs are not being shown in this frame"
SBFOptions.strings.FILTERWHITELIST = SBFOptions.strings.FILTERWHITELIST or "Filtered buffs are being shown in this frame"
SBFOptions.strings.COMMONFILTERS = SBFOptions.strings.COMMONFILTERS or "Common Filters"
SBFOptions.strings.USEDFILTERS = SBFOptions.strings.USEDFILTERS or "Filters in use"
SBFOptions.strings.COMMONFILTERLIST = SBFOptions.strings.COMMONFILTERLIST or {
  "Auras",
  "Duration less than 15 seconds",
  "Duration less than 30 seconds",
  "Duration less than 60 seconds",
  "Duration longer than 10 minutes",
  "Duration longer than 20 minutes",
  "Buffs/debuffs I can dispel",
  "Buffs/debuffs I can cast",
  "Buffs/debuffs I did cast",
  "Totems",
  "Tracking buff",
  "Magic effects",
  "Disease effects",
  "Poison effects",
  "Curse effects",
  "Untyped effects",
}

-- Filters Help

-- You never need to include these in your locale file
SBFOptions.strings.OPENHTML = SBFOptions.strings.OPENHTML or "<HTML><BODY><P>"
SBFOptions.strings.CLOSEHTML = SBFOptions.strings.CLOSEHTML or "</P></BODY></HTML>"

-- Don't include this in your locale file unless you are translating it
SBFOptions.strings.FILTERHELPHTML = SBFOptions.strings.FILTERHELPHTML or {
  {	"|cff00ff00Filter Help|r<BR/>",
    "A filter is of the form {|cffffcc00command|r}{|cff00cc00modidfier|r}{parameter}<BR/>",
    "<BR/>",
    "The filter has 3 parts:<BR/>",
    "|cffffcc00command|r - what property of the effect the filter will operate on<BR/>",
    "|cff00cc00modidfier|r - how the filter will compare<BR/>",
    "parameter - what the filter will compare against<BR/>",
    "<BR/>",
    "An example: |cff00d2ffD>20|r<BR/>",
    "<BR/>",
    "In this example, the parts are (more details about these on the next pages):<BR/>",
    "|cffffcc00D|r - The filter will look at the effect's duration in minutes<BR/>",
    "|cff00cc00>|r - The filter will use a 'greater than' comparison<BR/>",
    "20 - The filter will compare against 20 minutes<BR/>",
    "<BR/>",
    "So, the filter |cff00d2ffD>20|r means 'Any effects with duration more than 20 minutes'.  As above, what happens to an effect that matches a filter depends on whether the frame is set to blacklist or whitelist.<BR/>",
  },
  {	"|cff00ff00Commands|r:<BR/>",
    "|cffffcc00n|r: Filter by name (not case sensitive)<BR/>",
    "|cffffcc00tt|r: Filter by tooltip description text (not case sensitive)<BR/>",
    "|cffffcc00D|r: Filter by effect duration in minutes<BR/>",
    "|cffffcc00d|r: Filter by effect duration in seconds<BR/>",
    "|cffffcc00r|r: Filter on effect's remaining time in seconds<BR/>",
    "|cffffcc00R|r: Filter on effect's remaining time in minutes<BR/>",
    "|cffffcc00a|r: Auras (effect with no duration: paladin auras, aspects, etc.)<BR/>",
    "|cffffcc00e|r: Filter temporary item enchantments<BR/>",
    "|cffffcc00tr|r: Filter the tracking buff<BR/>",
    "|cffffcc00to|r: Filter your totems (for the shaman who owns the totems)<BR/>",
    "|cffffcc00c|r: Filter effect that your class can cast (but that you did not necessarily cast yourself)<BR/>",
    "|cffffcc00my|r: Filter effect that you cast<BR/>",
    "|cffffcc00s|r: Filter effects that you can spellsteal (hint: you can only spellsteal buffs)<BR/>",
    "|cffffcc00v|r: Filter effects that are from your vehicle<BR/>", -- 3.1.13
    "|cffffcc00help|r: Filter effects that are on friendly units<BR/>", -- 3.1.13
    "|cffffcc00harm|r: Filter effects that are on enemy units<BR/>", -- 3.1.13
    "|cffffcc00player|r: Filter effects that are cast by players<BR/>", -- 3.1.13
    "|cffffcc00npc|r: Filter effects that are cast by NPCs<BR/>", -- 3.1.13
    "|cffffcc00party|r: Filter effects that are cast by people in your party or raid<BR/>", -- 3.1.13
    "<BR/>",
    "In addition, there are several filters specifically for debuffs.  (The '|cffffcc00h|r' stands for harmful, since '|cffffcc00d|r' was already claimed for duration)<BR/>",
    "<BR/>",
    "|cffffcc00hc|r filters curses.<BR/>",
    "|cffffcc00hd|r filters diseases.<BR/>",
    "|cffffcc00hm|r filters magic.<BR/>",
    "|cffffcc00hp|r filters poison.<BR/>",
    "|cffffcc00hu|r filters debuffs with no type (untyped).<BR/>",
    "|cffffcc00ha|r filters debuff types you can dispel",
  },
  {	"|cff00ff00Operators|r:<BR/>",
    "|cff00ff00=|r exact match (used with |cffffcc00n|r)<BR/>",
    "|cff00ff00~|r partial match (used with |cffffcc00n,t|r)<BR/>",
    "|cff00ff00&lt;|r less than (used with |cffffcc00d,D,r,R|r)<BR/>",
    "|cff00ff00&lt;=|r less than or equal to (used with |cffffcc00d,D,r,R|r)<BR/>",
    "|cff00ff00&gt;|r greater than (used with |cffffcc00d,D,r,R|r)<BR/>",
    "|cff00ff00&gt;=|r greater than or equal to (used with |cffffcc00d,D,r,R|r)<BR/>",
    "<BR/>",
    "The negation (logical not) operator, |cff00ff00!|r, is used with the |cffffcc00n|r, |cffffcc00tt|r, |cffffcc00hc/hd/hm/hp/hu/ha|r, and |cffffcc00a|r commands:<BR/>",
    "|cff00d2ffa!|r (or |cff00d2ff!a|r) means 'effects that are not auras' (that is, effects that have durations)<BR/>",
    "|cff00d2ffn!~elixir|r means 'effects that do not contain elixir in their name'<BR/>",
    "|cff00d2ffn!=arcane intellect|r means 'not the Arcane Intellect effect'<BR/>",
    "|cff00d2fftt!~intellect|r means 'effects that do not contain intellect in the tooltip text'<BR/>",
    "|cff00d2ff!hc|r would mean 'effects that are not curses'<BR/>",
    "<BR/>",
    "|cff00ff00Parameters|r:<BR/>",
    "String - The |cffffcc00n|r and |cffffcc00tt|r commands take a string that is either used to partially match (~ operator) or exactly match (= operator) the name or tooltip text of the effect<BR/><BR/>",
    "Number - The |cffffcc00D|r, |cffffcc00d|r, |cffffcc00R|r, and |cffffcc00r|r commands take a number that is used to compare against the effect's duration or remaining time<BR/><BR/>",
    "The |cffffcc00a|r, |cffffcc00e|r, |cffffcc00hc|r, |cffffcc00hd|r, |cffffcc00hm|r, |cffffcc00hp|r, |cffffcc00hu|r, |cffffcc00ha|r, |cffffcc00tr|r, |cffffcc00c|r, |cffffcc00my|r, and |cffffcc00to|r commands do not take any parameters<BR/>",
  },
  {	"|cff00ff00Combining Filters with the and operator|r<BR/>",
    "You can make combinations of filters using logical and {&amp;} operator.<BR/>",
    "|cff00d2ffn~flask&amp;R&gt;60|r will be true if the name of the effect has 'flask' in it and its time remaining is more than 60 minutes<BR/>",
    "<BR/>",
    "|cff00ff00Sample Filters|r:<BR/>",
    "|cff00d2ffn~elixir|r<BR/>",
    "Filter 'Adept's Elixir', 'Elixir of Mastery' and so on<BR/><BR/>",
    "|cff00d2ffD&lt;=3|r<BR/>",
    "Filter all effects of duration less than or equal to 3 minutes<BR/><BR/>",
    "|cff00d2ffa|r<BR/>",
    "Filter all auras<BR/><BR/>",
    "|cff00d2ffe|r<BR/>",
    "Filters all temporary item enchants (sharpened, wizard oil, etc.)<BR/><BR/>",
    "|cff00d2ffn=arcane intellect|r<BR/>",
    "Filters the Arcane Intellect effect<BR/><BR/>",
    "|cff00d2ffn=living bomb&amp;my|r<BR/>",
    "Filters the Living Bomb effect that I placed on the target<BR/><BR/>",
    "|cff00d2ffc|r<BR/>",
    "Filters the effects that my class can place on the target",
  },
}

-- Don't include this in your locale file unless you are translating it
SBFOptions.strings.NAMEHELPHTML = SBFOptions.strings.NAMEHELPHTML or {
  {	"|cff00ff00Name Help|r<BR/>",
    "There are three valid elements for a name:<BR/>",
    "<BR/>",
    "|cffff00ccName|r - How the effect's name will be displayed<BR/>",
    "|cffffcc00Rank|r - How the effect's rank will be displayed<BR/>",
    "|cff00cc00Count|r - How the effect's count will be displayed<BR/>",
    "<BR/>",
    "An example: |cffff00ccName[full]|r |cffffcc00Rank[Roman]|r |cff00cc00Count[(always)]|r<BR/>",
    "<BR/>",
    "In this example, all the possible elements are displayed:<BR/>",
    "|cffff00ccName[full]|r - Show the full effect name (e.g. Arcane Intellect) <BR/>",
    "|cffffcc00Rank[Roman]|r - The effect's rank will be displayed as a roman numeral<BR/>",
    "|cff00cc00Count[(XXX)]|r - The effect count will always be displayed, enclosed in parentheses ()<BR/>",
    "<BR/>",
    "This format will make an effect name formatted like this: |cff00d2ffArcane Intellect VI (1)|r<BR/>",
    "<BR/>",
    "|cff00ff00Element Formatting|r<BR/>",
    "An element always takes the form of |cff00d2ffElement[stufftodisplay]|r<BR/>",
    "<BR/>",
    "Each element type will have valid keywords that will be replaced with effect-specific data.  You may place whatever text you wish inside an element tag to go with the keywords that are substituted and it will be reproduced exactly.<BR/>",
    "<BR/>",
    "For example: Count[(always)] vs. Count[always]<BR/>",
    "When the always keyword is substituted, Count[(always)] will display as |cff00d2ff(6)|r<BR/>",
    "When the always keyword is substituted, Count[always] will display as |cff00d2ff6|r<BR/>",
    "<BR/>",
    "When the roman keyword is substituted in Rank[Rank roman], it will display as |cff00d2ffRank IV|r<BR/>",
  },
  {	"|cff00ff00Name Element|r<BR/>",
    "There are three valid keywords for the name element:<BR/>",
    "<BR/>",
    "|cffff00ccfull|r - The effect's full name (e.g. Mark of the Wild)<BR/>",
    "|cffff00ccshort|r - The effect's name shortened (e.g. MotW)<BR/>",
    "|cffff00ccxshort|r - The shortened name, even shorter (e.g. MW)<BR/>",
    "|cffff00cctrunc:X|r - The effect's name truncated at X characters from the beginning<BR/>",
    "|cffff00ccchop:X|r - The effect's name with the first X characters chopped off<BR/>",
    "|cffff00ccof|r - Chop off everything to the end of the word 'of' in the effect's name<BR/>",
    "(e.g. Elixir of Draenic Wisdom -> Draenic Wisdom)<BR/>",
    "<BR/>",
    "<BR/>",
    "|cff00ff00Rank Element|r<BR/>",
    "There are two valid keywords for the rank element:<BR/>",
    "<BR/>",
    "|cffffcc00arabic|r - The effect's rank in arabic numerals (e.g. 6)<BR/>",
    "|cffffcc00roman|r - The effect's rank in roman numerals (e.g. VI)<BR/>",
    "<BR/>",
    "If no rank is available for an effect, the Rank element will not be shown<BR/>",
    "<BR/>",
    "<BR/>",
    "|cff00ff00Count Element|r<BR/>",
    "There are three valid keywords for the count element:<BR/>",
    "<BR/>",
    "|cff00cc00normal|r - The count element is shown only if it is a stacking effect with more than one stack<BR/>",
    "|cff00cc00stack|r - The count element is shown only if it is a stacking effect, even if there is only one stack of the effect<BR/>",
    "|cff00cc00always|r - The count element is always shown, even the effect does not stack<BR/>",
  },
  {	"|cff00ff00Tips|r<BR/>",
    "|cffffcc00Rank[Rank roman]|r and 'Rank |cffffcc00Rank[roman]|r' are actually quite different. Consider these name formats:<BR/>",
    "|cffff00ccName[full]|r |cffffcc00Rank[Rank roman]|r and |cffff00ccName[full]|r Rank |cffffcc00Rank[roman]|r<BR/>",
    "<BR/>",
    "When applied to Arcane Intellect (Rank 6), these will both display the same thing:<BR/>",
    "|cff00d2ffArcane Intellect Rank VI|r<BR/>",
    "<BR/>",
    "However, when applied to Well Fed, which does not give a rank, these will display differently:<BR/>",
    "|cffff00ccName[full]|r |cffffcc00Rank[Rank roman]|r will display |cff00d2ffWell Fed|r<BR/>",
    "|cffff00ccName[full]|r Rank |cffffcc00Rank[roman]|r will display |cff00d2ffWell Fed Rank|r<BR/>",
    "<BR/>",
    "Always put all of the conditional text for an element inside its tag!<BR/>",
  },
}

SBFOptions.strings.frameVisibility = SBFOptions.strings.frameVisibility or {
  "Always",
  "Never",
  "In combat",
  "Out of combat",
}
SBFOptions.strings.frameVisibility[5] = SBFOptions.strings.frameVisibility[5] or "Mouseover" -- 3.1.13  (since not all locales have it translated)
SBFOptions.strings.frameVisibility[6] = SBFOptions.strings.frameVisibility[6] or "Solo" -- 3.1.13
SBFOptions.strings.frameVisibility[7] = SBFOptions.strings.frameVisibility[7] or "Party" -- 3.1.13
SBFOptions.strings.frameVisibility[8] = SBFOptions.strings.frameVisibility[8] or "Raid" -- 3.1.13
SBFOptions.strings.frameVisibility[9] = SBFOptions.strings.frameVisibility[9] or "Party or Raid" -- 3.1.13
SBFOptions.strings.frameVisibility[10] = SBFOptions.strings.frameVisibility[10] or "Friendly" -- 3.1.13
SBFOptions.strings.frameVisibility[11] = SBFOptions.strings.frameVisibility[11] or "Hostile" -- 3.1.13

SBFOptions.strings.timerFormats = SBFOptions.strings.timerFormats or {
  "Blizzard style",
  "mm:ss",
  "Seconds",
  "< 60sec only",
  "No timer",
  "Blizzard style II",
  "OmniCC style",
}

SBFOptions.strings.WARNTIMETT = SBFOptions.strings.WARNTIMETT or {
  "Expiration Warning Time",
  "Expiration warning will be given",
  "when this much time is left on the effect",
}

SBFOptions.strings.MINTIMETT = SBFOptions.strings.MINTIMETT or {
  "Minimum Time",
  "Expiration warning will be given only",
  "for effects of this duration or longer",
}


-- 3.1.25
SBFOptions.strings.RELOADNEEDED = SBFOptions.strings.RELOADNEEDED or "You need to relog or reload UI for this change to take effect"
SBFOptions.strings.DEFAULTBUFFS = SBFOptions.strings.DEFAULTBUFFS or "Show the default buff frame"
SBFOptions.strings.DEFAULTENCHANTS = SBFOptions.strings.DEFAULTENCHANTS or "Show default enchant frame"
-- 3.1.25