
local ids = LibStub:NewLibrary("tekIDmemo", 2)
if not ids then return end

setmetatable(ids, {
	__index = function(t,i)
		if type(i) == "number" then
			t[i] = i
			return i
		elseif type(i) ~= "string" then
			t[i] = false
			return
		end

		local id = tonumber(i:match("item:(%d+)"))
		t[i] = id
		return id
	end,
})

