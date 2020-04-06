if not Skinner:isAddonEnabled("ItemDB") then return end

function Skinner:ItemDB()

	local IDB = LibStub("AceAddon-3.0"):GetAddon("ItemDB", true)
	if not IDB then return end

	-- Browser
	self:skinEditBox{obj=ItemDB_Browser_Filter_Name, noWidth=true, x=-5}
	self:skinEditBox{obj=ItemDB_Browser_Filter_MinLevel, noWidth=true, x=-5, y=4}
	self:skinEditBox{obj=ItemDB_Browser_Filter_MaxLevel, noWidth=true, x=-5}
	self:skinDropDown{obj=ItemDB_Browser_Filter_RarityDropDown, mtx=-5, mty=2}
	self:skinDropDown(ItemDB_Browser_FilterDropDown)
	self:skinScrollBar{obj=ItemDB_Browser_FilterScrollFrame}
	self:skinScrollBar{obj=ItemDB_Browser_ItemScrollFrame}
	self:addSkinFrame{obj=ItemDB_Browser, kfs=true, x1=10, y1=-11, y2=4}
	-- Advanced Filters panel
	self:getRegion(ItemDB_Browser_AdvancedFiltersCloseButton, 4):SetAlpha(0)
	self:skinButton{obj=ItemDB_Browser_AdvancedFiltersCloseButton, cb=true}
	self:addSkinFrame{obj=ItemDB_Browser_AdvancedFilters, kfs=true, x1=-1, y1=-3, x2=-3}

	-- sort buttons
	local sortNames= {"Rarity", "Name", "MinLevel", "ItemLevel", "Value"}
	for _, v in pairs(sortNames) do
		local sortObj = _G["ItemDB_Browser_Sort_"..v]
		self:keepRegions(sortObj, {4, 5, 6}) -- N.B. Region 4 is text, 5 is the arrow, 6 is the highlight
		self:applySkin(sortObj)
	end
	-- filter buttons
	-- Hook this to manage the filters
	self:SecureHook(IDB, "FilterList_Update", function()
		for i = 1, 15 do
			local filterObj = _G["ItemDB_Browser_FilterButton"..i]
			self:keepRegions(filterObj, {3, 4})
			self:applySkin(filterObj)
		end
	end)

	-- Tabs
	for i = 1, ItemDB_Browser.numTabs do
		local tabObj = _G["ItemDB_BrowserTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook(IDB, "SelectItemProvider",function(...)
			for i = 1, ItemDB_Browser.numTabs do
				local tabSF = self.skinFrame[_G["ItemDB_BrowserTab"..i]]
				if i == ItemDB_Browser.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

end
