if not Skinner:isAddonEnabled("RecipeBook") then return end

function Skinner:RecipeBook()

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook(RBUI, "MainFrame_OnUpdate",function(...)
			for i = 1, RBUI_MainFrame.numTabs do
				local tabSF = self.skinFrame[_G["RBUI_MainFrameTab"..i]]
				if i == RBUI_MainFrame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

-->>-- Main Frame
	self:moveObject{obj=RBUI_MainFrame_TitleText, y=-6}
	self:addSkinFrame{obj=RBUI_MainFrame, kfs=true}
	-- Tabs
	for i = 1, RBUI_MainFrame.numTabs do
		local tabObj = _G["RBUI_MainFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

-->>-- Search Frame (Tab 1)
	self:skinEditBox(RBUI_SearchFrame_EDIT_SearchFor, {9})
	self:skinScrollBar{obj=RBUI_SearchFrame_ResultsScrollFrame}
-->>-- Skill Frame (Tab 2)
	self:skinEditBox(RBUI_SkillFrame_EDIT_Filter, {9})
	self:keepFontStrings(RBUI_SkillFrame_DD_SortType)
	self:skinScrollBar{obj=RBUI_SkillFrame_ScrollFrame}
-->>-- Skill Tracking Sub Frame
	self:addSkinFrame{obj=RBSkillTrackFrame, kfs=true}
-->>-- Sharing Frame (Tab 3)
	self:skinScrollBar{obj=RBUI_SharingFrame_WhoScrollFrame}
	self:skinFFToggleTabs("RBUI_SharingFrameTab")
-->>-- Banking Frame (Tab 4)
	self:skinScrollBar{obj=RBUI_BankingFrame_ItemScrollFrame}
-->>-- Options Frame (Tab 5)

-->>-- Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			RecipeBookInfoTooltip:SetBackdrop(self.Backdrop[1])
			RecipeBookUITooltip:SetBackdrop(self.Backdrop[1])
		end
		self:SecureHookScript(RecipeBookInfoTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
		self:SecureHookScript(RecipeBookUITooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

-->>-- LibDataBroker support
	if LibStub("LibDataBroker-1.1", true)
	and not LibStub("LibDataBroker-1.1"):GetDataObjectByName("RecipeBook") then
		rbDB = LibStub("LibDataBroker-1.1"):NewDataObject("RecipeBook", {
			type = "launcher",
			icon = "Interface\\AddOns\\RecipeBook\\Icons\\Minimap",
			OnClick = function(button)
				if button == "LeftButton" then
					if RBUI_MainFrame:IsVisible() then RBUI_MainFrame:Hide()
					else RBUI:ShowBrowseFrame()
					end
				end
			end,
			OnTooltipShow = function(tooltip)
				tooltip:AddLine(RECIPEBOOK_MMTXT, 1, 1, 1, 1)
			end,
		})
	end

end
