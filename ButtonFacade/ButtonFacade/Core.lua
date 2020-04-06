--[[
	Project.: ButtonFacade
	File....: Core.lua
	Version.: 328
	Author..: StormFX, JJ Sheets
]]

-- [ Private Table ] --

local AddOn, ns = ...

-- [ Set Up ] --

local LibStub = LibStub
local LBF = LibStub("LibButtonFacade", true)
if not LBF then return end
local BF = LibStub("AceAddon-3.0"):NewAddon(AddOn, "AceConsole-3.0")

-- [ Locals ] --

local L, pairs = ns.L, pairs

-- [ Core Options ] --

BF.Options = {
	type = "group",
	name = AddOn,
	args = {
		General = {
			type = "group",
			name = AddOn,
			order = 1,
			args = {
				Info = {
					type = "description",
					name = L["BF_INFO"].."\n",
					order = 1,
				},
			},
		},
		Addons = {
			type = "group",
			name = L["AddOns"],
			order = 2,
			args = {
				Info = {
					type = "description",
					name = L["ADDON_INFO"].."\n",
					order = 1,
				},
			},
		},
	},
}

-- [ Core Methods ] --

-- Initialize function.
function BF:OnInitialize()
	-- Set up saved variables.
	local defaults = {
		profile = {
			SkinID = "Blizzard",
			Gloss = false,
			Backdrop = false,
			Colors = {},
		},
	}
	self.db = LibStub("AceDB-3.0"):New("ButtonFacadeDB", defaults, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
	self.Options.args.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.Options.args.Profiles.order = 100
end

-- Enable function.
function BF:OnEnable()
	LBF:RegisterSkinCallback(AddOn, self.SkinCallback, self)
	LBF:Group():Skin(self.db.profile.SkinID, self.db.profile.Gloss, self.db.profile.Backdrop, self.db.profile.Colors)
	LBF:RegisterGuiCallback(self.GuiUpdate, self)
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(AddOn, self.Options)
	local ACD = LibStub("AceConfigDialog-3.0")
	self.OptionsPanel = ACD:AddToBlizOptions(AddOn, AddOn, nil, "General")
	self.OptionsPanel.Addons = ACD:AddToBlizOptions(AddOn, L["AddOns"], AddOn, "Addons")
	self.OptionsPanel.Profiles = ACD:AddToBlizOptions(AddOn, L["Profiles"], AddOn, "Profiles")
	self:RegisterChatCommand("bf", function() self:OpenOptions() end)
	self:RegisterChatCommand("buttonfacade", function() self:OpenOptions() end)
end

-- Reloads settings on profile activity.
function BF:Refresh()
	LBF:Group():SetSkin(self.db.profile.SkinID, self.db.profile.Gloss, self.db.profile.Backdrop, self.db.profile.Colors)
end

-- Callback function to store settings.
function BF:SkinCallback(SkinID, Gloss, Backdrop, Group, Button, Colors)
	if not Group then
		self.db.profile.SkinID = SkinID
		self.db.profile.Gloss = Gloss
		self.db.profile.Backdrop = Backdrop
		self.db.profile.Colors = Colors
	end
end

-- Opens the options window.
function BF:OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(self.OptionsPanel.Profiles)
	InterfaceOptionsFrame_OpenToCategory(self.OptionsPanel)
end

-- [ Skin Options ] --

do
	-- Gets the skin.
	local function GetSkin(info)
		return info.arg.SkinID
	end
	-- Sets the skin.
	local function SetSkin(info, value)
		local LBFGroup = info.arg
		LBFGroup:Skin(value, LBFGroup.Gloss, LBFGroup.Backdrop)
	end
	-- Gets the gloss.
	local function GetGloss(info)
		return info.arg[1].Gloss or 0
	end
	-- Sets the gloss.
	local function SetGloss(info, value)
		local LBFGroup = info.arg[1]
		LBFGroup:Skin(LBFGroup.SkinID, value, LBFGroup.Backdrop)
	end
	-- Gets the backdrop.
	local function GetBackdrop(info)
		return info.arg[1].Backdrop
	end
	-- Sets the backdrop.
	local function SetBackdrop(info, value)
		local LBFGroup = info.arg[1]
		LBFGroup:Skin(LBFGroup.SkinID, LBFGroup.Gloss, value and true or false)
	end
	-- Gets a layer's color.
	local function GetLayerColor(info)
		local LBFGroup, layer = info.arg[1], info.arg[2]
		return LBFGroup:GetLayerColor(layer)
	end
	-- Sets a layer's color.
	local function SetLayerColor(info, r, g, b, a)
		local LBFGroup, layer = info.arg[1], info.arg[2]
		LBFGroup:SetLayerColor(layer, r, g, b, a)
	end
	-- Gets a border's color.
	local function GetBorderColor(info)
		local LBFGroup, type = info.arg[1], info.arg[2]
		return LBFGroup:GetBorderColor(type)
	end
	-- Sets a border's color.
	local function SetBorderColor(info, r, g, b, a)
		local LBFGroup, type = info.arg[1], info.arg[2]
		LBFGroup:SetBorderColor(type, r, g, b, a)
	end
	-- Resets all colors.
	local function ResetAllColors(info)
		info.arg:ResetColors()
	end
	-- Gets the hidden state of a layer.
	local function GetState(info)
		local LBFGroup, layer = info.arg[1], info.arg[2]
		local list = LBF:GetSkins()
		return list[LBFGroup.SkinID][layer].Hide
	end
	local function GetBackdropState(info)
		return not info.arg[1].Backdrop
	end
	local function CreateOptions(addon, group, button)
		local LBFGroup = LBF:Group(addon, group, button)
		local name, info
		if button then
			name = button
			info = L["Apply skin to all buttons registered with %s: %s/%s."]:format(addon, group, button)
		elseif group then
			name = group
			info = L["Apply skin to all buttons registered with %s: %s."]:format(addon, group)
		elseif addon then
			name = addon
			info = L["Apply skin to all buttons registered with %s."]:format(addon)
		else
			name = L["Global Settings"]
			info = L["GLOBAL_INFO"]
		end
		return {
			type = "group",
			name = name,
			args = {
				Info = {
					type = "description",
					name = info.."\n",
					order = 1,
				},
				Skin = {
					type = "select",
					name = L["Skin"],
					desc = L["Set the skin."],
					get = GetSkin,
					set = SetSkin,
					arg = LBFGroup,
					style = "dropdown",
					width = "full",
					values = LBF.ListSkins,
					order = 2,
				},
				Spacer = {
					type = "description",
					name = " ",
					order = 3,
				},
				Gloss = {
					type = "group",
					name = L["Gloss Settings"],
					order = 4,
					inline = true,
					args = {
						Color = {
							type = "color",
							name = L["Color"],
							desc = L["Set the color of the gloss texture."],
							get = GetLayerColor,
							set = SetLayerColor,
							arg = {LBFGroup, "Gloss"},
							disabled = GetState,
							order = 1,
						},
						Opacity = {
							type = "range",
							name = L["Opacity"],
							desc = L["Set the intensity of the gloss."],
							get = GetGloss,
							set = SetGloss,
							arg = {LBFGroup, "Gloss"},
							min = 0,
							max = 1,
							step = 0.01,
							isPercent = true,
							disabled = GetState,
							order = 2,
						},
					},
				},
				Backdrop = {
					type = "group",
					name = L["Backdrop Settings"],
					order = 5,
					inline = true,
					args = {
						Color = {
							type = "color",
							name = L["Color"],
							desc = L["Set the backdrop color."],
							get = GetLayerColor,
							set = SetLayerColor,
							arg = {LBFGroup, "Backdrop"},
							hasAlpha = true,
							disabled = GetBackdropState,
							order = 1,
						},
						Enable = {
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable the backdrop."],
							get = GetBackdrop,
							set = SetBackdrop,
							arg = {LBFGroup, "Backdrop"},
							--width = "half",
							disabled = GetState,
							order = 1,
						},
					},
				},
				States = {
					type = "group",
					name = L["State Colors"],
					order = 6,
					inline = true,
					args = {
						Normal = {
							type = "color",
							name = L["Normal"],
							desc = L["Set the color of the normal texture."],
							get = GetLayerColor,
							set = SetLayerColor,
							arg = {LBFGroup, "Normal"},
							hasAlpha = true,
							disabled = GetState,
							order = 1,
						},
						Highlight = {
							type = "color",
							name = L["Highlight"],
							desc = L["Set the color of the highlight texture."],
							get = GetLayerColor,
							set = SetLayerColor,
							arg = {LBFGroup, "Highlight"},
							hasAlpha = true,
							disabled = GetState,
							order = 2,
						},
						Checked = {
							type = "color",
							name = L["Checked"],
							desc = L["Set the color of the checked texture."],
							get = GetLayerColor,
							set = SetLayerColor,
							arg = {LBFGroup, "Checked"},
							hasAlpha = true,
							disabled = GetState,
							order = 3,
						},
						Flash = {
							type = "color",
							name = L["Flash"],
							desc = L["Set the color of the flash texture."],
							get = GetLayerColor,
							set = SetLayerColor,
							arg = {LBFGroup, "Flash"},
							hasAlpha = true,
							disabled = GetState,
							order = 4,
						},
						Pushed = {
							type = "color",
							name = L["Pushed"],
							desc = L["Set the color of the pushed texture."],
							get = GetLayerColor,
							set = SetLayerColor,
							arg = {LBFGroup, "Pushed"},
							hasAlpha = true,
							disabled = GetState,
							order = 5,
						},
						Disabled = {
							type = "color",
							name = L["Disabled"],
							desc = L["Set the color of the disabled texture."],
							get = GetLayerColor,
							set = SetLayerColor,
							arg = {LBFGroup, "Disabled"},
							hasAlpha = true,
							disabled = GetState,
							order = 6,
						},
					},
				},
				Borders = {
					type = "group",
					name = L["Border Colors"],
					order = 7,
					inline = true,
					hidden = function() return not LBFGroup.Borders end,
					args = {
						None = {
							type = "color",
							name = L["Debuff"],
							desc = L["Set the border color for debuffs that cannot be removed."],
							get = GetBorderColor,
							set = SetBorderColor,
							arg = {LBFGroup, "None"},
							hasAlpha = true,
							order = 1,
						},
						Curse = {
							type = "color",
							name = L["Curse"],
							desc = L["Set the border color for curses."],
							get = GetBorderColor,
							set = SetBorderColor,
							arg = {LBFGroup, "Curse"},
							hasAlpha = true,
							order = 2,
						},
						Disease = {
							type = "color",
							name = L["Disease"],
							desc = L["Set the border color for diseases."],
							get = GetBorderColor,
							set = SetBorderColor,
							arg = {LBFGroup, "Disease"},
							hasAlpha = true,
							order = 3,
						},
						Magic = {
							type = "color",
							name = L["Magic"],
							desc = L["Set the border color for magic."],
							get = GetBorderColor,
							set = SetBorderColor,
							arg = {LBFGroup, "Magic"},
							hasAlpha = true,
							order = 4,
						},
						Poison = {
							type = "color",
							name = L["Poison"],
							desc = L["Set the border color for poisons."],
							get = GetBorderColor,
							set = SetBorderColor,
							arg = {LBFGroup, "Poison"},
							hasAlpha = true,
							order = 5,
						},
						Action = {
							type = "color",
							name = L["Equipped"],
							desc = L["Set the border color for equipped items."],
							get = GetBorderColor,
							set = SetBorderColor,
							arg = {LBFGroup, "Action"},
							hasAlpha = true,
							order = 6,
						},
						Enchant = {
							type = "color",
							name = L["Enchant"],
							desc = L["Set the border color for weapon enchants."],
							get = GetBorderColor,
							set = SetBorderColor,
							arg = {LBFGroup, "Enchant"},
							hasAlpha = true,
							order = 7,
						},
						Special = {
							type = "color",
							name = L["Custom"],
							desc = L["Set the border color for custom types."],
							get = GetBorderColor,
							set = SetBorderColor,
							arg = {LBFGroup, "Custom"},
							hasAlpha = true,
							order = 8,
						},
					},
				},
				ResetAll = {
					type = "execute",
					name = L["Reset All Colors"],
					desc = L["Reset all colors to their defaults."],
					func = ResetAllColors,
					arg = LBFGroup,
					width = "full",
					order = 15,
				},
			},
		}
	end
	BF.Options.args.General.args.Global = CreateOptions()
	BF.Options.args.General.args.Global.inline = true
	local args = BF.Options.args.Addons.args
	function BF:GuiUpdate(addon, group)
		if not addon then
			for _, addon in pairs(LBF:ListAddons()) do
				local cAddon = addon:gsub("%s","_")
				args[cAddon] = args[cAddon] or CreateOptions(addon)
			end
		elseif not group then
			local cAddon = addon:gsub("%s","_")
			for _, group in pairs(LBF:ListGroups(addon)) do
				local cGroup = group:gsub("%s","_")
				local addonArgs = args[cAddon].args
				addonArgs[cGroup] = addonArgs[cGroup] or CreateOptions(addon, group)
			end
		else
			local cAddon = addon:gsub("%s","_")
			local cGroup = group:gsub("%s","_")
			for _, button in pairs(LBF:ListButtons(addon, group)) do
				local cButton = button:gsub("%s","_")
				local groupArgs = args[cAddon].args[cGroup].args
				groupArgs[cButton] = groupArgs[cButton] or CreateOptions(addon, group, button)
			end
		end
	end
end
