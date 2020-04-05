--[[
	A combuctor panel for adding and removing categories from the bank/inventory frames
		This is a rush job, I should redo it later
--]]

local CombuctorSet = Combuctor:GetModule('Sets')
local L = LibStub("AceLocale-3.0"):GetLocale("Combuctor")
local MAX_ITEMS = 13
local height, offset = 26, 0
local selected = {}
local items = {}
local profile = Combuctor:GetProfile()
local key = 'inventory'

local function AddSet(name)
	local info = Combuctor:GetProfile()[key]
	local sets = info.sets

	for i, set in pairs(sets) do
		if set.name == name then
			return
		end
	end
	table.insert(sets, name)
	Combuctor:SendMessage('COMBUCTOR_CONFIG_SET_ADD', key, name)
end

local function RemoveSet(name)
	local info = Combuctor:GetProfile()[key]
	local sets = info.sets

	for i,set in pairs(sets) do
		if set == name then
			table.remove(sets, i)
			Combuctor:SendMessage('COMBUCTOR_CONFIG_SET_REMOVE', key, name)
			break
		end
	end
end

local function AddSubSet(name, parent)
	local info = Combuctor:GetProfile()[key]
	local exclude = info.exclude[parent]

	if exclude then
		for i,set in pairs(exclude) do
			if set == name then
				table.remove(exclude, i)
				if #exclude < 1 then
					info.exclude[parent] = nil
				end

				Combuctor:SendMessage('COMBUCTOR_CONFIG_SUBSET_ADD', key, name, parent)
				break
			end
		end
	end
end

local function RemoveSubSet(name, parent)
	local info = Combuctor:GetProfile()[key]
	local exclude = info.exclude[parent]

	if exclude then
		for i,set in pairs(exclude) do
			if set == name then
				return
			end
		end
		table.insert(exclude, name)
	else
		info.exclude[parent] = {name}
	end
	Combuctor:SendMessage('COMBUCTOR_CONFIG_SUBSET_REMOVE', key, name, parent)
end

local function HasSet(name)
	local info = Combuctor:GetProfile()[key]

	for i,setName in pairs(info.sets) do
		if setName == name then
			return true
		end
	end
	return false
end

local function HasSubSet(name, parent)
	local info = Combuctor:GetProfile()[key]
	local exclude = info.exclude[parent]

	if exclude then
		for j,child in pairs(exclude) do
			if child == name then
				return false
			end
		end
	end
	return true
end

--list button
local function ListButtonCheck_OnClick(self)
	local set = self:GetParent().set
	if set.parent then
		if self:GetChecked() then
			AddSubSet(set.name, set.parent)
		else
			RemoveSubSet(set.name, set.parent)
		end
	else
		if self:GetChecked() then
			AddSet(set.name)
		else
			RemoveSet(set.name)
		end
	end
end

local function ListButtonToggle_OnClick(self)
	local set = self:GetParent().set

	selected[set.name] = not selected[set.name]
	self:GetParent():GetParent():UpdateList()
end

local function ListButton_Set(self, set)
	self.set = set

	if set.icon then
		getglobal(self.check:GetName() .. 'Text'):SetFormattedText('|T%s:%d|t %s', set.icon, 28, set.name)
	else
		getglobal(self.check:GetName() .. 'Text'):SetText(set.name)
	end

	if set.parent then
		self.toggle:Hide()
	else
		self.toggle:Show()

		if selected[set.name] then
			self.toggle:SetNormalTexture('Interface\\Buttons\\UI-MinusButton-UP')
			self.toggle:SetPushedTexture('Interface\\Buttons\\UI-MinusButton-DOWN')
		else
			self.toggle:SetNormalTexture('Interface\\Buttons\\UI-PlusButton-UP')
			self.toggle:SetPushedTexture('Interface\\Buttons\\UI-PlusButton-DOWN')
		end
	end

	if set.parent then
		self.check:SetChecked(HasSubSet(set.name, set.parent))
	else
		self.check:SetChecked(HasSet(set.name))
	end
end

local function ListButton_Create(id, parent)
	local name = format('%sButton%d', parent:GetName(), id)
	local b = CreateFrame('Frame', name, parent)
	b:SetWidth(200)
	b:SetHeight(24)
	b.Set = ListButton_Set

	local toggle = CreateFrame('Button', nil, b)
	toggle:SetPoint('LEFT', b)
	toggle:SetWidth(14)
	toggle:SetHeight(14)
	toggle:SetNormalTexture('Interface\\Buttons\\UI-PlusButton-UP')
	toggle:SetPushedTexture('Interface\\Buttons\\UI-PlusButton-DOWN')
	toggle:SetHighlightTexture('Interface\\Buttons\\UI-PlusButton-Hilight')
	toggle:SetScript('OnClick', ListButtonToggle_OnClick)
	b.toggle = toggle

	local check = CreateFrame('CheckButton', name .. 'Check', b, 'InterfaceOptionsCheckButtonTemplate')
	check:SetScript('OnClick', ListButtonCheck_OnClick)
	check:SetPoint('LEFT', toggle, 'RIGHT', 4, 0)
	b.check = check

	return b
end


--[[ Panel Functions ]]--

local function Panel_UpdateList(self)
	local items = {}

	for _,parentSet in CombuctorSet:GetParentSets() do
		table.insert(items, parentSet)
		if selected[parentSet.name] then
			for _,childSet in CombuctorSet:GetChildSets(parentSet.name) do
				table.insert(items, childSet)
			end
		end
	end

	local scrollFrame = self.scrollFrame
	local offset = FauxScrollFrame_GetOffset(scrollFrame)
	local i = 1

	while i <= MAX_ITEMS and items[i + offset] do
		local button = self.buttons[i]
		button:Set(items[i + offset])

		local offLeft = button.set.parent and 24 or 0
		button:SetPoint('TOPLEFT', 14 + offLeft, -(86 + button:GetHeight() * i))
		button:Show()

		i = i + 1
	end

	for j = i, #self.buttons do
		self.buttons[j]:Hide()
	end

	FauxScrollFrame_Update(scrollFrame, #items, MAX_ITEMS, self.buttons[1]:GetHeight())
end

local info = {}
local function AddItem(text, value, func, checked, arg1)
	info.text = text
	info.func = func
	info.value = value
	info.checked = checked
	info.arg1 = arg1
	UIDropDownMenu_AddButton(info)
end

local function AddFrameSelector(self)
	local dd = self:NewDropdown('Frame')

	dd:SetScript('OnShow', function(self)
		UIDropDownMenu_SetWidth(self, 110)
		UIDropDownMenu_Initialize(self, self.Initialize)
		UIDropDownMenu_SetSelectedValue(self, key)
	end)

	local function Key_OnClick(self)
		key = self.value
		UIDropDownMenu_SetSelectedValue(dd, self.value)
		dd:GetParent():UpdateList()
	end

	function dd:Initialize()
		AddItem(L.Inventory, 'inventory', Key_OnClick, 'inventory' == key)
		AddItem(L.Bank, 'bank', Key_OnClick, 'bank' == key)
	end
	return dd
end


do
	local panel = Combuctor.Options
	panel.UpdateList = Panel_UpdateList
	panel:SetScript('OnShow', function(self) self:UpdateList() end)
	panel:SetScript('OnHide', function(self) selected = {} end)

	local name = panel:GetName()

	local dropdown = AddFrameSelector(panel)
	dropdown:SetPoint('TOPLEFT', 6, -72)

	local scroll = CreateFrame('ScrollFrame', name .. 'ScrollFrame', panel, 'FauxScrollFrameTemplate')
	scroll:SetScript('OnVerticalScroll', function(self, arg1)
		FauxScrollFrame_OnVerticalScroll(self, arg1, height + offset, function()
			panel:UpdateList()
		end)
	end)
	scroll:SetPoint('TOPLEFT', 6, -92)
	scroll:SetPoint('BOTTOMRIGHT', -32, 8)
	panel.scrollFrame = scroll

	panel.buttons = setmetatable({}, {__index = function(t, k)
		t[k] = ListButton_Create(k, panel)
		return t[k]
	end})
end