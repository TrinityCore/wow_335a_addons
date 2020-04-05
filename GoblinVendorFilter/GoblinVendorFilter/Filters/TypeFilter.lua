
local addonName, addon = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

addon.filters["Item Type Filter"] = {}
local filter = addon.filters["Item Type Filter"]

filter.types ={}
filter.types_filtered ={}
filter.subtypes ={}
filter.subtypes_filtered ={}

local function NumEntries(t)
	if t then
		local count = 0
		for k in pairs(t) do
			count = count + 1
		end
		return count
	else
		return 0
	end
end

addon.filterOptions["Item Type Filter"] = {
	type = 'group',
	name = "Item Type Filter",
	args = {
	},
}

local desc = {
	type = 'description',
	name = L['Only Type/SubType combinations you have previously seen can be filtered by default'],
	order = 1,
}

local order = {}
local TypeSelect = {
	type = 'toggle',
	desc = L['When selected this item type will be shown unless multible subtypes are found'],
	name = function(info) return info[#info] end,
	get = function(info)
		return addon.db.profile.ITFilter.filtertypes[info[#info]]
	end,
	set = function(info, val)
		addon.db.profile.ITFilter.filtertypes[info[#info]] = val
		if val then
			for k in pairs(addon.db.global.ITFilter[info[#info]]) do
				addon.db.profile.ITFilter.filtersubtypes[info[#info]][k] = true
			end
		else
			wipe(addon.db.profile.ITFilter.filtersubtypes[info[#info]])
		end
	end,
	order = function(info) return order[info[#info]] end,
}

local SubTypeSelect= {
	type = 'multiselect',
	name = function(info) return string.match(info[#info], "(.+)subgroup") end,
	values = function(info) return addon.db.global.ITFilter[string.match(info[#info], "(.+)subgroup")] end,
	desc = L['Show this sub type'],
	get = function(info, key)
		local iType = string.match(info[#info], "(.+)subgroup")
		addon.db.profile.ITFilter.filtersubtypes[iType] = addon.db.profile.ITFilter.filtersubtypes[iType] or {}
		return addon.db.profile.ITFilter.filtersubtypes[iType][key]
	end,
	set = function(info, key, val)
		local iType = string.match(info[#info], "(.+)subgroup")
		addon.db.profile.ITFilter.filtersubtypes[iType] = addon.db.profile.ITFilter.filtersubtypes[iType] or {}
		addon.db.profile.ITFilter.filtersubtypes[iType][key] = val
	end,
	order = function(info) return order[info[#info]] end,
}

local sortedType, sortedSubType = {}, {}
function filter:UpdateOptions()
	wipe(order)
	wipe(addon.filterOptions["Item Type Filter"].args)
	local args = addon.filterOptions["Item Type Filter"].args
	args['desc'] = desc
	wipe(sortedType)
	for t in pairs(addon.db.global.ITFilter) do
		sortedType[#sortedType+1] = t
	end
	table.sort(sortedType)
	local count = 1
	for i, t in ipairs(sortedType) do
		args[t] = TypeSelect
		args[t..'subgroup'] = SubTypeSelect
		
		count = count + 1
		order[t] = count
		count = count + 1
		order[t..'subgroup'] = count
	end
	
end

function filter:AddItem(link)
	local _, _, _, _, _, itemType, itemSubType = GetItemInfo(link)
	self.types[itemType] = true
	self.subtypes[itemType] = self.subtypes[itemType] or {}
	self.subtypes[itemType][itemSubType] = true
	
	-- add all type/subtype combinations to a global db table so that people can filter them
	addon.db.global.ITFilter[itemType] = addon.db.global.ITFilter[itemType] or {}
	addon.db.global.ITFilter[itemType][itemSubType] = itemSubType
end

function filter:ClearAll()
	wipe(self.types)
	for _, st in pairs(self.subtypes) do
		wipe(st)
	end
	filter:ResetFilter()
end

function filter:isFilterd(link)
	local _, _, _, _, _, itemType, itemSubType = GetItemInfo(link)
	local subfilters
	for k, v in pairs(self.subtypes_filtered) do
		if next(v) then
			subfilters = true
			break
		end
	end
	if next(self.types_filtered) or subfilters then
		if self.types_filtered[itemType] or (self.subtypes_filtered[itemType] and self.subtypes_filtered[itemType][itemSubType]) then
			return false
		else
			return true
		end
	else
		return false
	end
end

function filter:ResetFilter()
	wipe(self.types_filtered)
	for t, v in pairs(addon.db.profile.ITFilter.filtertypes) do
		self.types_filtered[t] = v
	end

	for _, st in pairs(self.subtypes_filtered) do
		wipe(st)
	end
	for t, sTable in pairs(addon.db.profile.ITFilter.filtersubtypes) do
		for st, v in pairs(sTable) do
			self.subtypes_filtered[t] = self.subtypes_filtered[t] or {}
			self.subtypes_filtered[t][st] = v
		end
	end
end

function filter:ShowAll()
	wipe(self.types_filtered)
	for _, st in pairs(self.subtypes_filtered) do
		wipe(st)
	end
end

function filter:FilterAll()
	if self:isRelevant() then
		for t, tTable in pairs(addon.db.global.ITFilter) do
			for st in pairs(tTable) do
				self.subtypes_filtered[t] = self.subtypes_filtered[t] or {}
				self.subtypes_filtered[t][st] = true
			end
			self.types_filtered[t] = true
		end
	end
end

function filter:WriteDefault(db)
	db.profile.ITFilter = {}
	db.profile.ITFilter.filtertypes = {}
	db.profile.ITFilter.filtersubtypes = {}
	db.global.ITFilter = {}
end

function filter:isRelevant()
	local tCount = 0
	local stCount
	for t in pairs(self.types) do
		tCount = tCount + 1
		if tCount > 1 then
			return true
		end
		stCount = 0
		for st in pairs(self.subtypes[t]) do
			stCount = stCount + 1
			if stCount > 1 then
				return true
			end
		end
	end
end

local info, itemtypesorted = {}, {}
function filter:GetDropdown(level)
	wipe(info)
	wipe(itemtypesorted)
	info.keepShownOnClick = 1
    if level == 1 then
		for t in pairs(self.types) do
			itemtypesorted[#itemtypesorted+1] = t
		end
		table.sort(itemtypesorted)

		for i = 1, #itemtypesorted do
			info.text = itemtypesorted[i]
			info.arg1 = itemtypesorted[i]
			info.value = itemtypesorted[i]
			info.hasArrow = NumEntries(self.subtypes[itemtypesorted[i]]) > 1
			info.checked = self.types_filtered[itemtypesorted[i]]
			info.func = function(button, arg1)
				local b
				if self.types_filtered[arg1] then
					b = nil
				else
					b = true
				end
				self.types_filtered[arg1] = b
				if self.subtypes[arg1] then
					for st in pairs(self.subtypes[arg1]) do
						self.subtypes_filtered[arg1] = self.subtypes_filtered[arg1] or {}
						self.subtypes_filtered[arg1][st] = b
					end
				end
				ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
				ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
				addon:FilterUpdate()
			end
			UIDropDownMenu_AddButton(info, level)
		end
	elseif level == 2 and self.subtypes[UIDROPDOWNMENU_MENU_VALUE] then
		for st in pairs(self.subtypes[UIDROPDOWNMENU_MENU_VALUE]) do
			itemtypesorted[#itemtypesorted+1] = st
		end
		table.sort(itemtypesorted)

		for i = 1, #itemtypesorted do
			info.text = itemtypesorted[i]
			info.arg1 = UIDROPDOWNMENU_MENU_VALUE
			info.arg2 = itemtypesorted[i]
			info.checked = self.subtypes_filtered[UIDROPDOWNMENU_MENU_VALUE] and self.subtypes_filtered[UIDROPDOWNMENU_MENU_VALUE][itemtypesorted[i]]
			info.func = function(button, arg1, arg2)
				self.subtypes_filtered[arg1] = self.subtypes_filtered[arg1] or {}
				if self.subtypes_filtered[arg1][arg2] then
					self.subtypes_filtered[arg1][arg2] = nil
				else
					self.subtypes_filtered[arg1][arg2] = true
				end
				addon:FilterUpdate()
			end
			UIDropDownMenu_AddButton(info, level)
		end
	end
end
