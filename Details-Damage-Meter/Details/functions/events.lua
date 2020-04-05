--File Revision: 1
--Last Modification: 27/07/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = _G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local _
	--> Event types:
	_details.RegistredEvents = {
		--> instances
			["DETAILS_INSTANCE_OPEN"] = {},
			["DETAILS_INSTANCE_CLOSE"] = {},
			["DETAILS_INSTANCE_SIZECHANGED"] = {},
			["DETAILS_INSTANCE_STARTRESIZE"] = {},
			["DETAILS_INSTANCE_ENDRESIZE"] = {},
			["DETAILS_INSTANCE_STARTSTRETCH"] = {},
			["DETAILS_INSTANCE_ENDSTRETCH"] = {},
			["DETAILS_INSTANCE_CHANGESEGMENT"] = {},
			["DETAILS_INSTANCE_CHANGEATTRIBUTE"] = {},
			["DETAILS_INSTANCE_CHANGEMODE"] = {},
			["DETAILS_INSTANCE_NEWROW"] = {},
			
		--> data
			["DETAILS_DATA_RESET"] = {},
			["DETAILS_DATA_SEGMENTREMOVED"] = {},
		
		--> combat
			["COMBAT_PLAYER_ENTER"] = {},
			["COMBAT_PLAYER_LEAVE"] = {},
			["COMBAT_PLAYER_TIMESTARTED"] = {},
			["COMBAT_BOSS_FOUND"] = {},
		
		--> area
			["ZONE_TYPE_CHANGED"] = {},
		
		--> roster
			["GROUP_ONENTER"] = {},
			["GROUP_ONLEAVE"] = {},
		
		--> buffs
			["BUFF_UPDATE"] = {},
			["BUFF_UPDATE_DEBUFFPOWER"] = {}
	}

	local function AlreadyRegistred(_tables, _object)
		for index, _this_object in ipairs(_tables) do 
			if (_this_object.__eventtable) then
				if (_this_object[1] == _object) then
					return index
				end
			elseif (_this_object == _object) then
				return index
			end
		end
		return false
	end

local common_events = {
	["DETAILS_INSTANCE_OPEN"] = true,
	["DETAILS_INSTANCE_CLOSE"] = true,
	["DETAILS_INSTANCE_SIZECHANGED"] = true,
	["DETAILS_INSTANCE_STARTRESIZE"] = true,
	["DETAILS_INSTANCE_ENDRESIZE"] = true,
	["DETAILS_INSTANCE_STARTSTRETCH"] = true,
	["DETAILS_INSTANCE_ENDSTRETCH"] = true,
	["DETAILS_INSTANCE_CHANGESEGMENT"] = true,
	["DETAILS_INSTANCE_CHANGEATTRIBUTE"] = true,
	["DETAILS_INSTANCE_CHANGEMODE"] = true,
	["DETAILS_INSTANCE_NEWROW"] = true,
	["DETAILS_DATA_RESET"] = true,
	["DETAILS_DATA_SEGMENTREMOVED"] = true,
	["COMBAT_PLAYER_ENTER"] = true,
	["COMBAT_PLAYER_LEAVE"] = true,
	["COMBAT_PLAYER_TIMESTARTED"] = true,
	["COMBAT_BOSS_FOUND"] = true,
	["GROUP_ONENTER"] = true,
	["GROUP_ONLEAVE"] = true,
	["ZONE_TYPE_CHANGED"] = true,
}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> register a event

	function _details:RegisterEvent(object, event, func)

		if (not _details.RegistredEvents[event]) then
			if (object.Msg) then
				object:DelayMsg("(debug) unknown event", event)
			else
				_details:DelayMsg("(debug) unknown event", event)
			end
			return
		end
		
		if (common_events[event]) then
			if (not AlreadyRegistred(_details.RegistredEvents[event], object)) then
				if (func) then
					tinsert(_details.RegistredEvents[event], {object, func, __eventtable = true})
				else
					tinsert(_details.RegistredEvents[event], object)
				end
				return true
			else
				return false
			end
		else
			if (event == "BUFF_UPDATE") then
				if (not AlreadyRegistred(_details.RegistredEvents["BUFF_UPDATE"], object)) then
					if (func) then
						tinsert(_details.RegistredEvents["BUFF_UPDATE"], {object, func, __eventtable = true})
					else
						tinsert(_details.RegistredEvents["BUFF_UPDATE"], object)
					end
					_details.Buffs:CatchBuffs()
					_details.RecordPlayerSelfBuffs = true
					_details:UpdateParserGears()
					return true
				else
					return false
				end
				
			elseif (event == "BUFF_UPDATE_DEBUFFPOWER") then
				if (not AlreadyRegistred(_details.RegistredEvents["BUFF_UPDATE_DEBUFFPOWER"], object)) then
					if (func) then
						tinsert(_details.RegistredEvents["BUFF_UPDATE_DEBUFFPOWER"], {object, func, __eventtable = true})
					else
						tinsert(_details.RegistredEvents["BUFF_UPDATE_DEBUFFPOWER"], object)
					end
					_details.RecordPlayerAbilityWithBuffs = true
					_details:UpdateDamageAbilityGears()
					_details:UpdateParserGears()
					return true
				else
					return false
				end
			end
		end
	end

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Unregister a Event

	function _details:UnregisterEvent(object, event)
	
		if (not _details.RegistredEvents[event]) then
			if (object.Msg) then
				object:Msg("(debug) unknown event", event)
			else
				_details:Msg("(debug) unknown event", event)
			end
			return
		end
	
		if (common_events[event]) then
			local index = AlreadyRegistred(_details.RegistredEvents[event], object)
			if (index) then
				table.remove(_details.RegistredEvents[event], index)
				return true
			else
				return false
			end
		else
			if (event == "BUFF_UPDATE") then
				local index = AlreadyRegistred(_details.RegistredEvents["BUFF_UPDATE"], object)
				if (index) then
					table.remove(_details.RegistredEvents["BUFF_UPDATE"], index)
					if (#_details.RegistredEvents["BUFF_UPDATE"] < 1) then
						_details.RecordPlayerSelfBuffs = true
						_details:UpdateParserGears()
					end
					return true
				else
					return false
				end
				
			elseif (event == "BUFF_UPDATE_DEBUFFPOWER") then
				local index = AlreadyRegistred(_details.RegistredEvents["BUFF_UPDATE_DEBUFFPOWER"], object)
				if (index) then
					table.remove(_details.RegistredEvents["BUFF_UPDATE_DEBUFFPOWER"], index)
					if (#_details.RegistredEvents["BUFF_UPDATE_DEBUFFPOWER"] < 1) then
						_details.RecordPlayerAbilityWithBuffs = false
						_details:UpdateDamageAbilityGears()
						_details:UpdateParserGears()
					end
					return true
				else
					return false
				end
			end
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions
	
	--> Send Event
	function _details:SendEvent(event, object, ...)

		--> send event to all registred plugins
		
		if (event == "PLUGIN_DISABLED" or event == "PLUGIN_ENABLED") then
			return object:OnDetailsEvent(event, ...)
		
		elseif (not object) then
			for _, PluginObject in ipairs(_details.RegistredEvents[event]) do
				if (PluginObject.__eventtable) then
					if (PluginObject[1].Enabled and PluginObject[1].__enabled) then
						if (type(PluginObject[2]) == "function") then
							PluginObject[2](event, ...)
						else
							PluginObject[1][PluginObject[2]](event, ...)
						end
					end
				else
					if (PluginObject.Enabled and PluginObject.__enabled) then
						PluginObject:OnDetailsEvent(event, ...)
					end
				end
			end
			
		elseif (type(object) == "string" and object == "SEND_TO_ALL") then
			
			for _, PluginObject in ipairs(_details.RaidTables.Plugins) do 
				if (PluginObject.__enabled) then
					PluginObject:OnDetailsEvent(event)
				end
			end
			
			for _, PluginObject in ipairs(_details.SoloTables.Plugins) do 
				if (PluginObject.__enabled) then
					PluginObject:OnDetailsEvent(event)
				end
			end
			
			for _, PluginObject in ipairs(_details.ToolBar.Plugins) do 
				if (PluginObject.__enabled) then
					PluginObject:OnDetailsEvent(event)
				end
			end
		else
		--> send the event only for requested plugin
			if (object.Enabled and object.__enabled) then
				return object:OnDetailsEvent(event, ...)
			end
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> listeners

	local listener_meta = setmetatable({}, _details)
	listener_meta.__index = listener_meta
	
	function listener_meta:RegisterEvent(event, func)
		return _details:RegisterEvent(self, event, func)
	end
	function listener_meta:UnregisterEvent(event)
		return _details:UnregisterEvent(self, event)
	end
	
	function _details:CreateEventListener()
		local new = {Enabled = true, __enabled = true}
		setmetatable(new, listener_meta)
		return new
	end