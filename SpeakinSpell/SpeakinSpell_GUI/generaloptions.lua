-- Author      : RisM
-- Create Date : 9/21/2009 3:06:34 AM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)
local BIGREDBUTTON = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell_BIGREDBUTTON", false)

SpeakinSpell:PrintLoading("gui/generaloptions.lua")


-------------------------------------------------------------------------------
-- GUI LAYOUT - GENERAL SETTINGS
-------------------------------------------------------------------------------


SpeakinSpell.OptionsGUI.args.General = {
	order = 1,
	type = "group",
	name = L["General Settings"],
	desc = L["General Settings for SpeakinSpell"],
	args = {
		-----------------------
		Caption = {
			order = 1,
			type = "header",
			--name = L["General Settings"],
			name = function()
				SpeakinSpell:SetLastPageViewed( "General", "SpeakinSpell" )
				return L["General Settings"]
			end,
		},
		
		-----------------------
		InfoGroup = {
			order = 2,
			type = "group",
			guiInline = true,
			name = L["Information"],
			args = {
				Version = {
					order = 2,
					type = "description",
					name = function()
						--Locale note: normally string concatenation like this is frowned on
						--		but in these cases, I think something equivalent to "Version".." "..N will be universal
						--		so it doesn't seem worth the added complexity of using FormatSubs here
						return	GAME_VERSION_LABEL.." "..SpeakinSpell.CURRENT_VERSION.."\n"..
								L["Data format compatible with v >="]..SpeakinSpell.DATA_VERSION
					end,
				},
				Memory = {
					order = 3,
					type = "description",
					name = function() return SpeakinSpell:GetAddonMemoryUsedString() end,
				},
--				URLs = {
--					order = 4,
--					type = "description",
--					name = SpeakinSpell.ALL_URLs,
--				},
				Help = {
					order = 5,
					type = "execute",
					name = HELP_LABEL,
					desc = L["Open the User's Manual"],
					func = function() SpeakinSpell:ShowHelp() end,
				},
			},
		},

		-----------------------
		GeneralGroup = {
			order = 3,
			type = "group",
			guiInline = true,
			name = L["General Settings"],
			args = {
				EnableAllMessagesToggle = {
					order = 11,
					type = "toggle",
					width = "full",
					name = L["Enable Automatic SpeakinSpell Event Announcements"],
					desc = function()
						-- NOTE: purposefully using the Minimap colors out of scope here
						local subs = {
							on = (SpeakinSpell.Colors.Minimap.ON)..L["ON|r"],
							off = (SpeakinSpell.Colors.Minimap.OFF)..L["OFF|r"],
						}
						local tooltip = ""
						if SpeakinSpellSavedData.EnableAllMessages then
							tooltip = L[
[[SpeakinSpell is <on>

Disable this option to turn SpeakinSpell <off> and silence all SpeakinSpell speeches

/ss macro events are always enabled if you manually type it or click a button for it.
]]
]
						else
							tooltip = L[
[[SpeakinSpell is <off>

Enable this option to turn SpeakinSpell <on> and resume announcing SpeakinSpell Speech Events

/ss macro events are always enabled if you manually type it or click a button for it.
]]
]
						end
						return SpeakinSpell:FormatSubs( tooltip, subs )
					end,
					get = function() return  SpeakinSpell:GeneralOptions_OnEnableAllMessagesToggle("GET",nil) end,
					set = function(_, value) SpeakinSpell:GeneralOptions_OnEnableAllMessagesToggle("SET",value) end,
				},
				EnableMinimapIcon = {
					order = 12,
					type = "toggle",
					name = L["Show Minimap Button"],
					desc = L["Show the SpeakinSpell minimap button"],
					get = function(info) return SpeakinSpellSavedData.ShowMinimapButton end,
					set = function(info, value) SpeakinSpell:MinimapButton_Show(value) end,
				},
				ShowVersionAtLogin = {
					order = 13,
					width = "full",
					type = "toggle",
					name = L["Show Welcome Message"],
					desc = L["Show the version number in chat when loading SpeakinSpell during login"],
					get = function(info) return SpeakinSpellSavedData.ShowVersionAtLogin end,
					set = function(info, value) SpeakinSpellSavedData.ShowVersionAtLogin = value end,
				},
				UseSharedSpeeches = {
					order = 14,
					width = "full",
					type = "toggle",
					name = L["Share Speeches for All Characters"],
					desc = L[
[[OFF = All of your characters will use separate lists of event triggers and random speeches, which you can copy from one to the other using "/ss import"

ON = All of your characters will share the same event triggers and speeches

Toggling this option will merge or split your settings between all of your characters]]
					],
					get = function(info) return SpeakinSpellSavedDataForAll.AllToonsShareSpeeches end,
					set = function(_,value)
						if SpeakinSpellSavedDataForAll.AllToonsShareSpeeches == value then
							return --unchanged
						end
						-- these functions set SpeakinSpellSavedDataForAll.AllToonsShareSpeeches when ready
						if value then -- merge
							SpeakinSpell:Import_AllAltsToSharedEventTable() -- templates.lua
						else -- split
							SpeakinSpell:Split_SharedEventTableToAllAlts() -- templates.lua
						end
					end,
				},
				AlwaysUseCommon = {
					order = 15,
					type = "toggle",
					name = function()
						local subs = {
							language = GetDefaultLanguage("player"),
						}
						return SpeakinSpell:FormatSubs( L["Always use <language>"], subs )
					end,
					desc = function()
						local subs = {
							language = SpeakinSpell:GetRacialLanguage(),
						}
						return SpeakinSpell:FormatSubs( L["Don't ever use your racial/roleplay language, <language>"], subs)
					end,
					get = function() return SpeakinSpellSavedData.AlwaysUseCommon end,
					set = function(_,value) SpeakinSpellSavedData.AlwaysUseCommon = value end,
					hidden = function() return GetNumLanguages() < 2 end,
				},
				GlobalCooldown = {
					order = 16,
					type = "range",
					width = "full",
					name = L["Global Cooldown"],
					desc = L["This option will silence SpeakinSpell for this many seconds after any event announcement."],
					min =0, max = 600, step=1, -- allowing for 0 seconds up to 10 minutes
					get = function() return  SpeakinSpellSavedData.GlobalCooldown end,
					set = function(_, value) SpeakinSpellSavedData.GlobalCooldown = value end,
				},
				EditSpeeches = {
					order = 17,
					type = "execute",
					name = L["Edit Speeches"],
					func = function() SpeakinSpell:ShowMessageOptions() end,
				},
			},
		},
		
		-----------------------
		DiagnosticsGroup = {
			order = 20,
			type = "group",
			name = L["Diagnostics"],
			guiInline = true,
			args = {
				ShowSpellEventsToggle = {
					order = 21,
					type = "toggle",
					width = "full",
					name = L["Show Setup Guides"],
					desc = L[
[[Enable this option to make SpeakinSpell show you (and only you) all of your own spell casting events and other events that can be announced.

This includes any spell, ability, item, /ss macro things, or automatically obtained effect (e.g. Trinkets or Talents) that you cast or use.]]
					],
					get = function() return SpeakinSpellSavedData.ShowSetupGuides end,
					set = function(_, value) SpeakinSpellSavedData.ShowSetupGuides = value end,
				},
				ShowWhyNotToggle = {
					order = 22,
					type = "toggle",
					width = "full",
					name = L["Show Why Event Triggers Do Not Fire"],
					desc = L["If you have an event trigger that does not appear to be firing, this option will tell you which setting silenced the announcement of that event, for example because it's on cooldown, or the random chance failed."],
					get = function() return SpeakinSpellSavedData.ShowWhyNot end,
					set = function(_, value) SpeakinSpellSavedData.ShowWhyNot = value end,
				},
				ShowDebugMessagesToggle = {
					order = 23,
					type = "toggle",
					width = "full",
					name = L["Show Debugging Messages (verbose)"],
					desc = L["Enable this option to show an overwhelming amount of information"],
					get = function() return  SpeakinSpell:GeneralOptions_OnShowDebugMessagesToggle("GET",nil) end,
					set = function(_, value) SpeakinSpell:GeneralOptions_OnShowDebugMessagesToggle("SET",value) end,
				},
			},
		},
		
		-----------------------
		ScrollGap = {
			order = 100,
			type = "description",
			name = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
		},
		BigRedButton = {
			order = 101,
			type = "execute",
			width = "full",
			name = L["DO NOT PRESS THIS BUTTON"],
			desc = L["Under no circumstances should you ever, EVER push this button.\n\nI'm warning you.\n\nDon't do it.\n\nSeriously, you're already hovering over it for too long, and that's dangerous.\n\nMove your mouse before it's too late!"],
			func = function() SpeakinSpell:GeneralOptions_OnClickBigRedButton() end,
		},
	}, --end args
}

-------------------------------------------------------------------------------
-- OPTIONS GUI FUNCTIONS - GENERAL SETTINGS
-------------------------------------------------------------------------------


function SpeakinSpell:GeneralOptions_OnShowDebugMessagesToggle(getset, value)
	if "GET" == getset then
		return SpeakinSpellSavedData.ShowDebugMessages
	else -- "SET"
		SpeakinSpellSavedData.ShowDebugMessages = value
	end
end


function SpeakinSpell:GeneralOptions_OnEnableAllMessagesToggle(getset, value)
	if "GET" == getset then
		return SpeakinSpellSavedData.EnableAllMessages
	else -- "SET"
		SpeakinSpellSavedData.EnableAllMessages = value
		-- the minimap icon reflects on/off status, so make sure it is refreshed when toggling this checkbox
		self:MinimapButton_Refresh()
	end
end


function SpeakinSpell:GeneralOptions_OnClickBigRedButton()
	-- check range of BigRedButtonIndex
	if not self.RuntimeData.BigRedButtonIndex then
		self.RuntimeData.BigRedButtonIndex = 1
	end
	if self.RuntimeData.BigRedButtonIndex > #(BIGREDBUTTON.List) then
		self.RuntimeData.BigRedButtonIndex = 1
	end
	
	-- process substitution variables
	local de = {
		-- event descriptors
		name = "Big Red Button",
		rank = "Silly",
		-- event-specific data for substitutions
		target = self:GetDefaultTarget(false),
		caster = UnitName("player"),
		type = "MACRO",
		linenumber = tostring(self.RuntimeData.BigRedButtonIndex),
	}
	local msg = BIGREDBUTTON.List[ self.RuntimeData.BigRedButtonIndex ]
	
	-- print the next message in the looping array
	-- NOTE: some empty items are inserted on purpose to make a click non-functional
	--	SayOneLine aborts on empty lines
	self:SayMultiLineWithSubs( msg, "MYSTERIOUS VOICE", nil, nil, de )
	
	-- prepare for the next pass
	self.RuntimeData.BigRedButtonIndex = self.RuntimeData.BigRedButtonIndex + 1
end
