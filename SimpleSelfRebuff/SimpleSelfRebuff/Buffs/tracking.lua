if not SimpleSelfRebuff then return end

SimpleSelfRebuff:RegisterBuffSetup(function(self)	

	-- Use 2.3 built-in functions
	local cat = self:GetCategory(self.CATEGORY_TRACKING)
	for i = 1, GetNumTrackingTypes() do
		local name, texture, _, type = GetTrackingInfo(i)
		cat:add(name, 'mountFriendly', true, 'texture', texture, 'trackingType', type, 'trackingId', i)
	end
		
end)
