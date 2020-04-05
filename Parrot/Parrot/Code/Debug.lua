local Parrot = _G.Parrot
local mod = Parrot:NewModule("Debug", "AceHook-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("Parrot", true)

local db1
local debug_cache

local debugSpaces = {}

local dbDefaults = {
	profile = {
		sessions = {},
		filters = {},
	},
}

function mod:OnInitialize()
	db1 = Parrot.db1:RegisterNamespace("Debug", dbDefaults)
	--[===[@debug@
	mod.db1 = db1
	--@end-debug@]===]
	mod:SetEnabledState(false)
end

local function addDebugHook(module, key, func)
	mod:Hook(module, key, function(...)
			Parrot:SaveDebug(func(...))
		end)
end

local function newSession()
	debug_cache = {}
	table.insert(db1.profile.sessions, debug_cache)
end

function mod:OnEnable()
	newSession()
	for k,v in Parrot:IterateModules() do
		if type(v.GetDebugHooks) == 'function' then
			for key,func in pairs(v.GetDebugHooks()) do
				addDebugHook(v, key, func)
			end
		end
	end
end

function mod:OnDisable()
	mod:UnhookAll()
end

function Parrot:RegisterDebugSpace(name, replayfunc)
	debugSpaces[name] = replayfunc or true
end

function mod:SaveDebug(debugSpace, message, arg1, ...)
	if db1.profile.filters[debugSpace] then
		return
	end
	local entry = ("%s__%s__%s: "):format(debugSpace, GetTime(), message)
	if type(arg1) == 'table' then
		local first = true
		for k,v in pairs(arg1) do
			if first then
				first = false
				entry = entry .. ("%s = %s"):format(tostring(k), tostring(v))
			else
				entry = entry .. (",%s = %s"):format(tostring(k), tostring(v))
			end
		end
	else
		entry = entry .. ("#%d = %s"):format(1, tostring(select(1, ...)))
		for i = 2, select('#', ...) do
			entry = entry .. (", #%d = %s"):format(i, tostring(select(i, ...)))
		end
	end
	table.insert(debug_cache, entry)
end

function Parrot:SaveDebug(...)
	if mod:IsEnabled() then
		mod:SaveDebug(...)
	end
end

--function mod:PlayDebug()
	-- TODO implement
--end

function mod:OnOptionsCreate()
	--[===[@debug@
	local debug_opts = {
		type = 'group',
		name = L["Debug"],
		desc = L["Change debug settings"],
		order = 10,
		args = {
			debugmode = {
				type = 'toggle',
				name = L["Debug-mode"],
				desc = L["save Debuginformation in SavedVariables (costs CPU and Memory)"],
				set = function(info, value)
						if value then
							mod:Enable()
						else
							mod:Disable()
						end
					end,
				get = function(info)
						return mod:IsEnabled()
					end
			},
			clearall = {
				type = 'execute',
				name = L["Clear logs"],
				desc = L["Clear all saved logs"],
				disabled = function() return not mod:IsEnabled() end,
				func = function()
						mod:Disable()
						wipe(db1.profile.sessions)
						mod:Enable()
					end,
			},
		},
	}

	Parrot:AddOption('debug', debug_opts)
	--@end-debug@]===]
end
