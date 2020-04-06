if not Skinner:isAddonEnabled("RecipeRadar") then return end

function Skinner:RecipeRadar()

	self:keepFontStrings(RecipeRadarFrame)
	RecipeRadarFrame:SetWidth(RecipeRadarFrame:GetWidth() - 50)
	RecipeRadarFrame:SetHeight(RecipeRadarFrame:GetHeight() - 70)
	self:moveObject(RecipeRadarExitButton, "+", 28, "+", 8)
	self:removeRegions(RecipeRadarRadarTabFrame, {1, 2, 3})
	self:removeRegions(RecipeRadarRecipesTabFrame, {1, 2, 3})
	self:keepFontStrings(RecipeRadar_PersonAvailDropDown)
	self:keepFontStrings(RecipeRadar_Prof1DropDown)
	self:keepFontStrings(RecipeRadar_TeamDropDown)
	self:keepFontStrings(RecipeRadar_RealmAvailDropDown)
	self:keepFontStrings(RecipeRadar_Prof2DropDown)
	self:keepFontStrings(RecipeRadarListScrollFrame)
	self:skinScrollBar(RecipeRadarListScrollFrame)
	self:moveObject(RecipeRadarListScrollFrame, "+", 30, nil, nil)
	self:keepFontStrings(RadarTabDropDown)
	self:keepFontStrings(RecipesTabDropDown)
	self:moveObject(RecipeRadarDetailFrame, "+", 60, nil, nil)
	self:removeRegions(RecipeRadarMapFrame, {2, 3})
	self:moveObject(RecipeRadarRegionMap, "-", 12, "-", 70)
	self:moveObject(RecipeRadarMoneyFrame, nil, nil, "-", 70)
	self:moveObject(RecipeRadarOptionsButton, "+", 30, "-", 70)
	self:applySkin(RecipeRadarFrame, true)
-->>-- RecipeRadarAvailability Tooltip
	self:applySkin(RecipeRadarAvailabilityTooltip)
	RecipeRadarAvailabilityTooltip.SetBackdropColor = function() end
-->>-- RecipeRadarOptions Frame
	self:keepFontStrings(RecipeRadarOptionsFrame)
	self:keepFontStrings(RecipeRadar_ContinentDropDown)
	self:keepFontStrings(RecipeRadar_RegionDropDown)
	self:applySkin(RecipeRadarOptionsFrame, true)

end
