if not SimpleSelfRebuff then return end
if select(2, UnitClass('player')) ~= 'PALADIN' then return end

SimpleSelfRebuff:RegisterBuffSetup(function(self, L)

	-- subcast is used to group blessings
	self:GetCategory(L['Blessing'])
		:add( 20217, 'subcat', 'kings'     ) -- Blessing of Kings
		:add( 19740, 'subcat', 'might'     ) -- Blessing of Might
		:add( 20911, 'subcat', 'sanctuary' ) -- Blessing of Sanctuary
		:add( 19742, 'subcat', 'wisdom'    ) -- Blessing of Wisdom
		:add( 25898, 'subcat', 'kings'     ) -- Greater Blessing of Kings
		:add( 25782, 'subcat', 'might'     ) -- Greater Blessing of Might
		:add( 25899, 'subcat', 'sanctuary' ) -- Greater Blessing of Sanctuary
		:add( 25894, 'subcat', 'wisdom'    ) -- Greater Blessing of Wisdom
	
	self:GetCategory(L['Aura'])
		:add( 465, 'subcat', 'devotion',      'mountFriendly', true ) -- Devotion Aura
		:add( 7294, 'subcat', 'retribution',   'mountFriendly', true ) -- Retribution Aura
		:add( 19891, 'subcat', 'fire_res',      'mountFriendly', true ) -- Fire Resistance Aura
		:add( 19876, 'subcat', 'shadow_res',    'mountFriendly', true ) -- Shadow Resistance Aura
		:add( 19888, 'subcat', 'frost_rest',    'mountFriendly', true ) -- Frost Resistance Aura
		:add( 19746, 'subcat', 'concentration', 'mountFriendly', true ) -- Concentration Aura
		:add( 32223, 'subcat', 'crusader',      'mountFriendly', true ) -- Crusader Aura

	self:GetCategory(L['Seal']):addMulti( 
		21084, -- Seal of Righteousness
		20164, -- Seal of Justice
		20165, -- Seal of Light
		20166, -- Seal of Wisdom
		20375, -- Seal of Command
		31892, -- Seal of Blood
		31801, -- Seal of Vengeance
		53736, -- Seal of Corruption
		53720  -- Seal of the Martyr
	)
		
	self:AddStandaloneBuff( 25780 ) -- Righteous Fury

end)
