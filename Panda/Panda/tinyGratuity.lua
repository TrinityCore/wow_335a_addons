
local _G = getfenv(0)
local tip = CreateFrame("GameTooltip")
tip:SetOwner(WorldFrame, "ANCHOR_NONE")

-- Our global, change as needed
DEATinyGratuity = tip


local lcache, rcache = {}, {}
for i=1,30 do
	lcache[i], rcache[i] = tip:CreateFontString(), tip:CreateFontString()
	lcache[i]:SetFontObject(GameFontNormal); rcache[i]:SetFontObject(GameFontNormal)
	tip:AddFontStrings(lcache[i], rcache[i])
end


-- GetText cache tables, provide fast access to the tooltip's text
tip.L = setmetatable({}, {
	__index = function(t, key)
		if tip:NumLines() >= key and lcache[key] then
			local v = lcache[key]:GetText()
			t[key] = v
			return v
		end
		return nil
	end,
})


tip.R = setmetatable({}, {
	__index = function(t, key)
		if tip:NumLines() >= key and rcache[key] then
			local v = rcache[key]:GetText()
			t[key] = v
			return v
		end
		return nil
	end,
})


-- Performes a "full" erase of the tooltip
tip.Erase = function(self)
	self:ClearLines() -- Ensures tooltip's NumLines is reset
	for i in pairs(self.L) do self.L[i] = nil end -- Flush the metatable cache
	for i in pairs(self.R) do
		self.rcache[i]:SetText() -- Clear text from right side (ClearLines only hides them)
		self.R[i] = nil -- Flush the metatable cache
	end
	if not self:IsOwned(WorldFrame) then self:SetOwner(WorldFrame, "ANCHOR_NONE") end
end


-- Hooks the Set* methods to force a full erase beforehand
local methods = {"SetMerchantCostItem", "SetBagItem", "SetAction", "SetAuctionItem", "SetAuctionSellItem", "SetBuybackItem",
	"SetCraftItem", "SetCraftSpell", "SetHyperlink", "SetInboxItem", "SetInventoryItem", "SetLootItem", "SetLootRollItem",
	"SetMerchantItem", "SetPetAction", "SetPlayerBuff", "SetQuestItem", "SetQuestLogItem", "SetQuestRewardSpell",
	"SetSendMailItem", "SetShapeshift", "SetSpell", "SetTalent", "SetTrackingSpell", "SetTradePlayerItem", "SetTradeSkillItem",
	"SetTradeTargetItem", "SetTrainerService", "SetUnit", "SetUnitBuff", "SetUnitDebuff"}
for _,m in pairs(methods) do
	local orig = tip[m]
	tip[m] = function(self, ...)
		self:Erase()
		return orig(self, ...)
	end
end

