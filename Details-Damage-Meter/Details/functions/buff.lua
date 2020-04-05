--File Revision: 1
--Last Modification: 27/07/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = _G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local _
	--> initialize buffs name container
	_details.Buffs.BuffsTable = {} -- armazenara o[name do buff] = { table do buff }
	_details.Buffs.__index = _details.Buffs
	
	--> switch off recording buffs by default
	_details.RecordPlayerSelfBuffs = false
	_details.RecordPlayerAbilityWithBuffs = false
	_details.RecordPlayerSelfDebuffs = false
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _pairs = pairs --> lua local
	local _ipairs = ipairs --> lua local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

	--> return if the buff is already registred or not
	function _details.Buffs:IsRegistred(buff)
		if (type(buff) == "number") then
			for _, buffObject in _pairs(_details.Buffs.BuffsTable) do 
				if (buffObject.id == buff) then
					return true
				end
			end
			return false
		elseif (type(buff) == "string") then
			for name, _ in _pairs(_details.Buffs.BuffsTable) do 
				if (name == buff) then
					return true
				end
			end
			return false
		end
	end

	--> register a new buff name
	function _details.Buffs:NewBuff(BuffName, BuffId)
		if (not BuffName) then
			BuffName = GetSpellInfo(BuffId)
		end
		if (_details.Buffs.BuffsTable[BuffName]) then
			return false
		else
			_details.Buffs.BuffsTable[BuffName] = _details.Buffs:BuildBuffTable(BuffName, BuffId)
		end
	end

	--> remove a registred buff
	function _details.Buffs:RemoveBuff(BuffName)
		if (not _details.Buffs.BuffsTable[BuffName]) then
			return false
		else
			_details.Buffs.BuffsTable = _details:tableRemove(_details.Buffs.BuffsTable, BuffName)
			return true
		end
	end
	
	--> return a list of registred buffs
	function _details.Buffs:GetBuffList()
		local list = {}
		for name, _ in _pairs(_details.Buffs.BuffsTable) do 
			list[#list+1] = name
		end
		return list
	end

	--> return a list of registred buffs ids
	function _details.Buffs:GetBuffListIds()
		local list = {}
		for name, buffObject in _pairs(_details.Buffs.BuffsTable) do 
			list[#list+1] = buffObject.id
		end
		return list
	end

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions
	
	function _details.Buffs:UpdateBuff(method)
		-- self = buff table
		if (method == "new") then
		
			self.start = _details._time
			self.castedAmt = self.castedAmt + 1
			self.active = true
			self.appliedAt[#self.appliedAt+1] = _details.table_current:GetCombatTime()
			_details:SendEvent("BUFF_UPDATE")
			
		elseif (method == "refresh") then
			
			self.refreshAmt = self.refreshAmt + 1
			self.duration = self.duration +(_details._time - self.start)
			self.start = _details._time
			self.appliedAt[#self.appliedAt+1] = _details.table_current:GetCombatTime()
			_details:SendEvent("BUFF_UPDATE")
			
		elseif (method == "remove") then
			
			if (self.start) then
				self.duration = self.duration +(_details._time - self.start)
			else
				self.duration = 0
			end
			self.droppedAmt = self.droppedAmt + 1
			self.start = nil
			self.active = false
			_details:SendEvent("BUFF_UPDATE")
			
		end
	end

	--> build buffs
	function _details.Buffs:BuildTables()
		_details.Buffs.built = true
		if (_details.savedbuffs) then
			for _, BuffId in _ipairs(_details.savedbuffs) do 
				_details.Buffs:NewBuff(nil, BuffId)
			end
		end
	end

	--> save buff list when addon exit
	function _details.Buffs:SaveBuffs()
		_details_database.savedbuffs = _details.Buffs:GetBuffListIds()
	end

	--> construct a buff table of the new buff registred
	function _details.Buffs:BuildBuffTable(BuffName, BuffId)
		local bufftable = {name = BuffName, id = BuffId, duration = 0, start = nil, castedAmt = 0, refreshAmt = 0, droppedAmt = 0, active = false, appliedAt = {}}
		bufftable.IsBuff = true
		setmetatable(bufftable, _details.Buffs)
		return bufftable
	end


	--> update player buffs
	function _details.Buffs:CatchBuffs()
		
		if (not _details.Buffs.built) then
			_details.Buffs:BuildTables()
		end
		
		for _, BuffTable in _pairs(_details.Buffs.BuffsTable) do 
			if (BuffTable.active) then
				BuffTable.start = _details._time
				BuffTable.castedAmt = 1
			else
				BuffTable.start = nil
				BuffTable.castedAmt = 0
			end
			
			BuffTable.appliedAt = {}
			BuffTable.duration = 0
			BuffTable.refreshAmt = 0
			BuffTable.droppedAmt = 0
		end
		
		--> catch buffs untracked yet
		for buffIndex = 1, 41 do
			local name = UnitAura("player", buffIndex)
			if (name) then
				local bufftable = _details.Buffs.BuffsTable[name]
				if (bufftable and not bufftable.active) then
					bufftable.active = true
					bufftable.castedAmt = 1
					bufftable.start = _details._time
				end
				
				--[[
				for index, BuffName in _pairs(_details.SoloTables.BuffsTableNameCache) do
					if (BuffName == name) then
						local BuffObject = _details.SoloTables.SoloBuffUptime[name]
						if (not BuffObject) then
							_details.SoloTables.SoloBuffUptime[name] = {name = name, duration = 0, start = nil, castedAmt = 1, refreshAmt = 0, droppedAmt = 0, Active = true, tableIndex = index, appliedAt = {}}
							--_details.SoloTables.BuffTextEntry[index].backgroundFrame:Active()
						end
					end
				end
				--]]
			end
		end
	end
