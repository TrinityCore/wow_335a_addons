local _G = getfenv(0)
local gratuity = LibStub("LibGratuity-3.0")
local Dewdrop = AceLibrary("Dewdrop-2.0")
local LSM3 = LibStub("LibSharedMedia-3.0")
local tablet = AceLibrary("Tablet-2.0")

local ipairs				= _G.ipairs
local next					= _G.next
local pairs					= _G.pairs
local select				= _G.select
local tonumber				= _G.tonumber
local tostring				= _G.tostring
local type					= _G.type
local unpack				= _G.unpack

local GetInventoryItemLink		= _G.GetInventoryItemLink
local GetInventoryItemTexture	= _G.GetInventoryItemTexture
local GetInventorySlotInfo		= _G.GetInventorySlotInfo
local GetItemInfo				= _G.GetItemInfo
local GetWeaponEnchantInfo		= _G.GetWeaponEnchantInfo
local GetTrackingTexture		= _G.GetTrackingTexture
local UnitAura					= _G.UnitAura

local math_abs				= _G.math.abs

local strgmatch				= _G.string.gmatch
local strgsub				= _G.string.gsub
local strmatch				= _G.string.match
local strtrim				= _G.string.trim
local strutf8sub			= _G.string.utf8sub

local table_insert			= _G.table.insert
local table_remove			= _G.table.remove
local table_sort			= _G.table.sort

local RANK = _G.RANK

--~ local L = setmetatable({}, {__index = function(self, key) return key end})
local L = AceLibrary("AceLocale-2.2"):new("ElkBuffBars")

ElkBuffBars = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0", "FuBarPlugin-2.0")
-- ElkBuffBars = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0", "AceDebug-2.0", "FuBarPlugin-2.0")
local ElkBuffBars = ElkBuffBars
local EBB_Bar
local EBB_BarGroup
-- ElkBuffBars.debugFrame = ChatFrame4
-- ElkBuffBars:SetDebugging(true)

ElkBuffBars.revision = tonumber(string.sub("$Revision: 151 $", 12, -3)) or 1

ElkBuffBars:RegisterDB("ElkBuffBarsDB")
ElkBuffBars:RegisterDefaults("profile", {
	bargroups = {},
	groupspacing = 10,
	hidebuffframe = true,
	hidetenchframe = true,
	hidetrackingframe = true,
	nameoverride = {
		BUFF = {},
		DEBUFF = {},
		TENCH = {},
		TRACKING = {},
	},
	typeoverride = {
		BUFF = {},
		DEBUFF = {},
		TENCH = {},
		TRACKING = {},
	},
})

function ElkBuffBars:AddDefaultBargroups()
	table_insert(self.db.profile.bargroups,
		{
			["bars"] = {
				["barcolor"]			= {0.3, 0.5, 1, 0.8},								-- <color set>
				["barbgcolor"]			= {0, 0.5, 1, 0.3},									-- <color set>
			},
			["filter"] = {
				["type"] = {
					["BUFF"] = true,
					["TRACKING"] = true,
				}
			},
			anchortext = "BUFFS & TRACKING",			-- <string>
		})
	table_insert(self.db.profile.bargroups,
		{
			["bars"] = {
				["barcolor"]			= {1, 0, 0, 0.8},									-- <color set>
				["barbgcolor"]			= {1, 0, 0, 0.3},									-- <color set>
			},
			["filter"] = {
				["type"] = {
					["DEBUFF"] = true,
				}
			},
			anchortext = "DEBUFFS",						-- <string>
			anchorshown = false,						-- true, false
			stickto = 1,								-- bargroup id
			stickside = "",								-- "LEFT", "RIGHT", ""
		})
	table_insert(self.db.profile.bargroups,
		{
			["bars"] = {
				["barcolor"]			= {0.5, 0, 0.5, 0.8},								-- <color set>
				["barbgcolor"]			= {0.5, 0, 0.5, 0.3},								-- <color set>
			},
			["filter"] = {
				["type"] = {
					["TENCH"] = true,
				}
			},
			anchortext = "TENCH",						-- <string>
			anchorshown = false,						-- true, false
			stickto = 2,								-- bargroup id
			stickside = "",								-- "LEFT", "RIGHT", ""
		})
end

local STICKTO_AREA = 25

local INVENTORYSLOT_MAINHAND = GetInventorySlotInfo("MainHandSlot")
local INVENTORYSLOT_SECONDARYHAND = GetInventorySlotInfo("SecondaryHandSlot")

local scan_happend = {}
local old_hasMainHandEnchant,	old_mainHandExpiration,	old_mainHandCharges,	old_mainHandName,	old_mainHandRank
local old_hasOffHandEnchant,	old_offHandExpiration,	old_offHandCharges,		old_offHandName,	old_offHandRank

local AO_allopts
local AO_buffsettings
local AO_groupsettings

local LSM3_font = LSM3:List("font")
local LSM3_statusbar = LSM3:List("statusbar")

ElkBuffBars.ShortName = setmetatable({}, { __index = function(self, key)
	local name = key
	local shortname = ""
	if strmatch(name, "[%(%)]") then
		name = strtrim(strgsub(strgsub(name, "%b()", ""), "  +", " "))
	end
	for word in strgmatch(name, "([^ ]+)") do
		local alpha, bravo = strutf8sub(word, 1, 1), strutf8sub(word, 2)
		if strmatch(bravo, ":") then
			shortname = shortname..alpha .. ":"
		else
			shortname = shortname..alpha
		end
	end
	self[key] = shortname
	return shortname
end, })

function ElkBuffBars:OnInitialize()
	delayed_code()

	local build = select(2, _G.GetBuildInfo())
	if not self.db.account.build or self.db.account.build ~= build or true then
		self.db.account.build = build
		self.db.account.maxtimes = nil
		self.db.account.maxcharges = nil
	end
	if not self.db.account.maxtimes then
		self.db.account.maxtimes = {
			BUFF = {},
			DEBUFF = {},
			TENCH = {},
		}
	end
	if not self.db.account.maxcharges then
		self.db.account.maxcharges = {
			BUFF = {},
			DEBUFF = {},
			TENCH = {},
		}
	end
end

function ElkBuffBars:OnEnable()
	self:OnProfileEnable()
	
	-- register events
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self:RegisterBucketEvent("MINIMAP_UPDATE_TRACKING", .1)
	self:RegisterBucketEvent("PLAYER_FOCUS_CHANGED", .1)
	self:RegisterBucketEvent("PLAYER_TARGET_CHANGED", .1)
	self:RegisterBucketEvent("UNIT_PET", .1)
	self:RegisterBucketEvent("UNIT_AURA", .1)
	self:RegisterEvent("UNIT_ENTERED_VEHICLE")
	self:RegisterEvent("UNIT_EXITED_VEHICLE")
	self:ScheduleRepeatingEvent(self.DoUpdates, .5, self)
	
	LSM3.RegisterCallback(self, "LibSharedMedia_Registered", "LibSharedMedia_Update")
	LSM3.RegisterCallback(self, "LibSharedMedia_SetGlobal", "LibSharedMedia_Update")
	--
	self:ScanData_UnitAura("player", "BUFF")
	self:ScanData_UnitAura("player", "DEBUFF")
	self:ScanData_TENCH()
	self:ScanData_TRACKING()

--~ 	
--~ 	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
--~ 	

	-- hide Blizzard frames
	self:PLAYER_ENTERING_WORLD()
end

--~ 	
--~ function ElkBuffBars:UNIT_INVENTORY_CHANGED(...)
--~ 	self:PrintComma("UNIT_INVENTORY_CHANGED", ...)
--~ 	self:PrintComma(string.match(GetInventoryItemLink("player", INVENTORYSLOT_MAINHAND) or "nil", "|H(item:[^|]*)|") or "nil", string.match(GetInventoryItemLink("player", INVENTORYSLOT_SECONDARYHAND) or "nil", "|H(item:[^|]*)|") or "nil")
--~ end
--~ 	

function ElkBuffBars:OnDisable()
	self:OnProfileDisable()
	self:ClearAllData()
end

function ElkBuffBars:OnProfileEnable()
	-- add default bargroups
	if #self.db.profile.bargroups == 0 then
		self:AddDefaultBargroups()
	end
	-- check bargroups
	self:CheckLayouts()
	-- update known names
	self:UpdateKnownNames()
	-- create bargroups based on stored settings
	self:CreateBarGroups()
end

function ElkBuffBars:OnProfileDisable()
	-- recycle all bargroups
	self:RemoveBarGroups()
end

-- refresh layouts when new media is set
function ElkBuffBars:LibSharedMedia_Update(callback, type, handle)
	if type == "font" or type == "statusbar" then
		for k, v in pairs(self.bargroups) do
			v:SetLayout()
		end
	end
end

function ElkBuffBars:PLAYER_ENTERING_WORLD()
--~ 	BuffFrame:Hide()
--~ 	TemporaryEnchantFrame:Hide()
	
	self:HandleFrame_Blizzard_BuffFrame(self.db.profile.hidebuffframe)
	self:HandleFrame_Blizzard_TemporaryEnchantFrame(self.db.profile.hidetenchframe)
	self:HandleFrame_Blizzard_MiniMapTracking(self.db.profile.hidetrackingframe)
end

local hidden_blizzard_frames = {}

function ElkBuffBars:HandleFrame_Blizzard_BuffFrame(hide)
	if hide then
		BuffFrame:UnregisterEvent("UNIT_AURA")
		BuffFrame:Hide()
		hidden_blizzard_frames["BuffFrame"] = true
	elseif hidden_blizzard_frames["BuffFrame"] then
		BuffFrame:RegisterEvent("UNIT_AURA")
		BuffFrame:Show()
		BuffFrame_Update()
		hidden_blizzard_frames["BuffFrame"] = false
	end
end

function ElkBuffBars:HandleFrame_Blizzard_TemporaryEnchantFrame(hide)
	if hide then
		TemporaryEnchantFrame:Hide()
		BuffFrame:SetPoint("TOPRIGHT", "TemporaryEnchantFrame", "TOPRIGHT", 0, 0)
		hidden_blizzard_frames["TemporaryEnchantFrame"] = true
	elseif hidden_blizzard_frames["TemporaryEnchantFrame"] then
		TemporaryEnchantFrame:Show()
		hidden_blizzard_frames["TemporaryEnchantFrame"] = false
	end
end

function ElkBuffBars:HandleFrame_Blizzard_MiniMapTracking(hide)
	if hide then
		MiniMapTracking:UnregisterEvent("MINIMAP_UPDATE_TRACKING")
		MiniMapTracking:Hide()
		hidden_blizzard_frames["MiniMapTracking"] = true
	elseif hidden_blizzard_frames["MiniMapTracking"] then
		MiniMapTracking:RegisterEvent("MINIMAP_UPDATE_TRACKING")
		MiniMapTracking:Show()
		MiniMapTracking_Update()
		hidden_blizzard_frames["MiniMapTracking"] = false
	end
end

-- -----
-- cache bars
-- -----
local barcache = {}

function ElkBuffBars:GetBar()
	if #barcache > 0 then
		return table_remove(barcache, #barcache)
	else
		return EBB_Bar:new()
	end
end

function ElkBuffBars:RecycleBar(bar)
	bar:Reset()
	table_insert(barcache, bar)
end

-- -----
-- cache bargroups
-- -----
local bargroupcache = {}

function ElkBuffBars:GetBarGroup()
	if #bargroupcache > 0 then
		return table_remove(bargroupcache, #bargroupcache)
	else
		return EBB_BarGroup:new()
	end
end

function ElkBuffBars:RecycleBarGroup(bargroup)
	bargroup:Reset()
	table_insert(bargroupcache, bargroup)
end

-- -----
-- cache datatables
-- -----
local datatablecache = {}

local function GetDataTable()
	if #datatablecache > 0 then
		return table_remove(datatablecache, #datatablecache)
	else
		return {}
	end
end

local function RecycleDataTable(dt)
	table_insert(datatablecache, dt)
end

-- -----
-- known names
-- -----
ElkBuffBars.knownnames = {
	BUFF = {},
	DEBUFF = {},
	TENCH = {},
	TRACKING = {},
}

local knownnames_validate = {
	BUFF = {},
	DEBUFF = {},
	TENCH = {},
	TRACKING = {},
}


function ElkBuffBars:AddKnownName(type, name)
	if not self.knownnames[type][name] then
		self.knownnames[type][name] = true
		AO_buffsettings.args[type].args[name] = self:GetNameOptions(type, name)
		table_insert(knownnames_validate[type], name)
		table_sort(knownnames_validate[type])
	end
end

function ElkBuffBars:UpdateKnownNames()
	for type, data in pairs(self.db.profile.nameoverride) do
		for name in pairs(data) do
			self:AddKnownName(type, name)
		end
	end
	for type, data in pairs(self.db.profile.typeoverride) do
		for name in pairs(data) do
			self:AddKnownName(type, name)
		end
	end
	for id, bg in pairs(self.db.profile.bargroups) do
		if bg.filter.names_include then
			for type, data in pairs(bg.filter.names_include) do
				for name in pairs(data) do
					self:AddKnownName(type, name)
				end
			end
		end
		if bg.filter.names_exclude then
			for type, data in pairs(bg.filter.names_exclude) do
				for name in pairs(data) do
					self:AddKnownName(type, name)
				end
			end
		end
	end
end

-- -----
-- creation/removing of bargroups
-- -----
ElkBuffBars.bargroups = {}

local function ApplyDefaults(defaults, data)
	for k, v in pairs(defaults) do
		if type(v) == "table" then
			if data[k] == nil or type(data[k]) ~= "table" then data[k] = {} end
			ApplyDefaults(v, data[k])
		else
			if data[k] == nil then data[k] = v end
		end
	end
end

local DEFAULT_LAYOUT = {
	["bars"] = {
		["icon"]				= "LEFT",											-- "LEFT", "RIGHT", false
		["iconcount"]			= true,												-- true, false
		["iconcountanchor"]		= "CENTER",											-- <anchor>
		["iconcountfont"]		= "Arial Narrow",									-- <LSM3:font>
		["iconcountfontsize"]	= 14,												-- <font size>
		["iconcountcolor"]		= {1, 1, 1, 1},										-- <color set>
		["bar"]					= true,												-- true, false
		["bgbar"]				= true,												-- true, false
		["bartexture"]			= "Otravi",											-- <LSM3:statusbar>, false
		["barright"]			= false,											-- true, false
		["spark"]				= false,											-- true, false
		["textTL"]				= "NAMERANKCOUNT",									-- false, "NAME", "NAMERANK", "NAMECOUNT", "NAMERANKCOUNT", "RANK", "COUNT", "TIMELEFT", "DEBUFFTYPE"
		["textTLfont"]			= "Friz Quadrata TT",								-- <LSM3:font>
		["textTLfontsize"]		= 14,												-- <font size>
		["textTLcolor"]			= {1, 1, 1, 1},										-- <color set>
		["textTLalign"]			= "LEFT",											-- left, center, right
		["textTR"]				= "TIMELEFT",										-- false, "NAME", "NAMERANK", "NAMECOUNT", "NAMERANKCOUNT", "RANK", "COUNT", "TIMELEFT", "DEBUFFTYPE"
		["textTRfont"]			= "Friz Quadrata TT",								-- <LSM3:font>
		["textTRfontsize"]		= 14,												-- <font size>
		["textTRcolor"]			= {1, 1, 1, 1},										-- <color set>
		["textBL"]				= false,											-- false, "NAME", "NAMERANK", "NAMECOUNT", "NAMERANKCOUNT", "RANK", "COUNT", "TIMELEFT", "DEBUFFTYPE"
		["textBLfont"]			= "Friz Quadrata TT",								-- <LSM3:font>
		["textBLfontsize"]		= 14,												-- <font size>
		["textBLcolor"]			= {1, 1, 1, 1},										-- <color set>
		["textBLalign"]			= "LEFT",											-- left, center, right
		["textBR"]				= false,											-- false, "NAME", "NAMERANK", "NAMECOUNT", "NAMERANKCOUNT", "RANK", "COUNT", "TIMELEFT", "DEBUFFTYPE"
		["textBRfont"]			= "Friz Quadrata TT",								-- <LSM3:font>
		["textBRfontsize"]		= 14,												-- <font size>
		["textBRcolor"]			= {1, 1, 1},										-- <color set>
		["barcolor"]			= {0.3, 0.5, 1, 0.8},								-- <color set>
		["barbgcolor"]			= {0, 0.5, 1, 0.3},									-- <color set>
		["debufftypecolor"]		= true,												-- true, false
		["timeformat"]			= "CONDENSED",										-- "DEFAULT", "EXTENDED", "FULL", "SHORT", "CONDENSED"
		["width"]				= 250,
		["height"]				= 20,
		["tooltipanchor"]		= "default",										-- <tooltip anchor>, "default"
		timelessfull			= false,											-- true, false
		padding					= 1,												-- 0 - 10
		abbreviate_name			= 0,												--
	},
	["filter"] = {
		["type"] = {
		}
	},
	alpha			= 1,								-- alpha value
	scale			= 1,
	sorting			= "timeleft",						-- timeleft, timemax
	target			= "player",							-- player, pet, target
	growup			= false,							-- true, false
	barspacing		= 0,								-- 0+
	anchortext		= "unknown bargroup",				-- <string>
	anchorshown		= true,								-- true, false
}

-- resets corrupt entries in the given layout to default values; returns a now valid layout
function ElkBuffBars:CheckLayout(layout)
	if not layout or type(layout) ~= "table" then layout = {} end
	ApplyDefaults(DEFAULT_LAYOUT, layout)
	if layout.id and layout.stickto == layout.id then layout.stickto = nil end
	return layout
end

function ElkBuffBars:CheckLayouts()
	local bglayouts = self.db.profile.bargroups
	for k, v in ipairs(bglayouts) do
		self:CheckLayout(v)
	end
end

function ElkBuffBars:CreateBarGroups()
	for k, v in pairs(self.bargroups) do
		self:RecycleBarGroup(v)
		self.bargroups[k] = nil
	end

	local bglayouts = self.db.profile.bargroups
	for k, v in ipairs(bglayouts) do
		self:AddBarGroup(v)
	end
	for k, v in ipairs(self.bargroups) do
		local layout = bglayouts[k]
		v:SetPosition()
		v:GetContainer():Show()
	end
end

function ElkBuffBars:RemoveBarGroups()
	for k, v in pairs(self.bargroups) do
		self:RecycleBarGroup(v)
		self.bargroups[k] = nil
		AO_groupsettings[k] = nil
	end
end

function ElkBuffBars:AddBarGroup(layout)
	if not layout then
		layout = {
			["bars"] = {
			},
			["filter"] = {
				["type"] = {
					["BUFF"] = true,
				}
			},
			anchortext = "new bargroup",				-- <string>
		}

		table_insert(self.db.profile.bargroups, layout)
	end
	local bargroup = self:GetBarGroup()
	table_insert(self.bargroups, bargroup)
	layout.id = #self.bargroups
	self:CheckLayout(layout)
	bargroup:SetLayout(layout)
	table_insert(AO_groupsettings, self:GetGroupOptions(#self.bargroups))
	return bargroup
end

function ElkBuffBars:RemoveBarGroup(id)
	local bg = table_remove(self.bargroups, id)
	table_remove(self.db.profile.bargroups, id)
	for k, v in pairs(self.bargroups) do
		local layout = v.layout
		layout.id = k
		if layout.stickto then
			if layout.stickto == id then
				-- the group we sticked to was removed
				local container = v:GetContainer()
				layout.stickto = nil
				container:ClearAllPoints()
				container:SetPoint("CENTER", UIParent, "CENTER", layout.x, layout.y)
				v:ToggleAnchor(true)
			elseif layout.stickto > id then
				layout.stickto = layout.stickto - 1
			end
		end
	end
	table_remove(AO_groupsettings)
	self:RecycleBarGroup(bg)
end

function ElkBuffBars:CopyBarLayout(target, source)
	if target == source then return end
	if not source then source = DEFAULT_LAYOUT end
	target.bars = {}
	ApplyDefaults(source.bars, target.bars)
	target.sorting = source.sorting
	self.bargroups[target.id]:SetLayout()
end

-- -----
-- buff scanning
-- -----
ElkBuffBars.buffdata = {
	focus = {},
	pet = {},
	player = {},
	target = {},
	vehicle = {},
}
ElkBuffBars.debuffdata = {
	focus = {},
	pet = {},
	player = {},
	target = {},
	vehicle = {},
}
ElkBuffBars.tenchdata = {}
ElkBuffBars.trackingdata = {}

function ElkBuffBars:ClearAllData()
	for _, data in pairs(self.buffdata) do
		for k, v in pairs(data) do
			RecycleDataTable(v)
			data[k] = nil
		end
	end
	for _, data in pairs(self.debuffdata) do
		for k, v in pairs(data) do
			RecycleDataTable(v)
			data[k] = nil
		end
	end
	for k, v in pairs(self.tenchdata) do
		RecycleDataTable(v)
		self.tenchdata[k] = nil
	end
	for k, v in pairs(self.trackingdata) do
		RecycleDataTable(v)
		self.trackingdata[k] = nil
	end
end

function ElkBuffBars:MINIMAP_UPDATE_TRACKING()
	self:ScanData_TRACKING()

	self:DoUpdates()
end

function ElkBuffBars:PLAYER_FOCUS_CHANGED()
	self:ScanData_UnitAura("focus", "BUFF")
	self:ScanData_UnitAura("focus", "DEBUFF")

	self:DoUpdates()
end

function ElkBuffBars:PLAYER_TARGET_CHANGED()
	self:ScanData_UnitAura("target", "BUFF")
	self:ScanData_UnitAura("target", "DEBUFF")

	self:DoUpdates()
end

function ElkBuffBars:UNIT_PET(args)
	if args["player"] then
		self:ScanData_UnitAura("pet", "BUFF")
		self:ScanData_UnitAura("pet", "DEBUFF")

		self:DoUpdates()
	end
end

function ElkBuffBars:UNIT_ENTERED_VEHICLE(unit)
	if unit == "player" then
		self:ScanData_UnitAura("vehicle", "BUFF")
		self:ScanData_UnitAura("vehicle", "DEBUFF")

		self:DoUpdates()
	end
end

function ElkBuffBars:UNIT_EXITED_VEHICLE(unit)
	if unit == "player" then
		self:ScanData_UnitAura("vehicle", "BUFF")
		self:ScanData_UnitAura("vehicle", "DEBUFF")

		self:DoUpdates()
	end
end

local watched_unitids = { focus = true, pet = true, player = true, target = true, vehicle = true }
function ElkBuffBars:UNIT_AURA(args)
	for arg in pairs(args) do
		if watched_unitids[arg] then
			self:ScanData_UnitAura(arg, "BUFF")
			self:ScanData_UnitAura(arg, "DEBUFF")
		end
	end

	self:DoUpdates()
end

local PATTERN_RANK = RANK.." (%d+)"

function ElkBuffBars:ScanData_TENCH()
	local maxtimes = self.db.account.maxtimes.TENCH
	local maxcharges = self.db.account.maxcharges.TENCH
	for k, v in pairs(self.tenchdata) do
		RecycleDataTable(v)
		self.tenchdata[k] = nil
	end
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
	if ( hasMainHandEnchant ) then
		local timeleft = mainHandExpiration / 1000
		local timemax = timeleft
	
		local id = INVENTORYSLOT_MAINHAND
		local name, rank = self:GetTempBuffName(id)
		self:AddKnownName("TENCH", name)
		local tname = name..(rank and (" "..rank) or "")
--		if rank then
--			rank = strmatch(rank, PATTERN_RANK)
--		end
		if maxtimes[tname] and timemax < maxtimes[tname] then
			timemax = maxtimes[tname]
		else
			maxtimes[tname] = timemax
		end
		local charges = mainHandCharges or 0
		if charges > 1 and (not maxcharges[tname] or maxcharges[tname] < charges) then
			maxcharges[tname] = charges
		end

		local dt = GetDataTable()
		dt.id				= id
		dt.name				= self.db.profile.nameoverride.TENCH[name] or name
		dt.realname			= name
		dt.rank				= rank and tonumber(rank) or nil
		dt.type				= self.db.profile.typeoverride.TENCH[name] or "TENCH"
		dt.realtype			= "TENCH"
		dt.debufftype		= nil
		dt.expirytime		= timeleft + GetTime()
		dt.timemax			= timemax
		dt.untilcancelled	= nil
		dt.charges			= charges
		dt.maxcharges		= maxcharges[tname]
		dt.icon				= GetInventoryItemTexture("player", id)
		dt.ismine			= true
		
		table_insert(self.tenchdata, dt)
	end
	if ( hasOffHandEnchant ) then
		local timeleft = offHandExpiration / 1000
		local timemax = timeleft

		local id = INVENTORYSLOT_SECONDARYHAND
		local name, rank = self:GetTempBuffName(id)
		local tname = name..(rank and (" "..rank) or "")
		self:AddKnownName("TENCH", name)
--		if rank then
--			rank = strmatch(rank, PATTERN_RANK)
--		end
		if maxtimes[tname] and timemax < maxtimes[tname] then
			timemax = maxtimes[tname]
		else
			maxtimes[tname] = timemax
		end
		local charges = offHandCharges or 0
		if charges > 1 and (not maxcharges[tname] or maxcharges[tname] < charges) then
			maxcharges[tname] = charges
		end

		local dt = GetDataTable()
		dt.id				= id
		dt.name				= self.db.profile.nameoverride.TENCH[name] or name
		dt.realname			= name
		dt.rank				= rank and tonumber(rank) or nil
		dt.type				= self.db.profile.typeoverride.TENCH[name] or "TENCH"
		dt.realtype			= "TENCH"
		dt.debufftype		= nil
		dt.expirytime		= timeleft + GetTime()
		dt.timemax			= timemax
		dt.untilcancelled	= nil
		dt.charges			= charges
		dt.maxcharges		= maxcharges[tname]
		dt.icon				= GetInventoryItemTexture("player", id)
		dt.ismine			= true
		
		table_insert(self.tenchdata, dt)
	end
	scan_happend.player = true
end

function ElkBuffBars:ScanData_TRACKING()
	for k, v in pairs(self.trackingdata) do
		RecycleDataTable(v)
		self.trackingdata[k] = nil
	end
	local icon = GetTrackingTexture()
	if icon then
		local name = self:GetTrackingName()
		self:AddKnownName("TRACKING", name)
		local dt = GetDataTable()
		dt.id				= 1
		dt.name				= self.db.profile.nameoverride.TRACKING[name] or name
		dt.realname			= name
		dt.rank				= nil
		dt.type				= self.db.profile.typeoverride.TRACKING[name] or "TRACKING"
		dt.realtype			= "TRACKING"
		dt.debufftype		= nil
		dt.expirytime		= 0
		dt.timemax			= 0
		dt.untilcancelled	= true
		dt.charges			= 0
		dt.maxcharges		= nil
		dt.icon				= icon
		dt.ismine			= true
		
		table_insert(self.trackingdata, dt)
	end
	scan_happend.player = true
end


local selfcast = {
	pet = true,
	player = true,
	vehicle = true,
}
function ElkBuffBars:ScanData_UnitAura(unit, type)
	local filter = type == "DEBUFF" and "HARMFUL" or "HELPFUL"
	local maxcharges = self.db.account.maxcharges[type]
	local datatable = type == "DEBUFF" and self.debuffdata[unit] or self.buffdata[unit]
	if not datatable then return end
	for k, v in pairs(datatable) do
		RecycleDataTable(v)
		datatable[k] = nil
	end
	local i = 1
	while true do
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, i, filter)
		if not icon then break end
		local tname = name..(rank and (" "..rank) or "")
		self:AddKnownName(type, name)
		if rank then
			rank = strmatch(rank, PATTERN_RANK)
		end
		count = count or 0
		if count > 1 and (not maxcharges[tname] or maxcharges[tname] < count) then
			maxcharges[tname] = count
		end

		local dt = GetDataTable()
		dt.id				= i
		dt.name				= self.db.profile.nameoverride[type][name] or name
		dt.realname			= name
		dt.rank				= rank and tonumber(rank) or nil
		dt.type				= (self.db.profile.typeoverride[type][name] or type)
		dt.realtype			= type
		dt.debufftype		= debuffType
		dt.expirytime		= expirationTime
		dt.timemax			= duration or 0
		dt.untilcancelled	= ((not duration) or duration == 0) and true or nil
		dt.charges			= count
		dt.maxcharges		= maxcharges[tname]
		dt.icon				= icon
		dt.ismine			= unitCaster and selfcast[unitCaster] and true or false
		
		table_insert(datatable, dt)
		i = i + 1
	end
	scan_happend[unit] = true
end

local roman_to_arabic = setmetatable({I = 1, V = 5, X = 10, L = 50, C = 100, D = 500, M = 1000}, {__index=function(self, roman)
	local arabic = 0
	local maxval = 0
	for i = roman:len(), 1, -1 do
		local digitval = self[roman:sub(i,i)]
		if digitval < maxval then
			arabic = arabic - digitval
		else
			arabic = arabic + digitval
			maxval = digitval
		end
	end
	self[roman] = arabic
	return arabic
end})

function ElkBuffBars:GetTempBuffName(id)
	local rank
	gratuity:SetInventoryItem("player", id)
	local _, _, buffname = gratuity:Find("^(.+) %(%d+ [^%)]+%)$")
	if buffname then
		buffname = strgsub(buffname, " %(%d+ [^%)]+%)", "") -- remove 2nd brackets for buffs with charges
		local tname, trank = strmatch(buffname, "(.*) (%d*)$")
		if tname then
			buffname = tname
			rank = trank
		else
			local tname, trank = strmatch(buffname, "(.*) ([CDILMVX]*)$")
			if tname then
				buffname = tname
				rank = roman_to_arabic[trank]
			end
		end
		return buffname, rank
	end
	local itemlink = GetInventoryItemLink("player", id)
	if itemlink then
		local name = GetItemInfo(itemlink)
		return name or "Weapon "..id
	end
	return "Weapon "..id
end

function ElkBuffBars:GetTrackingName()
	local name, texture, active, category
	local count = GetNumTrackingTypes()
	for id=1, count do
		name, texture, active, category  = GetTrackingInfo(id)
		if active then
			return name
		end
	end
	return NONE
end

--
--
--
function ElkBuffBars:UpdateTimes(unit)
	for k, v in pairs(self.buffdata[unit]) do
		if not v.untilcancelled then
			local timemax, expirytime = select(6, UnitAura(unit, v.id, "HELPFUL"))
			if not timemax or timemax == 0 or expirytime > v.expirytime then
				self:ScanData_UnitAura(unit, "BUFF")
				break
			end
			v.expirytime = expirytime
		end
	end

	for k, v in pairs(self.debuffdata[unit]) do
		if not v.untilcancelled then
			local timemax, expirytime = select(6, UnitAura(unit, v.id, "HARMFUL"))
			if not timemax or timemax == 0 or expirytime > v.expirytime then
				self:ScanData_UnitAura(unit, "DEBUFF")
				break
			end
			v.expirytime = expirytime
		end
	end
end

function ElkBuffBars:DoFullUpdate()
	self:UNIT_AURA(watched_unitids)
	self:ScanData_TENCH()
	self:ScanData_TRACKING()
	self:DoUpdates()
end

function ElkBuffBars:DoUpdates()
	-- check for changed weaponbuffs
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
	local mainHandName, mainHandRank
	if hasMainHandEnchant then
		mainHandName, mainHandRank = self:GetTempBuffName(INVENTORYSLOT_MAINHAND)
	end
	local offHandName, offHandRank
	if hasOffHandEnchant then
		offHandName, offHandRank = self:GetTempBuffName(INVENTORYSLOT_SECONDARYHAND)
	end
	if hasMainHandEnchant ~= old_hasMainHandEnchant or (mainHandExpiration or 0) > (old_mainHandExpiration or 0) or mainHandCharges ~= old_mainHandCharges or mainHandName ~= old_mainHandName or mainHandRank ~= old_mainHandRank
		or hasOffHandEnchant ~= old_hasOffHandEnchant or (offHandExpiration or 0) > (old_offHandExpiration or 0) or offHandCharges ~= old_offHandCharges or offHandName ~= old_offHandName or offHandRank ~= old_offHandRank then
		self:ScanData_TENCH()
		old_hasMainHandEnchant = hasMainHandEnchant
		old_mainHandCharges = mainHandCharges
		old_mainHandName = mainHandName
		old_mainHandRank = mainHandRank
		old_hasOffHandEnchant = hasOffHandEnchant
		old_offHandCharges = offHandCharges
		old_offHandName = offHandName
		old_offHandRank = offHandRank
	end
	old_mainHandExpiration = mainHandExpiration
	old_offHandExpiration = offHandExpiration

--~ 	self:UpdateTimes("focus")
--~ 	self:UpdateTimes("pet")
--~ 	self:UpdateTimes("player")
--~ 	self:UpdateTimes("target")

	-- if we did a scan, update bar data
	if next(scan_happend) then
		for k, v in pairs(self.bargroups) do
			v:UpdateData(scan_happend)
		end
		for k in pairs(scan_happend) do
			scan_happend[k] = nil
		end
	else
		for k, v in pairs(self.bargroups) do
			v:UpdateTimeleft()
		end
	end
end

function ElkBuffBars:StickGroup(bargroup)
	local layout = bargroup.layout
	local id = layout.id
	local growup = layout.growup
	local container = bargroup:GetContainer()
	local base_y = growup and container:GetBottom() or container:GetTop()
	local base_left = container:GetLeft()
	local base_right = container:GetRight()
	layout.stickto = nil
--	self:Print("Sticking bargroup", id)
	for k, v in pairs(self.bargroups) do
		local comp_container = v:GetContainer()
		local comp_y = growup and comp_container:GetTop() or comp_container:GetBottom() or 0
		if v.layout.id ~= id and math_abs(comp_y - base_y) < STICKTO_AREA then
			-- we are on the same y-area
			local comp_left = comp_container:GetLeft()
			local comp_right = comp_container:GetRight()
			local dist_left = math_abs(base_left - comp_left)
			local dist_mid = math_abs((base_left + base_right) - (comp_left + comp_right)) / 2
			local dist_right = math_abs(base_right - comp_right)
			if dist_left <= STICKTO_AREA or dist_mid <= STICKTO_AREA or dist_right <= STICKTO_AREA then
--				self:Print(" - sticking to bargroup ", k)
				-- we are also on the same x-area
				-- check if we would loop-stick to ourself
				local parent = v
				local hasloop = false
				while parent.layout.stickto do
					if parent.layout.stickto == id then
--						self:Print("   - LOOP FOUND!")
						hasloop = true
						break
					end
					parent = self.bargroups[parent.layout.stickto]
				end
				if not hasloop then
					-- we have found a valid group to stick to
					layout.stickto = k
					local stickdist = STICKTO_AREA
					if dist_mid <= STICKTO_AREA then
--~ 						self:Print("   - SUCCESS! -> middle")
						layout.stickside = ""
						stickdist = dist_mid
					end
					if dist_left <= STICKTO_AREA and dist_left < stickdist then
--~ 						self:Print("   - SUCCESS! -> left")
						layout.stickside = "LEFT"
						stickdist = dist_left
					end
					if dist_right <= STICKTO_AREA and dist_right < stickdist then
--~ 						self:Print("   - SUCCESS! -> right")
						layout.stickside = "RIGHT"
						stickdist = dist_right
--~ 					else
--~ 						self:Print("   - |cffff0000ERROR|r")
					end
					bargroup:SetPosition()
					return true
				end
			end
		end
	end
	return false
end

-- -----
-- FuBar stuff
-- -----
ElkBuffBars.hasIcon = true	-- icon by Jakobud @ wowace forums
ElkBuffBars.hasNoColor = true
ElkBuffBars.clickableTooltip = true
ElkBuffBars.hideWithoutStandby = true
ElkBuffBars.independentProfile = true
ElkBuffBars.cannotDetachTooltip = true

function ElkBuffBars:OnTextUpdate()
	self:SetText("ElkBuffBars")
end

function ElkBuffBars:OnTooltipUpdate()
	local cat = tablet:AddCategory(
		'columns', 2,
		'text', L["TOOLTIP_BARGROUP"],
		'text2', L["TOOLTIP_TYPE"],
		'hideBlankLine', true,
		'showWithoutChildren', true
	)
	for k, v in ipairs(self.bargroups) do
		cat:AddLine(	"text",		tostring(k)..". "..(v.layout.anchortext or "???"),
						"text2",	v.layout.target,
						"hasCheck",	true,
						"checked",	v.layout.anchorshown,
						"func",		"ToggleAnchor",
						"arg1",		v
					)
	end
end

local typeoverride_validate
function delayed_code()
	EBB_Bar = _G.EBB_Bar
	EBB_BarGroup = _G.EBB_BarGroup

	-- -----
	-- AceOption table
	-- -----
	AO_buffsettings = {
		type = "group", name = L["OPTIONS_OVERRIDES_NAME"], desc = L["OPTIONS_OVERRIDES_DESC"], args = {
			BUFF = {
				type = "group", name = "BUFF", desc = "BUFF", args = {},
			},
			DEBUFF = {
				type = "group", name = "DEBUFF", desc = "DEBUFF", args = {},
			},
			TENCH = {
				type = "group", name = "TENCH", desc = "TENCH", args = {},
			},
			TRACKING = {
				type = "group", name = "TRACKING", desc = "TRACKING", args = {},
			},
		},
		order = 101,
	}

	AO_groupsettings = {}

	AO_allopts = {
		type = "group", args = {
			buffsettings = AO_buffsettings,
			groupsettings = {
				type = "group", name = L["OPTIONS_BARGROUPS_NAME"], desc = L["OPTIONS_BARGROUPS_DESC"], args = AO_groupsettings,
				order = 102,
			},
			newgroup = {
				type = "execute", name = L["OPTIONS_NEWGROUP_NAME"], desc = L["OPTIONS_NEWGROUP_DESC"],
				func = function()
						local bg = ElkBuffBars:AddBarGroup()
						bg:SetPosition()
						bg:GetContainer():Show()
					end,
				order = 103,
			},
			groupspacing = {
				type = "range", name = L["OPTIONS_GROUPSPACING_NAME"], desc = L["OPTIONS_GROUPSPACING_DESC"],
				min = 0, max = 50, step = 1,
				get = function() return ElkBuffBars.db.profile.groupspacing end,
				set = function(v)
						ElkBuffBars.db.profile.groupspacing = tonumber(v)
						for k, bg in ipairs(ElkBuffBars.bargroups) do
							bg:SetPosition()
						end
					end,
				order = 104,
			},
			buffframe = {
				type = "toggle", name = L["OPTIONS_HIDEBLIZZARDBUFFS_NAME"], desc = L["OPTIONS_HIDEBLIZZARDBUFFS_DESC"],
				get = function() return ElkBuffBars.db.profile.hidebuffframe end,
				set = function(v)
						ElkBuffBars.db.profile.hidebuffframe = v
						ElkBuffBars:HandleFrame_Blizzard_BuffFrame(ElkBuffBars.db.profile.hidebuffframe)
					end,
				order = 105,
			},
			tenchframe = {
				type = "toggle", name = L["OPTIONS_HIDEBLIZZARDTENCH_NAME"], desc = L["OPTIONS_HIDEBLIZZARDTENCH_DESC"],
				get = function() return ElkBuffBars.db.profile.hidetenchframe end,
				set = function(v)
						ElkBuffBars.db.profile.hidetenchframe = v
						ElkBuffBars:HandleFrame_Blizzard_TemporaryEnchantFrame(ElkBuffBars.db.profile.hidetenchframe)
					end,
				order = 105,
			},
			trackingframe = {
				type = "toggle", name = L["OPTIONS_HIDEBLIZZARDTRACKING_NAME"], desc = L["OPTIONS_HIDEBLIZZARDTRACKING_DESC"],
				get = function() return ElkBuffBars.db.profile.hidetrackingframe end,
				set = function(v)
						ElkBuffBars.db.profile.hidetrackingframe = v
						ElkBuffBars:HandleFrame_Blizzard_MiniMapTracking(ElkBuffBars.db.profile.hidetrackingframe)
					end,
				order = 105,
			},
		}
	}

	typeoverride_validate = {BUFF = "BUFF", DEBUFF = "DEBUFF", TENCH = "TENCH", TRACKING = "TRACKING", [""] = L["OPTIONS_OVERRIDES_TYPE_VALIDATE_DEFAULT"]}

	ElkBuffBars.OnMenuRequest = AO_allopts

	ElkBuffBars:RegisterChatCommand({"/ebb"}, {
		type = "group", args = {
			config = {
				type = "execute", name = "config", desc = L["CHATCOMMAND_CONFIG_DESC"],
				func = function() ElkBuffBars:ShowDewdrop() end,
			}
		}
	})
end

function ElkBuffBars:GetNameOptions(type, name)
	return {
		type = "group", name = name, desc = name, args = {
			name = {
				type = "text", name = L["OPTIONS_OVERRIDES_NAME_NAME"], desc = L["OPTIONS_OVERRIDES_NAME_DESC"], usage = "",
				get = function() return ElkBuffBars.db.profile.nameoverride[type][name] or "" end,
				set = function(v) ElkBuffBars.db.profile.nameoverride[type][name] = v ~= "" and v or nil end,
			},
			type = {
				type = "text", name = L["OPTIONS_OVERRIDES_TYPE_NAME"], desc = L["OPTIONS_OVERRIDES_TYPE_DESC"],
				get = function() return ElkBuffBars.db.profile.typeoverride[type][name] or "" end,
				set = function(v) ElkBuffBars.db.profile.typeoverride[type][name] = (v ~= "" and v ~= type) and v or nil end,
				validate = typeoverride_validate,
			}
		}
	}
end

local function SetNameFilter(groupid, white, type, name, value)
	local bg = ElkBuffBars.bargroups[groupid]
	local filter = bg.layout.filter
	local ftname = white and "names_include" or "names_exclude"
	if value then
		if not filter[ftname] then
			filter[ftname] = {}
		end
		if not filter[ftname][type] then
			filter[ftname][type] = {}
		end
		filter[ftname][type][name] = true
	elseif filter[ftname] and filter[ftname][type] then
		filter[ftname][type][name] = nil
		local hasdata = false
		for _ in pairs(filter[ftname][type]) do
			hasdata = true
			break
		end
		if not hasdata then
			filter[ftname][type] = nil
		end
		hasdata = false
		for _ in pairs(filter[ftname]) do
			hasdata = true
			break
		end
		if not hasdata then
			filter[ftname] = nil
		end
	end
	bg:UpdateData()
end

local groupoptionscache = {}
function ElkBuffBars:GetGroupOptions(id)
	if not groupoptionscache[id] then
		groupoptionscache[id] = {
			type = "group", name = (L["OPTIONS_GROUP_NAME"]):format(id), desc = (L["OPTIONS_GROUP_DESC"]):format(id), args = {
				anchorshown = {
					type = "toggle", name = L["OPTIONS_GROUP_ANCHOR_NAME"], desc = L["OPTIONS_GROUP_ANCHOR_DESC"],
					get = function() return ElkBuffBars.db.profile.bargroups[id].anchorshown end,
					set = function() ElkBuffBars.bargroups[id]:ToggleAnchor() end,
					order = 101,
				},
				anchortext = {
					type = "text", name = L["OPTIONS_GROUP_NAME_NAME"], desc = L["OPTIONS_GROUP_NAME_DESC"], usage = "",
					get = function() return ElkBuffBars.db.profile.bargroups[id].anchortext end,
					set = function(v)
							local bg = ElkBuffBars.bargroups[id]
							bg.layout.anchortext = v
							if bg.layout.anchorshown then
								bg:ToggleAnchor(true)
							end
						end,
					order = 102,
				},
				bars = {
					type = "group", name = L["OPTIONS_GROUP_BARLAYOUT_NAME"], desc = L["OPTIONS_GROUP_BARLAYOUT_DESC"], args = {
						bar = {
							type = "group", name = L["OPTIONS_GROUP_BAR_NAME"], desc = L["OPTIONS_GROUP_BAR_DESC"], args = {
								bar = {
									type = "toggle", name = L["OPTIONS_GROUP_BAR_SHOW_NAME"], desc = L["OPTIONS_GROUP_BAR_SHOW_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.bar end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.bar = v
											bg:SetLayout()
										end,
									order = 101,
								},
								bartexture = {
									type = "text", name = L["OPTIONS_GROUP_BAR_TEXTURE_NAME"], desc = L["OPTIONS_GROUP_BAR_TEXTURE_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.bartexture end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.bartexture = v
											bg:SetLayout()
										end,
									validate = LSM3_statusbar,
									order = 102,
								},
								barcolor = {
									type = "color", name = L["OPTIONS_GROUP_BAR_COLOR_NAME"], desc = L["OPTIONS_GROUP_BAR_COLOR_DESC"],
									get = function() return unpack(ElkBuffBars.db.profile.bargroups[id].bars.barcolor) end,
									set = function(r, g, b, a)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.barcolor[1] = r
											bg.layout.bars.barcolor[2] = g
											bg.layout.bars.barcolor[3] = b
											bg.layout.bars.barcolor[4] = a
											bg:SetLayout()
											if bg.layout.anchorshown then
												bg:ToggleAnchor(true)
											end
										end,
									hasAlpha = true,
									order = 103,
								}, -- <color set>
								bgbar = {
									type = "toggle", name = L["OPTIONS_GROUP_BAR_BGSHOW_NAME"], desc = L["OPTIONS_GROUP_BAR_BGSHOW_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.bgbar end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.bgbar = v
											bg:SetLayout()
										end,
									order = 104,
								},
								barbgcolor = {
									type = "color", name = L["OPTIONS_GROUP_BAR_BGCOLOR_NAME"], desc = L["OPTIONS_GROUP_BAR_BGCOLOR_DESC"],
									get = function() return unpack(ElkBuffBars.db.profile.bargroups[id].bars.barbgcolor) end,
									set = function(r, g, b, a)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.barbgcolor[1] = r
											bg.layout.bars.barbgcolor[2] = g
											bg.layout.bars.barbgcolor[3] = b
											bg.layout.bars.barbgcolor[4] = a
											bg:SetLayout()
										end,
									hasAlpha = true,
									order = 105,
								}, -- <color set>
								spark = {
									type = "toggle", name = L["OPTIONS_GROUP_BAR_SPARK_NAME"], desc = L["OPTIONS_GROUP_BAR_SPARK_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.spark end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.spark = v
											bg:SetLayout()
										end,
									order = 106,
								},
								debufftypecolor = {
									type = "toggle", name = L["OPTIONS_GROUP_BAR_DEBUFFCOLOR_NAME"], desc = L["OPTIONS_GROUP_BAR_DEBUFFCOLOR_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.debufftypecolor end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.debufftypecolor = v
											bg:UpdateBars()
										end,
									order = 107,
								},
								barright = {
									type = "toggle", name = L["OPTIONS_GROUP_BAR_LTRDIR_NAME"], desc = L["OPTIONS_GROUP_BAR_LTRDIR_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.barright end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.barright = v
											bg:SetLayout()
										end,
									order = 108,
								},
								timelessfull = {
									type = "toggle", name = L["OPTIONS_GROUP_BAR_TIMELESSFULL_NAME"], desc = L["OPTIONS_GROUP_BAR_TIMELESSFULL_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.timelessfull end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.timelessfull = v
											bg:UpdateData()
										end,
									order = 109,
								},
							},
							order = 101,
						},
						icon = {
							type = "group", name = L["OPTIONS_GROUP_ICON_NAME"], desc = L["OPTIONS_GROUP_ICON_DESC"], args = {
								icon = {
									type = "text", name = L["OPTIONS_GROUP_ICON_POSITION_NAME"], desc = L["OPTIONS_GROUP_ICON_POSITION_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.icon or "false" end,
									set = function(v)
											if v == "false" then v = false end
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.icon = v
											bg:SetLayout()
										end,
									validate = {["false"] = L["OPTIONS_GROUP_ICON_POSITION_HIDE"], ["LEFT"] = L["OPTIONS_GROUP_ICON_POSITION_LEFT"], ["RIGHT"] = L["OPTIONS_GROUP_ICON_POSITION_RIGHT"]},
									order = 101,
								}, -- "LEFT", "RIGHT", false
								iconcount = {
									type = "toggle", name = L["OPTIONS_GROUP_ICON_STACK_SHOW_NAME"], desc = L["OPTIONS_GROUP_ICON_STACK_SHOW_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.iconcount end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.iconcount = v
											bg:SetLayout()
										end,
									order = 102,
								}, -- true, false
								iconcountanchor = {
									type = "text", name = L["OPTIONS_GROUP_ICON_STACK_ANCHOR_NAME"], desc = L["OPTIONS_GROUP_ICON_STACK_ANCHOR_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.iconcountanchor end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.iconcountanchor = v
											bg:SetLayout()
										end,
									validate = {"TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT"},
									order = 103,
								}, -- <anchor>
								iconcountfont = {
									type = "text", name = L["OPTIONS_GROUP_ICON_STACK_FONT_NAME"], desc = L["OPTIONS_GROUP_ICON_STACK_FONT_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.iconcountfont end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.iconcountfont = v
											bg:SetLayout()
										end,
									validate = LSM3_font,
									order = 104
								}, -- <LSM3:font>
								iconcountfontsize =  {
									type = "range", name = L["OPTIONS_GROUP_ICON_STACK_FONTSIZE_NAME"], desc = L["OPTIONS_GROUP_ICON_STACK_FONTSIZE_DESC"],
									min = 4, max = 32, step = 1,
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.iconcountfontsize end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.iconcountfontsize = tonumber(v)
											bg:SetLayout()
										end,
									order = 105,
								}, -- <font size>
								iconcountcolor = {
									type = "color", name = L["OPTIONS_GROUP_ICON_STACK_FONTCOLOR_NAME"], desc = L["OPTIONS_GROUP_ICON_STACK_FONTCOLOR_DESC"],
									get = function() return unpack(ElkBuffBars.db.profile.bargroups[id].bars.iconcountcolor) end,
									set = function(r, g, b, a)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.iconcountcolor[1] = r
											bg.layout.bars.iconcountcolor[2] = g
											bg.layout.bars.iconcountcolor[3] = b
											bg.layout.bars.iconcountcolor[4] = a
											bg:SetLayout()
										end,
									hasAlpha = true,
									order = 106,
								}, -- <color set>
							},
							order = 102
						},
						texttl = {
							type = "group", name = L["OPTIONS_GROUP_TEXTTL_NAME"], desc = L["OPTIONS_GROUP_TEXTTL_DESC"], args = {
								textTL = {
									type = "text", name = L["OPTIONS_GROUP_TEXT_TEMPLATE_NAME"], desc = L["OPTIONS_GROUP_TEXT_TEMPLATE_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textTL or "false" end,
									set = function(v)
											if v == "false" then v = false end
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textTL = v
											bg:SetLayout()
										end,
									validate = {
										["false"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_HIDE"],
										["NAME"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAME"],
										["NAMERANK"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANK"],
										["NAMECOUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMECOUNT"],
										["NAMERANKCOUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANKCOUNT"],
										["RANK"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_RANK"],
										["COUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_COUNT"],
										["TIMELEFT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_TIMELEFT"],
										["DEBUFFTYPE"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_DEBUFFTYPE"]
									},
									order = 101,
								}, -- false, "NAME", "NAMERANK", "NAMECOUNT", "NAMERANKCOUNT", "RANK", "COUNT", "TIMELEFT", "DEBUFFTYPE"
								textTLfont = {
									type = "text", name = L["OPTIONS_GROUP_TEXT_FONT_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONT_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textTLfont end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textTLfont = v
											bg:SetLayout()
										end,
									validate = LSM3_font,
									order = 102,
								}, -- <LSM3:font>
								textTLfontsize = {
									type = "range", name = L["OPTIONS_GROUP_TEXT_FONTSIZE_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONTSIZE_DESC"],
									min = 4, max = 32, step = 1,
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textTLfontsize end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textTLfontsize = tonumber(v)
											bg:SetLayout()
										end,
									order = 102,
								}, -- <font size>
								textTLcolor = {
									type = "color", name = L["OPTIONS_GROUP_TEXT_FONTCOLOR_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONTCOLOR_DESC"],
									get = function() return unpack(ElkBuffBars.db.profile.bargroups[id].bars.textTLcolor) end,
									set = function(r, g, b, a)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textTLcolor[1] = r
											bg.layout.bars.textTLcolor[2] = g
											bg.layout.bars.textTLcolor[3] = b
											bg.layout.bars.textTLcolor[4] = a
											bg:SetLayout()
										end,
									hasAlpha = true,
									order = 103,
								}, -- <color set>
								textTLalign = {
									type = "text", name = L["OPTIONS_GROUP_TEXT_ALIGNMENT_NAME"], desc = L["OPTIONS_GROUP_TEXTTL_ALIGNMENT_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textTLalign end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textTLalign = v
											bg:SetLayout()
										end,
									validate = {["left"] = L["OPTIONS_GROUP_TEXT_ALIGNMENT_LEFT"], ["center"] = L["OPTIONS_GROUP_TEXT_ALIGNMENT_CENTER"], ["right"] = L["OPTIONS_GROUP_TEXT_ALIGNMENT_RIGHT"]},
									order = 104
								}, -- left, center, right
							},
							order = 103,
						},
						texttr = {
							type = "group", name = L["OPTIONS_GROUP_TEXTTR_NAME"], desc = L["OPTIONS_GROUP_TEXTTR_NAME"], args = {
								textTR = {
									type = "text", name = L["OPTIONS_GROUP_TEXT_TEMPLATE_NAME"], desc = L["OPTIONS_GROUP_TEXT_TEMPLATE_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textTR or "false" end,
									set = function(v)
											if v == "false" then v = false end
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textTR = v
											bg:SetLayout()
										end,
									validate = {
										["false"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_HIDE"],
										["NAME"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAME"],
										["NAMERANK"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANK"],
										["NAMECOUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMECOUNT"],
										["NAMERANKCOUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANKCOUNT"],
										["RANK"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_RANK"],
										["COUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_COUNT"],
										["TIMELEFT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_TIMELEFT"],
										["DEBUFFTYPE"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_DEBUFFTYPE"]
									},
									order = 101,
								}, -- false, "NAME", "NAMERANK", "NAMECOUNT", "NAMERANKCOUNT", "RANK", "COUNT", "TIMELEFT", "DEBUFFTYPE"
								textTRfont = {
									type = "text", name = L["OPTIONS_GROUP_TEXT_FONT_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONT_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textTRfont end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textTRfont = v
											bg:SetLayout()
										end,
									validate = LSM3_font,
									order = 102,
								}, -- <LSM3:font>
								textTRfontsize = {
									type = "range", name = L["OPTIONS_GROUP_TEXT_FONTSIZE_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONTSIZE_DESC"],
									min = 4, max = 32, step = 1,
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textTRfontsize end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textTRfontsize = tonumber(v)
											bg:SetLayout()
										end,
									order = 103,
								}, -- <font size>
								textTRcolor = {
									type = "color", name = L["OPTIONS_GROUP_TEXT_FONTCOLOR_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONTCOLOR_DESC"],
									get = function() return unpack(ElkBuffBars.db.profile.bargroups[id].bars.textTRcolor) end,
									set = function(r, g, b, a)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textTRcolor[1] = r
											bg.layout.bars.textTRcolor[2] = g
											bg.layout.bars.textTRcolor[3] = b
											bg.layout.bars.textTRcolor[4] = a
											bg:SetLayout()
										end,
									hasAlpha = true,
									order = 104,
								}, -- <color set>
							},
							order = 104,
						},
						textbl = {
							type = "group", name = L["OPTIONS_GROUP_TEXTBL_NAME"], desc = L["OPTIONS_GROUP_TEXTBL_NAME"], args = {
								textBL = {
									type = "text", name = L["OPTIONS_GROUP_TEXT_TEMPLATE_NAME"], desc = L["OPTIONS_GROUP_TEXT_TEMPLATE_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textBL or "false" end,
									set = function(v)
											if v == "false" then v = false end
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textBL = v
											bg:SetLayout()
										end,
									validate = {
										["false"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_HIDE"],
										["NAME"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAME"],
										["NAMERANK"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANK"],
										["NAMECOUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMECOUNT"],
										["NAMERANKCOUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANKCOUNT"],
										["RANK"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_RANK"],
										["COUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_COUNT"],
										["TIMELEFT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_TIMELEFT"],
										["DEBUFFTYPE"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_DEBUFFTYPE"]
									},
									order = 101,
								}, -- false, "NAME", "NAMERANK", "NAMECOUNT", "NAMERANKCOUNT", "RANK", "COUNT", "TIMELEFT", "DEBUFFTYPE"
								textBLfont = {
									type = "text", name = L["OPTIONS_GROUP_TEXT_FONT_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONT_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textBLfont end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textBLfont = v
											bg:SetLayout()
										end,
									validate = LSM3_font,
									order = 102,
								}, -- <LSM3:font>
								textBLfontsize = {
									type = "range", name = L["OPTIONS_GROUP_TEXT_FONTSIZE_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONTSIZE_DESC"],
									min = 4, max = 32, step = 1,
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textBLfontsize end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textBLfontsize = tonumber(v)
											bg:SetLayout()
										end,
									order = 103,
								}, -- <font size>
								textBLcolor = {
									type = "color", name = L["OPTIONS_GROUP_TEXT_FONTCOLOR_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONTCOLOR_DESC"],
									get = function() return unpack(ElkBuffBars.db.profile.bargroups[id].bars.textBLcolor) end,
									set = function(r, g, b, a)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textBLcolor[1] = r
											bg.layout.bars.textBLcolor[2] = g
											bg.layout.bars.textBLcolor[3] = b
											bg.layout.bars.textBLcolor[4] = a
											bg:SetLayout()
										end,
									hasAlpha = true,
									order = 104,
								}, -- <color set>
								textBLalign = {
									type = "text", name = L["OPTIONS_GROUP_TEXT_ALIGNMENT_NAME"], desc = L["OPTIONS_GROUP_TEXTBL_ALIGNMENT_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textBLalign end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textBLalign = v
											bg:SetLayout()
										end,
									validate = {["left"] = L["OPTIONS_GROUP_TEXT_ALIGNMENT_LEFT"], ["center"] = L["OPTIONS_GROUP_TEXT_ALIGNMENT_CENTER"], ["right"] = L["OPTIONS_GROUP_TEXT_ALIGNMENT_RIGHT"]},
									order = 105,
								}, -- left, center, right
							},
							order = 105,
						},
						textbr = {
							type = "group", name = L["OPTIONS_GROUP_TEXTBR_NAME"], desc = L["OPTIONS_GROUP_TEXTBR_NAME"], args = {
								textBR = {
									type = "text", name = L["OPTIONS_GROUP_TEXT_TEMPLATE_NAME"], desc = L["OPTIONS_GROUP_TEXT_TEMPLATE_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textBR or "false" end,
									set = function(v)
											if v == "false" then v = false end
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textBR = v
											bg:SetLayout()
										end,
									validate = {
										["false"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_HIDE"],
										["NAME"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAME"],
										["NAMERANK"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANK"],
										["NAMECOUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMECOUNT"],
										["NAMERANKCOUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANKCOUNT"],
										["RANK"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_RANK"],
										["COUNT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_COUNT"],
										["TIMELEFT"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_TIMELEFT"],
										["DEBUFFTYPE"] = L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_DEBUFFTYPE"]
									},
									order = 101,
								}, -- false, "NAME", "NAMERANK", "NAMECOUNT", "NAMERANKCOUNT", "RANK", "COUNT", "TIMELEFT", "DEBUFFTYPE"
								textBRfont = {
									type = "text", name = L["OPTIONS_GROUP_TEXT_FONT_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONT_DESC"],
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textBRfont end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textBRfont = v
											bg:SetLayout()
										end,
									validate = LSM3_font,
									order = 102,
								}, -- <LSM3:font>
								textBRfontsize = {
									type = "range", name = L["OPTIONS_GROUP_TEXT_FONTSIZE_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONTSIZE_DESC"],
									min = 4, max = 32, step = 1,
									get = function() return ElkBuffBars.db.profile.bargroups[id].bars.textBRfontsize end,
									set = function(v)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textBRfontsize = tonumber(v)
											bg:SetLayout()
										end,
									order = 103,
								}, -- <font size>
								textBRcolor = {
									type = "color", name = L["OPTIONS_GROUP_TEXT_FONTCOLOR_NAME"], desc = L["OPTIONS_GROUP_TEXT_FONTCOLOR_DESC"],
									get = function() return unpack(ElkBuffBars.db.profile.bargroups[id].bars.textBRcolor) end,
									set = function(r, g, b, a)
											local bg = ElkBuffBars.bargroups[id]
											bg.layout.bars.textBRcolor[1] = r
											bg.layout.bars.textBRcolor[2] = g
											bg.layout.bars.textBRcolor[3] = b
											bg.layout.bars.textBRcolor[4] = a
											bg:SetLayout()
										end,
									hasAlpha = true,
									order = 104,
								}, -- <color set>
							},
							order = 106,
						},
						abbreviate_name = {
							type = "range", name = L["OPTIONS_GROUP_ABBREVIATE_NAME"], desc = L["OPTIONS_GROUP_ABBREVIATE_DESC"],
							min = 0, max = 100, step = 1,
							get = function() return ElkBuffBars.db.profile.bargroups[id].bars.abbreviate_name end,
							set = function(v)
									local bg = ElkBuffBars.bargroups[id]
									bg.layout.bars.abbreviate_name = tonumber(v)
									bg:UpdateText()
								end,
							order = 107,
						},
						timeformat = {
							type = "text", name = L["OPTIONS_GROUP_TIMEFORMAT_NAME"], desc = L["OPTIONS_GROUP_TIMEFORMAT_DESC"],
							get = function() return ElkBuffBars.db.profile.bargroups[id].bars.timeformat end,
							set = function(v)
									local bg = ElkBuffBars.bargroups[id]
									bg.layout.bars.timeformat = v
									bg:UpdateTimeleft()
								end,
							validate = {"DEFAULT", "EXTENDED", "FULL", "SHORT", "CONDENSED"},
							order = 108,
						}, -- "DEFAULT", "EXTENDED", "FULL", "SHORT", "CONDENSED"
						padding = {
							type = "range", name = L["OPTIONS_GROUP_PADDING_NAME"], desc = L["OPTIONS_GROUP_PADDING_DESC"],
							min = 0, max = 10, step = 1,
							get = function() return ElkBuffBars.db.profile.bargroups[id].bars.padding end,
							set = function(v)
									local bg = ElkBuffBars.bargroups[id]
									bg.layout.bars.padding = tonumber(v)
									bg:SetLayout()
								end,
							order = 109,
						},
						tooltipanchor = {
							type = "text", name = L["OPTIONS_GROUP_TTIPANCHOR_NAME"], desc = L["OPTIONS_GROUP_TTIPANCHOR_DESC"],
							get = function() return ElkBuffBars.db.profile.bargroups[id].bars.tooltipanchor end,
							set = function(v)
									local bg = ElkBuffBars.bargroups[id]
									bg.layout.bars.tooltipanchor = v
								end,
							validate = {"default", "ANCHOR_TOPRIGHT", "ANCHOR_RIGHT","ANCHOR_BOTTOMRIGHT", "ANCHOR_TOPLEFT", "ANCHOR_LEFT", "ANCHOR_BOTTOMLEFT", "ANCHOR_CURSOR", "ANCHOR_PRESERVE", "ANCHOR_NONE"},
							order = 110,
						},
						height = {
							type = "range", name = L["OPTIONS_GROUP_HEIGHT_NAME"], desc = L["OPTIONS_GROUP_HEIGHT_DESC"],
							min = 0, max = 100, step = 1,
							get = function() return ElkBuffBars.db.profile.bargroups[id].bars.height end,
							set = function(v)
									local bg = ElkBuffBars.bargroups[id]
									local blayout = bg.layout.bars
									blayout.height = tonumber(v)
									if blayout.height > blayout.width then blayout.height = blayout.width end
									bg:SetLayout()
									bg:UpdateBarPositions()
								end,
							order = 111,
						},
						width = {
							type = "range", name = L["OPTIONS_GROUP_WIDTH_NAME"], desc = L["OPTIONS_GROUP_WIDTH_DESC"],
							min = 0, max = 500, step = 1,
							get = function() return ElkBuffBars.db.profile.bargroups[id].bars.width end,
							set = function(v)
									local bg = ElkBuffBars.bargroups[id]
									local blayout = bg.layout.bars
									blayout.width = tonumber(v)
									if blayout.width < blayout.height then blayout.width = blayout.height end
									bg:SetLayout()
									if bg.layout.anchorshown then
										bg:ToggleAnchor(true)
									else
										bg:UpdateBarPositions()
									end
								end,
							order = 112,
						},
					},
					order = 103,
				},
				alpha = {
					type = "range", name = L["OPTIONS_GROUP_ALPHA_NAME"], desc = L["OPTIONS_GROUP_ALPHA_DESC"],
					isPercent = true,
					get = function() return ElkBuffBars.db.profile.bargroups[id].alpha end,
					set = function(v)
							local bg = ElkBuffBars.bargroups[id]
							bg.layout.alpha = tonumber(v)
							bg:SetLayout()
						end,
					order = 104,
				},
				scale = {
					type = "range", name = L["OPTIONS_GROUP_SCALE_NAME"], desc = L["OPTIONS_GROUP_SCALE_DESC"],
					isPercent = true, min = 0.1, max = 2,
					get = function() return ElkBuffBars.db.profile.bargroups[id].scale end,
					set = function(v)
							local bg = ElkBuffBars.bargroups[id]
							bg.layout.scale = tonumber(v)
							bg:SetLayout()
						end,
					order = 105,
				},
				barspacing = {
					type = "range", name = L["OPTIONS_GROUP_BARSPACING_NAME"], desc = L["OPTIONS_GROUP_BARSPACING_DESC"],
					min = 0, max = 50, step = 1,
					get = function() return ElkBuffBars.db.profile.bargroups[id].barspacing end,
					set = function(v)
							local bg = ElkBuffBars.bargroups[id]
							bg.layout.barspacing = tonumber(v)
							bg:UpdateBarPositions()
						end,
					order = 106,
				},
				growup = {
					type = "toggle", name = L["OPTIONS_GROUP_GROWUP_NAME"], desc = L["OPTIONS_GROUP_GROWUP_DESC"],
					get = function() return ElkBuffBars.db.profile.bargroups[id].growup end,
					set = function(v)
							local bg = ElkBuffBars.bargroups[id]
							bg.layout.growup = v
							bg.layout.stickto = nil
							bg.layout.stickside = nil
							bg:SetLayout()
							bg:SetPosition()
						end,
					order = 107,
				},
				sorting = {
					type = "text", name = L["OPTIONS_GROUP_SORTING_NAME"], desc = L["OPTIONS_GROUP_SORTING_DESC"],
					get = function() return ElkBuffBars.db.profile.bargroups[id].sorting end,
					set = function(v)
							local bg = ElkBuffBars.bargroups[id]
							bg.layout.sorting = v
							bg:UpdateData()
						end,
					validate = {"name", "none", "timeleft", "timemax"},
					order = 108,
				},
				filter = {
					type = "group", name = L["OPTIONS_GROUP_FILTER_NAME"], desc = L["OPTIONS_GROUP_FILTER_DESC"], args = {
						type = {
							type = "text", name = L["OPTIONS_GROUP_FILTER_TYPE_NAME"], desc = L["OPTIONS_GROUP_FILTER_TYPE_DESC"],
							get = function(k) return ElkBuffBars.db.profile.bargroups[id].filter.type[k] or false end,
							set = function(k, v)
									ElkBuffBars.bargroups[id].layout.filter.type[k] = v or nil
									ElkBuffBars:DoFullUpdate()
								end,
							multiToggle = true,
							validate = {"BUFF", "DEBUFF", "TENCH", "TRACKING"},
							order = 101,
						},
						selfcast = {
							type = "text", name = L["OPTIONS_GROUP_FILTER_SELFCAST_NAME"], desc = L["OPTIONS_GROUP_FILTER_SELFCAST_DESC"],
							get = function(k) return ElkBuffBars.db.profile.bargroups[id].filter.selfcast or "none" end,
							set = function(v)
									if v == "none" then v = nil end
									ElkBuffBars.bargroups[id].layout.filter.selfcast = v
									ElkBuffBars:DoFullUpdate()
								end,
							validate = {whitelist = L["OPTIONS_GROUP_FILTER_SELFCAST_VALIDATE_WHITELIST"], none = L["OPTIONS_GROUP_FILTER_SELFCAST_VALIDATE_NOFILTER"], blacklist = L["OPTIONS_GROUP_FILTER_SELFCAST_VALIDATE_BLACKLIST"]},
							order = 102,
						},
						untilcancelled = {
							type = "text", name = L["OPTIONS_GROUP_FILTER_TIMELESS_NAME"], desc = L["OPTIONS_GROUP_FILTER_TIMELESS_DESC"],
							get = function() return ElkBuffBars.db.profile.bargroups[id].filter.untilcancelled or "none" end,
							set = function(v)
									if v == "none" then v = nil end
									ElkBuffBars.bargroups[id].layout.filter.untilcancelled = v
									ElkBuffBars:DoFullUpdate()
								end,
							validate = {only = L["OPTIONS_GROUP_FILTER_TIMELESS_VALIDATE_WHITELIST"], none = L["OPTIONS_GROUP_FILTER_TIMELESS_VALIDATE_NOFILTER"], hide = L["OPTIONS_GROUP_FILTER_TIMELESS_VALIDATE_BLACKLIST"]},
							order = 103,
						},
						timemax_min = {
							type = "text", name = L["OPTIONS_GROUP_FILTER_TIMEMAXMIN_NAME"], desc = L["OPTIONS_GROUP_FILTER_TIMEMAXMIN_DESC"], usage = L["OPTIONS_GROUP_FILTER_TIMEMAXMIN_USAGE"],
							get = function() return ElkBuffBars.db.profile.bargroups[id].filter.timemax_min or "" end,
							set = function(v)
									v = tonumber(v)
									ElkBuffBars.bargroups[id].layout.filter.timemax_min = (v ~= 0) and v or nil
									ElkBuffBars:DoFullUpdate()
								end,
							order = 104,
						},
						timemax_max = {
							type = "text", name = L["OPTIONS_GROUP_FILTER_TIMEMAXMAX_NAME"], desc = L["OPTIONS_GROUP_FILTER_TIMEMAXMAX_DESC"], usage = L["OPTIONS_GROUP_FILTER_TIMEMAXMAX_USAGE"],
							get = function() return ElkBuffBars.db.profile.bargroups[id].filter.timemax_max or "" end,
							set = function(v)
									v = tonumber(v)
									ElkBuffBars.bargroups[id].layout.filter.timemax_max = (v ~= 0) and v or nil
									ElkBuffBars:DoFullUpdate()
								end,
							order = 105,
						},
						names_include = {
							type = "group", name = L["OPTIONS_GROUP_FILTER_NAME_WHITELIST_NAME"], desc = L["OPTIONS_GROUP_FILTER_NAME_WHITELIST_DESC"],
							args = {
								BUFF = {
									type = "text", name = "BUFF", desc = "BUFF",
									get = function(k)
											local ni = ElkBuffBars.db.profile.bargroups[id].filter.names_include
											return ni and ni.BUFF and ni.BUFF[k] or false
										end,
									set = function(name, value) SetNameFilter(id, true, "BUFF", name, value) end,
									multiToggle = true,
									validate = knownnames_validate.BUFF,
								},
								DEBUFF = {
									type = "text", name = "DEBUFF", desc = "DEBUFF",
									get = function(k)
											local ni = ElkBuffBars.db.profile.bargroups[id].filter.names_include
											return ni and ni.DEBUFF and ni.DEBUFF[k] or false
										end,
									set = function(name, value) SetNameFilter(id, true, "DEBUFF", name, value) end,
									multiToggle = true,
									validate = knownnames_validate.DEBUFF,
								},
								TENCH = {
									type = "text", name = "TENCH", desc = "TENCH",
									get = function(k)
											local ni = ElkBuffBars.db.profile.bargroups[id].filter.names_include
											return ni and ni.TENCH and ni.TENCH[k] or false
										end,
									set = function(name, value) SetNameFilter(id, true, "TENCH", name, value) end,
									multiToggle = true,
									validate = knownnames_validate.TENCH,
								},
								TRACKING = {
									type = "text", name = "TRACKING", desc = "TRACKING",
									get = function(k)
											local ni = ElkBuffBars.db.profile.bargroups[id].filter.names_include
											return ni and ni.TRACKING and ni.TRACKING[k] or false
										end,
									set = function(name, value) SetNameFilter(id, true, "TRACKING", name, value) end,
									multiToggle = true,
									validate = knownnames_validate.TRACKING,
								},
							},
							order = 106,
						},
						names_exclude = {
							type = "group", name = L["OPTIONS_GROUP_FILTER_NAME_BLACKLIST_NAME"], desc = L["OPTIONS_GROUP_FILTER_NAME_BLACKLIST_DESC"],
							args = {
								BUFF = {
									type = "text", name = "BUFF", desc = "BUFF",
									get = function(k)
											local ne = ElkBuffBars.db.profile.bargroups[id].filter.names_exclude
											return ne and ne.BUFF and ne.BUFF[k] or false
										end,
									set = function(name, value) SetNameFilter(id, false, "BUFF", name, value) end,
									multiToggle = true,
									validate = knownnames_validate.BUFF,
								},
								DEBUFF = {
									type = "text", name = "DEBUFF", desc = "DEBUFF",
									get = function(k)
											local ne = ElkBuffBars.db.profile.bargroups[id].filter.names_exclude
											return ne and ne.DEBUFF and ne.DEBUFF[k] or false
										end,
									set = function(name, value) SetNameFilter(id, false, "DEBUFF", name, value) end,
									multiToggle = true,
									validate = knownnames_validate.DEBUFF,
								},
								TENCH = {
									type = "text", name = "TENCH", desc = "TENCH",
									get = function(k)
											local ne = ElkBuffBars.db.profile.bargroups[id].filter.names_exclude
											return ne and ne.TENCH and ne.TENCH[k] or false
										end,
									set = function(name, value) SetNameFilter(id, false, "TENCH", name, value) end,
									multiToggle = true,
									validate = knownnames_validate.TENCH,
								},
								TRACKING = {
									type = "text", name = "TRACKING", desc = "TRACKING",
									get = function(k)
											local ne = ElkBuffBars.db.profile.bargroups[id].filter.names_exclude
											return ne and ne.TRACKING and ne.TRACKING[k] or false
										end,
									set = function(name, value) SetNameFilter(id, false, "TRACKING", name, value) end,
									multiToggle = true,
									validate = knownnames_validate.TRACKING,
								},
							},
							order = 107,
						},
					},
					order = 109,
				},
				target = {
					type = "text", name = L["OPTIONS_GROUP_TARGET_NAME"], desc = L["OPTIONS_GROUP_TARGET_DESC"],
					get = function() return ElkBuffBars.db.profile.bargroups[id].target end,
					set = function(v)
							local bg = ElkBuffBars.bargroups[id]
							bg.layout.target = v
							bg:UpdateData()
						end,
					validate = {"focus", "pet", "player", "target", "vehicle"},
					order = 110,
				},
				clickthrough = {
					type = "toggle", name = L["OPTIONS_GROUP_CLICKTHROUGH_NAME"], desc = L["OPTIONS_GROUP_CLICKTHROUGH_DESC"],
					get = function() return ElkBuffBars.db.profile.bargroups[id].bars.clickthrough end,
					set = function(v)
							local bg = ElkBuffBars.bargroups[id]
							bg.layout.bars.clickthrough = v
							bg:SetLayout()
						end,
					order = 111,
				},
				copylayout = {
					type = "text", name = L["OPTIONS_GROUP_COPYLAYOUT_NAME"], desc = L["OPTIONS_GROUP_COPYLAYOUT_DESC"], usage = L["OPTIONS_GROUP_COPYLAYOUT_USAGE"],
					get = false,
					set = function(v)
							v = tonumber(v)
							if v ~= id and ElkBuffBars.bargroups[v] then
								ElkBuffBars:CopyBarLayout(ElkBuffBars.bargroups[id].layout, ElkBuffBars.bargroups[v].layout)
							end
						end,
					order = 112,
				},
				resetpos = {
					type = "execute", name = L["OPTIONS_GROUP_RESETPOSITION_NAME"], desc = L["OPTIONS_GROUP_RESETPOSITION_DESC"],
					func = function()
							local bg = ElkBuffBars.bargroups[id]
							bg.layout.x = nil
							bg.layout.y = nil
							bg.stickto = nil
							bg.stickside = nil
							bg:SetPosition()
						end,
					order = 113,
				},
				remove = {
					type = "execute", name = L["OPTIONS_GROUP_REMOVE_NAME"], desc = L["OPTIONS_GROUP_REMOVE_DESC"],
					func = function()
							Dewdrop:Close()
							ElkBuffBars:RemoveBarGroup(id)
						end,
					order = 114,
				},
			}
		}
	end
	return groupoptionscache[id]
end

function ElkBuffBars:ShowDewdrop()
	Dewdrop:Open(UIParent, "children", AO_allopts, "cursorX", true, "cursorY", true)
end
