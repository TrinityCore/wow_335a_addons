--[[
LibDebugLog-1.0 - Library providing simple debug logging for WoW addons
Copyright (C) 2008 Adirelle

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
--]]

local MAJOR, MINOR = "LibDebugLog-1.0", 100000 + tonumber(("$Revision: 22 $"):match("%d+"))
assert(LibStub, MAJOR.." requires LibStub")
local CBH = LibStub("CallbackHandler-1.0",false)
assert(CBH, MAJOR.." requires CallbackHandler-1.0")
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

lib.loggers = lib.loggers or {}
lib.debugging = lib.debugging or {}
lib.mixins = lib.mixins or {}
lib.options = lib.options or {}
lib.callbacks = lib.callbacks or CBH:New(lib)	

function lib.callbacks:OnUsed(_, event)
	if event == "MessageLogged" then
		lib.quiet = true
	end
end

function lib.callbacks:OnUnused(_, event)
	if event == "MessageLogged" then
		lib.quiet = false
	end
end

local loggers = lib.loggers
local debugging = lib.debugging
local mixins = lib.mixins
local options = lib.options

function mixins:ToggleDebugLog(value)
	value = not not value
	if value ~= debugging[self] then
		if not value then
			self:Debug("Debug disabled")
		end
		debugging[self] = value
		if value then
			self:Debug("Debug enabled")
		end
		lib.callbacks:Fire(value and 'DebugLogEnabled' or 'DebugLogDisabled', self, value)
	end
end

function mixins:IsDebugLogEnabled()
	return debugging[self]
end

do
	-- Based on AceDebug-2.0
	local tmp = {}
	local function LogMessage(self, a1, ...)
		if lib.globalToggle == false or (lib.globalToggle == nil and not debugging[self]) then return end
		local message, now, n = "", GetTime(), select('#', ...)
		a1 = tostring(a1)
		if a1:find("%%") and n > 0 then
			message = a1:format(tostringall(...))
		else
			for i=1,n do 
				tmp[i] = tostring(select(i, ...)) 
			end
			message = a1 .. " " .. table.concat(tmp, " ")
			wipe(tmp)
		end
		if lib.quiet then
			lib.callbacks:Fire("MessageLogged", self, now, message)
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cff7fff7f(DEBUG) %s:[%s.%3d]|r: %s"):format(
					tostring(self), date("%H:%M:%S"), (now % 1) * 1000, message
				)
			)
		end
	end
	
	function mixins:Debug(...)
		local success, errorMsg = pcall(LogMessage, self, ...)
		if not success then
			geterrorhandler()(errorMsg)
		end
	end
end

function lib:SetGlobalToggle(value)
	if value ~= nil then
		value = not not value
	end
	if value ~= lib.globalToggle then
		lib.globalToggle = value
		lib.callbacks:Fire(value and 'GlobalDebugEnabled' or 'GlobalDebugDisabled', value)
	end
end

function lib:GetGlobalToggle()
	return lib.globalToggle
end

function lib:GetAce3OptionTable(logger, order)
	if not loggers[logger] then return end
	if not options[logger] then
		options[logger] = {
			name = 'Enable debug logs',
			type = 'toggle',
			get = function(info) return logger:IsDebugLogEnabled() end,
			set = function(info, value) return logger:ToggleDebugLog(value) end,
			disabled = function() return lib.globalToggle ~= nil end,
			order = order or 100,
		}
	end
	return options[logger]
end

do
	local function iter(onlyNamed, logger)
		while true do
			local name
			logger, name = next(loggers, logger)
			if not logger then
				return
			elseif not onlyNamed or name ~= true then
				return logger, name
			end
		end
	end
	function lib:IterateLoggers(onlyNamed)
		return iter, onlyNamed
	end
end

function lib:Embed(logger)
	assert(type(logger) == 'table')
	for name,func in pairs(mixins) do
		logger[name] = func
	end
	if not loggers[logger] then
		local name = rawget(logger, 'name')
		loggers[logger] = name or true
		self.callbacks:Fire('NewLogger', logger, name)
		self.callbacks:Fire('NewBroker', logger, name) -- Compat
	end
end

function lib:GetLoggerName(logger)
	local name = loggers[logger]
	return name ~= true and name or nil
end

lib.GetBrokerName = lib.GetLoggerName -- Compat
lib.IterateBrokers = lib.IterateLoggers -- Compat

for logger in pairs(loggers) do
	lib:Embed(logger)
end

