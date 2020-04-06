if not Skinner:isAddonEnabled("ACP") then return end

function Skinner:ACP()

	ACP_AddonList:SetScale(0.75) -- shrink frame

	self:skinDropDown{obj=ACP_AddonListSortDropDown}
	self:skinScrollBar{obj=ACP_AddonList_ScrollFrame}
	self:addSkinFrame{obj=ACP_AddonList, kfs=true, hdr=true, x1=12, x2=-40, y2=12}
	-- skin the buttons
	self:skinButton{obj=GameMenuButtonAddOns}
	self:skinButton{obj=ACP_AddonListCloseButton, cb=true}
	self:skinButton{obj=ACP_AddonListDisableAll}
	self:skinButton{obj=ACP_AddonListEnableAll}
	self:skinButton{obj=ACP_AddonListSetButton}
	self:skinButton{obj=ACP_AddonList_ReloadUI}
	self:skinButton{obj=ACP_AddonListBottomClose}
	for i = 1, 20 do
		self:skinButton{obj=_G["ACP_AddonListEntry"..i.."LoadNow"]}
	end

end
