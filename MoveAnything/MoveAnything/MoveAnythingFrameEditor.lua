local addonname, MOVANY = ...

local function tdeepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function MovAny:ToggleFrameEditors()
	local show = MAOptionsToggleFrameEditors:GetChecked()
	for i,fe in pairs(MovAny.frameEditors) do
		if show then
			fe:Show()
		else
			fe:Hide()
		end
	end
end

function MovAny:FrameEditor(name)
	--decho(o)
	
	if MovAny.frameEditors[name] then
		MovAny.frameEditors[name]:CloseDialog()
		return
	end
	
	if MovAny.MoveOnlyWhenVisible[name] then
		maPrint(string.format(MOVANY.ONLY_WHEN_VISIBLE, name))
		return
	end
	
	local f
	for id = 1, 1000, 1 do
		f = _G["MA_FE"..id]
		if not f then
			f = MovAny:CreateFrameEditor(id, name)
			break
		end
		if not f.o then
			f:LoadFrame(name)	
			f:Show()
			break
		end
		id = id + 1
	end
end

function MovAny:CreateFrameEditor(id, name)
	local funcClearFocus = function(self)
		self:ClearFocus()
	end
	
	local leftColumnWidth = 50
	local centerColumnWidth = 30
	local secondColumnOffset = leftColumnWidth + 10
	
	local fn = "MA_FE"..id
	local fe = CreateFrame("Frame", fn, UIParent)
	
	fe:SetWidth(610)
	fe:SetHeight(465)
	fe:SetFrameStrata("FULLSCREEN")
	fe:SetFrameLevel(1)
	fe:SetPoint("CENTER")
	fe:EnableMouse(true)
	fe:SetMovable(true)
	fe:RegisterForDrag("LeftButton")
	fe:SetScript("OnDragStart", fe.StartMoving)
	fe:SetScript("OnDragStop", fe.StopMovingOrSizing)
	fe:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		tile = "true",
		tileSize = 32,
	})
	fe:SetBackdropColor(0, 0, 0)
	fe:SetBackdropBorderColor(0, 0, 0)
	
	local closeButton = CreateFrame("Button", fn.."Close", fe, "MAButtonTemplate")
	closeButton:SetText("X")
	closeButton:SetWidth(20)
	closeButton:SetHeight(20)
	closeButton:SetPoint("TOPRIGHT", -1, 0)
	closeButton:SetScript("OnClick", function()
		fe:CloseDialog()
	end)
	
	local helpfulNameLabel = fe:CreateFontString()
	helpfulNameLabel:SetFontObject("GameFontNormalSmall")
	helpfulNameLabel:SetWidth(leftColumnWidth)
	helpfulNameLabel:SetHeight(20)
	helpfulNameLabel:SetJustifyH("LEFT")
	helpfulNameLabel:SetPoint("TOPLEFT", fe, "TOPLEFT", 12, -8)
	helpfulNameLabel:SetText("Frame:")
	
	local helpfulName = fe:CreateFontString(fn.."HelpfulName")
	helpfulName:SetFontObject("GameFontHighlightSmall")
	helpfulName:SetWidth(270)
	helpfulName:SetHeight(20)
	helpfulName:SetJustifyH("LEFT")
	helpfulName:SetPoint("TOPLEFT", helpfulNameLabel, "TOPRIGHT", 6, 0)
	
	
	local realNameLabel = fe:CreateFontString()
	realNameLabel:SetFontObject("GameFontNormalSmall")
	realNameLabel:SetWidth(leftColumnWidth)
	realNameLabel:SetHeight(20)
	realNameLabel:SetJustifyH("LEFT")
	realNameLabel:SetPoint("TOPLEFT", helpfulNameLabel, "BOTTOMLEFT", 0, -2)
	realNameLabel:SetText("Name:")
	
	local realName = fe:CreateFontString(fn.."RealName")
	realName:SetFontObject("GameFontHighlightSmall")
	realName:SetWidth(270)
	realName:SetHeight(20)
	realName:SetJustifyH("LEFT")
	realName:SetPoint("TOPLEFT", realNameLabel, "TOPRIGHT", 6, 0)
	
	
	local enabledCheck = CreateFrame("CheckButton", fn.."Enabled", fe, "MACheckButtonTemplate")
	enabledCheck:SetPoint("TOPLEFT", realNameLabel, "BOTTOMLEFT", 2, -2)
	enabledCheck:SetScript("OnClick", function(self) MovAny:ToggleEnableFrame(fe.editFrame:GetName()) end)
	
	local enabledLabel = fe:CreateFontString()
	enabledLabel:SetFontObject("GameFontNormalSmall")
	--enabledLabel:SetWidth(leftColumnWidth)
	enabledLabel:SetHeight(20)
	enabledLabel:SetJustifyH("LEFT")
	enabledLabel:SetPoint("TOPLEFT", enabledCheck, "TOPRIGHT", 1, 2)
	enabledLabel:SetText("Enabled")
	
	
	local hideCheck = CreateFrame("CheckButton", fn.."Hide", fe, "MACheckButtonTemplate")
	hideCheck:SetPoint("TOPLEFT", enabledLabel, "TOPRIGHT", 9, -2)
	hideCheck:SetScript("OnClick", function(self) if not MovAny:ToggleHide(fe.editFrame:GetName()) then self:SetChecked(nil) end end)
	
	local hideLabel = fe:CreateFontString()
	hideLabel:SetFontObject("GameFontNormalSmall")
	--hideLabel:SetWidth(leftColumnWidth)
	hideLabel:SetHeight(20)
	hideLabel:SetJustifyH("LEFT")
	hideLabel:SetPoint("TOPLEFT", hideCheck, "TOPRIGHT", 1, 2)
	hideLabel:SetText("Hidden")
	
	
	local clampToScreenCheck = CreateFrame("CheckButton", fn.."ClampToScreenButton", fe, "MACheckButtonTemplate")
	clampToScreenCheck:SetPoint("TOPLEFT", hideLabel, "TOPRIGHT", 9, -2)
	clampToScreenCheck:SetScript("OnClick", function()
		local opt = fe:VerifyOpt()

		if opt.clampToScreen then
			opt.clampToScreen = nil
		else
			opt.clampToScreen = true
		end
		if fe.editFrame and fe.editFrame.SetClampedToScreen then
			fe.editFrame:SetClampedToScreen(opt.clampToScreen)
			local mover = MovAny:GetMoverByFrameName(fe.o.name)
			if mover then
				mover:SetClampedToScreen(opt.clampToScreen)
			end
		end
	end)
	
	local clampToScreenLabel = fe:CreateFontString()
	clampToScreenLabel:SetFontObject("GameFontNormalSmall")
	clampToScreenLabel:SetWidth(100)
	clampToScreenLabel:SetHeight(20)
	clampToScreenLabel:SetJustifyH("LEFT")
	clampToScreenLabel:SetPoint("TOPLEFT", clampToScreenCheck, "TOPRIGHT", 0, 0)
	clampToScreenLabel:SetText("Clamp to screen")
	
	--[[
	local positionHeading = fe:CreateFontString()
	positionHeading:SetFontObject("GameFontNormalSmall")
	positionHeading:SetWidth(leftColumnWidth)
	positionHeading:SetHeight(20)
	positionHeading:SetJustifyH("LEFT")
	positionHeading:SetPoint("TOPLEFT", enabledCheck, "BOTTOMLEFT", -3, -2)
	positionHeading:SetText("Position")
	]]
	
	local dropDownClickFunc = function(self)
		ToggleDropDownMenu(1, nil, self, self, 6, 7, nil, self)
	end
	
	local pointLabel = fe:CreateFontString()
	pointLabel:SetFontObject("GameFontNormalSmall")
	pointLabel:SetWidth(leftColumnWidth)
	pointLabel:SetHeight(18)
	pointLabel:SetJustifyH("LEFT")
	pointLabel:SetPoint("TOPLEFT", enabledCheck, "BOTTOMLEFT", -2, -4)
	pointLabel:SetText("Attach")
	
	local pointDropDownButton = CreateFrame("Button", fn.."Point", fe, "UIDropDownMenuTemplate")
	pointDropDownButton:SetID(1)
	pointDropDownButton:SetScript("OnClick", dropDownClickFunc)
	
	local pointFunc = function(self)
		UIDropDownMenu_SetSelectedValue(pointDropDownButton, self.value)
		
		fe:VerifyOpt()
		if fe.opt.pos[1] ~= self.value then
			fe.opt.pos[1] = self.value
			fe:WritePoint()
		end
	end
	
	local pointDropDown_MenuInit = function()
		local point
		if fe.opt and fe.opt.pos and fe.opt.pos[1] then
			point = fe.opt.pos[1]
		elseif fe.editFrame then
			point = fe.editFrame:GetPoint()
		end
		
		local info
		for _, infoTab in pairs(MovAny.DDMPointList) do
			info = UIDropDownMenu_CreateInfo()
			info.text = infoTab.text
			info.value = infoTab.value
			info.func = pointFunc
			if point == infoTab.value then
				info.checked = true
			end
			UIDropDownMenu_AddButton(info)
		end
	end
	
	pointDropDownButton:SetPoint("TOPLEFT", pointLabel, "TOPRIGHT", -12, 1)
	UIDropDownMenu_Initialize(pointDropDownButton, pointDropDown_MenuInit)
	UIDropDownMenu_SetWidth(pointDropDownButton, 100)
	
	
	local pointResetButton = CreateFrame("Button", fn.."PointResetButton", fe, "MAButtonTemplate")
	pointResetButton:SetWidth(20)
	pointResetButton:SetHeight(20)
	pointResetButton:SetPoint("TOPLEFT", pointDropDownButton, "TOPRIGHT", 0, -2.5)
	pointResetButton:SetText("R")
	pointResetButton:SetScript("OnClick", function()
		local p = MovAny:GetFirstOrgPoint(fe:VerifyOpt())
		if not p then
			return
		end
		p = p[1]

		if fe.opt and fe.opt.pos[1] ~= p then
			UIDropDownMenu_Initialize(pointDropDownButton, pointDropDown_MenuInit)
			UIDropDownMenu_SetSelectedValue(pointDropDownButton, p)
			fe.opt.pos[1] = p
			fe:WritePoint()
		end
	end)
	
	
	local relPointLabel = fe:CreateFontString()
	relPointLabel:SetFontObject("GameFontNormalSmall")
	relPointLabel:SetWidth(leftColumnWidth)
	relPointLabel:SetHeight(18)
	--relPointLabel:SetJustifyH("LEFT")
	relPointLabel:SetPoint("TOPLEFT", pointLabel, "BOTTOMLEFT", 0, -10)
	relPointLabel:SetText("to")
	
	local relPointDropDownButton = CreateFrame("Button", fn.."RelPoint", fe, "UIDropDownMenuTemplate")
	relPointDropDownButton:SetID(2)
	relPointDropDownButton:SetScript("OnClick", dropDownClickFunc)
	
	local relPointFunc = function(self)
		UIDropDownMenu_SetSelectedValue(relPointDropDownButton, self.value)
		
		fe:VerifyOpt()
		if not fe.opt.orgPos and fe.editFrame then
			MovAny:StoreOrgPoints(fe.editFrame, fe.opt)
		end
		local updateEditor
		if not fe.opt.pos then
			fe.opt.pos = MovAny:GetRelativePoint(MovAny:GetFirstOrgPoint(fe.opt), fe)
			updateEditor = true
		end
		if fe.opt.pos[3] ~= self.value then
			fe.opt.pos[3] = self.value
			fe:WritePoint(updateEditor)
		end
	end
	
	local relPointDropDown_MenuInit = function()
		local info
		for _, infoTab in pairs(MovAny.DDMPointList) do
			info = UIDropDownMenu_CreateInfo()
			info.text = infoTab.text
			info.value = infoTab.value
			info.func = relPointFunc
			info.checked = nil
			UIDropDownMenu_AddButton(info)
		end
	end
	
	relPointDropDownButton:SetPoint("TOPLEFT", relPointLabel, "TOPRIGHT", -12, 1)
	UIDropDownMenu_Initialize(relPointDropDownButton, relPointDropDown_MenuInit)
	UIDropDownMenu_SetWidth(relPointDropDownButton, 100)
	
	
	local relPointResetButton = CreateFrame("Button", fn.."RelPointResetButton", fe, "MAButtonTemplate")
	relPointResetButton:SetWidth(20)
	relPointResetButton:SetHeight(20)
	relPointResetButton:SetPoint("TOPLEFT", relPointDropDownButton, "TOPRIGHT", 0, -2.5)
	relPointResetButton:SetText("R")
	relPointResetButton:SetScript("OnClick", function()
		local p = MovAny:GetFirstOrgPoint(fe:VerifyOpt())
		if not p then
			return
		end
		p = p[3]
		if fe.opt and fe.opt.pos[3] ~= p then
			UIDropDownMenu_Initialize(relPointDropDownButton, relPointDropDown_MenuInit)
			UIDropDownMenu_SetSelectedValue(relPointDropDownButton, p)
			fe.opt.pos[3] = p
			fe:WritePoint()
		end
	end)
	
	
	
	local relToLabel = fe:CreateFontString()
	relToLabel:SetFontObject("GameFontNormalSmall")
	relToLabel:SetWidth(leftColumnWidth)
	relToLabel:SetHeight(18)
	--relToLabel:SetJustifyH("LEFT")
	relToLabel:SetPoint("TOPLEFT", relPointLabel, "BOTTOMLEFT", 0, -15)
	relToLabel:SetText("of")
	
	local relToEdit = CreateFrame("EditBox", fn.."RelToEdit", fe, "InputBoxTemplate")
	
	local relToFunc = function(self)
		self = self or relToEdit
		local value = self:GetText()
		
		if value == "" then
			if fe.opt and fe.opt.pos then
				self:SetText(fe.opt.pos[2])
			else
				local p = MovAny:GetFirstOrgPoint(fe:VerifyOpt())
				p = p[2]
				self:SetText(p)
			end
		elseif _G[value] then
			fe:VerifyOpt()
			if not fe.opt.orgPos and fe.editFrame then
				MovAny:StoreOrgPoints(fe.editFrame, fe.opt)
			end
			local updateEditor
			if not fe.opt.pos then
				fe.opt.pos = MovAny:GetRelativePoint(MovAny:GetFirstOrgPoint(fe.opt), fe)
				updateEditor = true
			end
			if fe.opt.pos[2] ~= value then
				fe.opt.pos[2] = value
				fe:WritePoint(updateEditor)
			end
		else
			maPrint(string.format(MOVANY.ELEMENT_NOT_FOUND_NAMED, value))
		end
		
		self:ClearFocus()
	end
	
	local relToEscapeFunc = function(self)
		local value = self:GetText()
		if _G[value] then
			fe:VerifyOpt()
			if not fe.opt.orgPos and fe.editFrame then
				MovAny:StoreOrgPoints(fe.editFrame, fe.opt)
			end
			local updateEditor
			if not fe.opt.pos then
				fe.opt.pos = MovAny:GetRelativePoint(MovAny:GetFirstOrgPoint(fe.opt), fe)
				updateEditor = true
			end
			if fe.opt.pos[2] ~= value then
				fe.opt.pos[2] = value
				fe:WritePoint(updateEditor)
			end
		else
			if fe.opt and fe.opt.pos then
				self:SetText(fe.opt.pos[2])
			else
				local p = MovAny:GetFirstOrgPoint(fe:VerifyOpt())
				p = p[2]
				self:SetText(p)
			end
		end
		self:ClearFocus()
	end
	
	relToEdit:SetFontObject("GameFontHighlightSmall")
	relToEdit:SetWidth(300)
	relToEdit:SetHeight(20)
	relToEdit:SetJustifyH("LEFT")
	relToEdit:SetAutoFocus(false)
	relToEdit:SetPoint("TOPLEFT", relToLabel, "TOPRIGHT", 10, 0)
	relToEdit:SetScript("OnTabPressed", relToFunc)
	relToEdit:SetScript("OnEnterPressed", relToFunc)
	relToEdit:SetScript("OnEscapePressed", relToEscapeFunc)
	
	
	local relToResetButton = CreateFrame("Button", fn.."RelToResetButton", fe, "MAButtonTemplate")
	relToResetButton:SetWidth(20)
	relToResetButton:SetHeight(20)
	relToResetButton:SetPoint("TOPLEFT", relToEdit, "TOPRIGHT", 7, 0)
	relToResetButton:SetText("R")
	relToResetButton:SetScript("OnClick", function()
		local p = MovAny:GetFirstOrgPoint(fe:VerifyOpt())
		if not p then
			return
		end
		p = p[2]

		if relToEdit:GetText() ~= p then
			relToEdit:SetText(p)
			relToFunc()
		end
	end)
	
	
	local xLabel = fe:CreateFontString()
	xLabel:SetFontObject("GameFontNormalSmall")
	xLabel:SetWidth(leftColumnWidth)
	xLabel:SetHeight(18)
	xLabel:SetJustifyH("LEFT")
	xLabel:SetPoint("TOPLEFT", relToLabel, "BOTTOMLEFT", 0, -13)
	xLabel:SetText("X offset")
	
	
	local xEdit = CreateFrame("EditBox", fn.."XEdit", fe, "InputBoxTemplate")
	
	local xSlider = CreateFrame("Slider", fn.."XSlider", fe, "OptionsSliderTemplate")
	
	xEdit:SetFontObject("GameFontHighlightSmall")
	xEdit:SetMaxLetters(10)
	xEdit:SetWidth(59)
	xEdit:SetHeight(20)
	xEdit:SetJustifyH("CENTER")
	xEdit:SetAutoFocus(false)
	xEdit:SetPoint("TOPLEFT", xLabel, "TOPRIGHT", 10, 0)
	xEdit:SetText("0")
	
	local xSliderFunc
	local xEditFunc = function(self)
		self:ClearFocus()
		
		local v = tonumber(xEdit:GetText())
		if v == nil then
			return
		end
		
		xSlider:SetScript("OnValueChanged", nil)
		xSlider:SetMinMaxValues(v - 200, v + 200)
		xSlider:SetValue(v)
		
		v = numfor(v)
		_G[xSlider:GetName().."Low"]:SetText(v - 200)
		_G[xSlider:GetName().."High"]:SetText(v + 200)
		_G[xSlider:GetName().."Text"]:SetText(v)
		
		xSlider:SetScript("OnValueChanged", xSliderFunc)
		
		if fe.updating then
			return
		end
		fe:VerifyOpt()
		if not fe.opt.orgPos and fe.editFrame then
			MovAny:StoreOrgPoints(fe.editFrame, fe.opt)
		end
		local updateEditor
		if not fe.opt.pos then
			fe.opt.pos = MovAny:GetRelativePoint(MovAny:GetFirstOrgPoint(fe.opt), fe)
			updateEditor = true
		end
		if fe.opt.pos[4] ~= tonumber(xEdit:GetText()) then
			fe.opt.pos[4] = tonumber(xEdit:GetText())
			fe:WritePoint(updateEditor)
		end
	end
	xEdit:SetScript("OnEnterPressed", xEditFunc)
	xEdit:SetScript("OnTabPressed", xEditFunc)
	xEdit:SetScript("OnEscapePressed", funcClearFocus)
	
	xSlider:SetScale(.75)
	xSlider:SetWidth(535)
	xSlider:SetMinMaxValues(-200, 200)
	xSlider:SetValue(0)
	xSlider:SetValueStep(1)
	xSlider:SetPoint("TOPLEFT", xEdit, "TOPRIGHT", 10, -2)
	xSlider:SetScript("OnMouseUp", function(self)
		local v = numfor(xSlider:GetValue())
		xSlider:SetScript("OnValueChanged", nil)
		xSlider:SetMinMaxValues(v - 200, v + 200)
		xSlider:SetScript("OnValueChanged", xSliderFunc)
		_G[xSlider:GetName().."Low"]:SetText(v - 200)
		_G[xSlider:GetName().."High"]:SetText(v + 200)
		_G[xSlider:GetName().."Text"]:SetText(v)
	end)
	xSliderFunc = function(self)
		local v = numfor(xSlider:GetValue())
		_G[xSlider:GetName().."Text"]:SetText(v)
		
		xEdit:SetText(numfor(xSlider:GetValue()))
		
		if fe.updating then
			return
		end
		fe:VerifyOpt()
		if not fe.opt.orgPos and fe.editFrame then
			MovAny:StoreOrgPoints(fe.editFrame, fe.opt)
		end
		local updateEditor
		if not fe.opt.pos then
			fe.opt.pos = MovAny:GetRelativePoint(MovAny:GetFirstOrgPoint(fe.opt), fe)
			updateEditor = true
		end
		if fe.opt.pos[4] ~= xSlider:GetValue() then
			fe.opt.pos[4] = xSlider:GetValue()
			fe:WritePoint(updateEditor)
		end
	end
	xSlider:SetScript("OnValueChanged", xSliderFunc)
	
	
	local xResetButton = CreateFrame("Button", fn.."XResetButton", fe, "MAButtonTemplate")
	xResetButton:SetWidth(20)
	xResetButton:SetHeight(20)
	xResetButton:SetPoint("TOPLEFT", xSlider, "TOPRIGHT", 12, 2)
	xResetButton:SetText("R")
	xResetButton:SetScript("OnClick", function()
		local p = MovAny:GetFirstOrgPoint(fe:VerifyOpt())
		if not p then
			return
		end
		p = p[4]
		
		xSlider:SetScript("OnValueChanged", nil)
		xSlider:SetMinMaxValues(p-200, p+200)
		xSlider:SetScript("OnValueChanged", xSliderFunc)
		xSlider:SetValue(p)
	end)
	
	
	local xZeroButton = CreateFrame("Button", fn.."XZeroButton", fe, "MAButtonTemplate")
	xZeroButton:SetWidth(20)
	xZeroButton:SetHeight(20)
	xZeroButton:SetPoint("TOPLEFT", xResetButton, "TOPRIGHT", 5, 0)
	xZeroButton:SetText("0")
	xZeroButton:SetScript("OnClick", function()
		xSlider:SetScript("OnValueChanged", nil)
		xSlider:SetMinMaxValues(-200, 200)
		xSlider:SetScript("OnValueChanged", xSliderFunc)
		xSlider:SetValue(0)
	end)
	
	
	local yLabel = fe:CreateFontString()
	yLabel:SetFontObject("GameFontNormalSmall")
	yLabel:SetWidth(leftColumnWidth)
	yLabel:SetHeight(18)
	yLabel:SetJustifyH("LEFT")
	yLabel:SetPoint("TOPLEFT", xLabel, "BOTTOMLEFT", 0, -13)
	yLabel:SetText("Y offset")
	
	
	local yEdit = CreateFrame("EditBox", fn.."YEdit", fe, "InputBoxTemplate")
	
	local ySlider = CreateFrame("Slider", fn.."YSlider", fe, "OptionsSliderTemplate")
	
	yEdit:SetFontObject("GameFontHighlightSmall")
	yEdit:SetMaxLetters(10)
	yEdit:SetWidth(59)
	yEdit:SetHeight(20)
	yEdit:SetJustifyH("CENTER")
	yEdit:SetAutoFocus(false)
	yEdit:SetPoint("TOPLEFT", yLabel, "TOPRIGHT", 10, 0)
	yEdit:SetText("0")
	local ySliderFunc
	local yEditFunc = function(self)
		self:ClearFocus()
		
		local v = tonumber(yEdit:GetText())
		if not v then
			return
		end
		
		ySlider:SetScript("OnValueChanged", nil)
		ySlider:SetMinMaxValues(v - 200, v + 200)
		ySlider:SetValue(v)
		
		v = numfor(v)
		_G[ySlider:GetName().."Low"]:SetText(v - 200)
		_G[ySlider:GetName().."High"]:SetText(v + 200)
		_G[ySlider:GetName().."Text"]:SetText(v)
		
		ySlider:SetScript("OnValueChanged", ySliderFunc)
		
		if fe.updating then
			return
		end
		fe:VerifyOpt()
		if not fe.opt.orgPos and fe.editFrame then
			MovAny:StoreOrgPoints(fe.editFrame, fe.opt)
		end
		local updateEditor
		if not fe.opt.pos then
			fe.opt.pos = MovAny:GetRelativePoint(MovAny:GetFirstOrgPoint(fe.opt), fe)
			updateEditor = true
		end
		if fe.opt.pos[5] ~= tonumber(yEdit:GetText()) then
			fe.opt.pos[5] = tonumber(yEdit:GetText())
			fe:WritePoint(updateEditor)
		end
	end
	yEdit:SetScript("OnEnterPressed", yEditFunc)
	yEdit:SetScript("OnTabPressed", yEditFunc)
	yEdit:SetScript("OnEscapePressed", funcClearFocus)
	
	ySlider:SetScale(.75)
	ySlider:SetWidth(535)
	ySlider:SetMinMaxValues(-200, 200)
	ySlider:SetValue(0)
	ySlider:SetValueStep(1)
	ySlider:SetPoint("TOPLEFT", yEdit, "TOPRIGHT", 10, -2)
	ySlider:SetScript("OnMouseUp", function(self)
		local v = numfor(ySlider:GetValue())
		ySlider:SetScript("OnValueChanged", nil)
		ySlider:SetMinMaxValues(v - 200, v + 200)
		ySlider:SetScript("OnValueChanged", ySliderFunc)
		_G[ySlider:GetName().."Low"]:SetText(v - 200)
		_G[ySlider:GetName().."High"]:SetText(v + 200)
		_G[ySlider:GetName().."Text"]:SetText(v)
	end)
	
	ySliderFunc = function(self)
		local v = numfor(ySlider:GetValue())
		_G[ySlider:GetName().."Text"]:SetText(v)
		
		yEdit:SetText(numfor(ySlider:GetValue()))
		
		if fe.updating then
			return
		end
		fe:VerifyOpt()
		if not fe.opt.orgPos and fe.editFrame then
			MovAny:StoreOrgPoints(fe.editFrame, fe.opt)
		end
		local updateEditor
		if not fe.opt.pos then
			fe.opt.pos = MovAny:GetRelativePoint(MovAny:GetFirstOrgPoint(fe.opt), fe)
			updateEditor = true
		end
		if fe.opt.pos[5] ~= self:GetValue() then
			fe.opt.pos[5] = self:GetValue()
			fe:WritePoint(updateEditor)
		end
	end
	ySlider:SetScript("OnValueChanged", ySliderFunc)
	
	
	local yResetButton = CreateFrame("Button", fn.."YResetButton", fe, "MAButtonTemplate")
	yResetButton:SetWidth(20)
	yResetButton:SetHeight(20)
	yResetButton:SetPoint("TOPLEFT", ySlider, "TOPRIGHT", 12, 2)
	yResetButton:SetText("R")
	yResetButton:SetScript("OnClick", function()
		local p = MovAny:GetFirstOrgPoint(fe:VerifyOpt())
		if not p then
			return
		end
		p = p[5]
		
		ySlider:SetScript("OnValueChanged", nil)
		ySlider:SetMinMaxValues(p-200, p+200)
		ySlider:SetScript("OnValueChanged", ySliderFunc)
		ySlider:SetValue(p)
	end)
	
	
	local yZeroButton = CreateFrame("Button", fn.."YZeroButton", fe, "MAButtonTemplate")
	yZeroButton:SetWidth(20)
	yZeroButton:SetHeight(20)
	yZeroButton:SetPoint("TOPLEFT", yResetButton, "TOPRIGHT", 5, 0)
	yZeroButton:SetText("0")
	yZeroButton:SetScript("OnClick", function()
		ySlider:SetScript("OnValueChanged", nil)
		ySlider:SetMinMaxValues(-200, 200)
		ySlider:SetScript("OnValueChanged", ySliderFunc)
		ySlider:SetValue(0)
	end)
	
	
	local widthLabel = fe:CreateFontString()
	widthLabel:SetFontObject("GameFontNormalSmall")
	widthLabel:SetWidth(leftColumnWidth)
	widthLabel:SetHeight(18)
	widthLabel:SetJustifyH("LEFT")
	widthLabel:SetPoint("TOPLEFT", yLabel, "BOTTOMLEFT", 0, -13)
	widthLabel:SetText("Width")
	
	
	local widthEdit = CreateFrame("EditBox", fn.."WidthEdit", fe, "InputBoxTemplate")
	
	local widthSlider = CreateFrame("Slider", fn.."WidthSlider", fe, "OptionsSliderTemplate")
	
	widthEdit:SetFontObject("GameFontHighlightSmall")
	widthEdit:SetMaxLetters(10)
	widthEdit:SetWidth(59)
	widthEdit:SetHeight(20)
	widthEdit:SetJustifyH("CENTER")
	widthEdit:SetAutoFocus(false)
	widthEdit:SetPoint("TOPLEFT", widthLabel, "TOPRIGHT", 10, 0)
	widthEdit:SetText("0")
	local widthSliderFunc
	local widthEditFunc = function(self)
		self:ClearFocus()
		local v = tonumber(widthEdit:GetText())
		if v == nil or v < 1 then
			return
		end
		
		
		local lowV = v - 200
		if lowV < 1 then
			lowV = 1
		end
		widthSlider:SetScript("OnValueChanged", nil)
		widthSlider:SetMinMaxValues(lowV, lowV + 400)
		widthSlider:SetValue(v)
		widthSlider:SetScript("OnValueChanged", widthSliderFunc)
		v = numfor(v)
		_G[widthSlider:GetName().."Low"]:SetText(numfor(lowV))
		_G[widthSlider:GetName().."High"]:SetText(numfor(lowV + 400))
		_G[widthSlider:GetName().."Text"]:SetText(v)
		
		if fe.updating then
			return
		end
		fe:VerifyOpt()
		
		fe:WriteDimentions()
	end
	
	widthEdit:SetScript("OnEnterPressed", widthEditFunc)
	widthEdit:SetScript("OnTabPressed", widthEditFunc)
	widthEdit:SetScript("OnEscapePressed", funcClearFocus)
	
	widthSlider:SetScale(.75)
	widthSlider:SetWidth(535)
	widthSlider:SetMinMaxValues(-200, 200)
	widthSlider:SetValue(0)
	widthSlider:SetValueStep(1)
	widthSlider:SetPoint("TOPLEFT", widthEdit, "TOPRIGHT", 10, -2)
	widthSlider:SetScript("OnMouseUp", function(self)
		local v = widthSlider:GetValue()
		
		local lowV = v - 200
		if lowV < 1 then
			lowV = 1
		end
		v = numfor(v)
		widthSlider:SetMinMaxValues(lowV, lowV + 400)
		_G[widthSlider:GetName().."Low"]:SetText(numfor(lowV))
		_G[widthSlider:GetName().."High"]:SetText(numfor(lowV + 400))
		_G[widthSlider:GetName().."Text"]:SetText(v)
	end)
	widthSliderFunc = function(self)
		local v = numfor(widthSlider:GetValue())
		_G[widthSlider:GetName().."Text"]:SetText(v)
		
		widthEdit:SetText(numfor(widthSlider:GetValue()))
		
		if fe.updating then
			return
		end
		fe:VerifyOpt()
		
		fe:WriteDimentions()
	end
	widthSlider:SetScript("OnValueChanged", widthSliderFunc)
	
	
	local widthResetButton = CreateFrame("Button", fn.."WidthResetButton", fe, "MAButtonTemplate")
	widthResetButton:SetWidth(20)
	widthResetButton:SetHeight(20)
	widthResetButton:SetPoint("TOPLEFT", widthSlider, "TOPRIGHT", 12, 2)
	widthResetButton:SetText("R")
	widthResetButton:SetScript("OnClick", function()
		local opt = fe:VerifyOpt()
		local p = opt.originalWidth
		if not p then
			return
		end
		
		local lowV = p - 200
		if lowV < 0 then
			lowV = 0
		end
		
		widthSlider:SetScript("OnValueChanged", nil)
		widthSlider:SetMinMaxValues(lowV, lowV + 400)
		widthSlider:SetScript("OnValueChanged", widthSliderFunc)
		widthSlider:SetValue(p)
		
		_G[heightSlider:GetName().."Low"]:SetText(numfor(lowV))
		_G[heightSlider:GetName().."High"]:SetText(numfor(lowV + 400))
	end)
	
	
	local heightLabel = fe:CreateFontString()
	heightLabel:SetFontObject("GameFontNormalSmall")
	heightLabel:SetWidth(leftColumnWidth)
	heightLabel:SetHeight(18)
	heightLabel:SetJustifyH("LEFT")
	heightLabel:SetPoint("TOPLEFT", widthLabel, "BOTTOMLEFT", 0, -13)
	heightLabel:SetText("Height")
	
	
	local heightEdit = CreateFrame("EditBox", fn.."HeightEdit", fe, "InputBoxTemplate")
	
	local heightSlider = CreateFrame("Slider", fn.."HeightSlider", fe, "OptionsSliderTemplate")
	
	heightEdit:SetFontObject("GameFontHighlightSmall")
	heightEdit:SetMaxLetters(10)
	heightEdit:SetWidth(59)
	heightEdit:SetHeight(20)
	heightEdit:SetJustifyH("CENTER")
	heightEdit:SetAutoFocus(false)
	heightEdit:SetPoint("TOPLEFT", heightLabel, "TOPRIGHT", 10, 0)
	heightEdit:SetText("0")
	local heightSliderFunc
	local heightEditFunc = function(self)
		self:ClearFocus()
		local v = tonumber(heightEdit:GetText())
		if v == nil or v < 1 then
			return
		end

		local lowV = v - 200
		if lowV < 1 then
			lowV = 1
		end
		heightSlider:SetScript("OnValueChanged", nil)
		heightSlider:SetMinMaxValues(lowV, lowV + 400)
		heightSlider:SetValue(v)
		
		v = numfor(v)
		_G[heightSlider:GetName().."Low"]:SetText(numfor(lowV))
		_G[heightSlider:GetName().."High"]:SetText(numfor(lowV + 400))
		_G[heightSlider:GetName().."Text"]:SetText(v)
		heightSlider:SetScript("OnValueChanged", heightSliderFunc)
		if fe.updating then
			return
		end
		fe:VerifyOpt()
		
		fe:WriteDimentions()
	end
	
	heightEdit:SetScript("OnEnterPressed", heightEditFunc)
	heightEdit:SetScript("OnTabPressed", heightEditFunc)
	heightEdit:SetScript("OnEscapePressed", funcClearFocus)
	
	heightSlider:SetScale(.75)
	heightSlider:SetWidth(535)
	heightSlider:SetMinMaxValues(-200, 200)
	heightSlider:SetValue(0)
	heightSlider:SetValueStep(1)
	heightSlider:SetPoint("TOPLEFT", heightEdit, "TOPRIGHT", 10, -2)
	heightSlider:SetScript("OnMouseUp", function(self)
		local v = heightSlider:GetValue()
		
		local lowV = v - 200
		if lowV < 1 then
			lowV = 1
		end
		v = numfor(v)
		heightSlider:SetMinMaxValues(lowV, lowV + 400)
		_G[heightSlider:GetName().."Low"]:SetText(numfor(lowV))
		_G[heightSlider:GetName().."High"]:SetText(numfor(lowV + 400))
	end)
	
	heightSliderFunc = function(self)
		local v = numfor(heightSlider:GetValue())
		_G[heightSlider:GetName().."Text"]:SetText(v)
		
		heightEdit:SetText(numfor(heightSlider:GetValue()))
		
		if fe.updating then
			return
		end
		fe:VerifyOpt()
		
		fe:WriteDimentions()
	end
	heightSlider:SetScript("OnValueChanged", heightSliderFunc)
	
	
	local heightResetButton = CreateFrame("Button", fn.."HeightResetButton", fe, "MAButtonTemplate")
	heightResetButton:SetWidth(20)
	heightResetButton:SetHeight(20)
	heightResetButton:SetPoint("TOPLEFT", heightSlider, "TOPRIGHT", 12, 2)
	heightResetButton:SetText("R")
	heightResetButton:SetScript("OnClick", function()
		local opt = fe:VerifyOpt()
		local p = opt.originalHeight
		if not p then
			return
		end
		
		local lowV = p - 200
		if lowV < 1 then
			lowV = 1
		end
		
		heightSlider:SetScript("OnValueChanged", nil)
		heightSlider:SetMinMaxValues(lowV, lowV + 400)
		heightSlider:SetScript("OnValueChanged", heightSliderFunc)
		heightSlider:SetValue(p)
		local v = heightSlider:GetValue()
		
		_G[heightSlider:GetName().."Low"]:SetText(numfor(lowV))
		_G[heightSlider:GetName().."High"]:SetText(numfor(lowV + 400))
	end)
	
	
	local scaleLabel = fe:CreateFontString()
	scaleLabel:SetFontObject("GameFontNormalSmall")
	scaleLabel:SetWidth(leftColumnWidth)
	scaleLabel:SetHeight(20)
	scaleLabel:SetJustifyH("LEFT")
	scaleLabel:SetPoint("TOPLEFT", heightLabel, "BOTTOMLEFT", 0, -20)
	scaleLabel:SetText("Scale:")
	
	local scaleEdit = CreateFrame("EditBox", fn.."ScaleEdit", fe, "InputBoxTemplate")
	
	local scaleSlider = CreateFrame("Slider", fn.."ScaleSlider", fe, "OptionsSliderTemplate")
	
	scaleEdit:SetFontObject("GameFontHighlightSmall")
	scaleEdit:SetMaxLetters(6)
	scaleEdit:SetWidth(59)
	scaleEdit:SetHeight(20)
	scaleEdit:SetJustifyH("CENTER")
	scaleEdit:SetAutoFocus(false)
	scaleEdit:SetPoint("TOPLEFT", scaleLabel, "TOPRIGHT", 10, 0)
	scaleEdit:SetText("1")
	local scaleSliderFunc
	local scaleEditFunc = function(self)
		self:ClearFocus()
		local v = tonumber(self:GetText())
		if not v then
			return
		end
		_G[scaleSlider:GetName().."Text"]:SetText(v)
		
		scaleSlider:SetScript("OnValueChanged", nil)
		scaleSlider:SetValue(v)
		scaleSlider:SetScript("OnValueChanged", scaleSliderFunc)
		
		if fe.updating then
			return
		end
		fe:VerifyOpt()
		if fe.opt.scale ~= tonumber(self:GetText()) then
			fe.opt.scale = tonumber(self:GetText())
			fe:WriteScale()
		end
	end
	scaleEdit:SetScript("OnEnterPressed", scaleEditFunc)
	scaleEdit:SetScript("OnTabPressed", scaleEditFunc)
	scaleEdit:SetScript("OnEscapePressed", funcClearFocus)
	
	scaleSlider:SetScale(.75)
	scaleSlider:SetWidth(535)
	scaleSlider:SetMinMaxValues(0,10)
	scaleSlider:SetValue(1)
	scaleSlider:SetValueStep(.01)
	scaleSlider:SetPoint("TOPLEFT", scaleEdit, "TOPRIGHT", 10, -2)
	scaleSlider:SetScript("OnMouseUp", function(self)
		_G[self:GetName().."Text"]:SetText(numfor(self:GetValue(), 2))
	end)
	_G[scaleSlider:GetName().."Low"]:SetText("0")
	_G[scaleSlider:GetName().."High"]:SetText("10")
	
	scaleSliderFunc = function(self)
		if not self.GetValue then
			return
		end
		local v = numfor(self:GetValue(), 2)
		_G[self:GetName().."Text"]:SetText(v)
		
		scaleEdit:SetText(v)
		
		if fe.updating then
			return
		end
		fe:VerifyOpt()
		if fe.opt.scale ~= self:GetValue() then
			fe.opt.scale = self:GetValue()
			fe:WriteScale()
		end
	end
	scaleSlider:SetScript("OnValueChanged", scaleSliderFunc)
	
	
	local scaleResetButton = CreateFrame("Button", fn.."ScaleResetButton", fe, "MAButtonTemplate")
	scaleResetButton:SetWidth(20)
	scaleResetButton:SetHeight(20)
	scaleResetButton:SetPoint("TOPLEFT", scaleSlider, "TOPRIGHT", 12, 2)
	scaleResetButton:SetText("R")
	scaleResetButton:SetScript("OnClick", function()
		local opt = fe:VerifyOpt()
		local p = opt.originalScale
		if not p then
			return
		end
		scaleSlider:SetValue(p)
	end)
	
	
	local scaleOneButton = CreateFrame("Button", fn.."ScaleOneButton", fe, "MAButtonTemplate")
	scaleOneButton:SetWidth(20)
	scaleOneButton:SetHeight(20)
	scaleOneButton:SetPoint("TOPLEFT", scaleResetButton, "TOPRIGHT", 5, 0)
	scaleOneButton:SetText("1")
	scaleOneButton:SetScript("OnClick", function()
		scaleSlider:SetValue(1)
	end)
	
	
	local alphaLabel = fe:CreateFontString()
	alphaLabel:SetFontObject("GameFontNormalSmall")
	alphaLabel:SetWidth(leftColumnWidth)
	alphaLabel:SetHeight(20)
	alphaLabel:SetJustifyH("LEFT")
	alphaLabel:SetPoint("TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -2)
	alphaLabel:SetText("Alpha:")
	
	local alphaEdit = CreateFrame("EditBox", fn.."AlphaEdit", fe, "InputBoxTemplate")
	
	local alphaSlider = CreateFrame("Slider", fn.."AlphaSlider", fe, "OptionsSliderTemplate")
	
	alphaEdit:SetFontObject("GameFontHighlightSmall")
	alphaEdit:SetMaxLetters(5)
	alphaEdit:SetWidth(59)
	alphaEdit:SetHeight(20)
	alphaEdit:SetJustifyH("CENTER")
	alphaEdit:SetAutoFocus(false)
	alphaEdit:SetPoint("TOPLEFT", alphaLabel, "TOPRIGHT", 10, 0)
	alphaEdit:SetText("100")
	local alphaSliderFunc
	local alphaEditFunc = function(self)
		self:ClearFocus()
		local v = tonumber(self:GetText())
		if v == nil then
			return
		end
		if v > 100 then
			v = 100
			self:SetText(v)
		elseif v < 0 then
			v = 0
			self:SetText(v)
		end
		_G[alphaSlider:GetName().."Text"]:SetText(v.."%")
		
		alphaSlider:SetScript("OnValueChanged", nil)
		alphaSlider:SetValue(v / 100)
		alphaSlider:SetScript("OnValueChanged", alphaSliderFunc)
		
		if fe.updating then
			return
		end
		fe:WriteAlpha()
	end
	alphaEdit:SetScript("OnEnterPressed", alphaEditFunc)
	alphaEdit:SetScript("OnTabPressed", alphaEditFunc)
	alphaEdit:SetScript("OnEscapePressed", funcClearFocus)
	
	alphaSlider:SetScale(.75)
	alphaSlider:SetWidth(535)
	alphaSlider:SetMinMaxValues(0,1)
	alphaSlider:SetValue(1)
	alphaSlider:SetValueStep(.01)
	alphaSlider:SetPoint("TOPLEFT", alphaEdit, "TOPRIGHT", 10, -2)
	alphaSlider:SetScript("OnMouseUp", function(self)
		_G[self:GetName().."Text"]:SetText(numfor(alphaSlider:GetValue() * 100, 0).."%")
	end)
	
	alphaSliderFunc = function(self)
		local v = numfor(alphaSlider:GetValue() * 100, 0)
		_G[self:GetName().."Text"]:SetText(v.."%")
		alphaEdit:SetText(v)
		
		if fe.updating then
			return
		end
		fe:WriteAlpha()
	end
	alphaSlider:SetScript("OnValueChanged", alphaSliderFunc)
	_G[alphaSlider:GetName().."Low"]:SetText("0%")
	_G[alphaSlider:GetName().."High"]:SetText("100%")
	
	local alphaResetButton = CreateFrame("Button", fn.."AlphaResetButton", fe, "MAButtonTemplate")
	alphaResetButton:SetWidth(20)
	alphaResetButton:SetHeight(20)
	alphaResetButton:SetPoint("TOPLEFT", alphaSlider, "TOPRIGHT", 12, 2)
	alphaResetButton:SetText("R")
	alphaResetButton:SetScript("OnClick", function()
		local opt = fe:VerifyOpt()
		local p = opt.originalAlpha
		if not p then
			return
		end
		alphaSlider:SetValue(p)
	end)
	
	
	local alphaFullButton = CreateFrame("Button", fn.."AlphaFullButton", fe, "MAButtonTemplate")
	alphaFullButton:SetWidth(20)
	alphaFullButton:SetHeight(20)
	alphaFullButton:SetPoint("TOPLEFT", alphaResetButton, "TOPRIGHT", 5, 0)
	alphaFullButton:SetText("1")
	alphaFullButton:SetScript("OnClick", function()
		alphaSlider:SetValue(1)
	end)
	
	
	local hideArtworkCheck = CreateFrame("CheckButton", fn.."Hide", fe, "MACheckButtonTemplate")
	local hideBackgroundCheck = CreateFrame("CheckButton", fn.."Hide", fe, "MACheckButtonTemplate")
	local hideBorderCheck = CreateFrame("CheckButton", fn.."Hide", fe, "MACheckButtonTemplate")
	local hideHighlightCheck = CreateFrame("CheckButton", fn.."Hide", fe, "MACheckButtonTemplate")
	local hideOverlayCheck = CreateFrame("CheckButton", fn.."Hide", fe, "MACheckButtonTemplate")
	
	local hideLayerFunc = function(self)
		fe:VerifyOpt()
		
		MovAny:ResetLayers(fe.editFrame, fe.opt, true)
		
		if self == hideArtworkCheck then
			fe.opt.disableLayerArtwork = self:GetChecked()
		elseif self == hideBackgroundCheck then
			fe.opt.disableLayerBackground = self:GetChecked()
		elseif self == hideBorderCheck then
			fe.opt.disableLayerBorder = self:GetChecked()
		elseif self == hideHighlightCheck then
			fe.opt.disableLayerHighlight = self:GetChecked()
		elseif self == hideOverlayCheck then
			fe.opt.disableLayerOverlay = self:GetChecked()
		end
		
		MovAny:ApplyLayers(fe.editFrame, fe.opt)
	end
	
	
	local hideLayersHeading = fe:CreateFontString()
	hideLayersHeading:SetFontObject("GameFontNormalSmall")
	hideLayersHeading:SetWidth(85)
	hideLayersHeading:SetHeight(20)
	hideLayersHeading:SetJustifyH("LEFT")
	hideLayersHeading:SetPoint("TOPLEFT", alphaLabel, "BOTTOMLEFT", 0, -10)
	hideLayersHeading:SetText("Hide Layer")
	
	local layersResetButton = CreateFrame("Button", fn.."PointResetButton", fe, "MAButtonTemplate")
	layersResetButton:SetWidth(20)
	layersResetButton:SetHeight(20)
	layersResetButton:SetPoint("TOPLEFT", hideLayersHeading, "TOPRIGHT", 0, -1)
	layersResetButton:SetText("R")
	layersResetButton:SetScript("OnClick", function()
		local opt = fe:VerifyOpt()
		if fe.editFrame and opt then
			MovAny:ResetLayers(fe.editFrame, opt)
			hideArtworkCheck:SetChecked(nil)
			hideBackgroundCheck:SetChecked(nil)
			hideBorderCheck:SetChecked(nil)
			hideHighlightCheck:SetChecked(nil)
			hideOverlayCheck:SetChecked(nil)
		end
	end)
	
	hideArtworkCheck:SetWidth(20)
	hideArtworkCheck:SetHeight(20)
	hideArtworkCheck:SetPoint("TOPLEFT", hideLayersHeading, "BOTTOMLEFT", 4, -2)
	hideArtworkCheck:SetScript("OnClick", hideLayerFunc)
	
	local hideArtworkLabel = fe:CreateFontString()
	hideArtworkLabel:SetFontObject("GameFontNormalSmall")
	--hideArtworkLabel:SetWidth(leftColumnWidth)
	hideArtworkLabel:SetHeight(16)
	hideArtworkLabel:SetJustifyH("LEFT")
	hideArtworkLabel:SetPoint("TOPLEFT", hideArtworkCheck, "TOPRIGHT", 3, 0)
	hideArtworkLabel:SetText("Artwork")
	
	
	hideBackgroundCheck:SetWidth(20)
	hideBackgroundCheck:SetHeight(20)
	hideBackgroundCheck:SetPoint("TOPLEFT", hideArtworkCheck, "BOTTOMLEFT", 0, -1)
	hideBackgroundCheck:SetScript("OnClick", hideLayerFunc)
	
	local hideBackgroundLabel = fe:CreateFontString()
	hideBackgroundLabel:SetFontObject("GameFontNormalSmall")
	--hideBackgroundLabel:SetWidth(leftColumnWidth)
	hideBackgroundLabel:SetHeight(16)
	hideBackgroundLabel:SetJustifyH("LEFT")
	hideBackgroundLabel:SetPoint("TOPLEFT", hideBackgroundCheck, "TOPRIGHT", 3, 0)
	hideBackgroundLabel:SetText("Background")
	
	
	hideBorderCheck:SetWidth(20)
	hideBorderCheck:SetHeight(20)
	hideBorderCheck:SetPoint("TOPLEFT", hideBackgroundCheck, "BOTTOMLEFT", 0, -1)
	hideBorderCheck:SetScript("OnClick", hideLayerFunc)
	
	local hideBorderLabel = fe:CreateFontString()
	hideBorderLabel:SetFontObject("GameFontNormalSmall")
	--hideBorderLabel:SetWidth(leftColumnWidth)
	hideBorderLabel:SetHeight(16)
	hideBorderLabel:SetJustifyH("LEFT")
	hideBorderLabel:SetPoint("TOPLEFT", hideBorderCheck, "TOPRIGHT", 3, 0)
	hideBorderLabel:SetText("Border")
	
	
	hideHighlightCheck:SetWidth(20)
	hideHighlightCheck:SetHeight(20)
	hideHighlightCheck:SetPoint("TOPLEFT", hideBorderCheck, "BOTTOMLEFT", 0, -1)
	hideHighlightCheck:SetScript("OnClick", hideLayerFunc)
	
	local hideHighlightLabel = fe:CreateFontString()
	hideHighlightLabel:SetFontObject("GameFontNormalSmall")
	--hideHighlightLabel:SetWidth(leftColumnWidth)
	hideHighlightLabel:SetHeight(16)
	hideHighlightLabel:SetJustifyH("LEFT")
	hideHighlightLabel:SetPoint("TOPLEFT", hideHighlightCheck, "TOPRIGHT", 3, 0)
	hideHighlightLabel:SetText("Highlight")
	
	
	hideOverlayCheck:SetWidth(20)
	hideOverlayCheck:SetHeight(20)
	hideOverlayCheck:SetPoint("TOPLEFT", hideHighlightCheck, "BOTTOMLEFT", 0, -1)
	hideOverlayCheck:SetScript("OnClick", hideLayerFunc)
	
	local hideOverlayLabel = fe:CreateFontString()
	hideOverlayLabel:SetFontObject("GameFontNormalSmall")
	--hideOverlayLabel:SetWidth(leftColumnWidth)
	hideOverlayLabel:SetHeight(16)
	hideOverlayLabel:SetJustifyH("LEFT")
	hideOverlayLabel:SetPoint("TOPLEFT", hideOverlayCheck, "TOPRIGHT", 3, 0)
	hideOverlayLabel:SetText("Overlay")
	
	
	local strataLabel = fe:CreateFontString()
	strataLabel:SetFontObject("GameFontNormalSmall")
	strataLabel:SetWidth(leftColumnWidth)
	strataLabel:SetHeight(20)
	strataLabel:SetJustifyH("LEFT")
	strataLabel:SetPoint("TOPLEFT", layersResetButton, "TOPRIGHT", 30, 0)
	strataLabel:SetText("Strata:")
	
	local strataDropDownButton = CreateFrame("Button", fn.."Strata", fe, "UIDropDownMenuTemplate")
	strataDropDownButton:SetID(3)
	strataDropDownButton:SetScript("OnClick", dropDownClickFunc)
	
	local strataFunc = function(self)
		UIDropDownMenu_SetSelectedValue(strataDropDownButton, self.value)
		
		local opt = fe:VerifyOpt()
		if opt.frameStrata ~= self.value then
			opt.frameStrata = self.value
			
			local editFrame = fe.editFrame
			if editFrame then
				if not opt.orgFrameStrata then
					opt.orgFrameStrata = editFrame:GetFrameStrata()
				end
				if not InCombatLockdown() or not MovAny:IsProtected(editFrame) then
					editFrame:SetFrameStrata(opt.frameStrata)
				else
					local closure = function(f, fs)
						return function()
							if MovAny:IsProtected(f) and InCombatLockdown() then
								return true
							end
							f:SetFrameStrata(fs)
						end
					end
					MovAny.pendingActions[fe.o.name..":SetFrameStrata"] = closure(editFrame, opt.frameStrata)
				end
			end
		end
	end
	
	local strataDropDown_MenuInit = function()
		local frameStrata = (fe.opt and fe.opt.frameStrata) or (fe.editFrame and fe.editFrame:GetFrameStrata()) or nil
		
		local info
		for _, infoTab in pairs(MovAny.DDMStrataList) do
			info = UIDropDownMenu_CreateInfo()
			info.text = infoTab.text
			info.value = infoTab.value
			info.func = strataFunc
			
			
			if frameStrata == infoTab.value then
				info.checked = true
			end
			UIDropDownMenu_AddButton(info)
		end
	end
	
	strataDropDownButton:SetPoint("TOPLEFT", strataLabel, "TOPRIGHT", -12, 1)
	UIDropDownMenu_Initialize(strataDropDownButton, strataDropDown_MenuInit)
	UIDropDownMenu_SetWidth(strataDropDownButton, 130)
	--[[
	strataDropDownButton:SetScript("OnClick", function()
		ToggleDropDownMenu(1, nil, nil, strataDropDownButton, 0, 0, nil, strataDropDownButton)
	end)
	]]
	
		
	local strataResetButton = CreateFrame("Button", fn.."StrataResetButton", fe, "MAButtonTemplate")
	strataResetButton:SetWidth(20)
	strataResetButton:SetHeight(20)
	strataResetButton:SetPoint("TOPLEFT", strataDropDownButton, "TOPRIGHT", 0, -2.5)
	strataResetButton:SetText("R")
	strataResetButton:SetScript("OnClick", function()
		local opt = fe:VerifyOpt()
		local fs = opt.orgFrameStrata
		local editFrame = fe.editFrame
		if not fs then
			return
		end
		

		if strataDropDownButton:GetText() ~= fs then
			if editFrame then
				if not InCombatLockdown() or not MovAny:IsProtected(editFrame) then
					editFrame:SetFrameStrata(fs)
				else
					local closure = function(f, fs)
						return function()
							if MovAny:IsProtected(f) and InCombatLockdown() then
								return true
							end
							f:SetFrameStrata(fs)
						end
					end
					MovAny.pendingActions[fe.o.name..":SetFrameStrata"] = closure(editFrame, fs)
				end
			end
			opt.frameStrata = fs
			
			UIDropDownMenu_Initialize(strataDropDownButton, strataDropDown_MenuInit)
			UIDropDownMenu_SetSelectedValue(strataDropDownButton, fs)
			
			opt.orgFrameStrata = nil
			opt.frameStrata = nil
		end
	end)
	
	
	local revertButton = CreateFrame("Button", fn.."RevertButton", fe, "MAButtonTemplate")
	revertButton:SetWidth(75)
	revertButton:SetHeight(22)
	revertButton:SetPoint("TOPLEFT", strataResetButton, "TOPRIGHT", 25, 0)
	revertButton:SetText("Revert")
	revertButton.tooltipText = "Reverts the frame to the modifications it had when this editor was opened."
	revertButton:SetScript("OnClick", function()
		if fe.editFrame and (InCombatLockdown() and MovAny:IsProtected(fe.editFrame)) then
			maPrint(string.format(MOVANY.FRAME_PROTECTED_DURING_COMBAT, fe.o.name))
		else
			if fe.editFrame then
				MovAny:ResetAll(fe.editFrame, MovAny:GetFrameOptions(fe.o.name), true)
			end
			local opt = tdeepcopy(fe.initialOpt)
			MovAny.frameOptions[fe.o.name] = opt
			fe.opt = opt
			MovAny:SyncFrame(fe.o.name, opt, true)
			fe:UpdateEditor()
		end
	end)
	
	
	local resetButton = CreateFrame("Button", fn.."ResetButton", fe, "MAButtonTemplate")
	resetButton:SetWidth(75)
	resetButton:SetHeight(22)
	resetButton:SetPoint("TOPLEFT", revertButton, "BOTTOMLEFT", 0, -10)
	resetButton:SetText("Reset")
	resetButton.tooltipText = "Resets the frame, undoing all modifications you have made with MoveAnything."
	resetButton:SetScript("OnClick", function()
		if not fe.editFrame then
			return
		end
		
		MovAny:ResetFrameConfirm(fe.o.name)
	end)
	
	
	local exportButton = CreateFrame("Button", fn.."ExportButton", fe, "MAButtonTemplate")
	exportButton:SetWidth(75)
	exportButton:SetHeight(22)
	exportButton:SetPoint("TOPLEFT", resetButton, "BOTTOMLEFT", 0, -10)
	exportButton:SetText("Export")
	exportButton:Disable()
	exportButton.tooltipText = "Not yet implemented."
	exportButton:SetScript("OnClick", function() end)
	
	
	local syncButton = CreateFrame("Button", fn.."SyncButton", fe, "MAButtonTemplate")
	syncButton:SetWidth(75)
	syncButton:SetHeight(22)
	syncButton:SetPoint("TOPLEFT", exportButton, "BOTTOMLEFT", 0, -10)
	syncButton:SetText("Sync")
	syncButton:Disable()
	syncButton.tooltipText = "Synchronize the frame with all modifications made in MoveAnything."
	syncButton:SetScript("OnClick", function()
		if fe.editFrame then
			MovAny:SyncFrame(fe.o.name)
		end
	end)
	
	
	local moverButton = CreateFrame("Button", fn.."MoverButton", fe, "MAButtonTemplate")
	moverButton:SetWidth(75)
	moverButton:SetHeight(22)
	moverButton:SetPoint("TOPLEFT", revertButton, "TOPRIGHT", 10, 0)
	moverButton:SetText("Mover")
	moverButton.tooltipText = "Toggles a mover on/off for the frame."
	moverButton:SetScript("OnClick", function(self)
		MovAny:ToggleMove(fe.o.name)
		fe:UpdateButtons()
	end)
	
	
	local showButton = CreateFrame("Button", fn.."ShowButton", fe, "MAButtonTemplate")
	showButton:SetWidth(75)
	showButton:SetHeight(22)
	showButton:SetPoint("TOPLEFT", moverButton, "BOTTOMLEFT", 0, -10)
	showButton:SetText("Show")
	showButton.tooltipText = "Toggles visibility of the frame, any change is not permanent. For permanent hiding use the \"Hidden\" checkbox."
	showButton:SetScript("OnClick", function(self)
		local opt = fe.opt
		local f = fe.editFrame
		if not f then
			return
		end
		if not MovAny:IsProtected(f) or not InCombatLockdown() then
			if f:IsShown() then
				if (opt and opt.UIPanelWindows) or UIPanelWindows[ f:GetName() ] then
					HideUIPanel(f)
				else
					f:Hide()
				end
			else
				if (opt and opt.UIPanelWindows) or UIPanelWindows[ f:GetName() ] then
					ShowUIPanel(f)
				else
					f:Show()
				end
			end
			fe:UpdateButtons()
		else
			maPrint(string.format(MOVANY.FRAME_PROTECTED_DURING_COMBAT, f:GetName()))
		end
	end)
	
	
	local importButton = CreateFrame("Button", fn.."ImportButton", fe, "MAButtonTemplate")
	importButton:SetWidth(75)
	importButton:SetHeight(22)
	importButton:SetPoint("TOPLEFT", showButton, "BOTTOMLEFT", 0, -10)
	importButton:SetText("Import")
	importButton:Disable()
	importButton.tooltipText = "Not yet implemented."
	importButton:SetScript("OnClick", function() end)
	
	
	
	local actualsHeading = fe:CreateFontString()
	actualsHeading:SetFontObject("GameFontNormalSmall")
	actualsHeading:SetWidth(140)
	actualsHeading:SetHeight(20)
	actualsHeading:SetJustifyH("LEFT")
	actualsHeading:SetPoint("TOPRIGHT", fe, "TOPRIGHT", -25, -4)
	actualsHeading:SetText("Absolute values")
	
	local infoTextWidthLabel = fe:CreateFontString()
	infoTextWidthLabel:SetFontObject("GameFontNormalSmall")
	infoTextWidthLabel:SetWidth(leftColumnWidth)
	infoTextWidthLabel:SetHeight(16)
	infoTextWidthLabel:SetJustifyH("RIGHT")
	infoTextWidthLabel:SetPoint("TOPLEFT", actualsHeading, "BOTTOMLEFT", -55, -1)
	infoTextWidthLabel:SetText("Width:")
	
	local infoTextWidth = fe:CreateFontString()
	infoTextWidth:SetFontObject("GameFontNormalSmall")
	infoTextWidth:SetWidth(60)
	infoTextWidth:SetHeight(16)
	infoTextWidth:SetJustifyH("LEFT")
	infoTextWidth:SetPoint("TOPLEFT", infoTextWidthLabel, "TOPRIGHT", 3, 0)
	
	
	local infoTextXLabel = fe:CreateFontString()
	infoTextXLabel:SetFontObject("GameFontNormalSmall")
	infoTextXLabel:SetWidth(leftColumnWidth)
	infoTextXLabel:SetHeight(16)
	infoTextXLabel:SetJustifyH("RIGHT")
	infoTextXLabel:SetPoint("TOPLEFT", infoTextWidthLabel, "BOTTOMLEFT", 0, -1)
	infoTextXLabel:SetText("X:")
	
	local infoTextX = fe:CreateFontString()
	infoTextX:SetFontObject("GameFontNormalSmall")
	infoTextX:SetWidth(60)
	infoTextX:SetHeight(16)
	infoTextX:SetJustifyH("LEFT")
	infoTextX:SetPoint("TOPLEFT", infoTextXLabel, "TOPRIGHT", 3, 0)
	
	
	local infoTextAlphaLabel = fe:CreateFontString()
	infoTextAlphaLabel:SetFontObject("GameFontNormalSmall")
	infoTextAlphaLabel:SetWidth(leftColumnWidth)
	infoTextAlphaLabel:SetHeight(16)
	infoTextAlphaLabel:SetJustifyH("RIGHT")
	infoTextAlphaLabel:SetPoint("TOPLEFT", infoTextXLabel, "BOTTOMLEFT", 0, -1)
	infoTextAlphaLabel:SetText("Alpha:")
	
	local infoTextAlpha = fe:CreateFontString()
	infoTextAlpha:SetFontObject("GameFontNormalSmall")
	infoTextAlpha:SetWidth(60)
	infoTextAlpha:SetHeight(16)
	infoTextAlpha:SetJustifyH("LEFT")
	infoTextAlpha:SetPoint("TOPLEFT", infoTextAlphaLabel, "TOPRIGHT", 3, 0)
	
	
	local infoTextHeightLabel = fe:CreateFontString()
	infoTextHeightLabel:SetFontObject("GameFontNormalSmall")
	infoTextHeightLabel:SetWidth(leftColumnWidth)
	infoTextHeightLabel:SetHeight(16)
	infoTextHeightLabel:SetJustifyH("RIGHT")
	infoTextHeightLabel:SetPoint("TOPLEFT", actualsHeading, "BOTTOMLEFT", 55, -1)
	infoTextHeightLabel:SetText("Height:")
	
	local infoTextHeight = fe:CreateFontString()
	infoTextHeight:SetFontObject("GameFontNormalSmall")
	infoTextHeight:SetWidth(60)
	infoTextHeight:SetHeight(16)
	infoTextHeight:SetJustifyH("LEFT")
	infoTextHeight:SetPoint("TOPLEFT", infoTextHeightLabel, "TOPRIGHT", 3, 0)
	
	
	local infoTextYLabel = fe:CreateFontString()
	infoTextYLabel:SetFontObject("GameFontNormalSmall")
	infoTextYLabel:SetWidth(leftColumnWidth)
	infoTextYLabel:SetHeight(16)
	infoTextYLabel:SetJustifyH("RIGHT")
	infoTextYLabel:SetPoint("TOPLEFT", infoTextHeightLabel, "BOTTOMLEFT", 0, -1)
	infoTextYLabel:SetText("Y:")
	
	local infoTextY = fe:CreateFontString()
	infoTextY:SetFontObject("GameFontNormalSmall")
	infoTextY:SetWidth(60)
	infoTextY:SetHeight(16)
	infoTextY:SetJustifyH("LEFT")
	infoTextY:SetPoint("TOPLEFT", infoTextYLabel, "TOPRIGHT", 3, 0)
	
	
	local infoTextScaleLabel = fe:CreateFontString()
	infoTextScaleLabel:SetFontObject("GameFontNormalSmall")
	infoTextScaleLabel:SetWidth(leftColumnWidth)
	infoTextScaleLabel:SetHeight(16)
	infoTextScaleLabel:SetJustifyH("RIGHT")
	infoTextScaleLabel:SetPoint("TOPLEFT", infoTextYLabel, "BOTTOMLEFT", 0, -1)
	infoTextScaleLabel:SetText("Scale:")
	
	local infoTextScale = fe:CreateFontString()
	infoTextScale:SetFontObject("GameFontNormalSmall")
	infoTextScale:SetWidth(60)
	infoTextScale:SetHeight(16)
	infoTextScale:SetJustifyH("LEFT")
	infoTextScale:SetPoint("TOPLEFT", infoTextScaleLabel, "TOPRIGHT", 3, 0)
	--[[
	
	Width
	Height
	Lock proportions
	
	
	]]
	
	fe.LoadFrame = function(self, name)
		if self.o then
			MovAny.frameEditors[self.o.name] = nil
		end
		
		self.editFrame = _G[name]
		self.opt = MovAny:GetFrameOptions(name, nil, true)
		self.o = MovAny:GetFrame(name)
		
		self.initialOpt = tdeepcopy(self.opt)
		
		MovAny.frameEditors[name] = self
		self:UpdateEditor()
	end
	
	fe.UpdateEditor = function()
		fe.updating = true
		
		local o = fe.o
		local fn = o.name
		local opt = MovAny:GetFrameOptions(fn)
		fe.opt = opt
		local editFrame = fe.editFrame
		
		local frameHeight = 460
		
		realName:SetText(fn)
		helpfulName:SetText(o.helpfulName)
		
		enabledCheck:SetChecked(not opt or not opt.disabled)
		
		if not MovAny.NoHide[fn] then
			hideLabel:Show()
			hideCheck:Show()
			hideCheck:SetChecked(opt and opt.hidden)
		else
			hideLabel:Hide()
			hideCheck:Hide()
		end
		
		if not editFrame or editFrame.SetClampedToScreen then
			clampToScreenCheck:Show()
			clampToScreenLabel:Show()
			clampToScreenCheck:SetChecked((opt and opt.clampToScreen) or (editFrame and editFrame:IsClampedToScreen()))
		else
			clampToScreenCheck:Hide()
			clampToScreenLabel:Hide()
		end
		
		
		local nextPoint = {"TOPLEFT", enabledCheck, "BOTTOMLEFT", -2, -4}
		
		if not MovAny.NoMove[fn] then
			pointLabel:SetPoint(unpack(nextPoint))
			nextPoint = {"TOPLEFT", yLabel, "BOTTOMLEFT", 0, -20}
			
			pointLabel:Show()
			pointDropDownButton:Show()
			pointResetButton:Show()
			relPointLabel:Show()
			relPointDropDownButton:Show()
			relPointResetButton:Show()
			relToLabel:Show()
			relToEdit:Show()
			relToResetButton:Show()
			xLabel:Show()
			xEdit:Show()
			xSlider:Show()
			xResetButton:Show()
			yLabel:Show()
			yEdit:Show()
			ySlider:Show()
			yResetButton:Show()
			
			local p
			if opt and opt.pos then
				p = opt.pos
			elseif editFrame then
				local mover = MovAny:GetMoverByFrameName(fn)
				if mover then
					p = {mover:GetPoint()}
				else
					p = {editFrame:GetPoint()}
				end
			end
			if p then
				UIDropDownMenu_Initialize(pointDropDownButton, pointDropDown_MenuInit)
				UIDropDownMenu_SetSelectedValue(pointDropDownButton, p[1] or "TOPLEFT")
				
				local relPoint = p[3] or p[1] or "TOPLEFT"
				UIDropDownMenu_Initialize(relPointDropDownButton, relPointDropDown_MenuInit)
				UIDropDownMenu_SetSelectedValue(relPointDropDownButton, relPoint)
				
				local relativeTo = "UIParent"
				if p[2] then
					if type(p[2]) == "string" then
						relativeTo = p[2]
					elseif type(p[2]) == "table" and p[2]:GetName() then
						relativeTo = p[2]:GetName()
					end
				end
				relToEdit:SetText(relativeTo)
				
				local v = tonumber(numfor(p[4])) or 0
				xSlider:SetMinMaxValues(v - 200, v + 200)
				_G[xSlider:GetName().."Low"]:SetText(v - 200)
				_G[xSlider:GetName().."High"]:SetText(v + 200)
				xSlider:SetValue(numfor(p[4] or 0))
				
				v = tonumber(numfor(p[5])) or 0
				ySlider:SetMinMaxValues(v - 200, v + 200)
				_G[ySlider:GetName().."Low"]:SetText(v - 200)
				_G[ySlider:GetName().."High"]:SetText(v + 200)
				ySlider:SetValue(numfor(p[5] or 0))
			end
		else
			frameHeight = frameHeight - 150
			
			pointLabel:Hide()
			pointDropDownButton:Hide()
			pointResetButton:Hide()
			relPointLabel:Hide()
			relPointDropDownButton:Hide()
			relPointResetButton:Hide()
			relToLabel:Hide()
			relToEdit:Hide()
			relToResetButton:Hide()
			xLabel:Hide()
			xEdit:Hide()
			xSlider:Hide()
			xResetButton:Hide()
			yLabel:Hide()
			yEdit:Hide()
			ySlider:Hide()
			yResetButton:Hide()
		end
		
		if editFrame and MovAny:CanBeScaled(editFrame) and editFrame.GetScale then
			if MovAny.ScaleWH[fn] then
				frameHeight = frameHeight + 27
				
				widthLabel:SetPoint(unpack(nextPoint))
				nextPoint = {"TOPLEFT", heightLabel, "BOTTOMLEFT", 0, -20}
				
				scaleLabel:Hide()
				scaleEdit:Hide()
				scaleSlider:Hide()
				scaleResetButton:Hide()
				
				widthLabel:Show()
				widthEdit:Show()
				widthSlider:Show()
				widthResetButton:Show()
				heightLabel:Show()
				heightEdit:Show()
				heightSlider:Show()
				heightResetButton:Show()
				
				local v = 1
				if opt and (opt.width or opt.originalWidth) then
					if opt.width then
						v = opt.width
					elseif opt.originalWidth then
						v = opt.originalWidth
					end
				elseif fe.editFrame then
					v = fe.editFrame:GetWidth()
				end
				local lowV = tonumber(numfor(v)) - 200
				if lowV < 1 then
					lowV = 1
				end
				--widthEdit:SetText(v)
				widthSlider:SetMinMaxValues(lowV, lowV + 400)
				widthSlider:SetValue(v)
				_G[widthSlider:GetName().."Low"]:SetText(lowV)
				_G[widthSlider:GetName().."High"]:SetText(lowV + 400)
				
				v = 1
				if opt and (opt.height or opt.originalHeight) then
					if opt.height then
						v = opt.height
					elseif opt.originalHeight then
						v = opt.originalHeight
					end
				elseif fe.editFrame then
					v = fe.editFrame:GetHeight()
				end
				lowV = tonumber(numfor(v)) - 200
				if lowV < 1 then
					lowV = 1
				end
				--heightEdit:SetText(v)
				heightSlider:SetMinMaxValues(lowV, lowV + 400)
				heightSlider:SetValue(v)
				_G[heightSlider:GetName().."Low"]:SetText(lowV)
				_G[heightSlider:GetName().."High"]:SetText(lowV + 400)
			else
				scaleLabel:SetPoint(unpack(nextPoint))
				nextPoint = {"TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -20}
			
				scaleLabel:Show()
				scaleEdit:Show()
				scaleSlider:Show()
				scaleResetButton:Show()
				
				widthLabel:Hide()
				widthEdit:Hide()
				widthSlider:Hide()
				widthResetButton:Hide()
				heightLabel:Hide()
				heightEdit:Hide()
				heightSlider:Hide()
				heightResetButton:Hide()
			
				local scale = opt and opt.scale or 1
				if scale then
					--scaleEdit:SetText(numfor(scale))
					scaleSlider:SetValue(scale)
				else
					frameHeight = frameHeight - 40
					scaleLabel:Hide()
					scaleEdit:Hide()
					scaleSlider:Hide()
					scaleResetButton:Hide()
				end
			end
		else
			frameHeight = frameHeight - 40
			scaleLabel:Hide()
			scaleEdit:Hide()
			scaleSlider:Hide()
			scaleResetButton:Hide()
		end
		
		if editFrame and not MovAny.NoAlpha[fn] and editFrame.GetAlpha then
			alphaLabel:SetPoint(unpack(nextPoint))
			nextPoint = {"TOPLEFT", alphaLabel, "BOTTOMLEFT", 0, -20}
			
			alphaLabel:Show()
			alphaEdit:Show()
			alphaSlider:Show()
			alphaResetButton:Show()
			
			local alpha = opt and opt.alpha or 1
			--alphaEdit:SetText(numfor(alpha * 100))
			alphaSlider:SetValue(alpha)
		else
			frameHeight = frameHeight - 40
			alphaLabel:Hide()
			alphaEdit:Hide()
			alphaSlider:Hide()
			alphaResetButton:Hide()
		end
		fe:SetHeight(frameHeight)
		
		hideLayersHeading:SetPoint(unpack(nextPoint))
		
		if fe.editFrame and fe.editFrame.DisableDrawLayer then
			hideLayersHeading:Show()
			
			hideArtworkCheck:Show()
			hideBackgroundCheck:Show()
			hideBorderCheck:Show()
			hideHighlightCheck:Show()
			hideOverlayCheck:Show()
			
			hideArtworkLabel:Show()
			hideBackgroundLabel:Show()
			hideBorderLabel:Show()
			hideHighlightLabel:Show()
			hideOverlayLabel:Show()
			
			hideArtworkCheck:SetChecked(fe.opt and fe.opt.disableLayerArtwork)
			hideBackgroundCheck:SetChecked(fe.opt and fe.opt.disableLayerBackground)
			hideBorderCheck:SetChecked(fe.opt and fe.opt.disableLayerBorder)
			hideHighlightCheck:SetChecked(fe.opt and fe.opt.disableLayerHighlight)
			hideOverlayCheck:SetChecked(fe.opt and fe.opt.disableLayerOverlay)
		else
			hideLayersHeading:Hide()
			
			hideArtworkCheck:Hide()
			hideBackgroundCheck:Hide()
			hideBorderCheck:Hide()
			hideHighlightCheck:Hide()
			hideOverlayCheck:Hide()
			
			hideArtworkLabel:Hide()
			hideBackgroundLabel:Hide()
			hideBorderLabel:Hide()
			hideHighlightLabel:Hide()
			hideOverlayLabel:Hide()
		end
		
		if (opt and opt.frameStrata) or (editFrame and editFrame.GetFrameStrata and editFrame:GetFrameStrata()) then
			strataLabel:Show()
			strataDropDownButton:Show()
			local frameStrata = (opt and opt.frameStrata) or (editFrame and editFrame:GetFrameStrata()) or nil
			UIDropDownMenu_Initialize(strataDropDownButton, strataDropDown_MenuInit)
			if frameStrata then
				UIDropDownMenu_SetSelectedValue(strataDropDownButton, frameStrata)
			else
				UIDropDownMenu_SetSelectedValue(strataDropDownButton, "BACKGROUND")
			end
		else
			strataLabel:Hide()
			strataDropDownButton:Hide()
		end
		
		fe:UpdateButtons()
		fe:UpdateActuals()
		
		fe.updating = nil
	end
	
	fe.UpdateButtons = function()
		
		if MovAny:GetFrameOptions(fe.o.name) then
			resetButton:Enable()
		else
			resetButton:Disable()
		end
		
		if fe.editFrame then
			local mover = MovAny:GetMoverByFrameName(fe.o.name)
			moverButton:Enable()
			moverButton:SetText(mover and "Detach" or "Attach")
			if mover then
				syncButton:Disable()
			else
				syncButton:Enable()
			end
		else
			moverButton:Disable()
			syncButton:Disable()
		end
		
		if fe.editFrame then
			showButton:Enable()
			showButton:SetText(fe.editFrame:IsShown() and "Hide" or "Show")
		else
			showButton:Disable()
		end
	end
	
	fe.CloseDialog = function()
		if IsShiftKeyDown() and IsControlKeyDown() and IsAltKeyDown() then
			ReloadUI()
		else
			fe:Hide()
			MovAny.frameEditors[fe.o.name] = nil
			fe.o = nil
			fe.opt = nil
			fe.editFrame = nil
			fe.initialOpt = nil
		end
	end
	
	fe.VerifyOpt = function(self, dontCreate)
		local opt = MovAny:GetFrameOptions(fe.o.name)
		if not opt then
			if dontCreate then
				fe.opt = nil
			else
				fe.opt = MovAny:HookFrame(fe.o.name)
			end
		end
		return fe.opt
	end

	fe.WritePoint = function(self, updateEditor)
		if fe.updating then
			return
		end
		
		local fn = fe.o.name
		local editFrame = fe.editFrame
		local opt = fe:VerifyOpt()
		
		if fe.editFrame and not opt.orgPos then
			MovAny:StoreOrgPoints(editFrame, opt)
		end

		fe.updating = true
		local mover = MovAny:GetMoverByFrameName(fn)
		if editFrame then
			if mover and (not InCombatLockdown() or not MovAny:IsProtected(editFrame)) then
				mover.dontUpdate = true
				MovAny:DetachMover(mover)
			end
			if not InCombatLockdown() or not MovAny:IsProtected(editFrame) then
				MovAny:ApplyPosition(editFrame, opt)
			else
				local closure = function(f, opt)
					return function()
						if MovAny:IsProtected(f) and InCombatLockdown() then
							return true
						end
						MovAny:ApplyPosition(f, opt)
					end
				end
				MovAny.pendingActions[fe.o.name..":SetPoint"] = closure(editFrame, opt)
			end
			if mover and (not InCombatLockdown() or not MovAny:IsProtected(editFrame)) then
				MovAny:AttachMover(fn)
			end
		end
		
		if updateEditor then
			fe:UpdateEditor()
		else
			fe:UpdateButtons()
			fe:UpdateActuals()
		end
		fe.updating = nil
	end

	fe.WriteScale = function()
		if fe.updating then
			return
		end
		local fn = fe.o.name
		local editFrame = fe.editFrame
		local opt = fe:VerifyOpt()

		local scale = scaleSlider:GetValue()
		
		fe.updating = true
		
		local mover = MovAny:GetMoverByFrameName(fn)
		if mover and (not InCombatLockdown() or not MovAny:IsProtected(editFrame)) then
			mover.dontUpdate = true
			MovAny:StopMoving(fn)
		end
		
		if scale > 0 then
			opt.scale = scale
			if editFrame then
				if not InCombatLockdown() or not MovAny:IsProtected(editFrame) then
					MovAny:ApplyScale(editFrame, opt)
				else
					local closure = function(f, opt)
						return function()
							if MovAny:IsProtected(f) and InCombatLockdown() then
								return true
							end
							MovAny:ApplyScale(f, opt)
						end
					end
					MovAny.pendingActions[fn..":SetScale"] = closure(editFrame, opt)
				end
			end
		end
		
		if mover and (not InCombatLockdown() or not MovAny:IsProtected(editFrame)) then
			MovAny:AttachMover(fn)
		end
		
		fe:UpdateButtons()
		fe:UpdateActuals()
		fe.updating = nil
	end
	
	fe.WriteDimentions = function()
		if fe.updating then
			return
		end
		local fn = fe.o.name
		local editFrame = fe.editFrame
		local opt = fe:VerifyOpt()
		
		if editFrame then
			if type(opt.originalWidth) == "nil" then
				opt.originalWidth = editFrame:GetWidth()
			end
			
			if type(opt.originalHeight) == "nil" then
				opt.originalHeight = editFrame:GetHeight()
			end
		end
		
		fe.updating = true
		local mover = MovAny:GetMoverByFrameName(fn)
		if mover and (not InCombatLockdown() or not MovAny:IsProtected(editFrame)) then
			mover.dontUpdate = true
			MovAny:StopMoving(fn)
		end
		
		local width = widthSlider:GetValue()
		if width >= 0 then
			opt.width = width
		end
		
		local height = heightSlider:GetValue()
		if height >= 0 then
			opt.height = height
		end
		
		if editFrame then
			if not InCombatLockdown() or not MovAny:IsProtected(editFrame) then
				MovAny:ApplyScale(editFrame, opt)
			else
				local closure = function(f, opt)
					return function()
						if MovAny:IsProtected(f) and InCombatLockdown() then
							return true
						end
						MovAny:ApplyScale(f,opt)
					end
				end
				MovAny.pendingActions[fn..":Scale"] = closure(editFrame, opt)
			end
		end
		if mover and (not InCombatLockdown() or not MovAny:IsProtected(editFrame)) then
			MovAny:AttachMover(fn)
		end
		fe:UpdateButtons()
		fe:UpdateActuals()
		fe.updating = nil
	end

	fe.WriteAlpha = function()
		if fe.updating then
			return
		end
		local fn = fe.o.name
		local opt = fe:VerifyOpt()
		
		fe.updating = true
		if opt.alpha ~= tonumber(alphaSlider:GetValue()) then
			opt.alpha = tonumber(alphaSlider:GetValue())
			
			if fe.editFrame then
				MovAny:ApplyAlpha(fe.editFrame, opt)
			end
			if opt.alpha == opt.originalAlpha then
				opt.alpha = nil
				opt.originalAlpha = nil
			end
		end
		
		fe:UpdateButtons()
		fe:UpdateActuals()
		fe.updating = nil
	end
	
	fe.UpdateActuals = function()
		local editFrame = fe.editFrame
		if not editFrame then
			actualsHeading:Hide()
			infoTextWidthLabel:Hide()
			infoTextWidth:Hide()
			infoTextHeightLabel:Hide()
			infoTextHeight:Hide()
			infoTextXLabel:Hide()
			infoTextX:Hide()
			infoTextYLabel:Hide()
			infoTextY:Hide()
			infoTextScaleLabel:Hide()
			infoTextScale:Hide()
			infoTextAlphaLabel:Hide()
			infoTextAlpha:Hide()
			return
		end
		
		actualsHeading:Show()
		infoTextWidthLabel:Show()
		infoTextWidth:Show()
		infoTextHeightLabel:Show()
		infoTextHeight:Show()
		infoTextXLabel:Show()
		infoTextX:Show()
		infoTextYLabel:Show()
		infoTextY:Show()
		
		if editFrame.GetEffectiveScale or editFrame.GetScale then
			local scale
			if editFrame.GetScale then
				scale = editFrame:GetScale()
			elseif editFrame.GetEffectiveScale then
				scale = editFrame:GetEffectiveScale() / UIParent:GetScale()
			end
			
			if editFrame:GetLeft() then
				infoTextX:SetText(numfor(editFrame:GetLeft() * scale))
			else
				infoTextX:SetText("?")
			end
			if editFrame:GetBottom() then
				infoTextY:SetText(numfor(editFrame:GetBottom() * scale))
			end
			
			if editFrame:GetWidth() then
				infoTextWidth:SetText(numfor(editFrame:GetWidth() * scale))
			end
			if editFrame:GetHeight() then
				infoTextHeight:SetText(numfor(editFrame:GetHeight() * scale))
			end
			
			infoTextScaleLabel:Show()
			infoTextScale:Show()
			infoTextScale:SetText(numfor(scale * 100).."%")
		else
			infoTextX:SetText(numfor(editFrame:GetLeft()))
			infoTextY:SetText(numfor(editFrame:GetBottom()))
			
			infoTextWidth:SetText(numfor(editFrame:GetWidth()))
			infoTextHeight:SetText(numfor(editFrame:GetHeight()))
			
			infoTextScaleLabel:Hide()
			infoTextScale:Hide()
		end
		if editFrame.GetEffectiveAlpha or editFrame.GetAlpha then
			infoTextAlphaLabel:Show()
			infoTextAlpha:Show()
			local alpha
			if editFrame.GetEffectiveAlpha then
				alpha = editFrame:GetEffectiveAlpha()
			elseif editFrame.GetAlpha then
				alpha = editFrame:GetAlpha()
			end
			infoTextAlpha:SetText(numfor(alpha * 100, 0).."%")
		else
			infoTextAlphaLabel:Hide()
			infoTextAlpha:Hide()
		end
	end
	
	fe:LoadFrame(name)
end