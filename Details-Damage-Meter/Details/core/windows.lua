--> this file controls the window position, size and others panels
	
	local _details =	_G._details
	local Loc =			LibStub("AceLocale-3.0"):GetLocale( "Details" )
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers
	
	local _math_floor = math.floor --lua local
	local _type = type --lua local
	local _math_abs = math.abs --lua local
	local _ipairs = ipairs --lua local
	
	local _GetScreenWidth = GetScreenWidth --wow api local
	local _GetScreenHeight = GetScreenHeight --wow api local
	local _UIParent = UIParent --wow api local
	
	local gump = _details.gump --details local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local end_window_spacement = 0
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function _details:AnimarSplit(bar, goal)
		bar.start = bar.split.bar:GetValue()
		bar.stop = goal
		bar.proximo_update = 0
		bar.has_animation = true
		bar:SetScript("OnUpdate", self.FazerAnimacaoSplit)
	end

	function _details:FazerAnimacaoSplit(elapsed)
		local velocidade = 0.8
		
		if (self.stop > self.start) then
			self.start = self.start+velocidade
			self.split.bar:SetValue(self.start)

			self.split.div:SetPoint("left", self.split.bar, "left", self.split.bar:GetValue()*(self.split.bar:GetWidth()/100) - 4, 0)
			
			if (self.start+1 >= self.stop) then
				self.has_animation = false
				self:SetScript("OnUpdate", nil)
			end
		else
			self.start = self.start-velocidade
			self.split.bar:SetValue(self.start)
			
			self.split.div:SetPoint("left", self.split.bar, "left", self.split.bar:GetValue()*(self.split.bar:GetWidth()/100) - 4, 0)
			
			if (self.start-1 <= self.stop) then
				self.has_animation = false
				self:SetScript("OnUpdate", nil)
			end
		end
		self.proximo_update = 0
	end

	function _details:do_animations()
		
		--[
		for i = 2, self.rows_fit_in_window do
			--local row_previous = self.bars[i-1]
			local row = self.bars[i]
			local row_proxima = self.bars[i+1]
			
			if (row_proxima and not row.animation_ignore) then
				local v = row.statusbar:GetValue()
				local v_proxima = row_proxima.statusbar:GetValue()
				
				if (v_proxima > v) then
					if (row.animation_end >= v_proxima) then
						row.statusbar:SetValue(v_proxima)
					else
						row.statusbar:SetValue(row.animation_end)
						row_proxima.statusbar:SetValue(row.animation_end)
					end
				end
			end
		end
		--]]
		
		for i = 2, self.rows_fit_in_window do
			local row = self.bars[i]
			if (row.animation_ignore) then
				row.animation_ignore = nil
				if (row.has_animation) then
					row.has_animation = false
					row:SetScript("OnUpdate", nil)
				end
			else
				if (row.animation_end ~= row.animation_end2) then
					_details:AnimarBar(row, row.animation_end)
					row.animation_end2 = row.animation_end
				end
			end
		end
		
	end
	
	function _details:AnimarBar(this_bar, stop)
		this_bar.start = this_bar.statusbar:GetValue()
		this_bar.stop = stop
		this_bar.has_animation = true
		
		if (this_bar.stop > this_bar.start) then
			this_bar:SetScript("OnUpdate", self.FazerAnimacao_Direita)
		else
			this_bar:SetScript("OnUpdate", self.FazerAnimacao_Esquerda)
		end
	end

	function _details:FazerAnimacao_Esquerda(elapsed)
		self.start = self.start - 1
		self.statusbar:SetValue(self.start)
		if (self.start-1 <= self.stop) then
			self.has_animation = false
			self:SetScript("OnUpdate", nil)
		end
	end
	
	function _details:FazerAnimacao_Direita(elapsed)
		self.start = self.start + 1
		self.statusbar:SetValue(self.start)
		if (self.start+1 >= self.stop) then
			self.has_animation = false
			self:SetScript("OnUpdate", nil)
		end
	end

	function _details:UpdatePontos()
		local _x, _y = self:GetPositionOnScreen()
		if (not _x) then
			return
		end
		local _w, _h = self:GetRealSize()

		local metade_width = _w/2
		local metade_altura = _h/2
		
		local statusbar_y_mod = 0
		if (not self.show_statusbar) then
			statusbar_y_mod = 14 * self.baseframe:GetScale()
		end
		
		if (not self.ponto1) then
			self.ponto1 = {x = _x - metade_width, y = _y + metade_altura +(statusbar_y_mod*-1)} --topleft
			self.ponto2 = {x = _x - metade_width, y = _y - metade_altura + statusbar_y_mod} --bottomleft
			self.ponto3 = {x = _x + metade_width, y = _y - metade_altura + statusbar_y_mod} --bottomright
			self.ponto4 = {x = _x + metade_width, y = _y + metade_altura +(statusbar_y_mod*-1)} --topright
		else
			self.ponto1.x = _x - metade_width
			self.ponto1.y = _y + metade_altura +(statusbar_y_mod*-1)
			self.ponto2.x = _x - metade_width
			self.ponto2.y = _y - metade_altura + statusbar_y_mod
			self.ponto3.x = _x + metade_width
			self.ponto3.y = _y - metade_altura + statusbar_y_mod
			self.ponto4.x = _x + metade_width
			self.ponto4.y = _y + metade_altura +(statusbar_y_mod*-1)
		end
	end

	function _details:SaveMainWindowPosition(instance)
		
		if (instance) then
			self = instance
		end
		local displaying = self.displaying
		
		--> get sizes
		local baseframe_width = self.baseframe:GetWidth()
		local baseframe_height = self.baseframe:GetHeight()
		if (not baseframe_width) then
			return _details:ScheduleTimer("SaveMainWindowPosition", 1, self)
		end
		
		--> calc position
		local _x, _y = self:GetPositionOnScreen()
		if (not _x) then
			return _details:ScheduleTimer("SaveMainWindowPosition", 1, self)
		end

		--> save the position
		local _w = baseframe_width
		local _h = baseframe_height
		
		self.position[displaying].x = _x
		self.position[displaying].y = _y
		self.position[displaying].w = _w
		self.position[displaying].h = _h
		
		--> update the 4 points for window groups
		local metade_width = _w/2
		local metade_altura = _h/2
		
		local statusbar_y_mod = 0
		if (not self.show_statusbar) then
			statusbar_y_mod = 14
		end
		
		if (not self.ponto1) then
			self.ponto1 = {x = _x - metade_width, y = _y + metade_altura +(statusbar_y_mod*-1)} --topleft
			self.ponto2 = {x = _x - metade_width, y = _y - metade_altura + statusbar_y_mod} --bottomleft
			self.ponto3 = {x = _x + metade_width, y = _y - metade_altura + statusbar_y_mod} --bottomright
			self.ponto4 = {x = _x + metade_width, y = _y + metade_altura +(statusbar_y_mod*-1)} --topright
		else
			self.ponto1.x = _x - metade_width
			self.ponto1.y = _y + metade_altura +(statusbar_y_mod*-1)
			self.ponto2.x = _x - metade_width
			self.ponto2.y = _y - metade_altura + statusbar_y_mod
			self.ponto3.x = _x + metade_width
			self.ponto3.y = _y - metade_altura + statusbar_y_mod
			self.ponto4.x = _x + metade_width
			self.ponto4.y = _y + metade_altura +(statusbar_y_mod*-1)
		end
		
		self.baseframe.BoxBarsAltura = self.baseframe:GetHeight() - end_window_spacement --> espaço para o final da window
		
		return {altura = self.baseframe:GetHeight(), width = self.baseframe:GetWidth(), x = _x, y = _y}
	end

	function _details:RestoreMainWindowPosition(pre_defined)

		local _scale = self.baseframe:GetEffectiveScale() 
		local _UIscale = _UIParent:GetScale()
		
		local novo_x = self.position[self.displaying].x*_UIscale/_scale
		local novo_y = self.position[self.displaying].y*_UIscale/_scale
		
		if (pre_defined) then --> overwrite
			novo_x = pre_defined.x*_UIscale/_scale
			novo_y = pre_defined.y*_UIscale/_scale
			self.position[self.displaying].w = pre_defined.width
			self.position[self.displaying].h = pre_defined.altura
		end

		self.baseframe:SetWidth(self.position[self.displaying].w)
		self.baseframe:SetHeight(self.position[self.displaying].h)
		
		self.baseframe:ClearAllPoints()
		self.baseframe:SetPoint("CENTER", _UIParent, "CENTER", novo_x, novo_y)

		self.baseframe.BoxBarsAltura = self.baseframe:GetHeight() - end_window_spacement --> espaço para o final da window
	end

	function _details:RestoreMainWindowPositionNoResize(pre_defined, x, y)

		x = x or 0
		y = y or 0

		local _scale = self.baseframe:GetEffectiveScale() 
		local _UIscale = _UIParent:GetScale()

		local novo_x = self.position[self.displaying].x*_UIscale/_scale
		local novo_y = self.position[self.displaying].y*_UIscale/_scale
		
		if (pre_defined) then --> overwrite
			novo_x = pre_defined.x*_UIscale/_scale
			novo_y = pre_defined.y*_UIscale/_scale
			self.position[self.displaying].w = pre_defined.width
			self.position[self.displaying].h = pre_defined.altura
		end

		self.baseframe:ClearAllPoints()
		self.baseframe:SetPoint("CENTER", _UIParent, "CENTER", novo_x + x, novo_y + y)
		self.baseframe.BoxBarsAltura = self.baseframe:GetHeight() - end_window_spacement --> espaço para o final da window
	end

	function _details:ResetGump(instance, type, segment)
		if (not instance or _type(instance) == "boolean") then
			segment = type
			type = instance
			instance = self
		end
		
		if (type and type == 0x1) then --> entrando em combat
			if (instance.segment == -1) then --> this showing a table overall
				return
			end
		end
		
		if (segment and instance.segment ~= segment) then
			return
		end

		instance.barS = {nil, nil} --> zera o iterator
		instance.rows_showing = 0 --> resetou, então não this mostranho nenhuma bar
		
		for i = 1, instance.rows_created, 1 do --> limpa a referência do que thisva sendo mostrado na bar
			local this_bar= instance.bars[i]
			this_bar.my_table = nil
			this_bar.animation_end = 0
			this_bar.animation_end2 = 0
		end
		
		if (instance.scrolling) then
			instance:HideScrollBar() --> hida a scrollbar
		end
		instance.need_scrolling = false
		instance.bar_mod = nil

	end

	function _details:ReadjustGump()
		
		if (self.displaying == "normal") then --> somente alterar o tamanho das bars se tiver showing o gump normal
		
			if (not self.baseframe.isStretching and self.stretchToo and #self.stretchToo > 0) then
				if (self.eh_horizontal or self.eh_tudo or(self.verticalSnap and not self.eh_vertical)) then
					for _, instance in _ipairs(self.stretchToo) do 
						instance.baseframe:SetWidth(self.baseframe:GetWidth())
						local mod =(self.baseframe:GetWidth() - instance.baseframe._place.width) / 2
						instance:RestoreMainWindowPositionNoResize(instance.baseframe._place, mod, nil)
						instance:BaseFrameSnap()
					end
				end
				if ((self.eh_vertical or self.eh_tudo or not self.eh_horizontal) and(not self.verticalSnap or self.eh_vertical)) then
					for _, instance in _ipairs(self.stretchToo) do 
						if (instance.baseframe) then --> this criada
							instance.baseframe:SetHeight(self.baseframe:GetHeight())
							local mod
							if (self.eh_vertical) then
								mod =(self.baseframe:GetHeight() - instance.baseframe._place.altura) / 2
							else
								mod = -(self.baseframe:GetHeight() - instance.baseframe._place.altura) / 2
							end
							instance:RestoreMainWindowPositionNoResize(instance.baseframe._place, nil, mod)
							instance:BaseFrameSnap()
						end
					end
				end
			elseif (self.baseframe.isStretching and self.stretchToo and #self.stretchToo > 0) then
				for _, instance in _ipairs(self.stretchToo) do 
					instance.baseframe:SetHeight(self.baseframe:GetHeight())
					local mod =(self.baseframe:GetHeight() - instance.baseframe._place.altura) / 2
					instance:RestoreMainWindowPositionNoResize(instance.baseframe._place, nil, mod)
				end
			end
			
			if (self.stretch_button_side == 2) then
				self:StretchButtonAnchor(2)
			end
			
			--> readjust o freeze
			if (self.freezed) then
				_details:Freeze(self)
			end
		
			-- -4 difere a precisão de quando a bar será adicionada ou apagada da bar
			self.baseframe.BoxBarsAltura = self.baseframe:GetHeight() - end_window_spacement

			local T = self.rows_fit_in_window
			if (not T) then --> primeira vez que o gump this sendo readjustdo
				T = _math_floor(self.baseframe.BoxBarsAltura / self.row_height)
			end
			
			--> readjustr o local do relógio
			local meio = self.baseframe:GetWidth() / 2
			local novo_local = meio - 25
			
			self.rows_fit_in_window = _math_floor( self.baseframe.BoxBarsAltura / self.row_height)

			--> verifica se precisa create mais bars
			if (self.rows_fit_in_window > #self.bars) then--> verifica se precisa create mais bars
				for i  = #self.bars+1, self.rows_fit_in_window, 1 do
					gump:CreateNewBar(self, i) --> cria new bar
				end
				self.rows_created = #self.bars
			end
			
			--> seta a width das bars
			if (self.bar_mod and self.bar_mod ~= 0) then
				for index = 1, self.rows_fit_in_window do
					self.bars[index]:SetWidth(self.baseframe:GetWidth()+self.bar_mod)
				end
			else
				for index = 1, self.rows_fit_in_window do
					self.bars[index]:SetWidth(self.baseframe:GetWidth()+self.row_info.space.right)
				end
			end

			--> verifica se precisa esconder ou mostrar alguma bar
			local A = self.barS[1]
			if (not A) then --> primeira vez que o resize this sendo usado, no caso no startup do addon ou ao create uma new instância
				--> hida as bars não usadas
				for i = 1, self.rows_created, 1 do
					gump:Fade(self.bars[i], 1)
					self.bars[i].on = false
				end
				return
			end
			
			local X = self.rows_showing
			local C = self.rows_fit_in_window

			--> novo iterator
			local bars_diff = C - T --> aqui pega a amount de bars, se aumentou ou diminuiu
			if (bars_diff > 0) then --> ganhou bars_diff news bars
				local end_iterator = self.barS[2] --> posição atual
				end_iterator = end_iterator+bars_diff --> new posição
				local excedeu_iterator = end_iterator - X --> total que ta sendo mostrado - end do iterator
				if (excedeu_iterator > 0) then --> extrapolou
					end_iterator = X --> seta o end do iterator pra ser na ultima bar
					self.barS[2] = end_iterator --> end do iterator setado
					
					local start_iterator = self.barS[1]
					if (start_iterator-excedeu_iterator > 0) then --> se as bars que sobraram preenchem o start do iterator
						start_iterator = start_iterator-excedeu_iterator --> pega o novo valor do iterator
						self.barS[1] = start_iterator
					else
						self.barS[1] = 1 --> se ganhou mais bars pra cima, ignore elas e mover o iterator para a pocição inicial
					end
				else
					--> se não extrapolou this okey e this showing a amount de bars correta
					self.barS[2] = end_iterator
				end
				
				for index = T+1, C do
					local bar = self.bars[index]
					if (bar) then
						if (index <= X) then
							gump:Fade(bar, "out")
						else
							if (self.baseframe.isStretching or self.auto_resize) then
								gump:Fade(bar, 1)
							else
								gump:Fade(bar, "in", 0.1)
							end
						end
					end
				end
				
			elseif (bars_diff < 0) then --> lost bars_diff bars
				local end_iterator = self.barS[2] --> posição atual
				if (not(end_iterator == X and end_iterator < C)) then --> calcula primeiro as bars que foram perdidas são bars que não thisvam sendo usadas
					--> perdi X bars, diminui X posições no iterator
					local lost = _math_abs(bars_diff)
					
					if (end_iterator == X) then --> se o iterator tiver na ultima posição
						lost = lost -(C - X)
					end
					
					end_iterator = end_iterator - lost
					
					if (end_iterator < C) then
						end_iterator = C
					end
					
					self.barS[2] = end_iterator
					
					for index = T, C+1, -1 do
						local bar = self.bars[index]
						if (bar) then
							if (self.baseframe.isStretching or self.auto_resize) then
								gump:Fade(bar, 1)
							else	
								gump:Fade(bar, "in", 0.1)
							end
						end
					end
				end
			end

			if (X <= C) then --> desligar a scrolling
				if (self.scrolling and not self.baseframe.isStretching) then
					self:HideScrollBar()
				end
				self.need_scrolling = false
			else --> ligar ou atualizar a scrolling
				if (not self.scrolling and not self.baseframe.isStretching) then
					self:MostrarScrollBar()
				end
				self.need_scrolling = true
			end
			
			--> verificar o tamanho dos names
			local which_bar = 1
			for i = self.barS[1], self.barS[2], 1 do
				local this_bar = self.bars[which_bar]
				local table = this_bar.my_table
				
				if (table) then --> a bar this showing alguma coisa
				
					if (table._custom) then 
						table(this_bar, self)
					elseif (table._refresh_window) then
						table:_refresh_window(this_bar, self)
					else
						table:RefreshBar(this_bar, self, true)
					end

				end
				
				which_bar = which_bar+1
			end
			
			--> força o próximo refresh
			self.showing[self.attribute].need_refresh = true

		end	
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> panels

--> cooltip presets
	function _details:CooltipPreset(preset)
		local GameCooltip = GameCooltip
	
		GameCooltip:Reset()
		
		if (preset == 1) then
			GameCooltip:SetOption("TextFont", "Friz Quadrata TT")
			GameCooltip:SetOption("TextColor", "orange")
			GameCooltip:SetOption("TextSize", 12)
			GameCooltip:SetOption("ButtonsYMod", -4)
			GameCooltip:SetOption("YSpacingMod", -4)
			GameCooltip:SetOption("IgnoreButtonAutoHeight", true)
			GameCooltip:SetColor(1, 0.5, 0.5, 0.5, 0.5)
			
		elseif (preset == 2) then
			GameCooltip:SetOption("TextFont", "Friz Quadrata TT")
			GameCooltip:SetOption("TextColor", "orange")
			GameCooltip:SetOption("TextSize", 12)
			GameCooltip:SetOption("FixedWidth", 220)
			GameCooltip:SetOption("ButtonsYMod", -4)
			GameCooltip:SetOption("YSpacingMod", -4)
			GameCooltip:SetOption("IgnoreButtonAutoHeight", true)
			GameCooltip:SetColor(1, 0.5, 0.5, 0.5, 0.5)
			
		end
	end

--> yes no panel

	do
		_details.yesNo = _details.gump:NewPanel(UIParent, _, "DetailsYesNoWindow", _, 500, 80)
		_details.yesNo:SetPoint("center", UIParent, "center")
		_details.gump:NewLabel(_details.yesNo, _, "$parentAsk", "ask", "")
		_details.yesNo["ask"]:SetPoint("center", _details.yesNo, "center", 0, 25)
		_details.yesNo["ask"]:SetWidth(480)
		_details.yesNo["ask"]:SetJustifyH("center")
		_details.yesNo["ask"]:SetHeight(22)
		_details.gump:NewButton(_details.yesNo, _, "$parentNo", "no", 100, 30, function() _details.yesNo:Hide() end, nil, nil, nil, Loc["STRING_NO"])
		_details.gump:NewButton(_details.yesNo, _, "$parentYes", "yes", 100, 30, nil, nil, nil, nil, Loc["STRING_YES"])
		_details.yesNo["no"]:SetPoint(10, -45)
		_details.yesNo["yes"]:SetPoint(390, -45)
		_details.yesNo["no"]:InstallCustomTexture()
		_details.yesNo["yes"]:InstallCustomTexture()
		_details.yesNo["yes"]:SetHook("OnMouseUp", function() _details.yesNo:Hide() end)
		function _details:Ask(msg, func, ...)
			_details.yesNo["ask"].text = msg
			local p1, p2 = ...
			_details.yesNo["yes"]:SetClickFunction(func, p1, p2)
			_details.yesNo:Show()
		end
		_details.yesNo:Hide()
	end
	
--> cria o frame de wait for plugin
	function _details:CreateWaitForPlugin()
	
		local WaitForPluginFrame = CreateFrame("frame", "DetailsWaitForPluginFrame" .. self.mine_id, UIParent)
		local WaitTexture = WaitForPluginFrame:CreateTexture(nil, "overlay")
		WaitTexture:SetTexture("Interface\\AddOns\\Details\\images\\Mechanical_Circular_Frame")
		WaitTexture:SetPoint("center", WaitForPluginFrame)
		WaitTexture:SetWidth(180)
		WaitTexture:SetHeight(180)
		WaitForPluginFrame.wheel = WaitTexture
		local RotateAnimGroup = WaitForPluginFrame:CreateAnimationGroup()
		local rotate = RotateAnimGroup:CreateAnimation("Rotation")
		rotate:SetDegrees(360)
		rotate:SetDuration(60)
		RotateAnimGroup:SetLooping("repeat")
		
		local bgpanel = gump:NewPanel(UIParent, UIParent, "DetailsWaitFrameBG"..self.mine_id, nil, 120, 30, false, false, false)
		bgpanel:SetPoint("center", WaitForPluginFrame, "center")
		bgpanel:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"})
		bgpanel:SetBackdropColor(.2, .2, .2, 1)
		
		local label = gump:NewLabel(UIParent, UIParent, nil, nil, Loc["STRING_WAITPLUGIN"]) --> localize-me
		label.color = "silver"
		label:SetPoint("center", WaitForPluginFrame, "center")
		label:SetJustifyH("center")
		label:Hide()

		WaitForPluginFrame:Hide()	
		self.wait_for_plugin_created = true
		
		function self:WaitForPlugin()
		
			self:ChangeIcon([[Interface\GossipFrame\ActiveQuestIcon]])
		
			if (WaitForPluginFrame:IsShown() and WaitForPluginFrame:GetParent() == self.baseframe) then
				self.waiting_pid = self:ScheduleTimer("ExecDelayedPlugin1", 5, self)
			end
		
			WaitForPluginFrame:SetParent(self.baseframe)
			WaitForPluginFrame:SetAllPoints(self.baseframe)
			local size = math.max(self.baseframe:GetHeight()* 0.35, 100) 
			WaitForPluginFrame.wheel:SetWidth(size)
			WaitForPluginFrame.wheel:SetHeight(size)
			WaitForPluginFrame:Show()
			label:Show()
			bgpanel:Show()
			RotateAnimGroup:Play()
			
			self.waiting_raid_plugin = true
			
			self.waiting_pid = self:ScheduleTimer("ExecDelayedPlugin1", 5, self)
		end
		
		function self:CancelWaitForPlugin()
			RotateAnimGroup:Stop()
			WaitForPluginFrame:Hide()	
			label:Hide()
			bgpanel:Hide()
		end
		
		function self:ExecDelayedPlugin1()
		
			self.waiting_raid_plugin = nil
			self.waiting_pid = nil
		
			RotateAnimGroup:Stop()
			WaitForPluginFrame:Hide()	
			label:Hide()
			bgpanel:Hide()
			
			if (self.mine_id == _details.solo) then
				_details.SoloTables:switch(nil, _details.SoloTables.Mode)
				
			elseif (self.mode == _details._details_props["MODE_RAID"]) then
				_details.RaidTables:EnableRaidMode(self)
				
			end
		end	
	end
	
	do
		local WaitForPluginFrame = CreateFrame("frame", "DetailsWaitForPluginFrame", UIParent)
		local WaitTexture = WaitForPluginFrame:CreateTexture(nil, "overlay")
		WaitTexture:SetTexture("Interface\\AddOns\\Details\\images\\Mechanical_Circular_Frame")
		WaitTexture:SetPoint("center", WaitForPluginFrame)
		WaitTexture:SetWidth(180)
		WaitTexture:SetHeight(180)
		WaitForPluginFrame.wheel = WaitTexture
		local RotateAnimGroup = WaitForPluginFrame:CreateAnimationGroup()
		local rotate = RotateAnimGroup:CreateAnimation("Rotation")
		rotate:SetDegrees(360)
		rotate:SetDuration(60)
		RotateAnimGroup:SetLooping("repeat")
		
		local bgpanel = gump:NewPanel(UIParent, UIParent, "DetailsWaitFrameBG", nil, 120, 30, false, false, false)
		bgpanel:SetPoint("center", WaitForPluginFrame, "center")
		bgpanel:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"})
		bgpanel:SetBackdropColor(.2, .2, .2, 1)
		
		local label = gump:NewLabel(UIParent, UIParent, nil, nil, Loc["STRING_WAITPLUGIN"]) --> localize-me
		label.color = "silver"
		label:SetPoint("center", WaitForPluginFrame, "center")
		label:SetJustifyH("center")
		label:Hide()

		WaitForPluginFrame:Hide()	
		
		function _details:WaitForSoloPlugin(instance)
		
			instance:ChangeIcon([[Interface\GossipFrame\ActiveQuestIcon]])
		
			if (WaitForPluginFrame:IsShown() and WaitForPluginFrame:GetParent() == instance.baseframe) then
				return _details:ScheduleTimer("ExecDelayedPlugin", 5, instance)
			end
		
			WaitForPluginFrame:SetParent(instance.baseframe)
			WaitForPluginFrame:SetAllPoints(instance.baseframe)
			local size = math.max(instance.baseframe:GetHeight()* 0.35, 100) 
			WaitForPluginFrame.wheel:SetWidth(size)
			WaitForPluginFrame.wheel:SetHeight(size)
			WaitForPluginFrame:Show()
			label:Show()
			bgpanel:Show()
			RotateAnimGroup:Play()
			
			return _details:ScheduleTimer("ExecDelayedPlugin", 5, instance)
		end
		
		function _details:CancelWaitForPlugin()
			RotateAnimGroup:Stop()
			WaitForPluginFrame:Hide()	
			label:Hide()
			bgpanel:Hide()
		end
		
		function _details:ExecDelayedPlugin(instance)
		
			RotateAnimGroup:Stop()
			WaitForPluginFrame:Hide()	
			label:Hide()
			bgpanel:Hide()
			
			if (instance.mine_id == _details.solo) then
				_details.SoloTables:switch(nil, _details.SoloTables.Mode)
				
			elseif (instance.mine_id == _details.raid) then
				_details.RaidTables:switch(nil, _details.RaidTables.Mode)
				
			end
		end	
	end

--> tutorial bookmark
	function _details:TutorialBookmark(instance)
	
		_details:SetTutorialCVar("ATTRIBUTE_SELECT_TUTORIAL1", true)
		
		local func = function()
			local f = CreateFrame("frame", nil, instance.baseframe)
			f:SetAllPoints();
			f:SetFrameStrata("FULLSCREEN")
			f:SetBackdrop({bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16})
			f:SetBackdropColor(0, 0, 0, 0.8)
			
			f.alert = CreateFrame("frame", "DetailsTutorialBookmarkAlert", UIParent)--, "ActionBarButtonSpellActivationAlert")
			f.alert:SetPoint("topleft", f, "topleft")
			f.alert:SetPoint("bottomright", f, "bottomright")
			--f.alert.animOut:Stop()
			--f.alert.animIn:Play()
			
			f.text = f:CreateFontString(nil, "overlay", "GameFontNormal")
			f.text:SetText(Loc["STRING_MINITUTORIAL_BOOKMARK1"])
			f.text:SetWidth(f:GetWidth()-15)
			f.text:SetPoint("center", f)
			f.text:SetJustifyH("center")
			
			f.bg = f:CreateTexture(nil, "border")
			f.bg:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Horizontal-Desaturated]])
			f.bg:SetAllPoints()
			f.bg:SetAlpha(0.8)
			
			f.textbg = f:CreateTexture(nil, "artwork")
			f.textbg:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-RecentHeader]])
			f.textbg:SetPoint("center", f)
			f.textbg:SetAlpha(0.4)
			f.textbg:SetTexCoord(0, 1, 0, 24/32)

			f:SetScript("OnMouseDown", function(self, button)
				if (button == "RightButton") then
					f.alert.animIn:Stop()
					f.alert.animOut:Play()
					_details.switch:ShowMe(instance)
					f:Hide()
				end
			end)
		end
		
		_details:GetFramework():ShowTutorialAlertFrame("How to Use Bookmarks", "switch fast between displays", func)
	end

--> config class colors
	function _details:OpenClassColorsConfig()
		if (not _G.DetailsClassColorManager) then
			gump:CreateSimplePanel(UIParent, 300, 280, "Modify Class Colors", "DetailsClassColorManager")
			local panel = _G.DetailsClassColorManager
			local upper_panel = CreateFrame("frame", nil, panel)
			upper_panel:SetAllPoints(panel)
			upper_panel:SetFrameLevel(panel:GetFrameLevel()+3)
			
			local y = -50
			
			local callback = function(button, r, g, b, a, self)
				self.MyObject.my_texture:SetVertexColor(r, g, b)
				_details.class_colors[self.MyObject.my_class][1] = r
				_details.class_colors[self.MyObject.my_class][2] = g
				_details.class_colors[self.MyObject.my_class][3] = b
				_details:UpdateGumpMain(-1, true)
			end
			local set_color = function(class, index, self, button)
				local current_class_color = _details.class_colors[class]
				local r, g, b = unpack(current_class_color)
				_details.gump:ColorPick(self, r, g, b, 1, callback)
			end
			local reset_color = function(class, index, self, button)
				local color_table = RAID_CLASS_COLORS[class]
				local r, g, b = color_table.r, color_table.g, color_table.b
				self.MyObject.my_texture:SetVertexColor(r, g, b)
				_details.class_colors[self.MyObject.my_class][1] = r
				_details.class_colors[self.MyObject.my_class][2] = g
				_details.class_colors[self.MyObject.my_class][3] = b
				_details:UpdateGumpMain(-1, true)
			end
			local on_enter = function(self, capsule)
				--_details:CooltipPreset(1)
				--GameCooltip:AddLine("right click to reset")
				--GameCooltip:Show(self)
			end
			local on_leave = function(self, capsule)
				--GameCooltip:Hide()
			end
			
			local reset = gump:NewLabel(panel, _, nil, nil, "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:" .. 20 .. ":" .. 20 .. ":0:1:512:512:8:70:328:409|t " .. "Right Click to Reset")
			reset:SetPoint("bottomright", panel, "bottomright", -23, 38)
			local reset_texture = gump:CreateImage(panel,[[Interface\MONEYFRAME\UI-MONEYFRAME-BORDER]], 138, 45, "border")
			reset_texture:SetPoint("center", reset, "center", 0, -7)
			reset_texture:SetDesaturated(true)
			
			panel.buttons = {}
			
			for index, class_name in ipairs(CLASS_SORT_ORDER) do
				
				local icon = gump:CreateImage(upper_panel,[[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES]], 32, 32, nil, CLASS_ICON_TCOORDS[class_name], "icon_" .. class_name)
				
				if (index%2 ~= 0) then
					icon:SetPoint(10, y)
				else
					icon:SetPoint(150, y)
					y = y - 33
				end
				
				local bg_texture = gump:CreateImage(panel,[[Interface\AddOns\Details\images\bar_skyline]], 135, 30, "artwork")
				bg_texture:SetPoint("left", icon, "right", -32, 0)
				
				local button = gump:CreateButton(panel, set_color, 135, 30, "set color", class_name, index)
				button:SetPoint("left", icon, "right", -32, 0)
				button:InstallCustomTexture(nil, nil, nil, nil, true)
				button:SetFrameLevel(panel:GetFrameLevel()+1)
				button.my_icon = icon
				button.my_texture = bg_texture
				button.my_class = class_name
				button:SetHook("OnEnter", on_enter)
				button:SetHook("OnLeave", on_leave)
				button:SetClickFunction(reset_color, nil, nil, "RightClick")
				panel.buttons[class_name] = button
				
			end
			
		end
		
		for class, button in pairs(_G.DetailsClassColorManager.buttons) do
			button.my_texture:SetVertexColor(unpack(_details.class_colors[class]))
		end
		
		_G.DetailsClassColorManager:Show()
	end
	
--> config bookmarks
	function _details:OpenBookmarkConfig()
	
		if (not _G.DetailsBookmarkManager) then
			gump:CreateSimplePanel(UIParent, 300, 480, "Manage Bookmarks", "DetailsBookmarkManager")
			local panel = _G.DetailsBookmarkManager
			panel.blocks = {}
			
			local clear_func = function(id)
				if (_details.switch.table[id]) then
					_details.switch.table[id].attribute = nil
					_details.switch.table[id].sub_attribute = nil
					panel:Refresh()
					_details.switch:Update()
				end
			end
			
			local select_attribute = function(_, _, _, attribute, sub_atribute)
				if (not sub_atribute) then 
					return
				end
				_details.switch.table[panel.selecting_slot].attribute = attribute
				_details.switch.table[panel.selecting_slot].sub_attribute = sub_atribute
				panel:Refresh()
				_details.switch:Update()
			end
			
			local cooltip_color = {.1, .1, .1, .3}
			local set_att = function(id, _, self)
				panel.selecting_slot = id
				GameCooltip:Reset()
				GameCooltip:SetType(3)
				GameCooltip:SetOwner(self)
				_details:SetAttributesOption(_details:GetInstance(1), select_attribute)
				GameCooltip:SetColor(1, cooltip_color)
				GameCooltip:SetColor(2, cooltip_color)
				GameCooltip:SetOption("HeightAnchorMod", -7)
				GameCooltip:ShowCooltip()
			end
			
			local button_backdrop = {bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 64, insets = {left=0, right=0, top=0, bottom=0}}
			
			local set_onenter = function(self, capsule)
				self:SetBackdropColor(1, 1, 1, 0.9)
				capsule.icon:SetBlendMode("ADD")
			end
			local set_onleave = function(self, capsule)
				self:SetBackdropColor(0, 0, 0, 0.5)
				capsule.icon:SetBlendMode("BLEND")
			end
			
			for i = 1, 40 do
				local clear = gump:CreateButton(panel, clear_func, 16, 16, nil, i, nil,[[Interface\Glues\LOGIN\Glues-CheckBox-Check]])
				if (i%2 ~= 0) then
					--impar
					clear:SetPoint(15,(( i*10 ) * -1) - 35) --left
				else
					--par
					local o = i-1
					clear:SetPoint(150,(( o*10 ) * -1) - 35) --right
				end
			
				local set = gump:CreateButton(panel, set_att, 16, 16, nil, i)
				set:SetPoint("left", clear, "right")
				set:SetPoint("right", clear, "right", 110, 0)
				set:SetBackdrop(button_backdrop)
				set:SetBackdropColor(0, 0, 0, 0.5)
				set:SetHook("OnEnter", set_onenter)
				set:SetHook("OnLeave", set_onleave)

				set:InstallCustomTexture(nil, nil, nil, nil, true)
				
				local bg_texture = gump:CreateImage(set,[[Interface\AddOns\Details\images\bar_skyline]], 135, 30, "background")
				bg_texture:SetAllPoints()
				set.bg = bg_texture
			
				local icon = gump:CreateImage(set, nil, 16, 16, nil, nil, "icon")
				icon:SetPoint("left", clear, "right", 4, 0)
				
				local label = gump:CreateLabel(set, "")
				label:SetPoint("left", icon, "right", 2, 0)

				tinsert(panel.blocks, {icon = icon, label = label, bg = set.bg})
			end
			
			local normal_coords = {0, 1, 0, 1}
			local unknown_coords = {157/512, 206/512, 39/512,  89/512}
			function panel:Refresh()
				local bookmarks = _details.switch.table
				
				for i = 1, 40 do
					local bookmark = bookmarks[i]
					local this_block = panel.blocks[i]
					if (bookmark and bookmark.attribute and bookmark.sub_attribute) then
						if (bookmark.attribute == 5) then --> custom
							local CustomObject = _details.custom[bookmark.sub_attribute]
							if (not CustomObject) then --> ele já foi deletado
								this_block.label.text = "-- x -- x --"
								this_block.icon.texture = "Interface\\ICONS\\Ability_DualWield"
								this_block.icon.texcoord = normal_coords
								this_block.bg:SetVertexColor(.4, .1, .1, .12)
							else
								this_block.label.text = CustomObject.name
								this_block.icon.texture = CustomObject.icon
								this_block.icon.texcoord = normal_coords
								this_block.bg:SetVertexColor(.4, .4, .4, .6)
							end
						else
							this_block.label.text = _details.sub_attributes[bookmark.attribute].list[bookmark.sub_attribute]
							this_block.icon.texture = _details.sub_attributes[bookmark.attribute].icons[bookmark.sub_attribute][1]
							this_block.icon.texcoord = _details.sub_attributes[bookmark.attribute].icons[bookmark.sub_attribute][2]
							this_block.bg:SetVertexColor(.4, .4, .4, .6)
						end
					else
						this_block.label.text = "-- x -- x --"
						this_block.icon.texture =[[Interface\AddOns\Details\images\icons]]
						this_block.icon.texcoord = unknown_coords
						this_block.bg:SetVertexColor(.4, .1, .1, .12)
					end
				end
			end
		end

		_G.DetailsBookmarkManager:Show()
		_G.DetailsBookmarkManager:Refresh()
	end
	
--> tutorial bubbles
	do
		--[1] create new instance
		--[2] esticar window
		--[3] resize e trava
		--[4] shortcut frame
		--[5] micro displays
		--[6] snap windows
	
		function _details:run_tutorial()
		
			local lower_instance = _details:GetLowerInstanceNumber()
				if (lower_instance) then
				local instance = _details:GetInstance(lower_instance)
			
				_details.times_of_tutorial = _details.times_of_tutorial + 1
				if (_details.times_of_tutorial > 20) then
					return
				end
			
				if (_details.MicroButtonAlert:IsShown()) then
					return _details:ScheduleTimer("delay_tutorial", 2)
				end

				if (not _details.tutorial.alert_frames[1]) then
				
					_details.MicroButtonAlert.Text:SetText(Loc["STRING_MINITUTORIAL_1"])
					_details.MicroButtonAlert:SetPoint("bottom", instance.baseframe.header.novo, "top", 0, 16)
					_details.MicroButtonAlert:SetHeight(200)
					_details.MicroButtonAlert:Show()
					_details.tutorial.alert_frames[1] = true
					
				elseif (not _details.tutorial.alert_frames[2]) then
				
					_details.MicroButtonAlert.Text:SetText(Loc["STRING_MINITUTORIAL_2"])
					_details.MicroButtonAlert:SetPoint("bottom", instance.baseframe.button_stretch, "top", 0, 15)
					instance.baseframe.button_stretch:Show()
					instance.baseframe.button_stretch:SetAlpha(1)
					_details.MicroButtonAlert:Show()
					_details.tutorial.alert_frames[2] = true
				
				elseif (not _details.tutorial.alert_frames[3]) then
					_details.MicroButtonAlert.Text:SetText(Loc["STRING_MINITUTORIAL_3"])
					_details.MicroButtonAlert:SetPoint("bottom", instance.baseframe.resize_right, "top", -8, 16)
					
					_details.OnEnterMainWindow(instance)
					instance.baseframe.button_stretch:SetAlpha(0)
					
					_details.MicroButtonAlert:Show()
					_details.tutorial.alert_frames[3] = true
				
				elseif (not _details.tutorial.alert_frames[4]) then
				
					_details.MicroButtonAlert.Text:SetText(Loc["STRING_MINITUTORIAL_4"])
					_details.MicroButtonAlert:SetPoint("bottom", instance.baseframe, "center", 0, 16)
					_details.MicroButtonAlert:Show()
					_details.tutorial.alert_frames[4] = true
					
				elseif (not _details.tutorial.alert_frames[5]) then
				
					_details.MicroButtonAlert.Text:SetText(Loc["STRING_MINITUTORIAL_5"])
					_details.MicroButtonAlert:SetPoint("bottom", instance.baseframe.rodape.top_bg, "top", 0, 16)
					_details.MicroButtonAlert:Show()
					_details.MicroButtonAlert:SetHeight(220)
					_details.tutorial.alert_frames[5] = true
					
				elseif (not _details.tutorial.alert_frames[6]) then
				
					_details.MicroButtonAlert.Text:SetText(Loc["STRING_MINITUTORIAL_6"])
					_details.MicroButtonAlert:SetPoint("bottom", instance.baseframe.bar_right, "center", -24, 16)
					_details.MicroButtonAlert:SetHeight(200)
					_details.MicroButtonAlert:Show()
					_details.tutorial.alert_frames[6] = true
				
					return --> colocando return pra nao rodar o schedule infinitamente
				end
			end
			--
			_details:ScheduleTimer("delay_tutorial", 2)
		end
	
		--[1] create new instance
		--[2] esticar window
		--[3] resize e trava
		--[4] shortcut frame
		--[5] micro displays
		--[6] snap windows
	
		function _details:delay_tutorial()
			if (_details.character_data.logons < 2) then
				_details:run_tutorial()
			end
		end
		
		function _details:StartTutorial()
			--
			if (_G["DetailsWelcomeWindow"] and _G["DetailsWelcomeWindow"]:IsShown()) then
				return _details:ScheduleTimer("StartTutorial", 10)
			end
			--
			_details.times_of_tutorial = 0 
			_details:ScheduleTimer("delay_tutorial", 5)
		end
	
	end

	
--> create bubble
	do 
		local f = CreateFrame("frame", "DetailsBubble", UIParent)
		f:SetPoint("center", UIParent, "center")
		f:SetSize(100, 100)
		f:SetFrameStrata("TOOLTIP")
		f.isHorizontalFlipped = false
		f.isVerticalFlipped = false
		
		local t = f:CreateTexture(nil, "artwork")
		t:SetTexture([[Interface\AddOns\Details\images\icons]])
		t:SetSize(131 * 1.2, 81 * 1.2)
		--377 328 508 409  0.0009765625
		t:SetTexCoord(0.7373046875, 0.9912109375, 0.6416015625, 0.7978515625)
		t:SetPoint("center", f, "center")
		
		local line1 = f:CreateFontString(nil, "overlay", "GameFontNormalSmall")
		line1:SetPoint("topleft", t, "topleft", 24, -10)
		_details:SetFontSize(line1, 9)
		line1:SetTextColor(.9, .9, .9, 1)
		line1:SetSize(110, 12)
		line1:SetJustifyV("center")
		line1:SetJustifyH("center")

		local line2 = f:CreateFontString(nil, "overlay", "GameFontNormalSmall")
		line2:SetPoint("topleft", t, "topleft", 11, -20)
		_details:SetFontSize(line2, 9)
		line2:SetTextColor(.9, .9, .9, 1)
		line2:SetSize(140, 12)
		line2:SetJustifyV("center")
		line2:SetJustifyH("center")
		
		local line3 = f:CreateFontString(nil, "overlay", "GameFontNormalSmall")
		line3:SetPoint("topleft", t, "topleft", 7, -30)
		_details:SetFontSize(line3, 9)
		line3:SetTextColor(.9, .9, .9, 1)
		line3:SetSize(144, 12)
		line3:SetJustifyV("center")
		line3:SetJustifyH("center")
		
		local line4 = f:CreateFontString(nil, "overlay", "GameFontNormalSmall")
		line4:SetPoint("topleft", t, "topleft", 11, -40)
		_details:SetFontSize(line4, 9)
		line4:SetTextColor(.9, .9, .9, 1)
		line4:SetSize(140, 12)
		line4:SetJustifyV("center")
		line4:SetJustifyH("center")

		local line5 = f:CreateFontString(nil, "overlay", "GameFontNormalSmall")
		line5:SetPoint("topleft", t, "topleft", 24, -50)
		_details:SetFontSize(line5, 9)
		line5:SetTextColor(.9, .9, .9, 1)
		line5:SetSize(110, 12)
		line5:SetJustifyV("center")
		line5:SetJustifyH("center")
		
		f.lines = {line1, line2, line3, line4, line5}
		
		function f:FlipHorizontal()
			if (not f.isHorizontalFlipped) then
				if (f.isVerticalFlipped) then
					t:SetTexCoord(0.9912109375, 0.7373046875, 0.7978515625, 0.6416015625)
				else
					t:SetTexCoord(0.9912109375, 0.7373046875, 0.6416015625, 0.7978515625)
				end
				f.isHorizontalFlipped = true
			else
				if (f.isVerticalFlipped) then
					t:SetTexCoord(0.7373046875, 0.9912109375, 0.7978515625, 0.6416015625)
				else
					t:SetTexCoord(0.7373046875, 0.9912109375, 0.6416015625, 0.7978515625)
				end
				f.isHorizontalFlipped = false
			end
		end
		
		function f:FlipVertical()
		
			if (not f.isVerticalFlipped) then
				if (f.isHorizontalFlipped) then
					t:SetTexCoord(0.7373046875, 0.9912109375, 0.7978515625, 0.6416015625)
				else
					t:SetTexCoord(0.9912109375, 0.7373046875, 0.7978515625, 0.6416015625)
				end
				f.isVerticalFlipped = true
			else
				if (f.isHorizontalFlipped) then
					t:SetTexCoord(0.7373046875, 0.9912109375, 0.6416015625, 0.7978515625)
				else
					t:SetTexCoord(0.9912109375, 0.7373046875, 0.6416015625, 0.7978515625)
				end
				f.isVerticalFlipped = false
			end
		end
		
		function f:TextConfig(fontsize, fontface, fontcolor)
			for i = 1, 5 do
			
				local line = f.lines[i]
				
				_details:SetFontSize(line, fontsize or 9)
				_details:SetFontFace(line, fontface or[[Fonts\FRIZQT__.TTF]])
				_details:SetFontColor(line, fontcolor or {.9, .9, .9, 1})

			end
		end
		
		function f:SetBubbleText(line1, line2, line3, line4, line5)
			if (not line1) then
				for _, line in ipairs(f.lines) do
					line:SetText("")
				end
				return
			end
			
			if (line1:find("\n")) then
				line1, line2, line3, line4, line5 = strsplit("\n", line1)
			end
			
			f.lines[1]:SetText(line1)
			f.lines[2]:SetText(line2)
			f.lines[3]:SetText(line3)
			f.lines[4]:SetText(line4)
			f.lines[5]:SetText(line5)
		end
		
		function f:SetOwner(frame, myPoint, hisPoint, x, y, alpha)
			f:ClearAllPoints()
			f:TextConfig()
			f:SetBubbleText(nil)
			t:SetTexCoord(0.7373046875, 0.9912109375, 0.6416015625, 0.7978515625)
			f.isHorizontalFlipped = false
			f.isVerticalFlipped = false
			f:SetPoint(myPoint or "bottom", frame, hisPoint or "top", x or 0, y or 0)
			t:SetAlpha(alpha or 1)
		end
		
		function f:ShowBubble()
			f:Show()
		end
		
		function f:HideBubble()
			f:Hide()
		end
		
		f:SetBubbleText(nil)
		
		f:Hide()
	end
	
--> feed back request
	
	function _details:ShowFeedbackRequestWindow()
	
		local feedback_frame = CreateFrame("FRAME", "DetailsFeedbackWindow", UIParent, "ButtonFrameTemplate")
		tinsert(UISpecialFrames, "DetailsFeedbackWindow")
		feedback_frame:SetPoint("center", UIParent, "center")
		feedback_frame:SetSize(512, 200)
		feedback_frame.portrait:SetTexture([[Interface\CHARACTERFRAME\TEMPORARYPORTRAIT-FEMALE-GNOME]])
		
		feedback_frame.TitleText:SetText("Details! Need Your Help!")
		
		feedback_frame.uppertext = feedback_frame:CreateFontString(nil, "artwork", "GameFontNormal")
		feedback_frame.uppertext:SetText("Tell us about your experience using Details!, what you liked most, where we could improve, what things you want to see in the future?")
		feedback_frame.uppertext:SetPoint("topleft", feedback_frame, "topleft", 60, -32)
		local font, _, flags = feedback_frame.uppertext:GetFont()
		feedback_frame.uppertext:SetFont(font, 10, flags)
		feedback_frame.uppertext:SetTextColor(1, 1, 1, .8)
		feedback_frame.uppertext:SetWidth(440)

		local editbox = _details.gump:NewTextEntry(feedback_frame, nil, "$parentTextEntry", "text", 387, 14)
		editbox:SetPoint(20, -106)
		editbox:SetAutoFocus(false)
		editbox:SetHook("OnEditFocusGained", function() 
			editbox.text = "http://www.mmo-champion.com/threads/1480721-New-damage-meter-%28Details!%29-need-help-with-tests-and-feedbacks" 
			editbox:HighlightText()
		end)
		editbox:SetHook("OnEditFocusLost", function() 
			editbox.text = "http://www.mmo-champion.com/threads/1480721-New-damage-meter-%28Details!%29-need-help-with-tests-and-feedbacks" 
			editbox:HighlightText()
		end)
		editbox:SetHook("OnChar", function() 
			editbox.text = "http://www.mmo-champion.com/threads/1480721-New-damage-meter-%28Details!%29-need-help-with-tests-and-feedbacks"
			editbox:HighlightText()
		end)
		editbox.text = "http://www.mmo-champion.com/threads/1480721-New-damage-meter-%28Details!%29-need-help-with-tests-and-feedbacks"
		
		
		feedback_frame.midtext = feedback_frame:CreateFontString(nil, "artwork", "GameFontNormal")
		feedback_frame.midtext:SetText("visit the link above and let's make Details! stronger!")
		feedback_frame.midtext:SetPoint("center", editbox.widget, "center")
		feedback_frame.midtext:SetPoint("top", editbox.widget, "bottom", 0, -2)
		feedback_frame.midtext:SetJustifyH("center")
		local font, _, flags = feedback_frame.midtext:GetFont()
		feedback_frame.midtext:SetFont(font, 10, flags)
		--feedback_frame.midtext:SetTextColor(1, 1, 1, 1)
		feedback_frame.midtext:SetWidth(440)
		
		
		feedback_frame.gnoma = feedback_frame:CreateTexture(nil, "artwork")
		feedback_frame.gnoma:SetPoint("topright", feedback_frame, "topright", -1, -59)
		feedback_frame.gnoma:SetTexture("Interface\\AddOns\\Details\\images\\icons2")
		feedback_frame.gnoma:SetSize(105*1.05, 107*1.05)
		feedback_frame.gnoma:SetTexCoord(0.2021484375, 0, 0.7919921875, 1)

		feedback_frame.close = CreateFrame("Button", "DetailsFeedbackWindowCloseButton", feedback_frame, "OptionsButtonTemplate")
		feedback_frame.close:SetPoint("bottomleft", feedback_frame, "bottomleft", 8, 4)
		feedback_frame.close:SetText("Close")
		feedback_frame.close:SetScript("OnClick", function(self)
			editbox:ClearFocus()
			feedback_frame:Hide()
		end)
		
		feedback_frame.postpone = CreateFrame("Button", "DetailsFeedbackWindowPostPoneButton", feedback_frame, "OptionsButtonTemplate")
		feedback_frame.postpone:SetPoint("bottomright", feedback_frame, "bottomright", -10, 4)
		feedback_frame.postpone:SetText("Remind-me Later")
		feedback_frame.postpone:SetScript("OnClick", function(self)
			editbox:ClearFocus()
			feedback_frame:Hide()
			_details.tutorial.feedback_window1 = false
		end)
		feedback_frame.postpone:SetWidth(130)
		
		feedback_frame:SetScript("OnHide", function() 
			editbox:ClearFocus()
		end)
		
		--0.0009765625 512
		function _details:FeedbackSetFocus()
			DetailsFeedbackWindow:Show()
			DetailsFeedbackWindowTextEntry.MyObject:SetFocus()
			DetailsFeedbackWindowTextEntry.MyObject:HighlightText()
		end
		_details:ScheduleTimer("FeedbackSetFocus", 5)
	
	end
	
--> interface menu
	local f = CreateFrame("frame", "DetailsInterfaceOptionsPanel", UIParent)
	f.name = "Details"
	f.logo = f:CreateTexture(nil, "overlay")
	f.logo:SetPoint("center", f, "center", 0, 0)
	f.logo:SetPoint("top", f, "top", 25, 56)
	f.logo:SetTexture([[Interface\AddOns\Details\images\logotype]])
	f.logo:SetSize(256, 128)
	InterfaceOptions_AddCategory(f)
	
		--> open options panel
		f.options_button = CreateFrame("button", nil, f, "OptionsButtonTemplate")
		f.options_button:SetText(Loc["STRING_INTERFACE_OPENOPTIONS"])
		f.options_button:SetPoint("topleft", f, "topleft", 10, -100)
		f.options_button:SetWidth(170)
		f.options_button:SetScript("OnClick", function(self)
			local lower_instance = _details:GetLowerInstanceNumber()
			_details:OpenOptionsWindow(_details:GetInstance(lower_instance))
		end)
		
		--> create new window
		f.new_window_button = CreateFrame("button", nil, f, "OptionsButtonTemplate")
		f.new_window_button:SetText(Loc["STRING_MINIMAPMENU_NEWWINDOW"])
		f.new_window_button:SetPoint("topleft", f, "topleft", 10, -125)
		f.new_window_button:SetWidth(170)
		f.new_window_button:SetScript("OnClick", function(self)
			_details:Createinstance(_, true)
		end)	
	
	function _details:OpenBrokerTextEditor()
		
		if (not DetailsWindowOptionsBrokerTextEditor) then

			local panel = _details.gump:NewPanel(UIParent, nil, "DetailsWindowOptionsBrokerTextEditor", nil, 650, 200)
			panel:SetPoint("center", UIParent, "center")
			panel:Hide()
			panel:SetFrameStrata("FULLSCREEN")
			panel:SetBackdrop({	bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 64, insets = {left=3, right=3, top=3, bottom=3}})
			panel:DisableGradient()
			panel:SetBackdropColor(0, 0, 0, 0)
			panel.locked = false
		
			local bg_texture = _details.gump:NewImage(panel,[[Interface\AddOns\Details\images\welcome]], 1, 1, "background")
			bg_texture:SetPoint("topleft", panel, "topleft")
			bg_texture:SetPoint("bottomright", panel, "bottomright")
			
			local textentry = _details.gump:NewSpecialLuaEditorEntry(panel.widget, 450, 180, "editbox", "$parentEntry", true)
			textentry:SetPoint("topleft", panel.widget, "topleft", 10, -10)
			
			textentry.editbox:SetScript("OnTextChanged", function()
				local text = panel.widget.editbox:GetText()
				_details.data_broker_text = text
				_details:BrokerTick()
				if (_G.DetailsOptionsWindow)  then
					_G.DetailsOptionsWindow19BrokerEntry.MyObject:SetText(_details.data_broker_text)
				end
			end)
			
			local option_selected = 1
			local onclick= function(_, _, value)
				option_selected = value
			end
			local AddOptions = {
				{label = Loc["STRING_OPTIONS_DATABROKER_TEXT_ADD1"], value = 1, onclick = onclick},
				{label = Loc["STRING_OPTIONS_DATABROKER_TEXT_ADD2"], value = 2, onclick = onclick},
				{label = Loc["STRING_OPTIONS_DATABROKER_TEXT_ADD3"], value = 3, onclick = onclick},
				{label = Loc["STRING_OPTIONS_DATABROKER_TEXT_ADD4"], value = 4, onclick = onclick},
				
				{label = Loc["STRING_OPTIONS_DATABROKER_TEXT_ADD5"], value = 5, onclick = onclick},
				{label = Loc["STRING_OPTIONS_DATABROKER_TEXT_ADD6"], value = 6, onclick = onclick},
				{label = Loc["STRING_OPTIONS_DATABROKER_TEXT_ADD7"], value = 7, onclick = onclick},
				{label = Loc["STRING_OPTIONS_DATABROKER_TEXT_ADD8"], value = 8, onclick = onclick},
				
				{label = Loc["STRING_OPTIONS_DATABROKER_TEXT_ADD9"], value = 9, onclick = onclick},
			}
			local buildAddMenu = function()
				return AddOptions
			end
			
			local d = _details.gump:NewDropDown(panel, _, "$parentTextOptionsDropdown", "TextOptionsDropdown", 150, 20, buildAddMenu, 1)
			d:SetPoint("topright", panel, "topright", -10, -14)
			--d:SetFrameStrata("TOOLTIP")

			local optiontable = {"{dmg}", "{dps}", "{dpos}", "{ddiff}", "{heal}", "{hps}", "{hpos}", "{hdiff}", "{time}"}
		
			local add_button = _details.gump:NewButton(panel, nil, "$parentAddButton", nil, 20, 20, function() 
				textentry.editbox:Insert(optiontable[option_selected])
			end, 
			nil, nil, nil, "<-")
			add_button:SetPoint("right", d, "left", -2, 0)
			add_button:InstallCustomTexture()
			
			
			-- code author Saiket from  http://www.wowinterface.com/forums/showpost.php?p=245759&postcount=6
			--- @return StartPos, EndPos of highlight in this editbox.
			local function GetTextHighlight( self )
				local Text, Cursor = self:GetText(), self:GetCursorPosition();
				self:Insert( "" ); -- Delete selected text
				local TextNew, CursorNew = self:GetText(), self:GetCursorPosition();
				-- Restore previous text
				self:SetText( Text );
				self:SetCursorPosition( Cursor );
				local Start, End = CursorNew, #Text -( #TextNew - CursorNew );
				self:HighlightText( Start, End );
				return Start, End;
			end
		      
			local StripColors;
			do
				local CursorPosition, CursorDelta;
				--- Callback for gsub to remove unescaped codes.
				local function StripCodeGsub( Escapes, Code, End )
					if ( #Escapes % 2 == 0 ) then -- Doesn't escape Code
						if ( CursorPosition and CursorPosition >= End - 1 ) then
							CursorDelta = CursorDelta - #Code;
						end
						return Escapes;
					end
				end
				--- Removes a single escape sequence.
				local function StripCode( Pattern, Text, OldCursor )
					CursorPosition, CursorDelta = OldCursor, 0;
					return Text:gsub( Pattern, StripCodeGsub ), OldCursor and CursorPosition + CursorDelta;
				end
				--- Strips Text of all color escape sequences.
				-- @param Cursor  Optional cursor position to keep track of.
				-- @return Stripped text, and the updated cursor position if Cursor was given.
				function StripColors( Text, Cursor )
					Text, Cursor = StripCode( "(|*)(|c%x%x%x%x%x%x%x%x)()", Text, Cursor );
					return StripCode( "(|*)(|r)()", Text, Cursor );
				end
			end
			
			local COLOR_END = "|r";
			--- Wraps this editbox's selected text with the given color.
			local function ColorSelection( self, ColorCode )
				local Start, End = GetTextHighlight( self );
				local Text, Cursor = self:GetText(), self:GetCursorPosition();
				if ( Start == End ) then -- Nothing selected
					--Start, End = Cursor, Cursor; -- Wrap around cursor
					return; -- Wrapping the cursor in a color code and hitting backspace crashes the client!
				end
				-- Find active color code at the end of the selection
				local ActiveColor;
				if ( End < #Text ) then -- There is text to color after the selection
					local ActiveEnd;
					local CodeEnd, _, Escapes, Color = 0;
					while( true ) do
						_, CodeEnd, Escapes, Color = Text:find( "(|*)(|c%x%x%x%x%x%x%x%x)", CodeEnd + 1 );
						if ( not CodeEnd or CodeEnd > End ) then
							break;
						end
						if ( #Escapes % 2 == 0 ) then -- Doesn't escape Code
							ActiveColor, ActiveEnd = Color, CodeEnd;
						end
					end
		       
					if ( ActiveColor ) then
						-- Check if color gets terminated before selection ends
						CodeEnd = 0;
						while( true ) do
							_, CodeEnd, Escapes = Text:find( "(|*)|r", CodeEnd + 1 );
							if ( not CodeEnd or CodeEnd > End ) then
								break;
							end
							if ( CodeEnd > ActiveEnd and #Escapes % 2 == 0 ) then -- Terminates ActiveColor
								ActiveColor = nil;
								break;
							end
						end
					end
				end
		     
				local Selection = Text:sub( Start + 1, End );
				-- Remove color codes from the selection
				local Replacement, CursorReplacement = StripColors( Selection, Cursor - Start );
		     
				self:SetText(( "" ):join(
					Text:sub( 1, Start ),
					ColorCode, Replacement, COLOR_END,
					ActiveColor or "", Text:sub( End + 1 )
				) );
		     
				-- Restore cursor and highlight, adjusting for wrapper text
				Cursor = Start + CursorReplacement;
				if ( CursorReplacement > 0 ) then -- Cursor beyond start of color code
					Cursor = Cursor + #ColorCode;
				end
				if ( CursorReplacement >= #Replacement ) then -- Cursor beyond end of color
					Cursor = Cursor + #COLOR_END;
				end
				
				self:SetCursorPosition( Cursor );
				-- Highlight selection and wrapper
				self:HighlightText( Start, #ColorCode +( #Replacement - #Selection ) + #COLOR_END + End );
			end
			
			local color_func = function(_, r, g, b, a)
				local hex = _details:hex(a*255).._details:hex(r*255).._details:hex(g*255).._details:hex(b*255)
				ColorSelection( textentry.editbox, "|c" .. hex)
			end
			
			local color_button = _details.gump:NewColorPickButton(panel, "$parentButton5", nil, color_func)
			color_button:SetSize(80, 20)
			color_button:SetPoint("topright", panel, "topright", -10, -102)
			color_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_COLOR_TOOLTIP"]
		
			local done = function()
				local text = panel.widget.editbox:GetText()
				_details.data_broker_text = text
				if (_G.DetailsOptionsWindow)  then
					_G.DetailsOptionsWindow19BrokerEntry.MyObject:SetText(_details.data_broker_text)
				end
				_details:BrokerTick()
				panel:Hide()
			end
			
			local ok_button = _details.gump:NewButton(panel, nil, "$parentButtonOk", nil, 80, 20, done, nil, nil, nil, Loc["STRING_OPTIONS_TEXTEDITOR_DONE"], 1)
			ok_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_DONE_TOOLTIP"]
			ok_button:InstallCustomTexture()
			ok_button:SetPoint("topright", panel, "topright", -10, -174)
			
			local reset_button = _details.gump:NewButton(panel, nil, "$parentDefaultOk", nil, 80, 20, function() textentry.editbox:SetText("") end, nil, nil, nil, "Reset", 1)
			reset_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_RESET_TOOLTIP"]
			reset_button:InstallCustomTexture()
			reset_button:SetPoint("topright", panel, "topright", -100, -152)
			
			local cancel_button = _details.gump:NewButton(panel, nil, "$parentDefaultCancel", nil, 80, 20, function() textentry.editbox:SetText(panel.default_text); done(); end, nil, nil, nil, Loc["STRING_OPTIONS_TEXTEDITOR_CANCEL"], 1)
			cancel_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_CANCEL_TOOLTIP"]
			cancel_button:InstallCustomTexture()
			cancel_button:SetPoint("topright", panel, "topright", -100, -174)			
		
		end
		
		local panel = DetailsWindowOptionsBrokerTextEditor.MyObject
		
		local text = _details.data_broker_text:gsub("||", "|")
		panel.default_text = text
		panel.widget.editbox:SetText(text)
		
		panel:Show()
	end
	
--> row text editor
	local panel = _details.gump:NewPanel(UIParent, nil, "DetailsWindowOptionsBarTextEditor", nil, 650, 200)
	panel:SetPoint("center", UIParent, "center")
	panel:Hide()
	panel:SetFrameStrata("FULLSCREEN")
	panel:SetBackdrop({	bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 64, insets = {left=3, right=3, top=3, bottom=3}})
	panel:DisableGradient()
	panel:SetBackdropColor(0, 0, 0, 0)
	panel.locked = false
	
	local bg_texture = _details.gump:NewImage(panel,[[Interface\AddOns\Details\images\welcome]], 1, 1, "background")
	bg_texture:SetPoint("topleft", panel, "topleft")
	bg_texture:SetPoint("bottomright", panel, "bottomright")
	
	function panel.widget:Open(text, callback, host, default)
		if (host) then
			panel:SetPoint("center", host, "center")
		end
		
		text = text:gsub("||", "|")
		panel.default_text = text
		panel.widget.editbox:SetText(text)
		panel.callback = callback
		panel.default = default or ""
		panel:Show()
	end
	
	local textentry = _details.gump:NewSpecialLuaEditorEntry(panel.widget, 450, 180, "editbox", "$parentEntry", true)
	textentry:SetPoint("topleft", panel.widget, "topleft", 10, -10)
	
	local arg1_button = _details.gump:NewButton(panel, nil, "$parentButton1", nil, 80, 20, function() textentry.editbox:Insert("{data1}") end, nil, nil, nil, string.format(Loc["STRING_OPTIONS_TEXTEDITOR_DATA"], "1"), 1)
	local arg2_button = _details.gump:NewButton(panel, nil, "$parentButton2", nil, 80, 20, function() textentry.editbox:Insert("{data2}") end, nil, nil, nil, string.format(Loc["STRING_OPTIONS_TEXTEDITOR_DATA"], "2"), 1)
	local arg3_button = _details.gump:NewButton(panel, nil, "$parentButton3", nil, 80, 20, function() textentry.editbox:Insert("{data3}") end, nil, nil, nil, string.format(Loc["STRING_OPTIONS_TEXTEDITOR_DATA"], "3"), 1)
	arg1_button:SetPoint("topright", panel, "topright", -10, -14)
	arg2_button:SetPoint("topright", panel, "topright", -10, -36)
	arg3_button:SetPoint("topright", panel, "topright", -10, -58)
	arg1_button:InstallCustomTexture()
	arg2_button:InstallCustomTexture()
	arg3_button:InstallCustomTexture()
	
	arg1_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_DATA_TOOLTIP"]
	arg2_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_DATA_TOOLTIP"]
	arg3_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_DATA_TOOLTIP"]
	
	-- code author Saiket from  http://www.wowinterface.com/forums/showpost.php?p=245759&postcount=6
	--- @return StartPos, EndPos of highlight in this editbox.
	local function GetTextHighlight( self )
		local Text, Cursor = self:GetText(), self:GetCursorPosition();
		self:Insert( "" ); -- Delete selected text
		local TextNew, CursorNew = self:GetText(), self:GetCursorPosition();
		-- Restore previous text
		self:SetText( Text );
		self:SetCursorPosition( Cursor );
		local Start, End = CursorNew, #Text -( #TextNew - CursorNew );
		self:HighlightText( Start, End );
		return Start, End;
	end
      
	local StripColors;
	do
		local CursorPosition, CursorDelta;
		--- Callback for gsub to remove unescaped codes.
		local function StripCodeGsub( Escapes, Code, End )
			if ( #Escapes % 2 == 0 ) then -- Doesn't escape Code
				if ( CursorPosition and CursorPosition >= End - 1 ) then
					CursorDelta = CursorDelta - #Code;
				end
				return Escapes;
			end
		end
		--- Removes a single escape sequence.
		local function StripCode( Pattern, Text, OldCursor )
			CursorPosition, CursorDelta = OldCursor, 0;
			return Text:gsub( Pattern, StripCodeGsub ), OldCursor and CursorPosition + CursorDelta;
		end
		--- Strips Text of all color escape sequences.
		-- @param Cursor  Optional cursor position to keep track of.
		-- @return Stripped text, and the updated cursor position if Cursor was given.
		function StripColors( Text, Cursor )
			Text, Cursor = StripCode( "(|*)(|c%x%x%x%x%x%x%x%x)()", Text, Cursor );
			return StripCode( "(|*)(|r)()", Text, Cursor );
		end
	end
	
	local COLOR_END = "|r";
	--- Wraps this editbox's selected text with the given color.
	local function ColorSelection( self, ColorCode )
		local Start, End = GetTextHighlight( self );
		local Text, Cursor = self:GetText(), self:GetCursorPosition();
		if ( Start == End ) then -- Nothing selected
			--Start, End = Cursor, Cursor; -- Wrap around cursor
			return; -- Wrapping the cursor in a color code and hitting backspace crashes the client!
		end
		-- Find active color code at the end of the selection
		local ActiveColor;
		if ( End < #Text ) then -- There is text to color after the selection
			local ActiveEnd;
			local CodeEnd, _, Escapes, Color = 0;
			while( true ) do
				_, CodeEnd, Escapes, Color = Text:find( "(|*)(|c%x%x%x%x%x%x%x%x)", CodeEnd + 1 );
				if ( not CodeEnd or CodeEnd > End ) then
					break;
				end
				if ( #Escapes % 2 == 0 ) then -- Doesn't escape Code
					ActiveColor, ActiveEnd = Color, CodeEnd;
				end
			end
       
			if ( ActiveColor ) then
				-- Check if color gets terminated before selection ends
				CodeEnd = 0;
				while( true ) do
					_, CodeEnd, Escapes = Text:find( "(|*)|r", CodeEnd + 1 );
					if ( not CodeEnd or CodeEnd > End ) then
						break;
					end
					if ( CodeEnd > ActiveEnd and #Escapes % 2 == 0 ) then -- Terminates ActiveColor
						ActiveColor = nil;
						break;
					end
				end
			end
		end
     
		local Selection = Text:sub( Start + 1, End );
		-- Remove color codes from the selection
		local Replacement, CursorReplacement = StripColors( Selection, Cursor - Start );
     
		self:SetText(( "" ):join(
			Text:sub( 1, Start ),
			ColorCode, Replacement, COLOR_END,
			ActiveColor or "", Text:sub( End + 1 )
		) );
     
		-- Restore cursor and highlight, adjusting for wrapper text
		Cursor = Start + CursorReplacement;
		if ( CursorReplacement > 0 ) then -- Cursor beyond start of color code
			Cursor = Cursor + #ColorCode;
		end
		if ( CursorReplacement >= #Replacement ) then -- Cursor beyond end of color
			Cursor = Cursor + #COLOR_END;
		end
		
		self:SetCursorPosition( Cursor );
		-- Highlight selection and wrapper
		self:HighlightText( Start, #ColorCode +( #Replacement - #Selection ) + #COLOR_END + End );
	end
	
	local color_func = function(_, r, g, b, a)
		local hex = _details:hex(a*255).._details:hex(r*255).._details:hex(g*255).._details:hex(b*255)
		ColorSelection( textentry.editbox, "|c" .. hex)
	end
	
	local func_button = _details.gump:NewButton(panel, nil, "$parentButton4", nil, 80, 20, function() textentry.editbox:Insert("{func local player = ...; return 0;}") end, nil, nil, nil, Loc["STRING_OPTIONS_TEXTEDITOR_FUNC"], 1)
	local color_button = _details.gump:NewColorPickButton(panel, "$parentButton5", nil, color_func)
	color_button:SetSize(80, 20)
	func_button:SetPoint("topright", panel, "topright", -10, -80)
	color_button:SetPoint("topright", panel, "topright", -10, -102)
	func_button:InstallCustomTexture()
	
	color_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_COLOR_TOOLTIP"]
	func_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_FUNC_TOOLTIP"]
	
	--color_button:InstallCustomTexture()
	
	--local comma_button = _details.gump:NewButton(panel, nil, "$parentButtonComma", nil, 80, 20, function() textentry.editbox:Insert("_details:comma_value( )") end, nil, nil, nil, Loc["STRING_OPTIONS_TEXTEDITOR_COMMA"])
	--local tok_button = _details.gump:NewButton(panel, nil, "$parentButtonTok", nil, 80, 20, function() textentry.editbox:Insert("_details:ToK2( )") end, nil, nil, nil, Loc["STRING_OPTIONS_TEXTEDITOR_TOK"])
	--comma_button:InstallCustomTexture()
	--tok_button:InstallCustomTexture()
	--comma_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_COMMA_TOOLTIP"]
	--tok_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_TOK_TOOLTIP"]
	
	--comma_button:SetPoint("topright", panel, "topright", -100, -14)
	--tok_button:SetPoint("topright", panel, "topright", -100, -36)
	
	local done = function()
		local text = panel.widget.editbox:GetText()
		text = text:gsub("\n", "")
		
		local test = text
	
		local function errorhandler(err)
			return geterrorhandler()(err)
		end
	
		local code =[[local str = "STR"; str = str:ReplaceData(100, 50, 75, {name = "you", total = 10, total_without_pet = 5, damage_taken = 7, last_dps = 1, friendlyfire_total = 6, totalover = 2, totalabsorb = 4, totalover_without_pet = 6, healing_taken = 1, heal_enemy_amt = 2});]]
		code = code:gsub("STR", test)

		local f = loadstring(code)
		local err, two = xpcall(f, errorhandler)
		
		if (not err) then
			return
		end
		
		panel.callback(text)
		panel:Hide()
	end
	
	local ok_button = _details.gump:NewButton(panel, nil, "$parentButtonOk", nil, 80, 20, done, nil, nil, nil, Loc["STRING_OPTIONS_TEXTEDITOR_DONE"], 1)
	ok_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_DONE_TOOLTIP"]
	ok_button:InstallCustomTexture()
	ok_button:SetPoint("topright", panel, "topright", -10, -174)
	
	local reset_button = _details.gump:NewButton(panel, nil, "$parentDefaultOk", nil, 80, 20, function() textentry.editbox:SetText(panel.default) end, nil, nil, nil, Loc["STRING_OPTIONS_TEXTEDITOR_RESET"], 1)
	reset_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_RESET_TOOLTIP"]
	reset_button:InstallCustomTexture()
	reset_button:SetPoint("topright", panel, "topright", -100, -152)
	
	local cancel_button = _details.gump:NewButton(panel, nil, "$parentDefaultCancel", nil, 80, 20, function() textentry.editbox:SetText(panel.default_text); done(); end, nil, nil, nil, Loc["STRING_OPTIONS_TEXTEDITOR_CANCEL"], 1)
	cancel_button.tooltip = Loc["STRING_OPTIONS_TEXTEDITOR_CANCEL_TOOLTIP"]
	cancel_button:InstallCustomTexture()
	cancel_button:SetPoint("topright", panel, "topright", -100, -174)	
	
	--update window
	function _details:OpenUpdateWindow()
	
		if (not _G.DetailsUpdateDialog) then
			local updatewindow_frame = CreateFrame("frame", "DetailsUpdateDialog", UIParent, "ButtonFrameTemplate")
			updatewindow_frame:SetFrameStrata("LOW")
			tinsert(UISpecialFrames, "DetailsUpdateDialog")
			updatewindow_frame:SetPoint("center", UIParent, "center")
			updatewindow_frame:SetSize(512, 200)
			updatewindow_frame.portrait:SetTexture([[Interface\CHARACTERFRAME\TEMPORARYPORTRAIT-FEMALE-GNOME]])
			
			updatewindow_frame.TitleText:SetText("A New Version Is Available!")

			updatewindow_frame.midtext = updatewindow_frame:CreateFontString(nil, "artwork", "GameFontNormal")
			updatewindow_frame.midtext:SetText("Good news everyone!\nA new version has been forged and is waiting to be looted.")
			updatewindow_frame.midtext:SetPoint("topleft", updatewindow_frame, "topleft", 10, -90)
			updatewindow_frame.midtext:SetJustifyH("center")
			updatewindow_frame.midtext:SetWidth(370)
			
			updatewindow_frame.gnoma = updatewindow_frame:CreateTexture(nil, "artwork")
			updatewindow_frame.gnoma:SetPoint("topright", updatewindow_frame, "topright", -3, -59)
			updatewindow_frame.gnoma:SetTexture("Interface\\AddOns\\Details\\images\\icons2")
			updatewindow_frame.gnoma:SetSize(105*1.05, 107*1.05)
			updatewindow_frame.gnoma:SetTexCoord(0.2021484375, 0, 0.7919921875, 1)
			
			local editbox = _details.gump:NewTextEntry(updatewindow_frame, nil, "$parentTextEntry", "text", 387, 14)
			editbox:SetPoint(20, -136)
			editbox:SetAutoFocus(false)
			editbox:SetHook("OnEditFocusGained", function() 
				editbox.text = "http://www.curse.com/addons/wow/details"
				editbox:HighlightText()
			end)
			editbox:SetHook("OnEditFocusLost", function() 
				editbox.text = "http://www.curse.com/addons/wow/details"
				editbox:HighlightText()
			end)
			editbox:SetHook("OnChar", function() 
				editbox.text = "http://www.curse.com/addons/wow/details"
				editbox:HighlightText()
			end)
			editbox.text = "http://www.curse.com/addons/wow/details"
			
			updatewindow_frame.close = CreateFrame("Button", "DetailsUpdateDialogCloseButton", updatewindow_frame, "OptionsButtonTemplate")
			updatewindow_frame.close:SetPoint("bottomleft", updatewindow_frame, "bottomleft", 8, 4)
			updatewindow_frame.close:SetText("Close")
			
			updatewindow_frame.close:SetScript("OnClick", function(self)
				DetailsUpdateDialog:Hide()
				editbox:ClearFocus()
			end)
			
			updatewindow_frame:SetScript("OnHide", function()
				editbox:ClearFocus()
			end)
			
			function _details:UpdateDialogSetFocus()
				DetailsUpdateDialog:Show()
				DetailsUpdateDialogTextEntry.MyObject:SetFocus()
				DetailsUpdateDialogTextEntry.MyObject:HighlightText()
			end
			_details:ScheduleTimer("UpdateDialogSetFocus", 1)
			
		end
		
	end	
	
	function _details:OpenProfiler()
	
		--> isn't first run, so just quit
		if (not _details.character_first_run) then
			return
		elseif (_details.is_first_run) then
			return
		elseif (_details.always_use_profile and type(_details.always_use_profile) == "string") then
			return
		else
			--> check is this is the first run of the addon(after being installed)
			local amount = 0
			for name, profile in pairs(_details_global.__profiles) do 
				amount = amount + 1
			end
			if (amount == 1) then
				return
			end
		end
	
		local f = CreateFrame("frame", nil, UIParent) --"DetailsSelectProfile"
		f:SetSize(250, 300)
		
		f:SetPoint("right", UIParent, "right", -5, 0)
		
		f:SetMovable(true)
		f:SetScript("OnMouseDown", function(self)
			if (not self.moving) then
				self:StartMoving()
				self.moving = true
			end
		end)
		f:SetScript("OnMouseUp", function(self)
			if (self.moving) then
				self:StopMovingOrSizing()
				self.moving = false
			end
		end)
		
		local background = f:CreateTexture(nil, "background")
		background:SetAllPoints()
		background:SetTexture([[Interface\AddOns\Details\images\welcome]])
		
		local logo = f:CreateTexture(nil, "artwork")
		logo:SetTexture([[Interface\AddOns\Details\images\logotype]])
		logo:SetSize(256*0.8, 128*0.8)
		logo:SetPoint("center", f, "center", 0, 0)
		logo:SetPoint("top", f, "top", 20, 20)
		
		local string_profiler = f:CreateFontString(nil, "artwork", "GameFontNormal")
		string_profiler:SetPoint("top", logo, "bottom", -20, 10)
		string_profiler:SetText("Profiler!")
		
		local string_profiler = f:CreateFontString(nil, "artwork", "GameFontNormal")
		string_profiler:SetPoint("topleft", f, "topleft", 10, -130)
		string_profiler:SetText(Loc["STRING_OPTIONS_PROFILE_SELECTEXISTING"])
		string_profiler:SetWidth(230)
		_details:SetFontSize(string_profiler, 11)
		_details:SetFontColor(string_profiler, "white")
		
		--> get the new profile name
		local current_profile = _details:GetCurrentProfileName()
		
		local on_select_profile = function(_, _, profilename)
			if (profilename ~= _details:GetCurrentProfileName()) then
				_details:ApplyProfile(profilename)
				if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
					_details:OpenOptionsWindow(_G.DetailsOptionsWindow.instance)
				end
			end
		end
		
		local texcoord = {5/32, 30/32, 4/32, 28/32}
		
		local fill_dropdown = function()
			local t = {
				{value = current_profile, label = Loc["STRING_OPTIONS_PROFILE_USENEW"], onclick = on_select_profile, icon =[[Interface\FriendsFrame\UI-Toast-FriendRequestIcon]], texcoord = {4/32, 30/32, 4/32, 28/32}, iconcolor = "orange"}
			}
			for _, profilename in ipairs(_details:GetProfileList()) do
				if (profilename ~= current_profile) then
					t[#t+1] = {value = profilename, label = profilename, onclick = on_select_profile, icon =[[Interface\FriendsFrame\UI-Toast-FriendOnlineIcon]], texcoord = texcoord, iconcolor = "yellow"}
				end
			end
			return t
		end
		
		local dropdown = _details.gump:NewDropDown(f, f, "DetailsProfilerProfileSelectorDropdown", "dropdown", 220, 20, fill_dropdown, 1)
		dropdown:SetPoint(15, -190)
		
		local confirm_func = function()
			if (current_profile ~= _details:GetCurrentProfileName()) then
				_details:EraseProfile(current_profile)
			end
			f:Hide()
		end
		local confirm = _details.gump:NewButton(f, f, "DetailsProfilerProfileConfirmButton", "button", 150, 20, confirm_func, nil, nil, nil, "okey!")
		confirm:SetPoint(50, -250)
		confirm:InstallCustomTexture()
	
	end	
	
	--> minimap icon and hotcorner
	function _details:RegisterMinimap()
		local LDB = LibStub("LibDataBroker-1.1", true)
		local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)
		
		if LDB then

			local databroker = LDB:NewDataObject("Details!", {
				type = "launcher",
				icon =[[Interface\AddOns\Details\images\minimap]],
				text = "0",
				
				HotCornerIgnore = true,
				
				OnClick = function(self, button)
				
					if (button == "LeftButton") then
					
						--> 1 = open options panel
						if (_details.minimap.onclick_what_todo == 1) then
							local lower_instance = _details:GetLowerInstanceNumber()
							if (not lower_instance) then
								local instance = _details:GetInstance(1)
								_details.Createinstance(_, _, 1)
								_details:OpenOptionsWindow(instance)
							else
								_details:OpenOptionsWindow(_details:GetInstance(lower_instance))
							end
						
						--> 2 = reset data
						elseif (_details.minimap.onclick_what_todo == 2) then
							_details.table_history:reset()
						
						--> 3 = show hide windows
						elseif (_details.minimap.onclick_what_todo == 3) then
							local opened = _details:GetOpenedWindowsAmount()
							
							if (opened == 0) then
								_details:ReopenAllInstances()
							else
								_details:ShutDownAllInstances()
							end
						end
						
					elseif (button == "RightButton") then
					
						GameTooltip:Hide()
						local GameCooltip = GameCooltip
						
						GameCooltip:Reset()
						GameCooltip:SetType("menu")
						GameCooltip:SetOption("ButtonsYMod", -5)
						GameCooltip:SetOption("HeighMod", 5)
						GameCooltip:SetOption("TextSize", 10)

						--344 427 200 268 0.0009765625
						--0.672851, 0.833007, 0.391601, 0.522460
						
						--GameCooltip:SetBannerImage(1,[[Interface\AddOns\Details\images\icons]], 83*.5, 68*.5, {"bottomleft", "topleft", 1, -4}, {0.672851, 0.833007, 0.391601, 0.522460}, nil)
						--GameCooltip:SetBannerImage(2, "Interface\\PetBattles\\Weather-Windy", 512*.35, 128*.3, {"bottomleft", "topleft", -25, -4}, {0, 1, 1, 0})
						--GameCooltip:SetBannerText(1, "Mini Map Menu", {"left", "right", 2, -5}, "white", 10)
						
						--> reset
						GameCooltip:AddMenu(1, _details.table_history.reset, true, nil, nil, Loc["STRING_MINIMAPMENU_RESET"], nil, true)
						GameCooltip:AddIcon([[Interface\COMMON\VOICECHAT-MUTED]], 1, 1, 14, 14)
						
						GameCooltip:AddLine("$div")
						
						--> new instancai
						GameCooltip:AddMenu(1, _details.Createinstance, true, nil, nil, Loc["STRING_MINIMAPMENU_NEWWINDOW"], nil, true)
						GameCooltip:AddIcon([[Interface\ICONS\Spell_ChargePositive]], 1, 1, 14, 14, 0.0703125, 0.9453125, 0.0546875, 0.9453125)
						
						--> reopen window 64: 0.0078125
						local reopen = function()
							for _, instance in ipairs(_details.table_instances) do 
								if (not instance:IsActive()) then
									_details:Createinstance(instance.mine_id)
									return
								end
							end
						end
						GameCooltip:AddMenu(1, reopen, nil, nil, nil, Loc["STRING_MINIMAPMENU_REOPEN"], nil, true)
						GameCooltip:AddIcon([[Interface\AddOns\Details\images\Ability_Priest_VoidShift]], 1, 1, 14, 14, 0.0703125, 0.9453125, 0.0546875, 0.9453125)
						
						GameCooltip:AddMenu(1, _details.ReopenAllInstances, true, nil, nil, Loc["STRING_MINIMAPMENU_REOPENALL"], nil, true)
						GameCooltip:AddIcon([[Interface\AddOns\Details\images\Ability_Priest_VoidShift]], 1, 1, 14, 14, 0.0703125, 0.9453125, 0.0546875, 0.9453125, "#ffb400")

						GameCooltip:AddLine("$div")
						
						--> lock
						GameCooltip:AddMenu(1, _details.LockInstances, true, nil, nil, Loc["STRING_MINIMAPMENU_LOCK"], nil, true)
						GameCooltip:AddIcon([[Interface\AddOns\Details\images\PetBattle-LockIcon]], 1, 1, 14, 14, 0.0703125, 0.9453125, 0.0546875, 0.9453125)
						
						GameCooltip:AddMenu(1, _details.UnlockInstances, true, nil, nil, Loc["STRING_MINIMAPMENU_UNLOCK"], nil, true)
						GameCooltip:AddIcon([[Interface\AddOns\Details\images\PetBattle-LockIcon]], 1, 1, 14, 14, 0.0703125, 0.9453125, 0.0546875, 0.9453125, "gray")
						
						GameCooltip:SetOwner(self, "topright", "bottomleft")
						GameCooltip:ShowCooltip()
						

					end
				end,
				OnTooltipShow = function(tooltip)
					tooltip:AddLine("Details!", 1, 1, 1)
					if (_details.minimap.onclick_what_todo == 1) then
						tooltip:AddLine(Loc["STRING_MINIMAP_TOOLTIP1"])
					elseif (_details.minimap.onclick_what_todo == 2) then
						tooltip:AddLine(Loc["STRING_MINIMAP_TOOLTIP11"])
					elseif (_details.minimap.onclick_what_todo == 3) then
						tooltip:AddLine(Loc["STRING_MINIMAP_TOOLTIP12"])
					end
					tooltip:AddLine(Loc["STRING_MINIMAP_TOOLTIP2"])
				end,
			})
			
			if (databroker and not LDBIcon:IsRegistered("Details!")) then
				LDBIcon:Register("Details!", databroker, self.minimap)
			end
			
			_details.databroker = databroker
			
		end
	end
	
	function _details:DoRegisterHotCorner()
		--register lib-hotcorners
		local on_click_on_hotcorner_button = function(frame, button) 
			if (_details.hotcorner_topleft.onclick_what_todo == 1) then
				local lower_instance = _details:GetLowerInstanceNumber()
				if (not lower_instance) then
					local instance = _details:GetInstance(1)
					_details.Createinstance(_, _, 1)
					_details:OpenOptionsWindow(instance)
				else
					_details:OpenOptionsWindow(_details:GetInstance(lower_instance))
				end
				
			elseif (_details.hotcorner_topleft.onclick_what_todo == 2) then
				_details.table_history:reset()
			end
		end

		local quickclick_func1 = function(frame, button) 
			_details.table_history:reset()
		end
		
		local quickclick_func2 = function(frame, button) 
			local lower_instance = _details:GetLowerInstanceNumber()
			if (not lower_instance) then
				local instance = _details:GetInstance(1)
				_details.Createinstance(_, _, 1)
				_details:OpenOptionsWindow(instance)
			else
				_details:OpenOptionsWindow(_details:GetInstance(lower_instance))
			end
		end
		
		local tooltip_hotcorner = function()
			GameTooltip:AddLine("Details!", 1, 1, 1, 1)
			if (_details.hotcorner_topleft.onclick_what_todo == 1) then
				GameTooltip:AddLine("|cFF00FF00Left Click:|r open options panel.", 1, 1, 1, 1)
				
			elseif (_details.hotcorner_topleft.onclick_what_todo == 2) then
				GameTooltip:AddLine("|cFF00FF00Left Click:|r clear all segments.", 1, 1, 1, 1)
				
			end
		end
		
		if (_G.HotCorners) then
			_G.HotCorners:RegisterHotCornerButton(
				--> absolute name
				"Details!",
				--> corner
				"TOPLEFT", 
				--> config table
				_details.hotcorner_topleft,
				--> frame _G name
				"DetailsLeftCornerButton", 
				--> icon
				[[Interface\AddOns\Details\images\minimap]], 
				--> tooltip
				tooltip_hotcorner,
				--> click function
				on_click_on_hotcorner_button, 
				--> menus
				nil, 
				--> quick click
				{
					{func = quickclick_func1, name = "Details! - Reset Data"}, 
					{func = quickclick_func2, name = "Details! - Open Options"}
				},
				--> onenter
				nil,
				--> onleave
				nil,
				--> is install
				true
			)
		end
	end
	
	function _details:TestBarsUpdate()
		local current_combat = _details:GetCombat("current")
		for index, actor in current_combat[1]:ListActors() do
			actor.total = actor.total +(actor.total / 100 * math.random(1, 5))
			actor.total = actor.total -(actor.total / 100 * math.random(1, 5))
		end
		for index, actor in current_combat[2]:ListActors() do
			actor.total = actor.total +(actor.total / 100 * math.random(1, 5))
			actor.total = actor.total -(actor.total / 100 * math.random(1, 5))
		end
		current_combat[1].need_refresh = true
		current_combat[2].need_refresh = true
	end
	
	function _details:StartTestBarUpdate()
		if (_details.test_bar_update) then
			_details:CancelTimer(_details.test_bar_update)
		end
		_details.test_bar_update = _details:ScheduleRepeatingTimer("TestBarsUpdate", 0.1)
	end
	function _details:StopTestBarUpdate()
		if (_details.test_bar_update) then
			_details:CancelTimer(_details.test_bar_update)
		end
		_details.test_bar_update = nil
	end
	
	function _details:CreateTestBars()
		local current_combat = _details:GetCombat("current")
		
		local actors_name = {"Ragnaros", "The Lich King", "Your Neighbor", "Your Raid Leader", "Your Internet Girlfriend", "Mr. President", "A Shadow Priest Complaining About Dps", "Ms. Gray", "Parry Hotter", "Your Math Teacher", "King Djoffrey", UnitName("player") .. " Snow", "A Drunk Dawrf", "Somebody That You Used To Know", "Low Dps Guy", "Helvis Phresley(Death Log Not Found)", "Stormwind Guard", "A PvP Player", "Bolvar Fordragon","Malygos","Akama","Anachronos","Lady Blauminex","Cairne Bloodhoof","Borivar","C'Thun","Drek'Thar","Durotan","Eonar","Footman Malakai","Bolvar Fordragon","Fritz Fizzlesprocket","Lisa Gallywix","M'uru","High Priestess MacDonnell","Nazgrel","Ner'zhul","Saria Nightwatcher","Chief Ogg'ora","Ogoun","Grimm Onearm","Apothecary Oni'jus","Orman of Stromgarde","General Rajaxx","Baron Rivendare","Roland","Archmage Trelane","Liam Trollbane"}
		local actors_classes = CLASS_SORT_ORDER
		
		local total_damage = 0
		local total_heal = 0
		
		for i = 1, 10 do
			local robot = current_combat[1]:CatchCombatant(0x0000000000000, actors_name[math.random(1, #actors_name)], 0x114, true)
			robot.group = true
			robot.class = actors_classes[math.random(1, #actors_classes)]
			robot.total = math.random(10000000, 60000000)
			robot.damage_taken = math.random(10000000, 60000000)
			robot.friendlyfire_total = math.random(10000000, 60000000)
			
			total_damage = total_damage + robot.total
			
			if (robot.name == "King Djoffrey") then
				local robot_death = current_combat[4]:CatchCombatant(0x0000000000000, robot.name, 0x114, true)
				robot_death.group = true
				robot_death.class = robot.class
				local this_death = {{true, 96648, 100000, time(), 0, "Lady Holenna"}, {true, 96648, 100000, time()-52, 100000, "Lady Holenna"}, {true, 96648, 100000, time()-86, 200000, "Lady Holenna"}, {true, 96648, 100000, time()-101, 300000, "Lady Holenna"}, {false, 55296, 400000, time()-54, 400000, "King Djoffrey"}, {true, 14185, 0, time()-59, 400000, "Lady Holenna"}, {false, 87351, 400000, time()-154, 400000, "King Djoffrey"}, {false, 56236, 400000, time()-158, 400000, "King Djoffrey"} } 
				local t = {this_death, time(), robot.name, robot.class, 400000, "52m 12s", ["dead"] = true}
				table.insert(current_combat.last_events_tables, #current_combat.last_events_tables+1, t)
				
			elseif (robot.name == "Mr. President") then	
				rawset(_details.spellcache, 56488, {"Nuke", 56488,[[Interface\ICONS\inv_gizmo_supersappercharge]]})
				robot.spell_tables:CatchSpell(56488, true, "SPELL_DAMAGE")
				robot.spell_tables._ActorTable[56488].total = robot.total
			end
			
			local robot = current_combat[2]:CatchCombatant(0x0000000000000, actors_name[math.random(1, #actors_name)], 0x114, true)
			robot.group = true
			robot.class = actors_classes[math.random(1, #actors_classes)]
			robot.total = math.random(10000000, 60000000)
			robot.totalover = math.random(10000000, 60000000)
			robot.totalabsorb = math.random(10000000, 60000000)
			robot.healing_taken = math.random(10000000, 60000000)
			
			total_heal = total_heal + robot.total
			
		end
		
		current_combat.start_time = time()-360
		current_combat.end_time = time()
		
		current_combat.totals_group[1] = total_damage
		current_combat.totals_group[2] = total_heal
		current_combat.totals[1] = total_damage
		current_combat.totals[2] = total_heal
		
		for _, instance in ipairs(_details.table_instances) do 
			if (instance:IsEnabled()) then
				instance:InstanceReset()
			end
		end
		
	end	
	
	--old versions dialog
	--[[
	--print("Last Version:", _details_database.last_version, "Last Interval Version:", _details_database.last_realversion)

	local resetwarning_frame = CreateFrame("FRAME", "DetailsResetConfigWarningDialog", UIParent, "ButtonFrameTemplate")
	resetwarning_frame:SetFrameStrata("LOW")
	tinsert(UISpecialFrames, "DetailsResetConfigWarningDialog")
	resetwarning_frame:SetPoint("center", UIParent, "center")
	resetwarning_frame:SetSize(512, 200)
	resetwarning_frame.portrait:SetTexture("Interface\\CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-GNOME")
	resetwarning_frame:SetScript("OnHide", function()
		DetailsBubble:HideBubble()
	end)
	
	resetwarning_frame.TitleText:SetText("Noooooooooooo!!!")

	resetwarning_frame.midtext = resetwarning_frame:CreateFontString(nil, "artwork", "GameFontNormal")
	resetwarning_frame.midtext:SetText("A pack of murlocs has attacked Details! tech center, our gnames engineers are working on fixing the damage.\n\n If something is messed in your Details!, especially the close, instance and reset buttons, you can either 'Reset Skin' or access the options panel.")
	resetwarning_frame.midtext:SetPoint("topleft", resetwarning_frame, "topleft", 10, -90)
	resetwarning_frame.midtext:SetJustifyH("center")
	resetwarning_frame.midtext:SetWidth(370)
	
	resetwarning_frame.gnoma = resetwarning_frame:CreateTexture(nil, "artwork")
	resetwarning_frame.gnoma:SetPoint("topright", resetwarning_frame, "topright", -3, -80)
	resetwarning_frame.gnoma:SetTexture("Interface\\AddOns\\Details\\images\\icons2")
	resetwarning_frame.gnoma:SetSize(89*1.00, 97*1.00)
	--resetwarning_frame.gnoma:SetTexCoord(0.212890625, 0.494140625, 0.798828125, 0.99609375) -- 109 409 253 510
	resetwarning_frame.gnoma:SetTexCoord(0.17578125, 0.001953125, 0.59765625, 0.787109375) -- 1 306 90 403
	
	resetwarning_frame.close = CreateFrame("Button", "DetailsFeedbackWindowCloseButton", resetwarning_frame, "OptionsButtonTemplate")
	resetwarning_frame.close:SetPoint("bottomleft", resetwarning_frame, "bottomleft", 8, 4)
	resetwarning_frame.close:SetText("Close")
	resetwarning_frame.close:SetScript("OnClick", function(self)
		resetwarning_frame:Hide()
	end)

	resetwarning_frame.see_updates = CreateFrame("Button", "DetailsResetWindowSeeUpdatesButton", resetwarning_frame, "OptionsButtonTemplate")
	resetwarning_frame.see_updates:SetPoint("bottomright", resetwarning_frame, "bottomright", -10, 4)
	resetwarning_frame.see_updates:SetText("Update Info")
	resetwarning_frame.see_updates:SetScript("OnClick", function(self)
		_details.OpenNewsWindow()
		DetailsBubble:HideBubble()
		--resetwarning_frame:Hide()
	end)
	resetwarning_frame.see_updates:SetWidth(130)
	
	resetwarning_frame.reset_skin = CreateFrame("Button", "DetailsResetWindowResetSkinButton", resetwarning_frame, "OptionsButtonTemplate")
	resetwarning_frame.reset_skin:SetPoint("right", resetwarning_frame.see_updates, "left", -5, 0)
	resetwarning_frame.reset_skin:SetText("Reset Skin")
	resetwarning_frame.reset_skin:SetScript("OnClick", function(self)
		--do the reset
		for index, instance in ipairs(_details.table_instances) do 
			if (not instance.initiated) then
				instance:RestoreWindow()
				local skin = instance.skin
				instance:ChangeSkin("Default Skin")
				instance:ChangeSkin("Minimalistic")
				instance:ChangeSkin(skin)
				instance:DisableInstance()
			else
				local skin = instance.skin
				instance:ChangeSkin("Default Skin")
				instance:ChangeSkin("Minimalistic")
				instance:ChangeSkin(skin)
			end
		end
	end)
	resetwarning_frame.reset_skin:SetWidth(130)
	
	resetwarning_frame.open_options = CreateFrame("Button", "DetailsResetWindowOpenOptionsButton", resetwarning_frame, "OptionsButtonTemplate")
	resetwarning_frame.open_options:SetPoint("right", resetwarning_frame.reset_skin, "left", -5, 0)
	resetwarning_frame.open_options:SetText("Options Panel")
	resetwarning_frame.open_options:SetScript("OnClick", function(self)
		local lower_instance = _details:GetLowerInstanceNumber()
		if (not lower_instance) then
			local instance = _details:GetInstance(1)
			_details.Createinstance(_, _, 1)
			_details:OpenOptionsWindow(instance)
		else
			_details:OpenOptionsWindow(_details:GetInstance(lower_instance))
		end
	end)
	resetwarning_frame.open_options:SetWidth(130)

	function _details:ResetWarningDialog()
		DetailsResetConfigWarningDialog:Show()
		DetailsBubble:SetOwner(resetwarning_frame.gnoma, "bottomright", "topleft", 30, -37, 1)
		DetailsBubble:FlipHorizontal()
		DetailsBubble:SetBubbleText("", "", "WWHYYYYYYYYY!!!!", "", "")
		DetailsBubble:TextConfig(14, nil, "deeppink")
		DetailsBubble:ShowBubble()


	end
	_details:ScheduleTimer("ResetWarningDialog", 7)
--]]

--[[
	local background_up = f:CreateTexture(nil, "background")
	background_up:SetPoint("topleft", f, "topleft")
	background_up:SetSize(250, 150)
	background_up:SetTexture("Interface\\AddOns\\Details\\images\\Question-Main")
	background_up:SetTexCoord(0, 420/512, 320/512, 475/512)
	
	local background_down = f:CreateTexture(nil, "background")
	background_down:SetPoint("topleft", background_up, "bottomleft")
	background_down:SetSize(250, 150)
	background_down:SetTexture("Interface\\AddOns\\Details\\images\\Question-Main")
	background_down:SetTexCoord(0, 420/512, 156/512, 308/512)
	
	background_up:SetDesaturated(true)
	background_down:SetDesaturated(true)
--]]