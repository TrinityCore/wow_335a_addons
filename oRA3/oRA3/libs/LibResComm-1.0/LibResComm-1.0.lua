--[[
Name: LibResComm-1.0
Revision: $Revision: 48 $
Author(s): DathRarhek (Polleke) (polleke@gmail.com)
Documentation: http://www.wowace.com/index.php/LibResComm-1.0
SVN:  svn://svn.wowace.com/wow/librescomm-1-0/mainline/trunk
Description: Keeps track of resurrection spells cast in the raid group
Dependencies: LibStub, CallbackHandler-1.0
]]

local MAJOR_VERSION = "LibResComm-1.0"
local MINOR_VERSION = 90000 + tonumber(("$Revision: 48 $"):match("%d+"))

local lib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

-- Older version loaded. Clean up
if lib.disable then
	lib.disable()
end

--------------------------------------------------------------------------------
-- Localization
--

local corpseOf = "^Corpse of (.+)$"
local l = GetLocale()
if l == "frFR" then
	corpseOf = "^Cadavre d[e'] ?(.+)$"
elseif l == "deDE" then
	corpseOf = "^Leichnam von (.+)$"
elseif l == "koKR" then
	corpseOf = "(.+)의 시체$"
elseif l == "zhCN" then
	corpseOf = "^(.+)的尸体"
elseif l == "zhTW" then
	corpseOf = "^(.+)的屍體"
elseif l == "ruRU" then
	corpseOf = "^Труп (.+)$"
end

--------------------------------------------------------------------------------
-- Event frame
--

lib.eventFrame = lib.eventFrame or CreateFrame("Frame")
lib.eventFrame:SetScript("OnEvent", function(this, event, ...)
	this[event](this, ...)
end)
lib.eventFrame:UnregisterAllEvents()

--------------------------------------------------------------------------------
-- Embed CallbackHandler-1.0
--

if not lib.Callbacks then
	lib.Callbacks = LibStub("CallbackHandler-1.0"):New(lib)
end

--------------------------------------------------------------------------------
-- Locals
--

local playerName = UnitName("player")
local _, playerClass = UnitClass("player")
local isResser = (playerClass == "PRIEST") or (playerClass == "SHAMAN") or (playerClass == "PALADIN") or (playerClass == "DRUID")

-- Last target name from UNIT_SPELLCAST_SENT
local sentTargetName = nil

-- Mouse down target
local mouseDownTarget = nil
local worldFrameHook = nil

-- Battleground/Arena/Group Indicators
local inBattlegroundOrArena = nil

-- For tracking STOP messages
local isCasting = nil

-- So bug is only reported once
local reportBugOnce = false

-- Tracking resses
local activeRes = {}

local resSpells = {
	SHAMAN = (GetSpellInfo(20777)),
	PRIEST = (GetSpellInfo(25435)),
	PALADIN = (GetSpellInfo(20773)),
	DRUID = (GetSpellInfo(50764))
}
local combatresSpells = {
	DRUID = (GetSpellInfo(20484))
}

local resSpell = resSpells[playerClass]
local combatresSpell = combatresSpells[playerClass]

--------------------------------------------------------------------------------
-- Utilities
--

local function commSend(contents, distribution, target)
	if not (oRA and oRA:HasModule("ParticipantPassive") and oRA:IsModuleActive("ParticipantPassive") or CT_RA_Stats) then
		SendAddonMessage("CTRA", contents, distribution or (inBattlegroundOrArena and "BATTLEGROUND" or "RAID"), target)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function lib.eventFrame:UNIT_SPELLCAST_SENT(unit, _, _, targetName)
	if unit ~= "player" then return end
	sentTargetName = targetName
end

function lib.eventFrame:UNIT_SPELLCAST_START(unit, spellName)
	if unit ~= "player" then return end
	if spellName ~= resSpell and spellName ~= combatresSpell then return end

	isCasting = true

	local target = sentTargetName
	if not sentTargetName or sentTargetName == UNKNOWN then
		target = mouseDownTarget
	end

	if not target then
		if not reportBugOnce then
			print("Possible bug in LibResComm-1.0. Please file a ticket at http://www.wowace.com/addons/librescomm-1-0/tickets/")
			reportBugOnce = true
		end
		target = "Target Unknown"
	end		
	
	local endTime = select(6, UnitCastingInfo(unit)) or (GetTime() + 10) * 1000
	endTime = endTime / 1000

	activeRes[playerName] = target

	lib.Callbacks:Fire("ResComm_ResStart", playerName, endTime, target)
	commSend(string.format("RES %s", target))
end

function lib.eventFrame:CHAT_MSG_ADDON(prefix, msg, distribution, sender)
	if prefix ~= "CTRA" then return end
	if sender == playerName then return end

	local target

	for cmd, targetName in msg:gmatch("(%a+)%s?([^#]*)") do
		-- A lot of garbage can come in, make absolutely sure we have a decent message
		if cmd == "RES" and targetName ~= "" and targetName ~= UNKNOWN then

			local endTime = select(6, UnitCastingInfo(sender)) or (GetTime() + 10)*1000

			if endTime and targetName then
				endTime = endTime / 1000
				activeRes[sender] = targetName
				lib.Callbacks:Fire("ResComm_ResStart", sender, endTime, targetName)
			end
		elseif cmd == "RESNO" then
			if activeRes[sender] then
				target = activeRes[sender]
				activeRes[sender] = nil
			end
			lib.Callbacks:Fire("ResComm_ResEnd", sender, target)
		elseif cmd == "RESSED" then
			if activeRes[sender] then
				target = activeRes[sender]
				activeRes[sender] = nil
			end
			lib.Callbacks:Fire("ResComm_Ressed", sender)
		elseif cmd == "CANRES" then
			lib.Callbacks:Fire("ResComm_CanRes", sender)
		elseif cmd == "NORESSED" then
			lib.Callbacks:Fire("ResComm_ResExpired",sender)
		end
	end
end

function lib.eventFrame:UNIT_SPELLCAST_SUCCEEDED(unit, spellName)
	if unit ~= "player" or not isCasting then return end

	local target = activeRes[playerName]
	if activeRes[playerName] then
		activeRes[playerName] = nil
	end

	lib.Callbacks:Fire("ResComm_ResEnd", playerName, target)
	commSend("RESNO")
	isCasting = false
end

function lib.eventFrame:UNIT_SPELLCAST_STOP(unit, spellName)
	if unit ~= "player" or not isCasting then return end
	
	local target = activeRes[playerName]
	if activeRes[playerName] then
		activeRes[playerName] = nil
	end

	lib.Callbacks:Fire("ResComm_ResEnd", playerName, target)
	commSend("RESNO")
	isCasting = false
end

function lib.eventFrame:PLAYER_ENTERING_WORLD()
	local it = select(2, IsInInstance())
	inBattlegroundOrArena = (it == "pvp") or (it == "arena")
end

--------------------------------------------------------------------------------
-- Public Functions

--[[ IsUnitBeingRessed(unit)

Description: Checks if a unit is being ressurected at that moment.

Input: Name of a friendly player

Output: Boolean. True when unit is being ressed. False when not.
]]--

function lib:IsUnitBeingRessed(unit)
	for resser, ressed in pairs(activeRes) do
		if unit == ressed then
			return true, resser
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Hooks
--

-- Credits to Ora2
function lib:worldFrameOnMouseDown()
	if GameTooltipTextLeft1:IsVisible() then
		local target = select(3, GameTooltipTextLeft1:GetText():find(corpseOf))
		if target then	
			mouseDownTarget = target
		end
	end
end

function lib:popupFuncRessed()
	lib.Callbacks:Fire("ResComm_Ressed", playerName)
	commSend("RESSED")
end

function lib:popupFuncCanRes()
	if not HasSoulstone() then return end

	lib.Callbacks:Fire("ResComm_CanRes", playerName)
	commSend("CANRES")
end

function lib:popupFuncExpired()
	lib.Callbacks:Fire("ResComm_ResExpired", playerName)
	commSend("NORESSED")
end

function lib:noop()
end
--------------------------------------------------------------------------------
-- Register events and hooks
--

function lib:start()
	lib.eventFrame:RegisterEvent("CHAT_MSG_ADDON")

	if isResser then
		lib.eventFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
		lib.eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
		lib.eventFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
		lib.eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	end

	lib.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

	worldFrameHook = WorldFrame:GetScript("OnMouseDown")
	if not worldFrameHook then
		worldFrameHook = lib.noop;
	end
	
	WorldFrame:SetScript("OnMouseDown", function(...)
		lib:worldFrameOnMouseDown()
		worldFrameHook(...)
	end)

	local res = StaticPopupDialogs["RESURRECT"].OnShow
	StaticPopupDialogs["RESURRECT"].OnShow = function(...)
		lib:popupFuncRessed()
		res(...)
	end

	local resNoSick = StaticPopupDialogs["RESURRECT_NO_SICKNESS"].OnShow
	StaticPopupDialogs["RESURRECT_NO_SICKNESS"].OnShow = function(...)
		lib:popupFuncRessed()
		resNoSick(...)
	end

	local resNoTimer = StaticPopupDialogs["RESURRECT_NO_TIMER"].OnShow
	StaticPopupDialogs["RESURRECT_NO_TIMER"].OnShow =  function(...)
		lib:popupFuncRessed()
		resNoTimer(...)
	end

	local death = StaticPopupDialogs["DEATH"].OnShow
	StaticPopupDialogs["DEATH"].OnShow =  function(...)
		lib:popupFuncCanRes()
		death(...)
	end
	
	if not StaticPopupDialogs["RESURRECT"].OnHide then
		StaticPopupDialogs["RESURRECT"].OnHide = function() lib:popupFuncExpired() end
	else 
		local resurrect = StaticPopupDialogs["RESURRECT"].OnHide
		StaticPopupDialogs["RESURRECT"].OnHide = function(...) 
			lib:popupFuncExpired()
			resurrect(...)
		end	
	end
	
	if not StaticPopupDialogs["RESURRECT_NO_SICKNESS"].OnHide then
		StaticPopupDialogs["RESURRECT_NO_SICKNESS"].OnHide = function() lib:popupFuncExpired() end
	else
		local resNoSick = StaticPopupDialogs["RESURRECT_NO_SICKNESS"].OnHide
		StaticPopupDialogs["RESURRECT_NO_SICKNESS"].OnHide = function(...) 
			lib:popupFuncExpired()
			resNoSick(...)
		end	
	end
	
	if not StaticPopupDialogs["RESURRECT_NO_TIMER"].OnHide then
		StaticPopupDialogs["RESURRECT_NO_TIMER"].OnHide = function() 
			if not StaticPopup_FindVisible("DEATH") then lib:popupFuncExpired() end
		end
	else
		local resNoTimer = StaticPopupDialogs["RESURRECT_NO_TIMER"].OnHide
		StaticPopupDialogs["RESURRECT_NO_TIMER"].OnHide = function(...) 
			if not StaticPopup_FindVisible("DEATH") then lib:popupFuncExpired() end
			resNoTimer(...)
		end	
	end
	
end

--------------------------------------------------------------------------------
-- Start library
--

lib.disable = function()
	lib.worldFrameOnMouseDown = lib.noop
	lib.popupFuncRessed = lib.noop
	lib.popupFuncCanRes = lib.noop
	lib.popupFuncExpired = lib.noop
	lib.eventFrame:UnregisterAllEvents()
end
lib:start()
