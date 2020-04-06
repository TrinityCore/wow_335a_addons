if not Skinner:isAddonEnabled("Atlas") then return end

function Skinner:Atlas()

	-- this is used to add a texture to the dropdown
	local function textureDD(dd, opt)

		self:keepFontStrings(dd)
		if self.db.profile.TexturedDD then
			dd.ddTex = dd:CreateTexture(nil, "BORDER")
			dd.ddTex:SetTexture(Skinner.itTex)
			dd.ddTex:ClearAllPoints()
			dd.ddTex:SetPoint("TOPLEFT", dd, "TOPLEFT", 20, opt and -5 or -4)
			dd.ddTex:SetPoint("BOTTOMRIGHT", dd, "BOTTOMRIGHT", opt and -24 or -18, opt and 8 or 10)
		end

	end

-->>--	AtlasFrame
	self:moveObject(self:getRegion(AtlasFrame, 6), nil, nil, "+", 8)
	self:moveObject(self:getRegion(AtlasFrame, 7), nil, nil, "+", 8)
	self:moveObject(AtlasFrameCloseButton, "-", 4, "+", 8)
	textureDD(AtlasFrameDropDownType)
	textureDD(AtlasFrameDropDown)
	self:removeRegions(AtlasFrame, {1,2,3,4,5}) -- N.B. other regions are text or Map Textures
	self:skinEditBox(AtlasSearchEditBox, {9})
	self:keepFontStrings(AtlasScrollBar)
	self:skinScrollBar(AtlasScrollBar)
	self:applySkin(AtlasFrame, nil)
	-- change the draw layer so the map is visible
	AtlasMap:SetDrawLayer("OVERLAY")

-->>--	AtlasOptionsFrame
	self:keepRegions(AtlasOptionsFrame, {11})
	textureDD(AtlasOptionsFrameDropDownCats, true)
	self:applySkin(AtlasOptionsFrame, true)

end
