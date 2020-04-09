local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("substitutions.lua")

-------------------------------------------------------------------------------
-- A LIST OF ALL POSSIBLE SUBSTITUTIONS (for testing purposes)
-------------------------------------------------------------------------------

SpeakinSpell.TEST_ALL_SUBS = {
	-- basic DetectedEvent data
	"name",
	"rank",
	"type",
	"key",
	"target", -- has special handling beyond the simple UnitName("target")
	"lasttarget",
	"selected", -- always UnitName("target")
	"caster",
	
	-- UnitName API tests
	"player",
	"mouseover",
	"focus",
	"pet",
	
	-- Substitution Functions from the table below
	"realm",
	"playertitle", -- " of Stormwind", "Merrymaker "
	"playerfulltitle", -- "Stonarius of Stormwind", "Merrymaker Stonarius"
	"guild",
	"home",
	"zone", -- "Stormwind"
	"subzone", -- "The Canals"
	"spelllink", -- clickable
	"targetclass",
	"targetrace",
	"scenario",
	"eventtype",
	"eventtypeprefix",
	"displayname",
	"displaylink",
	"playerclass",
	"playerrace",
	"class", -- same as <playerclass>
	"race", -- same as <playerrace>

	-- alias for other data
	"spellname", -- same as "name"
	"spellrank", -- same as "rank"
	
	-- symbols
	"tm",
	"r",
	"c",
	
	-- time/date formats
	"mdyhms",
	"mdy",
	"hms",
	"md",
	"hm",

	-- numbered party member slots for UnitName API
	"party1",
	"party2",
	"party3",
	"party4",
	"party5",
	"raid1",
	"raid5",
	"raid7",
	"raid12",
	"raid40",
	"arena1",
	"arena2",
	"arena3",
	"arena4",
	"arena5",
	
	-- number party member pets
	"partypet1",
	"partypet2",
	"partypet3",
	"partypet4",
	"partypet5",
	"raidpet2", -- not doing the other raid pets
	
	-- append "target" to UnitName API using a player's name instead of unitId (requires hyphens)
	"Stonarius-target",
	"Stonarius-target-target",
	
	-- random substitutions
	"randomtaunt",
	"randomfaction",
	"randomgirl",
	"randomboy",
	"randomsilly",
	
	-- possessive
	"player's",
	"target's",
	"caster's",
	"randomtaunt's",
	"mouseover's",
	"focus'", -- this is the correct way to specify <focus'> ... NOT <focus's>
	
	-- third person
	"player|me",
	"name|me",
	"mouseover|me",
	
	-- third person possessive
	"player's|my",
	"name's|my",
	"mouseover's|my",

	-- append "target" to UnitName API
	"playertarget",
	"playertargettarget",
	"raid1target",
	"pettarget",
	"pettargettarget",
	"partypet2target",
	
	-- append "target" ... third person possessive
	"mouseovertarget's|my",
	"playertarget's|my",
	"Stonarius-target-target's|my",

	-- gender
	"player*male*female",
	"mouseover*boy*girl",
	"Stonarius-target-target*him*her",
	-- gender... third person possessive
	"mouseover's*his*her|my", -- the possessive form is actually irrelevent because "his" and "her's" are already possessive
	"mouseover*the boy*the girl|me", -- with spaces
	"Stonarius-target-target*him*her|me", -- with target appended
	
	-- slash commands are processed by another subsystem
	--"/cast foo",
	--"/ss macro test",
	--"/ss help",
	--"/ss testallsubs", -- would cause infinite recursion!
}


-------------------------------------------------------------------------------
-- Localization of <substitution> keys
-------------------------------------------------------------------------------


-- We always convert the localized sk.key into English using this table
-- English keys will be converted to themselves
-- For example, German <ziel> will become <target> for use in the function tables below
-- then "target" is a valid table key for the various lookup functions
SpeakinSpell.SubsToEnglish = {
[strlower(NAME)] = "name",
[strlower(RANK)] = "rank",
[strlower(TYPE)] = "type",
[L["key"]] = "key",
[strlower(TARGET)] = "target",
[L["lasttarget"]] = "lasttarget",
[L["selected"]] = "selected",
[strlower(SPELL_TARGET_TYPE0_DESC)] = "caster",
[strlower(PLAYER)] = "player",
[L["mouseover"]] = "mouseover",
[strlower(FOCUS)] = "focus",
[strlower(PET)] = "pet",
[L["realm"]] = "realm",
[L["playertitle"]] = "playertitle",
[L["playerfulltitle"]] = "playerfulltitle",
[strlower(GUILD)] = "guild",
[strlower(HOME)] = "home",
[strlower(ZONE)] = "zone",
[L["subzone"]] = "subzone",
[L["spelllink"]] = "spelllink",
[strlower(TARGET..CLASS)] = "targetclass",
[strlower(TARGET..RACE)] = "targetrace",
[L["scenario"]] = "scenario",
[L["eventtype"]] = "eventtype",
[L["eventtypeprefix"]] = "eventtypeprefix",
[L["displayname"]] = "displayname",
[L["displaylink"]] = "displaylink",
[strlower(PLAYER..CLASS)] = "playerclass",
[strlower(PLAYER..RACE)] = "playerrace",
[strlower(CLASS)] = "class",
[strlower(RACE)] = "race",
[L["spellname"]] = "spellname",
[L["spellrank"]] = "spellrank",
[L["tm"]] = "tm",
[L["r"]] = "r",
[L["c"]] = "c",
[L["mdyhms"]] = "mdyhms",
[L["mdy"]] = "mdy",
[L["hms"]] = "hms",
[L["md"]] = "md",
[L["hm"]] = "hm",
-- list event-specific keys here
[L["text"]] = "text",
[strlower(DAMAGE)] = "damage",
[strlower(COMBATLOG_HIGHLIGHT_SCHOOL)] = "school",
[L["overkill"]] = "overkill",
[L["achievement"]] = "achievement",
[L["desc"]] = "desc",
[L["reward"]] = "reward",
[L["points"]] = "points",
}


-------------------------------------------------------------------------------
-- SUBSTITUTION FUNCTIONS TABLE
-------------------------------------------------------------------------------

local SubstitutionFunctions = {	
["selected"] = function(de) 
	return UnitName("target")
end,
["lasttarget"] = function(de)
	return SpeakinSpell.RuntimeData.LastSpellcastSentTarget
end,
["realm"] = function(de) 
	return GetRealmName()
end,
["playertitle"] = function(de) 
	return GetTitleName( GetCurrentTitle() )
end,
["playerfulltitle"] = function(de) 
	return SpeakinSpell:GetPlayerFullTitleName()
end,
["guild"] = function(de) 
	return SpeakinSpell:GetGuildName()
end,
["home"] = function(de) 
	return GetBindLocation()
end,
["displayname"] = function(de)
	return SpeakinSpell:FormatDisplayName( de )
end,

-- auto-substitutions like MS Word would use
["tm"] = function(de) 
	return "™"	-- Trademark symbol
end,
["r"] = function(de) 
	return "®"	-- Registered Trademark symbol
end,
["c"] = function(de) 
	return "©"	-- Copyright (C)
end,

--	GetRealZoneText is subtly different from GetZoneText re: instance names
--		see http://www.wowwiki.com/API_GetZoneText
--		we want to use GetRealZoneText to use real instance names instead of subzone names
--		<subzone> will use the minimap text for instances
--	GetSubZoneText returns an empty string if you're not in a sub zone
--		GetMinimapZoneText returns the current subzone text shown on the minimap
--		the minimap always shows something = the greater region name if not in a subzone
--		so this is guaranteed to return an appropriate value
["zone"] = function(de) 
	return GetRealZoneText()
end,
["subzone"] = function(de) 
	return GetMinimapZoneText()
end,
["spelllink"] = function(de)
	return SpeakinSpell:SafeGetSpellLink(de)
end,

-- default caster and target information
["caster"] = function(de)
	return UnitName("player")
end,

-- race/class info
-- from UnitID info on wowwiki:
-- player name 
--    As returned by UnitName, GetGuildRosterInfo, GetFriendInfo, COMBAT LOG EVENT, etc. 
--	This must be spelled exactly AND WILL BE INVALID IF THE NAMED PLAYER IS NOT A PART OF YOUR PARTY OR RAID. 
--	As with all other UnitIDs, it is not case sensitive. 
--	This creates a problem for getting race/class info of players outside the party
--	so we try to get a universally-allowed unitid like target if we have them selected
--	see NameToUnitID in utils
    
["targetclass"] = function(de)
	-- UnitClass throws a lua error if 'unit' is nil
	if not de.target then
		--GetDefaultTarget already failed, so <target> will fail and this should fail too
		return nil
	end
	local localizedName, _ = UnitClass( de.target );
	--SpeakinSpell:DebugMsg("targetclass", string.format("%s=%s", tostring(de.target), tostring(localizedName)))
	if not localizedName then
		local unitid = SpeakinSpell:NameToUnitID( de.target )
		if unitid then
			localizedName, _ = UnitClass( unitid );
			--SpeakinSpell:DebugMsg("targetclass", string.format("%s=%s", tostring(unitid), tostring(localizedName)))
			if localizedName ~= de.target then -- NPCs return their own name for their class
				return localizedName
			end
		end
	end
	return localizedName
end,
["targetrace"] = function(de)
	-- UnitRace throws a lua error if 'unit' is nil
	if not de.target then
		--GetDefaultTarget already failed, so <target> will fail and this should fail too
		return nil
	end
	local localizedName, _ = UnitRace( de.target )
	if not localizedName then
		local unitid = SpeakinSpell:NameToUnitID( de.target )
		if unitid then
			localizedName, _ = UnitRace( unitid );
		end
	end
	return localizedName
end,
["playerclass"] = function(de)
	return UnitClass( "player" )
end,
["playerrace"] = function(de)
	return UnitRace( "player" )
end,
-- "race" and "class" default to player's
["class"] = function(de)
	return UnitClass( "player" )
end,
["race"] = function(de)
	return UnitRace( "player" )
end,

-- aliases for other information
["spellname"] = function(de)
	return de.name
end,
["spellrank"] = function(de)
	return de.rank
end,

-- Select a channel to use while in <scenario>
--[[
-- [buildlocales.py copy]
-- The following phrases are the possible values of <scenario>
-- as in the phrase "<displaylink> is silent while in <scenario>."
-- or "Just a sec, I am busy with <scenario>."
-- [buildlocales.py end of copy]
--]]
["scenario"] = function(de)
	local Scenarios = {
		Arena		= L["The Arena"],
		BG			= L["A Battleground"],
		WG			= L["Wintergrasp"],
		RaidLeader	= L["Raid Leadership Mode"],
		RaidOfficer	= L["Raid Officer Mode"],
		Raid		= L["A Raid"],
		Party		= L["A Party"],
		PartyLeader	= L["Party Leadership Mode"],
		Solo		= L["Solo Mode"],
	}
	return Scenarios[ SpeakinSpell:GetScenarioKey() ]
end,

["eventtypeprefix"] = function(de)
	--i.e. "When I Start Casting: "
	if de.type == "TEST" then --not listed in the GUI
		return L["Test Event: "]
	end
	return SpeakinSpell.EventTypes.IN_SPELL_LIST[de.type]
end,

["eventtype"] = function(de)
	--i.e. "Spells, Abilities, and Items (Start Casting)"
	if de.type == "TEST" then --not listed in the GUI
		return L["Test Events"]
	end
	return SpeakinSpell.EventTypes.AS_FILTERS[de.type]
end,

["newline"] = function(de)
	return "\n"
end,

["displaylink"] = function(de)
	-- this displaylink is used by the Report Detected Speech Events diagnostic feature
	-- some events (yellow damage / SPELL_DAMAGE) want to change the default display link format
	-- because of a different eventname from spellname, so that event handler overrides the displaylink member
	-- doing it this way gives us the added feature of supporting a <displaylink> substitution globally for all events
	if de.type == "ACHIEVEMENT" then
		-- the general case would format an achievement event name here as "Achievement earned by [achievement link]"
		-- it would be better to say "Achievement earned by Someone Nearby: [achievement link]"
		return SpeakinSpell:FormatSubs( "<EventTypePrefix><name>: <SpellLink>", de )
	elseif de.type == "MACRO" then
		-- macros break the general case below when they are recursive calls
		-- and the <spelllink> links the name of the spell that triggered the /ss macro (the parent event)
		return SpeakinSpell:FormatSubs( L["<EventTypePrefix><name>"], de )
	else
		-- for most event types this is the same as the DisplayName format, except that the spell name is a clickable link
		return SpeakinSpell:FormatSubs( "<EventTypePrefix><SpellLink>", de )
	end
end,

-- various time/date forms
["mdyhms"] = function(de)
	return date("%m/%d/%y %H:%M:%S",time())
end,

["mdy"] = function(de)
	return date("%m/%d/%y",time())
end,

["hms"] = function(de)
	return date("%H:%M:%S",time())
end,

["md"] = function(de)
	return date("%m/%d",time())
end,

["hm"] = function(de)
	return date("%H:%M",time())
end,


}


-- see substititions.lua for substitution lookup/generation functions
-- random substititions are handled through another system
function SpeakinSpell:LookupSubstitutionFunctionTable( sk, de )
	local Func = SubstitutionFunctions[ sk.key ]
	if Func then
		--self:DebugMsg(nil,"found function for key:"..tostring(sk.key))
		return Func(de)
	else
		--self:DebugMsg(nil,"no function for key:"..tostring(sk.key))
		return nil
	end
end


-------------------------------------------------------------------------------
-- UNIT CHANGES FOR GRAMMAR
-------------------------------------------------------------------------------


-- Applies possessive logic to a substitution
-- if the substitution key was possessive, make the unit possessive as well
function SpeakinSpell:MakeUnitPossessive(sk)
	if sk.nonpossessive then
		sk.unitnonpossessive = sk.unit
		sk.unit = self:MakePossessive( sk.unit )
	end
end


-- Applies Third Person, Gender, or Me logic to the SubstitutionKey (sk)
-- if the unit is me, use "me" text instead of speaking in the third person
-- if gender text was specified for male and female, and the unit gender is known, use the gender text
function SpeakinSpell:PickUnitGenderOrMe(sk)
	if sk.me then
		sk.unit = sk.me
	elseif sk.unitgender and sk.male then
		if sk.unitgender == 2 and sk.male then
			sk.unit = sk.male
		elseif sk.unitgender == 3 and sk.female then
			sk.unit = sk.female
		end
	end
	-- else, sk.unit remains unchanged
end


-------------------------------------------------------------------------------
-- MAIN SEARCH FUNCTION
-------------------------------------------------------------------------------

-- define a search order
--NOTE: de is the parent originating event, and CurrentEvent is either a /ss macro or the same object
local SearchOrder = {
	-- Basic Substitutions from the event information
	[1] = function( sk, de, CurrentEvent )
		return de[ sk.key ]
	end,
	-- In case the Current Event defines something the Parent Event doesn't
	[2] = function( sk, de, CurrentEvent )
		return CurrentEvent[ sk.key ]
	end,
	-- UnitName API Substitutions
	[3] = function( sk, de, CurrentEvent )
		return UnitName( sk.key )
	end,
	-- Custom Function Table defined above
	[4] = function( sk, de, CurrentEvent )
		return SpeakinSpell:LookupSubstitutionFunctionTable( sk, de )
	end,
	-- Random Subtititutions
	[5] = function( sk, de, CurrentEvent )
		local last = SpeakinSpell.RuntimeData.LastRandomSub[sk.key]
		local unit = SpeakinSpell:GetRandomTableEntry( SpeakinSpellSavedDataForAll.RandomSubs[sk.key], last )
		SpeakinSpell.RuntimeData.LastRandomSub[sk.key] = unit
		return unit
	end,
}

-- takes a SubstitutionKey (sk) and a CurrentEvent and searches for the sk.key information
-- sets sk.unit to the matching value
-- grammar features are not applied
function SpeakinSpell:FindUnitForSub( sk, CurrentEvent )
	local funcname = "FindUnitForSub"
	--self:DebugMsg(funcname, "sk.key:"..tostring(sk.key))

	-- Try parent event information first
	local de = CurrentEvent
	if self.RuntimeData.ParentDetectedEvent then
		--self:DebugMsg(funcname, "Using Parent Event Info")
		de = self.RuntimeData.ParentDetectedEvent
	end
	
	-- search through all the tables or functions for a value
	for index,Search in ipairs( SearchOrder ) do
		sk.unit = Search( sk, de, CurrentEvent )
		if sk.unit then
			--self:DebugMsg(funcname, "sk.key:"..tostring(sk.key).." index:"..tostring(index).." sk.unit:"..tostring(sk.unit))
			return sk.unit
		end
	end

	-- unknown -- force it to have a value
	sk.unit = "<"..tostring(sk.key)..">"
	--self:DebugMsg(funcname, "unknown sk.unit:"..sk.unit)
end


-------------------------------------------------------------------------------
-- SUBSTITUTE "ME" OR "GENDER" VALUES
-------------------------------------------------------------------------------


function SpeakinSpell:SubstituteGender( sk, de )
	local funcname = "SubstituteGender"
	
	-- if gender substitutions weren't specified, then forget it
	if not (sk.male or sk.female) then
		return false
	end
	
	-- figure out the gender
	if (not sk.unitgender) or (sk.unitgender == 1) then
		-- try the actual unit name first in case it's a player
		sk.unitgender = UnitSex( sk.unit )
		self:DebugMsg(funcname,string.format("unit(%s) gender:%s", tostring(sk.unit), tostring(sk.unitgender)))
		-- for NPCs, we can't get the gender by name,
		-- but if it's a unitId key like "mouseover" we can get it from the substitution key
		if (not sk.unitgender) or (sk.unitgender == 1) then
			sk.unitgender = UnitSex( sk.key )
			self:DebugMsg(funcname,string.format("key(%s) gender:%s", tostring(sk.key), tostring(sk.unitgender)))
			if (not sk.unitgender) or (sk.unitgender == 1) then
				-- if that sk.key didn't work, try an alternate one
				local altunitid = self:NameToUnitID( sk.unit )
				if altunitid and altunitid ~= sk.key then --dont bother if we already tried this unitid
					sk.unitgender = UnitSex( altunitid )
					self:DebugMsg(funcname,string.format("altunitid(%s) gender:%s", tostring(altunitid), tostring(sk.unitgender)))
				end
			end
			-- if we still don't know the gender, stick with the name
			if (not sk.unitgender) or (sk.unitgender == 1) then
				self:DebugMsg(funcname,string.format("gender unknown"))
				return false
			end
		end
	end
	
	-- if we known the gender, and we have text for that gender, use it to override the name
	if sk.unitgender == 2 and sk.male then
		sk.unit = self:FormatEmbeddedSubs( sk.male, de )
		return true
	elseif sk.unitgender == 3 and sk.female then
		sk.unit = self:FormatEmbeddedSubs( sk.female, de )
		return true
	end
	
	-- we don't have text for this gender
	return false
end


function SpeakinSpell:SubstituteMe( sk, de )
	if sk.me and (sk.unit == UnitName("player")) then
		sk.unit = self:FormatEmbeddedSubs( sk.me, de )
		return true
	else
		return false
	end
end


-------------------------------------------------------------------------------
-- CONVERT A SINGLE SUBSTITUTION VALUE - MAIN
-------------------------------------------------------------------------------

-- 'text' is what comes between the <brackets> not including brackets
-- returns the complete substitution value, with all grammar rules applied, etc
function SpeakinSpell:DoSubstitution( text, DetectedEvent )
	local funcname = "DoSubstitution"

	-- create a SubstitutionKey object to track the parsing and substitution process
	local sk = self:ParseSubstitutionKey( text )
	
	-- Find the 'unit' to which this substitution refers
	-- this guarantee's we have a valid sk.unit
	self:FindUnitForSub( sk, DetectedEvent )
	--self:DebugMsg(funcname, "sk.unit:"..tostring(sk.unit))
	
	-- make sure we save/validate some data after that search
	sk.unit = tostring( sk.unit ) -- in case something funky happened with sub-tables
	
	-- if |me was specified, and it's me, this overrides other grammar rules below
	if self:SubstituteMe( sk, DetectedEvent ) then
		return sk.unit
	end
	
	-- if gender was specified, don't make it overly possessive like <player's*his*her's> -> his's
	if self:SubstituteGender( sk, DetectedEvent ) then
		return sk.unit
	end
	
	-- make the unit possessive if the text was possessive
	self:MakeUnitPossessive( sk )
	return sk.unit
end


-------------------------------------------------------------------------------
-- REPLACE ALL SUBSTITUTIONS IN A STRING - MAIN
-------------------------------------------------------------------------------

--[[
-- [buildlocales.py copy]
-- The wrapping symbols around <substitutions> may be localized
L["<"] = "<"
L[">"] = ">"
-- L["<(.-)>"] is a regular expression match pattern for string.gsub()
-- [buildlocales.py end of copy]
--]]

-- search for substitutions and replace them with values
function SpeakinSpell:FormatSubs(msg, DetectedEvent)
	--self:DebugMsg("FormatSubs",msg)
	return string.gsub(msg, L["<(.-)>"], 
		function(var)  --<var>
			return self:DoSubstitution( var, DetectedEvent ) 
		end
	)
end

--[[
-- [buildlocales.py copy]
-- The wrapping symbols around <target|_embedded substitutions_> may be localized
L["_"] = "_"
-- L["_(.-)_"] is a regular expression match pattern for string.gsub()
-- [buildlocales.py end of copy]
--]]

-- search for substitutions and replace them with values
function SpeakinSpell:FormatEmbeddedSubs(msg, DetectedEvent)
	--self:DebugMsg("FormatSubs",msg)
	return string.gsub(msg, L["_(.-)_"], 
		function(var)  --<var>
			return self:DoSubstitution( var, DetectedEvent ) 
		end
	)
end

function SpeakinSpell:TestAllSubs()
	-- set this up as a detected event
	local DetectedEventStub = {
		-- event descriptors
		name = "SpeakinSpell:TestAllSubs()",
		type = "TEST",
		-- event-specific data for substitutions
		-- None
	}
	local de = self:CreateDetectedEvent( DetectedEventStub )
	
	-- for each substitution in the test list, print...
	-- player="<player>" -- for unknowns
	-- player="Stonius" -- for knowns
	for _,sub in ipairs(SpeakinSpell.TEST_ALL_SUBS) do
		-- this debug/test output is exempt from localization (and pretty simplistic anyway)
		local msg = string.format([[%s="<%s>"]],sub,sub)
		msg = SpeakinSpell:FormatSubs( msg, de )
		self:Print(msg)
	end
end


function SpeakinSpell:Validate_SubstitutionKey(keyword)
	-- for case insensitive matching all substitution keys must be lowercase
	keyword = string.lower(keyword)
	-- it also causes a problem if the user typed the <brackets>
	keyword = string.gsub(keyword, "<", "")
	keyword = string.gsub(keyword, ">", "")
	-- just to be safe, let's also remove any other special chars our parser would look for
	keyword = string.gsub(keyword, "|", "")
	keyword = string.gsub(keyword, "*", "")				
	keyword = string.gsub(keyword, "\'", "")
	--TODOFUTURE: fix the pattern to achieve all that in a single call to string.gsub()
	return keyword
end

