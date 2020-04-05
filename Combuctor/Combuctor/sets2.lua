--[[
	sets.lua
		The Combuctor set API

	--[[ set object methods ]]--

	--updates the display icon for <set> and notifies combuctor if icon changes
	--triggers COMBUCTOR_SET_UPDATE_ICON	set, icon
	set:SetIcon(path)

	--updates the display name for <set> and notifies combuctor if name changes
	--triggers COMBUCTOR_SET_UPDATE_NAME	set, name
	set:SetName(name)

	--updates the rule method for <set> and notifies combuctor if the rule changes
	--triggers COMBUCTOR_SET_UPDATE_RULE	set, rule
	set:SetRule(rule)

	--forces combuctor to update the set, if displayed
	--triggers COMBUCTOR_SET_UPDATE	set
	set:Update()

	--removes the given set object
	--triggers COMBUCTOR_SET_REMOVE	set
	set:Destroy()

	--returns true if the given slot is contained in the set, and false otherwise
	true | false = set:ContainsSlot(player, bagType, <GetItemInfo() return values...>)

	--adds a new subset to the given set
	--should blow up if attempting to add a subset of a subset
	--triggers COMBUCTOR_SET_ADD set
	set = set:AddChild(id, name, icon, rule)

	--usage
	--for i, subSet in set:GetChildren() do
	iterator = set:GetChildren()


	--[[ set meta methods ]]--

	--creates a new set
	--triggers COMBUCTOR_SET_ADD set
	local set = CombuctorSet:Add(id, name, icon, rule)

	local set = CombuctorSet:Get(id, parent)

	--usage
	--for i, set in CombuctorSet:GetAll() do
	iterator = CombuctorSet:GetAll()
--]]

local CombuctorSet = Combuctor:NewModule('Sets', 'AceEvent-3.0')


--[[ local set methods ]]--

local Set = {}
local set_mt = {__index = Set}
local sets = {}

local function Set_Get(id, parent)
	assert(id, 'Set must have an ID')

	for i, set in pairs(sets) do
		if set.id == id and set.parent == parent then
			return set
		end
	end
	return nil
end

local function Set_New(id, parent, name, icon, rule)
	assert(id, 'Set must have an ID')
	assert(not Set_Get(id, parent), format('Set (%s, %s) already exists', id, parent or 'nil'))

	local set = {
		['id'] = id,
		['name'] = name,
		['parent'] = parent,
		['icon'] = icon,
		['rule'] = rule
	}

	set = setmetatable(set, set_mt)
	table.insert(sets, set)

	CombuctorSet:SendMessage('COMBUCTOR_SET_ADD', set)
	return set
end

--returns true if the set was removed from the setlist, and false otherwise
local function Set_Remove(id, parent)
	assert(id, 'Set must have an ID')

	for i, set in pairs(sets) do
		if set.id == id and set.parent == parent then
			table.remove(sets, i)
			CombuctorSet:SendMessage('COMBUCTOR_SET_REMOVE', set)
			return true
		end
	end
	return false
end

local function setIterator(parent, i)
	for j = i + 1, #sets do
		local set = sets[j]
		if set and set.parent == parent then
			return j, set
		end
	end
end


--[[
	Set Object Methods
--]]

--display name
function Set:SetName(name)
	if self.name ~= name then
		self.name = name
		CombuctorSet:SendMessage('COMBUCTOR_SET_UPDATE_NAME', self, name)
	end
end

function Set:GetName()
	return self.name or self.id
end

--display icon
function Set:SetIcon(icon)
	if self.icon ~= icon then
		self.icon = icon
		CombuctorSet:SendMessage('COMBUCTOR_SET_UPDATE_ICON', self, icon)
	end
end

function Set:GetIcon()
	return self.icon
end

--rule
function Set:SetRule(rule)
	if self.rule ~= rule then
		self.rule = rule
		CombuctorSet:SendMessage('COMBUCTOR_SET_UPDATE_RULE', self, rule)
	end
end

function Set:GetRule()
	return self.rule
end

--accessor, returns true if the given slot is contained in the set and false otherwise
function Set:ContainsSlot(player, bagType, name, link, quality, reqLevel, iLvl, type, subType, stackCount, equipLoc)
	if self.rule then
		return self:rule(player, bagType, name, link, quality, reqLevel, iLvl, type, subType, stackCount, equipLoc)
	end
	return true
end

--forces a set update event
function Set:ForceUpdate()
	CombuctorSet:SendMessage('COMBUCTOR_SET_UPDATE', self)
end

--child management
function Set:AddChild(name, icon, rule)
	assert(not self.parent, 'Cannot create a subset of a subset')

	return Set_New(id, self.id, name, icon, rule)
end

function Set:GetChild(id)
	return Set_Get(id, self.id)
end

--iterator
--usage: for i, subSet in set:GetChildren() do
--	print(set:GetName(), set:GetIcon(), set:GetRule())
function Set:GetChildren()
	return setIterator, self.id, 0
end

--destructor
function Set:Destroy()
	return Set_Remove(self.id, self.parent)
end


--[[
	Meta Set Methods
--]]

--set constructor
function CombuctorSet:Add(id, name, icon, rule)
	return Set_New(id, nil, name, icon, rule)
end

function CombuctorSet:Get(id, parent)
	return Set_Get(id, parent)
end

--iterator
--usage: for i, subSet in set:GetChildren() do
--	print(set:GetName(), set:GetIcon(), set:GetRule())
function CombuctorSet:GetParentSets()
	return setIterator, nil, 0
end