if not Skinner:isAddonEnabled("Squeenix") then return end

function Skinner:Squeenix()

	-- Find & Skin the Squeenix border & direction indicators
	for _, child in pairs{Minimap:GetChildren()} do
		if child:IsObjectType("Button")
		and child:GetName() == nil
		then
			child:Hide()
			self.minimapskin = self:addSkinButton{obj=Minimap, parent=Minimap}
			if not self.db.profile.MinimapGloss then LowerFrameLevel(self.minimapskin) end
		end
		-- Move the compass points text
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and child:GetFrameStrata() == "BACKGROUND"
		and ceil(child:GetWidth()) == 140
		and ceil(child:GetHeight()) == 140
		then
--			self:Debug("Squeenix, found Compass Frame")
			for _, reg in ipairs{child:GetRegions()} do
				if reg:IsObjectType("FontString") then
--					self:Debug("Squeenix found direction text")
					if reg:GetText() == "E" then self:moveObject{obj=reg, x=1}
					elseif reg:GetText() == "W" then self:moveObject{obj=reg, x=-1}
					end
				end
			end
		end
	end
	self:moveObject{obj=MinimapNorthTag, y=4}

end
