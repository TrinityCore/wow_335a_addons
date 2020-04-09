-- Author      : RisM
-- Create Date : 11/29/2009 2:23:42 AM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local LibSmartComm = LibStub:GetLibrary("LibSmartComm-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("gui/generaloptions.lua")


-------------------------------------------------------------------------------
-- GUI LAYOUT - NETWORK DATA SHARING
-------------------------------------------------------------------------------

SpeakinSpell.OptionsGUI.args.Network = {
	order = 1,
	type = "group",
	name = L["Data Sharing"],
	desc = L["Share speeches and other data with other SpeakinSpell users"],
	args = {
		-----------------------
		Header = {
			order = 1,
			type = "header",
			name = function()
				SpeakinSpell:SetLastPageViewed( "Network", L["Data Sharing"] )
				return L["Data Sharing"]
			end,
		},
		Caption = {
			order = 2,
			type = "description",
			name = L["Share speeches and other data with other SpeakinSpell users"].."\n",
		},
		
		-----------------------
		EnableNetwork = {
			order = 3,
			type = "toggle",
			name = "Enable Network Communications",
			width = "full",
			desc = "Allows blocking any and all network communications with other SpeakinSpell users. This is an account-wide option.",
			get = function() return SpeakinSpellSavedDataForAll.Networking.EnableNetwork end,
			set = function(_,value)
				SpeakinSpellSavedDataForAll.Networking.EnableNetwork = value
				if value then
					SpeakinSpell:Network_Init()
				else
					SpeakinSpell:Network_Disable()
				end
			end,
		},
		ShowHideGroup = {
			order = 5,
			type = "group",
			name = L["Networking Options and Commands"],
			desc = "", -- not used
			hidden = function()
				return not SpeakinSpellSavedDataForAll.Networking.EnableNetwork
			end,
			guiInline = true,
			args = {
				DiagnosticsGroup = {
					order = 100,
					type = "group",
					guiInline = true,
					name = L["Diagnostics"],
					args = {
						ShowCommTraffic = {
							order = 1,
							type = "toggle",
							width = "full",
							name = L["Show Comm Traffic"],
							desc = L["Show data sharing communication progress messages in the chat"],
							get = function() return SpeakinSpellSavedDataForAll.Networking.ShowCommTraffic end,
							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.ShowCommTraffic = value end,
						},
						ShowTransferProgress = {
							order = 2,
							type = "toggle",
							width = "full",
							name = L["Show Transfer Progress"],
							desc = L["Show outbound data transfer progress"],
							get = function() return SpeakinSpellSavedDataForAll.Networking.ShowTransferProgress end,
							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.ShowTransferProgress = value end,
							hidden = function() return not SpeakinSpellSavedDataForAll.Networking.ShowCommTraffic end,
						},
						SyncsThisSession = {
							order = 6,
							type = "description",
							width = "full",
							name = function()
								local label = L["During this session, you have synced with the following players:"]
								-- check if any other players have been found (via syncs)
								if SpeakinSpell:IsTableEmpty(LibSmartComm.versionsfound) then
									label = label.."\n"..L["None"] --TODO: is there a GlobalStrings string for "None"?
									return label
								end
								-- enumerate all of the players that we found, and what version they're running
								for name,version in pairs(LibSmartComm.versionsfound) do
									local subs = {
										name = name,
										version = version.client,
									}
									label = label.."\n"..SpeakinSpell.FormatSubs(L["<name> (<version>)"], subs)
								end
								return label
							end,
						},
						ShowStats = {
							order = 4,
							type = "toggle",
							width = "full",
							name = L["Show Statistics"],
							desc = L["Show network transfer statistics"],
							get = function() return SpeakinSpellSavedDataForAll.Networking.ShowStats end,
							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.ShowStats = value end,
						},
						Stats = {
							order = 5,
							type = "description",
							width = "full",
							hidden = function() return not SpeakinSpellSavedDataForAll.Networking.ShowStats end,
							name = function()
								local stats = SpeakinSpell.RuntimeData.Networking.stats
								if not stats then
									return L["Network stats unavailable"]
								end
								local subs = {
queuesize = tostring(stats.queue.size),
queuepeek = tostring(stats.queue.peek),

rawqueued = tostring(stats.totals.sent.rawqueued),
sentactual = tostring(stats.totals.sent.actual),
sendcompression = string.format("%2.1f", 100 * stats.totals.sent.actual / stats.totals.sent.rawqueued),

receivedactual = tostring(stats.totals.received.actual),
receiveduser = tostring(stats.totals.received.user),
receivedcompression = string.format("%2.1f", 100 * stats.totals.received.actual / stats.totals.received.user),

deficit = tostring(stats.totals.sent.actual - stats.totals.received.actual),

overheadpacket = tostring(stats.overhead.packets),
overheadid = tostring(stats.overhead.addonid),
overheadlsc = tostring(stats.overhead.total),
overheadpercent = string.format("%2.1f", 100 * stats.overhead.total / stats.totals.sent.actual),

packovercomp = tostring(LibSmartComm.packetoverhead.compressed),
packoverraw = tostring(LibSmartComm.packetoverhead.uncompressed),
numpackets = tostring(stats.totals.sent.packets),

prefixsize = "3", --string.len(NID), NID not accessible in this file, and this is easier
segments = tostring(stats.totals.sent.segments)
								}
								return SpeakinSpell:FormatSubs( L[
[[
Send queue
size:<queuesize>
peek:<queuepeek>

Total Sent
user data:<rawqueued>
actual:<sentactual>
Compressed to <sendcompression>%

Total Received
actual:<receivedactual>
user data:<receiveduser>
Compressed to <receivedcompression>%

Actual Sent - Received = <deficit>

LibSmartComm overhead
for packets:<overheadpacket>
for addonid:<overheadid>
total:<overheadlsc>
percent overhead:<overheadpercent>%

Overhead per packet
compressed:<packovercomp>
uncompressed:<packoverraw>
total packets:<numpackets>

addonid prefix:<prefixsize>
total segments:<segments>
]]
								], subs )
							end,
						},
					},
				},
				
				AutoSyncGroup = {
					order = 11,
					type = "group",
					guiInline = true,
					name = L["Auto-Sync Options"],
					desc = "", -- not used
					args = {
						Login = {
							order = 1,
							type = "toggle",
							width = "full",
							name = L["Auto-sync at Login"],
							desc = L["Send a data sharing request to GUILD, RAID, PARTY, and BATTLEGROUND channels every time you login or /reloadui"],
							get = function() return SpeakinSpellSavedDataForAll.Networking.AutoSyncOnLogin end,
							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.AutoSyncOnLogin = value end,
						},
--						Join = { --TODOFUTURE: implement AutoSyncOnJoin
--							order = 2,
--							type = "toggle",
--							width = "full",
--							name = L["Auto-sync on Join Group"],
--							desc = L["|cffff0000(not yet implemented)|r\nEnable automatic sync requests sent to the channel when you join a PARTY, GUILD, RAID, or BATTLEGROUND"],
--							get = function() return SpeakinSpellSavedDataForAll.Networking.AutoSyncOnJoin end,
--							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.AutoSyncOnJoin = value end,
--						},
						SyncNowBroadcast = {
							order = 11,
							type = "execute",
							name = L["Global Sync"],
							desc = L["Send a data sharing request to GUILD, RAID, PARTY, and BATTLEGROUND channels.\n\nSame as \"/ss sync\""],
							func = function()
								SpeakinSpell:Network_AutoSync()
							end,
						},
						SyncNowTarget = {
							order = 12,
							type = "execute",
							name = L["Sync with Target"],
							desc = L["Send a data sharing request to your selected target.\n\nSame as \"/ss sync <target>\""],
							func = function()
								SpeakinSpell:Network_SyncWithTarget( UnitName("target") )
							end,
						},
					},
				},
				
				SharingGroup = {
					order = 12,
					type = "group",
					guiInline = true,
					name = L["Sharing vs. Privacy"],
					desc = "", -- not used
					args = {
						ShareET = {
							order = 1,
							type = "toggle",
							width = "full",
							name = L["Share my speeches"],
							desc = L["Share the speeches I have written for SpeakinSpell events"],
							get = function() return SpeakinSpellSavedDataForAll.Networking.Share.ET end,
							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.Share.ET = value end,
						},
						ShareRS = {
							order = 2,
							type = "toggle",
							width = "full",
							name = L["Share my random <substitutions>"],
							desc = L["Share my word lists for <randomsub> words"],
							get = function() return SpeakinSpellSavedDataForAll.Networking.Share.RS end,
							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.Share.RS = value end,
						},
						ShareNEW = {
							order = 3,
							type = "toggle",
							width = "full",
							name = L["Share my detected event hooks"],
							desc = L["Share my list of New Events Detected from the \"/ss create\" interface"],
							get = function() return SpeakinSpellSavedDataForAll.Networking.Share.NEW end,
							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.Share.NEW = value end,
						},
					},
				},
				
				CollectingGroup = {
					order = 13,
					type = "group",
					guiInline = true,
					name = L["Collect from others"],
					desc = "", -- not used
					args = {
						CollectET = {
							order = 1,
							type = "toggle",
							width = "full",
							name = L["Collect Speeches"],
							desc = L["Collect and save speeches written by other SpeakinSpell users"],
							get = function() return SpeakinSpellSavedDataForAll.Networking.Collect.ET end,
							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.Collect.ET = value end,
						},
						CollectRS = {
							order = 2,
							type = "toggle",
							width = "full",
							name = L["Collect Random <substitutions>"],
							desc = L["Collect and save <randomsub> word lists from other SpeakinSpell users"],
							get = function() return SpeakinSpellSavedDataForAll.Networking.Collect.RS end,
							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.Collect.RS = value end,
						},
						CollectNEW = {
							order = 3,
							type = "toggle",
							width = "full",
							name = L["Collect New Event Hooks"],
							desc = L["Collect detected event hooks for the list in the \"/ss create\" interface"],
							get = function() return SpeakinSpellSavedDataForAll.Networking.Collect.NEW end,
							set = function(_,value) SpeakinSpellSavedDataForAll.Networking.Collect.NEW = value end,
						},
						GotoImport = {
							order = 11,
							type = "execute",
							width = "full",
							name = L["Browse Collected Content"],
							desc = L["Click to go to the Import New Data screen to browse the speeches and <randomsub> lists that you've collected from others"],
							func = function()
								--TODOLATER: only load collected speeches? could make that a search option under Import GUI
								SpeakinSpell:Templates_Load() -- removes redundant and inapplicable data while/after loading
								SpeakinSpell:ShowImport()
							end,
						},
					},
				},
			},
		},
	},
}


-------------------------------------------------------------------------------
-- OPTIONS GUI FUNCTIONS - NETWORK DATA SHARING
-------------------------------------------------------------------------------
-- all simple enough to be inline above
