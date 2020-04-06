if not Skinner:isAddonEnabled("DockingStation") then return end

function Skinner:DockingStation_Config()

	--	look through all InterfaceOptionsFrame children backwards
	for i = InterfaceOptionsFrame:GetNumChildren(), 1, -1  do
		local child = select(i, InterfaceOptionsFrame:GetChildren())
		local point, relTo, relPoint, xOfs, yOfs = child:GetPoint()
		if point == "LEFT"
		and relTo == InterfaceOptionsFrame
		and relPoint == "RIGHT"
		and xOfs == -13
		and yOfs == 0 then
			self:addSkinFrame{obj=child, x1=4, y1=-4, x2=-4, y2=4}
			self:skinSlider(self:getChild(child, 1)) -- skin the slider
			break
		end
	end
	
end
