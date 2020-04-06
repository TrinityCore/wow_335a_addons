
function Skinner:Earth()

	-- This addon is a component of Cosmos

-->>--	Hook this to change the Quest Text colour
	self:SecureHook("EarthQuestLog_Update", function(questLogName)
		for i = 1, 30 do
			local r, g, b, a = _G["PartyQuestsLogObjective"..i]:GetTextColor()
			_G["PartyQuestsLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		end
		local r, g, b, a = PartyQuestsLogRequiredMoneyText:GetTextColor()
		PartyQuestsLogRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		PartyQuestsLogRewardTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
		PartyQuestsLogItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		PartyQuestsLogItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)

-->>--	DropDown Menus
	self:SecureHook("EarthMenu_ToggleDropDownMenu", function()
--		self:Debug("EM_TDDM")
		self:applySkin(EarthDropDownList1Backdrop)
		self:applySkin(EarthDropDownList1MenuBackdrop)
		self:applySkin(EarthDropDownList2Backdrop)
		self:applySkin(EarthDropDownList2MenuBackdrop)
		self:applySkin(EarthDropDownList3Backdrop)
		self:applySkin(EarthDropDownList3MenuBackdrop)
	end)

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then EarthTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(EarthTooltip, "OnShow", function(this)
--			self:Debug("ET_OS: [%s]", this:GetName())
			self:skinTooltip(EarthTooltip)
		end)
	end

end
