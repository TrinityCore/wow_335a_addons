if not Skinner:isAddonEnabled("GearScore") then return end

function Skinner:GearScore()

	-- Display frame
	self:addSkinFrame{obj=GS_DisplayFrame, y1=-9, x2=-9, y2=-2}
	-- Tabs
	for i = 1, GS_DisplayFrame.numTabs do
		local tabObj = _G["GS_DisplayFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
		if i == 3 then -- option tab
			self:moveObject{obj=tabObj, x=-10}
			tabObj:SetHeight(32)
		end
	end
	self.tabFrames[GS_DisplayFrame] = true

	-- Default frame
	self:skinEditBox{obj=GS_EditBox1, regs={9}, y=-4}
	-- Gear frame
	for i = 1, 4 do
		self:glazeStatusBar(_G["GS_SpecBar"..i], 0)
		_G["GS_SpecBar"..i.."LeftTexture"]:SetAlpha(0)
	end
	GS_Model:SetBackdrop(nil)
	-- Notes frame
	self:skinEditBox{obj=GS_NotesEditBox, regs={9}}
	-- XP frame
	for i = 1, 14 do
		self:glazeStatusBar(_G["GS_XpBar"..i], 0)
		_G["GS_XpBar"..i.."LeftTexture"]:SetAlpha(0)
	end
	-- Options frame
	self:skinEditBox{obj=GS_LevelEditBox, regs={9}, noWidth=true}
	self:moveObject{obj=GS_FontString88, y=24} -- move "Show GearScores in Chat" text upto its checkbox

-->>-- Database frame
	self:SecureHook("GearScore_DisplayDatabase", function(...)
		GS_DatabaseFrame.tooltip.tfade:SetTexture(nil) -- remove gradient as alpha value is changed
	end)
	self:moveObject{obj=GSDatabaseFrameCloseButton, x=-1, y=-1}
	self:skinEditBox{obj=GS_SearchXBox, y=4}
	self:addSkinFrame{obj=GS_DatabaseFrame, y2=-1}
	-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then GearScoreTooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(GearScoreTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end
	-- Report frame
	self:skinEditBox{obj=GSX_WhisperEditBox, regs={9}}
	self:skinEditBox{obj=GSX_ChannelEditBox, regs={9}}
	self:addSkinFrame{obj=GS_ReportFrame}
	-- Tabs
	for i = 1, GS_DatabaseFrame.numTabs do
		local tabObj = _G["GS_DatabaseFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[GS_DatabaseFrame] = true

end
