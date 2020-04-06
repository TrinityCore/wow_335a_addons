if not Skinner:isAddonEnabled("FlightMap") then return end

function Skinner:FlightMap()

	self:keepFontStrings(FlightMapTaxiContinents)
	self:keepFontStrings(FlightMapTimesFrame)
	self:moveObject(FlightMapTimesText, nil, nil, "-", 2)
	self:glazeStatusBar(FlightMapTimesFrame, 0)
-->>--	Options Frame
	self:keepFontStrings(FlightMapOptionsFrame)
	self:applySkin(FlightMapOptionsFrame, true)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then FlightMapTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(FlightMapTooltip)
	end

end
