
function Skinner:MetaMap()
	if not self.db.profile.WorldMap then return end

	self:keepRegions(MetaMap_InstanceMenu, {4,5}) -- N.B. regions 4 & 5 are text
	self:moveObject(WorldMapFrameCloseButton, "-", 10, "-", 5)
	self:applySkin(MetaMapTopFrame)

	for i = 1, 6 do
		local tabName = _G["MetaMap_DialogFrameTab"..i]
		-- hook the OnShow script to allow tab widths to be changed
		self:RawHookScript(tabName, "OnShow", function()
--			self:Debug(tabName:GetName().."OnShow")
			self.hooks[tabName].OnShow()
			tabName:SetWidth(tabName:GetWidth() * 0.85)
			end)
		self:keepRegions(tabName, {7}) -- N.B. region 7 is text
		tabName:SetHeight(tabName:GetHeight() * (self.FTyMult + self.FTyMult))
		if i == 1 then
			self:moveObject(tabName, nil, nil, "_", 8)
		else
			self:moveObject(tabName, "+", 15, nil, nil)
		end
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
	end

	self:moveObject(MetaMap_CloseButton, nil, nil, "_", 2)

	self:applySkin(MetaMap_DialogFrame)

end
