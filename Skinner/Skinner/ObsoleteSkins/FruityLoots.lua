
function Skinner:FruityLoots()
	if not self.db.profile.LootFrame then return end

	self:RawHook(FruityLoots ,"LootFrame_SetPoint", function(obj, flx, fly)
		local screenWidth = GetScreenWidth()
		if (UIParent:GetWidth() > screenWidth) then screenWidth = UIParent:GetWidth() end
		local screenHeight = GetScreenHeight()
	-- LootFrame is set to 256 wide in the xml file, but is actually only 191 wide
	-- This is based on calculation involving the offset on the close button:
	-- The height is always 256, which is the correct number.
		local windowWidth = 191
		local windowHeight = 256
		if (flx + windowWidth) > screenWidth then flx = screenWidth - windowWidth end
		if fly > screenHeight then fly = screenHeight end
		if flx < 0 then flx = 0 end
		if (fly - windowHeight) < 0 then fly = windowHeight end
		LootFrame:ClearAllPoints()
		LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", flx + 10, fly - 44)
	end)

end
