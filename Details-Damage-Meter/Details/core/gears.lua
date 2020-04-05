local _details = 		_G._details
local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )


local GetNumGroupMembers = GetNumGroupMembers

function _details:UpdateGears()
	
	_details:UpdateParser()
	_details:UpdateControl()
	_details:UpdateCombat()
	
end

function _details:SetWindowUpdateSpeed(interval, nosave)
	if (not interval) then
		interval = _details.update_speed
	end
	
	if (not nosave) then
		_details.update_speed = interval
	end
	
	_details:CancelTimer(_details.atualizador)
	_details.atualizador = _details:ScheduleRepeatingTimer("UpdateGumpMain", interval, -1)
end

function _details:SetUseAnimations(enabled, nosave)
	if (enabled == nil) then
		enabled = _details.use_row_animations
	end
	
	if (not nosave) then
		_details.use_row_animations = enabled
	end
	
	_details.is_using_row_animations = enabled
end

function _details:HavePerformanceProfileEnabled()
	return _details.performance_profile_enabled
end

_details.PerformanceIcons = {
	["RaidFinder"] = {icon =[[Interface\PvPRankBadges\PvPRank15]], color = {1, 1, 1, 1}},
	["Raid15"] = {icon =[[Interface\PvPRankBadges\PvPRank15]], color = {1, .8, 0, 1}},
	["Raid30"] = {icon =[[Interface\PvPRankBadges\PvPRank15]], color = {1, .8, 0, 1}},
	["Mythic"] = {icon =[[Interface\PvPRankBadges\PvPRank15]], color = {1, .4, 0, 1}},
	["Battleground15"] = {icon =[[Interface\PvPRankBadges\PvPRank07]], color = {1, 1, 1, 1}},
	["Battleground40"] = {icon =[[Interface\PvPRankBadges\PvPRank07]], color = {1, 1, 1, 1}},
	["Arena"] = {icon =[[Interface\PvPRankBadges\PvPRank12]], color = {1, 1, 1, 1}},
	["Dungeon"] = {icon =[[Interface\PvPRankBadges\PvPRank01]], color = {1, 1, 1, 1}},
}

function _details:CheckForPerformanceProfile()
	
	local type = _details:GetPerformanceRaidType()
	
	local profile = _details.performance_profiles[type]
	
	if (profile and profile.enabled) then
		_details:SetWindowUpdateSpeed(profile.update_speed, true)
		_details:SetUseAnimations(profile.use_row_animations, true)
		_details:CaptureSet(profile.damage, "damage")
		_details:CaptureSet(profile.heal, "heal")
		_details:CaptureSet(profile.energy, "energy")
		_details:CaptureSet(profile.miscdata, "miscdata")
		_details:CaptureSet(profile.aura, "aura")
		
		if (not _details.performance_profile_lastenabled or _details.performance_profile_lastenabled ~= type) then
			_details:InstanceAlert(Loc["STRING_OPTIONS_PERFORMANCE_PROFILE_LOAD"] .. type, {_details.PerformanceIcons[type].icon, 14, 14, false, 0, 1, 0, 1, unpack(_details.PerformanceIcons[type].color)} , 5, {_details.empty_function})
		end
		
		_details.performance_profile_enabled = type
		_details.performance_profile_lastenabled = type
	else
		_details:SetWindowUpdateSpeed(_details.update_speed)
		_details:SetUseAnimations(_details.use_row_animations)
		_details:CaptureSet(_details.capture_real["damage"], "damage")
		_details:CaptureSet(_details.capture_real["heal"], "heal")
		_details:CaptureSet(_details.capture_real["energy"], "energy")
		_details:CaptureSet(_details.capture_real["miscdata"], "miscdata")
		_details:CaptureSet(_details.capture_real["aura"], "aura")
		_details.performance_profile_enabled = nil
	end
	
end

function _details:GetPerformanceRaidType()

	local name, type, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()

	if (type == "none") then
		return nil
	end
	
	if (type == "pvp") then
		if (maxPlayers == 40) then
			return "Battleground40"
		elseif (maxPlayers == 15) then
			return "Battleground15"
		else
			return nil
		end
	end
	
	if (type == "arena") then
		return "Arena"
	end

	if (type == "raid") then
		--mythic
		--if (difficulty == 15) then
		--	return "Mythic"
		--end
		
		--raid finder
		if (difficulty == 7) then
			return "RaidFinder"
		end
		
		--flex
		if (difficulty == 14) then
			if (GetNumRaidMembers() > 15) then
				return "Raid30"
			else
				return "Raid15"
			end
		end
		
		--normal heroic
		if (maxPlayers == 10) then
			return "Raid15"
		elseif (maxPlayers == 25) then
			return "Raid30"
		end
	end
	
	if (type == "party") then
		return "Dungeon"
	end
	
	return nil
end

local background_tasks = {}
local task_timers = {
	["LOW"] = 30,
	["MEDIUM"] = 18,
	["HIGH"] = 10,
}

function _details:RegisterBackgroundTask(name, func, priority, ...)

	assert(type(self) == "table", "RegisterBackgroundTask 'self' must be a table.")
	assert(type(name) == "string", "RegisterBackgroundTask param #1 must be a string.")
	if (type(func) == "string") then
		assert(type(self[func]) == "function", "RegisterBackgroundTask param #2 function not found on main object.")
	else
		assert(type(func) == "function", "RegisterBackgroundTask param #2 expect a function or function name.")
	end
	
	priority = priority or "LOW"
	priority = string.upper(priority)
	if (not task_timers[priority]) then
		priority = "LOW"
	end

	if (background_tasks[name]) then
		background_tasks[name].func = func
		background_tasks[name].priority = priority
		background_tasks[name].args = {...}
		background_tasks[name].args_amt = select("#", ...)
		background_tasks[name].object = self
		return
	else
		background_tasks[name] = {func = func, lastexec = time(), priority = priority, nextexec = time() + task_timers[priority] * 60, args = {...}, args_amt = select("#", ...), object = self}
	end
end

function _details:UnregisterBackgroundTask(name)
	background_tasks[name] = nil
end

function _details:DoBackgroundTasks()
	if (_details:GetZoneType() ~= "none" or _details:InGroup()) then
		return
	end
	
	local t = time()
	
	for taskName, taskTable in pairs(background_tasks) do 
		if (t > taskTable.nextexec) then
			if (type(taskTable.func) == "string") then
				taskTable.object[taskTable.func](taskTable.object, unpack(taskTable.args, 1, taskTable.args_amt))
			else
				taskTable.func(unpack(taskTable.args, 1, taskTable.args_amt))
			end

			taskTable.nextexec = random(30, 120) + t +(task_timers[taskTable.priority] * 60)
		end
	end
end

_details.background_tasks_loop = _details:ScheduleRepeatingTimer("DoBackgroundTasks", 120)
