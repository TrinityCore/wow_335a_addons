local Routes = LibStub("AceAddon-3.0"):GetAddon("Routes")
local TT = Routes:NewModule("TomTom", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Routes")

-- Aceopt table, defined later
local options
-- Our db
local db

------------------------------------------------------------------------------------------------------
-- TomTom support

local route_table
local route_name
local direction = 1
local node_num = 1
local callbacks
local stored_uid
local stored_nodeID


function TT:FindClosestVisibleRoute()
	if not TomTom then
		Routes:Print(L["TomTom is missing or disabled"])
		return
	end
	if not TomTom.SetCustomWaypoint then
		Routes:Print(L["An updated copy of TomTom is required for TomTom integration to work"])
		return
	end
	local Astrolabe = DongleStub("Astrolabe-0.4")
	local c, z, x, y = Astrolabe:GetCurrentPlayerPosition()
	local zone = GetRealZoneText()
	local closest_zone, closest_route, closest_node
	local min_distance = 1/0
	local defaults = db.defaults
	for route_name, route_data in pairs(db.routes[ Routes.zoneData[zone][4] ]) do  -- for each route in current zone
		if type(route_data) == "table" and type(route_data.route) == "table" and #route_data.route > 1 then  -- if it is valid
			if (not route_data.hidden and (route_data.visible or not defaults.use_auto_showhide)) or defaults.show_hidden then  -- if it is visible
				for i = 1, #route_data.route do  -- for each node
					local x2, y2 = Routes:getXY(route_data.route[i])
					local dist = Astrolabe:ComputeDistance(c, z, x, y, c, z, x2, y2)
					if dist < min_distance and dist > db.defaults.waypoint_hit_distance then
						-- Only consider nodes further than the hit distance
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

function TT:QueueFirstNode()
	if not TomTom then
		Routes:Print(L["TomTom is missing or disabled"])
		return
	end
	if not TomTom.SetCustomWaypoint then
		Routes:Print(L["An updated copy of TomTom is required for TomTom integration to work"])
		return
	end
	local a, b, c = self:FindClosestVisibleRoute()
	if a then
		if stored_uid then
			self:RemoveQueuedNode()
		end
		route_name = b
		route_table = db.routes[ Routes.zoneData[a][4] ][b]
		node_num = c
		local Astrolabe = DongleStub("Astrolabe-0.4")
		local c, z, x, y = Astrolabe:GetCurrentPlayerPosition()
		local x2, y2 = Routes:getXY(route_table.route[node_num])
		stored_nodeID = route_table.route[node_num]
		--stored_uid = TomTom:SetWaypoint(c, z, x2, y2, callbacks, false, false)
		stored_uid = TomTom:SetCustomWaypoint(c, z, x2*100, y2*100, callbacks, false, false)
		TomTom:SetCrazyArrow(stored_uid, db.defaults.waypoint_hit_distance, L["%s - Node %d"]:format(route_name, node_num))
	end
end

function TT.WaypointHit(event, uid, distance, dist, lastdist)
	if stored_uid == uid then
		--TomTom:ClearWaypoint(uid)
		TomTom:RemoveWaypoint(stored_uid)
		stored_uid = nil

		local route = route_table.route
		for i = 1, #route do
			if stored_nodeID == route[i] then
				-- Match found, get the next node to waypoint
				local Astrolabe = DongleStub("Astrolabe-0.4")
				local c, z, x, y = Astrolabe:GetCurrentPlayerPosition()
				node_num = i

				while true do
					-- Find next node that isn't within hit distance
					node_num = node_num + direction
					if node_num > #route then
						node_num = 1
					elseif node_num < 1 then
						node_num = #route
					end
					local x2, y2 = Routes:getXY(route[node_num])
					local dist = Astrolabe:ComputeDistance(c, z, x, y, c, z, x2, y2)
					if dist > db.defaults.waypoint_hit_distance then
						--Routes:Print("Adding node "..node_num)
						stored_nodeID = route[node_num]
						--stored_uid = TomTom:SetWaypoint(c, z, x2, y2, callbacks, false, false)
						stored_uid = TomTom:SetCustomWaypoint(c, z, x2*100, y2*100, callbacks, false, false)
						TomTom:SetCrazyArrow(stored_uid, db.defaults.waypoint_hit_distance, L["%s - Node %d"]:format(route_name, node_num))
						return
					end
					if node_num == i then
						-- Entire route is within hit_distance
						-- This is the terminating condition to prevent infinite loops
						return
					end
				end
			end
		end
	end
end

function TT:RemoveQueuedNode()
	if not TomTom then
		Routes:Print(L["TomTom is missing or disabled"])
		return
	end
	if not TomTom.SetCustomWaypoint then
		Routes:Print(L["An updated copy of TomTom is required for TomTom integration to work"])
		return
	end
	if stored_uid then
		--TomTom:ClearWaypoint(stored_uid)
		TomTom:RemoveWaypoint(stored_uid)
		stored_uid = nil
	end
end

function TT:ChangeWaypointDirection()
	direction = -direction
	Routes:Print(L["Direction changed"])
end

function TT:OnInitialize()
	db = Routes.db.global
	Routes.options.args.options_group.args.tomtom = options
	callbacks = {
		distance = {
			[db.defaults.waypoint_hit_distance] = TT.WaypointHit
		},
	}
end


------------------------------------------------------------------

options = {
	name = L["Waypoints (TomTom)"], type = "group",
	desc = L["Integrated support options for TomTom"],
	disabled = function() return not TomTom end,
	order = 300,
	args = {
		desc = {
			type  = "description",
			name  = L["This section implements TomTom support for Routes. Click Start to find the nearest node in a visible route in the current zone.\n"],
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
			set = function(k, v)
				db.defaults.waypoint_hit_distance = v
				-- Yes, it has to be a new table instead of modifying the existing table.
				-- This is because TomTom may still have table references to the old
				-- callbacks table from a previously set waypoint and modifying it will cause
				-- TomTom to malfunction (it expects the distance key to still exist)
				callbacks = {
					distance = {
						[v] = TT.WaypointHit
					},
				}
			end,
		},
		linebreak1 = {
			type = "description",
			name = "",
			order = 15,
		},
		start = {
			name  = L["Start using TomTom"], type = "execute",
			desc  = L["Start using TomTom by finding the closest visible route/node in the current zone and using that as the waypoint"],
			handler = TT,
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
			arg = "ROUTESTTSTART",
			order = 30,
		},
		linebreak2 = {
			type = "description",
			name = "",
			order = 35,
		},
		stop = {
			name  = L["Stop using TomTom"], type = "execute",
			desc  = L["Stop using TomTom by clearing the last queued node"],
			handler = TT,
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
			arg = "ROUTESTTSTOP",
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
			handler = TT,
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
			arg = "ROUTESTTCHANGEDIR",
			order = 70,
		},
	},
}


-- Setup keybinds in keybinding menu
BINDING_HEADER_Routes = L["Routes"]
BINDING_NAME_ROUTESTTSTART = L["Start using Waypoints (TomTom)"]
BINDING_NAME_ROUTESTTSTOP = L["Stop using Waypoints (TomTom)"]
BINDING_NAME_ROUTESTTCHANGEDIR = L["Change direction (TomTom)"]


-- vim: ts=4 noexpandtab
