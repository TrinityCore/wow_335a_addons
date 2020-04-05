local Routes = LibStub("AceAddon-3.0"):GetAddon("Routes", 1)
if not Routes then return end

local SourceName = "Gatherer"
local L = LibStub("AceLocale-3.0"):GetLocale("Routes")

------------------------------------------
-- setup
Routes.plugins[SourceName] = {}
local source = Routes.plugins[SourceName]

do
	local loaded = true
	local function IsActive() -- Can we gather data?
		return Gatherer and loaded
	end
	source.IsActive = IsActive

	-- stop loading if the addon is not enabled, or
	-- stop loading if there is a reason why it can't be loaded ("MISSING" or "DISABLED")
	local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(SourceName)
	if not enabled or (reason ~= nil) then
		loaded = false
		return
	end
end

------------------------------------------
-- functions

local amount_of = {}
local function Summarize(data, zone)
	local continent = Routes.zoneData[zone][3]
	continent, zone = floor(continent / 100), continent % 100

	for node, db_type, count in Gatherer.Storage.ZoneGatherNames(continent, zone) do
		local translatednode = Gatherer.Util.GetNodeName(node)
		data[ ("%s;%s;%s;%s"):format(SourceName, db_type, node, count) ] = ("%s - %s (%d)"):format(L[SourceName..db_type], translatednode, count)
	end

	return data
end
source.Summarize = Summarize

-- returns the english name, translated name for the node so we can store it was being requested
-- also returns the type of db for use with auto show/hide route
local translate_db_type = {
	["HERB"] = "Herbalism",
	["MINE"] = "Mining",
	["OPEN"] = "Treasure",
}
local function AppendNodes(node_list, zone, db_type, node_type)
	local continent = Routes.zoneData[zone][3]
	continent, zone = floor(continent / 100), continent % 100
	node_type = tonumber(node_type)

	for _, x, y in Gatherer.Storage.ZoneGatherNodes(continent, zone, node_type) do
		tinsert( node_list, floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5) )
	end

	-- return the node_type for auto-adding
	local translatednode = Gatherer.Util.GetNodeName(node_type)
	return translatednode, translatednode, translate_db_type[db_type]
end
source.AppendNodes = AppendNodes

-- continent/zone - GetMapZones() stuff
-- nodeType - HERB/MINE/OPEN
-- x, y - the coordinate [0,1]
-- node_name - the node being removed, can be an ID, as long as I can convert this to a localized or english string of the node such as "Copper Vein"
local function InsertNode(continent, zone, nodeType, x, y, node_name)
	--Routes:InsertNode(zone, coord, node_name)
end

local function DeleteNode(continent, zone, nodeType, x, y, node_name)
	--Routes:DeleteNode(zone, coord, node_name)
end

local function AddCallbacks()
	--Functions to add Gatherer callbacks
end
source.AddCallbacks = AddCallbacks

local function RemoveCallbacks()
	--Functions to remove Gatherer callbacks
end
source.RemoveCallbacks = RemoveCallbacks

-- vim: ts=4 noexpandtab
