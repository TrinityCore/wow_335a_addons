--File Revision: 2
--Last Modification: 12/09/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.
	-- 12/09/2013: Fixed some problems with garbage collector.

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = 		_G._details
	local _timestamp = time()
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _table_insert = table.insert --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _time = time --lua local
	local _math_floor = math.floor
	local timeMachine = _details.timeMachine --details local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants
	local _timestamp = _time()
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	timeMachine.ligada = false

	function timeMachine:Core()

		_timestamp = _time()
		_details._time = _timestamp
		_details:UpdateGears()

		for type, table in _pairs(self.tables) do
			for name, player in _ipairs(table) do
				if (player) then
					if (player.last_event+10 > _timestamp) then --> okey o player this dando dps
						if (player.on_hold) then --> o dps thisva pausado, retornar a active
							player:HoldOn(false)
						end
					else
						if (not player.on_hold) then --> não ta pausado, precisa por em pausa
							--> verifica se this castando alguma coisa que leve + que 10 seconds
							player:HoldOn(true)
						end
					end
				end
			end
		end
	end

	function timeMachine:Ligar()
		self.atualizador = self:ScheduleRepeatingTimer("Core", 1)
		self.ligada = true
		self.tables = {{}, {}} --> 1 damage 2 heal
		
		local damages = _details.table_current[1]._ActorTable
		for _, player in _ipairs(damages) do
			if (player.dps_started) then
				player:RegisterInTimeMachine()
			end
		end
	end

	function timeMachine:Desligar()
		self.ligada = false
		self.tables = nil
		if (self.atualizador) then
			self:CancelTimer(self.atualizador)
			self.atualizador = nil
		end
	end

	function timeMachine:Reinitialize()
		table.wipe(self.tables[1])
		table.wipe(self.tables[2])
		self.tables = {{}, {}} --> 1 damage 2 heal
	end

	function _details:UnregisterInTimeMachine()
		if (not timeMachine.ligada) then
			return
		end
		
		local timeMachineContainer = timeMachine.tables[self.type]
		local actorTimeMachineID = self.timeMachine
		
		if (timeMachineContainer[actorTimeMachineID] == self) then
			self:FinishTime()
			self.timeMachine = nil
			timeMachineContainer[actorTimeMachineID] = false
		end
	end

	function _details:RegisterInTimeMachine()
		if (not timeMachine.ligada) then
			return
		end

		local this_table = timeMachine.tables[self.type]
		_table_insert(this_table, self)
		self.timeMachine = #this_table
	end 

	function _details:ManutencaoTimeMachine()
		for type, table in _ipairs(timeMachine.tables) do
			local t = {}
			local removed = 0
			for index, player in _ipairs(table) do
				if (player) then
					t[#t+1] = player
					player.timeMachine = #t
				else
					removed = removed + 1
				end
			end
			
			timeMachine.tables[type] = t
			
			if (_details.debug) then
				_details:Msg("timemachine r"..removed.."| e"..#t.."| t"..type)
			end
		end
	end

	function _details:Time()
		if (self.end_time) then --> o time do player this trancado
			local t = self.end_time - self.start_time
			if (t < 10) then
				t = 10
			end
			return t
		elseif (self.on_hold) then --> o time this em pausa
			local t = self.delay - self.start_time
			if (t < 10) then
				t = 10
			end
			return t
		else
			if (self.start_time == 0) then
				return 10
			end
			local t = _timestamp - self.start_time
			if (t < 10) then
				if (_details.in_combat) then
					local combat_time = _details.table_current:GetCombatTime()
					if (combat_time < 10) then
						return combat_time
					end
				end
				t = 10
			end
			return t
		end
	end

	function _details:InitializeTime(time, shadow)

	-- inicia o time no objeto atual
	--------------------------------------------------------------------------------
		
		self.start_time = time
		
	-- inicia o time no shadow do objeto
	--------------------------------------------------------------------------------	
		
		if (shadow.end_time) then
			local subs = shadow.end_time - shadow.start_time
			shadow.start_time = time - subs
			shadow.end_time = nil
		else
			if (shadow.start_time == 0) then
				shadow.start_time = time
			end
		end
	end

	function _details:FinishTime()
		if (self.end_time) then
			return
		end

		if (self.on_hold) then
			self:HoldOn(false)
		end
		
		self.end_time = _timestamp
	end

	--> diz se o dps dthis player this em pausa
	function _details:HoldOn(pausa)
		if (pausa == nil) then 
			return self.on_hold --retorna se o dps this aberto ou closedo para this player
			
		elseif (pausa) then --> true - colocar como inactive
			self.delay = _math_floor(self.last_event) --_timestamp - 10
			if (self.delay < self.start_time) then
				self.delay = self.start_time
			end
			self.on_hold = true
			
		else --> false - retornar a atividade
			local diff = _timestamp - self.delay - 1
			if (diff > 0) then
				self.start_time = self.start_time + diff
			end
			--if (_timestamp - self.start_time < 20) then
			--	self.start_time = self.start_time - 1
			--end
			self.on_hold = false
			
		end
	end

	function _details:PrintTimeMachineIndexes()
		print("timemachine damage", #timeMachine.tables[1])
		print("timemachine heal", #timeMachine.tables[2])
	end