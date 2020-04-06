if not Skinner:isAddonEnabled("HitsMode") then return end

function Skinner:HitsMode()

	self:keepFontStrings(HMOptions)
	self:moveObject(self:getRegion(HMOptions, 2), nil, nil, "-", 7) -- title text
	self:applySkin(HMOptionsPaneBgFrame)
	self:removeRegions(HMOptionsScrollBarBg)
	self:skinScrollBar(HMOptionsPane)
	self:applySkin(HMOptions)

end
