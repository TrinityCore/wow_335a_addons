if not Skinner:isAddonEnabled("Enchantrix-Barker") then return end

function Skinner:EnchantrixBarker()
	if self.initialized.EnchantrixBarker then return end
	self.initialized.EnchantrixBarker = true

	if not IsAddOnLoaded("AdvancedTradeSkillWindow") then
		self:SecureHookScript(Enchantrix_BarkerDisplayButton, "OnShow", function()
			self:moveObject(Enchantrix_BarkerDisplayButton, nil, nil, "+", 15)
			self:Unhook(Enchantrix_BarkerDisplayButton, "OnShow")
		end)
	end

	if self.db.profile.TexturedTab then
		self:SecureHook("Enchantrix_BarkerOptions_Tab_OnClick", function()
			for i = 1, 4 do
				local tabName = _G["Enchantrix_BarkerOptions_FrameTab"..i]
				if i == Enchantrix_BarkerOptions_Frame.selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end

	self:keepFontStrings(Enchantrix_BarkerOptions_Frame)
	Enchantrix_BarkerOptions_Frame:SetWidth(Enchantrix_BarkerOptions_Frame:GetWidth() * self.FxMult)
	Enchantrix_BarkerOptions_Frame:SetHeight(Enchantrix_BarkerOptions_Frame:GetHeight() * self.FyMult)
	for i = 1, 4 do
		local tabName = _G["Enchantrix_BarkerOptions_FrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		if i == 1 then
			self:moveObject(tabName, "-", 5, "-", 70)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 10, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
	end
	self:moveObject(Enchantrix_BarkerOptions_CloseButton, "+", 28, "+", 8)
	self:applySkin(Enchantrix_BarkerOptions_Frame)

end
