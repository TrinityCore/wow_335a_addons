if not Skinner:isAddonEnabled("Spew") then return end

function Skinner:Spew()

	self:addSkinFrame{obj=SpewPanel, kfs=true, x1=10, y1=-11, y2=8}
	
end
