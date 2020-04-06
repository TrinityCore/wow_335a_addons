
function Skinner:Jobber()

	local function fixDDTex(opts)
		
		opts.tex:SetTexture(Skinner.itTex)
		opts.tex:ClearAllPoints()
		opts.tex:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", 0, -5)
		opts.tex:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", -2, 6)
		
	end

	self:keepFontStrings(JobberRankFrame)
	self:glazeStatusBar(JobberRankFrame, 0)
	self:getChild(JobberRankFrame, 1):SetBackdrop(nil) -- Background, has same name as a texture
	self:skinEditBox{obj=JobberFrameContainerEditBox, regs={9}}
	fixDDTex{obj=JobberSubClassDropDown, tex=JobberSubClassDropDownMiddle}
	JobberSubClassDropDownBackGround:SetBackdrop(nil)
	fixDDTex{obj=JobberSortingDropDown, tex=JobberSortingDropDownMiddle}
	JobberSortingDropDownBackGround:SetBackdrop(nil)
	fixDDTex{obj=JobberInvSlotDropDown, tex=JobberInvSlotDropDownMiddle}
	JobberInvSlotDropDownBackGround:SetBackdrop(nil)
	self:removeRegions(JobberExpandButtonFrame)
	self:skinScrollBar{obj=JobberListScrollFrame, noMove=true}
	JobberHorizontalBar:Hide()
	self:keepFontStrings(JobberPricingBar)
	self:skinEditBox{obj=JobberInputBox, regs={9}, noHeight=true, x=-5}
	self:addSkinFrame{obj=JobberFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=73}
	
-->>-- PM Frame
	fixDDTex{obj=JobberPMSortingDropDown, tex=JobberPMSortingDropDownMiddle}
	JobberPMSortingDropDownBackGround:SetBackdrop(nil)
	self:skinEditBox{obj=JobberPMAdjQtyInputBox, regs={9}, noHeight=true, x=-5}
	self:addSkinFrame{obj=JobberPM, kfs=true}

end
