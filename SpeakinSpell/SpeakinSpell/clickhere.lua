local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")

SpeakinSpell:PrintLoading("clickhere.lua")


-------------------------------------------------------------------------------
-- [CLICK HERE] chat links support framework
-------------------------------------------------------------------------------


-- Hook the SetItemRef API, which is our clue that our [Click Here] link was clicked

local SetItemRef_orig = _G.SetItemRef --global API

function SpeakinSpell:ClickHere_Init()
	SetItemRef_orig = _G.SetItemRef --global API
	_G.SetItemRef = SpeakinSpell_SetItemRef
end


-- 'link' is the link text part of the clicked link
--		same as 'link' in MakeClickHereLink()
-- 'text' is the complete text of the link including escape sequences
--		same as the complete return value of MakeClickHereLink()
-- 'button' is 'LeftButton' or 'RightButton' used to click on the link (not used by us)
function SpeakinSpell_SetItemRef(link, text, button)
	local funcname = "SpeakinSpell_SetItemRef"
	--SpeakinSpell:Print("link:"..tostring(link)) -- local link = string.format( "SSLink<%s>", LuaCode )
	--SpeakinSpell:Print("text:"..tostring(text)) -- prints the clickable link again "[Click Here]"
	--SpeakinSpell:Print("button:"..tostring(button)) -- "LeftButton"

	local ndxLink = string.find(link, "SSLink<")
	if ndxLink and (ndxLink >= 0) then
		-- find the instance of "SSLink<%s>"
		string.gsub(link, "SSLink<(.-)>", 
				function(LuaCode) -- LuaCode = '%s', executable Lua code
					SpeakinSpell:DebugMsg(funcname, "RunScript:"..LuaCode)
					RunScript(LuaCode)
				end,
				1 -- we can stop after one string match
			)
	else
		SetItemRef_orig(link, text, button)
	end
end


-- returns localized string "[Click Here]"=ClickHere as clickable link to 'command' code
-- 'LuaCode' is executable Lua code to run when clicking the link
-- clicking the link will call to SpeakinSpell_SetItemRef which will call RunScript(LuaCode)
-- Color is optional, will use the standard ClickHere color if not specified
function SpeakinSpell:MakeClickHereLink(ClickHere, LuaCode, Color)
	local link = string.format( "SSLink<%s>", LuaCode )
	if Color == nil then
		Color = tostring(SpeakinSpellSavedData.Colors.ClickHere)
	end
    return "|H"..tostring(link).."|h"..Color..tostring(ClickHere).."|r|h|h"
end


-------------------------------------------------------------------------------
-- [CLICK HERE] click handlers
-------------------------------------------------------------------------------


function SpeakinSpell:OnClickEditEvent(key)
	local funcname = "OnClickEditEvent"
	self:DebugMsg(funcname, "key:"..tostring(key))
	
	-- do we have an event table entry for this yet, or is it new?
	local EventTable = self:GetActiveEventTable()
	local ete = EventTable[ key ]
	
	if not ete then
		-- this is new
		local de = SpeakinSpellSavedDataForAll.NewEventsDetected[ key ]
		if not de then
			-- something is wrong with the data
			self:DebugMsg(funcname, "can't find event with key:"..key)
			return
		end
		local new = {
			DetectedEvent = self:CopyTable(de)
		}
		self:Validate_EventTableEntry(new)
		EventTable[key] = new
		ete = new
	end
	
	-- setup the message settings GUI to show the category of event we're opening
	self:DebugMsg(funcname, "ete.DetectedEvent.type:"..tostring(ete.DetectedEvent.type) )
--	self:SetFilter(de.type,de.name)
	self:SetFilter(ete.DetectedEvent.type,"") --don't set the name, it's not necessary since we set the selected key and type
	-- and select our new spell
	self.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey = key
	-- force rebuilding the event select list to include this new item
	self.RuntimeData.OptionsGUIStates.MessageSettings.FilterChanged = true
	
	-- now we're ready to go to the new event's settings in the options GUI
	self:ShowMessageOptions()
end
