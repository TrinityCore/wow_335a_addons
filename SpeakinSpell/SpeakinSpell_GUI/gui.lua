-- Author      : RisM
-- Create Date : 6/28/2009 3:57:34 PM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("gui/gui.lua")



-------------------------------------------------------------------------------
-- OPTIONS GUI FUNCTIONS - SHARED UTILITIES
-------------------------------------------------------------------------------


function SpeakinSpell:AddToBlizOptions(FrameObjectName, FrameDisplayName, ParentDisplayName)
	-- AddToBlizOptions(appName="SpeakinSpell", display name, parent, ObjectName)
	-- NOTE: the FrameObjectName here represents self.OptionsGUI.args[FrameObjectName]
	self.optionsFrames[FrameObjectName] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SpeakinSpell", FrameDisplayName, ParentDisplayName, FrameObjectName)
	
	-- for some reason the framework has a problem if we define the "reset defaults" button handler in the data before calling AddToBlizOptions
	-- so we have to add it afterwards
	self.optionsFrames[FrameObjectName].default = function() self:ResetToDefaults(FrameObjectName) end
end



function SpeakinSpell:RefreshFrame(FrameName)
	-- the only way I found to do this is to hide and then show the frame
	-- this occurs fast enough that I do not see a flicker when this happens
	-- UPDATE: saw a forum post when I was at work with the proper API call, but I already forget what it was, and this still works
	if self.optionsFrames and self.optionsFrames[FrameName] and self.optionsFrames[FrameName]:IsVisible() then
		self.optionsFrames[FrameName]:Hide()
		self.optionsFrames[FrameName]:Show()
	end
end



function SpeakinSpell:GUI_GetEventSelectLabel()
	local type = SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTypeFilter
	if type == "MACRO" then
		--Locale note: normally string concatenation like this is frowned on
		--		but for /ss macros, the word order is forced by the slash command syntax, so it's OK here
		return tostring(SpeakinSpell.EventTypes.IN_SPELL_LIST[type])..strlower(MACRO)
	end
	local name = SpeakinSpell.EventTypes.IN_SPELL_LIST[type]
	if name then
		return name
	else
		return L["Select a Speech Event"]
	end
end


--FormatDisplayName
-- create a display name for an event, using options
-- typonly = a type filter in effect, or nil
--		if a type filter is in effect, don't include the type in the display name
--		if a type filter is NOT in effect, include the event type in the display name
--
local g_DefaultFormat = {
	typefilter = "*ALL", 
	ShowAllRanks = true, 
	HighlightFilterText = false, 
	BaseColor = "|r",
}
function SpeakinSpell:FormatDisplayName( de, DisplayNameFormat )
	local funcname = "FormatDisplayName"
	
	local Format = self:CopyTable( DisplayNameFormat )
	self:ValidateObject( Format, g_DefaultFormat )

	local subs = self:CopyTable(de)
	subs.basecolor = Format.BaseColor

	local subformat = L["<basecolor><eventtypeprefix><colormatchedname><rank>"]
	
	-- rank = " (Rank)" or ""
	if self:IsEventTypeRankable( de.type ) then
		subs.rank = de.rank
		if (not subs.rank) or (subs.rank == "") then
			if Format.ShowAllRanks then
				subs.rank = L["All Ranks"]
				subformat = L["<basecolor><eventtypeprefix><colormatchedname> (<rank>)"]
			else
				-- this doesn't have a rank specified, and we're not showing "All Ranks"
				subformat = L["<basecolor><eventtypeprefix><colormatchedname>"]
			end
		else
			-- we have a rank to show
			subformat = L["<basecolor><eventtypeprefix><colormatchedname> (<rank>)"]
		end
	else
		subs.rank = nil
		subformat = L["<basecolor><eventtypeprefix><colormatchedname>"]
	end

	if Format.HighlightFilterText then
		subs.colormatchedname = self:ColorFilterText( de.name, Format.BaseColor )
	else
		subs.colormatchedname = (Format.BaseColor)..tostring(de.name)
	end

	if Format.typefilter == "*ALL" then -- show the type in the display name
		return self:FormatSubs(subformat,subs)
	end

	-- when showing macros only, format so we show...
	-- when I type: /ss macro
	-- foo, bar, battlecry, whatever
	if (Format.typefilter == "MACRO") and (de.type == "MACRO") then
		if self:StartsWith( string.lower( de.name ), strlower(MACRO) ) then
			subs.colormatchedname = string.sub( de.name, string.len( strlower(MACRO) )+1 )
			if Format.HighlightFilterText then
				subs.colormatchedname = self:ColorFilterText( subs.colormatchedname, Format.BaseColor )
			end
			return self:FormatSubs(L["<basecolor><colormatchedname>"],subs)
		end
	end
	
	if (not subs.rank) or (subs.rank == "") then
		--self:FormatSubs(L["<colormatchedname>"],subs)
		return subs.colormatchedname
	end
	-- For all other types, we're only showing this type of event, so show only the name and rank
	return self:FormatSubs(L["<colormatchedname> (<rank>)"],subs)
end


-------------------------------------------------------------------------------
-- FILTER EVENT LIST SEARCH FUNCTION
-------------------------------------------------------------------------------


function SpeakinSpell:GUI_ResetState()
	-- reset the persistent spell/event lists
	-- the rest is in the RuntimeData table which is also being reset at this time
	self.OptionsGUI.args.CreateNew.args.NewSpellNameSelect.values = {}
	self.OptionsGUI.args.CurrentMessagesGUI.args.SelectGroup.args.EventSelect.values = {}
end

	
function SpeakinSpell:RebuildSpellList( values, OptionsGUIState, EventTable, MatchesFilterFunc, GetDisplayNameFunc )
	local funcname = "RebuildSpellList"
	
	if not OptionsGUIState.FilterChanged then
		--self:DebugMsg(funcname,"not changed")
		return
	end
	
	--self:DebugMsg(funcname,"entry")
	OptionsGUIState.FilterChanged = false

	-- if the current selection doesn't match the filter, erase it, and we'll pick a new one
	if OptionsGUIState.SelectedEventKey and not MatchesFilterFunc( OptionsGUIState.SelectedEventKey ) then
		--self:DebugMsg(funcname,"erasing selection")
		OptionsGUIState.SelectedEventKey = nil
	end
	
	-- search NewEventsDetected for those that match the filter
	-- add or remove from the list as needed
	numAdded = 0
	for key,_ in pairs(EventTable) do
		-- if we're allowed to add more
		-- and this event matches the filter
		-- NOTE: use a hard cap of 200 search results even if ShowMoreThanAHundred is enabled
		--		many more than that will crash the GUI with a stack overflow
		if (OptionsGUIState.SelectedEventKey == key) or -- we already matched the selected key
			( ( SpeakinSpellSavedData.ShowMoreThanAHundred or (numAdded < 100) ) and (numAdded < 200) and MatchesFilterFunc(key) ) then
			-- add to the list of shown values
			numAdded = numAdded + 1
			values[key] = GetDisplayNameFunc(key)
			-- make sure we have a current spell selected for the options GUI 
			-- we'll use the first one we see
			if not OptionsGUIState.SelectedEventKey then
				--self:DebugMsg(funcname,"set selection to:"..key)
				OptionsGUIState.SelectedEventKey = key
			end
		else
			-- remove it from the list of shown values
			-- NOTE: keep the current selection, even if that makes 101 items
			values[key] = nil
		end
	end
	
	--table.sort(values) -- appears to be self-sorting
end



function SpeakinSpell:SetLastPageViewed( ObjectName, InterfacePanel )
	local funcname = "SetLastPageViewed"
	--self:DebugMsg(funcname, "InterfacePanel:"..InterfacePanel )
	
	SpeakinSpellSavedData.LastPageViewed = {
		ObjectName = ObjectName,
		InterfacePanel = InterfacePanel,
	}
end


-------------------------------------------------------------------------------
-- CreateGUI - add the options GUI to the game's interface panel
-------------------------------------------------------------------------------

--TODO: can this get an on-load handler to call CreateGUI when the GUI module is loaded on demand?

function SpeakinSpell:CreateGUI()
	-- Define Options table for the GUI
	self.OptionsGUI.name = "SpeakinSpell"
	
	--SpeakinSpell:LoadChatColorCodes() -- these chat frame settings aren't loaded yet, will just load all white if we do it here
	
	-- add dynamically-generated controls to the GUI definitions
	self:CreateGUI_CurrentMessagesGUI()
	self:CreateGUI_RandomSubs()
	self:CreateGUI_HelpPages()
	self:CreateGUI_Import()
	
	-- add the options to the in-game interface options panel at Escape > Interface > Addons > SpeakinSpell
	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	-- (or it would matter if we had sub-categories, which we currently don't)
	-- InterfaceOptions_AddCategory(self.OptionsGUI) -- done via Ace below

	-- :RegisterOptionsTable(appName, options, slashcmd, persist)
	-- AceConfig:RegisterOptionsTable("MyAddon", myOptions, {"/myslash", "/my"})
	LibStub("AceConfig-3.0"):RegisterOptionsTable("SpeakinSpell", self.OptionsGUI, nil)
	
	--SpeakinSpell:AddToBlizOptions(FrameObjectName, FrameDisplayName, ParentDisplayName)
	--frame objects are stored to self.optionsFrames[FrameObjectName]
	self.optionsFrames = {}
	--TODOLATER: make these redundant lists data-driven ... iterate on SpeakinSpell.OptionsGUI.args or something
	self:AddToBlizOptions("General",		"SpeakinSpell",		nil)
	self:AddToBlizOptions("CurrentMessagesGUI",	L["Message Settings"],		"SpeakinSpell")
	self:AddToBlizOptions("CreateNew",		L["Create New..."],				"SpeakinSpell")
	self:AddToBlizOptions("RandomSubs",		L["Random Substutitions"],		"SpeakinSpell")
	self:AddToBlizOptions("ImportGUI",		L["Import New Data"],			"SpeakinSpell")
	self:AddToBlizOptions("Network",		L["Data Sharing"],				"SpeakinSpell")
	self:AddToBlizOptions("Colors",			L["SpeakinSpell Colors"],		"SpeakinSpell")
	self:AddToBlizOptions("HelpRoot",		L["SpeakinSpell Help"],			"SpeakinSpell")
	
	--flag that we ran this init function, so we don't run it again by accident
	--and so we know that the GUI module is loaded -AND- initialized
	--NOTE: this doesn't live in RuntimeData because that table can be reset
	self.IsGUILoaded = true
end


-- if the options GUI is showing right now, we need to refresh it to make it show the new data
function SpeakinSpell:GUI_RefreshAllFrames()
	self:RefreshFrame("General")
	self:RefreshFrame("CurrentMessagesGUI")
	self:RefreshFrame("CreateNew")
	self:RefreshFrame("RandomSubs")
	self:RefreshFrame("ImportGUI")
	self:RefreshFrame("Network")
	self:RefreshFrame("Colors")
end


function SpeakinSpell:ColorizeChannelList( channels )
	--SpeakinSpell:LoadChatColorCodes() -- we have to do this later than OnVariablesLoaded, but doing it here is redundant
	local values = {}
	for channel,_ in pairs( channels ) do
		local color = SpeakinSpell.Colors.Channels[ channel ]
		if color then
			values[ L[channel] ] = color .. L[channel] -- [buildlocales.py No Warning] Locale keys for channel names are copied from SpeakinSpell.lua
		else
			values[ L[channel] ] =          L[channel] -- [buildlocales.py No Warning] i.e. "Silent" comes out white this way
		end
	end
	return values
end