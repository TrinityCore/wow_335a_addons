-- Author      : RisM
-- Create Date : 9/21/2009 2:45:50 AM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("gui/randomsubs.lua")

-------------------------------------------------------------------------------
-- GUI LAYOUT - RANDOM SUBSTITUTION SETTINGS
-------------------------------------------------------------------------------


SpeakinSpell.OptionsGUI.args.RandomSubs = {
	order = 4,
	type = "group",
	name = L["Random Substitutions"],
	desc = L["Random Substitutions like <randomtaunt> and <randomfaction>"],
	args = {
		CaptionNormalMode = {
			order = 1,
			type = "header",
			--name = L["Random Substitutions"],
			name = function()
				SpeakinSpell:SetLastPageViewed( "RandomSubs", L["Random Substutitions"])
				return L["Random Substitutions"]
			end,
		},
		Instructions = {
			order = 2,
			type = "description",
			name = "\n" .. L["Edit the values that may be used for random <substitutions>"] .. "\n",
		},
		RandomSubSelect = {
			order = 3,
			type = "select",
			--width = "full",
			name = L["Select a <substitution>"],
			desc = L["Select a Randomized Substitution\n\nThese substitutions may be used in speeches when announcing events, and a random result from the list below will be selected."],
			values = function()
				local values = {}
				for key,_ in pairs(SpeakinSpellSavedDataForAll.RandomSubs) do
					local display = "<"..tostring(key)..">"
					values[key] = display
				end
				return values
			end,
			get = function() return  SpeakinSpell:RandomSubs_OnRandomSubSelect("GET",nil) end,
			set = function(_, value) SpeakinSpell:RandomSubs_OnRandomSubSelect("SET",value) end,
		},
		DeleteList = {
			order = 4,
			type = "execute",
			name = L["Delete Word List"],
			desc = L["Delete the selected word list and <substitution> word"],
			func = function()
				SpeakinSpellSavedDataForAll.RandomSubs[ SpeakinSpell.RuntimeData.OptionsGUIStates.RandomSubs.Selection ] = nil
			end,
		},
		NewList = {
			order = 5,
			type = "input",
			name = L["New Word List"],
			desc = L["Create a new <randomword> list by typing the randomword into this box.\nDo not include the brackets <>"],
			set = function(_,value)
				-- fix any user errors in the way the substitution key word was entered
				-- i.e. must be lowercase, no embedded <brackets> etc.
				value = SpeakinSpell:Validate_SubstitutionKey(value)
				-- OK now we have a validated substitution key
				local already_defined = SpeakinSpellSavedDataForAll.RandomSubs[ value ]
				if not already_defined then
					-- create a new array
					SpeakinSpellSavedDataForAll.RandomSubs[ value ] = {}
				end
				-- select the item
				SpeakinSpell.RuntimeData.OptionsGUIStates.RandomSubs.Selection = value
			end,
		},
		Gap = {
			order = 6,
			type = "description",
			name = "",
			width = "full",
		},
	}, --end args
}


-------------------------------------------------------------------------------
-- OPTIONS GUI FUNCTIONS - RANDOM SUBS PAGE
-------------------------------------------------------------------------------


function SpeakinSpell:RandomSubs_ValidateSelectedRandomSub()
	local funcname = "RandomSubs_ValidateSelectedRandomSub"
	
	if self.RuntimeData.OptionsGUIStates.RandomSubs.Selection
		and SpeakinSpellSavedDataForAll.RandomSubs[ self.RuntimeData.OptionsGUIStates.RandomSubs.Selection ] then
		--self:DebugMsg(funcname, "keeping sel:"..self.RuntimeData.OptionsGUIStates.RandomSubs.Selection)
		return
	end
	
	-- try to pick a good example as a default, if it still exists
	if SpeakinSpellSavedDataForAll.RandomSubs[ "randomfaction" ] then
		self.RuntimeData.OptionsGUIStates.RandomSubs.Selection = "randomfaction"
		return
	end
	
	for key,table in pairs(SpeakinSpellSavedDataForAll.RandomSubs) do
		self.RuntimeData.OptionsGUIStates.RandomSubs.Selection = key
		--self:DebugMsg(funcname, "set sel:"..self.RuntimeData.OptionsGUIStates.RandomSubs.Selection)
		return
	end
	
	self.RuntimeData.OptionsGUIStates.RandomSubs.Selection = nil
	--self:DebugMsg(funcname, "no sel")
end


function SpeakinSpell:RandomSubs_GetSelectedSubsTable()
	self:RandomSubs_ValidateSelectedRandomSub()
	local key = self.RuntimeData.OptionsGUIStates.RandomSubs.Selection
	if key then
		return SpeakinSpellSavedDataForAll.RandomSubs[ key ]
	else
		return nil
	end
end


function SpeakinSpell:RandomSubs_OnRandomSubSelect(getset, value)
	if "GET" == getset then
		self:RandomSubs_ValidateSelectedRandomSub()
		return self.RuntimeData.OptionsGUIStates.RandomSubs.Selection
	else
		self.RuntimeData.OptionsGUIStates.RandomSubs.Selection = value
	end
end


function SpeakinSpell:RandomSubs_OnTextBox(getset, index, value)
	local SubsTable = self:RandomSubs_GetSelectedSubsTable()
	if not SubsTable then
		self:ErrorMsg("RandomSubs_OnTextBox", "no SubsTable selected")
		return ""
	end
	
	if "GET" == getset then
		local text = SubsTable[index]
		if not text then
			text = ""
		end
		return text
	else -- "SET"
		-- store the new value into the message table
		SubsTable[index] = value
		
		-- remove holes from the message table
		-- if the user has just deleted one of the entries, move everything else up to fill in the gap
		if value == "" then
			for i=index+1,SpeakinSpell.MAX.TEXTS_PER_RANDOM_SUB,1 do
				SubsTable[i-1] = SubsTable[i]
			end
			SubsTable[SpeakinSpell.MAX.TEXTS_PER_RANDOM_SUB] = nil
			-- destroy empty strings from the table
			for i=SpeakinSpell.MAX.TEXTS_PER_RANDOM_SUB-1,1,-1 do
				if SubsTable[i] == "" then
					SubsTable[i] = nil
				else
					break --the rest should be valid non-empty strings
				end
			end
		end
	end
end


function SpeakinSpell:RandomSubs_ShowTextBox(i)
	local NumTextBoxesShown = 0
	local SubsTable = self:RandomSubs_GetSelectedSubsTable()
	if SubsTable then
		NumTextBoxesShown = 1 + #(SubsTable)
	end

	return (i <= NumTextBoxesShown)
end



-- add message boxes
function SpeakinSpell:CreateGUI_RandomSubs()
	for i=1,SpeakinSpell.MAX.TEXTS_PER_RANDOM_SUB,1 do
		self.OptionsGUI.args.RandomSubs.args["RandomSub"..i] = {
			order = i + 100, -- should be the order of the last item listed above the message input boxes (OncePerTargetToggle), plus i
			--width = "full",
			type = "input",
			--the name and desc tooltip are generated dynamically to use the selected <randomtext> variable name
			name = function()
				self:RandomSubs_ValidateSelectedRandomSub()
				return "<"..tostring(self.RuntimeData.OptionsGUIStates.RandomSubs.Selection).."> "..i
			end, 
			desc = function()
				self:RandomSubs_ValidateSelectedRandomSub()
				local subs = {
					selected = L["<"]..tostring(self.RuntimeData.OptionsGUIStates.RandomSubs.Selection)..L[">"]
				}
				return self:FormatSubs(L["Anything you type here might be used as a substitution for <selected>"], subs)
			end,
			get = function() return  self:RandomSubs_OnTextBox("GET",i,nil) end,
			set = function(_, value) self:RandomSubs_OnTextBox("SET",i, value) end,
			hidden = function() return not self:RandomSubs_ShowTextBox(i) end,
		}
	end
end

