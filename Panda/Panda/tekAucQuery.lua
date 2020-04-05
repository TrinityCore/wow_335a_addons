
local lib = LibStub:NewLibrary("tekAucQuery", 2)
if not lib then return end

setmetatable(lib, {
	__index = function(t,i)
		if not i then return end
		if GetAuctionBuyout then return GetAuctionBuyout(i) end
		if AucAdvanced and AucAdvanced.Modules and AucAdvanced.Modules.Util.Appraiser and AucAdvanced.Modules.Util.Appraiser.GetPrice then
			local p = AucAdvanced.Modules.Util.Appraiser.GetPrice(i, nil, true)
			t[i] = p
			return p
		end
	end,
})

