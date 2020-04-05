



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> basic stuff

	local _
	local _details = _G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	
	--> mantain the enabled time captures
	_details.timeContainer = {}
	_details.timeContainer.Exec = {}
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers
	local ipairs = ipairs
	local _math_floor = math.floor
	local time = time

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local INDEX_NAME = 1
	local INDEX_FUNCTION = 2
	local INDEX_MATRIX = 3
	local INDEX_AUTHOR = 4
	local INDEX_VERSION = 5
	local INDEX_ICON = 6
	local INDEX_ENABLED = 7
	
	local DEFAULT_USER_MATRIX = {max_value = 0, last_value = 0}
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> register and unregister captures


	function _details:TimeDataUpdate(index_or_name, name, func, matrix, author, version, icon, is_enabled)
		
		local this_capture
		if (type(index_or_name) == "number") then
			this_capture = _details.savedTimeCaptures[index_or_name]
		else
			for index, t in ipairs(_details.savedTimeCaptures) do
				if (t[INDEX_NAME] == index_or_name) then
					this_capture = t
				end
			end
		end
		
		if (not this_capture) then
			return false
		end
		
		if (this_capture.do_not_save) then
			return _details:Msg("This capture belongs to a plugin and cannot be edited.")
		end
		
		this_capture[INDEX_NAME] = name or this_capture[INDEX_NAME]
		this_capture[INDEX_FUNCTION] = func or this_capture[INDEX_FUNCTION]
		this_capture[INDEX_MATRIX] = matrix or this_capture[INDEX_MATRIX]
		this_capture[INDEX_AUTHOR] = author or this_capture[INDEX_AUTHOR]
		this_capture[INDEX_VERSION] = version or this_capture[INDEX_VERSION]
		this_capture[INDEX_ICON] = icon or this_capture[INDEX_ICON]
		
		if (is_enabled ~= nil) then
			this_capture[INDEX_ENABLED] = is_enabled
		else
			this_capture[INDEX_ENABLED] = this_capture[INDEX_ENABLED]
		end
		
		if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
			_G.DetailsOptionsWindow16UserTimeCapturesFillPanel.MyObject:Refresh()
		end
		
		return true
		
	end

	function _details:TimeDataRegister(name, func, matrix, author, version, icon, is_enabled, force_no_save)
	
		--> check name
		if (not name) then
			return "Couldn't register the time capture, name was nil."
		end
		
		--> check if the name already exists
		for index, t in ipairs(_details.savedTimeCaptures) do
			if (t[INDEX_NAME] == name) then
				return "Couldn't register the time capture, name already registred."
			end
		end
		
		--> check function
		if (not func) then
			return "Couldn't register the time capture, invalid function."
		end
		
		local no_save = nil
		--> passed a function means that this isn't came from a user
		--> so the plugin register the capture every time it loads.
		if (type(func) == "function") then
			no_save = true
		
		--> this a custom capture from a user, so we register a default user table for matrix
		elseif (type(func) == "string") then
			matrix = DEFAULT_USER_MATRIX
			
		end
		
		if (not no_save and force_no_save) then
			no_save = true
		end
		
		--> check matrix
		if (not matrix or type(matrix) ~= "table") then
			return "Couldn't register the time capture, matrix was invalid."
		end
		
		author = author or "Unknown"
		version = version or "v1.0"
		icon = icon or[[Interface\InventoryItems\WoWUnknownItem01]]
		
		tinsert(_details.savedTimeCaptures, {name, func, matrix, author, version, icon, is_enabled, do_not_save = no_save})
		
		if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
			_G.DetailsOptionsWindow16UserTimeCapturesFillPanel.MyObject:Refresh()
		end
		
		return true
		
	end
	
	--> unregister
	function _details:TimeDataUnregister(name)
		if (type(name) == "number") then
			tremove(_details.savedTimeCaptures, name)
			if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
				_G.DetailsOptionsWindow16UserTimeCapturesFillPanel.MyObject:Refresh()
			end
		else
			for index, t in ipairs(_details.savedTimeCaptures) do
				if (t[INDEX_NAME] == name) then
					tremove(_details.savedTimeCaptures, index)
					if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
						_G.DetailsOptionsWindow16UserTimeCapturesFillPanel.MyObject:Refresh()
					end
					return true
				end
			end
			return false
		end
	end
	
	--> cleanup when logout
	function _details:TimeDataCleanUpTimerary()
		local new_table = {}
		for index, t in ipairs(_details.savedTimeCaptures) do
			if (not t.do_not_save) then
				tinsert(new_table, t)
			end
		end
		_details.savedTimeCaptures = new_table
	end

	local tick_time = 0
	
	--> starting a combat
	function _details:TimeDataCreateCombatTables()
		
		--> create capture table
		local data_captured = {}
	
		--> drop the last capture exec table without wiping
		local exec = {}
		_details.timeContainer.Exec = exec
		
		--> build the exec table
		for index, t in ipairs(_details.savedTimeCaptures) do
			if (t[INDEX_ENABLED]) then
			
				local data = {}
				data_captured[t[INDEX_NAME]] = data
			
				if (type(t[INDEX_FUNCTION]) == "string") then
					--> user
					local func = loadstring(t[INDEX_FUNCTION])
					if (func) then
						tinsert(exec, { func = func, data = data, attributes = table_deepcopy(t[INDEX_MATRIX]), is_user = true })
					end
				else
					--> plugin
					tinsert(exec, { func = t[INDEX_FUNCTION], data = data, attributes = table_deepcopy(t[INDEX_MATRIX]) })
				end
			
			end
		end
	
		tick_time = 0
	
		--> return the capture table the to combat object
		return data_captured
	end
	
	local exec_user_func = function(func, attributes, data, this_second)
		
		local result = func()
		
		local current = result - attributes.last_value
		data[this_second] = current
		
		if (current > attributes.max_value) then
			attributes.max_value = current
			data.max_value = current
		end
		
		attributes.last_value = result
		
	end
	
	function _details:TimeDataTick()
	
		tick_time = tick_time + 1
	
		for index, t in ipairs(_details.timeContainer.Exec) do 
		
			if (t.is_user) then
				--> by a user
				exec_user_func(t.func, t.attributes, t.data, tick_time)
				
			else
				--> by a plugin
				t.func(t.attributes, t.data, tick_time)
				
			end
		
		end
	
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> broker dps stuff

	local ToKFunctions = _details.ToKFunctions

	local broker_functions = {
		-- raid dps[1]
		function()
			local combat = _details.table_current
			local time = combat:GetCombatTime()
			if (not time or time == 0) then
				return 0
			else
				return ToKFunctions[_details.minimap.text_format](_, combat.totals_group[1] / time)
			end
		end,
		-- raid hps[2]
		function()
			local combat = _details.table_current
			local time = combat:GetCombatTime()
			if (not time or time == 0) then
				return 0
			else
				return ToKFunctions[_details.minimap.text_format](_, combat.totals_group[2] / time)
			end
		end
	}
	

	local get_combat_time = function()
		local combat_time = _details.table_current:GetCombatTime()
		local minutes, seconds = _math_floor(combat_time / 60), _math_floor(combat_time % 60)
		if (seconds < 10) then
			seconds = "0" .. seconds
		end
		return minutes .. "m " .. seconds .. "s"
	end
	
	local get_damage_position = function()
		local damage_container = _details.table_current[1]
		damage_container:SortByKey("total")
		
		local pos = 1
		for index, actor in ipairs(damage_container._ActorTable) do
			if (actor.group) then
				if (actor.name == _details.playername) then
					return pos
				end
				pos = pos + 1
			end
		end
		
		return 0
	end
	
	local get_heal_position = function()
		local heal_container = _details.table_current[2]
		heal_container:SortByKey("total")

		local pos = 1
		for index, actor in ipairs(heal_container._ActorTable) do
			if (actor.group) then
				if (actor.name == _details.playername) then
					return pos
				end
				pos = pos + 1
			end
		end
		
		return 0
	end
	
	local get_damage_diff = function()
		local damage_container = _details.table_current[1]
		damage_container:SortByKey("total")
		
		local first
		local first_index
		for index, actor in ipairs(damage_container._ActorTable) do
			if (actor.group) then
				first = actor
				first_index = index
				break
			end
		end

		if (first) then
			if (first.name == _details.playername) then
				local second
				local container = damage_container._ActorTable
				for i = first_index+1, #container do
					if (container[i].group) then
						second = container[i]
						break
					end
				end
				
				if (second) then
					local diff = first.total - second.total
					return "+" .. ToKFunctions[_details.minimap.text_format](_, diff)
				else
					return "0"
				end
			else
				local player = damage_container._NameIndexTable[_details.playername]
				if (player) then
					player = damage_container._ActorTable[player]
					local diff = first.total - player.total
					return "-" .. ToKFunctions[_details.minimap.text_format](_, diff)
				else
					return ToKFunctions[_details.minimap.text_format](_, first.total)
				end
			end
		else
			return "0"
		end
	end
	
	local get_heal_diff = function()
		local heal_container = _details.table_current[2]
		heal_container:SortByKey("total")
		
		local first
		local first_index
		for index, actor in ipairs(heal_container._ActorTable) do
			if (actor.group) then
				first = actor
				first_index = index
				break
			end
		end
		
		if (first) then
			if (first.name == _details.playername) then
				local second
				local container = heal_container._ActorTable
				for i = first_index+1, #container do
					if (container[i].group) then
						second = container[i]
						break
					end
				end
				
				if (second) then
					local diff = first.total - second.total
					return "+" .. ToKFunctions[_details.minimap.text_format](_, diff)
				else
					return "0"
				end
			else
				local player = heal_container._NameIndexTable[_details.playername]
				if (player) then
					player = heal_container._ActorTable[player]
					local diff = first.total - player.total
					return "-" .. ToKFunctions[_details.minimap.text_format](_, diff)
				else
					return ToKFunctions[_details.minimap.text_format](_, first.total)
				end
			end
		else
			return "0"
		end
	end
	
	local get_player_dps = function()
		local damage_player = _details.table_current(1, _details.playername)
		if (damage_player) then
			local combat_time = _details.table_current:GetCombatTime()
			if (combat_time > 0) then
				return ToKFunctions[_details.minimap.text_format](_, damage_player.total / combat_time)
			else
				return 0
			end
		else
			return 0
		end
	end
	
	local get_player_hps = function()
		local heal_player = _details.table_current(2, _details.playername)
		if (heal_player) then
			local combat_time = _details.table_current:GetCombatTime()
			if (combat_time > 0) then
				return ToKFunctions[_details.minimap.text_format](_, heal_player.total / combat_time)
			else
				return 0
			end
		else
			return 0
		end
	end
	
	local get_player_damage = function()
		local damage_player = _details.table_current(1, _details.playername)
		if (damage_player) then
			return ToKFunctions[_details.minimap.text_format](_, damage_player.total)
		else
			return 0
		end
	end
	
	local get_player_heal = function()
		local heal_player = _details.table_current(2, _details.playername)
		if (heal_player) then
			return ToKFunctions[_details.minimap.text_format](_, heal_player.total)
		else
			return 0
		end
	end
	
	local parse_broker_text = function()
	
		local text = _details.data_broker_text
		if (text == "") then
			return
		end
		
		text = text:gsub("{dmg}", get_player_damage)
		text = text:gsub("{dps}", get_player_dps)
		text = text:gsub("{heal}", get_player_heal)
		text = text:gsub("{hps}", get_player_hps)
		text = text:gsub("{time}", get_combat_time)
		text = text:gsub("{dpos}", get_damage_position)
		text = text:gsub("{hpos}", get_heal_position)
		text = text:gsub("{ddiff}", get_damage_diff)
		text = text:gsub("{hdiff}", get_heal_diff)

		return text
	end
	
	function _details:BrokerTick()
		_details.databroker.text = parse_broker_text()
	end
	