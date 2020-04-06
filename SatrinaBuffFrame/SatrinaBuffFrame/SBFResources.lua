local sbf = _G["SBF"]
local tables = {}
local created = 0
local out = 0
local a

local meta = {}
meta.__mode = "v"       

sbf.GetTable = function(self)
	if (#tables == 0) then
    created = created + 1
    out = out + 1
    a = {}
    -- setmetatable(a, meta)
		return a
	end
  out = out + 1
	return table.remove(tables, 1)
end

sbf.PutTable = function(self, t, topOnly)
	if not t then
		return
	end
  if t.auraType and t.name then
    self:debugmsg(256, format("PutTable called for |cff00ffaa%s", t.name))
  end
	for k,v in pairs(t) do
		if (type(v) == "table") and not topOnly and not v.IsObjectType and (string.byte(k, 1) ~= 95) then
			self:PutTable(v)
		end
		t[k] = nil
	end
  out = out - 1
	table.insert(tables, t)
end

sbf.RecycleTable = function(self, t)
	for k,v in pairs(t) do
		if (type(v) == "table") and not topOnly and not v.IsObjectType and (string.byte(k, 1) ~= 95) then
			self:PutTable(v)
		end
		t[k] = nil
	end
end

sbf.CopyTable = function(self, src)
	local dst = self:GetTable()
	for k,v in pairs(src) do
		if (type(v) == "table") and not v.IsObjectType and (string.byte(k, 1) ~= 95) then
			dst[k] = self:CopyTable(v)
		else
			dst[k] = v
		end
	end
	return dst
end

sbf.TableStats = function(self)
  self:Print(format("%d tables created: %d out, %d in", created, out, #tables))
end