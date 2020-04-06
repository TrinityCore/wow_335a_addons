if not Skinner:isAddonEnabled("Skillet") then return end

function Skinner:Skillet()
	if not self.db.profile.TradeSkillUI then return end

	self:SecureHook(Skillet, "ShowTradeSkillWindow", function()
		SkilletRankFrameBorder:Hide()
		self:glazeStatusBar(SkilletRankFrame, 0, SkilletRankFrameBackground)
		self:skinDropDown{obj=SkilletRecipeGroupDropdown}
		self:skinDropDown{obj=SkilletSortDropdown}
		self:skinEditBox(SkilletFilterBox, {9})
		self:skinScrollBar{obj=SkilletSkillList, size=3}
		self:applySkin(SkilletSkillListParent)
		self:applySkin(SkilletReagentParent)
		self:skinEditBox(SkilletItemCountInputBox, {9})
		self:skinScrollBar{obj=SkilletQueueList, size=3}
		self:applySkin(SkilletQueueParent)
		self:addSkinFrame{obj=SkilletFrame, kfs=true}
		self:Unhook(Skillet, "ShowTradeSkillWindow")
	end)

-->>--	SkilletShoppingList
	self:SecureHook(SkilletShoppingList, "Show", function(this)
		self:skinScrollBar{obj=SkilletShoppingListList, size=3}
		self:applySkin(SkilletShoppingListParent)
		self:addSkinFrame{obj=SkilletShoppingList, kfs=true}
		self:Unhook(SkilletShoppingList, "Show")
	end)

-->>--	SkilletRecipeNotes Frame
	self:SecureHook(SkilletRecipeNotesFrame, "Show", function(this)
		self:skinScrollBar{obj=SkilletNotesList, size=3}
		self:applySkin(SkilletRecipeNotesFrame)
		self:Unhook(SkilletRecipeNotesFrame, "Show")
	end)
	self:SecureHook(Skillet, "RecipeNote_OnClick", function(this, button)
		self:skinEditBox{obj=self:getChild(button, 2), regs={9}} -- skin EditBox
		self:Unhook(Skillet, "RecipeNote_OnClick")
	end)

-->>-- InventoryInfoPopup
	self:SecureHook(Skillet, "ShowInventoryInfoPopup", function()
		self:addSkinFrame{obj=SkilletInfoBoxFrame}
		self:Unhook(Skillet, "ShowInventoryInfoPopup")
	end)

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then SkilletTradeskillTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(SkilletTradeskillTooltip, "OnShow", function(this)
			self:skinTooltip(SkilletTradeskillTooltip)
		end)
	end

-->>-- Buttons
	if self.modBtns then
		-- skin queue buttons
		SkilletQueueButton1:SetParent(SkilletQueueParent) -- reparent it
		self.sBut[SkilletQueueButton1] = nil -- remove old skin button
		self:SecureHook(Skillet, "UpdateQueueWindow", function()
			for i = 1, floor(SkilletQueueList:GetHeight() / SKILLET_TRADE_SKILL_HEIGHT) do
				local dBtn = _G["SkilletQueueButton"..i.."DeleteButton"]
				if not self.sBut[dBtn] then self:skinButton{obj=dBtn, x1=-3, y1=-3, x2=3, y2=1} end
			end
		end)
    if Skillet.PluginButton_OnClick ~= nil then
      self:SecureHook(Skillet, "PluginButton_OnClick", function(this, button)
        for i = 1, #SkilletFrame.added_buttons do
          local btn = _G["SkilletPluginDropdown"..i]
          if not self.sBut[btn] then
            self:skinButton{obj=btn}
          end
        end
      end)
    end
		
	end

end
