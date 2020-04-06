
function Skinner:LootLink()

-->>--	LootLink Frame
	LootLinkFrame:SetWidth(LootLinkFrame:GetWidth() * self.FxMult)
	LootLinkFrame:SetHeight(LootLinkFrame:GetHeight() * self.FyMult)
	self:removeRegions(LootLinkFrame, {1,2,3,4,5})
	self:keepRegions(LootLinkFrameDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:removeRegions(LootLinkListScrollFrame)
	self:skinScrollBar(LootLinkListScrollFrame)
	self:moveObject(LootLinkFrameCloseButton, "+", 28, "+", 8)
	self:applySkin(LootLinkFrame)

-->>--	Search Frame
	self:moveObject(LLS_TextEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_TextEditBox, {})
	self:moveObject(LLS_NameEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_NameEditBox, {})
	self:moveObject(LLS_MinimumLevelEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MinimumLevelEditBox, {})
	self:moveObject(LLS_MaximumLevelEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MaximumLevelEditBox, {})
	self:moveObject(LLS_MinimumSlotsEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MinimumSlotsEditBox, {})
	self:moveObject(LLS_MinimumDamageEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MinimumDamageEditBox, {})
	self:moveObject(LLS_MaximumDamageEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MaximumDamageEditBox, {})
	self:moveObject(LLS_MaximumSpeedEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MaximumSpeedEditBox, {})
	self:moveObject(LLS_MinimumDPSEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MinimumDPSEditBox, {})
	self:moveObject(LLS_MinimumArmorEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MinimumArmorEditBox, {})
	self:moveObject(LLS_MinimumBlockEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MinimumBlockEditBox, {})
	self:moveObject(LLS_MinimumSkillEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MinimumSkillEditBox, {})
	self:moveObject(LLS_MaximumSkillEditBox, nil, nil, "+", 5)
	self:skinEditBox(LLS_MaximumSkillEditBox, {})
	self:keepRegions(LLS_RarityDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(LLS_BindsDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(LLS_LocationDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(LLS_TypeDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(LLS_SubtypeDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:applySkin(LootLinkSearchFrame, true)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then LootLinkTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(LootLinkTooltip)
	end

end
