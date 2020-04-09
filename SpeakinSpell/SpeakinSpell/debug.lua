-- Author      : RisM
-- Create Date : 6/28/2009 3:48:10 PM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")

SpeakinSpell:PrintLoading("debug.lua")

-------------------------------------------------------------------------------
-- DEBUG MESSAGES
-------------------------------------------------------------------------------


function SpeakinSpell:DebugMsg(funcname, message)
	if SpeakinSpell.DEBUG_MODE or (SpeakinSpellSavedData and SpeakinSpellSavedData.ShowDebugMessages) then
		if funcname then
			self:Print(funcname.."() - "..tostring(message))
		else
			self:Print(message)
		end
	end
end


function SpeakinSpell:ErrorMsg(funcname, message)
	self:Print("ERROR: "..tostring(funcname).."() - "..tostring(message))
end


function SpeakinSpell:DebugMsgDumpString(name, value)
	self:DebugMsg( nil, string.format("%s=%s", tostring(name), tostring(value)) )
end


function SpeakinSpell:DebugMsgDumpBool(name, value)
	if value then
		self:DebugMsg(nil, tostring(name).."=true")
	else
		self:DebugMsg(nil, tostring(name).."=false")
	end
end


function SpeakinSpell:DebugMsgDumpTable(Table, name, maxdepth)
	-- make sure it's a table
	if type(Table) ~= "table" then
		self:DebugMsg( nil, tostring(name).."="..tostring(Table) )
		return
	end
	if not maxdepth then
		maxdepth = 1
	end
	-- enumerate the contents of the table
	for k,v in pairs(Table) do
		if (maxdepth > 1) and (type(v) == "table") then
			self:DebugMsgDumpTable(v, tostring(name).."."..tostring(k), maxdepth-1)
		else
			self:DebugMsg( nil, tostring(name).."["..tostring(k).."]".."="..tostring(v) )
		end
	end
end

