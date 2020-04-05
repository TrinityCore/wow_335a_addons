--[[
	Tab Filters
		Used to filter within categories
--]]

local BottomTab = Combuctor:NewClass('Button')
local CombuctorSets = Combuctor:GetModule('Sets')

function BottomTab:New(parent, id)
	local tab = self:Bind(CreateFrame('Button', parent:GetName() .. 'Tab' .. id, parent, 'CombuctorFrameTabButtonTemplate'))
	tab:SetScript('OnClick', self.OnClick)
	tab:SetID(id)

	return tab
end

function BottomTab:OnClick()
	local frame = self:GetParent():GetParent()
	if frame.selectedTab ~= self:GetID() then
		PlaySound('igCharacterInfoTab')
	end

	frame:SetSubCategory(self.set.name)
end

function BottomTab:Set(set)
	self.set = set
	if set.icon then
		self:SetFormattedText('|T%s:%d|t %s', set.icon, 16, set.name)
	else
		self:SetText(set.name)
	end

	PanelTemplates_TabResize(self, 0)
	self:GetHighlightTexture():SetWidth(self:GetTextWidth() + 30)
end

function BottomTab:UpdateHighlight(setName)
	if self.set.name == setName then
		PanelTemplates_SetTab(self:GetParent(), self:GetID())
	end
end


--[[
	BottomTab Object
--]]


--[[
	Side Filter Object
--]]

local BottomFilter = Combuctor:NewClass('Frame')
Combuctor.BottomFilter = BottomFilter

function BottomFilter:New(parent)
	local f = self:Bind(CreateFrame('Frame', parent:GetName() .. 'BottomFilter', parent))

	--metatable magic for button creation on demand
	f.buttons = setmetatable({}, {__index = function(t, k)
		local tab = BottomTab:New(f, k)

		if k > 1 then
			tab:SetPoint('LEFT', f.buttons[k-1], 'RIGHT', -16, 0)
		else
			tab:SetPoint('CENTER', parent, 'BOTTOMLEFT', 60, 46)
		end

		t[k] = tab
		return tab
	end})

	return f
end

function BottomFilter:UpdateFilters()
	local numFilters = 0
	local parent = self:GetParent()

	for _,set in CombuctorSets:GetChildSets(parent:GetCategory()) do
		if parent:HasSubSet(set.name, set.parent) then
			numFilters = numFilters + 1
			self.buttons[numFilters]:Set(set)
		end
	end

	--show only used tabs
	if numFilters > 1 then
		for i = 1, numFilters do
			self.buttons[i]:Show()
		end

		for i = numFilters + 1, #self.buttons do
			self.buttons[i]:Hide()
		end

		PanelTemplates_SetNumTabs(self, numFilters)
		self:UpdateHighlight()
		self:Show()
	--at most one filter active, hide all tabs
	else
		PanelTemplates_SetNumTabs(self, 0)
		self:Hide()
	end
	self:GetParent():UpdateClampInsets()
end

function BottomFilter:UpdateHighlight()
	local category = self:GetParent():GetSubCategory()

	for _,button in pairs(self.buttons) do
		if button:IsShown() then
			button:UpdateHighlight(category)
		end
	end
end