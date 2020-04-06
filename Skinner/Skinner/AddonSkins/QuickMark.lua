if not Skinner:isAddonEnabled("QuickMark") then return end

function Skinner:QuickMark()

	self:skinAllButtons{obj=QuickMarkVerticalForm, sap=true}
	self:addSkinFrame{obj=QuickMarkVerticalForm, kfs=true, x1=6, y1=-8, x2=-3, y2=3, nb=true}
	self:skinAllButtons{obj=QuickMarkHorizontalForm, sap=true}
	self:addSkinFrame{obj=QuickMarkHorizontalForm, kfs=true, x1=10, y1=-6, x2=-6, y2=3, nb=true}

end
