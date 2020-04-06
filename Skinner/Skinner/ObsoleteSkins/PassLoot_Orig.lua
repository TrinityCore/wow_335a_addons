
function Skinner:PassLoot()

-->>-- Options Frame
	self:applySkin(PassLoot_MainFrame, true)
	-- Rules
	self:removeRegions(PassLoot_RuleList_Scroll)
	self:skinScrollBar(PassLoot_RuleList_Scroll)
	self:applySkin(PassLoot_RuleList)
	self:skinEditBox(PassLoot_Settings_Zone, {15})
	self:moveObject(PassLoot_Settings_Zone, "+", 4, nil, nil)
	self:skinEditBox(PassLoot_Settings_Desc, {15})
	self:skinDropDown(PassLoot_Settings_GroupRaid)
	self:skinDropDown(PassLoot_Settings_Bind)
	self:skinDropDown(PassLoot_Settings_Quality)
	self:skinDropDown(PassLoot_Settings_Unique)
	self:skinDropDown(PassLoot_Settings_EquipSlot)
	self:skinDropDown(PassLoot_Settings_Type)
	self:skinDropDown(PassLoot_Settings_LootWon)
	self:skinEditBox(PassLoot_Settings_LootWonCounter, {15})
	self:removeRegions(PassLoot_ItemList_Scroll)
	self:skinScrollBar(PassLoot_ItemList_Scroll)
	self:applySkin(PassLoot_ItemList)
	self:applySkin(PassLoot_Settings)
	-- Profiles
	self:skinDropDown(PassLoot_Profiles_CurrentProfile)
	self:skinDropDown(PassLoot_Profiles_CopyProfile)
	self:skinDropDown(PassLoot_Profiles_DeleteProfile)
	self:skinEditBox(PassLoot_Profiles_NewProfileName, {15})
	self:applySkin(PassLoot_Profiles)
	-- Tabs
	self:skinFFToggleTabs("PassLoot_TabbedMenuContainerTab", 2)

end
