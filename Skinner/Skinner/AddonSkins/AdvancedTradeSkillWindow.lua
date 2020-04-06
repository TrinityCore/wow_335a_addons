if not Skinner:isAddonEnabled("AdvancedTradeSkillWindow") then return end

function Skinner:AdvancedTradeSkillWindow()
	if not self.db.profile.TradeSkillUI then return end

	self:keepFontStrings(ATSWRankFrame)
	self:keepFontStrings(ATSWRankFrameBorder)
	self:glazeStatusBar(ATSWRankFrame, 0, ATSWRankFrameBackground)
	self:skinScrollBar{obj=ATSWListScrollFrame}
	self:keepFontStrings(ATSWExpandButtonFrame)
	self:skinDropDown{obj=ATSWInvSlotDropDown}
	self:skinDropDown{obj=ATSWSubClassDropDown}
	self:skinScrollBar{obj=ATSWQueueScrollFrame}
	self:skinEditBox{obj=ATSWInputBox, regs={9}, noWidth=true}
	self:skinEditBox{obj=ATSWFilterBox, regs={9}}
	self:addSkinFrame{obj=ATSWFrame, kfs=true, x1=14, y1=-11, x2=-32, y2=10}
	-- m/p buttons
	self:skinButton{obj=ATSWCollapseAllButton, mp=true}
	for i = 1, ATSW_TRADE_SKILLS_DISPLAYED do
		self:skinButton{obj=_G["ATSWSkill"..i], mp=true}
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ATSWFrame_Update", function()
			for i = 1, ATSW_TRADE_SKILLS_DISPLAYED do
				self:checkTex(_G["ATSWSkill"..i])
			end
		end)
	end
	for i = 1, ATSW_MAX_TRADE_SKILL_REAGENTS do
		_G["ATSWReagent"..i.."NameFrame"]:SetTexture(nil)
	end

	-- Reagent frame
	self:addSkinFrame{obj=ATSWReagentFrame, kfs=true, x1=14, y1=-13, x2=-34, y2=10}

	-- Options frame
	self:addSkinFrame{obj=ATSWOptionsFrame}

	-- Continue frame
	self:addSkinFrame{obj=ATSWContinueFrame}

	-- Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then ATSWTradeskillTooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(ATSWTradeskillTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

	-- Shopping List frame
	self:skinScrollBar{obj=ATSWSLScrollFrame}
	self:addSkinFrame{obj=ATSWShoppingListFrame, kfs=true, x1=16, y1=-2, x2=-30, y2=40}

	-- Recipe Sorting Editor frame
	self:skinScrollBar{obj=ATSWCSUListScrollFrame}
	self:skinScrollBar{obj=ATSWCSSListScrollFrame}
	self:skinEditBox{obj=ATSWCSNewCategoryBox}
	self:addSkinFrame{obj=ATSWCSFrame, kfs=true, x1=14, y1=-11, x2=-32, y2=10}
	-- m/p buttons
	for i = 1, 17 do
		self:skinButton{obj=_G["ATSWCSCSkill"..i.."SkillButton"], mp=true}
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ATSWCS_UpdateSkillList", function()
			for i = 1, 17 do
				self:checkTex(_G["ATSWCSCSkill"..i.."SkillButton"])
			end
		end)
	end

-->>--	All Reagent List frame
	self:skinDropDown{obj=ATSWAllReagentListCharDropDown}
	self:addSkinFrame{obj=ATSWAllReagentListFrame, kfs=true, x1=14, y1=-1, x2=-35}
-->>--	Scan Delay frame
	self:glazeStatusBar(ATSWScanDelayFrameBar, 0, ATSWScanDelayFrameBarBackground)
	self:addSkinFrame{obj=ATSWScanDelayFrame, kfs=true}

end
