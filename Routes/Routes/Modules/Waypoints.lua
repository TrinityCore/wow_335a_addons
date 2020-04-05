local Routes = LibStub("AceAddon-3.0"):GetAddon("Routes")
local Waypoints = Routes:NewModule("Waypoints", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Routes")

-- Aceopt table, defined later
local options
-- Our db
local db

------------------------------------------------------------------------------------------------------
-- Cartographer_Waypoints support

local route_table
local route_name
local direction = 1
local node_num = 1
local zone
local stored_hit_distance

local function round(num, digits) -- copied from various Cartographer modules
	-- banker's rounding
	local mantissa = 10^digits
	local norm = num*mantissa
	norm = norm + 0.5
	local norm_f = floor(norm)
	if norm == norm_f and (norm_f % 2) ~= 0 then
		return (norm_f-1)/mantissa
	end
	return norm_f/mantissa
end

function Waypoints:FindClosestVisibleRoute()
	if not (Cartographer and Cartographer:HasModule("Waypoints") and Cartographer:IsModuleActive("Waypoints")) then
		Routes:Print(L["Cartographer_Waypoints module is missing or disabled"])
		return
	end
	local zone = GetRealZoneText()
	local closest_zone, closest_route, closest_node
	local min_distance = 1/0
	local defaults = db.defaults
	for route_name, route_data in pairs(db.routes[ Routes.zoneData[zone][4] ]) do  -- for each route in current zone
		if type(route_data) == "table" and type(route_data.route) == "table" and #route_data.route > 1 then  -- if it is valid
			if (not route_data.hidden and (route_data.visible or not defaults.use_auto_showhide)) or defaults.show_hidden then  -- if it is visible
				for i = 1, #route_data.route do  -- for each node
					local x, y = floor(route_data.route[i] / 10000) / 10000, (route_data.route[i] % 10000) / 10000
					local dist = Cartographer:GetDistanceToPoint(x, y, zone) -- If you have Cartographer_Waypoints, then you have Cartographer
					if dist < min_distance then
						min_distance = dist
						closest_zone = zone
						closest_route = route_name
						closest_node = i
					end
				end
			end
		end
	end
	return closest_zone, closest_route, closest_node
end

function Waypoints:QueueFirstNode()
	if not (Cartographer and Cartographer:HasModule("Waypoints") and Cartographer:IsModuleActive("Waypoints")) then
		Routes:Print(L["Cartographer_Waypoints module is missing or disabled"])
		return
	end
	local BZR = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()
	local a, b, c = self:FindClosestVisibleRoute()
	if a then
		if stored_hit_distance then
			-- We are already following a route in Waypoints
			self:RemoveQueuedNode()
		end
		zone = a
		route_name = b
		route_table = db.routes[ Routes.zoneData[zone][4] ][b]
		node_num = c
		-- convert from GMID to CartID
		local x, y = Routes:getXY(route_table.route[node_num])
		local cartCoordID = round(x*10000, 0) + round(y*10000, 0)*10001
		Cartographer_Waypoints:AddRoutesWaypoint(BZR[zone], cartCoordID, L["%s - Node %d"]:format(route_name, node_num))
		self:RegisterMessage("CartographerWaypoints_WaypointHit", "WaypointHit")
		stored_hit_distance = Cartographer_Waypoints:GetWaypointHitDistance()
		Cartographer_Waypoints:SetWaypointHitDistance(db.defaults.waypoint_hit_distance)
	end
end

function Waypoints:WaypointHit(event, waypoint)
	if stored_hit_distance then
		local BZR = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()
		-- Try to match the removed waypointID with a node in the route. This
		-- is necessary because the route could have changed dynamically from node
		-- insertion/deletion/optimization/etc causing a change to the node numbers
		local id = tonumber((gsub(waypoint.WaypointID, BZR[zone], ""))) -- Extra brackets necessary to reduce to 1 return value
		if not id then return end -- Not a waypoint from this zone
		-- convert from CartID to GMID
		local x, y = (id % 10001)/10000, floor(id / 10001)/10000
		id = Routes:getID(x, y)
		local route = route_table.route
		for i = 1, #route do
			if id == route[i] then
				-- Match found, get the next node to waypoint
				node_num = i + direction
				if node_num > #route then
					node_num = 1
				elseif node_num < 1 then
					node_num = #route
				end
				--Routes:Print("Adding node "..node_num)
				-- convert from GMID to CartID
				local x, y = Routes:getXY(route[node_num])
				local cartCoordID = round(x*10000, 0) + round(y*10000, 0)*10001
				Cartographer_Waypoints:AddRoutesWaypoint(BZR[zone], cartCoordID, L["%s - Node %d"]:format(route_name, node_num))
				Cartographer_Waypoints:SetWaypointHitDistance(db.defaults.waypoint_hit_distance)
				break
			end
		end
	end
end

function Waypoints:RemoveQueuedNode()
	if not (Cartographer and Cartographer:HasModule("Waypoints") and Cartographer:IsModuleActive("Waypoints")) then
		Routes:Print(L["Cartographer_Waypoints module is missing or disabled"])
		return
	end
	local BZR = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()
	if stored_hit_distance then
		-- convert from GMID to CartID
		local x, y = Routes:getXY(route_table.route[node_num])
		local cartCoordID = round(x*10000, 0) + round(y*10000, 0)*10001
		Cartographer_Waypoints:CancelWaypoint(cartCoordID..BZR[zone])
		Cartographer_Waypoints:SetWaypointHitDistance(stored_hit_distance)
		stored_hit_distance = nil
		self:UnregisterMessage("CartographerWaypoints_WaypointHit")
	end
end

function Waypoints:ChangeWaypointDirection()
	direction = -direction
	Routes:Print(L["Direction changed"])
end

function Waypoints:OnInitialize()
	db = Routes.db.global
	Routes.options.args.options_group.args.waypoints = options
end


------------------------------------------------------------------

options = {
	name = L["Waypoints (Carto)"], type = "group",
	desc = L["Integrated support options for Cartographer_Waypoints"],
	disabled = function() return not (Cartographer and Cartographer:HasModule("Waypoints") and Cartographer:IsModuleActive("Waypoints")) end,
	order = 300,
	args = {
		desc = {
			type  = "description",
			name  = L["This section implements Cartographer_Waypoints support for Routes. Click Start to find the nearest node in a visible route in the current zone.\n"],
			order = 0,
		},
		hit_distance = {
			name = L["Waypoint hit distance"], type = "range",
			desc = L["This is the distance in yards away from a waypoint to consider as having reached it so that the next node in the route can be added as the waypoint"],
			min  = 5,
			max  = 80, -- This is the maximum range of node detection for "Find X" profession skills
			step = 1,
			order = 10,
			width = "double",
			arg = "waypoint_hit_distance",
		},
		linebreak1 = {
			type = "description",
			name = "",
			order = 15,
		},
		start = {
			name  = L["Start using Waypoints"], type = "execute",
			desc  = L["Start using Cartographer_Waypoints by finding the closest visible route/node in the current zone and using that as the waypoint"],
			handler = Waypoints,
			func  = "QueueFirstNode",
			order = 20,
		},
		keystart = {
			name = "Keybind to Start",
			desc = "Keybind to Start",
			type = "keybinding",
			handler = Routes.KeybindHelper,
			get = "GetKeybind",
			set = "SetKeybind",
			arg = "ROUTESCWPSTART",
			order = 30,
		},
		linebreak2 = {
			type = "description",
			name = "",
			order = 35,
		},
		stop = {
			name  = L["Stop using Waypoints"], type = "execute",
			desc  = L["Stop using Cartographer_Waypoints by clearing the last queued node"],
			handler = Waypoints,
			func  = "RemoveQueuedNode",
			order = 40,
		},
		keystop = {
			name = "Keybind to Stop",
			desc = "Keybind to Stop",
			type = "keybinding",
			handler = Routes.KeybindHelper,
			get = "GetKeybind",
			set = "SetKeybind",
			arg = "ROUTESCWPSTOP",
			order = 50,
		},
		linebreak3 = {
			type = "description",
			name = "",
			order = 55,
		},
		direction = {
			name  = L["Change direction"], type = "execute",
			desc  = L["Change the direction of the nodes in the route being added as the next waypoint"],
			handler = Waypoints,
			func  = "ChangeWaypointDirection",
			order = 60,
		},
		keychangedir = {
			name = "Keybind to Change",
			desc = "Keybind to Change",
			type = "keybinding",
			handler = Routes.KeybindHelper,
			get = "GetKeybind",
			set = "SetKeybind",
			arg = "ROUTESCWPCHANGEDIR",
			order = 70,
		},
	},
}


-- Setup keybinds in keybinding menu
BINDING_HEADER_Routes = L["Routes"]
BINDING_NAME_ROUTESCWPSTART = L["Start using Waypoints (Carto)"]
BINDING_NAME_ROUTESCWPSTOP = L["Stop using Waypoints (Carto)"]
BINDING_NAME_ROUTESCWPCHANGEDIR = L["Change direction (Carto)"]


-- vim: ts=4 noexpandtab
