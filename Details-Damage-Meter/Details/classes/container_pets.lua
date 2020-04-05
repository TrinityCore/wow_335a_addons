local _details = 		_G._details
local gump = 			_details.gump

local container_pets =		_details.container_pets

-- api locals
local _UnitGUID = UnitGUID
local _UnitName = UnitName
local _GetUnitName = GetUnitName
local _IsInRaid = IsInRaid
local _IsInGroup = IsInGroup
local _GetNumGroupMembers = GetNumGroupMembers

-- lua locals
local _setmetatable = setmetatable
local _bit_band = bit.band --lua local
local _pairs = pairs
local _ipairs = ipairs
local _table_wipe = table.wipe

--details locals
local is_ignored = _details.pets_ignored

function container_pets:NewContainer()
	local this_table = {}
	_setmetatable(this_table, _details.container_pets)
	this_table.pets = {} --> armazena a pool -> uma dictionary com o[serial do pet] -> name do owner
	this_table._ActorTable = {} --> armazena os 15 ultimos pets do player ->[player name] -> {nil, nil, nil, ...}
	return this_table
end

local OBJECT_TYPE_PET = 0x00001000
local EM_GRUPO = 0x00000007
local PET_EM_GRUPO = 0x00001007
-- GetOwner
function container_pets:CatchDono(pet_serial, pet_name, pet_flags)

	--> sair se o pet estiver na ignore
	if (is_ignored[pet_serial]) then
		return
	end

	--> buscar pelo pet no container de pets
	local busca = self.pets[pet_serial]
	if (busca) then
		return pet_name .." <"..busca[1]..">", busca[1], busca[2], busca[3] -->[1] owner name[2] owner serial[3] owner flag
	end
	
	--> buscar pelo pet na raide
	local owner_name, owner_serial, owner_flags
	
	if (GetNumRaidMembers() > 0) then
		for i = 1, GetNumRaidMembers() do 
			if (pet_serial == _UnitGUID("raidpet"..i)) then
				owner_serial = _UnitGUID("raid"..i)
				owner_flags = 0x00000417 --> emulate sourceflag flag
				
				local name, realm = _UnitName("raid"..i)
				if (realm and realm ~= "") then
					name = name.."-"..realm
				end
				owner_name = name
			end
		end
		
	elseif (GetNumPartyMembers() > 0) then
		for i = 1, GetNumPartyMembers() do 
			if (pet_serial == _UnitGUID("partypet"..i)) then
				owner_serial = _UnitGUID("party"..i)
				owner_flags = 0x00000417 --> emulate sourceflag flag
				
				local name, realm = _UnitName("party"..i)
				if (realm and realm ~= "") then
					name = name.."-"..realm
				end
				
				owner_name = name
			end
		end
	end
	
	if (not owner_name) then
		if (pet_serial == _UnitGUID("pet")) then
			owner_name = _GetUnitName("player")
			owner_serial = _UnitGUID("player")
			if (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0) then
				owner_flags = 0x00000417 --> emulate sourceflag flag
			else
				owner_flags = 0x00000411 --> emulate sourceflag flag
			end
		end
	end
	
	if (owner_name) then
		self.pets[pet_serial] = {owner_name, owner_serial, owner_flags, _details._time, true} --> adicionada a flag emulada
		return pet_name .." <"..owner_name..">", owner_name, owner_serial, owner_flags
	else
		
		if (pet_flags and _bit_band(pet_flags, OBJECT_TYPE_PET) ~= 0) then --> é um pet
			if (not _details.pets_no_owner[pet_serial] and _bit_band(pet_flags, EM_GRUPO) ~= 0) then
				_details.pets_no_owner[pet_serial] = {pet_name, pet_flags}
				_details:Msg("couldn't find the owner of the pet:", pet_name)
			end
		else
			is_ignored[pet_serial] = true
		end
	end
	
	--> não pode enagainstr o owner do pet, coloca-lo na ignore
	
	return
end

-->  ao ter raid roster update, precisa dar foreach no container de pets e verificar as flags
-->  o mesmo precisa ser feito com as tables de combat

function container_pets:BuscarPets()
	if (GetNumRaidMembers() > 0) then
		for i = 1, GetNumRaidMembers(), 1 do 
			local pet_serial = _UnitGUID("raidpet"..i)
			if (pet_serial) then
				if (not _details.table_pets.pets[pet_serial]) then
					local name, realm = _UnitName("raid"..i)
					if (name == "Unknown Entity") then
						_details:SchedulePetUpdate(1)
					else
						if (realm and realm ~= "") then
							name = name.."-"..realm
						end
						_details.table_pets:Adicionar(pet_serial, _UnitName("raidpet"..i), 0x1114, _UnitGUID("raid"..i), name, 0x514)
					end
				end
			end
		end
		
	elseif (GetNumPartyMembers() > 0) then
		for i = 1, GetNumPartyMembers(), 1 do 
			local pet_serial = _UnitGUID("partypet"..i)
			if (pet_serial) then
				if (not _details.table_pets.pets[pet_serial]) then
					local name, realm = _UnitName("party"..i)
					if (name == "Unknown Entity") then
						_details:SchedulePetUpdate(1)
					else
						if (realm and realm ~= "") then
							name = name.."-"..realm
						end
						_details.table_pets:Adicionar(pet_serial, _UnitName("partypet"..i), 0x1114, _UnitGUID("party"..i), name, 0x514) 
					end
				end
			end
		end
		
		local pet_serial = _UnitGUID("pet")
		if (pet_serial) then
			if (not _details.table_pets.pets[pet_serial]) then
				_details.table_pets:Adicionar(pet_serial, _UnitName("pet"), 0x1114, _UnitGUID("player"), _details.playername, 0x514)
			end
		end
		
	else
		local pet_serial = _UnitGUID("pet")
		if (pet_serial) then
			if (not _details.table_pets.pets[pet_serial]) then
				_details.table_pets:Adicionar(pet_serial, _UnitName("pet"), 0x1114, _UnitGUID("player"), _details.playername, 0x514)
			end
		end
	end
end

-- 4372 = 1114 -> pet control player -> friendly -> aff raid

function container_pets:Adicionar(pet_serial, pet_name, pet_flags, owner_serial, owner_name, owner_flags)

	if (pet_flags and _bit_band(pet_flags, OBJECT_TYPE_PET) ~= 0 and _bit_band(pet_flags, EM_GRUPO) ~= 0) then
		self.pets[pet_serial] = {owner_name, owner_serial, owner_flags, _details._time, true, pet_name, pet_serial}
		--if (pet_name == "Guardian of Ancient Kings") then --remover
		--	print("SUMMON", "Adicionou ao container")
		--end
	else
		self.pets[pet_serial] = {owner_name, owner_serial, owner_flags, _details._time, false, pet_name, pet_serial}
		--if (pet_name == "Guardian of Ancient Kings") then --remover
		--	print("SUMMON", "Adicionou ao container")
		--end
	end
	
end

function _details:WipePets()
	return _table_wipe(_details.table_pets.pets)
end

function _details:LimparPets()
	--> elimina pets antigos
	local _new_PetTable = {}
	for PetSerial, PetTable in _pairs(_details.table_pets.pets) do 
		if ((PetTable[4] + _details.interval_collect > _details._time + 1) or(PetTable[5] and PetTable[4] + 43200 > _details._time) ) then
			_new_PetTable[PetSerial] = PetTable
		end
	end
	--a table antiga será descartada pelo garbage collector.
	--_table_wipe(_details.table_pets.pets)
	_details.table_pets.pets = _new_PetTable
end

local have_schedule = false
function _details:UpdatePets()
	have_schedule = false
	return container_pets:BuscarPets()
end
function _details:SchedulePetUpdate(seconds)
	if (have_schedule) then
		return
	end
	have_schedule = true
	_details:ScheduleTimer("UpdatePets", seconds or 5)
end

function _details.refresh:r_container_pets(container)
	_setmetatable(container, container_pets)
	--container.__index = container_pets
end

