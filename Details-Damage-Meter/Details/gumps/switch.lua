local _details = 		_G._details
local AceLocale = LibStub("AceLocale-3.0")
local Loc = AceLocale:GetLocale( "Details" )

local gump = 			_details.gump
local _
--lua locals
local _unpack = unpack
local _math_floor = math.floor

--api locals
do
	local _CreateFrame = CreateFrame
	local _UIParent = UIParent

	local gump_fundo_backdrop = {
		bgFile = "Interface\\AddOns\\Details\\images\\background", 
		--edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
		tile = true, tileSize = 16, --edgeSize = 4,
		insets = {left = 0, right = 0, top = 0, bottom = 0}}

	local frame = _CreateFrame("frame", "DetailsSwitchPanel", _UIParent)
	frame:SetPoint("center", _UIParent, "center", 500, -300)
	frame:SetWidth(250)
	frame:SetHeight(100)
	--frame:SetBackdrop(gump_fundo_backdrop)
	frame:SetBackdropBorderColor(170/255, 170/255, 170/255)
	frame:SetBackdropColor(24/255, 24/255, 24/255, .8)
	
	frame:SetFrameStrata("FULLSCREEN")
	frame:SetFrameLevel(16)
	
	frame.background = frame:CreateTexture(nil, "background")
	frame.background:SetTexture([[Interface\AddOns\Details\images\Store-Splash]])
	frame.background:SetTexCoord(16/1024, 561/1024, 8/1024, 263/1024)
	frame.background:SetAllPoints()
	frame.background:SetDesaturated(true)
	frame.background:SetVertexColor(.5, .5, .5, .85)
	
	frame.topbg = frame:CreateTexture(nil, "background")
	frame.topbg:SetTexture([[Interface\AddOns\Details\images\ScenariosParts]])
	frame.topbg:SetTexCoord(100/512, 267/512, 143/512, 202/512)
	frame.topbg:SetPoint("bottomleft", frame, "topleft")
	frame.topbg:SetPoint("bottomright", frame, "topright")
	frame.topbg:SetHeight(20)
	frame.topbg:SetDesaturated(true)
	frame.topbg:SetVertexColor(.3, .3, .3, 0.8)
	
	frame.topbg_frame = CreateFrame("frame", nil, frame)
	frame.topbg_frame:SetPoint("bottomleft", frame, "topleft")
	frame.topbg_frame:SetPoint("bottomright", frame, "topright")
	frame.topbg_frame:SetHeight(20)
	frame.topbg_frame:EnableMouse(true)
	frame.topbg_frame:SetScript("OnMouseDown", function(self, button)
		if (button == "RightButton") then
			_details.switch:CloseMe()
		end
	end)
	
	frame.star = frame:CreateTexture(nil, "overlay")
	frame.star:SetTexture([[Interface\Glues\CharacterSelect\Glues-AddOn-Icons]])
	frame.star:SetTexCoord(0.75, 1, 0, 1)
	frame.star:SetSize(16, 16)
	frame.star:SetPoint("bottomleft", frame, "topleft", 4, 0)
	
	frame.title_label = frame:CreateFontString(nil, "overlay", "GameFontNormal")
	frame.title_label:SetPoint("left", frame.star, "right", 4, -1)
	frame.title_label:SetText("Bookmark")

	function _details.switch:CloseMe()
		_details.switch.frame:Hide()
		GameCooltip:Hide()
		_details.switch.frame:SetBackdropColor(24/255, 24/255, 24/255, .8)
		_details.switch.current_instance:StatusBarAlert(nil)
		_details.switch.current_instance = nil
	end
	
	--> limitação: não tenho como pegar o base frame da instância por aqui
	frame.close = gump:NewDetailsButton(frame, frame, _, function() end, nil, nil, 1, 1, "", "", "", "", {rightFunc = {func = _details.switch.CloseMe, param1 = nil, param2 = nil}}, "DetailsSwitchPanelClose")
	frame.close:SetPoint("topleft", frame, "topleft")
	frame.close:SetPoint("bottomright", frame, "bottomright")
	frame.close:SetFrameLevel(9)
	frame:Hide()
	
	_details.switch.frame = frame
	_details.switch.button_height = 20
end

_details.switch.buttons = {}
_details.switch.slots = _details.switch.slots or 6
_details.switch.showing = 0
_details.switch.table = _details.switch.table or {}
_details.switch.current_instance = nil
_details.switch.current_button = nil
_details.switch.height_necessary =(_details.switch.button_height * _details.switch.slots) / 2

local right_click_text = {text = Loc["STRING_SHORTCUT_RIGHTCLICK"], size = 9, color = {.9, .9, .9}}
local right_click_texture = {[[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 14, 14, 0.0019531, 0.1484375, 0.6269531, 0.8222656}

function _details.switch:ShowMe(instance)

	--> check if there is some custom contidional
	if (instance.attribute == 5) then
		local custom_object = instance:GetCustomObject()
		if (custom_object and custom_object.OnSwitchShow) then
			local interrupt = custom_object.OnSwitchShow(instance)
			if (interrupt) then
				return
			end
		end
	end

	if (_details.switch.current_instance) then
		_details.switch.current_instance:StatusBarAlert(nil)
	end

	_details.switch.current_instance = instance
	
	_details.switch.frame:SetPoint("topleft", instance.baseframe, "topleft", 0, 1)
	_details.switch.frame:SetPoint("bottomright", instance.baseframe, "bottomright", 0, 1)
	
	_details.switch.frame:SetBackdropColor(0.094, 0.094, 0.094, .8)
	
	local altura = instance.baseframe:GetHeight()
	local mostrar_quantas = _math_floor(altura / _details.switch.button_height) * 2
	
	if (_details.switch.mostrar_quantas ~= mostrar_quantas) then 
		for i = 1, #_details.switch.buttons do
			if (i <= mostrar_quantas) then 
				_details.switch.buttons[i]:Show()
			else
				_details.switch.buttons[i]:Hide()
			end
		end
		
		if (#_details.switch.buttons < mostrar_quantas) then
			_details.switch.slots = mostrar_quantas
		end
		
		_details.switch.mostrar_quantas = mostrar_quantas
	end
	
	_details.switch:Resize()
	_details.switch:Update()
	
	_details.switch.frame:SetScale(instance.window_scale)
	_details.switch.frame:Show()
	
	if (not _details.tutorial.bookmark_tutorial) then
	
		if (not SwitchPanelTutorial) then
			local tutorial_frame = CreateFrame("frame", "SwitchPanelTutorial", _details.switch.frame)
			tutorial_frame:SetFrameStrata("FULLSCREEN_DIALOG")
			tutorial_frame:SetAllPoints()
			tutorial_frame:EnableMouse(true)
			tutorial_frame:SetBackdrop({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16 })
			tutorial_frame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)

			tutorial_frame.info_label = tutorial_frame:CreateFontString(nil, "overlay", "GameFontNormal")
			tutorial_frame.info_label:SetPoint("topleft", tutorial_frame, "topleft", 10, -10)
			tutorial_frame.info_label:SetText(Loc["STRING_MINITUTORIAL_BOOKMARK2"])
			tutorial_frame.info_label:SetJustifyH("left")
			
			tutorial_frame.mouse = tutorial_frame:CreateTexture(nil, "overlay")
			tutorial_frame.mouse:SetTexture([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]])
			tutorial_frame.mouse:SetTexCoord(0.0019531, 0.1484375, 0.6269531, 0.8222656)
			tutorial_frame.mouse:SetSize(20, 22)
			tutorial_frame.mouse:SetPoint("topleft", tutorial_frame.info_label, "bottomleft", -3, -10)

			tutorial_frame.close_label = tutorial_frame:CreateFontString(nil, "overlay", "GameFontNormalSmall")
			tutorial_frame.close_label:SetPoint("left", tutorial_frame.mouse, "right", 4, 0)
			tutorial_frame.close_label:SetText(Loc["STRING_MINITUTORIAL_BOOKMARK3"])
			tutorial_frame.close_label:SetJustifyH("left")
			
			local checkbox = CreateFrame("CheckButton", "SwitchPanelTutorialCheckBox", tutorial_frame, "ChatConfigCheckButtonTemplate")
			checkbox:SetPoint("topleft", tutorial_frame.mouse, "bottomleft", -1, -5)
			_G[checkbox:GetName().."Text"]:SetText(Loc["STRING_MINITUTORIAL_BOOKMARK4"])
			
			tutorial_frame:SetScript("OnMouseDown", function()
				if (checkbox:GetChecked()) then
					_details.tutorial.bookmark_tutorial = true
				end
				tutorial_frame:Hide()
			end)
		end
		
		SwitchPanelTutorial:Show()
		SwitchPanelTutorial.info_label:SetWidth(_details.switch.frame:GetWidth()-30)
		SwitchPanelTutorial.close_label:SetWidth(_details.switch.frame:GetWidth()-30)
	end
	
	_details.switch:Resize()
	--instance:StatusBarAlert(right_click_text, right_click_texture) --icon, color, time
end

function _details.switch:Config(_,_, attribute, sub_attribute)
	if (not sub_attribute) then 
		return
	end
	
	_details.switch.table[_details.switch.current_button].attribute = attribute
	_details.switch.table[_details.switch.current_button].sub_attribute = sub_attribute
	_details.switch:Update()
end

function _details:FastSwitch(_this)
	_details.switch.current_button = _this.button
	
	if (not _this.attribute) then --> botão direito
	
		GameCooltip:Reset()
		GameCooltip:SetType(3)
		GameCooltip:SetFixedParameter(_details.switch.current_instance)
		GameCooltip:SetOwner(_details.switch.buttons[_this.button])
		_details:SetAttributesOption(_details.switch.current_instance, _details.switch.Config)
		GameCooltip:SetColor(1, {.1, .1, .1, .3})
		GameCooltip:SetColor(2, {.1, .1, .1, .3})
		GameCooltip:SetOption("HeightAnchorMod", -7)
		GameCooltip:ShowCooltip()

	else --> botão left
		if (_details.switch.current_instance.mode == _details._details_props["MODE_ALONE"]) then
			_details.switch.current_instance:ChangeMode(_details.switch.current_instance, _details.switch.current_instance.LastMode)
			
		elseif (_details.switch.current_instance.mode == _details._details_props["MODE_RAID"]) then
			_details.switch.current_instance:ChangeMode(_details.switch.current_instance, _details.switch.current_instance.LastMode)
			
		end
		
		_details.switch.current_instance:SwitchTable(_details.switch.current_instance, true, _this.attribute, _this.sub_attribute)
		_details.switch.CloseMe()
		
	end
end

-- nao tem suporte a solo mode tank mode
-- nao tem suporte a custom até agora, não sei como vai ficar

function _details.switch:InitSwitch()
	return _details.switch:Update()
end

function _details.switch:OnRemoveCustom(CustomIndex)
	for i = 1, _details.switch.slots do
		local options = _details.switch.table[i]
		if (options and options.attribute == 5 and options.sub_attribute == CustomIndex) then 
			--> precisa reset esse aqui
			options.attribute = nil
			options.sub_attribute = nil
			_details.switch:Update()
		end
	end
end

local default_coords = {0, 1, 0, 1}
local unknown_coords = {157/512, 206/512, 39/512,  89/512}

function _details.switch:Update()

	local slots = _details.switch.slots
	local x = 10
	local y = 5
	local jump = false

	for i = 1, slots do

		local options = _details.switch.table[i]
		if (not options) then 
			options = {attribute = nil, sub_attribute = nil}
			_details.switch.table[i] = options
		end

		local button = _details.switch.buttons[i]
		if (not button) then
			button = _details.switch:NewSwitchButton(_details.switch.frame, i, x, y, jump)
			button:SetFrameLevel(_details.switch.frame:GetFrameLevel()+2)
			_details.switch.showing = _details.switch.showing + 1
		end
		
		local param2Table = {
			["instance"] = _details.switch.current_instance, 
			["button"] = i, 
			["attribute"] = options.attribute, 
			["sub_attribute"] = options.sub_attribute
		}
		
		button.funcParam2 = param2Table
		button.button2.funcParam2 = param2Table
		
		local icon
		local coords
		local name
		
		if (options.sub_attribute) then
			if (options.attribute == 5) then --> custom
				local CustomObject = _details.custom[options.sub_attribute]
				if (not CustomObject) then --> ele já foi deletado
					--icon = "Interface\\ICONS\\Ability_DualWield"
					icon =[[Interface\AddOns\Details\images\icons]]
					coords = unknown_coords
					name = Loc["STRING_SWITCH_CLICKME"]
				else
					icon = CustomObject.icon
					coords = default_coords
					name = CustomObject.name
				end
			else
				icon = _details.sub_attributes[options.attribute].icons[options.sub_attribute][1]
				coords = _details.sub_attributes[options.attribute].icons[options.sub_attribute][2]
				name = _details.sub_attributes[options.attribute].list[options.sub_attribute]
			end
		else
			icon =[[Interface\AddOns\Details\images\icons]]
			coords = unknown_coords
			name = Loc["STRING_SWITCH_CLICKME"]
		end
		
		button.button2.text:SetText(name)
		
		button.textureNormal:SetTexture(icon, true)
		button.textureNormal:SetTexCoord(_unpack(coords))
		button.texturePushed:SetTexture(icon, true)
		button.texturePushed:SetTexCoord(_unpack(coords))
		button.textureH:SetTexture(icon, true)
		button.textureH:SetTexCoord(_unpack(coords))
		button:ChangeIcon(button.textureNormal, button.texturePushed, _, button.textureH)

		if (jump) then 
			x = x - 125
			y = y + _details.switch.button_height
			jump = false
		else
			x = x + 125
			jump = true
		end

	end
	
end

function _details.switch:Resize()

	local x = 7
	local y = 5
	
	local window_width, window_height = _details.switch.current_instance:GetSize()
	
	local horizontal_amt = floor(math.max(window_width / 100, 2))
	local vertical_amt = floor((window_height - y) / 20)
	local size = window_width / horizontal_amt
	
	local frame = _details.switch.frame
	
	for index, button in ipairs(_details.switch.buttons) do
		button:Hide()
	end
	
	local i = 1
	for vertical = 1, vertical_amt do
		x = 7
		for horizontal = 1, horizontal_amt do
			local button = _details.switch.buttons[i]
			
			local options = _details.switch.table[i]
			if (not options) then 
				options = {attribute = nil, sub_attribute = nil}
				_details.switch.table[i] = options
			end
			
			if (not button) then
				button = _details.switch:NewSwitchButton(frame, i, x, y)
				button:SetFrameLevel(frame:GetFrameLevel()+2)
				_details.switch.showing = _details.switch.showing + 1
			end
			
			button:SetPoint("topleft", frame, "topleft", x, -y)
			button.textureNormal:SetPoint("topleft", frame, "topleft", x, -y)
			button.texturePushed:SetPoint("topleft", frame, "topleft", x, -y)
			button.textureH:SetPoint("topleft", frame, "topleft", x, -y)	
			button.button2.text:SetSize(size - 30, 12)
			button.button2:SetPoint("bottomright", button, "bottomright", size - 30, 0)
			button.line:SetWidth(size - 15)
			button.line2:SetWidth(size - 15)
			
			button:Show()
			
			i = i + 1
			x = x + size
			if (i > 40) then
				break
			end
		end
		y = y + 20
	end
	
	_details.switch.slots = i-1
	
end

function _details.switch:Resize2()

	local x = 7
	local y = 5
	local xPlus =(_details.switch.current_instance:GetSize()/2)-5
	local frame = _details.switch.frame
	
	for index, button in ipairs(_details.switch.buttons) do
		
		if (button.rightButton) then
			button:SetPoint("topleft", frame, "topleft", x, -y)
			button.textureNormal:SetPoint("topleft", frame, "topleft", x, -y)
			button.texturePushed:SetPoint("topleft", frame, "topleft", x, -y)
			button.textureH:SetPoint("topleft", frame, "topleft", x, -y)	
			button.button2.text:SetSize(xPlus - 30, 12)
			button.button2:SetPoint("bottomright", button, "bottomright", xPlus - 30, 0)
			button.line:SetWidth(xPlus - 15)
			button.line2:SetWidth(xPlus - 15)
			
			x = x - xPlus
			y = y + _details.switch.button_height
			jump = false
		else
			button:SetPoint("topleft", frame, "topleft", x, -y)
			button.textureNormal:SetPoint("topleft", frame, "topleft", x, -y)
			button.texturePushed:SetPoint("topleft", frame, "topleft", x, -y)
			button.textureH:SetPoint("topleft", frame, "topleft", x, -y)	
			button.button2.text:SetSize(xPlus - 30, 12)
			button.button2:SetPoint("topleft", button, "topright", 1, 0)
			button.button2:SetPoint("bottomright", button, "bottomright", xPlus - 30, 0)
			button.line:SetWidth(xPlus - 20)
			button.line2:SetWidth(xPlus - 20)
			
			x = x + xPlus
			jump = true			
		end
		
	end
end

local onenter = function(self)
	if (not _details.switch.table[self.index].attribute) then
		GameCooltip:Reset()
		_details:CooltipPreset(1)
		GameCooltip:AddLine("add bookmark")
		GameCooltip:AddIcon([[Interface\Glues\CharacterSelect\Glues-AddOn-Icons]], 1, 1, 16, 16, 0.75, 1, 0, 1, {0, 1, 0})

		GameCooltip:SetOwner(self)
		GameCooltip:SetType("tooltip")
		
		GameCooltip:SetOption("TextSize", 10)
		GameCooltip:SetOption("ButtonsYMod", 0)
		GameCooltip:SetOption("YSpacingMod", 0)
		GameCooltip:SetOption("IgnoreButtonAutoHeight", false)
		
		GameCooltip:Show()
	else
		GameCooltip:Hide()
	end
	
	self.text:SetTextColor(1, 1, 1, 1)
	self.border:SetBlendMode("ADD")
end

local onleave = function(self)
	if (GameCooltip:IsTooltip()) then
		GameCooltip:Hide()
	end
	self.text:SetTextColor(.8, .8, .8, 1)
	self.border:SetBlendMode("BLEND")
end

local oniconnter = function(self)

	if (GameCooltip:IsMenu()) then
		return
	end

	GameCooltip:Reset()
	_details:CooltipPreset(1)
	GameCooltip:AddLine("select bookmark")
	GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 14, 0.0019531, 0.1484375, 0.6269531, 0.8222656)
	
	GameCooltip:SetOwner(self)
	GameCooltip:SetType("tooltip")
	
	GameCooltip:SetOption("TextSize", 10)
	GameCooltip:SetOption("ButtonsYMod", 0)
	GameCooltip:SetOption("YSpacingMod", 0)
	GameCooltip:SetOption("IgnoreButtonAutoHeight", false)
	
	GameCooltip:Show()
end

local oniconleave = function(self)
	if (GameCooltip:IsTooltip()) then
		GameCooltip:Hide()
	end
end

function _details.switch:NewSwitchButton(frame, index, x, y, rightButton)

	local paramTable = {
			["instance"] = _details.switch.current_instance, 
			["button"] = index, 
			["attribute"] = nil, 
			["sub_attribute"] = nil
		}

	--button dentro da caixa
	local button = gump:NewDetailsButton(frame, frame, _, _details.FastSwitch, nil, paramTable, 15, 15, "", "", "", "", 
	{rightFunc = {func = _details.FastSwitch, param1 = nil, param2 = {attribute = nil, button = index}}, OnGrab = "PassClick"}, "DetailsSwitchPanelButton_1_"..index)
	button:SetPoint("topleft", frame, "topleft", x, -y)
	button.rightButton = rightButton
	
	button.MouseOnEnterHook = oniconnter
	button.MouseOnLeaveHook = oniconleave
	
	--borda
	button.fundo = button:CreateTexture(nil, "overlay")
	button.fundo:SetTexture("Interface\\AddOns\\Details\\images\\Spellbook-Parts")
	button.fundo:SetTexCoord(0.00390625, 0.27734375, 0.44140625,0.69531250)
	button.fundo:SetWidth(26)
	button.fundo:SetHeight(24)
	button.fundo:SetPoint("topleft", button, "topleft", -5, 5)
	
	--fundo marrom
	local fundo_x = -3
	local fundo_y = -5
	button.line = button:CreateTexture(nil, "background")
	button.line:SetTexture("Interface\\AddOns\\Details\\images\\Spellbook-Parts")
	button.line:SetTexCoord(0.31250000, 0.96484375, 0.37109375, 0.52343750)
	button.line:SetWidth(85)
	button.line:SetPoint("topleft", button, "topright", fundo_x, 0)
	button.line:SetPoint("bottomleft", button, "bottomright", fundo_x, fundo_y)
	
	--fundo marrom 2
	button.line2 = button:CreateTexture(nil, "background")
	button.line2:SetTexture("Interface\\AddOns\\Details\\images\\Spellbook-Parts")
	button.line2:SetTexCoord(0.31250000, 0.96484375, 0.37109375, 0.52343750)
	button.line2:SetWidth(85)
	button.line2:SetPoint("topleft", button, "topright", fundo_x, 0)
	button.line2:SetPoint("bottomleft", button, "bottomright", fundo_x, fundo_y)
	
	--button do fundo marrom
	local button2 = gump:NewDetailsButton(button, button, _, _details.FastSwitch, nil, paramTable, 1, 1, button.line, "", "", button.line2, 
	{rightFunc = {func = _details.switch.CloseMe, param1 = nil, param2 = nil}, OnGrab = "PassClick"}, "DetailsSwitchPanelButton_2_"..index)
	button2:SetPoint("topleft", button, "topright", 1, 0)
	button2:SetPoint("bottomright", button, "bottomright", 90, 0)
	button.button2 = button2
	
	--icon
	button.textureNormal = button:CreateTexture(nil, "background")
	button.textureNormal:SetAllPoints(button)
	
	--icon pushed
	button.texturePushed = button:CreateTexture(nil, "background")
	button.texturePushed:SetAllPoints(button)
	
	--highlight
	button.textureH = button:CreateTexture(nil, "background")
	button.textureH:SetAllPoints(button)
	
	--text do attribute
	gump:NewLabel(button2, button2, nil, "text", "", "GameFontNormalSmall")
	button2.text:SetPoint("left", button, "right", 5, -1)
	button2.text:SetNonSpaceWrap(true)
	button2.text:SetTextColor(.8, .8, .8, 1)
	
	button2.button1_icon = button.textureNormal
	button2.button1_icon2 = button.texturePushed
	button2.button1_icon3 = button.textureH
	button2.border = button.fundo
	
	button2.MouseOnEnterHook = onenter
	button2.MouseOnLeaveHook = onleave
	
	_details.switch.buttons[index] = button
	button.index = index
	button2.index = index
	
	return button
end
