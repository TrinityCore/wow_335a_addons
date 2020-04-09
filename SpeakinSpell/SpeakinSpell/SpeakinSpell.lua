
local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("SpeakinSpell.lua")


-------------------------------------------------------------------------------
-- GENERAL INITIALIZATION AND MAIN ENTRY POINTS
-------------------------------------------------------------------------------


--FrameName indicates the name of the frame that is open when you push the reset button
--FrameName is nil when this function is called from the command line
--TODOFUTURE: allow the FrameName to be specified on the command line, and pass that instead of nil
function SpeakinSpell:ResetToDefaults(FrameName)
	table.wipe( self:GetActiveEventTable() )
	
	--TODOLATER: prompt: are you sure you want to reset all settings?
	--TODOFUTURE: if the reset button is clicked in the GUI, prompt to reset only that frame or all options? (or cancel)
	
	-- stop networking
	self:Network_Disable()
	
	-- update/reset runtime data state
	self:InitRuntimeData()
	if self.IsGUILoaded then
		self:GUI_ResetState() --remove all event keys from the drop down lists.  Everything else about the GUI was reset by InitRuntimeData
	end
	
	-- reset the default templates to restore previously redundant content
	self:Templates_Release()
	
	-- copy defaults into current settings using class-specific defaults
	self:InitDefaultSavedData()
	
	-- if the options GUI is showing right now, we need to refresh it to make it show the new data
	if self.IsGUILoaded then
		self:GUI_RefreshAllFrames()
	end
		
	-- resume networking
	self:Network_Init()
	
	self:Print(L["Default settings restored"])
end




function SpeakinSpell:OnInitialize()
	local funcname = "OnInitialize"
	self:DebugMsg(funcname, "entry")

	-- called by the WoWAce framework during ADDON_LOADED
	-- which means saved variables have already been loaded... I think...
	-- it works fine for me to do the work of OnLoad here
	-- but a few users have periodically complained about their data becoming erased
	-- so I worried that I should switch from VARIABLES_LOADED to ADDON_LOADED
	-- and it does indeed seem risky to call InitRuntimeData here if the framework is
	-- calling this in response to ADDON_LOADED but I thought variables hadn't been loaded yet
	-- 3.3.3.02 changed to running OnLoad as in-line code that executes as this file gets loaded
	-- which is listed last in the TOC
end


function SpeakinSpell:OnLoad()
	local funcname = "OnLoad"
	self:DebugMsg(funcname, "entry")

    -- Called by in-line code at the end of this file
    -- when the addon is loaded
    -- Variables have not yet been loaded
    assert( not self.VariablesAreLoaded )
    assert( not self.OnLoadCompleted )

	-- load the event types to prepare for RegisterAddonEventType
	-- to support the localization website tool, we can't have nested tables in our Locale file
	-- so create the table structure here, while keeping the L[] table flat
	--self.EventTypes.AS_FILTERS		= self:CopyTable( L.EVENTTYPES.AS_FILTERS )
	--self.EventTypes.IN_SPELL_LIST	= self:CopyTable( L.EVENTTYPES.IN_SPELL_LIST )
	self:CreateEventTypeLists()
	
	self:InitRuntimeData()			-- initialize self.RuntimeData.Stuff\	
	self:RegisterAllEvents()		-- includes registering for ADDON_LOADED event -> OnVariablesLoaded
	self:RegisterChatCommands()		-- setup /ss stuff
	self:Templates_OnInitialize()	-- initialize Templates info for default speeches
	self:ClickHere_Init()			-- setup to support [Click Here] links in chat messages

	-- NOTE: the rest of the initialization does not occur until OnVariablesLoaded below
	self:DebugMsg(funcname, "done")
    self.OnLoadCompleted = true
end


-- after OnInitialize, the main initialization waits until the saved variables areloaded
function SpeakinSpell:OnVariablesLoaded()
	local funcname = "OnVariablesLoaded"
	self:DebugMsg(funcname, "starting")

	-- validate startup logic
	-- this is important to ensure that saved data doesn't get erased by startup initialization
	-- and catch it when it does (after WoW patches change timing of events)
    assert( self.OnLoadCompleted )
    assert( not self.VariablesAreLoaded )
	self.VariablesAreLoaded = true
	
	-- SpeakinSpellSavedData and ForAll will always exist
	-- they'll be empty if no saved data was actually loaded (fresh install or reset)
	
	if	SpeakinSpellSavedData.Version or		-- current test for existance of saved data for versions >= 3.2.2.17
		SpeakinSpellSavedData.EventTable or		-- old data location from before v3.2.2.17
		SpeakinSpellSavedData.SpellTable then	-- old name from v3.1.2.04 and earlier
		-- If the format of the saved data has changed due to upgrading to a newer version
		-- then fix the old saved data for compatibility - also may fix corrupted data, etc.
		self:ValidateAllSavedData()
	else
		if SpeakinSpellSavedDataForAll.Version then
			-- new character for an existing user
			-- (we have saved data For All, but not for This Toon)
			self:DebugMsg(funcname, "saved data does not exist, using defaults (for this toon only)")
			self:InitDefaultSavedData_NewToonOnly()
		else
			-- new user: load defaults
			-- (we don't have ANY saved data at all)
			self:DebugMsg(funcname, "saved data does not exist, using defaults (for whole account)")
			self:InitDefaultSavedData() --also calls ValidateAllSavedData
		end
	end	
	
	-- we won't be needing the templates anymore for loading default speeches
	self:Templates_Release() -- will be reloaded if the GUI is opened

	-- the channel table is a reverse lookup table for channel names, built from GlobalStrings + Locale-xxXX.lua
	-- this function uses FormatSubs, which needs RuntimeData to exist first - do InitRuntimeData before this
	-- FormatSubs also relies on saved variables to exist - so we actually need to defer this to OnVariablesLoaded
	-- The GUI needs this channel table, so it should also come before CreateGUI
	-- (though that's probably unnecessary as long as ChannelTable exists before the GUI is actually shown)
	self:CreateChannelTable()
	
	-- set up the Options GUI
	-- NOTE: we want to have the Saved Data before we do this
	self:MinimapButton_Create()
	
	-- Print welcome message
	self:ShowWelcomeMessages()
	
	-- trigger a Speech Event for loading
	local DetectedEventStub = {
		-- event descriptors
		name = L["SpeakinSpell Loaded"],
		type = "EVENT",
		-- event-specific data for substitutions
		caster = UnitName("player"),
		target = UnitName("player"),
	}
	self:OnSpeechEvent( DetectedEventStub ) 
	
	-- start network communications, if applicable
	self:Network_Init()
	
	-- start watching for rez events from LibResComm 
	-- this might immediately start wanting to use the speeches
	self:Rez_Init()

	-- Done
	self:DebugMsg(funcname, "done")
end


function SpeakinSpell:OnEnable()
	-- Called when the addon is enabled
	-- self:RegisterAllEvents() -- did this OnInitialize
end


function SpeakinSpell:OnDisable()
    -- Called when the addon is disabled
	-- we don't need to do anything here
end



function SpeakinSpell:CreateEventTypeLists()
	-- load the event types to prepare for RegisterAddonEventType
	-- to support the localization website tool, we can't have nested tables in our Locale file
	-- so create the table structure here, while keeping the L[] table flat
	--self.EventTypes.IN_SPELL_LIST	= self:CopyTable( L.EVENTTYPES.IN_SPELL_LIST )
	--self.EventTypes.AS_FILTERS		= self:CopyTable( L.EVENTTYPES.AS_FILTERS )
	-- the "TEST" type gets special handling for substitutions because it doesn't show up in the GUI lists 
	self.EventTypes.IN_SPELL_LIST = {
		["EVENT"]								= L["Misc. Event: "],-- ..eventname
		["NPC"]									= L["NPC: "], --enter/exit barber chair
		["REZ"]									= L["Resurrection: "], --enter/exit barber chair
		["COMMRX"]								= L["Data Sharing Event (Rx): "],
		["COMMTX"]								= L["Data Sharing Event (Tx): "],
		["CHAT"]								= L["Chat Event: "], --guild member says 'ding'
		["COMBAT"]								= L["Combat Event: "], -- .. Enter/Exit combat
		["ACHIEVEMENT"]							= L["Achievement Earned by "], -- .. eventname = "me" or "someone nearby" or "a guild member"
		["MACRO"]								= L["When I Type: /ss "],-- ..input ==> "User Macro Event: /ss macro something"
		["SPELL_AURA_APPLIED_BUFF"]				= L["When I buff myself with: "],--..spellname
		["SPELL_AURA_APPLIED_DEBUFF"]			= L["When I debuff myself with: "],--..spellname
		["SPELL_AURA_APPLIED_BUFF_FOREIGN"]		= L["When someone else buffs me with: "],--..spellname
		["SPELL_AURA_APPLIED_DEBUFF_FOREIGN"]	= L["When someone else debuffs me with: "],--..spellname
		["UNIT_SPELLCAST_CHANNEL_START"]		= L["When I Start Channeling: "],--..spellname
		["UNIT_SPELLCAST_CHANNEL_STOP"]			= L["When I Stop Channeling: "],--..spellname
		["UNIT_SPELLCAST_SENT"]					= L["When I Start Casting: "],--..spellname (rank)
		["UNIT_SPELLCAST_FAILED"]				= L["When I Fail to Cast: "],--..spellname
		["UNIT_SPELLCAST_INTERRUPTED"]			= L["When I'm interrupted while casting: "],--..spellname
		["UNIT_SPELLCAST_STOP"]					= L["When I Stop Casting: "],--..spellname
		["UNIT_SPELLCAST_SUCCEEDED"]			= L["When I Successfully Cast: "],--..spellname
		--NOTE: UNIT_SPELLCAST_SUCCEEDED appears to be the only pet event that actually occurs in WoW 3.3.5
--		["PETUNIT_SPELLCAST_CHANNEL_START"]		= L["When my Pet Starts Channeling: "],--..spellname
--		["PETUNIT_SPELLCAST_CHANNEL_STOP"]		= L["When my Pet Stops Channeling: "],--..spellname
--		["PETUNIT_SPELLCAST_SENT"]				= L["When my Pet Starts Casting: "],--..spellname (rank)
--		["PETUNIT_SPELLCAST_FAILED"]			= L["When my Pet Fails to Cast: "],--..spellname
--		["PETUNIT_SPELLCAST_INTERRUPTED"]		= L["When my Pet is interrupted while casting: "],--..spellname
--		["PETUNIT_SPELLCAST_STOP"]				= L["When my Pet Stops Casting: "],--..spellname
		["PETUNIT_SPELLCAST_SUCCEEDED"]			= L["When my Pet Successfully Cast: "],--..spellname
	}

	self.EventTypes.AS_FILTERS = {
		["*ALL"]								= L["_ Show All Types of Events _"],
		["EVENT"]								= L["Misc. Events"],
		["NPC"]									= L["Interaction with NPCs"], --enter/exit barber chair
		["REZ"]									= L["Resurrection Events (LibResComm)"], --enter/exit barber chair
		["COMMRX"]								= L["Data Sharing Events (Received)"],
		["COMMTX"]								= L["Data Sharing Events (Sent)"],
		["CHAT"]								= L["Chat Events"], --guild member says 'ding'
		["COMBAT"]								= L["Combat Events"], -- .. Enter/Exit combat
		["ACHIEVEMENT"]							= ACHIEVEMENTS, -- .. eventname = "me" or "someone nearby" or "a guild member"
		["MACRO"]								= L["/ss macro things you type"],
		["SPELL_AURA_APPLIED_BUFF"]				= L["Self Buffs (includes procs)"],
		["SPELL_AURA_APPLIED_DEBUFF"]			= L["Self Debuffs"],
		["SPELL_AURA_APPLIED_BUFF_FOREIGN"]		= L["Buffs from Others (includes totems)"],--..spellname
		["SPELL_AURA_APPLIED_DEBUFF_FOREIGN"]	= L["Debuffs from Others"],--..spellname
		["UNIT_SPELLCAST_CHANNEL_START"]		= L["Channeled Spells Start"],--..spellname
		["UNIT_SPELLCAST_CHANNEL_STOP"]			= L["Channeled Spells Stop"],--..spellname
		["UNIT_SPELLCAST_SENT"]					= L["Spells, Abilities, and Items (Start Casting)"],
		["UNIT_SPELLCAST_FAILED"]				= L["Spells, Abilities, and Items (Failed)"],--..spellname
		["UNIT_SPELLCAST_INTERRUPTED"]			= L["Spells, Abilities, and Items (Interrupted)"],--..spellname
		["UNIT_SPELLCAST_STOP"]					= L["Spells, Abilities, and Items (Stop Casting)"],--..spellname
		["UNIT_SPELLCAST_SUCCEEDED"]			= L["Spells, Abilities, and Items (Successful Cast)"],--..spellname
		--NOTE: UNIT_SPELLCAST_SUCCEEDED appears to be the only pet event that actually occurs in WoW 3.3.5
--		["PETUNIT_SPELLCAST_CHANNEL_START"]		= L["Pet's Channeled Spells Start"],--..spellname
--		["PETUNIT_SPELLCAST_CHANNEL_STOP"]		= L["Pet's Channeled Spells Stop"],--..spellname
--		["PETUNIT_SPELLCAST_SENT"]				= L["Pet's Abilities (Start Casting)"],
--		["PETUNIT_SPELLCAST_FAILED"]			= L["Pet's Abilities (Failed)"],--..spellname
--		["PETUNIT_SPELLCAST_INTERRUPTED"]		= L["Pet's Abilities (Interrupted)"],--..spellname
--		["PETUNIT_SPELLCAST_STOP"]				= L["Pet's Abilities (Stop Casting)"],--..spellname
		["PETUNIT_SPELLCAST_SUCCEEDED"]			= L["Pet's Abilities (Successful Cast)"],--..spellname
	}
end


--[[
-- [buildlocales.py copy]
-- The names of chat channels use internal channel ID names 
-- instead of the English text that is normally used in a one-to-one match

L["Silent"]						= "Silent" -- this means that messages are disabled
L["SPEAKINSPELL CHANNEL"]		= "Self-Chat (SpeakinSpell:)"
L["SELF RAID WARNING CHANNEL"]	= "Self-Only Raid Warning"
L["RAID_BOSS_WHISPER"]			= "Boss Whisper"
L["MYSTERIOUS VOICE"]			= "[Mysterious Voice] whispers:"
L["COMM TRAFFIC RX"]			= "Comm Traffic Received (Rx)"
L["COMM TRAFFIC TX"]			= "Comm Traffic Sent (Tx)"

-- The rest of the channel lookup table is built from GlobalStrings.lua
-- using the following format
L["<text> (<slash>)"] = "<text> (<slash>)" --example: "Say (/s)" or "Guild (/g)"

-- [buildlocales.py end of copy]
--]]

-- NOT copied by BuildLocales.py:
-- The rest of these are pulled from GlobalStrings.lua, using the function below
--L["SAY"]			= "Say (/s)"
--L["PARTY"]			= "Party (/p)"
--L["RAID"]			= "Raid (/ra)"
--L["BATTLEGROUND"]	= "Battleground (/bg)"
--L["EMOTE"]			= "Emote (/em)"
--L["YELL"]			= "Yell (/y)"
--L["RAID_WARNING"]	= "Raid Warning (/rw)"
--L["GUILD"]			= "Guild (/g)"

function SpeakinSpell:CreateChannelTable()
	-- start with proprietary channels
	self.ChannelTable = {
		[L["SPEAKINSPELL CHANNEL"]]			= "SPEAKINSPELL CHANNEL",
		[L["SELF RAID WARNING CHANNEL"]]	= "SELF RAID WARNING CHANNEL",
		[L["RAID_BOSS_WHISPER"]]			= "RAID_BOSS_WHISPER",
		[L["MYSTERIOUS VOICE"]]				= "MYSTERIOUS VOICE",
		[L["COMM TRAFFIC RX"]]				= "COMM TRAFFIC RX",
		[L["COMM TRAFFIC TX"]]				= "COMM TRAFFIC TX",
	}

	-- create L[] table entries for channel names from GlobalStrings.lua
	local GlobalStrings = {
		{
			key = "SAY",
			text = SAY,
			slash = SLASH_SAY1,
		},
		{
			key = "PARTY",
			text = PARTY,
			slash = SLASH_PARTY1,
		},
		{
			key = "RAID",
			text = RAID,
			slash = SLASH_RAID3,
		},
		{
			key = "EMOTE",
			text = EMOTE,
			slash = SLASH_EMOTE2,
		},
		{
			key = "BATTLEGROUND",
			text = BATTLEGROUND,
			slash = SLASH_BATTLEGROUND,
		},
		{
			key = "RAID_WARNING",
			text = RAID_WARNING,
			slash = SLASH_RAID_WARNING1,
		},
		{
			key = "GUILD",
			text = GUILD,
			slash = SLASH_GUILD1,
		},
	}
	
	for i,subs in pairs(GlobalStrings) do
		--L["SAY"] = "Say (/s)"
		L[subs.key] = self:FormatSubs(L["<text> (<slash>)"], subs) --[buildlocales.py No Warning] for non-standard usage of L[] in L[subs.key]
		--ChannelTable[ L["SAY"] ] = "SAY"
		--ChannelTable["Say (/s)"] -> "SAY"
		self.ChannelTable[L[subs.key]] = subs.key --[buildlocales.py No Warning] for non-standard usage of L[] in L[subs.key]
	end
end


-- for addons to create new event types
function SpeakinSpell:RegisterAddonEventType( TYPE, SomethingEvents, AsPrefix )
	self.EventTypes.AS_FILTERS		[ TYPE ] = SomethingEvents	-- "Something Events"
	self.EventTypes.IN_SPELL_LIST	[ TYPE ] = AsPrefix			-- "Something Event: "
end


function SpeakinSpell:ToggleSetupGuides()
	self:EnableSetupGuides( not SpeakinSpellSavedData.ShowSetupGuides, false )
end

function SpeakinSpell:EnableSetupGuides( value, IsInit )
	SpeakinSpellSavedData.ShowSetupGuides = value
	if SpeakinSpellSavedData.ShowSetupGuides then
		local subs = {
			clickhere = self:MakeClickHereLink(L["[/ss guides]"], "SpeakinSpell:ToggleSetupGuides()"),
		}
		self:Print( self:FormatSubs(L["Setup guides are enabled. <clickhere> to disable them"], subs))
		subs.clickhere = self:MakeClickHereLink(L["[/ss recent]"], "SpeakinSpell:ReportRecentEvents()")
		self:Print( self:FormatSubs(L["<clickhere> to review recent events and speeches"], subs))
	elseif (not IsInit) then
		local subs = {
			clickhere = self:MakeClickHereLink(L["[/ss guides]"], "SpeakinSpell:ToggleSetupGuides()"),
		}
		self:Print( self:FormatSubs(L["Setup guides have been disabled. <clickhere> to enable them"], subs))
	end
end


function SpeakinSpell:ShowWelcomeMessages()
	-- Welcome to SpeakinSpell v3.3.0.07 [Click Here] to edit options
	if SpeakinSpellSavedData.ShowVersionAtLogin then
		local subs = {
			version = self.CURRENT_VERSION,
			clickhere = self:MakeClickHereLink(L["[Click Here]"], "SpeakinSpell:ShowOptions()"),
		}
		self:Print( self:FormatSubs(L["Welcome to SpeakinSpell v<version> <clickhere> to edit options"], subs) )
		-- Automatic event detection is On/Off
		if SpeakinSpellSavedData.EnableAllMessages then
			self:Print( L["Automatic event detection and announcements are enabled."] )
		else
			self:Print( L["Automatic event detection and announcements are disabled."] )
			self:Print( L["However, \"/ss macro something\" will still trigger announcements if run manually"] )
		end
	end
	-- Setup guides are enabled [Click Here] to disable them
	SpeakinSpell:EnableSetupGuides( SpeakinSpellSavedData.ShowSetupGuides, true )
end


function SpeakinSpell:ReportRecentEvents()
	self:Print( L["Recent Events Detected..."] )
	for i=SpeakinSpell.MAX.RECENT_HISTORY,1,-1 do
		local de = self.RuntimeData.Recent.Events[i]
		if de then
			self:DoReportDetectedSpeechEvent( de, true, false )
		end
	end
	self:Print( L["Recent Speech Announcements..."] )
	for i=SpeakinSpell.MAX.RECENT_HISTORY,1,-1 do
		local item = self.RuntimeData.Recent.Speeches[i]
		if item then
			self:DoReportDetectedSpeechEvent( item.de, true, false )
			self:Print( item.msg )
		end
	end
end


SpeakinSpell:OnLoad() -- see comments in OnInitialize

