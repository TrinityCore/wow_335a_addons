-- class target file

	local _details = 		_G._details
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _setmetatable = setmetatable --lua local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants
	
	local dst_of_ability	=	_details.dst_of_ability

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function dst_of_ability:Newtable(link)

		local this_table = {total = 0}
		_setmetatable(this_table, dst_of_ability)
		
		return this_table
	end

	function dst_of_ability:AddQuantidade(amt)
		self.total = self.total + amt
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core
	
	function _details.refresh:r_dst_of_ability(this_dst, shadow)
		_setmetatable(this_dst, dst_of_ability)
		this_dst.__index = dst_of_ability
		this_dst.shadow = shadow._ActorTable[shadow._NameIndexTable[this_dst.name]]
	end

	function _details.clear:c_dst_of_ability(this_dst)
		this_dst.shadow = nil
		--this_dst.__index = {}
		this_dst.__index = nil
	end

	dst_of_ability.__sub = function(table1, table2)
		table1.total = table1.total - table2.total
		if (table1.overheal) then
			table1.overheal = table1.overheal - table2.overheal
			table1.absorbed = table1.absorbed - table2.absorbed
		end
	end
