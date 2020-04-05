
local addonName, addon = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

addon.filters["Equip Location Filter"] = {}
local filter = addon.filters["Equip Location Filter"]

filter.equipLoc ={}
filter.equipLoc_filtered ={}
filter.equipLocChecked = false

local order = {}
local TypeSelect = {
	type = 'toggle',
	desc = L['When selected this item equip location will be shown'],
	name = function(info)	
		return _G[info[#info]]
	end,
	get = function(info)
		return addon.db.profile.ELFilter[info[#info]]
	end,
	set = function(info, val)
		addon.db.profile.ELFilter[info[#info]] = val
	end,
	order = function(info)
		return order[info[#info]]+1
	end,
}

local itemtypesorted, itemtypesortedL = {}, {}
function filter:UpdateOptions()
	wipe(itemtypesorted)
	if not addon.filterOptions["Equip Location Filter"] then
		addon.filterOptions["Equip Location Filter"] = {
			type = 'group',
			name = L["Equip Location Filter"],
			args = {
				desc = {
					type = 'description',
					name = L['Only equip location you have previously seen can be filtered by default'],
					order = 1,
				},
			},
		}
		local args = addon.filterOptions["Equip Location Filter"].args
		
		for l in pairs(addon.db.global.ELFilter) do
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

function filter:AddItem(link)
	local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(link)
	if _G[itemEquipLoc] then
		self.equipLoc[itemEquipLoc] = true
	end
	addon.db.global.ELFilter[itemEquipLoc] = true
end

function filter:ClearAll()
	wipe(self.equipLoc)
	filter:ResetFilter()
end

function filter:isFilterd(link)
	if next(self.equipLoc_filtered) then
		local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(link)
		return not self.equipLoc_filtered[itemEquipLoc]
	else
		return false
	end
end

function filter:ResetFilter()
	wipe(self.equipLoc_filtered)
	for q, v in pairs(addon.db.profile.ELFilter) do
		self.equipLoc_filtered[q] = v
	end
end

function filter:ShowAll()
	wipe(self.equipLoc_filtered)
end

function filter:FilterAll()
	if self:isRelevant() then
		for i in pairs(addon.db.global.ELFilter) do
			self.equipLoc_filtered[i] = true
		end
	end
end

function filter:isRelevant()
	local count = 0
	for k in pairs(self.equipLoc) do
		count = count + 1
		if count > 1 then
			return true
		end
	end
end

function filter:WriteDefault(db)
	db.profile.ELFilter = {}
	db.global.ELFilter = {}
end

local info = {}
function filter:GetDropdown(level)
	wipe(info)
	wipe(itemtypesorted)
	info.keepShownOnClick = 1
    if level == 1 then
		info.text = ITEMSLOTTEXT
		info.value = ITEMSLOTTEXT
		info.hasArrow = true
		info.func = function()
			local b
			if self.equipLocChecked then
				b = nil
			else
				b = true
			end
			self.equipLocChecked = b
			for el in pairs(self.equipLoc) do
				self.equipLoc_filtered[el] = b
			end
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			addon:FilterUpdate()
		end
		UIDropDownMenu_AddButton(info, level)
	elseif level == 2 and ITEMSLOTTEXT == UIDROPDOWNMENU_MENU_VALUE then
		for l in pairs(self.equipLoc) do
			local L = _G[l]
			if L then
				itemtypesorted[#itemtypesorted+1] = L
				itemtypesortedL[L] = l
			end
		end
		table.sort(itemtypesorted)

		for i = 1, #itemtypesorted do
			info.text = itemtypesorted[i]
			info.arg1 = itemtypesortedL[itemtypesorted[i]]
			info.checked = self.equipLoc_filtered[itemtypesortedL[itemtypesorted[i]]]
			info.func = function(button, arg1)
				if self.equipLoc_filtered[arg1] then
					self.equipLoc_filtered[arg1] = nil
				else
					self.equipLoc_filtered[arg1] = true
				end
				addon:FilterUpdate()
			end
			UIDropDownMenu_AddButton(info, level)
		end
	end
end