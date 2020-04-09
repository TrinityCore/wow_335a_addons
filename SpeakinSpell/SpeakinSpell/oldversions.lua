-- Author      : RisM
-- Create Date : 6/28/2009 3:59:16 PM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("oldversions.lua")


-------------------------------------------------------------------------------
-- Localization Archive (for buildlocales.py)
-------------------------------------------------------------------------------

--[[
-- [buildlocales.py copy]

-- Localization of this file has to be careful because some localized strings
-- were used as functional table keys and may be required to match old data
--
-- If the L[] value is in source data, then it must be preserved forever in
--		order to be able to find matching data in old saved data
-- If the L[] value is a destination value, then it may use the newest value
--		which can freely be changed in order to perfect the translation
--		or change the way the UI looks
-- If the L[] value is not used in data at all because it is a status message
--		then it may be changed freely
-- Old transtions need to be saved following this naming convention
-- For locale files that didn't exist yet in these older versions, use English

-- DO NOT CHANGE! -- the value of L["/macro"] in release 3.1.2.05
L["3.1.2.05 /macro"] = "macro"

-- DO NOT CHANGE! -- the <newline> substitution key word from 3.2.2.02
L["3.2.2.02 <newline>"] = "<newline>"

-- DO NOT CHANGE! -- display names for some event hooks in 3.2.2.14
L["3.2.2.14 Entering Combat"] = "Entering Combat"
L["3.2.2.14 Exiting Combat"] = "Exiting Combat"
L["3.2.2.14 Whispered While In-Combat"] = "Whispered While In-Combat"

-- REFERENCED OUTSIDE THIS FILE (authorized list) -- 
-- These are expected overlaps with other code files
-- The following warnings will be auto-detected by the script
-- The dominant translations used elsewhere in the UI may be used, and freely changed
--L["SpeakinSpell Loaded"] already defined under:SpeakinSpell.lua
--L["<newline>"] already defined under:gui/currentmessages.lua

-- OK TO CHANGE --
-- the remaining definitions below are auto-generated
-- they may be changed freely to provide the best possible translation

-- [buildlocales.py end of copy]
--]]


-------------------------------------------------------------------------------
-- UPDATE OLD SAVED DATA
-------------------------------------------------------------------------------


--[[ Archived Code Refence from 3.1.2.03

SpeakinSpell:ConvertOldSpellTableToNewEventTable()

-----------------------------------------------------
-- OLD FORMAT: 3.1.2.03
local spellnamekey = name
if rank then
	spellnamekey = name.."("..rank..")"
end
-- rank can also be "_ event: Login" or "_ macro something"

SpeakinSpellSavedData.EventTable[spellnamekey] = {
	-- default options
	Channels = self:CopyTable(DEFAULT_CHANNEL_RULES),
	WhisperTarget = false,
	Frequency = 1.00, --default 100%
	Messages = self:CopyTable(DEFAULT_SPEECHES.NEWSPELL),
}

-----------------------------------------------------------------------------------
-- NEW FORMAT: 3.1.2.05
-- DetectedEvent table has been added
-- key has changed
-- new key format is name..rank..type
-----------------------------------------------------------------------------------


SpeakinSpellSavedData.EventTable[de.key] = {
	-- event information
	DetectedEvent = {
		key			= de.key,
		name		= de.name,
		rank		= de.rank,
		type		= de.type,
		--DisplayName = de.DisplayName, -- no longer stored in data as of 3.2.2.02
		--SpellLink	= de.SpellLink, --no longer stored in data as of 3.2.0.08
		-- caster	= de.caster -- not stored in event table
		-- target	= de.target -- not stored in event table
		-- pet		= de.pet    -- not stored in event table
	},
	-- default options
	Channels = self:CopyTable(DEFAULT_CHANNEL_RULES),
	WhisperTarget = false,
	Frequency = 1.00, --default 100%
	Cooldown = 0,
	Messages = self:CopyTable(DEFAULT_SPEECHES.NEWSPELL),
}
--]]

-- oldkey is a v3.1.2.03 SpellTable key
-- returns a new DetectedEventStub object for 3.1.2.05
function SpeakinSpell:FixOld_31205_CreateDEStub(oldkey)

	local stub = {
		name = "",
		rank = "",
		type = "", --unknown
		-- in 3.1.2.03, the only detected events were self cast on player
		-- or equivalent for as much as we cared at the time.
		caster = UnitName("player"),
		target = UnitName("player"),
	}
	
	-- check for macros using the 3.1.2.03 method of key names
	if self:StartsWith(oldkey, "_ macro") or self:StartsWith(oldkey, "_ "..L["3.1.2.05 /macro"]) then
		--remove leading "_ " from the name
		stub.name = string.sub(oldkey, 3)
		stub.rank = ""
		stub.type = "MACRO"
		return stub
	end
	
	-- check for the only event that was supported in 3.1.2.03
	if oldkey == "_ event: Login" then
		stub.name = L["SpeakinSpell Loaded"] --[buildlocales.py No Warning] OK to use the latest available translation here
		stub.rank = ""
		stub.type = "EVENT"
		return stub
	end
	
	-- it must be either a UNIT_SPELLCAST_SENT or a SPELL_AURA_APPLIED_BUFF
	-- let's take a closer look... 
	
	-- GetSpellInfo
	local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(oldkey)

	-- check whether they old key specified the rank or not
	local oldkeyrank = string.match(oldkey, "%b()")
	
	-- if GetSpellInfo returns data, then it's a real spell, which will mean UNIT_SPELLCAST_SENT
	if name then
		stub.type = "UNIT_SPELLCAST_SENT"
		stub.name = name
		if oldkeyrank and rank then
			stub.rank = rank
		else -- use unspecified rank
			stub.rank = ""
		end
		return stub
	end

	-- else, do some manual parsing and see what we can come up with
	
	-- parse the old key name for the name and rank
	stub.name = oldkey
	stub.rank = string.match(oldkey, "%b()")
	
	if not stub.rank then
		stub.rank = ""
	end
	
	if stub.rank ~= "" then
		stub.name = string.sub(oldkey, 1, -2 - string.len(stub.rank) ) -- remove rank from name
		stub.rank = string.sub(stub.rank, 2, -2) --remove wrapping parens
	end
	-- else the name is the full key, already set up above
	
	stub.name = self:TitleCase(stub.name)
	stub.rank = self:TitleCase(stub.rank)
	
	-- buffs received have no rank
	-- if this has rank, it's definitely not a buff
	if stub.rank ~= "" then
		stub.type = "UNIT_SPELLCAST_SENT"
		return stub
	end
	
--	self:Print("---------")
--	self:Print("GetSpellInfo - assumed buff")
--	self:Print("name:"..tostring(name))
--	self:Print("rank:"..tostring(rank))
--	self:Print("icon:"..tostring(icon))
--	self:Print("cost:"..tostring(cost))
--	self:Print("isFunnel:"..tostring(isFunnel))
--	self:Print("powerType:"..tostring(powerType))
--	self:Print("castTime:"..tostring(castTime))
--	self:Print("minRange:"..tostring(minRange))
--	self:Print("maxRange:"..tostring(maxRange))
--	self:Print("---------")

	-- can't tell for sure, so use both
	stub.type = "BOTH"
	
	return stub
end



function SpeakinSpell:FixOld_31205_CreateDetectedEvent( DetectedEventStub )

	local de = self:CopyTable(DetectedEventStub)
	
	-- SpellLink --no longer stored in data as of 3.2.0.08 - safe to remove from legacy support
	-- create a spell link, if possible
	-- the stub will set SpellLink = true if the event is a spell
	-- else will we make a fake one
--	if de.SpellLink then
--		de.SpellLink,_ = GetSpellLink(de.name, de.rank)
--	end
	-- NOTE: some aura gains are not linkable, notably "Refreshment" from "Drink"
	--		in that case, GetSpellLink will return NULL
--	if not de.SpellLink then
--		de.SpellLink = "["..de.name.."]"
--	end
	
	--[[ don't need this for importing saved data
	
	-- validate the target - get a backup target from selection, focus, or assumed self-cast
	if not de.target or de.target == "" or de.target == "Unknown" then
		de.target = self:GetDefaultTarget(true)
	end
	-- END SpellLink --no longer stored in data as of 3.2.0.08

	-- fetch additional target information
	de.targetclass = UnitClass(de.target)
	de.targetrace = UnitRace(de.target)

	--setup <pet> (3.2.0.06 no longer created here)
	de.pet = UnitName("pet")
	--]]
	
	-- create a display name for this event
	-- no longer stored in event table as of 32202
--	if de.rank ~= "" then
--		de.DisplayName = L.EVENTTYPES.IN_SPELL_LIST[de.type]..de.name.." ("..de.rank..")" 
--	else
--		de.DisplayName = L.EVENTTYPES.IN_SPELL_LIST[de.type]..de.name
--	end
	
	-- create a unique key for this event
	de.key = tostring(de.name)..tostring(de.rank)..tostring(de.type) --DO NOT CHANGE 3.1.2.05 format is intentional
	
	--[[ don't need this for importing saved data
	
	-- check for a EventTableEntry for this specific rank
	de.EventTableEntry = SpeakinSpellSavedData.EventTable[ de.key ]
	
	-- if that wasn't found, check for a rankless entry
	if not de.EventTableEntry then
		local ranklesskey = de.name..de.type
		de.EventTableEntry = SpeakinSpellSavedData.EventTable[ de.key ]
		-- if that was found, then update the key for future reference
		if de.EventTableEntry then
			de.key = ranklesskey
		end
	end
	--]]
	
	return de
end


function SpeakinSpell:FixOld_31205_CreateEventTableEntry(oldkey, OldSpellTableEntry, de)
	SpeakinSpellSavedData.EventTable[de.key] = {
		-- event information
		DetectedEvent = {
			key			= de.key,
			name		= de.name,
			rank		= de.rank,
			type		= de.type,
			--DisplayName = de.DisplayName, -- no longer stored in event table as of 32202
			--SpellLink	= de.SpellLink, --no longer stored in event table as of 32008
			-- caster	= de.caster -- not stored in event table in 31205
			-- target	= de.target -- not stored in event table in 31205
			-- pet		= de.pet    -- not stored in event table in 31205
		},
		-- default options
		-- Channels and Messages tables are guaranteed to exist
		-- the rest might not - correct for that below
		Channels		= self:CopyTable(OldSpellTableEntry.Channels),
		Messages		= self:CopyTable(OldSpellTableEntry.Messages),
	}
	
	-- validate missing data and set defaults
	-- this used to be performed as a side effect in the GUI prior to 3.1.2.05
	local de = SpeakinSpellSavedData.EventTable[de.key]
	
	--WhisperTarget
	if OldSpellTableEntry.WhisperTarget then
		de.WhisperTarget = OldSpellTableEntry.WhisperTarget
	else
		de.WhisperTarget = false
	end
	
	--Frequency
	if OldSpellTableEntry.Frequency then
		de.Frequency = OldSpellTableEntry.Frequency
	else
		de.Frequency = 1.00 --FREQUENCY_DEFAULT
	end
	
	--Cooldown
	if OldSpellTableEntry.Cooldown then
		de.Cooldown	= OldSpellTableEntry.Cooldown
	else
		de.Cooldown	= 0 --COOLDOWN_DEFAULT
	end
	
	--DisableAnnouncements
	if OldSpellTableEntry.DisableAnnouncements then
		de.DisableAnnouncements	= OldSpellTableEntry.DisableAnnouncements
	else
		de.DisableAnnouncements	= false
	end
end


function SpeakinSpell:FixOld_31205_ImportSpellTable()

	SpeakinSpellSavedData.EventTable = {}
	
	if not SpeakinSpellSavedData.SpellTable then
		return
	end

	for oldkey,OldSpellTableEntry in pairs(SpeakinSpellSavedData.SpellTable) do
	
		-- the process in 31205 is basically 3 steps
		-- 1) declare a DetectedObjectStub with name, rank, type, caster, and target
		--		we will create this by parsing the oldkey value, which is where this info lived
		-- 2) pass that stub through the function FullDetectedEvent = CreateDetectedEvent(stub)
		--		we have a copy of that function, with some small tweaks and simplifications
		-- 3) create an EventTableEntry object out of the FullDetectedEvent, which adds the Messages and other settings
		local stub = self:FixOld_31205_CreateDEStub(oldkey)
		
		-- some spells are clearly in the spellbook (UNIT_SPELLCAST_SENT) 
		-- while others must be items (UNIT_SPELLCAST_SENT)  or procs (SPELL_AURA_APPLIED_BUFF)
		if stub.type ~= "BOTH" then
			-- stub.type is known
			local de = self:FixOld_31205_CreateDetectedEvent(stub)
			self:FixOld_31205_CreateEventTableEntry(oldkey, OldSpellTableEntry, de)
		else
			-- stub.type is unknown, record both
			self:Print("Unsure how to update: "..tostring(oldkey))--TODOFUTURE: change this to a prompt
			
			stub.type = "UNIT_SPELLCAST_SENT"
			local de = self:FixOld_31205_CreateDetectedEvent(stub)
			self:FixOld_31205_CreateEventTableEntry(oldkey, OldSpellTableEntry, de)

			stub.type = "SPELL_AURA_APPLIED_BUFF"
			de = self:FixOld_31205_CreateDetectedEvent(stub)
			self:FixOld_31205_CreateEventTableEntry(oldkey, OldSpellTableEntry, de)
		end
	end
	
	-- we can destroy the old SpellTable now.  We won't be using it anymore
	SpeakinSpellSavedData.SpellTable = nil
end


-----------------------------------------------------------------------------------
-- Patch 3.1.2.06
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_31206_UpdateEventKeys()
	local funcname = "FixOld_31206_UpdateEventKeys"
	
	--changing SpeakinSpellSavedData.EventTable causes a problem while iterating on it
	--so build a new table and use it to replace the old table
	local newkeys = {}
	
	if not SpeakinSpellSavedData.EventTable then
		--self:ErrorMsg(funcname, "SpeakinSpellSavedData.EventTable is nil, aborting update to 3.1.2.06")
		SpeakinSpellSavedData.EventTable = {}
		return
	end
	
	for oldkey,EventTableEntry in pairs(SpeakinSpellSavedData.EventTable) do
		local de = EventTableEntry.DetectedEvent
		-- DO NOT CHANGE 3.1.2.06 format is intentional for upgrade chain
		de.key = tostring(de.type)..tostring(de.name)..tostring(de.rank) -- DO NOT CHANGE 3.1.2.06 format
		newkeys[de.key] = EventTableEntry
	end
	
	SpeakinSpellSavedData.EventTable = self:CopyTable(newkeys)
end


-----------------------------------------------------------------------------------
-- Patch 3.1.2.07
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_31207_UpdateEventKeys()
	--changing SpeakinSpellSavedData.EventTable causes a problem while iterating on it
	--so build a new table and use it to replace the old table
	local newkeys = {}
	if not SpeakinSpellSavedData.EventTable then
		SpeakinSpellSavedData.EventTable = {}
	end
	for key,EventTableEntry in pairs(SpeakinSpellSavedData.EventTable) do
		local de = EventTableEntry.DetectedEvent
		if de then
			de.key = string.gsub( string.upper( tostring(de.type)..tostring(de.name)..tostring(de.rank)), " ", "_" ) -- DO NOT CHANGE 3.1.2.07 format
			newkeys[de.key] = EventTableEntry
		end
	end
	SpeakinSpellSavedData.EventTable = self:CopyTable( newkeys )
end


-----------------------------------------------------------------------------------
-- Patch 3.1.3.02
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_31302_AddNewEventsDetected()
	-- moved the NewEventsDetected table from RuntimeData into SpeakinSpellSavedData
	if not SpeakinSpellSavedData.NewEventsDetected then
		SpeakinSpellSavedData.NewEventsDetected = {}
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.1.3.03
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_31303_GetTypeFromKey(key)
	--NOTE: the order matters here
	local types = {
		[1] = "EVENT",
		[2] = "MACRO",
		[3] = "UNIT_SPELLCAST_SENT",
		[4] = "SPELL_AURA_APPLIED_BUFF_FOREIGN",
		[5] = "SPELL_AURA_APPLIED_DEBUFF_FOREIGN",
		[6] = "SPELL_AURA_APPLIED_BUFF",
		[7] = "SPELL_AURA_APPLIED_DEBUFF",
	}
	for i,type in ipairs(types) do
		if self:StartsWith(key, type) then return type end
	end
end

function SpeakinSpell:FixOld_31303_RecoverMissingTypes()
	-- I discovered that DetectedEvent.type was left undefined for many event types in the saved data
	-- thankfully, it can be recovered from the key format
	if not SpeakinSpellSavedData.EventTable then
		SpeakinSpellSavedData.EventTable = {}
	end
	for key,EventTableEntry in pairs(SpeakinSpellSavedData.EventTable) do
		EventTableEntry.DetectedEvent.type = self:FixOld_31303_GetTypeFromKey(key)
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.2.0.06
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_32006_InsertRandomFaction(name)
	if not SpeakinSpellSavedData.RandomSubs then
		SpeakinSpellSavedData.RandomSubs = {} -- shouldn't be needed, but just in case
	end
	if (name ~= nil) and (name ~= "") then
		tinsert(SpeakinSpellSavedData.RandomSubs["randomfaction"], name)
	end
end



function SpeakinSpell:FixOld_32006_UpgradePossessive(EventTableEntry)
	if not EventTableEntry.Messages then
		EventTableEntry.Messages = {} --just in case
	end
	for key,msg in pairs(EventTableEntry.Messages) do
		msg = string.gsub(msg, "<focus>'s","<focus'>")
		msg = string.gsub(msg, ">'s","'s>")
		-- I think that's enough
	end
end


function SpeakinSpell:FixOld_32006_SetDefaultLeaderChannel(EventTableEntry)
	if not EventTableEntry.Channels then
		EventTableEntry.Channels = {} -- should exist already, but just in case
	end
	-- the Leader scenario is new in 3.2.0.06
	-- set it's default channel to match the party or raid scenarios
	if EventTableEntry.Channels.Party then
		EventTableEntry.Channels.PartyLeader = EventTableEntry.Channels.Party
	end
	if EventTableEntry.Channels.Raid then
		EventTableEntry.Channels.RaidLeader = EventTableEntry.Channels.Raid
		EventTableEntry.Channels.RaidOfficer = EventTableEntry.Channels.Raid
	end
end


function SpeakinSpell:FixOld_32006_BunchOfStuff()
	if not SpeakinSpellSavedData.EventTable then
		SpeakinSpellSavedData.EventTable = {} --just in case
	end
	-- update EventTable data
	for key,EventTableEntry in pairs(SpeakinSpellSavedData.EventTable) do
		-- the <pet> variable is not event-specific, but had been tracked in the DetectedEvent objects
		-- the new implementation for substitution variables might use this outdated stored value
		-- instead of the name of the currently active pet
		EventTableEntry.DetectedEvent.pet = nil
		-- update all saved messages to make use of new possessive substitutions like <player's>
		self:FixOld_32006_UpgradePossessive(EventTableEntry)
		-- update settings to use the new Leader scenario the same as SpeakinSpell would have behaved before
		self:FixOld_32006_SetDefaultLeaderChannel(EventTableEntry)
	end
	
	-- Also added <randomtaunt> and <randomfaction> to saved variables, so users can change them
	--SpeakinSpellSavedData.RandomSubs = self:CopyTable( DEFAULT_SPEECHES.RandomSubs ) -- data moved, unnecessary to import it as a patch
	--self:FixOld_32006_AddRandomFactions() -- data moved, unnecessary to import it as a patch
	
end


-----------------------------------------------------------------------------------
-- Patch 3.2.2.02
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_32202_UpgradeNewline()
	if not SpeakinSpellSavedData.EventTable then
		SpeakinSpellSavedData.EventTable = {} --just in case
	end
	for key,EventTableEntry in pairs(SpeakinSpellSavedData.EventTable) do
		for i,Speech in pairs( EventTableEntry.Messages ) do
			Speech = string.gsub( Speech,   "<newline>",  "\n" )
			Speech = string.gsub( Speech, L["<newline>"], "\n" ) --[buildlocales.py No Warning] OK to use the newest translation here
			Speech = string.gsub( Speech, L["3.2.2.02 <newline>"],  "\n" ) -- also check for an old value
			EventTableEntry.Messages[i] = Speech
		end
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.2.2.14
-----------------------------------------------------------------------------------


function SpeakinSpell:Keyify_32214( s )
	return string.upper( string.replace( tostring(s), " ", "_" ) )
end

-- returns rankedkey, ranklesskey
-- if not a rankable event, then ranklesskey will be nil
-- TODOFUTURE: this could return an ordered list of potential keys?
-- maybe for linking UNIT_SPELLCAST_SENT to the matching SPELL_AURA_GAIN 
-- and/or for making speech sets that apply to many spells with the same speech settings
function SpeakinSpell:MakeEventTableKeys_32214( de )
	-- create a unique key for this event
	de.rankedkey	= self:Keyify_32214( tostring(de.type)..tostring(de.name)..tostring(de.rank) )
	de.key = de.rankedkey
	
-- this part is N/A for our purposes.	
--	de.ranklesskey	= self:Keyify_32214( tostring(de.type)..tostring(de.name)                    )
--	if (not self:IsEventTypeRankable( de.type )) or (de.rankedkey == de.ranklesskey) then
--		de.ranklesskey = nil
--	end
end


function SpeakinSpell:FixOld_32214_UpgradeEvents()
	-- the following data table defines:
	--	NewType = NewEventTypes[ de.name ]
	-- WARNING: the event names are localized!! that means subject to change
	-- TODOFUTURE: the localized text used in v3.2.2.14 should be archived here in this oldversions system
	--	to make it safe to change the Localized text descriptions of these events
	local NewEventTypes = {
		[L["3.2.2.14 Entering Combat"]] = "COMBAT",
		[L["3.2.2.14 Exiting Combat"]] = "COMBAT",
		[L["3.2.2.14 Whispered While In-Combat"]] = "CHAT",
	}
	
	if not SpeakinSpellSavedData.EventTable then
		SpeakinSpellSavedData.EventTable = {} --just in case
	end
	
	-- check EventTable
	for key,ete in pairs(SpeakinSpellSavedData.EventTable) do
		local de = ete.DetectedEvent
		if de and de.type == "EVENT" then
			local NewType = NewEventTypes[ de.name ]
			if NewType then
				de.type = NewType
				-- update the table key, which is based on the type
				local oldkey = de.key
				self:MakeEventTableKeys_32214( de )
				ete.key = de.key
				SpeakinSpellSavedData.EventTable[ oldkey ] = nil
				SpeakinSpellSavedData.EventTable[ de.key ] = ete
			end
		end
	end

	-- check NewEventsDetected
	if not SpeakinSpellSavedData.NewEventsDetected then
		SpeakinSpellSavedData.NewEventsDetected = {} --just in case
	end
	for key,de in pairs(SpeakinSpellSavedData.NewEventsDetected) do
		if de and de.type == "EVENT" then
			local NewType = NewEventTypes[ de.name ]
			if NewType then
				de.type = NewType
				-- update the table key, which is based on the type
				local oldkey = de.key
				self:MakeEventTableKeys_32214( de )
				SpeakinSpellSavedData.NewEventsDetected[ oldkey ] = nil
				SpeakinSpellSavedData.NewEventsDetected[ de.key ] = de
			end
		end
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.2.2.15
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_32215_FixDE( de )
	--note L[] might change - use hard-coded text from v3.2.2.14
	--only English text was available for this event type in this version anyway
	-- This applies to a wide variety of events
	-- nameformat = L["I received Yellow Damage (%s)"]
	-- de.name = string.format( nameformat, DamageType),
	-- DamageType is a string composed of things like "Critical, Killing Blow"
	-- This applies the same to White Damage events
	
	-- insert new text "I received" in the name, preserving the DamageType
	de.name = "I caused " .. tostring(de.name)
	de.eventname = de.name
	--de.spellname is the name of the spell = separate data, don't change it
	
	-- insert the new text in the key, using the appropriate format, and preserving the DamageType
	de.key = "COMBAT" .. "I_CAUSED_" .. string.sub( tostring(de.key), string.len("COMBAT")+1)
	de.rankedkey = de.key
	
	-- also fix the <displaylink>
	de.displaylink = self:FormatSubs( "<eventtypeprefix><eventname>: <spelllink>", de)
end


-- This version split "Combat Event: Yellow Damage" into "I caused yellow damage" vs. "I received yellow damage"
-- event keys and names must be updated accordingly
function SpeakinSpell:FixOld_32215_RenameYellowDamage()
	if not SpeakinSpellSavedData.EventTable then
		SpeakinSpellSavedData.EventTable = {} --just in case
	end
	for key,ete in pairs(SpeakinSpellSavedData.EventTable) do
		--note L[] might change - use hard-coded text from v3.2.2.14
		--only English text was available for this event type in this version anyway
		local ndx = string.find(key, "YELLOW_DAMAGE")
		if not ndx then
			ndx = string.find(key, "WHITE_DAMAGE") -- data setup for these is exactly the same as yellow damage
		end
		if ndx and ndx >= 0 then
			self:FixOld_32215_FixDE( ete.DetectedEvent )
			ete.key = ete.DetectedEvent.key
			SpeakinSpellSavedData.EventTable[ ete.key ] = ete
			SpeakinSpellSavedData.EventTable[ key ] = nil
		end
	end
	
	if not SpeakinSpellSavedData.NewEventsDetected then
		SpeakinSpellSavedData.NewEventsDetected = {} --just in case
	end
	for key,de in pairs(SpeakinSpellSavedData.NewEventsDetected) do
		local ndx = string.find(key, "YELLOW_DAMAGE")
		if not ndx then
			ndx = string.find(key, "WHITE_DAMAGE") -- data setup for these is exactly the same as yellow damage
		end
		if ndx and ndx >= 0 then
			self:FixOld_32215_FixDE( de )
			SpeakinSpellSavedData.NewEventsDetected[ de.key ] = de
			SpeakinSpellSavedData.NewEventsDetected[ key ] = nil
		end
	end
	
	-- also just noticed that my saved variables file still has an old copy of SpeakinSpellSavedData.DEFAULT_SPEECHES
	-- this was a past attemmpt to make my current settings easily exportable to DefaultSpeeches-enUS.lua
	-- but it was failed and no longer supported, so clean up the unused old data
	SpeakinSpellSavedData.DEFAULT_SPEECHES = nil
end


-----------------------------------------------------------------------------------
-- Patch 3.2.2.17
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_32217_MoveSavedData()
	--------------------------
	-- NewEventsDetected
	
	if not SpeakinSpellSavedDataForAll.NewEventsDetected then
		SpeakinSpellSavedDataForAll.NewEventsDetected = {}
	end
	
	-- add this toon's NewEventsDetected to the account-wide NewEventsDetected
	self:ValidateObject(SpeakinSpellSavedDataForAll.NewEventsDetected, SpeakinSpellSavedData.NewEventsDetected)
	-- delete this toon's NewEventsDetected
	SpeakinSpellSavedData.NewEventsDetected = nil
	
	--------------------------
	-- EventTable
	local realm = GetRealmName()
	local toon = UnitName("player")
	
	if not SpeakinSpellSavedDataForAll.Toons then
		SpeakinSpellSavedDataForAll.Toons = {}
	end
	if not SpeakinSpellSavedDataForAll.Toons[realm] then
		SpeakinSpellSavedDataForAll.Toons[realm] = {}
	end
	if not SpeakinSpellSavedDataForAll.Toons[realm][toon] then
		SpeakinSpellSavedDataForAll.Toons[realm][toon] = {}
	end
	
	-- move EventTable to SpeakinSpellSavedDataForAll
	-- extra safety checks here because I had a LUA error fail out of this function partway through
	-- it could have caused perma-LUA error at startup for any character in the same boat
	if not SpeakinSpellSavedDataForAll.Toons[realm][toon].EventTable then
		if SpeakinSpellSavedData.EventTable then -- just to be safe
			SpeakinSpellSavedDataForAll.Toons[realm][toon].EventTable = SpeakinSpellSavedData.EventTable
		else
			SpeakinSpellSavedDataForAll.Toons[realm][toon].EventTable = {}
		end
	end
	SpeakinSpellSavedData.EventTable = nil


	--------------------------
	-- RandomSubs
	if not SpeakinSpellSavedDataForAll.RandomSubs then
		SpeakinSpellSavedDataForAll.RandomSubs = {}
	end
	
	-- move/merge RandomSubs into ForAll
	if SpeakinSpellSavedData.RandomSubs then -- very old clients won't have this table at all
		for keyword, newlist in pairs(SpeakinSpellSavedData.RandomSubs) do
			local existinglist = SpeakinSpellSavedDataForAll.RandomSubs[keyword]
			if existinglist then
				-- add new unique words to the list
				local uniquetable = {}
				for _,word in pairs(existinglist) do
					uniquetable[word] = true
				end
				for _,word in pairs(newlist) do
					if not uniquetable[word] then
						tinsert(existinglist,word)
						uniquetable[word] = true
					end
				end
			else
				SpeakinSpellSavedDataForAll.RandomSubs[keyword] = newlist
			end
		end
		
		SpeakinSpellSavedData.RandomSubs = nil
	end -- end if SpeakinSpellSavedData.RandomSubs
	
end -- end FixOld_32217_MoveSavedData


-----------------------------------------------------------------------------------
-- Patch 3.2.2.22
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_32222_MoveNetworkOptions()
	local n = SpeakinSpellSavedDataForAll.Networking
	if not n then return end -- data from before 3.2.2.21 didn't have this table at all
	if n.Share then return end --patch was already applied by logging in to a different toon
	n.Share = {
		ET = n.ShareET,
		NEW = n.ShareNEW,
		RS = true,
	}
	n.Collect = {
		ET = n.CollectET,
		NEW = n.CollectNEW,
		RS = true,
	}
	-- delete old vars
	n.ShareET = nil
	n.ShareNEW = nil
	n.CollectET = nil
	n.CollectNEW = nil
end


-----------------------------------------------------------------------------------
-- Patch 3.2.2.25
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_32225_EraseOldRezEventHooks()
	-- everything in the patch applies to global data only
	-- we can (and should) skip it if we already ran this patch from a different toon
	if SpeakinSpellSavedDataForAll.Version >= "3.2.2.25" then
		return
	end
	
	if not SpeakinSpellSavedDataForAll.NewEventsDetected then
		SpeakinSpellSavedDataForAll.NewEventsDetected = {} --just in case
	end
	
	-- all the REZ event key names have changed since the previous version
	-- erase all the old NewEventsDetected hooks
	for key,de in pairs(SpeakinSpellSavedDataForAll.NewEventsDetected) do
		if de.type == "REZ" then
			SpeakinSpellSavedDataForAll.NewEventsDetected[key] = nil
		end
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.2.2.26
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_32226_FixInvalidEventHooks()
	local funcname = "patch 3.2.2.26"
	
	-- everything in the patch applies to global data only
	-- we can (and should) skip it if we already ran this patch from a different toon
	if SpeakinSpellSavedDataForAll.Version >= "3.2.2.26" then
		return
	end
	
	-- the previous few betas allowed for some invalid event hooks to be created
	-- 3.2.2.26 also adds a mechanism to init the NewEventsDetected list from DEFAULT_EVENTHOOKS
	if not SpeakinSpellSavedDataForAll.NewEventsDetected then
		SpeakinSpellSavedDataForAll.NewEventsDetected = {} --just in case
	end
	local ned = SpeakinSpellSavedDataForAll.NewEventsDetected
	for key,de in pairs(ned) do
		if de.type == "COMM" -- these were all changed to COMMRX or COMMTX
		or de.type == "EVENT" -- these will be recreated from DEFAULT_EVENTHOOKS
		or self:EndsWith( key, "NIL" ) then -- to deal with improper handling of nil ranks
			-- delete the whole event
			--self:DebugMsg(funcname, "delete:"..tostring(key))
			ned[key] = nil
		else 
			-- remove unused data clutter - recreate each de table with minimal data
			--self:DebugMsg(funcname, "repair:"..tostring(key))
			ned[key] = {
				type = de.type,
				name = de.name,
				rank = de.rank,
				key = key,
			}
		end
	end
	
	-- delete old global networking options that were moved
	-- most of this is redundant with 3.2.2.22 but somehow seems to have gotten missed
	local n = SpeakinSpellSavedDataForAll.Networking
	
	-- the rest of this function only deals with networking data
	if not n then
		return
	end
	
	n.ShareET = nil
	n.ShareNEW = nil
	n.CollectET = nil
	n.CollectNEW = nil
	n.AutoVersionChecks = nil -- wasn't touched by 3.2.2.22 patch

	-- clear out any collected event table entries based on these
	local cet = n.CollectedEventTables
	if not cet then
		return
	end
	
	for player,et in pairs(cet) do
		for key,ete in pairs(et) do
			local de = ete.DetectedEvent
			if de.type == "COMM" -- these were all changed to COMMRX or COMMTX
			or de.type == "EVENT" -- these can be recollected
			or self:EndsWith( key, "NIL" ) then -- to deal with improper handling of nil ranks
				et[key] = nil
			else 
				-- remove unused data clutter
				ete.DetectedEvent = {
					type = de.type,
					name = de.name,
					rank = de.rank,
					key = key,
				}
				-- clean out additional options that should not be sent over the network
				ete.ReadOnly = nil
				ete.DisableAnnouncements = nil
				ete.DetectedEventStub = nil
			end
		end
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.2.2.27
-----------------------------------------------------------------------------------


-- my NewEventsDetected has become tons of extra DetectedEvent.members in it
-- all that should be needed is type, name, rank, and key
function SpeakinSpell:FixOld_32227_CleanNewEventsDetected()
	if not SpeakinSpellSavedDataForAll.NewEventsDetected then
		SpeakinSpellSavedDataForAll.NewEventsDetected = {} --just in case
	end
	for key,de in pairs(SpeakinSpellSavedDataForAll.NewEventsDetected) do
		local newde = {
			name = de.name,
			type = de.type,
			rank = de.rank,
			key = de.key,
		}
		SpeakinSpellSavedDataForAll.NewEventsDetected[ key ] = newde
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.3.0.02
-----------------------------------------------------------------------------------


-- wow patch 3.3.0 removed the raid warning channel from 5-man groups
-- also check for duplicate enter/exit combat events, reported by Dire Lemming
function SpeakinSpell:FixOld_33002_RaidWarnAndDupEvents()
	if not SpeakinSpellSavedDataForAll.NewEventsDetected then
		SpeakinSpellSavedDataForAll.NewEventsDetected = {} --just in case
	end
	-- 32214 renamed these events
	-- Dire Lemming reported that she was getting duplicates of these
	-- getting this out of the way first since error checks aren't needed
	SpeakinSpellSavedDataForAll.NewEventsDetected[ "EVENTENTERING_COMBAT" ] = nil
	SpeakinSpellSavedDataForAll.NewEventsDetected[ "EVENTEXITING_COMBAT" ] = nil
	
	-- first lets clean up any EventTable entries that still reference the raid warning channel in 5-man scenarios
	local EventTable = SpeakinSpell:GetActiveEventTable()
	if not EventTable then
		-- OK that's weird, why doesn't this exist? oh well just abort silently
		return
	end

	-- change raid warnings to party chat for 5-man scenarios
	for key, ete in pairs(EventTable) do
		if ete.Channels.Party == "RAID_WARNING" then
			ete.Channels.Party = "PARTY"
		end
		if ete.Channels.PartyLeader == "RAID_WARNING" then
			ete.Channels.PartyLeader = "PARTY"
		end
	end
	
	-- ideally this should perform a merge from the old event key to the new one
	-- but the merge logic here would be non-trivial
	-- and that should have already been done by the 3.2.2.14 patch when these were originally renamed
	-- Dire Lemming's problem is most likely caused by copy-pasting in her saved variables files
	-- reintroducing old data into the current version
	-- so this is unlikely to occur for most people
	-- and anyone who created this problem with copy paste has their speeches archived
	-- so they can re-edit the LUA files again (and hopefully get it right this time??)
	-- so we can just simply blow these away
	-- my bigger concern is what this kind of error does as it propogates across the data sharing network
	EventTable[ "EVENTENTERING_COMBAT" ] = nil
	EventTable[ "EVENTEXITING_COMBAT" ] = nil
end


-----------------------------------------------------------------------------------
-- Patch 3.3.3.01
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_33301_FixRandomSubs()
	-- previous versions allowed the end-user to enter invalid data into the random substitutions
	-- fix any errors in their old saved data, the way the GUI now validates this
	-- WARNING: changes to Validate_SubstitutionKey might cause issues for users who skip a version
	--		if another future patch has to run a similar procedure and we end up fixing the keys more than once
	--		in different ways... makes me worry the second pass would have unexpected input data that's already fixed
	--		but since it's already fixed it should be OK... I hope... don't want to duplicate the function
	
	local RandomSubs = SpeakinSpellSavedDataForAll.RandomSubs
	if RandomSubs then
		for keyword, wordlist in pairs(RandomSubs) do
			local newkeyword = self:Validate_SubstitutionKey(keyword)
			if newkeyword ~= keyword then
				RandomSubs[keyword] = nil
				RandomSubs[newkeyword] = wordlist
			end
		end
	end
	
	-- also repair data-sharing saved data if we collected any errors from others...
	if	SpeakinSpellSavedDataForAll.Networking and 
		SpeakinSpellSavedDataForAll.Networking.CollectedRandomSubs then
		for creator, RandomSubs in pairs( SpeakinSpellSavedDataForAll.Networking.CollectedRandomSubs ) do
			for keyword, wordlist in pairs(RandomSubs) do
				local newkeyword = self:Validate_SubstitutionKey(keyword)
				if newkeyword ~= keyword then
					RandomSubs[keyword] = nil
					RandomSubs[newkeyword] = wordlist
				end
			end
		end
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.3.3.03
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_33303_NewOptions()
	-- add new global cooldown option, defaulted to 0 seconds to preserve legacy behavior
	if not SpeakinSpellSavedData.GlobalCooldown then
		SpeakinSpellSavedData.GlobalCooldown = 0
	end
	
	-- add ExpandMacros option to all EventTableEntry objects
	if not SpeakinSpellSavedDataForAll.Toons then
		return -- data is too old to contain this data
	end
	
	for realm,ToonList in pairs(SpeakinSpellSavedDataForAll.Toons) do
		for toon,ToonSettings in pairs(ToonList) do
			if ToonSettings.EventTable then
				for key,ete in pairs(ToonSettings.EventTable) do
					if not ete.ExpandMacros then -- nil or false
						ete.ExpandMacros = false --preserve legacy behavior
					end
				end
			end
		end
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.3.3.04
-----------------------------------------------------------------------------------


function SpeakinSpell:FixOld_33304_SharedEventTable()
	-- now supports a shared event table for all toons
	-- create the option and set it to false if it doesn't exist
	if nil == SpeakinSpellSavedDataForAll.AllToonsShareSpeeches then
		SpeakinSpellSavedDataForAll.AllToonsShareSpeeches = false
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.3.3.06
-----------------------------------------------------------------------------------
-- I removed the white/yellow damage events, which were badly designed
-- because of too many permutations of damage types:glancing/resist/absorbed/etc.
-- speeches are preserved by converting existing data to /ss macro events
-- new smarter/generalized events are added for critical strikes and killing blows


function SpeakinSpell:FixOld_33306_CleanOneEventTable(EventTable)
	if not EventTable then
		return nil -- shouldn't occur, but standard safety check
	end
	
	-- NOTE: adding/removing table keys during the loop gave one person an error "invalid key to 'next' "
	--		although this is something that never caused an error for me, I am reading that
	--		it is not allowed, and only sometimes throws an error
	--		so generate a new table and return it to overwrite EventTable, 
	--		instead of changing the existing EventTable while iterative over it
	local NewEventTable = {}

	for key,ete in pairs(EventTable) do
		if ete.DetectedEvent.type == "COMBAT" and 
			(string.find(key, "WHITE_DAMAGE") or string.find(key,"YELLOW_DAMAGE")) then
			-- shortcut to detected event object
			local de = ete.DetectedEvent
			-- convert to macro type
			de.type = "MACRO"
			de.name = MACRO.." "..tostring(de.name)
			de.eventname = de.name
			de.spellname = de.name
			-- regenerate key
			-- 3.3.3.05 key format expanded in-line here for simplicity
			local newkey = string.upper( string.replace( tostring( tostring(de.type)..tostring(de.name) ), " ", "_" ) )
			-- update key
			de.rankedkey = newkey
			de.key = newkey
			ete.key = newkey
			-- update container table
			NewEventTable[newkey] = ete
		else
			NewEventTable[key] = ete
		end
	end

	return NewEventTable
end


function SpeakinSpell:FixOld_33306_DeprecateDamageEvents()
	-- alter each toon-specific event table
	for realm,ToonList in pairs(SpeakinSpellSavedDataForAll.Toons) do
		for toon,ToonSettings in pairs(ToonList) do
			if ToonSettings.EventTable then
				ToonSettings.EventTable = self:FixOld_33306_CleanOneEventTable(ToonSettings.EventTable)
			end
		end
	end
	
	-- if using a shared event table, update that too
	if SpeakinSpellSavedDataForAll.AllToonsEventTable then
		SpeakinSpellSavedDataForAll.AllToonsEventTable = self:FixOld_33306_CleanOneEventTable(SpeakinSpellSavedDataForAll.AllToonsEventTable)
	end

	-- also remove the deprecated event keys from the list of unused event hooks
	if SpeakinSpellSavedDataForAll.NewEventsDetected then
		for key,_ in pairs(SpeakinSpellSavedDataForAll.NewEventsDetected) do
			if string.find(key, "WHITE_DAMAGE") or string.find(key,"YELLOW_DAMAGE") then
				SpeakinSpellSavedDataForAll.NewEventsDetected[key] = nil
			end
		end
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.3.3.09
-----------------------------------------------------------------------------------
-- The patch function for 3.3.3.05 had an error from adding/removing keys to a table,
-- while iterating over that table, which caused "invalid key to next" lua errors
-- causing it to fail out during load, so I fixed that error, and moved it to 3.3.3.06
-- (there isn't a 3.3.3.05 patch function anymore, because it was renamed to 3.3.3.06)
-- However, the 3.3.3.06 patch had another error that it didn't check for COMBAT type events
-- allowing it to reconvert already-converted macro events from the deprecated 3.3.3.05 patch
-- The 3.3.3.06 patch is now fixed, but this new patch is designed to fix data that had
-- been corrupted by the previous buggy patch
-- NOTE: it has to be careful not to break anything for people who were never effected
-- by the previous bug, if they skip from 3.3.3.04 directly to 3.3.3.09 or newer
-- and thus get the repaired 3.3.3.06 patch instead of the bugged 3.3.3.05/06 patches from those releases



function SpeakinSpell:FixOld_33309_CleanOneEventTable(EventTable)
	if not EventTable then
		return nil -- shouldn't occur, but standard safety check
	end
	
	-- because keys will change, we'll have to rebuild the table
	local NewEventTable = {}

	for key,ete in pairs(EventTable) do
		-- fix MACRO events
		-- which have the white/yellow damage substrings in their keys, derived from the deprecated events
		-- and which repeat the word macro more than once
		-- note that all macro event keys start with MACROMACRO (the type, plus the user input to the slash command function)
		-- but a broken one here would be MACROMACRO_MACRO, or possibly MACROMACRO_MACRO_MACRO_MACRO, etc.
		if ete.DetectedEvent.type == "MACRO" and 
			(string.find(key, "WHITE_DAMAGE") or string.find(key,"YELLOW_DAMAGE")) and 
			self:StartsWith(key, "MACROMACRO_MACRO") then
			-- shortcut to detected event object
			local de = ete.DetectedEvent
			
			-- strip repeating "macro macro" from the name
			-- this might be repeated any number of times "macro macro macro macro" etc.
			-- and only occurs at the start of the string
			-- opposite of this: de.name = MACRO.." "..tostring(de.name)
			while self:StartsWith(de.name, "macro macro") do
				de.name = string.sub( de.name, string.len("macro ")+1 )
			end

			-- update eventname to match name
			de.eventname = de.name
			de.spellname = de.name

			-- regenerate key
			-- 3.3.3.09 key format expanded in-line here for simplicity
			local newkey = string.upper( string.replace( tostring( tostring(de.type)..tostring(de.name) ), " ", "_" ) )
			
			-- update key
			de.rankedkey = newkey
			de.key = newkey
			ete.key = newkey
			
			-- update container table
			NewEventTable[newkey] = ete
		else
			-- keep as-is
			NewEventTable[key] = ete
		end
	end

	return NewEventTable
end


function SpeakinSpell:FixOld_33309_FixMacroMacro()
	-- alter each toon-specific event table
	for realm,ToonList in pairs(SpeakinSpellSavedDataForAll.Toons) do
		for toon,ToonSettings in pairs(ToonList) do
			if ToonSettings.EventTable then
				ToonSettings.EventTable = self:FixOld_33309_CleanOneEventTable(ToonSettings.EventTable)
			end
		end
	end
	
	-- if using a shared event table, update that too
	if SpeakinSpellSavedDataForAll.AllToonsEventTable then
		SpeakinSpellSavedDataForAll.AllToonsEventTable = self:FixOld_33309_CleanOneEventTable(SpeakinSpellSavedDataForAll.AllToonsEventTable)
	end
	
	-- also clean these things from the data sharing collected event tables
	-- ya know what? just reset the collected data entirely
	-- it could be dirty with other deprecated stuff I'm forgetting
	-- and it's not that important to preserve
	if SpeakinSpellSavedDataForAll.Networking then
		SpeakinSpellSavedDataForAll.Networking.CollectedEventTables = {}
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.3.5.01
-----------------------------------------------------------------------------------
-- Previous versions have been using English event hook lists in non-English game clients
-- this patch deletes the invalid data (the entire event hook list)
-- to force non-English clients to learn a new list of valid event hooks


function SpeakinSpell:FixOld_33501_DeleteNonEnglishEventHooks()
	local gameLocale = GetLocale()
	if gameLocale ~= "enUS" and gameLocale ~= "enGB" then
		-- non-English game clients must delete old invalid lists of event hooks
		-- this list contains mostly English spell names and event keys that won't work
		SpeakinSpellSavedDataForAll.NewEventsDetected = {}
	end
end


-----------------------------------------------------------------------------------
-- Patch 3.3.5.06
-----------------------------------------------------------------------------------
-- Bad event keys were introduced by a previous DefaultSpeeches-enUS file
-- fix Resurrection: Start Casting (I'm the caster) event keys

function SpeakinSpell:FixOld_33506_OneEventTable(EventTable)
	local badkey  = "REZSTART CASTING_(I'M_THE_CASTER)" --broken because of a space instead of underscore
	local goodkey = "REZSTART_CASTING_(I'M_THE_CASTER)"
	
	-- if there's already an entry for the working key, delete the broken one
	if EventTable[goodkey] then
		EventTable[badkey] = nil
		return
	end
	
	-- else, migrate the broken key to the working one
	if EventTable[badkey] then
		EventTable[goodkey] = EventTable[badkey]
		EventTable[goodkey].key = goodkey
		EventTable[goodkey].DetectedEvent.key = goodkey
		EventTable[goodkey].DetectedEvent.ranklesskey = goodkey
		EventTable[goodkey].DetectedEvent.rankedkey = goodkey
		EventTable[badkey] = nil
		return
	end
end

function SpeakinSpell:FixOld_33506_FixRezKeys()
	-- alter each toon-specific event table
	for realm,ToonList in pairs(SpeakinSpellSavedDataForAll.Toons) do
		for toon,ToonSettings in pairs(ToonList) do
			if ToonSettings.EventTable then
				self:FixOld_33506_OneEventTable(ToonSettings.EventTable)
			end
		end
	end
	
	-- if using a shared event table, update that too
	if SpeakinSpellSavedDataForAll.AllToonsEventTable then
		self:FixOld_33506_OneEventTable(SpeakinSpellSavedDataForAll.AllToonsEventTable)
	end
	
	-- also clean these things from the data sharing collected event tables
	-- ya know what? just reset the collected data entirely
	-- it could be dirty with other deprecated stuff I'm forgetting
	-- and it's not that important to preserve
	if SpeakinSpellSavedDataForAll.Networking then
		if SpeakinSpellSavedDataForAll.Networking.CollectedEventTables then
			for creator, EventTable in pairs(SpeakinSpellSavedDataForAll.Networking.CollectedEventTables) do
				self:FixOld_33506_OneEventTable(EventTable)
			end
		end
	end
end


-----------------------------------------------------------------------------------
-- Define Patches by version
-----------------------------------------------------------------------------------

SpeakinSpell.Patches = {

{ Version = "3.1.1.02", 
	-- Added this global toggle in 3.1.1.02, before this, it behaved as if always on
	func = function() SpeakinSpellSavedData.EnableAllMessages = true end,
},

{ Version = "3.1.2.05", 
	-- redefined the SpellTable as EventTable with a new key system and data format
	func = function() SpeakinSpell:FixOld_31205_ImportSpellTable() end,
},

{ Version = "3.1.2.06", 
	-- changed event keys so they sort by event type instead of spell name
	func = function() SpeakinSpell:FixOld_31206_UpdateEventKeys() end,
},

{ Version = "3.1.2.07",
	-- changed event keys to uppercase, with underscores replacing spaces
	func = function() SpeakinSpell:FixOld_31207_UpdateEventKeys() end,
},

{ Version = "3.1.3.02",
	-- moved the NewEventsDetected table from RuntimeData into SpeakinSpellSavedData
	func = function() SpeakinSpell:FixOld_31302_AddNewEventsDetected() end,
},

{ Version = "3.1.3.03",
	-- I discovered that DetectedEvent.type was left undefined for many event types in the saved data
	-- thankfully, it can be recovered from the key format
	func = function() SpeakinSpell:FixOld_31303_RecoverMissingTypes() end,
},

{ Version = "3.2.0.06",
	-- This version made several changes to the saved data
	func = function() SpeakinSpell:FixOld_32006_BunchOfStuff() end,
},

{ Version = "3.2.2.02",
	-- This version enhanced <newline> to allow storing "\n" in the data and GUI
	func = function() SpeakinSpell:FixOld_32202_UpgradeNewline() end,
},

{ Version = "3.2.2.14",
	-- This version split up the growing category of type = "EVENT" speech events into new additional event types
	func = function() SpeakinSpell:FixOld_32214_UpgradeEvents() end,
},

{ Version = "3.2.2.15",
	-- This version split "Combat Event: Yellow Damage" into I caused yellow damage vs. I received yellow damage.
	-- event keys and names must be updated accordingly
	func = function() SpeakinSpell:FixOld_32215_RenameYellowDamage() end,
},

{ Version = "3.2.2.17",
	-- moved saved data tables from the per-character to account-wide settings
	func = function() SpeakinSpell:FixOld_32217_MoveSavedData() end,
},

{ Version = "3.2.2.21",
	-- introduced the concept of the DATA_VERSION separate from the CURRENT_VERSION
	-- a patch must be defined in order to increment the DATA_VERSION
	-- without a patch definition, the data from previous client versions will be considered compatible with the current version
	-- NOTE: this version also split the channel option COMM TRAFFIC into TX/RX, but I doubt anyone was using it
	--		and this was a beta so if the lack of a patch for that causes LUA errors, oh well, I'm being lazy about this one
	func = function() end,
},

{ Version = "3.2.2.22",
	-- moved some networking options into a sub-table
	func = function() SpeakinSpell:FixOld_32222_MoveNetworkOptions() end,
},

{ Version = "3.2.2.25",
	-- the previous version's REZ type event key names have been changed
	func = function() SpeakinSpell:FixOld_32225_EraseOldRezEventHooks() end,
},

{ Version = "3.2.2.26",
	-- my NewEventsDetected has become cluttered with invalid event keys from the past few betas
	func = function() SpeakinSpell:FixOld_32226_FixInvalidEventHooks() end,
},

{ Version = "3.2.2.27",
	-- my NewEventsDetected has become tons of extra DetectedEvent.members in it
	func = function() SpeakinSpell:FixOld_32227_CleanNewEventsDetected() end,
},

{ Version = "3.3.0.02",
	-- wow patch 3.3.0 removed the raid warning channel from 5-man groups
	-- also check for duplicate enter/exit combat events, reported by Dire Lemming
	func = function() SpeakinSpell:FixOld_33002_RaidWarnAndDupEvents() end,
},

{ Version = "3.3.3.01",
	-- previous versions allowed the end-user to enter invalid data into the random substitutions
	-- fix any errors in their old saved data, the way the GUI now validates this
	func = function() SpeakinSpell:FixOld_33301_FixRandomSubs() end,
},

{ Version = "3.3.3.03",
	-- This version added some new options
	func = function() SpeakinSpell:FixOld_33303_NewOptions() end,
},

{ Version = "3.3.3.04",
	-- This version added some new options
	func = function() SpeakinSpell:FixOld_33304_SharedEventTable() end,
	OnlyForAll = true, --no toon-specific changes, alts need not run this patch
},

{ Version = "3.3.3.06",
	-- I removed the white/yellow damage events, which were badly designed
	-- speeches are preserved by converting existing data to /ss macro events
	func = function() SpeakinSpell:FixOld_33306_DeprecateDamageEvents() end,
	OnlyForAll = true, --no toon-specific changes, alts need not run this patch
},

{ Version = "3.3.3.09",
	-- Errors in the patch function for 3.3.3.05 (which was moved to 6)
	-- caused repetitive duplication of the word macro in the converted macro events
	func = function() SpeakinSpell:FixOld_33309_FixMacroMacro() end,
	OnlyForAll = true, --no toon-specific changes, alts need not run this patch
},

{ Version = "3.3.5.01",
	-- Previous versions have been using English event hook lists in non-English game clients
	-- this patch deletes the invalid data (the entire event hook list)
	-- to force non-English clients to learn a new list of valid event hooks
	func = function() SpeakinSpell:FixOld_33501_DeleteNonEnglishEventHooks() end,
	OnlyForAll = true, --no toon-specific changes, alts need not run this patch
},

{ Version = "3.3.5.06",
	-- Bad event keys were introduced by a previous DefaultSpeeches-enUS file
	-- fix Resurrection: Start Casting (I'm the caster) event keys
	func = function() SpeakinSpell:FixOld_33506_FixRezKeys() end,
	OnlyForAll = true, --no toon-specific changes, alts need not run this patch
},

-----------------------------------------------------------------------------------
} -- end Patches


-----------------------------------------------------------------------------------
-- DATA VERSION and debugging
-----------------------------------------------------------------------------------

-- data version used for patches and network communications
SpeakinSpell.DATA_VERSION = SpeakinSpell.Patches[ #(SpeakinSpell.Patches) ].Version

-- this flag enables debugging the latest patch function
-- will force ApplyPatches to run, and adjust the DATA_VERSION to always apply the latest patch function
SpeakinSpell.DEBUG_PATCH = false

if SpeakinSpell.DEBUG_PATCH then
	-- if debugging the newest patch function, 
	-- artificially set DATA_VERSION to the previous version
	SpeakinSpell.DATA_VERSION = "3.3.3.06"
end


-----------------------------------------------------------------------------------
-- RUN PATCH FUNCTIONS
-----------------------------------------------------------------------------------


function SpeakinSpell:ApplyPatches() --globally, i.e. on first time load of a new version
	
	if SpeakinSpell.DEBUG_PATCH and (SpeakinSpellSavedData.Version >= SpeakinSpell.DATA_VERSION) then
		-- if debugging the newest patch function, force it to run
		SpeakinSpellSavedData.Version = SpeakinSpell.DATA_VERSION
	end
	
	-----------------------------------------------------------------------------------
	-- Apply all patches

	for i, Patch in ipairs(SpeakinSpell.Patches) do
		if SpeakinSpellSavedData.Version < Patch.Version then -- this toon's first time logging in with this version
			if Patch.OnlyForAll and SpeakinSpellSavedDataForAll.Version >= Patch.Version then
				-- only the DataForAll is effected, and it was already updated
				-- so skip it
			else
				-- apply the patch defined above
				local subs = {
					oldversion = SpeakinSpellSavedData.Version,
					newversion = Patch.Version,
				}
				self:Print( SpeakinSpell:FormatSubs( L["Updating saved data <oldversion> -> <newversion>"], subs) )
				Patch.func()
			end
			SpeakinSpellSavedData.Version = Patch.Version -- patch has been applied
		end
	end

	-----------------------------------------------------------------------------------
	-- all saved data is now up to date with the current version
	SpeakinSpellSavedData.Version		= SpeakinSpell.DATA_VERSION
	SpeakinSpellSavedDataForAll.Version = SpeakinSpell.DATA_VERSION
end
