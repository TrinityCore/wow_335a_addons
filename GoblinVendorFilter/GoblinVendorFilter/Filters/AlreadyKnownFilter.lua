
local addonName, addon = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

addon.filters["Already Known Filter"] = {}
local filter = addon.filters["Already Known Filter"]

do -- Tooltip Scanner to detect if we already know an item
	local Scanner = CreateFrame("GameTooltip", "addon_AKF_ScannerTooltip", nil, "GameTooltipTemplate")
	Scanner:SetOwner(UIParent, "ANCHOR_NONE")
	local known_cache = {}
	setmetatable(known_cache, {__mode = "kv"})
	function filter:CheckIfKnown(link)
		if known_cache[link] then
			return true
		end
		Scanner:ClearLines()
		Scanner:SetHyperlink(link)
		for i=1,Scanner:NumLines() do
			Scanner[i] = Scanner[i] or _G["addon_AKF_ScannerTooltipTextLeft"..i]
			if Scanner[i]:GetText() == ITEM_SPELL_KNOWN then
				known_cache[link] = true
				return true
			end
		end
		return false
	end
end

filter.linkList = {}
function filter:AddItem(link, i)
	self.linkList[link] = i
end

function filter:ClearAll()
	wipe(self.linkList)
	self.alreadyknown = addon.db.profile.alreadyknown
end

function filter:isFilterd(link)
	if not self.alreadyknown then
		return self:CheckIfKnown(link)
	end
end

function filter:ResetFilter()
	self.alreadyknown = addon.db.profile.alreadyknown
end

function filter:ShowAll()
	self.alreadyknown = true
end

function filter:FilterAll()
	if self:isRelevant() then
		self.alreadyknown = false
	end
end

function filter:WriteDefault(db)
	db.profile.alreadyknown = true
end

function filter:isRelevant()
	local count = 0
	local fcount = 0
	for link in pairs(self.linkList) do
		if self:CheckIfKnown(link) then
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
		info.text = ITEM_SPELL_KNOWN
		info.checked = self.alreadyknown
		info.func = function()
			self.alreadyknown = not self.alreadyknown
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			ToggleDropDownMenu(1, nil, addon.FilterMenu, addon.FilterButton, 0, 0)
			addon:FilterUpdate()
		end
		UIDropDownMenu_AddButton(info, level)
	end
end

addon.filterOptions["Already Known Filter"] = {
	type = 'group',
	name = L["Already Known Filter"],
	args = {
		UIF = {
			name = L["Already Known Filter Default"],
			desc = L['When selected only unknown or not learnable items will be shown initially!'],
			type = 'toggle',
			width = 'full',
			get = function(info)
				return not addon.db.profile.alreadyknown
			end,
			set = function(info, val)
				addon.db.profile.alreadyknown = not val
				filter:ResetFilter()
			end,
		},
	},
}
