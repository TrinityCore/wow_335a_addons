if not Skinner:isAddonEnabled("Possessions") then return end

function Skinner:Possessions()

	self:moveObject{obj=Possessions_FrameTitle, y=-6}
	self:moveObject{obj=Possessions_FrameCloseButton, x=8, y=9}
	self:skinDropDown{obj=Possessions_CharDropDown}
	self:skinDropDown{obj=Possessions_LocDropDown}
	self:skinDropDown{obj=Possessions_SlotDropDown}
	self:skinDropDown{obj=Possessions_TypeDropDown}
	self:skinDropDown{obj=Possessions_SubTypeDropDown}
	self:skinEditBox{obj=Possessions_SearchBox, regs={9}}
	self:skinScrollBar{obj=Possessions_IC_ScrollFrame}
	for i = 1, 15 do
		self:keepFontStrings(_G["POSSESSIONS_BrowseButton"..i])
	end
	self:addSkinFrame{obj=Possessions_Frame, kfs=true}

end
