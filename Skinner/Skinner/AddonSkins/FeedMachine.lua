if not Skinner:isAddonEnabled("FeedMachine") then return end

function Skinner:FeedMachine()

	if select(2, UnitClass('player')) ~= "HUNTER" then return end

	self:SecureHook(FeedMachine, "FMUI_Show", function()
-->>--	Main Frame
		FMUIMainFrame:SetWidth(FMUIMainFrame:GetWidth() * self.FxMult - 10)
		FMUIMainFrame:SetHeight(FMUIMainFrame:GetHeight() * self.FyMult - 20)
		self:moveObject(self:getChild(FMUIMainFrame, 1), "+", 28, "+", 8) -- Close Button
		self:moveObject(self:getRegion(FMUIMainFrame, 6), "-", 10, "+", 10)
		self:moveObject(self:getRegion(FMUIMainFrame, 7), "-", 10, "+", 10)
		self:moveObject(self:getRegion(FMUIMainFrame, 8), "-", 10, "+", 10)
		self:moveObject(self:getRegion(FMUIMainFrame, 9), "-", 10, "+", 10)
		self:moveObject(self:getRegion(FMUIMainFrame, 10), nil, nil, "+", 8) -- Title
		self:keepRegions(FMUIMainFrame, {6, 7, 8, 9, 10}) -- N.B. 6 - 9 are the background textures
		self:applySkin(FMUIMainFrame)
-->>--	Food Frame
		self:keepFontStrings(FeedMachineUI_Food_Frame)
		self:skinDropDown(FMFoodButtonDropDown)
		self:moveObject(FMFoodButtonDropDown, "-", 10, "+", 10)
		self:removeRegions(FeedMachineUI_ScrollFrame)
		self:skinScrollBar(FeedMachineUI_ScrollFrame)
		self:moveObject(FeedMachineUI_ScrollFrame, "-", 10, "+", 20)
		self:moveObject(self:getChild(FeedMachineUI_Food_Frame, 2), "-", 10, "+", 10) -- Check button
		for i = 1, 7 do
			self:moveObject(_G["FMFoodButton"..i.."Button"], "-", 10, "+", 10)
			self:moveObject(self:getChild(FeedMachineUI_Food_Frame, (i + 1) * 2), "-", 10, "+", 10) -- Text
		end
-->>--	Diets Frame
		self:keepFontStrings(FeedMachineUI_Diets_Frame)
		self:removeRegions(FeedMachineUI_Diets_ScrollFrame)
		self:skinScrollBar(FeedMachineUI_Diets_ScrollFrame)
		self:moveObject(FeedMachineUI_Diets_ScrollFrame, "-", 10, "+", 20)
		for i = 1, 7 do
			self:moveObject(_G["FMDietButton"..i.."Button"], "-", 10, "+", 10)
			self:moveObject(self:getChild(FeedMachineUI_Diets_Frame, i * 2), "-", 10, "+", 10) -- Text
		end
-->>--	Tabs
		self:keepRegions(FMUIMainFrameTab1, {7,8})
		self:keepRegions(FMUIMainFrameTab2, {7,8})
		self:moveObject(FMUIMainFrameTab1, "-", 10, "-", 70)
		self:moveObject(FMUIMainFrameTab2, nil, nil, "-", 70)
		if self.db.profile.TexturedTab then
			self:applySkin(FMUIMainFrameTab1, nil, 0)
			self:applySkin(FMUIMainFrameTab2, nil, 0)
			self:setActiveTab(FMUIMainFrameTab1)
			self:setInactiveTab(FMUIMainFrameTab2)
			self:SecureHook(FeedMachine, "FMUI_HandlerTabButton", function(buttonname)
--				self:Debug("FMUI_HandlerTabButton: [%s, %s]", buttonname, FMUIMainFrame.selectedTab)
				for i = 1, 2 do
					if FMUIMainFrame.selectedTab == i then
						self:setActiveTab(_G["FMUIMainFrameTab"..i])
					else
						self:setInactiveTab(_G["FMUIMainFrameTab"..i])
					end
				end
			end)
		else
			self:applySkin(FMUIMainFrameTab1)
			self:applySkin(FMUIMainFrameTab2)
		end
		self:Unhook(FeedMachine, "FMUI_Show")
	end)

end
