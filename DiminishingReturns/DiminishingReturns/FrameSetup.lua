local addon = DiminishingReturns
if not addon then return end
local L = addon.L

local supportState = {}

local frames = {}
local frameCallbacks = {}
local addonCallbacks = {}

local safecall
do
	local function pcall_result(success, ...)
		if not success then
			addon:Debug('Callback error:', ...)
			geterrorhandler()(...)
		end
		return ...
	end

	function safecall(func, ...)
		return pcall_result(pcall(func, ...))
	end
end

function addon.CheckFrame(frame)
	local name = frame and frame:GetName()
	local callback = name and frameCallbacks[name]
	if callback then
		addon:Debug('Calling callback for frame', name)
		frameCallbacks[name] = nil
		safecall(callback, frame)
		return true
	end
end

function addon:RegisterFrame(name, callback)
	frameCallbacks[name] = callback
	if not addon.CheckFrame(_G[name]) then
		addon:Debug('Registered callback for frame', name)
	end
end

hooksecurefunc('RegisterUnitWatch', addon.CheckFrame)

function addon:RegisterFrameConfig(label, getDatabaseCallback)
	if not addon.pendingFrameConfig then
		addon.pendingFrameConfig = {}
	end
	addon.pendingFrameConfig[label] = getDatabaseCallback
end

local addonSupportInitialized

local function IsLoaded(name)
	if name == "FrameXML" then
		return IsLoggedIn()
	else
		return IsAddOnLoaded(name)
	end 
end

local function CanBeLoaded(name)
	if name == "FrameXML" then
		return true
	else
		return select(5, GetAddOnInfo(name))
	end 
end

local function CheckAddonSupport()
	if not addonSupportInitialized then return end
	for name, callback in pairs(addonCallbacks) do
		if IsLoaded(name) then
			addon:Debug('Calling addon support for', name)
			addonCallbacks[name] = nil
			local success, reason = pcall(callback)
			if success then
				supportState[name] = '|cff00ff00'..L["active"]..'|r'
			else
				supportState[name] = '|cffff0000'..L["error: "]..reason..'|r'
			end
		end
	end
end

function addon:RegisterAddonSupport(name, callback)
	if not IsLoaded(name) then
		local loadable, reason = CanBeLoaded(name)
		if not loadable then
			self:Debug('Not registering addon support for', name, ':', _G["ADDON_"..reason], '['..reason..']')
			if reason == 'MISSING' then
				supportState[name] = '|cffbbbbbbnot installed|r'
			else
				supportState[name] = '|cffff0000cannot be loaded: '.._G["ADDON_"..reason]..'|r'
			end
			return
		end
	end
	supportState[name] = '|cff00ffff'..L["to be loaded"]..'|r'
	addonCallbacks[name] = callback
	CheckAddonSupport()
	if addonCallbacks[name] then
		self:Debug('Registered addon support for', name)
	end
end

function addon:LoadAddonSupport()
	addonSupportInitialized = true
	CheckAddonSupport()
	if addonCallbacks.framexml then
		addon:RegisterEvent('PLAYER_LOGIN', CheckAddonSupport)
	end
	addon:RegisterEvent('ADDON_LOADED', CheckAddonSupport)
end

SLASH_DRSTATUS1 = "/drstatus"
SLASH_DRSTATUS2 = "/drsupport"
SlashCmdList.DRSTATUS = function()
	print('DiminishingReturns addon support:')
	for name, state in pairs(supportState) do
		print('-', name, ':', state)
	end
end