if not Skinner:isAddonEnabled("ExtendedRaidInfo") then return end

function Skinner:ExtendedRaidInfo()

	self:skinDropDown{obj=ExtendedRaidInfoAltList}
	self:skinDropDown{obj=ExtendedRaidInfoFilter}
	for _,v in pairs{"Name", "Difficulty", "Expires"} do
		local hdr = _G["ExtendedRaidInfoHeader"..v]
		self:removeRegions(hdr, {1, 2, 3})
		self:addSkinFrame{obj=hdr}
	end	
	self:skinScrollBar{obj=ExtendedRaidInfoScroll}
	self:addSkinFrame{obj=ExtendedRaidInfo.window, kfs=true, x1=3, y1=-2, x2=-2}
	self:moveObject{obj=ExtendedRaidInfo.window, y=1}

end
