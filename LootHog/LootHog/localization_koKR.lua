-- Korean Localization:
-- Done by 

if (GetLocale()=="koKR") then
	loothog_version = "3.3.0"
	LOOTHOG_TITLE = "Loothog " .. loothog_version
	BINDING_NAME_LOOTHOGTOGGLE = "Show/Hide Window"
	BINDING_HEADER_LOOTHOG = "LootHog"
	LOOTHOG_ROLL_PATTERN = "(.+) rolls (%d+) %((%d+)%-(%d+)%)" --hopefully fixes the Â character problems
	LOOTHOG_PASS_PATTERN = "pass"
	LOOTHOG_RESETONWATCH_PATTERN = " won with a roll of"
	LOOTHOG_RESETONWATCH_PATTERN2 = "tied with"

-- size of the main and options/config window
	LOOTHOG_UI_MAIN_WIDTH = "190"
	LOOTHOG_UI_CONFIG_WIDTH = "410"
	LOOTHOG_UI_CONFIG_HEIGHT = "520"

	LOOTHOG_ADDON_LABEL_OPTIONS = "Global Options"
	LOOTHOG_ADDON_LABEL_HANDLE = "Roll Handling"
	LOOTHOG_ADDON_LABEL_RULES = "Rules"
	LOOTHOG_ADDON_LABEL_ABOUT = "About"

	LOOTHOG_LABEL_DELIMITER = "------------------"
	LOOTHOG_LABEL_WINNERSDELIMITER = "=================="
	LOOTHOG_LABEL_CHATLISTTOP = "Rolls in descending Order"
	LOOTHOG_LABEL_ROLLS = "LootHog Rolls"
	LOOTHOG_LABEL_RULES = "LootHog Rules"
	LOOTHOG_LABEL_READY = "Ready..."  -- Means that LootHog is ready to receive /random rolls.
	LOOTHOG_LABEL_OPTIONS = "LootHog Options"
	LOOTHOG_LABEL_HOLDING = "Holding..."  -- Means that the user has clicked "Hold" to prevent the timeout.
	LOOTHOG_LABEL_NOTIMEOUT = "Timeout disabled."
	LOOTHOG_LABEL_TIMELEFT = "Timeout: %s seconds"  -- (seconds)
	LOOTHOG_LABEL_COUNTDOWN = "Countdown"
	LOOTHOG_LABEL_COUNT = "Rolls:%s, Players:%s"  -- (roll count, player count)

	LOOTHOG_BUTTON_CLEAR = "Clear"
	LOOTHOG_BUTTON_OPTIONS = "Options"
	LOOTHOG_BUTTON_HOLD = "Hold"
	LOOTHOG_BUTTON_UNHOLD = "UnHold"
	LOOTHOG_BUTTON_ANNOUNCE = "Announce"
	LOOTHOG_BUTTON_ASSIGN = "Assign"
	LOOTHOG_BUTTON_YETTOROLL = "Not rolled"
	LOOTHOG_BUTTON_INFO = "Kick Roll"
	LOOTHOG_BUTTON_ROLL = "Roll"
	LOOTHOG_BUTTON_OFFSPEC = "Alt Roll"
	LOOTHOG_BUTTON_PASS = "Pass"
	LOOTHOG_BUTTON_COUNTDOWN = "Countdown"
	LOOTHOG_BUTTON_START = "Start"
	LOOTHOG_BUTTON_RULES = "Rules"
	LOOTHOG_BUTTON_MODE = "Mode"
	LOOTHOG_BUTTON_ANNOUNCERULES = "Announce Rules"
	LOOTHOG_BUTTON_ANNOUNCELOOT = "Announce Loot"
	LOOTHOG_LABEL_OFF = "Loothog Rolls - Off"
	LOOTHOG_LABEL_ON = "Loothog Rolls - Auto"
	LOOTHOG_LABEL_MANUAL = "Loothog Rolls - Manual"
	LOOTHOG_LABEL_QUIET = "Loothog Rolls - Quiet"

	LOOTHOG_OPTION_ENABLE = "Enable LootHog"
	LOOTHOG_OPTION_MANUAL = "Only count rolls when I have started Loothog"
	LOOTHOG_OPTION_QUIET = "Quiet Mode"
	LOOTHOG_OPTION_AUTOSHOW = "Automatically show window when someone rolls"
	LOOTHOG_OPTION_RESETONWATCH = "Deactivate LootHog if someone else announces"
	LOOTHOG_OPTION_GROUPONLY = "Count rolls from group members only"
	LOOTHOG_OPTION_SHOWALLLOOTBUTTON = "Show the Announce All Loot Button"
	LOOTHOG_OPTION_MASTERLOOTERONLY = "Only if I'm Master Looter"
	LOOTHOG_OPTION_OVERRIDEREFRESH = "Override default refresh interval Refresh Every "
	LOOTHOG_OPTION_FRAMES = "frames"

	LOOTHOG_OPTION_LISTTOCHAT = "Submit top"
	LOOTHOG_OPTION_LISTTOCHAT2 = "rolls to chat when announcing"

	LOOTHOG_OPTION_PREVENT = "Prevent /random rolls from appearing in the chatlog"
	LOOTHOG_OPTION_CLOSEONANNOUNCE = "Close LootHog window after announcing a winner"
	LOOTHOG_OPTION_CLEARONCLOSE = "Clear rolls when closing main window"
	LOOTHOG_OPTION_ACK = "Acknowledge rolls via /whisper to roller"

  LOOTHOG_OPTION_REJECT = "Reject rolls with bounds other than (" 
    LOOTHOG_OPTION_LOWER = " - "
    LOOTHOG_OPTION_UPPER = ")"
    LOOTHOG_OPTION_NOTIFYME = "Tell me when a roll has been rejected"
  LOOTHOG_OPTION_OFFSPEC = "Allow Offspec rolls ("
    LOOTHOG_OPTION_OFFSPEC_LOWER = " - "
    LOOTHOG_OPTION_OFFSPEC_UPPER = ")"
  LOOTHOG_OPTION_AUTOOFFSPEC = "Automatically announce offspec if no-one rolls"
    LOOTHOG_OPTION_ANNOUNCEOFFSPEC = "Announce on offspec"
    LOOTHOG_OPTION_OFFSPEC_ROLL_TEXT = "OFFSPEC!"
    LOOTHOG_OPTION_OFFSPECTIMEOUT = "Enable offspec timeout and set to"
  LOOTHOG_OPTION_REJECTCLASS = "Reject rolls from invalid classes"
    LOOTHOG_OPTION_ANNOUNCEREJECT = "Announce rejected rolls"
	
  LOOTHOG_OPTION_ANNOUNCEONCLEAR = "Announce on Start:"
    LOOTHOG_OPTION_NEW_ROLL_TEXT = "New roll starting now !"
    LOOTHOG_OPTION_ANNOUNCETIMEOUT = "Announce timeout on start"
    LOOTHOG_OPTION_ANNOUNCECLASS = "Announce Eligible Classes"
    LOOTHOG_OPTION_ANNOUNCECLASSTK = "for tokens only."
     
  LOOTHOG_OPTION_TIMEOUT1 = "Set Loothog Timeout to"
	LOOTHOG_OPTION_TIMEOUT2 = "seconds"

    LOOTHOG_OPTION_AUTOCOUNTDOWN = "Automatically countdown last"

    LOOTHOG_OPTION_AUTOEXTEND = "Reset timer to"
    LOOTHOG_OPTION_TIMEOUT3 = "seconds if roll detected in the last "
    LOOTHOG_OPTION_ANNOUNCEEXTEND = "Announce roll extenstions"
	
	LOOTHOG_OPTION_FINALIZE = "Announce after timeout expires"
	LOOTHOG_OPTION_AUTOASSIGN = "Automatically assign loot"
	LOOTHOG_OPTION_FINALIZEROLLS = "Finalize rolling when all group members have rolled"

    LOOTHOG_RULES_INTROLABEL = "Announce at start of rules :"
    LOOTHOG_RULES_INTRO = "Loothog Rules :"
    LOOTHOG_RULES_ONEEPIC = "Allow one epic per person"
    LOOTHOG_RULES_ONESET = "Allow one set piece/token per person"
    LOOTHOG_RULES_RESET = "Reset eligibility when all interested parties have received loot"
    LOOTHOG_RULES_DISENCHANTER = "will disenchant items. "

    LOOTHOG_RULES_CHAT_DKP1 = "One Epic"
    LOOTHOG_RULES_CHAT_DKP2 = " and one Set piece/token"
    LOOTHOG_RULES_CHAT_DKP3 = "One Set piece/token"
    LOOTHOG_RULES_CHAT_DKP4 = " per person."
    LOOTHOG_RULES_CHAT_RESET = "You will be eligible to roll again when all interested parties have recieved loot."
    LOOTHOG_RULES_CHAT_TIMEOUT = "You will have %s seconds to roll."
    LOOTHOG_RULES_CHAT_BOUNDS = "Rolls between %s and %s are accepted."
    LOOTHOG_RULES_CHAT_OFFSPEC = " For OffSpec please roll between %s and %s (/roll %s %s)"
    LOOTHOG_RULES_CHAT_CLASSES = "Only rolls from classes that are able to use an item will be accepted"

	LOOTHOG_MSG_LOAD = "LootHog v%s loaded.  For options, type /loothog."  -- (version)
	LOOTHOG_MSG_INFO = "LootHog-Information: You may pass on a running roll by typing: %s"  -- (pass pattern)
	LOOTHOG_MSG_CHEAT = "Ignoring %s's roll of %s (%s-%s)."  -- (player, roll, max_roll, min_roll)
	LOOTHOG_MSG_CHEATCLASS = "Ignoring %s's roll of %s (Invalid Class)"
	LOOTHOG_MSG_ACK = "Got your roll (%s).  Good luck!"  -- (roll)
	LOOTHOG_MSG_OFFSPEC_ACK = "Got your offspec roll (%s).  Good luck!"  -- (roll)
	LOOTHOG_MSG_ACK_PASS = "You have passed on this roll."  -- (pass)
	LOOTHOG_MSG_DUPE = "%s has rolled more than once!"  -- (player)
	LOOTHOG_MSG_WINNER = "%s%s won with a roll of %s!  (%s-%s) %s"  -- (player, group, roll, min, max, item)
	LOOTHOG_MSG_ROLLS = "%s: %s rolled %s."  -- (roll posistion, player, roll)
	LOOTHOG_MSG_ROLLS_OFFSPEC = "%s: %s rolled %s (Offspec)."  -- (roll posistion, player, roll)
	LOOTHOG_MSG_GROUP = "group"
	LOOTHOG_MSG_NOTGROUP= "group not found"
	LOOTHOG_MSG_STAT = "Gesamtanzahl der W\195\188rfe: "
	LOOTHOG_MSG_HOLDCONT = "Loothog is restarting countdown at %s seconds."
	LOOTHOG_MSG_HOLDSTART = "Loothog is holding countdown at %s seconds."
	LOOTHOG_MSG_RESET = "New Roll Detected restating countdown at %s seconds."
	LOOTHOG_MSG_TIMEANNOUNCE = "You have %s seconds to roll!"
	LOOTHOG_MSG_CLASSES = "Classes"
	

-- The following variables are used to build a string of this type, in the case of a tie:
-- "Gnomechomsky, Saucytails, and Pionerka tied with 98's!"
-- I don't know if a literal substitution can provide a proper translation.  Feedback is welcome.  :)
	LOOTHOG_MSG_AND = " and "
	LOOTHOG_MSG_TIED = " tied with %s's!"  -- (roll)
	LOOTHOG_MSG_YETTOPASS = "The following people still need to roll or say %s" --(LOOTHOG_PASS_PATTERN)
	LOOTHOG_MSG_REMOVEROLL = "<LootHog>: %s's roll of %s has been removed from consideration."

	LOOTHOG_DEATHKNIGHT_CLASS = "DeathKnight"
	LOOTHOG_WARLOCK_CLASS = "Warlock"
	LOOTHOG_PALADIN_CLASS = "Paladin"
	LOOTHOG_DRUID_CLASS = "Druid"
	LOOTHOG_MAGE_CLASS = "Mage"
	LOOTHOG_SHAMAN_CLASS = "Shaman"
	LOOTHOG_PRIEST_CLASS = "Priest"
	LOOTHOG_ROGUE_CLASS = "Rogue"
	LOOTHOG_HUNTER_CLASS = "Hunter"
	LOOTHOG_WARRIOR_CLASS = "Warrior"


	Loothog_Armor = "Armor"
	Loothog_Weapon = "Weapon"
	Loothog_Miscellaneous = "Miscellaneous"
	Loothog_Cloth = "Cloth"
	Loothog_Leather = "Leather"
	Loothog_Mail = "Mail"
	Loothog_Plate = "Plate"
	
	Loothog_Bows = "Bows"
	Loothog_Crossbows = "Crossbows"
	Loothog_Daggers = "Daggers"
	Loothog_Guns = "Guns"
	Loothog_FishingPoles = "Fishing Poles"
	Loothog_FistWeapons = "Fist Weapons"
	Loothog_OneHandedAxes = "One-Handed Axes"
	Loothog_OneHandedMaces = "One-Handed Maces"
	Loothog_OneHandedSwords = "One-Handed Swords"
	Loothog_Polearms = "Polearms"
	Loothog_Staves = "Staves"
	Loothog_Thrown = "Thrown"
	Loothog_TwoHandedAxes = "Two-Handed Axes"
	Loothog_TwoHandedMaces = "Two-Handed Maces"
	Loothog_TwoHandedSwords = "Two-Handed Swords"
	Loothog_Wands = "Wands"

	LOOTHOG_SLASH_TITLE = "Slash Commands"
	LOOTHOG_SLASH_TITLEUL = "============="
	LOOTHOG_SLASH_ROLL = "/LH Roll will roll with the configured boundaries (%s - %s)"
	LOOTHOG_SLASH_LINK = "/LH <ItemLink> will start Loothog and announce item."
	LOOTHOG_SLASH_CONFIG = "/LH Config or /LH Options loads the config screen"
	LOOTHOG_SLASH_TOGGLE = "/LH enable will turn Loothog on or off"
	LOOTHOG_SLASH_MANUAL = "/LH manual toggles manual mode on or off"
	LOOTHOG_SLASH_MODE = "/LH mode will toggles between the modes (Off, Auto, Manual)"
	LOOTHOG_SLASH_COUNTDOWN = "/LH Countdown will countdown the last %s seconds"
	LOOTHOG_SLASH_HOLD = "/LH Hold will toggle holding the countdown."
	LOOTHOG_SLASH_HOLDRESET = "Loothog will continue counting down from %s seconds"
	LOOTHOG_SLASH_KICK = "/LH Kick will kick the top roll from consideration"
	LOOTHOG_SLASH_ANNOUNCE = "/LH Announce will announce the winner to chat"
	LOOTHOG_SLASH_ASSIGN = "/LH Assign will assign loot to the winner (or DEer or Yourself)"
	LOOTHOG_SLASH_CLEAR = "/LH Clear will clear all current rolls and enter standby"
	LOOTHOG_SLASH_NOTROLLED = "/LH Notrolled will list party/raid members still to roll"
	LOOTHOG_SLASH_LIST = "/LH list will list the top %s winners"
	LOOTHOG_SLASH_START = "/LH Start will take Loothog out of standby mode"
	LOOTHOG_SLASH_START1 = "Loothog will start any configured countdowns"
	LOOTHOG_SLASH_OFFSPEC = "/LH offspec will roll an offspec roll. (%s - %s)"
	LOOTHOG_SLASH_RULES = "/LH Rules will announce the loot rules to party/raid"
	LOOTHOG_SLASH_RESET = "/LH Reset will delete all settings and reset to default"
	LOOTHOG_SLASH_HELP = "/LH Help Shows this screen"

	LOOTHOG_ABOUT_SEPERATOR = "**************************"
	LOOTHOG_ABOUT_AUTHOR = "Author : "
	LOOTHOG_ABOUT_AUTHORNAME = "Leucocepha, Serenity - Proudmoore"
	LOOTHOG_ABOUT_THANKS = "Thanks to: "
	LOOTHOG_ABOUT_THANKS1 = "Chompers for the original addon"
	LOOTHOG_ABOUT_THANKS2 = "Suan (Kaz'goroth) - Coding"
	LOOTHOG_ABOUT_THANKS3 = "Codeus - Coding"
	LOOTHOG_ABOUT_THANKS4 = "dblixer - Offspec Coding"
	LOOTHOG_ABOUT_THANKS5 = "Erytheia - Code Cleanup, Testing"
	LOOTHOG_ABOUT_THANKS6 = "Devilcat - Bugfixes"
	LOOTHOG_ABOUT_THANKS7 = "m0rgoth - French translation"
  	LOOTHOG_ABOUT_THANKS8 = "ShyMun - Spanish Translation"
  	LOOTHOG_ABOUT_THANKS9 = "Ufi82 - German Translation"


	LOOTHOG_ERROR_NOLOOT = "LOOTHOG ERROR : Can't find loot item"
	LOOTHOG_ERROR_NOMEMBER = "LOOTHOG ERROR : Can't find raid member"
	LOOTHOG_ERROR_LOOTWINDOW = "LOOTHOG ERROR :: You must have the loot window open to assign loot"
	LOOTHOG_ERROR_PARTY = "LOOTHOG ERROR :: You must be in a party or raid to assign loot"
	LOOTHOG_ERROR_MASTERLOOTER = "LOOTHOG ERROR :: You must be the Master Looter to assign loot"
end