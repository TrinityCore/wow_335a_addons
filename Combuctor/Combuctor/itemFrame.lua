--[[
	itemFrame.lua
		A thingy that displays items
--]]

local ItemFrame = Combuctor:NewClass('Button')
Combuctor.ItemFrame = ItemFrame

--local bindings
local FrameEvents = Combuctor:GetModule('ItemFrameEvents')
local ItemSearch = LibStub('LibItemSearch-1.0')

--InvDataity functions
local function ToIndex(bag, slot)
	return (bag<0 and bag*100 - slot) or (bag*100 + slot)
end

local function ToBag(index)
	return (index > 0 and floor(index/100)) or ceil(index/100)
end


--[[
	Constructor
--]]

function ItemFrame:New(parent)
	local f = self:Bind(CreateFrame('Button', nil, parent))
	f.items = {}
	f.bags = parent.sets.bags
	f.filter = parent.filter
	f.count = 0

	f:RegisterForClicks('anyUp')
	f:SetScript('OnShow', self.OnShow)
	f:SetScript('OnHide', self.OnHide)
	f:SetScript('OnClick', self.PlaceItem)

	return f
end

function ItemFrame:OnShow()
	self:UpdateUpdatable()
	self:Regenerate()
end

function ItemFrame:OnHide()
	self:UpdateUpdatable()
end

function ItemFrame:UpdateUpdatable()
	if self:IsVisible() then
		FrameEvents:Register(self)
	else
		FrameEvents:Unregister(self)
	end
end


--[[ Player Filtering ]]--

function ItemFrame:SetPlayer(player)
	self.player = player
	self:ReloadAllItems()
end

function ItemFrame:GetPlayer()
	return self.player or UnitName('player')
end


--[[ Item Updating ]]--

--returns true if the item matches the given filter, false othewise
function ItemFrame:HasItem(bag, slot, link)
	--check for the bag
	local hasBag = false
	for _,bagID in pairs(self.bags) do
		if bag == bagID then
			hasBag = true
			break
		end
	end
	if not hasBag then
		return false
	end

	--do filter checks
	local f = self.filter
	if next(f) then
		local player = self:GetPlayer()
		local bagType = self:GetBagType(bag)
		local link = link or self:GetItemLink(bag, slot)

		local name, quality, level, ilvl, type, subType, stackCount, equipLoc
		if link then
			name, link, quality, level, ilvl, type, subType, stackCount, equipLoc = GetItemInfo(link)
		end

		if f.quality and quality ~= f.quality then
			return false
		elseif f.rule and not f.rule(player, bagType, name, link, quality, level, ilvl, type, subType, stackCount, equipLoc) then
			return false
		elseif f.subRule and not f.subRule(player, bagType, name, link, quality, level, ilvl, type, subType, stackCount, equipLoc) then
			return false
		--text search
		elseif f.name then
			return ItemSearch:Find(link, f.name)
		end
	end
	return true
end

function ItemFrame:AddItem(bag, slot)
	local index = ToIndex(bag, slot)
	local item = self.items[index]

	if item then
		item:Update()
		item:Highlight(self.highlightBag == bag)
	else
		local item = Combuctor.ItemSlot:New()
		item:Set(self, bag, slot)
		item:Highlight(self.highlightBag == bag)

		self.items[index] = item
		self.count = self.count + 1
		return true
	end
end

function ItemFrame:RemoveItem(bag, slot)
	local index = ToIndex(bag, slot)
	local item = self.items[index]

	if item then
		item:Free()
		self.items[index] = nil
		self.count = self.count - 1
		return true
	end
end

function ItemFrame:UpdateSlot(bag, slot, link)
	if self:HasItem(bag, slot, link) then
		return self:AddItem(bag, slot)
	end
	return self:RemoveItem(bag, slot)
end

function ItemFrame:UpdateSlotLock(bag, slot)
	if not slot then return end

	local item = self.items[ToIndex(bag, slot)]
	if item then
		item:UpdateLocked()
	end
end

function ItemFrame:UpdateSlotCooldown(bag, slot)
	local item = self.items[ToIndex(bag, slot)]
	if item then
		item:UpdateCooldown()
	end
end

function ItemFrame:UpdateSlotCooldowns()
	for _,item in pairs(self.items) do
		item:UpdateCooldown()
	end
end


--[[ Mass Item Changes ]]--

--update all items and layout the frame
function ItemFrame:Regenerate()
	--no need to regenerate if we're hidden, since we're forcing one when shown
	if not self:IsVisible() then return end

	local changed = false

	for _,bag in pairs(self.bags) do
		for slot = 1, self:GetBagSize(bag) do
			if self:UpdateSlot(bag, slot) then
				changed = true
			end
		end
	end

	if changed then
		self:RequestLayout()
	end
end

--remove all items from the frame
function ItemFrame:RemoveAllItems()
	local items = self.items
	local changed = true

	for i,item in pairs(items) do
		changed = true
		item:Free()
		items[i] = nil
	end
	self.count = 0

	return changed
end

--completely regenerate the frame
function ItemFrame:ReloadAllItems()
	if self:RemoveAllItems() and self:IsVisible() then
		self:Regenerate()
	end
end


--[[ Item Layout ]]--

function ItemFrame:RequestLayout()
	self.needsLayout = true
	self:TriggerLayout()
end

function ItemFrame:TriggerLayout()
	if self:IsVisible() and self.needsLayout then
		FrameEvents:RequestLayout(self)
	end
end

--layout all the item buttons, scaling ot fit inside the fram
--todo: dividers for bags v bank
function ItemFrame:Layout(spacing)
	local width, height = self:GetWidth(), self:GetHeight()
	local spacing = spacing or 2
	local count = self.count
	local size = 36 + spacing*2
	local cols = 0
	local scale, rows
	local maxScale = Combuctor:GetMaxItemScale()

	repeat
		cols = cols + 1
		scale = width / (size*cols)
		rows = floor(height / (size*scale))
	until(scale <= maxScale and cols*rows >= count)

	--layout the items
	local player = self:GetPlayer()
	local items = self.items
	local i = 0

	for _,bag in ipairs(self.bags) do
		for slot = 1, self:GetBagSize(bag) do
			local item = items[ToIndex(bag, slot)]
			if item then
				i = i + 1
				local row = mod(i-1,cols)
				local col = ceil(i/cols)-1
				item:ClearAllPoints()
				item:SetScale(scale)
				item:SetPoint('TOPLEFT', self, 'TOPLEFT', size*row + spacing, -(size*col + spacing))
				item:Show()
			end
		end
	end
end


--[[ Item Slot Highlighting ]]--

--highlights an item if it belongs to the selected bag
function ItemFrame:HighlightBag(bag)
	self.highlightBag = bag
	for _,item in pairs(self.items) do
		item:Highlight(item:GetBag() == bag)
	end
end


--[[ Item Placement ]]--

function ItemFrame:GetBagSize(bag)
	return Combuctor.BagSlotInfo:GetSize(self:GetPlayer(), bag)
end

function ItemFrame:GetBagType(bag)
	return Combuctor.BagSlotInfo:GetBagType(self:GetPlayer(), bag)
end

function ItemFrame:IsBagCached(bag)
	return Combuctor.BagSlotInfo:IsCached(self:GetPlayer(), bag)
end

function ItemFrame:GetItemLink(bag, slot)
	local link = select(7, Combuctor.ItemSlotInfo:GetItemInfo(self:GetPlayer(), bag, slot))
	return link
end

--places the item in the first available slot in the current player's visible bags
--todo: make smarter
function ItemFrame:PlaceItem()
	if CursorHasItem() then
		for _,bag in ipairs(self.bags) do
			--this check is basically in case i decide, 'you know what would be awesome? bank and items in the same frame' again
			if not self:IsBagCached(bag) then
				for slot = 1, self:GetBagSize(bag) do
					if not GetContainerItemLink(bag, slot) then
						PickupContainerItem(bag, slot)
					end
				end
			end
		end
	end
end