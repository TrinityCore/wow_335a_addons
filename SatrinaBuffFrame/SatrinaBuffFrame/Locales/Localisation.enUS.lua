SBF.strings.DISABLE = SBF.strings.DISABLE or "Uninstall SBF to disable"
SBF.strings.BUFFEXPIRE = SBF.strings.BUFFEXPIRE or "is about to expire"
SBF.strings.BUFFNOTICE = SBF.strings.BUFFNOTICE or "has expired"
SBF.strings.VERSION = SBF.strings.VERSION or "version %s"
SBF.strings.NEWPLAYER = SBF.strings.NEWPLAYER or SBF.strings.NEWPLAYER or "Satrina Buff Frames new player: "
SBF.strings.UPDATE = SBF.strings.UPDATE or "Updating to Satrina Buff Frames %.1f"
SBF.strings.RESET = SBF.strings.RESET or "This update requires a reset of all saved variables - sorry!"
SBF.strings.EXCLUDE = SBF.strings.EXCLUDE or "Do not show this buff"
SBF.strings.BUFFFRAME = SBF.strings.BUFFFRAME or "Show in buff frame"
SBF.strings.NOFRAME = SBF.strings.NOFRAME or "Clear frame"
SBF.strings.ALWAYSWARN = SBF.strings.ALWAYSWARN or "Always warn when expiring"
SBF.strings.CANCEL = SBF.strings.CANCEL or "Cancel this buff"
SBF.strings.DESTROYTOTEM = SBF.strings.DESTROYTOTEM or "Destroy this totem"
SBF.strings.CONFIGERROR = SBF.strings.CONFIGERROR or "Error loading SBFOptions: %s"
SBF.strings.DRAGTAB = SBF.strings.DRAGTAB or "SBF %d"
SBF.strings.FRAMETITLE = SBF.strings.FRAMETITLE or "Buff Frame %d"
SBF.strings.ENCHANTS = SBF.strings.ENCHANTS or "Enchants"
SBF.strings.DRAGTAB1 = SBF.strings.DRAGTAB1 or "drag to move this frame"
SBF.strings.DRAGTAB2 = SBF.strings.DRAGTAB2 or "shift+click to select this frame"
SBF.strings.SHOWATBUFFRAME = SBF.strings.SHOWATBUFFRAME or "Buff Frame "
SBF.strings.TEMPENCHANT = SBF.strings.TEMPENCHANT or "Temp Enchant %d"
SBF.strings.INVALIDBUFF = SBF.strings.INVALIDBUFF or "Attempt to give expire warning for invalid buff"
SBF.strings.OPTIONS = SBF.strings.OPTIONS or "Opens SBF options"
SBF.strings.HIDE = SBF.strings.HIDE or "Force default buff frames to hide"
SBF.strings.DEFAULT = SBF.strings.DEFAULT or "Default"
SBF.strings.DEFAULTFRAME = SBF.strings.DEFAULTFRAME or "Default frame"

SBF.strings.UNKNOWNBUFF = SBF.strings.UNKNOWNBUFF or "Unknown Buff"
SBF.strings.BUFFERROR = SBF.strings.BUFFERROR or "SBF error: cannot tooltip this buff"

SBF.strings.ERRBUFF_EXTENT = SBF.strings.ERRBUFF_EXTENT or "Error getting extent for frame %d - frame does not exist"

SBF.strings.OLDOPTIONS = SBF.strings.OLDOPTIONS or "SBF Options is out of date"
SBF.strings.OPTIONSVERSION = SBF.strings.OPTIONSVERSION or "SBF Options version |cff00ff66%s|r does not match SBF version |cff00ff66%s|r"

SBF.strings.OF = SBF.strings.OF or "of"
SBF.strings.OFTHE = SBF.strings.OFTHE or "of the"
SBF.strings.NA = SBF.strings.NA or "N/A"

SBF.strings.NOTRACKING = SBF.strings.NOTRACKING or "Not Tracking"
SBF.strings.SPELL_COMBUSTION = SBF.strings.SPELL_COMBUSTION or "Combustion"
SBF.strings.SPELL_FR_AURA = SBF.strings.SPELL_FR_AURA or "Fire Resistance Aura"

SBF.strings.SLASHTHROTTLE = SBF.strings.SLASHTHROTTLE or "    |cff00ff66throttle|r - [|cff00aaff%.2f|r] Change the combat throttle value (0.05-1.00)"
SBF.strings.INVALIDTHROTTLE = SBF.strings.INVALIDTHROTTLE or "Throttle value must be between 0.05 and 1.00"
SBF.strings.THROTTLECHANGED = SBF.strings.THROTTLECHANGED or "Throttle value is now |cff00aaff%.2f|r"

SBF.strings.SENTRYTOTEM = SBF.strings.SENTRYTOTEM or "Sentry Totem"  -- Keeps sentry totem from being destroyed when you click it

SBF.strings.SLASHHEADER = SBF.strings.SLASHHEADER or "|cff00ff66Satrina Buff Frames|r version |cff00aaff%s|r"
SBF.strings.SLASHOPTIONS = SBF.strings.SLASHOPTIONS or {
  "    |cff00ff66options|r - Show SBF options",
  "    |cff00ff66hide|r - Force default buff frame to hide again",
  "    |cff00ff66fix|r - Try to fix the SBF settings for this character",
  "    |cff00ff66reset|r - Reset SBF settings for this character",
  "               (this will reload your UI automatically)",
}

SBF.strings.buffTotems = SBF.strings.buffTotems or {
  "Totem of Wrath",
  "Fire Resistance",
  "Flametongue",
  "Frost Resistance",
  "Grounding",
  "Nature Resistance",
  "Sentry",
  "Stoneskin",
  "Strength of Earth",
  "Wrath of Air",
  "Windfury",
  "Grace of Air", --?
  "Windwall", --?
  "Tranquil Air", --?
}

SBF.strings.sort = SBF.strings.sort or SBF.strings.sort or {
  "None",
  "Time Ascending",
  "Time Descending",
  "Name Ascending",
  "Name Descending",
  "Duration Ascending",
  "Duration Descending",
}

SBF.strings.sounds = SBF.strings.sounds or SBF.strings.sounds or {
  "Whoosh",
  "Clink",
  "Auction Bell",
  "Clunk",
  "Murloc!",
}

SBF.strings.castableExclude = SBF.strings.castableExclude or {
}

-- 3.1.25
SBF.strings.DISABLEDSBFO = SBF.strings.DISABLEDSBFO or "The SBFOptions addon is disabled.  Log out and enable it from the Addon menu at character select"
-- Temp enchants that have 30 minute durations
SBF.strings.thirtyMinuteEnchants = SBF.strings.thirtyMinuteEnchants or {
  "Rockbiter",
  "Windfury",
  "Frostbrand",
  "Flametongue",
  "Earthliving",
}
