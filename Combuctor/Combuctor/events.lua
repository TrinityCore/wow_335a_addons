--[[
	BagEvents
		A library of functions for accessing and updating bag slot information

	Based on SpecialEvents-Bags by Tekkub Stoutwrithe (tekkub@gmail.com)

	COMBUCTOR_SLOT_ADD
	args:		bag, slot, link, count, locked, coolingDown
		called when a new slot becomes available to the player

	COMBUCTOR_SLOT_REMOVE
	args:		bag, slot
		called when an item slot is removed from being in use

	COMBUCTOR_SLOT_UPDATE
	args:		bag, slot, link, count, locked, coolingDown
		called when an item slot's item or item count changes

	COMBUCTOR_SLOT_UPDATE_LOCK
		args:		bag, slot, locked
		called when an item slot is locked or unlocked

	COMBUCTOR_SLOT_UPDATE_COOLDOWN
	args:		bag, slot, coolingDown
		called when an item's cooldown starts/ends

	COMBUCTOR_BANK_OPENED
	args:		none
		called when the bank has opened and all of the bagnon events have fired

	COMBUCTOR_BANK_CLOSED
	args:		none
		called when the bank is closed and all of the bagnon events have fired

	COMBUCTOR_BAG_TYPE_CHANGED
	args:		bag, bagType, bagSubType
		called when a bag is gained/lost or changes from one type to another
--]]

local BagEvents = Combuctor:NewModule('Events', 'AceEvent-3.0')
BagEvents.atBank = false
BagEvents.firstVisit = true

local slots = {}
local bagSubTypes = {}

local function ToIndex(bag, slot)
	return (bag < 0 and bag*100 - slot) or bag*100 + slot
end

local function GetBagSize(bag)
	return (bag == KEYRING_CONTAINER and GetKeyRingSize()) or GetContainerNumSlots(bag)
end


--[[ Update Functions ]]--

--all info
function BagEvents:AddItem(bag, slot)
	local index = ToIndex(bag,slot)
	if not slots[index] then slots[index] = {} end

	local data = slots[index]
	local link = GetContainerItemLink(bag, slot)
	local count, locked = select(2, GetContainerItemInfo(bag, slot))
	local start, duration, enable = GetContainerItemCooldown(bag, slot)
	local onCooldown = (start > 0 and duration > 0 and enable > 0)

	data[1] = link
	data[2] = count
	data[3] = locked
	data[4] = onCooldown

	self:SendMessage('COMBUCTOR_SLOT_ADD', bag, slot, link, count, locked, onCooldown)
end

function BagEvents:RemoveItem(bag, slot)
	local data = slots[ToIndex(bag, slot)]

	if data and next(data) then
		local prevLink = data[1]
		for i in pairs(data) do
			data[i] = nil
		end
		self:SendMessage('COMBUCTOR_SLOT_REMOVE', bag, slot, prevLink)
	end
end

function BagEvents:UpdateItem(bag, slot)
	local data = slots[ToIndex(bag, slot)]

	if data then
		local prevLink = data[1]
		local prevCount = data[2]

		local link = GetContainerItemLink(bag, slot)
		local count, locked = select(2, GetContainerItemInfo(bag, slot))
		local start, duration, enable = GetContainerItemCooldown(bag, slot)
		local onCooldown = (start > 0 and duration > 0 and enable > 0)

		if not(prevLink == link and prevCount == count) then
			data[1] = link
			data[2] = count
			data[3] = locked
			data[4] = onCooldown

			self:SendMessage('COMBUCTOR_SLOT_UPDATE', bag, slot, link, count, locked, onCooldown)
		end
	end
end

function BagEvents:UpdateItems(bag)
	for slot = 1, GetBagSize(bag) do
		self:UpdateItem(bag, slot)
	end
end

--lock
function BagEvents:UpdateLock(bag, slot)
	local data = slots[ToIndex(bag,slot)]

	if data and data[1] then
		local locked = select(3, GetContainerItemInfo(bag, slot))
		if data[3] ~= locked then
			data[3] = locked
			self:SendMessage('COMBUCTOR_SLOT_UPDATE_LOCK', bag, slot, locked)
		end
	end
end

function BagEvents:UpdateLocks(bag)
	for slot = 1, GetBagSize(bag) do
		self:UpdateLock(bag, slot)
	end
end

--cooldowns
function BagEvents:UpdateCooldown(bag, slot)
	local data = slots[ToIndex(bag,slot)]

	if data and data[1] then
		local start, duration, enable = GetContainerItemCooldown(bag, slot)
		local onCooldown = (start > 0 and duration > 0 and enable > 0)

		if data[4] ~= onCooldown then
			data[4] = onCooldown
			self:SendMessage('COMBUCTOR_SLOT_UPDATE_COOLDOWN', bag, slot, onCooldown)
		end
	end
end

function BagEvents:UpdateCooldowns(bag)
	for slot = 1, GetBagSize(bag) do
		self:UpdateCooldown(bag, slot)
	end
end

--bag sizes
function BagEvents:UpdateBagSize(bag)
	local prevSize = slots[bag*100] or 0
	local newSize = GetBagSize(bag) or 0
	slots[bag*100] = newSize

	if prevSize > newSize then
		for slot = newSize+1, prevSize do
			self:RemoveItem(bag, slot)
		end
	elseif prevSize < newSize then
		for slot = prevSize+1, newSize do
			self:AddItem(bag, slot)
		end
	end
end

function BagEvents:UpdateBagType(bag)
	local link = GetInventoryItemLink('player', ContainerIDToInventoryID(bag))
	local type, subType
	if link then
		type, subType = select(6, GetItemInfo(link))
	end

	if subType ~= bagSubTypes[bag] then
		bagSubTypes[bag] = subType
		self:SendMessage('COMBUCTOR_BAG_TYPE_CHANGED', bag, type, subType)
	end
end

function BagEvents:UpdateBagSizesAndTypes()
	if self:AtBank() then
		for bag = 1, GetNumBankSlots() + 4 do
			self:UpdateBagSize(bag)
			self:UpdateBagType(bag)
		end
	else
		for bag = 1, 4 do
			self:UpdateBagSize(bag)
			self:UpdateBagType(bag)
		end
	end
	self:UpdateBagSize(KEYRING_CONTAINER)
end



--[[ Events ]]--

--player login
function BagEvents:OnEnable()
	self:RegisterEvent('BAG_UPDATE')
	self:RegisterEvent('ITEM_LOCK_CHANGED')
	self:RegisterEvent('BAG_UPDATE_COOLDOWN')
	self:RegisterEvent('PLAYERBANKSLOTS_CHANGED')
	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED')

	self:UpdateBagSize(KEYRING_CONTAINER)
	self:UpdateItems(KEYRING_CONTAINER)

	self:UpdateBagSize(BACKPACK_CONTAINER)
	self:UpdateItems(BACKPACK_CONTAINER)
end

function BagEvents:BAG_UPDATE(event, bag)
	self:UpdateBagSizesAndTypes()
	self:UpdateItems(bag)
end

function BagEvents:PLAYERBANKSLOTS_CHANGED()
	self:UpdateBagSizesAndTypes()

	self:UpdateItems(BANK_CONTAINER)
end

function BagEvents:BANKFRAME_OPENED()
	self.atBank = true

	if self.firstVisit then
		self.firstVisit = nil
		self:UpdateBagSize(BANK_CONTAINER)
		self:UpdateBagSizesAndTypes()
	end

	self:SendMessage('COMBUCTOR_BANK_OPENED')
end

function BagEvents:BANKFRAME_CLOSED()
	self.atBank = false
	self:SendMessage('COMBUCTOR_BANK_CLOSED')
end

function BagEvents:ITEM_LOCK_CHANGED()
	if self:AtBank() then
		for bag = -2, GetNumBankSlots() + 4 do
			self:UpdateLocks(bag)
		end
	else
		for bag = 0, 4 do
			self:UpdateLocks(bag)
		end
		self:UpdateLocks(KEYRING_CONTAINER)
	end
end

function BagEvents:BAG_UPDATE_COOLDOWN()
	for bag = 0, 4 do
		self:UpdateCooldowns(bag)
	end
end

--[[ Accessor Methods ]]--

function BagEvents:AtBank()
	return self.atBank
end