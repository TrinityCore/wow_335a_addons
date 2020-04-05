
--note: this file need a major clean up especially on function creation.

local _details = 		_G._details
local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
local _
local gump = 			_details.gump
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local attributes = _details.attributes
local sub_attributes = _details.sub_attributes
local segments = _details.segments

--lua locals
local _cstr = tostring
local _math_ceil = math.ceil
local _math_floor = math.floor
local _ipairs = ipairs
local _pairs = pairs
local _string_lower = string.lower
local _unpack = unpack
--api locals
local CreateFrame = CreateFrame
local _GetTime = GetTime
local _GetCursorPosition = GetCursorPosition
local _GameTooltip = GameTooltip
local _UIParent = UIParent
local _GetScreenWidth = GetScreenWidth
local _GetScreenHeight = GetScreenHeight
local _IsAltKeyDown = IsAltKeyDown
local _IsShiftKeyDown = IsShiftKeyDown
local _IsControlKeyDown = IsControlKeyDown
local mode_raid = _details._details_props["MODE_RAID"]
local mode_alone = _details._details_props["MODE_ALONE"]
local mode_group = _details._details_props["MODE_GROUP"]
local mode_all = _details._details_props["MODE_ALL"]

--constants
local baseframe_strata = "LOW"
local gump_fundo_backdrop = {
	bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
	insets = {left = 0, right = 0, top = 0, bottom = 0}}


function  _details:ScheduleUpdate(instance)
	instance.barS = {nil, nil}
	instance.update = true
	if (instance.showing) then
		instance.attribute = instance.attribute or 1
		
		if (not instance.showing[instance.attribute]) then --> unknow very rare bug where showing transforms into a clean table
			instance.showing = _details.table_current
		end
		
		instance.showing[instance.attribute].need_refresh = true
	end
end

--> skins TCoords

--	0.00048828125
	
	local DEFAULT_SKIN =[[Interface\AddOns\Details\images\skins\classic_skin]]
	
	--local COORDS_LEFT_BALL = {0.15673828125, 0.27978515625, 0.08251953125, 0.20556640625} -- 160 84 287 211(updated)
	--160 84 287 211
	local COORDS_LEFT_BALL = {0.15576171875, 0.27978515625, 0.08251953125, 0.20556640625} -- 160 84 287 211(updated)
	
	local COORDS_LEFT_CONNECTOR = {0.29541015625, 0.30126953125, 0.08251953125, 0.20556640625} --302 84 309 211(updated)
	local COORDS_LEFT_CONNECTOR_NO_ICON = {0.58837890625, 0.59423828125, 0.08251953125, 0.20556640625} -- 602 84 609 211(updated)
	local COORDS_TOP_BACKGROUND = {0.15673828125, 0.65478515625, 0.22314453125, 0.34619140625} -- 160 228 671 355(updated)
	
	--local COORDS_RIGHT_BALL = {0.31591796875, 0.43994140625, 0.08251953125, 0.20556640625} --324 84 451 211(updated)
	local COORDS_RIGHT_BALL = {0.3154296875+0.00048828125, 0.439453125+0.00048828125, 0.08203125, 0.2060546875-0.00048828125} --323 84 450 211(updated)
	
	--local COORDS_LEFT_BALL_NO_ICON = {0.44970703125, 0.57275390625, 0.08251953125, 0.20556640625} --460 84 587 211(updated)
	local COORDS_LEFT_BALL_NO_ICON = {0.44970703125, 0.57275390625, 0.08251953125, 0.20556640625} --460 84 587 211(updated) 588 212

	local COORDS_LEFT_SIDE_BAR = {0.76611328125, 0.82763671875, 0.00244140625, 0.50146484375} -- 784 2 848 514(updated)
	--local COORDS_LEFT_SIDE_BAR = {0.76611328125, 0.82666015625, 0.00244140625, 0.50048828125} -- 784 2 848 514(updated)
	--local COORDS_LEFT_SIDE_BAR = {0.765625, 0.8291015625, 0.00244140625, 0.5029296875} -- 784 2 848 514(updated)
	--784 2 847 513
	
	--local COORDS_RIGHT_SIDE_BAR = {0.70068359375, 0.76220703125, 0.00244140625, 0.50146484375} -- 717 2 781 514(updated)
	--local COORDS_RIGHT_SIDE_BAR = {0.7001953125, 0.763671875, 0.00244140625, 0.50146484375} -- 717 2 781 514(updated)
	local COORDS_RIGHT_SIDE_BAR = {0.7001953125+0.00048828125, 0.76171875, 0.001953125, 0.5009765625} -- --717 2 780 513
	
	local COORDS_BOTTOM_SIDE_BAR = {0.32861328125, 0.82666015625, 0.50537109375, 0.56494140625} -- 336 517 847 579(updated)
	
	local COORDS_SLIDER_TOP = {0.00146484375, 0.03076171875, 0.00244140625, 0.03173828125} -- 1 2 32 33 -ok
	local COORDS_SLIDER_MIDDLE = {0.00146484375, 0.03076171875, 0.03955078125, 0.10009765625} -- 1 40 32 103 -ok
	local COORDS_SLIDER_DOWN = {0.00146484375, 0.03076171875, 0.10986328125, 0.13916015625} -- 1 112 32 143 -ok

	local COORDS_STRETCH = {0.00146484375, 0.03076171875, 0.21435546875, 0.22802734375} -- 1 219 32 234 -ok
	local COORDS_RESIZE_RIGHT = {0.00146484375, 0.01513671875, 0.24560546875, 0.25927734375} -- 1 251 16 266 -ok
	local COORDS_RESIZE_LEFT = {0.02001953125, 0.03173828125, 0.24560546875, 0.25927734375} -- 20 251 33 266 -ok
	
	local COORDS_UNLOCK_BUTTON = {0.00146484375, 0.01513671875, 0.27197265625, 0.28564453125} -- 1 278 16 293 -ok
	
	local COORDS_BOTTOM_BACKGROUND = {0.15673828125, 0.65478515625, 0.35400390625, 0.47705078125} -- 160 362 671 489 -ok
	local COORDS_PIN_LEFT = {0.00146484375, 0.03076171875, 0.30126953125, 0.33056640625} -- 1 308 32 339 -ok
	local COORDS_PIN_RIGHT = {0.03564453125, 0.06494140625, 0.30126953125, 0.33056640625} -- 36 308 67 339 -ok
	
	-- icons: 365 = 0.35693359375 // 397 = 0.38720703125
	
function _details:ActualizeScrollBar(x)

	local cabe = self.rows_fit_in_window --> quantas bars cabem na window

	if (not self.barS[1]) then --primeira vez que as bars estão aparecendo
		self.barS[1] = 1 --primeira bar
		if (cabe < x) then --se a amount a ser mostrada for maior que o que pode ser mostrado
			self.barS[2] = cabe -- B = o que pode ser mostrado
		else
			self.barS[2] = x -- contrário B = o que this sendo mostrado
		end
	end
	
	if (not self.scrolling) then
		if (x > cabe) then --> Ligar a ScrollBar
			self.rows_showing = x
			
			if (not self.baseframe.isStretching) then
				self:MostrarScrollBar()
			end
			self.need_scrolling = true
			
			self.barS[2] = cabe --> B é o total que cabe na bar
		else --> Do contrário B é o total de bars
			self.rows_showing = x
			self.barS[2] = x
		end
	else
		if (x > self.rows_showing) then --> tem mais bars showing agora do que na última atualização
			self.rows_showing = x
			local nao_mostradas = self.rows_showing - self.rows_fit_in_window
			local slider_height = nao_mostradas*self.row_height
			self.scroll.scrollMax = slider_height
			self.scroll:SetMinMaxValues(0, slider_height)
			
		else	--> diminuiu a amount, acontece depois de uma collect de lixo
			self.rows_showing = x
			local nao_mostradas = self.rows_showing - self.rows_fit_in_window
			
			if (nao_mostradas < 1) then  --> se estiver showing menos do que realmente cabe não precisa scrollbar
				self:HideScrollBar()
			else
				--> contrário, basta atualizar o tamanho da scroll
				local slider_height = nao_mostradas*self.row_height
				self.scroll.scrollMax = slider_height
				self.scroll:SetMinMaxValues(0, slider_height)
			end
			
		end
	end
	
	if (self.update) then 
		self.update = false
		self.v_bars = true
		return _details:HideBarsNotUsed(self)
	end
end

--> self é a window das bars
local function move_bars(self, elapsed)
	self._move_func.time = self._move_func.time+elapsed
	if (self._move_func.time > 0.01) then
		if (self._move_func.instance.bgdisplay_loc == self._move_func._end) then --> se o tamanho atual é igual ao final declarado
			self:SetScript("OnUpdate", nil)
			self._move_func = nil
		else
			self._move_func.time = 0
			self._move_func.instance.bgdisplay_loc = self._move_func.instance.bgdisplay_loc + self._move_func.inc --> inc é -1 ou 1 e irá crescer ou diminuir a window
			
			for index = 1, self._move_func.instance.rows_fit_in_window do
				self._move_func.instance.bars[index]:SetWidth(self:GetWidth()+self._move_func.instance.bgdisplay_loc-3)
			end
			self._move_func.instance.bgdisplay:SetPoint("bottomright", self, "bottomright", self._move_func.instance.bgdisplay_loc, 0)
			
			self._move_func.instance.bar_mod = self._move_func.instance.bgdisplay_loc+(-3)
			
			--> verifica o tamanho do text
			for i  = 1, #self._move_func.instance.bars do
				local this_bar = self._move_func.instance.bars[i]
				_details:name_space(this_bar)
			end
		end
	end
end

--> self é a instância
function _details:MoveBarsTo(destino)
	local window = self.baseframe

	window._move_func = {
		window = self.baseframe,
		instance = self,
		time = 0
	}
	
	if (destino > self.bgdisplay_loc) then
		window._move_func.inc = 1
	else
		window._move_func.inc = -1
	end
	window._move_func._end = destino
	window:SetScript("OnUpdate", move_bars)
end

function _details:MostrarScrollBar(sem_animation)

	if (self.scrolling) then
		return
	end
	
	if (not _details.use_scroll) then
		self.baseframe:EnableMouseWheel(true)
		self.scroll:Enable()
		self.scroll:SetValue(0)
		self.scrolling = true
		return
	end

	local main = self.baseframe
	local mover_para = self.width_scroll*-1
	
	if (not sem_animation and _details.animate_scroll) then
		self:MoveBarsTo(mover_para)
	else
		--> set size of rows
		for index = 1, self.rows_fit_in_window do
			self.bars[index]:SetWidth(self.baseframe:GetWidth()+mover_para -3) --> -3 distance between row end and scroll start
		end
		--> move the semi-background to the left(which moves the scroll)
		self.bgdisplay:SetPoint("bottomright", self.baseframe, "bottomright", mover_para, 0)
		
		self.bar_mod = mover_para +(-3)
		self.bgdisplay_loc = mover_para
		
		--> cancel movement if any
		if (self.baseframe:GetScript("OnUpdate") and self.baseframe:GetScript("OnUpdate") == move_bars) then
			self.baseframe:SetScript("OnUpdate", nil)
		end
	end
	
	local nao_mostradas = self.rows_showing - self.rows_fit_in_window
	local slider_height = nao_mostradas*self.row_height
	self.scroll.scrollMax = slider_height
	self.scroll:SetMinMaxValues(0, slider_height)
	
	self.scrolling = true
	self.scroll:Enable()
	main:EnableMouseWheel(true)

	self.scroll:SetValue(0) --> set value pode chamar o atualizador
	self.baseframe.button_down:Enable()
	main.resize_right:SetPoint("bottomright", main, "bottomright", self.width_scroll*-1, 0)
	
	if (main.isLocked) then
		main.lock_button:SetPoint("bottomright", main, "bottomright", self.width_scroll*-1, 0)
	end

end

function _details:HideScrollBar(sem_animation, force)

	if (not self.scrolling) then
		return
	end
	
	if (not _details.use_scroll and not force) then
		self.scroll:Disable()
		self.baseframe:EnableMouseWheel(false)
		self.scrolling = false
		return
	end
	
	local main = self.baseframe

	if (not sem_animation and _details.animate_scroll) then
		self:MoveBarsTo(self.row_info.space.right + 3) --> 
	else
		for index = 1, self.rows_fit_in_window do
			self.bars[index]:SetWidth(self.baseframe:GetWidth() - 5) --> -5 space between row end and window right border
		end
		self.bgdisplay:SetPoint("bottomright", self.baseframe, "bottomright", 0, 0) -- voltar o background na pocição inicial
		self.bar_mod = 0 -- zera o bar mod, uma vez que as bars vão thisr na pocisão inicial
		self.bgdisplay_loc = -2
		if (self.baseframe:GetScript("OnUpdate") and self.baseframe:GetScript("OnUpdate") == move_bars) then
			self.baseframe:SetScript("OnUpdate", nil)
		end
	end

	self.scrolling = false
	self.scroll:Disable()
	main:EnableMouseWheel(false)
	
	main.resize_right:SetPoint("bottomright", main, "bottomright", 0, 0)
	if (main.isLocked) then
		main.lock_button:SetPoint("bottomright", main, "bottomright", 0, 0)
	end
end

local function OnLeaveMainWindow(instance, self)

	instance.is_interacting = false
	instance:SetMenuAlpha(nil, nil, nil, nil, true)
	instance:SetAutoHideMenu(nil, nil, true)
	
	if (instance.mode ~= _details._details_props["MODE_ALONE"] and not instance.baseframe.isLocked) then

		--> resizes and lock button
		instance.baseframe.resize_right:SetAlpha(0)
		instance.baseframe.resize_left:SetAlpha(0)
		instance.baseframe.lock_button:SetAlpha(0)
		instance.break_snap_button:SetAlpha(0)
		
		--> stretch button
		--gump:Fade(instance.baseframe.button_stretch, -1)
		gump:Fade(instance.baseframe.button_stretch, "ALPHA", 0)
	
	elseif (instance.mode ~= _details._details_props["MODE_ALONE"] and instance.baseframe.isLocked) then
		instance.baseframe.lock_button:SetAlpha(0)
		gump:Fade(instance.baseframe.button_stretch, "ALPHA", 0)
		instance.break_snap_button:SetAlpha(0)

	end
end
_details.OnLeaveMainWindow = OnLeaveMainWindow

local function OnEnterMainWindow(instance, self)

	instance.is_interacting = true
	instance:SetMenuAlpha(nil, nil, nil, nil, true)
	instance:SetAutoHideMenu(nil, nil, true)

	if (instance.baseframe:GetFrameLevel() > instance.rowframe:GetFrameLevel()) then
		instance.rowframe:SetFrameLevel(instance.baseframe:GetFrameLevel())
	end
	
	if (instance.mode ~= _details._details_props["MODE_ALONE"] and not instance.baseframe.isLocked) then

		--> resizes and lock button
		instance.baseframe.resize_right:SetAlpha(1)
		instance.baseframe.resize_left:SetAlpha(1)
		instance.baseframe.lock_button:SetAlpha(1)
		
		--> stretch button
		gump:Fade(instance.baseframe.button_stretch, "ALPHA", 0.6)
	
		--> snaps
		for _, instance_id in _pairs(instance.snap) do
			if (instance_id) then
				instance.break_snap_button:SetAlpha(1)
				break
			end
		end
		
	elseif (instance.mode ~= _details._details_props["MODE_ALONE"] and instance.baseframe.isLocked) then
		instance.baseframe.lock_button:SetAlpha(1)
		gump:Fade(instance.baseframe.button_stretch, "ALPHA", 0.6)
		
		--> snaps
		for _, instance_id in _pairs(instance.snap) do
			if (instance_id) then
				instance.break_snap_button:SetAlpha(1)
				break
			end
		end
	
	end
end
_details.OnEnterMainWindow = OnEnterMainWindow

local function VPL(instance, this_instance)
	--> conferir left
	if (instance.ponto4.x < this_instance.ponto1.x) then --> a window this a left
		if (instance.ponto4.x+20 > this_instance.ponto1.x) then --> a window this a menos de 20 pixels de distância
			if (instance.ponto4.y < this_instance.ponto1.y + 100 and instance.ponto4.y > this_instance.ponto1.y - 100) then --> a window this a +20 ou -20 pixels de distância na vertical
				return 1
			end
		end
	end
	return nil
end

local function VPB(instance, this_instance)
	--> conferir baixo
	if (instance.ponto1.y+(20 * instance.window_scale) < this_instance.ponto2.y -(16 * this_instance.window_scale)) then --> a window this em baixo
		if (instance.ponto1.x > this_instance.ponto2.x-100 and instance.ponto1.x < this_instance.ponto2.x+100) then --> a window this a 20 pixels de distância para a left ou para a right
			if (instance.ponto1.y+(20 * instance.window_scale) > this_instance.ponto2.y -(36 * this_instance.window_scale)) then --> this a 20 pixels de distância
				return 2
			end
		end
	end
	return nil
end

local function VPR(instance, this_instance)
	--> conferir lateral right
	if (instance.ponto2.x > this_instance.ponto3.x) then --> a window this a right
		if (instance.ponto2.x-20 < this_instance.ponto3.x) then --> a window this a menos de 20 pixels de distância
			if (instance.ponto2.y < this_instance.ponto3.y + 100 and instance.ponto2.y > this_instance.ponto3.y - 100) then --> a window this a +20 ou -20 pixels de distância na vertical
				return 3
			end
		end
	end
	return nil
end

local function VPT(instance, this_instance)
	--> conferir cima
	if (instance.ponto3.y -(16 * instance.window_scale) > this_instance.ponto4.y +(20 * this_instance.window_scale)) then --> a window this em cima
		if (instance.ponto3.x > this_instance.ponto4.x-100 and instance.ponto3.x < this_instance.ponto4.x+100) then --> a window this a 20 pixels de distância para a left ou para a right
			if (this_instance.ponto4.y+(40 * this_instance.window_scale) > instance.ponto3.y -(16 * instance.window_scale)) then
				return 4
			end
		end
	end
	return nil
end

local color_red = {1, 0.2, 0.2}
local color_green = {0.2, 1, 0.2}

local update_line = function(self, target_frame)

	--> based on weak auras frame movement code
	--local selfX, selfY = target_frame:GetCenter()
	local selfX, selfY = target_frame.instance:GetPositionOnScreen()
	--local anchorX, anchorY = self:GetCenter()
	local anchorX, anchorY = self.instance:GetPositionOnScreen()
	
	selfX, selfY = selfX or 0, selfY or 0
	anchorX, anchorY = anchorX or 0, anchorY or 0
	
	local dX = selfX - anchorX
	local dY = selfY - anchorY
	local distance = sqrt(dX^2 + dY^2)

	local angle = atan2(dY, dX)
	local numInterim = floor(distance/40)
    
	local guide_balls = _details.guide_balls
	if (not guide_balls) then
		_details.guide_balls = {}
		guide_balls = _details.guide_balls
	end
    
	for index, ball in ipairs(guide_balls) do
		ball:Hide()
	end
	
	self.instance:UpdatePontos()
	target_frame.instance:UpdatePontos()
	
	local color = color_red
	local _R, _T, _L, _B = VPL(self.instance, target_frame.instance), VPB(self.instance, target_frame.instance), VPR(self.instance, target_frame.instance), VPT(self.instance, target_frame.instance)
	if (_R or _T or _L or _B) then
		color = color_green
	end

	for i = 0, numInterim do
		local x =(distance -(i * 40)) * cos(angle)
		local y =(distance -(i * 40)) * sin(angle)

		local ball = guide_balls[i]
		if (not ball) then
			ball = _details.overlay_frame:CreateTexture(nil, "Overlay")
			ball:SetTexture([[Interface\AddOns\Details\images\icons]])
			ball:SetSize(16, 16)
			ball:SetAlpha(0.3)
			ball:SetTexCoord(410/512, 426/512, 2/512, 18/512)
			tinsert(guide_balls, ball)
		end
		
		ball:ClearAllPoints()
		ball:SetPoint("CENTER", self, "CENTER", x, y) --baseframse center
		ball:Show()
		ball:SetVertexColor(unpack(color))
	end

end

local time_movendo, precisa_activer, instance_dst, time_fades, nao_anexados, flash_bounce, start_draw_lines
local movement_onupdate = function(self, elapsed) 

				if (start_draw_lines and start_draw_lines > 0.95) then
					update_line(self, instance_dst.baseframe)
				elseif (start_draw_lines) then
					start_draw_lines = start_draw_lines + elapsed
				end

				if (time_movendo and time_movendo < 0) then

					if (precisa_activer) then --> se a instância estiver closeda
						gump:Fade(instance_dst.baseframe, "ALPHA", 0.2)
						gump:Fade(instance_dst.baseframe.header.ball, "ALPHA", 0.2)
						gump:Fade(instance_dst.baseframe.header.attribute_icon, "ALPHA", 0.2)
						instance_dst:SaveMainWindowPosition()
						instance_dst:RestoreMainWindowPosition()
						precisa_activer = false
						
					elseif (time_fades) then
					
						if (flash_bounce == 0) then
						
							flash_bounce = 1

							local has_livre = false
							
							for side, livre in _ipairs(nao_anexados) do
								if (livre) then
									if (side == 1) then

										local texture = instance_dst.h_left.texture
										texture:ClearAllPoints()
										
										if (instance_dst.toolbar_side == 1) then
											if (instance_dst.show_statusbar) then
												texture:SetPoint("topright", instance_dst.baseframe, "topleft", 0, 20)
												texture:SetPoint("bottomright", instance_dst.baseframe, "bottomleft", 0, -14)
											else
												texture:SetPoint("topright", instance_dst.baseframe, "topleft", 0, 20)
												texture:SetPoint("bottomright", instance_dst.baseframe, "bottomleft", 0, 0)
											end
										else
											if (instance_dst.show_statusbar) then
												texture:SetPoint("topright", instance_dst.baseframe, "topleft", 0, 0)
												texture:SetPoint("bottomright", instance_dst.baseframe, "bottomleft", 0, -34)
											else
												texture:SetPoint("topright", instance_dst.baseframe, "topleft", 0, 0)
												texture:SetPoint("bottomright", instance_dst.baseframe, "bottomleft", 0, -20)
											end
										end
									
										instance_dst.h_left:Flash(1, 1, 2.0, false, 0, 0)
										has_livre = true
										
									elseif (side == 2) then
									
										local texture = instance_dst.h_baixo.texture
										texture:ClearAllPoints()
									
										if (instance_dst.toolbar_side == 1) then
											if (instance_dst.show_statusbar) then
												texture:SetPoint("topleft", instance_dst.baseframe, "bottomleft", 0, -14)
												texture:SetPoint("topright", instance_dst.baseframe, "bottomright", 0, -14)
											else
												texture:SetPoint("topleft", instance_dst.baseframe, "bottomleft", 0, 0)
												texture:SetPoint("topright", instance_dst.baseframe, "bottomright", 0, 0)
											end
										else
											if (instance_dst.show_statusbar) then
												texture:SetPoint("topleft", instance_dst.baseframe, "bottomleft", 0, -34)
												texture:SetPoint("topright", instance_dst.baseframe, "bottomright", 0, -34)
											else
												texture:SetPoint("topleft", instance_dst.baseframe, "bottomleft", 0, -20)
												texture:SetPoint("topright", instance_dst.baseframe, "bottomright", 0, -20)
											end
										end
									
										instance_dst.h_baixo:Flash(1, 1, 2.0, false, 0, 0)
										has_livre = true
										
									elseif (side == 3) then
									
										local texture = instance_dst.h_right.texture
										texture:ClearAllPoints()
										
										if (instance_dst.toolbar_side == 1) then
											if (instance_dst.show_statusbar) then
												texture:SetPoint("topleft", instance_dst.baseframe, "topright", 0, 20)
												texture:SetPoint("bottomleft", instance_dst.baseframe, "bottomright", 0, -14)
											else
												texture:SetPoint("topleft", instance_dst.baseframe, "topright", 0, 20)
												texture:SetPoint("bottomleft", instance_dst.baseframe, "bottomright", 0, 0)
											end
										else
											if (instance_dst.show_statusbar) then
												texture:SetPoint("topleft", instance_dst.baseframe, "topright", 0, 0)
												texture:SetPoint("bottomleft", instance_dst.baseframe, "bottomright", 0, -34)
											else
												texture:SetPoint("topleft", instance_dst.baseframe, "topright", 0, 0)
												texture:SetPoint("bottomleft", instance_dst.baseframe, "bottomright", 0, -20)
											end
										end
									
										instance_dst.h_right:Flash(1, 1, 2.0, false, 0, 0)
										has_livre = true
										
									elseif (side == 4) then
										
										local texture = instance_dst.h_cima.texture
										texture:ClearAllPoints()
										
										if (instance_dst.toolbar_side == 1) then
											texture:SetPoint("bottomleft", instance_dst.baseframe, "topleft", 0, 20)
											texture:SetPoint("bottomright", instance_dst.baseframe, "topright", 0, 20)
										else
											texture:SetPoint("bottomleft", instance_dst.baseframe, "topleft", 0, 0)
											texture:SetPoint("bottomright", instance_dst.baseframe, "topright", 0, 0)
										end
										
										instance_dst.h_cima:Flash(1, 1, 2.0, false, 0, 0)
										has_livre = true
									end
								end
							end
							
							if (has_livre) then
								if (not _details.snap_alert.playing) then
									instance_dst:SnapAlert()
									_details.snap_alert.playing = true
									
									_details.MicroButtonAlert.Text:SetText(string.format(Loc["STRING_ATACH_DESC"], self.instance.mine_id, instance_dst.mine_id))
									_details.MicroButtonAlert:SetPoint("bottom", instance_dst.baseframe.header.novo, "top", 0, 18)
									_details.MicroButtonAlert:SetHeight(200)
									_details.MicroButtonAlert:Show()
								end
							end
						end
						
						time_movendo = 1
					else
						self:SetScript("OnUpdate", nil)
						time_movendo = 1
					end
					
				else
					time_movendo = time_movendo - elapsed
				end
			end

local function move_window(baseframe, starting, instance)

	instance_dst = _details.table_instances[instance.mine_id-1]
	if (_details.disable_window_groups) then
		instance_dst = nil
	end
	
	if (starting) then
	
		if (baseframe.isMoving) then
			--> ja this em movimento
			return
		end
	
		baseframe.isMoving = true
		instance:BaseFrameSnap()
		baseframe:StartMoving()
		
		local group = instance:GetInstanceGroup()
		for _, this_instance in _ipairs(group) do
			this_instance.baseframe:SetClampRectInsets(0, 0, 0, 0)
			this_instance.isMoving = true
		end
		
		local _, ClampLeft, ClampRight = instance:instancesHorizontais()
		local _, ClampBottom, ClampTop = instance:instancesVerticais()
		
		baseframe:SetClampRectInsets(-ClampLeft, ClampRight, ClampTop, -ClampBottom)

		if (instance_dst) then
		
			time_fades = 1.0
			nao_anexados = {true, true, true, true}
			time_movendo = 1
			flash_bounce = 0

			start_draw_lines = 0
			for side, snap_to in _pairs(instance_dst.snap) do
				if (snap_to == instance.mine_id) then
					start_draw_lines = false
				end
			end
			
			for side, snap_to in _pairs(instance_dst.snap) do
				if (snap_to) then
					if (snap_to == instance.mine_id) then
						time_fades = nil
						break
					end
					nao_anexados[side] = false
				end
			end
			
			for side = 1, 4 do
				if (instance_dst.horizontalSnap and instance.verticalSnap) then
					nao_anexados[side] = false
				elseif (instance_dst.horizontalSnap and side == 2) then
					nao_anexados[side] = false
				elseif (instance_dst.horizontalSnap and side == 4) then
					nao_anexados[side] = false
				elseif (instance_dst.verticalSnap and side == 1) then
					nao_anexados[side] = false
				elseif (instance_dst.verticalSnap and side == 3) then
					nao_anexados[side] = false
				end
			end

			local need_start = not instance_dst.initiated
			precisa_activer = not instance_dst.active
			
			if (need_start) then --> se a instância não tiver sido aberta ainda

				instance_dst:RestoreWindow(instance_dst.mine_id, true)
				if (instance_dst:IsSoloMode()) then
					_details.SoloTables:switch()
				end
				
				instance_dst.active = false
				
				instance_dst:SaveMainWindowPosition()
				instance_dst:RestoreMainWindowPosition()
				
				gump:Fade(instance_dst.baseframe, 1)
				gump:Fade(instance_dst.rowframe, 1)
				gump:Fade(instance_dst.baseframe.header.ball, 1)
				
				need_start = false
			end

			baseframe:SetScript("OnUpdate", movement_onupdate)
		end
		
	else

		baseframe:StopMovingOrSizing()
		baseframe.isMoving = false
		baseframe:SetScript("OnUpdate", nil)
		
		if (_details.guide_balls) then
			for index, ball in ipairs(_details.guide_balls) do
				ball:Hide()
			end
		end
		
		for _, ins in _details:ListInstances() do
			if (ins.baseframe) then
				ins.baseframe:SetUserPlaced(false)
			end
		end
		
		--baseframe:SetClampRectInsets(unpack(_details.window_clamp))

		if (instance_dst) then
		
			instance:UpdatePontos()
			
			local left, baixo, right, cima
			local mine_id = instance.mine_id --> id da instância que this sendo movida
			
			local isVertical = instance_dst.verticalSnap
			local isHorizontal = instance_dst.horizontalSnap
			
			local isSelfVertical = instance.verticalSnap
			local isSelfHorizontal = instance.horizontalSnap
			
			local _R, _T, _L, _B
			
			if (isVertical and not isSelfHorizontal) then
				_T, _B = VPB(instance, instance_dst), VPT(instance, instance_dst)
			elseif (isHorizontal and not isSelfVertical) then
				_R, _L = VPL(instance, instance_dst), VPR(instance, instance_dst)
			elseif (not isVertical and not isHorizontal) then
				_R, _T, _L, _B = VPL(instance, instance_dst), VPB(instance, instance_dst), VPR(instance, instance_dst), VPT(instance, instance_dst)
			end
			
			if (_L) then
				if (not instance:ThisGrouped(instance_dst, _L)) then
					left = instance_dst.mine_id
					instance.horizontalSnap = true
					instance_dst.horizontalSnap = true
				end
			end
			
			if (_B) then
				if (not instance:ThisGrouped(instance_dst, _B)) then
					baixo = instance_dst.mine_id
					instance.verticalSnap = true
					instance_dst.verticalSnap = true
				end
			end
			
			if (_R) then
				if (not instance:ThisGrouped(instance_dst, _R)) then
					right = instance_dst.mine_id
					instance.horizontalSnap = true
					instance_dst.horizontalSnap = true
				end
			end
			
			if (_T) then
				if (not instance:ThisGrouped(instance_dst, _T)) then
					cima = instance_dst.mine_id
					instance.verticalSnap = true
					instance_dst.verticalSnap = true
				end
			end
			
			if (left or baixo or right or cima) then
				instance:agrupar_windows({left, baixo, right, cima})
			end
--aqui
			for _, this_instance in _ipairs(_details.table_instances) do
				if (not this_instance:IsActive() and this_instance.initiated) then
					this_instance:ResetGump()
					gump:Fade(this_instance.baseframe, "in", 0.2)
					gump:Fade(this_instance.baseframe.header.ball, "in", 0.2)
					gump:Fade(this_instance.baseframe.header.attribute_icon, "in", 0.2)
					
					if (this_instance.mode == mode_raid) then
						_details.raid = nil
					elseif (this_instance.mode == mode_alone) then
						_details.SoloTables:switch()
						_details.solo = nil
					end

				elseif (this_instance:IsActive()) then
					this_instance:SaveMainWindowPosition()
					this_instance:RestoreMainWindowPosition()
				end
			end

		end

		--> salva pos de todas as windows
		for _, ins in _ipairs(_details.table_instances) do
			if (ins:IsEnabled()) then
				ins:SaveMainWindowPosition()
				ins:RestoreMainWindowPosition()
			end
		end
		
		local group = instance:GetInstanceGroup()
		for _, this_instance in _ipairs(group) do
			this_instance.isMoving = false
		end
		
		_details.snap_alert.playing = false
		--_details.snap_alert.animIn:Stop()
		--_details.snap_alert.animOut:Play()
		_details.MicroButtonAlert:Hide()

		if (instance_dst) then
			instance_dst.h_left:Stop()
			instance_dst.h_baixo:Stop()
			instance_dst.h_right:Stop()
			instance_dst.h_cima:Stop()
		end
		
	end
end
_details.move_window_func = move_window

local BGFrame_scripts_onenter = function(self)
	OnEnterMainWindow(self._instance, self)
end

local BGFrame_scripts_onleave = function(self)
	OnLeaveMainWindow(self._instance, self)
end

local BGFrame_scripts_onmousedown = function(self, button)
	if (self._instance.baseframe.isMoving) then
		move_window(self._instance.baseframe, false, self._instance)
		self._instance:SaveMainWindowPosition()
		return
	end
	
	if (not self._instance.baseframe.isLocked and button == "LeftButton") then
		move_window(self._instance.baseframe, true, self._instance)
		if (self.is_toolbar) then
			if (self._instance.attribute_text.enabled and self._instance.attribute_text.side == 1 and self._instance.toolbar_side == 1) then
				self._instance.menu_attribute_string:SetPoint("bottomleft", self._instance.baseframe.header.ball, "bottomright", self._instance.attribute_text.anchor[1]+1, self._instance.attribute_text.anchor[2]-1)
			end
		end
	elseif (button == "RightButton") then
		if (_details.switch.current_instance and _details.switch.current_instance == self._instance) then
			_details.switch:CloseMe()
		else
			_details.switch:ShowMe(self._instance)
		end
	end
end

local BGFrame_scripts_onmouseup = function(self, button)
	if (self._instance.baseframe.isMoving) then
		move_window(self._instance.baseframe, false, self._instance) --> novo movedor da window
		self._instance:SaveMainWindowPosition()
		if (self.is_toolbar) then
			if (self._instance.attribute_text.enabled and self._instance.attribute_text.side == 1 and self._instance.toolbar_side == 1) then
				self._instance.menu_attribute_string:SetPoint("bottomleft", self._instance.baseframe.header.ball, "bottomright", self._instance.attribute_text.anchor[1], self._instance.attribute_text.anchor[2])
			end
		end
	end
end

local function BGFrame_scripts(BG, baseframe, instance)
	BG._instance = instance
	BG:SetScript("OnEnter", BGFrame_scripts_onenter)
	BG:SetScript("OnLeave", BGFrame_scripts_onleave)
	BG:SetScript("OnMouseDown", BGFrame_scripts_onmousedown)
	BG:SetScript("OnMouseUp", BGFrame_scripts_onmouseup)
end

function gump:RegisterForDetailsMove(frame, instance)

	frame:SetScript("OnMouseDown", function(frame, button)
		if (not instance.baseframe.isLocked and button == "LeftButton") then
			move_window(instance.baseframe, true, instance) --> novo movedor da window
		end
	end)

	frame:SetScript("OnMouseUp", function(frame)
		if (instance.baseframe.isMoving) then
			move_window(instance.baseframe, false, instance) --> novo movedor da window
			instance:SaveMainWindowPosition()
		end
	end)	
end

--> scripts do base frame
local BFrame_scripts_onsizechange = function(self)
	self._instance:SaveMainWindowPosition()
	self._instance:ReadjustGump()
	self._instance.oldwith = self:GetWidth()
	_details:SendEvent("DETAILS_INSTANCE_SIZECHANGED", nil, self._instance)
end

local BFrame_scripts_onenter = function(self)
	OnEnterMainWindow(self._instance, self)
end

local BFrame_scripts_onleave = function(self)
	OnLeaveMainWindow(self._instance, self)
end

local BFrame_scripts_onmousedown = function(self, button)
	if (not self.isLocked and button == "LeftButton") then
		move_window(self, true, self._instance)
	end
end

local BFrame_scripts_onmouseup = function(self, button)
	if (self.isMoving) then
		move_window(self, false, self._instance) --> novo movedor da window
		self._instance:SaveMainWindowPosition()
	end
end

local function BFrame_scripts(baseframe, instance)
	baseframe._instance = instance
	baseframe:SetScript("OnSizeChanged", BFrame_scripts_onsizechange)
	baseframe:SetScript("OnEnter", BFrame_scripts_onenter)
	baseframe:SetScript("OnLeave", BFrame_scripts_onleave)
	baseframe:SetScript("OnMouseDown", BFrame_scripts_onmousedown)
	baseframe:SetScript("OnMouseUp", BFrame_scripts_onmouseup)
end

local function backgrounddisplay_scripts(backgrounddisplay, baseframe, instance)

	backgrounddisplay:SetScript("OnEnter", function(self)
		OnEnterMainWindow(instance, self)
	end)
	
	backgrounddisplay:SetScript("OnLeave", function(self) 
		OnLeaveMainWindow(instance, self)
	end)
end

local function instances_horizontais(instance, width, left, right)
	if (left) then
		for side, this_instance in _pairs(instance.snap) do 
			if (side == 1) then --> movendo para left
				local instance = _details.table_instances[this_instance]
				instance.baseframe:SetWidth(width)
				instance.auto_resize = true
				instance:ReadjustGump()
				instance.auto_resize = false
				instances_horizontais(instance, width, true, false)
				_details:SendEvent("DETAILS_INSTANCE_SIZECHANGED", nil, instance)
			end
		end
	end
	
	if (right) then
		for side, this_instance in _pairs(instance.snap) do 
			if (side == 3) then --> movendo para left
				local instance = _details.table_instances[this_instance]
				instance.baseframe:SetWidth(width)
				instance.auto_resize = true
				instance:ReadjustGump()
				instance.auto_resize = false
				instances_horizontais(instance, width, false, true)
				_details:SendEvent("DETAILS_INSTANCE_SIZECHANGED", nil, instance)
			end
		end
	end
end

local function instances_verticais(instance, altura, left, right)
	if (left) then
		for side, this_instance in _pairs(instance.snap) do 
			if (side == 1) then --> movendo para left
				local instance = _details.table_instances[this_instance]
				instance.baseframe:SetHeight(altura)
				instance.auto_resize = true
				instance:ReadjustGump()
				instance.auto_resize = false
				instances_verticais(instance, altura, true, false)
				_details:SendEvent("DETAILS_INSTANCE_SIZECHANGED", nil, instance)
			end
		end
	end
	
	if (right) then
		for side, this_instance in _pairs(instance.snap) do 
			if (side == 3) then --> movendo para left
				local instance = _details.table_instances[this_instance]
				instance.baseframe:SetHeight(altura)
				instance.auto_resize = true
				instance:ReadjustGump()
				instance.auto_resize = false
				instances_verticais(instance, altura, false, true)
				_details:SendEvent("DETAILS_INSTANCE_SIZECHANGED", nil, instance)
			end
		end
	end
end

local check_snap_side = function(instanceid, snap, id, container)
	local instance = _details:GetInstance(instanceid)
	if (instance and instance.snap[snap] and instance.snap[snap] == id) then
		tinsert(container, instance)
		return true
	end
end

function _details:instancesVerticais(instance)

	instance = self or instance
	
	local on_top = {}
	local on_bottom = {}
	local id = instance:GetId()
	
	--lower instances
	local this_instance = _details:GetInstance(id-1)
	if (this_instance) then
		--> top side
		if (this_instance.snap[2] and this_instance.snap[2] == id) then
			local cid = id
			local snapid = 2
			for i = cid-1, 1, -1 do
				if (check_snap_side(i, 2, cid, on_top)) then
					cid = cid - 1
				else
					break
				end
			end
		--> bottom side
		elseif (this_instance.snap[4] and this_instance.snap[4] == id) then
			local cid = id
			local snapid = 4
			for i = cid-1, 1, -1 do
				if (check_snap_side(i, 4, cid, on_bottom)) then
					cid = cid - 1
				else
					break
				end
			end
		end
	end

	--upper instances
	local this_instance = _details:GetInstance(id+1)
	if (this_instance) then
		--> top side
		if (this_instance.snap[2] and this_instance.snap[2] == id) then
			local cid = id
			local snapid = 2
			for i = cid+1, _details:GetNumInstancesAmount() do
				if (check_snap_side(i, 2, cid, on_top)) then
					cid = cid + 1
				else
					break
				end
			end
		--> bottom side
		elseif (this_instance.snap[4] and this_instance.snap[4] == id) then
			local cid = id
			local snapid = 4
			for i = cid+1, _details:GetNumInstancesAmount() do
				if (check_snap_side(i, 4, cid, on_bottom)) then
					cid = cid + 1
				else
					break
				end
			end
		end
	end
	
	--> calc top clamp
	local top_clamp = 0
	local bottom_clamp = 0
	
	if (instance.toolbar_side == 1) then
		top_clamp = top_clamp + 20
	elseif (instance.toolbar_side == 2) then
		bottom_clamp = bottom_clamp + 20
	end
	if (instance.show_statusbar) then
		bottom_clamp = bottom_clamp + 14
	end
	
	for cid, this_instance in _ipairs(on_top) do
		if (this_instance.show_statusbar) then
			top_clamp = top_clamp + 14
		end
		top_clamp = top_clamp + 20
		top_clamp = top_clamp + this_instance.baseframe:GetHeight()
	end
	
	for cid, this_instance in _ipairs(on_bottom) do
		if (this_instance.show_statusbar) then
			bottom_clamp = bottom_clamp + 14
		end
		bottom_clamp = bottom_clamp + 20
		bottom_clamp = bottom_clamp + this_instance.baseframe:GetHeight()
		tinsert(on_top, this_instance)
	end

	return on_top, bottom_clamp, top_clamp
end

--[[
			side 4
	-----------------------------------------
	|					|
side 1	|					| side 3
	|					|
	|					|
	-----------------------------------------
			side 2
--]]

function _details:instancesHorizontais(instance)

	instance = self or instance

	local linha_horizontal, left, right = {}, 0, 0
	
	local top, bottom = 0, 0

	local checking = instance
	
	local check_index_previous = _details.table_instances[instance.mine_id-1]
	if (check_index_previous) then --> possiu uma instância antes de mim
		if (check_index_previous.snap[3] and check_index_previous.snap[3] == instance.mine_id) then --> o index negactive vai para a left
			for i = instance.mine_id-1, 1, -1 do 
				local this_instance = _details.table_instances[i]
				if (this_instance.snap[3]) then
					if (this_instance.snap[3] == checking.mine_id) then
						linha_horizontal[#linha_horizontal+1] = this_instance
						left = left + this_instance.baseframe:GetWidth()
						checking = this_instance
					end
				else
					break
				end
			end
		elseif (check_index_previous.snap[1] and check_index_previous.snap[1] == instance.mine_id) then --> o index negactive vai para a right
			for i = instance.mine_id-1, 1, -1 do 
				local this_instance = _details.table_instances[i]
				if (this_instance.snap[1]) then
					if (this_instance.snap[1] == checking.mine_id) then
						linha_horizontal[#linha_horizontal+1] = this_instance
						right = right + this_instance.baseframe:GetWidth()
						checking = this_instance
					end
				else
					break
				end
			end
		end
	end
	
	checking = instance
	
	local check_index_posterior = _details.table_instances[instance.mine_id+1]
	if (check_index_posterior) then
		if (check_index_posterior.snap[3] and check_index_posterior.snap[3] == instance.mine_id) then --> o index posterior vai para a left
			for i = instance.mine_id+1, #_details.table_instances do 
				local this_instance = _details.table_instances[i]
				if (this_instance.snap[3]) then
					if (this_instance.snap[3] == checking.mine_id) then
						linha_horizontal[#linha_horizontal+1] = this_instance
						left = left + this_instance.baseframe:GetWidth()
						checking = this_instance
					end
				else
					break
				end
			end
		elseif (check_index_posterior.snap[1] and check_index_posterior.snap[1] == instance.mine_id) then --> o index posterior vai para a right
			for i = instance.mine_id+1, #_details.table_instances do 
				local this_instance = _details.table_instances[i]
				if (this_instance.snap[1]) then
					if (this_instance.snap[1] == checking.mine_id) then
						linha_horizontal[#linha_horizontal+1] = this_instance
						right = right + this_instance.baseframe:GetWidth()
						checking = this_instance
					end
				else
					break
				end
			end
		end
	end

	return linha_horizontal, left, right, bottom, top
	
end

local resizeTooltip = {
	{text = "|cff33CC00Click|cffEEEEEE: ".. Loc["STRING_RESIZE_COMMON"]},
	
	{text = "+|cff33CC00 Click|cffEEEEEE: " .. Loc["STRING_RESIZE_HORIZONTAL"]},
	{icon =[[Interface\AddOns\Details\images\key_shift]], width = 24, height = 14, l = 0, r = 1, t = 0, b =0.640625},
	
	{text = "+|cff33CC00 Click|cffEEEEEE: " .. Loc["STRING_RESIZE_VERTICAL"]},
	{icon =[[Interface\AddOns\Details\images\key_alt]], width = 24, height = 14, l = 0, r = 1, t = 0, b =0.640625},
	
	{text = "+|cff33CC00 Click|cffEEEEEE: " .. Loc["STRING_RESIZE_ALL"]},
	{icon =[[Interface\AddOns\Details\images\key_ctrl]], width = 24, height = 14, l = 0, r = 1, t = 0, b =0.640625}
}

--> search key: ~resizescript

local resize_scripts_onmousedown = function(self, button)
	_G.GameCooltip:ShowMe(false) --> Hide Cooltip
	
	if (not self:GetParent().isLocked and button == "LeftButton" and self._instance.mode ~= _details._details_props["MODE_ALONE"]) then 
		self:GetParent().isResizing = true
		self._instance:BaseFrameSnap()

		local isVertical = self._instance.verticalSnap
		local isHorizontal = self._instance.horizontalSnap
	
		local agrupadas
		if (self._instance.verticalSnap) then
			agrupadas = self._instance:instancesVerticais()
		elseif (self._instance.horizontalSnap) then
			agrupadas = self._instance:instancesHorizontais()
		end

		self._instance.stretchToo = agrupadas
		if (self._instance.stretchToo and #self._instance.stretchToo > 0) then
			for _, this_instance in ipairs(self._instance.stretchToo) do 
				this_instance.baseframe._place = this_instance:SaveMainWindowPosition()
				this_instance.baseframe.isResizing = true
			end
		end
		
	----------------
	
		if (self._myside == "<") then
			if (_IsShiftKeyDown()) then
				self._instance.baseframe:StartSizing("left")
				self._instance.eh_horizontal = true
			elseif (_IsAltKeyDown()) then
				self._instance.baseframe:StartSizing("top")
				self._instance.eh_vertical = true
			elseif (_IsControlKeyDown()) then
				self._instance.baseframe:StartSizing("bottomleft")
				self._instance.eh_tudo = true
			else
				self._instance.baseframe:StartSizing("bottomleft")
			end
			
			self:SetPoint("bottomleft", self._instance.baseframe, "bottomleft", -1, -1)
			self.afundado = true
			
		elseif (self._myside == ">") then
			if (_IsShiftKeyDown()) then
				self._instance.baseframe:StartSizing("right")
				self._instance.eh_horizontal = true
			elseif (_IsAltKeyDown()) then
				self._instance.baseframe:StartSizing("top")
				self._instance.eh_vertical = true
			elseif (_IsControlKeyDown()) then
				self._instance.baseframe:StartSizing("bottomright")
				self._instance.eh_tudo = true
			else
				self._instance.baseframe:StartSizing("bottomright")
			end
			
			if (self._instance.scrolling and _details.use_scroll) then
				self:SetPoint("bottomright", self._instance.baseframe, "bottomright",(self._instance.width_scroll*-1) + 1, -1)
			else
				self:SetPoint("bottomright", self._instance.baseframe, "bottomright", 1, -1)
			end
			self.afundado = true
		end
		
		_details:SendEvent("DETAILS_INSTANCE_STARTRESIZE", nil, self._instance)
		
		if (_details.update_speed > 0.3) then
			_details:CancelTimer(_details.atualizador)
			_details.atualizador = _details:ScheduleRepeatingTimer("UpdateGumpMain", 0.3, -1)
			_details.resize_changed_update_speed = true
		end
		
	end 
end

local resize_scripts_onmouseup = function(self, button)

	if (self.afundado) then
		self.afundado = false
		if (self._myside == ">") then
			if (self._instance.scrolling and _details.use_scroll) then
				self:SetPoint("bottomright", self._instance.baseframe, "bottomright", self._instance.width_scroll*-1, 0)
			else
				self:SetPoint("bottomright", self._instance.baseframe, "bottomright", 0, 0)
			end
		else
			self:SetPoint("bottomleft", self._instance.baseframe, "bottomleft", 0, 0)
		end
	end

	if (self:GetParent().isResizing) then 
	
		self:GetParent():StopMovingOrSizing()
		self:GetParent().isResizing = false
		
		self._instance:RefreshBars()
		self._instance:InstanceReset()
		self._instance:ReadjustGump()

		if (self._instance.stretchToo and #self._instance.stretchToo > 0) then
			for _, this_instance in ipairs(self._instance.stretchToo) do 
				this_instance.baseframe:StopMovingOrSizing()
				this_instance.baseframe.isResizing = false
				this_instance:RefreshBars()
				this_instance:InstanceReset()
				this_instance:ReadjustGump()
				_details:SendEvent("DETAILS_INSTANCE_SIZECHANGED", nil, this_instance)
			end
			self._instance.stretchToo = nil
		end	
		
		local width = self._instance.baseframe:GetWidth()
		local altura = self._instance.baseframe:GetHeight()
		
		if (self._instance.eh_horizontal) then
			instances_horizontais(self._instance, width, true, true)
			self._instance.eh_horizontal = nil
		end
		
		--if (instance.eh_vertical) then
			instances_verticais(self._instance, altura, true, true)
			self._instance.eh_vertical = nil
		--end
		
		_details:SendEvent("DETAILS_INSTANCE_ENDRESIZE", nil, self._instance)
		
		if (self._instance.eh_tudo) then
			for _, this_instance in _ipairs(_details.table_instances) do
				if (this_instance:IsActive() and this_instance.mode ~= _details._details_props["MODE_ALONE"]) then
					this_instance.baseframe:ClearAllPoints()
					this_instance:SaveMainWindowPosition()
					this_instance:RestoreMainWindowPosition()
				end
			end
			
			for _, this_instance in _ipairs(_details.table_instances) do
				if (this_instance:IsActive() and this_instance ~= self._instance and this_instance.mode ~= _details._details_props["MODE_ALONE"]) then
					this_instance.baseframe:SetWidth(width)
					this_instance.baseframe:SetHeight(altura)
					this_instance.auto_resize = true
					this_instance:RefreshBars()
					this_instance:InstanceReset()
					this_instance:ReadjustGump()
					this_instance.auto_resize = false
					_details:SendEvent("DETAILS_INSTANCE_SIZECHANGED", nil, this_instance)
				end
			end

			self._instance.eh_tudo = nil
		end
		
		self._instance:BaseFrameSnap()
		
		for _, this_instance in _ipairs(_details.table_instances) do
			if (this_instance:IsActive()) then
				this_instance:SaveMainWindowPosition()
				this_instance:RestoreMainWindowPosition()
			end
		end
		
		if (_details.resize_changed_update_speed) then
			_details:CancelTimer(_details.atualizador)
			_details.atualizador = _details:ScheduleRepeatingTimer("UpdateGumpMain", _details.update_speed, -1)
			_details.resize_changed_update_speed = nil
		end
		
	end 
end

local resize_scripts_onhide = function(self)
	if (self.going_hide) then
		_G.GameCooltip:ShowMe(false)
		self.going_hide = nil
	end
end

local resize_scripts_onenter = function(self)
	if (self._instance.mode ~= _details._details_props["MODE_ALONE"] and not self._instance.baseframe.isLocked and not self.showing) then

		OnEnterMainWindow(self._instance, self)
	
		self.texture:SetBlendMode("ADD")
		self.displaying = true
		
		GameCooltip:Reset()
		GameCooltip:SetType("tooltip")
		GameCooltip:AddFromTable(resizeTooltip)
		GameCooltip:SetOption("TextSize", _details.font_sizes.menus)
		GameCooltip:SetOption("NoLastSelectedBar", true)
		GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
		GameCooltip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		GameCooltip:SetOwner(self)
		GameCooltip:ShowCooltip()
	end
end

local resize_scripts_onleave = function(self)
	if (self.displaying) then
		self.going_hide = true
		if (not self.movendo) then
			OnLeaveMainWindow(self._instance, self)
		end

		self.texture:SetBlendMode("BLEND")
		self.displaying = false
		
		GameCooltip:ShowMe(false)
	end
end

local function resize_scripts(resizer, instance, scrollbar, side, baseframe)
	resizer._instance = instance
	resizer._myside = side

	resizer:SetScript("OnMouseDown", resize_scripts_onmousedown)
	resizer:SetScript("OnMouseUp", resize_scripts_onmouseup)
	resizer:SetScript("OnHide", resize_scripts_onhide)
	resizer:SetScript("OnEnter", resize_scripts_onenter)
	resizer:SetScript("OnLeave", resize_scripts_onleave)
end

local lockButtonTooltip = {
	{text = Loc["STRING_LOCK_DESC"]},
	{icon =[[Interface\AddOns\Details\images\PetBattle-LockIcon]], width = 14, height = 14, l = 0.0703125, r = 0.9453125, t = 0.0546875, b = 0.9453125, color = "orange"},
}

local lockFunctionOnEnter = function(self)
	if (self.instance.mode ~= _details._details_props["MODE_ALONE"] and not self.displaying) then
		OnEnterMainWindow(self.instance, self)
		
		self.displaying = true
		
		self.label:SetTextColor(1, 1, 1, .6)

		GameCooltip:Reset()
		GameCooltip:SetType("tooltip")
		GameCooltip:AddFromTable(lockButtonTooltip)
		GameCooltip:SetOption("NoLastSelectedBar", true)
		GameCooltip:SetOption("TextSize", _details.font_sizes.menus)
		GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
		GameCooltip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		GameCooltip:SetOwner(self)
		GameCooltip:ShowCooltip()
	end
end
 
local lockFunctionOnLeave = function(self)
	if (self.displaying) then
		self.going_hide = true
		OnLeaveMainWindow(self.instance, self)
		self.label:SetTextColor(.3, .3, .3, .6)
		self.displaying = false
		GameCooltip:ShowMe(false)
	end
end

local lockFunctionOnHide = function(self)
	if (self.going_hide) then
		GameCooltip:ShowMe(false)
		self.going_hide = nil
	end
end

function _details:DelayOptionsRefresh(instance, no_reopen)
	if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
		_details:ScheduleTimer("OpenOptionsWindow", 0.1, {instance or _G.DetailsOptionsWindow.instance, no_reopen})
	end
end

local lockFunctionOnClick = function(button)
	local baseframe = button:GetParent()
	if (baseframe.isLocked) then
		baseframe.isLocked = false
		baseframe.instance.isLocked = false
		button.label:SetText(Loc["STRING_LOCK_WINDOW"])
		button:SetWidth(button.label:GetStringWidth()+2)
		baseframe.resize_right:SetAlpha(1)
		baseframe.resize_left:SetAlpha(1)
		button:ClearAllPoints()
		button:SetPoint("right", baseframe.resize_right, "left", -1, 1.5)		
	else
		baseframe.isLocked = true
		baseframe.instance.isLocked = true
		button.label:SetText(Loc["STRING_UNLOCK_WINDOW"])
		button:SetWidth(button.label:GetStringWidth()+2)
		button:ClearAllPoints()
		button:SetPoint("bottomright", baseframe, "bottomright", -3, 0)
		baseframe.resize_right:SetAlpha(0)
		baseframe.resize_left:SetAlpha(0)
	end
	
	_details:DelayOptionsRefresh()
	
end
_details.lock_instance_function = lockFunctionOnClick

local unSnapButtonTooltip = {
	{text = Loc["STRING_DETACH_DESC"]},
	{icon =[[Interface\AddOns\Details\images\icons]], width = 14, height = 14, l = 160/512, r = 179/512, t = 142/512, b = 162/512},
}

local unSnapButtonOnEnter = function(self)

	local have_snap = false
	for _, instance_id in _pairs(self.instance.snap) do
		if (instance_id) then
			have_snap = true
			break
		end
	end
	
	if (not have_snap) then
		OnEnterMainWindow(self.instance, self)
		self.displaying = true
		return
	end

	OnEnterMainWindow(self.instance, self)
	self.displaying = true
	
	GameCooltip:Reset()
	GameCooltip:AddFromTable(unSnapButtonTooltip)
	GameCooltip:SetOption("TextSize", _details.font_sizes.menus)
	GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
	GameCooltip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
	GameCooltip:ShowCooltip(self, "tooltip")
	
end

local unSnapButtonOnLeave = function(self)
	if (self.displaying) then
		OnLeaveMainWindow(self.instance, self)
		self.displaying = false
		GameCooltip:Hide()
	end
end

local shift_monitor = function(self)
	if (_IsShiftKeyDown()) then
		if (not self.showing_allspells) then
			self.showing_allspells = true
			local instance = _details:GetInstance(self.instance_id)
			instance:SetTooltip(self, self.row_id, "shift")
		end
		
	elseif (self.showing_allspells) then
		self.showing_allspells = false
		local instance = _details:GetInstance(self.instance_id)
		instance:SetTooltip(self, self.row_id)
	end
	
	if (_IsControlKeyDown()) then
		if (not self.showing_alltargets) then
			self.showing_alltargets = true
			local instance = _details:GetInstance(self.instance_id)
			instance:SetTooltip(self, self.row_id, "ctrl")
		end
		
	elseif (self.showing_alltargets) then
		self.showing_alltargets = false
		local instance = _details:GetInstance(self.instance_id)
		instance:SetTooltip(self, self.row_id)
	end
	
	if (_IsAltKeyDown()) then
		if (not self.showing_allpets) then
			self.showing_allpets = true
			local instance = _details:GetInstance(self.instance_id)
			instance:SetTooltip(self, self.row_id, "alt")
		end
		
	elseif (self.showing_allpets) then
		self.showing_allpets = false
		local instance = _details:GetInstance(self.instance_id)
		instance:SetTooltip(self, self.row_id)
	end
end

local on_switch_show = function(instance)
	instance:SwitchTable(instance, true, 1, 6)
	return true
end

local bar_backdrop_onenter = {
	bgFile =[[Interface\Tooltips\UI-Tooltip-Background]], 
	tile = true, tileSize = 16,
	insets = {left = 1, right = 1, top = 0, bottom = 1}
}
local bar_backdrop_onleave = {
	bgFile = "", 
	edgeFile = "", tile = true, tileSize = 16, edgeSize = 32,
	insets = {left = 1, right = 1, top = 0, bottom = 1}
}

local bar_scripts_onenter = function(self)
	self.mouse_over = true
	OnEnterMainWindow(self._instance, self)

	self._instance:SetTooltip(self, self.row_id)
	
	self:SetBackdrop(bar_backdrop_onenter)	
	self:SetBackdropColor(0.588, 0.588, 0.588, 0.7)

	self.texture:SetBlendMode("ADD")
	--local r, g, b = self.texture:GetVertexColor()
	--self.texture:SetVertexColor(math.min(r+0.1, 1), math.min(g+0.1, 1), math.min(b+0.1, 1))
	--self.icon_class:SetBlendMode("ADD")
	
	self:SetScript("OnUpdate", shift_monitor)
end

local bar_scripts_onleave = function(self)
	self.mouse_over = false
	OnLeaveMainWindow(self._instance, self)
	
	_GameTooltip:Hide()
	GameCooltip:ShowMe(false)
	
	self:SetBackdrop(bar_backdrop_onleave)	
	self:SetBackdropBorderColor(0, 0, 0, 0)
	self:SetBackdropColor(0, 0, 0, 0)
	
	self.texture:SetBlendMode("BLEND")
	--self.icon_class:SetBlendMode("BLEND")
	--local r, g, b = self.texture:GetVertexColor()
	--self.texture:SetVertexColor(math.min(r+0.1, 1), math.min(g+0.1, 1), math.min(b+0.1, 1))
	
	self.showing_allspells = false
	self:SetScript("OnUpdate", nil)
end

local bar_scripts_onmousedown = function(self, button)
	if (self.fading_in) then
		return
	end
	
	if (button == "RightButton") then
		return _details.switch:ShowMe(self._instance)
	
	--elseif (button == "MiddleButton") then

	elseif (button == "LeftButton") then

		if (self._instance.attribute == 1 and self._instance.sub_attribute == 6) then --> enemies
		
			local enemy = self.my_table.name
			local custom_name = enemy .. Loc["STRING_CUSTOM_ENEMY_DT"]
		
			--> proheal se já tem um custom:
			for index, CustomObject in _ipairs(_details.custom) do
				if (CustomObject:GetName() == custom_name) then
					--> fix for not saving funcs on logout
					if (not CustomObject.OnSwitchShow) then
						CustomObject.OnSwitchShow = on_switch_show
					end
					return self._instance:SwitchTable(self._instance.segment, 5, index)
				end
			end

			--> create um custom para this actor.
			local new_custom_object = {
				name = custom_name,
				icon =[[Interface\AddOns\Details\images\Pet_Type_Undead]],
				attribute = "damagedone",
				author = _details.playername,
				desc = enemy .. " Damage Taken",
				source = "[raid]",
				target = enemy,
				script = false,
				tooltip = false,
				temp = true,
				OnSwitchShow = on_switch_show,
			}
	
			tinsert(_details.custom, new_custom_object)
			setmetatable(new_custom_object, _details.attribute_custom)
			new_custom_object.__index = _details.attribute_custom

			return self._instance:SwitchTable(self._instance.segment, 5, #_details.custom)
			
		end	
	end
	
	self.text_right:SetPoint("right", self.statusbar, "right", 1, -1)
	if (self._instance.row_info.no_icon) then
		self.text_left:SetPoint("left", self.statusbar, "left", 3, -1)
	else
		self.text_left:SetPoint("left", self.icon_class, "right", 4, -1)
	end

	self.mouse_down = _GetTime()
	self.button = button
	local x, y = _GetCursorPosition()
	self.x = _math_floor(x)
	self.y = _math_floor(y)

	if (not self._instance.baseframe.isLocked) then
		GameCooltip:Hide()
		move_window(self._instance.baseframe, true, self._instance)
	end
end

local bar_scripts_onmouseup = function(self, button)
	if (self._instance.baseframe.isMoving) then
		move_window(self._instance.baseframe, false, self._instance)
		self._instance:SaveMainWindowPosition()

		if (self._instance:SetTooltip(self, self.row_id)) then
			GameCooltip:Show(self, 1)
		end
	end

	self.text_right:SetPoint("right", self.statusbar, "right")
	if (self._instance.row_info.no_icon) then
		self.text_left:SetPoint("left", self.statusbar, "left", 2, 0)
	else
		self.text_left:SetPoint("left", self.icon_class, "right", 3, 0)
	end
	
	local x, y = _GetCursorPosition()
	x = _math_floor(x)
	y = _math_floor(y)

	if (self.mouse_down and(self.mouse_down+0.4 > _GetTime() and(x == self.x and y == self.y)) or(x == self.x and y == self.y)) then
		if (self.button == "LeftButton" or self.button == "MiddleButton") then
			if (self._instance.attribute == 5 or _IsShiftKeyDown()) then 
				--> report
				return _details:ReportSingleLine(self._instance, self)
			end
			self._instance:OpenWindowInfo(self.my_table)
		end
	end
end

local bar_scripts_onclick = function(self, button)

end

local function bar_scripts(this_bar, instance, i)
	this_bar._instance = instance

	this_bar:SetScript("OnEnter", bar_scripts_onenter) 
	this_bar:SetScript("OnLeave", bar_scripts_onleave) 
	this_bar:SetScript("OnMouseDown", bar_scripts_onmousedown)
	this_bar:SetScript("OnMouseUp", bar_scripts_onmouseup)
	this_bar:SetScript("OnClick", bar_scripts_onclick)
end

function _details:ReportSingleLine(instance, bar)

	local report
	if (instance.attribute == 5) then --> custom
		report = {"Details! " .. Loc["STRING_CUSTOM_REPORT"] .. " " ..instance.customName}
	else
		report = {"Details! " .. Loc["STRING_REPORT"] .. " " .. _details.sub_attributes[instance.attribute].list[instance.sub_attribute]}
	end

	report[#report+1] = bar.text_left:GetText().." "..bar.text_right:GetText()

	return _details:Report(report, {_no_current = true, _no_inverse = true, _custom = true})
end

local function button_stretch_scripts(baseframe, backgrounddisplay, instance)
	local button = baseframe.button_stretch

	button:SetScript("OnEnter", function(self)
		self.mouse_over = true
		gump:Fade(self, "ALPHA", 1)
	end)
	button:SetScript("OnLeave", function(self)
		self.mouse_over = false
		gump:Fade(self, "ALPHA", 0)
	end)	

	button:SetScript("OnMouseDown", function(self, button)

		if (button ~= "LeftButton") then
			return
		end
	
		if (instance:IsSoloMode()) then
			return
		end
	
		instance:HideScrollBar(true)
		baseframe._place = instance:SaveMainWindowPosition()
		baseframe.isResizing = true
		baseframe.isStretching = true
		baseframe:SetFrameStrata("TOOLTIP")
		instance.rowframe:SetFrameStrata("TOOLTIP")
		
		local _r, _g, _b, _a = baseframe:GetBackdropColor()
		gump:GradientEffect( baseframe, "frame", _r, _g, _b, _a, _r, _g, _b, 0.9, 1.5)
		if (instance.wallpaper.enabled) then
			_r, _g, _b = baseframe.wallpaper:GetVertexColor()
			_a = baseframe.wallpaper:GetAlpha()
			gump:GradientEffect(baseframe.wallpaper, "texture", _r, _g, _b, _a, _r, _g, _b, 0.05, 0.5)
		end
		
		if (instance.stretch_button_side == 1) then
			baseframe:StartSizing("top")
		elseif (instance.stretch_button_side == 2) then
			baseframe:StartSizing("bottom")
		end
		
		local linha_horizontal = {}
	
		local checking = instance
		for i = instance.mine_id-1, 1, -1 do 
			local this_instance = _details.table_instances[i]
			if ((this_instance.snap[1] and this_instance.snap[1] == checking.mine_id) or(this_instance.snap[3] and this_instance.snap[3] == checking.mine_id)) then
				linha_horizontal[#linha_horizontal+1] = this_instance
				checking = this_instance
			else
				break
			end
		end
		
		checking = instance
		for i = instance.mine_id+1, #_details.table_instances do 
			local this_instance = _details.table_instances[i]
			if ((this_instance.snap[1] and this_instance.snap[1] == checking.mine_id) or(this_instance.snap[3] and this_instance.snap[3] == checking.mine_id)) then
				linha_horizontal[#linha_horizontal+1] = this_instance
				checking = this_instance
			else
				break
			end
		end
		
		instance.stretchToo = linha_horizontal
		if (#instance.stretchToo > 0) then
			for _, this_instance in ipairs(instance.stretchToo) do 
				this_instance:HideScrollBar(true)
				this_instance.baseframe._place = this_instance:SaveMainWindowPosition()
				this_instance.baseframe.isResizing = true
				this_instance.baseframe.isStretching = true
				this_instance.baseframe:SetFrameStrata("TOOLTIP")
				this_instance.rowframe:SetFrameStrata("TOOLTIP")
				
				local _r, _g, _b, _a = this_instance.baseframe:GetBackdropColor()
				gump:GradientEffect( this_instance.baseframe, "frame", _r, _g, _b, _a, _r, _g, _b, 0.9, 1.5)
				_details:SendEvent("DETAILS_INSTANCE_STARTSTRETCH", nil, this_instance)
				
				if (this_instance.wallpaper.enabled) then
					_r, _g, _b = this_instance.baseframe.wallpaper:GetVertexColor()
					_a = this_instance.baseframe.wallpaper:GetAlpha()
					gump:GradientEffect(this_instance.baseframe.wallpaper, "texture", _r, _g, _b, _a, _r, _g, _b, 0.05, 0.5)
				end
				
			end
		end
		
		_details:SnapTextures(true)
		
		_details:SendEvent("DETAILS_INSTANCE_STARTSTRETCH", nil, instance)
		
		--> change the update speed
		
		if (_details.update_speed > 0.3) then
			_details:CancelTimer(_details.atualizador)
			_details.atualizador = _details:ScheduleRepeatingTimer("UpdateGumpMain", 0.3, -1)
			_details.stretch_changed_update_speed = true
		end
		
	end)
	
	button:SetScript("OnMouseUp", function(self, button)
	
		if (button ~= "LeftButton") then
			return
		end
	
		if (instance:IsSoloMode()) then
			return
		end
	
		if (baseframe.isResizing) then 
			baseframe:StopMovingOrSizing()
			baseframe.isResizing = false
			instance:RestoreMainWindowPosition(baseframe._place)
			instance:ReadjustGump()
			baseframe.isStretching = false
			if (instance.need_scrolling) then
				instance:MostrarScrollBar(true)
			end
			_details:SendEvent("DETAILS_INSTANCE_SIZECHANGED", nil, instance)
			
			instance:RefreshBars()
			instance:InstanceReset()
			instance:ReadjustGump()
			
			if (instance.stretchToo and #instance.stretchToo > 0) then
				for _, this_instance in ipairs(instance.stretchToo) do 
					this_instance.baseframe:StopMovingOrSizing()
					this_instance.baseframe.isResizing = false
					this_instance:RestoreMainWindowPosition(this_instance.baseframe._place)
					this_instance:ReadjustGump()
					this_instance.baseframe.isStretching = false
					if (this_instance.need_scrolling) then
						this_instance:MostrarScrollBar(true)
					end
					_details:SendEvent("DETAILS_INSTANCE_SIZECHANGED", nil, this_instance)
					
					local _r, _g, _b, _a = this_instance.baseframe:GetBackdropColor()
					gump:GradientEffect( this_instance.baseframe, "frame", _r, _g, _b, _a, instance.bg_r, instance.bg_g, instance.bg_b, instance.bg_alpha, 0.5)
					
					if (this_instance.wallpaper.enabled) then
						_r, _g, _b = this_instance.baseframe.wallpaper:GetVertexColor()
						_a = this_instance.baseframe.wallpaper:GetAlpha()
						gump:GradientEffect(this_instance.baseframe.wallpaper, "texture", _r, _g, _b, _a, _r, _g, _b, this_instance.baseframe.wallpaper.alpha, 1.0)
					end
					
					this_instance.baseframe:SetFrameStrata(this_instance.strata)
					this_instance.rowframe:SetFrameStrata(this_instance.strata)
					this_instance:StretchButtonAlwaysOnTop()
					
					_details:SendEvent("DETAILS_INSTANCE_ENDSTRETCH", nil, this_instance.baseframe)
					
					this_instance:RefreshBars()
					this_instance:InstanceReset()
					this_instance:ReadjustGump()
					
				end
				instance.stretchToo = nil
			end
			
		end 
		
		local _r, _g, _b, _a = baseframe:GetBackdropColor()
		gump:GradientEffect( baseframe, "frame", _r, _g, _b, _a, instance.bg_r, instance.bg_g, instance.bg_b, instance.bg_alpha, 0.5)
		if (instance.wallpaper.enabled) then
			_r, _g, _b = baseframe.wallpaper:GetVertexColor()
			_a = baseframe.wallpaper:GetAlpha()
			gump:GradientEffect(baseframe.wallpaper, "texture", _r, _g, _b, _a, _r, _g, _b, instance.wallpaper.alpha, 1.0)
		end
		
		baseframe:SetFrameStrata(instance.strata)
		instance.rowframe:SetFrameStrata(instance.strata)
		instance:StretchButtonAlwaysOnTop()
		
		_details:SnapTextures(false)
		
		_details:SendEvent("DETAILS_INSTANCE_ENDSTRETCH", nil, instance)
		
		if (_details.stretch_changed_update_speed) then
			_details:CancelTimer(_details.atualizador)
			_details.atualizador = _details:ScheduleRepeatingTimer("UpdateGumpMain", _details.update_speed, -1)
			_details.stretch_changed_update_speed = nil
		end
		
	end)	
end

local function button_down_scripts(main_frame, backgrounddisplay, instance, scrollbar)
	main_frame.button_down:SetScript("OnMouseDown", function(self)
		if (not scrollbar:IsEnabled()) then
			return
		end
		
		local B = instance.barS[2]
		if (B < instance.rows_showing) then
			scrollbar:SetValue(scrollbar:GetValue() + instance.row_height)
		end
		
		self.precionado = true
		self.last_up = -0.3
		self:SetScript("OnUpdate", function(self, elapsed)
			self.last_up = self.last_up + elapsed
			if (self.last_up > 0.03) then
				self.last_up = 0
				B = instance.barS[2]
				if (B < instance.rows_showing) then
					scrollbar:SetValue(scrollbar:GetValue() + instance.row_height)
				else
					self:Disable()
				end
			end
		end)
	end)
	
	main_frame.button_down:SetScript("OnMouseUp", function(self) 
		self.precionado = false
		self:SetScript("OnUpdate", nil)
	end)
end

local function button_up_scripts(main_frame, backgrounddisplay, instance, scrollbar)

	main_frame.button_up:SetScript("OnMouseDown", function(self) 

		if (not scrollbar:IsEnabled()) then
			return
		end
		
		local A = instance.barS[1]
		if (A > 1) then
			scrollbar:SetValue(scrollbar:GetValue() - instance.row_height)
		end
		
		self.precionado = true
		self.last_up = -0.3
		self:SetScript("OnUpdate", function(self, elapsed)
			self.last_up = self.last_up + elapsed
			if (self.last_up > 0.03) then
				self.last_up = 0
				A = instance.barS[1]
				if (A > 1) then
					scrollbar:SetValue(scrollbar:GetValue() - instance.row_height)
				else
					self:Disable()
				end
			end
		end)
	end)
	
	main_frame.button_up:SetScript("OnMouseUp", function(self) 
		self.precionado = false
		self:SetScript("OnUpdate", nil)
	end)	

	main_frame.button_up:SetScript("OnEnable", function(self)
		local current = scrollbar:GetValue()
		if (current == 0) then
			main_frame.button_up:Disable()
		end
	end)
end

function DetailsKeyBindScrollUp()

	local last_key_pressed = _details.KeyBindScrollUpLastPressed or GetTime()-0.3
	
	local to_top = false
	if (last_key_pressed+0.2 > GetTime()) then
		to_top = true
	end
	
	_details.KeyBindScrollUpLastPressed = GetTime()
	
	for index, instance in ipairs(_details.table_instances) do
		if (instance:IsEnabled()) then
			
			local scrollbar = instance.scroll
			
			local A = instance.barS[1]
			if (A and A > 1) then
				if (to_top) then
					scrollbar:SetValue(0)
					scrollbar.ultimo = 0
					instance.baseframe.button_up:Disable()
				else
					scrollbar:SetValue(scrollbar:GetValue() - instance.row_height*2)
				end
			elseif (A) then
				scrollbar:SetValue(0)
				scrollbar.ultimo = 0
				instance.baseframe.button_up:Disable()
			end
			
		end
	end
end

function DetailsKeyBindScrollDown()
	for index, instance in ipairs(_details.table_instances) do
		if (instance:IsEnabled()) then
			
			local scrollbar = instance.scroll
			
			local B = instance.barS[2]
			if (B and B < instance.rows_showing) then
				scrollbar:SetValue(scrollbar:GetValue() + instance.row_height*2)
			elseif (B) then
				local _, maxValue = scrollbar:GetMinMaxValues()
				scrollbar:SetValue(maxValue)
				scrollbar.ultimo = maxValue
				instance.baseframe.button_down:Disable()
			end
			
		end
	end
end

local function iterate_scroll_scripts(backgrounddisplay, backgroundframe, baseframe, scrollbar, instance)

	baseframe:SetScript("OnMouseWheel", 
		function(self, delta)
			if (delta > 0) then --> rolou pra cima
				local A = instance.barS[1]
				if (A > 1) then
					scrollbar:SetValue(scrollbar:GetValue() - instance.row_height*2)
				else
					scrollbar:SetValue(0)
					scrollbar.ultimo = 0
					baseframe.button_up:Disable()
				end
			elseif (delta < 0) then --> rolou pra baixo
			
				local B = instance.barS[2]
			
				if (B < instance.rows_showing) then
					scrollbar:SetValue(scrollbar:GetValue() + instance.row_height*2)
				else
					local _, maxValue = scrollbar:GetMinMaxValues()
					scrollbar:SetValue(maxValue)
					scrollbar.ultimo = maxValue
					baseframe.button_down:Disable()
				end
			end

		end)

	scrollbar:SetScript("OnValueChanged", function(self)
		local ultimo = self.ultimo
		local mine_valor = self:GetValue()
		if (ultimo == mine_valor) then --> não mudou
			return
		end
		
		--> shortcut
		local minValue, maxValue = scrollbar:GetMinMaxValues()
		if (minValue == mine_valor) then
			instance.barS[1] = 1
			instance.barS[2] = instance.rows_fit_in_window
			instance:UpdateGumpMain(instance, true)
			self.ultimo = mine_valor
			baseframe.button_up:Disable()
			return
		elseif (maxValue == mine_valor) then
			local min = instance.rows_showing -instance.rows_fit_in_window
			min = min+1
			if (min < 1) then
				min = 1
			end
			instance.barS[1] = min
			instance.barS[2] = instance.rows_showing
			instance:UpdateGumpMain(instance, true)
			self.ultimo = mine_valor
			baseframe.button_down:Disable()
			return
		end
		
		if (not baseframe.button_up:IsEnabled()) then
			baseframe.button_up:Enable()
		end
		if (not baseframe.button_down:IsEnabled()) then
			baseframe.button_down:Enable()
		end
		
		if (mine_valor > ultimo) then --> scroll down

			local B = instance.barS[2]
			if (B < instance.rows_showing) then --> se o valor maximo não for o máximo de bars a serem mostradas	
				
				local precisa_passar =((B+2) * instance.row_height) -(instance.row_height*instance.rows_fit_in_window)
				
			--	if (mine_valor > precisa_passar) then --> o valor atual passou o valor que precisa passar pra locomover
				if (true) then --> testing
					local diff = mine_valor - ultimo --> pega a diferença de H
					diff = diff / instance.row_height --> calcula quantas bars ele pulou
					diff = _math_ceil(diff) --> arredonda para cima
					if (instance.barS[2]+diff > instance.rows_showing and ultimo > 0) then
						instance.barS[1] = instance.rows_showing -(instance.rows_fit_in_window-1)
						instance.barS[2] = instance.rows_showing
					else
						instance.barS[2] = instance.barS[2]+diff
						instance.barS[1] = instance.barS[1]+diff
					end
					instance:UpdateGumpMain(instance, true)
				end
			end
		else --> scroll up
			local A = instance.barS[1]
			if (A > 1) then
				local precisa_passar =(A-1) * instance.row_height
				--if (mine_valor < precisa_passar) then
				if (true) then --> testing
					--> calcula quantas bars passou
					local diff = ultimo - mine_valor
					diff = diff / instance.row_height
					diff = _math_ceil(diff)
					if (instance.barS[1]-diff < 1) then
						instance.barS[2] = instance.rows_fit_in_window
						instance.barS[1] = 1
					else
						instance.barS[2] = instance.barS[2]-diff
						instance.barS[1] = instance.barS[1]-diff
					end

					instance:UpdateGumpMain(instance, true)
				end
			end
		end
		self.ultimo = mine_valor
	end)		
end

function _details:HaveInstanceAlert()
	return self.alert:IsShown()
end

function _details:InstanceAlertTime(instance)
	instance.alert:Hide()
	instance.alert.rotate:Stop()
	instance.alert_time = nil
end

function _details:InstanceAlert(msg, icon, time, clickfunc)
	
	if (not self.mine_id) then
		local lower = _details:GetLowerInstanceNumber()
		if (lower) then
			self = _details:GetInstance(lower)
		else
			return
		end
	end
	
	if (type(msg) == "boolean" and not msg) then
		self.alert:Hide()
		self.alert.rotate:Stop()
		self.alert_time = nil
		return
	end
	
	if (msg) then
		self.alert.text:SetText(msg)
	else
		self.alert.text:SetText("")
	end
	
	if (icon) then
		if (type(icon) == "table") then
			local texture, w, h, animate, l, r, t, b, r, g, b, a = unpack(icon)
			
			self.alert.icon:SetTexture(texture)
			self.alert.icon:SetWidth(w or 14)
			self.alert.icon:SetHeight(h or 14)
			if (l and r and t and b) then
				self.alert.icon:SetTexCoord(l, r, t, b)
			end
			if (animate) then
				self.alert.rotate:Play()
			end
			if (r and g and b) then
				self.alert.icon:SetVertexColor(r, g, b, a or 1)
			end
		else
			self.alert.icon:SetWidth(14)
			self.alert.icon:SetHeight(14)
			self.alert.icon:SetTexture(icon)
			self.alert.icon:SetVertexColor(1, 1, 1, 1)
			self.alert.icon:SetTexCoord(0, 1, 0, 1)
		end
	else
		self.alert.icon:SetTexture(nil)
	end
	
	if (clickfunc) then
		self.alert.button:SetClickFunction(unpack(clickfunc))
	else
		self.alert.button.clickfunction = nil
	end

	if (time) then
		self.alert_time = time
		_details:ScheduleTimer("InstanceAlertTime", time, self)
	end
	
	self.alert:SetPoint("bottom", self.baseframe, "bottom", 0, -12)
	self.alert:SetPoint("left", self.baseframe, "left", 3, 0)
	self.alert:SetPoint("right", self.baseframe, "right", -3, 0)
	
	self.alert:Show()
	self.alert:Play()
end

function CreateAlertFrame(baseframe, instance)

	local frame_upper = CreateFrame("scrollframe", "DetailsAlertFrameScroll" .. instance.mine_id, baseframe)
	frame_upper:SetPoint("bottom", baseframe, "bottom")
	frame_upper:SetPoint("left", baseframe, "left", 3, 0)
	frame_upper:SetPoint("right", baseframe, "right", -3, 0)
	frame_upper:SetHeight(13)
	frame_upper:SetFrameStrata("fullscreen")
	
	local frame_lower = CreateFrame("frame", "DetailsAlertFrameScrollChild" .. instance.mine_id, frame_upper)
	frame_lower:SetHeight(25)
	frame_lower:SetPoint("left", frame_upper, "left")
	frame_lower:SetPoint("right", frame_upper, "right")
	frame_upper:SetScrollChild(frame_lower)

	local alert_bg = CreateFrame("frame", "DetailsAlertFrame" .. instance.mine_id, frame_lower)
	alert_bg:SetPoint("bottom", baseframe, "bottom")
	alert_bg:SetPoint("left", baseframe, "left", 3, 0)
	alert_bg:SetPoint("right", baseframe, "right", -3, 0)
	alert_bg:SetHeight(12)
	alert_bg:SetBackdrop({bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
	insets = {left = 0, right = 0, top = 0, bottom = 0}})
	alert_bg:SetBackdropColor(.1, .1, .1, 1)
	alert_bg:SetFrameStrata("HIGH")
	alert_bg:SetFrameLevel(baseframe:GetFrameLevel() + 6)
	alert_bg:Hide()

	local toptexture = alert_bg:CreateTexture(nil, "background")
	toptexture:SetTexture([[Interface\AddOns\Details\images\challenges-main]])
	--toptexture:SetTexCoord(0.1921484375, 0.523671875, 0.234375, 0.160859375)
	toptexture:SetTexCoord(0.231171875, 0.4846484375, 0.0703125, 0.072265625)
	toptexture:SetPoint("left", alert_bg, "left")
	toptexture:SetPoint("right", alert_bg, "right")
	toptexture:SetPoint("bottom", alert_bg, "top", 0, 0)
	toptexture:SetHeight(1)
	
	local text = alert_bg:CreateFontString(nil, "overlay", "GameFontNormal")
	text:SetPoint("right", alert_bg, "right", -14, 0)
	_details:SetFontSize(text, 10)
	text:SetTextColor(1, 1, 1, 1)
	
	local rotate_frame = CreateFrame("frame", "DetailsAlertFrameRotate" .. instance.mine_id, alert_bg)
	rotate_frame:SetWidth(12)
	rotate_frame:SetPoint("right", alert_bg, "right", -2, 0)
	rotate_frame:SetHeight(alert_bg:GetWidth())
	
	local icon = rotate_frame:CreateTexture(nil, "overlay")
	icon:SetPoint("center", rotate_frame, "center")
	icon:SetWidth(14)
	icon:SetHeight(14)
	
	local button = gump:NewButton(alert_bg, nil, "DetailsInstance"..instance.mine_id.."AlertButton", nil, 1, 1)
	button:SetAllPoints()
	button:SetHook("OnMouseUp", function() alert_bg:Hide() end)
	
	local RotateAnimGroup = rotate_frame:CreateAnimationGroup()
	local rotate = RotateAnimGroup:CreateAnimation("Rotation")
	rotate:SetDegrees(360)
	rotate:SetDuration(6)
	RotateAnimGroup:SetLooping("repeat")
	
	alert_bg:Hide()
	
	local anime = alert_bg:CreateAnimationGroup()
	anime.group = anime:CreateAnimation("Translation")
	anime.group:SetDuration(0.15)
	--anime.group:SetSmoothing("OUT")
	anime.group:SetOffset(0, 10)
	anime:SetScript("OnFinished", function(self) 
		alert_bg:Show()
		alert_bg:SetPoint("bottom", baseframe, "bottom", 0, 0)
		alert_bg:SetPoint("left", baseframe, "left", 3, 0)
		alert_bg:SetPoint("right", baseframe, "right", -3, 0)
	end)
	
	function alert_bg:Play()
		anime:Play()
	end
	
	alert_bg.text = text
	alert_bg.icon = icon
	alert_bg.button = button
	alert_bg.rotate = RotateAnimGroup
	
	instance.alert = alert_bg
	
	return alert_bg
end

function _details:InstanceMsg(text, icon, textcolor, icontexture, iconcoords, iconcolor)
	if (not text) then
		self.freeze_icon:Hide()
		return self.freeze_text:Hide()
	end
	
	self.freeze_text:SetText(text)
	self.freeze_icon:SetTexture(icon)

	self.freeze_icon:Show()
	self.freeze_text:Show()
	
	if (textcolor) then
		local r, g, b, a = gump:ParseColors(textcolor)
		self.freeze_text:SetTextColor(r, g, b, a)
	else
		self.freeze_text:SetTextColor(1, 1, 1, 1)
	end

	if (icontexture) then
		self.freeze_icon:SetTexture(icontexture)
	else
		self.freeze_icon:SetTexture([[Interface\CHARACTERFRAME\Disconnect-Icon]])
	end
	
	if (iconcoords and type(iconcoords) == "table") then
		self.freeze_icon:SetTexCoord(_unpack(iconcoords))
	else
		self.freeze_icon:SetTexCoord(0, 1, 0, 1)
	end
	
	if (iconcolor) then
		local r, g, b, a = gump:ParseColors(iconcolor)
		self.freeze_icon:SetVertexColor(r, g, b, a)
	else
		self.freeze_icon:SetVertexColor(1, 1, 1, 1)
	end
end

function _details:schedule_hide_anti_overlap(self)
	self:Hide()
	self.schdule = nil
end
local function hide_anti_overlap(self)
	if (self.schdule) then
		_details:CancelTimer(self.schdule)
		self.schdule = nil
	end
	local schdule = _details:ScheduleTimer("schedule_hide_anti_overlap", 0.3, self)
	self.schdule = schdule
end

local function show_anti_overlap(instance, host, side)

	local anti_menu_overlap = instance.baseframe.anti_menu_overlap

	if (anti_menu_overlap.schdule) then
		_details:CancelTimer(anti_menu_overlap.schdule)
		anti_menu_overlap.schdule = nil
	end

	anti_menu_overlap:ClearAllPoints()
	if (side == "top") then
		anti_menu_overlap:SetPoint("bottom", host, "top")
	elseif (side == "bottom") then
		anti_menu_overlap:SetPoint("top", host, "bottom")
	end
	anti_menu_overlap:Show()
end

_details.snap_alert = CreateFrame("frame", "DetailsSnapAlertFrame", UIParent)--, "ActionBarButtonSpellActivationAlert")
_details.snap_alert:Hide()
_details.snap_alert:SetFrameStrata("FULLSCREEN")

function _details:SnapAlert()
	_details.snap_alert:ClearAllPoints()
	_details.snap_alert:SetPoint("topleft", self.baseframe.header.novo, "topleft", -8, 6)
	_details.snap_alert:SetPoint("bottomright", self.baseframe.header.novo, "bottomright", 8, -6)
	--_details.snap_alert.animOut:Stop()
	--_details.snap_alert.animIn:Play()
end

do

	--search key: ~tooltip
	local tooltip_anchor = CreateFrame("frame", "DetailsTooltipAnchor", UIParent)
	tooltip_anchor:SetSize(140, 20)
	tooltip_anchor:SetAlpha(0)
	tooltip_anchor:SetMovable(false)
	tooltip_anchor:SetClampedToScreen(true)
	tooltip_anchor.locked = true
	tooltip_anchor:SetBackdrop({bgFile =[[Interface\Tooltips\UI-Tooltip-Background]], edgeFile =[[Interface\DialogFrame\UI-DialogBox-Border]], edgeSize = 10, insets = {left = 1, right = 1, top = 2, bottom = 1}})
	tooltip_anchor:SetBackdropColor(0, 0, 0, 1)

	tooltip_anchor:SetScript("OnEnter", function(self)
		tooltip_anchor.alert.animIn:Stop()
		tooltip_anchor.alert.animOut:Play()
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(Loc["STRING_OPTIONS_TOOLTIPS_ANCHOR_TEXT_DESC"])
		GameTooltip:Show()
	end)
	
	tooltip_anchor:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	tooltip_anchor:SetScript("OnMouseDown", function(self, button)
		if (not self.moving and button == "LeftButton") then
			self:StartMoving()
			self.moving = true
		end
	end)
	
	tooltip_anchor:SetScript("OnMouseUp", function(self, button)
		if (self.moving) then
			self:StopMovingOrSizing()
			self.moving = false
			local xofs, yofs = self:GetCenter() 
			local scale = self:GetEffectiveScale()
			local UIscale = UIParent:GetScale()
			xofs = xofs * scale - GetScreenWidth() * UIscale / 2
			yofs = yofs * scale - GetScreenHeight() * UIscale / 2
			_details.tooltip.anchor_screen_pos[1] = xofs / UIscale
			_details.tooltip.anchor_screen_pos[2] = yofs / UIscale
			
		elseif (button == "RightButton" and not self.moving) then
			tooltip_anchor:MoveAnchor()
		end
	end)
	
	function tooltip_anchor:MoveAnchor()
		if (self.locked) then
			self:SetAlpha(1)
			self:EnableMouse(true)
			self:SetMovable(true)
			self:SetFrameStrata("FULLSCREEN")
			self.locked = false
			tooltip_anchor.alert.animOut:Stop()
			tooltip_anchor.alert.animIn:Play()
		else
			self:SetAlpha(0)
			self:EnableMouse(false)
			self:SetFrameStrata("MEDIUM")
			self:SetMovable(false)
			self.locked = true
			tooltip_anchor.alert.animIn:Stop()
			tooltip_anchor.alert.animOut:Play()
		end
	end
	
	function tooltip_anchor:Restore()
		local x, y = _details.tooltip.anchor_screen_pos[1], _details.tooltip.anchor_screen_pos[2]
		local scale = self:GetEffectiveScale() 
		local UIscale = UIParent:GetScale()
		x = x * UIscale / scale
		y = y * UIscale / scale
		self:ClearAllPoints()
		self:SetParent(UIParent)
		self:SetPoint("center", UIParent, "center", x, y)
	end
	
	tooltip_anchor.alert = CreateFrame("frame", "DetailsTooltipAnchorAlert", UIParent)--, "ActionBarButtonSpellActivationAlert")
	tooltip_anchor.alert:SetFrameStrata("FULLSCREEN")
	tooltip_anchor.alert:Hide()
	tooltip_anchor.alert:SetPoint("topleft", tooltip_anchor, "topleft", -60, 6)
	tooltip_anchor.alert:SetPoint("bottomright", tooltip_anchor, "bottomright", 40, -6)

	local icon = tooltip_anchor:CreateTexture(nil, "overlay")
	icon:SetTexture([[Interface\AddOns\Details\images\minimap]])
	icon:SetPoint("left", tooltip_anchor, "left", 4, 0)
	icon:SetSize(18, 18)
	
	local text = tooltip_anchor:CreateFontString(nil, "overlay", "GameFontNormalSmall")
	text:SetPoint("left", icon, "right", 6, 0)
	text:SetText(Loc["STRING_OPTIONS_TOOLTIPS_ANCHOR_TEXT"])
	
	tooltip_anchor:EnableMouse(false)

end

--> ~start ~window ~window ~new ~start
function gump:CreateWindowMain(ID, instance, criando)

-- main frames -----------------------------------------------------------------------------------------------------------------------------------------------

	--> create the base frame, everything connect in this frame except the rows.
	local baseframe = CreateFrame("scrollframe", "DetailsBaseFrame"..ID, _UIParent) --
	baseframe:SetMovable(true)
	baseframe:SetResizable(true)
	baseframe:SetUserPlaced(false)

	baseframe.instance = instance
	baseframe:SetFrameStrata(baseframe_strata)
	baseframe:SetFrameLevel(2)

	--> background holds the wallpaper, alert strings ans textures, have setallpoints on baseframe
	--> backgrounddisplay is a scrollschild of backgroundframe
	local backgroundframe =  CreateFrame("scrollframe", "Details_WindowFrame"..ID, baseframe)
	local backgrounddisplay = CreateFrame("frame", "Details_GumpFrame"..ID, backgroundframe)
	backgroundframe:SetFrameLevel(3)
	backgrounddisplay:SetFrameLevel(3)
	backgroundframe.instance = instance
	backgrounddisplay.instance = instance

	--> row frame is the parent of rows, it have setallpoints on baseframe
	local rowframe = CreateFrame("frame", "DetailsRowFrame"..ID, _UIParent)
	rowframe:SetAllPoints(baseframe)
	rowframe:SetFrameStrata(baseframe_strata)
	rowframe:SetFrameLevel(2)
	instance.rowframe = rowframe
	
	--> right click bookmark
	local switchbutton = gump:NewDetailsButton(backgrounddisplay, baseframe, nil, function() end, nil, nil, 1, 1, "", "", "", "", 
	{rightFunc = {func = function() _details.switch:ShowMe(instance) end, param1 = nil, param2 = nil}}, "Details_SwitchButtonFrame" ..  ID)
	
	switchbutton:SetPoint("topleft", backgrounddisplay, "topleft")
	switchbutton:SetPoint("bottomright", backgrounddisplay, "bottomright")
	switchbutton:SetFrameLevel(backgrounddisplay:GetFrameLevel()+1)
	
	--> avoid mouse hover over a high window when the menu is open for a lower instance.
	local anti_menu_overlap = CreateFrame("frame", "Details_WindowFrameAntiMenuOverlap" .. ID, baseframe)
	anti_menu_overlap:SetSize(100, 13)
	anti_menu_overlap:SetFrameStrata("DIALOG")
	anti_menu_overlap:EnableMouse(true)
	anti_menu_overlap:Hide()
	baseframe.anti_menu_overlap = anti_menu_overlap

-- scroll bar -----------------------------------------------------------------------------------------------------------------------------------------------
--> create the scrollbar, almost not used.

	local scrollbar = CreateFrame("slider", "Details_ScrollBar"..ID, backgrounddisplay) --> scroll
	
	--> scroll image-node up
		baseframe.scroll_up = backgrounddisplay:CreateTexture(nil, "background")
		baseframe.scroll_up:SetPoint("topleft", backgrounddisplay, "topright", 0, 0)
		baseframe.scroll_up:SetTexture(DEFAULT_SKIN)
		baseframe.scroll_up:SetTexCoord(unpack(COORDS_SLIDER_TOP))
		baseframe.scroll_up:SetWidth(32)
		baseframe.scroll_up:SetHeight(32)
	
	--> scroll image-node down
		baseframe.scroll_down = backgrounddisplay:CreateTexture(nil, "background")
		baseframe.scroll_down:SetPoint("bottomleft", backgrounddisplay, "bottomright", 0, 0)
		baseframe.scroll_down:SetTexture(DEFAULT_SKIN)
		baseframe.scroll_down:SetTexCoord(unpack(COORDS_SLIDER_DOWN))
		baseframe.scroll_down:SetWidth(32)
		baseframe.scroll_down:SetHeight(32)
	
	--> scroll image-node middle
		baseframe.scroll_middle = backgrounddisplay:CreateTexture(nil, "background")
		baseframe.scroll_middle:SetPoint("top", baseframe.scroll_up, "bottom", 0, 8)
		baseframe.scroll_middle:SetPoint("bottom", baseframe.scroll_down, "top", 0, -11)
		baseframe.scroll_middle:SetTexture(DEFAULT_SKIN)
		baseframe.scroll_middle:SetTexCoord(unpack(COORDS_SLIDER_MIDDLE))
		baseframe.scroll_middle:SetWidth(32)
		baseframe.scroll_middle:SetHeight(64)
	
	--> scroll widgets
		baseframe.button_up = CreateFrame("button", "DetailsScrollUp" .. instance.mine_id, backgrounddisplay)
		baseframe.button_down = CreateFrame("button", "DetailsScrollDown" .. instance.mine_id, backgrounddisplay)
	
		baseframe.button_up:SetWidth(29)
		baseframe.button_up:SetHeight(32)
		baseframe.button_up:SetNormalTexture([[Interface\BUTTONS\UI-ScrollBar-ScrollUpButton-Up]])
		baseframe.button_up:SetPushedTexture([[Interface\BUTTONS\UI-ScrollBar-ScrollUpButton-Down]])
		baseframe.button_up:SetDisabledTexture([[Interface\BUTTONS\UI-ScrollBar-ScrollUpButton-Disabled]])
		baseframe.button_up:Disable()

		baseframe.button_down:SetWidth(29)
		baseframe.button_down:SetHeight(32)
		baseframe.button_down:SetNormalTexture([[Interface\BUTTONS\UI-ScrollBar-ScrollDownButton-Up]])
		baseframe.button_down:SetPushedTexture([[Interface\BUTTONS\UI-ScrollBar-ScrollDownButton-Down]])
		baseframe.button_down:SetDisabledTexture([[Interface\BUTTONS\UI-ScrollBar-ScrollDownButton-Disabled]])
		baseframe.button_down:Disable()

		baseframe.button_up:SetPoint("topright", baseframe.scroll_up, "topright", -4, 3)
		baseframe.button_down:SetPoint("bottomright", baseframe.scroll_down, "bottomright", -4, -6)

		scrollbar:SetPoint("top", baseframe.button_up, "bottom", 0, 12)
		scrollbar:SetPoint("bottom", baseframe.button_down, "top", 0, -12)
		scrollbar:SetPoint("left", backgrounddisplay, "right", 3, 0)
		scrollbar:Show()

		--> config set
		scrollbar:SetOrientation("VERTICAL")
		scrollbar.scrollMax = 0
		scrollbar:SetMinMaxValues(0, 0)
		scrollbar:SetValue(0)
		scrollbar.ultimo = 0
		
		--> thumb
		scrollbar.thumb = scrollbar:CreateTexture(nil, "overlay")
		scrollbar.thumb:SetTexture([[Interface\Buttons\UI-ScrollBar-Knob]])
		scrollbar.thumb:SetSize(29, 30)
		scrollbar:SetThumbTexture(scrollbar.thumb)
		
		--> scripts
		button_down_scripts(baseframe, backgrounddisplay, instance, scrollbar)
		button_up_scripts(baseframe, backgrounddisplay, instance, scrollbar)
	
-- stretch button -----------------------------------------------------------------------------------------------------------------------------------------------

		baseframe.button_stretch = CreateFrame("button", "DetailsButtonStretch" .. instance.mine_id, baseframe)
		baseframe.button_stretch:SetPoint("bottom", baseframe, "top", 0, 20)
		baseframe.button_stretch:SetPoint("right", baseframe, "right", -27, 0)
		baseframe.button_stretch:SetFrameLevel(15)
		
		local stretch_texture = baseframe.button_stretch:CreateTexture(nil, "overlay")
		stretch_texture:SetTexture(DEFAULT_SKIN)
		stretch_texture:SetTexCoord(unpack(COORDS_STRETCH))
		stretch_texture:SetWidth(32)
		stretch_texture:SetHeight(16)
		stretch_texture:SetAllPoints(baseframe.button_stretch)
		baseframe.button_stretch.texture = stretch_texture
		
		baseframe.button_stretch:SetWidth(32)
		baseframe.button_stretch:SetHeight(16)
		
		baseframe.button_stretch:Show()
		gump:Fade(baseframe.button_stretch, "ALPHA", 0)

		button_stretch_scripts(baseframe, backgrounddisplay, instance)

-- main window config -------------------------------------------------------------------------------------------------------------------------------------------------

		baseframe:SetClampedToScreen(true)
		baseframe:SetSize(_details.new_window_size.width, _details.new_window_size.height)
		
		baseframe:SetPoint("center", _UIParent)
		baseframe:EnableMouseWheel(false)
		baseframe:EnableMouse(true)
		baseframe:SetMinResize(150, 7)
		baseframe:SetMaxResize(_details.max_window_size.width, _details.max_window_size.height)

		baseframe:SetBackdrop(gump_fundo_backdrop)
		baseframe:SetBackdropColor(instance.bg_r, instance.bg_g, instance.bg_b, instance.bg_alpha)
	
-- background window config -------------------------------------------------------------------------------------------------------------------------------------------------

		backgroundframe:SetAllPoints(baseframe)
		backgroundframe:SetScrollChild(backgrounddisplay)
		
		backgrounddisplay:SetResizable(true)
		backgrounddisplay:SetPoint("topleft", baseframe, "topleft")
		backgrounddisplay:SetPoint("bottomright", baseframe, "bottomright")
		backgrounddisplay:SetBackdrop(gump_fundo_backdrop)
		backgrounddisplay:SetBackdropColor(instance.bg_r, instance.bg_g, instance.bg_b, instance.bg_alpha)
	
-- instance mini widgets -------------------------------------------------------------------------------------------------------------------------------------------------

	--> freeze icon
		instance.freeze_icon = backgrounddisplay:CreateTexture(nil, "overlay")
			instance.freeze_icon:SetWidth(64)
			instance.freeze_icon:SetHeight(64)
			instance.freeze_icon:SetPoint("center", backgrounddisplay, "center")
			instance.freeze_icon:SetPoint("left", backgrounddisplay, "left")
			instance.freeze_icon:Hide()
	
		instance.freeze_text = backgrounddisplay:CreateFontString(nil, "overlay", "GameFontNormalSmall")
			instance.freeze_text:SetHeight(64)
			instance.freeze_text:SetPoint("left", instance.freeze_icon, "right", -18, 0)
			instance.freeze_text:SetTextColor(1, 1, 1)
			instance.freeze_text:Hide()
	
	--> details version
		instance._version = baseframe:CreateFontString(nil, "overlay", "GameFontNormalSmall")
			--instance._version:SetPoint("left", backgrounddisplay, "left", 20, 0)
			instance._version:SetTextColor(1, 1, 1)
			instance._version:SetText("this is a alpha version of Details\nyou can help us sending bug reports\nuse the blue button.")
			if (not _details.initializing) then
				
			end
			instance._version:Hide()
			

	--> wallpaper
		baseframe.wallpaper = backgrounddisplay:CreateTexture(nil, "overlay")
		baseframe.wallpaper:Hide()
	
	--> alert frame
		baseframe.alert = CreateAlertFrame(baseframe, instance)
	
-- resizers & lock button ------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> right resizer
		baseframe.resize_right = CreateFrame("button", "Details_Resize_Direita"..ID, baseframe)
		
		local resize_right_texture = baseframe.resize_right:CreateTexture(nil, "overlay")
		resize_right_texture:SetWidth(16)
		resize_right_texture:SetHeight(16)
		resize_right_texture:SetTexture(DEFAULT_SKIN)
		resize_right_texture:SetTexCoord(unpack(COORDS_RESIZE_RIGHT))
		resize_right_texture:SetAllPoints(baseframe.resize_right)
		baseframe.resize_right.texture = resize_right_texture

		baseframe.resize_right:SetWidth(16)
		baseframe.resize_right:SetHeight(16)
		baseframe.resize_right:SetPoint("bottomright", baseframe, "bottomright", 0, 0)
		baseframe.resize_right:EnableMouse(true)
		baseframe.resize_right:SetFrameStrata("HIGH")
		baseframe.resize_right:SetFrameLevel(baseframe:GetFrameLevel() + 6)
		baseframe.resize_right.side = 2

	--> lock window button
		baseframe.lock_button = CreateFrame("button", "Details_Lock_Button"..ID, baseframe)
		baseframe.lock_button:SetPoint("right", baseframe.resize_right, "left", -1, 1.5)
		baseframe.lock_button:SetFrameLevel(baseframe:GetFrameLevel() + 6)
		baseframe.lock_button:SetWidth(40)
		baseframe.lock_button:SetHeight(16)
		baseframe.lock_button.label = baseframe.lock_button:CreateFontString(nil, "overlay", "GameFontNormal")
		baseframe.lock_button.label:SetPoint("right", baseframe.lock_button, "right")
		baseframe.lock_button.label:SetTextColor(.3, .3, .3, .6)
		baseframe.lock_button.label:SetJustifyH("right")
		baseframe.lock_button.label:SetText(Loc["STRING_LOCK_WINDOW"])
		baseframe.lock_button:SetWidth(baseframe.lock_button.label:GetStringWidth()+2)
		baseframe.lock_button:SetScript("OnClick", lockFunctionOnClick)
		baseframe.lock_button:SetScript("OnEnter", lockFunctionOnEnter)
		baseframe.lock_button:SetScript("OnLeave", lockFunctionOnLeave)
		baseframe.lock_button:SetScript("OnHide", lockFunctionOnHide)
		baseframe.lock_button:SetFrameStrata("HIGH")
		baseframe.lock_button:SetFrameLevel(baseframe:GetFrameLevel() + 6)
		baseframe.lock_button.instance = instance
		
	--> left resizer
		baseframe.resize_left = CreateFrame("button", "Details_Resize_Esquerda"..ID, baseframe)
		
		local resize_left_texture = baseframe.resize_left:CreateTexture(nil, "overlay")
		resize_left_texture:SetWidth(16)
		resize_left_texture:SetHeight(16)
		resize_left_texture:SetTexture(DEFAULT_SKIN)
		resize_left_texture:SetTexCoord(unpack(COORDS_RESIZE_LEFT))
		resize_left_texture:SetAllPoints(baseframe.resize_left)
		baseframe.resize_left.texture = resize_left_texture

		baseframe.resize_left:SetWidth(16)
		baseframe.resize_left:SetHeight(16)
		baseframe.resize_left:SetPoint("bottomleft", baseframe, "bottomleft", 0, 0)
		baseframe.resize_left:EnableMouse(true)
		baseframe.resize_left:SetFrameStrata("HIGH")
		baseframe.resize_left:SetFrameLevel(baseframe:GetFrameLevel() + 6)
	
		baseframe.resize_left:SetAlpha(0)
		baseframe.resize_right:SetAlpha(0)
	
		if (instance.isLocked) then
			instance.isLocked = not instance.isLocked
			lockFunctionOnClick(baseframe.lock_button)
		end
	
		gump:Fade(baseframe.lock_button, -1, 3.0)

-- scripts ------------------------------------------------------------------------------------------------------------------------------------------------------------

	BFrame_scripts(baseframe, instance)

	BGFrame_scripts(switchbutton, baseframe, instance)
	BGFrame_scripts(backgrounddisplay, baseframe, instance)
	
	iterate_scroll_scripts(backgrounddisplay, backgroundframe, baseframe, scrollbar, instance)
	

-- create toolbar ----------------------------------------------------------------------------------------------------------------------------------------------------------

	gump:CreateCabecalho(baseframe, instance)
	
-- create statusbar ----------------------------------------------------------------------------------------------------------------------------------------------------------		

	gump:CreateRodape(baseframe, instance)

-- left and right side bars ------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ~bar ~bordas ~border
		local floatingframe = CreateFrame("frame", "DetailsInstance"..ID.."BorderHolder", baseframe)
		floatingframe:SetFrameLevel(baseframe:GetFrameLevel()+7)
		instance.floatingframe = floatingframe
	--> left
		baseframe.bar_left = floatingframe:CreateTexture(nil, "artwork")
		baseframe.bar_left:SetTexture(DEFAULT_SKIN)
		baseframe.bar_left:SetTexCoord(unpack(COORDS_LEFT_SIDE_BAR))
		baseframe.bar_left:SetWidth(64)
		baseframe.bar_left:SetHeight(512)
		baseframe.bar_left:SetPoint("topleft", baseframe, "topleft", -56, 0)
		baseframe.bar_left:SetPoint("bottomleft", baseframe, "bottomleft", -56, -14)
	--> right
		baseframe.bar_right = floatingframe:CreateTexture(nil, "artwork")
		baseframe.bar_right:SetTexture(DEFAULT_SKIN)
		baseframe.bar_right:SetTexCoord(unpack(COORDS_RIGHT_SIDE_BAR))
		baseframe.bar_right:SetWidth(64)
		baseframe.bar_right:SetHeight(512)
		baseframe.bar_right:SetPoint("topright", baseframe, "topright", 56, 0)
		baseframe.bar_right:SetPoint("bottomright", baseframe, "bottomright", 56, -14)
	--> bottom
		baseframe.bar_fundo = floatingframe:CreateTexture(nil, "artwork")
		baseframe.bar_fundo:SetTexture(DEFAULT_SKIN)
		baseframe.bar_fundo:SetTexCoord(unpack(COORDS_BOTTOM_SIDE_BAR))
		baseframe.bar_fundo:SetWidth(512)
		baseframe.bar_fundo:SetHeight(64)
		baseframe.bar_fundo:SetPoint("bottomleft", baseframe, "bottomleft", 0, -56)
		baseframe.bar_fundo:SetPoint("bottomright", baseframe, "bottomright", 0, -56)

-- break snap button ----------------------------------------------------------------------------------------------------------------------------------------------------------

		instance.break_snap_button = CreateFrame("button", "DetailsBreakSnapButton" .. ID, baseframe.header.close)
		instance.break_snap_button:SetPoint("bottom", baseframe.resize_right, "top", -1, 0)
		instance.break_snap_button:SetFrameLevel(baseframe:GetFrameLevel() + 5)
		instance.break_snap_button:SetSize(13, 13)
		instance.break_snap_button:SetAlpha(0)
		
		instance.break_snap_button.instance = instance
		
		instance.break_snap_button:SetScript("OnClick", function()
			instance:Ungroup(-1)
		end)
		
		instance.break_snap_button:SetScript("OnEnter", unSnapButtonOnEnter)
		instance.break_snap_button:SetScript("OnLeave", unSnapButtonOnLeave)
		

		instance.break_snap_button:SetNormalTexture(DEFAULT_SKIN)
		instance.break_snap_button:SetDisabledTexture(DEFAULT_SKIN)
		instance.break_snap_button:SetHighlightTexture(DEFAULT_SKIN, "ADD")
		instance.break_snap_button:SetPushedTexture(DEFAULT_SKIN)
		
		instance.break_snap_button:GetNormalTexture():SetTexCoord(unpack(COORDS_UNLOCK_BUTTON))
		instance.break_snap_button:GetDisabledTexture():SetTexCoord(unpack(COORDS_UNLOCK_BUTTON))
		instance.break_snap_button:GetHighlightTexture():SetTexCoord(unpack(COORDS_UNLOCK_BUTTON))
		instance.break_snap_button:GetPushedTexture():SetTexCoord(unpack(COORDS_UNLOCK_BUTTON))
	
-- scripts ------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
		resize_scripts(baseframe.resize_right, instance, scrollbar, ">", baseframe)
		resize_scripts(baseframe.resize_left, instance, scrollbar, "<", baseframe)
	
-- side bars highlights ------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> top
		local fcima = CreateFrame("frame", "DetailsTopSideBarHighlight" .. instance.mine_id, baseframe.header.close)
		gump:CreateFlashAnimation(fcima)
		fcima:Hide()
		
		instance.h_cima = fcima:CreateTexture(nil, "overlay")
		instance.h_cima:SetTexture([[Interface\AddOns\Details\images\highlight_updown]])
		instance.h_cima:SetTexCoord(0, 1, 0.5, 1)
		instance.h_cima:SetPoint("topleft", baseframe.header.top_bg, "bottomleft", -10, 37)
		instance.h_cima:SetPoint("topright", baseframe.header.ball_r, "bottomright", -97, 37)
		instance.h_cima:SetDesaturated(true)
		fcima.texture = instance.h_cima
		instance.h_cima = fcima
		
	--> bottom
		local fbaixo = CreateFrame("frame", "DetailsBottomSideBarHighlight" .. instance.mine_id, baseframe.header.close)
		gump:CreateFlashAnimation(fbaixo)
		fbaixo:Hide()
		
		instance.h_baixo = fbaixo:CreateTexture(nil, "overlay")
		instance.h_baixo:SetTexture([[Interface\AddOns\Details\images\highlight_updown]])
		instance.h_baixo:SetTexCoord(0, 1, 0, 0.5)
		instance.h_baixo:SetPoint("topleft", baseframe.rodape.left, "bottomleft", 16, 17)
		instance.h_baixo:SetPoint("topright", baseframe.rodape.right, "bottomright", -16, 17)
		instance.h_baixo:SetDesaturated(true)
		fbaixo.texture = instance.h_baixo
		instance.h_baixo = fbaixo
		
	--> left
		local fleft = CreateFrame("frame", "DetailsLeftSideBarHighlight" .. instance.mine_id, baseframe.header.close)
		gump:CreateFlashAnimation(fleft)
		fleft:Hide()
		
		instance.h_left = fleft:CreateTexture(nil, "overlay")
		instance.h_left:SetTexture([[Interface\AddOns\Details\images\highlight_leftright]])
		instance.h_left:SetTexCoord(0.5, 1, 0, 1)
		instance.h_left:SetPoint("topleft", baseframe.bar_left, "topleft", 40, 0)
		instance.h_left:SetPoint("bottomleft", baseframe.bar_left, "bottomleft", 40, 0)
		instance.h_left:SetDesaturated(true)
		fleft.texture = instance.h_left
		instance.h_left = fleft
		
	--> right
		local fright = CreateFrame("frame", "DetailsRightSideBarHighlight" .. instance.mine_id, baseframe.header.close)
		gump:CreateFlashAnimation(fright)	
		fright:Hide()
		
		instance.h_right = fright:CreateTexture(nil, "overlay")
		instance.h_right:SetTexture([[Interface\AddOns\Details\images\highlight_leftright]])
		instance.h_right:SetTexCoord(0, 0.5, 1, 0)
		instance.h_right:SetPoint("topleft", baseframe.bar_right, "topleft", 8, 18)
		instance.h_right:SetPoint("bottomleft", baseframe.bar_right, "bottomleft", 8, 0)
		instance.h_right:SetDesaturated(true)
		fright.texture = instance.h_right
		instance.h_right = fright

--> done

	if (criando) then
		local CProps = {
			["altura"] = 100,
			["width"] = 200,
			["bars"] = 50,
			["barsvisiveis"] = 0,
			["x"] = 0,
			["y"] = 0,
			["w"] = 0,
			["h"] = 0
		}
		instance.locs = CProps
	end

	return baseframe, backgroundframe, backgrounddisplay, scrollbar
	
end

function _details:SetBarGrowDirection(direction)

	if (not direction) then
		direction = self.bars_grow_direction
	end
	
	self.bars_grow_direction = direction
	
	local x = self.row_info.space.left
	
	if (direction == 1) then --> top to bottom
		for index, row in _ipairs(self.bars) do
			local y = self.row_height *(index - 1)
			y = y * -1
			row:ClearAllPoints()
			row:SetPoint("topleft", self.baseframe, "topleft", x, y)
			
		end
		
	elseif (direction == 2) then --> bottom to top
		for index, row in _ipairs(self.bars) do
			local y = self.row_height *(index - 1)
			row:ClearAllPoints()
			row:SetPoint("bottomleft", self.baseframe, "bottomleft", x, y + 2)
		end
		
	end
	
	--> update all row width
	if (self.bar_mod and self.bar_mod ~= 0) then
		for index = 1, #self.bars do
			self.bars[index]:SetWidth(self.baseframe:GetWidth() + self.bar_mod)
		end
	else
		for index = 1, #self.bars do
			self.bars[index]:SetWidth(self.baseframe:GetWidth()+self.row_info.space.right)
		end
	end
end

--> Alias
function gump:NewRow(instance, index)
	return gump:CreateNewBar(instance, index)
end

_details.bars_criadas = 0

--> search key: ~row ~bar
function gump:CreateNewBar(instance, index)

	--> instance = window object, index = row number
	local baseframe = instance.baseframe
	local rowframe = instance.rowframe
	
	--> create the bar with rowframe as parent
	local new_row = CreateFrame("button", "DetailsBar_"..instance.mine_id.."_"..index, rowframe)
	
	new_row.row_id = index
	new_row.instance_id = instance.mine_id
	new_row.animation_end = 0
	new_row.animation_end2 = 0
	
	--> set point, almost irrelevant here, it recalc this on SetBarGrowDirection()
	local y = instance.row_height *(index-1)
	if (instance.bars_grow_direction == 1) then
		y = y*-1
		new_row:SetPoint("topleft", baseframe, "topleft", instance.row_info.space.left, y)
		
	elseif (instance.bars_grow_direction == 2) then
		new_row:SetPoint("bottomleft", baseframe, "bottomleft", instance.row_info.space.left, y + 2)
	end
	
	--> row height
	new_row:SetHeight(instance.row_info.height)
	new_row:SetWidth(baseframe:GetWidth()+instance.row_info.space.right)
	new_row:SetFrameLevel(baseframe:GetFrameLevel() + 4)
	new_row.last_value = 0
	new_row.w_mod = 0
	new_row:EnableMouse(true)
	new_row:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	
	--> statusbar
	new_row.statusbar = CreateFrame("StatusBar", "DetailsBar_Statusbar_"..instance.mine_id.."_"..index, new_row)
	--> frame for hold the backdrop border
	new_row.border = CreateFrame("Frame", "DetailsBar_Border_" .. instance.mine_id .. "_" .. index, new_row.statusbar)
	new_row.border:SetFrameLevel(new_row.statusbar:GetFrameLevel()+1)
	new_row.border:SetAllPoints(new_row)
	
	--> create textures and icons
	new_row.texture = new_row.statusbar:CreateTexture(nil, "artwork")
	new_row.texture:SetHorizTile(false)
	new_row.texture:SetVertTile(false)
	
	--> row background texture
	new_row.background = new_row:CreateTexture(nil, "background")
	new_row.background:SetTexture()
	new_row.background:SetAllPoints(new_row)

	new_row.statusbar:SetStatusBarColor(0, 0, 0, 0)
	new_row.statusbar:SetStatusBarTexture(new_row.texture)
	new_row.statusbar:SetMinMaxValues(0, 100)
	new_row.statusbar:SetValue(0)

	--> class icon
	local icon_class = new_row.statusbar:CreateTexture(nil, "overlay")
	icon_class:SetHeight(instance.row_info.height)
	icon_class:SetWidth(instance.row_info.height)
	icon_class:SetTexture(instance.row_info.icon_file)
	icon_class:SetTexCoord(.75, 1, .75, 1)
	new_row.icon_class = icon_class

	icon_class:SetPoint("left", new_row, "left")
	new_row.statusbar:SetPoint("topleft", icon_class, "topright")
	new_row.statusbar:SetPoint("bottomright", new_row, "bottomright")
	
	--> left text
	new_row.text_left = new_row.statusbar:CreateFontString(nil, "overlay", "GameFontHighlight")
	new_row.text_left:SetPoint("left", new_row.icon_class, "right", 3, 0)
	new_row.text_left:SetJustifyH("left")
	new_row.text_left:SetNonSpaceWrap(true)

	--> right text
	new_row.text_right = new_row.statusbar:CreateFontString(nil, "overlay", "GameFontHighlight")
	new_row.text_right:SetPoint("right", new_row.statusbar, "right")
	new_row.text_right:SetJustifyH("right")
	
	--> set the onclick, on enter scripts
	bar_scripts(new_row, instance, index)

	--> hide
	gump:Fade(new_row, 1) 

	--> adds the window container
	instance.bars[index] = new_row
	
	--> set the left text
	new_row.text_left:SetText(Loc["STRING_NEWROW"])
	
	--> refresh rows
	instance:InstanceRefreshRows()
	
	_details:SendEvent("DETAILS_INSTANCE_NEWROW", nil, instance, new_row)
	
	return new_row
end

function _details:SetBarTextSettings(size, font, fixedcolor, leftcolorbyclass, rightcolorbyclass, leftoutline, rightoutline, customrighttextenabled, customrighttext, percentage_type, showposition, customlefttextenabled, customlefttext)
	
	--> size
	if (size) then
		self.row_info.font_size = size
	end

	--> font
	if (font) then
		self.row_info.font_face = font
		self.row_info.font_face_file = SharedMedia:Fetch("font", font)
	end

	--> fixed color
	if (fixedcolor) then
		local red, green, blue, alpha = gump:ParseColors(fixedcolor)
		local c = self.row_info.fixed_text_color
		c[1], c[2], c[3], c[4] = red, green, blue, alpha
	end
	
	--> left color by class
	if (type(leftcolorbyclass) == "boolean") then
		self.row_info.textL_class_colors = leftcolorbyclass
	end
	
	--> right color by class
	if (type(rightcolorbyclass) == "boolean") then
		self.row_info.textR_class_colors = rightcolorbyclass
	end
	
	--> left text outline
	if (type(leftoutline) == "boolean") then
		self.row_info.textL_outline = leftoutline
	end
	
	--> right text outline
	if (type(rightoutline) == "boolean") then
		self.row_info.textR_outline = rightoutline
	end
	
	--> custom left text
	if (type(customlefttextenabled) == "boolean") then
		self.row_info.textL_enable_custom_text = customlefttextenabled
	end
	if (customlefttext) then
		self.row_info.textL_custom_text = customlefttext
	end

	--> custom right text
	if (type(customrighttextenabled) == "boolean") then
		self.row_info.textR_enable_custom_text = customrighttextenabled
	end
	if (customrighttext) then
		self.row_info.textR_custom_text = customrighttext
	end
	
	--> percent type
	if (percentage_type) then
		self.row_info.percent_type = percentage_type
	end
	
	--> show position number
	if (type(showposition) == "boolean") then
		self.row_info.textL_show_number = showposition
	end
	
	self:InstanceReset()
	self:InstanceRefreshRows()
end

function _details:SetBarBackdropSettings(enabled, size, color, texture)

	if (type(enabled) ~= "boolean") then
		enabled = self.row_info.backdrop.enabled
	end
	if (not size) then
		size = self.row_info.backdrop.size
	end
	if (not color) then
		color = self.row_info.backdrop.color
	end
	if (not texture) then
		texture = self.row_info.backdrop.texture
	end
	
	self.row_info.backdrop.enabled = enabled
	self.row_info.backdrop.size = size
	self.row_info.backdrop.color = color
	self.row_info.backdrop.texture = texture
	
	self:InstanceReset()
	self:InstanceRefreshRows()
	self:ReadjustGump()
end

function _details:SetBarSettings(height, texture, colorclass, fixedcolor, backgroundtexture, backgroundcolorclass, backgroundfixedcolor, alpha, iconfile, barstart, spacement)
	
	--> bar start
	if (type(barstart) == "boolean") then
		self.row_info.start_after_icon = barstart
	end
	
	--> icon file
	if (iconfile) then
		self.row_info.icon_file = iconfile
		if (iconfile == "") then
			self.row_info.no_icon = true
		else
			self.row_info.no_icon = false
		end
	end
	
	--> alpha
	if (alpha) then
		self.row_info.alpha = alpha
	end
	
	--> height
	if (height) then
		self.row_info.height = height
		self.row_height = height + self.row_info.space.between
	end
	
	--> spacement
	if (spacement) then
		self.row_info.space.between = spacement
		self.row_height = self.row_info.height + spacement
	end
	
	--> texture
	if (texture) then
		self.row_info.texture = texture
		self.row_info.texture_file = SharedMedia:Fetch("statusbar", texture)
	end
	
	--> color by class
	if (type(colorclass) == "boolean") then
		self.row_info.texture_class_colors = colorclass
	end
	
	--> fixed color
	if (fixedcolor) then
		local red, green, blue, alpha = gump:ParseColors(fixedcolor)
		local c = self.row_info.fixed_texture_color
		c[1], c[2], c[3], c[4] = red, green, blue, alpha
	end
	
	--> background texture
	if (backgroundtexture) then
		self.row_info.texture_background = backgroundtexture
		self.row_info.texture_background_file = SharedMedia:Fetch("statusbar", backgroundtexture)
	end
	
	--> background color by class
	if (type(backgroundcolorclass) == "boolean") then
		self.row_info.texture_background_class_color = backgroundcolorclass
	end
	
	--> background fixed color
	if (backgroundfixedcolor) then
		local red, green, blue, alpha = gump:ParseColors(backgroundfixedcolor)
		local c =  self.row_info.fixed_texture_background_color
		c[1], c[2], c[3], c[4] = red, green, blue, alpha
	end

	self:InstanceReset()
	self:InstanceRefreshRows()
	self:ReadjustGump()

end

--/script _details:InstanceRefreshRows(_details.table_instances[1])

-- search key: ~row
function _details:InstanceRefreshRows(instance)

	if (instance) then
		self = instance
	end

	if (not self.bars or not self.bars[1]) then
		return
	end
	
	--> texture
		local texture_file = SharedMedia:Fetch("statusbar", self.row_info.texture)
		local texture_file2 = SharedMedia:Fetch("statusbar", self.row_info.texture_background)
	
	--> outline values
		local left_text_outline = self.row_info.textL_outline
		local right_text_outline = self.row_info.textR_outline
	
	--> texture color values
		local texture_class_color = self.row_info.texture_class_colors
		local texture_r, texture_g, texture_b
		if (not texture_class_color) then
			texture_r, texture_g, texture_b = _unpack(self.row_info.fixed_texture_color)
		end
	
	--text color
		local left_text_class_color = self.row_info.textL_class_colors
		local right_text_class_color = self.row_info.textR_class_colors
		local text_r, text_g, text_b
		if (not left_text_class_color or not right_text_class_color) then
			text_r, text_g, text_b = _unpack(self.row_info.fixed_text_color)
		end
		
		local height = self.row_info.height
	
	--alpha
		local alpha = self.row_info.alpha
	
	--icons
		local no_icon = self.row_info.no_icon
		local icon_texture = self.row_info.icon_file
		local start_after_icon = self.row_info.start_after_icon
	
	--custom right text
		local custom_right_text_enabled = self.row_info.textR_enable_custom_text
		local custom_right_text = self.row_info.textR_custom_text

	--backdrop
		local backdrop = self.row_info.backdrop.enabled
		local backdrop_color
		if (backdrop) then
			backdrop = {edgeFile = SharedMedia:Fetch("border", self.row_info.backdrop.texture), edgeSize = self.row_info.backdrop.size}
			backdrop_color = self.row_info.backdrop.color
		end
		
	--font face
		self.row_info.font_face_file = SharedMedia:Fetch("font", self.row_info.font_face)
		
	-- do it

	for _, row in _ipairs(self.bars) do 

		--> positioning and size
		row:SetHeight(height)
		row.icon_class:SetHeight(height)
		row.icon_class:SetWidth(height)
		
		--> icon
		if (no_icon) then
			row.statusbar:SetPoint("topleft", row, "topleft")
			row.statusbar:SetPoint("bottomright", row, "bottomright")
			row.text_left:SetPoint("left", row.statusbar, "left", 2, 0)
			row.icon_class:Hide()
		else
			if (start_after_icon) then
				row.statusbar:SetPoint("topleft", row.icon_class, "topright")
			else
				row.statusbar:SetPoint("topleft", row, "topleft")
			end
			
			row.statusbar:SetPoint("bottomright", row, "bottomright")
			row.text_left:SetPoint("left", row.icon_class, "right", 3, 0)
			row.icon_class:Show()
		end
	
		if (not self.row_info.texture_background_class_color) then
			local c = self.row_info.fixed_texture_background_color
			row.background:SetVertexColor(c[1], c[2], c[3], c[4])
		else
			local c = self.row_info.fixed_texture_background_color
			local r, g, b = row.background:GetVertexColor()
			row.background:SetVertexColor(r, g, b, c[4])
		end
	
		--> outline
		if (left_text_outline) then
			_details:SetFontOutline(row.text_left, left_text_outline)
		else
			_details:SetFontOutline(row.text_left, nil)
		end
		
		if (right_text_outline) then
			self:SetFontOutline(row.text_right, right_text_outline)
		else
			self:SetFontOutline(row.text_right, nil)
		end
		
		--> texture:
		row.texture:SetTexture(texture_file)
		row.background:SetTexture(texture_file2)
		
		--> texture class color: if true color changes on the fly through class refresh
		if (not texture_class_color) then
			row.texture:SetVertexColor(texture_r, texture_g, texture_b, alpha)
		else
			local r, g, b = row.texture:GetVertexColor()
			row.texture:SetVertexColor(r, g, b, alpha)
		end
		
		--> text class color: if true color changes on the fly through class refresh
		if (not left_text_class_color) then
			row.text_left:SetTextColor(text_r, text_g, text_b)
		end
		if (not right_text_class_color) then
			row.text_right:SetTextColor(text_r, text_g, text_b)
		end
		
		--> text size
		_details:SetFontSize(row.text_left, self.row_info.font_size or height * 0.75)
		_details:SetFontSize(row.text_right, self.row_info.font_size or height * 0.75)
		
		--> text font
		_details:SetFontFace(row.text_left, self.row_info.font_face_file or "GameFontHighlight")
		_details:SetFontFace(row.text_right, self.row_info.font_face_file or "GameFontHighlight")

		--backdrop
		if (backdrop) then
			row.border:SetBackdrop(backdrop)
			row.border:SetBackdropBorderColor(_unpack(backdrop_color))
		else
			row.border:SetBackdrop(nil)
		end
		
	end
	
	self:SetBarGrowDirection()

end

-- search key: ~wallpaper
function _details:InstanceWallpaper(texture, anchor, alpha, texcoord, width, height, overlay)

	local wallpaper = self.wallpaper
	
	if (type(texture) == "boolean" and texture) then
		texture, anchor, alpha, texcoord, width, height, overlay = wallpaper.texture, wallpaper.anchor, wallpaper.alpha, wallpaper.texcoord, wallpaper.width, wallpaper.height, wallpaper.overlay
		
	elseif (type(texture) == "boolean" and not texture) then
		self.wallpaper.enabled = false
		return gump:Fade(self.baseframe.wallpaper, "in")
		
	elseif (type(texture) == "table") then
		anchor = texture.anchor or wallpaper.anchor
		alpha = texture.alpha or wallpaper.alpha
		if (texture.texcoord) then
			texcoord = {unpack(texture.texcoord)}
		else
			texcoord = wallpaper.texcoord
		end
		width = texture.width or wallpaper.width
		height = texture.height or wallpaper.height
		if (texture.overlay) then
			overlay = {unpack(texture.overlay)}
		else
			overlay = wallpaper.overlay
		end
		
		if (type(texture.enabled) == "boolean") then
			if (not texture.enabled) then
				wallpaper.enabled = false
				wallpaper.texture = texture.texture or wallpaper.texture
				wallpaper.anchor = anchor
				wallpaper.alpha = alpha
				wallpaper.texcoord = texcoord
				wallpaper.width = width
				wallpaper.height = height
				wallpaper.overlay = overlay
				return self:InstanceWallpaper(false)
			end
		end
		
		texture = texture.texture or wallpaper.texture

	else
		texture = texture or wallpaper.texture
		anchor = anchor or wallpaper.anchor
		alpha = alpha or wallpaper.alpha
		texcoord = texcoord or wallpaper.texcoord
		width = width or wallpaper.width
		height = height or wallpaper.height
		overlay = overlay or wallpaper.overlay
	end
	
	if (not wallpaper.texture and not texture) then
		local spec = GetPrimaryTalentTree()
		if (spec) then
			local _, _, _, _, _background = GetTalentTabInfo(spec)
			if (_background) then
				texture = "Interface\\TALENTFRAME\\".._background
			end
		end
		
		texcoord = {0, 1, 0, 0.7}
		alpha = 0.5
		width, height = self:GetSize()
		anchor = "all"
	end
	
	local t = self.baseframe.wallpaper

	t:ClearAllPoints()
	
	if (anchor == "all") then
		t:SetPoint("topleft", self.baseframe, "topleft")
		t:SetPoint("bottomright", self.baseframe, "bottomright")
	elseif (anchor == "center") then
		t:SetPoint("center", self.baseframe, "center", 0, 4)
	elseif (anchor == "stretchLR") then
		t:SetPoint("center", self.baseframe, "center")
		t:SetPoint("left", self.baseframe, "left")
		t:SetPoint("right", self.baseframe, "right")
	elseif (anchor == "stretchTB") then
		t:SetPoint("center", self.baseframe, "center")
		t:SetPoint("top", self.baseframe, "top")
		t:SetPoint("bottom", self.baseframe, "bottom")
	else
		t:SetPoint(anchor, self.baseframe, anchor)
	end
	
	t:SetTexture(texture)
	t:SetTexCoord(unpack(texcoord))
	t:SetWidth(width)
	t:SetHeight(height)
	t:SetVertexColor(unpack(overlay))
	
	wallpaper.enabled = true
	wallpaper.texture = texture
	wallpaper.anchor = anchor
	wallpaper.alpha = alpha
	wallpaper.texcoord = texcoord
	wallpaper.width = width
	wallpaper.height = height
	wallpaper.overlay = overlay

	t:Show()
	--t:SetAlpha(alpha)
	gump:Fade(t, "ALPHAANIM", alpha)

end

function _details:GetTextures()
	local t = {}
	t[1] = self.baseframe.rodape.left
	t[2] = self.baseframe.rodape.right
	t[3] = self.baseframe.rodape.top_bg
	
	t[4] = self.baseframe.header.ball_r
	t[5] = self.baseframe.header.ball
	t[6] = self.baseframe.header.emenda
	t[7] = self.baseframe.header.top_bg
	
	t[8] = self.baseframe.bar_left
	t[9] = self.baseframe.bar_right
	t[10] = self.baseframe.UPFrame
	return t
	--attribute_icon é uma exceção
end

function _details:SetWindowAlphaForInteract(alpha)
	
	local ignorebars = self.menu_alpha.ignorebars
	
	if (self.is_interacting) then
		--> entrou
		--self.baseframe:SetAlpha(alpha)
		self:InstanceAlpha(alpha)
		self:SetIconAlpha(alpha, nil, true)
		
		if (ignorebars) then
			self.rowframe:SetAlpha(1)
		else
			self.rowframe:SetAlpha(alpha)
		end
	else
		--> saiu
		if (self.combat_changes_alpha) then --> combat alpha
			--self.baseframe:SetAlpha(self.combat_changes_alpha)
			self:InstanceAlpha(self.combat_changes_alpha)
			self:SetIconAlpha(self.combat_changes_alpha, nil, true)
			self.rowframe:SetAlpha(self.combat_changes_alpha) --alpha do combat é absofight
		else
			--self.baseframe:SetAlpha(alpha)
			self:InstanceAlpha(alpha)
			self:SetIconAlpha(alpha, nil, true)
			
			if (ignorebars) then
				self.rowframe:SetAlpha(1)
			else
				self.rowframe:SetAlpha(alpha)
			end
		end

	end
	
end

function _details:SetWindowAlphaForCombat(entering_in_combat, true_hide)

	local amount, rowsamount, menuamount

	--get the values
	if (entering_in_combat) then
		amount = self.hide_in_combat_alpha / 100
		self.combat_changes_alpha = amount
		rowsamount = amount
		menuamount = amount
		if (_details.pet_battle) then
			amount = 0
			rowsamount = 0
			menuamount = 0
		end
	else
		if (self.menu_alpha.enabled) then --auto transparency
			if (self.is_interacting) then
				amount = self.menu_alpha.onenter
				menuamount = self.menu_alpha.onenter
				if (self.menu_alpha.ignorebars) then
					rowsamount = 1
				else
					rowsamount = amount
				end
			else
				amount = self.menu_alpha.onleave
				menuamount = self.menu_alpha.onleave
				if (self.menu_alpha.ignorebars) then
					rowsamount = 1
				else
					rowsamount = amount
				end
			end
		else
			amount = self.color[4]
			menuamount = 1
			rowsamount = 1
		end
		self.combat_changes_alpha = nil
	end

	--print("baseframe:",amount,"rowframe:",rowsamount,"menu:",menuamount)
	
	--apply
	if (true_hide and amount == 0) then
		gump:Fade(self.baseframe, _unpack(_details.windows_fade_in))
		gump:Fade(self.rowframe, _unpack(_details.windows_fade_in))
		self:SetIconAlpha(nil, true)
	else
	
		self.baseframe:Show()
		self.baseframe:SetAlpha(1)
		
		--gump:Fade(self.baseframe, "ALPHAANIM", amount)
		self:InstanceAlpha(amount)
		gump:Fade(self.rowframe, "ALPHAANIM", rowsamount)
		self:SetIconAlpha(menuamount)
	end
	
	if (self.show_statusbar) then
		self.baseframe.bar_fundo:Hide()
	end
	if (self.hide_icon) then
		self.baseframe.header.attribute_icon:Hide()
	end

end

function _details:InstanceButtonsColors(red, green, blue, alpha, no_save, only_left, only_right)
	
	if (not red) then
		red, green, blue, alpha = unpack(self.color_buttons)
	end
	
	if (type(red) ~= "number") then
		red, green, blue, alpha = gump:ParseColors(red)
	end
	
	if (not no_save) then
		self.color_buttons[1] = red
		self.color_buttons[2] = green
		self.color_buttons[3] = blue
		self.color_buttons[4] = alpha
	end
	
	local baseToolbar = self.baseframe.header
	

	if (only_left) then
	
		local icons = {baseToolbar.mode_selecao, baseToolbar.segment, baseToolbar.attribute, baseToolbar.report}
		
		for _, button in _ipairs(icons) do 
			button:SetAlpha(alpha)
		end

		if (self:IsLowerInstance()) then
			for _, ThisButton in _ipairs(_details.ToolBar.Shown) do
				ThisButton:SetAlpha(alpha)
			end
		end
		
	elseif (only_right) then
	
		local icons = {baseToolbar.novo, baseToolbar.close, baseToolbar.reset}
		
		for _, button in _ipairs(icons) do 
			button:SetAlpha(alpha)
		end

	else
		
		local icons = {baseToolbar.mode_selecao, baseToolbar.segment, baseToolbar.attribute, baseToolbar.report, baseToolbar.novo, baseToolbar.close, baseToolbar.reset}
		
		for _, button in _ipairs(icons) do 
			button:SetAlpha(alpha)
		end
		
		if (self:IsLowerInstance()) then
			for _, ThisButton in _ipairs(_details.ToolBar.Shown) do
				ThisButton:SetAlpha(alpha)
			end
		end
	
	end
end

function _details:InstanceAlpha(alpha)
	self.baseframe.header.ball_r:SetAlpha(alpha)
	self.baseframe.header.ball:SetAlpha(alpha)
	self.baseframe.header.attribute_icon:SetAlpha(alpha)
	self.baseframe.header.emenda:SetAlpha(alpha)
	self.baseframe.header.top_bg:SetAlpha(alpha)
	self.baseframe.bar_left:SetAlpha(alpha)
	self.baseframe.bar_right:SetAlpha(alpha)
	self.baseframe.bar_fundo:SetAlpha(alpha)
	self.baseframe.UPFrame:SetAlpha(alpha)
end

function _details:InstanceColor(red, green, blue, alpha, no_save, change_statusbar)

	if (not red) then
		red, green, blue, alpha = unpack(self.color)
		no_save = true
	end

	if (type(red) ~= "number") then
		red, green, blue, alpha = gump:ParseColors(red)
	end

	if (not no_save) then
		--> saving
		self.color[1] = red
		self.color[2] = green
		self.color[3] = blue
		self.color[4] = alpha
		if (change_statusbar) then
			self:StatusBarColor(red, green, blue, alpha)
		end
	else
		--> not saving
		self:StatusBarColor(nil, nil, nil, alpha, true)
	end

	local skin = _details.skins[self.skin]
	
	--[[
	self.baseframe.rodape.left:SetVertexColor(red, green, blue)
		self.baseframe.rodape.left:SetAlpha(alpha)
	self.baseframe.rodape.right:SetVertexColor(red, green, blue)
		self.baseframe.rodape.right:SetAlpha(alpha)
	self.baseframe.rodape.top_bg:SetVertexColor(red, green, blue)
		self.baseframe.rodape.top_bg:SetAlpha(alpha)
	--]]
	
	self.baseframe.header.ball_r:SetVertexColor(red, green, blue)
		self.baseframe.header.ball_r:SetAlpha(alpha)
		
	self.baseframe.header.ball:SetVertexColor(red, green, blue)
	self.baseframe.header.ball:SetAlpha(alpha)
	
	self.baseframe.header.attribute_icon:SetAlpha(alpha)

	self.baseframe.header.emenda:SetVertexColor(red, green, blue)
		self.baseframe.header.emenda:SetAlpha(alpha)
	self.baseframe.header.top_bg:SetVertexColor(red, green, blue)
		self.baseframe.header.top_bg:SetAlpha(alpha)

	self.baseframe.bar_left:SetVertexColor(red, green, blue)
		self.baseframe.bar_left:SetAlpha(alpha)
	self.baseframe.bar_right:SetVertexColor(red, green, blue)
		self.baseframe.bar_right:SetAlpha(alpha)
	self.baseframe.bar_fundo:SetVertexColor(red, green, blue)
		self.baseframe.bar_fundo:SetAlpha(alpha)
		
	self.baseframe.UPFrame:SetAlpha(alpha)

	--self.color[1], self.color[2], self.color[3], self.color[4] = red, green, blue, alpha
end

function _details:StatusBarAlertTime(instance)
	instance.baseframe.statusbar:Hide()
end

function _details:StatusBarAlert(text, icon, color, time)

	local statusbar = self.baseframe.statusbar
	
	if (text) then
		if (type(text) == "table") then
			if (text.color) then
				statusbar.text:SetTextColor(gump:ParseColors(text.color))
			else
				statusbar.text:SetTextColor(1, 1, 1, 1)
			end
			
			statusbar.text:SetText(text.text or "")
			
			if (text.size) then
				_details:SetFontSize(statusbar.text, text.size)
			else
				_details:SetFontSize(statusbar.text, 9)
			end
		else
			statusbar.text:SetText(text)
			statusbar.text:SetTextColor(1, 1, 1, 1)
			_details:SetFontSize(statusbar.text, 9)
		end
	else
		statusbar.text:SetText("")
	end
	
	if (icon) then
		if (type(icon) == "table") then
			local texture, w, h, l, r, t, b = unpack(icon)
			statusbar.icon:SetTexture(texture)
			statusbar.icon:SetWidth(w or 14)
			statusbar.icon:SetHeight(h or 14)
			if (l and r and t and b) then
				statusbar.icon:SetTexCoord(l, r, t, b)
			end
		else
			statusbar.icon:SetTexture(icon)
			statusbar.icon:SetWidth(14)
			statusbar.icon:SetHeight(14)
			statusbar.icon:SetTexCoord(0, 1, 0, 1)
		end
	else
		statusbar.icon:SetTexture(nil)
	end
	
	if (color) then
		statusbar:SetBackdropColor(gump:ParseColors(color))
	else
		statusbar:SetBackdropColor(0, 0, 0, 1)
	end
	
	if (icon or text) then
		statusbar:Show()
		if (time) then
			_details:ScheduleTimer("StatusBarAlertTime", time, self)
		end
	else
		statusbar:Hide()
	end
end


function gump:CreateRodape(baseframe, instance)

	baseframe.rodape = {}
	
	--> left
	baseframe.rodape.left = baseframe.header.close:CreateTexture(nil, "overlay")
	baseframe.rodape.left:SetPoint("topright", baseframe, "bottomleft", 16, 0)
	baseframe.rodape.left:SetTexture(DEFAULT_SKIN)
	baseframe.rodape.left:SetTexCoord(unpack(COORDS_PIN_LEFT))
	baseframe.rodape.left:SetWidth(32)
	baseframe.rodape.left:SetHeight(32)
	
	--> direito
	baseframe.rodape.right = baseframe.header.close:CreateTexture(nil, "overlay")
	baseframe.rodape.right:SetPoint("topleft", baseframe, "bottomright", -16, 0)
	baseframe.rodape.right:SetTexture(DEFAULT_SKIN)
	baseframe.rodape.right:SetTexCoord(unpack(COORDS_PIN_RIGHT))
	baseframe.rodape.right:SetWidth(32)
	baseframe.rodape.right:SetHeight(32)
	
	--> bar centro
	baseframe.rodape.top_bg = baseframe:CreateTexture(nil, "background")
	baseframe.rodape.top_bg:SetTexture(DEFAULT_SKIN)
	baseframe.rodape.top_bg:SetTexCoord(unpack(COORDS_BOTTOM_BACKGROUND))
	baseframe.rodape.top_bg:SetWidth(512)
	baseframe.rodape.top_bg:SetHeight(128)
	baseframe.rodape.top_bg:SetPoint("left", baseframe.rodape.left, "right", -16, -48)
	baseframe.rodape.top_bg:SetPoint("right", baseframe.rodape.right, "left", 16, -48)

	local StatusBarLeftAnchor = CreateFrame("frame", "DetailsStatusBarAnchorLeft" .. instance.mine_id, baseframe)
	StatusBarLeftAnchor:SetPoint("left", baseframe.rodape.top_bg, "left", 5, 57)
	StatusBarLeftAnchor:SetWidth(1)
	StatusBarLeftAnchor:SetHeight(1)
	baseframe.rodape.StatusBarLeftAnchor = StatusBarLeftAnchor
	
	local StatusBarCenterAnchor = CreateFrame("frame", "DetailsStatusBarAnchorCenter" .. instance.mine_id, baseframe)
	StatusBarCenterAnchor:SetPoint("center", baseframe.rodape.top_bg, "center", 0, 57)
	StatusBarCenterAnchor:SetWidth(1)
	StatusBarCenterAnchor:SetHeight(1)
	baseframe.rodape.StatusBarCenterAnchor = StatusBarCenterAnchor
	
	--> display frame
		baseframe.statusbar = CreateFrame("frame", "DetailsStatusBar" .. instance.mine_id, baseframe.header.close)
		baseframe.statusbar:SetFrameLevel(baseframe.header.close:GetFrameLevel()+2)
		baseframe.statusbar:SetPoint("left", baseframe.rodape.left, "right", -13, 10)
		baseframe.statusbar:SetPoint("right", baseframe.rodape.right, "left", 13, 10)
		baseframe.statusbar:SetHeight(14)
		
		local statusbar_icon = baseframe.statusbar:CreateTexture(nil, "overlay")
		statusbar_icon:SetWidth(14)
		statusbar_icon:SetHeight(14)
		statusbar_icon:SetPoint("left", baseframe.statusbar, "left")
		
		local statusbar_text = baseframe.statusbar:CreateFontString(nil, "overlay", "GameFontNormal")
		statusbar_text:SetPoint("left", statusbar_icon, "right", 2, 0)
		
		baseframe.statusbar:SetBackdrop({
		bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
		insets = {left = 0, right = 0, top = 0, bottom = 0}})
		baseframe.statusbar:SetBackdropColor(0, 0, 0, 1)
		
		baseframe.statusbar.icon = statusbar_icon
		baseframe.statusbar.text = statusbar_text
		baseframe.statusbar.instance = instance
		
		baseframe.statusbar:Hide()
	
	--> frame invisível
	baseframe.DOWNFrame = CreateFrame("frame", "DetailsDownFrame" .. instance.mine_id, baseframe)
	baseframe.DOWNFrame:SetPoint("left", baseframe.rodape.left, "right", 0, 10)
	baseframe.DOWNFrame:SetPoint("right", baseframe.rodape.right, "left", 0, 10)
	baseframe.DOWNFrame:SetHeight(14)
	
	baseframe.DOWNFrame:Show()
	baseframe.DOWNFrame:EnableMouse(true)
	baseframe.DOWNFrame:SetMovable(true)
	baseframe.DOWNFrame:SetResizable(true)
	
	BGFrame_scripts(baseframe.DOWNFrame, baseframe, instance)
end

function _details:CheckConsolidates()
	for mine_id, instance in ipairs(_details.table_instances) do 
		if (instance.consolidate and mine_id ~= _details.lower_instance) then
			instance:UnConsolidateIcons()
		end
	end
end

function _details:ConsolidateIcons()

	self.consolidate = true
	
	self.consolidateButton:Show()
	
	self:ToolbarMenuButtons()
	
	return self:MenuAnchor()
end

function _details:UnConsolidateIcons()

	self.consolidate = false
	
	if (not self.consolidateButton) then
		return self:ToolbarMenuButtons()
	end
	
	self.consolidateButton:Hide()
	
	self:ToolbarMenuButtons()
	
	return self:MenuAnchor()
end

function _details:GetMenuAnchorPoint()
	local toolbar_side = self.toolbar_side
	local menu_side = self.menu_anchor.side
	
	if (menu_side == 1) then --left
		if (toolbar_side == 1) then --top
			return self.menu_points[1], "bottomleft", "bottomright"
		elseif (toolbar_side == 2) then --bottom
			return self.menu_points[1], "topleft", "topright"
		end
	elseif (menu_side == 2) then --right
		if (toolbar_side == 1) then --top
			return self.menu_points[2], "topleft", "bottomleft"
		elseif (toolbar_side == 2) then --bottom
			return self.menu_points[2], "topleft", "topleft"
		end
	end
end
function _details:GetMenu2AnchorPoint()
	local toolbar_side = self.toolbar_side
	if (toolbar_side == 1) then --top
		return self.menu2_points[1], "topright", "bottomleft"
	elseif (toolbar_side == 2) then --bottom
		return self.menu2_points[1], "topleft", "topleft"
	end
end

--> search key: ~icon
function _details:ToolbarMenuButtonsSize(size)
	size = size or self.menu_icons_size
	self.menu_icons_size = size
	return self:ToolbarMenuButtons()
end
function _details:ToolbarMenu2ButtonsSize(size)
	size = size or self.menu2_icons_size
	self.menu2_icons_size = size
	return self:ToolbarMenu2Buttons()
end

local SetIconAlphaCacheButtonsTable = {}
function _details:SetIconAlpha(alpha, hide, no_animations)

	if (self.attribute_text.enabled) then
		if (not self.menu_attribute_string) then --> create on demand
			self:AttributeMenu()
		end
		
		if (hide) then
			gump:Fade(self.menu_attribute_string.widget, _unpack(_details.windows_fade_in))
		else
			if (no_animations) then
				self.menu_attribute_string:SetAlpha(alpha)
			else
				gump:Fade(self.menu_attribute_string.widget, "ALPHAANIM", alpha)
			end
		end
	end
	
	table.wipe(SetIconAlphaCacheButtonsTable)
	SetIconAlphaCacheButtonsTable[1] = self.baseframe.header.mode_selecao
	SetIconAlphaCacheButtonsTable[2] = self.baseframe.header.segment
	SetIconAlphaCacheButtonsTable[3] = self.baseframe.header.attribute
	SetIconAlphaCacheButtonsTable[4] = self.baseframe.header.report

	for index, button in _ipairs(SetIconAlphaCacheButtonsTable) do
		if (self.menu_icons[index]) then
			if (hide) then
				gump:Fade(button, _unpack(_details.windows_fade_in))	
			else
				if (no_animations) then
					button:SetAlpha(alpha)
				else
					gump:Fade(button, "ALPHAANIM", alpha)
				end
			end
		end
	end
	
	table.wipe(SetIconAlphaCacheButtonsTable)
	SetIconAlphaCacheButtonsTable[1] = self.baseframe.header.close
	SetIconAlphaCacheButtonsTable[2] = self.baseframe.header.novo
	SetIconAlphaCacheButtonsTable[3] = self.baseframe.header.reset
	
	for index, button in _ipairs(SetIconAlphaCacheButtonsTable) do
		if (self.menu2_icons[index]) then
			if (hide) then
				gump:Fade(button, _unpack(_details.windows_fade_in))	
			else
				if (no_animations) then
					button:SetAlpha(alpha)
				else
					gump:Fade(button, "ALPHAANIM", alpha)
				end
			end
		end
	end
	
	if (self:IsLowerInstance()) then
		if (#_details.ToolBar.Shown > 0) then
			for index, button in ipairs(_details.ToolBar.Shown) do
				if (hide) then
					gump:Fade(button, _unpack(_details.windows_fade_in))		
				else
					if (no_animations) then
						button:SetAlpha(alpha)
					else
						gump:Fade(button, "ALPHAANIM", alpha)
					end
				end
			end
		end
	end
end

function _details:ToolbarMenuButtons(_mode, _segment, _attributes, _report)

	if (_mode == nil) then
		_mode = self.menu_icons[1]
	end
	if (_segment == nil) then
		_segment = self.menu_icons[2]
	end
	if (_attributes == nil) then
		_attributes = self.menu_icons[3]
	end
	if (_report == nil) then
		_report = self.menu_icons[4]
	end	

	self.menu_icons[1] = _mode
	self.menu_icons[2] = _segment
	self.menu_icons[3] = _attributes
	self.menu_icons[4] = _report
	
	local buttons = {self.baseframe.header.mode_selecao, self.baseframe.header.segment, self.baseframe.header.attribute, self.baseframe.header.report}
	
	local anchor_frame, point1, point2 = self:GetMenuAnchorPoint()
	local got_anchor = false
	self.lastIcon = nil
	
	local size = self.menu_icons_size
	
	--> normal buttons
	for index, button in _ipairs(buttons) do
		if (self.menu_icons[index]) then
			button:ClearAllPoints()
			if (got_anchor) then
				button:SetPoint("left", self.lastIcon, "right")
			else
				button:SetPoint(point1, anchor_frame, point2)
				got_anchor = button
			end
			self.lastIcon = button
			button:SetParent(self.baseframe)
			button:SetFrameLevel(self.baseframe.UPFrame:GetFrameLevel()+1)
			button:Show()
			
			if (buttons[4] == button) then
				button:SetSize(8*size, 16*size)
			else
				button:SetSize(16*size, 16*size)
			end
		else
			button:Hide()
		end
	end
	
	--> plugins buttons
	if (self:IsLowerInstance()) then
		if (#_details.ToolBar.Shown > 0) then
			for index, button in ipairs(_details.ToolBar.Shown) do 
				button:ClearAllPoints()
				if (got_anchor) then
					if (self.plugins_grow_direction == 2) then --right(default)
						if (self.lastIcon == buttons[4]) then
							button:SetPoint("left", self.lastIcon.widget or self.lastIcon, "right", 2, 0) --, button.x, button.y
						else
							button:SetPoint("left", self.lastIcon.widget or self.lastIcon, "right") --, button.x, button.y
						end
					elseif (self.plugins_grow_direction == 1) then --left
						if (index == 1) then
							button:SetPoint("right", got_anchor.widget or got_anchor, "left") --, button.x, button.y
						else
							button:SetPoint("right", self.lastIcon.widget or self.lastIcon, "left") --, button.x, button.y
						end
					end
				else
					button:SetPoint(point1, anchor_frame, point2)
					got_anchor = button
				end
				self.lastIcon = button
				button:SetParent(self.baseframe)
				button:SetFrameLevel(self.baseframe.UPFrame:GetFrameLevel()+1)
				button:Show()
				
				button:SetSize(16*size, 16*size)
			end
		end
	end
	
	return true
end

function _details:ToolbarMenu2Buttons(_close, _instance, _reset)
	if (_close == nil) then
		_close = self.menu2_icons[1]
	end
	if (_instance == nil) then
		_instance = self.menu2_icons[2]
	end
	if (_reset == nil) then
		_reset = self.menu2_icons[3]
	end
	
	self.menu2_icons[1] = _close
	self.menu2_icons[2] = _instance
	self.menu2_icons[3] = _reset
	
	local buttons = {self.baseframe.header.close, self.baseframe.header.novo, self.baseframe.header.reset}
	local config = {self.closebutton_config, self.instancebutton_config, self.resetbutton_config}
	
	local anchor_frame, point1, point2 = self:GetMenu2AnchorPoint() -- self.menu2_points[1], "topleft", "bottomleft"
	local got_anchor = false
	local lastIcon = nil
	
	local size = self.menu2_icons_size
	local default_texcoord = {0, 1, 0, 1}
	local default_vertexcolor = {1, 1, 1, 1}
	--> normal buttons
	for index, button in ipairs(buttons) do
		if (self.menu2_icons[index]) then

			local button_config = config[index]
			button:ClearAllPoints()
			
			if (got_anchor) then
				button:SetPoint("right", lastIcon, "left", button_config.anchor[1], button_config.anchor[2])
			else
				button:SetPoint(point1, anchor_frame, point2, button_config.anchor[1], button_config.anchor[2])
				got_anchor = button
			end
			
			button:SetSize(button_config.size[1] * size, button_config.size[2] * size)
			
			local normal_texture = button:GetNormalTexture()
			local highlight_texture = button:GetHighlightTexture()
			local pushed_texture = button:GetPushedTexture()
			
			if normal_texture then
				normal_texture:SetTexture(button_config.normal_texture)
			else
				button:SetNormalTexture(button_config.normal_texture)
			end
			
			if highlight_texture then
				highlight_texture:SetTexture(button_config.highlight_texture)
			else
				button:SetHighlightTexture(button_config.normal_texture)
			end
			
			if pushed_texture then
				pushed_texture:SetTexture(button_config.pushed_texture or button_config.normal_texture)
			else
				button:SetPushedTexture(button_config.pushed_texture)
			end
			local normal_texture = button:GetNormalTexture()
			local highlight_texture = button:GetHighlightTexture()
			local pushed_texture = button:GetPushedTexture()
			
			if (button_config.normal_texcoord) then
				normal_texture:SetTexCoord(unpack(button_config.normal_texcoord))
			else
				normal_texture:SetTexCoord(unpack(default_texcoord))
			end

			if (button_config.highlight_texcoord) then
				highlight_texture:SetTexCoord(unpack(button_config.highlight_texcoord))
			else
				if (button_config.normal_texcoord and button_config.normal_texture == button_config.highlight_texture) then
					highlight_texture:SetTexCoord(unpack(button_config.normal_texcoord))
				else
					highlight_texture:SetTexCoord(unpack(default_texcoord))
				end
			end
			
			if (button_config.pushed_texcoord) then
				pushed_texture:SetTexCoord(unpack(button_config.pushed_texcoord))
			else
				if (button_config.normal_texcoord and(not button_config.pushed_texture or button_config.normal_texture == button_config.pushed_texture)) then
					pushed_texture:SetTexCoord(unpack(button_config.normal_texcoord))
				else
					pushed_texture:SetTexCoord(unpack(default_texcoord))
				end
			end
			
			if (button_config.normal_vertexcolor) then
				normal_texture:SetVertexColor(unpack(button_config.normal_vertexcolor))
			else
				normal_texture:SetVertexColor(unpack(default_vertexcolor))
			end
			
			if (button_config.highlight_vertexcolor) then
				highlight_texture:SetVertexColor(unpack(button_config.highlight_vertexcolor))
			else
				if (button_config.normal_vertexcolor and button_config.normal_texture == button_config.highlight_texture) then
					highlight_texture:SetVertexColor(unpack(button_config.normal_vertexcolor))
				else
					highlight_texture:SetVertexColor(unpack(default_vertexcolor))
				end
			end
			
			if (button_config.pushed_vertexcolor) then
				pushed_texture:SetVertexColor(unpack(button_config.pushed_vertexcolor))
			else
				if (button_config.normal_vertexcolor and button_config.normal_texture == button_config.pushed_texture) then
					pushed_texture:SetVertexColor(unpack(button_config.normal_vertexcolor))
				else
					pushed_texture:SetVertexColor(unpack(default_vertexcolor))
				end
			end

			if (button_config.alpha) then
				button:GetNormalTexture():SetAlpha(button_config.alpha)
				button:GetHighlightTexture():SetAlpha(button_config.alpha)
				button:GetPushedTexture():SetAlpha(button_config.alpha)
			end
			
			lastIcon = button
			button:SetParent(self.baseframe)
			button:SetFrameLevel(self.baseframe.UPFrame:GetFrameLevel()+1)
			button:Show()
			
		else
			button:Hide()
		end
	end
	
	self:ToolbarMenu2InstanceButtonSettings()
	
	return true
end

function _details:ToolbarMenu2InstanceButtonSettings(color, font, size, shadow)
	
	if (not color) then
		color = self.instancebutton_config.textcolor
	end
	if (not font) then
		font = self.instancebutton_config.textfont
	end
	if (not size) then
		size = self.instancebutton_config.textsize
	end
	if (shadow == nil) then
		shadow = self.instancebutton_config.textshadow
	end
	
	self.instancebutton_config.textcolor = color
	self.instancebutton_config.textfont = font
	self.instancebutton_config.textsize = size
	self.instancebutton_config.textshadow = shadow
	
	local fontstring = self.baseframe.header.novo:GetFontString()
	
	_details:SetFontSize(fontstring, size)
	_details:SetFontFace(fontstring, SharedMedia:Fetch("font", font))
	_details:SetFontColor(fontstring, color)
	_details:SetFontOutline(fontstring, shadow)

end

local parameters_table = {}

local on_leave_menu = function(self, elapsed)
	parameters_table[2] = parameters_table[2] + elapsed
	if (parameters_table[2] > 0.3) then
		if (not _G.GameCooltip.mouseOver and not _G.GameCooltip.buttonOver and(not _G.GameCooltip:GetOwner() or _G.GameCooltip:GetOwner() == self)) then
			_G.GameCooltip:ShowMe(false)
		end
		self:SetScript("OnUpdate", nil)
	end
end

local build_mode_list = function(self, elapsed)

	local CoolTip = GameCooltip
	local instance = parameters_table[1]
	parameters_table[2] = parameters_table[2] + elapsed
	
	if (parameters_table[2] > 0.15) then
		self:SetScript("OnUpdate", nil)
		
		CoolTip:Reset()
		CoolTip:SetType("menu")
		CoolTip:SetLastSelected("main", parameters_table[3])
		CoolTip:SetFixedParameter(instance)
		CoolTip:SetColor("main", "transparent")
		
		CoolTip:SetOption("TextSize", _details.font_sizes.menus)
		CoolTip:SetOption("ButtonHeightModSub", -5)
		CoolTip:SetOption("ButtonHeightMod", -5)
		CoolTip:SetOption("ButtonsYModSub", -5)
		CoolTip:SetOption("ButtonsYMod", -5)
		CoolTip:SetOption("YSpacingModSub", 1)
		CoolTip:SetOption("YSpacingMod", 1)
		CoolTip:SetOption("FixedHeight", 106)
		CoolTip:SetOption("FixedWidthSub", 146)
		
		--CoolTip:SetOption("SubMenuIsTooltip", true)
		
		--if (_details.tutorial.logons > 9) then
			--CoolTip:SetOption("IgnoreSubMenu", true)
		--end
		
		CoolTip:AddLine(Loc["STRING_MODE_GROUP"])
		CoolTip:AddMenu(1, instance.ChangeMode, 2, true)
		CoolTip:AddIcon([[Interface\AddOns\Details\images\mode_icons]], 1, 1, 20, 20, 32/256, 32/256*2, 0, 1)
		--CoolTip:AddLine(Loc["STRING_HELP_MODEGROUP"], nil, 2)
		--CoolTip:AddIcon([[Interface\TUTORIALFRAME\TutorialFrame-QuestionMark]], 2, 1, 16, 16, 8/64, 1 -(8/64), 8/64, 1 -(8/64))
		
		CoolTip:AddLine(Loc["STRING_MODE_ALL"])
		CoolTip:AddMenu(1, instance.ChangeMode, 3, true)
		CoolTip:AddIcon([[Interface\AddOns\Details\images\mode_icons]], 1, 1, 20, 20, 32/256*2, 32/256*3, 0, 1)
		--CoolTip:AddLine(Loc["STRING_HELP_MODEALL"], nil, 2)
		--CoolTip:AddIcon([[Interface\TUTORIALFRAME\TutorialFrame-QuestionMark]], 2, 1, 16, 16, 8/64, 1 -(8/64), 8/64, 1 -(8/64))
	
		CoolTip:AddLine(Loc["STRING_MODE_RAID"])
		CoolTip:AddMenu(1, instance.ChangeMode, 4, true)
		CoolTip:AddIcon([[Interface\AddOns\Details\images\mode_icons]], 1, 1, 20, 20, 32/256*3, 32/256*4, 0, 1)
		--CoolTip:AddLine(Loc["STRING_HELP_MODERAID"], nil, 2)
		--CoolTip:AddIcon([[Interface\TUTORIALFRAME\TutorialFrame-QuestionMark]], 2, 1, 16, 16, 8/64, 1 -(8/64), 8/64, 1 -(8/64))

		--build raid plugins list
		local available_plugins = _details.RaidTables:GetAvailablePlugins()

		if (#available_plugins >= 0) then
			local amt = 0
			
			for index, ptable in _ipairs(available_plugins) do
				if (ptable[3].__enabled) then
					CoolTip:AddMenu(2, _details.RaidTables.EnableRaidMode, instance, ptable[4], true, ptable[1], ptable[2], true) --PluginName, PluginIcon, PluginObject, PluginAbsoluteName
					amt = amt + 1
				end
			end
			
			CoolTip:SetWallpaper(2,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
			
			if (amt <= 3) then
				CoolTip:SetOption("SubFollowButton", true)
			end
		end
		
		CoolTip:AddLine(Loc["STRING_MODE_SELF"])
		CoolTip:AddMenu(1, instance.ChangeMode, 1, true)
		CoolTip:AddIcon([[Interface\AddOns\Details\images\mode_icons]], 1, 1, 20, 20, 0, 32/256, 0, 1)
		--CoolTip:AddLine(Loc["STRING_HELP_MODESELF"], nil, 2)
		--CoolTip:AddIcon([[Interface\TUTORIALFRAME\TutorialFrame-QuestionMark]], 2, 1, 16, 16, 8/64, 1 -(8/64), 8/64, 1 -(8/64))
		
		--build self plugins list
		
		CoolTip:AddLine(Loc["STRING_OPTIONS_WINDOW"])
		CoolTip:AddMenu(1, _details.OpenOptionsWindow)
		CoolTip:AddIcon([[Interface\AddOns\Details\images\mode_icons]], 1, 1, 20, 20, 32/256*4, 32/256*5, 0, 1)
		
		--CoolTip:AddFromTable(parameters_table[4])
		
		if (instance.consolidate) then
			CoolTip:SetOwner(self, "topleft", "topright", 3)
		else
			if (instance.toolbar_side == 1) then
				CoolTip:SetOwner(self)
			elseif (instance.toolbar_side == 2) then --> bottom
				CoolTip:SetOwner(self, "bottom", "top", 0, 0) -- -7
			end
		end
		
		--CoolTip:SetWallpaper(1,[[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Horizontal-Desaturated]], nil, {1, 1, 1, 0.3})
		CoolTip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
		CoolTip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		
		show_anti_overlap(instance, self, "top")
		
		CoolTip:ShowCooltip()
	end
end

local segments_used = 0
local segments_filled = 0
local empty_segment_color = {1, 1, 1, .4}

-- search key: ~segments
local build_segment_list = function(self, elapsed)

	local CoolTip = GameCooltip
	local instance = parameters_table[1]
	parameters_table[2] = parameters_table[2] + elapsed
	
	if (parameters_table[2] > 0.15) then
		self:SetScript("OnUpdate", nil)
	
		--> here we are using normal Add calls
		CoolTip:Reset()
		CoolTip:SetType("menu")
		CoolTip:SetFixedParameter(instance)
		CoolTip:SetColor("main", "transparent")

		CoolTip:SetOption("FixedWidthSub", 175)
		CoolTip:SetOption("RightTextWidth", 105)
		CoolTip:SetOption("RightTextHeight", 12)
		
		----------- segments
		local menuIndex = 0
		_details.segments_amount = math.floor(_details.segments_amount)
		
		local fight_amount = 0
		
		local filled_segments = 0
		for i = 1, _details.segments_amount do
			if (_details.table_history.tables[i]) then
				filled_segments = filled_segments + 1
			else
				break
			end
		end

		filled_segments = _details.segments_amount - filled_segments - 2
		local fill = math.abs(filled_segments - _details.segments_amount)
		segments_used = 0
		segments_filled = fill
		
		for i = _details.segments_amount, 1, -1 do
			
			if (i <= fill) then

				local thisCombat = _details.table_history.tables[i]
				if (thisCombat) then
					local enemy = thisCombat.is_boss and thisCombat.is_boss.name
					segments_used = segments_used + 1

					if (thisCombat.is_boss and thisCombat.is_boss.name) then
					
						if (thisCombat.instance_type == "party") then
							CoolTip:AddLine(thisCombat.is_boss.name .."(#"..i..")", _, 1, {170/255, 167/255, 255/255, 1})
						elseif (thisCombat.is_boss.killed) then
							CoolTip:AddLine(thisCombat.is_boss.name .."(#"..i..")", _, 1, "lime")
						else
							CoolTip:AddLine(thisCombat.is_boss.name .."(#"..i..")", _, 1, "red")
						end
						
						local portrait = _details:GetBossPortrait(thisCombat.is_boss.mapid, thisCombat.is_boss.index)
						if (portrait) then
							CoolTip:AddIcon(portrait, 2, "top", 128, 64)
						end
						CoolTip:AddIcon([[Interface\AddOns\Details\images\icons]], "main", "left", 16, 16, 0.96875, 1, 0, 0.03125)
						
						local background = _details:GetRaidIcon(thisCombat.is_boss.mapid)
						if (background) then
							CoolTip:SetWallpaper(2, background, nil, {1, 1, 1, 0.5})
						elseif (thisCombat.instance_type == "party") then
							local ej_id = thisCombat.is_boss.ej_instance_id
							if (ej_id) then
								--local name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = EJ_GetInstanceInfo(ej_id)
								if (bgImage) then
									CoolTip:SetWallpaper(2, bgImage, {0.09, 0.698125, 0, 0.833984375}, {1, 1, 1, 0.5})
								end
							end
						else
							CoolTip:SetWallpaper(2,[[Interface\AddOns\Details\images\HotItemBanner]], {0.14453125, 0.9296875, 0.2625, 0.6546875}, {1, 1, 1, 0.5}, true)
						end
					
					elseif (thisCombat.is_arena) then
						
						local file, coords = _details:GetArenaInfo(thisCombat.is_arena.mapid)
						
						enemy = thisCombat.is_arena.name

						CoolTip:AddLine(thisCombat.is_arena.name, _, 1, "yellow")
						
						--131 105 157 127
						--0.255859375 0.306640625 0.205078125 0.248046875
						CoolTip:AddIcon([[Interface\AddOns\Details\images\icons]], "main", "left", 16, 12, 0.251953125, 0.306640625, 0.205078125, 0.248046875)
						--CoolTip:AddIcon([[Interface\AddOns\Details\images\CombatSwords]], "main", "left", 12, 12, 0, 0.453125, 0.015625, 0.46875)
						
						if (file) then
							CoolTip:SetWallpaper(2, "Interface\\Glues\\LOADINGSCREENS\\" .. file, coords, {1, 1, 1, 0.4})
						end
						
					else
						enemy = thisCombat.enemy
						if (enemy) then
							CoolTip:AddLine(thisCombat.enemy .."(#"..i..")", _, 1, "yellow")
						else
							CoolTip:AddLine(segments.past..i, _, 1, "silver")
						end
						
						if (thisCombat.is_trash) then
							CoolTip:AddIcon([[Interface\AddOns\Details\images\icons]], "main", "left", 16, 12, 0.02734375, 0.11328125, 0.19140625, 0.3125)
						else
							CoolTip:AddIcon([[Interface\QUESTFRAME\UI-Quest-BulletPoint]], "main", "left", 16, 16)
						end
						
						CoolTip:SetWallpaper(2,[[Interface\ACHIEVEMENTFRAME\UI-Achievement-StatsBackground]], {0.5078125, 0.1171875, 0.017578125, 0.1953125}, {1, 1, 1, .5})
						
					end
					
					CoolTip:AddMenu(1, instance.SwitchTable, i)
					
					CoolTip:AddLine(Loc["STRING_SEGMENT_ENEMY"] .. ":", enemy, 2, "white", "white")
					
					local elapsed =(thisCombat.end_time or _details._time) - thisCombat.start_time
					local minutes, seconds = _math_floor(elapsed/60), _math_floor(elapsed%60)
					CoolTip:AddLine(Loc["STRING_SEGMENT_TIME"] .. ":", minutes.."m "..seconds.."s", 2, "white", "white")
					
					CoolTip:AddLine(Loc["STRING_SEGMENT_START"] .. ":", thisCombat.data_start, 2, "white", "white")
					CoolTip:AddLine(Loc["STRING_SEGMENT_END"] .. ":", thisCombat.data_end or "in progress", 2, "white", "white")
					
					fight_amount = fight_amount + 1
				else
					CoolTip:AddLine(Loc["STRING_SEGMENT_LOWER"] .. " #" .. i, _, 1, "gray")
					CoolTip:AddMenu(1, instance.SwitchTable, i)
					CoolTip:AddIcon([[Interface\QUESTFRAME\UI-Quest-BulletPoint]], "main", "left", 16, 16, nil, nil, nil, nil, empty_segment_color)
					CoolTip:AddLine(Loc["STRING_SEGMENT_EMPTY"], _, 2)
					CoolTip:AddIcon([[Interface\CHARACTERFRAME\Disconnect-Icon]], 2, 1, 12, 12, 0.3125, 0.65625, 0.265625, 0.671875)
					CoolTip:SetWallpaper(2,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
				end
				
				if (menuIndex) then
					menuIndex = menuIndex + 1
					if (instance.segment == i) then
						CoolTip:SetLastSelected("main", menuIndex); 
						menuIndex = nil
					end
				end
			
			end
			
		end
		
		----------- current
		CoolTip:AddLine(segments.current_standard, _, 1, "white")
		CoolTip:AddMenu(1, instance.SwitchTable, 0)
		CoolTip:AddIcon([[Interface\QUESTFRAME\UI-Quest-BulletPoint]], "main", "left", 16, 16, nil, nil, nil, nil, "orange")
			
			local enemy = _details.table_current.is_boss and _details.table_current.is_boss.name or _details.table_current.enemy or "--x--x--"
			
			if (_details.table_current.is_boss and _details.table_current.is_boss.name) then
				local portrait = _details:GetBossPortrait(_details.table_current.is_boss.mapid, _details.table_current.is_boss.index)
				if (portrait) then
					CoolTip:AddIcon(portrait, 2, "top", 128, 64)
				end
				
				local background = _details:GetRaidIcon(_details.table_current.is_boss.mapid)
				if (background) then
					CoolTip:SetWallpaper(2, background, nil, {1, 1, 1, 0.5})
				elseif (_details.table_current.instance_type == "party") then
					local ej_id = _details.table_current.is_boss.ej_instance_id
					if (ej_id) then
						--local name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = EJ_GetInstanceInfo(ej_id)
						if (bgImage) then
							CoolTip:SetWallpaper(2, bgImage, {0.09, 0.698125, 0, 0.833984375}, {1, 1, 1, 0.5})
						end
					end
				end
			else
				CoolTip:SetWallpaper(2,[[Interface\ACHIEVEMENTFRAME\UI-Achievement-StatsBackground]], {0.5078125, 0.1171875, 0.017578125, 0.1953125}, {1, 1, 1, .5})
			end					
			
			CoolTip:AddLine(Loc["STRING_SEGMENT_ENEMY"] .. ":", enemy, 2, "white", "white")
			
			if (not _details.table_current.end_time) then
				if (_details.in_combat) then
					local elapsed = _details._time - _details.table_current.start_time
					local minutes, seconds = _math_floor(elapsed/60), _math_floor(elapsed%60)
					CoolTip:AddLine(Loc["STRING_SEGMENT_TIME"] .. ":", minutes.."m "..seconds.."s", 2, "white", "white") 
				else
					CoolTip:AddLine(Loc["STRING_SEGMENT_TIME"] .. ":", "--x--x--", 2, "white", "white")
				end
			else
				local elapsed =(_details.table_current.end_time) - _details.table_current.start_time
				local minutes, seconds = _math_floor(elapsed/60), _math_floor(elapsed%60)
				CoolTip:AddLine(Loc["STRING_SEGMENT_TIME"] .. ":", minutes.."m "..seconds.."s", 2, "white", "white") 
			end

			
			CoolTip:AddLine(Loc["STRING_SEGMENT_START"] .. ":", _details.table_current.data_start, 2, "white", "white")
			CoolTip:AddLine(Loc["STRING_SEGMENT_END"] .. ":", _details.table_current.data_end or "in progress", 2, "white", "white") 
		
			--> fill é a amount de menu que this sendo mostrada
			if (instance.segment == 0) then
				if (fill - 2 == menuIndex) then
					CoolTip:SetLastSelected("main", fill - 1)
				elseif (fill - 1 == menuIndex) then
					CoolTip:SetLastSelected("main", fill)
				else
					CoolTip:SetLastSelected("main", fill + 1)
				end

				menuIndex = nil
			end
		
		----------- overall
		--CoolTip:AddLine(segments.overall_standard, _, 1, "white") Loc["STRING_REPORT_LAST"] .. " " .. fight_amount .. " " .. Loc["STRING_REPORT_FIGHTS"]
		CoolTip:AddLine(Loc["STRING_SEGMENT_OVERALL"], _, 1, "white")
		CoolTip:AddMenu(1, instance.SwitchTable, -1)
		CoolTip:AddIcon([[Interface\QUESTFRAME\UI-Quest-BulletPoint]], "main", "left", 16, 16, nil, nil, nil, nil, "orange")
		
			CoolTip:AddLine(Loc["STRING_SEGMENT_ENEMY"] .. ":", "--x--x--", 2, "white", "white")--localize-me
			
			if (not _details.table_overall.end_time) then
				if (_details.in_combat) then
					local elapsed = _details._time - _details.table_overall.start_time
					local minutes, seconds = _math_floor(elapsed/60), _math_floor(elapsed%60)
					CoolTip:AddLine(Loc["STRING_SEGMENT_TIME"] .. ":", minutes.."m "..seconds.."s", 2, "white", "white") 
				else
					CoolTip:AddLine(Loc["STRING_SEGMENT_TIME"] .. ":", "--x--x--", 2, "white", "white")
				end
			else
				local elapsed =(_details.table_overall.end_time) - _details.table_overall.start_time
				local minutes, seconds = _math_floor(elapsed/60), _math_floor(elapsed%60)
				CoolTip:AddLine(Loc["STRING_SEGMENT_TIME"] .. ":", minutes.."m "..seconds.."s", 2, "white", "white") 
			end
			
			CoolTip:SetWallpaper(2,[[Interface\ACHIEVEMENTFRAME\UI-Achievement-StatsBackground]], {0.5078125, 0.1171875, 0.017578125, 0.1953125}, {1, 1, 1, .5})
			
			local earlyFight = ""
			for i = _details.segments_amount, 1, -1 do
				if (_details.table_history.tables[i]) then
					earlyFight = _details.table_history.tables[i].data_start
					break
				end
			end
			CoolTip:AddLine(Loc["STRING_SEGMENT_START"] .. ":", earlyFight, 2, "white", "white")
			
			local lastFight = ""
			for i = 1, _details.segments_amount do
				if (_details.table_history.tables[i] and _details.table_history.tables[i].data_end ~= 0) then
					lastFight = _details.table_history.tables[i].data_end
					break
				end
			end
			CoolTip:AddLine(Loc["STRING_SEGMENT_END"] .. ":", lastFight, 2, "white", "white")
			
			--> fill é a amount de menu que this sendo mostrada
			if (instance.segment == -1) then
				if (fill - 2 == menuIndex) then
					CoolTip:SetLastSelected("main", fill)
				elseif (fill - 1 == menuIndex) then
					CoolTip:SetLastSelected("main", fill+1)
				else
					CoolTip:SetLastSelected("main", fill + 2)
				end
				menuIndex = nil
			end
			
		---------------------------------------------
		
		if (instance.consolidate) then
			CoolTip:SetOwner(self, "topleft", "topright", 3)
		else
			if (instance.toolbar_side == 1) then
				CoolTip:SetOwner(self)
			elseif (instance.toolbar_side == 2) then --> bottom
				CoolTip:SetOwner(self, "bottom", "top", 0, 0) -- -7
			end
		end
		
		CoolTip:SetOption("TextSize", _details.font_sizes.menus)
		CoolTip:SetOption("SubMenuIsTooltip", true)
		
		CoolTip:SetOption("ButtonHeightMod", -4)
		CoolTip:SetOption("ButtonsYMod", -4)
		CoolTip:SetOption("YSpacingMod", 4)
		
		CoolTip:SetOption("ButtonHeightModSub", 4)
		CoolTip:SetOption("ButtonsYModSub", 0)
		CoolTip:SetOption("YSpacingModSub", -4)
		
		--CoolTip:SetWallpaper(1,[[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Horizontal-Desaturated]], nil, {1, 1, 1, 0.3})
		CoolTip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
		CoolTip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		CoolTip:SetBackdrop(2, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		
		show_anti_overlap(instance, self, "top")
		
		CoolTip:ShowCooltip()
		
		self:SetScript("OnUpdate", nil)
	end	
	
end

-- ~skin
function _details:ChangeSkin(skin_name)

	if (not skin_name) then
		skin_name = self.skin
	end

	local this_skin = _details.skins[skin_name]

	if (not this_skin) then
		skin_name = "Minimalistic v2"
		this_skin = _details.skins[skin_name]
	end
	
	local just_updating = false
	if (self.skin == skin_name) then
		just_updating = true
	end

	if (not just_updating) then

		--> skin updater
		--print("debug", self.mine_id, self.initiated, self.baseframe, self.bgframe)
		if (self.bgframe.skin_script) then
			self.bgframe:SetScript("OnUpdate", nil)
			self.bgframe.skin_script = false
		end
	
		--> reset all config
			self:ResetInstanceConfig(true)
	
		--> overwrites
			local overwrite_cprops = this_skin.instance_cprops
			if (overwrite_cprops) then
				
				local copy = table_deepcopy(overwrite_cprops)
				
				for cprop, value in _pairs(copy) do
					if (type(value) == "table") then
						for cprop2, value2 in _pairs(value) do
							self[cprop][cprop2] = value2
						end
					else
						self[cprop] = value
					end
				end
				
			end
			
		--> reset micro frames
			_details.StatusBar:Reset(self)

		--> customize micro frames
			if (this_skin.micro_frames) then
				if (this_skin.micro_frames.left) then
					_details.StatusBar:SetPlugin(self, this_skin.micro_frames.left, "left")
				end
				if (this_skin.micro_frames.color) then
					_details.StatusBar:ApplyOptions(self.StatusBar.left, "textcolor", this_skin.micro_frames.color)
					_details.StatusBar:ApplyOptions(self.StatusBar.center, "textcolor", this_skin.micro_frames.color)
					_details.StatusBar:ApplyOptions(self.StatusBar.right, "textcolor", this_skin.micro_frames.color)
				end
				if (this_skin.micro_frames.font) then
					_details.StatusBar:ApplyOptions(self.StatusBar.left, "textface", this_skin.micro_frames.font)
					_details.StatusBar:ApplyOptions(self.StatusBar.center, "textface", this_skin.micro_frames.font)
					_details.StatusBar:ApplyOptions(self.StatusBar.right, "textface", this_skin.micro_frames.font)
				end
				if (this_skin.micro_frames.size) then
					_details.StatusBar:ApplyOptions(self.StatusBar.left, "textsize", this_skin.micro_frames.size)
					_details.StatusBar:ApplyOptions(self.StatusBar.center, "textsize", this_skin.micro_frames.size)
					_details.StatusBar:ApplyOptions(self.StatusBar.right, "textsize", this_skin.micro_frames.size)
				end
			end
			
	end
	
	self.skin = skin_name

	local skin_file = this_skin.file

	--> set textures
	
		self.baseframe.header.ball:SetTexture(skin_file) --> bola left
		self.baseframe.header.emenda:SetTexture(skin_file) --> emenda que liga a bola a texture do centro
		
		self.baseframe.header.ball_r:SetTexture(skin_file) --> bola right onde fica o botão de close
		self.baseframe.header.top_bg:SetTexture(skin_file) --> top background
		
		self.baseframe.bar_left:SetTexture(skin_file) --> bar lateral
		self.baseframe.bar_right:SetTexture(skin_file) --> bar lateral
		self.baseframe.bar_fundo:SetTexture(skin_file) --> bar inferior
		
		self.baseframe.scroll_up:SetTexture(skin_file) --> scrollbar parte de cima
		self.baseframe.scroll_down:SetTexture(skin_file) --> scrollbar parte de baixo
		self.baseframe.scroll_middle:SetTexture(skin_file) --> scrollbar parte do meio

		self.baseframe.rodape.top_bg:SetTexture(skin_file) --> rodape top background
		self.baseframe.rodape.left:SetTexture(skin_file) --> rodape left
		self.baseframe.rodape.right:SetTexture(skin_file) --> rodape direito
		
		self.baseframe.button_stretch.texture:SetTexture(skin_file) --> botão de esticar a window
		
		self.baseframe.resize_right.texture:SetTexture(skin_file) --> botão de redimencionar da right
		self.baseframe.resize_left.texture:SetTexture(skin_file) --> botão de redimencionar da left
		
		self.break_snap_button:SetNormalTexture(skin_file) --> cadeado
		self.break_snap_button:SetDisabledTexture(skin_file)
		self.break_snap_button:SetHighlightTexture(skin_file, "ADD")
		self.break_snap_button:SetPushedTexture(skin_file)

----------> icon anchor and size
	
	if (self.mode == 1 or self.mode == 4 or self.attribute == 5) then -- alone e raid
		local icon_anchor = this_skin.icon_anchor_plugins
		self.baseframe.header.attribute_icon:SetPoint("topright", self.baseframe.header.ball_point, "topright", icon_anchor[1], icon_anchor[2])
		if (self.mode == 1) then
			if (_details.SoloTables.Plugins[1] and _details.SoloTables.Mode) then
				local plugin_index = _details.SoloTables.Mode
				if (plugin_index > 0 and _details.SoloTables.Menu[plugin_index]) then
					self:ChangeIcon(_details.SoloTables.Menu[plugin_index][2])
				end
			end

		elseif (self.mode == 4) then
			--if (_details.RaidTables.Plugins[1] and _details.RaidTables.Mode) then
			--	local plugin_index = _details.RaidTables.Mode
			--	if (plugin_index and _details.RaidTables.Menu[plugin_index]) then
					--self:ChangeIcon(_details.RaidTables.Menu[plugin_index][2])
			--	end
			--end
		end
	else
		local icon_anchor = this_skin.icon_anchor_main --> ancora do icon do canto direito superior
		self.baseframe.header.attribute_icon:SetPoint("topright", self.baseframe.header.ball_point, "topright", icon_anchor[1], icon_anchor[2])
		self:ChangeIcon()
	end
	
----------> lock alpha head	
	
	if (not this_skin.can_change_alpha_head) then
		self.baseframe.header.ball:SetAlpha(100)
	else
		self.baseframe.header.ball:SetAlpha(self.color[4])
	end

----------> update abbreviation function on the class files
	
	_details.attribute_damage:UpdateSelectedToKFunction()
	_details.attribute_heal:UpdateSelectedToKFunction()
	_details.attribute_energy:UpdateSelectedToKFunction()
	_details.attribute_misc:UpdateSelectedToKFunction()
	_details.attribute_custom:UpdateSelectedToKFunction()
	
----------> call widgets handlers	
		self:SetBarSettings(self.row_info.height)
		self:SetBarBackdropSettings()
	
	--> update toolbar
		self:ToolbarSide()
	
	--> update stretch button
		self:StretchButtonAnchor()
	
	--> update side bars
		if (self.show_sidebars) then
			self:ShowSideBars()
		else
			self:HideSideBars()
		end

	--> refresh the side of the micro displays
		self:MicroDisplaysSide()
		
	--> update statusbar
		if (self.show_statusbar) then
			self:ShowStatusBar()
		else
			self:HideStatusBar()
		end

	--> update wallpaper
		if (self.wallpaper.enabled) then
			self:InstanceWallpaper(true)
		else
			self:InstanceWallpaper(false)
		end
	
	--> update instance color
		self:InstanceColor()
		self:SetBackgroundColor()
		self:SetBackgroundAlpha()
		self:SetAutoHideMenu()
		self:SetBackdropTexture()

	--> refresh all bars
		
		self:InstanceRefreshRows()

	--> update menu saturation
		self:DesaturateMenu()
		self:DesaturateMenu2()
	
	--> update statusbar color
		self:StatusBarColor()
	
	--> update attribute string
		self:AttributeMenu()
	
	--> update top menus
		self:LeftMenuAnchorSide()
		self:Menu2Anchor()
		
	--> update window strata level
		self:SetFrameStrata()
	
	--> update the combat alphas
		self:SetCombatAlpha(nil, nil, true)
		
	--> update icons
		_details.ToolBar:ReorganizeIcons(true) --call self:SetMenuAlpha()
		
	--> refresh options panel if opened
		if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
			_details:OpenOptionsWindow(self)
		end

	--> check if is interacting
		if (self.menu_alpha.enabled) then
			if (_details.in_combat) then
				self:SetWindowAlphaForCombat(true)
			else
				self:SetWindowAlphaForCombat()
			end
		end
		
	--> set the scale
	self:SetWindowScale()
		
	if (not just_updating or _details.initializing) then
		if (this_skin.callback) then
			this_skin:callback(self, just_updating)
		end
		
		if (this_skin.control_script) then
			if (this_skin.control_script_on_start) then
				this_skin:control_script_on_start(self)
			end
			self.bgframe:SetScript("OnUpdate", this_skin.control_script)
			self.bgframe.skin_script = true
			self.bgframe.skin = this_skin
			--self.bgframe.skin_script_instance = true
		end
	end

end

function _details:DelayedCheckCombatAlpha(instance)
	if (UnitAffectingCombat("player") or InCombatLockdown()) then
		instance:SetWindowAlphaForCombat(true, true) --> hida a window
	else
		instance:SetWindowAlphaForCombat(false) --> deshida a window
	end
end

function _details:DelayedCheckOutOfCombatAlpha(instance)
	if (UnitAffectingCombat("player") or InCombatLockdown()) then
		instance:SetWindowAlphaForCombat(false) --> deshida a window
	else
		instance:SetWindowAlphaForCombat(true, true) --> hida a window
	end
end

function _details:SetCombatAlpha(modify_type, alpha_amount, interacting)

	if (interacting) then
		
		if (self.hide_in_combat_type == 1) then --None
			return
			
		elseif (self.hide_in_combat_type == 2) then --While In Combat
			_details:ScheduleTimer("DelayedCheckCombatAlpha", 0.3, self)
			
		elseif (self.hide_in_combat_type == 3) then --"While Out of Combat"
			_details:ScheduleTimer("DelayedCheckOutOfCombatAlpha", 0.3, self)
			
		elseif (self.hide_in_combat_type == 4) then --"While Out of a Group"
			if (_details.in_group) then
				self:SetWindowAlphaForCombat(false) --> deshida a window
			else
				self:SetWindowAlphaForCombat(true, true) --> hida a window
			end
		end
		
		return
	end

	if (not modify_type) then
		modify_type = self.hide_in_combat_type
	else
		if (modify_type == 1) then --> changed to none
			self:SetWindowAlphaForCombat(false)
		end
	end
	
	if (not alpha_amount) then
		alpha_amount = self.hide_in_combat_alpha
	end
	
	self.hide_in_combat_type = modify_type
	self.hide_in_combat_alpha = alpha_amount
	
	self:SetCombatAlpha(nil, nil, true)
	
end

function _details:SetFrameStrata(strata)
	
	if (not strata) then
		strata = self.strata
	end
	
	self.strata = strata
	
	self.rowframe:SetFrameStrata(strata)
	self.baseframe:SetFrameStrata(strata)
	
	if (strata == "BACKGROUND") then
		self.break_snap_button:SetFrameStrata("LOW")
		self.baseframe.resize_left:SetFrameStrata("LOW")
		self.baseframe.resize_right:SetFrameStrata("LOW")
		self.baseframe.lock_button:SetFrameStrata("LOW")
		
	elseif (strata == "LOW") then
		self.break_snap_button:SetFrameStrata("MEDIUM")
		self.baseframe.resize_left:SetFrameStrata("MEDIUM")
		self.baseframe.resize_right:SetFrameStrata("MEDIUM")
		self.baseframe.lock_button:SetFrameStrata("MEDIUM")
		
	elseif (strata == "MEDIUM") then
		self.break_snap_button:SetFrameStrata("HIGH")
		self.baseframe.resize_left:SetFrameStrata("HIGH")
		self.baseframe.resize_right:SetFrameStrata("HIGH")
		self.baseframe.lock_button:SetFrameStrata("HIGH")
		
	elseif (strata == "HIGH") then
		self.break_snap_button:SetFrameStrata("DIALOG")
		self.baseframe.resize_left:SetFrameStrata("DIALOG")
		self.baseframe.resize_right:SetFrameStrata("DIALOG")
		self.baseframe.lock_button:SetFrameStrata("DIALOG")
		
	elseif (strata == "DIALOG") then
		self.break_snap_button:SetFrameStrata("FULLSCREEN")
		self.baseframe.resize_left:SetFrameStrata("FULLSCREEN")
		self.baseframe.resize_right:SetFrameStrata("FULLSCREEN")
		self.baseframe.lock_button:SetFrameStrata("FULLSCREEN")
		
	end
	
	self:StretchButtonAlwaysOnTop()
	
end

function _details:LeftMenuAnchorSide(side)
	
	if (not side) then
		side = self.menu_anchor.side
	end
	
	self.menu_anchor.side = side
	
	return self:MenuAnchor()
	
end

-- ~attributemenu(text with attribute name)
function _details:AttributeMenu(enabled, pos_x, pos_y, font, size, color, side, shadow)

	if (type(enabled) ~= "boolean") then
		enabled = self.attribute_text.enabled
	end
	
	if (not pos_x) then
		pos_x = self.attribute_text.anchor[1]
	end
	if (not pos_y) then
		pos_y = self.attribute_text.anchor[2]
	end
	
	if (not font) then
		font = self.attribute_text.text_face
	end
	
	if (not size) then
		size = self.attribute_text.text_size
	end
	
	if (not color) then
		color = self.attribute_text.text_color
	end
	
	if (not side) then
		side = self.attribute_text.side
	end
	
	if (type(shadow) ~= "boolean") then
		shadow = self.attribute_text.shadow
	end
	
	self.attribute_text.enabled = enabled
	self.attribute_text.anchor[1] = pos_x
	self.attribute_text.anchor[2] = pos_y
	self.attribute_text.text_face = font
	self.attribute_text.text_size = size
	self.attribute_text.text_color = color
	self.attribute_text.side = side
	self.attribute_text.shadow = shadow

	--> enabled
	if (not enabled and self.menu_attribute_string) then
		return self.menu_attribute_string:Hide()
	elseif (not enabled) then
		return
	end
	
	--> protection against failed clean up framework table
	if (self.menu_attribute_string and not getmetatable(self.menu_attribute_string)) then
		self.menu_attribute_string = nil
	end
	
	if (not self.menu_attribute_string) then 

		local label = gump:NewLabel(self.floatingframe, nil, "DetailsAttributeStringInstance" .. self.mine_id, nil, "", "GameFontNormalSmall")
		self.menu_attribute_string = label
		self.menu_attribute_string.text = _details:GetSubAttributeName(self.attribute, self.sub_attribute)
		self.menu_attribute_string.owner_instance = self
		
		self.menu_attribute_string.Enabled = true
		self.menu_attribute_string.__enabled = true
		
		function self.menu_attribute_string:OnEvent(instance, attribute, subAttribute)
			if (instance == label.owner_instance) then
				local sName = instance:GetInstanceAttributeText()
				label.text = sName
			end
		end
		
		_details:RegisterEvent(self.menu_attribute_string, "DETAILS_INSTANCE_CHANGEATTRIBUTE", self.menu_attribute_string.OnEvent)
		_details:RegisterEvent(self.menu_attribute_string, "DETAILS_INSTANCE_CHANGEMODE", self.menu_attribute_string.OnEvent)

	end

	self.menu_attribute_string:Show()
	
	--> anchor
	if (side == 1) then --> a string this no side de cima
		if (self.toolbar_side == 1) then -- a toolbar this em cima
			self.menu_attribute_string:ClearAllPoints()
			self.menu_attribute_string:SetPoint("bottomleft", self.baseframe.header.ball, "bottomright", self.attribute_text.anchor[1], self.attribute_text.anchor[2])
			
		elseif (self.toolbar_side == 2) then --a toolbar this em baixo
			self.menu_attribute_string:ClearAllPoints()
			self.menu_attribute_string:SetPoint("bottomleft", self.baseframe, "topleft", self.attribute_text.anchor[1] + 21, self.attribute_text.anchor[2])

		end
		
	elseif (side == 2) then --> a string this no side de baixo
		if (self.toolbar_side == 1) then --toolbar this em cima
			self.menu_attribute_string:ClearAllPoints()
			self.menu_attribute_string:SetPoint("left", self.baseframe.rodape.StatusBarLeftAnchor, "left", self.attribute_text.anchor[1] + 16, self.attribute_text.anchor[2] - 6)

		elseif (self.toolbar_side == 2) then --toolbar this em baixo
			self.menu_attribute_string:SetPoint("bottomleft", self.baseframe.header.ball, "topright", self.attribute_text.anchor[1], self.attribute_text.anchor[2] - 19)

		end
	end
	
	--font face
	local fontPath = SharedMedia:Fetch("font", font)
	_details:SetFontFace(self.menu_attribute_string, fontPath)
	
	--font size
	_details:SetFontSize(self.menu_attribute_string, size)
	
	--color
	_details:SetFontColor(self.menu_attribute_string, color)
	
	--shadow
	_details:SetFontOutline(self.menu_attribute_string, shadow)
	
end

-- ~backdrop
function _details:SetBackdropTexture(texturename)
	
	if (not texturename) then
		texturename = self.backdrop_texture
	end
	
	self.backdrop_texture = texturename
	
	local texture_path = SharedMedia:Fetch("background", texturename)
	
	self.baseframe:SetBackdrop({
		bgFile = texture_path, tile = true, tileSize = 128,
		insets = {left = 0, right = 0, top = 0, bottom = 0}}
	)
	self.bgdisplay:SetBackdrop({
		bgFile = texture_path, tile = true, tileSize = 128,
		insets = {left = 0, right = 0, top = 0, bottom = 0}}
	)
	
	self:SetBackgroundAlpha(self.bg_alpha)
	
end

-- ~alpha(transparency of buttons on the toolbar)
function _details:SetAutoHideMenu(left, right, interacting)

	if (interacting) then
		if (self.is_interacting) then
			if (self.auto_hide_menu.left) then
				local r, g, b = unpack(self.color_buttons)
				self:InstanceButtonsColors(r, g, b, 1, true, true) --no save, only left
			end
			if (self.auto_hide_menu.right) then
				local r, g, b = unpack(self.color_buttons)
				self:InstanceButtonsColors(r, g, b, 1, true, nil, true) --no save, only right
			end
		else
			if (self.auto_hide_menu.left) then
				local r, g, b = unpack(self.color_buttons)
				self:InstanceButtonsColors(r, g, b, 0, true, true) --no save, only left
			end
			if (self.auto_hide_menu.right) then
				local r, g, b = unpack(self.color_buttons)
				self:InstanceButtonsColors(r, g, b, 0, true, nil, true) --no save, only right
			end
		end
		return
	end

	if (left == nil) then
		left = self.auto_hide_menu.left
	end
	if (right == nil) then
		right = self.auto_hide_menu.right
	end

	self.auto_hide_menu.left = left
	self.auto_hide_menu.right = right
	
	local r, g, b = unpack(self.color_buttons)
	
	if (not left) then
		--auto hide is off
		self:InstanceButtonsColors(r, g, b, 1, true, true) --no save, only left
	else
		if (self.is_interacting) then
			self:InstanceButtonsColors(r, g, b, 1, true, true) --no save, only left
		else
			self:InstanceButtonsColors(0, 0, 0, 0, true, true) --no save, only left
		end
	end
	
	if (not right) then
		--auto hide is off
		self:InstanceButtonsColors(r, g, b, 1, true, nil, true) --no save, only right
	else
		if (self.is_interacting) then
			self:InstanceButtonsColors(r, g, b, 1, true, nil, true) --no save, only right
		else
			self:InstanceButtonsColors(0, 0, 0, 0, true, nil, true) --no save, only right
		end
	end
	
	--auto_hide_menu = {left = false, right = false},

end

-- transparency for toolbar, borders and statusbar
function _details:SetMenuAlpha(enabled, onenter, onleave, ignorebars, interacting)

	if (interacting) then --> called from a onenter or onleave script
		if (self.menu_alpha.enabled) then
			if (self.is_interacting) then
				return self:SetWindowAlphaForInteract(self.menu_alpha.onenter)
			else
				return self:SetWindowAlphaForInteract(self.menu_alpha.onleave)
			end
		end
		return
	end

	--ignorebars
	
	if (enabled == nil) then
		enabled = self.menu_alpha.enabled
	end
	if (not onenter) then
		onenter = self.menu_alpha.onenter
	end
	if (not onleave) then
		onleave = self.menu_alpha.onleave
	end
	if (ignorebars == nil) then
		ignorebars = self.menu_alpha.ignorebars
	end

	self.menu_alpha.enabled = enabled
	self.menu_alpha.onenter = onenter
	self.menu_alpha.onleave = onleave
	self.menu_alpha.ignorebars = ignorebars
	
	if (not enabled) then
		--> aqui this mandando setar a alpha do baseframe
		self.baseframe:SetAlpha(1)
		self.rowframe:SetAlpha(1)
		self:InstanceAlpha(self.color[4])
		self:SetIconAlpha(1, nil, true)
		return self:InstanceColor(unpack(self.color))
		--return self:SetWindowAlphaForInteract(self.color[4])
	else
		local r, g, b = unpack(self.color)
		self:InstanceColor(r, g, b, 1)
		r, g, b = unpack(self.statusbar_info.overlay)
		self:StatusBarColor(r, g, b, 1)
	end

	if (self.is_interacting) then
		return self:SetWindowAlphaForInteract(onenter) --> set alpha
	else
		return self:SetWindowAlphaForInteract(onleave) --> set alpha
	end
	
end

function _details:GetInstanceCurrentAlpha()
	if (self.menu_alpha.enabled) then
		if (self:IsInteracting()) then
			return self.menu_alpha.onenter
		else
			return self.menu_alpha.onleave
		end
	else
		return self.color[4]
	end
end

function _details:GetInstanceIconsCurrentAlpha()
	if (self.menu_alpha.enabled and self.menu_alpha.iconstoo) then
		if (self:IsInteracting()) then
			return self.menu_alpha.onenter
		else
			return self.menu_alpha.onleave
		end
	else
		return 1
	end
end

function _details:MicroDisplaysSide(side, fromuser)
	if (not side) then
		side = self.micro_displays_side
	end
	
	self.micro_displays_side = side
	
	_details.StatusBar:ReloadAnchors(self)
	
	if (self.micro_displays_side == 2 and not self.show_statusbar) then --> bottom side
		_details.StatusBar:Hide(self)
		if (fromuser) then
			_details:Msg(Loc["STRING_OPTIONS_MICRODISPLAYWARNING"])
		end
	elseif (self.micro_displays_side == 2) then
		_details.StatusBar:Show(self)
	elseif (self.micro_displays_side == 1) then
		_details.StatusBar:Show(self)
	end
	
end

function _details:IsGroupedWith(instance)
	local id = instance:GetId()
	for side, instanceId in _pairs(self.snap) do
		if (instanceId == id) then
			return true
		end
	end
	return false
end

function _details:GetInstanceGroup(instance_id)

	local instance = self
	
	if (instance_id) then
		instance = _details:GetInstance(instance_id)
		if (not instance or not instance:IsEnabled()) then
			return
		end
	end
	
	local current_group = {instance}
	
	for side, insId in _pairs(instance.snap) do
		if (insId < instance:GetId()) then
			local last_id = instance:GetId()
			for i = insId, 1, -1 do
				local this_instance = _details:GetInstance(i)
				local got = false
				if (this_instance and this_instance:IsEnabled()) then
					for side, id in _pairs(this_instance.snap) do
						if (id == last_id) then
							tinsert(current_group, this_instance)
							got = true
							last_id = i
						end
					end
				end
				if (not got) then
					break
				end
			end
		else
			local last_id = instance:GetId()
			for i = insId, _details.instances_amount do
				local this_instance = _details:GetInstance(i)
				local got = false
				if (this_instance and this_instance:IsEnabled()) then
					for side, id in _pairs(this_instance.snap) do
						if (id == last_id) then
							tinsert(current_group, this_instance)
							got = true
							last_id = i
						end
					end
				end
				if (not got) then
					break
				end
			end
		end
	end
	
	return current_group
end

function _details:SetWindowScale(scale, from_options)
	if (not scale) then
		scale = self.window_scale
	end
	
	self.window_scale = scale
	
	self.baseframe:SetScale(scale)
	self.rowframe:SetScale(scale)
	
	if (from_options) then
	
		local group = self:GetInstanceGroup()
		
		for _, instance in _ipairs(group) do
			instance.baseframe:SetScale(scale)
			instance.rowframe:SetScale(scale)
			instance.window_scale = scale
		end
		
		for _, instance in _ipairs(group) do
			_details.move_window_func(instance.baseframe, true, instance)
			_details.move_window_func(instance.baseframe, false, instance)
		end
		
		for _, instance in _ipairs(group) do
			instance:SaveMainWindowPosition()
		end
	end
end

function _details:ToolbarSide(side)
	
	if (not side) then
		side = self.toolbar_side
	end
	
	self.toolbar_side = side
	
	local skin = _details.skins[self.skin]
	
	if (side == 1) then --> top
		--> ball point
		self.baseframe.header.ball_point:ClearAllPoints()
		self.baseframe.header.ball_point:SetPoint("bottomleft", self.baseframe, "topleft", unpack(skin.icon_point_anchor))
		--> ball
		self.baseframe.header.ball:SetTexCoord(unpack(COORDS_LEFT_BALL))
		self.baseframe.header.ball:ClearAllPoints()
		self.baseframe.header.ball:SetPoint("bottomleft", self.baseframe, "topleft", unpack(skin.left_corner_anchor))

		--> ball r
		self.baseframe.header.ball_r:SetTexCoord(unpack(COORDS_RIGHT_BALL))
		self.baseframe.header.ball_r:ClearAllPoints()
		self.baseframe.header.ball_r:SetPoint("bottomright", self.baseframe, "topright", unpack(skin.right_corner_anchor))

		--> tex coords
		self.baseframe.header.emenda:SetTexCoord(unpack(COORDS_LEFT_CONNECTOR))
		self.baseframe.header.top_bg:SetTexCoord(unpack(COORDS_TOP_BACKGROUND))
		
		--> up frames
		self.baseframe.UPFrame:SetPoint("left", self.baseframe.header.ball, "right", 0, -53)
		self.baseframe.UPFrame:SetPoint("right", self.baseframe.header.ball_r, "left", 0, -53)
		
		self.baseframe.UPFrameConnect:ClearAllPoints()
		self.baseframe.UPFrameConnect:SetPoint("bottomleft", self.baseframe, "topleft", 0, -1)
		self.baseframe.UPFrameConnect:SetPoint("bottomright", self.baseframe, "topright", 0, -1)
		
		self.baseframe.UPFrameLeftPart:ClearAllPoints()
		self.baseframe.UPFrameLeftPart:SetPoint("bottomleft", self.baseframe, "topleft", 0, 0)
		
	else --> bottom
	
		local y = 0
		if (self.show_statusbar) then
			y = -14
		end
	
		--> ball point
		self.baseframe.header.ball_point:ClearAllPoints()
		local _x, _y = unpack(skin.icon_point_anchor_bottom)
		self.baseframe.header.ball_point:SetPoint("topleft", self.baseframe, "bottomleft", _x, _y + y)
		--> ball
		self.baseframe.header.ball:ClearAllPoints()
		local _x, _y = unpack(skin.left_corner_anchor_bottom)
		self.baseframe.header.ball:SetPoint("topleft", self.baseframe, "bottomleft", _x, _y + y)
		local l, r, t, b = unpack(COORDS_LEFT_BALL)
		self.baseframe.header.ball:SetTexCoord(l, r, b, t)

		--> ball r
		self.baseframe.header.ball_r:ClearAllPoints()
		local _x, _y = unpack(skin.right_corner_anchor_bottom)
		self.baseframe.header.ball_r:SetPoint("topright", self.baseframe, "bottomright", _x, _y + y)
		local l, r, t, b = unpack(COORDS_RIGHT_BALL)
		self.baseframe.header.ball_r:SetTexCoord(l, r, b, t)
		
		--> tex coords
		local l, r, t, b = unpack(COORDS_LEFT_CONNECTOR)
		self.baseframe.header.emenda:SetTexCoord(l, r, b, t)
		local l, r, t, b = unpack(COORDS_TOP_BACKGROUND)
		self.baseframe.header.top_bg:SetTexCoord(l, r, b, t)

		--> up frames
		self.baseframe.UPFrame:SetPoint("left", self.baseframe.header.ball, "right", 0, 53)
		self.baseframe.UPFrame:SetPoint("right", self.baseframe.header.ball_r, "left", 0, 53)
		
		self.baseframe.UPFrameConnect:ClearAllPoints()
		self.baseframe.UPFrameConnect:SetPoint("topleft", self.baseframe, "bottomleft", 0, 1)
		self.baseframe.UPFrameConnect:SetPoint("topright", self.baseframe, "bottomright", 0, 1)
		
		self.baseframe.UPFrameLeftPart:ClearAllPoints()
		self.baseframe.UPFrameLeftPart:SetPoint("topleft", self.baseframe, "bottomleft", 0, 0)
		
	end
	
	--> update top menus
		self:LeftMenuAnchorSide()
		self:Menu2Anchor()
	
	self:StretchButtonAnchor()
	
	self:HideMainIcon()
	
	if (self.show_sidebars) then
		self:ShowSideBars()
	end
	
	self:AttributeMenu()
	
end

function _details:StretchButtonAlwaysOnTop(on_top)
	
	if (type(on_top) ~= "boolean") then
		on_top = self.grab_on_top
	end
	
	self.grab_on_top = on_top
	
	if (self.grab_on_top) then
		self.baseframe.button_stretch:SetFrameStrata("FULLSCREEN")
	else
		self.baseframe.button_stretch:SetFrameStrata(self.strata)
	end
	
end

function _details:StretchButtonAnchor(side)
	
	if (not side) then
		side = self.stretch_button_side
	end
	
	if (side == 1 or string.lower(side) == "top") then
	
		self.baseframe.button_stretch:ClearAllPoints()
		
		local y = 0
		if (self.toolbar_side == 2) then --bottom
			y = -20
		end
		
		self.baseframe.button_stretch:SetPoint("bottom", self.baseframe, "top", 0, 20 + y)
		self.baseframe.button_stretch:SetPoint("right", self.baseframe, "right", -27, 0)
		self.baseframe.button_stretch.texture:SetTexCoord(unpack(COORDS_STRETCH))
		self.stretch_button_side = 1
		
	elseif (side == 2 or string.lower(side) == "bottom") then
	
		self.baseframe.button_stretch:ClearAllPoints()
		
		local y = 0
		if (self.toolbar_side == 2) then --bottom
			y = y -20
		end
		if (self.show_statusbar) then
			y = y -14
		end
		
		self.baseframe.button_stretch:SetPoint("center", self.baseframe, "center")
		self.baseframe.button_stretch:SetPoint("top", self.baseframe, "bottom", 0, y)
		
		local l, r, t, b = unpack(COORDS_STRETCH)
		self.baseframe.button_stretch.texture:SetTexCoord(r, l, b, t)
		
		self.stretch_button_side = 2
		
	end
	
end

function _details:MenuAnchor(x, y)

	if (self.toolbar_side == 1) then --top
		if (not x) then
			x = self.menu_anchor[1]
		end
		if (not y) then
			y = self.menu_anchor[2]
		end
		self.menu_anchor[1] = x
		self.menu_anchor[2] = y
		
	elseif (self.toolbar_side == 2) then --bottom
		if (not x) then
			x = self.menu_anchor_down[1]
		end
		if (not y) then
			y = self.menu_anchor_down[2]
		end
		self.menu_anchor_down[1] = x
		self.menu_anchor_down[2] = y
	end
	
	local menu_points = self.menu_points -- = {MenuAnchorLeft, MenuAnchorRight}
	
	if (self.menu_anchor.side == 1) then --> left
		--self.baseframe.header.mode_selecao:ClearAllPoints()
	
		menu_points[1]:ClearAllPoints()
		if (self.toolbar_side == 1) then --> top
			--self.baseframe.header.mode_selecao:SetPoint("bottomleft", self.baseframe.header.ball, "bottomright", x, y)
			menu_points[1]:SetPoint("bottomleft", self.baseframe.header.ball, "bottomright", x, y+2)
			
		else --> bottom
			--self.baseframe.header.mode_selecao:SetPoint("topleft", self.baseframe.header.ball, "topright", x, y*-1)
			menu_points[1]:SetPoint("topleft", self.baseframe.header.ball, "topright", x,(y*-1) - 4)

		end
	
	elseif (self.menu_anchor.side == 2) then --> right
		--self.baseframe.header.mode_selecao:ClearAllPoints()
		menu_points[2]:ClearAllPoints()
		if (self.toolbar_side == 1) then --> top
			--self.baseframe.header.mode_selecao:SetPoint("topleft", self.baseframe.header.ball_r, "bottomleft", x, y+16)
			menu_points[2]:SetPoint("topleft", self.baseframe.header.ball_r, "bottomleft", x, y+16)
			
		else --> bottom
			--self.baseframe.header.mode_selecao:SetPoint("topleft", self.baseframe.header.ball_r, "topleft", x, y*-1)
			menu_points[2]:SetPoint("topleft", self.baseframe.header.ball_r, "topleft", x,(y*-1) - 4)

		end
	end
	
	self:ToolbarMenuButtons()
	
end

function _details:Menu2Anchor(x, y)

	if (self.toolbar_side == 1) then --top
		if (not x) then
			x = self.menu2_anchor[1]
		end
		if (not y) then
			y = self.menu2_anchor[2]
		end
		self.menu2_anchor[1] = x
		self.menu2_anchor[2] = y
		
	elseif (self.toolbar_side== 2) then --bottom
		if (not x) then
			x = self.menu2_anchor_down[1]
		end
		if (not y) then
			y = self.menu2_anchor_down[2]
		end
		self.menu2_anchor_down[1] = x
		self.menu2_anchor_down[2] = y
	end
	
	local anchor = self.menu2_points[1]
	anchor:ClearAllPoints()
	
	if (self.toolbar_side == 1) then --> top
		anchor:SetPoint("topleft", self.baseframe.header.ball_r, "bottomleft", x, y+16)
		
	else --> bottom
		anchor:SetPoint("topleft", self.baseframe.header.ball_r, "topleft", x-17,(y*-1) + 1)

	end
	
	self:ToolbarMenu2Buttons()
	
end

function _details:HideMainIcon(value)

	if (type(value) ~= "boolean") then
		value = self.hide_icon
	end

	if (value) then
	
		self.hide_icon = true
		gump:Fade(self.baseframe.header.attribute_icon, 1)
		--self.baseframe.header.ball:SetParent(self.baseframe)
		
		if (self.toolbar_side == 1) then
			self.baseframe.header.ball:SetTexCoord(unpack(COORDS_LEFT_BALL_NO_ICON))
			self.baseframe.header.emenda:SetTexCoord(unpack(COORDS_LEFT_CONNECTOR_NO_ICON))
			
		elseif (self.toolbar_side == 2) then
			local l, r, t, b = unpack(COORDS_LEFT_BALL_NO_ICON)
			self.baseframe.header.ball:SetTexCoord(l, r, b, t)
			local l, r, t, b = unpack(COORDS_LEFT_CONNECTOR_NO_ICON)
			self.baseframe.header.emenda:SetTexCoord(l, r, b, t)
		
		end
		
	else
		self.hide_icon = false
		gump:Fade(self.baseframe.header.attribute_icon, 0)
		--self.baseframe.header.ball:SetParent(_details.listener)
		
		if (self.toolbar_side == 1) then

			self.baseframe.header.ball:SetTexCoord(unpack(COORDS_LEFT_BALL))
			self.baseframe.header.emenda:SetTexCoord(unpack(COORDS_LEFT_CONNECTOR))
			
		elseif (self.toolbar_side == 2) then

			local l, r, t, b = unpack(COORDS_LEFT_BALL)
			self.baseframe.header.ball:SetTexCoord(l, r, b, t)
			local l, r, t, b = unpack(COORDS_LEFT_CONNECTOR)
			self.baseframe.header.emenda:SetTexCoord(l, r, b, t)
		end
	end
	
end

--> search key: ~desaturate
function _details:DesaturateMenu(value)

	if (value == nil) then
		value = self.desaturated_menu
	end

	if (value) then
	
		self.desaturated_menu = true
		self.baseframe.header.mode_selecao:GetNormalTexture():SetDesaturated(true)
		self.baseframe.header.segment:GetNormalTexture():SetDesaturated(true)
		self.baseframe.header.attribute:GetNormalTexture():SetDesaturated(true)
		self.baseframe.header.report:GetNormalTexture():SetDesaturated(true)
		
		if (self.mine_id == _details:GetLowerInstanceNumber()) then
			for _, button in _ipairs(_details.ToolBar.AllButtons) do
				button:GetNormalTexture():SetDesaturated(true)
			end
		end
		
	else
	
		self.desaturated_menu = false
		self.baseframe.header.mode_selecao:GetNormalTexture():SetDesaturated(false)
		self.baseframe.header.segment:GetNormalTexture():SetDesaturated(false)
		self.baseframe.header.attribute:GetNormalTexture():SetDesaturated(false)
		self.baseframe.header.report:GetNormalTexture():SetDesaturated(false)
		
		if (self.mine_id == _details:GetLowerInstanceNumber()) then
			for _, button in _ipairs(_details.ToolBar.AllButtons) do
				button:GetNormalTexture():SetDesaturated(false)
			end
		end
		
	end
end

function _details:DesaturateMenu2(value)

	if (value == nil) then
		value = self.desaturated_menu2
	end

	if (value) then
		self.desaturated_menu2 = true
		self.baseframe.header.close:GetNormalTexture():SetDesaturated(true)
		self.baseframe.header.novo:GetNormalTexture():SetDesaturated(true)
		self.baseframe.header.reset:GetNormalTexture():SetDesaturated(true)
	else
		self.desaturated_menu2 = false
		self.baseframe.header.close:GetNormalTexture():SetDesaturated(false)
		self.baseframe.header.novo:GetNormalTexture():SetDesaturated(false)
		self.baseframe.header.reset:GetNormalTexture():SetDesaturated(false)
	end
end

function _details:ShowSideBars(instance)
	if (instance) then
		self = instance
	end
	
	self.show_sidebars = true
	
	self.baseframe.bar_left:Show()
	self.baseframe.bar_right:Show()
	
	--> set default spacings
	local this_skin = _details.skins[self.skin]
	if (this_skin.instance_cprops and this_skin.instance_cprops.row_info and this_skin.instance_cprops.row_info.space) then
		self.row_info.space.left = this_skin.instance_cprops.row_info.space.left
		self.row_info.space.right = this_skin.instance_cprops.row_info.space.right
	else
		self.row_info.space.left = 3
		self.row_info.space.right = -5
	end

	if (self.show_statusbar) then
		self.baseframe.bar_left:SetPoint("bottomleft", self.baseframe, "bottomleft", -56, -14)
		self.baseframe.bar_right:SetPoint("bottomright", self.baseframe, "bottomright", 56, -14)
		
		if (self.toolbar_side == 2) then
			self.baseframe.bar_fundo:Show()
			local l, r, t, b = unpack(COORDS_BOTTOM_SIDE_BAR)
			self.baseframe.bar_fundo:SetTexCoord(l, r, b, t)
			self.baseframe.bar_fundo:ClearAllPoints()
			self.baseframe.bar_fundo:SetPoint("bottomleft", self.baseframe, "topleft", 0, -6)
			self.baseframe.bar_fundo:SetPoint("bottomright", self.baseframe, "topright", -1, -6)
		else
			self.baseframe.bar_fundo:Hide()
		end
	else
		self.baseframe.bar_left:SetPoint("bottomleft", self.baseframe, "bottomleft", -56, 0)
		self.baseframe.bar_right:SetPoint("bottomright", self.baseframe, "bottomright", 56, 0)
		
		self.baseframe.bar_fundo:Show()
		
		if (self.toolbar_side == 2) then --tooltbar on bottom
			local l, r, t, b = unpack(COORDS_BOTTOM_SIDE_BAR)
			self.baseframe.bar_fundo:SetTexCoord(l, r, b, t)
			self.baseframe.bar_fundo:ClearAllPoints()
			self.baseframe.bar_fundo:SetPoint("bottomleft", self.baseframe, "topleft", 0, -6)
			self.baseframe.bar_fundo:SetPoint("bottomright", self.baseframe, "topright", -1, -6)
		else --tooltbar on top
			self.baseframe.bar_fundo:SetTexCoord(unpack(COORDS_BOTTOM_SIDE_BAR))
			self.baseframe.bar_fundo:ClearAllPoints()
			self.baseframe.bar_fundo:SetPoint("bottomleft", self.baseframe, "bottomleft", 0, -56)
			self.baseframe.bar_fundo:SetPoint("bottomright", self.baseframe, "bottomright", -1, -56)
		end
	end
	
	self:SetBarGrowDirection()
	
end

function _details:HideSideBars(instance)
	if (instance) then
		self = instance
	end
	
	self.show_sidebars = false
	
	self.row_info.space.left = 0
	self.row_info.space.right = 0
	
	self.baseframe.bar_left:Hide()
	self.baseframe.bar_right:Hide()
	self.baseframe.bar_fundo:Hide()
	
	self:SetBarGrowDirection()
end

function _details:HideStatusBar(instance)
	if (instance) then
		self = instance
	end
	
	self.show_statusbar = false
	
	self.baseframe.rodape.left:Hide()
	self.baseframe.rodape.right:Hide()
	self.baseframe.rodape.top_bg:Hide()
	self.baseframe.rodape.StatusBarLeftAnchor:Hide()
	self.baseframe.rodape.StatusBarCenterAnchor:Hide()
	self.baseframe.DOWNFrame:Hide()
	
	if (self.toolbar_side == 2) then
		self:ToolbarSide()
	end
	
	if (self.show_sidebars) then
		self:ShowSideBars()
	end
	
	self:StretchButtonAnchor()
	
	if (self.micro_displays_side == 2) then --> bottom side
		_details.StatusBar:Hide(self) --> mini displays widgets
	end
end

function _details:StatusBarColor(r, g, b, a, no_save)

	if (not r) then
		r, g, b = unpack(self.statusbar_info.overlay)
		a = a or self.statusbar_info.alpha
	end

	if (not no_save) then
		self.statusbar_info.overlay[1] = r
		self.statusbar_info.overlay[2] = g
		self.statusbar_info.overlay[3] = b
		self.statusbar_info.alpha = a
	end
	
	self.baseframe.rodape.left:SetVertexColor(r, g, b)
	self.baseframe.rodape.left:SetAlpha(a)
	self.baseframe.rodape.right:SetVertexColor(r, g, b)
	self.baseframe.rodape.right:SetAlpha(a)
	self.baseframe.rodape.top_bg:SetVertexColor(r, g, b)
	self.baseframe.rodape.top_bg:SetAlpha(a)
	
end

function _details:ShowStatusBar(instance)
	if (instance) then
		self = instance
	end
	
	self.show_statusbar = true
	
	self.baseframe.rodape.left:Show()
	self.baseframe.rodape.right:Show()
	self.baseframe.rodape.top_bg:Show()
	self.baseframe.rodape.StatusBarLeftAnchor:Show()
	self.baseframe.rodape.StatusBarCenterAnchor:Show()
	self.baseframe.DOWNFrame:Show()
	
	self:ToolbarSide()
	self:StretchButtonAnchor()
	
	if (self.micro_displays_side == 2) then --> bottom side
		_details.StatusBar:Show(self) --> mini displays widgets
	end
end

function _details:SetTooltipBackdrop(border_texture, border_size, border_color)

	if (not border_texture) then
		border_texture = _details.tooltip.border_texture
	end
	if (not border_size) then
		border_size = _details.tooltip.border_size
	end
	if (not border_color) then
		border_color = _details.tooltip.border_color
	end

	_details.tooltip.border_texture = border_texture
	_details.tooltip.border_size = border_size

	local c = _details.tooltip.border_color
	local cc = _details.tooltip_border_color
	c[1], c[2], c[3], c[4] = border_color[1], border_color[2], border_color[3], border_color[4] or 1
	cc[1], cc[2], cc[3], cc[4] = border_color[1], border_color[2], border_color[3], border_color[4] or 1

	_details.tooltip_backdrop.edgeFile = SharedMedia:Fetch("border", border_texture)
	_details.tooltip_backdrop.edgeSize = border_size

end

--> reset button functions
	local reset_button_onenter = function(self)
	
		OnEnterMainWindow(self.instance, self)
		GameCooltip.buttonOver = true
		self.instance.baseframe.header.button_mouse_over = true
		
		GameCooltip:Reset()
		GameCooltip:SetOption("ButtonsYMod", -2)
		GameCooltip:SetOption("YSpacingMod", 0)
		GameCooltip:SetOption("TextHeightMod", 0)
		GameCooltip:SetOption("IgnoreButtonAutoHeight", false)
		
		local font = SharedMedia:Fetch("font", "Friz Quadrata TT")
		
		GameCooltip:AddLine(Loc["STRING_ERASE_DATA"], nil, 1, "white", nil, _details.font_sizes.menus, font)
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\UI-StopButton]], 1, 1, 14, 14, 0, 1, 0, 1, "red")
		GameCooltip:AddMenu(1, _details.table_history.reset)
		
		GameCooltip:AddLine(Loc["STRING_ERASE_DATA_OVERALL"], nil, 1, "white", nil, _details.font_sizes.menus, font)
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\UI-StopButton]], 1, 1, 14, 14, 0, 1, 0, 1, "orange")
		GameCooltip:AddMenu(1, _details.table_history.reset_overall)
		
		GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
		GameCooltip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		
		show_anti_overlap(self.instance, self, "top")
		
		GameCooltip:ShowCooltip(self, "menu")
	end
	
	local reset_button_onleave = function(self)
		OnLeaveMainWindow(self.instance, self)
		
		hide_anti_overlap(self.instance.baseframe.anti_menu_overlap)
		
		GameCooltip.buttonOver = false
		self.instance.baseframe.header.button_mouse_over = false
		
		if (GameCooltip.active) then
			parameters_table[2] = 0
			self:SetScript("OnUpdate", on_leave_menu)
		else
			self:SetScript("OnUpdate", nil)
		end
		
	end
	
--> close button functions

	local close_button_onclick = function(self, _, button)
		self = self or button
	
		self:Disable()
		self.instance:DisableInstance() 
		
		--> não há mais instâncias abertas, então manda msg alertando
		if (_details.opened_windows == 0) then
			_details:Msg(Loc["STRING_CLOSEALL"])
		end
		
		GameCooltip:Hide()
	end
	_details.close_instance_func = close_button_onclick

	local close_button_onenter = function(self)
		OnEnterMainWindow(self.instance, self, 3)

		GameCooltip.buttonOver = true
		self.instance.baseframe.header.button_mouse_over = true
		
		GameCooltip:Reset()
		GameCooltip:SetOption("ButtonsYMod", -4)
		GameCooltip:SetOption("ButtonsYModSub", -2)
		GameCooltip:SetOption("YSpacingMod", 0)
		GameCooltip:SetOption("YSpacingModSub", -3)
		GameCooltip:SetOption("TextHeightMod", 0)
		GameCooltip:SetOption("TextHeightModSub", 0)
		GameCooltip:SetOption("IgnoreButtonAutoHeight", false)
		GameCooltip:SetOption("IgnoreButtonAutoHeightSub", false)
		GameCooltip:SetOption("SubMenuIsTooltip", true)
		GameCooltip:SetOption("FixedWidthSub", 180)
		GameCooltip:SetOption("FixedHeight", 30)
		
		local font = SharedMedia:Fetch("font", "Friz Quadrata TT")
		GameCooltip:AddLine(Loc["STRING_MENU_CLOSE_INSTANCE"], nil, 1, "white", nil, _details.font_sizes.menus, font)
		GameCooltip:AddIcon([[Interface\Buttons\UI-Panel-MinimizeButton-Up]], 1, 1, 14, 14, 0.2, 0.8, 0.2, 0.8)
		GameCooltip:AddMenu(1, close_button_onclick, self)
		
		GameCooltip:AddLine(Loc["STRING_MENU_CLOSE_INSTANCE_DESC"], nil, 2, "white", nil, _details.font_sizes.menus, font)
		GameCooltip:AddIcon([[Interface\CHATFRAME\UI-ChatIcon-Minimize-Up]], 2, 1, 18, 18)
		
		GameCooltip:AddLine(Loc["STRING_MENU_CLOSE_INSTANCE_DESC2"], nil, 2, "white", nil, _details.font_sizes.menus, font)
		GameCooltip:AddIcon([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]], 2, 1, 18, 18)
		
		GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
		GameCooltip:SetWallpaper(2,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
		GameCooltip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		GameCooltip:SetBackdrop(2, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		
		show_anti_overlap(self.instance, self, "top")
		
		GameCooltip:ShowCooltip(self, "menu")
	end
	
	local close_button_onleave = function(self)
		OnLeaveMainWindow(self.instance, self, 3)

		hide_anti_overlap(self.instance.baseframe.anti_menu_overlap)
		
		GameCooltip.buttonOver = false
		self.instance.baseframe.header.button_mouse_over = false
		
		if (GameCooltip.active) then
			parameters_table[2] = 0
			self:SetScript("OnUpdate", on_leave_menu)
		else
			self:SetScript("OnUpdate", nil)
		end
		
	end
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> build upper menu bar

function gump:CreateCabecalho(baseframe, instance)

	baseframe.header = {}
	
	--> FECHAR instance ----------------------------------------------------------------------------------------------------------------------------------------------------
	baseframe.header.close = CreateFrame("button", "DetailsCloseInstanceButton" .. instance.mine_id, baseframe) --, "UIPanelCloseButton"
	baseframe.header.close:SetWidth(18)
	baseframe.header.close:SetHeight(18)
	baseframe.header.close:SetFrameLevel(5) --> altura mais alta que os demais frames
	baseframe.header.close:SetPoint("bottomright", baseframe, "topright", 5, -6) --> seta o ponto dele fixando no base frame
	
	baseframe.header.close:SetNormalTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Up]])
	baseframe.header.close:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
	baseframe.header.close:SetPushedTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Down]])
	
	baseframe.header.close.instance = instance
	baseframe.header.close.instance = instance
	
	baseframe.header.close:SetScript("OnEnter", close_button_onenter)
	baseframe.header.close:SetScript("OnLeave", close_button_onleave)
	
	baseframe.header.close:SetScript("OnClick", close_button_onclick)

	--> bola do canto esquedo superior --> primeiro create a armação para apoiar as textures
	baseframe.header.ball_point = baseframe.header.close:CreateTexture(nil, "overlay")
	baseframe.header.ball_point:SetPoint("bottomleft", baseframe, "topleft", -37, 0)
	baseframe.header.ball_point:SetWidth(64)
	baseframe.header.ball_point:SetHeight(32)
	
	--> icon do attribute
	--baseframe.header.attribute_icon = _details.listener:CreateTexture(nil, "artwork")
	baseframe.header.attribute_icon = baseframe:CreateTexture(nil, "background")
	local icon_anchor = _details.skins["Default Skin"].icon_anchor_main
	baseframe.header.attribute_icon:SetPoint("topright", baseframe.header.ball_point, "topright", icon_anchor[1], icon_anchor[2])
	baseframe.header.attribute_icon:SetTexture(DEFAULT_SKIN)
	baseframe.header.attribute_icon:SetWidth(32)
	baseframe.header.attribute_icon:SetHeight(32)
	
	--> bola overlay
	--baseframe.header.ball = _details.listener:CreateTexture(nil, "overlay")
	baseframe.header.ball = baseframe:CreateTexture(nil, "overlay")
	baseframe.header.ball:SetPoint("bottomleft", baseframe, "topleft", -107, 0)
	baseframe.header.ball:SetWidth(128)
	baseframe.header.ball:SetHeight(128)
	
	baseframe.header.ball:SetTexture(DEFAULT_SKIN)
	baseframe.header.ball:SetTexCoord(unpack(COORDS_LEFT_BALL))

	--> emenda
	baseframe.header.emenda = baseframe:CreateTexture(nil, "background")
	baseframe.header.emenda:SetPoint("bottomleft", baseframe.header.ball, "bottomright")
	baseframe.header.emenda:SetWidth(8)
	baseframe.header.emenda:SetHeight(128)
	baseframe.header.emenda:SetTexture(DEFAULT_SKIN)
	baseframe.header.emenda:SetTexCoord(unpack(COORDS_LEFT_CONNECTOR))

	baseframe.header.attribute_icon:Hide()
	baseframe.header.ball:Hide()

	--> bola do canto direito superior
	baseframe.header.ball_r = baseframe:CreateTexture(nil, "background")
	baseframe.header.ball_r:SetPoint("bottomright", baseframe, "topright", 96, 0)
	baseframe.header.ball_r:SetWidth(128)
	baseframe.header.ball_r:SetHeight(128)
	baseframe.header.ball_r:SetTexture(DEFAULT_SKIN)
	baseframe.header.ball_r:SetTexCoord(unpack(COORDS_RIGHT_BALL))

	--> bar centro
	baseframe.header.top_bg = baseframe:CreateTexture(nil, "background")
	baseframe.header.top_bg:SetPoint("left", baseframe.header.emenda, "right", 0, 0)
	baseframe.header.top_bg:SetPoint("right", baseframe.header.ball_r, "left")
	baseframe.header.top_bg:SetTexture(DEFAULT_SKIN)
	baseframe.header.top_bg:SetTexCoord(unpack(COORDS_TOP_BACKGROUND))
	baseframe.header.top_bg:SetWidth(512)
	baseframe.header.top_bg:SetHeight(128)

	--> frame invisível
	baseframe.UPFrame = CreateFrame("frame", "DetailsUpFrameInstance"..instance.mine_id, baseframe)
	baseframe.UPFrame:SetPoint("left", baseframe.header.ball, "right", 0, -53)
	baseframe.UPFrame:SetPoint("right", baseframe.header.ball_r, "left", 0, -53)
	baseframe.UPFrame:SetHeight(20)
	baseframe.UPFrame.is_toolbar = true
	
	baseframe.UPFrame:Show()
	baseframe.UPFrame:EnableMouse(true)
	baseframe.UPFrame:SetMovable(true)
	baseframe.UPFrame:SetResizable(true)
	
	BGFrame_scripts(baseframe.UPFrame, baseframe, instance)
	
	--> corrige o vão entre o baseframe e o upframe
	baseframe.UPFrameConnect = CreateFrame("frame", "DetailsAntiGap"..instance.mine_id, baseframe)
	baseframe.UPFrameConnect:SetPoint("bottomleft", baseframe, "topleft", 0, -1)
	baseframe.UPFrameConnect:SetPoint("bottomright", baseframe, "topright", 0, -1)
	baseframe.UPFrameConnect:SetHeight(2)
	baseframe.UPFrameConnect:EnableMouse(true)
	baseframe.UPFrameConnect:SetMovable(true)
	baseframe.UPFrameConnect:SetResizable(true)
	baseframe.UPFrameConnect.is_toolbar = true
	
	BGFrame_scripts(baseframe.UPFrameConnect, baseframe, instance)
	
	baseframe.UPFrameLeftPart = CreateFrame("frame", "DetailsUpFrameLeftPart"..instance.mine_id, baseframe)
	baseframe.UPFrameLeftPart:SetPoint("bottomleft", baseframe, "topleft", 0, 0)
	baseframe.UPFrameLeftPart:SetSize(22, 20)
	baseframe.UPFrameLeftPart:EnableMouse(true)
	baseframe.UPFrameLeftPart:SetMovable(true)
	baseframe.UPFrameLeftPart:SetResizable(true)
	baseframe.UPFrameLeftPart.is_toolbar = true
	
	BGFrame_scripts(baseframe.UPFrameLeftPart, baseframe, instance)

	--> anchors para os micro displays no side de cima da window
	local StatusBarLeftAnchor = CreateFrame("frame", "DetailsStatusBarLeftAnchor" .. instance.mine_id, baseframe)
	StatusBarLeftAnchor:SetPoint("bottomleft", baseframe, "topleft", 0, 9)
	StatusBarLeftAnchor:SetWidth(1)
	StatusBarLeftAnchor:SetHeight(1)
	baseframe.header.StatusBarLeftAnchor = StatusBarLeftAnchor
	
	local StatusBarCenterAnchor = CreateFrame("frame", "DetailsStatusBarCenterAnchor" .. instance.mine_id, baseframe)
	StatusBarCenterAnchor:SetPoint("center", baseframe, "center")
	StatusBarCenterAnchor:SetPoint("bottom", baseframe, "top", 0, 9)
	StatusBarCenterAnchor:SetWidth(1)
	StatusBarCenterAnchor:SetHeight(1)
	baseframe.header.StatusBarCenterAnchor = StatusBarCenterAnchor	

	local StatusBarRightAnchor = CreateFrame("frame", "DetailsStatusBarRightAnchor" .. instance.mine_id, baseframe)
	StatusBarRightAnchor:SetPoint("bottomright", baseframe, "topright", 0, 9)
	StatusBarRightAnchor:SetWidth(1)
	StatusBarRightAnchor:SetHeight(1)
	baseframe.header.StatusBarRightAnchor = StatusBarRightAnchor
	
	local MenuAnchorLeft = CreateFrame("frame", "DetailsMenuAnchorLeft"..instance.mine_id, baseframe)
	MenuAnchorLeft:SetSize(1, 1)
	
	local MenuAnchorRight = CreateFrame("frame", "DetailsMenuAnchorRight"..instance.mine_id, baseframe)
	MenuAnchorRight:SetSize(1, 1)
	
	local Menu2AnchorRight = CreateFrame("frame", "DetailsMenu2AnchorRight"..instance.mine_id, baseframe)
	Menu2AnchorRight:SetSize(1, 1)
	
	instance.menu_points = {MenuAnchorLeft, MenuAnchorRight}
	instance.menu2_points = {Menu2AnchorRight}
	
-- botões	
------------------------------------------------------------------------------------------------------------------------------------------------- 	

	local CoolTip = _G.GameCooltip

	--> SELEÇÃO DO MODE ----------------------------------------------------------------------------------------------------------------------------------------------------
	
	baseframe.header.mode_selecao = gump:NewButton(baseframe, nil, "DetailsModeButton"..instance.mine_id, nil, 16, 16, _details.empty_function, nil, nil,[[Interface\AddOns\Details\images\mode_icon]])
	baseframe.header.mode_selecao:SetPoint("bottomleft", baseframe.header.ball, "bottomright", instance.menu_anchor[1], instance.menu_anchor[2])
	baseframe.header.mode_selecao:SetFrameLevel(baseframe:GetFrameLevel()+5)

	--> Generating Cooltip menu from table template
	local modeMenuTable = {
	
		{text = Loc["STRING_MODE_GROUP"]},
		{func = instance.ChangeMode, param1 = 2},
		{icon =[[Interface\AddOns\Details\images\mode_icons]], l = 32/256, r = 32/256*2, t = 0, b = 1, width = 20, height = 20},
		{text = Loc["STRING_HELP_MODEGROUP"], type = 2},
		{icon =[[Interface\TUTORIALFRAME\TutorialFrame-QuestionMark]], type = 2, width = 16, height = 16, l = 8/64, r = 1 -(8/64), t = 8/64, b = 1 -(8/64)},

		{text = Loc["STRING_MODE_ALL"]},
		{func = instance.ChangeMode, param1 = 3},
		{icon =[[Interface\AddOns\Details\images\mode_icons]], l = 32/256*2, r = 32/256*3, t = 0, b = 1, width = 20, height = 20},
		{text = Loc["STRING_HELP_MODEALL"], type = 2},
		{icon =[[Interface\TUTORIALFRAME\TutorialFrame-QuestionMark]], type = 2, width = 16, height = 16, l = 8/64, r = 1 -(8/64), t = 8/64, b = 1 -(8/64)},		

		{text = Loc["STRING_MODE_RAID"]}, -- .. "(|cffa0a0a0" .. Loc["STRING_MODE_PLUGINS"] .. "|r)"
		{func = instance.ChangeMode, param1 = 4},
		{icon =[[Interface\AddOns\Details\images\mode_icons]], l = 32/256*3, r = 32/256*4, t = 0, b = 1, width = 20, height = 20},
		{text = Loc["STRING_HELP_MODERAID"], type = 2},
		{icon =[[Interface\TUTORIALFRAME\TutorialFrame-QuestionMark]], type = 2, width = 16, height = 16, l = 8/64, r = 1 -(8/64), t = 8/64, b = 1 -(8/64)},
		
		{text = Loc["STRING_MODE_SELF"]}, -- .. "(|cffa0a0a0" .. Loc["STRING_MODE_PLUGINS"] .. "|r)"
		{func = instance.ChangeMode, param1 = 1},
		{icon =[[Interface\AddOns\Details\images\mode_icons]], l = 0, r = 32/256, t = 0, b = 1, width = 20, height = 20},
		{text = Loc["STRING_HELP_MODESELF"], type = 2},
		{icon =[[Interface\TUTORIALFRAME\TutorialFrame-QuestionMark]], type = 2, width = 16, height = 16, l = 8/64, r = 1 -(8/64), t = 8/64, b = 1 -(8/64)},

		{text = Loc["STRING_OPTIONS_WINDOW"]},
		{func = _details.OpenOptionsWindow},
		{icon =[[Interface\AddOns\Details\images\mode_icons]], l = 32/256*4, r = 32/256*5, t = 0, b = 1, width = 20, height = 20},
	}
	
	--> Cooltip raw method for enter/leave show/hide
	baseframe.header.mode_selecao:SetScript("OnEnter", function(self)
	
		--gump:Fade(baseframe.button_stretch, "alpha", 0.3)
		OnEnterMainWindow(instance, self, 3)
		
		if (instance.desaturated_menu) then
			self:GetNormalTexture():SetDesaturated(false)
		end
		
		_G.GameCooltip.buttonOver = true
		baseframe.header.button_mouse_over = true
		
		local passou = 0
		if (_G.GameCooltip.active) then
			passou = 0.15
		end

		local checked
		if (instance.mode == 1) then
			checked = 4
		elseif (instance.mode == 2) then
			checked = 1
		elseif (instance.mode == 3) then
			checked = 2
		elseif (instance.mode == 4) then
			checked = 3
		end

		parameters_table[1] = instance
		parameters_table[2] = passou
		parameters_table[3] = checked
		parameters_table[4] = modeMenuTable
		
		self:SetScript("OnUpdate", build_mode_list)
	end)
	
	baseframe.header.mode_selecao:SetScript("OnLeave", function(self) 
		OnLeaveMainWindow(instance, self, 3)
		
		hide_anti_overlap(instance.baseframe.anti_menu_overlap)
		
		if (instance.desaturated_menu) then
			self:GetNormalTexture():SetDesaturated(true)
		end
		
		_G.GameCooltip.buttonOver = false
		baseframe.header.button_mouse_over = false
		
		if (_G.GameCooltip.active) then
			parameters_table[2] = 0
			self:SetScript("OnUpdate", on_leave_menu)
		else
			self:SetScript("OnUpdate", nil)
		end
	end)
	
	--> SELECIONAR O SEGMENTO  ----------------------------------------------------------------------------------------------------------------------------------------------------
	baseframe.header.segment = gump:NewButton(baseframe, nil, "DetailsSegmentButton"..instance.mine_id, nil, 16, 16, _details.empty_function, nil, nil,[[Interface\AddOns\Details\images\segments_icon]])
	baseframe.header.segment:SetFrameLevel(baseframe.UPFrame:GetFrameLevel()+1)

	baseframe.header.segment:SetHook("OnMouseUp", function(button, buttontype)

		if (buttontype == "LeftButton") then
		
			local segment_goal = instance.segment + 1
			if (segment_goal > segments_used) then
				segment_goal = -1
			elseif (segment_goal > _details.segments_amount) then
				segment_goal = -1
			end
			
			local total_shown = segments_filled+2
			local goal = segment_goal+1
			
			local select_ = math.abs(goal - total_shown)
			GameCooltip:Select(1, select_)
			
			return instance:SwitchTable(segment_goal)
		elseif (buttontype == "RightButton") then
		
			local segment_goal = instance.segment - 1
			if (segment_goal < -1) then
				segment_goal = segments_used
			end
			
			local total_shown = segments_filled+2
			local goal = segment_goal+1
			
			local select_ = math.abs(goal - total_shown)
			GameCooltip:Select(1, select_)
			
			return instance:SwitchTable(segment_goal)
		
		elseif (buttontype == "MiddleButton") then
			
			local segment_goal = 0
			
			local total_shown = segments_filled+2
			local goal = segment_goal+1
			
			local select_ = math.abs(goal - total_shown)
			GameCooltip:Select(1, select_)
			
			return instance:SwitchTable(segment_goal)
			
		end
	end)
	baseframe.header.segment:SetPoint("left", baseframe.header.mode_selecao, "right", 0, 0)

	--> Cooltip raw method for show/hide onenter/onhide
	baseframe.header.segment:SetScript("OnEnter", function(self) 
		--gump:Fade(baseframe.button_stretch, "alpha", 0.3)
		OnEnterMainWindow(instance, self, 3)
		
		if (instance.desaturated_menu) then
			self:GetNormalTexture():SetDesaturated(false)
		end
		
		_G.GameCooltip.buttonOver = true
		baseframe.header.button_mouse_over = true
		
		local passou = 0
		if (_G.GameCooltip.active) then
			passou = 0.15
		end

		parameters_table[1] = instance
		parameters_table[2] = passou
		self:SetScript("OnUpdate", build_segment_list)
	end)
	
	--> Cooltip raw method
	baseframe.header.segment:SetScript("OnLeave", function(self) 
		--gump:Fade(baseframe.button_stretch, -1)
		OnLeaveMainWindow(instance, self, 3)

		hide_anti_overlap(instance.baseframe.anti_menu_overlap)
		
		if (instance.desaturated_menu) then
			self:GetNormalTexture():SetDesaturated(true)
		end
		
		_G.GameCooltip.buttonOver = false
		baseframe.header.button_mouse_over = false
		
		if (_G.GameCooltip.active) then
			parameters_table[2] = 0
			self:SetScript("OnUpdate", on_leave_menu)
		else
			self:SetScript("OnUpdate", nil)
		end
	end)	

	--> SELECIONAR O ATRIBUTO  ----------------------------------------------------------------------------------------------------------------------------------------------------
	baseframe.header.attribute = gump:NewButton(baseframe, nil, "DetailsAttributeButton"..instance.mine_id, nil, 16, 16, instance.SwitchTable, instance, -3,[[Interface\AddOns\Details\images\sword]])
	--baseframe.header.attribute = gump:NewDetailsButton(baseframe, _, instance, instance.SwitchTable, instance, -3, 16, 16,[[Interface\AddOns\Details\images\sword]])
	baseframe.header.attribute:SetFrameLevel(baseframe.UPFrame:GetFrameLevel()+1)
	baseframe.header.attribute:SetPoint("left", baseframe.header.segment.widget, "right", 0, 0)

	--> Cooltip automatic method through Injection
	
	--> First we declare the function which will build the menu
	local BuildAttributeMenu = function()
		if (_details.solo and _details.solo == instance.mine_id) then
			_details:SetSoloOption(instance)
		elseif (instance:IsRaidMode()) then
			local have_plugins = _details:SetRaidOption(instance)
			if (not have_plugins) then
				GameCooltip:SetType("tooltip")
				GameCooltip:SetOption("ButtonsYMod", 0)
				GameCooltip:SetOption("YSpacingMod", 0)
				GameCooltip:SetOption("TextHeightMod", 0)
				GameCooltip:SetOption("IgnoreButtonAutoHeight", false)
				GameCooltip:AddLine("All raid plugins already\nin use or disabled.", nil, 1, "white", nil, 10, SharedMedia:Fetch("font", "Friz Quadrata TT"))
				GameCooltip:AddIcon([[Interface\GROUPFRAME\UI-GROUP-ASSISTANTICON]], 1, 1)
				GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
			end
		else
			_details:SetAttributesOption(instance)
		end
		
		GameCooltip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		GameCooltip:SetBackdrop(2, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
	end
	
	--> Now we create a table with some parameters
	--> your frame need to have a member called CoolTip
	baseframe.header.attribute.CoolTip = {
		Type = "menu", --> the type, menu tooltip tooltipbars
		BuildFunc = BuildAttributeMenu, --> called when user mouse over the frame
		OnEnterFunc = function(self) 
			baseframe.header.button_mouse_over = true; 
			OnEnterMainWindow(instance, baseframe.header.attribute, 3) 
			show_anti_overlap(instance, self, "top")
			if (instance.desaturated_menu) then
				self:GetNormalTexture():SetDesaturated(false)
			end
		end,
		OnLeaveFunc = function(self) 
			baseframe.header.button_mouse_over = false; 
			OnLeaveMainWindow(instance, baseframe.header.attribute, 3) 
			hide_anti_overlap(instance.baseframe.anti_menu_overlap)
			if (instance.desaturated_menu) then
				self:GetNormalTexture():SetDesaturated(true)
			end
		end,
		FixedValue = instance,
		ShowSpeed = 0.15,
		Options = function()
			if (instance.consolidate) then
				return {Anchor = instance.consolidateFrame, MyAnchor = "topleft", RelativeAnchor = "topright", TextSize = _details.font_sizes.menus}
			else
				if (instance.toolbar_side == 1) then --top
					return {TextSize = _details.font_sizes.menus}
				elseif (instance.toolbar_side == 2) then --bottom
					return {TextSize = _details.font_sizes.menus, HeightAnchorMod = 0} -- -7
				end
			end
		end}
	
	--> install cooltip
	_G.GameCooltip:CoolTipInject(baseframe.header.attribute)

	--> REPORTAR ~report ----------------------------------------------------------------------------------------------------------------------------------------------------
			baseframe.header.report = gump:NewButton(baseframe, nil, "DetailsReportButton"..instance.mine_id, nil, 8, 16, _details.Report, instance, nil,[[Interface\Addons\Details\Images\report_button]])
			--baseframe.header.report = gump:NewDetailsButton(baseframe, _, instance, _details.Report, instance, nil, 16, 16,[[Interface\COMMON\VOICECHAT-ON]])
			baseframe.header.report:SetPoint("left", baseframe.header.attribute, "right", -6, 0)
			baseframe.header.report:SetFrameLevel(baseframe.UPFrame:GetFrameLevel()+1)
			baseframe.header.report:SetScript("OnEnter", function(self)
				OnEnterMainWindow(instance, self, 3)
				if (instance.desaturated_menu) then
					self:GetNormalTexture():SetDesaturated(false)
				end
				
				GameCooltip.buttonOver = true
				baseframe.header.button_mouse_over = true
				
				GameCooltip:Reset()
				GameCooltip:SetOption("ButtonsYMod", -3)
				GameCooltip:SetOption("YSpacingMod", 0)
				GameCooltip:SetOption("TextHeightMod", 0)
				GameCooltip:SetOption("IgnoreButtonAutoHeight", false)
				
				GameCooltip:AddLine("Report Results", nil, 1, "white", nil, _details.font_sizes.menus, SharedMedia:Fetch("font", "Friz Quadrata TT"))
				GameCooltip:AddIcon([[Interface\Addons\Details\Images\report_button]], 1, 1, 12, 19)
				GameCooltip:AddMenu(1, _details.Report, instance)
				
				GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
				GameCooltip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
				
				show_anti_overlap(instance, self, "top")
				
				GameCooltip:ShowCooltip(self, "menu")
				
			end)
			baseframe.header.report:SetScript("OnLeave", function(self)
			
				OnLeaveMainWindow(instance, self, 3)
				
				hide_anti_overlap(instance.baseframe.anti_menu_overlap)
				
				GameCooltip.buttonOver = false
				baseframe.header.button_mouse_over = false
				
				if (instance.desaturated_menu) then
					self:GetNormalTexture():SetDesaturated(true)
				end
				
				if (GameCooltip.active) then
					parameters_table[2] = 0
					self:SetScript("OnUpdate", on_leave_menu)
				else
					self:SetScript("OnUpdate", nil)
				end

			end)

	--> NOVA instance ----------------------------------------------------------------------------------------------------------------------------------------------------
	baseframe.header.novo = CreateFrame("button", "DetailsInstanceButton"..instance.mine_id, baseframe) --, "OptionsButtonTemplate"
	baseframe.header.novo:SetFrameLevel(baseframe.UPFrame:GetFrameLevel()+1)
	
	baseframe.header.novo:SetNormalTexture([[Interface\AddOns\Details\images\skins\default_skin]])
	baseframe.header.novo:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
	baseframe.header.novo:SetPushedTexture([[Interface\AddOns\Details\images\skins\default_skin]])
	
	baseframe.header.novo:SetWidth(20)
	baseframe.header.novo:SetHeight(16)

	baseframe.header.novo:SetPoint("bottomright", baseframe, "topright", instance.instance_button_anchor[1], instance.instance_button_anchor[2])
	
	baseframe.header.novo:SetScript("OnClick", function() _details:Createinstance(_, true); _G.GameCooltip:ShowMe(false) end)
	baseframe.header.novo:SetText("#"..instance.mine_id)
	baseframe.header.novo:SetNormalFontObject("GameFontNormalSmall")

	--> cooltip through inject
	--> OnClick Function[1] caller[2] fixed param[3] param1[4] param2
	local OnClickNewMenu = function(_, _, id)
		_details.Createinstance(_, _, id)
		_G.GameCooltip:ExecFunc(baseframe.header.novo)
	end
	
	--> Build Menu Function
	local BuildClosedInstanceMenu = function() 
	
		local ClosedInstances = 0
		
		for index = 1, math.min(#_details.table_instances, _details.instances_amount), 1 do 
		
			local _this_instance = _details.table_instances[index]
			
			if (not _this_instance.active) then --> só reopen se ela estiver active
			
				--> pegar o que ela ta showing
				local attribute = _this_instance.attribute
				local sub_attribute = _this_instance.sub_attribute
				ClosedInstances = ClosedInstances + 1
				
				if (attribute == 5) then --> custom
				
					local CustomObject = _details.custom[sub_attribute]
					
					if (not CustomObject) then
						_this_instance:ResetAttribute()
						attribute = _this_instance.attribute
						sub_attribute = _this_instance.sub_attribute
						CoolTip:AddMenu(1, OnClickNewMenu, index, nil, nil, "#".. index .. " " .. _details.attributes.list[attribute] .. " - " .. _details.sub_attributes[attribute].list[sub_attribute], _, true)
						CoolTip:AddIcon(_details.sub_attributes[attribute].icons[sub_attribute][1], 1, 1, 20, 20, unpack(_details.sub_attributes[attribute].icons[sub_attribute][2]))
					else
						CoolTip:AddMenu(1, OnClickNewMenu, index, nil, nil, "#".. index .. " " .. _details.attributes.list[attribute] .. " - " .. CustomObject:GetName(), _, true)
						CoolTip:AddIcon(CustomObject.icon, 1, 1, 20, 20, 0, 1, 0, 1)
					end

				else
					local mode = _this_instance.mode
					
					if (mode == 1) then --alone
					
						attribute = _details.SoloTables.Mode or 1
						local SoloInfo = _details.SoloTables.Menu[attribute]
						if (SoloInfo) then
							CoolTip:AddMenu(1, OnClickNewMenu, index, nil, nil, "#".. index .. " " .. SoloInfo[1], _, true)
							CoolTip:AddIcon(SoloInfo[2], 1, 1, 20, 20, 0, 1, 0, 1)
						else
							CoolTip:AddMenu(1, OnClickNewMenu, index, nil, nil, "#".. index .. " Unknown Plugin", _, true)
						end
						
					elseif (mode == 4) then --raid
					
						local plugin_name = _this_instance.current_raid_plugin or _this_instance.last_raid_plugin
						if (plugin_name) then
							local plugin_object = _details:GetPlugin(plugin_name)
							if (plugin_object) then
								CoolTip:AddMenu(1, OnClickNewMenu, index, nil, nil, "#".. index .. " " .. plugin_object.__name, _, true)
								CoolTip:AddIcon(plugin_object.__icon, 1, 1, 20, 20, 0, 1, 0, 1)	
							else
								CoolTip:AddMenu(1, OnClickNewMenu, index, nil, nil, "#".. index .. " Unknown Plugin", _, true)
							end
						else
							CoolTip:AddMenu(1, OnClickNewMenu, index, nil, nil, "#".. index .. " Unknown Plugin", _, true)
						end
						
					else
					
						CoolTip:AddMenu(1, OnClickNewMenu, index, nil, nil, "#".. index .. " " .. _details.attributes.list[attribute] .. " - " .. _details.sub_attributes[attribute].list[sub_attribute], _, true)
						CoolTip:AddIcon(_details.sub_attributes[attribute].icons[sub_attribute][1], 1, 1, 20, 20, unpack(_details.sub_attributes[attribute].icons[sub_attribute][2]))
						
					end
				end

				CoolTip:SetOption("TextSize", _details.font_sizes.menus)
			end
		end
		
		if (ClosedInstances == 0) then
			if (_details:GetNumInstancesAmount() == _details:GetMaxInstancesAmount()) then
				CoolTip:AddMenu(1, _details.Createinstance, true, nil, nil, Loc["STRING_NOMORE_INSTANCES"], _, true)
				CoolTip:AddIcon([[Interface\Buttons\UI-PlusButton-Up]], 1, 1, 16, 16)
			else
				CoolTip:AddMenu(1, _details.Createinstance, true, nil, nil, Loc["STRING_NOCLOSED_INSTANCES"], _, true)
				CoolTip:AddIcon([[Interface\Buttons\UI-AttributeButton-Encourage-Up]], 1, 1, 16, 16)
			end
		end
		
		GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
		GameCooltip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		GameCooltip:SetBackdrop(2, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
		
		return ClosedInstances
	end
	
	--> Inject Options Table
	baseframe.header.novo.CoolTip = { 
		--> cooltip type "menu" "tooltip" "tooltipbars"
		Type = "menu",
		--> how much time wait with mouse over the frame until cooltip show up
		ShowSpeed = 0.15,
		--> will call for build menu
		BuildFunc = BuildClosedInstanceMenu, 
		--> a hook for OnEnterScript
		OnEnterFunc = function() OnEnterMainWindow(instance, baseframe.header.novo, 3) end,
		--> a hook for OnLeaveScript
		OnLeaveFunc = function() OnLeaveMainWindow(instance, baseframe.header.novo, 3) end,
		--> default message if there is no option avaliable
		Default = Loc["STRING_NOCLOSED_INSTANCES"],
		--> instance is the first parameter sent after click, before parameters
		FixedValue = instance,
		Options = function()
			if (instance.toolbar_side == 1) then --top
				return {TextSize = 10, NoLastSelectedBar = true, ButtonsYMod = -2}
			elseif (instance.toolbar_side == 2) then --bottom
				return {HeightAnchorMod = -7, TextSize = 10, NoLastSelectedBar = true}
			end
		end
	}
	
	--> Inject
	_G.GameCooltip:CoolTipInject(baseframe.header.novo)
	
-- ~delete ~erase
--> reset history ----------------------------------------------------------------------------------------------------------------------------------------------------

	baseframe.header.reset = CreateFrame("button", "DetailsClearSegmentsButton" .. instance.mine_id, baseframe)
	baseframe.header.reset:SetFrameLevel(baseframe.UPFrame:GetFrameLevel()+1)
	baseframe.header.reset:SetSize(10, 16)
	baseframe.header.reset:SetPoint("right", baseframe.header.novo, "left")
	baseframe.header.reset.instance = instance
	baseframe.header.reset:SetScript("OnClick", function() 
		if (not _details.disable_reset_button) then
			_details.table_history:reset() 
		else
			_details:Msg(Loc["STRING_OPTIONS_DISABLED_RESET"])
		end
	end)
	baseframe.header.reset:SetScript("OnEnter", reset_button_onenter)
	baseframe.header.reset:SetScript("OnLeave", reset_button_onleave)
	
	baseframe.header.reset:SetNormalTexture([[Interface\Addons\Details\Images\reset_button2]])
	baseframe.header.reset:SetHighlightTexture([[Interface\Addons\Details\Images\reset_button2]])
	baseframe.header.reset:SetPushedTexture([[Interface\Addons\Details\Images\reset_button2]])
	
--> end botão reset


--[[

--> test com shadows

--mode
	local shadow = baseframe.header.mode_selecao:CreateTexture("sombra", "background")
	shadow:SetPoint("center", baseframe.header.mode_selecao.widget, "center")
	shadow:SetTexture("Interface\\PetBattles\\PetBattle-SelectedPetGlow")
	shadow:SetVertexColor(0, 0, 0, 1)
	shadow:SetSize(22, 22)
--segments
	local shadow = baseframe.header.segment:CreateTexture("sombra2", "background")
	shadow:SetPoint("center", baseframe.header.segment.widget, "center")
	shadow:SetTexture("Interface\\PetBattles\\PetBattle-SelectedPetGlow")
	shadow:SetVertexColor(0, 0, 0, 1)
	shadow:SetSize(22, 22)
--attribute
	local shadow = baseframe.header.attribute:CreateTexture("sombra3", "background")
	shadow:SetPoint("center", baseframe.header.attribute.widget, "center")
	shadow:SetTexture("Interface\\PetBattles\\PetBattle-SelectedPetGlow")
	shadow:SetVertexColor(0, 0, 0, 1)
	shadow:SetSize(12, 16)
	shadow:SetTexCoord(0.0, 0.0, 0.3, 0.3, 0.7, 0.7, 1, 1)
--report
	local shadow = baseframe.header.report:CreateTexture("sombra4", "background")
	shadow:SetPoint("center", baseframe.header.report.widget, "center")
	shadow:SetTexture("Interface\\PetBattles\\PetBattle-SelectedPetGlow")
	shadow:SetVertexColor(0, 0, 0, 1)
	shadow:SetSize(22, 22)
	
--baseToolbar.novo, baseToolbar.close, baseToolbar.reset}baseToolbar.mode_selecao, baseToolbar.segment, baseToolbar.attribute, baseToolbar.report	

	local shadow = UIParent:CreateTexture("SombraTthis", "background")
	shadow:SetPoint("center", UIParent, "center", 200, 0)
	shadow:SetTexture("Interface\\PetBattles\\PetBattle-SelectedPetGlow")
	shadow:SetVertexColor(0, 0, 0, 1)
	shadow:SetSize(300, 300)
	shadow:SetTexCoord(0.0, 0.0, 0.3, 0.3, 0.7, 0.7, 1, 1)
	--]]
end
