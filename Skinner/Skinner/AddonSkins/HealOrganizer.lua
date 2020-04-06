if not Skinner:isAddonEnabled("HealOrganizer") then return end

function Skinner:HealOrganizer()

	self:addSkinFrame{obj=HealOrganizerDialog, kfs=true, hdr=true}
	self:applySkin(HealOrganizerDialogEinteilung)
	self:applySkin(HealOrganizerDialogEinteilungOptionen)
	self:applySkin(HealOrganizerDialogEinteilungStats)
	self:skinEditBox(HealOrganizerDialogEinteilungRestAction, {9})
	self:applySkin(HealOrganizerDialogEinteilungSets)
	self:skinDropDown{obj=HealOrganizerDialogEinteilungSetsDropDown}
	self:applySkin(HealOrganizerDialogBroadcast)
	self:skinEditBox(HealOrganizerDialogBroadcastChannelEditbox, {9})
	self:moveObject(HealOrganizerDialogClose, nil, nil, "-", 5)

end
