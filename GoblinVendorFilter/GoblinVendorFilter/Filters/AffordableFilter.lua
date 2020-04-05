
local addonName, addon = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

addon.filters["Affordable Filter"] = {}
local filter = addon.filters["Affordable Filter"]


filter.linkList = {}
function filter:AddItem(link, i)
	filter.linkList[link] = i
end

function filter:ClearAll()
	wipe(self.linkList)
	self.affordable = addon.db.profile.affordable
end

function filter:isFilterd(link, i)
	if self.affordable then
		local _, _, price, _, _, _, extendedCost = addon.GetMerchantItemInfo_old(i)
		local money = GetMoney()
		if price > money then
			return true
		elseif extendedCost then
			local honorPoints, arenaPoints, itemCount = addon.GetMerchantItemCostInfo_old(i)
			if honorPoints > GetHonorCurrency() or arenaPoints > GetArenaCurrency() then
				return true
			elseif itemCount > 0 then
				for id=1, itemCount do
					local itemTexture, itemValue, itemLink = addon.GetMerchantItemCostItem_old(i, id)
					if itemValue > GetItemCount(itemLink) then
						return true
					end
				end
				return false
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
	
	local _, _, _, _, _, isUsable = addon.GetMerchantItemInfo_old(i)
	return self.affordable and not isUsable
end

function filter:ResetFilter()
	self.affordable = addon.db.profile.affordable
end

function filter:ShowAll()
	self.affordable = false
end

function filter:FilterAll()
	if self:isRelevant() then
		self.affordable = true
	end
end

function filter:WriteDefault(db)
	db.profile.affordable = false
end

function filter:isRelevant() -- need to look into this one some more
	return true
end

local info, itemtypesorted, itemtypesortedL = {}, {}, {}
function filter:GetDropdown(level)
	wipe(info)
	wipe(itemtypesorted)
	info.keepShownOnClick = 1
    if level == 1 then
		info.text = L['Affordable']
		info.checked = self.affordable
		info.func = function()
			self.affordable = not self.affordable
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			addon:FilterUpdate()
		end
		UIDropDownMenu_AddButton(info, level)
	end
end

addon.filterOptions["Affordable Filter"] = {
	type = 'group',
	name = L["Affordable Filter"],
	args = {
		UIF = {
			name = L["Affordable Filter Default"],
			desc = L['When selected only items you can afford will be displayed initially!'],
			type = 'toggle',
			width = 'full',
			get = function(info)
				return addon.db.profile.affordable
			end,
			set = function(info, val)
				addon.db.profile.affordable = val
				filter:ResetFilter()
			end,
		},
	},
}