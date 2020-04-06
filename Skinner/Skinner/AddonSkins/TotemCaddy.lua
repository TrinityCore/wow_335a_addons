if not Skinner:isAddonEnabled("TotemCaddy") then return end

function Skinner:TotemCaddy()

	self:applySkin(TCOptionsFrame)
	self:applySkin(DummySmallTotemFrame)
	local r, g, b, a = unpack(self.bbColour)
	TCReincarnationFrame:SetBackdropBorderColor(r, g, b, a)
	TCWindfuryFrame:SetBackdropBorderColor(r, g, b, a)
	self:skinDropDown(TCMainFrameDropDown)
	self:applySkin(TCRecordsFrame)

end
