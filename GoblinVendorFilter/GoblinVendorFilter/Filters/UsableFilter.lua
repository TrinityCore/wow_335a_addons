
local addonName, addon = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

addon.filters["Usable Items Filter"] = {}
local filter = addon.filters["Usable Items Filter"]


filter.linkList = {}
function filter:AddItem(link, i)
	filter.linkList[link] = i
end

function filter:ClearAll()
	wipe(self.linkList)
	self.usable = addon.db.profile.usable
end

function filter:isFilterd(link, i)
	local _, _, _, _, _, isUsable = addon.GetMerchantItemInfo_old(i)
	return self.usable and not isUsable
end

function filter:ResetFilter()
	self.usable = addon.db.profile.usable
end

function filter:ShowAll()
	self.usable = false
end

function filter:FilterAll()
	if self:isRelevant() then
		self.usable = true
	end
end

function filter:WriteDefault(db)
	db.profile.usable = false
end

function filter:isRelevant()
	local count = 0
	local fcount = 0
	for link, i in pairs(self.linkList) do
		local _, _, _, _, _, isUsable = addon.GetMerchantItemInfo_old(i)
		if isUsable then
			fcount = fcount + 1
		else
			count = count + 1
		end
		if count > 0 and fcount > 0 then
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
		info.text = USABLE_ITEMS
		info.checked = self.usable
		info.func = function()
			self.usable = not self.usable
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			addon:FilterUpdate()
		end
		UIDropDownMenu_AddButton(info, level)
	end
end

addon.filterOptions["Usable Items Filter"] = {
	type = 'group',
	name = L["Usable Items Filter"],
	args = {
		UIF = {
			name = L["Usable Items Filter Default"],
			desc = L['When selected only usable items will be displayed initially!'],
			type = 'toggle',
			width = 'full',
			get = function(info)
				return addon.db.profile.usable
			end,
			set = function(info, val)
				addon.db.profile.usable = val
				filter:ResetFilter()
			end,
		},
	},
}