--File Revision: 1
--Last Modification: 06/12/2013
-- Change Log:
	-- 06/12/2013: file added.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--[[global]] DETAILS_HOOK_COOLDOWN = "HOOK_COOLDOWN"
	--[[global]] DETAILS_HOOK_DEATH = "HOOK_DEATH"
	--[[global]] DETAILS_HOOK_BATTLERESS = "HOOK_BATTLERESS"
	--[[global]] DETAILS_HOOK_INTERRUPT = "HOOK_INTERRUPT"
	
	--[[global]] DETAILS_HOOK_BUFF = "HOOK_BUFF" --[[REMOVED--]]
	
	
	local _details = _G._details
	local _
	
	_details.hooks["HOOK_COOLDOWN"] = {}
	_details.hooks["HOOK_DEATH"] = {}
	_details.hooks["HOOK_BATTLERESS"] = {}
	_details.hooks["HOOK_INTERRUPT"] = {}
	
	_details.hooks["HOOK_BUFF"] = {} --[[REMOVED--]]
	
	function _details:InstallHook(hook_type, func)
	
		if (not _details.hooks[hook_type]) then
			return false, "Invalid hook type."
		end
		
		_details.hooks[hook_type][#_details.hooks[hook_type] + 1] = func
		
		_details.hooks[hook_type].enabled = true
		
		_details:UpdateParserGears()
		return true
	end
	
	function _details:UnInstallHook(hook_type, func)
	
		if (not _details.hooks[hook_type]) then
			return false, "Invalid hook type."
		end
		
		for index, this_func in ipairs(_details.hooks[hook_type]) do 
		
			if (this_func == func) then
			
				table.remove(_details.hooks[hook_type], index)
				
				if (#_details.hooks[hook_type] == 0) then
					_details.hooks[hook_type].enabled = false
				end
				
				_details:UpdateParserGears()
				return true
			end
		end
		
	end