
function Skinner:KingOfTheJungle()

	if select(2, UnitClass('player')) ~= "HUNTER" then return end

	self:SecureHook(KingOfTheJungle, "KOTJUI_Show", function()
		if KOTJUIMainFrame.skinned then return end
-->>--	Main Frame
		KOTJUIMainFrame:SetWidth(KOTJUIMainFrame:GetWidth() * self.FxMult - 10)
		KOTJUIMainFrame:SetHeight(KOTJUIMainFrame:GetHeight() * self.FyMult - 20)
		self:moveObject(self:getChild(KOTJUIMainFrame, 1), "+", 28, "+", 8) -- Close Button
		self:moveObject(self:getRegion(KOTJUIMainFrame, 6), "-", 10, "+", 10)
		self:moveObject(self:getRegion(KOTJUIMainFrame, 7), "-", 10, "+", 10)
		self:moveObject(self:getRegion(KOTJUIMainFrame, 8), "-", 10, "+", 10)
		self:moveObject(self:getRegion(KOTJUIMainFrame, 9), "-", 10, "+", 10)
		self:moveObject(self:getRegion(KOTJUIMainFrame, 10), nil, nil, "+", 8) -- Title
		self:keepRegions(KOTJUIMainFrame, {6,7,8,9,10})
		self:applySkin(KOTJUIMainFrame)
-->>--	Food Frame
		self:keepRegions(KingOfTheJungleUI_Food_Frame, {})
		self:keepRegions(KOTJFoodButtonDropDown, {4})
		self:keepRegions(KingOfTheJungleUI_ScrollFrame, {})
		self:skinScrollBar(KingOfTheJungleUI_ScrollFrame)
		self:moveObject(KOTJFoodButtonDropDown, "-", 10, "+", 10)
		self:moveObject(self:getChild(KingOfTheJungleUI_Food_Frame, 2), "-", 10, "+", 10) -- Check button
		self:moveObject(KingOfTheJungleUI_ScrollFrame, "-", 10, "+", 20)
		for i = 1, 7 do
			self:moveObject(_G["KOTJFoodButton"..i.."Button"], "-", 10, "+", 10)
			self:moveObject(self:getChild(KingOfTheJungleUI_Food_Frame, (i + 1) * 2), "-", 10, "+", 10) -- Text
		end
-->>--	Diets Frame
		self:keepRegions(KingOfTheJungleUI_Diets_Frame, {})
		self:keepRegions(KingOfTheJungleUI_Diets_ScrollFrame, {})
		self:skinScrollBar(KingOfTheJungleUI_Diets_ScrollFrame)
		self:moveObject(KingOfTheJungleUI_Diets_ScrollFrame, "-", 10, "+", 20)
		for i = 1, 7 do
			self:moveObject(_G["KOTJDietButton"..i.."Button"], "-", 10, "+", 10)
			self:moveObject(self:getChild(KingOfTheJungleUI_Diets_Frame, i * 2), "-", 10, "+", 10) -- Text
		end
-->>--	Tabs
		self:keepRegions(KOTJUIMainFrameTab1, {7,8})
		self:keepRegions(KOTJUIMainFrameTab2, {7,8})
		self:keepRegions(KOTJUIMainFrameTab3, {7,8})
		self:moveObject(KOTJUIMainFrameTab1, "-", 10, "-", 70)
		self:moveObject(KOTJUIMainFrameTab2, nil, nil, "-", 70)
		self:moveObject(KOTJUIMainFrameTab3, "+", 10, "-", 70)
		if self.db.profile.TexturedTab then
			self:applySkin(KOTJUIMainFrameTab1, nil, 0)
			self:applySkin(KOTJUIMainFrameTab2, nil, 0)
			self:applySkin(KOTJUIMainFrameTab3, nil, 0)
			self:setActiveTab(KOTJUIMainFrameTab1)
			self:setInactiveTab(KOTJUIMainFrameTab2)
			self:setInactiveTab(KOTJUIMainFrameTab3)
			self:SecureHook(KingOfTheJungle, "KOTJUI_HandlerTabButton", function(buttonname)
--				self:Debug("KOTJUI_HandlerTabButton: [%s, %s]", buttonname, KOTJUIMainFrame.selectedTab)
				for i = 1, 3 do
					if KOTJUIMainFrame.selectedTab == i then
						self:setActiveTab(_G["KOTJUIMainFrameTab"..i])
					else
						self:setInactiveTab(_G["KOTJUIMainFrameTab"..i])
					end
				end
			end)
		else
			self:applySkin(KOTJUIMainFrameTab1)
			self:applySkin(KOTJUIMainFrameTab2)
			self:applySkin(KOTJUIMainFrameTab3)
		end
		KOTJUIMainFrame.skinned = true
	end)

end
