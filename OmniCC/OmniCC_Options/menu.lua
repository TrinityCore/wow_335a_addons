--[[
	menu.lua
		Code for the OmniCC options panel
--]]

local Options = CreateFrame('Frame', 'OmniCCOptionsFrame', UIParent)
local SML = LibStub('LibSharedMedia-3.0')
local L = OMNICC_LOCALS

function Options:Load(title, subtitle)
	self.name = title
	
	local text = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	text:SetPoint('TOPLEFT', 16, -16)
	text:SetText(title)

	local subtext = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	subtext:SetHeight(32)
	subtext:SetPoint('TOPLEFT', text, 'BOTTOMLEFT', 0, -8)
	subtext:SetPoint('RIGHT', self, -32, 0)
	subtext:SetNonSpaceWrap(true)
	subtext:SetJustifyH('LEFT')
	subtext:SetJustifyV('TOP')
	subtext:SetText(subtitle)

	self:AddDisplayPanel()
	self:AddFontPanel()

	local color = self:AddColorPanel()
	color:SetPoint('BOTTOMLEFT', 10, 10)
	
	InterfaceOptions_AddCategory(self) 
end


--[[ Panels ]]--

--Display
function Options:AddDisplayPanel()
	--show models
	local showModels = self:CreateCheckButton(L.ShowModels, self)
	showModels:SetScript('OnShow', function(self) self:SetChecked(OmniCC:ShowingModels()) end)
	showModels:SetScript('OnClick', function(self) OmniCC:SetShowModels(self:GetChecked()) end)
	showModels:SetPoint('TOPLEFT', 10, -72)

	--show cooldown puls

	--use MM:SS format
	local useMMSS = self:CreateCheckButton(L.UseMMSS, self)
	useMMSS:SetScript('OnShow', function(self) self:SetChecked(OmniCC:UsingMMSS()) end)
	useMMSS:SetScript('OnClick', function(self) OmniCC:SetUseMMSS(self:GetChecked()) end)
	useMMSS:SetPoint('TOP', showModels, 'BOTTOM', 0, -2)
	
	local showTenthsOfSeconds = self:CreateCheckButton(L.ShowTenthsOfSeconds, self)
	showTenthsOfSeconds:SetScript('OnShow', function(self) self:SetChecked(OmniCC:UseTenthsOfSeconds()) end)
	showTenthsOfSeconds:SetScript('OnClick', function(self) OmniCC:SetUseTenthsOfSeconds(self:GetChecked()) end)
	showTenthsOfSeconds:SetPoint('TOP', useMMSS, 'BOTTOM', 0, -2)

	--minimum duration slider
	local minDuration = self:CreateSlider(L.MinDuration, self, 0, 30, 0.5)
	minDuration:SetScript('OnShow', function(self)
		self.onShow = true
		self:SetValue(OmniCC:GetMinDuration())
		self.onShow = nil
	end)
	minDuration:SetScript('OnValueChanged', function(self, value)
		self.valText:SetText(format('%.1fs', value))
		if not self.onShow then
			OmniCC:SetMinDuration(value)
		end
	end)
	minDuration:SetPoint('TOPLEFT', showTenthsOfSeconds, 'BOTTOMLEFT', 2, -24)

	--minimum scale slider
	local minScale = self:CreateSlider(L.MinScale, self, 0, 2, 0.05)
	minScale:SetScript('OnShow', function(self)
		self.onShow = true
		self:SetValue(OmniCC:GetMinScale())
		self.onShow = nil
	end)
	minScale:SetScript('OnValueChanged', function(self, value)
		self.valText:SetText(floor(value * 100 + 0.5) .. '%')
		if not self.onShow then
			OmniCC:SetMinScale(value)
		end
	end)
	minScale:SetPoint('TOPLEFT', minDuration, 'BOTTOMLEFT', 0, -20)
end

--font
function Options:AddFontPanel()
	local fontFace = self:CreateFontSelector(self)
	fontFace:SetPoint('TOPRIGHT', -24, -72)

	local fontOutline = self:CreateFontOutlineDropdown(self)
	fontOutline:SetPoint('TOPLEFT', fontFace, 'BOTTOMLEFT', 0, -24)

	local fontSize = self:CreateSlider(L.FontSize, self, 8, 32, 0.5)
	fontSize:SetScript('OnShow', function(self)
		self.onShow = true
		self:SetValue(OmniCC:GetFontSize())
		self.onShow = nil
	end)
	fontSize:SetScript('OnValueChanged', function(self, value)
		self.valText:SetText(format('%.1f', value))
		if not self.onShow then
			OmniCC:SetFontSize(value)
		end
	end)
	fontSize:SetPoint('TOPLEFT', fontOutline, 'BOTTOMLEFT', 15, -18)
	
	--minimum pulse duration slider
	local minEffectDuration = self:CreateSlider(L.MinEffectDuration, self, 0, 60, 0.5)
	minEffectDuration:SetScript('OnShow', function(self)
		self.onShow = true
		self:SetValue(OmniCC:GetMinEffectDuration())
		self.onShow = nil
	end)
	minEffectDuration:SetScript('OnValueChanged', function(self, value)
		self.valText:SetText(format('%.1fs', value))
		if not self.onShow then
			OmniCC:SetMinEffectDuration(value)
		end
	end)
	minEffectDuration:SetPoint('TOPLEFT', fontSize, 'BOTTOMLEFT', 0, -20)
end

function Options:AddColorPanel()
	local panel = self:CreatePanel(L.ColorsAndScaling)
	panel:SetWidth(392); panel:SetHeight(148)

	local short = self:CreateFormatSlider(L.UnderFiveSeconds, panel, 'short')
	short:SetPoint('TOPLEFT', 10, -32)

	local seconds = self:CreateFormatSlider(SECONDS, panel, 'secs')
	seconds:SetPoint('TOPLEFT', short, 'BOTTOMLEFT', 0, -24)

	local mins = self:CreateFormatSlider(MINUTES, panel, 'mins')
	mins:SetPoint('TOPLEFT', seconds, 'BOTTOMLEFT', 0, -24)

	local hours = self:CreateFormatSlider(HOURS, panel, 'hrs')
	hours:SetPoint('TOPRIGHT', -42, -32)

	local days = self:CreateFormatSlider(DAYS, panel, 'days')
	days:SetPoint('TOPLEFT', hours, 'BOTTOMLEFT', 0, -24)

	return panel
end


--[[
	Widget Templates
--]]

--panel
function Options:CreatePanel(name)
	local panel = CreateFrame('Frame', self:GetName() .. name, self, 'OptionsBoxTemplate')
	panel:SetBackdropBorderColor(0.4, 0.4, 0.4)
	panel:SetBackdropColor(0.15, 0.15, 0.15, 0.5)
	getglobal(panel:GetName() .. 'Title'):SetText(name)

	return panel
end

--basic slider
do
	local function Slider_OnMouseWheel(self, arg1)
		local step = self:GetValueStep() * arg1
		local value = self:GetValue()
		local minVal, maxVal = self:GetMinMaxValues()

		if step > 0 then
			self:SetValue(min(value+step, maxVal))
		else
			self:SetValue(max(value+step, minVal))
		end
	end

	function Options:CreateSlider(text, parent, low, high, step)
		local name = parent:GetName() .. text
		local slider = CreateFrame('Slider', name, parent, 'OptionsSliderTemplate')
		slider:SetScript('OnMouseWheel', Slider_OnMouseWheel)
		slider:SetMinMaxValues(low, high)
		slider:SetValueStep(step)
		slider:EnableMouseWheel(true)
		BlizzardOptionsPanel_Slider_Enable(slider) --colors the slider properly

		getglobal(name .. 'Text'):SetText(text)
		getglobal(name .. 'Low'):SetText('')
		getglobal(name .. 'High'):SetText('')

		local text = slider:CreateFontString(nil, 'BACKGROUND')
		text:SetFontObject('GameFontHighlightSmall')
		text:SetPoint('LEFT', slider, 'RIGHT', 7, 0)
		slider.valText = text

		return slider
	end
end

--check button
function Options:CreateCheckButton(name, parent)
	local button = CreateFrame('CheckButton', parent:GetName() .. name, parent, 'InterfaceOptionsCheckButtonTemplate')
	getglobal(button:GetName() .. 'Text'):SetText(name)

	return button
end

--basic dropdown
function Options:CreateDropdown(name, parent)
	local frame = CreateFrame('Frame', parent:GetName() .. name, parent, 'UIDropDownMenuTemplate')
	local text = frame:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 21, 0)
	text:SetFontObject('GameFontNormalSmall')
	text:SetText(name)

	return frame
end

--font outline dropdown
do
	local styles = {NONE, L.Thin, L.Thick}
	local outlines = {nil, 'OUTLINE', 'THICKOUTLINE'}

	local info = {}
	local function AddItem(text, value, func, checked)
		info.text = text
		info.func = func
		info.value = value
		info.checked = checked
		UIDropDownMenu_AddButton(info)
	end

	local function Dropdown_OnShow(self)
		UIDropDownMenu_SetWidth(self, 132)
		UIDropDownMenu_Initialize(self, self.Initialize)

		local selected = OmniCC:GetFontOutline()
		for i, outline in pairs(outlines) do
			if outline == selected then
				UIDropDownMenu_SetSelectedValue(self, i)
				return
			end
		end
		UIDropDownMenu_SetSelectedValue(self, 1)
	end

	function Options:CreateFontOutlineDropdown(parent)
		local dropdown = self:CreateDropdown(L.FontOutline, parent)
		dropdown:SetScript('OnShow', Dropdown_OnShow)

		local function Button_OnClick(self)
			OmniCC:SetFontOutline(outlines[self.value])
			UIDropDownMenu_SetSelectedValue(dropdown, self.value)
		end
			
		function dropdown:Initialize()
			local selected = OmniCC:GetFontOutline()
			for i,style in ipairs(styles) do
				AddItem(style, i, Button_OnClick, outlines[i] == selected)
			end
		end

		return dropdown
	end
end

--font selector
do
	local MAX_LIST_SIZE = 20

	local function ListButton_OnClick(self)
		OmniCC:SetFont(self.font)

		local parent = self:GetParent()
		parent:Hide()

		local text = getglobal(parent:GetParent():GetName() .. 'Text')
		text:SetText(OmniCC:GetFontName())

		PlaySound('UChatScrollButton')
	end

	local function ListButton_Create(parent)
		local button = CreateFrame('Button', nil, parent)
		button:SetHeight(UIDROPDOWNMENU_BUTTON_HEIGHT)

		local text = button:CreateFontString()
		text:SetJustifyH('LEFT')
		text:SetPoint('LEFT', 27, 0)
		button.text = text

		local check = button:CreateTexture(nil, 'ARTWORK')
		check:SetWidth(24); check:SetHeight(24)
		check:SetTexture('Interface/Buttons/UI-CheckBox-Check')
		check:SetPoint('LEFT')
		button.check = check

		local highlight = button:CreateTexture(nil, 'BACKGROUND')
		highlight:SetAllPoints(button)
		highlight:SetTexture('Interface/QuestFrame/UI-QuestTitleHighlight')
		highlight:SetAlpha(0.4)
		highlight:SetBlendMode('ADD')
		highlight:Hide()
		button:SetHighlightTexture(highlight)

		button:SetScript('OnClick', ListButton_OnClick)

		return button
	end

	local function List_UpdateWidth(self)
		--determine the max frame width
		self.width = 0
		for _,font in pairs(SML:List('font')) do
			self.text:SetFont(SML:Fetch('font', font, true), UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT + 1)
			self.text:SetText(font)
			self.width = max(self.text:GetWidth()+60, self.width)
		end
	end

	local function List_Update(self)
		local buttons = self.buttons
		local fonts = SML:List('font')
		local numFonts = #fonts
		local selectedFont = OmniCC:GetFontName()
		local listSize = min(numFonts, MAX_LIST_SIZE)

		local scrollFrame = self.scrollFrame
		local offset = scrollFrame.offset
		FauxScrollFrame_Update(scrollFrame, numFonts, listSize, UIDROPDOWNMENU_BUTTON_HEIGHT)

		for i = 1, listSize do
			local index = i + offset
			local button = self.buttons[i]
			local font = fonts[index]

			if font then
				button.font = font
				button.text:SetFont(SML:Fetch('font', font), UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT)
				button.text:SetText(font)

				if font == selectedFont then
					button.check:Show()
				else
					button.check:Hide()
				end

				button:SetWidth(self.width)
				button:Show()
			else
				button:Hide()
			end
		end

		for i = listSize+1, #buttons do
			buttons[i]:Hide()
		end

		if self.scrollFrame:IsShown() then
			self:SetWidth(self.width + 50)
		else
			self:SetWidth(self.width + 30)
		end
		self:SetHeight((listSize * UIDROPDOWNMENU_BUTTON_HEIGHT) + (UIDROPDOWNMENU_BORDER_HEIGHT * 2))
	end

	local function List_Create(parent)
		local frame = CreateFrame('Button', parent:GetName() .. 'FSList', parent)
		frame:SetToplevel(true)
		frame:Raise()

		frame.text = frame:CreateFontString()

		frame.buttons = setmetatable({}, {__index = function(t, i)
			local button = ListButton_Create(frame)
			if i > 1 then
				button:SetPoint('TOPLEFT', t[i-1], 'BOTTOMLEFT')
			else
				button:SetPoint('TOPLEFT', 15, -15)
			end
			t[i] = button

			return button
		end})

		local scroll = CreateFrame('ScrollFrame', frame:GetName() .. 'ScrollFrame', frame, 'FauxScrollFrameTemplate')
		scroll:SetPoint('TOPLEFT', 12, -14)
		scroll:SetPoint('BOTTOMRIGHT', -36, 13)
		scroll:SetScript('OnVerticalScroll', function(self, arg1)
			FauxScrollFrame_OnVerticalScroll(self, arg1, UIDROPDOWNMENU_BUTTON_HEIGHT, function() List_Update(frame) end)
		end)
		frame.scrollFrame = scroll

		frame:SetBackdrop{
			bgFile = 'Interface/DialogFrame/UI-DialogBox-Background',
			edgeFile = 'Interface/DialogFrame/UI-DialogBox-Border',
			insets = {left = 11, right = 12, top = 12, bottom = 11},
			tile = true, tileSize = 32, edgeSize = 32,
		}

		frame:SetScript('OnShow', function(self) List_UpdateWidth(self); List_Update(self) end)
		frame:SetScript('OnHide', frame.Hide)
		frame:SetScript('OnClick', frame.Hide)
		frame:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', 6, 8)
		frame:Hide()

		return frame
	end

	local function DropdownButton_OnClick(self)
		local list = self.list
		if list then
			if list:IsShown() then
				list:Hide()
			else
				list:Show()
			end
		else
			self.list = List_Create(self:GetParent())
			self.list:Show()
		end
	end

	local function Dropdown_OnShow(self)
		UIDropDownMenu_SetWidth(self, 132)
		getglobal(self:GetName() .. 'Text'):SetText(OmniCC:GetFontName())
	end

	function Options:CreateFontSelector(parent)
		local dropdown = self:CreateDropdown(L.Font, parent)
		dropdown:SetScript('OnShow', Dropdown_OnShow)
		getglobal(dropdown:GetName() .. 'Button'):SetScript('OnClick', DropdownButton_OnClick)

		return dropdown
	end
end

--color selector
do
	local colorSelectors, colorCopier

	--color copier: we use this to transfer color from one color selector to another
	local function ColorCopier_Create()
		local copier = CreateFrame('Frame')
		copier:SetWidth(24); copier:SetHeight(24)
		copier:Hide()

		copier:EnableMouse(true)
		copier:SetToplevel(true)
		copier:SetMovable(true)
		copier:RegisterForDrag('LeftButton')
		copier:SetFrameStrata('TOOLTIP')

		copier:SetScript('OnUpdate', function(self)
			local x, y = GetCursorPosition()
			self:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', x - 8, y + 8)
		end)

		copier:SetScript('OnReceiveDrag', function(self)
			for _,selector in pairs(colorSelectors) do
				if MouseIsOver(selector, 8, -8, -8, 8) then
					selector:PasteColor()
					break
				end
			end
			self:Hide()
		end)

		copier:SetScript('OnMouseUp', copier.Hide)

		copier.bg = copier:CreateTexture()
		copier.bg:SetTexture('Interface/ChatFrame/ChatFrameColorSwatch')
		copier.bg:SetAllPoints(copier)

		return copier
	end

	local function ColorSelect_CopyColor(self)
		colorCopier = colorCopier or ColorCopier_Create()
		colorCopier.bg:SetVertexColor(self:GetNormalTexture():GetVertexColor())
		colorCopier:Show()
	end

	local function ColorSelect_PasteColor(self)
		self:SetColor(colorCopier.bg:GetVertexColor())
		colorCopier:Hide()
	end

	local function ColorSelect_SetColor(self, ...)
		self:GetNormalTexture():SetVertexColor(...)
		OmniCC:SetDurationColor(self.duration, ...)
	end

	local function ColorSelect_OnClick(self)
		if ColorPickerFrame:IsShown() then
			ColorPickerFrame:Hide()
		else
			self.r, self.g, self.b = OmniCC:GetDurationFormat(self:GetParent().duration)

			UIDropDownMenuButton_OpenColorPicker(self)
			ColorPickerFrame:SetFrameStrata('TOOLTIP')
			ColorPickerFrame:Raise()
		end
	end

	local function ColorSelect_OnEnter(self)
		local color = NORMAL_FONT_COLOR
		self.bg:SetVertexColor(color.r, color.g, color.b)
	end

	local function ColorSelect_OnLeave(self)
		local color = HIGHLIGHT_FONT_COLOR
		self.bg:SetVertexColor(color.r, color.g, color.b)
	end

	function Options:CreateColorSelector(name, parent, duration)
		local frame = CreateFrame('Button', parent:GetName() .. name, parent)
		frame:SetWidth(16); frame:SetHeight(16)
		frame:SetNormalTexture('Interface/ChatFrame/ChatFrameColorSwatch')
		frame.duration = duration

		local bg = frame:CreateTexture(nil, 'BACKGROUND')
		bg:SetWidth(14); bg:SetHeight(14)
		bg:SetTexture(1, 1, 1)
		bg:SetPoint('CENTER')
		frame.bg = bg

		frame.SetColor = ColorSelect_SetColor
		frame.PasteColor = ColorSelect_PasteColor
		frame.swatchFunc = function() frame:SetColor(ColorPickerFrame:GetColorRGB()) end
		frame.cancelFunc = function() frame:SetColor(frame.r, frame.g, frame.b) end

		frame:RegisterForDrag('LeftButton')
		frame:SetScript('OnDragStart', ColorSelect_CopyColor)
		frame:SetScript('OnClick', ColorSelect_OnClick)
		frame:SetScript('OnEnter', ColorSelect_OnEnter)
		frame:SetScript('OnLeave', ColorSelect_OnLeave)

		--register the color selector, and create the copier if needed
		if colorSelectors then
			table.insert(colorSelectors, frame)
		else
			colorSelectors = {frame}
		end

		return frame
	end
end

--format selector:  this is a slider for font scale + a color selector
do
	local function FormatSlider_OnShow(self)
		self.onShow = true
		local r, g, b, scale = OmniCC:GetDurationFormat(self.duration)
		self:SetValue(scale)
		self.colorSelect:GetNormalTexture():SetVertexColor(r,g,b)
		self.onShow = nil
	end

	local function FormatSlider_OnValueChanged(self, value)
		self.valText:SetText(floor(value * 100 + 0.5) .. '%')
		if not self.onShow then
			OmniCC:SetDurationScale(self.duration, value)
		end
	end

	function Options:CreateFormatSlider(name, parent, duration)
		local slider = self:CreateSlider(name, parent, 0.5, 2, 0.05)
--		slider:SetWidth(120); slider:SetHeight(18)
		slider.duration = duration

		local text = getglobal(slider:GetName() .. 'Text')
		text:ClearAllPoints()
		text:SetPoint('BOTTOMLEFT', slider, 'TOPLEFT')
		text:SetJustifyH('LEFT')

		local colorSelect = self:CreateColorSelector('ColorSelect', slider, duration)
		colorSelect:SetPoint('BOTTOMRIGHT', slider, 'TOPRIGHT')
		slider.colorSelect = colorSelect

		slider:SetScript('OnShow', FormatSlider_OnShow)
		slider:SetScript('OnValueChanged', FormatSlider_OnValueChanged)

		return slider
	end
end

Options:Load(select(2, GetAddOnInfo('OmniCC')))