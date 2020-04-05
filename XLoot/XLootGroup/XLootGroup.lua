local L = AceLibrary("AceLocale-2.2"):new("XLootGroup")
local XL = AceLibrary("AceLocale-2.2"):new("XLoot")

XLootGroup = XLoot:NewModule("XLootGroup")

XLootGroup.dewdrop = AceLibrary("Dewdrop-2.0")

local AA = AceLibrary("AnchorsAway-1.0")
XLootGroup.AA = AA

local _G = getfenv(0)

XLootGroup.revision  = tonumber((string.gsub("$Revision: 61 $", "^%$Revision: (%d+) %$$", "%1")))

function XLootGroup:OnInitialize()
	self.db = XLoot:AcquireDBNamespace("XLootGroupDB")
	self.defaults = {
		extra = false,
		buttonscale = 24,
		nametrunc = 15,
		lockbop = false,
		faderows = true,
		showrolls = true,
	}
	XLoot:RegisterDefaults("XLootGroupDB", "profile", self.defaults)
end

function XLootGroup:OpenMenu(frame)
	self.dewdrop:Open(frame,
		'children', function(level, value)
				self.dewdrop:FeedAceOptionsTable(self.fullopts)
			end,
		'cursorX', true,
		'cursorY', true
	)
end

function XLootGroup:OnEnable()
	local db = self.db.profile
	UIParent:UnregisterEvent("START_LOOT_ROLL")
	UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")
	self:RegisterEvent("START_LOOT_ROLL", "AddGroupLoot")
	self:RegisterEvent("CANCEL_LOOT_ROLL", "CancelGroupLoot")
	self:RegisterEvent("SpecialEvents_RollSelected", "RollSelect")
	
	if not AA.stacks.roll then
		local stack = AA:NewAnchor("roll", "Loot Rolls", "Interface\\Buttons\\UI-GroupLoot-Dice-Up", db, self.dewdrop, nil, 'add')
		XLoot:Skin(stack.frame)
		stack.SizeRow = XLoot.SizeRow
		stack.BuildRow = self.GroupBuildRow
		stack.opts.threshold = nil
		stack.opts.timeout = nil
		stack.opts.extra = { 
			type = "toggle", 
			name = L["Show countdown text"], 
			desc = L["Show small text beside the item indicating how much time remains"], 
			get = function() if db.extra == nil then db.extra = true end return db.extra end,
			set = function(v) db.extra = v if v and db.showrolls then db.showrolls = false end end,
			order = 18 
		}
		stack.opts.showrolls = {
			type = "toggle", 
			name = L["Show current rolls"], 
			desc = L["Show small text beside the item indicating how many have chosen what to roll"], 
			get = function() return db.showrolls end,
			set = function(v) db.showrolls = v if v and db.extra then db.extra = false end end,
			order = 19
		}
		stack.opts.faderows = { 
			type = "toggle", 
			name = L["Fade out rows"], 
			desc = L["Smoothly fade rows out once rolled on."], 
			get = function() if db.faderows == nil then db.faderows = true end return db.faderows end,
			set = function(v) db.faderows = v end,
			order = 21
		}
		stack.opts.buttonsize = {
			type = "range",
			name = L["Roll button size"],
			desc = L["Size of the Need, Greed, Disenchant and Pass buttons"], -- 3.3 added Disenchant
			get = function() return db.buttonscale end,
			set = function(v) db.buttonscale = v; XLootGroup:ResizeButtons() end,
			min = 10,
			max = 36,
			step = 1,
			order = 22
		}
		stack.opts.trunc = {
			type = "range",
			name = L["Trim item names to..."],
			desc = L["Length in characters to trim item names to"],
			get = function() return db.nametrunc end,
			set = function(v) db.nametrunc = v end,
			min = 4,
			max = 100,
			step = 2,
			order = 23
		}
		stack.opts.lockbop = {
			type = "toggle",
			name = L["Prevent rolls on BoP items"],
			desc = L["Locks the Need and Greed buttons for any BoP items"],
			get = function() return db.lockbop end,
			set = function(v) db.lockbop = v end,
			order = 24
		}
		local stackdb = AA.stacks.roll.db
		stackdb.timeout = 10000
		stackdb.threshold = 10000
		stack.clear = function(row)
			row.rollID = nil
			row.rollTime = nil
			row.timeout = nil
			row.link = nil
			row.name = nil
			row.clicked = nil
			row.high = nil
			row.need = 0
			row.greed = 0
			row.dis = 0 -- patch 3.3
			row.pass = 0
		end
		
		if not XLoot.opts.args.pluginspacer then
			XLoot.opts.args.pluginspacer = {
				type = "header",
				order = 85
			}
		end
		
		XLoot.opts.args.group =  {
			name = "|cFF44EE66"..L["XLoot Group"],
			desc = L["A stack of frames for showing group loot information"],
			icon = "Interface\\Buttons\\UI-GroupLoot-Dice-Up",
			type = "group",
			order = 87,
			args = stack.opts
		}
	end
end

function XLootGroup:OnDisable()
	self:UnregisterAllEvents()
	UIParent:RegisterEvent("START_LOOT_ROLL")
	UIParent:RegisterEvent("CANCEL_LOOT_ROLL")
end

function XLootGroup:ResizeButtons()
	local size = self.db.profile.buttonscale
	for _, row in pairs(AA.stacks.roll.rows) do
		row.bgreed:SetWidth(size)
		row.bgreed:SetHeight(size)
		row.bneed:SetWidth(size)
		row.bneed:SetHeight(size)
		row.bpass:SetWidth(size)
		row.bpass:SetHeight(size)
		XLoot:SizeRow(nil, row)
	end
end

XLootGroup.rollbuttons = { 'bneed', 'bgreed', 'bdis', 'bpass' } -- patch 3.3 'bdis' added
function XLootGroup:AddGroupLoot(item, time)
	local stack = AA.stacks.roll
	local row = AA:AddRow(stack)
	row.rollID = item
	row.rollTime = time
	row.timeout = time
	row.link = GetLootRollItemLink(item)
	row.status:SetMinMaxValues(0, time)
	local texture, name, count, quality, bop, cneed, cgreed, cdis = GetLootRollItemInfo(item) -- patch 3.3 'canNeed,canGreed,canDis' params added
	XLoot:SetBindText(XLoot:GetBindOn(row.link), row.fsbind)
	row.bind = bind
	local length = self.db.profile.nametrunc
	if string.len(name) > length then
		name = string.sub(name, 1, length)..".."
	end
	row.name = ("%s%s%s|r"):format(select(4, GetItemQualityColor(quality)), count>1 and count.."x " or "", name)
	SetItemButtonTexture(row.button, texture)
	row.fsloot:SetText(row.name)
	row:SetScript("OnUpdate", self:RollUpdateClosure(item, time, row, stack, id))
	for k, v in pairs(XLootGroup.rollbuttons) do
		local b = row[v]
		UIFrameFadeRemoveFrame(b)
		b.fadeInfo = nil
		b:Show()
		if v=='bpass' or (v=='bneed' and cneed) or (v=='bgreed' and cgreed) or (v=='bdis' and cdis) then
			b:Enable()
			SetDesaturation(b:GetNormalTexture(), false);
		else
			b:Disable()
			SetDesaturation(b:GetNormalTexture(), true);
		end
		b:SetAlpha(1)
	end
	XLoot:QualityColorRow(row, quality)
	XLoot:SizeRow(stack, row)
end

function XLootGroup:RollUpdateClosure(item, time, row, stack, id)
	local width, lastleft, niltext
	return function()
		if not width then
			width = row.status:GetWidth()
		end
		local left = GetLootRollTimeLeft(item)
		if left <= 0 then 
			row:Hide()
			AA:PopRow(AA.stacks.roll, row.id, nil, nil, 0)
			return nil
		end
		if not lastleft then lastleft = left
		elseif lastleft < left then return nil end
		left = math.max(0, math.min(left, time))
		row.status:SetValue(left)
		if self.db.profile.extra then
			row.fsextra:SetText(string.format("%.f ", left/1000))
			niltext = false
		elseif not niltext then
			row.fsextra:SetText("")
			niltext = true
		end
		local point = width*(left/time)+1
		return row.status.spark:SetPoint("CENTER", row.status, "LEFT", point, 0)
	end
end

function XLootGroup:CancelGroupLoot(id, timeout)
	 for k, row in ipairs(AA.stacks.roll.rowstack) do
	 	if row.rollID == id then
			row:SetScript("OnUpdate", nil)
			row.fsextra:SetText("")
			if self.db.profile.faderows then
				AA:PopRow(AA.stacks.roll, row.id, nil, nil, 5)
				for i, v in pairs(XLootGroup.rollbuttons) do
					row[v]:Disable()
					if v ~= row.clicked then
						local rowt = row[v]
						UIFrameFadeOut(rowt, 1, 1, 0)
						rowt.fadeInfo.finishedFunc = function() rowt:Hide()  end
						rowt.fadeInfo.fadeHoldTime = 5
					end
				end
			else
				row:Hide()
				AA:PopRow(AA.stacks.roll, row.id, nil, nil, 0)
			end
	 	end
	 end
end

local function GetRoll(item)
	for k, row in ipairs(AA.stacks.roll.rowstack) do
		if row.link == item then
			return row
		end
	end
	return nil
end

local function ClickRoll(row, which, id)
	if which == 'bpass' or not (XLootGroup.db.profile.lockbop and row.bind == 'pickup') then
		row.clicked = which
		RollOnLoot(row.rollID, id)
	end
end

-- Group loot - Roll made (Need - x, Greed - x, Dis - x) -- patch 3.3 Dis added.
function XLootGroup:RollSelect(ty, who, item)
	if not self.db.profile.showrolls then return nil end
	local row = GetRoll(item)
	if not row then return nil end
	
	row[ty] = row[ty] and row[ty] + 1 or 1
	local need = row.need > 0 and ('|cffff1111%sn'):format(tostring(row.need)) or ''
	local greed = row.greed > 0 and ('|cff11ff11%sg'):format(tostring(row.greed)) or ''
	local dis = row.dis > 0 and ('|cff1111ff%sd'):format(tostring(row.dis)) or '' -- patch 3.3 dis added.
	local pass = row.pass > 0 and ('|cffaaaaaa%sp'):format(tostring(row.pass)) or ''
	row.fsextra:SetText(("%s%s%s%s  "):format(need, greed, dis, pass)) -- patch 3.3 dis.
end


function XLootGroup:GroupBuildRow(stack, id)
	local row = XLoot:GenericItemRow(stack, id, AA)
	local rowname = row:GetName()
	
	local bneed = CreateFrame("Button", rowname.."NeedButton", row)
	bneed:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")
	bneed:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Highlight")
	bneed:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Down")
	bneed:SetScript("OnClick", function() ClickRoll(row, 'bneed', 1) end)
	bneed:SetScript("OnEnter", function() GameTooltip:SetOwner(bneed, "ANCHOR_RIGHT"); GameTooltip:SetText(NEED) end)
	bneed:SetScript("OnLeave", function() GameTooltip:Hide() end)
	local bgreed = CreateFrame("Button", rowname.."GreedButton", row)
	bgreed:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Up")
	bgreed:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Highlight")
	bgreed:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Down")
	bgreed:SetScript("OnClick", function() ClickRoll(row, 'bgreed', 2) end)
	bgreed:SetScript("OnEnter", function() GameTooltip:SetOwner(bgreed, "ANCHOR_RIGHT"); GameTooltip:SetText(GREED) end)
	bgreed:SetScript("OnLeave", function() GameTooltip:Hide() end)
	local bdis = CreateFrame("Button", rowname.."DisButton", row) -- 3.3 patch dis button section added.
	bdis:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-DE-Up")
	bdis:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-DE-Highlight")
	bdis:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-DE-Down")
	bdis:SetScript("OnClick", function() ClickRoll(row, 'bdis', 3) end)
	bdis:SetScript("OnEnter", function() GameTooltip:SetOwner(bdis, "ANCHOR_RIGHT"); GameTooltip:SetText(ROLL_DISENCHANT) end)
	bdis:SetScript("OnLeave", function() GameTooltip:Hide() end) -- 3.3 dis button end
	local bpass = CreateFrame("Button", rowname.."PassButton", row)
	bpass:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
	bpass:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Down")
	bpass:SetScript("OnClick", function() ClickRoll(row, 'bpass', 0) end)
	bpass:SetScript("OnEnter", function() GameTooltip:SetOwner(bpass, "ANCHOR_RIGHT"); GameTooltip:SetText(PASS) end)
	bpass:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	local status = CreateFrame("StatusBar", rowname.."StatusBar", row)
	status:SetMinMaxValues(0, 60000)
	status:SetValue(0)
	status:SetStatusBarTexture("Interface\\AddOns\\XLootGroup\\DarkBottom.tga")
	
	local spark = row:CreateTexture(nil, "OVERLAY")
	spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	spark:SetBlendMode("ADD")
	status.spark = spark
	
	local bind = row:CreateFontString(rowname.."Bind")
	bind:SetFont("Fonts\\FRIZQT__.TTF", 11, "THICKOUTLINE")
	
	row:SetScale(1.2)
	
	local size = XLootGroup.db.profile.buttonscale
	bneed:SetWidth(size)
	bneed:SetHeight(size)
	bgreed:SetWidth(size)
	bgreed:SetHeight(size)
	bdis:SetWidth(size) -- 3.3 patch
	bdis:SetHeight(size) -- 3.3 patch
	bpass:SetWidth(size)
	bpass:SetHeight(size)
	
	local level = row.overlay:GetFrameLevel()+1
	bneed:SetFrameLevel(level)
	bgreed:SetFrameLevel(level)
	bdis:SetFrameLevel(level) -- 3.3 patch
	bpass:SetFrameLevel(level)
	
	bneed:SetPoint("LEFT", row.button, "RIGHT", 5, -1)
	bgreed:SetPoint("LEFT", bneed, "RIGHT", 0, -1) 
	bdis:SetPoint("LEFT", bgreed, "RIGHT", 0, 1) -- 3.3 patch add 'bdis' button (disenchant)
	bpass:SetPoint("LEFT", bdis, "RIGHT", 0, 2.2) -- 3.3 patch shift anchoring to 'bdis'
	row.fsplayer:ClearAllPoints()
	bind:SetPoint("LEFT", bpass, "RIGHT", 3, 1)
	row.fsloot:SetPoint("LEFT", bind, "RIGHT", 0, .12)
	status:SetFrameLevel(status:GetFrameLevel()-1)
	status:SetStatusBarColor(.8, .8, .8, .9)
	status:SetPoint("TOP", row, "TOP", 0, -4)
	status:SetPoint("BOTTOM", row, "BOTTOM", 0, 4)
	status:SetPoint("LEFT", row.button, "RIGHT", -1, 0)
	status:SetPoint("RIGHT", row, "RIGHT", -4, 0)
	
	row.fsextra:SetVertexColor(.8, .8, .8, .8)
	
	spark:SetWidth(12)
	spark:SetHeight(status:GetHeight()*2.44)

	XLoot:ItemButtonWrapper(row.button, 8, 8, 20)
	
	row.bneed = bneed
	row.bgreed = bgreed
	row.bdis = bdis -- 3.3 patch
	row.bpass = bpass
	row.need = 0
	row.greed = 0
	row.dis = 0 -- 3.3 patch
	row.pass = 0
	row.fsbind = bind
	row.status = status
	row.candismiss = false
	row.sizeoffset = 52
	return row
end