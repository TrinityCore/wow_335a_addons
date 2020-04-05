if not SimpleSelfRebuff then return end
if select(2, UnitClass('player')) ~= 'HUNTER' then return end

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)

	self:GetCategory(L['Aspect']):addMulti( 
		34074, -- Aspect of the Viper
		13161, -- Aspect of the Beast
		5118,  -- Aspect of the Cheetah
		13165, -- Aspect of the Hawk
		13163, -- Aspect of the Monkey
		61846  -- Aspect of the Dragonhawk
	)
		:add(	13159, 'subcat', 'pack' ) -- Aspect of the Pack
		:add(	20043, 'subcat', 'wild' ) -- Aspect of the Wild

	self:AddStandaloneBuff( 19506 ) -- Trueshot Aura
	
end)
