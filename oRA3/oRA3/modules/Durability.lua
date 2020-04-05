
-- Durability is transmitted when the player dies or zones or closes a merchant window
-- Durability information will be available from the oRA3 gui for everyone.

local oRA = LibStub("AceAddon-3.0"):GetAddon("oRA3")
local util = oRA.util
local module = oRA:NewModule("Durability", "AceEvent-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("oRA3")

module.VERSION = tonumber(("$Revision: 328 $"):sub(12, -3))

local durability = {} 

function module:OnRegister()
	-- should register durability table with the oRA3 core GUI for sortable overviews
	oRA:RegisterList(
		L["Durability"],
		durability,
		L["Name"],
		L["Average"],
		L["Minimum"],
		L["Broken"]
	)
	oRA.RegisterCallback(self, "OnStartup")
	oRA.RegisterCallback(self, "OnShutdown")
	oRA.RegisterCallback(self, "OnCommDurability")
	oRA.RegisterCallback(self, "OnCommRequestUpdate")
	
	self:RegisterChatCommand("radur", "OpenDurabilityCheck")
	self:RegisterChatCommand("radurability", "OpenDurabilityCheck")
end

function module:OnStartup()
	self:RegisterEvent("PLAYER_DEAD", "CheckDurability")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "CheckDurability")
	self:RegisterEvent("MERCHANT_CLOSED", "CheckDurability")
	
	self:CheckDurability()
end

function module:OnShutdown()
	wipe(durability)
	self:UnregisterEvent("PLAYER_DEAD")
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	self:UnregisterEvent("MERCHANT_CLOSED")
end

function module:OpenDurabilityCheck()
	oRA:OpenToList(L["Durability"])
end

function module:OnCommRequestUpdate()
	self:CheckDurability()
end

function module:CheckDurability(event)
	local cur, max, broken, vmin = 0, 0, 0, 100
	for i = 1, 18 do
		local imin, imax = GetInventoryItemDurability(i)
		if imin and imax then
			vmin = math.min(math.floor(imin / imax * 100), vmin)
			if imin == 0 then broken = broken + 1 end
			cur = cur + imin
			max = max + imax
		end
	end
	local perc = math.floor(cur / max * 100)
	oRA:SendComm("Durability", perc, vmin, broken)
end

-- Durability answer
function module:OnCommDurability(commType, sender, perc, minimum, broken)
	local k = util:inTable(durability, sender, 1)
	if not k then
		durability[#durability + 1] = { sender }
		k = #durability
	end
	durability[k][2] = perc
	durability[k][3] = minimum
	durability[k][4] = broken

	oRA:UpdateList(L["Durability"])
end

