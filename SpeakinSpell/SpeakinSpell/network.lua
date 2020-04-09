-- Author      : RisM
-- Create Date : 11/28/2009 11:13:26 PM


local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)
local LibSmartComm = LibStub:GetLibrary("LibSmartComm-1.0")
local DEFAULT_EVENTHOOKS = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell_DEFAULT_EVENTHOOKS",	false)

SpeakinSpell:PrintLoading("network.lua")


-------------------------------------------------------------------------------
-- INVISIBLE NETWORK COMMUNICATIONS BETWEEN INSTANCES OF SPEAKINSPLL
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- NETWORK CONFIG
-------------------------------------------------------------------------------

local NID = "SSN" -- 'prefix' in each call to SendAddonMessage


-------------------------------------------------------------------------------
-- INIT
-------------------------------------------------------------------------------
-- TODOFUTURE: add a global channel or friend list network of known SS users


function SpeakinSpell:Network_Init()
	if not SpeakinSpellSavedDataForAll.Networking.EnableNetwork then
		return
	end
	
	-- setup LibSmartComm
	local client_version = SpeakinSpell.CURRENT_VERSION
	if SpeakinSpell.DEVELOPER_MODE then
		-- Prefacing the version with "0." makes it look like everyone else has a greater version
		-- to suppress firing the OnNewerVersion callback,
		-- so that people in my guild aren't told that a new version of SS is available before it really is
		-- The string at the end explains it for the optional "Found a SpeakinSpell User" message
		-- The net result will be something like "0.3.3.5.10 (Unreleased Developer Version)"
		client_version = "0." .. SpeakinSpell.CURRENT_VERSION .. L[" (Unreleased Developer Version)"]
	end
	LibSmartComm:RegisterAddon(		NID, SpeakinSpell, client_version, SpeakinSpell.DATA_VERSION )
	LibSmartComm:RegisterCommands(	NID, SpeakinSpell.NETWORK_COMMANDS )
	LibSmartComm:RegisterCallback(	NID, "OnPacketQueued" )
	LibSmartComm:RegisterCallback(	NID, "OnCharsSent" )
	LibSmartComm:RegisterCallback(	NID, "OnSendComplete" )
	LibSmartComm:RegisterCallback(	NID, "OnSendQueueEmpty" )
	LibSmartComm:RegisterCallback(	NID, "OnStatsUpdated" )
	LibSmartComm:RegisterCallback(	NID, "OnNewerVersion" )
	LibSmartComm:RegisterCallback(	NID, "OnNewUserFound" )
	LibSmartComm:RegisterCallback(	NID, "OnNetworkError" )
	--LibSmartComm:RegisterCallback(NID, "OnVersionPing" ) --we received a stub packet without a packet.command - if it's a newer version, the framework will call OnNewerVersion before OnVersionPing
	
	-- auto-sync at startup
	if SpeakinSpellSavedDataForAll.Networking.AutoSyncOnLogin then
		self:Network_AutoSync()
	end
end


function SpeakinSpell:Network_Disable()
	LibSmartComm:Unregister( NID )
end


-------------------------------------------------------------------------------
-- STATUS REPORTS
-------------------------------------------------------------------------------


function SpeakinSpell:Network_PrintStatus( rxtx, msg, de )
	local funcname = "Network_PrintStatus"
	
	-- Built-in status messages
	-- msg can be nil because some messages are optional below ShowCommTraffic, i.e. ShowTransferProgress
	if msg then
		if SpeakinSpellSavedDataForAll.Networking.ShowCommTraffic then
			self:SayMultiLineWithSubs(msg, "COMM TRAFFIC "..rxtx, nil, false, de)
		else
			self:DebugMsg(funcname, msg)
		end
	end

	-- if the network status event has a name, then signal it as a speech event
	if de.name then
		de.type = "COMM"..rxtx
		de.msg = msg
		self:OnSpeechEvent( de )
	end
end


-------------------------------------------------------------------------------
-- START SYNC
-------------------------------------------------------------------------------


function SpeakinSpell:Network_SyncWithTarget(target)
	local de = {
		name = L["Auto-Sync With Player"],
		target = target,
	}
	self:Network_PrintStatus( "TX", L["Starting Sync with <target>"], de )
	
	local data = {
		Share	= SpeakinSpellSavedDataForAll.Networking.Share,
		Collect	= SpeakinSpellSavedDataForAll.Networking.Collect,
	}
	LibSmartComm:Send( NID, "SYNC?", data, "WHISPER", target)
end


function SpeakinSpell:Network_AutoSync() --TODOLATER: call if AutoSyncOnJoin and we join one of the channels
	local de = {
		name = L["General Auto-Sync"],
	}
	self:Network_PrintStatus( "TX", L["Performing General Auto-Sync"], de )

	local data = {
		Share	= SpeakinSpellSavedDataForAll.Networking.Share,
		Collect	= SpeakinSpellSavedDataForAll.Networking.Collect,
	}
	if not LibSmartComm:Broadcast( NID, "SYNC?", data) then
		local de = { name = L["General Auto-Sync Failed"] }
		self:Network_PrintStatus("TX", L["No channels are available. For global syncs, join a guild, party, raid, or battleground."], de)
	end

	-- automatic debug test suite if enabled
	if SpeakinSpell.DEBUG_NETWORK then
		LibSmartComm:Send( NID, "SYNC?",data,"GUILD")
		LibSmartComm:Send( NID, "SYNC?",data,"RAID")
		LibSmartComm:Send( NID, "SYNC?",data,"PARTY")
		LibSmartComm:Send( NID, "SYNC?",data,"BATTLEGROUND")
		LibSmartComm:Send( NID, "SYNC?",data,"WHISPER", "nobody")
		LibSmartComm:Send( NID, "SYNC?",data,"WHISPER", UnitName("player"))
	end
end


-------------------------------------------------------------------------------
-- COMMUNICATION PROTOCOL - COMMAND / RESPONSE HANDLERS
-------------------------------------------------------------------------------

-- route commands to functions
SpeakinSpell.NETWORK_COMMANDS = {

-------------------------------------------------------------------------------
["SYNC?"] = function( packet )
	local sentsomething = false
	
	if not packet.data then
		-- unexpected missing packet data, just reply with version
		-- No, LibSmartComm now always handshakes with a version response from the first packet received
		--LibSmartComm:SendReplyVersionOnly( packet )
		return
	end
	
	-- Ask for event tables, if I collect them, and the sender shares them
	if SpeakinSpellSavedDataForAll.Networking.Collect.ET and packet.data.Share.ET then
		LibSmartComm:SendReply( "ET?", nil, packet )
		sentsomething = true
	end
	
	-- If I share my ET and the sender wants it, send it now
	if SpeakinSpellSavedDataForAll.Networking.Share.ET and packet.data.Collect.ET then
		LibSmartComm:SendReply( "ET=", SpeakinSpell:Network_GetCompressedActiveEventTable(), packet )
		sentsomething = true
	end
	
	-- Ask for event tables, if I collect them, and the sender shares them
	if SpeakinSpellSavedDataForAll.Networking.Collect.RS and packet.data.Share.RS then
		LibSmartComm:SendReply( "RS?", nil, packet )
		sentsomething = true
	end
	
	-- If I share my RS and the sender wants it, send it now
	if SpeakinSpellSavedDataForAll.Networking.Share.RS and packet.data.Collect.RS then
		LibSmartComm:SendReply( "RS=", SpeakinSpellSavedDataForAll.RandomSubs, packet )
		sentsomething = true
	end
	
	-- Ask for NewEventsDetected, if I collect them, and the sender shares them
	-- If I share my NewEventsDetected and the sender wants it, send it now
	-- NOTE: if I'm sending my list and asking for a reply, I'll attach my list to the NEW? and get a shorter reply
	--		instead of asking for a separate NEW? and NEW= and getting back a mostly redundant list
	if SpeakinSpellSavedDataForAll.Networking.Collect.NEW and packet.data.Share.NEW then
		if SpeakinSpellSavedDataForAll.Networking.Share.NEW and packet.data.Collect.NEW then
			-- here's my list and I want a reply
			LibSmartComm:SendReply( "NEW?", SpeakinSpell:Network_GetCompressedNewEventsDetected(), packet )
		else
			-- I'd like a list from you, but I don't share mine
			LibSmartComm:SendReply( "NEW?", nil, packet )
		end
		sentsomething = true
	elseif SpeakinSpellSavedDataForAll.Networking.Share.NEW and packet.data.Collect.NEW then
		-- here's my list, and I don't want a reply
		LibSmartComm:SendReply( "NEW=", SpeakinSpell:Network_GetCompressedNewEventsDetected(), packet )
		sentsomething = true
	end
	
	-- if I haven't said anything else yet
	-- at least brag that I'm a newer version
	-- this is now done automatically by the framework in LibSmartComm as a one-time handshake
--	if (not sentsomething) and (SpeakinSpell.CURRENT_VERSION > packet.version.client) then
--		LibSmartComm:SendReplyVersionOnly( packet )
--	end
	
end,

-------------------------------------------------------------------------------
["ET?"] = function( packet )
	if SpeakinSpellSavedDataForAll.Networking.Share.ET then
		LibSmartComm:SendReply( "ET=", SpeakinSpell:Network_GetCompressedActiveEventTable(), packet )
	end
end,

-------------------------------------------------------------------------------
["ET="] = function( packet )
	SpeakinSpell:Network_OnEventTable( packet )
end,

-------------------------------------------------------------------------------
["RS?"] = function( packet )
	if SpeakinSpellSavedDataForAll.Networking.Share.RS then
		LibSmartComm:SendReply( "RS=", SpeakinSpellSavedDataForAll.RandomSubs, packet )
	end
end,

-------------------------------------------------------------------------------
["RS="] = function( packet )
	SpeakinSpell:Network_OnRandomSubs( packet )
end,

-------------------------------------------------------------------------------
["NEW?"] = function( packet )
	-- send the NewEventsDetected
	local replydata = SpeakinSpell:Network_GetCompressedNewEventsDetected( packet.data ) --OK for data to be nil here
	
	-- if a table of known events was provided, then don't send those to a client that already knows about them
	if not SpeakinSpell:IsTableEmpty(packet.data) then
		SpeakinSpell:DebugMsg("NEW?","included non-empty data")
		-- process the received data like it's a "NEW="
		SpeakinSpell:Network_OnNewEvents( packet )
	end
	
	-- if we don't share, then stop here
	if not SpeakinSpellSavedDataForAll.Networking.Share.NEW then
		SpeakinSpell:DebugMsg("NEW?","Networking.Share.NEW is disabled")
		return
	end
	
	-- if there are no new events, then don't bother to reply
	if SpeakinSpell:IsTableEmpty(replydata) then
		local de = {
			name = L["No New Events to Send to <target>"],
			target = packet.sender,
		}
		SpeakinSpell:Network_PrintStatus("TX", L["NEW? reply canceled - all event hooks are already known to <target>"], de)
		return
	end

	-- reply
	LibSmartComm:SendReply("NEW=", replydata, packet)
end,

-------------------------------------------------------------------------------
["NEW="] = function( packet )
	SpeakinSpell:Network_OnNewEvents( packet )
end,

-------------------------------------------------------------------------------

} --END NETWORK_COMMANDS
	

-------------------------------------------------------------------------------
-- LibSmartComm callback handlers
-------------------------------------------------------------------------------


-- OnCharsSent( _, packet, sent, textlen )
--		signals each chunk of progress on sending 'packet'
--		about 250 chars each
--		same as AceComm callbackFn
function SpeakinSpell:OnCharsSent(_, packet, sent, textlen)
	-- show progress
	local de = {
		name = L["Each Packet Sent"],
		target	= packet.target or packet.distribution,
		command = packet.command or GAME_VERSION_LABEL,
		distribution= packet.distribution,
		sent = sent,
		textlen = textlen,
		percent = string.format( "%2.1f", (100*sent/textlen) ),
	}
	local msg = L["<target> -> <command> <sent> / <textlen> - <percent>%"]
	if not SpeakinSpellSavedDataForAll.Networking.ShowTransferProgress then
		msg = nil
	end
	self:Network_PrintStatus( "TX", msg, de )
end


function SpeakinSpell:OnPacketQueued(_, packet, packetsize )
	local de = {
		name = L["Send Data"],
		target = packet.target or packet.distribution,--target name for whispers, or a channel name
		caster = UnitName("player"),
		command = packet.command or GAME_VERSION_LABEL,
		distribution = packet.distribution,
		size = packetsize,
	}
	self:Network_PrintStatus( "TX", L["Send to <target> <command> (<size> chars)"], de )
end


-- OnPacketReceive(_, packet)
--		a complete packet has been received
--		(called before routing to your registered command handler for the packet)
function SpeakinSpell:OnPacketReceive(_, packet, packetsize)
	-- show comm progress message
	local de = {
		name = L["Receive Data"],
		target = UnitName("player"),
		caster = packet.sender,
		sender = packet.sender,
		command = packet.command or GAME_VERSION_LABEL,
		distribution = packet.distribution, --will be whisper if whispered to you - no need to show player name
		size = packetsize,
	}
	self:Network_PrintStatus( "RX", L["Received from <sender> (<distribution>): <command> (<size> chars)"], de )
end


-- OnSendComplete( _, packet )
--		Send() finished sending the packet asynchronously
function SpeakinSpell:OnSendComplete(_, packet, packetsize)
	-- show transfer complete
	local de = {
		name = L["Transfer Complete"],
		target	= packet.target or packet.distribution,
		command = packet.command or GAME_VERSION_LABEL,
		distribution= packet.distribution,
		size = packetsize,
	}
	self:Network_PrintStatus( "TX", L["Send Complete: <command> -> <target> (<size> chars)"], de )
end


-- OnSendQueueEmpty( _ )
--		signals when the send queue is empty
function SpeakinSpell:OnSendQueueEmpty(_)
	local de = { name = L["Tx Queue is Empty"] }
	self:Network_PrintStatus( "TX", L["All sending is complete (for now)"], de )
end


-- OnStatsUpdated( _, stats )
--		your comm traffic stats have been updated (for a diagnostic UI)
--		stats == addon.stats (see RegisterAddon)
function SpeakinSpell:OnStatsUpdated(_, stats)
	-- update the stats diagnostics display
	self.RuntimeData.Networking.stats = stats
	if SpeakinSpellSavedDataForAll.Networking.ShowStats then
		self:RefreshFrame("Network")
	end
end


-- OnNewerVersion( _, version )
--		A newer version of your addon sent us a message
--		this will not be repeated more than once for a given version (number or string)
--		but another even higher version might be found later
function SpeakinSpell:OnNewerVersion(_, version)
	self.RuntimeData.Networking.NewestVersion = version
	self:Print(L["Newer version available: "]..tostring(version))
	self:Print( SpeakinSpell.URL )
end


-- OnNewUserFound(_, username, client_version )
--		Another user of this addon was found.  They are running client_version
--		Only signaled once per user
function SpeakinSpell:OnNewUserFound(_, username, client_version )
	local de = {
		name = "Found a SpeakinSpell User",
		caster = tostring(username),
		target = tostring(username),
		version = tostring(client_version),
		username = tostring(username),
	}
	local message = self:FormatSubs(L["Found a SpeakinSpell User <username> running v<version>"], de)
	self:Network_PrintStatus( "RX", message, de )
end


-- OnNetworkError( _, message )
--		message (string) describes the network error
--		i.e. ""DecodePacket failed" or "unregistered command code:CODEA"
function SpeakinSpell:OnNetworkError(_, message)
	-- show network error for debug output
	local de = {
		name = L["Network Error"],
		message = message,
	}
	self:Network_PrintStatus( "RX", L["Network Error: "]..tostring(message), de )
end


function SpeakinSpell:OnVersionPing(_,packet)
	-- unused
end


-------------------------------------------------------------------------------
-- NEW EVENTS DETECTED
-------------------------------------------------------------------------------


function SpeakinSpell:Network_OnNewEvents( packet )
	local funcname = "Network_OnNewEvents"
	
	-- merge new events lists
	-- (replies handled elsewhere)
	
	-- disregard this if we don't collect this data
	if not SpeakinSpellSavedDataForAll.Networking.Collect.NEW then
		self:DebugMsg(funcname, "CollectNEW is disabled")
		return
	end
	
	-- import the new events we just received
	local n = 0
	for key,de in pairs(packet.data) do
		local known = SpeakinSpellSavedDataForAll.NewEventsDetected[key]
		if not known then
			self:Validate_DetectedEvent(de)
			if key ~= de.key then
				self:DebugMsg(funcname, "validated de has key mismatch, disregarding it")
			else
				-- add the new event info
				SpeakinSpellSavedDataForAll.NewEventsDetected[key] = de
				-- force the GUI to update
				self.RuntimeData.OptionsGUIStates.CreateNew.FilterChanged = true
				n = n+1
			end
		end
	end
	
	-- report status
	-- don't signal each NewEventsDetected item as a speech event - they come in big sets, a bunch at a time
	local de_for_msg = {
		name = L["Received new event hooks"],
		sender = packet.sender,
		channel = packet.distribution,
		distribution = packet.distribution,
		n = n,
	}
	self:Network_PrintStatus( "RX", L["Discovered <n> new event hooks from <sender> (<channel>)"], de_for_msg )
end


-------------------------------------------------------------------------------
-- EVENT TABLES for CONTENT PACKS
-------------------------------------------------------------------------------



function SpeakinSpell:Network_OnEventTable( packet )
	local funcname = "Network_OnEventTable"
	
	-- disregard this if we don't collect speeches
	if not SpeakinSpellSavedDataForAll.Networking.Collect.ET then
		self:DebugMsg(funcname, "CollectET disabled")
		return
	end
	
	-- save the content for future use by the templates system and /ss import
	-- NOTE: the template system will validate the data under LoadTemplate
	SpeakinSpellSavedDataForAll.Networking.CollectedEventTables[ packet.sender ] = packet.data

	local de = {
		name = L["Collected Event Table (Speeches)"],
		sender = packet.sender,
	}
	self:Network_PrintStatus( "RX", L["Collected an Event Table from: <sender>"], de )
end


function SpeakinSpell:Network_OnRandomSubs( packet )
	-- disregard this if we don't collect RandomSubs
	if not SpeakinSpellSavedDataForAll.Networking.Collect.RS then
		self:DebugMsg(funcname, "CollectRS disabled")
		return
	end
	
	-- save the content for future use by the templates system and /ss import
	SpeakinSpellSavedDataForAll.Networking.CollectedRandomSubs[ packet.sender ] = packet.data

	local de = {
		name = L["Collected Random Substitutions"],
		sender = packet.sender,
	}
	self:Network_PrintStatus( "RX", L["Collected random substitutions from: <sender>"], de )
end


function SpeakinSpell:Network_GetCompressedNewEventsDetected( AlreadyKnownToFarEnd ) --note AlreadyKnownToFarEnd can be a nil table
	local data = {}
	
	for key,de in pairs(SpeakinSpellSavedDataForAll.NewEventsDetected) do
		if (not DEFAULT_EVENTHOOKS.NewEventsDetected[key]) -- don't send built-in data
			and (AlreadyKnownToFarEnd and not AlreadyKnownToFarEnd[key]) then		-- don't echo data we just got from this sender
			
			data[key] = { -- this should be all that's needed to identify the event
				type = de.type,
				name = de.name,
			}
			-- add rank only if it applies
			if self:IsEventTypeRankable(de.type) and de.rank and (de.rank ~= "") then
				data[key].rank = de.rank
			end
			-- key only exists for convenience so we can leave it out
			-- will be restored from the current table key at the far end
		end
	end
	
	return data
end


function SpeakinSpell:Network_GetCompressedActiveEventTable()
	local data = {}
	
	local ET = self:GetActiveEventTable()
	for key,ete in pairs( ET ) do
		local de = ete.DetectedEvent
		data[key] = {
			-- key -- reconstructed on the other end
			DetectedEvent = { --only send enough info to ID the event
				name = de.name,
				type = de.type,
			},
			--DisableAnnouncements = false, --don't send this option over the network
			Messages		= ete.Messages, -- the speech list
			--ReadOnly = {}, -- don't send the read-only option over the network
			WhisperTarget	= ete.WhisperTarget,
			Channels		= ete.Channels,
			--NOTE: GetDefaultLanguage("player") doesn't work during loader, or OnInitialize, or OnVariablesLoaded
			RPLanguage				= ete.RPLanguage, -- "Common", "Dwarvish", etc, may also be L["Random"]
			RPLanguageRandomChance	= ete.RPLanguageRandomChance, --0.5, etc
			Frequency				= ete.Frequency,
			Cooldown				= ete.Cooldown,
		}
		-- add rank only if it applies
		if self:IsEventTypeRankable(de.type) and de.rank and (de.rank ~= "") then
			data[key].DetectedEvent.rank = de.rank
		end
	end
	
	return data
end
