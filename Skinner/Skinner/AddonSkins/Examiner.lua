if not Skinner:isAddonEnabled("Examiner") then return end

function Skinner:Examiner()
	if not self.db.profile.InspectUI then return end

	-- this is used to add a texture to the dropdown
	local function textureDD(dd)

		self:keepFontStrings(dd)
		if self.db.profile.TexturedDD then
			dd.ddTex = dd:CreateTexture(nil, "BORDER")
			dd.ddTex:SetTexture(Skinner.itTex)
			dd.ddTex:ClearAllPoints()
			dd.ddTex:SetPoint("TOPLEFT", dd, "TOPLEFT", 0, -2)
			dd.ddTex:SetPoint("BOTTOMRIGHT", dd, "BOTTOMRIGHT", -3, 3)
		end

	end

	-- hook this to skin the dropdown menu (also used by TipTac skin)
	if not self:IsHooked(AzDropDown, "ToggleMenu") then
		self:SecureHook(AzDropDown, "ToggleMenu", function(...)
			self:skinScrollBar{obj=_G["AzDropDownScroll"..AzDropDown.vers]}
			self:addSkinFrame{obj=_G["AzDropDownScroll"..AzDropDown.vers]:GetParent()}
			self:Unhook(AzDropDown, "ToggleMenu")
		end)
	end

	self:removeRegions(Examiner, {1, 5, 6, 7, 8}) -- N.B. other regions are text or background
	self:addSkinFrame{obj=Examiner, x1=10, y1=-11, x2=-33}

	-- skin sub frames
	for k, mod in pairs(Examiner.modules) do
--		self:Debug("Examiner.modules: [%d, %s, %s]", k, mod.token, mod.page or "nil")
		if mod.page then
			if mod.token == "Config" then
				self:SecureHookScript(mod.page, "OnShow", function(this)
					textureDD(self:getChild(this, 1)) -- dropdown
					self:Unhook(mod.page, "OnShow")
				end)
			elseif mod.token == "Cache" then
				self:skinScrollBar{obj=ExaminerCacheScroll}
			elseif mod.token == "PvP" then
				-- arena panels
				for i = 2, 4 do
					self:addSkinFrame{obj=self:getChild(mod.page, i)}
				end
			elseif mod.token == "Feats" then
				self:SecureHookScript(mod.page, "OnShow", function(this)
					textureDD(self:getChild(this, 1)) -- dropdown
					self:Unhook(mod.page, "OnShow")
				end)
				self:skinScrollBar{obj=ExaminerFeatsScroll}
			elseif mod.token == "Stats" then
				self:skinScrollBar{obj=ExaminerStatScroll}
			elseif mod.token == "Talents" then
				self:skinFFToggleTabs("ExaminerTab", MAX_TALENT_TABS)
				self:skinScrollBar{obj=ExaminerTalentsScrollChild}
			end
			if mod.token ~= "Talents" then self:addSkinFrame{obj=mod.page} end
		end
	end

end
