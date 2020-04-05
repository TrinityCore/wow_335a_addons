--[[
	Auctioneer - Scan Finish module
	Version: 5.7.4568 (KillerKoala)
	Revision: $Id: ScanFinish.lua 4514 2009-11-01 20:20:21Z Nechckn $
	URL: http://auctioneeraddon.com/

	This is an Auctioneer module that adds a few event functionalities
	to Auctioneer when a successful scan is completed.

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]
if not AucAdvanced then return end

local libType, libName = "Util", "ScanFinish"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local print,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()

local blnDebug = false
local blnLibEmbedded = nil

local blnScanStarted = false
local blnScanStatsReceived = false
local blnScanLastPage = false
local intScanMinThreshold = 300  --Safeguard to prevent Auditor Refresh button scans from executing our finish events. Use 300 or more to be safe
local blnScanMinThresholdMet = false
local strPrevSound = "AuctioneerClassic"

function lib.Processor(callbackType, ...)

	if (callbackType == "scanprogress") then
		if blnDebug then
			print(".")
			print("  Debug:CallbackType:", callbackType)
		end
		if not get("util.scanfinish.activated") then
			return
		end
		private.ScanProgressReceiver(...)
	elseif (callbackType == "scanstats") then
		if blnDebug then
			print(".")
			print("  Debug:CallbackType:", callbackType)
			print("  Debug:ScanStarted="..tostring(blnScanStarted))
			print("  Debug:ScanLastPage="..tostring(blnScanLastPage))
			print("  Debug:ScanMinThresholdMet="..tostring(blnScanMinThresholdMet))
			print("  Debug:ScanStatsReceived="..tostring(blnScanStatsReceived))
		end
		if not get("util.scanfinish.activated") then
			return
		end
		local scanstats = ...
		blnScanMinThresholdMet = blnScanMinThresholdMet and not scanstats.wasIncomplete -- if scan was incomplete then treat threshold as not met
		if blnDebug then
			print("  Debug:Updating ScanMinThresholdMet="..tostring(blnScanMinThresholdMet))
			print("  Debug:Updating ScanStatsReceived=true")
		end
		blnScanStatsReceived = true
	elseif (callbackType == "config") then
		if blnDebug then
			print(".")
			print("  Debug:CallbackType:", callbackType)
		end
		private.SetupConfigGui(...)
	elseif (callbackType == "configchanged") then
		if blnDebug then
			print(".")
			print("  Debug:CallbackType:", callbackType)
		end
		private.ConfigChanged(...)
	end
end

function lib.OnLoad()
	default("util.scanfinish.activated", true)
	default("util.scanfinish.shutdown", false)
	default("util.scanfinish.logout", false)
	default("util.scanfinish.message", "So many auctions... so little time")
	default("util.scanfinish.messagechannel", "none")
	default("util.scanfinish.emote", "none")
	default("util.scanfinish.debug", false)
	if get("util.scanfinish.debug") then blnDebug = true end
	default("util.scanfinish.soundpath", "none")
	strPrevSound = get("util.scanfinish.soundpath")
end

function private.ScanProgressReceiver(state, totalAuctions, scannedAuctions, elapsedTime, page, maxPages, queryName, scanCount)
	if blnDebug then print("  Debug:Process State=", state) end

	if blnDebug then
		print("  Debug:ScanStarted="..tostring(blnScanStarted))
		print("  Debug:ScanLastPage="..tostring(blnScanLastPage))
		print("  Debug:ScanStatsReceived="..tostring(blnScanStatsReceived))
		print("  Debug:ScanMinThresholdMet="..tostring(blnScanMinThresholdMet))
		print("  Debug:API.IsBlocked="..tostring(AucAdvanced.API.IsBlocked()))
		print("  Debug:API.IsScanning="..tostring(AucAdvanced.Scan.IsScanning()))
		if scannedAuctions then print("  Debug:ScannedAuctions="..tostring(scannedAuctions)) end
		if totalAuctions then print("  Debug:TotalAuctions="..tostring(totalAuctions)) end
		if maxPages then print("  Debug:maxPages="..tostring(maxPages)) end
	end

	--Change the state if we have not scanned any auctions yet.
	--This is done so that we don't start the timer too soon and thus get skewed numbers
	if (state == nil and (
		not scannedAuctions or
		scannedAuctions == 0 or
		not AucAdvanced.API.IsBlocked() or
		BrowseButton1:IsVisible()
	)) then
		if blnDebug then
			print("  Debug:ScanFinish Switching State=true")
			print("  Debug:Updating ScanStarted=true")
			print("  Debug:Updating ScanStatsReceived=false")
		end
		blnScanStarted = true
		blnScanLastPage = false
		blnScanStatsReceived = false
		state = true
	end

	--if all of the following conditions are met, we should have had a successfully completed full scan
	--1. Has the Processor sent a state of false
	--2. Did we find a successful scan start
	--3. Did we find a minimum amount of scan items
	--4. Did we see the last page of the scan
	--5. Did we receive the stats
	--6. There are no pending scans
	if (state == false
		and blnScanStarted
		and blnScanMinThresholdMet
		and blnScanLastPage
		and blnScanStatsReceived
		and scanCount == 0
	) then
		blnScanStarted = false
		blnScanMinThresholdMet = false
		blnScanLastPage = false
		blnScanStatsReceived = false
		private.PerformFinishEvents()
	end

	--detect if we've reached the last page. Print progress on the way if we're in debug
	--don't detect do this before the completed detection to prevent premature execution
	if totalAuctions and scannedAuctions then

		-- check for GetAll scan
		if maxPages == 1 and totalAuctions > 50 then
			if blnDebug then print("  Debug:GetAll scan detected") end
			if blnDebug then print("  Debug:ScanFinish Switching LastPageReached=true") end
			blnScanLastPage = true -- GetAll only has one page, and this is it
			if totalAuctions > intScanMinThreshold then
				-- scannedAucions will always be 0 at this point in a GetAll, so test totalAuctions instead
				--Send a friendly reminder that we may be shutting down or logging off now
				private.AlertShutdownOrLogOff()
				if blnDebug then print("  Debug:ScanFinish Switching ScanMinThresholdMet=true") end
				blnScanMinThresholdMet = true
			end
		else

			--Check to see if we've scanned to our minimum threshold to enable shutdown or logout
			if scannedAuctions > intScanMinThreshold and blnScanMinThresholdMet == false then
				if blnDebug then print("  Debug:ScanFinish Switching ScanMinThresholdMet=true") end
				--Send a friendly reminder that we may be shutting down or logging off now
				private.AlertShutdownOrLogOff()
				blnScanMinThresholdMet = true
			end

			--Send a warning about the impending shutdown/logout as we approach the end of our auction scan
			if blnScanStarted and blnScanMinThresholdMet and (totalAuctions - scannedAuctions < 150) then
				private.AlertShutdownOrLogOff()
			end
			if totalAuctions - scannedAuctions < 50 then
				if blnDebug then
					print("  Debug:ScanFinish Switching LastPageReached=true")
				end

				blnScanLastPage = true
			end
		end
	end
end

function private.PerformFinishEvents()
	--Clean up/reset local variables
	blnScanStarted = false
	blnScanStatsReceived = false
	blnScanLastPage = false
	blnScanMinThresholdMet = false

	if blnDebug then
		print("  Debug:Message: "..get("util.scanfinish.message"))
		print("  Debug:MessageChannel: "..get("util.scanfinish.messagechannel"))
		print("  Debug:Emote: "..get("util.scanfinish.emote"))
		print("  Debug:LogOut: "..tostring(get("util.scanfinish.logout")))
		print("  Debug:ShutDown: "..tostring(get("util.scanfinish.shutdown")))
	end

	--Sound
	private.PlayCompleteSound()

	--Message
	if get("util.scanfinish.messagechannel") == "none" then
		--don't do anything
	elseif get("util.scanfinish.messagechannel") == "GENERAL" then
		SendChatMessage(get("util.scanfinish.message"),"CHANNEL",nil,GetChannelName("General"))
	else
		SendChatMessage(get("util.scanfinish.message"),get("util.scanfinish.messagechannel"))
	end


	--Emote
	if not (get("util.scanfinish.emote") == "none") then
		DoEmote(get("util.scanfinish.emote"))
	end

	--Shutdown or Logoff
	if (get("util.scanfinish.shutdown")) then
		print("AucAdvanced: {{"..libName.."}} Shutting Down!!")
		if not blnDebug then
			Quit()
		end
	elseif (get("util.scanfinish.logout")) then
		print("AucAdvanced: {{"..libName.."}} Logging Out!")
		if not blnDebug then
			Logout()
		end
	end
end

function private.AlertShutdownOrLogOff()
	if (get("util.scanfinish.shutdown")) then
		PlaySound("TellMessage")
		print("AucAdvanced: {{"..libName.."}} |cffff3300Reminder|r: Shutdown is enabled. World of Warcraft will be shut down once the current scan successfully completes.")
	elseif (get("util.scanfinish.logout")) then
		PlaySound("TellMessage")
		print("AucAdvanced: {{"..libName.."}} |cffff3300Reminder|r: LogOut is enabled. This character will be logged off once the current scan successfully completes.")
	end
end

function private.PlayCompleteSound()
	strConfiguredSoundPath = get("util.scanfinish.soundpath")
	if strConfiguredSoundPath and not (strConfiguredSoundPath == "none") then
		if blnDebug then
			print("AucAdvanced: {{"..libName.."}} You are listening to "..strConfiguredSoundPath)
		end
		if strConfiguredSoundPath == "AuctioneerClassic" then
			if blnLibEmbedded == nil then
			  	blnLibEmbedded = IsLibEmbedded()
			end
			strConfiguredSoundPath = "Interface\\AddOns\\Auc-Util-ScanFinish\\ScanComplete.mp3"
			if blnLibEmbedded then
				strConfiguredSoundPath = "Interface\\AddOns\\Auc-Advanced\\Modules\\Auc-Util-ScanFinish\\ScanComplete.mp3"
			end

			--Known PlaySoundFile bug seems to require some event preceeding it to get it to work reliably
			--Can get this working as a print to screen or an internal sound. Other developers
			--suggested this workaround.
			--http://forums.worldofwarcraft.com/thread.html?topicId=1777875494&sid=1&pageNo=4
			--PlaySound("GAMEHIGHLIGHTFRIENDLYUNIT") -- this bug appears to be fixed
			PlaySoundFile(strConfiguredSoundPath)

		else
			PlaySound(strConfiguredSoundPath)
		end
	end
end

--Config UI functions
function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName, libType.." Modules")

	gui:AddHelp(id, "what is scanfinish",
		"What is ScanFinish?",
		"ScanFinish is an Auctioneer module that will execute one or more useful events once Auctioneer has completed a scan successfully.\n\nScanFinish will only execute these events during full Auctioneer scans with a minimum threshold of "..intScanMinThreshold .." items, so there is no worry about logging off or spamming emotes during the incremental scans or SearchUI activities. Unfortunately, this also means the functionality will not be enabled in auction houses with under "..intScanMinThreshold.." items."
		)

	gui:AddControl(id, "Header",	 0,	libName.." options")
	gui:AddControl(id, "Checkbox",   0, 1, "util.scanfinish.activated", "Allow the execution of the events below once a successful scan completes")
	gui:AddTip(id, "Selecting this option will enable Auctioneer to perform the events below once Auctioneer has completed a scan successfully. \n\nUncheck this to disable all events.")

	gui:AddControl(id, "Subhead",	0,	"Sound & Emote")
	gui:AddControl(id, "Selectbox",  0, 3, {
		{"none", "None (do not play a sound)"},
		{"AuctioneerClassic", "Auctioneer Classic"},
		{"QUESTCOMPLETED","Quest Completed"},
		{"LEVELUP","Level Up"},
		{"AuctionWindowOpen","Auction House Open"},
		{"AuctionWindowClose","Auction House Close"},
		{"ReadyCheck","Raid Ready Check"},
		{"RaidWarning","Raid Warning"},
		{"LOOTWINDOWCOINSOUND","Coin"},
	}, "util.scanfinish.soundpath", "Pick the sound to play")
	gui:AddTip(id, "Selecting one of these sounds will cause Auctioneer to play that sound once Auctioneer has completed a scan successfully. \n\nBy selecting None, no sound will be played.")

	gui:AddControl(id, "Selectbox",  0, 3, {
		{"none"	  , "None (do not emote)"},
		{"APOLOGIZE" , "Apologize"},
		{"APPLAUD"   , "Applaud"},
		{"BRB"	   , "BRB"},
		{"CACKLE"	, "Cackle"},
		{"CHICKEN"   , "Chicken"},
		{"DANCE"	 , "Dance"},
		{"FAREWELL"  , "Farewell"},
		{"FLIRT"	 , "Flirt"},
		{"GLOAT"	 , "Gloat"},
		{"JOKE"	  , "Silly"},
		{"SLEEP"	 , "Sleep"},
		{"VICTORY"   , "Victory"},
		{"YAWN"	  , "Yawn"},

	}, "util.scanfinish.emote", "Pick the Emote to perform")
	gui:AddTip(id, "Selecting one of these emotes will cause your character to perform the selected emote once Auctioneer has completed a scan successfully.\n\nBy selecting None, no emote will be performed.")

	gui:AddControl(id, "Subhead",	0,	"Message")
	gui:AddControl(id, "Text",	   0, 1, "util.scanfinish.message", "Message text:")
	gui:AddTip(id, "Enter the message text of what you wish your character to say as well as choosing a channel below. \n\nThis will not execute slash commands.")
	gui:AddControl(id, "Selectbox",  0, 3, {
		{"none", "None (do not send message)"},
		{"SAY", "Say (/s)"},
		{"PARTY","Party (/p)"},
		{"RAID","Raid (/r)"},
		{"GUILD","Guild (/g)"},
		{"YELL","Yell (/y)"},
		{"EMOTE","Emote (/em)"},
		{"GENERAL","General"},
	}, "util.scanfinish.messagechannel", "Pick the channel to send your message to")
	gui:AddTip(id, "Selecting one of these channels will cause your character to say the message text into the selected channel once Auctioneer has completed a scan successfully. \n\nBy choosing Emote, your character will use the text above as a custom emote. \n\nBy selecting None, no message will be sent.")


	gui:AddControl(id, "Subhead",	0,	"Shutdown or Log Out")
	gui:AddControl(id, "Checkbox",   0, 1, "util.scanfinish.shutdown", "Shutdown World of Warcraft")
	gui:AddTip(id, "Selecting this option will cause Auctioneer to shut down World of Warcraft completely once Auctioneer has completed a scan successfully.")
	gui:AddControl(id, "Checkbox",   0, 1, "util.scanfinish.logout", "Log Out the current character")
	gui:AddTip(id, "Selecting this option will cause Auctioneer to log out to the character select screen once Auctioneer has completed a scan successfully. \n\nIf Shutdown is enabled, selecting this will have no effect")


	--Debug switch via gui. Currently not exposed to the end user
	--gui:AddControl(id, "Subhead",	0,	"")
	--gui:AddControl(id, "Checkbox",   0, 1, "util.scanfinish.debug", "Show Debug Information for this session")


end

function IsLibEmbedded()
	blnResult = false
	for pos, module in ipairs(AucAdvanced.EmbeddedModules) do
		--print("  Debug:Comparing Auc-Util-"..libName.." with "..module)
		if "Auc-Util-"..libName == module then
			if blnDebug then
				print("  Debug:Auc-Util-"..libName.." is an embedded module")
			end
			blnResult = true
			break
		end
	end
	return blnResult
end

function private.ConfigChanged()
	--Debug switch via gui. Currently not exposed to the end user
	--blnDebug = get("util.scanfinish.debug")
	if blnDebug then
		print("  Debug:Configuration Changed")
	end

	if not (strPrevSound == get("util.scanfinish.soundpath")) then
		private.PlayCompleteSound()
		strPrevSound = get("util.scanfinish.soundpath")
	end

	if (not get("util.scanfinish.activated")) then
		if blnDebug then print("  Debug:Updating ScanFinish:Deactivated") end
		private.ScanProgressReceiver(false)
	elseif (AucAdvanced.Scan.IsScanning()) then
		if blnDebug then print("  Debug:Updating ScanFinish with Scan in progress") end
		private.ScanProgressReceiver(true)
	end
end

AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/5.7/Auc-Util-ScanFinish/ScanFinish.lua $", "$Rev: 4514 $")
