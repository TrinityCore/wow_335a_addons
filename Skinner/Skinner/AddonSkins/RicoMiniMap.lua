if not Skinner:isAddonEnabled("RicoMiniMap") then return end

function Skinner:RicoMiniMap()

	local function skinSquare()
	
		MinimapBorder:Hide()

		if not Skinner.sBut[Minimap] then
			Skinner.minimapskin = Skinner:addSkinButton(Minimap, Minimap)
			if not Skinner.db.profile.MinimapGloss then LowerFrameLevel(Skinner.minimapskin) end
		else
			Skinner.sBut[Minimap]:Show()
		end
		
	end
	
	self:SecureHook(RicoMiniMap, "UpdateShape", function()
		if RicoMiniMap.db.profile.Shape == 2 then skinSquare() 
		elseif self.sBut[Minimap] then
			self.sBut[Minimap]:Hide()
		end
	end)
	
	if RicoMiniMap.db.profile.Shape == 2 then skinSquare() end
	
end
