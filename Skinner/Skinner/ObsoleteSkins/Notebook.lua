
function Skinner:Notebook()

	NotebookFrame:SetWidth(NotebookFrame:GetWidth() * self.FxMult)
	NotebookFrame:SetHeight(NotebookFrame:GetHeight() * self.FyMult)
	self:keepRegions(NotebookFrameDragFrame, {})
	self:moveObject(NotebookFrameTitleText, nil, nil, "+", 6)
	self:moveObject(NotebookFrameCloseX, "+", 28, "+", 8)
	self:moveObject(NotebookFrameNewButton, nil, nil, "+", 16)
	self:moveObject(NotebookListFrame, "-", 10, "+", 20)
	NotebookListFrame:SetWidth(NotebookListFrame:GetWidth() + 10)
	NotebookListFrame:SetHeight(NotebookListFrame:GetHeight() + 10)
	self:moveObject(NotebookListFrameButton1, "+", 3, "-", 3)
	self:keepRegions(NotebookListFrame, {})
	self:applySkin(NotebookListFrame, nil)
	self:keepRegions(NotebookListFrameScrollFrame, {})
	self:skinScrollBar(NotebookListFrameScrollFrame)
	self:moveObject(NotebookListFrameScrollFrame, "+", 6, "-", 4)
	self:keepRegions(NotebookDropDown, {4})
	NotebookDescriptionFrame:SetWidth(NotebookListFrame:GetWidth())
	NotebookDescriptionFrame:SetHeight(NotebookDescriptionFrame:GetHeight() + 15)
	self:moveObject(NotebookDescriptionFrame, "-", 10, "+", 25)
	self:keepRegions(NotebookDescriptionFrame, {})
	self:applySkin(NotebookDescriptionFrame)
	self:keepRegions(NotebookFrameEditScrollFrame, {})
	self:skinScrollBar(NotebookFrameEditScrollFrame)
	self:moveObject(NotebookFrameEditScrollFrame, "+", 6, "-", 8)
	self:keepRegions(NotebookFrameEditScrollFrameChildFrame, {})
	self:keepRegions(NotebookFrameTextScrollFrame, {})
	self:skinScrollBar(NotebookFrameTextScrollFrame)
	self:keepRegions(NotebookFrameTextScrollFrameChildFrame, {1})
	self:keepRegions(NotebookFrameCanSend, {1})
	self:moveObject(NotebookFrameCloseButton, "+", 20, "-", 70)
	self:moveObject(NotebookFrameSaveButton, nil, nil, "-", 70)
	self:keepRegions(NotebookFrame, {6})
	self:applySkin(NotebookFrame, nil)

-->>--	Tabs
	self:keepRegions(NotebookFrameFilterTab1, {7,8})
	self:keepRegions(NotebookFrameFilterTab2, {7,8})
	self:keepRegions(NotebookFrameFilterTab3, {7,8})
	for i = 1, 3 do
		local tabName = _G["NotebookFrameFilterTab"..i]
		if i == 1 then self:moveObject(tabName, "-", 40, "+", 10) end
		self:moveObject(_G[tabName:GetName().."Text"], nil, nil, "+", 5)
		self:moveObject(_G[tabName:GetName().."HighlightTexture"], "-", 2, "+", 7)
	end
	if self.db.profile.TexturedTab then
		for i = 1, 3 do
			local tabName = _G["NotebookFrameFilterTab"..i]
			self:applySkin(tabName, nil, 0)
			if i == 1 then
				self:setActiveTab(tabName)
			else
				self:setInactiveTab(tabName)
			end
		end
		self:SecureHook("NotebookFrame_TabButtonOnClick", function(id)
			if not id then id = this:GetID() end
			for i = 1, 3 do
				local tabName = _G["NotebookFrameFilterTab"..i]
				if i == id then
					self:setActiveTab(tabName)
				else
					self:setInactiveTab(tabName)
				end
			end
		end)
	else
		self:applySkin(NotebookFrameFilterTab1)
		self:applySkin(NotebookFrameFilterTab2)
		self:applySkin(NotebookFrameFilterTab3)
	end

end
