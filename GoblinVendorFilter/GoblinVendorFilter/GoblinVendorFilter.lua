
--[[ list of all functions that are relevent
BuyMerchantItem(index[, qty]) -- no return
honorPoints, arenaPoints, itemCount = GetMerchantItemCostInfo(index);
itemTexture, itemValue, itemLink = GetMerchantItemCostItem(index, itemIndex) -- itemIndex <= itemCount from GetMerchantItemCostInfo
name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index)
link = GetMerchantItemLink(index);
maxStack = GetMerchantItemMaxStack(index)
numItems = GetMerchantNumItems();
PickupMerchantItem(index) -- no return
ShowMerchantSellCursor(index) -- no return
GameTooltip:SetMerchantItem(merchantIndex)
]]

local _, GVF = ...

--_G["GVF"] = GVF -- use for debugging

local L = LibStub("AceLocale-3.0"):GetLocale("GoblinVendorFilter", true)

GVF.filters = {}
GVF.indexLookup = {}
GVF.maxIndex = 0
GVF.MerchantOpen = false
GVF.HookOverwrite = false

GVF.frame = CreateFrame('frame')
GVF.frame:SetScript("OnEvent", function(self, event, ...) if GVF[event] then return GVF[event](GVF, event, ...) end end)

function GVF:MERCHANT_CLOSED()
	for k, filter in pairs(self.filters) do
		filter:ClearAll()
	end
	CloseDropDownMenus()
	self.MerchantOpen = false
end

GVF.frame:RegisterEvent("MERCHANT_CLOSED")

-- Let the mad hooking begin
-- we replace all the merchant functions and reroute them through our own
-- this enables us to modify any an all merchant addon out there :)
GVF.GetMerchantNumItems_old = GetMerchantNumItems
GVF.GetMerchantItemLink_old = GetMerchantItemLink

local function GenerateIndexLookup()
	local allDisplayed = true
	GVF.MerchantOpen = true
	wipe(GVF.indexLookup)
	GVF.indexLookup[0] = 0
	GVF.maxIndex = 0
	local filtered
	for i=1, GVF.GetMerchantNumItems_old() do
		local link = GVF.GetMerchantItemLink_old(i)
		if link then
			filtered = nil
			for k, filter in pairs(GVF.filters) do
				filter:AddItem(link, i)
			end
		end
	end
	for i=1, GVF.GetMerchantNumItems_old() do
		local link = GVF.GetMerchantItemLink_old(i)
		if link then
			filtered = nil
			for k, filter in pairs(GVF.filters) do
				if filter:isFilterd(link, i) and filter:isRelevant() then
					filtered = true
				end
			end
			if filtered then
				allDisplayed = false
			else
				GVF.maxIndex = GVF.maxIndex + 1
				GVF.indexLookup[GVF.maxIndex] = i
			end
		else
			GVF.maxIndex = GVF.maxIndex + 1
			GVF.indexLookup[GVF.maxIndex] = i
		end
	end
	if allDisplayed then
		GVF.AllTexture:SetVertexColor(0,1,0)
	else
		GVF.AllTexture:SetVertexColor(1,0,0)
	end
end

function GetMerchantNumItems()
	GVF.HookOverwrite = false
	GenerateIndexLookup()
	return GVF.maxIndex
end

function GetMerchantItemLink(index)
	if GVF.HookOverwrite then
		return GVF.GetMerchantItemLink_old(index)
	elseif GVF.indexLookup[index] then
		return GVF.GetMerchantItemLink_old(GVF.indexLookup[index])
	else
		return nil
	end
end

GVF.BuyMerchantItem_old = BuyMerchantItem
function BuyMerchantItem(index, qty)
	return GVF.BuyMerchantItem_old(GVF.indexLookup[index], qty)
end

GVF.GetMerchantItemCostInfo_old = GetMerchantItemCostInfo
function GetMerchantItemCostInfo(index, qty)
	if GVF.HookOverwrite then
		return GVF.GetMerchantItemCostInfo_old(index, qty)
	else
		return GVF.GetMerchantItemCostInfo_old(GVF.indexLookup[index], qty)
	end
end

GVF.GetMerchantItemCostItem_old = GetMerchantItemCostItem
function GetMerchantItemCostItem(index, itemIndex)
	if GVF.HookOverwrite then
		return GVF.GetMerchantItemCostItem_old(index, itemIndex)
	else
		return GVF.GetMerchantItemCostItem_old(GVF.indexLookup[index], itemIndex)
	end
end

GVF.GetMerchantItemInfo_old = GetMerchantItemInfo
function GetMerchantItemInfo(index)
	if GVF.HookOverwrite then
		return GVF.GetMerchantItemInfo_old(index)
	elseif GVF.indexLookup[index] then
		return GVF.GetMerchantItemInfo_old(GVF.indexLookup[index])
	else
		return nil
	end
end

GVF.GetMerchantItemMaxStack_old = GetMerchantItemMaxStack
function GetMerchantItemMaxStack(index)
	if GVF.HookOverwrite then
		return GVF.GetMerchantItemMaxStack_old(index)
	elseif GVF.indexLookup[index] then
		return GVF.GetMerchantItemMaxStack_old(GVF.indexLookup[index])
	else
		return nil
	end
end

GVF.PickupMerchantItem_old = PickupMerchantItem
function PickupMerchantItem(index)
	return GVF.PickupMerchantItem_old(GVF.indexLookup[index])
end

GVF.ShowMerchantSellCursor_old = ShowMerchantSellCursor
function ShowMerchantSellCursor(index)
	return GVF.ShowMerchantSellCursor_old(GVF.indexLookup[index])
end

local function OnUpdate(self)
	GVF.HookOverwrite = false
	self:SetScript("OnUpdate", nil)
end

local function GameTooltip_SetMerchantItem(self, i, ...)
	GVF.HookOverwrite = true
	self:SetMerchantItem_old(GVF.indexLookup[i], ...)
	GVF.HookOverwrite = false
end

local hookedFrames = {}
function GVF:MERCHANT_SHOW()
	local frame = EnumerateFrames() -- hook all tooltips on startup
	while frame do
		if string.lower(frame:GetObjectType()) == "gametooltip" and not hookedFrames[frame] then
			hookedFrames[frame] = true
			frame.SetMerchantItem_old = frame.SetMerchantItem
			frame.SetMerchantItem = GameTooltip_SetMerchantItem
		end
		frame = EnumerateFrames(frame)
	end
end

GVF.frame:RegisterEvent("MERCHANT_SHOW")

-- and we are done hooking

GVF.FilterMenu = CreateFrame("Frame", "GVF_FilterMenu", GVF.frame)
GVF.FilterMenu.onHide = function(...)
	MenuParent = nil
	MenuItem = nil
	MenuEquipSlot = nil
end
GVF.FilterMenu.HideMenu = function()
    if UIDROPDOWNMENU_OPEN_MENU == GVF.FilterMenu then
        CloseDropDownMenus()
    end
end

--MERCHANT_UPDATE
function GVF:FilterUpdate()
	local frame = EnumerateFrames()
	while frame do
		if frame:IsEventRegistered("MERCHANT_UPDATE") then
			local func = frame:GetScript("OnEvent")
			func(frame, "MERCHANT_UPDATE")
		end
		frame = EnumerateFrames(frame)
	end
	GenerateIndexLookup()
end

GVF.FilterButton = CreateFrame('Button',nil,MerchantFrame)
	GVF.FilterButton:SetWidth(30)
	GVF.FilterButton:SetHeight(30)
	GVF.FilterButton:SetPoint("TOPRIGHT", MerchantFrame, "TOPRIGHT",-55,-9)
	GVF.FilterButton:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]])
	GVF.FilterButton:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]])
	GVF.FilterButton:SetDisabledTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]])
	GVF.FilterButton:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])
	GVF.FilterButton:SetScript('OnClick', function(self)
		ToggleDropDownMenu(1, nil, GVF.FilterMenu, self, 0, 0)
	end)
	GVF.AllTexture = GVF.FilterButton:CreateTexture(nil, "OVERLAY")
		GVF.AllTexture:SetTexture([[Interface\Buttons\UI-Common-MouseHilight]])
		GVF.AllTexture:SetBlendMode('ADD')
		GVF.AllTexture:SetAllPoints(GVF.FilterButton)

local info, sortedFilters = {}, {}
GVF.FilterMenu.initialize = function(self, level)
	if not level then return end
    if level == 1 then
		wipe(info)
		wipe(sortedFilters)
		for k in pairs(GVF.filters) do
			sortedFilters[#sortedFilters+1] = k
		end
		table.sort(sortedFilters)

		for i = 1, #sortedFilters do
			if GVF.filters[sortedFilters[i]]:isRelevant() then
				-- Create the title of the menu
				info.isTitle = 1
				info.text = L[sortedFilters[i]]
				info.notCheckable = 1
				UIDropDownMenu_AddButton(info, level)

				GVF.filters[sortedFilters[i]]:GetDropdown(level)
			end
		end
		info.isTitle = nil
		info.disabled = nil
        info.notCheckable = 1
--[[
		info.text = RED_FONT_COLOR_CODE..L["Filter All"]
		info.keepShownOnClick = 1
		info.tooltipOnButton = 1
		info.tooltipWhileDisabled = 1
		info.tooltipTitle = L["Filter All"]
		info.tooltipText = L["Filter All desc"]
		info.func = function()
			for k, filter in pairs(GVF.filters) do
				filter:FilterAll()
			end
			ToggleDropDownMenu(1, nil, GVF.FilterMenu, GVF.FilterButton, 0, 0)
			ToggleDropDownMenu(1, nil, GVF.FilterMenu, GVF.FilterButton, 0, 0)
			GVF:FilterUpdate()
		end
		UIDropDownMenu_AddButton(info, level)
]]--
		info.tooltipOnButton = nil
		info.tooltipWhileDisabled = nil
		info.tooltipTitle = nil
		info.tooltipText = nil

		info.text = GREEN_FONT_COLOR_CODE..L["Show All"]
		info.func = function()
			for k, filter in pairs(GVF.filters) do
				filter:ShowAll()
			end
			ToggleDropDownMenu(1, nil, GVF.FilterMenu, GVF.FilterButton, 0, 0)
			ToggleDropDownMenu(1, nil, GVF.FilterMenu, GVF.FilterButton, 0, 0)
			GVF:FilterUpdate()
		end
		UIDropDownMenu_AddButton(info, level)

		info.text = NORMAL_FONT_COLOR_CODE..RESET
		info.keepShownOnClick = 1
		info.func = function()
			for k, filter in pairs(GVF.filters) do
				filter:ResetFilter()
			end
			ToggleDropDownMenu(1, nil, GVF.FilterMenu, GVF.FilterButton, 0, 0)
			ToggleDropDownMenu(1, nil, GVF.FilterMenu, GVF.FilterButton, 0, 0)
			GVF:FilterUpdate()
		end
		UIDropDownMenu_AddButton(info, level)
		
		info.text = GAMEOPTIONS_MENU
		info.keepShownOnClick = nil
		info.func = function()
			InterfaceOptionsFrame_OpenToCategory(GVF.optframe.GVF)
		end
		UIDropDownMenu_AddButton(info, level)
		
		info.text = CLOSE
		info.func = self.HideMenu
		UIDropDownMenu_AddButton(info, level)

	elseif level == 2 then
		for k, filter in pairs(GVF.filters) do
			filter:GetDropdown(level)
		end
	end
end

function GVF:ADDON_LOADED(event, addon)
	if addon == "GoblinVendorFilter" then
		self.frame:UnregisterEvent("ADDON_LOADED")
		self.ADDON_LOADED = nil
		if IsLoggedIn() then self:PLAYER_LOGIN() else self.frame:RegisterEvent("PLAYER_LOGIN") end
	end
end
GVF.frame:RegisterEvent("ADDON_LOADED")

function GVF:PLAYER_LOGIN(event, addon)
	local defaults = {
		['profile'] = {},
		['global'] = {},
	}

	for k, filter in pairs(self.filters) do
		if filter.WriteDefault then
			filter:WriteDefault(defaults)
		end
	end

	self.db = LibStub("AceDB-3.0"):New("GoblinVendorFilterDB", defaults)
	self:RegisterModuleOptions('profile', LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), 'Profile')

	self.db:RegisterCallback("OnProfileChanged", function() GVF:ProcessDB() end)
	self.db:RegisterCallback("OnProfileCopied", function() GVF:ProcessDB() end)
	self.db:RegisterCallback("OnProfileReset", function() GVF:ProcessDB() end)

	for k, filter in pairs(self.filters) do
		filter:ResetFilter()
	end
end

function GVF:ProcessDB()
	for k, filter in pairs(self.filters) do
		filter:ResetFilter()
	end
	if self.MerchantOpen then
		self:FilterUpdate()
	end
end

local IOFchild = CreateFrame('frame', nil, InterfaceOptionsFrame)
IOFchild:SetScript("OnShow", function()
	for k, filter in pairs(GVF.filters) do
		if filter.UpdateOptions then
			filter:UpdateOptions()
		end
	end
end)
IOFchild:SetScript("OnHide", function()
	for k, filter in pairs(GVF.filters) do
		filter:ResetFilter()
	end
end)

GVF.MainOption = {
	type="group",
	width = 'fill',
	handler = GVF,
	childGroups = 'tab',
	args = {},
	plugins = {
		filters = {}
	},
}
GVF.filterOptions = GVF.MainOption.plugins.filters

GVF.optframe = {}
LibStub("AceConfig-3.0"):RegisterOptionsTable('GVF', GVF.MainOption)
GVF.optframe.GVF = LibStub("AceConfigDialog-3.0"):AddToBlizOptions('GVF', 'GoblinVendorFilter')
-- function addapted from the RegisterModuleOptions function in Mapster
function GVF:RegisterModuleOptions(name, optionTbl, displayName)
	local cname = "GVF"..name
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(cname, optionTbl)
	self.optframe[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(cname, displayName, "GoblinVendorFilter")
end
