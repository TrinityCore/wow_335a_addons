
function Skinner:DebuffFilter()

-->>--	Options Frame
	self:moveObject(DebuffFilterOptions_CloseButton, "+", 8, "+", 8)
	self:keepFontStrings(DebuffFilterOptions_SettingsFrame)
	self:applySkin(DebuffFilterOptions_SettingsFrame, nil)
	self:keepFontStrings(DebuffFilterOptions_GrowDropDown)
	self:keepFontStrings(DebuffFilterOptions_ScrollFrame)
	self:skinScrollBar(DebuffFilterOptions_ScrollFrame)
	self:keepFontStrings(DebuffFilterOptions_ListFrame)
	self:applySkin(DebuffFilterOptions_ListFrame, nil)
	self:keepFontStrings(DebuffFilterOptions_TargetDropDown)
	self:skinEditBox(DebuffFilterOptions_EditBox, {9})
	self:skinEditBox(DebuffFilterOptions_EditBox2, {9})
	self:keepFontStrings(DebuffFilterOptionsFrame)
	self:applySkin(DebuffFilterOptionsFrame, true)
-->>--	Tabs
	self:keepFontStrings(DebuffFilterOptions_DebuffsTab)
	if self.db.profile.TexturedTab then self:applySkin(DebuffFilterOptions_DebuffsTab, nil, 0)
	else self:applySkin(DebuffFilterOptions_DebuffsTab) end
	self:moveObject(DebuffFilterOptions_DebuffsTab, nil, nil, "-", 6)
	self:moveObject(DebuffFilterOptions_DebuffsTabText, nil, nil, "+", 5)
	self:keepFontStrings(DebuffFilterOptions_BuffsTab)
	if self.db.profile.TexturedTab then self:applySkin(DebuffFilterOptions_BuffsTab, nil, 0)
	else self:applySkin(DebuffFilterOptions_BuffsTab) end
	self:moveObject(DebuffFilterOptions_BuffsTabText, nil, nil, "+", 5)

-->>--	Filter Frame Backdrops
	self:applySkin(DebuffFilter_DebuffFrameBackdrop)
	self:applySkin(DebuffFilter_BuffFrameBackdrop)
	self:applySkin(DebuffFilter_PDebuffFrameBackdrop)
	self:applySkin(DebuffFilter_PBuffFrameBackdrop)
	self:applySkin(DebuffFilter_FDebuffFrameBackdrop)
	self:applySkin(DebuffFilter_FBuffFrameBackdrop)

-->>--	skin existing buttons
	local function skinDFButtons(bName)

		for i = 1, 8 do
			local obj = _G["DebuffFilter_"..bName.."Button"..i]
			if obj and not Skinner.skinned[obj] then
				Skinner:addSkinButton(obj)
			end
		end
	end

	local buttonNames = {"Debuff", "Buff", "PDebuff", "PBuff", "FDebuff", "FBuff"}
	-- skin existing buttons
	for _, v in pairs(buttonNames) do
		skinDFButtons(v)
	end
	-- hook these to skin new buttons
	for _, v in pairs(buttonNames) do
		local func = "DebuffFilter_"..v.."Frame_Update"
		self:SecureHook(func, function()
--			self:Debug(func)
			skinDFButtons(v)
		end)
	end

end
