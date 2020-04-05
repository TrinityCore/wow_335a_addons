--[[
	InvData
		A wrapper libary for accessing inventory data
--]]

local InvData = Combuctor:NewModule('InventoryData', 'AceEvent-3.0')
local currentPlayer = UnitName('player')

--[[ Bank ]]--

function InvData:UpdateBank(event)
	self.atBank = (event == 'BANKFRAME_OPENED')
end

function InvData:AtBank()
	return self.atBank
end


--[[
	Bag Data Access
--]]

function InvData:GetInvSlot(bag)
	return bag > 0 and ContainerIDToInventoryID(bag)
end

function InvData:GetBagSize(bag, player)
	if self:IsCachedBag(bag, player) then
		return (BagnonDB and BagnonDB:GetBagData(bag, player)) or 0
	end
	return (bag == KEYRING_CONTAINER and GetKeyRingSize()) or GetContainerNumSlots(bag)
end

function InvData:GetBagLink(bag, player)
	if self:IsCachedBag(bag, player) then
		return BagnonDB and (select(2, BagnonDB:GetBagData(bag, player)))
	end
	return GetInventoryItemLink('player', self:GetInvSlot(bag))
end

function InvData:GetBagType(bag, player)
	if bag == KEYRING_CONTAINER then
		return 256
	elseif bag > 0 then
		local link = InvData:GetBagLink(bag, player)
		return link and GetItemFamily(link)
	else
		return 0
	end
end

--[[
	Item Data Access
--]]

--returns all information about an item
function InvData:GetItemInfo(bag, slot, player)
	local link, count, texture, quality, readable, cached, locked, _

	if self:IsCachedBag(bag, player) then
		if BagnonDB then
			link, count, texture, quality = BagnonDB:GetItemData(bag, slot, player)
			cached = true
		end
	else
		link = GetContainerItemLink(bag, slot)
		if link then
			texture, count, locked, _, readable = GetContainerItemInfo(bag, slot)
			quality = select(3, GetItemInfo(link))
		end
	end

	return link, count, texture, quality, locked, readable, cached
end


function InvData:GetItemLink(bag, slot, player)
	if self:IsCachedBag(bag, player) then
		return BagnonDB and (BagnonDB:GetItemData(bag, slot, player))
	end
	return GetContainerItemLink(bag, slot)
end

--returns the count of items in the given slot
function InvData:GetItemCount(bag, slot, player)
	if self:IsCachedBag(bag, player) then
		if BagnonDB then
			local link, count = BagnonDB:GetItemData(bag, slot, player)
			if link then
				return count or 1
			end
		else
			return 0
		end
	end
	return select(2, GetContainerItemInfo(bag, slot))
end


--[[ Bag Type Comparisons ]]--

--returns true if the given bag is cached AND we have a way of reading data for it
function InvData:IsCachedBag(bag, player)
	return currentPlayer ~= (player or currentPlayer) or (self:IsBankBag(bag) and not self:AtBank())
end

function InvData:IsInventoryBag(bag)
	return bag == KEYRING_CONTAINER or (bag > -1 and bag < 5)
end

function InvData:IsBankBag(bag)
	return (bag == BANK_CONTAINER or bag > 4)
end

--register those events
InvData:RegisterEvent('BANKFRAME_OPENED', 'UpdateBank')
InvData:RegisterEvent('BANKFRAME_CLOSED', 'UpdateBank')