-- Author      : RisM
-- Create Date : 9/21/2009 2:44:55 AM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)
local DEFAULT_EVENTHOOKS = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell_DEFAULT_EVENTHOOKS",	false)

SpeakinSpell:PrintLoading("gui/createnew.lua")

-------------------------------------------------------------------------------
-- GUI LAYOUT - Create New
-------------------------------------------------------------------------------

SpeakinSpell.OptionsGUI.args.CreateNew = {
	order = 3,
	type = "group",
	name = "unused_CreateNew_name",
	desc = "unused_CreateNew_desc",
	args = {
		Caption = {
			order = 1,
			type = "header",
			--name = L["Create a New Speech Event"],
			name = function()
				SpeakinSpell:SetLastPageViewed( "CreateNew", L["Create New..."] )
				return L["Create a New Speech Event"]
			end,
		},
		NewSpellModeInstruct = {
			order = 2,
			type = "description",
			name = function()
				local subs = {
					number = SpeakinSpell:SizeTable(SpeakinSpellSavedDataForAll.NewEventsDetected),
				}
				return "\n\n"..SpeakinSpell:FormatSubs( L[
[[SpeakinSpell can announce many different spells, abilities, items, buffs, procced effects, and other events, and can discover new events the longer you use it.

If the spell or event that you're looking for is not in the list, then cast it or trigger its effect.

To define a custom event, type "/ss macro something" in the default chat frame.

Total event hooks known: <number>]]
					], subs).."\n"
			end,
		},
		ResetNewEventsDetected = {
			order = 3,
			type = "execute",
			name = L["Reset Event List"],
			desc = L["Reset the list of event hooks to the default basic list, removing all discovered and collected event hooks"],
			func = function()
				SpeakinSpellSavedDataForAll.NewEventsDetected = SpeakinSpell:CopyTable( DEFAULT_EVENTHOOKS.NewEventsDetected )
			end,
		},
		CaptionSearch = {
			order = 4,
			type = "header",
			name = L["Search Filter Options"],
		},
--		SearchOptions = {
--			order = 3,
--			type = "group",
--			guiInline = true,
--			name = L["Search Filter Options"],
--			args = {
		EventTextFilterSelect = {
			order = 4,
			type = "input",
			width = "full",
			name = SEARCH,
			desc = L["Type some of the name of what you're looking for, to narrow down the list below"],
			get = function() return  SpeakinSpell:CreateNew_OnGetSetEventTextFilter("GET",nil) end,
			set = function(_, value) SpeakinSpell:CreateNew_OnGetSetEventTextFilter("SET",value) end,
		},
		EventTypeFilterSelect = {
			order = 5,
			type = "select",
			width = "full",
			name = L["Select a Category of Events"],
			desc = L["Show only this kind of event in the list below"],
			values = function() return SpeakinSpell.EventTypes.AS_FILTERS end,
			get = function() return  SpeakinSpell:CreateNew_OnEventTypeFilterSelect("GET",nil) end,
			set = function(_, value) SpeakinSpell:CreateNew_OnEventTypeFilterSelect("SET",value) end,
		},
		ShowAllRanks = {
			order = 7,
			type = "toggle",
			width = "full",
			name = L["Show All Ranks"],
			desc = L["Enable to show different ranks of spells and abilities, including Polymorph critters.\n\nIf disabled, any rank of the spell will count."],
			--hidden = function() return not SpeakinSpell:IsSelectedEventTypeFilterRankable() end,
			get = function() return  SpeakinSpell:CreateNew_OnToggleShowAllRanks("GET",nil) end,
			set = function(_, value) SpeakinSpell:CreateNew_OnToggleShowAllRanks("SET",value) end,
		},
		ShowMoreThanAHundred = {
			order = 6,
			type = "toggle",
			width = "full",
			name = L["Show More than 100 Search Results"],
			desc = L["Enable to show more than 100 search results in the drop-down list below.\n\nEnabling this option can slow down the performance of this window (capped at 200 max to avoid memory overflows)."],
			get = function() return  SpeakinSpell:CreateNew_OnToggleShowMoreThanAHundred("GET",nil) end,
			set = function(_, value) SpeakinSpell:CreateNew_OnToggleShowMoreThanAHundred("SET",value) end,
		},
		ShowUsedHooks = {
			order = 7,
			type = "toggle",
			width = "full",
			name = L["Show Used Event Hooks"],
			desc = L["Enable to show the event hooks that you already use."],
			get = function() return  SpeakinSpell:CreateNew_OnToggleShowUsedHooks("GET",nil) end,
			set = function(_, value) SpeakinSpell:CreateNew_OnToggleShowUsedHooks("SET",value) end,
		},
--			},
--		},
		Gap = {
			order = 8,
			type = "description",
			name = "",
		},
		CaptionSelect = {
			order = 9,
			type = "header",
			name = L["Select and Create"],
		},
		NewSpellNameSelect = {
			order = 10,
			type = "select",
			width = "full",
			--name = L["Select a Spell"],
			name = function() return SpeakinSpell:GUI_GetEventSelectLabel() end,
			desc = L["This is a list of all the detected spells, abilities, items, and procced effects which SpeakinSpell has seen you cast or receive recently."],
			values = {},
			hidden = function() return not SpeakinSpell:CreateNew_HaveValidSelection() end,
			get = function() return  SpeakinSpell:CreateNew_OnNewSpellNameSelect("GET",nil) end,
			set = function(_, value) SpeakinSpell:CreateNew_OnNewSpellNameSelect("SET",value) end,
		},
		NoSearchResults = {
			name = "\n"..L["No Matching Search Results Found"].."\n",
			order = 11,
			type = "description",
			width = "full",
			hidden = function() return SpeakinSpell:CreateNew_HaveValidSelection() end,
		},
		CreateNewSpellButton = {
			order = 12,
			type = "execute",
			--width = "full",
			name = L["Create Speech Event"],
			desc = L["Select the new spell event you want to announce in chat above, then push this button"],
			func = function() SpeakinSpell:CreateNew_OnClickCreateNew() end,
			hidden = function() return not SpeakinSpell:CreateNew_HaveValidSelection() end,
		},
	}, --end args
}
-------------------------------------------------------------------------------
-- OPTIONS GUI FUNCTIONS - CREATE NEW
-------------------------------------------------------------------------------



function SpeakinSpell:CreateNew_GetSelectedEventObject()
	local eventkey = self.RuntimeData.OptionsGUIStates.CreateNew.SelectedEventKey
	if eventkey then
		return SpeakinSpellSavedDataForAll.NewEventsDetected[eventkey]
	else
		return nil
	end
end


function SpeakinSpell:CreateNew_HaveValidSelection()
	-- used to show/hide controls
	-- show this control if there is a valid selected event
	-- otherwise, it implies that there's nothing to select
	-- or else we would have chosen a default selection
	local SelectedEventObject = self:CreateNew_GetSelectedEventObject()
	if SelectedEventObject then
		--self:Print("CreateNew_HaveValidSelection:"..tostring(SelectedEventObject.key))
		return true
	else
		return false
	end
end


function SpeakinSpell:CreateNew_ValidateSelectedEvent()
	local funcname = "CreateNew_ValidateSelectedEvent"
	
	local DetectedEvent = self:CreateNew_GetSelectedEventObject()

	-- allow the current selection to remain if it is valid
	if DetectedEvent then
		if self:MatchesFilter(DetectedEvent,false) then
			-- the current selection is valid, so keep it
			--self:DebugMsg(funcname, "valid selection:"..tostring(DetectedEvent.key))
			return
		end
		--else, the current selection did not match the filter, so select a default
	end

	-- rebuild the list to match the new filter if its out of date
	-- this will select something if possible
	self:CreateNew_RebuildSpellList()
end


function SpeakinSpell:CreateNew_OnEventTypeFilterSelect(getset,value)
	if "GET" == getset then
		-- rebuild the list to match the new filter if its out of date
		self:CreateNew_RebuildSpellList()
		return SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTypeFilter
	else -- "SET"
		-- if the filter is changing, then rebuild the spell/event list
		self:SetFilter(value,nil)
		-- rebuild the list to match the new filter
		self:CreateNew_RebuildSpellList()
	end
	-- NOTE: the current selection will be repaired to match the new filter in _ValidateSelectedEvent
	--		as a side effect when the GUI framework automatically tries to get the new value of 
	--		the rest of the controls on the page, including the selected event
end


function SpeakinSpell:CreateNew_OnGetSetEventTextFilter(getset,value)
	if "GET" == getset then
		--if nothing is selected, set to all
		self:CreateNew_RebuildSpellList()
		return SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTextFilter
	else -- "SET"
		-- if the filter is changing, then rebuild the spell/event list
		self:SetFilter(nil,value)
		-- rebuild the list to match the new filter
		self:CreateNew_RebuildSpellList()
	end
	-- NOTE: the current selection will be repaired to match the new filter in _ValidateSelectedEvent
	--		as a side effect when the GUI framework automatically tries to get the new value of 
	--		the rest of the controls on the page, including the selected event
end



function SpeakinSpell:CreateNew_OnToggleShowMoreThanAHundred(getset,value)
	if "GET" == getset then
		-- rebuild the list to match the new filter if its out of date
		self:CreateNew_RebuildSpellList()
		return SpeakinSpellSavedData.ShowMoreThanAHundred
	else -- "SET"
		-- if the filter is changing, then rebuild the spell/event list
		self:SetFilterShowMoreThanAHundred(value)
		-- rebuild the list to match the new filter
		self:CreateNew_RebuildSpellList()
	end
end


function SpeakinSpell:CreateNew_OnToggleShowUsedHooks(getset,value)
	if "GET" == getset then
		-- rebuild the list to match the new filter if its out of date
		self:CreateNew_RebuildSpellList()
		return SpeakinSpellSavedData.ShowUsedHooks
	else -- "SET"
		-- if the filter is changing, then rebuild the spell/event list
		self:SetFilterShowUsedHooks(value)
		-- rebuild the list to match the new filter
		self:CreateNew_RebuildSpellList()
	end
end

function SpeakinSpell:CreateNew_OnToggleShowAllRanks(getset,value)
	if "GET" == getset then
		-- rebuild the list to match the new filter if its out of date
		self:CreateNew_RebuildSpellList()
		return SpeakinSpellSavedData.ShowAllRanks
	else -- "SET"
		-- if the filter is changing, then rebuild the spell/event list
		self:SetFilterShowAllRanks(value)
		-- rebuild the list to match the new filter
		self:CreateNew_RebuildSpellList()
	end
end


function SpeakinSpell:CreateNew_OnNewSpellNameSelect(getset, value)
	if "GET" == getset then
		--if nothing is selected, try to select the first thing in the list
		self:CreateNew_ValidateSelectedEvent()
		return self.RuntimeData.OptionsGUIStates.CreateNew.SelectedEventKey
	else -- "SET"
		self.RuntimeData.OptionsGUIStates.CreateNew.SelectedEventKey = value
	end
end


function SpeakinSpell:CreateNew_RebuildSpellList()
	local values = self.OptionsGUI.args.CreateNew.args.NewSpellNameSelect.values
	local OptionsGUIState = self.RuntimeData.OptionsGUIStates.CreateNew
	local EventTable = SpeakinSpellSavedDataForAll.NewEventsDetected
	local MatchesFilterFunc = function(key)
		local de = SpeakinSpellSavedDataForAll.NewEventsDetected[key]
		if de and (not SpeakinSpellSavedData.ShowUsedHooks) and self:GetActiveEventTable()[de.key] then
			return false
		end
		return SpeakinSpell:MatchesFilter( de, false )
	end
	local GetDisplayNameFunc = function(key)
		local de = SpeakinSpellSavedDataForAll.NewEventsDetected[key]
		local DisplayNameFormat = {
			typefilter = SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTypeFilter,
			ShowAllRanks = SpeakinSpellSavedData.ShowAllRanks,
			HighlightFilterText = true,
			BaseColor = "|r",
		}
		return self:FormatDisplayName( de, DisplayNameFormat )
	end
	self:RebuildSpellList( values, OptionsGUIState, EventTable, MatchesFilterFunc, GetDisplayNameFunc )
end


function SpeakinSpell:CreateNew_OnClickCreateNew()
	local funcname = "CreateNew_OnClickCreateNew"
	
	-- grab the selected new event
	local de = self:CreateNew_GetSelectedEventObject()
	if not de then
		self:ErrorMsg(funcname, "no event selected")
		return
	end
	
	-- add the spell to the message table and related data structures
	local EventTable = self:GetActiveEventTable()
	if not EventTable[de.key] then
		local new = {
			DetectedEvent = self:CopyTable(de)
		}
		self:Validate_EventTableEntry(new)
		EventTable[de.key] = new
	end
	
	-- destroy the new event detection since this is now a registered event
	-- NO! keep it.
	-- NOTE: We save the whole list now forever and we don't want to have to recast to get it back
	-- SpeakinSpellSavedDataForAll.NewEventsDetected[de.key] = nil
	
	-- deselect it from the Create New screen and remove it from that UI
	-- NO! see note above
	-- self.RuntimeData.OptionsGUIStates.CreateNew.SelectedEventKey = nil
	-- self.OptionsGUI.args.CreateNew.args.NewSpellNameSelect.values[de.key] = nil

	-- setup the message settings GUI to show the new category of event we've added
--	self:SetFilter(de.type,de.name)
	self:SetFilter(de.type,nil) --don't set the name, it's not necessary sicne we set the selected key and type
	-- and select our new spell
	self.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey = de.key
	-- force rebuilding the event select list to include this new item
	self.RuntimeData.OptionsGUIStates.MessageSettings.FilterChanged = true
	
	-- now we're ready to go to the new event's settings in the options GUI
	self:ShowMessageOptions()
end



function SpeakinSpell:GUI_CreateNew_OnNewEventDetected(de)
	local funcname = "GUI_CreateNew_OnNewEventDetected"
	
	--self:DebugMsg(funcname, "entry")
	
	-- update the GUI to show this newly detected event if it matches the current search filter
	if self:MatchesFilter(de,false) then
		local values = self.OptionsGUI.args.CreateNew.args.NewSpellNameSelect.values
		-- add this to the list of values
		DisplayNameFormat = {
			typefilter = SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTypeFilter,
			ShowAllRanks = SpeakinSpellSavedData.ShowAllRanks,
			HighlightFilterText = true,
			BaseColor = "|r",
		}
		values[de.key] = self:FormatDisplayName( de, DisplayNameFormat )
		-- re-sort the list
		-- table.sort(values) -- this isn't necessary
	end
	
	-- legacy behavior -> assistive guide
	-- in the past, we used to automatically open the options GUI for a new macro
	-- now we put a clickable link into the chat instead, to be less obtrusive
	if de.type == "MACRO" then
		-- this may already have been done if enabled for all events
		if not (SpeakinSpellSavedData.ShowSetupGuides or SpeakinSpell.DEBUG_MODE) then
			self:DoReportDetectedSpeechEvent( de, true, false )
		end
	end
end
