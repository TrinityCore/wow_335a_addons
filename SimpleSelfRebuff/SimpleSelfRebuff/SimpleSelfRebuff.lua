-------------------------------------------------------------------------------
-- Localization libraries
-------------------------------------------------------------------------------

-- Use a developping locale, so that I can put anything in L
local L = LibStub("AceLocale-3.0"):GetLocale("SimpleSelfRebuff")
--local L = setmetatable({}, {__index=function(t,k) t[k]=k return k end})

-------------------------------------------------------------------------------
-- Globals made local
-------------------------------------------------------------------------------

local _G = _G
local pairs = _G.pairs
local ipairs = _G.ipairs
local next = _G.next
local select = _G.select
local tonumber = _G.tonumber
local setmetatable = _G.setmetatable
local rawget = _G.rawget
local type = _G.type

local IsMounted = _G.IsMounted
local IsStealthed = _G.IsStealthed
local IsFlying = _G.IsFlying
local IsResting = _G.IsResting
local GetWeaponEnchantInfo = _G.GetWeaponEnchantInfo
local GetInventorySlotInfo = _G.GetInventorySlotInfo
local GetTrackingTexture = _G.GetTrackingTexture
local UnitBuff = _G.UnitBuff
local GetSpellName = _G.GetSpellName
local GetItemInfo = _G.GetItemInfo

local bit_band = _G.bit.band
local bit_bor  = _G.bit.bor

-------------------------------------------------------------------------------
-- Libraries
-------------------------------------------------------------------------------

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-------------------------------------------------------------------------------
-- Aliases & constants
-------------------------------------------------------------------------------

local activationCheckEvents = {
	'PLAYER_DEAD', 'PLAYER_UNGHOST', 'PLAYER_ALIVE', 'PLAYER_UPDATE_RESTING',
	'PLAYER_ENTERING_WORLD', 'PLAYER_LEAVING_WORLD',
}

local CATEGORY_TRACKING = L["Tracking"] or "Tracking"
local CATEGORY_MAINHAND = L["Main weapon"] or "Main weapon"
local CATEGORY_OFFHAND  = L["Off-hand weapon"] or "Off-hand weapon"

local SOURCE_SPELL    = 'spell'
local SOURCE_TRACKING = 'tracking'

local TARGET_AURA     = 'aura'
local TARGET_TRACKING = 'tracking'
local TARGET_MAINHAND = 'main-hand'
local TARGET_OFFHAND  = 'off-hand'

local STATE_SET      = 0x0001
local STATE_FOUND    = 0x0002
local STATE_EXPIRING = 0x0004
local STATE_QUIET    = 0x0008
local STATE_DONTCAST = 0x0010
local STATE_ANY      = 0x001F

-------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------

local categories = {}
local sources = {}
local targets = {}

local buffToCast

local monitoringActive

local db, db_char

-------------------------------------------------------------------------------
-- Addon declaration
-------------------------------------------------------------------------------

SimpleSelfRebuff = LibStub("AceAddon-3.0"):NewAddon("SimpleSelfRebuff",
	"AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0"
	,"LibDebugLog-1.0"
)
local SimpleSelfRebuff = SimpleSelfRebuff


-- Static early initialization
--[===[@alpha@
local debugOptions
--@end-alpha@]===]
do
	local self = SimpleSelfRebuff

	self.options = {
		handler = self,
		type = 'group',
		args = {
			general = {
				order = 10,
				name = L['General'],
				type = 'group',
				args = {
					rebuffThreshold = {
						type = 'range',
						name = L["Rebuff time threshold"],
						desc = L["Any buff with remaining time less than this value will be recast. Select 0 to disable."],
						min = 0,
						max = 180,
						step = 1,
						bigStep = 5,
						get = function() return db.rebuffThreshold end,
						set = function(info, value)
							db.rebuffThreshold = value
							self:CheckRebuff()
						end,
					},
					resting = {
						type = 'toggle',
						name = L["Disable while resting"],
						desc = L["Disable rebuffing at inn and in major cities."],
						get  = function() return db.disableWhileResting end,
						set  = function(info, v)
							db.disableWhileResting = v
							self:CheckActivation()
						end,
					},
					shiftOverrides = {
						type = 'toggle',
						name = L["Override with Shift"],
						desc = L["When enabled, use Shift to enforce the selected buff in multi-choice categories like trackings, aspects, ..."],
						get  = function() return db.shiftOverrides end,
						set  = function(info, v)
							db.shiftOverrides = v
							self:CheckRebuff()
						end,
					},
				},
			},
			buffs = {
				name = L['Buff selection'],
				type = 'group',
				order = 20,
				args = {}
			},
			modules = {
				name = L['Modules'],
				type = 'group',
				order = 30,
				args = {
					enable = {
						name = L['Enabled modules'],
						order = 10,
						type = 'multiselect',
						values = 'GetModuleList',
						get = function(info, name)
							return db.modules[name]
						end,
						set = function(inf, name, value)
							db.modules[name] = not not value
							if value then
								SimpleSelfRebuff:EnableModule(name)
							else
								SimpleSelfRebuff:DisableModule(name)
							end
						end,
					},
				},
			},
		},
	}

--[===[@alpha@	
	debugOptions ={
		name = 'Debugging',
		type = 'group',
		order = 35,
		args = {
			diag = {
				type = 'execute',
				name = L['Diagnostic'],
				desc = 'Dump some data to help bug fixing. Please includes this output into your bug reports.',
				func = 'DumpDiagnostic',
				order = 100,
			},
			debug = LibStub('LibDebugLog-1.0'):GetAce3OptionTable(SimpleSelfRebuff, 110),
			debugHeader = {
				name = 'Module debugging',
				type = 'header',
				order = 115,
			},
		},
	}
--@end-alpha@]===]

	self.CATEGORY_TRACKING = CATEGORY_TRACKING
	self.CATEGORY_MAINHAND = CATEGORY_MAINHAND
	self.CATEGORY_OFFHAND  = CATEGORY_OFFHAND

	self.SOURCE_SPELL    = SOURCE_SPELL
	self.SOURCE_TRACKING = SOURCE_TRACKING

	self.TARGET_AURA     = TARGET_AURA
	self.TARGET_TRACKING = TARGET_TRACKING
	self.TARGET_MAINHAND = TARGET_MAINHAND
	self.TARGET_OFFHAND  = TARGET_OFFHAND

	self.STATE_SET      = STATE_SET
	self.STATE_FOUND    = STATE_FOUND
	self.STATE_EXPIRING = STATE_EXPIRING
	self.STATE_QUIET    = STATE_QUIET
	self.STATE_DONTCAST  = STATE_DONTCAST

	self.L = L

--[===[@debug@
	SSR = self

	self.categories = categories
	self.sources = sources
	self.targets = targets
--@end-debug@]===]
end

-------------------------------------------------------------------------------
-- Internal signaling system
-------------------------------------------------------------------------------

do
	local mixin = {}
	local signals = LibStub('CallbackHandler-1.0'):New(mixin,
		"RegisterSignal", "UnregisterSignal", "UnregisterAllSignals"
	)
	function mixin:SendSignal(...) return signals:Fire(...) end

	function SimpleSelfRebuff:EmbedSignals(target)
		for k,v in pairs(mixin) do
			target[k] = v
		end
	end

	SimpleSelfRebuff:EmbedSignals(SimpleSelfRebuff)
end

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

local error = error

local function err(msg, ...)
	if select('#', ...) > 0 then
		msg = msg:format(tostringall(...))
	end
	return error(msg, 3)
end


local function warn(msg, ...)
	if select('#', ...) > 0 then
		msg = msg:format(tostringall(...))
	end
	local _, ret = pcall(error, msg, 3)
	geterrorhandler()(ret)
end

local function erase(...)
	for i=1,select('#', ...) do
		local t = select(i, ...)
		if type(t) == 'table' then
			for k in pairs(t) do
				t[k] = nil
			end
		end
	end
end
SimpleSelfRebuff.erase = erase

local function loadHash(t, ...)
	for i = 1, select('#', ...), 2 do
		local k,v = select(i, ...)
		if t[k] == nil then
			t[k] = v
		end
	end
end

local function colorize(text, r, g, b)
	return ("|cff%02x%02x%02x%s|r"):format(math.floor(r*255), math.floor(g*255), math.floor(b*255), text or "")
end
SimpleSelfRebuff.colorize = colorize

local new, del
do
	local list = setmetatable({}, {__mode='k'})

	function new(...)
		local t = next(list)
		if t then
			list[t] = nil
			for i = 1, select('#', ...) do
				t[i] = select(i, ...)
			end
			return t
		else
			return {...}
		end
	end
	function del(t)
		if type(t) == 'table' then
			setmetatable(t, nil)
			for k in pairs(t) do
				t[k] = nil
			end
			list[t] = true
		end
		return nil
	end
end
SimpleSelfRebuff.new = new
SimpleSelfRebuff.del = del

-- Formatter

local function formatDuration(duration, default)
	if not duration or duration < 1 then
		return default or "-"
	elseif duration >= 3600 then
		return HOUR_ONELETTER_ABBR:format(math.ceil(duration/3600))
	elseif duration >= 60 then
		return MINUTE_ONELETTER_ABBR:format(math.ceil(duration/60))
	else
		return SECOND_ONELETTER_ABBR:format(duration)
	end
end
SimpleSelfRebuff.formatDuration = formatDuration

-------------------------------------------------------------------------------
-- Initializing
-------------------------------------------------------------------------------

-- Addon setup
function SimpleSelfRebuff:OnInitialize()
	self.date = string.sub("$Date: 2008-11-26 15:48:21 +0000 (Wed, 26 Nov 2008) $", 8, 17)

	self.db = LibStub("AceDB-3.0"):New("SimpleSelfRebuffDB", {
		profile = {
			rebuffThreshold = 30,
			disableWhileResting = false,
			shiftOverrides = false,
			modules = { ['*'] = true },
		},
		char = {
			categories = {}
		},
	})

	db = self.db.profile
	db_char = self.db.char

	-- AceDebug-2.0 compat layer
	self.SetDebugging = self.ToggleDebugLog
	self.IsDebugging = self.IsDebugLogEnabled

	-- Register options and chat commands
	AceConfig:RegisterOptionsTable(self.name, self.options)
	AceConfigDialog:SetDefaultSize(self.name, 450, 500)
	self:RegisterChatCommand("ssr", "ChatCommand")
	self:RegisterChatCommand("simpleselfrebuff", "ChatCommand")

--[===[@alpha@
	-- Debug config
	AceConfig:RegisterOptionsTable(self.name..'_DEBUG', debugOptions)
--@end-alpha@]===]

	-- Blizzard panel
	AceConfigDialog:AddToBlizOptions(self.name, self.name)

	-- Look for loadable modules
	self:ScanLoadOnDemandModules()
end

function SimpleSelfRebuff:OpenGUI()
	AceConfigDialog:Open(self.name)
end

function SimpleSelfRebuff:ChatCommand(input)
	if not input or input:trim() == "" then
		self:OpenGUI()
--[===[@alpha@	
	elseif input == "debug" then
		AceConfigDialog:Open(self.name..'_DEBUG')
--@end-alpha@]===]
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(self, "ssr", self.name, input == "help" and "" or input)
	end
end

local first = true
function SimpleSelfRebuff:OnEnable()

	if first then
		self:SetupEnabledModules()
		first = false
	end

	self:RegisterBucketEvent(activationCheckEvents, 0, 'CheckActivation')
	self:RegisterSignal('BuffChanged', 'CheckRebuff')
	self:RegisterSignal('HeartBeat', 'CheckRebuff')
	self:RegisterSignal('AvailableBuffsChanged')
	self:RegisterEvent('MODIFIER_STATE_CHANGED', 'ModifierStateChanged')

	self:ProcessRegistry()
	self:RegisterSignal('RegistryUpdated', 'ProcessRegistry')

	self:CheckActivation()
end

function SimpleSelfRebuff:OnDisable(first)
	self:SetMonitoringActive(false)
end

function SimpleSelfRebuff:AvailableBuffsChanged()
	self:UpdateCategories()
	self:CheckActivation()
end

function SimpleSelfRebuff:ModifierStateChanged(event, modifierKey)
	if db.shiftOverrides and modifierKey == 'LSHIFT' or modifierKey == 'RSHIFT' then
		self:CheckRebuff();
	end
end

function SimpleSelfRebuff:UpdateCategories()
	for name, category in pairs(categories) do
		category:Update()
	end
end

function SimpleSelfRebuff:IterateCategories(stateMask)
	local name = nil
	stateMask = stateMask and bit_band(stateMask, STATE_ANY)

	local function iterator()
		local category, state, expected, actual, timeLeft
		repeat
			name, category = next(categories, name)
			if not category then
				return
			end
			state, expected, actual, timeLeft = category:GetState()
		until not stateMask or bit_band(state, stateMask) ~= 0
		return category, state, expected, actual, timeLeft
	end

	return iterator
end

function SimpleSelfRebuff:DumpDiagnostic()
	self:Print("Version v2.0.4-beta-5")
	self:Print("=== Categories ===")
	for categoryName, category in pairs(categories) do
		self:Print(("* %s: selected=%q, actual=%q"):format(
			tostring(categoryName),
			tostring(category:GetExpectedBuff()),
			tostring(category:GetActualBuff())
		))
	end
	self:Print("=== Buff targets ===")
	for name,target in pairs(targets) do
		if type(target.DumpDiagnostic) == "function" then
			self:Print(("* %s:"):format(name))
			target:DumpDiagnostic()
		end
	end
end

-------------------------------------------------------------------------------
-- Options handling
-------------------------------------------------------------------------------

do

	local function getBuffOption(info)
		local category = info.arg
		local buff = category:GetExpectedBuff()
		if info.option.type == 'toggle' then
			return buff and buff.name == category.name
		else
			return buff and buff.name or ''
		end
	end

	local function setBuffOption(info, value)
		local category = info.arg
		local buff = category:GetExpectedBuff()
		if info.option.type == 'toggle' then
			category:SetExpectedBuff(value and category.name or nil)
		else
			category:SetExpectedBuff(value ~= '' and value or nil)
		end
	end

	local getBuffValues
	do
		local tmp = {}
		function getBuffValues(info)
			erase(tmp)
			local category = info.arg
			tmp[''] = L["None"]
			for name,buff in pairs(category.buffs) do
				if buff:IsCastable() then
					tmp[buff.name] = buff.name
				end
			end
			return tmp
		end
	end

	function SimpleSelfRebuff:BuildOptions()
		local opts = self.options.args.buffs.args
		for categoryName, category in pairs(categories) do
			local categoryName, category = categoryName, category
			local catKey = categoryName:gsub('%W+', '')
			if not opts[catKey] then
				local option = {
					name = categoryName,
					desc = categoryName,
					arg = category,
					get = getBuffOption,
					set = setBuffOption,
					hidden = function() return category.found == 0 end,
					disabled = function() return category.castable == 0 end,
					order = 200,
				}
				if category.count == 1 and next(category.buffs) == categoryName then
					option.type = 'toggle'
				else
					option.type = 'select'
					option.values = getBuffValues
				end
				opts[catKey] = option
			end
		end
	end

end

-------------------------------------------------------------------------------
-- Activation
-------------------------------------------------------------------------------

function SimpleSelfRebuff:SendHeartBeat()
	self:SendSignal('HeartBeat')
end

function SimpleSelfRebuff:SetMonitoringActive(value)
	if value and not monitoringActive then
		monitoringActive = true
		self:Debug('Activated')

		if not self.heartBeatTimer then
			self.heartBeatTimer = self:ScheduleRepeatingTimer('SendHeartBeat', 1.5)
		end

		self:SendSignal('MonitoringEnabled')
		self:SendSignal('UpdateDisplay')

	elseif not value and monitoringActive then
		monitoringActive = nil
		self:Debug('Disactivated')

		if self.heartBeatTimer then
			self:CancelTimer(self.heartBeatTimer, true)
			self.heartBeatTimer = nil
		end

		self:SendSignal('MonitoringDisabled')
		self:SendSignal('UpdateDisplay')
	end
end

function SimpleSelfRebuff:CheckActivation()
	self:SetMonitoringActive(IsLoggedIn() and not ( UnitIsDeadOrGhost('player') or (db.disableWhileResting and IsResting()) ))
end

function SimpleSelfRebuff:IsMonitoringActive()
	return monitoringActive
end

-------------------------------------------------------------------------------
-- Core
-------------------------------------------------------------------------------

function SimpleSelfRebuff:CheckRebuff()
	for categoryName,category in pairs(categories) do
		category:RefreshState()
	end
end

-------------------------------------------------------------------------------
-- Module handling
-------------------------------------------------------------------------------

do
	local lodModules = {}

	local function isContainedIn(value, ...)
		for i = 1, select('#', ...) do
			if value == select(i, ...) then
				return true
			end
		end
		return false
	end

	local function LoadModule(self, name)
		local addon = lodModules[name]
		if not addon or IsAddOnLoaded(addon) then
			lodModules[name] = nil
		else
			loaded, reason = LoadAddOn(addon)
			if not loaded then
				self:Print(L["Could not load module %q: %s"]:format(name, reason))
			end
		end
	end

	do
		local tmp = {}
		function SimpleSelfRebuff:GetModuleList()
			erase(tmp)
			for name in pairs(lodModules) do
				tmp[name] = name
			end
			for name in self:IterateModules() do
				tmp[name] = name
			end
			return tmp
		end
	end

	function SimpleSelfRebuff:ScanLoadOnDemandModules()
		for i = 1,GetNumAddOns() do
			if not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
				local name = GetAddOnInfo(i)
				local moduleName = name:match('^SimpleSelfRebuff_(%w+)$')
				if  moduleName and isContainedIn('SimpleSelfRebuff', GetAddOnDependencies(i)) then
					lodModules[moduleName] = name
				end
			end
		end
	end

	function SimpleSelfRebuff:SetupEnabledModules()
		for name in pairs(lodModules) do
			if db.modules[name] then
				LoadModule(self, name)
			end
		end
		for name,module in self:IterateModules() do
			module:SetEnabledState(not not db.modules[name])
		end
	end

	function SimpleSelfRebuff:EnableModule(name)
		LoadModule(self, name)
		self:GetModule(name):Enable()
	end

	function SimpleSelfRebuff:OnModuleCreated(module)
		--[===[@alpha@
		if type(module.Debug) == 'function' then
			local opts = debugOptions.args
			local opt = LibStub('LibDebugLog-1.0'):GetAce3OptionTable(module, 120)
			opt.name = module.moduleName
			opts['debug_'..module.moduleName] = opt
		end
		--@end-alpha@]===]
		lodModules[module.moduleName] = nil
	end

end

-------------------------------------------------------------------------------
-- Module prototype
-------------------------------------------------------------------------------

local modulePrototype = { core = SimpleSelfRebuff }

SimpleSelfRebuff:EmbedSignals(modulePrototype)

SimpleSelfRebuff.modulePrototype = modulePrototype
SimpleSelfRebuff:SetDefaultModuleLibraries('AceEvent-3.0', 'LibDebugLog-1.0')
SimpleSelfRebuff:SetDefaultModulePrototype(modulePrototype)
SimpleSelfRebuff:SetDefaultModuleState(false)

function modulePrototype:RegisterOptions(options)
	options.handler = self
	options.disabled = false
	options.hidden = function(info) return not self:IsEnabled() end
	self.core.options.args.modules.args[self.moduleName] = options
end

function modulePrototype:RegisterNamespace(defaults)
	return self.core.db:RegisterNamespace(self.moduleName, defaults)
end

-------------------------------------------------------------------------------
-- Minimal class implementation
-------------------------------------------------------------------------------

local Class
do
	local ClassRoot = {
		prototype = {
			init = function() end
		},
		new = function(self, ...)
			local class = self
			local instance = setmetatable({}, {__index = class.prototype})
			instance:init(...)
			return instance
		end
	}
	ClassRoot.prototype.class = ClassRoot

	Class = function(super, ...)
		super = super or ClassRoot

		-- Build the prototype
		local prototype = setmetatable({}, {__index = super.prototype})

		-- Embed into the prototype
		local n = select('#', ...)
		if n > 0 then
			for i=1,n do
				local lib = select(i, ...)
				if type(lib) == "string" then
					lib = LibStub(lib)
				end
				lib:Embed(prototype)
			end
		end

		-- Build the class
		local class = setmetatable({
			prototype = prototype,
			super = super
		}, {__index = super})
		prototype.class = class

		return class
	end
end
SimpleSelfRebuff.Class = Class
SimpleSelfRebuff.classes = {}

-------------------------------------------------------------------------------
-- Base buff class
-------------------------------------------------------------------------------

local CategoryClass, BuffClass

BuffClass = Class()
SimpleSelfRebuff.classes.Buff = BuffClass

function BuffClass.prototype:init(name, category, source, target, ...)
	if type(name) ~= 'string' then
		err('Argument #2 to BuffClass:new() should be a string, not %q', type(name))
	end

	loadHash(self, ...)
	self.name = name
	self.category = category
	self.source = source
	self.target = target

	BuffClass.super.prototype.init(self)

	source:RegisterBuff(self)
	target:RegisterBuff(self)
end

function BuffClass.prototype:PostInit()
	if self.fallback then
		local fallbackBuff = self.category.buffs[self.fallback]
		if not fallbackBuff then
			err("Could not find fallback buff %s for %s", self.fallback, self.name)
		end
		self.fallback = fallbackBuff
	end
end

function BuffClass.prototype:ChangeName(name)
	if type(name) ~= 'string' then
		err("Argument #2 to SetName should be a string, not %q", type(name))
	elseif name == self.name then
		return
	end

	self.category.buffs[self.name] = nil
	self.target.buffs[self.name] = nil
	self.source.buffs[self.name] = nil

	self.name = name

	self.category.buffs[name] = self
	self.target.buffs[name] = self
	self.source.buffs[name] = self
end

function BuffClass.prototype:IsCastable()
	if self.found then
		if self.minLevel and UnitLevel('player') < self.minLevel then
			return false
		elseif self.maxLevel and UnitLevel('player') > self.maxLevel then
			return false
		elseif type(self.target.IsTargetValid) == "function" then
			return self.target:IsTargetValid(self)
		end
		return true
	end
	return false
end

function BuffClass.prototype:SetAsActualBuff(flag, ownBuff, timeLeft)
	if flag then
		self.category:SetActualBuff(self, ownBuff, timeLeft)
	else
		self.category:SetActualBuff(nil, nil, nil)
	end
end

function BuffClass.prototype:IsActualBuff()
	return self.category:GetActualBuff() == self
end

function BuffClass.prototype:IsExpectedBuff()
	return self.category:GetExpectedBuff() == self
end

function BuffClass.prototype:GetState()
	local state, expected, actual, timeLeft = self.category:GetState()
	if self ~= expected then
		return 0
	else
		return state, timeLeft
	end
end

function BuffClass.prototype:CustomizeState(state)
	if (IsMounted() or IsStealthed() or IsFlying()) and not self.mountFriendly then
		state = bit_bor(state, STATE_DONTCAST)
	end
	if type(self.checkRequirement) == "function" and not self:checkRequirement() then
		state = bit_bor(state, STATE_DONTCAST)
		state = bit_bor(state, STATE_QUIET)
	end
	return state
end

function BuffClass.prototype:_IsUsable()
	return self.source:IsBuffUsable(self) and self.target:IsBuffUsable(self)
end

function BuffClass.prototype:IsUsable()
	return self:_IsUsable() or (self.fallback and self.fallback:IsUsable())
end

function BuffClass.prototype:IsInCooldown()
	return self.source:IsBuffInCooldown(self)
end

function BuffClass.prototype:SetupSecureButton(button)
	if self:_IsUsable() then
		self.source:SetupSecureButton(self, button)
		self.target:SetupSecureButton(self, button)
	elseif self.fallback then
		return self.fallback:SetupSecureButton(button)
	end
end

function BuffClass.prototype:ToString()
	return '<Buff-"'..self.name..'">'
end

-------------------------------------------------------------------------------
-- Category class
-------------------------------------------------------------------------------

CategoryClass = Class()
SimpleSelfRebuff.classes.Category = CategoryClass

function CategoryClass.prototype:init(name, target, source, ...)
	if type(name) ~= 'string' then
		err('Argument #2 to CategoryClass:new() should be a string, not %q', type(name))
	end
	CategoryClass.super.prototype.init(self)
	self.name = name
	self.buffs = {}
	self.count = 0
	self.found = 0
	self.target = target or TARGET_AURA
	self.source = source or SOURCE_SPELL
	self.state = 0
	loadHash(self, ...)
end

function CategoryClass.prototype:PostInit()
	for name,buff in pairs(self.buffs) do
		buff:PostInit()
	end
end

function CategoryClass.prototype:Update()

	self.count = 0
	self.found = 0
	self.castable = 0

	for name,buff in pairs(self.buffs) do
		self.count = self.count + 1
		if buff.found then
			self.found = self.found + 1
			if buff:IsCastable() then
				self.castable = self.castable + 1
			end
		end
		if buff.name ~= name then
			self.buffs[name] = nil
			self.buffs[buff.name] = buff
		end
	end

	--[[local expected = self:GetExpectedBuff()
	if expected and not expected:IsCastable() then
		self:SetExpectedBuff(nil)
	end--]]

end

function CategoryClass.prototype:add(name, ...)

	local texture
	if type(name) == "number" then
		name, _, texture = GetSpellInfo(name)
	end
	if not name then
		err("invalid category name: %s", name);
	end
	
	if self.buffs[name] then
		err("%q already registered in category %q", name, self.name)
	end

	local source = self.source and sources[self.source]
	local target = self.target and targets[self.target]

	if not source then
		err("unknown source for %q: %q", name, self.source)
	elseif not target then
		err("unknown target for %q: %q", name, self.target)
	end

	local buff = BuffClass:new(name, self, source, target, ...)
	self.buffs[buff.name] = buff
	self.count = self.count + 1
	buff.texture = texture or buff.texture

	return self
end

function CategoryClass.prototype:addMulti(...)
	for i=1,select('#', ...) do
		local name = select(i, ...)
		self:add(name)
	end
	return self
end

function CategoryClass.prototype:GetExpectedBuff()
	local name = db_char.categories[self.name]
	local buff = name and self.buffs[name]
	if buff and buff:IsCastable() then
		return buff
	end
end

function CategoryClass.prototype:SetExpectedBuff(buff)
	local buffName
	if type(buff) == 'string' then
		buffName = buff
	elseif buff then
		buffName = buff.name
	end
	if buffName then
		if not self.buffs[buffName] then
			err("Unknown buff %q in category %q", buffName, self.name)
		elseif not self.buffs[buffName].found then
			buffName = nil
		end
	end
	if buffName ~= db_char.categories[self.name] then
		db_char.categories[self.name] = buffName
		SimpleSelfRebuff:SendSignal('BuffSetupChanged', buffName, self.name)
		self:RefreshState()
	end
end

function CategoryClass.prototype:GetActualBuff()
	local timeLeft = self.actualBuffExpiration and math.floor(self.actualBuffExpiration - GetTime())
	if not timeLeft or timeLeft <= 0 then
		timeLeft = nil
	end
	return self.actualBuff, timeLeft
end

function CategoryClass.prototype:SetActualBuff(current, ownBuff, timeLeft, debug)
	if current and not ownBuff then
		local expected = self:GetExpectedBuff()
		if expected and (expected.subcat or current.subcat) and expected.subcat ~= current.subcat then
			return
		end
	end
	local expiration = (current and type(timeLeft) == "number" and math.floor(GetTime() + timeLeft)) or nil
	local delta = math.abs((expiration or 0) - (self.actualBuffExpiration or 0))
	local dirty = (current ~= self.actualBuff) or (delta >= 2)
	self.actualBuff = current
	self.actualBuffExpiration = expiration
	if dirty then
		if debug then
			SimpleSelfRebuff:Debug('%s buff changed : %q (%q)', self.name, current and current.name, current and expiration and expiration-GetTime())
		end
		SimpleSelfRebuff:SendSignal('BuffChanged')
		self:RefreshState()
		return true
	end
end

do
	local t = {}
	function SimpleSelfRebuff:fmtState(state)
		for k in pairs(t) do t[k] = nil end
		state = state or 0
		if bit_band(state, STATE_SET) ~= 0 then
			table.insert(t, 'set')
		end
		if bit_band(state, STATE_FOUND) ~= 0 then
			table.insert(t, 'found')
		end
		if bit_band(state, STATE_EXPIRING) ~= 0 then
			table.insert(t, 'expiring')
		end
		if bit_band(state, STATE_DONTCAST) ~= 0 then
			table.insert(t, 'dontcast')
		end
		if bit_band(state, STATE_QUIET) ~= 0 then
			table.insert(t, 'quiet')
		end
		return table.concat(t, ',') .. (" (%X)"):format(state)
	end
end

function CategoryClass.prototype:RefreshState()
	local newState = 0
	local actual, timeLeft
	local expected = self:GetExpectedBuff()

	if expected then
		newState = bit_bor(newState, STATE_SET)
		actual, timeLeft = self:GetActualBuff()
		if actual then
			if expected == actual or not (db.shiftOverrides and IsShiftKeyDown()) then
				newState = bit_bor(newState, STATE_FOUND)
				if timeLeft and db.rebuffThreshold and timeLeft < db.rebuffThreshold then
					newState = bit_bor(newState, STATE_EXPIRING)
				end
			end
		end
		newState = expected:CustomizeState(newState)
	end
	--[[
	SimpleSelfRebuff:Debug('%s: expected: %q, actual: %q, timeLeft: %q, state: %s',
		self.name,
		(expected and expected.name or nil),
		(actual and actual.name or nil),
		timeLeft,
		SimpleSelfRebuff:fmtState(newState)
	)
	--]]

	return self:SetState(newState)
end

function CategoryClass.prototype:SetState(newState)
	if newState ~= self.state then
		self.state = newState
		SimpleSelfRebuff:Debug('%s state changed to %s',  self.name, SimpleSelfRebuff:fmtState(newState))
		SimpleSelfRebuff:SendSignal('StateChanged', self, self:GetState())
		return true
	end
end

function CategoryClass.prototype:GetState()
	return self.state, self:GetExpectedBuff(), self:GetActualBuff()
end

function CategoryClass.prototype:ToString()
	return '<Category-"'..self.name..'">'
end

-------------------------------------------------------------------------------
-- Some mixin helpers
-------------------------------------------------------------------------------

local BuffAspectClass, BuffSourceClass, BuffTargetClass

do

	-----------------------------------------------------------------------------
	-- Abstract buff aspect class
	-----------------------------------------------------------------------------

	BuffAspectClass = Class(nil, "AceEvent-3.0")
	SimpleSelfRebuff.classes.BuffAspect = BuffAspectClass

	SimpleSelfRebuff:EmbedSignals(BuffAspectClass.prototype)

	BuffAspectClass.virtual = true

	function BuffAspectClass.prototype:init()
		BuffAspectClass.super.prototype.init(self)
		self.allBuffs = {}
		self.buffs = {}
		self:RegisterMonitoringEvents()
		self:RegisterSignal('RegistryProcessed', 'OnRegistryProcessed', true)
	end

	function BuffAspectClass.prototype:Debug(...)
		SimpleSelfRebuff:Debug(...)
	end

	function BuffAspectClass.prototype:_delegate(methodName, ...)
		if type(self[methodName]) == "function" then
			local success, msg = pcall(self[methodName], self, ...)
			if success then
				return msg
			else
				geterrorhandler()(msg)
			end
		end
	end

	function BuffAspectClass.prototype:RegisterMonitoringEvents()
		self:RegisterSignal('MonitoringEnabled', 'OnMonitoringEnable')
		self:RegisterSignal('MonitoringDisabled', 'OnMonitoringDisable')
	end

	function BuffAspectClass.prototype:OnRegistryProcessed()
		self:_delegate('OnInitialize')
	end

	function BuffAspectClass.prototype:OnMonitoringEnable()
		if not self._enabled then
			--self:Debug('Enabling %q', self)
			self:_delegate('OnEnable')
			self._enabled = true
		end
	end

	function BuffAspectClass.prototype:OnMonitoringDisable()
		if self._enabled then
			--self:Debug('Disabling %q', self)
			self:UnregisterAllEvents()
			self:UnregisterAllSignals()
			self:_delegate('OnDisable')
			self._enabled = nil
			self:RegisterMonitoringEvents()
		end
	end

	function BuffAspectClass.prototype:RegisterBuff(buff)
		self:_delegate('OnBuffRegister', buff)
		self.buffs[buff.name] = buff
		self.allBuffs[buff] = true
	end

	-----------------------------------------------------------------------------
	-- Source buff aspect class
	-----------------------------------------------------------------------------

	BuffSourceClass = Class(BuffAspectClass)
	SimpleSelfRebuff.classes.BuffSource = BuffSourceClass

	function BuffSourceClass.prototype:init(source, buffUsableCheck, getBuffCooldown)
		BuffSourceClass.super.prototype.init(self)
		self.source = source
		sources[source] = self
	end

	function BuffSourceClass.prototype:IsBuffUsable(buff)
		return self:_IsBuffUsable(buff) and not self:IsBuffInLongCooldown(buff)
	end

	function BuffSourceClass.prototype:IsBuffInCooldown(buff)
		local start, duration = self:_GetBuffCooldown(buff)
		local endTime = duration > 0 and start + duration
		if endTime and endTime > GetTime() then
			return true, GetTime()-endTime
		else
			return false
		end
	end

	function BuffSourceClass.prototype:IsBuffInLongCooldown(buff)
		local start, duration = self:_GetBuffCooldown(buff)
		return start > 0 and duration > 1.5 and start+duration > GetTime()
	end

	function BuffSourceClass.prototype:ToString()
		return '<BuffSource-'..self.source..'>'
	end

	function BuffSourceClass.prototype:_GetBuffCooldown(buff)
		err("_GetBuffCooldown should be overriden")
	end

	function BuffSourceClass.prototype:_IsBuffUsable(buff)
		err("_IsBuffUsable should be overriden")
	end

	-----------------------------------------------------------------------------
	-- Target buff aspect class
	-----------------------------------------------------------------------------

	BuffTargetClass = Class(BuffAspectClass)
	SimpleSelfRebuff.classes.BuffTarget = BuffTargetClass

	function BuffTargetClass.prototype:init(target)
		BuffTargetClass.super.prototype.init(self)
		self.target = target
		targets[target] = self
	end

	function BuffTargetClass.prototype:ToString()
		return '<BuffTarget-'..self.target..'>'
	end

	function BuffTargetClass.prototype:IsBuffUsable(buff)
		return true
	end

	function BuffTargetClass.prototype:SetupSecureButton(buff, button)
		-- NOOP
	end

end

SimpleSelfRebuff.buffTypes = {}

-------------------------------------------------------------------------------
-- Buffs from spells
-------------------------------------------------------------------------------

do
	local SpellBuff = BuffSourceClass:new(SOURCE_SPELL, IsUsableSpell, GetSpellCooldown)
	SimpleSelfRebuff.buffTypes.Spell = SpellBuff

	function SpellBuff:OnInitialize()
		if next(self.allBuffs) then
			self:ScanSpells()
		end
	end

	function SpellBuff:OnEnable()
		if next(self.allBuffs) then
			self:RegisterEvent('SPELLS_CHANGED', 'ScanSpells')
			self:ScanSpells()
		end
	end

	function SpellBuff:ScanSpells()
		local dirty = false
		local knownSpells = new()

		local i = 1
		while true do
			local name = GetSpellName(i, BOOKTYPE_SPELL)
			if not name then
				break
			end
			knownSpells[name] = true
			i = i + 1
		end

		for buff in pairs(self.allBuffs) do
			local found = knownSpells[buff.name]
			if found and not buff.found then
				-- SimpleSelfRebuff:Debug('New spell: %q', buff.name)
				buff.found = true
				dirty = true
			elseif not found and buff.found then
				-- SimpleSelfRebuff:Debug('Old spell: %q', buff.name)
				buff.found = nil
				dirty = true
			end
		end

		knownSpells = del(knownSpells)

		if dirty then
			self:SendSignal('AvailableBuffsChanged')
		end
	end

	function SpellBuff:SetupSecureButton(buff, button)
		self:Debug('Setup casting for spell %q', buff.name)
		button:SetAttribute('*type*', 'spell')
		button:SetAttribute('*spell*', buff.name)
	end

	function SpellBuff:_GetBuffCooldown(buff)
		return GetSpellCooldown(buff.name)
	end

	function SpellBuff:_IsBuffUsable(buff)
		return IsUsableSpell(buff.name)
	end

end

-------------------------------------------------------------------------------
-- Auras
-------------------------------------------------------------------------------

do
	local AuraBuff = BuffTargetClass:new(TARGET_AURA)
	SimpleSelfRebuff.buffTypes.Aura = AuraBuff

	local scanFrame

	local function RequireAuraScan()
		scanFrame:Show()
	end

	function AuraBuff:OnEnable()
		if next(self.allBuffs) then
			if not scanFrame then
				scanFrame = CreateFrame("Frame")
				scanFrame:SetScript('OnUpdate', function()
					scanFrame:Hide()
					self:ScanAuras('OnUpdate')
				end)
				scanFrame:Hide()
			end

			self:RegisterEvent('UNIT_AURA')
			self:RegisterEvent('UNIT_AURASTATE', 'UNIT_AURA')
			self:RegisterSignal('BuffSetupChanged', RequireAuraScan)
			RequireAuraScan()
		end
	end

	function AuraBuff:OnDisable()
		if not next(self.allBuffs) and scanFrame then
			scanFrame:Hide()
		end
	end

	function AuraBuff:UNIT_AURA(event, unit)
		if unit == 'player' then
			RequireAuraScan()
		end
	end

	local function PlayerBuff(index)
		local name, _, _, _, _, duration, timeEnd, isMine = UnitBuff("player", index)
		return name, timeEnd and timeEnd-GetTime(), not not isMine 
	end

	local seen = {}
	function AuraBuff:ScanAuras(...)
		for i = 1, 512 do
			local buffName, timeLeft, isMine = PlayerBuff(i)
			if not buffName then
				break
			end
			local buff = buffName and self.buffs[buffName]
			if buff then
				seen[buff] = true
				if buff:SetAsActualBuff(true, isMine, timeLeft) then
					self:Debug('Found aura %s (%q)', buff.name, timeLeft)
				end
			end
		end

		for buff in pairs(self.allBuffs) do
			if not seen[buff] and buff:IsActualBuff() then
				self:Debug('%s faded out', buff.name)
				buff:SetAsActualBuff(false)
			end
		end

		erase(seen)
	end

	function AuraBuff:DumpDiagnostic()
		for i = 1, 32 do
			-- Only take in account buffs we actually cast
			local buffName, _, _, _, duration, timeLeft = UnitBuff('player', i)
			if not buffName then
				break
			end
			if buffName and self.buffs[buffName] then
				SimpleSelfRebuff:Print("  buff=%q, timeLeft=%q", buffName, timeLeft)
			end
		end
	end

	function AuraBuff:SetupSecureButton(buff, button)
		button:SetAttribute('*unit*', 'player')
	end

end

-------------------------------------------------------------------------------
-- Tracking
-------------------------------------------------------------------------------

do
	local TrackingBuffTarget = BuffTargetClass:new(TARGET_TRACKING)
	local AceTimer = LibStub('AceTimer-3.0')
	SimpleSelfRebuff.buffTypes.TrackingTarget = TrackingBuffTarget

	function TrackingBuffTarget:OnBuffRegister(buff)
		buff.found = true
	end

	function TrackingBuffTarget:OnEnable()
		self:RegisterEvent('MINIMAP_UPDATE_TRACKING')
		self:RegisterEvent('UNIT_AURA')
		self:RegisterSignal('BuffSetupChanged', 'ScanTracking')
		self:ScanTracking()
	end
	
	function TrackingBuffTarget:UNIT_AURA(event, unit)
		if unit == 'player' then
			self:ScanTracking()
		end
	end

	function TrackingBuffTarget:MINIMAP_UPDATE_TRACKING()
		self:ScanTracking()
		-- Rescan in 1.5 seconds, there are sometimes some kind of lag
		AceTimer.ScheduleTimer(self, "ScanTracking", 1.5)
	end
	
	function TrackingBuffTarget:ScanTracking()
		for buff in pairs(self.allBuffs) do
			local active = select(3, GetTrackingInfo(buff.trackingId))
			if active then
				SimpleSelfRebuff:Debug('Active tracking: %q', buff.name)
				buff:SetAsActualBuff(true, true)
				return
			end
		end
		for buff in pairs(self.allBuffs) do
			buff:SetAsActualBuff(false)
		end
	end
end

do
	local TrackingBuffSource = BuffSourceClass:new(SOURCE_TRACKING)
	SimpleSelfRebuff.buffTypes.TrackingSource = TrackingBuffSource

	function TrackingBuffSource:SetupSecureButton(buff, button)
		self:Debug('Setup casting for tracking %q', buff.name)
		button:SetAttribute('*type*', 'macro')
		button:SetAttribute('*macrotext*', ('/run SetTracking(%s)'):format(buff.trackingId or "nil"))
	end

	function TrackingBuffSource:_GetBuffCooldown(buff)
		if buff.trackingType == 'spell' then
			return GetSpellCooldown(buff.name)
		else
			return 0, 0
		end
	end

	function TrackingBuffSource:_IsBuffUsable(buff)
		if buff.trackingType == 'spell' then
			return IsUsableSpell(buff.name)
		else
			return true
		end
	end

end

-------------------------------------------------------------------------------
-- Weapon enchantment buff
-------------------------------------------------------------------------------

do
	local WeaponBuffClass = Class(BuffTargetClass, "AceBucket-3.0")

	function WeaponBuffClass.prototype:init(target, slotName, infoIndex, validEquipLocs)
		local slot = GetInventorySlotInfo(slotName)
		if type(slot) ~= 'number' then
			err("Invalid slot name %q => %q", slotName, slot)
		end

		WeaponBuffClass.super.prototype.init(self, target)

		self.slot = slot
		self.infoIndex = infoIndex
		self.validEquipLocs = validEquipLocs
	end

	function WeaponBuffClass.prototype:OnInitialize()
		if next(self.allBuffs) then
			self:CheckSlot()
		end
	end

	function WeaponBuffClass.prototype:OnEnable()
		if next(self.allBuffs) then
			--self:Debug('Enabling weapon buffs')
			self:RegisterBucketEvent('UNIT_INVENTORY_CHANGED', 0.5, 'CheckSlot')
			self:RegisterSignal('HeartBeat', 'ScanWeaponBuffs')
			self:RegisterSignal('BuffSetupChanged', 'ScanWeaponBuffs')
			self:CheckSlot()
			self:ScanWeaponBuffs()
		end
	end

	function WeaponBuffClass.prototype:ScanWeaponBuffs()
		local hasEnchant, timeLeft
		local category = next(self.allBuffs).category
		local expected = self.canBuff and category:GetExpectedBuff()
		if expected then
			hasEnchant, timeLeft = select(self.infoIndex, GetWeaponEnchantInfo())
		end
		if hasEnchant then
			category:SetActualBuff(expected, true, timeLeft and math.floor(timeLeft/1000) or nil, true)
		else
			category:SetActualBuff(nil, nil, nil, true)
		end
	end

	function WeaponBuffClass.prototype:CheckSlot()
		local itemLink = GetInventoryItemLink("player", self.slot)
		local itemEquipLoc = itemLink and select(9, GetItemInfo(itemLink))
		if itemEquipLoc ~= self.itemEquipLoc then
			self.itemEquipLoc = itemEquipLoc
			self.canBuff = itemEquipLoc and self.validEquipLocs[itemEquipLoc]
			self:SendSignal('AvailableBuffsChanged')
		end
	end

	function WeaponBuffClass.prototype:SetupSecureButton(buff, button)
		self:Debug('Setting up for buff %q on %q', buff.name, self.slot)
		button:SetAttribute('*target-slot*', self.slot)
	end

	function WeaponBuffClass.prototype:IsTargetValid(buff)
		return self.canBuff
	end

	WeaponBuffClass.prototype.IsBuffUsable = WeaponBuffClass.prototype.IsTargetValid

	function WeaponBuffClass.prototype:DumpDiagnostic()
		SimpleSelfRebuff:Print("  Slot: %d, itemLoc: %s", self.slot, self.itemEquipLoc)
		local hasEnchant, timeLeft, charges = select(self.infoIndex, GetWeaponEnchantInfo())
		SimpleSelfRebuff:Print("  WeaponInfo: hasEnchant=%q, timeLeft=%q, charges=%q", hasEnchant, timeLeft, charges)
	end

	SimpleSelfRebuff.buffTypes.MainHand = WeaponBuffClass:new(
		TARGET_MAINHAND,
		'MainHandSlot',
		1,
		{
			INVTYPE_WEAPON         = true,
			INVTYPE_2HWEAPON       = true,
			INVTYPE_WEAPONMAINHAND = true,
		}
	)

	SimpleSelfRebuff.buffTypes.OffHand = WeaponBuffClass:new(
		TARGET_OFFHAND,
		'SecondaryHandSlot',
		4,
		{
			INVTYPE_WEAPON         = true,
			INVTYPE_WEAPONOFFHAND  = true,
		}
	)

end

-------------------------------------------------------------------------------
-- Buff registry
-------------------------------------------------------------------------------

do
	local setupFuncs = {}

	function SimpleSelfRebuff:RegisterBuffSetup(func)
		if type(func) == "function" then
			tinsert(setupFuncs, func)
			self:SendSignal('RegistryUpdated')
		else
			err("Arg #1 to RegisterBuffs must be a function, not %q", type(func))
		end
	end

	function SimpleSelfRebuff:ProcessRegistry()
		if not #setupFuncs then
			self:Debug('no setup funcs')
			return
		end

		-- Prebuild categories
		self:GetCategory(self.CATEGORY_TRACKING, self.TARGET_TRACKING, self.SOURCE_TRACKING)
		self:GetCategory(self.CATEGORY_MAINHAND, self.TARGET_MAINHAND)
		self:GetCategory(self.CATEGORY_OFFHAND,  self.TARGET_OFFHAND)

		-- Load all funcs
		while #setupFuncs > 0 do
			func = tremove(setupFuncs)
			local success, msg = pcall(func, self, L)
			if not success then
				geterrorhandler()("Error in buff definition: " .. msg)
			end
		end

		-- Post initialization setup
		for name,category in pairs(categories) do
			category:PostInit()
		end

		self:SendSignal('RegistryProcessed')

		self:UpdateCategories()
		self:BuildOptions()
	end
end

function SimpleSelfRebuff:GetCategory(name, ...)
	if type(name) ~= 'string' then
		err("Argument #2 to GetCategory should be a string, not %q", name)
	end
	if not categories[name] then
		categories[name] = CategoryClass:new(name, ...)
	end
	return categories[name]
end

function SimpleSelfRebuff:AddStandaloneBuff(name, ...)
	local catName = name
	if type(name) == "number" then
		catName = GetSpellInfo(name)
	elseif type(name) ~= 'string' then
		err("Argument #2 to AddStandaloneBuff should be a string or a number, not %q", name)
	end
	self:GetCategory(catName):add(name, ...)
end

function SimpleSelfRebuff:AddMultiStandaloneBuffs(...)
	for i=1,select('#', ...) do
		local name = select(i, ...)
		self:AddStandaloneBuff(name)
	end
end
