local _details = 		_G._details
local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local gump = 			_details.gump
local _
--lua locals
--local _string_len = string.len
local _math_floor = math.floor
local _ipairs = ipairs
local _pairs = pairs
local _type = type
--api locals
local _CreateFrame = CreateFrame
local _GetTime = GetTime
local _GetSpellInfo = _details.getspellinfo
local _GetCursorPosition = GetCursorPosition
local _unpack = unpack

local attributes = _details.attributes
local sub_attributes = _details.sub_attributes

local info = _details.window_info
local class_icons = _G.CLASS_ICON_TCOORDS

------------------------------------------------------------------------------------------------------------------------------
--self = instance
--player = class_damage ou class_heal

function _details:OpenWindowInfo(player, from_att_change)

	if (not _details.row_singleclick_overwrite[self.attribute] or not _details.row_singleclick_overwrite[self.attribute][self.sub_attribute]) then
		_details:CloseWindowInfo()
		return
	elseif (_type(_details.row_singleclick_overwrite[self.attribute][self.sub_attribute]) == "function") then
		if (from_att_change) then
			_details:CloseWindowInfo()
			return
		end
		return _details.row_singleclick_overwrite[self.attribute][self.sub_attribute](_, player, self)
	end
	
	if (self.mode == _details._details_props["MODE_RAID"]) then
		_details:CloseWindowInfo()
		return
	end

	--> _details.info_player armazena o player que this sendo mostrado na window de details
	if (info.player and info.player == player and self and info.attribute and self.attribute == info.attribute and self.sub_attribute == info.sub_attribute) then
		_details:CloseWindowInfo() --> se clicou na mesma bar então close a window de details
		return
	elseif (not player) then
		_details:CloseWindowInfo()
		return
	end

	if (info.bars1) then
		for index, bar in ipairs(info.bars1) do 
			bar.other_actor = nil
		end
	end
	
	if (info.bars2) then
		for index, bar in ipairs(info.bars2) do 
			bar.icon:SetTexture(nil)
			bar.icon:SetTexCoord(0, 1, 0, 1)
		end
	end
	
	--> vamos passar os parâmetros para dentro da table da window...

	info.active = true --> sinaliza o addon que a window this aberta
	info.attribute = self.attribute --> instance.attribute -> grava o attribute(damage, heal, etc)
	info.sub_attribute = self.sub_attribute --> instance.sub_attribute -> grava o sub attribute(damage done, dps, damage taken, etc)
	info.player = player --> de which player(objeto class_damage)
	info.instance = self --> salva a referência da instância que pediu o info
	
	info.target_text = Loc["STRING_TARGETS"] .. ":"
	info.target_member = "total"
	info.target_persecond = false
	
	info.displaying = nil
	
	local name = info.player.name --> name do player
	local attribute_name = sub_attributes[info.attribute].list[info.sub_attribute] .. " " .. Loc["STRING_ACTORFRAME_REPORTOF"] --> // name do attribute // precisa ser o sub attribute correto???
	
	--> removendo o name da realm do player
	if (name:find("-")) then
		name = name:gsub(("-.*"), "")
	end

	if (info.instance.attribute == 1 and info.instance.sub_attribute == 6) then --> enemy
		attribute_name = sub_attributes[info.attribute].list[1] .. " " .. Loc["STRING_ACTORFRAME_REPORTOF"]
	end

	info.name:SetText(name)
	info.attribute_name:SetText(attribute_name)

	local serial = player.serial
	local avatar
	if (serial ~= "") then
		avatar = NickTag:GetNicknameTable(serial)
	end
	
	if (avatar and avatar[1]) then
		info.name:SetText(avatar[1] or name)
	end
	
	if (avatar and avatar[2]) then

		info.avatar:SetTexture(avatar[2])
		info.avatar_bg:SetTexture(avatar[4])
		if (avatar[5]) then
			info.avatar_bg:SetTexCoord(unpack(avatar[5]))
		end
		if (avatar[6]) then
			info.avatar_bg:SetVertexColor(unpack(avatar[6]))
		end
		
		info.avatar_nick:SetText(avatar[1] or name)
		info.avatar_attribute:SetText(attribute_name)
		
		info.avatar_attribute:SetPoint("CENTER", info.avatar_nick, "CENTER", 0, 14)
		info.avatar:Show()
		info.avatar_bg:Show()
		info.avatar_bg:SetAlpha(.65)
		info.avatar_nick:Show()
		info.avatar_attribute:Show()
		info.name:Hide()
		info.attribute_name:Hide()
		
	else
	
		info.avatar:Hide()
		info.avatar_bg:Hide()
		info.avatar_nick:Hide()
		info.avatar_attribute:Hide()
		
		info.name:Show()
		info.attribute_name:Show()
	end
	
	info.attribute_name:SetPoint("CENTER", info.name, "CENTER", 0, 14)
	
	info.no_targets:Hide()
	info.no_targets.text:Hide()
	gump:SwitchBackgroundInfo(info)
	
	gump:HidaAllBarsInfo()
	gump:HidaAllBarsTarget()
	gump:HidaAllDetailInfo()
	
	gump:JI_UpdateContainerBars(-1)
	
	local class = player.class
	
	if (not class) then
		class = "monster"
	end
	
	--info.class_icon:SetTexture("Interface\\AddOns\\Details\\images\\"..class:lower()) --> top left
	info.class_icon:SetTexture("Interface\\AddOns\\Details\\images\\classes") --> top left

	if (class ~= "UNKNOW" and class ~= "UNGROUPPLAYER") then

		
		info.class_icon:SetTexCoord(_details.class_coords[class][1], _details.class_coords[class][2], _details.class_coords[class][3], _details.class_coords[class][4])
		if (player.enemy) then 
			--> completa com a borda
			--info.class_iconPlus:SetTexture("Interface\\AddOns\\Details\\images\\classes_plus")
			if (_details.faction_against == "Horde") then
				--info.class_iconPlus:SetTexCoord(0.25, 0.5, 0, 0.25)
				info.name:SetTextColor(1, 91/255, 91/255, 1)
			else
				--info.class_iconPlus:SetTexCoord(0, 0.25, 0, 0.25)
				info.name:SetTextColor(151/255, 215/255, 1, 1)
			end
		else
			info.class_iconPlus:SetTexture()
			info.name:SetTextColor(1, 1, 1, 1)
		end
	else
		if (player.enemy) then 
			if (_details.class_coords[_details.faction_against]) then
				info.class_icon:SetTexCoord(_unpack(_details.class_coords[_details.faction_against]))
				if (_details.faction_against == "Horde") then
					info.name:SetTextColor(1, 91/255, 91/255, 1)
				else
					info.name:SetTextColor(151/255, 215/255, 1, 1)
				end
			else
				info.name:SetTextColor(1, 1, 1, 1)
			end
		else
			--info.class_icon:SetTexture("Interface\\AddOns\\Details\\images\\monster")
			--info.class_icon:SetTexCoord(0, 1, 0, 1)
			info.class_icon:SetTexCoord(_details.class_coords["MONSTER"][1], _details.class_coords["MONSTER"][2], _details.class_coords["MONSTER"][3], _details.class_coords["MONSTER"][4])
		end
		
		info.class_iconPlus:SetTexture()
	end
	
	info:ShowTabs()
	gump:Fade(info, 0)
	
	return player:SetInfo()
end

-- for beta todo: info background need a major rewrite
function gump:SwitchBackgroundInfo()

	if (info.attribute == 1) then --> DANO
	
		if (info.sub_attribute == 1 or info.sub_attribute == 2) then --> damage done / dps
			if (info.type ~= 1) then --> window com as divisorias
				info.bg1:SetTexture([[Interface\AddOns\Details\images\info_window_background]])
				info.bg1_sec_texture:SetTexture(nil)
				info.type = 1
			end
			
			if (info.sub_attribute == 2) then
				info.targets:SetText(Loc["STRING_TARGETS"] .. " " .. Loc["STRING_ATTRIBUTE_DAMAGE_DPS"] .. ":")
				info.target_persecond = true
			else
				info.targets:SetText(Loc["STRING_TARGETS"] .. ":")
			end
			
		elseif (info.sub_attribute == 3) then --> damage taken
			if (info.type ~= 2) then --> window com fundo diferente
				info.bg1:SetTexture([[Interface\AddOns\Details\images\info_window_background]])
				info.bg1_sec_texture:SetTexture([[Interface\AddOns\Details\images\info_window_damagetaken]])
				info.type = 2
			end
			
			info.targets:SetText(Loc["STRING_TARGETS"] .. ":")
			info.no_targets:Show()
			info.no_targets.text:Show()
			
		elseif (info.sub_attribute == 4) then --> friendly fire
			if (info.type ~= 3) then --> window com fundo diferente
				info.bg1:SetTexture([[Interface\AddOns\Details\images\info_window_background]])
				info.bg1_sec_texture:SetTexture([[Interface\AddOns\Details\images\info_window_damagetaken]])
				info.type = 3
			end
			info.targets:SetText(Loc["STRING_SPELLS"] .. ":")
			
		elseif (info.sub_attribute == 6) then --> enemies
			if (info.type ~= 3) then --> window com fundo diferente
				info.bg1:SetTexture([[Interface\AddOns\Details\images\info_window_background]])
				info.bg1_sec_texture:SetTexture([[Interface\AddOns\Details\images\info_window_damagetaken]])
				info.type = 3
			end
			info.targets:SetText(Loc["STRING_DAMAGE_TAKEN_FROM"])
		end
		
	elseif (info.attribute == 2) then --> HEALING
		if (info.sub_attribute == 1 or info.sub_attribute == 2 or info.sub_attribute == 3) then --> damage done / dps
			if (info.type ~= 1) then --> window com as divisorias
				info.bg1:SetTexture([[Interface\AddOns\Details\images\info_window_background]])
				info.bg1_sec_texture:SetTexture(nil)
				info.type = 1
			end
			
			if (info.sub_attribute == 3) then
				info.targets:SetText(Loc["STRING_OVERHEALED"] .. ":")
				info.target_member = "overheal"
				info.target_text = Loc["STRING_OVERHEALED"] .. ":"
			elseif (info.sub_attribute == 2) then
				info.targets:SetText(Loc["STRING_TARGETS"] .. " " .. Loc["STRING_ATTRIBUTE_HEAL_HPS"] .. ":")
				info.target_persecond = true
			else
				info.targets:SetText(Loc["STRING_TARGETS"] .. ":")
			end
			
		elseif (info.sub_attribute == 4) then --> Healing taken
			if (info.type ~= 2) then --> window com fundo diferente			
				info.bg1:SetTexture([[Interface\AddOns\Details\images\info_window_background]])
				info.bg1_sec_texture:SetTexture([[Interface\AddOns\Details\images\info_window_damagetaken]])
				info.type = 2
			end
			
			info.targets:SetText(Loc["STRING_TARGETS"] .. ":")
			info.no_targets:Show()
			info.no_targets.text:Show()
		end
		
	elseif (info.attribute == 3) then --> REGEN
		if (info.type ~= 2) then --> window com fundo diferente
			info.bg1:SetTexture([[Interface\AddOns\Details\images\info_window_background]])
			info.bg1_sec_texture:SetTexture(nil)
			info.type = 2
		end
		info.targets:SetText("Vindo de:")
	
	elseif (info.attribute == 4) then --> MISC
		if (info.type ~= 2) then --> window com fundo diferente
			info.bg1:SetTexture([[Interface\AddOns\Details\images\info_window_background]])
			info.bg1_sec_texture:SetTexture(nil)
			info.type = 2
		end
		info.targets:SetText(Loc["STRING_TARGETS"] .. ":")
		
	end
end

--> self é whichquer coisa que chamar this função
------------------------------------------------------------------------------------------------------------------------------
-- é chamado pelo click no X e pelo reset do history
function _details:CloseWindowInfo(fromEscape)
	if (info.active) then --> se a window tiver aberta
		--window_info:Hide()
		if (fromEscape) then
			gump:Fade(info, "in")
		else
			gump:Fade(info, 1)
		end
		info.active = false --> sinaliza o addon que a window this agora closeda
		
		--_details.info_player.details = nil
		info.player = nil
		info.attribute = nil
		info.sub_attribute = nil
		info.instance = nil
		
		info.name:SetText("")
		info.attribute_name:SetText("")
		
		gump:JI_UpdateContainerBars(-1) --> reseta o frame das bars			
	end
end

--> esconde todas as bars das skills na window de info
------------------------------------------------------------------------------------------------------------------------------
function gump:HidaAllBarsInfo()
	local bars = _details.window_info.bars1
	for index = 1, #bars, 1 do
		bars[index]:Hide()
		bars[index].texture:SetStatusBarColor(1, 1, 1, 1)
		bars[index].on_focus = false
	end
end

--> esconde todas as bars dos targets do player
------------------------------------------------------------------------------------------------------------------------------
function gump:HidaAllBarsTarget()
	local bars = _details.window_info.bars2
	for index = 1, #bars, 1 do
		bars[index]:Hide()
	end
end

--> esconde as 5 bars a right na window de info
------------------------------------------------------------------------------------------------------------------------------
function gump:HidaAllDetailInfo()
	for i = 1, 5 do
		gump:HidaDetailInfo(i)
	end
	for _, bar in _ipairs(info.bars3) do 
		bar:Hide()
	end
	_details.window_info.spell_icon:SetTexture("")
end


--> seta os scripts da window de informações
local mouse_down_func = function(self, button)
	if (button == "LeftButton") then
		info:StartMoving()
		info.isMoving = true
	elseif (button == "RightButton" and not self.isMoving) then
		_details:CloseWindowInfo()
	end
end

local mouse_up_func = function(self, button)
	if (info.isMoving) then
		info:StopMovingOrSizing()
		info.isMoving = false
	end
end

------------------------------------------------------------------------------------------------------------------------------
local function seta_scripts(this_gump)

	--> Window
	this_gump:SetScript("OnMouseDown", mouse_down_func)
	this_gump:SetScript("OnMouseUp", mouse_up_func)

	this_gump.container_bars.gump:SetScript("OnMouseDown", mouse_down_func)
	this_gump.container_bars.gump:SetScript("OnMouseUp", mouse_up_func)
					
	this_gump.container_details:SetScript("OnMouseDown", mouse_down_func)
	this_gump.container_details:SetScript("OnMouseUp", mouse_up_func)

	this_gump.container_targets.gump:SetScript("OnMouseDown", mouse_down_func)
	this_gump.container_targets.gump:SetScript("OnMouseUp", mouse_up_func)

	--> botão close
	this_gump.close:SetScript("OnClick", function(self) 
		_details:CloseWindowInfo()
	end)
end



------------------------------------------------------------------------------------------------------------------------------
function gump:HidaDetailInfo(index)
	local info = _details.window_info.groups_details[index]
	info.name:SetText("")
	info.name2:SetText("")
	info.damage:SetText("")
	info.damage_percent:SetText("")
	info.damage_media:SetText("")
	info.damage_dps:SetText("")
	info.bg:Hide()
end

--> cria a bar de details a right da window de informações
------------------------------------------------------------------------------------------------------------------------------

local detail_infobg_onenter = function(self)
	gump:Fade(self.overlay, "OUT") 
	gump:Fade(self.report, "OUT")
end

local detail_infobg_onleave = function(self)
	gump:Fade(self.overlay, "IN")
	gump:Fade(self.report, "IN")
end

local details_inforeport_onenter = function(self)
	gump:Fade(self:GetParent().overlay, "OUT")
	gump:Fade(self, "OUT")
end
local details_inforeport_onleave = function(self)
	gump:Fade(self:GetParent().overlay, "IN")
	gump:Fade(self, "IN")
end

function gump:CreateDetailInfo(index)

	local info = {}
	info.name = _details.window_info.container_details:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	info.name2 = _details.window_info.container_details:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	info.damage = _details.window_info.container_details:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	info.damage_percent = _details.window_info.container_details:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	info.damage_media = _details.window_info.container_details:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	info.damage_dps = _details.window_info.container_details:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	
	info.bg = _CreateFrame("StatusBar", nil, _details.window_info.container_details)
	info.bg:SetStatusBarTexture("Interface\\AddOns\\Details\\images\\bar_details2")
	info.bg:SetMinMaxValues(0, 100)
	info.bg:SetValue(100)
	
	info.bg:SetWidth(219)
	info.bg:SetHeight(47)
	
	info.bg.overlay = info.bg:CreateTexture(nil, "ARTWORK")
	info.bg.overlay:SetTexture("Interface\\AddOns\\Details\\images\\overlay_details")
	info.bg.overlay:SetWidth(241)
	info.bg.overlay:SetHeight(61)
	info.bg.overlay:SetPoint("TOPLEFT", info.bg, "TOPLEFT", -7, 6)
	gump:Fade(info.bg.overlay, 1)
	
	info.bg.report = gump:NewDetailsButton(info.bg, nil, nil, _details.Report, _details.window_info, 10+index, 16, 16,
	--_details.icons.report.up, _details.icons.report.down, _details.icons.report.disabled)
	"Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", nil, "DetailsWindowInfoReport1")
	info.bg.report:SetPoint("BOTTOMLEFT", info.bg.overlay, "BOTTOMRIGHT",  -33, 10)
	gump:Fade(info.bg.report, 1)
	
	info.bg:SetScript("OnEnter", detail_infobg_onenter)
	info.bg:SetScript("OnLeave", detail_infobg_onleave)

	info.bg.report:SetScript("OnEnter", details_inforeport_onenter)
	info.bg.report:SetScript("OnLeave", details_inforeport_onleave)

	info.bg_end = info.bg:CreateTexture(nil, "BACKGROUND")
	info.bg_end:SetHeight(47)
	info.bg_end:SetTexture("Interface\\AddOns\\Details\\images\\bar_details2_end")

	_details.window_info.groups_details[index] = info
end

--> determina which a pocisão que a bar de details vai ocupar
------------------------------------------------------------------------------------------------------------------------------
function gump:SetaDetailInfoAltura(index)
	local info = _details.window_info.groups_details[index]
	local window =  _details.window_info.container_details
	local altura = {-10, -63, -118, -173, -228}
	local x1 = 64
	local x2 = 160
	
	altura = altura[index]
	
	info.bg:SetPoint("TOPLEFT", window, "TOPLEFT", x1-2, altura+2)
	info.bg_end:SetPoint("LEFT", info.bg, "LEFT", info.bg:GetValue()*2.19, 0)
	info.bg:Hide()
	
	info.name:SetPoint("TOPLEFT", window, "TOPLEFT", x1, altura)
	info.name2:SetPoint("TOPLEFT", window, "TOPLEFT", x2, altura)
	info.damage:SetPoint("TOPLEFT", window, "TOPLEFT", x1, altura +(-20))
	info.damage_percent:SetPoint("TOPLEFT", window, "TOPLEFT", x2, altura +(-20))
	info.damage_media:SetPoint("TOPLEFT", window, "TOPLEFT", x1, altura +(-30))
	info.damage_dps:SetPoint("TOPLEFT", window, "TOPLEFT", x2, altura +(-30))
end

--> seta o conteúdo da bar de details
------------------------------------------------------------------------------------------------------------------------------
function gump:SetaDetailInfoText(index, p, arg1, arg2, arg3, arg4, arg5, arg6)
	local info = _details.window_info.groups_details[index]
	
	if (p) then
		if (_type(p) == "table") then
			info.bg:SetValue(p.p)
			info.bg:SetStatusBarColor(p.c[1], p.c[2], p.c[3])
		else
			info.bg:SetValue(p)
			info.bg:SetStatusBarColor(1, 1, 1)
		end
		
		info.bg_end:SetPoint("LEFT", info.bg, "LEFT",(info.bg:GetValue()*2.19)-6, 0)
		info.bg:Show()
	end
	
	if (info.IsPet) then 
		info.bg.PetIcon:Hide()
		info.bg.PetText:Hide()
		info.bg.PetDps:Hide()
		gump:Fade(info.bg.overlay, "IN")
		info.IsPet = false
	end
	
	if (arg1) then
		info.name:SetText(arg1)
	end
	
	if (arg2) then
		info.damage:SetText(arg2)
	end
	
	if (arg3) then
		info.damage_percent:SetText(arg3)
	end
	
	if (arg4) then
		info.damage_media:SetText(arg4)
	end
	
	if (arg5) then
		info.damage_dps:SetText(arg5)
	end
	
	if (arg6) then
		info.name2:SetText(arg6)
	end
	
	info.name:Show()
	info.damage:Show()
	info.damage_percent:Show()
	info.damage_media:Show()
	info.damage_dps:Show()
	info.name2:Show()
	
end

--> cria as 5 caixas de details infos que serão used
------------------------------------------------------------------------------------------------------------------------------
local function cria_bars_details()
	_details.window_info.groups_details = {}

	gump:CreateDetailInfo(1)
	gump:SetaDetailInfoAltura(1)
	gump:CreateDetailInfo(2)
	gump:SetaDetailInfoAltura(2)
	gump:CreateDetailInfo(3)
	gump:SetaDetailInfoAltura(3)
	gump:CreateDetailInfo(4)
	gump:SetaDetailInfoAltura(4)
	gump:CreateDetailInfo(5)
	gump:SetaDetailInfoAltura(5)
end

--> cria os texts em general da window info
------------------------------------------------------------------------------------------------------------------------------
local function cria_texts(this_gump)
	this_gump.name = this_gump:CreateFontString(nil, "OVERLAY", "QuestFont_Large")
	this_gump.name:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 105, -54)
	
	this_gump.attribute_name = this_gump:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	
	this_gump.targets = this_gump:CreateFontString(nil, "OVERLAY", "QuestFont_Large")
	this_gump.targets:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 24, -235)
	this_gump.targets:SetText(Loc["STRING_TARGETS"] .. ":")

	this_gump.avatar = this_gump:CreateTexture(nil, "overlay")
	this_gump.avatar_bg = this_gump:CreateTexture(nil, "overlay")
	this_gump.avatar_attribute = this_gump:CreateFontString(nil, "overlay", "GameFontNormalSmall")
	this_gump.avatar_nick = this_gump:CreateFontString(nil, "overlay", "QuestFont_Large")
	this_gump.avatar:SetDrawLayer("overlay", 3)
	this_gump.avatar_bg:SetDrawLayer("overlay", 2)
	this_gump.avatar_nick:SetDrawLayer("overlay", 4)
	
	this_gump.avatar:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 60, -10)
	this_gump.avatar_bg:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 60, -12)
	this_gump.avatar_bg:SetSize(275, 60)
	
	this_gump.avatar_nick:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 195, -54)
	
	this_gump.avatar:Hide()
	this_gump.avatar_bg:Hide()
	this_gump.avatar_nick:Hide()
	
end


--> left superior
local function cria_container_bars(this_gump)

	local container_bars_window = _CreateFrame("ScrollFrame", "Details_Info_ContainerBarsScroll", this_gump) 
	local container_bars = _CreateFrame("Frame", "Details_Info_ContainerBars", container_bars_window)

	container_bars_window:SetBackdrop({
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-gold-Border", tile = true, tileSize = 16, edgeSize = 5,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})		
	container_bars_window:SetBackdropBorderColor(0, 0, 0, 0)
	
	container_bars:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})		
	container_bars:SetBackdropColor(0, 0, 0, 0)

	container_bars:SetAllPoints(container_bars_window)
	container_bars:SetWidth(300)
	container_bars:SetHeight(150)
	container_bars:EnableMouse(true)
	container_bars:SetResizable(false)
	container_bars:SetMovable(true)
	
	container_bars_window:SetWidth(300)
	container_bars_window:SetHeight(145)
	container_bars_window:SetScrollChild(container_bars)
	container_bars_window:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 21, -76)

	gump:NewScrollBar(container_bars_window, container_bars, 6, -17)
	container_bars_window.slider:Altura(117)
	container_bars_window.slider:cimaPoint(0, 1)
	container_bars_window.slider:baixoPoint(0, -3)

	container_bars_window.ultimo = 0
	
	container_bars_window.gump = container_bars
	--container_bars_window.slider = slider_gump
	this_gump.container_bars = container_bars_window
	
end

function gump:JI_UpdateContainerBars(amt)

	local container = _details.window_info.container_bars
	
	if (amt >= 9 and container.ultimo ~= amt) then
		local tamanho = 17*amt
		container.gump:SetHeight(tamanho)
		container.slider:Update()
		container.ultimo = amt
	elseif (amt < 8 and container.slider.active) then
		container.slider:Update(true)
		container.gump:SetHeight(140)
		container.scroll_active = false
		container.ultimo = 0
	end
end


function gump:JI_UpdateContainerTargets(amt)

	local container = _details.window_info.container_targets
	
	if (amt >= 6 and container.ultimo ~= amt) then
		local tamanho = 17*amt
		container.gump:SetHeight(tamanho)
		container.slider:Update()
		container.ultimo = amt
	elseif (amt <= 5 and container.slider.active) then
		container.slider:Update(true)
		container.gump:SetHeight(100)
		container.scroll_active = false
		container.ultimo = 0
	end
end

--> container right
local function cria_container_details(this_gump)
	local container_details = _CreateFrame("Frame", "Details_Info_ContainerDetails", this_gump)
	
	container_details:SetPoint("TOPRIGHT", this_gump, "TOPRIGHT", -74, -76)
	container_details:SetWidth(220)
	container_details:SetHeight(270)
	container_details:EnableMouse(true)
	container_details:SetResizable(false)
	container_details:SetMovable(true)
	
	this_gump.container_details = container_details
end

--> left inferior
local function cria_container_targets(this_gump)
	local container_targets_window = _CreateFrame("ScrollFrame", "Details_Info_ContainerTargetsScroll", this_gump)
	local container_targets = _CreateFrame("Frame", "Details_Info_ContainerTargets", container_targets_window)

	container_targets_window:SetBackdrop({
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-gold-Border", tile = true, tileSize = 16, edgeSize = 5,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})		
	container_targets_window:SetBackdropBorderColor(0,0,0,0)
	
	--container_targets:SetBackdrop({
	--	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
	--	insets = {left = 1, right = 1, top = 0, bottom = 1},})		
	--container_targets:SetBackdropColor(50/255, 50/255, 50/255, 0.6)
	
	container_targets:SetAllPoints(container_targets_window)
	container_targets:SetWidth(300)
	container_targets:SetHeight(100)
	container_targets:EnableMouse(true)
	container_targets:SetResizable(false)
	container_targets:SetMovable(true)
	
	container_targets_window:SetWidth(300)
	container_targets_window:SetHeight(100)
	container_targets_window:SetScrollChild(container_targets)
	container_targets_window:SetPoint("BOTTOMLEFT", this_gump, "BOTTOMLEFT", 20, 6) --56 default

	gump:NewScrollBar(container_targets_window, container_targets, 7, 4)
	container_targets_window.slider:Altura(88)
	container_targets_window.slider:cimaPoint(0, 1)
	container_targets_window.slider:baixoPoint(0, -3)
	
	container_targets_window.gump = container_targets
	this_gump.container_targets = container_targets_window
end

--> search key: ~create
function gump:CreateWindowInfo()

	--> cria a window em si
	local this_gump = info
	this_gump:SetFrameStrata("MEDIUM")
	
	--> fehcar com o esc
	tinsert(UISpecialFrames, this_gump:GetName())

	--> propriedades da window
	this_gump:SetPoint("CENTER", UIParent)
	--this_gump:SetWidth(640)
	this_gump:SetWidth(590)
	this_gump:SetHeight(354)
	this_gump:EnableMouse(true)
	this_gump:SetResizable(false)
	this_gump:SetMovable(true)
	
	--> joga a window para a global
	_details.window_info = this_gump
	
	--> começa a preparer as textures <--
	
	--> icon da class no canto left superior
	this_gump.class_icon = this_gump:CreateTexture(nil, "BACKGROUND")
	this_gump.class_icon:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 4, 0)
	this_gump.class_icon:SetWidth(64)
	this_gump.class_icon:SetHeight(64)
	this_gump.class_icon:SetDrawLayer("BACKGROUND", 1)
	--> complemento do icon
	this_gump.class_iconPlus = this_gump:CreateTexture(nil, "BACKGROUND")
	this_gump.class_iconPlus:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 4, 0)
	this_gump.class_iconPlus:SetWidth(64)
	this_gump.class_iconPlus:SetHeight(64)
	this_gump.class_iconPlus:SetDrawLayer("BACKGROUND", 2)
	
	--> cria as 4 partes do fundo da window
	
	--> top left
	this_gump.bg1 = this_gump:CreateTexture(nil, "BORDER")
	this_gump.bg1:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 0, 0)
	--this_gump.bg1:SetWidth(512)
	--this_gump.bg1:SetHeight(256)
	this_gump.bg1:SetDrawLayer("BORDER", 1)
	
	function _details:SetPlayerDetailsWindowTexture(texture)
		this_gump.bg1:SetTexture(texture)
	end
	_details:SetPlayerDetailsWindowTexture("Interface\\AddOns\\Details\\images\\info_window_background")
	
	this_gump.bg1_sec_texture = this_gump:CreateTexture(nil, "BORDER")
	this_gump.bg1_sec_texture:SetDrawLayer("BORDER", 2)
	--this_gump.bg1_sec_texture:SetPoint("topleft", this_gump.bg1, "topleft", 356, -86)
	this_gump.bg1_sec_texture:SetPoint("topleft", this_gump.bg1, "topleft", 348, -86)
	this_gump.bg1_sec_texture:SetHeight(262)
	this_gump.bg1_sec_texture:SetWidth(264)

	--> bottom left
	this_gump.bg3 = this_gump:CreateTexture(nil, "BORDER")
	--this_gump.bg3:SetPoint("BOTTOMLEFT", this_gump, "BOTTOMLEFT", 0, 0)
	this_gump.bg3:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 0, -256)
	this_gump.bg3:SetWidth(512)
	this_gump.bg3:SetHeight(128)
	this_gump.bg3:SetTexture("Interface\\AddOns\\Details\\images\\info_bg_part3") 
	this_gump.bg3:Hide()
	
	--> top right
	this_gump.bg2 = this_gump:CreateTexture(nil, "BORDER")
	this_gump.bg2:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 512, 0)
	this_gump.bg2:SetWidth(128)
	this_gump.bg2:SetHeight(128)
	this_gump.bg2:SetTexture("Interface\\AddOns\\Details\\images\\info_bg_part2") 
	this_gump.bg2:Hide()
	
	--> bottom right
	this_gump.bg4 = this_gump:CreateTexture(nil, "BORDER")
	--this_gump.bg4:SetPoint("BOTTOMRIGHT", this_gump, "BOTTOMRIGHT", 0, 0)
	--this_gump.bg4:SetPoint("BOTTOMLEFT", this_gump, "BOTTOMLEFT", 512, 0)
	this_gump.bg4:SetPoint("TOPLEFT", this_gump, "TOPLEFT", 512, -128)
	this_gump.bg4:SetWidth(128)
	this_gump.bg4:SetHeight(256)
	this_gump.bg4:SetTexture("Interface\\AddOns\\Details\\images\\info_bg_part4") 
	this_gump.bg4:Hide()

	--> botão de close
	this_gump.close = _CreateFrame("Button", nil, this_gump, "UIPanelCloseButton")
	this_gump.close:SetWidth(32)
	this_gump.close:SetHeight(32)
	this_gump.close:SetPoint("TOPRIGHT", this_gump, "TOPRIGHT", 5, -8)
	this_gump.close:SetText("X")
	this_gump.close:SetFrameLevel(this_gump:GetFrameLevel()+2)

	this_gump.no_targets = this_gump:CreateTexture(nil, "overlay")
	this_gump.no_targets:SetPoint("BOTTOMLEFT", this_gump, "BOTTOMLEFT", 20, 6)
	this_gump.no_targets:SetSize(301, 100)
	this_gump.no_targets:SetTexture([[Interface\QUESTFRAME\UI-QUESTLOG-EMPTY-TOPLEFT]])
	this_gump.no_targets:SetTexCoord(0.015625, 1, 0.01171875, 0.390625)
	this_gump.no_targets:SetDesaturated(true)
	this_gump.no_targets:SetAlpha(.7)
	this_gump.no_targets.text = this_gump:CreateFontString(nil, "overlay", "GameFontNormal")
	this_gump.no_targets.text:SetPoint("center", this_gump.no_targets, "center")
	this_gump.no_targets.text:SetText(Loc["STRING_NO_TARGET_BOX"])
	this_gump.no_targets.text:SetTextColor(1, 1, 1, .4)
	this_gump.no_targets:Hide()
	
	function this_gump:ToFront()
		if (_details.bosswindow) then
			if (_details.bosswindow:GetFrameLevel() > this_gump:GetFrameLevel()) then 
				this_gump:SetFrameLevel(this_gump:GetFrameLevel()+3)
				_details.bosswindow:SetFrameLevel(_details.bosswindow:GetFrameLevel()-3)
			end
		end
	end
	
	this_gump.grab = gump:NewDetailsButton(this_gump, this_gump, _, this_gump.ToFront, nil, nil, 590, 73, "", "", "", "", {OnGrab = "PassClick"}, "DetailsWindowInfoGrab")
	this_gump.grab:SetPoint("topleft",this_gump, "topleft")
	this_gump.grab:SetFrameLevel(this_gump:GetFrameLevel()+1)
	
	--> titulo
	gump:NewLabel(this_gump, this_gump, nil, "titulo", Loc["STRING_PLAYER_DETAILS"], "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
	this_gump.titulo:SetPoint("center", this_gump, "center")
	this_gump.titulo:SetPoint("top", this_gump, "top", 0, -18)
	
	--> cria os texts da window
	cria_texts(this_gump)	
	
	--> cria o frama que vai abrigar as bars das abilities
	cria_container_bars(this_gump)
	
	--> cria o container que vai opengar as 5 bars de details
	cria_container_details(this_gump)
	
	--> cria o container onde vai abrigar os targets do player
	cria_container_targets(this_gump)

	--> cria as 5 bars de details a right da window
	cria_bars_details()
	
	--> seta os scripts dos frames da window
	seta_scripts(this_gump)

	--> vai armazenar os objetos das bars de ability
	this_gump.bars1 = {} 
	
	--> vai armazenar os objetos das bars de targets
	this_gump.bars2 = {} 
	
	--> vai armazenar os objetos das bars da caixa especial da right
	this_gump.bars3 = {} 


	--> botão de report da caixa da left, onde fica as bars principais
	this_gump.report_left = gump:NewDetailsButton(this_gump, this_gump, nil, _details.Report, this_gump, 1, 16, 16,
	"Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", nil, "DetailsWindowInfoReport2")
	--this_gump.report_left:SetPoint("BOTTOMLEFT", this_gump.container_bars, "TOPLEFT",  281, 3)
	this_gump.report_left:SetPoint("BOTTOMLEFT", this_gump.container_bars, "TOPLEFT",  33, 3)
	this_gump.report_left:SetFrameLevel(this_gump:GetFrameLevel()+2)

	--> botão de report da caixa dos targets
	this_gump.report_targets = gump:NewDetailsButton(this_gump, this_gump, nil, _details.Report, this_gump, 3, 16, 16,
	"Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", nil, "DetailsWindowInfoReport3")
	this_gump.report_targets:SetPoint("BOTTOMRIGHT", this_gump.container_targets, "TOPRIGHT",  -2, -1)
	this_gump.report_targets:SetFrameLevel(3) --> solved inactive problem

	--> ícone da spell selecionada para mais details
	this_gump.bg_icon_bg = this_gump:CreateTexture(nil, "ARTWORK")
	this_gump.bg_icon_bg:SetPoint("TOPRIGHT", this_gump, "TOPRIGHT",  -15, -12)
	this_gump.bg_icon_bg:SetTexture("Interface\\AddOns\\Details\\images\\icon_bg_fundo")
	this_gump.bg_icon_bg:SetDrawLayer("ARTWORK", -1)
	this_gump.bg_icon_bg:Show()
	
	this_gump.bg_icon = this_gump:CreateTexture(nil, "OVERLAY")
	this_gump.bg_icon:SetPoint("TOPRIGHT", this_gump, "TOPRIGHT",  -15, -12)
	this_gump.bg_icon:SetTexture("Interface\\AddOns\\Details\\images\\icon_bg")
	this_gump.bg_icon:Show()
	
	--this_gump:Hide()
	
	this_gump.spell_icon = this_gump:CreateTexture(nil, "ARTWORK")
	this_gump.spell_icon:SetPoint("BOTTOMRIGHT", this_gump.bg_icon, "BOTTOMRIGHT",  -19, 2)
	this_gump.spell_icon:SetWidth(35)
	this_gump.spell_icon:SetHeight(34)
	this_gump.spell_icon:SetDrawLayer("ARTWORK", 0)
	this_gump.spell_icon:Show()
	
	--> coisinhas do side do icon
	this_gump.apoio_icon_left = this_gump:CreateTexture(nil, "ARTWORK")
	this_gump.apoio_icon_direito = this_gump:CreateTexture(nil, "ARTWORK")
	this_gump.apoio_icon_left:SetTexture("Interface\\AddOns\\Details\\images\\PaperDollSidebarTabs")
	this_gump.apoio_icon_direito:SetTexture("Interface\\AddOns\\Details\\images\\PaperDollSidebarTabs")
	
	local apoio_altura = 13/256
	this_gump.apoio_icon_left:SetTexCoord(0, 1, 0, apoio_altura)
	this_gump.apoio_icon_direito:SetTexCoord(0, 1, apoio_altura+(1/256), apoio_altura+apoio_altura)
	
	this_gump.apoio_icon_left:SetPoint("bottomright", this_gump.bg_icon, "bottomleft",  42, 0)
	this_gump.apoio_icon_direito:SetPoint("bottomleft", this_gump.bg_icon, "bottomright",  -17, 0)
	
	this_gump.apoio_icon_left:SetWidth(64)
	this_gump.apoio_icon_left:SetHeight(13)
	this_gump.apoio_icon_direito:SetWidth(64)
	this_gump.apoio_icon_direito:SetHeight(13)

	--> botão de report da caixa da right, onde estão os 5 quadrados
	this_gump.report_right = gump:NewDetailsButton(this_gump, this_gump, nil, _details.Report, this_gump, 2, 16, 16,
	"Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", nil, "DetailsWindowInfoReport4")
	this_gump.report_right:SetPoint("TOPRIGHT", this_gump, "TOPRIGHT",  -8, -57)	
	this_gump.report_right:Hide()

	local red = "FFFFAAAA"
	local green = "FFAAFFAA"
	
	--> tabs:
	--> tab default
	_details:CreatePlayerDetailsTab("Summary", --[1] tab name
			function(tabOBject, playerObject) --[2] condition
				if (playerObject) then 
					return true 
				else 
					return false 
				end
			end, 
			nil, --[3] fill function
			function() --[4] onclick
				for _, tab in _ipairs(_details.player_details_tabs) do
					tab.frame:Hide()
				end
			end,
			nil --[5] oncreate
			)
		
		--> search key: ~avoidance
		
		local avoidance_create = function(tab, frame)
		
		--> MAIN ICON
			local mainicon = frame:CreateTexture(nil, "artwork")
			mainicon:SetPoint("topright", frame, "topright", -12, -12)
			mainicon:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-ACHIEVEMENT-SHIELDS]])
			mainicon:SetTexCoord(0, .5, .5, 1)
			mainicon:SetSize(64, 64)
			
			local tankname = frame:CreateFontString(nil, "artwork", "GameFontNormal")
			tankname:SetPoint("right", mainicon, "left", -2, 2)
			tab.tankname = tankname
		
		--> Percent Desc
			local percent_desc = frame:CreateFontString(nil, "artwork", "GameFontNormal")
			percent_desc:SetText("Percent values are comparisons with the previous try.")
			percent_desc:SetPoint("bottomleft", frame, "bottomleft", 13, 13)
			percent_desc:SetTextColor(.5, .5, .5, 1)
		
		--> SUMMARY
			local summary_texture = frame:CreateTexture(nil, "artwork")
			summary_texture:SetPoint("topleft", frame, "topleft", 10, -15)
			summary_texture:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
			summary_texture:SetSize(128, 16)
			local summary_text = frame:CreateFontString(nil, "artwork", "GameFontNormal")
			summary_text:SetText("Summary")
			summary_text :SetPoint("left", summary_texture, "left", 2, 0)
		
			--total damage received
			local damagereceived = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			damagereceived:SetPoint("topleft", frame, "topleft", 15, -35)
			damagereceived:SetText("Total Damage Taken:") --> localize-me
			damagereceived:SetTextColor(.8, .8, .8, 1)
			local damagereceived_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			damagereceived_amt:SetPoint("left", damagereceived,  "right", 2, 0)
			damagereceived_amt:SetText("0")
			tab.damagereceived = damagereceived_amt
		
			--per second
			local damagepersecond = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			damagepersecond:SetPoint("topleft", frame, "topleft", 20, -50)
			damagepersecond:SetText("Per Second:") --> localize-me
			local damagepersecond_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			damagepersecond_amt:SetPoint("left", damagepersecond,  "right", 2, 0)
			damagepersecond_amt:SetText("0")
			tab.damagepersecond = damagepersecond_amt
			
			--total absorbs
			local absorbstotal = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			absorbstotal:SetPoint("topleft", frame, "topleft", 15, -65)
			absorbstotal:SetText("Total Absorbs:") --> localize-me
			absorbstotal:SetTextColor(.8, .8, .8, 1)
			local absorbstotal_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			absorbstotal_amt:SetPoint("left", absorbstotal,  "right", 2, 0)
			absorbstotal_amt:SetText("0")
			tab.absorbstotal = absorbstotal_amt
			
			--per second
			local absorbstotalpersecond = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			absorbstotalpersecond:SetPoint("topleft", frame, "topleft", 20, -80)
			absorbstotalpersecond:SetText("Per Second:") --> localize-me
			local absorbstotalpersecond_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			absorbstotalpersecond_amt:SetPoint("left", absorbstotalpersecond,  "right", 2, 0)
			absorbstotalpersecond_amt:SetText("0")
			tab.absorbstotalpersecond = absorbstotalpersecond_amt
		
		--> MELEE
		
			local melee_texture = frame:CreateTexture(nil, "artwork")
			melee_texture:SetPoint("topleft", frame, "topleft", 10, -100)
			melee_texture:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
			melee_texture:SetSize(128, 16)
			local melee_text = frame:CreateFontString(nil, "artwork", "GameFontNormal")
			melee_text:SetText("Melee")
			melee_text :SetPoint("left", melee_texture, "left", 2, 0)
			
			--dodge
			local dodge = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			dodge:SetPoint("topleft", frame, "topleft", 15, -120)
			dodge:SetText("Dodge:") --> localize-me
			dodge:SetTextColor(.8, .8, .8, 1)
			local dodge_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			dodge_amt:SetPoint("left", dodge,  "right", 2, 0)
			dodge_amt:SetText("0")
			tab.dodge = dodge_amt

			local dodgepersecond = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			dodgepersecond:SetPoint("topleft", frame, "topleft", 20, -135)
			dodgepersecond:SetText("Per Second:") --> localize-me
			local dodgepersecond_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			dodgepersecond_amt:SetPoint("left", dodgepersecond,  "right", 2, 0)
			dodgepersecond_amt:SetText("0")
			tab.dodgepersecond = dodgepersecond_amt
			
			-- parry
			local parry = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			parry:SetPoint("topleft", frame, "topleft", 15, -150)
			parry:SetText("Parry:") --> localize-me
			parry:SetTextColor(.8, .8, .8, 1)
			local parry_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			parry_amt:SetPoint("left", parry,  "right", 2, 0)
			parry_amt:SetText("0")
			tab.parry = parry_amt
			
			local parrypersecond = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			parrypersecond:SetPoint("topleft", frame, "topleft", 20, -165)
			parrypersecond:SetText("Per Second:") --> localize-me
			local parrypersecond_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			parrypersecond_amt:SetPoint("left", parrypersecond,  "right", 2, 0)
			parrypersecond_amt:SetText("0")
			tab.parrypersecond = parrypersecond_amt

		--> ABSORBS
		
			local absorb_texture = frame:CreateTexture(nil, "artwork")
			absorb_texture:SetPoint("topleft", frame, "topleft", 200, -15)
			absorb_texture:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
			absorb_texture:SetSize(128, 16)
			local absorb_text = frame:CreateFontString(nil, "artwork", "GameFontNormal")
			absorb_text:SetText("Absorb")
			absorb_text :SetPoint("left", absorb_texture, "left", 2, 0)
		
			--full absorbs
			local fullsbsorbed = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			fullsbsorbed:SetPoint("topleft", frame, "topleft", 205, -35)
			fullsbsorbed:SetText("Full Absorbs:") --> localize-me
			fullsbsorbed:SetTextColor(.8, .8, .8, 1)
			local fullsbsorbed_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			fullsbsorbed_amt:SetPoint("left", fullsbsorbed,  "right", 2, 0)
			fullsbsorbed_amt:SetText("0")
			tab.fullsbsorbed = fullsbsorbed_amt
			
			--partially absorbs
			local partiallyabsorbed = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			partiallyabsorbed:SetPoint("topleft", frame, "topleft", 205, -50)
			partiallyabsorbed:SetText("Partially Absorbed:") --> localize-me
			partiallyabsorbed:SetTextColor(.8, .8, .8, 1)
			local partiallyabsorbed_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			partiallyabsorbed_amt:SetPoint("left", partiallyabsorbed,  "right", 2, 0)
			partiallyabsorbed_amt:SetText("0")
			tab.partiallyabsorbed = partiallyabsorbed_amt
		
			--partially absorbs per second
			local partiallyabsorbedpersecond = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			partiallyabsorbedpersecond:SetPoint("topleft", frame, "topleft", 210, -65)
			partiallyabsorbedpersecond:SetText("Average:") --> localize-me
			local partiallyabsorbedpersecond_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			partiallyabsorbedpersecond_amt:SetPoint("left", partiallyabsorbedpersecond,  "right", 2, 0)
			partiallyabsorbedpersecond_amt:SetText("0")
			tab.partiallyabsorbedpersecond = partiallyabsorbedpersecond_amt
			
			--no absorbs
			local noabsorbs = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			noabsorbs:SetPoint("topleft", frame, "topleft", 205, -80)
			noabsorbs:SetText("No Absorption:") --> localize-me
			noabsorbs:SetTextColor(.8, .8, .8, 1)
			local noabsorbs_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			noabsorbs_amt:SetPoint("left", noabsorbs,  "right", 2, 0)
			noabsorbs_amt:SetText("0")
			tab.noabsorbs = noabsorbs_amt
		
		--> HEALING
		
			local healing_texture = frame:CreateTexture(nil, "artwork")
			healing_texture:SetPoint("topleft", frame, "topleft", 200, -100)
			healing_texture:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
			healing_texture:SetSize(128, 16)
			local healing_text = frame:CreateFontString(nil, "artwork", "GameFontNormal")
			healing_text:SetText("Healing")
			healing_text :SetPoint("left", healing_texture, "left", 2, 0)
			
			--self healing
			local selfhealing = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			selfhealing:SetPoint("topleft", frame, "topleft", 205, -120)
			selfhealing:SetText("Self Healing:") --> localize-me
			selfhealing:SetTextColor(.8, .8, .8, 1)
			local selfhealing_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			selfhealing_amt:SetPoint("left", selfhealing,  "right", 2, 0)
			selfhealing_amt:SetText("0")
			tab.selfhealing = selfhealing_amt

			--self healing per second
			local selfhealingpersecond = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			selfhealingpersecond:SetPoint("topleft", frame, "topleft", 210, -135)
			selfhealingpersecond:SetText("Per Second:") --> localize-me
			local selfhealingpersecond_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
			selfhealingpersecond_amt:SetPoint("left", selfhealingpersecond,  "right", 2, 0)
			selfhealingpersecond_amt:SetText("0")
			tab.selfhealingpersecond = selfhealingpersecond_amt
		
			for i = 1, 5 do 
				local healer = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
				healer:SetPoint("topleft", frame, "topleft", 205, -160 +((i-1)*15)*-1)
				healer:SetText("healer name:") --> localize-me
				healer:SetTextColor(.8, .8, .8, 1)
				local healer_amt = frame:CreateFontString(nil, "artwork", "GameFontNormalSmall")
				healer_amt:SetPoint("left", healer,  "right", 2, 0)
				healer_amt:SetText("0")
				tab["healer" .. i] = {healer, healer_amt}
			end
			
		--SPELLS
			local spells_texture = frame:CreateTexture(nil, "artwork")
			spells_texture:SetPoint("topleft", frame, "topleft", 400, -80)
			spells_texture:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
			spells_texture:SetSize(128, 16)
			local spells_text = frame:CreateFontString(nil, "artwork", "GameFontNormal")
			spells_text:SetText("Spells")
			spells_text :SetPoint("left", spells_texture, "left", 2, 0)
			
			local frame_tooltip_onenter = function(self)
				if (self.spellid) then
					self:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 512, edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 8})
					self:SetBackdropColor(.5, .5, .5, .5)
					GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
					GameTooltip:SetSpellByID(self.spellid)
					GameTooltip:Show()
				end
			end
			local frame_tooltip_onleave = function(self)
				if (self.spellid) then
					self:SetBackdrop(nil)
					GameTooltip:Hide()
				end
			end
			
			for i = 1, 10 do 
				local frame_tooltip = CreateFrame("frame", nil, frame)
				frame_tooltip:SetPoint("topleft", frame, "topleft", 405, -100 +((i-1)*15)*-1)
				frame_tooltip:SetSize(150, 14)
				frame_tooltip:SetScript("OnEnter", frame_tooltip_onenter)
				frame_tooltip:SetScript("OnLeave", frame_tooltip_onleave)
				
				local icon = frame_tooltip:CreateTexture(nil, "artwork")
				icon:SetSize(14, 14)
				icon:SetPoint("left", frame_tooltip, "left")
				
				local spell = frame_tooltip:CreateFontString(nil, "artwork", "GameFontNormalSmall")
				spell:SetPoint("left", icon, "right", 2, 0)
				spell:SetText("spell name:") --> localize-me
				spell:SetTextColor(.8, .8, .8, 1)
				
				local spell_amt = frame_tooltip:CreateFontString(nil, "artwork", "GameFontNormalSmall")
				spell_amt:SetPoint("left", spell,  "right", 2, 0)
				spell_amt:SetText("0")
				
				tab["spell" .. i] = {spell, spell_amt, icon, frame_tooltip}
			end
		
		end
		
		local getpercent = function(value, lastvalue, elapsed_time, inverse)
			local ps = value / elapsed_time
			local diff
			
			if (lastvalue == 0) then
				diff = "+0%"
			else
				if (ps >= lastvalue) then
					local d = ps - lastvalue
					d = d / lastvalue * 100
					d = _math_floor(math.abs(d))

					if (d > 999) then
						d = "> 999"
					end
					
					if (inverse) then
						diff = "|c" .. green .. "+" .. d .. "%|r"
					else
						diff = "|c" .. red .. "+" .. d .. "%|r"
					end
				else
					local d = lastvalue - ps
					d = d / ps * 100
					d = _math_floor(math.abs(d))
					
					if (d > 999) then
						d = "> 999"
					end
					
					if (inverse) then
						diff = "|c" .. red .. "-" .. d .. "%|r"
					else
						diff = "|c" .. green .. "-" .. d .. "%|r"
					end
				end
			end
			
			return ps, diff
		end
		
		-- ~buff
		local spells_by_class = { --buffss uptime
			["DRUID"] = {
				[132402] = true, --savage defense
				[135286] = true, -- tooth and claw
			},
			["DEATHKNIGHT"] = {
				[145677] = true, --riposte
				[77535] = true, --blood shield
				--[49222] = true, --bone shield
				[51460] = true, --runic corruption
			},
			["PALADIN"] = {
				[132403] = true, --shield of the righteous
				[114163] = true, --eternal-flame
				[20925] = true, --sacred shield
			},
			["WARRIOR"] = {
				[145672] = true, --riposte
				[2565] = true, -- shield Block
				[871] = true, --shield wall
				[112048] = true, --shield barrier
			},
		}
		
		local avoidance_fill = function(tab, player, combat)

			local elapsed_time = combat:GetCombatTime()
			
			local last_combat = combat.previous_combat
			if (not last_combat or not last_combat[1]) then
				last_combat = combat
			end
			local last_actor = last_combat(1, player.name)
			local n = player.name
			if (n:find("-")) then
				n = n:gsub(("-.*"), "")
			end
			tab.tankname:SetText("Avoidance of\n" .. n) --> localize-me
			
			--> damage taken
				local playerdamage = combat(1, player.name)
				
				local damagetaken = playerdamage.damage_taken
				local last_damage_received = 0
				if (last_actor) then
					last_damage_received = last_actor.damage_taken / last_combat:GetCombatTime()
				end
				
				tab.damagereceived:SetText(_details:ToK2(damagetaken))
				
				local ps, diff = getpercent(damagetaken, last_damage_received, elapsed_time)
				tab.damagepersecond:SetText(_details:comma_value(_math_floor(ps)) .. "(" .. diff .. ")")

			--> absorbs
				local totalabsorbs = playerdamage.avoidance.overall.ABSORB_AMT
				local incomingtotal = damagetaken + totalabsorbs
				
				local last_total_absorbs = 0
				if (last_actor and last_actor.avoidance) then
					last_total_absorbs = last_actor.avoidance.overall.ABSORB_AMT / last_combat:GetCombatTime()
				end
				
				tab.absorbstotal:SetText(_details:ToK2(totalabsorbs) .. "(" .. _math_floor(totalabsorbs / incomingtotal * 100) .. "%)")
				
				local ps, diff = getpercent(totalabsorbs, last_total_absorbs, elapsed_time, true)
				tab.absorbstotalpersecond:SetText(_details:comma_value(_math_floor(ps)) .. "(" .. diff .. ")")
				
			--> dodge
				local totaldodge = playerdamage.avoidance.overall.DODGE
				tab.dodge:SetText(totaldodge)
				
				local last_total_dodge = 0
				if (last_actor and last_actor.avoidance) then
					last_total_dodge = last_actor.avoidance.overall.DODGE / last_combat:GetCombatTime()
				end
				local ps, diff = getpercent(totaldodge, last_total_dodge, elapsed_time, true)
				tab.dodgepersecond:SetText( string.format("%.2f", ps) .. "(" .. diff .. ")")
			
			--> parry
				local totalparry = playerdamage.avoidance.overall.PARRY
				tab.parry:SetText(totalparry)
				
				local last_total_parry = 0
				if (last_actor and last_actor.avoidance) then
					last_total_parry = last_actor.avoidance.overall.PARRY / last_combat:GetCombatTime()
				end
				local ps, diff = getpercent(totalparry, last_total_parry, elapsed_time, true)
				tab.parrypersecond:SetText(string.format("%.2f", ps) .. "(" .. diff .. ")")
				
			--> absorb
				local fullabsorb = playerdamage.avoidance.overall.FULL_ABSORBED
				local halfabsorb = playerdamage.avoidance.overall.PARTIAL_ABSORBED
				local halfabsorb_amt = playerdamage.avoidance.overall.PARTIAL_ABSORB_AMT
				local noabsorb = playerdamage.avoidance.overall.FULL_HIT
				
				tab.fullsbsorbed:SetText(fullabsorb)
				tab.partiallyabsorbed:SetText(halfabsorb)
				tab.noabsorbs:SetText(noabsorb)
				
				if (halfabsorb_amt > 0) then
					local average = halfabsorb_amt / halfabsorb --tenho o average
					local last_average = 0
					if (last_actor and last_actor.avoidance) then
						last_average = last_actor.avoidance.overall.PARTIAL_ABSORB_AMT / last_actor.avoidance.overall.PARTIAL_ABSORBED
					end
					
					local ps, diff = getpercent(halfabsorb_amt, last_average, halfabsorb, true)
					tab.partiallyabsorbedpersecond:SetText(_details:comma_value(_math_floor(ps)) .. "(" .. diff .. ")")
				else
					tab.partiallyabsorbedpersecond:SetText("0.00(0%)")
				end
				

				
			--> healing
			
				local actor_heal = combat(2, player.name)
				if (not actor_heal) then
					tab.selfhealing:SetText("0")
					tab.selfhealingpersecond:SetText("0(0%)")
				else
					local last_actor_heal = last_combat(2, player.name)
					local this_dst = actor_heal.targets._NameIndexTable[player.name]
					if (this_dst) then
						this_dst = actor_heal.targets._ActorTable[this_dst]
						local heal_total = this_dst.total
						tab.selfhealing:SetText(_details:ToK2(heal_total))
						
						if (last_actor_heal) then
							local this_dst = last_actor_heal.targets._NameIndexTable[player.name]
							if (this_dst) then
							
								this_dst = actor_heal.targets._ActorTable[this_dst]
								
								local last_heal = this_dst.total / last_combat:GetCombatTime()
								
								local ps, diff = getpercent(heal_total, last_heal, elapsed_time, true)
								tab.selfhealingpersecond:SetText(_details:comma_value(_math_floor(ps)) .. "(" .. diff .. ")")
								
							else
								tab.selfhealingpersecond:SetText("0(0%)")
							end
						else
							tab.selfhealingpersecond:SetText("0(0%)")
						end
						
					else
						tab.selfhealing:SetText("0")
						tab.selfhealingpersecond:SetText("0(0%)")
					end
					
					
					-- taken from healer
					local heal_from = actor_heal.healing_from
					local myReceivedHeal = {}
					
					for actorName, _ in pairs(heal_from) do 
						local thisActor = combat(2, actorName)
						local targets = thisActor.targets --> targets is a container with target classes
						local amount = targets:GetAmount(player.name, "total")
						myReceivedHeal[#myReceivedHeal+1] = {actorName, amount, thisActor.class}
					end
					
					table.sort(myReceivedHeal, _details.Sort2) --> Sort2 sort by second index
					
					for i = 1, 5 do 
						local label1, label2 = unpack(tab["healer" .. i])
						if (myReceivedHeal[i]) then
							local name = myReceivedHeal[i][1]
							if (name:find("-")) then
								name = name:gsub(("-.*"), "")
							end
							label1:SetText(name .. ":")
							local class = myReceivedHeal[i][3]
							if (class) then
								local c = RAID_CLASS_COLORS[class]
								if (c) then
									label1:SetTextColor(c.r, c.g, c.b)
								end
							else
								label1:SetTextColor(.8, .8, .8, 1)
							end
							
							local last_actor = last_combat(2, myReceivedHeal[i][1])
							if (last_actor) then
								local targets = last_actor.targets
								local amount = targets:GetAmount(player.name, "total")
								if (amount) then
									
									local last_heal = amount
									
									local ps, diff = getpercent(myReceivedHeal[i][2], last_heal, 1, true)
									label2:SetText( _details:ToK2(myReceivedHeal[i][2] or 0) .. "(" .. diff .. ")")
									
								else
									label2:SetText( _details:ToK2(myReceivedHeal[i][2] or 0))
								end
							else
								label2:SetText( _details:ToK2(myReceivedHeal[i][2] or 0))
							end
							
							
						else
							label1:SetText("-- -- -- --")
							label1:SetTextColor(.8, .8, .8, 1)
							label2:SetText("")
						end
					end
				end
				
			--> Spells
				--> cooldowns
				
				local index_used = 1
				
				local misc_player = combat(4, player.name)
				
				if (misc_player) then
					if (misc_player.cooldowns_defensive_spell_tables) then
						local my_table = misc_player.cooldowns_defensive_spell_tables._ActorTable
						local cooldowns_used = {}
						
						for _spellid, _table in pairs(my_table) do
							cooldowns_used[#cooldowns_used+1] = {_spellid, _table.counter}
						end
						table.sort(cooldowns_used, function(t1, t2) return t1[2] > t2[2] end)
						
						if (#cooldowns_used > 1) then
							for i = 1, #cooldowns_used do
								local this_ability = cooldowns_used[i]
								local name_spell, _, icon_spell = _GetSpellInfo(this_ability[1])
								
								local label1, label2, icon1, framebg = unpack(tab["spell" .. i])
								framebg.spellid = this_ability[1]
								
								label1:SetText(name_spell .. ":")
								label2:SetText(this_ability[2])
								icon1:SetTexture(icon_spell)
								icon1:SetTexCoord(0.0625, 0.953125, 0.0625, 0.953125)
								
								index_used = index_used + 1
							end
						end
					end
				end

				--> buffs uptime
				if (index_used < 11) then
					if (misc_player.buff_uptime_spell_tables) then
						local my_table = misc_player.buff_uptime_spell_tables._ActorTable
						
						local encounter_time = combat:GetCombatTime()
						
						for _spellid, _table in pairs(my_table) do
							if (spells_by_class[player.class][_spellid] and index_used <= 10) then 
								local name_spell, _, icon_spell = GetSpellInfo(_spellid)
								local label1, label2, icon1, framebg = unpack(tab["spell" .. index_used])
								
								framebg.spellid = _spellid
								
								local t = _table.uptime / encounter_time * 100
								label1:SetText(name_spell .. ":")
								local minutes, seconds = _math_floor(_table.uptime / 60), _math_floor(_table.uptime % 60)
								label2:SetText(minutes .. "m " .. seconds .. "s" .. "(" .. _math_floor(t) .. "%)")
								icon1:SetTexture(icon_spell)
								icon1:SetTexCoord(0.0625, 0.953125, 0.0625, 0.953125)
								
								index_used = index_used + 1
							end
						end
					end
				end
				
				for i = index_used, 10 do
					local label1, label2, icon1, framebg = unpack(tab["spell" .. i])
					
					framebg.spellid = nil
					label1:SetText("-- -- -- --")
					label2:SetText("")
					icon1:SetTexture(nil)
				end
				
			--> ability usada para interromper

				
				
			
--[[
			
--]]
		end
		
		_details:CreatePlayerDetailsTab("Avoidance", --[1] tab name
			function(tabOBject, playerObject)  --[2] condition
				if (playerObject.isTank) then 
					return true 
				else 
					return false 
				end
			end, 
			
			avoidance_fill, --[3] fill function
			
			nil, --[4] onclick
			
			avoidance_create --[5] oncreate
			)
	
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		local target_texture =[[Interface\AddOns\Details\images\Target]]
		local empty_text = ""
		
		local plus = red .. "-(" 
		local minor = green .. "+("

		local fill_compare_targets = function(self, player, other_players, target_pool)
			
			local offset = FauxScrollFrame_GetOffset(self)
			
			local frame2 = DetailsPlayerComparisonTarget2
			local frame3 = DetailsPlayerComparisonTarget3
			
			local total = player.total_without_pet
			
			if (not target_pool[1]) then
				for i = 1, 4 do 
					local bar = self.bars[i]
					local bar_2 = frame2.bars[i]
					local bar_3 = frame3.bars[i]
					
					bar[1]:SetTexture(nil)
					bar[2].lefttext:SetText(empty_text)
					bar[2].lefttext:SetTextColor(.5, .5, .5, 1)
					bar[2].righttext:SetText("")
					bar[2]:SetValue(0)
					bar[3][4] = nil
					bar_2[1]:SetTexture(nil)
					bar_2[2].lefttext:SetText(empty_text)
					bar_2[2].lefttext:SetTextColor(.5, .5, .5, 1)
					bar_2[2].righttext:SetText("")
					bar_2[2]:SetValue(0)
					bar_2[3][4] = nil
					bar_3[1]:SetTexture(nil)
					bar_3[2].lefttext:SetText(empty_text)
					bar_3[2].lefttext:SetTextColor(.5, .5, .5, 1)
					bar_3[2].righttext:SetText("")
					bar_3[2]:SetValue(0)
					bar_3[3][4] = nil
				end
				
				return
			end
			
			local top = target_pool[1][2]
			
			--player 2
			local player_2 = other_players[1]
			local player_2_target_pool
			local player_2_top
			if (player_2) then
				local player_2_target = player_2.targets._ActorTable
				player_2_target_pool = {}
				for index, target in _ipairs(player_2_target) do 
					player_2_target_pool[#player_2_target_pool+1] = {target.name, target.total}
				end
				table.sort(player_2_target_pool, function(t1, t2) return t1[2] > t2[2] end)
				if (player_2_target_pool[1]) then
					player_2_top = player_2_target_pool[1][2]
				else
					player_2_top = 0
				end
				--1 skill, 
			end

			--player 3
			local player_3 = other_players[2]
			local player_3_target_pool
			local player_3_top
			if (player_3) then
				local player_3_target = player_3.targets._ActorTable
				player_3_target_pool = {}
				for index, target in _ipairs(player_3_target) do 
					player_3_target_pool[#player_3_target_pool+1] = {target.name, target.total}
				end
				table.sort(player_3_target_pool, function(t1, t2) return t1[2] > t2[2] end)
				if (player_3_target_pool[1]) then
					player_3_top = player_3_target_pool[1][2]
				else
					player_3_top = 0
				end
			end

			for i = 1, 4 do 
				local bar = self.bars[i]
				local bar_2 = frame2.bars[i]
				local bar_3 = frame3.bars[i]
				
				local index = i + offset
				local data = target_pool[index]
				
				if (data) then --[name][total]
				
					local target_name = data[1]
					
					bar[1]:SetTexture(target_texture)
					bar[1]:SetDesaturated(true)
					bar[1]:SetAlpha(.7)
					
					bar[2].lefttext:SetText(index .. ". " .. target_name)
					bar[2].lefttext:SetTextColor(1, 1, 1, 1)
					bar[2].righttext:SetText(_details:ToK2Min(data[2])) -- .. "(" .. _math_floor(data[2] / total * 100) .. "%)"
					bar[2]:SetValue(data[2] / top * 100)
					bar[3][1] = player.name --name
					bar[3][2] = target_name
					bar[3][3] = data[2] --total
					bar[3][4] = player
					
					-- 2
					if (player_2) then

						local player_2_target_total
						local player_2_target_index
						
						for index, t in _ipairs(player_2_target_pool) do
							if (t[1] == target_name) then
								player_2_target_total = t[2]
								player_2_target_index = index
								break
							end
						end
						
						if (player_2_target_total) then
							bar_2[1]:SetTexture(target_texture)
							bar_2[1]:SetDesaturated(true)
							bar_2[1]:SetAlpha(.7)
							
							bar_2[2].lefttext:SetText(player_2_target_index .. ". " .. target_name)
							bar_2[2].lefttext:SetTextColor(1, 1, 1, 1)
							
							if (data[2] > player_2_target_total) then
								local diff = data[2] - player_2_target_total
								local up = diff / player_2_target_total * 100
								up = _math_floor(up)
								if (up > 999) then
									up = ">" .. 999
								end
								bar_2[2].righttext:SetText(_details:ToK2Min(player_2_target_total) .. " |c" .. minor .. up .. "%)|r")
							else
								local diff = player_2_target_total - data[2]
								local down = diff / data[2] * 100
								down = _math_floor(down)
								if (down > 999) then
									down = ">" .. 999
								end
								bar_2[2].righttext:SetText(_details:ToK2Min(player_2_target_total) .. " |c" .. plus .. down .. "%)|r")
							end
							
							bar_2[2]:SetValue(player_2_target_total / player_2_top * 100)
							bar_2[3][1] = player_2.name
							bar_2[3][2] = target_name
							bar_2[3][3] = player_2_target_total
							bar_2[3][4] = player_2
							
						else
							bar_2[1]:SetTexture(nil)
							bar_2[2].lefttext:SetText(empty_text)
							bar_2[2].lefttext:SetTextColor(.5, .5, .5, 1)
							bar_2[2].righttext:SetText("")
							bar_2[2]:SetValue(0)
							bar_2[3][4] = nil
						end
					else
						bar_2[1]:SetTexture(nil)
						bar_2[2].lefttext:SetText(empty_text)
						bar_2[2].lefttext:SetTextColor(.5, .5, .5, 1)
						bar_2[2].righttext:SetText("")
						bar_2[2]:SetValue(0)
						bar_2[3][4] = nil
					end
					
					-- 3
					if (player_3) then

						local player_3_target_total
						local player_3_target_index
						
						for index, t in _ipairs(player_3_target_pool) do
							if (t[1] == target_name) then
								player_3_target_total = t[2]
								player_3_target_index = index
								break
							end
						end
						
						if (player_3_target_total) then
							bar_3[1]:SetTexture(target_texture)
							bar_3[1]:SetDesaturated(true)
							bar_3[1]:SetAlpha(.7)
							
							bar_3[2].lefttext:SetText(player_3_target_index .. ". " .. target_name)
							bar_3[2].lefttext:SetTextColor(1, 1, 1, 1)
							
							if (data[2] > player_3_target_total) then
								local diff = data[2] - player_3_target_total
								local up = diff / player_3_target_total * 100
								up = _math_floor(up)
								if (up > 999) then
									up = ">" .. 999
								end
								bar_3[2].righttext:SetText(_details:ToK2Min(player_3_target_total) .. " |c" .. minor .. up .. "%)|r")
							else
								local diff = player_3_target_total - data[2]
								local down = diff / data[2] * 100
								down = _math_floor(down)
								if (down > 999) then
									down = ">" .. 999
								end
								bar_3[2].righttext:SetText(_details:ToK2Min(player_3_target_total) .. " |c" .. plus .. down .. "%)|r")
							end
							
							bar_3[2]:SetValue(player_3_target_total / player_3_top * 100)
							bar_3[3][1] = player_3.name
							bar_3[3][2] = target_name
							bar_3[3][3] = player_3_target_total
							bar_3[3][4] = player_3
							
						else
							bar_3[1]:SetTexture(nil)
							bar_3[2].lefttext:SetText(empty_text)
							bar_3[2].lefttext:SetTextColor(.5, .5, .5, 1)
							bar_3[2].righttext:SetText("")
							bar_3[2]:SetValue(0)
							bar_3[3][4] = nil
						end
					else
						bar_3[1]:SetTexture(nil)
						bar_3[2].lefttext:SetText(empty_text)
						bar_3[2].lefttext:SetTextColor(.5, .5, .5, 1)
						bar_3[2].righttext:SetText("")
						bar_3[2]:SetValue(0)
						bar_3[3][4] = nil
					end
					
				else
					bar[1]:SetTexture(nil)
					bar[2].lefttext:SetText(empty_text)
					bar[2].lefttext:SetTextColor(.5, .5, .5, 1)
					bar[2].righttext:SetText("")
					bar[2]:SetValue(0)
					bar[3][4] = nil
					bar_2[1]:SetTexture(nil)
					bar_2[2].lefttext:SetText(empty_text)
					bar_2[2].lefttext:SetTextColor(.5, .5, .5, 1)
					bar_2[2].righttext:SetText("")
					bar_2[2]:SetValue(0)
					bar_2[3][4] = nil
					bar_3[1]:SetTexture(nil)
					bar_3[2].lefttext:SetText(empty_text)
					bar_3[2].lefttext:SetTextColor(.5, .5, .5, 1)
					bar_3[2].righttext:SetText("")
					bar_3[2]:SetValue(0)
					bar_3[3][4] = nil
				end
			end
			
		end

		local fill_compare_actors = function(self, player, other_players)
			
			--primeiro preenche a nossa bar
			local spells_sorted = {}
			for spellid, spelltable in _pairs(player.spell_tables._ActorTable) do
				spells_sorted[#spells_sorted+1] = {spelltable, spelltable.total}
			end
			table.sort(spells_sorted, function(t1, t2) return t1[2] > t2[2] end)
		
			self.player = player:Name()
		
			local offset = FauxScrollFrame_GetOffset(self)
		
			local total = player.total_without_pet
			local top = spells_sorted[1][2]
			
			local frame2 = DetailsPlayerComparisonBox2
			frame2.player = other_players[1]:Name()
			local player_2_total = other_players[1].total_without_pet
			local player_2_spells_sorted = {}
			for spellid, spelltable in _pairs(other_players[1].spell_tables._ActorTable) do
				player_2_spells_sorted[#player_2_spells_sorted+1] = {spelltable, spelltable.total}
			end
			table.sort(player_2_spells_sorted, function(t1, t2) return t1[2] > t2[2] end)
			local player_2_top = player_2_spells_sorted[1][2]
			local player_2_spell_info = {}
			for index, spelltable in _ipairs(player_2_spells_sorted) do 
				player_2_spell_info[spelltable[1].id] = index
			end
			
			local frame3 = DetailsPlayerComparisonBox3
			frame3.player = other_players[2] and other_players[2]:Name()
			local player_3_total = other_players[2] and other_players[2].total_without_pet
			local player_3_spells_sorted = {}
			local player_3_spell_info = {}
			local player_3_top
			
			if (other_players[2]) then
				for spellid, spelltable in _pairs(other_players[2].spell_tables._ActorTable) do
					player_3_spells_sorted[#player_3_spells_sorted+1] = {spelltable, spelltable.total}
				end
				table.sort(player_3_spells_sorted, function(t1, t2) return t1[2] > t2[2] end)
				player_3_top = player_3_spells_sorted[1][2]
				for index, spelltable in _ipairs(player_3_spells_sorted) do 
					player_3_spell_info[spelltable[1].id] = index
				end
			end

			for i = 1, 9 do 
				local bar = self.bars[i]
				local index = i + offset
				
				local data = spells_sorted[index]
				
				if (data) then
					--seta no box main
					local spellid = data[1].id
					local name, _, icon = _GetSpellInfo(spellid)
					bar[1]:SetTexture(icon)
					bar[2].lefttext:SetText(index .. ". " .. name)
					bar[2].lefttext:SetTextColor(1, 1, 1, 1)
					bar[2].righttext:SetText(_details:ToK2Min(data[2])) -- .. "(" .. _math_floor(data[2] / total * 100) .. "%)"
					bar[2]:SetValue(data[2] / top * 100)
					bar[3][1] = data[1].counter --tooltip hits
					bar[3][2] = data[2] / data[1].counter --tooltip average
					bar[3][3] = _math_floor(data[1].c_amt / data[1].counter * 100) --tooltip critical
					bar[3][4] = spellid
					
					--seta no segundo box
					local player_2 = other_players[1]
					local spell = player_2.spell_tables._ActorTable[spellid]
					local bar_2 = frame2.bars[i]
					
					-- ~compare
					if (spell) then
						bar_2[1]:SetTexture(icon)
						bar_2[2].lefttext:SetText(player_2_spell_info[spellid] .. ". " .. name)
						bar_2[2].lefttext:SetTextColor(1, 1, 1, 1)
						
						if (spell.total == 0 and data[2] == 0) then
							bar_2[2].righttext:SetText("0 +(0%)")
							
						elseif (data[2] > spell.total) then
							local diff = data[2] - spell.total
							local up = diff / spell.total * 100
							up = _math_floor(up)
							if (up > 999) then
								up = ">" .. 999
							end
							bar_2[2].righttext:SetText(_details:ToK2Min(spell.total) .. " |c" .. minor .. up .. "%)|r")
						else
							local diff = spell.total - data[2]
							local down = diff / data[2] * 100
							down = _math_floor(down)
							if (down > 999) then
								down = ">" .. 999
							end
							bar_2[2].righttext:SetText(_details:ToK2Min(spell.total) .. " |c" .. plus .. down .. "%)|r")
						end
						
						bar_2[2]:SetValue(spell.total / player_2_top * 100)
						bar_2[3][1] = spell.counter --tooltip hits
						bar_2[3][2] = spell.total / spell.counter --tooltip average
						bar_2[3][3] = _math_floor(spell.c_amt / spell.counter * 100) --tooltip critical
					else
						bar_2[1]:SetTexture(nil)
						bar_2[2].lefttext:SetText(empty_text)
						bar_2[2].lefttext:SetTextColor(.5, .5, .5, 1)
						bar_2[2].righttext:SetText("")
						bar_2[2]:SetValue(0)
					end
					
					--seta o terceiro box
					local bar_3 = frame3.bars[i]
					
					if (player_3_total) then
						local player_3 = other_players[2]
						local spell = player_3.spell_tables._ActorTable[spellid]
						
						if (spell) then
							bar_3[1]:SetTexture(icon)
							bar_3[2].lefttext:SetText(player_3_spell_info[spellid] .. ". " .. name)
							bar_3[2].lefttext:SetTextColor(1, 1, 1, 1)
							
							if (spell.total == 0 and data[2] == 0) then
								bar_3[2].righttext:SetText("0 +(0%)")
								
							elseif (data[2] > spell.total) then
								local diff = data[2] - spell.total
								local up = diff / spell.total * 100
								up = _math_floor(up)
								if (up > 999) then
									up = ">" .. 999
								end
								bar_3[2].righttext:SetText(_details:ToK2Min(spell.total) .. " |c" .. minor .. up .. "%)|r")
							else
								local diff = spell.total - data[2]
								local down = diff / data[2] * 100
								down = _math_floor(down)
								if (down > 999) then
									down = ">" .. 999
								end
								bar_3[2].righttext:SetText(_details:ToK2Min(spell.total) .. " |c" .. plus .. down .. "%)|r")
							end
							
							bar_3[2]:SetValue(spell.total / player_3_top * 100)
							bar_3[3][1] = spell.counter --tooltip hits
							bar_3[3][2] = spell.total / spell.counter --tooltip average
							bar_3[3][3] = _math_floor(spell.c_amt / spell.counter * 100) --tooltip critical
						else
							bar_3[1]:SetTexture(nil)
							bar_3[2].lefttext:SetText(empty_text)
							bar_3[2].lefttext:SetTextColor(.5, .5, .5, 1)
							bar_3[2].righttext:SetText("")
							bar_3[2]:SetValue(0)
						end
					else
						bar_3[1]:SetTexture(nil)
						bar_3[2].lefttext:SetText(empty_text)
						bar_3[2].lefttext:SetTextColor(.5, .5, .5, 1)
						bar_3[2].righttext:SetText("")
						bar_3[2]:SetValue(0)
					end
				else
					bar[1]:SetTexture(nil)
					bar[2].lefttext:SetText(empty_text)
					bar[2].lefttext:SetTextColor(.5, .5, .5, 1)
					bar[2].righttext:SetText("")
					bar[2]:SetValue(0)
					local bar_2 = frame2.bars[i]
					bar_2[1]:SetTexture(nil)
					bar_2[2].lefttext:SetText(empty_text)
					bar_2[2].lefttext:SetTextColor(.5, .5, .5, 1)
					bar_2[2].righttext:SetText("")
					bar_2[2]:SetValue(0)
					local bar_3 = frame3.bars[i]
					bar_3[1]:SetTexture(nil)
					bar_3[2].lefttext:SetText(empty_text)
					bar_3[2].lefttext:SetTextColor(.5, .5, .5, 1)
					bar_3[2].righttext:SetText("")
					bar_3[2]:SetValue(0)
				end
				
			end
			
			for index, spelltable in _ipairs(spells_sorted) do
				
			end
			
		end
	
		local refresh_comparison_box = function(self)
			--atualiza a scroll
			FauxScrollFrame_Update(self, math.max(self.tab.spells_amt, 10), 9, 15)
			fill_compare_actors(self, self.tab.player, self.tab.players)
		end
		
		local refresh_target_box = function(self)
			
			--player 1 targets
			local my_targets = self.tab.player.targets._ActorTable
			local target_pool = {}
			for index, target in _ipairs(my_targets) do 
				target_pool[#target_pool+1] = {target.name, target.total}
			end
			table.sort(target_pool, function(t1, t2) return t1[2] > t2[2] end)
			
			FauxScrollFrame_Update(self, math.max(#target_pool, 5), 4, 14)

			fill_compare_targets(self, self.tab.player, self.tab.players, target_pool)
		end
	
		local compare_fill = function(tab, player, combat)
			local players_to_compare = tab.players
			
			DetailsPlayerComparisonBox1.name_label:SetText(player:Name())
			
			local label2 = _G["DetailsPlayerComparisonBox2"].name_label
			local label3 = _G["DetailsPlayerComparisonBox3"].name_label
			
			if (players_to_compare[1]) then
				label2:SetText(players_to_compare[1]:Name())
			end
			if (players_to_compare[2]) then
				label3:SetText(players_to_compare[2]:Name())
			else
				label3:SetText("Player 3")
			end
			
			refresh_comparison_box(DetailsPlayerComparisonBox1)
			refresh_target_box(DetailsPlayerComparisonTarget1)
			
		end
	
		local on_enter_target = function(self)
		
			local frame1 = DetailsPlayerComparisonTarget1
			local frame2 = DetailsPlayerComparisonTarget2
			local frame3 = DetailsPlayerComparisonTarget3
		
			local bar1 = frame1.bars[self.index]
			local bar2 = frame2.bars[self.index]
			local bar3 = frame3.bars[self.index]

			local player_1 = bar1[3][4]
			if (not player_1) then
				return
			end
			local player_2 = bar2[3][4]
			local player_3 = bar3[3][4]
			
			local target_name = bar1[3][2]
			
			frame1.tooltip:SetPoint("bottomleft", bar1[2], "topleft", -18, 5)
			frame2.tooltip:SetPoint("bottomleft", bar2[2], "topleft", -18, 5)
			frame3.tooltip:SetPoint("bottomleft", bar3[2], "topleft", -18, 5)

			local actor1_total = bar1[3][3]
			local actor2_total = bar1[3][3]
			local actor3_total = bar1[3][3]
			
			-- player 1
			local player_1_skills = {}
			for spellid, spell in _pairs(player_1.spell_tables._ActorTable) do
				for index, target in _ipairs(spell.targets._ActorTable) do
					if (target.name == target_name) then
						player_1_skills[#player_1_skills+1] = {spellid, target.total}
					end
				end
			end
			table.sort(player_1_skills, _details.Sort2)
			local player_1_top = player_1_skills[1][2]
			
			-- player 2
			local player_2_skills = {}
			local player_2_top
			if (player_2) then
				for spellid, spell in _pairs(player_2.spell_tables._ActorTable) do
					for index, target in _ipairs(spell.targets._ActorTable) do
						if (target.name == target_name) then
							player_2_skills[#player_2_skills+1] = {spellid, target.total}
						end
					end
				end
				table.sort(player_2_skills, _details.Sort2)
				player_2_top = player_2_skills[1][2]
			end
			
			-- player 3
			local player_3_skills = {}
			local player_3_top
			if (player_3) then
				for spellid, spell in _pairs(player_3.spell_tables._ActorTable) do
					for index, target in _ipairs(spell.targets._ActorTable) do
						if (target.name == target_name) then
							player_3_skills[#player_3_skills+1] = {spellid, target.total}
						end
					end
				end
				table.sort(player_3_skills, _details.Sort2)
				player_3_top = player_3_skills[1][2]
			end
			
			-- build tooltip
			frame1.tooltip:Reset()
			frame2.tooltip:Reset()
			frame3.tooltip:Reset()
			
			frame1.tooltip:Show()
			frame2.tooltip:Show()
			frame3.tooltip:Show()
			
			local frame2_gotresults = false
			local frame3_gotresults = false
			
			for index, spell in _ipairs(player_1_skills) do
				local bar = frame1.tooltip.bars[index]
				if (not bar) then
					bar = frame1.tooltip:CreateBar()
				end
				
				local name, _, icon = _GetSpellInfo(spell[1])
				bar[1]:SetTexture(icon)
				bar[2].lefttext:SetText(index .. ". " .. name)
				bar[2].righttext:SetText(_details:ToK2Min(spell[2]))
				bar[2]:SetValue(spell[2]/player_1_top*100)
				
				if (player_2) then
					local player_2_skill
					local found_skill = false
					for this_index, this_spell in _ipairs(player_2_skills) do
						if (spell[1] == this_spell[1]) then
							local bar = frame2.tooltip.bars[index]
							if (not bar) then
								bar = frame2.tooltip:CreateBar(index)
							end
							
							bar[1]:SetTexture(icon)
							bar[2].lefttext:SetText(this_index .. ". " .. name)
							
							if (spell[2] > this_spell[2]) then
								local diff = spell[2] - this_spell[2]
								local up = diff / this_spell[2] * 100
								up = _math_floor(up)
								if (up > 999) then
									up = ">" .. 999
								end
								bar[2].righttext:SetText(_details:ToK2Min(this_spell[2]) .. " |c" .. minor .. up .. "%)|r")
							else
								local diff = this_spell[2] - spell[2]
								local down = diff / spell[2] * 100
								down = _math_floor(down)
								if (down > 999) then
									down = ">" .. 999
								end
								bar[2].righttext:SetText(_details:ToK2Min(this_spell[2]) .. " |c" .. plus .. down .. "%)|r")
							end

							bar[2]:SetValue(this_spell[2]/player_2_top*100)
							found_skill = true
							frame2_gotresults = true
							break
						end
					end
					if (not found_skill) then
						local bar = frame2.tooltip.bars[index]
						if (not bar) then
							bar = frame2.tooltip:CreateBar(index)
						end
						bar[1]:SetTexture(nil)
						bar[2].lefttext:SetText("")
						bar[2].righttext:SetText("")
					end
				end
				
				if (player_3) then
					local player_3_skill
					local found_skill = false
					for this_index, this_spell in _ipairs(player_3_skills) do
						if (spell[1] == this_spell[1]) then
							local bar = frame3.tooltip.bars[index]
							if (not bar) then
								bar = frame3.tooltip:CreateBar(index)
							end
							
							bar[1]:SetTexture(icon)
							bar[2].lefttext:SetText(this_index .. ". " .. name)
							
							if (spell[2] > this_spell[2]) then
								local diff = spell[2] - this_spell[2]
								local up = diff / this_spell[2] * 100
								up = _math_floor(up)
								if (up > 999) then
									up = ">" .. 999
								end
								bar[2].righttext:SetText(_details:ToK2Min(this_spell[2]) .. " |c" .. minor .. up .. "%)|r")
							else
								local diff = this_spell[2] - spell[2]
								local down = diff / spell[2] * 100
								down = _math_floor(down)
								if (down > 999) then
									down = ">" .. 999
								end
								bar[2].righttext:SetText(_details:ToK2Min(this_spell[2]) .. " |c" .. plus .. down .. "%)|r")
							end

							bar[2]:SetValue(this_spell[2]/player_3_top*100)
							found_skill = true
							frame3_gotresults = true
							break
						end
					end
					if (not found_skill) then
						local bar = frame3.tooltip.bars[index]
						if (not bar) then
							bar = frame3.tooltip:CreateBar(index)
						end
						bar[1]:SetTexture(nil)
						bar[2].lefttext:SetText("")
						bar[2].righttext:SetText("")
					end
				end
				
			end
			
			frame1.tooltip:SetHeight((#player_1_skills*15) + 10)
			frame2.tooltip:SetHeight((#player_1_skills*15) + 10)
			frame3.tooltip:SetHeight((#player_1_skills*15) + 10)
			
			if (not frame2_gotresults) then
				frame2.tooltip:Hide()
			end
			if (not frame3_gotresults) then
				frame3.tooltip:Hide()
			end

		end
		
		local on_leave_target = function(self)
			local frame1 = DetailsPlayerComparisonTarget1
			local frame2 = DetailsPlayerComparisonTarget2
			local frame3 = DetailsPlayerComparisonTarget3
		
			local bar1 = frame1.bars[self.index]
			local bar2 = frame2.bars[self.index]
			local bar3 = frame3.bars[self.index]
		
			bar1[2]:SetStatusBarColor(.5, .5, .5, 1)
			bar1[2].icon:SetTexCoord(0, 1, 0, 1)
			bar2[2]:SetStatusBarColor(.5, .5, .5, 1)
			bar2[2].icon:SetTexCoord(0, 1, 0, 1)
			bar3[2]:SetStatusBarColor(.5, .5, .5, 1)
			bar3[2].icon:SetTexCoord(0, 1, 0, 1)
			
			frame1.tooltip:Hide()
			frame2.tooltip:Hide()
			frame3.tooltip:Hide()
		end
	
		local on_enter = function(self)
		
			local frame1 = DetailsPlayerComparisonBox1
			local frame2 = DetailsPlayerComparisonBox2
			local frame3 = DetailsPlayerComparisonBox3
		
			local bar1 = frame1.bars[self.index]
			local bar2 = frame2.bars[self.index]
			local bar3 = frame3.bars[self.index]

			frame1.tooltip:SetPoint("bottomleft", bar1[2], "topleft", -18, 5)
			frame2.tooltip:SetPoint("bottomleft", bar2[2], "topleft", -18, 5)
			frame3.tooltip:SetPoint("bottomleft", bar3[2], "topleft", -18, 5)

			local spellid = bar1[3][4]
			local player1 = frame1.player
			local player2 = frame2.player
			local player3 = frame3.player
			
			local hits = bar1[3][1]
			local average = bar1[3][2]
			local critical = bar1[3][3]

			local player1_misc = info.instance.showing(4, player1)
			local player2_misc = info.instance.showing(4, player2)
			local player3_misc = info.instance.showing(4, player3)
			
			local player1_uptime
			
			if (bar1[2].righttext:GetText()) then
				bar1[2]:SetStatusBarColor(1, 1, 1, 1)
				bar1[2].icon:SetTexCoord(.1, .9, .1, .9)
				frame1.tooltip.hits_label2:SetText(hits)
				frame1.tooltip.average_label2:SetText(_details:ToK2Min(average))
				frame1.tooltip.crit_label2:SetText(critical .. "%")
				
				if (player1_misc) then
					local spell = player1_misc.debuff_uptime_spell_tables and player1_misc.debuff_uptime_spell_tables._ActorTable and player1_misc.debuff_uptime_spell_tables._ActorTable[spellid]
					if (spell) then
						local minutes, seconds = _math_floor(spell.uptime/60), _math_floor(spell.uptime%60)
						player1_uptime = spell.uptime
						frame1.tooltip.uptime_label2:SetText(minutes .. "m" .. seconds .. "s")
					else
						frame1.tooltip.uptime_label2:SetText("--x--x--")
					end
				else
					frame1.tooltip.uptime_label2:SetText("--x--x--")
				end
				
				frame1.tooltip:Show()
			end
			
			if (bar2[2].righttext:GetText()) then
			
				bar2[2]:SetStatusBarColor(1, 1, 1, 1)
				bar2[2].icon:SetTexCoord(.1, .9, .1, .9)
				
				if (hits > bar2[3][1]) then
					local diff = hits - bar2[3][1]
					local up = diff / bar2[3][1] * 100
					up = _math_floor(up)
					if (up > 999) then
						up = ">" .. 999
					end
					frame2.tooltip.hits_label2:SetText(bar2[3][1] .. " |c" .. minor .. up .. "%)|r")
				else
					local diff = bar2[3][1] - hits
					local down = diff / hits * 100
					down = _math_floor(down)
					if (down > 999) then
						down = ">" .. 999
					end
					frame2.tooltip.hits_label2:SetText(bar2[3][1] .. " |c" .. plus .. down .. "%)|r")
				end
				
				if (average > bar2[3][2]) then
					local diff = average - bar2[3][2]
					local up = diff / bar2[3][2] * 100
					up = _math_floor(up)
					if (up > 999) then
						up = ">" .. 999
					end
					frame2.tooltip.average_label2:SetText(_details:ToK2Min(bar2[3][2]) .. " |c" .. minor .. up .. "%)|r")
				else
					local diff = bar2[3][2] - average
					local down = diff / average * 100
					down = _math_floor(down)
					if (down > 999) then
						down = ">" .. 999
					end
					frame2.tooltip.average_label2:SetText(_details:ToK2Min(bar2[3][2]) .. " |c" .. plus .. down .. "%)|r")
				end
				
				if (critical > bar2[3][3]) then
					local diff = critical - bar2[3][3]
					local up = diff / bar2[3][3] * 100
					up = _math_floor(up)
					if (up > 999) then
						up = ">" .. 999
					end
					frame2.tooltip.crit_label2:SetText(bar2[3][3] .. "%" .. " |c" .. minor .. up .. "%)|r")
				else
					local diff = bar2[3][3] - critical
					local down = diff / critical * 100
					down = _math_floor(down)
					if (down > 999) then
						down = ">" .. 999
					end
					frame2.tooltip.crit_label2:SetText(bar2[3][3] .. "%" .. " |c" .. plus .. down .. "%)|r")
				end
				
				if (player2_misc) then
					local spell = player2_misc.debuff_uptime_spell_tables and player2_misc.debuff_uptime_spell_tables._ActorTable and player2_misc.debuff_uptime_spell_tables._ActorTable[spellid]
					if (spell and spell.uptime) then
						local minutes, seconds = _math_floor(spell.uptime/60), _math_floor(spell.uptime%60)
						
						if (not player1_uptime) then
							frame2.tooltip.uptime_label2:SetText(minutes .. "m" .. seconds .. "s(0%)|r")
						
						elseif (player1_uptime > spell.uptime) then
							local diff = player1_uptime - spell.uptime
							local up = diff / spell.uptime * 100
							up = _math_floor(up)
							if (up > 999) then
								up = ">" .. 999
							end
							frame2.tooltip.uptime_label2:SetText(minutes .. "m" .. seconds .. "s |c" .. minor .. up .. "%)|r")
						else
							local diff = spell.uptime - player1_uptime
							local down = diff / player1_uptime * 100
							down = _math_floor(down)
							if (down > 999) then
								down = ">" .. 999
							end
							frame2.tooltip.uptime_label2:SetText(minutes .. "m" .. seconds .. "s |c" .. plus .. down .. "%)|r")
						end
					else
						frame2.tooltip.uptime_label2:SetText("--x--x--")
					end
				else
					frame2.tooltip.uptime_label2:SetText("--x--x--")
				end

				frame2.tooltip:Show()
			end
			
			---------------------------------------------------
			
			if (bar3[2].righttext:GetText()) then
				bar3[2]:SetStatusBarColor(1, 1, 1, 1)
				bar3[2].icon:SetTexCoord(.1, .9, .1, .9)
				
				if (hits > bar3[3][1]) then
					local diff = hits - bar3[3][1]
					local up = diff / bar3[3][1] * 100
					up = _math_floor(up)
					if (up > 999) then
						up = ">" .. 999
					end
					frame3.tooltip.hits_label2:SetText(bar3[3][1] .. " |c" .. minor .. up .. "%)|r")
				else
					local diff = bar3[3][1] - hits
					local down = diff / hits * 100
					down = _math_floor(down)
					if (down > 999) then
						down = ">" .. 999
					end
					frame3.tooltip.hits_label2:SetText(bar3[3][1] .. " |c" .. plus .. down .. "%)|r")
				end

				if (average > bar3[3][2]) then
					local diff = average - bar3[3][2]
					local up = diff / bar3[3][2] * 100
					up = _math_floor(up)
					if (up > 999) then
						up = ">" .. 999
					end
					frame3.tooltip.average_label2:SetText(_details:ToK2Min(bar3[3][2]) .. " |c" .. minor .. up .. "%)|r")
				else
					local diff = bar3[3][2] - average
					local down = diff / average * 100
					down = _math_floor(down)
					if (down > 999) then
						down = ">" .. 999
					end
					frame3.tooltip.average_label2:SetText(_details:ToK2Min(bar3[3][2]) .. " |c" .. plus .. down .. "%)|r")
				end
				
				if (critical > bar3[3][3]) then
					local diff = critical - bar3[3][3]
					local up = diff / bar3[3][3] * 100
					up = _math_floor(up)
					if (up > 999) then
						up = ">" .. 999
					end
					frame3.tooltip.crit_label2:SetText(bar3[3][3] .. "%" .. " |c" .. minor .. up .. "%)|r")
				else
					local diff = bar3[3][3] - critical
					local down = diff / critical * 100
					down = _math_floor(down)
					if (down > 999) then
						down = ">" .. 999
					end
					frame3.tooltip.crit_label2:SetText(bar3[3][3] .. "%" .. " |c" .. plus .. down .. "%)|r")
				end

				if (player3_misc) then
					local spell = player3_misc.debuff_uptime_spell_tables and player3_misc.debuff_uptime_spell_tables._ActorTable and player3_misc.debuff_uptime_spell_tables._ActorTable[spellid]
					if (spell and spell.uptime) then
						local minutes, seconds = _math_floor(spell.uptime/60), _math_floor(spell.uptime%60)
						
						if (not player1_uptime) then
							frame3.tooltip.uptime_label2:SetText(minutes .. "m" .. seconds .. "s(0%)|r")
							
						elseif (player1_uptime > spell.uptime) then
							local diff = player1_uptime - spell.uptime
							local up = diff / spell.uptime * 100
							up = _math_floor(up)
							if (up > 999) then
								up = ">" .. 999
							end
							frame3.tooltip.uptime_label2:SetText(minutes .. "m" .. seconds .. "s |c" .. minor .. up .. "%)|r")
						else
							local diff = spell.uptime - player1_uptime
							local down = diff / player1_uptime * 100
							down = _math_floor(down)
							if (down > 999) then
								down = ">" .. 999
							end
							frame3.tooltip.uptime_label2:SetText(minutes .. "m" .. seconds .. "s |c" .. plus .. down .. "%)|r")
						end
					else
						frame3.tooltip.uptime_label2:SetText("--x--x--")
					end
				else
					frame3.tooltip.uptime_label2:SetText("--x--x--")
				end
				
				frame3.tooltip:Show()
			end
		end
		
		local on_leave = function(self)
			local frame1 = DetailsPlayerComparisonBox1
			local frame2 = DetailsPlayerComparisonBox2
			local frame3 = DetailsPlayerComparisonBox3
		
			local bar1 = frame1.bars[self.index]
			local bar2 = frame2.bars[self.index]
			local bar3 = frame3.bars[self.index]
		
			bar1[2]:SetStatusBarColor(.5, .5, .5, 1)
			bar1[2].icon:SetTexCoord(0, 1, 0, 1)
			bar2[2]:SetStatusBarColor(.5, .5, .5, 1)
			bar2[2].icon:SetTexCoord(0, 1, 0, 1)
			bar3[2]:SetStatusBarColor(.5, .5, .5, 1)
			bar3[2].icon:SetTexCoord(0, 1, 0, 1)
			
			frame1.tooltip:Hide()
			frame2.tooltip:Hide()
			frame3.tooltip:Hide()
		end
	
		local compare_create = function(tab, frame)
		
			local create_bar = function(name, parent, index, main, is_target)
				local y =((index-1) * -15) - 7
			
				local spellicon = parent:CreateTexture(nil, "overlay")
				spellicon:SetSize(14, 14)
				spellicon:SetPoint("topleft", parent, "topleft", 4, y)
				spellicon:SetTexture([[Interface\InventoryItems\WoWUnknownItem01]])
			
				local bar = CreateFrame("StatusBar", name, parent)
				bar.index = index
				bar:SetPoint("topleft", spellicon, "topright", 0, 0)
				bar:SetPoint("topright", parent, "topright", -4, y)
				bar:SetStatusBarTexture([[Interface\AddOns\Details\images\bar_serenity]])
				bar:SetStatusBarColor(.5, .5, .5, 1)
				bar:SetMinMaxValues(0, 100)
				bar:SetValue(100)
				bar:SetHeight(14)
				bar.icon = spellicon
				
				if (is_target) then
					bar:SetScript("OnEnter", on_enter_target)
					bar:SetScript("OnLeave", on_leave_target)
				else
					bar:SetScript("OnEnter", on_enter)
					bar:SetScript("OnLeave", on_leave)
				end
				
				bar.lefttext = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")

				local _, size, flags = bar.lefttext:GetFont()
				local font = SharedMedia:Fetch("font", "Arial Narrow")
				bar.lefttext:SetFont(font, 11)
				
				bar.lefttext:SetPoint("left", bar, "left", 2, 0)
				bar.lefttext:SetJustifyH("left")
				bar.lefttext:SetTextColor(1, 1, 1, 1)
				bar.lefttext:SetNonSpaceWrap(true)
				bar.lefttext:SetWordWrap(false)
				if (main) then
					bar.lefttext:SetWidth(110)
				else
					bar.lefttext:SetWidth(70)
				end
				
				bar.righttext = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
				
				local _, size, flags = bar.righttext:GetFont()
				local font = SharedMedia:Fetch("font", "Arial Narrow")
				bar.righttext:SetFont(font, 11)
				
				bar.righttext:SetPoint("right", bar, "right", -2, 0)
				bar.righttext:SetJustifyH("right")
				bar.righttext:SetTextColor(1, 1, 1, 1)
				
				tinsert(parent.bars, {spellicon, bar, {0, 0, 0}})
			end
			
			local create_tooltip = function(name)
				local tooltip = CreateFrame("frame", name, UIParent)
				tooltip:SetBackdrop({bgFile =[[Interface\Tooltips\UI-Tooltip-Background]], edgeFile =[[Interface\Tooltips\UI-Tooltip-Border]], tile = true, tileSize = 16, edgeSize = 12, insets = {left = 1, right = 1, top = 1, bottom = 1},})	
				tooltip:SetBackdropColor(0, 0, 0, 1)
				tooltip:SetSize(175, 67)
				tooltip:SetFrameStrata("tooltip")
				
				local background = tooltip:CreateTexture(nil, "artwork")
				background:SetTexture([[Interface\AddOns\Details\images\Spellbook-Page-1]])
				background:SetTexCoord(.6, 0.1, 0, 0.64453125)
				background:SetVertexColor(1, 1, 1, 0.2)
				background:SetPoint("topleft", tooltip, "topleft", 2, -4)
				background:SetPoint("bottomright", tooltip, "bottomright", -4, 2)
				
				tooltip.hits_label = tooltip:CreateFontString(nil, "overlay", "GameFontNormalSmall")
				tooltip.hits_label:SetPoint("topleft", tooltip, "topleft", 10, -10)
				tooltip.hits_label:SetText("Total Hits:")
				tooltip.hits_label:SetJustifyH("left")
				tooltip.hits_label2 = tooltip:CreateFontString(nil, "overlay", "GameFontNormalSmall")
				tooltip.hits_label2:SetPoint("topright", tooltip, "topright", -10, -10)
				tooltip.hits_label2:SetText("0")
				tooltip.hits_label2:SetJustifyH("right")
				
				tooltip.average_label = tooltip:CreateFontString(nil, "overlay", "GameFontNormalSmall")
				tooltip.average_label:SetPoint("topleft", tooltip, "topleft", 10, -22)
				tooltip.average_label:SetText("Average:")
				tooltip.average_label:SetJustifyH("left")
				tooltip.average_label2 = tooltip:CreateFontString(nil, "overlay", "GameFontNormalSmall")
				tooltip.average_label2:SetPoint("topright", tooltip, "topright", -10, -22)
				tooltip.average_label2:SetText("0")
				tooltip.average_label2:SetJustifyH("right")
				
				tooltip.crit_label = tooltip:CreateFontString(nil, "overlay", "GameFontNormalSmall")
				tooltip.crit_label:SetPoint("topleft", tooltip, "topleft", 10, -34)
				tooltip.crit_label:SetText("Critical:")
				tooltip.crit_label:SetJustifyH("left")
				tooltip.crit_label2 = tooltip:CreateFontString(nil, "overlay", "GameFontNormalSmall")
				tooltip.crit_label2:SetPoint("topright", tooltip, "topright", -10, -34)
				tooltip.crit_label2:SetText("0")
				tooltip.crit_label2:SetJustifyH("right")
				
				tooltip.uptime_label = tooltip:CreateFontString(nil, "overlay", "GameFontNormalSmall")
				tooltip.uptime_label:SetPoint("topleft", tooltip, "topleft", 10, -46)
				tooltip.uptime_label:SetText("Uptime:")
				tooltip.uptime_label:SetJustifyH("left")
				tooltip.uptime_label2 = tooltip:CreateFontString(nil, "overlay", "GameFontNormalSmall")
				tooltip.uptime_label2:SetPoint("topright", tooltip, "topright", -10, -46)
				tooltip.uptime_label2:SetText("0")
				tooltip.uptime_label2:SetJustifyH("right")
				
				return tooltip
			end

			local create_tooltip_target = function(name)
				local tooltip = CreateFrame("frame", name, UIParent)
				tooltip:SetBackdrop({bgFile =[[Interface\Tooltips\UI-Tooltip-Background]], edgeFile =[[Interface\Tooltips\UI-Tooltip-Border]], tile = true, tileSize = 16, edgeSize = 12, insets = {left = 1, right = 1, top = 1, bottom = 1},})	
				tooltip:SetBackdropColor(0, 0, 0, 1)
				tooltip:SetSize(175, 67)
				tooltip:SetFrameStrata("tooltip")
				tooltip.bars = {}
				
				function tooltip:Reset()
					for index, bar in _ipairs(tooltip.bars) do 
						bar[1]:SetTexture(nil)
						bar[2].lefttext:SetText("")
						bar[2].righttext:SetText("")
						bar[2]:SetValue(0)
					end
				end
				
				function tooltip:CreateBar(index)
				
					if (index) then
						if (index > #tooltip.bars+1) then
							for i = #tooltip.bars+1, index-1 do
								tooltip:CreateBar()
							end
						end
					end
				
					local index = #tooltip.bars+1
					local y =((index-1) * -15) - 7
					local parent = tooltip
				
					local spellicon = parent:CreateTexture(nil, "overlay")
					spellicon:SetSize(14, 14)
					spellicon:SetPoint("topleft", parent, "topleft", 4, y)
					spellicon:SetTexture([[Interface\InventoryItems\WoWUnknownItem01]])
				
					local bar = CreateFrame("StatusBar", name .. "Bar" .. index, parent)
					bar.index = index
					bar:SetPoint("topleft", spellicon, "topright", 0, 0)
					bar:SetPoint("topright", parent, "topright", -4, y)
					bar:SetStatusBarTexture([[Interface\AddOns\Details\images\bar_serenity]])
					bar:SetStatusBarColor(.5, .5, .5, 1)
					bar:SetMinMaxValues(0, 100)
					bar:SetValue(0)
					bar:SetHeight(14)
					bar.icon = spellicon
		
					bar.lefttext = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
					local _, size, flags = bar.lefttext:GetFont()
					local font = SharedMedia:Fetch("font", "Arial Narrow")
					bar.lefttext:SetFont(font, 11)					
					bar.lefttext:SetPoint("left", bar, "left", 2, 0)
					bar.lefttext:SetJustifyH("left")
					bar.lefttext:SetTextColor(1, 1, 1, 1)
					bar.lefttext:SetNonSpaceWrap(true)
					bar.lefttext:SetWordWrap(false)
					
					if (name:find("1")) then
						bar.lefttext:SetWidth(110)
					else
						bar.lefttext:SetWidth(80)
					end
					
					bar.righttext = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")	
					local _, size, flags = bar.righttext:GetFont()
					local font = SharedMedia:Fetch("font", "Arial Narrow")
					bar.righttext:SetFont(font, 11)					
					bar.righttext:SetPoint("right", bar, "right", -2, 0)
					bar.righttext:SetJustifyH("right")
					bar.righttext:SetTextColor(1, 1, 1, 1)
					
					local object = {spellicon, bar}
					tinsert(tooltip.bars, object)
					return object
				end
				
				local background = tooltip:CreateTexture(nil, "artwork")
				background:SetTexture([[Interface\AddOns\Details\images\Spellbook-Page-1]])
				background:SetTexCoord(.6, 0.1, 0, 0.64453125)
				background:SetVertexColor(0, 0, 0, 0.6)
				background:SetPoint("topleft", tooltip, "topleft", 2, -4)
				background:SetPoint("bottomright", tooltip, "bottomright", -4, 2)
				
				return tooltip
			end
			
			local frame1 = CreateFrame("scrollframe", "DetailsPlayerComparisonBox1", frame, "FauxScrollFrameTemplate")
			frame1:SetScript("OnVerticalScroll", function(self, offset) FauxScrollFrame_OnVerticalScroll(self, offset, 14, refresh_comparison_box) end)			
			frame1:SetSize(175, 150)
			frame1:SetPoint("topleft", frame, "topleft", 10, -30)
			frame1:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 10, insets = {left = 1, right = 1, top = 0, bottom = 1},})	
			frame1:SetBackdropColor(0, 0, 0, .7)
			frame1.bars = {}
			frame1.tab = tab
			frame1.tooltip = create_tooltip("DetailsPlayerComparisonBox1Tooltip")
			
			local playername1 = frame1:CreateFontString(nil, "overlay", "GameFontNormal")
			playername1:SetPoint("bottomleft", frame1, "topleft", 2, 0)
			playername1:SetText("Player 1")
			frame1.name_label = playername1
			
			--create as bars do frame1
			for i = 1, 9 do
				create_bar("DetailsPlayerComparisonBox1Bar"..i, frame1, i, true)
			end

			--cria o box dos targets
			local target1 = CreateFrame("scrollframe", "DetailsPlayerComparisonTarget1", frame, "FauxScrollFrameTemplate")
			target1:SetScript("OnVerticalScroll", function(self, offset) FauxScrollFrame_OnVerticalScroll(self, offset, 14, refresh_target_box) end)			
			target1:SetSize(175, 70)
			target1:SetPoint("topleft", frame1, "bottomleft", 0, -10)
			target1:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 10, insets = {left = 1, right = 1, top = 0, bottom = 1},})	
			target1:SetBackdropColor(0, 0, 0, .7)
			target1.bars = {}
			target1.tab = tab
			target1.tooltip = create_tooltip_target("DetailsPlayerComparisonTarget1Tooltip")
			
			--create as bars do target1
			for i = 1, 4 do
				create_bar("DetailsPlayerComparisonTarget1Bar"..i, target1, i, true, true)
			end
			
--------------------------------------------
			local frame2 = CreateFrame("frame", "DetailsPlayerComparisonBox2", frame)
			local frame3 = CreateFrame("frame", "DetailsPlayerComparisonBox3", frame)
			
			frame2:SetPoint("topleft", frame1, "topright", 25, 0)
			frame2:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 10, insets = {left = 1, right = 1, top = 0, bottom = 1},})	
			frame2:SetSize(170, 150)
			frame2:SetBackdropColor(0, 0, 0, .7)
			frame2.bars = {}
			frame2.tooltip = create_tooltip("DetailsPlayerComparisonBox2Tooltip")
			
			local playername2 = frame2:CreateFontString(nil, "overlay", "GameFontNormal")
			playername2:SetPoint("bottomleft", frame2, "topleft", 2, 0)
			playername2:SetText("Player 2")
			frame2.name_label = playername2
			
			--create as bars do frame2
			for i = 1, 9 do
				create_bar("DetailsPlayerComparisonBox2Bar"..i, frame2, i)
			end
			
			--cria o box dos targets
			local target2 = CreateFrame("frame", "DetailsPlayerComparisonTarget2", frame)
			target2:SetSize(170, 70)
			target2:SetPoint("topleft", frame2, "bottomleft", 0, -10)
			target2:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 10, insets = {left = 1, right = 1, top = 0, bottom = 1},})	
			target2:SetBackdropColor(0, 0, 0, .7)
			target2.bars = {}
			target2.tooltip = create_tooltip_target("DetailsPlayerComparisonTarget2Tooltip")
			
			--create as bars do target2
			for i = 1, 4 do
				create_bar("DetailsPlayerComparisonTarget2Bar"..i, target2, i, nil, true)
			end
			
			frame3:SetPoint("topleft", frame2, "topright", 5, 0)
			frame3:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 10, insets = {left = 1, right = 1, top = 0, bottom = 1},})	
			frame3:SetSize(170, 150)
			frame3:SetBackdropColor(0, 0, 0, .7)
			frame3.bars = {}
			frame3.tooltip = create_tooltip("DetailsPlayerComparisonBox3Tooltip")
			
			local playername3 = frame3:CreateFontString(nil, "overlay", "GameFontNormal")
			playername3:SetPoint("bottomleft", frame3, "topleft", 2, 0)
			playername3:SetText("Player 3")
			frame3.name_label = playername3
			
			--create as bars do frame3
			for i = 1, 9 do
				create_bar("DetailsPlayerComparisonBox3Bar"..i, frame3, i)
			end
			
			--cria o box dos targets
			local target3 = CreateFrame("frame", "DetailsPlayerComparisonTarget3", frame)
			target3:SetSize(170, 70)
			target3:SetPoint("topleft", frame3, "bottomleft", 0, -10)
			target3:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 10, insets = {left = 1, right = 1, top = 0, bottom = 1},})	
			target3:SetBackdropColor(0, 0, 0, .7)
			target3.bars = {}
			target3.tooltip = create_tooltip_target("DetailsPlayerComparisonTarget3Tooltip")
			
			--create as bars do target1
			for i = 1, 4 do
				create_bar("DetailsPlayerComparisonTarget3Bar"..i, target3, i, nil, true)
			end
		end

		-- ~compare
		_details:CreatePlayerDetailsTab("Compare", --[1] tab name
			function(tabOBject, playerObject)  --[2] condition
			
				if (info.attribute > 2) then
					return false
				end

				local same_class = {}
				local class = playerObject.class
				local my_spells = {}
				local my_spells_total = 0
				--> build my spell list
				for spellid, _ in _pairs(playerObject.spell_tables._ActorTable) do
					my_spells[spellid] = true
					my_spells_total = my_spells_total + 1
				end
				
				tabOBject.players = {}
				tabOBject.player = playerObject
				tabOBject.spells_amt = my_spells_total
				
				for index, actor in _ipairs(info.instance.showing[info.attribute]._ActorTable) do 
					if (actor.class == class and actor ~= playerObject) then

						local same_spells = 0
						for spellid, _ in _pairs(actor.spell_tables._ActorTable) do
							if (my_spells[spellid]) then
								same_spells = same_spells + 1
							end
						end
						
						local match_percentage = same_spells / my_spells_total * 100

						if (match_percentage > 30) then
							tinsert(tabOBject.players, actor)
						end
					end
				end
				
				if (#tabOBject.players > 0) then
					return true
				end
				
				return false
				--return true
			end, 
			
			compare_fill, --[3] fill function
			
			nil, --[4] onclick
			
			compare_create --[5] oncreate
		)
	
		function this_gump:ShowTabs()
			local amt_positive = 0

			for index = #_details.player_details_tabs, 1, -1 do
				
				local tab = _details.player_details_tabs[index]
				
				if (tab:condition(info.player, info.attribute, info.sub_attribute)) then
					tab:Show()
					amt_positive = amt_positive + 1
					tab:SetPoint("BOTTOMLEFT", info.container_bars, "TOPLEFT",  390 -(67 *(amt_positive-1)), 1)
				else
					tab.frame:Hide()
					tab:Hide()
				end
			end
			
			if (amt_positive < 2) then
				--_details.player_details_tabs[1]:Hide()
				_details.player_details_tabs[1]:SetPoint("BOTTOMLEFT", info.container_bars, "TOPLEFT",  390 -(67 *(2-1)), 1)
			end
			
			_details.player_details_tabs[1]:Click()
			
		end

		this_gump:SetScript("OnHide", function(self)
			_details:CloseWindowInfo()
			for _, tab in _ipairs(_details.player_details_tabs) do
				tab:Hide()
				tab.frame:Hide()
			end
		end)
	
	--DetailsInfoWindowTab1Text:SetText("Avoidance")
	this_gump.type = 1 --> type da window // 1 = window normal
	
	return this_gump
	
end

_details.player_details_tabs = {}

function _details:CreatePlayerDetailsTab(tabname, condition, fillfunction, onclick, oncreate)
	if (not tabname) then
		tabname = "unnamed"
	end

	local index = #_details.player_details_tabs
	
	local newtab = CreateFrame("button", "DetailsInfoWindowTab" .. index, info, "ChatTabTemplate")
	newtab:SetText(tabname)
	newtab:SetFrameStrata("HIGH")
	newtab:Hide()
	
	newtab.condition = condition
	newtab.tabname = tabname
	newtab.onclick = onclick
	newtab.fillfunction = fillfunction
	newtab.last_actor = {}
	
	--> frame
	newtab.frame = CreateFrame("frame", nil, UIParent)
	newtab.frame:SetFrameStrata("HIGH")
	newtab.frame:EnableMouse(true)
	
	if (newtab.fillfunction) then
		newtab.frame:SetScript("OnShow", function()
			if (newtab.last_actor == info.player) then
				return
			end
			newtab.last_actor = info.player
			newtab:fillfunction(info.player, info.instance.showing)
		end)
	end
	
	if (oncreate) then
		oncreate(newtab, newtab.frame)
	end
	
	newtab.frame:SetBackdrop({
		bgFile =[[Interface\AddOns\Details\images\UI-GuildAchievement-Parchment-Horizontal-Desaturated]], tile = true, tileSize = 512,
		edgeFile =[[Interface\ACHIEVEMENTFRAME\UI-Achievement-WoodBorder]], edgeSize = 32,
		insets = {left = 0, right = 0, top = 0, bottom = 0}})		
	newtab.frame:SetBackdropColor(.5, .50, .50, 1)
	
	newtab.frame:SetPoint("TOPLEFT", info, "TOPLEFT", 19, -76)
	newtab.frame:SetSize(569, 274)
	
	newtab.frame:Hide()
	
	--> adicionar ao container
	_details.player_details_tabs[#_details.player_details_tabs+1] = newtab
	
	if (not onclick) then
		--> hide all tabs
		newtab:SetScript("OnClick", function() 
			for _, tab in _ipairs(_details.player_details_tabs) do
				tab.frame:Hide()
				tab.leftSelectedTexture:SetVertexColor(1, 1, 1, 1)
				tab.middleSelectedTexture:SetVertexColor(1, 1, 1, 1)
				tab.rightSelectedTexture:SetVertexColor(1, 1, 1, 1)
			end
			
			newtab.leftSelectedTexture:SetVertexColor(1, .7, 0, 1)
			newtab.middleSelectedTexture:SetVertexColor(1, .7, 0, 1)
			newtab.rightSelectedTexture:SetVertexColor(1, .7, 0, 1)
			newtab.frame:Show()
		end)
	else
		--> custom
		newtab:SetScript("OnClick", function() 
			for _, tab in _ipairs(_details.player_details_tabs) do
				tab.frame:Hide()
				tab.leftSelectedTexture:SetVertexColor(1, 1, 1, 1)
				tab.middleSelectedTexture:SetVertexColor(1, 1, 1, 1)
				tab.rightSelectedTexture:SetVertexColor(1, 1, 1, 1)
			end
			
			newtab.leftSelectedTexture:SetVertexColor(1, .7, 0, 1)
			newtab.middleSelectedTexture:SetVertexColor(1, .7, 0, 1)
			newtab.rightSelectedTexture:SetVertexColor(1, .7, 0, 1)
			
			onclick()
		end)
	end
	
	--> remove os scripts padroes
	newtab:SetScript("OnDoubleClick", nil)
	newtab:SetScript("OnEnter", nil)
	newtab:SetScript("OnLeave", nil)
	newtab:SetScript("OnDragStart", nil)

end

function _details.window_info:prepare_report(button)
	
	local attribute = info.attribute
	local sub_attribute = info.sub_attribute
	local player = info.player
	local instance = info.instance

	local amt = _details.report_lines
	
	local report_lines
	
	if (button == 1) then --> botão da left
		report_lines = {"Details! " .. Loc["STRING_ACTORFRAME_SPELLSOF"] .. " " .. player.name .. "(" .. _details.sub_attributes[attribute].list[sub_attribute] .. ")"}
		for index, bar in _ipairs(info.bars1) do 
			if (bar:IsShown()) then
				local spellid = bar.show
				if (spellid > 10) then
					local link = GetSpellLink(spellid)
					report_lines[#report_lines+1] = index .. ". " .. link .. ": " .. bar.text_right:GetText()
				else
					local spellname = bar.text_left:GetText():gsub((".*%."), "")
					spellname = spellname:gsub("|c%x%x%x%x%x%x%x%x", "")
					spellname = spellname:gsub("|r", "")
					report_lines[#report_lines+1] = index .. ". " .. spellname .. ": " .. bar.text_right:GetText()
				end
			end
			if (index == amt) then
				break
			end
		end
		
	elseif (button == 3) then --> botão dos targets
	
		if (attribute == 1 and sub_attribute == 3) then
			print(Loc["STRING_ACTORFRAME_NOTHING"])
			return
		end
	
		report_lines = {"Details! " .. Loc["STRING_ACTORFRAME_REPORTTARGETS"] .. " " .. _details.sub_attributes[1].list[1] .. " " .. Loc["STRING_ACTORFRAME_REPORTOF"] .. " " .. player.name}

		for index, bar in _ipairs(info.bars2) do
			if (bar:IsShown()) then
				report_lines[#report_lines+1] = bar.text_left:GetText().." -> ".. bar.text_right:GetText()
			end
			if (index == amt) then
				break
			end
		end
		
	elseif (button == 2) then --> botão da right
	
			--> diferentes types de amostragem na caixa da right
		     --damage                       --damage done                 --dps                                 --heal
		if ((attribute == 1 and(sub_attribute == 1 or sub_attribute == 2)) or(attribute == 2)) then
			if (not player.details) then
				print(Loc["STRING_ACTORFRAME_NOTHING"])
				return
			end
			local name = _GetSpellInfo(player.details)
			report_lines = {"Details! " .. Loc["STRING_ACTORFRAME_REPORTTO"] .. " " .. _details.sub_attributes[attribute].list[sub_attribute] .. " " .. Loc["STRING_ACTORFRAME_REPORTOF"] .. " " .. player.name, 
			Loc["STRING_ACTORFRAME_SPELLDETAILS"] .. ": " .. name}
			
			for i = 1, 5 do
			
				--> pega os dados dos quadrados --> Aqui mostra o resumo de todos os quadrados...
				local caixa = info.groups_details[i]
				if (caixa.bg:IsShown()) then
				
					local linha = ""

					local name2 = caixa.name2:GetText() --> golpes
					if (name2 and name2 ~= "") then
						if (i == 1) then
							linha = linha..name2.." / "
						else
							linha = linha..caixa.name:GetText().." "..name2.." / "
						end
					end			
					
					local damage = caixa.damage:GetText() --> damage
					if (damage and damage ~= "") then
						linha = linha..damage.." / "
					end
					
					local media = caixa.damage_media:GetText() --> media
					if (media and media ~= "") then
						linha = linha..media.." / "
					end			
					
					local damage_dps = caixa.damage_dps:GetText()
					if (damage_dps and damage_dps ~= "") then
						linha = linha..damage_dps.." / "
					end
					
					local damage_percent = caixa.damage_percent:GetText()
					if (damage_percent and damage_percent ~= "") then
						linha = linha..damage_percent.." "
					end
					
					report_lines[#report_lines+1] = linha
					
				end
				
				if (i == amt) then
					break
				end
				
			end
			
			--damage                       --damage tanken(mostra as spells que o dst usou)
		elseif ((attribute == 1 and sub_attribute == 3) or attribute == 3) then
		
			report_lines = {"Details! " .. Loc["STRING_ACTORFRAME_REPORTTO"] .. " " .. _details.sub_attributes[1].list[1] .. " " .. Loc["STRING_ACTORFRAME_REPORTOF"] .. " " .. player.details.. " " .. Loc["STRING_ACTORFRAME_REPORTAT"] .. " " .. player.name}

			for index, bar in _ipairs(info.bars3) do 
			
				if (bar:IsShown()) then
					report_lines[#report_lines+1] = bar.text_left:GetText().." -> ".. bar.text_right:GetText()
				end
				if (index == amt) then
					break
				end
				
			end
		end
		
	elseif (button >= 11) then --> primeira caixa dos details
		
		button =  button - 10
		
		local name
		if (_type(spellid) == "string") then
			--> is a pet
		else
			name = _GetSpellInfo(player.details)
		end
		
		if (not name) then
			name = ""
		end
		report_lines = {"Details! " .. Loc["STRING_ACTORFRAME_REPORTTO"] .. " " .. _details.sub_attributes[attribute].list[sub_attribute].. " " .. Loc["STRING_ACTORFRAME_REPORTOF"] .. " " .. player.name, 
		Loc["STRING_ACTORFRAME_SPELLDETAILS"] .. ": " .. name} 
		
		local caixa = info.groups_details[button]
		
		local linha = ""
		local name2 = caixa.name2:GetText() --> golpes
		if (name2 and name2 ~= "") then
			if (i == 1) then
				linha = linha..name2.." / "
			else
				linha = linha..caixa.name:GetText().." "..name2.." / "
			end
		end

		local damage = caixa.damage:GetText() --> damage
		if (damage and damage ~= "") then
			linha = linha..damage.." / "
		end

		local media = caixa.damage_media:GetText() --> media
		if (media and media ~= "") then
			linha = linha..media.." / "
		end

		local damage_dps = caixa.damage_dps:GetText()
		if (damage_dps and damage_dps ~= "") then
			linha = linha..damage_dps.." / "
		end

		local damage_percent = caixa.damage_percent:GetText()
		if (damage_percent and damage_percent ~= "") then
			linha = linha..damage_percent.." "
		end

		
		report_lines[#report_lines+1] = linha
		
	end
	
	--local report_lines = {"Details! Relatorio para ".._details.sub_attributes[self.attribute].list[self.sub_attribute]}

	
	--> pega o conteúdo da window da right
	
	return instance:send_report(report_lines)
end

local row_on_enter = function(self)
	if (info.fading_in or info.faded) then
		return
	end
	
	self.mouse_over = true

	--> aumenta o tamanho da bar
	self:SetHeight(17) --> altura determinada pela instância
	--> poe a bar com alfa 1 ao invés de 0.9
	self:SetAlpha(1)

	--> troca a cor da bar enquanto o mouse estiver em cima dela
	self:SetBackdrop({
		--bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 10,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})	
	self:SetBackdropBorderColor(0.666, 0.666, 0.666)
	self:SetBackdropColor(0.0941, 0.0941, 0.0941)
	
	if (self.isTarget) then --> prepare o tooltip do dst
		--> talvez devesse escurecer a window no fundo... pois o tooltip é transparente e pode confundir
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		
		-- ~erro
		if (self.spellid == "enemies") then --> damage taken enemies
			if (not self.my_table or not self.my_table:SetTooltipDamageTaken(self, self._index, info.instance)) then  -- > poderia ser aprimerado para uma tailcall
				return
			end
		
		elseif (not self.my_table or not self.my_table:SetTooltipTargets(self, self._index, info.instance)) then  -- > poderia ser aprimerado para uma tailcall
			return
			
		end
		GameTooltip:Show()
		
	elseif (self.isMain) then
	
		if (IsShiftKeyDown()) then
			if (type(self.show) == "number") then
				GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
				GameTooltip:AddLine(Loc["ABILITY_ID"] .. ": " .. self.show)
				GameTooltip:Show()	
			end
		end
	
		--> da zoom no icon
		self.icon:SetWidth(17)
		self.icon:SetHeight(17)	
		--> poe a alfa do icon em 1.0
		self.icon:SetAlpha(1)
		
		--> mostrar timerariamente o content da bar nas caixas de details
		if (not info.displaying) then --> não this showing nada na right
			info.displaying = self --> agora o showing é igual a this bar
			info.showing_mouse_over = true --> o content da direta this sendo mostrado pq o mouse this passando por cima do bagulho e não pq foi clicado
			info.showing = self._index --> diz  o index da bar que this sendo mostrado na right

			info.player.details = self.show --> my table = player = player.detales = spellid ou name que this sendo mostrado na right
			info.player:SetDetails(self.show, self, info.instance) --> passa a spellid ou name e a bar
		end
	end
end

local row_on_leave = function(self)
	if (self.fading_in or self.faded or not self:IsShown() or self.hidden) then
		return
	end

	self.mouse_over = false

	--> diminui o tamanho da bar
	self:SetHeight(16)
	--> volta com o alfa antigo da bar que era de 0.9
	self:SetAlpha(0.9)
	
	--> volto o background ao normal
	self:SetBackdrop({
		bgFile = "", edgeFile = "", tile = true, tileSize = 16, edgeSize = 32,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})	
	self:SetBackdropBorderColor(0, 0, 0, 0)
	self:SetBackdropColor(0, 0, 0, 0)
	
	GameTooltip:Hide() 
	
	if (self.isMain) then
		--> retira o zoom no icon
		self.icon:SetWidth(14)
		self.icon:SetHeight(14)
		--> volta com a alfa antiga da bar
		self.icon:SetAlpha(0.8)
		
		--> remover o conteúdo que thisva sendo mostrado na right
		if (info.showing_mouse_over) then
			info.displaying = nil
			info.showing_mouse_over = false
			info.showing = nil
			
			info.player.details = nil
			gump:HidaAllDetailInfo()
		end
	end
end

local row_on_mousedown = function(self)
	if (self.fading_in) then
		return
	end

	self.mouse_down = _GetTime()
	local x, y = _GetCursorPosition()
	self.x = _math_floor(x)
	self.y = _math_floor(y)

	if ((not info.isLocked) or(info.isLocked == 0)) then
		info:StartMoving()
		info.isMoving = true
	end	
end

local row_on_mouseup = function(self)
	if (self.fading_in) then
		return
	end

	if (info.isMoving) then
		info:StopMovingOrSizing()
		info.isMoving = false
	end

	local x, y = _GetCursorPosition()
	x = _math_floor(x)
	y = _math_floor(y)
	if ((self.mouse_down+0.4 > _GetTime() and(x == self.x and y == self.y)) or(x == self.x and y == self.y)) then
		--> setar os texts
		
		if (self.isMain) then --> se não for uma bar de dst
		
			local bar_antiga = info.displaying			
			if (bar_antiga and not info.showing_mouse_over) then
			
				bar_antiga.texture:SetStatusBarColor(1, 1, 1, 1) --> volta a texture normal
				bar_antiga.on_focus = false --> não this mais no focus

				--> CLICOU NA MESMA BARRA
				if (bar_antiga == self) then --> 
					info.showing_mouse_over = true
					return
					
				--> CLICOU EM OUTRA BARRA
				else --> clicou em outra bar e trocou o focus
					bar_antiga:SetAlpha(.9) --> volta a alfa antiga
				
					info.displaying = self
					info.showing = i
					
					info.player.details = self.show
					info.player:SetDetails(self.show, self)
					
					self:SetAlpha(1)
					self.texture:SetStatusBarColor(129/255, 125/255, 69/255, 1)
					self.on_focus = true
					return
				end
			end
			
			--> NÃO TINHA BARRAS PRECIONADAS
			-- info.showing = self
			info.showing_mouse_over = false
			self:SetAlpha(1)
			self.texture:SetStatusBarColor(129/255, 125/255, 69/255, 1)
			self.on_focus = true
		end
		
	end
end

local function SetBarScripts(this_bar, instance, i)
	
	this_bar._index = i
	
	this_bar:SetScript("OnEnter", row_on_enter)
	this_bar:SetScript("OnLeave", row_on_leave)

	this_bar:SetScript("OnMouseDown", row_on_mousedown)
	this_bar:SetScript("OnMouseUp", row_on_mouseup)

end

local function CreateTexturaBar(instance, bar)
	bar.texture = _CreateFrame("StatusBar", nil, bar)
	bar.texture:SetAllPoints(bar)
	
	--bar.texture:SetStatusBarTexture(instance.row_info.texture_file)
	bar.texture:SetStatusBarTexture(_details.default_texture)
	--bar.texture:SetStatusBarTexture([[Interface\AddOns\Details\images\bar_serenity]])
	
	bar.texture:SetStatusBarColor(.5, .5, .5, 0)
	bar.texture:SetMinMaxValues(0,100)
	
	if (bar.targets) then
		bar.targets:SetParent(bar.texture)
		bar.targets:SetFrameLevel(bar.texture:GetFrameLevel()+2)
	end
	
	bar.text_left = bar.texture:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	bar.text_left:SetPoint("LEFT", bar.texture, "LEFT", 22, 0)
	bar.text_left:SetJustifyH("LEFT")
	bar.text_left:SetTextColor(1,1,1,1)
	
	bar.text_left:SetNonSpaceWrap(true)
	bar.text_left:SetWordWrap(false)
	
	bar.text_right = bar.texture:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	if (bar.targets) then
		bar.text_right:SetPoint("RIGHT", bar.targets, "LEFT", -2, 0)
	else
		bar.text_right:SetPoint("RIGHT", bar, "RIGHT", -2, 0)
	end
	bar.text_right:SetJustifyH("RIGHT")
	bar.text_right:SetTextColor(1,1,1,1)
	
	bar.texture:Show()
end

local miniframe_func_on_enter = function(self)
	local bar = self:GetParent()
	if (bar.show and type(bar.show) == "number") then
		local spellname = GetSpellInfo(bar.show)
		if (spellname) then
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetHyperlink("spell:"..bar.show)
			GameTooltip:Show()
		end
	end
	bar:GetScript("OnEnter")(bar)
end

local miniframe_func_on_leave = function(self)
	GameTooltip:Hide()
	self:GetParent():GetScript("OnLeave")(self:GetParent())
end

local target_on_enter = function(self)

	local bar = self:GetParent():GetParent()
	
	if (bar.show and type(bar.show) == "number") then
		local actor = bar.other_actor or info.player
		local spell = actor.spell_tables:CatchSpell(bar.show)
		if (spell) then
			local ActorTargetsContainer = spell.targets._ActorTable
			local ActorTargetsSortTable = {}
			--add and sort
			for _, _target in _ipairs(ActorTargetsContainer) do
				ActorTargetsSortTable[#ActorTargetsSortTable+1] = {_target.name, _target[info.target_member] or _target.total or 0}
			end
			table.sort(ActorTargetsSortTable, _details.Sort2)
			
			local spellname = _GetSpellInfo(bar.show)
			
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:AddLine(bar.index .. ". " .. spellname)
			GameTooltip:AddLine(info.target_text)
			GameTooltip:AddLine(" ")
			
			--get time type
			local mine_time
			if (_details.time_type == 1 or not actor.group) then
				mine_time = actor:Time()
			elseif (_details.time_type == 2) then
				mine_time = info.instance.showing:GetCombatTime()
			end
			
			for index, target in ipairs(ActorTargetsSortTable) do 
				if (target[2] > 0) then
					local class = _details:GetClass(target[1])
					if (class and _details.class_coords[class]) then
						local cords = _details.class_coords[class]
						if (info.target_persecond) then
							GameTooltip:AddDoubleLine(index .. ". |TInterface\\AddOns\\Details\\images\\classes_small_alpha:14:14:0:0:128:128:"..cords[1]*128 ..":"..cords[2]*128 ..":"..cords[3]*128 ..":"..cords[4]*128 .."|t " .. target[1], _details:comma_value( _math_floor(target[2] / mine_time) ), 1, 1, 1, 1, 1, 1)
						else
							GameTooltip:AddDoubleLine(index .. ". |TInterface\\AddOns\\Details\\images\\classes_small_alpha:14:14:0:0:128:128:"..cords[1]*128 ..":"..cords[2]*128 ..":"..cords[3]*128 ..":"..cords[4]*128 .."|t " .. target[1], _details:comma_value(target[2]), 1, 1, 1, 1, 1, 1)
						end
					else
						if (info.target_persecond) then
							GameTooltip:AddDoubleLine(index .. ". " .. target[1], _details:comma_value( _math_floor(target[2] / mine_time)), 1, 1, 1, 1, 1, 1)
						else
							GameTooltip:AddDoubleLine(index .. ". " .. target[1], _details:comma_value(target[2]), 1, 1, 1, 1, 1, 1)
						end
					end
				end
			end
			
			GameTooltip:Show()
		else
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:AddLine(bar.index .. ". " .. bar.show)
			GameTooltip:AddLine(info.target_text)
			GameTooltip:AddLine(Loc["STRING_NO_TARGET"], 1, 1, 1)
			GameTooltip:AddLine(Loc["STRING_MORE_INFO"], 1, 1, 1)
			GameTooltip:Show()
		end
	else
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:AddLine(bar.index .. ". " .. bar.show)
		GameTooltip:AddLine(info.target_text)
		GameTooltip:AddLine(Loc["STRING_NO_TARGET"], 1, 1, 1)
		GameTooltip:AddLine(Loc["STRING_MORE_INFO"], 1, 1, 1)
		GameTooltip:Show()
	end
	
	self.texture:SetAlpha(1)
	self:SetAlpha(1)
	bar:GetScript("OnEnter")(bar)
end

local target_on_leave = function(self)
	GameTooltip:Hide()
	self:GetParent():GetParent():GetScript("OnLeave")(self:GetParent():GetParent())
	self.texture:SetAlpha(.7)
	self:SetAlpha(.7)
end

function gump:CreateNewBarInfo1(instance, index)

	if (_details.window_info.bars1[index]) then
		print("erro a bar "..index.." ja existe na window de details...")
		return
	end

	local window = info.container_bars.gump

	local this_bar = _CreateFrame("Button", "Details_infobox1_bar_"..index, info.container_bars.gump)
	this_bar:SetWidth(300) --> tamanho da bar de acordo com o tamanho da window
	this_bar:SetHeight(16) --> altura determinada pela instância
	this_bar.index = index

	local y =(index-1)*17 --> 17 é a altura da bar
	y = y*-1 --> baixo
	
	this_bar:SetPoint("LEFT", window, "LEFT")
	this_bar:SetPoint("RIGHT", window, "RIGHT")
	this_bar:SetPoint("TOP", window, "TOP", 0, y)
	this_bar:SetFrameLevel(window:GetFrameLevel() + 1)

	this_bar:EnableMouse(true)
	this_bar:RegisterForClicks("LeftButtonDown","RightButtonUp")	
	
	this_bar.targets = CreateFrame("frame", "Details_infobox1_bar_"..index.."Targets", this_bar)
	this_bar.targets:SetPoint("right", this_bar, "right")
	this_bar.targets:SetSize(15, 15)
	this_bar.targets.texture = this_bar.targets:CreateTexture(nil, overlay)
	this_bar.targets.texture:SetTexture([[Interface\AddOns\Details\images\Target]])
	this_bar.targets.texture:SetAllPoints()
	this_bar.targets.texture:SetDesaturated(true)
	this_bar.targets:SetAlpha(.7)
	this_bar.targets.texture:SetAlpha(.7)
	this_bar.targets:SetScript("OnEnter", target_on_enter)
	this_bar.targets:SetScript("OnLeave", target_on_leave)
	
	CreateTexturaBar(instance, this_bar)
	
	--> icon
	this_bar.miniframe = CreateFrame("frame", nil, this_bar)
	this_bar.miniframe:SetSize(14, 14)
	this_bar.miniframe:SetPoint("RIGHT", this_bar.texture, "LEFT", 20, 0)
	
	this_bar.miniframe:SetScript("OnEnter", miniframe_func_on_enter)
	this_bar.miniframe:SetScript("OnLeave", miniframe_func_on_leave)
	
	this_bar.icon = this_bar.texture:CreateTexture(nil, "OVERLAY")
	this_bar.icon:SetWidth(14)
	this_bar.icon:SetHeight(14)
	this_bar.icon:SetPoint("RIGHT", this_bar.texture, "LEFT", 20, 0)
	
	this_bar:SetAlpha(0.9)
	this_bar.icon:SetAlpha(0.8)
	
	this_bar.isMain = true
	
	SetBarScripts(this_bar, instance, index)
	
	info.bars1[index] = this_bar --> bar adicionada
	
	this_bar.texture:SetStatusBarColor(1, 1, 1, 1) --> isso aqui é a parte da seleção e desceleção
	this_bar.on_focus = false --> isso aqui é a parte da seleção e desceleção
	
	return this_bar
end

function gump:CreateNewBarInfo2(instance, index)

	if (_details.window_info.bars2[index]) then
		print("erro a bar "..index.." ja existe na window de details...")
		return
	end
	
	local window = info.container_targets.gump

	local this_bar = _CreateFrame("Button", "Details_infobox2_bar_"..index, info.container_targets.gump)
	this_bar:SetWidth(300) --> tamanho da bar de acordo com o tamanho da window
	this_bar:SetHeight(16) --> altura determinada pela instância

	local y =(index-1)*17 --> 17 é a altura da bar
	y = y*-1 --> baixo
	
	this_bar:SetPoint("LEFT", window, "LEFT")
	this_bar:SetPoint("RIGHT", window, "RIGHT")
	this_bar:SetPoint("TOP", window, "TOP", 0, y)
	this_bar:SetFrameLevel(window:GetFrameLevel() + 1)

	this_bar:EnableMouse(true)
	this_bar:RegisterForClicks("LeftButtonDown","RightButtonUp")	
	
	CreateTexturaBar(instance, this_bar)

	--> icon
	this_bar.icon = this_bar.texture:CreateTexture(nil, "OVERLAY")
	this_bar.icon:SetWidth(14)
	this_bar.icon:SetHeight(14)
	this_bar.icon:SetPoint("RIGHT", this_bar.texture, "LEFT", 0+20, 0)
	
	this_bar:SetAlpha(0.9)
	this_bar.icon:SetAlpha(0.8)
	
	this_bar.isTarget = true
	
	SetBarScripts(this_bar, instance, index)
	
	info.bars2[index] = this_bar --> bar adicionada
	
	return this_bar
end

local x_start = 62
local y_start = -10

function gump:CreateNewBarInfo3(instance, index)

	if (_details.window_info.bars3[index]) then
		print("erro a bar "..index.." ja existe na window de details...")
		return
	end

	local window = info.container_details

	local this_bar = CreateFrame("Button", "Details_infobox3_bar_"..index, window)
	this_bar:SetWidth(220) --> tamanho da bar de acordo com o tamanho da window
	this_bar:SetHeight(16) --> altura determinada pela instância
	
	local y =(index-1)*17 --> 17 é a altura da bar
	y = y*-1 --> baixo	
	
	this_bar:SetPoint("LEFT", window, "LEFT", x_start, 0)
	this_bar:SetPoint("RIGHT", window, "RIGHT", 59, 0)
	this_bar:SetPoint("TOP", window, "TOP", 0, y+y_start)
	
	this_bar:EnableMouse(true)
	
	CreateTexturaBar(instance, this_bar)

	--> icon
	this_bar.icon = this_bar.texture:CreateTexture(nil, "OVERLAY")
	this_bar.icon:SetWidth(14)
	this_bar.icon:SetHeight(14)
	this_bar.icon:SetPoint("RIGHT", this_bar.texture, "LEFT", 0+20, 0)
	
	this_bar:SetAlpha(0.9)
	this_bar.icon:SetAlpha(0.8)
	
	this_bar.isDetail = true
		
	SetBarScripts(this_bar, instance, index)
	
	info.bars3[index] = this_bar --> bar adicionada
	
	return this_bar
end
