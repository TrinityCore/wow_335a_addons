local _, addon = ...

local templates = {}
addon.templates = templates


do	-- templates for Settings

	-- template function for options check buttons
	local function onClick(self)
		local checked = self:GetChecked()
		if checked then
			PlaySound("igMainMenuOptionCheckBoxOn")
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
		end
		addon:Debug(self.setting..(checked and " on" or " off"))
		CritlineSettings[self.setting] = checked and true or false
		if self.setting:find("Display$") then
			addon.display:UpdateTree(self.setting:sub(1, -8), checked)
		elseif self.setting == "detailedTooltip" or self.setting == "invertFilter" then
			addon:RebuildAllTooltips()
		elseif self.setting == "showMinimap" then
			if checked then
				addon.minimap:Show()
			else
				addon.minimap:Hide()
			end
		end
	end

	function templates:CreateCheckButton(parent)
		local checkButton = CreateFrame("CheckButton", nil, parent, "OptionsBaseCheckButtonTemplate")
		checkButton:SetPushedTextOffset(0, 0)
		checkButton:SetScript("OnClick", onClick)
		
		local checkButtonText = checkButton:CreateFontString(nil, nil, "GameFontHighlight")
		checkButtonText:SetPoint("LEFT", checkButton, "RIGHT", 0, 1)
		checkButton:SetFontString(checkButtonText)

		return checkButton
	end


	-- template function for options sliders
	function templates:CreateSlider(parent, name)
		local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
		_G[name.."Text"]:SetFontObject("GameFontNormal")
		-- font string for current value
		slider.valueText = slider:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
		slider.valueText:SetPoint("CENTER", 0, -15)
		
		return slider
	end


	-- template function for options color picker buttons
	local function setColor(id)
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local texture = addon.settings.advanced.options.colorButtons[id].swatch
		--SHTSetOpacity(id)
		texture:SetVertexColor(r, g, b)
		texture.r = r
		texture.g = g
		texture.b = b
		if id == 1 then
			local spellColor = CritlineSettings.spellColor
			spellColor.r = r
			spellColor.g = g
			spellColor.b = b
		elseif id == 2 then
			local amountColor = CritlineSettings.amountColor
			amountColor.r = r
			amountColor.g = g
			amountColor.b = b
		end
	end

	local function cancel(id, prev)
		local texture = addon.settings.advanced.options.colorButtons[id].swatch
		local r = prev.r
		local g = prev.g
		local b = prev.b
		local a = prev.opacity
		texture:SetVertexColor(r, g, b)
		texture:SetAlpha(a)
		texture.r = r
		texture.g = g
		texture.b = b
		texture.a = a
	end
	
	local setColorFunc = {}
	local cancelFunc = {}
	for i = 1, 6 do
		setColorFunc[i] = function() setColor(i) end
		cancelFunc[i] = function(c) cancel(i, c) end
	end
	
	local function onClick(self)
		local id = self:GetID()
		CloseMenus()
		local texture = addon.settings.advanced.options.colorButtons[id].swatch
		if not texture.a then
			texture.a = 1
		end
		ColorPickerFrame.func = setColorFunc[id]
		ColorPickerFrame:SetColorRGB(texture.r, texture.g, texture.b)
		ColorPickerFrame.previousValues = {r = texture.r, g = texture.g, b = texture.b, opacity = texture.a}
		ColorPickerFrame.cancelFunc = cancelFunc[id]
		ColorPickerFrame.hasOpacity = false
		
		InterfaceOptionsFrame:Hide()
		ColorPickerFrame:Show()
	end
	
	local function onEnter(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
		end
	end
	
	local function onLeave(self)
		GameTooltip:Hide()
	end

	function templates:CreateColorButton(parent)
		local button = CreateFrame("Button", nil, parent)
		button:SetSize(26, 26)
		button:SetPushedTextOffset(0, 0)
		
		button:SetNormalTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
		button.swatch = button:GetNormalTexture()
		button.swatch:SetTexCoord(0, 1, 0, 1)
		
		local buttonText = button:CreateFontString(nil, nil, "GameFontHighlight")
		buttonText:SetPoint("LEFT", button, "RIGHT")
		buttonText:SetJustifyH("LEFT")
		button:SetFontString(buttonText)
		
		button:SetScript("OnClick", onClick)
		button:SetScript("OnEnter", onEnter)
		button:SetScript("OnLeave", onLeave)
		
		return button
	end
end


do	-- used in Reset and Announce
	local MAXSPELLBUTTONS = 14


	-- this is used for creating the scroll frames for the Reset and Announce frames
	function templates:CreateList(name)
		local frame = CreateFrame("Frame")

		frame.Update = self.Update
		local function update()
			frame:Update()
		end
		
		local scrollFrame = CreateFrame("ScrollFrame", name.."ScrollFrame", frame, "FauxScrollFrameTemplate")
		scrollFrame:SetPoint("TOP", 0, -24)
		scrollFrame:SetSize(300, (MAXSPELLBUTTONS * 22 + 4))
		scrollFrame:SetScript("OnShow", function(self)
			wipe(frame.selectedSpells)
			FauxScrollFrame_SetOffset(self, 0)
			_G[self:GetName().."ScrollBar"]:SetValue(0)
			frame:Update()
		end)
		scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
			FauxScrollFrame_OnVerticalScroll(self, offset, 22, update)
		end)
		frame.scrollFrame = scrollFrame
		
		-- onClick for check buttons
		local function onClick(self)
			local _, pos = addon:GetSpellFromDB(frame.tree.selectedValue, self.spell, self.isPeriodic)
			if self:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				frame.selectedSpells[pos] = true
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				frame.selectedSpells[pos] = nil
			end
		end
		
		-- create list of check buttons
		frame.buttons = {}
		for i = 1, MAXSPELLBUTTONS do
			local button = CreateFrame("CheckButton", nil, frame, "OptionsBaseCheckButtonTemplate")
			if i == 1 then
				button:SetPoint("TOPLEFT", frame.scrollFrame)
			else
				button:SetPoint("TOP", frame.buttons[i - 1], "BOTTOM", 0, 4)
			end
			button:SetPushedTextOffset(0, 0)
			button:SetScript("OnClick", onClick)
			
			-- set default font string for the check button (will contain the spell name)
			local fontString = button:CreateFontString(nil, nil, "GameFontHighlight")
			fontString:SetPoint("LEFT", button, "RIGHT", 0, 1)
			fontString:SetJustifyH("LEFT")
			button:SetFontString(fontString)
			
			-- font string for record amounts
			button.record = button:CreateFontString(nil, nil, "GameFontHighlight")
			button.record:SetPoint("CENTER", fontString)
			button.record:SetPoint("RIGHT", frame.scrollFrame)
			button.record:SetJustifyH("RIGHT")
			
			frame.buttons[i] = button
		end
		
		frame.tree = CreateFrame("Frame", name.."Tree", frame, "UIDropDownMenuTemplate")
		frame.tree:SetPoint("TOPLEFT", frame.scrollFrame, "BOTTOMLEFT", -16, -4)
		
		local function onClick(self)
			UIDropDownMenu_SetSelectedValue(frame.tree, self.value)
			wipe(frame.selectedSpells)
			FauxScrollFrame_SetOffset(frame.scrollFrame, 0)
			_G[frame.scrollFrame:GetName().."ScrollBar"]:SetValue(0)
			frame:Update()
		end
		
		local info = {}
		
		UIDropDownMenu_Initialize(frame.tree, function(self)
			wipe(info)
			info.text = DAMAGE
			info.value = "dmg"
			info.func = onClick
			UIDropDownMenu_AddButton(info)
			
			wipe(info)
			info.text = HEALS
			info.value = "heal"
			info.func = onClick
			UIDropDownMenu_AddButton(info)

			wipe(info)
			info.text = PET
			info.value = "pet"
			info.func = onClick
			UIDropDownMenu_AddButton(info)
		end)
		
		UIDropDownMenu_SetWidth(frame.tree, 120)
		UIDropDownMenu_SetSelectedValue(frame.tree, "dmg")
		
		-- reset/announce button
		local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		button:SetPoint("TOPRIGHT", frame.scrollFrame, "BOTTOMRIGHT", 0, -6)
		button:SetSize(100, 24)
		frame.button = button
		
		return frame
	end


	local spells = {}

	function templates:Update()
		local selectedTree = UIDropDownMenu_GetSelectedValue(self.tree)
		
		wipe(spells)
		
		for i, v in ipairs(CritlineDB[selectedTree]) do
			if v.normal or v.crit then
				spells[#spells + 1] = {
					spellName = v.spellName,
					isPeriodic = v.isPeriodic,
					normal = v.normal,
					crit = v.crit,
					pos = i,
				}
			end
		end
		
		local size = #spells
		
		FauxScrollFrame_Update(self.scrollFrame, size, MAXSPELLBUTTONS, 22)
		
		local offset = FauxScrollFrame_GetOffset(self.scrollFrame)
		
		for line = 1, MAXSPELLBUTTONS do
			local button = self.buttons[line]
			local lineplusoffset = line + offset
			if lineplusoffset <= size then
				local data = spells[lineplusoffset]
				button.spell = data.spellName
				button.isPeriodic = data.isPeriodic
				local normal = data.normal and data.normal.amount
				local crit = data.crit and data.crit.amount
				button:SetText(addon:GetFullSpellName(selectedTree, data.spellName, data.isPeriodic))
				button.record:SetFormattedText("%d/%d", (normal or 0), (crit or 0))
				button:SetChecked(self.selectedSpells[data.pos])
				button:Show()
			else
				button:Hide()
			end
		end
	end
end