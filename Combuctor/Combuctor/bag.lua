--[[
	ba.lua
		A bag button object
--]]

local Bag = Combuctor:NewClass('Button')
Combuctor.Bag = Bag

--local bindings
local L = LibStub('AceLocale-3.0'):GetLocale('Combuctor')

--[[ Constructor/Destructor ]]--

local SIZE = 30
local NORMAL_TEXTURE_SIZE = 64 * (SIZE/36)

local unused = {}
local id = 1

function Bag:New()
	local bag = self:Bind(CreateFrame('Button', format('CombuctorBag%d', id)))
	local name = bag:GetName()
	bag:SetWidth(SIZE); bag:SetHeight(SIZE)

	local icon = bag:CreateTexture(name .. 'IconTexture', 'BORDER')
	icon:SetAllPoints(bag)

	local count = bag:CreateFontString(name .. 'Count', 'OVERLAY')
	count:SetFontObject('NumberFontNormalSmall')
	count:SetJustifyH('RIGHT')
	count:SetPoint('BOTTOMRIGHT', -2, 2)

	local nt = bag:CreateTexture(name .. 'NormalTexture')
	nt:SetTexture([[Interface\\Buttons\\UI-Quickslot2]])
	nt:SetWidth(NORMAL_TEXTURE_SIZE)
	nt:SetHeight(NORMAL_TEXTURE_SIZE)
	nt:SetPoint('CENTER', 0, -1)
	bag:SetNormalTexture(nt)

	local pt = bag:CreateTexture()
	pt:SetTexture([[Interface\Buttons\UI-Quickslot-Depress]])
	pt:SetAllPoints(bag)
	bag:SetPushedTexture(pt)

	local ht = bag:CreateTexture()
	ht:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	ht:SetAllPoints(bag)
	bag:SetHighlightTexture(ht)

	bag:RegisterForClicks('anyUp')
	bag:RegisterForDrag('LeftButton')

	bag:SetScript('OnEnter', self.OnEnter)
	bag:SetScript('OnShow', self.OnShow)
	bag:SetScript('OnLeave', self.OnLeave)
	bag:SetScript('OnClick', self.OnClick)
	bag:SetScript('OnDragStart', self.OnDrag)
	bag:SetScript('OnReceiveDrag', self.OnClick)
	bag:SetScript('OnEvent', self.OnEvent)

	id = id + 1
	return bag
end

function Bag:Get()
	local f = next(unused)
	if f then
		unused[f] = nil
		return f
	end
	return self:New()
end

function Bag:Set(parent, id)
	self:SetID(id)
	self:SetParent(parent)

	if self:IsBank() or self:IsBackpack() then
		SetItemButtonTexture(self, [[Interface\Buttons\Button-Backpack-Up]])
		SetItemButtonTextureVertexColor(self, 1, 1, 1)
	else
		self:Update()

		self:RegisterEvent('ITEM_LOCK_CHANGED')
		self:RegisterEvent('CURSOR_UPDATE')
		self:RegisterEvent('BAG_UPDATE')
		self:RegisterEvent('PLAYERBANKSLOTS_CHANGED')

		if self:IsBankBagSlot() then
			self:RegisterEvent('BANKFRAME_OPENED')
			self:RegisterEvent('BANKFRAME_CLOSED')
			self:RegisterEvent('PLAYERBANKBAGSLOTS_CHANGED')
		end
	end
end

function Bag:Release()
	unused[self] = true

	self:SetParent(nil)
	self:Hide()
	self:UnregisterAllEvents()
	_G[self:GetName() .. 'Count']:Hide()
end


--[[ Frame Events ]]--

function Bag:OnEvent(event)
	if event == 'BANKFRAME_OPENED' or event == 'BANKFRAME_CLOSED' then
		self:Update()
	elseif not self:IsCached() then
		if event == 'ITEM_LOCK_CHANGED' then
			self:UpdateLock()
		elseif event == 'CURSOR_UPDATE' then
			self:UpdateCursor()
		elseif event == 'BAG_UPDATE' or event == 'PLAYERBANKSLOTS_CHANGED' then
			self:Update()
		elseif event == 'PLAYERBANKBAGSLOTS_CHANGED' then
			self:Update()
		end
	end
end

function Bag:OnClick(button)
	local link = (self:GetItemInfo())
	if link and HandleModifiedItemClick(link) then
		return
	end

	if self:IsCached() then
		return
	end

	if self:IsPurchasable()then
		self:PurchaseSlot()
	elseif CursorHasItem() then
		if self:IsBackpack() then
			PutItemInBackpack()
		elseif self:IsKeyRing() then
			PutKeyInKeyRing()
		else
			PutItemInBag(self:GetInventorySlot())
		end
	elseif not(self:IsBackpack() or self:IsBank()) then
		self:Pickup()
	end
end

function Bag:OnDrag()
	if not self:IsCached() then
		self:Pickup()
	end
end

function Bag:OnEnter()
	if self:GetRight() > (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end

	self:UpdateTooltip()
	self:HighlightItems()
	self:GetParent().itemFrame:HighlightBag(self:GetID())
end

function Bag:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
	self:ClearHighlightItems()
end

function Bag:OnShow()
	self:Update()
end


--[[ Update ]]--

function Bag:Update()
	if not self:IsVisible() then return end

	self:UpdateLock()
	self:UpdateSlotInfo()
	self:UpdateCursor()
end

function Bag:UpdateLock()
	if not self:IsBagSlot() then return end

	SetItemButtonDesaturated(self, self:IsLocked())
end

function Bag:UpdateCursor()
	if not self:IsBagSlot() then return end

	if CursorCanGoInSlot(self:GetInventorySlot()) then
		self:LockHighlight()
	else
		self:UnlockHighlight()
	end
end

function Bag:UpdateSlotInfo()
	if not self:IsBagSlot() then return end

	local link, count, texture = self:GetItemInfo()
	if link then
		self.hasItem = link

		SetItemButtonTexture(self, texture or GetItemIcon(link))
		SetItemButtonTextureVertexColor(self, 1, 1, 1)
	else
		self.hasItem = nil

		SetItemButtonTexture(self, [[Interface\PaperDoll\UI-PaperDoll-Slot-Bag]])

		--color red if the bag can be purchased
		if self:IsPurchasable() then
			SetItemButtonTextureVertexColor(self, 1, 0.1, 0.1)
		else
			SetItemButtonTextureVertexColor(self, 1, 1, 1)
		end
	end
	self:SetCount(count)
end

function Bag:SetCount(count)
	local text = _G[self:GetName() .. 'Count']
	local count = count or 0

	if count > 1 then
		if count > 999 then
			text:SetFormattedText('%.1fk', count/1000)
		else
			text:SetText(count)
		end
		text:Show()
	else
		text:Hide()
	end
end

function Bag:Pickup()
	PlaySound('BAGMENUBUTTONPRESS')
	PickupBagFromSlot(self:GetInventorySlot())
end

function Bag:HighlightItems()
	self:GetParent().itemFrame:HighlightBag(self:GetID())
end

function Bag:ClearHighlightItems()
	self:GetParent().itemFrame:HighlightBag(nil)
end

--show the purchase slot dialog
function Bag:PurchaseSlot()
	if not StaticPopupDialogs['CONFIRM_BUY_BANK_SLOT_COMBUCTOR'] then
		StaticPopupDialogs['CONFIRM_BUY_BANK_SLOT_COMBUCTOR'] = {
			text = TEXT(CONFIRM_BUY_BANK_SLOT),
			button1 = TEXT(YES),
			button2 = TEXT(NO),

			OnAccept = function(self) PurchaseSlot() end,

			OnShow = function(self) MoneyFrame_Update(self:GetName().. 'MoneyFrame', GetBankSlotCost(GetNumBankSlots())) end,

			hasMoneyFrame = 1,
			timeout = 0,
			hideOnEscape = 1,
		}
	end

	PlaySound('igMainMenuOption')
	StaticPopup_Show('CONFIRM_BUY_BANK_SLOT_COMBUCTOR')
end


--[[ Tooltip ]]--

function Bag:UpdateTooltip()
	GameTooltip:ClearLines()

	if self:IsBackpack() then
		GameTooltip:SetText(BACKPACK_TOOLTIP, 1, 1, 1)
	elseif self:IsBank() then
		GameTooltip:SetText(L.Bank, 1, 1, 1)
	elseif self:IsKeyRing() then
		GameTooltip:SetText(KEYRING, 1, 1, 1)
	elseif self:IsCached() then
		self:UpdateCachedBagTooltip()
	else
		self:UpdateBagTooltip()
	end


	GameTooltip:Show()
end

function Bag:UpdateCachedBagTooltip()
	local link = (self:GetItemInfo())
	if link then
		GameTooltip:SetHyperlink(link)
	elseif self:IsPurchasable() then
		GameTooltip:SetText(BANK_BAG_PURCHASE, 1, 1, 1)
	elseif self:IsBankBagSlot() then
		GameTooltip:SetText(BANK_BAG, 1, 1, 1)
	else
		GameTooltip:SetText(EQUIP_CONTAINER, 1, 1, 1)
	end
end

function Bag:UpdateBagTooltip()
	if not GameTooltip:SetInventoryItem('player', self:GetInventorySlot()) then
		if self:IsPurchasable() then
			GameTooltip:SetText(BANK_BAG_PURCHASE, 1, 1, 1)
			GameTooltip:AddLine(L.ClickToPurchase)
			SetTooltipMoney(GameTooltip, GetBankSlotCost(GetNumBankSlots()))
		else
			GameTooltip:SetText(EQUIP_CONTAINER, 1, 1, 1)
		end
	end
end


--[[ Accessor Functions ]]--

function Bag:GetPlayer()
	local p = self:GetParent()
	return p and p:GetPlayer() or UnitName('player')
end

--returns true if the bag is loaded from offline data, and false otehrwise
function Bag:IsCached()
	return Combuctor.BagSlotInfo:IsCached(self:GetPlayer(), self:GetID())
end

--returns true if the given bag represents the backpack container
function Bag:IsBackpack()
	return Combuctor.BagSlotInfo:IsBackpack(self:GetID())
end

--returns true if the given bag represetns the main bank container
function Bag:IsBank()
	return Combuctor.BagSlotInfo:IsBank(self:GetID())
end

function Bag:IsKeyRing()
	return Combuctor.BagSlotInfo:IsKeyRing(self:GetID())
end

--returns true if the given bag slot is an inventory bag slot
function Bag:IsInventoryBagSlot()
	return Combuctor.BagSlotInfo:IsBackpackBag(self:GetID())
end

--returns true if the given bag slot is a purchasable bank bag slot
function Bag:IsBankBagSlot()
	return Combuctor.BagSlotInfo:IsBankBag(self:GetID())
end

--returns true if the given bagSlot is one the player can place a bag in, and false otherwise
function Bag:IsBagSlot()
	return self:IsInventoryBagSlot() or self:IsBankBagSlot()
end

--returns true if the bag is a purchasable bank slot, and false otherwise
function Bag:IsPurchasable()
	return Combuctor.BagSlotInfo:IsPurchasable(self:GetPlayer(), self:GetID())
end

--returns the inventory slot id representation of the given bag
function Bag:GetInventorySlot()
	return Combuctor.BagSlotInfo:ToInventorySlot(self:GetID())
end

function Bag:GetItemInfo()
	local link, count, texture = Combuctor.BagSlotInfo:GetItemInfo(self:GetPlayer(), self:GetID())
	return link, count, texture
end

function Bag:IsLocked()
	return Combuctor.BagSlotInfo:IsLocked(self:GetPlayer(), self:GetID())
end