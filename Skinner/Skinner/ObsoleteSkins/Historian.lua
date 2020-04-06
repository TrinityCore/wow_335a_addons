
function Skinner:Historian()

	local MAX_TABS = 6

	HistorianFrameHeader:Hide()
	self:moveObject(HistorianFrameHeader, nil, nil, "-", 6)
	for i = 1, MAX_TABS do
		local sf = _G["HistorianTabPage"..i]
		self:removeRegions(sf)
		self:skinScrollBar(sf)
	end
	self:applySkin(HistorianTabContainer)

	-- Tabs
	for i = 1, MAX_TABS do
		local tabName = _G["HistorianTabContainerTab"..i]
		if i == 1 then
			self:moveObject(tabName, nil, nil, "+", 2)
		else
			self:moveObject(tabName, "+", 12, nil, nil)
		end
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
	end

	-- Hook this to resize the Tabs
	self:SecureHook(HistorianTabContainer, "Show", function(this)
		self:resizeTabs(HistorianTabContainer)
	end)

end
