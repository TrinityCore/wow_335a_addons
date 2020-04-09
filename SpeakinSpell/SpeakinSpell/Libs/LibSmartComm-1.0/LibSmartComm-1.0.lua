-------------------------------------------------------------------------------
-- A SMARTER NETWORK COMM SYSTEM
-------------------------------------------------------------------------------
--
-- LibSmartComm-1.0
--
-- Author      : RisM
-- Create Date : 12/6/2009 4:17:01 PM
--
-------------------------------------------------------------------------------
-- Combines the follow software stack into a single simpler API:
--
--	SendAddonMessage
--	ChattThrottleLib
--	AceComm-3.0
--	LibCompress
--
-------------------------------------------------------------------------------
-- Adds more functionality
--
--	simplified API sends tables instead of encoded strings
--	additional wrapper APIs add broadcasting and replies
--	automatic version and compatibility checking
--	route network command IDs to function handlers like other WoWLua events
--	callbacks for various network events: progress indications, error reports, etc
--	statistics tracking to help you refine your network communications
--	ignores messages from yourself (unless debugging is enabled)
--
-------------------------------------------------------------------------------
-- Basic Host Addon Usage: (see code for full API set)
--
--	local NETWORKID = "MYA" --"MYADDON" make this as short as possible while ensuring it will be unique
--
--	RegisterAddon( NETWORKID, clientversion [, dataversion] )
--
--	RegisterCommands( NETWORKID, CommandTable )
--		"CODEA"=OnCommandCodeA( packet )
--		"CODEB"=OnCommandCodeB( packet )
--
--	RegisterCallback( NETWORKID, "OnNetworkError", OnNetworkError ) --and any other callbacks you want
--
--	Send( NETWORKID, "CODEA", data )
--	Send( NETWORKID, "CODEB", data )
--
--	function OnCommandCodeA( packet )
--		you received a packet...
--
--	packet.addonid				-- the NETWORKID
--	packet.command == "CODEA"	-- from Send( NETWORKID, "CODEA", data )
--	packet.data == data or {}	-- from Send( NETWORKID, "CODEA", data )
--
--	packet.sender				-- the sender
--	packet.distribution			-- the channel you received this on
--
--	packet.version.LibSmartComm -- the NETWORK_VERSION of LibSmartComm that sent the packet
--	packet.version.client		-- the clientversion of your addon that sent the packet
--	packet.version.data			-- the dataversion of your addon that sent the packet
--
-------------------------------------------------------------------------------
-- COMPLETE API
--
--	All functions in LibSmartComm are public APIs unless named with '_'
--	should be self-explanatory - see code below
--	use an outline view if possible to see only the list of APIs
--	expand the outlining to see the parameter info
--
-------------------------------------------------------------------------------
--
-- Supported Callback Functions:
--		The first parameter is 'event' = the name of the function, abbreviated as '_' below
--
-- OnPacketQueued(_, packet, packetsize )
--		called when Send() runs, immediately before transmitting the packet
--
-- OnPacketReceive(_, packet, packetsize )
--		a complete packet has been received
--		(called before routing to your registered command handler for the packet)
--
-- OnCharsSent( _, packet, sent, textlen )
--		signals each chunk of progress on sending 'packet'
--		about 250 chars each
--		same as AceComm callbackFn
--
-- OnSendComplete( _, packet, packetsize )
--		Send() finished sending the packet asynchronously
--
-- OnSendQueueEmpty( _ )
--		signals when the send queue is empty
--
-- OnStatsUpdated( _, stats )
--		your comm traffic stats have been updated (for a diagnostic UI)
--		stats == addon.stats (see RegisterAddon)
--
-- OnNewerVersion( _, version )
--		A newer version of your addon sent us a message
--		this will not be repeated more than once for a given version (number or string)
--		but another even higher version might be found later
--
-- OnNetworkError( _, message )
--		message (string) describes the network error
--		i.e. "DecodePacket failed" or "unregistered command code:CODEA"
--
-- OnVersionPing(_, packet )
--		this packet does not have a command or data
--		it is an empty version ping packet
--
-- OnNewUserFound(_, username, client_version )
--		Another user of this addon was found.  They are running client_version
--		Only signaled once per user
--
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- CONFIG
-------------------------------------------------------------------------------

-- MINOR_VERSION controls LibStub, for which instance of LibSmartComm is loaded
local MINOR_VERSION = 3

-- NETWORK_VERSION prevents older/newer versions of the comm system from breaking each other with malformed data
-- This should only be increased if the version table format changes in Encode/DecodePacket
-- otherwise, versioning is controlled by the contents of the version info provided in each packet
local NETWORK_VERSION = 1

-- allow messages from yourself for debugging?
local DEBUG_NETWORK = false


-------------------------------------------------------------------------------
-- INSTANTIATE LIB, load dependent libs
-------------------------------------------------------------------------------

local LibSmartComm = LibStub:NewLibrary("LibSmartComm-1.0", MINOR_VERSION)
if not LibSmartComm then return end

local AceComm		= LibStub:GetLibrary("AceComm-3.0")
local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0")

local LibCompress = LibStub:GetLibrary("LibCompress")
local LCerrmsg = ""
local LCEncoder, LCerrmsg = LibCompress:GetAddonEncodeTable()

if LCerrmsg then
	error( string.format("LibSmartComm LibCompress error GetAddonEncodeTable: %s", tostring(LCerrmsg) ) )
end


-------------------------------------------------------------------------------
-- DEBUGGING and UTILS
-------------------------------------------------------------------------------


local function debug( funcname, msg )
	if DEBUG_NETWORK then
		print( tostring(funcname) .. " - " .. tostring(msg) )
	end
end


function LibSmartComm:GetBroadcastChannels()
	-- only use channels that apply to this character
	-- otherwise we could generate "you are not in a guild" spam, and the like
	local BroadcastChannels = {
		--"GUILD",
		--"RAID",
		--"PARTY",
	}
	if IsInGuild() then
		tinsert(BroadcastChannels, "GUILD")
	end
	local zoneType = select(2, IsInInstance())
	if zoneType=="pvp" then
		tinsert(BroadcastChannels, "BATTLEGROUND")
	elseif GetNumRaidMembers() > 0 then
		tinsert(BroadcastChannels, "RAID")
	elseif GetNumPartyMembers() > 0 then
		tinsert(BroadcastChannels, "PARTY")
	end
	return BroadcastChannels
end


-------------------------------------------------------------------------------
-- INIT / REGISTER APIs
-------------------------------------------------------------------------------


function LibSmartComm:_OneTimeInit()
	if self.init then
		return
	end
	
	-- embed ace libs
	AceComm:Embed(LibSmartComm)
	AceSerializer:Embed(LibSmartComm)

	-- create addons table
	self.addons = {}
	
	-- test size of overhead per packet using minimal data
	self.packetoverhead = {
		compressed = 0,
		uncompressed = 0,
	}
	local dummyAddonObject = {}
	local dummyaddon = self:_NewAddon( "a", dummyAddonObject, 2, 1 )
	local dummydata = {} --IMO a data={table} should be part of this packet overhead test, but the table should be empty
	local packetstring_encoded, rawsize = self:_EncodePacket( dummyaddon, "a", dummydata )
	self.packetoverhead.uncompressed = rawsize
	self.packetoverhead.compressed = string.len( packetstring_encoded )
end


function LibSmartComm:_NewAddon( addonid, AddonObject, clientversion, dataversion )
	local addon = {
		-- description
		id = addonid,
		version = {
			client = clientversion,
			data = dataversion or clientversion, -- dataversion is optional, will use clientversion by default
			newest = clientversion, --for suppressing redundant upgrade alerts
		},
		
		-- other users of this addon
		versionsfound = {
			--["PlayerName"] = version_table,
		},
		
		-- hook functions
		AddonObject = AddonObject, --if command handlers are strings, we'll call AddonObject[handler]()
		OnCommand = {}, -- command handler table - see RegisterCommand
		Callbacks = {}, -- network callback handler table - see RegisterCallback
		
		-- statistics for optimizing your network
		stats = {
			queue = { -- sending only
				size = 0, -- current traffic 
				peek = 0, -- most traffic ever queued at the same time
			},
			totals = {
				sent = {
					rawqueued = 0, -- total uncompressed data sent (your data only)
					actual = 0, -- total size actually sent including all overhead and compression
					packets = 0, -- number of packets (complete tables with message code and data)
					segments = 0, -- number of segments (individual 250-char substrings)
				},
				received = {
					actual = 0, -- accumulated size of all strings received in raw compressed form from AceComm (addonid overhead is not included, but packet overhead and compression is)
					user = 0, -- size of user data received (not including overhead)
				},
			},
			overhead = {
				packets = 0, -- added by packet table format
				addonid = 0, -- added by using addonid prefix in each underlying SendAddonMessage
				total = 0, -- total overhead
			},
		},
	}
	return addon
end


function LibSmartComm:RegisterAddon( addonid, AddonObject, clientversion, dataversion )
--
-- addonid 
--		an abbreviated but unique name for your addon
--
-- AddonObject
--		Your addon table, for callback handler function scope
--		AddonObject:OnSomething(...)
--
-- clientversion 
--		your addon's current version
--		can be string or int
--		must be comparable to older and newer versions
--
-- dataversion 
--		optional, an older compatible data version
--		must be comparable to clientversion in the same format
--		if unspecified, will use clientversion
--
	local fname = "RegisterAddon"
	
	self:_OneTimeInit()
	
	if self.addons[addonid] then
		error( "addonid is already registered" )
		return false
	end
	
	-- create addon object for info about this addon
	self.addons[addonid] = self:_NewAddon( addonid, AddonObject, clientversion, dataversion )
	
	-- register with AceComm
	self:RegisterComm( addonid, "_OnCommReceive" )
	return true
end


function LibSmartComm:RegisterCommand( addonid, command, OnCommand )
--
-- addonid 
--		an abbreviated but unique name for your addon
--
-- command 
--		a network command code defined by your addon
--
-- OnCommand 
--		the function to call when this command is received
--		will be called with a single parameter OnCommand( packet )
--		where 'packet' is a table
--
	local addon = self.addons[addonid]
	if not addon then
		error("unregistered addon:"..tostring(addonid))
		return
	end
	addon.OnCommand[ command ] = OnCommand
	
	--TODOFUTURE: compress command codes to index numbers? 
	--		don't want host addon to cause unexpected incompatibility between versions 
	--		by changing the order of their calls to RegisterCommand
end


function LibSmartComm:RegisterCallback( addonid, name, OnCallback )
-- RegisterCallback( addonid, name, func )
--		registers for a network event callback
--
-- addonid 
--		an abbreviated but unique name for your addon
-- name
--		a LibSmartComm callback event name (see above)
-- func (optional)
--		the callback function: func( event, ... )
--		if unspecified, assume it's AddonObject:name(...)
--
	local addon = self.addons[ addonid ]
	if not addon then
		error("unregistered addon:"..tostring(addonid))
		return
	end
	local func = OnCallback
	if func then
		if type(func) ~= "function" then
			error("func must be a function")
			return
		end
	else
		local afunc = addon.AddonObject[name]
		if not afunc then
			error( string.format("YourAddonObject:%s(...) is undefined", tostring(name)) )
			return
		end
		-- AddonName:OnSomething ... have to pass self manually as follows
		func = function(...) afunc(addon.AddonObject, ...) end
	end
	-- store the callback function
	addon.Callbacks[name] = func
end


function LibSmartComm:Unregister( addonid )
-- Unregister( addonid )
--
-- addonid 
--		an abbreviated but unique name for your addon
--
	-- unregister from AceComm
	self:UnregisterComm( addonid )
	-- unload from our table
	self.addons[addonid] = nil
end


-------------------------------------------------------------------------------
-- CALLBACKS (internal use)
-------------------------------------------------------------------------------


function LibSmartComm:RecordVersion( addon, packet )
	if not packet then
		debug("RecordVersion", "packet is nil")
		return
	end
	
	if not packet.version then
		debug("RecordVersion", "packet.version is nil")
		return
	end
	
	if not packet.sender then
		debug("RecordVersion", "packet.sender is nil")
		return
	end
	
	local known = addon.versionsfound[ packet.sender ]
	if known then
		-- update the version they're using in case they relogged and upgraded/downgraded
		--debug("RecordVersion", string.format("known %s client:%s data:%s", tostring(packet.sender), tostring(known.client), tostring(known.data)))
		addon.versionsfound[packet.sender] = packet.version
	else
		-- remember what version they're running (so we only do this once)
		debug("RecordVersion", string.format("NEW %s client:%s data:%s", tostring(packet.sender), tostring(packet.version.client), tostring(packet.version.data)))
		addon.versionsfound[packet.sender] = packet.version
		-- tell the client app that a new user was found
		self:_FireNetworkCallback( addon, "OnNewUserFound", packet.sender, packet.version.client )
		-- also send back a version ping to let the other end know that we exist
		-- since this is a new user we just discovered, so this is a first-time / one-time handshake
		-- "Hi, I'm running version X" "Hi, I'm running version Y" nice to meet you...
		self:SendReplyVersionOnly( packet )
	end
end


function LibSmartComm:_CheckNewerVersion( addon, version )
	if not version then
		return
	end
	
	if	addon.version.newest < version then
		addon.version.newest = version
		self:_FireNetworkCallback( addon, "OnNewerVersion", version )
	end
end


function LibSmartComm:_FireErrorCallback( addon, msg )
	local funcname = "_FireErrorCallback"
	debug(funcname, msg )
	self:_FireNetworkCallback( addon, "OnNetworkError", msg )
end


function LibSmartComm:_FireNetworkCallback( addon, event, ... )
	local funcname = "_FireNetworkCallback"
	--debug(funcname, tostring(event) )
	local func = addon.Callbacks[event]
	if func then
		func( event, ... )
	end
end


-- called by ChatThrottleLib (under AceComm) after each substring is sent
local function callbackFn( packet, sent, textlen )
	local self = LibSmartComm
	local funcname = "callbackFn"
	local addon = packet.addon
	if not addon then
		error("unregistered addon:"..tostring(addonid))
		return
	end

	-- count segments
	addon.stats.totals.sent.segments = addon.stats.totals.sent.segments + 1
	
	-- update queue size and transfer stats
	local sizesegment = sent - packet.sent
	packet.sent = sent
	addon.stats.queue.size = addon.stats.queue.size - sizesegment --note 'sent' is sent so far, not sent this time - it's cumulative
	addon.stats.totals.sent.actual = addon.stats.totals.sent.actual + sizesegment
	--debug( funcname, "queue.size:"..tostring(addon.stats.queue.size) )
	
	-- update overhead stat to include addonid string
	local prefixlen = string.len( addon.id )
	
	addon.stats.overhead.total	= addon.stats.overhead.total   + prefixlen
	addon.stats.overhead.addonid= addon.stats.overhead.addonid + prefixlen
	
	-- the prefix overhead is part actual data sent
	-- note 'sent' is sent so far, not sent this time - it's cumulative
	addon.stats.totals.sent.actual = addon.stats.totals.sent.actual + prefixlen

	-- done with stats
	self:_FireNetworkCallback( addon, "OnStatsUpdated", addon.stats )

	-- fire callback for OnCharsSent( packet, sent, textlen )
	self:_FireNetworkCallback( addon, "OnCharsSent", packet, sent, textlen )
	
	-- check for packet transfer complete
	if sent == textlen then
		addon.stats.totals.sent.packets = addon.stats.totals.sent.packets + 1
		-- fire callback for OnSendComplete( packet, packetsize )
		self:_FireNetworkCallback( addon, "OnSendComplete", packet, textlen )
		
	end
	
	-- check for all queued transfers finished
	if addon.stats.queue.size <= 0 then
		--addon.stats.queue.size = 0 --this shouldn't go below 0 - and I'd like the display to show if I screw this up
		-- fire callback for OnSendQueueEmpty(  )
		self:_FireNetworkCallback( addon, "OnSendQueueEmpty" )
	end

end



-------------------------------------------------------------------------------
-- SEND APIs
-------------------------------------------------------------------------------


function LibSmartComm:Send( addonid, command, data, distribution, target )
	local funcname = "Send"
--
-- addonid 
--		an abbreviated but unique name for your addon
-- command
--		a command defined by your addon, registered with RegisterCommand
-- data
--		any data you want to attach to the command
--		may be nil or any data type
-- distribution
--		a channel valid for SendAddonMessage (GUILD, RAID, PARTY, BATTLEGROUND, or WHISPER)
-- target
--		only used if distribution is WHISPER
--
	
	local addon = self.addons[ addonid ]
	if not addon then -- unregistered addon
		error("unregistered addon:"..tostring(addonid))
		return
	end
	
	-- create a packet as string to send through SendCommMessage -> SendAddonMessage
	local packetstring_encoded, rawlen, packet = self:_EncodePacket( addon, command, data )
	if not packetstring_encoded then
		--error("_EncodePacket failed") -- error already shown by _EncodePacket
		return
	end
	
	-- track stats for queue, overhead, and total sent
	local packetsize = string.len( packetstring_encoded )
	addon.stats.queue.size = addon.stats.queue.size + packetsize
	--debug( funcname, "queue.size:"..tostring(addon.stats.queue.size) )
	if  addon.stats.queue.peek < addon.stats.queue.size then
		addon.stats.queue.peek = addon.stats.queue.size
	end	
	-- track overhead from LibSmartComm packetizing
	addon.stats.overhead.total	= addon.stats.overhead.total   + self.packetoverhead.compressed
	addon.stats.overhead.packets= addon.stats.overhead.packets + self.packetoverhead.compressed
	-- track raw user data queued
	addon.stats.totals.sent.rawqueued = addon.stats.totals.sent.rawqueued + rawlen -- - self.packetoverhead.uncompressed
	-- done updating stats
	self:_FireNetworkCallback( addon, "OnStatsUpdated", addon.stats )


	-- add distribution info to the packet, for using packet as callbackArg
	packet.distribution = distribution
	packet.target = target
	packet.addon = addon --for callback routing
	packet.command = command -- abbreviated above, expanded by decode
	packet.sent = 0 --amount of this packet sent so far
	
	self:_FireNetworkCallback( addon, "OnPacketQueued", packet, packetsize )
	
	-- send
	self:SendCommMessage( addonid, packetstring_encoded, distribution, target, "NORMAL", callbackFn, packet )
end


-------------------------------------------------------------------------------
-- _OnCommReceive when AceComm is done receiving a complete packet
-------------------------------------------------------------------------------


function LibSmartComm:_OnCommReceive( addonid, packetstring_encoded, distribution, sender )
	local funcname = "_OnCommReceive"
	--debug(funcname, "entry")
	
	-- ignore messages from myself
	if sender == UnitName("player") and not DEBUG_NETWORK then
		debug(funcname, "sender is self") -- won't have an effect because DEBUG_NETWORK must be off to run this line of code
		return
	end
	
	-- check the addonid prefix for registered addons
	local addon = self.addons[ addonid ]
	if not addon then
		error("unregistered addon:"..tostring(addonid))
		return
	end
	
	-- decode the packet string to table form
	local packet, userdatasize = self:_DecodePacket( addon, packetstring_encoded, distribution, sender )
	if not packet then
		--debug(funcname, "DecodePacket failed") --debug messages already printed by DecodePacket
		-- don't print this error message or fire the callback for blocking messages from myself
		self:_FireErrorCallback( addon, "DecodePacket failed:"..tostring(userdatasize) )
		return
	end
	
	-- track stats 
	local packetsize = string.len(packetstring_encoded)
	addon.stats.totals.received.actual	= addon.stats.totals.received.actual	+ packetsize
	addon.stats.totals.received.user	= addon.stats.totals.received.user		+ userdatasize
	self:_FireNetworkCallback( addon, "OnStatsUpdated", addon.stats )
	
	-- version ping only? don't count it as a real packet
	if not packet.command then
		self:_FireNetworkCallback( addon, "OnVersionPing", packet )
		return
	end
	
	-- generic alert to the host addon that a packet was received
	self:_FireNetworkCallback( addon, "OnPacketReceive", packet, packetsize )
	
	-- call the addon's command handler for this command
	local func = addon.OnCommand[ packet.command ]
	if not func then
		self:_FireErrorCallback( addon, "unregistered command code:"..tostring(packet.command))
		return
	end

	-- call the command handler
	--debug(funcname, "found func for:"..tostring(packet.command))
	func( packet )
end


-------------------------------------------------------------------------------
-- ENCODE / DECODE PACKET TABLES
-------------------------------------------------------------------------------


-- return packetstring_encoded or nil
function LibSmartComm:_EncodePacket( addon, command, data )
	-- format the packet table
	-- it's easier to maintain and read the code if we serialize it into a single table
	-- we can also talk to older/newer version that used a different number of parameters
	-- even if it does add a few bytes to specify the parameter names
	-- to reduce network data size, use short names here
	-- we'll expand these names for readability in the host addon when we DecodePacket
	local packet = {
		-- LibSmartComm version 
		-- DO NOT RENAME: past versions are checking this to avoid LUA errors
		-- inc NETWORK_VERSION if table members below are removed or renamed (or change meaning)
		LSCV = NETWORK_VERSION,
		
		-- addon version info
		dv = addon.version.data,
		cv = addon.version.client,
		
		-- command and parameters
		c = command,
		d = data,
	}
	-- convert to string
	local packetstring = self:Serialize( packet )
	local rawlen = string.len( packetstring )
	
	-- compress the data (can only work on strings)
	local packetstring_compressed, LCerrmsg = LibCompress:Compress( packetstring )
	if LCerrmsg then
		error( string.format("LibCompress error - %s: %s", "Compress", tostring(LCerrmsg) ) )
		return
	end

	-- encode the compressed data to remove embedded nulls
	local packetstring_encoded = LCEncoder:Encode(packetstring_compressed)
	
	return packetstring_encoded, rawlen, packet
end


-- return packet_table or nil
function LibSmartComm:_DecodePacket( addon, packetstring_encoded, distribution, sender )
	local funcname = "_DecodePacket"
	
	-- decode the string to restore embedded nulls
	local packetstring_decoded = LCEncoder:Decode( packetstring_encoded )

	-- decompress the string
	local packstring_decompressed, LCerrmsg = LibCompress:Decompress( packetstring_decoded )
	if LCerrmsg or (not packstring_decompressed) then
		-- never seen this fail except from my coding error mismanaging the data encode/decode process
		local msg = string.format("LibCompress error - %s: %s", "Decompress", tostring(LCerrmsg) )
		debug( funcname, msg )
		return nil, msg
	end

	-- deserialize the string into a table
	local success, packet = self:Deserialize( packstring_decompressed )
	
	-- make sure Deserialize gave us a table
	if not (success and type(packet) == "table") then
		-- never seen this fail except from my coding error mismanaging the data encode/decode process
		debug( funcname, "Deserialize failed" )
		return nil, "Deserialize failed"
	end
	
	-------------------------------
	-- NETWORK_VERSION check
	
	if not ( packet.LSCV and (packet.LSCV == NETWORK_VERSION) ) then
		-- a different version of LibSmartComm packaged the packet_table differently
		local msg = "incompatible LSCV:"..tostring(packet.LSCV)
		debug( funcname, msg )
		-- show that a new version is available (maybe, if these vars still exist in the packet_table)
		self:_CheckNewerVersion( addon, packet.cv or packet.dv )
		return nil, msg
	end

	-- The version of LibSmartComm that sent this packet matches our NETWORK_VERSION
	-- so we are safe to parse the packet table	
	-- and expand out shortened id names for readability in the host addon
	-- these were abbreviated for shorter network traffic, but i HATE 2-letter identifier names like that
	-- NOTE: if one is undefined, assume they match (hence the 'or' below)
	packet.version = {
		data = packet.dv or packet.cv,
		client = packet.cv or packet.dv,
		LibSmartComm = packet.LSCV,
	}
	
	packet.dv = nil
	packet.cv = nil
	packet.LSCV = nil
	
	packet.command = packet.c
	packet.data = packet.d or {} --to prevent unexpected nil errors in host addon
	packet.c = nil
	packet.d = nil

	packet.addonid = addon.id
	packet.sender = sender
	packet.distribution = distribution
	
	-------------------------------
	-- HOST APP VERSION CHECKS
	
	-- RecordVersion does not include a check for new versions
	self:RecordVersion( addon, packet )
	
	-- we expect all packets to include a data version, and it must match the local host addon's data version
	if not ( packet.version.data and (packet.version.data == addon.version.data) ) then
		-- the addon who sent us this packet is using an incompatible data version for our local host addon
		-- like LSCV, but for the host addon changing the format of the 'data'
		-- the host addon doesn't want incompatible data from users of a different version
		-- the host addon only wants a version check to say "newer version available! go download it"
		local msg = "addon incompatible data version:"..tostring(packet.version.data)
		debug( funcname, msg )
		self:_CheckNewerVersion( addon, packet.version.client )
		return nil, msg
	end
	
	-------------------------------
	-- the packet is OK for both LSC and the host app
	
	-- check the sending addon's client version (cv) for upgrade reports
	-- cv incs don't create incompatibility in the network - only data and comm versions to worry about
	-- otherwise this is an automatic version checking feature of LibSmartComm
	self:_CheckNewerVersion( addon, packet.version.client )
	
	-- return user data size for stats tracking
	local userdatasize = string.len(packstring_decompressed) -- - self.packetoverhead.uncompressed
	
	-------------------------------
	-- success
	return packet, userdatasize
end


-------------------------------------------------------------------------------
-- SHORTCUT / WRAPPER APIS
-------------------------------------------------------------------------------
-- wrappers to APIs above
-- for info about parameters, see the raw APIs above


function LibSmartComm:SendReply( command, data, packet )
	-- the sender should always be known
	if not packet.sender then
		debug("LibSmartComm:SendReply - can't reply because sender is nil")
		return false
	end
	-- always reply as a whisper - nobody else wants to hear it
	return self:Send( packet.addonid, command, data, "WHISPER", packet.sender )
end


function LibSmartComm:SendReplyVersionOnly( packet )
	self:SendReply( nil,nil,packet )
end


function LibSmartComm:Broadcast(addonid, command, data)
	-- where should we broadcast?
	local BroadcastChannels = self:GetBroadcastChannels()
	
	local sentsomething = false
	-- send to all channels
	for i,channel in pairs(BroadcastChannels) do
		self:Send(addonid, command, data, channel, nil)
		sentsomething = true
	end
	return sentsomething
end


function LibSmartComm:RegisterCommands( addonid, CommandTable )
	for command, OnCommand in pairs(CommandTable) do
		self:RegisterCommand( addonid, command, OnCommand )
	end
end

