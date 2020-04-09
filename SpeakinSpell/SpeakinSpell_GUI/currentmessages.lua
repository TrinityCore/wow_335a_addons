-- Author      : RisM
-- Create Date : 9/21/2009 3:07:03 AM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("gui/currentmessages.lua")

-------------------------------------------------------------------------------
-- GUI LAYOUT - Message Settings
-------------------------------------------------------------------------------


SpeakinSpell.OptionsGUI.args.CurrentMessagesGUI = {
	order = 2,
	type = "group",
	name = L["General Settings"],
	desc = L["General Settings for SpeakinSpell"],
	args = {
		---------------------------------------------------------------
		Caption = {
			name = L["Edit Speech / Announcement Settings"],
			type = "header",
			order = 1,
		},
		SearchOptions = {
			--name = L["1. Search..."],
			name = function() -- this also serves as a loader
				SpeakinSpell:LoadChatColorCodes() -- we have to do this later than OnVariablesLoaded, and this is the best time, once on-load of this page
				SpeakinSpell:SetLastPageViewed( "CurrentMessagesGUI", L["Message Settings"] )
				return tostring(SpeakinSpellSavedData.Colors.Headings)..L["1. Search..."]
			end,
			order = 2,
			type = "group",
			guiInline = true,
			args = {
				EventTextFilterSelect = {
					order = 2,
					type = "input",
					width = "full",
					name = SEARCH,
					desc = L["Type some of the name of what you're looking for, to narrow down the list below"],
					get = function() return  SpeakinSpell:CurrentMessagesGUI_OnGetSetEventTextFilter("GET",nil) end,
					set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnGetSetEventTextFilter("SET",value) end,
				},
				EventTypeFilterSelect = {
					order = 3,
					type = "select",
					width = "full",
					name = L["Select a Category of Events"],
					desc = L["Show only this kind of event in the list below"],
					values = function() return SpeakinSpell.EventTypes.AS_FILTERS end,
					get = function() return  SpeakinSpell:CurrentMessagesGUI_OnEventTypeFilterSelect("GET",nil) end,
					set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnEventTypeFilterSelect("SET",value) end,
				},
				ShowMoreThanAHundred = {
					order = 4,
					type = "toggle",
					width = "full",
					name = L["Show More than 100 Search Results"],
					desc = L["Enable to show more than 100 search results in the drop-down list below.\n\nEnabling this option can slow down the performance of this window. (capped at 200 max to avoid memory overflows)"],
					get = function() return  SpeakinSpell:CurrentMessagesGUI_OnToggleShowMoreThanAHundred("GET",nil) end,
					set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnToggleShowMoreThanAHundred("SET",value) end,
				},
			},
		},
--		Gap1 = {
--			name = "\n",
--			order = 3,
--			type = "description",
--			width = "full",
--		},
		---------------------------------------------------------------
		SelectGroup = {
			name = function()
				return tostring(SpeakinSpellSavedData.Colors.Headings)..L["2. Select..."]
			end,
			order = 4,
			type = "group",
			guiInline = true,
			args = {
				NoSearchResults = {
					name = "\n"..L["No Matching Search Results Found"].."\n",
					order = 11,
					type = "description",
					width = "full",
					hidden = function() return SpeakinSpell:CurrentMessagesGUI_ShowSelectedEventControls() end,
				},
				EventSelect = {
					order = 12,
					type = "select",
					width = "full",
					--name = L["Select a Spell"],
					name = function() return SpeakinSpell:GUI_GetEventSelectLabel() end,
					desc = L["Select a spell from the list to configure the random announcements for that spell."],
					values = {},
					get = function() return  SpeakinSpell:CurrentMessagesGUI_OnEventSelect("GET",nil) end,
					set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnEventSelect("SET",value) end,
					hidden = function() return not SpeakinSpell:CurrentMessagesGUI_ShowSelectedEventControls() end,
				},
				SelectedKey = {
					order = 13,
					type = "description",
					width = "full",
					name = function() return "Selected key:"..tostring(SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey) end,
					hidden = function() return not SpeakinSpellSavedData.ShowDebugMessages end,
				},
				CreateSpellButton = {
					order = 14,
					type = "execute",
					name = L["Create New..."],
					desc = L["Click here to create settings for a new spell, ability, effect, macro, or other event"],
					func = function() SpeakinSpell:CurrentMessagesGUI_OnClickGotoCreate() end,
				},
			},
		},
--		Gap2 = {
--			name = "\n",
--			order = 5,
--			type = "description",
--			width = "full",
--		},
		---------------------------------------------------------------
		EditGroup = {
			name = function()
				return tostring(SpeakinSpellSavedData.Colors.Headings)..L["3. Edit..."]
			end,
			order = 6,
			type = "group",
			guiInline = true,
			hidden = function() return not SpeakinSpell:CurrentMessagesGUI_ShowSelectedEventControls() end,
			args = {
--				Caption = {
--					order = 1,
--					type = "header",
--					name = function()
--						return SpeakinSpell:CurrentMessagesGUI_GetSelectedDisplayNameForEditLabel()
--					end
--				},
				------------------------------
				FrequencyOptionsGroup = {
					order = 2,
					type = "group",
					--name = L["How often you say (Cooldowns/Limits)"],
					name = function()
						local subs = {
							-- color coded to show search matches
							selectedevent = SpeakinSpell:CurrentMessagesGUI_GetSelectedDisplayNameForEditLabel(),
						}
						return SpeakinSpell:FormatSubs(L["How Often? <selectedevent>"], subs)
					end,
					--name = L["Chat Frequency / Spam Reduction Options"],
					--name = L["Limits"],
					--desc = L["Edit Chat Announcement Frequency and Spam Reduction Options"],
					guiInline = true,
					args = {
--						Header = {
--							order = 1,
--							name = L["Limits"],
--							type = "header",
--						},
						Minimize = {
							order = 4,
							width = "full",
							type = "toggle",
							func = function()
								SpeakinSpellSavedDataForAll.ShowFrequencyGroup = not SpeakinSpellSavedDataForAll.ShowFrequencyGroup
							end,
							get = function() return SpeakinSpellSavedDataForAll.ShowFrequencyGroup end,
							set = function(_,value) SpeakinSpellSavedDataForAll.ShowFrequencyGroup = value end,
							name = L["Show These Options"],
							desc = L["Show these options for chat frequency, cooldowns, and other limits"]
						}, --"show these options"
--						Caption = {
--							order = 3,
--							name = L["Edit Chat Announcement Frequency and Spam Reduction Options"].."\n",
--							type = "header",
--							--hidden = function() return not SpeakinSpellSavedDataForAll.ShowFrequencyGroup end,
--						}, --L["Edit Chat Announcement Frequency and Spam Reduction Options"]
						DeleteSpellButton = {
							order = 2,
							type = "execute",
							name = L["Delete this Event"],
							desc = L["Remove the selected spell from the list"],
							func = function() SpeakinSpell:CurrentMessagesGUI_OnClickDelete() end,
							--hidden = function() return not SpeakinSpellSavedDataForAll.ShowFrequencyGroup end,
						}, --L["Delete this Event"]
						Disable = {
							order = 1,
							type = "toggle",
							width = "full",
							name = L["Disable announcements for this Speech Event"],
							desc = L["Stop SpeakinSpell from announcing the selected spell or event"],
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnSpellDisable("GET",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnSpellDisable("SET",value) end,
							--hidden = function() return not SpeakinSpellSavedDataForAll.ShowFrequencyGroup end,
						}, --"disable this event"
						FrequencySelect = {
							order = 31,
							type = "range",
							width = "full",
							name = L["Random Chance (%)"],
							desc = L[
[[You have a random chance to say a message each time you use the selected spell, based on this selected percentage.

100% will always speak. 0% will never speak.]]
							],
							min = 0.01, max = 1.00, step=0.01,
							isPercent = true,
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnFrequencySelect("GET",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnFrequencySelect("SET",value) end,
							hidden = function() return not SpeakinSpellSavedDataForAll.ShowFrequencyGroup end,
						}, --"random chance"
						CooldownSlider = {
							order = 32,
							type = "range",
							width = "full",
							name = L["Cooldown (seconds)"] ,
							desc = L["To prevent SpeakinSpell from speaking in the chat too often for this spell, you can set a cooldown for how many seconds must pass before SpeakinSpell will announce this spell again."],
							min =0, max = 600, step=1, -- allowing for 0 seconds up to 10 minutes
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnCooldownSlider("GET",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnCooldownSlider("SET",value) end,
							hidden = function() return not SpeakinSpellSavedDataForAll.ShowFrequencyGroup end,
						}, --"cooldown (seconds)"
						OncePerCombatToggle = {
							order = 33,
							type = "toggle",
							width = "double",
							name = L["Limit once per combat"],
							desc = L["Do not announce this event more than once until you either leave combat, or enter combat."],
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnOncePerCombatToggle("GET",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnOncePerCombatToggle("SET",value) end,
							hidden = function() return not SpeakinSpellSavedDataForAll.ShowFrequencyGroup end,
						}, --"once per combat"
						OncePerTargetToggle = {
							order = 34,
							type = "toggle",
							width = "double",
							name = L["Limit once per <target>"],
							desc = L[
[[Do not announce this event more than once in a row for the same <target> name.

Note that for spells and events that only ever target you, you're name will never change, so this would limit the announcement to once per login session.]]
							],
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnOncePerTargetToggle("GET",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnOncePerTargetToggle("SET",value) end,
							hidden = function() return not SpeakinSpellSavedDataForAll.ShowFrequencyGroup end,
						}, --"once per <target> name"
					}, -- end FrequencyOptionsGroup.args
				}, -- L["How often you say (Cooldowns/Limits)"]
--				Gap1 = {
--					name = "\n",
--					order = 22,
--					type = "description",
--					width = "full",
--				},
				------------------------------
				ChatChannelOptionsGroup = {
					order = 22,
					type = "group",
					--name = L["Where you say (Channels/Whisper)"],
					name = function()
						local subs = {
							-- color coded to show search matches
							selectedevent = SpeakinSpell:CurrentMessagesGUI_GetSelectedDisplayNameForEditLabel(),
						}
						return SpeakinSpell:FormatSubs(L["Which Channel? <selectedevent>"], subs)
					end,
					--name = L["Chat Channels / Whisper Options"],
					--name = L["Channels/Whisper"],
					--desc = L["Edit Chat Channel and Whisper Options"],
					guiInline = true,
					args = {
--						Header = {
--							order = 1,
--							name = L["Channels/Whisper"],
--							type = "header",
--						},
						Minimize = {
							order = 1,
							width = "full",
							type = "toggle",
							func = function()
								SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup = not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup
							end,
							get = function() return SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
							set = function(_,value) SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup = value end,
							name = L["Show These Options"],
							desc = L["Show these options for chat channel selections"]
						}, --"show/hide"
--						Caption = {
--							order = 2,
--							name = L["Edit Chat Channel and Whisper Options"].."\n",
--							type = "description",
--						},
						WhisperTargetToggle = {
							order = 3,
							type = "toggle",
							width = "full",
							name = L["Whisper the message to your <target>"],
							desc = L[
[[Enable whispering the announcement to the friendly <target> of your spell.

Non-spell Speech Events also have a <target>. This uses the same target as the <target> substitution, and will not whisper to yourself.]]
							],
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnWhisperTarget("GET",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnWhisperTarget("SET",value) end,
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
						},
						ChannelSelectCaption = {
							order = 10,
							type = "description",
							width= "full",
							name = "\n"..L["Select the channel to use for this spell, while..."],
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
						},
						ChannelSelectSolo = {
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
							order = 11,
							type = "select",
							name = L["By yourself"],
							desc = L["Select which channel to use for this spell while playing solo"],
							values = function()
								local channels = { -- color-coded to match default chat channel colors
									["SPEAKINSPELL CHANNEL"] = "",
									["SELF RAID WARNING CHANNEL"] = "",
									["GUILD"] = "",
									--["BATTLEGROUND"] = "",
									--["RAID"] = "",
									--["PARTY"] = "",
									["SAY"] = "",
									["EMOTE"] = "",
									["YELL"] = "",
									--["RAID_WARNING"] = "",
									["Silent"] = "",
									["RAID_BOSS_WHISPER"] = "",
									["MYSTERIOUS VOICE"] = "",
									["COMM TRAFFIC RX"] = "",
									["COMM TRAFFIC TX"] = "",
								}
								return SpeakinSpell:ColorizeChannelList( channels )
							end,
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("GET","Solo",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("SET","Solo",value) end,
						},
						ChannelSelectParty = {
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
							order = 12,
							type = "select",
							name = L["In a Party"],
							desc = L["Select which channel to use for this spell while in a Party"],
							values = function()
								local channels = { -- color-coded to match default chat channel colors
									["SPEAKINSPELL CHANNEL"] = "",
									["SELF RAID WARNING CHANNEL"] = "",
									["GUILD"] = "",
									--["BATTLEGROUND"] = "",
									--["RAID"] = "",
									["PARTY"] = "",
									["SAY"] = "",
									["EMOTE"] = "",
									["YELL"] = "",
									--["RAID_WARNING"] = "", --disabled by Blizzard in 5-mans in WoW 3.3.0
									["Silent"] = "",
									["RAID_BOSS_WHISPER"] = "",
									["MYSTERIOUS VOICE"] = "",
									["COMM TRAFFIC RX"] = "",
									["COMM TRAFFIC TX"] = "",
								}
								return SpeakinSpell:ColorizeChannelList( channels )
							end,
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("GET","Party",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("SET","Party",value) end,
						},
						ChannelSelectRaid = {
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
							order = 14,
							type = "select",
							name = L["In a Raid"],
							desc = L["Select which channel to use for this spell while in a Raid"],
							values = function()
								local channels = { -- color-coded to match default chat channel colors
									["SPEAKINSPELL CHANNEL"] = "",
									["SELF RAID WARNING CHANNEL"] = "",
									["GUILD"] = "",
									--["BATTLEGROUND"] = "",
									["RAID"] = "",
									["PARTY"] = "",
									["SAY"] = "",
									["EMOTE"] = "",
									["YELL"] = "",
									--["RAID_WARNING"] = "",
									["Silent"] = "",
									["RAID_BOSS_WHISPER"] = "",
									["MYSTERIOUS VOICE"] = "",
									["COMM TRAFFIC RX"] = "",
									["COMM TRAFFIC TX"] = "",
								}
								return SpeakinSpell:ColorizeChannelList( channels )
							end,
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("GET","Raid",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("SET","Raid",value) end,
						},
						ChannelSelectPartyLeader = {
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
							order = 13,
							type = "select",
							name = PARTY_LEADER,
							desc = L["Use this channel if you are the leader of a 5-man party"],
							values = function()
								local channels = { -- color-coded to match default chat channel colors
									["SPEAKINSPELL CHANNEL"] = "",
									["SELF RAID WARNING CHANNEL"] = "",
									["GUILD"] = "",
									--["BATTLEGROUND"] = "",
									--["RAID"] = "",
									["PARTY"] = "",
									["SAY"] = "",
									["EMOTE"] = "",
									["YELL"] = "",
									--["RAID_WARNING"] = "", --disabled by Blizzard in 5-mans in WoW 3.3.0
									["Silent"] = "",
									["RAID_BOSS_WHISPER"] = "",
									["MYSTERIOUS VOICE"] = "",
									["COMM TRAFFIC RX"] = "",
									["COMM TRAFFIC TX"] = "",
								}
								return SpeakinSpell:ColorizeChannelList( channels )
							end,
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("GET","PartyLeader",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("SET","PartyLeader",value) end,
						},
						ChannelSelectRaidLeader = {
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
							order = 16,
							type = "select",
							name = RAID_LEADER,
							desc = L["Use this channel if you are the leader of a raid group"],
							values = function()
								local channels = { -- color-coded to match default chat channel colors
									["SPEAKINSPELL CHANNEL"] = "",
									["SELF RAID WARNING CHANNEL"] = "",
									["GUILD"] = "",
									--["BATTLEGROUND"] = "",
									["RAID"] = "",
									["PARTY"] = "",
									["SAY"] = "",
									["EMOTE"] = "",
									["YELL"] = "",
									["RAID_WARNING"] = "",
									["Silent"] = "",
									["RAID_BOSS_WHISPER"] = "",
									["MYSTERIOUS VOICE"] = "",
									["COMM TRAFFIC RX"] = "",
									["COMM TRAFFIC TX"] = "",
								}
								return SpeakinSpell:ColorizeChannelList( channels )
							end,
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("GET","RaidLeader",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("SET","RaidLeader",value) end,
						},
						ChannelSelectRaidOfficer = {
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
							order = 15,
							type = "select",
							name = L["Raid Officer"],
							desc = L["Use this channel if you are promoted to assist in a raid group"],
							values = function()
								local channels = { -- color-coded to match default chat channel colors
									["SPEAKINSPELL CHANNEL"] = "",
									["SELF RAID WARNING CHANNEL"] = "",
									["GUILD"] = "",
									--["BATTLEGROUND"] = "",
									["RAID"] = "",
									["PARTY"] = "",
									["SAY"] = "",
									["EMOTE"] = "",
									["YELL"] = "",
									["RAID_WARNING"] = "",
									["Silent"] = "",
									["RAID_BOSS_WHISPER"] = "",
									["MYSTERIOUS VOICE"] = "",
									["COMM TRAFFIC RX"] = "",
									["COMM TRAFFIC TX"] = "",
								}
								return SpeakinSpell:ColorizeChannelList( channels )
							end,
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("GET","RaidOfficer",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("SET","RaidOfficer",value) end,
						},
						ChannelSelectBG = {
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
							order = 17,
							type = "select",
							name = L["In a Battleground"],
							desc = L["Select which channel to use for this spell while in a Battleground"],
							values = function()
								local channels = { -- color-coded to match default chat channel colors
									["SPEAKINSPELL CHANNEL"] = "",
									["SELF RAID WARNING CHANNEL"] = "",
									["GUILD"] = "",
									["BATTLEGROUND"] = "",
									--["RAID"] = "",
									["PARTY"] = "",
									["SAY"] = "",
									["EMOTE"] = "",
									["YELL"] = "",
									--["RAID_WARNING"] = "",
									["Silent"] = "",
									["RAID_BOSS_WHISPER"] = "",
									["MYSTERIOUS VOICE"] = "",
									["COMM TRAFFIC RX"] = "",
									["COMM TRAFFIC TX"] = "",
								}
								return SpeakinSpell:ColorizeChannelList( channels )
							end,
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("GET","BG",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("SET","BG",value) end,
						},
						ChannelSelectArena = {
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
							order = 18,
							type = "select",
							name = L["In Arena"],
							desc = L["Select which channel to use for this spell while playing in the Arena"],
							values = function()
								local channels = { -- color-coded to match default chat channel colors
									["SPEAKINSPELL CHANNEL"] = "",
									["SELF RAID WARNING CHANNEL"] = "",
									["GUILD"] = "",
									--["BATTLEGROUND"] = "",
									["RAID"] = "",
									["PARTY"] = "",
									["SAY"] = "",
									["EMOTE"] = "",
									["YELL"] = "",
									["RAID_WARNING"] = "",
									["Silent"] = "",
									["RAID_BOSS_WHISPER"] = "",
									["MYSTERIOUS VOICE"] = "",
									["COMM TRAFFIC RX"] = "",
									["COMM TRAFFIC TX"] = "",
								}
								return SpeakinSpell:ColorizeChannelList( channels )
							end,
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("GET","Arena",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("SET","Arena",value) end,
						},
						ChannelSelectWG = {
							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowChannelsGroup end,
							order = 19,
							type = "select",
							name = L["In Wintergrasp"],
							desc = L[
[[Select which channel to use for this spell while playing in a Wintergrasp battle.  This only applies during an active battle.]]
							],
							values = function()
								local channels = { -- color-coded to match default chat channel colors
									["SPEAKINSPELL CHANNEL"] = "",
									["SELF RAID WARNING CHANNEL"] = "",
									["GUILD"] = "",
									--["BATTLEGROUND"] = "",
									["RAID"] = "",
									["PARTY"] = "",
									["SAY"] = "",
									["EMOTE"] = "",
									["YELL"] = "",
									--["RAID_WARNING"] = "",
									["Silent"] = "",
									["RAID_BOSS_WHISPER"] = "",
									["MYSTERIOUS VOICE"] = "",
									["COMM TRAFFIC RX"] = "",
									["COMM TRAFFIC TX"] = "",
								}
								return SpeakinSpell:ColorizeChannelList( channels )
							end,
							get = function() return  SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("GET","WG",nil) end,
							set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnChannelSelect("SET","WG",value) end,
						},
					}, -- end args
				}, -- L["Where you say (Channels/Whisper)"]
--				Gap2 = {
--					name = "\n",
--					order = 23,
--					type = "description",
--					width = "full",
--				},
				------------------------------
				SpeechListGroup = {
					order = 24,
					type = "group",
					--name = L["What you say (Speeches)"],
					name = function()
						local subs = {
							-- color coded to show search matches
							selectedevent = SpeakinSpell:CurrentMessagesGUI_GetSelectedDisplayNameForEditLabel(),
						}
						return SpeakinSpell:FormatSubs(L["What to Say? <selectedevent>"], subs)
					end,
					--name = L["Speeches"],
--					name = function()
--						return L["Speeches for "]..SpeakinSpell:CurrentMessagesGUI_GetSelectedDisplayNameForEditLabel()
--					end,
					--desc = L["Edit the random speeches used for this Speech Event announcement"],
					guiInline = true,
					args = {
--						Header = {
--							order = 1,
--							name = L["Speeches"],
--							type = "header",
--						},
--						Minimize = {
--							order = 1,
--							width = "full",
--							type = "toggle",
--							get = function() return SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowSpeechesGroup end,
--							set = function(_,value) SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowSpeechesGroup = value end,
--							name = L["Show the Speech List"],
--							desc = L["Show the list of speeches, for editing what you say to announce this event"]
--						}, --"show/hide"
--						Caption = {
--							hidden = function() return not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowSpeechesGroup end,
--							order = 3,
--							type = "header",
--							name = L["Edit the random speeches used for this Speech Event announcement"].."\n",
--						}, --L["Edit the random speeches used for this Speech Event announcement"]
						Delete = {
							order = 10,
							type = "execute",
							name = L["Delete All Speeches"],
							desc = L["Delete all of the speeches for the selected event, INCLUDING read-only speeches"],
							func = function() SpeakinSpell:CurrentMessageGUI_DeleteAllSpeeches() end,
							hidden = function()
								--if not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowSpeechesGroup then
								--	return true
								--end
								local EventTableEntry = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
								if (not EventTableEntry) then
									return true
								end
								return SpeakinSpell:IsTableEmpty(EventTableEntry.Messages)
							end,
						}, --L["Delete All Speeches"]
						ShowReadyOnly = {
							order = 22,
							type = "toggle",
							width = "full",
							name = L["Show Read-Only Speeches"],
							desc = L["Toggle showing read-only speeches in the list below."],
							get = function() return SpeakinSpellSavedDataForAll.ShowReadOnlySpeeches end,
							set = function(_,value) SpeakinSpellSavedDataForAll.ShowReadOnlySpeeches = value end,
						}, --L["Show Ready-Only Speeches"]
						NumHidden = {
							order = 23,
							type = "description",
							hidden = function()
								return SpeakinSpellSavedDataForAll.ShowReadOnlySpeeches
							end,
							name = function()
								local EventTableEntry = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
								if not EventTableEntry then
									return ""
								end
								local subs = {
									hidden = 0,
									total = #(EventTableEntry.Messages),
								}
								if EventTableEntry.ReadOnly then
									for s,b in pairs(EventTableEntry.ReadOnly) do
										subs.hidden = subs.hidden+1
									end
								end
								return SpeakinSpell:FormatSubs( L["<hidden> of <total> speeches are read-only / hidden"], subs )
							end,
						},
						UseMultiLine = {
							order = 24,
							type = "toggle",
							width = "full",
							name = L["Use Multi-Line Edit Boxes"],
							desc = L["Toggle showing single-line or multi-line edit boxes for speeches"],
							get = function() return SpeakinSpellSavedDataForAll.UseMultiLine end,
							set = function(_,value) SpeakinSpellSavedDataForAll.UseMultiLine = value end,
						}, --L["Show Ready-Only Speeches"]
						RPLanguage = {
							order = 36,
							type = "select",
							name = LANGUAGE,
							desc = L["Select the racial game language you want to use to announce these speeches\n\nThis option will be ignored if you set the \"Always Use Common\" option under general settings."],
							values = function()
								local values = SpeakinSpell:GetLanguageList()
								-- TODOFUTURE: add SpeakinSpell language filters like "Pirate" and treat Random as one of those
								values[ L["Random"] ] = L["Random"]
								return values
							end,
							hidden = function() 
								return (GetNumLanguages() < 2)
							end,
							get = function() 
								local EventTableEntry = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
								if not (EventTableEntry and EventTableEntry.RPLanguage) then
									--NOTE: GetDefaultLanguage("player") doesn't work during loader, or OnInitialize, or OnVariablesLoaded
									return GetDefaultLanguage("player")
								end
								return EventTableEntry.RPLanguage 
							end,
							set = function(_,value) 
								local EventTableEntry = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
								if not EventTableEntry then
									return
								end
								EventTableEntry.RPLanguage = value 
							end,
						}, --select language 
						RPLanguageRandomChance = {
							order = 37,
							type = "range",
							min = 0.01, max = 1.00, step=0.01,
							isPercent = true,
							width = "full",
							name = function()
								local subs = {
									language = SpeakinSpell:GetRacialLanguage()
								}
								return SpeakinSpell:FormatSubs( L["Random Chance to use <language>"], subs )
							end,
							desc = function()
								local subs = {
									common = GetDefaultLanguage("player"), -- could be "orcish"
									racial = SpeakinSpell:GetRacialLanguage(), --could be "thallasian" (sp?)
								}
								return SpeakinSpell:FormatSubs( L[
[[Select the random chance to use your racial/roleplay language for this event
0% will always use <common>. 100% will always use <racial>.]]
									], subs )
							end,
							get = function() 
								local EventTableEntry = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
								if not EventTableEntry
								   and EventTableEntry.RPLanguageRandomChance then
									return 0.5 -- 50/50
								end
								return EventTableEntry.RPLanguageRandomChance 
							end,
							set = function(_,value) 
								local EventTableEntry = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
								if not EventTableEntry then
									return
								end
								EventTableEntry.RPLanguageRandomChance = value 
							end,
							hidden = function() -- not selecting "random" from the RPLanguage drop-down above
								local EventTableEntry = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
								if not EventTableEntry then
									return true
								end
								return EventTableEntry.RPLanguage ~= L["Random"]
							end,
						}, --"Random chance to use language"
						
						ExpandMacros = {
							order = 40,
							type = "toggle",
							width = "full",
							name = L["Expand /ss macros as lists-only"],
							desc = L[
[[For /ss macros used in the speeches below, enable this option to import the macro event's speech list into this event's speech list when selecting a random speech.

This will more evenly distribute the random selection of speeches in nested macros, while ignoring the macro event's own separate settings for chat channels, cooldowns, etc.

This option is not recursive, so if you want nested macros to expand sub-macro calls, you must enable this option in the separate settings for the nested macro events.
]]
							],
							get = function()
								local EventTableEntry = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
								if not (EventTableEntry and EventTableEntry.ExpandMacros) then
									return SpeakinSpell.DEFAULTS.EventTableEntry.ExpandMacros
								end
								return EventTableEntry.ExpandMacros
							end,
							set = function(_,value)
								local EventTableEntry = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
								if not EventTableEntry then
									return
								end
								EventTableEntry.ExpandMacros = value
							end,
						},

						-- CreateGUI_CurrentMessagesGUI will add speech boxes here

					},
				}, -- L["What you say (Speeches)"]
			}, --end args
		}, --end EditGroup
	}, --end args
} --end CurrentMessagesGUI



-- create message boxes
function SpeakinSpell:CreateGUI_CurrentMessagesGUI()
	-- add SpeakinSpell.MAX.MESSAGES_PER_SPELL random speech input boxes
	local args = SpeakinSpell.OptionsGUI.args.CurrentMessagesGUI.args.EditGroup.args.SpeechListGroup.args
	for i=1,SpeakinSpell.MAX.MESSAGES_PER_SPELL,1 do
		local subs = {
			number = i,
		}
		args["SpellMessage"..i] = {
			order = i + 100,
			width = "full",
			type = "group",
			name = SpeakinSpell:FormatSubs( L["Random Speech <number>"], subs), -- "Random Speech %d"
			hidden = function() return not SpeakinSpell:CurrentMessagesGUI_ShowSpeechBox(i) end,
			args = {
				EditMulti = {
					hidden = function() 
						return SpeakinSpell:CurrentMessagesGUI_IsReadOnlySpeech(i) or (not SpeakinSpellSavedDataForAll.UseMultiLine)
					end,
					order = 1,
					type = "input",
					width = "full",
					multiline = true,
					name = L["Edit"],
					desc = L[
[[Write an announcement for this event.

Duplicates of speeches listed above will not be accepted]]
					],
					get = function() return  SpeakinSpell:CurrentMessagesGUI_OnMessage("GET",i, nil,   SpeakinSpellSavedDataForAll.UseMultiLine) end,
					set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnMessage("SET",i, value, SpeakinSpellSavedDataForAll.UseMultiLine) end,
				}, --L["Random Speech <number>"] text box (multiline)
				EditSingle = {
					hidden = function() 
						return SpeakinSpell:CurrentMessagesGUI_IsReadOnlySpeech(i) or (SpeakinSpellSavedDataForAll.UseMultiLine)
					end,
					order = 1,
					type = "input",
					width = "full",
					multiline = false,
					name = L["Edit"],
					desc = L[
[[Write an announcement for this event.

Duplicates of speeches listed above will not be accepted]]
					],
					get = function() return  SpeakinSpell:CurrentMessagesGUI_OnMessage("GET",i, nil,   SpeakinSpellSavedDataForAll.UseMultiLine) end,
					set = function(_, value) SpeakinSpell:CurrentMessagesGUI_OnMessage("SET",i, value, SpeakinSpellSavedDataForAll.UseMultiLine) end,
				}, --L["Random Speech <number>"] text box (single-line)
				Delete = {
					order = 2,
					type = "execute",
					name = DELETE,
					desc = L["Delete this speech"],
					func = function() SpeakinSpell:CurrentMessagesGUI_OnDeleteSpeech(i) end,
					hidden = function() return not SpeakinSpell:CurrentMessagesGUI_ShowDeleteSpeech(i) end,
				}, --L["Delete this speech"]
				ReadOnly = {
					order = 4,
					type = "toggle",
					name = L["Read-Only"],
					desc = L["Toggle showing edit controls or a compressed display"],
					get = function(_,ReadOnly) return SpeakinSpell:CurrentMessagesGUI_IsReadOnlySpeech(i,ReadOnly) end,
					set = function(_,ReadOnly) SpeakinSpell:CurrentMessagesGUI_ToggleReadOnly(i,ReadOnly) end,
					hidden = function() return not SpeakinSpell:CurrentMessagesGUI_ShowReadyOnlySpeech(i) end,
				},
				Text = {
					order = 3,
					type = "description",
					width = "full",
					name = function() return SpeakinSpell:CurrentMessagesGUI_OnMessage("GET",i,nil,true) end,
					hidden = function() return not SpeakinSpell:CurrentMessagesGUI_IsReadOnlySpeech(i) end,
				},
				GotoMacroGap = {
					type = "description",
					width = "full",
					name = "",
					order = 10,
					hidden = function()
						local msg = SpeakinSpell:CurrentMessagesGUI_OnMessage("GET",i,nil,true)
						if not msg then 
							return true 
						end
						local ete = SpeakinSpell:GetETEForSSMacro(msg)
						if not ete then
							return true
						end
						return false
					end,
				},
				GotoMacro = {
					order = 11,
					name = L["Edit Macro Event"],
					hidden = function()
						local msg = SpeakinSpell:CurrentMessagesGUI_OnMessage("GET",i,nil,true)
						if not msg then 
							return true 
						end
						local ete = SpeakinSpell:GetETEForSSMacro(msg)
						if not ete then
							return true
						end
						return false
					end,
					desc = function()
						local msg = SpeakinSpell:CurrentMessagesGUI_OnMessage("GET",i,nil,true)
						return L["Open the event settings to edit speeches and other options for When I Type: "] .. tostring(msg)
					end,
					type = "execute",
					func = function()
						local msg = SpeakinSpell:CurrentMessagesGUI_OnMessage("GET",i,nil,true)
						if not msg then 
							return
						end
						local ete = SpeakinSpell:GetETEForSSMacro(msg)
						if not ete then
							return
						end
						-- set the current selection
						-- NOTE: it doesn't have to match the filter, and we don't have to do anything to force a refresh
						-- TODOLATER: this has a defect whereby the selected event is populated throughout the entire window, however...
						--		the drop-down list does not show it as the selection, it's just blank
						--		clicking the drop-down list shows a list of matching search results
						--		this forced selection doesn't have to be one of them to otherwise load completely/correctly in the window
						--		it's just kind of odd minor cosmetic defect with the dropdown list to select an event
						--		and the search options potentially filtering out this macro event
						--		even though the edit group fully shows and edits the macro flawlessly otherwise
						SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey = ete.key
					end,
				},
				ExpandMacro = {
					order = 12,
					type = "execute",
					name = L["Import Macro's List"],
					desc = L["Copy the speeches from this macro into the current event, replacing the macro call here with the list of speeches from that macro."],
					hidden = function()
						local msg = SpeakinSpell:CurrentMessagesGUI_OnMessage("GET",i,nil,true)
						if not msg then 
							return true 
						end
						local ete = SpeakinSpell:GetETEForSSMacro(msg)
						if not ete then
							return true
						end
						return false
					end,
					func = function()
						local ete = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
						if not ete then 
							return
						end
						-- replace the macro call with the macro's speech list
						ete.Messages = SpeakinSpell:ExpandOneSSMacro( ete.Messages, i )
					end,
				},
			},
		}
	end
end



-------------------------------------------------------------------------------
-- OPTIONS GUI FUNCTIONS - MESSAGE SETTINGS
-------------------------------------------------------------------------------


function SpeakinSpell:CurrentMessagesGUI_IsReadOnlySpeech( index )
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		return false
	end
	
	local msg = EventTableEntry.Messages[index]
	if not msg then
		return false
	end
	
	if not EventTableEntry.ReadOnly then
		return false
	end

	if EventTableEntry.ReadOnly[ msg ] then
		return true
	else
		return false
	end
end


function SpeakinSpell:CurrentMessagesGUI_ToggleReadOnly( index, ReadOnly )
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		return
	end
	
	local msg = EventTableEntry.Messages[index]
	if not msg then
		return
	end
	
	if not EventTableEntry.ReadOnly then
		EventTableEntry.ReadOnly = {}
	end

	if ReadOnly then
		EventTableEntry.ReadOnly[ msg ] = true
	else
		EventTableEntry.ReadOnly[ msg ] = nil
	end
end


function SpeakinSpell:CurrentMessageGUI_DeleteAllSpeeches()
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		return
	end
	EventTableEntry.Messages = {}
	EventTableEntry.ReadOnly = {}
end


function SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
	local eventkey = self.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey
	if eventkey then
		return self:GetActiveEventTable()[eventkey]
	else
		return nil
	end
end


function SpeakinSpell:CurrentMessagesGUI_ValidateSelectedEvent()
	-- get the selected EventTableEntry
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if EventTableEntry then
		if self:MatchesFilter(EventTableEntry.DetectedEvent,true) then
			-- the current selection is valid, so keep it
			return
		end
		--else, the current selection did not match the filter, so select a default
	end
	
	-- select the first thing in the list, if possible
	for key,EventTableEntry in pairs( self:GetActiveEventTable() ) do
		if self:MatchesFilter(EventTableEntry.DetectedEvent,true) then
			-- the current selection is valid, so keep it
			self.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey = key
			return
		end
	end
	
	-- our spell list is empty or nothing matches the filter
	self.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey = nil
end



function SpeakinSpell:CurrentMessagesGUI_OnClickDelete()
	local funcname = "CurrentMessagesGUI_OnClickDelete"

	-- get the selected EventTableEntry
	local eventkey = self.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey
	if not eventkey then
		self:ErrorMsg(funcname, "no event selected")
		return
	end
	
	-- update GUI state
	self.OptionsGUI.args.CurrentMessagesGUI.args.SelectGroup.args.EventSelect.values[eventkey] = nil
	self.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey = nil
	
	-- delete the current selection from the SavedData table
	self:DeleteSpell(eventkey)
end



function SpeakinSpell:CurrentMessagesGUI_OnToggleShowMoreThanAHundred(getset,value)
	if "GET" == getset then
		-- rebuild the list to match the new filter if its out of date
		self:CurrentMessagesGUI_RebuildSpellList()
		return SpeakinSpellSavedData.ShowMoreThanAHundred
	else -- "SET"
		-- if the filter is changing, then rebuild the spell/event list
		self:SetFilterShowMoreThanAHundred(value)
		-- rebuild the list to match the new filter
		self:CurrentMessagesGUI_RebuildSpellList()
	end
end


function SpeakinSpell:CurrentMessagesGUI_OnClickGotoCreate()
	InterfaceOptionsFrame_OpenToCategory(L["Create New..."])
end


function SpeakinSpell:CurrentMessagesGUI_OnEventTypeFilterSelect(getset, value)
	if "GET" == getset then
		-- rebuild the list to match the new filter if its out of date
		self:CurrentMessagesGUI_RebuildSpellList()
		return SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTypeFilter
	else -- "SET"
		-- if the filter is changing, then rebuild the spell/event list
		self:SetFilter(value,nil)
		-- rebuild the list to match the new filter
		self:CurrentMessagesGUI_RebuildSpellList()
	end
	-- NOTE: the current selection will be repaired to match the new filter in _ValidateSelectedEvent
	--		as a side effect when the GUI framework automatically tries to get the new value of 
	--		the rest of the controls on the page, including the selected event
end


function SpeakinSpell:CurrentMessagesGUI_OnGetSetEventTextFilter(getset, value)
	if "GET" == getset then
		-- rebuild the list to match the new filter if its out of date
		self:CurrentMessagesGUI_RebuildSpellList()
		return SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTextFilter
	else -- "SET"
		-- if the filter is changing, then rebuild the spell/event list
		self:SetFilter(nil,value)
		-- rebuild the list to match the new filter
		self:CurrentMessagesGUI_RebuildSpellList()
	end
	-- NOTE: the current selection will be repaired to match the new filter in _ValidateSelectedEvent
	--		as a side effect when the GUI framework automatically tries to get the new value of 
	--		the rest of the controls on the page, including the selected event
end

function SpeakinSpell:CurrentMessagesGUI_OnEventSelect(getset, value)
	if "GET" == getset then
		-- create a side-effect to update the shown/hidden state of all options GUI controls
		self:CurrentMessagesGUI_RebuildSpellList()
		-- return the current spell selection
		return self.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey
	else -- "SET"
		-- update the current selection
		self.RuntimeData.OptionsGUIStates.MessageSettings.SelectedEventKey = value
	end
end


function SpeakinSpell:CurrentMessagesGUI_OnChannelSelect(getset, scenario, value)
	local funcname = "CurrentMessagesGUI_OnChannelSelect"
		
	-- get the selected EventTableEntry
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		self:ErrorMsg(funcname, "no event selected")
		return
	end

	if "GET" == getset then
		--self:DebugMsg(funcname,"GET "..scenario..":"..tostring(EventTableEntry.Channels[scenario]))
		if EventTableEntry.Channels[scenario] then
			return L[EventTableEntry.Channels[scenario]] -- [buildlocales.py No Warning] Locale keys for channel names are copied from SpeakinSpell.lua
		else
			return L["Silent"]
		end
	else --"SET"
		-- store the new channel selection
		if value == L["Silent"] then
			EventTableEntry.Channels[scenario] = nil
		else
			-- create a reverse lookup table to un-localize channel names
			-- so we can return a channel name that is compatible with SendChatMessage()
			EventTableEntry.Channels[scenario] = self.ChannelTable[value]
		end
		--self:DebugMsg(funcname,"set "..scenario..":"..tostring(EventTableEntry.Channels[scenario]))
	end
end



function SpeakinSpell:CurrentMessagesGUI_OnWhisperTarget(getset, value)
	-- make sure we have a valid spell selection
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		self:ErrorMsg( "CurrentMessagesGUI_OnWhisperTarget", "no event selected" )
		return false
	end
	
	if "GET" == getset then
		return EventTableEntry.WhisperTarget
	else
		EventTableEntry.WhisperTarget = value
	end
end


function SpeakinSpell:CurrentMessagesGUI_OnMessage(getset, index, value, UseMultiLine)
	local funcname = "CurrentMessagesGUI_OnMessage"
	
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		self:ErrorMsg("CurrentMessagesGUI_OnMessage", "no event selected")
		return ""
	end
	
	if "GET" == getset then
		local msg = EventTableEntry.Messages[index]
		if not msg then
			msg = ""
		end
		if UseMultiLine then
			msg = string.replace( msg, L["<newline>"], "\n" )
		else
			msg = string.replace( msg, "\n", L["<newline>"] )
		end
		return msg
	else -- "SET"
		-- make sure we have a message table for the currently selected spell
		if not EventTableEntry.Messages then
			EventTableEntry.Messages = {}
		end
		
		-- NOTE: always store line breaks instead of <newline>
		EventTableEntry.Messages[ index ] = string.replace( value, L["<newline>"], "\n" )

		-- remove holes and duplicates from the message table
		EventTableEntry.Messages = self:StringArray_Compress( EventTableEntry.Messages )
		
		return EventTableEntry.Messages[index] -- only returning something for symmetry
	end
end



function SpeakinSpell:CurrentMessagesGUI_OnDeleteSpeech(index)
	local funcname = "CurrentMessagesGUI_OnDeleteSpeech"
	
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		self:ErrorMsg(funcname, "no event selected")
		return
	end
	
	local Messages = EventTableEntry.Messages -- create reference for shortcut notation
	
	-- delete the item
	Messages[index] = nil
	
	-- fill holes in the array
	EventTableEntry.Messages = self:StringArray_Compress( Messages )
end

function SpeakinSpell:CurrentMessagesGUI_ShowDeleteSpeech(index)
	local funcname = "CurrentMessagesGUI_ShowDeleteSpeech"
	
	if self:CurrentMessagesGUI_IsReadOnlySpeech(index) then
		return false
	end
	
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		return false
	end

	local msg = EventTableEntry.Messages[index]
	return ( (msg ~= nil) and (msg ~= "") )
end


function SpeakinSpell:CurrentMessagesGUI_ShowReadyOnlySpeech( index )
	local funcname = "CurrentMessagesGUI_ShowReadyOnlySpeech"
	
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		return false
	end

	local msg = EventTableEntry.Messages[index]
	return ( (msg ~= nil) and (msg ~= "") )
end


function SpeakinSpell:CurrentMessagesGUI_OnSpellDisable(getset, value)
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		self:ErrorMsg("CurrentMessagesGUI_OnSpellDisable", "no event selected")
		return
	end

	if "GET" == getset then
		return EventTableEntry.DisableAnnouncements
	else -- "SET"
		EventTableEntry.DisableAnnouncements = value
	end
end


function SpeakinSpell:CurrentMessagesGUI_OnFrequencySelect(getset, value)
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		self:ErrorMsg("CurrentMessagesGUI_OnFrequencySelect", "no event selected")
		return
	end
	
	if "GET" == getset then	
		return EventTableEntry.Frequency
	else --"SET"
		EventTableEntry.Frequency = value
	end
end


function SpeakinSpell:CurrentMessagesGUI_OnCooldownSlider(getset, value)
	local funcname = "CurrentMessagesGUI_OnCooldownSlider"

	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		self:ErrorMsg(funcname, "no event selected")
		return
	end
	
	if "GET" == getset then	
		return EventTableEntry.Cooldown
	else --"SET"
		EventTableEntry.Cooldown = value
	end
end


function SpeakinSpell:CurrentMessagesGUI_OnOncePerCombatToggle(getset, value)
	local funcname = "CurrentMessagesGUI_OnOncePerCombatToggle"

	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		self:ErrorMsg(funcname, "no event selected")
		return
	end
	
	if "GET" == getset then	
		return EventTableEntry.OncePerCombat
	else --"SET"
		EventTableEntry.OncePerCombat = value
	end
end


function SpeakinSpell:CurrentMessagesGUI_OnOncePerTargetToggle(getset, value)
	local funcname = "CurrentMessagesGUI_OnOncePerTargetToggle"

	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		self:ErrorMsg(funcname, "no event selected")
		return
	end
	
	if "GET" == getset then	
		return EventTableEntry.OncePerTarget
	else --"SET"
		EventTableEntry.OncePerTarget = value
	end
end


function SpeakinSpell:CurrentMessagesGUI_ShowSpeechBox(i)
	-- [X] Show Speeches
--	if not SpeakinSpell.RuntimeData.OptionsGUIStates.MessageSettings.ShowSpeechesGroup then
--		return false
--	end
	
	-- must have an EventTableEntry to continue
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	if not EventTableEntry then
		return false
	end
	
	-- [X] Show Read-Only Speeches
	if not SpeakinSpellSavedDataForAll.ShowReadOnlySpeeches then
		local msg = EventTableEntry.Messages[i]
		if msg and (msg ~= "") then
			if EventTableEntry.ReadOnly[msg] then
				return false
			end
		end
	end
	
	-- determine how many Spell Message N input boxes are shown
	-- typically we'll show at least 1 speech message input box if we have a spell selected
	-- we want to show 1 more than the number of speeches currently configured
	-- unless we don't have a spell selected or we're in EnterNewSpell mode
	local NumSpellMessageInputsShown = 1 + #(EventTableEntry.Messages)
	return (i <= NumSpellMessageInputsShown)
end


function SpeakinSpell:CurrentMessagesGUI_ShowSelectedEventControls()
	local EventTableEntry = self:CurrentMessagesGUI_GetSelectedEventObject()
	return (EventTableEntry ~= nil)
end


function SpeakinSpell:CurrentMessagesGUI_RebuildSpellList()
	local funcname = "CurrentMessagesGUI_RebuildSpellList"

	local values = self.OptionsGUI.args.CurrentMessagesGUI.args.SelectGroup.args.EventSelect.values
	local OptionsGUIState = self.RuntimeData.OptionsGUIStates.MessageSettings
	local EventTable = self:GetActiveEventTable()
	if not EventTable then
		self:DebugMsg(funcname, "EventTable is nil")
	end
	
	local MatchesFilterFunc = function(key) 
		if not key then
			self:DebugMsg(funcname, "key is nil")
			return false
		end
		local ete = EventTable[key]
		if not ete then
			return false
		end
		local de = ete.DetectedEvent
		return SpeakinSpell:MatchesFilter( de, true )
	end
	
	local GetDisplayNameFunc = function(key)
		local de = EventTable[key].DetectedEvent
		local DisplayNameFormat = {
			typefilter = SpeakinSpell.RuntimeData.OptionsGUIStates.SelectedEventTypeFilter,
			ShowAllRanks = false,
			HighlightFilterText = true,
			BaseColor = "|r",
		}
		return self:FormatDisplayName( de, DisplayNameFormat )
	end
	
	self:RebuildSpellList( values, OptionsGUIState, EventTable, MatchesFilterFunc, GetDisplayNameFunc )
end




function SpeakinSpell:CurrentMessagesGUI_GetSelectedDisplayNameForEditLabel()
	-- include a reminder of the selected event
	local ete = SpeakinSpell:CurrentMessagesGUI_GetSelectedEventObject()
	local label = ""
	if ete and ete.DetectedEvent then
		local DisplayNameFormat = {
			ShowAllRanks = true,
			HighlightFilterText = true,
			BaseColor = SpeakinSpellSavedData.Colors.SelectedItem,
		}
		label = SpeakinSpell:FormatDisplayName( ete.DetectedEvent, DisplayNameFormat ).."|r"
	end
	return label
end
