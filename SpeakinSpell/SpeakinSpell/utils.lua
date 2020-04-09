-- Author      : RisM
-- Create Date : 6/28/2009 3:54:18 PM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("utils.lua")

-------------------------------------------------------------------------------
-- UTILITY FUNCTIONS
-------------------------------------------------------------------------------


function SpeakinSpell:Keyify( s )
	return string.upper( string.replace( tostring(s), " ", "_" ) )
end

--TODOFUTURE: consider using this function to make code more readable, but slower
function SpeakinSpell:RemoveEmptyTables( t )
	for key,value in pairs( t ) do
		if type(value) == "table" then
			self:RemoveEmptyTables( value )
			if self:IsTableEmpty( value ) then
				t[key] = nil
			end
		end
	end
end


-- Import new contents from Source into existing table Dest
function SpeakinSpell:AddTable(Dest, Source)
	-- create the destination if it doesn't exist
	if Dest == nil then
		Dest = {}
	end
	assert( type(Dest) == "table" )
	
	-- if there's no source, then there's nothing to add
	if Source == nil then
		-- nothing to add
		return Dest
	end
	
	-- add the contents of Source, one item at a time
	for k,v in pairs(Source) do
		-- dig into embedded tables to add those too, not just create references
		if type(v) == "table" then
			-- NOTE: safety checks above will ensure we create Dest[k] if necessary
			Dest[k] = self:AddTable(Dest[k], v)
		else
			Dest[k] = v
		end
	end
	
	return Dest
end


-- create a deep copy of the table and return it
function SpeakinSpell:CopyTable(SourceTable)
	-- adding SourceTable to a new empty table will create a copy
	return self:AddTable(nil, SourceTable)
end

-- add an array of strings
function SpeakinSpell:AddStringArray(Dest, Source)
	for _,s in ipairs(Source) do
		tinsert( Dest, s )
	end
end



-- make sure there are no empty strings or empty array indices in the string list
-- also remove duplicates
function SpeakinSpell:StringArray_Compress( List )
	-- the easiest thing to do is make a new list
	-- build a reverse lookup table of the target array first, to search for duplicates
	-- TODOFUTURE: could do this a faster way i'm sure
	local NewList = {}
	local UniqueCheck = {}
	for i,s in pairs( List ) do
		if (s ~= "") and (not UniqueCheck[s]) then
			local ret = tinsert( NewList, s )
			UniqueCheck[ s ] = true
		end
	end
	return NewList
end


function SpeakinSpell:IsTableEmpty( t )
	if not t then
		return true
	end
	for _,_ in pairs(t) do
		return false
	end
	return true
end


function SpeakinSpell:SizeTable( t )
	if not t then
		return 0
	end
	
	local size = 0
	for _,_ in pairs(t) do
		size = size + 1
	end
	return size
end


function SpeakinSpell:GetGuildName()
	local guildName = GetGuildInfo( UnitName("player") )
	if guildName then
		return guildName
	else
		return L["Your friends"]
	end
end


function SpeakinSpell:GetPlayerFullTitleName()
	local title = GetTitleName( GetCurrentTitle() )
	-- if we don't have a title, then self:StartsWith will error on the nil value
	if not title then
		return UnitName("player")
	end
	-- we have a title, so decide if it comes first or last
	-- blizzard does this by setting a space at the beginning or end for easier string concatenation
	if self:StartsWith(title, " ") then
		return UnitName("player")..tostring(title)
	else
		return title..UnitName("player")
	end
end


function SpeakinSpell:GetDefaultTarget(ShowDebugMsg)
	-- try the currently selected target
	local target = UnitName("target")
	if target then
		if ShowDebugMsg then self:DebugMsg(nil,"<target> is unknown, using <selected>:"..tostring(target)) end
		return target
	end
	
	-- nobody is selected, try focus
	target = UnitName("focus")
	if target then
		if ShowDebugMsg then self:DebugMsg(nil,"<target> is unknown, using <focus>:"..tostring(target)) end
		return target
	end
	
	-- nobody on focus, try mouseover
	target = UnitName("mouseover")
	if target then
		if ShowDebugMsg then self:DebugMsg(nil,"<target> is unknown, using <mouseover>:"..tostring(target)) end
		return target
	end
	
	-- assume self-cast ability
	-- NO this doesn't work out very well in practice (especially battle cries / entering combat)
--	target = UnitName("player")
--	if ShowDebugMsg then self:DebugMsg(nil,"<target> is unknown, using <player>:"..tostring(target)) end
	
	return target
end


-- from UnitID info on wowwiki:
-- player name 
--    As returned by UnitName, GetGuildRosterInfo, GetFriendInfo, COMBAT LOG EVENT, etc. 
--	This must be spelled exactly AND WILL BE INVALID IF THE NAMED PLAYER IS NOT A PART OF YOUR PARTY OR RAID. 
--	As with all other UnitIDs, it is not case sensitive. 
--	This creates a problem for getting race/class info of players outside the party
--	so we try to get a universally-allowed unitid like target if we have them selected
--	Try all of these UnitNames until we get a match, then return it
--	this will be a usable global name for UnitRace or UnitClass (or similar APIs?)

local NameToUnitIDSearchList = {
"target",    --verified works for UnitRace/UnitClass in 3.3.5
"focus",     --verified works for UnitRace/UnitClass in 3.3.5
"mouseover", --verified works for UnitRace/UnitClass in 3.3.5
-- the rest are untested for UnitRace/UnitClass
-- "arenaN" Opposing arena member with index N (1,2,3,4 or 5). 
"arena1",
"arena2",
"arena3",
"arena4",
"arena5",
-- "bossN" The active bosses of the current encounter if available N (1,2,3 or 4). (Added in 3.3.0) 
"boss1",
"boss2",
"boss3",
"boss4",
}

function SpeakinSpell:NameToUnitID( name )
	-- similar to GetDefaultTarget but to get a valid unitId to query race/class for people outside our party or raid
	-- which is not allowed by name, but is allowed if they're your target, focus, or mouseover
	for i,unitId in ipairs(NameToUnitIDSearchList) do
		if UnitName(unitId) == name then
			self:DebugMsg("NameToUnitID", "NameToUnitID:"..tostring(unitId))
			return unitId
		end
	end
	
	return nil
end


function SpeakinSpell:TitleCase(s)
	local first = string.sub(s,1,1)
	local rest = string.sub(s,2,-1)

	first = string.upper(first)
	
	rest = string.gsub(rest, " %a",
		function(match) 
			return string.upper(match)
		end
	)
	
	local result = tostring(first)..tostring(rest)
	return result
end


function SpeakinSpell:StartsWith(s, prefix)
	start = string.sub(s, 1, string.len(prefix))
	return (start == prefix)
end


function SpeakinSpell:EndsWith(s, suffix)
	strend = string.sub(s, -1 * string.len(suffix))
	return (strend == suffix)
end


function SpeakinSpell:ContainsWholeWord(s, word)
	-- force lowercase for case-insensitive matching
	-- and tostring() for safety against lua errors
	local search = strlower( tostring(s) )
	local wordlower = strlower( tostring(word) )
	
	-- use gsub to remove all whole words which are not 'word'
	-- "(%a+)" matches all whole words
	-- TODOFUTURE: this whole function can probably be achieved with a more powerful regular expression 
	--		passed to string.match, containing the word we're looking for, and some regular expression syntax
	--		it would probably run faster
	local found = string.gsub( search, "(%a+)", function(match)
		if match == wordlower then
			return wordlower
		end
		return ""
	end)
	
	-- 'found' now contains only whole words which match 'word'
	-- and white space
	local ndx = string.find(found, wordlower)
	if (ndx ~= nil) and (ndx >= 0) then
		return true
	else
		return false
	end
end


--[[
-- [buildlocales.py copy]
-- SpeakinSpell:IsInWintergraspBattle() uses GetZoneText() to determine if you're in Wintergrasp
-- GetWintergraspWaitTime() indicates that a battle is in progress, but not whether you're there, in it
-- This must match the result of GetZoneText() for your game client
-- which is usually what it says on the minimap
L["Wintergrasp GetZoneText"] = "Wintergrasp"
-- [buildlocales.py end of copy]
--]]

function SpeakinSpell:IsInWintergraspBattle()
	--only applies to active battles
	
	--we only care if a battle is in progress
	--if we're in WG for VOA PVE and the battle is over, switch to raid settings
	if (GetWintergraspWaitTime() ~= nil) then
		-- a battle is not in progress
		return false
	end
	
	--TODOFUTURE: this has a localization problem since it does a string comparison
	-- unfortunately there doesn't appear to be a locale-independant way to test for wintergrasp
	if GetZoneText() == L["Wintergrasp GetZoneText"] then
		return true
	else
		return false
	end
end


function SpeakinSpell:GetRandomTableEntry( t, last )
	if not t then return nil end
	
	local max = #(t)
	if not (max >= 1) then return nil end
	
	local n = math.random(1, max);
	local sel = t[n]
	
	-- avoid repeating the same message we used last time
	-- unless there's only one in the list
	-- or we don't have a 'last'
	if last and (max > 1) then
		while sel == last do
			n = math.random(1, max);
			sel = t[n]
		end
	end
	
	return sel
end


function SpeakinSpell:GetScenarioKey()
	local funcname = "GetScenarioKey"
	-- NOTE: the EventTableEntry.Channels table stores channel names that are compatible with SendChatMessage
	--	see also CurrentMessagesGUI_OnChannelSelect
	
	local zoneType = select(2, IsInInstance())	
	if zoneType == "arena" then --(IsActiveBattlefieldArena()) is unreliable during prep time
		return "Arena"
	elseif zoneType == "pvp" then --(GetNumBattlefieldScores() > 0) is unreliable during prep time
		return "BG"
	elseif (self:IsInWintergraspBattle()) then --only applies to active battles
		-- NOTE: raid warnings not enabled for WG battles
		return "WG"
	elseif (GetNumRaidMembers() > 0) then
		-- override Raid with Leader if applicable
		if IsRaidLeader() then
			return "RaidLeader"
		elseif IsRaidOfficer() then
			return "RaidOfficer"
		else
			return "Raid"
		end
	elseif (GetNumPartyMembers() > 0) then
		-- override Party with Leader if applicable
		if IsPartyLeader() then
			return "PartyLeader"
		else
			return "Party"
		end
	else -- solo
		return "Solo"
	end
end



function SpeakinSpell:GetLanguageList()
	local funcname = "GetLanguageList"
	--self:DebugMsg(funcname, "entry")
	
	--Create and return a list of RP languages that are known to the player
	--NOTE: this does not include SpeakinSpell proprietary language filters like "Pirate" (TODOFUTURE: or does it?)
	--NOTE: format this table for use in the GUI
	local Langs = {}
	for i=1, GetNumLanguages() do
		local lang = GetLanguageByIndex(i)
		Langs[lang] = lang
	end
	return Langs
end


function SpeakinSpell:GetRacialLanguage()
	-- return GetLanguageByIndex( 2 ) -- appears to be non-deterministically ordered
	local Common = GetDefaultLanguage("player")
	for i=1, GetNumLanguages() do
		local lang = GetLanguageByIndex(i)
		if lang ~= Common then
			return lang
		end
	end
	return Common
end


-- if any key is missing from obj, it will be imported from DefaultObject
function SpeakinSpell:ValidateObject( obj, DefaultObject )
	if not DefaultObject then -- i'd prefer this didn't happen, but let it pass silently
		return
	end
	for key,val in pairs(DefaultObject) do
		if obj[key] == nil then -- NOTE: don't replace "false" values
			if type( DefaultObject[key] ) == "table" then
				obj[key] = self:CopyTable(DefaultObject[key])
			else
				obj[key] = DefaultObject[key]
			end
		--no, this would bring in whole lists of things like messages
		--elseif type( DefaultObject[key] ) == "table" then
		--	self:ValidateObject( obj[key], DefaultObject[key] )
		end
	end
end


function SpeakinSpell:GetAddonMemoryUsedString()
	UpdateAddOnMemoryUsage("SpeakinSpell")
	local subs = {
		kb = string.format("%d",GetAddOnMemoryUsage("SpeakinSpell")), --convert float to whole number of kb
		kbgui = string.format("%d",GetAddOnMemoryUsage("SpeakinSpell_GUI")), --convert float to whole number of kb
	}
	return self:FormatSubs( L["Memory Used: <kb> kb (+<kbgui>kb for the gui)"], subs )
end


-- Load chat channel colors from the chat frame settings
-- NOTE: it takes a while for ChatTypeInfo to be populated, so this doesn't work too early during loading
--		OnVariablesLoaded, the data is still not available, so we have to call this late as-needed in the GUI
--		which is just as well to force us to get the latest settings if they've changed
function SpeakinSpell:LoadChatColorCodes()
	-- NOTE: new colors can be declared with empty strings
	--		keys must be valid chat type names for ChatTypeInfo[]
	SpeakinSpell.Colors.Channels = {
		BATTLEGROUND= "|cffff6b00",
		RAID		= "|cffff6b00",
		GUILD		= "|c4444ff44",
		PARTY		= "|cffaaeeff",
		EMOTE		= "|cffff7b34",
		YELL		= "|cffff2f32",
		RAID_WARNING= "|cffffdbad",
		RAID_BOSS_WHISPER= "",
	}
	
	-- load the game's built-in channel colors from ChatTypeInfo
	for channel,_ in pairs( SpeakinSpell.Colors.Channels ) do
		local info = ChatTypeInfo[channel]
		if info then
			if nil == info.a then
				info.a = 1
			end
			SpeakinSpell.Colors.Channels[channel] = string.format( "|c%02x%02x%02x%02x", 255*info.a, 255*info.r, 255*info.g, 255*info.b )
		end
	end
	
	-- create colors code strings for the SpeakinSpell-created special channels
	if	SpeakinSpellSavedData and 
		SpeakinSpellSavedData.Colors and
		SpeakinSpellSavedData.Colors.Channels then
		for channel,info in pairs( SpeakinSpellSavedData.Colors.Channels ) do
			if nil == info.a then
				info.a = 1
			end
			SpeakinSpell.Colors.Channels[channel] = string.format( "|c%02x%02x%02x%02x", 255*info.a, 255*info.r, 255*info.g, 255*info.b )
		end
	end
end



function SpeakinSpell:StringColorCodeToTable(cc)
	-- cc is a string color code "|caarrggbb" example: "|cff123456"
	-- returns the color code as a table: t.a, t.r, t.g, t.b 
	-- using numbers in the format used by the color picker GUI controls and blizzard APIs
	-- which is a floating point number 0-1 representing the fraction of intensity 0-255
	
	-- extract component colors from the string escape sequence format "|caarrggbb"
	-- the "0x" is needed to make LUA interpret the string to number conversion correctly
	local aa = "0x"..string.sub( cc, 3, 4 )
	local rr = "0x"..string.sub( cc, 5, 6 )
	local gg = "0x"..string.sub( cc, 7, 8 )
	local bb = "0x"..string.sub( cc, 9, 11)
	
	-- convert string hex int "0xff" to floating point fraction or % of 0-255
	-- and store results in a table
	local t = {
		a = aa/255,
		r = rr/255,
		g = gg/255,
		b = bb/255,
	}
	
	return t
end


--Before the transition to using GlobalStrings, we used to define this in the Locale-xxXX.lua file:
--L["Shadowstorm"] = "Shadowstorm" <-- Important to note that GlobalStrings calls Shadowstorm "plague" so this may be reinstated
--GlobalStrings is probably the most accurate/appropriate value we could use
--because that's what it should show in the combat log and elsewhere in the default UI
function SpeakinSpell:DamageSchoolCodeNumberToString(number)
	local Schools = {
		[1] = STRING_SCHOOL_PHYSICAL,
		[2] = STRING_SCHOOL_HOLY,
		[4] = STRING_SCHOOL_FIRE,
		[8] = STRING_SCHOOL_NATURE,
		[12] = STRING_SCHOOL_FIRESTORM,
		[16] = STRING_SCHOOL_FROST,
		[20] = STRING_SCHOOL_FROSTFIRE,
		[24] = STRING_SCHOOL_FROSTSTORM,
		[32] = STRING_SCHOOL_SHADOW,
		[40] = STRING_SCHOOL_SHADOWSTORM,
		[48] = STRING_SCHOOL_SHADOWFROST,
		[64] = STRING_SCHOOL_ARCANE,
		[68] = STRING_SCHOOL_SPELLFIRE,
	}
	if Schools[number] then
		return Schools[number]
	else
		return L["Unknown Damage Type"] --REVIEW: for consistency with the rest of SpeakinSpell, should this return nil? other <substitutions> fail to substitute, rather than say "No Target"
	end
end



--[[
Lots of notes here on the issues surrounding RunSlashCommand below

one possible implementation of RunSlashCmd from wowwiki

-- works for "/help" but not for "/cheer" - it doesn't work on built-in emotes

local _G = _G
local function RunSlashCmd(cmd)
  local slash, rest = cmd:match("^(%S+)%s*(.-)$")
  for name in pairs(SlashCmdList) do
     local i = 1
     local slashCmd
     repeat
        slashCmd = _G["SLASH_"..name..i]
        
        if slashCmd == slash then
           -- Call the handler
           SlashCmdList[name](rest)
           return true
        end
        i = i + 1
     until not slashCmd
  end
end 

	the following method was perfect in 3.3.3, but is now incomplete after 3.3.5.
	CreateFrame("EditBox") is an incomplete object for use with ChatEdit_SendText()
	It seems to work, but as it pops off the stack and does its cleanup
	it tries to deactivate the EditBox, and fails on a bunch of nil values
	I tried experimentally adding stubs to satisfy the nil objects
	but that's impossible based on guessing, without access to the source
	which is in the private code.
	I found an imperfect work-around below
	
	-- create a hidden edit box to parse and send the slash command
	if not SpeakinSpellTempEditBox then
		self:DebugMsg(funcname, "creating SpeakinSpellTempEditBox")
		SpeakinSpellTempEditBox = CreateFrame("EditBox", "SpeakinSpellTempEditBox")
		--ZOMG HAX
		--WoW 3.3.5 overhauled the chat frame with zero documentation
		--I got an error popup saying
		--	Message: ..\FrameXML\ChatFrame.lua line 3421:
		--   attempt to index field 'header' (a nil value)
		--and took a WILD guess that it was a field of SpeakinSpellTempEditBox
		--one nil field error after the next, I experimentally found I could hack around it by adding these stubs
		SpeakinSpellTempEditBox.header = {}
		SpeakinSpellTempEditBox.header.Hide = function() end
		SpeakinSpellTempEditBox.focusLeft = {}
		SpeakinSpellTempEditBox.focusLeft.Hide = function() end
		SpeakinSpellTempEditBox.focusRight = {}
		SpeakinSpellTempEditBox.focusRight.Hide = function() end
		SpeakinSpellTempEditBox.focusMid = {} --focusMid?! Blizz, you are just mocking me now WTF are these things?!
		SpeakinSpellTempEditBox.focusMid.Hide = function() end
		SpeakinSpellTempEditBox.button = {} --TODOFUTURE: this isn't it, it's a field of some other table
		--Hide was already here before 3.3.5, since the beginning
		SpeakinSpellTempEditBox:Hide()
	end

	self:DebugMsg(funcname,"executing slash command: " .. tostring(text) )
	SpeakinSpellTempEditBox:SetText(text)
	ChatEdit_SendText(SpeakinSpellTempEditBox) -- throws a lua error, as-is, without more attached frame objects in the table

-- this doesn't work either
--	DEFAULT_CHAT_FRAME:SetText(text)
--	ChatEdit_SendText(DEFAULT_CHAT_FRAME)

-- nor this
--	DEFAULT_CHAT_FRAME:AddMessage(text)

-- using ChatFrame 1 has the side-effect of erasing something you're in the middle of typing
-- if an event fires an emote while you're trying to type something manually
	ChatFrame1EditBox:SetText(text)
	ChatEdit_SendText(ChatFrame1EditBox)

-- to work around that problem, I tried to GetText then SetText as follows
-- the text is preserved, however the edit box loses focus
-- you have to click it with the mouse to get focus on it again
-- hitting enter resets it to an empty string
	local oldtext = ChatFrame1EditBox:GetText()
	ChatFrame1EditBox:SetText(text)
	ChatEdit_SendText(ChatFrame1EditBox)
	ChatFrame1EditBox:SetText(oldtext)

-- which led me to using ChatFrame 2
-- this suffers the same problem, but since chat frame 2 is usually the combat log
-- the impact is gone
-- and text you were typing in chat frame 1 is not effected
-- while the emote still comes out in chat frame 1 as expected based on chat types
--]]

--[[ 
--in 3.3.5 the following function requires a fragment of XML 
--to fix initialization of the EditBox object
see embeds.xml
	<EditBox name="SpeakinSpellEditBoxTemplate" inherits="ChatFrameEditBoxTemplate" virtual="true">
		<Scripts>
			<OnLoad>
				self.chatFrame = self:GetParent();
				ChatEdit_OnLoad(self);
			</OnLoad>
		</Scripts>
	</EditBox>
--]]


local SpeakinSpellChatEditBox = CreateFrame("EditBox", "SpeakinSpellChatEditBox", UIParent, "SpeakinSpellEditBoxTemplate")

-- NOTE: recursive calls to /ss macros are handled in ProcessChatSlashCommand
--		as well as some additional error logic to see if this function should be called
function SpeakinSpell:RunSlashCommand(text)
	local funcname = "RunSlashCommand"

	-- validate input
	if not text then
		return false
	end
	if type(text) ~= "string" then
		return false
	end
	if ( strsub(text, 1, 1) ~= "/" ) then
		return false
	end
	
	-- OK to send the command	
	self:DebugMsg(funcname,"passing to SpeakinSpellChatEditBox: " .. tostring(text) )
	SpeakinSpellChatEditBox:SetText(text) 
	ChatEdit_SendText(SpeakinSpellChatEditBox)

	self:DebugMsg(funcname,"success" )
	return true
end
