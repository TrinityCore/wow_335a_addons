local L = AceLibrary("AceLocale-2.2"):new("XLootMonitor")

XLootMonitor = XLoot:NewModule("XLootMonitor")

XLootMonitor.dewdrop = AceLibrary("Dewdrop-2.0")
local deformat = AceLibrary("Deformat-2.0")
local AA = AceLibrary("AnchorsAway-1.0")
AceLibrary("SpecialEvents-Loot-1.0")
local nilTable = XLoot.nilTable
XLootMonitor.AA = AA
XLoot.deformat = deformat

local _G = getfenv(0)

XLootMonitor.revision  = tonumber((string.gsub("$Revision: 107 $", "^%$Revision: (%d+) %$$", "%1")))

function XLootMonitor:OnInitialize()
	self.db = XLoot:AcquireDBNamespace("XLootMonitorDB")
	self.defaults = {
		lock = false,
		qualitythreshold = 1,
		selfqualitythreshold = 0,
		historylinktrunc = 20,
		history = {
			customitem = "",
			customcoin = "",
		},
		monitorlinktrunc = 20,
		historyactive = true,
		money = true,
		texcolor = true,
		strata = "LOW",
		layout = 1,
		anchors = { },
		pos = { },
		stacks = { },
		rollchoices = false,
		rollwins = false, 
		yourtotals = true,
	}
	XLoot:RegisterDefaults("XLootMonitorDB", "profile", self.defaults)
	self:DoOptions()	

	-- Initialize misc vars
	self.exports = { }
	self.stacks = { }
	self.cache = { time = { }, player = { }, total = { } }

	-- Setup options to test monitor
	self:AddTestItem("money1", function()self:TriggerEvent("SpecialEvents_LootDummy", string.format(LOOT_MONEY_SPLIT, "70 Gold, 2 Silver, 3 Copper")) end)
	self:AddTestItem("money2", function() self:TriggerEvent("SpecialEvents_LootDummy", string.format(LOOT_MONEY_SPLIT, "1 Gold, 3 Copper")) end)
	self:AddTestItem("money3", function() self:TriggerEvent("SpecialEvents_LootDummy", string.format(LOOT_MONEY_SPLIT, "99 Silver, 3 Copper")) end)
	self:AddTestItem("selflootcommon", function() self:TriggerEvent("SpecialEvents_LootDummy", "You receive loot: |cffffffff|Hitem:2589:0:0:0:0:0:0:0|h[Linen Cloth]|h|r.") end)
	self:AddTestItem("selflootuncommon", function() self:TriggerEvent("SpecialEvents_LootDummy", "You receive loot: |cff1eff00|Hitem:11874:0:0:0:0:0:0:0|h[Clouddrift Mantle]|h|r.") end)
	self:AddTestItem("selflootrare", function() self:TriggerEvent("SpecialEvents_LootDummy", "You receive loot: |cff007099|Hitem:14638:0:0:0:0:0:0:0|h[Cadaverous Leggings]|h|r.") end)
	self:AddTestItem("selfstackloot1", function() self:TriggerEvent("SpecialEvents_LootDummy", "You receive loot: |cffffffff|Hitem:2589:0:0:0:0:0:0:0|h[Linen Cloth]|h|rx3.") end)
	self:AddTestItem("selflootepic", function() self:TriggerEvent("SpecialEvents_LootDummy", "You receive loot: |cffa335ee|Hitem:21698:0:0:0:0:0:0:0|h[Leggings of Immersion]|h|r.") end)
end

function XLootMonitor:OpenMenu(frame)
	self.dewdrop:Open(frame,
		'children', function(level, value)
				self.dewdrop:FeedAceOptionsTable(self.fullopts)
			end,
		'cursorX', true,
		'cursorY', true
	)
end

function XLootMonitor:OnEnable()
	self:RegisterEvent("XLoot_Item_Recieved", "ItemRecieved")
	self:RegisterEvent("SpecialEvents_CoinLooted", "AddCoin")
	self:RegisterEvent("SpecialEvents_ItemLooted", "AddLoot")
	self:RegisterEvent("SpecialEvents_RollSelected", "RollSelect")
	self:RegisterEvent("SpecialEvents_RollMade", "RollMade")
	self:RegisterEvent("SpecialEvents_RollWon", "RollWon")
	self:RegisterEvent("SpecialEvents_RollAllPassed", "RollPassed")
	
	-- Build Anchors Away stack
	if not AA.stacks.loot then
		local stackname, anchorname, icon = "loot", L["Loot Monitor"], "Interface\\GossipFrame\\TrainerGossipIcon"
		stack = AA:NewAnchor(stackname, anchorname, icon, self.db.profile, self.dewdrop)
		XLoot:Skin(stack.frame)
		stack.SizeRow = XLoot.SizeRow
		stack.BuildRow = self.BuildRow
		stack.clear = function(row)
			row.recipient = nil
			row.item = nil
			row.count = nil
			row.link = nil
		end
		-- Add a few options
		stack.opts.trunc = {
			type = "range",
			name = L["Trim item names to..."],
			desc = L["Length in characters to trim item names to"],
			get = function() return self.db.profile.monitorlinktrunc end,
			set = function(v) self.db.profile.monitorlinktrunc = v end,
			min = 4,
			max = 100,
			step = 2,
			order = 18
		}
		stack.opts.monitor =  {
			type = "execute",
			name = "|cFF44EE66"..L["optMonitor"],
			desc = L["descMonitor"],
			icon = "Interface\\GossipFrame\\BinderGossipIcon",
			order = 86,
			func = function() self:OpenMenu(UIParent) end,
		}
		self.opts.display.args = stack.opts
	end
end

function XLootMonitor:OnDisable()
	self:UnregisterAllEvents()
end

-- Small History module (Fear the tables..)
function XLootMonitor:ItemRecieved(item, recipient, count, class, classname, icon)
	if not self.db.profile.historyactive then return end
	if item == "coin" then recipient = "_coin" end
	
	-- Apply XLootMonitor quality Filter to History as well
	if item ~= "coin" and select(3,GetItemInfo(item)) < self.db.profile.qualitythreshold then return end
	
	-- Insert into time cache
	table.insert(self.cache.time, {item = item, player = recipient, count = count, time = time(), class = class, icon = icon})

	-- Insert into player cache
	if not self.cache.player[recipient] then 
		self.cache.player[recipient] = { class = class, classname = classname }
	end
	table.insert(self.cache.player[recipient], { item = item, count = count, time = time(), icon = icon })

	--Add to total cache
	if not self.cache.total[item] then
		self.cache.total[item] = {item = item, player = recipient, count = count, time = time(), class = class, icon = icon}
	else
		self.cache.total[item].count = self.cache.total[item].count + count
	end
end

-- History dewdrop menu
function XLootMonitor:BuildHistory(level, value)
	local db = self.db.profile
	local string_format = string.format
	if level == 1 then
		self.dewdrop:AddLine(
			'text', "|cFF77BBFF"..L["moduleHistory"],
			'icon', "Interface\\GossipFrame\\TrainerGossipIcon",
			'iconWidth', 24,
			'iconHeight', 24,
			'isTitle', true)		
		self.dewdrop:AddLine(
			'text', L["historyTime"],
			'hasArrow' , true,
			'value', "time")
		self.dewdrop:AddLine(
			'text', L["historyPlayer"],
			'hasArrow', true,
			'value', "player")
		self.dewdrop:AddLine(
			'text', L["View by item"],
			'hasArrow', true,
			'value', "total")
		self.dewdrop:AddLine()
		self.dewdrop:AddLine(
			'text', L["Export history"],
			'hasArrow', true,
			'value', 'historyexport')
		self.dewdrop:AddLine(
			'text', "|cFFFF3311"..L["historyClear"],
			'icon', "Interface\\Glues\\Login\\Glues-CheckBox-Check",
			'func', function() self.cache.time = nilTable(self.cache.time) self.cache.player = nilTable(self.cache.player) self.cache.total = nilTable(self.cache.total) end)
		self.dewdrop:AddLine()
		self.dewdrop:AddLine(
			'text', L["historyTrunc"],
			'hasArrow', true,
			'hasSlider', true,
			'sliderMin', 5,
			'sliderMax', 100,
			'sliderValue', db.historylinktrunc,
			'sliderStep', 5,
			'sliderFunc', function(v) db.historylinktrunc = v end)
		self.dewdrop:AddLine(
			'text', L["moduleActive"],
			'checked', db.historyactive,
			'func', function(v) db.historyactive = not db.historyactive end)
		self.dewdrop:AddLine()
		self.dewdrop:AddLine(
			'text', "|cFF44EE66"..L["optMonitor"],
			'icon', "Interface\\GossipFrame\\BinderGossipIcon",
			'func', function() self:OpenMenu(UIParent) end)
	elseif level == 2 and value then
		-- View history by time
		if value == "time" then
			if not next(self.cache.time) then
				self:HistoryEmptyLine()
			else
				for k,v in ipairs(self.cache.time) do
					if v.item == "coin" then
						self.dewdrop:AddLine(
							'text', string_format("|cFFEEEEEE%s|r   %s", date("%H:%M", v.time), XLoot:ParseMoney(v.count)),
							'icon', GetCoinIcon(v.count),
							'tooltipFunc', function() end,
							'notClickable', true)
					else
						local link = self:HistoryTrimLink(v.item)
						self.dewdrop:AddLine(
							'text', string_format("|cFFEEEEEE%s|r   |cFF%s%s|r %s%s", date("%H:%M", v.time), XLoot:ClassHex(v.class), v.player, tonumber(v.count) > 1 and tostring(v.count).."x" or "", link),
						    'icon', v.icon,
						    'tooltipFunc', GameTooltip.SetHyperlink,
						    'tooltipArg1', GameTooltip,
						    'tooltipArg2', v.item,
						    'func', function(arg1) self:LinkHistoryItem(arg1) end,
						    'arg1', v)
					end
				end
			end
		-- View history by player
		elseif value == "player" then
			if not next(self.cache.player) then
				self:HistoryEmptyLine()
			else
				for k, v in iteratetable(self.cache.player) do
					if k ~= "_coin" then
						self.dewdrop:AddLine(
							'text', string_format("|cFF%s%s|r", XLoot:ClassHex(v.class), k),
							'hasArrow', true,
							'value', "player "..k)
					else
						self.dewdrop:AddLine(
							'text', L["historyMoney"],
							'hasArrow', true,
							'value', "player _coin")
					end
				end
			end
		-- View history by item
		elseif value == "total" then
			if not next(self.cache.total) then
				self:HistoryEmptyLine()
			else
				if self.cache.total["coin"] then
					local coins = self.cache.total["coin"].count
					self.dewdrop:AddLine(
						'text', XLoot:ParseMoney(coins),
						'icon', GetCoinIcon(coins),
						'tooltipFunc', function() end,
						'notClickable', true)
				end
				for k, v in iteratetable(self.cache.total) do
					if k ~= "coin" then
						self.dewdrop:AddLine(
							'text', string_format("%s %s", v.count, v.item),
						    'icon', v.icon,
						    'arg1', v,
						    'hasArrow', true,
						    'value', "total "..k)
					end
				end
			end
		-- Export history
		elseif value == "historyexport" then
			if table.getn(self.exports) > 0 then
				for k, v in pairs(self.exports) do
					self.dewdrop:AddLine(
						'text', v.title,
						'icon', v.icon,
						'iconWidth', v.iconWidth,
						'iconHeight', v.iconHeight,
						'tooltipTitle', v.title,
						'tooltipText', v.tooltip,
						'func', v.func)
				end
			else
				self.dewdrop:AddLine(
					'text', L["Simple XML copy-export"],
					'disabled', true,
					'func', function() self:ExportXML() end)
				self.dewdrop:AddLine(
					'text', L["Copy-Paste Pipe Separated List"],
					'func', function() self:ExportPSV() end)
				self.dewdrop:AddLine(
					'text', L["Custom export"],
					'func', function() self:ExportCustom() end)	
			end				
		end
	elseif level == 3 and value then
		-- Display all of a particular player's loot
		if string.sub(value, 1, 6) == "player" then
			local player = string.sub(value, 8)
			for k, v in pairs(self.cache.player[player]) do
				if type(k) == "number" then
					if v.item == "coin" then
						self.dewdrop:AddLine(
							'text', string_format("|cFFEEEEEE%s|r   %s", date("%H:%M", v.time), XLoot:ParseMoney(v.count)),
							'icon', GetCoinIcon(v.count),
							'tooltipFunc', function() end,
							'notClickable', true)
					else
						self.dewdrop:AddLine(
							'text', string_format("|cFFEEEEEE%s|r   %s%s", date("%H:%M", v.time), tonumber(v.count) > 1 and tostring(v.count).."x" or "", v.item),
						    'icon', v.icon,
						    'tooltipFunc', GameTooltip.SetHyperlink,
						    'tooltipArg1', GameTooltip,
						    'tooltipArg2', v.item,
						    'func', function(arg1) self:LinkHistoryItem(arg1) end,
						    'arg1', v)
					end
				end
			end
		-- Display the totals for a particular item
		elseif string.sub(value, 1, 5) == "total" then
			local item = string.sub(value, 7)
			for k, v in iteratetable(self.cache.time) do
				if v.item == item then
					local link = self:HistoryTrimLink(v.item)
					self.dewdrop:AddLine(
						'text', string_format("|cFFEEEEEE%s|r   |cFF%s%s|r %s%s", date("%H:%M", v.time), XLoot:ClassHex(v.class), v.player, tonumber(v.count) > 1 and tostring(v.count).."x" or "", link),
					    'icon', v.icon,
					    'tooltipFunc', GameTooltip.SetHyperlink,
					    'tooltipArg1', GameTooltip,
					    'tooltipArg2',v.item,
					    'func', function(arg1) self:LinkHistoryItem(arg1) end,
					    'arg1', v)
				end
			end
		end
	end
end

local function ExtractLink(link)
	return link:match("(item:(.-):.*)|h%[(.*)%]")
end

local exportbuffer = {}
function XLootMonitor:ExportCustom()
	-- Grab locals
	local ins, customcoin, customitem = table.insert, self.db.profile.history.customcoin, self.db.profile.history.customitem
	
	-- Create helpers
	--local colorclass = function(class, player) return ("|cff%s%s|r"):format(XLoot.ClassHex(nil, class), player) end
	local parsemoney = function(money) return XLoot:ParseMoney(money, false, true) end
	local parsetime = function(stamp) return date("%H:%m", stamp) end
	local tokenize = function(string, values) string = string.gsub(string, "%[(.-)%]", values) return string end
	
	-- Parse each record
	for k, v in ipairs(self.cache.time) do
		-- Money
		if v.item == 'coin' then
			ins(exportbuffer, tokenize(customcoin, {
						time = v.time, 
						ftime = parsetime(v.time), 
						count = v.count, 
						fcount = parsemoney(v.count)
					}))
		-- Item
		else
			local link, id, name = ExtractLink(v.item)
			ins(exportbuffer, tokenize(customitem, { 
						time = v.time, 
						ftime = parsetime(v.time), 
						count = v.count, 
						id = id, 
						name =  name, 
						player = v.player,
						class = v.class,
						classname = self.cache.player[v.player].classname
					}))
		end
	end
	
	-- Solidify output
	local output = table.concat(exportbuffer, "\r\n")
	
	-- Cleanup
	for i, v in ipairs(exportbuffer) do
		exportbuffer[i] = nil
	end
	
	-- Display for copying
	self:HistoryExportCopier(output)
end


function XLootMonitor:ExportXML()
	local output = ''
	for k, v in ipairs(self.cache.time) do
		if v.item == 'coin' then
			output = string.format("%s<drop type='money' time='%d'>%d</drop>\n", output, v.time, v.count)
		else
			--DevTools_Dump(v.item)
			local link, id, name = ExtractLink(v.item)
			output = string.format("%s<drop type='item' time='%d' itemid='%s' itemlink='%s' count='%d' player=''>%s</drop>\n", output, v.time, id, link, v.count, v.player, name)
		end
	end
	self:HistoryExportCopier(output)
end

function XLootMonitor:ExportPSV()
	local output = ''
	for k, v in ipairs(self.cache.time) do
		if v.item == 'coin' then
			output = string.format("%sdrop|coin|%d|%d\n", output, v.time, v.count)
		else
			local link, id, name = ExtractLink(v.item)
			output = string.format("%sdrop|item|%d|%d|%s|%s|%s\n", output, v.time, v.count, id, name, link)
		end
	end
	self:HistoryExportCopier(output)
end

function XLootMonitor:HistoryExportCopier(text)
	local frame = XLootHistoryEditFrame
	local edit = XLootHistoryEdit
	-- Build the export frame
	if not frame then
		frame = CreateFrame("Frame", "XLootHistoryEditFrame", UIParent)
		frame:SetHeight(26)
		frame:SetWidth(300)
		XLoot:BackdropFrame(frame, { .2, .2, .2, 8 }, { .8, .8, .8, 8 })
		frame:SetPoint("CENTER", UIParent, "CENTER", 0, UIParent:GetWidth()/4)
		
		local label = frame:CreateFontString("XLootHistoryEditLabel", "OVERLAY", "GameFontNormalSmall")
		label:SetPoint("TOP", frame, "TOP", 0, -7)
		label:SetText(L["Press Control-C to copy the log"])
		
		edit = CreateFrame("EditBox", "XLootHistoryEdit", frame)
		edit:SetScript("OnEscapePressed", function() frame:Hide(); edit:Hide() end)
		edit:SetScript("OnMouseUp", function() edit:HighlightText() end)
		edit:SetScript("OnTextChanged", function() edit:SetText(edit.text) edit:HighlightText() end)
		edit:SetAutoFocus(true)
		edit:SetMultiLine(true)
		edit:EnableMouse(true)
		--edit:SetFontObject(GameFontNormalSmall)
		edit:SetTextColor(1, 1, 1)
		edit:SetJustifyV("TOP")
		edit:SetJustifyH("LEFT")
		edit:ClearAllPoints()
		edit:SetWidth(280)
	--	edit:SetPoint("LEFT", frame, "LEFT", 3, 0)
		edit:SetPoint("TOP", frame, "TOP", 0, -14)
	--	edit:SetPoint("RIGHT", frame, "RIGHT", -3, 0)
		edit:SetPoint("BOTTOM", frame, "BOTTOM")

		local close = CreateFrame("Button", "XLootHistoryEditClose", edit)
		close:SetScript("OnClick", function() frame:Hide(); edit:Hide() end)
		close:SetFrameLevel(8)
		close:SetWidth(32)
		close:SetHeight(32)
		close:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
		close:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
		close:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
		close:ClearAllPoints()
		close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 3, 3)
		close:SetHitRectInsets(5, 5, 5, 5)
		close:Show()
	end
	edit.text = text
	frame:Show()
	edit:Show()
	edit:SetMaxLetters(10000)--string.len(text))
	edit:SetText(text)
	edit:HighlightText()
end

function XLootMonitor:HistoryEmptyLine()
	self.dewdrop:AddLine(
		'text', L["historyEmpty"],
		'isTitle', true)
end

-- Truncate links
function XLootMonitor:HistoryTrimLink(link)
	local length = self.db.profile.historylinktrunc
	local name = XLoot:LinkToName(link)
	if string.len(name) > length then
		link = string.gsub(link, name, string.sub(name, 1, length).."..")
	end
	return link
end

function XLootMonitor:LinkHistoryItem(item)
	if not IsControlKeyDown() then
		if IsShiftKeyDown() then
			return ChatEdit_InsertLink(item.item)
		end
		if not ChatFrameEditBox:IsVisible() then
			ChatFrameEditBox:Show()
		end
		local outstring = string.format("%s %s: %s ", date("%H:%M", item.time), item.player, item.item)
		if strlen(ChatFrameEditBox:GetText()..outstring) > 255 then
			return self:Print(L["linkErrorLength"])
		else
			return ChatFrameEditBox:Insert(outstring)
		end
	else
		return DressUpItemLink(item.item)
	end
end

-- Group loot - Roll Selected (Greed, Need, Pass)
function XLootMonitor:RollSelect(ty, who, item)
	if not self.db.profile.rollchoices then return nil end
	local _, class = UnitClass(who)
	local stack = AA.stacks.loot
	local row = AA:PushRow(stack)
	row.link = item
	row.fsloot:SetText(item)
	row.fsplayer:SetText(who)
	local c = RAID_CLASS_COLORS[class]
	
	-- Debug pattern matching
	if (not who or not c or not class) and SEEL_LastEvent then
		XLoot:Print(("Please post this in XLoot's Thread: %s"):format(SEEL_LastEvent))
		XLoot:Print(("c: %s; who: %s; class: %s"):format(who or "nil", c or "nil", class or "nil"))
		return nil
	end
	
	row.fsplayer:SetVertexColor(c.r, c.g, c.b)
	XLoot:SizeRow(stack, row)
	if ty == "need" then texture ="Interface\\Buttons\\UI-GroupLoot-Dice-Up"
	elseif ty == "greed" then texture = "Interface\\Buttons\\UI-GroupLoot-Coin-Up"
	elseif ty == "dis" then texture = "Interface\\Buttons\\UI-GroupLoot-DE-Up" -- 3.3 patch
	else texture = "Interface\\Buttons\\UI-GroupLoot-Pass-Up" end
	SetItemButtonTexture(row.button, texture)
	XLoot:QualityColorRow(row, 0)
end

local itemrolls = { }

-- Group loot - Roll made (Need - x, Greed - x)
function XLootMonitor:RollMade(ty, who, roll, item)
	if not self.db.profile.rollwins then return nil end
	if not itemrolls[item] then itemrolls[item] = { } end
	itemrolls[item][who] = roll
end

-- Group loot - Roll won (xx won xx)
function XLootMonitor:RollWon(item, who)
	if (not self.db.profile.rollwins and not self.db.profile.rollchoices) or not itemrolls[item] then return nil end
	local you = UnitName('player')
	local win, yours = itemrolls[item][who], itemrolls[item][you]
	itemrolls[item] = nil
	if not self.db.profile.rollwins then return nil end
	local texture = select(10, GetItemInfo(item))
	local _, class = UnitClass(who)
	local stack = AA.stacks.loot
	local row = AA:PushRow(stack)
	row.link = item
	row.fsloot:SetText(((yours and who ~= you) and ("(%d - %d)"):format(win, yours) or win).." "..item)
	row.fsplayer:SetText(who)
	local c = RAID_CLASS_COLORS[class]
	row.fsplayer:SetVertexColor(c.r, c.g, c.b)
	XLoot:SizeRow(stack, row)
	SetItemButtonTexture(row.button, texture)
	XLoot:QualityColorRow(row, 0)
end

-- Group loot - All passed on item
function XLootMonitor:RollPassed(item)
	local db = self.db.profile
	if not db.rollchoices and not db.rollwins then return nil end
	itemrolls[item] = nil
	if not db.rollwins then return nil end
	local stack = AA.stacks.loot
	local row = AA:PushRow(stack)
	row.link = item
	row.fsloot:SetText(item)
	row.fsplayer:SetText(ALL)
	row.fsplayer:SetVertexColor(1, 1, 1)
	XLoot:SizeRow(stack, row)
	SetItemButtonTexture(row.button, "Interface\\Buttons\\UI-GroupLoot-Pass-Up")
	XLoot:QualityColorRow(row, 0)
end

local function itemtotal(item, new)
	local count = GetItemCount(item) + new
	return count > 1 and (" |cffaaaaaa%d|r"):format(count) or ""
end

function XLootMonitor:AddCoin(recipient, count, string)
	self:AddLoot(recipient, 'coin', count)
end

XLootMonitor.skiplist = {
	[28558] = true, -- spirit shard
	[29434] = true, -- badge of justice
	[40752] = true, -- emblem of heroism
	[40753] = true, -- emblem of valor
	[43228] = true, -- stone keeper's shard
	[44990] = true, -- champion's seal
	[45624] = true, -- emblem of conquest
	[47241] = true, -- emblem of triumph
	[49426] = true, -- emblem of frost
}
local unitFromPlayerName = XLoot.unitFromPlayerName
function XLootMonitor:AddLoot(recipient, item, count)
	local db = self.db.profile
	local  itemName, itemLink, itemQuality, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture
	local unit = unitFromPlayerName(recipient)
	if not UnitExists(unit) then return nil end
	local classname, class = UnitClass(unit)
	local own = recipient == UnitName('player')
	
 	if item ~= "coin" then
 		itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(item)
		if not itemName then return nil end
		local _, id, _ = ExtractLink(itemLink)
		if XLootMonitor.skiplist[id] then return nil end -- skip emblem/badge/seal etc spam
		self:TriggerEvent("XLoot_Item_Recieved", item, recipient, count, class, classname, itemTexture, itemName, itemLink)
		
		if own and itemQuality < db.selfqualitythreshold then
				return nil
		elseif not own and itemQuality < db.qualitythreshold then
				return nil
		end
	else
		itemName = "coin"
		self:TriggerEvent("XLoot_Item_Recieved", item, recipient, count, class, classname, nil, itemName)
		if not db.money then return end
	end
		
	local length = db.monitorlinktrunc
	if itemName:len() > length then
		itemName = itemName:sub(1, length)..".."
	end
	
	local stack = AA.stacks.loot
	local total = (own and db.yourtotals and item ~= "coin") and itemtotal(item, count) or ""
	if (stack.rowstack[1] and stack.rowstack[1].item ~= itemName) or not stack.rowstack[1] or stack.rowstack[1].recipient ~= recipient then 
		local row = AA:PushRow(stack)
		
		row.recipient = recipient
		row.item = itemName or "coin"
		row.count = count
		row.link = row.item ~= "coin" and item or nil
		if item == "coin" then -- Money
			row.fsplayer:SetText(XLoot:ParseMoney(count))
			row.fsloot:SetText("")
			SetItemButtonTexture(row.button, GetCoinIcon(count))
			XLoot:QualityColorRow(row, item)
		else -- Item
			row.fsplayer:SetText(recipient)
			row.fsloot:SetText(("%s[%s]"):format(count > 1 and tostring(count)..'x ' or '', itemName)..total)
			SetItemButtonTexture(row.button, itemTexture)
			row.fsloot:SetVertexColor(GetItemQualityColor(itemQuality))
			local c = RAID_CLASS_COLORS[class]
			row.fsplayer:SetVertexColor(c.r, c.g, c.b)
			XLoot:QualityColorRow(row, itemQuality)
		end
		row.fsextra:SetText("")
		XLoot:SizeRow(stack, row)
	else -- Add to the last row
		local srow = stack.rowstack[1]
		if item ~= "coin" then
			srow.count = srow.count + count
			srow.additional = (stack.rowstack.additional or 0) + count
			srow.fsextra:SetText(("|cAA22FF22+%s "):format(srow.additional))
			srow.fsloot:SetText(("%dx [%s]%s"):format(srow.count, itemName, total or ""))
			--srow.fsplayer:SetText(recipient)
			--local c = RAID_CLASS_COLORS[class]
			--srow.fsplayer:SetVertexColor(c.r, c.g, c.b)
		else
			srow.fsextra:SetText(("|cAA22FF22+%s "):format(XLoot:ParseMoney(count, true)))
			srow.count = count + (srow.count or 0)
			srow.fsplayer:SetText(XLoot:ParseMoney(srow.count))
		end
			XLoot:SizeRow(stack, srow)
	end
end

function XLootMonitor:BuildRow(stack, id)
	return XLoot:GenericItemRow(stack, id, AA)
end