local oRA = LibStub("AceAddon-3.0"):GetAddon("oRA3")
local util = oRA.util
local module = oRA:NewModule("Zone", "AceEvent-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("oRA3")

module.VERSION = tonumber(("$Revision: 150 $"):sub(12, -3))

local zones = {}
local factionList = {}
local tip = nil

local function createTooltip()
	tip = CreateFrame("GameTooltip")
	tip:SetOwner(WorldFrame, "ANCHOR_NONE")
	local lcache, rcache = {}, {}
	for i=1,30 do
		lcache[i], rcache[i] = tip:CreateFontString(), tip:CreateFontString()
		lcache[i]:SetFontObject(GameFontNormal); rcache[i]:SetFontObject(GameFontNormal)
		tip:AddFontStrings(lcache[i], rcache[i])
	end

	-- GetText cache tables, provide fast access to the tooltip's text
	tip.L = setmetatable({}, {
		__index = function(t, key)
			if tip:NumLines() >= key and lcache[key] then
				local v = lcache[key]:GetText()
				t[key] = v
				return v
			end
			return nil
		end,
	})
	local orig = tip.SetUnit
	tip.SetUnit = function(self, ...)
		self:ClearLines() -- Ensures tooltip's NumLines is reset
		for i in pairs(self.L) do self.L[i] = nil end -- Flush the metatable cache
		if not self:IsOwned(WorldFrame) then self:SetOwner(WorldFrame, "ANCHOR_NONE") end
		return orig(self, ...)
	end
end

-- GetZone and UPDATE_FACTIOn were taken from LibDogTag by Ckknight with permission.
local LEVEL_start = "^" .. (type(LEVEL) == "string" and LEVEL or "Level")
local PVP = type(PVP) == "string" and PVP or "PvP"
local function GetZone(unit)
	if UnitIsVisible(unit) then
		return nil
	end
	if not UnitIsConnected(unit) then
		return nil
	end
	tip:SetUnit(unit)
	local left_2 = tip.L[2]
	local left_3 = tip.L[3]
	if not left_2 or not left_3 then
		return nil
	end
	local hasGuild = not left_2:find(LEVEL_start)
	local factionText = not hasGuild and left_3 or tip.L[4]
	if factionText == PVP then
		factionText = nil
	end
	local hasFaction = factionText and not UnitPlayerControlled(unit) and not UnitIsPlayer(unit) and (UnitFactionGroup(unit) or factionList[factionText])
	if hasGuild and hasFaction then
		return tip.L[5]
	elseif hasGuild or hasFaction then
		return tip.L[4]
	else
		return left_3
	end
end


function module:OnRegister()
	oRA:RegisterList(
		L["Zone"],
		zones,
		L["Name"],
		L["Zone"]
	)
	oRA.RegisterCallback(self, "OnListSelected")
	oRA.RegisterCallback(self, "OnGroupChanged")
	oRA.RegisterCallback(self, "OnStartup", "UpdateZoneList")
	
	self:RegisterChatCommand("razone", "OpenZoneCheck")
	self:RegisterChatCommand("raz", "OpenZoneCheck")
end

function module:OnEnable()
	self:RegisterEvent("UPDATE_FACTION")
	self:UPDATE_FACTION()
end

function module:OnListSelected(event, list)
	if list == L["Zone"] then
		self:UpdateZoneList()
	end
end

function module:OpenZoneCheck()
	oRA:OpenToList(L["Zone"])
end

-- UPDATE_FACTION and getZone were taken from LibDogTag by ckknight with permission.
local in_UPDATE_FACTION = false
function module:UPDATE_FACTION()
	if in_UPDATE_FACTION then return end
	in_UPDATE_FACTION = true
	for i = 1, GetNumFactions() do
		local name,_,_,_,_,_,_,_,isHeader,isCollapsed = GetFactionInfo(i)
		if isHeader == 1 then
			if isCollapsed == 1 then
				local NumFactions = GetNumFactions()
				ExpandFactionHeader(i)
				NumFactions = GetNumFactions() - NumFactions
				for j = i+1, i+NumFactions do
					local name = GetFactionInfo(j)
					factionList[name] = true
				end
				CollapseFactionHeader(i)
			end
		else
			factionList[name] = true
		end
	end
	in_UPDATE_FACTION = false
end

function module:OnGroupChanged(event, status, members)
	self:UpdateZoneList()
	oRA:UpdateList(L["Zone"])
end

local function addPlayer(name, zone)
	if not name then return end
	local k = util:inTable(zones, name, 1)
	if not k then
		zones[#zones + 1] = { name }
		k = #zones
	end
	zone = zone or L["Unknown"]
	zones[k][2] = zone
end

function module:UpdateZoneList()
	wipe(zones)
	if oRA:InRaid() then
		for i = 1, GetNumRaidMembers() do
			local name, _, _, _, _, _, zone = GetRaidRosterInfo(i)
			addPlayer(name, zone)
		end
	elseif oRA:InParty() then
		if not tip then
			createTooltip()
		end
		addPlayer(UnitName("player"), GetRealZoneText())
		for i = 1, MAX_PARTY_MEMBERS do
			if GetPartyMember(i) then
				local name = UnitName("party"..i)
				local zone = GetZone("party"..i)
				addPlayer(name, zone)
			end
		end
	end
end

