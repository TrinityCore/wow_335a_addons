
local myname, ns = ...

function ns.InitDB()
	_G[myname.."DB"] = setmetatable(_G[myname.."DB"] or {}, {__index = ns.defaults})
	ns.db = _G[myname.."DB"]

	_G[myname.."DBPC"] = setmetatable(_G[myname.."DBPC"] or {}, {__index = ns.defaultsPC})
	ns.dbpc = _G[myname.."DBPC"]
end


function ns.FlushDB()
	for i,v in pairs(ns.defaults) do if ns.db[i] == v then ns.db[i] = nil end end
	for i,v in pairs(ns.defaultsPC) do if ns.dbpc[i] == v then ns.dbpc[i] = nil end end
end
