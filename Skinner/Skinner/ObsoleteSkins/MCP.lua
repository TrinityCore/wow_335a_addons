
function Skinner:MCP()
	if self.initialized.MCP then return end
	self.initialized.MCP = true

	if not self:isVersion("MCP", { "2006.07.22", "2006.08.28", "2006.09.06", "2006.12.16", "Version 2.0" }, MCP_VERSION) then return end

	if MCPAddonSetDropDown then
		-- Rophy's version on the SVN
		self:keepRegions(MCPAddonSetDropDown, {4,5}) -- N.B. regions 4 & 5 are text
		self:moveObject(MCPAddonSetDropDown, nil, nil, "-", 13)
		self:moveObject(MCP_AddonListDisableAll, nil, nil, nil, nil)
		self:moveObject(MCP_AddonListEnableAll, nil, nil, nil, nil)
		self:moveObject(MCP_AddonListSaveSet, nil, nil, "-", 10)
		self:moveObject(MCP_AddonList_ReloadUI, nil, nil, "-", 10)
	else
		-- standard version from Curse
		self:keepRegions(MCP_AddonList_ProfileSelection, {4,5}) -- N.B. regions 4 & 5 are text
		self:moveObject(MCP_AddonList_ProfileSelection, nil, nil, "-", 13)
		self:moveObject(MCP_AddonList_EnableAll, "+", 30, "+", 5)
		self:moveObject(MCP_AddonList_DisableAll, "+", 30, "+", 5)
		self:moveObject(MCP_AddonList_SaveProfile, "+", 40, "-", 10)
		self:moveObject(MCP_AddonList_DeleteProfile, "+", 40, "-", 10)
		self:moveObject(MCP_AddonList_ReloadUI, "+", 30, "+", 5)
	end

	-- change the scale to match other frames
	MCP_AddonList:SetScale(GameMenuFrame:GetEffectiveScale())

	self:keepRegions(MCP_AddonList, {8}) -- N.B. region 8 is the title
	MCP_AddonList:SetWidth(MCP_AddonList:GetWidth() * self.FxMult)
	MCP_AddonList:SetHeight(MCP_AddonList:GetHeight() * self.FyMult)

	-- resize the frame's children to match the frame size
	for i = 1, select("#", MCP_AddonList:GetChildren()) do
		local v = select(i, MCP_AddonList:GetChildren())
		v:SetWidth(v:GetWidth() * self.FxMult)
		v:SetHeight(v:GetHeight() * self.FyMult)
	end

	self:moveObject(MCP_AddonListCloseButton, "+", 40, nil, nil)
	self:moveObject(MCP_AddonListEntry1, nil, nil, "+", 10)
	self:removeRegions(MCP_AddonList_ScrollFrame)
	self:moveObject(MCP_AddonList_ScrollFrame, "+", 26, "+", 7)
	MCP_AddonList_ScrollFrame:SetHeight(MCP_AddonList_ScrollFrame:GetHeight() + 10)
	self:skinScrollBar(MCP_AddonList_ScrollFrame)

	self:applySkin(MCP_AddonList, true)

end
