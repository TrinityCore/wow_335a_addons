if not Skinner:isAddonEnabled("Badapples") then return end

function Skinner:Badapples()
	if not self.db.profile.FriendsFrame then return end

	-- Frame Tab
	self:keepRegions(BadapplesFriendsFrameTab6, {7, 8}) -- N.B. these regions are text & highlight
	self:addSkinFrame{obj=BadapplesFriendsFrameTab6, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
	local tabSF = self.skinFrame[BadapplesFriendsFrameTab6]
	if self.isTT then self:setInactiveTab(tabSF) end

	-- Toggle Tabs
	for _, v in pairs{"Friends", "Ignore", "Muted"} do
		local tabName = "Badapples"..v.."FrameToggleTab4"
		local tabObj = _G[tabName]
		tabObj:SetHeight(tabObj:GetHeight() - 5)
		self:moveObject{obj=_G[tabName.."Text"], x=-2, y=3}
		self:moveObject{obj=_G[tabName.."HighlightTexture"], x=-2, y=5}
		self:keepRegions(tabObj, {7, 8}) -- N.B. these regions are text & highlight
		self:addSkinFrame{obj=tabObj}
	end

	self:skinFFToggleTabs("BadapplesFrameToggleTab", 4)
	self:moveObject{obj=BadapplesFrameToggleTab4Text, y=1}
-->-- Side Tab
	self:removeRegions(BadapplesFriendsFrameSideTab1, {1}) -- N.B. other regions are icon and highlight
	self:addSkinFrame{obj=BadapplesFriendsFrameSideTab1}

-->>-- Badapples Frame
	self:keepFontStrings(BadapplesDropDown)
	self:skinScrollBar{obj=BadapplesListScrollFrame}
	self:moveObject{obj=BadapplesFrameEditBox, y=4}
	self:skinEditBox{obj=BadapplesFrameEditBox, regs={9}}
	self:addSkinFrame{obj=BadapplesFrameNameColumnHeader, kfs=true}
	self:addSkinFrame{obj=BadapplesFrameReasonColumnHeader, kfs=true}
	self:keepFontStrings(BadapplesFrame)

	self:skinButton{obj=BadapplesFrameColorButton}
	self:skinButton{obj=BadapplesFrameAddButton}
	self:skinButton{obj=BadapplesFrameRemoveButton}

end
