if not Skinner:isAddonEnabled("Mapster") then return end

function Skinner:Mapster()

	local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster", true)
	if not Mapster then return end

	local function sizeDown()

		self.skinFrame[WorldMapFrame]:ClearAllPoints()
		self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 12, -12)
		self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", -20, -15)

	end
	local function sizeUp()

		self.skinFrame[WorldMapFrame]:ClearAllPoints()
		self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 0, 1)
		self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", 1, 0)

	end
	-- hook these to handle map size changes
	self:SecureHook(Mapster, "SizeDown", function()
		sizeDown()
	end)
	self:SecureHook(Mapster, "SizeUp", function()
		sizeUp()
	end)
	self:SecureHook(Mapster, "UpdateBorderVisibility", function()
		if Mapster.bordersVisible then self.skinFrame[WorldMapFrame]:Show()
		else self.skinFrame[WorldMapFrame]:Hide() end
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
	-- on WorldMap frame
	self:skinButton{obj=MapsterOptionsButton}
	self:skinDropDown{obj=MapsterQuestObjectivesDropDown}

end
