--

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = 		_G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local _
	
	_details.network = {}
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _UnitName = UnitName
	local _GetRealmName = GetRealmName
	local _select = select
	local _table_wipe = table.wipe
	local _math_min = math.min
	local _string_gmatch = string.gmatch
	local _pairs = pairs

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local CONST_DETAILS_PREFIX = "DTLS"

	local CONST_HIGHFIVE_REQUEST = "HI"
	local CONST_HIGHFIVE_DATA = "HF"
	
	local CONST_VERSION_CHECK = "CV"
	
	local CONST_CLOUD_REQUEST = "CR"
	local CONST_CLOUD_FOUND = "CF"
	local CONST_CLOUD_DATARQ = "CD"
	local CONST_CLOUD_DATARC = "CE"
	local CONST_CLOUD_EQUALIZE = "EQ"
	
	_details.network.ids = {
		["HIGHFIVE_REQUEST"] = CONST_HIGHFIVE_REQUEST,
		["HIGHFIVE_DATA"] = CONST_HIGHFIVE_DATA,
		["VERSION_CHECK"] = CONST_VERSION_CHECK,
		["CLOUD_REQUEST"] = CONST_CLOUD_REQUEST,
		["CLOUD_FOUND"] = CONST_CLOUD_FOUND,
		["CLOUD_DATARQ"] = CONST_CLOUD_DATARQ,
		["CLOUD_DATARC"] = CONST_CLOUD_DATARC,
		["CLOUD_EQUALIZE"] = CONST_CLOUD_EQUALIZE,
	}
	
	local plugins_registred = {}
	
	local temp = {}
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> comm functions

	function _details.network.HighFive_Request()
		return _details:SendRaidData(CONST_HIGHFIVE_DATA, _details.userversion)
	end
	
	function _details.network.HighFive_DataReceived(player, realm, core_version, user_version)
		if (_details.sent_highfive and _details.sent_highfive + 30 > GetTime()) then
			_details.users[#_details.users+1] = {player, realm,(user_version or "") .. "(" .. core_version .. ")"}
		end
	end
	
	function _details.network.Update_VersionReceived(player, realm, core_version, build_number)
		if (_details.debug) then
			_details:Msg("(debug) received version alert ", build_number)
		end
	
		build_number = tonumber(build_number)
	
		if (not _details.build_counter or not _details.lastUpdateWarning or not build_number) then
			return
		end
	
		if (build_number > _details.build_counter) then
			if (time() > _details.lastUpdateWarning + 72000) then
				local lower_instance = _details:GetLowerInstanceNumber()
				if (lower_instance) then
					lower_instance = _details:GetInstance(lower_instance)
					if (lower_instance) then
						lower_instance:InstanceAlert("Update Available!", {[[Interface\GossipFrame\AvailableQuestIcon]], 16, 16, false}, 360, {_details.OpenUpdateWindow})
					end
				end
				_details.lastUpdateWarning = time()
			end
		end
	end
	
	function _details.network.Cloud_Request(player, realm, core_version, ...)
		if (_details.debug) then
			_details:Msg("(debug)", player, _details.host_of, _details:CaptureIsAllEnabled(), core_version == _details.realversion)
		end
		if (player ~= _details.playername) then
			if (not _details.host_of and _details:CaptureIsAllEnabled() and core_version == _details.realversion) then
				if (realm ~= _GetRealmName()) then
					player = player .."-"..realm
				end
				_details.host_of = player
				if (_details.debug) then
					_details:Msg("(debug) sent 'okey' answer for a cloud parser request.")
				end
				_details:SendCommMessage(CONST_DETAILS_PREFIX, _details:Serialize(_details.network.ids.CLOUD_FOUND, _UnitName("player"), _GetRealmName(), _details.realversion), "WHISPER", player)
			end
		end
	end
	
	function _details.network.Cloud_Found(player, realm, core_version, ...)
		if (_details.host_by) then
			return
		end
	
		if (realm ~= _GetRealmName()) then
			player = player .."-"..realm
		end
		_details.host_by = player
		
		if (_details.debug) then
			_details:Msg("(debug) cloud found for disabled captures.")
		end
		
		_details.cloud_process = _details:ScheduleRepeatingTimer("RequestCloudData", 10)
		_details.last_data_requested = _details._time
	end
	
	function _details.network.Cloud_DataRequest(player, realm, core_version, ...)
		if (not _details.host_of) then
			return
		end
		
		local attribute, subattribute = player, realm
		
		local data
		local attribute_name = _details:GetInternalSubAttributeName(attribute, subattribute)
		
		if (attribute == 1) then
			data = _details.attribute_damage:RefreshWindow({}, _details.table_current, nil, { key = attribute_name, mode = _details.modes.group })
		elseif (attribute == 2) then
			data = _details.attribute_heal:RefreshWindow({}, _details.table_current, nil, { key = attribute_name, mode = _details.modes.group })
		elseif (attribute == 3) then
			data = _details.attribute_energy:RefreshWindow({}, _details.table_current, nil, { key = attribute_name, mode = _details.modes.group })
		elseif (attribute == 4) then
			data = _details.attribute_misc:RefreshWindow({}, _details.table_current, nil, { key = attribute_name, mode = _details.modes.group })
		else
			return
		end
		
		if (data) then
			local export = temp
			local container = _details.table_current[attribute]._ActorTable
			for i = 1, _math_min(6, #container) do 
				local actor = container[i]
				if (actor.group) then
					export[#export+1] = {actor.name, actor[attribute_name]}
				end
			end
			
			if (_details.debug) then
				_details:Msg("(debug) requesting data from the cloud.")
			end
			
			_details:SendCommMessage(CONST_DETAILS_PREFIX, _details:Serialize(CONST_CLOUD_DATARC, attribute, attribute_name, export), "WHISPER", _details.host_of)
			_table_wipe(temp)
		end
	end
	
	function _details.network.Cloud_DataReceived(player, realm, core_version, ...)
		local attribute, attribute_name, data = player, realm, core_version
		
		local container = _details.table_current[attribute]
		
		if (_details.debug) then
			_details:Msg("(debug) received data from the cloud.")
		end
		
		for i = 1, #data do 
			local _this = data[i]
			
			local name = _this[1]
			local actor = container:CatchCombatant(nil, name)
			
			if (not actor) then
				if (GetNumRaidMembers() > 0) then
					for i = 1, GetNumRaidMembers() do 
						if (name:find("-")) then --> other realm
							local nname, server = _UnitName("raid"..i)
							if (server and server ~= "") then
								nname = nname.."-"..server
							end
							if (nname == name) then
								actor = container:CatchCombatant(UnitGUID("raid"..i), name, 0x514, true)
								break
							end
						else
							if (_UnitName("raid"..i) == name) then
								actor = container:CatchCombatant(UnitGUID("raid"..i), name, 0x514, true)
								break
							end
						end

					end
				elseif (GetNumPartyMembers() > 0) then
					for i = 1, GetNumPartyMembers() do
						if (name:find("-")) then --> other realm
							local nname, server = _UnitName("party"..i)
							if (server and server ~= "") then
								nname = nname.."-"..server
							end
							if (nname == name) then
								actor = container:CatchCombatant(UnitGUID("party"..i), name, 0x514, true)
								break
							end
						else
							if (_UnitName("party"..i) == name or _details.playername == name) then
								actor = container:CatchCombatant(UnitGUID("party"..i), name, 0x514, true)
								break
							end
						end
					end
				end
			end

			if (actor) then
				actor[attribute_name] = _this[2]
				container.need_refresh = true
			else
				if (_details.debug) then
					_details:Msg("(debug) actor not found on cloud data received", name, attribute_name)
				end
			end
		end
	end
	
	function _details.network.Cloud_Ewhichize(player, realm, core_version, data)
		if (not _details.in_combat) then
			if (core_version ~= _details.realversion) then
				return
			end
			_details:MakeEwhichizeOnActor(player, realm, data)
		end
	end
	
	_details.network.functions = {
		[CONST_HIGHFIVE_REQUEST] = _details.network.HighFive_Request,
		[CONST_HIGHFIVE_DATA] = _details.network.HighFive_DataReceived,
		[CONST_VERSION_CHECK] = _details.network.Update_VersionReceived,
		
		[CONST_CLOUD_REQUEST] = _details.network.Cloud_Request,
		[CONST_CLOUD_FOUND] = _details.network.Cloud_Found,
		[CONST_CLOUD_DATARQ] = _details.network.Cloud_DataRequest,
		[CONST_CLOUD_DATARC] = _details.network.Cloud_DataReceived,
		[CONST_CLOUD_EQUALIZE] = _details.network.Cloud_Ewhichize,
	}
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> register comm

	function _details:CommReceived(_, data, _, source)
		local prefix, player, realm, dversion, arg6, arg7, arg8, arg9 =  _select(2, _details:Deserialize(data))
		
		if (_details.debug) then
			_details:Msg("(debug) network received:", prefix, "length:",string.len(data))
		end
		
		local func = _details.network.functions[prefix]
		if (func) then
			func(player, realm, dversion, arg6, arg7, arg8, arg9)
		else
			func = plugins_registred[prefix]
			if (func) then
				func(player, realm, dversion, arg6, arg7, arg8, arg9)
			else
				if (_details.debug) then
					_details:Msg("comm prefix not found:", prefix)
				end
			end
		end
	end

	_details:RegisterComm("DTLS", "CommReceived")
	
	function _details:RegisterPluginComm(prefix, func)
		assert(type(prefix) == "string" and string.len(prefix) >= 2 and string.len(prefix) <= 4, "RegisterPluginComm expects a string with 2-4 characters on #1 argument.")
		assert(type(func) == "function" or(type(func) == "string" and type(self[func]) == "function"), "RegisterPluginComm expects a function or function name on #2 argument.")
		assert(plugins_registred[prefix] == nil, "Prefix " .. prefix .. " already in use 1.")
		assert(_details.network.functions[prefix] == nil, "Prefix " .. prefix .. " already in use 2.")
		
		if (type(func) == "string") then
			plugins_registred[prefix] = self[func]
		else
			plugins_registred[prefix] = func
		end
		return true
	end
	
	function _details:UnregisterPluginComm(prefix)
		plugins_registred[prefix] = nil
		return true
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> send functions

	function _details:GetChannelId(channel)
		for id = 1, GetNumDisplayChannels() do 
			local name, _, _, room_id = GetChannelDisplayInfo(id)
			if (name == channel) then
				return room_id
			end
		end
	end
	
	function _details.parser_functions:CHAT_MSG_CHANNEL(...)
		local message, _, _, _, _, _, _, _, channelName = ...
		if (channelName == "Details") then
			local prefix, data = strsplit("_", message, 2)
			
			local func = plugins_registred[prefix]
			if (func) then
				func(_select(2, _details:Deserialize(data)))
			else
				if (_details.debug) then
					_details:Msg("comm prefix not found:", prefix)
				end
			end

		end
	end

	function _details:SendPluginCommMessage(prefix, channel, ...)
	
		if (not _details:IsConnected()) then
			return false
		end
	
		if (not channel) then
			channel = "Details"
		end
		
		if (channel == "RAID") then
				_details:SendCommMessage(prefix, _details:Serialize(self.__version, ...), "RAID")			
		elseif (channel == "PARTY") then
				_details:SendCommMessage(prefix, _details:Serialize(self.__version, ...), "PARTY")		
		elseif (channel == "Details") then
			local id = _details:GetChannelId(channel)
			if (id) then
				SendChatMessage(prefix .. "_" .. _details:Serialize(self.__version, ...), "CHANNEL", nil, id)
			end
			
		else
			_details:SendCommMessage(prefix, _details:Serialize(self.__version, ...), channel)
		end
		
		return true
	end
	
	
	--> send as
	function _details:SendRaidDataAs(type, player, realm, ...)
		if (not realm) then
			--> check if realm is already inside player name
			for _name, _realm in _string_gmatch(player, "(%w+)-(%w+)") do
				if (_realm) then
					player = _name
					realm = _realm
				end
			end
		end
		if (not realm) then
			--> doesn't have realm at all, so we assume the actor is in same realm as player
			realm = _GetRealmName()
		end
		_details:SendCommMessage(CONST_DETAILS_PREFIX, _details:Serialize(type, player, realm, _details.realversion, ...), "RAID")
	end
	
	function _details:SendRaidData(type, ...)
		_details:SendCommMessage(CONST_DETAILS_PREFIX, _details:Serialize(type, _UnitName("player"), _GetRealmName(), _details.realversion, ...), "RAID")
	end
	
	function _details:SendPartyData(type, ...)
		_details:SendCommMessage(CONST_DETAILS_PREFIX, _details:Serialize(type, _UnitName("player"), _GetRealmName(), _details.realversion, ...), "PARTY")
	end
	
	function _details:SendGuildData(type, ...)
		_details:SendCommMessage(CONST_DETAILS_PREFIX, _details:Serialize(type, _UnitName("player"), _GetRealmName(), _details.realversion, ...), "GUILD")
	end
	


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> cloud

	function _details:SendCloudRequest()
		_details:SendRaidData(_details.network.ids.CLOUD_REQUEST)
	end
	
	function _details:ScheduleSendCloudRequest()
		_details:ScheduleTimer("SendCloudRequest", 1)
	end

	function _details:RequestCloudData()
		_details.last_data_requested = _details._time

		if (not _details.host_by) then
			return
		end
	
		for index = 1, #_details.table_instances do
			local instance = _details.table_instances[index]
			if (instance.active) then
				local attribute = instance.attribute
				if (attribute == 1 and not _details:CaptureGet("damage")) then
					_details:SendCommMessage(CONST_DETAILS_PREFIX, _details:Serialize(CONST_CLOUD_DATARQ, attribute, instance.sub_attribute), "WHISPER", _details.host_by)
					break
				elseif (attribute == 2 and(not _details:CaptureGet("heal") or _details:CaptureGet("aura"))) then
					_details:SendCommMessage(CONST_DETAILS_PREFIX, _details:Serialize(CONST_CLOUD_DATARQ, attribute, instance.sub_attribute), "WHISPER", _details.host_by)
					break
				elseif (attribute == 3 and not _details:CaptureGet("energy")) then
					_details:SendCommMessage(CONST_DETAILS_PREFIX, _details:Serialize(CONST_CLOUD_DATARQ, attribute, instance.sub_attribute), "WHISPER", _details.host_by)
					break
				elseif (attribute == 4 and not _details:CaptureGet("miscdata")) then
					_details:SendCommMessage(CONST_DETAILS_PREFIX, _details:Serialize(CONST_CLOUD_DATARQ, attribute, instance.sub_attribute), "WHISPER", _details.host_by)
					break
				end
			end
		end
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> update

	function _details:CheckVersion(send_to_guild)
		if (GetNumRaidMembers() > 0) then
			_details:SendRaidData(_details.network.ids.VERSION_CHECK, _details.build_counter)
		elseif (GetNumPartyMembers() > 0) then
			_details:SendPartyData(_details.network.ids.VERSION_CHECK, _details.build_counter)
		end
		
		if (send_to_guild) then
			_details:SendGuildData(_details.network.ids.VERSION_CHECK, _details.build_counter)
		end
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> sharer

	--> entrar no canal após logar no servidor
	function _details:EnterChatChannel()
		if (not _details.realm_sync) then
			return
		end
		
		if (_details.schedule_chat_leave) then
			_details:CancelTimer(_details.schedule_chat_leave)
			_details.schedule_chat_leave = nil
		end
		_details.schedule_chat_enter = nil
	
		local realm = GetRealmName()
		realm = realm or ""
		
		--if (realm ~= "Azralon") then
		--	return
		--end
	
		--> room name
		local room_name = "Details"

		_details.listener:RegisterEvent("CHAT_MSG_CHANNEL")
		
		--> already in?
		for room_index = 1, 10 do
			local _, name = GetChannelName(room_index)
			if (name == room_name) then
				_details.is_connected = true
				return --> already in the room
			end
		end
		
		--> enter
		--print("entrando no canal")
		JoinChannelByName(room_name)
		_details.is_connected = true
	end
	
	function _details:LeaveChatChannel()
		if (not _details.realm_sync) then
			return
		end
	
		if (_details.schedule_chat_enter) then
			_details:CancelTimer(_details.schedule_chat_enter)
			_details.schedule_chat_enter  = nil
		end
		_details.schedule_chat_leave = nil
	
		local realm = GetRealmName()
		realm = realm or ""
		
		--if (realm ~= "Azralon") then
		--	return
		--end
		
		--> room name
		local room_name = "Details"
		local is_in = false
		
		--> already in?
		for room_index = 1, 10 do
			local _, name = GetChannelName(room_index)
			if (name == room_name) then
				is_in = true
			end
		end
		
		if (is_in) then
			--print("saindo do canal")
			LeaveChannelByName(room_name)
		end
		
		_details.is_connected = false
		
		_details.listener:UnregisterEvent("CHAT_MSG_CHANNEL")
	end
	
	--> sair do canal quando estiver em group
	local event_handler = {Enabled = true, __enabled = true, test = " test"}
	function event_handler:ZONE_TYPE_CHANGED(zone_type)
		if (not _details.realm_sync) then
			return
		end

		if (zone_type == "none") then
			if (not _details:InGroup()) then
				if (_details.schedule_chat_leave) then
					_details:CancelTimer(_details.schedule_chat_leave)
				end
				if (not _details.schedule_chat_enter) then
					_details.schedule_chat_enter = _details:ScheduleTimer("EnterChatChannel", 2)
				end
			end
		else
			if (_details:InGroup()) then
				if (_details.schedule_chat_enter) then
					_details:CancelTimer(_details.schedule_chat_enter)
				end
				if (not _details.schedule_chat_leave) then
					_details.schedule_chat_leave = _details:ScheduleTimer("LeaveChatChannel", 2)
				end
			end
		end
	end
	
	function event_handler:GROUP_ONENTER()
		if (not _details.realm_sync) then
			return
		end
	
		if (_details.zone_type ~= "none") then
			if (_details.schedule_chat_enter) then
				_details:CancelTimer(_details.schedule_chat_enter)
			end
			if (not _details.schedule_chat_leave) then
				_details.schedule_chat_leave = _details:ScheduleTimer("LeaveChatChannel", 2)
			end
		end
	end
	
	function _details:CheckChatOnLeaveGroup()
		if (not _details.realm_sync) then
			return
		end
		
		_details.schedule_group_onleave_check = nil
		if (_details.zone_type == "none") then
			if (_details.schedule_chat_leave) then
				_details:CancelTimer(_details.schedule_chat_leave)
			end
			if (not _details.schedule_chat_enter) then
				_details.schedule_chat_enter = _details:ScheduleTimer("EnterChatChannel", 2)
			end
		end
	end
	function event_handler:GROUP_ONLEAVE()
		if (not _details.realm_sync) then
			return
		end
		
		if (_details.schedule_group_onleave_check) then
			_details:CancelTimer(_details.schedule_group_onleave_check)
			_details.schedule_group_onleave_check = nil
		end
		_details.schedule_group_onleave_check = _details:ScheduleTimer("CheckChatOnLeaveGroup", 5)
	end
	
	_details:RegisterEvent(event_handler, "GROUP_ONENTER", "GROUP_ONENTER")
	_details:RegisterEvent(event_handler, "GROUP_ONLEAVE", "GROUP_ONLEAVE")
	_details:RegisterEvent(event_handler, "ZONE_TYPE_CHANGED", "ZONE_TYPE_CHANGED")
	
	function _details:IsConnected()
		return _details.is_connected
	end