local _G = getfenv(0)

function Skinner:PoliteWhisper()

	self:keepRegions(PoliteWhisper_Frame, {11})
	self:moveObject(self:getRegion(PoliteWhisper_Frame, 11), nil, nil, "-", 4)
	self:applySkin(PoliteWhisper_Frame, true)

-->>--	PW Dungeon
	self:skinEditBox(PoliteWhisper_Dungeon)
	self:moveObject(PoliteWhisper_Dungeon, "-", 4, "+", 4)
	self:keepRegions(PoliteWhisper_DungeonDrop, {4,5}) -- N.B. regions 4 & 5 are text
	self:skinEditBox(PoliteWhisper_MinLevel)
	self:moveObject(PoliteWhisper_MinLevel, "-", 4, "+", 3)
	self:skinEditBox(PoliteWhisper_MaxLevel)
	self:moveObject(PoliteWhisper_MaxLevel, "-", 4, "+", 3)
	PoliteWhisper_FinderDr:Hide()
	self:keepRegions(PoliteWhisper_DruidDrop, {4,5}) -- N.B. regions 4 & 5 are text
	PoliteWhisper_FinderH:Hide()
	self:keepRegions(PoliteWhisper_HunterDrop, {4,5}) -- N.B. regions 4 & 5 are text
	PoliteWhisper_FinderPa:Hide()
	self:keepRegions(PoliteWhisper_PaladinDrop, {4,5}) -- N.B. regions 4 & 5 are text
	PoliteWhisper_FinderPr:Hide()
	self:keepRegions(PoliteWhisper_PriestDrop, {4,5}) -- N.B. regions 4 & 5 are text
	PoliteWhisper_FinderS:Hide()
	self:keepRegions(PoliteWhisper_ShamanDrop, {4,5}) -- N.B. regions 4 & 5 are text
	PoliteWhisper_FinderW:Hide()
	self:keepRegions(PoliteWhisper_WarriorDrop, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(PoliteWhisper_OtherDrop, {4,5}) -- N.B. regions 4 & 5 are text
	self:skinEditBox(PoliteWhisper_Ignore)
	self:skinEditBox(PoliteWhisper_Notes)

-->>--	PW Party
	self:skinEditBox(PoliteWhisper_Notes1)
	self:skinEditBox(PoliteWhisper_Notes2)
	self:skinEditBox(PoliteWhisper_Notes3)
	self:skinEditBox(PoliteWhisper_Notes4)

	--Tabs
	for	i =1, 4 do
		local tabName = _G["PoliteWhisper_FrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		if i == 1 then
			self:setActiveTab(tabName)
			self:moveObject(tabName, "-", 10, "+", 2)
		else
			self:setInactiveTab(tabName)
			self:moveObject(tabName, "+", 11, nil, nil)
		end
	end

	self:SecureHook("PoliteWhisper_GoTab", function(num)
		for	i =1, 4 do
			local tabName = _G["PoliteWhisper_FrameTab"..i]
			if not self.skinned[tabName] then
				tabName:SetWidth(tabName:GetWidth() - 20)
			end
			if i == num then
				self:setActiveTab(tabName)
			else
				self:setInactiveTab(tabName)
			end
		end
	end)

end
