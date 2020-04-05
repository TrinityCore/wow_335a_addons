--[[
	Side Filters
		Used for setting what types of items to show
--]]

--[[ A side filter button, switches parent filters on click ]]--

local SideFilterButton = Combuctor:NewClass('CheckButton')
do
	local id = 1
	function SideFilterButton:New(parent, reversed)
		local b = self:Bind(CreateFrame('CheckButton', 'CombuctorSideButton' .. id, parent, 'CombuctorSideTabButtonTemplate'))
		b:GetNormalTexture():SetTexCoord(0.06, 0.94, 0.06, 0.94)
		b:SetScript('OnClick', b.OnClick)
		b:SetScript('OnEnter', b.OnEnter)
		b:SetScript('OnLeave', b.OnLeave)
		b:SetReversed(reversed)

		id = id + 1
		return b
	end
end

function SideFilterButton:OnClick()
	self:GetParent():GetParent():SetCategory(self.set.name)
end

function SideFilterButton:OnEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	GameTooltip:SetText(self.set.name)
	GameTooltip:Show()
end

function SideFilterButton:OnLeave()
	GameTooltip:Hide()
end

function SideFilterButton:Set(set)
	self.set = set
	self:SetNormalTexture(set.icon)
end

function SideFilterButton:UpdateHighlight(setName)
	self:SetChecked(self.set.name == setName)
end

function SideFilterButton:SetReversed(enable)
	self.reversed = enable and true or nil

	local border = _G[self:GetName() .. 'Border']

	border:ClearAllPoints()
	if self:Reversed() then
		border:SetTexCoord(1, 0, 0, 1)
		border:SetPoint('TOPRIGHT', 3, 11)
	else
		border:SetTexCoord(0, 1, 0, 1)
		border:ClearAllPoints()
		border:SetPoint('TOPLEFT', -3, 11)
	end
end

function SideFilterButton:Reversed()
	return self.reversed
end


--[[
	Side Filter Object
--]]

local SideFilter = Combuctor:NewClass('Frame')
Combuctor.SideFilter = SideFilter

local CombuctorSets = Combuctor:GetModule('Sets')

function SideFilter:New(parent, reversed)
	local f = self:Bind(CreateFrame('Frame', nil, parent))

	--metatable magic for button creation on demand
	f.buttons = setmetatable({}, {__index = function(t, k)
		local b = SideFilterButton:New(f, f:Reversed())

		--layout the last placed button
		if k > 1 then
			b:SetPoint('TOPLEFT', t[k-1], 'BOTTOMLEFT', 0, -17)
		else
			if f:Reversed() then
				b:SetPoint('TOPRIGHT', parent, 'TOPLEFT', 10, -80)
			else
				b:SetPoint('TOPLEFT', parent, 'TOPRIGHT', -32, -65)
			end
		end

		t[k] = b
		return b
	end})

	f:SetReversed(reversed)

	return f
end

function SideFilter:UpdateFilters()
	local numFilters = 0
	local parent = self:GetParent()

	for _,set in CombuctorSets:GetParentSets() do
		if parent:HasSet(set.name) then
			numFilters = numFilters + 1
			self.buttons[numFilters]:Set(set)
		end
	end

	--show only used buttons
	if numFilters > 1 then
		for i = 1, numFilters do
			self.buttons[i]:Show()
		end

		for i = numFilters + 1, #self.buttons do
			self.buttons[i]:Hide()
		end

		self:UpdateHighlight()
		self:Show()
	--at most one filter active, hide all side buttons
	else
		self:Hide()
	end
end

function SideFilter:UpdateHighlight()
	local category = self:GetParent():GetCategory()

	for _,button in pairs(self.buttons) do
		if button:IsShown() then
			button:UpdateHighlight(category)
		end
	end
end

--layout all buttons
function SideFilter:Layout()
	if #self.buttons > 0 then
		local first = self.buttons[1]
		first:ClearAllPoints()

		if self:Reversed() then
			first:SetPoint('TOPRIGHT', self:GetParent(), 'TOPLEFT', 10, -80)
		else
			first:SetPoint('TOPLEFT', self:GetParent(), 'TOPRIGHT', -32, -65)
		end

		for i = 2, #self.buttons do
			self.buttons[i]:SetPoint('TOPLEFT', self.buttons[i-1], 'BOTTOMLEFT', 0, -17)
		end
	end
end

--[[ Switch between tabs on the left/right ]]--
function SideFilter:SetReversed(enable)
	self.reversed = enable and true or nil

	for i, button in pairs(self.buttons) do
		button:SetReversed(enable)
	end

	self:Layout()
end

function SideFilter:Reversed()
	return self.reversed
end
