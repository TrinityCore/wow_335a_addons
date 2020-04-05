--[[
********************************************************************************
Routes
v1.2.8a
23 December 2009
(Written for Live Servers v3.3.0.11159)

Author: Xaroz @ EU Emerald Dream Alliance & Xinhuan @ US Blackrock Alliance
********************************************************************************

Description:
	Routes allow you to draw lines on the worldmap linking nodes together into
	an efficient farming route from existing databases. The route will be shown
	(by default) on the minimap and zone map as well.

Features:
	- Select node-types to build a line upon. The following are supported
	   * Cartographer_Fishing
	   * Cartographer_Mining
	   * Cartographer_Herbalism
	   * Cartographer_ExtractGas
	   * Cartographer_Treasure
	   * GatherMate
	   * Gatherer
	   * HandyNotes
	- Optimize your route using the traveling salesmen problem (TSP) ant
	  colony optimization (ACO) algorithm
	- Background (nonblocking) and foreground (blocking) optimization
	- Select color/thickness/transparency/visibility for each route
	- For any route created, finding a new node will try to add that as
	  optimal as possible
	- Quick clustering algorithm to merge nearby nodes into a single traveling
	  point
	- Quickly mark entire areas/regions as "out of bounds" or "taboo" to Routes,
	  meaning your routes will ignore nodes in those areas and avoid cross them
	- Fubar plugin available to quickly access your routes
	- Cartographer_Waypoints and TomTom support for quickly following a route
	- Works with Chinchilla's Expander minimap and SexyMap's HudMap!
	- Full in-game help file and FAQ, guiding you step by step on what to do! 

Download:
	The latest version of Routes is always available on
	- http://www.wowace.com/projects/routes/
	- http://wow.curse.com/downloads/wow-addons/details/routes.aspx
	- http://www.wowinterface.com/downloads/info11401-Routes.html

Localization:
	You can contribute by updating/adding localizations using the system on
	- http://www.wowace.com/projects/routes/localization/

Contact:
	If you find any bugs or have any suggestions, you can contact us on:

	Forum: http://forums.wowace.com/showthread.php?t=10369
	IRC  : Grum or Xinhuan on irc://irc.freenode.org/wowace
	Email: Grum ( routes AT grum DOT nl )
	       Xinhuan ( xinhuan AT gmail DOT com )
	       Paypal donations are welcome ;)
]]

Routes = LibStub("AceAddon-3.0"):NewAddon("Routes", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local Routes = Routes
local L   = LibStub("AceLocale-3.0"):GetLocale("Routes", false)
local G = {} -- was Graph-1.0, but we removed the dependency
Routes.G = G

-- database defaults
local db
local defaults = {
	global = {
		routes = {
			['*'] = { -- zone name, stored as the MapFile string constant
				['*'] = { -- route name
					route           = {},    -- point, point, point
					color           = nil,   -- defaults to db.defaults.color if nil
					width           = nil,   -- defaults to db.defaults.width if nil
					width_minimap   = nil,   -- defaults to db.defaults.width_minimap if nil
					width_battlemap = nil,   -- defaults to db.defaults.width_battlemap if nil
					hidden          = false, -- boolean
					looped          = 1,     -- looped? 1 is used (instead of true) because initial early code used 1 inside route creation code
					visible         = true,  -- visible?
					length          = 0,     -- length
					selection       = {
						['**'] = false  -- Node we're interested in tracking
					},
					db_type         = {
						['**'] = false  -- db_types used for use with auto show/hide
					},
					taboos          = {
						['**'] = false  -- taboo regions in effect
					},
					taboolist       = {} -- point, point, point
				},
			},
		},
		taboo = {
			['*'] = { -- zone name, stored as the MapFile string constant
				['*'] = { -- route name
					route           = {},    -- point, point, point
				},
			},
		},
		defaults = {            --    r,    g,    b,   a
			color           = {   1, 0.75, 0.75,   1 },
			hidden_color    = {   1,    1,    1, 0.5 },
			width           = 30,
			width_minimap   = 25,
			width_battlemap = 15,
			show_hidden     = false,
			update_distance = 1,
			fake_point      = -1,
			fake_data       = 'dummy',
			draw_minimap    = true,
			draw_worldmap   = true,
			draw_battlemap  = true,
			draw_indoors    = false,
			tsp = {
				initial_pheromone  = 0.1,   -- Initial pheromone trail value
				alpha              = 1,     -- Likelihood of ants to follow pheromone trails (larger value == more likely)
				beta               = 6,     -- Likelihood of ants to choose closer nodes (larger value == more likely)
				local_decay        = 0.2,   -- Governs local trail decay rate [0, 1]
				local_update       = 0.4,   -- Amount of pheromone to reinforce local trail update by
				global_decay       = 0.2,   -- Governs global trail decay rate [0, 1]
				twoopt_passes      = 3,     -- Number of times to perform 2-opt passes
				two_point_five_opt = false, -- Perform optimized 2-opt pass
			},
			prof_options = {
				Herbalism  = "Always",
				Mining     = "Always",
				Fishing    = "Always",
				Treasure   = "Always",
				ExtractGas = "Always",
				Note       = "Always",
			},
			use_auto_showhide = false,
			waypoint_hit_distance = 50,
			line_gaps = true,
			line_gaps_skip_cluster = true,
			cluster_dist = 60,
			callbacks = {
				['*'] = true
			}
		},
	}
}

-- Ace Options Table for our addon
local options
-- Plugins table
Routes.plugins = {}

-- localize some globals
local pairs, next = pairs, next
local tinsert, tremove = tinsert, tremove
local floor = math.floor
local format = string.format
local math_abs = math.abs
local math_sin = math.sin
local math_cos = math.cos
local WorldMapButton = WorldMapButton
local Minimap = Minimap
local GetPlayerFacing = GetPlayerFacing

------------------------------------------------------------------------------------------------------
-- Core Routes functions

--[[ Our coordinate format for Routes
Warning: These are convenience functions, most of the :getXY() and :getID()
code are inlined in critical code paths in various functions, changing
the coord storage format requires changing the inlined code in numerous
locations in addition to these 2 functions
]]
function Routes:getID(x, y)
	return floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)
end
function Routes:getXY(id)
	return floor(id / 10000) / 10000, (id % 10000) / 10000
end

function Routes:DrawWorldmapLines()
	-- setup locals
	local zone = self.zoneNames[GetCurrentMapContinent()*100 + GetCurrentMapZone()]
	local BattlefieldMinimap = BattlefieldMinimap  -- local reference if it exists
	local fh, fw = WorldMapButton:GetHeight(), WorldMapButton:GetWidth()
	local bfh, bfw  -- BattlefieldMinimap height and width
	local defaults = db.defaults

	-- clear all the lines
	G:HideLines(WorldMapButton)
	if (BattlefieldMinimap) then
		-- The Blizzard addon "Blizzard_BattlefieldMinimap" is loaded
		G:HideLines(BattlefieldMinimap)
		bfh, bfw = BattlefieldMinimap:GetHeight(), BattlefieldMinimap:GetWidth()
	end

	-- check for conditions not to draw the world map lines
	if not zone then return end -- player is not viewing a zone map of a continent
	local flag1 = defaults.draw_worldmap and WorldMapFrame:IsShown() -- Draw worldmap lines?
	local flag2 = defaults.draw_battlemap and BattlefieldMinimap and BattlefieldMinimap:IsShown() -- Draw battlemap lines?
	if (not flag1) and (not flag2) then	return end 	-- Nothing to draw

	for route_name, route_data in pairs( db.routes[ self.zoneData[zone][4] ] ) do
		if type(route_data) == "table" and type(route_data.route) == "table" and #route_data.route > 1 then
			local width = route_data.width or defaults.width
			local halfwidth = route_data.width_battlemap or defaults.width_battlemap
			local color = route_data.color or defaults.color

			if (not route_data.hidden and not route_data.editing and (route_data.visible or not defaults.use_auto_showhide)) or defaults.show_hidden then
				if route_data.hidden then color = defaults.hidden_color end
				local last_point
				local sx, sy
				if route_data.looped then
					last_point = route_data.route[ #route_data.route ]
					sx, sy = floor(last_point / 10000) / 10000, (last_point % 10000) / 10000
					sy = (1 - sy)
				end
				for i = 1, #route_data.route do
					local point = route_data.route[i]
					if point == defaults.fake_point then
						point = nil
					end
					if last_point and point then
						local ex, ey = floor(point / 10000) / 10000, (point % 10000) / 10000
						ey = (1 - ey)
						if (flag1) then
							G:DrawLine(WorldMapButton, sx*fw, sy*fh, ex*fw, ey*fh, width, color , "OVERLAY")
						end
						if (flag2) then
							G:DrawLine(BattlefieldMinimap, sx*bfw, sy*bfh, ex*bfw, ey*bfh, halfwidth, color , "OVERLAY")
						end
						sx, sy = ex, ey
					end
					last_point = point
				end
			end
		end
	end
end

local MinimapShapes = {
	-- quadrant booleans (same order as SetTexCoord)
	-- {upper-left, lower-left, upper-right, lower-right}
	-- true = rounded, false = squared
	["ROUND"]                 = { true,  true,  true,  true},
	["SQUARE"]                = {false, false, false, false},
	["CORNER-TOPLEFT"]        = { true, false, false, false},
	["CORNER-TOPRIGHT"]       = {false, false,  true, false},
	["CORNER-BOTTOMLEFT"]     = {false,  true, false, false},
	["CORNER-BOTTOMRIGHT"]    = {false, false, false,  true},
	["SIDE-LEFT"]             = { true,  true, false, false},
	["SIDE-RIGHT"]            = {false, false,  true,  true},
	["SIDE-TOP"]              = { true, false,  true, false},
	["SIDE-BOTTOM"]           = {false,  true, false,  true},
	["TRICORNER-TOPLEFT"]     = { true,  true,  true, false},
	["TRICORNER-TOPRIGHT"]    = { true, false,  true,  true},
	["TRICORNER-BOTTOMLEFT"]  = { true,  true, false,  true},
	["TRICORNER-BOTTOMRIGHT"] = {false,  true,  true,  true},
}

local minimap_radius
local minimap_rotate
local indoors = "indoor"

local MinimapSize = { -- radius of minimap
	indoor = {
		[0] = 150,
		[1] = 120,
		[2] = 90,
		[3] = 60,
		[4] = 40,
		[5] = 25,
	},
	outdoor = {
		[0] = 233 + 1/3,
		[1] = 200,
		[2] = 166 + 2/3,
		[3] = 133 + 1/3,
		[4] = 100,
		[5] = 66 + 2/3,
	},
}

local function is_round( dx, dy )
	local map_shape = GetMinimapShape and GetMinimapShape() or "ROUND"

	local q = 1
	if dx > 0 then q = q + 2 end -- right side
	-- XXX Tripple check this
	if dy > 0 then q = q + 1 end -- bottom side

	return MinimapShapes[map_shape][q]
end

local function is_inside( sx, sy, cx, cy, radius )
	local dx = sx - cx
	local dy = sy - cy

	if is_round( dx, dy ) then
		return dx*dx+dy*dy <= radius*radius
	else
		return math_abs( dx ) <= radius and math_abs( dy ) <= radius
	end
end

local function GetFacing()
	if GetPlayerFacing then return GetPlayerFacing() end
	return -MiniMapCompassRing:GetFacing()
end

local last_X, last_Y, last_facing = 1/0, 1/0, 1/0

-- implementation of cache - use zone in the key for an unique identifier
-- because every zone has a different X/Y location and possible yardsizes
local X_cache = {}
local Y_cache = {}
local XY_cache_mt = {
	__index = function(t, key)
		local zone, coord = (';'):split( key )
		local X = Routes.zoneData[zone][1] * floor(coord / 10000) / 10000
		local Y = Routes.zoneData[zone][2] * (coord % 10000) / 10000
		X_cache[key] = X
		Y_cache[key] = Y

		-- figure out which one to return
		if t == X_cache then return X else return Y end
	end
}

setmetatable( X_cache, XY_cache_mt )
setmetatable( Y_cache, XY_cache_mt )

function Routes:DrawMinimapLines(forceUpdate)
	if not db.defaults.draw_minimap then
		G:HideLines(Minimap)
		return
	end

	local _x, _y = GetPlayerMapPosition("player")

	-- invalid coordinates - clear map
	if not _x or not _y or _x < 0 or _x > 1 or _y < 0 or _y > 1 then
		G:HideLines(Minimap)
		return
	end

	local zone = GetRealZoneText()

	-- if we are indoors, or the zone we are in is not defined in our tables ... no routes
	if not zone or self.zoneData[zone][4] == "" or (not db.defaults.draw_indoors and indoors == "indoor") then
		G:HideLines(Minimap)
		return
	end

	local defaults = db.defaults
	local zoneW, zoneH = self.zoneData[zone][1], self.zoneData[zone][2]
	if not zoneW then return end
	local cx, cy = zoneW * _x, zoneH * _y

	local facing, sin, cos
	if minimap_rotate then
		facing = GetFacing()
	end

	if (not forceUpdate) and facing == last_facing and (last_X-cx)^2 + (last_Y-cy)^2 < defaults.update_distance^2 then
		-- no update!
		return
	end

	do
		local currentZoneID = self.zoneData[zone][3]
		local mapZoneID = GetCurrentMapContinent()*100 + GetCurrentMapZone()
		if currentZoneID ~= mapZoneID then
			-- we are viewing a map that isn't the current zone (usually a continent
			-- map), so the coordinates are wrong, unless we translate them
			return
		end
	end

	G:HideLines(Minimap)

	last_X = cx
	last_Y = cy
	last_facing = facing

	if minimap_rotate then
		sin = math_sin(facing)
		cos = math_cos(facing)
	end

	minimap_radius = MinimapSize[indoors][Minimap:GetZoom()]
	local radius = minimap_radius
	local radius2 = radius * radius

	local minX = cx - radius
	local maxX = cx + radius
	local minY = cy - radius
	local maxY = cy + radius

	local div_by_zero_nudge = 0.000001

	local minimap_w = Minimap:GetWidth()
	local minimap_h = Minimap:GetHeight()
	local scale_x = minimap_w / (radius*2)
	local scale_y = minimap_h / (radius*2)

	local minimapScale = Minimap:GetScale()
	
	for route_name, route_data in pairs( db.routes[ self.zoneData[zone][4] ] ) do
		if type(route_data) == "table" and type(route_data.route) == "table" and #route_data.route > 1 then
			-- store color/width
			local width = (route_data.width_minimap or defaults.width_minimap) / (minimapScale)
			local color = route_data.color or defaults.color

			-- unless we show hidden
			if (not route_data.hidden and (route_data.visible or not defaults.use_auto_showhide)) or defaults.show_hidden then
				-- use this special color
				if route_data.hidden then
					color = defaults.hidden_color
				end

				-- some state data
				local last_x = nil
				local last_y = nil
				local last_inside = nil

				-- if we loop - make sure the 'last' gets filled with the right info
				if route_data.looped and route_data.route[ #route_data.route ] ~= defaults.fake_point then
					local key = format("%s;%s", zone, route_data.route[ #route_data.route ])
					last_x, last_y = X_cache[key], Y_cache[key]
					if minimap_rotate then
						local dx = last_x - cx
						local dy = last_y - cy
						last_x = cx + dx*cos - dy*sin
						last_y = cy + dx*sin + dy*cos
					end
					last_inside = is_inside( last_x, last_y, cx, cy, radius )
				end

				-- loop over the route
				for i = 1, #route_data.route do
					local point = route_data.route[i]
					local cur_x, cur_y, cur_inside

					-- if we have a 'fake point' (gap) - clear current values
					if point == defaults.fake_point then
						cur_x = nil
						cur_y = nil
						cur_inside = false
					else
						local key = format("%s;%s", zone, point)
						cur_x, cur_y = X_cache[key], Y_cache[key]
						if minimap_rotate then
							local dx = cur_x - cx
							local dy = cur_y - cy
							cur_x = cx + dx*cos - dy*sin
							cur_y = cy + dx*sin + dy*cos
						end
						cur_inside = is_inside( cur_x, cur_y, cx, cy, radius )
					end

					-- check if we have any nil values (we cant draw) and check boundingbox
					if cur_x and cur_y and last_x and last_y and not (
						( cur_x < minX and last_x < minX ) or
						( cur_x > maxX and last_x > maxX ) or
						( cur_y < minY and last_y < minY ) or
						( cur_y > maxY and last_y > maxY )
					)
					then
						-- default all to not drawing
						local draw_sx = nil
						local draw_sy = nil
						local draw_ex = nil
						local draw_ey = nil

						-- both inside - easy! draw
						if cur_inside and last_inside then
							draw_sx = last_x
							draw_sy = last_y
							draw_ex = cur_x
							draw_ey = cur_y
						else
							-- direction of line
							local dx = last_x - cur_x
							local dy = last_y - cur_y

							-- calculate point on perpendicular line
							local zx = cx - dy
							local zy = cy + dx

							-- nudge it a bit so we dont get div by 0 problems
							if dx == 0 then dx = div_by_zero_nudge end
							if dy == 0 then dy = div_by_zero_nudge end

							-- calculate intersection point
							local nd = ((cx   -last_x)*(cy-zy) - (cx-zx)*(cy   -last_y)) /
									   ((cur_x-last_x)*(cy-zy) - (cx-zx)*(cur_y-last_y))

							-- perpendicular point (closest to center on the line given)
							local px = last_x + nd * -dx
							local py = last_y + nd * -dy

							-- check range of intersect point
							local dpc_x = cx - px
							local dpc_y = cy - py

							-- distance^2 of the perpendicular point
							local lenpc = dpc_x*dpc_x + dpc_y*dpc_y

							-- the line can only intersect if the perpendicular point is at
							-- least closer than the furthest away point (one of the corners)
							if lenpc < 2*radius2 then

								-- if inside - ready to draw
								if cur_inside then
									draw_ex = cur_x
									draw_ey = cur_y
								else
									-- if we're not inside we can still be in the square - if so dont do any intersection
									-- calculations yet
									if math_abs( cur_x - cx ) < radius and math_abs( cur_y - cy ) < radius then
										draw_ex = cur_x
										draw_ey = cur_y
									else
										-- need to intersect against the square
										-- likely x/y to intersect with
										local minimap_cur_x  = cx + radius * (dx < 0 and 1 or -1)
										local minimap_cur_y  = cy + radius * (dy < 0 and 1 or -1)

										-- which intersection is furthest?
										local delta_cur_x = (minimap_cur_x - cur_x) / -dx
										local delta_cur_y = (minimap_cur_y - cur_y) / -dy

										-- dark magic - needs to be changed to positive signs whenever i can care about it
										if delta_cur_x < delta_cur_y and delta_cur_x < 0 then
											draw_ex = minimap_cur_x
											draw_ey = cur_y + -dy*delta_cur_x
										else
											draw_ex = cur_x + -dx*delta_cur_y
											draw_ey = minimap_cur_y
										end

										-- check if we didn't calculate some wonky offset - has to be inside with
										-- some slack on accuracy
										if math_abs( draw_ex - cx ) > radius*1.01 or
										   math_abs( draw_ey - cy ) > radius*1.01
										then
											draw_ex = nil
											draw_ey = nil
										end
									end

									-- we might have a round corner here - lets see if the quarter with the intersection is round
									if draw_ex and draw_ey and is_round( draw_ex - cx, draw_ey - cy ) then
										-- if we are also within the circle-range
										if lenpc < radius2 then
											-- circle intersection
											local dcx = cx - cur_x
											local dcy = cy - cur_y
											local len_dc = dcx*dcx + dcy*dcy

											local len_d = dx*dx + dy*dy
											local len_ddc = dx*dcx + dy*dcy

											-- discriminant
											local d_sqrt = ( len_ddc*len_ddc - len_d * (len_dc - radius2) )^0.5

											-- calculate point
											draw_ex = cur_x - dx * (-len_ddc + d_sqrt) / len_d
											draw_ey = cur_y - dy * (-len_ddc + d_sqrt) / len_d

											-- have to be on the *same* side of the perpendicular point else it's fake
											if (draw_ex - px)/math_abs(draw_ex - px) ~= (cur_x- px)/math_abs(cur_x - px) or
											   (draw_ey - py)/math_abs(draw_ey - py) ~= (cur_y- py)/math_abs(cur_y - py)
											then
												draw_ex = nil
												draw_ey = nil
											end
										else
											draw_ex = nil
											draw_ey = nil
										end
									end
								end

								-- if inside - ready to draw
								if last_inside then
									draw_sx = last_x
									draw_sy = last_y
								else
									-- if we're not inside we can still be in the square - if so dont do any intersection
									-- calculations yet
									if math_abs( last_x - cx ) < radius and math_abs( last_y - cy ) < radius then
										draw_sx = last_x
										draw_sy = last_y
									else
										-- need to intersect against the square
										-- likely x/y to intersect with
										local minimap_last_x = cx + radius * (dx > 0 and 1 or -1)
										local minimap_last_y = cy + radius * (dy > 0 and 1 or -1)

										-- which intersection is furthest?
										local delta_last_x = (minimap_last_x - last_x) / dx
										local delta_last_y = (minimap_last_y - last_y) / dy

										-- dark magic - needs to be changed to positive signs whenever i can care about it
										if delta_last_x < delta_last_y and delta_last_x < 0 then
											draw_sx = minimap_last_x
											draw_sy = last_y + dy*delta_last_x
										else
											draw_sx = last_x + dx*delta_last_y
											draw_sy = minimap_last_y
										end

										-- check if we didn't calculate some wonky offset - has to be inside with
										-- some slack on accuracy
										if math_abs( draw_sx - cx ) > radius*1.01 or
										   math_abs( draw_sy - cy ) > radius*1.01
										then
											draw_sx = nil
											draw_sy = nil
										end
									end

									-- we might have a round corner here - lets see if the quarter with the intersection is round
									if draw_sx and draw_sy and is_round( draw_sx - cx, draw_sy - cy ) then
										-- if we are also within the circle-range
										if lenpc < radius2 then
											-- circle intersection
											local dcx = cx - cur_x
											local dcy = cy - cur_y
											local len_dc = dcx*dcx + dcy*dcy

											local len_d = dx*dx + dy*dy
											local len_ddc = dx*dcx + dy*dcy

											-- discriminant
											local d_sqrt = ( len_ddc*len_ddc - len_d * (len_dc - radius2) )^0.5

											-- calculate point
											draw_sx = cur_x - dx * (-len_ddc - d_sqrt) / len_d
											draw_sy = cur_y - dy * (-len_ddc - d_sqrt) / len_d

											-- have to be on the *same* side of the perpendicular point else it's fake
											if (draw_sx - px)/math_abs(draw_sx - px) ~= (last_x- px)/math_abs(last_x - px) or
											   (draw_sy - py)/math_abs(draw_sy - py) ~= (last_y- py)/math_abs(last_y - py)
											then
												draw_sx = nil
												draw_sy = nil
											end
										else
											draw_sx = nil
											draw_sy = nil
										end
									end
								end
							end
						end

						if draw_sx and draw_sy and draw_ex and draw_ey then
							-- translate to left bottom corner and apply scale
							draw_sx =			 (draw_sx - minX) * scale_x
							draw_sy = minimap_h - (draw_sy - minY) * scale_y
							draw_ex =			 (draw_ex - minX) * scale_x
							draw_ey = minimap_h - (draw_ey - minY) * scale_y

							if defaults.line_gaps then
								-- shorten the line by 5 pixels (scaled) on endpoints inside the Minimap
								local gapConst = 5 / minimapScale
								local dx = draw_sx - draw_ex
								local dy = draw_sy - draw_ey
								local l = (dx*dx + dy*dy)^0.5
								local x = gapConst * dx / l
								local y = gapConst * dy / l
								local shorten1, shorten2
								if last_inside then shorten1 = true else shorten1 = false end
								if cur_inside then shorten2 = true else shorten2 = false end
								if shorten2 and route_data.metadata and defaults.line_gaps_skip_cluster and #route_data.metadata[i] > 1 then
									shorten2 = false
								end
								if shorten1 and route_data.metadata and defaults.line_gaps_skip_cluster and #route_data.metadata[(i-1 == 0) and #route_data.route or i-1] > 1 then
									shorten1 = false
								end
								if shorten1 and shorten2 and l > (gapConst*2) then -- draw if line is 10 or more pixels (scaled)
									G:DrawLine( Minimap, draw_sx-x, draw_sy-y, draw_ex+x, draw_ey+y, width, color, "ARTWORK")
								elseif shorten1 and not shorten2 and l > gapConst then
									G:DrawLine( Minimap, draw_sx-x, draw_sy-y, draw_ex, draw_ey, width, color, "ARTWORK")
								elseif shorten2 and not shorten1 and l > gapConst then
									G:DrawLine( Minimap, draw_sx, draw_sy, draw_ex+x, draw_ey+y, width, color, "ARTWORK")
								elseif not shorten1 and not shorten2 then
									G:DrawLine( Minimap, draw_sx, draw_sy, draw_ex, draw_ey, width, color, "ARTWORK")
								end
							else
								G:DrawLine( Minimap, draw_sx, draw_sy, draw_ex, draw_ey, width, color, "ARTWORK")
							end
						end
					end

					-- store last point
					last_x = cur_x
					last_y = cur_y
					last_inside = cur_inside
				end
			end
		end
	end
end

-- This frame is to throttle InsertNode() and DeleteNode() calls so that
-- redrawing the map lines are delayed by 1 frame. These 2 functions can
-- potentially be spammed by a source database importing nodes.
local throttleFrame = CreateFrame("Frame")
throttleFrame:Hide()
throttleFrame:SetScript("OnUpdate", function(self, elapsed)
	Routes:DrawWorldmapLines()
	Routes:DrawMinimapLines(true)
	self:Hide()
end)

-- Accepts a zone name, coord and node_name
-- for inserting into relevant routes
-- Zone name must be localized, node_name can be english or localized
function Routes:InsertNode(zone, coord, node_name)
	for route_name, route_data in pairs( db.routes[ self.zoneData[zone][4] ] ) do
		-- for every route check if the route is created with this node
		if route_data.selection then
			for k, v in pairs(route_data.selection) do
				if k == node_name or v == node_name then
					-- Add the node
					local x, y = self:getXY(coord)
					local flag = false
					for tabooname, used in pairs(route_data.taboos) do
						if used and self:IsNodeInTaboo(x, y, db.taboo[ self.zoneData[zone][4] ][tabooname]) then
							flag = true
						end
					end
					if flag then
						tinsert(route_data.taboolist, coord)
					else
						route_data.length = self.TSP:InsertNode(route_data.route, route_data.metadata, zone, coord, route_data.cluster_dist or 65) -- 65 is the old default
						throttleFrame:Show()
					end
					break
				end
			end
		end
	end
end

-- Accepts a zone name, coord and node_name
-- for deleting into relevant routes
-- Zone name must be localized, node_name can be english or localized
function Routes:DeleteNode(zone, coord, node_name)
	for route_name, route_data in pairs( db.routes[ self.zoneData[zone][4] ] ) do
		-- for every route check if the route is created with this node
		if route_data.selection then
			local flag = false
			for k, v in pairs(route_data.selection) do
				if k == node_name or v == node_name then
					-- Delete the node if it exists in this route
					if route_data.metadata then
						-- this is a clustered route
						for i = 1, #route_data.route do
							local num_data = #route_data.metadata[i]
							for j = 1, num_data do
								if coord == route_data.metadata[i][j] then
									-- recalcuate centroid
									local x, y = self:getXY(coord)
									local cx, cy = self:getXY(route_data.route[i])
									if num_data > 1 then
										-- more than 1 node in this cluster
										cx, cy = (cx * num_data - x) / (num_data-1), (cy * num_data - y) / (num_data-1)
										tremove(route_data.metadata[i], j)
										route_data.route[i] = self:getID(cx, cy)
									else
										-- only 1 node in this cluster, just remove it
										tremove(route_data.metadata, i)
										tremove(route_data.route, i)
									end
									route_data.length = self.TSP:PathLength(route_data.route, zone)
									throttleFrame:Show()
									flag = true
									break
								end
							end
							if flag then break end
						end
					else
						-- this is not a clustered route
						for i = 1, #route_data.route do
							if coord == route_data.route[i] then
								tremove(route_data.route, i)
								route_data.length = self.TSP:PathLength(route_data.route, zone)
								throttleFrame:Show()
								flag = true
								break
							end
						end
					end
					if not flag then
						-- node not found yet, so search the taboolist
						for i = 1, #route_data.taboolist do
							if route_data.taboolist[i] == coord then
								tremove(route_data.taboolist, i)
								flag = true
								break
							end
						end
					end
				end
				if flag then break end
			end
		end
	end
end

-- This function upgrades the Routes old storage format which was dependant
-- on LibBabble-Zone-3.0 to the new format that doesn't require it. Note that
-- this upgrade function only works on enUS or enGB clients because the old
-- format uses English strings, the new format uses mapfile names.
function Routes:UpgradeStorageFormat1()
	local t = {}
	for zone, zone_table in pairs(db.routes) do
		if self.zoneMapFile[zone] == nil then
			-- This zone is a string that doesn't correspond to any of the
			-- mapfile names. So we try to obtain the mapfile name
			local mapfile = self.zoneData[zone][4]
			if mapfile == "" then
				-- invalid zones return "" due to a metatable, delete the
				-- whole zone
				db.routes[zone] = nil
			else
				-- We found a match, store the zone_table temporarily first
				-- and delete the whole zone (because we cannot insert new
				-- keys into db.routes[] while iterating over it)
				t[mapfile] = zone_table
				db.routes[zone] = nil
			end
		end
	end
	for mapfile, zone_table in pairs(t) do
		-- Now assign the new zone mapfile keys
		db.routes[mapfile] = zone_table
		t[mapfile] = nil
	end
	t = nil

	-- Delete invalid zones from the taboo table
	for zone, zone_table in pairs(db.taboo) do
		if self.zoneMapFile[zone] == nil then
			db.taboo[zone] = nil
		end
	end
end

local function GetZoneDescText(info)
	local count = 0
	for route_name, route_table in pairs(db.routes[info.arg]) do
		if #route_table.route > 0 then
			count = count + 1
		end
	end
	return L["You have |cffffd200%d|r route(s) in |cffffd200%s|r."]:format(count, Routes.zoneMapFile[info.arg])
end
local function GetZoneTabooDescText(info)
	local count = 0
	for taboo_name, taboo_table in pairs(db.taboo[info.arg]) do
		if #taboo_table.route > 0 then
			count = count + 1
		end
	end
	return L["You have |cffffd200%d|r taboo region(s) in |cffffd200%s|r."]:format(count, Routes.zoneMapFile[info.arg])
end


------------------------------------------------------------------------------------------------------
-- General event functions

function Routes:OnInitialize()
	-- Initialize database
	self.db = LibStub("AceDB-3.0"):New("RoutesDB", defaults)
	db = self.db.global
	self.options = options

	-- Initialize the ace options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Routes", options)
	self:RegisterChatCommand(L["routes"], function() LibStub("AceConfigDialog-3.0"):Open("Routes") end)

	-- Upgrade old storage format (which was dependant on LibBabble-Zone-3.0
	-- to the new format that doesn't require it
	-- Also delete any invalid zones
	self:UpgradeStorageFormat1()

	-- Generate ace options table for each route
	local opts = options.args.routes_group.args
	for zone, zone_table in pairs(db.routes) do
		if next(zone_table) == nil then
			-- cleanup the empty zone
			db.routes[zone] = nil
		else
			local localizedZoneName = self.zoneMapFile[zone]
			opts[zone] = {
				type = "group",
				name = localizedZoneName,
				desc = L["Routes in %s"]:format(localizedZoneName),
				args = {},
			}
			for route, route_table in pairs(zone_table) do
				local routekey = route:gsub("%s", "\255") -- can't have spaces in the key
				opts[zone].args[routekey] = self:CreateAceOptRouteTable(zone, route)
				route_table.editing = nil -- in case server crashes during edit.
			end
			opts[zone].args.desc = {
				type = "description",
				name = GetZoneDescText,
				arg = zone,
				order = 0,
			}
		end
	end

	-- Generate ace options table for each taboo region
	local opts = options.args.taboo_group.args
	for zone, zone_table in pairs(db.taboo) do
		if next(zone_table) == nil then
			-- cleanup the empty zone
			db.taboo[zone] = nil
		else
			local localizedZoneName = self.zoneMapFile[zone]
			opts[zone] = {
				type = "group",
				name = localizedZoneName,
				desc = L["Taboos in %s"]:format(localizedZoneName),
				args = {},
			}
			for taboo in pairs(zone_table) do
				local tabookey = taboo:gsub("%s", "\255") -- can't have spaces in the key
				opts[zone].args[tabookey] = self:CreateAceOptTabooTable(zone, taboo)
			end
			opts[zone].args.desc = {
				type = "description",
				name = GetZoneTabooDescText,
				arg = zone,
				order = 0,
			}
		end
	end
	self:SetupSourcesOptTables()
	self:RegisterEvent("ADDON_LOADED")
end

local timerFrame = CreateFrame("Frame")
timerFrame:Hide()
timerFrame.elapsed = 0
timerFrame:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed > 0.025 or self.force then -- throttle to a max of 40 redraws per sec
		self.elapsed = 0                       -- kinda unnecessary since at default 1 yard refresh, its limited to 36 redraws/sec
		Routes:DrawMinimapLines(self.force)    -- only need 25 redraws/sec to perceive smooth motion anyway
		self.force = nil
	end
end)

local function SetZoomHook()
	timerFrame.force = true
end

function Routes:MINIMAP_UPDATE_ZOOM()
	local zoom = Minimap:GetZoom()
	if GetCVar("minimapZoom") == GetCVar("minimapInsideZoom") then
		Minimap:SetZoom(zoom < 2 and zoom + 1 or zoom - 1)
	end
	indoors = GetCVar("minimapZoom")+0 == Minimap:GetZoom() and "outdoor" or "indoor"
	Minimap:SetZoom(zoom)
end

function Routes:CVAR_UPDATE(event, cvar, value)
	if cvar == "ROTATE_MINIMAP" then
		minimap_rotate = value == "1"
	end
end

function Routes:OnEnable()
	-- World Map line drawing
	self:RegisterEvent("WORLD_MAP_UPDATE", "DrawWorldmapLines")
	-- Minimap line drawing
	self:SecureHook(Minimap, "SetZoom", SetZoomHook)
	if db.defaults.draw_minimap then
		self:RegisterEvent("MINIMAP_UPDATE_ZOOM")
		self:RegisterEvent("CVAR_UPDATE")
		timerFrame:Show()
		self:RegisterEvent("MINIMAP_ZONE_CHANGED", "DrawMinimapLines", true)
		minimap_rotate = GetCVar("rotateMinimap") == "1"
		-- Notes: Do not call self:MINIMAP_UPDATE_ZOOM() here because the CVARs aren't applied yet.
		-- MINIMAP_UPDATE_ZOOM gets fired automatically by wow when it applies the CVARs.
	end
	for addon, plugin_table in pairs(Routes.plugins) do
		if db.defaults.callbacks[addon] and plugin_table.IsActive() then
			plugin_table.AddCallbacks()
		end
	end
end

function Routes:OnDisable()
	-- Ace3 unregisters all events and hooks for us on disable
	for addon, plugin_table in pairs(Routes.plugins) do
		if db.defaults.callbacks[addon] and plugin_table.IsActive() then
			plugin_table.RemoveCallbacks()
		end
	end
	timerFrame:Hide()
end

function Routes:ADDON_LOADED(event, addon)
	if self.plugins[addon] then
		options.args.add_group.args[addon].disabled = false
		options.args.add_group.args[addon].guiHidden = false
		if db.defaults.callbacks[addon] and self.plugins[addon].IsActive() then
			self.plugins[addon].AddCallbacks()
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Ace options table stuff

do
	-- Helper functions for setting/clearing keybinds in our option tables
	local KeybindHelper = {}
	Routes.KeybindHelper = KeybindHelper

	local t = {}
	function KeybindHelper:MakeKeyBindingTable(...)
		for k in pairs(t) do t[k] = nil end
		for i = 1, select("#", ...) do
			local key = select(i, ...)
			if key ~= "" then
				tinsert(t, key)
			end
		end
		return t
	end

	function KeybindHelper:GetKeybind(info)
		return table.concat(self:MakeKeyBindingTable(GetBindingKey(info.arg)), ", ")
	end

	function KeybindHelper:SetKeybind(info, key)
		if key == "" then
			local t = self:MakeKeyBindingTable(GetBindingKey(info.arg))
			for i = 1, #t do
				SetBinding(t[i])
			end
		else
			local oldAction = GetBindingAction(key)
			local frame = LibStub("AceConfigDialog-3.0").OpenFrames["Routes"]
			if frame then
				if ( oldAction ~= "" and oldAction ~= info.arg ) then
					frame:SetStatusText(KEY_UNBOUND_ERROR:format(GetBindingText(oldAction, "BINDING_NAME_")))
				else
					frame:SetStatusText(KEY_BOUND)
				end
			end
			SetBinding(key, info.arg)
		end
		SaveBindings(GetCurrentBindingSet())
	end
end


options = {
	type = "group",
	name = L["Routes"],
	get = function(k) return db.defaults[k.arg] end,
	set = function(k, v) db.defaults[k.arg] = v; Routes:DrawWorldmapLines(); Routes:DrawMinimapLines(true); end,
	args = {
		options_group = {
			type = "group",
			name = L["Options"],
			desc = L["Options"],
			order = 0,
			--args = {}, -- defined later
		},
		add_group = {
			type = "group",
			name = L["Add"],
			desc = L["Add"],
			order = 100,
			--args = {}, -- defined later
		},
		routes_group = {
			type = "group",
			name = L["Routes"],
			desc = L["Routes"],
			order = 200,
			args = {},
		},
		taboo_group = {
			type = "group",
			name = L["Taboos"],
			desc = L["Taboos"],
			order = 250,
			args = {},
		},
		faq_group = {
			type = "group",
			name = L["Help File"],
			desc = L["Help File"],
			order = 300,
			args = {
				overview = {
					type = "group",
					name = L["Overview"],
					desc = L["Overview"],
					order = 10,
					args = {
						header = {
							type = "header",
							name = L["Overview"],
							order = 0,
						},
						desc = {
							type = "description",
							name = L["OVERVIEW_TEXT"],
							order = 1,
						},
					},
				},
				create_route = {
					type = "group",
					name = L["Creating a route"],
					desc = L["Creating a route"],
					order = 20,
					args = {
						header = {
							type = "header",
							name = L["Creating a route"],
							order = 0,
						},
						desc = {
							type = "description",
							name = L["CREATE_ROUTE_TEXT"],
							order = 1,
						},
					},
				},
				optimizing_route = {
					type = "group",
					name = L["Optimizing a route"],
					desc = L["Optimizing a route"],
					order = 30,
					args = {
						header = {
							type = "header",
							name = L["Optimizing a route"],
							order = 0,
						},
						desc = {
							type = "description",
							name = L["OPTIMIZING_ROUTE_TEXT"],
							order = 1,
						},
					},
				},
				customizing_route = {
					type = "group",
					name = L["Customizing route display"],
					desc = L["Customizing route display"],
					order = 40,
					args = {
						header = {
							type = "header",
							name = L["Customizing route display"],
							order = 0,
						},
						desc = {
							type = "description",
							name = L["CUSTOMIZING_ROUTE_TEXT"],
							order = 1,
						},
					},
				},
				create_taboos = {
					type = "group",
					name = L["Creating a taboo region"],
					desc = L["Creating a taboo region"],
					order = 50,
					args = {
						header = {
							type = "header",
							name = L["Creating a taboo region"],
							order = 0,
						},
						desc = {
							type = "description",
							name = L["CREATE_TABOOS_TEXT"],
							order = 1,
						},
					},
				},
				waypoints_integration = {
					type = "group",
					name = L["Waypoints Integration"],
					desc = L["Waypoints Integration"],
					order = 60,
					args = {
						header = {
							type = "header",
							name = L["Waypoints Integration"],
							order = 0,
						},
						desc = {
							type = "description",
							name = L["WAYPOINTS_INTEGRATION_TEXT"],
							order = 1,
						},
					},
				},
				auto_update = {
					type = "group",
					name = L["Automatic route updating"],
					desc = L["Automatic route updating"],
					order = 70,
					args = {
						header = {
							type = "header",
							name = L["Automatic route updating"],
							order = 0,
						},
						desc = {
							type = "description",
							name = L["AUTOMATIC_UPDATE_TEXT"],
							order = 1,
						},
					},
				},
				faq = {
					type = "group",
					name = L["FAQ"],
					desc = L["Frequently Asked Questions"],
					order = 100,
					args = {
						header = {
							type = "header",
							name = L["Frequently Asked Questions"],
							order = 0,
						},
						desc = {
							type = "description",
							name = L["FAQ_TEXT"],
							order = 1,
						},
					},
				},
			},
		},
	}
}

options.args.options_group.args = {
	-- Mapdrawing menu entry
	drawing = {
		name = L["Map Drawing"], type = "group",
		desc = L["Map Drawing"],
		order = 100,
		args = {
			linedisplay_group = {
				name = L["Toggle drawing on each of the maps."], type = "group",
				desc = L["Toggle drawing on each of the maps."],
				inline = true,
				order = 100,
				args = {
					worldmap_toggle = {
						name = L["Worldmap"],
						desc = L["Worldmap drawing"],
						type = "toggle",
						order = 100,
						arg = "draw_worldmap",
					},
					minimap_toggle = {
						name = L["Minimap"],
						desc = L["Minimap drawing"],
						type  = "toggle",
						order = 200,
						get  = function(info) return db.defaults.draw_minimap end,
						set  = function(info, v)
							db.defaults.draw_minimap = v
							if v then
								Routes:RegisterEvent("MINIMAP_UPDATE_ZOOM")
								Routes:RegisterEvent("CVAR_UPDATE")
								timerFrame:Show()
								Routes:RegisterEvent("MINIMAP_ZONE_CHANGED", "DrawMinimapLines", true)
								minimap_rotate = GetCVar("rotateMinimap") == "1"
								Routes:MINIMAP_UPDATE_ZOOM()  -- This has a DrawMinimapLines(true) call in it, and sets an "indoors" variable
							else
								Routes:UnregisterEvent("MINIMAP_UPDATE_ZOOM")
								Routes:UnregisterEvent("CVAR_UPDATE")
								timerFrame:Hide()
								Routes:UnregisterEvent("MINIMAP_ZONE_CHANGED")
								G:HideLines(Minimap)
							end
						end,
					},
					battlemap_toggle = {
						name = L["Zone Map"],
						desc = L["Zone Map drawing"],
						type  = "toggle",
						order = 300,
						arg = "draw_battlemap",
					},
					indoors_toggle = {
						name = L["Minimap when indoors"],
						desc = L["Draw on minimap when indoors"],
						type  = "toggle",
						order = 400,
						arg = "draw_indoors",
						disabled = function() return not db.defaults.draw_minimap end,
					},
				},
			},
			default_group = {
				name = L["Set the width of lines on each of the maps."], type = "group",
				desc = L["Normal lines"],
				inline = true,
				order = 200,
				args = {
					width = {
						name = L["Worldmap"], type = "range",
						desc = L["Width of the line in the Worldmap"],
						min = 10, max = 100, step = 1,
						arg = "width",
						order = 100,
					},
					width_minimap = {
						name = L["Minimap"], type = "range",
						desc = L["Width of the line in the Minimap"],
						min = 10, max = 100, step = 1,
						arg = "width_minimap",
						order = 110,
					},
					width_battlemap = {
						name = L["Zone Map"], type = "range",
						desc = L["Width of the line in the Zone Map"],
						min = 10, max = 100, step = 1,
						arg = "width_battlemap",
						order = 120,
					},
				},
			},
			color_group = {
				name = L["Color of lines"], type = "group",
				desc = L["Color of lines"],
				inline = true,
				order = 300,
				get = function(info) return unpack(db.defaults[info.arg]) end,
				set = function(info, r, g, b, a)
					local c = db.defaults[info.arg]
					c[1] = r; c[2] = g; c[3] = b; c[4] = a
					Routes:DrawWorldmapLines()
					Routes:DrawMinimapLines(true)
				end,
				args = {
					color = {
						name = L["Default route"], type = "color",
						desc = L["Change default route color"],
						arg  = "color",
						hasAlpha = true,
						order = 200,
					},
					hidden_color = {
						name = L["Hidden route"], type = "color",
						desc = L["Change default hidden route color"],
						arg  = "hidden_color",
						hasAlpha = true,
						order = 400,
					},
				},
			},
			line_gaps_group = {
				name = L["Line gaps"], type = "group",
				desc = L["Line gaps"],
				inline = true,
				order = 400,
				args = {
					line_gaps = {
						name = L["Draw line gaps"], type = "toggle",
						desc = L["Shorten the lines drawn on the minimap slightly so that they do not overlap the icons and minimap tracking blips."],
						arg  = "line_gaps",
						order = 400,
					},
					line_gaps_skip_cluster = {
						name = L["Skip clustered node points"], type = "toggle",
						desc = L["Do not draw gaps for clustered node points in routes."],
						arg  = "line_gaps_skip_cluster",
						disabled = function() return not db.defaults.line_gaps end,
						order = 400,
					},
				},
			},
			show_hidden = {
				name = L["Show hidden routes"], type = "toggle",
				desc = L["Show hidden routes?"],
				arg  = "show_hidden",
				order = 450,
			},
			update_distance = {
				name = L["Update distance"], type = "range",
				desc = L["Yards to move before triggering a minimap update"],
				min = 0, max = 10, step = 0.1,
				arg = "update_distance",
				order = 500,
			},
		},
	},
}


-- Set of functions we use to edit route configs
local ConfigHandler = {}

function ConfigHandler:GetColor(info)
	return unpack(db.routes[info.arg.zone][info.arg.route].color or db.defaults.color)
end
function ConfigHandler:SetColor(info, r, g, b, a)
	local t = db.routes[info.arg.zone][info.arg.route]
	t.color = t.color or {}
	t = t.color
	t[1] = r; t[2] = g; t[3] = b; t[4] = a;
	Routes:DrawWorldmapLines()
	Routes:DrawMinimapLines(true)
end

function ConfigHandler:GetHidden(info)
	return db.routes[info.arg.zone][info.arg.route].hidden
end
function ConfigHandler:SetHidden(info, v)
	db.routes[info.arg.zone][info.arg.route].hidden = v
	Routes:DrawWorldmapLines()
	Routes:DrawMinimapLines(true)
end

function ConfigHandler:GetWidth(info)
	return db.routes[info.arg.zone][info.arg.route].width or db.defaults.width
end
function ConfigHandler:SetWidth(info, v)
	db.routes[info.arg.zone][info.arg.route].width = v
	Routes:DrawWorldmapLines()
end

function ConfigHandler:GetWidthMinimap(info)
	return db.routes[info.arg.zone][info.arg.route].width_minimap or db.defaults.width_minimap
end
function ConfigHandler:SetWidthMinimap(info, v)
	db.routes[info.arg.zone][info.arg.route].width_minimap = v
	Routes:DrawMinimapLines(true)
end

function ConfigHandler:GetWidthBattleMap(info)
	return db.routes[info.arg.zone][info.arg.route].width_battlemap or db.defaults.width_battlemap
end
function ConfigHandler:SetWidthBattleMap(info, v)
	db.routes[info.arg.zone][info.arg.route].width_battlemap = v
	Routes:DrawWorldmapLines()
end

function ConfigHandler:DeleteRoute(info)
	local zone, route = info.arg.zone, info.arg.route
	local is_running, route_table = Routes.TSP:IsTSPRunning()
	if is_running and route_table == db.routes[zone][route].route then
		Routes:Print(L["You may not delete a route that is being optimized in the background."])
		return
	end
	db.routes[zone][route] = nil
	local routekey = route:gsub("%s", "\255") -- can't have spaces in the key
	options.args.routes_group.args[zone].args[routekey] = nil -- delete route from aceopt
	if next(db.routes[zone]) == nil then
		db.routes[zone] = nil
		options.args.routes_group.args[zone] = nil -- delete zone from aceopt if no routes remaining
	end
	Routes:DrawWorldmapLines()
	Routes:DrawMinimapLines(true)
end

function ConfigHandler:ClusterRoute(info)
	local zone, route = info.arg.zone, info.arg.route
	local t = db.routes[zone][route]
	t.route, t.metadata, t.length = Routes.TSP:ClusterRoute(db.routes[zone][route].route, Routes.zoneMapFile[zone], db.defaults.cluster_dist)
	t.cluster_dist = db.defaults.cluster_dist
	Routes:DrawWorldmapLines()
	Routes:DrawMinimapLines(true)
end

function ConfigHandler:UnClusterRoute(info)
	local zone, route = info.arg.zone, info.arg.route
	local t = db.routes[zone][route]
	local num = 0
	for i = 1, #t.metadata do
		for j = 1, #t.metadata[i] do
			num = num+1
			t.route[num] = t.metadata[i][j]
		end
	end
	t.metadata = nil
	t.cluster_dist = nil
	t.length = Routes.TSP:PathLength(t.route, Routes.zoneMapFile[zone])
	Routes:DrawWorldmapLines()
	Routes:DrawMinimapLines(true)
end

function ConfigHandler:IsCluster(info)
	local t = db.routes[info.arg.zone][info.arg.route]
	if t.metadata then
		return true
	else
		return false
	end
end
function ConfigHandler:IsNotCluster(info)
	return not self:IsCluster(info)
end

function ConfigHandler:GetDefaultClusterDist()
	return db.defaults.cluster_dist
end
function ConfigHandler:SetDefaultClusterDist(info, v)
	db.defaults.cluster_dist = v
end

function ConfigHandler:ResetLineSettings(info)
	local t = db.routes[info.arg.zone][info.arg.route]
	t.color = nil
	t.width = nil
	t.width_minimap = nil
	t.width_battlemap = nil
	Routes:DrawWorldmapLines()
	Routes:DrawMinimapLines(true)
end

function ConfigHandler.GetRouteDesc(info)
	local t = db.routes[info.arg.zone][info.arg.route]
	return L["This route has |cffffd200%d|r nodes and is |cffffd200%d|r yards long."]:format(#t.route, t.length)
end

function ConfigHandler.GetShortClusterDesc(info)
	local t = db.routes[info.arg.zone][info.arg.route]
	if not t.metadata then
		return L["This route is not a clustered route."]
	end
	local numNodes = 0
	for i = 1, #t.metadata do
		numNodes = numNodes + #t.metadata[i]
	end
	return L["This route is a clustered route, down from the original |cffffd200%d|r nodes."]:format(numNodes)
end

function ConfigHandler.GetRouteClusterRadiusDesc(info)
	local t = db.routes[info.arg.zone][info.arg.route]
	if t.metadata then
		return L["The cluster radius of this route is |cffffd200%d|r yards."]:format(t.cluster_dist or 65) -- 65 was an old default
	end
end

do
	local str = {}
	function ConfigHandler.GetDataDesc(info)
		for k in pairs(str) do str[k] = nil end
		local t = db.routes[info.arg.zone][info.arg.route]
		local num = 1
		str[num] = L["This route has nodes that belong to the following categories:"]
		for k in pairs(t.db_type) do
			num = num + 1
			str[num] = "|cffffd200     "..L[k].."|r"
		end
		num = num + 1
		str[num] = L["This route contains the following nodes:"]
		for k, v in pairs(t.selection) do
			num = num + 1
			if v == true then v = k end
			str[num] = "|cffffd200     "..v.."|r"
		end
		return table.concat(str, "\n")
	end

	local data = {}
	function ConfigHandler.GetClusterDesc(info)
		for k in pairs(str) do str[k] = nil end
		for k in pairs(data) do data[k] = nil end
		local t = db.routes[info.arg.zone][info.arg.route]
		if not t.metadata then
			return L["This route is not a clustered route."]
		end

		local numNodes = 0
		local maxt = 0
		local zone = Routes.zoneMapFile[info.arg.zone]
		local zoneW, zoneH = Routes.zoneData[zone][1], Routes.zoneData[zone][2]
		for i = 1, #t.metadata do
			local numData = #t.metadata[i]
			numNodes = numNodes + numData
			local x, y = floor(t.route[i] / 10000) / 10000, (t.route[i] % 10000) / 10000
			for j = 1, numData do
				local x2, y2 = floor(t.metadata[i][j] / 10000) / 10000, (t.metadata[i][j] % 10000) / 10000 -- to round off the coordinate
				local t = (((x2 - x)*zoneW)^2 + ((y2 - y)*zoneH)^2)^0.5 - 0.0001
				t = floor(t / 10)
				data[t] = (data[t] or 0) + 1
				if t > maxt then maxt = t end
			end
		end
		for i = 0, maxt do
			str[i+4] = L["|cffffd200     %d|r node(s) are between |cffffd200%d|r-|cffffd200%d|r yards of a cluster point"]:format(data[i] or 0, i*10+1, i*10+10)
		end
		str[1] = L["This route is a clustered route, down from the original |cffffd200%d|r nodes."]:format(numNodes)
		str[2] = L["The cluster radius of this route is |cffffd200%d|r yards."]:format(t.cluster_dist or 65) -- 65 was an old default
		str[3] = L["|cffffd200     %d|r node(s) are at |cffffd2000|r yards of a cluster point"]:format(data[-1] or 0)
		return table.concat(str, "\n")
	end

	function ConfigHandler.GetTabooDesc(info)
		for k in pairs(str) do str[k] = nil end
		local t = db.routes[info.arg.zone][info.arg.route]
		local num = 1
		str[num] = L["This route has the following taboo regions:"]
		for k, v in pairs(t.taboos) do
			if v then
				num = num + 1
				str[num] = "|cffffd200     "..k.."|r"
			else
				t.taboos[k] = nil -- set the false value to nil, so we don't pairs() over it in the future
			end
		end
		if num == 1 then
			str[num] = L["This route has no taboo regions."]
		end
		num = num + 1
		str[num] = L["This route contains |cffffd200%d|r nodes that have been tabooed."]:format(#t.taboolist)
		return table.concat(str, "\n")
	end
end

function ConfigHandler:GetTwoPointFiveOpt()
	return db.defaults.tsp.two_point_five_opt
end
function ConfigHandler:SetTwoPointFiveOpt(info, v)
	db.defaults.tsp.two_point_five_opt = v
end

function ConfigHandler:DoForeground(info)
	local t = db.routes[info.arg.zone][info.arg.route]
	if #t.route > 724 then
		-- Lua has 4mb limit on table size. 725x725 will result in a table of size 525625
		-- 524288 (or 2^19) is the max as 8 bytes per entry (4 bytes for key, 4 bytes for value) will give exactly 4 Mb
		Routes:Print(L["TOO_MANY_NODES_ERROR"])
		return
	end
	local taboos = {}
	for tabooname, used in pairs(t.taboos) do
		if used then
			tinsert(taboos, db.taboo[info.arg.zone][tabooname])
		end
	end
	local output, meta, length, iter, timetaken = Routes.TSP:SolveTSP(t.route, t.metadata, taboos, Routes.zoneMapFile[info.arg.zone], db.defaults.tsp)
	t.route = output
	t.length = length
	t.metadata = meta
	Routes:Print(L["Path with %d nodes found with length %.2f yards after %d iterations in %.2f seconds."]:format(#output, length, iter, timetaken))

	-- redraw lines
	local AutoShow = Routes:GetModule("AutoShow", true)
	if AutoShow and db.defaults.use_auto_showhide then
		AutoShow:ApplyVisibility()
	end
	Routes:DrawWorldmapLines()
	Routes:DrawMinimapLines(true)
end

function ConfigHandler:DoBackground(info)
	local t = db.routes[info.arg.zone][info.arg.route]
	if #t.route > 724 then
		Routes:Print(L["TOO_MANY_NODES_ERROR"])
		return
	end
	local taboos = {}
	for tabooname, used in pairs(t.taboos) do
		if used then
			tinsert(taboos, db.taboo[info.arg.zone][tabooname])
		end
	end
	local running, errormsg = Routes.TSP:SolveTSPBackground(t.route, t.metadata, taboos, Routes.zoneMapFile[info.arg.zone], db.defaults.tsp)
	if (running == 1) then
		Routes:Print(L["Now running TSP in the background..."])
		Routes.TSP:SetFinishFunction(function(output, meta, length, iter, timetaken)
			t.route = output
			t.length = length
			t.metadata = meta
			Routes:Print(L["Path with %d nodes found with length %.2f yards after %d iterations in %.2f seconds."]:format(#output, length, iter, timetaken))
			-- redraw lines
			local AutoShow = Routes:GetModule("AutoShow", true)
			if AutoShow and db.defaults.use_auto_showhide then
				AutoShow:ApplyVisibility()
			end
			Routes:DrawWorldmapLines()
			Routes:DrawMinimapLines(true)
		end)
	elseif (running == 2) then
		Routes:Print(L["There is already a TSP running in background. Wait for it to complete first."])
	elseif (running == 3) then
		-- This should never happen, but is here as a fallback
		Routes:Print(L["The following error occured in the background path generation coroutine, please report to Grum or Xinhuan:"]);
		Routes:Print(errormsg);
	end
end

do
	local t = {}
	function ConfigHandler:GetTabooRegions(info)
		for k, v in pairs(t) do t[k] = nil end
		for k, v in pairs(db.taboo[info.arg.zone]) do
			t[k] = k
		end
		return t
	end
end
function ConfigHandler:GetTabooRegionStatus(info, k)
	return db.routes[info.arg.zone][info.arg.route].taboos[k]
end
function ConfigHandler:SetTabooRegionStatus(info, k, v)
	if v == false then v = nil end
	local zone = info.arg.zone
	local route_data = db.routes[zone][info.arg.route]
	local taboo_data = db.taboo[zone][k]
	if route_data.taboos[k] ~= v then
		-- toggle it
		route_data.taboos[k] = v
		if v then
			Routes:ApplyTabooToRoute(zone, taboo_data, route_data)
		else
			Routes:UnTabooRoute(zone, route_data)
		end
	end
end
function ConfigHandler:IsBeingManualEdited(info)
	return db.routes[info.arg.zone][info.arg.route].editing
end

-- These tables are referenced inside CreateAceOptRouteTable() defined right below this
local blank_line_table = {
	name = "", type = "description",
	order = 325,
}
local two_point_five_group_table = {
	type = "group",
	order = 150,
	name = L["Extra optimization"],
	inline = true,
	args = {
		two_point_five_opt_disc = {
			name = L["ExtraOptDesc"], type = "description",
			order = 0,
		},
		two_point_five_opt = {
			name = L["Extra optimization"], type = "toggle",
			desc = L["ExtraOptDesc"],
			get = "GetTwoPointFiveOpt", set = "SetTwoPointFiveOpt",
			disabled = false, -- to avoid inheriting from parent, so we don't have to use an arg= field
			order = 100,
		},
	},
}
local foreground_table = {
	type  = "description",
	name  = L["Foreground Disclaimer"],
	order = 0,
}
local background_table = {
	type  = "description",
	name  = L["Background Disclaimer"],
	order = 0,
}
local cluster_header_table = {
	type = "header",
	name = L["Route Clustering"],
	order = 40,
}
local cluster_table = {
	type  = "description",
	name  = L["CLUSTER_DESC"],
	order = 50,
}
local optimize_header_table = {
	type = "header",
	name = L["Route Optimizing"],
	order = 100,
}
local taboo_desc_table = {
	type  = "description",
	name  = L["TABOO_DESC2"],
	order = 0,
}

function Routes:CreateAceOptRouteTable(zone, route)
	local zone_route_table = {zone = zone, route = route}

	-- Yes, return this huge table for given zone/route
	return {
		type = "group",
		name = route,
		desc = route,
		childGroups = "tab",
		handler = ConfigHandler,
		args = {
			info_group = {
				type = "group",
				name = L["Information"],
				order = 0,
				args = {
					desc1 = {
						type = "description",
						name = ConfigHandler.GetRouteDesc,
						arg = zone_route_table,
						order = 0,
					},
					desc2 = {
						type = "description",
						name = ConfigHandler.GetDataDesc,
						arg = zone_route_table,
						order = 10,
					},
					desc3 = {
						type = "description",
						name = ConfigHandler.GetClusterDesc,
						arg = zone_route_table,
						order = 20,
					},
					desc4 = {
						type = "description",
						name = ConfigHandler.GetTabooDesc,
						arg = zone_route_table,
						order = 30,
					},
					delete = {
						name = L["Delete"], type = "execute",
						desc = L["Permanently delete a route"],
						func = "DeleteRoute",
						arg = zone_route_table,
						confirm = true,
						confirmText = L["Are you sure you want to delete this route?"],
						order = 100,
						disabled = "IsBeingManualEdited",
					},
				},
			},
			setting_group = {
				type = "group",
				name = L["Line Settings"],
				order = 100,
				disabled = "IsBeingManualEdited",
				arg = zone_route_table,
				args = {
					desc = {
						type = "description",
						name = L["These settings control the visibility and look of the drawn route."],
						order = 0,
					},
					color = {
						name = L["Line Color"], type = "color",
						desc = L["Change the line color"],
						get = "GetColor", set = "SetColor",
						arg = zone_route_table,
						order = 100,
						hasAlpha = true,
					},
					hidden = {
						name = L["Hide Route"], type = "toggle",
						desc = L["Hide the route from being shown on the maps"],
						get = "GetHidden", set = "SetHidden",
						arg = zone_route_table,
						order = 200,
					},
					width = {
						name = L["Width (Map)"], type = "range",
						desc = L["Width of the line in the map"],
						min = 10, max = 100, step = 1,
						get = "GetWidth", set = "SetWidth",
						arg = zone_route_table,
						order = 300,
					},
					width_minimap = {
						name = L["Width (Minimap)"], type = "range",
						desc = L["Width of the line in the Minimap"],
						min = 10, max = 100, step = 1,
						get = "GetWidthMinimap", set = "SetWidthMinimap",
						arg = zone_route_table,
						order = 310,
					},
					width_battlemap = {
						name = L["Width (Zone Map)"], type = "range",
						desc = L["Width of the line in the Zone Map"],
						min = 10, max = 100, step  = 1,
						get = "GetWidthBattleMap", set = "SetWidthBattleMap",
						arg = zone_route_table,
						order = 320,
					},
					blankline = blank_line_table,
					reset_all = {
						name = L["Reset"], type = "execute",
						desc = L["Reset the line settings to defaults"],
						func = "ResetLineSettings",
						arg = zone_route_table,
						order = 500,
					},
				},
			},
			optimize_group = {
				type = "group",
				order = 200,
				name = L["Optimize Route"],
				disabled = "IsBeingManualEdited",
				arg = zone_route_table,
				args = {
					desc = {
						type = "description",
						name = ConfigHandler.GetRouteDesc,
						arg = zone_route_table,
						order = 0,
					},
					desc2 = {
						type = "description",
						name = ConfigHandler.GetShortClusterDesc,
						arg = zone_route_table,
						order = 1,
					},
					desc3 = {
						type = "description",
						name = ConfigHandler.GetRouteClusterRadiusDesc,
						arg = zone_route_table,
						hidden = "IsNotCluster",
						disabled = "IsNotCluster",
						order = 2,
					},
					cluster_header = cluster_header_table,
					desc_cluster = cluster_table,
					cluster_dist = {
						name = L["Cluster Radius"], type = "range",
						desc = L["CLUSTER_RADIUS_DESC"],
						min = 10, max = 200, step = 1,
						get = "GetDefaultClusterDist",
						set = "SetDefaultClusterDist",
						arg = zone_route_table,
						hidden = "IsCluster",
						disabled = "IsCluster",
						order = 60,
					},
					cluster = {
						name = L["Cluster"], type = "execute",
						desc = L["Cluster this route"],
						func = "ClusterRoute",
						arg = zone_route_table,
						hidden = "IsCluster",
						disabled = "IsCluster",
						order = 70,
					},
					uncluster = {
						name = L["Uncluster"], type = "execute",
						desc = L["Uncluster this route"],
						func = "UnClusterRoute",
						arg = zone_route_table,
						hidden = "IsNotCluster",
						disabled = "IsNotCluster",
						order = 80,
					},
					optimize_header = optimize_header_table,
					two_point_five_group = two_point_five_group_table,
					foreground_group = {
						type = "group",
						order = 200,
						name = L["Foreground"],
						inline = true,
						args = {
							foreground_disc = foreground_table,
							foreground = {
								name = L["Foreground"], type = "execute",
								desc = L["Foreground Disclaimer"],
								func = "DoForeground",
								arg = zone_route_table,
								order = 100,
							},
						},
					},
					background_group = {
						type = "group",
						order = 300,
						name = L["Background"],
						inline = true,
						args = {
							background_disc = background_table,
							background = {
								name = L["Background"], type = "execute",
								desc = L["Background Disclaimer"],
								func = "DoBackground",
								arg = zone_route_table,
								order = 100,
							},
						},
					},
				},
			},
			taboo_group = {
				type = "group",
				order = 300,
				name = L["Taboos"],
				disabled = "IsBeingManualEdited",
				arg = zone_route_table,
				args = {
					desc = taboo_desc_table,
					taboos = {
						name = L["Select taboo regions to apply:"],
						type = "multiselect",
						order = 100,
						values = "GetTabooRegions",
						get = "GetTabooRegionStatus",
						set = "SetTabooRegionStatus",
						arg = zone_route_table,
					},
				},
			},
			edit_group = Routes:CreateAceOptRouteEditTable(zone_route_table),
		},
	}
end

local source_data = {}
options.args.routes_group.args.desc = {
	type = "description",
	name = L["When the following data sources add or delete node data, update my routes automatically by inserting or removing the same node in the relevant routes."]..L[" Gatherer/HandyNotes currently does not support callbacks, so this is impossible for Gatherer/HandyNotes."],
	order = 0,
}
options.args.routes_group.args.callbacks = {
	type = "multiselect",
	name = L["Select sources of data"],
	order = 100,
	values = source_data,
	get = function(info, k)
		if Routes.plugins[k].IsActive() and k ~= "Gatherer" and k ~= "HandyNotes" then
			return db.defaults.callbacks[k]
		else
			return nil
		end
	end,
	set = function(info, k, v)
		-- If plugin is not active, don't toggle anything
		if not Routes.plugins[k].IsActive() or k == "Gatherer" or k == "HandyNotes" then return end
		if v == nil then v = false end
		db.defaults.callbacks[k] = v
		if v then
			Routes.plugins[k].AddCallbacks()
		else
			Routes.plugins[k].RemoveCallbacks()
		end
	end,
	tristate = true,
}

-- AceOpt config table for route creation
do
	-- Some upvalues used in the aceopts[] table for creating new routes
	local create_name = ""
	local create_zones = {}
	local create_zone
	local last_zone = {}
	local create_choices = {}
	local create_data = {}
	local empty_table = {}
	local source_data_choice = {}

	local function deep_copy_table(a, b)
		for k, v in pairs(b) do
			if type(v) == "table" then
				--a[k] = {} -- no need this, AceDB defaults should handle it
				deep_copy_table(a[k], v)
			else
				a[k] = v
			end
		end
	end

	local function get_source_values(info)
		if not create_zone then return empty_table end
		local create_data = create_data[info.arg]
		if last_zone[info.arg] == create_zone then return create_data end
		-- reuse table
		for k in pairs(create_data) do create_data[k] = nil end
		-- extract data from plugin
		if Routes.plugins[info.arg].IsActive() then
			Routes.plugins[info.arg].Summarize(create_data, create_zone)
		end
		-- found no data - insert dummy message
		if not next(create_data) then
			create_data[ db.defaults.fake_data ..";;;" ] = L["No data found"]
		end
		last_zone[info.arg] = create_zone
		return create_data
	end

	local function get_source_value(info, key)
		--Routes:Print(("Getting choice for: %s"):format(key or "nil"));
		if not create_zone then return end
		if key == db.defaults.fake_data then return end
		if not create_choices[create_zone] then create_choices[create_zone] = {} end
		return create_choices[create_zone][key]
	end

	local function set_source_value(info, key, value)
		if not create_zone then return end
		if key == db.defaults.fake_data then return end
		if not create_choices[create_zone] then create_choices[create_zone] = {} end
		create_choices[create_zone][key] = value
		--Routes:Print(("Setting choice: %s to %s"):format(key or "nil", value and "true" or "false"));
	end

	function Routes:SetupSourcesOptTables()
		-- reuse table
		for k in pairs(source_data) do source_data[k] = nil end
		-- create a checkbox for each plugin, then setup the aceopt table
		local order = 300
		for addon, plugin_table in pairs(Routes.plugins) do
			local addonkey = addon:gsub("%s", "_")
			source_data[addonkey] = addon
			if not options.args.add_group.args[addonkey] then
				order = order + 1
				create_data[addonkey] = {}
				options.args.add_group.args[addonkey] = {
					name = addon..L[" Data"], type = "multiselect",
					order = order,
					arg = addon,
					values = get_source_values,
					get = get_source_value,
					set = set_source_value,
					width = "full",
					disabled = not plugin_table.IsActive(),
					guiHidden = not plugin_table.IsActive(),
				}
			end
		end
	end

	options.args.add_group.args = {
		route_name = {
			type = "input",
			name = L["Name of Route"],
			desc = L["Name of the route to add"],
			validate = function(info, name)
				if name == "" or strtrim(name) == "" then
					return L["No name given for new route"]
				end
				return true
			end,
			get = function() return create_name end,
			set = function(info, v) create_name = strtrim(v) end,
			order = 100,
		},
		zone_choice = {
			name = L["Select Zone"], type = "select",
			desc = L["Zone to create route in"],
			order = 150,
			values = function()
				if not next(create_zones) then
					for k, v in pairs(Routes.zoneNames) do
						create_zones[v] = v
					end
				end
				return create_zones
			end,
			get = function()
				-- Use currently viewed map on first view.
				create_zone = create_zone or Routes.zoneNames[GetCurrentMapContinent()*100 + GetCurrentMapZone()]
				return create_zone
			end,
			set = function(info, key) create_zone = key end,
			style = "radio",
		},
		header_bare = {
			type = "header",
			name = L["Create Bare Route"],
			order = 200,
		},
		info_bare = {
			type = "description",
			name = L["CREATE_BARE_ROUTE_DESC"],
			order = 201,
		},
		add_route_bare = {
			name = L["Create Bare Route"], type = "execute",
			desc = L["CREATE_BARE_ROUTE_DESC"],
			order = 202,
			func = function()
				create_name = strtrim(create_name)
				if not create_name or create_name == "" then
					Routes:Print(L["No name given for new route"])
					return
				end
				local new_route = { route = {71117111, 12357823, 11171123}, selection = {}, db_type = {} }

				-- Perform a deep copy instead so that db defaults apply
				local mapfile = Routes.zoneData[create_zone][4]
				db.routes[mapfile][create_name] = nil -- overwrite old route
				new_route.route = Routes.TSP:DecrossRoute(new_route.route)
				deep_copy_table(db.routes[mapfile][create_name], new_route)

				db.routes[mapfile][create_name].length = Routes.TSP:PathLength(new_route.route, create_zone)

				-- Create the aceopts table entry for our new route
				local opts = options.args.routes_group.args
				if not opts[mapfile] then
					opts[mapfile] = { -- use a 3 digit string which is alphabetically sorted zone names by continent
						type = "group",
						name = create_zone,
						desc = L["Routes in %s"]:format(create_zone),
						args = {},
					}
					opts[mapfile].args.desc = {
						type = "description",
						name = GetZoneDescText,
						arg = mapfile,
						order = 0,
					}
				end
				local routekey = create_name:gsub("%s", "\255") -- can't have spaces in the key
				opts[mapfile].args[routekey] = Routes:CreateAceOptRouteTable(mapfile, create_name)

				-- Draw it
				local AutoShow = Routes:GetModule("AutoShow", true)
				if AutoShow and db.defaults.use_auto_showhide then
					AutoShow:ApplyVisibility()
				end
				Routes:DrawWorldmapLines()
				Routes:DrawMinimapLines(true)

				-- clear stored name
				create_name = ""
				create_zone = nil
			end,
			disabled = function()
				return not create_name or strtrim(create_name) == ""
			end,
			confirm = function()
				if #db.routes[ Routes.zoneData[create_zone][4] ][create_name].route > 0 then
					return true
				end
				return false
			end,
			confirmText = L["A route with that name already exists. Overwrite?"],
		},
		header_normal = {
			type = "header",
			name = L["Create Route from Data Sources"],
			order = 225,
		},
		source_choices = {
			name = L["Select sources of data"], type = "multiselect",
			order = 250,
			values = source_data,
			get = function(info, k)
				if Routes.plugins[k].IsActive() then
					if source_data_choice[k] == nil then
						source_data_choice[k] = true
					end
					return source_data_choice[k]
				else
					return nil
				end
			end,
			set = function(info, k, v)
				-- If plugin is not active, don't toggle anything
				if not Routes.plugins[k].IsActive() then return end
				if v == nil then v = false end
				source_data_choice[k] = v
				options.args.add_group.args[k].disabled = not v
				options.args.add_group.args[k].guiHidden = not v
			end,
			tristate = true,
		},
		add_route = {
			name = L["Create Route"], type = "execute",
			desc = L["Create Route"],
			order = 400,
			func = function()
				create_name = strtrim(create_name)
				if not create_name or create_name == "" then
					Routes:Print(L["No name given for new route"])
					return
				end
				-- the real 'action', we use a temporary table in case of data corruption and only commit this to the db if successful
				local new_route = { route = {}, selection = {}, db_type = {} }
				-- if for every selected nodetype on this map
				if type(create_choices[create_zone]) == "table" then
					for data_string, wanted in pairs(create_choices[create_zone]) do
						local db_src, db_type, node_type, amount = (';'):split(data_string);
						local addonkey = db_src:gsub("%s", "_")
						-- if we want em
						if (wanted and source_data_choice[addonkey]) then
							--Routes:Print(("found %s %s %s %s"):format( db_src,db_type,node_type,amount ))
							if db_src ~= db.defaults.fake_data then -- ignore any fake data
								-- extract data from plugin
								local plugin = Routes.plugins[db_src]
								if plugin.IsActive() then
									local english_node, localized_node, type = plugin.AppendNodes(new_route.route, create_zone, db_type, node_type)
									new_route.selection[english_node] = localized_node
									new_route.db_type[type] = true
								end
							end
						end
					end
				end

				if #new_route.route == 0 then
					Routes:Print(L["No data selected for new route"])
					return
				end

				-- Perform a deep copy instead so that db defaults apply
				local mapfile = Routes.zoneData[create_zone][4]
				db.routes[mapfile][create_name] = nil -- overwrite old route
				new_route.route = Routes.TSP:DecrossRoute(new_route.route)
				deep_copy_table(db.routes[mapfile][create_name], new_route)

				db.routes[mapfile][create_name].length = Routes.TSP:PathLength(new_route.route, create_zone)

				-- Create the aceopts table entry for our new route
				local opts = options.args.routes_group.args
				if not opts[mapfile] then
					opts[mapfile] = { -- use a 3 digit string which is alphabetically sorted zone names by continent
						type = "group",
						name = create_zone,
						desc = L["Routes in %s"]:format(create_zone),
						args = {},
					}
					opts[mapfile].args.desc = {
						type = "description",
						name = GetZoneDescText,
						arg = mapfile,
						order = 0,
					}
				end
				local routekey = create_name:gsub("%s", "\255") -- can't have spaces in the key
				opts[mapfile].args[routekey] = Routes:CreateAceOptRouteTable(mapfile, create_name)

				-- Draw it
				local AutoShow = Routes:GetModule("AutoShow", true)
				if AutoShow and db.defaults.use_auto_showhide then
					AutoShow:ApplyVisibility()
				end
				Routes:DrawWorldmapLines()
				Routes:DrawMinimapLines(true)

				-- clear stored name
				create_name = ""
				create_zone = nil
			end,
			disabled = function()
				return not create_name or strtrim(create_name) == ""
			end,
			confirm = function()
				if #db.routes[ Routes.zoneData[create_zone][4] ][create_name].route > 0 then
					return true
				end
				return false
			end,
			confirmText = L["A route with that name already exists. Overwrite?"],
		},
	}

	-- Add another 'Create button'
	options.args.add_group.args.add_route_copy = {}
	for k,v in pairs(options.args.add_group.args.add_route) do
		options.args.add_group.args.add_route_copy[k] = v
	end
	options.args.add_group.args.add_route_copy.order
		= options.args.add_group.args.source_choices.order + 1
end

------------------------------------------------------------------------------------------------------
-- Taboo code

do
	-- Give ourselves a new frame to draw on (so we don't have opening/closing the map wiping stuff out)
	local RoutesTabooFrame = CreateFrame("Frame", "RoutesTabooFrame", WorldMapButton)
	RoutesTabooFrame:SetAllPoints(WorldMapButton)
	RoutesTabooFrame:EnableMouse(false)

	local intersection = {}
	local pool = setmetatable({}, {__mode="kv"})
	local function SortIntersection(a, b)
		return a.x < b.x
	end

	-- This function takes a taboo (a route basically), and draws it on screen and shades the inside
	function Routes:DrawTaboo(route_data, width, color)
		local fh, fw = WorldMapButton:GetHeight(), WorldMapButton:GetWidth()
		width = width or db.defaults.width
		color = color or db.defaults.color

		-- This part just draws the taboo outline, its the same code as the one that draws routes
		do
			local last_point
			local sx, sy
			last_point = route_data.route[ #route_data.route ]
			sx, sy = floor(last_point / 10000) / 10000, (last_point % 10000) / 10000
			sy = (1 - sy)
			for i = 1, #route_data.route do
				local point = route_data.route[i]
				local ex, ey = floor(point / 10000) / 10000, (point % 10000) / 10000
				ey = (1 - ey)
				G:DrawLine(RoutesTabooFrame, sx*fw, sy*fh, ex*fw, ey*fh, width, color , "OVERLAY")
				sx, sy = ex, ey
				last_point = point
			end
		end

		if route_data.isroute then return end

		-- The shade-lines get half-alpha and 66% width
		color[4] = color[4] / 2
		width = 2/3 * width
		for z = 0, 1 do -- loop twice, once for upper half, once for lower half
			for k = 0, 1, 0.01 do
				for i = 1, #intersection do
					pool[tremove(intersection)] = true
				end
				local last_point
				local sx, sy
				last_point = route_data.route[ #route_data.route ]
				sx, sy = floor(last_point / 10000) / 10000, (last_point % 10000) / 10000
				for i = 1, #route_data.route do
					local point = route_data.route[i]
					local ex, ey = floor(point / 10000) / 10000, (point % 10000) / 10000
					if sx + sy == z + k then -- check for endpoint 1
						local vector = next(pool) or {}
						pool[vector] = nil
						vector.x, vector.y = sx, sy
						tinsert(intersection, vector)
					elseif ex + ey == z + k then -- check for endpoint 2
						--[[local vector = next(pool) or {}
						pool[vector] = nil
						vector.x, vector.y = ex, ey
						tinsert(intersection, vector)]]
					elseif ex+ey-sx-sy ~= 0 then -- 0 indicates a parallel line
						local u, t
						if z == 0 and k ~= 0 then
							u = (k - sx - sy)/(ex+ey-sx-sy)
							t = (sx + (ex-sx)*u)/k
						elseif z == 1 and k ~= 1 then
							u = (1 - sx - sy + k)/(ex+ey-sx-sy)
							t = (sx + (ex-sx)*u - k)/(1-k)
						else
							u, t = -1, -1 -- invalid
						end
						if t >= 0 and t <= 1 and u >= 0 and u <= 1 then
							local vector = next(pool) or {}
							pool[vector] = nil
							vector.x, vector.y = sx + (ex-sx)*u, sy + (ey-sy)*u
							tinsert(intersection, vector)
						end
					end
					sx, sy = ex, ey
					last_point = point
				end
				table.sort(intersection, SortIntersection)
				--[[for j = #intersection, 2, -1 do -- this loop removes identical intersection points
					if intersection[j].x == intersection[j-1].x then
						pool[tremove(intersection, j)] = true
					end
				end]]
				for j = 1, #intersection - (#intersection % 2), 2 do -- this loop draws the pairs of intersections
					G:DrawLine(RoutesTabooFrame, intersection[j].x*fw, (1-intersection[j].y)*fh, intersection[j+1].x*fw, (1-intersection[j+1].y)*fh, width, color , "OVERLAY")
				end
			end
		end

		-- restore default alpha
		color[4] = color[4] * 2
	end

	local taboo_edit_list = {}
	function Routes:DrawTaboos()
		G:HideLines(RoutesTabooFrame)
		for taboo_orig, taboo_copy in pairs(taboo_edit_list) do
			Routes:DrawTaboo(taboo_copy)
		end
	end

	-- Upvalues used for our taboo node functions
	local taboo_cache = {}
	local TEXTURE, DATA, COORD, CURRENT, REAL, X, Y  = 1, 2, 3, 4, 5, 6, 7
	local GetOrCreateTabooNode

	-- Define our functions for a node pin
	local NodeHelper = {}
	function NodeHelper:StartMoving()
		self:StartMoving()
		self:SetScript("OnUpdate", NodeHelper.OnUpdate)
		self.elapsed = 0
	end
	function NodeHelper:OnDragStop()
		self:StopMovingOrSizing()
		self:SetScript("OnUpdate", nil)
		self.elapsed = nil
		self:SetParent(RoutesTabooFrame)
		self:ClearAllPoints()
		self:SetPoint("CENTER", RoutesTabooFrame, "TOPLEFT", self[X]*RoutesTabooFrame:GetWidth(), -self[Y]*RoutesTabooFrame:GetHeight())
	end
	function NodeHelper:OnUpdate(elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed < 0.05 then return end

		-- get current location
		local id = self[COORD]
		local x, y = self:GetCenter()
		local parent = self:GetParent()
		local pw, ph = parent:GetWidth(), parent:GetHeight()
		x = (x - parent:GetLeft()) / pw
		y = (parent:GetTop() - y) / ph

		-- Only within our frame
		if x < 0.0001 then x = 0.0001 end -- don't allow 0 values, because our intersection function doesn't like it.
		if x > 0.999 then x = 0.999 end -- don't use 0.9999 because we want some slack space of 10 nodes in case user drags multiple nodes on top of each other
		if y < 0.0001 then y = 0.0001 end
		if y > 0.999 then y = 0.999 end -- we can't have y == 1 because of coord storage format

		local new_id = Routes:getID(x,y)
		if id == new_id then return end -- position didn't change, no updates
		x, y = Routes:getXY(new_id)

		-- edit the route
		local current = self[CURRENT]
		self[DATA].route[current] = new_id
		self[COORD], self[X], self[Y] = new_id, x, y

		-- Relocate the before helper pin
		local nodenum = current == 1 and #self[DATA].route or current-1
		local node = self[DATA].fakenodes[nodenum]
		local x2, y2 = Routes:getXY( self[DATA].route[nodenum] )
		local new_id = Routes:getID( (x+x2)/2, (y+y2)/2 )
		x2, y2 = Routes:getXY(new_id)
		node[COORD], node[X], node[Y] = new_id, x2, y2
		node:SetPoint("CENTER", RoutesTabooFrame, "TOPLEFT", x2*pw, -y2*ph)

		-- Relocate the after helper pin
		nodenum = current == #self[DATA].route and 1 or current+1
		node = self[DATA].fakenodes[current]
		x2, y2 = Routes:getXY( self[DATA].route[nodenum] )
		new_id = Routes:getID( (x+x2)/2, (y+y2)/2 )
		x2, y2 = Routes:getXY(new_id)
		node[COORD], node[X], node[Y] = new_id, x2, y2
		node:SetPoint("CENTER", RoutesTabooFrame, "TOPLEFT", x2*pw, -y2*ph)

		-- redraw
		Routes:DrawTaboos()
	end
	function NodeHelper:OnClick(button, down)
		if button == "LeftButton" and not self[REAL] then
			-- Promote helper node to a real node
			self[REAL] = true
			self:SetWidth(16)
			self:SetHeight(16)
			self:SetAlpha(1)
			local current = self[CURRENT]+1
			for i = current, #self[DATA].route do
				self[DATA].nodes[i][CURRENT] = i+1
				self[DATA].fakenodes[i][CURRENT] = i+1
			end
			self[CURRENT] = current
			tinsert(self[DATA].route, current, self[COORD])
			tinsert(self[DATA].nodes, current, self)
			tremove(self[DATA].fakenodes, current-1)
			local x, y = Routes:getXY(self[COORD])
			local w, h = RoutesTabooFrame:GetWidth(), RoutesTabooFrame:GetHeight()

			-- Now create the before helper pin
			local nodenum = current == 1 and #self[DATA].route or current-1
			local x2, y2 = Routes:getXY( self[DATA].route[nodenum] )
			local new_id = Routes:getID( (x+x2)/2, (y+y2)/2 )
			local node = GetOrCreateTabooNode(self[DATA], new_id)
			x2, y2 = Routes:getXY(new_id)
			node:SetPoint("CENTER", RoutesTabooFrame, "TOPLEFT", x2*w, -y2*h)
			node:SetWidth(10)
			node:SetHeight(10)
			node:SetAlpha(0.75)
			node[REAL] = false
			node[CURRENT] = nodenum
			tinsert(self[DATA].fakenodes, nodenum, node)

			-- Create the after helper pin
			nodenum = current == #self[DATA].route and 1 or current+1
			x2, y2 = Routes:getXY( self[DATA].route[nodenum] )
			new_id = Routes:getID( (x+x2)/2, (y+y2)/2 )
			node = GetOrCreateTabooNode(self[DATA], new_id)
			x2, y2 = Routes:getXY(new_id)
			node:SetPoint("CENTER", RoutesTabooFrame, "TOPLEFT", x2*w, -y2*h)
			node:SetWidth(10)
			node:SetHeight(10)
			node:SetAlpha(0.75)
			node[REAL] = false
			node[CURRENT] = current
			tinsert(self[DATA].fakenodes, current, node)

		elseif button == "RightButton" and self[REAL] and #self[DATA].route > 3 then
			-- Delete node if we have more than 3 nodes
			local current = self[CURRENT]
			for i = current+1, #self[DATA].route do
				self[DATA].nodes[i][CURRENT] = i-1
				self[DATA].fakenodes[i][CURRENT] = i-1
			end
			tremove(self[DATA].route, current)
			local a = tremove(self[DATA].nodes, current)
			local b = tremove(self[DATA].fakenodes, current)

			-- Relocate the before helper pin
			local w, h = RoutesTabooFrame:GetWidth(), RoutesTabooFrame:GetHeight()
			local nodenum = current == 1 and #self[DATA].route or current-1
			local nodenum2 = current > #self[DATA].route and 1 or current
			local node = self[DATA].fakenodes[nodenum]
			local x, y = Routes:getXY( self[DATA].route[nodenum] )
			local x2, y2 = Routes:getXY( self[DATA].route[nodenum2] )
			local new_id = Routes:getID( (x+x2)/2, (y+y2)/2 )
			x2, y2 = Routes:getXY(new_id)
			node[COORD], node[X], node[Y] = new_id, x2, y2
			node:SetPoint("CENTER", RoutesTabooFrame, "TOPLEFT", x2*w, -y2*h)

			-- Recycle ourselves
			a:Hide()
			b:Hide()
			taboo_cache[a] = true
			taboo_cache[b] = true
			Routes:DrawTaboos()
		end

		-- Check data
		for i = 1, #self[DATA].route do
			assert(self[DATA].nodes[i][CURRENT] == i)
			assert(self[DATA].fakenodes[i][CURRENT] == i)
		end
	end

	GetOrCreateTabooNode = function( route_data, coord )
		node = next( taboo_cache )
		if node then
			taboo_cache[ node ] = nil
		else
			-- Create new node
			node = CreateFrame( "Button", nil, RoutesTabooFrame )
			node:SetFrameLevel( RoutesTabooFrame:GetFrameLevel() + 6 ) -- we need to be above others (GatherMate nodes are @ 5)

			-- set it up
			local texture = node:CreateTexture( nil, "OVERLAY" )
			texture:SetTexture("Interface\\WorldMap\\WorldMapPartyIcon")
			texture:SetAllPoints(node)
			node[TEXTURE] = texture

			node:EnableMouse(true)
			node:SetMovable(true)
			node:SetWidth(16)
			node:SetHeight(16)
		end

		-- store data
		node[X], node[Y] = Routes:getXY( coord )
		node[COORD] = coord
		node[DATA] = route_data

		node:RegisterForDrag("LeftButton")
		node:RegisterForClicks("LeftButtonDown", "RightButtonUp")
		node:SetScript("OnDragStart", NodeHelper.StartMoving)
		node:SetScript("OnClick", NodeHelper.OnClick)
		node:SetScript("OnDragStop", NodeHelper.OnDragStop)
		node:Show()
		return node
	end

	local function TabooDeleteNode(menubutton, node)
		local route = node[DATA].route
		for i = 1, #route do
			if route[i] == node[COORD] then
				tremove(route, i)
				break
			end
		end

		node:Hide()
		taboo_cache[node] = true
	end

	local TabooHandler = {}
	function TabooHandler:EditTaboo(info)
		-- open the WorldMapFlame on the right zone
		local zone_id = Routes.zoneData[ Routes.zoneMapFile[info.arg.zone] ][3]

		-- make a copy of the taboo for editing
		local taboo_data = info.arg.isroute and db.routes[info.arg.zone][info.arg.route] or db.taboo[info.arg.zone][info.arg.taboo]
		local copy_of_taboo_data = {route = {}, nodes = {}, fakenodes = {}}
		if info.arg.isroute then
			local is_running, route_table = Routes.TSP:IsTSPRunning()
			if is_running and route_table == taboo_data then return end
			if ConfigHandler:IsCluster(info) then return end
			copy_of_taboo_data.isroute = true
			taboo_data.editing = true
			throttleFrame:Show()  -- To remove the route from the map
		end
		for i = 1, #taboo_data.route do
			copy_of_taboo_data.route[i] = taboo_data.route[i]
		end
		taboo_edit_list[taboo_data] = copy_of_taboo_data

		local fh, fw = RoutesTabooFrame:GetHeight(), RoutesTabooFrame:GetWidth()

		local route = copy_of_taboo_data.route
		-- Pin the real nodes
		for i=1, #route do
			local node = GetOrCreateTabooNode(copy_of_taboo_data, route[i])
			local x, y = node[X], node[Y]
			node:SetPoint("CENTER", RoutesTabooFrame, "TOPLEFT", x*fw, -y*fh)
			node[CURRENT] = i
			node[REAL] = true
			copy_of_taboo_data.nodes[i] = node
			node:SetWidth(16)
			node:SetHeight(16)
			node:SetAlpha(1)
		end
		-- Pin the helper nodes
		for i=1, #route do
			local beforeX, beforeY = Routes:getXY(route[i])
			local afterX, afterY = Routes:getXY(route[i == #route and 1 or i+1])
			local new_id = Routes:getID( (beforeX+afterX)/2, (beforeY+afterY)/2 )
			local node = GetOrCreateTabooNode(copy_of_taboo_data, new_id)
			local x, y = Routes:getXY(new_id)
			node:SetPoint("CENTER", RoutesTabooFrame, "TOPLEFT", x*fw, -y*fh)
			node[CURRENT] = i
			node[REAL] = false
			copy_of_taboo_data.fakenodes[i] = node
			node:SetWidth(10)
			node:SetHeight(10)
			node:SetAlpha(0.75)
		end
		Routes:DrawTaboos()
		WorldMapFrame:Show()
		SetMapZoom( floor( zone_id / 100 ), zone_id % 100 )
	end
	function TabooHandler:SaveEditTaboo(info)
		if info.arg.isroute then
			local zone, route = info.arg.zone, info.arg.route
			local route_data = db.routes[zone][route]
			local copy_of_taboo = self:CancelEditTaboo(info)
			for i = 1, #copy_of_taboo.route do
				route_data.route[i] = copy_of_taboo.route[i]
			end
			for i = #copy_of_taboo.route + 1, #route_data.route do
				route_data.route[i] = nil
			end
			for tabooname, used in pairs(route_data.taboos) do
				if used then
					local taboo_data = db.taboo[zone][tabooname]
					Routes:ApplyTabooToRoute(zone, taboo_data, route_data)
				end
			end
		else
			local zone, taboo = info.arg.zone, info.arg.taboo
			local taboo_data = db.taboo[zone][taboo]
			local copy_of_taboo = self:CancelEditTaboo(info)
			taboo_data.route = copy_of_taboo.route
			-- Update all routes with this taboo
			for route_name, route_data in pairs(db.routes[zone]) do
				if route_data.taboos[taboo] then
					Routes:ApplyTabooToRoute(zone, taboo_data, route_data)
					Routes:UnTabooRoute(zone, route_data)
				else
					-- Set the false value (acedb generated default) to nil, so we don't pairs() over it
					route_data.taboos[taboo] = nil
				end
			end
		end
		throttleFrame:Show()  -- Redraw the changes
	end
	function TabooHandler:CancelEditTaboo(info)
		local taboo = info.arg.isroute and db.routes[info.arg.zone][info.arg.route] or db.taboo[info.arg.zone][info.arg.taboo]
		if info.arg.isroute then
			taboo.editing = nil
			throttleFrame:Show()  -- Redraw the route
		end
		local copy_of_taboo = taboo_edit_list[taboo]
		taboo_edit_list[taboo] = nil
		for i = 1, #copy_of_taboo.route do
			-- Return the pool of pins representing real nodes
			local node = copy_of_taboo.nodes[i]
			node:Hide()
			taboo_cache[node] = true
			copy_of_taboo.nodes[i] = nil

			-- Return the pool of pins representing helper nodes
			node = copy_of_taboo.fakenodes[i]
			node:Hide()
			taboo_cache[node] = true
			copy_of_taboo.fakenodes[i] = nil
		end
		assert(not next(copy_of_taboo.fakenodes))
		assert(not next(copy_of_taboo.nodes))
		Routes:DrawTaboos()
		return copy_of_taboo -- return the edited table
	end
	function TabooHandler:DeleteTaboo(info)
		if self:IsBeingEdited(info) then
			Routes:Print(L["You may not delete a taboo that is being edited."])
			return
		end
		local zone, taboo = info.arg.zone, info.arg.taboo
		db.taboo[zone][taboo] = nil
		local tabookey = taboo:gsub("%s", "\255") -- can't have spaces in the key
		options.args.taboo_group.args[zone].args[tabookey] = nil -- delete taboo from aceopt
		if next(db.taboo[zone]) == nil then
			db.taboo[zone] = nil
			options.args.taboo_group.args[zone] = nil -- delete zone from aceopt if no routes remaining
		end
		-- Now delete the taboo region from all routes in the zone that had it
		for route_name, route_data in pairs(db.routes[zone]) do
			if route_data.taboos[taboo] then
				route_data.taboos[taboo] = nil
				Routes:UnTabooRoute(zone, route_data)
			else
				-- Set the false value (acedb generated default) to nil, so we don't pairs() over it
				route_data.taboos[taboo] = nil
			end
		end
	end
	function TabooHandler:IsBeingEdited(info)
		local taboo = info.arg.isroute and db.routes[info.arg.zone][info.arg.route] or db.taboo[info.arg.zone][info.arg.taboo]
		if taboo_edit_list[taboo] then return true end
		return false
	end
	function TabooHandler:IsNotBeingEdited(info)
		return not self:IsBeingEdited(info)
	end

	local taboo_desc_table = {
		type = "description",
		order = 0,
		name = L["TABOO_EDIT_DESC"],
	}
	function Routes:CreateAceOptTabooTable(zone, taboo)
		local zone_taboo_table = {zone = zone, taboo = taboo}

		return {
			type = "group",
			name = taboo,
			desc = taboo,
			handler = TabooHandler,
			args = {
				desc = taboo_desc_table,
				edit_taboo = {
					type = "execute",
					name = L["Edit taboo region"],
					desc = L["Edit this taboo region on the world map"],
					arg = zone_taboo_table,
					order = 1,
					func = "EditTaboo",
					disabled = "IsBeingEdited",
				},
				save_edit_taboo = {
					type = "execute",
					name = L["Save taboo edit"],
					desc = L["Stop editing this taboo region on the world map and save the edits"],
					arg = zone_taboo_table,
					order = 2,
					func = "SaveEditTaboo",
					disabled = "IsNotBeingEdited",
				},
				cancel_edit_taboo = {
					type = "execute",
					name = L["Cancel taboo edit"],
					desc = L["Stop editing this taboo region on the world map and abandon changes made"],
					arg = zone_taboo_table,
					order = 3,
					func = "CancelEditTaboo",
					disabled = "IsNotBeingEdited",
				},
				delete_taboo = {
					type = "execute",
					name = L["Delete Taboo"],
					desc = L["Delete this taboo region permanently. This will also remove it from all routes that use it."],
					arg = zone_taboo_table,
					order = 4,
					func = "DeleteTaboo",
					disabled = "IsBeingEdited",
					confirm = true,
					confirmText = L["Are you sure you want to delete this taboo? This action will also remove the taboo from all routes that use it."],
				},
			},
		}
	end

	local taboo_name = ""
	local create_zone
	local create_zones = {}
	options.args.taboo_group.args = {
		desc = {
			name = L["TABOO_DESC"],
			type = "description",
			order = 0,
		},
		taboo_name = {
			type = "input",
			name = L["Name of Taboo"],
			desc = L["Name of taboo region to add"],
			validate = function(info, name)
				if name == "" or strtrim(name) == "" then
					return L["No name given for new taboo region"]
				end
				return true
			end,
			get = function() return taboo_name end,
			set = function(info, v) taboo_name = strtrim(v) end,
			order = 100,
		},
		zone_choice = {
			name = L["Select Zone"], type = "select",
			desc = L["Zone to create taboo in"],
			order = 200,
			values = function()
				if not next(create_zones) then
					for k, v in pairs(Routes.zoneNames) do
						create_zones[v] = v
					end
				end
				return create_zones
			end,
			get = function()
				-- Use currently viewed map on first view.
				create_zone = create_zone or Routes.zoneNames[GetCurrentMapContinent()*100 + GetCurrentMapZone()]
				return create_zone
			end,
			set = function(info, key) create_zone = key end,
			style = "radio",
		},
		add_taboo = {
			name = L["Create Taboo"], type = "execute",
			desc = L["Create Taboo"],
			order = 300,
			func = function()
				taboo_name = strtrim(taboo_name)
				if not taboo_name or taboo_name == "" then
					Routes:Print(L["No name given for new taboo region"])
					return
				end

				local mapfile = Routes.zoneData[create_zone][4]
				db.taboo[mapfile][taboo_name].route[1] = 71117111
				db.taboo[mapfile][taboo_name].route[2] = 12357823
				db.taboo[mapfile][taboo_name].route[3] = 11171123

				-- Create the aceopts table entry for our new route
				local opts = options.args.taboo_group.args
				if not opts[mapfile] then
					opts[mapfile] = {
						type = "group",
						name = create_zone,
						desc = L["Taboos in %s"]:format(create_zone),
						args = {},
					}
					opts[mapfile].args.desc = {
						type = "description",
						name = GetZoneTabooDescText,
						arg = mapfile,
						order = 0,
					}
				end
				local tabookey = taboo_name:gsub("%s", "\255") -- can't have spaces in the key
				opts[mapfile].args[tabookey] = Routes:CreateAceOptTabooTable(mapfile, taboo_name)

				-- clear stored name
				taboo_name = ""
				create_zone = nil
			end,
			disabled = function()
				return not taboo_name or strtrim(taboo_name) == ""
			end,
			confirm = function()
				if #db.taboo[ Routes.zoneData[create_zone][4] ][taboo_name].route > 0 then
					return true
				end
				return false
			end,
			confirmText = L["A taboo with that name already exists. Overwrite?"],
		},
	}

	function TabooHandler:IsNotEditAllowed(info)
		local route_table = db.routes[info.arg.zone][info.arg.route]
		if taboo_edit_list[route_table] then return true end
		local is_running, route_table2 = Routes.TSP:IsTSPRunning()
		if is_running and route_table2 == route_table then
			return true
		end
		if ConfigHandler:IsCluster(info) then
			return true
		end
		return false
	end
	local route_edit_desc_table = {
		type = "description",
		order = 0,
		name = L["ROUTE_EDIT_DESC"],
	}
	function Routes:CreateAceOptRouteEditTable(zone_route_table)
		zone_route_table.isroute = true
		return {
			type = "group",
			order = 400,
			name = L["Edit Route Manually"],
			handler = TabooHandler,
			args = {
				desc = route_edit_desc_table,
				edit_route = {
					type = "execute",
					name = L["Edit route"],
					desc = L["Edit this route on the world map"],
					arg = zone_route_table,
					order = 1,
					func = "EditTaboo",
					disabled = "IsNotEditAllowed",
				},
				save_edit_route = {
					type = "execute",
					name = L["Save route edit"],
					desc = L["Stop editing this route on the world map and save the edits"],
					arg = zone_route_table,
					order = 2,
					func = "SaveEditTaboo",
					disabled = "IsNotBeingEdited",
				},
				cancel_edit_route = {
					type = "execute",
					name = L["Cancel route edit"],
					desc = L["Stop editing this route on the world map and abandon changes made"],
					arg = zone_route_table,
					order = 3,
					func = "CancelEditTaboo",
					disabled = "IsNotBeingEdited",
				},
			},
		}
	end

	--/run Routes:TestFunc()
	--/run Routes:ClearTestFunc()
	--[[function Routes:TestFunc(taboo)
		taboo = taboo or Routes.db.global.taboo[ Routes.zoneData["Shattrath City"][4] ]["abc"]
		local fw, fh = RoutesTabooFrame:GetWidth(), RoutesTabooFrame:GetHeight()

		for i = 0, 1, 0.02 do
			for j = 0, 0.99, 0.02 do
				local point = self:getID(i, j)
				local node = GetOrCreateTabooNode(taboo, point)
				local x, y = node[X], node[Y]
				node:SetPoint("CENTER", RoutesTabooFrame, "TOPLEFT", x*fw, -y*fh)
				if self:IsNodeInTaboo(x, y, taboo) then
					node[TEXTURE]:SetVertexColor( 1, 0, 0, 1 )
				else
					node[TEXTURE]:SetVertexColor( 0, 1, 0, 1 )
				end
				node[BEFORE] = point
				node[AFTER] = point
				node:SetAlpha(0.5)
			end
		end
	end
	function Routes:ClearTestFunc()
		for i = 0, 1, 0.02 do
			for j = 0, 0.99, 0.02 do
				local point = self:getID(i, j)
				local node = GetOrCreateTabooNode(taboo, point)
				node:Hide()
				taboo_cache[node] = true
			end
		end
	end]]
end


do
	-- This function tests if the node at location (x,y) is in a taboo region
	-- It does this by drawing a line from (0,0) to (x,y) and seeing how many times
	-- this line intersects the taboo polygon edges. If its even, its outside. If
	-- its odd its inside.
	function Routes:IsNodeInTaboo(x, y, taboo)
		-- our taboo regions have x and y between 0.0001 and 0.9999
		if x <= 0 or y <= 0 or x >= 1 or y >= 1 then return false end
		local count = 0

		local last_point = taboo.route[ #taboo.route ]
		local sx, sy = floor(last_point / 10000) / 10000, (last_point % 10000) / 10000
		for i = 1, #taboo.route do
			local point = taboo.route[i]
			local ex, ey = floor(point / 10000) / 10000, (point % 10000) / 10000
			-- check if (0,0)-(x,y) intersects with (sx,sy)-(ex,ey)
			if sx >= 0 and sx <= x and sx/sy == x/y then -- check for endpoint 1
				count = count + 1 -- (sx,sy) lies on the line
			elseif ex >= 0 and ex <= x and ex/ey == x/y then -- check for endpoint 2
				-- (ex,ey) lies on the line, do nothing
			else
				local d = (x*ey - x*sy - y*ex + y*sx)
				if d ~= 0 then
					local u = (sx*y - sy*x)/d
					local t = (sx + (ex-sx)*u)/x
					if t >= 0 and t <= 1 and u >= 0 and u <= 1 then
						count = count + 1
					end
				end
			end
			sx, sy = ex, ey
			last_point = point
		end
		return count % 2 == 1
	end

	function Routes:ApplyTabooToRoute(zone, taboo_data, route_data)
		if route_data.metadata then
			-- this is a clustered route
			for i = #route_data.route, 1, -1 do
				for j = #route_data.metadata[i], 1, -1 do
					local coord = route_data.metadata[i][j]
					local x, y = Routes:getXY(coord)
					if Routes:IsNodeInTaboo(x, y, taboo_data) then -- remove node
						-- recalcuate centroid
						local cx, cy = Routes:getXY(route_data.route[i])
						local num_data = #route_data.metadata[i]
						if num_data > 1 then
							-- more than 1 node in this cluster
							cx, cy = (cx * num_data - x) / (num_data-1), (cy * num_data - y) / (num_data-1)
							tremove(route_data.metadata[i], j)
							route_data.route[i] = Routes:getID(cx, cy)
						else
							-- only 1 node in this cluster, just remove it
							tremove(route_data.metadata, i)
							tremove(route_data.route, i)
						end
						tinsert(route_data.taboolist, coord)
						route_data.length = Routes.TSP:PathLength(route_data.route, Routes.zoneMapFile[zone])
						throttleFrame:Show()
					end
				end
			end
		else
			-- this is not a clustered route
			for i = #route_data.route, 1, -1 do
				local coord = route_data.route[i]
				local x, y = Routes:getXY(coord)
				if Routes:IsNodeInTaboo(x, y, taboo_data) then -- remove node
					tremove(route_data.route, i)
					tinsert(route_data.taboolist, coord)
					route_data.length = self.TSP:PathLength(route_data.route, Routes.zoneMapFile[zone])
					throttleFrame:Show()
				end
			end
		end
	end
	function Routes:UnTabooRoute(zone, route_data)
		for i = #route_data.taboolist, 1, -1 do
			local coord = route_data.taboolist[i]
			local x, y = Routes:getXY(coord)
			local flag = false
			for tabooname, used in pairs(route_data.taboos) do
				if used and Routes:IsNodeInTaboo(x, y, db.taboo[zone][tabooname]) then
					flag = true
				end
			end
			if flag == false then
				route_data.length = Routes.TSP:InsertNode(route_data.route, route_data.metadata, Routes.zoneMapFile[zone], coord, route_data.cluster_dist or 65) -- 65 is the old default
				tremove(route_data.taboolist, i)
				throttleFrame:Show()
			end
		end
	end
end


------------------------------------------------------------------------------------------------------
-- The following function is used with permission from Daniel Stephens <iriel@vigilance-committee.org>
-- with reference to TaxiFrame.lua in Blizzard's UI and Graph-1.0 Ace2 library (by Cryect) which I now
-- maintain after porting it to LibGraph-2.0 LibStub library -- Xinhuan
local TAXIROUTE_LINEFACTOR = 128/126; -- Multiplying factor for texture coordinates
local TAXIROUTE_LINEFACTOR_2 = TAXIROUTE_LINEFACTOR / 2; -- Half of that

-- T        - Texture
-- C        - Canvas Frame (for anchoring)
-- sx,sy    - Coordinate of start of line
-- ex,ey    - Coordinate of end of line
-- w        - Width of line
-- relPoint - Relative point on canvas to interpret coords (Default BOTTOMLEFT)
function G:DrawLine(C, sx, sy, ex, ey, w, color, layer)
	local relPoint = "BOTTOMLEFT"

	if not C.Routes_Lines then
		C.Routes_Lines={}
		C.Routes_Lines_Used={}
	end

	local T = tremove(C.Routes_Lines) or C:CreateTexture(nil, "ARTWORK")
	T:SetTexture("Interface\\AddOns\\Routes\\line")
	tinsert(C.Routes_Lines_Used,T)

	T:SetDrawLayer(layer or "ARTWORK")

	T:SetVertexColor(color[1],color[2],color[3],color[4]);

	-- Determine dimensions and center point of line
	local dx,dy = ex - sx, ey - sy;

	-- Calculate actual length of line
	local l = ((dx * dx) + (dy * dy)) ^ 0.5;

	-- Quick escape if it's zero length
	if l == 0 then
		T:ClearAllPoints();
		T:SetTexCoord(0,0,0,0,0,0,0,0);
		T:SetPoint("BOTTOMLEFT", C, relPoint, cx, cy);
		T:SetPoint("TOPRIGHT",   C, relPoint, cx, cy);
		return T;
	end

	local cx,cy = (sx + ex) / 2, (sy + ey) / 2;

	-- Normalize direction if necessary
	if (dx < 0) then
		dx,dy = -dx,-dy;
	end

	-- Sin and Cosine of rotation, and combination (for later)
	local s,c = -dy / l, dx / l;
	local sc = s * c;

	-- Calculate bounding box size and texture coordinates
	local Bwid, Bhgt, BLx, BLy, TLx, TLy, TRx, TRy, BRx, BRy;
	if (dy >= 0) then
		Bwid = ((l * c) - (w * s)) * TAXIROUTE_LINEFACTOR_2;
		Bhgt = ((w * c) - (l * s)) * TAXIROUTE_LINEFACTOR_2;
		BLx, BLy, BRy = (w / l) * sc, s * s, (l / w) * sc;
		BRx, TLx, TLy, TRx = 1 - BLy, BLy, 1 - BRy, 1 - BLx;
		TRy = BRx;
	else
		Bwid = ((l * c) + (w * s)) * TAXIROUTE_LINEFACTOR_2;
		Bhgt = ((w * c) + (l * s)) * TAXIROUTE_LINEFACTOR_2;
		BLx, BLy, BRx = s * s, -(l / w) * sc, 1 + (w / l) * sc;
		BRy, TLx, TLy, TRy = BLx, 1 - BRx, 1 - BLx, 1 - BLy;
		TRx = TLy;
	end

	-- Thanks Blizzard for adding (-)10000 as a hard-cap and throwing errors!
	-- The cap was added in 3.1.0 and I think it was upped in 3.1.1
	--  (way less chance to get the error)
	if TLx > 10000 then TLx = 10000 elseif TLx < -10000 then TLx = -10000 end
	if TLy > 10000 then TLy = 10000 elseif TLy < -10000 then TLy = -10000 end
	if BLx > 10000 then BLx = 10000 elseif BLx < -10000 then BLx = -10000 end
	if BLy > 10000 then BLy = 10000 elseif BLy < -10000 then BLy = -10000 end
	if TRx > 10000 then TRx = 10000 elseif TRx < -10000 then TRx = -10000 end
	if TRy > 10000 then TRy = 10000 elseif TRy < -10000 then TRy = -10000 end
	if BRx > 10000 then BRx = 10000 elseif BRx < -10000 then BRx = -10000 end
	if BRy > 10000 then BRy = 10000 elseif BRy < -10000 then BRy = -10000 end

	-- Set texture coordinates and anchors
	T:ClearAllPoints();

	--[[ When stuff did error
	local status, err = pcall( T.SetTexCoord, T, TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy )
	if not status then
		error( ("SetTexCoord tossed an error, please report on http://wowace.com/projects/routes >> Error: %s TLx: %s TLy: %s BLx: %s BLy: %s TRx: %s TRy: %s BRx: %s BRy: %s"):format(
			err or "nil", TLx or "nil", TLy or "nil", BLx or "nil", BLy or "nil", TRx or "nil", TRy or "nil", BRx or "nil", BRy or "nil"
		));
	end
	--]]
	T:SetTexCoord( TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy )
	T:SetPoint("BOTTOMLEFT", C, relPoint, cx - Bwid, cy - Bhgt);
	T:SetPoint("TOPRIGHT",   C, relPoint, cx + Bwid, cy + Bhgt);
	T:Show()
	return T
end

function G:HideLines(C)
	if C.Routes_Lines then
		for i = #C.Routes_Lines_Used, 1, -1 do
			C.Routes_Lines_Used[i]:Hide()
			tinsert(C.Routes_Lines,tremove(C.Routes_Lines_Used))
		end
	end
end


function Routes:ReparentMinimap(minimap)
	self.G:HideLines(Minimap)
	Minimap = minimap
	throttleFrame:Show()
end

-- vim: ts=4 noexpandtab
