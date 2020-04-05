
-- Resistance is transmitted after the player changes his gear.
-- Resistance information will be available from the oRA3 gui for everyone.
local oRA = LibStub("AceAddon-3.0"):GetAddon("oRA3")
local util = oRA.util
local module = oRA:NewModule("Resistance", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("oRA3")

module.VERSION = tonumber(("$Revision: 328 $"):sub(12, -3))

local resistances = {}

local f -- frame defined later

function module:OnRegister()
	oRA:RegisterList(
		L["Resistances"],
		resistances,
		L["Name"],
		"|cffb22f27" .. L["Fire"] .. "|r",
		"|cff64ae3f" .. L["Nature"] .. "|r",
		"|cff506fff" .. L["Frost"] .. "|r",
		"|cff6e52ff" .. L["Shadow"] .. "|r",
		L["Arcane"]
	)
	oRA.RegisterCallback(self, "OnCommResistance")
	oRA.RegisterCallback(self, "OnCommRequestUpdate")
	oRA.RegisterCallback(self, "OnStartup")
	oRA.RegisterCallback(self, "OnShutdown")
	
	self:RegisterChatCommand("rares", "OpenResistanceCheck")
	self:RegisterChatCommand("raresist", "OpenResistanceCheck")
	self:RegisterChatCommand("raresistance", "OpenResistanceCheck")
end

function module:OnStartup()
	f:RegisterEvent("UNIT_INVENTORY_CHANGED")
	f:RegisterEvent("UNIT_RESISTANCES")
	self:CheckResistance()
end

function module:OnShutdown()
	wipe(resistances)
	f:UnregisterEvent("UNIT_INVENTORY_CHANGED")
	f:UnregisterEvent("UNIT_RESISTANCES")
	f:SetScript("OnUpdate", nil)
end

function module:OpenResistanceCheck()
	oRA:OpenToList(L["Resistances"])
end

function module:OnCommRequestUpdate()
	self:CheckResistance()
end

do
	f = CreateFrame("Frame")
	local total = 0
	local function onUpdate(self, elapsed)
		total = total + elapsed
		if total > 2 then
			module:CheckResistance()
			total = 0
			self:SetScript("OnUpdate", nil)
		end
	end
	f:SetScript("OnEvent", function(self, event, unit)
		if unit and unit ~= "player" then return end
		if total > 0 then
			total = 0
		else
			self:SetScript("OnUpdate", onUpdate)
		end
	end)

	local ret = {}
	function module:CheckResistance()
		wipe(ret)
		for i = 2, 6 do
			local _, r = UnitResistance("player", i)
			ret[#ret + 1] = r
		end
		oRA:SendComm("Resistance", unpack(ret))
	end
end

-- Resistance answer
function module:OnCommResistance(commType, sender, fr, nr, frr, sr, ar)
	local k = util:inTable(resistances, sender, 1)
	if not k then
		resistances[#resistances + 1] = { sender }
		k = #resistances
	end
	resistances[k][2] = fr
	resistances[k][3] = nr
	resistances[k][4] = frr
	resistances[k][5] = sr
	resistances[k][6] = ar
	
	oRA:UpdateList(L["Resistances"])
end

