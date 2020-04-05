--[[ Link actor with his twin shadow ]]

do 
	local _details = _G._details

	local _rawget = rawget
	local _setmetatable =	setmetatable
	local _ipairs = ipairs
	
	--> default weaktable
	_details.weaktable = {__mode = "v"}

	--> create link between two tables
	function _details:FazLinkagem(objeto)
		local mine_links = _rawget(self, "links")
		if (not mine_links) then
			mine_links = _setmetatable({}, _details.weaktable)
			self.links = mine_links
		end
		mine_links[#mine_links+1] = objeto
	end
	
	--> check if there is a link between tables
	function _details:EstaoLinkados(objeto)
		local mine_links = _rawget(self, "links")
		if (not mine_links) then
			return false
		end
		for index, actor in _ipairs(mine_links) do
			if (actor == objeto) then
				return true
			end
		end
		
		return false
	end

	--> create the link
	function _details:CreateLink(link)
		--> se tiver a table no overall
		--if (link) then 
		--	link:FazLinkagem(self)
		--end
	end
end