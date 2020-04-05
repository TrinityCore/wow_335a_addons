
local Panda = Panda
local GS = Panda.GS
local BC_GREEN_GEMS, BC_BLUE_GEMS, CUTS = Panda.BC_GREEN_GEMS, Panda.BC_BLUE_GEMS, Panda.CUTS


local values = setmetatable({}, {
	__index = function(t, link)
		if not link then return end
		local id = tonumber((link:match("item:(%d+):")))
		if not id or not CUTS[id] or not Panda:GetAHBuyout(id) then return end

		local val = 0
		for _,cutid in pairs(CUTS[id]) do val = val + (Panda:GetAHBuyout(cutid) or 0) end
		val = string.format("%s (%.2f%% profit)", GS(val/#CUTS[id]), ((val/#CUTS[id])/Panda:GetAHBuyout(id) - 1) * 100)
		t[link] = val
		return val
	end,
})


local origs = {}
local OnTooltipSetItem = function(frame, ...)
	assert(frame, "arg 1 is nil, someone isn't hooking correctly")

	local _, link = frame:GetItem()
	local val = values[link]
	if val and val ~= 0 then frame:AddDoubleLine("Average cut value:", val) end
	if origs[frame] then return origs[frame](frame, ...) end
end

for i,frame in pairs{GameTooltip, ItemRefTooltip} do
	origs[frame] = frame:GetScript("OnTooltipSetItem")
	frame:SetScript("OnTooltipSetItem", OnTooltipSetItem)
end


local f = CreateFrame("Frame")
f:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
f:SetScript("OnEvent", function() for i in pairs(values) do values[i] = nil end end)


