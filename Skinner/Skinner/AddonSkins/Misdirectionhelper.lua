if not Skinner:isAddonEnabled("Misdirectionhelper") then return end

function Skinner:Misdirectionhelper()

-->>-- Main frame
	Misdirectionhelper_EditBox:SetTextColor(self.BTr, self.BTg, self.BTb)
	Misdirectionhelper_EditBox:SetHeight(18)
	Misdirectionhelper_EditBox:SetWidth(104)
	self:skinEditBox{obj=Misdirectionhelper_EditBox, regs={9}, noHeight=true, noWidth=true}
	self:skinButton{obj=Misdirectionhelper_Small, mp2=true}
	self:skinButton{obj=Misdirectionhelper_Close, cb2=true, x1=2, x2=-2, y2=4}
	self:moveObject{obj=Misdirectionhelper_Close, y=-2}
	self:addSkinFrame{obj=Misdirectionhelper_Mainframe, kfs=true, nb=true, x1=4, y1=2, x2=-4}
-->>-- Small frame
	self:skinButton{obj=Misdirectionhelper_SmallSmall, mp2=true}
	self:addSkinFrame{obj=Misdirectionhelper_SmallMainframe, kfs=true, x1=4, y1=2, x2=-5, y2=29}
-->>-- Options frame
	self:skinDropDown{obj=Misdirectionhelper_optDropdownmenu1}
	self:skinDropDown{obj=Misdirectionhelper_optDropdownmenu2}
	self:addSkinFrame{obj=Misdirectionhelper_opt, kfs=true}

end
