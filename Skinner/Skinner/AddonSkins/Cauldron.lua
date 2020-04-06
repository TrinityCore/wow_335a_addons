if not Skinner:isAddonEnabled("Cauldron") then return end

function Skinner:Cauldron()

	-- Main frame
	self:skinDropDown{obj=CauldronFiltersFilterDropDown}
	self:skinEditBox{obj=CauldronFiltersSearchEditBox}
	self:skinDropDown{obj=CauldronFiltersCategoryDropDown}
	self:skinDropDown{obj=CauldronFiltersInvSlotDropDown}
	self:moveObject{obj=CauldronCloseButton, x=-4}
	self:addSkinFrame{obj=CauldronFrame, kfs=true, x1=9, y1=-11, x2=-5, y2=-1}
	-- List frame
	self:removeRegions(CauldronSkillListFrameExpandButtonFrame)
	self:skinButton{obj=CauldronSkillListFrameExpandButtonFrameCollapseAllButton, mp=true}
	self:skinScrollBar{obj=CauldronSkillListFrameScrollFrame}
	if self.modBtns then
		-- store player name
		local uName = UnitName("player")
		-- hook to manage changes to button textures
		self:SecureHook(Cauldron, "UpdateSkillList", function()
			local skillName = CURRENT_TRADESKILL
			if IsTradeSkillLinked() then skillName = "Linked-"..skillName end
			local skillList = Cauldron:GetSkillList(uName, skillName)
			if not skillList then return end
			for i = 1, #skillList do
				local btn = _G["CauldronSkillItem"..i.."DiscloseButton"]
				if not btn then break end
				if not btn.skin then -- skin button if required
					self:skinButton{obj=btn, mp=true, plus=true}
					btn.skin = true
					-- remove reagent item textures as well
					for j = 1, 8 do
						_G["CauldronSkillItem"..i.."ReagentsItemDetail"..j.."NameFrame"]:SetTexture(nil)
					end
				end
				if btn then self:checkTex(btn) end
			end
--			self:checkTex(CauldronSkillListFrameExpandButtonFrameCollapseAllButton) --[ Not currently updated v154]
		end)
	end
	
	-- Skill Info frame
	self:keepFontStrings(CauldronRankFrame)
	self:glazeStatusBar(CauldronRankFrame, 0, CauldronRankFrameBackground)
	-- Queue frame
	self:skinScrollBar{obj=CauldronQueueFrameScrollFrame}
	CauldronQueueFrameQueueEmptyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- Buttons frame
	self:skinEditBox{obj=CauldronAmountInputBox, noHeight=true, x=-3}
	self:moveObject{obj=CauldronAmountIncrementButton, x=3}
	self:skinAllButtons{obj=CauldronButtonsFrame}

-->>-- Shopping List
	self:addSkinFrame{obj=CauldronShoppingListFrame, x1=-2, y1=-1, x2=-1, y2=-1}

end
