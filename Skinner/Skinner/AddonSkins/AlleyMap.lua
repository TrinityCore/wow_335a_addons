if not Skinner:isAddonEnabled("AlleyMap") then return end

function Skinner:AlleyMap()

	local function sizeUp()
	
		self.skinFrame[WorldMapFrame]:SetParent(WorldMapFrame)
		self.skinFrame[WorldMapFrame]:SetFrameStrata("LOW")
		self.skinFrame[WorldMapFrame]:ClearAllPoints()
		self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 255, -95)
		self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", -255, 95)
		
	end
	local function sizeDown()

		for _, child in pairs{WorldMapDetailFrame:GetChildren()} do
			child:SetAlpha(0)
		end
	
		self.skinFrame[WorldMapFrame]:SetParent(WorldMapDetailFrame) -- handle frame movement
		self.skinFrame[WorldMapFrame]:SetFrameStrata("LOW")
		self.skinFrame[WorldMapFrame]:ClearAllPoints()
		self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -5, 4)
		self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 4, -4)
		
	end
	self:SecureHook("WorldMap_ToggleSizeUp", function()
		sizeUp()
	end)
	self:SecureHook("WorldMap_ToggleSizeDown", function()
		sizeDown()
	end)
	
	self:addSkinFrame{obj=WorldMapFrame, ft="u", kfs=true}
	-- handle big/small map sizes
	if WorldMapFrame.sizedDown
	or WORLDMAP_SETTINGS and WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE -- Patch
	then
		sizeDown()
	else
		sizeUp()
	end

end
