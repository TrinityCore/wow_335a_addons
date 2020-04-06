if not Skinner:isAddonEnabled("xMerchant") then return end

function Skinner:xMerchant()

	local frame = NuuhMerchantFrame
	self:skinEditBox{obj=frame.search, regs={9}}
	self:skinScrollBar{obj=frame.scrollframe}
	frame.top:Hide()
	frame.bottom:Hide()

end
