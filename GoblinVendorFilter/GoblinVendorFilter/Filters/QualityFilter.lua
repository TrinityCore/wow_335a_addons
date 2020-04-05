
local addonName, addon = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local ItemQualityDesc = {
	[0] = ITEM_QUALITY0_DESC,
	[1] = ITEM_QUALITY1_DESC,
	[2] = ITEM_QUALITY2_DESC,
	[3] = ITEM_QUALITY3_DESC,
	[4] = ITEM_QUALITY4_DESC,
	[5] = ITEM_QUALITY5_DESC,
	[6] = ITEM_QUALITY6_DESC,
	[7] = ITEM_QUALITY7_DESC,
}

addon.filters["Item Quality Filter"] = {}
local filter = addon.filters["Item Quality Filter"]

filter.qualities ={}
filter.qualities_filtered ={}
filter.qualitiesChecked = false

local TypeSelect = {
	type = 'toggle',
	desc = L['When selected this item quality will be shown'],
	name = function(info)	
		local n = tonumber(info[#info])
		local _, _, _, hex = GetItemQualityColor(n)
		return hex..ItemQualityDesc[n]
	end,
	get = function(info)
		local n = tonumber(info[#info])
		return addon.db.profile.IQFilter[n]
	end,
	set = function(info, val)
		local n = tonumber(info[#info])
		addon.db.profile.IQFilter[n] = val
	end,
	order = function(info)
		local n = tonumber(info[#info])
		return n
	end,
}

function filter:UpdateOptions()
	if not addon.filterOptions["Item Quality Filter"] then
		addon.filterOptions["Item Quality Filter"] = {
			type = 'group',
			name = L["Item Quality Filter"],
			args = {
			},
		}
		local args = addon.filterOptions["Item Quality Filter"].args

		for i, t in ipairs(ItemQualityDesc) do
			args[tostring(i)] = TypeSelect
		end
	end
end

function filter:AddItem(link)
	local _, _, itemRarity = GetItemInfo(link)
	self.qualities[itemRarity] = true
end

function filter:ClearAll()
	wipe(self.qualities)
	filter:ResetFilter()
end

function filter:isFilterd(link)
	if next(self.qualities_filtered) then
		local _, _, itemRarity = GetItemInfo(link)
		return not self.qualities_filtered[itemRarity]
	else
		return false
	end
end

function filter:ResetFilter()
	wipe(self.qualities_filtered)
	for q, v in ipairs(addon.db.profile.IQFilter) do
		self.qualities_filtered[q] = v
	end
end

function filter:ShowAll()
	wipe(self.qualities_filtered)
end

function filter:FilterAll()
	if self:isRelevant() then
		for i in pairs(ItemQualityDesc) do
			self.qualities_filtered[i] = true
		end
	end
end

function filter:WriteDefault(db)
	db.profile.IQFilter = {}
end

function filter:isRelevant()
	local count = 0
	for k in pairs(self.qualities) do
		count = count + 1
		if count > 1 then
			return true
		end
	end
end

local info, itemtypesorted, itemtypesortedL = {}, {}, {}
function filter:GetDropdown(level)
	wipe(info)
	wipe(itemtypesorted)
	info.keepShownOnClick = 1
    if level == 1 then
		info.text = QUALITY
		info.value = QUALITY
		info.hasArrow = true
		info.func = function()
			local b
			if self.qualitiesChecked then
				b = nil
			else
				b = true
			end
			self.qualitiesChecked = b
			for el in pairs(self.qualities) do
				self.qualities_filtered[el] = b
			end
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			addon:FilterUpdate()
		end
		UIDropDownMenu_AddButton(info, level)
	elseif level == 2 and QUALITY == UIDROPDOWNMENU_MENU_VALUE then
		for q in pairs(self.qualities) do
			itemtypesorted[#itemtypesorted+1] = q
		end
		table.sort(itemtypesorted)

		for i = 1, #itemtypesorted do
			local _, _, _, hex = GetItemQualityColor(itemtypesorted[i])
			info.text = hex..ItemQualityDesc[itemtypesorted[i]]
			info.arg1 = itemtypesorted[i]
			info.checked = self.qualities_filtered[itemtypesorted[i]]
			info.func = function(button, arg1)
				if self.qualities_filtered[arg1] then
					self.qualities_filtered[arg1] = nil
				else
					self.qualities_filtered[arg1] = true
				end
				addon:FilterUpdate()
			end
			UIDropDownMenu_AddButton(info, level)
		end
	end
end