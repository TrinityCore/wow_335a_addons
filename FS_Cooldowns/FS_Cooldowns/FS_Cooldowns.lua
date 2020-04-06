local LGIST = LibStub:GetLibrary("LibGroupInSpecT-1.1")
local FSCD  = LibStub("AceAddon-3.0"):NewAddon("FSCooldowns", "AceEvent-3.0", "AceConsole-3.0", "AceComm-3.0")
local Media = LibStub("LibSharedMedia-3.0")

FSCD.version = "1.3.3"

--------------------------------------------------------------------------------

local function dump(t)
	local print_r_cache = {}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						print(indent..string.rep(" ",string.len(pos)+6).."}")
					elseif (type(pos)=="table") then
						print(indent.."["..tostring(pos).."] => "..tostring(t).." {")
						sub_print_r(pos,indent..string.rep(" ",string.len(tostring(pos))+8))
						print(indent..string.rep(" ",string.len(tostring(pos))+6).."}")
					else
						print(indent.."["..tostring(pos).."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	sub_print_r(t," ")
end

--------------------------------------------------------------------------------

local order = 0
local function getOrder()
	order = order + 1
	return order
end

local class_colors = {
	[1]  = {0.78, 0.61, 0.43, "c79c6e"}, -- Warrior
	[2]  = {0.96, 0.55, 0.73, "f58cba"}, -- Paladin
	[3]  = {0.67, 0.83, 0.45, "abd473"}, -- Hunter
	[4]  = {1.00, 0.96, 0.41, "fff569"}, -- Rogue
	[5]  = {1.00, 1.00, 1.00, "ffffff"}, -- Priest
	[6]  = {0.77, 0.12, 0.23, "c41f3b"}, -- Death Knight
	[7]  = {0.00, 0.44, 0.87, "0070de"}, -- Shaman
	[8]  = {0.41, 0.80, 0.94, "69ccf0"}, -- Mage
	[9]  = {0.58, 0.51, 0.79, "9482c9"}, -- Warlock
	[10] = {0.33, 0.54, 0.52, "00ff96"}, -- Monk
	[11] = {1.00, 0.49, 0.04, "ff7d0a"}, -- Druid
}

local cooldowns = {
-- Paladin
--[[	[20473] = { -- Holy Shock
		cooldown = 6,
		spec = 65,
		class = 2,
		order = getOrder()
	},]]
	[31821] = { -- Devotion Aura
		cooldown = 180,
		duration = 6,
		spec = 65,
		class = 2,
		order = getOrder()
	},
	[31842] = { -- Avenging Wrath (Holy)
		cooldown = function(player)
			return player.glyphs[162604] and 90 or 180
		end,
		duration = function(player)
			return player.talents[17599] and 30 or 20
		end,
		spec = 65,
		class = 2,
		reset_on_wipe = true,
		order = getOrder()
	},
	[6940] = { -- Hand of Sacrifice
		cooldown = 120,
		duration = 12,
		charges = function(player)
			return player.talents[17593] and 2 or 1
		end,
		class = 2,
		order = getOrder()
	},
	[1022] = { -- Hand of Protection
		cooldown = 300,
		duration = 10,
		charges = function(player)
			return player.talents[17593] and 2 or 1
		end,
		class = 2,
		order = getOrder()
	},
	[114039] = { -- Hand of Purity
		cooldown = 30,
		duration = 6,
		talent = 17589,
		class = 2,
		order = getOrder()
	},
-- Priest
	[62618] = { -- Power Word: Barrier
		cooldown = 180,
		duration = 10,
		spec = 256,
		class = 5,
		order = getOrder()
	},
	[33206] = { -- Pain Suppression
		cooldown = 180,
		duration = 8,
		spec = 256,
		class = 5,
		order = getOrder()
	},
	[64843] = { -- Divine Hymn
		cooldown = 180,
		duration = 8,
		spec = 257,
		class = 5,
		order = getOrder()
	},
	[47788] = { -- Guardian Spirit
		cooldown = 180,
		duration = 10,
		spec = 257,
		class = 5,
		order = getOrder()
	},
	[15286] = { -- Vampiric Embrace
		cooldown = 180,
		duration = 15,
		spec = 258,
		class = 5,
		order = getOrder()
	},
-- Druid
	[740] = { -- Tranquility
		cooldown = 180,
		duration = 8,
		spec = 105,
		class = 11,
		order = getOrder()
	},
	[33891] = { -- Incarnation: Tree of Life
		cooldown = 180,
		duration = 30,
		talent = 21707,
		class = 11,
		order = getOrder()
	},
	[102342] = { -- Ironbark
		cooldown = 60,
		duration = 12,
		spec = 105,
		class = 11,
		order = getOrder()
	},
	[124974] = { -- Nature's Vigil
		cooldown = 90,
		duration = 30,
		talent = 18586,
		class = 11,
		order = getOrder()
	},
	[106898] = { -- Stampeding Roar
		cooldown = 120,
		duration = 8,
		class = 11,
		order = getOrder()
	},
-- Shaman
	[108280] = { -- Healing Tide Totem
		cooldown = 180,
		duration = 10,
		spec = 264,
		class = 7,
		order = getOrder()
	},
	[98008] = { -- Spirit Link Totem
		cooldown = 180,
		duration = 6,
		charges = function(player)
			return player.talents[19273] and 2 or 1
		end,
		spec = 264,
		class = 7,
		order = getOrder()
	},
	[114052] = { -- Ascendance
		cooldown = 180,
		duration = 15,
		spec = 264,
		class = 7,
		order = getOrder()
	},
	[8143] = { -- Tremor Totem
		cooldown = 60,
		duration = 10,
		class = 7,
		order = getOrder()
	},
	[108281] = { -- Ancestral Guidance
		cooldown = 120,
		duration = 10,
		talent = 19269,
		class = 7,
		order = getOrder()
	},
 -- Monk
	[115310] = { -- Revival
		cooldown = 180,
		spec = 270,
		class = 10,
		order = getOrder()
	},
	[116849] = { -- Life Cocoon
		cooldown = 100,
		duration = 12,
		spec = 270,
		class = 10,
		order = getOrder()
	},
--[[	[115072] = { -- Expel Harm
		cooldown = 15,
		duration = 5,
		spec = 270,
		class = 10,
		order = getOrder()
	},]]
-- Death Knight
	[51052] = { -- Anti-Magic Zone
		cooldown = 120,
		duration = 3,
		talent = 19219,
		class = 6,
		order = getOrder()
	},
	[108199] = { -- Gorefiend's Grasp
		cooldown = 60,
		talent = 19230,
		class = 6,
		order = getOrder()
	},
-- Warrior
	[97462] = { -- Rallying Cry
		cooldown = 180,
		duration = 10,
		spec = { 71, 72 },
		class = 1,
		order = getOrder()
	},
	[114030] = { -- Vigilance
		cooldown = 120,
		duration = 12,
		talent = 19676,
		class = 1,
		order = getOrder()
	},
	[3411] = { -- Intervene
		cooldown = 30,
		duration = 10,
		class = 1,
		order = getOrder()
	},
-- Mage
	--[[
	[159916] = { -- Amplify Magic
		cooldown = 120,
		duration = 6,
		class = 8,
		order = getOrder()
	},]]
-- Rogue
	[76577] = { -- Smoke Bomb
		cooldown = 180,
		duration = 5,
		class = 4,
		order = getOrder()
	},
-- Hunter
	--[[
	[172106] = { -- Aspect of the Fox
		cooldown = 180,
		duration = 6,
		class = 3,
		order = getOrder()
	},]]
	
-- Legendary rings
	["legendary_rings"] = {
		special = true,
		cooldown = 120,
		duration = 15,
		icon = select(3, GetSpellInfo(187612)),
		color = { 100/255, 150/255, 200/255 },
		order = getOrder()
	},
}

--------------------------------------------------------------------------------

local cooldowns_list = {}
do
	for id, infos in pairs(cooldowns) do
		table.insert(cooldowns_list, id)
	end
	table.sort(cooldowns_list, function(a, b)
		local a, b = cooldowns[a], cooldowns[b]
		return a.order < b.order
	end)
end

local cooldowns_idx = {}
local roster = {}

local displays = {}

local players_available = {}

--------------------------------------------------------------------------------

local defaults = {
	profile = {
		groups = {
			["**"] = {
				position = { "TOPLEFT", nil, "TOPLEFT", 250, -250 },
				size = 24,
				border = 1,
				spacing = 2,
				width = 100,
				height = 15,
				attach = "LEFTDOWN",
				texture = "Blizzard",
				font = "Friz Quadrata TT",
				font_size = 11,
				missing = true,
				charges = true,
				limit = false,
				limit_nb = 3,
				cooldowns = {},
				unlocked = false
			}
		}
	}
}

local settings

local config = {
	type = "group",
	args = {
		groups = {
			name = "Display groups",
			type = "group",
			args = {
				["$New"] = {
					order = 0,
					name = "New group name",
					type = "input",
					get = function() return "" end,
					set = function(_, name) FSCD:CreateDisplayGroup(name) end
				},
			}
		}
	}
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("FS Cooldowns", config)

function FSCD:OnInitialize()
	LGIST.RegisterCallback(self, "GroupInSpecT_Update", "RosterUpdate")
	LGIST.RegisterCallback(self, "GroupInSpecT_Remove", "RosterRemove")
	
	self:RegisterChatCommand("fsc", function()
		LibStub("AceConfigDialog-3.0"):Open("FS Cooldowns")
	end)
	
	self.db = LibStub("AceDB-3.0"):New("FSCooldownsSettings", defaults, true)
	config.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	settings = self.db.profile
	
	self.db.RegisterCallback(self, "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("ENCOUNTER_END")
	self:RegisterEvent("PLAYER_LOGIN")
	
	self:RegisterComm("FSCD", "OnCommReceived")
	
	C_Timer.NewTicker(2, function()
		local one_changed = false
		for name, available in pairs(players_available) do
			if not UnitExists(name) then
				players_available[name] = nil
			else
				local a = UnitIsVisible(name) and not UnitIsDeadOrGhost(name)
				if a ~= available then
					players_available[name] = a
					one_changed = true
				end
			end
		end
		
		if one_changed then
			FSCD:RefreshAllCooldowns()
		end
	end)
	
	for name in pairs(settings.groups) do
		self:CreateDisplayGroup(name)
	end
	
	self:RebuildAllDisplays()
	
	if FS and FS.Config then
		FS.Config:Register("Cooldowns", {
			title = {
				type = "description",
				name = "|cff64b4ffCooldowns tracker",
				fontSize = "large",
				order = 0,
			},
			desc = {
				type = "description",
				name = "Tracks raid cooldown and legendary rings usage.",
				fontSize = "medium",
				order = 1,
			},
			version = {
				type = "description",
				name = "\n|cffffd100FS Cooldowns version: |r" .. FSCD.version,
				fontSize = "small",
				order = 2,
			},
			groups = config.args.groups,
			profiles = config.args.profiles
		})
	end
end

function FSCD:PLAYER_LOGIN()
	local key = "legendary_rings"
	local rings = cooldowns[key]
	
	local dps_ring_names = {
		[1] = "Thorasus",
		[2] = "Thorasus",
		[3] = "Maalus",
		[4] = "Maalus",
		[5] = "Nithramus",
		[6] = "Thorasus",
		[7] = GetSpecialization() == 2 and "Maalus" or "Nithramus",
		[8] = "Nithramus",
		[9] = "Nithramus",
		[10] = "Maalus",
		[11] = (GetSpecialization() == 2 or GetSpecialization() == 3) and "Maalus" or "Nithramus",
	}
	
	local dps_name = dps_ring_names[select(3, UnitClass("player"))]
	
	local hallows = { name = dps_name, ring_name = dps_name, guid = "Hallows", order = 1 }
	roster["Hallows"] = {
		player = hallows,
		cooldowns = {
			[key] = self:CreatePlayerCooldown(hallows, rings, key)
		}
	}
	
	local sanctus = { name = "Sanctus", ring_name = "Sanctus", guid = "Sanctus", order = 2 }
	roster["Sanctus"] = {
		player = sanctus,
		cooldowns = {
			[key] = self:CreatePlayerCooldown(sanctus, rings, key)
		}
	}
	
	local etheralus = { name = "Etheralus", ring_name = "Etheralus", guid = "Etheralus" , order = 3 }
	roster["Etheralus"] = {
		player = etheralus,
		cooldowns = {
			[key] = self:CreatePlayerCooldown(etheralus, rings, key)
		}
	}
	
	self:RebuildIndex()
end

function FSCD:OnProfileChanged()
	for name in pairs(displays) do
		self:RemoveDisplayGroup(name, true)
	end
	
	settings = self.db.profile
	
	for name in pairs(settings.groups) do
		self:CreateDisplayGroup(name)
	end
end

function FSCD:CreateDisplayGroup(name)
	if displays[name] then return end
	
	-- Create settings entry
	if not settings.groups[name] then
		settings.groups[name] = {}
	end
	
	-- Create config entry
	local group = {
		name = name,
		type = "group",
		args = {
			unlock = {
				order = 1,
				name = "Display anchor",
				type = "toggle",
				get = function() return settings.groups[name].unlocked end,
				set = function(_, value)
					settings.groups[name].unlocked = value
					FSCD:RebuildDisplay(name)
				end
			},
			remove = {
				order = 2,
				name = "Delete group",
				type = "execute",
				func = function()
					FSCD:RemoveDisplayGroup(name)
				end
			},
			void1 = {
				order = 3,
				name = "\n",
				type = "description"
			},
			size = {
				order = 10,
				name = "Icon size",
				min = 16,
				max = 64,
				type = "range",
				step = 1,
				get = function() return settings.groups[name].size end,
				set = function(_, value)
					settings.groups[name].size = value
					FSCD:RebuildDisplay(name)
				end
			},
			border = {
				order = 11,
				name = "Border size",
				min = 0,
				max = 5,
				type = "range",
				step = 1,
				get = function() return settings.groups[name].border end,
				set = function(_, value)
					settings.groups[name].border = value
					FSCD:RebuildDisplay(name)
				end
			},
			width = {
				order = 12,
				name = "Bar width",
				min = 50,
				max = 200,
				type = "range",
				step = 1,
				get = function() return settings.groups[name].width end,
				set = function(_, value)
					settings.groups[name].width = value
					FSCD:RebuildDisplay(name)
				end
			},
			height = {
				order = 13,
				name = "Bar height",
				min = 10,
				max = 50,
				type = "range",
				step = 1,
				get = function() return settings.groups[name].height end,
				set = function(_, value)
					settings.groups[name].height = value
					FSCD:RebuildDisplay(name)
				end
			},
			spacing = {
				order = 14,
				name = "Spacing",
				min = 0,
				max = 50,
				type = "range",
				step = 1,
				get = function() return settings.groups[name].spacing end,
				set = function(_, value)
					settings.groups[name].spacing = value
					FSCD:RebuildDisplay(name)
				end
			},
			attach = {
				order = 15,
				name = "Attach - Grow",
				type = "select",
				values = {
					LEFTDOWN = "Left - Down",
					LEFTUP = "Left - Up",
					RIGHTDOWN = "Right - Down",
					RIGHTUP = "Right - Up",
				},
				get = function() return settings.groups[name].attach end,
				set = function(_, value)
					settings.groups[name].attach = value
					FSCD:RebuildDisplay(name)
				end
			},
			font_size = {
				order = 16,
				name = "Font size",
				min = 5,
				max = 30,
				type = "range",
				step = 1,
				get = function() return settings.groups[name].font_size end,
				set = function(_, value)
					settings.groups[name].font_size = value
					FSCD:RebuildDisplay(name)
				end
			},
			font = {
				order = 17,
				name = "Font",
				type = "select",
				dialogControl = "LSM30_Font",
				values = Media:HashTable("font"),
				get = function() return settings.groups[name].font end,
				set = function(_, value)
					settings.groups[name].font = value
					FSCD:RebuildDisplay(name)
				end
			},
			texture = {
				order = 18,
				name = "Texture",
				type = "select",
				width = "double",
				dialogControl = "LSM30_Statusbar",
				values = Media:HashTable("statusbar"),
				get = function() return settings.groups[name].texture end,
				set = function(_, value)
					settings.groups[name].texture = value
					FSCD:RebuildDisplay(name)
				end
			},
			void2 = {
				order = 20,
				name = "\n",
				type = "description"
			},
			missing = {
				order = 21,
				name = "Display missing cooldowns",
				type = "toggle",
				width = "full",
				get = function() return settings.groups[name].missing end,
				set = function(_, value)
					settings.groups[name].missing = value
					FSCD:RebuildDisplay(name)
				end
			},
			missingDesc = {
				order = 22,
				name = "Display cooldown icon even if nobody in the group can cast it\n",
				type = "description"
			},
			charges = {
				order = 23,
				name = "Display charges",
				type = "toggle",
				width = "full",
				get = function() return settings.groups[name].charges end,
				set = function(_, value)
					settings.groups[name].charges = value
					FSCD:RefreshAllCooldowns()
				end
			},
			chargesDesc = {
				order = 24,
				name = "Display charges count next to the player's name if more than one charge of the cooldown is available\n",
				type = "description"
			},
			limit = {
				order = 25,
				name = "Limit number of visible cooldowns",
				type = "toggle",
				width = "full",
				get = function() return settings.groups[name].limit end,
				set = function(_, value)
					settings.groups[name].limit = value
					FSCD:RebuildDisplay(name)
				end
			},
			limit_nb = {
				order = 26,
				name = "Limit",
				min = 1,
				max = 10,
				type = "range",
				step = 1,
				hidden = function() return not settings.groups[name].limit end,
				get = function() return settings.groups[name].limit_nb end,
				set = function(_, value)
					settings.groups[name].limit_nb = value
					FSCD:RebuildDisplay(name)
				end
			},
			limitDesc = {
				order = 27,
				name = "Limit the number of visible cooldowns at any one time, for each spell",
				type = "description"
			},
			voidx = {
				order = 100,
				name = "\n",
				type = "description"
			},
			--[[cooldowns = {
				order = 10,
				name = "Cooldowns",
				type = "header"
			},]]
		}
	}
	
	local last_order
	for _, id in ipairs(cooldowns_list) do
		if not cooldowns[id].special then
			local spell, _, icon = GetSpellInfo(id)
			local desc, icon_texture
			if spell then
				desc = GetSpellDescription(id) .. "\n|cff999999" .. id .. "|r"
				icon_texture = "|T" .. icon .. ":21|t"
			else
				spell = "Spell#" .. id
				icon_texture = ""
			end
			
			local cd_data = cooldowns[id]
			last_order = 1000 + cd_data.order * 10
			
			group.args["Spell" .. id] = {
				order = last_order,
				name = icon_texture .. " |cff" .. (cd_data.class and class_colors[cd_data.class][4] or "ffffff") .. spell .. "|h|r",
				desc = desc,
				type = "toggle",
				get = function()
					return settings.groups[name].cooldowns[id]
				end,
				set = function(_, enabled)
					settings.groups[name].cooldowns[id] = enabled and true or nil
					FSCD:RebuildDisplay(name)
				end
			}
		end
	end
	
	do
		local spell, _, icon = GetSpellInfo(187612)
		local icon_texture = "|T" .. icon .. ":21|t"
		group.args["LegendaryRings"] = {
			order = last_order + 1,
			name = icon_texture .. " |cffff8000Legendary rings|h|r",
			desc = "Tracks legendary rings usage and cooldown",
			type = "toggle",
			get = function()
				return settings.groups[name].cooldowns["legendary_rings"]
			end,
			set = function(_, enabled)
				settings.groups[name].cooldowns["legendary_rings"] = enabled and true or nil
				FSCD:RebuildDisplay(name)
			end
		}
	end
	
	config.args.groups.args[name] = group
	
	-- Create group anchor
	local anchor = CreateFrame("Frame", nil, UIParent)
	
	anchor:SetPoint(unpack(settings.groups[name].position))

	local backdrop = {
		bgFile = "Interface\\BUTTONS\\WHITE8X8",
		edgeFile = "",
		tile = false, tileSize = 0, edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	}

	anchor:SetBackdrop(backdrop)
	anchor:SetSize(80, 80)

	anchor:SetClampedToScreen(true)
	anchor:SetMovable(true)
	anchor:RegisterForDrag("LeftButton")
	anchor:SetScript("OnDragStart", anchor.StartMoving)
	anchor:SetScript("OnDragStop", function()
		anchor:StopMovingOrSizing()
		settings.groups[name].position = { anchor:GetPoint() }
	end)
	
	anchor:Show()
	displays[name] = anchor
	
	self:RebuildDisplay(name)
end

function FSCD:RemoveDisplayGroup(name, leave_config)
	config.args.groups.args[name] = nil
	if not leave_config then settings.groups[name] = nil end
	displays[name]:Hide()
	for id, icon in pairs(displays[name].icons) do
		for _, bar in ipairs(icon.bars) do
			bar:Hide()
		end
	end
	displays[name] = nil
end

function FSCD:PlayerHasCooldown(player, spell)
	if spell.special or (spell.class and player.class_id ~= spell.class) then
		return false
	end
	
	local function spec_match()
		if type(spell.spec) == "table" then
			for _, spec in pairs(spell.spec) do
				if spec == player.global_spec_id then
					return true
				end
			end
		elseif spell.spec == player.global_spec_id then
			return true
		end
		return false
	end
	
	if spell.spec and not spec_match() then
		return false
	end
	
	if spell.talent and not player.talents[spell.talent] then
		return false
	end
	
	return true
end

function FSCD:CreatePlayerCooldown(player, cooldown, id)
	local cd = {
		player = player,
		template = cooldown,
		id = id,
		used = 0,
		cast = 0,
		duration = 0,
		cooldown = 0
	}
	
	function cd:Evaluate(key, default)
		local value = cooldown[key]
		if value == nil then return default end
		if type(value) == "function" then return value(player) end
		return value
	end
	
	return cd
end

function FSCD:PlayerCooldowns(player)
	local player_cds = {}
	for id, cd in pairs(cooldowns) do
		if (self:PlayerHasCooldown(player, cd)) then
			player_cds[id] = self:CreatePlayerCooldown(player, cd, id)
		end
	end
	return player_cds
end

function FSCD:RebuildIndex()
	cooldowns_idx = {}
	for guid, rpl in pairs(roster) do
		for cd, data in pairs(rpl.cooldowns) do
			if not cooldowns_idx[cd] then cooldowns_idx[cd] = {} end
			table.insert(cooldowns_idx[cd], data)
		end
	end
	
	FSCD:RefreshAllCooldowns()
end

function FSCD:CreateCooldownIcon(anchor, id)
	local icon = CreateFrame("BUTTON", nil, anchor);
	icon:SetFrameStrata("BACKGROUND")
	icon:SetWidth(24)
	icon:SetHeight(24)
	icon:SetPoint("CENTER", 0, 0)
	
	local back = icon:CreateTexture(nil, "BACKGROUND")
	back:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	back:SetAllPoints()
	icon.back = back
	
	local tex = icon:CreateTexture(nil, "MEDIUM")
	tex:SetTexture(cooldowns[id].icon or select(3, GetSpellInfo(id)))
	tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon.tex = tex
	
	icon.cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
	
	local glowing = false
	function icon:SetGlow(glow)
		if glow and not glowing then
			glowing = true
			ActionButton_ShowOverlayGlow(icon);
		elseif not glow and glowing then
			glowing = false
			ActionButton_HideOverlayGlow(icon);
		end
	end
	
	function icon:SetCooldown(from, to)
		icon.cd:SetCooldown(from, to - from)
	end
	
	function icon:SetDesaturated(desaturated)
		if desaturated then
			icon.tex:SetDesaturated(1)
			icon.back:SetVertexColor(0.5, 0.5, 0.5, 1)
		else
			icon.tex:SetDesaturated()
			local r, g, b
			if cooldowns[id].color then
				r, g, b = unpack(cooldowns[id].color)
			else
				r, g, b = unpack(class_colors[cooldowns[id].class])
			end
			icon.back:SetVertexColor(r, g, b, 1)
		end
	end
	
	icon.bars = {}
	
	icon:EnableMouse(false)
	return icon
end

function FSCD:CreateCooldownBar(icon, group)
	local wrapper = CreateFrame("Frame", nil, icon)
	
	local backdrop = {
		bgFile = "Interface\\BUTTONS\\WHITE8X8",
		edgeFile = "",
		tile = false, tileSize = 0, edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	}

	wrapper:SetBackdrop(backdrop)
	wrapper:SetBackdropColor(0.12, 0.12, 0.12, 0.4)
	wrapper:SetFrameStrata("BACKGROUND")
	
	local bar = CreateFrame("StatusBar", nil, wrapper)
	bar:SetStatusBarTexture(Media:Fetch("statusbar", group.texture))
	--bar:SetPoint("TOPLEFT", wrapper, "TOPLEFT", 1, -1)
	--bar:SetPoint("BOTTOMRIGHT", wrapper, "BOTTOMRIGHT", -1, 1)
	bar:SetAllPoints(wrapper)
	wrapper.bar = bar
	
	local text = bar:CreateFontString()
	text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
	text:SetJustifyV("MIDDLE")
	text:SetJustifyH("LEFT")
	text:SetTextColor(1, 1, 1, 1)
	text:SetPoint("LEFT", wrapper, "LEFT", 2, 0)
	text:SetPoint("RIGHT", wrapper, "RIGHT", -35, 0)
	text:SetWordWrap(false)
	wrapper.text = text
	
	local time = bar:CreateFontString()
	time:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
	time:SetJustifyV("MIDDLE")
	time:SetJustifyH("RIGHT")
	time:SetTextColor(1, 1, 1, 1)
	time:SetPoint("LEFT", text, "RIGHT", 2, 0)
	time:SetPoint("RIGHT", wrapper, "RIGHT", 0, 0)
	wrapper.time = time
	
	function wrapper:SetData(data)
		wrapper.data = data
		self:Update()
	end
	
	local throttler = 0
	local function duration_updater(cast_start, duration_end, cd)
		return function()
			bar:SetValue(duration_end - GetTime() + cast_start)
			
			throttler = throttler + 1
			if throttler % 10 == 0 then
				local remaining = math.ceil(cd.duration - GetTime())
				local sec = remaining % 60
				local min = math.floor(remaining / 60)
				time:SetFormattedText("%d:%02d", min, sec)
			end
		end
	end
	
	local function cd_updater(cd)
		return function()
			bar:SetValue(GetTime())
			
			throttler = throttler + 1
			if throttler % 10 == 0 then
				local remaining = math.ceil(cd.cooldown - GetTime())
				local sec = remaining % 60
				local min = math.floor(remaining / 60)
				time:SetFormattedText("%d:%02d", min, sec)
			end
		end
	end
	
	function wrapper:Update()
		local cd = wrapper.data
		
		local r, g, b
		if cd.template.color then
			r, g, b = unpack(cd.template.color)
		else
			r, g, b = unpack(class_colors[cd.template.class])
		end
		
		local max_charges = cd:Evaluate("charges", 1)
		
		if max_charges > 1 and group.charges then
			local charges_avail = max_charges - cd.used
			text:SetText(charges_avail .. " - " .. cd.player.name)
		else
			text:SetText(cd.player.name)
		end
		
		local color_ratio = 0.8
		local animating = false
		local animate_duration = false
		wrapper:SetAlpha(1.0)
		
		if cd.duration > GetTime() then
			color_ratio = 2
			animating = true
			animate_duration = true
		elseif not players_available[cd.player.name] and not cd.template.special then
			color_ratio = 0.2
			wrapper:SetAlpha(0.4)
		elseif cd.cooldown > GetTime() then
			if cd.used >= cd:Evaluate("charges", 1) then
				color_ratio = 0
			end
			animating = true
		end
		
		local function blend(color) return color * color_ratio + 0.3 * (1 - color_ratio) end
		bar:SetStatusBarColor(blend(r), blend(g), blend(b), 1)
		
		if animating then
			throttler = 0
			bar:SetMinMaxValues(cd.cast, animate_duration and cd.duration or cd.cooldown)
			if animate_duration then
				wrapper:SetScript("OnUpdate", duration_updater(cd.cast, cd.duration, cd))
			else
				wrapper:SetScript("OnUpdate", cd_updater(cd))
			end
		else
			wrapper:SetScript("OnUpdate", nil)
			bar:SetMinMaxValues(0, 1)
			bar:SetValue(1)
			time:SetText("")
		end
	end
	
	return wrapper
end

function FSCD:RebuildDisplay(name)
	local anchor = displays[name]
	local group = settings.groups[name]
	
	if not anchor.icons then
		anchor.icons = {}
	end
	
	if group.unlocked then
		anchor:SetBackdropColor(0.39, 0.71, 1.00, 0.3)
		anchor:EnableMouse(true)
	else
		anchor:SetBackdropColor(0, 0, 0, 0)
		anchor:EnableMouse(false)
	end
	
	for id, icon in pairs(anchor.icons) do
		icon:Hide()
		icon.visible = false
		for i, bar in ipairs(icon.bars) do
			bar:Hide()
		end
	end
	
	local last_icon
	for _, id in ipairs(cooldowns_list) do
		if group.cooldowns[id] and (group.missing or cooldowns_idx[id]) then
			if not anchor.icons[id] then
				anchor.icons[id] = self:CreateCooldownIcon(anchor, id)
			end
			
			local icon = anchor.icons[id]
			icon:ClearAllPoints()
			
			icon:SetSize(group.size, group.size)
			icon.tex:SetPoint("TOPLEFT", icon, "TOPLEFT", group.border, -group.border)
			icon.tex:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -group.border, group.border)
			icon.cd:SetPoint("TOPLEFT", icon, "TOPLEFT", group.border, -group.border)
			icon.cd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -group.border, group.border)
			
			if last_icon then
				local bars_height = (last_icon.bars_count * (group.height + 2)) - 2
				local overflow = (bars_height > group.size) and bars_height - group.size or 0
				
				if group.attach == "LEFTUP" or group.attach == "RIGHTUP" then
					icon:SetPoint("BOTTOMLEFT", last_icon, "TOPLEFT", 0, group.spacing + overflow)
				else
					icon:SetPoint("TOPLEFT", last_icon, "BOTTOMLEFT", 0, -(group.spacing + overflow))
				end
			else
				local attach_to = {
					LEFTDOWN = "TOPLEFT",
					LEFTUP = "BOTTOMLEFT",
					RIGHTDOWN = "TOPRIGHT",
					RIGHTUP = "BOTTOMRIGHT"
				}
				icon:SetPoint(attach_to[group.attach], anchor, attach_to[group.attach], 0, 0)
			end
			
			icon.visible = true
			icon:Show()
			
			local available = false
			
			icon.bars_count = 0
			local last_bar
			if cooldowns_idx[id] then
				for i, data in ipairs(cooldowns_idx[id]) do
					if not icon.bars[i] then
						icon.bars[i] = FSCD:CreateCooldownBar(icon, group)
					end
					
					local bar = icon.bars[i]
					bar:SetWidth(group.width)
					bar:SetHeight(group.height)
					
					bar:ClearAllPoints()
					if not last_bar then
						if group.attach == "RIGHTUP" then
							bar:SetPoint("BOTTOMRIGHT", icon, "BOTTOMLEFT", -math.min(5, group.spacing), 0)
						elseif group.attach == "RIGHTDOWN" then
							bar:SetPoint("TOPRIGHT", icon, "TOPLEFT", -math.min(5, group.spacing), 0)
						elseif group.attach == "LEFTUP" then
							bar:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", math.min(5, group.spacing), 0)
						else
							bar:SetPoint("TOPLEFT", icon, "TOPRIGHT", math.min(5, group.spacing), 0)
						end
					else
						if group.attach == "LEFTUP" or group.attach == "RIGHTUP" then
							bar:SetPoint("BOTTOMLEFT", last_bar, "TOPLEFT", 0, 2)
						else
							bar:SetPoint("TOPLEFT", last_bar, "BOTTOMLEFT", 0, -2)
						end
					end
					
					bar.bar:SetStatusBarTexture(Media:Fetch("statusbar", group.texture))
					bar.text:SetFont(Media:Fetch("font", group.font), group.font_size, "OUTLINE")
					bar.time:SetFont(Media:Fetch("font", group.font), group.font_size, "OUTLINE")
					bar:Show()
					bar:SetData(data)
					
					available = true
					icon.bars_count = icon.bars_count + 1
					
					last_bar = bar
					
					if group.limit and icon.bars_count == group.limit_nb then
						break
					end
				end
			end
			
			if available then
				icon:SetAlpha(1)
				icon:SetDesaturated(false)
			else
				icon:SetAlpha(0.5)
				icon:SetDesaturated(true)
			end
			
			last_icon = icon
		end
	end
end

function FSCD:RebuildAllDisplays()
	for name in pairs(displays) do
		self:RebuildDisplay(name)
	end
	FSCD:RefreshAllCooldowns()
end

--------------------------------------------------------------------------------

local function sortCooldowns(a, b)
	if a.player.order and b.player.order then
		return a.player.order < b.player.order
	end

	local now = GetTime()
	local aActive, bActive = now < a.duration, now < b.duration
	
	if aActive ~= bActive then
		return aActive
	else
		if aActive then
			return a.duration < b.duration
		else
			local paAvail = players_available[a.player.name]
			local pbAvail = players_available[b.player.name]
			
			if paAvail ~= pbAvail then
				return paAvail
			else
				local aMax, bMax = a:Evaluate("charges", 1), b:Evaluate("charges", 1)
				local aAvail = a.used < aMax
				local bAvail = b.used < bMax
				
				if aAvail ~= bAvail then
					return aAvail
				else
					if aAvail then
						if a.used ~= b.used then
							return a.used < b.used
						else
							return aMax > bMax
						end
					else
						return a.cooldown < b.cooldown
					end
				end
			end
		end
	end
end

function FSCD:RefreshCooldown(id)
	if not cooldowns_idx[id] then return end
	table.sort(cooldowns_idx[id], sortCooldowns)
	local now = GetTime()
			
	for _, display in pairs(displays) do
		local icon = display.icons[id]
		if icon and icon.visible then
			local one_available = false
			local glow = false
			
			for i, data in ipairs(cooldowns_idx[id]) do
				local bar = icon.bars[i]
				if bar then
					bar:SetData(data)
					if data.duration > now then
						glow = true
					end
					
					if data.used < data:Evaluate("charges", 1) then
						one_available = true
					end
				end
			end
			
			icon:SetGlow(glow)
			
			if one_available or glow then
				icon:SetDesaturated(false)
				icon:SetCooldown(0, 0)
			else
				icon:SetDesaturated(true)
				icon:SetCooldown(cooldowns_idx[id][1].cast, cooldowns_idx[id][1].cooldown)
			end
		end
	end
end

function FSCD:RefreshAllCooldowns()
	for id in pairs(cooldowns_idx) do
		self:RefreshCooldown(id)
	end
end

--------------------------------------------------------------------------------

function FSCD:RosterUpdate(_, guid, _, player)
	local rpl = roster[guid] or {}
	local cds = self:PlayerCooldowns(player)
	
	if rpl.cooldowns then
		for id, cd in pairs(rpl.cooldowns) do
			if cds[id] then
				cd.player = player
				cds[id] = cd
			end
		end
	end
	
	rpl.cooldowns = cds
	rpl.player = player
	roster[guid] = rpl
	
	if not player.name then
		player.name = player.lku
	end
	
	players_available[player.name] = true
	
	self:RebuildIndex()
	self:RebuildAllDisplays()
end

function FSCD:RosterRemove(_, guid)
	roster[guid] = nil
	self:RebuildIndex()
	self:RebuildAllDisplays()
end

--------------------------------------------------------------------------------

local function modCharges(cd, delta)
	cd.used = cd.used + delta
	
	local max_charges = cd:Evaluate("charges", 1)
	if cd.used > max_charges then cd.used = max_charges end
	if cd.used < 0 then cd.used = 0 end
end

local function handleCharge(cd)
	return function()
		modCharges(cd, -1)
		cd.timer = nil
		FSCD:RefreshCooldown(cd.id)
		if cd.used > 0 then
			cd.cooldown = GetTime() + cd:Evaluate("cooldown", 15)
			cd.timer = C_Timer.NewTimer(cd.cooldown - GetTime(), handleCharge(cd))
		end
	end
end

local castDebounce = {}
local legendary_rings_ids = {
	[187611] = "Hallows", -- Nithramus
	[187612] = "Etheralus",
	[187613] = "Sanctus",
	[187614] = "Hallows", -- Thorasus
	[187615] = "Hallows", -- Maalus
}

local function spellCasted(source, dest, id, broadcast)
	local ring_name = legendary_rings_ids[id] or false
	local instances = cooldowns_idx[ring_name and "legendary_rings" or id]
	
	if instances then
		local now = GetTime()
		local debounce_key = source .. ":" .. dest .. ":" .. id
		if castDebounce[debounce_key] and (now - castDebounce[debounce_key]) < 0.75 then
			return
		else
			castDebounce[debounce_key] = now
		end
			
		for _, cd in ipairs(instances) do
			if cd.player.guid == source or cd.player.guid == ring_name then
				local now = GetTime()
				
				local caster_name
				if ring_name then
					caster_name = select(6, GetPlayerInfoByGUID(source))
					cd.player.name = caster_name
				end
				
				modCharges(cd, 1)
				cd.cast = now
				cd.duration = now + cd:Evaluate("duration", 1.5)
				
				if cd.used == 1 then
					cd.cooldown = now + cd:Evaluate("cooldown", 15)
					if cd.timer then cd.timer:Cancel() end
					cd.timer = C_Timer.NewTimer(cd.cooldown - now, handleCharge(cd))
				end
				
				FSCD:RefreshCooldown(cd.id)
				
				C_Timer.After(cd.duration - now, function()
					FSCD:RefreshCooldown(cd.id)
				end)
				
				if ring_name then
					C_Timer.After(cd.cooldown - now, function()
						if cd.player.name == caster_name then
							cd.player.name = cd.player.ring_name
						end
						FSCD:RefreshCooldown(cd.id)
					end)
				end
				
				if broadcast then
					broadcast:SendCommMessage("FSCD", debounce_key, "RAID")
				end
				return
			end
		end
	end
end

function FSCD:OnCommReceived(chan, data)
	if chan ~= "FSCD" then return end
	local source, dest, id = data:match("(.*):(.*):(.*)")
	if not id then return end
	spellCasted(source, dest, id)
end

local PLAYER_GUID = UnitGUID("player")
function FSCD:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, source, _, _, _, dest, _, _, _, id)
if event == "SPELL_CAST_SUCCESS" then
		spellCasted(source, dest, id, self)
	end
end

function FSCD:ENCOUNTER_END()
	wipe(castDebounce)
	for id, instances in pairs(cooldowns_idx) do
		if cooldowns[id].reset_on_wipe or cooldowns[id].cooldown >= 180 then
			for i, cd in ipairs(instances) do
				cd.used = 0
				cd.cast = 0
				cd.duration = 0
				cd.cooldown = 0
			end
			self:RefreshCooldown(id)
		end
	end
end
