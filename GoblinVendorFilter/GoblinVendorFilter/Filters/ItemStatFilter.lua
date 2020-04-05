
local addonName, addon = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

addon.filters["Item Stat Filter"] = {}
local filter = addon.filters["Item Stat Filter"]

filter.itemstat ={}
filter.itemstat_filtered_EX ={}
filter.itemstatChecked_EX = false
filter.itemstat_filtered_IN ={}
filter.itemstatChecked_IN = false

local order = {}
local TypeSelect = {
	type = 'toggle',
	desc = L['Yellow Checkmark:|nWe want this stat.|n|nGrey Checkmark:|nWe do not care if we have this stat or not.|n|nNo Checkmark:|nWe do not want this stat.'],
	name = function(info)	
		return _G[info[#info]]
	end,
	get = function(info)
		if addon.db.profile.ItemStatIncFilter[info[#info]] then
			return true
		elseif addon.db.profile.ItemStatExFilter[info[#info]] then
			return false
		else
			return nil
		end
	end,
	set = function(info, val)
		if val then
			addon.db.profile.ItemStatIncFilter[info[#info]] = true
			addon.db.profile.ItemStatExFilter[info[#info]] = nil
		elseif val == false then
			addon.db.profile.ItemStatIncFilter[info[#info]] = nil
			addon.db.profile.ItemStatExFilter[info[#info]] = true
		else
			addon.db.profile.ItemStatIncFilter[info[#info]] = nil
			addon.db.profile.ItemStatExFilter[info[#info]] = nil
		end
	end,
	order = function(info)
		return order[info[#info]]+1
	end,
	tristate = true,
}

local itemtypesorted, itemtypesortedL = {}, {}
function filter:UpdateOptions()
	wipe(itemtypesorted)
	if not addon.filterOptions["Item Stat Filter"] then
		addon.filterOptions["Item Stat Filter"] = {
			type = 'group',
			name = L["Item Stat Filter"],
			args = {
				desc = {
					type = 'description',
					name = L['|cFFFF0000<<WARNING>>|r|nIf you change these from the default grey checkmark you may missout on items with no stats.|nOnly item stats you have previously seen can be filtered by default'],
					order = 1,
				},
			},
		}
		local args = addon.filterOptions["Item Stat Filter"].args
		
		for l in pairs(addon.db.global.ItemStatFilter) do
			local Lo = _G[l]
			if Lo then
				itemtypesorted[#itemtypesorted+1] = Lo
				itemtypesortedL[Lo] = l
			end
		end
		table.sort(itemtypesorted)
		wipe(order)
		for i, l in ipairs(itemtypesorted) do
			order[itemtypesortedL[l]] = i
		end
		
		for Lo, l in pairs(itemtypesortedL) do
			args[l] = TypeSelect
		end
	end
end

local tempStats = {}
function filter:AddItem(link)
	wipe(tempStats)
	GetItemStats(link, tempStats)
	for stat in pairs(tempStats) do
		if _G[stat] then
			self.itemstat[stat] = true
		end
		addon.db.global.ItemStatFilter[stat] = true
	end
end

function filter:ClearAll()
	wipe(self.itemstat)
	filter:ResetFilter()
end

function filter:isFilterd(link)
	wipe(tempStats)
	GetItemStats(link, tempStats)
	for stat in pairs(tempStats) do
		if self.itemstat_filtered_EX[stat] then
			return true
		end
	end
	if next(self.itemstat_filtered_IN) then
		for stat in pairs(tempStats) do
			if self.itemstat_filtered_IN[stat] then
				return false
			end
		end
		return true
	else
		return false
	end
end

function filter:ResetFilter()
	wipe(self.itemstat_filtered_EX)
	for q, v in pairs(addon.db.profile.ItemStatExFilter) do
		self.itemstat_filtered_EX[q] = v
	end
	wipe(self.itemstat_filtered_IN)
	for q, v in pairs(addon.db.profile.ItemStatIncFilter) do
		self.itemstat_filtered_IN[q] = v
	end
end

function filter:ShowAll()
	wipe(self.itemstat_filtered_EX)
	wipe(self.itemstat_filtered_IN)
end

function filter:FilterAll()
	if self:isRelevant() then
		for i in pairs(addon.db.global.ItemStatFilter) do
			self.itemstat_filtered_EX[i] = true
		end
	end
end

function filter:isRelevant()
	local count = 0
	for k in pairs(self.itemstat) do
		count = count + 1
		if count > 1 then
			return true
		end
	end
	return false
end

function filter:WriteDefault(db)
	db.profile.ItemStatExFilter = {}
	db.global.ItemStatFilter = {}
	db.profile.ItemStatIncFilter = {}
end

local info = {}
function filter:GetDropdown(level)
	wipe(info)
	wipe(itemtypesorted)
	info.keepShownOnClick = 1
    if level == 1 then
		info.text = L['Want:']
		info.value = 'Inclusive_Stats'
		info.hasArrow = true
		info.func = function()
			local b
			if self.itemstatChecked_IN then
				b = nil
			else
				b = true
			end
			self.itemstatChecked_IN = b
			for el in pairs(self.itemstat) do
				self.itemstat_filtered_IN[el] = b
				if b then
					self.itemstat_filtered_EX[el] = nil
				end
			end
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			addon:FilterUpdate()
		end
		UIDropDownMenu_AddButton(info, level)
		
		info.text = L["Don't Want:"]
		info.value = 'Exclusive_Stats'
		info.hasArrow = true
		info.func = function()
			local b
			if self.itemstatChecked_EX then
				b = nil
			else
				b = true
			end
			self.itemstatChecked_EX = b
			for el in pairs(self.itemstat) do
				self.itemstat_filtered_EX[el] = b
				if b then
					self.itemstat_filtered_IN[el] = nil
				end
			end
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			addon:FilterUpdate()
		end
		UIDropDownMenu_AddButton(info, level)
	elseif level == 2 and (('Exclusive_Stats' == UIDROPDOWNMENU_MENU_VALUE) or ('Inclusive_Stats' == UIDROPDOWNMENU_MENU_VALUE))then
		for l in pairs(self.itemstat) do
			local L = _G[l]
			if L then
				itemtypesorted[#itemtypesorted+1] = L
				itemtypesortedL[L] = l
			end
		end
		table.sort(itemtypesorted)
		if 'Exclusive_Stats' == UIDROPDOWNMENU_MENU_VALUE then
			for i = 1, #itemtypesorted do
				info.text = itemtypesorted[i]
				info.arg1 = itemtypesortedL[itemtypesorted[i]]
				info.checked = self.itemstat_filtered_EX[itemtypesortedL[itemtypesorted[i]]]
				info.func = function(button, arg1)
					if self.itemstat_filtered_EX[arg1] then
						self.itemstat_filtered_EX[arg1] = nil
					else
						self.itemstat_filtered_EX[arg1] = true
						self.itemstat_filtered_IN[arg1] = nil
					end
					addon:FilterUpdate()
				end
				UIDropDownMenu_AddButton(info, level)
			end
		elseif 'Inclusive_Stats' == UIDROPDOWNMENU_MENU_VALUE then
			for i = 1, #itemtypesorted do
				info.text = itemtypesorted[i]
				info.arg1 = itemtypesortedL[itemtypesorted[i]]
				info.checked = self.itemstat_filtered_IN[itemtypesortedL[itemtypesorted[i]]]
				info.func = function(button, arg1)
					if self.itemstat_filtered_IN[arg1] then
						self.itemstat_filtered_IN[arg1] = nil
					else
						self.itemstat_filtered_IN[arg1] = true
						self.itemstat_filtered_EX[arg1] = nil
					end
					addon:FilterUpdate()
				end
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end
end