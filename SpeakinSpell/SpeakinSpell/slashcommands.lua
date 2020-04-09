-- Author      : RisM
-- Create Date : 6/28/2009 4:03:23 PM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)
local HELPFILE = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell_HELPFILE", false)

SpeakinSpell:PrintLoading("slashcommands.lua")

-------------------------------------------------------------------------------
-- SLASH COMMAND HANDLERS
-------------------------------------------------------------------------------

-- All of these commands will trigger SpeakinSpell:OnSlashCommand()
-- L[] overrides also apply
local SLASH_COMMAND_STARTS = {
	"ss",			-- "/ss <input>" -> OnSlashCommand(input)
	"speakinspell", -- "/speakinspell <input>" -> OnSlashCommand(input)
}

-- table of supporting slash commands
-- NOTE: support both English and current locale
--	non-English game clients can typically use both translated and untranslated slash commands
--	for built-in functions like /bg chat, etc, so it makes sense here as well
local SLASH_COMMANDS_SIMPLE = {
	["toggle"]		= function() SpeakinSpell:ShowOptions_Toggle() end,
	["options"]		= function() SpeakinSpell:ShowOptions() end,
	["create"]		= function() SpeakinSpell:ShowCreateNew() end,
	["messages"]	= function() SpeakinSpell:ShowMessageOptions() end,
	["random"]		= function() SpeakinSpell:ShowRandomSubsOptions() end,
	["import"]		= function() SpeakinSpell:ShowImport() end,
	["colors"]		= function() SpeakinSpell:ShowColorsGUI() end,
	["network"]		= function() SpeakinSpell:ShowNetworkOptions() end,
	["help"]		= function() SpeakinSpell:ShowHelp() end,
	["reset"]		= function() SpeakinSpell:ResetToDefaults(nil) end,
	["eraseall"]	= function() SpeakinSpell:EraseAllSpeeches() end,
	["advertise"]	= function() SpeakinSpell:Advertise("") end,
	["ad"]			= function() SpeakinSpell:Advertise("") end,
	["ad /s"]		= function() SpeakinSpell:Advertise("SAY") end,
	["ad /g"]		= function() SpeakinSpell:Advertise("GUILD") end,
	["ad /p"]		= function() SpeakinSpell:Advertise("PARTY") end,
	["ad /ra"]		= function() SpeakinSpell:Advertise("RAID") end,
	["testallsubs"] = function() SpeakinSpell:TestAllSubs() end,
	["memory"]		= function() SpeakinSpell:Print( SpeakinSpell:GetAddonMemoryUsedString() ) end,
	["sync"]		= function() SpeakinSpell:Network_AutoSync() end,
	["guides"]		= function() SpeakinSpell:ToggleSetupGuides() end,
	["recent"]		= function() SpeakinSpell:ReportRecentEvents() end,
}

--NOTE: always include a space in the key, so that params will not start with that
local SLASH_COMMANDS_STARTSWITH = {
	-- ["key"] = function(k,p) -- "/ss <key><params>" -> Func(key,params)
	-- "/ss macro something whacky" -> Func("macro","something whacky")
	["macro"]	= function( key, params ) SpeakinSpell:ProcessUserMacro( key, params ) end,
	["ad"]		= function( key, params ) SpeakinSpell:Advertise("WHISPER", params) end,
	["sync"]	= function( key, params ) SpeakinSpell:Network_SyncWithTarget( params ) end,
}

--[[ [buildlocales.py Data]

The following Localization is required for the chat commands listed above
buildlocales.py will catch this list and create Locale table entries
English commands always also work in the presence of a translation
leXin told me that was a standard practice

L["ss"]
L["speakinspell"]
L["toggle"]
L["options"]
L["create"]
L["messages"]
L["random"]
L["import"]
L["network"]
L["help"]
L["reset"]
L["advertise"]
L["ad"]
L["ad /s"]
L["ad /g"]
L["ad /p"]
L["ad /ra"]
L["testallsubs"]
L["memory"]
L["sync"]
L["guides"]
L["recent"]
L["ad "]
L["sync "]
--]]

--[[
-- [buildlocales.py copy]
-- to satisfy slash command general-case logic that supports both English and localized text
-- we can get these localized words from GlobalStrings (which are Capitalized)
L["colors"] = strlower(COLORS)
L["macro"] = strlower(MACRO)
-- [buildlocales.py end of copy]
--]]

-------------------------------------------------------------------------------
-- SETUP
-------------------------------------------------------------------------------


function SpeakinSpell:RegisterChatCommands()
	-- add the localized slash commands (support both)
	-- NOTE: these are the starter-word only "/SpeakinSpell" and variants
	for _,command in pairs(SLASH_COMMAND_STARTS) do
		local lcommand = L[command] -- [buildlocales.py No Warning] Locale keys are defined manually under -- SLASH COMMANDS
		if lcommand ~= command then
			tinsert(SLASH_COMMAND_STARTS, lcommand)
		end
	end
	
	-- register all chat commands
	for k,v in pairs(SLASH_COMMAND_STARTS) do
		self:RegisterChatCommand(v,"OnSlashCommand")
	end

	-- now for our own commands, which are technically parameters to the commands we just registered above
	
	-- add localized commands
	for command,Func in pairs(SLASH_COMMANDS_SIMPLE) do
		local lcommand = L[command] -- [buildlocales.py No Warning] 
		if lcommand ~= command and (not SLASH_COMMANDS_SIMPLE[ lcommand ]) then
			SLASH_COMMANDS_SIMPLE[ lcommand ] = Func
		end
	end
	-- and same thing for the Starts-With table
	for command,Func in pairs(SLASH_COMMANDS_STARTSWITH) do
		local lcommand = L[command] -- [buildlocales.py No Warning] 
		if lcommand ~= command and (not SLASH_COMMANDS_STARTSWITH[ lcommand ]) then
			SLASH_COMMANDS_STARTSWITH[ lcommand ] = Func
		end
	end
end



-------------------------------------------------------------------------------
-- OnSlashCommand main handler
-------------------------------------------------------------------------------


function SpeakinSpell:OnSlashCommand(input)
	local funcname = "OnSlashCommand"

	-- format <substutitions> in the input and lowercase it for table lookups
	local de = {
		name = input,
		target = UnitName("target"),
	}
	input = self:FormatSubs( string.lower(input), de )
	self:DebugMsg(funcname,"OnSlashCommand:"..tostring(input))
	
	-- if nothing is specified, then choose a default command
	if input == nil or input == "" then
		input = "toggle"
	end
	
	-- what did the user enter?
	Func = SLASH_COMMANDS_SIMPLE[input]
	
	-- process the command if found in the easy table
	if Func then
		Func()
		return
	end
	
	-- It wasn't an easy command...
	--	check for commands that start with one of the commands that have arguments
	--	defined in SLASH_COMMANDS_STARTSWITH[]

	for key,Func in pairs(SLASH_COMMANDS_STARTSWITH) do
		if self:StartsWith(input, key.." ") then
			local params = string.sub( input, string.len(key)+1 )
			-- remove any additional leading spaces
			-- KLUGE: this is also a kluge to work around odd behavior of string.sub()
			-- the behavior of string.sub seems inconsistent, sometimes ndx+1 gets the leading space
			-- but ndx+2 sometimes goes 1 too far and misses the first letter of the params string
			-- so we use ndx+1 and check for the leading space
			-- which also adds a nice feature in this case if the user types an extra space by accident
			while self:StartsWith(params, " ") do
				params = string.sub( params, 2 )
			end
			-- OK, call the handler for this function, and pass it the additional parameters
			Func( key, params )
			return
		end
	end
	
	--else -- doesn't appear to be a valid command
	self:ShowHelp()
		
	-- go straight to the slash commands page (if possible)
	-- NOTE: this currently doesn't work... see notes in HelpPages_SelectTopic()
	self:HelpPages_SelectTopic( HELPFILE.SLASH_COMMANDS )

end


-------------------------------------------------------------------------------
-- /ss macro stuff
-------------------------------------------------------------------------------


function SpeakinSpell:ProcessUserMacro( key, params )
	--NOTE: legacy behavior here... TODOFUTURE: set name = only the params instead of the whole input
	--NOTE: reinsert the space between "macro something" which was removed by OnSlashCommand()
	local input = tostring(key).." "..tostring(params) -- "macro something" not including /ss
	
	self:DebugMsg(funcname, "User Macro input:"..tostring(params))
	
	local DetectedEventStub = {
		-- event descriptors
		name = input, -- use the entire lowercase input = "macro something"
		type = "MACRO",
		-- event-specific data for substitutions
		caster = UnitName("player"),
	}
	
	-- NOTE: do not inherit parent event data here
	--		that would corrupt the event key,
	--		causing us to load the wrong speech list and options
	--		and leading to infinite recursion
	--		see SpeakinSpell:InheritParentEvent()
	
	-- signal the event
	self:OnSpeechEvent( DetectedEventStub )
	return true
end


function SpeakinSpell:GetETEForSSMacro(input)
	local funcname = "GetETEForSSMacro"
	--self:DebugMsg(funcname, "input:"..tostring(input))

	local macro = string.sub(input,2) --strip off the leading '/'
	for _,slash in pairs(SLASH_COMMAND_STARTS) do
		if self:StartsWith(macro, slash) then
			macro = string.sub(macro, string.len(slash)+2)
			break
		end
	end
	while self:StartsWith(macro, " ") do
		macro = string.sub(macro, 2)
	end
	if not ( self:StartsWith(macro, "macro ") or self:StartsWith(macro, MACRO.." ") ) then
		-- not a recursive macro
		--self:DebugMsg(funcname, string.format([["%s" doesn't start with "macro"]], macro) )
		return nil
	end
	
	local key = self:Keyify( "MACRO"..tostring(macro) )
	--self:DebugMsg(funcname, "key:"..key)
	return self:GetActiveEventTable()[key]
end


function SpeakinSpell:ProcessRecursiveUserMacro(input, ParentDetectedEvent)
	local funcname = "ProcessRecursiveUserMacro"

	local ete = self:GetETEForSSMacro(input)
	if not ete then
		-- this is not an error, because we call this function as a test
		-- but it does mean we have nothing to do here
		--self:ErrorMsg(funcname, "no settings defined for "..tostring(input))
		return false
	end
		
	if self.RuntimeData.RecursiveCall == input then
		self:ShowWhyNot( ParentDetectedEvent, L["the /ss macro would keep calling itself forever"] )
		return true --consider this completely processed and stop
	end
	
	self.RuntimeData.RecursiveCall = input
	self:DebugMsg(funcname, "Recursive User Macro input: "..tostring(input))
	
	local DetectedEventStub = {
		-- event descriptors
		name = ete.DetectedEvent.name, -- use the entire lowercase input = "macro something"
		type = "MACRO",
		-- event-specific data for substitutions
		target = ParentDetectedEvent.target,
		caster = ParentDetectedEvent.caster,
	}
	
	-- signal the event
	self:OnRecursiveEventDetected( input, DetectedEventStub, ParentDetectedEvent )
	
	-- clear the infinite recursive call blocker
	self.RuntimeData.RecursiveCall = nil
	
	return true
end

