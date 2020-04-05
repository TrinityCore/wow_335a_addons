--[[
	itemFrameEvents.lua
		A single event handler for the itemFrame object
--]]

local FrameEvents = Combuctor:NewModule('ItemFrameEvents', 'AceEvent-3.0')
local currentPlayer = UnitName('player')
local frames = {}


--a widget for performing delayed updates
--if you ever see how many times the combuctor slot add/remove/update events are called, you'll know why this exists
local Updater = CreateFrame('Frame')
Updater:SetScript('OnUpdate', function(self)
	FrameEvents:LayoutFrames()
	self:Hide()
end)
Updater:Hide()

function FrameEvents:OnEnable()
	self:RegisterEvent('BAG_UPDATE_COOLDOWN', 'UpdateSlotCooldowns')

	self:RegisterMessage('COMBUCTOR_SLOT_ADD', 'UpdateSlot')
	self:RegisterMessage('COMBUCTOR_SLOT_REMOVE', 'RemoveItem')
	self:RegisterMessage('COMBUCTOR_SLOT_UPDATE', 'UpdateSlot')
	self:RegisterEvent('ITEM_LOCK_CHANGED', 'UpdateSlotLock')

	self:RegisterMessage('COMBUCTOR_BANK_OPENED', 'UpdateBankFrames')
	self:RegisterMessage('COMBUCTOR_BANK_CLOSED', 'UpdateBankFrames')
end

function FrameEvents:UpdateSlot(msg, ...)
	for f in self:GetFrames() do
		if f:GetPlayer() == currentPlayer then
			if f:UpdateSlot(...) then
				f:RequestLayout()
			end
		end
	end
end

function FrameEvents:RemoveItem(msg, ...)
	for f in self:GetFrames() do
		if f:GetPlayer() == currentPlayer then
			if f:RemoveItem(...) then
				f:RequestLayout()
			end
		end
	end
end

function FrameEvents:UpdateSlotLock(msg, ...)
	for f in self:GetFrames() do
		if f:GetPlayer() == currentPlayer then
			f:UpdateSlotLock(...)
		end
	end
end

function FrameEvents:UpdateSlotCooldowns(msg, ...)
	for f in self:GetFrames() do
		if f:GetPlayer() == currentPlayer then
			f:UpdateSlotCooldowns()
		end
	end
end

function FrameEvents:UpdateBankFrames()
	for f in self:GetFrames() do
		f:Regenerate()
	end
end

function FrameEvents:LayoutFrames()
	for f in self:GetFrames() do
		if f.needsLayout then
			f.needsLayout = nil
			f:Layout()
		end
	end
end

function FrameEvents:RequestLayout()
	Updater:Show()
end

function FrameEvents:GetFrames()
	return pairs(frames)
end

function FrameEvents:Register(f)
	frames[f] = true
end

function FrameEvents:Unregister(f)
	frames[f] = nil
end