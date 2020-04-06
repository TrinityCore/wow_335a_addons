if not Skinner:isAddonEnabled("MrTrader_SkillWindow") then return end

function Skinner:MrTrader_SkillWindow()

	-- hide filter texture when filter is clicked
	self:SecureHook("MRTUIUtils_FilterButton_SetType", function(button, type, text, isLast)
		_G[button:GetName().."NormalTexture"]:SetAlpha(0)
	end)

	self:skinDropDown{obj=MRTSkillItemDropDown}
	self:keepFontStrings(MRTAvailableFilterFrame)
	self:skinEditBox{obj=MRTSkillFrameEditBox}
	MRTSkillRankFrameBorder:SetAlpha(0)
	self:glazeStatusBar(MRTSkillRankFrame, 0, MRTSkillRankFrameBackground)
	for i = 1, 18 do
		self:keepRegions(_G["MRTSkillFilterButton"..i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:addSkinFrame{obj=_G["MRTSkillFilterButton"..i]}
	end
	self:skinScrollBar{obj=MRTSkillFilterScrollFrame}
	self:skinScrollBar{obj=MRTSkillListScrollFrame}
	self:skinScrollBar{obj=MRTDetailScrollFrame}
	self:keepFontStrings(MRTDetailScrollChildFrame)
	self:skinEditBox{obj=MRTSkillInputBox, x=-6}
	self:addSkinFrame{obj=MRTSkillFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}

	for i = 1, MAX_TRADE_SKILL_REAGENTS do
		_G["MRTSkillReagent"..i.."NameFrame"]:SetTexture(nil)
	end

-->>-- New Category frame
	self:skinEditBox{obj=MRTNewCategoryFrameCategoryName, x=-3}
	self:addSkinFrame{obj=MRTNewCategoryFrame, kfs=true, x1=5, y1=-6, x2=-5, y2=6}

end
