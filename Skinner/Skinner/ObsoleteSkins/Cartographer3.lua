
function Skinner:Cartographer3()

	local frame = Cartographer3.Data.mapFrame
	frame.bg:SetBackdrop(self.backdrop)
	local r, g, b, a = unpack(self.bColour)
	frame.bg:SetBackdropColor(r, g, b, a)
	local r, g, b, a = unpack(self.bbColour)
	frame.bg:SetBackdropBorderColor(r, g, b, a)
	self:applyGradient(frame.bg, 60)
	local sf = Cartographer3.Data.scrollFrame
	sf:ClearAllPoints()
	local mh = Cartographer3.Data.mapHolder
	sf:SetPoint("BOTTOMLEFT", mh, "BOTTOMLEFT", 4, 4)
	sf:SetPoint("TOPRIGHT", mh, "TOPRIGHT", -4, -25)
	self:moveObject(_G[frame:GetName() .. "_CloseButton"], "+", 4, "+", 5)
	self:moveObject(_G[frame:GetName() .. "_Button1"], "+", 4, "-", 5)
	self:moveObject(_G[frame:GetName() .. "_Button4"], "-", 4, "-", 5)
	
end
