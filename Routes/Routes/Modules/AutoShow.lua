local Routes = LibStub("AceAddon-3.0"):GetAddon("Routes")
local AutoShow = Routes:NewModule("AutoShow", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Routes")

-- Aceopt table, defined later
local options
-- Our db
local db

local have_prof = {
	Herbalism  = false,
	Mining     = false,
	Fishing    = false,
	ExtractGas = false, -- Engineering
}
local texture_to_profession = {
	["Interface\\Icons\\Spell_Nature_Earthquake"] = "Mining",
	["Interface\\Icons\\INV_Misc_Flower_02"] = "Herbalism",
	["Interface\\Icons\\INV_Misc_Fish_02"] = "Fishing",
	["Interface\\Icons\\Racial_Dwarf_FindTreasure"] = "Treasure",
}
local active_tracking

function AutoShow:SKILL_LINES_CHANGED()
	local skillname, isHeader
	for i = 1, GetNumSkillLines() do
		skillname, isHeader = GetSkillLineInfo(i)
		if not isHeader and skillname then
			if strfind(skillname, GetSpellInfo(7620), 1, true) then
				have_prof.Fishing = true
			elseif strfind(skillname, GetSpellInfo(9134), 1, true) then
				have_prof.Herbalism = true
			elseif strfind(skillname, GetSpellInfo(2575), 1, true) then
				have_prof.Mining = true
			elseif strfind(skillname, GetSpellInfo(4036), 1, true) then
				have_prof.ExtractGas = true
			end
		end
	end
	self:ApplyVisibility()
end

function AutoShow:MINIMAP_UPDATE_TRACKING()
	active_tracking = texture_to_profession[GetTrackingTexture()]
	self:ApplyVisibility()
end

function AutoShow:ApplyVisibility()
	local modified = false
	for zone, zone_table in pairs(db.routes) do -- for each zone
		if next(zone_table) ~= nil then
			for route_name, route_data in pairs(zone_table) do -- for each route
				if route_data.db_type then
					local visible = false
					for db_type in pairs(route_data.db_type) do -- for each db type used
						local status = db.defaults.prof_options[db_type]
						if status == "Always" then
							visible = true
						elseif status == "With Profession" and have_prof[db_type] then
							visible = true
						elseif status == "When active" and active_tracking == db_type then
							visible = true
						--elseif status == "Never" then
						--	visible = false
						end
						if visible == not route_data.visible then
							modified = true
						end
						route_data.visible = visible
					end
				end
			end
		end
	end
	if modified then
		-- redraw worldmap + minimap
		Routes:DrawWorldmapLines()
		Routes:DrawMinimapLines(true)
	end
end

function AutoShow:SetupAutoShow()
	if db.defaults.use_auto_showhide then
		self:RegisterEvent("SKILL_LINES_CHANGED")
		self:RegisterEvent("MINIMAP_UPDATE_TRACKING")
		self:MINIMAP_UPDATE_TRACKING()
		self:SKILL_LINES_CHANGED()
	end
end

function AutoShow:OnInitialize()
	db = Routes.db.global
	Routes.options.args.options_group.args.auto_group = options
end

function AutoShow:OnEnable()
	self:SetupAutoShow()
end


local prof_options = {
	["Always"]          = L["Always show"],
	["With Profession"] = L["Only with profession"],
	["When active"]     = L["Only while tracking"],
	["Never"]           = L["Never show"],
}
local prof_options2 = { -- For Treasure, which isn't a profession
	["Always"]          = L["Always show"],
	["When active"]     = L["Only while tracking"],
	["Never"]           = L["Never show"],
}
local prof_options3 = { -- For Gas, which doesn't have tracking as a skill
	["Always"]          = L["Always show"],
	["With Profession"] = L["Only with profession"],
	["Never"]           = L["Never show"],
}
local prof_options4 = { -- For Note, which isn't a profession or tracging skill
	["Always"]          = L["Always show"],
	["Never"]           = L["Never show"],
}

options = {
	name = L["Auto show/hide"], type = "group",
	desc = L["Auto show and hide routes based on your professions"],
	--groupType = "inline",
	order = 200,
	args = {
		use_auto_showhide = {
			name = L["Use Auto Show/Hide"],
			desc = L["Use Auto Show/Hide"],
			type = "toggle",
			arg = "use_auto_showhide",
			order = 210,
			set = function(info, v)
				db.defaults.use_auto_showhide = v
				AutoShow:SetupAutoShow()
				Routes:DrawWorldmapLines()
				Routes:DrawMinimapLines(true)
			end,
		},
		auto_group = {
			name = L["Auto Show/Hide per route type"], type = "group",
			desc = L["Auto Show/Hide settings"],
			inline = true,
			order = 300,
			disabled = function(info) return not db.defaults.use_auto_showhide end,
			set = function(info, v)
				db.defaults.prof_options[info.arg] = v
				AutoShow:ApplyVisibility()
			end,
			get = function(info) return db.defaults.prof_options[info.arg] end,
			args = {
				fishing = {
					name = L["Fishing"], type = "select",
					desc = L["Routes with Fish"],
					order = 100,
					values = prof_options,
					arg = "Fishing",
				},
				gas = {
					name = L["ExtractGas"], type = "select",
					desc = L["Routes with Gas"],
					order = 200,
					values = prof_options3,
					arg = "ExtractGas",
				},
				herbalism = {
					name = L["Herbalism"], type = "select",
					desc = L["Routes with Herbs"],
					order = 300,
					values = prof_options,
					arg = "Herbalism",
				},
				mining = {
					name = L["Mining"], type = "select",
					desc = L["Routes with Ore"],
					order = 400,
					values = prof_options,
					arg = "Mining",
				},
				treasure = {
					name = L["Treasure"], type = "select",
					desc = L["Routes with Treasure"],
					order = 500,
					values = prof_options2,
					arg = "Treasure",
				},
				note = {
					name = L["Note"], type = "select",
					desc = L["Routes with Notes"],
					order = 600,
					values = prof_options4,
					arg = "Note",
				},
			},
		},
	},
}

-- vim: ts=4 noexpandtab
