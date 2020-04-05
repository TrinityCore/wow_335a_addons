
local L = LibStub("AceLocale-3.0"):GetLocale("GcdHackTracker", true)

-- Slash commands
SLASH_GCDHACKTRACKER1 = "/ght"
SLASH_GCDHACKTRACKER2 = "/GHT"
SlashCmdList["GCDHACKTRACKER"] = function(msg)
	msg = string.lower(msg or "")
	
	--print("> /ght " .. msg)
	
	if (msg == "track") then
		
		GcdHackTrackerData.enabled = not GcdHackTrackerData.enabled
		
		if (GcdHackTrackerData.enabled) then
			print("|cff5eafe8<GHT>|r " .. L.TRACKING_START)
		else
			print("|cff5eafe8<GHT>|r " .. L.TRACKING_STOP)
		end
		
		_G["GcdHackTracker"]:registerLogEvents(GcdHackTrackerData.enabled)
		
	elseif (msg == "shout") then
		
		if (GcdHackTrackerData.shout > 0) then
			GcdHackTrackerData.shout = 0
		else
			GcdHackTrackerData.shout = 1
		end
		
		if (GcdHackTrackerData.shout ~= 0) then
			print("|cff5eafe8<GHT>|r " .. L.SHOUTING_START)
		else
			print("|cff5eafe8<GHT>|r " .. L.SHOUTING_STOP)
		end
		
	elseif (msg == "show") then
		
		_G["GcdHackTracker"]:showGui()
		
	elseif (string.find(msg, 'gcd%s%d*')) then
		
		local gcd = string.sub(msg, 5)
		if (tonumber(gcd)) then
			print("|cff5eafe8<GHT>|r " .. L.SETTING_GCD .. " |cff00e300" .. gcd .. "|r")
			GCD_ALERT_VALUE = tonumber(gcd)
		else
			print("|cff5eafe8<GHT>|r " .. L.SETTING_INVALID)
		end
		
	elseif (msg == "version") then
		
		print("|cff5eafe8<GHT>|r " .. L.RUN_VERSION .. _G["GcdHackTracker"]:getVersion())
		
	elseif (msg == "debug") then
		
		GcdHackTrackerData.debug = not GcdHackTrackerData.debug
		
		if (GcdHackTrackerData.debug) then
			print("|cff5eafe8<GHT>|r " .. L.DEBUG_START)
		else
			print("|cff5eafe8<GHT>|r " .. L.DEBUG_STOP)
		end
		
	else
		
		-- display help
		print("|cff5eafe8<GHT>|r /ght track - " .. L.HELP_TRACK)
		print("|cff5eafe8<GHT>|r /ght show - " .. L.HELP_SHOW)
		print("|cff5eafe8<GHT>|r /ght gcd [number] - " .. L.HELP_GCD)
		print("|cff5eafe8<GHT>|r /ght version - " .. L.HELP_VERSION)
		--print("|cff5eafe8<GHT>|r /ght shout - " .. L.HELP_SHOUT)
		--print("|cff5eafe8<GHT>|r /ght debug - " .. L.HELP_DEBUG)
		
	end
end