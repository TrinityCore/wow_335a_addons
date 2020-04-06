
function Skinner:VanasKoS()

-->>--	List Frame
	self:keepFontStrings(VanasKoSFrame)
	self:moveObject(VanasKosFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(VanasKoSListFrameShowButton, "+", 50, nil, nil)
	self:keepRegions(VanasKoSFrameChooseListDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:moveObject(VanasKoSFrameChooseListDropDown, nil, nil, "+", 10)
	self:moveObject(VanasKoSListFrameShowButton, "+", 34, "+", 18)
	self:skinEditBox(VanasKoSListFrameSearchBox, {9})
	self:moveObject(VanasKoSListFrameSyncButton, "+", 5, "+", 13)
	self:keepFontStrings(VanasKoSGuildsListFrame)
	self:keepFontStrings(VanasKoSListScrollFrame)
	self:keepFontStrings(VanasKoSPlayersListFrame)
	self:moveObject(VanasKoSListScrollFrame, "+", 30, "+", 10)
	self:skinScrollBar(VanasKoSListScrollFrame)
	self:moveObject(VanasKoSListFrameListButton1, "-", 10, "+", 14)
	self:keepFontStrings(VanasKoSListFrame)
	VanasKoSFrame:SetWidth(VanasKoSFrame:GetWidth() * self.FxMult)
	VanasKoSFrame:SetHeight(VanasKoSFrame:GetHeight() * self.FyMult)
	self:moveObject(VanasKoSFrameTitleText, nil, nil, "+", 10)
	self:moveObject(VanasKoSFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(VanasKoSListFrameAddButton, "-", 10, "-", 70)
	self:applySkin(VanasKoSFrame)
-->>--	About Frame
	self:keepFontStrings(VanasKoSAboutFrame)
	self:moveObject(self:getChild(VanasKoSAboutFrame, 2), nil, nil, "-", 70)
-->>--	Tabs
	self:keepRegions(VanasKoSFrameTab1, {7,8})
	self:keepRegions(VanasKoSFrameTab2, {7,8})
	if self.db.profile.TexturedTab then
		self:applySkin(VanasKoSFrameTab1, nil, 0)
		self:applySkin(VanasKoSFrameTab2, nil, 0)
		self:SecureHook(VanasKoSGUI, "Update", function()
			self:setInactiveTab(VanasKoSFrameTab1)
			self:setInactiveTab(VanasKoSFrameTab2)
			self:setActiveTab(_G["VanasKoSFrameTab"..VanasKoSFrame.selectedTab])
		end)
	else
		self:applySkin(VanasKoSFrameTab1)
		self:applySkin(VanasKoSFrameTab2)
	end
	self:moveObject(VanasKoSFrameTab1, nil, nil, "-", 70)
	self:moveObject(VanasKoSFrameTab2, "+", 8, nil, nil)
-->>--	Warning Frame
	self:applySkin(VanasKoS_WarnFrame)
	VanasKoS_WarnFrame.SetBackdropColor = function() end

end
