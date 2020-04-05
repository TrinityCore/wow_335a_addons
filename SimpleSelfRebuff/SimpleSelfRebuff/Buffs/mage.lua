if not SimpleSelfRebuff then return end
if select(2, UnitClass('player')) ~= 'MAGE' then return end

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)

	self:GetCategory(L['Armor']):addMulti(
		7302, -- Ice Armor
		6117, -- Mage Armor
		168, -- Frost Armor
		30482  -- Molten Armor
	)
	
	self:GetCategory(L['Intellect']):addMulti(
		1459, -- Arcane Intellect
		23028, -- Arcane Brilliance
		46302  -- K'iru's Song of Victory -- can not be cast by player but conflicts with AI/AB
	)
	
	self:AddStandaloneBuff( 11129 ) -- Combustion
	self:AddStandaloneBuff( 11426 ) -- Ice Barrier
	
	self:GetCategory(L['Magic Alteration']):addMulti(
		1008, -- Amplify Magic
		604  -- Dampen Magic
	)
	
	self:GetCategory(L['Ward']):addMulti(
    543, -- Fire Ward
    6143  -- Frost Ward
   )
   	
end)
