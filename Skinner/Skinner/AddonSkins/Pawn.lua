if not Skinner:isAddonEnabled("Pawn") then return end

function Skinner:Pawn()

	self:applySkin(PawnUIFrame, true)
	self:moveObject(PawnUIFrame_TinyCloseButton, "+", 8, "-", 8)
	
-->>-- Scales Tab
	self:skinDropDown(PawnUIFrame_CurrentScaleDropDown)
	
	---- Stats List
	for i = 1, PawnUIScalesTabPage:GetNumChildren() do
		local child = select(i, PawnUIScalesTabPage:GetChildren())
		if child:GetName() == nil then self:applySkin(child) end
	end
	self:skinEditBox(PawnUIFrame_StatValueBox, {9})
	self:removeRegions(PawnUIFrame_StatsList)
	self:skinScrollBar(PawnUIFrame_StatsList)

-->>-- Compare Tab
	self:removeRegions(PawnUICompareScrollFrame)
	self:skinScrollBar(PawnUICompareScrollFrame)
	self:skinDropDown(PawnUIFrame_CurrentCompareScaleDropDown)
	
-->>-- Options Tab
	self:skinEditBox(PawnUIFrame_DigitsBox, {9})

-->>-- Dialog Frame
	self:applySkin(PawnUIStringDialog)
	self:skinEditBox(PawnUIStringDialog_TextBox, {9})
	
-->>-- Tabs
	for i = 1, 5 do
		local tabObj = _G["PawnUIFrameTab"..i]
		if i == 1 then
			self:moveObject(tabObj, nil, nil, "+", 1)
		elseif i == 4 then -- About Tab
		elseif i == 5 then -- Getting started Tab
			self:moveObject(tabObj, "-", 12, nil, nil)
		else
			self:moveObject(tabObj, "+", 11, nil, nil)
		end
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabObj)
			else self:setInactiveTab(tabObj) end
		else self:applySkin(tabObj) end
	end
	if self.db.profile.TexturedTab then 
		self:SecureHook("PawnUISwitchToTab", function(tabNo)
			for i = 1, 5 do
				local tabObj = _G["PawnUIFrameTab"..i]
				if i == tabNo then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
		end)
	end
	
	
	
end
