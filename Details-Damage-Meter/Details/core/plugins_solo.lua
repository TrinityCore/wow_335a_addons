--File Revision: 1
--Last Modification: 27/07/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = _G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _pairs = pairs --lua locals
	local _math_floor = math.floor --lua locals

	local _UnitAura = UnitAura
	
	local gump = _details.gump --details local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local mode_alone = _details._details_props["MODE_ALONE"]
	local mode_group = _details._details_props["MODE_GROUP"]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions	

	--> When a combat start
	function _details:UpdateSolo()
		local SoloInstance = _details.table_instances[_details.solo]
		_details.SoloTables.CombatIDLast = _details.SoloTables.CombatID
		_details.SoloTables.CombatID = _details:NumeroCombate()
		_details.SoloTables.Attribute = SoloInstance.attribute
	end

	--> enable and disable Solo Mode for an Instance
	function _details:SoloMode(show)
		if (show) then
		
			--> salvar a window normal
			if (self.displaying ~= "solo") then --> caso o addon tenha ligado ja no painel solo, não precisa rodar isso aqui
				self:SaveMainWindowPosition()

				if (self.scrolling) then
					self:HideScrollBar() --> hida a scrollbar
				end
				self.need_scrolling = false

				self.baseframe:EnableMouseWheel(false)
				gump:Fade(self, 1, nil, "bars") --> escondendo a window da instância[instância[force hide[velocidade[hidar o que]]]]
				self.displaying = "solo"
			end
			
			_details.SoloTables.instance = self
			
			--> default plugin
			if (not _details.SoloTables.built) then
				gump:PrepareSoloMode(self)
			end
			
			self.mode = _details._details_props["MODE_ALONE"]
			_details.solo = self.mine_id
			--self:UpdateSliderSolo(0)

			if (not self.position.solo.w) then --> primeira vez que o solo mode é executado nessa instância
				self.baseframe:SetWidth(300)
				self.baseframe:SetHeight(300)
				self:SaveMainWindowPosition()
			else
				self:RestoreMainWindowPosition()
				local w, h = self:GetSize()
				if (w ~= 300 or h ~= 300) then
					self.baseframe:SetWidth(300)
					self.baseframe:SetHeight(300)
					self:SaveMainWindowPosition()
				end
			end
			
			local first_enabled_plugin, first_enabled_plugin_index
			for index, plugin in ipairs(_details.SoloTables.Plugins) do
				if (plugin.__enabled) then
					first_enabled_plugin = plugin
					first_enabled_plugin_index = index
				end
			end
			
			if (not first_enabled_plugin) then
				_details:WaitForSoloPlugin(self)
			else
				if (not _details.SoloTables.Plugins[_details.SoloTables.Mode]) then
					_details.SoloTables.Mode = first_enabled_plugin_index
				end
				_details.SoloTables:switch(nil, _details.SoloTables.Mode)
			end

		else
		
			--print("--------------------------------")
			--print(debugstack())
		
			if (_details.PluginCount.SOLO > 0) then
				local solo_frame = _details.SoloTables.Plugins[_details.SoloTables.Mode].Frame
				if (solo_frame) then
					_details.SoloTables:switch()
				end
			end

			_details.solo = nil --> destranca a window solo para ser usada em outras  instâncias
			self.displaying = "normal"
			self:RestoreMainWindowPosition()
			
			if (_G.DetailsWaitForPluginFrame:IsShown()) then
				_details:CancelWaitForPlugin()
			end

			gump:Fade(self, 1, nil, "bars")
			gump:Fade(self.scroll, 0)
			
			if (self.need_scrolling) then
				self:MostrarScrollBar(true)
			else
				--> precisa verificar se ele precisa a scrolling certo?
				self:ReadjustGump()
			end
			
			--> calcula se existem bars, etc...
			if (not self.rows_fit_in_window) then --> as bars não forma initiateds ainda
				self.rows_fit_in_window = _math_floor(self.baseframe.BoxBarsAltura / self.row_height)
				if (self.rows_created < self.rows_fit_in_window) then
					for i  = #self.bars+1, self.rows_fit_in_window do
						local new_bar = gump:CreateNewBar(self, i, 30) --> cria new bar
						new_bar.text_left:SetText(Loc["STRING_NEWROW"])
						new_bar.statusbar:SetValue(100) 
						self.bars[i] = new_bar
					end
					self.rows_created = #self.bars
				end
			end
		end
	end

	--> Build Solo Mode Tables and Functions
	function gump:PrepareSoloMode(instance)

		_details.SoloTables.built = true

		_details.SoloTables.SpellCastTable = {} --> not used
		_details.SoloTables.TimeTable = {} --> not used

		_details.SoloTables.Mode = _details.SoloTables.Mode or 1 --> solo mode
		
		function _details.SoloTables:GetActiveIndex()
			return _details.SoloTables.Mode
		end
		
		function _details.SoloTables:switch(_, _switchTo)

			--> just hide all
			if (not _switchTo) then 
				if (#_details.SoloTables.Plugins > 0) then --> have at least one plugin
					_details.SoloTables.Plugins[_details.SoloTables.Mode].Frame:Hide()
				end
				return
			end
			
			--> if passed the absolute plugin name
			if (type(_switchTo) == "string") then
				for index, ptable in ipairs(_details.SoloTables.Menu) do 
					if (ptable[3].__enabled and ptable[4] == _switchTo) then
						_switchTo = index
						break
					end
				end
				
			elseif (_switchTo == -1) then
				_switchTo = _details.SoloTables.Mode + 1
				if (_switchTo > #_details.SoloTables.Plugins) then
					_switchTo = 1
				end
			end
		
			local ThisFrame = _details.SoloTables.Plugins[_details.SoloTables.Mode]
			if (not ThisFrame or not ThisFrame.__enabled) then
				--> frame not found, try in few second again
				_details.SoloTables.Mode = _switchTo
				_details:WaitForSoloPlugin(instance)
				return
			end
		
			--> hide current frame
			_details.SoloTables.Plugins[_details.SoloTables.Mode].Frame:Hide()
			--> switch mode
			_details.SoloTables.Mode = _switchTo
			--> show and setpoint new frame

			_details.SoloTables.Plugins[_details.SoloTables.Mode].Frame:Show()
			_details.SoloTables.Plugins[_details.SoloTables.Mode].Frame:SetPoint("TOPLEFT",_details.SoloTables.instance.bgframe)
			
			_details.SoloTables.instance:ChangeIcon(_details.SoloTables.Menu[_details.SoloTables.Mode][2])
			
			_details:SendEvent("DETAILS_INSTANCE_CHANGEATTRIBUTE", nil, _details.SoloTables.instance, _details.SoloTables.instance.attribute, _details.SoloTables.instance.sub_attribute)
			
		end
		
		return true
	end

	function _details:CloseSoloDebuffs()
		local SoloDebuffUptime = _details.table_current.SoloDebuffUptime
		if (not SoloDebuffUptime) then
			return
		end
		
		for SpellId, DebuffTable in _pairs(SoloDebuffUptime) do
			if (DebuffTable.start) then
				DebuffTable.duration = DebuffTable.duration +(_details._time - DebuffTable.start) --> time do parser será igual ao time()?
				DebuffTable.start = nil
			end
			DebuffTable.Active = false
		end
	end

	--> Buffs terá em todos os Solo Modes
	function _details.SoloTables:CatchBuffs()
		--> reset bufftables
		_details.SoloTables.SoloBuffUptime = _details.SoloTables.SoloBuffUptime or {}
		
		for spellname, BuffTable in _pairs(_details.SoloTables.SoloBuffUptime) do
			--local BuffEntryTable = _details.SoloTables.BuffTextEntry[BuffTable.tableIndex]
			
			if (BuffTable.Active) then
				BuffTable.start = _details._time
				BuffTable.castedAmt = 1
				BuffTable.appliedAt = {}
				--BuffEntryTable.backgroundFrame:Active()
			else
				BuffTable.start = nil
				BuffTable.castedAmt = 0
				BuffTable.appliedAt = {}
				--BuffEntryTable.backgroundFrame:Desactive()
			end
			
			BuffTable.duration = 0
			BuffTable.refreshAmt = 0
			BuffTable.droppedAmt = 0
		end
		
		--> catch buffs untracked yet
		for buffIndex = 1, 41 do
			local name = _UnitAura("player", buffIndex)
			if (name) then
				for index, BuffName in _pairs(_details.SoloTables.BuffsTableNameCache) do
					if (BuffName == name) then
						local BuffObject = _details.SoloTables.SoloBuffUptime[name]
						if (not BuffObject) then
							_details.SoloTables.SoloBuffUptime[name] = {name = name, duration = 0, start = nil, castedAmt = 1, refreshAmt = 0, droppedAmt = 0, Active = true, tableIndex = index, appliedAt = {}}
						end
					end
				end
			end
		end
	end

	function _details:instanceCheckForDisabledSolo(instance)

		if (not instance) then
			instance = self
		end
		
		
		if (instance.mode == mode_alone) then
			--print("arrumando a instance "..instance.mine_id)
			if (instance.initiated) then
				_details:ChangeMode(instance, mode_group)
				instance:SoloMode(false)
				_details:ResetGump(instance)
			else
				instance.mode = mode_group
				instance.last_mode = mode_group
			end
		end
	end

	function _details:UpdateSoloMode_AfertReset(instance)
		if (_details.SoloTables.CombatIDLast) then
			_details.SoloTables.CombatIDLast = nil
		end
		if (_details.SoloTables.CombatID) then
			_details.SoloTables.CombatID = 0
		end
	end
