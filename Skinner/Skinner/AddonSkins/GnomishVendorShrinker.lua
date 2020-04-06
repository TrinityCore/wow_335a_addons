if not Skinner:isAddonEnabled("GnomishVendorShrinker") then return end

function Skinner:GnomishVendorShrinker()

	local frame = self:findFrame2(MerchantFrame, "Frame", 294, 315)
	if frame then
		self:skinEditBox{obj=self:getChild(frame, 15), regs={9}}
		local slider = self:getChild(frame, 16)
		self:skinSlider{obj=slider}
		self:getChild(slider, 3):SetBackdrop(nil) -- slider border
	end

end
