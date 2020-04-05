local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )

local _details = 		_G._details
local gump = 			_details.gump
local _
--lua locals
local _cstr = tostring --> lua local
local _math_ceil = math.ceil --> lua local
local _math_floor = math.floor --> lua local
local _string_len = string.len --> lua local
local _pairs = pairs --> lua local
local	_tinsert = tinsert --> lua local
local _IsInRaid = IsInRaid --> lua local

local _CreateFrame = CreateFrame --> wow api locals
local _IsInGuild = IsInGuild --> wow api locals
local _GetChannelList = GetChannelList --> wow api locals
local _UIParent = UIParent --> wow api locals

--> got weird errors with globals, not sure why
local _UIDropDownMenu_SetSelectedID = UIDropDownMenu_SetSelectedID --> wow api locals
local _UIDropDownMenu_CreateInfo = UIDropDownMenu_CreateInfo --> wow api locals
local _UIDropDownMenu_AddButton = UIDropDownMenu_AddButton --> wow api locals
local _UIDropDownMenu_Initialize = UIDropDownMenu_Initialize --> wow api locals
local _UIDropDownMenu_SetWidth = UIDropDownMenu_SetWidth --> wow api locals
local _UIDropDownMenu_SetButtonWidth = UIDropDownMenu_SetButtonWidth --> wow api locals
local _UIDropDownMenu_SetSelectedValue = UIDropDownMenu_SetSelectedValue --> wow api locals
local _UIDropDownMenu_JustifyText = UIDropDownMenu_JustifyText --> wow api locals
local _UISpecialFrames = UISpecialFrames --> wow api locals


--> details API functions -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	function _details:SendReportLines(lines)
		if (type(lines) == "string") then
			lines = {lines}
		elseif (type(lines) ~= "table") then
			return _details:NewError("SendReportLines parameter 1 must be a table or string.")
		end
		return _details:send_report(lines, true)
	end

	function _details:SendReportWindow(func, _current, _inverse, _slider)

		if (type(func) ~= "function") then
			return _details:NewError("SendReportWindow parameter 1 must be a function.")
		end

		if (not _details.window_report) then
			_details.window_report = gump:CreateWindowReport()
		end

		if (_current) then
			_G["Details_Report_CB_1"]:Enable()
			_G["Details_Report_CB_1Text"]:SetTextColor(1, 1, 1, 1)
		else
			_G["Details_Report_CB_1"]:Disable()
			_G["Details_Report_CB_1Text"]:SetTextColor(.5, .5, .5, 1)
		end
		
		if (_inverse) then
			_G["Details_Report_CB_2"]:Enable()
			_G["Details_Report_CB_2Text"]:SetTextColor(1, 1, 1, 1)
		else
			_G["Details_Report_CB_2"]:Disable()
			_G["Details_Report_CB_2Text"]:SetTextColor(.5, .5, .5, 1)
		end
		
		if (_slider) then
			_details.window_report.slider:Enable()
			_details.window_report.slider.lockTexture:Hide()
			_details.window_report.slider.amt:Show()
		else
			_details.window_report.slider:Disable()
			_details.window_report.slider.lockTexture:Show()
			_details.window_report.slider.amt:Hide()
		end
		
		if (_details.window_report.active) then 
			_details.window_report:Flash(0.2, 0.2, 0.4, true, 0, 0, "NONE")
		end
		
		_details.window_report.active = true
		_details.window_report.sendr:SetScript("OnClick", function() func(_G["Details_Report_CB_1"]:GetChecked(), _G["Details_Report_CB_2"]:GetChecked(), _details.report_lines) end)
		
		gump:Fade(_details.window_report, 0)
		
		return true
	end
	
	function _details:SendReportTextWindow(lines)
	
		if (not _details.copypasteframe) then
			_details.copypasteframe = CreateFrame("editbox", "DetailsCopyPasteFrame2", UIParent)
			_details.copypasteframe:SetFrameStrata("TOOLTIP")
			_details.copypasteframe:SetPoint("CENTER", UIParent, "CENTER", 0, 50)
			tinsert(UISpecialFrames, "DetailsCopyPasteFrame2")
			_details.copypasteframe:SetSize(400, 400)
			_details.copypasteframe:SetBackdrop({bgFile = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Parchment-Horizontal-Desaturated", 
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
				tile = true, tileSize = 16, edgeSize = 8,
				insets = {left = 0, right = 0, top = 0, bottom = 0},})
			_details.copypasteframe:SetBackdropColor(0, 0, 0, 0.9)
			_details.copypasteframe:SetAutoFocus(false)
			_details.copypasteframe:SetMultiLine(true)
			_details.copypasteframe:SetFontObject("GameFontNormalSmall")
			_details.copypasteframe:Hide()
			
			local title = _details.copypasteframe:CreateFontString(nil, "overlay", "GameFontNormal")
			title:SetPoint("bottomleft", _details.copypasteframe, "topleft", 2, 2)
			title:SetText("Press Ctrl + C and paste wherever you want, press any key to close.")
			title:SetJustifyH("left")
			
			local texture = _details.copypasteframe:CreateTexture(nil, "overlay")
			texture:SetTexture(0, 0, 0, 1)
			texture:SetSize(400, 25)
			texture:SetPoint("bottomleft", _details.copypasteframe, "topleft")
			
			_details.copypasteframe:SetScript("OnEditFocusGained", function() _details.copypasteframe:HighlightText() end)
			_details.copypasteframe:SetScript("OnEditFocusLost", function() _details.copypasteframe:Hide() end)
			_details.copypasteframe:SetScript("OnEscapePressed", function() _details.copypasteframe:SetFocus(false); _details.copypasteframe:Hide() end)
			_details.copypasteframe:SetScript("OnChar", function() _details.copypasteframe:SetFocus(false); _details.copypasteframe:Hide() end)
		end
		
		local s = ""
		for _, line in ipairs(lines) do 
			s = s .. line .. "\n"
		end
		
		_details.copypasteframe:Show()
		_details.copypasteframe:SetText(s)
		_details.copypasteframe:HighlightText()
		_details.copypasteframe:SetFocus(true)

	end

	
--> internal details report functions -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	function _details:Report(param2, options, arg3)

		if (not _details.window_report) then
			_details.window_report = gump:CreateWindowReport()
		end
		
		if (options and options.mine_id) then
			self = options
		end
		
		--> trabalha com as opções:
		if (options and options._no_current) then
			_G["Details_Report_CB_1"]:Disable()
			_G["Details_Report_CB_1Text"]:SetTextColor(.5, .5, .5, 1)
		else
			_G["Details_Report_CB_1"]:Enable()
			_G["Details_Report_CB_1Text"]:SetTextColor(1, 1, 1, 1)
		end
		
		if (options and options._no_inverse) then
			_G["Details_Report_CB_2"]:Disable()
			_G["Details_Report_CB_2Text"]:SetTextColor(.5, .5, .5, 1)
		else
			_G["Details_Report_CB_2"]:Enable()
			_G["Details_Report_CB_2Text"]:SetTextColor(1, 1, 1, 1)
		end
		
		_details.window_report.slider:Enable()
		_details.window_report.slider.lockTexture:Hide()
		_details.window_report.slider.amt:Show()
		
		if (options) then
			_details.window_report.sendr:SetScript("OnClick", function() self:prepare_report(param2, options._custom) end)
		else
			_details.window_report.sendr:SetScript("OnClick", function() self:prepare_report(param2) end)
		end

		if (_details.window_report.active) then 
			--_details.window_report:Flash(0.2, 0.2, 0.4, true, 0, 0, "NONE")
			UIFrameFlash(_details.window_report, 0.4, 0.4, 0.4, true, 0, 0)
			--gump:Fade(_details.window_report, 1)
		end
		
		_details.window_report.active = true
		gump:Fade(_details.window_report, 0)
	end
	
--> build report frame gump -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--> script
	local savepos = function(self)
		local xofs, yofs = self:GetCenter() 
		local scale = self:GetEffectiveScale()
		local UIscale = UIParent:GetScale()
		xofs = xofs * scale - GetScreenWidth() * UIscale / 2
		yofs = yofs * scale - GetScreenHeight() * UIscale / 2
		local x = xofs / UIscale
		local y = yofs / UIscale
		_details.report_pos[1] = x
		_details.report_pos[2] = y
	end
	local restorepos = function(self)
		local x, y = _details.report_pos[1], _details.report_pos[2]
		local scale = self:GetEffectiveScale() 
		local UIscale = UIParent:GetScale()
		x = x * UIscale / scale
		y = y * UIscale / scale
		self:ClearAllPoints()
		self:SetPoint("center", UIParent, "center", x, y)
	end
	local function seta_scripts(this_gump)
		--> Window
		this_gump:SetScript("OnMouseDown", 
						function(self, button)
							if (button == "LeftButton") then
								self:StartMoving()
								self.isMoving = true
							end
						end)
						
		this_gump:SetScript("OnMouseUp", 
						function(self)
							if (self.isMoving) then
								self:StopMovingOrSizing()
								savepos(self)
								self.isMoving = false
							end
						end)
	end

--> dropdown menus

local function cria_drop_down(this_gump)
--[[
Emote: 255 251 255
Yell: 255 63 64
Guild Chat: 64 251 64
Officer Chat: 64 189 64
Achievement: 255 251 0
Whisper: 255 126 255
RealID: 0 251 246
Party: 170 167 255
Party Lead: 118 197 255
Raid: 255 125 0
Raid Warning: 255 71 0
Raid Lead: 255 71 9
BG Leader: 255 216 183
General/Trade: 255 189 192
--]]

local iconsize = {16, 16}

local list = {
{Loc["STRING_REPORTFRAME_PARTY"], "PARTY", function() return GetNumPartyMembers() > 0 end, {iconsize = iconsize, icon =[[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.53125, 0.7265625, 0.078125, 0.40625}, color = {0.66, 0.65, 1}}},
{Loc["STRING_REPORTFRAME_RAID"], "RAID", function() return GetNumRaidMembers() > 0 end, {iconsize = iconsize, icon =[[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.53125, 0.7265625, 0.078125, 0.40625}, color = {1, 0.49, 0}}}, 
{Loc["STRING_REPORTFRAME_GUILD"], "GUILD", _IsInGuild, {iconsize = iconsize, icon =[[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.8046875, 0.96875, 0.125, 0.390625}, color = {0.25, 0.98, 0.25}}}, 
{Loc["STRING_REPORTFRAME_OFFICERS"], "OFFICER", _IsInGuild, {iconsize = iconsize, icon =[[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.8046875, 0.96875, 0.125, 0.390625}, color = {0.25, 0.74, 0.25}}}, 
{Loc["STRING_REPORTFRAME_WHISPER"], "WHISPER", nil, {iconsize = iconsize, icon =[[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0546875, 0.1953125, 0.625, 0.890625}, color = {1, 0.49, 1}}}, 
{Loc["STRING_REPORTFRAME_WHISPERTARGET"], "WHISPER2", nil, {iconsize = iconsize, icon =[[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0546875, 0.1953125, 0.625, 0.890625}, color = {1, 0.49, 1}}}, 
{Loc["STRING_REPORTFRAME_SAY"], "SAY", nil, {iconsize = iconsize, icon =[[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0390625, 0.203125, 0.09375, 0.375}, color = {1, 1, 1}}},
{Loc["STRING_REPORTFRAME_COPY"], "COPY", nil, {iconsize = iconsize, icon =[[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], coords = {0, 1, 0, 1}, color = {1, 1, 1}}},
}

		local on_click = function(self, fixedParam, selectedOutput)
			_details.report_where = selectedOutput
		end
	
		local build_list = function()
		
			local output_array = {}
		
			for index, case in ipairs(list) do 
				if (not case[3] or case[3]()) then
					output_array[#output_array + 1] = {iconsize = case[4].iconsize, value = case[2], label = case[1], onclick = on_click, icon = case[4].icon, texcoord = case[4].coords, iconcolor = case[4].color}
				end
			end
			
			local channels = {_GetChannelList()} --> coloca o resultado em uma table .. {id1, canal1, id2, canal2}
			for i = 1, #channels, 2 do --> total de canais
			
				output_array[#output_array + 1] = {iconsize = iconsize, value = "CHANNEL|"..channels[i+1], label = channels[i]..". "..channels[i+1], onclick = on_click, icon =[[Interface\FriendsFrame\UI-Toast-ToastIcons]], texcoord = {0.3046875, 0.4453125, 0.109375, 0.390625}, iconcolor = {149/255, 112/255, 112/255}}
			
				--list[#list+1] = {channels[i]..". "..channels[i+1], "CHANNEL|"..channels[i+1]}
			end
			
			local bnet_friends = {}
			
			local BnetFriends = BNGetNumFriends()
			for i = 1, BnetFriends do 
				local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, broadcastTime, canSoR = BNGetFriendInfo(i)
				if (isOnline) then
					output_array[#output_array + 1] = {iconsize = iconsize, value = "REALID|" .. presenceID, label = presenceName, onclick = on_click, icon =[[Interface\AddOns\Details\images\Battlenet-Battleneticon]], texcoord = {0.125, 0.875, 0.125, 0.875}, iconcolor = {1, 1, 1}}
				end
			end

			return output_array
		end
	
		local select_output = gump:NewDropDown(this_gump, _, "$parentOutputDropdown", "select", 185, 20, build_list, 1)
		select_output:SetPoint("topleft", this_gump, "topleft", 107, -55)
		this_gump.select = select_output.widget
		
		
		local function initialize(self, level)
			local info = _UIDropDownMenu_CreateInfo()

			for i = 9, #list do 
				list[i] = nil
			end
			
			local channels = {_GetChannelList()} --> coloca o resultado em uma table .. {id1, canal1, id2, canal2}
			for i = 1, #channels, 2 do --> total de canais
				list[#list+1] = {channels[i]..". "..channels[i+1], "CHANNEL|"..channels[i+1]}
			end
			
			local BnetFriends = BNGetNumFriends()
			for i = 1, BnetFriends do 
				local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, broadcastTime, canSoR = BNGetFriendInfo(i)
				if (isOnline) then
					list[#list+1] = {presenceName, "REALID|" .. presenceID, nil,[[Interface\AddOns\Details\images\Battlenet-Battleneticon]]}
				end
			end
			
			--BNSendWhisper

			for index, v in _pairs(list) do
			
				if (not v[3] or(type(v[3]) == "function" and v[3]())) then
					info = _UIDropDownMenu_CreateInfo()
					info.text = v[1]
					info.value = v[2]
					
					if (v[4]) then
						info.icon = v[4]
					end
					
					info.func = OnClick
					_UIDropDownMenu_AddButton(info, level)
				end
			end
		end
		
		function select_output:CheckValid()
			
			local last_selected = _details.report_where
			local check_func
			for i, t in ipairs(list) do
				if (t[2] == last_selected) then
					check_func = t[3]
					break
				end
			end
			
			if (check_func) then
				local is_shown = check_func()
				if (is_shown) then
					select_output:Select(last_selected)
				else
					if (GetNumRaidMembers() > 0) then
						select_output:Select("RAID")
					elseif (GetNumPartyMembers() > 0) then
						select_output:Select("PARTY")
					elseif (IsInGuild()) then
						select_output:Select("GUILD")
					else
						select_output:Select("SAY")
					end
				end
			else
				select_output:Select(last_selected)
			end
		end
		
		select_output:CheckValid()
	end

--> slider

	local function cria_slider(this_gump)

		this_gump.lines_amt = this_gump:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		this_gump.lines_amt:SetText(Loc["STRING_REPORTFRAME_LINES"])
		this_gump.lines_amt:SetTextColor(.9, .9, .9, 1)
		this_gump.lines_amt:SetPoint("bottomleft", this_gump, "bottomleft", 58, 12)
		_details:SetFontSize(this_gump.lines_amt, 10)
		
		local slider = _CreateFrame("Slider", "Details_Report_Slider", this_gump)
		this_gump.slider = slider
		slider:SetPoint("bottomleft", this_gump, "bottomleft", 58, -7)
		
		slider.thumb = slider:CreateTexture(nil, "artwork")
		slider.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
		slider.thumb:SetSize(30, 24)
		slider.thumb:SetAlpha(0.7)
		
		local lockTexture = slider:CreateTexture(nil, "overlay")
		lockTexture:SetPoint("center", slider.thumb, "center", -1, -1)
		lockTexture:SetTexture("Interface\\Buttons\\CancelButton-Up")
		lockTexture:SetWidth(29)
		lockTexture:SetHeight(24)
		lockTexture:Hide()
		slider.lockTexture = lockTexture

		slider:SetThumbTexture(slider.thumb) --depois 
		slider:SetOrientation("HORIZONTAL")
		slider:SetMinMaxValues(1.0, 25.0)
		slider:SetValueStep(1.0)
		slider:SetWidth(232)
		slider:SetHeight(20)

		local last_value = _details.report_lines or 5
		slider:SetValue(math.floor(last_value))
		
		slider.amt = slider:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		local amt = slider:GetValue()
		if (amt < 10) then
			amt = "0"..amt
		end
		slider.amt:SetText(amt)
		slider.amt:SetTextColor(.8, .8, .8, 1)
		
		slider.amt:SetPoint("center", slider.thumb, "center")
		
		slider:SetScript("OnValueChanged", function(self) 
			local amt = math.floor(self:GetValue())
			_details.report_lines = amt
			if (amt < 10) then
				amt = "0"..amt
			end
			self.amt:SetText(amt)
			end)
		
		slider:SetScript("OnEnter", function(self)
				slider.thumb:SetAlpha(1)
		end)
		
		slider:SetScript("OnLeave", function(self)
				slider.thumb:SetAlpha(0.7)
		end)
		
	end

--> whisper taget field

	local function cria_wisper_field(this_gump)
		
		this_gump.wisp_who = this_gump:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		this_gump.wisp_who:SetText(Loc["STRING_REPORTFRAME_WHISPER"] .. ":")
		this_gump.wisp_who:SetTextColor(1, 1, 1, 1)
		
		this_gump.wisp_who:SetPoint("topleft", this_gump.select, "topleft", 14, -30)
		
		_details:SetFontSize(this_gump.wisp_who, 10)

		--editbox
		local editbox = _CreateFrame("EditBox", nil, this_gump)
		this_gump.editbox = editbox
		
		editbox:SetAutoFocus(false)
		editbox:SetFontObject("GameFontNormalSmall")
		
		editbox:SetPoint("TOPLEFT", this_gump.select, "TOPLEFT", 64, -28)
		
		editbox:SetHeight(14)
		editbox:SetWidth(120)
		editbox:SetJustifyH("LEFT")
		editbox:EnableMouse(true)
		editbox:SetBackdrop({
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			tile = true, edgeSize = 1, tileSize = 5,
			})
		editbox:SetBackdropColor(0, 0, 0, 0.0)
		editbox:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0)
		
		local last_value = _details.report_to_who or ""
		editbox:SetText(last_value)
		editbox.lost_focus = nil
		editbox.focus = false
		
		editbox:SetScript("OnEnterPressed", function() 
			local text = _details:trim(editbox:GetText())
			if (_string_len(text) > 0) then
				_details.report_to_who = text
				editbox:AddHistoryLine(text)
				editbox:SetText(text)
			else 
				_details.report_to_who = ""
				editbox:SetText("")
			end 
			editbox.lost_focus = true --> isso aqui pra quando estiver editando e clicar em outra caixa
			editbox:ClearFocus()
		end)
		
		editbox:SetScript("OnEscapePressed", function() 
			editbox:SetText("") 
			_details.report_to_who = ""
			editbox.lost_focus = true
			editbox:ClearFocus() 
		end)
		
		editbox:SetScript("OnEnter", function() 
			editbox.mouse_over = true 
			editbox:SetBackdropColor(0.1, 0.1, 0.1, 0.7)
			if (editbox:GetText() == "" and not editbox.focus) then
				editbox:SetText(Loc["STRING_REPORTFRAME_INSERTNAME"])
			end 
		end)
		
		editbox:SetScript("OnLeave", function() 
			editbox.mouse_over = false 
			editbox:SetBackdropColor(0.0, 0.0, 0.0, 0.0)
			if (not editbox:HasFocus()) then 
				if (editbox:GetText() == Loc["STRING_REPORTFRAME_INSERTNAME"]) then
					editbox:SetText("") 
				end 
			end 
		end)

		editbox:SetScript("OnEditFocusGained", function()
			if (editbox:GetText() == Loc["STRING_REPORTFRAME_INSERTNAME"]) then
				editbox:SetText("") 
			end
			
			if (editbox:GetText() ~= "") then
				--> selecionar todo o text
				editbox:HighlightText(0, editbox:GetNumLetters())
			end
			
			editbox.focus = true
		end)
		
		editbox:SetScript("OnEditFocusLost", function()
			if (editbox.lost_focus == nil) then
				local text = _details:trim(editbox:GetText())
				if (_string_len(text) > 0) then 
					_details.report_to_who = text
				else
					_details.report_to_who = ""
					editbox:SetText("")
				end 
			else
				editbox.lost_focus = nil
			end
			
			editbox.focus = false
		end)
	end

--> both check buttons
		
	function cria_check_buttons(this_gump)
		local checkbox = _CreateFrame("CheckButton", "Details_Report_CB_1", this_gump, "ChatConfigCheckButtonTemplate")
		checkbox:SetPoint("topleft", this_gump.wisp_who, "bottomleft", -25, -4)
		_G[checkbox:GetName().."Text"]:SetText(Loc["STRING_REPORTFRAME_CURRENT"])
		_details:SetFontSize(_G[checkbox:GetName().."Text"], 10)
		checkbox.tooltip = Loc["STRING_REPORTFRAME_CURRENTINFO"]
		checkbox:SetHitRectInsets(0, -35, 0, 0)
		
		local checkbox2 = _CreateFrame("CheckButton", "Details_Report_CB_2", this_gump, "ChatConfigCheckButtonTemplate")
		checkbox2:SetPoint("topleft", this_gump.wisp_who, "bottomleft", 35, -4)
		_G[checkbox2:GetName().."Text"]:SetText(Loc["STRING_REPORTFRAME_REVERT"])
		_details:SetFontSize(_G[checkbox2:GetName().."Text"], 10)
		checkbox2.tooltip = Loc["STRING_REPORTFRAME_REVERTINFO"]
		checkbox2:SetHitRectInsets(0, -35, 0, 0)
	end

--> frame creation function

	function gump:CreateWindowReport()
		
		local this_gump = _CreateFrame("Frame", "DetailsReportWindow", _UIParent)
		this_gump:SetPoint("CENTER", UIParent, "CENTER")
		this_gump:SetFrameStrata("HIGH")

		_tinsert(_UISpecialFrames, this_gump:GetName())
		
		this_gump:SetScript("OnHide", function(self)
			_details.window_report.active = false
		end)

		this_gump:SetWidth(320)
		this_gump:SetHeight(128)
		this_gump:EnableMouse(true)
		this_gump:SetResizable(false)
		this_gump:SetMovable(true)
		restorepos(this_gump)

		_details.window_report = this_gump
		
		--> icon
		this_gump.icon = this_gump:CreateTexture(nil, "BACKGROUND")
		this_gump.icon:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 40, -10)
		this_gump.icon:SetTexture("Interface\\AddOns\\Details\\images\\report_frame_icons") --> top left
		this_gump.icon:SetWidth(64)
		this_gump.icon:SetHeight(64)
		this_gump.icon:SetTexCoord(1/256, 64/256, 1/256, 64/256) --left right top bottom
		
		--> cria as 2 partes do fundo da window
		this_gump.bg1 = this_gump:CreateTexture(nil, "BORDER")
		this_gump.bg1:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 0, 0)
		this_gump.bg1:SetTexture("Interface\\AddOns\\Details\\images\\report_frame1") --> top left

		this_gump.bg2 = this_gump:CreateTexture(nil, "BORDER")
		this_gump.bg2:SetPoint("TOPRIGHT", this_gump, "TOPRIGHT", 0, 0)
		this_gump.bg2:SetTexture("Interface\\AddOns\\Details\\images\\report_frame2") --> top right

		--> botão de close
		this_gump.close = CreateFrame("Button", nil, this_gump, "UIPanelCloseButton")
		this_gump.close:SetWidth(32)
		this_gump.close:SetHeight(32)
		this_gump.close:SetPoint("TOPRIGHT", this_gump, "TOPRIGHT", -20, -23)
		this_gump.close:SetText("X")
		this_gump.close:SetScript("OnClick", function()
			gump:Fade(this_gump, 1)
			_details.window_report.active = false
		end)	

		this_gump.titulo = this_gump:CreateFontString(nil, "OVERLAY", "GameFontHighlightLeft")
		this_gump.titulo:SetText(Loc["STRING_REPORTFRAME_WINDOW_TITLE"])
		this_gump.titulo:SetTextColor(0.999, 0.819, 0, 1)
		this_gump.titulo:SetPoint("topleft", this_gump, "topleft", 120, -33)

		seta_scripts(this_gump)

		cria_drop_down(this_gump)
		cria_slider(this_gump)
		cria_wisper_field(this_gump)
		cria_check_buttons(this_gump)

		this_gump.sendr = _CreateFrame("Button", nil, this_gump, "OptionsButtonTemplate")
		
		this_gump.sendr:SetPoint("topleft", this_gump.editbox, "topleft", 61, -19)
		
		this_gump.sendr:SetWidth(60)
		this_gump.sendr:SetHeight(15)
		this_gump.sendr:SetText(Loc["STRING_REPORTFRAME_SEND"])

		gump:Fade(this_gump, 1)
		gump:CreateFlashAnimation(this_gump)
		
		return this_gump
		
	end