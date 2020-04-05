local _details = 		_G._details
local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local g =	_details.gump
local _
-- DODANE
local function UniqueGetTalentSpecInfo(isInspect)
	local talantGroup = GetActiveTalentGroup(isInspect)
	local maxPoints, specIdx, specName, specIcon, specBackground = 0, 0
	
	for i = 1, MAX_TALENT_TABS do
		local name, icon, pointsSpent, _background = GetTalentTabInfo(i, isInspect, nil, talantGroup)
		if maxPoints < pointsSpent then
			maxPoints = pointsSpent
			specIdx = i
			specName = name
			specIcon = icon
			specBackground = _background
		end
	end

	if not specName then
		specName = "None"
	end
	if not specIcon then
		specIcon = "Interface\\Icons\\INV_Misc_QuestionMark"
	end
	if not specBackground then
		specBackground = "WarlockSummoning"
	end

	return specIdx, specName, specIcon, specBackground
end

function _details:OpenWelcomeWindow()

	GameCooltip:Close()
	local window = _G.DetailsWelcomeWindow

	if (not window) then
	
		local index = 1
		local pages = {}
		
		local instance = _details.table_instances[1]
		
		window = CreateFrame("frame", "DetailsWelcomeWindow", UIParent)
		window:SetPoint("center", UIParent, "center", -200, 0)
		window:SetWidth(512)
		window:SetHeight(256)
		window:SetMovable(true)
		window:SetScript("OnMouseDown", function() window:StartMoving() end)
		window:SetScript("OnMouseUp", function() window:StopMovingOrSizing() end)
		window:SetScript("OnHide", function()
			--> start tutorial if this is first run
			if (_details.tutorial.logons < 2 and _details.is_first_run) then
				--_details:StartTutorial()
			end
			_details.table_history:reset()
		end)
		
		local background = window:CreateTexture(nil, "background")
		background:SetPoint("topleft", window, "topleft")
		background:SetPoint("bottomright", window, "bottomright")
		background:SetTexture([[Interface\AddOns\Details\images\welcome]])
		
		local rodape_bg = window:CreateTexture(nil, "artwork")
		rodape_bg:SetPoint("bottomleft", window, "bottomleft", 11, 12)
		rodape_bg:SetPoint("bottomright", window, "bottomright", -11, 12)
		rodape_bg:SetTexture([[Interface\Tooltips\UI-Tooltip-Background]])
		rodape_bg:SetHeight(25)
		rodape_bg:SetVertexColor(0, 0, 0, 1)
		
		local logotype = window:CreateTexture(nil, "overlay")
		logotype:SetPoint("topleft", window, "topleft", 16, -20)
		logotype:SetTexture([[Interface\Addons\Details\images\logotype]])
		logotype:SetTexCoord(0.07421875, 0.73828125, 0.51953125, 0.890625)
		logotype:SetWidth(186)
		logotype:SetHeight(50)
		
		local cancel = CreateFrame("Button", nil, window)
		cancel:SetWidth(22)
		cancel:SetHeight(22)
		cancel:SetPoint("bottomleft", window, "bottomleft", 12, 14)
		cancel:SetFrameLevel(window:GetFrameLevel()+1)
		cancel:SetPushedTexture([[Interface\Buttons\UI-GroupLoot-Pass-Down]])
		cancel:SetHighlightTexture([[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
		cancel:SetNormalTexture([[Interface\Buttons\UI-GroupLoot-Pass-Up]])
		cancel:SetScript("OnClick", function() window:Hide() end)
		local cancelText = cancel:CreateFontString(nil, "overlay", "GameFontNormal")
		cancelText:SetPoint("left", cancel, "right", 2, 0)
		cancelText:SetText("Skip")
		
		local forward = CreateFrame("button", nil, window)
		forward:SetWidth(26)
		forward:SetHeight(26)
		forward:SetPoint("bottomright", window, "bottomright", -14, 13)
		forward:SetFrameLevel(window:GetFrameLevel()+1)
		forward:SetPushedTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Down]])
		forward:SetHighlightTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
		forward:SetNormalTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
		forward:SetDisabledTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Disabled]])
		
		local backward = CreateFrame("button", nil, window)
		backward:SetWidth(26)
		backward:SetHeight(26)
		backward:SetPoint("bottomright", window, "bottomright", -38, 13)
		backward:SetPushedTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Down]])
		backward:SetHighlightTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Up]])
		backward:SetNormalTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Up]])
		backward:SetDisabledTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Disabled]])
		
		forward:SetScript("OnClick", function()
			if (index < #pages) then
				for _, widget in ipairs(pages[index]) do 
					widget:Hide()
				end
				
				index = index + 1
				
				for _, widget in ipairs(pages[index]) do 
					widget:Show()
				end
				
				if (index == #pages) then
					forward:Disable()
				end
				backward:Enable()
			end
		end)
		
		backward:SetScript("OnClick", function()
			if (index > 1) then
				for _, widget in ipairs(pages[index]) do 
					widget:Hide()
				end
				
				index = index - 1
				
				for _, widget in ipairs(pages[index]) do 
					widget:Show()
				end
				
				if (index == 1) then
					backward:Disable()
				end
				forward:Enable()
			end
		end)

		function _details:WelcomeSetLoc()
			local instance = _details.table_instances[1]
			instance.baseframe:ClearAllPoints()
			instance.baseframe:SetPoint("left", DetailsWelcomeWindow, "right", 10, 0)
		end
		_details:ScheduleTimer("WelcomeSetLoc", 12)
		--_details:WelcomeSetLoc()

--/script local f=CreateFrame("frame");local g=false;f:SetScript("OnUpdate",function(s,e)if not g then local r=math.random for i=1,2500000 do local a=r(1,1000000);a=a+1 end g=true else print(string.format("cpu: %.3f",e));f:SetScript("OnUpdate",nil)end end)
	
	function _details:CalcCpuPower()
		local f = CreateFrame("frame")
		local got = false
		
		f:SetScript("OnUpdate", function(self, elapsed)
			if (not got and not InCombatLockdown()) then
				local r = math.random
				for i = 1, 2500000 do 
					local a = r(1, 1000000)
					a = a + 1
				end
				got = true
				
			elseif (not InCombatLockdown()) then
				--print("process time:", elapsed)
				
				if (elapsed < 0.295) then
					_details.use_row_animations = true
					_details.update_speed = 0.30
				
				elseif (elapsed < 0.375) then
					_details.use_row_animations = true
					_details.update_speed = 0.40
					
				elseif (elapsed < 0.475) then
					_details.use_row_animations = true
					_details.update_speed = 0.5
					
				elseif (elapsed < 0.525) then
					_details.update_speed = 0.5
					
				end
			
				DetailsWelcomeWindowSliderUpdateSpeed.MyObject:SetValue(_details.update_speed)
				DetailsWelcomeWindowAnimateSlider.MyObject:SetValue(_details.use_row_animations)

				f:SetScript("OnUpdate", nil)
			end
		end)
	end
	
	_details:ScheduleTimer("CalcCpuPower", 10)

	--detect ElvUI
	local ElvUI = _G.ElvUI
	if (ElvUI) then
		--active elvui skin
		local instance = _details.table_instances[1]
		if (instance and instance.active) then
			if (instance.skin ~= "ElvUI Frame Style") then
				instance:ChangeSkin("ElvUI Frame Style")
				_details:SetTooltipBackdrop("Blizzard Tooltip", 16, {1, 1, 1, 0})
			end
		end

		--save standard
		local savedObject = {}
		for key, value in pairs(instance) do
			if (_details.instance_defaults[key] ~= nil) then	
				if (type(value) == "table") then
					savedObject[key] = table_deepcopy(value)
				else
					savedObject[key] = value
				end
			end
		end
		_details.standard_skin = savedObject
	end
	
-- frame alert
	
	local frame_alert = CreateFrame("frame", nil, window)
	frame_alert:SetPoint("topright", window)
	function _details:StopPlayStretchAlert()
		frame_alert.alert.animIn:Stop()
		frame_alert.alert.animOut:Play()
		_details.stopwelcomealert = nil
	end
	frame_alert.alert = CreateFrame("frame", "DetailsWelcomeWindowAlert", UIParent)--, "ActionBarButtonSpellActivationAlert")
	frame_alert.alert:SetFrameStrata("FULLSCREEN")
	frame_alert.alert:Hide()	
	
local window_openned_at = time()

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 1
		
		--> introduction
		
		local angel = window:CreateTexture(nil, "border")
		angel:SetPoint("bottomright", window, "bottomright")
		angel:SetTexture([[Interface\TUTORIALFRAME\UI-TUTORIALFRAME-SPIRITREZ]])
		angel:SetTexCoord(0.162109375, 0.591796875, 0, 1)
		angel:SetWidth(442)
		angel:SetHeight(256)
		angel:SetAlpha(.2)
		
		local text1 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text1:SetPoint("topleft", window, "topleft", 13, -150)
		text1:SetText(Loc["STRING_WELCOME_1"])
		text1:SetJustifyH("left")
		
		pages[#pages+1] = {text1, angel}
		

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Avatar and Nickname Page

		local bg555 = window:CreateTexture(nil, "overlay")
		bg555:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg555:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg555:SetHeight(125*3)--125
		bg555:SetWidth(89*3)--82
		bg555:SetAlpha(.05)
		bg555:SetTexCoord(1, 0, 0, 1)

		local avatar_image = window:CreateTexture(nil, "overlay")
		avatar_image:SetTexture([[Interface\AddOns\Details\images\UI-EJ-BOSS-Default]])
		avatar_image:SetPoint("topright", window, "topright", -5, -21)
		avatar_image:SetWidth(128*1.2)
		avatar_image:SetHeight(64*1.2)
		
		local avatar_bg = g:NewImage(window, nil, 275, 60, nil, nil, "avatarPreview2", "$parentAvatarPreviewTexture2")
		avatar_bg:SetTexture([[Interface\AddOns\Details\images\Weather-StaticField]])
		avatar_bg:SetPoint("topright", window, "topright", -5, -36)
		avatar_bg:SetTexCoord(0, 1, 1, 0)
		avatar_bg:SetSize(360, 60)
		avatar_bg:SetVertexColor(.5, .5, .5, .5)
		
		local nickname = g:NewLabel(window, _, "$parentAvatarNicknameLabel", "avatarNickname", UnitName("player"), "GameFontNormalSmall")
		nickname:SetPoint("center", avatar_bg, "center", 0, -15)
		_details:SetFontSize(nickname.widget, 18)
		
		avatar_bg:SetDrawLayer("overlay", 2)
		avatar_image:SetDrawLayer("overlay", 3)
		nickname:SetDrawLayer("overlay", 3)

		local onPressEnter = function(_, _, text)
			local accepted, errortext = _details:SetNickname(text)
			if (not accepted) then
				_details:Msg(errortext)
			end
			--> we call again here, because if not accepted the box return the previous value and if successful accepted, update the value for formated string.
			local nick = _details:GetNickname(UnitGUID("player"), UnitName("player"), true)
			window.nicknameEntry.text = nick
			nickname:SetText(nick)
			nickname:SetPoint("center", avatar_bg, "center", 0, -15)
		end
		
		local nicknamelabel = g:NewLabel(window, nil, "$parentNickNameLabel", "nicknameLabel", Loc["STRING_OPTIONS_NICKNAME"] .. ":", "GameFontHighlightLeft")
		local nicknamebox = g:NewTextEntry(window, nil, "$parentNicknameEntry", "nicknameEntry", 140, 20, onPressEnter)
		nicknamebox:HighlightText()
		
		nicknamebox:SetPoint("left", nicknamelabel, "right", 2, 0)
		nicknamelabel:SetPoint("topleft", window, "topleft", 30, -160)
		
		function _details:UpdateNicknameOnWelcomeWindow()
			nicknamebox:SetText(select(1, UnitName("player")))
		end
		_details:ScheduleTimer("UpdateNicknameOnWelcomeWindow", 2)
		
		--
		
		local avatarcallback = function(textureAvatar, textureAvatarTexCoord, textureBackground, textureBackgroundTexCoord, textureBackgroundColor)
			_details:SetNicknameBackground(textureBackground, textureBackgroundTexCoord, textureBackgroundColor, true)
			_details:SetNicknameAvatar(textureAvatar, textureAvatarTexCoord)

			avatar_image:SetTexture(textureAvatar)
			avatar_image:SetTexCoord(1, 0, 0, 1)
			
			avatar_bg.texture = textureBackground
			local r, l, t, b = unpack(textureBackgroundTexCoord)
			avatar_bg:SetTexCoord(l, r, t, b)
			local r, g, b = unpack(textureBackgroundColor)
			avatar_bg:SetVertexColor(r, g, b, 1)
			
			_G.AvatarPickFrame.callback = nil
		end
		
		local openAtavarPickFrame = function()
			_G.AvatarPickFrame.callback = avatarcallback
			_G.AvatarPickFrame:Show()
		end
		
		local avatarbutton = g:NewButton(window, _, "$parentAvatarFrame", "chooseAvatarButton", 160, 18, openAtavarPickFrame, nil, nil, nil, "Pick Avatar", 1)
		avatarbutton:InstallCustomTexture()
		avatarbutton:SetPoint("left", nicknamebox, "right", 10, 0)
		--

		local bg_avatar = window:CreateTexture(nil, "overlay")
		bg_avatar:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg_avatar:SetHeight(125*3)--125
		bg_avatar:SetWidth(89*3)--82
		bg_avatar:SetAlpha(.1)
		bg_avatar:SetTexCoord(1, 0, 0, 1)
		
		local text_avatar1 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text_avatar1:SetPoint("topleft", window, "topleft", 20, -80)
		text_avatar1:SetText("Nickname and Avatar")
		
		local text_avatar2 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text_avatar2:SetPoint("topleft", window, "topleft", 30, -190)
		text_avatar2:SetText("Avatars are shown up on tooltips and at the player detail window.")
		text_avatar2:SetTextColor(1, 1, 1, 1)
		
		local changemind = g:NewLabel(window, _, "$parentChangeMindAvatarLabel", "ChangeMindAvatarLabel", Loc["STRING_WELCOME_2"], "GameFontNormal", 9, "orange")
		changemind:SetPoint("center", window, "center")
		changemind:SetPoint("bottom", window, "bottom", 0, 19)
		changemind.align = "|"
		
		--Ambos são senddos aos demais membros da sua guilda que também usam Details!. Seu apelido é mostrado ao invés do name do seu personagem.
		
		local text_avatar3 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text_avatar3:SetPoint("topleft", window, "topleft", 30, -110)
		text_avatar3:SetText("Both are sent to the other members of your guild who also use Details!. Your nickname is displayed instead of the name of your character.")
		text_avatar3:SetWidth(460)
		text_avatar3:SetHeight(100)
		text_avatar3:SetJustifyH("left")
		text_avatar3:SetJustifyV("top")
		text_avatar3:SetTextColor(1, 1, 1, 1)

		local pleasewait = window:CreateFontString(nil, "overlay", "GameFontNormalSmall")
		pleasewait:SetPoint("bottomright", forward, "topright")
		
		local free_frame3 = CreateFrame("frame", nil, window)
		function _details:FreeTutorialFrame3()
			if (window_openned_at+10 > time()) then
				pleasewait:Show()
				forward:Disable()
				pleasewait:SetText("wait... " .. window_openned_at + 10 - time())
			else
				pleasewait:Hide()
				pleasewait:SetText("")
				forward:Enable()
				_details:CancelTimer(window.free_frame3_schedule)
				window.free_frame3_schedule = nil
			end
		end
		free_frame3:SetScript("OnShow", function()
			if (window_openned_at+10 > time()) then
				forward:Disable()
				if (window.free_frame3_schedule) then
					_details:CancelTimer(window.free_frame3_schedule)
					window.free_frame3_schedule = nil
				end
				window.free_frame3_schedule = _details:ScheduleRepeatingTimer("FreeTutorialFrame3", 1)
			end
		end)
		free_frame3:SetScript("OnHide", function()
			if (window.free_frame3_schedule) then
				_details:CancelTimer(window.free_frame3_schedule)
				window.free_frame3_schedule = nil
				pleasewait:SetText("")
				pleasewait:Hide()
			end
		end)

		pages[#pages+1] = {pleasewait, free_frame3, bg555, bg_avatar, text_avatar1, text_avatar2, text_avatar3, changemind, avatar_image, avatar_bg, nickname, nicknamelabel, nicknamebox, avatarbutton}
		
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Skins Page

	--SKINS

		local bg55 = window:CreateTexture(nil, "overlay")
		bg55:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg55:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg55:SetHeight(125*3)--125
		bg55:SetWidth(89*3)--82
		bg55:SetAlpha(.05)
		bg55:SetTexCoord(1, 0, 0, 1)

		local text55 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text55:SetPoint("topleft", window, "topleft", 20, -80)
		text55:SetText(Loc["STRING_WELCOME_42"])

		local text555 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		--text555:SetPoint("topleft", window, "topleft", 30, -190)
		text555:SetText(Loc["STRING_WELCOME_45"])
		text555:SetTextColor(1, 1, 1, 1)
		
		local changemind = g:NewLabel(window, _, "$parentChangeMind55Label", "changemind55Label", Loc["STRING_WELCOME_2"], "GameFontNormal", 9, "orange")
		window.changemind55Label:SetPoint("center", window, "center")
		window.changemind55Label:SetPoint("bottom", window, "bottom", 0, 19)
		window.changemind55Label.align = "|"
		
		local text_appearance = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text_appearance:SetPoint("topleft", window, "topleft", 30, -110)
		text_appearance:SetText(Loc["STRING_WELCOME_43"])
		text_appearance:SetWidth(460)
		text_appearance:SetHeight(100)
		text_appearance:SetJustifyH("left")
		text_appearance:SetJustifyV("top")
		text_appearance:SetTextColor(1, 1, 1, 1)
		
		local skins_image = window:CreateTexture(nil, "overlay")
		skins_image:SetTexture([[Interface\Addons\Details\images\icons2]])
		skins_image:SetPoint("topright", window, "topright", -30, -24)
		skins_image:SetWidth(214)
		skins_image:SetHeight(133)
		skins_image:SetTexCoord(0, 0.41796875, 0, 0.259765625) --0, 0, 214 133
		
		--import settings
		local import_label = g:NewLabel(window, _, "$parentImportSettingsLabel", "ImportLabel", Loc["STRING_WELCOME_46"])
		import_label:SetPoint("topleft", window, "topleft", 30, -160)

		local convert_table = {
			["bartexture"] = "row_info-texture",
			["barfont"] = "row_info-font_face",
			["barfontsize"] = "row_info-font_size",
			["barspacing"] = "row_info-space-between",
			["barheight"] = "row_info-height",
			["barbgcolor"] = "row_info-fixed_texture_background_color",
			["reversegrowth"] = "bars_grow_direction",
			["barcolor"] = "row_info-fixed_texture_color",
			["title"] = "attribute_text",
			["background"] = "null"
		}
		
		local onSelectImport = function(_, _, keyname)
			--window.ImportDropdown:Select(false)
			local addon1_profile = _G.Skada.db.profile.windows[1]
			local value = addon1_profile[keyname]
			local dvalue = convert_table[keyname]
			
			if (dvalue) then
			
				local instance1 = _details:GetInstance(1)
			
				if (keyname == "barbgcolor") then
					instance1.row_info.fixed_texture_background_color[1] = value.r
					instance1.row_info.fixed_texture_background_color[2] = value.g
					instance1.row_info.fixed_texture_background_color[3] = value.b
					instance1.row_info.fixed_texture_background_color[4] = value.a
					value = instance1.row_info.fixed_texture_background_color
					
				elseif (keyname == "title") then
					local v = instance1.attribute_text
					v.enabled = true
					v.text_face = value.font
					v.anchor = {-17, 4}
					v.text_size = value.fontsize
					instance1.color[1], instance1.color[2], instance1.color[3], instance1.color[4] = value.color.r, value.color.g, value.color.b, value.color.a
					value = v
					
				elseif (keyname == "background") then
					instance1.bg_alpha = value.color.a
					instance1.bg_r = value.color.r
					instance1.bg_g = value.color.g
					instance1.bg_b = value.color.b
					instance1.backdrop_texture = value.texture
					
					instance1:ChangeSkin()
					return
				end
			
				local key1, key2, key3 = strsplit("-", dvalue)
				if (key3) then
					instance1[key1][key2][key3] = value
				elseif (key2) then
					instance1[key1][key2] = value
				elseif (key1) then
					instance1[key1] = value
				end
				
				instance1:ChangeSkin()
			end
			
		end

		local ImportMenu = function()
			local options = {}
			if (_G.Skada) then
				tinsert(options, {value = "bartexture", label = Loc["STRING_WELCOME_47"] .. "Skada)", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
				tinsert(options, {value = "barfont", label = Loc["STRING_WELCOME_48"] .. "Skada)", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
				tinsert(options, {value = "barfontsize", label = Loc["STRING_WELCOME_49"] .. "Skada)", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
				tinsert(options, {value = "barspacing", label = Loc["STRING_WELCOME_50"] .. "Skada)", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
				tinsert(options, {value = "barheight", label = Loc["STRING_WELCOME_51"] .. "Skada)", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
				tinsert(options, {value = "barbgcolor", label = Loc["STRING_WELCOME_52"] .. "Skada)", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
				tinsert(options, {value = "reversegrowth", label = Loc["STRING_WELCOME_53"] .. "Skada)", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
				tinsert(options, {value = "barcolor", label = Loc["STRING_WELCOME_54"] .. "Skada)", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
				tinsert(options, {value = "title", label = Loc["STRING_WELCOME_55"] .. "Skada)", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
				tinsert(options, {value = "background", label = Loc["STRING_WELCOME_56"] .. "Skada)", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
				--tinsert(options, {value = "", label = "", onclick = onSelectImport, icon =[[Interface\FriendsFrame\StatusIcon-Online]]})
			end
			return options
		end
		
		local import_dropdown = g:NewDropDown(window, _, "$parentImportDropdown", "ImportDropdown", 140, 20, ImportMenu, false)
		import_dropdown:SetPoint("left", import_label, "right", 2, 0)
		import_dropdown.tooltip = Loc["STRING_WELCOME_57"]
		
		--wallpapaer and skin
		local wallpaper_label_switch = g:NewLabel(window, _, "$parentBackgroundLabel", "enablewallpaperLabel", Loc["STRING_WELCOME_44"])
		wallpaper_label_switch:SetPoint("topleft", window, "topleft", 30, -180)
		
		--skin
			local onSelectSkin = function(_, _, skin_name)
				local instance1 = _details:GetInstance(1)
				instance1:ChangeSkin(skin_name)
			end

			local buildSkinMenu = function()
				local skinOptions = {}
				for skin_name, skin_table in pairs(_details.skins) do
					skinOptions[#skinOptions+1] = {value = skin_name, label = skin_name, onclick = onSelectSkin, icon = "Interface\\GossipFrame\\TabardGossipIcon", desc = skin_table.desc}
				end
				return skinOptions
			end
			
			local instance1 = _details:GetInstance(1)
			local skin_dropdown = g:NewDropDown(window, _, "$parentSkinDropdown", "skinDropdown", 140, 20, buildSkinMenu, instance1.skin)
			skin_dropdown.tooltip = Loc["STRING_WELCOME_58"]
			
			local skin_label = g:NewLabel(window, _, "$parentSkinLabel", "skinLabel", Loc["STRING_OPTIONS_INSTANCE_SKIN"])
			skin_dropdown:SetPoint("left", skin_label, "right", 2)
			skin_label:SetPoint("topleft", window, "topleft", 30, -140)
			
			--skin_dropdown:Select("Default Skin")
			
		--wallpapper
			--> agora cria os 2 dropdown da categoria e wallpaper
			
			local onSelectSecTexture = function(_, _, texturePath) 
				if (texturePath:find("TALENTFRAME")) then
					instance:InstanceWallpaper(texturePath, nil, nil, {0, 1, 0, 0.703125})
				else
					instance:InstanceWallpaper(texturePath, nil, nil, {0, 1, 0, 1})
				end
			end
		
			local subMenu = {
				["CREDITS"] = {
					{value =[[Interface\Glues\CREDITS\Arakkoa2]], label = "Arakkoa", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Arakkoa2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Arcane_Golem2]], label = "Arcane Golem", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Arcane_Golem2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Badlands3]], label = "Badlands", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Badlands3]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\BD6]], label = "Draenei", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\BD6]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Draenei_Character1]], label = "Draenei 2", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Draenei_Character1]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Draenei_Character2]], label = "Draenei 3", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Draenei_Character2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Draenei_Crest2]], label = "Draenei Crest", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Draenei_Crest2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Draenei_Female2]], label = "Draenei 4", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Draenei_Female2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Draenei2]], label = "Draenei 5", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Draenei2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Blood_Elf_One1]], label = "Kael'thas", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Blood_Elf_One1]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\BD2]], label = "Blood Elf", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\BD2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\BloodElf_Priestess_Master2]], label = "Blood elf 2", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\BloodElf_Priestess_Master2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Female_BloodElf2]], label = "Blood Elf 3", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Female_BloodElf2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\CinSnow01TGA3]], label = "Cin Snow", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\CinSnow01TGA3]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\DalaranDomeTGA3]], label = "Dalaran", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\DalaranDomeTGA3]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Darnasis5]], label = "Darnasus", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Darnasis5]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Draenei_CityInt5]], label = "Exodar", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Draenei_CityInt5]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Shattrath6]], label = "Shattrath", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Shattrath6]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Demon_Chamber2]], label = "Demon Chamber", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Demon_Chamber2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Demon_Chamber6]], label = "Demon Chamber 2", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Demon_Chamber6]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Dwarfhunter1]], label = "Dwarf Hunter", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Dwarfhunter1]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Fellwood5]], label = "Fellwood", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Fellwood5]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\HordeBanner1]], label = "Horde Banner", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\HordeBanner1]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Illidan_Concept1]], label = "Illidan", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Illidan_Concept1]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Illidan1]], label = "Illidan 2", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Illidan1]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Naaru_CrashSite2]], label = "Naaru Crash", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Naaru_CrashSite2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\NightElves1]], label = "Night Elves", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\NightElves1]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Ocean2]], label = "Mountain", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Ocean2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Tempest_Keep2]], label = "Tempest Keep", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Tempest_Keep2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Tempest_Keep6]], label = "Tempest Keep 2", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Tempest_Keep6]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Terrokkar6]], label = "Terrokkar", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Terrokkar6]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\ThousandNeedles2]], label = "Thousand Needles", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\ThousandNeedles2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\Troll2]], label = "Troll", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\Troll2]], texcoord = nil},
					{value =[[Interface\Glues\CREDITS\LESSERELEMENTAL_FIRE_03B1]], label = "Fire Elemental", onclick = onSelectSecTexture, icon =[[Interface\Glues\CREDITS\LESSERELEMENTAL_FIRE_03B1]], texcoord = nil},
				},
			}
		
			local buildBackgroundMenu2 = function() 
				return  subMenu[window.backgroundDropdown.value] or {label = "-- -- --", value = 0}
			end
		
			local onSelectMainTexture = function(_, _, choose)
				window.backgroundDropdown2:Select(choose)
			end
		
			local backgroundTable = {
				--{value = "ARCHEOLOGY", label = "Archeology", onclick = onSelectMainTexture, icon =[[Interface\ARCHEOLOGY\Arch-Icon-Marker]]},
				{value = "CREDITS", label = "Burning Crusade", onclick = onSelectMainTexture, icon =[[Interface\ICONS\TEMP]]},
				--{value = "DEATHKNIGHT", label = "Death Knight", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["DEATHKNIGHT"]},
				--{value = "DRESSUP", label = "Class Background", onclick = onSelectMainTexture, icon =[[Interface\ICONS\INV_Chest_Cloth_17]]},
				--{value = "DRUID", label = "Druid", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["DRUID"]},
				--{value = "HUNTER", label = "Hunter", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["HUNTER"]},
				--{value = "MAGE", label = "Mage", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["MAGE"]},
				--{value = "MONK", label = "Monk", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["MONK"]},
				--{value = "PALADIN", label = "Paladin", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["PALADIN"]},
				--{value = "PRIEST", label = "Priest", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["PRIEST"]},
				--{value = "ROGUE", label = "Rogue", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["ROGUE"]},
				--{value = "SHAMAN", label = "Shaman", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["SHAMAN"]},
				--{value = "WARLOCK", label = "Warlock", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["WARLOCK"]},
				--{value = "WARRIOR", label = "Warrior", onclick = onSelectMainTexture, icon = _details.class_icons_small, texcoord = _details.class_coords["WARRIOR"]},
			}
			local buildBackgroundMenu = function() return backgroundTable end		
			
			local wallpaper_switch = g:NewSwitch(window, _, "$parentUseBackgroundSlider", "useBackgroundSlider", 60, 20, _, _, instance.wallpaper.enabled)
			wallpaper_switch.tooltip = Loc["STRING_WELCOME_59"]
			local wallpaper_dropdown1 = g:NewDropDown(window, _, "$parentBackgroundDropdown", "backgroundDropdown", 150, 20, buildBackgroundMenu, nil)
			local wallpaper_dropdown2 = g:NewDropDown(window, _, "$parentBackgroundDropdown2", "backgroundDropdown2", 150, 20, buildBackgroundMenu2, nil)

			wallpaper_switch:SetPoint("left", wallpaper_label_switch, "right", 2)
			wallpaper_dropdown1:SetPoint("left", wallpaper_switch, "right", 2)
			wallpaper_dropdown2:SetPoint("left", wallpaper_dropdown1, "right", 2)
			
			
			function _details:WelcomeWallpaperRefresh()
					local id, name, icon, _background = UniqueGetTalentSpecInfo()
					if (_background) then
						local _, class = UnitClass("player")
						
						local titlecase = function(first, rest)
							return first:upper()..rest:lower()
						end
						class = class:gsub("(%a)([%w_']*)", titlecase)
						
						local bg = "Interface\\TALENTFRAME\\" .. _background
						
						wallpaper_dropdown1:Select(class)
						wallpaper_dropdown2:Select(1, true)
						
						instance.wallpaper.texture = bg
						instance.wallpaper.texcoord = {0, 1, 0, 0.703125}
						
					end
			end
			
			_details:ScheduleTimer("WelcomeWallpaperRefresh", 5)
			
			wallpaper_switch.OnSwitch = function(_, _, value)
				instance.wallpaper.enabled = value
				if (value) then
					--> primeira vez que roda:
					if (not instance.wallpaper.texture) then
						local id, name, icon, _background = UniqueGetTalentSpecInfo()
						if (_background) then
							instance.wallpaper.texture = "Interface\\TALENTFRAME\\".._background
						end
						instance.wallpaper.texcoord = {0, 1, 0, 0.703125}
					end
					
					instance.wallpaper.alpha = 0.35

					instance:InstanceWallpaper(true)
				else
					instance:InstanceWallpaper(false)
				end
			end
			
		local created_test_bars = 0
		local skins_frame_alert = CreateFrame("frame", nil, window)
		skins_frame_alert:SetScript("OnShow", function()
			if (created_test_bars < 2) then
				_details:CreateTestBars()
				created_test_bars = created_test_bars + 1
			end
		end)

		pages[#pages+1] = {import_label, import_dropdown, skins_frame_alert, bg55, text55, text555, skins_image, changemind, text_appearance, skin_dropdown, skin_label, wallpaper_label_switch, wallpaper_switch, wallpaper_dropdown1, wallpaper_dropdown2, }
		
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 2
		
	-- DPS effective or active
		
		local ampulheta = window:CreateTexture(nil, "overlay")
		ampulheta:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		ampulheta:SetPoint("bottomright", window, "bottomright", -10, 10)
		ampulheta:SetHeight(125*3)--125
		ampulheta:SetWidth(89*3)--82
		ampulheta:SetAlpha(.05)
		ampulheta:SetTexCoord(1, 0, 0, 1)		
		
		g:NewLabel(window, _, "$parentChangeMind2Label", "changemind2Label", Loc["STRING_WELCOME_2"], "GameFontNormal", 9, "orange")
		window.changemind2Label:SetPoint("center", window, "center")
		window.changemind2Label:SetPoint("bottom", window, "bottom", 0, 19)
		window.changemind2Label.align = "|"

		local text2 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text2:SetPoint("topleft", window, "topleft", 20, -80)
		text2:SetText(Loc["STRING_WELCOME_3"])
		
		local chronameter = CreateFrame("CheckButton", "WelcomeWindowChronameter", window, "ChatConfigCheckButtonTemplate")
		chronameter:SetPoint("topleft", window, "topleft", 40, -110)
		local continuous = CreateFrame("CheckButton", "WelcomeWindowContinuous", window, "ChatConfigCheckButtonTemplate")
		continuous:SetPoint("topleft", window, "topleft", 40, -160)
		
		_G["WelcomeWindowChronameterText"]:SetText(Loc["STRING_WELCOME_4"])
		_G["WelcomeWindowContinuousText"]:SetText(Loc["STRING_WELCOME_5"])
		
		local sword_icon = window:CreateTexture(nil, "overlay")
		sword_icon:SetTexture([[Interface\TUTORIALFRAME\UI-TutorialFrame-AttackCursor]])
		sword_icon:SetPoint("topright", window, "topright", -15, -30)
		sword_icon:SetWidth(64*1.4)
		sword_icon:SetHeight(64*1.4)
		sword_icon:SetTexCoord(1, 0, 0, 1)
		sword_icon:SetDrawLayer("overlay", 2)
		local thedude = window:CreateTexture(nil, "overlay")
		thedude:SetTexture([[Interface\TUTORIALFRAME\UI-TutorialFrame-TheDude]])
		thedude:SetPoint("bottomright", sword_icon, "bottomleft", 70, 19)
		thedude:SetWidth(128*1.0)
		thedude:SetHeight(128*1.0)
		thedude:SetTexCoord(0, 1, 0, 1)
		thedude:SetDrawLayer("overlay", 3)
		
		local chronameter_text = window:CreateFontString(nil, "overlay", "GameFontNormal")
		chronameter_text:SetText(Loc["STRING_WELCOME_6"])
		chronameter_text:SetWidth(360)
		chronameter_text:SetHeight(40)
		chronameter_text:SetJustifyH("left")
		chronameter_text:SetJustifyV("top")
		chronameter_text:SetTextColor(.8, .8, .8, 1)
		chronameter_text:SetPoint("topleft", _G["WelcomeWindowChronameterText"], "topright", 0, 0)
		
		local continuous_text = window:CreateFontString(nil, "overlay", "GameFontNormal")
		continuous_text:SetText(Loc["STRING_WELCOME_7"])
		continuous_text:SetWidth(340)
		continuous_text:SetHeight(40)
		continuous_text:SetJustifyH("left")
		continuous_text:SetJustifyV("top")
		continuous_text:SetTextColor(.8, .8, .8, 1)
		continuous_text:SetPoint("topleft", _G["WelcomeWindowContinuousText"], "topright", 0, 0)
		
		chronameter:SetHitRectInsets(0, -70, 0, 0)
		continuous:SetHitRectInsets(0, -70, 0, 0)
		
		if (_details.time_type == 1) then --> chronameter
			chronameter:SetChecked(true)
			continuous:SetChecked(false)
		elseif (_details.time_type == 2) then --> continuous
			chronameter:SetChecked(false)
			continuous:SetChecked(true)
		end
		
		chronameter:SetScript("OnClick", function() continuous:SetChecked(false); _details.time_type = 1 end)
		continuous:SetScript("OnClick", function() chronameter:SetChecked(false); _details.time_type = 2 end)
		
		pages[#pages+1] = {thedude, sword_icon, ampulheta, text2, chronameter, continuous, chronameter_text, continuous_text, window.changemind2Label}
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 4

	-- UPDATE SPEED
		
		local bg = window:CreateTexture(nil, "overlay")
		bg:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg:SetHeight(125*3)--125
		bg:SetWidth(89*3)--82
		bg:SetAlpha(.05)
		bg:SetTexCoord(1, 0, 0, 1)
		
		g:NewLabel(window, _, "$parentChangeMind4Label", "changemind4Label", Loc["STRING_WELCOME_11"], "GameFontNormal", 9, "orange")
		window.changemind4Label:SetPoint("center", window, "center")
		window.changemind4Label:SetPoint("bottom", window, "bottom", 0, 19)
		window.changemind4Label.align = "|"
		
		local text4 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text4:SetPoint("topleft", window, "topleft", 20, -80)
		text4:SetText(Loc["STRING_WELCOME_41"])
		
		local interval_text = window:CreateFontString(nil, "overlay", "GameFontNormal")
		interval_text:SetText(Loc["STRING_WELCOME_12"])
		interval_text:SetWidth(460)
		interval_text:SetHeight(40)
		interval_text:SetJustifyH("left")
		interval_text:SetJustifyV("top")
		interval_text:SetTextColor(1, 1, 1, .9)
		interval_text:SetPoint("topleft", window, "topleft", 30, -110)
		
		local dance_text = window:CreateFontString(nil, "overlay", "GameFontNormal")
		dance_text:SetText(Loc["STRING_WELCOME_13"])
		dance_text:SetWidth(460)
		dance_text:SetHeight(40)
		dance_text:SetJustifyH("left")
		dance_text:SetJustifyV("top")
		dance_text:SetTextColor(1, 1, 1, 1)
		dance_text:SetPoint("topleft", window, "topleft", 30, -175)
		
	--------------- Update Speed
		g:NewLabel(window, _, "$parentUpdateSpeedLabel", "updatespeedLabel", Loc["STRING_WELCOME_14"] .. ":")
		window.updatespeedLabel:SetPoint(31, -150)
		--
		
		g:NewSlider(window, _, "$parentSliderUpdateSpeed", "updatespeedSlider", 160, 20, 0.050, 3, 0.050, _details.update_speed, true) --parent, container, name, member, w, h, min, max, step, defaultv
		window.updatespeedSlider:SetPoint("left", window.updatespeedLabel, "right", 2, 0)
		window.updatespeedSlider:SetThumbSize(50)
		window.updatespeedSlider.useDecimals = true
		local updateColor = function(slider, value)
			if (value < 1) then
				slider.amt:SetTextColor(1, value, 0)
			elseif (value > 1) then
				slider.amt:SetTextColor(-(value-3), 1, 0)
			else
				slider.amt:SetTextColor(1, 1, 0)
			end
		end
		window.updatespeedSlider:SetHook("OnValueChange", function(self, _, amount) 
			_details:CancelTimer(_details.atualizador)
			_details.update_speed = amount
			_details.atualizador = _details:ScheduleRepeatingTimer("UpdateGumpMain", _details.update_speed, -1)
			updateColor(self, amount)
		end)
		updateColor(window.updatespeedSlider, _details.update_speed)
		
		window.updatespeedSlider:SetHook("OnEnter", function()
			_details:CooltipPreset(1)
			GameCooltip:AddLine(Loc["STRING_WELCOME_15"])
			GameCooltip:ShowCooltip(window.updatespeedSlider, "tooltip")
			return true
		end)
		
		window.updatespeedSlider.tooltip = Loc["STRING_WELCOME_15"]
		
	--------------- Animate Rows
		g:NewLabel(window, _, "$parentAnimateLabel", "animateLabel", Loc["STRING_WELCOME_16"] .. ":")
		window.animateLabel:SetPoint(31, -170)
		--
		g:NewSwitch(window, _, "$parentAnimateSlider", "animateSlider", 60, 20, _, _, _details.use_row_animations) -- ltext, rtext, defaultv
		window.animateSlider:SetPoint("left",window.animateLabel, "right", 2, 0)
		window.animateSlider.OnSwitch = function(self, _, value) --> slider, fixedValue, sliderValue(false, true)
			_details:SetUseAnimations(value)
		end	
		window.animateSlider.tooltip = Loc["STRING_WELCOME_17"]
		
		
	--------------- Max Segments
		g:NewLabel(window, _, "$parentSliderLabel", "segmentsLabel", Loc["STRING_WELCOME_21"] .. ":")
		window.segmentsLabel:SetPoint(31, -190)
		--
		g:NewSlider(window, _, "$parentSlider", "segmentsSlider", 120, 20, 1, 25, 1, _details.segments_amount) -- min, max, step, defaultv
		window.segmentsSlider:SetPoint("left", window.segmentsLabel, "right", 2, 0)
		window.segmentsSlider:SetHook("OnValueChange", function(self, _, amount) --> slider, fixedValue, sliderValue
			_details.segments_amount = math.floor(amount)
		end)
		window.segmentsSlider.tooltip = Loc["STRING_WELCOME_22"]
		
	--------------
		local mech_icon = window:CreateTexture(nil, "overlay")
		mech_icon:SetTexture([[Interface\Vehicles\UI-Vehicles-Endcap-Alliance]])
		mech_icon:SetPoint("topright", window, "topright", -15, -15)
		mech_icon:SetWidth(128*0.9)
		mech_icon:SetHeight(128*0.9)
		mech_icon:SetAlpha(0.8)
		
		local mech_icon2 = window:CreateTexture(nil, "overlay")
		mech_icon2:SetTexture([[Interface\Vehicles\UI-Vehicles-Trim-Alliance]])
		mech_icon2:SetPoint("topright", window, "topright", -10, -142)
		mech_icon2:SetWidth(128*1.0)
		mech_icon2:SetHeight(128*0.6)
		mech_icon2:SetAlpha(0.6)
		mech_icon2:SetTexCoord(0, 1, 40/128, 1)
		mech_icon2:SetDrawLayer("overlay", 2)
		
	----------------
	
		local update_frame_alert = CreateFrame("frame", nil, window)
		

		
		update_frame_alert:SetScript("OnShow", function()
			_details:StartTestBarUpdate()
		end)
		
		update_frame_alert:SetScript("OnHide", function()
			_details:StopTestBarUpdate()
		end)
	
	----------------
		
		pages[#pages+1] = {update_frame_alert, mech_icon2, mech_icon, window.segmentsLabel, window.segmentsSlider, bg, text4, interval_text, dance_text, window.updatespeedLabel, window.updatespeedSlider, window.animateLabel, window.animateSlider, window.changemind4Label}
		
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 6

		local bg6 = window:CreateTexture(nil, "overlay")
		bg6:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg6:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg6:SetHeight(125*3)--125
		bg6:SetWidth(89*3)--82
		bg6:SetAlpha(.1)
		bg6:SetTexCoord(1, 0, 0, 1)

		local text5 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text5:SetPoint("topleft", window, "topleft", 20, -80)
		text5:SetText(Loc["STRING_WELCOME_26"])
		
		local text_stretch = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text_stretch:SetPoint("topleft", window, "topleft", 181, -105)
		text_stretch:SetText(Loc["STRING_WELCOME_27"])
		text_stretch:SetWidth(310)
		text_stretch:SetHeight(100)
		text_stretch:SetJustifyH("left")
		text_stretch:SetJustifyV("top")
		text_stretch:SetTextColor(1, 1, 1, 1)
		
		local stretch_image = window:CreateTexture(nil, "overlay")
		stretch_image:SetTexture([[Interface\Addons\Details\images\icons]])
		stretch_image:SetPoint("right", text_stretch, "left", -12, 0)
		stretch_image:SetWidth(144)
		stretch_image:SetHeight(61)
		stretch_image:SetTexCoord(0.716796875, 1, 0.876953125, 1)
		
		local stretch_frame_alert = CreateFrame("frame", nil, window)
		stretch_frame_alert:SetScript("OnShow", function()
			local instance = _details:GetInstance(1)
			_details.OnEnterMainWindow(instance)
			instance.baseframe.button_stretch:SetAlpha(1)
			frame_alert.alert:SetPoint("topleft", instance.baseframe.button_stretch, "topleft", -20, 6)
			frame_alert.alert:SetPoint("bottomright", instance.baseframe.button_stretch, "bottomright", 20, -14)
			
			frame_alert.alert.animOut:Stop()
			frame_alert.alert.animIn:Play()
			if (_details.stopwelcomealert) then
				_details:CancelTimer(_details.stopwelcomealert)
			end
			_details.stopwelcomealert = _details:ScheduleTimer("StopPlayStretchAlert", 5)
		end)

		
		pages[#pages+1] = {bg6, text5, stretch_image, text_stretch, stretch_frame_alert}
		
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 7

		local bg6 = window:CreateTexture(nil, "overlay")
		bg6:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg6:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg6:SetHeight(125*3)--125
		bg6:SetWidth(89*3)--82
		bg6:SetAlpha(.1)
		bg6:SetTexCoord(1, 0, 0, 1)

		local text6 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text6:SetPoint("topleft", window, "topleft", 20, -80)
		text6:SetText(Loc["STRING_WELCOME_28"])
		
		local text_instance_button = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text_instance_button:SetPoint("topleft", window, "topleft", 25, -105)
		text_instance_button:SetText(Loc["STRING_WELCOME_29"])
		text_instance_button:SetWidth(270)
		text_instance_button:SetHeight(100)
		text_instance_button:SetJustifyH("left")
		text_instance_button:SetJustifyV("top")
		text_instance_button:SetTextColor(1, 1, 1, 1)
		
		local instance_button_image = window:CreateTexture(nil, "overlay")
		instance_button_image:SetTexture([[Interface\Addons\Details\images\icons]])
		instance_button_image:SetPoint("topright", window, "topright", -12, -70)
		instance_button_image:SetWidth(204)
		instance_button_image:SetHeight(141)
		instance_button_image:SetTexCoord(0.31640625, 0.71484375, 0.724609375, 1)
		
		local instance_frame_alert = CreateFrame("frame", nil, window)
		instance_frame_alert:SetScript("OnShow", function()
			local instance = _details:GetInstance(1)

			frame_alert.alert:SetPoint("topleft", instance.baseframe.header.novo, "topleft", -8, 6)
			frame_alert.alert:SetPoint("bottomright", instance.baseframe.header.novo, "bottomright", 8, -6)
			
			frame_alert.alert.animOut:Stop()
			frame_alert.alert.animIn:Play()
			if (_details.stopwelcomealert) then
				_details:CancelTimer(_details.stopwelcomealert)
			end
			_details.stopwelcomealert = _details:ScheduleTimer("StopPlayStretchAlert", 5)
		end)
		
		pages[#pages+1] = {bg6, text6, instance_button_image, text_instance_button, instance_frame_alert}
		
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 8

		local bg7 = window:CreateTexture(nil, "overlay")
		bg7:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg7:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg7:SetHeight(125*3)--125
		bg7:SetWidth(89*3)--82
		bg7:SetAlpha(.1)
		bg7:SetTexCoord(1, 0, 0, 1)

		local text7 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text7:SetPoint("topleft", window, "topleft", 20, -80)
		text7:SetText(Loc["STRING_WELCOME_30"])
		
		local text_shortcut = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text_shortcut:SetPoint("topleft", window, "topleft", 25, -110)
		text_shortcut:SetText(Loc["STRING_WELCOME_31"])
		text_shortcut:SetWidth(320)
		text_shortcut:SetHeight(90)
		text_shortcut:SetJustifyH("left")
		text_shortcut:SetJustifyV("top")
		text_shortcut:SetTextColor(1, 1, 1, 1)
		
		local shortcut_image1 = window:CreateTexture(nil, "overlay")
		shortcut_image1:SetTexture([[Interface\Addons\Details\images\icons]])
		shortcut_image1:SetPoint("topright", window, "topright", -12, -20)
		shortcut_image1:SetWidth(160)
		shortcut_image1:SetHeight(91)
		shortcut_image1:SetTexCoord(0, 0.31250, 0.82421875, 1)
		
		local shortcut_image2 = window:CreateTexture(nil, "overlay")
		shortcut_image2:SetTexture([[Interface\Addons\Details\images\icons]])
		shortcut_image2:SetPoint("topright", window, "topright", -12, -110)
		shortcut_image2:SetWidth(160)
		shortcut_image2:SetHeight(106)
		shortcut_image2:SetTexCoord(0, 0.31250, 0.59375, 0.80078125)
		
		pages[#pages+1] = {bg7, text7, shortcut_image1, shortcut_image2, text_shortcut}
		
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 9

		local bg77 = window:CreateTexture(nil, "overlay")
		bg77:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg77:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg77:SetHeight(125*3)--125
		bg77:SetWidth(89*3)--82
		bg77:SetAlpha(.1)
		bg77:SetTexCoord(1, 0, 0, 1)

		local text77 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text77:SetPoint("topleft", window, "topleft", 20, -80)
		text77:SetText(Loc["STRING_WELCOME_32"])
		
		local text_snap = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text_snap:SetPoint("topleft", window, "topleft", 25, -101)
		text_snap:SetText(Loc["STRING_WELCOME_33"])
		text_snap:SetWidth(160)
		text_snap:SetHeight(110)
		text_snap:SetJustifyH("left")
		text_snap:SetJustifyV("top")
		text_snap:SetTextColor(1, 1, 1, 1)
		local source, _, flags = text_snap:GetFont()
		text_snap:SetFont(source, 11, flags)
		
		local snap_image1 = window:CreateTexture(nil, "overlay")
		snap_image1:SetTexture([[Interface\Addons\Details\images\icons]])
		snap_image1:SetPoint("topright", window, "topright", -12, -95)
		snap_image1:SetWidth(308)
		snap_image1:SetHeight(121)
		snap_image1:SetTexCoord(0, 0.6015625, 0.353515625, 0.58984375)

		
		pages[#pages+1] = {bg77, text77, snap_image1, text_snap}
		
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 10

		local bg88 = window:CreateTexture(nil, "overlay")
		bg88:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg88:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg88:SetHeight(125*3)--125
		bg88:SetWidth(89*3)--82
		bg88:SetAlpha(.1)
		bg88:SetTexCoord(1, 0, 0, 1)

		local text88 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text88:SetPoint("topleft", window, "topleft", 20, -80)
		text88:SetText(Loc["STRING_WELCOME_34"])
		--|cFFFFFF00
		local text_micro_display = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text_micro_display:SetPoint("topleft", window, "topleft", 25, -101)
		text_micro_display:SetText(Loc["STRING_WELCOME_35"])
		text_micro_display:SetWidth(160)
		text_micro_display:SetHeight(110)
		text_micro_display:SetJustifyH("left")
		text_micro_display:SetJustifyV("top")
		text_micro_display:SetTextColor(1, 1, 1, 1)
		--local source, _, flags = text_micro_display:GetFont()
		--text_micro_display:SetFont(source, 11, flags)
		
		local micro_image1 = window:CreateTexture(nil, "overlay")
		micro_image1:SetTexture([[Interface\Addons\Details\images\icons]])
		micro_image1:SetPoint("topright", window, "topright", -12, -95)
		micro_image1:SetWidth(303)
		micro_image1:SetHeight(128)
		micro_image1:SetTexCoord(0.408203125, 1, 0.09375, 0.341796875)
		
		pages[#pages+1] = {bg88, text88, micro_image1, text_micro_display}
		
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 11

		local bg11 = window:CreateTexture(nil, "overlay")
		bg11:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg11:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg11:SetHeight(125*3)--125
		bg11:SetWidth(89*3)--82
		bg11:SetAlpha(.1)
		bg11:SetTexCoord(1, 0, 0, 1)

		local text11 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text11:SetPoint("topleft", window, "topleft", 20, -80)
		text11:SetText(Loc["STRING_WELCOME_36"])
		--|cFFFFFF00
		local text_plugins = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text_plugins:SetPoint("topleft", window, "topleft", 25, -101)
		text_plugins:SetText(Loc["STRING_WELCOME_37"])
		text_plugins:SetWidth(220)
		text_plugins:SetHeight(110)
		text_plugins:SetJustifyH("left")
		text_plugins:SetJustifyV("top")
		text_plugins:SetTextColor(1, 1, 1, 1)
		--local source, _, flags = text_plugins:GetFont()
		--text_plugins:SetFont(source, 11, flags)
		
		local plugins_image1 = window:CreateTexture(nil, "overlay")
		plugins_image1:SetTexture([[Interface\Addons\Details\images\icons2]])
		plugins_image1:SetPoint("topright", window, "topright", -12, -35)
		plugins_image1:SetWidth(226)
		plugins_image1:SetHeight(181)
		plugins_image1:SetTexCoord(0.55859375, 1, 0.646484375, 1)
		
		pages[#pages+1] = {bg11, text11, plugins_image1, text_plugins}
		
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end		
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 12

		local bg8 = window:CreateTexture(nil, "overlay")
		bg8:SetTexture([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg8:SetPoint("bottomright", window, "bottomright", -10, 10)
		bg8:SetHeight(125*3)--125
		bg8:SetWidth(89*3)--82
		bg8:SetAlpha(.1)
		bg8:SetTexCoord(1, 0, 0, 1)

		local text8 = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text8:SetPoint("topleft", window, "topleft", 20, -80)
		text8:SetText(Loc["STRING_WELCOME_38"])
		
		local text = window:CreateFontString(nil, "overlay", "GameFontNormal")
		text:SetPoint("topleft", window, "topleft", 25, -110)
		text:SetText(Loc["STRING_WELCOME_39"])
		text:SetWidth(410)
		text:SetHeight(90)
		text:SetJustifyH("left")
		text:SetJustifyV("top")
		text:SetTextColor(1, 1, 1, 1)

		pages[#pages+1] = {bg8, text8, text, report_image1}
		
		for _, widget in ipairs(pages[#pages]) do 
			widget:Hide()
		end
		
------------------------------------------------------------------------------------------------------------------------------		
		
		--[[
		forward:Click() 
		forward:Click()
		forward:Click()
		forward:Click()
		forward:Click()
		forward:Click()
		forward:Click()
		--forward:Click()
		--forward:Click()
		--forward:Click()
		--]]

	end
	
end