if not Skinner:isAddonEnabled("PassLoot") then return end

function Skinner:PassLoot()

	local plmf = PassLoot.RulesFrame
	-- Rules subpanel
	self:skinScrollBar{obj=plmf.List.ScrollFrame}
	self:addSkinFrame{obj=plmf.List, kfs=true}
	-- Rules Settings subpanel
	self:skinEditBox{obj=plmf.Settings.Desc, regs={15}}
	self:skinScrollBar{obj=plmf.Settings.AvailableFilters.ScrollFrame}
	self:addSkinFrame{obj=plmf.Settings.AvailableFilters, kfs=true}
	self:skinScrollBar{obj=plmf.Settings.ActiveFilters.ScrollFrame}
	self:addSkinFrame{obj=plmf.Settings.ActiveFilters, kfs=true}
	self:addSkinFrame{obj=plmf.Settings, kfs=true}
	-- Widgets
	self:skinEditBox(PassLoot_Frames_Widgets_Zone, {15})
	self:skinDropDown(PassLoot_Frames_Widgets_ZoneType)
	self:skinDropDown(PassLoot_Frames_Widgets_Quality)
	self:skinDropDown(PassLoot_Frames_Widgets_Bind)
	self:skinDropDown(PassLoot_Frames_Widgets_Unique)
	self:skinDropDown(PassLoot_Frames_Widgets_EquipSlot)
	self:skinDropDown(PassLoot_Frames_Widgets_TypeSubType)
	self:skinDropDown(PassLoot_Frames_Widgets_ItemLevelComparison)
	self:skinDropDown(PassLoot_Frames_Widgets_RequiredLevelComparison)
	self:skinDropDown(PassLoot_Frames_Widgets_GroupRaid)
	self:skinDropDown(PassLoot_Frames_Widgets_LootWonComparison)
	self:skinEditBox(PassLoot_Frames_Widgets_LootWonCounter, {15})
	self:skinEditBox(PassLoot_Frames_Widgets_ItemNameTextBox, {15})
	self:skinDropDown(PassLoot_Frames_Widgets_ItemPriceComparison)
	-- ItemPrice comparison widget money frame
	local mf = (PassLoot_Frames_Widgets_ItemPriceComparison:GetParent()).MoneyInputFrame
	self:skinEditBox{obj=mf.Gold, regs={9, 10}, noHeight=true, noWidth=true} 
	self:skinEditBox{obj=mf.Silver, regs={9, 10}, noHeight=true, noWidth=true} 
	self:moveObject{obj=mf.Silver, x=-10}
	self:moveObject{obj=mf.Silver.IconTexture, x=10}
	self:skinEditBox{obj=mf.Copper, regs={9, 10}, noHeight=true, noWidth=true} 
	self:moveObject{obj=mf.Copper.IconTexture, x=10}

end
