
local myname, ns = ...

ns.L = setmetatable({}, {__index=function(t,i) return i end})
