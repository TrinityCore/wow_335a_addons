-- Author      : RisM
-- Create Date : 6/28/2009 3:38:58 PM

-- This loader.lua file is loaded first, and defines default values, sets up critical declarations
-- SpeakinSpell.lua is loaded last, and runs its OnLoad function after every file has loaded

-------------------------------------------------------------------------------
-- Create Addon Object
-------------------------------------------------------------------------------

SpeakinSpell = LibStub("AceAddon-3.0"):NewAddon("SpeakinSpell", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")

-------------------------------------------------------------------------------
-- CURRENT VERSION
-------------------------------------------------------------------------------

SpeakinSpell.CURRENT_VERSION = GetAddOnMetadata("SpeakinSpell", "version") 

-------------------------------------------------------------------------------
-- DEBUG vs. RETAIL
-------------------------------------------------------------------------------
-- When enabling debug modes, these flags should be overriden in the optional file, user.lua
-- to avoid accidentally committing the code to SVN and releasing it to the public
-- with debug modes enabled (a mistake I have made in the past)

-- general debugging, basically forces debug messages on
-- i.e. if you can't get to the 
SpeakinSpell.DEBUG_MODE = false

-- network debugging
-- mostly controls whether to accept messages from yourself
SpeakinSpell.DEBUG_NETWORK = false


-------------------------------------------------------------------------------
-- DEVELOPER FLAGS
-------------------------------------------------------------------------------
-- These flags are override by the optional file developer.lua
-- which is included in SVN, but not included in the release package zip
-- in order to distinguish developers (who checkout from SVN) from end-users (who get the zip file from curse)

-- The 'DEVELOPER_MODE' flag is used to silence new version alerts for unreleased versions
-- and may be extended to more purposes in the future
SpeakinSpell.DEVELOPER_MODE = false


-------------------------------------------------------------------------------
-- CONSTANTS
-------------------------------------------------------------------------------

SpeakinSpell.URL = "Search www.curse.com for \"SpeakinSpell\""

SpeakinSpell.ALL_URLs = [[
http://wow.curse.com/downloads/wow-addons/details/speakinspell.aspx
http://www.wowace.com/projects/speakinspell/
http://www.wowace.com/addons/speakinspell/tickets/
]]

SpeakinSpell.MAX = {
	MESSAGES_PER_SPELL		= 100, -- do not ever make this number smaller, but we can always make it bigger
	TEXTS_PER_RANDOM_SUB	= 100, -- also do not shrink
	RECENT_HISTORY			= 5,   -- /ss recent
}


-------------------------------------------------------------------------------
-- COLORS
-------------------------------------------------------------------------------
-- Some colors are hard-coded
-- Some are loaded at runtime from other user-data


SpeakinSpell.Colors = {	
	-- TODOFUTURE: (maybe never?) make this color configurable, it's used for the SpeakinSpell system message color
	--		since Print is in the loader, saved data is not available yet, makes it tricky on making this color configurable
	SPEAKINSPELL	= "|cff33ff99",
	
	-- minimap button ON/OFF colors
	Minimap = {
		ON			= "|cff00ff00", -- green
		OFF			= "|cffff0000", -- red
		Click		= "|cffffff00", -- highlights text around "Click" and "Right-Click" in the tooltip
	},
	-- Import New Data Use/Delete button colors
	ImportNewData = {
		USE			= "|cff00ff00",
		GREY		= "|cff555555",
		RED			= "|cffff0000",
	},
}


-------------------------------------------------------------------------------
-- DEFAULTS
-------------------------------------------------------------------------------


SpeakinSpell.DEFAULTS = {
	
	AD_CHANNELS = { -- for /ss ad
		Arena		= "PARTY",
		BG			= "SAY",
		WG			= "SAY",
		RaidLeader	= "RAID",
		RaidOfficer	= "RAID",
		Raid		= "RAID",
		Party		= "PARTY",
		PartyLeader	= "PARTY",
		Solo		= "SAY",
	},
	MOUNT_CHANNELS = { -- for "/ss macro mount" and related "spells"
		--Arena		= "SAY",
		--BG		= "SAY",
		--WG		= "SAY",
		RaidLeader	= "SAY",
		RaidOfficer	= "SAY",
		Raid		= "SAY",
		Party		= "SAY",
		PartyLeader	= "SAY",
		Solo		= "SAY",
	},

	-- Saved Data Format and Defaults
	SpeakinSpellSavedData = {
		-- Data Format Version/Schema
		--Version = SpeakinSpell.CURRENT_VERSION, -- leave undefined until validated at least once at creation time
		
		-- General Settings
		ShowSetupGuides = false,
		ShowWhyNot = false,
		ShowDebugMessages = false,
		EnableAllMessages = true,
		ShowAllRanks = false,
		ShowMoreThanAHundred = false,
		ShowUsedHooks = false,
		ShowMinimapButton = true,
		ShowVersionAtLogin = true,
		ShowImportProgress = false,
		AlwaysUseCommon = false, -- override event-specific languages and speak in "Common" or "Orcish"
		GlobalCooldown = 10,

		MinimapIcon = {
			hide = false, --LibDBIcon's internal state data mirrors our own option ShowMinimapButton listed above
			minimapPos = 220,
			radius = 80,
		},
		
		-- user-configurable colors
		Colors = {
			SearchMatch		= "|cffff2222", -- highlights the search match in drop-down lists for event selects, etc
			SelectedItem	= "|cff00ff00", -- as the heading or caption of a section, showing the name of the selected event
			Headings		= "|cff33ff99",
			ClickHere		= "|cffffc000", -- color of [Click Here] links

			-- Colors for SS-Created channels
			-- will be copied into SpeakinSpell.Colors as |c codes
			Channels = {
				["SPEAKINSPELL CHANNEL"] = { -- SS System Messages 33-ff-99
					r = (51/255),
					g = (255/255),
					b = (153/255),
					a = 1,
				}, -- SS System messages
				["SELF RAID WARNING CHANNEL"] = { -- this is like the raid leader color, or DBM self-raid warnings
					r = (255/255), --ff
					g = (219/255), --db
					b = (173/255), --ad
					a = 1,
				}, -- Self-Only Raid Warnings
				["MYSTERIOUS VOICE"] = {
					r = (255/255), --ff
					g = (219/255), --db
					b = (173/255), --ad
					a = 1,
				}, -- Mysterious Voice
				["COMM TRAFFIC TX"] = {
					["a"] = 1,
					["b"] = 0,
					["g"] = 0.3843137254901961,
					["r"] = 0.6078431372549019,
				},
				["COMM TRAFFIC RX"] = {
					["a"] = 1,
					["b"] = 0,
					["g"] = 0.5137254901960784,
					["r"] = 0.8235294117647058,
				},
			},
		},
		
		-- Last Page Viewed
		-- page opened with "/ss toggle" or minimap button
		LastPageViewed = {
			ObjectName = "General",
			InterfacePanel = "SpeakinSpell",
		},
	},
	
	SpeakinSpellSavedDataForAll = {
		-- Data Format Version/Schema
		--Version = SpeakinSpell.CURRENT_VERSION, -- leave undefined until validated at least once at creation time
		
		-- user options
		ShowFrequencyGroup = true,
		ShowReadOnlySpeeches = true,
		UseMultiLine = true,
		RandomSubs = {},
		
		-- character-specific settings
		Toons = {}, -- Toons[realm][toon].EventTable, will still list realms and toons when event tables are shared in AllToonsEventTable
		AllToonsShareSpeeches = true,
		--AllToonsEventTable = {}, --can be nil when unused -- I'm worried that declaring it here is causing it to be erased - saw the error twice but now can't repro, but this was the only relevant change
		
		-- Data Tables
		NewEventsDetected = {},
		SpellIdCache = {},
		
		-- importable content from other users
		Networking = {
			-- global toggle
			EnableNetwork = true,
			-- diagnostic optioins
			ShowCommTraffic = false,
			ShowTransferProgress = false,
			ShowStats = false,
			-- auto-sync options
			AutoSyncOnLogin = false,
			AutoSyncOnJoin = false,
			-- sharing options
			Share = {
				ET = true,
				NEW = true,
				RS = true,
			},
			Collect = {
				ET = true,
				NEW = true,
				RS = true,
			},
			-- collected data
			CollectedEventTables = {},
			CollectedRandomSubs = {},
		},
	},
	
	DetectedEventStub = {
		-- all stubs are expected to have at least a name and type, which MUST exist
		name = "UNKNOWN",
		type = "EVENT",
		rank = "",
		
		-- the rest is optional, including...
		--spellid = 1234,
		--target = "Stonarius",
		--caster = "Stonarius",
	},
	
	DetectedEvent = {
		-- everything from a DetectedEventStub, plus...
		
		-- caster/target info is set by the original stub or CreateDetectedEvent
		--caster = "Stonarius",
		--target = "Stonarius",
		
		-- table keys -- generated in Validate_DetectedEvent / MakeEventTableKeys
		--key = "TABLEKEY",
		--rankedkey = "TABLEKEYRANK",
		--ranklesskey = "TABLEKEY",
	},
	
	-- Speech Events
	EventTableEntry = {
		-- General settings for this event
		DisableAnnouncements = false,
		
		-- The speech list
		Messages = {}, -- populated with default sample speeches from DEFAULT_SPEECHES in template.lua OnInitialize
		ReadOnly = {}, -- ReadOnly[string] = true or nil
		
		-- Channel options / Whisper
		WhisperTarget = false,
		Channels = { -- for creating new spells
			Solo		= "SPEAKINSPELL CHANNEL",
			Party		= nil, --"SAY",
			Raid		= nil,
			PartyLeader	= nil, --"SAY",
			RaidLeader	= nil, --"SAY",
			RaidOfficer	= nil, --"SAY",
			BG			= nil,
			Arena		= nil,
			WG			= nil,
		},
		--NOTE: GetDefaultLanguage("player") doesn't work during loader, or OnInitialize, or OnVariablesLoaded
		RPLanguage = nil, -- "Common", "Dwarvish", etc, may also be L["Random"]
		RPLanguageRandomChance = 0.5, --50/50 chance to use racial language, only if RPLanguage == L["Random"]

		-- Spam Reduction options
		Frequency = 1.00,
		Cooldown  = 0,
		ExpandMacros = false, --only really desired on the nested macros, not the 100 different events that call it out
	},
	
	Templates = {}, -- Working copy of DEFAULT_SPEECHES.Templates
	
	RuntimeData = {
		hasAggro = false,
		AnnouncementHistory = {}, -- [eventkey] = {LastMessage, LastTime, LastTarget}
		AnnouncedThisCombat = {}, -- [eventkey] = true, for Limit Once Per Combat - this table is destroyed/reset on enter/exit combat
		LastRandomSub = {}, -- [randomkey] = "random value" last used for the <randomkey> substitution
		Recent = { 
			Speeches = {},
			Events = {},
		},
		Networking = {
			NewestVersion = SpeakinSpell.CURRENT_VERSION,
		},
		SetupGuides = {
		},
		OptionsGUIStates = {
			SelectedEventTypeFilter = "*ALL",
			SelectedEventTextFilter = "",
			MessageSettings = {
				SelectedEventKey = nil,
				FilterChanged = true,
				ShowChannelsGroup = true,
				--ShowSpeechesGroup = true,
			},
			CreateNew = {
				SelectedEventKey = nil,
				FilterChanged = true,
			},
			RandomSubs = {
				SelectedSub = nil,
			},
			ImportGUI = {
				SelectedTemplate = nil,
				SelectedEvent = nil,
				SelectedRandomSub = nil,
			},
		},
	},
}


-------------------------------------------------------------------------------
-- DECLARE OPTIONS GUI TABLE
-------------------------------------------------------------------------------
SpeakinSpell.OptionsGUI = {
	type = "group",
	args = {},
}

-------------------------------------------------------------------------------
-- EVENT TYPES
-------------------------------------------------------------------------------

-- Event Types are not in RuntimeData to prevent resetting them on /ss reset
-- this is a copy of L.EVENTTYPES, plus additional RegisterAddonEventType types
SpeakinSpell.EventTypes = {
	IN_SPELL_LIST = {},
	AS_FILTERS = {},
}

-------------------------------------------------------------------------------
-- SAVED DATA DECLARATION
-------------------------------------------------------------------------------

-- we must declare the parent tables
-- if saved data exists, these tables will become populated, 
-- else we'll see that these are empty and fill in defaults
SpeakinSpellSavedData = {} -- character specific data
SpeakinSpellSavedDataForAll = {} -- account-wide data

-------------------------------------------------------------------------------
-- BASIC PRINT FUNCTIONS
-------------------------------------------------------------------------------


function SpeakinSpell:Print(message)
	-- Overriding AceConsole-3.0:Print to use localized addon name instead of tostring(self)
	--local tag = tostring(SpeakinSpell.Colors.SPEAKINSPELL).."SpeakinSpell|r: "
	local tag = "|HSSLink<SpeakinSpell:ShowOptions_Toggle()>|h" .. tostring(SpeakinSpell.Colors.SPEAKINSPELL) .. "[SpeakinSpell]|r|h|h "
	local text = tag .. tostring(message)
	DEFAULT_CHAT_FRAME:AddMessage( text )
end


function SpeakinSpell:PrintLoading(filename)
	--self:Print("loaded "..filename) -- used for debugging purposes
end

SpeakinSpell:PrintLoading("loader.lua")
