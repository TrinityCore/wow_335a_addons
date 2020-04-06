if not Skinner:isAddonEnabled("AutoDecline") then return end

function Skinner:AutoDecline()

	self:addSkinFrame{obj=AD_TogglesBorder, kfs=true, hdr=true, y2=6}
	self:addSkinFrame{obj=ADOptionsFrame, kfs=true, hdr=true, y2=4}

end
