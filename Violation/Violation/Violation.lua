-----------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("Violation")

local AceOO = AceLibrary("AceOO-2.0")
local dew = AceLibrary("Dewdrop-2.0")
local icon = LibStub("LibDBIcon-1.0", true)

local classColors = { WTF = "|cffa0a0a0" }
local rgbColors = { WTF = { 0.8, 0.8, 0.8 } }
for k, v in pairs(RAID_CLASS_COLORS) do
	classColors[k] = "|cff" .. string.format("%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
	rgbColors[k] = { v.r, v.g, v.b }
end

local classes = setmetatable({}, {__index =
	function(self, key)
		local class = select(2, UnitClass(key))
		if class then
			self[key] = class
			return self[key]
		end
	end
})

local coloredNames = setmetatable({}, {__index =
	function(self, key)
		local class = classes[key]
		if not class or not classColors[class] then
			return classColors.WTF .. key .. "|r"
		end
		self[key] = classColors[class]  .. key .. "|r"
		return self[key]
	end
})

local RGB = setmetatable({}, {__index =
	function(self, key)
		local class = classes[key]
		if not class or not rgbColors[class] then
			return rgbColors.WTF
		end
		self[key] = rgbColors[class]
		return self[key]
	end
})

local CTL = ChatThrottleLib
if type(CTL) ~= "table" or type(CTL.version) ~= "number" or CTL.version < 13 then
	error("Violation requires ChatThrottleLib version 13 or higher.")
end

local SM = LibStub("LibSharedMedia-3.0")

local db = nil

local _G = getfenv(0)
local table_insert = table.insert
local format = string.format

local playerName = UnitName("player")
local percentString = "%.1f%%"

local moduleVersion = 6

local runningModules = {}
local roster = {}
local characterPets = {}
local craftedPetGUIDs = {}

local red = "Interface\\AddOns\\Violation\\icons\\red"
local blue = "Interface\\AddOns\\Violation\\icons\\blue"
local grey = "Interface\\AddOns\\Violation\\icons\\grey"

local grouped = nil -- grouped status

-----------------------------------------------------------------------
-- Local heap and utility functions
-----------------------------------------------------------------------

local new, del
do
	local cache = setmetatable({},{__mode="k"})
	function new(...)
		local t = next(cache)
		if t then
			cache[t] = nil
			for i = 1, select("#", ...) do
				table_insert(t, (select(i, ...)))
			end
			return t
		else
			return {...}
		end
	end
	function del(t)
		if type(t) == "table" then
			for k, v in pairs(t) do
				if type(v) == "table" then
					v = del(v)
				end
				t[k] = nil
			end
			cache[t] = true
		end
		return nil
	end
end

local function Colorize(text, r, g, b)
	return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, text)
end

-----------------------------------------------------------------------
-- Addon declaration
-----------------------------------------------------------------------
Violation = AceLibrary("AceAddon-2.0"):new(
	"AceEvent-2.0",
	"AceDB-2.0",
	"AceConsole-2.0",
	"AceModuleCore-2.0"
)
local Violation = Violation

Violation:SetModuleMixins("AceEvent-2.0")

-----------------------------------------------------------------------
-- Options
-----------------------------------------------------------------------

local function get(key)
	return db[key]
end
local function set(key, val)
	db[key] = val
end

local reportToMenu = {
	whisper = {
		type = "group",
		name = WHISPER,
		desc = L["Whisper the data to someone."],
		pass = true,
		args = {
			player = {
				type = "text",
				name = PLAYER,
				desc = L["Whisper the data to the specified player."],
				usage = L["<playerName>"],
				order = 1,
			},
			spacer = {
				type = "header",
				name = " ",
				order = 50,
				hidden = true,
			},
		},
		order = 1,
	},
	say = {
		type = "execute",
		name = SAY,
		desc = L["Print to say."],
		passValue = "SAY",
		order = 2,
	},
	guild = {
		type = "execute",
		name = GUILD_CHAT,
		desc = L["Print to the guild channel."],
		passValue = "GUILD",
		order = 2,
		hidden = function() return not IsInGuild() end,
	},
	officer = {
		type = "execute",
		name = OFFICER_CHAT,
		desc = L["Print to the officer channel."],
		passValue = "OFFICER",
		order = 2,
		hidden = function() return not CanGuildInvite() end, -- Can't be arsed to check rank flags :P
	},
	party = {
		type = "execute",
		name = PARTY,
		desc = L["Print to the party channel."],
		passValue = "PARTY",
		order = 2,
		hidden = function() return GetNumPartyMembers() == 0 end,
	},
	raid = {
		type = "execute",
		name = RAID,
		desc = L["Print to the raid channel."],
		passValue = "RAID",
		order = 2,
		hidden = function() return GetNumRaidMembers() == 0 end,
	},
	cspacer = { -- space before the custom channels
		type = "header",
		name = " ",
		order = 50,
	},
	spacer = { -- spacer after the custom channels
		type = "header",
		name = " ",
		order = 90,
	},
	limit = {
		type = "range",
		name = L["Lines"],
		desc = L["Maximum number of lines to print."],
		max = 40,
		min = 1,
		step = 1,
		get = get,
		set = set,
		passValue = "maxPrintLines",
		order = 91,
	},
}

local options = {
	type = "group",
	handler = Violation,
	args = {
		track = {
			type = "group",
			name = L["Track"],
			desc = L["What data types to track."],
			disabled = "~IsActive",
			args = {}, -- Auto-populated by module toggles.
			order = 101,
			pass = true,
			get = function(mod)
				return db.enabledModules[mod]
			end,
			set = "ToggleModule",
		},
		text = {
			type = "group",
			name = L["Text"],
			desc = L["What data to show on the panel, if available."],
			args = {}, -- Auto-populated by module toggles.
			order = 102,
			pass = true,
			get = function(mod)
				return db.textModules[mod]
			end,
			set = function(mod, val)
				db.textModules[mod] = val
				Violation:UpdateText()
			end,
		},
		colors = {
			type = "group",
			name = L["Colors"],
			desc = L["Assign colors to the different data types."],
			pass = true,
			get = function(mod)
				local tuple = db.colors[mod] or {r=1,g=1,b=1}
				return tuple.r or 1, tuple.g or 1, tuple.b or 1
			end,
			set = function(mod, r, g, b)
				local tuple = db.colors[mod]
				tuple.r = r
				tuple.g = g
				tuple.b = b
				Violation:ScheduleEvent("ColorUpdate", Violation.UpdateDisplay, 5, Violation)
				Violation:UpdateWindows(true)
			end,
			args = {}, -- Auto-populated by module toggles.
			order = 103,
		},
		tooltip = {
			type = "group",
			name = L["Tooltip"],
			desc = L["What data to show in the tooltip."],
			args = {},
			order = 104,
			pass = true,
			get = function(mod)
				return db.tooltipModules[mod]
			end,
			set = function(mod, val)
				db.tooltipModules[mod] = val
				Violation:UpdateTooltip()
			end
		},
		windowspacer = {
			type = "header",
			name = " ",
			order = 110,
		},
		windows = {
			type = "group",
			name = L["Windows"],
			desc = L["Window options."],
			args = {
				spacer1 = {
					type = "header",
					text = " ",
					order = 110,
				},
				newwindow = {
					type = "execute",
					name = L["Create new window"],
					desc = L["Creates a new bar window display."],
					func = function()
						db.windows.count = db.windows.count + 1
						Violation:SetupWindows()
					end,
					disabled = function() return not next(runningModules) end,
					order = 111,
				},
				show = {
					type = "toggle",
					name = L["Show windows"],
					desc = L["Toggles all windows on or off."],
					set = "ToggleWindows",
					get = function() return db.showWindows end,
					order = 112,
				},
				showgrouped = {
					type = "toggle",
					name = L["Show in group"],
					desc = L["Automatically show windows when you are grouped."],
					set = function(v)
						db.showGrouped = v
						if v then
							if grouped then
								Violation:ToggleWindows(true)
							else
								Violation:ToggleWindows(false)
							end
						else
							Violation:ToggleWindows(true)
						end
					end,
					get = function() return db.showGrouped end,
					order = 113,
				},
				spacer2 = {
					type = "header",
					text = " ",
					order = 114,
				},
				windowdefaulttexture = {
					type = "text",
					name = L["Default texture"],
					desc = L["Set the default bar texture for windows."],
					set = function(v)
						db.defaultBarTexture = v
						Violation:UpdateWindows()
					end,
					get = function() return db.defaultBarTexture end,
					validate = SM:List("statusbar"),
					order = 115,
				},
				windowtooltip = {
					type = "toggle",
					name = L["Show tooltips"],
					desc = L["Toggle whether to show detailed information when you hover the window."],
					set = function(v) db.windowTooltips = v end,
					get = function() return db.windowTooltips end,
					order = 116,
				},
			},
			order = 111,
		},
		mergespacer = {
			type = "header",
			name = " ",
			order = 120,
		},
		merge = {
			type = "toggle",
			name = L["Merge pets"],
			desc = L["Merge pet data with master."],
			get = function() return db.mergePets end,
			set = function(value)
				db.mergePets = value
				Violation:UpdateText()
				Violation:UpdateWindows()
			end,
			order = 121,
		},
		minimap = {
			type = "toggle",
			name = L["Minimap icon"],
			desc = L["Toggle the minimap icon."],
			get = function() return not db.minimap.hide end,
			set = function(v)
				local hide = not v
				db.minimap.hide = hide
				if hide then
					icon:Hide("Violation")
				else
					icon:Show("Violation")
				end
			end,
			hidden = function() return not icon end,
			order = 122,
		},
		resetspacer = {
			type = "header",
			name = " ",
			order = 150,
		},
		resetPrint = {
			type = "toggle",
			name = L["Print on reset"],
			desc = L["Prints your current data locally when your data is reset."],
			get = get,
			set = set,
			passValue = "printOnReset",
			order = 200,
		},
		reset = {
			type = "group",
			name = L["Reset"],
			desc = L["Options for when to reset the data."],
			args = {
				now = {
					type = "execute",
					name = L["Reset now"],
					desc = L["Immediately resets your data."],
					func = "Reset",
					order = 100,
				},
				spacer = {
					type = "header",
					name = " ",
					order = 150,
				},
				autoheader = {
					type = "header",
					name = L["Auto-reset"],
					order = 200,
				},
				gaincombat = {
					type = "toggle",
					name = L["Entering combat"],
					desc = L["Automatically reset the data when entering combat."],
					get = function() return db.gainCombat end,
					set = function(v)
						if v then
							Violation:RegisterEvent("PLAYER_REGEN_DISABLED", "Reset")
						else
							Violation:UnregisterEvent("PLAYER_REGEN_DISABLED")
						end
						db.gainCombat = v
					end,
					order = 201,
				},
				leavecombat = {
					type = "toggle",
					name = L["Leaving combat"],
					desc = L["Automatically reset the data when leaving combat."],
					get = function() return db.leaveCombat end,
					set = function(v)
						if v then
							Violation:RegisterEvent("PLAYER_REGEN_ENABLED", "Reset")
						else
							Violation:UnregisterEvent("PLAYER_REGEN_ENABLED")
						end
						db.leaveCombat = v
					end,
					order = 202,
				},
			},
			order = 201,
		},
		report = {
			type = "group",
			name = L["Report"],
			desc = L["Report your current data to a channel."],
			args = {},
			order = 202,
		},
	},
}

-----------------------------------------------------------------------
-- Module prototype
-----------------------------------------------------------------------

Violation.modulePrototype.version = -1

local incompatible = {}
local registered = {}
function Violation.modulePrototype:OnInitialize()
	if type(self.name) ~= "string" then
		error("A module is missing its name field.")
	elseif type(self.version) ~= "number" then
		error(self.name .. " doesn't have a version field.")
	elseif registered[self.name] then
		error("A module has been initialized twice for some reason.")
	end

	if self.version == moduleVersion then
		Violation:OnRegister(self)
		registered[self.name] = true
	else
		incompatible[self] = true
		Violation:ModuleIncompatible(self)
	end
end

function Violation.modulePrototype:OnEnable(first)
	if not db then db = Violation.db.profile end
	if incompatible[self] or not db.enabledModules[self.name] then return end

	if not runningModules[self.name] then
		-- Always reset our data when we enable.
		runningModules[self.name] = self

		self:Reset()

		if type(self.OnModuleEnable) == "function" then
			self:OnModuleEnable()
		end

		Violation:UpdateWindows()
		Violation:TriggerEvent("Violation_ModuleEnabled", self.name)
	end
end

function Violation.modulePrototype:OnDisable()
	if runningModules[self.name] then
		runningModules[self.name] = nil
		
		if type(self.OnModuleDisable) == "function" then
			self:OnModuleDisable()
		end

		Violation:UpdateWindows()
		Violation:TriggerEvent("Violation_ModuleDisabled", self.name)
	end
end

function Violation.modulePrototype:GetRevision()
	return self.revision
end

function Violation.modulePrototype:Reset()
	if type(self.data) == "table" then
		self.data = del(self.data)
	end
	self.data = new()
	self.dirty = nil
	if type(self.OnReset) == "function" then
		self:OnReset()
	end
end

function Violation.modulePrototype:IsDirty()
	return self.dirty
end

function Violation.modulePrototype:ResetDirty()
	self.dirty = nil
end

function Violation.modulePrototype:GetData(name)
	if name then
		return self.data[name]
	else
		return self.data
	end
end

function Violation.modulePrototype:new(...) return new(...) end
function Violation.modulePrototype:del(t) return del(t) end

function Violation.modulePrototype:Report(target, name, ...)
	if target == "player" then target = name end
	Violation:PrintModuleDataToChannel(self.name, target)
end

-----------------------------------------------------------------------
-- Default module data implementation
-----------------------------------------------------------------------
-- This implementation supposes that the modules handle "incremental" data
-- like damage done, or healing taken, ...
-- Special modules like DPS or HPS, have to override these methods

Violation.modulePrototype.canMergeData = true

function Violation.modulePrototype:OnData(name, input)
	if name and input and input > 0 then
		self.data[name] = (self.data[name] or 0) + input
		self.dirty = true
	end
end

function Violation.modulePrototype:GetMergedData(...)
	local sum = 0
	for i = 1,select("#", ...) do
		local arg = select(i, ...)
		sum = sum + (self:GetData(arg) or 0)
	end
	return sum
end

-----------------------------------------------------------------------
-- Implicit module interface
-----------------------------------------------------------------------

local IViolation = {

	-- Optional methods:
	--
	-- -- Called when the module is enabled by the core. Any event registration
	-- -- should happen here.
	-- OnModuleEnable
	-- OnModuleDisable
	--
	-- -- Called when the module is initially registered.
	-- OnModuleRegister

	-- Must return the current module revision as a number.
	GetRevision = "function",

	-- Must return the module name as it should be displayed in the menu, for
	-- example "Damage done".
	GetDisplayName = "function",

	-- Must return the module name as it should be displayed in a condensed
	-- display, like "PlayerDPS" should return "DPS".
	GetShortDisplayName = "function",

	-- Must return wether the modules data is dirty or not. If it is a
	-- diplay update will be scheduled by the core.
	IsDirty = "function",

	-- This function is must reset the modules dirty flag that is returned by IsDirty.
	ResetDirty = "function",

	-- Invoked by the core when all data should be reset.
	Reset = "function",

	-- Must return a universal unique ID that will be used for this module when
	-- sending data (where the universe is Violation)
	-- (Not used now, we use a memoization of the module name instead.
	-- GetUUID = "function",

	-- Must return the current dataset for this module. If an argument is given,
	-- it can be assumed to be a player name, and only the data (a number) for
	-- that player (or nil) must be returned.
	GetData = "function",
}

-----------------------------------------------------------------------
-- LDB
-----------------------------------------------------------------------
local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("Violation", {
	type = "data source",
	text = "Violation",
	icon = "Interface\\AddOns\\Violation\\icons\\grey",
})

-----------------------------------------------------------------------
-- Addon initialization
-----------------------------------------------------------------------

local profileDefaults = {
	enabledModules = {
		["*"] = true,
	},
	textModules = {
		["Damage per Second"] = true,
	},
	tooltipModules = {
		["Damage per Second"] = true,
	},
	colors = {
		["**"]                 = { r = 1,   g = 1,   b = 1   },

		["Damage done"]        = { r = 0.8, g = 0.3, b = 0.3 },
		["Damage taken"]       = { r = 0.8, g = 0.5, b = 0.3 },
		["Damage per Second"]  = { r = 0.8, g = 0.8, b = 0.3 },
		["Healing done"]       = { r = 0.5, g = 0.8, b = 0.3 },
		["Healing taken"]      = { r = 0.3, g = 0.8, b = 0.3 },
		["Healing per Second"] = { r = 0.3, g = 0.8, b = 0.5 },
		["Overhealing done"]   = { r = 0.3, g = 0.8, b = 0.8 },
	},
	gainCombat = nil,
	leaveCombat = nil,
	leaderReset = true,
	printOnReset = true,
	mergePets = true,
	windowTooltips = true,
	defaultBarTexture = "Blizzard",

	windows = {
		count = 1,
		["**"] = {
			width = 200,
			height = 200,
			nrBars = 10,
			scale = 1,
			show = true,
			module = "Damage done",
			locked = false,
			useModuleColor = true,
			color = { r = 1, g = 0, b = 0 },
			hideColumns = {
				[L["Rank"]] = true,
				[L["Percent"]] = true,
			},
			useDefaultTexture = true,
			barTexture = "Blizzard",
		},
	},

	showWindows = true,
	
	minimap = {
		hide = false,
	},
}

function Violation:OnInitialize()
	local revision = tonumber(("$Revision: 489 $"):sub(12, -3)) or 1
	if not self.version then self.version = "1.0" end
	self.version = self.version .. "." .. revision
	self.revision = revision

	_G.VIOLATION_VERSION = self.version
	_G.VIOLATION_REVISION = self.revision
	
	self:RegisterDB("ViolationDB", "ViolationPerCharDB", "Default")
	self:RegisterDefaults("profile", profileDefaults)

	self.roster = roster

	self:RegisterChatCommand("/violation", options, "VIOLATION")
	
	if icon then
		icon:Register("Violation", ldb, self.db.profile.minimap)
	end
end

local groupEvent = {"RAID_ROSTER_UPDATE", "PARTY_MEMBERS_CHANGED"}
function Violation:OnEnable(first)
	db = self.db.profile

	grouped = nil

	self:OnProfileEnable()

	self:ScheduleRepeatingEvent("DisplayUpdate", self.UpdateTextIfDirty, 2, self)

	if db.gainCombat then
		self:RegisterEvent("PLAYER_REGEN_DISABLED", "Reset")
	end

	if db.leaveCombat then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "Reset")
	end

	self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE", "UpdateChannels")
	self:RegisterBucketEvent("UPDATE_CHAT_COLOR", 1, "UpdateChannels")
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_PET")

	self:RegisterBucketEvent(groupEvent, 2, function()
		self:UpdatePartyMenu()
		self:OnRosterUpdate()
	end)

	ldb.icon = red
	self:OnRosterUpdate(true)
	self:UpdateChannels()
	self:Reset()
end

do
	local band = bit.band
	local group = 0x7
	local mine = 0x1
	local pet = 0x1000
	if COMBATLOG_OBJECT_AFFILIATION_MINE then
		group = COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
		mine = COMBATLOG_OBJECT_AFFILIATION_MINE
		pet = COMBATLOG_OBJECT_TYPE_PET
	end
	function Violation:ADDON_LOADED(addon)
		if addon == "Blizzard_CombatLog" then
			group = COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
			mine = COMBATLOG_OBJECT_AFFILIATION_MINE
			pet = COMBATLOG_OBJECT_TYPE_PET
		end
	end
	function Violation:ShouldAccept(source)
		return band(source, group) ~= 0
	end
	function Violation:GetReferenceGUID(guid, flags)
		-- Handle pets
		if band(flags, pet) ~= 0 and craftedPetGUIDs[guid] then
			return craftedPetGUIDs[guid]
		end
		-- Handle my things that are not pets
		if band(flags, mine) ~= 0 then
			return roster[playerName]
		end
		-- Everything else
		return guid
	end
end

function Violation:OnProfileEnable()
	db = self.db.profile

	-- Enable/disable all modules.
	for name in self:IterateModules() do
		self:ToggleModuleActive(name, db.enabledModules[name])
	end

	self:SetupWindows()
	self:UpdateText()
	self:ToggleWindows(db.showWindows)
end

function Violation:OnProfileDisable()
	-- Delete all windows. Start from the highest numbered one or window:GetID() goes bonkers
	for i = #self.windows, 1, -1 do
		self.windows[i]:Delete()
		self.windows[i] = nil
	end
end

function Violation:OnDisable()
	-- Close all windows
	self:CloseWindows()

	-- Disable all modules.
	for name, mod in pairs(runningModules) do
		self:ToggleModuleActive(name, false)
	end

	ldb.icon = grey
end

function Violation:Reset()
	for modName, module in pairs(runningModules) do
		if db.printOnReset then
			local data = self:GetModuleData(modName, playerName)
			if type(data) == "number" and data > 0 then
				local color = db.colors[modName]
				local name = module:GetDisplayName()
				name = Colorize(name, color.r, color.g, color.b)
				self:Print(format("%s: %d", name, data))
			end
		end
		module:Reset()
	end
	self:UpdateText()
	self:UpdateWindows()
end

function Violation:UpdateChannels()
	local c = ChatTypeInfo
	for k, v in pairs(reportToMenu) do
		local o = c[v.passValue]
		if o then
			local n = Colorize(v.name:gsub("(|c%x%x%x%x%x%x%x%x)", ""):gsub("(|r)", ""), o.r, o.g, o.b)
			v.name = n
		end
	end

	for i = 1, 10 do
		local id, name = GetChannelName(i)
		if id > 0 and name then
			local o = c["CHANNEL" .. id]
			local n = o and Colorize(name, o.r, o.g, o.b) or name
			reportToMenu[id] = {
				type = "execute",
				name = n,
				desc = L["Print to channel %q."]:format(name),
				passValue = id,
				order = 50 + id,
			}
		elseif reportToMenu[id] then
			reportToMenu[id] = nil
		end
	end
end

-----------------------------------------------------------------------
-- Module handling
-----------------------------------------------------------------------

function Violation:OnRegister(mod)
	for k, v in pairs(IViolation) do
		if type(mod[k]) ~= v then
			error(format("The module %q does not inherit from the IViolation interface.", tostring(mod.name)))
			return
		end
	end

	if mod.revision and mod.revision > self.revision then
		self.revision = mod.revision
	end

	local moduleName = mod.name
	local displayName = mod:GetDisplayName()

	local function disabled()
		return not runningModules[moduleName]
	end

	options.args.track.args[moduleName] = {
		type = "toggle",
		name = displayName,
		desc = L["Toggle whether to track %q."]:format(displayName),
	}

	options.args.colors.args[moduleName] = {
		type = "color",
		name = displayName,
		desc = L["What color to use for the %q data type."]:format(displayName),
		order = 100,
		hidden = disabled,
	}

	options.args.text.args[moduleName] = {
		type = "toggle",
		name = displayName,
		desc = L["Toggle whether to display data from %q on the panel."]:format(displayName),
		hidden = disabled,
	}

	options.args.tooltip.args[moduleName] = {
		type = "toggle",
		name = displayName,
		desc = L["Toggle whether to display data from %q in the tooltip."]:format(displayName),
		hidden = disabled,
	}

	options.args.report.args[moduleName] = {
		type = "group",
		name = displayName,
		desc = L["Send %s data."]:format(displayName),
		handler = mod,
		hidden = disabled,
		args = reportToMenu,
		pass = true,
		get = false,
		set = "Report",
		func = "Report",
	}

	if type(mod.OnModuleRegister) == "function" then
		mod:OnModuleRegister()
	end
end

function Violation:ModuleIncompatible(mod)
	self:ToggleModuleActive(mod, false)
	self:Print(L["%s has been disabled, since it is not compatible with the latest module API."]:format(mod.name))
end

function Violation:ToggleModule(mod, val)
	db.enabledModules[mod] = val
	Violation:ToggleModuleActive(mod, val)
	Violation:UpdateText()
end

function Violation:IsModuleRunning(name)
	return runningModules[name] and true or false
end

-----------------------------------------------------------------------
-- Pet merging stuff
-----------------------------------------------------------------------

local function craftPetGUID(petGUID, ownerGUID)
	if not craftedPetGUIDs[petGUID] then
		-- This is based on http://www.wowace.com/forums/index.php?topic=11418.0:
		-- Strip the serial part of the pet GUID and append the unique part of the owner GUID
		craftedPetGUIDs[petGUID] = petGUID:sub(3,12)..'-'..ownerGUID:sub(13)
	end
	return craftedPetGUIDs[petGUID]
end

local function updateRosterUnit(u, pet)
	local uID = UnitGUID(u)
	local uN = UnitName(u)
	roster[uN] = uID
	if UnitExists(pet) then
		local pN = UnitName(pet)
		local pID = craftPetGUID(UnitGUID(pet), uID)
		roster[pN] = pID
		if uID and pID and (not characterPets[pID] or characterPets[pID] ~= uID) then
			characterPets[pID] = uID
			return true
		end
	end
end

local function updateRaidPets(n)
	local dirty = nil
	for i = 1, n do
		dirty = updateRosterUnit("raid"..i, "raid"..i.."pet") or dirty
	end
	return dirty
end

local function updatePartyPets(n)
	local dirty = updateRosterUnit("player", "pet")
	for i = 1, n do
		dirty = updateRosterUnit("party"..i, "party"..i.."pet") or dirty
	end
	return dirty
end

function Violation:COMBAT_LOG_EVENT_UNFILTERED(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags)
	if eventType ~= "SPELL_SUMMON" then return end
	if not Violation:ShouldAccept(srcFlags) then return end
	local owner = srcGUID
	local pet = craftPetGUID(dstGUID, owner)
	characterPets[pet] = owner
end

function Violation:OnRosterUpdate(first)
	local raidN = GetNumRaidMembers()
	local groupN = GetNumPartyMembers()

	-- Check if we are grouped
	if (grouped or first) and (groupN == 0 and raidN == 0) then
		grouped = nil
		if db.showGrouped then self:ToggleWindows(false) end
	elseif (not grouped or first) and (groupN > 0 or raidN > 0) then
		grouped = true
		if db.showGrouped then self:ToggleWindows(true) end
	end

	for k in pairs(roster) do roster[k] = nil end
	for k in pairs(craftedPetGUIDs) do craftedPetGUIDs[k] = nil end

	-- Update pets
	local dirty = nil
	if raidN > 0 then
		dirty = updateRaidPets(raidN)
	else
		dirty = updatePartyPets(groupN)
	end
	if dirty then
		self:UpdateText()
		self:UpdateWindows()
	end
end

function Violation:UNIT_PET(unit) 
	if updateRosterUnit(unit, unit.."pet") then
		self:UpdateText()
		self:UpdateWindows()
	end
end

do
	local pets = {}
	local displayData = {}
	
	local temp = {}

	function Violation:GetModuleData(modName, charName)
		local mod = runningModules[modName]
		if not mod then return end

		local charId = roster[charName]
		if charName and not charId then return end

		local data = nil
		if db.mergePets and mod.canMergeData then
			if charId then
				-- Specific player data
				data = mod:GetData(charId) or 0
				for pet, main in pairs(characterPets) do
					if main == charId then
						data = data + (mod:GetData(pet) or 0)
					end
				end
			else
				for k in pairs(temp) do temp[k] = nil end
				for k, v in pairs(mod:GetData()) do
					temp[k] = v
				end
				-- Merge data where needed
				for pet, main in pairs(characterPets) do
					if temp[pet] then
						if temp[main] then
							temp[main] = temp[main] + temp[pet]
						end
						temp[pet] = nil
					end
				end
				data = temp
			end
		else
			if charId then
				data = mod:GetData(charId) or 0
			else
				for k in pairs(temp) do temp[k] = nil end
				for k, v in pairs(mod:GetData()) do
					temp[k] = v
				end
				data = temp
			end
		end
		if type(data) == "table" then
			for k in pairs(displayData) do displayData[k] = nil end
			for name, id in pairs(roster) do
				if data[id] then
					displayData[name] = data[id]
				end
			end
			return displayData
		else
			return data
		end
	end
end

-----------------------------------------------------------------------
--
-----------------------------------------------------------------------

local function Sorter(a, b) return a[2] > b[2] end

-- this dataInfo table is reused throughout violation for the current information being displayed.
local dataInfo = {}

function Violation:PublishModuleData(modName, callback, count, offset, window)
	local data = self:GetModuleData(modName)
	if type(data) ~= "table" then
		error(format("%q provided us with nil data.", modName))
	end
	local mod = runningModules[modName]

	local tbl = new()
	dataInfo.total = 0
	dataInfo.maxValue = 0
	for k, v in pairs(data) do
		if type(v) == "number" and v > 0 then
			dataInfo.total = dataInfo.total + v
			dataInfo.maxValue = math.max(dataInfo.maxValue, v)
			table_insert(tbl, new(k, v))
		end
	end

	local tblCount = #tbl
	count = math.min(count or tblCount, tblCount)
	offset = math.max(math.min(offset or 0, tblCount-count), 0)

	local n = 0
	if tblCount > 0 then
		local percentage = nil

		if tblCount > 1 then
			table.sort(tbl, Sorter)

			if not mod.hidePercentage then
				percentage = new()
				for i, v in ipairs(tbl) do
					table_insert(percentage, (v[2] * 100) / dataInfo.total)
				end
			end
		end

		dataInfo.hasMergedData = db.mergePets and mod.canMergeData and next(characterPets) and true or nil
		dataInfo.rowCount = tblCount
		dataInfo.module = mod
		dataInfo.hasPercentage = percentage

		for i = 1, count do
			local rank = offset + i
			local name, value = unpack(tbl[rank])
			if not name then break end
			if window then
				callback(window, i, rank, name, value, percentage and percentage[rank])
			else
				callback(i, rank, name, value, percentage and percentage[rank])
			end
			n = n + 1
		end
	
		percentage = del(percentage)
	end

	tbl = del(tbl)
	return n, offset
end

-----------------------------------------------------------------------
-- Channel output
-----------------------------------------------------------------------

local function chatCallback(i, rank, name, value, percentage)
	if not dataInfo.header then
		CTL:SendChatMessage("BULK", "Vio", format("==== %s ====", dataInfo.module:GetDisplayName()), dataInfo.channel, nil, dataInfo.target)
		dataInfo.header = true
	end
	local s = nil
	if percentage then
		s = format("%d. %s - %s (%.1f%%)", rank, name, value, percentage)
	else
		s = format("%d. %s - %s", rank, name, value)
	end
	CTL:SendChatMessage("BULK", "Vio", s, dataInfo.channel, nil, dataInfo.target)
end

function Violation:PrintModuleDataToChannel(modName, target)
	dataInfo.header = nil
	dataInfo.target = target
	if tonumber(target) then
		dataInfo.channel = "CHANNEL"
	elseif UnitExists(target) or target:find("%l") then
		dataInfo.channel = "WHISPER"
	else
		dataInfo.channel = target
	end
	self:PublishModuleData(modName, chatCallback, db.maxPrintLines)
end

-----------------------------------------------------------------------
-- UI
-----------------------------------------------------------------------

do
	local classOrders = {}
	for k,v in pairs(RAID_CLASS_COLORS) do
		classOrders[k] = (v.r + v.g + v.b) * 10 + 100
	end

	function Violation:UpdatePartyMenu()
		local whisperTargets = reportToMenu.whisper.args
		local inRaid = UnitInRaid("player")
		local n = inRaid and GetNumRaidMembers() or GetNumPartyMembers()

		for k, o in pairs(whisperTargets) do
			if whisperTargets[k].type == "execute" then
				whisperTargets[k].hidden = true
			end
		end

		whisperTargets.spacer.hidden = true

		local shown = nil
		for i = 1, n do
			local name = inRaid and GetRaidRosterInfo(i) or UnitName("party" .. i)
			if name and not whisperTargets[name] then
				local _, c = UnitClass(name)
				whisperTargets[name] = {
					type = "execute",
					name = coloredNames[name],
					desc = L["Send reports to %s."]:format(name),
					passValue = name,
					order = classOrders[c] or 100,
				}
				shown = true
			end
			if name then
				whisperTargets[name].hidden = nil
				shown = true
			end
		end
		if shown then
			whisperTargets.spacer.hidden = nil
		end
	end
end

function ldb.OnClick(self, button)
	if button == "RightButton" then
		dew:Open(self,
			"children", function()
				dew:FeedAceOptionsTable(options)
			end
		)
	else
		if IsShiftKeyDown() then
			Violation:Reset()
		else
			Violation:ToggleWindows(not db.showWindows)
		end
	end
end

function Violation:UpdateTextIfDirty()
	local dirty = nil
	for k, v in pairs(db.tooltipModules) do
		if v and runningModules[k] and runningModules[k]:IsDirty() then
			dirty = true
			break
		end
	end
	if dirty then
		self:UpdateText()
		self:UpdateDirtyWindows()
	end
	for k, v in pairs(db.tooltipModules) do
		if v and runningModules[k] then
			runningModules[k]:ResetDirty()
		end
	end
end

do
	local function addTooltipCallback(tt, i, rank, name, value, percentage)
		if not dataInfo.cat then
			tt:AddDoubleLine(L["Player"], dataInfo.module:GetDisplayName(), 1,1,1, 1,1,1)
			dataInfo.cat = true
		end
		tt:AddDoubleLine(coloredNames[name], tostring(value or 0), 1,1,1, 1,1,1)
	end

	local noModules = L["No modules running, please enable one or more from the configuration menu."]
	local hint = L["|cffeda55fClick|r to toggle the bar display. |cffeda55fShift-Click|r to reset."]
	function ldb.OnTooltipShow(tt)
		tt:AddLine("Violation")
		local no = true
		for k, v in pairs(db.tooltipModules) do
			if v and runningModules[k] then
				no = nil
				dataInfo.cat = nil
				Violation:PublishModuleData(k, addTooltipCallback, 10, 0, tt)
				if dataInfo.cat then
					tt:AddLine(" ")
				end
			end
		end
		if no then
			tt:AddLine(noModules, 0.65, 0.65, 0.65, 1)
		end
		tt:AddLine(hint, 0.2, 1, 0.2, 1)
	end
end

function Violation:UpdateText()
	local hasText = nil
	for k, v in pairs(Violation.db.profile.textModules) do
		if v and runningModules[k] then
			local data = self:GetModuleData(k, playerName)
			if type(data) == "number" and data > 0 then
				local shortName = runningModules[k]:GetShortDisplayName()
				local color = db.colors[k]
				local text = Colorize(string.format("%s: %d", shortName, data), color.r, color.g, color.b)
				if not hasText then hasText = new(text)
				else table_insert(hasText, text) end
			end
		end
	end

	if not hasText then
		ldb.text = self.name
	else
		ldb.text = table.concat(hasText, " ")
		hasText = del(hasText)
	end
end

----------------------------
-- GUI STUFF
----------------------------

---------------------------
-- Locals
---------------------------

local cachedBars = {}
local windowCache = {}

Violation.windows = {}

----------------------------
-- Violation Window Menu Template and helpers
----------------------------

local function copyTable(source)
	local result = {}
	for k, v in pairs(source) do
		if type(v) == "table" then
			result[k] = copyTable(v)
		else
			result[k] = v
		end
	end
	return result
end


local windowDefaults = {
	width = 200,
	height = 200,
	nrBars = 10,
	scale = 1,
	show = true,
	module = "Damage",
	locked = false,
	useModuleColor = true,
	color = { r = 1, g = 0, b = 0 },
	barTexture = "Blizzard",
	hideColumns = {
		[L["Rank"]] = true,
		[L["Percent"]] = true,
	},
	useDefaultTexture = true,
	posX = false,
	posY = false,
}

local columns = { L["Rank"], L["Name"], L["Value"], L["Percent"] }
local windowOptionsTemplate = {
	report = {
		type = "group",
		name = L["Report"],
		desc = L["Report your current data to a channel."],
		hidden = disabled,
		args = reportToMenu,
		pass = true,
		get = false,
		set = "Report",
		func = "Report",
		order = 100,
	},
	show = {
		type = "toggle",
		name = L["Show"],
		desc = L["Show window."],
		get = "windowGet",
		set = "windowSet",
		passValue = "show",
		order = 105,
	},
	lock = {
		type = "toggle",
		name = L["Lock"],
		desc = L["Lock window."],
		get = "windowGet",
		set = "windowSet",
		passValue = "locked",
		order = 110,
	},
	layoutoptionsspacer = {
		type = "header",
		text = " ",
		order = 115,
	},
	modulecolor = {
		type = "toggle",
		name = L["Use module color"],
		desc = L["Use module color for the window header."],
		get = "windowGet",
		set = "windowSetSoft",
		passValue = "useModuleColor",
		order = 120,
	},
	color = {
		type = "color",
		name = L["Color"],
		desc = L["Use a custom window color for the header."],
		get = "windowGetColor",
		set = "windowSetColor",
		disabled = "windowUsesModuleColor",
		passValue = "color",
		order = 121,
	},
	defaulttexture = {
		type = "toggle",
		name = L["Use default texture"],
		desc = L["Use the default bar texture."],
		get = "windowGet",
		set = "windowSetSoft",
		passValue = "useDefaultTexture",
		order = 130,
	},
	texture = {
		type = "text",
		name = L["Texture"],
		desc = L["Set a custom bar texture to use for this window."],
		get = "windowGet",
		set = "windowSetSoft",
		passValue = "barTexture",
		validate = SM:List("statusbar"),
		disabled = "windowUsesDefaultTexture",
		order = 131,
	},
	columns = {
		type = "text",
		name = L["Columns"],
		desc = L["Toggle which columns should be visible in this window."],
		order = 132,
		get = "windowGetColumn",
		set = "windowSetColumn",
		multiToggle = true,
		validate = columns,
	},
	scale = {
		type = "range",
		name = L["Scale"],
		desc = L["Set the window scale."],
		min = 0.4, max=2, step=0.02, bigStep=0.1, isPercent=true,
		get = "windowGet",
		set = "windowSetSoft",
		passValue = "scale",
		order = 140,
	},
	resetspacer = {
		type = "header",
		name = " ",
		order = 190,
	},
	reset = {
		type = "execute",
		name = L["Reset module"],
		desc = L["Reset the associated modules data."],
		func = "windowReset",
		passValue = "reset",
		order = 191,
	},
	delspacer = {
		type = "header",
		name = " ",
		order = 200,
	},
	delete = {
		type = "execute",
		name = L["Delete"],
		desc = L["Delete this window."],
		func = "windowDelete",
		passValue = "delete",
		order = 201,
	},
}

---------------------------
-- Initialization from Violation
---------------------------

function Violation:SetupWindows()
	for i = 1, db.windows.count do
		if not self.windows[i] then
			if not db.windows[i] then
				db.windows[i] = copyTable(windowDefaults)
			end
			self.windows[i] = self:CreateWindow(db.windows[i])
			-- we call setup here because at this point getID() is available.
			self.windows[i]:Setup()
		end
	end
end

function Violation:CreateWindow(options)
	local w
	if #windowCache > 0 then
		w = table.remove(windowCache)
	else
		w = self.VioWindow:new()
	end
	w.options = options
	return w
end

function Violation:DeleteWindow(window)
	window:Delete()
	local wdb = db.windows
	local oldindex = window:GetID()
	for i = oldindex, wdb.count - 1 do
		wdb[i] = wdb[i+1]
		self.windows[i] = self.windows[i+1]
	end
	table_insert(windowCache, window)
	wdb[wdb.count] = nil
	self.windows[wdb.count] = nil
	options.args.windows.args[wdb.count] = nil
	wdb.count = wdb.count - 1
	for i = 1, wdb.count do
		self.windows[i]:SetupMenuOptions()
	end
	return nil
end

function Violation:UpdateWindows(sameamount)
	for k, w in ipairs(self.windows) do
		w:Update(sameamount)
	end
end

function Violation:UpdateDirtyWindows()
	for k, w in ipairs(self.windows) do
		w:UpdateIfDirty()
	end
end

function Violation:ToggleWindows(show)
	local shown=0
	for k, w in ipairs(self.windows) do
		if w.options.show then
			shown=shown+1
		end
	end
	if shown<1 then
		Violation:Print(L["No windows are configured to be shown."])
		db.showWindows = true
		return
	end

	db.showWindows = show
	if show then
		self:OpenWindows()
	else
		self:CloseWindows()
	end
end

function Violation:CloseWindows()
	for k, w in ipairs(self.windows) do
		w:Close()
	end
end

function Violation:OpenWindows()
	for k, w in ipairs(self.windows) do
		if w.options.show then
			w:Open()
		end
	end
end

----------------------------
-- Bar Tooltip
----------------------------

local function UpdateBarTooltip(bar)
	GameTooltip:SetOwner(bar)
	local char = bar.vioName
	GameTooltip:ClearLines()
	GameTooltip:AddLine(char)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(L["Module"], L["Value"], 1, 1, 1, 1, 1, 1)
	for modName, module in pairs(runningModules) do
		local displayName = module:GetDisplayName()
		local value = Violation:GetModuleData(modName, char)
		if value and tonumber(value) > 0 then
			local color = db.colors[modName]
			GameTooltip:AddDoubleLine(displayName, tostring(value), color.r, color.g, color.b, 1, 1, 1)
		end
	end
	GameTooltip:Show()
end

local function OnBarEnter(this)
	if db.windowTooltips and not UnitAffectingCombat("player") or IsControlKeyDown() then
		UpdateBarTooltip(this)
	end
end

local function OnBarLeave(this)
	GameTooltip:ClearLines()
	GameTooltip:Hide()
end

----------------------------
-- Bars Local Helpers
----------------------------

local function NewBar(texture)
	local f
	if #cachedBars > 0 then
		f = table.remove(cachedBars)
	else
		f = CreateFrame("Button", nil, UIParent)
	end

	f:Hide()
	f:SetHeight(15)

	if not f.statusbar then
		f.statusbar = CreateFrame("StatusBar", nil, f)
		f.statusbar:SetMinMaxValues(0,100)
		f.statusbar:ClearAllPoints()
		f.statusbar:SetAllPoints(f)
	end

	if not f.lefttext then
		f.lefttext = f.statusbar:CreateFontString(nil, "OVERLAY")
		f.lefttext:SetFontObject(GameFontHighlightSmall)
		f.lefttext:SetJustifyH("LEFT")
		f.lefttext:SetTextColor(1, 1, 1, 1)
		f.lefttext:SetPoint("LEFT", f.statusbar, "LEFT", 0, 0)
	end

	if not f.righttext then
		f.righttext = f.statusbar:CreateFontString(nil, "OVERLAY")
		f.righttext:SetFontObject(GameFontHighlightSmall)
		f.righttext:SetJustifyH("RIGHT")
		f.righttext:SetTextColor(1, 1, 1, 1)
		f.righttext:SetPoint("RIGHT", f.statusbar, "RIGHT", 0, 0)
	end

	if not f:GetScript("OnEnter") then
		f:SetScript("OnEnter", OnBarEnter)
	end
	if not f:GetScript("OnLeave") then
		f:SetScript("OnLeave", OnBarLeave)
	end

	return f
end

local function FreeBar(f)
	f:Hide()
	f:ClearAllPoints()
	table_insert(cachedBars, f)
	return nil
end

----------------------------
-- Vio Window Local Helpers
----------------------------

local function OnWindowMouseUp(this, button)
	if button == "RightButton" then
		this.window:OpenMenu()
	end
end

local function OnWindowMouseWheel(this, dir)
	this.window:OnOffset(dir > 0)
end

local function OnWindowClose(this)
	this:GetParent().window.options.show = false
	this:GetParent().window:Close()
end

local function OnWindowPrevModule(this)
	this:GetParent().window:SwitchView(false)
end

local function OnWindowNextModule(this)
	this:GetParent().window:SwitchView(true)
end

local function OnWindowDragStop(this)
	this:StopMovingOrSizing()
	local s = this:GetEffectiveScale()
	this.window.options.posX = this:GetLeft() * s
	this.window.options.posY = this:GetTop() * s
end

local function OnWindowSizeChanged(this)
	this.window:OnSized()
end

local function OnDragHandleShow(this)
	this.draghandle:Show()
end

local function OnDragHandleHide(this)
	this.draghandle:Hide()
end

local function ScheduleDragHandleHide(this)
	if this.windowframe then
		this = this.windowframe
	end
	if this.hideEvent then
		Violation:CancelScheduledEvent(this.hideEvent)
		this.hideEvent = nil
	end
	this.hideEvent = "Violation-" .. math.random()
	Violation:ScheduleEvent(this.hideEvent, OnDragHandleHide, 1, this)
end

local function OnDragHandleMouseDown(this)
	this.windowframe.isResizing = true
	this.windowframe:StartSizing("BOTTOMRIGHT")
end

local function OnDragHandleMouseUp(this, button)
	this.windowframe:StopMovingOrSizing()
	this.windowframe.window:OnSized()
	this.windowframe.isResizing = nil
end

local function OnDragHandleEnter(this)
	local hideEvent = this.hideEvent
	this.hideEvent = nil
	if this.windowframe then
		hideEvent = this.windowframe.hideEvent
		this.windowframe.hideEvent = nil
	end
	Violation:CancelScheduledEvent(hideEvent)
end

----------------------------
-- Violation Window Class
----------------------------

local VioWindow = AceOO.Class()

Violation.VioWindow = VioWindow

function VioWindow.prototype:init()
	VioWindow.super.prototype.init(self)
	local id = self:GetID() or 0
	local f = CreateFrame("Frame", "Violation"..id, UIParent)
	f:Hide()
	f.window = self
	self.frame = f
end

local windowBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
	edgeFile = "Interface\\AddOns\\Violation\\textures\\otravi-semi-full-border", edgeSize = 32,
	insets = {left = 0, right = 0, top = 20, bottom = 0},
}
function VioWindow.prototype:Setup()

	self.deleted = false

	local f = self.frame
	local o = self.options
	local font = GameFontNormal:GetFont()

	self.barOffset = 0
	if not self.currentBars then
		self.currentBars = {}
	end

	self:SetupMenuOptions()

	f:SetScale(o.scale or 1)
	f:SetClampedToScreen(true)

	f:SetWidth(o.width)
	f:SetHeight(o.height)
	f:SetPoint("CENTER", UIParent, "CENTER")
	f:SetBackdrop(windowBackdrop)
	f:SetBackdropColor(24/255, 24/255, 24/255)
	f:EnableMouse(true)
	f:EnableMouseWheel(true)

	f:SetScript("OnMouseUp", OnWindowMouseUp)
	f:SetScript("OnMouseWheel", OnWindowMouseWheel)

	-- header
	if not f.header then
		f.header = f:CreateFontString(nil,"OVERLAY")
	end
	f.header:SetFont(font, 12)
	f.header:SetText("")

	local module = Violation:HasModule(options.module) and Violation:GetModule(options.module) or nil

	if module then f.header:SetText(module:GetDisplayName()) end
	f.header:SetJustifyH("LEFT")
	f.header:SetShadowOffset(.8, -.8)
	f.header:SetShadowColor(0, 0, 0, 1)
	f.header:ClearAllPoints()
	f.header:SetPoint("TOPLEFT", f, "TOPLEFT", 24, -14)
	f.header:SetPoint("TOPRIGHT", f, "TOPRIGHT", -42, -14)

	-- close button
	if not f.closebutton then
		f.closebutton = CreateFrame("Button", nil, f)
	end
	f.closebutton:SetWidth(16)
	f.closebutton:SetHeight(16)
	f.closebutton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -7, -13)
	f.closebutton:SetScript("OnClick", OnWindowClose)
	if not f.close then
		f.close = f:CreateTexture(nil, "ARTWORK")
	end
	f.close:SetPoint("CENTER", f.closebutton, "CENTER")
	f.close:SetTexture("Interface\\AddOns\\Violation\\textures\\otravi-close")
	f.close:SetWidth(16)
	f.close:SetHeight(16)
	f.close:SetBlendMode("ADD")

	-- prev button
	if not f.prevbutton then
		f.prevbutton = CreateFrame("Button", nil, f)
	end
	f.prevbutton:SetWidth(16)
	f.prevbutton:SetHeight(16)
	f.prevbutton:SetPoint("TOPLEFT", f, "TOPLEFT", 7, -13)
	f.prevbutton:SetScript("OnClick", OnWindowPrevModule)
	if not f.prev then
		f.prev = f:CreateTexture(nil, "ARTWORK")
	end
	f.prev:SetPoint("CENTER", f.prevbutton, "CENTER")
	f.prev:SetTexture("Interface\\AddOns\\Violation\\textures\\prev")
	f.prev:SetWidth(16)
	f.prev:SetHeight(16)
	f.prev:SetBlendMode("ADD")

	-- next button
	if not f.nextbutton then
		f.nextbutton = CreateFrame("Button", nil, f)
	end
	f.nextbutton:SetWidth(16)
	f.nextbutton:SetHeight(16)
	f.nextbutton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -28, -13)
	f.nextbutton:SetScript("OnClick", OnWindowNextModule)
	if not f.next then
		f.next = f:CreateTexture(nil, "ARTWORK")
	end
	f.next:SetPoint("CENTER", f.nextbutton, "CENTER")
	f.next:SetTexture("Interface\\AddOns\\Violation\\textures\\next")
	f.next:SetWidth(16)
	f.next:SetHeight(16)
	f.next:SetBlendMode("ADD")

	-- drag handle
	if not f.draghandle then
		f.draghandle = CreateFrame("Frame", nil, f)
	end
	f.draghandle.windowframe = f
	f.draghandle:Hide()
	f.draghandle:SetFrameLevel(f:GetFrameLevel() + 10) -- place this above everything
	f.draghandle:SetWidth(16)
	f.draghandle:SetHeight(16)
	f.draghandle:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
	f.draghandle:EnableMouse(true)

	if not f.draghandle.texture then
		f.draghandle.texture = f.draghandle:CreateTexture(nil,"BACKGROUND")
	end
	f.draghandle.texture:SetTexture("Interface\\AddOns\\Violation\\textures\\draghandle")
	f.draghandle.texture:SetWidth(16)
	f.draghandle.texture:SetHeight(16)
	f.draghandle.texture:SetBlendMode("ADD")
	f.draghandle.texture:SetPoint("CENTER", f.draghandle, "CENTER", 0, 0)

	self:ToggleLock(o.locked)
	self:RestorePosition()

	self:Update()

	if o.show and db.showWindows then
		self:Open()
		Violation:ToggleWindows(true)
	else
		self:Close()
	end
end

function VioWindow.prototype:GetID()
	for k, w in ipairs(Violation.windows) do
		if w == self then
			return k
		end
	end
end

function VioWindow.prototype:DeleteWindowOptions()
	local id = self:GetID()
	if self.menuoptions then
		self.menuoptions.args = nil	-- this one is shared, don't nuke
		self.menuoptions.handler = nil	-- this one points to self == infinite recursion
		self.menuoptions = del(self.menuoptions)
	end
	options.args.windows.args[id] = nil
end

function VioWindow.prototype:UpdateOptionsName()
	local id = self:GetID()
	local mod = Violation:HasModule(self.options.module) and Violation:GetModule(self.options.module) or nil
	local modName = "?"
	if mod then
		modName = mod:GetDisplayName()
	end
	self.menuoptions.name = ("%d. %s"):format(id, modName)
	self.menuoptions.desc = L["Options for window %d. %s."]:format(id, modName)
end

function VioWindow.prototype:SetupMenuOptions()
	self:DeleteWindowOptions()

	local opt = new()
	opt.type = "group"
	opt.handler = self
	opt.args = windowOptionsTemplate
	opt.isChecked = "windowIsShown"
	opt.onClick = "windowToggleShown"

	self.menuoptions = opt
	self:UpdateOptionsName()

	local id = self:GetID()
	options.args.windows.args[id] = self.menuoptions
end

function VioWindow.prototype:OpenMenu()
	dew:Open(self.frame, "children", function() dew:FeedAceOptionsTable(self.menuoptions) end, "cursorX", true, "cursorY", true)
end

function VioWindow.prototype:ToggleLock(locked)
	self.options.locked = locked
	local f = self.frame
	if locked then
		f:SetMovable(nil)
		f:SetResizable(nil)
		f:RegisterForDrag()
		f.closebutton:Hide()
		f.close:Hide()

		f:SetScript("OnEnter", nil)
		f:SetScript("OnLeave", nil)
		f:SetScript("OnDragStart", nil)
		f:SetScript("OnDragStop", nil)
		f:SetScript("OnSizeChanged", nil)
		f.draghandle:SetScript("OnMouseDown", nil)
		f.draghandle:SetScript("OnMouseUp", nil)
		f.draghandle:SetScript("OnEnter", nil)
		f.draghandle:SetScript("OnLeave", nil)
	else
		f:SetMovable(true)
		f:SetResizable(true)
		f:SetMinResize(50,50)
		f:RegisterForDrag("LeftButton")
		f.closebutton:Show()
		f.close:Show()

		f:SetScript("OnDragStart", f.StartMoving)
		f:SetScript("OnDragStop", OnWindowDragStop)
		f:SetScript("OnSizeChanged", OnWindowSizeChanged)
		f:SetScript("OnEnter", OnDragHandleShow)
		f:SetScript("OnLeave", ScheduleDragHandleHide)
		f.draghandle:SetScript("OnMouseDown", OnDragHandleMouseDown)
		f.draghandle:SetScript("OnMouseUp", OnDragHandleMouseUp)
		f.draghandle:SetScript("OnEnter", OnDragHandleEnter)
		f.draghandle:SetScript("OnLeave", ScheduleDragHandleHide)
	end

end

function VioWindow.prototype:RestorePosition()
	local f = self.frame
	local x = self.options.posX
	local y = self.options.posY
	if x and y then
		local s = f:GetEffectiveScale()
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	end
end

function VioWindow.prototype:OnOffset(up)
	-- we do not check if ouyr barOffset is still valid here. Update will do that for us
	if up then
		self.barOffset = self.barOffset - 1
	else
		self.barOffset = self.barOffset + 1
	end
	self:Update()
end

function VioWindow.prototype:OnSized()
	local f = self.frame
	local o = self.options

	if not f.isResizing then return end -- don't do anything on frame creation

	local y = f:GetHeight()
	local x = f:GetWidth()

	o.height = y
	o.width = x

	y = math.ceil(y)
	y = y - 34 -- deduct the header size

	local nrbars = math.floor(y / 16)
	if nrbars < 1 then nrbars = 1 end

	if nrbars ~= o.nrBars then
		if nrbars < o.nrBars then
			for i = nrbars+1, o.nrBars do
				self:ClearBar(i)
			end
		end
		o.nrBars = nrbars
		self:Update()
	else
		self:Update(true)
	end
end

function VioWindow.prototype:SwitchView(forward)
	local o = self.options
	local mod = o.module
	local dirtpile = new()
	local current
	for modName in pairs(runningModules) do
		table_insert(dirtpile, modName)
		if modName == mod then
			current = #dirtpile
		end
	end
	if not current or (forward and current == #dirtpile) then
		o.module = dirtpile[1]
	elseif forward then
		o.module = dirtpile[current + 1]
	elseif current == 1 then
		o.module = dirtpile[#dirtpile]
	else
		o.module = dirtpile[current -1]
	end
	dirtpile = del(dirtpile)
	if mod ~= o.module then
		self:UpdateOptionsName()
		self:Update()
	end
end

function VioWindow.prototype:Delete()
	if dew:IsOpen(self.frame) then
		dew:Close()
	end
	self:Close()
	self:DeleteWindowOptions()
end

function VioWindow.prototype:Close()
	self.frame:Hide()
	for k, v in ipairs(self.currentBars) do
		self:ClearBar(k)
	end
end

function VioWindow.prototype:Open()
	self.frame:Show()
	self:Update()
end

do
	local columnRank = L["Rank"]
	local columnName = L["Name"]
	local columnValue = L["Value"]
	local columnPercent = L["Percent"]
	
	-- Ninjaed from Omen
	local function shortenNumbers(n)
		return n > 1000 and format("%2.1fk", n / 1000) or format("%2.0f", n)
	end
	
	local grey = { 0.5, 0.5, 0.5 }
function VioWindow.prototype:SetBar(count, rank, name, value, percent)
	local texture = self.options.useDefaultTexture and db.defaultBarTexture or self.options.barTexture

	if not self.currentBars[count] then
		self.currentBars[count] = NewBar(texture)
	end
	local f = self.currentBars[count]

	f:SetParent(self.frame)
	f.vioWindow = self
	f.vioName = name

	-- Horrible, horrible code. I'll redo it when I can be arsed.
	local c = self.options.hideColumns
	if not c[columnRank] or not c[columnName] then
		local text = nil
		if not c[columnRank] then text = " " .. rank .. "." end
		if not c[columnName] then
			if text then text = text .. " " end
			text = (text or " ") .. name
		end
		f.lefttext:SetText(text)
	else
		f.lefttext:SetText("")
	end
	if not c[columnValue] or not c[columnPercent] then
		local v = shortenNumbers(value)
		local text = nil
		if not c[columnValue] then text = v .. " " end
		if not c[columnPercent] and percent then
			text = (text or "") .. percentString:format(percent) .. " "
		end
		f.righttext:SetText(text)
	else
		f.righttext:SetText("")
	end

	local vmax = dataInfo.maxValue

	if vmax and vmax ~= 0 then
		f.statusbar:SetValue((value/vmax)*100)
	else
		f.statusbar:SetValue(100)
	end
	
	local color = RGB[name] or grey
	f.statusbar:SetStatusBarColor(color[1], color[2], color[3], 1)
	if count == 1 then
		f:SetPoint("TOP", self.frame, "TOP", 0, -32)
	else
		f:SetPoint("TOP", self.currentBars[count-1], "BOTTOM", 0, -1)
	end
	f.statusbar:SetStatusBarTexture(SM:Fetch("statusbar", texture))
	f:SetPoint("LEFT", self.frame, "LEFT", 0, 0)
	f:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
	f:Show()
end
end

function VioWindow.prototype:ClearBar(count)
	if not self.currentBars[count] then return end
	self.currentBars[count] = FreeBar(self.currentBars[count])
end

function VioWindow.prototype:UpdateIfDirty()
	local mod = Violation:HasModule(self.options.module) and Violation:GetModule(self.options.module) or nil
	if mod and mod:IsDirty() then
		self:Update()
		return self.options.module
	end
end

local disabledWindowColor = {r=0.5, g=0.5, b=0.5, a=1}

function VioWindow.prototype:Update(sameamount)
	if not self.options.show then return end

	local o = self.options

	local mod = o.module
	local module = Violation:HasModule(mod) and Violation:GetModule(mod) or nil
	if module then
		o.cachedShortDisplayName = module:GetShortDisplayName()
		o.cachedDisplayName = module:GetDisplayName()
	end

	local f = self.frame

	local txt
	if (f.header:GetRight() or 0) - (f.header:GetLeft() or 0) < 80 then
		txt = o.cachedShortDisplayName or "?"
	else
		txt = o.cachedDisplayName or "?"
	end

	if not db.enabledModules[mod] then
		module = nil
		txt = format("%s\n\n%s\nnot active",txt,txt)	-- uuuugly
	end

	f.header:SetText(txt)

	local color
	if not module then
		color = disabledWindowColor
	else
	 	color = o.useModuleColor and db.colors[mod] or o.color
	end
	f:SetBackdropBorderColor(color.r, color.g, color.b)

	if f.barScale ~= (o.scale or 1) then
		local x = f:GetLeft()
		local y = f:GetTop()
		local scale = f:GetScale()
		x = x * scale
		y = y * scale
		scale = o.scale or 1
		f:SetScale(scale)
		x = x / scale
		y = y / scale
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x,y)
		f.barScale = o.scale
	end

	if module then
		if not sameamount then
			local data = Violation:GetModuleData(module.name)
			if type(data) == "table" then
				self:UpdateBars(module.name)
			end
		end
	else
		for k, v in ipairs(self.currentBars) do
			self:ClearBar(k)
		end
	end
end

function VioWindow.prototype:UpdateBars(modName)
	local o = self.options
	local barCount, barOff = Violation:PublishModuleData(modName, self.SetBar, o.nrBars, self.barOffset, self)
	self.barOffset = barOff -- set our barOffset to the correct new value.
	if barCount < o.nrBars then
		for i = barCount+1, o.nrBars do
			self:ClearBar(i)
		end
	end
end

-- aceoptions handler methods:
function VioWindow.prototype:windowGetColumn(key)
	return not self.options.hideColumns[key]
end

function VioWindow.prototype:windowSetColumn(key, value)
	self.options.hideColumns[key] = not value
	self:Update()
end

function VioWindow.prototype:windowGet(passValue)
	return self.options[passValue]
end

function VioWindow.prototype:windowSet(passValue, value)
	self.options[passValue] = value
	self:Setup()
end

function VioWindow.prototype:windowSetSoft(passValue, value)
	self.options[passValue] = value
	self:Update(true)
end

function VioWindow.prototype:windowIsShown()
	return self.options.show
end

function VioWindow.prototype:windowToggleShown()
	self.options.show = not self.options.show
	self:Setup()
end

function VioWindow.prototype:windowDelete(passValue)
	Violation:DeleteWindow(self)
end

function VioWindow.prototype:windowReset(passValue)
	local mod = Violation:HasModule(self.options.module) and Violation:GetModule(self.options.module)
	if mod then
		mod:Reset()
		self:Update()
	end
end

function VioWindow.prototype:windowSetColor(passValue, r, g, b, a)
	local tuple = self.options[passValue]
	tuple.r = r
	tuple.g = g
	tuple.b = b
	tuple.a = a
	self.options[passValue] = tuple
	self:Update(true)
end

function VioWindow.prototype:windowGetColor(passValue)
	local tuple = self.options[passValue]
	return tuple.r, tuple.g, tuple.b, tuple.a
end

function VioWindow.prototype:windowUsesModuleColor()
	return self.options.useModuleColor
end

function VioWindow.prototype:windowUsesDefaultTexture()
	return self.options.useDefaultTexture
end

function VioWindow.prototype:Report(target, name, ...)
	local mod = Violation:HasModule(self.options.module) and Violation:GetModule(self.options.module)
	if target == "player" then target = name end
	return mod and mod:Report(target)
end

