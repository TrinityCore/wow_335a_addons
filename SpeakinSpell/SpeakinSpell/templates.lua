-- Author      : RisM
-- Create Date : 9/24/2009 11:04:29 PM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)
local DEFAULT_SPEECHES = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell_DEFAULT_SPEECHES",	false)

SpeakinSpell:PrintLoading("templates.lua")

-------------------------------------------------------------------------------
-- TEMPLATES FUNCTIONS
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Template: Empty Template
-------------------------------------------------------------------------------
-- This template can be used to erase all settings if you set settings = this
-- It is also used as a validator object, 
-- to ensure that all templates contain expected sub-tables
--
-- A template resembles the SpeakinSpellSavedData data structure
--



local EMPTY_TEMPLATE = {

	--------------------------------------
	-- the name of this template
	name = L["Empty Template"],
	-- a tooltip or short description for this template
	desc = L["An empty template containing no data at all"],
	--------------------------------------

	--------------------------------------
	-- Attributes
	-- Define attributes that describe the kind of player this template is meant for
	-- all attributes are optional - these are used for restrictions on which to show/hide/use
	-- see Template Attributes code below
	Attributes = {
		-- set english race name in ALL CAPS to show/use this template only for this race
		-- race = "DWARF",
		
		-- english class name in ALL CAPS to show/use this template only for this class
		-- class = "MAGE",
		
		-- to use this template as a default on a new install, set
		-- selected = true,
	},
	--------------------------------------

	Content = {
		--------------------------------------
		-- Random Substitutions "Mad Libs" table
		RandomSubs = {
			-- ["randomfaction"] = {"Horde","Alliance"},
		},
		--------------------------------------

		--------------------------------------
		-- Speech Event settings
		EventTable = {
			-- ["eventkey"] = EventTableEntry,
		},
		--------------------------------------
	},
	
} -- end Empty Template

-------------------------------------------------------------------------------
-- Template Attributes / Attribute Test Functions
-------------------------------------------------------------------------------

SpeakinSpell.TemplateAttributes = {

--
-- if ( SpeakinSpell.TemplateAttributes[ key ] ( Template.Attributes[ key ] ) ) then
--		use this template
-- else, don't use it
--
-- but it depends what we want to use it for, so note the various categories of tests
--


---------------------------------------------------------------------------------
-- if ( SHOULD_BE_UNLOADED[ key ] ( Template.Attributes[ key ] ) ) then delete this template
SHOULD_BE_UNLOADED = {

	-- set english race name in ALL CAPS to show/use this template only for this race
	-- race = "DWARF",
	["race"] = function( TemplateAttribute ) 
		local playerRace, englishRace = UnitRace("player"); 
		return ( TemplateAttribute ~= string.upper(englishRace) )
	end,
	
	-- english class name in ALL CAPS to show/use this template only for this class
	-- class = "MAGE",
	["class"] = function( TemplateAttribute ) 
		local playerClass, englishClass = UnitClass("player");
		return ( TemplateAttribute ~= string.upper(englishClass) )
	end,
	
	-- classes = "PRIEST,PALADIN,DRUID,SHAMAN"
	["classes"] = function( TemplateAttribute )
		local playerClass, englishClass = UnitClass("player");
		englishClass = string.upper(englishClass)
		local index = string.find( TemplateAttribute, englishClass )
		local found = ( index and (index >= 0) )
		return (not found)
	end,
	
	-- same deal for HORDE or ALLIANCE (i.e. mage portals, but also could be used for battlecries and other things)
	["faction"] = function( TemplateAttribute )
		local englishFaction = UnitFactionGroup("player")
		return ( TemplateAttribute ~= string.upper(englishFaction) )
	end,
	
	-- All others will be retained in memory
}, -- end SHOULD_BE_UNLOADED

---------------------------------------------------------------------------------
-- if not deleted by an attribute specified above, then...
-- if ( SELECT_BY_DEFAULT_ON_FRESH_INSTALL[ key ] ( Template.Attributes[ key ] ) ) then use by default on a fresh install
SELECT_BY_DEFAULT_ON_FRESH_INSTALL = {

	-- to select this template by default, set
	-- selected = true,
	["selected"] = function( TemplateAttribute ) 
		-- return selected
		return TemplateAttribute
	end,

	-- to show this template as an option, but not use it by default on a fresh install set:
	-- notdefault = true,
	["notdefault"] = function( TemplateAttribute ) 
		-- return selected by default =  NOT-NOT selected by default
		return not TemplateAttribute
	end,
	
	-- All others will be USED BY DEFAULT
	-- (if not deleted by the SHOULD_BE_UNLOADED rules)
}, -- USE_BY_DEFAULT_ON_FRESH_INSTALL

---------------------------------------------------------------------------------
} -- END SpeakinSpell.TemplateAttributes FUNCTION TABLE


---------------------------------------------------------------------------------
-- Execute SHOULD_BE_UNLOADED functions
---------------------------------------------------------------------------------


function SpeakinSpell:Template_DeleteRedundant_Speeches( Template, key )
	local TemplateEvent = Template.Content.EventTable[key]
	if not TemplateEvent.Messages then
		-- this is not an existing event, but the new template event has no speeches
		-- so delete it
		Template.Content.EventTable[key] = nil
		return
	end
	
	local ExistingEvent = self:GetActiveEventTable()[key]
	if not ExistingEvent then
		-- the user doesn't have any speeches for this event
		return
	end

	-- build a Unique Check table
	-- TODOFUTURE: move this UniqueCheck list creation into the ExistingEvent object, and maintain it
	local UniqueCheck = {}
	for i,msg in pairs( ExistingEvent.Messages ) do
		UniqueCheck[msg] = i
	end
	
	-- remove template speeches that the current user is already using
	for i,msg in pairs( TemplateEvent.Messages ) do
		if UniqueCheck[msg] then
			TemplateEvent.Messages[i] = nil
		end
	end
	
	-- remove nil array indexes
	TemplateEvent.Messages = self:StringArray_Compress( TemplateEvent.Messages )
	
	-- remove empty tables and resulting empty parent tables
	if self:IsTableEmpty( TemplateEvent.Messages ) then
		Template.Content.EventTable[key] = nil
	end
	if self:IsTableEmpty( Template.Content.EventTable ) then
		Template.Content.EventTable = nil
	end
	-- NOTE: don't delete Template.Content or Template yet
end


function SpeakinSpell:Template_DeleteRedundant_RandomSubs( Template, key )
	local ExistingSubsList = SpeakinSpellSavedDataForAll.RandomSubs[key]
	if not ExistingSubsList then
		-- everything we have in this template is unique
		return
	end
	
	-- build a Unique Check table
	-- TODOFUTURE: move this UniqueCheck list creation into a RandomSub object
	local UniqueCheck = {}
	for i,word in pairs( ExistingSubsList ) do
		UniqueCheck[word] = i
	end
	
	-- delete words that the player is already using
	local TemplateSubsList = Template.Content.RandomSubs[key]	
	for i,word in pairs( TemplateSubsList ) do
		if UniqueCheck[word] then
			TemplateSubsList[i] = nil
		end
	end
	
	-- fill nil array indices
	Template.Content.RandomSubs[key] = self:StringArray_Compress( TemplateSubsList )
	
	-- remove empty tables and resulting empty parent tables
	if self:IsTableEmpty( Template.Content.RandomSubs[key] ) then
		Template.Content.RandomSubs[key] = nil
	end
	if self:IsTableEmpty( Template.Content.RandomSubs ) then
		Template.Content.RandomSubs = nil
	end
	-- NOTE: don't delete Template.Content or Template yet
end


function SpeakinSpell:Template_DeleteRedundantContent( Template )
	-- EventTable
	if Template.Content.EventTable then
		for key,_ in pairs( Template.Content.EventTable ) do
			self:Template_DeleteRedundant_Speeches( Template, key )
		end
	end
	-- delete the entire EventTable if it is now empty
	if self:IsTableEmpty( Template.Content.EventTable) then
		Template.Content.EventTable = nil
	end
	-- RandomSubs
	if Template.Content.RandomSubs then
		for key,_ in pairs( Template.Content.RandomSubs ) do
			self:Template_DeleteRedundant_RandomSubs( Template, key )
		end
	end
	-- delete the entire RandomSubs table if it is now empty
	if self:IsTableEmpty( Template.Content.RandomSubs) then
		Template.Content.RandomSubs = nil
	end
end


function SpeakinSpell:Template_DeleteIncompatibleTemplates( Template )
	-- check attributes for incompatible templates
	for key,Attribute in pairs( Template.Attributes ) do
		ShouldBeUnloaded = SpeakinSpell.TemplateAttributes.SHOULD_BE_UNLOADED[ key ]
		if ShouldBeUnloaded and ShouldBeUnloaded( Attribute ) then
			--self:DebugMsg(funcname, string.format("Template \"%s\" unloaded because %s = %s", Template.name, key, Attribute ) )
			return true -- delete
		end
	end
	return false -- don't delete
end


function SpeakinSpell:DeleteUnusableTemplates( checkredundancy )
	local funcname = "DeleteUnusableTemplates"
	
	for key,Template in pairs( SpeakinSpell.DEFAULTS.Templates ) do
		-- check attributes for incompatible templates
		if self:Template_DeleteIncompatibleTemplates( Template ) then
			-- delete
			SpeakinSpell.DEFAULTS.Templates[key] = nil
		elseif checkredundancy then
			-- check for and remove redundant content that the player is already using
			self:Template_DeleteRedundantContent( Template )
			-- if the template is now empty, delete it
			if self:IsTableEmpty( Template.Content ) then
				self:DebugMsg(funcname, string.format("Deleting empty template: %s",Template.name) )
				SpeakinSpell.DEFAULTS.Templates[key] = nil
			end
		end
	end
end


function SpeakinSpell:DeleteUnselectedTemplates()
	local funcname = "DeleteUnselectedTemplates"
	
	local Templates = SpeakinSpell.DEFAULTS.Templates
	for key,t in pairs( Templates ) do
		if not (t.Attributes and
				t.Attributes.selected) then
			self:DebugMsg(funcname, t.name)
			Templates[key] = nil
		end
	end
end


---------------------------------------------------------------------------------
-- Execute SELECT_BY_DEFAULT_ON_FRESH_INSTALL functions
---------------------------------------------------------------------------------


function SpeakinSpell:Template_UseAsStarterDefault( Template, PreserveOtherToons )
	local funcname = "Template_UseAsStarterDefault"
	
	if PreserveOtherToons then -- we have some speeches setup for other toons, and we use a shared table
		-- don't import speeches that were already imported/reviewed/deleted on a different toon
		-- that means this template needs to match race or class
		if	(nil == Template.Attributes.race) and 
			(nil == Template.Attributes.class) and
			(nil == Template.Attributes.classes) then
			-- this is a generic template, so it has already been used as a starter default on a different toon
			self:DebugMsg(funcname, string.format("Template \"%s\" not selected because it was already used on a different toon (probably)", tostring(Template.name), tostring(key), tostring(Attribute)) )
			return false
		end 
		
		if Template.Attributes.classes then
			-- if this set of classes was already imported, then don't reimport
			local playerClass, englishClass = UnitClass("player");
			englishClass = string.upper(englishClass)
			local index = string.find( Template.Attributes.classes, englishClass )
			local found = ( index and (index >= 0) )
			if not found then
				-- not for this class anyway
				self:DebugMsg(funcname, string.format("Template \"%s\" not selected because it's not for this class", tostring(Template.name), tostring(key), tostring(Attribute)) )
				return false
			end
			-- TODOFUTURE: how can we tell what the race/class was of the other toons that we already imported?
			--		that requires additional saved data (probably?) prompt?
			--		for now just go ahead and re-import general/common speeches
		end
		if Template.Attributes.race then
			-- if this race was already imported, then don't reimport
			local playerRace, englishRace = UnitRace("player"); 
			englishRace = string.upper(englishRace)
			if Template.Attributes.race ~= englishRace then
				-- not for this race anyway
				self:DebugMsg(funcname, string.format("Template \"%s\" not selected because it's not for this race", tostring(Template.name), tostring(key), tostring(Attribute)) )
				return false
			end
			-- TODOFUTURE: how can we tell what the race/class was of the other toons that we already imported?
			--		that requires additional saved data (probably?) prompt?
			--		for now just go ahead and re-import general/common speeches
		end
	end
	
	for key,Attribute in pairs( Template.Attributes ) do
		SelectedByDefault = SpeakinSpell.TemplateAttributes.SELECT_BY_DEFAULT_ON_FRESH_INSTALL[ key ] -- [buildlocales.py No Warning] dumb text match of "L[" substring
		if SelectedByDefault then
			if SelectedByDefault( Attribute ) then
				return true
			else
				self:DebugMsg(funcname, string.format("Template \"%s\" not selected because %s=%s", tostring(Template.name), tostring(key), tostring(Attribute)) )
				return false -- the item is not selected
			end
		end
	end

	-- we didn't find any attributes we care about
	-- so don't select it
	self:DebugMsg(funcname, string.format("Template \"%s\" not selected because it has no interesting attributes",Template.name) )
	return false
end


function SpeakinSpell:ImportDefaultStarterSpeeches()
	if self:IsTableEmpty( self.DEFAULTS.Templates ) then
		self:Templates_Load()
	end
	
	local PreserveOtherToons = SpeakinSpellSavedDataForAll.AllToonsShareSpeeches and (not self:IsTableEmpty( self:GetActiveEventTable() ))
	
	for key,Template in pairs( SpeakinSpell.DEFAULTS.Templates ) do
		if self:Template_UseAsStarterDefault( Template, PreserveOtherToons ) then
			self:ImportTemplate( Template ) 
		end
	end

	--NOTE: even if the GUI is showing right now, we have dramatically changed the available template content
	-- go ahead and release it.  if necessary we'll force a GUI refresh
	self:Templates_Release()
end


---------------------------------------------------------------------------------
-- Initialize Template Info
---------------------------------------------------------------------------------


-- format name with a type prefix to fix list sorting
-- NOTE: lists are sorted by KEY, so do this before copying name to key
function SpeakinSpell:Template_MakeKey( name, LTYPE )
	local subs = {
		type = LTYPE,
		name = name,
	}
	return self:FormatSubs( L["(<type>) <name>"], subs )
end


function SpeakinSpell:LoadTemplate( t, LTYPE )
	local funcname = "LoadTemplate"

	-- use the name as a table key so we can easily find this
	-- NOTE: table keys got more complicated to sort the list better
	local key = self:Template_MakeKey( t.name, LTYPE )
	
	if not key then
		self:ErrorMsg(funcname, "t.name is nil")
		return
	end
	
	-- duplicate names are not allowed
	if self.DEFAULTS.Templates[ key ] then
		self:ErrorMsg(funcname, "duplicate template key: "..key)
		return
	end
	
	-- make a working copy of the (incomplete) template object from DEFAULT_SPEECHES or generated
	self.DEFAULTS.Templates[ key ] = self:CopyTable( t )
	
	-- add missing and automated data to the working copy
	local new = self.DEFAULTS.Templates[ key ]
	new.key = key
	new.name = key
	self:ValidateObject( new, EMPTY_TEMPLATE )
end


function SpeakinSpell:Templates_Load()
	-- make a working copy of the default speech templates
	-- while loading, make all templates self-aware of their keys
	-- and rekey the table on the template names instead of auto-numbered
	-- so that the list in the GUI will sort
	self.DEFAULTS.Templates = {}
	for i,t in pairs( DEFAULT_SPEECHES.Templates ) do
		self:LoadTemplate( t, L["BUILT-IN"] )
	end
	
	-- add a default template of <randomstuff> from <guild> and other info
	self:Template_BuildAuto_Random()
	self:Template_BuildAuto_MountRedirects() -- adds to Templates["Mounts and Pets"]
	
	-- add content from my other toons
	self:Templates_AddMyOtherToons()
	
	-- add shared content that we received over the network
	self:Templates_AddSharedNetworkContent()
	
	-- delete default speeches from RAM if they don't apply to this race/class
	self:DeleteUnusableTemplates( true )	
end


-- NOTE: we'll reload this data if needed
--	when the GUI is opened, of to reset to defaults or whatever
function SpeakinSpell:Templates_Release()
	--self:DeleteUnselectedTemplates()
	--self:DebugMsg(nil,"--Templates--")
	--self:DebugMsgDumpTable( self.DEFAULTS.Templates, "Templates", 2 )
	self.DEFAULTS.Templates = nil
	self.DEFAULTS.Templates = {}
end


function SpeakinSpell:Templates_Reset()
	self:Templates_Release()
end


function SpeakinSpell:Templates_OnInitialize()
	-- DEFAULT_SPEECHES.NEWSPELL -> SpeakinSpell.DEFAULTS.EventTableEntry.Messages
	--TODOFUTURE: change DEFAULT_SPEECHES.NEWSPELL to a Template
	--NOTE: this currently doesn't need to be done in Reset, but would be if this were a user-editable template
	SpeakinSpell.DEFAULTS.EventTableEntry.Messages = self:CopyTable( DEFAULT_SPEECHES.NEWSPELL )
end


-------------------------------------------------------------------------------
-- Build the Auto-Random Template
-------------------------------------------------------------------------------



function SpeakinSpell:Template_BuildAuto_Random()
	local t = {
		name = "Auto-Generated Random Template",
		desc = "Adds Auto-Generated <randomtaunt> and <randomfaction> names based on your guild and arena teams",
		Attributes = {
			selected = true,
		},
		Content = {
			RandomSubs = {
				["randomfaction"] = {},
				["randomtaunt"] = {},
			},
		},
	}
	
	-- Query guild and arena team names
	
	local Factions = {
		-- guildName, guildRankName, guildRankIndex = GetGuildInfo(unit);
		guildName = GetGuildInfo( UnitName("player") ),
		-- teamName, teamSize, teamRating, weekPlayed, weekWins, seasonPlayed, seasonWins, playerPlayed, seasonPlayerPlayed, teamRank, playerRating = GetArenaTeam(id);
		arena2 = GetArenaTeam(1),
		arena3 = GetArenaTeam(2),
		arena5 = GetArenaTeam(3),
	}
	--TODOLATER: these queries on not working on a first time clean install, but they do work on /ss reset ... i think it's a load timing issue
	--self:DebugMsgDumpTable( Factions, "Affiliations", 2 )
	
	-- Add all to <randomfaction>
	for _,name in pairs(Factions) do
		if (name ~= nil) and (name ~= "") then
			tinsert( t.Content.RandomSubs["randomfaction"], name )
		end
	end
		
	-- Add "Enemy Of..." to <randomtaunt>
	for _,name in pairs(Factions) do
		if (name ~= nil) and (name ~= "") then
			local subs = {
				name = name,
			}
			tinsert( t.Content.RandomSubs["randomtaunt"], self:FormatSubs(L["Enemy of <name>"], subs) )
		end
	end

	-- add this to SpeakinSpell.DEFAULTS.Templates
	self:LoadTemplate( t, L["AUTO"] )
end



-- returns one of the following
--"/ss macro mount"
--"/ss macro mount swim"
--"/ss macro mount qiraj"
--"/ss macro mount flight"
--"/ss macro mount flight fast"
--"/ss macro mount flight 310"
--"/ss macro mount ground"
--"/ss macro mount ground fast"
function SpeakinSpell:DetermineMountClass( tooltip )

	if not tooltip then
		return "/ss macro mount" -- generic any mount
	end
	
	-- this if-else logic was borrowed from Mountiful
	-- code style and actions taken have been changed for SpeakinSpell purposes
	if ( string.find(tooltip, L["swimmer"]) ) then
		return "/ss macro mount swim"
	elseif ( string.find(tooltip, L["Qiraj"]) ) then
		return "/ss macro mount qiraj"
	elseif string.find(tooltip, L["changes"]) and string.find(tooltip, L["location"]) then -- Catches mounts that change depending on location and skill --headless horseman mount
		return "/ss macro mount ground"
	elseif string.find(tooltip, L["changes"]) and not string.find(tooltip, L["Outland"]) then -- Catches mounts that change depending on skill
		return "/ss macro mount flight"
	elseif string.find(tooltip, L["Outland"]) then -- Catches flying mounts
		if string.find(tooltip, L["extremely"]) then -- Catches 310% mounts
			return "/ss macro mount flight 310"
		elseif(string.find(tooltip, L["changes"])) then -- Catches flying mounts that change depending on skill
			return "/ss macro mount flight"
		elseif (string.find(tooltip, L["very"]))then -- Catches epic flyers
			return "/ss macro mount flight fast"
		else
			return "/ss macro mount flight"
		end
	elseif not string.find(tooltip, L["Outland"]) then
		if string.find(tooltip, L["very"])then
			return "/ss macro mount ground fast"
		else
			return "/ss macro mount ground"
		end
	end
end


function SpeakinSpell:Template_BuildAuto_MountRedirects()
	local funcname = "Template_BuildAuto_MountRedirects"
	
	local oldkey = self:Template_MakeKey( L["Mounts and Pets"], L["BUILT-IN"] ) 

	-- Add these bindings to the Mounts and Pets template
	local Template = SpeakinSpell.DEFAULTS.Templates[oldkey]
	if not Template then
		self:ErrorMsg(funcname, "Template is nil")
		return
	end
	local EventTable = Template.Content.EventTable
	if not EventTable then
		self:ErrorMsg(funcname, "EventTable is nil")
		return
	end
	
	-- move this to a different key as TYPE="AUTO"
	local newkey = self:Template_MakeKey( L["Mounts and Pets"], L["AUTO"] ) 
	SpeakinSpell.DEFAULTS.Templates[newkey] = Template
	SpeakinSpell.DEFAULTS.Templates[oldkey] = nil
	Template.key = newkey
	Template.name = newkey
	
	-- search for all pets
	for i=1,GetNumCompanions("CRITTER") do
		local creatureID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("CRITTER", i);
		local key = self:Keyify( "UNIT_SPELLCAST_SENT".. tostring(creatureName) )
		local macro = "/ss macro pet"	
		EventTable[key] = {
			DetectedEvent = {
				type = "UNIT_SPELLCAST_SENT",
				name = creatureName,
			},
			Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
			-- redirect all mount "spells" to /ss macro mount, to share the speech list
			Messages = {macro},
			--ReadOnly = {[macro] = 1}, -- this works, but i don't think read-only flags should ever be enabled by default
			Frequency = 0.1,-- default to 10% chance
			Cooldown = 120,	-- and 2 min cooldown
			-- all other settings use defaults
		}
	end
	
	-- search for all mounts
	if not SpeakinSpell.TooltipCatcher then
		SpeakinSpell.TooltipCatcher = CreateFrame("GameTooltip", "SpeakinSpellTooltipCatcher", nil, "GameTooltipTemplate") 
		SpeakinSpell.TooltipCatcher:SetOwner(WorldFrame,"ANCHOR_NONE")  --(from Mountiful) fixes the deathcharger bug.  why?  who knows.  it works though.
	end
	
	for i=1,GetNumCompanions("MOUNT") do
		local creatureID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("MOUNT", i);
		local key = self:Keyify( "UNIT_SPELLCAST_SENT".. tostring(creatureName) )
		local macro = "/ss macro mount" -- by default unless we can figure out what kind of mount below
		
		-- determine type of mount
		local link = GetSpellLink(creatureSpellID)
		SpeakinSpell.TooltipCatcher:SetHyperlink(link) -- Set link for tooltip
		local tooltip = _G["SpeakinSpellTooltipCatcherTextLeft"..3]:GetText() -- Get the description text from the tooltip
		local macro = self:DetermineMountClass( tooltip )
		
		-- build the EventTableEntry for this mount summoning event
		EventTable[key] = {
			DetectedEvent = {
				type = "UNIT_SPELLCAST_SENT",
				name = creatureName,
			},
			Channels = SpeakinSpell:CopyTable( SpeakinSpell.DEFAULTS.MOUNT_CHANNELS ),
			-- redirect all mount "spells" to /ss macro mount, to share the speech list
			Messages = {macro},
			--ReadOnly = {[macro] = 1}, -- this works, but i don't think read-only flags should ever be enabled by default
			Frequency = 0.1,-- default to 10% chance
			Cooldown = 120,	-- and 2 min cooldown
			-- all other settings use defaults
		}
	end
end


---------------------------------------------------------------------------------
-- IMPORT A WHOLE TEMPLATE (main table iterator functions)
---------------------------------------------------------------------------------


function SpeakinSpell:ImportTemplate_MergeExistingEvent( Template, key )
	local funcname = "ImportTemplate_MergeExistingEvent"
	self:DebugMsg(funcname, "key:"..tostring(key))
	
	-- validate parameters
	if not Template then
		self:ErrorMsg(funcname, "Template is nil")
		return
	end
	if not key then
		self:ErrorMsg(funcname, "key is nil")
		return
	end
	
	--- safely dig into the meaningful tables that we need
	local ExistingEvent = self:GetActiveEventTable()[key]
	if not ExistingEvent then
		self:ErrorMsg(funcname, "ExistingEvent is nil")
		return
	end
	local ExistingMessages = ExistingEvent.Messages
	if not ExistingMessages then
		self:ErrorMsg(funcname, "ExistingMessages is nil")
		return
	end
	
	local TemplateEvent = Template.Content.EventTable[key]
	if not TemplateEvent then
		self:ErrorMsg(funcname, "TemplateEvent is nil")
		return
	end
	local TemplateMessages = TemplateEvent.Messages
	if not TemplateMessages then
		self:ErrorMsg(funcname, "TemplateMessages is nil")
		return
	end

	if self:IsTableEmpty( TemplateMessages ) then
		self:ErrorMsg(funcname, "TemplateMessages is empty")
		return
	end
	
	--self:DebugMsgDumpTable( ExistingMessages, "ExistingMessages", 2 )
	--self:DebugMsgDumpTable( TemplateMessages, "TemplateMessages", 2 )

	-- merge an existing event's message list
	self:AddStringArray( ExistingMessages, TemplateMessages )
	ExistingEvent.Messages = self:StringArray_Compress( ExistingMessages )
	
	-- report progress
	self:Import_PrintProgress( L["Merged speeches for <displayname>"], ExistingEvent.DetectedEvent )
	
	-- the Template.Content.EventTable[key] is now redundant with used content
	Template.Content.EventTable[key] = nil
	
	-- clean up empty parent tables in the template if we used up all the content
	if self:IsTableEmpty( Template.Content.EventTable ) then
		Template.Content.EventTable = nil
	end
	if self:IsTableEmpty( Template.Content ) then
		SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
	end
end


function SpeakinSpell:Template_DeleteOneSpeech( Template, key, index )
	local TemplateEvent = Template.Content.EventTable[key]

	if not TemplateEvent then
		return
	end
	
	-- the TemplateEvent.Messages[ index ] is now redundant with used content
	-- if that was the last new speech in the template, delete it
	TemplateEvent.Messages[ index ] = nil
	
	-- clean up empty parent tables
	if self:IsTableEmpty(TemplateEvent.Messages) then
		Template.Content.EventTable[key] = nil
	end

	if self:IsTableEmpty( Template.Content.EventTable ) then
		Template.Content.EventTable = nil
	end
	
	if self:IsTableEmpty( Template.Content ) then
		SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
	end
end


function SpeakinSpell:Template_DoAddEventToSavedData( Event, key )
	-- validate parameters
	if not Event then
		self:ErrorMsg( funcname, "Event is nil")
		return
	end
	if not key then
		self:ErrorMsg( funcname, "key is nil")
		return
	end
	
	-- save the object
	self:GetActiveEventTable()[key] = Event
	self:Validate_EventTableEntry( Event )
	
	-- allow the new item to show in the GUI without a new manual search
	self.RuntimeData.OptionsGUIStates.MessageSettings.FilterChanged = true
	-- NOTE: doesn't effect "Create New" GUI
end


function SpeakinSpell:ImportTemplate_AddOneSpeech( Template, key, index )
	local funcname = "ImportTemplate_AddOneSpeech"
	
	-- validate parameters
	if not Template then
		self:ErrorMsg(funcname, "Template is nil")
		return
	end
	if not key then
		self:ErrorMsg(funcname, "key is nil")
		return
	end
	if not index then
		self:ErrorMsg(funcname, "index is nil")
		return
	end

	-- get the new Event
	local TemplateEvent = Template.Content.EventTable[key]
	if not TemplateEvent then
		self:ErrorMsg(funcname, "TemplateEvent is nil")
		return
	end
	
	-- get the new speech
	local NewSpeech = TemplateEvent.Messages[ index ]
	if not NewSpeech then
		self:ErrorMsg(funcname, "TemplateEvent is nil")
		return
	end
	
	-- get the existing Event
	local ExistingEvent = self:GetActiveEventTable()[key]
	if not ExistingEvent then
		-- this can happen, not an error
		-- copy the basic settings for the event, to make a place for this speech
		ExistingEvent = self:CopyTable( TemplateEvent )
		ExistingEvent.Messages = {} -- we only want 1 of these speeches, and we'll get it below
		self:Template_DoAddEventToSavedData( ExistingEvent, key )
	end
	
	-- get the target table
	local ExistingMessageList = ExistingEvent.Messages
	if not ExistingMessageList then
		self:ErrorMsg(funcname, "ExistingMessageList is nil")
		return
	end

	-- add the new speech to the existing speech list
	tinsert( ExistingMessageList, NewSpeech )
	
	-- report progress
	local subs = {
		speech = NewSpeech,
	}
	self:Import_PrintProgress( L["Added speech: <speech>"], subs )
	
	-- the TemplateEvent.Messages[ index ] is now redundant with used content
	-- if that was the last new speech in the template, delete it
	self:Template_DeleteOneSpeech( Template, key, index )
end


function SpeakinSpell:ImportTemplate_AddNewEvent( Template, key )
	local funcname = "ImportTemplate_AddNewEvent"
--	self:DebugMsg(funcname, "key:"..tostring(key))
	
	-- validate parameters
	if not Template then
		self:ErrorMsg(funcname, "Template is nil")
		return
	end
	if not key then
		self:ErrorMsg(funcname, "key is nil")
		return
	end
	
	-- safely dig into the relevant tables
	local TemplateEvent = Template.Content.EventTable[key]
	if not TemplateEvent then
		self:ErrorMsg(funcname, "TemplateEvent is nil")
		return
	end
	
	-- create a copy of the event
	local NewEvent = self:CopyTable( TemplateEvent )
	self:Template_DoAddEventToSavedData( NewEvent, key )

	-- report progress
	self:Import_PrintProgress( L["Added speeches for <displayname>"], NewEvent.DetectedEvent )
	
	-- the Template.Content.EventTable[key] is now redundant with used content
	Template.Content.EventTable[key] = nil
	
	-- clean up empty parent tables if we used up all the template content
	if self:IsTableEmpty( Template.Content.EventTable ) then
		Template.Content.EventTable = nil
	end
	if self:IsTableEmpty( Template.Content ) then
		SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
	end
end


function SpeakinSpell:ImportTemplate_AllSpeeches( Template, key )
	local funcname = ""
	
	-- validate parameters
	if not Template then
		self:ErrorMsg(funcname, "Template is nil")
		return
	end
	if not key then
		self:ErrorMsg(funcname, "key is nil")
		return
	end

	-- pass off to merge or add subroutine	
	local ExistingEvent = self:GetActiveEventTable()[key]
	if ExistingEvent then
		self:ImportTemplate_MergeExistingEvent( Template, key )
	else -- completely new event
		self:ImportTemplate_AddNewEvent( Template, key )
	end
end

-- Import data from the EventTable of a Template
function SpeakinSpell:ImportTemplate_Events( Template )
	-- don't bother unless there's content here
	if self:IsTableEmpty( Template.Content.EventTable ) then
		return
	end
	
	-- Merge or Add speech events
	for key,_ in pairs(Template.Content.EventTable) do
		self:ImportTemplate_AllSpeeches( Template, key )
	end
	
	-- the Template.Content.EventTable is now redundant with used content
	Template.Content.EventTable = nil
end


function SpeakinSpell:Template_DeleteOneRandomWord( Template, key, index )
	local SubsList = Template.Content.RandomSubs[key]

	if not SubsList then
		return
	end
	
	-- the TemplateEvent.Messages[ index ] is now redundant with used content
	-- if that was the last new speech in the template, delete it
	SubsList[ index ] = nil
	
	-- clean up empty parent tables
	if self:IsTableEmpty( SubsList ) then
		Template.Content.RandomSubs[key] = nil
	end
	
	if self:IsTableEmpty( Template.Content.RandomSubs ) then
		Template.Content.RandomSubs = nil
	end
	
	if self:IsTableEmpty( Template.Content ) then
		SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
	end
end


function SpeakinSpell:ImportTemplate_AddOneRandomWord( Template, key, index )
	local funcname = "ImportTemplate_AddOneRandomWord"
	
	-- validate parameters
	if not Template then
		self:ErrorMsg(funcname, "Template is nil")
		return
	end
	if not key then
		self:ErrorMsg(funcname, "key is nil")
		return
	end
	if not index then
		self:ErrorMsg(funcname, "index is nil")
		return
	end
	
	-- safely navigate to the tables we need
	local NewSubsList = Template.Content.RandomSubs[key]
	if not index then
		self:ErrorMsg(funcname, "NewSubsList is nil")
		return
	end
	local NewWord = NewSubsList[ index ]
	if not NewWord then
		self:ErrorMsg(funcname, "NewWord is nil")
		return
	end
	if NewWord == "" then
		self:ErrorMsg(funcname, "NewWord is empty")
		return
	end

	local OldSubsList = SpeakinSpellSavedDataForAll.RandomSubs[key]
	if not OldSubsList then
		-- this can happen - not an error
		-- copy the basic settings for the event, and just this one speech
		OldSubsList = {}
		SpeakinSpellSavedDataForAll.RandomSubs[key] = OldSubsList
	end
	
	-- add one word to the subs list
	tinsert( OldSubsList, NewWord )
	
	-- report progress
	local subs = {
		randomkey = key,
		newword = NewWord,
	}
	self:Import_PrintProgress( L["Added <randomkey>: <newword>"], subs )

	-- the TemplateEvent.Messages[ index ] is now redundant with used content
	-- if that was the last new speech in the template, delete it
	self:Template_DeleteOneRandomWord( Template, key, index )
end


function SpeakinSpell:ImportTemplate_ExistingSubsList( Template, keyword )
	local funcname = "ImportTemplate_ExistingSubsList"
	
	-- validate parameters
	if not Template then
		self:ErrorMsg(funcname, "Template is nil")
		return
	end
	if not keyword then
		self:ErrorMsg(funcname, "keyword is nil")
		return
	end
	
	-- safely retrieve relevant tables
	local ExistingSubsList = SpeakinSpellSavedDataForAll.RandomSubs[keyword]
	if not ExistingSubsList then
		self:ErrorMsg(funcname, "ExistingSubsList is nil")
		return
	end
	local NewSubsList = Template.Content.RandomSubs[keyword]
	if not NewSubsList then
		self:ErrorMsg(funcname, "NewSubsList is nil")
		return
	end

	-- merge the lists
	self:AddStringArray( ExistingSubsList, NewSubsList )
	SpeakinSpellSavedDataForAll.RandomSubs[keyword] = self:StringArray_Compress( ExistingSubsList )

	-- report progress
	local subs = {
		keyword = L["<"]..tostring(keyword)..L[">"],
	}
	self:Import_PrintProgress( L["Merged word list for <keyword>"], subs )
	
	-- the Template.Content.RandomSubs[keyword] is now redundant with used content
	Template.Content.RandomSubs[keyword] = nil
	
	-- remove empty parent tables
	if self:IsTableEmpty( Template.Content.RandomSubs ) then
		Template.Content.RandomSubs = nil
	end
	if self:IsTableEmpty( Template.Content ) then
		SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
	end
end


function SpeakinSpell:ImportTemplate_NewSubsList( Template, keyword )
	local funcname = "ImportTemplate_NewSubsList"
	
	-- validate parameters
	if not Template then
		self:ErrorMsg(funcname, "Template is nil")
		return
	end
	if not keyword then
		self:ErrorMsg(funcname, "keyword is nil")
		return
	end
	
	-- safely retrieve relevant tables
	local TemplateSubs = Template.Content.RandomSubs[keyword]
	if not TemplateSubs then
		self:ErrorMsg(funcname, "TemplateSubs is nil")
		return
	end

	-- copy this random substitution list
	SpeakinSpellSavedDataForAll.RandomSubs[keyword] = self:CopyTable( TemplateSubs )

	-- report progress
	local subs = {
		keyword = L["<"]..tostring(keyword)..L[">"],
	}
	self:Import_PrintProgress( L["Added word list for <keyword>"], subs )
	
	-- the Template.Content.RandomSubs[keyword] is now redundant with used content
	Template.Content.RandomSubs[keyword] = nil
	
	-- remove empty parent tables
	if self:IsTableEmpty( Template.Content.RandomSubs ) then
		Template.Content.RandomSubs = nil
	end
	if self:IsTableEmpty( Template.Content ) then
		SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
	end
end


function SpeakinSpell:ImportTemplate_AllRandomWords( Template, key )
	local ExistingSubsList = SpeakinSpellSavedDataForAll.RandomSubs[key]
	if ExistingSubsList then
		self:ImportTemplate_ExistingSubsList( Template, key )
	else
		self:ImportTemplate_NewSubsList( Template, key )
	end
end

function SpeakinSpell:ImportTemplate_RandomSubs( Template )
	-- Don't bother unless there's content to import
	if self:IsTableEmpty( Template.Content.RandomSubs ) then
		return
	end
	
	-- Merge or Add all RandomSubs
	for key,SubsList in pairs(Template.Content.RandomSubs) do
		self:ImportTemplate_AllRandomWords( Template, key )
	end
	
	-- the Template.Content.RandomSubs is now redundant with used content
	Template.Content.RandomSubs = nil
end


function SpeakinSpell:Import_PrintProgress( msgformat, subs )
	if SpeakinSpellSavedData.ShowImportProgress or SpeakinSpell.DEBUG_MODE then
		self:Print( self:FormatSubs( msgformat, subs) )
	end
end


function SpeakinSpell:ImportTemplate( Template )
	self:Import_PrintProgress( "----------" )
	self:Import_PrintProgress( L["Importing Template: <name>"], Template )
	
	-- check for and remove redundant content that the player is already using
	self:Template_DeleteRedundantContent( Template )
	
	-- import data 
	-- guaranteed to be all non-redundant new content
	-- these functions are safe to call on empty tables
	self:ImportTemplate_Events		( Template )
	self:ImportTemplate_RandomSubs	( Template )
	
	-- this template is now redundant, so delete it
	SpeakinSpell.DEFAULTS.Templates[ Template.key ] = nil
end


---------------------------------------------------------------------------------
-- add shared network content into the templates
---------------------------------------------------------------------------------


function SpeakinSpell:Templates_AddSharedNetworkContent()
	for creator, EventTable in pairs( SpeakinSpellSavedDataForAll.Networking.CollectedEventTables ) do
		self:Template_AddSharedEventTable( creator, EventTable )
	end
	for creator, RandomSubs in pairs( SpeakinSpellSavedDataForAll.Networking.CollectedRandomSubs ) do
		self:Template_AddSharedRandomSubs( creator, RandomSubs )
	end
end


function SpeakinSpell:Template_AddSharedEventTable( creator, EventTable )
	-- this fake detected event tricks out FormatSubs to work so we can get the 's possessive form logic easily
	local fakede = {
		creator = creator,
	}
	-- package the EventTable in a template object with a name, tooltip, and proper table format
	local t = {
		name = self:FormatSubs(L["<creator's> shared speeches"], fakede),
		desc = self:FormatSubs(L["<creator's> speeches, shared with you over the network"], fakede),
		Attributes = {
			selected = false,
			network = true,
		},
		Content = {
			EventTable = EventTable,
		},
	}
	-- load the template into the working copy
	self:LoadTemplate( t, strupper(PLAYER) )
end


function SpeakinSpell:Template_AddSharedRandomSubs( creator, RandomSubs )
	-- this fake detected event tricks out FormatSubs to work so we can get the 's possessive form logic easily
	local fakede = {
		creator = creator,
	}
	-- package the EventTable in a template object with a name, tooltip, and proper table format
	local t = {
		name = self:FormatSubs(L["<creator's> shared random substitutions"], fakede),
		desc = self:FormatSubs(L["<creator's> random <susbtitution> word lists, shared with you over the network"], fakede),
		Attributes = {
			selected = false,
			network = true,
		},
		Content = {
			RandomSubs = RandomSubs,
		},
	}
	-- load the template into the working copy
	self:LoadTemplate( t, strupper(PLAYER) )
end


---------------------------------------------------------------------------------
-- add content from my other toons
---------------------------------------------------------------------------------


function SpeakinSpell:Templates_AddMyOtherToons()
	for realm, toonlist in pairs(SpeakinSpellSavedDataForAll.Toons) do
		for toon, Settings in pairs(toonlist) do
			self:Template_AddAltToonEventTable( realm, toon, Settings.EventTable )
		end
	end
end


function SpeakinSpell:Template_AddAltToonEventTable( realm, toon, EventTable )
	local funcname = "Template_AddAltToonEventTable"
	
	if toon == UnitName("player") and realm == GetRealmName() then
		-- will be 100% redundant and auto-removed, so skip it
		return
	end
	
	self:DebugMsg(funcname, toon)
	
	-- this fake detected event tricks out FormatSubs to work so we can get the 's possessive form logic easily
	local fakede = {
		toon = toon,
		realm = realm,
	}
	-- package the EventTable in a template object with a name, tooltip, and proper table format
	local t = {
		name = self:FormatSubs(L["<toon's> speeches (<realm>)"], fakede),
		desc = self:FormatSubs(L["<toon's> speeches (your alternate character on <realm>)"], fakede),
		Attributes = {
			selected = false,
			othertoon = true,
		},
		Content = {
			EventTable = EventTable,
		},
	}
	-- load the template into the working copy
	self:LoadTemplate( t, L["ALT"] )
end


function SpeakinSpell:Import_AllAltsToSharedEventTable()
	-- share existing templates functions to import all other alts' speeches into this one
	self.DEFAULTS.Templates = {}
	self:Templates_AddMyOtherToons()
	self:DeleteUnusableTemplates( true )	

	for index,Template in pairs( SpeakinSpell.DEFAULTS.Templates ) do
		self:ImportTemplate( Template )
	end
	
	-- done with templates
	self.DEFAULTS.Templates = nil
	
	--set SpeakinSpellSavedDataForAll.AllToonsEventTable to the active event table
	if not SpeakinSpellSavedDataForAll.AllToonsEventTable then
		SpeakinSpellSavedDataForAll.AllToonsEventTable = self:GetActiveEventTable()
	end
	SpeakinSpellSavedDataForAll.AllToonsShareSpeeches = true -- changes result from GetActiveEventTable()
	
	-- clear the Toon-specific event tables...
	--SpeakinSpellSavedDataForAll.Toons = nil
	-- keep the set of known realms/toons and only erase the EventTables to save memory
	if SpeakinSpellSavedDataForAll.Toons then
		for realm,ToonList in pairs(SpeakinSpellSavedDataForAll.Toons) do
			for toon,ToonSettings in pairs(ToonList) do
				ToonSettings.EventTable = nil
			end
		end
	end
end


function SpeakinSpell:Split_SharedEventTableToAllAlts()
	-- copy the shared speeches to all toons
	if SpeakinSpellSavedDataForAll.Toons then
		for realm,ToonList in pairs(SpeakinSpellSavedDataForAll.Toons) do
			for toon,ToonSettings in pairs(ToonList) do
				ToonSettings.EventTable = self:CopyTable(SpeakinSpellSavedDataForAll.AllToonsEventTable)
			end
		end
	end
	-- done with AllToonsEventTable
	SpeakinSpellSavedDataForAll.AllToonsShareSpeeches = false -- changes result from GetActiveEventTable()
	SpeakinSpellSavedDataForAll.AllToonsEventTable = nil
end
