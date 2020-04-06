if not Skinner:isAddonEnabled("Clique") then return end

function Skinner:Clique()
	if not self.db.profile.SpellBookFrame then return end

	local function skinClique()

		CliqueFrame.headerLeft:Hide()
		CliqueFrame.headerRight:Hide()
		CliqueFrame.header:Hide()
		Skinner:keepFontStrings(CliqueFrame)
		Skinner:moveObject(CliqueFrame, "+", 25, "-", 25)
		Skinner:moveObject(CliqueButtonClose, "+", 4, "-", 4, CliqueFrame)
		Skinner:skinDropDown(CliqueDropDown)
		Skinner:keepFontStrings(CliqueListScroll)
		Skinner:skinScrollBar(CliqueListScroll)
		Skinner:applySkin(CliqueFrame)

-->>--	TextList Frame
		CliqueTextListFrame.headerLeft:Hide()
		CliqueTextListFrame.headerRight:Hide()
		CliqueTextListFrame.header:Hide()
		Skinner:moveObject(CliqueTextButtonClose, "+", 4, "-", 4, CliqueTextListFrame)
		Skinner:keepFontStrings(CliqueTextListFrame)
		Skinner:applySkin(CliqueTextListFrame)
		Skinner:keepFontStrings(CliqueTextListScroll)
		Skinner:skinScrollBar(CliqueTextListScroll)

-->>--	CustomEdit Frame
		CliqueCustomFrame.headerLeft:Hide()
		CliqueCustomFrame.headerRight:Hide()
		CliqueCustomFrame.header:Hide()
		Skinner:keepFontStrings(CliqueCustomFrame)
		Skinner:applySkin(CliqueCustomFrame)
		CliqueCustomArg1:SetMultiLine(false)
		Skinner:skinEditBox(CliqueCustomArg1, {9})
		Skinner:skinEditBox(CliqueCustomArg2, {9})
		Skinner:skinEditBox(CliqueCustomArg3, {9})
		Skinner:skinEditBox(CliqueCustomArg4, {9})
		Skinner:skinEditBox(CliqueCustomArg5, {9})
		Skinner:keepFontStrings(CliqueMultiScrollFrame)
		Skinner:skinScrollBar(CliqueMultiScrollFrame)

-->>--	IconSelect Frame
		CliqueIconSelectFrame.headerLeft:Hide()
		CliqueIconSelectFrame.headerRight:Hide()
		CliqueIconSelectFrame.header:Hide()
		Skinner:keepFontStrings(CliqueIconSelectFrame)
		Skinner:applySkin(CliqueIconSelectFrame)
		Skinner:keepFontStrings(CliqueIconScrollFrame)
		Skinner:skinScrollBar(CliqueIconScrollFrame)

	end

	self:SecureHook(Clique, "CreateOptionsFrame", function()
		skinClique()
		Skinner:Unhook(Clique, "CreateOptionsFrame")
	end)

	self:removeRegions(CliquePulloutTab, {1})
	CliquePulloutTab:SetWidth(CliquePulloutTab:GetWidth() * 1.25)
	CliquePulloutTab:SetHeight(CliquePulloutTab:GetHeight() * 1.25)
	if self.db.profile.TexturedTab then self:applySkin(CliquePulloutTab, nil, 0) else self:applySkin(CliquePulloutTab) end

end
