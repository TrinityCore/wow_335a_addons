--[[
LibAdiEvent-1.0 - Event handling library
(c) 2009 Adirelle (adirelle@tagada-team.net)
All rights reserved.
--]]

local MAJOR, MINOR = 'LibAdiEvent-1.0', 3
local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end
oldMinor = oldMinor or 0

-- Safecall dispatcher (ripped from CBH)

local type = type
local pcall = pcall
local pairs = pairs
local assert = assert
local concat = table.concat
local loadstring = loadstring
local next = next
local select = select
local type = type
local xpcall = xpcall
local tinsert = tinsert
local tremove = tremove

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function CreateDispatcher(argCount)
	local code = [[
	local next, xpcall, eh = ...

	local method, ARGS
	local function call() return method(ARGS) end

	local function dispatch(handlers, ...)
		local index
		index, method = next(handlers)
		if not method then return end
		local OLD_ARGS = ARGS
		ARGS = ...
		repeat
			xpcall(call, eh)
			index, method = next(handlers, index)
		until not method
		ARGS = OLD_ARGS
	end

	return dispatch
	]]

	local ARGS, OLD_ARGS = {}, {}
	for i = 1, argCount do ARGS[i], OLD_ARGS[i] = "arg"..i, "old_arg"..i end
	code = code:gsub("OLD_ARGS", concat(OLD_ARGS, ", ")):gsub("ARGS", concat(ARGS, ", "))
	return assert(loadstring(code, "safecall Dispatcher["..argCount.."]"))(next, xpcall, errorhandler)
end

lib.__dispatchers = setmetatable(lib.__dispatchers or {}, {__index=function(self, argCount)
	local dispatcher = CreateDispatcher(argCount)
	rawset(self, argCount, dispatcher)
	return dispatcher
end})

-- Internal frame

local function GetInternalFrame(noSpawn)
	if not lib.frame then
		if noSpawn then return end
		lib.frame = CreateFrame("Frame", "LibAdiEvent10Frame")
		lib.Embed(lib.frame)		
	end
	return lib.frame
end

-- Event dispatching

lib.handlers = lib.handlers or {}
local handlers = lib.handlers

function lib.TriggerEvent(self, event, ...)
	local eventHandlers = handlers[self][event]
	if eventHandlers then
		lib.__dispatchers[select('#', ...)+2](eventHandlers, self, event, ...)
	end
end

function lib.RegisterEvent(self, event, handler)
	if self == lib then
		self = GetInternalFrame()
	end
	assert(type(event) == "string", "RegisterEvent(event, handler): event must be a string")
	handler = handler or event
	if type(handler) == "string" then
		handler = self[handler]
	end
	assert(type(handler) == "function", "RegisterEvent(event, handler): handler must resolve to a function or a method name")	
	local eventHandlers = handlers[self][event]
	if not eventHandlers then
		self:__RegisterEvent(event)	
		handlers[self][event] = { handler }
	else
		for i, func in pairs(eventHandlers) do
			if func == handler then return end
		end
		tinsert(eventHandlers, handler)
	end
end

function lib.UnregisterEvent(self, event, handler)
	if self == lib then
		self = GetInternalFrame(true)
		if not self then return end
	end
	assert(type(event) == "string", "UnregisterEvent(event, handler): event must be a string")
	handler = handler or event
	if type(handler) == "string" then
		handler = self[handler]
	end	
	assert(type(handler) == "function", "UnregisterEvent(event, handler): handler must resolve to a function or a method name")
	local eventHandlers = handlers[self][event]
	if eventHandlers then
		for i, func in pairs(eventHandlers) do
			if func == handler then
				tremove(eventHandlers, i)
				break
			end
		end
		if #eventHandlers == 0 then
			self:__UnregisterEvent(event)
			handlers[self][event] = nil			
		end
	end
end

-- Message channels

lib.channels = lib.channels or {}
local channels = lib.channels

function lib.TriggerMessage(self, ...)
	if self == lib then
		self = GetInternalFrame(true)
		if not self then return end
	end
	if channels[self] then
		for listener in pairs(channels[self]) do
			listener:TriggerEvent(...)
		end
	end
end

function lib.ClearMessageChannel(self)
	if self == lib then
		self = GetInternalFrame(true)
		if not self then return end
	end
	local oldChannel = channels[self]
	if oldChannel then
		oldChannel[self] = nil
		channels[self] = nil
	end
end

function lib.SetMessageChannel(self, channelId)
	if self == lib then
		self = GetInternalFrame()
	end
	channelId = tostring(channelId)
	local newChannel = channels[channelId]
	if not newChannel then
		newChannel = {}
		channels[channelId] = newChannel
	end
	local oldChannel = channels[self]
	if oldChannel ~= newChannel then
		if oldChannel then
			oldChannel[self] = nil
		end
		channels[self] = newChannel
		newChannel[self] = true
	end
end

-- Embedding and updating

local exports = {
	"TriggerEvent", "RegisterEvent", "UnregisterEvent",
	"SetMessageChannel", "ClearMessageChannel", "TriggerMessage",
}

lib.embeds = lib.embeds or {}
local embeds = lib.embeds

function lib.Embed(target)
	embeds[target] = true
	handlers[target] = handlers[target] or {}
	target.__RegisterEvent = target.__RegisterEvent or target.RegisterEvent
	target.__UnregisterEvent = target.__UnregisterEvent or target.UnregisterEvent
	target:SetScript('OnEvent', lib.TriggerEvent)
	for _,name in pairs(exports) do
		target[name] = lib[name]
	end
end

for target in pairs(embeds) do
	lib.Embed(target)
end

