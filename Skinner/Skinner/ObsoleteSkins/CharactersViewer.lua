
function Skinner:CharactersViewer()
	if not self.db.profile.CharacterFrames then return end

	if not self:isVersion("CharactersViewer", { 103, 104, 289 }, CharactersViewer.version.number) then return end

	if CharactersViewer.version.number == 103 or CharactersViewer.version.number == 104 then
-->>--	version 1.03/4
		self:keepFontStrings(CharactersViewerDropDown)
		self:keepFontStrings(CharactersViewerDropDown2)
		self:moveObject(CharactersViewerDropDown2, "-", 10, "-", 14)
		self:keepFontStrings(CharactersViewer_Frame)
		CharactersViewer_Frame:SetWidth(CharactersViewer_Frame:GetWidth() * self.FxMult)
		CharactersViewer_Frame:SetHeight(CharactersViewer_Frame:GetHeight() * self.FyMult)
		self:moveObject(CharactersViewer_FrameTitleText, nil, nil, "-", 30)
		self:moveObject(CharactersViewer_RestedFrame, "-", 20, "+", 30)
		self:moveObject(CharactersViewer_FrameDetailTitle0, "-", 10, nil, nil)
		self:moveObject(CharactersViewer_FrameDetailText0, "-", 30, nil, nil)
		self:moveObject(CharactersViewer_FrameStatsTitle1, "-", 10, "+", 20)
		self:moveObject(CharactersViewer_CloseButton, "+", 28, "+", 8)
		self:moveObject(CharactersViewer_FrameItem1, "-", 8, "+", 20)
		self:moveObject(CharactersViewer_FrameItem10, "+", 30, "+", 20)
		self:moveObject(CharactersViewer_FrameItem16, "-", 10, nil, nil)
		self:moveObject(CharactersViewerResistanceFrame, "-", 10, "+", 20)
		self:moveObject(CharactersViewerDropDown, "-", 10, "-", 14)
		self:moveObject(CharactersViewer_MoneyFrame, "+", 30, "-", 80)
		self:applySkin(CharactersViewer_Frame)

		for i = 0, 4 do
			bagName = _G["CharactersViewer_ContainerFrame"..i]
			self:keepFontStrings(bagName)
			self:moveObject(_G[bagName:GetName().."Name"], "-", 10, nil, nil)
			_G[bagName:GetName().."Name"]:SetTextColor(1, 1, 1)
			self:applySkin(bagName)
			self:RawHookScript(bagName, "OnShow", function()
				-- self:Debug(this:GetName().." - OnShow")
				self.hooks[this].OnShow()
				self:shrinkBag(this)
			end)
		end

		keyringName = CharactersViewer_KeyringContainerFrame
		self:keepFontStrings(keyringName)
		self:moveObject(_G[keyringName:GetName().."Name"], "-", 10, nil, nil)
		_G[keyringName:GetName().."Name"]:SetTextColor(1, .7, 0)
		self:applySkin(keyringName)
		self:RawHookScript(keyringName, "OnShow", function()
			-- self:Debug(this:GetName().." - OnShow")
			self.hooks[this].OnShow()
			self:shrinkBag(this)
		end)

		-- Bank Frame
		self:keepFontStrings(CharactersViewerDropDown3)
		self:keepFontStrings(CharactersViewerBankFrame)
		CharactersViewerBankFrame:SetWidth(CharactersViewerBankFrame:GetWidth() * self.FxMult)
		CharactersViewerBankFrame:SetHeight(CharactersViewerBankFrame:GetHeight() * self.FyMult - 40)
		self:moveObject(CharactersViewerBankItems_TitleText, nil, nil, "-", 50)
		self:moveObject(self:getRegion(CharactersViewerBankFrame, 4), "+", 10, "-", 30)
		self:moveObject(self:getRegion(CharactersViewerBankFrame, 5), "+", 10, "-", 30)
		self:moveObject(CharactersViewerBankMoney1, "-", 120, "-", 80)
		self:moveObject(CharactersViewerBankItems_MoneyFrameTotal1, "-", 120, "-", 80)
		self:moveObject(CharactersViewerBankItems_CloseButton, "+", 28, "+", 8)
		self:moveObject(CharactersViewerBankItem_Item1, "-", 10, "+", 25)
		self:moveObject(CharactersViewerDropDown3, "+", 180, "-", 50)
		self:applySkin(CharactersViewerBankFrame)

		for i = 5, 10 do
			bankBagName = _G["CharactersViewer_BankItemsContainerFrame"..i]
			self:keepFontStrings(bankBagName)
			self:moveObject(_G[bankBagName:GetName().."Name"], "-", 10, nil, nil)
			_G[bankBagName:GetName().."Name"]:SetTextColor(.3, .3, 1)
			self:applySkin(bankBagName)
			self:RawHookScript(bankBagName, "OnShow", function()
				-- self:Debug(this:GetName().." - OnShow")
				self.hooks[this].OnShow()
				self:shrinkBag(this)
			end)
		end

	else
-->--	version 2.89

		CVCharacterFrame:SetWidth(CVCharacterFrame:GetWidth() * self.FxMult + 20)
		CVCharacterFrame:SetHeight(CVCharacterFrame:GetHeight() * self.FyMult)

		self:moveObject(CVCharacterNameText, nil, nil, "-", 30)
		self:moveObject(CVCharacterFrameCloseButton, "+", 28, "+", 8)
		self:moveObject(CVCharacterHeadSlot, nil, nil, "+", 20)
		self:moveObject(CVCharacterHandsSlot, nil, nil, "+", 20)
		self:moveObject(CVCharacterMainHandSlot, nil, nil, "-", 75)
		self:moveObject(CVCharacterResistanceFrame, nil, nil, "+", 20)
		self:moveObject(CVCharacterHealth, nil, nil, "+", 20)
		self:moveObject(CVPaperDollFrameDropDown2, "-", 10, "-", 14)
		self:keepFontStrings(CVCharacterAttributesFrame)

		self:keepFontStrings(CVSkillFrame)
		self:applySkin(CVSkillFrame)
		self:keepFontStrings(CVOptionFrame)
		self:applySkin(CVOptionFrame)
		self:keepFontStrings(CVReportFrame)
		self:applySkin(CVReportFrame)
		self:keepFontStrings(CVPaperDollFrameDropDown1)
		self:keepFontStrings(CVPaperDollFrameDropDown2)
		self:keepFontStrings(CVPaperDollFrame)
		self:applySkin(CVPaperDollFrame)
		self:keepFontStrings(CVReputationFrame)
		self:applySkin(CVReputationFrame)
		self:keepFontStrings(CVCharacterFrame)
		self:applySkin(CVCharacterFrame)

		-- Character Frame tabs
		for i = 1, 7 do
			local tabName = _G["CVCharacterFrameTab"..i]
			self:keepRegions(tabName, {7, 8})
			if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
			else self:applySkin(tabName) end
			if i == 1 then self:moveObject(tabName, nil, nil, "-", 72) end
			self:RawHookScript(tabName, "OnShow", function()
				-- self:Debug("%s - %s", this:GetName(), "OnShow")
				self.hooks[this].OnShow()
				this:SetWidth(this:GetWidth() * 0.80)
				local _, _, _, xOfs, _ = this:GetPoint()
				-- don't move the first tab
				if math.floor(xOfs) == -18 or math.floor(xOfs) == 0 then self:moveObject(this, "+", 15, nil, nil) end
			end)
		end
		-- Report Frame Tabs
		for i = 1, 3 do
			local tabName = _G["CVReportFrameToggleTab"..i]
			self:keepRegions(tabName, {7, 8})
			if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
			else self:applySkin(tabName) end
			self:moveObject(_G[tabName:GetName().."Text"], nil, nil, "+", 6)
			local tabHL = getglobal(tabName:GetName().."HighlightTexture")
			self:moveObject(tabHL, nil, nil, "+", 8)
		end
		-- Bags
		for i = 1, 6 do
			bagName = _G["CVContainerFrame"..i]
			self:keepFontStrings(bagName)
			self:moveObject(_G[bagName:GetName().."Name"], "-", 10, nil, nil)
			_G[bagName:GetName().."Name"]:SetTextColor(1, 1, 1)
			self:applySkin(bagName)
			self:RawHookScript(bagName, "OnShow", function()
				-- self:Debug(this:GetName().." - OnShow")
				self.hooks[this].OnShow()
				self:shrinkBag(this, true)
				self:Unhook(this, "OnShow")
				end)
		end

		-- Bank Frame
		CVBankFrame:SetWidth(CVBankFrame:GetWidth() * self.FxMult + 20)
		CVBankFrame:SetHeight(CVBankFrame:GetHeight() * self.FyMult)

		self:moveObject(CVBankFrameTitleText, nil, nil, "-", 30)
		self:moveObject(CVBankFrameTimestamp, nil, nil, "+", 20)
		self:moveObject(CVBankFrameItemSlotText, nil, nil, "-", 40)
		self:moveObject(self:getRegion(CVBankFrame, 5), nil, nil, "-", 40)
		self:moveObject(CVBankFrameItem1, "-", 22, "-", 7)
		self:moveObject(CVBankFrameMoney1, "-", 20, "-", 60)
		self:moveObject(CVBankCloseButton, "-", 20, "+", 7)
		self:moveObject(CVPaperDollFrameDropDown3, "-", 10, "-", 100)
		self:keepFontStrings(CVPaperDollFrameDropDown3)
		self:keepFontStrings(CVBankFrame)
		self:applySkin(CVBankFrame)

		for i = 7, 13 do
			bankBagName = _G["CVContainerFrame"..i]
			self:keepFontStrings(bankBagName)
			self:moveObject(_G[bankBagName:GetName().."Name"], "-", 10, nil, nil)
			_G[bankBagName:GetName().."Name"]:SetTextColor(.3, .3, 1)
			self:applySkin(bankBagName)
			self:RawHookScript(bankBagName, "OnShow", function()
--				self:Debug(this:GetName().." - OnShow")
				self.hooks[this].OnShow()
				self:shrinkBag(this)
				self:Unhook(this, "OnShow")
			end)
		end
	end

end
