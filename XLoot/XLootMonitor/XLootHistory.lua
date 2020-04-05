function XLootMonitor:ItemRecieved(item, recipient, count, class, classname, icon)
	if not self.db.profile.historyactive then return end
	if item == "coin" then recipient = "_coin" end

	-- Insert into time cache
	table.insert(self.cache.time, {item = item, player = recipient, count = count, time = time(), class = class, icon = icon})

	-- Insert into player cache
	if not self.cache.player[recipient] then 
		self.cache.player[recipient] = { class = class, classname = classname }
	end
	table.insert(self.cache.player[recipient], { item = item, player = recipient, count = count, time = time(), icon = icon })

	--Add to total cache
	if not self.cache.total[item] then
		self.cache.total[item] = {item = item, player = recipient, count = count, time = time(), class = class, icon = icon}
	else
		self.cache.total[item].count = self.cache.total[item].count + count
	end
end

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
			'func', function() self.cache.time = {}; self.cache.player = {}; end)
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
	elseif level == 2 then
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
						    'tooltipArg2', XLoot:LinkToID(v.item),
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
							'text', v.item,
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
					'text', L["No export handlers found"],
					'isTitle', true)
			end				
		end
	elseif level == 3 then
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
						    'tooltipArg2', XLoot:LinkToID(v.item),
						    'func', function(arg1) self:LinkHistoryItem(arg1) end,
						    'arg1', v)
					end
				end
			end
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
					    'tooltipArg2', XLoot:LinkToID(v.item),
					    'func', function(arg1) self:LinkHistoryItem(arg1) end,
					    'arg1', v)
				end
			end
		end
	end
end

function XLootMonitor:HistoryExportCopier(text)
	local frame = XLootHistoryEditFrame
	local edit = XLootHistoryEdit
	if not frame then
		frame = CreateFrame("Frame", "XLootHistoryEditFrame", UIParent)
		frame:SetHeight(28)
		frame:SetWidth(200)
		XLoot:BackdropFrame(frame, { .2, .2, .2, 8 }, { .8, .8, .8, 8 })
		frame:SetPoint("CENTER", UIParent, "CENTER", 0, UIParent:GetWidth()/4)
		
		edit = CreateFrame("EditBox", "XLootHistoryEdit", frame)
		edit:SetScript("OnEscapePressed", function() frame:Hide(); edit:Hide() end)
		edit:SetAutoFocus(true)
		edit:SetMultiLine(true)
		edit:EnableMouse(true)
		edit:SetFontObject(GameFontNormalSmall)
		edit:SetTextColor(1, 1, 1)
		edit:SetJustifyV("TOP")
		edit:SetJustifyH("LEFT")
	--	edit:SetPoint("LEFT", frame, "LEFT", 3, 0)
		edit:SetPoint("TOP", frame, "TOP", 0, 0)
	--	edit:SetPoint("RIGHT", frame, "RIGHT", -3, 0)
		edit:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)

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
	-- /script XLootMonitor:HistoryExportCopier()
	edit:SetText("")
	frame:Show()
	edit:Show()
	edit:SetMaxLetters(1000)--string.len(text))
	edit:SetText("WEORIUQLJLAJDOFJWOENRQ\nSDFOUHWEORHJQLJ\n\n\nasdlkjasdf")
	edit:HighlightText()
end

function XLootMonitor:HistoryEmptyLine()
	self.dewdrop:AddLine(
		'text', L["historyEmpty"],
		'isTitle', true)
end

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
		if not ChatFrameEditBox:IsVisible() then
			ChatFrameEditBox:Show()
		end
		local outstring = string.format("%s %s: %s ", date("%H:%M", item.time), item.player, item.item)
		if strlen(ChatFrameEditBox:GetText()..outstring) > 255 then
			self:Print(L["linkErrorLength"])
		else
			ChatFrameEditBox:Insert(outstring)
		end
	else
		DressUpItemLink(item.item)
	end
end