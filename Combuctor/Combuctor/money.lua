--[[
	moneyFrame.lua
		A money frame object
--]]

local MoneyFrame = Combuctor:NewClass('Frame')
Combuctor.MoneyFrame = MoneyFrame

local L = LibStub('AceLocale-3.0'):GetLocale('Combuctor')

function MoneyFrame:New(parent)
	local f = self:Bind(CreateFrame('Frame', parent:GetName() .. 'MoneyFrame', parent, 'SmallMoneyFrameTemplate'))
	f:SetScript('OnShow', self.Update)
	f:Update()

	local click = CreateFrame('Button', f:GetName() .. 'Click', f)
	click:SetFrameLevel(f:GetFrameLevel() + 3)
	click:SetAllPoints(f)

	click:SetScript('OnClick', self.OnClick)
	click:SetScript('OnEnter', self.OnEnter)
	click:SetScript('OnLeave', self.OnLeave)

	return f
end

function MoneyFrame:Update()
	local player = self:GetParent():GetPlayer()
	if player == UnitName('player') or not BagnonDB then
		MoneyFrame_Update(self:GetName(), GetMoney())
	else
		MoneyFrame_Update(self:GetName(), BagnonDB:GetMoney(player))
	end
end

--frame events
function MoneyFrame:OnClick()
	local parent = self:GetParent()
	local name = parent:GetName()

	if MouseIsOver(getglobal(name .. 'GoldButton')) then
		OpenCoinPickupFrame(COPPER_PER_GOLD, MoneyTypeInfo[parent.moneyType].UpdateFunc(), parent)
		parent.hasPickup = 1
	elseif MouseIsOver(getglobal(name .. 'SilverButton')) then
		OpenCoinPickupFrame(COPPER_PER_SILVER, MoneyTypeInfo[parent.moneyType].UpdateFunc(), parent)
		parent.hasPickup = 1
	elseif MouseIsOver(getglobal(name .. 'CopperButton')) then
		OpenCoinPickupFrame(1, MoneyTypeInfo[parent.moneyType].UpdateFunc(), parent)
		parent.hasPickup = 1
	end
end

-- ChangeLog
-- 07/03/2009 Serenity(SACW) modified this frame to show earmarked currencies in the money window when hovered over, probably should get it's own small square in the inventory frame
--     but this works for now.
function MoneyFrame:OnEnter()
	if BagnonDB then
		
		GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT')

	-- Section added by Serenity of Silver Aerie Codeworks.
		if ( GetNumWatchedTokens() > 0 ) then
			local Num_Currs = GetNumWatchedTokens()

			if ( Num_Currs > 3 ) then
				Num_Currs = 3
			end
			
			GameTooltip:AddLine(format("%s's Currencies", UnitName('player') ) )
			
			for CountVar = 1, Num_Currs, 1 do
				local Curr_Name, Curr_Amt = GetBackpackCurrencyInfo(CountVar)
				if ( Curr_Name == nil ) then
				else
					GameTooltip:AddDoubleLine(Curr_Name, Curr_Amt, 0, 170, 255, 255, 255, 255)
				end
			end			

			GameTooltip:AddLine('\r')
		end

		local money = 0
		for player in BagnonDB:GetPlayers() do
			money = money + BagnonDB:GetMoney(player)
		end
	-- End Section
	
--		GameTooltip:SetText(format(L.TotalOnRealm, GetRealmName()))
		GameTooltip:AddLine(format(L.TotalOnRealm, GetRealmName()))
		SetTooltipMoney(GameTooltip, money)
		GameTooltip:Show()
	end
end

function MoneyFrame:OnLeave()
	GameTooltip:Hide()
end