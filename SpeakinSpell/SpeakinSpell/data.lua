-- Author      : RisM
-- Create Date : 6/28/2009 3:56:24 PM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)
local DEFAULT_EVENTHOOKS = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell_DEFAULT_EVENTHOOKS",	false)

SpeakinSpell:PrintLoading("data.lua")

-------------------------------------------------------------------------------
-- DATA STRUCTURES (? not sure what to call this category)
-------------------------------------------------------------------------------


function SpeakinSpell:GetActiveEventTable()
	local realm = GetRealmName()
	local toon = UnitName("player")
	
	if SpeakinSpellSavedDataForAll.AllToonsShareSpeeches then
		-- all toons share the same event table
		if not SpeakinSpellSavedDataForAll.AllToonsEventTable then
			SpeakinSpellSavedDataForAll.AllToonsEventTable = {}
		end
		return SpeakinSpellSavedDataForAll.AllToonsEventTable
	end
	
	-- just to be safe, make sure this table exists at each level
	if not SpeakinSpellSavedDataForAll.Toons then
		SpeakinSpellSavedDataForAll.Toons = {}
	end
	if not SpeakinSpellSavedDataForAll.Toons[realm] then
		SpeakinSpellSavedDataForAll.Toons[realm] = {}
	end
	if not SpeakinSpellSavedDataForAll.Toons[realm][toon] then
		SpeakinSpellSavedDataForAll.Toons[realm][toon] = {}
	end
	if not SpeakinSpellSavedDataForAll.Toons[realm][toon].EventTable then
		SpeakinSpellSavedDataForAll.Toons[realm][toon].EventTable = {}
	end
	
	-- return the active character's EventTable - this is one of the most important data structures
	return SpeakinSpellSavedDataForAll.Toons[realm][toon].EventTable
end


-------------------------------------------------------------------------------
-- INITIALIZATION / IMPORT OF DEFAULT DATA
-------------------------------------------------------------------------------


function SpeakinSpell:InitDefaultSavedData()
	
	-- Create/Reset the saved data per-character
	table.wipe(SpeakinSpellSavedData)
	self:ValidateObject( SpeakinSpellSavedData, SpeakinSpell.DEFAULTS.SpeakinSpellSavedData )
	
	-- DO NOT Create/Reset the saved data per-account
	-- but do reset this toon's settings within the saved data for all
	table.wipe( self:GetActiveEventTable() )
	self:ValidateObject( SpeakinSpellSavedDataForAll, SpeakinSpell.DEFAULTS.SpeakinSpellSavedDataForAll )
	
	-- set the data version
	-- the data version lives on the available patches defined in oldversions.lua
	-- so it can't be defined in the constructor templates declared in loader.lua
	SpeakinSpellSavedData.Version		= SpeakinSpell.DATA_VERSION
	SpeakinSpellSavedDataForAll.Version = SpeakinSpell.DATA_VERSION
	
	-- Insert defaults speeches and event settings for all suitable templates
	self:ImportDefaultStarterSpeeches()

	-- set the event hook list to the defaults, to get it started
	SpeakinSpellSavedDataForAll.NewEventsDetected = self:CopyTable( DEFAULT_EVENTHOOKS.NewEventsDetected )
	
	-- some info may be missing from the defaults out of convenience
	-- this also performs additional data-driven data construction 
	-- for default global settings and other data structures
	self:ValidateAllSavedData()
	
end


function SpeakinSpell:InitDefaultSavedData_NewToonOnly()
	-- like above, as a first-time init only
	-- (InitDefaultSaveData is also used for /ss reset)
	
	-- Create/Reset the saved data for just this character
	table.wipe(SpeakinSpellSavedData)
	self:ValidateObject( SpeakinSpellSavedData, SpeakinSpell.DEFAULTS.SpeakinSpellSavedData )

	-- make sure all global shared data is up-to-date
	-- NOTE: this will still run patches on the saved data For All 
	-- if the current user's saved data (assigned above) is at the current version, which it is now
	self:ValidateAllSavedData()

	-- Insert defaults speeches and event settings for all suitable templates
	-- NOTE: global "for all players" default speeches have already been reviewed/deleted/modified 
	--		on other toons, presumably, if SpeakinSpellSavedDataForAll.AllToonsShareSpeeches
	--		that caveat is handled internally to the templates system - see: Template_UseAsStarterDefault
	self:ImportDefaultStarterSpeeches()
end



-------------------------------------------------------------------------------
-- DATA STRUCTURES (? not sure what to call this category)
-------------------------------------------------------------------------------

function SpeakinSpell:InitRuntimeData()
	--NOTE: SpeakinSpellSavedData either does not exist yet or is about to be reset to defaults
	--		do not reference it here
	
	-- declaration moved to loader.lua - just copy the default RuntimeData template/constructor here to reset the runtime state
	self.RuntimeData = self:CopyTable( self.DEFAULTS.RuntimeData )
end


function SpeakinSpell:DeleteSpell(key)
	-- delete the current selection from the SavedData and RuntimeData tables
	self:GetActiveEventTable()[key] = nil
	
	if not self.RuntimeData then
		-- we're still initializing, so the rest of this stuff doesn't matter
		return
	end
	
	-- remove runtime data for messaging cooldowns and limits
	self.RuntimeData.AnnouncementHistory[key] = nil
	
	-- restore the spell to the list of new detected
	-- so the user doesn't have to retrigger it
	-- self:RecordNewSpell(EventTableEntry.DetectedEvent)
	-- NO! could be outdated and bugged event
	-- just make the user recreate it	
	
	self:CurrentMessagesGUI_ValidateSelectedEvent() -- make sure we still have a valid spell selection
end



function SpeakinSpell:IsEventTypeRankable(checktype)
	local RankableEventTypes = {
		"*ALL",
		"UNIT_SPELLCAST_SENT",
		"UNIT_SPELLCAST_CHANNEL_START",
		"UNIT_SPELLCAST_CHANNEL_STOP",
		"UNIT_SPELLCAST_FAILED",
		"UNIT_SPELLCAST_INTERRUPTED",
		"UNIT_SPELLCAST_STOP",
		"UNIT_SPELLCAST_SUCCEEDED",
	}
	for _,type in pairs(RankableEventTypes) do
		if checktype == type then
			return true --this event type is rankable
		end
	end
	
	return false --this event type is not rankable
end


function SpeakinSpell:IsSelectedEventTypeFilterRankable()
	return self:IsEventTypeRankable( self.RuntimeData.OptionsGUIStates.SelectedEventTypeFilter )
end


function SpeakinSpell:SetFilterShowMoreThanAHundred(value)
	if SpeakinSpellSavedData.ShowMoreThanAHundred == value then
		--value is not changing
		return
	end
	
	SpeakinSpellSavedData.ShowMoreThanAHundred = value
	
	--self.RuntimeData.OptionsGUIStates.MessageSettings.FilterChanged = true --the message settings GUI will always Show All Ranks
	self.RuntimeData.OptionsGUIStates.CreateNew.FilterChanged = true
end


function SpeakinSpell:SetFilterShowUsedHooks(value)
	if SpeakinSpellSavedData.ShowUsedHooks == value then
		-- value is not changing
		return
	end
	
	SpeakinSpellSavedData.ShowUsedHooks = value
	--self.RuntimeData.OptionsGUIStates.MessageSettings.FilterChanged = true --the message settings GUI ONLY shows used hooks
	self.RuntimeData.OptionsGUIStates.CreateNew.FilterChanged = true
end


function SpeakinSpell:SetFilterShowAllRanks(value)
	if SpeakinSpellSavedData.ShowAllRanks == value then
		--value is not changing
		return
	end
	
	SpeakinSpellSavedData.ShowAllRanks = value
	
	if self:IsSelectedEventTypeFilterRankable() then
		--self.RuntimeData.OptionsGUIStates.MessageSettings.FilterChanged = true --the message settings GUI will always Show All Ranks
		self.RuntimeData.OptionsGUIStates.CreateNew.FilterChanged = true
	end
end


function SpeakinSpell:SetFilter(type,text)
	local rebuild = false
	if type and self.RuntimeData.OptionsGUIStates.SelectedEventTypeFilter ~= type then
		self.RuntimeData.OptionsGUIStates.SelectedEventTypeFilter = type
		rebuild = true
	end
	
	if text and self.RuntimeData.OptionsGUIStates.SelectedEventTextFilter ~= text then
		self.RuntimeData.OptionsGUIStates.SelectedEventTextFilter = text
		rebuild = true
	end
	
	if rebuild then
		self.RuntimeData.OptionsGUIStates.MessageSettings.FilterChanged = true
		self.RuntimeData.OptionsGUIStates.CreateNew.FilterChanged = true
	end
end

	
function SpeakinSpell:MatchesFilter(DetectedEvent, ForceAllRanks)
	local funcname = "MatchesFilter"
	
	if not DetectedEvent then -- deleting data may have made a key invalid
		return false
	end
	
	-- check type filter
	local type = SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTypeFilter
	if type and not (type == "*ALL" or type == DetectedEvent.type) then
		--self:DebugMsg(funcname, "type failed:"..tostring(DetectedEvent.type))
		return false
	end
	
	-- check text filter - use lowercase for case-insensitive comparison
	local text = string.lower( SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTextFilter )
	--self:DebugMsg(funcname, "text:"..tostring(text))
	if text and not (text == "") then
		local name = DetectedEvent.name or DetectedEvent.eventname or DetectedEvent.spellname
		if name then
			name = string.lower(name)
		else
			name = ""
		end
		-- NOTE: hyphens cause string.find to fail to find "auto-afk" in "auto-afk"
		--		so replace all hyphens with spaces for the sake of comparison
		--		it's an issue of the LUA pattern syntax
		text = string.gsub(text,"-"," ")
		name = string.gsub(name,"-"," ")
		-- look for the text as a substring anywhere in the name
		local ndxMatch = string.find( name, text )
		if not (ndxMatch and (ndxMatch >= 0)) then
			-- the substring was not found, so this is not a match
			--self:DebugMsg(funcname, string.format("text \"%s\" failed on name \"%s\"",text,name))
			return false
		end
		-- else, don't return true yet because we still need to check the rank filter
	end
	
	-- check rank filter
	if self:IsSelectedEventTypeFilterRankable() then
		local HideSpecialRanks = not (ForceAllRanks or SpeakinSpellSavedData.ShowAllRanks)
		if HideSpecialRanks then
			if DetectedEvent.rank and (DetectedEvent.rank ~= "") then
				-- a rank is specified
				--self:DebugMsg(funcname, "rank failed:"..tostring(DetectedEvent.rank))
				return false
			end
		end
	end

	-- no filters are defined
	--self:DebugMsg(funcname, "pass key:"..tostring(DetectedEvent.key))
	return true
end


function SpeakinSpell:ColorFilterText( DisplayName, BaseColor )
	-- do a case insensitive match to color-code
	local filter = string.lower( SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTextFilter )
	if filter and filter ~= "" then
		local name = string.lower( DisplayName )
		local ndx = string.find( name, filter )
		if ndx == nil then
			return (BaseColor)..tostring(DisplayName)
		end
		
		-- split up the string
		local Start = string.sub( DisplayName, 1, ndx - 1 )
		local Match = string.sub( DisplayName,    ndx, ndx + string.len(filter) - 1 )
		local Rest  = string.sub( DisplayName,         ndx + string.len(filter) )
		
		-- put it back together again
		return tostring(BaseColor)..tostring(Start)..tostring(SpeakinSpellSavedData.Colors.SearchMatch)..tostring(Match)..tostring(BaseColor)..tostring(Rest)
	end
	-- else no search in effect
	return DisplayName
end


-- RecordNewEvent creates and maintains a list of new spells that don't have messages associated with them
-- this list is used to present the user with a list of options when she wants to start announcing a new spell
function SpeakinSpell:RecordNewEvent(de)
	local funcname = "RecordNewEvent"
	
	-- if we already recorded this spell, don't add a duplicate, unless this is a different rank
	-- NOTE: RecordNewEvent is called for both ranked, and rankless versions of the event
	
	if SpeakinSpellSavedDataForAll.NewEventsDetected[de.key] then
		-- this is not a new event, so we're done
		--self:DebugMsg(funcname, self:FormatSubs("New Event seen before <key>: <SpellLink>", de) )
		--self:GUI_CreateNew_OnNewEventDetected(de) -- so this event should already be in the GUI
		return
	end
	
	-- record the new event
	self:DebugMsg(funcname, self:FormatSubs("Found New Event <key>: <SpellLink>", de) )
	SpeakinSpellSavedDataForAll.NewEventsDetected[de.key] = { -- only copy necessary identifying info
		type = de.type,
		name = de.name,
		rank = de.rank,
		key = de.key,
	}
	
	-- update the options GUI to include the new event in the dropdown list
	if self.IsGUILoaded then -- LoD GUI might not be loaded, in which case this is unnecessary
		self:GUI_CreateNew_OnNewEventDetected(de)
	end
end


-- The only way to find a spell ID for a name is to search all possible IDs for a match
-- because of this, we use a cache table to speed up the search for known spells
function SpeakinSpell:GetSpellID( spellname, spellrank )
	local funcname = "GetSpellID"
	
	-- make sure the rank is non-nil
	if not spellrank then
		spellrank = ""
	end
	
	-- determine the key for our cache table
	local cachekey = tostring(spellname)..tostring(spellrank)

	-- check for this name in the cache
	local id = SpeakinSpellSavedDataForAll.SpellIdCache[ cachekey ]
	if id ~= nil then -- NOTE: allow the 0 id for non-spell events
		return id
	end

	-- search all possible spellIds for a match
	local name = ""
	local rank = ""

	for i = 1, 100000 do
		name,rank = GetSpellInfo(i)
		if name then
			local thiskey = tostring(name)..tostring(rank)
			if thiskey == cachekey then
				self:DebugMsg(funcname, string.format("new spellid cachekey:%s=%s", cachekey,tostring(i)) )
				SpeakinSpellSavedDataForAll.SpellIdCache[ cachekey ] = i
				return i
			end
		end
	end

	-- no spell id found
	self:DebugMsg(funcname, string.format("new spellid cachekey:%s=%s", cachekey,tostring(0)) )
	SpeakinSpellSavedDataForAll.SpellIdCache[ cachekey ] = 0
	return 0
end



-----------------------------------------------------------------------------------
-- ValidateSpellIdCache -- Validate the saved SpellId Cache
--
--	This should only be necessary if Blizzard changes the spell ids
--		but is also a general data validation task, in case anything has been corrupted
--		or in case I have programming errors
--		this function iterates the spell id cache to make sure that the names still match the IDs
--
--	if Blizzard ever changes the spell ids, then our saved cache would become invalid
--		that's unlikely
--
--	but if our saved data gets messed up from manual edits or some other problems
--		make sure it isn't saving incorrect information
--
function SpeakinSpell:ValidateSpellIdCache()
	-- if the cache does not exist, create it and we're done
	if not SpeakinSpellSavedDataForAll.SpellIdCache then
		SpeakinSpellSavedDataForAll.SpellIdCache = {}
		return
	end
	
	-- check every entry in the table 
	-- should take fewer iterations that way than for i = 1, 100000 do ...
	-- the id should be usable to query the name
	-- which should be usable to determine the key
	-- which should return the same id we started with, or we need to fix it
	
	local name = ""
	local rank = ""
	for cachekey, id in pairs(SpeakinSpellSavedDataForAll.SpellIdCache) do
		name,rank = GetSpellInfo(id)
		if not name then -- this id is no longer valid
			SpeakinSpellSavedDataForAll.SpellIdCache[cachekey] = nil
		else
			local newkey = tostring(name)..tostring(rank)
			if newkey ~= cachekey then
				self:DebugMsg(funcname, string.format("cachekey:%s, newkey:%s, id:%d", cachekey, newkey, id))
				SpeakinSpellSavedDataForAll.SpellIdCache[cachekey] = nil
				SpeakinSpellSavedDataForAll.SpellIdCache[newkey] = id
			end
		end
	end
end



-- NOTE: GetSpellLink on a name will throw a LUA error on invalid names
--		which is why we had to switch over to spell ids
function SpeakinSpell:SafeGetSpellLink(de)
	-- NOTE: spellid may be either zero or nil if this event is not a spell with an id
	-- NOTE: use spellname for the unclickable links formatted here, which can be subtly different than name/eventname
	
	if not de.spellid then
		if de.type == "MACRO" then
			return tostring(de.name)
		else
			return "["..tostring(de.spellname).."]"
		end
	end

	local SpellLink = GetSpellLink( de.spellid )
	if SpellLink then
		return SpellLink
	else
		return "["..tostring(de.spellname).."]"
	end
end


-- returns rankedkey, ranklesskey
-- if not a rankable event, then ranklesskey will be nil
-- TODOFUTURE: this could return an ordered list of potential keys?
-- maybe for linking UNIT_SPELLCAST_SENT to the matching SPELL_AURA_GAIN 
-- and/or for making speech sets that apply to many spells with the same speech settings
function SpeakinSpell:MakeEventTableKeys( de )
	-- create a unique key for this event
	local rank = de.rank or ""
	de.rankedkey	= self:Keyify( tostring(de.type)..tostring(de.name)..tostring(rank) )
	de.ranklesskey	= self:Keyify( tostring(de.type)..tostring(de.name)                    )
	
	if (not self:IsEventTypeRankable( de.type )) or (de.rankedkey == de.ranklesskey) then
		de.ranklesskey = nil
	end
end


function SpeakinSpell:CreateDetectedEvent( DetectedEventStub )
	local funcname = "CreateDetectedEvent"
	
	local de = self:CopyTable(DetectedEventStub)

	if not de.caster then
		de.caster = UnitName("player")
	end
	
	-- validate the target - get a backup target from selection, focus, or assumed self-cast
	if not de.target or de.target == "" or de.target == "Unknown" then
		de.target = self:GetDefaultTarget(true)
	end
	
	-- fill in any other missing defaults or auto-generated properties
	self:Validate_DetectedEvent( de )
	
	return de
end


-------------------------------------------------------------------------------
-- CHECK OPTIONS IF SPEAKING IS ALLOWED
-------------------------------------------------------------------------------


function SpeakinSpell:SaveInRecentList( de, msg )
	-- save in recent list
	if msg then
		-- save in Speeches
		
		-- make sure this speech is not already in the history list
		for i=1,SpeakinSpell.MAX.RECENT_HISTORY,1 do
			local item = self.RuntimeData.Recent.Speeches[i]
			if item and item.msg == msg then
				return
			end
		end
		-- make room in slot 1
		for i=SpeakinSpell.MAX.RECENT_HISTORY,2,-1 do
			self.RuntimeData.Recent.Speeches[i] = self.RuntimeData.Recent.Speeches[i-1]
		end
		-- save in slot 1
		self.RuntimeData.Recent.Speeches[1] = {
			de = de,
			msg = msg,
		}
	else
		-- save in Events
		-- make sure this speech is not already in the history list
		for i=1,SpeakinSpell.MAX.RECENT_HISTORY,1 do
			local item = self.RuntimeData.Recent.Events[i]
			if item and item.key == de.key then
				return
			end
		end
		-- make room in slot 1
		for i=SpeakinSpell.MAX.RECENT_HISTORY,2,-1 do
			self.RuntimeData.Recent.Events[i] = self.RuntimeData.Recent.Events[i-1]
		end
		-- save in slot 1
		self.RuntimeData.Recent.Events[1] = de
	end
end


function SpeakinSpell:SaveAnnouncementHistory( de, msg )
	-- record info about the last time we announced this event (which should be right now)
	self.RuntimeData.AnnouncementHistory[de.key] = {
		LastMessage = msg,
		LastTime	= GetTime(),
		LastTarget	= de.target,
	}
	self.RuntimeData.AnnouncedThisCombat[de.key] = true
	self:SaveInRecentList(de,msg)
	self.RuntimeData.GlobalCooldownTime = GetTime() --easier than searching or sorting the AnnouncementHistory table
end


function SpeakinSpell:GetLastMessage( de )
	local History = self.RuntimeData.AnnouncementHistory[de.key]
	if History then
		return History.LastMessage
	else
		return nil
	end
end


function SpeakinSpell:CheckSpellFrequency( de )
	-- check the frequency setting against a random number to determine if we should speak or not
	local Chance = math.random(1,100)
	local Frequency = de.EventTableEntry.Frequency*100

	if Chance > Frequency then
		de.chance = Chance
		de.frequency = Frequency
		--self:DebugMsg( "CheckSpellFrequency", self:FormatSubs("random chance failed for <SpellLink> rolled <Chance> > <Frequency>", de) )
		self:ShowWhyNot( de, L["the random chance failed (<frequency>%)"] )
		return false
	end
	
	return true
end


function SpeakinSpell:CheckSpellCooldown( de )
	local funcname = "CheckSpellCooldown"
	
	-- check for a cooldown limit on announcing this spell

	local History = self.RuntimeData.AnnouncementHistory[de.key]
	if not History then
		-- we have not yet announced this spell, so it can't be on cooldown
		return true
	end

	-- calculate elapsed time since last announcement
	-- NOTE: History.LastTime is guaranteed to be a valid value, or we would have aborted above
	local elapsed = GetTime() - History.LastTime

	-- Now finally actually check if the cooldown is in effect
	-- NOTE: "no cooldown" is set by Cooldown=0, so elapsed < 0 will not occur
	if elapsed < de.EventTableEntry.Cooldown then
		-- the cooldown is in effect, so be silent
		de.elapsed = string.format("%d",elapsed) --round off
		de.cd = string.format("%d",de.EventTableEntry.Cooldown)--round off
		de.remaining = string.format("%d",de.EventTableEntry.Cooldown - elapsed)--round off
		--self:DebugMsg( funcname, self:FormatSubs("messaging on cooldown <SpellLink> elapsed:<elapsed>, CD:<cd>", de) )
		self:ShowWhyNot( de, L["this event trigger's cooldown is in effect (<remaining>/<cd> seconds remaining)"] )
		return false
	end
	
	return true
end


function SpeakinSpell:CheckGlobalCooldown()
	local funcname = "CheckGlobalCooldown"
	
	if self.RuntimeData.RecursiveCall then
		-- If one event fires /ss macro as a shared speech list
		-- the /ss macro event should not be silenced by the global cooldown
		-- to the end-user, it's one event
		return true --allow
	end
	
	if not SpeakinSpellSavedData.GlobalCooldown then -- 0 or nil
		return true --cooldown disabled, always allow
	end
	
	if nil == self.RuntimeData.GlobalCooldownTime then --lets assume 0 is a valid time, even though it probably isn't
		-- nothing has been spoken yet, so we can't be on cooldown
		return true --allowed to speak
	end
	
	local elapsed = GetTime() - self.RuntimeData.GlobalCooldownTime
	if elapsed < SpeakinSpellSavedData.GlobalCooldown then
		self:DebugMsg( funcname, "global cooldown is in effect" )
		return false --we're still on cooldown, not allowed to speak
	end
	
	-- cooldown has elapsed
	return true
end


function SpeakinSpell:CheckOncePerTarget( de )
	local funcname = "CheckOncePerTarget"

	if not de.EventTableEntry.OncePerTarget then
		-- "limit once per target" is disabled, so we can always speak
		return true
	end

	local History = self.RuntimeData.AnnouncementHistory[de.key]
	if not History then
		-- we haven't announced this event yet at all, so we can't have announced it for this target
		return true
	end
	
	-- check the last target that was used
	if de.target == History.LastTarget then
		return false
	end
	
	-- we have a new target this time, so we can speak
	return true
end


function SpeakinSpell:CheckOncePerCombat( de )
	local funcname = "CheckOncePerCombat"

	if not de.EventTableEntry.OncePerCombat then
		-- "limit once per combat" is disabled, so we can always speak
		return true
	end
	
	local History = self.RuntimeData.AnnouncementHistory[de.key]
	if not History then
		-- we haven't announced this event yet at all, so we can't have announced it for this target
		return true
	end

--	if not self.RuntimeData.InCombat then
--		-- we're not in combat, so this option should not apply
--		self:DebugMsg( funcname, "Limit once per combat no has no effect because you are not in combat" )
--		return true
--	end
	
	-- AnnouncedThisCombat is reset upon both entering and exiting combat
	if self.RuntimeData.AnnouncedThisCombat[de.key] then
		self:DebugMsg( funcname, "Limit once per combat is in effect for this event key="..tostring(de.key) )
		return false
	end
	
	-- it's a new combat, so go ahead and announce
	return true
end


function SpeakinSpell:ResetOncePerCombatFlags()
	-- forget all the once-per-combat memory
	-- NOTE: this is easier if we track it as a separate table
	--		rather than add data to self.RuntimeData.AnnouncementHistory
	self.RuntimeData.AnnouncedThisCombat = {}
	
	-- NOTE: don't reset last target info when changing combat sessions
	-- because we want "limit once per target" to apply to targets to the same name in multiple pulls
end


function SpeakinSpell:ShowWhyNot( de, reason, func )
	local funcname = "ShowWhyNot"

	if not SpeakinSpellSavedData.ShowWhyNot then
		return
	end
	
	-- this is the complete message format we're going for
	local MessageFormat = L["Announcement of \"<displaylink>\" was silenced because <reason>. <clickhere> to change this setting."]
	local subber = self:CopyTable(de) --so we don't modify the DetectedEvent object
	subber.reason = self:FormatSubs( reason, de ) --provided by caller
	
	-- make the [Click Here] link
	if not func then -- assume this is an event-specific option and offer to open the settings for this event
		func = string.format("SpeakinSpell:OnClickEditEvent(\"%s\")", de.key)
	end
	subber.clickhere = self:MakeClickHereLink( L["[Click Here]"], func )
	
	-- print it
	self:Print( self:FormatSubs( MessageFormat, subber ) )
end


function SpeakinSpell:AllowSpeakForSpell( de )
	local funcname = "AllowSpeakForSpell"
	
	if de.EventTableEntry.DisableAnnouncements then
		self:ShowWhyNot( de, L["this event trigger is disabled"] )
		return false
	end
	
	-- NOTE: even if EnableAllMessages is false, if this is a user macro "/ss macro something" then allow it anyway
	if not SpeakinSpellSavedData.EnableAllMessages and de.type ~= "MACRO" then
		self:ShowWhyNot( de, L["all automated SpeakinSpell announcements are disabled (except for /ss macro events)"], "SpeakinSpell:ShowOptions()" )
		return false
	end
	
	if not self:CheckGlobalCooldown() then
		self:ShowWhyNot( de, L["the global cooldown is in effect"], "SpeakinSpell:ShowOptions()" )
		return false
	end

	if not self:CheckSpellFrequency( de ) then
		--self:ShowWhyNot( de, L["the random chance failed (<chance>%)"] )
		return false
	end
	
	if not self:CheckSpellCooldown( de ) then
		--self:ShowWhyNot( de, L["this event trigger's cooldown is in effect (<elapsed><seconds> sec.)"] )
		return false
	end
	
	if not self:CheckOncePerTarget( de ) then
		if not de.target then
			-- make sure a target name is displayed
			de.target = L["no target selected"]
		end
		self:ShowWhyNot( de, L["this event trigger is limited to once per target (<target>)"] )
		return false
	end
	
	if not self:CheckOncePerCombat( de ) then
		self:ShowWhyNot( de, L["this event trigger is limited to once per combat / once per out-of-combat"] )
		return false
	end
	
	-- no limits or restrictions apply, so go ahead and speak
	return true
end



-- will construct or repair a DetectedEvent (de) object
function SpeakinSpell:Validate_DetectedEvent(de)
	-- fill in missing name, spellname, and/or eventname, as needed
	local name = de.name or de.eventname or de.spellname
	local names = {
		name		= name,
		eventname	= name,
		spellname	= name,
	}
	self:ValidateObject( de, names )
	
	-- check additional defaults
	self:ValidateObject( de, SpeakinSpell.DEFAULTS.DetectedEvent )

	-- de.type is an enumerated table key that must be a valid one of a limited list
	-- if we don't have locale strings for this type, set to the generic "EVENT" type
--	if not SpeakinSpell.EventTypes.IN_SPELL_LIST[de.type] then
--		de.type = "EVENT"
--	end
	-- nope, could be registered by an addon shortly after validate all data on-load
	-- and SpeakinSpell.DEFAULTS.DetectedEvent contains a default "EVENT" if it's totally undefined
	-- so we should be OK
	
	-- make sure rankedkey and ranklesskey are both set
	-- the active ".key" will be updated below
	self:MakeEventTableKeys( de )
	
	-- make sure we have an active key
	-- NOTE: assumed the RANKLESS key if undefined
	if not de.key then
		de.key = de.ranklesskey
		if not de.key then -- doesn't have a rankless key
			de.key = de.rankedkey
		end
	end
end


-- will construct or repair an EventTableEntry (ete) object
function SpeakinSpell:Validate_EventTableEntry( ete )
	local funcname = "Validate_EventTableEntry"
	
	--NOTE: GetDefaultLanguage() doesn't work during loader, or OnInitialize, or OnVariablesLoaded
	SpeakinSpell.DEFAULTS.EventTableEntry.RPLanguage = GetDefaultLanguage("player")
	--self:DebugMsg(funcname, tostring(SpeakinSpell.DEFAULTS.EventTableEntry.RPLanguage) )
	
	self:ValidateObject( ete, SpeakinSpell.DEFAULTS.EventTableEntry )
	ete.Messages = self:StringArray_Compress( ete.Messages ) -- remove empty string indexes and redundant speeches
	self:Validate_DetectedEvent( ete.DetectedEvent )
end


function SpeakinSpell:ValidateAllSavedData()
	local funcname = "ValidateAllSavedData"
	-- NOTE: When creating new data or resetting to defaults
	--		the SavedData.Version number will be set to the current DATA_VERSION prior to entering this function
	--		otherwise, side effects of this function may be used to complete the constructors from the DEFAULTS table in loader.lua
	
	-----------------------------------------------------------------------------------
	-- prior to v3.0.3.08, a version number was not saved in the SpeakinSpellSavedData
	-- create an older version number to force running the first available patch

	if not SpeakinSpellSavedData.Version then
		SpeakinSpellSavedData.Version = "3.0.3.07"
	end
	if not SpeakinSpellSavedDataForAll.Version then
		--this actually gained a version number more recently than this, 
		--but not sure exactly which version, and an older number should be OK
		SpeakinSpellSavedDataForAll.Version = "3.0.3.07"
	end
	
	self:DebugMsg(funcname, "data version - this toon:"..tostring(SpeakinSpellSavedData.Version))
	self:DebugMsg(funcname, "data version - all toons:"..tostring(SpeakinSpellSavedDataForAll.Version))
	self:DebugMsg(funcname, "data version - current v:"..tostring(SpeakinSpell.DATA_VERSION))
	
	-----------------------------------------------------------------------------------
	-- Apply patches if necessary
	
	-- if the saved data was from the current version
	-- we can speed up loading a little by skipping this loop
	-- NOTE: the current user's data version could be newer than the global For All version
	--		in the case of initializing settings for a new toon immediately after a patch
	--		before the global For All data has been patched yet
	if	(SpeakinSpellSavedData.Version		< SpeakinSpell.DATA_VERSION) or 
		(SpeakinSpellSavedDataForAll.Version< SpeakinSpell.DATA_VERSION) or 
		SpeakinSpell.DEBUG_PATCH then
		self:ApplyPatches()
	end
	
	-- global settings and tables - make sure they all exist
	-- this creates new variables that may not have patch functions
	self:ValidateObject( SpeakinSpellSavedData,			SpeakinSpell.DEFAULTS.SpeakinSpellSavedData			)
	self:ValidateObject( SpeakinSpellSavedDataForAll,	SpeakinSpell.DEFAULTS.SpeakinSpellSavedDataForAll	)

	-- also have to dig into sub-tables because ValidateObject can't be recursive
	-- see notes in ValidateObject for details
	self:ValidateObject( SpeakinSpellSavedData.Colors,			SpeakinSpell.DEFAULTS.SpeakinSpellSavedData.Colors	)
	self:ValidateObject( SpeakinSpellSavedData.Colors.Channels,	SpeakinSpell.DEFAULTS.SpeakinSpellSavedData.Colors.Channels	)
	self:ValidateObject( SpeakinSpellSavedDataForAll.Networking,SpeakinSpell.DEFAULTS.SpeakinSpellSavedDataForAll.Networking )
	self:ValidateObject( SpeakinSpellSavedDataForAll.Networking.Share,	SpeakinSpell.DEFAULTS.SpeakinSpellSavedDataForAll.Networking.Share )
	self:ValidateObject( SpeakinSpellSavedDataForAll.Networking.Collect,SpeakinSpell.DEFAULTS.SpeakinSpellSavedDataForAll.Networking.Collect )

	-----------------------------------------------------------------------------------
	-- Validate the saved SpellId Cache
	-- This should only be necessary if Blizzard changes the spell ids
	-- but is also a general data validation task, in case anything has been corrupted
	-- or in case I have programming errors
	self:ValidateSpellIdCache()
	
	-----------------------------------------------------------------------------------
	-- Apply standard error checks and display string updates
	-- even if running the same version as the saved data
	-- this also updates data such as localizable display names
	
	-- TODOLATER: we *should* technically loop across the entire meta table of all toons' event tables
	--		SpeakinSpellSavedDataForAll.Toons[realm][toon].EventTable
	--		but the legacy behavior of only hitting the active character is good enough for now
	-- TODOLATER: this should all actually be a patch function, and doesn't need to be done every time
	--		we should assume completeness unless something changes in a patch
	--		and simply always create a patch function for new stuff
	
	for key, ete in pairs( self:GetActiveEventTable() ) do
		ete.key = key
		ete.DetectedEvent.key = key
		self:Validate_EventTableEntry(ete)
	end
	
	for key, de in pairs(SpeakinSpellSavedDataForAll.NewEventsDetected) do
		de.key = key
		self:Validate_DetectedEvent(de)
		-- unused event hooks don't need to be so complete, so remove a few things
		de.rankedkey = nil
		de.ranklesskey = nil
		de.eventname = nil
		de.spellname = nil
	end

	-- add any new DEFAULT_EVENTHOOKS
	self:ValidateObject( SpeakinSpellSavedDataForAll.NewEventsDetected, DEFAULT_EVENTHOOKS.NewEventsDetected )
end


