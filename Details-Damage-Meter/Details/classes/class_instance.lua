local AceLocale = LibStub("AceLocale-3.0")
local Loc = AceLocale:GetLocale( "Details" )
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local _type= type  --> lua local
local _ipairs = ipairs --> lua local
local _pairs = pairs --> lua local
local _math_floor = math.floor --> lua local
local _math_abs = math.abs --> lua local
local _table_remove = table.remove --> lua local
local _getmetatable = getmetatable --> lua local
local _setmetatable = setmetatable --> lua local
local _string_len = string.len --> lua local
local _unpack = unpack --> lua local
local _cstr = string.format --> lua local
local _SendChatMessage = SendChatMessage --> wow api locals
local _GetChannelName = GetChannelName --> wow api locals
local _UnitExists = UnitExists --> wow api locals
local _UnitName = UnitName --> wow api locals
local _UnitIsPlayer = UnitIsPlayer --> wow api locals
local _UnitGroupRolesAssigned = UnitGroupRolesAssigned --> wow api locals

--DODANE
local MAX_TALENT_TABS = MAX_TALENT_TABS;

local _details = 		_G._details
local gump = 			_details.gump

local history = 			_details.history

local mode_raid = _details._details_props["MODE_RAID"]
local mode_alone = _details._details_props["MODE_ALONE"]
local mode_group = _details._details_props["MODE_GROUP"]
local mode_all = _details._details_props["MODE_ALL"]

local _

local attributes = _details.attributes
local sub_attributes = _details.sub_attributes
local segments = _details.segments

--> STARTUP reactivate instances and regenerate tables from them
	function _details:RestartInstances()
		return _details:Reactivateinstances()
	end
	
	function _details:Reactivateinstances()
	
		_details.opened_windows = 0
		
		--> set metatables
		for index = 1, #_details.table_instances do 
			local instance = _details.table_instances[index]
			if (not _getmetatable(instance)) then
				_setmetatable(_details.table_instances[index], _details)
			end
		end
		
		--> create frames
		for index = 1, #_details.table_instances do 
			local instance = _details.table_instances[index]
			if (instance:IsEnabled()) then
				_details.opened_windows = _details.opened_windows + 1
				instance:RestoreWindow(index, nil, true)
			else
				instance.initiated = false
			end
		end
		
		--> load
		for index = 1, #_details.table_instances do 
			local instance = _details.table_instances[index]
			if (instance:IsEnabled()) then
				instance.initiated = true
				instance:EnableInstance()
				instance:ChangeSkin()
			end
		end
		
		--> send open event
		for index = 1, #_details.table_instances do 
			local instance = _details.table_instances[index]
			if (instance:IsEnabled()) then
				if (not _details.initializing) then
					_details:SendEvent("DETAILS_INSTANCE_OPEN", nil, instance)
				end
			end
		end
	end
	
------------------------------------------------------------------------------------------------------------------------

--> API: call a function to all enabled instances
function _details:InstanceCall(func, ...)
	if (type(func) == "string") then
		func = _details[func]
	end
	for index, instance in _ipairs(_details.table_instances) do
		if (instance:IsActive()) then --> only enabled
			func(instance, ...)
		end
	end
end

--> send a function to be exexuted in all instances(internal)
function _details:instanceCallFunction(func, ...)
	for index, instance in _ipairs(_details.table_instances) do
		if (instance:IsActive()) then --> only if is active
			func(_, instance, ...) 
		end
	end
end

--> send a function to be executed in all instances(internal)
function _details:instanceCallFunctionOffline(func, ...)
	for index, instance in _ipairs(_details.table_instances) do
		func(_, instance, ...)
	end
end

function _details:GetLowerInstanceNumber()
	local lower = 999
	for index, instance in _ipairs(_details.table_instances) do
		if (instance.active and instance.baseframe) then
			if (instance.mine_id < lower) then
				lower = instance.mine_id
			end
		end
	end
	if (lower == 999) then
		_details.lower_instance = 0
		return nil
	else
		_details.lower_instance = lower
		return lower
	end
end

function _details:IsLowerInstance()
	local lower = _details:GetLowerInstanceNumber()
	if (lower) then
		return lower == self.mine_id
	end
	return false
end

function _details:IsInteracting()
	return self.is_interacting
end

function _details:GetMode()
	return self.mode
end

function _details:GetInstance(id)
	return _details.table_instances[id]
end

function _details:GetId()
	return self.mine_id
end
function _details:GetInstanceId()
	return self.mine_id
end

function _details:GetSegment()
	return self.segment
end

function _details:GetSoloMode()
	return _details.table_instances[_details.solo]
end
function _details:GetRaidMode()
	return _details.table_instances[_details.raid]
end

function _details:IsSoloMode(offline)
	if (offline) then
		return self.mode == 1
	end
	if (not _details.solo) then
		return false
	else
		return _details.solo == self:GetInstanceId()
	end
end

function _details:IsRaidMode()
	return self.mode == _details._details_props["MODE_RAID"]
end

function _details:IsGroupMode()
	return self.mode == _details._details_props["MODE_GROUP"]
end

function _details:IsNormalMode()
	if (self:GetInstanceId() == 2 or self:GetInstanceId() == 3) then
		return true
	else
		return false
	end
end

function _details:GetCustomObject()
	return _details.custom[self.sub_attribute]
end

function _details:ResetAttribute()
	if (self.initiated) then 
		self:SwitchTable(nil, 1, 1, true)
	else
		self.attribute = 1
		self.sub_attribute = 1
	end
end

function _details:ListInstances()
	return _ipairs(_details.table_instances)
end

function _details:GetPosition()
	return self.position
end

function _details:GetDisplay()
	return self.attribute, self.sub_attribute
end

function _details:GetMaxInstancesAmount()
	return _details.instances_amount
end

function _details:GetFreeInstancesAmount()
	return _details.instances_amount - #_details.table_instances
end

function _details:GetOpenedWindowsAmount()
	local amount = 0
	for _, instance in _details:ListInstances() do
		if (instance:IsEnabled()) then
			amount = amount + 1
		end
	end
	return amount
end

function _details:GetNumRows()
	return self.rows_fit_in_window
end

function _details:GetRow(index)
	return self.bars[index]
end

------------------------------------------------------------------------------------------------------------------------

--> returns active instance
function _details:IsActive()
	return self.active
end
--> english alias
function _details:IsEnabled()
	return self.active
end

function _details:IsStarted()
	return self.initiated
end

------------------------------------------------------------------------------------------------------------------------

	function _details:LoadLocalInstanceConfig()
		local config = _details.local_instances_config[self.mine_id]
		if (config) then
		
			if (not _details.profile_save_pos) then
				self.position = table_deepcopy(config.pos)
			end
			
			if (_type(config.attribute) ~= "number") then
				config.attribute = 1
			end
			if (_type(config.sub_attribute) ~= "number") then
				config.sub_attribute = 1
			end
			if (_type(config.segment) ~= "number") then
				config.segment = 1
			end
			
			self.active = config.is_open
			self.attribute = config.attribute
			self.sub_attribute = config.sub_attribute
			self.mode = config.mode
			self.segment = config.segment
			self.snap = config.snap and table_deepcopy(config.snap) or {}
			self.horizontalSnap = config.horizontalSnap
			self.verticalSnap = config.verticalSnap
			self.sub_attribute_last = table_deepcopy(config.sub_attribute_last)
			self.isLocked = config.isLocked
			self.last_raid_plugin = config.last_raid_plugin
			
		end
	end

	function _details:ShutDownAllInstances()
		for index, instance in _ipairs(_details.table_instances) do
			if (instance:IsEnabled()) then
				instance:ShutDown()
			end
		end
	end

	function _details:ShutDown()
		return self:DisableInstance()
	end
	
	function _details:GetNumWindows()
		
	end

--> deactivates an instance which remain opened by just hiding the window
	function _details:DisableInstance()
	
		local lower = _details:GetLowerInstanceNumber()

		self.active = false
		_details:GetLowerInstanceNumber()
		
		if (lower == self.mine_id) then
			--> os icons dos plugins thiso hostiados nessa instance.
			_details.ToolBar:ReorganizeIcons(true) --não precisa recarregar toda a skin
		end
		
		if (_details.switch.current_instance and _details.switch.current_instance == self) then
			_details.switch:CloseMe()
		end
		
		_details.opened_windows = _details.opened_windows-1
		self:ResetGump()
		
		--gump:Fade(self.baseframe.header.attribute_icon, _unpack(_details.windows_fade_in))
		--gump:Fade(self.baseframe.header.ball, _unpack(_details.windows_fade_in))
		--gump:Fade(self.baseframe, _unpack(_details.windows_fade_in))
		--gump:Fade(self.rowframe, _unpack(_details.windows_fade_in))
		
		gump:Fade(self.baseframe.header.ball, 1)
		gump:Fade(self.baseframe, 1)
		gump:Fade(self.rowframe, 1)
		
		self:Ungroup(-1)
		
		if (self.mode == mode_raid) then
			_details.RaidTables:DisableRaidMode(self)
			
		elseif (self.mode == mode_alone) then
			_details.SoloTables:switch()
			self.atualizando = false
			_details.solo = nil
		end
		
		--print("Abertas: " .. _details.opened_windows)
		if (not _details.initializing) then
			_details:SendEvent("DETAILS_INSTANCE_CLOSE", nil, self)
		end
		
	end
------------------------------------------------------------------------------------------------------------------------

	function _details:instanceFadeBars(instance, segment)
		local _fadeType, _fadeSpeed = _unpack(_details.row_fade_in)
		if (segment) then
			if (instance.segment == segment) then
				return gump:Fade(instance, _fadeType, _fadeSpeed, "bars")
			end
		else
			return gump:Fade(instance, _fadeType, _fadeSpeed, "bars")
		end
	end

	-- reopens all as instances
	function _details:ReopenAllInstances(temp)
		for index = math.min(#_details.table_instances, _details.instances_amount), 1, -1 do 
			local instance = _details:GetInstance(index)
			instance:EnableInstance(temp)
		end
	end
	
	function _details:LockInstance(flag)
		
		if (type(flag) == "boolean") then
			self.isLocked = not flag
		end
	
		if (self.isLocked) then
			self.isLocked = false
			if (self.baseframe) then
				self.baseframe.isLocked = false
				self.baseframe.lock_button.label:SetText(Loc["STRING_LOCK_WINDOW"])
				self.baseframe.lock_button:SetWidth(self.baseframe.lock_button.label:GetStringWidth()+2)
				self.baseframe.resize_right:SetAlpha(0)
				self.baseframe.resize_left:SetAlpha(0)
				self.baseframe.lock_button:ClearAllPoints()
				self.baseframe.lock_button:SetPoint("right", self.baseframe.resize_right, "left", -1, 1.5)
			end
		else
			self.isLocked = true
			if (self.baseframe) then
				self.baseframe.isLocked = true
				self.baseframe.lock_button.label:SetText(Loc["STRING_UNLOCK_WINDOW"])
				self.baseframe.lock_button:SetWidth(self.baseframe.lock_button.label:GetStringWidth()+2)
				self.baseframe.lock_button:ClearAllPoints()
				self.baseframe.lock_button:SetPoint("bottomright", self.baseframe, "bottomright", -3, 0)
				self.baseframe.resize_right:SetAlpha(0)
				self.baseframe.resize_left:SetAlpha(0)
			end
		end
	end
	
	function _details:LockInstances()
		for index, instance in ipairs(_details.table_instances) do 
			instance:LockInstance(true)
		end
	end
	
	function _details:UnlockInstances()
		for index, instance in ipairs(_details.table_instances) do 
			instance:LockInstance(false)
		end
	end

--> oposto do desactiver, ela apenas volta a mostrar a window

	--> alias
	function _details:EnableInstance(temp)
		return self:EnableInstance(temp)
	end
	
	function _details:EnableInstance(temp)
	
		self.active = true
		local lower = _details:GetLowerInstanceNumber()
		
		if (lower == self.mine_id) then
			--> os icons dos plugins precisam ser hostiados nessa instance.
			_details.ToolBar:ReorganizeIcons(true) --> não precisa recarregar toda a skin
		end
		
		if (not self.initiated) then
			self:RestoreWindow(self.mine_id)
		else
			_details.opened_windows = _details.opened_windows+1
		end

		_details:SwitchTable(self, nil, nil, nil, true)
		
		--gump:Fade(self.baseframe.header.attribute_icon, _unpack(_details.windows_fade_out))
		--gump:Fade(self.baseframe.header.ball, _unpack(_details.windows_fade_out))
		--gump:Fade(self.baseframe, _unpack(_details.windows_fade_out))

		if (self.hide_icon) then
			gump:Fade(self.baseframe.header.attribute_icon, 1)
		else
			gump:Fade(self.baseframe.header.attribute_icon, 0)
		end
		
		gump:Fade(self.baseframe.header.ball, 0)
		gump:Fade(self.baseframe, 0)
		gump:Fade(self.rowframe, 0)
		
		self:SetMenuAlpha()
		
		self.baseframe.header.close:Enable()
		
		self:ChangeIcon()

		if (not temp) then
			if (self.mode == mode_raid) then
				_details.RaidTables:EnableRaidMode(self)
				
			elseif (self.mode == mode_alone) then
				self:SoloMode(true)
			end
		end
		
		self:SetCombatAlpha(nil, nil, true)
		
		--if (self.hide_out_of_combat and not UnitAffectingCombat("player")) then
		--	self:SetWindowAlphaForCombat(true, true)
		--end
		
		if (not temp and not _details.initializing) then
			_details:SendEvent("DETAILS_INSTANCE_OPEN", nil, self)
		end
	end
------------------------------------------------------------------------------------------------------------------------

--> apaga de vez um instância
	function _details:DeleteInstance2(ID)
		return _table_remove(_details.table_instances, ID)
	end
------------------------------------------------------------------------------------------------------------------------

--> retorna quantas instância há no momento
	function _details:GetNumInstancesAmount()
		return #_details.table_instances
	end
	function _details:NumberOfInstances()
		return #_details.table_instances
	end
------------------------------------------------------------------------------------------------------------------------

	function _details:DeleteInstance(id)

		local instance = _details:GetInstance(id)
		
		if (not instance) then
			return false
		end

		--> break snaps of previous and next window
		local left_instance = _details:GetInstance(id-1)
		if (left_instance) then
			for snap_side, instance_id in _pairs(left_instance.snap) do
				if (instance_id == id) then --snap na proxima instance
					left_instance.snap[snap_side] = nil
				end
			end
		end
		local right_instance = _details:GetInstance(id+1)
		if (right_instance) then
			for snap_side, instance_id in _pairs(right_instance.snap) do
				if (instance_id == id) then --snap na proxima instance
					right_instance.snap[snap_side] = nil
				end
			end
		end
		
		--> re align snaps for higher instances
		for i = id+1, #_details.table_instances do
			local this_instance = _details:GetInstance(i)
			--fix the snaps
			for snap_side, instance_id in _pairs(this_instance.snap) do
				if (instance_id == i+1) then --snap na proxima instance
					this_instance.snap[snap_side] = i
				elseif (instance_id == i-1 and i-2 > 0) then --snap na instance previous
					this_instance.snap[snap_side] = i-2
				else
					this_instance.snap[snap_side] = nil
				end
			end
		end
		
		table.remove(_details.table_instances, id)

	end


------------------------------------------------------------------------------------------------------------------------
--> cria uma new instância e a joga para o container de instâncias

	function _details:CreateInstance(id)
		return _details:Createinstance(_, id)
	end

	function _details:Createinstance(_, id)
		
		if (id and _type(id) == "boolean") then
			
			if (#_details.table_instances >= _details.instances_amount) then
				_details:Msg(Loc["STRING_INSTANCE_LIMIT"])
				return false
			end
			
			local next_id = #_details.table_instances+1
			
			if (_details.unused_instances[next_id]) then
				local new_instance = _details.unused_instances[next_id]
				_details.table_instances[next_id] = new_instance
				_details.unused_instances[next_id] = nil
				new_instance:EnableInstance()
				return new_instance
			end
			
			local new_instance = _details:Newinstance(next_id)
			
			if (_details.standard_skin) then
				for key, value in pairs(_details.standard_skin) do
					if (type(value) == "table") then
						new_instance[key] = table_deepcopy(value)
					else
						new_instance[key] = value
					end
				end
				new_instance:ChangeSkin()
			end
			
			return new_instance
			
		elseif (id) then
			local instance = _details.table_instances[id]
			if (instance and not instance:IsActive()) then
				instance:EnableInstance()
				_details:DelayOptionsRefresh(instance)
				return
			end
		end
	
		--> antes de create uma new, ver se não há alguma para reactiver
		for index, instance in _ipairs(_details.table_instances) do
			if (not instance:IsActive()) then
				instance:EnableInstance()
				return
			end
		end
		
		if (#_details.table_instances >= _details.instances_amount) then
			return _details:Msg(Loc["STRING_INSTANCE_LIMIT"])
		end
		
		local new_instance = _details:Newinstance(#_details.table_instances+1)
		
		if (not _details.initializing) then
			_details:SendEvent("DETAILS_INSTANCE_OPEN", nil, new_instance)
		end
		
		_details:GetLowerInstanceNumber()
		
		return new_instance
	end
------------------------------------------------------------------------------------------------------------------------

--> self é a instância que this sendo movida.. instance é a que this parada
function _details:ThisGrouped(this_instance, side) --> side //// 1 = encostou na left // 2 = escostou emaixo // 3 = encostou na right // 4 = encostou em cima
	--local mine_snap = self.snap --> pegou a table com {side, side, side, side}
	
	if (this_instance.snap[side]) then
		return true --> ha possui uma window grudapa nthis side
	elseif (side == 1) then
		if (self.snap[3]) then
			return true
		end
	elseif (side == 2) then
		if (self.snap[4]) then
			return true
		end
	elseif (side == 3) then
		if (self.snap[1]) then
			return true
		end
	elseif (side == 4) then
		if (self.snap[2]) then
			return true
		end
	end

	return false --> do contrário retorna false
end

function _details:BaseFrameSnap()
	for mine_id, instance in _ipairs(_details.table_instances) do
		if (instance:IsActive()) then
			instance.baseframe:ClearAllPoints()
		end
	end
	
	local group = self:GetInstanceGroup()
	local scale = self.window_scale
	for _, instance in _ipairs(group) do
		instance:SetWindowScale(scale)
	end
	
	local my_baseframe = self.baseframe
	for side, snap_to in _pairs(self.snap) do
		--print("DEBUG instance " .. snap_to .. " side "..side)
		local instance_dst = _details.table_instances[snap_to]

		if (side == 1) then --> a left
			instance_dst.baseframe:SetPoint("TOPRIGHT", my_baseframe, "TOPLEFT")
			
		elseif (side == 2) then --> em baixo
			local statusbar_y_mod = 0
			if (not self.show_statusbar) then
				statusbar_y_mod = 14
			end
			instance_dst.baseframe:SetPoint("TOPLEFT", my_baseframe, "BOTTOMLEFT", 0, -34 + statusbar_y_mod)
			
		elseif (side == 3) then --> a right
			instance_dst.baseframe:SetPoint("BOTTOMLEFT", my_baseframe, "BOTTOMRIGHT")
			
		elseif (side == 4) then --> em cima
			local statusbar_y_mod = 0
			if (not instance_dst.show_statusbar) then
				statusbar_y_mod = -14
			end
			instance_dst.baseframe:SetPoint("BOTTOMLEFT", my_baseframe, "TOPLEFT", 0, 34 + statusbar_y_mod)

		end
	end

	--[
	--> aqui precisa de um efeito reverse
	local reverse = self.mine_id - 2 --> se existir 
	if (reverse > 0) then --> se tiver uma instância lá trás
		--> aqui faz o efeito reverse:
		local start_retro = self.mine_id - 1
		for mine_id = start_retro, 1, -1 do
			local instance = _details.table_instances[mine_id]
			for side, snap_to in _pairs(instance.snap) do
				if (snap_to < instance.mine_id and snap_to ~= self.mine_id) then --> se o side que this grudado for menor que o mine id... EX instnacia #2 grudada na #1
				
					--> então tenho que pegar a instância do snap

					local instance_dst = _details.table_instances[snap_to]
					local side_reverse
					if (side == 1) then
						side_reverse = 3
					elseif (side == 2) then
						side_reverse = 4
					elseif (side == 3) then
						side_reverse = 1
					elseif (side == 4) then
						side_reverse = 2
					end

					--> do os setpoints
					if (side_reverse == 1) then --> a left
						instance_dst.baseframe:SetPoint("BOTTOMLEFT", instance.baseframe, "BOTTOMRIGHT")
						
					elseif (side_reverse == 2) then --> em baixo
					
						local statusbar_y_mod = 0
						if (not instance_dst.show_statusbar) then
							statusbar_y_mod = -14
						end
						
						instance_dst.baseframe:SetPoint("BOTTOMLEFT", instance.baseframe, "TOPLEFT", 0, 34 + statusbar_y_mod) -- +(statusbar_y_mod*-1)
						
					elseif (side_reverse == 3) then --> a right
						instance_dst.baseframe:SetPoint("TOPRIGHT", instance.baseframe, "TOPLEFT")
						
					elseif (side_reverse == 4) then --> em cima
					
						local statusbar_y_mod = 0
						if (not instance.show_statusbar) then
							statusbar_y_mod = 14
						end
					
						instance_dst.baseframe:SetPoint("TOPLEFT", instance.baseframe, "BOTTOMLEFT", 0, -34 + statusbar_y_mod)
						
					end
				end
			end
		end
	end
	--]]
	
	for mine_id, instance in _ipairs(_details.table_instances) do
		if (mine_id > self.mine_id) then
			for side, snap_to in _pairs(instance.snap) do
				if (snap_to > instance.mine_id and snap_to ~= self.mine_id) then
					local instance_dst = _details.table_instances[snap_to]
					
					if (side == 1) then --> a left
						instance_dst.baseframe:SetPoint("TOPRIGHT", instance.baseframe, "TOPLEFT")
						
					elseif (side == 2) then --> em baixo
						local statusbar_y_mod = 0
						if (not instance.show_statusbar) then
							statusbar_y_mod = 14
						end
						instance_dst.baseframe:SetPoint("TOPLEFT", instance.baseframe, "BOTTOMLEFT", 0, -34 + statusbar_y_mod)
						
					elseif (side == 3) then --> a right
						instance_dst.baseframe:SetPoint("BOTTOMLEFT", instance.baseframe, "BOTTOMRIGHT")
						
					elseif (side == 4) then --> em cima
					
						local statusbar_y_mod = 0
						if (not instance_dst.show_statusbar) then
							statusbar_y_mod = -14
						end
					
						instance_dst.baseframe:SetPoint("BOTTOMLEFT", instance.baseframe, "TOPLEFT", 0, 34 + statusbar_y_mod)
						
					end
				end
			end
		end
	end
end

function _details:agrupar_windows(sides)

	local instance = self

	for side, this_instance in _pairs(sides) do
		if (this_instance) then
			instance.baseframe:ClearAllPoints()
			this_instance = _details.table_instances[this_instance]
			
			instance:SetWindowScale(this_instance.window_scale)
			
			if (side == 3) then --> right
				--> mover frame
				instance.baseframe:SetPoint("TOPRIGHT", this_instance.baseframe, "TOPLEFT")
				instance.baseframe:SetPoint("RIGHT", this_instance.baseframe, "LEFT")
				instance.baseframe:SetPoint("BOTTOMRIGHT", this_instance.baseframe, "BOTTOMLEFT")
				
				local _, height = this_instance:GetSize()
				instance:SetSize(nil, height)
				
				--> salva o snap
				self.snap[3] = this_instance.mine_id
				this_instance.snap[1] = self.mine_id
				
			elseif (side == 4) then --> cima
				--> mover frame
				
				local statusbar_y_mod = 0
				if (not this_instance.show_statusbar) then
					statusbar_y_mod = 14
				end
				
				instance.baseframe:SetPoint("TOPLEFT", this_instance.baseframe, "BOTTOMLEFT", 0, -34 + statusbar_y_mod)
				instance.baseframe:SetPoint("TOP", this_instance.baseframe, "BOTTOM", 0, -34 + statusbar_y_mod)
				instance.baseframe:SetPoint("TOPRIGHT", this_instance.baseframe, "BOTTOMRIGHT", 0, -34 + statusbar_y_mod)
				
				local _, height = this_instance:GetSize()
				instance:SetSize(nil, height)
				
				--> salva o snap
				self.snap[4] = this_instance.mine_id
				this_instance.snap[2] = self.mine_id
				
				--this_instance.baseframe.rodape.StatusBarLeftAnchor:SetPoint("left", this_instance.baseframe.rodape.top_bg, "left", 25, 58)
				--this_instance.baseframe.rodape.StatusBarCenterAnchor:SetPoint("center", this_instance.baseframe.rodape.top_bg, "center", 20, 58)
				--this_instance.baseframe.rodape.left:SetTexture("Interface\\AddOns\\Details\\images\\bar_down_left_snap")
				--this_instance.baseframe.rodape.left.have_snap = true

			elseif (side == 1) then --> left
				--> mover frame
				instance.baseframe:SetPoint("TOPLEFT", this_instance.baseframe, "TOPRIGHT")
				instance.baseframe:SetPoint("LEFT", this_instance.baseframe, "RIGHT")
				instance.baseframe:SetPoint("BOTTOMLEFT", this_instance.baseframe, "BOTTOMRIGHT")
				
				local _, height = this_instance:GetSize()
				instance:SetSize(nil, height)
				
				--> salva o snap
				self.snap[1] = this_instance.mine_id
				this_instance.snap[3] = self.mine_id
				
			elseif (side == 2) then --> baixo
				--> mover frame
				
				local statusbar_y_mod = 0
				if (not instance.show_statusbar) then
					statusbar_y_mod = -14
				end
				
				instance.baseframe:SetPoint("BOTTOMLEFT", this_instance.baseframe, "TOPLEFT", 0, 34 + statusbar_y_mod)
				instance.baseframe:SetPoint("BOTTOM", this_instance.baseframe, "TOP", 0, 34 + statusbar_y_mod)
				instance.baseframe:SetPoint("BOTTOMRIGHT", this_instance.baseframe, "TOPRIGHT", 0, 34 + statusbar_y_mod)
				
				local _, height = this_instance:GetSize()
				instance:SetSize(nil, height)
				
				--> salva o snap
				self.snap[2] = this_instance.mine_id
				this_instance.snap[4] = self.mine_id
				
				--self.baseframe.rodape.StatusBarLeftAnchor:SetPoint("left", self.baseframe.rodape.top_bg, "left", 25, 58)
				--self.baseframe.rodape.StatusBarCenterAnchor:SetPoint("center", self.baseframe.rodape.top_bg, "center", 20, 58)
				--self.baseframe.rodape.left:SetTexture([[Interface\AddOns\Details\images\bar_down_left_snap]])
				--self.baseframe.rodape.left.have_snap = true
			end
			
			if (not this_instance.active) then
				this_instance:EnableInstance()
			end
			
		end
	end
	
	instance.break_snap_button:SetAlpha(1)
	
	if (_details.tutorial.unlock_button < 4) then
	
		_details.temp_table1.IconSize = 32
		_details.temp_table1.TextHeightMod = -6
		_details.popup:ShowMe(instance.break_snap_button, "tooltip", "Interface\\AddOns\\Details\\images\\LockButton-Unlocked-Up", Loc["STRING_UNLOCK"], 150, _details.temp_table1)
		
		--UIFrameFlash(instance.break_snap_button, .5, .5, 5, false, 0, 0)
		_details.tutorial.unlock_button = _details.tutorial.unlock_button + 1
	end
	
	_details:DelayOptionsRefresh()
	
end

function _details:UngroupInstance()
	return self:Ungroup(-1)
end

function _details:Ungroup(instance, side)

	if (self.mine_id) then --> significa que self é uma instance
		side = instance
		instance = self
	end
	
	if (_type(instance) == "number") then --> significa que passou o número da instância
		instance =  _details.table_instances[instance]
	end
	
	_details:DelayOptionsRefresh(nil, true)
	
	if (not side) then
		--print("DEBUG: Ungroup this sem side")
		return
	end
	
	if (side < 0) then --> clicou no botão para desagrupar tudo
		local ID = instance.mine_id
		
		for id, this_instance in _ipairs(_details.table_instances) do 
			for index, iid in _pairs(this_instance.snap) do -- index = 1 left , 3 right, 2 bottom, 4 top
				if (iid and(iid == ID or id == ID)) then -- iid = instance.mine_id
				
					this_instance.snap[index] = nil
					
					if (instance.verticalSnap or this_instance.verticalSnap) then
						if (not this_instance.snap[2] and not this_instance.snap[4]) then
							this_instance.verticalSnap = false
							this_instance.horizontalSnap = false
						end
					elseif (instance.horizontalSnap or this_instance.horizontalSnap) then
						if (not this_instance.snap[1] and not this_instance.snap[3]) then
							this_instance.horizontalSnap = false
							this_instance.verticalSnap = false
						end
					end
					
					if (index == 2) then  -- index é o codigo do snap
						--this_instance.baseframe.rodape.StatusBarLeftAnchor:SetPoint("left", this_instance.baseframe.rodape.top_bg, "left", 5, 58)
						--this_instance.baseframe.rodape.StatusBarCenterAnchor:SetPoint("center", this_instance.baseframe.rodape.top_bg, "center", 0, 58)
						--this_instance.baseframe.rodape.left:SetTexture("Interface\\AddOns\\Details\\images\\bar_down_left")
						--this_instance.baseframe.rodape.left.have_snap = nil
					end
					
				end
			end
		end
		
		instance.break_snap_button:SetAlpha(0)
		
		instance.verticalSnap = false
		instance.horizontalSnap = false
		return
	end
	
	local this_instance = _details.table_instances[instance.snap[side]]
	
	if (not this_instance) then
		--print("DEBUG: Erro, a instance nao existe")
		return
	end
	
	instance.snap[side] = nil
	
	if (side == 1) then
		this_instance.snap[3] = nil
	elseif (side == 2) then
		this_instance.snap[4] = nil
	elseif (side == 3) then
		this_instance.snap[1] = nil
	elseif (side == 4) then
		this_instance.snap[2] = nil
	end

	instance.break_snap_button:SetAlpha(0)
	
	
	if (instance.initiated) then
		instance:SaveMainWindowPosition()
		instance:RestoreMainWindowPosition()
	end
	
	if (this_instance.initiated) then
		this_instance:SaveMainWindowPosition()
		this_instance:RestoreMainWindowPosition()	
	end
	
	--print("DEBUG: Details: instances desagrupadas")
	
	--_details:RefreshAgrupamentos()
	
end
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


function _details:SnapTextures(remove)
	for id, this_instance in _ipairs(_details.table_instances) do 
		if (this_instance:IsActive()) then
			if (this_instance.baseframe.rodape.left.have_snap) then
				if (remove) then
					--this_instance.baseframe.rodape.left:SetTexture("Interface\\AddOns\\Details\\images\\bar_down_left")
				else
					--this_instance.baseframe.rodape.left:SetTexture("Interface\\AddOns\\Details\\images\\bar_down_left_snap")
				end
			end
		end
	end
end

--> cria uma window para uma new instância
	--> search key: ~new ~new
	function _details:CreateDisabledInstance(ID, skin_table)
	
	--> first check if we can recycle a old instance
		if (_details.unused_instances[ID]) then
			local new_instance = _details.unused_instances[ID]
			_details.table_instances[ID] = new_instance
			_details.unused_instances[ID] = nil
			--> replace the values on recycled instance
				new_instance:ResetInstanceConfig()
			
			--> copy values from a previous skin saved
				if (skin_table) then
					--> copy from skin_table to new_instance
					_details.table.copy(new_instance, skin_table)
				end
			
			return new_instance
		end
	
	--> must create a new one
		local new_instance = {
			--> instance id
				mine_id = ID,
			--> internal stuff
				bars = {}, --container que irá armazenar todas as bars
				barS = {nil, nil}, --de x até x são as bars que estão sendo mostradas na tela
				scrolling = false, --bar de scrolling não this sendo mostrada
				width_scroll = 26,
				bar_mod = 0,
				bgdisplay_loc = 0,		
				
			--> displaying row info
				rows_created = 0,
				rows_showing = 0,
				rows_max = 50,

			--> saved pos for normal mode and lone wolf mode
				position = {
					["normal"] = {x = 1, y = 2, w = 300, h = 200},
					["solo"] = {x = 1, y = 2, w = 300, h = 200}
				},
				
			--> save information about window snaps
				snap = {},
			
			--> current state starts as normal
				displaying = "normal",
			--> menu consolidated
				consolidate = false, --deprecated
				icons = {true, true, true, true},
				
			--> status bar stuff
				StatusBar = {options = {}},

			--> more stuff
				attribute = 1, --> damage 
				sub_attribute = 1, --> damage done
				sub_attribute_last = {1, 1, 1, 1, 1},
				segment = 0, --> combat atual
				mode = mode_group,
				last_mode = mode_group,
				LastMode = mode_group,
		}
		
		_setmetatable(new_instance, _details)
		_details.table_instances[#_details.table_instances+1] = new_instance

		--> fill the empty instance with default values
			new_instance:ResetInstanceConfig()
		
		--> copy values from a previous skin saved
			if (skin_table) then
				--> copy from skin_table to new_instance
				_details.table.copy(new_instance, skin_table)
			end
			
		--> setup default wallpaper
			local id, name, icon, _background, role = UniqueGetTalentSpecInfo()
			if (_background) then
				local bg = "Interface\\TALENTFRAME\\" .. _background
				if (new_instance.wallpaper) then
					new_instance.wallpaper.texture = bg
					new_instance.wallpaper.texcoord = {0, 1, 0, 0.703125}
				end
			end
		
		--> finish
			return new_instance
	end
	
	function _details:Newinstance(ID)

		local new_instance = {}
		_setmetatable(new_instance, _details)
		_details.table_instances[#_details.table_instances+1] = new_instance
		
		--> instance number
			new_instance.mine_id = ID
		
		--> setup all config
			new_instance:ResetInstanceConfig()
			--> setup default wallpaper
			local id, name, icon, _, _background = UniqueGetTalentSpecInfo()
			if (_background) then
				local bg = "Interface\\TALENTFRAME\\" .. _background
				if (new_instance.wallpaper) then
					new_instance.wallpaper.texture = bg
					new_instance.wallpaper.texcoord = {0, 1, 0, 0.703125}
				end
			end

		--> internal stuff
			new_instance.bars = {} --container que irá armazenar todas as bars
			new_instance.barS = {nil, nil} --de x até x são as bars que estão sendo mostradas na tela
			new_instance.scrolling = false --bar de scrolling não this sendo mostrada
			new_instance.width_scroll = 26
			new_instance.bar_mod = 0
			new_instance.bgdisplay_loc = 0
		
		--> displaying row info
			new_instance.rows_created = 0
			new_instance.rows_showing = 0
			new_instance.rows_max = 50
			new_instance.rows_fit_in_window = nil
		
		--> saved pos for normal mode and lone wolf mode
			new_instance.position = {
				["normal"] = {x = 1, y = 2, w = 300, h = 200},
				["solo"] = {x = 1, y = 2, w = 300, h = 200}
			}		
		--> save information about window snaps
			new_instance.snap = {}
		
		--> current state starts as normal
			new_instance.displaying = "normal"
		--> menu consolidated
			new_instance.consolidate = false
			new_instance.icons = {true, true, true, true}

		--> create window frames
		
			local _baseframe, _bgframe, _bgframe_display, _scrollframe = gump:CreateWindowMain(ID, new_instance, true)
			new_instance.baseframe = _baseframe
			new_instance.bgframe = _bgframe
			new_instance.bgdisplay = _bgframe_display
			new_instance.scroll = _scrollframe

		--> status bar stuff
			new_instance.StatusBar = {}
			new_instance.StatusBar.left = nil
			new_instance.StatusBar.center = nil
			new_instance.StatusBar.right = nil
			new_instance.StatusBar.options = {}

			local clock = _details.StatusBar:CreateStatusBarChildForInstance(new_instance, "DETAILS_STATUSBAR_PLUGIN_CLOCK")
			_details.StatusBar:SetCenterPlugin(new_instance, clock)
			
			local segment = _details.StatusBar:CreateStatusBarChildForInstance(new_instance, "DETAILS_STATUSBAR_PLUGIN_PSEGMENT")
			_details.StatusBar:SetLeftPlugin(new_instance, segment)
			
			local dps = _details.StatusBar:CreateStatusBarChildForInstance(new_instance, "DETAILS_STATUSBAR_PLUGIN_PDPS")
			_details.StatusBar:SetRightPlugin(new_instance, dps)

		--> internal stuff
			new_instance.oldHeight = _baseframe:GetHeight()
			new_instance.attribute = 1 --> damage 
			new_instance.sub_attribute = 1 --> damage done
			new_instance.sub_attribute_last = {1, 1, 1, 1, 1}
			new_instance.segment = -1 --> combat atual
			new_instance.mode = mode_group
			new_instance.last_mode = mode_group
			new_instance.LastMode = mode_group
			
		--> change the attribute
			_details:SwitchTable(new_instance, 0, 1, 1)
			
		--> internal stuff
			new_instance.row_height = new_instance.row_info.height + new_instance.row_info.space.between
			
			new_instance.oldwith = new_instance.baseframe:GetWidth()
			new_instance.initiated = true
			new_instance:SaveMainWindowPosition()
			new_instance:ReadjustGump()
			
			new_instance.rows_fit_in_window = _math_floor(new_instance.position[new_instance.displaying].h / new_instance.row_height)
		
		--> all done
			new_instance:EnableInstance()
			
		new_instance:ShowSideBars()

		new_instance.skin = "no skin"
		new_instance:ChangeSkin("Minimalistic v2")
		
		--> apply standard skin if have one saved
		--[[
			if (_details.standard_skin) then

				local style = _details.standard_skin
				local instance = new_instance
				local skin = style.skin
				
				instance.skin = ""
				instance:ChangeSkin(skin)
				
				--> overwrite all instance parameters with saved ones
				for key, value in pairs(style) do
					if (key ~= "skin") then
						if (type(value) == "table") then
							instance[key] = table_deepcopy(value)
						else
							instance[key] = value
						end
					end
				end

			end
		--]]
		
		--> apply all changed attributes
		--new_instance:ChangeSkin()
		
		return new_instance
	end
------------------------------------------------------------------------------------------------------------------------

	function _details:FixToolbarMenu(instance)
		--print("fixing...", instance.mine_id)
		--instance:ToolbarMenuButtons()
	end

--> ao reinitialize o addon this função é rodada para recreate a window da instância
--> search key: ~restore ~start ~start
function _details:RestoreWindow(index, temp, load_only)
		
	--> load
		self:LoadInstanceConfig()
		
	--> reset internal stuff
		self.sub_attribute_last = self.sub_attribute_last or {1, 1, 1, 1, 1}
		self.scrolling = false
		self.need_scrolling = false
		self.bars = {}
		self.barS = {nil, nil}
		self.rows_fit_in_window = nil
		self.consolidate = self.consolidate or false
		self.icons = self.icons or {true, true, true, true}
		self.rows_created = 0
		self.rows_showing = 0
		self.rows_max = 50
		self.rows_fit_in_window = nil
		self.width_scroll = 26
		self.bar_mod = 0
		self.bgdisplay_loc = 0
		self.last_mode = self.last_mode or mode_group

		self.row_height = self.row_info.height + self.row_info.space.between
		
	--> create frames
		local _baseframe, _bgframe, _bgframe_display, _scrollframe = gump:CreateWindowMain(self.mine_id, self)
		self.baseframe = _baseframe
		self.bgframe = _bgframe
		self.bgdisplay = _bgframe_display
		self.scroll = _scrollframe		
		_baseframe:EnableMouseWheel(false)
		self.oldHeight = _baseframe:GetHeight()
		
	--> change the attribute
		_details:SwitchTable(self, self.segment, self.attribute, self.sub_attribute, true) --> passando true no 5º valor para a função ignore a checagem de valores iguais
	
	--> set wallpaper
		if (self.wallpaper.enabled) then
			self:InstanceWallpaper(true)
		end
		
	--> set the color of this instance window
		self:InstanceColor(self.color)
		
	--> scrollbar
		self:HideScrollBar(true)
	
	--> check snaps
		self.snap = self.snap or {}

	--> status bar stuff
		self.StatusBar = {}
		self.StatusBar.left = nil
		self.StatusBar.center = nil
		self.StatusBar.right = nil
		self.StatusBarSaved = self.StatusBarSaved or {options = {}}
		self.StatusBar.options = self.StatusBarSaved.options

		if (self.StatusBarSaved.center and self.StatusBarSaved.center == "NONE") then
			self.StatusBarSaved.center = "DETAILS_STATUSBAR_PLUGIN_CLOCK"
		end
		local clock = _details.StatusBar:CreateStatusBarChildForInstance(self, self.StatusBarSaved.center or "DETAILS_STATUSBAR_PLUGIN_CLOCK")
		_details.StatusBar:SetCenterPlugin(self, clock, true)
		
		if (self.StatusBarSaved.left and self.StatusBarSaved.left == "NONE") then
			self.StatusBarSaved.left = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT"
		end
		local segment = _details.StatusBar:CreateStatusBarChildForInstance(self, self.StatusBarSaved.left or "DETAILS_STATUSBAR_PLUGIN_PSEGMENT")
		_details.StatusBar:SetLeftPlugin(self, segment, true)
		
		if (self.StatusBarSaved.right and self.StatusBarSaved.right == "NONE") then
			self.StatusBarSaved.right = "DETAILS_STATUSBAR_PLUGIN_PDPS"
		end
		local dps = _details.StatusBar:CreateStatusBarChildForInstance(self, self.StatusBarSaved.right or "DETAILS_STATUSBAR_PLUGIN_PDPS")
		_details.StatusBar:SetRightPlugin(self, dps, true)

	--> load mode

		if (self.mode == mode_alone) then
			if (_details.solo and _details.solo ~= self.mine_id) then --> proteção para ter apenas uma instância com a window SOLO
				self.mode = mode_group
				self.displaying = "normal"
			else
				self:SoloMode(true)
				_details.solo = self.mine_id
			end
		elseif (self.mode == mode_raid) then
			_details.raid = self.mine_id
		else
			self.displaying = "normal"
		end

	--> internal stuff
		self.oldwith = self.baseframe:GetWidth()
		self:RestoreMainWindowPosition()
		self:ReadjustGump()
		self:SaveMainWindowPosition()
		
		if (not load_only) then
			self.initiated = true
			self:EnableInstance(temp)
			self:ChangeSkin()
		end
		
	--> all done
	return
end

function _details:SwitchBack()
	local prev_switch = self.auto_switch_to_old
	
	if (prev_switch) then
		if (self.mode ~= prev_switch[1]) then
			_details:ChangeMode(self, prev_switch[1])
		end
		
		if (self.mode == _details._details_props["MODE_RAID"]) then
			_details.RaidTables:switch(nil, prev_switch[5], self)
			
		elseif (self.mode == _details._details_props["MODE_ALONE"]) then
			_details.SoloTables:switch(nil, prev_switch[6])
			
		else
			_details:SwitchTable(self, prev_switch[4], prev_switch[2], prev_switch[3])
		end
		
		self.auto_switch_to_old = nil
	end
end

function _details:SwitchTo(switch_table, nosave)
	if (not nosave) then
		self.auto_switch_to_old = {self.mode, self.attribute, self.sub_attribute, self.segment, self:GetRaidPluginName(), _details.SoloTables.Mode}
	end

	if (switch_table[1] == "raid") then
		_details.RaidTables:EnableRaidMode(self, switch_table[2])
	else
		--muda para um attribute normal
		if (self.mode ~= _details._details_props["MODE_GROUP"]) then
			_details:ChangeMode(self, _details._details_props["MODE_GROUP"])
		end
		_details:SwitchTable(self, nil, switch_table[1], switch_table[2])
	end
end

--backtable indexes:[1]: mode[2]: attribute[3]: sub attribute[4]: segment[5]: raidmode index[6]: solomode index
function _details:CheckSwitchOnCombatEnd(nowipe, warning)

	self:SwitchBack()
	
	local role = _UnitGroupRolesAssigned("player")
	
	local got_switch = false
	
	if (role == "DAMAGER" and self.switch_damager) then
		self:SwitchTo(self.switch_damager)
		got_switch = true
		
	elseif (role == "HEALER" and self.switch_healer) then
		self:SwitchTo(self.switch_healer)
		got_switch = true
		
	elseif (role == "TANK" and self.switch_tank) then
		self:SwitchTo(self.switch_tank, true)
		got_switch = true
		
	elseif (role == "NONE" and _details.last_assigned_role ~= "NONE") then
		self:SwitchBack()
		got_switch = true
		
	end
	
	if (warning and got_switch) then
		local attribute_name = self:GetInstanceAttributeText()
		self:InstanceAlert(string.format(Loc["STRING_SWITCH_WARNING"], attribute_name), {[[Interface\AddOns\Details\images\sword]], 18, 18, false}, 4)
	end
	
	if (self.switch_all_roles_after_wipe and not nowipe) then
		if (_details.table_current.is_boss and _details.table_current.instance_type == "raid" and not _details.table_current.is_boss.killed and _details.table_current.is_boss.name) then
			self:SwitchBack()
			self:SwitchTo(self.switch_all_roles_after_wipe)
		end
	end
	
end

function _details:CheckSwitchOnLogon(warning)
	for index, instance in ipairs(_details.table_instances) do 
		if (instance.active) then
			instance:CheckSwitchOnCombatEnd(true, warning)
		end
	end
end

function _details:CheckSegmentForSwitchOnCombatStart()
	
end

function _details:CheckSwitchOnCombatStart(check_segment)

	self:SwitchBack()

	local all_roles = self.switch_all_roles_in_combat
	
	local role = _UnitGroupRolesAssigned("player")
	local got_switch = false
	
	if (role == "DAMAGER" and self.switch_damager_in_combat) then
		self:SwitchTo(self.switch_damager_in_combat)
		got_switch = true
		
	elseif (role == "HEALER" and self.switch_healer_in_combat) then
		self:SwitchTo(self.switch_healer_in_combat)
		got_switch = true
		
	elseif (role == "TANK" and self.switch_tank_in_combat) then
		self:SwitchTo(self.switch_tank_in_combat)
		got_switch = true
		
	elseif (self.switch_all_roles_in_combat) then
		self:SwitchTo(self.switch_all_roles_in_combat)
		got_switch = true
		
	end
	
	if (check_segment and got_switch) then
		if (self:GetSegment() ~= 0) then
			self:SwitchTable(0)
		end
	end
	
end

function _details:ExportSkin()

	--create the table
	local exported = {
		version = _details.preset_version --skin version
	}

	--export the keys
	for key, value in pairs(self) do
		if (_details.instance_defaults[key] ~= nil) then	
			if (type(value) == "table") then
				exported[key] = table_deepcopy(value)
			else
				exported[key] = value
			end
		end
	end
	
	--export size and positioning
	if (_details.profile_save_pos) then
		exported.position = self.position
	else
		exported.position = nil
	end
	
	--export mini displays
	if (self.StatusBar and self.StatusBar.left) then
		exported.StatusBarSaved = {
			["left"] = self.StatusBar.left.real_name or "NONE",
			["center"] = self.StatusBar.center.real_name or "NONE",
			["right"] = self.StatusBar.right.real_name or "NONE",
		}
		exported.StatusBarSaved.options = {
			[exported.StatusBarSaved.left] = table_deepcopy(self.StatusBar.left.options),
			[exported.StatusBarSaved.center] = table_deepcopy(self.StatusBar.center.options),
			[exported.StatusBarSaved.right] = table_deepcopy(self.StatusBar.right.options)
		}

	elseif (self.StatusBarSaved) then
		exported.StatusBarSaved = table_deepcopy(self.StatusBarSaved)
		
	end

	return exported
	
end

function _details:ApplySavedSkin(style)

	if (not style.version or _details.preset_version > style.version) then
		return _details:Msg(Loc["STRING_OPTIONS_PRESETTOOLD"])
	end
	
	--> set skin preset
	local skin = style.skin
	self.skin = ""
	self:ChangeSkin(skin)
	
	-- /script print(_details.table_instances[1].baseframe:GetAlpha())

	--> overwrite all instance parameters with saved ones
	for key, value in pairs(style) do
		if (key ~= "skin") then
			if (type(value) == "table") then
				self[key] = table_deepcopy(value)
			else
				self[key] = value
			end
		end
	end
	
	--> check for new keys inside tables
	for key, value in pairs(_details.instance_defaults) do 
		if (type(value) == "table") then
			for key2, value2 in pairs(value) do 
				if (self[key][key2] == nil) then
					if (type(value2) == "table") then
						self[key][key2] = table_deepcopy(_details.instance_defaults[key][key2])
					else
						self[key][key2] = value2
					end
				end
			end
		end
	end	
	
	self.StatusBarSaved = style.StatusBarSaved and table_deepcopy(style.StatusBarSaved) or {options = {}}
	self.StatusBar.options = self.StatusBarSaved.options
	_details.StatusBar:UpdateChilds(self)
	
	--> apply all changed attributes
	self:ChangeSkin()
	
	--export size and positioning
	if (_details.profile_save_pos) then
		self.position = style.position
		self:RestoreMainWindowPosition()
	else
		self.position = table_deepcopy(self.position)
	end
	
end

------------------------------------------------------------------------------------------------------------------------

function _details:InstanceReset(instance)
	if (instance) then
		self = instance
	end
	_details.gump:Fade(self, "in", nil, "bars")
	self:UpdateSegments(self)
	self:UpdateSoloMode_AfertReset()
	self:ResetGump()
	
	if (not _details.initializing) then
		_details:UpdateGumpMain(self, true) --atualiza todas as instances
	end
end

function _details:RefreshBars(instance)
	if (instance) then
		self = instance
	end
	self:InstanceRefreshRows(instance)
end

function _details:SetBackgroundColor(...)

	local red = select(1, ...)
	if (not red) then
		self.bgdisplay:SetBackdropColor(self.bg_r, self.bg_g, self.bg_b, self.bg_alpha)
		self.baseframe:SetBackdropColor(self.bg_r, self.bg_g, self.bg_b, self.bg_alpha)
		return
	end

	local r, g, b = gump:ParseColors(...)
	self.bgdisplay:SetBackdropColor(r, g, b, self.bg_alpha or _details.default_bg_alpha)
	self.baseframe:SetBackdropColor(r, g, b, self.bg_alpha or _details.default_bg_alpha)
	self.bg_r = r
	self.bg_g = g
	self.bg_b = b
end

function _details:SetBackgroundAlpha(alpha)
	if (not alpha) then
		alpha = self.bg_alpha
--	else
--		print(alpha)
--		alpha = _details:Scale(0, 1, 0.2, 1, alpha) - 0.8
	end
	
	self.bgdisplay:SetBackdropColor(self.bg_r, self.bg_g, self.bg_b, alpha)
	self.baseframe:SetBackdropColor(self.bg_r, self.bg_g, self.bg_b, alpha)
	self.bg_alpha = alpha
end

function _details:GetSize()
	return self.baseframe:GetWidth(), self.baseframe:GetHeight()
end

function _details:GetRealSize()
	return self.baseframe:GetWidth() * self.baseframe:GetScale(), self.baseframe:GetHeight() * self.baseframe:GetScale()
end

function _details:GetPositionOnScreen()
	local xOfs, yOfs = self.baseframe:GetCenter()
	if (not xOfs) then
		return
	end
	-- credits to ckknight(http://www.curseforge.com/profiles/ckknight/) 
	local _scale = self.baseframe:GetEffectiveScale()
	local _UIscale = UIParent:GetScale()
	xOfs = xOfs*_scale - GetScreenWidth()*_UIscale/2
	yOfs = yOfs*_scale - GetScreenHeight()*_UIscale/2
	return xOfs/_UIscale, yOfs/_UIscale
end

--> alias
function _details:SetSize(w, h)
	return self:Resize(w, h)
end

function _details:Resize(w, h)
	if (w) then
		self.baseframe:SetWidth(w)
	end
	
	if (h) then
		self.baseframe:SetHeight(h)
	end
	
	self:SaveMainWindowPosition()
	
	return true
end

------------------------------------------------------------------------------------------------------------------------

function _details:HaveOneCurrentInstance()

	local have = false
	for _, instance in _ipairs(_details.table_instances) do
		if (instance.active and instance.baseframe and instance.segment == 0) then
			return
		end
	end
	
	local lower = _details:GetLowerInstanceNumber()
	if (lower) then
		local instance = _details:GetInstance(lower)
		if (instance and instance.auto_current) then
			instance:SwitchTable(0) --> muda o segment pra current
			return instance:InstanceAlert(Loc["STRING_CHANGED_TO_CURRENT"], {[[Interface\GossipFrame\TrainerGossipIcon]], 18, 18, false}, 6)
		else
			for _, instance in _ipairs(_details.table_instances) do
				if (instance.active and instance.baseframe and instance.segment ~= 0 and instance.auto_current) then
					instance:SwitchTable(0) --> muda o segment pra current
					return instance:InstanceAlert(Loc["STRING_CHANGED_TO_CURRENT"], {[[Interface\GossipFrame\TrainerGossipIcon]], 18, 18, false}, 6)
				end
			end
		end
	end
	
end

function _details:Freeze(instance)

	if (not instance) then
		instance = self
	end

	if (not _details.initializing) then
		instance:ResetGump()
		gump:Fade(instance, "in", nil, "bars")
	end
	
	instance:InstanceMsg(Loc["STRING_FREEZE"],[[Interface\CHARACTERFRAME\Disconnect-Icon]], "silver")
	
	--instance.freeze_icon:Show()
	--instance.freeze_text:Show()
	
	local width = instance:GetSize()
	instance.freeze_text:SetWidth(width-64)
	
	instance.freezed = true
end

function _details:UnFreeze(instance)

	if (not instance) then
		instance = self
	end

	self:InstanceMsg(false)
	
	--instance.freeze_icon:Hide()
	--instance.freeze_text:Hide()
	instance.freezed = false
	
	if (not _details.initializing) then
		--instance:RestoreMainWindowPosition()
		instance:ReadjustGump()
	end
end

function _details:UpdateSegments(instance)
	if (instance.initiated) then
		if (instance.segment == -1) then
			--instance.baseframe.rodape.segment:SetText(segments.overall) --> localiza-me
			instance.showing = _details.table_overall
		elseif (instance.segment == 0) then
			--instance.baseframe.rodape.segment:SetText(segments.current) --> localiza-me
			instance.showing = _details.table_current
		else
			instance.showing = _details.table_history.tables[instance.segment]
			--instance.baseframe.rodape.segment:SetText(segments.past..instance.segment) --> localiza-me
		end
	end
end

function _details:UpdateSegments_AfterCombat(instance, history)

	if (instance.freezed) then
		return --> se this congelada não tem o que do
	end

	local segment = instance.segment

	local _fadeType, _fadeSpeed = _unpack(_details.row_fade_in)
	
	if (segment == _details.segments_amount) then --> significa que o index[5] passou a ser[6] com a entrada da new table
		instance.showing = history.tables[_details.segments_amount] --> então ele volta a pegar o index[5] que antes era o index[4]

		gump:Fade(instance, _fadeType, _fadeSpeed, "bars")
		instance.showing[instance.attribute].need_refresh = true
		instance.v_bars = true
		instance:ResetGump()
		instance:UpdateGumpMain(true)
		
	elseif (segment < _details.segments_amount and segment > 0) then
		instance.showing = history.tables[segment]
		
		gump:Fade(instance, _fadeType, _fadeSpeed, "bars") --"in", nil
		instance.showing[instance.attribute].need_refresh = true
		instance.v_bars = true
		instance:ResetGump()
		instance:UpdateGumpMain(true)
	end
	
end

function _details:SetDisplay(segment, attribute, sub_attribute, starting_instance, InstanceMode)
	if (not self.mine_id) then
		return
	end
	return self:SwitchTable(segment, attribute, sub_attribute, starting_instance, InstanceMode)
end

function _details:SwitchTable(instance, segment, attribute, sub_attribute, starting_instance, InstanceMode)

	if (self and self.mine_id and not instance) then --> self é uma instância
		InstanceMode = starting_instance
		starting_instance = sub_attribute
		sub_attribute = attribute
		attribute = segment
		segment = instance
		instance = self
	end
	
	if (_type(instance) == "number") then
		sub_attribute = attribute
		attribute = segment
		segment = instance
		instance = self
	end
	
	if (InstanceMode and InstanceMode ~= instance:GetMode()) then
		instance:ChangeMode(instance, InstanceMode)
	end
	
	local update_coolTip = false
	local sub_attribute_click = false
	
	if (_type(segment) == "boolean" and segment) then --> clicou em um sub attribute
		sub_attribute_click = true
		segment = instance.segment
	
	elseif (segment == -2) then --> clicou para mudar de segment
		segment = instance.segment + 1
		
		if (segment > _details.segments_amount) then
			segment = -1
		end
		update_coolTip = true
		
	elseif (segment == -3) then --> clicou para mudar de attribute
		segment = instance.segment
		
		attribute = instance.attribute+1
		if (attribute > attributes[0]) then
			attribute = 1
		end
		update_coolTip = true
		
	elseif (segment == -4) then --> clicou para mudar de sub attribute
		segment = instance.segment
		
		sub_attribute = instance.sub_attribute+1
		if (sub_attribute > attributes[instance.attribute]) then
			sub_attribute = 1
		end
		update_coolTip = true
		
	end	
	
	--> pega os attributes dthis instance
	local current_segment = instance.segment
	local current_attribute = instance.attribute
	local current_sub_attribute = instance.sub_attribute
	
	local attribute_changed = false
	
	--> verifica se os valores passados são válidos
	if (not segment) then
		segment = instance.segment
	elseif (_type(segment) ~= "number") then
		segment = instance.segment
	end
	
	if (not attribute) then
		attribute  = instance.attribute
	elseif (_type(attribute) ~= "number") then
		attribute = instance.attribute
	end
	
	if (not sub_attribute) then
		if (attribute == current_attribute) then
			sub_attribute  = instance.sub_attribute
		else
			sub_attribute  = instance.sub_attribute_last[attribute]
		end
	elseif (_type(sub_attribute) ~= "number") then
		sub_attribute = instance.sub_attribute
	end
	
	--> já this showing isso que this pedindo
	if (not starting_instance and segment == current_segment and attribute == current_attribute and sub_attribute == current_sub_attribute and not _details.initializing) then
		return
	end

	--> Muda o segment caso necessário
	if (segment ~= current_segment or _details.initializing or starting_instance) then

		--> na troca de segment, conferir se a instance this frozen
		if (instance.freezed) then
			if (not starting_instance) then
				instance:UnFreeze()
			else
				instance.freezed = false
			end
		end
	
		instance.segment = segment
	
		if (segment == -1) then --> overall
			instance.showing = _details.table_overall
		elseif (segment == 0) then --> combat atual
			instance.showing = _details.table_current
		else --> alguma table do histórico
			instance.showing = _details.table_history.tables[segment]
		end
		
		if (update_coolTip) then
			_details.popup:Select(1, segment+2)
		end
		
		if (instance.showing and instance.showing.against) then
			--print("DEBUG: against", instance.showing.against)
		end

		_details:SendEvent("DETAILS_INSTANCE_CHANGESEGMENT", nil, instance, segment)
		
		if (_details.instances_segments_locked and not starting_instance) then
			for _, instance in ipairs(_details.table_instances) do
				if (instance.mine_id ~= instance.mine_id and instance.active) then
					if (instance.mode == 2 or instance.mode == 3) then
						--> na troca de segment, conferir se a instance this frozen
						if (instance.freezed) then
							if (not starting_instance) then
								instance:UnFreeze()
							else
								instance.freezed = false
							end
						end
						
						instance.segment = segment
					
						if (segment == -1) then --> overall
							instance.showing = _details.table_overall
						elseif (segment == 0) then --> combat atual
							instance.showing = _details.table_current
						else --> alguma table do histórico
							instance.showing = _details.table_history.tables[segment]
						end
						
						if (not instance.showing) then
							if (not starting_instance) then
								instance:Freeze()
							end
							return
						end
						
						instance.v_bars = true
						instance.showing[attribute].need_refresh = true
						
						if (not _details.initializing and not starting_instance) then
							instance:ResetGump()
							instance:UpdateGumpMain(true)
						end
						
						_details:SendEvent("DETAILS_INSTANCE_CHANGESEGMENT", nil, instance, segment)
					end
				end
			end
		end
		
	end

	--> Muda o attribute caso  necessário
	--print("DEBUG attributes", instance, segment, attribute, sub_attribute, starting_instance)

	if (attribute == 5) then
		if (#_details.custom < 1) then 
			attribute = 1
			sub_attribute = 1
		end
	end
	
	if (attribute ~= current_attribute or _details.initializing or starting_instance or(instance.mode == mode_alone or instance.mode == mode_raid)) then
	
		if (instance.mode == mode_alone and not(_details.initializing or starting_instance)) then
			if (_details.SoloTables.Mode == #_details.SoloTables.Plugins) then
				_details.popup:Select(1, 1)
			else
				if (_details.PluginCount.SOLO > 0) then
					_details.popup:Select(1, _details.SoloTables.Mode+1)
				end
			end
			return _details.SoloTables.switch(nil, nil, -1)
	
		elseif ((instance.mode == mode_raid) and not(_details.initializing or starting_instance) ) then --> raid
			return --nao faz nada quando clicar no botão
		end
		
		attribute_changed = true
		instance.attribute = attribute
		instance.sub_attribute = instance.sub_attribute_last[attribute]
		
		--> troca icon
		instance:ChangeIcon()
		
		if (update_coolTip) then
			_details.popup:Select(1, attribute)
			_details.popup:Select(2, instance.sub_attribute, attribute)
		end

		--_details:SetTutorialCVar("ATTRIBUTE_SELECT_TUTORIAL1", nil)
		if (not _details:GetTutorialCVar("ATTRIBUTE_SELECT_TUTORIAL1") and not _details.initializing and not starting_instance) then
			if (not _G["DetailsWelcomeWindow"] or not _G["DetailsWelcomeWindow"]:IsShown()) then
				_details:TutorialBookmark(instance)
			end
		end
		
		if (_details.cloud_process) then
			
			if (_details.debug) then
				_details:Msg("(debug) instance #"..instance.mine_id.." found cloud process.")
			end
			
			local attribute = instance.attribute
			local time_left =(_details.last_data_requested+7) - _details._time
			
			if (attribute == 1 and _details.in_combat and not _details:CaptureGet("damage") and _details.host_by) then
				if (_details.debug) then
					_details:Msg("(debug) instance need damage cloud.")
				end
			elseif (attribute == 2 and _details.in_combat and(not _details:CaptureGet("heal") or _details:CaptureGet("aura")) and _details.host_by) then
				if (_details.debug) then
					_details:Msg("(debug) instance need heal cloud.")
				end
			elseif (attribute == 3 and _details.in_combat and not _details:CaptureGet("energy") and _details.host_by) then
				if (_details.debug) then
					_details:Msg("(debug) instance need energy cloud.")
				end
			elseif (attribute == 4 and _details.in_combat and not _details:CaptureGet("miscdata") and _details.host_by) then
				if (_details.debug) then
					_details:Msg("(debug) instance need misc cloud.")
				end
			else
				time_left = nil
			end
			
			if (time_left) then
				if (_details.debug) then
					_details:Msg("(debug) showing instance alert.")
				end
				instance:InstanceAlert(Loc["STRING_PLEASE_WAIT"], {[[Interface\AddOns\Details\images\StreamCircle]], 22, 22, true}, time_left)
			end
		end
		
		_details:SendEvent("DETAILS_INSTANCE_CHANGEATTRIBUTE", nil, instance, attribute, sub_attribute)
		
	end

	if (sub_attribute ~= current_sub_attribute or _details.initializing or starting_instance or attribute_changed) then
		
		instance.sub_attribute = sub_attribute
		
		if (sub_attribute_click) then
			--print("aqui", instance.sub_attribute)
			instance.sub_attribute_last[instance.attribute] = instance.sub_attribute
		end
		
		if (instance.attribute == 5) then --> custom
			instance:ChangeIcon()
		end
		
		_details:SendEvent("DETAILS_INSTANCE_CHANGEATTRIBUTE", nil, instance, attribute, sub_attribute)
	end

	if (_details.window_info:IsShown() and instance == _details.window_info.instance) then	
		if (not instance.showing) then
			_details:CloseWindowInfo()
		else
			local actor = instance.showing(instance.attribute, _details.window_info.player.name)
			if (actor) then
				instance:OpenWindowInfo(actor, true)
			else
				_details:CloseWindowInfo()
			end
		end
		--_details:CloseWindowInfo()
	end
	
	if (not instance.showing) then
		if (not starting_instance) then
			instance:Freeze()
		end
		return
	else
		--> verificar relogio, precisaria dar refresh no plugin clock
	end
	
	instance.v_bars = true
	
	instance.showing[attribute].need_refresh = true
	
	if (not _details.initializing and not starting_instance) then
		instance:ResetGump()
		--print("atualizando: ", instance.attribute, instance.sub_attribute)
		instance:UpdateGumpMain(true)
	end

end

function _details:GetRaidPluginName()
	return self.current_raid_plugin or self.last_raid_plugin
end

function _details:GetInstanceAttributeText()
	
	if (self.mode == mode_group or self.mode == mode_all) then
		local attribute = self.attribute
		local sub_attribute = self.sub_attribute
		local name = _details:GetSubAttributeName(attribute, sub_attribute)
		return name or "Unknown"
		
	elseif (self.mode == mode_raid) then
		local plugin_name = self.current_raid_plugin or self.last_raid_plugin
		if (plugin_name) then
			local plugin_object = _details:GetPlugin(plugin_name)
			if (plugin_object) then
				return plugin_object.__name
			else
				return "Unknown Plugin"
			end
		else
			return "Unknown Plugin"
		end
	
	elseif (self.mode == mode_alone) then
		local attribute = _details.SoloTables.Mode or 1
		local SoloInfo = _details.SoloTables.Menu[attribute]
		if (SoloInfo) then
			return SoloInfo[1]
		else
			return "Unknown Plugin"
		end
	end
	
end

function _details:SetRaidOption(instance)

	local available_plugins = _details.RaidTables:GetAvailablePlugins()

	if (#available_plugins == 0) then
		return false
	end
	
	local amount = 0
	for index, ptable in _ipairs(available_plugins) do
		if (ptable[3].__enabled) then
			GameCooltip:AddMenu(1, _details.RaidTables.switch, ptable[4], instance, nil, ptable[1], ptable[2], true) --PluginName, PluginIcon, PluginObject, PluginAbsoluteName
			amount = amount + 1
		end
	end

	if (amount == 0) then
		return false
	end
	
	GameCooltip:SetOption("NoLastSelectedBar", true)
	
	GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
	return true
end

function _details:SetSoloOption(instance)
	for index, ptable in _ipairs(_details.SoloTables.Menu) do 
		if (ptable[3].__enabled) then
			GameCooltip:AddMenu(1, _details.SoloTables.switch, index, nil, nil, ptable[1], ptable[2], true)
		end
	end
	
	if (_details.SoloTables.Mode) then
		GameCooltip:SetLastSelected(1, _details.SoloTables.Mode)
	end
	
	GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
	
	return true
end

-- ~menu
function _details:SetAttributesOption(instance, func)

	func = func or instance.SwitchTable

	local checked1 = instance.attribute
	local attribute_active = instance.attribute --> pega o number
	
	local options
	if (attribute_active == 5) then --> custom
		options = {Loc["STRING_CUSTOM_NEW"]}
		for index, custom in _ipairs(_details.custom) do 
			options[#options+1] = custom.name
		end
	else
		options = sub_attributes[attribute_active].list
	end
	
	local icons = {
		"Interface\\AddOns\\Details\\images\\attributes_icons_damage", 
		"Interface\\AddOns\\Details\\images\\attributes_icons_heal", 
		"Interface\\AddOns\\Details\\images\\attributes_icons_energyze",
		"Interface\\AddOns\\Details\\images\\attributes_icons_misc"
	}

	local CoolTip = _G.GameCooltip
	local p = 0.125 --> 32/256
	
	local gindex = 1
	for i = 1, attributes[0] do -->[0] armazena quantos attributes existem
		
		CoolTip:AddMenu(1, func, nil, i, nil, attributes.list[i], nil, true)
		CoolTip:AddIcon("Interface\\AddOns\\Details\\images\\attributes_icons", 1, 1, 20, 20, p*(i-1), p*(i), 0, 1)
		
		if (i == 1) then
			CoolTip:SetWallpaper(2,[[Interface\TALENTFRAME\WarlockDestruction-TopLeft]], {1, 0.22, 0, 0.55}, {1, 1, 1, .1})
		elseif (i == 2) then
			--CoolTip:SetWallpaper(2,[[Interface\TALENTFRAME\PriestHoly-TopLeft]], {0, .8, 0, 1}, {1, 1, 1, .1})
			CoolTip:SetWallpaper(2,[[Interface\AddOns\Details\images\bg-priest-holy]], {1, .6, 0, .2}, {1, 1, 1, .2})
		elseif (i == 3) then
			CoolTip:SetWallpaper(2,[[Interface\TALENTFRAME\ShamanEnhancement-TopLeft]], {0, 1, .2, .6}, {1, 1, 1, .1})
		elseif (i == 4) then
			CoolTip:SetWallpaper(2,[[Interface\TALENTFRAME\WarlockCurses-TopLeft]], {.2, 1, 0, 1}, {1, 1, 1, .1})
		end
		
		local options = sub_attributes[i].list
		
		for o = 1, attributes[i] do
			if (_details:CaptureIsEnabled( _details.attributes_capture[gindex] )) then
				CoolTip:AddMenu(2, func, true, i, o, options[o], nil, true)
				CoolTip:AddIcon(icons[i], 2, 1, 20, 20, p*(o-1), p*(o), 0, 1)
			else
				CoolTip:AddLine(options[o], nil, 2, .5, .5, .5, 1)
				CoolTip:AddMenu(2, func, true, i, o)
				CoolTip:AddIcon(icons[i], 2, 1, 20, 20, p*(o-1), p*(o), 0, 1, {.3, .3, .3, 1})
			end

			gindex = gindex + 1
		end

		CoolTip:SetLastSelected(2, i, instance.sub_attribute_last[i])

	end
	
	--> custom
	CoolTip:AddMenu(1, func, nil, 5, nil, attributes.list[5], nil, true)
	CoolTip:AddIcon("Interface\\AddOns\\Details\\images\\attributes_icons", 1, 1, 20, 20, p*(5-1), p*(5), 0, 1)
	CoolTip:AddMenu(2, _details.OpenCustomDisplayWindow, nil, nil, nil, Loc["STRING_CUSTOM_NEW"], "Interface\\AddOns\\Details\\images\\Character-Plus", true)
	
	for index, custom in _ipairs(_details.custom) do 
		if (custom.temp) then
			CoolTip:AddLine(custom.name .. Loc["STRING_CUSTOM_TEMPORARILY"], nil, 2)
		else
			CoolTip:AddLine(custom.name, nil, 2)
		end
		
		CoolTip:AddMenu(2, func, true, 5, index)
		CoolTip:AddIcon(custom.icon, 2, 1, 16, 16)
	end
	
	--> set the wallpaper on custom
	GameCooltip:SetWallpaper(2,[[Interface\TALENTFRAME\WarriorArm-TopLeft]], {1, 0, 0, 1}, {1, 1, 1, 0.1})

	if (#_details.custom == 0) then
		CoolTip:SetLastSelected(2, 5, 1)
	else
		if (instance.attribute == 5) then
			CoolTip:SetLastSelected(2, 5, instance.sub_attribute+1)
		else
			CoolTip:SetLastSelected(2, 5, instance.sub_attribute_last[5]+1)
		end
	end

	CoolTip:SetOption("StatusBarTexture",[[Interface\AddOns\Details\images\bar4_vidro]])
	
	CoolTip:SetLastSelected(1, attribute_active)
	
	CoolTip:SetWallpaper(1,[[Interface\SPELLBOOK\DeathKnightBlood-TopLeft]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
	--CoolTip:SetWallpaper(1,[[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Horizontal-Desaturated]], nil, {1, 1, 1, 0.3})
	
	return menu_main, sub_menus
end

--> O Mode não vai afetar a table do SHOWING.
-- o mode é apenas afetado na hora de mostrar o que na table

function _details:ChangeIcon(icon)
	
	local skin = _details.skins[self.skin]

	--print(debugstack())
	
	if (icon) then
		
		--> plugin chamou uma troca de icon
		self.baseframe.header.attribute_icon:SetTexture(icon)
		self.baseframe.header.attribute_icon:SetTexCoord(5/64, 60/64, 3/64, 62/64)
		
		local icon_size = skin.icon_plugins_size
		self.baseframe.header.attribute_icon:SetWidth(icon_size[1])
		self.baseframe.header.attribute_icon:SetHeight(icon_size[2])
		local icon_anchor = skin.icon_anchor_plugins
		self.baseframe.header.attribute_icon:SetPoint("TOPRIGHT", self.baseframe.header.ball_point, "TOPRIGHT", icon_anchor[1], icon_anchor[2])
		
	elseif (self.mode == mode_alone) then --> solo
		-- o icon é alterado pelo próprio plugin
	
	elseif (self.mode == mode_group or self.mode == mode_all) then --> group

		if (self.attribute == 5) then 
			--> custom
			if (_details.custom[self.sub_attribute]) then
				local icon = _details.custom[self.sub_attribute].icon
				self.baseframe.header.attribute_icon:SetTexture(icon)
				self.baseframe.header.attribute_icon:SetTexCoord(5/64, 60/64, 3/64, 62/64)
				
				local icon_size = skin.icon_plugins_size
				self.baseframe.header.attribute_icon:SetWidth(icon_size[1])
				self.baseframe.header.attribute_icon:SetHeight(icon_size[2])
				local icon_anchor = skin.icon_anchor_plugins
				self.baseframe.header.attribute_icon:SetPoint("TOPRIGHT", self.baseframe.header.ball_point, "TOPRIGHT", icon_anchor[1], icon_anchor[2])
			end
		else
			--> normal
			local half = 0.00048828125
			local size = 0.03125
			
			--normal icons
			--local icons = _details.sub_attributes[self.attribute].icons
			--self.baseframe.header.attribute_icon:SetTexture(icons[self.sub_attribute][1])
			--self.baseframe.header.attribute_icon:SetTexCoord( unpack(icons[self.sub_attribute][2]) )
			
			self.baseframe.header.attribute_icon:SetTexture(skin.file)
			self.baseframe.header.attribute_icon:SetTexCoord((0.03125 *(self.attribute-1)) + half,(0.03125 * self.attribute) - half, 0.35693359375, 0.38720703125)
			
			local icon_anchor = skin.icon_anchor_main
			self.baseframe.header.attribute_icon:SetPoint("TOPRIGHT", self.baseframe.header.ball_point, "TOPRIGHT", icon_anchor[1], icon_anchor[2])
			
			self.baseframe.header.attribute_icon:SetWidth(32)
			self.baseframe.header.attribute_icon:SetHeight(32)
		end
		
	elseif (self.mode == mode_raid) then --> raid
		-- o icon é alterado pelo próprio plugin
	end
end

function _details:SetMode(which)
	return self:ChangeMode(which)
end

function _details:ChangeMode(instance, which, from_mode_menu)

	if (_type(instance) == "number") then
		which = instance
		instance = self
	end
	
	local update_coolTip = false
	
	if (which == -2) then --clicou para mudar
		local update_coolTip = true
		
		if (instance.mode == 1) then
			which = 2
		elseif (instance.mode == 2) then
			which = 3
		elseif (instance.mode == 3) then
			which = 4
		elseif (instance.mode == 4) then
			which = 1
		end
	end
	
	--[[ if (_details.solo and _details.solo == instance.mine_id) then --> não trocar de mode se tiver em combat e a window no solo mode
		if (UnitAffectingCombat("player")) then
			return
		end
	end --]]

	if (instance.showing) then
		if (not instance.attribute) then
			instance.attribute = 1
			instance.sub_attribute = 1
			--print("Details found a internal probleam and fixed: 'instance.attribute' were null, now is 1.")
		end
		if (not instance.showing[instance.attribute]) then
			instance.showing = _details.table_current
			--print("Details found a internal problem and fixed: container for instance.showing were null, now is current combat.")
		end
		instance.attribute = instance.attribute or 1
		instance.showing[instance.attribute].need_refresh = true
	end
	
	if (which == mode_alone) then
	
		instance.LastMode = instance.mode
	
		if (instance:IsRaidMode()) then
			_details.RaidTables:DisableRaidMode(instance)
		end

		--> verifica se ja tem alguma instance desactiveda em solo e remove o solo dela
		_details:instanceCallFunctionOffline(_details.instanceCheckForDisabledSolo)
		
		instance.mode = mode_alone
		instance:ChangeIcon()
		
		instance:SoloMode(true)
		_details:SendEvent("DETAILS_INSTANCE_CHANGEMODE", nil, instance, mode_alone)
		
	elseif (which == mode_raid) then
		
		instance.LastMode = instance.mode
		
		if (instance:IsSoloMode()) then
			instance:SoloMode(false)
		end

		--_details:instanceCallFunctionOffline(_details.instanceCheckForDisabledRaid)

		instance.mode = mode_raid
		instance:ChangeIcon()
		
		_details.RaidTables:EnableRaidMode(instance)
		
		_details:SendEvent("DETAILS_INSTANCE_CHANGEMODE", nil, instance, mode_raid)
	
	elseif (which == mode_group) then
	
		instance.LastMode = instance.mode
	
		if (instance:IsSoloMode()) then
			--instance.mode = mode_group
			instance:SoloMode(false)
		elseif (instance:IsRaidMode()) then
			_details.RaidTables:DisableRaidMode(instance)
		end
		
		_details:ResetGump(instance)
		--gump:Fade(instance, 1, nil, "bars")
		
		instance.mode = mode_group
		instance:ChangeIcon()
		
		instance:UpdateGumpMain(true)
		instance.last_mode = mode_group
		_details:SendEvent("DETAILS_INSTANCE_CHANGEMODE", nil, instance, mode_group)
		_details:SendEvent("DETAILS_INSTANCE_CHANGEATTRIBUTE", nil, instance, instance.attribute, instance.sub_attribute)

	elseif (which == mode_all) then
	
		instance.LastMode = instance.mode
	
		if (instance:IsSoloMode()) then
			instance.mode = mode_all
			instance:SoloMode(false)

		elseif (instance:IsRaidMode()) then
			_details.RaidTables:DisableRaidMode(instance)
		end
		
		instance.mode = mode_all
		instance:ChangeIcon()
		
		instance:UpdateGumpMain(true)
		instance.last_mode = mode_all
		_details:SendEvent("DETAILS_INSTANCE_CHANGEMODE", nil, instance, mode_all)
		_details:SendEvent("DETAILS_INSTANCE_CHANGEATTRIBUTE", nil, instance, instance.attribute, instance.sub_attribute)
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
	
	_details.popup:Select(1, checked)
	if (from_mode_menu) then
		instance.baseframe.header.mode_selecao:GetScript("OnEnter")(instance.baseframe.header.mode_selecao)
		if (instance.desaturated_menu) then
			instance.baseframe.header.mode_selecao:GetNormalTexture():SetDesaturated(true)
		end
	end
end

local function GetDpsHps(_thisActor, key)

	local keyname
	if (key == "dps") then
		keyname = "last_dps"
	elseif (key == "hps") then
		keyname = "last_hps"
	end
		
	if (_thisActor[keyname]) then
		return _thisActor[keyname]
	else
		if ((_details.time_type == 2 and _thisActor.group) or not _details:CaptureGet("damage")) then
			local dps = _thisActor.total / _thisActor:GetCombatTime()
			_thisActor[keyname] = dps
			return dps
		else
			if (not _thisActor.on_hold) then
				local dps = _thisActor.total/_thisActor:Time() --calcula o dps dthis objeto
				_thisActor[keyname] = dps --salva o dps dele
				return dps
			else
				if (_thisActor[keyname] == 0) then --> não calculou o dps dele ainda mas entrou em standby
					local dps = _thisActor.total/_thisActor:Time()
					_thisActor[keyname] = dps
					return dps
				else
					return _thisActor[keyname]
				end
			end
		end
	end
end

--> Report o que this na window da instância
function _details:prepare_report(this_report, custom)
	
	if (custom) then
		--> shrink
		local report_lines = {}
		for i = 1, _details.report_lines+1, 1 do  --#this_report -- o +1 é pq ele conta o cabeçalho como uma linha
			report_lines[#report_lines+1] = this_report[i]
		end
		
		return self:send_report(report_lines, true)
	end

	local amt = _details.report_lines

	local report_lines = {}

	if (self.attribute == 5) then --> custom
		report_lines[#report_lines+1] = "Details!: " .. self.customName .. " " .. Loc["STRING_CUSTOM_REPORT"]
	else
		report_lines[#report_lines+1] = "Details!: " .. _details.sub_attributes[self.attribute].list[self.sub_attribute]
	end
	
	local bars = self.bars
	local this_bar
	
	local is_current = _G["Details_Report_CB_1"]:GetChecked()
	local is_reverse = _G["Details_Report_CB_2"]:GetChecked()
	
	if (not _details.fontstring_len) then
		_details.fontstring_len = _details.listener:CreateFontString(nil, "background", "GameFontNormal")
	end
	local _, fontSize = FCF_GetChatWindowInfo(1)
	if (fontSize < 1) then
		fontSize = 10
	end
	local source, _, flags = _details.fontstring_len:GetFont()
	_details.fontstring_len:SetFont(source, fontSize, flags)
	_details.fontstring_len:SetText("hello details!")
	local default_len = _details.fontstring_len:GetStringWidth()
	
	--> pegar a font do chat
	--_details.fontstring_len:
	
	if (not is_reverse) then
	
		if (not is_current) then 
			--> assumindo que self é sempre uma instância aqui.
			local total, keyName, keyNameSec, first
			local container_amount = 0
			local attribute = self.attribute
			local container = self.showing[attribute]._ActorTable
			
			--print("amt: ",#container)
			
			if (attribute == 1) then --> damage
				if (self.sub_attribute == 5) then --> frags
					local frags = self.showing.frags
					local reportFrags = {}
					for name, amount in pairs(frags) do 
						--> string para imprimir direto sem calculos
						reportFrags[#reportFrags+1] = {frag = tostring(amount), name = name} 
					end
					container = reportFrags
					keyName = "frag"
				else
					total, keyName, first, container_amount = _details.attribute_damage:RefreshWindow(self, self.showing, true, true)
					if (self.sub_attribute == 1) then
						keyNameSec = "dps"
					elseif (self.sub_attribute == 2) then
						
					end
				end
			elseif (attribute == 2) then --> heal
				total, keyName, first, container_amount = _details.attribute_heal:RefreshWindow(self, self.showing, true, true)

				if (self.sub_attribute == 1) then
					keyNameSec = "hps"
				end
			elseif (attribute == 3) then --> energy
				total, keyName, first, container_amount = _details.attribute_energy:RefreshWindow(self, self.showing, true, true)
			elseif (attribute == 4) then --> misc
				if (self.sub_attribute == 5) then --> deaths
					local deaths = self.showing.last_events_tables
					local reportDeaths = {}
					for index, death in ipairs(deaths) do 
						reportDeaths[#reportDeaths+1] = {dead = death[6], name = death[3]:gsub(("%-.*"), "")}
					end
					container = reportDeaths
					keyName = "dead"
				else
					total, keyName, first, container_amount = _details.attribute_misc:RefreshWindow(self, self.showing, true, true)
				end
			elseif (attribute == 5) then --> custom
			
				if (_details.custom[self.sub_attribute]) then
					total, container, first, container_amount = _details.attribute_custom:RefreshWindow(self, self.showing, true, true)
					keyName = "report_value"
				else
					total, keyName, first, container_amount = _details.attribute_damage:RefreshWindow(self, self.showing, true, true)
					total = 1
					attribute = 1
					container = self.showing[attribute]._ActorTable
				end
				--print(total, keyName, first, attribute, container_amount)
			end
			
			amt = math.min(amt, container_amount or 0)

			for i = 1, amt do 
				local _thisActor = container[i]

				if (_thisActor) then 
				
					local amount
					if (type(_thisActor[keyName]) == "number") then
						amount = _math_floor(_thisActor[keyName])
					else
						amount = _thisActor[keyName]
					end
					
					local name = _thisActor.name.." "
					if (_details.remove_realm_from_name and name:find("-")) then
						name = name:gsub(("%-.*"), "")
					end
					
					_details.fontstring_len:SetText(name)
					local stringlen = _details.fontstring_len:GetStringWidth()
					
					while(stringlen < default_len) do 
						name = name .. "."
						_details.fontstring_len:SetText(name)
						stringlen = _details.fontstring_len:GetStringWidth()
					end
					
					if (_type(amount) == "number" and amount > 0) then
						if (keyNameSec) then
							local dps = GetDpsHps(_thisActor, keyNameSec)
							report_lines[#report_lines+1] = i .. ". " .. name .. " " .. _cstr("%.2f", amount/total*100) .. "%(" .. _details:comma_value(_math_floor(dps)) .. ", " .. _details:ToK( _math_floor(amount) ) .. ")"
						else
							report_lines[#report_lines+1] = i .. ". " .. name .. "   " .. _details:ToKReport(amount).."(".._cstr("%.1f", amount/total*100).."%)"
						end
						
					elseif (_type(amount) == "string") then
					
						report_lines[#report_lines+1] = i .. ". " .. name .. "   " .. amount
						
					else
						break
					end
				else
					break
				end
			end
	
		else
			for i = 1, amt do
				local ROW = self.bars[i]
				if (ROW) then
					if (not ROW.hidden or ROW.fading_out) then --> a bar this visivel na tela
						report_lines[#report_lines+1] = ROW.text_left:GetText().."   ".. ROW.text_right:GetText()
					else
						break
					end
				else
					break --> chegou a final, parar de pegar as lines
				end
			end
		end
		
	else --> é reverse
		report_lines[1] = report_lines[1].."(" .. Loc["STRING_REPORTFRAME_REVERTED"] .. ")"
		
		if (not is_current) then 
			--> assumindo que self é sempre uma instância aqui.
			local total, keyName, first, container_amount
			local attribute = self.attribute
			
			local container = self.showing[attribute]._ActorTable
			local amount = 0
			
			if (attribute == 1) then --> damage
				if (self.sub_attribute == 5) then --> frags
					local frags = self.showing.frags
					local reportFrags = {}
					for name, amount in pairs(frags) do 
						--> string para imprimir direto sem calculos
						reportFrags[#reportFrags+1] = {frag = tostring(amount), name = name} 
					end
					container = reportFrags
					keyName = "frag"
				else
					if (self.sub_attribute == 1) then
						keyNameSec = "dps"
					end
					total, keyName, first, container_amount = _details.attribute_damage:RefreshWindow(self, self.showing, true, true)
				end
			elseif (attribute == 2) then --> heal
				total, keyName, first, container_amount = _details.attribute_heal:RefreshWindow(self, self.showing, true, true)
				if (self.sub_attribute == 1) then
					keyNameSec = "hps"
				end
			elseif (attribute == 3) then --> energy
				total, keyName, first, container_amount = _details.attribute_energy:RefreshWindow(self, self.showing, true, true)
			elseif (attribute == 4) then --> misc
				if (self.sub_attribute == 5) then --> deaths
					local deaths = self.showing.last_events_tables
					local reportDeaths = {}
					for index, death in ipairs(deaths) do 
						reportDeaths[#reportDeaths+1] = {dead = death[6], name = death[3]:gsub(("%-.*"), "")}
					end
					container = reportDeaths
					keyName = "dead"
				else
					total, keyName, first, container_amount = _details.attribute_misc:RefreshWindow(self, self.showing, true, true)
				end
			elseif (attribute == 5) then --> custom
				total, container, first, container_amount = _details.attribute_custom:RefreshWindow(self, self.showing, true, true)
				keyName = "report_value"				
			end
			
			local this_amt = math.min(#container, container_amount or 0, amt)
			this_amt = #container - this_amt

			for i = container_amount, this_amt, -1 do 
				
				local _thisActor = container[i]
				if (_thisActor) then
				
					local amount
					if (type(_thisActor[keyName]) == "number") then
						amount = _math_floor(_thisActor[keyName])
					else
						amount = _thisActor[keyName]
					end
					
					local name = _thisActor.name .. " "
					
					_details.fontstring_len:SetText(name)
					local stringlen = _details.fontstring_len:GetStringWidth()
					
					while(stringlen < default_len) do 
						name = name .. "."
						_details.fontstring_len:SetText(name)
						stringlen = _details.fontstring_len:GetStringWidth()
					end				
					
					if (_type(amount) == "number") then
						if (amount > 0) then 
							if (keyNameSec) then
								local dps = GetDpsHps(_thisActor, keyNameSec)
								report_lines[#report_lines+1] = i .. ". " .. name .. " " .. _cstr("%.2f", amount/total*100) .. "%(" .. _details:comma_value(_math_floor(dps)) .. ", " .. _details:ToK( _math_floor(amount) ) .. ")"
							else
								report_lines[#report_lines+1] = i .. "." .. name .. "   " .. _details:comma_value( _math_floor(amount) ).."(".._cstr("%.1f", amount/total*100).."%)"
							end
							
							amount = amount + 1
							if (amount == amt) then
								break
							end
						end
					elseif (_type(amount) == "string") then
						report_lines[#report_lines+1] = i .. ". " .. name .. "   " .. amount
					else
						break
					end
				end
			end
		else
			local new_table = {}
			
			for i = 1, amt do
				local ROW = self.bars[i]
				if (ROW) then
					if (not ROW.hidden or ROW.fading_out) then --> a bar this visivel na tela
						new_table[#new_table+1] = ROW.text_left:GetText().."   ".. ROW.text_right:GetText()
					else
						break
					end
				else
					break
				end
			end
			
			for i = #new_table, 1, -1 do
				report_lines[#report_lines+1] = new_table[i]
			end
		end

	end
	
	return self:send_report(report_lines)
	
end

function _details:send_report(lines, custom)

	local segment = self.segment
	local fight = nil
	
	if (not custom) then
		if (segment == -1) then --overall
			fight = Loc["STRING_REPORT_LAST"] .. " " .. #_details.table_history.tables .. " " .. Loc["STRING_REPORT_FIGHTS"]
			
		elseif (segment == 0) then --current
		
			if (_details.table_current.is_boss) then
				local encounterName = _details.table_current.is_boss.name
				if (encounterName) then
					fight = encounterName
				end
				
			elseif (_details.table_current.is_pvp) then
				local battleground_name = _details.table_current.is_pvp.name
				if (battleground_name) then
					fight = battleground_name
				end
			end
			
			if (not fight) then
				if (_details.table_current.enemy) then
					fight = _details.table_current.enemy
				end
			end
			
			if (not fight) then
				fight = _details.segments.current
			end
		else
			if (segment == 1) then
			
				if (_details.table_history.tables[1].is_boss) then
					local encounterName = _details.table_history.tables[1].is_boss.name
					if (encounterName) then
						fight = encounterName .. "(" .. Loc["STRING_REPORT_LASTFIGHT"]  .. ")"
					end
					
				elseif (_details.table_history.tables[1].is_pvp) then
					local battleground_name = _details.table_history.tables[1].is_pvp.name
					if (battleground_name) then
						fight = battleground_name .. "(" .. Loc["STRING_REPORT_LASTFIGHT"]  .. ")"
					end
				end
				
				if (not fight) then
					if (_details.table_history.tables[1].enemy) then
						fight = _details.table_history.tables[1].enemy .. "(" .. Loc["STRING_REPORT_LASTFIGHT"]  .. ")"
					end
				end
			
				if (not fight) then
					fight = Loc["STRING_REPORT_LASTFIGHT"]
				end
				
			else
			
				if (_details.table_history.tables[segment].is_boss) then
					local encounterName = _details.table_history.tables[segment].is_boss.name
					if (encounterName) then
						fight = encounterName .. "(" .. segment .. " " .. Loc["STRING_REPORT_PREVIOUSFIGHTS"] .. ")"
					end
					
				elseif (_details.table_history.tables[segment].is_pvp) then
					local battleground_name = _details.table_history.tables[segment].is_pvp.name
					if (battleground_name) then
						fight = battleground_name .. "(" .. Loc["STRING_REPORT_LASTFIGHT"]  .. ")"
					end
				end
				
				if (not fight) then
					if (_details.table_history.tables[segment].enemy) then
						fight = _details.table_history.tables[segment].enemy .. "(" .. segment .. " " .. Loc["STRING_REPORT_PREVIOUSFIGHTS"] .. ")"
					end
				end
			
				if (not fight) then
					fight = "(" .. segment .. " " .. Loc["STRING_REPORT_PREVIOUSFIGHTS"] .. ")"
				end
			end
		end

		lines[1] = lines[1] .. " " .. Loc["STRING_REPORT"] .. " " .. fight

	end
	
	if (_details.time_type == 2) then
		--lines[1] = lines[1] .. "(Ef)"
	else
		--lines[1] = lines[1] .. "(Ac)"
	end
	
	local editbox = _details.window_report.editbox
	if (editbox.focus) then --> não precionou enter antes de clicar no okey
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
	end

	if (_details.report_where == "COPY") then
		return _details:SendReportTextWindow(lines)
	end
	
	local to_who = _details.report_where
	
	local channel = to_who:find("CHANNEL")
	local is_btag = to_who:find("REALID")
	
	if (channel) then
		
		channel = to_who:gsub((".*|"), "")

		for i = 1, #lines do 
			_SendChatMessage(lines[i], "CHANNEL", nil, _GetChannelName(channel))
		end
		
		return
		
	elseif (is_btag) then
	
		local id = to_who:gsub((".*|"), "")
		local presenceID = tonumber(id)
		
		for i = 1, #lines do 
			BNSendWhisper(presenceID, lines[i])
		end
		
		return

	elseif (to_who == "WHISPER") then --> whisper
	
		local dst = _details.report_to_who
		
		if (not dst or dst == "") then
			print(Loc["STRING_REPORT_INVALIDTARGET"])
			return
		end
		
		for i = 1, #lines do 
			_SendChatMessage(lines[i], to_who, nil, dst)
		end
		return
		
	elseif (to_who == "WHISPER2") then --> whisper target
		to_who = "WHISPER"
		
		local dst
		if (_UnitExists("target")) then
			if (_UnitIsPlayer("target")) then
				dst = _UnitName("target")
			else
				print(Loc["STRING_REPORT_INVALIDTARGET"])
				return
			end
		else
			print(Loc["STRING_REPORT_INVALIDTARGET"])
			return
		end
		
		for i = 1, #lines do 
			_SendChatMessage(lines[i], to_who, nil, dst)
		end

		return
	end
	
	for i = 1, #lines do 
		_SendChatMessage(lines[i], to_who)
	end
	
end
