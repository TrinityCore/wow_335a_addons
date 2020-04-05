local revision = tonumber(string.sub("$Revision: 151 $", 12, -3)) or 1
if revision > ElkBuffBars.revision then ElkBuffBars.revision = revision end

local _G = getfenv(0)
local Dewdrop = AceLibrary("Dewdrop-2.0")

local ipairs				= _G.ipairs
local pairs					= _G.pairs

local table_insert			= _G.table.insert
local table_remove			= _G.table.remove
local table_sort			= _G.table.sort

local DEMO_BUFF = {
	id				= -1,
	name			= "Blessing of Demonstration",
	realname		= "Blessing of Demonstration",
	rank			= 23,
	type			= "FAKE",
	realtype		= "FAKE",
	debufftype		= nil,
	timeleft		= 817,
	timemax			= 1200,
	untilcancelled	= nil,
	charges			= 5,
	maxcharges		= 5,
	icon			= "Interface\\Icons\\INV_Misc_QuestionMark",
}
EBB_BarGroup = AceLibrary("AceOO-2.0").Class()
local EBB_BarGroup = EBB_BarGroup
local ElkBuffBars

function EBB_BarGroup.prototype:init(arg)
	EBB_BarGroup.super.prototype.init(self)
	if not ElkBuffBars then ElkBuffBars = _G.ElkBuffBars end
	self.bars = {}
	self.data = {}
	self.frames = {}
	if not self.frames.container then
		self.frames.container = CreateFrame("button", nil, UIParent)
		self.frames.container:SetFrameStrata("BACKGROUND")
		self.frames.container:SetMovable(true)
		self.frames.container:SetClampedToScreen(true)
	end
end

function EBB_BarGroup.prototype:Reset()
	self.frames.container:ClearAllPoints()
	self.frames.container:Hide()
	for k, v in pairs(self.bars) do
		ElkBuffBars:RecycleBar(v)
		self.bars[k] = nil
	end

	local data = self.data
	for k in pairs(data) do
		data[k] = nil
	end

	self.layout = nil
end

function EBB_BarGroup.prototype:GetContainer()
	return self.frames.container
end

function EBB_BarGroup.prototype:SetLayout(layout)
	if layout then
		self.layout = layout
	else
		layout = self.layout
		if not layout then
			return
		end
	end
	for _, bar in ipairs(self.bars) do
		bar:UpdateLayout(layout.bars)
	end
	if layout.bars.clickthrough then
		self.frames.container:EnableMouse(false)
	else
		self.frames.container:EnableMouse(true)
	end
	self.frames.container:SetAlpha(layout.alpha)
	self.frames.container:SetScale(layout.scale)
	self:ToggleAnchor(layout.anchorshown)
	self:UpdateBarPositions()
end

function EBB_BarGroup.prototype:SetPosition()
	local layout = self.layout
	self.frames.container:ClearAllPoints()
	if layout.stickto then
		self.frames.container:SetPoint((layout.growup and "BOTTOM" or "TOP")..(layout.stickside or ""), ElkBuffBars.bargroups[layout.stickto]:GetContainer(), (layout.growup and "TOP" or "BOTTOM")..(layout.stickside or ""), 0, layout.growup and ElkBuffBars.db.profile.groupspacing or -ElkBuffBars.db.profile.groupspacing)
	elseif layout.x and layout.y then
		self.frames.container:SetPoint(layout.growup and "BOTTOMLEFT" or "TOPLEFT", UIParent, "BOTTOMLEFT", layout.x, layout.y)
	else
		self.frames.container:SetPoint("CENTER", UIParent, "CENTER")
		self:ToggleAnchor(true)
	end
end

function EBB_BarGroup.prototype:ToggleAnchor(show)
	if show == nil then
		show = not self.layout.anchorshown
	end
	if show then
		if not self.frames.anchor then
			self.frames.anchor = CreateFrame("Button", nil, self.frames.container)
			self.frames.anchor:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
											edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
											tile = false, tileSize = 16, edgeSize = 16,
											insets = { left = 5, right =5, top = 5, bottom = 5 }})
			self.frames.anchor:SetHeight(25)
			self.frames.anchortext = self.frames.anchor:CreateFontString(nil, "OVERLAY")
			self.frames.anchortext:SetFontObject(GameFontNormalSmall)
			self.frames.anchortext:ClearAllPoints()
			self.frames.anchortext:SetTextColor(1, 1, 1, 1)
			self.frames.anchortext:SetPoint("CENTER", self.frames.anchor, "CENTER")
			self.frames.anchortext:SetJustifyH("CENTER")
			self.frames.anchortext:SetJustifyV("MIDDLE")

			self.frames.anchor.bargroup = self
			self.frames.anchor:RegisterForDrag("LeftButton")
			self.frames.anchor:SetScript("OnDragStart", function(this) this.bargroup:StartMoving() end )
			self.frames.anchor:SetScript("OnDragStop", function(this) this.bargroup:StopMoving() end )

			self.frames.anchor:RegisterForClicks("LeftButtonUp", "RightButtonUp")
			self.frames.anchor:SetScript("OnClick", function(this, button) this.bargroup:OnClick(button) end )
		end
		self.frames.anchor:SetWidth(self.layout.bars.width)
		self.frames.anchor:SetBackdropColor(self.layout.bars.barcolor[1], self.layout.bars.barcolor[2], self.layout.bars.barcolor[3], .5)
		self.frames.anchortext:SetText(self.layout.anchortext)
		self.frames.anchor:Show()
		self.layout.anchorshown = true
	else
		if self.frames.anchor then
			self.frames.anchor:Hide()
		end
		self.layout.anchorshown = false
	end
	self:UpdateData()
end

function EBB_BarGroup.prototype:StartMoving()
	self.frames.container:StartMoving()
end

function EBB_BarGroup.prototype:StopMoving()
	self.frames.container:StopMovingOrSizing()
	self.frames.container:SetUserPlaced(false) -- don't save in frame cache
	if not ElkBuffBars:StickGroup(self) then
		self.layout.x = self.frames.container:GetLeft()
		self.layout.y = self.layout.growup and self.frames.container:GetBottom() or self.frames.container:GetTop()
		self.frames.container:ClearAllPoints()
		self.frames.container:SetPoint(self.layout.growup and "BOTTOMLEFT" or "TOPLEFT", UIParent, "BOTTOMLEFT", self.layout.x, self.layout.y)
	end
end

function EBB_BarGroup.prototype:OnClick(button)
	if button == "LeftButton" then
		if IsAltKeyDown() then
			self:ToggleAnchor()
		end
	elseif button == "RightButton" then
		self:ShowMenu()
	end
end

function EBB_BarGroup.prototype:ShowMenu()
	Dewdrop:Open(self.frames.anchor, "children", ElkBuffBars:GetGroupOptions(self.layout.id))
end

-- updates position of bars (+ anchor) inside the container; sets container height
function EBB_BarGroup.prototype:UpdateBarPositions()
	local lastframe
	local height = 0
	if self.layout.anchorshown then
		self:UpdateBarPosition(self.frames.anchor, lastframe)
		lastframe = self.frames.anchor
		height = height + 25
	end
	for _, bar in pairs(self.bars) do
		if height > 0 then height = height + self.layout.barspacing end
		self:UpdateBarPosition(bar:GetContainer(), lastframe)
		height = height + self.layout.bars.height
		lastframe = bar:GetContainer()
	end
	if height < 1 then height = 1 end -- add some height for empty groups in order to have them work ad relative anchors
	self.frames.container:SetHeight(height)
	self.frames.container:SetWidth(self.layout.bars.width)
end

-- update the position of 'frame'; anchors it to 'relframe' if given
function EBB_BarGroup.prototype:UpdateBarPosition(frame, relframe)
	local growup = self.layout.growup
	frame:ClearAllPoints()
	if not relframe then
		frame:SetPoint(growup and "BOTTOM" or "TOP", self.frames.container, growup and "BOTTOM" or "TOP")
	else
		frame:SetPoint(growup and "BOTTOM" or "TOP", relframe, growup and "TOP" or "BOTTOM", 0, growup and self.layout.barspacing or -self.layout.barspacing)
	end
end

local sorting = {
	name = function(a, b)
			return a.name < b.name
		end,
	timeleft = function(a, b)
			if a.untilcancelled then
				if b.untilcancelled then
					return a.name < b.name
				else
					return true
				end
			elseif b.untilcancelled then
				return false
			end
			if a.expirytime < b.expirytime then
				return false
			elseif a.expirytime > b.expirytime then
				return true
			else
				return a.name < b.name
			end
		end,
	timemax = function(a, b)
			if a.untilcancelled then
				if b.untilcancelled then
					return a.name < b.name
				else
					return true
				end
			elseif b.untilcancelled then
				return false
			end
			if a.timemax < b.timemax then
				return false
			elseif a.timemax > b.timemax then
				return true
			else
				return a.name < b.name
			end
		end,
}

-- creates data for which bars will be created
function EBB_BarGroup.prototype:UpdateData(updated)
	if updated and not updated[self.layout.target] then return end
	local layout = self.layout
	local data = self.data
	for k in pairs(data) do
		data[k] = nil
	end

	for _, v in pairs(ElkBuffBars.buffdata[layout.target]) do
		if self:CheckFilter(v) then
			table_insert(data, v)
		end
	end
	for _, v in pairs(ElkBuffBars.debuffdata[layout.target]) do
		if self:CheckFilter(v) then
			table_insert(data, v)
		end
	end
	if layout.target == "player" then
		for _, v in pairs(ElkBuffBars.tenchdata) do
			if self:CheckFilter(v) then
				table_insert(data, v)
			end
		end
		for _, v in pairs(ElkBuffBars.trackingdata) do
			if self:CheckFilter(v) then
				table_insert(data, v)
			end
		end
	end

	if self.layout.anchorshown and #data < 1 then
		table_insert(data, DEMO_BUFF)
	end
	if sorting[self.layout.sorting] then
		table_sort(data, sorting[self.layout.sorting])
	end
	self:UpdateBars()
end

-- creates bars from data
function EBB_BarGroup.prototype:UpdateBars()
	local bars = self.bars

	local i = 1
	while i <= #self.data do
		if i > #bars then
			table_insert(bars, ElkBuffBars:GetBar())
			bars[i]:UpdateLayout(self.layout.bars)
			bars[i]:SetParent(self)
		end
		bars[i]:UpdateData(self.data[i])
		i = i + 1
	end
	while i <= #bars do
		ElkBuffBars:RecycleBar(table_remove(bars, #bars))
	end
	self:UpdateBarPositions()
	for _, bar in pairs(bars) do
		bar:GetContainer():Show()
	end
end

-- orders the bars to update the texts shown
function EBB_BarGroup.prototype:UpdateText()
	for _, bar in ipairs(self.bars) do
		bar:UpdateText()
	end
end

-- orders the bars to update the time shown
function EBB_BarGroup.prototype:UpdateTimeleft()
	for _, bar in ipairs(self.bars) do
		bar:UpdateTimeleft()
	end
end

-- checks for various filter settings
function EBB_BarGroup.prototype:CheckFilter(data)
	if not self.layout then
		return false
	end

	local filter = self.layout.filter

	if	   (not filter.type[data.type])																								-- type
		or (filter.selfcast and ((filter.selfcast == "blacklist" and data.ismine) or (filter.selfcast == "whitelist" and not data.ismine)))
		or (not data.untilcancelled and filter.timemax_min and data.timemax < filter.timemax_min)									-- min timemax
		or (not data.untilcancelled and filter.timemax_max and data.timemax > filter.timemax_max)									-- max timemax
		or (filter.untilcancelled and ((filter.untilcancelled == "only" and not data.untilcancelled) or (filter.untilcancelled == "hide" and data.untilcancelled)))
		or (filter.names_include and not (filter.names_include[data.type] and filter.names_include[data.type][data.realname]))		-- show by name
		or (filter.names_exclude and filter.names_exclude[data.type] and filter.names_exclude[data.type][data.realname])			-- hide by name
		or (filter.charges_min and data.charges < filter.charges_min)																-- min charges
		or (filter.charges_max and data.charges > filter.charges_max)																-- max charges
		then return false end

	return true
end
